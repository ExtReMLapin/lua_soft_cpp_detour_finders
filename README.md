# lua_soft_detour_finders
detects c/cpp function detoured using a cpp module by checking the address of the function


Execute the file, it will generate a file in data/ with a populated database, it only checks the function from _G, detect the "lower" function, decides it's the offset and then generate the database out of it.

Then you can use the generated file to check if any cpp function was detoured.

Obviously, it's reboot/changelevel proof, that's the whole point of detecting the offset, eh.

![](https://i.imgur.com/xXH2lTQ.gif)
