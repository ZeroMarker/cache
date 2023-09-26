function InitViewport1(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";
	
	obj.PTCode = Common_TextField("PTCode","<b style='color:red'>*</b>����");
	obj.PTDesc = Common_TextField("PTDesc","<b style='color:red'>*</b>����");
	obj.PTIsActive = Common_Checkbox("PTIsActive","�Ƿ���Ч");
	obj.PTResume = Common_TextField("PTResume","��ע");
	
	obj.PTSCode = Common_TextField("PTSCode","<b style='color:red'>*</b>����");
	obj.PTSDesc = Common_TextField("PTSDesc","<b style='color:red'>*</b>����");
	obj.PTSIsActive = Common_Checkbox("PTSIsActive","�Ƿ���Ч");
	obj.PTSAutoMark = Common_Checkbox("PTSAutoMark","�Զ����");
	obj.PTSAutoCheck = Common_Checkbox("PTSAutoCheck","�Զ����");
	obj.PTSAutoClose = Common_Checkbox("PTSAutoClose","�Զ��ر�");
	obj.PTSIcon = Common_TextField("PTSIcon","<b style='color:red'>*</b>ͼ�궨��");
	obj.PTSResume = Common_TextField("PTSResume","��ע");
	
	//���ʹ���
	obj.gridPatTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	//�ӷ������
	obj.gridPatTypeSubStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	//����Store
	obj.gridPatTypeStore = new Ext.data.Store({
		proxy: obj.gridPatTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTID'
		},
		[
			{name: 'PTID', mapping : 'PTID'}
			,{name: 'PTCode', mapping : 'PTCode'}
			,{name: 'PTDesc', mapping: 'PTDesc'}
			,{name: 'PTIsActiveDesc', mapping: 'PTIsActiveDesc'}
			,{name: 'PTResume', mapping: 'PTResume'}
		])
	});
	//�ӷ���Store
	obj.gridPatTypeSubStore = new Ext.data.Store({
		proxy: obj.gridPatTypeSubStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTSID'
		},
		[
			{name: 'PTSID', mapping : 'PTSID'}
			,{name: 'PTSCode', mapping : 'PTSCode'}
			,{name: 'PTSDesc', mapping: 'PTSDesc'}
			,{name: 'PTSIcon', mapping: 'PTSIcon'}
			,{name: 'PTSAutoMarkDesc', mapping: 'PTSAutoMarkDesc'}
			,{name: 'PTSAutoCheckDesc', mapping: 'PTSAutoCheckDesc'}
			,{name: 'PTSAutoCloseDesc', mapping: 'PTSAutoCloseDesc'}
			,{name: 'PTSIsActiveDesc', mapping: 'PTSIsActiveDesc'}
			,{name: 'PTSResume', mapping: 'PTSResume'}
		])
	});
	//����Panel
	obj.gridPatType = new Ext.grid.EditorGridPanel({
		id : 'gridPatType'
		,store : obj.gridPatTypeStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 20, dataIndex: 'PTCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 60, dataIndex: 'PTDesc', sortable: false, menuDisabled:true, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '�Ƿ�<br>��Ч', width: 20, dataIndex: 'PTIsActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��ע', width: 60, dataIndex: 'PTResume', sortable: false, menuDisabled:true, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
		],viewConfig : {
			forceFit : true
		},bbar: new Ext.PagingToolbar({
			pageSize : 15,
			store : obj.gridPatTypeStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
    });
    //�ӷ���Panel
	obj.gridPatTypeSub = new Ext.grid.EditorGridPanel({
		id : 'gridPatTypeSub'
		,store : obj.gridPatTypeSubStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 50, dataIndex: 'PTSCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 150, dataIndex: 'PTSDesc', sortable: false, menuDisabled:true, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: 'ͼ�궨��', width: 70, dataIndex: 'PTSIcon', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '�Զ�<br>���', width: 40, dataIndex: 'PTSAutoMarkDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Զ�<br>���', width: 40, dataIndex: 'PTSAutoCheckDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Զ�<br>�ر�', width: 40, dataIndex: 'PTSAutoCloseDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Ƿ�<br>��Ч', width: 40, dataIndex: 'PTSIsActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��ע', width: 150, dataIndex: 'PTSResume', sortable: false, menuDisabled:true, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
		],viewConfig : {
			forceFit : true
		},bbar: new Ext.PagingToolbar({
			pageSize : 15,
			store : obj.gridPatTypeSubStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
    });
	obj.btnUpdate1 = new Ext.Toolbar.Button({
		id : 'btnUpdate1'
		,iconCls : 'icon-save'
		,width: 80
		,text : '����'
	});
	
	obj.btnDelete1 = new Ext.Toolbar.Button({
		id : 'btnDelete1'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : 'ɾ��'
	});
	
	obj.btnUpdate2 = new Ext.Toolbar.Button({
		id : 'btnUpdate2'
		,iconCls : 'icon-save'
		,width: 80
		,text : '����'
	});
	
	obj.btnDelete2 = new Ext.Toolbar.Button({
		id : 'btnDelete2'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : 'ɾ��'
	});
	//����panel
	obj.PatTypePanel = new Ext.Panel({
		title : '���⻼�߷���'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'center'
				,items:[obj.gridPatType]
			},{
				layout : 'fit'
				,region : 'south'
				,height : 70
				,items :[
				{
					layout : 'column'
					,items : [
					{
						width : 100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.PTCode]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.PTDesc]
					},{
						width : 100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.PTIsActive]
					},{
						width : 400
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.PTResume]
					}]		
				}]
			}
		],bbar : [obj.btnUpdate1,obj.btnDelete1,'->','��']
	});
	//�����panel
	obj.PatTypeSubPanel = new Ext.Panel({
		title : '���⻼���ӷ���'
		,region : 'center'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'center'
				,width:400 
				,items:[obj.gridPatTypeSub]
			},{
				layout : 'fit'
				,region : 'south'
				,height : 70
				,items :[
				{
					layout : 'column',
					items : [
					{
						width : 100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.PTSCode]
					},{
						width: 160
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.PTSDesc]
					},{
						width : 190
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 80
						,items: [obj.PTSIcon]
					},{
						width : 90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.PTSAutoMark]
					},{
						width : 90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.PTSAutoCheck]
					},{
						width : 450
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.PTSResume]
					},{
						width : 90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.PTSAutoClose]
					},{
						width : 90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.PTSIsActive]
					}]
				}]
			}
		],bbar : [obj.btnUpdate2,obj.btnDelete2,'->','��']
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'west'
				,width:450
				,frame : true
				,items:[obj.PatTypePanel]
			},{
				layout : 'fit'
				,region : 'center'
				,frame : true
				,items:[obj.PatTypeSubPanel]
			}
		]
	});
	
	obj.gridPatTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SPEService.PatType';
		param.QueryName = 'QryPatType';
		param.ArgCnt = 0;
	});
	
	obj.gridPatTypeSubStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SPEService.PatTypeSub';
		param.QueryName = 'QryPatTypeSub';
		param.Arg1 = obj.RecRowID1;
		//param.Arg1 = Ext.getCmp("gridPatType").getSelectionModel().getSelections()[0].get("PTID");
		param.ArgCnt = 1;

	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

