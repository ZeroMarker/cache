// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objDeleteButton=document.getElementById("delete1");
var objPACPassword=document.getElementById("PACPassword");		 // setting link to form element "PACPassword"
var objConfirmPACPassword=document.getElementById("ConfirmPACPassword"); // setting link to form element "ConfirmPACPassword"
var objID=document.getElementById("ID");				 // can't get ID from the parameter sting directly
									 // so getting it from hidden from field which linked
									 // to the value in parameter sting.

var objUpd=document.getElementById("update1")				 // setting link to form element "update1"
if (objUpd) objUpd.onclick=UpdateClickHandler;				 // and setting up it's behaviour

var PasswordChanged = false;						 // setting up PasswordChanged flag	




document.body.onload=BodyLoadHandler;					 // setting up page load behaviour;
// 		 //
// End of script //
//		 //










//			 //
// Function Definitions: //
//			 //




function BodyLoadHandler()
{

if (objPACPassword)  	// Password fields do not autopopulate via %request.Get. Need to default "********"
{			// will determine whether or not the password has changed, and field will only be updated	
			// if it has
	
        if ((objID)&&(objID.value!="")) 
 	 {
	  objPACPassword.value="********";
	 }		
	objPACPassword.onchange=PasswordChangeHandler;
	if (objConfirmPACPassword) 
	{
		objConfirmPACPassword.onchange=PasswordChangeHandler;
		if ((objID)&&(objID.value!="")) objConfirmPACPassword.value="********";
	} 

}


if ((objID)&&(objID.value==""))   // if it's a new user - can't delete him
{
	if (objDeleteButton) objDeleteButton.disabled=true;
}


}



//if update button clicked
function UpdateClickHandler() 
{
	if (PasswordPreUpdateCheck()) return update1_click();
	return false
}



// if ConfirmPassword field exist and Password field matches ConfirmPassword field;
function PasswordPreUpdateCheck() {
	if (PasswordChanged)
        {
   		if ((objConfirmPACPassword)) 
		{
			if (objPACPassword.value!=objConfirmPACPassword.value)
			{
				alert(t['Pwd_Not_Match']);
				objPACPassword.value="";
				objConfirmPACPassword.value="";
				websys_setfocus("PACPassword");
				return false;
			}
		}
	}
	return true;
}




//If Password Field chanded  
function PasswordChangeHandler() 
{
 PasswordChanged=true;
}




