/// 名称	DHCPEDoctorWorkStatistic.js
/// 医生工作量统计

var TFORM="";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("DocName");
	if (obj) {
		obj.onchange=DocName_change;
		//obj.onblur=DocName_blur;
	}
	obj=document.getElementById("StationName");
	if (obj) {
		obj.onchange=StationName_change;	
	}

	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	obj=document.getElementById("OEItemDesc");
	if (obj) {
		obj.onchange=OEItemDesc_change;
		obj.onblur=OEItemDesc_blur;
	}
	obj=document.getElementById("Group");
	if (obj) {
		obj.onchange=Group_change;
	}
	obj=document.getElementById("BExport")          //add by 090730
	if (obj) { obj.onclick=BExport_click; }	         //add by 090730
	
	obj=document.getElementById("Clear");
	if (obj) obj.onclick=BClear_click;

	iniForm();
	Muilt_LookUp('DocName'+'^'+'Group'+'^'+'OEItemDesc');
}

function BClear_click()
{
	var obj=document.getElementById("DocNo");
	if (obj) obj.value="";
	var obj=document.getElementById("DocDR");
	if (obj) obj.value="";
	var obj=document.getElementById("DocName");
	if (obj) obj.value="";
	var obj=document.getElementById("DocInitials");
	if (obj) obj.value="";
	var obj=document.getElementById("OEItemDR");
	if (obj) obj.value="";
	var obj=document.getElementById("OEItemDesc");
	if (obj) obj.value="";
	var obj=document.getElementById("DateBegin");
	if (obj) obj.value="";
	var obj=document.getElementById("DateEnd");
	if (obj) obj.value="";
	var obj=document.getElementById("GroupDR");
	if (obj) obj.value="";
	var obj=document.getElementById("Group");
	if (obj) obj.value="";
	var obj=document.getElementById("VIPLevel");
	if (obj) obj.value="";
	var obj=document.getElementById("StationID");
	if (obj) obj.value="";
	var obj=document.getElementById("StationName");
	if (obj) obj.value="";
	var obj=document.getElementById("FindType");
	if (obj) obj.checked=false;
	
}
function BFind_click()
{
	var obj,DocNo="", DocDR="", DocInitials="", OEItemDR="", DateBegin="", DateEnd="", GroupDR="", VIPLevel="", StationID="", FindType="";
	var obj=document.getElementById("DocNo");
	if (obj) DocNo=obj.value;
	var obj=document.getElementById("DocDR");
	if (obj) DocDR=obj.value;
	var obj=document.getElementById("DocInitials");
	if (obj) DocInitials=obj.value;
	var obj=document.getElementById("OEItemDR");
	if (obj) OEItemDR=obj.value;
	var obj=document.getElementById("DateBegin");
	if (obj) DateBegin=obj.value;
	var obj=document.getElementById("DateEnd");
	if (obj) DateEnd=obj.value;
	var obj=document.getElementById("GroupDR");
	if (obj) GroupDR=obj.value;
	var obj=document.getElementById("VIPLevel");
	if (obj) VIPLevel=obj.value;
	var obj=document.getElementById("StationID");
	if (obj) StationID=obj.value;
	var obj=document.getElementById("FindType");
	if (obj&&obj.checked) FindType="on";
	SetQueryValue(1,DocNo, DocDR, DocInitials, OEItemDR, DateBegin, DateEnd, GroupDR, VIPLevel, StationID, FindType)
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEDoctorWorkStatistic&ShowResult=1"
		+"&"+"DocNo"+"="+DocNo+"&"+"DocDR"+"="+DocDR+"&"+"DocInitials"+"="+DocInitials
		+"&"+"OEItemDR"+"="+OEItemDR+"&"+"DateBegin"+"="+DateBegin+"&"+"DateEnd"+"="+DateEnd
		+"&"+"GroupDR"+"="+GroupDR+"&"+"VIPLevel"+"="+VIPLevel+"&"+"StationID"+"="+StationID
		+"&"+"FindType"+"="+FindType;
	location.href=lnk;
}
function SetQueryValue(KillFlag,DocNo, DocDR, DocInitials, OEItemDR, DateBegin, DateEnd, GroupDR, VIPLevel, StationID, FindType)
{
	var ret=tkMakeServerCall("web.DHCPE.Report.DoctorWorkStatistic","SetTempGlobal",KillFlag,DocNo, DocDR, DocInitials, OEItemDR, DateBegin, DateEnd, GroupDR, VIPLevel, StationID, FindType)
	if (ret!=""){
		SetQueryValue(0,DocNo, DocDR, DocInitials, OEItemDR, ret, DateEnd, GroupDR, VIPLevel, StationID, FindType)
	}
}


function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationID");
	if (obj) obj.value=DataArry[1];
}
function iniForm(){
	var obj
	return;
	obj=document.getElementById("DateBegin");
	if (obj){
		obj.value='t';
		DateBegin_lookupSelect();
	}
	
	obj=document.getElementById("DateEnd");
	if (obj){
		obj.value='t';
		DateEnd_lookuphandler();
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function GetOEItem(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("OEItemDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("OEItemDR");
	if (obj) { obj.value=aiList[2]; }
}

function GetDocName(value){
	
	var aiList=value.split("^");
	if (""==value){return false;}
	
	obj=document.getElementById("DocName");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("DocDR");
	if (obj) { obj.value=aiList[2]; }
}

function GetSTName(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("STName");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("STDR");
	if (obj) { obj.value=aiList[1]; }
}

function GetGroupID(value){
	if ("^^"==value) { return false; }
	var aiList=value.split("^");
	
    obj=document.getElementById("GroupDR");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("Group");
	if (obj) { obj.value=aiList[1]; }
	
}


//登记号
function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if ( 13==key) {
		RegNoOnChange();
	}
}

function DocName_blur() {
		
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('DocName');
			if (obj) { obj.value=""; }
		//}
		//else { return false; }
}
function Group_change() {

	var obj;

	obj=document.getElementById('GroupDR');
	if (obj) { obj.value="";}
}


	
function DocName_change() {

	var obj;
	obj=document.getElementById('DocDR');
	if (obj) { obj.value="";}
}

function StationName_change() {

	var obj;
	obj=document.getElementById('StationID');
	if (obj) { obj.value="";}
}

function OEItemDesc_blur() {
	return
	var obj;
	obj=document.getElementById('OEItemDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function OEItemDesc_change() {
		var obj;
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
}

function BExport_click()
{   
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEDocWorkStatistic.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  
		xlApp.UserControl = true;
       	xlApp.visible = true; //显示 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1");  

		obj=document.getElementById('GetRowNum');
		 if (obj) {var encmeth=obj.value; } else {var encmeth=''; };
		 var NumStr=cspRunServerMethod(encmeth);
		 var Num=NumStr.split("^")
	
		k=3
	
		for (j=0;j<Num.length;j++)
		{  
			var Ins=document.getElementById('GetDocWorkInfoBox');
		    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		    	var DataStr=cspRunServerMethod(encmeth,Num[j]);
		 
		    	if (""==DataStr) { return false; }
		
		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
			xlsheet.cells(k+j,3)=Data[2] 
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,3)).Borders.LineStyle   = 1
			   
		} 
	/*
   		var SaveDir="d:\\医生工作量统计.xls";
   		xlsheet.SaveAs(SaveDir);
   		xlApp.Visible = true;
   		xlApp.UserControl = true; 
    */
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

document.body.onload = BodyLoadHandler;