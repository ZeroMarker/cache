dhcwl.mkpi.ExecCodeCfg = function(){
	
	//*************************************************************过滤函数维护*********************************************************//
	var lastParaValue="";
	//		定义grid列模型
	var excCodeColumnModel = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{header:'ID',dataIndex:'ID',sortable:true,width:50,menuDisabled : true},
		{header:'类型',dataIndex:'ExecCodeType',sortable:true,menuDisabled : true,width:60},
		{header:'执行代码子类',dataIndex:'ExecCodeSubType',sortable:true,menuDisabled : true,width:100},
		{header:'默认执行<br>代码',dataIndex:'ExecCodeDefaultFlag',sortable:true,menuDisabled : true,width:80},
		{header:'执行代码',dataIndex:'ExecCodewrite',sortable:true,menuDisabled : true,width:410},
		{header:'版本号',dataIndex:'ExecCodeVersion',sortable:true,menuDisabled : true,width:70},
		{header:'示例',dataIndex:'ExecCodeCall',sortable:true,menuDisabled : true,width:90,hidden:true},
		{header:'创建\更新日期',dataIndex:'ExecCodeCUDate',sortable:true,menuDisabled : true,width:110,hidden:true},
		{header:'创建者',dataIndex:'ExecCodeCreator',sortable:true,menuDisabled : true,width:90},
		{header:'是否使用<br>Global',dataIndex:'ExecCodeGlobalFlag',sortable:true,menuDisabled : true,width:30,hidden:true},
		{header:'适用范围',dataIndex:'ExecCodeApplicable',sortable:true,menuDisabled : true,width:160,hidden:true},
		{header:'说明',dataIndex:'ExecCodeDescription',sortable:true,menuDisabled : true,width:30,hidden:true}
		
		
	]);
	
	//		定义grid数据源
	var excCodeStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/sysexecutecodecfg.csp?action=lookup&start=0&pageSize=10'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'ID'},
				{name:'ExecCodeType'},
				{name:'ExecCodewrite'},
				{name:'ExecCodeVersion'},
				{name:'ExecCodeCall'},
				{name:'ExecCodeCUDate'},
				{name:'ExecCodeCreator'},
				{name:'ExecCodeGlobalFlag'},
				{name:'ExecCodeApplicable'},
				{name:'ExecCodeDescription'},
				{name:'ExecCodeSubType'},
				{name:'ExecCodeDefaultFlag'}
			]
		})
	});
	
	var pagingBar = new Ext.PagingToolbar({
		pageSize:10,
		store:excCodeStore,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到第 {1} 条记录，一共 {2} 条',
		emptyMsg:'sorry,data not found!',
		listeners :{
			'beforechange':function(pt,page){
				//alert(pagingBar.getPageData().activePage);
				//var currentPage=pagingBar.getPageData().activePage;
				excCodeStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysexecutecodecfg.csp?action=lookup'+lastParaValue));
			}
		}
	});
	
	var excCodeRecord = new Ext.data.Record.create([
		{name:'ID',type: 'string'},
		{name:'ExecCodeType',type: 'string'},
		{name:'ExecCodewrite',type: 'string'},
		{name:'ExecCodeVersion',type: 'string'},
		{name:'ExecCodeCall',type: 'string'},
		{name:'ExecCodeCUDate',type: 'string'},
		{name:'ExecCodeCreator',type: 'string'},
		{name:'ExecCodeGlobalFlag',type: 'string'},
		{name:'ExecCodeApplicable',type: 'string'},
		{name:'ExecCodeDescription',type: 'string'},
		{name:'ExecCodeSubType',type: 'string'},
		{name:'ExecCodeDefaultFlag',type: 'string'}
	]);
	
	var type="";	//根据执行代码类型，获取执行代码子类型数据列表。
	
	//		定义grid样式
	var excCodeGrid = new Ext.grid.GridPanel({
		//title:'执行代码列表',
		id:'excCodeGrid',
		//autoScroll:true,
		frame:true,
		store:excCodeStore,
		//monitorResize:true,
		//width:960,
		height:355,
		columnLines: true,
		/*viewConfig:{
			//autoFill:true
			markDirty :false,
			forceFit: true
		},*/
		cm:excCodeColumnModel,
		sm:new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            	'rowselect': function(sm, row, rec){
            		var id=rec.get("ID");
            		var form=excCodeForm.getForm();
            		
            		
            		var description=rec.get("ExecCodeDescription");
            		description=description.replace(/\<br\/\>/gi, '\n');
            		rec.set("ExecCodeDescription",description);
            		
					form.loadRecord(rec);
					form.setValues({ID:id});
					
					var ID=Ext.getCmp('ID1').getValue();
					if (ID){
						//Ext.getCmp('ExecCodewrite').disable();
						Ext.getCmp('ExecCodeType').disable();
						Ext.getCmp('ExecCodeSubType').disable();
					}
					
					
					
					type = Ext.getCmp('ExecCodeType').getValue();
					//--add by wz.2014-4-10
					/*
					if ('KPI'==type) {
						subTypeStore.proxy.conn.url = 'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo';
					}else if ('DIM'==type) {
						subTypeStore.proxy.conn.url = 'dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo';
					}else{
						subTypeStore.proxy.conn.url = 'dhcwl/kpi/kpiservice.csp?action=getSectionCombo';
					}
					subTypeStore.reload();
					*/
					
					//++add by wz.2014-4-10
					if ('KPI'==type) {
						subTypeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'}); 
					}else if ('DIM'==type) {
						subTypeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo'}); 
					}else{
						subTypeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getSectionCombo'}); 
					}
					subTypeStore.reload();		

				}
            }
        }),
		bbar:pagingBar /*,
		listeners:{
			'contextmenu':function(event){
				event.preventDefault();
				quickMenu.showAt(event.getXY());
			}
		}*/
	});
	
	var isGlobalStruct = new Ext.form.ComboBox({
		editable:false,
		name:'ExecCodeGlobalFlag',
		id:'ExecCodeGlobalFlag',
		width:80,
		mode:'local',
		fieldLabel:'使用global',
		triggerAction:'all',
		displayField:'displayValue',
		valueField:'realValue',
		store:new Ext.data.JsonStore({
			fields:['displayValue','realValue'],
			data:[{
				displayValue:'是',
				realValue:'Y'
			},{
				displayValue:'否',
				realValue:'N'
			}]
		}),
		listeners:{
			'select':function(combox){
				Ext.getCmp('ExecCodeGlobalFlag').setValue(combox.getValue());
			}
		}
	});
	
	var excCodeType = new Ext.form.ComboBox({
		xtype : 'combo',
		editable:false,
		name:'ExecCodeType',
		id:'ExecCodeType',
		width:100,
		fieldLabel:'类型',
		triggerAction : 'all',
		mode:'remote',
		displayField : 'typeName',
		valueField : 'typeCode',
		store : new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/sysexecutecodecfg.csp?action=getExecuteCodeType'}),
			reader:new Ext.data.ArrayReader({},[{name:'typeName'},{name:'typeCode'}])
		}),
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{typeName}' +   
			'</div>'+   
			'</tpl>',			
		listeners:{
			'select':function(combox){
				excCodeType.setValue(combox.getValue());
				excCodeSubType.setValue();
				type = excCodeType.getValue();
				//++add by wz.2014-3-31
				if ('KPI'==type) {
					//subTypeStore.proxy.conn.url = 'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'; //--mofidy by wz.2014-4-1
					subTypeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiflCombo'}); 
				}else if ('DIM'==type) {
					//subTypeStore.proxy.conn.url = 'dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo';//--mofidy by wz.2014-4-1
					subTypeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getKpiDimCombo'}); 
					
				}else{
					//subTypeStore.proxy.conn.url = 'dhcwl/kpi/kpiservice.csp?action=getSectionCombo';//--mofidy by wz.2014-4-1
					subTypeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/kpiservice.csp?action=getSectionCombo'}); 
					
				}
				subTypeStore.reload();
			}
		}
	});
	
	var subTypeStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/sysexecutecodecfg.csp?action='}),
		reader:new Ext.data.ArrayReader({},[{name:'subTypeCode'},{name:'subTypeName'}]),
		listeners:{
			'load':function(){
				var value=Ext.getCmp('ExecCodeSubType').getValue();
				if (value!="")	excCodeSubType.setValue(value);
			}
			
		}
	});
	
	var excCodeSubType = new Ext.form.ComboBox({
		xtype : 'combo',
		editable:false,
		name:'ExecCodeSubType',
		id:'ExecCodeSubType',
		width:80,
		triggerAction : 'all',
		mode:'remote',
		fieldLabel:'子类型',
		displayField : 'subTypeName',
		valueField : 'subTypeCode',
		store : subTypeStore,
		tpl:'<tpl for=".">' +   
			'<div class="x-combo-list-item" style="height:18px;">' +   
			'{subTypeName}' +   
			'</div>'+   
			'</tpl>',			
		listeners:{
			'select':function(combox){

				excCodeSubType.setValue(combox.getValue());
			},
			//++add by wz.2014-3-31
			'beforequery' : function(  queryEvent ){
				type = excCodeType.getValue();
				if (''==type) {
					Ext.MessageBox.alert("提示","请先选择执行代码的‘类型’！");
					return false;
				}else return true;				
			}
		}
	});
	
	//		定义Form表单
	/*var excCodeForm = new Ext.FormPanel({
		//title:'执行代码维护',
		id:'excCodeForm',
		//height:280,
		layout:'table',
		autoScroll:true,
		loadMask: true,
		columnLines: true,
		viewConfig:{forceFit: true},
		layoutConfig:{columns:10},
		items:[{
			html:'ID：',
			width:60
		},{
			width:80,
			xtype:'textfield',
			name:'ID',
			id:'ID',
			disabled:true
		},{
			html:'创建/修改日期：'
		},{
			width:130,
			xtype:'datefield',
			//format:'Y-m-d',
			name:'ExecCodeCUDate',
			id:'ExecCodeCUDate'
		},{
			html:'创建/修改者：'
		},{
			xtype:'textfield',
			width:80,
			name:'ExecCodeCreator',
			id:'ExecCodeCreator'
		},{
			html:'是否使用Global：'
		},isGlobalStruct,{
			html:'版本：',
			width:40
		},{
			width:60,
			xtype:'textfield',
			name:'ExecCodeVersion',
			id:'ExecCodeVersion'
		},{
			html:'类型：'
		},excCodeType,{
			html:'执行代码子类型：'
		},excCodeSubType,{
			html:'默认执行代码标志：'
		},{
			xtype:'combo',
			editable:false,
			name:'ExecCodeDefaultFlag',
			id:'ExecCodeDefaultFlag',
			width:80,
			mode:'local',
			triggerAction:'all',
			displayField:'displayValue',
			valueField:'realValue',
			tpl:'<tpl for=".">' +   
				'<div class="x-combo-list-item" style="height:12px;">' +   
				'{displayValue}' +   
				'</div>'+   
				'</tpl>',				
			store:new Ext.data.JsonStore({
				fields:['displayValue','realValue'],
				data:[{
					displayValue:'是',
					realValue:'Y'
				},{
					displayValue:'否',
					realValue:'N'
				}]
			}),
			listeners:{
				'select':function(combox){
					Ext.getCmp('ExecCodeDefaultFlag').setValue(combox.getValue());
				}
			}
		},{
			html:'',
			colspan:4
		},{
			html:'适用范围：',
			colspan:10
		},{
			html:''
		},{
			width:600,
			xtype:'textfield',
			name:'ExecCodeApplicable',
			id:'ExecCodeApplicable',
			colspan:10
		},{
			html:'执行代码：',
			colspan:10
		},{
			html:''
		},{
			width:600,
			xtype:'textfield',
			emptyText:'##class(ClassName).MethodName 或者 MethodName^MacFileName',
			name:'ExecCodewrite',
			//disabled:true,
			id:'ExecCodewrite',
			colspan:10,
			listeners:{
				'change':function(){
					var value=Ext.getCmp('ExecCodewrite').getValue();
					if (-1==value.search(/\^/)) {
						Ext.getCmp('ExecCodeCall').setValue(value+'()');
					}else{
						Ext.getCmp('ExecCodeCall').setValue('s monthId=$$'+value+'()');
					}
				}
			}
		},{
			html:'示例：',
			colspan:10
		},{
			html:''
		},{
			width:600,
			xtype:'textfield',
			name:'ExecCodeCall',
			id:'ExecCodeCall',
			disabled:true,
			colspan:10
		},{
			html:'说明：',
			colspan:10
		},{
			html:''
		},{
			width:600,
			height:60,
			xtype:'textarea',
			name:'ExecCodeDescription',
			id:'ExecCodeDescription',
			colspan:10
		}],*/
	var excCodeForm = new Ext.FormPanel({
    	frame : true,
		//height : 145,
		autoScroll:true,
		bodyStyle:'padding:5px',
		labelAlign : 'right',
		labelWidth : 90,
		style : {
			"margin-right" : Ext.isIE6? (Ext.isStrict ? "-10px" : "-13px"): "0"
		},
		items : [{
			layout : 'column',
			items : [{ 
				columnWidth : .25,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 100
				},
				items : [{
							fieldLabel : 'ID',
							xtype:'textfield',
							name:'ID',
							id:'ID1',
							disabled:true
						},{
							fieldLabel : '修改日期',
							xtype:'datefield',
							name:'ExecCodeCUDate',
							id:'ExecCodeCUDate',
							format:GetWebsysDateFormat()
						},{
							fieldLabel : '创建者',
							xtype:'textfield',
							name:'ExecCodeCreator',
							id:'ExecCodeCreator'
						},excCodeType,excCodeSubType,isGlobalStruct]
			},{ 
				columnWidth : .7,
				layout : 'form',
				defaultType : 'textfield',
				defaults : {
					width : 500
				},
				items : [{
							fieldLabel : '版本',
							xtype:'textfield',
							width:120,
							name:'ExecCodeVersion',
							id:'ExecCodeVersion'
						},{
							fieldLabel : '默认激活',
							xtype:'combo',
							editable:false,
							name:'ExecCodeDefaultFlag',
							id:'ExecCodeDefaultFlag',
							width:120,
							mode:'local',
							triggerAction:'all',
							displayField:'displayValue',
							valueField:'realValue',
							tpl:'<tpl for=".">' +   
								'<div class="x-combo-list-item" style="height:18px;">' +   
								'{displayValue}' +   
								'</div>'+   
								'</tpl>',				
							store:new Ext.data.JsonStore({
								fields:['displayValue','realValue'],
								data:[{
									displayValue:'是',
									realValue:'Y'
								},{
									displayValue:'否',
									realValue:'N'
								}]
							}),
							listeners:{
								'select':function(combox){
									Ext.getCmp('ExecCodeDefaultFlag').setValue(combox.getValue());
								}
							}
						},{
							fieldLabel : '适用范围',
							xtype:'textfield',
							name:'ExecCodeApplicable',
							id:'ExecCodeApplicable'
						},{
							fieldLabel : '执行代码',
							xtype:'textfield',
							emptyText:'##class(ClassName).MethodName 或者 MethodName^MacFileName',
							name:'ExecCodewrite',
							//disabled:true,
							id:'ExecCodewrite',
							colspan:10,
							listeners:{
								'change':function(){
									var value=Ext.getCmp('ExecCodewrite').getValue();
									if (-1==value.search(/\^/)) {
										Ext.getCmp('ExecCodeCall').setValue(value+'()');
									}else{
										Ext.getCmp('ExecCodeCall').setValue('s monthId=$$'+value+'()');
									}
								}
							}
						},{
							fieldLabel : '示例',
							xtype:'textfield',
							name:'ExecCodeCall',
							id:'ExecCodeCall',
							disabled:true
						},{
							fieldLabel : '说明',
							xtype:'textarea',
							height:25,
							name:'ExecCodeDescription',
							id:'ExecCodeDescription'
						}]
			}]
		}],
		tbar:new Ext.Toolbar([{
			//text:'新增',
			text: '<span style="line-Height:1">新增</span>',
			icon: '../images/uiimages/edit_add.png',
			handler:function(){
				var form = excCodeForm.getForm();
				var date=dhcwl.mkpi.Util.nowDate();
				form.setValues({ID:'',ExecCodeType:'',ExecCodewrite:'',ExecCodeVersion:'',ExecCodeCall:'',ExecCodeCUDate:'',ExecCodeCreator:'',ExecCodeGlobalFlag:'',ExecCodeApplicable:'',ExecCodeDescription:'',ExecCodeSubType:'',ExecCodeDefaultFlag:''});
				var initV={ExecCodeType:'',ExecCodewrite:'',ExecCodeVersion:'',ExecCodeCall:'',ExecCodeCUDate:date,ExecCodeCreator:'',ExecCodeGlobalFlag:'',ExecCodeApplicable:'',ExecCodeDescription:'',ExecCodeSubType:'',ExecCodeDefaultFlag:''};
				excCodeStore.insert(0,new excCodeRecord(initV));
				excCodeGrid.getSelectionModel().selectFirstRow();
				//Ext.getCmp('ExecCodewrite').enable();
				//++add by wz.2014-4-22
				Ext.getCmp('ExecCodeType').enable();
				Ext.getCmp('ExecCodeSubType').enable();
			}
		},'-',{
			//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
			handler:function(){
				var cursor=Math.ceil((pagingBar.cursor + pagingBar.pageSize) / pagingBar.pageSize);
				var sm = excCodeGrid.getSelectionModel();
                var record = sm.getSelected();
                if(!sm||!record){
               		Ext.MessageBox.alert("保存","请选中要保存的执行代码行！");
               		return;
                }
				var ID=Ext.getCmp('ID1').getValue();
				var ExecCodeType=Ext.getCmp('ExecCodeType').getValue();
				var ExecCodewrite=Ext.getCmp('ExecCodewrite').getValue();
				var ExecCodeVersion=Ext.getCmp('ExecCodeVersion').getValue();
				var ExecCodeCall=Ext.getCmp('ExecCodeCall').getValue();
				var ExecCodeCUDate=Ext.get('ExecCodeCUDate').getValue();	//这里用getCmp()获取到的日期格式非Year-Month-Day格式
				var ExecCodeCreator=Ext.getCmp('ExecCodeCreator').getValue();
				var ExecCodeGlobalFlag=Ext.getCmp('ExecCodeGlobalFlag').getValue();
				var ExecCodeApplicable=Ext.getCmp('ExecCodeApplicable').getValue();
				var ExecCodeDescription=Ext.getCmp('ExecCodeDescription').getValue();
				ExecCodeDescription=ExecCodeDescription.replace(/\r\n/gi, '<br/>').replace(/\n/gi, '<br/>');
				
				var ExecCodeSubType=Ext.getCmp('ExecCodeSubType').getValue();
				var ExecCodeDefaultFlag=Ext.getCmp('ExecCodeDefaultFlag').getValue();
				if (!ExecCodeType || !ExecCodewrite ){
					Ext.MessageBox.alert("保存","需要您指定类型和执行代码！");
               		return;
				}
				if (!ExecCodeSubType){
					Ext.MessageBox.alert("保存","需要您指定子类型！");
               		return;
				}
				if (ExecCodeDescription.length>100 || ExecCodeApplicable.length>100) {
                	Ext.Msg.alert("提示","操作失败：'适用范围'或'说明'的描述不能超过100个字符！")
                	return;
                }
                
				var paraValues='&ExecCodeType='+ExecCodeType+'&ExecCodewrite='+ExecCodewrite+'&ExecCodeVersion='+ExecCodeVersion+'&ExecCodeCall='+ExecCodeCall+'&ExecCodeCUDate='+ExecCodeCUDate+'&ExecCodeCreator='+ExecCodeCreator+'&ExecCodeGlobalFlag='+ExecCodeGlobalFlag+'&ExecCodeApplicable='+ExecCodeApplicable+'&ExecCodeDescription='+ExecCodeDescription+'&ExecCodeSubType='+ExecCodeSubType+'&ExecCodeDefaultFlag='+ExecCodeDefaultFlag;
				/*
				if (!ID){
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysexecutecodecfg.csp?action=add&ID='+ID+paraValues);
				}else{
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysexecutecodecfg.csp?action=update&ID='+ID+paraValues);
				}
				
				excCodeStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysexecutecodecfg.csp?action=lookup'));
            	excCodeStore.load();
				*/    //--modify by wz.2014-3-26
				var url="";
				if (!ID) url='dhcwl/kpi/sysexecutecodecfg.csp?action=add&ID='+ID+paraValues;
				else url='dhcwl/kpi/sysexecutecodecfg.csp?action=update&ID='+ID+paraValues;
				
				 dhcwl.mkpi.Util.ajaxExc(url,null,function(jsonData){
						if(jsonData.success==true && jsonData.tip=="ok"){
							//excCodeStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysexecutecodecfg.csp?action=lookup&&start=0&pageSize=10')); 
			            	//excCodeStore.reload();
							Ext.Msg.alert("提示","操作成功！");
						}else{
							Ext.Msg.alert("失败",jsonData.tip);
							}
							
						},this);					

				//Ext.getCmp('ExecCodewrite').disable();
				pagingBar.cursor=0;
                pagingBar.doLoad(pagingBar.pageSize*(cursor-1));
			}
		},'-',{
			//text:'清空',
			text: '<span style="line-Height:1">清空</span>',
			icon: '../images/uiimages/clearscreen.png',
			handler:function(){
				var form = excCodeForm.getForm();
				form.setValues({ID:'',ExecCodeType:'',ExecCodewrite:'',ExecCodeVersion:'',ExecCodeCall:'',ExecCodeCUDate:'',ExecCodeCreator:'',ExecCodeGlobalFlag:'',ExecCodeApplicable:'',ExecCodeDescription:'',ExecCodeSubType:'',ExecCodeDefaultFlag:''});
				//++add by wz.2014-4-22
				Ext.getCmp('ExecCodeType').enable();
				Ext.getCmp('ExecCodeSubType').enable();			
			}
		},'-',{
			//text:'查询',
			text: '<span style="line-Height:1">查询</span>',
			icon: '../images/uiimages/search.png',
			handler:function(){
				var ExecCodeType=Ext.getCmp('ExecCodeType').getValue();
				var ExecCodewrite=Ext.getCmp('ExecCodewrite').getValue();
				var ExecCodeVersion=Ext.getCmp('ExecCodeVersion').getValue();
				var ExecCodeCall=Ext.getCmp('ExecCodeCall').getValue();
				var ExecCodeCUDate=Ext.get('ExecCodeCUDate').getValue();
				var ExecCodeCreator=Ext.getCmp('ExecCodeCreator').getValue();
				var ExecCodeGlobalFlag=Ext.getCmp('ExecCodeGlobalFlag').getValue();
				var ExecCodeApplicable=Ext.getCmp('ExecCodeApplicable').getValue();
				var ExecCodeDescription=Ext.getCmp('ExecCodeDescription').getValue();
				var ExecCodeSubType=Ext.getCmp('ExecCodeSubType').getValue();
				var ExecCodeDefaultFlag=Ext.getCmp('ExecCodeDefaultFlag').getValue();
				var paraValues='&ExecCodeType='+ExecCodeType+'&ExecCodewrite='+ExecCodewrite+'&ExecCodeVersion='+ExecCodeVersion+'&ExecCodeCall='+ExecCodeCall+'&ExecCodeCUDate='+ExecCodeCUDate+'&ExecCodeCreator='+ExecCodeCreator+'&ExecCodeGlobalFlag='+ExecCodeGlobalFlag+'&ExecCodeApplicable='+ExecCodeApplicable+'&ExecCodeDescription='+ExecCodeDescription+'&ExecCodeSubType='+ExecCodeSubType+'&ExecCodeDefaultFlag='+ExecCodeDefaultFlag;
				lastParaValue=paraValues;
				excCodeStore.removeAll();
				
				//++add by wz.2014-4-3
				//excCodeStore.proxy=new Ext.data.HttpProxy({url:'dhcwl/kpi/sysexecutecodecfg.csp?action=lookup&start=0&pageSize=10'+paraValues}); 
				
				excCodeStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysexecutecodecfg.csp?action=lookup&start=0&pageSize=10'+paraValues));
            	excCodeStore.load();
				//Ext.getCmp('ExecCodewrite').disable();
			}
		}])
	});
	
	var excCodePanel = new Ext.Panel({
		id:'excCodePanel',
		//title:'系统配置',
		monitorResize:true,
		layout:'table',
		layoutConfig:{columns:1},
		items:[{
			//region:'north',
			height:245,
			items:excCodeForm
		},{
			//region:'center',
			height:345,
			autoScroll:true,
			items:excCodeGrid
		}]
	});
	
	this.ReLoad=function() {
		excCodePanel.doLayout();
	}
	
	this.InitPanelSize = function() {
		if ((!!excCodePanel)&&(!!excCodeForm)&&(!!excCodeGrid)) {
			var parentWidth = excCodePanel.getWidth();
			//alert(excCodeGrid.getWidth()+'之后'+parentWidth);
			excCodeForm.setWidth(parentWidth-10);
			excCodeGrid.setWidth(parentWidth-10);
		}
	}
	
	this.GetExcCodePanel = function(){
		excCodeStore.load();
		return excCodePanel;
	}
	
}