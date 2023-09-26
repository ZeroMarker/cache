
function BodyLoadHandler()
{
	var obj=document.getElementById("Close");
	if (obj) obj.onclick=closeWin;
	
	var obj=document.getElementById("CreateRequest");
	if (obj) obj.onclick=createRequest;
	
	var obj=document.getElementById("selectAll");
	if (obj) obj.onclick=selectAll;

	
	var obj=document.getElementById("ReqLoc");  
	if (obj) 
	{obj.onkeydown=popReqLoc;
	 obj.onblur=ReqLocCheck;
	}
		
	SetDateScope();
	SetPharmacy();
	//SetReqNo();
	
	}
	
function GetReqNo(bdd)
{
  var exe="";
  var reqno="";
  if (bdd=="") return "";
  var obj=document.getElementById("mGetReqNo");  
  if (obj) exe=obj.value;
  if (exe!="")
  {
	  reqno=cspRunServerMethod(exe,bdd);
	  }
	return reqno;
}	

function popReqLoc()
{	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
		window.event.isLookup=true
	  	ReqLoc_lookuphandler(window.event);
	}
}
function ReqLocCheck()
{	
	var obj=document.getElementById("ReqLoc");
	var obj2=document.getElementById("ReqLocRowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";		}
}

function closeWin()
{
	window.close();

}
function createRequest()
{
  var exe="";
  var user=session['LOGON.USERID'] ;
  var obj=document.getElementById("mCreateRequest");
  if (obj) exe=obj.value;
  if (exe=="") return "";
  var obj=document.getElementById("RecLocRowid");
  if (obj)  dept=obj.value;
  var obj=document.getElementById("ReqLocRowid");
  if (obj)  pharLoc=obj.value;

  var obj=document.getElementById("StartDate");
  if (obj)  var sd=obj.value;
  var obj=document.getElementById("EndDate");
  if (obj)  var ed=obj.value;
  
  var obj=document.getElementById("StartTime");
  if (obj)  var st=obj.value;
  var obj=document.getElementById("EndTime");
  if (obj)  var et=obj.value;
  
  
  
  if (dept=='') 
  {alert(t['DEPT_NEEDED']);
   return;
	  }
  if (pharLoc=='') 
  {alert(t['PHARMACY_NEEDED']);
     return;
  }
  
  if ((sd=='')||(ed==''))
  {
	alert(t['DATE_NEEDED']);  
	return;
  }
  
  if ((st=='')||(et==''))
  {
	alert(t['TIME_NEEDED']);  
	return;
  }  
  
  if (DateStringCompare(sd,ed)==1)
  {alert(t['INVALID_DATESCOPE']);
     return;
     }
  
  var ICCode="";
  var obj=document.getElementById("ICCode");
  if (obj) ICCode=obj.value;
  
  var ret=confirm("是否生成库存转移请求单?");
  if (ret) 
  {
    var result=cspRunServerMethod(exe,dept,pharLoc,sd,st,ed,et,user,ICCode);
    var restsrt=result.split("^")
    if (result==-9){
		alert("请先处理未完成的基数药请领单!")
		return;
	}
    if (restsrt[0]>0) 
    {    
    	alert(t['CREATE_SUCCEED']);  
      	refreshWin(result);     
    }
    else if(restsrt[0]=="-1001") 
    {
		alert("条件范围内无可用保存数据!")
	}
    else
    {alert(t['CREATE_FAILURE']+restsrt);   }
  }
  
  
}
function refreshWin(result)
{
	var ss=result.split("^");
	if (ss.length>0 )
	{
		var bdd=ss[1];
		var reqrowid=ss[0];
		var reqno=GetReqNo(reqrowid);
		
  
		  var ICCode="";
		  var obj=document.getElementById("ICCode");
		  if (obj) ICCode=obj.value;
  
  		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferRequestByBasedrug"+"&bdd="+bdd+"&ReqNo="+reqno+"&ICCode="+ICCode;
		//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferRequestByBasedrug"+"&bdd=6";
		window.location.href=lnk;
		}
	}
function selectAll()
{

	
	}	
function ReqLocLookUpSelect(str)
{
 var ss=str.split("^");
 if (ss.length>0)
	{
		var reqLoc=ss[0];
		var reqLocRowid=ss[1];
		var obj=document.getElementById("ReqLocRowid");	
		if (obj) obj.value=reqLocRowid;
		var obj=document.getElementById("ReqLoc");	
		if (obj) obj.value=reqLoc;
	}
}
function SetDateScope()
{
 var exe;
 var objexe=document.getElementById("mGetBaseDrugDispDateScope");
 if (objexe) exe=objexe.value;
 else exe="";
 if (exe=="") return ;
 var obj=document.getElementById("RecLocRowid");
 if (obj) var dept=obj.value;
 else dept="";
 
 var ICCode="";
 var obj=document.getElementById("ICCode");
 if (obj) ICCode=obj.value;
 
 var ret=cspRunServerMethod(exe,dept,ICCode);
 if (ret!="") var ss=ret.split("^");

 var objSD=document.getElementById("StartDate");
 var objED=document.getElementById("EndDate");
 
 if (objSD) objSD.value=ss[0];
 if (objED) objED.value=ss[1];
 
 var objST=document.getElementById("StartTime");
 var objET=document.getElementById("EndTime");
 if (objST) objST.value=ss[2];
 if (objET) objET.value=ss[3];
 
}

function SetPharmacy()
{
	var exe="";
	var obj=document.getElementById("mGetConfigPhaLocDr");
	if (obj) exe=obj.value;
	else exe="";
	
	var str=cspRunServerMethod(exe);
	if (str!="")
	
	{
		var ss=str.split("^");
		
		var phaLocRowid=ss[1];
		var phaLoc=ss[0];
		
		var obj=document.getElementById("ReqLocRowid");
		if (obj) obj.value=phaLocRowid;
		var obj=document.getElementById("ReqLoc");
		if (obj) obj.value=phaLoc;
	}
	
	}
document.body.onload=BodyLoadHandler
