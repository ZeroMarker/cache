//Create by zzp
// 20150518
//合同进程管理（工期）
function InitviewScreen(){
	var obj = new Object();
	 obj.CAgingContractStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAgingContractStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CAgingContractStore.load();
	obj.CAgingAgingStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAgingAgingStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CAgingAgingStore.load();
	//******************************Start****************************
	obj.CAgingContract = new Ext.form.ComboBox({
		id : 'CAgingContract'
		,width : 180
		,store : obj.CAgingContractStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '选择合同'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAgingAging = new Ext.form.ComboBox({
		id : 'CAgingAging'
		,width : 80
		,store : obj.CAgingAgingStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '选择工期'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAgingCode= new Ext.form.TextField({
		id : 'CAgingCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '工期编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAgingDesc= new Ext.form.TextField({
		id : 'CAgingDesc'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '工期名称'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAgingHrowid= new Ext.form.TextField({
		id : 'CAgingHrowid'
		,width : 30
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'rowid'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAgingAdd = new Ext.Button({
		id : 'CAgingAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.CAgingUpdate = new Ext.Button({
		id : 'CAgingUpdate'
		,iconCls : 'icon-update'
		,text : '修改'
	});
	obj.CAgingQuery = new Ext.Button({
		id : 'CAgingQuery' 
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.CAgingBatch = new Ext.Button({
		id : 'CAgingBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/** 搜索工具条 */
	obj.tb = new Ext.Toolbar({
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('选择合同：'),obj.CAgingContract,'-',new Ext.Toolbar.TextItem('选择工期：'),obj.CAgingAging,'-',new Ext.Toolbar.TextItem('工期编码：'),obj.CAgingCode,'-',new Ext.Toolbar.TextItem('工期描述：'),obj.CAgingDesc,'-',obj.CAgingQuery,'-',obj.CAgingBatch,'-',obj.CAgingAdd,'-',obj.CAgingUpdate,obj.CAgingHrowid]
			});
	
	//****************************** End ****************************
	//***************下一个条件start****************
	obj.CAgingModeCode= new Ext.form.TextField({
		id : 'CAgingModeCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '模块编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAgingModeDesc= new Ext.form.TextField({
		id : 'CAgingModeDesc'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '模块描述'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAgingModeAdd = new Ext.Button({
		id : 'CAgingModeAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.CAgingModeUpdate = new Ext.Button({
		id : 'CAgingModeUpdate'
		,iconCls : 'icon-update'
		,text : '修改'
	});
	obj.CAgingModeQuery = new Ext.Button({
		id : 'CAgingModeQuery' 
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.CAgingModeBatch = new Ext.Button({
		id : 'CAgingModeBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/** 搜索工具条 */
	obj.tbMode = new Ext.Toolbar({
				id : 'tbMode',
				items : [new Ext.Toolbar.TextItem('模块编码：'),obj.CAgingModeCode,'-',new Ext.Toolbar.TextItem('模块名称：'),obj.CAgingModeDesc,'-',obj.CAgingModeQuery,'-',obj.CAgingModeBatch,'-',obj.CAgingModeAdd,'-',obj.CAgingModeUpdate]
			});
	//***************end****************************

	obj.CAgingGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.CAgingGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'QueryContractAging';
			param.Arg1 = Ext.getCmp('CAgingContract').getValue();
			param.Arg2 = Ext.getCmp('CAgingAging').getValue();
			param.Arg3 = Ext.getCmp('CAgingCode').getValue();
			param.Arg4 = Ext.getCmp('CAgingDesc').getValue();
			param.ArgCnt = 4;
	});
	obj.CAgingGridStore = new Ext.data.Store({
		proxy: obj.CAgingGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[{
			name: 'CAgingGRowid', 
			mapping: 'CAgingGRowid'
			},{
			name: 'CAgingGContract', 
			mapping: 'CAgingGContract'
			},{
			name: 'CAgingGContractid',
			mapping: 'CAgingGContractid'
			},{
			name: 'CAgingGAging', 
			mapping: 'CAgingGAging'
			},{
			name: 'CAgingGAgingid',
			mapping: 'CAgingGAgingid'
			},{
			name: 'CAgingGCode',
			mapping: 'CAgingGCode'
			},{
			name: 'CAgingGDesc',
			mapping: 'CAgingGDesc'
			},{
			name: 'CAgingGStatus',
			mapping: 'CAgingGStatus'
			},{
			name: 'CAgingGStatusid',
			mapping: 'CAgingGStatusid'
			},{
			name: 'CAgingGPlanStartDate',
			mapping: 'CAgingGPlanStartDate'
			},{
			name: 'CAgingGPlanStartTime',
			mapping: 'CAgingGPlanStartTime'
			},{
			name: 'CAgingGStartDate',
			mapping: 'CAgingGStartDate'
			},{
			name: 'CAgingGStartTime',
			mapping: 'CAgingGStartTime'
			},{
			name: 'CAgingGPlanEndDate',
			mapping: 'CAgingGPlanEndDate'
			},{
			name: 'CAgingGPlanEndTime',
			mapping: 'CAgingGPlanEndTime'
			},{
			name: 'CAgingGEndDate',
			mapping: 'CAgingGEndDate'
			},{
			name: 'CAgingGEndTime',
			mapping: 'CAgingGEndTime'
			},{
			name: 'CAgingGCreatUser',
			mapping: 'CAgingGCreatUser'
			},{
			name: 'CAgingGCreatDate',
			mapping: 'CAgingGCreatDate'
			},{
			name: 'CAgingGCreatTime',
			mapping: 'CAgingGCreatTime'
			},{
			name: 'CAgingGRemark',
			mapping: 'CAgingGRemark'
			}]
		})
	});
	obj.gridCAgingCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.CAgingGridPanel = new Ext.grid.GridPanel({
		id : 'CAgingGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		//,width : 1100
		,region : 'north'
		//,width:600
		,bodystyle:"width:100%"
		,bodystyle:"width:100%"
		,overflow:'auto'
		,autoScroll:true
		,title:'合同工期管理'
		//,autoWidth:true
		,collapsible: true
		,height: 220
		,minHeight: 200
        ,maxHeight: 300
		,plugins : obj.gridCAgingCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,editable: true
		,store : obj.CAgingGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridCAgingCheckCol
			, { header : 'Rowid', width : 80, dataIndex : 'CAgingGRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '合同名称', width : 200, dataIndex : 'CAgingGContract', sortable : false, align : 'center',editable: true }
			, { header : '合同名称id', width : 100, dataIndex : 'CAgingGContractid', hidden: true ,sortable : false, align : 'center',editable: true }
			, { header : '工期', width : 100, dataIndex : 'CAgingGAging', sortable : false ,align : 'center'}
			, { header : '工期id', width : 100, dataIndex : 'CAgingGAgingid', hidden: true ,sortable : false ,align : 'center'}
			, { header : '工期编码', width : 100, dataIndex : 'CAgingGCode', sortable : true, align : 'center' }
			, { header : '工期名称', width : 100, dataIndex : 'CAgingGDesc',sortable : true,align : 'center' }
			, { header : '工期状态', width : 100, dataIndex : 'CAgingGStatus',sortable : true,align : 'center' }
			, { header : '工期状态id', width : 100, dataIndex : 'CAgingGStatusid',hidden: true ,sortable : true,align : 'center' }
			, { header : '计划开始日期', width : 100, dataIndex : 'CAgingGPlanStartDate',align : 'center'}
			, { header : '计划开始时间', width : 100, dataIndex : 'CAgingGPlanStartTime',sortable : true,align : 'center' }
			, { header : '实际开始日期', width : 100, dataIndex : 'CAgingGStartDate',sortable : true,align : 'center' }
			, { header : '实际开始时间', width : 100, dataIndex : 'CAgingGStartTime',sortable : true,align : 'center' }
			, { header : '计划结束日期', width : 100, dataIndex : 'CAgingGPlanEndDate',sortable : true,align : 'center' }
			, { header : '计划结束时间', width : 100, dataIndex : 'CAgingGPlanEndTime',sortable : true,align : 'center'}
			, { header : '实际结束日期', width : 100, dataIndex : 'CAgingGEndDate',sortable : true,align : 'center' }
			, { header : '实际结束时间', width : 100, dataIndex : 'CAgingGEndTime',sortable : true,align : 'center'}
			, { header : '创建人', width : 100, dataIndex : 'CAgingGCreatUser',sortable : true,align : 'center' }
			, { header : '创建日期', width : 100, dataIndex : 'CAgingGCreatDate',sortable : true,align : 'center'}
			, { header : '创建时间', width : 100, dataIndex : 'CAgingGCreatTime',sortable : true,align : 'center' }
			, { header : '备注', width : 150, dataIndex : 'CAgingGRemark',sortable : true,align : 'center'}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 10,
			store : obj.CAgingGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2} 条记录',
			displayInfo: true,
			emptyMsg: '没有记录'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//forceFit: true   // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化（比如你resize了它）时不会自动调整column的宽度
            scrollOffset: 0   //不加这个的话，会在grid的最右边有个空白，留作滚动条的位置
			,enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	//--------------------------------------------------------------------
	
	obj.CAgingModuleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.CAgingModuleStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'QueryCAgingModule';
			param.Arg1 = Ext.getCmp('CAgingModeCode').getValue();
			param.Arg2 = Ext.getCmp('CAgingModeDesc').getValue();
			param.Arg3 = Ext.getCmp('CAgingHrowid').getValue();
			param.ArgCnt = 3;
	});
	obj.CAgingModuleStore = new Ext.data.Store({
		proxy: obj.CAgingModuleStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:['ContractModeRowid'
		            ,'ContractModeCode'
		            ,'ContractModeDesc'
		            ,'ContractModeStandby3'
		            ,'ContractModeProduct'
		            ,'ContractModeAging'
		            ,'ContractModeStatus'
		            ,'ContractModePlanDate'
		            ,'ContractModePlanTime'
		            ,'ContractModeActDate'
		            ,'ContractModeActTime'
		            ,'ContractModeRemark']
		})
	});
	obj.CAgingModuleCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.CAgingModulePanel = new Ext.grid.GridPanel({
		id : 'CAgingModulePanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		,collapsible: true
		,region:'center'
		,autoWidth:true
		,bodystyle:"width:100%"
		,bodystyle:"height:100%"
		,title:'工期模块管理'
		,plugins : obj.CAgingModuleCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.CAgingModuleStore
		,tbar:obj.tbMode
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.CAgingModuleCheckCol
			, { header : 'Rowid', width : 150, dataIndex : 'ContractModeRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '模块编码', width : 100, dataIndex : 'ContractModeCode', sortable : false, align : 'center',editable: true }
			, { header : '模块名称', width : 100, dataIndex : 'ContractModeDesc', sortable : false ,align : 'center'}
			, { header : '产品', width : 100, dataIndex : 'ContractModeStandby3', sortable : true, align : 'center' }
			, { header : '产品组', width : 100, dataIndex : 'ContractModeProduct',sortable : true,align : 'center' }
			, { header : '工期', width : 100, dataIndex : 'ContractModeAging',sortable : true,align : 'center' }
			, { header : '模块状态', width : 100, dataIndex : 'ContractModeStatus',sortable : true,align : 'center'}
			, { header : '计划日期', width : 100, dataIndex : 'ContractModePlanDate', sortable : true, align : 'center' }
			, { header : '计划时间', width : 100, dataIndex : 'ContractModePlanTime', sortable : true, align : 'center' }
			, { header : '实际日期', width : 100, dataIndex : 'ContractModeActDate', sortable : true, align : 'center' }
			, { header : '实际时间', width : 100, dataIndex : 'ContractModeActTime', sortable : true, align : 'center' }
			, { header : '备注信息', width : 100, dataIndex : 'ContractModeRemark', sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.CAgingModuleStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}条记录',
			displayInfo: true,
			emptyMsg: '没有记录'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			forceFit: true // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化（比如你resize了它）时不会自动调整column的宽度
            ,scrollOffset: 0 //不加这个的话，会在grid的最右边有个空白，留作滚动条的位置
			,enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	//--------------------------------------------------------------------
	obj.CAgingPanal=new Ext.Panel({
			id : 'CAgingPanal'
			,layout : 'form'
			,title:'合同工期管理'
		    ,bodystyle:"width:100%"
		    ,autoScroll:true
			,overflow:'auto'
			//,width : 1200
		    //,height: 200
			,frame:true
			,region : 'center'
			//,collapsible: true
			//,border:true
			,items:[obj.CAgingGridPanel]
		});
	obj.CAgingPanalMoude=new Ext.Panel({
			id : 'CAgingPanalMoude'
			,layout : 'fit'
			,width : '100%'
			,region:"center" 
			,title:'工期模块管理'
			//,width : 1200
		   // ,height: 500
			//,collapsible: true
			,border:true
			,items:[obj.CAgingModulePanel]
		});
	obj.CAgingPanalTol=new Ext.Panel({
			id : 'CAgingPanalTol'
			,layout : 'form'
			,width : '100%'
			,region:"center" 
			//,width : 1200
		    //,height: 800
			//,collapsible: true
			,border:true
			,items:[obj.CAgingPanal,obj.CAgingPanalMoude]
		});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		//,width : '100%'
		//,height: 800
	    ,layout : 'border'
		,items : [obj.CAgingGridPanel,obj.CAgingModulePanel]
		});
	
	//--------------------------------------------------------------------------------------------
	obj.CAgingGridStore.removeAll();
	obj.CAgingGridStore.load({params : {start:0,limit:10}});
	obj.CAgingModuleStore.removeAll();
	obj.CAgingModuleStore.load({params : {start:0,limit:10}});
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
//创建工期明细新增、更新小窗口
function ContractAgingWind(){
    var obj = new Object();
	obj.CAStratusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAStratusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CAContractStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAgingContractStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CAAgingStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAgingAgingStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CAContractStore.load();
	obj.CAAgingStore.load();
	obj.CAStratusStore.load();
	obj.CAAddRowid= new Ext.form.TextField({
		id : 'CAAddRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.CAAddFlag= new Ext.form.TextField({
		id : 'CAAddFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '操作类型'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAContractName= new Ext.form.ComboBox({
		id : 'CAContractName'
		,width : 100
		,mode:'local'
		,minChars : 1
		,store:obj.CAContractStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '合同名称'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAAgingName= new Ext.form.ComboBox({
		id : 'CAAgingName'
		,width : 100
		,minChars : 1
		,store:obj.CAAgingStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '合同工期'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CACode = new Ext.form.TextField({
		id : 'CACode'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '工期编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CADesc = new Ext.form.TextField({
		id : 'CADesc'
		,width : 100
		//,store : obj.cboLocStore
		//,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '工期名称'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAStatus= new Ext.form.ComboBox({
		id : 'CAStatus'
		,width : 100
		,minChars : 1
		,store:obj.CAStratusStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '工期状态'
		,valueNotFoundText : ''
		,editable : true
		//,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAPlanStartDate = new Ext.form.DateField({
		id : 'CAPlanStartDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '计开日期'
		,emptyText:'请选择日期'
	    ,format:'Y-m-d'
	    //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAPlanStratTime = new Ext.form.TimeField({
		id : 'CAPlanStratTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '计开时间'
		,renderTo: Ext.get('times') 
	    //,emptyText:'请选择时间'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,invalidText:'请选择时间或输入有效格式的时间'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAStartDate = new Ext.form.DateField({
		id : 'CAStartDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '实开日期'
		//,emptyText:'请选择日期'
	    ,format:'Y-m-d'
	   // ,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAStartTime = new Ext.form.TimeField({
		id : 'CAStartTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '实开时间'
		,renderTo: Ext.get('times') 
	    //,emptyText:'请选择时间'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,invalidText:'请选择时间或输入有效格式的时间'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAPlanEndDate = new Ext.form.DateField({
		id : 'CAPlanEndDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '计完日期'
		,emptyText:'请选择日期'
	    ,format:'Y-m-d'
	    //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAPlanEndTime = new Ext.form.TimeField({
		id : 'CAPlanEndTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '计完时间'
		,renderTo: Ext.get('times') 
	    //,emptyText:'请选择时间'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,invalidText:'请选择时间或输入有效格式的时间'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAEndDate = new Ext.form.DateField({
		id : 'CAEndDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '实完日期'
		//,emptyText:'请选择日期'
	    ,format:'Y-m-d'
	    //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CAEndTime = new Ext.form.TimeField({
		id : 'CAEndTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '实完时间'
		,renderTo: Ext.get('times') 
	    //,emptyText:'请选择时间'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,invalidText:'请选择时间或输入有效格式的时间'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CARemark = new Ext.form.TextArea({
		id : 'CARemark'
		,width : 100
		,minChars : 1
		,height : 115
		,displayField : 'desc'
		,fieldLabel : '备注'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAAdd = new Ext.Button({
		id : 'CAAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.CADelete = new Ext.Button({
		id : 'CADelete'
		,iconCls : 'icon-delete'
		,text : '取消'
	});
	obj.winTPanelMenu = new Ext.form.FormPanel({
		id : 'winTPanelMenu'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,autoHeight : true
        ,autoWidth : true
		,layout : 'form'
		,hideLabel:false
		,labelAlign : "right"
		,labelWidth:60
		,frame : true
		,items:[{   // 行1
                layout : "column",         // 从左往右的布局
                items : [{
                          columnWidth : .5       // 该列有整行中所占百分比
                          ,layout : "form"       // 从上往下的布局
                          ,items : [obj.CAAddRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CAAddFlag]
                         }]
                },{ // 行2
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CAContractName]
                         }]
                },{ // 行3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CACode]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CADesc]
                         }]
                },{ // 行4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAAgingName]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CAStatus]
                         }]
                },{ // 行5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAPlanStartDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CAPlanStratTime]
                         }]
                },{ // 行6
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAStartDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CAStartTime]
                         }]
                },{ // 行7
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAPlanEndDate]
                         },{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAPlanEndTime]
                         }]
                },{ // 行8
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAEndDate]
                         },{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CAEndTime]
                         }]
                },{ // 行9
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CARemark]
                         }]
			    }]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 425
		,buttonAlign : 'center'
		,width : 500
		,modal : true
		,title : '工期明细'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.CAAdd
			  ,obj.CADelete
		]
	});
	ContractAgingWindEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
