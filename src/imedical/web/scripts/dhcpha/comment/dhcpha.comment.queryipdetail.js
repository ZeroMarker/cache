var unitsUrl = 'dhcpha.comment.query.save.csp';
var idTmr = "";
var comwidth = 150;

Ext.onReady(function() {

	Ext.QuickTips.init(); // 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;

	var ResultData = [['仅合格', '1'], ['仅不合格', '2'], ['仅有结果', '4'], ['全部', '3']];

	var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data: ResultData
	});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField: 'retdesc',
		mode: 'local',
		width: comwidth,
		id: 'ResultCmb',
		emptyText: '',
		valueField: 'retid',
		emptyText: '选择点评结果...',
		fieldLabel: '点评结果'
	});

	var StDateField = new Ext.form.DateField({

		xtype: 'datefield',
		//format:'j/m/Y' ,
		fieldLabel: '开始日期',
		name: 'startdt',
		id: 'startdt',
		//invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		width: comwidth,
		value: new Date
	})

	var EndDateField = new Ext.form.DateField({
		//format:'j/m/Y' ,
		fieldLabel: '截止日期',
		name: 'enddt',
		id: 'enddt',
		width: comwidth,
		value: new Date
	})

	var FindButton = new Ext.Button({
		width: 65,
		id: "FindButton",
		text: '查询',
		iconCls: "page_find",
		listeners: {
			"click": function() {

				FindCNTSData();

			}
		}

	})

	var ExportButton = new Ext.Button({
		width: 65,
		id: "ExportButton",
		text: '另存',
		iconCls: "page_export",
		listeners: {
			"click": function() {

				ExportNTSData();

			}
		}

	})

	var QueryForm = new Ext.FormPanel({
		labelWidth: 80,
		region: 'north',
		title: '点评单明细查询(住院)',
		frame: true,
		height: 115,
		tbar: [FindButton, '-', ExportButton],
		items: [{
			frame:true,
			layout: "column",
			items: [{
				labelAlign: 'right',
				columnWidth: .25,
				layout: "form",
				items: [StDateField]
			},
			{
				labelAlign: 'right',
				columnWidth: .25,
				layout: "form",
				items: [EndDateField]

			},
			{

				labelAlign: 'right',
				columnWidth: .25,
				layout: "form",
				items: [ResultCombo]
			}]

		}

		]

	});

	////明细table 
	var nm = new Ext.grid.RowNumberer();
	var commentitmgridcm = new Ext.grid.ColumnModel([nm,

	{
		header: '点评单号',
		dataIndex: 'pcntsno',
		width: 120
	},
	{
		header: '登记号',
		dataIndex: 'patno',
		width: 100
	},
	{
		header: '姓名',
		dataIndex: 'patname',
		width: 100
	},
	{
		header: '性别',
		dataIndex: 'patsex',
		width: 60
	},
	{
		header: '年龄',
		dataIndex: 'patage',
		width: 60
	},
	{
		header: '费别',
		dataIndex: 'billtype',
		width: 80
	},
	{
		header: '诊断',
		dataIndex: 'diag',
		width: 200
	},
	{
		header: '医嘱名称',
		dataIndex: 'inciDesc',
		width: 350
	},
	{
		header: '数量',
		dataIndex: 'qty',
		width: 60
	},
	{
		header: '单位',
		dataIndex: 'uomdesc',
		width: 80
	},
	{
		header: '单价',
		dataIndex: 'price',
		width: 60,
		hidden:true
	},
	{
		header: '金额',
		dataIndex: 'amt',
		width: 60,
		hidden:true
	},
	{
		header: '剂量',
		dataIndex: 'dosagestr',
		width: 100
	},
	{
		header: '剂量',
		dataIndex: 'dosage',
		width: 80,
		hidden:true
	},
	{
		header: '剂量单位',
		dataIndex: 'doseuom',
		width: 80,
		hidden:true
	},
	{
		header: '频次',
		dataIndex: 'freq',
		width: 80
	},
	{
		header: '用法',
		dataIndex: 'instru',
		width: 80
	},
	{
		header: '医嘱优先级',
		dataIndex: 'priorty',
		width: 80
	},
	{
		header: '医生',
		dataIndex: 'doctor',
		width: 80
	},
	{
		header: '备注',
		dataIndex: 'remark',
		width: 100
	},
	{
		header: '基本药物',
		dataIndex: 'basflag',
		width: 80
	},
	{
		header: '结果',
		dataIndex: 'curret',
		width: 80
	},
	{
		header: '原因',
		dataIndex: 'reason',
		width: 300
	},
	{
		header: '点评药师',
		dataIndex: 'username',
		width: 120
	},
	{
		header: '药师建议',
		dataIndex: 'phadvice',
		width: 100,
		hidden: true
	},
	{
		header: '药师备注',
		dataIndex: 'phnote',
		width: 300,
		hidden: true
	}

	]);

	var commentitmgridds = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		},
		['pcntsno', 'patno', 'patname', 'patsex', 'patage', 'billtype', 'diag', 'inciDesc', 'qty', 'uomdesc', 'price', 'amt', 'dosage', 'doseuom', 'freq', 'instru', 'priorty', 'doctor', 'remark', 'basflag', 'curret', 'reason', 'username', 'phadvice', 'phnote','dosagestr'

		]),

		remoteSort: true
	});

	var commentitmgridPagingToolbar = new Ext.PagingToolbar({
		store: commentitmgridds,
		pageSize: 200,
		//显示右下角信息
		displayInfo: true,
		displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
		prevText: "上一页",
		nextText: "下一页",
		refreshText: "刷新",
		lastText: "最后页",
		firstText: "第一页",
		beforePageText: "当前页",
		afterPageText: "共{0}页",
		emptyMsg: "没有数据"
	});

	var commentitmgrid = new Ext.grid.GridPanel({

		id: 'commentgriditmtbl',
		stripeRows: true,
		region: 'center',
		width: 150,
		autoScroll: true,
		title: "",
		enableHdMenu: false,
		ds: commentitmgridds,
		cm: commentitmgridcm,
		enableColumnMove: false,
		view: new Ext.ux.grid.BufferView({
			// custom row height
			rowHeight: 25,
			// render rows as they come into viewable area.
			scrollDelay: false

		}),

		bbar: commentitmgridPagingToolbar,
		trackMouseOver: 'true'

	});

	///框架定义

	var port = new Ext.Viewport({

		layout: 'border',

		items: [QueryForm, commentitmgrid]

	});

	function FindCNTSData() {

		waitMask = new Ext.LoadMask(Ext.getBody(), {
			msg: "系统正在处理数据，请稍候...",
			removeMask: true
		});
		waitMask.show();

		ClearWindow();

		sdate = Ext.getCmp("startdt").getRawValue();
		edate = Ext.getCmp("enddt").getRawValue();
		result = Ext.getCmp("ResultCmb").getValue()

		QueryStr = sdate + "^" + edate + "^" + result;

		commentitmgridds.proxy = new Ext.data.HttpProxy({
			url: unitsUrl + '?action=FindCNTSIPDetail&QueryStr=' + QueryStr
		});

		commentitmgridds.load({

			params: {
				start: 0,
				limit: commentitmgridPagingToolbar.pageSize
			},

			callback: function(r, options, success) {

				waitMask.hide();
				if (success == false) {
					Ext.Msg.show({
						title: '注意',
						msg: '查询失败 !',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				}
			}

		});

	}

	function ClearWindow() {
		commentitmgridds.removeAll();

	}

	function ExportNTSData() {
		sdate = Ext.getCmp("startdt").getRawValue();
		edate = Ext.getCmp("enddt").getRawValue();
		result = Ext.getCmp("ResultCmb").getValue() 
		QueryStr = sdate + "^" + edate + "^" + result;
		var expwin = new Ext.Window({
			title: '导出excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTIPCNTSDetailByForExp.raq&QueryStr=' + QueryStr + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
		}).show();

	}

});