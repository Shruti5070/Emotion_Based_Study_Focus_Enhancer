# Emotion Based Focus Enhancer System

## Overview
The Emotion Based Focus Enhancer System is a web application that analyzes user input text and detects emotion as **positive, negative, or neutral** using a machine learning model. Based on the detected emotion, it provides **suggestions and steps** to improve focus and study performance.

## Features
- User registration and login
- Emotion detection from text input
- Suggestions and detailed steps for improvement
- Daily emotion tracking (one emotion per user per day)
- Emotion update if changed on the same day
- Dashboard with bar graph for last 10 days
- PostgreSQL database integration

## Technologies Used
- Frontend: HTML, CSS, JavaScript
- Backend: Python (Flask)
- Database: PostgreSQL
- Machine Learning: Scikit-learn

## Project Structure
Emotion_Project/
├── app.py
├── best_emotion_model.pkl
├── daily_bargraph.py
├── emotion_focus_db.sql
├── emotion_focus_db.txt
├── emotion_pipeline.pkl
├── emotions_dataset.parquet
├── goemotions.csv
├── __pycache__/
│   └── train_models.cpython-36.pyc
├── static/
│   ├── confusion_matrix.png
│   ├── login_style.css
│   ├── study_focus.jpg
│   └── style.css
├── templates/
│   ├── daily_analysis.html
│   ├── index.html
│   ├── login.html
│   ├── register.html
│   └── trend_analysis.html
├── train_models.py
└── vectorizer.pkl

## Setup Instructions

### Clone the repository
git clone https://github.com/yourusername/emotion-project.git

### Go to project folder
cd emotion-project

### Install dependencies
pip install -r requirements.txt

### Setup database
createdb mydb  
psql -U postgres -d mydb -f emotion_focus_db.sql

### Run project
python app.py

## Functionality
- User enters a sentence and system detects emotion
- System provides suggestions and steps
- Emotion is stored in database
- One emotion per user per day is maintained
- Dashboard shows emotion trends

## Objective
To help users improve focus and productivity by understanding their emotions

## Limitations
- Emotion detection may not be fully accurate
- Only one sentence is processed at a time
- Suggestions are predefined
- Only one emotion per day is stored

## Future Enhancements
- Improve model accuracy
- Add personalized suggestions
- Enhance dashboard
- Add voice input
- Improve user interface

## Author
Shruti Pawar
