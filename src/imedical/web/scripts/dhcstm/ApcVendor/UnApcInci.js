/*��Ӧ�̴���Ȩ�����б� */
function SelectItmToApcInci(Venid,Fn)
{
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
			Ext.getCmp("M_InciDesc2").setValue(InciDesc);
			Ext.getCmp("M_InciCode2").setValue(InciCode);
			
			search();
		}
		
		// ���ʱ���
		var M_InciCode2 = new Ext.form.TextField({
			fieldLabel : '<font color=blue>���ʱ���</font>',
			id : 'M_InciCode2',
			name : 'M_InciCode2',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					search();	
					}
				}
			}
		});
		
		// ��������
		var M_InciDesc2 = new Ext.form.TextField({
			fieldLabel : '<font color=blue>��������</font>',
			id : 'M_InciDesc2',
			name : 'M_InciDesc2',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("M_StkGrpType2").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
	// ���ʱ���
	var M_GeneName2 = new Ext.form.TextField({
		fieldLabel : '<font color=blue>���ʱ���</font>',
		id : 'M_GeneName2',
		name : 'M_GeneName2',
		anchor : '90%',
		valueNotFoundText : '',
		listeners : {
			specialkey : function(field, e) {
			if(e.getKey() == e.ENTER){
					search();
				}			}
		}
	});
	
	// ��������
	var M_StkGrpType2=new Ext.ux.StkGrpComboBox({ 
		fieldLabel:'<font color=blue>����</font>',
		id : 'M_StkGrpType2',
		name : 'M_StkGrpType2',
		StkType:App_StkTypeCode,     //��ʶ��������
		UserId:gUserId,
		LocId:gLocId,
		DrugInfo:"Y",
		anchor : '90%',
		listeners:{
			'select':function(){
				Ext.getCmp("M_StkCat2").setValue('');
			}
		}
	}); 
	
	
	// ������
	var M_StkCat2 = new Ext.ux.ComboBox({
		fieldLabel : '<font color=blue>������</font>',
		id : 'M_StkCat2',
		name : 'M_StkCat2',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'M_StkGrpType2'}
	});
		var Vendor2=new Ext.ux.VendorComboBox({
		id : 'Vendor2',
		name : 'Vendor2',
		anchor:'90%'
	});

	// ����·��
	var DspPhaUrl ='dhcstm.druginfomaintainaction.csp?actiontype=GetItm';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url:DspPhaUrl,
		method : "POST"
	});
	// ָ���в���
	var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp",  "BillUom",  "StkCat","NotUseFlag"];
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
	DrugInfoStore.setDefaultSort('InciCode', 'ASC');
	var chkSm=new Ext.grid.CheckboxSelectionModel({});	
		
	var nm = new Ext.grid.RowNumberer();
	var DrugInfoCm = new Ext.grid.ColumnModel([nm,chkSm, 
		{
			header : "�����id",
			dataIndex : 'InciRowid',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true,
			hideable : false
		}, {
			header : "���ʴ���",
			dataIndex : 'InciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
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
			header : "����",
			dataIndex : 'Manf',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '��ⵥλ',
			dataIndex : 'PurUom',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : "�ۼ�(��ⵥλ)",
			dataIndex : 'Sp',
			width : 100,
			align : 'right',
			sortable : true
		},  {
			header : "�Ƽ۵�λ",
			dataIndex : 'BillUom',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "������",
			dataIndex : 'StkCat',
			width : 150,
			align : 'left',
			sortable : true
		}, {
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
	DrugInfoCm.defaultSortable = true;
	
	var DrugInfoToolbar = new Ext.PagingToolbar({
		store:DrugInfoStore,
		pageSize:PageSize,
		id:'DrugInfoToolbar',
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	
	var DrugInfoGrid = new Ext.grid.GridPanel({
		id:'DrugInfoGrid',
		region:'center',
		autoScroll:true,
		cm:DrugInfoCm,
		store:DrugInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		sm:chkSm,
		loadMask : true,
		bbar:DrugInfoToolbar
	});		
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
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			 M_InciCode2.setValue("");
			 M_InciDesc2.setValue("");
			M_StkGrpType2.setValue("");
			M_StkCat2.setValue("");
			M_StkGrpType2.getStore().load();
			M_StkCat2.setRawValue("");
			M_GeneName2.setValue("");
			Vendor2.setValue("")
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
		}
	});
	
	/*ȷ������*/
	var OkAddBtn = new Ext.Toolbar.Button({
		text:'ȷ��',
		height: 30,
		width : 70,
		iconCls : 'page_save',
		handler:function()
		{
			var sm=Ext.getCmp('DrugInfoGrid').getSelectionModel();
			var arr=sm.getSelections();
			if (arr.length<1)
			{
				Msg.info('error','��ѡ����Ҫ��ӵ����ʼ�¼!');
				return;
			}
			var InciStr="";
			for (var i=0;i<arr.length;i++)
			{
				var r=arr[i];
				var inci=r.get('InciRowid');
				if (InciStr=="")	{InciStr=inci;}
				else { InciStr=InciStr+"^"+inci;}
			}
			if (InciStr==""){
				Msg.info('error','��ѡ����Ҫ��ӵ����ʼ�¼!');
				return;
			}
			Ext.Ajax.request({
				url: 'dhcstm.venincitmaction.csp?actiontype=Save',
				params: {InciStr:InciStr, Venid:Venid},
				failure: function(result, request) {
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "��Ȩ�ɹ�!");
						Fn();
					}else{
						var retinfo=jsonData.info;
						Msg.info("error", "��Ȩʧ��!"+retinfo);
					}
				},
				scope: this
			});
			Ext.getCmp('UnInciToApc').close();
			Fn();
		}
	});
	
	var CloseAdd = new Ext.Toolbar.Button({
		text:'ȡ��',
		height: 30,
		width : 70,
		iconCls : 'page_delete',
		handler:function()
		{
			Ext.getCmp('UnInciToApc').close();
		}
	});
	
	function search(){
		DrugInfoGrid.getStore().removeAll();
		DrugInfoGrid.getView().refresh();
		var inciDesc = Ext.getCmp("M_InciDesc2").getValue();
		var inciCode = Ext.getCmp("M_InciCode2").getValue();
		var alias = Ext.getCmp("M_GeneName2").getValue();
		var stkCatId = Ext.getCmp("M_StkCat2").getValue();
		var StkGrpType = Ext.getCmp("M_StkGrpType2").getValue();
		var Vendor= Ext.getCmp("Vendor2").getValue();
		if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
			Msg.info("error", "��ѡ���ѯ����!");
			return false;
		}
		var allFlag=2 ;
		var others = "^^^"+StkGrpType;
		
		// ��ҳ��������
		var highPrice="";
		var charge="";
		
		DrugInfoStore.setBaseParam('InciDesc',inciDesc);
		DrugInfoStore.setBaseParam('InciCode',inciCode);
		DrugInfoStore.setBaseParam('Alias',alias);
		DrugInfoStore.setBaseParam('StkCatId',stkCatId);
		DrugInfoStore.setBaseParam('AllFlag',allFlag);
		DrugInfoStore.setBaseParam('HighPrice',highPrice);
		DrugInfoStore.setBaseParam('Charge',charge);
		DrugInfoStore.setBaseParam('Others',others);
		DrugInfoStore.setBaseParam('Vendor',Vendor);
		var pageSize=DrugInfoToolbar.pageSize;
		DrugInfoStore.load({params:{start:0, limit:pageSize}});
	}

	var HisListTab = new Ext.form.FormPanel({
		height:150,
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoScroll : false,
		region : 'north',	
		bodyStyle:'padding:5px',
		tbar : [SearchBT, '-', ClearBT,'-',OkAddBtn,'-',CloseAdd],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			style:'padding:0px 0px 0px 5px',
			defaults: {border:false},
			items : [
				{layout:'form',columnWidth:.3,items:[M_InciCode2,M_StkGrpType2]},
				{layout:'form',columnWidth:.3,items:[M_InciDesc2,M_StkCat2]},
				{layout:'form',columnWidth:.3,items:[Vendor2,M_GeneName2]}
				]					
		}]			
	});		
	var UnInciToApc=new Ext.Window({
		title:'ѡ����Ŀ',
		id:'UnInciToApc',
		modal:true,
		width:800,
		height:600,
		layout:'border',
		items:[HisListTab,DrugInfoGrid]

	});
	UnInciToApc.show();
}
