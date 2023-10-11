FindINScrap = function(ds,inscrapNumField,finshCK,auditCK,mainRowId,locField,dateField,reasonId,addB,fn){
	var url = 'dhcst.inscrapaction.csp';
	var inscrap = "";
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		width:150,
		listWidth:210,
		allowBlank:true,
		fieldLabel:$g('��ʼ����'),
		anchor:'90%',
		value:new Date()
	});
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		width:150,
		listWidth:210,
		allowBlank:true,
		fieldLabel:$g('��ֹ����'),
		anchor:'90%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:$g('����'),
		width:200,
		listWidth:210,
		emptyText:$g('����...'),
		groupId:gGroupId
	});
	Loc.getStore().load(session['LOGON.GROUPID']);
	Loc.setValue(locField.getValue());
	
	var finish = new Ext.form.Checkbox({
		id: 'finish',
		boxLabel:$g('�����'),
		allowBlank:true,
		listeners:{
			'check':function(t,chk){
				if (chk){
					Ext.getCmp('audit').setValue(!chk);
				}
			}
		}
	});

	var audit = new Ext.form.Checkbox({
		id: 'audit',
		boxLabel:$g('�����'),
		allowBlank:true,
		listeners:{
			'check':function(t,chk){
				if (chk){
					Ext.getCmp('finish').setValue(!chk);
				}

			}
		}	
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
		remoteSort: false
	});


	var InscrapCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: $g('����rowid'),
			dataIndex: 'inscp',
			hidden:true
		},{
			header: $g('��������'),
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: $g('����'),
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: $g("��������"),
			dataIndex: 'date',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("ԭ��"),
			dataIndex: 'reasonDesc',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("���״̬"),
			dataIndex: 'completed',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: $g("���״̬"),
			dataIndex: 'chkFlag',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: $g("��ע"),
			dataIndex: 'remark',
			width: 200,
			align: 'left',
			sortable: true
		}
	]);

	var InscrapPagingToolbar = new Ext.PagingToolbar({
		store:InscrapDs,
		pageSize:15,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});
	
	var clearB=new Ext.Toolbar.Button({
		text:$g('����'),
		height:30,
		width:70,
		iconCls:'page_clearscreen',
		handler:function()
		{
			SetLogInDept(Loc.getStore(),'Loc');
			Ext.getCmp('startDate').setValue(new Date());
			Ext.getCmp('endDate').setValue(new Date());
			Ext.getCmp('audit').setValue(false);
			Ext.getCmp('finish').setValue(false);
			Ext.getCmp('InscrapGrid').getStore().removeAll();
			Ext.getCmp('InscrapItmGrid').getStore().removeAll();
		}
	
	
	})
	var fB = new Ext.Toolbar.Button({
		text:$g('��ѯ'),
		tooltip:$g('��ѯ'),
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			find();
		}
	});
	
	var closWinB=new Ext.Toolbar.Button({
		text:$g('�ر�'),
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
			header: $g('ҩƷrowid'),
			dataIndex: 'inci',
			hidden:true
		},{
			header: $g('����'),
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: $g('����'),
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header: $g("����~Ч��"),
			dataIndex: 'batNo',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("������ҵ"),
			dataIndex: 'manf',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("��������"),
			dataIndex: 'qty',
			width: 72,
			align: 'right',
			sortable: true
		},{
			header:$g('��λ'),
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:$g('����'),
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('���'),
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('���'),
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header:$g('�ۼ�'),
			dataIndex:'sp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('�ۼ۽��'),
			dataIndex:'spAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('����'),
			dataIndex:'pp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('���۽��'),
			dataIndex:'ppAmt',
			align:'right',
			width:80,
			sortable:true
		}
	]);
var InscrapItmPagingToolbar = new Ext.PagingToolbar({
		store:InscrapItmDs,
		pageSize:30,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});
	var InscrapItmGrid = new Ext.grid.GridPanel({
		region:'south',
		store:InscrapItmDs,
		cm:InscrapItmCm,
		id:'InscrapItmGrid',
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		bbar:InscrapItmPagingToolbar,
		height:225
	});
  
	/*
	InscrapGrid.on('rowclick',function(grid,rowIndex,e){
		InscrapItmDs.removeAll();
		inscrap = InscrapDs.data.items[rowIndex].data["inscp"];
		mainRowId = inscrap;
		InscrapItmDs.load({params:{inscrap:inscrap}});
	});
	*/
	
	InscrapGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		InscrapItmDs.removeAll();
		inscrap = InscrapDs.data.items[rowIndex].data["inscp"];
		mainRowId = inscrap;
		InscrapItmDs.setBaseParam('inscrap',inscrap)
		InscrapItmDs.load({
			params:{start:0,limit:InscrapItmPagingToolbar.pageSize},
			callback : function(r,options, success){
				if(success==false){
					Ext.MessageBox.alert($g("��ѯ����"),this.reader.jsonData.Error); 
	 			}
			}	
		});
	});
	
	
	InscrapGrid.on('rowdblclick',function(grid,rowIndex,e){		
		fn(inscrap)
		//ds.load({params:{inscrap:inscrap}});
		//findWin.close();
		findWin.hide();
	});
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelWidth:60,
		labelAlign:'right',
		frame:true,
		tbar:[fB,'-',clearB,'-',closWinB],
		layout:'fit',
		items:[{
			xtype:'fieldset',
			title:$g('��ѯ����'),
			layout:'column',
			style:DHCSTFormStyle.FrmPaddingV,
			items:[{
				columnWidth:.25,
				xtype:'fieldset',
				border:false,
				items:Loc
			},{
				columnWidth:.25,
				xtype:'fieldset',
				border:false,
				items:startDate
			},{
				columnWidth:.25,
				xtype:'fieldset',
				border:false,
				items:endDate
			},{
				columnWidth:.12,
				labelWidth:10,
				xtype:'fieldset',
				border:false,
				items:finish
			},{
				columnWidth:.12,
				xtype:'fieldset',
				border:false,
				labelWidth:10,
				items:audit
			}]
		}]
	});
	
	var findWin = new Ext.Window({
		title:$g('���ҿ�汨��'),
		id:'scrapWinFind',
		height:document.body.clientHeight*0.9,
		width:document.body.clientWidth*0.9,
		minHeight:document.body.clientWidth*0.3,
		layout:'border',
		plain:true,
		modal:true,
		//bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:[
			{
	            region: 'north',
	            height: DHCSTFormStyle.FrmHeight(1)-28, // give north and south regions a height
	            layout: 'fit', // specify layout manager for items
	            items:[conPanel]
        	},{
                region: 'center',			               
                layout: 'fit', // specify layout manager for items
                items: InscrapGrid       
		               
		    }, {
                region: 'south',
                split: true,
    			height: 250,
    			minSize: 200,
    			maxSize: 350,
                layout: 'fit', // specify layout manager for items
                items: InscrapItmGrid       
               
            }],
		listeners:{
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
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("��ѡ����ʼ����!"));
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("��ѡ���ֹ����!"));
			return false;
		}
		
		var locId = Ext.getCmp('Loc').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("��ѡ�����벿��!"));
			return false;
		}
		
		var finish = (Ext.getCmp('finish').getValue()==true?'Y':'N');
		var audit = (Ext.getCmp('audit').getValue()==true?'Y':'');
		
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+finish+"^"+audit;
		InscrapItmDs.removeAll();
		InscrapDs.setBaseParam('strParam',strPar);
		InscrapDs.removeAll();
		InscrapDs.load({params:{start:0,limit:InscrapPagingToolbar.pageSize,sort:'NO',dir:'desc'}});
		InscrapDs.on('load',function(){
			if (InscrapDs.getCount()>0){
				InscrapGrid.getSelectionModel().selectFirstRow();
				InscrapGrid.focus();
				InscrapGrid.getView().focusRow(0);
			}
			//findWin.focus();
			
		})
		
		//InscrapDs.
	}	
};

