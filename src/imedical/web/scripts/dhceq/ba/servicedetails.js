/// add by ZY0281 20211018
var Columns=getCurColumnsInfo('BA.G.ServerItem.ServerDetails','','','')
var ServiceItemID=getElementValue("ServiceItemID")
jQuery(document).ready(function()
{
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	defindTitleStyle();
	initUserInfo();
	initButton();
	initDHCEQCServiceDetailsGrid();
}

function initDHCEQCServiceDetailsGrid()
{
	$HUI.datagrid("#tDHCEQCServiceDetails",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.CTServiceDetails",
			QueryName:"GetServiceDetails",
			ServiceItemID:ServiceItemID,
			HospID:curSSHospitalID,	//增加院区参数取值 add by zy 20220808 	2835289
		},
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
	    columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
