function InitMrNoTypeLinkViewPort(){
	var obj = new Object();
	obj.NoTypeID = arguments[0].get('ID');
	obj.CTHospIDs = arguments[1];
	
	obj.btnDeleteNTL = new Ext.Button({
		id : 'btnDeleteNTL'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	
	obj.gridNoTypeLinkStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridNoTypeLinkStore = new Ext.data.Store({
		proxy: obj.gridNoTypeLinkStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'LocID', mapping: 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'HospID', mapping: 'HospID'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
		])
	});
	obj.gridNoTypeLink = new Ext.grid.GridPanel({
		id : 'gridNoTypeLink'
		,store : obj.gridNoTypeLinkStore
		,columnLines:true
		//,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '关联医院', width: 100, dataIndex: 'HospDesc', align: 'center'}
			,{header: '关联科室', width: 120, dataIndex: 'LocDesc', align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: [obj.btnDeleteNTL]
	});
	
	//医院列表
	obj.gridNoTypeLinkHospStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridNoTypeLinkHospStore = new Ext.data.Store({
		proxy: obj.gridNoTypeLinkHospStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HospID'
		}, 
		[	
			{name: 'IsChecked', mapping : 'IsChecked'},
			,{name: 'HospID', mapping: 'HospID'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
		])
	});
	obj.gridNoTypeLinkHosp = new Ext.grid.EditorGridPanel({
		id : 'gridNoTypeLinkHosp'
		,store : obj.gridNoTypeLinkHospStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'north'
		,height : 150
		//,loadMask : true
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
			,{header: '医院名称', width: 150, dataIndex: 'HospDesc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	///科室列表
	obj.gridNoTypeLinkLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridNoTypeLinkLocStore = new Ext.data.Store({
		proxy: obj.gridNoTypeLinkLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		}, 
		[
			{name: 'IsChecked', mapping : 'IsChecked'},
			,{name: 'LocID', mapping: 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
		])
	});
	obj.gridNoTypeLinkLoc = new Ext.grid.EditorGridPanel({
		id : 'gridNoTypeLinkLoc'
		,store : obj.gridNoTypeLinkLocStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		//,loadMask : true
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
			,{header: '科室名称', width: 150, dataIndex: 'LocDesc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.SelectPanel = new Ext.Panel({
		id :'SelectPanel'
		,region : 'east'
		,width : 300
		,layout : 'border'
		,frame : true
		,tbar: ['请选择关联医院、科室...']
		,items:[
			obj.gridNoTypeLinkHosp
			,obj.gridNoTypeLinkLoc
		]
	});
	
	obj.MrNoTypeLinkWindow = new Ext.Window({
		id : 'MrNoTypeLinkWindow'
		,width : 800
		,plain : true
		,buttonAlign : 'center'
		,height : 500
		,title : '号码类型关联科室维护'
		,layout : 'border'
		,frame  : true
		,bodyBorder : 'padding:0 0 0 0'
		,resizable:false
		,modal : true
		,items:[
			obj.gridNoTypeLink
			,obj.SelectPanel
		]
	});


	obj.gridNoTypeLinkStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SS.NoTypeLnk';
			param.QueryName = 'QryNoTpLocList';
			param.Arg1 = obj.NoTypeID;
			param.ArgCnt = 1;
	});
	obj.gridNoTypeLinkStore.load({});
	
	obj.gridNoTypeLinkHospStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.NoTypeSrv';
			param.QueryName = 'QryHospByIDs';
			param.Arg1 = obj.CTHospIDs;
			param.ArgCnt = 1;
	});
	obj.gridNoTypeLinkHospStore.load({});

	obj.gridNoTypeLinkLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.NoTypeSrv';
			param.QueryName = 'QryLocByNoType';
			var HospID=""
			var objRec = Ext.getCmp("gridNoTypeLinkHosp").getSelectionModel().getSelected();
			if (objRec)
			{
				HospID = objRec.get("HospID");
			}
			param.Arg1 = HospID;
			param.Arg2 = obj.NoTypeID;
			param.ArgCnt = 2;
	});
	obj.gridNoTypeLinkLocStore.load({});
	
	InitMrNoTypeLinkEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}