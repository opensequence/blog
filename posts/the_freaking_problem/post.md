[![photo padlock-58544_320_zpsvcncd1ks.jpg](http://i288.photobucket.com/albums/ll182/os_blog1/padlock-58544_320_zpsvcncd1ks.jpg)](http://s288.photobucket.com/user/os_blog1/media/padlock-58544_320_zpsvcncd1ks.jpg.html)
<p>For those who haven't heard - here is a succinct description from Matthew Green:
"A group of cryptographers at INRIA, Microsoft Research and IMDEA have discovered some serious vulnerabilities in OpenSSL (e.g., Android) clients and Apple TLS/SSL clients (e.g., Safari) that allow a 'man in the middle attacker' to downgrade connections from 'strong' RSA to 'export-grade' RSA. These attacks are real and exploitable against a shocking number of websites -- including government websites"

**Why is the FREAK problem such a mess**
This vulnerability is an echo of a long since removed (late 90's) restriction imposed by the US government on exporting strong encryption standards outside the US. It exposes the problem of legacy; where there is deemed too much risk removing old features - the developer instead opting to simply keep adding new ones on top. AS evidenced with this problem, this legacy code oft gets forgotten to the sands of time, only to be exposed in spectacular fashion much later.
The problem is compounded by the use of common security libraries used across many software platforms.

**The scramble to patch**
All the major software vendors (Apple, Google, Microsoft, OpenSSL) have now released (or shortly releasing) patches for their products and libraries, however it remains to be seen how long this issue will persist; owing to the often slow patch cycle of the wider Internet.
UPDATE - I have just seen this article published by Ars Technica - FIreEye researchers apparently have discovered thousands of apps on Android and IOS  who may also be vulnerable to the FREAK attack..

**How to prevent this in the future?**
It is easy to posit how this could have been prevented with hindsight - however it does highlight how much we rely on common libraries for our Internet services. I think more attention (money) needs to be paid to regularly auditing them as we are so early into the history of the Internet that we are constantly learning new lessons as we go.

**References:**

Matthew Green
http://blog.cryptographyengineering.com/2015/03/attack-of-week-freak-or-factoring-nsa.html

HTTPS-crippling FREAK exploit affects thousands of Android and iOS apps
http://arstechnica.com/security/2015/03/https-crippling-freak-exploit-hits-thousands-of-android-and-ios-apps/

</p>