
var Columns=getCurColumnsInfo('PLAT.G.Product','','','')
jQuery(document).ready(function()
{
	initDocument();
})

function initDocument()
{
	initUserInfo();
    //initMessage(""); //获取所有业务消息
    //initLookUp("MRObjLocDR_LocDesc^MRExObjDR_ExObj^"); //初始化放大镜
    initLookUp(); //初始化放大镜
	defindTitleStyle(); 
    //initButton(); //按钮初始化
    jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
    initButtonWidth();
    initDatagrid()
}
function initDatagrid()
{
	$HUI.datagrid("#DHCEQPLATCProduct",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTProduct",
			QueryName:"GetProduct",
			Desc:getElementValue("PDesc"),
			AssetItemID:getElementValue("PAssetItemDR_AIDesc"),    // modify by mwz 2020-04-09 MWZ0033
			BrandID:getElementValue("PBrandDR")
		},
    	border:false,      //MODIFY BY MWZ 2020-04-19 MWZ0035
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		columns:Columns,
		pagination:true,
		pageSize:15,
		pageNumber:15,
		pageList:[15,30,45,60,75]
	});
}
function setSelectValue(elementID,rowData)
{
	if(elementID=="PAssetItemDR_AIDesc") {setElement("PAssetItemDR",rowData.TRowID)}
	else if(elementID=="PBrandDR_BDesc") {setElement("PBrandDR",rowData.TRowID)}
}

//hisui.common.js错误纠正需要
function clearData(str)
{
	if((str)=="PBrandDR_BDesc") {setElement("PBrandDR","")}

} 
function BFind_Clicked()
{
	initDatagrid()
}
