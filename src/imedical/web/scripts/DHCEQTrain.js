var SelectedRow = 0;
var rowid=0;
function BPrint1_Clicked()
{
	
}
function OtherSet()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
}
function BFind_Clicked()
{
	var SourceID=GetElementValue("SourceID")
    var SourceListID=GetElementValue("SourceListID")
    var SourceStatus=GetElementValue("SourceStatus")
    var ComponentName=GetElementValue("ComponentName")
    var TrainUser=GetElementValue("F_TrainUser")
    var TrainTitle=GetElementValue("F_TrainTitle")
    var TrainDate=GetElementValue("F_TrainDate")
    var TrainEquip=GetElementValue("F_TrainEquip")
    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus+'&TrainUser='+TrainUser+'&TrainDate='+TrainDate+'&TrainTitle='+TrainTitle+'&TrainEquip='+TrainEquip;
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQTrain');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("SourceListID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TSourceIDz"+SelectedRow);
		SetData(rowid);//µ÷ÓÃº¯Êý
		}
}
function Clear()
{
	SetElement("F_TrainAddress","");
	SetElement("F_TrainDate","");
	SetElement("F_TrainUser","");
	SetElement("F_TrainTitle","");
	SetElement("F_Remark","");
	SetElement("F_TrainContent","");
	SetElement("F_TrainEquip","");
}
function SetData(rowid)
{
	SetElement("SourceListID",rowid)
	FillData()
}
function CheckData()
{
	return 0;
}