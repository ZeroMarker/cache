FindINAdj = function(ds,adjNumField,mainRowId,locField,dateField,addB,finshCK,auditCK,fn){
	var url = 'dhcst.inadjaction.csp';
	var adj = "";
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date()
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'95%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:'科室',
		listWidth:210,
		emptyText:'科室...',
		anchor:'95%',
		groupId:GroupId
	});
	
	var finsh = new Ext.form.Checkbox({
		id: 'finsh',
		boxLabel:'完成',
		anchor:'95%',
		allowBlank:true
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		boxLabel:'审核',
		anchor:'95%',
		allowBlank:true
	});
	// 调整原因
	var adjReasonField = new Ext.form.ComboBox({
		id:'adjReasonField',
		fieldLabel:'调整原因',
		listWidth:200,
		allowBlank:true,
		store:ReasonForAdjustMentStore,
		valueField:'RowId',
		displayField:'Description',
		emptyText:'调整原因...',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:200,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		anchor:'90%'
	});
	ReasonForAdjustMentStore.load();
	var InadjProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InadjDs = new Ext.data.Store({
		proxy:InadjProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'adj'},
			{name:'no'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'date'},
			{name:'time'},
			{name:'user'},
			{name:'userName'},
			{name:'chkDate'},
			{name:'chkTime'},
			{name:'chkUser'},
			{name:'chkUserName'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'comp'},
			{name:'state'},
			{name:'chkFlag'},
			{name:'stkType'},
			{name:'spAmt'},
			{name:'rpAmt'},
			{name:'adjReason'},
			{name:'adjRemark'}
		]),
		remoteSort: false,
		listeners:{
		'load':function(){
		
			
			
		}
		}
	});

	
	var InadjCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '调整单rowid',
			dataIndex: 'adj',
			hidden:true
		},{
			header: '调整单号',
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: '科室',
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: "调整日期",
			dataIndex: 'date',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "scg",
			dataIndex: 'scg',
			width: 150,
			align: 'center',
			hidden:true
		},
		{
			header: "类组",
			dataIndex: 'scgDesc',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: "完成",
			dataIndex: 'comp',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "审核",
			dataIndex: 'chkFlag',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
	        header:"进价金额",
	        dataIndex:'rpAmt',
	        width:100,
	        align:'right',
	        sortable:true
	    },{
	        header:"售价金额",
	        dataIndex:'spAmt',
	        width:100,
	        align:'right',
	        sortable:true
	    },{
	        header:"调整原因",
	        dataIndex:'adjReason',
	        width:100,
	        align:'left'
	    },{
	        header:"备注",
	        dataIndex:'adjRemark',
	        width:100,
	        align:'left'
	    }
	]);

	var InadjPagingToolbar = new Ext.PagingToolbar({
		store:InadjDs,
		pageSize:15,
		id:'adjGrid',
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
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
				startDate = startDate.format(App_StkDateFormat);
			}else{
				Msg.info("error","请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(App_StkDateFormat);
			}else{
				Msg.info("error","请选择截止日期!");
				return false;
			}
			
			var locId = Ext.getCmp('Loc').getValue();
			if((locId=="")||(locId==null)){
				Msg.info("error","请选择科室!");
				return false;
			}
			
			var finsh = (Ext.getCmp('finsh').getValue()==true?'Y':'N');
			var audit = (Ext.getCmp('audit').getValue()==true?'Y':'N');
			var reasondr=Ext.getCmp('adjReasonField').getValue();
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+audit+"^"+finsh+"^"+reasondr;
			InadjDs.setBaseParam('strParam',strPar);
			InadjDs.removeAll();
			InadjItmDs.removeAll();
			InadjDs.load({params:{start:0,limit:InadjPagingToolbar.pageSize,sort:'NO',dir:'desc'}});
			
			InadjDs.on('load',function(){
					if (InadjDs.getCount()>0){InadjGrid.getSelectionModel().selectFirstRow();
						InadjGrid.focus();
						InadjGrid.getView().focusRow(0);
					}
			})
	
		}
	});
	
	var cancelFind=new Ext.Toolbar.Button({
		text:'关闭',
		height:30,
		width:70,
		iconCls:'page_delete',
		handler:function()
		{
			findWin.close();		
		}
	
	
	})
	var InadjGrid = new Ext.grid.GridPanel({
		region:'center',
		store:InadjDs,
		cm:InadjCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:InadjPagingToolbar
	});
	
	var InadjItmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=queryItem',method:'GET'});
	var InadjItmDs = new Ext.data.Store({
		proxy:InadjItmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'adjitm'},
			{name:'inclb'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
			{name:'spec'},
			{name:'manf'},
			{name:'batNo'},
			{name:'expDate'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'qtyBUOM'},
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'insti'}
		]),
		remoteSort: false
	});


	var InadjItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '明细rowid',
			dataIndex: 'adjitm',
			hidden:true
		},{
			header: '批次rowid',
			dataIndex: 'inclb',
			hidden:true
		},{
			header: '药品rowid',
			dataIndex: 'inci',
			hidden:true
		},{
			header: '代码',
			dataIndex: 'code',
			width: 70,
			sortable:true,
			align: 'left'
		},{
			header: '名称',
			dataIndex: 'desc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: "批次~效期",
			dataIndex: 'batNo',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "调整数量",
			dataIndex: 'qty',
			width: 72,
			align: 'right',
			sortable: true
		},{
			header:'单位',
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'进价',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'进价金额',
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'售价',
			dataIndex:'sp',
			align:'right',
			width:100,
			sortable:true
		},{
			header:'售价金额',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			sortable:true
		},{
			header:'规格',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		}
	]);
	
	var InadjItmPagingToolbar = new Ext.PagingToolbar({
		store:InadjItmDs,
		pageSize:15,
		id:'adjItmGrid',
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var InadjItmGrid = new Ext.grid.GridPanel({
		region:'south',
		store:InadjItmDs,
		cm:InadjItmCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:InadjItmPagingToolbar
	});

	InadjGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		adj = InadjDs.data.items[rowIndex].data["adj"];
 		mainRowId = adj;
 		InadjItmDs.setBaseParam('adj',adj);
 		InadjItmDs.removeAll();
		InadjItmDs.load({
			params:{start:0,limit:InadjItmPagingToolbar.pageSize},
			callback : function(r,options, success){
				if(success==false){
					Ext.MessageBox.alert("查询错误",this.reader.jsonData.Error); 
	 			}
			}
		
		});
	});		
	
	InadjGrid.on('rowdblclick',function(grid,rowIndex,e){
		ds.load({params:{adj:adj}});
		SetMain(adj);
		fn(adj)		
		findWin.close();
	});
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelWidth:60,
		autoScroll:false,
		labelAlign:'right',
		height: DHCSTFormStyle.FrmHeight(1), 
		frame:true,
		tbar:[fB,'-',cancelFind],
		//layout:'column',
		layout:'fit',
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			items:[{
				layout:'column',
				items:[
					{columnWidth:.2,xtype : 'fieldset',border:false,items:startDate},
					{columnWidth:.2,xtype : 'fieldset',border:false,items:endDate},
					{columnWidth:.25,xtype : 'fieldset',border:false,items:Loc},
					{columnWidth:.2,xtype : 'fieldset',border:false,items:adjReasonField},
					{columnWidth:.15,xtype : 'fieldset',border:false,listWidth:10,items:[finsh,audit]}
				]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'查找库存调整单',
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
		minWidth:document.body.clientWidth*0.3, 
		minHeight:document.body.clientHeight*0.3,
		layout:'border',
		plain:true,
		modal:true,
		//bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[conPanel,InadjGrid,InadjItmGrid],
		listeners:{
		'render':function(){
			var locRowid=locField.getValue();
			var locDesc=locField.getRawValue();
			Ext.getCmp('Loc').setValue(locRowid);
	
		}
		}
	});
		
	//显示窗口
	findWin.show();
};

function SetMain(adj){
	mainRowId=adj;
}
