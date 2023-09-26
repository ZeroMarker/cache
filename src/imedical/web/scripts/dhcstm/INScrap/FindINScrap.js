FindINScrap = function(fn){
	var url = 'dhcstm.inscrapaction.csp';
	var inscrap = "";
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'90%',
		value:new Date()
	});
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'90%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:'����',
		width:200,
		listWidth:210,
		emptyText:'����...',
		groupId:gGroupId
	});
	
	var finish = new Ext.form.Checkbox({
		id: 'finish',
		hideLabel : true,
		boxLabel:'�����',
		allowBlank:true
	});
	
	var InscrapProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
	var InscrapDs = new Ext.data.Store({
		proxy:InscrapProxy,
		id:'InscrapDs',
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
		remoteSort: false,
		listeners : {
			load : function(store, records, options){
				if (records.length > 0){
					InscrapGrid.getSelectionModel().selectFirstRow();
					InscrapGrid.getView().focusRow(0);
				}
			}
		}
	});

	var InscrapCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����rowid',
			dataIndex: 'inscp',
			hidden:true
		},{
			header: '��������',
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: '����',
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: "��������",
			dataIndex: 'date',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "ԭ��",
			dataIndex: 'reasonDesc',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "���״̬",
			dataIndex: 'completed',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "���״̬",
			dataIndex: 'chkFlag',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: "��ע",
			dataIndex: 'remark',
			width: 200,
			align: 'left',
			sortable: true
		}
	]);

	var InscrapPagingToolbar = new Ext.PagingToolbar({
		store:InscrapDs,
		pageSize:15,
		displayInfo:true
	});
	
	var clearB=new Ext.Toolbar.Button({
		text:'���',
		height:30,
		width:70,
		iconCls:'page_clearscreen',
		handler:function()
		{
			SetLogInDept(Loc.getStore(),'Loc');
			Ext.getCmp('startDate').setValue(new Date());
			Ext.getCmp('endDate').setValue(new Date());
			Ext.getCmp('finish').setValue(false);
			Ext.getCmp('InscrapGrid').getStore().removeAll();
			Ext.getCmp('InscrapItmGrid').getStore().removeAll();
		}
	});
	var fB = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			find();
		}
	});
	
	var closWinB=new Ext.Toolbar.Button({
		text:'�ر�',
		height:30,
		width:70,
		iconCls:'page_delete',
		handler:function(){
			//findWin.close();
			findWin.hide();
		}
	});
	
	var InscrapGrid = new Ext.grid.GridPanel({
		region:'center',
		store:InscrapDs,
		cm:InscrapCm,
		id:'InscrapGrid',
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
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
			{name:'uomDesc'},
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
		{
			header: 'Xrowid',
			dataIndex: 'inspi',
			hidden:true
		},{
			header: 'Yrowid',
			dataIndex: 'inclb',
			hidden:true
		},{
			header: '����rowid',
			dataIndex: 'inci',
			hidden:true
		},{
			header: '����',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header: "����~Ч��",
			dataIndex: 'batNo',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'manf',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: "��������",
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
		},{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'���',
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'�ۼ�',
			dataIndex:'sp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'�ۼ۽��',
			dataIndex:'spAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'����',
			dataIndex:'pp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:'���۽��',
			dataIndex:'ppAmt',
			align:'right',
			width:80,
			sortable:true
		}
	]);
var InscrapItmPagingToolbar = new Ext.PagingToolbar({
		store:InscrapItmDs,
		pageSize:15,
		displayInfo:true
	});
	
	var InscrapItmGrid = new Ext.grid.GridPanel({
		region:'south',
		height:gGridHeight,
		store:InscrapItmDs,
		cm:InscrapItmCm,
		id:'InscrapItmGrid',
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:InscrapItmPagingToolbar
	});
	
	InscrapGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		InscrapItmDs.removeAll();
		inscrap = InscrapDs.data.items[rowIndex].data["inscp"];
		InscrapItmDs.setBaseParam('inscrap',inscrap)
		InscrapItmDs.load({params:{start:0,limit:InscrapItmPagingToolbar.pageSize}});
	});
	
	
	InscrapGrid.on('rowdblclick',function(grid,rowIndex,e){		
		fn(inscrap)
		//findWin.close();
		findWin.hide();
	});
	
	var conPanel = new Ext.ux.FormPanel({
		labelWidth:60,
		tbar:[fB,'-',clearB,'-',closWinB],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			autoHeight:true,
			bodyStyle:'padding:5px 0 0 0',
			items:[{
				layout:'column',
				items:[{
					columnWidth:.25,
					layout:'form',
					items:Loc
				},{
					columnWidth:.25,
					layout:'form',
					items:startDate
				},{
					columnWidth:.25,
					layout:'form',
					items:endDate
				},{
					columnWidth:.12,
					layout:'form',
					items:finish
				}]
			}]
		}]
	});
	
	var findWin = new Ext.ux.Window({
		title:'���ҿ�汨��',
		id:'scrapWinFind',
		layout:'border',
		items:[conPanel,InscrapGrid,InscrapItmGrid],
		listeners:{
			'render':function(){
				var LocId = Ext.getCmp('locField').getValue();
				var LocDesc = Ext.getCmp('locField').getRawValue();
				addComboData(null, LocId, LocDesc, Ext.getCmp('Loc'));
				Ext.getCmp('Loc').setValue(LocId);
			},
			'show':function(){
				find();
			}
		}
	});

	//��ʾ����
	findWin.show();

	function find(){
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
			Msg.info("error","��ѡ�����벿��!");
			return false;
		}
		
		var finish = Ext.getCmp('finish').getValue()==true?'Y':'N';
		var audit = 'N';
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+finish+"^"+audit;
		
		InscrapItmDs.removeAll();
		InscrapDs.setBaseParam('strParam',strPar);
		InscrapDs.removeAll();
		InscrapDs.load({params:{start:0,limit:InscrapPagingToolbar.pageSize,sort:'NO',dir:'desc'}});
	}	
};

