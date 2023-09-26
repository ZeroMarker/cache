var admType="";
var preRegNo="",ctcpDesc="";
var idTmr=""
function BodyLoadHandler()
{
	var objRegNo=document.getElementById("regNo");
	if (objRegNo) {objRegNo.onblur=RegNoBlur;}

	var objSearch=document.getElementById("Find");
	if (objSearch) {objSearch.onclick=SearchClick;}
	var objPrint=document.getElementById("Print");
	if (objPrint) {objPrint.onclick=PrintClick;}
	admType=document.getElementById("admType").value;
	var clearScreenObj=document.getElementById("clearScreen");
	if (clearScreenObj) {clearScreenObj.onclick=ClearScreen;}
	var fDate=document.getElementById("fromDate");
	//if (fDate) {fDate.onblur=Adjust_TDate;fDate.onchange=Adjust_TDate}
    var tDate=document.getElementById("toDate");
	//if (tDate) {tDate.onblur=Adjust_FDate;tDate.onchange=Adjust_FDate;}
    if (fDate.value=="") fDate.value=DateDemo();
    if (tDate.value=="") tDate.value=DateDemo();
    var userId=session['LOGON.USERID'];
    var objFirstCtcpDesc=document.getElementById("firstCtcpDesc");
	if (objFirstCtcpDesc) objFirstCtcpDesc.onblur=FirstCtcpDescBlur;
	
}
function DateDemo(){
   var d, s="";
   d = new Date();
   s += d.getDate() + "/";
   s += (d.getMonth() + 1) + "/";
   s += d.getYear();
   return(s);
}
function SearchClick()
{
	Search(true);
}

function Search(searchFlag)
{
	Find_click();
}
function GetEpisode(str)
{
	var obj=document.getElementById('EpisodeID');
	var tem=str.split("^");
	obj.value=tem[6];
	Find_click();
}
function RegNoKeyDown()
{
	if (event.keyCode==13) RegNoBlur()
}
function RegNoBlur()
{
	var i;
    //var obj=document.getElementById("patMainInfo");
    //obj.value=""
    var objRegNo=document.getElementById("regNo");
    if (objRegNo.value==preRegNo) return;
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    for (i=0;i<8-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
    //preRegNo=objRegNo.value;
   	//BasPatinfo(objRegNo.value);
   	//document.getElementById("CardNo").value="";
    //document.getElementById("EpisodeID").value="";EpisodeID="";
   	//Search(true);
}

function FunReadCard()
{
    var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			document.getElementById("EpisodeID").value="";EpisodeID=""
			var obj=document.getElementById("regNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			if (myary[5]!=""){
				BasPatinfo(myary[5]);
				ReLoadOPFoot("Bill","","");  //only read pat base info,no fee
			}
			break;
		case "-200":
			alert(t["alert:cardinvalid"]);
			break;
		case "-201":alert(t["alert:cardvaliderr"])
		default:
	}
}
function BasPatinfo(regNo)
{//    s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel
   
	if (regNo=="") return;
 	var patinfo=document.getElementById("patinfo").value;
 	var str=cspRunServerMethod(patinfo,regNo);
   	if (str=="") return;
    var tem=str.split("^");

	var obj=document.getElementById("patMainInfo");
	obj.value=tem[4]+","+tem[3]+","+tem[7]
}

function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList<3) return 0;
	return tmpList[2]*1000+tmpList[1]*100+tmpList[0]
}
function Adjust_TDate()
{
	var fDate=document.getElementById("fromDate");
    var tDate=document.getElementById("toDate");
	//alert(fDate.value+" "+tDate.value)
	if (GetDate(fDate.value)>GetDate(tDate.value)) tDate.value=fDate.value ;
}
function Adjust_FDate()
{
	var fDate=document.getElementById("fromDate");
    var tDate=document.getElementById("toDate");
	if (GetDate(fDate.value)>GetDate(tDate.value)) fDate.value=tDate.value ;
}
function ClearScreen()
{
	document.getElementById("regNo").value="";
	document.getElementById("CardNo").value="";
	document.getElementById("EpisodeID").value="";
	document.getElementById("patMainInfo").value=""
	document.getElementById("fromDate").value=""
	document.getElementById("toDate").value=""
	document.getElementById("visitStat").value=""
	var obj=document.getElementById('ctcpId');
	if (obj) obj.value="";
	obj=document.getElementById('firstCtcpDesc');
	if (obj) obj.value="";
	obj=document.getElementById("locDesc")
	if (obj) obj.value="";
	obj=document.getElementById("needAdsouDesc")
	if (obj) obj.value="";
	Search(false);
}
function GetVisitStat(str)
{	var obj=document.getElementById('visitStat');
	var tem=str.split("^");
	obj.value=tem[1];
}
function GetLoc(str)
{
	var tem=str.split("^");
	if (tem[1])
	{ 
		var obj=document.getElementById('locId');
		if (obj) obj.value=tem[1];
		obj=document.getElementById('ctcpId');
		if (obj) obj.value="";
		obj=document.getElementById('firstCtcpDesc');
		if (obj) obj.value="";
	}
}
function GetCtcp(str)
{
	var tem=str.split("^");
	var obj=document.getElementById('ctcpId');
	if ((obj)&&(tem[1])) obj.value=tem[1];
	ctcpDesc=tem[0]
}
function FirstCtcpDescBlur()
{
    var objFirstCtcpDesc=document.getElementById("firstCtcpDesc");
    var objCtcpId=document.getElementById("ctcpId");
	if (objCtcpId){
	    if (objFirstCtcpDesc.value=="") {
		    objCtcpId.value="";;
		    ctcpDesc=""
	    }
	    else{
		    objFirstCtcpDesc.value=ctcpDesc;
		} 
    }
}

