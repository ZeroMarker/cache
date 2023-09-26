(function(){
Ext.ns("dhcwl.checkfun.ExcValueItem")
})();
dhcwl.checkfun.ExcValueItem=function(setId,historyId,id){
	var parentWin=null;
	this.setId=setId,this.historyId=historyId,this.id=id;
	var serviceUrl="dhcwl/checkfun/checkfunvalueservice.csp";
	var columnModel=new Ext.grid.ColumnModel([
	{header:'ID',dataIndex:'ID',sortable:true,width:50,sortable:true},
	{header:'历史值',dataIndex:'hValue',sortable:true,width:80,sortable:true},
	{header:'生效日期',dataIndex:'eDate',sortable:true,width:80,sortable:true},
	{header:'更新日期',dataIndex:'uDate',sortable:true,width:80,sortable:true},
	{header:'更新用户',dataIndex:'uUser',sortable:true,width:80,sortable:true}
	]);
	var hisStore=new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:serviceUrl+'?action=list-hisValue&setId='+setId+'&kpiId='+historyId+'&id='+id}),
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
		//title:'例外值复制',
		id:hisValueGrid,
		//height:360,
		//width:400,
		frame:true,
		store:hisStore,
		cm:columnModel,
		sm:new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		columnLines:true,
		tbar:new Ext.Toolbar([
		{text: '<span style="line-Height:1">复制</span>',
		icon   : '../images/uiimages/copy1.png',
			handler:function(){
				var sm=hisValueGrid.getSelectionModel();
				var record=sm.getSelected();
				if(!sm||!record){
					alert:("请选择一行来复制例外值");
					return;
				}
			Ext.Msg.confirm('信息','确定复制该历史值的例外值?', function(btn){
					if(btn=='yes'){
						var ID=record.get("ID");
						paraValues='ID='+ID+'&id='+id;
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=insertExcValue&'+paraValues);
						ExcValueItemWin.close();
						var store2=parentWin.getStoreExtValue();
						store2.proxy.setUrl(encodeURI(serviceUrl+'?action=mulSerchExValue&extraId='+id+'&setId='+setId));
						store2.reload();
					}
				});	
			}
		}
		])
		
	})
	var ExcValueItemWin=new Ext.Window({
		title:'例外值复制2',
		id:'ExcValueItemWin',
		//layout:'table',
		//layoutConfig:{columns:1},
		width:400,
		height:400,
		modal:true,
		resizable:false,
		layout:'fit',
		items:hisValueGrid
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