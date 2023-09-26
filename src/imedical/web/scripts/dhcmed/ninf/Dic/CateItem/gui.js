
function InitViewportCateItem(){
	var obj = new Object();
	obj.CateID=CateID;
	obj.CateCode=CateCode;
	
	obj.txtAlias = new Ext.form.TextField({
		id : 'txtAlias'
		,fieldLabel : '����'
		,width : 200
		,anchor : '100%'
	});
	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-Find'
		,width: 60
		,text : '����'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : 'ɾ��'
	});
	
	obj.gridCateItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridCateItemStore = new Ext.data.Store({
		proxy: obj.gridCateItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		}, 
		[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemCode', mapping: 'ItemCode'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'ItemCateCode', mapping: 'ItemCateCode'}
			,{name: 'ItemActive', mapping: 'ItemActive'}
			,{name: 'ItemResume', mapping: 'ItemResume'}
		])
	});
	obj.gridCateItem = new Ext.grid.EditorGridPanel({
		id : 'gridCateItem'
		,store : obj.gridCateItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: 'ѡ��', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '����', width: 40, dataIndex: 'ItemCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 300, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '�Ƿ�<br>��Ч', width: 40, dataIndex: 'ItemActive', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("ItemActive");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '˵��', width: 240, dataIndex: 'ItemResume', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			//forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridCateItemStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
    });
	
	obj.gridItemDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridItemDicStore = new Ext.data.Store({
		proxy: obj.gridItemDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		}, 
		[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicActive', mapping: 'DicActive'}
			,{name: 'DicResume', mapping: 'DicResume'}
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
			{header: 'ѡ��', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '����', width: 40, dataIndex: 'DicCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 300, dataIndex: 'DicDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			//forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridItemDicStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
    });
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				region: 'center',
				layout : 'fit',
				frame : true,
				items : [
					obj.gridCateItem
				],
				tbar : [obj.btnDelete,'->','��']
			},{
				region: 'east',
				width : 320,
				layout : 'fit',
				frame : true,
				items : [
					obj.gridItemDic
				],
				tbar : [obj.txtAlias,obj.btnFind]
			}
		]
	});
	
	obj.gridCateItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.CateItemSrv';
		param.QueryName = 'QryCateItemByCate';
		param.Arg1 = obj.CateCode;
		param.ArgCnt = 1;
	});
	
	obj.gridItemDicStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.CateItemSrv';
		param.QueryName = 'QryItemDicByType';
		param.Arg1 = obj.CateCode;
		param.Arg2 = obj.txtAlias.getValue();
		param.ArgCnt = 2;
	});
	
	InitViewportCateItemEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}