function InitViewPort()
{
	var obj = new Object();
	obj.HospID = '';
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
		,title : '院区列表'
		,hideHeaders : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '医院名称', width: 150, dataIndex: 'HospDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
    
    obj.gridLocListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLocListStore = new Ext.data.Store({
		proxy: obj.gridLocListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocRowId'
		},
		[
			{name: 'LocRowId', mapping : 'LocRowId'}
			,{name: 'LocDesc1', mapping: 'LocDesc1'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'IsChecked', mapping: 'IsChecked'}
		])
	});
	obj.gridLocList = new Ext.grid.EditorGridPanel({
		id : 'gridLocList'
		,store : obj.gridLocListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,title : '科室列表'
		,hideHeaders : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '科室名', width: 150, dataIndex: 'LocDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
    
	obj.ViewPort = new Ext.Viewport({
		id:'ViewPort',
		layout:'border',
		items:[
			{
				 region : 'west'
				,width:300
				,layout : 'fit'
				,items : [obj.gridCTHospList]
			},{
				 region : 'center'
				,layout : 'fit'
				,items : [obj.gridLocList]
			}
		]
	});
	
	obj.gridCTHospListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.HospitalSrv';
		param.QueryName = 'QryCTHospital';
		param.ArgCnt = 0;
	});
	obj.gridCTHospListStore.load({});
	
	obj.gridLocListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.PrintLoc';
		param.QueryName = 'QueryLoction';
		param.Arg1 = '';
		param.Arg2 = '';
		param.Arg3 = '';
		param.Arg4 = 'E';
		param.Arg5 = 'O';
		param.Arg6 = '';
		param.Arg7 = obj.HospID;
		param.ArgCnt = 7;
	});
	
	InitViewPortEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}