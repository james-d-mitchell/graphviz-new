# How to run current version (testing)
- In this folder there should be a file `run.sh` with the following code.
```bash
#!/bin/bash
<Path to gap.sh> ./run.g
```
- Replace `<Path to gap.sh>` with the path to your `gap.sh`. 
- Then open the terminal and run `./run.sh`. If it fails to run it likely does not have sufficient permissions. This can be fixed with `chmod 755 run.sh` which gives it the required permissions to run. 
- If there are still issues please contact me at mp322@st-andrews.ac.uk. That should open gap and load the scripts into the repl.
- Now that the repl is open some example code can be viewed by running `TestCode();`.

## Notes
- This is a quick minimum version. Most of the code has not been tested manually. None of the code has be tested with automated testing (to be fixed). Sorry for any bugs in advance. Please let me know if you find any.

## Todo
- Add a description of your package; perhaps also instructions how how to.
- Complete documentation
- Consider removing or replacing the `GV_` prefix.
- Likely more I dont know about yet lol.

# The GAP package graphviz
Install and use it, resp. where to find out more

## Contact
TODO: add info on how to contact you and/or how to report issues with your
package

## License
TODO: Provide information on the license of your package. A license is
important as it determines who has a right to distribute your package. The
"default" license to consider is GNU General Public License v2 or later, as
that is the license of GAP itself.
