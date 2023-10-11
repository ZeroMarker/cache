/*
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});

grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('10')=='数据错误'){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
*/

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
LocBox.on('blur', function(e) {
	if (e.value.trim() == '') {
		loadgname('');
	}
});

var arrgrid = new Array();
var gbox = new Array();
var gboxstore = new Ext.data.JsonStore({
	data: gbox,
	fields: ['id', 'desc']

});
function addgbox(a, b) {
	gbox.push({
		id: a,
		desc: b
	});
}
var GItemBox = new Ext.form.ComboBox({
	name: '根目录名称',
	id: 'gitembox',
	store: new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			fields: [{
				'name': 'LocCode',
				'mapping': 'LocCode'
			}, {
				'name': 'LocDes',
				'mapping': 'LocDes'
			}, {
				'name': 'rw',
				'name': 'rw'
			}]
		}),
		baseParams: {
			className: 'NurEmr.Surgery',
			methodName: 'GetItmList',
			type: 'Query'
		}
	}),
	tabIndex: '0',
	listWidth: '300',
	listHeght: '100',
	height: 100,
	width: 300,
	xtype: 'combo',
	displayField: 'LocDes',
	valueField: 'LocCode',
	hideTrigger: false,
	forceSelection: true,
	triggerAction: 'all',
	minChars: 1,
	pageSize: 20,
	typeAhead: true,
	typeAheadDelay: 1000,
	//editable:false,
	loadingText: 'Searching...'
});
var GBox = new Ext.form.ComboBox({
	id: 'KNurseName',
	//hiddenName : 'region1',
	store: gboxstore,
	width: 80,
	fieldLabel: '根目录名',
	triggerAction: 'all',
	valueField: 'id',
	value: "",
	displayField: 'desc',
	allowBlank: true,
	mode: 'local'
});
GBox.on('select', function () {
	var KNurseName = Ext.getCmp("KNurseName");
	var id = KNurseName.getValue()
	var Getval = document.getElementById('Getval');
	if (Getval) {
	}
	var KNurseobj = Ext.getCmp("mygridmodle");
	KNurseobj.setValue("")
	var KNurseobj = Ext.getCmp("xsname");
	KNurseobj.setValue("")
	find()
});
var modledata = new Array();
var GetModel = document.getElementById('GetModel');
if (GetModel) {
	cspRunServerMethod(GetModel.value, 'addmodel');
}
//加载根目录名称
function loadgname(loc) {
	var obj = Ext.getCmp("KNurseName");
	var objloc = Ext.getCmp("locbox").getRawValue();
	//alert(objloc)
	gbox = new Array()
	tkMakeServerCall("NurMp.TemplateMenu", "getgbox", loc, "addgbox")
	obj.store.loadData(gbox);
}
function addmodel(a, b) {
	modledata.push({
		modle: a,
		modledesc: b
	});
}
var modlestore = new Ext.data.JsonStore({
	data: modledata,
	fields: ['modle', 'modledesc']
});
var combo = new Ext.form.ComboBox({
	id: 'mygridmodle',
	store: modlestore,
	valueField: 'modle',
	displayField: 'modledesc',
	typeAhead: true,
	mode: 'local',
	triggerAction: 'all',
	// emptyText:'按模版查询...',
	selectOnFocus: true,
	width: 200,
	listeners: {
		select: function (combo, record, index) {
		}
	}
});
combo.on('select', function () {
	Ext.getCmp("xsname").setValue("");
	Ext.getCmp("xsname").setDisabled(true)
	find()
});
LocBox.on('select', function () {
	var obj = Ext.getCmp("KNurseName");
	obj.setValue("");
	var obj = Ext.getCmp("mygridmodle");
	obj.setValue("");
	var obj = Ext.getCmp("xsname");
	obj.setValue("");
	var objloc = Ext.getCmp("locbox");
	if (objloc.getValue() != "") {
		loadgname(objloc.getValue()) //加载根目录
		var a = tkMakeServerCall("NurMp.TemplateMenuSub", "iflochaveset", objloc.getValue())
		if (a == "")  //该科没有保存配置
		{
			Ext.getCmp("deleteloc").setDisabled(true)
			Ext.getCmp("add").setDisabled(true)
		} else {
			Ext.getCmp("deleteloc").setDisabled(false)
			Ext.getCmp("add").setDisabled(false)
		}
	}
	find();
});
function BodyLoadHandler() {

	if (typeof (arr[0].items) != "undefined") arr[0].items[0].getBottomToolbar().hide();
	setsize("mygridpl", "gform", "mygrid");
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var grid = Ext.getCmp('mygrid');
	var len = grid.getColumnModel().getColumnCount();
	for (var i = 0; i < len; i++) {
		if (grid.getColumnModel().getDataIndex(i) == 'rw') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'par') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'loc') {
			grid.getColumnModel().setHidden(i, true);
		}
		if (grid.getColumnModel().getDataIndex(i) == 'gid') {
			grid.getColumnModel().setHidden(i, true);
		}
	}

	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem('病区', LocBox),
		tobar.addItem('根目录名', GBox),
		tobar.addItem('模板', combo),
		tobar.addItem('显示名称', {
			xtype: 'textfield',
			width: 200,
			id: 'xsname',
			fieldLabel: '显示名称'
		}),
		tbar2 = new Ext.Toolbar({});

	tbar2.addItem("-");
	tbar2.addButton({
		//className: 'new-topic-button',
		text: "增加",
		icon: '../images/uiimages/edit_add.png',
		handler: additm,
		id: 'add'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		//className: 'new-topic-button',
		icon: '../images/uiimages/edit_remove.png',
		text: "删除",
		handler: delete1,
		id: 'delete'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		//className: 'new-topic-button',
		text: "保存",
		icon: '../images/uiimages/filesave.png',
		handler: Save,
		id: 'update'
	});
	tbar2.addButton({
		//className: 'new-topic-button',
		text: "查询",
		icon: '../images/uiimages/search.png',
		handler: find,
		id: 'mygridSch'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		//className: 'new-topic-button',
		icon: '../images/uiimages/clearscreen.png',
		text: "清屏",
		handler: clearall,
		id: 'clearall'
	});
	/*tbar2.addItem("-");
	tbar2.addButton({
		className: 'new-topic-button',
		text: "清屏2",
		handler:clearall2,
		id: 'clearall2'
	});*/

	tbar2.addItem("-");
	tbar2.addButton({
		//className: 'new-topic-button',
		icon: '../images/uiimages/wastebin.png',
		text: "删除当前科室配置",
		handler: deleteloc,
		id: 'deleteloc'
	});
	tbar2.addItem("-");

	tbar2.render(grid.tbar);
	tobar.doLayout();
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
				mygridtime.setValue(rowObj[0].get("rw"));
				var mygridtime = Ext.getCmp("mygridmodle");
				mygridtime.setValue(rowObj[0].get("Code"));
				var mygridtime = Ext.getCmp("xsname");
				mygridtime.setValue(rowObj[0].get("Name"));
				Ext.getCmp("add").setDisabled(true)
				Ext.getCmp("mygridmodle").setDisabled(true)
				Ext.getCmp("xsname").setDisabled(false)
				Ext.getCmp("mygridSch").setDisabled(true)
				Ext.getCmp("delete").setDisabled(false)

			}
		}
	}
	);
	Ext.getCmp("xsname").setDisabled(true)
	grid.addListener('rowcontextmenu', rightClickFn);
	inidata("patward", "Desc", "web.DHCNurblsjflwh:GetWard", "Loc$W");
	var loginloc = Ext.getCmp("locbox").getValue();
	//alert(loginloc)

	//inidata("KNurseName","Desc","NurMp.TemplateMenuSub:GetRootname","Loc$"+loginloc);
	inidata("CCERR", "Desc", "web.DHCNurblsjflwh:CRItem", "");
	//patward.setValue(session['LOGON.CTLOCID']);
	//alert(session['LOGON.GROUPID'])
	if (session['LOGON.GROUPID'] == 20) {
		//patward.disable()
	}
	if (EpisodeID != "") {
		var boxobj = Ext.getCmp("locbox");
		boxobj.setValue(EpisodeID);
	}
	loadgname(EpisodeID); //加载根目录
	find();
	Ext.getCmp("delete").setDisabled(true)
	grid.setTitle("子目录维护：loc为空是全院默认配置")
	if (EpisodeID == "") {

		Ext.getCmp("deleteloc").setDisabled(true)
	} else {
		// grid.setTitle("子目录维护("+NurRecId+")")
		//alert(EpisodeID)
		var a = tkMakeServerCall("NurMp.TemplateMenuSub", "iflochaveset", EpisodeID)
		if (a == "")  //该科没有保存配置
		{
			Ext.getCmp("deleteloc").setDisabled(true)
			Ext.getCmp("add").setDisabled(true)
		} else {
			Ext.getCmp("deleteloc").setDisabled(false)
			Ext.getCmp("add").setDisabled(false)
		}

	}


	//alert();
	//debugger;
}
//使用全院配置
function deleteloc() {
	var locboxobj = Ext.getCmp("locbox");  //科室
	if (locboxobj.getValue() != "") {
		var flag = confirm("您将删除本病区配置信息，删除后将使用全院默认配置！确定删除？")
		if (flag) {
			var a = tkMakeServerCall("NurMp.TemplateMenuSub", "deleteloc", locboxobj.getValue())
			Ext.getCmp("deleteloc").setDisabled(true)
			find();
		}

	}
}
function additm() {
	var modle = Ext.getCmp("mygridmodle"); //模板
	var locboxobj = Ext.getCmp("locbox");  //科室
	var Name = Ext.getCmp("KNurseName");  //根目录
	var mygrid = Ext.getCmp("mygrid");
	//alert(Name.getValue())
	if (modle.getValue() == "") {
		alert("模板不能为空");
		return;
	}
	if (Name.getValue() == "") {
		alert("根目录不能为空");
		return;
	}
	//alert(Name.getValue())
	var modelname = Ext.getCmp("mygridmodle").lastSelectionText;
	var gname = Ext.getCmp("KNurseName").lastSelectionText;
	//alert(gname)
	var parr = Name.getValue() + "^" + modle.getValue() + "^" + locboxobj.getValue() + "^" + modelname + "^" + gname
	//alert(parr);
	var a = tkMakeServerCall("NurMp.TemplateMenuSub", "Additm", parr)
	if (a != 0) { alert(a) }
	Ext.getCmp("mygridmodle").setValue("")
	find()
}
function clearall() {
	Ext.getCmp("mygridmodle").setValue("");
	Ext.getCmp("xsname").setValue("");
	Ext.getCmp("KNurseName").setValue("");
	Ext.getCmp("xsname").setDisabled(true)
	Ext.getCmp("mygridSch").setDisabled(false)
	Ext.getCmp("delete").setDisabled(true)
	find()
}
function clearall2() {
	Ext.getCmp("mygridmodle").setValue("");
	Ext.getCmp("xsname").setValue("");
	Ext.getCmp("xsname").setDisabled(true)
	Ext.getCmp("mygridSch").setDisabled(false)
	Ext.getCmp("delete").setDisabled(true)
	//Ext.getCmp("KNurseName").setValue("");
	find()
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
		var chl = objRow[0].get("par");
		var locs = objRow[0].get("loc");
		if (rw != "") {
			var a = tkMakeServerCall("NurMp.TemplateMenuSub", "upordown", locs, rw, chl, -1)
			find2()
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
		var chl = objRow[0].get("par");
		var locs = objRow[0].get("loc");
		if (rw != "") {
			var a = tkMakeServerCall("NurMp.TemplateMenuSub", "upordown", locs, rw, chl, 1)
			find2()
		} else {
			alert("请先保存")
		}
	}
}
function rowClickFn(grid, rowIndex, e) {
	// alert('你单击了' + rowIndex);
	//var grid=Ext.getCmp("mygrid");

	//var rw = objRow[0].get("rw");
	//var chl = objRow[0].get("par");
	//var par = objRow[0].get("par");
	//var id=rw+"||"+chl;
	//alert(par);
	//var a = cspRunServerMethod(SetStatus.value,id);
	//find()
}


