///ҵ����˵ȼ�ά��
var DictUrl="dhcst."
var unitsUrl = 'dhcst.stkauditlevelaction.csp';
var TmpUserId = ""
Ext.onReady(function() {
	
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.Ajax.timeout = 900000;
	var QueryButton = new Ext.Button({
		width: 65,
		id: "QueryBtn",
		text: $g('��ѯ'),
		iconCls: 'page_find',
		listeners: {
			"click": function() {
				QueryAuditLevel();
			}
		}
	}) 
	var SaveButton = new Ext.Button({
		width: 65,
		id: "SaveBtn",
		text: $g('����'),
		iconCls: 'page_save',
		listeners: {
			"click": function() {
				SaveAuditLevel();
			}
		}
	}) 
	// ���Ӱ�ť
	var AddButton = new Ext.Toolbar.Button({
		id: "AddBtn",
		text: $g('����'),
		tooltip: $g('�������'),
		width: 70,
		height: 30,
		iconCls: 'page_add',
		handler: function() { // �ж��Ƿ��Ѿ��������
			var rowCount = StkAuditLevelgrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = StkAuditLevelgridds.data.items[rowCount - 1];
				var data = rowData.get("ActiveFlagId");
				if (data == null || data.length <= 0) {
					Msg.info("warning", $g("�Ѵ����½���!"));
					return;
				}
			}
			addNewRow();
		}
	});
	var DelButton = new Ext.Toolbar.Button({
		id: 'DelBtn',
		text: $g('ɾ��'),
		width: '70',
		height: '30',
		tooltip: $g('���ɾ��'),
		iconCls: 'page_delete',
		handler: function() {
			DelAuditLevel();
		}
	}); 
	// ���ñ�ʶ	
	var ActiveFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['Y',$g('����')],['N',$g('δ����')]]
	});
	
	// ���ñ�ʶ
	var ActiveFlag = new Ext.form.ComboBox({
	    id:'ActiveFlag',
	    listWidth:50,
	    store:ActiveFlagStore,
	    valueField:'RowId',
	    displayField:'Description',
	    triggerAction:'all',
	    mode:'local',
	    selectOnFocus:true,
	    forceSelection:true,
	    editable:true
	})
	// ��Ŀ����	
	var STALTypeStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : DictUrl+'stkauditlevelaction.csp?action=GetSTALType'
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['RowId','Description'])
	});	
 
	// ��Ŀ���� 
	var STALType = new Ext.ux.ComboBox({
		fieldLabel: $g('��Ŀ����'),
		id: 'STALType',
		name: 'STALType',
		//anchor : '90%',
		width: 50,
		store: STALTypeStore,
		//valueField : 'TypeId',
		valueField: 'RowId',
		displayField: 'Description'
	}); 

	//��Ŀ������ȫ��
	var STALSSGroup = new Ext.ux.ComboBox({
		fieldLabel: $g('��Ŀ������ȫ��'),
		id: 'STALSSGroup',
		name: 'STALSSGroup',
		//anchor : '90%',
		width: 50,
		store: GroupComboStore,
		valueField: 'RowId',
		displayField: 'Description'
	}); 
	STALSSGroup.on('beforequery', function(e) {
		var groupdesc=Ext.getCmp("STALSSGroup").getRawValue();
		GroupComboStore.removeAll();
		GroupComboStore.setBaseParam('FilterDesc',groupdesc);
		GroupComboStore.load({});	
	}); 
	//����
	var STALItmLoc = new Ext.ux.ComboBox({
		fieldLabel: $g('����'),
		id: 'STALItmLoc',
		name: 'STALItmLoc',
		//anchor : '90%',
		width: 50,
		store: DeptLocStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'ItmLocName',
		listeners:{
			select:function()
			{  
			   var cell = StkAuditLevelgrid.getSelectionModel().getSelectedCell(); 
			   var rowData = StkAuditLevelgrid.getStore().getAt(cell[0]);
			   rowData.set("SSUserId","");
			   rowData.set("SSUserDesc","");
			} 
		}  
		
	}); 
	STALItmLoc.on('beforequery', function(e) {
		var ctlocdesc=Ext.getCmp("STALItmLoc").getRawValue();
		DeptLocStore.removeAll();
		DeptLocStore.setBaseParam('locDesc',ctlocdesc);
		DeptLocStore.load({});	
	}); 
	//�����
	var STALSSUser = new Ext.ux.ComboBox({
		fieldLabel: $g('�����'),
		id: 'STALSSUser',
		name: 'STALSSUser',
		width: 50,
		store: DeptUserStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'SSUserName',
		typeAhead:false,
		editable:false,
		listeners:{'focus':{fn:function(e){e.expand();this.doQuery(this.allQuery, true);},buffer:200}},	
	});
	STALSSUser.on('beforequery', function(e) {
		var cell = StkAuditLevelgrid.getSelectionModel().getSelectedCell();
        // ѡ����
        var row = cell[0];
        var rowData = StkAuditLevelgrid.getStore().getAt(row);
        var ctlocid=rowData.data.ItmLocId
		var userdesc=Ext.getCmp("STALSSUser").getRawValue();
		TmpUserId = Ext.getCmp("STALSSUser").getValue();
		/// �ӳ����¼��ظ��е�User��Store����Ȼ��һ�е�User-Store���ȸ��ǹ����ѵ�ǰ�е�ѡ��ֱֵ������� 2021-08-24
		setTimeout(function(){    
			DeptUserStore.removeAll();
			DeptUserStore.setBaseParam('locId',ctlocid);
			DeptUserStore.setBaseParam('Desc',userdesc);
			DeptUserStore.load({});	
			},300)
		
	}); 
	
	DeptUserStore.addListener('load', function(st, rds, opts) {
		//alert(TmpUserId)
        Ext.getCmp("STALSSUser").setValue(TmpUserId);
});

	
	// ����·��
	var DetailUrl = unitsUrl+'?action=QueryAuditLevel'; // ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url: DetailUrl,
		method: "POST"
	}); 
	// ָ���в���  //"OriginId","OriginDesc"
	var fields = ["STALRowId", "ActiveFlagId", "ActiveFlagDesc", "TypeId", "TypeDesc", "STALItmDesc", "ItmLevel", "SSGroupId", "SSGroupDesc", "ItmLocId", "ItmLocDesc", "SSUserId", "SSUserDesc"]; // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "StkAuditLevel",
		fields: fields
	}); 
	// ���ݼ�
	var StkAuditLevelgridds = new Ext.data.Store({
		proxy: proxy,
		reader: reader
	});
	var nm = new Ext.grid.RowNumberer();
	var StkAuditLevelgridcm = new Ext.grid.ColumnModel([nm, {
		header: "RowId",
		dataIndex: 'STALRowId',
		width: 20,
		align: 'left',
		sortable: true,
		hidden: true
	},
	{
		header: $g("���ñ�ʶ"),
		dataIndex: 'ActiveFlagId',
		width: 70,
		align: 'center',
		sortable: true,
		editor: new Ext.grid.GridEditor(ActiveFlag),
		renderer: Ext.util.Format.comboRenderer2(ActiveFlag, "ActiveFlagId", "ActiveFlagDesc")
	},
	{
		header: $g('��Ŀ����'),
		dataIndex: 'TypeId',
		width: 100,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(STALType),
		renderer: Ext.util.Format.comboRenderer2(STALType, "TypeId", "TypeDesc")
	},
	{
		header: $g('��Ŀ����'),
		dataIndex: 'STALItmDesc',
		width: 100,
		align: 'left',
		sortable: true,
		hidden:true,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus: true,
			allowBlank: false,
			listeners: {
				specialkey: function(field, e) {

				}
			}
		}))
	},
	{
		header: $g("��Ŀ�ȼ�����"),
		dataIndex: 'ItmLevel',
		width: 100,
		align: 'left',
		sortable: true,
		editor: new Ext.form.NumberField  
	},
	{
		header: $g("��ȫ��"),
		dataIndex: 'SSGroupId',
		width: 150,
		align: 'center',
		sortable: true,
		editor: new Ext.grid.GridEditor(STALSSGroup),
		renderer: Ext.util.Format.comboRenderer2(STALSSGroup, "SSGroupId", "SSGroupDesc")
	},

	{
		header: $g("����"),
		dataIndex: 'ItmLocId',
		width: 180,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(STALItmLoc),
		renderer: Ext.util.Format.comboRenderer2(STALItmLoc, "ItmLocId", "ItmLocDesc")
	},
	{
		header: $g("�����"),
		dataIndex: 'SSUserId',
		width: 180,
		align: 'left',
		editor: new Ext.grid.GridEditor(STALSSUser),
		renderer: Ext.util.Format.comboRenderer2(STALSSUser, "SSUserId", "SSUserDesc")
	}]); 
	function addNewRow() {
		var record = Ext.data.Record.create([{
			name: 'STALRowId',
			type: 'string'
		},
		{
			name: 'ActiveFlagId',
			type: 'string'
		},
		{
			name: 'TypeId',
			type: 'string'
		},
		{
			name: 'STALItmDesc',
			type: 'string'
		},
		{
			name: 'ItmLevel',
			type: 'string'
		},
		{
			name: 'SSGroupId',
			type: 'string'
		},
		{
			name: 'ItmLocId',
			type: 'string'
		},
		{
			name: 'SSUserId',
			type: 'string'
		}]);
		var NewRecord = new record({
			STALRowId: '',
			ActiveFlagId: '',
			TypeId: '',
			STALItmDesc: '',
			ItmLevel: '',
			SSGroupId: '',
			ItmLocId: '',
			SSUserId: ''
		});
	StkAuditLevelgridds.add(NewRecord); 
	StkAuditLevelgrid.startEditing(StkAuditLevelgridds.getCount() - 1, 2);
	};
	var StkAuditLevelgrid = new Ext.grid.EditorGridPanel({
		id: 'StkAuditLeveltbl',
		title: $g('ҵ����˵ȼ�ά��'),
		region: 'center',
		autoScroll: true,//�Զ����ɹ�����
		enableHdMenu: false,
		frame: true,
		height: 690,
		ds: StkAuditLevelgridds,
		cm: StkAuditLevelgridcm,
		stripeRows: true,
		loadMask: true,
		sm: new Ext.grid.CellSelectionModel({}),
		enableColumnMove: false,
		stripeRows: true,
		clicksToEdit: 1,
		tbar: [ AddButton, "-", DelButton, "-", SaveButton],
		trackMouseOver: 'true'
	});
	var HospPanel = InitHospCombo('DHC_StkAuditLevel',function(combo, record, index){
		HospId = this.value; 
		GroupComboStore.removeAll();
		GroupComboStore.reload();
		DeptLocStore.removeAll();
		DeptLocStore.reload();
		QueryAuditLevel();
	});		
	var QueryForm = new Ext.Panel({
		id:"QueryForm",
		region: 'center',
		frame: true,
		items: [StkAuditLevelgrid]
	}) 
	var port = new Ext.Viewport({
		layout: 'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel]
			},QueryForm
		],

		renderTo: 'mainPanel'
	}); 

	
	///-----------------------------------------------------------------
	///��������
	function QueryAuditLevel() {
		//StkAuditLevelgridds.removeAll(); 
		StkAuditLevelgridds.load({params:{start:0,limit:30,sort:"",dir:""}});
	}
	function SaveAuditLevel() {
		var ListDetail = ""
		var rowCount = StkAuditLevelgrid.getStore().getCount(); 
		for (var i = 0; i < rowCount; i++) {
			var rowData = StkAuditLevelgridds.getAt(i);
			if (rowData.data.newRecord || rowData.dirty) {
				var STALRowId = rowData.get("STALRowId");
				var ActiveFlagId = rowData.get("ActiveFlagId");
				var TypeId = rowData.get("TypeId");
				var STALItmDesc = rowData.get("STALItmDesc");
				var ItmLevel = rowData.get("ItmLevel");
				var SSGroupId = rowData.get("SSGroupId");
				var StkGrpId ="G";  // rowData.get("StkGrpId");
				var ItmLocId = rowData.get("ItmLocId");
				var SSUserId = rowData.get("SSUserId");
				if ((ActiveFlagId==null)||(ActiveFlagId==""))
				{
					Msg.info("warning", $g("��ά������״̬!"));
					return
				}
				if ((TypeId==null)||(TypeId==""))
				{
					Msg.info("warning", $g("��ά����Ŀ����!"));
					return
				}
				if ((TypeId==null)||(TypeId==""))
				{
					Msg.info("warning", $g("��ά����Ŀ����!"));
					return
				}
				if((TypeId=="Basic")&&((SSUserId=="")||(SSUserId==null))) 
				{
					Msg.info("warning", $g("��Ŀ����ΪҩƷ��Ϣʱ,����˱���!"));
					return	
				}
				if ((SSUserId=="")&&(ItmLocId=="")&&(SSGroupId==""))
				{
					Msg.info("warning", "��ȫ��,����,����˲���ͬʱΪ��!");
					return	
				}
				var str = STALRowId + "^" + ActiveFlagId + "^" + TypeId + "^" + encodeURI(STALItmDesc) + "^" + ItmLevel + "^" + SSGroupId + "^" + StkGrpId + "^" + ItmLocId + "^" + SSUserId
				if (ListDetail == "") {
					ListDetail = str;
				} else {
					ListDetail = ListDetail + "!!" + str;
				}
			}
		}
		
		if (ListDetail == "") {
			Msg.info("Warning", $g("û����Ҫ�������ϸ!"));
			return false;
		} 
		///���ݿ⽻��
		Ext.Ajax.request({
			url: unitsUrl + '?action=SaveAuditLevel&ListDetail=' + ListDetail,
			failure: function(result, request) {
				Ext.Msg.show({
					title: $g('����'),
					msg: $g('������������!'),
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) { 
					Msg.info("success", $g("����ɹ�!"));
					QueryAuditLevel();
				} else if (jsonData.retvalue == -1) {
					Ext.Msg.alert($g("��ʾ"), $g("�����ظ���"));
				} else if (jsonData.retvalue == -5) {
					Ext.Msg.alert($g("��ʾ"), $g("û����Ҫ���������!����ֵ: ") + jsonData.retinfo);
				} else {
					Ext.Msg.alert($g("��ʾ"), $g("���ʧ��!����ֵ: ") + jsonData.retinfo);
				}
			},
			scope: this
		});
	}
	function DelAuditLevel() {
		var cell = StkAuditLevelgrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", $g("��ѡ��Ҫɾ���ļ�¼��"));
			return;
		}
		var row = cell[0];
		var record = StkAuditLevelgridds.getAt(row);
		var STALRowid = record.get("STALRowId");
		if (STALRowid == null || STALRowid.length < 1) {
			Msg.info("warning", $g("��ѡ��¼��δ���棬����ɾ��!"));
			return;
		} else {
			Ext.MessageBox.show({
				title: $g('��ʾ'),
				msg: $g('�Ƿ�ȷ��ɾ���ü�¼'),
				buttons: Ext.MessageBox.YESNO,
				fn: showResult,
				icon: Ext.MessageBox.QUESTION
			});
		}
		function showResult(btn) {
			if (btn == "yes") { 
				var mask = ShowLoadMask(Ext.getBody(), $g("���������Ժ�..."));
				Ext.Ajax.request({
					url: unitsUrl + '?action=DelAuditLevel&STALRowid=' + STALRowid,
					success: function(response, opts) {
						var jsonData = Ext.util.JSON.decode(response.responseText);
						mask.hide();
						if (jsonData.retvalue == 0) {
							Msg.info("success", $g("ɾ���ɹ�!"));
							QueryAuditLevel();
						} else if (jsonData.retvalue == -1) {
							Msg.info("error", $g("��ѡ����ɾ����¼!"));
						} else {
							Msg.info("error", $g("ɾ��ʧ��!"));
						}
					}
				});
			}
		}
	}
});