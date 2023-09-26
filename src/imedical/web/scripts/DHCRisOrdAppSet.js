//DHCRisOrdAppSet.js

function BodyLoadHandler()
{
	
}
// 选择医嘱大类
function SelectOrdCat(Info)
{
	Item=Info.split("^");
    document.getElementById("ItemCat").value=Item[1];
    document.getElementById("ItemCatID").value=Item[0];
}

//选择子类
function SelectOrdSubCat(Info)
{
	Item=Info.split("^");
    document.getElementById("ItemSubCat").value=Item[1];
    document.getElementById("SubCatID").value=Item[0];

}

//选择医嘱项目
function SelectOrdItem(Info)
{
    Item=Info.split("^");
    document.getElementById("OrdName").value=Item[1];
    document.getElementById("ArcItemID").value=Item[0];
	
}

//选择申请单样式ID
function SelectAppID(Info)
{
	Item=Info.split("^");
    document.getElementById("Appshape").value=Item[1];
    document.getElementById("AppShapeRowid").value=Item[0];
}


document.body.onload = BodyLoadHandler;