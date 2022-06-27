# About MVP

It is an iOs application with build-in basic face ID verification mechanic.
Mobile app create faceIDs of users from video stream, store them in DB.
Every time when user want to get access to  list of completed test's he should complete face verification.

## App has two flows

## QR - dna-test imitation 

1. User scan qr to start test.
In mvp we allow to scan any QR, app imitate needed qr-content  randomly by self (Covid19 or Monkey pub test).

2. In case when user didn't complete registration yet, app request some actions from him to get and store his faceID.

3. Successful verification
App emulate a voice dialog between user and Genius Machine. It's several simple steps without any actions from user in this mvp. After that application randomly generate result of test, store it and show result to user in app ui.

## Start - allow user to see results of previos tests

1. In case when user didn't complete registration yet, app request some actions from him to get and store his faceID.

2. Successful verification

App show to user list of tests that was previously completed via "QR-flow"