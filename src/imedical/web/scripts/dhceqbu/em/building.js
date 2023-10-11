$(function(){
	initDocument();
});
function initDocument()
{
	jQuery("#BSave").linkbutton({iconCls: 'icon-w-save'}); //add hly 2019-9-9
	jQuery("#BSave").on("click",BSave_Clicked); //add hly 2019-9-9
	fillData();
	//initButton(); //modified by sjh SJH0027 2020-06-12 
	setRequiredElements("BBuildingArea"); //������
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly=="1")
	{
		disableElement("BSave",true);
	}

};

function fillData()
{
	var BRowID=getElementValue("BRowID");
	if (BRowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCDT3D.BUSBuilding","GetOneBuilding",BRowID);
	if (jsonData=="") return; //modify by sjh 2019-10-17  ����ţ�1013659
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData=="") return;
	if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
	setElementByJson(jsonData.Data);
}

function BSave_Clicked()
{
	if (getElementValue("BBuildingArea")=="")
	{
		messageShow("alert","error","��ʾ","�����������Ϊ��!"); //modify hly 2019-9-9
		return
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCDT3D.BUSBuilding","SaveData",data);
	if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data);return;}
	window.location.reload();
}