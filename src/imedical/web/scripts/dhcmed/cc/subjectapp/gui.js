function InitViewport1(){
	var obj = new Object();
	obj.BtnNew = new Ext.Button({
		id : 'BtnNew'
		,iconCls : 'icon-new'
		,anchor : '95%'
		,text : '新建'
});
	obj.BtnEdit = new Ext.Button({
		id : 'BtnEdit'
		,iconCls : 'icon-edit'
		,anchor : '95%'
		,text : '编辑'
});
	obj.BtnDelete = new Ext.Button({
		id : 'BtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.ColsBtnUpdate = new Ext.Button({
		id : 'ColsBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '列表属性'
});
	obj.SubBtnUpdate = new Ext.Button({
		id : 'SubBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '监控项目'
});
	obj.FormPanel2 = new Ext.form.FormPanel({
		id : 'FormPanel2'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '监控主题应用'
		,region : 'north'
		,frame : true
		,height : 100
		,items:[
		]
	,	buttons:[
			obj.BtnNew
			,obj.BtnEdit
			,obj.BtnDelete
			,obj.ColsBtnUpdate
			,obj.SubBtnUpdate
		]
	});
	obj.SAGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SAGridPanelStore = new Ext.data.Store({
		proxy: obj.SAGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'SACode', mapping: 'SACode'}
			,{name: 'SADesc', mapping: 'SADesc'}
			,{name: 'SASubjectDr', mapping: 'SASubjectDr'}
			,{name: 'SAShowScore', mapping: 'SAShowScore'}
			,{name: 'SAShowDr', mapping: 'SAShowDr'}
			,{name: 'SAResume', mapping: 'SAResume'}
			,{name: 'SASubjectDrDesc', mapping: 'SASubjectDrDesc'}
			,{name: 'SAShowDrDesc', mapping: 'SAShowDrDesc'}
		])
	});
	obj.SAGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SAGridPanel = new Ext.grid.GridPanel({
		id : 'SAGridPanel'
		,store : obj.SAGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'SACode', sortable: true}
			,{header: '描述', width: 150, dataIndex: 'SADesc', sortable: true}
			,{header: '监控主题字典', width: 100, dataIndex: 'SASubjectDrDesc', sortable: true}
			,{header: '显示分值', width: 70, dataIndex: 'SAShowScore', sortable: true}
			,{header: '主题展现字典', width: 100, dataIndex: 'SAShowDrDesc', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'SAResume', sortable: true}
		]
		, tbar: [{
            iconCls: 'icon-new',
            text: '新建',
            handler: function(){
             	obj.BtnNew_click(obj);	
            }
        },{
        	iconCls: 'icon-edit',
        	text: '编辑',
        	handler: function(){
             	obj.BtnEdit_click(obj);	
            }
        },{
        	iconCls: 'icon-delete',
        	text: '删除',
        	handler: function(){
             	obj.BtnDelete_click(obj);	
            }
        },{
        	iconCls: 'icon-update',
        	text: '列表属性',
        	handler: function(){
             	obj.ColsBtnUpdate_click(obj);	
            }
        },{
        	iconCls: 'icon-update',
        	text: '监控项目',
        	handler: function(){
             	obj.SubBtnUpdate_click(obj);	
            }
        }]	
		});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			//obj.FormPanel2,
			obj.SAGridPanel
		]
	});
	obj.SAGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'QuerySubAppInfo';
			param.ArgCnt = 0;
	});
	obj.SAGridPanelStore.load({});
	InitViewport1Event(obj);
	//事件处理代码
  	obj.LoadEvent(arguments);
  return obj;
}

