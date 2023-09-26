// 名称:注册物资调码(用于记录维修情况)
// 编写日期:2014-03-10

function LocMainReg(PhaLoc){
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var DrugListFlag=0;	//标志 用意判断是查询还是录入
	var inciDr=""

		/**
		 * 调用物资窗体并返回结果
		 */	
		function GetPhaOrderInfo2(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList2);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList2(record) {
			if (record == null || record == "") {
				return;
			}
			
		    inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			
			var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
			// 选中行
			var row = cell[0];
			var rowData = BarCodeGrid.getStore().getAt(row);
			rowData.set("IncId",inciDr);
			rowData.set("IncCode",inciCode);
			rowData.set("IncDesc",inciDesc);
			rowData.set("UomId",record.get("BuomDr"));
			rowData.set("UomDesc",record.get("BuomDesc"));
			rowData.set("Rp",record.get("bRp"));
			rowData.set("Sp",record.get("bSp"));
			
			var barcodeIndex=GetColIndex(BarCodeGrid,'BarCode')
			BarCodeGrid.startEditing(row,barcodeIndex);
		}
		
		var startDate = new Ext.ux.DateField({
				id:'startDate',
				allowBlank:true,
				fieldLabel:'起始日期',
				anchor:'95%',
				value:new Date()
			});
			//截止日期
		var endDate = new Ext.ux.DateField({
				id:'endDate',
				allowBlank:true,
				fieldLabel:'截止日期',
				anchor:'95%',
				value:new Date()
			});
	

		/**
		 * 新增一行
		 */
		function addNewRow() {
			var col = GetColIndex(BarCodeGrid,'IncDesc');
			var rowCount = BarCodeGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = BarCodeGridDs.data.items[rowCount - 1];
				var data = rowData.get("IncId");
				if (data == null || data.length <= 0) {
					BarCodeGrid.startEditing(BarCodeGridDs.getCount() - 1, col);
					return;
				}
			}
			var record = Ext.data.Record.create([
				{name : 'Rowid',type : 'string'},
				{name : 'IncId',type : 'string'},
				{name : 'IncCode',type : 'string'},
				{name : 'IncDesc',type : 'string'},
				{name : 'BarCode',type : 'string'},
				{name : 'Rp',type : 'double'},
				{name : 'Sp',type : 'double'},
				{name : 'UomId',type : 'int'},
				{name : 'UomDesc',type : 'string'},
				{name : 'dhclmRemarks',type : 'string'}
			]);
			var NewRecord = new record({
				Rowid : '',
				IncId : '',
				IncCode : '',
				IncDesc : '',
				BarCode : '',
				Rp : '',
				Sp : '',
				UomId : '',
				UomDesc : '',
				dhclmRemarks : ''
			});
			BarCodeGridDs.add(NewRecord);
			BarCodeGrid.startEditing(BarCodeGridDs.getCount() - 1, col);
		}
	
	var BarCodeGridDs = new Ext.data.JsonStore({
		autoDestroy: true,
	    url:'',
	    fields:['Rowid','IncId','IncCode','IncDesc','BarCode','Rp','Sp','UomId','UomDesc','dhclmRemarks']
	});
	
	//模型
	var BarCodeGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"物资代码",
	        dataIndex:'IncCode',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"物资名称",
	        dataIndex:'IncDesc',
	        width:200,
	        align:'left',
	        sortable:true,
	        editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							GetPhaOrderInfo2(field.getValue(),"");
						}
					}
				}
			}))
	    },{
	        header:"编码",
	        dataIndex:'BarCode',
	        width:150,
	        align:'left',
	        sortable:false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addNewRow();
						}
					}
				}
			}))
	    },{
	        header:"单位Id",
	        dataIndex:'UomId',
	        width:80,
	        align:'left',
	        hidden:true
	    },{
	        header:"单位",
	        dataIndex:'UomDesc',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			editor : new Ext.ux.NumberField({
				formatType : 'FmtRP',
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
						}
					}
				}
			})
		},{
			header : "售价",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			editor : new Ext.ux.NumberField({
				formatType : 'FmtSP',
				selectOnFocus : true,
				allowBlank : false,
				editable : false
			})
		},{
	        header:"备注",
	        dataIndex:'dhclmRemarks',
	        width:200,
	        align:'left',
	        sortable:false,
	        editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
					
					}
				}
	        }))
	    }
	]);
	//初始化默认排序功能
	BarCodeGridCm.defaultSortable = true;
	
	// 清空按钮
	var clearBarCode = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			BarCodeGrid.store.removeAll();
		}
	});
	
	var DeleteDetailBT=new Ext.Toolbar.Button({
		id:'DeleteDetailBT',
		text:'删除一条',
		tooltip:'点击删除',
		width:70,
		height:30,
		iconCls:'page_delete',
		handler:function(){
			deleteDetail();
		}
	});
	
	function deleteDetail() {
		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		var row = cell[0];
		var rowData = BarCodeGrid.getStore().getAt(row);
		var Rowid = rowData.get("Rowid");
		if (Rowid == "" ) {
			BarCodeGrid.getStore().remove(rowData);
			BarCodeGrid.getView().refresh();
		}
	}	
	// 增加按钮
	var AddBT = new Ext.Toolbar.Button({
		id : "AddBT",
		text : '增加一条',
		tooltip : '点击增加',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			addNewRow();
		}
	});

	// 保存按钮
	var saveBarCode = new Ext.Toolbar.Button({
		text : '保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			if(BarCodeGrid.activeEditor != null){
				BarCodeGrid.activeEditor.completeEdit();
			} 
			save();
		}
	});
	
	function save() {
		var MainInfo = gUserId +"^"+PhaLoc;
		var ListDetail="";
		var rowCount = BarCodeGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = BarCodeGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){	
				var Rowid=rowData.get("Rowid");
				var IncId = rowData.get("IncId");
				if(IncId==""){continue;}
				var BarCode = rowData.get("BarCode");
				if(BarCode==""){
					Msg.info("warning","第"+(i+1)+"行编码不可为空");
					return;
				}
				var UomId = rowData.get('UomId');
				if(Ext.isEmpty(UomId)){
					Msg.info("warning","第"+(i+1)+"行单位rowid为空,请核实!");
					return false;
				}
				var Rp = rowData.get("Rp");
				var Sp = rowData.get("Sp");
				var Remarks = rowData.get("dhclmRemarks");
				Remarks = Remarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
				var str = Rowid+"^"+IncId+"^"+BarCode+"^"+UomId+"^"+Rp+"^"+Sp+"^"+Remarks;
				if(ListDetail==""){
					ListDetail=str;
				}else{
					ListDetail=ListDetail+RowDelim+str;
				}
			}
		}
		if(ListDetail==""){
			Msg.info("warning","没有需要保存的内容!");
			return;
		}
		var url = DictUrl + "locmainaction.csp?actiontype=Save";
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{MainInfo:MainInfo,ListDetail:ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var datetime = jsonData.info;
					var startDate=datetime.split("^")[0];
					var time=datetime.split("^")[1];
					Msg.info("success", "保存成功!");
					RegWindow.close();
					var StrParam=startDate+"^^^^^"+time+"^"+PhaLoc;
					MasterStore.setBaseParam('StrParam',StrParam);
					MasterStore.removeAll();
					DetailStore.removeAll();
					MasterStore.load({params:{start:0,limit:MasterGridToolbar.pageSize}});
				}else{
					Msg.info("error", "保存失败!"+jsonData.info);
				}
			},
			scope : this
		});
		loadMask.hide();
	}
	
	//表格
	BarCodeGrid = new Ext.grid.EditorGridPanel({
		store:BarCodeGridDs,
		cm:BarCodeGridCm,
		loadMask:'true',
		trackMouseOver:true,
		region:'center',
		stripeRows:true,
		sm : new Ext.grid.CellSelectionModel({}),
		loadMask:true,
		clicksToEdit:1,
		tbar:[AddBT,'-',DeleteDetailBT,'-',clearBarCode,'-',saveBarCode]
	});
	
	var RegWindow = new Ext.Window({
		height:500,
		width:900,
		title:'注册编码',
		modal:true,
		layout:'border',
		items:[BarCodeGrid]
	});
	RegWindow.show();
	addNewRow();
}