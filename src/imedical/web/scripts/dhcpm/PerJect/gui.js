//Create by zzp
// 20150427
//项目维护
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.JectName= new Ext.form.TextField({
		id : 'JectName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '项目名称'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.JectHosp = new Ext.form.TextField({
		id : 'JectHosp'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '医院'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.JectCode = new Ext.form.TextField({
		id : 'JectCode'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '项目编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.JectUser = new Ext.form.TextField({
		id : 'JectUser'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '项目经理'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.JectAdd = new Ext.Button({
		id : 'JectAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.JectUpdate = new Ext.Button({
		id : 'JectUpdate'
		,iconCls : 'icon-update'
		,text : '修改'
	});
	obj.JectQuery = new Ext.Button({
		id : 'JectQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.JectBatch = new Ext.Button({
		id : 'JectBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/**增改**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.JectAdd, '-', obj.JectUpdate]
		});
	/** 搜索工具条 */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('项目名称：'),obj.JectName,'-',new Ext.Toolbar.TextItem('医院：'),obj.JectHosp,'-',new Ext.Toolbar.TextItem('编码：'),obj.JectCode,'-',new Ext.Toolbar.TextItem('项目经理：'),obj.JectUser,'-',obj.JectQuery,'-',obj.JectBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.JectGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	
    obj.JectGridStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=JectGridStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['JectGridRowid','JectGridName','JectGridHosName','JectGridUser','JectGridUserZL','JectGridCode','JectGridType','JectGridDel','JectGridDelDD','JectGridTel','JectGridDate','JectGridCreatUser','JectGridbz'])
    	});
	obj.gridJectCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.JectGridPanel = new Ext.grid.GridPanel({
		id : 'JectGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridJectCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.JectGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.gridJectCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'JectGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '项目名称', width : 200, dataIndex : 'JectGridName', sortable : false, align : 'center',editable: true }
			, { header : '医院名称', width : 200, dataIndex : 'JectGridHosName', sortable : false ,align : 'center'}
			, { header : '项目经理', width : 300, dataIndex : 'JectGridUser', sortable : true, align : 'center' }
			, { header : '项目助理', width : 150, dataIndex : 'JectGridUserZL',sortable : true,align : 'center' }
			, { header : '项目编码', width : 150, dataIndex : 'JectGridCode',align : 'center'}
			, { header : '有效状态', width : 150, dataIndex : 'JectGridType',sortable : true,align : 'center' }
			, { header : '项目地址', width : 150, dataIndex : 'JectGridDel',sortable : true,align : 'center' }
			, { header : '办公地点', width : 150, dataIndex : 'JectGridDelDD',sortable : true,align : 'center' }
			, { header : '办公电话', width : 150, dataIndex : 'JectGridTel',sortable : true,align : 'center' }
			, { header : '创建时间', width : 150, dataIndex : 'JectGridDate',sortable : true,align : 'center' }
			, { header : '创建用户', width : 150, dataIndex : 'JectGridCreatUser',sortable : true,align : 'center' }
			, { header : '备注', width : 150, dataIndex : 'JectGridbz',sortable : true,align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.JectGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
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
	obj.JectPanal=new Ext.Panel({
			id : 'JectPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,title:'项目维护'
			,items:[obj.JectGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.JectPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.JectGridStore.removeAll();
	obj.JectGridStore.load();
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
function JectMenuWind(){
    var obj = new Object();
	obj.JectHosStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=JectHosStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
    obj.JectUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=JectUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.JectPerTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=JectPerType'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
    obj.JectHosStore.load();
	obj.JectUserStore.load();
	obj.JectPerTypeStore.load();
	obj.AUJectRowid= new Ext.form.TextField({
		id : 'AUJectRowid'
		,width : 40
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectFlag	= new Ext.form.TextField({
		id : 'AUJectFlag'
		,width : 40
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '操作类型'
		//,editable : true
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectName= new Ext.form.TextField({
		id : 'AUJectName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '项目名称'
		//,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectCode = new Ext.form.TextField({
		id : 'AUJectCode'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '项目编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.AUJectHosName= new Ext.form.ComboBox({
		id : 'AUJectHosName'
		,width : 100
		//,minChars : 1
		,fieldLabel : '医院名称'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.JectHosStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectUser= new Ext.form.ComboBox({
		id : 'AUJectUser'
		,width : 100
		//,minChars : 1
		,fieldLabel : '项目经理'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.JectUserStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectUserZL= new Ext.form.ComboBox({
		id : 'AUJectUserZL'
		,width : 100
		//,minChars : 1
		,fieldLabel : '项目助理'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.JectUserStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectType= new Ext.form.ComboBox({
		id : 'AUJectType'
		,width : 100
		//,minChars : 1
		,fieldLabel : '项目状态'
		,mode : 'local'
		//triggerAction : 'all', 
	    ,store : obj.JectPerTypeStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectDel= new Ext.form.TextField({
		id : 'AUJectDel'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '项目地址'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectDD= new Ext.form.TextField({
		id : 'AUJectDD'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '办公地点'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectTel= new Ext.form.TextField({
		id : 'AUJectTel'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '办公电话'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectBZ = new Ext.form.TextArea({
		id : 'AUJectBZ'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '备注'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AUJectAdd = new Ext.Button({
		id : 'AUJectAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.AUJectDelete = new Ext.Button({
		id : 'AUJectDelete'
		,iconCls : 'icon-delete'
		,text : '取消'
	});
	obj.winTPanelMenu = new Ext.Panel({
		id : 'winTPanelMenu'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{3,0,0,0}'
		//,height:'80%'
		//,title : '用户详情'
		,layout : 'form'
		,region : 'center'
		,labelWidth:60
		,frame : true
		,items:[
		     obj.AUJectRowid
			,obj.AUJectFlag
			,obj.AUJectName
			,obj.AUJectCode 
			,obj.AUJectHosName
		    ,obj.AUJectUser
			,obj.AUJectUserZL
			,obj.AUJectType
			,obj.AUJectDel
			,obj.AUJectDD
			,obj.AUJectTel
			,obj.AUJectBZ
		]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 480
		,buttonAlign : 'center'
		,width : 470
		,modal : true
		,title : '项目明细'
		,layout : 'border'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.AUJectAdd
			  ,obj.AUJectDelete
		]
	});
	JectMenuWindEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}