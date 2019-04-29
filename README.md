# ADFSRulez
Some random ADFS rulez and stuff... 

## CreateCustomCanvasLogin.psm1 
This could work for most likely anything that needs this kind of logic. 

### Use case 
So, you need to provide a claim to a RP for a set of users but the claim should be composed of different attributes for different set of users. 
The case that proned the creation of this function was that for a user to be able to login in to Canvas as a student, we needed the the login name in Canvas to match a value in our SIS system, but for faculty and staff, this value does not exist. How do we solve this? 
Simple, just create custom claim rules with some filters! 

* In more detail: *
All students are in a parent AD group called Students (easy right?) and has the norEduPersonLIN attribute set to the SIS_ID from the SIS system. The SIS_ID is what identifies the student in the LMS login. 
All faculty and staff are in AD group called Employee and the LMS would identify the login ID of the person to another value (in this case UPN from the AD). 

### So what happens when I run the script? 
When you import and run the script you will be prompted for some values, for the simplicity the AD search commands needed to populate the script isn't included but should be fairly easy to get. 

After you've supplied the values, the script will create a .csv file that can be used to create the custom claims in ADFS. 

### Prerequisites

1. The name of the outgoing claim (this should be the login ID in the Canvas, this can be configured in Canvas)
2. The attribute name of the attribute holding the SIS_ID of the employees (in my example http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn) and the same for the students (in my example urn:mace:dir:attribute-def:norEduPersonLIN).
3. The group SID of the AD groups for employee and students. 

### How to get the group SID
Open a Powershell console.

```powershell
> (Get-ADGroup -Identity "insert name of group here, ie Employee").SID 
```

### Running the script
Finally, fun will now commence! 

Back to Powershell! 
```powershell
> Import-Module ./CreateCustomCanvasLogin.psm1
> CreateCustomCanvasLogin -StaffSID "S-1231-12313-1231" -StaffSIS "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn" -StudentSID "S-1245-1245-345" -StudentSIS "urn:mace:dir:attribute-def:norEduPersonLIN" -CustomLoginName "Login:To:LMS"
```
If everything goes according to plan, you will now have a file named CustomCanvasLogin.csv in your folder. Use this to create the custom claims in ADFS :)
This will not cover the process of actually creating it in ADFS but you could probably just export your current claims for that RP, add this to the end of that file and import it back in again. ** You should of course try this in a testing environment first **. 

## Disclaimer
Ofcourse this is like any other thing you find on the internet - as is and you should probably know what your doing before you go ahead and do it. But this is kinda harmless, just creating a a file with some attributes... 