//*****************************监控主题应用维护窗口********************************************
function InitSAWindow(){
	var obj = new Object();
	obj.SASubjectDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SASubjectDrStore = new Ext.data.Store({
		proxy: obj.SASubjectDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'SDDesc', mapping: 'SDDesc'}
		])
	});
	
	obj.SAShowDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SAShowDrStore = new Ext.data.Store({
		proxy: obj.SAShowDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'SDDesc', mapping: 'SDDesc'}
		])
	});
	obj.SAWPanel4 = new Ext.Panel({
		id : 'SAWPanel4'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.SACode = new Ext.form.TextField({
		id : 'SACode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.SADesc = new Ext.form.TextField({
		id : 'SADesc'
		,fieldLabel : '描述'
		,anchor : '95%'
});
	obj.SASubjectDr = new Ext.form.ComboBox({
		id : 'SASubjectDr'
		,store : obj.SASubjectDrStore
		,valueField : 'rowid'
		,displayField : 'SDDesc'
		,fieldLabel : '监控主题'
		,editable : true
		,anchor : '95%'
		,forceSelection : true
		,triggerAction : 'all'
});
	obj.SAShowScore = new Ext.form.NumberField({
		id : 'SAShowScore'
		,fieldLabel : '显示分值'
		,anchor : '95%'
});
	obj.SAShowDr = new Ext.form.ComboBox({
		id : 'SAShowDr'
		,store : obj.SAShowDrStore
		,valueField : 'rowid'
		,displayField : 'SDDesc'
		,editable : true
		,fieldLabel : '展现模式'
		,forceSelection : true
		,anchor : '95%'
		,triggerAction : 'all'
});
	obj.SAResume = new Ext.form.TextField({
		id : 'SAResume'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.SARowid = new Ext.form.TextField({
		id : 'SARowid'
		,hidden : true
});
	obj.SAWPanel5 = new Ext.Panel({
		id : 'SAWPanel5'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.SACode
			,obj.SADesc
			,obj.SASubjectDr
			,obj.SAShowScore
			,obj.SAShowDr
			,obj.SAResume
			,obj.SARowid
		]
	});
	obj.SAWPanel6 = new Ext.Panel({
		id : 'SAWPanel6'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.SAWPanel3 = new Ext.Panel({
		id : 'SAWPanel3'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.SAWPanel4
			,obj.SAWPanel5
			,obj.SAWPanel6
		]
	});
	obj.SABtnSave = new Ext.Button({
		id : 'SABtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.SABtnExit = new Ext.Button({
		id : 'SABtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	obj.SubjectAppFPanel = new Ext.form.FormPanel({
		id : 'SubjectAppFPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,items:[
			obj.SAWPanel3
		]
	,	buttons:[
			obj.SABtnSave
			,obj.SABtnExit
		]
	});
	obj.SAWindow = new Ext.Window({
		id : 'SAWindow'
		,height : 250
		,buttonAlign : 'center'
		,width : 400
		,title : '监控主题维护'
		,layout : 'fit'
		,items:[
			obj.SubjectAppFPanel
		]
	});
	
	obj.SASubjectDrStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
		param.QueryName = 'QuerySubjectDicInfo';
		param.ArgCnt = 0;
	});
	obj.SAShowDrStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
		param.QueryName = 'QueryShowDicInfo';
		param.ArgCnt = 0;
	});
	obj.SASubjectDrStore.load({});
	obj.SAShowDrStore.load({});
	InitSAWindowEvent(obj);
	//事件处理代码
	obj.SABtnSave.on("click", obj.SABtnSave_click, obj);
	obj.SABtnExit.on("click", obj.SABtnExit_click, obj);
  	obj.LoadEvent(arguments);
  return obj;
}

//*******************监控主题应用列表属性**************************************

