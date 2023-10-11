var fheight = document.body.offsetHeight - 5;
var fwidth = document.body.offsetWidth - 3;

var depcombo = new Ext.form.ComboBox({
	id: 'depcombo',
	store: new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			fields: [{
				'name': 'id',
				'mapping': 'id'
			}, {
				'name': 'desc',
				'mapping': 'desc'
			}]
		}),
		baseParams: {
			className: 'User.DHCConsultDepItm',
			methodName: 'FindLocData',
			type: 'Query'
		},
		listeners: {
			beforeload: function(tstore, e) {
				tstore.baseParams.parr = Ext.getCmp('depcombo').lastQuery;
			}
		}
	}),
	tabIndex: '0',
	listWidth: '200',
	height: 18,
	width: 120,
	xtype: 'combo',
	displayField: 'desc',
	valueField: 'id',
	hideTrigger: false,
	queryParam: '',
	triggerAction: 'all',
	minChars: 1,
	pageSize: 10,
	typeAhead: true,
	typeAheadDelay: 1000,
	loadingText: 'Searching...'
});
var itmcombo = new Ext.form.ComboBox({
	id: 'itmcombo',
	store: new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			fields: [{
				'name': 'id',
				'mapping': 'id'
			}, {
				'name': 'desc',
				'mapping': 'desc'
			}]
		}),
		baseParams: {
			className: 'User.DHCConsultDepItm',
			methodName: 'FindItmData',
			type: 'Query'
		},
		listeners: {
			beforeload: function(tstore, e) {
				tstore.baseParams.parr = Ext.getCmp('itmcombo').lastQuery;
			}
		}
	}),
	tabIndex: '0',
	listWidth: '200',
	height: 18,
	width: 120,
	xtype: 'combo',
	displayField: 'desc',
	valueField: 'id',
	hideTrigger: false,
	queryParam: '',
	triggerAction: 'all',
	minChars: 1,
	pageSize: 10,
	typeAhead: true,
	typeAheadDelay: 1000,
	loadingText: 'Searching...'
});
//会诊类型
var contypcombo = new Ext.form.ComboBox({
	name: 'contypcombo',
	id: 'contypcombo',
	store: new Ext.data.ArrayStore({
		fields: [{
			'name': 'id',
			'mapping': 'id'
		}, {
			'name': 'desc',
			'mapping': 'desc'
		}],

		data: [{
			'id': 'I',
			'desc': '院内会诊'
		}, {
			'id': 'O',
			'desc': '院外会诊'
		}]
	}),
	width: 80,
	displayField: 'desc',
	valueField: 'id',
	triggerAction: 'all',
	mode: 'local',
	value: ''
});
var docgradedata = new Array();
function adddocgrade(a, b) {
	docgradedata.push({
		id: a,
		desc: b
	});
}
//医生类型
var doctypcombo = new Ext.form.ComboBox({
	name: 'doctypcombo',
	id: 'doctypcombo',
	store: new Ext.data.ArrayStore({
		fields: [{
			'name': 'id',
			'mapping': 'id'
		}, {
			'name': 'desc',
			'mapping': 'desc'
		}],
		data: []
	}),
	width: 110,
	displayField: 'desc',
	valueField: 'id',
	triggerAction: 'all',
	mode: 'local',
	value: ''
});
/*
{
			'id': 'D',
			'desc': '主任医师'
		}, {
			'id': 'A',
			'desc': '副主任医师'
		}, {
			'id': 'C',
			'desc': '主治医师'
		}, {
			'id': 'P',
			'desc': '知名专家'
		}
*/
//医嘱产生方式
var howToCreateOrdCombo = new Ext.form.ComboBox({
	name: 'howToCreateOrdCombo',
	id: 'howToCreateOrdCombo',
	store: new Ext.data.ArrayStore({
		fields: [{
			'name': 'id',
			'mapping': 'id'
		}, {
			'name': 'desc',
			'mapping': 'desc'
		}],

		data: [{
			'id': 'E',
			'desc': '执行会诊'
		}, {
			'id': 'A',
			'desc': '申请会诊'
		}]
	}),
	width: 50,
	displayField: 'desc',
	valueField: 'id',
	triggerAction: 'all',
	mode: 'local',
	value: ''
});

