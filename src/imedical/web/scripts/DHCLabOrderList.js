//DHCLabOrderList.js

document.write("<object id='objPrintPreview' classid='../service/lablis/DHCLabtrakReportPrint.dll#DHCLabtrakReportPrint.DHCLabtrakReportPrint' VIEWASTEXT/>")
document.write("</object>");

//document.write("<object id='objPrintPreview' classid='clsid:207F1B36-61ED-42F9-BE97-28312366AFCA' style='width:0;height:0'>")
//document.write("</object>");

var gUsercode=session['LOGON.USERCODE'];  
var PatientID=document.getElementById('PatientID');
var EpisodeID=document.getElementById('EpisodeID');
var objAdmID=document.getElementById('AdmID');

var AdmDateType="0";

var objSearch=document.getElementById('Search');
var ResIndex="",AdmDateIndex=0
var tEpisodeID=EpisodeID.value;

if (objSearch){
	var TParam=objSearch.value.split('^');
	if (TParam.length>5){
		ResIndex=TParam[3];
		AdmDateIndex=TParam[5];
	}
}

if (objAdmID) {
	var getAdmList=document.getElementById('getAdmList');
	if (getAdmList) {var encmeth=getAdmList.value} else {var encmeth=''};
	var RetVal=cspRunServerMethod(encmeth,PatientID.value);
	var tmpVal=RetVal.split("^");
  objAdmID.size=1;
  objAdmID.multiple=false;
  var tIndex=0;
	for (var i=0;i<tmpVal.length;i++){
		objAdmID.options[i]=new Option(tmpVal[i],tmpVal[i]);
		if ((tEpisodeID!="") && (tmpVal[i].indexOf(tEpisodeID)>=0)) {
			tIndex=i;
		}
	}
	objAdmID.selectedIndex=tIndex;
	objAdmID.onchange=FindOrderAdmID;
}

//结果状态
var objRes=document.getElementById("ResultStatus");
if (objRes){
	   objRes.size=1;
	   objRes.multiple=false;	
	   objRes.options[0]=new Option("全部","0");
	   objRes.options[1]=new Option("无结果","N");
	   objRes.options[2]=new Option("有结果","Y");
	   if (ResIndex=="N") {objRes.selectedIndex=1;}
	   if (ResIndex=="Y") {objRes.selectedIndex=2;}
	   objRes.onchange=FindOrderDateAll;
}
//就诊日期
var objAdmDate90=document.getElementById("AdmDate90");
if (objAdmDate90){objAdmDate90.onclick=FindOrderDate90;}
var objAdmDate180=document.getElementById("AdmDate180");
if (objAdmDate180){objAdmDate180.onclick=FindOrderDate180;}
var objAdmDate365=document.getElementById("AdmDate365");
if (objAdmDate365){objAdmDate365.onclick=FindOrderDate365;}
var objAdmDateAll=document.getElementById("AdmDateAll");
if (objAdmDateAll){objAdmDateAll.onclick=FindOrderDateAll;}
  
var ObjPrint=document.getElementById("PrintReport");  
if (ObjPrint) ObjPrint.onclick=SelectPrint;

var ObjPrint=document.getElementById("PrintPreview");  
if (ObjPrint) ObjPrint.onclick=PrintPreview;
	
var objSelectAll = document.getElementById("SelectAll");
if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;


var ObjPrint=document.getElementById('PrintEMR');
if (ObjPrint) ObjPrint.onclick=PrintEMR;

var ObjFind=document.getElementById('Find');
if (ObjFind) ObjFind.onclick=FindOrder;


var ObjPrintReport=document.getElementById('DownloadPrintProgram');
if (ObjPrintReport) ObjPrintReport.onclick=DownloadPrintProgramClickHandler;

