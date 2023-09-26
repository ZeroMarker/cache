
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","����");
	obj.txtDesc = Common_TextField("txtDesc","����");
	obj.chkIsActive = Common_Checkbox("chkIsActive","�Ƿ���Ч");
	obj.txtResume = Common_TextField("txtResume","��ע");
	
	obj.chkIsViewAll = Common_Checkbox("chkIsViewAll","��ʾȫ��");
	
	obj.gridInfPositionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfPositionStore = new Ext.data.Store({
		proxy: obj.gridInfPositionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'InfPosRowId'
		},
		[
			{name: 'InfPosRowId', mapping : 'InfPosRowId'}
			,{name: 'InfPosCode', mapping : 'InfPosCode'}
			,{name: 'InfPosDesc', mapping: 'InfPosDesc'}
			,{name: 'InfPosActive', mapping: 'InfPosActive'}
			,{name: 'InfPosActiveDesc', mapping: 'InfPosActiveDesc'}
			,{name: 'InfPosResume', mapping: 'InfPosResume'}
		])
	});
	obj.gridInfPosition = new Ext.grid.EditorGridPanel({
		id : 'gridInfPosition'
		,store : obj.gridInfPositionStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '����', width: 20, dataIndex: 'InfPosCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '����', width: 80, dataIndex: 'InfPosDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Ƿ�<br>��Ч', width: 40, dataIndex: 'InfPosActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '��ע', width: 50, dataIndex: 'InfPosResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.gridInfDiagnoseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfDiagnoseStore = new Ext.data.Store({
		proxy: obj.gridInfDiagnoseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IDRowID'
		}, 
		[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'MapID', mapping: 'MapID'}
			,{name: 'IPRowID', mapping: 'IPRowID'}
			,{name: 'IPCode', mapping: 'IPCode'}
			,{name: 'IPDesc', mapping: 'IPDesc'}
			,{name: 'IDRowID', mapping: 'IDRowID'}
			,{name: 'IDCode', mapping: 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
		])
	});
	obj.gridInfDiagnose = new Ext.grid.EditorGridPanel({
		id : 'gridInfDiagnose'
		,store : obj.gridInfDiagnoseStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: 'ѡ��', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '�������', width: 150, dataIndex: 'IDDesc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.gridInfOperStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfOperStore = new Ext.data.Store({
		proxy: obj.gridInfOperStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IDRowID'
		}, 
		[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'MapID', mapping: 'MapID'}
			,{name: 'IPRowID', mapping: 'IPRowID'}
			,{name: 'IPCode', mapping: 'IPCode'}
			,{name: 'IPDesc', mapping: 'IPDesc'}
			,{name: 'IDRowID', mapping: 'IDRowID'}
			,{name: 'IDCode', mapping: 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
		])
	});
	obj.gridInfOper = new Ext.grid.EditorGridPanel({
		id : 'gridInfOper'
		,store : obj.gridInfOperStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: 'ѡ��', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '�ֺ��Բ���', width: 150, dataIndex: 'IDDesc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });

	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '����'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : 'ɾ��'
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
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										width : 90
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsActive]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridInfPosition
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','��']
			},{
				region: 'east',
				width : 300,
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
							obj.gridInfDiagnose
						]
					},{
						region: 'north',
						height:300,
						layout : 'fit',
						frame : true,
						items : [
							obj.gridInfOper
						]
					}
				],
				bbar : ['��Ⱦ��λ�������ø�Ⱦ���','->','��']
			}
		]
	});
	
	obj.gridInfPositionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.InfPosition';
		param.QueryName = 'QryInfPosition';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	obj.gridInfDiagnoseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.MapPosDia';
		param.QueryName = 'QryDiagByInfPos';
		
		var InfPosition = "";
		var objRec = obj.gridInfPosition.getSelectionModel().getSelected();
		if (objRec) {
			InfPosition = objRec.get("InfPosRowId");
		}
		
		param.Arg1 = InfPosition;
		param.Arg2 = (obj.chkIsViewAll.getValue()==true ? "Y" : "N");
		param.ArgCnt = 2;
	});
	
	obj.gridInfOperStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.MapPosOperDic';
		param.QueryName = 'QryOperByInfPos0';
		
		var InfPosition = "";
		var objRec = obj.gridInfPosition.getSelectionModel().getSelected();
		if (objRec) {
			InfPosition = objRec.get("InfPosRowId");
		}
		
		param.Arg1 = InfPosition;
		param.Arg2 = (obj.chkIsViewAll.getValue()==true ? "Y" : "N");
		param.ArgCnt = 2;

	});

	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

