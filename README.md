# lua_soft_detour_finders POC
POC detecting c/cpp function being detoured using a cpp module by checking the address of the function


Execute the file, it will generate a file in data/ with a populated database, it only checks the function from _G, detect the "lower" function, decides it's the offset and then generate the database out of it.

Then you can use the generated file to check if any cpp function was detoured.

Obviously, it's reboot/changelevel proof, that's the whole point of detecting the offset, eh.

![](https://i.imgur.com/xXH2lTQ.gif)



What it's not doing : 

* Detecting lua detours (that's easy to do)

* Detecting backdoors

* Detecting detours of tostring, even if i can use other ways of getting the address
