//名称	DHCPEFetchReport.js
//功能	取报告
//组件  DHCPEFetchReport
//创建	2018.09.07
//创建人  xy
var myCombAry=new Array();
document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
document.write("</object>");


document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;
	  

	obj=document.getElementById("DoRegNo");
	if (obj){ obj.onkeydown=DoRegNo_keydown; }
	
	obj=document.getElementById("HPNo");
	if (obj){ obj.onkeydown=HPNo_keydown; }
	
	obj=document.getElementById("GroupName");
	if (obj){ obj.onchange=GroupName_change; }

	var obj=document.getElementById("BFind");
    if (obj){obj.onclick=BFind_click;}
	
	//读身份证
	var obj=document.getElementById("ReadRegInfo");
    if (obj){obj.onclick=ReadRegInfo_OnClick;}
  
	//撤销
	obj=document.getElementById("BCancelFetch");
	if (obj){ obj.onclick=BCancelFetch_click; }
   
	//导出
	obj=document.getElementById("BExport");
	if (obj){ obj.onclick=BExport_click; } 
	
	
	websys_setfocus("DoRegNo"); 
}

function BFind_click()
{   
  
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	
	var iHPNo=getValueById("HPNo");
	
    var iStartDate=getValueById("StartDate");
     
    var iEndDate=getValueById("EndDate");
     
    var iNoFetchReport="N"
	var iNoFetchReport=getValueById("NoFetchReport");
    if(iNoFetchReport) { iNoFetchReport="Y"; }
    else{ iNoFetchReport="N"; }
   
    var iVIPLevel=getValueById("VIPLevel");
    
    var iName=getValueById("Name");
    
	var iGroupID=getValueById("GroupID");
	
	var iDepartName =getValueById("DepartName");
    
  var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEFetchReport"
			+"&RegNo="+iRegNo
			+"&HPNo="+iHPNo
			+"&StartDate="+iStartDate
			+"&EndDate="+iEndDate
			+"&NoFetchReport="+iNoFetchReport
			+"&VIPLevel="+iVIPLevel
			+"&Name="+iName
			+"&GroupID="+iGroupID
			+"&DepartName ="+iDepartName 
			;
            //alert(lnk)
   // location.href=lnk;
    $("#tDHCPEFetchReport").datagrid('load',{ComponentID:55950,RegNo:iRegNo,HPNo:iHPNo,StartDate:iStartDate,EndDate:iEndDate,NoFetchReport:iNoFetchReport,VIPLevel:iVIPLevel,Name:iName,GroupID:iGroupID,DepartName:iDepartName});
}

//导出
function BExport_click()
{ 
	
    try{
	
 	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEFetchReport.xlsx';
	xlApp = new ActiveXObject("Excel.Application"); 
	xlApp.UserControl = true;
    xlApp.visible = true; 
	xlBook = xlApp.Workbooks.Add(Templatefilepath); 
	xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	
	var RowsLen=tkMakeServerCall("web.DHCPE.FetchReport","GetRowLength",session['LOGON.USERID']); 
	if(RowsLen==0){ 
		$.messager.alert("提示","此次查询结果为空","info");
	   	return;
	} 
	var HospitalID=session['LOGON.HOSPID'];
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HospitalID);
	xlsheet.cells(1,1)=HosName;
	var k=2;
	for(var i=1;i<=RowsLen;i++)
	{ 
		var DataStr=tkMakeServerCall("web.DHCPE.FetchReport","GetRowData",session['LOGON.USERID'],i); 
		var tempcol=DataStr.split("^"); 
		k=k+1;
		xlsheet.Rows(k).insert(); 
		xlsheet.cells(k,1)=tempcol[0];
		xlsheet.cells(k,2)=tempcol[1];
		xlsheet.cells(k,3)=tempcol[2];
		xlsheet.cells(k,4)=tempcol[3];
		xlsheet.cells(k,5)=tempcol[4];
		xlsheet.cells(k,6)=tempcol[5];
		xlsheet.cells(k,7)=tempcol[6];
		xlsheet.cells(k,8)=tempcol[7]; 
		xlsheet.cells(k,9)=tempcol[8];
		xlsheet.cells(k,10)=tempcol[9]; 
		xlsheet.cells(k,11)=tempcol[10];
		xlsheet.cells(k,12)=tempcol[11];
		xlsheet.cells(k,13)=tempcol[12];
 		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,13)).Borders.LineStyle=1; 
		
	} 
	 
   xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
	 
}
catch(e)
	{
		alert(e+"^"+e.message);
	}
}

