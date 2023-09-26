///名称:胰岛素查询
///描述: 胰岛素累计数以及用药明细
///编写者：MYQ
///编写日期: 2015.07.16
///dhcpha.queryinsulindetail.js
Ext.onReady(function() {
	var logonloc = session['LOGON.CTLOCID'];
	var URL = 'dhcpha.queryinsulindetailaction.csp';
	
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		listWidth:80,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'95%',
		value:new Date()
	});
	
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		listWidth:80,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'95%',
		value:new Date()
	});
	
	///定义药房科室
  var ComBoPhaLocDs = new Ext.data.Store({
		autoLoad: true,
		proxy:new Ext.data.HttpProxy({url:URL+'?actiontype=GetPhaLocDs',method:'GET'}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'PhaLocID'},['PhaLocDesc','PhaLocID'])
				
	});
	
	var PhaLocCombox = new Ext.form.ComboBox({
		fieldLabel:'药房科室',
		id:'PhaLocCombox',
		name:'PhaLocCombox',
		store : ComBoPhaLocDs,
		width:200,
		listWidth : 200,
		emptyText:'选择药房科室...',
		hideOnSelect : false,
		maxHeight : 300,	
		valueField : 'PhaLocID',
		displayField : 'PhaLocDesc',
		triggerAction : 'all',
		showSelectAll : true, 
		disabled : false ,
		queryMode:'remote',
		queryParam:'combotext',
		minChars:0
					
	});
	
	///定义病区
  var ComBoWardDs = new Ext.data.Store({
		autoLoad: true,
		proxy:new Ext.data.HttpProxy({url:URL+'?actiontype=GetWardDs', method:'GET'}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'WardID'},['WardDesc','WardID'])
				
	});
	
  var WardCombox = new Ext.form.ComboBox({
		fieldLabel:'病区',
		id:'WardCombo',
		name:'WardCombo',
		store : ComBoWardDs,
		width:200,
		listWidth : 200,
		emptyText:'选择病区...',
		hideOnSelect : false,
		maxHeight : 300,	
		valueField : 'WardID',
		displayField : 'WardDesc',
		triggerAction : 'all',
		showSelectAll : true, 
		disabled : false ,
		queryMode:'remote',
		queryParam:'combotext',
		minChars:0
					
	});
	
	var FindBt = new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format('Y-m-d');
			}else{
				Msg.info("error","请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format('Y-m-d');
			}else{
				Msg.info("error","请选择截止日期!");
				return false;
			}
			
			var PhaLocId = Ext.getCmp('PhaLocCombox').getValue();
			
			if((PhaLocId=="")||(PhaLocId.length==0)){
				Msg.info("warning","请先选择药房科室!");
				return false;
			}
			
			var WardId = Ext.getCmp('WardCombo').getValue();
			
			var strPar = startDate+"^"+endDate+"^"+PhaLocId+"^"+WardId ;
			InsulinMDs.removeAll();
			InsulinDDs.removeAll();
			pagingToolbar2.updateInfo();
			InsulinDDs.setBaseParam('StrPar',"");
			InsulinDDs.load({params:{start:0,limit:pagingToolbar2.pageSize}});
			InsulinMDs.setBaseParam('StrPar',strPar);
			InsulinMDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
			
		
		}
	});
	
	var InsulinMProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=mquery',method:'GET'});
	var InsulinMDs = new Ext.data.Store({
		proxy:InsulinMProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
		    {name:'pres'},
			{name:'warddesc'},
			{name:'incidesc'},
			{name:'accumqty'}
		]),
		remoteSort: false
	});


	var InsulinMCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{	
			header: 'rowid',
			dataIndex: 'pres',
			width: 100,
			hidden:true,
			align: 'left'
		},{
			header: '病区',
			dataIndex: 'warddesc',
			width: 200,
			sortable:true,
			align: 'left'
		},{
			header: '药品名称',
			dataIndex: 'incidesc',
			width: 200,
			sortable:true,
			align: 'left'
		},{
			header: "积累数",
			dataIndex: 'accumqty',
			width: 100,
			align: 'left',
			sortable: true
		}
	]);
	
		InsulinMDs.on('load',function(){
			if (InsulinMDs.getCount()>0){
				GridMain.getSelectionModel().selectFirstRow();
				GridMain.focus();
				GridMain.getView().focusRow(0);
			}
			
		})


	
	var pagingToolbar = new Ext.PagingToolbar({
		store:InsulinMDs,
		pageSize:30,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var GridMain = new Ext.grid.GridPanel({
		region:'center',
		store:InsulinMDs,
		cm:InsulinMCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar
	});
	
	
	var InsulinDProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryDetail',method:'GET'});
	var InsulinDDs = new Ext.data.Store({
		proxy:InsulinDProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'bustype'},
			{name:'busqty'},
			{name:'busavqty'},
			{name:'busdate'},
			{name:'bususer'}
		]),
		remoteSort: false
	});
	



	var InsulinDCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '业务类型',
			dataIndex: 'bustype',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '业务数量',
			dataIndex: 'busqty',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '保留结余数量',
			dataIndex: 'busavqty',
			width: 90,
			sortable:true,
			align: 'left'
		},{
			header: '业务日期',
			dataIndex: 'busdate',
			width: 130,
			sortable:true,
			align: 'left'
		},{
			header: "业务操作人",
			dataIndex: 'bususer',
			width: 80,
			align: 'right',
			sortable: true
		}
	]);
	var pagingToolbar2=new Ext.PagingToolbar({
					store:InsulinDDs,
					pageSize:20,
					displayInfo:true,
					displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
					emptyMsg:"没有记录"
			});
	
	var GridDetail = new Ext.grid.GridPanel({
		region:'south',
		store:InsulinDDs,
		cm:InsulinDCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask: true,
		height:225,
		bbar:pagingToolbar2
	});

		GridMain.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
		GridDetail.removeAll();
		var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format('Y-m-d');
			}else{
				Msg.info("error","请选择起始日期!");
				return false;
			}
		var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format('Y-m-d');
			}else{
				Msg.info("error","请选择截止日期!");
				return false;
			}
		
		pres =  InsulinMDs.data.items[rowIndex].data["pres"];
		var StrPar=startDate+"^"+endDate+"^"+pres
		//alert("StrPar:"+StrPar)
		
		InsulinDDs.setBaseParam('StrPar',StrPar);
		InsulinDDs.load({params:{start:0,limit:pagingToolbar2.pageSize}});
	/*	*/
	});
	
	var HisListTab = new Ext.form.FormPanel({
					labelwidth : 30,
					labelAlign : 'right',
					frame : true,
					title:'保留药累计查询',
					autoScroll : false,
					//bodyStyle : 'padding:0px 0px 0px 0px;',					
					tbar : [FindBt],
					items:[{
						xtype:'fieldset',
						title:'查询条件',
						layout: 'column',    
						style:'padding:10px;',
						items : [{ 				
							columnWidth: 0.25,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	
			            	defaultType: 'textfield',
			            	autoHeight: true,
			            	border: false,
			            	items: [startDate]
							
						},{ 				
							columnWidth: 0.25,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	
			            	defaultType: 'textfield',
			            	autoHeight: true,
			            	border: false,
			            	items: [endDate]
							
						},{ 				
							columnWidth: 0.25,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	  
			            	defaultType: 'textfield',
			            	autoHeight: true,
			            	border: false,
			            	items: [WardCombox]
							
						},{ 				
							columnWidth: 0.25,
			            	xtype: 'fieldset',
			            	labelWidth: 60,	 
			            	defaultType: 'textfield',
			            	autoHeight: true,
			            	border: false,
			            	items: [PhaLocCombox]
							
						}]
						
					}]
				});
	
	
	// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [           
			            {
			                region: 'north',
			                height: 150, 
			                layout: 'fit', 
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '病区',			               
			                layout: 'fit', 
			                items: GridMain       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '保留药累计明细',
			                layout: 'fit', 
			                items: GridDetail       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});

