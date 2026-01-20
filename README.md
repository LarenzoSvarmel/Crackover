# CrossOver (De-Trial'd)
Credit goes to [ellsies](https://gist.github.com/ellsies)

(The script isn't modified, at all. You can eye-for-eye the [revisions](https://gist.github.com/ellsies/e9383c75fd8cd8d5781dac91d7e2360d/revisions) of the original creator and clearly see that, and I don't think I'll ever modify the code; If it ain't broke, don't fix it.)

## Why is this here? Why not use the new version?
The *new* version by [totallynotinteresting](https://gist.github.com/totallynotinteresting) does not work on my Mac, architecture issues that I doubt they'd fix, even if I create an issue and detail it for them. That version is just meant for newer Macs. So treat this repository as the legacy version of CrackOver.

This version worked just fine as-is, and I also wanna find it easier so I just put it here.

# How to use

Make sure you have brew installed
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Open Terminal on Mac (LaunchPad -> Search -> Terminal)

You might have some trouble with pidof: 
If you do have trouble with pidof, install macports at https://www.macports.org/install.php then use: 
```sudo port install pidof```

(It works just the same as the brew version)

After a successful install, the script below does the rest:

### Installing the patch:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LarenzoSvarmel/Crackover/refs/heads/main/install.sh)"
```

