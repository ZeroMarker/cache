function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	
	obj.cboEnviHyLoc = Common_ComboToLoc("cboEnviHyLoc","����");
	obj.cboEnviHyItem = Common_ComboToEnviHyItem("cboEnviHyItem","�����Ŀ");
	obj.chkIsViewAll = Common_Checkbox("chkIsViewAll","��ʾȫ��");
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-edit'
		,width: 60
		,text : '����'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 60
		,text : 'ɾ��'
	});
	obj.btnSelectAll = new Ext.Button({
		id : 'btnSelectAll'
		,iconCls : 'icon-update'
		,width: 60
		,text : 'ȫѡ'
	});
	obj.btnSelectUnall = new Ext.Button({
		id : 'btnSelectUnall'
		,iconCls : 'icon-update'
		,width: 60
		,text : '��ѡ'
	});
	
	//�ж���׼ά��
	obj.gridEnviHyNormsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridEnviHyNormsStore = new Ext.data.Store({
		proxy: obj.gridEnviHyNormsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'NormID'
		},
		[
			{name: 'NormID', mapping : 'NormID'}
			,{name : 'IsLocNorm',mapping : 'IsLocNorm'}
			,{name: 'EHNCateg', mapping : 'EHNCateg'}
			,{name: 'EHNRange', mapping : 'EHNRange'}
			,{name: 'EHNNorm', mapping: 'EHNNorm'}
			,{name: 'ItemObj', mapping: 'ItemObj'}
			,{name: 'EHNNormMax', mapping: 'EHNNormMax'}
			,{name: 'EHNNormMin', mapping: 'EHNNormMin'}
			,{name: 'SpecimenTypeID', mapping : 'SpecimenTypeID'}
			,{name: 'SpecimenType', mapping : 'SpecimenType'}
			,{name: 'SpecimenNum', mapping: 'SpecimenNum'}
			,{name: 'CenterNum', mapping: 'CenterNum'}
			,{name: 'SurroundNum', mapping: 'SurroundNum'}
			,{name: 'IsActive', mapping: 'IsActive'}
		])
	});
	obj.gridEnviHyNorms = new Ext.grid.EditorGridPanel({
		id : 'gridEnviHyNorms'
		,store : obj.gridEnviHyNormsStore
		,selModel : new Ext.grid.RowSelectionModel()
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: 'ѡ��', width: 30, dataIndex: 'IsLocNorm', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					if (v == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '��ⷶΧ', width: 150, dataIndex: 'EHNRange', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '����׼', width: 150, dataIndex: 'EHNNorm', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '�걾', width: 70, dataIndex: 'SpecimenType', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�걾<br>����', width: 50, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '�Ƿ�<br>��Ч', width: 50, dataIndex: 'IsActive', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					if (v == '1') {
						return "��";
					} else {
						return "��";
					}
				}
			}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ConditionPanel = new Ext.Panel({
		id: 'ConditionPanel'
		,title: 'ά�����Ҽ����Ŀ...'
		,width:500
		,region: 'east'
		,layout: 'border'
		,buttonAlign : 'right'
		,frame : true
		,items:[
			{
				region: 'north'
				,layout : 'form'
				,height : 75
				,width : 200
				,labelAlign : 'right'
				,labelWidth : 70
				,items: [
					obj.cboEnviHyLoc
					,obj.cboEnviHyItem
					,obj.chkIsViewAll
				]
			}
			,obj.gridEnviHyNorms
		]
		,bbar:[obj.btnSelectAll,obj.btnSelectUnall,obj.btnUpdate,obj.btnDelete]
	});
	
	//���Һ���Ŀά��
	obj.gridEnviHyLocItemsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridEnviHyLocItemsStore = new Ext.data.Store({
		proxy: obj.gridEnviHyLocItemsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EHLIID'
		}, 
		[
			{name: 'EHLIID', mapping : 'EHLIID'}
			,{name: 'EnviHyLocID', mapping: 'EnviHyLocID'}
			,{name: 'EnviHyLoc', mapping: 'EnviHyLoc'}
			,{name: 'EnviHyItemID', mapping: 'EnviHyItemID'}
			,{name: 'EnviHyItem', mapping: 'EnviHyItem'}
			,{name: 'EnviHyNorms', mapping: 'EnviHyNorms'}
			,{name: 'EnviHyNormCnt', mapping: 'EnviHyNormCnt'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.gridEnviHyLocItems = new Ext.grid.GridPanel({
		id : 'gridEnviHyLocItems'
		,store : obj.gridEnviHyLocItemsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 180, dataIndex: 'EnviHyLoc', sortable: false, align: 'left'}
			,{header: '�����Ŀ', width: 180, dataIndex: 'EnviHyItem', sortable: false, align: 'left'}
			,{header: '��ⷶΧ', width: 60, dataIndex: 'EnviHyNormCnt', sortable: false, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridEnviHyLocItemsStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.ConditionPanel
			,obj.gridEnviHyLocItems
		]
	});
	
	//��ѯά�����
	obj.gridEnviHyLocItemsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.EnviHyLocItems';
		param.QueryName = 'QryEnviHyItemsByLoc';
		param.Arg1      = Common_GetValue('cboEnviHyLoc');
		param.Arg2      = "";
		param.ArgCnt 	= 2;
	});
	
	//��ѯ��ⷶΧ
	obj.gridEnviHyNormsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.EnviHyLocItems';
		param.QueryName = 'QryEnviHyNormsByLocItem';
		param.Arg1		= Common_GetValue('cboEnviHyLoc');
		param.Arg2      = Common_GetValue('cboEnviHyItem');
		param.Arg3 		= (obj.chkIsViewAll.getValue()==true ? "1" : "0");
		param.ArgCnt    = 3;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}