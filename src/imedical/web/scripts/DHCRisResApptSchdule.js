//DHCRisResApptSchdule.js
var gRemainNumber=""; //剩余数
var gLastMaxNum="";   //最大预约数
var gLastAutoNum="";  //自动预约数
var gAutoUseNum="";   //自动预约使用数

function BodyLoadHandler()
{
	
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	//查询可以登陆的科室和上次选择的科室
	GetLocName();

    //获得资源
    GetResource();
        
	/*var BookDateObj=document.getElementById("BookDate");
	if (BookDateObj.value=="")
	{
		BookDateObj.value=DateDemo();
	}*/
	var SDateObj=document.getElementById("BookDate");
	if (SDateObj.value=="")
	{
		SDateObj.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");  //DateDemo();
	}
	
	var EDateObj=document.getElementById("EndDate");
	if (EDateObj.value=="")
	{
		EDateObj.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");   //DateDemo();
	}
	
	var MaxObj=document.getElementById("MaxNumber");
	if (MaxObj)
	{
		MaxObj.onchange=MaxChange_click;   
	}
	var AutoObj=document.getElementById("AutoNumber");
	if (AutoObj)
	{
		AutoObj.onchange=AutoChange_click;   
	}
	
    //获取预约使用方式ID并设置样式
    GetUseType();
    var patTypeListObj=document.getElementById("patTypeList");
	if (patTypeListObj)
	{
		patTypeListObj.ondblclick=patTypeList_dblclick;
	}
	
	
	document.getElementById("showNotAvial").value="Y";
}

function GetResource()
{
	var SelResource="";
	SelResourceObj=document.getElementById("SelResource");
	if (SelResourceObj)
	{
		SelResource=SelResourceObj.value;
	}
 
  	var ResourceObj=document.getElementById("Resource");
   	if (ResourceObj)
   	{
 		combo("Resource");
 		var LocId=document.getElementById("LocId").value;
		var GetWeekInfoFunction=document.getElementById("GetResourceInfo").value;
		var Info1=cspRunServerMethod(GetWeekInfoFunction,LocId);
   		AddItem("Resource",Info1);
      	ResourceObj.onchange=onChangeResource; 
      	
      	var ResourceIdObj=document.getElementById("ResourceId");
		if (ResourceIdObj)
		{
			ResourceObj.value=ResourceIdObj.value; 
 		}
 		
  		ResourceObj.text=SelResource;
      	
     	
  	}
}

//
function onChangeResource()
{
	var ResourceObj=document.getElementById("Resource");
	if (ResourceObj)
	{
		//alert(ResourceObj.value);
		document.getElementById("ResourceId").value=ResourceObj.value; 
 	}
}




function Modi_click()
{
	
	var LocId=document.getElementById("LocId").value;
	
	var ResourceId=document.getElementById("ResourceId").value;
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("请选择一条记录!");
		return;
	}
	var BookMaxNumber=document.getElementById("MaxNumber").value;
	BookMaxNumber=cTrim(BookMaxNumber,0);
	BookMaxNumber=Number(BookMaxNumber);
	//alert("BookMaxNumber="+BookMaxNumber)
	var BookAutoNumber=document.getElementById("AutoNumber").value;
	BookAutoNumber=cTrim(BookAutoNumber,0);
	BookAutoNumber=Number(BookAutoNumber);
	//alert("BookAutoNumber="+BookAutoNumber)
	
	if (BookMaxNumber<BookAutoNumber)
	{
		alert("自动预约数不能大于最大预约数");
		return ;
	}
	
	var remainTime=document.getElementById("remainTime").value;
	remainTime=cTrim(remainTime,0);
	//alert(remainTime);
	var intRemainTime=parseInt(remainTime);
	//alert(intRemainTime);
	if ( intRemainTime < 0)
	{
		alert("剩余时间必须大于0");
		return ;
	}
	
	
	
	//var Info=SelRowid+"^"+BookMaxNumber+"^"+BookAutoNumber+"^"+remainTime;
	var availPatTypeCode=document.getElementById("patTypeCode").value;
    availPatTypeCode=cTrim(availPatTypeCode,0)
    
    var notAvail="";
	if ( document.getElementById("notAvail").checked)
		notAvail="Y";
		
	var Info=SelRowid+"^"+BookMaxNumber+"^"+BookAutoNumber+"^"+remainTime+"^"+availPatTypeCode+"^"+notAvail;
	
	//web.DHCRisResourceApptSchudle.UpdateDateResApptSchudle
	var UpdateApptSchudleFun=document.getElementById("UpdateApptSchudle").value;
	var ret=cspRunServerMethod(UpdateApptSchudleFun,Info);
	if (ret!="0")
	{
	     var Info="更新资源数量失败:SQLCODE="+ret;
		alert(Info);
	}
	else
	{

		var Resource=document.getElementById("Resource").value;
		var arcItemMastDr=""; //document.getElementById("arcItemMastDr").value;
        var arcItemMast=""; //document.getElementById("arcItemMast").value;
        var LocName=document.getElementById("LocName").value;
        var StartDate=document.getElementById("BookDate").value;
        var EndDate=document.getElementById("EndDate").value;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisResApptSchdule&LocId="+LocId+"&LocName="+LocName+"&ResourceId="+ResourceId+"&Resource="+Resource+"&arcItemMastDr="+arcItemMastDr+"&arcItemMast="+arcItemMast+"&BookDate="+StartDate+"&EndDate="+EndDate+"&showNotAvial=Y";
   		//alert(lnk)
		
		location.href=lnk; 
	}
	
}



