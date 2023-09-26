//描述: 入库单发票号录入
//编写日期: 2014.09.17
	var URL="dhcstm.vendorinvaction.csp";
	var UserId = session['LOGON.USERID'];
	var GroupId=session['LOGON.GROUPID']
	var CtLocId = session['LOGON.CTLOCID'];
	
	//保存参数值的object
    var PayParamObj = GetAppPropValue('DHCSTPAYM');
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		width : 120,
		value : new Date().add(Date.DAY, - 30)
	});
	
	// 截止日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		width : 120,
		value : new Date()
	});
	
	var Vendor = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		emptyText : '供应商...'
	});
	
	// 类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     
		LocId:CtLocId,
		UserId:UserId
	});
	
	var INVAssemNo=new Ext.form.TextField({
		fieldLabel : '发票组合单号',
		id : 'INVAssemNo',
		name : 'INVAssemNo',
		anchor : '90%',
		width : 120
	});
	
	var INVRpAmt=new Ext.form.TextField({
		id : 'INVRpAmt',
		fieldLabel:'组合进价总额',
		anchor : '90%'
	});	
	
	var INVNo=new Ext.form.TextField({
		fieldLabel : '发票号',
		id : 'INVNo',
		name : 'INVNo',
		anchor : '90%',
		width : 120
	});
	
	var filledFlag = new Ext.form.Checkbox({
		fieldLabel : '已录入',
		id : 'filledFlag',
		name : 'filledFlag',
		anchor : '90%',
		checked : false
	});

	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '点击查询',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	// 确定按钮
	var selectBT = new Ext.Toolbar.Button({
		text : '保存',
		tooltip : '保存',
		width : 70,
		height : 30,
		iconCls : 'page_edit',
		handler : function() {
			save();
		}
	});
	
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '打印',
		tooltip : '点击打印',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var rec=FindMasterGrid.getSelectionModel().getSelected();
			if (!rec) return;
			var inv=rec.get('inv');
			Printinv(inv);
		}
	});	
	/**
	 * 保存方法
	 */
	function save() {
		if(FindMasterGrid.activeEditor != null){
			FindMasterGrid.activeEditor.completeEdit();
		}
		var ListDetail="";
		var rowCount = FindMasterGrid.getStore().getCount();

		for (var i = 0; i < rowCount; i++) {
			var rowData = FindMasterGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inv=rowData.get("inv");
				var InvNo=rowData.get("invNo");
				var Invrpamt=rowData.get("invrpamt");
				var InvNoDate=Ext.util.Format.date(rowData.get("invNoDate"),ARG_DATEFORMAT);
				var str = Inv + "^" + InvNo + "^" + Invrpamt + "^" + InvNoDate;
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		if(ListDetail==""){
			Msg.info("warning", "数据没有发生变化，不需要保存!");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"处理中...");
		var url = URL+ '?actiontype=SaveInvNo';
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "保存成功!");
					Ext.getCmp("filledFlag").setValue(true);
					Query();
				}else {
					var Ret=jsonData.info;
					if(Ret==-1){
						Msg.info("error", "操作失败,不存在需要保存的数据!");
					}else if(Ret==-2){
						Msg.info("error", "操作失败,发票组合单Id为空或发票组合单不存在!");
					}else if(Ret==-52){
						Msg.info("error", "已付款,不能更新发票信息!");
					}else {
						Msg.info("error", "操作失败!");
					}
				}
				mask.hide();
			},
			scope : this
		});
	}	
	/**
	 * 查询方法
	 */
	function Query() {
		if (CtLocId == null || CtLocId.length <= 0) {
			return;
		}
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if(sd!=""){
			sd = sd.format(ARG_DATEFORMAT);
		}
		if(ed!=""){
			ed = ed.format(ARG_DATEFORMAT);
		}
		var vendor = Ext.getCmp('Vendor').getValue();
		var stkGrp = Ext.getCmp('StkGrpType').getValue();
		var assemNo = Ext.getCmp('INVAssemNo').getRawValue();
		var rpAmt = Ext.getCmp('INVRpAmt').getValue();
		var invNo = Ext.getCmp('INVNo').getValue();
		var filledFlag = Ext.getCmp('filledFlag').getValue()==true?'Y':'N';
		var completed = "Y"
		/*
		if(vendor==""){
			Msg.info("warning", "请选择供应商!");
			return;
		}
		if(stkGrp==""){
			Msg.info("warning", "请选择类组!");
			return;
		}*/
		if(sd==""||ed==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return; 
		}
		var StrParam=sd+"^"+ed+"^"+CtLocId+"^"+vendor+"^"+completed+"^"+stkGrp+"^"+assemNo+"^"+rpAmt+"^"+invNo+"^"+filledFlag;
		FindMasterGridDs.setBaseParam('StrParam',StrParam);
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		FindMasterGridDs.load({params:{start:0,limit:MastPagingToolbar.pageSize,sort:'inv',dir:'Desc'}});
		FindMasterGridDs.on('load',function(){
			if (FindMasterGridDs.getCount()>0){
				FindMasterGrid.getSelectionModel().selectFirstRow();
				FindMasterGrid.getView().focusRow(0);
			}
		});
	}
	
	/**
	 * 清空方法
	 */
	function clearData() {
		Ext.getCmp("Vendor").setValue("");
		//Ext.getCmp("StkGrpType").setValue("");
		
		StkGrpType.store.load();
		Ext.getCmp("INVAssemNo").setValue("");
		Ext.getCmp("INVRpAmt").setValue("");
		Ext.getCmp("INVNo").setValue("");
		Ext.getCmp("filledFlag").setValue("");
		
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		this.ginvRowId="";
	}
	
	var FindMasterGrid="";
	var FindMasterGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=query',method:'GET'});
	var fields = ["inv","assemNo","loc","locDesc","vendor","vendorName","UserName",{name:'invNoDate',type:'date',dateFormat:DateFormat},
				  "invDate","invTime","invComp","scgdr","scgDesc","rpamt","spamt","invNo","invrpamt","invspamt"];
	var FindMasterGridDs = new Ext.data.Store({
		proxy:FindMasterGridProxy,
    	reader:new Ext.data.JsonReader({
	    	totalProperty : "results",
        	root:'rows',
   			id : "inv",
			fields : fields
		})
	});

	var FindMasterColumns = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		{
			header : "RowId",
			dataIndex : 'inv',
			hidden : true
		}, {
			header : "发票组合单号",
			dataIndex : 'assemNo',
			width : 120
		}, {
			header : "供应商",
			dataIndex : 'vendorName',
			width : 200
		}, {
			header : "制单日期",
			dataIndex : 'invDate',
			width : 90,
			align : 'center'
		}, {
			header : "制单时间",
			dataIndex : 'invTime',
			width : 90,
			align : 'center'
		}, {
			header : "制单人",
			dataIndex : 'UserName',
			width : 90
		}, {
			header : "组合进价金额",
			dataIndex : 'rpamt',
			xtype : 'numbercolumn',
			width : 90
		}, {
			header : "组合售价金额",
			dataIndex : 'spamt',
			xtype : 'numbercolumn',
			width : 90
		},{
			header : "完成标志",
			dataIndex : 'invComp',
			width :60,
			xtype : 'checkcolumn'
		}, {
			header : "发票号",
			dataIndex : 'invNo',
			width : 120,
			editor:new Ext.form.TextField({selectOnFocus:true})
		}, {
			header : "发票金额",
			dataIndex : 'invrpamt',
			xtype : 'numbercolumn',
			width : 90,
			editor:new Ext.form.NumberField({selectOnFocus:true})
		}, {
			header : "发票日期",
			dataIndex : 'invNoDate',
			
			width : 100,
			align : 'center',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
			})
		}, {
			header : "入库退货科室",
			dataIndex : 'locDesc',
			width : 120,
			hidden:true
		}, {
			header : "类组",
			dataIndex : 'scgDesc',
			width : 120,
			hidden:true
		}
	]);
	
	var MastPagingToolbar = new Ext.PagingToolbar({
    	store:FindMasterGridDs,
		pageSize:PageSize,
    	displayInfo:true
	});

	var FindMasterGrid = new Ext.grid.EditorGridPanel({
		region: 'center',
		title: '发票组合单',
		store:FindMasterGridDs,
		cm:FindMasterColumns,
		sm:new Ext.grid.RowSelectionModel({singleSelect : true}),
		trackMouseOver:true,
		stripeRows:true,
		loadMask:true,
		bbar:[MastPagingToolbar]
	});
	
	FindMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ginvRowId = FindMasterGridDs.getAt(rowIndex).get("inv");
		FindDetailGrid.load({params:{parref:ginvRowId}}); 
	});

	var FindDetailColumns = [{
			header : "RowId",
			dataIndex : 'invi',
			hidden : true
		}, {
			header : "入库退货明细Id",
			dataIndex : 'ingridr',
			width : 80,
			hidden : true
		}, {
			header : "物资Id",
			dataIndex : 'IncId',
			width : 80,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 180
		}, {
			header : "规格",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "数量",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			header : "单位",
			dataIndex : 'UomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "进价",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "售价",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "进价金额",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "售价金额",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "类型",
			dataIndex : 'TransType',
			width : 70,
			align : 'left',
			sortable : true	
		}, {
			header : "厂商",
			dataIndex : 'manf',
			width : 150
		}];
	
	var FindDetailGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'south',
		split: true,
		height: 220,
		collapsible: true,
		title: '发票组合单明细',
		id : 'FindDetailGrid',
		editable : false,
		contentColumns : FindDetailColumns,
		smType : "row",
		autoLoadStore : false,
		actionUrl : URL,
		queryAction : "queryItem",
		idProperty : "invi",
		remoteSort : false,
		showTBar : false,
		paging : true
	});
	
	var HisListTab = new Ext.ux.FormPanel({
		title:'入库单、退货单组合发票号录入',
		labelWidth : 100,
		tbar : [SearchBT, '-', ClearBT,'-',selectBT,'-',PrintBT],
		layout: 'column',
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			columnWidth : 1,
			layout : 'column',			
			autoHeight : true,
			defaults: {columnWidth: 0.25,layout:'form'},
			items : [
				{
					items: [StartDate,EndDate]
				},{
					items: [Vendor,StkGrpType]  
				},{
					items: [INVAssemNo,INVRpAmt]
				},{
					items: [INVNo,filledFlag]
			}]
			
		}]
	});
Ext.onReady(function(){
	
	//取是否需要审批参数
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, FindMasterGrid, FindDetailGrid]
	});
})