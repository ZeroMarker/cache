function InitViewport1(){
	var obj = new Object();
	obj.PType = new Ext.form.TextField({
		id : 'PType'
		,fieldLabel : '����'
		,disabled : true
});
	obj.PCode = new Ext.form.TextField({
		id : 'PCode'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.PDesc = new Ext.form.TextField({
		id : 'PDesc'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.PRemark = new Ext.form.TextField({
		id : 'PRemark'
		,fieldLabel : '��ע'
});
	obj.PExpandCode = new Ext.form.TextField({
		id : 'PExpandCode'
		,fieldLabel : '��չ'
});
	
	obj.PActive = new Ext.form.Checkbox({
		id : 'PActive'
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
		,items:[obj.PType,obj.PDesc,obj.PExpandCode,obj.Rowid]
		,layout : 'form'
	});
	obj.FormPanelRight = new Ext.Panel({
		columnWidth:0.5
		,items:[obj.PCode,obj.PRemark,obj.PActive]
		,layout : 'form'
	});
	obj.FormPanel14 = new Ext.form.FormPanel({
		id : 'FormPanel14'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 140
		,region : 'north'
		,layout:'column'
		,frame : true
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
			,{name: 'PCode', mapping: 'PCode'}
			,{name: 'PDesc', mapping: 'PDesc'}
			,{name: 'PRemark', mapping: 'PRemark'}
			,{name: 'PExpandCode', mapping: 'PExpandCode'}
			,{name: 'PType', mapping: 'PType'}
			,{name: 'PActive', mapping: 'PActive'}
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
			,{header: '����', width: 60, dataIndex: 'PCode', sortable: true}
			,{header: '����', width: 150, dataIndex: 'PDesc', sortable: true}
			,{header: '��ע', width: 100, dataIndex: 'PRemark', sortable: true}
			,{header: '��չ', width: 100, dataIndex: 'PExpandCode', sortable: true}
			,{header: '����', width: 40, dataIndex: 'PActive', sortable: true,renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
            }}
      ,{header: '�༭���ʽ', width: 150, dataIndex: 'EditExpression',renderer: function(v,c,record,row){

				return "<input type='button' value='���ʽά��'>" ;

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
								Arg1 : '1002'
							}
						}),
				root : new Ext.tree.AsyncTreeNode({
							id : '0',
							text : '֪�����ά��'
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
			param.QueryName = 'FindCPlnss';
			param.Arg1 = obj.PType.getValue();
			param.ArgCnt = 1;
	});
	InitViewport1Event(obj);
	//�¼��������
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

