function OE_InitOEOrder(EpisodeID,StepID,SubCatID,ItemID){
	var obj = new Object();
	obj.currRowIndex = '';
	obj.currArcimID = '';
	obj.EpisodeID = EpisodeID;
	obj.StepID = StepID;
	obj.SubCatID = SubCatID;
	obj.ItemID = ItemID;
	
	obj.OE_btnSave = new Ext.Button({
		id : 'OE_btnSave'
		,iconCls : 'icon-confirm'
		,width: 80
		,text : '确定'
	});
	obj.OE_btnCancel = new Ext.Button({
		id : 'OE_btnCancel'
		,iconCls : 'icon-exit'
		,width: 80
		,text : '关闭'
	});
	
	obj.OE_gridOEOrderStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OE_gridOEOrderStore = new Ext.data.GroupingStore({
		proxy: obj.OE_gridOEOrderStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IGAIndex'
		},[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'ItemID', mapping : 'ItemID'}
			,{name: 'ItemDesc', mapping : 'ItemDesc'}
			,{name: 'ItmNoStr', mapping : 'ItmNoStr'}
			,{name: 'ItmSubCatID', mapping : 'ItmSubCatID'}
			,{name: 'ItmSubCatDesc', mapping : 'ItmSubCatDesc'}
			,{name: 'ItmIsOptional', mapping : 'ItmIsOptional'}
			,{name: 'IGPriority', mapping: 'IGPriority'}
			,{name: 'IGPriorityDesc', mapping: 'IGPriorityDesc'}
			,{name: 'IGIsMain', mapping: 'IGIsMain'}
			,{name: 'OrderSeqNo', mapping: 'OrderSeqNo'}
			,{name: 'IGAIndex', mapping: 'IGAIndex'}
			,{name: 'IGAArcimDR', mapping: 'IGAArcimDR'}
			,{name: 'IGAArcimDesc', mapping: 'IGAArcimDesc'}
			,{name: 'PHCGeneDesc', mapping: 'PHCGeneDesc'}
			,{name: 'PHCSpecDesc', mapping: 'PHCSpecDesc'}
			,{name: 'PHCFormDesc', mapping: 'PHCFormDesc'}
			,{name: 'IGAPackQty', mapping: 'IGAPackQty'}
			,{name: 'IGAFreqDR', mapping: 'IGAFreqDR'}
			,{name: 'IGAFreqDesc', mapping: 'IGAFreqDesc'}
			,{name: 'IGADuratDR', mapping: 'IGADuratDR'}
			,{name: 'IGADuratDesc', mapping: 'IGADuratDesc'}
			,{name: 'IGAInstrucDR', mapping: 'IGAInstrucDR'}
			,{name: 'IGAInstrucDesc', mapping: 'IGAInstrucDesc'}
			,{name: 'IGADoseQty', mapping: 'IGADoseQty'}
			,{name: 'IGADoseUomDR', mapping: 'IGADoseUomDR'}
			,{name: 'IGADoseUomDesc', mapping: 'IGADoseUomDesc'}
			,{name: 'IGADefault', mapping: 'IGADefault'}
			,{name: 'IGAResume', mapping: 'IGAResume'}
			,{name: 'IsArcInci', mapping: 'IsArcInci'}
			,{name: 'IGASign', mapping: 'IGASign'}
		])
		,sortInfo:{field: 'OrderSeqNo', direction: "ASC"}
		,groupField:'ItmNoStr'
	});
	obj.OE_gridOEOrder = new Ext.grid.GridPanel({
		id : 'OE_gridOEOrder'
		,store : obj.OE_gridOEOrderStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,loadMask : true
		,tbar : [{id:'msgOE_gridOEOrder',text:'临床路径医嘱录入',style:'font-weight:bold;font-size:14px;',xtype:'label'}
		,'->',obj.OE_btnSave,{style:'width:20px;',xtype:'label'},obj.OE_btnCancel,{style:'width:20px;',xtype:'label'}]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '医嘱类型', width:80, dataIndex: 'IGPriorityDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '顺序号', width: 60, dataIndex: 'OrderSeqNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'IGAArcimDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IGASign = rd.get("IGASign");
					if (IGASign == '1'){
						v = '┏' + v;
					} else if (IGASign == '2'){
						v = '┗' + v;
					} else if (IGASign == '3'){
						v = '' + v;
					} else {
						v = '┃' + v;
					}
					return v;
				}
			}
			,{header: '选择', width: 50, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var checked = rd.get("IsChecked");
					if (checked == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '单次<br>剂量', width: 50, dataIndex: 'IGADoseQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width: 50, dataIndex: 'IGADoseUomDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '频次', width: 70, dataIndex: 'IGAFreqDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '用法', width: 70, dataIndex: 'IGAInstrucDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '疗程', width: 70, dataIndex: 'IGADuratDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '数量', width:50, dataIndex: 'IGAPackQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 80, dataIndex: 'IGAResume', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '首选<br>医嘱', width: 50, dataIndex: 'IGADefault', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGADefault = rd.get("IGADefault");
					if (IGADefault == '1') {
						return "是";
					} else {
						return "";
					}
				}
			}
			,{header: '项目编号', width: 0, dataIndex: 'ItmNoStr', sortable: false, menuDisabled:true, hidden:true, align: 'center'}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '项目：{[values.rs[0].get("ItemDesc")]} (共{[values.rs.length]}项)',
			groupByText:'依本列分组',
			getRowClass : function(record,rowIndex,rowParams,store){
				if (record.data.IsArcInci=="0") {
					return 'x-grid-record-red';
				} else {
					return '';
				}
			}
		})
    });
	
	obj.OE_gridArcimSelectStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OE_gridArcimSelectStore = new Ext.data.Store({
		proxy: obj.OE_gridArcimSelectStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ArcimID'
		},
		[
			{name: 'ArcimID', mapping: 'ArcimID'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'OrderType', mapping : 'OrderType'}
			,{name: 'PrescType', mapping: 'PrescType'}
			,{name: 'FreqDR', mapping: 'FreqDR'}
			,{name: 'FreqDesc', mapping: 'FreqDesc'}
			,{name: 'DuratDR', mapping: 'DuratDR'}
			,{name: 'DuratDesc', mapping: 'DuratDesc'}
			,{name: 'InstrucDR', mapping: 'InstrucDR'}
			,{name: 'InstrucDesc', mapping: 'InstrucDesc'}
			,{name: 'DoseQty', mapping: 'DoseQty'}
			,{name: 'DoseUomDR', mapping: 'DoseUomDR'}
			,{name: 'DoseUomDesc', mapping: 'DoseUomDesc'}
			,{name: 'PHCGeneDesc', mapping: 'PHCGeneDesc'}
			,{name: 'PHCSpecDesc', mapping: 'PHCSpecDesc'}
			,{name: 'PHCFormDesc', mapping: 'PHCFormDesc'}
		])
	});
	obj.OE_gridArcimSelect = new Ext.grid.EditorGridPanel({
		id : 'OE_gridArcimSelect'
		,store : obj.OE_gridArcimSelectStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,height : 120
		,region : 'south'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '名称', width: 200, dataIndex: 'ArcimDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '单次剂量', width: 60, dataIndex: 'DoseQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width: 50, dataIndex: 'DoseUomDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '频次', width: 50, dataIndex: 'FreqDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '用法', width: 80, dataIndex: 'InstrucDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '疗程', width: 60, dataIndex: 'DuratDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '剂型', width: 70, dataIndex: 'PHCFormDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '规格', width: 70, dataIndex: 'PHCSpecDesc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.OE_WinOEOrder = new Ext.Window({
		id : 'OE_WinOEOrder'
		,height : 560
		,width : 850
		,modal : true
		,closable : false
		,layout : 'border'
		,resizable : false      //不可调整大小
		,draggable : false      //不可拖拽
		,frame : true
		,buttonAlign : 'center'
		,items:[
			obj.OE_gridOEOrder
			,obj.OE_gridArcimSelect
		]
		//,buttons:[obj.OE_btnSave,obj.OE_btnCancel]
	});
	
	obj.OE_gridOEOrderStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCCPW.MR.FORM.OEOrderSrv';
		param.QueryName = 'QryOrderListByStep';
		param.Arg1 = obj.EpisodeID;
		param.Arg2 = obj.StepID;
		param.Arg3 = obj.SubCatID;
		param.Arg4 = obj.ItemID;
		param.ArgCnt = 4;
	});
	
	obj.OE_gridArcimSelectStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCCPW.MR.FORM.OEOrderSrv';
		param.QueryName = 'QryOrderListByGene';
		param.Arg1 = obj.EpisodeID;
		param.Arg2 = obj.currArcimID;
		param.ArgCnt = 2;
	});
	
	OE_InitOEOrderEvent(obj);
	obj.OE_LoadEvent(arguments);
	return obj;
}