function BodyLoadHandler() {

	setsize("mygridpl", "gform", "mygrid");
	//var mygridpl = Ext.getCmp('mygridpl');
	//mygridpl.setPosition(0, 0);
	//setTimeout("Ext.getCmp('mygridpl').setSize(fwidth,fheight);", 1000)

	addTool();
	var mygrid = Ext.getCmp('mygrid');
		var len = mygrid.getColumnModel().getColumnCount();
	for (var i = 0; i < len; i++) {
		if (mygrid.getColumnModel().getDataIndex(i) == 'contype') {
			mygrid.getColumnModel().setHidden(i, true);
		}
		if (mygrid.getColumnModel().getDataIndex(i) == 'doctype') {
			mygrid.getColumnModel().setHidden(i, true);
		}
		if (mygrid.getColumnModel().getDataIndex(i) == 'depid') {
			mygrid.getColumnModel().setHidden(i, true);
		}
		if (mygrid.getColumnModel().getDataIndex(i) == 'itmid') {
			mygrid.getColumnModel().setHidden(i, true);
		}
		if (mygrid.getColumnModel().getDataIndex(i) == 'rw') {
			mygrid.getColumnModel().setHidden(i, true);
		}
		if (mygrid.getColumnModel().getDataIndex(i) == 'howToCreateCode') {
			mygrid.getColumnModel().setHidden(i, true);
		}
	}
	//mygrid.setSize(fwidth,fheight);
	mygrid.store.on('beforeload', function() {
		var depid = depcombo.getValue();
		var itmid = itmcombo.getValue();
		mygrid.store.baseParams.parr = depid + '^' + itmid;
	});
	findRec();
	mygrid.on('rowdblclick', rowdblclick);
	mygrid.on('rowclick', rowdblclick);

	var depobj = Ext.getCmp('depcombo');
	depobj.on('select', selectdep);
	var titlestr = "会诊科室关联会诊医嘱维护说明：会诊科室为“默认医嘱”时只维护医嘱项。会诊执行时如果某科室没有维护对应医嘱项则取“全院会诊”的医嘱项，如果\"全院会诊\"项还未维护则取\"默认医嘱\"维护的医嘱项"
	mygrid.setTitle(titlestr)
	mygrid.getBottomToolbar().hide();
	var contype;
	var doctype;
	var depid;
	var rw;
	var DocGrade = Ext.getCmp("doctypcombo");
	if (DocGrade) {	
	tkMakeServerCall("web.DHCConsult","getDocGrade","adddocgrade","DOCTOR");
		//cspRunServerMethod(getloc1, "adddocgrade","DOCTOR");
				DocGrade.store.loadData(docgradedata);
	}
	//mygrid.getColumnModel().setHidden(0, true); 



}

function selectdep(obj) {
	var selval = obj.value
	var typobj = Ext.getCmp('contypcombo');
	var docobj = Ext.getCmp('doctypcombo');
	if (selval == "DF") {
		typobj.setDisabled(true)
		docobj.setDisabled(true)
		itmcombo.setValue("")
		contypcombo.setValue("")
		doctypcombo.setValue("")
		howToCreateOrdCombo.setValue("");
	} else {
		typobj.setDisabled(false)
		docobj.setDisabled(false)
		itmcombo.setValue("")
		contypcombo.setValue("")
		doctypcombo.setValue("")
		howToCreateOrdCombo.setValue("");
	}
	findRec();
}

