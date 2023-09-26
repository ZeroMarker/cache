/*var LocId=session['LOGON.CTLOCID'];
var UserId=session['LOGON.USERID']
var obj=document.getElementById("LocId");
if (obj) obj.value=LocId;
var GetLocDesc=document.getElementById("GetLocDesc").value;
var CTLocDesc=cspRunServerMethod(GetLocDesc,LocId);
var Obj=document.getElementById("Dept");
    Obj.value=CTLocDesc*/
function BodyLoadHandler() {
	var Obj=document.getElementById("SearCh");
	if(Obj) Obj.onclick=SearCh;	
	var obj=document.getElementById("SelectAll");
	if (obj){obj.onclick=SelectAll_Click;} 
	obj=document.getElementById("OrdExcute");
	if (obj){obj.onclick=OrdExcute;}
	obj=document.getElementById("UnExec");
	if (obj){obj.onclick=UnDoExecOrd;} 
	var obj=document.getElementById("PatRegNo");
	if (obj)
	{
		obj.onblur=Reg_Blur;
	}
	obj=document.getElementById("Print");
	if (obj){obj.onclick=PrintClick;}
}
function UnDoExecOrd()
{
	var OrdStr=""
	var UserId=session['LOGON.USERID']
	var Objtbl=document.getElementById('tDHCNurConOrd');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('SeleItemz'+i);  
	if(selobj.checked==true){
		var OrdRowId=document.getElementById('OeordIdz'+i).innerText
		if(OrdStr==""){	OrdStr=OrdRowId}
		else {OrdStr=OrdStr+"^"+OrdRowId}
		}  
	}
	if (OrdStr==""){
		alert(t['alert:select']);
		return;	
	}
	var obj=document.getElementById("OeordNotes");
	if (obj) { var Notes=obj.value;}
	else { var Notes="" }
	var UnDoExecOrd=document.getElementById("UnDoExecOrd").value;
	var OrdItmExecute=cspRunServerMethod(UnDoExecOrd,OrdStr,UserId);
	SearCh();
}
function Reg_Blur()
{
	var i;
    var regno=document.getElementById("PatRegNo");
	var isEmpty=(regno.value=="");
    var oldLen=regno.value.length;
    if(oldLen==10) return
    if (!isEmpty) {
        for (i=0;i<10-oldLen;i++)
        {
	        regno.value="0"+regno.value  
        }
    }
    if(!isEmpty) SearCh();
}
function SearCh()
{
	var obj=document.getElementById("PatRegNo");
	if (obj) { var PatRegNo=obj.value; }
	else { var PatRegNo="" }
	var obj=document.getElementById("StartDate");
	if (obj) { var StartDate=obj.value; }
	else { var StartDate="" }
	var obj=document.getElementById("EndDate");
	if (obj) { var EndDate=obj.value; }
	else { var EndDate="" }
	var obj=document.getElementById("LocId");
	if (obj) { var LocId=obj.value; }
	else { var LocId="" }
	var obj=document.getElementById("Dept");
	if (obj) { var Dept=obj.value; }
	else { var Dept="" }
	var obj=document.getElementById("ExecFlage");
	if (obj.checked==true) { var ExecFlage=1;}
	else { var ExecFlage=0 }
	var obj=document.getElementById("PatLocId");
	if (obj) { var PatLocId=obj.value; }
	else { var PatLocId="" }
	var obj=document.getElementById("PatLoc");
	if (obj) { var PatLoc=obj.value; }
	else { var PatLoc="" }
	if(PatLoc=="") var PatLocId=""
	
	var obj=document.getElementById("OrdCatId");
	if (obj) { var OrdCatId=obj.value; }
	else { var OrdCatId="" }
	var obj=document.getElementById("OrdCat");
	if (obj) { var OrdCat=obj.value; }
	else { var OrdCat="" }
	if(OrdCat=="") var OrdCatId=""

	var obj=document.getElementById("ArcimId");
	if (obj) { var ArcimId=obj.value; }
	else { var ArcimId="" }
	var obj=document.getElementById("Arcim");
	if (obj) { var Arcim=obj.value; }
	else { var Arcim="" }
	if(Arcim=="") var ArcimId=""
		
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurConOrd&StartDate="+StartDate+"&EndDate="+EndDate+"&LocId="+LocId+ "&ExecFlage="+ExecFlage+"&Dept="+Dept+"&PatRegNo="+PatRegNo+"&PatLoc="+PatLoc+"&PatLocId="+PatLocId+"&OrdCat="+OrdCat+"&OrdCatId="+OrdCatId+"&Arcim="+Arcim+"&ArcimId="+ArcimId;
	window.location.href=lnk;
}
function OrdExcute()
{
	var OrdStr=""
	var UserId=session['LOGON.USERID']
	var Objtbl=document.getElementById('tDHCNurConOrd');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('SeleItemz'+i);  
	if(selobj.checked==true){
		var OrdRowId=document.getElementById('OeordIdz'+i).innerText
		if(OrdStr==""){	OrdStr=OrdRowId}
		else {OrdStr=OrdStr+"^"+OrdRowId}
		}  
	}
	if (OrdStr==""){
		alert(t['alert:select']);
		return;	
	}
	var obj=document.getElementById("OeordNotes");
	if (obj) { var Notes=obj.value;}
	else { var Notes="" }
	var OrdItmExecute=document.getElementById("OrdItmExecute").value;
	var OrdItmExecute=cspRunServerMethod(OrdItmExecute,OrdStr,UserId,"E",Notes);
	SearCh();
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    var OrdStat=document.getElementById("OrdStatDescz"+selectrow).innerText;
    var SeleItem=document.getElementById("SeleItemz"+selectrow);
    if ((SeleItem.checked==true)&(OrdStat!=t['vale:OrdStat'])){
	    obj=document.getElementById("OrdExcute");
		//obj.style.visibility="hidden";
		obj.disabled = true
    }
    var obj=document.getElementById("OeordNotes");
	if (obj) { obj.value=document.getElementById("notesz"+selectrow).innerText;}
}