function delete1() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		var SetStatus = document.getElementById('delete');
		var rw = objRow[0].get("rw");
		var chl = objRow[0].get("par");
		var id = rw + "^" + chl;
		//alert(par);
		var a = cspRunServerMethod(SetStatus.value, id);

	}
	clearall2()
}
function Save() {
	var grid = Ext.getCmp("mygrid");
	var objRow = grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
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
		var RecSave = document.getElementById('Save');
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
		Ext.getCmp("deleteloc").setDisabled(false)
	}
	else {

		var SetStatus = document.getElementById('update');
		var rw = objRow[0].get("rw");
		var chl = objRow[0].get("par");
		var codename = document.getElementById("xsname").value;
		if (rw != "") {
			var id = rw + "||" + chl;
			id = id + "";
			//alert(codename)
			var a = tkMakeServerCall("NurMp.TemplateMenuSub", "update", id, codename)
			if (a != 0) { alert(a); }
			Ext.getCmp("mygridmodle").setValue("");
			Ext.getCmp("xsname").setValue("");
			Ext.getCmp("xsname").setDisabled(true)

			find2()
			Ext.getCmp("deleteloc").setDisabled(false)

		}
	}

	//if (a!=0)
	//{alert(a)}


}
function Saveback() {
	var modle = Ext.getCmp("mygridmodle");
	var locboxobj = Ext.getCmp("locbox");
	var Name = Ext.getCmp("KNurseName");
	var RecSave = document.getElementById('Save');
	var mygrid = Ext.getCmp("mygrid");
	if (locboxobj.getValue() == "") {
		//alert("科室不能为空")
		//	return;
	}
	var modelname = Ext.getCmp("mygridmodle").lastSelectionText;
	var gname = Ext.getCmp("KNurseName").lastSelectionText;
	var parr = Name.getValue() + "^" + modle.getValue() + "^" + locboxobj.getvalue() + "^" + modelname + "^" + gname
	alert(parr);
	var a = cspRunServerMethod(RecSave.value, parr, "");
	if (a != 0) { alert(a) }
	find()

}


