var SelectedRow = 0;
var varTabName=""; //����
var varTabNameStr=""; //����
var varPreFix="";  //ǰ׺
var varType="";    //����
var varReadOnly="";//ֻ��

function BodyLoadHandler() 
{
	document.body.scroll="no";	
	InitUserInfo();	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCodeTableList');
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
		varTabName="";
		varPreFix=""	
		varType="1";
		varReadOnly="";
		parent.DHCEQCCodeTable.location.href="websys.default.csp"

		//SetData();			
		}
	else{
		SelectedRow=selectrow;		
		varTabNameStr=GetCElementValue("TCodeDescz"+selectrow);
		varTabName=GetElementValue("TCodeNamez"+selectrow);		
		varPreFix=GetElementValue("TShortDescz"+selectrow);
		varType=GetElementValue("TTypez"+selectrow);
		varReadOnly=GetElementValue("TReadOnlyz"+selectrow);
		SetData();		
		}		
}
function SetData()	{
	if(varType=="1")
	{
		//��׼�����
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCCodeTable&TabName="+(varTabName)+"&PreFix="+(varPreFix)+"&ReadOnly="+(varReadOnly)+"&titleName="+(varTabNameStr);
		parent.DHCEQCCodeTable.location.href=lnk;
	}
	else
	{
		var value=varTabName.split("_")
		if(value.length>2)
		{
			alertShow('������ı���,��������Χ!');
			return;
		}
		if(varType=="2")
		{
			//�Ǳ�׼�����				
			parent.DHCEQCCodeTable.location.href="websys.default.csp?WEBSYS.TCOMPONENT=" + value[0] + value[1]+"&ReadOnly="+(varReadOnly);
			
		}
		else
		{
			//csp page
			var varUrl=value[0] + value[1]+".csp?ReadOnly="+(varReadOnly);
			parent.DHCEQCCodeTable.location.href=varUrl;
		}
	}
}
document.body.onload = BodyLoadHandler;