var Objtbl=document.getElementById('tDHCLabOrderList');
var Rows=Objtbl.rows.length;
var tmpobj,tmpobj1
var admTypeValue=0;admValue=""
for (var i=1;i<Rows;i++){
	tmpobj=document.getElementById('ResultStatusz'+i);
	tmpobj1=document.getElementById('TSResultAnomalyz'+i);
	var tflag;
	tReadFlag=document.getElementById('ReadFlagz'+i).innerText;
	if (tReadFlag==' ')
	{
		Objtbl.rows[i].style.fontWeight='bold';
	};
	
	///选择权限
	var chkboxObj=document.getElementById("Selectz"+i);
    if (tmpobj){
          if (tmpobj1.value=='1') {
               tmpobj.style.color='red'
          }else{
               tmpobj.style.color='blue'
          }
    
          if ((chkboxObj)&&(tmpobj.innerText=='')) {chkboxObj.disabled=true; }
     }else{
          if (chkboxObj) {chkboxObj.disabled=true;}
     };
	var objAdmNo=document.getElementById('AdmNoz'+i);
	if ((objAdmNo)&&(admValue!=objAdmNo.innerText)){
		admTypeValue++;
		admValue=objAdmNo.innerText;
	}
	if(admTypeValue%2==0){
		Objtbl.rows[i].style.backgroundColor='#87cefa';
	} else {
		//Objtbl.rows[i].style.backgroundColor='#2e8b57';
	}
}


//ChkUnReadWarnReport();

function SelectAllClickHandler() {
    var itbl=document.getElementById("tDHCLabOrderList");
    if (itbl.rows.length==0) {return}
     if (itbl) {
          for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
               var chkboxObj=document.getElementById("Selectz"+curr_row);
               if (chkboxObj) {
                    if(!chkboxObj.disabled){
                         chkboxObj.checked=objSelectAll.checked;
                    }
               }
          }
     }
     return true;
}

function SelectPrint(){
   var ifrm,itbl,LabOeordRowidStr="";
   itbl=document.getElementById("tDHCLabOrderList");
   if (itbl.rows.length==0) {return}
   
   if (itbl) {
	  	for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var objSelectItem=document.getElementById("Selectz"+curr_row);
			if (objSelectItem.checked==true){ 
			      var TSRowId=document.getElementById("LabTestSetRowz"+curr_row).value;   //Hide
			      //var TSRowId=document.getElementById("LabTestSetRowz"+curr_row).innerText;
			      TSRowId=TSRowId.replace(",","#");
			      if (TSRowId) LabOeordRowidStr=LabOeordRowidStr+"^"+TSRowId;
				}
		 }
   }
  
  	if (LabOeordRowidStr=="") return;
	var GetReportNoMethod=document.getElementById('getWebConnString').value;
    connectString = cspRunServerMethod(GetReportNoMethod);
  	if (connectString=="") return;
    userCode=gUsercode;
    param="";
    //connectString = "cn_iptcp:127.0.0.1[1972]:DHC-APP";
    if (LabOeordRowidStr) objPrintPreview.PrintOut(LabOeordRowidStr, userCode, param, connectString);  
}

function PrintPreview(){
   var ifrm,itbl,LabOeordRowidStr="";
   itbl=document.getElementById("tDHCLabOrderList");
   if (itbl.rows.length==0) {return}
   
   if (itbl) {
	  	for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var objSelectItem=document.getElementById("Selectz"+curr_row);
			if (objSelectItem.checked==true){ 
			      var TSRowId=document.getElementById("LabTestSetRowz"+curr_row).value;   //Hide
			      //var TSRowId=document.getElementById("LabTestSetRowz"+curr_row).innerText;
			      TSRowId=TSRowId.replace(",","#");
			      if (TSRowId) LabOeordRowidStr=LabOeordRowidStr+"^"+TSRowId;
				}
		 }
   }
  
  	if (LabOeordRowidStr=="") return;
	var GetReportNoMethod=document.getElementById('getWebConnString').value;
    connectString = cspRunServerMethod(GetReportNoMethod);
  	if (connectString=="") return;
    userCode=gUsercode;
    param="";
    //connectString = "cn_iptcp:127.0.0.1[1972]:DHC-APP";
    //alert(connectString);
	//alert(objPrintPreview);
    if (LabOeordRowidStr) objPrintPreview.PrintPreview(LabOeordRowidStr, userCode, param, connectString);  
}


function DownloadPrintProgramClickHandler() {
	//var str=objPrintPreview.SayHello("Tom")
	//var str=objPrintPreview.ShowString("Tom")
	//alert(str);
	
	//var obj;
	//obj = new ActiveXObject("DHCLabtrakReportPrint.DHCLabtrakReportPrint");

    //rowids = "100160||A028||1^100151||A028||1";
    var rowids = "100160||A028||1";
    var userCode="demo";
    var param="";
    var connectString="cn_iptcp:127.0.0.1[1972]:DHC-APP";
    var str=objPrintPreview.ShowString(connectString);
    var ret=objPrintPreview.PrintPreview(rowids, userCode, param, connectString);
	
}