function inidata(cmbname, desc, quer, parr) {
	var cmb = Ext.getCmp(cmbname);
	var querymth = document.getElementById('GetQueryCombox');
	if (cmb != null) {
		arrgrid = new Array();
		var a = cspRunServerMethod(querymth.value, quer, parr, "AddRec", desc);
		cmb.store.loadData(arrgrid);
	}

}

var REC = new Array();

//查询
function find() {
	var xsname = Ext.getCmp("xsname");
	var mode = Ext.getCmp("mygridmodle");
	var subtype = Ext.getCmp("KNurseName");
	var locsel = Ext.getCmp("locbox");
	var mygrid = Ext.getCmp("mygrid");
	var parr = "^" + subtype.getValue() + "^" + "^" + "^" + locsel.getValue()
	var GetQueryData = document.getElementById('GetQueryData');
	arrgrid = new Array();
	var grid = Ext.getCmp("mygrid");
	var a = cspRunServerMethod(GetQueryData.value, "NurMp.TemplateMenuSub:CRItem", "parr$" + parr, "AddRec");
	grid.store.loadData(arrgrid);
	Ext.getCmp("add").setDisabled(false)
	Ext.getCmp("mygridmodle").setDisabled(false)
	Ext.getCmp("delete").setDisabled(true)
	var locselect = Ext.getCmp("locbox").lastSelectionText;
	if (locselect == "") {
		locselect = "默认"
	}
	//mygrid.setTitle("子目录维护 ->"+locselect)
	if (locsel.getValue() == "") {
		Ext.getCmp("deleteloc").setDisabled(true)
	}

}

