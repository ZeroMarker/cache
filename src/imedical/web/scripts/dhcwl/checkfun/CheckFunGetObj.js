(function(){
Ext.ns("dhcwl.checkfun.CheckFunGetObj")
})
dhcwl.checkfun.CheckFunGetObj=function(setId){
	var parentWin;
    this.setId=setId;
    //alert(setId);
    //alert("进入");
	var serviceUrl="dhcwl/checkfun/checkfunvalueservice.csp";
	var columnModel=new Ext.grid.ColumnModel([
		{header:'ID',dataIndex:'ID',sortable:true,width:50,sortable:true},
		{header:'考核对象编码',dataIndex:'objCode',sortable:true,width:80,sortable:true,hidden:true},
		{header:'考核对象描述',dataIndex:'objDesc',sortable:true,width:100,sortable:true}
	]);
	var objStore=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=list-objItem&setId='+setId}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNums',
			root:'root',
			fields:[
			{name:'ID'},
			{name:'objCode'},
			{name:'objDesc'}
			]
		})
	});
	objStore.load();
	var objValueGrid=new Ext.grid.EditorGridPanel({
		title:'考核对象',
		id:objValueGrid,
		height:400,
		width:420,
		frame:true,
		store:objStore,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines:true,
		tbar:new Ext.Toolbar(
		/*
		[
		{text:'选 中',
			handler:function(){
				var sm=objValueGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行数据");
					return;
				}
				var ID=record.get("ID");
				var name=record.get("objDesc");
				var objform=parentWin.getExtraValueForm();
				objform.getForm().findField('objId').setValue(ID);
				objform.getForm().findField('objDesc').setValue(name);
				//objItemWin.hide();
				objItemWin.close();
			
			}
		},'-',
		{text:'  '},'按条件搜索',{
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
							objStore.proxy.setUrl(encodeURI(serviceUrl+'?action=list-objItem&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue+'&setId='+setId));
	            			objStore.load();
						}
					}
				}
			}]
			
		}
		]
		*/
		{	
			layout:'hbox',
			items:[
				{text: '<span style="line-Height:1">选中</span>',
				icon   : '../images/uiimages/ok.png',
			handler:function(){
				var sm=objValueGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行数据");
					return;
				}
				var ID=record.get("ID");
				var name=record.get("objDesc");
				var objform=parentWin.getExtraValueForm();
				objform.getForm().findField('objId').setValue(ID);
				objform.getForm().findField('objDesc').setValue(name);
				//objItemWin.hide();
				objItemWin.close();
			
			}
		},'-',
		{text:'  '},'搜索条件',
		{	
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
	            		/*{name : 'Code',   value: '编码'},*/
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
							objStore.proxy.setUrl(encodeURI(serviceUrl+'?action=list-objItem&searcheCond='+choicedSearcheCond+'&searcheValue='+searcheValue+'&setId='+setId));
	            			objStore.load();
						}
					}
				}
		}
			]
		}
		)
	})
	var objItemWin=new Ext.Window({
		title:'考核对象',
		id:'objItemWin',
		layout:'table',
		layoutConfig:{columns:1},
		width:430,
		height:400,
		modal:true,
		resizable:true,
		items:[{
			autoScroll:true,
			
			items:objValueGrid
		}]
		
	});
	this.showobjItemWin=function(){
		//this.setId=setId;
		this.showData();
		objItemWin.show();
		objStore.proxy.setUrl(encodeURI('dhcwl/checkfun/checkfunvalueservice.csp?action=list-objItem&setId='+setId));
	}
	this.showData=function(){
		objValueGrid.show();
	}
	this.getobjStore=function(){
		return objStore;
	}
	this.getobjValueGrid=function(){
		return objValueGrid;
	}
	this.setParentWin=function(win){
		parentWin=win;
		objItemWin.show();
		
	}
	this.show=function(){
		objItemWin.show();
		objValueGrid.show();
		objStore.proxy.setUrl(encodeURI('dhcwl/checkfun/checkfunvalueservice.csp?action=list-objItem&setId='+setId));
	}
	
	
}