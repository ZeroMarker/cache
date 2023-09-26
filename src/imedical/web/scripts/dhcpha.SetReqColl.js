//dhcpha.SetReqColl.js
//description:基数请领出库/审核选择发药人
var clientIP;
var parWin;
var CollFlag;
function BodyLoadHandler()
{ 
	clientIP=GetLocalIPAddress();
	parWin=window.dialogArguments;
	var obj=document.getElementById("CollFlag");	
	if (obj) CollFlag=obj.value;

	SetFormTitle(CollFlag); //zhwh 2011-07-18	
	//alert(CollFlag);
	
	var obj=document.getElementById("selectCollector");	
	if (obj) obj.onclick=selectCollector;
	
	var obj=document.getElementById("collectorList");	
	if (obj) 
	{obj.onkeydown=coll;
	obj.onclick=setFocusPwd;
	obj.multiple=false;
	}
  
	var obj=document.getElementById("UserPassword");	
	if (obj) obj.onkeydown=setPassword;
	var obj=document.getElementById("setCollect");	
	if (obj) obj.onclick=setCollectInfo;
  
	//setCollectorList();
	var obj=document.getElementById("UserPassword");	
	if (obj) obj.readOnly=true;
      selectCollector();
	setReqCollUserToList();

}

function setCollectInfo()
{
   var pwd="";
   var userRowid=""
   var obj=document.getElementById("UserPassword");	
   if (obj) pwd=obj.value;
   if (obj.value=="") {alert("请输入密码！");return;}
   //var obj=document.getElementById("rowid");	
   //if (obj) userRowid=obj.value;
   userRowid=getUserRowId();
   if (ValidUser(userRowid,pwd)) 
   { 
	   parWin.setUser(userRowid)  //接口函数
	   window.close()
   }
   //清除掉密码
  var obj=document.getElementById("UserPassword");	
  obj.value="";
   
   
}
function coll()
{
	var pwdObj=document.getElementById("UserPassword");
	var UserListObj	=document.getElementById("collectorList");
	if (window.event.keyCode==13) 
	{
		if (pwdObj) 
		{
			pwdObj.readOnly=false;  
			pwdObj.value="";
			pwdObj.focus();
		}      
	}
	
	if (window.event.keyCode==46)
	{
	  //删除
	  if  ( confirm("是否从列表中删除?")==true)	
	   {
		   var ind=UserListObj.options.selectedIndex;
		   if (ind>=0)
		   { UserListObj.remove(ind);
		    
		    makeUserStr();
		    
		    setCollectorList();
		   }
		}
	}
  return websys_cancel();
	
 }

function getUserRowId()
{
	var userrowid="";
	var obj=document.getElementById("collectorList");	
	var ind=obj.selectedIndex	
	if (ind<0 ) return userrowid;
	userrowid=obj.options[ind].value
	//var userName=obj.options[ind].text
	//if ((userrowid=="")||(userName=="")) return;
	return userrowid
	}
function setPassword()
{
	if (getUserRowId()!=""){
	  if (window.event.keyCode==13) 
	  {
	   setCollectInfo();
	   return websys_cancel();
	  }
	}
	else {alert("请选择一个用户！")}
	

}
function ValidUser(rowid,pwd)
{
	 var exe='';
	var obj=document.getElementById("mValidUser")
	if (obj) exe=obj.value;
	if (exe!='')
	{
		var result=cspRunServerMethod(exe,rowid,pwd);
		if (result<0) 
		{alert(t['INVALID_PWD']); 
		    var pwdobj=document.getElementById("UserPassword")
		    if (pwdobj) pwdobj.value="";
			return false;
				}
		///begin to collect
    
	}
	else
		{return false;}
	return true;
 }
function selectCollector()
{
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.GrpUser"+"&GrpId="+session['LOGON.GROUPID'];
  // window.open(lnk,"","menubar=no");
  var retval=showModalDialog(lnk,window,"Width:100;Height:200;center:yes;scroll:no;");
}
function setCollectorList()
{
	var userList=document.getElementById("collectorList");	
	userList.length=0;
	var obj=document.getElementById("collectorStr");	
	var str=obj.value;
 	//alert(str);
	var ss=str.split("!")
	
	for (var i=0;i<ss.length;i++)
	{
		var tmp=ss[i];
		var sss=tmp.split("^");
		
		var rowid=sss[0];
		var userName=sss[2];
	 
		userList.options[userList.options.length]=new Option (userName,rowid);
		
	}
	userList.options.selectedIndex=0;
	var pwdObj=document.getElementById("UserPassword");
	pwdObj.readOnly=false; 
   	saveRetUserToGlobal();
	}
