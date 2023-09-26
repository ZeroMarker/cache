FindINDispRet = function(loc,fn){
	var url = 'dhcstm.indispretaction.csp';
	var dsr = "";
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'95%',
		value:new Date().add(Date.DAY,-30)
	});
	
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'95%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:'����',
		listWidth:210,
		emptyText:'����...',
		anchor:'95%',
		groupId:GroupId
	});
	
	var finish = new Ext.form.Checkbox({
		id: 'finish',
		fieldLabel:'���',
		anchor:'95%',
		allowBlank:true
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		fieldLabel:'���',
		anchor:'95%',
		allowBlank:true
	});
	
	var dsrProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InDispRetDs = new Ext.data.Store({
		proxy:dsrProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsr'},
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
			{name:'dispmode'},
			{name:'recUser'},
			{name:'recUserName'},
			{name:'grp'},
			{name:'grpDesc'},
			'RetLocId','RetLoc'
		]),
		remoteSort: false,
		listeners : {
			load : function(store,records,options){
				if (records.length>0){
					InDispRetGrid.getSelectionModel().selectFirstRow();
					InDispRetGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var InDispCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '�˻ص�rowid',
			dataIndex: 'dsr',
			hidden:true
		},{
			header: '�˻ص���',
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header:'���տ���',
			dataIndex:'RetLoc',
			width:150
		},{
			header: "�˻�����",
			dataIndex: 'date',
			width: 120,
			align: 'left',
			sortable: true
		},{
			header: "scg",
			dataIndex: 'scg',
			width: 150,
			align: 'center',
			hidden:true
		},{
			header: "����",
			dataIndex: 'scgDesc',
			width: 60,
			align: 'left',
			sortable: true
		},{
			header:'�Ƶ���',
			dataIndex:'userName',
			width:60
		},{
			header: "���",
			dataIndex: 'comp',
			width: 40,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "���",
			dataIndex: 'chkFlag',
			width: 40,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);

	var DsrPagingToolbar = new Ext.PagingToolbar({
		store:InDispRetDs,
		pageSize:15,
		displayInfo:true
	});
	
	var fB = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ����ʼ����!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ���ֹ����!");
				return false;
			}
			
			var locId = Ext.getCmp('Loc').getValue();
			if((locId=="")||(locId==null)){
				Msg.info("error","��ѡ�����!");
				return false;
			}
			
			var finish = (Ext.getCmp('finish').getValue()==true?'Y':'N');
			var audit = (Ext.getCmp('audit').getValue()==true?'Y':'N');
			
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+audit+"^"+finish;
			InDispRetDs.setBaseParam('strParam',strPar);
			InDispRetDs.removeAll();
			InDispRetItmDs.removeAll();
			InDispRetDs.load({
				params:{start:0,limit:DsrPagingToolbar.pageSize,sort:'NO',dir:'desc'}
			});
		}
	});
	
	var cancelFind=new Ext.Toolbar.Button({
		text:'�ر�',
		height:30,
		width:70,
		iconCls:'page_delete',
		handler:function()
		{
			findWin.close();		
		}
	})
	
	var InDispRetGrid = new Ext.ux.GridPanel({
		id : 'InDispRetGrid',
		region:'center',
		store:InDispRetDs,
		cm:InDispCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:DsrPagingToolbar
	});
	
	var InDispRetItmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=queryItem',method:'GET'});
	var InDispRetItmDs = new Ext.data.Store({
		proxy:InDispRetItmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsrItm'},
			{name:'inclb'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
			{name:'Abbrev'},
			{name:'spec'},
			{name:'manf'},
			{name:'batNo'},
			{name:'expDate'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			"Brand","Model"
		]),
		remoteSort: false
	});


	var InDispRetItmCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '��ϸrowid',
			dataIndex: 'dsrItm',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inclb',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inci',
			hidden:true
		},
		/*
	    {
	        header:"������",
	        dataIndex:'receiveUser',
	        width:100,
	        align:'left',
	        sortable:true,
	 	    renderer:Ext.util.Format.comboRenderer2(UCG,"UserId","Name")
	 	    //,
			//editor:new Ext.grid.GridEditor(UCG)       
	    },				
				
		*/			
		{
			header: '����',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'desc',
			width: 180,
			sortable:true,
			align: 'left'
		},{
			header:'���',
			dataIndex:'Abbrev',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'Ʒ��',
			dataIndex:'Brand',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'�ͺ�',
			dataIndex:'Model',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header: "����~Ч��",
			dataIndex: 'batNo',
			width: 180,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "�˻�����",
			dataIndex: 'qty',
			width: 72,
			align: 'right',
			sortable: true
		},{
			header:'��λ',
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		}/*,{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		}*/,{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'���۽��',
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		}
	]);
	
	var dsrItmPagingToolbar = new Ext.PagingToolbar({
		store:InDispRetItmDs,
		pageSize:15,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var InDispRetItmGrid = new Ext.ux.GridPanel({
		id : 'InDispRetItmGrid',
		region:'south',
		store:InDispRetItmDs,
		cm:InDispRetItmCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:dsrItmPagingToolbar
	});

	InDispRetGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		dsr = InDispRetDs.data.items[rowIndex].data["dsr"];
 		mainRowId = dsr;
 		InDispRetItmDs.setBaseParam('dsr',dsr);
 		InDispRetItmDs.removeAll();
		InDispRetItmDs.load({params:{start:0,limit:dsrItmPagingToolbar.pageSize}});
	});		
	
	InDispRetGrid.on('rowdblclick',function(grid,rowIndex,e){
		//var ds=grid.getStore();
		//ds.load({params:{dsr:dsr}});
		//SetMain(dsr);
		fn(dsr)		
		/*
		adjNumField.setValue(InDispRetDs.data.items[rowIndex].data["no"]);
		groupField.setValue(InDispRetDs.data.items[rowIndex].data["scg"]);
		
		
		locField.setValue(InDispRetDs.data.items[rowIndex].data["loc"]);
		locField.setRawValue(InDispRetDs.data.items[rowIndex].data["locDesc"]);
		dateField.setValue(InDispRetDs.data.items[rowIndex].data["date"]);
		//alert(InDispRetDs.data.items[rowIndex].data["comp"]);
		
		//��ɱ�־
		if(InDispRetDs.data.items[rowIndex].data["comp"]=="Y"){
			finshCK.setValue(true);
			//addB.disable();
		}else{
			finshCK.setValue(false);
		}
		//��˱�־
		if(InDispRetDs.data.items[rowIndex].data["chkFlag"]=="Y"){
			auditCK.setValue(true);
			//addB.disable();
		}else{
			auditCK.setValue(false);
		}
		//����
		//Ext.getCmp('').setValue(InDispRetDs.data.items[rowIndex].data["scg"])
		
		*/
		
		findWin.close();
	});
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelWidth:60,
		autoScroll:true,
		labelAlign:'right',
		autoHeight: true, 
		frame:true,
		tbar:[fB,'-',cancelFind],
		layout:'column',
		layout:'fit',
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			autoHeight:true,
			bodyStyle:'padding:0px;',
			items:[{
				layout:'column',
				items:[
					{columnWidth:.2,layout:'form',items:startDate},
					{columnWidth:.2,layout:'form',items:endDate},
					{columnWidth:.3,layout:'form',items:Loc},
					{columnWidth:.15,layout:'form',items:finish},
					{columnWidth:.15,layout:'form',items:audit}
				]
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'������Ա�˻ص�',
		width:gWinWidth,
		height:gWinHeight,
		minWidth:1000, 
		minHeight:600,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[conPanel,InDispRetGrid,InDispRetItmGrid]
	});
		
	//��ʾ����
	findWin.show();
	fB.handler();
};
