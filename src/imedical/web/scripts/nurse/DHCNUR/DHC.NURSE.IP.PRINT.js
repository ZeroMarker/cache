/// Creator:      pengjunfu
/// CreatDate:    2013.08.2
/// Description:  补打
function InitializeForm() {

	var recordStore = CreateStore("Nur.NursePrintRecord", "getPrintRecord");
	var recordGrid = new Ext.grid.GridPanel({
				id : 'record',
				store : recordStore,
				cm : CreateColumnModel("Nur.NursePrintRecord", "getPrintRecord"),
				loadMask : true,
				tbar : new Ext.Toolbar({
							items : [
									"起始日期",
									{
										xtype:'datefield',
										format: 'Y-m-d',
										id:'dateFrom',
										value:session['TODAY']
									},
									"-",
									"结束日期",
									{
										xtype:'datefield',
										format: 'Y-m-d',
										id:'dateTo',
										value:session['TODAY']
									},					
									"-", 
									{
										xtype : 'button',
										id : 'btnSearch',
										text : "查询",
										listeners:{
											"click":function(){
												Search_Click()
											}
										}
									}]
						}),
				bbar : new Ext.PagingToolbar({
							pageSize : 1000,
							store : recordStore
						})
			});
	var subRecordStore = CreateStore("Nur.NursePrintRecordSub", "getPrintSubRecord");
	var subRecordGrid = new Ext.grid.GridPanel({
				id : 'subRecord',
				store : subRecordStore,
				sm : new Ext.grid.CheckboxSelectionModel ({singleSelect : false}),
				cm : CreateColumnModel("Nur.NursePrintRecordSub", "getPrintSubRecord"),
				loadMask : true,
				tbar : new Ext.Toolbar({
							items : [
									{
										xtype : 'button',
										id : 'btnPrint',
										text : "打印",
										listeners:{
											"click":function(){
												print_Click()
											}
										}
									}]
						}),
				bbar : new Ext.PagingToolbar({
							pageSize : 1000,
							store : subRecordStore
						})
			});
	
	var viewPort = new Ext.Viewport({
				layout : 'hbox',
				id : "viewPort",
				layoutConfig : { align : 'stretch' },
				defaults : {
					border : true,
					frame : true,
					flex : 1,
					bodyBorder : true
				},
				items : [ 
							recordGrid,
							subRecordGrid
						]
			});

}
// 初始化组件初始值
function InitializeValue() {
	var recordGrid=Ext.getCmp("record");
	var subRecordGrid=Ext.getCmp("subRecord")
	var store = recordGrid.getStore();
	store.on("beforeload", function(store) {
				store.baseParams.locId= session['LOGON.CTLOCID'];
				store.baseParams.startDate= Ext.getCmp("dateFrom").getRawValue();
				store.baseParams.startTime= "";
				store.baseParams.endDate= Ext.getCmp("dateTo").getRawValue();
				store.baseParams.endTime= "";
				
			})

	recordGrid.on("rowclick",function(g,i,e) {
						var r=g.getStore().getAt(i) 
						var id=r.get("id");
						queryTypeCode=r.get("queryTypeCode");
						printFlag=r.get("printFlag");
						printType=r.get("printType")

						var subRecordStore=subRecordGrid.getStore();
						subRecordStore.baseParams.id=id;
						subRecordStore.load({
							params : {
								start : 0,
								limit : 1000
							}
						});
					})
 	var selectEnvent=function(sm, row, rec){
			var subOrdFlag=0;
			if(rec.get("医嘱名称").indexOf("____")>-1){
				subOrdFlag=1;
			}

			var selected=sm.isSelected(rec);
			var i;
			var store=subRecordGrid.getStore();
			sm.suspendEvents();
			for(i=row+1;i<store.getCount();i++)
			{
				if(store.getAt(i).get("医嘱名称").indexOf("____")>-1){
						if(selected){
							sm.selectRow(i,true);
						}else{
							sm.deselectRow(i);
						}
						
				}else{
					break;
				}
			}
			if(subOrdFlag==0){
				sm.resumeEvents();
				return;
			}
			for(i=row-1;i>=0;i--)
			{
				if(store.getAt(i).get("医嘱名称").indexOf("____")>-1){
					if(selected){
						sm.selectRow(i,true);
					}else{
						sm.deselectRow(i);
					}
				}
				else{
					if(selected){
						sm.selectRow(i,true);
					}else{
						sm.deselectRow(i);
					}
					sm.resumeEvents();
					return;
				}
			}

	}
	subRecordGrid.getSelectionModel().on("rowselect",selectEnvent)
	subRecordGrid.getSelectionModel().on("rowdeselect",selectEnvent)
	subRecordGrid.getColumnModel().setColumnWidth(1,300)
	subRecordGrid.getColumnModel().setColumnWidth(2,100)
	subRecordGrid.getColumnModel().setColumnWidth(3,100)
}
function Search() {
		Ext.getCmp("record").getStore().load({
				params : {
					start : 0,
					limit : 1000
				}
			});
		

}

function print_Click(){
	var subRecordGrid=Ext.getCmp("subRecord");
	clearPrintSetting();
	printSetting.queryTypeCode=queryTypeCode;
	printSetting.printFlag=printFlag;
	printSetting.printType=printType;
	var selectedRecords=subRecordGrid.getSelectionModel().getSelections();
	
	for(var i=0;i<selectedRecords.length;i++){
		printSetting.printCollectData[printSetting.printCollectData.length]=selectedRecords[i].get("oeoreId");
		printSetting.printSeqNoData[printSetting.printSeqNoData.length]=selectedRecords[i].get("seqNo");
		printSetting.printLabNoData[printSetting.printLabNoData.length]=selectedRecords[i].get("labNo");
		printSetting.printIdData[printSetting.printIdData.length]=selectedRecords[i].get("oeoreId");
	}
	printSetting.save=false;

	NurseExcuteSheetPrint();

}
function Search_Click() {
	Search()
}

function CreateColumnModel(className, methodName) {
	var cm = new Ext.grid.ColumnModel(eval("("
			+ tkMakeServerCall("Nur.QueryBroker", "GenerateColumnModel",
					className, methodName,"",1) + ")"))
	return cm;
}
function CreateStore(className, methodName) {
	var store = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : "../csp/dhc.nurse.ext.common.getdata.csp"
						}),
				reader : new Ext.data.JsonReader(eval("("
						+ tkMakeServerCall("Nur.QueryBroker",
								"GenerateMetaData", className, methodName)
						+ ")")),
				baseParams : {
					className : className,
					methodName : methodName,
					type : 'Query'
				}
			});
	return store;
}
function CreateComboBox(id, displayField, valueField, fieldLabel, value, width,
		className, methodName, queryParam, column) {
	var combox = new Ext.form.ComboBox({
				store : CreateStore(className, methodName),
				displayField : displayField,
				valueField : valueField,
				fieldLabel : fieldLabel,
				id : id,
				value : value,
				colspan : column,
				width : width,
				hideTrigger : true,
				queryParam : queryParam,
				forceSelection : true,
				triggerAction : 'all',
				minChars : 1,
				pageSize : 10,
				typeAhead : true,
				typeAheadDelay : 1000,
				loadingText : 'Searching...'
			})
	combox.on("expand", function(comboBox) {
				comboBox.list.setWidth('auto');
				comboBox.innerList.setWidth('auto');
			}, this, {
				single : true
			})
	return combox;
}
Ext.onReady(function() {
			InitializeForm();
			InitializeValue()
			Search();
		});