var ComponentID=""

function findHandler() {
	var obj=document.getElementById("PatientNo");
	if (obj.value.length>0) obj.value=FormatAdmNo(obj.value);
	return
	return Find_click();
}

function LoadHandler1() {
	var obj=document.getElementById("Find");
	//if(obj) obj.onclick=findHandler;
	//
	//"tDHCDocWorkBench"
	var tbl=document.getElementById("tDHCPEDocPatientList");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
	//add by lxl 20121130	
	for (i=1;i<tbl.rows.length;i++)
	{
		var eSrc=tbl.rows[i];
	    var RowObj=getRow(eSrc);
	    RowObj.className="Green";
	}
	
	ColorTblColumn(tbl,'PAAdmReasonCode','PAAdmReason')	//
	//preferences exist...
	//
	//var ComponentID="";
	var WorkComponent=document.getElementById("WorkComponent");
	if (WorkComponent) {ComponentID=WorkComponent.value;}
	
	var obj=document.getElementById("PatientNo");
	if (obj) obj.onkeydown=KeyDown_Find;
	var obj=document.getElementById("SurName");
	if (obj) obj.onkeydown=KeyDown_Find;
	
	var obj=document.getElementById("GroupName");
	if (obj) obj.onchange=GroupNameChanged;
	var obj=document.getElementById("TeamName");
	if (obj) obj.onchange=TeamNameChanged;
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_keydown;}


	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	SetSort("tDHCPEDocPatientList","TTotal")
	//initialReadCardButton()
	Muilt_LookUp('GroupName'+'^'+'TeamName'+'^'+'DepName');
	websys_setfocus("PatientNo");
}
function SetSort(TableName,ItemName)
{
	var objtbl=document.getElementById(TableName);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ItemName+"z"+j);
		if (obj) obj.innerText=j;	
	}
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change()
	}
}

function CardNo_Change()
{
	CardNoChangeApp("PatientNo","CardNo","Find_click()","Clear_click()","0");
    var obj=document.getElementById("PatientNo");
	if (obj)
	{  
	
	  if (obj.value!="")
       {   
	       DHC_AutoSelectPat(obj.value)}	   
	}
	

}
function ReadCard_Click()
{
	ReadCardApp("PatientNo","Find_click()","CardNo");
    var obj=document.getElementById("PatientNo");
	if (obj)
	{  
	
		if (obj.value!="")
       {   
	       DHC_AutoSelectPat(obj.value)}	   
	}
	
}

function AfterGroupSelected(value){
	//ROWSPEC = "GBI_Desc:%String, GBI_Code:%String, GBI_RowId:%String"	
	if (""==value){return false}
	var aiList=value.split("^");
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=aiList[0];
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=aiList[1];
	/*var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[2],true);
	SetCtlValueByID("txtGroupName",aiList[0],true);*/
}
function AfterItemSelected(value){
	if (""==value){return false}
	
	var aiList=value.split("^");
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=aiList[1];
	var obj=document.getElementById("TeamName");
	if (obj) obj.value=aiList[0];
	
}
function GroupNameChanged()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamName");
	if (obj) obj.value="";
}
function TeamNameChanged()
{
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
}
function KeyDown_Find(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		Find_click();
	}
}
function ColorTblColumn(tbl,ColName1,ColName2)	{
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	//for (var j=1;j<RowItems.length;j++) {
	//	if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
	//		alert(RowItems[j].style.color)
	//		RowItems[j].style.color="red";
	//	}
	//}
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable1=document.getElementById(ColName1+'z'+j);
		var sLable2=document.getElementById(ColName2+'z'+j);
		var sTD2=sLable2.parentElement;
		var PatType=sLable1.value;
		if (PatType=='Govement') {sTD2.className="Govement"};
		if (PatType=='Insurance') {sTD2.className="Insurance"};
		if (PatType=='Private') {sTD2.className="Private"};
	}
}

