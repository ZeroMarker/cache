// /����: �˻����Ƶ�
// /����: �˻����Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.31

var URL = 'dhcstm.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var gIngrt= gIngrtId;	//�˻�����id

var buomRp="";	//������λ����
var buomSp="";	//������λ�ۼ�
var puomRp="";	//��ⵥλ����
var puomSp="";	//��ⵥλ�ۼ�
GetParam();
//ȡ��ֵ�������

var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}

var dateField = new Ext.ux.DateField({
	id:'dateField',
	listWidth:150,
	allowBlank:false,
	fieldLabel:'����',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var dretField = new Ext.form.TextField({
	id:'dret',
	fieldLabel:'�˻�����',
	allowBlank:true,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'�˻�����',
	emptyText:'�˻�����...',
	anchor:'90%',
	groupId:groupId,
	stkGrpId : 'groupField',
	childCombo : 'Vendor'
});

var groupField=new Ext.ux.StkGrpComboBox({ 
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:locId,
	UserId:userId,
	anchor:'90%'
}); 

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%',
	params : {LocId : 'locField',ScgId : 'groupField'}
});

var pNameField = new Ext.form.TextField({
	id:'pName',
	fieldLabel:'��Ʒ����',
	allowBlank:true,
	width:180,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//�������ʴ���
				var group = Ext.getCmp("groupField").getValue();
				//GetPhaOrderInfo(field.getValue(),group);
			
				var inputVen=field.getValue();
				var Locdr=Ext.getCmp('locField').getValue();
				var NotUseFlag='N';
				var QtyFlag=1;
				var ReqLoc='';
				var Vendor=Ext.getCmp('Vendor').getValue();
				var VendorName=Ext.getCmp('Vendor').getRawValue();
				VendorItmBatWindow(inputVen, group, App_StkTypeCode, Locdr,Vendor,VendorName, NotUseFlag, QtyFlag, HospId, ReqLoc, AddList);
			}
		}	
	}
});

var HVBarCodeEditor = new Ext.form.TextField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var row=IngDretDetailGrid.getSelectionModel().getSelectedCell()[0];
				var findHVIndex=IngDretDetailGridDs.findExact('HVBarCode',Barcode,0);
				if(findHVIndex>=0 && findHVIndex!=row){
					Msg.info("warning","�����ظ�¼��!");
					return;
				}
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7];
							var scgID=itmArr[8],scgDesc=itmArr[9],ingri=itmArr[10];
							if(status!="Enable"){
								Msg.info("warning","�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!");
								IngDretDetailGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(Ext.getCmp("groupField").getValue()!=scgID){
								Msg.info("warning","����"+Barcode+"����"+scgDesc+"����,�뵱ǰ����!");
								IngDretDetailGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(ingri==""){
								Msg.info("warning","��������δ�������,�����˻�!");
								return;
							}else if(lastDetailAudit!="Y"){
								Msg.info("warning","�ø�ֵ������δ��˵�"+lastDetailOperNo+",���ʵ!");
								return;
							}else if(type=="T"){
								Msg.info("warning","�ø�ֵ�����Ѿ�����,�����Ƶ�!");
								return;
							}
							var phaLoc = Ext.getCmp("locField").getValue();
							var vendor = Ext.getCmp("Vendor").getValue();
							var zeroFlag = '0';
							var strPar = phaLoc+"^"+inciDr+"^"+vendor+"^"+zeroFlag+"^"+ingri+"^"+inclb;
							var url = "dhcstm.ingdretaction.csp?actiontype=selectBatch&strPar="+strPar+"&start=0&limit=1";
							var result=ExecuteDBSynAccess(url);
							var info=Ext.util.JSON.decode(result);
							var inforesults=info.results;
							if(inforesults=='0'){
								Msg.info("warning","�������Ӧ���Ϊ�㣬�����˻�!");
								return;
							}
							var inforows=info.rows[0];
							var InfoRecord=new Ext.data.Record(inforows);
							AddList(InfoRecord);
						}else{
							Msg.info("warning","��������δע��!");
							return;
						}
					}
				});
			}
		}
	}
});

var transOrder = new Ext.form.Checkbox({
	id: 'transOrder',
	fieldLabel:'���ۻ�Ʊ',
	anchor:'90%',
	allowBlank:true
});

//"���"��־
var complete = new Ext.form.Checkbox({
	id: 'complete',
	fieldLabel:'���',
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%'
});

//"���"��־
var auditChk = new Ext.form.Checkbox({
	id: 'audited',
	fieldLabel:'���',
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%'
});

var noViewZeroItem = new Ext.form.Checkbox({
	id: 'noViewZeroItem',
	fieldLabel:'����ʾ���Ϊ�����',
	allowBlank:true,
	checked:true
});

var noViewZeroVendor = new Ext.form.Checkbox({
	id: 'noViewZeroVendor',
	fieldLabel:'����ʾ���Ϊ��Ĺ�Ӧ��',
	allowBlank:true
});

ReasonForReturnStore.load();
var newBT = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'�½��˻���',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		//addDetailRow();
		if (Ext.getCmp('groupField').getValue()==''){
		    Msg.info('error','��ѡ������!');
		    return;
	          }
		NewRet()
	}
});

var clearBT = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function() {
		if (isDataChanged(formPanel,IngDretDetailGrid)){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearData();
						SetFormOriginal(formPanel);
					}
				}
			})
		}else{
			clearData(); 
			SetFormOriginal(formPanel);
		}
	}
});

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if (Ext.getCmp('groupField').getValue()==''){
		    Msg.info('error','��ѡ������!');
		    return;
	          }
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		DeleteDetail();
	}
});

var GridColSetBT = new Ext.Toolbar.Button({
	text:'������',
	tooltip:'������',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		GridColSet(IngDretDetailGrid,"DHCSTRETURNM");
	}
});

// ��ҳ���� 
var NumAmount = new Ext.form.TextField({
	emptyText : '��ҳ����',
	id : 'NumAmount',
	name : 'NumAmount',
	anchor : '90%',
	width:200
});	

// ���ۺϼ�
var RpAmount = new Ext.form.TextField({
	emptyText : '���ۺϼ�',
	id : 'RpAmount',
	name : 'RpAmount',
	anchor : '90%',
	width : 200
});

// �ۼۺϼ�
var SpAmount = new Ext.form.TextField({
	emptyText : '�ۼۺϼ�',
	id : 'SpAmount',
	name : 'SpAmount',
	anchor : '90%',
	width : 200
});

//�ϼ�
function GetAmount(){
	var rpAmt=0,spAmt=0;
	var Count = IngDretDetailGrid.getStore().getCount();
	for(var i=0; i<Count; i++){
		var rowData = IngDretDetailGridDs.getAt(i);
		var qty = Number(rowData.get("qty"));
		var Rp = Number(rowData.get("rp"));
		var Sp = Number(rowData.get("sp"));
		var rpAmt1=Rp.mul(qty);
		var spAmt1=Sp.mul(qty);
		rpAmt=rpAmt.add(rpAmt1);
		spAmt=spAmt.add(spAmt1);
	}
	var	rpAmt=rpAmt.toFixed(2);
	var	spAmt=spAmt.toFixed(2);
	Count="��ǰ����:"+" "+Count;
	rpAmt="�˻����ۺϼ�:"+" "+rpAmt+" "+"Ԫ";
	spAmt="�˻��ۼۺϼ�:"+" "+spAmt+" "+"Ԫ";
	Ext.getCmp("NumAmount").setValue(Count);
	Ext.getCmp("RpAmount").setValue(rpAmt);
	Ext.getCmp("SpAmount").setValue(spAmt);
}
var findIngDret = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if(Ext.getCmp("locField").getValue()==""){
			Msg.info("warning","�˻����Ҳ���Ϊ��!");
			return;
		}
		findIngDret();
	}
});

var completeBT = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		Complete();
	}
});

var cancelCompleteBT = new Ext.Toolbar.Button({
	text:'ȡ�����',
	tooltip:'ȡ�����',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		cancelComplete();
	}
});

// ��ӡ�˻���
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : '��ӡ',
	tooltip : '��ӡ�˻���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintIngDret(gIngrt);
	}
});

var saveIngDret = new Ext.ux.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	disabled:true,
	height : 30,
	handler:function(){
		//1.����������Ϣ
		var retNo = Ext.getCmp('dret').getValue();
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","��ѡ������!");
			return false;
		}
		var vendorId=Ext.getCmp("Vendor").getValue();
		if((vendorId=="")||(vendorId==null)){
			Msg.info("error","��ѡ��Ӧ��!");
			return false;
		}
		var locId=Ext.getCmp("locField").getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����!");
			return false;
		}
		var stkType = "";
		var adjChequeFlag = (Ext.getCmp('transOrder').getValue()==true?'Y':'N');
		var mainInfo=locId+"^"+vendorId+"^"+userId+"^"+scg+"^"+adjChequeFlag;
		
		if(IngDretDetailGrid.activeEditor != null){
			IngDretDetailGrid.activeEditor.completeEdit();
		}
		var rows = "";
		var count = IngDretDetailGridDs.getCount();		
		if(!count>0){Msg.info('error','û����Ҫ���������!') ;return}
		for(var index=0;index<count;index++){
			var row = IngDretDetailGridDs.getAt(index);
			//���������ݷ����仯ʱִ����������
			if(row.data.newRecord || row.dirty){	
				var ingrti = row.get('ingrti'); 	//�˻��ӱ�rowid(DHC_INGRtItm)
				var ingri = row.get('ingri'); 		//����ӱ�rowid(DHC_INGdRecItm)
				if(ingri==null || ingri==""){
					continue;
				}
				var qty = row.get('qty'); 			//����
				if((ingri!="")&&(qty==null || qty==""||qty<0)){
					Msg.info("warning","��"+(index+1)+"���˻�����Ϊ�ջ���С��0!");
					return;
				}
				var uomId = row.get('uom'); 		//��λ
				var rp = row.get('rp'); 			//����
				var rpAmt = row.get('rpAmt'); 		//���۽��
				var sp = row.get('sp'); 			//�ۼ�
				var spAmt = row.get('spAmt'); //�ۼ۽��
				var oldSp = row.get('oldSp'); //�����ۼ�
				var oldSpAmt = row.get('oldSpAmt'); //�����ۼ۽��
				var invNo = row.get('invNo'); //��Ʊ��
				var invDate = row.get('invDate'); //��Ʊ����
				if((invDate!="")&&(invDate!=null)){
					invDate = invDate.format(ARG_DATEFORMAT);
				}else{
					invDate="";
				}
				var invAmt = row.get('invAmt'); //��Ʊ���
				var sxNo = row.get('sxNo'); //���е���
				if(sxNo==null){
					sxNo = "";
				}
				var reason = row.get('reasonId'); //�˻�ԭ��
				if((ingri!="")&&(reason==null || reason=="")&&(gParam[8]!="Y")){
					Msg.info("warning","��"+(index+1)+"���˻�ԭ��Ϊ��!");
					return;
				}
				var aspa = row.get('aspAmt'); //�˻����۽��
				var HVBarCode = row.get('HVBarCode')
				var Remark = row.get('Remark')
				var SpecDesc = row.get('SpecDesc')
				//
				//�˻���ϸid^�����ϸid^����^��λ^����^�ۼ�^��Ʊ��^��Ʊ����^��Ʊ���^���е�^�˻�ԭ��
				var data =  ingrti+"^"+ingri+"^"+qty+"^"+uomId+"^"+rp+"^"+sp+"^"+invNo+"^"+invDate+"^"+invAmt+"^"+sxNo+"^"+reason+"^"+HVBarCode+"^"+Remark+"^"+SpecDesc;
				if(rows!=""){
					rows = rows+xRowDelim()+data;
				}else{
					rows = data;
				}
			}
		}
		
		if(rows=="" && !IsFormChanged(formPanel)){Msg.info('error','û����Ҫ���������!');return}
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url: URL+'?actiontype=save',
			params:{ret:gIngrt,MainData:mainInfo,Detail:rows},
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					gIngrt =  jsonData.info; //�˻�������Id					
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
					if(gParam[5] == 'Y'){
						PrintIngDret.defer(300,this,[gIngrt, 'Y']);
					}
				}else{
					var ret=jsonData.info;
					if(ret=='-10'){
						Msg.info("warning","���ÿ�治�����˻�!");
					}else if(ret=='-3'){
						Msg.info("warning","�����˻�����ʧ��!");
					}else if(ret=='-4'){
						Msg.info("warning","�����˻���ʧ��!");
					}else if(ret=='-6'){
						Msg.info("warning","�����˻���ϸʧ��!");
					}else{
						Msg.info("error","����ʧ��:"+ret);
					}
				}
				loadMask.hide();
			},
			scope: this
		});
	}
});

var deleteIngDret = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(gIngrt==null || gIngrt==""){
			Msg.info("error","û��Ҫɾ�����˻���!");
			return false;
		}else{
			if (Ext.getCmp('complete').getValue()==true)
			{
				Msg.info("warning","�Ѿ����,��ֹɾ��!");
				return;
			}
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ�����˻���?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=delete&Ingrt='+gIngrt,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error","������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","ɾ���ɹ�!");
									clearData();
								}else{
									Msg.info("error","ɾ��ʧ��!");
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

////ɾ��һ����ϸ��¼
function DeleteDetail(){
	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true)){
		Msg.info('warning','��ǰ�˻��������,��ֹɾ����ϸ��¼!');
		return;
	}
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	if (!cell) {
		Msg.info("warning",'��ѡ����ϸ��¼!');
		return;
	}
	var rowindex=cell[0];
	if(rowindex==null){
		Msg.info("error","��ѡ������!");
		return false;
	}else{
		var record = IngDretDetailGrid.getStore().getAt(rowindex);
		var RowId = record.get("ingrti");
		if(RowId!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						
						Ext.Ajax.request({
							
							url:URL+'?actiontype=deleteDetail&rowid='+RowId,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error","������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","ɾ���ɹ�!");
									if (IngDretDetailGrid.getStore().getCount()==0)
									{
										setEditEnable();
									}
									IngDretDetailGridDs.load({params:{start:0,limit:20,sort:'ingrti',dir:'desc',ret:gIngrt}});
								}else{
									Msg.info("error","ɾ��ʧ��!");
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			IngDretDetailGrid.getStore().remove(record);
			IngDretDetailGrid.getView().refresh();
			if (IngDretDetailGrid.getStore().getCount()==0)
			{
				setEditEnable();
			}
		}
	}
}

var Cause2 = new Ext.form.ComboBox({
	fieldLabel : '�˻�ԭ��',
	id : 'Cause2',
	name : 'Cause2',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '�˻�ԭ��...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
				var row = IngDretDetailGridDs.getAt(cell[0]);
				//row.set('retReason',field.getRawValue());
				//row.set('retReasonId',field.getValue());
				
				//var col=GetColIndex(IngDretDetailGrid,"invNo");
				//IngDretDetailGrid.startEditing(cell[0],col);
				addDetailRow();
			}
		}
	}
});		

//��������Դ
var IngDretDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'GET'});
var IngDretDetailGridDs = new Ext.data.Store({
	proxy:IngDretDetailGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'ingrti'},
		{name:'ingri'},
		{name:'manf'},
		{name:'inclb'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:DateFormat},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'reasonId'},
		{name:'retReason'},
		{name:'stkqty'},
		{name:'buom'},
		{name:'confac'},
		{name:'HVFlag'},
		{name:'HVBarCode'},
		{name:'Remark'},
		{name:'SpecDesc'}
	]),
	remoteSort:false
});

// ��λ
var CTUom = new Ext.form.ComboBox({
	//fieldLabel : '��λ',
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
	listWidth : 250	,
	valueNotFoundText : ''
});

CTUom.on('beforequery', function(combo) {
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	var InciDr = inclb.split("||")[0];
	CTUom.store.setBaseParam('ItmRowid',InciDr);
	CTUom.store.removeAll();
	CTUom.store.load();
});

/**
 * ��λ�任�¼�
 */
CTUom.on('select', function(combo) {
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);
	
	var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //��λ��С��λ��ת����ϵ		
	var Uom = record.get("uom");    //Ŀǰ��ʾ���˻���λ
	var BatStkQty=record.get("stkqty");
	var NewStkQty=BatStkQty;
	if(value!=Uom){
		if(value==BUom){
			NewStkQty=BatStkQty*ConFac;
		}else{
			NewStkQty=BatStkQty/ConFac;
		}
		record.set("stkqty",NewStkQty)
	}
	var ingri=record.get("ingri");
	record.set("uom", combo.getValue());
	var Uom=record.get("uom");
	SetIngriPrice(record,ingri,Uom);
});

//ģ��
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"�˻��ӱ�rowid",
		dataIndex:'ingrti',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"����ӱ�rowid",
		dataIndex:'ingri',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"����DR",
		dataIndex:'inclb',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"���ʴ���",
		dataIndex:'code',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'desc',
		id:'desc',
		width:200,
		align:'left',
		sortable:true,
		editor:pNameField
	},{
		header:"��ֵ��־",
		dataIndex:'HVFlag',
		width:60,
		align:'center',
		sortable:true,
		hidden:true
	},{
		header:"��ֵ����",
		dataIndex:'HVBarCode',
		id:'HVBarCode',
		width:200,
		align:'left',
		sortable:true,
		editable : false,
		hidden:true,		//!UseItmTrack
		editor:HVBarCodeEditor
	},{
		header:"����",
		dataIndex:'manf',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"���",
		dataIndex:'spec',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"���ο��",
		dataIndex:'stkqty',
		width:100,
		align:'left',
		sortable:true    	
	},{
		header:"�˻�����",
		dataIndex:'qty',
		width:100,
		id:'qty',
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'dretQtyField',
			allowBlank:true,
			allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var row = IngDretDetailGridDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
						var count = field.getValue();
						if(count>row.get("stkqty")||count<0){
							field.setValue("");
							Msg.info("error","�˻��������ܴ��ڿ����������С��0!");
						}else{
							var col=GetColIndex(IngDretDetailGrid,"reasonId");
							IngDretDetailGrid.startEditing(cell[0],col);
							//row.set("invAmt", count*row.get("rp")); 
						}
					}
				}
			}
		})
	},{
		header:"�˻���λ",
		dataIndex:'uom',
		id:'uom',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
		editor : new Ext.grid.GridEditor(CTUom),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(IngDretDetailGrid,"uom");
					IngDretDetailGrid.startEditing(cell[0], colIndex);									
				}
			}
		}
	},{
		header:"�˻�ԭ��",
		dataIndex:'reasonId',
		width:100,
		id:'reasonId',
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(Cause2),
		renderer:Ext.util.Format.comboRenderer2(Cause2,"reasonId","retReason")
	},{
		header:"�˻�����",
		dataIndex:'rp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�˻����۽��",
		dataIndex:'rpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�ۼ�",
		dataIndex:'sp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�˻��ۼ۽��",
		dataIndex:'spAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"����",
		dataIndex:'batNo',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"Ч��",
		dataIndex:'expDate',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��Ʊ��",
		dataIndex:'invNo',
		id:'invNo',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'invNoField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						var colindex=GetColIndex(IngDretDetailGrid,"invDate");
						IngDretDetailGrid.startEditing(cell[0],colindex);
					}
				}
			}
		})
	},{
		header:"��Ʊ����",
		dataIndex:'invDate',
		id:'invDate',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			id:'invDateField2',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						var row = IngDretDetailGridDs.getAt(cell[0]);	
						var colindex=GetColIndex(IngDretDetailGrid,"invAmt");
						IngDretDetailGrid.startEditing(cell[0],colindex);	
					}
				}
			}
		})
	},{
		header:"�˷�Ʊ���",
		dataIndex:'invAmt',
		id:'invAmt',
		width:100,
		align:'right',
		sortable:true,
		editor: new Ext.ux.NumberField({
			formatType : 'FmtRA',
			id:'invAmtField2',
			allowBlank:true
		})
	},{
		header:"���е���",
		dataIndex:'sxNo',
		id:'sxNo',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
			allowBlank:true
		})
	},{
		header:"��ע",
		dataIndex:'Remark',
		id:'Remark',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({})
	},{
		header:"������",
		dataIndex:'SpecDesc',
		width:100,
		align:'left',
		sortable:true
	}
]);

//��ʼ��Ĭ��������
IngDretDetailGridCm.defaultSortable = true;

//���
var IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	region: 'center',
	title:'��ϸ��¼',
	store:IngDretDetailGridDs,
	id:'IngDretDetailGrid',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	clicksToEdit:1,
	bbar: new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]}),
	listeners:{
		'beforeedit':function(e){
			if(Ext.getCmp('complete').getValue()){
				return false;
			}
			if(e.field=='qty'){
				if(UseItmTrack && e.record.get('HVFlag')=='Y'){
					e.cancel=true;
				}
			}
			if(e.field=="HVBarCode"){
				if(!UseItmTrack || e.record.get("HVFlag")=='N' || (e.record.get("ingrti")!="" && e.record.get("HVBarCode")!="")){
					e.cancel=true;
				}else{
					if(UseItmTrack && e.record.get("HVFlag")=="Y"){
						e.cancel=true;
					}
				}
			}
			if(e.field=="desc" && e.record.get("HVBarCode")!=""){
				e.cancel=true;
			}
		},
		'afteredit':function(e){
			if(e.field=='qty'){
				if(e.record.get("qty")>e.record.get("stkqty")){
					Msg.info("error","�˻��������ܴ��ڿ������!");
					e.record.set("qty","");
				}else{
					e.record.set("rpAmt", accMul(e.value,e.record.get("rp"))); 
					e.record.set("spAmt", accMul(e.value,e.record.get("sp")));
					e.record.set("invAmt",accMul(e.value,e.record.get("rp")))
				}
			}
		},
		'rowcontextmenu' : rightClickFn
	}
});

IngDretDetailGrid.getView().on('refresh',function(grid){
	GetAmount();
});
var rightMenu=new Ext.menu.Menu({
	id:"rightClickMenu",
	items:[{
		id:"mnuDelete",
		text:"ɾ��",
		handler:DeleteDetail
	}]
});

function rightClickFn(grid,rowindex,e){
	grid.getSelectionModel().select(rowindex,0);
	e.preventDefault();
	rightMenu.showAt(e.getXY());
}

var formPanel = new Ext.ux.FormPanel({
	title: '�˻��Ƶ�',
	tbar : [newBT,'-',findIngDret,'-',saveIngDret,'-',completeBT,'-',cancelCompleteBT,'-',deleteIngDret,'-',clearBT,'-',printBT],
	items:[{
		xtype:'fieldset',
		title:'�˻�����Ϣ',
		style:'padding 0px 0px 0px 5px',
		layout: 'column',
		items : [{
			columnWidth: 0.25,
			layout:'form',
			items: [locField,groupField]
		},{
			columnWidth: 0.25,
			layout:'form',
			items: [Vendor,dretField]
		},{
			columnWidth: 0.20,
			layout:'form',
			items: [dateField]
		},{
			columnWidth: 0.15,
			layout:'form',
			items: [complete,transOrder]
		},{
			columnWidth: 0.15,
			layout:'form',
			items:[auditChk]
		}]
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IngDretDetailGrid],
		renderTo:'mainPanel'
	});
	
	RefreshGridColSet(IngDretDetailGrid,"DHCSTRETURNM");   //�����Զ�������������������
	
	if(gIngrt != ''){
		Select(gIngrt);
		IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'',dir:'',ret:gIngrt}});
	}
});

function addDetailRow() {
	GetAmount();
	if(IngDretDetailGrid.activeEditor!=null){IngDretDetailGrid.activeEditor.completeEdit();}
	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true))
	{
		Msg.info('warning','��ǰ�˻��������,��ֹ������ϸ��¼!');
		return;
	}	
	var rowCount =IngDretDetailGrid.getStore().getCount();
	/*if(rowCount==0 || IngDretDetailGridDs.data.items[rowCount - 1].get('inclb')!=''){
		var NewRec = CreateRecordInstance(IngDretDetailGridDs.fields);
		IngDretDetailGridDs.add(NewRec);
	}*/
	var colIndex=GetColIndex(IngDretDetailGrid,"desc");
	var reasonId="";
	var retReason="";
	if(rowCount>0){
		if(IngDretDetailGridDs.data.items[rowCount - 1].get('inclb')==''){
		    IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, colIndex);
			return;
		}
		var rowData = IngDretDetailGridDs.data.items[rowCount - 1];
		//�˻�ԭ��
		if(gParam[7]=="Y"){
			reasonId=rowData.get("reasonId");
			retReason=rowData.get("retReason");
		}
	}
	var defaData={"reasonId":reasonId,"retReason":retReason}
	var NewRecord = CreateRecordInstance(IngDretDetailGridDs.fields,defaData)
	IngDretDetailGridDs.add(NewRecord);
	IngDretDetailGrid.getSelectionModel().select(IngDretDetailGridDs.getCount() - 1, colIndex);
	IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, colIndex);
	setEditDisable();
	if (IngDretDetailGrid.getStore().getCount()>1){Ext.getCmp('Vendor').setDisabled(true);}
}

//�����˻��б�
function AddList(row){
	if(row==null || row==""){
		return;
	}
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var rowIndex=cell[0];
	var rowData = IngDretDetailGridDs.getAt(rowIndex);
	var HVBarCode=IngDretDetailGrid.store.getAt(rowIndex).get('HVBarCode');
	if(UseItmTrack && row.get('HVFlag')=='Y' && HVBarCode==""){
		Msg.info("warning","��ֵ����,���������¼��!");
		var colIndex=GetColIndex(IngDretDetailGrid,"HVBarCode");
		IngDretDetailGrid.startEditing(rowIndex,colIndex);
		return;
	}
	var INGRI = row.get('INGRI');
	var INCLB = row.get('INCLB');
	var code = row.get('code');
	var desc = row.get('desc');
	var mnf = row.get('mnf');
	var batch = row.get('batch');
	var sven = row.get('sven');
	var venid=row.get('venid');
	var pp = row.get('pp');
	var expdate = row.get('expdate');
	var uom = row.get('uom');
	var uomDesc = row.get('uomDesc');
	var idate = row.get('idate');
	var invDate = row.get('invDate');
	var recqty = row.get('recqty');
	if(recqty<0){
		Msg.info("warning","������ϸ����Ѻ��!!");
		return ;
		}
	var stkqty = row.get('stkqty');
	var rp = row.get('rp');
	var sp = row.get('sp');
	var invNo = row.get('invNo');
	var sxNo = row.get('sxNo');
	var cause = row.get('causeName');
	var causeId = row.get('causeId');
	var Drugform = row.get('Drugform');
	var spec = row.get('Spec');
	var buom=row.get('buom');
	var confac=row.get('confac');
	var HVFlag=row.get('HVFlag');
	var SpecDesc=row.get('SpecDesc');
	
	puomRp=rp;
	puomSp=sp;
	buomRp=puomRp/confac;
	buomSp=puomSp/confac;
	
	if(stkqty<=0){
		Msg.info("warning","����Ŀ���Ϊ�㣬�����˻�!");
		return;
	}
	var selectVenid=Ext.getCmp("Vendor").getValue();
	if(selectVenid!=null & selectVenid!=""){
		if(selectVenid!=venid){    
			Msg.info("warning","����Ŀ��Ӧ�̲�������ѡ����Ŀ�Ĺ�Ӧ�̣�������ͬһ���˻������˻�");
			return;
		}
	}else{
		addComboData(Vendor.getStore(),venid,sven);
		Ext.getCmp("Vendor").setValue(venid);
		Ext.getCmp('Vendor').setDisabled(true);
	}
	
	if(!(UseItmTrack && HVFlag=='Y')){
		var findIndex=IngDretDetailGridDs.findExact('ingri',INGRI,0);
		if(findIndex>=0 && findIndex!=rowIndex){
			Msg.info("warning","�������ϸ�����Ѿ��������˻��б�")
			return;
		}
	}
	
	rowData.set('code',code);
	rowData.set('desc',desc);
	rowData.set('ingri',INGRI);
	rowData.set('inclb',INCLB);
	rowData.set('sp',sp);
	rowData.set('rp',rp);
	rowData.set('batNo',batch);
	rowData.set('expDate',expdate);
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set('uom',uom);
	rowData.set('uomDesc',uomDesc);
	rowData.set('spec',spec);
	rowData.set('manf',mnf);
	rowData.set('stkqty',stkqty);
	rowData.set('buom',buom);
	rowData.set('confac',confac);
	rowData.set('HVFlag',HVFlag);
	rowData.set('SpecDesc',SpecDesc);
	
	if(UseItmTrack && HVFlag=='Y'){
		rowData.set('qty',1);
		rowData.set("rpAmt", row.get("rp")); 
		rowData.set("spAmt", row.get("sp")); 
		rowData.set("invAmt", row.get("rp"));
		var colIndex=GetColIndex(IngDretDetailGrid,"reasonId");
		IngDretDetailGrid.startEditing(rowIndex,colIndex);
	}else{
		var colIndex=GetColIndex(IngDretDetailGrid,"qty");
		IngDretDetailGrid.startEditing(rowIndex,colIndex);
	}
	saveIngDret.enable();
	
	if (IngDretDetailGrid.getStore().getCount()>0){
		Ext.getCmp('Vendor').setDisabled(true);
	}
}
//�½��˻���
function NewRet()
{
	clearData();
	saveIngDret.disable ();
	addDetailRow();
}

