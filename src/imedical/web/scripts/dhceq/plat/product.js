///modified by ZY   2826780  20220926
///产品界面重做，可以直接替换
var PreSelectedRowID = "";
var Columns=getCurColumnsInfo('PLAT.G.Product','','','')
jQuery(document).ready(function()
{
    initDocument();
})

function initDocument()
{
    initUserInfo();
    initMessage(""); //获取所有业务消息
    initLookUp(); //初始化放大镜
    defindTitleStyle(); 
    initButton(); //按钮初始化
    initButtonWidth();
    initDatagrid()
}
function initDatagrid()
{
    var lnk=GetLnk()
    $HUI.datagrid("#DHCEQPLATCProduct",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCEQ.Plat.CTProduct",
            QueryName:"GetProduct",
            vData:lnk,
            SourceType:getElementValue("SourceType"),
            SourceID:getElementValue("SourceID"),
        },
        border:false,      //MODIFY BY MWZ 2020-04-19 MWZ0035
        rownumbers: true,  //如果为true，则显示一个行号列。
        singleSelect:true,
        fit:true,
        columns:Columns,
        onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            //fillData_OnClickRow(rowIndex, rowData);
        },
        pagination:true,
        pageSize:15,
        pageNumber:1,	//modified by ZY20221206 bug:3136080
        pageList:[15,30,45,60,75]
    });
}

function GetLnk()
{
    var lnk="";
    lnk=lnk+"^PDesc="+getElementValue("PDesc");
    lnk=lnk+"^PManufactoryDR="+getElementValue("PManufactoryDR");
    lnk=lnk+"^PModels="+getElementValue("PModels"); 
    return lnk
}
function setSelectValue(elementID,rowData)
{
    if(elementID=="PAssetItemDR_AIDesc") {setElement("PAssetItemDR",rowData.TRowID)}
    else if(elementID=="PBrandDR_BDesc") {setElement("PBrandDR",rowData.TRowID)}
    else if(elementID=="PManufactoryDR_VDesc") {setElement("PManufactoryDR",rowData.TRowID)}
    else {setDefaultElementValue(elementID,rowData)}
}
//hisui.common.js错误纠正需要
function clearData(str)
{
    if((str)=="PBrandDR_BDesc") {setElement("PBrandDR","")}
    else if((str)=="PManufactoryDR_VDesc") {setElement("PManufactoryDR","")}
}
function BFind_Clicked()
{
    initDatagrid()
}
