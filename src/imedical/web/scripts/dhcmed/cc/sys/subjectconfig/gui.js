﻿
function InitViewport1(SubjectCode){
	var obj = new Object();
	
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.cboSubject = Common_ComboToSubject("cboSubject","监控主题");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.gridConfigStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridConfigStore = new Ext.data.Store({
		proxy: obj.gridConfigStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		},
		[
			{name: 'RowId', mapping : 'RowId'}
			,{name: 'Code', mapping : 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'SubjectCode', mapping: 'SubjectCode'}
			,{name: 'SubjectDesc', mapping: 'SubjectDesc'}
		])
	});
	obj.gridConfig = new Ext.grid.EditorGridPanel({
		id : 'gridConfig'
		,store : obj.gridConfigStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 60, dataIndex: 'Code', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'Desc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '监控主题', width: 200, dataIndex: 'SubjectDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IsActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'Resume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	obj.TreeControlsTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter : 'Arg1',
			dataUrl : "dhcmed.cc.sys.configitemtree.csp",
			baseParams : {
				SubjectCode:'',
				SubjectConfigID:''
			}
	});
	obj.TreeControls = new Ext.tree.TreePanel({
		buttonAlign : 'center'
		,region : 'center'
		,width:300
		,rootVisible:false
		,autoScroll:true
		,loader : null  //obj.TreeControlsTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'root',text:'root'})
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 70,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboSubject]
									},{
										width : 100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridConfig
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			},{
				region: 'east',
				width : 300,
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.TreeControls
						]
					}
				]
				,bbar : ['监控主题关联监控项目子类','->','…']
			}
		]
	});
	
	obj.gridConfigStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.Sys.SubjectConfig';
		param.QueryName = 'QrySubjectConfig';
		param.Arg1 = '';
		param.Arg2 = '';
		param.ArgCnt = 2;
	});
	/*
	obj.gridItemDicStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.Sys.SubjectConfig';
		param.QueryName = 'QrySubCatByConfig';
		
		var ConfigID = "";
		var objRec = obj.gridConfig.getSelectionModel().getSelected();
		if (objRec) {
			ConfigID = objRec.get("RowId");
		}
		
		param.Arg1 = ConfigID;
		param.Arg2 = (obj.chkIsViewAll.getValue()==true ? "Y" : "N");
		param.ArgCnt = 2;
	});
	*/
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

