/**
 * @author Administrator
 */
function BodyLoadHandler(){
	var but = Ext.getCmp("_Button5");
	but.setText("保存");
	but.on('click', save);
	loadset();
}
function loadset()
{
	var dbip=Ext.getCmp("dbip");
	var webip=Ext.getCmp("webip");
	var getSet=document.getElementById('getSet');
 	var a=cspRunServerMethod(getSet.value);
	if (a != "") {
		var ar = a.split("^");
		dbip.setValue(ar[0]);
		webip.setValue(ar[1]);
		//alert(webip.value);
		//debugger;
	}

}
function save()
{
	var dbip=Ext.getCmp("dbip");
	var webip=Ext.getCmp("webip");
	var saveset=document.getElementById('SetSave');
	var parr="ServerDB|"+dbip.getValue()+"^WebServer|"+webip.getValue();
 	var a=cspRunServerMethod(saveset.value,parr);

}
