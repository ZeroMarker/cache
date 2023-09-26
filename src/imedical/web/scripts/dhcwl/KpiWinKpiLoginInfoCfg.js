dhcwl.mkpi.KpiWinKpiLoginInfoCfg = function(kpiCode){
	
	var mkpiCode="";
	var serviceUrl="dhcwl/kpi/kpilogininfocfg.csp";

	//	自定义插件Ext.grid.CheckColumn
	Ext.grid.CheckColumn = function(config){
		Ext.apply(this, config);
		if(!this.id){
			this.id = Ext.id();
		}
		this.renderer = this.renderer.createDelegate(this);
	};
	//	对自定义插件Ext.grid.CheckColumn作原型声明
	Ext.grid.CheckColumn.prototype ={  
		init : function(grid){  
			this.grid = grid;  
			this.grid.on('render', function(){  
				var view = this.grid.getView();  
				view.mainBody.on('mousedown', this.onMouseDown, this);  
			}, this);  
		},
		onMouseDown : function(e, t){  
			if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){  
				e.stopEvent();  
				var index = this.grid.getView().findRowIndex(t);  
				var record = this.grid.store.getAt(index);  
				record.set(this.dataIndex, !record.data[this.dataIndex]);  
			}
		},
		renderer : function(v, p, record){  
			p.css += ' x-grid3-check-col-td';   
			return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';  
		}
	}; 
	
	//	封装checkColumn的实例，以便后面引用
	var checkColumn = new Array();
	checkColumn[0] = new Ext.grid.CheckColumn({header:'ID',dataIndex:'ID',sortable:true,menuDisabled : true,width:15,hidden:true});
	checkColumn[1] = new Ext.grid.CheckColumn({header:'指标定义日志',dataIndex:'KpiLogDefinition',sortable:true,menuDisabled : true,width:15});
	checkColumn[2] = new Ext.grid.CheckColumn({header:'数据处理日志',dataIndex:'KpiLogDataProcess',sortable:true,menuDisabled : true,width:15});
	checkColumn[3] = new Ext.grid.CheckColumn({header:'数据查询日志',dataIndex:'KpiLogDataQuery',sortable:true,menuDisabled : true,width:15});
	checkColumn[4] = new Ext.grid.CheckColumn({header:'任务错误日志',dataIndex:'KpiLogTaskErr',sortable:true,menuDisabled : true,width:15});

	//	指标日志配置维护列模型
	var loginInfoCM = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		//{header:'kpiCode',dataIndex:'kpiCode',sortable:true,width:15,hidden:true},
		checkColumn[1],
		checkColumn[2],
		checkColumn[3],
		checkColumn[4]
	]);

	//		定义grid数据源
	var loginInfoStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpilogininfocfg.csp?action=lookup&kpiCode='+kpiCode+'&start=1&pageSize=15'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'kpiCode'},
				{name:'KpiLogDefinition', type: 'bool'},
				{name:'KpiLogDataProcess', type: 'bool'},
				{name:'KpiLogDataQuery', type: 'bool'},
				{name:'KpiLogTaskErr', type: 'bool'}
			]
		})
	});
	
	//		定义grid记录
	var recorde = Ext.data.Record.create([
		{name:'kpiCode'},
		{name:'KpiLogDefinition'},
		{name:'KpiLogDataProcess'},
		{name:'KpiLogDataQuery'},
		{name:'KpiLogTaskErr'}
	]);

	
	var isNewItem=false, isItemSaved=false;
	//		定义grid面板
	
	var loginInfoCfgGrid = new Ext.grid.EditorGridPanel({
		id:'loginInfoCfgGrid',
		height:360,
		frame:true,
		store:loginInfoStore,
		cm:loginInfoCM,
		sm:new Ext.grid.RowSelectionModel(),
		clicksToEdit:1,
		plugins:checkColumn,
		columnLines: true,
		viewConfig:{
			forceFit: true
		},
		bbar:new Ext.PagingToolbar({
            pageSize: 15,
            store: loginInfoStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
             listeners :{
				'change':function(pt,page){
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='+kpiCode));
				}
			}
        }),
		tbar: [{
            //text:'新增',
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler:function(){
				var initV={KpiLogDefinition:false,KpiLogDataProcess:false,KpiLogDataQuery:false,KpiLogTaskErr:false};
                var logSM = loginInfoCfgGrid.getSelectionModel();
				logSM.selectFirstRow();
				if (!!logSM.getCount())
                {
					Ext.MessageBox.alert("增加","您只能给每一个指标建立一条日志配置信息！");
					return;
                }
				else{
					loginInfoStore.insert(0,new recorde(initV));
				}
			}
		},'-',{
			//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
			handler:function(){
				var sm = loginInfoCfgGrid.getSelectionModel();
				var record = sm.getSelected();
				if (!sm||!record)
				{
					Ext.MessageBox.alert("消息","请单击选中选择要保存的行！");
					return;
				}
				mkpiCode=record.get('kpiCode');
				var KpiLogDefinition=record.get('KpiLogDefinition');
				var KpiLogDataProcess=record.get('KpiLogDataProcess');
				var KpiLogDataQuery=record.get('KpiLogDataQuery');
				var KpiLogTaskErr=record.get('KpiLogTaskErr');
				var paraList='&kpiCode='+kpiCode+'&KpiLogDefinition='+KpiLogDefinition+'&KpiLogDataProcess='+KpiLogDataProcess+'&KpiLogDataQuery='+KpiLogDataQuery+'&KpiLogTaskErr='+KpiLogTaskErr;
				if (!!mkpiCode) {
					dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=update&'+paraList);
				}else{
					dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=add&'+paraList);
				}
				loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='+kpiCode));
				loginInfoStore.load();
				loginInfoCfgGrid.show();
				//alert(paraList);
				Ext.MessageBox.alert("消息","指标日志配置保存成功！");
			}
		},'-',{
			//text:'删除',
			text: '<span style="line-Height:1">删除</span>',
			icon: '../images/uiimages/edit_remove.png',
			handler:function(){
				var sm = loginInfoCfgGrid.getSelectionModel();
				var record = sm.getSelected();
				if (!sm||!record)
				{
					Ext.MessageBox.alert("删除","请单击选中选择要删除的行！");
					return;
				}
				Ext.Msg.confirm("删除","删除指标"+kpiCode+"日志配置数据,确定删除吗？", function(btn){
					if ('yes' == btn)
					{
						//loginInfoStore.remove(record);
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delete&pageSize=15&kpiCode='+kpiCode+';');
						loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='+kpiCode));
						loginInfoStore.removeAll();
						loginInfoStore.load();
						loginInfoCfgGrid.show();
						
					}
				});
			}
		}],
		listenners:{
			'click':function(){
				record = sm.selectFirstRow();
			}
		}
	});

	
	var kpiLoginInfoCfgWin = new Ext.Window({
		title:'指标日志维护',
		id:'win-loginInfoCfg',
		width:800,
		height:400,
		modal:true,
		resizable:true,
		items:loginInfoCfgGrid
	});

	this.showKpiLoginInfoCfgWin = function(){
		this.showData();
		kpiLoginInfoCfgWin.show();
	}
	
	this.showData = function(){
		loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='+kpiCode));
		loginInfoStore.load({
			callback: function (Record, option, success) {
				if (true == success)
				{
					
				}
			}
		});
		loginInfoCfgGrid.show();
	}

	this.getLoginInfoStore=function(){
    	return loginInfoStore;
    }
}