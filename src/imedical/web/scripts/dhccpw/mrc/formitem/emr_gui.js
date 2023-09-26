var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.txtItemDesc = Common_TextField("txtDesc","��Ŀ����");
	obj.txtItemGroup = Common_NumberField("txtItemGroup","����",0,0);
	obj.cboItemSubCat = Common_ComboToItmSubCat("cboItemSubCat","��Ŀ����");
	obj.chkIsActive = Common_Checkbox("chkIsActive","�Ƿ��ѡ��");
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 50
		,anchor : '100%'
		,text : '����'
	});
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,width : 50
		,anchor : '100%'
		,text : '����'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 60
		,anchor : '100%'
		,text : 'ɾ��'
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
			,{name: 'IsMustFlag', mapping: 'IsMustFlag'}
			,{name: 'IsMustDesc', mapping: 'IsMustDesc'}
		])
		,sortInfo:{field: 'SubCatID', direction: "ASC"}
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
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��Ŀ����', width: 350, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '����', width: 50, dataIndex: 'GroupNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ŀ����', width: 100, dataIndex: 'SubCatDesc', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '�Ƿ�<br>��ѡ', width: 50, dataIndex: 'IsMustDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��Ŀ����', width: 0, dataIndex: 'CatDesc', sortable: false, menuDisabled:true, hidden:true, align: 'center'}
		]
		,view: new Ext.grid.GroupingView({
			//forceFit:true,
			groupTextTpl: '{[values.rs[0].get("CatDesc")]}(��{[values.rs.length]}����Ŀ)',
			groupByText:'�����з���'
		})
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'south',
				height: 70,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.txtItemDesc]
					},{
						width:90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.txtItemGroup]
					},{
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboItemSubCat]
					},{
						width:120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.chkIsActive]
					}
				],
				buttons : [obj.btnUpdate,obj.btnAdd,{style:'width:100px;',xtype:'label'},obj.btnDelete]
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