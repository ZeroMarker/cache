/**
 * @author Administrator
 */

var grid;
var arrgrid = new Array();
var locdatabox = new Array();
cspRunServerMethod(getloc, 'addlocbox');
function addlocbox(a, b) {
	locdatabox.push({
		loc: a,
		locdes: b
	});
}
var storelocbox = new Ext.data.JsonStore({
	data: locdatabox,
	fields: ['loc', 'locdes']
});
var LocBox = new Ext.form.ComboBox({
	id: 'locbox',
	hiddenName: 'loc12222',
	store: storelocbox,
	width: 200,
	fieldLabel: '科室',
	valueField: 'loc',
	triggerAction: 'all',
	displayField: 'locdes',
	allowBlank: true,
	mode: 'local',
	anchor: '100%'
});

var arrgrid = new Array();
var gbox = new Array();
function addgbox(a, b) {
	gbox.push({
		id: a,
		desc: b
	});
}
var KNurseNamestore = new Ext.data.JsonStore({
	data: gbox,
	fields: ['id', 'desc']

});
var DFGMenu = new Ext.form.ComboBox({
	id: 'KNurseName',
	//hiddenName : 'region1',
	store: KNurseNamestore,
	width: 80,
	fieldLabel: '根目录名',
	triggerAction: 'all',
	valueField: 'id',
	value: "",
	displayField: 'desc',
	allowBlank: true,
	mode: 'local'
});
DFGMenu.on('select', function () {

	find()
});
//选择病区
LocBox.on('select', function () {
	var obj = Ext.getCmp("btnadd");
	//obj.setDisabled(true)
	var obj = Ext.getCmp("KNurseName");
	obj.setValue("")
	var obj = Ext.getCmp("xsname");
	obj.setValue("")
	var objloc = Ext.getCmp("locbox");
	var selectloc = objloc.getValue()
	Ext.getCmp("KNurseName").setDisabled(false)
	//alert(selectloc)
	loadgname()
	var objloc = Ext.getCmp("locbox");
	if (objloc.getValue() != "") {
		var a = tkMakeServerCall("NurMp.TemplateMenu", "iflochaveset", objloc.getValue())
		//alert(a)		  
		if (a == "")  //该科没有保存配置
		{

			Ext.getCmp("btnadd").setDisabled(true)
			Ext.getCmp("btnsave").setDisabled(false)
			Ext.getCmp("deleteloc").setDisabled(true)
		} else {
			Ext.getCmp("btnsave").setDisabled(true)
			Ext.getCmp("btnadd").setDisabled(false)
			Ext.getCmp("deleteloc").setDisabled(false)
		}
	}
	//Ext.getCmp("btnadd").setDisabled(true)
	find();
});
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
	//fm.doLayout();
	//but.ide();
	var gridpl = Ext.getCmp('mygridpl');
	gridpl.setHeight(document.body.clientHeight);
	gridpl.setWidth(document.body.clientWidth);
	grid = Ext.getCmp('mygrid');
	var len = grid.getColumnModel().getColumnCount();
	for (var i = 0; i < len; i++) {
		if (grid.getColumnModel().getDataIndex(i) == 'rw') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'link') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'loc') {
			grid.getColumnModel().setHidden(i, true);
		}
	}

	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	//alert(11);
	tobar.addItem('科室病区', LocBox)
	//tobar.addItem('关联默认根目录', DFGMenu);
	var tbar2 = new Ext.Toolbar({})
	tbar2.addItem('显示名称', {
		xtype: 'textfield',
		width: 150,
		id: 'xsname',
		fieldLabel: '显示名称'
	})
	tbar2.addItem('-');
	tbar2.addItem('是否启用', {
		xtype: 'combo',
		width: 60,
		id: 'ifOn',
		triggerAction: 'all',
    mode: 'local',
		store: new Ext.data.ArrayStore({
			fields: [
					'id',
					'desc'
			],
			data: [['Y', 'Y'], ['N', 'N']],
		}),
		valueField: 'id',
		displayField: 'desc'	
	})
	tbar2.addItem('-');
	tbar2.addButton({
		//className : 'new-topic-button',
		text: "增加",
		icon: '../images/uiimages/edit_add.png',
		handler: additm,
		id: 'btnadd'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		//className : 'new-topic-button',
		icon: '../images/uiimages/edit_remove.png',
		text: "删除",
		handler: typdelete,
		id: 'delete'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		//className : 'new-topic-button',
		icon: '../images/uiimages/filesave.png',
		text: "修改",
		handler: save,
		id: 'btnsave'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		//className : 'new-topic-button',
		icon: '../images/uiimages/search.png',
		text: "查询",
		handler: find,
		id: 'find'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		//className : 'new-topic-button',
		icon: '../images/uiimages/searchallloc.png',
		text: "查询默认配置",
		handler: finddf,
		id: 'finddf'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		//className : 'new-topic-button',
		icon: '../images/uiimages/clearscreen.png',
		text: "清屏",
		handler: clearsel,
		id: 'clear'
	});

	tbar2.addItem('-');
	tbar2.addButton({
		//className: 'new-topic-button',
		text: "删除当前科室配置",
		icon: '../images/uiimages/wastebin.png',
		handler: deleteloc,
		id: 'deleteloc',
		hidden:true
	});
	tbar2.addItem('-');
	tbar2.render(grid.tbar);
	tobar.doLayout();
	//alert(14);
	grid.addListener('rowclick', function () {
		var grid = Ext.getCmp('mygrid');
		var objRow = grid.getSelectionModel().getSelections();
		if (objRow.length == 0) {
			return;
		}
		else {
			var grid = Ext.getCmp("mygrid");
			var rowObj = grid.getSelectionModel().getSelections();
			var rwval = rowObj[0].get("rw");
			if (rwval != "") {
				var mygridtime = Ext.getCmp("KNurseName");
				mygridtime.setValue(rowObj[0].get("link"));
				var mygridtime = Ext.getCmp("xsname");
				mygridtime.setValue(rowObj[0].get("name"));
				var objIfOn = Ext.getCmp("ifOn");
				objIfOn.setValue(rowObj[0].get("ifon"));
				Ext.getCmp("btnsave").setDisabled(false)
				Ext.getCmp("btnadd").setDisabled(false)
				Ext.getCmp("xsname").setDisabled(false)
				Ext.getCmp("delete").setDisabled(false)
			}
			else {
				Ext.getCmp("btnsave").setDisabled(false)
				Ext.getCmp("btnadd").setDisabled(false)
				Ext.getCmp("delete").setDisabled(true)
				find()
			}
		}
	}
	);
	grid.addListener('rowcontextmenu', rightClickFn);
	var but1 = Ext.getCmp("mygridbut1");
	but1.on('click', additm);
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.setText("修改");
	but.on('click', save);
	but.hide()
	grid.getBottomToolbar().hide()

	if (EpisodeID != "") { 
		Ext.getCmp('locbox').setValue(EpisodeID);
	}

	Ext.getCmp("KNurseName").setDisabled(true)
	loadgname()
	Ext.getCmp("btnsave").setDisabled(true)
	find();
	//Ext.getCmp("delete").setDisabled(true)
	//ifdelete("");
	
}
function ifdelete(loc) {
	var a = tkMakeServerCall("NurMp.TemplateMenu", "iflochaveset", loc)
	if ((a == "") || (loc == ""))  //该科没有保存配置
	{
		Ext.getCmp("deleteloc").setDisabled(true)
		Ext.getCmp("btnadd").setDisabled(true)
	} else {
		Ext.getCmp("deleteloc").setDisabled(false)
		Ext.getCmp("btnadd").setDisabled(false)
	}
}
//使用全院配置
function deleteloc() {
	var locboxobj = Ext.getCmp("locbox");  //科室
	if (locboxobj.getValue() != "") {
		var flag = confirm("你确定要删除此条记录吗!")
		if (flag) {
			var a = tkMakeServerCall("NurMp.TemplateMenu", "deleteloc", locboxobj.getValue())
			Ext.getCmp("deleteloc").setDisabled(true)
			Ext.getCmp("btnsave").setDisabled(false)
			find();
		}
	}
}
var rightClick = new Ext.menu.Menu({
	id: 'rightClickCont',
	items: [{
		id: 'rMenu1',
		text: '上移',
		handler: up
	}, {
		id: 'rMenu2',
		text: '下移',
		handler: down
	}]
});
function rightClickFn(client, rowIndex, e) {
	e.preventDefault();
	grid = client;
	CurrRowIndex = rowIndex;
	rightClick.showAt(e.getXY());
}
function up() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		var rw = objRow[0].get("rw");
		var locs = objRow[0].get("loc");
		if (rw != "") {
			//alert(rw)
			var a = tkMakeServerCall("NurMp.TemplateMenu", "upordown", locs, rw, -1)
			find()
		} else {
			alert("请先保存")
		}

	}
}
function down() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		var rw = objRow[0].get("rw");
		var locs = objRow[0].get("loc");
		if (rw != "") {
			var a = tkMakeServerCall("NurMp.TemplateMenu", "upordown", locs, rw, 1)
			find()
		} else {
			alert("请先保存")
		}
	}
}
function clearsel() {
	Ext.getCmp("KNurseName").setValue("")
	Ext.getCmp("xsname").setValue("")
	Ext.getCmp("btnadd").setDisabled(false)
	Ext.getCmp("btnsave").setDisabled(true)
	find()
}
function loadgname() {
	var obj = Ext.getCmp("KNurseName");
	gbox = new Array()
	tkMakeServerCall("NurMp.TemplateMenu", "getgbox", "", "addgbox")
	obj.store.loadData(gbox);
}
function additm() {
	var modle = Ext.getCmp("xsname"); //名称
	var locboxobj = Ext.getCmp("locbox");  //科室
	var objIfOn = Ext.getCmp('ifOn');
	var mygrid = Ext.getCmp("mygrid");
	//alert(Name.getValue())
	if (modle.getValue() == "") {
		alert("名称不能为空");
		return;
	}
	var parr = locboxobj.getValue() + "^" + modle.getValue() + "^" + objIfOn.getValue(); 
	//alert(parr);
	var a = tkMakeServerCall("NurMp.TemplateMenu", "Additm", parr)
	if (a != 0) {
		alert(a)
		return;
	}
	Ext.getCmp("xsname").setValue("");
	Ext.getCmp("KNurseName").setValue("");
	Ext.getCmp("xsname").setDisabled(false)
	Ext.getCmp("btnsave").setDisabled(true)
	Ext.getCmp("btnadd").setDisabled(false)
	find()
	loadgname()
}
function save() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		alert('请选择记录！');
		return false;
		var grid = Ext.getCmp("mygrid");
		var store = grid.store;
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount();
		var list = [];
		var grid1 = Ext.getCmp('mygrid');
		for (var i = 0; i < store.getCount(); i++) {
			list.push(store.getAt(i).data);
		}
		var RecSave = document.getElementById('SaveQt');
		var str = "";
		for (var i = 0; i < list.length; i++) {
			var obj = list[i];
			var itmstr = "";
			for (var p in obj) {
				if (p == "") continue;
				itmstr = itmstr + p + "|" + obj[p] + '^';
			}
			if (str == "") str = itmstr
			else {
				str = str + "$" + itmstr
			}
		}
		//alert(str);
		var a = cspRunServerMethod(RecSave.value, str);
		find()
		Ext.getCmp("delete").setDisabled(false)
		//Ext.getCmp("btnsave").setDisabled(true)
		Ext.getCmp("btnadd").setDisabled(false)
		Ext.getCmp("btnsave").setDisabled(false)
	}
	else {
		var rw = objRow[0].get("rw");
		var codename = document.getElementById("xsname").value;
		var objIfOn = Ext.getCmp('ifOn');
		if (rw != "") {
			var id = rw;
			//alert(rw)
			var a = tkMakeServerCall("NurMp.TemplateMenu", "update", id, codename, objIfOn.getValue())
			//alert(a)
			if (a != 0) {
				alert(a);
				return;
			}
			Ext.getCmp("xsname").setValue("");
			Ext.getCmp("KNurseName").setValue("");
			Ext.getCmp("xsname").setDisabled(false)
			Ext.getCmp("btnsave").setDisabled(true)
			Ext.getCmp("btnadd").setDisabled(false)
			find()
		}
	}
}
function find() {
	var grid = Ext.getCmp("mygrid");
	var GetQueryData = document.getElementById('GetQueryData');
	arrgrid = new Array();
	var seloc = Ext.getCmp("locbox").getValue();
	if (seloc == "") {
		Ext.getCmp("deleteloc").setDisabled(true);
		Ext.getCmp("btnadd").setDisabled(false);
	} else {
		var a = tkMakeServerCall("NurMp.TemplateMenu", "iflochaveset", seloc)
		if (a != "") {
			Ext.getCmp("deleteloc").setDisabled(false);
			Ext.getCmp("btnadd").setDisabled(false);
		} else {
			Ext.getCmp("deleteloc").setDisabled(true);
			Ext.getCmp("btnadd").setDisabled(false);
		}

	}
	//alert(session['LOGON.CTLOCID']);
	//alert(seloc)
	var a = cspRunServerMethod(GetQueryData.value, "NurMp.TemplateMenu:CRItem", "parr$" + seloc, "AddRec");
	//alert(a);
	Ext.getCmp("delete").setDisabled(true)
	grid.store.loadData(arrgrid);
}
function finddf() {
	var grid = Ext.getCmp("mygrid");
	var GetQueryData = document.getElementById('GetQueryData');
	arrgrid = new Array();
	Ext.getCmp("locbox").setValue("")
	Ext.getCmp("KNurseName").setValue("")
	Ext.getCmp("xsname").setValue("")
	Ext.getCmp("KNurseName").setDisabled(true)
	Ext.getCmp("btnadd").setDisabled(false)
	Ext.getCmp("btnsave").setDisabled(true)
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "NurMp.TemplateMenu:CRItem", "parr$", "AddRec");
	//alert(a);
	grid.store.loadData(arrgrid);
	Ext.getCmp("delete").setDisabled(true)
}
function AddRec(str) {
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function find2() {
	var grid = Ext.getCmp("mygrid");
	var GetQueryData = document.getElementById('GetQueryData');
	arrgrid = new Array();
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "NurMp.TemplateMenu:CRItem2", "parr$", "AddRec2");
	//alert(a);
	grid.store.loadData(arrgrid);
}
function AddRec2(str) {
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	var rw = ""
	if (len == 0) {
		alert("请先选择一行!");
		return;
	}
	else {
		var rw = rowObj[0].get('rw')
		if (rw != "") {
			var flag = confirm("你确定要作废此条记录吗!")
			if (flag) {
				var a = tkMakeServerCall("NurMp.TemplateMenu", "QtDelete", rw)
				Ext.getCmp("delete").setDisabled(true)
				Ext.getCmp("xsname").setValue("")
				Ext.getCmp("KNurseName").setValue("")
				Ext.getCmp("btnadd").setDisabled(false)
				Ext.getCmp("btnsave").setDisabled(true)
				find();
			}

		}

	}

}
function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val, addday) {
	var year = val.getFullYear();
	var mon = val.getMonth();
	var dat = val.getDate() + addday;
	var datt = new Date(year, mon, dat);
	return formatDate(datt);
}
function getDate(val) {
	var a = val.split('-');
	var dt = new Date(a[0], a[1] - 1, a[2]);
	return dt;
}
function formatDate(value) {
	try {
		return value ? value.dateFormat('Y-m-d') : '';
	}
	catch (err) {
		return '';
	}
};