function find2() {
	var xsname = Ext.getCmp("xsname");
	var mode = Ext.getCmp("mygridmodle");
	var subtype = Ext.getCmp("KNurseName");
	var locsel = Ext.getCmp("locbox");
	var mygrid = Ext.getCmp("mygrid");
	var parr = "^" + subtype.getValue() + "^" + "^" + "^" + locsel.getValue()
	var GetQueryData = document.getElementById('GetQueryData');
	arrgrid = new Array();
	var grid = Ext.getCmp("mygrid");
	var a = cspRunServerMethod(GetQueryData.value, "NurMp.TemplateMenuSub:CRItem", "parr$" + parr, "AddRec");
	grid.store.loadData(arrgrid);
	Ext.getCmp("add").setDisabled(false)
	Ext.getCmp("mygridmodle").setDisabled(false)

	Ext.getCmp("delete").setDisabled(true)
	var locselect = Ext.getCmp("locbox").lastSelectionText;
	if (locselect == "") {
		locselect = "默认"
	}
	//mygrid.setTitle("子目录维护 ->"+locselect)

}

function AddRec(str) {
	//var a=new Object(eval(str));
	//alert(str);
	str = str.replace(/\t+/g, "").replace(/\n+/g, "").replace(/\r+/g, "").replace(/\s+/g, "");  //去除字符串中空格
	var obj = eval('(' + str + ')');

	//obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrgrid.push(obj);
	//debugger;
}

//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime() {
	var a = Ext.util.Format.dateRenderer('h:m');
	return a;
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


var checkret = "";

function add(a1, a2) {
	attenitm.push({
		xtype: 'panel',
		id: a1,
		title: a2,
		region: 'center',
		height: 1000,
		layout: 'fit',
		closable: true,
		items: []
	})
}


var condata = new Array();
function add(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o) { //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel,SeqNo
	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		PriorDes: d,
		Meth: e,
		PHFreq: f,
		Dose: g,
		DoseUnit: h,
		PhQtyOrd: i,
		OrdStat: j,
		Doctor: k,
		Oew: l,
		OrdSub: m,
		SeqNo: o
	});
}
function DBC2SBC(str) {
	var result = '';
	if ((str) && (str.length)) {
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else {
		result = str;
	}
	return result;
}

