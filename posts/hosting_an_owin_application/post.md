Recently, I had been tasked with figuring out how to host a test OWIN (find out more about OWIN [here](http://owin.org/)) application securely using TLS. I assumed this process would be quite simple; hosting an OWIN application over http is as simple as running the executable. However I ran into a few hurdles looking at documentation online; So I've distilled them down to the steps below:

**Get your Windows Machine Ready**
Make sure your windows system has ASP.NET 4.5 installed. In my case I was using a base install of Window Server 2012 R2 so I had to make sure the ASP.NET 4.5 feature was installed here:
[![photo NET45Feature_Server2012R2_zpsgglrttav.png](http://i288.photobucket.com/albums/ll182/os_blog1/NET45Feature_Server2012R2_zpsgglrttav.png)](http://s288.photobucket.com/user/os_blog1/media/NET45Feature_Server2012R2_zpsgglrttav.png.html)

**Install your Certificate**
Next step is to install your certificate onto the machine. I let windows decide where to put my certificate (it placed it in the "Personal Store") Make sure to choose to install the certificate into "Local Machine"
[![photo Cert_LocalM_Server2012R2_zpswaesa7a4.png](http://i288.photobucket.com/albums/ll182/os_blog1/Cert_LocalM_Server2012R2_zpswaesa7a4.png)](http://s288.photobucket.com/user/os_blog1/media/Cert_LocalM_Server2012R2_zpswaesa7a4.png.html)

Verify the certificate looks right by opening Certificate Manager (just search for "Certificate" in windows 8 and above). By default it should appear in the Local Computers Personal Certificate store:
[![photo CertMGR_Server2012R2_zpsm81savfq.png](http://i288.photobucket.com/albums/ll182/os_blog1/CertMGR_Server2012R2_zpsm81savfq.png)](http://s288.photobucket.com/user/os_blog1/media/CertMGR_Server2012R2_zpsm81savfq.png.html)

**Save the "Thumbprint" of your certificate**
The thumbprint is just a hash of your certificate and is how the netsh command will identify what certificate you wish to bind to the port.

From Certificate Manager double click to view your cert. Go to the "details" tab. Scroll down to the "Thumbprint" field and copy the hash displayed. Save this somewhere and remove the spaces between the characters. You will need this later.
[![photo CertThumb_Server2012R2_zps1luqbeun.png](http://i288.photobucket.com/albums/ll182/os_blog1/CertThumb_Server2012R2_zps1luqbeun.png)](http://s288.photobucket.com/user/os_blog1/media/CertThumb_Server2012R2_zps1luqbeun.png.html)

**Use netsh to bind the certificate to a port number**

Here is where we will need the certificate thumbprint; Insert it in the certhash field. 0.0.0.0 means this will listen on any ip address the computer has attached - you can specify an ip address or port here if you wish.
<div style="border:1px solid black;padding:2em;background-color: #b0c4de;">netsh http add sslcert ipport=0.0.0.0:443 certhash=‎fazzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzcafa appid={26557231-5530-1055-8579-FBAAAACFCAAA}</div>

I couldn’t really get a solid description of what the APPID is for; as far as I can tell it's a random ID that can be referenced (not sure what for) later. I just made this up and it worked fine. The ID is commonly formatted something like this: {00112233-4455-6677-8899-AABBCCDDEEFF}

[![photo NetSH_success_Server2012R2_zps12fin4vc.png](http://i288.photobucket.com/albums/ll182/os_blog1/NetSH_success_Server2012R2_zps12fin4vc.png)](http://s288.photobucket.com/user/os_blog1/media/NetSH_success_Server2012R2_zps12fin4vc.png.html)

**Confirm the binding is in place**
After the binding has been applied you can view your binding using this command:

[![photo NetSH_showSSL_Server2012R2_zpsjbs2k92q.png](http://i288.photobucket.com/albums/ll182/os_blog1/NetSH_showSSL_Server2012R2_zpsjbs2k92q.png)](http://s288.photobucket.com/user/os_blog1/media/NetSH_showSSL_Server2012R2_zpsjbs2k92q.png.html)

**Modify your OWIN config**
You will need to make sure your OWIN config is setup to accept connections on whichever port number you decided!
Your mileage will vary here, but in my case the application came with a .CONFIG file containing a "baseUri" setting. Make sure this matches what your DNS name will be.
[![photo OWIN_portconfig_Server2012R2_zpsrgdstovm.png](http://i288.photobucket.com/albums/ll182/os_blog1/OWIN_portconfig_Server2012R2_zpsrgdstovm.png)](http://s288.photobucket.com/user/os_blog1/media/OWIN_portconfig_Server2012R2_zpsrgdstovm.png.html)

**Run your app and test it**
[![photo OWIN_SUCCESS_Server2012R2_zps81qcga42.png](http://i288.photobucket.com/albums/ll182/os_blog1/OWIN_SUCCESS_Server2012R2_zps81qcga42.png)](http://s288.photobucket.com/user/os_blog1/media/OWIN_SUCCESS_Server2012R2_zps81qcga42.png.html)
Success! Look at that beautiful Green Padlock -  You now have a functioning Secure OWIN application!

Let me know in the comments how you went hosting your own OWIN application.

**Removing the Binding**
You can delete bindings using:

<div style="border:1px solid black;padding:2em;background-color: #b0c4de;">netsh http delete ipport=0.0.0.0:443</div>

**Notes**
Make sure you remember to setup your DNS records and your local firewall rules to get this working!

## _**Coming up:**_ How to host OWIN applications through IIS using [katana](http://www.asp.net/aspnet/overview/owin-and-katana/owin-middleware-in-the-iis-integrated-pipeline)!

**References:**
Initial blog entry I found
http://katanaproject.codeplex.com/discussions/545123

How to: Configure a Port with an SSL Certificate
https://msdn.microsoft.com/en-us/library/ms733791%28v=vs.110%29.aspx

How to: Retrieve the Thumbprint of a Certificate
https://msdn.microsoft.com/en-us/library/ms734695%28v=vs.110%29.aspx