//创建工期模块新增、更新小窗口
function ContractAgingModeWind(){
    var obj = new Object();
	obj.CAModeRowid = new Ext.form.TextField({
		id : 'CAModeRowid'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,disabled:true
		//,valueField : 'rowid'
	});
	obj.CAModeNStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CAModeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CAModeNStore.load();
	//obj.CAModeNStore.load({params : {Rowid:Ext.getCmp('CAModeRowid').getValue()}});
	obj.CAModeFlag = new Ext.form.TextField({
		id : 'CAModeFlag'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '操作类型'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,disabled:true
		//,valueField : 'rowid'
	});
	obj.CAAgingModeName= new Ext.form.ComboBox({
		id : 'CAAgingModeName'
		,width : 100
		,minChars : 1
		,store:obj.CAModeNStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '合同模块'
		,valueNotFoundText : ''
		,editable : true
		//,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAAgingModeRemark = new Ext.form.TextArea({
		id : 'CAAgingModeRemark'
		,width : 100
		,minChars : 1
		,height : 115
		,displayField : 'desc'
		,fieldLabel : '备注信息'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CAModeAdd = new Ext.Button({
		id : 'CAModeAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.CAModeDelete = new Ext.Button({
		id : 'CADelete'
		,iconCls : 'icon-delete'
		,text : '取消'
	});
	obj.winTPanelMenu = new Ext.form.FormPanel({
		id : 'winTPanelMenu'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,autoHeight : true
        ,autoWidth : true
		,layout : 'form'
		,hideLabel:false
		,labelAlign : "right"
		,labelWidth:60
		,frame : true
		,items:[{   // 行1
                layout : "column",         // 从左往右的布局
                items : [{
                          columnWidth : .5       // 该列有整行中所占百分比
                          ,layout : "form"       // 从上往下的布局
                          ,items : [obj.CAModeRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CAModeFlag]
                         }]
                },{ // 行2
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CAAgingModeName]
                         }]
                },{
				layout : "column",
				items :[{
				         columnWidth :1
						 ,layout : "form"
						 ,items : [obj.CAAgingModeRemark]
				       }]
				}]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 285
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '工期模块明细'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.CAModeAdd
			  ,obj.CAModeDelete
		]
	});
	ContractAgingModeWindEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}