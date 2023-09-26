/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.JZQuery.List.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-6-21


============================================================================ */
var intSelectRow = -1;
var strTableName = "tDHC_WMR_JZQuery_List";
var cnt = 0;

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById(strTableName);
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) 
	{
		intSelectRow = -1;
	}
	else
	{
		intSelectRow = selectrow;
	}	
}

function MarkFirstVisit()
{
    var objTable = document.getElementById(strTableName);
    var objCheck = null;
   for(var i = 1; i < objTable.rows.length; i ++)
   {
     objCheck = document.getElementById("FirstVisitz" + i);
     
     objCheck.checked = (document.getElementById("VisitFlagz" + i) .value == "Y");
    } 
}

function GetNeedPrintList()
{
    var objTable = document.getElementById(strTableName);
    var objArry = new Array();
    var objCheck = null;
    for(var i = 0; i < objTable.rows.length; i ++)
   {
     objCheck = document.getElementById("NeedPrintz" + i);
     if(objCheck.checked)
        objArry.push(document.getElementById("RowIDz" + i).value);
    }  
   return objArry; 
}

function cmdAdmitPatientOnClick()
{
    var strRowID = window.event.srcElement.id.replace("cmdAdmitPatientz", "");
    var strPapmiID = getElementValue("Papmiz" + strRowID);
    var strPadmID = getElementValue("Paadmz" + strRowID);
    var strMrType =  GetParam(window, "MRTypeDr");
    var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmitPatient.Main&PatientID=" + strPapmiID + 
                        "&EpisodeID=" + strPadmID +
                        "&MrType="  + strMrType +
                        "&AdmTypeFlag=I||O||E&WorkItem=&RequestType=&AutoTransfer=&AutoRequest=&MultiAdmit=Y&MRChange=N";
    window.open(strUrl, "_blank", "top=100,left=100,height=600,width=850,status=yes,toolbar=no,menubar=no,location=no"); 
}
//add by liuxuefeng	2010-03-18 集团化接诊
function cmdGroupReceiptOnClick()
{
		var CTLocID=session['LOGON.CTLOCID'];
  	var UserId=session['LOGON.USERID'];
    var strRowID = window.event.srcElement.id.replace("cmdGroupReceiptz", "");
    var MrNo = getElementValue("MrNOz" + strRowID);
    var EpisodeID = getElementValue("Paadmz" + strRowID);
    //var strMrType =  GetParam(window, "MRTypeDr");
	  var AdmType="I";
	  //alert("strRowID="+strRowID+";EpisodeID="+EpisodeID+";MrNo="+MrNo+";CTLocID="+CTLocID+";UserId="+UserId);
		var flg=GroupReceipt(CTLocID, EpisodeID, MrNo, UserId, AdmType);
		//alert(flg);
		if (flg>=0){
				alert("接诊成功!");
			}else{
				alert("接诊错误,请联系信息科!错误代码:"+flg);
		}
		window.location.reload();
}


function InitForm()
{
	document.getElementById("clblCount").style.color = "red";
	document.getElementById("lblCount").style.color = "red";
}

function InitEvents()
{
   var objTable = document.getElementById("tDHC_WMR_JZQuery_List"); 
    for(var i = 1; i < objTable.rows.length; i ++)
    {
        document.getElementById("cmdAdmitPatientz" + i).onclick =  cmdAdmitPatientOnClick;
        document.getElementById("cmdGroupReceiptz" + i).onclick =  cmdGroupReceiptOnClick;
        if(Trim(getElementValue("MrNOz" + i)) == "")
        {
	        objTable.rows[i].style.backgroundColor = "hotpink";
	        cnt ++;
	}
    }   
    setElementValue("lblCount", cnt);
    setElementValue("ListRows", objTable.rows.length-1);//add by liuxuefeng 2010-01-28
}

InitForm();
InitEvents();