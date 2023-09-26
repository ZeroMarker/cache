PayQuery = function(ds,inscrapNumField,finshCK,auditCK,mainRwoId,locField,dateField,reasonId,addB){
	var url = 'dhcstm.payaction.csp';
	var inscrap = "";
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		
		anchor:'90%',
		value:new Date(),
		editable:false
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		
		anchor:'90%',
		value:new Date(),
		editable:false
	});
	
	var Loc = new Ext.form.ComboBox({
		id:'Loc',
		fieldLabel:'科室',
		width:210,
		listWidth:210,
		allowBlank:true,
		store:GetGroupDeptStore,
		valueField:'RowId',
		displayField:'Description',
		emptyText:'科室...',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:999,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	var finsh = new Ext.form.Checkbox({
		id: 'finsh',
		fieldLabel:'完成',
		allowBlank:true
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		fieldLabel:'审核',
		allowBlank:true
	});
	
	var InscrapProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InscrapDs = new Ext.data.Store({
		proxy:InscrapProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'inscp'},
			{name:'no'},
			{name:'date'},
			{name:'time'},
			{name:'user'},
			{name:'userName'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'chkDate'},
			{name:'chkTime'},
			{name:'chkUser'},
			{name:'chkUserName'},
			{name:'completed'},
			{name:'chkFlag'},
			{name:'stkType'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'reason'},
			{name:'reasonDesc'},
			{name:'remark'}
		]),
		remoteSort: false
	});


	var InscrapCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '报损单rowid',
			dataIndex: 'inscp',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: '调整单号',
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: '科室',
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: "调整日期",
			dataIndex: 'date',
			width: 150,
			align: 'center',
			sortable: true
		},{
			header: "原因",
			dataIndex: 'reasonDesc',
			width: 150,
			align: 'center',
			sortable: true
		},{
			header: "完成状态",
			dataIndex: 'completed',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "审核状态",
			dataIndex: 'chkFlag',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "备注",
			dataIndex: 'remark',
			width: 200,
			align: 'center',
			sortable: true
		}
	]);

	var InscrapPagingToolbar = new Ext.PagingToolbar({
		store:InscrapDs,
		pageSize:15,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['sort']='NO';
			B['dir']='desc';
			B['strPar']=Ext.getCmp('startDate').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDate').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('Loc').getValue()+"^"+(Ext.getCmp('finsh').getValue()==true?'Y':'N')+"^"+(Ext.getCmp('audit').getValue()==true?'Y':'N');
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	
	var fB = new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","请选择截止日期!");
				return false;
			}
			
			var locId = Ext.getCmp('Loc').getValue();
			if((locId=="")||(locId==null)){
				Msg.info("error","请选择申请部门!");
				return false;
			}
			
			var finsh = (Ext.getCmp('finsh').getValue()==true?'Y':'N');
			var audit = (Ext.getCmp('audit').getValue()==true?'Y':'N');
			
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+finsh+"^"+audit;
			
			InscrapDs.load({params:{start:0,limit:InscrapPagingToolbar.pageSize,sort:'NO',dir:'desc',strPar:strPar}});
		}
	});
	
	var InscrapGrid = new Ext.grid.GridPanel({
		store:InscrapDs,
		cm:InscrapCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:InscrapPagingToolbar
	});
	
	var InscrapItmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=queryItem',method:'GET'});
	var InscrapItmDs = new Ext.data.Store({
		proxy:InscrapItmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'inspi'},
			{name:'inclb'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
			{name:'spec'},
			{name:'manf'},
			{name:'uom'},
			{name:'qty'},
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'pp'},
			{name:'ppAmt'},
			{name:'batNo'},
			{name:'expDate'}
		]),
		remoteSort: false
	});


	var InscrapItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		/*{
			header: 'Xrowid',
			dataIndex: 'inspi',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: 'Yrowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: '物资rowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			align: 'center'
		},*/{
			header: '代码',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: '名称',
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'center'
		},{
			header: "批次~效期",
			dataIndex: 'batNo',
			width: 80,
			align: 'center',
			sortable: true
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 80,
			align: 'center',
			sortable: true
		},{
			header: "调整数量",
			dataIndex: 'qty',
			width: 72,
			align: 'center',
			sortable: true
		}/*,{
			header:'单位',
			dataIndex:'uom',
			align:'right',
			width:80,
			sortable:true
		}*/,{
			header:'单价',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'金额',
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'规格',
			dataIndex:'spec',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'售价',
			dataIndex:'sp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'售价金额',
			dataIndex:'spAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'批价',
			dataIndex:'pp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'批价金额',
			dataIndex:'ppAmt',
			align:'right',
			width:80,
			sortable:true
		}
	]);
	
	var InscrapItmGrid = new Ext.grid.GridPanel({
		store:InscrapItmDs,
		cm:InscrapItmCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225
	});

	
	InscrapGrid.on('rowclick',function(grid,rowIndex,e){
		inscrap = InscrapDs.data.items[rowIndex].data["inscp"];
		mainRwoId = inscrap;
		InscrapItmDs.load({params:{inscrap:inscrap}});
	});
	
	InscrapGrid.on('rowdblclick',function(grid,rowIndex,e){
		ds.load({params:{inscrap:inscrap}});
		inscrapNumField.setValue(InscrapDs.data.items[rowIndex].data["no"]);
		
		locField.setValue(InscrapDs.data.items[rowIndex].data["loc"]);
		locField.setRawValue(InscrapDs.data.items[rowIndex].data["locDesc"]);
		dateField.setValue(InscrapDs.data.items[rowIndex].data["date"]);
		if(InscrapDs.data.items[rowIndex].data["completed"]==true){
			finshCK.setValue(true);
			addB.disable();
		}else{
			finshCK.setValue(false);
		}
		if(InscrapDs.data.items[rowIndex].data["chkFlag"]==true){
			auditCK.setValue(true);
			addB.disable();
		}else{
			auditCK.setValue(false);
		}
		reasonId = InscrapDs.data.items[rowIndex].data["reason"];
		causeField.setValue(reasonId);
		causeField.setRawValue(InscrapDs.data.items[rowIndex].data["reasonDesc"]);
		remarkField.setValue(InscrapDs.data.items[rowIndex].data["remark"]);
		findWin.close();
	});
	
	var conPanel = new Ext.form.FormPanel({
		labelwidth:0,
		autoScroll:true,
		labelAlign:'right',
		autoHeight: true, 
		frame:true,
		tbar:[fB],
		layout:'column',
		items:[{
			xtype:'fieldset',
			title:'条件',
			width:1160,
			height:53,
			bodyStyle:'padding:0px;',
			items:[{
				layout:'column',
				items:[
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.12,xtype:'label',text: '开始日期'},
					startDate,
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.12,xtype:'label',text: '结束日期'},
					endDate,
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.06,xtype:'label',text: '科室'},
					Loc,
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.06,xtype:'label',text: '完成'},
					finsh,
					{columnWidth:.1,xtype:'displayfield'},
					{columnWidth:.06,xtype:'label',text: '审核'},
					audit
				]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'查找库存报损单(未审核)',
		width:1200,
		height:600,
		minWidth:1000, 
		minHeight:600,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[conPanel,InscrapGrid,InscrapItmGrid]
	});
		
	//显示窗口
	findWin.show();
};