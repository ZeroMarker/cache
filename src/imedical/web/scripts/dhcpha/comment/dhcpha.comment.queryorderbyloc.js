var unitsUrl = 'dhcpha.comment.query.save.csp';
var idTmr = "";
var comwidth = 150;
var QueryStr = "";

Ext.onReady(function() {

	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var SortTypeDs = [['��������', '1'], ['��������', '2']];

	var SortTypestore = new Ext.data.SimpleStore({
		fields: ['num', 'id'],
		data: SortTypeDs
	});

	var SortTypeCombo = new Ext.form.ComboBox({
		store: SortTypestore,
		displayField: 'num',
		mode: 'local',
		width: comwidth,
		id: 'SortTypeCmb',
		emptyText: '',
		valueField: 'id',
		emptyText: 'ѡ������ʽ...',
		fieldLabel: '����ʽ'
	});

	var ResultData = [['���ϸ�', '1'], ['�����ϸ�', '2']];

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
		title: '��������������ǰ20��',
		frame: true,
		height: 120,
		tbar: [FindButton, ExportButton],
		items: [{
			layout: "column",
			frame:true,
			items: [{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [StDateField]
			},
			{
				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [EndDateField]

			},
			{

				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [ResultCombo]
			},			{

				labelAlign: 'right',
				columnWidth: .2,
				layout: "form",
				items: [SortTypeCombo]
			}]
		}]

	});

	////��ϸtable 
	var nm = new Ext.grid.RowNumberer();
	var commentitmgridcm = new Ext.grid.ColumnModel([nm,

	{
		header: '����',
		dataIndex: 'desc',
		width: 200
	},
	{
		header: '������',
		dataIndex: 'descnum',
		width: 200
	},
	{
		header: '������',
		dataIndex: 'desccent',
		width: 200
	}

	]);

	var commentitmgridds = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		},
		['desc', 'descnum', 'desccent'

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
		//height:290,
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
			scrollDelay: false,

			getRowClass: function(record, index, rowParams, store) {

				if (record.data.colorflag > 0) {

					return 'x-grid-record-green';

				}

			}

		}),

		bbar: commentitmgridPagingToolbar,
		trackMouseOver: 'true'

	});

	///��ܶ���

	var port = new Ext.Viewport({

		layout: 'border',

		items: [QueryForm, commentitmgrid]

	});

	///----------------Events----------------

	FindCNTSData = function() {

		ClearWindow();
		sorttype = Ext.getCmp("SortTypeCmb").getValue();
		if (sorttype == "") {
			Ext.Msg.show({
				title: 'ע��',
				msg: '����ʽΪ������ !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
        result = Ext.getCmp("ResultCmb").getValue();
		if (result == "") {
			Ext.Msg.show({
				title: 'ע��',
				msg: '�������Ϊ������ !',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.INFO
			});
			return;
		}
		QueryStr = GetQueryStr();

		commentitmgridds.proxy = new Ext.data.HttpProxy({
			url: unitsUrl + '?action=QueryOrderByLoc&QueryStr=' + QueryStr
		});

		commentitmgridds.load({

			params: {
				start: 0,
				limit: commentitmgridPagingToolbar.pageSize
			},

			callback: function(r, options, success) {

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

	function OpenExpWin(QueryStr, QueryFlag) {
		var excelUrl = 'dhccpmrunqianreport.csp?reportName=DHCSTCNTSSortByDocExp.raq&QueryStr=' + QueryStr + "&QueryFlag=" + QueryFlag;
		var NewWin =open(excelUrl,"����Excel","top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes");

	}

	function ExportNTSData() {

		QueryStr = GetQueryStr();
		var QueryFlag = 2 ;
		OpenExpWin(QueryStr, QueryFlag)

	}

	function ExportNTSData() {

		QueryStr = GetQueryStr();
		var QueryFlag = 2 ;
		OpenExpWin(QueryStr, QueryFlag)

	}

	function GetQueryStr() {
		sdate = Ext.getCmp("startdt").getRawValue();
		edate = Ext.getCmp("enddt").getRawValue();
		result = Ext.getCmp("ResultCmb").getValue();
		sorttype = Ext.getCmp("SortTypeCmb").getValue();
		ret = sdate + "^" + edate + "^" + result + "^" + sorttype;
		return ret;
	}

});