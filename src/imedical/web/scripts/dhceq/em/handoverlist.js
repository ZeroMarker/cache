var handoverlistColumns=getCurColumnsInfo('EM.G.HandOver.HandOverList','','',''); 
var editIndex=undefined;
var modifyBeforeRow = {};
var GlobalObj = {
	HOEquipStatusDesc : [{"value":"0","text":"Õý³£"},{"value":"1","text":"Òì³£"}],	

}
$(document).ready(function () {
	initDocument();
});
function initDocument()
{	
	initUserInfo(); 
	defindTitleStyle(); 
	initButton(); 
    initButtonWidth();
	initHandOverList();

}
function initHandOverList()
{
	$HUI.datagrid("#tDHCEQHandOverList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.EM.BUSHandOver",
    	QueryName:"GetHandOverList",
    	vLocDR:"",	
		SDate:getElementValue("SDate"),
		EDate:getElementValue("EDate")
	},
    fit:true,
    singleSelect:false,
    rownumbers: true,
    columns:handoverlistColumns,
	pagination:true,
	pageSize:20,
	pageNumber:1,
	pageList:[20,40,60,80],	
});
	$('#tDHCEQHandOverList').datagrid('showColumn','HOUser');
	$('#tDHCEQHandOverList').datagrid('hideColumn','TCk');
}
function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQHandOverList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.EM.BUSHandOver",
    	QueryName:"GetHandOverList",
    	vLocDR:"",	
		SDate:getElementValue("SDate"),
		EDate:getElementValue("EDate")
	}
	});
}
