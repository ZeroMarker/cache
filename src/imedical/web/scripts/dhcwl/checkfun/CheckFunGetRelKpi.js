(function(){
Ext.ns("dhcwl.checkfun.CheckFunGetRelKpi")
})();
dhcwl.checkfun.CheckFunGetRelKpi=function(setId){
	var parentWin=null;
	this.setId=setId;
	var serviceUrl="dhcwl/checkfun/checkfunvalueservice.csp";
	var columnModel=new Ext.grid.ColumnModel([
	{header:'ID',dataIndex:'ID',sortable:true,width:50,sortable:true},
	{header:'考核指标编码',dataIndex:'kpiCode',sortable:true,width:120,sortable:true},
	{header:'考核指标描述',dataIndex:'kpiDesc',sortable:true,width:160,sortable:true}
	]);
	var kpiStore=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=list-relKpiItem&setId='+setId}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNums',
			root:'root',
			fields:[
			{name:'ID'},
			{name:'kpiCode'},
			{name:'kpiDesc'}
			]
		})
	});
	kpiStore.load();
	var kpiValueGrid=new Ext.grid.EditorGridPanel({
		//title:'考核指标',
		id:kpiValueGrid,
		height:360,
		width:430,
		frame:true,
		store:kpiStore,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines:true,
		tbar:new Ext.Toolbar(
		
		  /*
		  [
		{text:'选 中',
			handler:function(){
				var sm=kpiValueGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行数据");
					return;
				}
				var ID=record.get("ID");
				var name=record.get("kpiDesc");
				var kpiform=parentWin.getPresentValueForm();
			    kpiform.getForm().findField('setkpiId').setValue(ID);
			    kpiform.getForm().findField('setkpiDesc').setValue(name);
			    //kpiItemWin.hide();
			    kpiItemWin.close();
				
			}
		},'-',
         {text:'    '},'按条件搜索',{
         
         	xtype : 'compositefield',
        	anchor: '-20',
       	 	msgTarget: 'side',
       	 	items :[{
       	 		id:'searchCond',
	        	width: 70,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'请选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'Code',   value: '编码'},
	                	{name : 'Name',  value: '描述'}
	             	]}),
         		listeners:{
         		'select':function(combo){
         				choicedSearcheCond=combo.getValue();
         			}
         		}
         		},{
         			xtype:'textfield',
         			width:200,
         			flex:1,
         			id:'searcheContValue',
         			enableKeyEvents:true,
         			allowBlank:true,
         			listeners:{
         				'keypress':function(ele,event){
         					searcheValue=Ext.get("searcheContValue").getValue();
         					if((event.getKey()==event.ENTER)){
         						kpiStore.proxy.setUrl(encodeURI(serviceUrl+'?action=list-relKpiItem&setId='+setId+'&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue));
	            				kpiStore.load();
         					}
         					
         				}
         			}
         		}
         		]
         	}
         ]
         */
		{
			layout:'hbox',
			items:[
				{text: '<span style="line-Height:1">选中</span>',
icon   : '../images/uiimages/ok.png',
			handler:function(){
				var sm=kpiValueGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行数据");
					return;
				}
				var ID=record.get("ID");
				var name=record.get("kpiDesc");
				var kpiform=parentWin.getPresentValueForm();
			    kpiform.getForm().findField('setkpiId').setValue(ID);
			    kpiform.getForm().findField('setkpiDesc').setValue(name);
			    //kpiItemWin.hide();
			    kpiItemWin.close();
				
			}
		},'-',
         {text:'    '},'搜索条件',
         {
         	id:'searchCond',
	        	width: 90,
				xtype:'combo',
	        	mode:'local',
	        	emptyText:'选择搜索类型',
	        	triggerAction:  'all',
	        	forceSelection: true,
	        	editable: false,
	        	displayField:'value',
	        	valueField:'name',
	        	store:new Ext.data.JsonStore({
	        		fields:['name', 'value'],
	            	data:[
	            		{name : 'Code',   value: '编码'},
	                	{name : 'Name',  value: '描述'}
	             	]}),
         		listeners:{
         		'select':function(combo){
         				choicedSearcheCond=combo.getValue();
         			}
         		}
         		},{
         			xtype:'textfield',
         			width:100,
         			flex:1,
         			id:'searcheContValue',
         			enableKeyEvents:true,
         			allowBlank:true,
         			listeners:{
         				'keypress':function(ele,event){
         					searcheValue=Ext.get("searcheContValue").getValue();
         					if((event.getKey()==event.ENTER)){
         						kpiStore.proxy.setUrl(encodeURI(serviceUrl+'?action=list-relKpiItem&setId='+setId+'&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue));
	            				kpiStore.load();
         					}
         					
         				}
         			}
         }
			]
		}
         )
	})
	var kpiItemWin=new Ext.Window({
		title:'考核指标',
		id:'dhcwl_checkfun_checkfungetkpi',
		//layout:'table',
		//layoutConfig:{columns:1},
		width:430,
		height:400,
		modal:true,
		resizable:false,
			layout:'fit',
			items:kpiValueGrid

	});
	this.showkpiItemWin=function(){
		this.showData();
		kpiItemWin.show();
	}
	this.showData=function(){
		kpiValueGrid.show();
	}
	this.getkpiStore=function(){
		return kpiStore;
	}
	this.gethiskpiGrid=function(){
    	return kpiValueGrid;
	}
	this.show=function(){
		kpiItemWin.show();
		kpiValueGrid.show();
		kpiStore.proxy.setUrl(encodeURI('dhcwl/checkfun/checkfunvalueservice.csp?action=list-relKpiItem&setId='+setId));
	}
	this.setParentWin=function(win){
		parentWin=win;
		kpiItemWin.show();
	}
}