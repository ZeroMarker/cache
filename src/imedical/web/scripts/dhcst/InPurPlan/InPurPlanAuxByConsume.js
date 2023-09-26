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
				fieldLabel : '���Ŀ���',
				id : 'ConsumeLoc',
				name : 'ConsumeLoc',
				anchor : '90%',
				emptyText : '���Ŀ���...',
				defaultLoc:""
			});

	// ��������
	var PurLoc = new Ext.ux.LocComboBox({
		fieldLabel : '�ɹ�����',
		id : 'PurLoc',
		name : 'PurLoc',
		anchor : '90%',
		emptyText : '�ɹ�����...',
		groupId:session['LOGON.GROUPID'],
		listeners : {
			'select' : function(e) {
				var SelLocId=Ext.getCmp('PurLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
				StkGrpType.getStore().removeAll();
				StkGrpType.getStore().setBaseParam("locId",SelLocId)
				StkGrpType.getStore().setBaseParam("userId",userId)
				StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
				StkGrpType.getStore().load();
			}
		}
	});
			
	// ��ʼ����
	var StartDate = new Ext.ux.EditDate({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.EditDate({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				value : DefaultEdDate()
			});
			
	var UseDays =new Ext.form.NumberField({
			fieldLabel : '��ҩ����',
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%'
	});
	
	var HospitalFlag = new Ext.form.Checkbox({
		boxLabel : '����ȫԺ����',
		id : 'HospitalFlag',
		name : 'HospitalFlag',
		anchor : '90%',
		//width : 120,
		checked : false,
		handler:function(){
				Ext.getCmp("TFlag").setValue(false);
				Ext.getCmp("KFlag").setValue(false);
		}
	});
	var AllLocQtyFlag = new Ext.form.Checkbox({
		boxLabel : '����ȫԺ���',
		id : 'AllLocQtyFlag',
		name : 'AllLocQtyFlag',
		anchor : '90%',
		//width : 120,
		checked : false
	});
	var IncludeZeroFlag = new Ext.form.Checkbox({
		boxLabel : '�����ƻ�����Ϊ0',
		id : 'IncludeZeroFlag',
		name : 'IncludeZeroFlag',
		anchor : '90%',
		//width : 120,
		checked : false
	});
		   // �б�
		var ZBFlag = new Ext.form.Radio({
			boxLabel : '�б�',
			id : 'ZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // ���б�
		var NotZBFlag = new Ext.form.Radio({
			boxLabel : '���б�',
			id : 'NotZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // ȫ��
		var AllFlag = new Ext.form.Radio({
			boxLabel : 'ȫ��',
			id : 'AllFlag',
			name : 'ZBType',
			anchor : '80%',
			checked : true
				});
	//�ı����ȫԺ���ĵ�ֵ
	HospitalFlag.on('check', function(checkbox,value) {
		if(value==true){
			Ext.getCmp("TFlag").setDisabled(true);
			Ext.getCmp("KFlag").setDisabled(true);
		}else{
			Ext.getCmp("TFlag").setDisabled(false);
			Ext.getCmp("KFlag").setDisabled(false);
		}
		
	
	});
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:session['LOGON.CTLOCID'],
		UserId:userId,
		anchor : '90%'
	}); 
	// ������
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{StkGrpId:'StkGrpType'}
});
	var PFlag = new Ext.form.Checkbox({
		boxLabel : 'סԺ��ҩ',
		id : 'PFlag',
		name : 'PFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var YFlag = new Ext.form.Checkbox({
		boxLabel : 'סԺ��ҩ',
		id : 'YFlag',
		name : 'YFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var FFlag = new Ext.form.Checkbox({
		boxLabel : '���﷢ҩ',
		id : 'FFlag',
		name : 'FFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var HFlag = new Ext.form.Checkbox({
		boxLabel : '������ҩ',
		id : 'HFlag',
		name : 'HFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var TFlag = new Ext.form.Checkbox({
		boxLabel : 'ת��',
		id : 'TFlag',
		name : 'TFlag',
		anchor : '90%',
		//width : 80,
		checked : false
	});
	var KFlag = new Ext.form.Checkbox({
		boxLabel : 'ת��',
		id : 'KFlag',
		name : 'KFlag',
		anchor : '90%',
		//width : 80,
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
					Query();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		var PurLoc = Ext.getCmp("PurLoc").getValue();
		var ConsumeLoc = Ext.getCmp("ConsumeLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var UseDays = Ext.getCmp("UseDays").getValue();
		var ZBFlag=Ext.getCmp("ZBFlag").getValue();
		var NotZBFlag=Ext.getCmp("NotZBFlag").getValue();
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		var AllLocQtyFlag=(Ext.getCmp('AllLocQtyFlag').getValue()==true?'Y':'N');
		var IncludeZeroFlag=(Ext.getCmp('IncludeZeroFlag').getValue()==true?'Y':'N');
		 //������
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
		if (AllFlag==true){
			var zbflagstr=1;
			}
		else if(ZBFlag==true){
			var zbflagstr=2;
			}
		else{
			var zbflagstr=3;
			}
			
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
		if (UseDays == undefined || UseDays.length <= 0) {
			Msg.info("warning", "����д��ҩ����!");
			return;
		}
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var HospFlag=Ext.getCmp("HospitalFlag").getValue();
		var TransType='';
		var PFlag=(Ext.getCmp("PFlag").getValue()==true?'P':'');
		var YFlag=(Ext.getCmp("YFlag").getValue()==true?'Y':'');
		var FFlag=(Ext.getCmp("FFlag").getValue()==true?'F':'');
		var HFlag=(Ext.getCmp("HFlag").getValue()==true?'H':'');
		var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');
		var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');
		if(PFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+PFlag;
			}else{
				TransType=PFlag;
			}
		}
		if(YFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+YFlag;
			}else{
				TransType=YFlag;
			}
		}
		if(FFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+FFlag;
			}else{
				TransType=FFlag;
			}
		}
		if(HFlag!=''){
			if(TransType!=''){
				TransType=TransType+','+HFlag;
			}else{
				TransType=HFlag;
			}
		}
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
		if (TransType == null || TransType.length <= 0) {
			Msg.info("warning", "��ѡ��ҵ������!");
			return;
		}
		if(HospFlag==true){
			//��ʼ����,��ֹ����,��ҩ����,����id,ҵ�����ʹ�,�ɹ�����id
			var ListParam=startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType+'^'+PurLoc+'^'+userId+"^"+zbflagstr+"^"+stkCatId+"^"+AllLocQtyFlag+"^"+IncludeZeroFlag;	
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryAllItmForPurch';
	
		}else{
			if (ConsumeLoc == undefined || ConsumeLoc.length <= 0) {
				Msg.info("warning", "��ѡ�����Ĳ���!");
				return;
			}
			//���Ŀ���id,��ʼ����,��ֹ����,��ҩ����,����id,ҵ�����ʹ�,�ɹ�����id
			var ListParam=ConsumeLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+TransType+'^'+PurLoc+'^'+userId+"^"+zbflagstr+"^"+stkCatId+"^"+AllLocQtyFlag+"^"+IncludeZeroFlag;					
			var url= DictUrl
				+ 'inpurplanaction.csp?actiontype=QueryLocItmForPurch';
		}
		DetailStore.proxy = new Ext.data.HttpProxy({
			url : encodeURI(url),
			method : "POST"
		});
		DetailStore.load({params:{start:0, limit:999,strParam:ListParam},
			callback : function(o,response,success) { 
				if (success == false){  
					Ext.MessageBox.alert("��ѯ����",DetailStore.reader.jsonData.Error);
					DetailGrid.loadMask.hide();  
				}
			}
		});
	}
	
function save(){
	var purNo = '';
	var locId = Ext.getCmp('PurLoc').getValue();
	var stkGrpId = Ext.getCmp('StkGrpType').getValue();
	var rowCount = DetailGrid.getStore().getCount();				
	var data="";
	for(var i=0;i<rowCount;i++){
		var rowData = DetailStore.getAt(i);	
		var rowid = '';
		var incId = rowData.data["Inci"];
		var qty = rowData.data["PurQty"];
		var uomId = rowData.data["PurUomId"];
		var vendorId = rowData.data["VenId"];
		var rp =rowData.data["Rp"];
		var manfId =rowData.data["ManfId"];
		var carrierId =rowData.data["CarrierId"];
		var reqLocId =rowData.data["ReqLocId"]||"";	// �깺����
		var prolocqty=rowData.data["ProLocQty"];;  //����ɹ���
		var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId+"^"+prolocqty;
		if(data==""){
			data = dataRow;
		}else{
			data = data+xRowDelim()+dataRow;
		}
	}
		var ZBFlag=Ext.getCmp("ZBFlag").getValue();
		var NotZBFlag=Ext.getCmp("NotZBFlag").getValue();
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		if (AllFlag==true){
			var zbflagstr=1;
			}
		else if(ZBFlag==true){
			var zbflagstr=2;
			}
		else{
			var zbflagstr=3;
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
					location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId+'&zbFlag='+zbflagstr;
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
						Msg.info("error","����ƻ�����ϸʧ��,�������ɼƻ���!���ҩƷ���������Ƿ��в�����ҩƷ");
					}else if(jsonData.info==-7){
						Msg.info("error","ʧ��ҩƷ��������ϸ���治�ɹ�����ʾ���ɹ���ҩƷ!"+jsonData.info);
					}else{
						Msg.info("error","����ʧ��!"+jsonData.info);
					}
				}
			},
			scope: this
		});
	}
		}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
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
		Ext.getCmp("PurLoc").setValue(session['LOGON.CTLOCID']);
		Ext.getCmp("ConsumeLoc").setValue("");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("UseDays").setValue("");
		Ext.getCmp("StkGrpType").setValue("");
		Ext.getCmp("StkGrpType").setRawValue("");
		Ext.getCmp("PFlag").setValue(false);
		Ext.getCmp("YFlag").setValue(false);
		Ext.getCmp("FFlag").setValue(false);
		Ext.getCmp("HFlag").setValue(false);
		Ext.getCmp("TFlag").setValue(false);
		Ext.getCmp("KFlag").setValue(false);
		Ext.getCmp("HospitalFlag").setValue(false);
		Ext.getCmp("AllLocQtyFlag").setValue(false);
		Ext.getCmp("IncludeZeroFlag").setValue(false);
		Ext.getCmp("M_StkCat").setValue("");
		Ext.getCmp("M_StkCat").setRawValue("");
		Ext.getCmp("NotZBFlag").setValue(false);
		Ext.getCmp("ZBFlag").setValue(false);
		Ext.getCmp("AllFlag").setValue(true);
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	// ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '���ΪExcel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(DetailGrid);
					//gridSaveAsExcel(DetailGrid); //��ҳҳ������
				}
			});
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
				store : ItmUomStore,
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
					var InciDr = record.get("Inci");
					ItmUomStore.removeAll();
					/*
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ InciDr;
					CTUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							}); */
					ItmUomStore.load({params:{ItmRowid:InciDr}});
				});

	/**
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);

				var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
				var BUom = record.get("BUomId");
				var ConFac = record.get("ConFac");   //��λ��С��λ��ת����ϵ					
				var TrUom = record.get("PurUomId");    //Ŀǰ��ʾ�ĳ��ⵥλ
				var Rp = record.get("Rp");
				var StkQty = record.get("StkQty");
				//var DirtyQty=record.get("ResQty");
				//var AvaQty=record.get("AvaQty");
				var PurQty=record.get("PurQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("Rp", Rp/ConFac);
					record.set("StkQty", StkQty*ConFac);
					//record.set("ResQty", DirtyQty*ConFac);
					//record.set("AvaQty", AvaQty*ConFac);
					record.set("PurQty", PurQty*ConFac);
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("Rp", Rp*ConFac);
					record.set("StkQty", StkQty/ConFac);
					//record.set("ResQty", DirtyQty/ConFac);
					//record.set("AvaQty", AvaQty/ConFac);
					record.set("PurQty", PurQty/ConFac);
				}
				record.set("PurUomId", combo.getValue());
	});
	
	
	
			/**
	 * ɾ��ѡ����ҩƷ
	 */
	function deleteDetail() {
		var selectlist=DetailGrid.getSelectionModel().getSelections();
		if ((selectlist == null)||(selectlist=="")) {
			Msg.info("warning", "��ѡ����Ҫɾ���ļ�¼!");
			return;
		}
		var selectlength=selectlist.length
		for (var selecti=0;selecti<selectlength;selecti++){
			var selectrecord=selectlist[selecti];
			DetailGrid.getStore().remove(selectrecord);
		}	
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
			 "BUomId","ConFac","ApcWarn","StkCatDesc","ProLocQty","HospStkQty","PackQty","PackUomDesc",
			 "PackPurFac","LastExpDate","ReqLocId"];
			
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
	/**
	 * ��ʾ��ϸǰ��װ�ر�Ҫ��combox
	 */
	DetailStore.on('beforeload',function(store,options){
		//װ�����е�λ
		var url = DictUrl
						+ 'drugutil.csp?actiontype=CTUom&CTUomDesc=&start=0&limit=9999';
		CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
		CTUomStore.load();
	});
	var sm = new Ext.grid.CheckboxSelectionModel();
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,sm, {
				header : "ҩƷId",
				dataIndex : 'Inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'StkCatDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'InciDesc',
				width : 220,
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
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUomDesc"),								
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "��Ӧ��",
				dataIndex : 'VenDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'ManfDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ɹ����ҿ��",
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
			},{
				header : "����ɹ���",
				dataIndex : 'ProLocQty',
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
				width : 140,
				align : 'right',
				sortable : true
			},{
				header : "ȫԺ���",
				dataIndex : 'HospStkQty',
				width : 90,
				align : 'right',
				sortable : true
			},{
				header : "���װ����",
				dataIndex : 'PackQty',
				width : 90,
				align : 'right',
				sortable : true,
				hidden:true
			},{
				header : "���װϵ��",
				dataIndex : 'PackPurFac',
				width : 90,
				align : 'right',
				sortable : true,
				hidden:true
			},{
				header : "���װ��λ",
				dataIndex : 'PackUomDesc',
				width : 90,
				align : 'right',
				sortable : true
			},{
				header : "������Ч��",
				dataIndex : 'LastExpDate',
				width : 90,
				align : 'right',
				sortable : true
			},{
				header : "�깺����Id",
				dataIndex : 'ReqLocId',
				width : 90,
				align : 'right',
				sortable : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm :sm, // new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
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
		rightClick.showAt(e.getXY()); 
	}


	
	var col1={ 				
			columnWidth: 0.3,
        	xtype: 'fieldset',
        	labelWidth: 60,	
        	defaults: {width: 180, border:false},    // Default config options for child items
        	defaultType: 'textfield',
        	autoHeight: true,
        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
        	border: false,
        	//style: {
            //	"margin-left": "10px", // when you add custom margin in IE 6...
           	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
           	//	"margin-bottom": "10px"
        	//},
        	items: [PurLoc,ConsumeLoc,StkGrpType]
			
		}
	var col2={ 				
			columnWidth: 0.15,
        	xtype: 'fieldset',
        	labelWidth: 60,	
        	defaults: {width: 180, border:false},    // Default config options for child items
        	defaultType: 'textfield',
        	autoHeight: true,
        	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
        	border: false,
        	//style: {
            //	"margin-left": "10px", // when you add custom margin in IE 6...
            //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
        	//},
        	items: [StartDate,EndDate,UseDays]
			
		}
	var col3={ 				
			width: 360,
			title:'ҵ������',
			xtype: 'fieldset',
				frame : true,
				autoScroll : true,
				bodyStyle : 'padding-top:0px;',
				layout: 'column',  
				items:[{ 				
						columnWidth: 0.5,
		            	xtype: 'fieldset',
		            	//labelWidth: 50,	
		            	//defaults: {width: 80, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	border: false,	          
		            	items: [PFlag,YFlag,FFlag]
						
					},{ 				
						columnWidth: 0.5,
		            	xtype: 'fieldset',
		            	//labelWidth: 30,	
		            	//defaults: {width: 80, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	items: [TFlag,KFlag,HFlag]
						
					}]			
						
		}
		
	var col4={ 				
			columnWidth: 0.3,
        	xtype: 'fieldset',
        	labelWidth: 90,	
        	defaults: {width: 210, border:false},    // Default config options for child items
        	defaultType: 'textfield',
        	autoHeight: true,
        	border: false,
        	items: [M_StkCat,
        		 {xtype : 'compositefield',
        		 style: {"margin-left": "-55px","margin-top": "-5px"},
        		 items:[HospitalFlag,AllLocQtyFlag]},
        		 {xtype : 'compositefield',
        		 style: {"margin-left": "-55px","margin-top": "-5px"},
        		 items:[IncludeZeroFlag]}
        		
        		]			
		}
		var col5={ 				
			columnWidth: 0.2,
        	xtype: 'fieldset',
        	labelWidth: 80,	
        	defaults: {width: 100, border:false},    
        	defaultType: 'textfield',
        	autoHeight: true,
        	border: false,
        	items: [AllFlag,NotZBFlag,ZBFlag]
			
		}
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT,'-',SaveAsBT],		
		items : [{
			xtype:'fieldset',
			layout: 'table',    // Specifies that the items will now be arranged in columns
			layoutConfig: {columns:5},
			title:'��ѯ����',
			style : 'padding-top:0px;padding-bottom:0px;',
			items:[col1,col2,col4,col5,col3]
		}]
		
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'�ɹ��ƻ��Ƶ�-��������',
		                height: 220, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '��ϸ',			               
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			]
			});
DetailGrid.on('mouseover',function(e){
	var rowCount = DetailGrid.getStore().getCount();
	if (rowCount>0)
	{  
		var ShowInCellIndex=GetColIndex(DetailGrid,"InciCode")  //�ڵڼ�����ʾ
		var index = DetailGrid.getView().findRowIndex(e.getTarget());
		var record = DetailGrid.getStore().getAt(index);
		if (record)
		{
			var desc=record.data.InciDesc;
			var inci=record.data.Inci;
		}
		ShowAllLocStkQtyWin(e,DetailGrid,ShowInCellIndex,desc,inci);
	}

},this,{buffer:200});

})
