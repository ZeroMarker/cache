/*PMPDepartAudit.js
 @Author:liubaoshi
*/
var currRow=0;
var locid="",userid="",AuditLocDr="",AuditUserDr=""
var TLocDescobj;
function BodyLoadHandler()
{
 	var obj=document.getElementById("Update")
	if (obj) obj.onclick=Update_Click;
	var obj=document.getElementById("Add")
	if (obj) obj.onclick=Add_Click;
	var obj=document.getElementById("clear");
    if (obj) obj.onclick=clear_Click;
	TLocDescobj=document.getElementById('loc');
	TLocDescobj.onkeydown=getTLocDesc; 
   	TLocDescobj.onkeyup=clearlocid;
   	Tuserobj=document.getElementById('user');
   	Tuserobj.onkeydown=getuserDesc; 
   	Tuserobj.onkeyup=clearuserid;
   	ChooseType()
}

function Add_Click()
{
	var loc=document.getElementById('loc').value
	var user=document.getElementById('user').value
	var type=document.getElementById('Type').value
	if(locid=="")
		{
			locid=document.getElementById('locid').value;
		}
	if(userid=="")
		{
			userid=document.getElementById('userid').value;
		}
	if(locid=="")
		{
			alert(t['01'])
	    	return 
		}
	if(userid=="")
		{
			alert(t['01'])
	    	return     
		}
	if (type=="")
	   {
			alert(t['type']);  
			return
		}
	//验证
	var checkinfo=document.getElementById('Check');
	if (checkinfo){var encmeth=checkinfo.value} else{var encmeth=''}
	var ResInfo=cspRunServerMethod(encmeth,locid,userid,type)
	var StrInfo=ResInfo.split("^")
	if(StrInfo[0]==0)
		{
			alert(t['02'])
	    	return 
		}
	//添加
	var obj=document.getElementById('addinfo');
   	if (obj) {var encmeth1=obj.value} else {var encmeth1=''};
   	var  ret=cspRunServerMethod(encmeth1,locid,userid,type)
   	if(ret==0)
		{
			alert(t['Success'])
			window.location.reload();
		}
	 else
	 	{
	   		alert(t['Failure'])
	   		return
    	}
	
	window.location.reload();
}

function Update_Click()
{
	var obj=document.getElementById("AuditRowid"+"z"+currRow)
    if (obj) var AuditRowid=obj.innerText;
    var loc=document.getElementById('loc').value;
    var user=document.getElementById('user').value;
    var deft=document.getElementById('Effect').checked
    var type=document.getElementById('Type').value;
    if(deft)
    	{ 
			deft="Y"
		}
	else
		{
			deft="N"
		}
	if(locid=="")
		{
			locid=document.getElementById('locid').value;
		}
	if(userid=="")
		{
			userid=document.getElementById('userid').value;
		}
	if (currRow==0)
    	{
	   	 	alert(t['noline'])
	    	return
		}
	if (loc=="")
		{
			alert('科室不能为空');
			return
		}
	if (user=="")
		{
			alert('用户不能为空');
			return
		}
	//alert(AuditRowid);
	//alert(locid);
	//alert(userid);
	//alert(deft);
	var obj=document.getElementById("Up")
	if (obj) {var encmeth2=obj.value} else {var encmeth2=''};
   	var  Stpp=cspRunServerMethod(encmeth2,AuditRowid,locid,userid,deft,type)
   	if(Stpp==0)
		{
			alert(t['UpSucc'])
			window.location.reload();
		}
	else
	 	{
	   		alert(t['UpFail'])
	   		return
    	}
		window.location.reload(); 
	
}


function Getlocid(Value)
{
	var obj=document.getElementById('locid')
	var Tmploc=Value.split("^")
	locid=Tmploc[1];
}
function Getuserid(Value)
{
	var obj=document.getElementById('userid')
	var Tmpuser=Value.split("^")
	userid=Tmpuser[2];
}
	
function SelectRowHandler()
{
	currRow=selectedRow(window)
	//var objAuditLocName=document.getElementById("AuditLocName"+"z"+currRow)
	//var objloc=document.getElementById("loc")
	//if (objloc) objloc.value=objAuditLocName.innerText;
	
	//var objAuditUserName=document.getElementById("AuditUserName"+"z"+currRow)
	//var objuser=document.getElementById("user")
	//if (objuser) objuser.value=objAuditUserName.innerText;
	
}
function ChooseType()
{
	var obj=document.getElementById('Type');
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=ChooseType_OnChange;
	}	
	var varItem = new Option("","");
    obj.options.add(varItem);
    var varItem = new Option("科室审核","L");
    obj.options.add(varItem);
    var varItem = new Option("需求分配","F");
    obj.options.add(varItem);
    obj=null
	
	}
function ChooseType_OnChange()
{
	var obj=document.getElementById('Type');
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
}
function getTLocDesc()
{
	if (window.event.keyCode==13) 
		{  
			window.event.keyCode=117;
	   		loc_lookuphandler();
		}
}

function clearlocid()
{
	var locidobj=document.getElementById('locid');
	locidobj.value="";
}

function getuserDesc()
{
	if (window.event.keyCode==13) 
		{  
			window.event.keyCode=117;
	   		user_lookuphandler();
		}
}

function clearuserid()
{
	var useridobj=document.getElementById('userid');
	useridobj.value="";
}

function clear_Click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=PMPDepartAudit";
}
document.body.onload=BodyLoadHandler