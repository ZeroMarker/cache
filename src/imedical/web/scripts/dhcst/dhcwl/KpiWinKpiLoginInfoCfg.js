dhcwl.mkpi.KpiWinKpiLoginInfoCfg = function(kpiCode){

	//	是否已经配置了指标日志的全局变量
	var isConfiged=false;
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
	checkColumn[0] = new Ext.grid.CheckColumn({header:'指标定义（增加）',dataIndex:'MKPIDefineAdd',sortable:true,width:15});
	checkColumn[1] = new Ext.grid.CheckColumn({header:'指标定义（修改）',dataIndex:'MKPIDefineUpdate',sortable:true,width:15});
	checkColumn[2] = new Ext.grid.CheckColumn({header:'指标定义（删除）',dataIndex:'MKPIDefineDelete',sortable:true,width:15});
	checkColumn[3] = new Ext.grid.CheckColumn({header:'指标数据（查询）',dataIndex:'MKPIDataGet',sortable:true,width:15});
	checkColumn[4] = new Ext.grid.CheckColumn({header:'指标数据（生成）',dataIndex:'MKPIDataCreate',sortable:true,width:15});
	checkColumn[5] = new Ext.grid.CheckColumn({header:'指标任务',dataIndex:'MKPITask',sortable:true,width:15});

	//	指标日志配置维护列模型
	var loginInfoCM = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		checkColumn[0],
		checkColumn[1],
		checkColumn[2],
		checkColumn[3],
		checkColumn[4],
		checkColumn[5]
	]);

	//		定义grid数据源
	var loginInfoStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpilogininfocfg.csp?action=lookup&kpiCode='+kpiCode+'&start=1&pageSize=15'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'MKPIDefineAdd', type: 'bool'},
				{name:'MKPIDefineUpdate', type: 'bool'},
				{name:'MKPIDefineDelete', type: 'bool'},
				{name:'MKPIDataGet', type: 'bool'},
				{name:'MKPIDataCreate', type: 'bool'},
				{name:'MKPITask', type: 'bool'}
			]
		})
	});
	
	//		定义grid记录
	var recorde = Ext.data.Record.create([
		{name:'MKPIDefineAdd'},
		{name:'MKPIDefineUpdate'},
		{name:'MKPIDefineDelete'},
		{name:'MKPIDataGet'},
		{name:'MKPIDataCreate'},
		{name:'MKPITask'}
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
            pageSize: 10,
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
            text:'增加',
            handler:function(){
				var initV={MKPIDefineAdd:false,MKPIDefineUpdate:false,MKPIDefineDelete:false,MKPIDataGet:false,MKPIDataCreate:false,MKPITask:false};
                if (false == isConfiged)
                {
					loginInfoStore.insert(0,new recorde(initV));
                }
				else{
					Ext.MessageBox.alert("增加","您只能给每一个指标建立一条日志配置信息！");
					return;
				}
				isNewItem=true, isItemSaved=false;
			}
		},'-',{
			text:'保存',
			handler:function(){
				if (true==isNewItem)
				{
					var sm = loginInfoCfgGrid.getSelectionModel();
					var record = sm.getSelected();
					if (!sm||!record)
					{
						Ext.MessageBox.alert("增加","请单击选中选择要保存的行！");
						return;
					}
					var MKPIDefineAdd=record.get('MKPIDefineAdd');
					var MKPIDefineUpdate=record.get('MKPIDefineUpdate');
					var MKPIDefineDelete=record.get('MKPIDefineDelete');
					var MKPIDataGet=record.get('MKPIDataGet');
					var MKPIDataCreate=record.get('MKPIDataCreate');
					var MKPITask=record.get('MKPITask');
					var paraList='kpiCode='+kpiCode+'&MKPIDefineAdd='+MKPIDefineAdd+'&MKPIDefineUpdate='+MKPIDefineUpdate+'&MKPIDefineDelete='+MKPIDefineDelete;
					paraList=paraList+'&MKPIDataGet='+MKPIDataGet+'&MKPIDataCreate='+MKPIDataCreate+'&MKPITask='+MKPITask;
					dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=add&'+paraList);
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='+kpiCode));
					loginInfoStore.reload();
					loginInfoCfgGrid.show();
					//alert(paraList);
					Ext.MessageBox.alert("增加","新建指标日志配置保存成功！");
					isNewItem=false, isItemSaved=true;
				}
				else if (false==isNewItem)
				{
					var sm = loginInfoCfgGrid.getSelectionModel();
					var record = sm.getSelected();
					if (!sm||!record)
					{
						Ext.MessageBox.alert("更新","请单击选中选择要更新的行！");
						return;
					}
					var MKPIDefineAdd=record.get('MKPIDefineAdd');
					var MKPIDefineUpdate=record.get('MKPIDefineUpdate');
					var MKPIDefineDelete=record.get('MKPIDefineDelete');
					var MKPIDataGet=record.get('MKPIDataGet');
					var MKPIDataCreate=record.get('MKPIDataCreate');
					var MKPITask=record.get('MKPITask');
					var paraList='kpiCode='+kpiCode+'&MKPIDefineAdd='+MKPIDefineAdd+'&MKPIDefineUpdate='+MKPIDefineUpdate+'&MKPIDefineDelete='+MKPIDefineDelete;
					paraList=paraList+'&MKPIDataGet='+MKPIDataGet+'&MKPIDataCreate='+MKPIDataCreate+'&MKPITask='+MKPITask;
					dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=update&'+paraList);
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='+kpiCode));
					loginInfoStore.reload();
					loginInfoCfgGrid.show();
					//alert(paraList);
					Ext.MessageBox.alert("更新","指标日志配置更新成功！");
				}
			}
		},'-',{
			text:'删除',
			handler:function(){
				var sm = loginInfoCfgGrid.getSelectionModel();
				var record = sm.getSelected();
				if (!sm||!record)
				{
					Ext.MessageBox.alert("更新","请单击选中选择要更新的行！");
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
					isConfiged=true;
				}
			}
		});
		loginInfoCfgGrid.show();
	}

	this.getLoginInfoStore=function(){
    	return loginInfoStore;
    }
}