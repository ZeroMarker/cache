(function(){
Ext.ns("dhcwl.checkfun.CheckFunGetEDate")
})();
dhcwl.checkfun.CheckFunGetEDate=function(setId){
	var parentWin=null;
	this.setId=setId;
	var serviceUrl="dhcwl/checkfun/checkfunvalueservice.csp";
	var columnModel=new Ext.grid.ColumnModel([
	{header:'ID',dataIndex:'ID',sortable:true,width:120,sortable:true},
	{header:'生效日期',dataIndex:'eDate',sortable:true,width:160,sortable:true}
	]);
	var eDateStore=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=list-eDate&setId='+setId}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNums',
			root:'root',
			fields:[
			{name:'ID'},
			{name:'eDate'}
			]
		})
	});
	eDateStore.load();
	var dateGrid=new Ext.grid.EditorGridPanel({
		//title:'生效日期',
		id:dateGrid,
		height:360,
		width:398,
		frame:true,
		store:eDateStore,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines:true,
		tbar:new Ext.Toolbar(
		/*[
			{text:'选 中',
			handler:function(){
				var sm=dateGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行数据");
					return;
				}
				var ID=record.get("ID");
				var name=record.get("eDate");
				var kpiform=parentWin.getPresentValueForm();
				kpiform.getForm().findField('eDate').setValue(name);
				eDateWin.close();
				}
			},'-',
			{
				text:' '
			},'按条件搜索',{
			
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
	                	{name : 'Name',  value: '描述'}
	             	]
	        		}),
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
         							eDateStore.proxy.setUrl(encodeURI(serviceUrl+'?action=list-eDate&setId='+setId+'&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue));
	            				 	eDateStore.load();
         						}
         				}
         			}
       	 		}]
			}
		]*/
		{
			layout:'hbox',
			items:[
					{text: '<span style="line-Height:1">选中</span>',
icon   : '../images/uiimages/ok.png',
			handler:function(){
				var sm=dateGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行数据");
					return;
				}
				
				var ID=record.get("ID");
				var name=record.get("eDate");
				var kpiform=parentWin.getPresentValueForm();
				kpiform.getForm().findField('eDate').setValue(name);
				eDateWin.close();
				}
			},'-',
			{
				text:' '
			},'搜索条件',
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
	                	{name : 'Name',  value: '生效日期'}
	             	]
	        		}),
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
         							eDateStore.proxy.setUrl(encodeURI(serviceUrl+'?action=list-eDate&setId='+setId+'&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue));
	            				 	eDateStore.load();
         						}
         				}
         			}
       	 		
			}
			
					
			]
		
		})
	});
	var eDateWin=new Ext.Window({
		title:'生效日期',
		id:'dhcwl_checkfun_checkfungetDate',
		layout:'table',
		layoutConfig:{columns:1},
		width:430,
		height:400,
		modal:true,
		resizable:false,
		layout:'fit',
		items:dateGrid
		
	});
	this.showEDateWin=function(){
		this.showData();
		eDateWin.show();
	}
	this.showData=function(){
		dateGrid.show();
	}
	this.getEDateStore=function(){
		return eDateStore;
	}
	this.gethisEDateGrid=function(){
    	return dateGrid;
	}
	this.show=function(){
		eDateWin.show();
		dateGrid.show();
		eDateStore.proxy.setUrl(encodeURI('dhcwl/checkfun/checkfunvalueservice.csp?action=list-eDate&setId='+setId));
	}
	this.setParentWin=function(win){
		parentWin=win;
		eDateWin.show();
	}
}