function ReadRegInfo_OnClick()
  {
	
   	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");
 
     if (myary[0]=="0")
     { 
   
      SetPatInfoByXML(myary[1]); 
	  var myNameobj=document.getElementById("Name");
	  var myPatNameobj=document.getElementById('Name');
	  if ((myNameobj)&&(myPatNameobj)){
			myPatNameobj.value=myNameobj.value; 
			//alert(myPatNameobj.value)
			
		} 
	  var mycredobj=document.getElementById("CredNo");
		
     }
   
	 var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",mycredobj.value);
	 if (RegNo==""){
		return false;
	}
	var obj=document.getElementById("DoRegNo");
	if (obj){
		obj.value=RegNo;
		
	}
     
  }

function SetPatInfoByXML(XMLStr)
{
	
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
	   $.messager.alert("提示",xmlDoc.parseError.reason,"info");
		return; 
	}
    
	var nodes = xmlDoc.documentElement.childNodes;
	
	for(var i=0; i<nodes.length; i++) 
	{
		
		var myItemName=nodes(i).nodeName;
		
		var myItemValue= nodes(i).text;
		if (myCombAry[myItemName]){
			//alert(nodes(i).text)
			myCombAry[myItemName].setComboValue(myItemValue);
            
		}else{

			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	
	delete(xmlDoc);
}

function BCancelFetch_click()
{ 
    var objtbl = $("#tDHCPEFetchReport").datagrid('getRows');
    if(selectrow=="-1"){
		 $.messager.alert("提示","请选择待撤销的人","info");
		return false;
		}
	var ID=objtbl[selectrow].TID;
	if(ID==""){
		 $.messager.alert("提示","请选择待撤销的人","info");
		return false;
		}
	obj=document.getElementById("CancelFetchClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID);
	var Arr=ret.split("^")
	if (Arr[0]==0){
		$.messager.alert("提示","撤销成功","success");
		BFind_click();
	}else{
		 $.messager.alert("提示","撤销失败"+Arr[1],"error");
		//alert(Arr[1])
	}
}

var selectrow=-1; 
function SelectRowHandler(index,rowdata) {
	
	
	var objtbl = $("#tDHCPEFetchReport").datagrid('getRows');
    var rows=objtbl.length;
	selectrow=index;
	if(index==selectrow)
	{ 
 		
	}else
	{
		selectrow=-1;
		
	}


}


function GroupName_change()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
}

function SelectGroup(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=Arr[0];
}

function HPNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var obj=document.getElementById("HPNo");
		var encmeth="",HPNo="";
		if (obj) HPNo=obj.value;
		if (HPNo=="") return false;
		var obj=document.getElementById("FetchReportByHPNoClass");
		if (obj) encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,HPNo);
		var Arr=ret.split("^");
		if (Arr[0]!=0){
			$.messager.alert("提示",Arr[1],"info");
		  //alert(Arr[1]);
		   return false;

		}
		//window.location.reload();
		BFind_click();
	}
}
function DoRegNo_keydown(e)
{
	var Key=websys_getKey(e);
	var encmeth="",RegNo="";
	if ((9==Key)||(13==Key)) {
		
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var RegNo=$("#DoRegNo").val();
     if (RegNo=="") 
	   {
		   $.messager.alert("提示","请输入登记号","info");
		   return false;
	   }
		
  	if (RegNo.length<RegNoLength && RegNo.length>0) { 
			RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
			$("#DoRegNo").val(RegNo)
  	}
		
		var obj=document.getElementById("FetchReportClass");
		if (obj) encmeth=obj.value;
		var ret=cspRunServerMethod(encmeth,RegNo);
		var Arr=ret.split("^");
	
		if (Arr[0]!=0){
			$.messager.alert("提示",Arr[1],"info");
			return false;
		}
		
		BFind_click();
	}
}