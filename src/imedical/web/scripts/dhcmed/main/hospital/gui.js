
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.cboHospital = Common_ComboToCTHosp("cboHospital","医院");
	obj.cboProduct = Common_ComboToProduct("cboProduct","产品");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.gridHospitalStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridHospitalStore = new Ext.data.Store({
		proxy: obj.gridHospitalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SSHospID'
		},
		[
			{name: 'SSHospID', mapping : 'SSHospID'}
			,{name: 'SSHospCode', mapping : 'SSHospCode'}
			,{name: 'SSHospDesc', mapping: 'SSHospDesc'}
			,{name: 'CTHospID', mapping: 'CTHospID'}
			,{name: 'CTHospDesc', mapping: 'CTHospDesc'}
			,{name: 'ProductID', mapping: 'ProductID'}
			,{name: 'ProductDesc', mapping: 'ProductDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridHospital = new Ext.grid.EditorGridPanel({
		id : 'gridHospital'
		,store : obj.gridHospitalStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 60, dataIndex: 'SSHospCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'SSHospDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '医院', width:200, dataIndex: 'CTHospDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '产品', width: 200, dataIndex: 'ProductDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 60, dataIndex: 'IsActiveDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : '删除'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
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
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboHospital]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboProduct]
									},{
										width : 150
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
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
							obj.gridHospital
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridHospitalStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.HospitalSrv';
		param.QueryName = 'QrySSHospital';
		param.ArgCnt = 0;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

