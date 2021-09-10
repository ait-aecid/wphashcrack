# wphashcrack

wphashcrack is a tool that extracts database-credentials from wp-config.php, extracts the password-hash of a user and utilizes john to crack the hash.

**Please note that this tool is written exclusively for research purposes and should not be used harmfully**

# References

This tool uses a statically compiled version of john the ripper and the rockyou wordlist:

- https://download.openwall.net/pub/projects/john/contrib/linux/historical/
- https://github.com/danielmiessler/SecLists/raw/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz
