// 名称:物资包维护打包收费
// 编写日期:2012-06-14
// 修改：2017-02-07

var gridUrl='dhcstm.packchargelinkaction.csp'
var gIncId='';
	/**
	* 调用物资窗体并返回结果
	*/
	function GetPhaOrderInfo1(item) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item,"", App_StkTypeCode, "", "N", "0", "",getDrugList1,"","","","","","N","Y");
		}
	}

	/**
	* 返回方法
	*/
	function getDrugList1(records) {
		records = [].concat(records);
		if (records == null || records == "") {
			return;
		}
		gIncId = records[0].get("InciDr");
		var incDesc=records[0].get("InciDesc");
		var cell = PackGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var col = cell[1];
		var rowData = PackGrid.getStore().getAt(row);
		rowData.set("PackRowId", gIncId);
		rowData.set("PackDesc", incDesc);
	}
    
    /**
     * 调用物资窗体并返回结果
     */
    function GetPhaOrderInfo2(item) {
        if (item != null && item.length > 0) {
        	var vendor=Ext.getCmp("Vendor").getValue()
            GetPhaOrderWindow(item,"", App_StkTypeCode, "", "N",
				"0", "",getDrugList2,"","",
				"","","","N","Y",
				vendor, "Y");
        }
    }
   
	function getDrugList2(records) {
		records = [].concat(records);
		if (records == null || records == "") {
		return;
		}
		Ext.each(records,function(record,index,allItems){
			var inciDr = record.get("InciDr");		
			var Inci=records[0].get("InciDr");
			var InciDesc=records[0].get("InciDesc");
			var Spec=records[0].get("Spec");
			var InciCode=records[0].get("InciCode");
			var cell = ItmLinkGrid.getSelectionModel().getSelectedCell();
			var row = cell[0];
			var col = cell[1];
			var rowData = ItmLinkGrid.getStore().getAt(row);
			rowData.set("Inci", Inci);
			rowData.set("InciDesc", InciDesc);
			rowData.set("Spec", Spec);
			rowData.set("InciCode", InciCode);
		})
		if(gIncId==""){Msg.info("error","请从物资列表中选择包!");return;}
	}

	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor:'60%'
	});

	function RefreshGrid(){
		PackGridDs.load();
		ItmGridDs.setBaseParam("Pack",gIncId);
		ItmGridDs.load({
			params:{start:0,limit:999}
		});
	}
	var AddPack = new Ext.ux.Button({
		text : '新增包',
		iconCls : 'page_add',
		handler : function() {
			var colIndex = GetColIndex(PackGrid,'PackDesc');
			var rowCount = PackGrid.getStore().getCount();
			if(rowCount>0){
				var rowData = PackGrid.getStore().getAt(rowCount - 1);
				var aaa = rowData.get('PackRowId');
				if (aaa == null || aaa.length <= 0) {
					PackGrid.startEditing(rowCount - 1, 1);
					return;
				}
			}
			if(PackGrid.activeEditor!=null){PackGrid.activeEditor.completeEdit();}
			var mr = PackGridDs.getModifiedRecords();
			var mrlen=mr.length;
			if(mrlen>0)
			{
				Msg.info("error","存在新增或修改的包，请保存或删除后再新增!");
				return;
			}
	
			var defaultValues = {};
			//获取record默认值
			if(Ext.isFunction(PackGrid.beforeAddFn)){
				defaultValues = eval(PackGrid.beforeAddFn).call();
				if(defaultValues===false){return;}
			}
			var RecordObject = PackGrid.store.fields;
			var NewRecord = CreateRecordInstance(RecordObject,defaultValues);
			PackGridDs.add(NewRecord);
			PackGrid.startEditing(rowCount, colIndex);
			ItmGridDs.removeAll();
			gIncId="";
		}
	});
	var SavePack = new Ext.ux.Button({
		text : '保存',
		iconCls : 'page_save',
		handler : function() {
			var incistr="";
			var mrItm = ItmGridDs.getModifiedRecords();
			var mrItmlen=mrItm.length;
			if(mrItmlen>0)
			{
				for(var i=0; i<mrItmlen; i++){
					var record = mrItm[i]
					var PCL=record.get("PCL");
					var Inci=record.get("Inci");
					if(incistr==""){incistr=PCL+RowDelim+Inci}
			        else{incistr=incistr+"^"+PCL+RowDelim+Inci}
				}
			}
			
			if(gIncId==""||gIncId==null||gIncId==undefined){Msg.info("warning","请选择要保存的包!");return;}
			var ret=tkMakeServerCall("web.DHCSTM.DHCPackChargeLink","Insert",gIncId,incistr);
			var retarr=ret.split("^")
			var count=retarr[0]
			var suncess=retarr[1]
			var repeat=retarr[2]
			Msg.info("success","共选择"+count+"条数据,成功插入"+suncess+"条数据,有"+repeat+"条重复数据")
			RefreshGrid();
		}
	});
	var DelPack = new Ext.ux.Button({
		text : '删除',
		iconCls : 'page_delete',
		handler : function() {
			var sel=PackGrid.getSelectionModel().getSelectedCell();
			var row = sel[0];
		    var col = sel[1];
		    var rowData = PackGrid.getStore().getAt(row);
			var PackRowId=rowData.get("PackRowId");
			if(PackRowId==""||PackRowId==null||PackRowId==undefined){Msg.info("warning","请选择要删除的包!");return;}
			var ret=tkMakeServerCall("web.DHCSTM.DHCPackChargeLink","DelPack",PackRowId)
			if(ret==0){Msg.info("success","删除成功!");PackGridDs.remove(rowData);ItmGridDs.removeAll();}
			else if(ret==1){Msg.info("success","删除成功!");PackGridDs.remove(rowData);ItmGridDs.removeAll();}
			else(Msg.info("error","删除失败!"))

		}
	});

	var AddPackLink = new Ext.ux.Button({
		text : '新增关联',
		iconCls : 'page_add',
		handler : function() {
			if(gIncId==""){Msg.info("warning","请选择要关联的包!");return;}
		var colIndex = GetColIndex(ItmLinkGrid,'InciDesc');
		var rowCount = ItmLinkGrid.getStore().getCount();
		if(rowCount>0){
			var rowData = ItmLinkGrid.getStore().getAt(rowCount - 1);
			var aaa = rowData.get('Inci');
			if (aaa == null || aaa.length <= 0) {
				ItmLinkGrid.startEditing(rowCount - 1, 1);
				return;
			}
		}
		var defaultValues = {};
		//获取record默认值
		if(Ext.isFunction(ItmLinkGrid.beforeAddFn)){
			defaultValues = eval(ItmLinkGrid.beforeAddFn).call();
			if(defaultValues===false){return;}
		}
		var RecordObject = ItmLinkGrid.store.fields;
		var NewRecord = CreateRecordInstance(RecordObject,defaultValues);
		ItmGridDs.add(NewRecord);
		ItmLinkGrid.startEditing(rowCount, colIndex);
		}
	});
	var DelPackLink = new Ext.ux.Button({
		text : '解除关联',
		iconCls : 'page_delete',
		handler : function() {
			var sel=ItmLinkGrid.getSelectionModel().getSelectedCell();
			var row = sel[0];
		    var col = sel[1];
		    var rowData = ItmLinkGrid.getStore().getAt(row);
			var inci=rowData.get("Inci")
			if(inci==""||inci==null||inci==undefined){Msg.info("warning","请选择要解除的关联!");return;}
			var pcl=rowData.get("PCL")
			if(pcl!="")
			{
				var ret=tkMakeServerCall("web.DHCSTM.DHCPackChargeLink","DelLink",pcl)
				if(ret==0){Msg.info("success","解除成功!");
				RefreshGrid()}
				else(Msg.info("error","解除失败!"))
			}
			else{
				ItmGridDs.remove(rowData);
			}
			
		}
	});

