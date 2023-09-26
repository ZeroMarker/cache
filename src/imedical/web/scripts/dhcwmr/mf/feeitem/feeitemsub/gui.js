function InitviewSubWindow(FeeItemID)
{
	var obj = new Object();
	obj.FeeItemID = FeeItemID;
	obj.FeeItemSubId = '';
	obj.dfSttDate = Common_DateFieldToDate("dfSttDate","开始日期");
	obj.dfEndDate = Common_DateFieldToDate("dfEndDate","结束日期");
	obj.txtResume = Common_TextField("txtResume","备注");

	obj.cboTarItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboTarItemStore = new Ext.data.Store({
		proxy: obj.cboTarItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboTarItem = new Ext.form.ComboBox({
		id : 'cboTarItem'
		,width : 300
		,store : obj.cboTarItemStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : 'HIS收费项'
		,labelSeparator :''
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'ID'
	});
	
	obj.gridCTHospListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridCTHospListStore = new Ext.data.Store({
		proxy: obj.gridCTHospListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HospID'
		},
		[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'HospID', mapping: 'HospID'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
		])
	});
	obj.gridCTHospList = new Ext.grid.EditorGridPanel({
		id : 'gridCTHospList'
		,store : obj.gridCTHospListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,height : 160 
		,hideHeaders : true
		,columns: [
			{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '医院名称', width: 200, dataIndex: 'HospDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			//forceFit : true
		}
    });
    
    obj.gridMrTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridMrTypeStore = new Ext.data.Store({
		proxy: obj.gridMrTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'MrTypeDesc', mapping: 'MrTypeDesc'}
		])
	});
	obj.gridMrType = new Ext.grid.EditorGridPanel({
		id : 'gridMrType'
		,store : obj.gridMrTypeStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,height : 200 
		,hideHeaders : true
		,columns: [
			{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '病案类型', width: 150, dataIndex: 'MrTypeDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
    
	obj.btnUpdate= new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.gridFeeItemSubStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridFeeItemSubStore = new Ext.data.Store({
		proxy: obj.gridFeeItemSubStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'TarItemDr', mapping : 'TarItemDr'}
			,{name: 'TarItemDesc', mapping : 'TarItemDesc'}
			,{name: 'SttDate', mapping : 'SttDate'}
			,{name: 'EndDate', mapping : 'EndDate'}
			,{name: 'MrTpIDs', mapping : 'MrTpIDs'}
			,{name: 'MrTpDescs', mapping : 'MrTpDescs'}
			,{name: 'HospIDs', mapping : 'HospIDs'}
			,{name: 'HospDescs', mapping : 'HospDescs'}
			,{name: 'Resume', mapping : 'Resume'}
		])
	});
	obj.gridFeeItemSub = new Ext.grid.EditorGridPanel({
		id : 'gridFeeItemSub'
		,store : obj.gridFeeItemSubStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'HIS收费项', width: 200, dataIndex: 'TarItemDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '开始日期', width: 80, dataIndex: 'SttDate', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '结束日期', width: 80, dataIndex: 'EndDate', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '病案类型', width: 200, dataIndex: 'MrTpDescs', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '医院列表', width: 200, dataIndex: 'HospDescs', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 100, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
	});
	
	obj.FeeItemSubWindow = new Ext.Window({
		id : 'FeeItemSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : true
		,resizable : false
		,title : '收费项目对照'
		,layout : 'border'
		,modal: true
		,items:[
			obj.gridFeeItemSub
			,{
				region:'east'
				,layout:'form'
				,width : 300
				,frame : true
				,labelWidth : 100
				,labelAlign : 'right'
				,buttonAlign : 'center'
				,items :[
					 obj.cboTarItem
					,obj.dfSttDate
					,obj.dfEndDate	
					,{
						layout : 'column'
						,items: [
							{
								width : 108
								,html : '<div style="width=100%;text-align:right;font-size:18px;">病案类型&nbsp;</div>'
							},{
								columnWidth : 1
								,layout : 'fit'
								,buttonAlign : 'left'
								,items: [obj.gridMrType]
							}
						]
					}
					,{
						layout : 'column'
						,items: [
							{
								width : 108
								,html : '<div style="width=100%;text-align:right;font-size:18px;">医院列表&nbsp;</div>'
							},{
								columnWidth : 1
								,layout : 'fit'
								,buttonAlign : 'left'
								,items: [obj.gridCTHospList]
							}
						]
					}
					,obj.txtResume
					,{
						layout : 'form'
						,buttonAlign : 'center'
						,buttons : [obj.btnUpdate]
					}
				]
			}
		]
	});
	
	obj.gridFeeItemSubStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.MFService.FeeItemSrv";
		param.QueryName = "QryFItemSubByPaf";
		param.Arg1		= obj.FeeItemID;
		param.ArgCnt	= 1;
	});
	obj.gridFeeItemSubStore.load({});
	
	obj.gridCTHospListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.MF.FeeItemSub';
			param.QueryName = 'QryFISHospList';
			if (obj.FeeItemSubId =="") {
				param.ClassName = 'DHCWMR.SSService.HospitalSrv';
				param.QueryName = 'QryCTHospital';
				param.ArgCnt = 0;
			} else {
				param.Arg1 = obj.FeeItemSubId;
				param.ArgCnt = 1;
			}
	});
	obj.gridCTHospListStore.load({});
	
	obj.gridMrTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.MF.FeeItemSub';
			param.QueryName = 'QryFISMrTypeList';
			if (obj.FeeItemSubId =="") {
				param.ClassName = 'DHCWMR.SS.MrType';
				param.QueryName = 'QueryMrType';
				param.Arg1 = '';
				param.ArgCnt = 1;
			} else {
				param.Arg1 = obj.FeeItemSubId;
				param.ArgCnt = 1;
			}
	});
	obj.gridMrTypeStore.load({});
	
	obj.cboTarItemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.MF.FeeItemSub';
			param.QueryName = 'QryTarItem';
			param.Arg1 	= obj.cboTarItem.getRawValue(); 
			param.ArgCnt = 1;
	});
	obj.cboTarItemStore.load({});
	
	InitviewSubWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}