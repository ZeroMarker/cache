/**
 * @author Administrator
 */
var grid;
var recId;
var qttypdata = new Array();
var GetQtTyp = document.getElementById('GetQtTyp');
if (GetQtTyp) {
	cspRunServerMethod(GetQtTyp.value, 'addqttyp');
}
function addqttyp(a, b) {
	qttypdata.push({
				typ : a,
				typdes : b
			});
}
var storeqttyp = new Ext.data.JsonStore({
			data : qttypdata,
			fields : ['typ', 'typdes']
		});
var typField = new Ext.form.ComboBox({
			id : 'typsys',
			hiddenName : 'typ1',
			store : storeqttyp,
			width : 100,
			fieldLabel : '事件',
			valueField : 'typ',
			displayField : 'typdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0];
	//debugger;
}
function BodyLoadHandler() {
		setsize("mygridpl", "gform", "mygrid");
		// fm.doLayout();
		var but1 = Ext.getCmp("mygridbut1");
		but1.hide();
		var but = Ext.getCmp("mygridbut2");
		but.setText("保存");
		but.hide();
		grid = Ext.getCmp('mygrid');
		grid.setTitle(gethead());
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
		tobar.addItem(
		{
			xtype:'datefield',
			format: 'Y-m-d',
			id:'mygriddate',
			value:(diffDate(new Date(),0))
		},'-',
		{
			xtype:'timefield',
			width:100,
			format: 'H:i',
			value:'0:00',
			id:'mygridtime'
		},'-','事件', typField,'-');
		tobar.addButton({
			className : 'new-topic-button',
			text : "增加",
			handler : typadd,
			id : 'mygridAdd'
		});
		tobar.addButton({
			className : 'new-topic-button',
			text : "修改",
			handler : typupdate,
			id : 'mygridSave'
		});
		tobar.addButton({
			className : 'new-topic-button',
			text : "删除",
			handler : typdelete,
			id : 'mygridDelete'
		});
		// tobar.render(grid.tbar);
		tobar.doLayout();
		grid.addListener('rowclick', rowClickFn);
		find();
}
var REC = new Array();
function rowClickFn(grid, rowIndex, e) {
	//alert('你单击了' + rowIndex);
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var mygriddate = Ext.getCmp("mygriddate");
	mygriddate.setValue(rowObj[0].get("ADate"));
	var mygridtime = Ext.getCmp("mygridtime");
	mygridtime.setValue(rowObj[0].get("ATime"));	
	var typ = Ext.getCmp("typsys");
	typ.setValue(rowObj[0].get("TypDr"));
	recId = rowObj[0].get("rw");
}
function find() {
	REC = new Array();
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var parr=EpisodeID;
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCADMQTREC:QtList", "parr$" + parr, "AddRec");
	mygrid.store.loadData(REC);
}
function AddRec(a1, a2, a3, a4, a5, a6) {
	// debugger;
	REC.push({
				ADate : a1,
				ATime : a2,
				Typ : a3,
				User : a4,
				rw : a5,
				TypDr : a6
			});
}
function typadd() {
	recId = "";
	var grid = Ext.getCmp("mygrid");
	var typ = Ext.get("typ1").dom.value;
	if (typ == ""){
		Ext.Msg.alert('提示', "请选择'事件'!");
		return;
	};
	var mygriddate = Ext.getCmp("mygriddate");
	if (mygriddate.value == "") {
		Ext.Msg.alert('提示', "请选择'日期'!");
		return;
	};
	var mygridtime = Ext.getCmp("mygridtime");
	if (mygridtime.value == "") {
		Ext.Msg.alert('提示', "请填写'时间'!");
		return;
	};
	var QtInsert = document.getElementById('QtInsert');
	if (QtInsert) {
		//alert(EpisodeID+","+mygriddate.value+","+mygridtime.value+","+typ);
		var ee=cspRunServerMethod(QtInsert.value,EpisodeID,mygriddate.value,mygridtime.value,typ,session['LOGON.USERID']);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	clearscreen();
	find();
}
function typupdate() {
	if (recId==""){
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var grid = Ext.getCmp("mygrid");
	var typ = Ext.get("typ1").dom.value;
	if (typ == ""){
		Ext.Msg.alert('提示', "请选择'事件'!");
		return;
	};
	var mygriddate = Ext.getCmp("mygriddate");
	if (mygriddate.value == "") {
		Ext.Msg.alert('提示', "请选择'日期'!");
		return;
	};
	var mygridtime = Ext.getCmp("mygridtime");
	if (mygridtime.value == "") {
		Ext.Msg.alert('提示', "请填写'时间'!");
		return;
	};
	var QtUpdate = document.getElementById('QtUpdate');
	if (QtUpdate) {
		//alert(recId+","+mygriddate.value+","+mygridtime.value+","+typ);
		var ee=cspRunServerMethod(QtUpdate.value,recId,mygriddate.value,mygridtime.value,typ,session['LOGON.USERID']);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	clearscreen();
	find();
}
function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete)
	{
		var ee = cspRunServerMethod(QtDelete.value, recId);
		if (ee != "0") {
			alert(ee);
			return;
		}
 	}
	clearscreen();
	find();
}
function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };