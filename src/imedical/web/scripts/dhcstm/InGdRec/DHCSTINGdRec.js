// /����: ��ⵥ�Ƶ�
// /����: ��ⵥ�Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.06.27
var impWindow = null;
var gUserId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gHospId=session['LOGON.HOSPID'];

var loadMask=null;
var colArr=[];
if(gParam.length<1){
	GetParam();  //��ʼ����������
}
var gPhaMulFlag = gParam[18];		//���ʵ����Ƿ��ѡ
var AllowEnterSpec=gParam[22]=='Y'?true:false;

//ȡ��ֵ�������
var UseItmTrack="";
var CreBarByIngdrec="";     //�Ƿ������ʱ�����ɸ�ֵ�������
var PhaOrderHVFlag = '';	//���ʵ����ĸ�ֵ���˱�־(Y:����ֵ,N:����ֵ,'':����)
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	CreBarByIngdrec=gItmTrackParam[3]=='Y'?true:false;
	if(UseItmTrack && !gHVINGdRec && !CreBarByIngdrec){
		PhaOrderHVFlag = 'N';
	}
}

var isBarcodeEdit=true,isIncdescEdit=true;
if(!UseItmTrack){
	if(gHVINGdRec){
		isIncdescEdit=false;
		Msg.info("warning","�˲˵���ʹ��!");
	}else{
		isBarcodeEdit=false;
	}
}else{
	if(gHVINGdRec){	//��ֵ�˵�
		isIncdescEdit=false;
	}else{			//�Ǹ�ֵ�˵�
		isBarcodeEdit=false;
	}
}
	
var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '��ⲿ��',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	emptyText : '��ⲿ��...',
	groupId:gGroupId,
	stkGrpId : "StkGrpType",
	childCombo : 'Vendor'
});

var VirtualFlag = new Ext.form.Checkbox({
	hideLabel:true,
	boxLabel : '���',
	id : 'VirtualFlag',
	name : 'VirtualFlag',
	anchor : '90%',
	checked : false,
	listeners:{
		check:function(chk,bool){
			if(bool){
				var phaloc=Ext.getCmp("PhaLoc").getValue();
				var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
				var response=ExecuteDBSynAccess(url);
				var jsonData=Ext.util.JSON.decode(response);
				if(jsonData.success=='true'){
					var info=jsonData.info;
					var infoArr=info.split("^");
					var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
					addComboData(Ext.getCmp("PhaLoc").getStore(),vituralLoc,vituralLocDesc);
					Ext.getCmp("PhaLoc").setValue(vituralLoc);
				}
			}else{
				SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
			}
		}
	}
});
var VendorParmasObj;
if(CommParObj['ApcScg'] == 'Y'){
	VendorParmasObj = {LocId : 'PhaLoc',ScgId : 'StkGrpType'};
}else{
	VendorParmasObj = {LocId : 'PhaLoc'};
}

var Vendor=new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%',
	params : VendorParmasObj,
	listeners : {
		select : function(){
			if(DetailGrid.getStore().getCount() == 0){
				//AddBT.handler();
			}
		}
	}
});
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '������',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
	});
// ��������
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor:'90%',
	listeners:{
		select:function(){
			if(CommParObj['ApcScg'] == 'Y'){
				Ext.getCmp("Vendor").setValue("");
			}
			Ext.getCmp("StkCat").setValue('');
		}
	}
}); 
// ������
var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'StkCat',
	name : 'StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'StkGrpType'}
});

var Specom = new Ext.form.ComboBox({
	fieldLabel : '������',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	width : 120,
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '������...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function(){
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var record = DetailGrid.getStore().getAt(cell[0]);
			var IncRowid = record.get("IncId");	
			var desc=this.getRawValue();
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam('SpecItmRowId',IncRowid)
			this.store.setBaseParam('desc',desc)
			this.store.load({params:{start:0,limit:this.pageSize}})
		} ,
		'specialkey' : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	})
});
// �������
var OperateInType = new Ext.form.ComboBox({
	fieldLabel : '�������',
	id : 'OperateInType',
	name : 'OperateInType',
	anchor : '90%',
	store : OperateInTypeStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	valueNotFoundText : ''
});
// Ĭ��ѡ�е�һ������
setDefaultInType();
// ��ⵥ��
var InGrNo = new Ext.form.TextField({
	fieldLabel : '��ⵥ��',
	id : 'InGrNo',
	name : 'InGrNo',
	anchor : '90%',
	disabled : true
});

// �������
var InGrDate = new Ext.ux.DateField({
	fieldLabel : '�������',
	id : 'InGrDate',
	name : 'InGrDate',
	anchor : '90%',
	value : new Date(),
	disabled : true
});
// ������
var RequestLoc = new Ext.ux.LocComboBox({
			fieldLabel : '���տ���',
			id : 'RequestLoc',
			name : 'RequestLoc',
			anchor:'90%',
			width : 120,
			emptyText : '���տ���...',
			defaultLoc:{}
});

// �ɹ���Ա
if(IngrParamObj.UseAllUserAsPur == 'Y'){
	var PurchaseUser = new Ext.ux.ComboBox({
		id : 'PurchaseUser',
		fieldLabel : '�ɹ���Ա',
		store : AllUserStore,	//ȡ������Ա
		filterName : 'Desc'
	});
}else{
	var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel : '�ɹ���Ա',
		id : 'PurchaseUser',
		store : PurchaseUserStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	PurchaseUserStore.load({
		callback : function(r,options,success){  
			for(var i=0;i<r.length;i++){ 
				if(PurchaseUserStore.data.items[i].data["Default"]=="Y"){ 
					PurchaseUser.setValue(PurchaseUserStore.data.items[i].data["RowId"]);   
				}  
			}
		}
	});
}

var AcceptUser = new Ext.ux.ComboBox({
	fieldLabel : '������',	
	id : 'AcceptUser',
	anchor : '90%',
	store : UStore,
	filterName : 'name',
	params : {locId:'PhaLoc'}
});

// ��ע
var InGrRemarks = new Ext.form.TextArea({
	id:'InGrRemarks',
	fieldLabel:'��ע',
	allowBlank:true,
	height:50,
	emptyText:'��ע...',
	anchor:'90%',
	selectOnFocus:true
});
var InPoNumField= new Ext.form.TextField({
	fieldLabel : '���е�',
	id : 'InPoNumField',
	name : 'InPoNumField',
	anchor : '90%',
	listeners : {
	 specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				SynInGdRec(field.getValue());
			}
		}
	}
});
function SynInGdRec(barcode){
	var url = DictUrl
			+ "sciaction.csp?actiontype=CreateInGdRecBySciPo";
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{BarCode:barcode,LocId:gLocId,user:gUserId},
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var IngrRowid = jsonData.info;
				Msg.info("success", "����ɹ�!");
				gIngrRowid=IngrRowid;
				Query(IngrRowid);
				if(gParam[3]=='Y'){
					PrintRec(IngrRowid,'Y');
				}
			} else {
				var ret=jsonData.info;
				if(ret==-99){
					Msg.info("error", "����ʧ��,���ܱ���!");
				}else if(ret==-2){
					Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
				}else if(ret==-3){
					Msg.info("error", "������ⵥʧ��!");
				}else if(ret==-912){
					Msg.info("error", "�����е�û��Ҫ����������Ϣ��");
				}else if(ret==-911){
					Msg.info("error", "���е����ʧ�ܣ�");
				}else if(ret==-4){
					Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
				}else if(ret==-5){
					Msg.info("error", "������ⵥ��ϸʧ��!");
				}else {
					Msg.info("error", "���治�ɹ���"+ret);
				}
			}
			loadMask.hide();
		},
		scope : this
	});
}
	
// ��ɱ�־
var CompleteFlag = new Ext.form.Checkbox({
	boxLabel : '���',
	id : 'CompleteFlag',
	name : 'CompleteFlag',
	anchor : '90%',
	checked : false,
	disabled:true
});
	
// ��ҩ����־
var PresentFlag = new Ext.form.Checkbox({
	boxLabel : '����',
	id : 'PresentFlag',
	name : 'PresentFlag',
	anchor : '90%',
	checked : false,
	listeners: {
		'check':function(cb,checked){
			if(checked==true){
				Msg.info("warning","����ѡ�˾�����־!")
			}		
		}
	}
});

// ���ۻ�Ʊ��־
var ExchangeFlag = new Ext.form.Checkbox({		
	id : 'ExchangeFlag',
	name : 'ExchangeFlag',
	anchor : '100%',
	checked : false,
	boxLabel:'���ۻ�Ʊ',
	listeners: {
		'check':function(cb,checked){
			if(checked==true){
				Msg.info("warning","����ѡ�˵��ۻ�Ʊ��־!")
			}		
		}
	}
});

var SourceOfFund = new Ext.ux.ComboBox({
	fieldLabel : '�ʽ���Դ',
	id : 'SourceOfFund',
	name : 'SourceOfFund',
	anchor : '90%',
	store : SourceOfFundStore,
	valueField : 'RowId',
	filterName:'Desc',
	displayField : 'Description'
});
// Ĭ��ѡ�е�һ������
setDefaultSourceOfFund();
// ��ӡ��ⵥ��ť
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '��ӡ��ⵥƱ��',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if((gParam[26]=="N")&&(Ext.getCmp('CompleteFlag').getValue()==false)){
			Msg.info('warning','�������ӡδ��ɵ���ⵥ!');
			return;
		}
		PrintRec(gIngrRowid);
	}
});

var EvaluateBT = new Ext.Toolbar.Button({
	id : "EvaluateBT",
	text : '��Ӧ������',
	tooltip : '������۹�Ӧ��',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if(gIngrRowid=="" || gIngrRowid==null){
			Msg.info("error", "��ѡ����ⵥ!");
			return false;			
		}else{
			evaluateWin(gIngrRowid);
		}
	}
});

// ��ѯ��ⵥ��ť
var SearchInGrBT = new Ext.Toolbar.Button({
	id : "SearchInGrBT",
	text : '��ѯ',
	tooltip : '��ѯ�ѱ������ⵥ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		DrugImportGrSearch(DetailStore,Query);
	}
});
	
function ImpByPoFN() {
	ImportByPo(Query);
}

function ImpBySciPoFN() {
	ImportBySciPo(Query);
}

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	id : "ClearBT",
	text : '���',
	tooltip : '��յ�ǰҳ��ı༭��Ϣ',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		if (isDataChanged(HisListTab,DetailGrid)){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearData();
						SetFormOriginal(HisListTab);
					}
				}
			})
		}else{
			clearData(); 
			SetFormOriginal(HisListTab);
		}
	}
});
// ��ɰ�ť
var CompleteBT = new Ext.Toolbar.Button({
	id : "CompleteBT",
	text : '���',
	tooltip : '���õ�ǰ����Ϊ<���>',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		// �ж���ⵥ�Ƿ������
		var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CompleteFlag != null && CompleteFlag != 0) {
			Msg.info("warning", "��ⵥ�����!");
			return;
		}		
		if (gIngrRowid == null || gIngrRowid=="") {
			Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
			return;
		}
		var rowData = DetailStore.getAt(0);
		if(rowData==""||rowData==undefined){
			Msg.info("warning","û����Ҫ��ɵ�������ϸ!");
			return;
		}
		
		//Ԥ������ж�
		var HRPBudgResult = HRPBudg();
		if(HRPBudgResult === false){
			return;
		}
		
		var mainData=GetIngrMainData(gIngrRowid);
		var mainArr=mainData.split("^");
		var phaLocDesc=mainArr[11];
		if(gHVINGdRec){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '��ǰ������Ϊ"'+phaLocDesc+'", �Ƿ������',
				buttons: Ext.Msg.YESNO,
				fn: function(b,t,o){
					if (b=='yes'){
						Complete();
					}
				},
				icon: Ext.MessageBox.QUESTION
			});
		}else{
			Complete();
		}
	}
});

// ȡ����ɰ�ť
var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : 'ȡ�����',
	tooltip : 'ȡ�����ݵ�<���>��־���ָ����ɱ༭״̬',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		CancleComplete();
	}
});

// ɾ����ť
var DeleteBT = new Ext.Toolbar.Button({
	id : "DeleteBT",
	text : 'ɾ��',
	tooltip : 'ɾ����ǰ����',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		deleteData();
	}
});
	
var viewImage= new Ext.Toolbar.Button({
	text : '���ͼƬ',
	tooltip : '�鿴���ͼƬ',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if ((gIngrRowid=='')||(gIngrRowid==undefined)) {
			Msg.info("error","��ѡ����ⵥ!");
			return false;
		}
		var PicStore = new Ext.data.JsonStore({
			url : 'dhcstm.synpicaction.csp?actiontype=GetInGdRecProductImage',
			root : 'rows',
			totalProperty : "results",
			fields : ["rowid","picsrc","imgtype"]
		});
		var type="";
		ShowInGdRecProductImageWindow(PicStore,gIngrRowid,type);
	}
});      

var ImportButton = new Ext.SplitButton({
		text: '����',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		tooltip: '�������밴ť',
		menu : {
			items: [{
				text: '<b>�����ı��ļ�</b>', handler: ImpFromTxtFN
			},{
				text: '<b>����Excel</b>', handler: ImportExcelFN
			},{
				text: '<b>���붩��</b>', handler: ImpByPoFN
			},{
				text: '<b>������ƽ̨����</b>', handler: ImpBySciPoFN
			},{
				text: '<b>����Excelģ��</b>', handler: ExportExcel
			}]
		}
})
	
function ImpFromTxtFN() {
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != 0) {
		Msg.info("warning", "��ⵥ����ɲ����޸�!");
		return;
	}
	if (Ext.getCmp('Vendor').getValue()==''){
		Msg.info('error','��ѡ��Ӧ��!');
		Ext.getCmp('Vendor').focus();
		return;
	}
	if (Ext.getCmp('StkGrpType').getValue()==''){
		Msg.info('warning','��ѡ������!');
		return;
	}			
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Text(*.txt)|*.txt";
	fd.FilterIndex = 1;	
	// ��������MaxFileSize. �������
	fd.MaxFileSize = 32767;
	// ��ʾ�Ի���
	fd.ShowOpen();
	var fileName=fd.FileName;
	if (fileName=='') return;
	MakeRecFromTxt(fileName,impLine);			
}

function ImportExcelFN(){
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != 0) {
		Msg.info("warning", "��ⵥ����ɲ����޸�!");
		return;
	}
	if (Ext.getCmp('Vendor').getValue()==''){
		Msg.info('error','��ѡ��Ӧ��!');
		Ext.getCmp('Vendor').focus();
		return;
	}
	if (Ext.getCmp('StkGrpType').getValue()==''){
		Msg.info('warning','��ѡ������!');
		return;
	}
	if (impWindow){
		impWindow.ShowOpen();
	}else{
		impWindow = new ActiveXObject("MSComDlg.CommonDialog");
		impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
		impWindow.FilterIndex = 1;
		// ��������MaxFileSize. �������
		impWindow.MaxFileSize = 32767;
		impWindow.ShowOpen();
	}
	
	var fileName = impWindow.FileName;
	if (fileName==''){
		Msg.info('error','��ѡ��Excel�ļ�!');
		return;
	}
	ReadFromExcel(fileName, impLine);
}
///���������ݵ���һ����¼
function impLine(s, rowNumber)
{
	var ss=s.split('\t');
	try {
//			���� ------- ��Ʊ��---- - ����----- - ����----- ��� - ----����- ------Ч��------
		var inciCode =ss[0];
		var invNo =ss[1];
		var qty =ss[2];
		var rp =ss[3];
		var amt =ss[4];
		var batNo =ss[5];
		var expDate =ss[6];
		var hosp=session["LOGON.HOSPID"];
		if(Ext.isEmpty(inciCode)){
			return false;
		}
		var url="dhcstm.drugutil.csp?actiontype=GetItmInfoByCode&ItmCode="+inciCode+"&HospId="+hosp ;	
		var responseText = ExecuteDBSynAccess(url);		
		var jsonData = Ext.util.JSON.decode(responseText);
		if (jsonData.success == 'true') {
			var list = jsonData.info.split("^");		
			var inci=list[15];
			var inciCode=list[0];
			var IncDesc=list[1];
			var Spec=list[16];
			var Sp=list[11];
			var ManfId=list[17];
			var Manf=list[18];
			var IngrUomId=list[8];
			var IngrUom=list[9];
			var BUomId=list[6];
			var NotUseFlag=list[19];
			var BatchReq = list[20];
			var ExpReq = list[21];			
			if(NotUseFlag=='Y'){
				Msg.info('warning', '��'+rowNumber+'��: '+inciCode+' Ϊ"������"״̬!');
				return;
			}
			colArr=sortColoumByEnterSort(DetailGrid); //���س��ĵ���˳���ʼ����
			// ����һ��
			addNewRow();	
			addComboData(PhManufacturerStore,ManfId,Manf);
			addComboData(ItmUomStore,IngrUomId,IngrUom);
			var row=DetailGrid.getStore().getCount();
			var rec=DetailGrid.getStore().getAt(row-1);			
			rec.set('IncCode',inciCode);
			rec.set('InvNo',invNo);			
			rec.set('RecQty',qty);
			rec.set('Rp',rp);
			rec.set('RpAmt',amt);
			rec.set('BatchNo',batNo);
			var d=new Date();
			d = Date.parseDate(expDate, "Y-n-j");
			rec.set('ExpDate',d);					
			rec.set('IncId',inci);
			rec.set('IncDesc',IncDesc);
			rec.set('Spec',Spec);
			rec.set('Sp',Sp);
			rec.set('ManfId',ManfId);
			rec.set('IngrUomId',IngrUomId);
			rec.set('BUomId',BUomId);
			rec.set('BatchReq',BatchReq);
			rec.set('ExpReq',ExpReq);			
		}else{
			Msg.info('error','��'+rowNumber+'�ж�ȡ����!');
			return false ;				
		}	
		// �����ť�Ƿ����
		//��ѯ^���^����^����^ɾ��^���^ȡ�����
		changeButtonEnable("0^1^1^1^1^1^0^1^1");
		SetFieldDisabled(true);
		return true;
	}catch (e){
		Msg.info('error','��ȡ���ݴ���!');
		return false;
	}

}	

/**
 * ��շ���
 */
function clearData() {
	gIngrRowid="";
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("SourceOfFund").setValue("");
	Ext.getCmp("StkGrpType").setValue("");
	Ext.getCmp("StkGrpType").getStore().load();
	Ext.getCmp("StkCat").setValue("");
	Ext.getCmp("StkCat").getStore().load();
	Ext.getCmp("InGrNo").setValue("");
	Ext.getCmp("InGrDate").setValue(new Date());
	Ext.getCmp("CompleteFlag").setValue(false);
	Ext.getCmp("PresentFlag").setValue(false);
	Ext.getCmp("ExchangeFlag").setValue(false);
	Ext.getCmp("InGrRemarks").setValue("");
	Ext.getCmp("VirtualFlag").setValue(false);
	SetLogInDept(PhaLoc.getStore(),"PhaLoc");
	Ext.getCmp("RequestLoc").setValue("");
	Ext.getCmp("OperateInType").setValue(""); //�������
	setDefaultInType();
	setDefaultSourceOfFund();
	Ext.getCmp("InPoNumField").setValue("");  //���е�
	Ext.getCmp("PurchaseUser").setValue("");  // �ɹ�Ա
	Ext.getCmp("AcceptUser").setValue("");
	Ext.getCmp("INFOPbCarrier").setValue("");
	
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
	//��ѯ^���^����^����^ɾ��^���^ȡ�����
	changeButtonEnable("1^1^1^0^0^0^0^1^1");
	SetFieldDisabled(false);
	Ext.getCmp("Vendor").setDisabled(false);
	//������ܴ���href����
	CheckLocationHref();
}

function ExportExcel(){
	window.open("../scripts/dhcstm/InGdRec/��ⵥ����ģ��.xls","_blank");
}
var DeleteDetailBT=new Ext.Toolbar.Button({
	id:'DeleteDetailBT',
	text:'ɾ��һ��',
	tooltip:'ɾ��һ�������ϸ��¼',
	width:70,
	height:30,
	iconCls:'page_delete',
	handler:function(){
		deleteDetail();
	}
});
// ���Ӱ�ť
var AddBT = new Ext.Toolbar.Button({
	id : "AddBT",
	text : '����һ��',
	tooltip : '����һ�������ϸ��¼',
	width : 70,
	height : 30,
	iconCls : 'page_add',
	handler : function() {
	var NewGridFlag = (DetailGrid.getStore().getCount() == 0);
		// �ж���ⵥ�Ƿ�������
		var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CmpFlag != null && CmpFlag != 0) {
			Msg.info("warning", "��ⵥ����ɲ����޸�!");
			return;
		}
		// �ж��Ƿ�ѡ����ⲿ�ź͹�������
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ����ⲿ��!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		if (vendor == null || vendor.length <= 0) {
			Msg.info("warning", "��ѡ��Ӧ��!");
			Ext.getCmp('Vendor').focus();
			return;
		}
		if (Ext.getCmp('StkGrpType').getValue()==''){
			Msg.info('warning','δѡ�����飬�������ʵ����!');
			//return;
		}  
		var operateInType = Ext.getCmp("OperateInType").getValue();
		if ((gParam[8]=="Y")&(operateInType == null || operateInType.length <= 0)) {
			Msg.info("warning", "��ѡ���������!");
			Ext.getCmp("OperateInType").focus();
			return;
		}
		
		if (gParam[15]=="Y") {
			Msg.info("warning", "��ⵥ��Ͷ�������һ��,��������!");
			return;
		}
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
		if((SourceOfFund==null || SourceOfFund=="")&&gParam[29]=="Y"){
			Msg.info("warning", "�ʽ���Դ����Ϊ��!");
			Ext.getCmp("SourceOfFund").focus();
			return false;
		}
		colArr=sortColoumByEnterSort(DetailGrid); //���س��ĵ���˳���ʼ����
		// ����һ��
		addNewRow();
		// �����ť�Ƿ����
		//��ѯ^���^����^����^ɾ��^���^ȡ�����
		changeButtonEnable("0^1^1^1^1^1^0^1^1");
		SetFieldDisabled(true);
		if(!NewGridFlag){
			Ext.getCmp("StkGrpType").setDisabled(true);
		}

	}
});

function SetFieldDisabled(bool){
	Ext.getCmp("PhaLoc").setDisabled(bool);
	//Ext.getCmp("Vendor").setDisabled(bool);
	//Ext.getCmp("StkGrpType").setDisabled(bool);
	Ext.getCmp("StkCat").setDisabled(bool);
}
	
/**
 * ����һ��
 */
function addNewRow() {
	if(DetailGrid.activeEditor!=null){DetailGrid.activeEditor.completeEdit();}
	var inciIndex=GetColIndex(DetailGrid,"IncDesc");
	var barcodeIndex=GetColIndex(DetailGrid,"HVBarCode");
	var col=gHVINGdRec?barcodeIndex:inciIndex;
	var lastInvNo="",lastInvDate="";
	// �ж��Ƿ��Ѿ��������
	var rowCount = DetailGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = DetailStore.data.items[rowCount - 1];
		var data = rowData.get("IncId");
		if (data == null || data.length <= 0) {
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			return;
		}
		//==============���ϴ�����������ƺͽ��۽��бȽ�==============
		if(gParam[31]=="Y"){
			var inci=data;
			var rprice=rowData.get("Rp");
			var inciDesc=rowData.get("IncDesc");
			var url = 'dhcstm.ingdrecaction.csp?actiontype=CheckNamePrice&inci='+inci+'&rp='+rprice;					
			var CheckResult = ExecuteDBSynAccess(url);
			var CheckJsonData = Ext.util.JSON.decode(CheckResult)				
			if (CheckJsonData.success == 'true') {
				if(CheckJsonData.info == -1){
					Msg.info("warning", inciDesc + '���������޸�!');
				}else if(CheckJsonData.info == -2){
					Msg.info("warning", inciDesc + '�Ľ����ѵ���!');
				}
			}
		}
		if(gParam[14]=='Y'){
			if(rowCount>0){
				var lastrowData = DetailStore.data.items[rowCount - 1];
				lastInvNo=lastrowData.get('InvNo');
				lastInvDate=lastrowData.get('InvDate');
				rowData.set('InvNo',lastInvNo);
				rowData.set('InvDate',lastInvDate);
			}
		}
	}
	var defaData = {InvNo : lastInvNo,InvDate:lastInvDate};
	var NewRecord = CreateRecordInstance(DetailStore.fields,defaData);
	DetailStore.add(NewRecord);	
	DetailGrid.startEditing(DetailStore.getCount() - 1, col);
}

// ���水ť
var SaveBT = new Ext.ux.Button({
	id : "SaveBT",
	text : '����',
	tooltip : '���浱ǰ�ĵ���',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		if(CheckDataBeforeSave()==true){
			if(BatSpFlag != '1' && IngrParamObj.AllowAspWhileReceive == 'Y'){
				var rowCount = DetailGrid.getStore().getCount();
				AdjPriceShow(0, rowCount-1);
			}else{
				saveOrder();
			}
		}
	}
});

function AdjPriceShow(ind,rowCount){
	try{
		var record = DetailStore.getAt(ind);
		var IncRowid=record.get("IncId");
	}catch(e){}
	if(Ext.isEmpty(IncRowid)){
		//���������зǿ���
		saveOrder();
		return;
	}
	var AdjSpUomId=record.get("IngrUomId");
	var uomdesc=record.get("IngrUom");
	var ResultSp= record.get("Sp"); 
	var ResultRp=record.get("Rp");
	var incicode=record.get("IncCode");
	var incidesc=record.get("IncDesc");
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	var strParam=gGroupId+"^"+gLocId+"^"+gUserId
	var url=DictUrl + "ingdrecaction.csp?actiontype=GetPrice&InciId="+IncRowid+"&UomId="+AdjSpUomId+"&StrParam="+strParam;
	var pricestr=ExecuteDBSynAccess(url);
	var priceArr=pricestr.split("^");
	var PriorRp=priceArr[0];
	var PriorSp=priceArr[1];
	var data = IncRowid + "^" + AdjSpUomId + "^" + PriorSp + "^" + ResultRp + "^" + gUserId
			+ "^" +PriorRp+"^"+ResultSp+"^"+StkGrpType+"^"+gLocId+ "^" +incicode
			+ "^" +incidesc+ "^" +uomdesc;
	var adjspFlag=tkMakeServerCall("web.DHCSTM.INAdjSalePrice","CheckItmAdjSp",IncRowid,""); //������ڵ��۵��򲻽�����ʾ
	if((IncRowid!="")&&(PriorSp!=ResultSp)&&(adjspFlag!=1)){
		var ret=confirm(incidesc+"�۸����仯���Ƿ����ɵ��۵�?");
		if (ret==true){
			SetAdjPrice(data,ind,rowCount,AdjPriceShow);	//ѭ������
		}else{
			if(ind >= rowCount){
				saveOrder();
			}else{
				AdjPriceShow(++ind,rowCount);
			}
		}
	}else if((IncRowid!="")&&(PriorSp!=ResultSp)&&(adjspFlag==1)){
		var ret=confirm(incidesc+"�۸����仯������δ��˵ĵ��۵��������ٴ����ɣ��Ƿ����?");
		if (ret==true){
			if(ind >= rowCount){
				saveOrder();
			}else{
				AdjPriceShow(++ind,rowCount);
			}
		}else{
			return;
		}
	}else{
		if(ind >= rowCount){
			saveOrder();
		}else{
			AdjPriceShow(++ind,rowCount);
		}
	}
}
	
/**
 * ������ⵥǰ���ݼ��
 */		
function CheckDataBeforeSave() {
	var nowdate = new Date();
	// �ж���ⵥ�Ƿ�������
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != 0) {
		Msg.info("warning", "��ⵥ����ɲ����޸�!");
		return false;
	}
	// �ж���ⲿ�ź͹������Ƿ�Ϊ��
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ����ⲿ��!");
		Ext.getCmp("PhaLoc").focus();
		return false;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	if (vendor == null || vendor.length <= 0) {
		Msg.info("warning", "��ѡ��Ӧ��!");
		Ext.getCmp('Vendor').focus();
		return false;
	}
	var carrid=Ext.getCmp("INFOPbCarrier").getValue();
	/*if (carrid==null||carrid.length<=0){
		Msg.info("warning", "��ѡ��������!");
		Ext.getCmp('INFOPbCarrier').focus();
		return false;
		
		}*/
	var PurUserId = Ext.getCmp("PurchaseUser").getValue();
	if((PurUserId==null || PurUserId=="")&(gParam[7]=='Y')){
		Msg.info("warning", "�ɹ�Ա����Ϊ��!");
		Ext.getCmp("PurchaseUser").focus();
		return false;
	}
	var IngrTypeId = Ext.getCmp("OperateInType").getValue();
	if((IngrTypeId==null || IngrTypeId=="")&(gParam[8]=='Y')){
		Msg.info("warning", "������Ͳ���Ϊ��!");
		Ext.getCmp("OperateInType").focus();
		return false;
	}
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
	if((SourceOfFund==null || SourceOfFund=="")&&gParam[29]=="Y"){
		Msg.info("warning", "�ʽ���Դ����Ϊ��!");
		Ext.getCmp("SourceOfFund").focus();
		return false;
	}
	// 1.�ж���������Ƿ�Ϊ��
	var rowCount = DetailGrid.getStore().getCount();
	// ��Ч����
	var count = 0;
	for (var i = 0; i < rowCount; i++) {
		var item = DetailStore.getAt(i).get("IncId");
		if (item != "") {
			count++;
		}
	}
	if (rowCount <= 0 || count <= 0) {
		Msg.info("warning", "�����������ϸ!");
		return false;
	}
	// 2.������䱳��
	for (var i = 0; i < rowCount; i++) {
		changeBgColor(i, "white");
	}

	// 3.������Ϣ�������
	for (var i = 0; i < rowCount; i++) {
		var rowData = DetailStore.getAt(i);
		var expDateValue = rowData.get("ExpDate");
		var item = rowData.get("IncId");
		if(item==null || item==""){
			break;
		}
		var InvNo=rowData.get('InvNo')
		if ((item != "") && (InvNo=="")&&(gParam[20]=="Y")) {
			Msg.info("warning", "��Ʊ�Ų���Ϊ��!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var ExpReq = rowData.get('ExpReq');
		if(ExpReq=='R'){
			if ((expDateValue==null)||(expDateValue==""))
			{
				Msg.info("warning","��Ч�ڲ���Ϊ��!");	
				return false;		
			}
			var ExpDate = new Date(Date.parse(expDateValue));
			if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
				Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		var BatchNo = rowData.get('BatchNo');
		var BatchReq = rowData.get('BatchReq');
		if(BatchReq=='R'){
			if ((item != "") && (BatchNo=="")) {
				Msg.info("warning", "���Ų���Ϊ��!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		var qty = rowData.get("RecQty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "�����������С�ڻ����0!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var inpoqty=rowData.get("InPoQty");
		if((gParam[13] != "Y") && (inpoqty!="") && (Number(qty) > Number(inpoqty))){
			Msg.info("warning", "����������ܴ��ڶ�������!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var realPrice = rowData.get("Rp");
		if ((item != "")&& (realPrice == null || realPrice < 0)) {
			Msg.info("warning", "�����۲���С��0!");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		var Sp = rowData.get("Sp");
		if (Sp<0){
			Msg.info("warning","��"+(i+1)+"���ۼ۲���ΪС��0");
			DetailGrid.getSelectionModel().select(i, 1);
			changeBgColor(i, "yellow");
			return false;
		}
		if((gParam[24] == "N")  ){
			var ManfId=rowData.get("ManfId");
			if(ManfId=='' || ManfId==undefined || ManfId==null){
				Msg.info("warning", "��⳧�̲���Ϊ��!");
				DetailGrid.getSelectionModel().select(i, 1);
				return false;
			}
		}
	}
	return true;
}
	
/**
 * ������ⵥ
 */
function saveOrder() {
	loadMask=ShowLoadMask(Ext.getBody(),"������...");
	var IngrNo = Ext.getCmp("InGrNo").getValue();
	var VenId = Ext.getCmp("Vendor").getValue();
	var Completed = (Ext.getCmp("CompleteFlag").getValue()==true?'Y':'N');
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var CreateUser = gUserId;
	var ExchangeFlag =(Ext.getCmp("ExchangeFlag").getValue()==true?'Y':'N');
	var PresentFlag = (Ext.getCmp("PresentFlag").getValue()==true?'Y':'N');
	var IngrTypeId = Ext.getCmp("OperateInType").getValue();
	var PurUserId = Ext.getCmp("PurchaseUser").getValue();
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var InGrRemarks = Ext.getCmp("InGrRemarks").getValue();
	InGrRemarks=InGrRemarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();		
	var RequestLoc = Ext.getCmp("RequestLoc").getValue(); 
	var AcceptUserId = Ext.getCmp("AcceptUser").getValue();
	var StkCatId = Ext.getCmp("StkCat").getValue();
	var carrid=Ext.getCmp("INFOPbCarrier").getValue();
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag 
			+ "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+""+"^"+InGrRemarks
			+ "^"+SourceOfFund+"^"+RequestLoc + "^^^" + AcceptUserId+"^^"+StkCatId+"^"+carrid;
	var ListDetail="";
	var rowCount = DetailGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = DetailStore.getAt(i);
		//���������ݷ����仯ʱִ����������
		if(rowData.data.newRecord || rowData.dirty){	
			var Ingri=rowData.get("Ingri");
			var IncId = rowData.get("IncId");
			if(IncId==null || IncId==""){continue;}
			var Sp=rowData.get("Sp");
			var BatchNo = rowData.get("BatchNo");
			var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("IngrUomId");
			var RecQty = rowData.get("RecQty");
			var Rp = rowData.get("Rp");
			if(Rp == 0 && confirm('��' + (i+1) + '��:' + rowData.get('IncDesc') + ' ����Ϊ0, �Ƿ����?') == false){
				loadMask.hide();
				return false;
			}
			//==============���ϴ�����������ƺͽ��۽��бȽ�==============
			if(gParam[31]=="Y"){
				var inciDesc=rowData.get("IncDesc");
				var url = 'dhcstm.ingdrecaction.csp?actiontype=CheckNamePrice&inci='+IncId+'&rp='+Rp;					
				var CheckResult = ExecuteDBSynAccess(url);
				var CheckJsonData = Ext.util.JSON.decode(CheckResult)				
				if (CheckJsonData.success == 'true') {
					if(CheckJsonData.info == -1){
						Msg.info("warning", inciDesc + '���������޸�!');
					}else if(CheckJsonData.info == -2){
						Msg.info("warning", inciDesc + '�Ľ����ѵ���!');
					}
				}
			}
			var NewSp =rowData.get("NewSp");
			var SxNo = rowData.get("SxNo");
			var InvNo = rowData.get("InvNo");
			var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
			var Remark=rowData.get("Remark");
			var Remarks=rowData.get("Remarks");
			var QualityNo=rowData.get("QualityNo");
			var MtDesc=rowData.get("MtDesc");
			var MtDr=rowData.get("MtDr");
			var BarCode=rowData.get("HVBarCode");
			var SterilizedNo=rowData.get("SterilizedNo");
			var AdmNo = rowData.get("AdmNo");
			var AdmExpDate =Ext.util.Format.date(rowData.get("AdmExpdate"),ARG_DATEFORMAT);
			var SpecDesc=rowData.get("SpecDesc");
			var reqLoc = rowData.get("reqLocId"); 
			//20180211
			var Tax=rowData.get("Tax")
			var InvSupplyDate =Ext.util.Format.date(rowData.get("InvSupplyDate"),ARG_DATEFORMAT);
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
					+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
					+ "^" + InvNo + "^" + InvDate + "^" + "" + "^" + Remark + "^" + Remarks
					+ "^" + QualityNo + "^" + MtDr + "^"+ BarCode + "^" + SterilizedNo + "^" + AdmNo
					+ "^" + AdmExpDate + "^^" + SpecDesc + "^^" + reqLoc
					+ "^" + Sp+"^" +Tax+"^"+InvSupplyDate;
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
		}
	}
	if(!IsFormChanged(HisListTab) && ListDetail==""){
		Msg.info("error", "û��������Ҫ����!");
		loadMask.hide();
		return false;
	}
	var url = DictUrl
		+ "ingdrecaction.csp?actiontype=Save";
	//var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{Ingr:gIngrRowid,MainInfo:MainInfo,ListDetail:ListDetail},
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var IngrRowid = jsonData.info;
				Msg.info("success", "����ɹ�!");
				DetailStore.commitChanges();
				// 7.��ʾ��ⵥ����
				gIngrRowid=IngrRowid;
				Query(IngrRowid);
				if(gParam[3]=='Y'){
					PrintRec(IngrRowid,'Y');
				}
				Ext.getCmp("Vendor").setDisabled(true);
			} else {
				var ret=jsonData.info;
				if(ret==-99){
					Msg.info("error", "����ʧ��,���ܱ���!");
				}else if(ret==-2){
					Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
				}else if(ret==-3){
					Msg.info("error", "������ⵥʧ��!");
				}else if(ret==-4){
					Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
				}else if(ret==-5){
					Msg.info("error", "������ⵥ��ϸʧ��!");
				}else {
					Msg.info("error", "������ϸ���治�ɹ���"+ret);
				}
				loadMask.hide();
			}
		},
		scope : this
	});
}
// ��ʾ��ⵥ����
function Query(IngrRowid) {
	if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
		return;
	}
	var url = DictUrl
		+ "ingdrecaction.csp?actiontype=Select&IngrRowid="
		+ IngrRowid;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var list = jsonData.info.split("^")
				if (list.length > 0) {
					gIngrRowid=IngrRowid;
					Ext.getCmp("InGrNo").setValue(list[0]);
					addComboData(Ext.getCmp("Vendor").getStore(),list[1],list[2]);
					Ext.getCmp("Vendor").setValue(list[1]);
					addComboData(Ext.getCmp("PhaLoc").getStore(),list[10],list[11]);
					Ext.getCmp("PhaLoc").setValue(list[10]);
					addComboData(OperateInTypeStore,list[17],list[18]);
					Ext.getCmp("OperateInType").setValue(list[17]);
					addComboData(Ext.getCmp("PurchaseUser").getStore(),list[19],list[20]);
					Ext.getCmp("PurchaseUser").setValue(list[19]);
					Ext.getCmp("InGrDate").setValue(list[12]);
					Ext.getCmp("CompleteFlag").setValue(list[9]=='Y'?true:false);
					Ext.getCmp("PresentFlag").setValue(list[30]=='Y'?true:false);
					Ext.getCmp("ExchangeFlag").setValue(list[31]=='Y'?true:false);
					addComboData(null,list[27],list[28],StkGrpType);
					Ext.getCmp("StkGrpType").setValue(list[27]);
					var InGrRemarks=handleMemo(list[32],xMemoDelim());
					Ext.getCmp("InGrRemarks").setValue(InGrRemarks);
					addComboData(Ext.getCmp("SourceOfFund").getStore(),list[33],list[34]);
					Ext.getCmp("SourceOfFund").setValue(list[33]);
					addComboData(Ext.getCmp("RequestLoc").getStore(),list[21],list[22]);
					Ext.getCmp("RequestLoc").setValue(list[21]);
					addComboData(Ext.getCmp("AcceptUser").getStore(),list[23],list[24]);
					Ext.getCmp("AcceptUser").setValue(list[23]);
					addComboData(null,list[36],list[37],StkCat);
					Ext.getCmp("StkCat").setValue(list[36]);
					addComboData(Ext.getCmp("INFOPbCarrier").getStore(),list[38],list[39]);
					Ext.getCmp("INFOPbCarrier").setValue(list[38]);
					// ��ʾ��ⵥ��ϸ����
					getDetail(IngrRowid);
					SetFieldDisabled(true);
				}
				SetFormOriginal(HisListTab);
			} else {
				if(loadMask){loadMask.hide();}
				Msg.info("warning", jsonData.info);
			}
		},
		scope : this
	});
}

// �����ϸ
// ����·��
var DetailUrl =DictUrl+
	'ingdrecaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});

// ָ���в���
var fields = ["Ingri", "IncId", "IncCode", "IncDesc","ManfId","Manf","BatchNo", {name:'ExpDate',type:'date',dateFormat:DateFormat},
	"IngrUomId","IngrUom","RecQty","Rp", "Marginnow", "Sp","NewSp","InvNo","InvMoney", {name:'InvDate',type:'date',dateFormat:DateFormat},"RpAmt", "SpAmt", "NewSpAmt",
	"QualityNo","SxNo","Remark","Remarks","MtDesc","PubDesc","BUomId","ConFacPur","MtDr","HVFlag","HVBarCode","Spec","SterilizedNo","InPoQty","BatchReq","ExpReq",
	"BarCode","AdmNo",{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"SpecDesc","reqLocId","reqLocDesc","Tax","TaxAmt",{name:'InvSupplyDate',type:'date',dateFormat:DateFormat}];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "Ingri",
	fields : fields
});
// ���ݼ�
var DetailStore = new Ext.data.Store({
	proxy : proxy,
	reader : reader
});
// ��ʾ��ⵥ��ϸ����
function getDetail(IngrRowid) {
	if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
		return;
	}
	DetailStore.load({
		params:{start:0,limit:999,Parref:IngrRowid},
		callback:function(r,success,options){
			if(loadMask){loadMask.hide();}
		}
	});
	// �����ť�Ƿ����
	//��ѯ^���^����^����^ɾ��^���^ȡ�����
	var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	if(inGrFlag==true){
		changeButtonEnable("1^1^0^0^0^0^1^0^0");
	}else{
		changeButtonEnable("1^1^1^1^1^1^0^1^1");
	}
	
}

// �����ť�Ƿ����
function changeButtonEnable(str) {
	var list = str.split("^");
	for (var i = 0; i < list.length; i++) {
		if (list[i] == "1") {
			list[i] = false;
		} else {
			list[i] = true;
		}
	}
	//��ѯ^���^����^����^ɾ��^���^ȡ�����
	SearchInGrBT.setDisabled(list[0]);
	ClearBT.setDisabled(list[1]);
	AddBT.setDisabled(list[2]);
	SaveBT.setDisabled(list[3]);
	DeleteBT.setDisabled(list[4]);
	CompleteBT.setDisabled(list[5]);
	CancleCompleteBT.setDisabled(list[6]);
	ImportButton.setDisabled(list[7]);
}

function deleteData() {
	// �ж���ⵥ�Ƿ�������
	var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	if (inGrFlag != null && inGrFlag != 0) {
		Msg.info("warning", "��ⵥ����ɲ���ɾ��!");
		return;
	}
	if (gIngrRowid == "") {
		Msg.info("warning", "û����Ҫɾ������ⵥ!");
		return;
	}

	Ext.MessageBox.show({
		title : '��ʾ',
		msg : '�Ƿ�ȷ��ɾ��������ⵥ?',
		buttons : Ext.MessageBox.YESNO,
		fn : showDeleteGr,
		icon : Ext.MessageBox.QUESTION
	});
}

/**
 * ɾ����ⵥ��ʾ
 */
function showDeleteGr(btn) {
	if (btn == "yes") {
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Delete&IngrRowid="
			+ gIngrRowid;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ɾ������
					Msg.info("success", "��ⵥɾ���ɹ�!");
					clearData();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
					}else if(ret==-2){
						Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
					}else if(ret==-3){
						Msg.info("error", "��ⵥ������ϸ�Ѿ���ˣ�����ɾ��!");
					}else{
						Msg.info("error", "ɾ��ʧ��,��鿴������־!");
					}
				}
			},
			scope : this
		});
	}
}

/**
 * ɾ��ѡ��������
 */
function deleteDetail() {
	// �ж���ⵥ�Ƿ������
	var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", "��ⵥ����ɲ���ɾ��!");
		return;
	}
	if (gParam[15]=="Y") {
		Msg.info("warning", "��ⵥ��Ͷ�������һ��,����ɾ��!");
		return;
	}
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "û��ѡ����!");
		return;
	}
	// ѡ����
	var row = cell[0];
	var record = DetailGrid.getStore().getAt(row);
	var Ingri = record.get("Ingri");
	if (Ingri == "" ) {
		DetailGrid.getStore().remove(record);
		DetailGrid.getView().refresh();
	} else {
		Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȷ��ɾ����������Ϣ?',
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});
	}
}
/**
 * ɾ����ʾ
 */
function showResult(btn) {
	if (btn == "yes") {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var Ingri = record.get("Ingri");

		// ɾ����������
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=DeleteDetail&Rowid="
			+ Ingri;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "ɾ���ɹ�!");
					DetailGrid.getStore().remove(record);
					DetailGrid.getView().refresh();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
					}else if(ret==-2){
						Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
					}else if(ret==-4){
						Msg.info("error", "����ϸ�����Ѿ���ˣ�����ɾ��!");
					}else{
						Msg.info("error", "ɾ��ʧ��,��鿴������־!");
					}
				}
			},
			scope : this
		});
	}
}

/**
 * �����ⵥ
 */
function Complete() {
	// �ж���ⵥ�Ƿ������
	var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
	if (CompleteFlag != null && CompleteFlag != 0) {
		Msg.info("warning", "��ⵥ�����!");
		return;
	}
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	if (InGrNo == null || InGrNo.length <= 0) {
		Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
		return;
	}
	//===========================
	var rowData = DetailStore.getAt(0);
	if(rowData==""||rowData==undefined){
		Msg.info("warning","û����Ҫ��ɵ�������ϸ!");
		return;
	}
	var Count = DetailGrid.getStore().getCount();
//		for (var i = 0; i < Count; i++) {
//			var rowData = DetailStore.getAt(i);
//			var Sp = Number(rowData.get("Sp"));
//			if(Sp<0){
//				Msg.info("warning","��"+(i+1)+"���ۼ۲���С��0!");
//				return;
//			}
//		}
	
	var url = DictUrl
			+ "ingdrecaction.csp?actiontype=MakeComplete";
	Ext.Ajax.request({
		url : url,
		params : {Rowid:gIngrRowid,User:gUserId,GroupId:gGroupId},
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ��˵���
				Msg.info("success", "�ɹ�!");
				// ��ʾ��ⵥ����
				Query(gIngrRowid);
				//��ѯ^���^����^����^ɾ��^���^ȡ�����
				changeButtonEnable("1^1^0^0^0^0^1^0^0");
				var AuditAfterComp=gParam[12];	//��ɺ��Զ���˲���
				var PrintAfterAudit=gParam[4];	//��˺��Զ���ӡ����
				if(AuditAfterComp=='Y' && PrintAfterAudit=='Y'){
					PrintRec(gIngrRowid,'Y');
				}if(gParam[23]==""){
					window.location.reload();
				}
				
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "����ʧ��,��ⵥIdΪ�ջ���ⵥ������!");
				}else if(Ret==-2){
					Msg.info("error", "��ⵥ�Ѿ����!");
				}else {
					Msg.info("error", "����ʧ��!");
				}
			}
		},
		scope : this
	});
}

/**
 * ȡ�������ⵥ
 */
function CancleComplete() {
	
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	if (InGrNo == null || InGrNo.length <= 0) {
		Msg.info("warning", "û����Ҫȡ����ɵ���ⵥ!");
		return;
	}
	var url = DictUrl
			+ "ingdrecaction.csp?actiontype=CancleComplete&Rowid="
			+ gIngrRowid + "&User=" + gUserId;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ��˵���
				Msg.info("success", "ȡ���ɹ�!");
				// ��ʾ��ⵥ����
				Query(gIngrRowid);
				//��ѯ^���^����^����^ɾ��^���^ȡ�����
				changeButtonEnable("1^1^1^1^1^1^0^1^1");
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "��ⵥIdΪ�ջ���ⵥ������!");
				}else if(Ret==-2){
					Msg.info("error", "��ⵥ��δ���!");
				}else if(Ret==-4){
					Msg.info("error", "��ⵥ�Ѿ����!");
				}else{
					Msg.info("error", "����ʧ��!");
				}
			}
		},
		scope : this
	});
}

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
	valueNotFoundText : '',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
});

// ��������
var Phmnf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Phmnf',
	name : 'Phmnf',
	anchor : '90%',
	width : 100,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'},
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
});

var ExpDateEditor = new Ext.ux.DateField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
});

var InvNoEditor=new Ext.form.TextField({
	selectOnFocus : true,
	allowBlank : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}			
			}
		}
	}
});

var RpEditor=new Ext.ux.NumberField({
	formatType : 'FmtRP',
	selectOnFocus : true,
	allowBlank : false,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				// ����һ��
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	}
})
var reqLoc = new Ext.ux.LocComboBox({
			fieldLabel : '���տ���',
			id : 'reqLoc',
			name : 'reqLoc',
			anchor:'90%',
			width : 120
});
var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "rowid",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "IncRowid",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '���ʴ���',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		renderer :Ext.util.Format.InciPicRenderer('IncId'),
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true,
		editable : isIncdescEdit,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// �ж���ⵥ�Ƿ������																		
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "��ⵥ�����!");
							return;
						}
						var group = Ext
								.getCmp("StkGrpType")
								.getValue();
						GetPhaOrderInfo(field.getValue(),
								group);
					}
					
				}
			}
		}))
	}, {
		header : '���',
		dataIndex : 'Spec',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "��ֵ��־",
		dataIndex : 'HVFlag',
		width : 80,
		align : 'center',
		sortable : true,
		hidden : true
	}, {
		header : "��ֵ����",
		dataIndex : 'HVBarCode',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : !isBarcodeEdit,
		editable : isBarcodeEdit,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					if (field.getValue()!="" && e.getKey() == Ext.EventObject.ENTER){
						var Barcode=field.getValue();
						var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
						var findHVIndex=DetailStore.findExact('HVBarCode',Barcode,0);
						if(findHVIndex>=0 && findHVIndex!=row){
							Msg.info("warning","�����ظ�¼��!");
							field.setValue("");
							field.focus();
							return;
						}
						Ext.Ajax.request({
							url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
							method : 'POST',
							waitMsg : '��ѯ��...',
							success : function(result, request){
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if(jsonData.success == 'true'){
									var itmArr=jsonData.info.split("^");
									var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
									var inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
									if(Ext.getCmp("StkGrpType").getValue()!=scgID){
										Msg.info("warning","����"+Barcode+"����"+scgDesc+"����,�뵱ǰ����!");
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}else if((type!="Reg" && type!="G")||(type=="G" && lastDetailAudit=="Y")){
										Msg.info("warning","�������Ѱ������!");
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}else if(type=="G" && lastDetailAudit!="Y"){
										Msg.info("warning","��δ��ɻ�δ��˵�"+lastDetailOperNo);
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}
									var record = Ext.data.Record.create([{
											name : 'InciDr',
											type : 'string'
										}, {
											name : 'InciCode',
											type : 'string'
										}, {
											name : 'InciDesc',
											type : 'string'
										}]);
									var InciRecord = new record({
										InciDr : inciDr,
										InciCode : inciCode,
										InciDesc : inciDesc,
										HVFlag : 'Y'
									});
									getDrugList(InciRecord)
								}else{
									Msg.info("error","��������δע��!");
									DetailGrid.store.getAt(row).set("HVBarCode","");
									return;
								}
							}
						});
					}
				}
			}
		}))
	}, {
		header : "����",
		dataIndex : 'ManfId',
		width : 180,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(Phmnf),
		renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")
	}, {
		header : "����",
		dataIndex : 'BatchNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					 if (e.getKey() == Ext.EventObject.ENTER) {
						 if(setEnterSort(DetailGrid,colArr)){
							 addNewRow();
						 }
					 }
				}
			}
		}))
	}, {
		header : "��Ч��",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'center',
		sortable : true,
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : ExpDateEditor
	}, {
		header : "��λ",
		dataIndex : 'IngrUomId',
		width : 80,
		align : 'left',
		sortable : true,
		renderer :Ext.util.Format.comboRenderer2(CTUom,"IngrUomId","IngrUom"),								
		editor : new Ext.grid.GridEditor(CTUom)
	}, {
		header : "����",
		dataIndex : 'RecQty',
		width : 80,
		align : 'right',
		sortable : true,
		editor : new Ext.ux.NumberField({
			formatType : 'FmtQTY',
			selectOnFocus : true,
			allowBlank : false,
			allowNegative : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// �ж���ⵥ�Ƿ������																		
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "��ⵥ�����!");
							return;
						}
						var qty = field.getValue();
						if (qty == null || qty.length <= 0) {
							Msg.info("warning", "�����������Ϊ��!");
							return;
						}
						if (qty <= 0) {
							Msg.info("warning", "�����������С�ڻ����0!");
							return;
						}
						// ����ָ���еĽ�����������ۼ�
						var cell = DetailGrid.getSelectionModel()
								.getSelectedCell();
						var record = DetailGrid.getStore()
								.getAt(cell[0]);
						var RealTotal = Number(record.get("Rp")).mul(qty);
						var SaleTotal = Number(record.get("Sp")).mul(qty);
						var NewSpAmt = Number(record.get("NewSp")).mul(qty);
						record.set("RpAmt", RealTotal);
						record.set("SpAmt", SaleTotal);
						record.set("NewSpAmt", NewSpAmt);
						record.set("InvMoney",RealTotal);
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}								
					}
				}
			}
		})
	}, {
		header : "����",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true,
		editor : RpEditor
	}, {
		header : "�ۼ�",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "��ǰ�ӳ�",
		dataIndex : 'Marginnow',
		width : 60,
		align : 'right',
		sortable : true	
	}, {
		header : "����ۼ�",
		dataIndex : 'NewSp',
		width : 60,
		align : 'right',
		sortable : true,
		editor : new Ext.ux.NumberField({
			formatType : 'FmtSP',
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if (cost == null
								|| cost.length <= 0) {
							Msg.info("warning", "����ۼ۲���Ϊ��!");
							return;
						}
						// ����ָ���е��ۼ۽��
						var cell = DetailGrid.getSelectionModel().getSelectedCell();
						var record = DetailGrid.getStore().getAt(cell[0]);
						var NewSpAmt = accMul(record.get("RecQty"),cost);
						record.set("NewSpAmt",NewSpAmt);
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "��Ʊ��",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true,
		editor : InvNoEditor
	}, {
		header :"��Ʊ���",
		dataIndex :'InvMoney',
		width :80,
		align :'right',
		editable : false,
		summaryType : 'sum',
		editor : new Ext.ux.NumberField({
			formatType : 'FmtRA',
			selectOnFocus : true,
			allowNegative : false
		})
	}, {
		header : "��Ʊ����",
		dataIndex : 'InvDate',
		width : 100,
		align : 'center',
		sortable : true,
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// �ж���ⵥ�Ƿ������
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "��ⵥ�����!");
							return;
						}
						var invDate = field.getValue();
						if (invDate == null || invDate.length <= 0) {
							// Msg.info("warning", "��Ʊ���ڲ���Ϊ��!");
							return;
						}
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : "�ʼ쵥��",
		dataIndex : 'QualityNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "���е���",
		dataIndex : 'SxNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "�������",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'right',
		sortable : true,
		summaryType : 'sum',
		editable:(gParam[6]=='Y'?true:false),
		editor:new Ext.ux.NumberField({
			formatType : 'FmtRA',
			selectOnFocus : true,
			allowNegative:false,
			allowBlank : false
		})
	}, {
		header : "����ۼ۽��",
		dataIndex : 'NewSpAmt',
		width : 100,
		align : 'right',
		sortable : true
	},{
		header : "��������",
		dataIndex : 'MtDesc',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "�б��ִ�",
		dataIndex : 'PubDesc',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "ժҪ",
		dataIndex : 'Remark',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : "��ע",
		dataIndex : 'Remarks',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : "BUomId",
		dataIndex : 'BUomId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "ConFacPur",
		dataIndex : 'ConFacPur',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "MtDr",
		dataIndex : 'MtDr',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "MtDr2",
		dataIndex : 'MtDr2',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "�������",
		dataIndex : 'SterilizedNo',
		width : 90,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// �ж���ⵥ�Ƿ������
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "��ⵥ�����!");
							return;
						}
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		}))
	}, {
		header : '��������',
		dataIndex : 'InPoQty',
		width : 80,
		align : 'left',
		hidden:true,
		sortable : true
	},{
		header : "����Ҫ��",
		dataIndex : 'BatchReq',
		width : 80,
		align : 'center',
		hidden : true
	},{
		header : "��Ч��Ҫ��",
		dataIndex : 'ExpReq',
		width : 80,
		align : 'center',
		hidden : true
	}, {
		header : "����",
		dataIndex : 'BarCode',
		width : 180,
		align : 'left',
		sortable : true,
		editable : isIncdescEdit,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						// �ж���ⵥ�Ƿ������
						var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
						if (CompleteFlag != null && CompleteFlag != false) {
							Msg.info("warning", "��ⵥ�����!");
							return;
						}
						var group = Ext
								.getCmp("StkGrpType")
								.getValue();
						var Barcode=field.getValue();
						GetPhaOrderInfo2(Barcode,group);
					}
				}
			}
		}))
	}, {
		header : "ע��֤��",
		dataIndex : 'AdmNo',
		width : 90,
		align : 'left',
		tooltip:'ͬʱ��Ctrl+Alt+Enter����ѡ���̵�ע��֤��',
		sortable : true,
		editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if ((Ext.EventObject.altKey)&&(Ext.EventObject.ctrlKey))
							{
								showCertInfo();
							}
							else
							{
								if(setEnterSort(DetailGrid,colArr)){
									addNewRow();
								}
							}
						}
					}
				}
			})
	}, {
		header : "ע��֤��Ч��",
		dataIndex : 'AdmExpdate',
		width : 100,
		align : 'center',
		sortable : true,	
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header:"������",
		dataIndex:'SpecDesc',
		width:100,
		editable : AllowEnterSpec,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
	},{
		header : "������",
		dataIndex : 'reqLocId',
		width : 80,
		align : 'left',
		sortable : true,
		renderer :Ext.util.Format.comboRenderer2(reqLoc,"reqLocId","reqLocDesc"),								
		editor : reqLoc
	}, {
		header : "��Ʒ˰��",
		dataIndex : 'Tax',
		width : 100,
		align : 'right',
		sortable : true,
		editor:new Ext.ux.NumberField({
			selectOnFocus : true,
			allowNegative:false,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//20180211
						var Tax=field.getValue();
						var cell=DetailGrid.getSelectionModel().getSelectedCell();
						var record=DetailGrid.getStore().getAt(cell[0]);
						var TaxAmt=Number(record.get("RecQty")).mul(Tax)
						record.set("TaxAmt",TaxAmt)
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}, {
		header : "��Ʒ��˰��",
		dataIndex : 'TaxAmt',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "��Ʊ�ṩ����",
		dataIndex : 'InvSupplyDate',
		width : 100,
		align : 'center',
		sortable : true,	
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
							addNewRow();
						}
					}
				}
			}
		})
	}
]);

var DetailGrid = new Ext.grid.EditorGridPanel({
	id : 'DetailGrid',
	title:'��ⵥ��ϸ',
	region : 'center',
	cm : DetailCm,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	sm : new Ext.grid.CellSelectionModel({}),
	tbar:{items:[AddBT,'-',DeleteDetailBT,'-',{height:30,width:70,text:'������',iconCls:'page_gear',handler:function(){GridColSet(DetailGrid,"DHCSTIMPORTM");}}]},
	clicksToEdit : 1,
	plugins : new Ext.grid.GridSummary(),
	listeners:{
		'beforeedit' : function(e){
			if(Ext.getCmp("CompleteFlag").getValue()==true){
				return false;
			}
			if(e.field=="HVBarCode"){
				if(!UseItmTrack || e.record.get("HVFlag")=='N' ||(e.record.get("Ingri")!="" && e.record.get("HVBarCode")!="")){
					e.cancel=true;
				}
			}
			if(e.field=="RecQty" || e.field=="IncDesc" || e.field=="IngrUomId" || e.field=="HVBarCode"){
				if(e.record.get("HVBarCode")!="" && e.record.get("HVFlag")=="Y"){
					e.cancel=true;
				}
			}
			if(e.field=="ExpDate" && e.record.get('ExpReq')=='N'){
				e.cancel=true;
			}
			if(e.field=="BatchNo" && e.record.get('BatchReq')=='N'){
				e.cancel=true;
			}
		},
		'afteredit' : function(e){
			if(e.field=='ExpDate'){
				if(e.record.get('ExpReq')!='R'){
					return;
				}
				var expDate = e.value;
				if(expDate==null || expDate==""){
					Msg.info("warning","��Ч�ڲ���Ϊ��!");
					e.record.set('ExpDate',e.originalValue);
					return;
				}else{
					expDate=expDate.format(ARG_DATEFORMAT);
				}
				var Inci = e.record.get('IncId');
				var flag=ExpDateValidator(expDate,Inci);
				if(flag==false){
					//Msg.info('warning','�����ʾ���ʧЧ������'+gParam[2]+'��!');
					e.record.set('ExpDate',e.originalValue);
					return;
				}
			}else if(e.field=='BatchNo'){
				if(e.record.get('BatchReq')!='R'){
					return;
				}
				var BatchNo = e.value;
				if(BatchNo==null || BatchNo==""){
					Msg.info("warning","���Ų���Ϊ��!");
					e.record.set('BatchNo',e.originalValue);
					return;
				}
			}else if(e.field=='Rp'){
				var cost = e.value;
				if (Ext.isEmpty(cost)) {
					Msg.info("warning", "���۲���Ϊ��!");
					e.record.set('Rp',e.originalValue);
					return;
				}else if (cost < 0) {
					//2016-09-26���ۿ�Ϊ0
					Msg.info("warning", "���۲���С��0!");
					e.record.set('Rp',e.originalValue);
					return;
				}
				var IncId=e.record.get('IncId');
				var UomId=e.record.get('IngrUomId');
				var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
				var sp = tkMakeServerCall('web.DHCSTM.DHCINGdRec', 'GetSpForRec', IncId, UomId, cost, Params);
				e.record.set("Sp",sp);
				//��֤�ӳ���
				var ChargeFlag = tkMakeServerCall('web.DHCSTM.Common.DrugInfoCommon','GetChargeFlag',IncId);
				var margin = 0;
				if(cost!=0 && gParam[5]!=0 && ChargeFlag=='Y'){
					margin = accSub(accDiv(sp, cost), 1);
					if(margin>gParam[5] || margin<0){
						Msg.info("warning",	"�ӳ��ʳ����޶���Χ!");
						e.record.set('Rp',e.originalValue);
						return false;
					}
				}
				// ����ָ���еĽ������
				var RealTotal = accMul(e.record.get("RecQty"), cost);
				e.record.set("RpAmt",RealTotal);
				e.record.set("InvMoney",RealTotal);
				e.record.set("Marginnow",margin.toFixed(3));
				
				//Ԥ������ж�
				var InciId = e.record.get('IncId');
				var RpAmt = Number(e.record.get('RpAmt'));
				if(!Ext.isEmpty(InciId) && !(Number <= 0)){
					HRPBudg(InciId);
				}
			}else if(e.field=='RecQty'){
				var RealTotal = accMul(e.record.get("Rp"), e.value);
				//20180223
				if(typeof(e.record.get("Tax"))!="undefined"){
				var TaxAmt = accMul(e.record.get("Tax"), e.value);
				e.record.set("TaxAmt",TaxAmt);
				}
				e.record.set("RpAmt",RealTotal);
				e.record.set("InvMoney",RealTotal);
				
				//Ԥ������ж�
				var InciId = e.record.get('IncId');
				var RpAmt = Number(e.record.get('RpAmt'));
				if(!Ext.isEmpty(InciId) && !(Number <= 0)){
					HRPBudg(InciId);
				}
			}else if(e.field=='Tax'){
				//20180223
				var TaxAmt = accMul(e.record.get("RecQty"), e.value);
				e.record.set("TaxAmt",TaxAmt);
			}else if(e.field=='InvNo'){
				var flag=InvNoValidator(e.value, gIngrRowid);
				if(flag==false){
					Msg.info("warning","��Ʊ��" + e.value + "�Ѵ����ڱ����ⵥ!");
				}
			}
		},
		//�Ҽ��˵�
		'rowcontextmenu' : rightClickFn
	}
});

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
	grid.getSelectionModel().select(rowindex,0);
	rightClick.showAt(e.getXY());
}

/*
 * Ԥ�����,����HRPԤ��ӿ�
 */
function HRPBudg(CurrInciId){
	CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
	var LocId = Ext.getCmp('PhaLoc').getValue();
	if(Ext.isEmpty(LocId)){
		return;
	}
	var DataStr = '';
	var Count = DetailGrid.getStore().getCount();
	for(i = 0; i < Count; i++){
		var RowData = DetailGrid.getStore().getAt(i);
		var Ingri = RowData.get('Ingri');
		var IncId = RowData.get('IncId');
		var RpAmt = RowData.get('RpAmt');
		if ((IncId == '') || !(RpAmt > 0)){
			continue;
		}
		var Data = Ingri + '^' + IncId + '^' + RpAmt;
		if(DataStr == ''){
			DataStr = Data;
		}else{
			DataStr = DataStr + RowDelim + Data;
		}
	}
	if(DataStr != ''){
		var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'IngrBalance', CurrInciId, LocId, DataStr);
		if(!Ext.isEmpty(Result)){
			Msg.info('error', '��ǰ�ɹ�����Ԥ��,���ʵ�޸�:' + Result);
			return false;
		}
	}
	return true;
}

//�жϿ�����ظ���(�Ǹ�ֵ����)
function  GetRepeatResult(store,colName,colValue,beginIndex,inciDesc,row){
	beginIndex=store.findExact(colName,colValue,beginIndex);
	if(beginIndex!=-1){
		changeBgColor(row, "yellow");
		Msg.info("warning","���� "+inciDesc+" �Ѵ����ڵ�"+(beginIndex+1)+"��!");
		changeBgColor(beginIndex, "yellow");
		GetRepeatResult(store,colName,colValue,beginIndex+1,inciDesc,row);
	}
}

/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, group) {					
	if (item != null && item.length > 0) {
		var vendor=""
		if(gParam[19]=="Y"){
			vendor=Ext.getCmp('Vendor').getValue()
		}
		var StkCat=Ext.getCmp("StkCat").getValue();
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N",
			"0", gHospId, getDrugList,"",0,
			"","","","",gPhaMulFlag,
			vendor, PhaOrderHVFlag,"",StkCat);
	}
}

//���������ȡ������Ϣ
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderByBarcodeWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
				getDrugList);
	}
}
/**
 * ���ط���
*/
function getDrugList(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();
	
	Ext.each(records,function(record,index,allItems){
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		var HVFlag=record.get("HVFlag");
		// ѡ����
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var rowCount=DetailStore.getCount();
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		if((!gHVINGdRec && HVFlag!="Y")){
			GetRepeatResult(DetailStore,'IncId',inciDr,0,inciDesc,row);
		}
		var rowData = DetailGrid.getStore().getAt(row);
		var ItmTrack=gItmTrackParam[0]=='Y'?true:false;
		//��ֵ���ٲ������úͲ˵���־һ��ʱ, ������ʾ
		if(UseItmTrack && !gHVINGdRec && HVFlag=='Y' && !CreBarByIngdrec){
			Msg.info("warning","��ֵ����,������������!");
			rowData.set("IncDesc","");
			var colIndex=GetColIndex(DetailGrid,'HVBarCode');
			DetailGrid.startEditing(row, colIndex);
			return;
		}

		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
		//ȡ����������Ϣ
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
			+ inciDr+"&Params="+Params;
		var result = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(result);
		if (jsonData.success == 'true') {
			var data=jsonData.info.split("^");
			
			//=====================�ж�����====================
			var DataList = vendor+"^"+inciDr+"^"+data[0];
			var url = 'dhcstm.utilcommon.csp?actiontype=Check&DataList=' + DataList;
			var CheckResult = ExecuteDBSynAccess(url);
			var CheckJsonData = Ext.util.JSON.decode(CheckResult)
			if (CheckJsonData.success == 'true') {
				if(CheckJsonData.info != ""){
					Msg.info("warning", inciDesc + ':' + CheckJsonData.info);
					if(CommParObj.StopItmBussiness == 'Y'){
						return;
					}
				}
			}
			
			rowData.set("IncId",inciDr);
			rowData.set("IncCode",inciCode);
			rowData.set("IncDesc",inciDesc);
			addComboData(PhManufacturerStore,data[0],data[1]);
			rowData.set("ManfId", data[0]);
			rowData.set("BatchNo", data[6]);
			rowData.set("ExpDate", toDate(data[7]));
			rowData.set("MtDesc", data[8]);
			rowData.set("PubDesc", data[9]);
			rowData.set("BUomId", data[10]);
			rowData.set("ConFacPur", data[11]);
			rowData.set("MtDr", data[12]);
			rowData.set("HVFlag",data[14]);
			var BatchReq = data[15],ExpReq = data[16];
			rowData.set("BatchReq",BatchReq);
			rowData.set("ExpReq",ExpReq);
			rowData.set("AdmNo",data[18]);
			rowData.set("AdmExpdate",toDate(data[19]));
			rowData.set("Spec",data[17]);
			rowData.set("BarCode",data[22]);
			if (gParam[30]=="1") {
				addComboData(ItmUomStore,data[10],data[25]);
				rowData.set("IngrUomId", data[10]);
				rowData.set("Rp", Number(data[23]));
				rowData.set("Sp", Number(data[24]));
				rowData.set("NewSp", Number(data[24]));
			} else {
				addComboData(ItmUomStore,data[2],data[3]);
				rowData.set("IngrUomId", data[2]);
				rowData.set("Rp", Number(data[4]));
				rowData.set("Sp", Number(data[5]));
				rowData.set("NewSp", Number(data[5]));
			}
			
			//�Ա�����ۼ�
			if(gParam[9]=="Y" & data[13]!=""){
				if(Number(data[5])>Number(data[13])){
					Msg.info("error","��ǰ�ۼ۸�������ۼ�!");
				}
			}

			if (Ext.getCmp('StkGrpType').getValue()==''){
				addComboData(null,data[30],data[31],Ext.getCmp("StkGrpType"));
				Ext.getCmp("StkGrpType").setValue(data[30]);
			}  
			var RequestLoc = Ext.getCmp("RequestLoc").getValue();
			var RequestLocdisplaytext = Ext.getCmp("RequestLoc").getRawValue()
			addComboData(Ext.getCmp("reqLoc").getStore(),RequestLoc,RequestLocdisplaytext);
			rowData.set("reqLocId", RequestLoc);
			var sp = rowData.get("Sp");
			var rp = rowData.get("Rp");
			if ((sp!=0)&&(rp!=0)){
				var margin = accSub(accDiv(sp, rp), 1);
				rowData.set("Marginnow",margin.toFixed(3));
			}
			//��ת����
			if(gPhaMulFlag == 'Y' && index < allItems.length - 1){
				addNewRow();
			}else{
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
		}
	});
}

/**
 * ��λչ���¼�
 */
CTUom.on('expand', function(combo) {
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var record = DetailGrid.getStore().getAt(cell[0]);
	var InciDr = record.get("IncId");
	ItmUomStore.removeAll();
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
	var ConFac = record.get("ConFacPur");   //��λ��С��λ��ת����ϵ
	var IngrUom = record.get("IngrUomId");    //Ŀǰ��ʾ����ⵥλ
	var Sp = Number(record.get("Sp"));
	var Rp = Number(record.get("Rp"));
	var NewSp = Number(record.get("NewSp"));
	if (value == null || value.length <= 0) {
		return;
	} else if (IngrUom == value) {
		return;
	} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
		record.set("Sp", Sp.div(ConFac));
		record.set("NewSp", NewSp.div(ConFac));
		record.set("Rp", Rp.div(ConFac));
	} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
		record.set("Sp", Sp.mul(ConFac));
		record.set("NewSp", NewSp.mul(ConFac));
		record.set("Rp", Rp.mul(ConFac));
	}
	var RpAmt=Number(record.get("Rp")).mul(record.get("RecQty"));
	var SpAmt=Number(record.get("Sp")).mul(record.get("RecQty"));
	var NewSpAmt=Number(record.get("NewSp")).mul(record.get("RecQty"));
	record.set("RpAmt",RpAmt);
	record.set("InvMoney",RpAmt);
	record.set("SpAmt",SpAmt);
	record.set("NewSpAmt",NewSpAmt);
	record.set("IngrUomId", combo.getValue());
});

// �任����ɫ
function changeBgColor(row, color) {
	DetailGrid.getView().getRow(row).style.backgroundColor = color;
}

var HisListTab = new Ext.form.FormPanel({
	labelWidth : 60,
	region : 'north',
	autoHeight : true,
	labelAlign : 'right',
	title:gHVINGdRec==true?'��ⵥ�Ƶ�(��ֵ)':'��ⵥ�Ƶ�',
	frame : true,
	autoScroll : false,
	tbar : [SearchInGrBT, '-', SaveBT, '-',ClearBT, '-', DeleteBT, '-', CompleteBT,
			'-',CancleCompleteBT,'-',ImportButton,'-',PrintBT,'-',EvaluateBT,'-',viewImage
			],
	items:[{
		xtype:'fieldset',
		title:'�����Ϣ',
		style:'padding:1px 0px 0px 10px',
		layout: 'column',    // Specifies that the items will now be arranged in columns
		defaults: {border:false},
		items : [{
			columnWidth: 0.3,
			xtype: 'fieldset',
			items: [PhaLoc,Vendor,StkGrpType,StkCat,SourceOfFund]
		},{
			columnWidth: gHVINGdRec?0.05:0.01,
			labelWidth : 10,
			items: gHVINGdRec?[VirtualFlag]:[]
		},{
			columnWidth: 0.25,
			xtype: 'fieldset',
			labelWidth: 60,
			defaultType: 'textfield',
			autoHeight: true,
			items: [InGrNo,InGrDate,OperateInType,RequestLoc,INFOPbCarrier]
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,
			defaultType: 'textfield',
			autoHeight: true,
			items: [PurchaseUser,InGrRemarks,InPoNumField]
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,
			defaultType: 'textfield',
			autoHeight: true,
			items: [AcceptUser,CompleteFlag,PresentFlag,ExchangeFlag]
		}]
	}]
});

function setCert(certNo,certExpDate)
{
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var r=cell[0] ;
	var rdata=DetailGrid.getStore().getAt(r);
	rdata.set("AdmNo",certNo);
	rdata.set("AdmExpdate",certExpDate);
}
function showCertInfo()
{	 
	var cell = DetailGrid.getSelectionModel().getSelectedCell();
	var r=cell[0] ;
 	var rdata=DetailGrid.getStore().getAt(r);
	var inci=rdata.get("IncId");
	var manf=rdata.get("ManfId");
	certEdit(inci,manf,setCert);
}
/*����ȱʡ���������
  ע�⣺��һ��Ӧ��Ϊʹ��ȱʡֵ�����ã���ʱ��ˡ�
*/	
function setDefaultInType()
{
	OperateInTypeStore.load({
		callback:function(r,options,success){
			if(success && r.length>0){
				OperateInType.setValue(r[0].get(OperateInType.valueField));
			}
		}
	});
}
/*����ȱʡ���ʽ���Դ��ǰ���ǲ������ó��ʽ���Դ�Ǳ�����
  ע�⣺��һ��Ӧ��Ϊʹ��ȱʡֵ�����ã���ʱ��ˡ�
*/	
function setDefaultSourceOfFund()
{
	SourceOfFundStore.load({
		params:{start:0,limit:999},
		callback:function(r,options,success){
			if(success && r.length>0 &&gParam[29]=="Y"){
				SourceOfFund.setValue(r[0].get(SourceOfFund.valueField));
			}
		}
	});
}
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, DetailGrid],
		renderTo : 'mainPanel'
	});
	
	RefreshGridColSet(DetailGrid,"DHCSTIMPORTM");   //�����Զ�������������������
	if(gIngrRowid!=null && gIngrRowid!='' && gFlag==1){
		Query.defer(100,this,[gIngrRowid]);
	}
})