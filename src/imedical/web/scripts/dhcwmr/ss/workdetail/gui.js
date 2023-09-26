
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","描述");
	obj.txtResume = Common_TextField("txtResume","备注");
	//数据类型
	obj.cboTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboTypeStore = new Ext.data.Store({
		proxy: obj.cboTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		},
		[
			{name: 'DicRowID', mapping : 'DicRowID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboType = new Ext.form.ComboBox({
		id : 'cboType'
		,fieldLabel : '类型'
		,labelSeparator :''
		,width : 100
		,store : obj.cboTypeStore
		,minChars : 0
		,queryDelay:1
		//,editable:true
		,typeAhead : false
		,triggerAction : 'all'
		,minListWidth:100
		,valueField : 'DicCode'
		,displayField : 'DicDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		
	});
	//字典代码
	obj.cboDicCodeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDicCodeStore = new Ext.data.Store({
		proxy: obj.cboDicCodeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		},
		[
			{name: 'DicRowID', mapping : 'DicRowID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});

	obj.cboDicCode = new Ext.form.ComboBox({
		id : 'cboDicCode'
		,fieldLabel : '字典代码'
		,labelSeparator :''
		,width : 100
		,store : obj.cboDicCodeStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,triggerAction : 'all'
		,minListWidth:150
		,valueField : 'DicRowID'
		,displayField : 'DicDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		
	});
	
	obj.gridWorkDetailStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridWorkDetailStore = new Ext.data.Store({
		proxy: obj.gridWorkDetailStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'WDetailCode', mapping : 'WDCode'}
			,{name: 'WDetailDesc', mapping: 'WDDesc'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeCode', mapping: 'TypeCode'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicCodeDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridWorkDetail = new Ext.grid.EditorGridPanel({
		id : 'gridWorkDetail'
		,store : obj.gridWorkDetailStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 80, dataIndex: 'WDetailCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '描述', width: 150, dataIndex: 'WDetailDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '类型', width: 80, dataIndex: 'TypeCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '字典代码', width: 80, dataIndex: 'DicCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 250, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridWorkDetail,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
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
										columnWidth:.15
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
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboType]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.cboDicCode]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.9
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
							obj.gridWorkDetail
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	//类型
	obj.cboTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.DictionarySrv"
		param.QueryName = "QryDicByType"
		param.Arg1 = "DataType"
		param.Arg2 = ""
		param.Arg3 = ""
		
		param.ArgCnt = 3;
	});
	//字典代码
	obj.cboDicCodeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.DictionarySrv"
		param.QueryName = "QryDicByType"
		param.Arg1 = "SYS"
		param.Arg2 = ""
		param.Arg3 = ""
		
		param.ArgCnt = 3
	});
	
	obj.gridWorkDetailStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.WorkDetailSrv"
		param.QueryName = "QryWorkDetail"
		
		param.ArgCnt = 0;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

