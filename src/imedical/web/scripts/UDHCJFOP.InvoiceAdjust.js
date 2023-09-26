
function BodyLoadHandler() 
{
	var obj=document.getElementById("BAdjust");
	if (obj)
	{
		obj.onclick=BAdjust_Click;
		//obj.onclick=BTest_Click;
	}
	var obj=document.getElementById("BFind");
	if (obj)
	{
		obj.onclick=BFind_Click;
	}
	
	var obj=document.getElementById("OperName");
	if (obj)
	{
		obj.onchange=OperName_OnChange;
	}
	InitDocument();
}

function BTest_Click(){
    var encmeth=""
    var InvRowIdCurrent="10002"
    var InvNoCurrent="222222"
    var varExpr=""
    
	var obj=document.getElementById("encmTest");
	if (obj)  encmeth=obj.value;
	var rtn =cspRunServerMethod(encmeth,InvRowIdCurrent,InvNoCurrent,Expr);			
	if (0==rtn)  alert(t['OK']);
	else  alert(t['Sorry']);

}

function OperName_OnChange()
{
	var mysUser=DHCWebD_GetObjValue("OperName");
	if (mysUser==""){
		DHCWebD_SetObjValueB("UserRowID","");
	}
	
}

function GetUserInvInfo(UserRowId)
{
  
	var encmeth=""
	var obj=document.getElementById("getCurrentInv");
	if (obj)  encmeth=obj.value;
			
	var InvInfo=cspRunServerMethod(encmeth,UserRowId);
	var ary=InvInfo.split("^");
   	
   	var obj=document.getElementById("InvNoCurrent");
	if (obj) obj.value=ary[0]; 
	
	var obj=document.getElementById("InvNoBeforeAdjust");
	if (obj) obj.value=ary[0]; 

  	var obj=document.getElementById("CurrentInvSection");
	if (obj) obj.value=ary[1]+"-"+ary[2]; 
	var obj=document.getElementById("InvRowIdCurrent");
	if (obj) obj.value=ary[3]; 
  		
}
function InitDocument()
{

	var obj=document.getElementById("OperName");
	if (obj) obj.value=session['LOGON.USERNAME'];
	GetUserInvInfo(session['LOGON.USERID']);
	

}

function GetUserInfoByUserCode(value)
{	
	var str=value.split("^");
	var obj=document.getElementById("OperName");
	if (obj) obj.value=str[0]
	var obj=document.getElementById("UserRowId");
	if (obj) obj.value=str[2]
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=str[3]
	
	GetUserInvInfo(str[2]);
	
}
function CheckValidInvoice()
{
	var rtn=0
	var obj=document.getElementById("InvNoCurrent");
	if (obj) var curNo=obj.value;
	if(isNaN(curNo)) curNo=-1;
  	
  	var encmeth=""
	var obj=document.getElementById("encCheckInv");
	if (obj)  encmeth=obj.value;
	var rtn=cspRunServerMethod(encmeth,curNo);			
	//alert('curNo:'+curNo+'rtn'+rtn)
	if (rtn!=0)
	{
		alert(t['InvUsed']);
		rtn=1	
	}
  	
  	
  	var obj=document.getElementById("CurrentInvSection");
	if (obj) var sec=obj.value; 
	var ary=sec.split("-")
	var beginNo=parseFloat(ary[0]); 
	var endNo=parseFloat(ary[1]);
	if(isNaN(beginNo)) beginNo=0
	if(isNaN(endNo)) endNo=0
	//alert("beginNo"+beginNo+"endNo"+endNo)
	if ((curNo<beginNo)||(curNo>endNo)||(0==curNo)) 
	{
		 alert(t['NotInSec']+'\n\n'+t['checkNo']);
		 rtn=1	
	}

	return rtn
}

function BAdjust_Click()
{
	
	var obj=document.getElementById("InvNoCurrent");
	if (obj) var InvNoCurrent=obj.value; 
	if (InvNoCurrent=="") 
	{
	    alert(t['NoInvoice']);
	    return;	
	}
	
	var AdjustReason=""
	/*
	var obj=document.getElementById("AdjustReason");
	if (obj) 
	{
	  var AdjustReason=obj.value; 
	  if (""==AdjustReason) 
	  {
		 alert(t['Reason']);	  
		 return;
	  }
	}
	*/
	
	var obj=document.getElementById("InvRowIdCurrent");
	if (obj) var InvRowIdCurrent=obj.value; 

	var obj=document.getElementById("UserRowId");
	if (obj) var UserRowId=obj.value; 
	var obj=document.getElementById("InvNoBeforeAdjust");
	if (obj) var InvNoBeforeAdjust=obj.value; 
    var Expr=UserRowId+"^"+InvRowIdCurrent+"^"+InvNoBeforeAdjust+"^"+InvNoCurrent+"^"+AdjustReason+"^"+session['LOGON.USERID'];

	
	var encmeth=""
	var obj=document.getElementById("UpdateEncmeth");
	if (obj)  encmeth=obj.value;
	var rtn=CheckValidInvoice()
	if (rtn==0) 
	{
		//alert('haha wo mei gengxin!')
	   var rtn =cspRunServerMethod(encmeth,InvRowIdCurrent,InvNoCurrent,Expr);			
	    if (0==rtn)  alert(t['OK']);
	    else  alert(t['Sorry']);
	} else 
    {
	    //alert(t['checkNo'])
	    return;
	}
}

function BFind_Click()
{
	
}
document.body.onload = BodyLoadHandler;
