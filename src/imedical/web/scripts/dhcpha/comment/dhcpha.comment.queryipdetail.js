var unitsUrl = 'dhcpha.comment.query.save.csp';
var idTmr = "";
var comwidth = 150;

Ext.onReady(function() {

	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;

	var ResultData = [['���ϸ�', '1'], ['�����ϸ�', '2'], ['���н��', '4'], ['ȫ��', '3']];

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
		emptyText: 'ѡ��������...',
		fieldLabel: '�������'
	});

	var StDateField = new Ext.form.DateField({

		xtype: 'datefield',
		//format:'j/m/Y' ,
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		//invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		width: comwidth,
		value: new Date
	})

	var EndDateField = new Ext.form.DateField({
		//format:'j/m/Y' ,
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		width: comwidth,
		value: new Date
	})

	var FindButton = new Ext.Button({
		width: 65,
		id: "FindButton",
		text: '��ѯ',
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
		text: '���',
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
		title: '��������ϸ��ѯ(סԺ)',
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

	////��ϸtable 
	var nm = new Ext.grid.RowNumberer();
	var commentitmgridcm = new Ext.grid.ColumnModel([nm,

	{
		header: '��������',
		dataIndex: 'pcntsno',
		width: 120
	},
	{
		header: '�ǼǺ�',
		dataIndex: 'patno',
		width: 100
	},
	{
		header: '����',
		dataIndex: 'patname',
		width: 100
	},
	{
		header: '�Ա�',
		dataIndex: 'patsex',
		width: 60
	},
	{
		header: '����',
		dataIndex: 'patage',
		width: 60
	},
	{
		header: '�ѱ�',
		dataIndex: 'billtype',
		width: 80
	},
	{
		header: '���',
		dataIndex: 'diag',
		width: 200
	},
	{
		header: 'ҽ������',
		dataIndex: 'inciDesc',
		width: 350
	},
	{
		header: '����',
		dataIndex: 'qty',
		width: 60
	},
	{
		header: '��λ',
		dataIndex: 'uomdesc',
		width: 80
	},
	{
		header: '����',
		dataIndex: 'price',
		width: 60,
		hidden:true
	},
	{
		header: '���',
		dataIndex: 'amt',
		width: 60,
		hidden:true
	},
	{
		header: '����',
		dataIndex: 'dosagestr',
		width: 100
	},
	{
		header: '����',
		dataIndex: 'dosage',
		width: 80,
		hidden:true
	},
	{
		header: '������λ',
		dataIndex: 'doseuom',
		width: 80,
		hidden:true
	},
	{
		header: 'Ƶ��',
		dataIndex: 'freq',
		width: 80
	},
	{
		header: '�÷�',
		dataIndex: 'instru',
		width: 80
	},
	{
		header: 'ҽ�����ȼ�',
		dataIndex: 'priorty',
		width: 80
	},
	{
		header: 'ҽ��',
		dataIndex: 'doctor',
		width: 80
	},
	{
		header: '��ע',
		dataIndex: 'remark',
		width: 100
	},
	{
		header: '����ҩ��',
		dataIndex: 'basflag',
		width: 80
	},
	{
		header: '���',
		dataIndex: 'curret',
		width: 80
	},
	{
		header: 'ԭ��',
		dataIndex: 'reason',
		width: 300
	},
	{
		header: '����ҩʦ',
		dataIndex: 'username',
		width: 120
	},
	{
		header: 'ҩʦ����',
		dataIndex: 'phadvice',
		width: 100,
		hidden: true
	},
	{
		header: 'ҩʦ��ע',
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
		//��ʾ���½���Ϣ
		displayInfo: true,
		displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		prevText: "��һҳ",
		nextText: "��һҳ",
		refreshText: "ˢ��",
		lastText: "���ҳ",
		firstText: "��һҳ",
		beforePageText: "��ǰҳ",
		afterPageText: "��{0}ҳ",
		emptyMsg: "û������"
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

	///��ܶ���

	var port = new Ext.Viewport({

		layout: 'border',

		items: [QueryForm, commentitmgrid]

	});

	function FindCNTSData() {

		waitMask = new Ext.LoadMask(Ext.getBody(), {
			msg: "ϵͳ���ڴ������ݣ����Ժ�...",
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
						title: 'ע��',
						msg: '��ѯʧ�� !',
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
			title: '����excel',
			width: Ext.getBody().getViewSize().width,
			height: Ext.getBody().getViewSize().height,
			html: '<iframe id="DHCSTCNTSDetailExp" src="dhccpmrunqianreport.csp?reportName=DHCSTIPCNTSDetailByForExp.raq&QueryStr=' + QueryStr + '" frameborder="0" width="100%" height="100%"></iframe>',
			layout: 'fit',
			plain: true,
			modal: true
		}).show();

	}

});