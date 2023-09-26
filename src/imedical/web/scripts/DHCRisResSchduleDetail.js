//DHCRisResSchduleDetail.js
//DHCRisResSchduleDetail.js

function BodyLoadHandler()
{
	

    //查询可以登陆的科室和上次选择的科室
    GetLocName();

    //获得资源
    GetResource();
        
	var SDateObj=document.getElementById("StartDate");
	if (SDateObj.value=="")
	{
		SDateObj.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");  //DateDemo();
	}
	
	var EDateObj=document.getElementById("EndDate");
	if (EDateObj.value=="")
	{
		EDateObj.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");   //DateDemo();
	}
	  
  
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
		document.getElementById("ResourceId").value=ResourceObj.value; 
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
	var objtbl=document.getElementById('tDHCRisResSchduleDetail');
	if (objtbl) 
	{
	  var rows=objtbl.rows.length; 
	}
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	CurrentSel=selectrow;
	
	
	var ResRowId=document.getElementById('ResSchudleRowidz'+selectrow).value;
	
	var param="&ResSchduleId="+ResRowId; 
	var Detailzlink='TDetailz'+selectrow;

   	if (eSrc.id==Detailzlink)
  	{
	   var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryResDetailResSch"+param;
	   //alert(link);
       var mynewlink=open(link,"DHCRisLocStatics","scrollbars=yes,resizable=yes,top=6,left=6,width=900,height=680");
       return false;
  	}
  	return false;
	
	
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
   
   sYear  = d.getFullYear();		// 获取年份?
   s = sDay + "/" + sMonth + "/" + sYear;
   return(s); 
   
}


document.body.onload = BodyLoadHandler;


