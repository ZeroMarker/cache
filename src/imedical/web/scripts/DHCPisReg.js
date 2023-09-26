//DHCPisReg.js
var CurrentSel=0
var PatientID,StudyNo;
var RptParm;

function BodyLoadHandler() 
{
	
}

function SelectRowHandler()
{
  	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPisReg');
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	CurrentSel=selectrow;
	var LocDr=document.getElementById('replocdr'+'z'+selectrow).value;
	var TOEOrderDr=document.getElementById('oeorditemdr'+'z'+selectrow).innerText;	
	var TRptCls=document.getElementById('RptCls'+'z'+selectrow).value;

	var reportzlink='Reportz'+selectrow;
	
    if (eSrc.id==reportzlink)
  	{	
	   	GetRptParm(LocDr,TOEOrderDr,TRptCls);

			window.open(RptParm);
			return false;
  	}
  	else
  	{
	
		}
}
function bodyunload()
{

}


function GetRptParm(cLocDr,TOEOrderDr,TRptCls)
{
	RptParm = "";
	RptParm ='http://172.26.201.3/PISWeb/Default.aspx?OID='+  TOEOrderDr +'&LOCID='+cLocDr+'&RPTID='+TRptCls;
	
}

document.body.onload = BodyLoadHandler;
document.body.onunload= bodyunload;