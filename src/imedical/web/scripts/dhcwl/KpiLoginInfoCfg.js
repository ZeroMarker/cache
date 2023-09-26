dhcwl.mkpi.KpiLoginInfoCfg = function(parentWin){
	var parentWin="";
	var serviceUrl="dhcwl/kpi/kpilogininfocfg.csp";
	var selectedKpiCode="", newCfgUnsaved=false;

	/*****************************************指标选取窗口***************************************************/
	var columnModelKpi = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'ID',dataIndex:'ID', width: 30, sortable: true ,menuDisabled : true
        },{header:'编码',dataIndex:'kpiCode', width: 70, sortable: true ,menuDisabled : true
        },{header:'指标名称',dataIndex:'kpiName', width: 80, sortable: true ,menuDisabled : true
        },{header:'类型',dataIndex:'category',resizable:'true',width:88,menuDisabled : true
        },{header:'区间',dataIndex:'section',resizable:'true',width:88,menuDisabled : true
        }
    ]);

	//定义指标的存储模型
    var storeKpi = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:'dhcwl/kpi/kpilogininfocfg.csp?action=getKpiNotLogCfged&start=0&pageSize=15'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'ID'},
            	{name: 'kpiCode'},
            	{name: 'kpiName'},
            	{name: 'category'},
            	{name: 'section'}
       		]
    	})
    });
	
	//定义指标的显示表格。
	var kpiList = new Ext.grid.GridPanel({
		id:"KPILoginInfoCfgkpiTables",
        //width:500,
        height:350,
        resizeAble:true,
        //autoHeight:true,
        enableColumnResize :true,
        store: storeKpi,
        cm: columnModelKpi,
		viewConfig:{
			forceFit: true
		},
        //autoScroll: true,
        bbar:new Ext.PagingToolbar({
            pageSize: 15,
            store: storeKpi,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到第 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
            listeners :{
	        	'beforechange':function(pt,page){
					var kpiListKpiCode = Ext.getCmp('kpiList-kpiCode').getValue();
	        		storeKpi.proxy.setUrl(encodeURI('dhcwl/kpi/kpilogininfocfg.csp?action=getKpiNotLogCfged&kpiCode='+kpiListKpiCode));
	        	}
            }
        }),
        listeners :{
        	'rowdblclick':function(ele,event){
				var sm = kpiList.getSelectionModel();
				if(!sm) return;
				var record = sm.getSelected();
        		if(!record) return;
				var kpiCode = record.get("kpiCode");
				selectedKpiCode = kpiCode;
				//Ext.getCmp('kpiLog-kpiCode').setValue(kpiCode);
				Ext.getCmp('kpiList-kpiCode').setValue(kpiCode);
				//	回填以及新增
				var initV={ID:'',kpiCode:selectedKpiCode, KpiLogDefinition:false, KpiLogDataProcess:false, KpiLogDataQuery:false, KpiLogTaskErr:false};
                loginInfoStore.insert(0,new recorde(initV));
				//	选中新增行
				var logSM = loginInfoCfgGrid.getSelectionModel();
				logSM.selectFirstRow();
				newCfgUnsaved=true;
				Ext.getCmp('kpiWin').hide();
			}
		}
    });
	
	//	定义指标选取窗口参数面板
	var kpiListArgsPanel = new Ext.Panel({
		monitorResize:true,
		layout:'table',
		frame:true,
		layoutConfig:{columns:3},
		items:[{
			html:'指标编码:'
		},{
			xtype:'textfield',
			id:'kpiList-kpiCode'
		},{
			xtype:'button',
			//text:'查询',
			text: '<span style="line-Height:1">查询</span>',
			icon: '../images/uiimages/search.png',
			listeners:{
				'click':function(){
					storeKpi.removeAll();
					var kpiListKpiCode = Ext.getCmp('kpiList-kpiCode').getValue();
					storeKpi.proxy.setUrl(encodeURI('dhcwl/kpi/kpilogininfocfg.csp?action=getKpiNotLogCfged&kpiCode='+kpiListKpiCode+'&start=0&pageSize=15'));
					storeKpi.load();
				}
			}
		}]
	});
	
	//	定义指标选取窗口
	var kpiWin = new Ext.Window({
		id:'kpiWin',
		title:'尚未配置局部日志的指标',
        width:800,
		height:450,
		resizable:true,
		closeAction:'hide',
		layout:'border',
		modal:true,
		items:[{
			layout:'fit',
			region:'north',
			height:60,
			items:kpiListArgsPanel
		},{
			layout:'fit',
			region:'center',
			items:kpiList
		}],
		listeners:{
			'close':function(){
				this.hide();
				//this.ownerCt.hide();
			}
		}
	});



	/*******************************************指标日志配置维护面板************************************/
	    var selectedKpiCodes=[];
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
	checkColumn[0] = new Ext.grid.CheckColumn({header:'ID',dataIndex:'ID',sortable:true,menuDisabled : true,width:150,hidden:true});
	checkColumn[1] = new Ext.grid.CheckColumn({header:'指标定义日志',dataIndex:'KpiLogDefinition',sortable:true,menuDisabled : true,width:200});
	checkColumn[2] = new Ext.grid.CheckColumn({header:'数据处理日志',dataIndex:'KpiLogDataProcess',sortable:true,menuDisabled : true,width:200});
	checkColumn[3] = new Ext.grid.CheckColumn({header:'数据查询日志',dataIndex:'KpiLogDataQuery',sortable:true,menuDisabled : true,width:200});
	checkColumn[4] = new Ext.grid.CheckColumn({header:'任务错误日志',dataIndex:'KpiLogTaskErr',sortable:true,menuDisabled : true,width:200});
	
	var isQueryOn=false;
	var sm = new Ext.grid.CheckboxSelectionModel();
	sm.on('selectionchange',function(){
		if (true == newCfgUnsaved) {
			Ext.Msg.confirm("消息","新增指标"+selectedKpiCode+"的日志配置数据尚未保存，继续吗？", function(btn){
				if ('yes' == btn){
					newCfgUnsaved = false;
					loginInfoStore.reload();
					loginInfoCfgGrid.show();
				} else {
					//	选中新增行
					var logSM = loginInfoCfgGrid.getSelectionModel();
					logSM.suspendEvents();
					logSM.selectFirstRow();
					logSM.resumeEvents();
					needTip = false;
				}
			});
		}
	});
	
	
	
	sm.on('rowselect',function(sm, row, rec){
		var code=rec.get("kpiCode");
    	if(!code||code=="") return;
		for(var i=selectedKpiCodes.length-1;i>-1;i--){
			if(selectedKpiCodes[i]==code)
				return;
		}
		selectedKpiCodes.push(code);
		//alert(selectedKpiIds.join(","));
	});
	
	
	sm.on('rowdeselect',function(sm, row, rec){
		var kpiCode=rec.get("kpiCode"),len=selectedKpiCodes.length;
		for(var i=0;i<len;i++){
			if(selectedKpiCodes[i]==kpiCode){
				for(var j=i;j<len;j++){
					selectedKpiCodes[j]=selectedKpiCodes[j+1];
					//selectKpiObj[rec.get("kpiCode")]=rec.get("kpiName");
				}
				selectedKpiCodes.length=len-1;
				break;
			}
		}
	});
	
	//	指标日志配置维护列模型
	var loginInfoCM = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		sm,
		{header:'指标编码',dataIndex:'kpiCode',sortable:true,width:200},//,editor:new Ext.form.TextField({id:'kpiLog-kpiCode',disabled:true})},
		checkColumn[0],
		checkColumn[1],
		checkColumn[2],
		checkColumn[3],
		checkColumn[4]
	]);

	//		定义grid数据源
	var loginInfoStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/kpilogininfocfg.csp?action=lookup&kpiCode=&start=1&pageSize=20'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'kpiCode'},
				{name:'ID'},
				{name:'KpiLogDefinition', type: 'bool'},
				{name:'KpiLogDataProcess', type: 'bool'},
				{name:'KpiLogDataQuery', type: 'bool'},
				{name:'KpiLogTaskErr', type: 'bool'}
			]
		})
		//sortInfo: {field:'kpiCode', direction:'ASC'}
	});
	
	//		定义grid记录
	var recorde = Ext.data.Record.create([
		{name:'kpiCode'},
		{name:'ID'},
		{name:'KpiLogDefinition'},
		{name:'KpiLogDataProcess'},
		{name:'KpiLogDataQuery'},
		{name:'KpiLogTaskErr'}
	]);

	
	var isNewItem=false, isItemSaved=false;
	//		定义grid面板
	var loginInfoCfgGrid = new Ext.grid.EditorGridPanel({
		id:'loginInfoCfgGrid',
		title:'日志局部配置',
		//frame:true,
		height:500,
		store:loginInfoStore,
		cm:loginInfoCM,
		sm:sm,
		clicksToEdit:1,
		plugins:checkColumn,
		columnLines: true,
		/*viewConfig:{
			forceFit: true
		},*/
		bbar:new Ext.PagingToolbar({
            pageSize: 20,
            store: loginInfoStore,
            displayInfo: true,
            displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
            emptyMsg: "没有记录",
			listeners :{
	        	'beforechange':function(pt,page){
					var kpiCode = Ext.getCmp('query-kpiCode').getValue(), type = Ext.getCmp('query-type').getValue();
					var paraList='kpiCode='+kpiCode+'&type='+type;
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&pageType=nextPage&'+paraList));
	        	},
	        	'change':function(pt,page){
					var code="";
					selKpiLen=selectedKpiCodes.length
					var AllRowCnt=loginInfoStore.getCount();
					var selRowCnt=0;					
					for(var i=loginInfoStore.getCount()-1;i>-1;i--){
						code=loginInfoStore.getAt(i).get("kpiCode");
						found=false;
						for(j=selKpiLen-1;j>-1;j--){
							if(selectedKpiCodes[j]==code) found=true;
						}
						if(found){
							sm.selectRow(i,true,false);
							selRowCnt++;
						}
					}
							
					
					
					var hd_checker = loginInfoCfgGrid.getEl().select('div.x-grid3-hd-checker');
			    	var hd = hd_checker.first();
			    	if(hd!=null ){
			    	    if(AllRowCnt!=selRowCnt && hd.hasClass('x-grid3-hd-checker-on')){
			    	    	hd.removeClass('x-grid3-hd-checker-on');
				    	}else if(AllRowCnt==selRowCnt && !hd.hasClass('x-grid3-hd-checker-on'))
				    	{
				    		hd.addClass('x-grid3-hd-checker-on');
				    	}
			    	}					
				}
            }
        }),
		tbar: [{
            //text:'新增',
            text: '<span style="line-Height:1">新增</span>',
            icon: '../images/uiimages/edit_add.png',
            handler:function(){
				if (true == getTipOfUnsaved()) {return;}
				storeKpi.load();
				Ext.getCmp('kpiList-kpiCode').setValue('');
				kpiWin.show();
			}
		},'-',{
			//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
			handler:function(){
				var operType = "";
				if (true == newCfgUnsaved) {
					operType = 'add';
				}else{ operType = 'update'; }
				newCfgUnsaved = false;
				var sm = loginInfoCfgGrid.getSelectionModel();
				if(!sm) return;
				//var record = sm.getSelected();
				//modify by wz.2014-3-21
				var records=sm.getSelections();
				for (var i=0;i<=records.length-1;i++) {
					record=records[i];
					var kpiCode=record.get('kpiCode');
					var KpiLogDefinition=record.get('KpiLogDefinition');
					var KpiLogDataProcess=record.get('KpiLogDataProcess');
					var KpiLogDataQuery=record.get('KpiLogDataQuery');
					var KpiLogTaskErr=record.get('KpiLogTaskErr');
					var paraList='&kpiCode='+kpiCode+'&KpiLogDefinition='+KpiLogDefinition+'&KpiLogDataProcess='+KpiLogDataProcess+'&KpiLogDataQuery='+KpiLogDataQuery+'&KpiLogTaskErr='+KpiLogTaskErr;
					dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action='+operType+paraList);
				}
				
				//loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20&kpiCode='));
				//setTimeout("loginInfoStore.load()",500);
				//modify by wk.2015-09-28
				var kpiCode = Ext.getCmp('query-kpiCode').getValue(), type = Ext.getCmp('query-type').getValue();
				var paraList='kpiCode='+kpiCode+'&type='+type;
				loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20&'+paraList));
				loginInfoStore.load();
				loginInfoCfgGrid.show();
			}
		},'-',{
			//text:'删除',
			text: '<span style="line-Height:1">删除</span>',
			icon: '../images/uiimages/edit_remove.png',
			handler:function(){
				if (true == getTipOfUnsaved()) {return;}
				
				/*
				 var selectedRows=loginInfoCfgGrid.getSelectionModel().getSelections(), kpisCodeStr="";
				if (""==selectedRows){
					Ext.MessageBox.alert("消息","请选择您要删除的行！");
					return;
				}
				
				for (var current=0; current<selectedRows.length; current++)
				{	
					//if (typeof(selectedRows[current].json.kpiCode) == "undefined"){	//???
					if (typeof(selectedRows[current].json) == "undefined"){
						Ext.MessageBox.alert("消息","呃，您现在正在增加新的指标日志配置信息。如果要放弃增加，请“重新载入”即可！");
						return;
					}
					kpisCodeStr += selectedRows[current].json.kpiCode+";";
				}
				var paraList='kpiCode='+kpisCodeStr;
				*/
				if (selectedKpiCodes.length==0) {
					Ext.MessageBox.alert("消息","请选择您要删除的行！");
					return;
				}
				var kpisCodeStr="";
				for (var i=0;i<=selectedKpiCodes.length-1;i++) {
					kpisCodeStr += selectedKpiCodes[i]+";";
				}
				var paraList='kpiCode='+kpisCodeStr;
				Ext.Msg.confirm("提示","确定删除指标日志配置数据吗？", function(btn){
					if ('yes' == btn)
					{
						dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=delete&'+paraList);
						loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20'));
						loginInfoStore.load();
						loginInfoCfgGrid.show();
						
						selectedKpiCodes=[];						
		
					}
				});
			}
		},'-',{
			//text:'重新载入',
			text: '<span style="line-Height:1">重新载入</span>',
			icon: '../images/uiimages/reset.png',
			handler:function(){
				if (true == getTipOfUnsaved()) {return;}
				var kpiCode="";
				var paraList='kpiCode='+kpiCode;
				loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20&'+paraList));
				loginInfoStore.load();
				loginInfoCfgGrid.show();
				selectedKpiIds=[];
			}
		}]
	});
	
	//		定义参数面板
	/*var loginInfoCfgArgs = new Ext.Panel({
		monitorResize:true,
		layout:'table',
		layoutConfig:{columns:5},
		items:[{
			html:'指标编码：'
		},{
			xtype:'textfield',
			id:'query-kpiCode',
			name:'query-kpiCode'
		},{
			html:'类型：'
		},{
			width: 100,
			id:'query-type',
			xtype:'combo',
			mode:'local',
			emptyText:'请选择指标日志类型',
			triggerAction:  'all',
			forceSelection: true,
			editable: false,
			displayField:'value',
			valueField:'name',
			store:new Ext.data.JsonStore({
				fields:['name', 'value'],
				data:[
					{name : '',   value: ''},
					{name : 'KpiLogDefinition',   value: '指标定义日志'},
					{name : 'KpiLogDataProcess', value: '数据处理日志'},
					{name : 'KpiLogDataQuery',  value: '数据查询日志'},
					{name : 'KpiLogTaskErr',  value: '任务错误日志'}
				]
			})
		},{
			xtype:'button',
			//text:'查询',
			text: '<span style="line-Height:1">查询</span>',
			icon: '../images/uiimages/search.png',
			listeners:{
				'click':function(){
					if (true == getTipOfUnsaved()) {return;}
					var kpiCode = Ext.getCmp('query-kpiCode').getValue(), type = Ext.getCmp('query-type').getValue();
					var paraList='kpiCode='+kpiCode+'&type='+type;
					loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20&'+paraList));
					loginInfoStore.load({
						callback: function (Record, option, success) {
							//alert(Record+'#####'+option+'#####'+success);
							if (false == success){
								//alert(success);
								Ext.MessageBox.alert("消息","啊哦，没有您要找的记录喂. ");
								loginInfoStore.removeAll();
							}
						}
					});
					loginInfoCfgGrid.show();
				}
			}
		}]
	});*/
	
	var loginInfoCfgArgs = new Ext.FormPanel({
    	border:false,
		bodyStyle:'padding:5px',
        style: {
            "margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0" 
        },
        labelAlign: 'right',
        buttonAlign: 'center',
		frame : true,
		bodyStyle:'padding:5px',
		labelWidth : 60,
		items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .20,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 150
				},
				items:[{
							fieldLabel : '指标编码',
							xtype:'textfield',
							id:'query-kpiCode',
							name:'query-kpiCode'
						}]
			},{ 
				columnWidth : .40,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 310
				},
				items : [
					{
						xtype: 'compositefield',
						fieldLabel : '函数选择',
						defaults: {
							flex: 1
						},
						items: [{
							fieldLabel : '类型',
							width: 150,
							id:'query-type',
							xtype:'combo',
							mode:'local',
							emptyText:'请选择指标日志类型',
							triggerAction:  'all',
							forceSelection: true,
							editable: false,
							displayField:'value',
							valueField:'name',
							store:new Ext.data.JsonStore({
								fields:['name', 'value'],
								data:[
									{name : '',   value: ''},
									{name : 'KpiLogDefinition',   value: '指标定义日志'},
									{name : 'KpiLogDataProcess', value: '数据处理日志'},
									{name : 'KpiLogDataQuery',  value: '数据查询日志'},
									{name : 'KpiLogTaskErr',  value: '任务错误日志'}
								]
							})
						},{
							xtype: 'button',
							text: '<span style="line-Height:1">查询</span>',
							icon: '../images/uiimages/search.png',						
							width: 30,
							handler: function(button) {
								if (true == getTipOfUnsaved()) {return;}
								var kpiCode = Ext.getCmp('query-kpiCode').getValue(), type = Ext.getCmp('query-type').getValue();
								var paraList='kpiCode='+kpiCode+'&type='+type;
								loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20&'+paraList));
								loginInfoStore.load({
									callback: function (Record, option, success) {
										//alert(Record+'#####'+option+'#####'+success);
										if (false == success){
											//alert(success);
											Ext.MessageBox.alert("消息","啊哦，没有您要找的记录喂. ");
											loginInfoStore.removeAll();
										}
									}
								});
								loginInfoCfgGrid.show();
							}
						}]
					}]
			}]
		}]
	})
		
	
	
	
	//		定义指标日志配置面板
	/*var loginInfoCfgPanel = new Ext.Panel({
		header:true,
		title:'日志配置',
		id:'loginInfoCfgPanel',
		monitorResize:true,
		layout:'border',
		items:[{
			region:'north',
			layout:'fit',
			frame:true,
			height:65,
			items:loginInfoCfgArgs
		},{
			region:'center',
			layout:'fit',
			//height:630,
			//anchor:'100% 85%',
			autoScroll:true,
			items:loginInfoCfgGrid
		}]
	});*/
	
	
	var loginInfoCfgPanel =new Ext.Panel ({ 
    	title:'日志配置',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		
    	defaults: { border :false},
        items: [{ 
			border :false,
			flex:1,
			layout:"fit",
            items:loginInfoCfgArgs
    	},{
			border :false,
			flex:5,
			layout:"fit",
            items:loginInfoCfgGrid
        }]
    });
	
	
	function getTipOfUnsaved(){
		if (true == newCfgUnsaved) {
			Ext.Msg.confirm("消息","新增指标"+selectedKpiCode+"的日志配置数据尚未保存，要放弃修改吗？", function(btn){
				if ('yes' == btn){
					newCfgUnsaved = false;
					loginInfoStore.reload();
					loginInfoCfgGrid.show();
				} else {
					//	选中新增行
					var logSM = loginInfoCfgGrid.getSelectionModel();
					logSM.suspendEvents();
					logSM.selectFirstRow();
					logSM.resumeEvents();
					needTip = false;
				}
			});
		}
		return newCfgUnsaved;
	}
	
	this.getKpiLoginInfoCfgPanel=function(){
		this.showData();
    	return loginInfoCfgPanel;
	}
	
	this.showData = function(){
		loginInfoStore.proxy.setUrl(encodeURI(serviceUrl+'?action=lookup&start=1&pageSize=20&kpiCode='));
		loginInfoStore.load();
		loginInfoCfgGrid.show();
	}
	//设定父窗口
	dhcwl.mkpi.MaintainDim.setParentWin=function(parentWin){
		dhcwl.mkpi.MaintainDim.parentWin=parentWin;
	}
	
}