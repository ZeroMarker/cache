FindINScrap = function(ds,inscrapNumField,finshCK,auditCK,mainRowId,locField,dateField,reasonId,addB,fn){
	var url = 'dhcst.inscrapaction.csp';
	var inscrap = "";
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		width:150,
		listWidth:210,
		allowBlank:true,
		fieldLabel:$g('起始日期'),
		anchor:'90%',
		value:new Date()
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		width:150,
		listWidth:210,
		allowBlank:true,
		fieldLabel:$g('截止日期'),
		anchor:'90%',
		value:new Date()
	});
	
	var Loc = new Ext.ux.LocComboBox({
		id:'Loc',
		fieldLabel:$g('科室'),
		width:200,
		listWidth:210,
		emptyText:$g('科室...'),
		groupId:gGroupId
	});
	Loc.getStore().load(session['LOGON.GROUPID']);
	Loc.setValue(locField.getValue());
	
	var finish = new Ext.form.Checkbox({
		id: 'finish',
		boxLabel:$g('已完成'),
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
		boxLabel:$g('已审核'),
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
			header: $g('报损单rowid'),
			dataIndex: 'inscp',
			hidden:true
		},{
			header: $g('调整单号'),
			dataIndex: 'no',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: $g('科室'),
			dataIndex: 'locDesc',
			width: 150,
			sortable:true,
			align: 'left'
		},{
			header: $g("报损日期"),
			dataIndex: 'date',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("原因"),
			dataIndex: 'reasonDesc',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("完成状态"),
			dataIndex: 'completed',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: $g("审核状态"),
			dataIndex: 'chkFlag',
			width: 100,
			align: 'center',
			sortable: true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: $g("备注"),
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
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
	
	var clearB=new Ext.Toolbar.Button({
		text:$g('清屏'),
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
		text:$g('查询'),
		tooltip:$g('查询'),
		iconCls:'page_find',
		width:70,
		height:30,
		handler:function(){
			find();
		}
	});
	
	var closWinB=new Ext.Toolbar.Button({
		text:$g('关闭'),
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
			header: $g('药品rowid'),
			dataIndex: 'inci',
			hidden:true
		},{
			header: $g('代码'),
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: $g('名称'),
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header: $g("批次~效期"),
			dataIndex: 'batNo',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("生产企业"),
			dataIndex: 'manf',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header: $g("报损数量"),
			dataIndex: 'qty',
			width: 72,
			align: 'right',
			sortable: true
		},{
			header:$g('单位'),
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:$g('单价'),
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('金额'),
			dataIndex:'rpAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('规格'),
			dataIndex:'spec',
			align:'left',
			width:80,
			sortable:true
		},{
			header:$g('售价'),
			dataIndex:'sp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('售价金额'),
			dataIndex:'spAmt',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('批价'),
			dataIndex:'pp',
			align:'right',
			width:80,
			sortable:true
		},{
			header:$g('批价金额'),
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
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
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
					Ext.MessageBox.alert($g("查询错误"),this.reader.jsonData.Error); 
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
			title:$g('查询条件'),
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
		title:$g('查找库存报损单'),
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

	//显示窗口
	findWin.show();

	function find(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("请选择起始日期!"));
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("请选择截止日期!"));
			return false;
		}
		
		var locId = Ext.getCmp('Loc').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("请选择申请部门!"));
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