function InitSubAppCWindow(){
	var obj = new Object();
	obj.sSARowid = new Ext.form.TextField({
		id : 'sSARowid'
		,hidden : true
});
	obj.SACBtnSave = new Ext.Button({
		id : 'SACBtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.SACBtnExit = new Ext.Button({
		id : 'SACBtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	var fm = Ext.form;
	    obj.SACIsHideStore = new Ext.data.SimpleStore({
		fields : ['YesNoDesc','YesNoCode'],
		data : 
		[['Y','Y'],['N','N']]
	});
	
	var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true // columns are not sortable by default           
        },
        columns: [
            /*{
                id: 'SACParref',
                header: '主题应用',
                dataIndex: 'SACParref',
                width: 220,
                // use shorthand alias defined above
                editor: new fm.TextField({
                    allowBlank: false
                })
            },*/
             {
                header: '列名称',
                dataIndex: 'SACName',
                width: 120
            }, {
                header: '列描述',
                dataIndex: 'SACDesc',
                width: 200,
      			editor: new fm.TextField({
                    allowBlank: false
                })
            }, {
                header: '是否隐藏',
                dataIndex: 'SACIsHide',
                width: 60,
          		editor: new fm.ComboBox({
          			id : 'cSACIsHide'
          			,name : 'cSACIsHide'
          			,typeAhead: true
          			,triggerAction: 'all'
          			,lazyRender: true
					,store : obj.SACIsHideStore
					,displayField : 'YesNoDesc'
					,valueField : 'YesNoCode'
					,editable : false
					,mode: 'local'
                })
            }, {
                header: '宽度',
                dataIndex: 'SACWidth',
                width: 50,
          		editor: new fm.NumberField({
                    allowBlank: false,
                    allowNegative: false,
                    maxValue: 100000
                })
            }, {
                header: '是否排序',
                dataIndex: 'SACIsSort',
                width: 60,
    			editor: new fm.ComboBox({
          			id : 'cSACIsSort'
          			,name : 'cSACIsSort'
          			,typeAhead: true
          			,triggerAction: 'all'
          			,lazyRender: true
					,store : obj.SACIsHideStore
					,displayField : 'YesNoDesc'
					,valueField : 'YesNoCode'
					,editable : false
					,mode: 'local'
                })
            }, {
                header: '列序号',
                dataIndex: 'SACIndex',
                width: 50,
          		editor: new fm.TextField({
                    allowBlank: false
                })
            }
        ]
    });
	obj.SACEditGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SACEditGridPanelStore = new Ext.data.Store({
		autoDestroy: true,
		proxy: obj.SACEditGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SACName'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SACParref', mapping: 'SACParref'}
			,{name: 'SADesc', mapping: 'SADesc'}
			,{name: 'SACName', mapping: 'SACName'}
			,{name: 'SACDesc', mapping: 'SACDesc'}
			,{name: 'SACIsHide', mapping: 'SACIsHide'}
			,{name: 'SACWidth', mapping: 'SACWidth'}
			,{name: 'SACIsSort', mapping: 'SACIsSort'}
			,{name: 'SACIndex', mapping: 'SACIndex'}
		])
	});

	obj.SACEditGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });

	obj.SACEditGridPanel = new Ext.grid.EditorGridPanel({
		id : 'SACEditGridPanel'
		,store : obj.SACEditGridPanelStore
		,cm : cm
		,region : 'center'
		,buttonAlign : 'center'
		,title : '列表属性'
		,frame: true
		,clicksToEdit: 1
});
	obj.SACEditGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'QuerySubjectAppCols';
			param.Arg1 = obj.sSARowid.getValue();
			param.ArgCnt = 1;
	});
	obj.SACEditGridPanelStore.load({
	params : {
		start:0
		,limit:20
	}});
	obj.SubAppCWindow = new Ext.Window({
		id : 'SubAppCWindow'
		,height : 400
		,buttonAlign : 'center'
		,width : 600
		,layout : 'fit'
		,items:[
			obj.SACEditGridPanel
		]	
		,	buttons:[
			obj.SACBtnSave
			,obj.SACBtnExit
		]
	});
	InitSubAppCWindowEvent(obj);
	//事件处理代码
	obj.SACBtnSave.on("click", obj.SACBtnSave_click, obj);
	obj.SACBtnExit.on("click", obj.SACBtnExit_click, obj);
  	obj.LoadEvent(arguments);
  return obj;
}

//******************监控主题应用监控项目维护窗口***********************************