function SelectAll_Click()
{
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tDHCNurConOrd');
  var Rows=Objtbl.rows.length;
  if(Rows==1) return
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('SeleItemz'+i);  
	selobj.checked=obj.checked;  
	}
  var OrdStat=document.getElementById("OrdStatDescz"+1).innerText;
  if ((obj.checked==true)&(OrdStat!=t['vale:OrdStat'])){
	  objExec=document.getElementById("OrdExcute");
	  //objExec.style.visibility="hidden";
	  objExec.disabled = true
    }
    else{
	  objExec=document.getElementById("OrdExcute");
	  //objExec.style.visibility="visible";
	  objExec.disabled = false
    }
}
function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("LocId")
	obj.value=loc[1];	
}
function PrintClick()
{
		var  path = GetFilePath();
		var fileName="DHCNurOrderPrint.xls";
		fileName=path+ fileName;
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName)
		xlsSheet = xlsBook.ActiveSheet ;
		var hospitalDesc=document.getElementById("hospital").value;
		var objtbl=document.getElementById('tDHCNurConOrd');
    var i=0;
    var OrderNum=0
		var GetOrderNum=document.getElementById("GetPrintOrderNum")
		if(GetOrderNum) var OrderNum=cspRunServerMethod(GetOrderNum.value);
    if(OrderNum<2) return
		xlsSheet.cells(1,1)="登记号"
		xlsSheet.cells(1,2)="病人姓名"
		xlsSheet.cells(1,3)="病人科室"
		xlsSheet.cells(1,4)="床号"
		xlsSheet.cells(1,5)="医嘱名称"
		xlsSheet.cells(1,6)="医嘱单价"
		xlsSheet.cells(1,7)="数量"
		xlsSheet.cells(1,8)="金额"
		xlsSheet.cells(1,9)="医嘱状态"
		xlsSheet.cells(1,10)="执行人"
		xlsSheet.cells(1,11)="执行时间"
	  for (i=1;i<=OrderNum;i++)
		{
			 var GetPrintOrder=document.getElementById("GetPrintOrder").value
			 var OrderStr=cspRunServerMethod(GetPrintOrder,i);
			 var OrderList=OrderStr.split("^")
		   xlsSheet.cells(i+1,1)=OrderList[0]
		   xlsSheet.cells(i+1,2)=OrderList[1]
		   xlsSheet.cells(i+1,3)=OrderList[12]
		   xlsSheet.cells(i+1,4)=OrderList[2]
		   xlsSheet.cells(i+1,5)=OrderList[3]
		   xlsSheet.cells(i+1,6)=OrderList[14]
		   xlsSheet.cells(i+1,7)=OrderList[15]
		   xlsSheet.cells(i+1,8)=OrderList[16]
		   xlsSheet.cells(i+1,9)=OrderList[5]
		   xlsSheet.cells(i+1,10)=OrderList[7]
		   xlsSheet.cells(i+1,11)=OrderList[8]
		}
		gridlist(xlsSheet,1,i,1,11)
		nxlcenter(xlsSheet,1,i,1,11)
		nfontcell(xlsSheet,1,i,1,11,10)
		var  LeftHeader="";LeftFooter = "";CenterFooter = "";RightFooter = "";
		var CenterHeader = "&14"+hospitalDesc+" "+"医技科室对帐单";
		var RightHeader = " ";RightFooter =""
		var CenterFooter ="";
		ExcelSet(xlsSheet, 0, 0, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
		//xlsExcel.Visible = true;
		//xlsSheet.PrintPreview() ;
		xlsSheet.PrintOut;
		xlsSheet = null;
		xlsBook.Close(savechanges=false);
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
function GetPatLoc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("PatLocId")
	if(obj) obj.value=loc[1];	
}
function GetOrdCat(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("OrdCatId")
	if(obj) obj.value=tem[1];
}
function GetArcItem(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("ArcimId")
	if(obj) obj.value=tem[1];
}
document.body.onload = BodyLoadHandler;