function InitviewScreen(){
	var obj = new Object();
	
	obj.RecRowID = '';
	obj.SrcObjDescID =  '';
	
	obj.cboCategory = Common_ComboToDic("cboCategory","�������","EPDCDCDicName");
	obj.cboCategory.width=200;
	obj.txtSrcObjDesc = Common_TextField("txtSrcObjDesc","����");
	obj.txtTargetDesc = Common_TextField("txtTargetDesc","Ŀ��ֵ");
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 80
		,text : '����'
	});
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ind'
		}, 
		[
			{name: 'ind', mapping: 'ind'}
			,{name: 'MappingID', mapping: 'MappingID'}
			,{name: 'argDicID', mapping: 'argDicID'}
			,{name: 'DicName', mapping: 'DicName'}
			,{name: 'TargetDesc', mapping: 'TargetDesc'}
		])
	});
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,columnLines : true
		,region : 'center'
		,tbar : new Ext.Toolbar({
			items: [
				new Ext.form.Label({text : '��ѡ�������Ϣ���'}),
				obj.cboCategory
			]
		})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'Դֵ����', width: 200, dataIndex: 'DicName', sortable: true, menuDisabled:true, align: 'center'}
			,{header: 'Ŀ��ֵ����', width: 200, dataIndex: 'TargetDesc', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridResultStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
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
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSrcObjDesc]
									},{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtTargetDesc]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridResult
						]
					}
				],
				bbar : [obj.btnUpdate,'->','��']
			}
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.DicMapping';
		param.QueryName = 'QryDicMapInfo';
		param.Arg1 = obj.cboCategory.getValue();
		param.ArgCnt = 1;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

