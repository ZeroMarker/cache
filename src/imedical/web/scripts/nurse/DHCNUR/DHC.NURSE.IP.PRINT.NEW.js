/// Creator:      pengjunfu
/// CreatDate:    2013.08.2
/// Description:  补打

var className = "Nur.NurseOperationRecord"
var subClassName = "Nur.NurseOperationRecordSub"

function InitializeForm() {

	var recordStore = CreateStore(className, "getOperationRecord");
	var recordGrid = new Ext.grid.GridPanel({
		id: 'record',
		store: recordStore,
		cm: CreateColumnModel(className, "getOperationRecord"),
		loadMask: true,
		tbar: new Ext.Toolbar({
			items: [
				"起始日期", {
					xtype: 'datefield',
					format: 'Y-m-d',
					id: 'dateFrom',
					value: session['TODAY']
				},
				"-",
				"结束日期", {
					xtype: 'datefield',
					format: 'Y-m-d',
					id: 'dateTo',
					value: session['TODAY']
				},
				"-",
				"操作类型",
				CreateComboBox('operationType', 'operationTypeDesc', 'operationTypeId', '', "", 90, 'Nur.NurseOperationType', 'findOperationType'),
				"-", {
					xtype: 'button',
					id: 'btnSearch',
					text: "查询",
					listeners: {
						"click": function() {
							Search_Click()
						}
					}
				}
			]
		}),
		bbar: new Ext.PagingToolbar({
			pageSize: 1000,
			store: recordStore
		})
	});
	var subRecordStore = CreateStore(subClassName, "getOperationSubRecord");
	var sm=new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		});
	var columnArray = eval("(" + tkMakeServerCall("Nur.ExtCore", "GenerateColumnModel",
		subClassName, "getOperationSubRecord", "", 1) + ")");
	var newColumnArray=new Array();
	newColumnArray.push(sm);
	for(var i=0;i<columnArray.length;i++){
		newColumnArray.push(columnArray[i]);
	}
	var subRecordGrid = new Ext.grid.GridPanel({
		id: 'subRecord',
		store: subRecordStore,
		sm: sm,
		cm:new Ext.grid.ColumnModel(newColumnArray),
		loadMask: true,
		tbar: new Ext.Toolbar({
			items: [{
				xtype: 'button',
				id: 'btnPrint',
				text: "打印",
				listeners: {
					"click": function() {
						print_Click()
					}
				}
			}]
		}),
		bbar: new Ext.PagingToolbar({
			pageSize: 1000,
			store: subRecordStore
		})
	});

	var viewPort = new Ext.Viewport({
		layout: 'hbox',
		id: "viewPort",
		layoutConfig: {
			align: 'stretch'
		},
		defaults: {
			border: true,
			frame: true,
			flex: 1,
			bodyBorder: true
		},
		items: [
			recordGrid,
			subRecordGrid
		]
	});



}
// 初始化组件初始值
function InitializeValue() {
	var recordGrid = Ext.getCmp("record");
	var subRecordGrid = Ext.getCmp("subRecord")
	var store = recordGrid.getStore();
	store.on("beforeload", function(store) {
	
		
		store.baseParams.parameter1 = session['LOGON.CTLOCID'];
		store.baseParams.parameter2 = Ext.getCmp("operationType").getValue();
		store.baseParams.parameter3 = Ext.getCmp("dateFrom").getRawValue();
		store.baseParams.parameter4 = "";
		store.baseParams.parameter5 = Ext.getCmp("dateTo").getRawValue();
		store.baseParams.parameter6 = "";


	})

	recordGrid.on("rowclick", function(g, i, e) {
		var r = g.getStore().getAt(i)
		var id = r.get("id");
		queryTypeCode = r.get("queryTypeCode");
		printFlag = r.get("printFlag");
		printType = r.get("printType");
		var oprationTypeDesc=r.get("操作类型");
		
		if(oprationTypeDesc.indexOf("打印")==-1){
			Ext.getCmp("btnPrint").hide();
		}else{
			Ext.getCmp("btnPrint").show();
		}
		var hd_checker = subRecordGrid.getEl().select('div.x-grid3-hd-checker'); 
	    var hd = hd_checker.first();  
	    if(hd != null){ 
	    hd.removeClass('x-grid3-hd-checker-on');
	}
		var subRecordStore = subRecordGrid.getStore();
		subRecordStore.baseParams.parameter1 = id;
		subRecordStore.load({
			params: {
				start: 0,
				limit: 1000
			}
		});
	})
	var selectEnvent = function(sm, row, rec) {
		var subOrdFlag = 0;
		if (rec.get("医嘱名称").indexOf("___") > -1) {
			subOrdFlag = 1;
		}

		var selected = sm.isSelected(rec);
		var i;
		var store = subRecordGrid.getStore();
		sm.suspendEvents();
		for (i = row + 1; i < store.getCount(); i++) {
			if (store.getAt(i).get("医嘱名称").indexOf("___") > -1) {
				if (selected) {
					sm.selectRow(i, true);
				} else {
					sm.deselectRow(i);
				}

			} else {
				break;
			}
		}
		if (subOrdFlag == 0) {
			sm.resumeEvents();
			return;
		}
		for (i = row - 1; i >= 0; i--) {
			if (store.getAt(i).get("医嘱名称").indexOf("___") > -1) {
				if (selected) {
					sm.selectRow(i, true);
				} else {
					sm.deselectRow(i);
				}
			} else {
				if (selected) {
					sm.selectRow(i, true);
				} else {
					sm.deselectRow(i);
				}
				sm.resumeEvents();
				return;
			}
		}

	}
	subRecordGrid.getSelectionModel().on("rowselect", selectEnvent)
	subRecordGrid.getSelectionModel().on("rowdeselect", selectEnvent)
	subRecordGrid.getColumnModel().setColumnWidth(1, 300)
	subRecordGrid.getColumnModel().setColumnWidth(2, 100)
	subRecordGrid.getColumnModel().setColumnWidth(3, 100)
	subRecordGrid.getColumnModel().setColumnWidth(4, 100)
	
	recordGrid.getColumnModel().setColumnWidth(0, 80)
	recordGrid.getColumnModel().setColumnWidth(1, 80)
	recordGrid.getColumnModel().setColumnWidth(2, 80)
	recordGrid.getColumnModel().setColumnWidth(3, 80)
	recordGrid.getColumnModel().setColumnWidth(4, 80)

	Ext.getCmp("operationType").on("select",function(){
		
		store.load({
			params: {
				start: 0,
				limit: 1000
			}
		});
	});
}

