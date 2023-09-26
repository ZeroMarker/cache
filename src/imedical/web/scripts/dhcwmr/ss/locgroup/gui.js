
function InitViewport1(){
	var obj = new Object();
	obj.LocGrpDicID = '';
	obj.txtLocAlias = Common_TextField("txtLocAlias","科室");
	obj.txtLocAlias.setWidth(200);
	obj.chkDisplayAll = Common_Checkbox("chkDisplayAll","显示全部");
	
	obj.btnUpdate = new Ext.Toolbar.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '同步科室'
	});
	
	obj.gridLocGrpDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLocGrpDicStore = new Ext.data.Store({
		proxy: obj.gridLocGrpDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		},
		[
			{name: 'DicRowID', mapping : 'DicRowID'}
			,{name: 'DicCode', mapping : 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.gridLocGrpDic = new Ext.grid.EditorGridPanel({
		id : 'gridLocGrpDic'
		,store : obj.gridLocGrpDicStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'west'
		,width : 300
		,loadMask : true
		,tbar : [{id:'msgGridLocGrpDic',text:'科室组列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室组', width: 150, dataIndex: 'DicDesc', sortable: false, menuDisabled:false, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.gridLocGrpDicStore,  //修复Bug6507
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.gridLocGrpCfgStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLocGrpCfgStore = new Ext.data.Store({
		proxy: obj.gridLocGrpCfgStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DeptCode'
		},
		[
			{name: 'DeptCode', mapping : 'DeptCode'}
			,{name: 'DeptDesc', mapping: 'DeptDesc'}
			,{name: 'LocGrpID', mapping : 'LocGrpID'}
			,{name: 'LocType', mapping: 'LocType'}
			,{name: 'LocGroup', mapping: 'LocGroup'}
			,{name: 'LocGroupDesc', mapping: 'LocGroupDesc'}
		])
		,sortInfo:{field: 'LocGroup', direction: "DESC"}
	});
	obj.gridLocGrpCfg = new Ext.grid.EditorGridPanel({
		id : 'gridLocGrpCfg'
		,store : obj.gridLocGrpCfgStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [{id:'msgGridLocGrpCfg',text:'科室列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'-','显示全部:',obj.chkDisplayAll,'-','别名检索：',obj.txtLocAlias,'-',obj.btnUpdate,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 30, dataIndex: 'LocGroup', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var LocGroup = rd.get("LocGroup");
					LocGroup = '|' + LocGroup + '|'
					if (LocGroup.indexOf('|' + obj.LocGrpDicID + '|')>-1){
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '科室代码', width: 60, dataIndex: 'DeptCode', sortable: true, menuDisabled:false, align: 'left'}
			,{header: '科室名称', width: 150, dataIndex: 'DeptDesc', sortable: true, menuDisabled:false, align: 'left'}
			,{header: '科室组', width:150, dataIndex: 'LocGroupDesc', sortable: true, menuDisabled:false, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.gridLocGrpCfgStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.gridLocGrpDic
			,obj.gridLocGrpCfg
		]
	});
	
	obj.gridLocGrpDicStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.DictionarySrv';
		param.QueryName = 'QryDicByType';
		param.Arg1 = 'LocGroupDic';
		param.Arg2 = '';
		param.Arg3 = '1';
		param.ArgCnt = 3;
	});
	
	obj.gridLocGrpCfgStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryLocGroupList';
		param.Arg1 = obj.LocGrpDicID;
		param.Arg2 = Common_GetValue("txtLocAlias");
		var IsDisplayAll = Common_GetValue("chkDisplayAll");
		if (IsDisplayAll) {
			param.Arg3 = 1;
		} else {
			param.Arg3 = 0;
		}
		param.ArgCnt = 3;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