function refreshMain()
{
  var docu=parent.frames['dhcpha.dispquery'].document;
  var objfind=docu.getElementById("Find");
  if (objfind) 
   {
	   objfind.click();
   }
   
	}
function GetListStr()
{
	//取用户列表串
	var rowidStr="";
	var obj=document.getElementById("collectorList");
	if (obj)
	{
		var len=obj.length;
		for (i=0;i<len;i++)
		{
		   	var rowid=obj.options[i].value;
			//alert(rowid);
			if (rowidStr=="") rowidStr=rowid;
			else  rowidStr= rowidStr+"^"+rowid;
	     }
	}
	
	return rowidStr;
}
function   x1()      
{      
          if   (   event.keyCode==116)      
          {      
                  event.keyCode   =   0;      
                  event.cancelBubble   =   true;      
                  return   false;      
          }      
}      
       
//禁止右键弹出菜单      
//function   x2()      
//{      
//      return   false;      
//}      
//
//
function setFocusPwd()
{
	var pwdObj=document.getElementById("UserPassword");
	if (pwdObj) 
	{
		pwdObj.readOnly=false;  
		pwdObj.value="";
		pwdObj.focus();
	}  	
	
}

function setReqCollUserToList()
{
  var exe="";
  if (CollFlag=="C")
  {
	 var obj=document.getElementById("mGetReqCollUser");
	 if (obj)  exe=obj.value;
	 else exe=""; }
  else
  {
	 var obj=document.getElementById("mGetReqDispUser");
	 if (obj)  exe=obj.value;
	 else exe="";
	  }
 if (exe=="") return;
 
 //alert(GetLocalIPAddress());
 
 var retusers=cspRunServerMethod(exe,clientIP);
 // alert("retusers:"+retusers);
 if (retusers=="") return;
 var obj=document.getElementById("collectorStr");
 if (obj) obj.value=retusers;
 
 setCollectorList();
		
}
function saveRetUserToGlobal()
{
  var exe="";
  if (CollFlag=="C")
  {
	 var obj=document.getElementById("mSaveReqCollUser");
	 if (obj)  exe=obj.value;
	 else exe="";
	  }
  else
  {
	 var obj=document.getElementById("mSaveReqDispUser");
	 if (obj)  exe=obj.value;
	 else exe=""	;  
	  }
 if (exe=="") return;
  var ss="";
 var obj=document.getElementById("collectorStr");
  if (obj)  ss=obj.value;
  
  var ret=cspRunServerMethod(exe,ss,clientIP);
	
	}

function GetLocalIPAddress()
{
    var obj = null;
    var rslt = "";
    try
    {
        obj = new ActiveXObject("rcbdyctl.Setting");
        rslt = obj.GetIPAddress;
        obj = null;
    }
    catch(e)
    {
        //异常发生
    }
    
    return rslt;
}
///
function makeUserStr()
{
  var str="";
  var obj=document.getElementById("collectorList");	
  if (obj)
  {
	  for (i=0;i<obj.length;i++)
	  {
		  var userrowid=obj.options[i].value;
		  var userName=obj.options[i].text;
		  var ss=userrowid+"^^"+userName;
		  
		  if (str=="")   {str=ss ;}
		  else  {str=str+"!"+ss;}
		  
		  }
	  }	
   var obj=document.getElementById("collectorStr");	
   if (obj) obj.value=str;
  }
/// //zhwh 2011-07-18
function SetFormTitle(CollFlag)
{
  var obj=document.getElementById("c"+"title");
  if (CollFlag=="C")
  { 
   	obj.innerText="基数配药确认";
   }
  else
  {	obj.innerText="基数发药确认";}	
}
document.body.onload=BodyLoadHandler;

//document.body.oncontextmenu=x2

