findIngDret = function(){
	//起始日期
	var startDate = new Ext.form.DateField({
		id:'startDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:$g('起始日期'),
		anchor:'90%',
		value:DefaultStDate()
		//,
		//editable:false
	});
	//截止日期
	var endDate = new Ext.form.DateField({
		id:'endDate',
		listWidth:210,
		allowBlank:true,
		fieldLabel:$g('截止日期'),
		anchor:'90%',
		value:DefaultEdDate()
		//,
		//editable:false
	});
    var rLocdr=Ext.getCmp('locField').getValue();
    if (rLocdr == null || rLocdr.length <= 0) {
		Msg.info("warning", $g("供给部门不能为空,请关闭窗体选择供给部门！"));
		return;
	}  
    
	var completFlag = new Ext.grid.CheckColumn({
		header:$g('完成标志'),
		dataIndex:'completed',
		anchor:'90%',		
		sortable:true,
		align: 'center',
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
			
	var auditFlag = new Ext.grid.CheckColumn({
		header:$g('审核标志'),
		dataIndex:'auditFlag',
		anchor:'90%',		
		sortable:true,
		align: 'center',
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});


	var Vendor2 = new Ext.ux.VendorComboBox({
	fieldLabel : $g('经营企业'),
	id : 'Vendor2',
	name : 'Vendor2',
	anchor:'90%',
	width : 140
});

	var chkComplete=new Ext.form.Checkbox({
		boxLabel:$g('仅已完成'),
		id:'completed',
		name:'completed',
		anchor:'90%'	
	});
	
	var OrderProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectOrder',method:'GET'});
	var OrderDs = new Ext.data.Store({
		proxy:OrderProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'}, [
			{name:'ingrt'},
			{name:'vendor'},
			{name:'vendorName'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'ingrtNo'},
			{name:'retDate'},
			{name:'retTime'},
			{name:'retUser'},
			{name:'retUserName'},
			{name:'auditDate'},
			{name:'auditTime'},
			{name:'auditUser'},
			{name:'auditUserName'},
			{name:'auditFlag'},
			{name:'completed'},
			{name:'adjCheque'},
			{name:'scg'},
			{name:'scgDesc'}
		]),
		remoteSort: false
	});


	var OrderCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header:'ingrt',
			dataIndex:'ingrt',
			hidden:true
		},{
			header: $g('退货单号'),
			dataIndex: 'ingrtNo',
			width: 150,
			sortable:true,
			align: 'center'
		},{
			header: $g('经营企业'),
			dataIndex: 'vendorName',
			width: 220,
			sortable:true,
			align: 'left'
		},{
			header: $g("日期"),
			dataIndex: 'retDate',
			width: 120,
			align: 'center',
			sortable: true
		},{
			header:$g('完成标志'),
			dataIndex:'completed',
			align:'center',
			width:120,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		},{
			header: $g("操作人"),
			dataIndex: 'retUserName',
			width: 120,
			align: 'center',
			sortable: true
		},{
			header:$g('审核标志'),
			dataIndex:'auditFlag',
			align:'center',
			width:120,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		}
	]);

	var pagingToolbar = new Ext.PagingToolbar({
		store:OrderDs,
		pageSize:20,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
		/*,
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['sort']='ingrt';
			B['dir']='desc';
			B['strPar']=Ext.getCmp('startDate').getValue().format('Y-m-d')+"^"+Ext.getCmp('endDate').getValue().format('Y-m-d')+"^"+rLocdr+"^"+Ext.getCmp('Vendor2').getValue();
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}

		*/


	});

	handler = function(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){startDate = startDate.format(App_StkDateFormat);}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){endDate = endDate.format(App_StkDateFormat);}
		var vorId = Ext.getCmp('Vendor2').getValue();
		if((startDate=="")||(startDate==null)){
			Msg.info("error",$g("请选择起始日期!"));
			return false;
		}
		if((endDate=="")||(endDate==null)){
			Msg.info("error",$g("请选择截止日期!"));
			return false;
		}
		/*
		if((vorId=="")||(vorId==null)){
			Msg.info("error","请选择经营企业!");
			return false;
		} */
		/*if((locId=="")||(locId==null)){
			Msg.info("error","请选择科室!");
			return false;
		}*/
		//改为取选择的科室
		if((rLocdr=="")||(rLocdr==null)){
			Msg.info("error",$g("请选择科室!"));
	    return false;
		}
		var complete="";
		if (chkComplete.getValue()==true)
		{complete="Y"}
		//else
		//{complete="N"}
		
		//strPar - 参数串(起始日期^截止日期^科室Id^经营企业Id^^仅已完成)
        var strParam=startDate+"^"+endDate+"^"+rLocdr+"^"+vorId+"^^"+complete
	    var ingrtstr="ingrt"
        var descstr="desc"
		OrderDs.setBaseParam("strPar",strParam);
        OrderDs.setBaseParam("sort",ingrtstr);
		OrderDs.setBaseParam("dir",descstr);
		//,sort:'ingrt',dir:'desc'
		OrderDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
	};

	var fB = new Ext.Toolbar.Button({
		text:$g('查询'),
		tooltip:$g('查询'),
		iconCls:'page_find',
		width : 70,
		height : 30
	});
	var xB=new Ext.Toolbar.Button({
		text:$g('关闭'),
		tooltip:$g('关闭'),
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			findWin.close();
		}
	});
	
	fB.addListener('click',handler,false);
	
	var conPanel = new Ext.form.FormPanel({
		region:'north',
		labelWidth:60,
		autoScroll:false,
		labelAlign:'right',
		//autoHeight: true, 
		frame:true,
		height:DHCSTFormStyle.FrmHeight(1)-28,
		tbar:[fB,'-',xB],
		items:[{
			xtype:'fieldset',
			title:$g('查询条件'),
			style:DHCSTFormStyle.FrmPaddingV,
			layout:'column',
			defaults: {border:false}, 
			items:[
				{columnWidth:.25,xtype:'fieldset',items:[startDate]},
				{columnWidth:.25,xtype:'fieldset',items:[endDate]},
				{columnWidth:.3,xtype:'fieldset',items:[Vendor2]},
				{columnWidth:.15,listWidth:0,xtype:'fieldset',items:[chkComplete]}
				
			]
		}]
	});

	var Grid = new Ext.grid.GridPanel({
		region:'center',
		store:OrderDs,
		cm:OrderCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		//height:325,
		bbar:pagingToolbar
	});
	
	var findWin = new Ext.Window({
		title:$g('查找退货单'),
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
		minWidth:document.body.clientWidth*0.3, 
		minHeight:document.body.clientHeight*0.3,
		layout:'border',
		plain:true,
		modal:true,
		//bodyStyle:'padding:5px;',
		//buttonAlign:'center',
		items:[conPanel,Grid]
	});
		
	//显示窗口
	findWin.show();
	
	Grid.on('rowdblclick',function(grid,rowIndex,e){
		var ingrt=OrderDs.data.items[rowIndex].data["ingrt"];
		Select(ingrt);
		IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:ingrt}});
		findWin.close();
	});
};