var PackGridDs = new Ext.data.JsonStore({
	url : gridUrl+'?actiontype=GetPack',
	totalProperty : "results",
	pruneModifiedRecords:true,
	root : 'rows',
	fields : ["PackRowId","PackDesc"]
});

var PackGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'PackRowId',
		dataIndex : 'PackRowId',
		hidden : true
	},{
		header : "包名称",
		dataIndex : 'PackDesc',
		width : 300,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo1(field.getValue());
					}
				}
			}
		}))
	}
]);

//表格

var PackGrid = new Ext.ux.EditorGridPanel({
	title:'物资包',
	region:'west',
	width : 400,
	id : 'PackGrid',
	store:PackGridDs,
	cm:PackGridCm,
	sm : new Ext.grid.CellSelectionModel({}),
	tbar:[AddPack],
	listeners : {
		'rowclick' : function(grid,rowIndex,e){
			var r = grid.store.getAt(rowIndex);
		    gIncId = r.get("PackRowId");
        	var incDesc=r.get("PackDesc");
			if(gIncId=="")
			{
				ItmGridDs.removeAll();
			}
			else{
				ItmGridDs.setBaseParam("Pack",gIncId)
				ItmGridDs.load({
					params:{start:0,limit:999}
				})
			}
		}
	}
});

var ItmGridDs = new Ext.data.JsonStore({
	url : gridUrl+'?actiontype=GetDetail',
	totalProperty : "results",
	pruneModifiedRecords:true,
	root : 'rows',
	fields : ["PCL","Inci","InciDesc","Spec","InciCode"]
});

var ItmLinkGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'PCL',
		dataIndex : 'PCL',
		hidden : true
	},{
		header : 'Inci',
		dataIndex : 'Inci',
		hidden : true
	},{
		header : '物资代码',
		dataIndex : 'InciCode',
		width : 120
	},{		
		header : "物资名称",
		dataIndex : 'InciDesc',
		width : 400,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(field.getValue());
					}
				}
			}
		}))
	},{
		header : '规格',
		dataIndex : 'Spec',
		width : 400
	}
]);

var ItmLinkGrid = new Ext.ux.EditorGridPanel({
	id : 'ItmLinkGrid',
	region : 'center',
	store : ItmGridDs,
	cm : ItmLinkGridCm,
	sm : new Ext.grid.CellSelectionModel({}),
	tbar:[AddPackLink,'-',DelPackLink]
});

   
var formPanel1 = new Ext.ux.FormPanel({
	tbar : [SavePack,'-',DelPack]
});
var formPanel2 = new Ext.ux.FormPanel({
	items : [Vendor]
});
//=====================================================

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

    var panel2 = new Ext.Panel({
        title:'物资包关联明细',
        region:'center',
        layout:'border',
        items:[formPanel2,ItmLinkGrid]                                 
    });
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel1,PackGrid,panel2]
	});
	PackGridDs.load();
});
