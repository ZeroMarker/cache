//名称	DHCPEPositiveRecordStatistic.js
//功能	阳性记录统计
//组件	DHCPEPositiveRecordStatistic	
//创建	2018.08.09
//创建人  xy
document.write('<input type= "file" id= "File" style= "display:none">');
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("SexM");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("SexF");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("Query");
	if (obj) { obj.onclick=Query_click; }
	
	//按excel模板规定导出
 	obj=document.getElementById("ExportPositive");
	if (obj){ obj.onclick=ExportPositive_click; }
}

function Query_click()
{
	
	var DateBegin="", DateEnd="", iSexM="", iSexF="";
	
	DateBegin=getValueById("DateBegin");
	
	DateEnd=getValueById("DateEnd");
	

	SexM=getValueById("SexM");
	if(SexM) { iSexM="On"; 
	 //SetChkElement("SexM",1)
	}
   
	
	SexF=getValueById("SexF");
	if(SexF) { iSexF="On"; 
	//SetChkElement("SexgF",1)
	}

	var Job=session['LOGON.CTLOCID']+""+session['LOGON.USERID'];
	
	var DeleteFlag="1";
		
	SetQueryValue(DeleteFlag,Job,DateBegin,DateEnd,iSexM,iSexF);
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPositiveRecordStatistic"
			+"&Job="+Job+"&DateBegin="+DateBegin+"&DateEnd="+DateEnd+"&SexM="+iSexM+"&SexF="+iSexF;
			//messageShow("","","",lnk)
	
	
}
function SetQueryValue(DeleteFlag,Job,DateBegin,DateEnd,SexM,SexF)
{
	var ret=tkMakeServerCall("web.DHCPE.Report.PositiveRecordStatistic","SetPositiveRecord",DeleteFlag,Job,DateBegin,DateEnd,SexM,SexF)
	if (ret!=""){
		var Arr=ret.split("^");
		DateBegin=Arr[0];
		DateEnd=Arr[1];
		SetQueryValue(0,Job,DateBegin,DateEnd,SexM,SexF)
	}
}	
function DateType_click() {

	var src=window.event.srcElement;
	obj=document.getElementById('SexM');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById('SexF');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	
}


//读取模板,第五行开始,格式医嘱ID
//最后行设置End作为结束
function ExportPositive_click()
{
	var SexStr=""
	var obj=document.getElementById('SexM');
	if (obj && obj.checked) { SexStr="M"; }
	obj=document.getElementById('SexF');
	if (obj && obj.checked) { SexStr="F"; }
	if (SexStr==""){
		alert("请选择性别")
		return false;
	}
	var Template="";
	var obj=document.getElementById("File")
	if (obj)
	{
		obj.click(); 
		Template=obj.value;
		obj.outerHTML=obj.outerHTML; //清空选择文件名称
	}
	if (Template=="") return false;
	var extend = Template.substring(Template.lastIndexOf(".")+1);
	if(!(extend=="xls"||extend=="xlsx")){
		alert("请选择xls文件")
		return false;
	}    
	xlApp = new ActiveXObject("Excel.Application");
		
	xlBook = xlApp.Workbooks.Add(Template);
		
	xlsheet = xlBook.WorkSheets("Sheet1");
	
	var InString="";
	var k=5;
	
	
	InString=SexStr;
	
	while(1)
	{
		var StrValue=StringIsNull(xlsheet.cells(k,3).Value);
		if (StrValue=="End") break;
		InString=InString+"^"+StrValue;
		k=k+1;
	}
	//messageShow("","","",InString)
	var Ins=document.getElementById('ExportPositiveBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var Result=cspRunServerMethod(encmeth,InString);
 	var ResultString=Result.split("^");
 	//messageShow("","","",ResultString)
 	var ResultCount=ResultString.length;
 	for (var m=1;m<ResultCount;m++)
 	{
	 	for (var n=1;n<9;n++)
	 	{
	 		xlsheet.cells(m+4,n+3)=ResultString[m].split("@")[n-1];
	 	}
 	}
    var Ins=document.getElementById('ExportPositiveRecordBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
		
	var Result=cspRunServerMethod(encmeth,SexStr);
	//messageShow("","","",Result)
 	var ResultString=Result.split("^");
 	 
 	var ResultCount=ResultString.length;
 	for (var m=1;m<ResultCount;m++)
 	{
	 	for (var n=1;n<12;n++)
	 	{
	 		xlsheet.cells(m+k,n)=ResultString[m].split("@")[n-1];
	 	}

 	}
	xlsheet.SaveAs("D:\健康体检阳性统计.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;
	xlApp=null; 
	xlsheet=null;  
	
}


function StringIsNull(String)
{
	if (String==null) return ""
	return String
}

document.body.onload = BodyLoadHandler;