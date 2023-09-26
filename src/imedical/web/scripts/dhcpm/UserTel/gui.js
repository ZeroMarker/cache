//Create by zzp
// 20150427
//医院联系方式
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.TelText	= new Ext.form.TextField({
		id : 'TelText'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '联系方式'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.TelLoc = new Ext.form.TextField({
		id : 'TelLoc'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.TelUser = new Ext.form.TextField({
		id : 'TelUser'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '用户'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.TelEmail = new Ext.form.TextField({
		id : 'TelEmail'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '电子邮件'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.TelAdd = new Ext.Button({
		id : 'TelAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.TelUpdate = new Ext.Button({
		id : 'TelUpdate'
		,iconCls : 'icon-update'
		,text : '修改'
	});
	obj.TelQuery = new Ext.Button({
		id : 'TelQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.TelBatch = new Ext.Button({
		id : 'TelBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/**增改**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.TelAdd, '-', obj.TelUpdate]
		});
	/** 搜索工具条 */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('用户：'),obj.TelUser,'-',new Ext.Toolbar.TextItem('联系方式：'),obj.TelText,'-',new Ext.Toolbar.TextItem('科室：'),obj.TelLoc,'-',new Ext.Toolbar.TextItem('电子邮件：'),obj.TelEmail,'-',obj.TelQuery,'-',obj.TelBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.TelGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	obj.TelGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.TelGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'TelGridStoreQuery';
			param.Arg1 = Ext.getCmp('TelText').getValue()+"^"+Ext.getCmp('TelLoc').getValue()+"^"+Ext.getCmp('TelEmail').getValue();
			param.ArgCnt = 1;
	});
	obj.TelGridStore = new Ext.data.Store({
		proxy: obj.TelGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record'
			,totalProperty: 'total'
			,fields:[{
			name: 'TelGridRowid',
			mapping: 'TelGridRowid'
			},{
			name: 'TelGridName',
			mapping: 'TelGridName'
			},{
			name: 'TelGridLoc',
			mapping: 'TelGridLoc'
			},{
			name: 'TelGridTel', 
			mapping: 'TelGridTel'
			},{
			name: 'TelGridEmail',
			mapping: 'TelGridEmail'
			},{
			name: 'TelGridbz',
			mapping: 'TelGridbz'
			}]
		})
	});
	obj.gridTelCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.TelGridPanel = new Ext.grid.GridPanel({
		id : 'TelGridPanel'
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
		,plugins : obj.gridTelCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.TelGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.gridTelCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'TelGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '用户名称', width : 200, dataIndex : 'TelGridName', sortable : false, align : 'center',editable: true }
			, { header : '用户科室', width : 200, dataIndex : 'TelGridLoc', sortable : false ,align : 'center'}
			, { header : '联系方式', width : 300, dataIndex : 'TelGridTel', sortable : true, align : 'center' }
			, { header : '电子邮件', width : 150, dataIndex : 'TelGridEmail',sortable : true,align : 'center' }
			, { header : '备注', width : 150, dataIndex : 'TelGridbz',align : 'center'}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.TelGridStore,
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
	obj.TelPanal=new Ext.Panel({
			id : 'TelPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.TelGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.TelPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.TelGridStore.removeAll();
	obj.TelGridStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
function TelMenuWind(){
    var obj = new Object();
	obj.TelRowid= new Ext.form.TextField({
		id : 'TelRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'TelRowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.TelFlag	= new Ext.form.TextField({
		id : 'TelFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'TelFlag'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.TelMenuText	= new Ext.form.TextField({
		id : 'TelMenuText'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '联系方式'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.TelMenuEmail = new Ext.form.TextField({
		id : 'TelMenuEmail'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '电子邮件'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.TelMenuAdd = new Ext.Button({
		id : 'TelMenuAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.TelMenuDelete = new Ext.Button({
		id : 'TelMenuDelete'
		,iconCls : 'icon-delete'
		,text : '取消'
	});
	obj.TelMenuName= new Ext.form.TextField({
		id : 'TelMenuName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '用户名称'
		//,editable : true
		,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.TelMenubz = new Ext.form.TextArea({
		id : 'TelMenubz'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '备注'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
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
		     obj.TelRowid
			,obj.TelMenuName
			,obj.TelFlag
			,obj.TelMenuText 
			,obj.TelMenuEmail
		    ,obj.TelMenubz
		]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 350
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '联系方式'
		,layout : 'border'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.TelMenuAdd
			  ,obj.TelMenuDelete
		]
	});
	TelMenuWindEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}