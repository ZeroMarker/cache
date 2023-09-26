
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.chkIsViewAll = Common_Checkbox("chkIsViewAll","显示全部");
	
	obj.gridInfectionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfectionStore = new Ext.data.Store({
		proxy: obj.gridInfectionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		},
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: 'ICD', mapping: 'ICD'}
			,{name: 'MIFDisease', mapping: 'MIFDisease'}
			,{name: 'MIFKind', mapping: 'MIFKind'}
			,{name: 'MIFRank', mapping: 'MIFRank'}
			,{name: 'MIFAppendix', mapping: 'MIFAppendix'}
			,{name: 'MIFMulti', mapping: 'MIFMulti'}
			,{name: 'MIFDependence', mapping: 'MIFDependence'}
			,{name: 'MIFTimeLimit', mapping: 'MIFTimeLimit'}
			,{name: 'MIFResume', mapping: 'MIFResume'}
		])
	});
	obj.gridInfection = new Ext.grid.EditorGridPanel({
		id : 'gridInfection'
		,store : obj.gridInfectionStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ICD', width: 100, dataIndex: 'ICD', sortable: true}
			,{header: '疾病名称', width: 250, dataIndex: 'MIFDisease', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.gridItemDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridItemDicStore = new Ext.data.Store({
		proxy: obj.gridItemDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'IDResume', mapping: 'IDResume'}
			,{name: 'IsChecked', mapping: 'IsChecked'}
			
		])
	});
	obj.gridItemDic = new Ext.grid.EditorGridPanel({
		id : 'gridItemDic'
		,store : obj.gridItemDicStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '选择', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '监控项目名称', width: 300, dataIndex: 'IDDesc', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'IDResume', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
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
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridInfection
						]
					}
				]
			},{
				region: 'east',
				width : 500,
				layout : 'border',
				//frame : true,
				items : [
					{
						region: 'south',
						height: 35,
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
										,labelWidth : 60
										,items: [obj.chkIsViewAll]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						frame : true,
						items : [
							obj.gridItemDic
						]
					}
				],
				bbar : ['关联监控项目字典','->','…']
			}
		]
	});
	
	obj.gridInfectionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.InfectionSrv';
		param.QueryName = 'QryIFList';
		param.Arg1 = "";
		param.Arg2 = "";
		param.Arg3 = "";
		param.Arg4 = "";
		param.Arg5 = "";
		param.ArgCnt = 5;
	});
	
	obj.gridItemDicStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.InfectCCMapSrv';
		param.QueryName = 'QryItemDicInfo';
		
		var xInfectID = "";
		var objRec = obj.gridInfection.getSelectionModel().getSelected();
		if (objRec) {
			xInfectID = objRec.get("RowID");
		}
		
		param.Arg1 = SubjectCode;
		param.Arg2 = xInfectID;
		param.Arg3 = (obj.chkIsViewAll.getValue()==true ? "Y" : "N");
		param.ArgCnt = 3;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

