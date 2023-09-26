// ����:��Ӧ������
// ��д����:2016-06-13

var EvalIndexUrl = 'dhcstm.vendorindexaction.csp';

var CodeField = {
	id: 'CodeField',
	xtype: 'textfield',
	fieldLabel: '����',
	allowBlank: true,
	anchor: '90%',
	selectOnFocus: true,
	emptyText: '��Ӧ�̴���...'
};

var NameField = {
	id: 'NameField',
	xtype: 'textfield',
	fieldLabel: '����',
	allowBlank: true,
	anchor: '90%',
	selectOnFocus: true,
	emptyText: '��Ӧ������...'
};

var FindVenButton = {
	xtype: 'uxbutton',
	text: '��ѯ',
	iconCls: 'page_find',
	handler: function () {
		VendorGrid.load();
	}
}

var VendorCm = [{
		dataIndex: 'RowId',
		header: 'RowId',
		hidden: true
	}, {
		dataIndex: 'Code',
		header: '��Ӧ�̴���',
		width: 150
	}, {
		dataIndex: 'Name',
		header: '��Ӧ������',
		width: 260
	}
];

function VendorParamsFn() {
	var Code = Ext.getCmp("CodeField").getValue();
	var Name = Ext.getCmp("NameField").getValue();
	var Status = "A";
	var StrParam = Code + "^" + Name + "^" + Status;
	return {
		StrParam: StrParam
	};
}

function VendorRowSelFn(grid, rowIndex, r) {
	var VendorId = r.get('RowId');
	var StrParam = VendorId;
	EvalIndexGrid.load({
		params: {
			StrParam: StrParam
		}
	});
}

var VendorGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'west',
		width: 450,
		id: 'VendorGrid',
		title: '��Ӧ��',
		editable: false,
		childGrid: ["EvalIndexGrid"],
		contentColumns: VendorCm,
		smType: "row",
		singleSelect: false,
		smRowSelFn: VendorRowSelFn,
		autoLoadStore: true,
		actionUrl: EvalIndexUrl,
		queryAction: "GetAllVendor",
		idProperty: "RowId",
		checkProperty: "",
		paramsFn: VendorParamsFn,
		showTBar: false,
		tbar: [CodeField, ' ', NameField, ' ', FindVenButton]
	});

VendorGrid.getSelectionModel().on('rowdeselect', function (sm, rowIndex, r) {
	EvalIndexGrid.removeAll();
});

var addEvalIndex = new Ext.Toolbar.Button({
		text: '�½�',
		tooltip: '�½�',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			EvalIndexGrid.addNewRow();
		}
	});

var SaveEvalIndex = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'page_save',
		height: 30,
		width: 70,
		handler: function () {
			Save();
		}
	});

var EvalueIndexStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: EvalIndexUrl + '?actiontype=EvalueIndex'
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['Description', 'RowId'])
	});
EvalueIndexStore.load();
var IndexList = new Ext.form.ComboBox({
		fieldLabel: '����ָ��',
		id: 'IndexList',
		name: 'IndexList',
		anchor: '90%',
		width: 200,
		store: EvalueIndexStore,
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: false,
		triggerAction: 'all',
		emptyText: '����ָ��...',
		selectOnFocus: true,
		forceSelection: true,
		listWidth: 200,
		valueNotFoundText: '',
		listeners: {
			select: function (combo, record, index) {
				var IndexId = record.get(this.valueField);
				var row = EvalIndexGrid.getSelectedCell()[0];
				var rowData = EvalIndexGrid.getAt(row);
				var rowCount = EvalIndexGrid.getCount();
				for (var i = 0; i < rowCount - 1; i++) {
					var Index = EvalIndexGrid.getAt(i).get("Index");
					var EvalDate = EvalIndexGrid.getAt(i).get("Date").format(DateFormat);
					var nowDate = new Date().format(DateFormat);
					if ((Index == IndexId) && (EvalDate == nowDate)) {
						Msg.info("warning", "ͬһʱ��������ָ�겻����ͬ!");
						return false;
					}
				}
				var Weight = tkMakeServerCall('web.DHCSTM.DHCVendorEvaluationIndex', 'GetWeight', IndexId);
				rowData.set("Weight", Weight);
				var SysIndex = tkMakeServerCall('web.DHCSTM.DHCVendorEvaluationIndex', 'GetSySIndex', IndexId);
				if (SysIndex = 1) {
					var Vendor = VendorGrid.getSelected().get('RowId');
					var Ret = tkMakeServerCall('web.DHCSTM.DHCVendorEvaluationIndex', 'GetSysIndexScore', IndexId, Vendor);
					var list = Ret.split("#");
					rowData.set("Score", list[1]);
					rowData.set("Remark", list[0]);
				}
				rowData.set("Date", new Date());
				EvalIndexGrid.startEditing(EvalIndexGrid.getCount() - 1, 4);
			}
		}
	});

var EvalIndexCm = [{
		header: 'RowId',
		dataIndex: 'RowId',
		hidden: true
	}, {
		header: '����ָ��',
		dataIndex: 'Index',
		width: 160,
		xtype: 'combocolumn',
		valueField: 'Index',
		displayField: 'Desc',
		editor: IndexList
	}, {
		header: 'Ȩ��',
		dataIndex: 'Weight',
		width: 80
	}, {
		header: '����',
		dataIndex: 'Score',
		width: 100,
		editor: new Ext.form.NumberField({
			id: 'weightField',
			allowBlank: false,
			allowNegative: false,
			maxValue: 5,
			minValue: 0,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var Score = field.getValue();
						if (Score == null || Score.length <= 0) {
							Msg.info("warning", "��������Ϊ��!");
							return;
						}
						if (Score < 0) {
							Msg.info("warning", "��������С��0!");
							return;
						}
						if (Score > 5) {
							Msg.info("warning", "�������ܴ���5!");
							return;
						}
						var col = GetColIndex(EvalIndexGrid, 'Remark');
						EvalIndexGrid.startEditing(EvalIndexGrid.getCount() - 1, col);
					}
				}
			}
		})
	}, {
		header: '��ע',
		dataIndex: 'Remark',
		width: 140,
		editor: new Ext.form.TextField({
			allowBlank: true,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						EvalIndexGrid.addNewRow();
					}
				}
			}
		})
	}, {
		header: "��������",
		dataIndex: 'Date',
		xtype: 'datecolumn',
		width: 100,
		align: 'left',
		sortable: true
	}
];

var EvalIndexGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'EvalIndexGrid',
		title: '����ָ��',
		region: 'center',
		contentColumns: EvalIndexCm,
		singleSelect: false,
		selectFirst: false,
		actionUrl: EvalIndexUrl,
		queryAction: "GetEvalIndex",
		idProperty: "RowId",
		checkProperty: 'Index',
		showTBar: false,
		tbar: [addEvalIndex, SaveEvalIndex, "<font color=blue>ע������Ϊ�����</font>"],
		paging: true
	});

function Save() {
	var VendorIdStr = "",ListData = "";
	var VendorSels = VendorGrid.getSelections();
	if (Ext.isEmpty(VendorSels)) {
		Msg.info("warning", "��ѡ����Ҫ��ֵĹ�Ӧ��!");
		return;
	} else {
		for (var i = 0, len = VendorSels.length; i < len; i++) {
			var VenorId = VendorSels[i].get('RowId');
			if (VendorIdStr == "") {
				VendorIdStr = VenorId;
			} else {
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var EvalStr = "";
	var EvalSels = EvalIndexGrid.getModifiedRecords();
	if (Ext.isEmpty(EvalSels)) {
		Msg.info("warning", "û����Ҫ�������Ϣ!");
		return;
	} else {
		for (var i = 0, len = EvalSels.length; i < len; i++) {
			var RowId = EvalSels[i].get('RowId');
			var Index = EvalSels[i].get('Index');
			var Score = EvalSels[i].get('Score');
			var Remark = EvalSels[i].get('Remark');
			var Weight = EvalSels[i].get('Weight');
			if (Weight == "" || typeof(Weight) == 'undefined') {
				Msg.info("warning", "ͬһʱ��������ָ�겻����ͬ!");
				return;
			}
			if (Score == "" || typeof(Score) == 'undefined') {
				Msg.info("warning", "���ڷ���Ϊ�յ�����,���ܱ���!");
				return;
			}
			var Date = Ext.util.Format.date(EvalSels[i].get('Date'), ARG_DATEFORMAT);
			var EvalStr = RowId + "^" + Index + "^" + Score + "^" + Remark + "^" + Date;
			if (ListData == "") {
				ListData = EvalStr;
			} else {
				ListData = ListData + RowDelim + EvalStr;
			}
		}
	}
	Ext.Ajax.request({
		url: EvalIndexUrl + '?actiontype=Save',
		params: {
			VendorIdStr: VendorIdStr,
			ListData: ListData
		},
		waitMsg: '������...',
		failure: function (result, request) {
			Msg.info("error", "������������!");
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "����ɹ�!");
				EvalIndexGrid.reload();
			} else {
				var ret = jsonData.info;
				if (ret == -3) {
					Msg.info("error", "ָ��Ȩ��֮�Ͳ��ܴ���1!");
				} else {
					Msg.info("error", "����ʧ��:" + ret);
				}
			}
		},
		scope: this
	});
}

function DelEvalIndex() {
	//	var VendorIdStr = "", ScgStr = "";
	//	var VendorSels = VendorGrid.getSelections();
	//	if(Ext.isEmpty(VendorSels)){
	//		Msg.info("warning","��ѡ����Ҫȡ����Ȩ�Ĺ�Ӧ��!");
	//		return;
	//	}else{
	//		for(var i=0,len=VendorSels.length; i<len; i++){
	//			var VenorId = VendorSels[i].get('RowId');
	//			if(VendorIdStr==""){
	//				VendorIdStr = VenorId;
	//			}else{
	//				VendorIdStr = VendorIdStr + "^" + VenorId;
	//			}
	//		}
	//	}
	//	var EvalSels = EvalIndexGrid.getSelections();
	//	if(Ext.isEmpty(EvalSels)){
	//		Msg.info("warning","��ѡ����Ҫȡ����Ȩ������!");
	//		return;
	//	}else{
	//		for(var i=0,len=EvalSels.length; i<len; i++){
	//			var Scg = EvalSels[i].get('Scg');
	//			if(ScgStr==""){
	//				ScgStr = Scg;
	//			}else{
	//				ScgStr = ScgStr + "^" + Scg;
	//			}
	//		}
	//	}
	//	Ext.Ajax.request({
	//		url : EvalIndexUrl + '?actiontype=Delete',
	//		params : {VendorIdStr : VendorIdStr, ScgStr : ScgStr},
	//		waitMsg:'ɾ����...',
	//		failure: function(result, request) {
	//			Msg.info("error","������������!");
	//		},
	//		success: function(result, request) {
	//			var jsonData = Ext.util.JSON.decode( result.responseText );
	//			if (jsonData.success=='true') {
	//				Msg.info("success","ɾ���ɹ�!");
	//				EvalIndexGrid.reload();
	//			}else{
	//				Msg.info("error","ɾ��ʧ��!");
	//			}
	//		},
	//		scope: this
	//	});
}

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [VendorGrid, EvalIndexGrid],
			renderTo: 'mainPanel'
		});
});
