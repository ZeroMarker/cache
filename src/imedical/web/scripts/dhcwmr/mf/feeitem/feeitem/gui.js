
function InitViewport1(){
	var obj = new Object();
	obj.FeeItemID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");

	obj.gridFeeItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridFeeItemStore = new Ext.data.Store({
		proxy: obj.gridFeeItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'FICode', mapping : 'FICode'}
			,{name: 'FIDesc', mapping : 'FIDesc'}
		])
	});
	obj.gridFeeItem = new Ext.grid.EditorGridPanel({
		id : 'gridFeeItem'
		,store : obj.gridFeeItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,layout : 'fit'
		,loadMask : true
		,tbar : [{id:'msgGridFeeItem',text:'收费项维护',style:'font-weight:bold;font-size:14px;',xtype:'label'},'-']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '收费项代码', width: 80, dataIndex: 'FICode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '收费项名称', width: 200, dataIndex: 'FIDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '关联HIS收费项', width: 200, dataIndex: '', sortable: true, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					return " <a href='#' onclick='DisplayLnkHISFeeItemWindow(\""+r+"\",\"\");'>关联</a>";
				}
			}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 30,
			store : obj.gridFeeItemStore,
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
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,frame: true
		,items:[
			obj.gridFeeItem
			/*
			,{
				region:'south'
				,height: 45
				,layout: 'column'
				,frame: true
				,items:[
					{
						columnWidth : .2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtCode]
					},{
						columnWidth : .2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtDesc]
					},{
						columnWidth : .08
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: []
					},{
						columnWidth : .2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.btnUpdate]
					}
				]
			}
			*/
		]
	});
	
	obj.gridFeeItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.MFService.FeeItemSrv";
		param.QueryName = "QryFeeItem";
		param.ArgCnt = 0;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

