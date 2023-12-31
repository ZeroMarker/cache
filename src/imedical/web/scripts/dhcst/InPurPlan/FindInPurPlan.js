FindPlan = function(Fn){
	var parref = "";
	var strParam = "";
	var IncId = "";
	
	function getDrugList(record) {
		if (record == null || record == "") {
			return false;
		}else{
			Ext.getCmp("aliasName").setValue(record.get("InciDesc"));	
			IncId = record.get("InciDr");
		}		
	}
		
	function GetPhaOrderInfo(item, group) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList);
		}
	}
	
	var startDateField = new Ext.ux.DateField({
		id:'startDateField',
		allowBlank:true,
		fieldLabel:$g('起始日期'),
		anchor:'90%',
		value:DefaultStDate()
	});

	var endDateField = new Ext.ux.DateField({
		id:'endDateField',
		allowBlank:true,
		fieldLabel:$g('截止日期'),
		anchor:'90%',
		value:DefaultEdDate()
	});
	
	var GField = new Ext.ux.StkGrpComboBox({ 
		id : 'GField',
		name : 'GField',
		StkType:App_StkTypeCode,     //标识类组类型
		anchor : '90%',
		LocId:CtLocId,
		UserId:UserId
	}); 

	var aliasNameField = new Ext.form.TextField({
		id:'aliasName',
		fieldLabel:$g('药品名称'),
		allowBlank:true,
		width:180,
		listWidth:180,
		emptyText:'',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					//调出药品窗口
					var group = Ext.getCmp("GField").getValue();
					GetPhaOrderInfo(field.getValue(),group);
				}
			}
		}
	});

	var apcVendorField = new Ext.ux.VendorComboBox({
		id:'apcVendorField',
		fieldLabel:$g('经营企业'),
		anchor:'90%'
	});
	
	var PlanNoField = new Ext.form.TextField({
		id:'PlanNo',
		fieldLabel:$g('计划单号'),
		allowBlank:true,
		emptyText:'',
		anchor:'90%',
		selectOnFocus:true
	});
		
	var DeptField = new Ext.ux.LocComboBox({
		id:'DeptField',
		fieldLabel:$g('科室'),
		anchor:'90%',
		listWidth:180,
		emptyText:'',
		groupId:gGroupId,
		listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('DeptField').getValue();//add wyx 根据选择的科室动态加载类组
                          GField.getStore().removeAll();
                          GField.getStore().setBaseParam("locId",SelLocId)
                          GField.getStore().setBaseParam("userId",UserId)
                          GField.getStore().setBaseParam("type",App_StkTypeCode)
                          GField.getStore().load();
			}
	}
		
	});
	
	
	var finshField = new Ext.form.Radio({ 
		id:'finsh',
		name:'finsh',
		boxLabel:$g('完成')  
	});
	var noFinshField = new Ext.form.Radio({  
		id:'noFinsh',
		name:'finsh', 
		boxLabel:$g('未完成')  
	});
	var allFinshField = new Ext.form.Radio({ 
		id:'allFinsh',
		name:'finsh',  
		boxLabel:$g('全部'),
		checked:true
	});
	
	var planUrl = 'dhcst.inpurplanaction.csp';
	var planProxy= new Ext.data.HttpProxy({url:planUrl+'?actiontype=query',method:'GET'});
	var planDs = new Ext.data.Store({
	proxy: planProxy,
	reader: new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
		}, [
			{name:'RowId'},
			{name:'PurNo'},
			{name:'LocId'},
			{name:'Loc'},
			{name:'Date'},
			{name:'User'},
			{name:'PoFlag'},
			{name:'CmpFlag'},
			{name:'StkGrpId'},
			{name:'StkGrp'}
		]),
		remoteSort:false
	});
						
	planDs.setDefaultSort('RowId', 'desc');
	planDs.on('load',function(ds){
		if (ds.getCount()>0){
			planGrid.getSelectionModel().selectFirstRow();
			planGrid.getView().focusRow(0);
		}
	})					
	var planCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: $g("计划单号"),
			dataIndex: 'PurNo',
			width: 120,
			align: 'left',
			sortable: true
		},{
			header: $g("科室"),
			dataIndex: 'Loc',
			width: 90,
			align: 'left',
			sortable: true
		},{
			header:$g('日期'),
			width:80,
			dataIndex:'Date',
			align: 'left',
			sortable: true
		},{
			header:$g('制作人'),
			align: 'left',
			width:70,
			dataIndex:'User',
			sortable: true
		},{
			header:$g('审批'),
			align: 'center',
			width:70,
			dataIndex:'PoFlag',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header:$g('完成'),
			align: 'center',
			width:70,
			dataIndex:'CmpFlag',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);
	
	var planItemUrl = 'dhcst.inpurplanaction.csp';
	var planItemProxy= new Ext.data.HttpProxy({url:planItemUrl+'?actiontype=queryItem',method:'GET'});
	var planItemDs = new Ext.data.Store({
	proxy: planItemProxy,
	reader: new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
		}, [
			{name:'RowId'},
			{name:'IncId'},
			{name:'IncCode'},
			{name:'IncDesc'},
			{name:'Spec'},
			{name:'ManfId'},
			{name:'Manf'},
			{name:'Qty'},
			{name:'UomId'},
			{name:'Uom'},
			{name:'Rp'},
			{name:'Sp'},
			{name:'RpAmt'},
			{name:'SpAmt'},
			{name:'VenId'},
			{name:'Vendor'},
			{name:'CarrierId'},
			{name:'Carrier'},
			{name:'Gene'},
			{name:'GoodName'},
			{name:'Form'},
			{name:'PoId'},
			{name:'ReqLocId'},
			{name:'ReqLoc'},
			{name:'StkQty'},
			{name:'MaxQty'},
			{name:'MinQty'}
		]),
		remoteSort:false
	});
			
	planItemDs.setDefaultSort('RowId', 'desc');
						
	var planItemCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: $g("代码"),
			dataIndex: 'IncCode',
			width: 90,
			align: 'left',
			sortable: true
		},{
			header: $g("名称"),
			dataIndex: 'IncDesc',
			width: 120,
			align: 'left',
			sortable: true
		},{
			header:$g('生产企业'),
			width:120,
			dataIndex:'Manf',
			align: 'left',
			sortable: true
		},{
			header:$g('规格'),
			align: 'left',
			width:70,
			dataIndex:'Spec',
			sortable: true
		},{
			header:$g('数量'),
			align: 'right',
			width:70,
			dataIndex:'Qty',
			sortable: true
		},{
			header:$g('单位'),
			align: 'left',
			width:70,
			dataIndex:'Uom',
			sortable: true
		},{
			header:$g('进价'),
			align: 'right',
			width:70,
			dataIndex:'Rp',
			sortable: true
		},{
			header:$g('售价'),
			align: 'right',
			width:70,
			dataIndex:'Sp',
			sortable: true
		},{
			header:$g('进价金额'),
			align: 'right',
			width:70,
			dataIndex:'RpAmt',
			sortable: true
		},{
			header:$g('售价金额'),
			align: 'right',
			width:70,
			dataIndex:'SpAmt',
			sortable: true
		},{
			header:$g('经营企业'),
			align: 'left',
			width:150,
			dataIndex:'Vendor',
			sortable: true
		},{
			header:$g('配送企业'),
			align: 'left',
			width:70,
			dataIndex:'Carrier',
			sortable: true
		},{
			header:$g('剂型'),
			align: 'left',
			width:70,
			dataIndex:'Form',
			sortable: true
		},{
			header:$g('申购科室'),
			align: 'left',
			width:70,
			dataIndex:'ReqLoc',
			sortable: true
		},{
			header:$g('申购科室库存量'),
			align: 'right',
			width:100,
			dataIndex:'StkQty',
			sortable: true
		},{
			header:$g('库存上限'),
			align: 'right',
			width:70,
			dataIndex:'MaxQty',
			sortable: true
		},{
			header:$g('库存下限'),
			align: 'right',
			width:70,
			dataIndex:'MinQty',
			sortable: true
		}
	]);
				
	var find = new Ext.Toolbar.Button({
		text:$g('查询'),
		tooltip:$g('查询'),
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			var locId = Ext.getCmp('DeptField').getValue();
			var StartDate=Ext.getCmp('startDateField').getValue();
			var FStartDate =StartDate;
			if((FStartDate!="")&&(FStartDate!=null)){
				FStartDate = FStartDate.format('Y-m-d');
			}
			var EndDate=Ext.getCmp('endDateField').getValue();
			var FEndDate =EndDate;
			if((FEndDate!="")&&(FEndDate!=null)){
				FEndDate = FEndDate.format('Y-m-d');
			}
			if(FStartDate>FEndDate){
				Msg.info("warning",$g("起始日期应该小于截止日期"));
				return;
			}
			StartDate=StartDate.format(App_StkDateFormat);
			EndDate=EndDate.format(App_StkDateFormat)
			var PurNo = Ext.getCmp('PlanNo').getValue();
			var StkGrpId = Ext.getCmp('GField').getValue();
			var VendorId = Ext.getCmp('apcVendorField').getValue();
			var Complete="";
			var Complete1 = Ext.getCmp('finsh').getValue();
			var Complete2 = Ext.getCmp('noFinsh').getValue();
			Complete = (Complete1==true?'Y':(Complete2==true?'N':''));
			var Audit = "N";
			if(Ext.getCmp("aliasName").getValue()==""){
				IncId="";
			}
			var strParam = locId+"^"+StartDate+"^"+EndDate+"^"+PurNo+"^"+StkGrpId+"^"+VendorId+"^"+IncId+"^"+Complete+"^"+Audit;
			if((StartDate=="")||(StartDate==null)){
				Msg.info("error", $g("请选择开始日期!"));
			}else if((EndDate=="")||(EndDate==null)){
				Msg.info("error", $g("请选择截止日期!"));
			}else{
				planDs.setBaseParam('strParam',strParam);
				planDs.removeAll();
				planItemGrid.store.removeAll();
				planDs.load({params:{start:0,limit:22,sort:'RowId',dir:'desc'}});
				
			}
		}
	});
				
	var sure = new Ext.Toolbar.Button({
		text:$g('选取'),
		tooltip:$g('选取'),
		iconCls:'page_goto',
		width : 70,
		height : 30,
		handler:function(){
			ReturnData();
		}
	});
	
	function ReturnData(){		
		var rowObj = planGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error", $g("请选择计划单!"));
			return false;
		}else{
			var planRowId = rowObj[0].get("RowId");
			purId = planRowId;
			Fn(purId);			
		}
		win.close();	
	}
	var clear = new Ext.Toolbar.Button({
		text:$g('清屏'),
		tooltip:$g('清屏'),
		iconCls:'page_clearscreen',
		width : 70,
		height :30,
		handler:function(){
			SetLogInDept(DeptField.getStore(),"DeptField")
			
			var SelLocId=Ext.getCmp('DeptField').getValue();//add wyx 根据选择的科室动态加载类组
            GField.getStore().removeAll();
            GField.getStore().setBaseParam("locId",SelLocId)
            GField.getStore().setBaseParam("userId",UserId)
            GField.getStore().setBaseParam("type",App_StkTypeCode)
            GField.getStore().load();

			PlanNoField.setValue("");
			apcVendorField.setValue("");
			apcVendorField.setRawValue("");
			Ext.getCmp("aliasName").setValue("");
			Ext.getCmp("startDateField").setValue(DefaultStDate());
			Ext.getCmp("endDateField").setValue(DefaultEdDate());
			Ext.getCmp('GField').setValue("");
			GField.store.load();
			Ext.getCmp('allFinsh').setValue(true);
			planGrid.getStore().removeAll();
			planGrid.getView().refresh();
			
			planItemGrid.getStore().removeAll();
			planItemGrid.getView().refresh();
		}
	});

	var cancel = new Ext.Toolbar.Button({
		text:$g('关闭'),
		tooltip:$g('关闭'),
		iconCls:'page_close',
		width : 70,
		height : 30,
		handler:function(){
			win.close();
		}
	});
			
	var planPagingToolbar = new Ext.PagingToolbar({
		store:planDs,
		pageSize:22,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
			
	planGrid = new Ext.grid.GridPanel({
		store:planDs,
		cm:planCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		bbar:[planPagingToolbar]
	});
	planGrid.on('rowdblclick',function(grid,rowindex,e){
		ReturnData();
	})	
	var planItemPagingToolbar = new Ext.PagingToolbar({
		store:planItemDs,
		pageSize:25,
		id:'planItem',
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
		
	planItemGrid = new Ext.grid.GridPanel({
		store:planItemDs,
		cm:planItemCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask:true,
		bbar:[planItemPagingToolbar]
	});
				
	var conPanel = new Ext.form.FormPanel({
		labelWidth:60,
		labelAlign:'right',
		frame:true,
		tbar:[find,'-',clear,'-',sure,'-',cancel],
		items:[{
			xtype:'fieldset',
			title:$g('查询条件'),
			style:DHCSTFormStyle.FrmPaddingV+"padding-bottom:0px",
			defaults:{border:false},
			layout:'column',
			items:[{
				columnWidth:0.3,
				xtype:'fieldset',
				items:[DeptField,apcVendorField,PlanNoField]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[startDateField,endDateField,aliasNameField]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[GField]
			},{
				columnWidth:0.2,
				xtype:'fieldset',
				items:[finshField,noFinshField,allFinshField]
			}]
		}]
	});

	planGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		var selectedRow = planDs.data.items[rowIndex];
		parref = selectedRow.data["RowId"];
		planItemDs.setBaseParam('parref',parref);
		planItemDs.proxy = new Ext.data.HttpProxy({url:planUrl+'?actiontype=queryItem',method:'GET'});
		planItemDs.load({params:{start:0,limit:25,sort:'RowId',dir:'desc',parref:parref}});
	});
	
	var win = new Ext.Window({
		title:$g('查找计划单'),
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
		layout:'border',
		plain:true,
		modal:true,
		buttonAlign:'center',
		//bodyStyle:'',
		items:[{
			region:'north',
			layout:'fit',
			height:DHCSTFormStyle.FrmHeight(2),
			items:conPanel
		},{
			region:'west',
			width:300,
			split:true,
			title:$g('采购计划单'),
			margins: '0 5 0 0',
			collapsible:true,
			layout:'fit',
			items:planGrid
		},{
			title:$g('明细'),
			region:'center',
			layout:'fit',
			items:planItemGrid
		}]
	});

	//显示窗口
	win.show();
};