function Search() {
	Ext.getCmp("record").getStore().load({
		params: {
			start: 0,
			limit: 1000
		}
	});
	Ext.getCmp("subRecord").getStore().removeAll();



}

function print_Click() {
	var subRecordGrid = Ext.getCmp("subRecord");
	clearOperationObject();
	operationObject.queryTypeCode = queryTypeCode;
	operationObject.printFlag = printFlag;
	operationObject.printType = printType;
	operationObject.saveFlag = false;
	var selectedRecords = subRecordGrid.getSelectionModel().getSelections();

	for (var i = 0; i < selectedRecords.length; i++) {
		operationObject.oeoreIdArray[operationObject.oeoreIdArray.length] = selectedRecords[i].get("oeoreId");
		operationObject.seqNoArray[operationObject.seqNoArray.length] = selectedRecords[i].get("seqNo");
		operationObject.labNoArray[operationObject.labNoArray.length] = selectedRecords[i].get("labNo");
		operationObject.unFilterOeoreIdArray[operationObject.unFilterOeoreIdArray.length] = selectedRecords[i].get("oeoreId");
	}


	NurseExcuteSheetPrint();

}

function Search_Click() {
	Search()
}

function CreateColumnModel(className, methodName) {
	var cm = new Ext.grid.ColumnModel(eval("(" + tkMakeServerCall("Nur.ExtCore", "GenerateColumnModel",
		className, methodName, "", 1) + ")"))
	return cm;
}

function CreateStore(className, methodName) {
	var store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: "../csp/dhc.nurse.extjs.getdata.csp"
		}),
		reader: new Ext.data.JsonReader(eval("(" + tkMakeServerCall("Nur.ExtCore",
			"GenerateMetaData", className, methodName) + ")")),
		baseParams: {
			className: className,
			methodName: methodName
		}
	});
	return store;
}

function CreateComboBox(id, displayField, valueField, fieldLabel, value, width,
	className, methodName) {
	var combox = new Ext.form.ComboBox({
		store: CreateStore(className, methodName),
		displayField: displayField,
		valueField: valueField,
		fieldLabel: fieldLabel,
		id: id,
		value: value,
		width: width,
		forceSelection: true,
		triggerAction: 'all',
		minChars: 1,
		pageSize: 10,
		typeAhead: true,
		typeAheadDelay: 1000,
		loadingText: 'Searching...'
	})

	return combox;
}
Ext.onReady(function() {
	InitializeForm();
	InitializeValue()
	Search();
});