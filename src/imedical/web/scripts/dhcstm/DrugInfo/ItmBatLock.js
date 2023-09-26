// /����: ��������
// /��д�ߣ��쳬
// /��д����: 2015.05.019
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
			 GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciCode=record.get("InciCode");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("M_InciDesc").setValue(InciDesc);
			Ext.getCmp("M_InciCode").setValue(InciCode);
			search();
		}

		//==========����==========================
		
		//==========�ؼ�==========================
		// ���ʱ���
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '<font color=blue>���ʱ���</font>',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					search();	
				}
			}
		});
		// ��������
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '<font color=blue>��������</font>',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
		// ���ʱ���
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : '<font color=blue>���ʱ���</font>',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					search();	
				}
			}
		});
		// ��������
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			fieldLabel:'<font color=blue>����</font>',
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			UserId:gUserId,
			LocId:gLocId,
			DrugInfo:"Y",
			anchor : '90%',
			listeners:{
				'select':function(){
					Ext.getCmp("M_StkCat").setValue('');
				}
			}
		}); 
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '<font color=blue>������</font>',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'M_StkGrpType'}
		});
		var FindTypeData=[['ȫ��','1'],['����','2'],['������','3']];
	   var FindTypeStore = new Ext.data.SimpleStore({
		    fields: ['typedesc', 'typeid'],
		    data : FindTypeData
		})
	  var FindTypeCombo = new Ext.form.ComboBox({
		  store: FindTypeStore,
		  displayField:'typedesc',
		  mode: 'local', 
		  anchor : '90%',
		  emptyText:'',
		  id:'FindTypeCombo',
		  fieldLabel : 'ͳ�Ʒ�ʽ',
		  triggerAction:'all', //ȡ���Զ�����
		  valueField : 'typeid'
	   });
	   Ext.getCmp("FindTypeCombo").setValue("1");
		//==========�ؼ�==========================
	
		// ����·��
		var DspPhaUrl ='dhcstm.druginfomaintainaction.csp?actiontype=GetItm';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url:DspPhaUrl,
			method : "POST"
		});
		// ָ���в���
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "StkCat","NotUseFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "InciRowid",
			fields : fields
		});
		// ���ݼ�
		var DrugInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			remoteSort: false
		});
		// �������ʽ
		DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				search();
			}
		});

		function search(){
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var inciCode = Ext.getCmp("M_InciCode").getValue();
			var alias = Ext.getCmp("M_GeneName").getValue();
			var stkCatId = Ext.getCmp("M_StkCat").getValue();
			var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
			if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
				Msg.info("error", "��ѡ���ѯ����!");
				return false;
			}
			var allFlag=Ext.getCmp("FindTypeCombo").getValue();
			//ҩѧ����id^ҩѧ����id^ҩѧ��С����id^����id
			var others = ""+"^"+""+"^"+""+"^"+StkGrpType;
			// ��ҳ��������
			DrugInfoStore.setBaseParam('InciDesc',inciDesc);
			DrugInfoStore.setBaseParam('InciCode',inciCode);
			DrugInfoStore.setBaseParam('Alias',alias);
			DrugInfoStore.setBaseParam('StkCatId',stkCatId);
			DrugInfoStore.setBaseParam('AllFlag',allFlag);
			DrugInfoStore.setBaseParam('Others',others);
			var pageSize=DrugInfoToolbar.pageSize;
			DrugInfoStore.load({params:{start:0, limit:pageSize},
				callback : function(r,options, success) {					//Store�쳣��������
					if(success==false){
     					Msg.info("error", "��ѯ������鿴��־!");
     				}else{
     					if(r.length>0){
     						DrugInfoGrid.getSelectionModel().selectFirstRow();
     						DrugInfoGrid.getView().focusRow(0);
     					}
     				}
				}
			});
		}
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkCat.setValue("");
				M_StkGrpType.getStore().load();
				M_StkCat.setRawValue("");
				M_GeneName.setValue("");
				Ext.getCmp("FindTypeCombo").setValue("1");
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				ItmBatGrid.getStore().removeAll();
				
			}
		});
		
		var nm = new Ext.grid.RowNumberer();
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
			{
				header : "�����id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 70,
				align : 'center',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BUom',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			},  {
				header : "������",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				renderer : function(v) {
					if (v == "Y")
						return "<div class='ux-lovcombo-icon-checked ux-lovcombo-icon' style='background-position:0 -13px;'>&nbsp;</div>";
					else
						return "<div class='ux-lovcombo-icon-unchecked ux-lovcombo-icon'>&nbsp;</div>"
				},
				sortable : true
			}
		]);
		var DrugInfoToolbar = new Ext.PagingToolbar({
			store:DrugInfoStore,
			pageSize:PageSize,
			id:'DrugInfoToolbar',
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		
		var DrugInfoGrid = new Ext.ux.GridPanel({
			title:'������Ϣ',
			id:'DrugInfoGrid',
			region:'center',
			cm:DrugInfoCm,
			store:DrugInfoStore,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			bbar:DrugInfoToolbar
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			height:170,
			title:'������������',
			region : 'north',	
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����--<font color=red>���顢�����ࡢ���ʱ��롢�������ơ����ʱ�������ȫ��Ϊ��</font>',
				layout: 'column',   
				defaults: {border:false},
				items : [{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [M_InciCode,M_StkGrpType]					
				}, {
					columnWidth: 0.25,
	            	xtype: 'fieldset',
					items : [M_InciDesc,M_StkCat]
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [M_GeneName,FindTypeCombo]					
				}
				]					
			}]			
		});
		
		//==== ��ӱ��ѡȡ���¼�=============
	   DrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			ItmBatStore.setBaseParam('Inci',InciRowid)
			ItmBatStore.load()
		});
		
		var ItmBatStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:'dhcstm.itmbatlockaction.csp?actiontype=GetBatInfo',
		root : 'rows',
		totalProperty : "results",	
		fields :["incib","incibno","incibexp","apcname","phmname","recallflag"],
		pruneModifiedRecords:true
		
	});
