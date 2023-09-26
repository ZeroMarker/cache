// 名称:供应商评价
// 编写日期:2016-06-13

var EvalIndexUrl = 'dhcstm.vendorindexaction.csp';

var CodeField = {
	id: 'CodeField',
	xtype: 'textfield',
	fieldLabel: '代码',
	allowBlank: true,
	anchor: '90%',
	selectOnFocus: true,
	emptyText: '供应商代码...'
};

var NameField = {
	id: 'NameField',
	xtype: 'textfield',
	fieldLabel: '名称',
	allowBlank: true,
	anchor: '90%',
	selectOnFocus: true,
	emptyText: '供应商名称...'
};

var FindVenButton = {
	xtype: 'uxbutton',
	text: '查询',
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
		header: '供应商代码',
		width: 150
	}, {
		dataIndex: 'Name',
		header: '供应商名称',
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
		title: '供应商',
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
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			EvalIndexGrid.addNewRow();
		}
	});

var SaveEvalIndex = new Ext.Toolbar.Button({
		text: '保存',
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
		fieldLabel: '评价指标',
		id: 'IndexList',
		name: 'IndexList',
		anchor: '90%',
		width: 200,
		store: EvalueIndexStore,
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: false,
		triggerAction: 'all',
		emptyText: '评价指标...',
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
						Msg.info("warning", "同一时间内评价指标不能相同!");
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
		header: '评价指标',
		dataIndex: 'Index',
		width: 160,
		xtype: 'combocolumn',
		valueField: 'Index',
		displayField: 'Desc',
		editor: IndexList
	}, {
		header: '权重',
		dataIndex: 'Weight',
		width: 80
	}, {
		header: '分数',
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
							Msg.info("warning", "分数不能为空!");
							return;
						}
						if (Score < 0) {
							Msg.info("warning", "分数不能小于0!");
							return;
						}
						if (Score > 5) {
							Msg.info("warning", "分数不能大于5!");
							return;
						}
						var col = GetColIndex(EvalIndexGrid, 'Remark');
						EvalIndexGrid.startEditing(EvalIndexGrid.getCount() - 1, col);
					}
				}
			}
		})
	}, {
		header: '备注',
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
		header: "评价日期",
		dataIndex: 'Date',
		xtype: 'datecolumn',
		width: 100,
		align: 'left',
		sortable: true
	}
];

var EvalIndexGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'EvalIndexGrid',
		title: '评价指标',
		region: 'center',
		contentColumns: EvalIndexCm,
		singleSelect: false,
		selectFirst: false,
		actionUrl: EvalIndexUrl,
		queryAction: "GetEvalIndex",
		idProperty: "RowId",
		checkProperty: 'Index',
		showTBar: false,
		tbar: [addEvalIndex, SaveEvalIndex, "<font color=blue>注：分数为五分制</font>"],
		paging: true
	});

function Save() {
	var VendorIdStr = "",ListData = "";
	var VendorSels = VendorGrid.getSelections();
	if (Ext.isEmpty(VendorSels)) {
		Msg.info("warning", "请选择需要打分的供应商!");
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
		Msg.info("warning", "没有需要保存的信息!");
		return;
	} else {
		for (var i = 0, len = EvalSels.length; i < len; i++) {
			var RowId = EvalSels[i].get('RowId');
			var Index = EvalSels[i].get('Index');
			var Score = EvalSels[i].get('Score');
			var Remark = EvalSels[i].get('Remark');
			var Weight = EvalSels[i].get('Weight');
			if (Weight == "" || typeof(Weight) == 'undefined') {
				Msg.info("warning", "同一时间内评价指标不能相同!");
				return;
			}
			if (Score == "" || typeof(Score) == 'undefined') {
				Msg.info("warning", "存在分数为空的数据,不能保存!");
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
		waitMsg: '保存中...',
		failure: function (result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				EvalIndexGrid.reload();
			} else {
				var ret = jsonData.info;
				if (ret == -3) {
					Msg.info("error", "指标权重之和不能大于1!");
				} else {
					Msg.info("error", "保存失败:" + ret);
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
	//		Msg.info("warning","请选择需要取消授权的供应商!");
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
	//		Msg.info("warning","请选择需要取消授权的类组!");
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
	//		waitMsg:'删除中...',
	//		failure: function(result, request) {
	//			Msg.info("error","请检查网络连接!");
	//		},
	//		success: function(result, request) {
	//			var jsonData = Ext.util.JSON.decode( result.responseText );
	//			if (jsonData.success=='true') {
	//				Msg.info("success","删除成功!");
	//				EvalIndexGrid.reload();
	//			}else{
	//				Msg.info("error","删除失败!");
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