function DHC_SelectPat()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow !=0) {
		var PatientID="";
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		var mradmObj=document.getElementById("mradmz"+selectrow);
	
		var SelectObj=document.getElementById("Selectz"+selectrow);
		var StatusObj=document.getElementById("WalkStatusz"+selectrow);
	//{
			if (PatientObj) PatientID=PatientObj.value;
			if (EpisodeObj) EpisodeID=EpisodeObj.value;
			if (mradmObj) mradm=mradmObj.value ;  
			
			var encmeth="";
			/*
			var obj=document.getElementById("IsChecking");
			if (obj)
			{
				encmeth=obj.value;
				if (session['LOGON.GROUPDESC']=="体检总检医生")
				
				{  
					var Ret=cspRunServerMethod(encmeth,EpisodeID,"N")
					
					if (Ret!="0")
					{
						if (!(confirm("此人正被"+Ret+"总检,继续总检?")))
						{  return false; }
						else
						{
							cspRunServerMethod(encmeth,EpisodeID,"Y")
						}
					}
				}
			}*/
			var lnk = "dhcpe.epr.chartbook.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//var lnk="websys.csp?a=a&TMENU=133%BuildIndices方法2&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			var lnk = "dhcpedocpatient.zj.csp?PAADM="+EpisodeID;
			var wwidth=screen.width-10;
			var wheight=screen.height-10;
			var xposition = (screen.width - wwidth) / 2;
			var yposition = (screen.height - wheight) / 2;
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
			var cwin=window.open(lnk,"_blank",nwin)	
			return true;
		//}
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow !=0) {
		//
		var PatientID="";
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		var mradmObj=document.getElementById("mradmz"+selectrow);
		if (PatientObj) PatientID=PatientObj.value;
		if (EpisodeObj) EpisodeID=EpisodeObj.value;
		if (mradmObj) mradm=mradmObj.value ;  
		//
		var PAPMINameObj=document.getElementById("PAPMINamez"+selectrow);
		var PAPMINOObj=document.getElementById("PAPMINOz"+selectrow);
		var Patient=PAPMINOObj.innerText+' '+PAPMINameObj.innerText;
		
		var obj=document.getElementById("Selectz"+selectrow);
		if (obj) obj.onclick=Select_click;

	}
	ChangeCheckStatus("Select");
}
function Select_click()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById("Selectz"+selectrow);
	
	if (obj) obj.checked=!obj.checked;
}


// 打印个人汇总报告
function IReportAll()
{
	var PatientID,EpisodeID,mradm
	var lnk=""; 
	lnk = "dhcpecallrpt.csp&PatientID="+PatientID
			+"&EpisodeID="+EpisodeID
			+"&mradm="+mradm;
			;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	//window.open(lnk,"_blank",nwin)


	
}
function GetIPAddress()	{
			var SetSkipStatus=document.getElementById('SetSkipStatus');
			if (SetSkipStatus) {var encmeth=SetSkipStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID);
}
function UnLoadHandler()	{
	alert('Now unload Window!!');
}
/*
function DHC_AutoSelectPat(PatientID)	{
   
	var obj=document.getElementById('GetAdmInfoByReg');
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	var Return=cspRunServerMethod(encmeth,PatientID);
    var mradm=Return
    if (mradm==""){return;}
    var EpisodeID=mradm
	var encmeth="";
	var obj=document.getElementById("IsChecking");
	if (obj)
			{
				encmeth=obj.value;
				if (session['LOGON.GROUPDESC']=="体检总检医生")
				{
					var Ret=cspRunServerMethod(encmeth,EpisodeID,"N")
					if (Ret!="0")
					{
						if (!(confirm("此人正被"+Ret+"总检,继续总检?")))
						{  return false; }
						else
						{
							cspRunServerMethod(encmeth,EpisodeID,"Y")
						}
					}
				}
			}
		
			
		   var lnk = "dhcpe.epr.chartbook.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//var lnk="websys.csp?a=a&TMENU=1332&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			window.location=lnk;
			return true;
			var wwidth=screen.width-10;
			var wheight=screen.height-10;
			var xposition = (screen.width - wwidth) / 2;
			var yposition = (screen.height - wheight) / 2;
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
			var cwin=window.open(lnk,"_blank",nwin)	
			return true;
	
}
*/
document.body.onload=LoadHandler1;
document.body.onunload=UnLoadHandler;
