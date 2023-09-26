 function MCSAItmList(mcsa)
{
	 // //查询函数
	 function Query(){    
		 saItmListStore.setBaseParam('mcsa',mcsa);
		 saItmListStore.removeAll();
		 
		 var Page=saItmListPagingToolbar.pageSize;
		 saItmListStore.load({
			 callback:function(r,options,success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				 }else{if(r.length>0){ }}
			 }	 
		 });
	}          

	// 访问路径
	var url ='dhcstm.itmmanfcertsaaction.csp?actiontype=mcsaItmList';
	var proxy = new Ext.data.HttpProxy({
		url : url,
		method : "POST"
	});
	
	// 指定列参数
	var fields = [ "inci", "code","desc", "uomDesc", "spec","manf", "rp","sp", "remark"];
	
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "rowid",
		fields : fields
	});
			
	// 数据集
	var saItmListStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	
	var nm = new Ext.grid.RowNumberer();
	var chkSm=new Ext.grid.CheckboxSelectionModel({});
	var saItmListCm = new Ext.grid.ColumnModel([nm,chkSm,
		{
			header : "物资RowId",
			dataIndex : 'inci',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'code',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'desc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : "规格",
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "单位",
			dataIndex : 'uomDesc',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "进价",
			dataIndex : 'rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "售价",
			dataIndex : 'sp',
			width : 60,
			align : 'right',
			sortable : true
		}
	]);
			
	var saItmListPagingToolbar = new Ext.PagingToolbar({
		store:saItmListStore,
		pageSize:999,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});

	var saItmListGrid = new Ext.grid.GridPanel({
		id : 'mcsaItmListGrid',
		region : 'center',
		// title : '列表',
		cm : saItmListCm,
		store : saItmListStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:saItmListPagingToolbar,
		// sm : new Ext.grid.RowSelectionModel({singleSelect:true})
		sm:chkSm
			
	});
	
	var addItm=new Ext.Toolbar.Button({
		text:'增加物资到链',
		iconCls:'page_add',
		handler:function(){
			SelectItmToAdd(addItmToSa);
		}	
	});
	var changeSaButton=new Ext.Toolbar.Button({
		text:'更换链',
		iconCls:'page_gear',
		handler:function(){
			changeSa(changeSaOfItm);
		}
		
	}); 
	
	function addItmToSa(inciS)
	{
		if (mcsa=="") return;
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=changeSaOfItm',
			params:{inciS:inciS,sa:mcsa},
			method:'POST',
			success:function()
			{
				Msg.info('success','添加成功！');
				Ext.getCmp('mcsaItmListGrid').getStore().reload();		
				
			},
			failure:function(){}
		})
	}
	
	function changeSaOfItm(sa)
	{
		if (sa=="") return;
		var sm=Ext.getCmp('mcsaItmListGrid').getSelectionModel();
		var arr=sm.getSelections();
		if (arr.length<1)
		{
			Msg.info('error','请选择!');
			return;
		}
		var inciS="";
		for (var i=0;i<arr.length;i++)
		{
			 var r=arr[i];
			var inci=r.get('inci');
			
			if (inciS=="")	{inciS=inci;}
			else { inciS=inciS+"^"+inci;}
		}
		if (inciS==""){Msg.info('error','请选择!');
			return;}
		
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=changeSaOfItm',
			params:{inciS:inciS,sa:sa},
			method:'POST',
			success:function()
			{
				Msg.info('success','更换成功！');
				Ext.getCmp('mcsaItmListGrid').getStore().reload();			
			},
			failure:function(){}
			
		})
		
	}
	
	var closeWin=new Ext.Toolbar.Button({
		text:'关闭',
		iconCls:'page_delete',
		handler:function(){
			Ext.getCmp('saItmListWin').close();
		}
		
	});
	
	var saItmListWin=new Ext.Window({
		title:'供货品种列表',
		id:'saItmListWin',
		width:950,
		height:560,
		minWidth:700,
		minHeight:500,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		tbar:[addItm,'-',changeSaButton,'-',closeWin],
		items:[saItmListGrid],
		resizable:false,
		listeners:{
		'show':function(){
			
			Query();
			
			}	
			
		}
	});
	if (saItmListWin) {
		saItmListWin.show();
	}
	
}

