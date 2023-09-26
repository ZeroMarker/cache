document.body.onload = BodyLoadHandler;

var stdate="",enddate=""
var EpisodeID="",opaId=""
var ctlocId=session['LOGON.CTLOCID'];

function BodyLoadHandler()
{
	var obj=document.getElementById("btnSch");
    if (obj) {obj.onclick=btnSch_Click;}
    var obj=document.getElementById("btnDetails");
    if (obj) {obj.onclick=btnDetails_Click;}
	var objstdate=document.getElementById("stdate");
	var objenddate=document.getElementById("enddate");
    var today=document.getElementById("getToday").value;
    if (objstdate.value=="") {objstdate.value=today;}
    if (objenddate.value=="") {objenddate.value=today;}
    stdate=objstdate.value;
    enddate=objenddate.value;
    var objPatWard=document.getElementById("patWard");
    if(objPatWard) objPatWard.onkeydown=GetPatWard;
    var objOpName=document.getElementById("opName");
	if(objOpName) objOpName.onkeydown=GetOpName;
	var obj=document.getElementById("ExportToExcel");
    if (obj) 
    {
        obj.onclick=Export_Click;
    }

}
function SelectRowHandler()
{
	var objtbl=document.getElementById('tDHCANOPInfo');
    var eSrc=window.event.srcElement;
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	EpisodeID=document.getElementById("admIdz"+selectrow).innerText;  //如果是隐藏的 要把innerText改成value
	//opaId=document.getElementById("opaIdz"+selectrow).innerText;
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	var opaId=document.getElementById("opaIdz"+selectrow).innerText;
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPInfoDetails+&startDate="+stdate+"&endDate="+enddate+"&topaId="+opaId;
     parent.frames[1].location.href=lnk; 

}
function btnSch_Click()
{
	var OpNameOrId="",PatWardId="",MedCareNo=""
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	var opId=document.getElementById("opId").value;
	if(opId=="") OpNameOrId=document.getElementById("opName").value;
	else  OpNameOrId=opId;
	PatWardId=document.getElementById("patWardId").value;
	MedCareNo=document.getElementById("MedCareNo").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPInfo&StartDate="+stdate+"&EndDate="+enddate+"&PatWardId="+PatWardId+"&OpNameOrId="+OpNameOrId+"&MedCareNo="+MedCareNo;
	location.href=lnk; 
}
function btnDetails_Click()
{
	//http://127.0.0.1/trakcare/csp/dhcanopchargeinfo.csp?opaId=42651&EpisodeID=2775151&ctlocId=311
	var lnk="../csp/dhcanopchargeinfo.csp?opaId="+opaId+"&EpisodeID="+EpisodeID+"&ctlocId="+ctlocId;
	window.open(lnk,'','')
}
function GetOpName()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	opName_lookuphandler();
	}
} 
function GetPatWard()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		patWard_lookuphandler();
	}
}
function getWardId(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("patWard")
	obj.value=tem[0];
	var obj=document.getElementById("patWardId")
	if(obj) obj.value=tem[1];
}
function GetOperation(str)
{
	var op=str.split("^");
	var obj=document.getElementById("opId");
	if (obj) obj.value=op[1];
	var obj=document.getElementById("opName");
	if (obj) obj.value=op[0];
}
function Export_Click()
{
		var xlsExcel,xlsBook,xlsSheet,fileName,path
		var objtbl=document.getElementById('tDHCANOPInfo');
		if (objtbl.rows.length<2) return;
		path=GetFilePath();
		fileName=path+"ANOPCOST.xls";
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName) ;
		xlsSheet = xlsBook.ActiveSheet;
		for (i=1;i<objtbl.rows.length;i++)
		{
			//opaId1
			var opaId=document.getElementById("opaIdz"+i).innerText;
			xlsSheet.cells(i+1,1)=opaId;
			//就诊号2
			var admId=document.getElementById("admIdz"+i).innerText;
			xlsSheet.cells(i+1,2)=admId;
			//住院号3
			var inPatNo=document.getElementById("inPatNoz"+i).innerText;
			xlsSheet.cells(i+1,3)=inPatNo;
			//病案号4
			var medCareNo=document.getElementById("medCareNoz"+i).innerText;
			xlsSheet.cells(i+1,4)=medCareNo;
			//登记号5
			var regNo=document.getElementById("regNoz"+i).innerText;
			xlsSheet.cells(i+1,5)=regNo;
			//病人科室ID6
			var PatWardtDr=document.getElementById("PatWardtDrz"+i).innerText;
			xlsSheet.cells(i+1,6)=PatWardtDr;
			//病人科室7
			var patWardDesc=document.getElementById("patWardDescz"+i).innerText;
			xlsSheet.cells(i+1,7)=patWardDesc;
			//病人姓名8
			var patName=document.getElementById("patNamez"+i).innerText;
			xlsSheet.cells(i+1,8)=patName;
			//性别9
			var sex=document.getElementById("sexz"+i).innerText;
			xlsSheet.cells(i+1,9)=sex	
			//年龄10
			var age=document.getElementById("agez"+i).innerText;
			xlsSheet.cells(i+1,10)=age	
			//就诊科室ID11
			var ctlocId=document.getElementById("ctlocIdz"+i).innerText;
			xlsSheet.cells(i+1,11)=ctlocId	
			//就诊科室代码12
			var ctlocCode=document.getElementById("ctlocCodez"+i).innerText;
			xlsSheet.cells(i+1,12)=ctlocCode	
			//就诊科室13
			var ctlocDesc=document.getElementById("ctlocDescz"+i).innerText;
			xlsSheet.cells(i+1,13)=ctlocDesc	
			//手术日期14
			var opdatestr=document.getElementById("opdatestrz"+i).innerText;
			xlsSheet.cells(i+1,14)=opdatestr
			//手术申请日期15	
			var opAppDateStr=document.getElementById("opAppDateStrz"+i).innerText;
			xlsSheet.cells(i+1,15)=opAppDateStr
			//状态代码	16
			var opStat=document.getElementById("opStatz"+i).innerText;
			xlsSheet.cells(i+1,16)=opStat
			//状态	17
			var opStatus=document.getElementById("opStatusz"+i).innerText;
			xlsSheet.cells(i+1,17)=opStatus	
			//麻醉方法18
			var anmethod=document.getElementById("anmethodz"+i).innerText;
			xlsSheet.cells(i+1,18)=anmethod
			//手术名称	19
			var opnameStr=document.getElementById("opnameStrz"+i).innerText;
			xlsSheet.cells(i+1,19)=opnameStr	
			//手术医师20
			var opdoc=document.getElementById("opdocz"+i).innerText;
			xlsSheet.cells(i+1,20)=opdoc	
		}
		var row=1;
		xlsSheet.cells(row,1)="opaId";
		xlsSheet.cells(row,2)="就诊号";
		xlsSheet.cells(row,3)="住院号";	
		xlsSheet.cells(row,4)="病案号";
		xlsSheet.cells(row,5)="登记号";
		xlsSheet.cells(row,6)="病人科室ID";
		xlsSheet.cells(row,7)="病人科室";
		xlsSheet.cells(row,8)="病人姓名";
		xlsSheet.cells(row,9)="性别";
		xlsSheet.cells(row,10)="年龄";
		xlsSheet.cells(row,11)="就诊科室ID";
		xlsSheet.cells(row,12)="就诊科室代码";
		xlsSheet.cells(row,13)="就诊科室";
		xlsSheet.cells(row,14)="手术日期";
		xlsSheet.cells(row,15)="手术申请日期";
		xlsSheet.cells(row,16)="状态代码";
		xlsSheet.cells(row,17)="状态";
		xlsSheet.cells(row,18)="麻醉方法";
		xlsSheet.cells(row,19)="手术名称";
		xlsSheet.cells(row,20)="手术医师";
		
		var savefileName="D:\\";
		var d = new Date();
		savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
		savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
		savefileName+=".xls"
		xlsSheet.SaveAs(savefileName);	
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

