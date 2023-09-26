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
		fieldLabel:'��ʼ����',
		anchor:'90%',
		value:DefaultStDate()
	});

	var endDateField = new Ext.ux.DateField({
		id:'endDateField',
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'90%',
		value:DefaultEdDate()
	});
	
	var GField = new Ext.ux.StkGrpComboBox({ 
		id : 'GField',
		name : 'GField',
		StkType:App_StkTypeCode,     //��ʶ��������
		anchor : '90%',
		LocId:CtLocId,
		UserId:UserId
	}); 

	var aliasNameField = new Ext.form.TextField({
		id:'aliasName',
		fieldLabel:'��������',
		allowBlank:true,
		width:180,
		listWidth:180,
		emptyText:'',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					//�������ʴ���
					var group = Ext.getCmp("GField").getValue();
					GetPhaOrderInfo(field.getValue(),group);
				}
			}
		}
	});

	var apcVendorField = new Ext.ux.VendorComboBox({
		id:'apcVendorField',
		fieldLabel:'��Ӧ��',
		anchor:'90%',
		params : {LocId : 'DeptField',ScgId : 'GField'}
	});
	
	var PlanNoField = new Ext.form.TextField({
		id:'PlanNo',
		fieldLabel:'�ƻ�����',
		allowBlank:true,
		emptyText:'',
		anchor:'90%',
		selectOnFocus:true
	});
		
	var DeptField = new Ext.ux.LocComboBox({
		id:'DeptField',
		fieldLabel:'����',
		anchor:'90%',
		listWidth:180,
		emptyText:'',
		groupId:gGroupId,
		stkGrpId : 'GField',
		childCombo : 'apcVendorField'
	});
	
	var finshField = new Ext.form.Radio({ 
		id:'finsh',
		name:'finsh', 
		boxLabel:'���'  
	});
	var noFinshField = new Ext.form.Radio({  
		id:'noFinsh',
		name:'finsh',  
		boxLabel:'δ��'  
	});
	var allFinshField = new Ext.form.Radio({ 
		id:'allFinsh',
		name:'finsh',  
		boxLabel:'ȫ��',
		checked:true
	});
	
	var planUrl = 'dhcstm.inpurplanaction.csp';
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
			{name:'StkGrp'},
			{name:'RefuseCase'}
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
			header: "�ƻ�����",
			dataIndex: 'PurNo',
			width: 120,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'Loc',
			width: 90,
			align: 'left',
			sortable: true
		},{
			header:'����',
			width:80,
			dataIndex:'Date',
			align: 'left',
			sortable: true
		},{
			header:'�Ƶ���',
			align: 'left',
			width:70,
			dataIndex:'User',
			sortable: true
		},{
			header:'��������',
			align: 'center',
			 hidden:true,
			width:70,
			dataIndex:'PoFlag',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header:'�ɹ������',
			align: 'center',
			width:70,
			dataIndex:'CmpFlag',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header:'�ܾ�ԭ��',
			align: 'left',
			width:70,
			dataIndex:'RefuseCase',
			sortable: true
		}
	]);
	
	var planItemUrl = 'dhcstm.inpurplanaction.csp';
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
			{name:'SpecDesc'},
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
			header: "����",
			dataIndex: 'IncCode',
			width: 90,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'IncDesc',
			width: 120,
			align: 'left',
			sortable: true
		},{
			header:'����',
			width:120,
			dataIndex:'Manf',
			align: 'left',
			sortable: true
		},{
			header:'���',
			align: 'left',
			width:70,
			dataIndex:'Spec',
			sortable: true
		},{
			header:'������',
			align: 'left',
			width:70,
			dataIndex:'SpecDesc',
			sortable: true
		},{
			header:'����',
			align: 'right',
			width:70,
			dataIndex:'Qty',
			sortable: true
		},{
			header:'��λ',
			align: 'left',
			width:70,
			dataIndex:'Uom',
			sortable: true
		},{
			header:'����',
			align: 'right',
			width:70,
			dataIndex:'Rp',
			sortable: true
		},{
			header:'�ۼ�',
			align: 'right',
			width:70,
			dataIndex:'Sp',
			sortable: true
		},{
			header:'���۽��',
			align: 'right',
			width:70,
			dataIndex:'RpAmt',
			sortable: true
		},{
			header:'�ۼ۽��',
			align: 'right',
			width:70,
			dataIndex:'SpAmt',
			sortable: true
		},{
			header:'��Ӧ��',
			align: 'left',
			width:150,
			dataIndex:'Vendor',
			sortable: true
		},{
			header:'������',
			align: 'left',
			width:70,
			dataIndex:'Carrier',
			sortable: true
		},{
			header:'�깺����',
			align: 'left',
			width:70,
			dataIndex:'ReqLoc',
			sortable: true
		},{
			header:'�깺���ҿ����',
			align: 'right',
			width:100,
			dataIndex:'StkQty',
			sortable: true
		},{
			header:'�������',
			align: 'right',
			width:70,
			dataIndex:'MaxQty',
			sortable: true
		},{
			header:'�������',
			align: 'right',
			width:70,
			dataIndex:'MinQty',
			sortable: true
		}
	]);
				
	var find = new Ext.Toolbar.Button({
		text:'����',
		tooltip:'����',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			var locId = Ext.getCmp('DeptField').getValue();
			var StartDate = Ext.getCmp('startDateField').getValue();
			if((StartDate!="")&&(StartDate!=null)){
				StartDate = StartDate.format(ARG_DATEFORMAT);
			}
			var EndDate = Ext.getCmp('endDateField').getValue();
			if((EndDate!="")&&(EndDate!=null)){
				EndDate = EndDate.format(ARG_DATEFORMAT);
			}
			if(StartDate>EndDate){
				Msg.info("warning","��ʼ����Ӧ��С�ڽ�ֹ����");
				return;
			}
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
			var AuditLevel=0;
			var strParam = locId+"^"+StartDate+"^"+EndDate+"^"+PurNo+"^"+StkGrpId
				+"^"+VendorId+"^"+IncId+"^"+Complete+"^"+Audit+"^"+""
				+"^"+AuditLevel+"^^"+UserId+'^^^'+gGroupId;
			
			if((StartDate=="")||(StartDate==null)){
				Msg.info("error", "��ѡ��ʼ����!");
			}else if((EndDate=="")||(EndDate==null)){
				Msg.info("error", "��ѡ���ֹ����!");
			}else{
				planDs.setBaseParam('strParam',strParam);
				planDs.removeAll();
				planItemGrid.store.removeAll();
				planDs.load({params:{start:0,limit:planPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
			}
		}
	});
				
	var sure = new Ext.Toolbar.Button({
		text:'ȷ��',
		tooltip:'ȷ��',
		iconCls:'page_add',
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
			Msg.info("error", "��ѡ��ƻ���!");
			return false;
		}else{
			var planRowId = rowObj[0].get("RowId");
			purId = planRowId;
			Fn(purId);			
		}
		win.close();	
	}
	var clear = new Ext.Toolbar.Button({
		text:'���',
		tooltip:'���',
		iconCls:'page_clearscreen',
		width : 70,
		height :30,
		handler:function(){
			SetLogInDept(DeptField.getStore(),"DeptField")
			PlanNoField.setValue("");
			apcVendorField.setValue("");
			apcVendorField.setRawValue("");
			Ext.getCmp("aliasName").setValue("");
			Ext.getCmp("startDateField").setValue(DefaultStDate());
			Ext.getCmp("endDateField").setValue(DefaultEdDate());
			
			planGrid.getStore().removeAll();
			planGrid.getView().refresh();
			
			planItemGrid.getStore().removeAll();
			planItemGrid.getView().refresh();
		}
	});

	var cancel = new Ext.Toolbar.Button({
		text:'ȡ��',
		tooltip:'ȡ��',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			win.close();
		}
	});
			
	var planPagingToolbar = new Ext.PagingToolbar({
		store:planDs,
		pageSize:30,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
			
	planGrid = new Ext.grid.GridPanel({
		region:'west',
		width:300,
		split:true,
		title:'�ɹ��ƻ���',
		margins: '0 5 0 0',
		collapsible:true,
		layout:'fit',
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
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B[A.sort]='RowId';
			B[A.dir]='desc';
			B['parref']=parref;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
		
	planItemGrid = new Ext.grid.GridPanel({
		title:'��ϸ',
		region:'center',
		layout:'fit',
		store:planItemDs,
		cm:planItemCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask:true,
		bbar:[planItemPagingToolbar]
	});
				
	var conPanel = new Ext.ux.FormPanel({
		labelwidth:60,
		tbar:[find,'-',sure,'-',clear,'-',cancel],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			style:'padding:5px 0px 0px 5px',
			defaults:{xtype:'fieldset',border:false},
			layout:'column',
			items:[{
				columnWidth:0.3,
				items:[DeptField,apcVendorField,PlanNoField]
			},{
				columnWidth:0.25,
				items:[startDateField,endDateField,aliasNameField]
			},{
				columnWidth:0.25,
				items:[GField]
			},{
				columnWidth:0.2,
				items:[finshField,noFinshField,allFinshField]
			}]
		}]
	});

	planGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		var selectedRow = planDs.data.items[rowIndex];
		parref = selectedRow.data["RowId"];
		planItemDs.proxy = new Ext.data.HttpProxy({url:planUrl+'?actiontype=queryItem',method:'GET'});
		planItemDs.load({params:{start:0,limit:25,sort:'RowId',dir:'desc',parref:parref}});
	});
	
	var win = new Ext.Window({
		title:'���Ҽƻ���',
		width:gWinWidth,
		height:gWinHeight,
		layout:'border',
		plain:true,
		modal:true,
		buttonAlign:'center',
		bodyStyle:'0',
		items:[conPanel,planGrid,planItemGrid]
	});

	//��ʾ����
	win.show();
	find.handler();
};