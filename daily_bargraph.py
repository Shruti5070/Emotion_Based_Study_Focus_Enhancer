import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

# connect database
conn = psycopg2.connect(
    database="emotion_focus_db",
    user="postgres",
    password="123",
    host="localhost",
    port="5432"
)

query = """
SELECT 
DATE(created_at) AS date,
emotion,
COUNT(*) AS count
FROM emotions
GROUP BY DATE(created_at), emotion
ORDER BY date;
"""

df = pd.read_sql(query, conn)

# reshape data
pivot = df.pivot(index="date", columns="emotion", values="count").fillna(0)

# plot
pivot.plot(kind="bar", stacked=True)

plt.title("Daily Emotion Distribution")
plt.xlabel("Date")
plt.ylabel("Number of Users")
plt.xticks(rotation=45)

plt.show()
