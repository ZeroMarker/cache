///dhcpha.phaoperaterdialog
function BodyLoadHandler()
{
	  window.returnValue="";
	  var obj=document.getElementById("bOK")
	  if (obj) obj.onclick=OkClick;
	  
	  var obj = document.getElementById("operater");
	  
	  if (obj) 
	  {obj.onkeydown=popOperater;
	   //obj.onblur=DispOperCheck;
	  }
	  if (obj){
		setOperater();
		obj.onchange=operaterSelect;
	  }
	  
}
function OkClick()
{
	var obj=document.getElementById("operaterIndex");
	if (obj){window.returnValue=obj.value;}
	else {window.returnValue="";}
	window.close();
}
function setOperater()
{
	var obj=document.getElementById("operater");
	//alert(obj);
	if (obj) InitOperater();
	var objindex=document.getElementById("operaterIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}

function operaterSelect()
{
	var obj=document.getElementById("operaterIndex");
	if(obj){
		var objuser=document.getElementById("operater");
		obj.value=objuser.selectedIndex;
	}
}
function OperUserLookUpSelect(str)
{
	var ss=str.split("^") ;
	if (ss.length>0) {
		var obj=document.getElementById("operaterrowid");
		if (obj) obj.value=ss[1] ;
		else obj.value="" ;
		}
	//alert(obj.value);	
}
function popOperater()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  operater_lookuphandler();
		}
}
function InitOperater()
{
	var obj=document.getElementById("grp") ;
	var grp=session['LOGON.GROUPID']
	var obj=document.getElementById("mGetPhaUser") ;
	if (obj) {var encmeth=obj.value}
	else {var encmeth=''};
	
	var result=cspRunServerMethod(encmeth,grp)  ;
	var PhaUser=result.split("!!")
	var cnt=PhaUser.length
	var objOperator=document.getElementById("operater") 
	objOperator.options[0]=new Option ("","") ;
	for (i=0;i<cnt;i++) {
		
		var PhaUserCode=PhaUser[i].split("^");
		var desc=PhaUserCode[0];
		var code=PhaUserCode[1];
		
	objOperator.options[objOperator.options.length]=new Option (desc,code) ; 
	}
}
document.body.onload=BodyLoadHandler