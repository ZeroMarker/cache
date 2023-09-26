/*����ѡ����Ŀ���뵽ĳ������ */
function SelectItmToAdd(Fn)
{
		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				//GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
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
			if(e.getKey() == e.ENTER){
					search();
				}			}
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
	var chkSm=new Ext.grid.CheckboxSelectionModel({
			// singleSelect:true
		});	
		
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
		//height:420,
		//width : 495,
		autoScroll:true,
		cm:DrugInfoCm,
		store:DrugInfoStore,
		trackMouseOver : true,
		stripeRows : true,
		// sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		sm:chkSm,
		loadMask : true,
		//plugins: [ColumnNotUseFlag],
		// tbar:{items:[{text:'������',handler:function(){	GridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAINM");}}]},
		bbar:DrugInfoToolbar
		/*view: new Ext.ux.grid.BufferView({
			rowHeight: 30,
			// forceFit: true,
			scrollDelay: false
		})*/
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
			M_StkGrpType.setValue("");
			M_StkCat.setValue("");
			M_StkGrpType.getStore().load();
			M_StkCat.setRawValue("");
			M_GeneName.setValue("");
			Vendor2.setValue("")
			// //M_AllFlag.setValue(false);
			// Ext.getCmp("FindTypeCombo").setValue("1");
			// M_HighPrice.setValue(false);
			// M_NoHighPrice.setValue(false);
			// M_ChargeFlag.setValue(false);
			DrugInfoGrid.getStore().removeAll();
			DrugInfoGrid.getView().refresh();
			// drugRowid="";
			// clearData();
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
				Msg.info('error','��ѡ����Ŀ!');
				return;
			}
			var inciS="";
			for (var i=0;i<arr.length;i++)
			{
				var r=arr[i];
				var inci=r.get('InciRowid');
				if (inciS=="")	{inciS=inci;}
				else { inciS=inciS+"^"+inci;}
			}
			if (inciS==""){
				Msg.info('error','��ѡ����Ŀ!');
				return;
			}
			Fn(inciS);
		}
	});
	
	var CloseAdd = new Ext.Toolbar.Button({
		text:'ȡ��',
		height: 30,
		width : 70,
		iconCls : 'page_delete',
		handler:function()
		{
			Ext.getCmp('addItemToSa').close();
		}
	});
	
	function search(){
		DrugInfoGrid.getStore().removeAll();
		DrugInfoGrid.getView().refresh();
		// clearData();
		 var inciDesc = Ext.getCmp("M_InciDesc2").getValue();
		 var inciCode = Ext.getCmp("M_InciCode2").getValue();
		var alias = Ext.getCmp("M_GeneName").getValue();
		var stkCatId = Ext.getCmp("M_StkCat").getValue();
		var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
		var Vendor= Ext.getCmp("Vendor2").getValue();
		// if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
			// Msg.info("error", "��ѡ���ѯ����!");
			// return false;
		// }
		var allFlag='Y' ;
		//var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
		// var allFlag=Ext.getCmp("FindTypeCombo").getValue();
		// var highPrice=""
		// if(highPrice==""){
			// highPrice= (Ext.getCmp("M_HighPrice").getValue()==true?'Y':'');
		// }
		// if(highPrice==""){
			// highPrice= (Ext.getCmp("M_NoHighPrice").getValue()==true?'N':'');
		// }
		// var charge = (Ext.getCmp("M_ChargeFlag").getValue()==true?'Y':'N');
		
		//����id
		var others = ""+"^"+""+"^"+""+"^"+StkGrpType;
		//var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetItm'+ '&InciDesc=' + inciDesc + '&InciCode=' + inciCode+ '&Alias=' + alias + '&StkCatId=' + stkCatId + '&AllFlag='+ allFlag + '&Others=' + others;
		/*
		DrugInfoStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST"
		});
		*/
		/*Store�쳣������һ
		DrugInfoStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST",
			listeners : {
				'loadexception' : function(e) {
					Msg.info("warning", "���ݷ����쳣!");
				}
			}
		});
		*/
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
		DrugInfoStore.load({params:{start:0, limit:pageSize},
			callback : function(r,options, success) {					//Store�쳣��������
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
					//DrugInfoGrid.loadMask.hide();

					//return "{results:0,rows:[]}";
				}else{
					//ֻ��һ����¼�Ļ�ѡ�д˼�¼
					if(r.length>=1){
						DrugInfoGrid.getSelectionModel().selectFirstRow();
						DrugInfoGrid.getView().focusRow(0);
					}
				}
			}
		});
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
				{layout:'form',columnWidth:.3,items:[M_InciCode2,M_StkGrpType]},
				{layout:'form',columnWidth:.3,items:[M_InciDesc2,M_StkCat]},
				{layout:'form',columnWidth:.3,items:[Vendor2,M_GeneName]}
				]					
		}]			
	});		
	var winx=new Ext.Window({
		title:'ѡ����Ŀ',
		id:'addItemToSa',
		modal:true,
		width:800,
		height:600,
		layout:'border',
		items:[HisListTab,DrugInfoGrid]
		// ,
		// tbar:[SearchBT]

	});
	winx.show();
}
