function InitViewport1(){
	var obj = new Object();
	obj.HCType = new Ext.form.TextField({
		id : 'HCType'
		,fieldLabel : '类型'
		,disabled : true
});
	obj.HCCode = new Ext.form.TextField({
		id : 'HCCode'
		,fieldLabel : ExtToolSetting.RedStarString+'代码'
		,allowBlank : false
});
	obj.HCDesc = new Ext.form.TextField({
		id : 'HCDesc'
		,fieldLabel : ExtToolSetting.RedStarString+'描述'
		,allowBlank : false
});
	obj.HCRemark = new Ext.form.TextField({
		id : 'HCRemark'
		,fieldLabel : '备注'
});
  obj.HCMonths = new Ext.form.NumberField({
		id : 'HCMonths'
		,fieldLabel : '随访间隔(月)'
});
	obj.HCExpandCode = new Ext.form.TextField({
		id : 'HCExpandCode'
		,fieldLabel : '扩展'
});
	
	obj.HCActive = new Ext.form.Checkbox({
		id : 'HCActive'
		,checked : true
		,fieldLabel : '激活'
});
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
});
	obj.B_Save = new Ext.Button({
		id : 'B_Save'
		,iconCls : 'icon-save'
		,text : '保存'
});
	obj.B_Clear = new Ext.Button({
		id : 'B_Clear'
		,iconCls : 'icon-new'
		,text : '清空'
});
	obj.FormPanelLeft = new Ext.Panel({
		columnWidth:0.5
		,items:[obj.HCType,obj.HCDesc,obj.HCMonths,obj.HCActive,obj.Rowid]
		,layout : 'form'
	});
	obj.FormPanelRight = new Ext.Panel({
		columnWidth:0.5
		,items:[obj.HCCode,obj.HCRemark,obj.HCExpandCode]
		,layout : 'form'
	});
	obj.FormPanel14 = new Ext.form.FormPanel({
		id : 'FormPanel14'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 160
		,region : 'north'
		,frame : true
		,layout:'column'
		,items:[
			obj.FormPanelLeft
			,obj.FormPanelRight
			
		]
	,	buttons:[
			obj.B_Save
			,obj.B_Clear
		]
	});
	obj.GridPanel4StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanel4Store = new Ext.data.Store({
		proxy: obj.GridPanel4StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'HCCode', mapping: 'HCCode'}
			,{name: 'HCDesc', mapping: 'HCDesc'}
			,{name: 'HCRemark', mapping: 'HCRemark'}
			,{name: 'HCMonths', mapping: 'HCMonths'}
			,{name: 'HCType', mapping: 'HCType'}
			,{name: 'HCActive', mapping: 'HCActive'}
			,{name: 'HCExpandCode', mapping: 'HCExpandCode'}
		])
	});
	obj.GridPanel4CheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanel4 = new Ext.grid.GridPanel({
		id : 'GridPanel4'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,store : obj.GridPanel4Store
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 60, dataIndex: 'HCCode', sortable: true}
			,{header: '描述', width: 150, dataIndex: 'HCDesc', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'HCRemark', sortable: true}
			,{header: '随访间隔', width: 100, dataIndex: 'HCMonths', sortable: true}
			,{header: '激活', width: 40, dataIndex: 'HCActive', sortable: true,renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
            }}
			,{header: '扩展', width: 100, dataIndex: 'HCExpandCode', sortable: true}
			,{header: '编辑表达式', width: 150, dataIndex: 'EditExpression',renderer: function(v,c,record,row){

				return "<input type='button' value='表达式维护'>" ;

			}}
		]});
	obj.main = new Ext.Panel({
		id : 'main'
		,buttonAlign : 'center'
		,width : 600
		,region : 'center'
		,title : '维护内容'
		,layout : 'border'
		,items:[
			obj.FormPanel14
			,obj.GridPanel4
		]
	});
	
	
	
	obj.TypeTree= new Ext.tree.TreePanel({

				region : 'center',
				width : '200',
				autoScroll : true,
				animate : true,
				frame : false,
				autoHeight : true,
				loader : new Ext.tree.TreeLoader({
							dataUrl : ExtToolSetting.TreeQueryPageURL,
							baseParams : {
								ClassName : 'web.DHCHM.HMCodeConfig',
								QueryName : 'FindTblTree',
								ArgCnt : 1,
								Arg1 : '1004'
							}
						}),
				root : new Ext.tree.AsyncTreeNode({
							id : '0',
							text : '人员分类维护'
						})
			});
	obj.TypeTree.expandAll();
	
	obj.List = new Ext.Panel({
		id : 'List'
		,buttonAlign : 'center'
		,width : '240'
		,region : 'west'
		,frame : true
		,title : '代码类型选择'
		,items:[
		obj.TypeTree
		
		]
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.main
			,obj.List
		]
	});
	obj.GridPanel4StoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.HMCodeConfig';
			param.QueryName = 'FindHumClass';
			param.Arg1 = obj.HCType.getValue();
			param.ArgCnt = 1;
	});
	InitViewport1Event(obj);
	//事件处理代码
	obj.B_Save.on("click", obj.B_Save_click, obj);
	obj.B_Clear.on("click", obj.B_Clear_click, obj);
	obj.TypeTree.on("click",obj.TblTree_click, obj);
	obj.GridPanel4.on("rowclick", obj.GridPanel_rowclick, obj);
	obj.GridPanel4.on("cellclick", obj.GridPanel_cellclick, obj);
  obj.LoadEvent(arguments);
  function ShowCheckStatus(value){
  	if (value=="Y")
		{
		
		return '<div><input name="" type="checkbox" value="" checked /></div>'
		}else
		{
		return '<div><input name="" type="checkbox" value="" /></div>'
		}

  }
  return obj;
}