function InitSASWindow(){
	var obj = new Object();
	obj.SASGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SASGridPanelStore = new Ext.data.Store({
		proxy: obj.SASGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SASRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SASRowid', mapping: 'SASRowid'}
			,{name: 'SASItemDr', mapping: 'SASItemDr'}
			,{name: 'SASItemDrDesc', mapping: 'SASItemDrDesc'}
			,{name: 'SASItemType', mapping: 'SASItemType'}
			,{name: 'SASItemTypeDesc', mapping: 'SASItemTypeDesc'}
			,{name: 'SASItemScore', mapping: 'SASItemScore'}
			,{name: 'SASLocDr', mapping: 'SASLocDr'}
			,{name: 'SASLocDrDesc', mapping: 'SASLocDrDesc'}
			,{name: 'SASGroupDr', mapping: 'SASGroupDr'}
			,{name: 'SASGroupDrDesc', mapping: 'SASGroupDrDesc'}
			,{name: 'SASResume', mapping: 'SASResume'}
		])
	});
	obj.SASGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SASGridPanel = new Ext.grid.GridPanel({
		id : 'SASGridPanel'
		,store : obj.SASGridPanelStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '监控项目', width: 100, dataIndex: 'SASItemDrDesc', sortable: true}
			,{header: '项目类型', width: 70, dataIndex: 'SASItemTypeDesc', sortable: true}
			,{header: '项目分值', width: 70, dataIndex: 'SASItemScore', sortable: true}
			,{header: '科室', width: 100, dataIndex: 'SASLocDrDesc', sortable: true}
			,{header: '安全组', width: 100, dataIndex: 'SASGroupDrDesc', sortable: true}
			,{header: '备注', width: 150, dataIndex: 'SASResume', sortable: true}
		]});
	obj.SASPanel8 = new Ext.Panel({
		id : 'SASPanel8'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.SASItemDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SASItemDrStore = new Ext.data.Store({
		proxy: obj.SASItemDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
		])
	});
	obj.SASItemDr = new Ext.form.ComboBox({
		id : 'SASItemDr'
		,minChars : 0
		,displayField : 'IDDesc'
		,fieldLabel : '监控项目'
		,store : obj.SASItemDrStore
		,forceSelection : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.SASItemTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SASItemTypeStore = new Ext.data.Store({
		proxy: obj.SASItemTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicCode', mapping: 'DicCode'}
		])
	});
	obj.SASItemType = new Ext.form.ComboBox({
		id : 'SASItemType'
		,minChars : 1
		,displayField : 'DicDesc'
		,fieldLabel : '项目类型'
		,store : obj.SASItemTypeStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,forceSelection : true
		,valueField : 'rowid'
});
	obj.SASItemScore = new Ext.form.NumberField({
		id : 'SASItemScore'
		,fieldLabel : '项目分值'
		,anchor : '95%'
});
	obj.SASLocDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SASLocDrStore = new Ext.data.Store({
		proxy: obj.SASLocDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'CtDesc', mapping: 'CtDesc'}
		])
	});
	obj.SASLocDr = new Ext.form.ComboBox({
		id : 'SASLocDr'
		,store : obj.SASLocDrStore
		,displayField : 'CtDesc'
		,minChars : 1
		,fieldLabel : '分科监控'
		,valueField : 'rowid'
		,triggerAction : 'all'
		,forceSelection : true
		,anchor : '95%'
});
	obj.SASGroupDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SASGroupDrStore = new Ext.data.Store({
		proxy: obj.SASGroupDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'SSGDesc', mapping: 'SSGDesc'}
		])
	});
	obj.SASGroupDr = new Ext.form.ComboBox({
		id : 'SASGroupDr'
		,minChars : 1
		,displayField : 'SSGDesc'
		,fieldLabel : '分组监控'
		,store : obj.SASGroupDrStore
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
		,forceSelection : true
});
	obj.SASResume = new Ext.form.TextField({
		id : 'SASResume'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.SASRowid = new Ext.form.TextField({
		id : 'SASRowid'
		,hidden : true
});
	obj.SAID = new Ext.form.TextField({
		id : 'SAID'
		,hidden : true
});
	obj.SASPanel9 = new Ext.Panel({
		id : 'SASPanel9'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.SASItemDr
			,obj.SASItemType
			,obj.SASItemScore
			,obj.SASLocDr
			,obj.SASGroupDr
			,obj.SASResume
			,obj.SASRowid
			,obj.SAID
		]
	});
	obj.SASPanel10 = new Ext.Panel({
		id : 'SASPanel10'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.SASFormPanel = new Ext.form.FormPanel({
		id : 'SASFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 180
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.SASPanel8
			,obj.SASPanel9
			,obj.SASPanel10
		]
	});
	obj.SASBtnSave = new Ext.Button({
		id : 'SASBtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.SASBtnDelete = new Ext.Button({
		id : 'SASBtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.SASBtnExit = new Ext.Button({
		id : 'SASBtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	obj.SASWindow = new Ext.Window({
		id : 'SASWindow'
		,height : 500
		,buttonAlign : 'center'
		,width : 600
		,modal : true
		,title : '监控项目维护'
		,layout : 'border'
		,items:[
			obj.SASGridPanel
			,obj.SASFormPanel
		]
	,	buttons:[
			obj.SASBtnSave
			,obj.SASBtnDelete
			,obj.SASBtnExit
		]
	});
	obj.SASGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'QuerySubAppSubInfo';
			param.Arg1 = obj.SAID.getValue();
			param.ArgCnt = 1;
	});
	obj.SASGridPanelStore.load({});
	obj.SASItemDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'FindItemDicInfo';
			param.Arg1 = obj.SASItemDr.getRawValue();
			param.ArgCnt = 1;
	});
	obj.SASItemDrStore.load({});
	obj.SASItemTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'QueryDicInfoFromType';
			param.Arg1 = 'SASITEMTYPE';
			param.ArgCnt = 1;
	});
	obj.SASItemTypeStore.load({});
	obj.SASLocDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'FindCtlocInfoFromDesc';
			param.Arg1 = obj.SASLocDr.getRawValue();
			param.ArgCnt = 1;
	});
	obj.SASLocDrStore.load({});
	obj.SASGroupDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectAppSrv';
			param.QueryName = 'FindSSGroupInfoFromDesc';
			param.Arg1 = obj.SASGroupDr.getRawValue();
			param.ArgCnt = 1;
	});
	obj.SASGroupDrStore.load({});
	InitSASWindowEvent(obj);
	//事件处理代码
	obj.SASGridPanel.on("rowclick", obj.SASGridPanel_rowclick, obj);
	obj.SASBtnSave.on("click", obj.SASBtnSave_click, obj);
	obj.SASBtnDelete.on("click", obj.SASBtnDelete_click, obj);
	obj.SASBtnExit.on("click", obj.SASBtnExit_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}