#!/bin/sh
nohup python /opt/k8s-mastery/sa-logic/sa/sentiment_analysis.py &
nohup java -jar /opt/k8s-mastery/sa-webapp/target/sentiment-analysis-web-0.0.1-SNAPSHOT.jar --sa.logic.api.url=http://localhost:5000 &
