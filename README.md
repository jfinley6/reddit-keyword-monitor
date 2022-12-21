## Reddit Keyword Monitor

### ** Project has been adapted to run on the front end. Update to readme coming soon. **

This program allows you to run a task in the background of your computer that checks for certain keywords in reddit posts. The task runs every 1 minute. The length of time can be changed. You are able to specify the subreddit you want to check as well as what words to look for. If it finds a match, it will email you a link to the post. If the program finds a post that it's already notified you about it will ignore it. 

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

#### 6. Create a .env folder

In the root folder of your directory, create a file called .env which is where we'll specify all of our variables for the program. This file is included in the .gitignore file and will not be tracked.

#### 7. Define Variables and Assign values

![.env file](https://i.imgur.com/lELWNKh.png)

Your .env file should match what is above with the x's replaced with your specific values. The only values that shouldn't be in quotes are the matching words. Values should be as follows.

- SUBREDDIT_NAME - The subreddit name you want to monitor.
- EMAIL_SUBJECT - The subject that the email being sent should have.
- RECEIVING_EMAIL - The email address that you would like the email to be sent to/
- SENDER_EMAIL - The email address where we setup an app password. This email will be sending the email.
- SENDER_EMAIL_PASSWORD - This is the 16-digit password we retrieved in step 5.
- MATCHING_WORDS - This can be any number of words you would like to check for. More than one word should be seperated by a comma with no space in between.

#### 8. Start running your task in the background

Run the following command in your terminal and the program will start checking for Reddit posts every 1 minute. 

```ruby
 whenever --update-crontab
```

If you would like to stop the task from being done automatically you can use the following command.

```ruby
 crontab -r    
```

And that's all it takes! Whenever a post is found with the matching words, it will send you an email with a link to the post.
If you would like to monitor the output of your program you can checkout the development.rb file which is found in the log folder. This will tell when it is done checking posts and the current time. It will also tell you if there is no internet as well as if it sent an email.

![Output log](https://i.imgur.com/dGX4JKZ.png)

#### Changing background task frequency

The default task frequency is 1 minute but you can change this in the schedule.rb file which is inside of app > config

![schedule.rb](https://i.imgur.com/8gvDRIM.png)

Just replace 1.minute with whatever frequency you want. In the above example, I changed it to 10.minutes.

### Questions

Any questions or issues please don't be afraid to ask!