var recallflag = new Ext.grid.CheckColumn({
	header:'�Ƿ�����',
	dataIndex:'recallflag',
	sortable:true,
	width:60
});
	var ItmBatCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header : "����RowID",
				dataIndex : 'incib',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "����",
				dataIndex : 'incibno',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'Ч��',
				dataIndex : 'incibexp',
				width : 80,
				align : 'left',
				sortable : true
				
			}, {
				header : "��Ӧ��",
				dataIndex : 'apcname',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'phmname',
				width : 150,
				align : 'left',
				sortable : true
			},recallflag
		]);
	var saveB = new Ext.ux.Button({
	iconCls:'page_save',
	text:'����',
	handler:function(){
		//��ȡ���е��¼�¼
		var mr=ItmBatStore.getModifiedRecords();
		var listData="";
		for(var i=0;i<mr.length;i++){
			var rowId=mr[i].data["incib"];
			var recallflag = mr[i].data["recallflag"];
			var dataRow = rowId+"^"+recallflag;
			if(listData==""){
				listData = dataRow;
			}else{
				listData = listData+xRowDelim()+dataRow;
			}
		}
		if(listData!=""){
			Ext.Ajax.request({
				url: 'dhcstm.itmbatlockaction.csp?actiontype=Save',
				params: {listData:listData},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						ItmBatStore.reload();
					}else{
						Msg.info("error", "����ʧ��!");
					}
				},
				scope: this
			});
		}
	}
});
	var ItmBatGrid = new Ext.ux.EditorGridPanel({
		id : 'ItmBatGrid',
		title : '������Ϣ',
		width:600,
		cm : ItmBatCm,
		tbar:[saveB],
		plugins:recallflag,
		store : ItmBatStore,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		region : 'east',
		clicksToEdit : 1
	});
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
            layout: 'border',
            items: [HisListTab,DrugInfoGrid,ItmBatGrid]
        });
})