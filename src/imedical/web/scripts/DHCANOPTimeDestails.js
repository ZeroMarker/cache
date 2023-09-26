var stdate="",enddate=""
var ctlocId=session['LOGON.CTLOCID'];
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	//var myDate=new Date();
	//var myYear=myDate.getFullYear();
	//var myMonth=myDate.getMonth()+1;
	//var myDay=myDate.getDate();
	//var obj=document.getElementById('opdate');
	//if(obj.value=="") obj.value=myDay+"/"+myMonth+"/"+myYear;
	//alert(date.toLocaleDateString())
	var objstdate=document.getElementById("startdate");
	var objenddate=document.getElementById("enddate");
    var today=document.getElementById("getToday").value;
    if (objstdate.value=="") {objstdate.value=today;}
    if (objenddate.value=="") {objenddate.value=today;}
    stdate=objstdate.value;
    enddate=objenddate.value;
	var obj=document.getElementById('btnSch');
	if (obj) {obj.onclick=btnSch_Click;}
	var obj=document.getElementById("BtnPrint");
	if(obj) obj.onclick=BtnPrint_Click;
	//btnSch_Click();
}
function btnSch_Click()
{
	stdate=document.getElementById("startdate").value;
	enddate=document.getElementById("enddate").value;
	var opordno=""
	if ( document.getElementById("opordno")) opordno=document.getElementById("opordno").value;
	var colCode=""
	if (document.getElementById("colCode")) colCode=document.getElementById("colCode").value;
	//var colName=document.getElementById("colName").value;
	var time="";
	if (document.getElementById("time"))time=document.getElementById("time").value;
	
	var typeCode="";
	if (document.getElementById("typeCode")) typeCode=document.getElementById("typeCode").value;

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPTimeDestails&startdate="+stdate+"&enddate="+enddate+"&opordno="+opordno+"&colCode="+colCode+"&time="+time+"&typeCode="+typeCode+"&ctlocId="+ctlocId;
	location.href=lnk;
}

function GetColName(str)
{
	var temp=str.split("^");
	var obj=document.getElementById("colCode");
	if(obj) obj.value=temp[0];
	var obj=document.getElementById("colName");
	if(obj) obj.value=temp[1];
}
function GetType(str)
{
	var temp=str.split("^");
	var obj=document.getElementById("typeCode");
	if(obj) obj.value=temp[0];
	var obj=document.getElementById("type");
	if(obj) obj.value=temp[1];
}
function BtnPrint_Click()
{
	var name,fileName,path,operStat,printTitle,operNum;
	var xlsExcel,xlsBook,xlsSheet,xlsRange;
	var row=3;
	var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
	var objtbl=document.getElementById('tDHCANOPTimeDestails');
	if (objtbl.rows.length<2) return;
	path=GetFilePath();
	fileName=path+"anopTimeDestails.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) ;
	xlsSheet = xlsBook.ActiveSheet;
	
	var stdate=document.getElementById('stdate').value;
	var enddate=document.getElementById('enddate').value;
	stdate=stdate.split("/")[2]+"-"+stdate.split("/")[1]+"-"+stdate.split("/")[0];
	enddate=enddate.split("/")[2]+"-"+enddate.split("/")[1]+"-"+enddate.split("/")[0];
	var printTitle="",startRow;
	if(stdate==enddate) printTitle=stdate;
	else printTitle=stdate+"~"+enddate;
	var row=1;
	mergcell(xlsSheet,row,1,14);
	xlsSheet.cells(row,1)=printTitle+"手术麻醉工作时间";
	fontcell(xlsSheet,row,1,1,18);
	xlcenter(xlsSheet,row,1,1);
	SetRowH(xlsExcel,row,24);
	
	var row=2;
	xlsSheet.cells(row,1)="日期";
	xlsSheet.cells(row,2)="手术间";
	xlsSheet.cells(row,3)="台次";	
	xlsSheet.cells(row,4)="病人姓名";
	xlsSheet.cells(row,5)="科室";
	xlsSheet.cells(row,6)="床位";
	xlsSheet.cells(row,7)="手术医生";
	xlsSheet.cells(row,8)="麻醉方法";
	xlsSheet.cells(row,9)="入室";
	xlsSheet.cells(row,10)="麻醉开始";
	xlsSheet.cells(row,11)="手术开始";
	xlsSheet.cells(row,12)="手术结束";
	xlsSheet.cells(row,13)="离室";
	xlsSheet.cells(row,14)="间隔时间";
	fontcell(xlsSheet,row,1,14,12);
	xlcenter(xlsSheet,row,1,14);
	SetRowH(xlsExcel,row,20);
	xlsSheet.Range(xlsSheet.Cells(row,1),xlsSheet.Cells(row,14)).Font.Bold=true;
	
	var curNum=0;
	var row=2;
   	for (i=1;i<objtbl.rows.length-1;i++)  
	{
		row=row+1;
		//operNum=operNum+1;
		xlsSheet.cells(row,1)=document.getElementById("topdatez"+i).innerText;
		var room=document.getElementById("roomDescz"+i).innerText+"间";
		xlsSheet.cells(row,2)=room;
		var ord=document.getElementById("ordnoz"+i).innerText;
		xlsSheet.cells(row,3)=ord;
		xlsSheet.cells(row,4)=document.getElementById("patNamez"+i).innerText;
		var ctlocdesc=document.getElementById("patLocDescz"+i).innerText;
		xlsSheet.cells(row,5)=ctlocdesc.split("(")[0];
		xlsSheet.cells(row,6)=document.getElementById("bedNoz"+i).innerText;
		var docnamestr=document.getElementById("opdocStrz"+i).innerText;
		xlsSheet.cells(row,7)=docnamestr.split(" ")[0];
		xlsSheet.cells(row,8)=document.getElementById("anMethodz"+i).innerText;
		xlsSheet.cells(row,9)=document.getElementById("inRoomTimez"+i).innerText;
		xlsSheet.cells(row,10)=document.getElementById("anaStartTimez"+i).innerText;
		xlsSheet.cells(row,11)=document.getElementById("opaStartTimez"+i).innerText;
		xlsSheet.cells(row,12)=document.getElementById("opaEndTimez"+i).innerText;
		xlsSheet.cells(row,13)=document.getElementById("leaveRoomTimez"+i).innerText;
		xlsSheet.cells(row,14)=document.getElementById("intervalz"+i).innerText;
		xlcenter(xlsSheet,row,1,14);
		fontcell(xlsSheet,row,1,14,10);
		SetRowH(xlsExcel,row,20);
		//curNum=curNum+1;
	}
	gridlist(xlsSheet,2,row,1,14);
	//var colName=document.getElementById("colNamez").value;
	//var time=document.getElementById("timez").value;
	//var type=document.getElementById("typez").value;
	//var opordno=document.getElementById("opordnoz").value;
	//if((colName!="")&&(time!="")&&(type!="")&&(opordno!=""))
	//{
		row=row+1;
		mergcell(xlsSheet,row,1,14);
		xlsSheet.cells(row,1)=document.getElementById("opdocStrz"+i).innerText;
		fontcell(xlsSheet,row,1,1,14);
		xlcenter(xlsSheet,row,1,1);
		SetRowH(xlsExcel,row,20);
	//}
	
	xlsExcel.Visible = true
	xlsSheet.PrintPreview 
	//xlsSheet.PrintOut(); 
	xlsSheet = null;
	xlsBook.Close(savechanges=false)
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}
function GetFilePath()
{
	var GetPath=document.getElementById("GetPath").value;
	var path=cspRunServerMethod(GetPath);
	return path;
}

