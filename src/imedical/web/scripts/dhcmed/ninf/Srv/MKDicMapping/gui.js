function InitviewScreen(){
	var obj = new Object();
	
	obj.RecRowID = '';
	obj.GroupCode =  '';
	obj.TypeCode =  '';
	
	obj.cboCategoryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCategoryStore = new Ext.data.Store({
		proxy: obj.cboCategoryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.cboCategory = new Ext.form.ComboBox({
		id : 'cboCategory'
		,store : obj.cboCategoryStore
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '��ѡ��������'
		,valueField : 'Code'
		,editable : false
		,width : 200
		,triggerAction : 'all'
	});
	
	obj.txtSrcObjID = Common_TextField("txtSrcObjID","Դֵ");
	obj.txtSrcObjDesc = Common_TextField("txtSrcObjDesc","����");
	obj.txtTargetID = Common_TextField("txtTargetID","Ŀ��ֵ");
	obj.txtResume = Common_TextField("txtResume","˵��");
	
	obj.cboTargetDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboTargetDescStore = new Ext.data.Store({
		proxy: obj.cboTargetDescStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		},
		[
			{name: 'DicID', mapping : 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicSpell', mapping: 'DicSpell'}
		])
	});
	obj.cboTargetDesc = new Ext.form.ComboBox({
		id : 'cboTargetDesc'
		,fieldLabel : '����'
		,width : 100
		,store : obj.cboTargetDescStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>����</th>',
					'<th>����</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{DicCode}</td>',
					'<td>{DicDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:300
		,valueField : 'DicCode'
		,displayField : 'DicDesc'
		,loadingText: '��ѯ��,���Ե�...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((!field.getValue())||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 80
		,text : 'ɾ��'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 80
		,text : '����'
	});
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width: 80
		,text : '��ѯ'
	});
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Category', mapping: 'Category'}
			,{name: 'SrcObjectID', mapping: 'SrcObjectID'}
			,{name: 'SrcDescription', mapping: 'SrcDescription'}
			,{name: 'Target', mapping: 'Target'}
			,{name: 'TargetDesc', mapping: 'TargetDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
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
			,{header: 'Դֵ', width: 100, dataIndex: 'SrcObjectID', sortable: true, menuDisabled:true, align: 'center'}
			,{header: 'Դֵ����', width: 150, dataIndex: 'SrcDescription', sortable: true, menuDisabled:true, align: 'center'}
			,{header: 'Ŀ��ֵ', width: 100, dataIndex: 'Target', sortable: true, menuDisabled:true, align: 'center'}
			,{header: 'Ŀ��ֵ����', width: 150, dataIndex: 'TargetDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '˵��', width: 200, dataIndex: 'ResumeText', sortable: true, menuDisabled:true, align: 'center'}
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
										width:160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSrcObjID]
									},{
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
										,items: [obj.txtTargetID]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboTargetDesc]
									},{
										columnWidth:1
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
							obj.gridResult
						]
					}
				],
				bbar : [obj.btnFind,obj.btnUpdate,obj.btnDelete,'->','��']
			}
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINF.Srv.MKDicMapping';
		param.QueryName = 'QryByCategoryNew';
		param.Arg1 = obj.cboCategory.getValue();
		param.Arg2 = '' //obj.txtSrcObjID.getValue();   //Common_GetValue("txtSrcObjID");
		param.Arg3 = obj.txtSrcObjDesc.getValue();   //Common_GetValue("txtSrcObjDesc");
		param.Arg4 = '' //obj.txtTargetID.getValue();   //Common_GetValue("txtTargetID");
		param.Arg5 = '' //obj.cboTargetDesc.getRawValue();
		param.ArgCnt = 5;
	});
	obj.cboCategoryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QrySSDictionary';
		param.Arg1 = 'INFMinkeMappingType';
		param.ArgCnt = 1;
	});
	obj.cboTargetDescStoreProxy.on('beforeload', function(objProxy, param){
		if (obj.GroupCode=='MKDIC') {
			//��������ֵ�
			param.ClassName = 'DHCMed.NINF.Srv.MKDictionary';
			param.QueryName = 'QryMKDicByType';
			param.Arg1 = obj.TypeCode;
			param.Arg2 = obj.cboTargetDesc.getRawValue();
			param.ArgCnt = 2;
		} else {
			//����Ժ������ֵ�
			param.ClassName = 'DHCMed.NINF.Srv.MKInfMapping';
			param.QueryName = 'QryInfDicByType';
			param.Arg1 = obj.GroupCode;
			param.Arg2 = obj.TypeCode;
			param.Arg3 = obj.cboTargetDesc.getRawValue();
			param.ArgCnt = 3;
		}
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

