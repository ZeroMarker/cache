
//名称	DHCPEStationWorkStatistic.js
//功能	科室(每月)统计
//组件	DHCPEStationWorkStatistic 	
//创建	2007.07.03
//最后修改时间	
//最后修改人	
//完成

var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("LocDesc");
	if (obj) {
		obj.onchange=LocDesc_change;
		obj.onblur=LocDesc_blur;
	}
	
	obj=document.getElementById("OEItemDesc");
	if (obj) {
		obj.onchange=OEItemDesc_change;
		obj.onblur=OEItemDesc_blur;
	}
	obj=document.getElementById("Group");
	if (obj) {
		obj.onchange=Group_change;
	}
	obj=document.getElementById("DateType_A");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("DateType_E");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("Export")          
	if (obj) { obj.onclick=Export_click; }
	
	//obj=document.getElementById("BFind");
	//if (obj) { obj.onclick=Query_Click; }
	
	obj=document.getElementById("Clear")         
	if (obj) { obj.onclick=Clear_click; }	
	
	iniForm();
	Muilt_LookUp('LocDesc'+'^'+'OEItemDesc'+'^'+'Group');
}
function Clear_click()
{
	
	var obj=document.getElementById("DateBegin");
	if (obj){obj.value=""}
	var obj=document.getElementById("DateEnd");
	if (obj){obj.value=""}
	var obj=document.getElementById("LocDesc");
	if (obj){obj.value=""}
	var obj=document.getElementById("LocDR");
	if (obj){obj.value=""}
	var obj=document.getElementById("OEItemDesc");
	if (obj){obj.value=""}
	var obj=document.getElementById("OEItemDR");
	if (obj){obj.value=""}
	var obj=document.getElementById("Group");
	if (obj){obj.value=""}
	var obj=document.getElementById("GroupDR");
	if (obj){obj.value=""}
	var obj=document.getElementById("VIPLevel");
	if (obj){obj.value=""}
	var obj=document.getElementById("DateType_A");
	if(obj){obj.checked=false;}
	var obj=document.getElementById("DType");
	if (obj){obj.value=""}
	var obj=document.getElementById("DateType_E");
	if(obj){obj.checked=true;}

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

function GetLoc(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("LocDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("LocDR");
	if (obj) { obj.value=aiList[2]; }
}

//登记号
function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if ( 13==key) {
		RegNoOnChange();
	}
}

function LocDesc_blur() {
		return;
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('LocDR');
			if (obj) { obj.value=""; alert("aaa")}
		//}
		//else { return false; }
}

function LocDesc_change() {

	var obj;

	obj=document.getElementById('LocDR');
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
function Group_change() {

	var obj;

	obj=document.getElementById('GroupDR');
	if (obj) { obj.value="";}
}
function GetGroupID(value){
	if ("^^"==value) { return false; }
	var aiList=value.split("^");
	
    obj=document.getElementById("GroupDR");
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById("Group");
	if (obj) { obj.value=aiList[1]; }
	
}
function DateType_click() {
	
	var src=window.event.srcElement;
	obj=document.getElementById('DateType_A');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById('DateType_E');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	
	var srcId=src.id.split('_');
	obj=document.getElementById('DType');
	if (obj) { obj.value=srcId[1]; }
}
function Query_Click(){
	var iLocDR='',iOEItemDR='',iDateBegin='',iDateEnd='',iDType='',iGroupDR='',iVIPLevel='';
	var obj;
	
	obj=document.getElementById('LocDR');
	if (obj) { iLocDR=obj.value; }
	
	obj=document.getElementById('OEItemDR');
	if (obj) { iOEItemDR=obj.value; }
	
	obj=document.getElementById('DateBegin');
	if (obj) { iDateBegin=obj.value; }
	
	obj=document.getElementById('DateEnd');
	if (obj) { iDateEnd=obj.value; }
	
	obj=document.getElementById('DType');
	if (obj) { iDType=obj.value; }
	if ((''==iDateEnd)||(''==iDateBegin)) {
		alert(t['Err 01']);
		return false;
	}
	obj=document.getElementById('GroupDR');
	if (obj) { iGroupDR=obj.value; }
	
	obj=document.getElementById('VIPLevel');
	if (obj) { iVIPLevel=obj.value; }
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEStationWorkStatistic'
			+"&LocDR="+iLocDR
			+"&OEItemDR="+iOEItemDR
			+"&DateBegin="+iDateBegin
			+"&DateEnd="+iDateEnd
			+"&DType="+iDType
			+"&GroupDR="+iGroupDR
			+"&VIPLevel="+iVIPLevel
			;
	location.href=lnk;				
}
function Export_click()
{  
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEStationWorkStatistic.xls';
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
			var Ins=document.getElementById('GetStationWorkInfoBox');
		    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		    	
		    	var DataStr=cspRunServerMethod(encmeth,Num[j]);
		    	
		    	if (""==DataStr) { return false; }
		
		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
			    xlsheet.cells(k+j,3)=Data[2] 
			    xlsheet.cells(k+j,4)=Data[3] 
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,4)).Borders.LineStyle   = 1
			   
		} 
	   /*
   		var SaveDir="d:\\科室工作量统计.xls";
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