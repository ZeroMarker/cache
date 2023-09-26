function InitWorkFlowSetViewPort(){
	var obj = new Object();
	obj.WorkFlowID = '';
	
	obj.gridWorkFlowStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridWorkFlowStore = new Ext.data.Store({
		proxy: obj.gridWorkFlowStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridWorkFlow = new Ext.grid.GridPanel({
		id : 'gridWorkFlow'
		,store : obj.gridWorkFlowStore
		,columnLines:true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 60, dataIndex: 'Code', align: 'center'}
			,{header: '描述', width: 80, dataIndex: 'Desc', align: 'center'}
			,{header: '操作项目', width: 60 , dataIndex: '' , align : 'center' ,
				renderer : function(v, m, rd, r, c, s){
					return " <a href='#' onclick='OpenWorkItemEdit(\""+r+"\",\"\");'>编辑</a>";
				}
			}
			,{header: '备注', width: 200, dataIndex: 'Resume', align: 'left'}
		],viewConfig : {
			forceFit : true
		}
	});
	
	obj.txtWFCode = new Ext.form.TextField({
		id : 'txtWFCode'
		,fieldLabel : '代码'
		,labelSeparator :''
		,width : 340
		,anchor : '95%'
	});
	obj.txtWFDesc = new Ext.form.TextField({
		id : 'txtWFDesc'
		,fieldLabel : '描述'
		,labelSeparator :''
		,width : 340
		,anchor : '95%'
	});
	obj.txtWFResume = new Ext.form.TextField({
		id : 'txtWFResume'
		,width : 340
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '95%'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});	
	
	obj.WorkFlowSetViewPort = new Ext.Viewport({
		id : 'WorkFlowSetViewPort'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 40,
						layout : 'form',
						frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 150
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtWFCode]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtWFDesc]
									},{
										columnWidth : .95
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtWFResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridWorkFlow
						]
					}
				],
				bbar : [obj.btnSave,obj.btnDelete,'->','…']
			}
		]
	});

	obj.gridWorkFlowStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SS.WorkFlow';
			param.QueryName = 'QryWorkFlow';
			param.ArgCnt = 0;
	});	
	obj.gridWorkFlowStore.load({});
	
	InitWorkFlowSetViewPortEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}