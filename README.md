Mine
========


From my humble knowledge I would like to share this project with you.

**Features:**

* ***Everything stored in a Parse Database***
* User authentication
* AutoLogin option (Saved in NSUserDefaults)
* Badge with items counter
* PFQueryTableView (Wall TableVC)
* Detailed Item visualization
* Edit Item
* Contacts items visualization
* Image Picker (Profile Photo)
* Side Menu ( REFrostedViewController - credits to [romaonthego](https://github.com/romaonthego/REFrostedViewController) )

Menu (Side menu)

* User Profile photo + username
* Link to **Wall**
* Link to **Contacts**
* Link to **Config**

ViewControllers:

* Wall TableVC (Shows items)
	* Swipe to delete row
	* Pull to refresh
	* Add button to "Add Item VC"
	* Row click to "Detailed Item VC"
* Add Item VC
	* Add Title, Date, and Description and Save it
* Detail Item VC
	* Edit button to "Edit VC"
* Edit VC
* Contacts TableVC
	* Swipe to delete contact
	* Add contact
* Config VC
	* User stats
	* Profile image
	* Image Upload/Change/Remove
	* Log Out button
	
**How to try it**

You need a Parse acount (It is Free). Then, when you create a new app on Parse you have to write down the **APPLICATION_ID** and **CLIENT_KEY**

Now, download this project, and create a Header File that must be like in the photo below. Here you are going to put your **APPLICATION_ID** and **CLIENT_KEY** in order to configure the app.

![alt text] [id1]

[id1]:http://s10.postimg.org/n1dal6njt/Captura_de_pantalla_2014_10_03_a_la_s_19_58_25.png "AppUtilities.h" 

That's all you need to take care before running the app-

Once you have been adding users and publications, you'll find two new tables (Data) on parse, and the will look like this:

![alt text] [id2]
![alt text] [id3]

[id2]:http://s17.postimg.org/t1osvr2cv/Captura_de_pantalla_2014_10_03_a_la_s_20_01_23.png "User table"
[id3]:http://s27.postimg.org/ax4ls5en7/Captura_de_pantalla_2014_10_03_a_la_s_20_02_31.png "Items table"



**Known issues**

* When adding a contact, the Wall is not showing its items until an app restart.

**Planned features:**

* Accept/decline contacts
* Show contacts images


**Screen Shots**


![alt text] [id4]
![alt text] [id5]
![alt text] [id6]
![alt text] [id7]
![alt text] [id8]
![alt text] [id9]

[id4]:http://s23.postimg.org/cpuvhvskb/i_OS_Simulator_Screen_Shot_03_10_2014_20_15_00.png
[id5]:http://s27.postimg.org/4nwb1uy5f/i_OS_Simulator_Screen_Shot_03_10_2014_20_14_23.png
[id6]:http://s13.postimg.org/lp7v9niav/i_OS_Simulator_Screen_Shot_03_10_2014_20_15_07.png
[id7]:http://s29.postimg.org/90rmsh953/i_OS_Simulator_Screen_Shot_03_10_2014_20_15_35.png
[id8]:http://s24.postimg.org/avxqlfml1/i_OS_Simulator_Screen_Shot_03_10_2014_20_13_57.png
[id9]:http://s28.postimg.org/narjszyvx/i_OS_Simulator_Screen_Shot_03_10_2014_20_14_18.png



___

Follow me on Twitter - [poolqf](https://twitter.com/poolqf)