function InitviewScreen(){
	var obj = new Object();
	obj.intCurrRowIndex = -1;
	obj.txtMRItemDesc = Common_TextField("txtMRItemDesc","项目名称");
	//obj.txtMRItemCat = Common_TextField("txtMRItemCat","大类");
	//obj.txtMRItemSubCat = Common_TextField("txtMRItemSubCat","子类");
	obj.cboDataSource = Common_ComboToDic("cboDataSource","数据来源","FPDataSource");
	obj.cboDataType = Common_ComboToDic("cboDataType","数据类型","FPDataType");
	obj.txtElementCode = Common_TextField("txtElementCode","首页单元");
	obj.txtElementDesc = Common_TextField("txtElementDesc","单元名称");
	obj.txtMRItemCol = Common_TextField("txtMRItemCol","显示顺序");
	obj.MRIsIndex = Common_Checkbox("MRIsIndex","是否建索引");
	obj.IsActive = Common_Checkbox("IsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.txtItemAlias = Common_TextField("txtItemAlias","项目名称");
	
	//大类
	obj.cboDataCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDataCatStore = new Ext.data.Store({
		proxy: obj.cboDataCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboDataCat = new Ext.form.ComboBox({
		id : 'cboDataCat'
		,fieldLabel : '大类<font color="red">*</font>'
		,store : obj.cboDataCatStore
		,minChars : 1
		,displayField : 'Desc'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	//子类
	obj.cboDataSubCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDataSubCatStore = new Ext.data.Store({
		proxy: obj.cboDataSubCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboDataSubCat = new Ext.form.ComboBox({
		id : 'cboDataSubCat'
		,fieldLabel : '子类<font color="red">*</font>'
		,store : obj.cboDataSubCatStore
		,minChars : 1
		,displayField : 'Desc'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 60
		,text : '保存'
	});
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.gridDataItemStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridDataItemStore = new Ext.data.Store({
		proxy: obj.gridDataItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowId', mapping: 'RowId'}
			,{name: 'DataSourceCode', mapping: 'DataSourceCode'}
			,{name: 'DataSource', mapping: 'DataSource'}
			,{name: 'ElementCode', mapping: 'ElementCode'}
			,{name: 'ElementDesc', mapping: 'ElementDesc'}
			,{name: 'DataTypeCode', mapping: 'DataTypeCode'}
			,{name: 'DataType', mapping: 'DataType'}
			,{name: 'MRItemDesc', mapping: 'MRItemDesc'}
			,{name: 'MRItemCat', mapping: 'MRItemCat'}
			,{name: 'MRItemSubCat', mapping: 'MRItemSubCat'}
			,{name: 'FPltemDesc', mapping: 'FPltemDesc'}
			,{name: 'MRItemCol', mapping: 'MRItemCol'}
			,{name: 'MRIsIndex', mapping: 'MRIsIndex'}
			,{name: 'MRIsIndexDesc', mapping: 'MRIsIndexDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'MRItemCatDesc', mapping: 'MRItemCatDesc'}
			,{name: 'MRItemSubCatDesc', mapping: 'MRItemSubCatDesc'}
		])
	});
	obj.gridDataItem = new Ext.grid.GridPanel({
		id : 'gridDataItem'
		,store : obj.gridDataItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,buttonAlign : 'center'
		,tbar : [{id:'msgGridDataItem',text:'首页数据项列表',style:'font-weight:bold;font-size:14px;',xtype:'label'},
		'-','关键字检索：',obj.txtItemAlias,'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '数据来源', width: 70, dataIndex: 'DataSource', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '首页单元', width: 150, dataIndex: 'ElementCode', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '单元名称', width: 100, dataIndex: 'ElementDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '大类', width: 100, dataIndex: 'MRItemCatDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			},{header: '子类', width: 100, dataIndex: 'MRItemSubCatDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '项目名称', width: 100, dataIndex: 'MRItemDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '数据<br>类型', width: 50, dataIndex: 'DataType', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '显示<br>顺序', width: 50, dataIndex: 'MRItemCol', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否创<br>建索引', width: 70, dataIndex: 'MRIsIndexDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IsActiveDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '编目项目名称', width: 120, dataIndex: 'FPltemDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '备注', width: 280, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
		]
		,iconCls: 'icon-grid'
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.gridDataItemStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			{
				region: 'south',
				height: 120,
				layout : 'form',
				frame : true,
				buttonAlign : 'center',
				items : [
					{
						layout : 'column',
						items : [
							{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtElementCode]
							},{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtMRItemDesc]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtElementDesc]
							},{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.cboDataCat]
							},{
								width:350
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.cboDataSubCat]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								width:180
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.cboDataSource]
							},{
								width:170
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.cboDataType]
							},{
								width:135
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtMRItemCol]
							},{
								width:110
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 80
								,items: [obj.MRIsIndex]
							},{
								width:110
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 80
								,items: [obj.IsActive]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								width:700
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtResume]
							},{
								width:10
							},{
								width:60
								,layout : 'form'
								,items: [obj.btnSave]
							}
						]
					}
				]
			},{
				region: 'center',
				layout : 'fit',
				//frame : true,
				items : [
					obj.gridDataItem
				]
			}
		]
	});
	obj.cboDataCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.DataCatSrv';
		param.QueryName = 'QryDataCat';
		param.ArgCnt = 0;
	});

	obj.cboDataSubCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.DataCatSrv';
		param.QueryName = 'QryDataSubCat';
		param.Arg1 = Common_GetValue('cboDataCat');
		param.ArgCnt = 1;
	});

	obj.gridDataItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.DataItemSrv';
		param.QueryName = 'QryDataItems';
		param.Arg1 = Common_GetValue('txtItemAlias');
		param.ArgCnt = 1;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

