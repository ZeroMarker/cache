// /����: �ɹ��ƻ������Ƶ����������ģ�
// /����: �ɹ��ƻ������Ƶ����������ģ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.01

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParam();
	}
	
	var ConsumeLoc = new Ext.ux.LocComboBox({
				fieldLabel : '<font color=blue>���Ŀ���</font>',
				id : 'ConsumeLoc',
				name : 'ConsumeLoc',
				anchor : '90%',
				emptyText : '���Ŀ���...',
				defaultLoc:""
			});
	SetLogInDept(ConsumeLoc.getStore(), 'ConsumeLoc');
	
	// ��������
	var PurLoc = new Ext.ux.LocComboBox({
				fieldLabel : '�ɹ�����',
				id : 'PurLoc',
				name : 'PurLoc',
				anchor : '90%',
				emptyText : '�ɹ�����...',
				groupId:session['LOGON.GROUPID'],
				stkGrpId : 'groupField'
			});
			
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				value : DefaultEdDate()
			});
			
	var UseDays =new Ext.form.NumberField({
			fieldLabel : '�ο�����',
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%',
			value : 30
	});

	var NotUseDaysFlag = new Ext.form.Checkbox({
		boxLabel : '��ʹ�òο�����',
		id : 'NotUseDaysFlag',
		anchor : '90%',
		checked : false
	});
	
	var HospitalFlag = new Ext.form.Checkbox({
		boxLabel : '����ȫԺ����',
		id : 'HospitalFlag',
		name : 'HospitalFlag',
		anchor : '90%',
		checked : false,
		listeners : {
			check : function(checkbox,value) {
				if(value == true){
					Ext.getCmp("TFlag").setValue(false);
					Ext.getCmp("KFlag").setValue(false);
					Ext.getCmp("TFlag").setDisabled(true);
					Ext.getCmp("KFlag").setDisabled(true);
				}else{
					Ext.getCmp("TFlag").setDisabled(false);
					Ext.getCmp("KFlag").setDisabled(false);
				}
			}
		}
	});
	
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:session['LOGON.CTLOCID'],
		UserId:userId,
		anchor : '90%'
	}); 

	var TFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : 'ת��',
		id : 'TFlag',
		anchor : '90%',
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : 'ת��',
		id : 'KFlag',
		anchor : '90%',
		checked : false
	});
	
	var PYFHFlag = new Ext.form.Checkbox({
		hideLabel : true,
		boxLabel : 'ҽ������',
		id : 'PYFHFlag',
		anchor : '90%',
		checked : false
	});
	
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					///Query();
					DetailGrid.load();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var UseDays = Ext.getCmp("UseDays").getValue();
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}
		
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "��ѡ��ʼ����!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "��ѡ���ֹ����!");
			return;
		}
		var NotUseDaysFlag = Ext.getCmp('NotUseDaysFlag').getValue()?1:0;		//��ʹ�òο������ı�־
		if (UseDays == undefined || UseDays.length <= 0 && NotUseDaysFlag==0) {
			Msg.info("warning", "����д�ο�����!");
			return;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var HospFlag=Ext.getCmp("HospitalFlag").getValue();
		var TransType='';
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		var PYFHFlag = Ext.getCmp('PYFHFlag').getValue()? 'P,Y,F,H' : '';
		if(TFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+TFlag;
			}else{
				TransType=TFlag;
			}
		}
		if(KFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+KFlag;
			}else{
				TransType=KFlag;
			}
		}
		if(PYFHFlag!=''){
			if(TransType!=''){
				TransType = TransType+','+PYFHFlag;
			}else{
				TransType = PYFHFlag;
			}
		}
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "��ѡ��ҵ������!");
			return;
		}
		
		if(HospFlag==true){
			//��ʼ����,��ֹ����,��ҩ����,����id,ҵ�����ʹ�,�ɹ�����id,UserId,��ʹ�òο�������־
			var ListParam=startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType
					+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;	
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryAllItmForPurch';
		}else{
			if (ConsumeLoc == undefined || ConsumeLoc.length <= 0) {
				Msg.info("warning", "��ѡ�����Ĳ���!");
				return;
			}
			//���Ŀ���id,��ʼ����,��ֹ����,��ҩ����,����id,ҵ�����ʹ�,�ɹ�����id,UserId,��ʹ�òο�������־
			var ListParam=ConsumeLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp
					+'^'+TransType+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;				
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurch';
		}
		
		DetailStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST"
		});
		DetailStore.removeAll();
		DetailStore.load({params:{start:0, limit:999,strParam:ListParam}});
	}
	
