##DESCRIPTION
We started on this because we wanted to know what is being served on a specific day at Skidmore College. Sometimes, the food being served might be something we particularly like, or know that it'll cause chaos in Dhall. 
*Made for fun, because why not?*

##HOW TO RUN  
###Data For DB
The current process is to run DhallScraper.sh, which will also runs ScrapeDhall.pl. The script will be written to dumb information into the local db.  
More information will be provided later.  

###Application
The application is a Flask application. Here are the necessary steps:  
```
cd menu-app  
python app.py # or python3 app.py depending on your system
```   

##NOTE  
If DhallScraper fails to run, it might be because of lack of dependencies.   
Try the following line and then re-run DhallScraper.sh.  
```
sudo apt-get install poppler-utils
```

###On virualenv  
Due to problem with namespace (which include whitespace for me), I have to edit some scripts so that virtualenv and pip3 would run.  
The problem can be found here: [https://github.com/pypa/virtualenv/issues/53](https://github.com/pypa/virtualenv/issues/53).  

##CONTRIBUTORS
This project is currently being developed by:  
Anh Vu Nguyen - @nlavee - anhvu.nguyenlam@gmail.com  
Giorgos Petkakis  

