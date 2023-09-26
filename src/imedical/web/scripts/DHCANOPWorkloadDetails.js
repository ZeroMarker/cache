document.body.onload = BodyLoadHandler;
var stdate="",enddate=""
var ctlocId=session['LOGON.CTLOCID'];
var opaId="",adm="",patType="";

function BodyLoadHandler()
{
	var objstdate=document.getElementById("stdate");
	var objenddate=document.getElementById("enddate");
    var today=document.getElementById("getToday").value;
    if (objstdate.value=="") {objstdate.value=today;}
    if (objenddate.value=="") {objenddate.value=today;}
    stdate=objstdate.value;
    enddate=objenddate.value;
	var obj=document.getElementById('btnSch');
	if (obj) {obj.onclick=btnSch_Click;}
	var obj=document.getElementById('btnPaidDetails');
	if (obj) {obj.onclick=btnPaidDetails_Click;}
}
function btnSch_Click()
{
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	var careprovdr=document.getElementById("careprovdr").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPWorkloadDetails&stratdate="+stdate+"&enddate="+enddate+"&andocId="+careprovdr+"&ctlocId="+ctlocId;
	location.href=lnk; 
}
function GetCareprovdesc(str)
{
	var careprovStr=str.split("^");
	var obj=document.getElementById("careprovdesc")
	obj.value=careprovStr[1];
	var obj=document.getElementById("careprovdr")
	if(obj) obj.value=careprovStr[0];
}
function btnPaidDetails_Click()
{
	if ((opaId=="")||(adm==""))
	{
	   alert("请选择一个病人");
	   return;
	}
	else
	{
		if(patType=="O")
		{
			alert("门诊病人清楚HIS程序查看费用明细!");
			return;
		}
		else
		{
			var retRef=-1,flag=1;
			var lnk= "../csp/dhcoperprice.csp?EpisodeID="+adm+"&OPERNo="+opaId+"&REF="+"-1"+"&FLAG="+"0"+"&STAT="+"F";
			window.open(lnk,'','');	
		}
	}
}
function SelectRowHandler()
{
	var objtbl=document.getElementById('tDHCANOPWorkloadDetails');
    var eSrc=window.event.srcElement;
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    //var selrow=document.getElementById("selRow");
    //selrow.value=DHCWeb_GetRowIdx(window);
    //careprovdr=document.getElementById("ctctpdrz"+selectrow).innerText;
    //careprovdr=document.getElementById("ctctpdrz"+selectrow).value;
    opaId=document.getElementById("opaIdz"+selectrow).innerText;
    adm=document.getElementById("admz"+selectrow).innerText;
    patType=document.getElementById("patTypez"+selectrow).innerText;
    
}