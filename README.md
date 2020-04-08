# DEL Demo
This is a simple (and currently unfinished) web app meant to demonstrate
the kind of website that's made possible through interaction with CMS's DEL 
on FHIR.

You can see it up and running at https://deldemo.herokuapp.com

## Installation
These installation instructions may seem verbose as they were written to be 
accessible to most anyone. It should go quickly if you already have the 
necessary tools installed and follow the jumps provided!

### MacOS
It is most likely the case that these steps are incredibly similar for all 
other unix based operating systems

1. Open __Terminal__

2. Check if you have __Git__ installed by inputting:
    
     ```
     git --version
     ```

    * If __Git__ is already installed, __Terminal__ should output something 
    like:
    
        ```
        git version 2.21.0
        ```
         
        Jump to [step 7](#step-7) if this is the case.
    
    * If __Terminal__ responded with anything that might indicate it did not 
    recognize __Git__, such as:
    
         ```
         -bash: git: command not found
         ``` 
         
        continue to [step 3](#step-3).

3. <a name="step-3"></a>Check if you have __Homebrew__ installed by 
inputting:

    ```
    brew -v
    ```

    * If __Homebrew__ is already installed, __Terminal__ should output 
    something like:

        ```
        Homebrew 2.1.7-16-gbf0f1bd
        Homebrew/homebrew-core (git revision 6cc9b; last commit 2019-07-16)
        Homebrew/homebrew-cask (git revision 177ff; last commit 2019-07-16)
        ```

        Jump to [step 5](#step-5) if this is the case.

    * If __Terminal__ responded with anything that might indicate it did not 
    recognize __Homebrew__, such as:

        ```
        -bash: brew: command not found
        ```

        continue to [step 4](#step-4).

4. <a name="step-4"></a>Install __Homebrew__ by inputting:

    ```
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

5. <a name="step-5"></a>Install __Git__ by inputting:

    ```
    brew install git
    ```

6. <a name="step-6"></a>Configure __Git__ to match your __Github__ account:

    ```
    git config --global user.name "YOUR NAME"
    git config --global user.email "YOUR@EMAIL.com"
    ```

    (Don't have a __Github__ account? Register [here](https://github.com/join) 
    then run the above commands)

7. <a name="step-7"></a>Create a new directory to store this web app. Feel 
free to put this directory wherever makes sense. For the sake of simplicity, 
the following commands will create it directly in the home directory:

    ```
    cd ~
    mkdir delDemo
    ```

8. Clone the DEL Demo repository into your new directory by inputting:

    ```
    cd delDemo
    git clone https://github.com/paciowg/delDemo.git
    ```

9. Check if you have __Rails__ installed by running:

    ```
    rails -v
    ```

    * If __Rails__ is already installed, __Terminal__ should output 
    something like:

        ```
        Rails 5.2.3
        ```

        If this is the case, jump to [step 15](#step-15)

    * If __Terminal__ responded with anything that might indicate it did not 
    recognize __Rails__, such as:

        ```
        -bash: rails: command not found
        ```

        continue to [step 10](#step-10).


10. <a name="step-10"></a>Check if you have __Ruby__ installed by inputting:

    ```
    ruby -v 
    ```

    * If __Ruby__ is already installed, __Terminal__ should output something 
    like:
    
        ```
        ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin18]
        ```
         
        Jump to [step 14](#step-14) if this is the case.
    
    * If __Terminal__ responded with anything that might indicate it did not 
    recognize __Ruby__, such as:
    
         ```
         -bash: ruby: command not found
         ``` 
         
        continue to [step 11](#step-11).

11. <a name="step-11"></a>Check if you have the **R**uby **V**ersion 
**M**anager (__RVM__) by inputting: 

    ```
    rvm -v
    ```

    * If __RVM__ is already installed, __Terminal__ should output something 
    like:
    
        ```
        rvm 1.29.9 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]
        ```
         
        Jump to [step 13](#step-13) if this is the case.
    
    * If __Terminal__ responded with anything that might indicate it did not 
    recognize __RVM__, such as:
    
         ```
         -bash: rvm: command not found
         ``` 
         
        continue to [step 12](#step-12)

12. <a name="step-12"></a>Install __RVM__ by inputting:

    ```
    \curl -L https://get.rvm.io | bash -s stable
    ```

    If it asks for your password, provide it. Once downloading __RVM__, 
    you will need to close and reopen __Terminal__. Input:

    ```
    exit
    ```
    Then close __Terminal__, and open __Terminal__ again.

    **NOTE**: Both Ruby and Rails can be installed with one command by inputting:
    ```
    \curl -sSL https://get.rvm.io | bash -s stable --rails
    ```
    If you choose this option, you can jump ahead to [step 15](#step-15) 
    Reference http://rvm.io/ for more information about the Ruby Version Manager.

13. <a name="step-13"></a>Install __Ruby__ by inputting:

    ```
    rvm install ruby-2.6.3
    ```

14. <a name="step-14"></a>Install __Rails__. 

    First, input the following to ensure that **Ruby**'s package 
    manager __RubyGems__ is up to date:

    ```
    gem update --system
    ```

    Then, install __Rails__ by running:

    ```
    gem install rails
    ```

15. <a name="step-15"></a>Set up your local instance of the app. 
    
    First, make sure you're in the correct directory (Remember to change 
    the cd path if you chose to set up the app in a different location):

    ```
    cd ~/delDemo
    ```

    Next, ensure you have the __Bundler__ gem installed by inputting:

    ```
    gem install bundler
    ```

    Finally, use __Bundler__ to install the DEL Demo's gems:

    ```
    bundle install
    ```

16. Check if you have __PostgreSQL__ installed by inputting:

    ```
    postgres --version 
    ```

    * If __PostgreSQL__ is already installed, __Terminal__ should output something 
    like:
    
        ```
        postgres (PostgreSQL) 11.4
        ```
         
        Jump to [step 18](#step-18) if this is the case.
    
    * If __Terminal__ responded with anything that might indicate it did not 
    recognize __PostgreSQL__, such as:
    
         ```
         -bash: postgres: command not found
         ``` 
         
        continue to [step 17](#step-17).

17. <a name="step-17"></a>Install __PostgreSQL__ by inputting:

    ```
    brew install postgresql
    ```
    Alternately, you can install PostgreSQL using a GUI installer. Binary packages are available for multiple operating systems at https://www.postgresql.org/download/. 

**NOTE:** A minimum of Postgres version 12 is required to run the demo. 

18. <a name="step-18"></a>Create and migrate the (largely unused) DEL Demo dev db

    ```
    rake db:create:all
    rake db:migrate
    ```


## Run Application
Once installation is complete, you can run the app by following these steps:

1. Open __Terminal__

2. Make sure your working directory is where the app is stored. If you 
followed the MacOS installation directions above with no variation, 
inputting the following will get you there:

    ```
    cd ~/delDemo
    ```

    If that is not where your delDemo directory is, instead input 
    `cd <path>` where `<path>` is the path to your delDemo directory.

3. Start up the __PostgreSQL__ server by inputting:

    ```
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
    ```

4. Tell __Rails__ to start up a __Puma__ server by inputting:

    ```
    rails server
    ```

5. The DEL Demo should be running! Open a browser (I suggest __Chrome__) 
and type the following into the address bar:

    ```
    localhost:3000
    ```

6. When you're done using the app, you need to make sure the server stops 
running. To do this gracefully, you need to do two things:
    
    * First, go back to your __Terminal__ window and stop __Puma__ by
    using the hotkey:

        ```
        control-C
        ```

    * Then, stop the __PostgreSQL__ server by inputting:

        ```
        pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log stop
        ```


## Copyright

Copyright 2020 The MITRE Corporation
