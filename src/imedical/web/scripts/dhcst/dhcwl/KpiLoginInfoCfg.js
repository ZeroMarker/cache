dhcwl.mkpi.KpiLoginInfoCfg = function(parentWin){
	var parentWin="";
	var serviceUrl="dhcwl/kpi/kpilogininfocfg.csp";
	

	/*****************************************指标选取窗口***************************************************/
	var columnModelKpi = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
        {header:'编码',dataIndex:'kpiCode', width: 70, sortable: true 
        },{header:'指标名称',dataIndex:'kpiName', width: 80, sortable: true 
        },{header:'维度',dataIndex:'dimType',resizable:'true',width:88
        },{header:'类型',dataIndex:'category',resizable:'true',width:88
        },{header:'区间',dataIndex:'section',resizable:'true',width:88
        }
    ]);

	//定义指标的存储模型
    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=TASK'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'dimType'},
            	{name: 'category'},
            	{name: 'section'}
       		]
    	})
    });
	
	//定义指标的显示表格。
	var choicedSearcheCond="", choiceKpiCode=null, originalKpiCode=null, isKpiSelected=false;
	var kpiList = new Ext.grid.GridPanel({
        id:"kpiTables",
        //width:500,
        height:600,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        store: storeKpi,
        cm: columnModelKpi,
		viewConfig:{
			forceFit: true
		},
        autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 50,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录"
        }),
        tbar: new Ext.Toolbar(
        ['按条件快速搜索：',{
    		xtype : 'compositefield',
			width: 300,
			anchor: '-20',
       	 	//msgTarget: 'side',
			items : [{
	        	//id:'searchCond2',	//?带id的combox会发生显示错位。
				width: 100,
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
	            		{name : 'Code',   value: '指标代码'},
	                	{name : 'Name',  value: '指标名称'},
	                	{name : 'Sec', value: '指标区间'},
	                	{name : 'Dim',  value: '指标维度'},
	                	{name : 'FL', value: '指标类型'}
	             	]}),
	             	listeners:{
	        			'select':function(combo){
	        				//alert("combo="+combo.getValue()+"  "+combo.getRawValue())
	        				choicedSearcheCond=combo.getValue();//ele.getValue();
	        			}
	        		}
	         	}, {
	        		xtype: 'textfield',
	            	width:200,
	            	flex : 1,
	            	id:'kpiSearchText-1',
	            	enableKeyEvents: true,
	            	//name : 'searcheContValue',
	            	//allowBlank: true,
	            	listeners :{
	            		'keypress':function(ele,event){
							var searcheValue=Ext.get("kpiSearchText-1").getValue();//ele.getValue();
							if ((event.getKey() == event.ENTER)){
								//alert("searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue);
	            				storeKpi.proxy.setUrl(encodeURI("dhcwl/kpi/getkpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="+choicedSearcheCond+"&searcheValue="+searcheValue+"&start=0&&limit=50"));
	            				storeKpi.load();
	            				kpiList.show();
	            			}
	            		}
	            	}
	        	}
        	]},"（按下'Enter'键查询，双击下表中的行选择指标）"
        ]),
		listeners :{
        	'rowdblclick':function(ele,event){
				originalKpiCode=Ext.getCmp('kpiSelectWin').getValue();
				var sm=kpiList.getSelectionModel();
				if(!sm) return;
				var record = sm.getSelected();
        		if(!record) return;
				choiceKpiCode=record.get("kpiCode");
				isKpiSelected=true;
				var kpiWin=Ext.getCmp('kpiWin'), kpiSelectWin=Ext.getCmp('kpiSelectWin');
				if (null==choiceKpiCode) Ext.getCmp('kpiSelectWin').setValue(originalKpiCode);
				//	第一个参数为true,逐层上报该事件
				//this.fireEvent(true,'rowdblclick',this.ownerCt.hide());
				//Ext.getCmp('kpiSelectWin').setValue(choiceKpiCode);
				this.ownerCt.hide();
			}
		}
    });



	/*******************************************指标日志配置维护面板************************************/
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
	checkColumn[0] = new Ext.grid.CheckColumn({header:'指标定义（增加）',dataIndex:'MKPIDefineAdd',sortable:true,width:15,hidden:true});
	checkColumn[1] = new Ext.grid.CheckColumn({header:'指标定义（修改）',dataIndex:'MKPIDefineUpdate',sortable:true,width:15});
	checkColumn[2] = new Ext.grid.CheckColumn({header:'指标定义（删除）',dataIndex:'MKPIDefineDelete',sortable:true,width:15});
	checkColumn[3] = new Ext.grid.CheckColumn({header:'指标数据（查询）',dataIndex:'MKPIDataGet',sortable:true,width:15});
	checkColumn[4] = new Ext.grid.CheckColumn({header:'指标数据（生成）',dataIndex:'MKPIDataCreate',sortable:true,width:15});
	checkColumn[5] = new Ext.grid.CheckColumn({header:'指标任务',dataIndex:'MKPITask',sortable:true,width:15});

	var isQueryOn=false;
	var sm = new Ext.grid.CheckboxSelectionModel();
	//	指标日志配置维护列模型
	var loginInfoCM = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		sm,
		{header:'指标&nbsp;&nbsp;&nbsp;[指标列表：F4]',id:'kpiWinText', dataIndex:'kpiCode',sortable:true,width:15,editor:new Ext.form.TextField({
			id:'kpiSelectWin',
			emptyText:'选择一个指标吧',
			enableKeyEvents: true,
			listeners:{
				keyup:function(ele,event){
					if (115==event.getKey())
					{
						isKpiSelected=false;
						storeKpi.removeAll();
						var kpiSelectWin=newWin;
						kpiSelectWin.show();
						isQueryOn=true;
					}
					else isQueryOn=false
				},
				'focus':function(){
					// 新增
					var sm = loginInfoCfgGrid.getSelectionModel();
					var record = sm.getSelected();
					var storeKpiCode=record.get("kpiCode");
					if ((isQueryOn==true)&&(null!=choiceKpiCode))
					{
						isQueryOn=false;
						Ext.getCmp('kpiSelectWin').setValue(choiceKpiCode);
					}else if ((isQueryOn==true)&&(null==choiceKpiCode))
					{
						isQueryOn=false;
					}else{
						// 更新
						textInputKpiCode=Ext.getCmp('kpiSelectWin').getValue()
						if (storeKpiCode!=textInputKpiCode)
						{
							Ext.getCmp('kpiSelectWin').setValue(textInputKpiCode);
						}
					}
				}
			}
		})},
		checkColumn[0],
		checkColumn[1],
		checkColumn[2],
		checkColumn[3],
		checkColumn[4],
		checkColumn[5]
	]);

	//	定义指标选取窗口
	var newWin = new Ext.Window({
		id:'kpiWin',
		title:'请选择要配置日志的指标',
		width:800,
		height:600,
		resizable:true,
		closeAction:'hide',
		modal:true,
		items:kpiList,
		listeners:{
			'hide':function(){
				if (null!=choiceKpiCode)
				{
					Ext.getCmp('kpiSelectWin').setValue(choiceKpiCode);
				}
			}
		}
	});

	//		定义grid数据源
	var loginInfoStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpilogininfocfg.csp?action=lookup&kpiCode=&start=1&pageSize=15'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'kpiCode'},
				{name:'MKPIDefineAdd', type: 'bool'},
				{name:'MKPIDefineUpdate', type: 'bool'},
				{name:'MKPIDefineDelete', type: 'bool'},
				{name:'MKPIDataGet', type: 'bool'},
				{name:'MKPIDataCreate', type: 'bool'},
				{name:'MKPITask', type: 'bool'}
			]
		})
		//sortInfo: {field:'kpiCode', direction:'ASC'}
	});
	
	//		定义grid记录
	var recorde = Ext.data.Record.create([
		{name:'kpiCode'},
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
		height:660,
		store:loginInfoStore,
		cm:loginInfoCM,
		sm:sm,
		clicksToEdit:1,
		plugins:checkColumn,
		columnLines: true,
		viewConfig:{
			forceFit: true
		},
		tbar: [{
            text:'增加',
            handler:function(){
            	var initV={ID:'',kpiId:'',MKPIDefineAdd:false,MKPIDefineUpdate:false,MKPIDefineDelete:false,MKPIDataGet:false,MKPIDataCreate:false,MKPITask:false};
                loginInfoStore.insert(0,new recorde(initV));
				//Ext.get("loginInfoCfgGrid").setOpacity(0.7,true);
				isNewItem=true, isItemSaved=false;
				var sm = loginInfoCfgGrid.getSelectionModel();
				//	默认选取新建的行
				var record = sm.selectFirstRow();
				//loginInfoCfgGrid.doLayout();
			}
		},'-',{
			text:'保存',
			handler:function(){
				if (true==isNewItem)
				{
					//var kpiCode=choiceKpiCode;
					var sm = loginInfoCfgGrid.getSelectionModel();
					//	默认选取新建的行
					var record = sm.getSelected();
					var kpiCode = null;
					if (!sm||!record)
					{
						Ext.MessageBox.alert("增加","请单击选中选择要保存的行！");
						return;
					}
					var kpiCode=record.get("kpiCode");
					if (null==kpiCode)
					{
						Ext.MessageBox.alert("增加","请选择一个指标或填写一个指标代码！");
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
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='));
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
					var kpiCode=record.get("kpiCode");
					var MKPIDefineAdd=record.get('MKPIDefineAdd');
					var MKPIDefineUpdate=record.get('MKPIDefineUpdate');
					var MKPIDefineDelete=record.get('MKPIDefineDelete');
					var MKPIDataGet=record.get('MKPIDataGet');
					var MKPIDataCreate=record.get('MKPIDataCreate');
					var MKPITask=record.get('MKPITask');
					var paraList='kpiCode='+kpiCode+'&MKPIDefineAdd='+MKPIDefineAdd+'&MKPIDefineUpdate='+MKPIDefineUpdate+'&MKPIDefineDelete='+MKPIDefineDelete;
					paraList=paraList+'&MKPIDataGet='+MKPIDataGet+'&MKPIDataCreate='+MKPIDataCreate+'&MKPITask='+MKPITask;
					dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=update&'+paraList);
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode='));
					loginInfoStore.reload();
					loginInfoCfgGrid.show();
					//alert(paraList);
					Ext.MessageBox.alert("更新","指标日志配置更新成功！");
				}
				//alert(choiceKpiCode);
			}
		},'-',{
			text:'删除',
			handler:function(){
				//var kpiCode=Ext.getCmp('kpiSelectWin').getValue();
				//if (!kpiCode)
				//{
				//	Ext.MessageBox.alert("消息","请确定您要删除的内容是存在的？");
				//	return;
				//}
				var selectedRows=loginInfoCfgGrid.getSelectionModel().getSelections(), kpisCodeStr="";
				for (var current=0; current<selectedRows.length; current++)
				{
					kpisCodeStr += selectedRows[current].json.kpiCode+";";
				}
				var paraList='kpiCode='+kpisCodeStr;
				
				Ext.Msg.confirm("删除","删除指标"+kpisCodeStr+"日志配置数据,确定删除吗？", function(btn){
					if ('yes' == btn)
					{
						//loginInfoStore.remove(record);
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delete&'+paraList);
						loginInfoStore.reload();
						loginInfoCfgGrid.show();
					}
				});
			}
		},'-',{
			text:'查询',
			handler:function(){
				var kpiCode=null;
				kpiCode=choiceKpiCode;
				if (null==choiceKpiCode)
				{
					kpiCode=Ext.getCmp('kpiSelectWin').getValue();
					if (!kpiCode)
					{
						Ext.MessageBox.alert("消息","请在指标列下的文本区域内按F4选择一个指标，或者填写一个指标代码吧！");
						return;
					}
				}
				
				var paraList='kpiCode='+kpiCode;
				loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&'+paraList));
				loginInfoStore.load({
					callback: function (Record, option, success) {
						//alert(Record+'#####'+option+'#####'+success);
						if (false == success){
							Ext.MessageBox.alert("消息","啊哦，没有您要找的记录喂. 查询条件将被清空！");
							loginInfoStore.removeAll();
							choiceKpiCode="";
						}
					}
				});
				loginInfoCfgGrid.show();
			}
		},'-',{
			text:'重新载入',
			handler:function(){
				var kpiCode="";
				var paraList='kpiCode='+kpiCode;
				loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&'+paraList));
				loginInfoStore.reload();
				loginInfoCfgGrid.show();
			}
		}]
	});

	//		定义指标日志配置面板
	var loginInfoCfgPanel = new Ext.Panel({
		title:'指标日志配置',
		frame:'true',
		id:'loginInfoCfgPanel',
		monitorResize:true,
		layout:'border',
		items:[{
			region:'center',
			height:540,
			//anchor:'100% 85%',
			autoScroll:true,
			items:loginInfoCfgGrid
		}]
	});

	this.getKpiLoginInfoCfgPanel=function(){
		this.showData();
    	return loginInfoCfgPanel;
	}
	
	this.showData = function(){
		var kpiCode="";
		loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageSize=15&kpiCode'+kpiCode));
		loginInfoStore.load();
		loginInfoCfgGrid.show();
	}
	//设定父窗口
	dhcwl.mkpi.MaintainDim.setParentWin=function(parentWin){
		dhcwl.mkpi.MaintainDim.parentWin=parentWin;
	}

}