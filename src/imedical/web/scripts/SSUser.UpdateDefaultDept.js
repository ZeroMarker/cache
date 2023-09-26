function BodyLoadHandler(){
 var obj=document.getElementById('update');
 if (obj) obj.onclick = ValidateUpdate;	
 var obj=document.getElementById("update")
 var SSGRPDesc=document.getElementById("SSGRPDesc");
 if(obj) {
	 obj.onclick=function (){ SSGRPDesc.disabled=false;update_click(); }
	 }
}
function ValidateUpdate(e) {
	var msg="";
	//if (!fSSUser_EditPassword_submit()) return;
	var objNewDept = document.getElementById('DEPARTMENT');
	
	
	var win = window.opener;
	if (win) {
		var objDept = win.document.getElementById('DEPARTMENT');
	}
	else var objDept = null;
	if (objNewDept) {
		//msg += ValidateDefault(objNewPwd.value);	
		if (msg != "") {
			alert(msg);
			return false;
		}
	}
	//copy new department to original screen department to enable logon
	if ((objDept) && (objNewDept)&&(objNewDept.value!="")) {
		objDept.value = objNewDept.value;
	}	
	return update_click();
}





function SetGroupByDet(str)
{
   group=str.split("^");
   var groupDesc=document.getElementById("SSGRPDesc");

   if (groupDesc)
   {
      groupDesc.value=group[1];   
   }
   //20140619,组件中写死了Hospital的值.
   var Hospital = document.getElementById("Hospital");
   if (Hospital){
		Hospital.value = group[2];  
	}
}
document.body.onload=BodyLoadHandler 