function save(){
	var purNo = '';
	var locId = Ext.getCmp('PurLoc').getValue();
	var stkGrpId = Ext.getCmp('StkGrpType').getValue();
	var rowCount = DetailGrid.getStore().getCount();
	var data="";
	for(var i=0;i<rowCount;i++){
		var rowData = DetailGrid.getStore().getAt(i);	
		var rowid = '';
		var incId = rowData.data["Inci"];
		var qty = rowData.data["PurQty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId ='';
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId;
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
	}
	
	if(data!=""){
		Ext.Ajax.request({
			url: DictUrl+'inpurplanaction.csp?actiontype=save',
			params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data},
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					location.href="dhcstm.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
				}else{
					if(jsonData.info==-1){
						Msg.info("error","���һ���ԱΪ��!");
					}else if(jsonData.info==-99){
						Msg.info("error","����ʧ��!");
					}else if(jsonData.info==-2){
						Msg.info("error","���ɼƻ�����ʧ��!");
					}else if(jsonData.info==-3){
						Msg.info("error","����ƻ���ʧ��!");
					}else if(jsonData.info==-4){
						Msg.info("error","δ�ҵ�����µļƻ���!");
					}else if(jsonData.info==-5){
						Msg.info("error","����ƻ�����ϸʧ��,�������ɼƻ���!");
					}else if(jsonData.info==-7){
						Msg.info("error","ʧ�����ʣ�������ϸ���治�ɹ�����ʾ���ɹ�������!");
					}else{
						Msg.info("error","����ʧ��!");
					}
				}
			},
			scope: this
		});
	}
}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(PurLoc.getStore(),'PurLoc');
		SetLogInDept(ConsumeLoc.getStore(), 'ConsumeLoc');
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("UseDays").setValue(30);
		Ext.getCmp("StkGrpType").getStore().reload();
		Ext.getCmp("TFlag").setValue(false);
		Ext.getCmp("KFlag").setValue(false);
		Ext.getCmp('PYFHFlag').setValue(false);
		Ext.getCmp("HospitalFlag").setValue(false);
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});
			// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '��λ...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});
	/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("inci");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
				CTUom.store.load();
			});

	/**
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);

				var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
				var BUom = record.get("BUomId");
				var ConFac = record.get("Fac");   //��λ��С��λ��ת����ϵ					
				var TrUom = record.get("pUom");    //Ŀǰ��ʾ�ĳ��ⵥλ
				var Sp = record.get("sp");
				var StkQty = record.get("stkQty");
				var DirtyQty=record.get("ResQty");
				var AvaQty=record.get("AvaQty");
				var PurQty=record.get("purQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("sp", accDiv(Sp,ConFac));
					record.set("stkQty", accMul(StkQty,ConFac));
					record.set("ResQty", accMul(DirtyQty,ConFac));
					record.set("AvaQty", accMul(AvaQty,ConFac));
					record.set("purQty", accMul(PurQty,ConFac));
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("sp", accMul(Sp,ConFac));
					record.set("stkQty", accDiv(StkQty,ConFac));
					record.set("ResQty", accDiv(DirtyQty,ConFac));
					record.set("AvaQty", accDiv(AvaQty,ConFac));
					record.set("purQty", accDiv(PurQty,ConFac));
				}
				record.set("pUom", combo.getValue());
	});
	
	/**
	 * ɾ��ѡ��������
	 */
	function deleteDetail() {
		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		DetailGrid.getStore().remove(record);
		DetailGrid.getView().refresh();
	}
	
	// ת����ϸ
	// ����·��
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurch';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = [ "Inci","InciCode","InciDesc", "PurUomId", "PurUomDesc", "PurQty","VenId",
			 "VenDesc", "ManfId", "ManfDesc","StkQty","Rp","CarrierId", "CarrierDesc", "DispensQty",
			 "BUomId","ConFac","ApcWarn"];
			
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Inci",
				fields : fields
			});
	
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = [{
				header : "����Id",
				dataIndex : 'Inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'InciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "�ɹ�����",
				dataIndex : 'PurQty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "�ɹ���������Ϊ��!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "�ɹ���������С�ڻ����0!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "��λ",
				dataIndex : "PurUomId",
				xtype:'combocolumn',
				valueField: "PurUomId",
				displayField: "PurUomDesc",
				editor:CTUom
			}, {
				header : "��Ӧ��",
				dataIndex : 'VenDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'ManfDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "���ҿ��",
				dataIndex : 'StkQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'DispensQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'CarrierDesc',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header : "������Ϣ",
				dataIndex : 'ApcWarn',
				width : 240,
				align : 'left',
				sortable : true
			},{
				header : "��Ӧ��id",
				dataIndex : 'VenId',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "����id",
				dataIndex : 'ManfId',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "������id",
				dataIndex : 'CarrierId',
				width : 50,
				align : 'left',
				sortable : true
			}];

		function GetMasterParams(){
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var UseDays = Ext.getCmp("UseDays").getValue();
		if (PurLoc == undefined || PurLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return false;
		}
		
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "��ѡ��ʼ����!");
			return false;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "��ѡ���ֹ����!");
			return false;
		}
		var NotUseDaysFlag = Ext.getCmp('NotUseDaysFlag').getValue()?1:0;		//��ʹ�òο������ı�־
		if (UseDays == undefined || UseDays.length <= 0 && NotUseDaysFlag==0) {
			Msg.info("warning", "����д�ο�����!");
			return false;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var HospFlag=Ext.getCmp("HospitalFlag").getValue();
		var TransType='';
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		var PYFHFlag = Ext.getCmp('PYFHFlag').getValue()? 'P,Y,F,H' : '';
		if(TFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+TFlag;
			}else{
				TransType=TFlag;
			}
		}
		if(KFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+KFlag;
			}else{
				TransType=KFlag;
			}
		}
		if(PYFHFlag!=''){
			if(TransType!=''){
				TransType = TransType+','+PYFHFlag;
			}else{
				TransType = PYFHFlag;
			}
		}
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "��ѡ��ҵ������!");
			return false;
		}
		
		if(HospFlag==true){
			//��ʼ����,��ֹ����,��ҩ����,����id,ҵ�����ʹ�,�ɹ�����id,UserId,��ʹ�òο�������־
			var ListParam=startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType
					+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;
		}else{
			if (ConsumeLoc == undefined || ConsumeLoc.length <= 0) {
				Msg.info("warning", "��ѡ�����Ĳ���!");
				return false;
			}
			//���Ŀ���id,��ʼ����,��ֹ����,��ҩ����,����id,ҵ�����ʹ�,�ɹ�����id,UserId,��ʹ�òο�������־
			var ListParam=ConsumeLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp
					+'^'+TransType+'^'+PurLoc+'^'+userId+'^'+NotUseDaysFlag;
		}
		return {"strParam":ListParam};
	}
	var DetailGrid = new Ext.dhcstm.EditorGridPanel({
		height : 200,
		collapsible: true,
		title: '',
		id : 'DetailGrid',
		contentColumns : DetailCm,
		actionUrl : 'dhcstm.inpurplanaction.csp',
		queryAction : "QueryLocItmForPurch",
		selectFirst : false,
		idProperty : "Inci",
		checkProperty : "Inci",
		paramsFn : GetMasterParams,
		paging : false,
		showTBar : false
	});
	/***
	**����Ҽ��˵�
	**/
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({
		id:'rightClickCont',
		items: [
			{
				id: 'mnuDelete',
				handler: deleteDetail,
				text: 'ɾ��'
			}
		]
	}); 
	
	//�Ҽ��˵�����ؼ�����
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		DetailGrid.getSelectionModel().select(rowindex, 0);
		rightClick.showAt(e.getXY());
	}
	
	var col1={
		columnWidth: 0.2,
		xtype: 'fieldset',
		autoHeight: true,
		border: false,
		items: [PurLoc,ConsumeLoc,StkGrpType,HospitalFlag]
	}
	var col2={
		columnWidth: 0.2,
		xtype: 'fieldset',
		autoHeight: true,
		border: false,
		items: [StartDate,EndDate,UseDays,NotUseDaysFlag]
	}
	var col3={
		columnWidth: 0.15,
		title:'ҵ������',
		xtype: 'fieldset',
		bodyStyle : 'padding:0 0 0 15px;',
		layout: 'form',
		items:[TFlag,KFlag,PYFHFlag]
	}
		
