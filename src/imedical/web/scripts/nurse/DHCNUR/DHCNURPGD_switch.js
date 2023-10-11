function setvalue()
{
	var ret=tkMakeServerCall("NurMp.Config","GetFlag");

	if (ret=="0") {var value="关";}
	else{var value="开";}
	var Item1=Ext.getCmp("Item1");
	Item1.setValue(value);
	
}
function BodyLoadHandler(){
	
	var Item5 = Ext.getCmp("Item5");
	Item5.on('click', save);
	
	setvalue();
}
function save()
{

	var Item1=Ext.getCmp("Item1");
	
	if (Item1.value=="开") {var flag="1";}
	else  {var flag="0"}
	
	var ret=tkMakeServerCall("NurMp.Config","UpgradeSet",flag);
	
	if (ret=="0") {alert("保存成功！")}
    else {alert("保存失败！")}

	//find();
	return;
}
