function InitViewport1(){
	var obj = new Object();
	obj.CTType = new Ext.form.TextField({
		id : 'CTType'
		,fieldLabel : '����'
		,disabled : true
});
	obj.CTCode = new Ext.form.TextField({
		id : 'CTCode'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.CTDesc = new Ext.form.TextField({
		id : 'CTDesc'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.CTRemark = new Ext.form.TextField({
		id : 'CTRemark'
		,fieldLabel : '��ע'
});
	obj.CTExpandCode = new Ext.form.TextField({
		id : 'CTExpandCode'
		,fieldLabel : '��չ'
});
	obj.CTDefault = new Ext.form.TextField({
		id : 'CTDefault'
});
	obj.CTDefault = new Ext.form.Checkbox({
		id : 'CTDefault'
		,fieldLabel : 'Ĭ��'
});
	obj.CTActive = new Ext.form.Checkbox({
		id : 'CTActive'
		,checked : true
		,fieldLabel : '����'
});
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
});
	obj.B_Save = new Ext.Button({
		id : 'B_Save'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.B_Clear = new Ext.Button({
		id : 'B_Clear'
		,iconCls : 'icon-new'
		,text : '���'
});

	obj.FormPanelLeft = new Ext.Panel({
		columnWidth:0.5
		,items:[obj.CTType,obj.CTDesc,obj.CTExpandCode,obj.CTActive]
		,layout : 'form'
	});
	obj.FormPanelRight = new Ext.Panel({
		columnWidth:0.5
		,items:[obj.CTCode,obj.CTRemark,obj.CTDefault,obj.Rowid]
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
		,layout : 'column'
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
			,{name: 'CTCode', mapping: 'CTCode'}
			,{name: 'CTDesc', mapping: 'CTDesc'}
			,{name: 'CTRemark', mapping: 'CTRemark'}
			,{name: 'CTDefault', mapping: 'CTDefault'}
			,{name: 'CTExpandCode', mapping: 'CTExpandCode'}
			,{name: 'CTType', mapping: 'CTType'}
			,{name: 'CTActive', mapping: 'CTActive'}
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
			,{header: '����', width: 60, dataIndex: 'CTCode', sortable: true}
			,{header: '����', width: 100, dataIndex: 'CTDesc', sortable: true}
			,{header: '��ע', width: 100, dataIndex: 'CTRemark', sortable: true}
			,{header: 'Ĭ��', width: 40, dataIndex: 'CTDefault', sortable: true,renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
            }}
			,{header: '��չ', width: 100, dataIndex: 'CTExpandCode', sortable: true}
			,{header: '����', width: 40, dataIndex: 'CTActive', sortable: true,renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
            }}
		]});
	obj.main = new Ext.Panel({
		id : 'main'
		,buttonAlign : 'center'
		,width : 600
		,region : 'center'
		,title : 'ά������'
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
								Arg1 : '1001'
							}
						}),
				root : new Ext.tree.AsyncTreeNode({
							id : '0',
							text : '��������ά��'
						})
			});
	obj.TypeTree.expandAll();
	
	obj.List = new Ext.Panel({
		id : 'List'
		,buttonAlign : 'center'
		,width : '300'
		,region : 'west'
		,frame : true
		,title : '��������ѡ��'
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
			param.QueryName = 'FindCodebyType';
			param.Arg1 = obj.CTType.getValue();
			param.ArgCnt = 1;
	});
	InitViewport1Event(obj);
	//�¼��������
	obj.B_Save.on("click", obj.B_Save_click, obj);
	obj.B_Clear.on("click", obj.B_Clear_click, obj);
	obj.TypeTree.on("click",obj.TblTree_click, obj);
	obj.GridPanel4.on("rowclick", obj.GridPanel_rowclick, obj);
  obj.LoadEvent(arguments);
  function ShowCheckStatus(value){
  	if (value=="Y")
		{
		
		return '<div><input name="" type="checkbox" value="" checked disabled/></div>'
		}else
		{
		return '<div><input name="" type="checkbox" value=""  disabled/></div>'
		}

  }
  return obj;
}

