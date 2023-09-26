/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.QueryByNo1.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-21
========================================================================= */
var intSelectRow = -1;

var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","HistoryQueryByNo1");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]+"||"+tmpChinese[3]);
//alert(tmpChinese[4]+"||"+tmpChinese[5]+"||"+tmpChinese[6]+"||"+tmpChinese[7]);


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHC_WMR_History_QueryByNo');
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

function BuildMrBaseInfo()
{
	var tmp = "";
	tmp += tmpChinese[0] + getElementValue("MrNo" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[1] + getElementValue("RegNo" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[2] + getElementValue("Name" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[3] + getElementValue("Sex" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[4] + getElementValue("Birthday" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[5] + getElementValue("PersonalID" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[6] + getElementValue("Company" + "z" + intSelectRow) + "\n";
	tmp += tmpChinese[7] + getElementValue("Address" + "z" + intSelectRow) + "\n";
	return tmp;
}	

function cmdCloseOnClick()
{
	window.close();
}

function cmdSelectOnClick()
{
	var strMrNo = "";
	var strPatientNo = "";
	var strPapmi = "";
	var strDetail = "";
	if(intSelectRow == -1)
	{
		window.alert(t['NotSelectInfo']);
	}
	else
	{
		strMrNo = getElementValue("MrType" + "z" + intSelectRow);
		strPatientNo = getElementValue("strRegNo" + "z" + intSelectRow);
		strPapmi = getElementValue("PapmiDr" + "z" + intSelectRow);
		//strDetail = BuildMrBaseInfo();
		window.opener.document.getElementById("txtMRInfo").value = getElementValue("RowID" + "z" + intSelectRow);//strMrNo + "^" + strPatientNo + "^" + strPapmi;
		//window.opener.document.getElementById("txtMRInfo").value = strDetail;
		window.opener.document.getElementById("txtMRegNo").innerText = getElementValue("RegNo" + "z" + intSelectRow);
		window.opener.document.getElementById("txtMName").innerText = getElementValue("Name" + "z" + intSelectRow);
		window.opener.document.getElementById("txtMSex").innerText = getElementValue("Sex" + "z" + intSelectRow);
		window.opener.document.getElementById("txtMPersonalID").innerText = getElementValue("PersonalID" + "z" + intSelectRow);
		window.opener.document.getElementById("txtMCompany").innerText = getElementValue("Company" + "z" + intSelectRow);
		window.opener.document.getElementById("txtMAddress").innerText = getElementValue("Address" + "z" + intSelectRow);
		window.opener.document.getElementById("txtMBirthday").innerText = getElementValue("Birthday" + "z" + intSelectRow) ;
		window.close();	
	}
}


function InitEvent()
{
	document.getElementById("cmdSelect").onclick = cmdSelectOnClick;
	document.getElementById("cmdClose").onclick = cmdCloseOnClick;
	
}

InitEvent();