function ChkUnReadWarnReport() {
	var tbl=document.getElementById("tDHCLabOrderList");
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var FlagValue = document.getElementById("ReadFlagz" + curr_row);
        if (FlagValue==null){
        	MarkAsAbnormal(curr_row,tbl);
        }
	}
}
function MarkAsAbnormal(CurrentRow,tableobj) {
	for (var CurrentCell=0; CurrentCell<tableobj.rows[CurrentRow].cells.length; CurrentCell++) {
		tableobj.rows[CurrentRow].cells[CurrentCell].style.color="Red";
	}
}
  

function getpayinfo()
{
	if (EpisodeID.value=="") return;
}

function FindOrder(){
	var Include="N"
	if (AdmDateType=="1") {tEpisodeID=""; Include="Y"} 
	if (AdmDateType=="2") {tEpisodeID=""; Include="Y"} 
	if (AdmDateType=="3") {tEpisodeID=""; Include="Y"} 
	if (AdmDateType=="4") {tEpisodeID=""; Include="Y"} 
		
	var	findParam="^^^"+objRes.value+"^"+Include+"^"+AdmDateType;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOrderList&PatientID="+PatientID.value+"&EpisodeID="+tEpisodeID+"&Search="+findParam;
	location.href=lnk;
	return;
}

function FindOrderDate90()
{
	AdmDateType=1;
	FindOrder();
	return;
}
function FindOrderDate180()
{
	AdmDateType=2;
	FindOrder();
	return;
}
function FindOrderDate365()
{
	AdmDateType=3;
	FindOrder();
	return;
}
function FindOrderDateAll()
{
	AdmDateType=4;
	FindOrder();
	return;
}

function FindOrderAdmID()
{
	AdmDateType=0;
	if (objAdmID.value==""){
		FindOrderDateAll()
	} else {
		var TAdmList=objAdmID.value.split(',');
		tEpisodeID=TAdmList[0];
		FindOrder();
	}
	return;

}

function PrintEMR(){	
	var AmdObj=document.getElementById("EpisodeID");
	if (AmdObj.value=="") {return ;}
	var AmdId=AmdObj.value;

    var xlApp,obook,osheet,xlsheet,xlBook
	var path
	
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','');
	var fileName=path+"DHCLabResultEMR.xls";

	var GetResults=document.getElementById('getResultsByAdm');
	if (GetResults) {var encmeth=GetResults.value} else {var encmeth=''};
	var RetVal=cspRunServerMethod(encmeth,'','',AmdId);
	var tmpVal=RetVal.split("^");
	var num=tmpVal[0];
	if (num==0) {return ;}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(fileName);
	xlsheet = xlBook.ActiveSheet;

	var z,row,j,SumData;
	row=3;
	xlsheet.cells(row,1)=tmpVal[1];   
	row=row+1;
	var TSRowIDLists=tmpVal[2].split("#")
	
	for(z=1;z<=num;z++){
		var TSRowID=TSRowIDLists[z-1]
		var getData=document.getElementById('getData');
		if (getData) {var encmeth=getData.value} else {var encmeth=''};
		var RetStr=cspRunServerMethod(encmeth,'','',TSRowID);
		var pRetValues=RetStr.split("||");
		SumData=pRetValues[0];
		var pDataList=pRetValues[1].split('@@');
		for(j=1;j<=SumData;j++){
			var pData=pDataList[j-1].split('^');
			row=row+1;
			if (pData[0]==2) {
	   			mergcell(xlsheet,row,1,6)
		        xlsheet.cells(row,1)=pData[1];   
		        gridlist(xlsheet,row,row,1,6);
			}
			if (pData[0]==3) {
		        xlsheet.cells(row,1)=pData[1];    
		        xlsheet.cells(row,2)=pData[2];    
		        xlsheet.cells(row,3)=pData[3]; 
		        xlsheet.cells(row,4)=pData[4]; 
		        xlsheet.cells(row,5)=pData[5];  
		        xlsheet.cells(row,6)=pData[6];  
			}
			if (pData[0]==4) {
		        xlsheet.cells(row,1)=pData[1];    
		        xlsheet.cells(row,3)=pData[2]; 
			}

			if (pData[0]==5) {
	   			mergcell(xlsheet,row,1,6)
		        xlsheet.cells(row,1)=pData[1];    
		        gridlist(xlsheet,row,row,1,6);
			}
		}
	}		

    xlApp.Visible=true;
    xlsheet.PrintPreview();
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet=null	


}