//���ҳ��
function clearData(){
	gIngrt="";
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("dret").setValue("");
	Ext.getCmp("complete").setValue(false);
	Ext.getCmp("transOrder").setValue(false);
	Ext.getCmp("audited").setValue(false);
	Ext.getCmp("dateField").setValue(new Date());
	IngDretDetailGridDs.removeAll();
	
	setEditEnable();
	//������ܴ���href����
	CheckLocationHref();
}


/*�˻������*/
function Complete() {
	if((gIngrt!="")&&(gIngrt!=null)){
		Ext.Ajax.request({
			url:URL+'?actiontype=complet&ret='+gIngrt,
			waitMsg:'ִ����...',
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","������ɳɹ�!");
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'',dir:'',ret:gIngrt}});
				}else{
					Msg.info("error","�������ʧ��!"+jsonData.info);
				}
			},
			scope: this
		});
	}
}

/*ȡ�����*/
function cancelComplete() {
	if((gIngrt!="")&&(gIngrt!=null)){
		Ext.Ajax.request({
			url:URL+'?actiontype=cancelComompleted&ret='+gIngrt,
			waitMsg:'ִ����......',
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","ȡ����ɳɹ�!");
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
				}else{
					switch (jsonData.info)
					{
					case '-1':
						Msg.info("warning","�˻���������!");
						break;
					case '-10':
						Msg.info("warning","�˻����Ѿ����,��ֹȡ�����!");
						break;
					case '-2':
						Msg.info("warning","�˻���δ���!");
						break;
					case '-99':
						Msg.info("error","����ʧ��!");
						break;
					default:
						Msg.info("error","ȡ�����ʧ��!"+jsonData.info);
						break;
					}
				}
			},
			scope: this
		});
	}
}
function Select(Ingrt)
{
	if((Ingrt==null)||(Ingrt=="")){
		return;
	}
	gIngrt=Ingrt;
	Ext.Ajax.request({
		url:URL+'?actiontype=getOrder&rowid='+Ingrt,
		waitMsg:'��ѯ��...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				Ext.getCmp('dret').setValue(arrData[6]);
				
				addComboData(Vendor.getStore(),arrData[1],arrData[20]);
				Ext.getCmp('Vendor').setValue(arrData[1]);
				addComboData(locField.getStore(),arrData[7],arrData[21]);
				Ext.getCmp("locField").setValue(arrData[7]);
				var compFlag=(arrData[4]=='Y'?true:false);
				Ext.getCmp("complete").setValue(compFlag);
				var adjchqFlag=(arrData[11]=='Y'?true:false);
				Ext.getCmp("transOrder").setValue(adjchqFlag);
				addComboData(null,arrData[14],arrData[24],groupField);
				Ext.getCmp('groupField').setValue(arrData[14]);
				
				var audited=(arrData[15]=='Y'?true:false);  //�����
				Ext.getCmp("audited").setValue(audited);
				var ingrdate=arrData[22];
				Ext.getCmp("dateField").setValue(ingrdate);
				//alert(compFlag);
				if(compFlag==true){
					saveIngDret.setDisabled(true);
					completeBT.setDisabled(true);
					//newBT.setDisabled(true);
				}else{
					saveIngDret.setDisabled(false);
					completeBT.setDisabled(false);
					//newBT.setDisabled(false);
				}
			}
		
			setEditDisable();
			Ext.getCmp('Vendor').setDisabled(true);
		},	
		scope: this
	});
	
}

//ȡ��ָ����λ�����۸񣨽���+�ۼۣ�
//ingri - �����ϸrowid
//uom - ��λrowid
function SetIngriPrice(rec,ingri,uom){
	Ext.Ajax.request({
		url:URL+'?actiontype=getIngriPrice'+"&ingri="+ingri+"&uom="+uom,
		failure:function(){
			Msg.info("error","ʧ��!");
		},
		success:function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				var rp=arrData[0];
				var sp=arrData[1];
				rec.set('rp',rp);
				rec.set('sp',sp);
				var qty=rec.get('qty');
				var rpAmt=accMul(rp,qty);
				var spAmt=accMul(sp,qty);
				rec.set('rpAmt',rpAmt);
				rec.set('spAmt',spAmt);
				rec.set('invAmt',rpAmt);
			}
		}
	})
}

//���ÿɱ༭�����disabled����
function setEditDisable(){
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('locField').setDisabled(true);
}
//�ſ��ɱ༭�����disabled����
function setEditEnable(){
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('locField').setDisabled(false);
	Ext.getCmp('Vendor').setDisabled(false);
}