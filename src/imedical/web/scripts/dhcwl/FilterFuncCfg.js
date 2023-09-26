dhcwl.mkpi.FilterFuncCfg = function(){
	
	//*************************************************************过滤函数维护*********************************************************//
	var lastParaValue="", funcPrototype="";
	//		定义grid列模型
	var filterFuncColumnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'ID',dataIndex:'FilterFuncID',sortable:true,width:15,menuDisabled : true},
		{header:'过滤函数名称',dataIndex:'FilterFuncCode',sortable:true,menuDisabled : true,width:50},
		{header:'功能描述',dataIndex:'FilterFuncFuncDesc',sortable:true,menuDisabled : true,anchor:'100%'},
		{header:'函数原型',dataIndex:'FilterFuncPrototype',sortable:true,menuDisabled : true,anchor:'100%'},
		{header:'执行代码',dataIndex:'FilterFuncExecCode',sortable:true,menuDisabled : true,anchor:'100%'}
	]);
	
	//		定义grid数据源
	var filterFuncStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/filterfunccfg.csp?action=lookup&start=0&pageSize=15'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'FilterFuncID'},
				{name:'FilterFuncCode'},
				{name:'FilterFuncPrototype'},
				{name:'FilterFuncExecCode'},
				{name:'FilterFuncFuncDesc'}
			]
		})
	});
	
	var filterFuncRecord = new Ext.data.Record.create([
		{name:'FilterFuncID',type:'string'},
		{name:'FilterFuncCode',type:'string'},
		{name:'FilterFuncPrototype',type:'string'},
		{name:'FilterFuncExecCode',type:'string'},
		{name:'FilterFuncFuncDesc',type:'string'}
	]);
	
	var pagingBar = new Ext.PagingToolbar({
		pageSize:15,
		store:filterFuncStore,
		displayInfo:true,
		displayMsg:'{0}~{1}条,共 {2} 条',
		emptyMsg:'sorry,data not found!',
		listeners :{
			'beforechange':function(pt,page){
				var code=Ext.getCmp('FilterFuncCode').getValue();
				var funcPrototype=Ext.getCmp('FilterFuncPrototype').getValue();
				var execCode=Ext.getCmp('FilterFuncExecCode').getValue();
				var funcDesc=Ext.getCmp('FilterFuncFuncDesc').getValue();
				if (execCode.match(/\#/)) {
					execCode=execCode.substring(2,execCode.length);
				}
				filterFuncStore.proxy.setUrl(encodeURI('dhcwl/kpi/filterfunccfg.csp?action=lookup'+lastParaValue));
			}
		}
	});
	
	//		定义grid样式
	var filterFuncGrid = new Ext.grid.GridPanel({
		//title:'函数列表',
		id:'filterFuncGrid',
		store:filterFuncStore,
		height:445,
		//autoScroll:true,
		frame:true,
		columnLines: true,
		viewConfig:{
			//autoFill:true
			markDirty :false,
			forceFit: true
		},
		cm:filterFuncColumnModel,
		sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	'rowselect': function(sm, row, rec) {
            		var id=rec.get("FilterFuncID");
					if (!id) {
						Ext.getCmp('FilterFuncID').setValue("");
						//Ext.getCmp('FilterFuncCode').enable();
					}else{
						//Ext.getCmp('FilterFuncCode').disable();		
						//++modify by wz.2014-4-22
						Ext.getCmp('FilterFuncPrototype').disable();
					}
					
            		var description=rec.get("FilterFuncFuncDesc");
            		description=description.replace(/\<br\/\>/gi, '\n');
            		rec.set("FilterFuncFuncDesc",description);					
					
					
					var form=filterFuncForm.getForm();
					
					
                	form.loadRecord(rec);
                	form.setValues({ID:id});
             	}
            }
        }),
		bbar:pagingBar
	});
	
	//modify by wk ~2017-03-16~公司UI标准修改
	//		定义Form表单
	/*var filterFuncForm = new Ext.FormPanel({
		//title:'函数信息',
		id:'filterFuncForm',
		//height:400,
		layout:'table',
		loadMask: true,
		columnLines: true,
		viewConfig:{forceFit: true},
		layoutConfig:{columns:10},
		items:[{
			html:'ID:'
		},{
			width:60,
			xtype:'textfield',
			name:'FilterFuncID',
			id:'FilterFuncID',
			disabled:true
		},{
			html:'过滤函数名称:'
		},{
			//vtype:'alpha',
			xtype:'textfield',
			name:'FilterFuncCode',
			id:'FilterFuncCode',
			listeners:{
				'change':function(){
				}
			}
		},{
			html:'函数原型:'
		},{
			xtype:'combo',
			name:'FilterFuncPrototype',
			id:'FilterFuncPrototype',
			width:180,
			colspan:5,
			mode:'local',
			triggerAction:'all',
			displayField:'displayValue',
			valueField:'realValue',
			store:new Ext.data.JsonStore({
				fields:['displayValue','realValue'],
				data:[{
					displayValue:'INTERNAL',
					realValue:'INTERNAL'
				},{
					displayValue:'CUSTOM',
					realValue:'CUSTOM'
				}]
			}),
			listeners:{
				'select':function(combox){
					Ext.getCmp('FilterFuncPrototype').setValue(combox.getValue());
				}
			}
		},{
			html:'函数执行代码:'
		},{
			width:520,
			xtype:'textfield',
			name:'FilterFuncExecCode',
			id:'FilterFuncExecCode',
			//disabled:true,
			emptyText:'##class(ClassName).MethodName 或者 MethodName^MacFileName',
			colspan:9
		},{
			html:'功能描述:'
		},{
			width:520,
			//height:30,
			emptyText:'用简短的文字说明下该函数的函数功能吧......',
			xtype:'textarea',
			name:'FilterFuncFuncDesc',
			id:'FilterFuncFuncDesc',
			colspan:10
		}],*/
	var filterFuncForm = new Ext.FormPanel({
    	frame : true,
		height : 150,
		labelAlign : 'right',
		bodyStyle:'padding:5px',
		labelWidth : 80,
		style : {
			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"
		},
		items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .30,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 130
				},
				items : [{
							fieldLabel : 'ID',
							xtype:'textfield',
							name:'FilterFuncID',
							id:'FilterFuncID',
							disabled:true
						},{
							fieldLabel : '名称',
							xtype:'textfield',
							name:'FilterFuncCode',
							id:'FilterFuncCode'
						},{
							fieldLabel : '函数原型',
							xtype:'combo',
							name:'FilterFuncPrototype',
							id:'FilterFuncPrototype',
							colspan:5,
							mode:'local',
							triggerAction:'all',
							displayField:'displayValue',
							valueField:'realValue',
							store:new Ext.data.JsonStore({
								fields:['displayValue','realValue'],
								data:[{
									displayValue:'INTERNAL',
									realValue:'INTERNAL'
								},{
									displayValue:'CUSTOM',
									realValue:'CUSTOM'
								}]
							}),
							listeners:{
								'select':function(combox){
									Ext.getCmp('FilterFuncPrototype').setValue(combox.getValue());
								}
							}
						}]
			},{ 
				columnWidth : .60,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 450
				},
				items : [{
							fieldLabel : '执行代码',
							xtype:'textfield',
							emptyText:'##class(ClassName).MethodName 或者 MethodName^MacFileName',
							name:'FilterFuncExecCode',
							id:'FilterFuncExecCode'
						},{
							fieldLabel : '功能描述',
							height:40,
							emptyText:'用简短的文字说明下该函数的函数功能吧......',
							xtype:'textarea',
							name:'FilterFuncFuncDesc',
							id:'FilterFuncFuncDesc'
						}]
			}]
		}],
		
		tbar:new Ext.Toolbar([{
			//text:'新增',
			text: '<span style="line-Height:1">新增</span>',
			icon: '../images/uiimages/edit_add.png',
			handler:function(){
				var initV={FilterFuncCode:'',FilterFuncPrototype:'',FilterFuncExecCode:'',FilterFuncFuncDesc:''};
				filterFuncStore.insert(0,new filterFuncRecord(initV));
				var form = filterFuncForm.getForm();
				form.setValues({FilterFuncID:'',FilterFuncCode:'',FilterFuncPrototype:'',FilterFuncExecCode:'',FilterFuncFuncDesc:''});
				//++moidfy by wz.2014-4-22
				Ext.getCmp('FilterFuncPrototype').enable();
			}
		},'-',{
			//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
			handler:function(){
				var cursor=Math.ceil((pagingBar.cursor + pagingBar.pageSize) / pagingBar.pageSize);
				var id=Ext.getCmp('FilterFuncID').getValue();
				var code=Ext.getCmp('FilterFuncCode').getValue();
				var funcPrototype=Ext.getCmp('FilterFuncPrototype').getValue();
				var execCode=Ext.getCmp('FilterFuncExecCode').getValue();
				var funcDesc=Ext.getCmp('FilterFuncFuncDesc').getValue();
				
				funcDesc=funcDesc.replace(/\r\n/gi, '<br/>').replace(/\n/gi, '<br/>');
				if (!code || !execCode || !funcPrototype){
					Ext.MessageBox.alert("保存","需要您指定函数名称和函数执行代码及函数原型！");
               		return;
				}
				
				//add by wz.2014-4-1
				if(execCode.length>2){
					if (execCode.substr(0,2)=="##" && execCode.indexOf("class(")>0 && execCode.indexOf(".")>0) {
						execCode=execCode.substr(2);
						//alert(execCode);
					}
				}
				
				dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/filterfunccfg.csp?action=save&id='+id+'&code='+code+'&funcPrototype='+funcPrototype+'&execCode='+execCode+'&funcDesc='+funcDesc);
				//filterFuncStore.proxy.setUrl(encodeURI('dhcwl/kpi/filterfunccfg.csp?action=lookup&start=0&pageSize=15'));
				//filterFuncStore.load();
				pagingBar.cursor=0;
                pagingBar.doLoad(pagingBar.pageSize*(cursor-1));
			}
		},'-',{
			//text:'清空',
			text: '<span style="line-Height:1">清空</span>',
			icon: '../images/uiimages/clearscreen.png',
			handler:function(){
				var form = filterFuncForm.getForm();
				form.setValues({FilterFuncID:'',FilterFuncCode:'',FilterFuncPrototype:'',FilterFuncExecCode:'',FilterFuncFuncDesc:''});
				//++modify by wz.2014-4-22
				Ext.getCmp('FilterFuncPrototype').enable();
			}
		},'-',{
			//text:'查询',
			text: '<span style="line-Height:1">查询</span>',
			icon: '../images/uiimages/search.png',
			handler:function(){
				var code=Ext.getCmp('FilterFuncCode').getValue();
				var funcPrototype=Ext.getCmp('FilterFuncPrototype').getValue();
				var execCode=Ext.getCmp('FilterFuncExecCode').getValue();
				var funcDesc=Ext.getCmp('FilterFuncFuncDesc').getValue();
				if (execCode.match(/\#/)) {
					execCode=execCode.substring(2,execCode.length);
				}
				filterFuncStore.removeAll();
				var paraValues='&code='+code+'&funcPrototype='+funcPrototype+'&execCode='+execCode+'&funcDesc='+funcDesc;
				lastParaValue=paraValues;
				filterFuncStore.proxy.setUrl(encodeURI('dhcwl/kpi/filterfunccfg.csp?action=lookup&start=0&pageSize=15'+paraValues));
				filterFuncStore.load();
			}
		}
		])
	});
	
	var filterFuncPanel = new Ext.Panel({
		id:'filterFuncPanel',
		//title:'系统配置',
		//collapsible: false,
		monitorResize:true,
		//frame:true,
		layout:'table',
		layoutConfig:{columns:1},
		items:[{
			height:155,
			items:filterFuncForm
		},{
			height:450,
			items:filterFuncGrid
		}]
	});
	
	this.ReLoad=function() {
		filterFuncPanel.doLayout();
	}
	this.InitPanelSize = function() {
		if ((!!filterFuncPanel)&&(!!filterFuncForm)&&(!!filterFuncGrid)) {
			var parentWidth = filterFuncPanel.getWidth();
			//alert(filterFuncGrid.getWidth()+'之后'+parentWidth);
			filterFuncForm.setWidth(parentWidth-10);
			filterFuncGrid.setWidth(parentWidth-10);
		}
	}
	
	this.GetFilterFuncPanel = function(){
		filterFuncStore.load();
		return filterFuncPanel;
	}
	
}