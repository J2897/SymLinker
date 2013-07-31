SymLinker
=========
*Released under the GNU General Public License version 3 by J2897.*

Pass it a source folder, and a destination, and a copy will be created. But instead of copying the files, symbolic links will be created instead.

*This has now been successfully tested on both 32-Bit and 64-Bit versions of Windows 7.*

Upon first run, it will look for this file:

	C:\Users\<name>\Documents\Symbolic Links.txt

If that file is not found, you will see the options screen for 20 seconds before the first option is automatically selected for you; a `Symbolic Links.txt` file will be generated and displayed in Windows Notepad. You may then proceed to generate folders of symbolic links.

*If in doubt, try the soft links out!*

Prerequisites
-------------

You will need the following beforehand:

* [Python] [1]
* [SymLinker] [2]
* [WinMerge] [3] (Optional)

How to use
----------

1.	Download the [master.zip] [2] file and extract the `SymLinker-master` folder to somewhere convenient:

		C:\Users\<name>\Programs\SymLinker-master\

	*You may rename the folder from `SymLinker-master` to just `SymLinker` if you wish.*

2.	Right-click on the `SymLinker.bat` file and select 'Run as administrator'.

3.	Choose option #1 first (scan file-system) to generate a summary of the current symbolic links on your drive.

4.	Create some symbolic links.

Note: If you have created lots of symbolic links and lost track of where they all are, don't panic. Choose option #1 again and another 'Symbolic Links.txt' file will be generated and placed here:

	C:\Users\<name>\Documents\Symbolic Links (1).txt

You may then open both files (`Symbolic Links.txt` and `Symbolic Links (1).txt`) in [WinMerge] [3] to easily compare both files.

   [1]: http://www.python.org/ftp/python/2.7.5/python-2.7.5.msi
   [2]: https://github.com/J2897/SymLinker/archive/master.zip
   [3]: http://winmerge.org/downloads/
