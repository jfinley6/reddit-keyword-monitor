## Reddit Keyword Monitor

This program allows you to run a task in the background of your computer that checks for certain keywords in recent reddit posts. The task runs every 1 minute. You are able to specify the subreddit you want to check as well as what words to look for. If it finds a match, it will email you a link to the post. If the program finds a post that it's already notified you about, it will ignore it. 

You are going to need two email addresses from gmail for this to work. I would recommend a brand new one in addition to one that you might already have.

#### Prerequisites

This project was built and requires the following on your computer.

- Github
- Ruby [2.7.4](https://github.com/organization/project-name/blob/master/.ruby-version#L1)
- Rails [7.0.4](https://github.com/organization/project-name/blob/master/Gemfile#L12)
- Postgresql [14.5](https://wiki.postgresql.org/wiki/Homebrew) *Installed using Homebrew

#### 1. Check out the repository

```bash
git clone git@github.com:jfinley6/reddit-keyword-monitor.git
```

#### 2. Install necessary gems

Run the following command

```ruby
bundle install
```

#### 3. Create and Setup the Database

Run the following command

```bash
rails db:create db:migrate db:seed
```

#### 4. Create 1-2 gmail accounts

If you already have the necessary accounts, proceed to step 4. Otherwise, get the right amount of accounts made. One of these emails will be sending an email, and the other receiving. 

#### 5. Retrieve app password for one of the accounts.

Go to your account settings and click the "Security" button. Proceed to the section that says "Signing into Google".

![Gmail security settings](https://i.imgur.com/nqnMRUX.png)

You're going to want to access "app passwords" but won't be able to until you've added 2-step authentication. If you haven't already, follow the steps for 2-step authentication. Once you've done go into the "app passwords" menu and you'll see the following screen.

![App passwords](https://i.imgur.com/xGJVlPM.png)

Click the "Select App" dropdown and give it a custom name of whatever you want. After clicking generate you will proceed to the final screen.

![16-digit app password](https://i.imgur.com/xGJVlPM.png)

Copy the 16 digit password and save it in a safe place. We are going to need it in a future step.

#### 6. Create a application.yml file and development.log file

In the config folder, create a file called application.yml which is where we'll specify all of our variables for the program. This file is included in the .gitignore file and will not be tracked.

In the log folder, create a file called development.log which is where the program will output it's results to.

#### 7. Define Variables and Assign values

![.env file](https://i.imgur.com/NVx4iUH.png)

Your .env file should match what is above with the x's replaced with your specific values. The only values that shouldn't be in quotes are the matching words. Values should be as follows.

- EMAIL_SUBJECT - The subject that the email being sent should have.
- RECEIVING_EMAIL - The email address that you would like the email to be sent to/
- SENDER_EMAIL - The email address where we setup an app password. This email will be sending the email.
- SENDER_EMAIL_PASSWORD - This is the 16-digit password we retrieved in step 5.

#### 8. Open the program up in your browser

Run the following command in your terminal and paste http://localhost:3002 into your browser

```ruby
foreman start -f Procfile
```


![program screenshot](https://i.imgur.com/B0RAMDv.png)

On this page, you can update the subreddit and keywords you want to monitor. If you click "Check Posts", the program will look for posts and check for any that have the keywords you specify in the title. If it finds one, it will send you an email and add the post to the list on the right. The list on the left will update you with the output of checking posts. Output includes:

- "Done Checking Posts at Current Time"
- "Email Sent at Current Time"
- "Keywords changed to ..."
- "Subreddit Name changed to ..." 
- "No internet

Clicking "Start Checking Posts Automatically" will run the program every minute and can be turned off when desired. Clicking the button will prompt a popup from your computer asking for permission to run the program in the backround.


### Questions

Any questions or issues please don't be afraid to ask! I'd also be happy to collaborate if anybody has any ideas on how to improve this. 