//	var col4={
//		columnWidth: 0.15,
//		xtype: 'fieldset',
//		labelWidth: 30,	
//		autoHeight: true,
//		border: false,
//		items: [HospitalFlag, NotUseDaysFlag]
//	}
		
	var col5 = {
		columnWidth : 0.42,
		bodyStyle : 'padding:0 0 0 15px;',
		html:'<font size=2 color=blue>1. ��"���Ŀ���"��Ϊͳ�Ƶ�Ԫ,�����ǿⷿҲ�������ٴ�����.'
			+ ' ����ѡ"ת��"ʱ��ת����������ֵͳ��, ͬʱ��ѡ����ѡ��ʱ(���繴ѡת��)�򰴴�����ͳ��.'
			+ ' ��ѡ"����ȫԺ����"ʱ���ҿ��ָ�ɹ�����, ����ָ���Ŀ���.'
			+ '<br>2. ҽ�����İ���ҽ����������.'
			+ '<br>3. ��ѡ"��ʹ�òο�����"ʱ, �ɹ���=������, ���� �ɹ���=(������ / ʱ����) * �ο����� - ���ҿ��.</font>'
	};
	
	var HisListTab = new Ext.ux.FormPanel({
		title : '�ɹ��ƻ������Ƶ�(��������)',
		labelWidth : 60,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 5px 5px;',
			layout : 'column',
			items:[col1,col2,col3,col5]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, {
				region: 'center',
				title: '��ϸ',
				layout: 'fit',
				items: DetailGrid
			}]
		});
})