//DHCRisOrdAppSet.js

function BodyLoadHandler()
{
	
}
// ѡ��ҽ������
function SelectOrdCat(Info)
{
	Item=Info.split("^");
    document.getElementById("ItemCat").value=Item[1];
    document.getElementById("ItemCatID").value=Item[0];
}

//ѡ������
function SelectOrdSubCat(Info)
{
	Item=Info.split("^");
    document.getElementById("ItemSubCat").value=Item[1];
    document.getElementById("SubCatID").value=Item[0];

}

//ѡ��ҽ����Ŀ
function SelectOrdItem(Info)
{
    Item=Info.split("^");
    document.getElementById("OrdName").value=Item[1];
    document.getElementById("ArcItemID").value=Item[0];
	
}

//ѡ�����뵥��ʽID
function SelectAppID(Info)
{
	Item=Info.split("^");
    document.getElementById("Appshape").value=Item[1];
    document.getElementById("AppShapeRowid").value=Item[0];
}


document.body.onload = BodyLoadHandler;