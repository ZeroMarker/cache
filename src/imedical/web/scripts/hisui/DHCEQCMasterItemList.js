/// -------------------------------
/// Created By HZY 2011-07-27  HZY0003 ?
/// --------------------------------
var SelectedRow = -1 ;  //hisui-���� modified by kdf 2018-03-01

function BodyLoadHandler() 
{
	//document.body.scroll="no";	
	InitUserInfo();	
	$("#tDHCEQCMasterItemList").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //add by lmm 2018-09-26 hisui���죺���ط�ҳ������

}
function SelectRowHandler(index,rowdata)
{
	Selected(index , rowdata);
}
function Selected(selectrow, rowdata)
{	
	if (SelectedRow==selectrow)	
	{	
		SelectedRow=-1;
		
		var HospitalID=window.parent.DHCEQCMasterItem.document.getElementById("Hold2").value
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&EquipTypeDR="+""+"&Hold2="+(HospitalID)+"&ReadOnly="+GetElementValue("ReadOnly")+"&EquipAttributeString="+GetElementValue("EquipAttributeString")+"&EquipAttributeFlag="+GetElementValue("EquipAttributeFlag");	// Mozy	1066474	2019-10-26
		parent.DHCEQCMasterItem.location.href=lnk;
		$('#tDHCEQCMasterItemList').datagrid('unselectAll');  //hisui���� add by kdf 
	}
	else
	{
		SelectedRow=selectrow;
		
		//var varID=GetElementValue("TIDz"+selectrow);
		var varID=rowdata.TID   //hisui���� add by kdf
		var HospitalID=window.parent.DHCEQCMasterItem.document.getElementById("Hold2").value ;
		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&EquipTypeDR="+(varID)+"&Hold2="+(HospitalID)+"&ReadOnly="+GetElementValue("ReadOnly")+"&EquipAttributeString="+GetElementValue("EquipAttributeString")+"&EquipAttributeFlag="+GetElementValue("EquipAttributeFlag");	// Mozy	1066474	2019-10-26
		parent.DHCEQCMasterItem.location.href=lnk;
	}		
}
document.body.style.padding="10px 5px 10px 10px" //// hisui-���� add by kdf 2018-11-09   ��������� �� �� �� �ڱ߾�
document.body.onload = BodyLoadHandler;