function GetLocName()
{
	var LocID=document.getElementById("LocId");
    if (LocID.value=="")
    {
       var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	   var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	   if (Getlocicvalue=="")
         LocID.value=session['LOGON.CTLOCID'];
       else 
 		 LocID.value=Getlocicvalue;
	}
    var LocName=document.getElementById("LocName").value;
	if (LocName=="")
	{
	   var GetLocNameFunction=document.getElementById("FunLocName").value;
	   var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
       var LocName=document.getElementById("LocName");
       LocName.value=value;
	}
}

//select special location 
function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("LocName").value=Item[0];
  document.getElementById("LocId").value=Item[1];
  
    //put selected locid into session
   var SetSessionLocid=document.getElementById("SetLocsession").value;
   cspRunServerMethod(SetSessionLocid,"SelLocID",Item[1]);
   
   	bRefreshResourceObj=document.getElementById("bRefreshResource");
	if (bRefreshResourceObj)
	{
		bRefreshResourceObj.value="";
	}
   
    //获得资源
   GetResource();
   
}


function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[0],perInfo[1]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisResApptSchdule');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	//BookedDate,TimeDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID
	var ResShudleID=document.getElementById("RowIdz"+selectrow).value;
	var BookDate= document.getElementById("TBookDatez"+selectrow).innerText;
	var TimeDesc=document.getElementById("TperiodTimez"+selectrow).innerText;
	var ServiceGroup= document.getElementById("TServiceGroupz"+selectrow).innerText;
	
	var ResourceDesc= document.getElementById("TResourcez"+selectrow).innerText;
    var StartTime=document.getElementById("TStartTimez"+selectrow).innerText;
	var EndTime=document.getElementById("TEndTimez"+selectrow).innerText;
	var ChargeTime=document.getElementById("TChargeTimez"+selectrow).innerText
	
	var MaxBookNum= document.getElementById("TMaxBookNumberz"+selectrow).innerText;
	gLastMaxNum=Number(MaxBookNum);
	var AutoBookNum= document.getElementById("TAutoNumberz"+selectrow).innerText;
	gLastAutoNum=Number(AutoBookNum);
	
	var RowId = document.getElementById("RowIdz"+selectrow).value;
	var remainTime = document.getElementById("TRemainTimez"+selectrow).innerText;
	    gAutoUseNum=document.getElementById("AutoUseNumberz"+selectrow).innerText;
    if (gAutoUseNum=="")
    {
	    gAutoUseNum=0;
	}
    
	gRemainNumber=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetRemainNumber",ResShudleID);
	
    var availPatType=document.getElementById("TAvailPatTypez"+selectrow).innerText;
	availPatType=cTrim(availPatType,0)
	var availPatTypeCode=document.getElementById("TAvailPatTypeCodez"+selectrow).value;
	availPatTypeCode=cTrim(availPatTypeCode,0)
    //alert(gRemainNumber);
	var SelDateObj=document.getElementById("SelDate");
	if (SelDateObj)
	{
		SelDateObj.value=BookDate;
	}
	
	
	//时间段代码
	var TimeDescObj=document.getElementById("TimeDesc");
	if (TimeDescObj)
	{
		TimeDescObj.value=TimeDesc;
		
	}

	//服务组ID
	var ServiceGroupObj=document.getElementById("ServiceGroup");
	if (ServiceGroupObj)
	{
		ServiceGroupObj.value=ServiceGroup;
	}
	
	var SelResourceObj=document.getElementById("SelResource");
	if (SelResourceObj)
	{
		SelResourceObj.value=ResourceDesc;
	}
	
	var StartTimeObj=document.getElementById("StartTime");
	if (StartTimeObj)
	{
		StartTimeObj.value=StartTime;
	}
	
	
	var EndTimeObj=document.getElementById("EndTime");
	if (EndTimeObj)
	{
		EndTimeObj.value=EndTime;
	}
	
	var inChargeTimeObj=document.getElementById("inChargeTime");
	if (inChargeTimeObj)
	{
		inChargeTimeObj.value=ChargeTime;
	}
	
	
	var MaxNumberObj=document.getElementById("MaxNumber");
	if (MaxNumberObj)
	{
		MaxNumberObj.value=MaxBookNum;
		
	}
	var AutoNumberObj=document.getElementById("AutoNumber");
	if (AutoNumberObj)
	{
		AutoNumberObj.disabled=false;
		AutoNumberObj.value=AutoBookNum;
		if (gRemainNumber=="0")
		{
	         AutoNumberObj.disabled=true;
		}
	           
	}
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=RowId;
	}
	
	var remainTimeObj=document.getElementById("remainTime");
	if (remainTimeObj)
	{
		remainTimeObj.value=remainTime;
	}
    
    var availPatTypeCodeObj=document.getElementById("patTypeCode");
	if (availPatTypeCodeObj)
		availPatTypeCodeObj.value=availPatTypeCode;
		
	var availPatTypeObj=document.getElementById("patType");
	if (availPatTypeObj)
		availPatTypeObj.value=availPatType;
		
		
	if ( document.getElementById("TNotAvailz"+selectrow).innerText=="Y" )
	{
		document.getElementById("notAvail").checked=true;
	}
	else
	{
		document.getElementById("notAvail").checked=false;
	}
}