function addTool() {

	var ret = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
	var ifCreateOrderByApp=ret.split("^")[0];
	var ifCreateOrderByExcute=ret.split("^")[1];
	ifCreateOrderByApp=(ifCreateOrderByApp=="Y")?true:false;
	ifCreateOrderByExcute=(ifCreateOrderByExcute=="Y")?true:false;
	
	var ifOpenMorcLocAudit = ret.split("^")[2];
	var ifOpenMoreLocAuditExec = ret.split("^")[3];
	ifOpenMorcLocAudit=(ifOpenMorcLocAudit=="Y")?true:false;
	ifOpenMoreLocAuditExec=(ifOpenMoreLocAuditExec=="Y")?true:false;

	var mygrid = Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	var tobar = new Ext.Toolbar();
	tobar.addItem('-');
	tobar.addItem('会诊科室', depcombo);
	tobar.addItem('-');
	tobar.addItem('会诊医嘱', itmcombo);
	tobar.addItem('-');
	tobar.addItem('会诊类型', contypcombo);
	tobar.addItem('-');
	tobar.addItem('医生类型', doctypcombo);
	tobar.addItem('-');
	tobar.addItem('生成方式', howToCreateOrdCombo);
	tobar.addItem('-');
	tobar.addButton({
		id: 'findbtn',
		text: '查询',
		icon:'../images/uiimages/search.png',
		handler: findRec
	});
	tobar.addItem('-');
	tobar.addButton({
		id: 'newbtn',
		text: '增加',
		icon:'../images/uiimages/edit_add.png',
		handler: addRec
	});
	tobar.addItem('-');
	tobar.addButton({
		id: 'updatebtn',
		text: '修改',
		icon:'../images/uiimages/pencil.png',
		handler: updateRec
	});
	tobar.addItem('-');
	tobar.addButton({
		id: 'deletebtn',
		text: '删除',
		icon:'../images/uiimages/edit_remove.png',
		handler: deleteRec
	});
	tobar.addItem('-');
	tobar.addButton({
		id: 'clearbtn',
		icon:'../images/uiimages/clearscreen.png',
		text: '清屏',
		handler: clearall
	});
	tobar.addItem('-');
	/*tobar.add("申请生成医嘱", {
		xtype: "checkbox",
		id: "ifCreateOrderByApp",
		checked:ifCreateOrderByApp
	});
	tobar.add("执行生成医嘱", {
		xtype: "checkbox",
		id: "ifCreateOrderByExcute",
		checked:ifCreateOrderByExcute
	})
	tobar.add({
		xtype: "button",
		text: "保存",
		id: "ifCreateSettingSaveBtn",
		handler:function(){
			var ifCreateOrderByApp = Ext.getCmp("ifCreateOrderByApp").getValue();
			var ifCreateOrderByExcute = Ext.getCmp("ifCreateOrderByExcute").getValue();
			ifCreateOrderByApp=ifCreateOrderByApp?"Y":"N";
			ifCreateOrderByExcute=ifCreateOrderByExcute?"Y":"N";
			var ret = tkMakeServerCall('User.DHCConsultDepItm', 'SaveConfig', ifCreateOrderByApp,ifCreateOrderByExcute);
			Ext.Msg.alert("提示","保存成功!")

		}
	});*/


	tobar.render(mygrid.tbar);
	tobar.doLayout();
	var tobarCheckbox = new Ext.Toolbar();
	tobarCheckbox.addItem('-');
	tobarCheckbox.add("申请生成医嘱", {
		xtype: "checkbox",
		id: "ifCreateOrderByApp",
		checked:ifCreateOrderByApp
	});
	tobarCheckbox.add("执行生成医嘱", {
		xtype: "checkbox",
		id: "ifCreateOrderByExcute",
		checked:ifCreateOrderByExcute
	})
	tobarCheckbox.add("开启多科会诊审核", {
		xtype: "checkbox",
		id: "ifOpenMorcLocAudit",
		checked:ifOpenMorcLocAudit,
		listeners:{
			'blur':OpenMorcLocAuditChange
		}
	});
	tobarCheckbox.add("由审核部门执行会诊", {
		xtype: "checkbox",
		id: "ifOpenMoreLocAuditExec",
		checked:ifOpenMoreLocAuditExec,
		disabled:!ifOpenMorcLocAudit
	})
	tobarCheckbox.addItem('-');
	tobarCheckbox.add({
		xtype: "button",
		text: "保存",
		icon:'../images/uiimages/filesave.png',
		id: "ifCreateSettingSaveBtn",
		handler:function(){
			var ifCreateOrderByApp = Ext.getCmp("ifCreateOrderByApp").getValue();
			var ifCreateOrderByExcute = Ext.getCmp("ifCreateOrderByExcute").getValue();
			var ifOpenMorcLocAudit = Ext.getCmp("ifOpenMorcLocAudit").getValue();
			var ifOpenMoreLocAuditExec = Ext.getCmp("ifOpenMoreLocAuditExec").getValue();
			ifCreateOrderByApp=ifCreateOrderByApp?"Y":"N";
			ifCreateOrderByExcute=ifCreateOrderByExcute?"Y":"N";
			if(ifOpenMorcLocAudit){ifOpenMorcLocAudit="Y";}else{ifOpenMorcLocAudit="N";}
			if(ifOpenMoreLocAuditExec){ifOpenMoreLocAuditExec="Y";}else{ifOpenMoreLocAuditExec="N";}
			var ret = tkMakeServerCall('User.DHCConsultDepItm', 'SaveConfig', ifCreateOrderByApp,ifCreateOrderByExcute,ifOpenMorcLocAudit,ifOpenMoreLocAuditExec);
			Ext.Msg.alert("提示","保存成功!")

		}
	});
	tobarCheckbox.addItem('-');
	tobarCheckbox.render(mygrid.tbar);
	tobarCheckbox.doLayout();
}
function OpenMorcLocAuditChange(){
	//alert('1');
	var AuitLocExe = Ext.getCmp('ifOpenMoreLocAuditExec');
	var AuitLoc = Ext.getCmp('ifOpenMorcLocAudit');
	if(!AuitLoc.getValue()){
		AuitLocExe.setValue(false);
		AuitLocExe.disable();
	}else{
		AuitLocExe.enable();
	}
			 
}
function findRec() {
	var mygrid = Ext.getCmp('mygrid');
	mygrid.store.load({
		params: {
			start: 0,
			limit: 100
		}
	});
	selectrw = ""
}

