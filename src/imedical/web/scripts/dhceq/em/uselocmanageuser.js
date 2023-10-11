var columns=getCurColumnsInfo('PLAT.G.UseLocManageUser','','','')
$(document).ready(function()
{
	initDocument();
})

function initDocument()
{
	initUserInfo();
    initLookUp(); //初始化放大镜
	defindTitleStyle();
    initButton(); //按钮初始化
    initButtonWidth();
    initDatagrid();
	$("#BExport").on("click", BExport_Clicked);
}

function initDatagrid()
{
	$HUI.datagrid("#DHCEQUseLocManageUser",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
			QueryName:"UseLocManageUser",
			ParamGroupID:getElementValue("GroupDR"),
			ParamLocID:getElementValue("UseLocDR"),
			ParamUserID:getElementValue("UserDR"),
			ParamJob:getElementValue("Job")
		},
    	border:false,
		rownumbers: true,
		singleSelect:true,
		fit:true,
		columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75]
	});
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")	
}

function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQUseLocManageUser",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
			QueryName:"UseLocManageUser",
			ParamGroupID:getElementValue("GroupDR"),
			ParamLocID:getElementValue("UseLocDR"),
			ParamUserID:getElementValue("UserDR"),
			ParamJob:getElementValue("Job")
		}
	})
}

function BExport_Clicked()
{
}