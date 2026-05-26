from flask import Flask, render_template, request, redirect, session, flash
import joblib
import re
import threading
import webbrowser
import psycopg2
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from io import BytesIO
import base64
import time


def get_db_connection():
    conn = psycopg2.connect(
        database="emotion_focus_db",
        user="postgres",
        password="123",
        host="localhost",
        port="5432"
    )
    return conn


app = Flask(__name__)
app.secret_key = "emotion_project_key"

model = joblib.load("emotion_pipeline.pkl")


# -------------------------------
# Clean text
# -------------------------------
def clean_text(text):
    text = str(text).lower()
    text = re.sub(r"[^a-z\s]", "", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text


# -------------------------------
# Negation handling
# -------------------------------
def handle_negation(original_text, predicted_emotion):

    words = original_text.lower().split()

    negative_words = ["sad", "bad", "angry", "upset", "depressed", "tired"]
    positive_words = ["happy", "good", "great", "excited", "motivated"]

    for i in range(len(words) - 1):
        if words[i] == "not":
            if words[i + 1] in negative_words:
                return "Positive"
            if words[i + 1] in positive_words:
                return "Negative"

    return predicted_emotion


# -------------------------------
# Suggestion logic
# -------------------------------
def get_suggestion(emotion):

    if emotion == "Positive":
        return "🔥 Great mood! Start a focused 25-minute deep study session."

    elif emotion == "Negative":
        return "⚡ Start with a small 5-minute task to build momentum."

    else:
        return "🎯 You seem neutral. Plan your study session and begin calmly."


# -------------------------------
# REGISTER
# -------------------------------
@app.route("/register", methods=["GET", "POST"])
def register():

    if request.method == "POST":

        username = request.form["username"]
        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute(
            "SELECT * FROM users WHERE username=%s OR email=%s",
            (username, email)
        )

        user = cur.fetchone()

        if user:
            cur.close()
            conn.close()
            flash("Username or Email already registered")
            return redirect("/login")

        cur.execute(
            "INSERT INTO users (username,email,password) VALUES (%s,%s,%s)",
            (username, email, password)
        )

        conn.commit()
        cur.close()
        conn.close()

        flash("Registration successful. Please Login")
        return redirect("/login")

    return render_template("register.html")


# -------------------------------
# LOGIN
# -------------------------------
@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute(
            "SELECT reg_id, username, password FROM users WHERE email=%s",
            (email,)
        )

        user = cur.fetchone()

        if not user:
            flash("No account with this email")
            return redirect("/register")

        if user[2] != password:
            flash("Wrong password")
            return redirect("/login")

        session["user"] = user[1]
        session["reg_id"] = user[0]

        cur.close()
        conn.close()

        return redirect("/")

    return render_template("login.html")


# -------------------------------
# HOME
# -------------------------------
@app.route("/", methods=["GET", "POST"])
def home():

    if "user" not in session:
        return redirect("/login")

    emotion = None
    solution = None
    steps = []
    show_steps = False
    user_input = ""

    if request.method == "POST":

        action = request.form.get("action")
        user_input = request.form.get("mood", "").strip()

        # -------------------------------
        # EMOTION PREDICTION
        # -------------------------------
        if user_input:
            cleaned = clean_text(user_input)
            prediction = model.predict([cleaned])[0]
            final_emotion = handle_negation(user_input, prediction)

            emotion = final_emotion
            solution = get_suggestion(final_emotion)

            # store last emotion for steps button
            session["last_emotion"] = emotion

            # -------------------------------
            # DATABASE LOGIC (YOUR LOGIC ✅)
            # -------------------------------
            conn = get_db_connection()
            cur = conn.cursor()

            # Get FIRST entry of today
            cur.execute("""
                SELECT created_at
                FROM emotions
                WHERE reg_id = %s
                AND DATE(created_at) = CURRENT_DATE
                ORDER BY created_at ASC
                LIMIT 1
            """, (session["reg_id"],))

            first_entry = cur.fetchone()

            if first_entry:
                # SAME created_at, update time
                cur.execute("""
                    INSERT INTO emotions (reg_id, emotion, created_at, updated_at)
                    VALUES (%s, %s, %s, CURRENT_TIMESTAMP)
                """, (session["reg_id"], emotion, first_entry[0]))
            else:
                # First entry today
                cur.execute("""
                    INSERT INTO emotions (reg_id, emotion, created_at)
                    VALUES (%s, %s, CURRENT_TIMESTAMP)
                """, (session["reg_id"], emotion))

            conn.commit()
            cur.close()
            conn.close()

        # -------------------------------
        # SHOW STEPS BUTTON
        # -------------------------------
        if action == "Show Detailed Steps":

            show_steps = True
            emotion = session.get("last_emotion")

            if emotion == "Positive":
                steps = [
                    "🎯 Pick ONE high-priority topic",
                    "⏱ Set a 25-minute timer",
                    "📵 Remove distractions",
                    "🧠 Start hardest task first",
                    "✍️ Take notes actively",
                    "🔁 5-min break after session",
                    "🚀 Repeat 2–3 cycles",
                    "💡 Rule: Don’t waste a good mood"
                ]

            elif emotion == "Negative":
                steps = [
                    "🧩 Start very small task",
                    "⏱ Set 5-minute timer",
                    "📖 Just begin (no pressure)",
                    "✔️ Continue if possible",
                    "📵 Remove distractions",
                    "💡 Switch if stuck",
                    "🏁 Reward yourself",
                    "💡 Rule: Just start"
                ]

            else:
                steps = [
                    "📝 Set 2–3 goals",
                    "📚 Start medium topic",
                    "⏱ Study 20 minutes",
                    "✍️ Summarize learning",
                    "🔄 Take break",
                    "📈 Track progress",
                    "🔁 Continue cycle",
                    "💡 Rule: Consistency wins"
                ]

    return render_template(
        "index.html",
        emotion=emotion,
        solution=solution,
        steps=steps,
        show_steps=show_steps,
        user_input=user_input
    )
# -------------------------------
# Daily Analysis graph
# -------------------------------
@app.route("/daily_analysis")
def daily_analysis():

    if "user" not in session:
        return redirect("/login")

    conn = get_db_connection()

    query = """
SELECT date, emotion, COUNT(*) as count
FROM (
    SELECT reg_id,
           DATE(created_at) as date,
           emotion,
           ROW_NUMBER() OVER (
               PARTITION BY reg_id, DATE(created_at)
               ORDER BY 
                   CASE 
                       WHEN updated_at IS NOT NULL THEN updated_at 
                       ELSE created_at 
                   END DESC,
                   id DESC
           ) as rn
    FROM emotions
) t
WHERE rn = 1
AND date >= CURRENT_DATE - INTERVAL '10 days'
GROUP BY date, emotion
ORDER BY date;
"""

    df = pd.read_sql(query, conn)
    conn.close()

    if df.empty:
        return "No emotion data available."

    print(df.to_string(index=False), flush=True)

    pivot = df.pivot(index="date", columns="emotion", values="count").fillna(0)
    pivot = pivot.reindex(columns=["Positive", "Negative", "Neutral"], fill_value=0)

    pivot.index = pd.to_datetime(pivot.index).strftime('%d-%b')

    fig, ax = plt.subplots(figsize=(8, 6))
    pivot.plot(kind="bar", stacked=True, ax=ax)

    ax.set_title("Last 10 Days Emotion Analysis")
    ax.set_xlabel("Date")
    ax.set_ylabel("Emotion Count")

    plt.xticks(rotation=45)
    plt.tight_layout()

    img = BytesIO()
    plt.savefig(img, format="png")
    img.seek(0)

    graph_url = base64.b64encode(img.getvalue()).decode()
    plt.close('all')

    return render_template("daily_analysis.html", graph=graph_url, t=time.time())

# -------------------------------
# Emotion Trend Graph (NEW)
# -------------------------------
@app.route("/trend_analysis")
def trend_analysis():

    if "user" not in session:
        return redirect("/login")

    conn = get_db_connection()

    query = """
    SELECT date, emotion
    FROM (
        SELECT reg_id,
               DATE(created_at) as date,
               emotion,
               ROW_NUMBER() OVER (
                   PARTITION BY reg_id, DATE(created_at)
                   ORDER BY 
                       CASE 
                           WHEN updated_at IS NOT NULL THEN updated_at 
                           ELSE created_at 
                       END DESC,
                       id DESC
               ) as rn
        FROM emotions
        WHERE reg_id = %s
    ) t
    WHERE rn = 1
    ORDER BY date;
    """

    df = pd.read_sql(query, conn, params=(session["reg_id"],))
    conn.close()

    if df.empty:
        return "No data available."

    # Convert emotion to score
    mapping = {"Positive": 1, "Neutral": 0, "Negative": -1}
    df["score"] = df["emotion"].map(mapping)

   	# Sort by date
    df = df.sort_values("date")

    # Moving average (trend)
    df["trend"] = df["score"].rolling(window=3).mean()

    # Convert date to string (IMPORTANT FIX)
    df["date"] = pd.to_datetime(df["date"]).dt.strftime('%d-%b')

    # Plot line graph
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.plot(df["date"], df["trend"], marker='o')

    ax.set_title("Emotion Improvement Trend")
    ax.set_xlabel("Date")
    ax.set_ylabel("Trend Score")

    plt.xticks(rotation=45)
    plt.tight_layout()

    # Convert to image
    img = BytesIO()
    plt.savefig(img, format="png")
    img.seek(0)

    graph_url = base64.b64encode(img.getvalue()).decode()
    plt.close('all')

    return render_template("trend_analysis.html", graph=graph_url, t=time.time())


# -------------------------------
# LOGOUT
# -------------------------------
@app.route("/logout")
def logout():
    session.clear()
    return redirect("/login")


# -------------------------------
# AUTO OPEN BROWSER
# -------------------------------
def open_browser():
    webbrowser.open("http://127.0.0.1:5000/login")


if __name__ == "__main__":
    threading.Timer(1, open_browser).start()
    app.run(host="127.0.0.1", port=5000, debug=False)

