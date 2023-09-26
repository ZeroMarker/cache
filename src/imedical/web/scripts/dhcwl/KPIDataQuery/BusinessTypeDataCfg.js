(function(){
	Ext.ns("dhcwl.KDQ.BusinessTypeDataCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.BusinessTypeDataCfg=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/businesstypedatacfg.csp";
	var outThis=this;
	var qryParam=new Object();
	
	
	var BTCfgCm = new Ext.grid.ColumnModel({
		defaults: {
                width: 100,
                sortable: false
        },
        columns: [
			{header: '编码',dataIndex: 'code',width: 150}, 
			{header: '描述',dataIndex: 'descript',width: 180},
			{header: '备注',dataIndex: 'remarks',id :'remarks',width: 180}
			]
	})	
	
	var BTCfgStore=new Ext.data.Store({
		reader:new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'id'},
				{name:'code'},
				{name:'descript'},
				{name:'remarks'}
			]
    	}),
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getBTData&'})
	})

    var BTCfgGrid = new Ext.grid.GridPanel({
		title:'业务类型',
        store: BTCfgStore,
        cm: BTCfgCm,
		autoExpandColumn: 'remarks',
        viewConfig: {
			forceFit: true
		},
		tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : [	
					{
						text: '<span style="line-Height:1">增加</span>',
						icon   : '../images/uiimages/edit_add.png',	
						xtype:'button',
						handler:OnAddBT
					},{
						id: 'removeBTBtn',
						text: '<span style="line-Height:1">删除</span>',
						icon   : '../images/uiimages/edit_remove.png',
						xtype:'button',
						disabled: true,
						handler:OnDelBT
					},{
						id: 'cleanGarbageBtn',
						text: '<span style="line-Height:1">垃圾数据清理</span>',
						icon   : '../images/uiimages/clearscreen.png',
						xtype:'button',
						disabled: true,
						handler:OnCleanGarbage
					},{
						xtype:'spacer',
						flex:1
					},	
					'查询值:',
					{
						id:'BtSearchV',
						xtype:'textfield',						
						width:50
					},"-",{
						text: '<span style="line-Height:1">查询</span>',
						icon   : '../images/uiimages/search.png',	
						xtype:'button',
						handler:OnSearchBT
					},	
					"-",
					{
						text: '<span style="line-Height:1">清空</span>',					
						icon   : '../images/uiimages/clearscreen.png',
						xtype:'button',
						handler:OnResetCondBT			
		}]}),
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:BTCfgStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
    });	

	var KPICm = new Ext.grid.ColumnModel({
		defaults: {
                width: 180,
                sortable: false
        },
        columns: [
			{header: '编码',dataIndex: 'code',width: 150}, 
			{header: '名称',dataIndex: 'name'},
			{header: '描述',dataIndex: 'descript',id :'descript'},
			{header: '类型',dataIndex: 'type'},
			{header: '维度',dataIndex: 'kpiDim'},
			{header: '区间',dataIndex: 'sec'},
			{header: '创建者 ',dataIndex: 'author'}
			]
	})	
	
	var KPIStore=new Ext.data.Store({
		reader:new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'code'},
				{name:'name'},
				{name:'descript'},
				{name:'type'},
				{name:'kpiDim'},
				{name:'sec'},				
				{name:'author'}				
			]
    	}),
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getKPIByBT'})
	})

    var KPIGrid = new Ext.grid.GridPanel({
		title:'指标',
        store: KPIStore,
        cm: KPICm,
		//autoExpandColumn: 'remarks',
        viewConfig: {
			forceFit: true
		},
		tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : 
					
					[
					{
						text: '<span style="line-Height:1">增加</span>',
						icon   : '../images/uiimages/edit_add.png',	
						xtype:'button',
						handler:OnAddKPI
					},{
						id: 'removeKPIBtn',
						text: '<span style="line-Height:1">删除</span>',
						icon   : '../images/uiimages/edit_remove.png',
						xtype:'button',
						disabled: true,
						handler:OnDelKPI
					},{
						xtype:'spacer',
						flex:1
					},						
					'查询值:',
					{
						id:'KPISearchV',
						xtype:'textfield',
						width:50
					},"-",{
						text: '<span style="line-Height:1">查询</span>',
						icon   : '../images/uiimages/search.png',	
						xtype:'button',
						handler:OnSearchKPI
					},	
					"-",
					{
						text: '<span style="line-Height:1">清空</span>',					
						icon   : '../images/uiimages/clearscreen.png',
						xtype:'button',
						handler:OnResetCondKPI			
		}]
		})
		,		
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:KPIStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
    });		
	

	

	var showStatPanel=new Ext.Panel({
		title:'业务类型配置',
		layout:'border',	
		defaults: {
		    split: true
		},
		closable:true,
		items: [
		{
		    region:'center',
	        //width: 900,
		    items:BTCfgGrid,
			split: true,
			layout:'fit'
						
		},{
			width: 700,
		    region:'east',
		    items:KPIGrid,
			layout:'fit'
			
		}]		
    });

	
	var addBTForm=new Ext.FormPanel({
		labelWidth: 60, 
		labelAlign : 'right',
        frame:true,
		border:true,		
		items:[{
			anchor: '98%',
			fieldLabel :'<span style="line-Height:1">编码</span>',
			name:'code',
			xtype:'textfield'
		},{
			anchor: '98%',
			fieldLabel:'<span style="line-Height:1">描述</span>',
			name:'descript',
			xtype:'textfield'
		},{
			anchor: '98%',
			fieldLabel:'<span style="line-Height:1">备注</span>',
			name :'remarks',
			xtype:'textarea'
		}]
	})
	
	/////////////////////////////////////////////////
	//新增业务类型窗口
	var addBTWin=new Ext.Window({
		width:300,
		height:200,
		resizable:false,
		closable : false,
		//closeAction:'close' ,
		closeAction:'hide',
		title:'新增业务类型',
		modal:true,
		items:addBTForm ,		
		layout:'fit',
		buttons: [
		{
			text: '<span style="line-Height:1">保存</span>',				
			icon   : '../images/uiimages/filesave.png',
			handler:OnAddBTData			
		},{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: OnCloseBTWins
		}]
		//autoScroll :true,		
	});
	
	
	
	
	/////////////////////////////////////////////////
	//新增指标窗口
	var sm = new Ext.grid.CheckboxSelectionModel({
        listeners: {
            rowselect: function(sm, rowIndex, rec) {
				var insData = {
					code: rec.get('code'),
					descript: rec.get('descript')
				};
				var p = new preSelKPIStore.recordType(insData); // create new record
				preSelKPIStore.add(p);
            },
            rowdeselect: function(sm, rowIndex, rec) {
				var inx=preSelKPIStore.find("code",rec.get("code"));
				preSelKPIStore.removeAt(inx);
            },			
        }		
	});
	var optionalKPICm = new Ext.grid.ColumnModel({
		defaults: {
                width: 180,
                sortable: false
        },
        columns: [
			sm,
			{header: '编码',dataIndex: 'code',width: 150}, 
			{header: '名称',dataIndex: 'name'},
			//{header: '描述',dataIndex: 'descript',id :'adddescript'},
			{header: '类型',dataIndex: 'type'},
			{header: '维度',dataIndex: 'kpiDim'},
			{header: '区间',dataIndex: 'sec',width: 80},
			{header: '创建者 ',dataIndex: 'author',width: 80}
			]
	})	
	
	var optionalKPIStore=new Ext.data.Store({
		reader:new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'code'},
				{name:'name'},
				{name:'descript'},
				{name:'type'},
				{name:'kpiDim'},
				{name:'sec'},				
				{name:'author'}				
			]
    	}),
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=getAllUncollectKPI'})
	})

    var optionalKPIGrid = new Ext.grid.GridPanel({
		title:'可选指标',
        store: optionalKPIStore,
        cm: optionalKPICm,
		sm: sm,
		viewConfig: {
			forceFit: true
		},
		tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : [
					'查询值:',
					{
						id:'optionalKPISearchV',
						xtype:'textfield',
						width:50
					},"-",{
						text: '<span style="line-Height:1">查询</span>',
						icon   : '../images/uiimages/search.png',	
						xtype:'button',
						handler:OnSearchUncollectKPI
					},	
					"-",
					{
						text: '<span style="line-Height:1">清空</span>',					
						icon   : '../images/uiimages/clearscreen.png',
						xtype:'button',
						handler:OnResetUncollectKPI			
		}]}),		
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:optionalKPIStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
    });			
	
	var preSelKPIStoreData = [];	
    var preSelKPIStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
			{name: 'code'},
			{name: 'descript'}
        ]
    });
	
	var preSelKPICm = new Ext.grid.ColumnModel({
        columns: [{
            header: '编码',
            dataIndex: 'code'
        }, {
            header: '描述',		
            dataIndex: 'descript'
        }]
	})		

    var preSelKPIGrid = new Ext.grid.GridPanel({
		title:'已选指标',
		//border:false,
        store: preSelKPIStore,
        stripeRows: true,
		cm: preSelKPICm,
		view:new Ext.grid.GridView({markDirty:false})
    });	
	
	preSelKPIStore.loadData(preSelKPIStoreData);

	
	var addKPIWin=new Ext.Window({
		width:800,
		height:500,
		resizable:false,
		closable : false,
		closeAction:'hide',
		title:'新增指标',
		modal:true,
		layout:'hbox',
		layoutConfig: {
			align : 'stretch',
			pack  : 'start',
		},
		items:[  
			{  
				flex:7, 
				layout:'fit',
				items:optionalKPIGrid
			},{
				flex:3, 
				layout:'fit',
				items:preSelKPIGrid
			}],			

		buttons: [
		{
			text: '<span style="line-Height:1">保存</span>',				
			icon   : '../images/uiimages/filesave.png',
			handler:OnAddKPIData			
		},{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: OnCloseKPIWins
		}]
		//autoScroll :true,		
	})	
	
	////////////////////////////////////////
	//事件处理
	
	BTCfgGrid.on('rowdblclick',function(Grid, rowIndex,e ){
		Ext.getCmp("KPISearchV").setValue("");
		OnSearchKPI();
		
	})
	
	BTCfgGrid.on('afterrender',function(Grid){
		BTCfgGrid.getStore().setBaseParam("searchV","");
		BTCfgGrid.getStore().reload({params:{start:0,limit:50}});
	});

	/*
	optionalKPIGrid.on('activate',function(comp){
		optionalKPIGrid.getStore().setBaseParam("searchV","");
		optionalKPIGrid.getStore().reload({params:{start:0,limit:50}});
	});	 	
	*/
	
	
	
	optionalKPIStore.on('load',function(store, records,options){
		sm.suspendEvents(false);
		for(var i=0;i<preSelKPIStore.getCount();i++){
			var preCode=preSelKPIStore.getAt(i).get("code");
			for(var j=0;j<optionalKPIStore.getCount();j++) {
				if (preCode==optionalKPIStore.getAt(j).get("code")) {
					sm.selectRow(j,true);
				}
			}
		}
		sm.resumeEvents();
	})

	KPIGrid.getSelectionModel().on('selectionchange', function(sm){
		Ext.getCmp("removeKPIBtn").setDisabled(sm.getCount() < 1);
		//KPIGrid.removeKPIBtn.setDisabled(sm.getCount() < 1);
    });
	
	
	BTCfgGrid.getSelectionModel().on('selectionchange', function(sm){
		Ext.getCmp("removeBTBtn").setDisabled(sm.getCount() < 1);		
		Ext.getCmp("cleanGarbageBtn").setDisabled(sm.getCount() < 1);
    });
	/////////////////////////////////////////////////////////////////////////////////////////
	//响应函数
	function OnAddBTData() {
		if (!!addBTWin.CallBack) {
			var args={};
			args.code=addBTForm.getForm().findField('code').getValue();
			args.descript=addBTForm.getForm().findField('descript').getValue();
			args.remarks=addBTForm.getForm().findField('remarks').getValue();
			
			if (args.code.trim()=="") {
				Ext.Msg.alert("提示","请填写编码！");
				return ;
			}
			var pattern1=/[^a-zA-Z_0-9-]/;
			if(pattern1.test(args.code)) 
			{
				Ext.Msg.alert("提示","编码只能由 '字母'、'数字'、'-'或'_' 组成!");
				return ;
			}	
			var pattern2=/[@#$%&"'￥]/;			
			if(pattern2.test(args.descript)) 
			{
				Ext.Msg.alert("提示","描述字符不能包含：'#$%&\"\'￥");
				return ;
			}			
		
			if(pattern2.test(args.remarks)) 
			{
				Ext.Msg.alert("提示","备注字符不能包含：'#$%&\"\'￥");
				return ;
			}			
			addBTWin.CallBack(args);
		}		
	}

	
	function OnSearchBT() {
		var btSearchV=Ext.getCmp("BtSearchV").getValue();
		BTCfgGrid.getStore().setBaseParam("searchV",btSearchV);
		BTCfgGrid.getStore().reload({params:{start:0,limit:50}});
	}
	
	function OnResetCondBT() {
		Ext.getCmp("BtSearchV").setValue("");
		BTCfgGrid.getStore().setBaseParam("searchV","-clear-");
		BTCfgGrid.getStore().reload({params:{start:0,limit:50}});
		//BTCfgGrid.getStore().removeAll();
	}
	
	
	function OnCloseBTWins() {
		addBTForm.getForm().findField('code').setValue("");
		addBTForm.getForm().findField('descript').setValue("");
		addBTForm.getForm().findField('remarks').setValue("");
		addBTWin.hide();
	}	
	
	function OnSearchKPI() {
		
		var selRec=BTCfgGrid.getSelectionModel().getSelected();
		if (!selRec) {
			Ext.Msg.alert("提示","请先选择业务类型！");
			return;
		}
		var btCode=selRec.get('code');
		var searchV=Ext.getCmp("KPISearchV").getValue();
		KPIGrid.getStore().setBaseParam("searchV",searchV);
		KPIGrid.getStore().setBaseParam("BTCode",btCode);
		KPIGrid.getStore().reload({params:{start:0,limit:50}});		
		
	}
	
	function OnResetCondKPI() {
		Ext.getCmp("KPISearchV").setValue("");
		KPIGrid.getStore().setBaseParam("searchV","-clear-");
		KPIGrid.getStore().reload({params:{start:0,limit:50}});	
	}
	
	function OnAddBT() {
		addBTWin.show();
		addBTWin.CallBack=addBTData;
	}
	
	function addBTData(args){
		var action="AddBT";
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			code:args.code,
			descript:args.descript,
			remarks:args.remarks
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				OnCloseBTWins();
				//刷新
				refreshGrid(BTCfgGrid);
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);
	}
	
	function OnSearchUncollectKPI() {
		var selRec=BTCfgGrid.getSelectionModel().getSelected();
		if (!selRec) {
			Ext.Msg.alert("提示","请先选择业务类型！");
			return;
		}
		var btCode=selRec.get('code');		
		
		var searchV=Ext.getCmp("optionalKPISearchV").getValue();
		optionalKPIGrid.getStore().setBaseParam("searchV",searchV);
		optionalKPIGrid.getStore().setBaseParam("BTCode",btCode);
		optionalKPIGrid.getStore().reload({params:{start:0,limit:50}});				
	}
	function OnResetUncollectKPI() {
		Ext.getCmp("optionalKPISearchV").setValue("");
	}
	////////////////////////////////////////////////////////////////
	//新增指标窗口中BUTTON处理
	function OnAddKPI() {
		var selRec=BTCfgGrid.getSelectionModel().getSelected();
		if (!selRec) {
			Ext.Msg.alert("提示","请先选择业务类型！");
			return;
		}		
		addKPIWin.show();
		optionalKPIGrid.getStore().setBaseParam("searchV","");
		optionalKPIGrid.getStore().reload({params:{start:0,limit:50}});
		addKPIWin.CallBack=addKPIData;
		
	}
	
	function OnDelBT() {
    	Ext.MessageBox.confirm('确认', '确定删除吗？', function(id){
			if (id=="no") {
				return;               	
			}
				 
			var selRec=BTCfgGrid.getSelectionModel().getSelected();
			var btCode=selRec.get('code');	
			
			var action="DelBT";
			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:action,
				BTCode:btCode
			},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//刷新
					refreshGrid(BTCfgGrid);
					refreshGrid(KPIGrid);
				}else{
					Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);
		})		
	}
	
	function OnCleanGarbage() {
		
			var selRec=BTCfgGrid.getSelectionModel().getSelected();
			if (!selRec) {
				Ext.Msg.alert("提示","请先选择业务类型！");
				return;
			}
			var btCode=selRec.get('code');	
			var action="CleanGarbage";			
			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:action,
				BTCode:btCode
			},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//刷新
					Ext.Msg.alert("提示","清理已完成！");
				}else{
					Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);		
		
	};
	
	
	function OnDelKPI() {
    	Ext.MessageBox.confirm('确认', '确定删除吗？', function(id){
			if (id=="no") {
				return;               	
			}
				 
			var selRec=BTCfgGrid.getSelectionModel().getSelected();
			var btCode=selRec.get('code');	
			var selRec=KPIGrid.getSelectionModel().getSelected();
			var kpiCode=selRec.get('code');
			
			var action="DelKPI";
			dhcwl.mkpi.Util.ajaxExc(serviceUrl,
			{
				action:action,
				KPICode:kpiCode,
				BTCode:btCode
			},function(jsonData){
				if(jsonData.success==true && jsonData.tip=="ok"){
					//刷新
					refreshGrid(KPIGrid);
				}else{
					Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);
		})			
	
	}
	
	function addKPIData(args){
		
		var selRec=BTCfgGrid.getSelectionModel().getSelected();
		var btCode=selRec.get('code');	
		
		var action="AddKPIs";
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			codes:args.codes,
			BTCode:btCode
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				OnCloseKPIWins();
				//刷新
				refreshGrid(KPIGrid);
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);	
	}	
	
	function OnAddKPIData() {
		if (preSelKPIGrid.getStore().getCount()<=0) {
			Ext.Msg.alert("提示","已选指标列表为空，请选择指标！");
			return ;
			
		}
		
		if (!!addKPIWin.CallBack) {
			var args={};
			args.codes="";
			

			for(i=0;i<preSelKPIGrid.getStore().getCount();i++) {
				var code=preSelKPIGrid.getStore().getAt(i).get("code");
				if (args.codes=="") args.codes=code;
				else args.codes=args.codes+","+code;
			}
			addKPIWin.CallBack(args);
		}	
				
	}
	
	function OnCloseKPIWins() {
		/*
		addBTForm.getForm().findField('code').setValue("");
		addBTForm.getForm().findField('descript').setValue("");
		addBTForm.getForm().findField('remarks').setValue("");
		*/
		preSelKPIStore.removeAll();
		addKPIWin.hide();
	}
	
	function refreshGrid(grid) {
		if (!!grid.getBottomToolbar()) {
			grid.getBottomToolbar().doRefresh();  
		}else{
			grid.getStore().reload({params:{start:0,limit:50}});
		}

	}
	/*
---------------------------------------------------------------------------------------	

*/
	
	this.getBTPanel=function() {
		return showStatPanel;
		
	}


}