function DateDemo()
{
   var d, s="";           // 声明变量?
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			// 获取日?
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;		// 获取月份?
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear();		// 获取年份?
   s = sDay + "/" + sMonth + "/" + sYear;
   return(s); 
   
}

function GetUseType()
{
	var LocID=document.getElementById("LocId").value;
	
    var BKTypeFunction=document.getElementById("GetBKUseFlagbyLoc").value;
	    gBKUseTypeDR=cspRunServerMethod(BKTypeFunction,LocID);
	    
	if (gBKUseTypeDR=="2")
    {
	   document.getElementById("MaxNumber").disabled=true;
	   document.getElementById("AutoNumber").disabled=true;
	}
	else
	{
		document.getElementById("remainTime").disabled=true;
	}
}

function MaxChange_click()
{
	if (gRemainNumber=="0")
	{
		var AddMax=0;
		var AutoAdd=0;
		
		var BookMaxNumber=document.getElementById("MaxNumber").value;
		BookMaxNumber=cTrim(BookMaxNumber,0);
		BookMaxNumber=Number(BookMaxNumber);
		AddMax=BookMaxNumber-gLastMaxNum;
		if (AddMax<0)
		{
			alert("输入的最大预约数量不能小于原数量!");
			document.getElementById("MaxNumber").value=gLastMaxNum;
			document.getElementById("AutoNumber").value=gLastAutoNum;
			return 
		}
		
		document.getElementById("AutoNumber").value=gLastAutoNum+AddMax;
		
	}
}


function AutoChange_click()
{	
    var AutoNumber=document.getElementById("AutoNumber").value;
        AutoNumber=cTrim(AutoNumber,0);
		AutoNumber=Number(AutoNumber);
	if ((AutoNumber-gAutoUseNum)>gRemainNumber)
	{
		alert("输入自动预约数量不能大于剩余数量"+gRemainNumber)
		document.getElementById("AutoNumber").value=gLastAutoNum;
		return;
	}
}

function patTypeList_dblclick()
{
	var patTypeSel=this.options[this.selectedIndex].text;
	var patCodeSel=this.options[this.selectedIndex].value;
	var patType=document.getElementById("patType").value;
	var patCode=document.getElementById("patTypeCode").value;
	//alert(patTypeSel);
	//alert(patType);
	document.getElementById("patType").value=dealString(patTypeSel,patType);
	document.getElementById("patTypeCode").value=dealString(patCodeSel,patCode);
	
}

function dealString(value,list)
{
	var listArray=list.split(";");
	var length=listArray.length;
	var listRet="";
	var hasValue=0;
	for (j=0;j<length;j++)
	{
		if (listArray[j]=="")
		{
			continue;
		}
		if (listArray[j]!=value)
		{
			if (listRet=="")
				listRet=listArray[j];
			else
				listRet=listRet+";"+listArray[j];
		}
		else
			hasValue=1;
	}
	if(hasValue==0)
	{
		if (listRet=="")
			listRet=value;
		else
			listRet=listRet+";"+value;
	}
	return listRet;
}

function GetOrdItemInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("arcItemMastDr").value=Item[1];
  document.getElementById("arcItemMast").value=Item[0]; 
	
}


document.body.onload = BodyLoadHandler;