var loctype=tkMakeServerCall("web.DHCSTPHQUERYINSULIN","GetLocType",logonloc)
	
SetLogonPha = function(store, CmpName) {
	// 药房设置默认值 
	var rowId = session['LOGON.CTLOCID'];
	var name = App_LogonLocDesc ;
	var defaultData = { 
		PhaLocID : rowId,
		PhaLocDesc : name
	};
	var record = new store.recordType(defaultData);
	store.add(record);
	Ext.getCmp(CmpName).setValue(rowId);
};	

SetLogonWard = function(store, CmpName) {
	// 病区设置默认值 
	var rowId = session['LOGON.WARDID'];
	var name = App_LogonLocDesc ;
	var defaultData = { 
		WardID : rowId,
		WardDesc : name
	};
	var record = new store.recordType(defaultData);
	store.add(record);
	Ext.getCmp(CmpName).setValue(rowId);
};
	if (loctype=="W") {
		SetLogonWard(ComBoWardDs,'WardCombo') ; 
		//SetLogonPha(ComBoPhaLocDs,'PhaLocCombox') ; 
		WardCombox.setDisabled(true);
		//PhaLocCombox.setDisabled(true);
		}
	if (loctype=="D") {
		SetLogonPha(ComBoPhaLocDs,'PhaLocCombox') ; 
		}
	
	
})