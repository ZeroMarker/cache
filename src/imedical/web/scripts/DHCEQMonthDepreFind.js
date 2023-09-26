var SelectedRow = 0;
var EquipDR=GetElementValue("EquipRowID"); 
var DepreSetId=GetElementValue("DepreSetId"); 
var DepreMethodId=GetElementValue("DepreMethodId");   
var CostAllotId=GetElementValue("CostAllotId");   
var PreDepreMonth=GetElementValue("PreDepreMonth"); 

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMonthDepreFind');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}
function Selected(selectrow)
{	
	if (SelectedRow==selectrow)	{			
		SelectedRow=0;
		parent.DHCEQMonthDepre.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMonthDepre&RecordID=&EquipDR="+EquipDR+"&DepreSetId="+DepreSetId+"&DepreMethodId="+DepreMethodId+"&CostAllotId="+CostAllotId+"&PreDepreMonth="+PreDepreMonth;		
		}
	else{
		SelectedRow=selectrow;		
		var recordID=GetElementValue("TRowIDz"+SelectedRow);
		parent.DHCEQMonthDepre.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMonthDepre&RecordID="+recordID+"&EquipDR=&DepreSetId=&DepreMethodId=&CostAllotId=&PreDepreMonth=";	
		}		
}