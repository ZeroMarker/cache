(function(){
Ext.ns("dhcwl.checkfun.CheckfunExcValueItem")
})();
dhcwl.checkfun.CheckfunExcValueItem=function(setId,kpiId,stId){
	var parentWin=null;
	this.setId=setId,this.kpiId=kpiId,this.stId=stId;
	var serviceUrl="dhcwl/checkfun/checkfunvalueservice.csp";
	var columnModel=new Ext.grid.ColumnModel([
	{header:'ID',dataIndex:'ID',sortable:true,width:50,sortable:true},
	{header:'标准值',dataIndex:'hValue',sortable:true,width:80,sortable:true},
	{header:'生效日期',dataIndex:'eDate',sortable:true,width:80,sortable:true},
	{header:'更新日期',dataIndex:'uDate',sortable:true,width:80,sortable:true},
	{header:'更新用户',dataIndex:'uUser',sortable:true,width:80,sortable:true}
	]);
	var hisStore=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=list-addStdValue&setId='+setId+'&kpiId='+kpiId+'&stId='+stId}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNums',
			root:'root',
			fields:[
			{name:'ID'},
			{name:'hValue'},
			{name:'eDate'},
			{name:'uDate'},
			{name:'uUser'}
			]
		})
	});
	hisStore.load();
	var hisValueGrid=new Ext.grid.EditorGridPanel({
		title:'例外值复制1',
		id:hisValueGrid,
		height:360,
		width:400,
		frame:true,
		store:hisStore,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines:true,
		tbar:new Ext.Toolbar([
		{
		text : '复制',
			icon   : '../images/uiimages/copy1.png',
			handler:function(){
				var sm=hisValueGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行来复制标准值");
					return;
				}
			Ext.Msg.confirm('信息','确定复制该标准值的例外值?', function(btn){
					if(btn=='yes'){
						var ID=record.get("ID");
						paraValues='ID='+ID+'&stId='+stId;
						//alert(paraValues);
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addInsertExcValue&'+paraValues);
						ExcValueItemWin.close();
						var store1=parentWin.getPresentStore();
						var prentGrid=parentWin.getPresentValueGrid();
						var store2=parentWin.getStoreExtValue();
						prentGrid.getStore().on({"load":{
						fn:function(){
							prentGrid.getSelectionModel().selectLastRow();
							var sm = prentGrid.getSelectionModel();
							var record=sm.getSelected();
        					//var valId=record.get('ID');
							var valId=stId;
        					//alert(valId);
        					store2.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&extraId='+valId+'&setId='+setId));
							store2.reload();
							}
						}});
						store1.reload();
					}
				});	
			}
		}
		])
		
	})
	var ExcValueItemWin=new Ext.Window({
		title:'例外值复制',
		id:'ExcValueItemWin',
		layout:'table',
		layoutConfig:{columns:1},
		width:400,
		height:400,
		modal:true,
		resizable:true,
		items:[{
			autoScroll:true,
			width:400,
			items:hisValueGrid
		}]
	});
	this.showExcValueItemWin=function(win){
		parentWin=win;
		this.showData();
		ExcValueItemWin.show();
		
	}
	this.showData=function(){
		hisValueGrid.show();
	}
	this.gethisStore=function(){
		return hisStore;
	}
	this.gethisValueGrid=function(){
    	return hisValueGrid;
	}	
}