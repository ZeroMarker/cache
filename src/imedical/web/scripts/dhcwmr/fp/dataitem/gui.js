function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	
	//编目数据项列表
	obj.txtDICode = Common_TextField("txtDICode","<b style='color:red'>*</b>代码");
	obj.txtDIDesc = Common_TextField("txtDIDesc","<b style='color:red'>*</b>名称");
	obj.txtDIResume = Common_TextField("txtDIResume","备注");
	
	obj.txtItemAlias = Common_TextField("txtItemAlias","关键字");
	
	obj.gridDataItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDataItemStore = new Ext.data.Store({
		proxy: obj.gridDataItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'DICode', mapping : 'DICode'}
			,{name: 'DIDesc', mapping: 'DIDesc'}
			,{name: 'DIResume', mapping: 'DIResume'}
		])
	});
	obj.gridDataItem = new Ext.grid.EditorGridPanel({
		id : 'gridDataItem'
		,store : obj.gridDataItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 30, dataIndex: 'DICode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 80, dataIndex: 'DIDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 50, dataIndex: 'DIResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridDataItemStore,
			displayMsg : '',
			displayInfo: true,
			emptyMsg: ''
		})
		,viewConfig : {
			forceFit : true
		}
    });
	obj.btnUpdate = new Ext.Toolbar.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.DataItemPanel = new Ext.Panel({
		buttonAlign : 'center'
		,region : 'west'
		,width : 350
		,layout : 'border'
		,tbar : [{id:'msgGridDataItem',text:'数据项维护',style:'font-weight:bold;font-size:14px;',xtype:'label'},'-','关键字检索:',obj.txtItemAlias,'-']
		,items:[
			obj.gridDataItem
			,{
				region : 'south'
				,height : 35
				,frame : true
				,layout : 'column'
				,items :[
					{
						width : 100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtDICode]
					},{
						width : 150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtDIDesc]
					},{
						columnWidth : .99
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtDIResume]
					}
				]
			}
		]
		,bbar : [obj.btnUpdate]
	});
	
	//关联模板单元/元数据列表
	obj.chkIsViewAll  = Common_Checkbox("chkIsViewAll","显示全部");
	obj.txtElDesc = Common_TextField("txtElDesc","单元名称");
	obj.txtElCode = Common_TextField("txtElCode","首页单元");
	obj.gridDataItemLnkStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDataItemLnkStore = new Ext.data.Store({
		proxy: obj.gridDataItemLnkStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MRItemID'
		},
		[
			{name: 'MRItemID', mapping : 'MRItemID'}
			,{name: 'MRItemDesc', mapping : 'MRItemDesc'}
			,{name: 'ElementCode', mapping: 'ElementCode'}
			,{name: 'ElementDesc', mapping: 'ElementDesc'}
			,{name: 'ItemLnkID', mapping: 'ItemLnkID'}
			,{name: 'LnkFlag', mapping: 'LnkFlag'}
			,{name: 'FPItemCode', mapping: 'FPItemCode'}
			,{name: 'FPItemDesc', mapping: 'FPItemDesc'}
			,{name: 'IsChecked', mapping: 'IsChecked'}
		])
	});
	obj.gridDataItemLnk = new Ext.grid.EditorGridPanel({
		id : 'gridDataItemLnk'
		,store : obj.gridDataItemLnkStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 30, dataIndex: 'LnkFlag', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var LnkFlag = rd.get("LnkFlag");
					if (LnkFlag == "1"){
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else if (LnkFlag == "0"){
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					} else {
						return "-";
					}
				}
			}
			,{header: '首页单元', width: 150, dataIndex: 'ElementCode', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '单元名称', width: 130, dataIndex: 'ElementDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '已关联项目代码', width: 80, dataIndex: 'FPItemCode', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '已关联项目名称', width: 80, dataIndex: 'FPItemDesc', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridDataItemLnkStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
    });
	obj.DataItemLnkPanel = new Ext.Panel({
		region : 'center'
		,layout : 'border'
		,tbar : [{id:'msgGridDataItemLnk',text:'数据项关联代码维护',style:'font-weight:bold;font-size:14px;',xtype:'label'}]
		,items:[
			obj.gridDataItemLnk
			,{
				region : 'south'
				,height : 35
				,frame : true
				,layout : 'column'
				,items :[
					{
						width : 90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.chkIsViewAll]
					},{
						width : 240
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.txtElDesc]
					},{
						width : 240
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.txtElCode]
					}
				]
			}
		],bbar : ['->','…']
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.DataItemPanel
			,obj.DataItemLnkPanel
		]
	});
	obj.gridDataItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.DataItemSrv';
		param.QueryName = 'QryItemList';
		param.Arg1 = Common_GetValue("txtItemAlias");
		param.ArgCnt = 1;
	});
	
	obj.gridDataItemLnkStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.DataItemSrv';
		param.QueryName = 'QryDataItemLnk';
		param.Arg1 = obj.RecRowID;
		param.Arg2 = (Common_GetValue('chkIsViewAll') ? 1 : 0);
		param.Arg3 = Common_GetValue('txtElDesc');
		param.Arg4 = Common_GetValue('txtElCode');
		param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

