var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	obj.currRowIndex = '';
	
	obj.txtItemDesc = Common_TextField("txtItemDesc","项目名称");
	obj.txtGroupNo = Common_NumberField("txtGroupNo","序号",0,0);
	obj.cboItemSubCat = Common_ComboToItmSubCat("cboItemSubCat","项目分类");
	
	obj.IsReadOnly = (ReadOnly=='Y');
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,text : '<span>更新</span>'
		,disabled : obj.IsReadOnly
		,width : 70
	});
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,text : '<span>增加</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '<span>删除</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	
	obj.gridFormItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridFormItemStore = new Ext.data.GroupingStore({
		proxy: obj.gridFormItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		},[
			{name: 'ItemID', mapping : 'ItemID'}
			,{name: 'ItemDesc', mapping : 'ItemDesc'}
			,{name: 'GroupNo', mapping : 'GroupNo'}
			,{name: 'SubCatID', mapping : 'SubCatID'}
			,{name: 'SubCatDesc', mapping: 'SubCatDesc'}
			,{name: 'CatID', mapping: 'CatID'}
			,{name: 'CatDesc', mapping: 'CatDesc'}
			,{name: 'IsOptional', mapping: 'IsOptional'}
		])
		,sortInfo:{field: 'CatID', direction: "ASC"}
		,groupField:'CatDesc'
	});
	obj.gridFormItem = new Ext.grid.GridPanel({
		id : 'gridFormItem'
		,store : obj.gridFormItemStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,bbar : [{style:'width:50px;',xtype:'label'},obj.btnUpdate,{style:'width:50px;',xtype:'label'},obj.btnAdd,{style:'width:50px;',xtype:'label'},obj.btnDelete]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '项目分类', width: 100, dataIndex: 'SubCatDesc', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '项目名称', width: 350, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '顺序号', width: 50, dataIndex: 'GroupNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '可否<br>不执行', width: 50, dataIndex: 'IsOptional', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsOptional = rd.get("IsOptional");
					if (IsOptional == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '项目大类', width: 0, dataIndex: 'CatDesc', sortable: false, menuDisabled:true, hidden:true, align: 'center'}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '{[values.rs[0].get("CatDesc")]}(共{[values.rs.length]}个项目)',
			groupByText:'依本列分组'
		})
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'south',
				height: 35,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboItemSubCat]
					},{
						width:300
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.txtItemDesc]
					},{
						width:100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,items: [obj.txtGroupNo]
					}
				]
			}
			,obj.gridFormItem
		]
	});
	
	obj.gridFormItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCCPW.MRC.FORM.ItemEditSrv';
		param.QueryName = 'QryItemByStep';
		param.Arg1 = FormStepID;
		param.Arg2 = '';
		param.ArgCnt = 2;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}