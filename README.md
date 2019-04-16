So this is a personal project I was working on. It's more impressive from an architectural than it is from a programmatical one.  You have a handful of micro services using Cassandra as a data store. It needs a rewrite but what it does is scrapes, stores, and summarizes news articles. It’s impressive because it stores the whole article in the site. 

To clone everything (I didn’t want to use submodules): 
```for i in `\ls | grep second`; do rm -rf $i;  git clone https://github.com/rlewkowicz/$i.git; done```

Then modify secondpage-api/.env and change APP_URL= to your url, no trailing slash. There’s a consul instance and eventually all the kv stores were supposed to be in there from a global .env. 

`bash build-all.sh`

Wait for it to finish and then docker-compose up. It will take some time to grab some articles and then you can browse what you’ve stored.


