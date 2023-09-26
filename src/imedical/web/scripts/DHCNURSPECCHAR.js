/**
 * @author Administrator
 */
var IfCanAdd="";
var IfCanAdd=document.getElementById('IfCanAdd');
if (IfCanAdd){
	IfCanAdd=cspRunServerMethod(IfCanAdd.value,session['LOGON.USERID']);
}
var grid;
function BodyLoadHandler() {
		setsize("mygridpl", "gform", "mygrid");
		// fm.doLayout();
		var but1 = Ext.getCmp("mygridbut1");
		but1.hide();
		var but = Ext.getCmp("mygridbut2");
		but.setText("保存");
		but.hide();
		grid = Ext.getCmp('mygrid');
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
		tobar.addItem(
		'特珠字符', {
				xtype : 'textfield',
				id : 'mygriddesc',
				fieldLabel : '特珠字符'
			});
		if (IfCanAdd=="Y")
		{
			tobar.addButton({
				className : 'new-topic-button',
				text : "增加",
				handler : charadd,
				id : 'mygridAdd'
			});
			tobar.addButton({
				className : 'new-topic-button',
				text : "修改",
				handler : chardate,
				id : 'mygridSave'
			});
			tobar.addButton({
				className : 'new-topic-button',
				text : "删除",
				handler : chardelete,
				id : 'mygridDelete'
			});
		}
		//tobar.addButton({
		//	className : 'new-topic-button',
		//	text : "插入",
		//	handler : charinsert,
		//	id : 'mygridInsert'
		//});
		//// tobar.render(grid.tbar);
		tobar.doLayout();
		grid.addListener('rowclick', rowClickFn);
		find();
}
var REC = new Array();
function rowClickFn(grid, rowIndex, e) {
	//alert('你单击了' + rowIndex);
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var mygriddesc = Ext.getCmp("mygriddesc");
	mygriddesc.setValue(rowObj[0].get("desc"));
	recId = rowObj[0].get("rw");
}
function find() {
	REC = new Array();
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var a = cspRunServerMethod(GetQueryData.value,"User.DHCTEMPSPECIALCHAR:CRItem", "", "AddRec");
	mygrid.store.loadData(REC);
}
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	REC.push(obj);
}

function charadd() {
	recId = "";
	save();
}
function chardate() {
	save();
}
function save() {
	var grid = Ext.getCmp("mygrid");
	var mygriddesc = Ext.getCmp("mygriddesc");
	if (mygriddesc.getValue() == "") {
		Ext.Msg.alert('提示', "请填写一个'特殊字符'!");
		return;
	};
	var Save = document.getElementById('Save');
	if (Save) {
		var ee=cspRunServerMethod(Save.value,mygriddesc.getValue(),recId);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	clearscreen();
	find();
}
function chardelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var objDelete = document.getElementById('Delete');
	if (objDelete)
	{
		var ee = cspRunServerMethod(objDelete.value, recId);
		if (ee != "0") {
			alert(ee);
			return;
		}
 	}
	clearscreen();
	find();
}
function charinsert() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var mygriddesc = Ext.getCmp("mygriddesc");
	Ext.Msg.alert('提示', mygriddesc.value);
}
function clearscreen() {
	var mygriddesc = Ext.getCmp("mygriddesc");
	if (mygriddesc) mygriddesc.setValue("");
}