function ChangeAdmLocType()
{
	var objChkEmergency=document.getElementById("chkEmergency");
	if (! objChkEmergency) return;
	var objAdmType=document.getElementById("admType");
	if (! objAdmType) return;
	if (objChkEmergency.checked) objAdmType.value="E"
	else objAdmType.value="O"	
}
function PrintClick()
{
	var objtbl=document.getElementById('tDHCADMVisitReg_Find');
	if  (objtbl.rows.length==1) return;
	var xlsExcel,xlsSheet,xlsBook;
	var i,j;
    var  path = GetFilePath();
    var fileName="DHCNurADMReg.xls" 
    fileName=path+ fileName;
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName) 
	xlsSheet = xlsBook.ActiveSheet ;
    var GetItemNum=document.getElementById("GetItemNum").value;
	var num=new Number(cspRunServerMethod(GetItemNum));
	xlsSheet.cells(1,1)=t['val:Date'];
	xlsSheet.cells(1,2)=t['val:Time'];
	xlsSheet.cells(1,3)=t['val:Name'];
	xlsSheet.cells(1,4)=t['val:Sex'];
	xlsSheet.cells(1,5)=t['val:Age'];
	xlsSheet.cells(1,6)=t['val:Adress'];
	xlsSheet.cells(1,7)=t['val:EmergCond'];
	xlsSheet.cells(1,8)=t['val:Arcud'];
	xlsSheet.cells(1,9)=t['val:AdmCtloc'];
	xlsSheet.cells(1,10)=t['val:Doc'];
	xlsSheet.cells(1,11)=t['val:VisitStat'];
	nfontcell(xlsSheet,1,1,1,11,10)
	gridlist(xlsSheet,1,1,1,11)
	nxlcenter(xlsSheet,1,1,1,11)
	for (i=1;i<num+1;i++)
	{
		var GetItem=document.getElementById("GetItem").value; 
		var res=cspRunServerMethod(GetItem,i);
		var data=res.split("^");
		xlsSheet.cells(i+1,1)=data[9];
		xlsSheet.cells(i+1,2)=data[10];
		xlsSheet.cells(i+1,3)=data[1];
		xlsSheet.cells(i+1,4)=data[2];
		xlsSheet.cells(i+1,5)=data[3];
		xlsSheet.cells(i+1,6)=data[4];
		xlsSheet.cells(i+1,7)=data[16];
		xlsSheet.cells(i+1,8)=data[8];
		xlsSheet.cells(i+1,9)=data[11].split("-")[1];
		xlsSheet.cells(i+1,10)=data[13];
		xlsSheet.cells(i+1,11)=data[7];
		nfontcell(xlsSheet,i+1,i+1,1,11,8)
		gridlist(xlsSheet,i+1,i+1,1,11)
	}
    var titleRows = 0;
    var titleCols = 0 ;
	var CenterHeader = "&12"+t['val:Header'];
	var RightHeader="";
	var LeftHeader="";
	var CenterFooter="";
	var LeftFooter="";
	var RightFooter = "";
     ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter);
		
	//xlsExcel.Visible = true;
    //xlsSheet.PrintPreview();
    xlsSheet.PrintOut
    xlsSheet = null;
    xlsBook.Close(savechanges=false);
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
    window.setInterval("Cleanup();",1);     
}
function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}
function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }
document.body.onload = BodyLoadHandler;