function addRec() {
	var depid = depcombo.getValue();
	var itmid = itmcombo.getValue();
	var contype = contypcombo.getValue();
	var doctype = doctypcombo.getValue();
	var howToCreateOrd=howToCreateOrdCombo.getValue();
	if (depid == "DF") {
		if (itmid == "") {
			alert('请选择会诊医嘱！');
			return;
		}
	} else {
		if (depid == "") {
			alert('请选择会诊科室！');
			return;
		}
		if (itmid == "") {
			alert('请选择会诊医嘱！');
			return;
		}
		if (contype == "") {
			alert('请选择会诊类型！');
			return;
		}
		if (doctype == "") {
			alert('请选择医生类型！');
			return;
		}
		if (howToCreateOrd == "") {
			alert('请选择生成方式！');
			return;
		}
	}
	var parr = depid + '^' + itmid + '^' + contype + '^' + doctype+"^"+howToCreateOrd;
	var a = tkMakeServerCall('User.DHCConsultDepItm', 'Save', parr);
	//alert(a);
	findRec();
}

function clearall() {
	depcombo.setValue("")
	itmcombo.setValue("")
	contypcombo.setValue("")
	doctypcombo.setValue("")
	howToCreateOrdCombo.setValue("");
	findRec();
}

function updateRec() {
	var mygrid = Ext.getCmp('mygrid');
	var selections = mygrid.getSelectionModel().getSelections();
	var depid = depcombo.getValue();
	var itmid = itmcombo.getValue();
	var contype = contypcombo.getValue();
	var doctype = doctypcombo.getValue();
	var howToCreateOrd=howToCreateOrdCombo.getValue();
	if (selections.length != 1) {
		alert('请选择一条记录！');
		return;
	}
	if (depid == "DF") {
		if (itmid == "") {
			alert('请选择会诊医嘱！');
			return;
		}
	} else {
		if (depid == "") {
			alert('请选择会诊科室！');
			return;
		}
		if (itmid == "") {
			alert('请选择会诊医嘱！');
			return;
		}
		if (contype == "") {
			alert('请选择会诊类型！');
			return;
		}
		if (doctype == "") {
			alert('请选择医生类型！');
			return;
		}
		if (howToCreateOrd == "") {
			alert('请选择生成方式！');
			return;
		}
	}
	var parr = depid + '^' + itmid + '^' + contype + '^' + doctype +"^"+howToCreateOrd+"^"+ selectrw;
	//alert(parr)
	var a = tkMakeServerCall('User.DHCConsultDepItm', 'Save', parr);
	//alert(a);
	findRec();
}

function deleteRec() {
	var mygrid = Ext.getCmp('mygrid');
	var selections = mygrid.getSelectionModel().getSelections();
	if (selections.length != 1) {
		alert('请选择一条记录！');
		return;
	}
	var parr = selections[0].get('rw');
	//alert(parr)
	Ext.Msg.confirm('注意','确定要删除吗？',
      function(btn){
        if(btn=='yes'){
			var a = tkMakeServerCall('User.DHCConsultDepItm', 'Delete', parr);	
			findRec();		  
        }
      },this);
	
	//alert(a);
}
var selectrw = ""

function rowdblclick(grid, row, col, e) {
	var depid = grid.store.getAt(row).get('depid');
	var itmid = grid.store.getAt(row).get('itmid');
	var contype = grid.store.getAt(row).get('contype');
	var doctype = grid.store.getAt(row).get('doctype');
	var howToCreateOrd = grid.store.getAt(row).get('howToCreateCode');
	selectrw = grid.store.getAt(row).get('rw');
	depcombo.store.load({
		params: {
			start: 0,
			limit: 1000
		},
		callback: function() {
			depcombo.setValue(depid);
		}
	});
	itmcombo.store.load({
		params: {
			start: 0,
			limit: 10000
		},
		callback: function() {
			itmcombo.setValue(itmid);
		}
	});
	contypcombo.setValue(contype);
	doctypcombo.setValue(doctype);
	howToCreateOrdCombo.setValue(howToCreateOrd);
	var typobj = Ext.getCmp('contypcombo');
	var docobj = Ext.getCmp('doctypcombo');
	//alert(depid)
	if (depid == "DF") {
		typobj.setDisabled(true)
		docobj.setDisabled(true)
	} else {
		typobj.setDisabled(false)
		docobj.setDisabled(false)
	}
}