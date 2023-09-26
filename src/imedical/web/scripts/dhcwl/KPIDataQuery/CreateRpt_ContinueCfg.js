(function(){
	Ext.ns("dhcwl.KDQ.CreateRptContinueCfg");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.CreateRptContinueCfg=function(){
	var serviceUrl="dhcwl/kpidataquery/createrpt.csp";
	var outThis=this;
	var parentObj=null;
	var dimCodes;
	var inParam;

	

	///////////////////////////////////////////////////////////////////////////////////////////
	////已选的角色或属性
		
	var selectedCml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'编码',dataIndex:'code',sortable:true, width: 150},
			{header:'描述',id:'descript',dataIndex:'descript',sortable:true, width: 100},
			/*
			{header:'统计项',xtype: 'checkcolumn',dataIndex:'isStatItem',sortable:true, width: 80},
			{header:'查询项',xtype: 'checkcolumn',dataIndex:'isSearchItem',sortable:true, width: 80}
			*/
			{header:'统计项',dataIndex:'isStatItem',sortable:true, width: 80},
			{header:'查询项',dataIndex:'isSearchItem',sortable:true, width: 80}

		]
	});

    var selectedStoreData = [];	
    var selectedStore = new Ext.data.ArrayStore({
		autoDestroy: true,
        fields: [
			{name: 'code'},
			{name: 'descript'},
			{name:'isStatItem'},
			{name:'isSearchItem'},
			{name:'type'}
        ]
    });	
	
    var selectedGrid = new Ext.grid.EditorGridPanel({
        //height:480,
		title:'已选统计项或查询项-维度',
		//layout:'fit',
        store: selectedStore,
        cm: selectedCml,
		autoExpandColumn: 'descript',
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false})
	});
	selectedStore.loadData(selectedStoreData);
	
	///////////////////////////////////////////////////////////////////////////////////////
	/////可选指标
	var optionalKPIStore = new Ext.data.Store({
 		proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getOptionalKPI'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'code'},
				{name:'descript'},
				{name:'roles'}
			]
    	})
    });
	
	var optionalKPICml = new Ext.grid.ColumnModel({
		default:{
			sortable: true,
			menuDisabled : true
		},
		columns:[
			{header:'编码',dataIndex:'code',width: 150},
			{header:'描述',id:'descript',dataIndex:'descript',width: 100},
			{header:'角色',dataIndex:'roles',width: 80}
		]
	});
	
	var businessTool2=new Ext.Toolbar({
			items : [		
			"业务类型：",
			{
				allowBlank:false,
				width:80,
				xtype:'combo',
				id:'ComboBusiness2',
				triggerAction:  'all',
				editable: false,
				displayField:   'Descript',
				valueField:     'Code',
				store:new Ext.data.Store({
						proxy: new Ext.data.HttpProxy({url:serviceUrl+"?action=getBusinessType"}),
						reader: new Ext.data.JsonReader({
							totalProperty: 'totalNum',
							root: 'root',
							fields:[
								{name: 'Descript'},
								{name: 'Code'}
							]
						})
					}),	
				mode:           'remote',
				triggerAction:  'all',
                typeAhead: true,
				listeners:{
					'beforeselect':function(combo,record,index) {
						var oldComboBusiness=getBusinessType();
						var businessCode=record.get('Code');
						if (oldComboBusiness!=businessCode) {

						}	
						reloadOptionalKPI(businessCode);						
					}
				}				
			}]	
		})
	
	
   var optionalKPIGrid = new Ext.grid.GridPanel({
        //height:480,
		title:'待选统计项-度量',
		//layout:'fit',
        store: optionalKPIStore,
        cm: optionalKPICml,
		autoExpandColumn: 'descript',
		stripeRows: true,
		view:new Ext.grid.GridView({markDirty:false})
	});	
	
	function reloadOptionalKPI(inbType) {
		var businessType="";
		if (!!inbType) businessType=inbType;
		else businessType=getBusinessType();
		
		optionalKPIStore.setBaseParam("dimCodes",dimCodes);
		optionalKPIStore.setBaseParam("businessType",businessType);
		optionalKPIStore.setBaseParam("selectedKpis",inParam.selectedKpis);
		optionalKPIStore.reload();
	}
	
	var continuePanel = new Ext.Panel({   
		layout:'border',
		defaults: {
			collapsible: true,
			split: true//,
			//bodyStyle: 'padding:5px'
		},
		tbar:businessTool2,
		items: [{
			collapsible: false,
			region:'center',

			layout:'vbox',
			layoutConfig: {
				align : 'stretch',
				pack  : 'start',
			},
			items: [
				{
					flex:1,
					layout:'fit',
					items:selectedGrid
				},
				{
					flex:1,
					layout:'fit',
					items:optionalKPIGrid
				}
			]
		}]
	})	
	
	function getBusinessType() {
		return Ext.getCmp("ComboBusiness2").getValue();
	};
	
	this.getBusinessType=function() {
		return getBusinessType();
	}
	
	this.getContinueCfgPanel=function() {
		return continuePanel;
	}
	
	this.updateCtnPanelData=function(param) {
		Ext.getCmp("ComboBusiness2").setValue("");
		optionalKPIStore.removeAll();
		dimCodes=param.roles;
		selectedStore.removeAll();
		selectedStore.add(param.arySelRec);
		inParam=param;
	}
}

