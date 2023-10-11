//var AcctBookID=GetAcctBookID();
// 科目ID//科目名称
var subjIDName = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['id', 'code', 'name', 'nameall', 'codename', 'codenameall'])
	});

subjIDName.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.vouchtempivinitem.csp?action=Getsubjidname&AcctBookID=' + AcctBookID + '&str=' + encodeURIComponent(Ext.getCmp('subjIDNameField').getRawValue()),
			method: 'POST'
		});
});

var subjIDNameField = new Ext.form.ComboBox({
		id: 'subjIDNameField',
		fieldLabel: '科目名称',
		store: subjIDName,
		displayField: 'codenameall',
		valueField: 'code',
		//typeAhead : true,
		selectOnFocus: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '',
		width: 150,
		listWidth: 250,
		pageSize: 10,
		minChars: 1
});

var subjIDName1 = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['id', 'code', 'name', 'nameall', 'codename', 'codenameall'])
});

subjIDName1.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.vouchtempivinitem.csp?action=Getsubjidname&AcctBookID=' + AcctBookID,
			method: 'POST'
		});
});

var subjIDNameField1 = new Ext.form.ComboBox({
		id: 'subjIDNameField1',
		fieldLabel: '科目名称',
		store: subjIDName1,
		displayField: 'codenameall',
		valueField: 'code',
		//typeAhead : true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '',
		width: 150,
		listWidth: 250,
		pageSize: 10,
		minChars: 1
	});

//借贷方向
var DirectionStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['1', '借'], ['-1', '贷']]
	});

var DirectionField = new Ext.form.ComboBox({
		id: 'DirectionField',
		name: 'DirectionField',
		fieldLabel: '借贷方向',
		store: DirectionStore,
		width: 65,
		listWidth: 65,
		selectOnFocus: true,
		allowBlank: true,
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		emptyText: '请选择...',
		// minChars: 15,
		// pageSize: 10,
		value: 1,
		forceSelection: true,
		editable: true
	});

//是否汇总明细
var AllocStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['999', '是'], ['0', '否']]
	});

var AllocField = new Ext.form.ComboBox({
		id: 'AllocField',
		name: 'AllocField',
		fieldLabel: '是否汇总明细',
		store: AllocStore,
		width: 80,
		listWidth: 80,
		selectOnFocus: true,
		allowBlank: true,
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		emptyText: '请选择...',
		// minChars: 15,
		// pageSize: 10,
		value: '999',
		forceSelection: true,
		editable: true
	});

var itemDetail = new dhc.herp.Gridwolf({
		title: '模板明细维护',
		iconCls:'maintain',
		region: 'center',
		// collapsible : true,	//收起
		height: 230,
		layout: "fit",
		split: true,
		xtype: 'grid',
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		stripeRows: true,
		// viewConfig:{ forceFit: true},
		// atLoad : true, // 是否自动刷新
		url: 'herp.acct.vouchtempivinitem.csp',
		fields: [{
				id: 'rowid',
				header: 'ID',
				editable: false,
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'SjCodeName',
				header: '<div style="text-align:center">科目名称</div>',
				dataIndex: 'SjCodeName',
				//align:'right',
				width: 235,
				allowBlank: false,
				editable: true,
				hidden: false,
				type: subjIDNameField /* ,
				renderer:function(value,meta,record){
				var dot="";
				if(value.length>3){
				meta.attr = 'ext:qtitle  ext:qtip="'+value+'"';
				dot="...";
				}else{

				}
				return value.substring(0,3)+dot;
				} */

			}, {
				id: 'Summary',
				header: '<div style="text-align:center">凭证摘要</div>',
				dataIndex: 'Summary',
				width: 130,
				allowBlank: false,
				editable: true,
				hidden: false
			}, {
				id: 'Direction',
				header: '<div style="text-align:center">借贷方向</div>',
				dataIndex: 'Direction',
				width: 80,
				allowBlank: true,
				align: 'center',
				type: DirectionField,
				editable: true
			}, {
				id: 'AllocRate',
				header: '<div style="text-align:center">是否汇总明细</div>',
				dataIndex: 'AllocRate',
				width: 110,
				allowBlank: true,
				align: 'center',
				type: AllocField,
				editable: true
			}, {
				id: 'CodeName',
				header: '<div style="text-align:center">结转科目</div>',
				dataIndex: 'CodeName',
				width: 200,
				allowBlank: true,
				align: 'left',
				editable: true,
				type: subjIDNameField1
			},{
				id: 'TempletID',
				header: 'TempletID',
				editable: false,
				dataIndex: 'TempletID',
				hidden: true
			}
		]

	});

// itemDetail.btnPrintHide();  //隐藏打印按钮
// itemDetail.btnResetHide();  //隐藏重置按钮

