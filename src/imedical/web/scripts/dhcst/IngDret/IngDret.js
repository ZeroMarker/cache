// /����: �˻����Ƶ�
// /����: �˻����Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.31
var colArr=[];
var IncId="";
var URL = 'dhcst.ingdretaction.csp';
var vendorId="";
var vendorName = "";
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var PurPlanParam = PHA_COM.ParamProp("DHCSTPURPLANAUDIT")
var ReturnParam  = PHA_COM.ParamProp("DHCSTRETURN")

//var arr = window.status.split(":");
//var length = arr.length;
var gIngrt= "";   //�˻�����id
var Msg_LostModified=$g('������¼����޸ģ��㵱ǰ�Ĳ�������ʧ��Щ������Ƿ����?');
 
var buomRp="";   //������λ����
var buomSp=""; //������λ�ۼ�
var puomRp="" ; //��ⵥλ����
var puomSp="" ; //��ⵥλ�ۼ�
if(gParam.length<1){
    GetParam();  //��ʼ����������
}
if(gParamCommon.length<1){
	GetParamCommon();  //��ʼ�������������� wyx ��������ȡ��������gParamCommon[9]

}
var dateField = new Ext.form.DateField({
	id:'dateField',
	listWidth:150,
    allowBlank:false,
	fieldLabel:$g('����'),
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var dretField = new Ext.form.TextField({
	id:'dret',
	fieldLabel:$g('�˻�����'),
	allowBlank:true,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('�˻�����'),
	emptyText:$g('�˻�����...'),
	anchor:'90%',
	groupId:groupId,
	listeners : {
		'select' : function(e) {
                      var SelLocId=Ext.getCmp('locField').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                      groupField.getStore().removeAll();
                      groupField.getStore().setBaseParam("locId",SelLocId)
                      groupField.getStore().setBaseParam("userId",UserId)
                      groupField.getStore().setBaseParam("type",App_StkTypeCode)
                      groupField.getStore().load();
		}
	}
});
	
var groupField=new Ext.ux.StkGrpComboBox({ 
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:locId,
	UserId:userId,
	anchor:'90%'
	
}); 
//=========ͳ�����=======		
		// ��ҳ����
		var NumAmount = new Ext.form.TextField({
					emptyText : $g('��ҳ����'),
					id : 'NumAmount',
					name : 'NumAmount',
					anchor : '90%',
					width:200
				});	
		// ���ۺϼ�
		var RpAmount = new Ext.form.TextField({
					emptyText : $g('���ۺϼ�'),
					id : 'RpAmount',
					name : 'RpAmount',
					width:200,
					anchor : '90%'
				});			
		// �ۼۺϼ�
		var SpAmount = new Ext.form.TextField({
					emptyText : $g('�ۼۺϼ�'),
					id : 'SpAmount',
					name : 'SpAmount',
					anchor : '90%',
					width:200
				});
		//zhangxiao20130815			
		function GetAmount(){
			var RpAmt=0
			var SpAmt=0
			var Count = IngDretDetailGrid.getStore().getCount();
			for (var i = 0; i < Count; i++) {
				var rowData = IngDretDetailGridDs.getAt(i);
				var RecQty = rowData.get("qty");
				var Rp = rowData.get("rp");
				var Sp = rowData.get("sp");
				var RpAmt1=Rp*RecQty;
				var SpAmt1=Sp*RecQty;
			    RpAmt=RpAmt+RpAmt1;
			    SpAmt=SpAmt+SpAmt1;
				}
			Count=$g("��ǰ����:")+" "+Count	
			RpAmt=$g("���ۺϼ�:")+" "+ FormatGridRpAmount(RpAmt)+" "+$g("Ԫ")
			SpAmt=$g("�ۼۺϼ�:")+" "+ FormatGridSpAmount(SpAmt)+" "+$g("Ԫ")
			Ext.getCmp("NumAmount").setValue(Count)	
			Ext.getCmp("RpAmount").setValue(RpAmt)	
			Ext.getCmp("SpAmount").setValue(SpAmt)
			}		
//=========ͳ�����=======
var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('��Ӫ��ҵ'),
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%',
	width : 140
});

var pNameField = new Ext.form.TextField({
	id:'pName',
	fieldLabel:$g('����'),
	allowBlank:true,
	width:180,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//����ҩƷ����
				var group = Ext.getCmp("groupField").getValue();
				//GetPhaOrderInfo(field.getValue(),group);
			
				var inputVen=field.getValue();
				var Locdr=Ext.getCmp('locField').getValue();
				var NotUseFlag='N';
				var QtyFlag='N';
				var ReqLoc='';
				var Vendor=Ext.getCmp('Vendor').getValue();
				var VendorName=Ext.getCmp('Vendor').getRawValue();
				VendorItmBatWindow(inputVen, group, App_StkTypeCode, Locdr,Vendor,VendorName, NotUseFlag,	QtyFlag, HospId, ReqLoc,handleSelectedIngri);
			}
		}	
	}
});

var transOrder = new Ext.form.Checkbox({
	id: 'transOrder',
	boxLabel:$g('���ۻ�Ʊ'),
	anchor:'90%',
	allowBlank:true
});

//"���"��־
var complete = new Ext.form.Checkbox({
	id: 'complete',
	boxLabel:$g('���'),
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%',
	listeners:{
		'check':function(chk,v){
			var grid=Ext.getCmp('IngDretDetailGrid');
			setGridEditable(grid,!v)
		}
	}
});

//"���"��־
var auditChk = new Ext.form.Checkbox({
	id: 'audited',
	boxLabel:$g('���'),
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%'
});

var noViewZeroItem = new Ext.form.Checkbox({
	id: 'noViewZeroItem',
	fieldLabel:$g('����ʾ���Ϊ�����'),
	allowBlank:true,
	checked:true
});

var noViewZeroVendor = new Ext.form.Checkbox({
	id: 'noViewZeroVendor',
	fieldLabel:$g('����ʾ���Ϊ��ľ�Ӫ��ҵ'),
	allowBlank:true
});
//=========================�˻�����=================================

ReasonForReturnStore.load();
var newBT = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½��˻���'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		//addDetailRow();
		NewRet()
	}
});


var clearBT = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler : function() {
		var compFlag=Ext.getCmp('complete').getValue();
		var mod=Modified();
		if  ( mod&&(!compFlag) ) {
			Ext.Msg.show({
			   title:$g('��ʾ'),
			   msg: Msg_LostModified,
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
			   		if (b=='yes'){clearData() ;}			   		
			   	},
	 		   //animEl: 'elId',
			   icon: Ext.MessageBox.QUESTION
			});
		}
		else
		{	clearData() ;}
	}
	
	
});
function clearData(){
	Ext.getCmp("dateField").setValue(new Date());
	Ext.getCmp("dret").setValue("");
	Ext.getCmp("complete").setValue(false);
	groupField.setDisabled(false);
	locField.setDisabled(false);
	Ext.getCmp("Vendor").setDisabled(false);
	Ext.getCmp("Vendor").setValue("")
	IngDretDetailGridDs.removeAll();
	IngDretDetailGrid.getView().refresh();
	gIngrt='';
	saveIngDret.setDisabled(false);
    completeBT.setDisabled(false);
	Ext.getCmp("transOrder").setValue(false);		
	Ext.getCmp("audited").setValue(false);
	setOriginalValue('MainForm');
}



var AddDetailBT=new Ext.Button({
	text:$g('����һ��'),
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{
		groupField.setDisabled(true);
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:$g('ɾ��һ��'),
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
		if (IngDretDetailGridDs.getCount()==0)
		{
			groupField.setDisabled(false);
			Ext.getCmp("Vendor").setDisabled(false);
		
		}

	}
});

var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('������'),
    tooltip:$g('������'),
    iconCls:'page_gear',
//	width : 70,
//	height : 30,
	handler:function(){
		GridColSet(IngDretDetailGrid,"DHCSTRETURN");
	}
});

var findIngDret = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		findIngDret();

	}
});

var completeBT = new Ext.Toolbar.Button({
	text:$g('���'),
    tooltip:$g('���'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var compFlag=Ext.getCmp('complete').getValue();
		var mod=Modified();
		if (mod&&(!compFlag)) {
			Ext.Msg.confirm($g('��ʾ'),$g('�����ѷ����ı�,�Ƿ���Ҫ��������?'),
			    function(btn){
				  if(btn=='yes'){
				     return;						
				  }else{
				     Complete();	
				  }
			 },this);
		 } else{
			Complete();
		}	
	}
});

var cancelCompleteBT = new Ext.Toolbar.Button({
	text:$g('ȡ�����'),
    tooltip:$g('ȡ�����'),
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
	text : $g('��ӡ'),
	tooltip : $g('��ӡ�˻���'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintIngDret(gIngrt);
	}
});
// ������ⵥ�˻�
var findIngBT = new Ext.Toolbar.Button({
	id : "findIngBT",
	text : $g('������ⵥ�˻�'),
	tooltip : $g('������ⵥ�˻�'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		///����ϸʱ������,�������������������
		if (IngDretDetailGridDs.getCount()>0)
		{
			Msg.info("warning",$g("�Ѵ����˻���ϸ!"));
			return;
			
		}
		FindIngInfo();
	}
});

var saveIngDret = new Ext.Toolbar.Button({
	id:"saveIngDret",
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	disabled:true,
	height : 30,
	handler:function(){
		var rowCount =IngDretDetailGridDs.getCount();
		if(rowCount==0) 
		{
			Msg.info('warning',$g('��ϸ����Ϊ�գ���˶���ϸ!'))
			return;
		} 
		//1.����������Ϣ
		var retNo = Ext.getCmp('dret').getValue();
		var scg = Ext.getCmp('groupField').getValue();
		if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
			Msg.info("error",$g("��ѡ������!"));
			return false;
		}
		var vendorId=Ext.getCmp("Vendor").getValue();
		if((vendorId=="")||(vendorId==null)){
			Msg.info("error",$g("��ѡ��Ӫ��ҵ!"));
			return false;
		}
		var locId=Ext.getCmp("locField").getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("��ѡ�����!"));
			return false;
		}
		var stkType = "";
		var adjChequeFlag = (Ext.getCmp('transOrder').getValue()==true?'Y':'N');
		var rlocid=Ext.getCmp('locField').getValue(); //ȡ�˻�����id����ȡ��¼����
		var mainInfo=rlocid+"^"+vendorId+"^"+userId+"^"+scg+"^"+adjChequeFlag;
		if (locId=='') {Msg.info('error',$g('��ѡ���˻�����!') );}
		if (vendorId=='') {Msg.info('error',$g('��ѡ���˻���Ӫ��ҵ!')) ;}
		if (userId=='') {Msg.info('error',$g('��ѡ���˻���!')) ;}
		if ((scg=='')&&(gParamCommon[9]=="N")) {Msg.info('error',$g('��ѡ������!')) ;}
		
		if(IngDretDetailGrid.activeEditor != null){
			IngDretDetailGrid.activeEditor.completeEdit();
		}
		var rows = "";
		var count = IngDretDetailGridDs.getCount();	
		if(!count>0){Msg.info('error',$g('û����Ҫ���������!')) ;return}
		for(var index=0;index<count;index++){
			var row = IngDretDetailGridDs.getAt(index);
			//���������ݷ����仯ʱִ����������
			if(row.data.newRecord || row.dirty || row.get('ingrti')==""){	
				var ingrti = row.get('ingrti'); 	//�˻��ӱ�rowid(DHC_INGRtItm)
				var ingri = row.get('ingri'); 		//����ӱ�rowid(DHC_INGdRecItm)
				var inclbrowid=row.get('inclb');
				if((inclbrowid=="")||(inclbrowid==null)){continue;}
				var qty = row.get('qty'); 			//����
				if(qty==null || qty==""||qty<=0){
					Msg.info("warning",$g("��")+(index+1)+$g("���˻�����Ϊ�ջ���С��0!"));
					var newcolIndex = GetColIndex(IngDretDetailGrid, 'qty');
                	IngDretDetailGrid.startEditing(index, newcolIndex);
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
					invDate = invDate.format(App_StkDateFormat);
				}else{
					invDate="";
				}
				if (((invNo=="")&&(invDate!=""))||((invNo!="")&&(invDate=="")))
                {
	                Msg.info("warning", $g("��")+(index+1)+$g("��,��Ʊ�źͷ�Ʊ������ͬʱ���룡"));
                    return;
                }
				var invAmt = row.get('invAmt'); //��Ʊ���
				var sxNo = row.get('sxNo'); //���е���
				if(sxNo==null){
					sxNo = "";
				}
				var reason = row.get('reasonId'); //�˻�ԭ��
				if(reason==null || reason==""){
					Msg.info("warning",$g("��")+(index+1)+$g("���˻�ԭ��Ϊ��!"));
					var newcolIndex = GetColIndex(IngDretDetailGrid, 'reasonId');
                	IngDretDetailGrid.startEditing(index, newcolIndex);
					return;
				}
				var aspa = row.get('aspAmt'); //�˻����۽��
				if(ingri==null || ingri==""){
				  continue;
				}
				//
				//�˻���ϸid^�����ϸid^����^��λ^����^�ۼ�^��Ʊ��^��Ʊ����^��Ʊ���^���е�^�˻�ԭ��
				var data =  ingrti+"^"+ingri+"^"+qty+"^"+uomId+"^"+rp+"^"+sp+"^"+invNo+"^"+invDate+"^"+invAmt+"^"+sxNo+"^"+reason;
				if(rows!=""){
					rows = rows+xRowDelim()+data;
				}else{
					rows = data;
				}
			}
		}
		//if(rows==""){Msg.info('error','û����Ҫ���������!') ;return}
		//���Ԥ������
		var ret = CheckSaveBudget(gIngrt,rows)
 		if(!ret) return;

		
		var loadMask=ShowLoadMask(Ext.getBody(),$g("������..."));
		Ext.Ajax.request({
			url: URL+'?actiontype=save',
			params:{ret:gIngrt,MainData:mainInfo,Detail:rows},
			failure: function(result, request) {
				Msg.info("error",$g("������������!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success",$g("����ɹ�!"));
					//alert(jsonData.info);
					gIngrt =  jsonData.info; //�˻�������Id
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
					SendBusiData(gIngrt,"RETURN","SAVE");
				}else{
					var ret=jsonData.info;
					if(ret=='-10'){
						Msg.info("warning",$g("���ÿ�治�����˻�!"));
					}else if(ret=='-3'){
						Msg.info("warning",$g("�����˻�����ʧ��!"));
					}else if(ret=='-4'){
						Msg.info("warning",$g("�����˻���ʧ��!"));
					}else if(ret=='-6'){
						Msg.info("warning",$g("�����˻���ϸʧ��!"));
					}else if(ret=='-8'){
						Msg.info("warning",$g("�˻��������!"));
					}else if(ret=='-9'){
						Msg.info("warning",$g("�˻��������!"));
					}else{
						Msg.info("error",$g("����ʧ��:")+ret);
					}
					
				}
				
				loadMask.hide();
			},
			scope: this
		});

    }
});


function CheckSaveBudget(gIngrt,data){
	if (_BudgetSaveFlag != "LIMIT" && _BudgetSaveFlag != "WARN") return true;
	var locId = Ext.getCmp('locField').getValue();
	var locDesc = Ext.getCmp('locField').getRawValue();
	var budgetId = Ext.getCmp('BudgetProComb').getRawValue();
	if(!budgetId) {
		Msg.info("warning","����������˶�HRPԤ��ϵͳ����ѡ��һ��Ԥ����Ŀ!");
		return false;
	}
	var MianObj={
		project_id : "", //��Ŀid
		project_desc: "", //��Ŀ����
		loc_id : locId, //����id
		loc_desc : locDesc, //��������
		business : "RETURN", //ҵ������
		businode : "SAVE", //ҵ��ڵ�
		main_id : "gIngrt", //ҵ������id
		main_no : "", //ҵ�񵥺�
		operate : "INSERT", //��������
		Detail : data //��ϸ����
	}
	var BusiData = JSON.stringify(MianObj)
	var ret = tkMakeServerCall("PHA.IN.Budget.Client.Interface","SendBusiData",BusiData)
	var RetJson = JSON.parse(ret);
	if(RetJson.code < 0 )
	{
		Msg.info("error",RetJson.msg);
		return false;
	}
	else if(RetJson.code == 1)
	{
		Msg.info("warning",RetJson.msg);
	}
	return true;
}


var deleteIngDret = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(gIngrt==null || gIngrt==""){
			Msg.info("error",$g("û��Ҫɾ�����˻���!"));
			return false;
		}else{			
			if (Ext.getCmp('complete').getValue()==true)
			{
				Msg.info("warning",$g("�Ѿ����,��ֹɾ��!"));
				return;
			}

			Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ�����˻���?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=delete&Ingrt='+gIngrt,
							waitMsg:$g('ɾ����...'),
							failure: function(result, request) {
								Msg.info("error",$g("������������!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("ɾ���ɹ�!"));
									Clear();
								}else if(jsonData.info==-99){
									Msg.info("error",$g("�˻�����Ϊδ���״̬,����ɾ��!"));
								}else{
									Msg.info("error",$g("ɾ��ʧ��!"));
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

	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true))
	{
		Msg.info('warning',$g('��ǰ�˻��������,��ֹɾ����ϸ��¼!'));
		return;
	}	
	
	
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	if (!cell) {
		Msg.info("warning",$g('��ѡ����ϸ��¼!'));
		return;
	}
	
	var rowindex=cell[0];
	if(rowindex==null){
		
		Msg.info("error",$g("��ѡ������!"));
		return false;
	}else{
		var record = IngDretDetailGrid.getStore().getAt(rowindex);
		var RowId = record.get("ingrti");
		if(RowId!=""){
			Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ��ѡ������?'),
				function(btn) {
					if(btn == 'yes'){
						
						Ext.Ajax.request({
							
							url:URL+'?actiontype=deleteDetail&rowid='+RowId,
							waitMsg:$g('ɾ����...'),
							failure: function(result, request) {
								Msg.info("error",$g("������������!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("ɾ���ɹ�!"));
									IngDretDetailGridDs.load({params:{start:0,limit:20,sort:'ingrti',dir:'desc',ret:gIngrt}});
								        GetAmount();
								}else{
									Msg.info("error",$g("ɾ��ʧ��!"));
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
			GetAmount();
		}
	}

}


//=========================�˻�����=================================
var Cause2 = new Ext.form.ComboBox({
	fieldLabel : $g('�˻�ԭ��'),
	id : 'Cause2',
	name : 'Cause2',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : $g('�˻�ԭ��...'),
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
				var colIndex=GetColIndex(IngDretDetailGrid,'Cause2');
				IngDretDetailGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22
				if(setEnterSort(IngDretDetailGrid,colArr)){
						addDetailRow();
					}

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
		{name:'invDate',type:'date',dateFormat:App_StkDateFormat},
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
		{name:'InsuCode'},
		{name:'InsuDesc'}
		
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
	emptyText :$g( '��λ...'),
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250	,
	valueNotFoundText : ''
});
		
ItmUomStore.on('beforeload',function(store){
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	
	var InciDr=inclb.split("||")[0];
	if (InciDr=='') return false;
	else
	{
		ItmUomStore.baseParams={ItmRowid:InciDr};
	}
	
});
/**
 * ��λչ���¼�
 */

CTUom.on('expand', function(combo) {

	combo.store.removeAll();
	combo.store.load();	

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
			NewStkQty=Number(BatStkQty).mul(ConFac);
		}else{
			NewStkQty=Number(BatStkQty).div(ConFac);
		}
		record.set("stkqty",NewStkQty)
	}
	//alert(value+"$"+BUom+"$"+Uom+"$"+NewStkQty+"^"+ConFac)
	var ingri=record.get("ingri");
	record.set("uom", combo.getValue());	
	var Uom=record.get("uom"); 
	SetIngriPrice(record,ingri,Uom);
	
});
var RpEditor=new Ext.form.NumberField({
	selectOnFocus : true,
	allowBlank : false,
	decimalPrecision:3,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {

				var cost = field.getValue();
		
				if (cost == null
						|| cost.length <= 0) {
					Msg.info("warning", $g("���۲���Ϊ��!"));
					return;
				}
				if (cost <= 0) {
					Msg.info("warning",$g("���۲���С�ڻ����0!"));
					return;
				}
			var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();	
			var colIndex=GetColIndex(IngDretDetailGrid,'rp');
			IngDretDetailGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22				
			if(setEnterSort(IngDretDetailGrid,colArr)){
					addDetailRow();
				}	
			}
		}
	}
})
var SpEditor=new Ext.form.NumberField({
	selectOnFocus : true,
	allowBlank : false,
	decimalPrecision:3,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
//		blur:function(field){
				var cost = field.getValue();
		
				if (cost == null
						|| cost.length <= 0) {
					Msg.info("warning", $g("�ۼ۲���Ϊ��!"));
					return;
				}
				if (cost <= 0) {
					Msg.info("warning",$g("�ۼ۲���С�ڻ����0!"));
					return;
				}
				
			var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
			var colIndex=GetColIndex(IngDretDetailGrid,'Sp');
			IngDretDetailGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22
			if(setEnterSort(IngDretDetailGrid,colArr)){
						addDetailRow();
					}

			}
		}
	}
})				
				
//ģ��
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:$g("�˻��ӱ�rowid"),
        dataIndex:'ingrti',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("����ӱ�rowid"),
        dataIndex:'ingri',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("����DR"),
        dataIndex:'inclb',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("����"),
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'desc',
        id:'desc',
        width:200,
        align:'left',
        sortable:true,
        editor:pNameField
    },{
        header:$g("������ҵ"),
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("���"),
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("���ο��"),
        dataIndex:'stkqty',
        width:100,
        align:'left',
        sortable:true    	
    },{
        header:$g("�˻�����"),
        dataIndex:'qty',
        width:100,
        id:'qty',
        align:'right',
        sortable:true,
        editor:new Ext.ux.NumberField({
			id:'dretQtyField',
			formatType:'FmtSQ',
            allowBlank:true,
			allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var row = IngDretDetailGridDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
						var count = field.getValue();
						if(count>row.get("stkqty")){
							field.setValue("");
							Msg.info("error",$g("�˻��������ܴ��ڿ������!"));
						}else{
							if(setEnterSort(IngDretDetailGrid,colArr)){
									addDetailRow();
								}
							GetAmount();
						}
					}
				}
			}
        })
    },{
        header:$g("�˻���λ"),
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
					GetAmount();										
				}
			}
		}
    },{
        header:$g("�˻�ԭ��"),
        dataIndex:'reasonId',
        width:100,
        id:'reasonId',
        align:'left',
        sortable:true,
		editor:new Ext.grid.GridEditor(Cause2),
		renderer:Ext.util.Format.comboRenderer(Cause2)
    },{
        header:$g("�˻�����"),
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true,
        editor : RpEditor

        
    },{
        header:$g("�˻����۽��"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("�ۼ�"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true,
        editor : SpEditor
    },{
        header:$g("�˻��ۼ۽��"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:$g("����"),
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("Ч��"),
        dataIndex:'expDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("��Ʊ��"),
        dataIndex:'invNo',
        id:'invNo',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'invNoField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}

					}
				}
			}
        })
    },{
        header:$g("��Ʊ����"),
        dataIndex:'invDate',
        id:'invDate',
        width:100,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor: new Ext.ux.DateField({
			id:'invDateField2',
            allowBlank:true,
			format:App_StkDateFormat,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						var row = IngDretDetailGridDs.getAt(cell[0]);	
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}
	
					}
				}
			}
        })
    },{
        header:$g("�˷�Ʊ���"),
        dataIndex:'invAmt',
        id:'invAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount,
		editor: new Ext.ux.NumberField({
			id:'invAmtField2',
			formatType:'FmtSA',
            allowBlank:true,			
            listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}
	
					}
				}
			}
        })
    },{
        header:$g("���е���"),
        dataIndex:'sxNo',
        id:'sxNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
            allowBlank:true,
            listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}
	
					}
				}
			}
        })
    }
    ,{
        header:$g("����ҽ������"),
        dataIndex:'InsuCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("����ҽ������"),
        dataIndex:'InsuDesc',
        width:100,
        align:'left',
        sortable:true
    }
]);

//��ʼ��Ĭ��������
IngDretDetailGridCm.defaultSortable = true;

//���
var IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	id:'IngDretDetailGrid',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	height:450,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({
		listeners:{
			'beforecellselect':function(sm,row,col){
				var ind=IngDretDetailGridCm.getIndexById('uom');
				if ( col==ind){

				}
			}
		}
	}),
	loadMask:true,
    //tbar:['��Ʒ����',pNameField,'-',findVendor,'-',addList,'-','����ʾ���Ϊ�����',noViewZeroItem,'-','����ʾ���Ϊ��ľ�Ӫ��ҵ',noViewZeroVendor],
	clicksToEdit:1
});

IngDretDetailGrid.on('afteredit',function(e){
	if(e.field=='qty'){
		if(e.record.get("qty")>e.record.get("stkqty")){
			Msg.info("error",$g("�˻��������ܴ��ڿ������!"));
			e.record.set("qty","");
		}else{
			e.record.set("rpAmt", accMul(e.value,e.record.get("rp"))); 
			e.record.set("spAmt", accMul(e.value,e.record.get("sp")));
			e.record.set("invAmt",accMul(e.value,e.record.get("rp")))
		}
	}
	if(e.field=='rp'){
		if(e.record.get("qty")>0){
			e.record.set("rpAmt", accMul(e.record.get("qty"),e.record.get("rp"))); 
			e.record.set("invAmt",accMul(e.record.get("qty"),e.record.get("rp")))
		}
	}
	if(e.field=='sp'){
		if(e.record.get("qty")>0){
		
			e.record.set("spAmt", accMul(e.record.get("qty"),e.record.get("sp")));
		}
	}
});

IngDretDetailGrid.addListener("rowcontextmenu",rightClickFn);
IngDretDetailGrid.on('beforeedit',function(e){
       	
       	
       	if(e.field=="sp"){
			 if (gParam[4]!='Y'){	
                          e.cancel=true;
                          }
			}
		if(e.field=="rp"){
			 if (gParam[3]!='Y'){	
                          e.cancel=true;
                          }
			}
		});
IngDretDetailGrid.addListener("rowcontextmenu",rightClickFn);
        IngDretDetailGrid.getView().on('refresh',function(Grid){
			GetAmount()
			})
var rightMenu=new Ext.menu.Menu({
	id:"rightClickMenu",
	items:[{
		id:"mnuDelete",
		text:$g("ɾ��"),
		handler:DeleteDetail
	}]
});

function rightClickFn(grid,rowindex,e){
	grid.getSelectionModel().select(rowindex,0);
	e.preventDefault();
	rightMenu.showAt(e.getXY());
}

var formPanel = new Ext.form.FormPanel({
	id:'MainForm',
	labelWidth : 60,
	labelAlign : 'right',
	frame:true,
	autoHeight:true,
	//bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar : [findIngDret,'-',clearBT,'-',newBT,'-',saveIngDret,'-',completeBT,'-',cancelCompleteBT,'-',findIngBT,'-',printBT,'-',deleteIngDret],
	items:[{
		xtype:'fieldset',
		title:$g('�˻�����Ϣ'),
		style:DHCSTFormStyle.FrmPaddingV,
		layout: 'column',    // Specifies that the items will now be arranged in columns
		items : [{ 				
			columnWidth: 0.25,
			xtype : 'fieldset',
			border:false,
        	items: [locField,groupField]
			
		},{ 				
			columnWidth: 0.25,
			xtype : 'fieldset',
			border:false,
	       	items: [Vendor,dretField]			
		},{ 				
			columnWidth: 0.20,
			xtype : 'fieldset',
			border:false,
        	items: [dateField,BudgetProComb]
			
		},{ 				
			columnWidth: 0.1,
			xtype : 'fieldset',
			border:false,
			labelWidth:10,
      		items: [complete,transOrder]			
		},{
			columnWidth: 0.15,
			xtype : 'fieldset',
			border:false,
			labelWidth:10,
			items:[auditChk]
		}
		]				
	}]
});

//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.Viewport({
		layout:'border',	
		items:[{
	                region: 'north',
	                split: true,
        			height: DHCSTFormStyle.FrmHeight(2),
	                title: $g('�˻��Ƶ�'),
	                layout:'fit',
	                items: formPanel               
	            },{             
	                region: 'center',		                
                	title:$g('��ϸ��¼'),
                	split:false,
                	//height:250,
                	//minSize:100,
                	//maxSize:200,
                	//collapsible:true,
                	layout:'fit',
                	items:IngDretDetailGrid,
                	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
                	bbar:new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]})
	            }],
		renderTo:'mainPanel'
	});
	
	RefreshGridColSet(IngDretDetailGrid,"DHCSTRETURN");   //�����Զ�������������������
	colArr=sortColoumByEnterSort(IngDretDetailGrid); //���س��ĵ���˳���ʼ����
	SetBudgetPro(Ext.getCmp("locField").getValue(),"RETURN",[1,2],"saveIngDret") //����HRPԤ����Ŀ
});
//===========ģ����ҳ��=================================================





function addDetailRow() {
	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true))
	{
		Msg.info('warning',$g('��ǰ�˻��������,��ֹ������ϸ��¼!'));
		return;
	}	
	locField.setDisabled(true);
	// �ж��Ƿ��Ѿ��������
	var rowCount = IngDretDetailGrid.getStore().getCount();
	var invNo="";
	var invDate="";
	var retReason="";
	var sxNo=""
	if (rowCount > 0) {
		var rowData = IngDretDetailGridDs.data.items[rowCount - 1];
		var data = rowData.get("inclb");
		if (data == null || data.length <= 0) {
			var col=GetColIndex(IngDretDetailGrid,"desc");
			IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, col);
			return;
		}
			var invNo=rowData.get("invNo");
		    var invDate=rowData.get("invDate");
		    var reasonId=rowData.get("reasonId");
		    var retReason=rowData.get("retReason");	
		    sxNo=rowData.get("sxNo");	
	}
	var rec = Ext.data.Record.create([
		{name : 'ingrti',type : 'string'}, 
		{name : 'ingri',type : 'string'}, 
		{name : 'manf',type : 'string'}, 
		{name : 'inclb',type : 'string'}, 
		{name : 'uom',type : 'string'}, 
		{name : 'uomDesc',type : 'string'}, 
		{name : 'qty',type : 'int'}, 
		{name : 'rp',type : 'double'}, 
		{name : 'rpAmt',type : 'double'},
		{name : 'sp',type : 'double'},
		{name : 'spAmt',type : 'double'},
		{name : 'invNo',type : 'string'},
		{name : 'invDate',type : 'string'},
		{name : 'invAmt',type : 'double'},
		{name : 'sxNo',type : 'string'},
		{name : 'oldSp',type : 'double'},
		{name : 'oldSpAmt',type : 'double'},
		{name : 'code',type : 'string'},
		{name : 'desc',type : 'string'},
		{name : 'spec',type : 'string'},
		{name : 'batNo',type : 'string'},
		{name : 'expDate',type : 'string'},
		{name : 'reasonId',type : 'int'},
		{name : 'retReason',type : 'string'},
		{name : 'stkqty',type : 'double'},
		{name:'buom',type:'string'},
		{name:'confac',type:'string'},
		{name:'InsuCode',type:'string'},
		{name:'InsuDesc',type:'string'}
		
	]);
	var NewRec = new rec({
		ingrti:'',
		ingri:'',
		manf:'',
		inclb:'',
		uom:'',
		uomDesc:'',
		qty:'',
		rp:'',
		rpAmt:'',
		sp:'',
		spAmt:'',
		invNo:invNo,
		invDate:invDate,
		invAmt:'',
		sxNo:sxNo,
		oldSp:'',
		oldSpAmt:'',
		code:'',
		desc:'',
		spec:'',
		batNo:'',
		expDate:'',
		reasonId:reasonId,
		retReason:retReason,
		stkqty:'',
		buom:'',
		confac:'',
		InsuCode:'',
		InsuDesc:''
	});
					
	IngDretDetailGridDs.add(NewRec);
	var colIndex=GetColIndex(IngDretDetailGrid,"desc");
	IngDretDetailGrid.getSelectionModel().select(IngDretDetailGridDs.getCount() - 1, colIndex);
	IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, colIndex);
        GetAmount();
}

//�����˻��б�
function AddList(row){
	if(row==null || row==""){
		return;
	}		
	var colIndex=GetColIndex(IngDretDetailGrid,"qty");
	var coldescIndex=GetColIndex(IngDretDetailGrid,"desc");
	//var row = IngDretGridDs.getAt(j);
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
	var stkqty = row.get('stkqty');
	var rp = row.get('rp');
	var sp = row.get('sp');
	var sp = row.get('sp');
	if(ReturnParam.ChoiceRp == 2 ) var rp = row.get('CurRp');
	if(ReturnParam.ChoiceSp == 2 ) var sp = row.get('CurSp');
	//var rpAmt = row.get('rpAmt');
	//var spAmt = row.get('spAmt');
	//var invAmt = row.get('invAmt');
	var invNo = row.get('invNo');
	//var qty = row.get('dretQty');
	var sxNo = row.get('sxNo');
	//var dretAmt = row.get('dretAmt');
	var cause = row.get('causeName');
	var causeId = row.get('causeId');
	var Drugform = row.get('Drugform');
	var spec = row.get('Spec');
	var buom=row.get('buom');
	var confac=row.get('confac');
	var InsuCode = row.get('InsuCode');
	var InsuDesc = row.get('InsuDesc');
	puomRp=rp;
	puomSp=sp;
	buomRp=puomRp/confac;
	buomSp=puomSp/confac;
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var rowIndex=cell[0];
	if(stkqty<=0){
		Msg.info("warning",$g("����Ŀ���Ϊ�㣬�����˻�!"));
		IngDretDetailGrid.startEditing(rowIndex,coldescIndex);
		return;
	}		
	var selectVenid=Ext.getCmp("Vendor").getValue();
	if(selectVenid!=null & selectVenid!=""){
		if(selectVenid!=venid){    
			Msg.info("warning",$g("����Ŀ��Ӫ��ҵ��������ѡ����Ŀ�ľ�Ӫ��ҵ��������ͬһ���˻������˻�"));
			IngDretDetailGrid.startEditing(rowIndex,coldescIndex);
			return;
		}
	}else{
		addComboData(Vendor.getStore(),venid,sven);
		Ext.getCmp("Vendor").setValue(venid);
	}	
	var count=IngDretDetailGridDs.getCount();
	for(var j=0;j<count;j++){
		var tmpData=IngDretDetailGridDs.getAt(j);
		var tmpInclb=tmpData.get("inclb");
		if((tmpInclb==INCLB)&(j!=rowIndex)){
			Msg.info("warning",$g("�������Ѿ��������˻��б�"))
			IngDretDetailGrid.startEditing(rowIndex,coldescIndex);
			return;
		}
	}
	;
	var rowData = IngDretDetailGridDs.getAt(rowIndex);
	rowData.set('code',code);
	rowData.set('desc',desc);
	rowData.set('ingri',INGRI);
	rowData.set('inclb',INCLB);
	//rowData.set('invNo',invNo);
	//rowData.set('qty',qty);
	rowData.set('sp',sp);
	rowData.set('rp',rp);
	rowData.set('batNo',batch);
	rowData.set('expDate',expdate);
	//rowData.set('sxNo',sxNo);
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set('uom',uom);
	rowData.set('uomDesc',uomDesc);
	//rowData.set('spAmt',spAmt);
	//rowData.set('rpAmt',rp*qty);
	//rowData.set('dretAmt',dretAmt);
	//rowData.set('invDate',invDate);
	//rowData.set('invAmt',invAmt);
	//rowData.set('retReason',cause);
	//rowData.set('reasonId',causeId);
	rowData.set('spec',spec);
	rowData.set('manf',mnf);
	rowData.set('stkqty',stkqty);

	rowData.set('buom',buom);
	rowData.set('confac',confac);
	rowData.set('InsuCode',InsuCode);
	rowData.set('InsuDesc',InsuDesc);
	if(setEnterSort(IngDretDetailGrid,colArr)){
		addDetailRow();
	}

	//IngDretDetailGrid.startEditing(rowIndex,colIndex);
	saveIngDret.enable();
	Ext.getCmp("Vendor").setDisabled(true);
	locField.setDisabled(true);
	groupField.setDisabled(true);
}


//�½��˻���
function NewRet()
{
	Clear();
	addDetailRow();
}

//���ҳ��
function Clear(){
	//alert(App_StkTypeCode);
	gIngrt="";
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("dret").setValue("");
	Ext.getCmp("complete").setValue(false);
	Ext.getCmp("transOrder").setValue(false);		
	Ext.getCmp("audited").setValue(false);
	Ext.getCmp("dateField").setValue(new Date());
	Ext.getCmp("Vendor").setDisabled(false);
	groupField.setDisabled(false);
	locField.setDisabled(false);
	IngDretDetailGridDs.removeAll();
}


/*�˻������*/
function Complete() {    
	var rowCount =IngDretDetailGridDs.getCount();
	if(rowCount==0) 
	{
		Msg.info('warning',$g('��ϸ����Ϊ�գ���˶���ϸ!'))
		return;
	} 

	     
	if((gIngrt!="")&&(gIngrt!=null)){
		/// ���Ԥ����Ŀ
	    var ret = SendBusiData(gIngrt,"RETURN","COMP");
	    if(!ret) return;

		Ext.Ajax.request({
			url:URL+'?actiontype=complet&ret='+gIngrt,
			waitMsg:$g('ִ����...'),
			failure: function(result, request) {
				Msg.info("error",$g("������������!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success",$g("������ɳɹ�!"));
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
				}else{
					if (jsonData.info==-2)
					{
						Msg.info("error",$g("�˻��������!"));
					}
					else
					{
						Msg.info("error",$g("�������ʧ��!")+jsonData.info);
					}
				}
			},
			scope: this
		});
	}
	else
	{
		Msg.info("warning",$g( "û����Ҫ��ɵ��˻���!"));
		return;
	}
            
}        

/*ȡ�����*/
function cancelComplete() {
	
	if((gIngrt!="")&&(gIngrt!=null)){
		Ext.Ajax.request({
			url:URL+'?actiontype=cancelComompleted&ret='+gIngrt,
			waitMsg:$g('ִ����......'),
			failure: function(result, request) {
				Msg.info("error",$g("������������!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success",$g("ȡ����ɳɹ�!"));
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
				}else{
					switch (jsonData.info)
					{
					 case '-1':
					 	Msg.info("warning",$g("�˻���������!"));
					 	break;
					 case '-10':
					 	Msg.info("warning",$g("�˻����Ѿ����,��ֹȡ�����!"));
					 	break;
					 case '-2':
					 	Msg.info("warning",$g("�˻���δ���!"));
					 	break;
					 case '-99':
					 	Msg.info("error",$g("����ʧ��!"));
					 	break;
					 default:
					 	Msg.info("error",$g("ȡ�����ʧ��!")+jsonData.info);
					 	break;
					}
				}
			},
			scope: this
		});
	}
	else
	{
		Msg.info("warning", $g("û����Ҫȡ����ɵ��˻���!"));
		return;
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
		waitMsg:$g('��ѯ��...'),
		failure: function(result, request) {
			Msg.info("error",$g("������������!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				Ext.getCmp('dret').setValue(arrData[6]);
				addComboData(Vendor.getStore(),arrData[1],arrData[27]);
				Ext.getCmp('Vendor').setValue(arrData[1]);
				addComboData(GetGroupDeptStore,arrData[7],arrData[19]);
				Ext.getCmp("locField").setValue(arrData[7]);
				var compFlag=(arrData[4]=='Y'?true:false);
				Ext.getCmp("complete").setValue(compFlag);
				var adjchqFlag=(arrData[11]=='Y'?true:false);
				Ext.getCmp("transOrder").setValue(adjchqFlag);
				Ext.getCmp('groupField').setValue(arrData[14]);
				
				var audited=(arrData[15]=='Y'?true:false);  //�����
				Ext.getCmp("audited").setValue(audited);
				var ingrdate=arrData[29];
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
					GetAmount();
				}
				Ext.getCmp("Vendor").setDisabled(true);
				groupField.setDisabled(true);
				locField.setDisabled(true);
			}
		},
		scope: this
	});
	
}
function SelectRec(Ingr)
{
	if((Ingr==null)||(Ingr=="")){
		return;
	}
	//gIngrt=Ingr;
	Ext.Ajax.request({
		url:URL+'?actiontype=getRec&rowid='+Ingr,
		waitMsg:$g('��ѯ��...'),
		failure: function(result, request) {
			Msg.info("error",$g("������������!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				addComboData(Vendor.getStore(),arrData[1],arrData[2]);
				Ext.getCmp('Vendor').setValue(arrData[1]);
				addComboData(GetGroupDeptStore,arrData[10],arrData[11]);
				Ext.getCmp("locField").setValue(arrData[10]);
				Ext.getCmp("complete").setValue(false);
				Ext.getCmp('groupField').setValue(arrData[27]);
				saveIngDret.setDisabled(false);
				completeBT.setDisabled(false);
				groupField.setDisabled(true);
				Ext.getCmp("Vendor").setDisabled(true);
				
			}
		},
		scope: this
	});
	
}

function setGridEditable(grid,b)
{
		
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('qty');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('uom');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('reasonId');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('invNo');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('invDate');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('invAmt');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('sxNo');	        
	grid.getColumnModel().setEditable(colId,b);
	
}



/*���Ƿ��޸�*/
function Modified(){
	var detailCnt=0
	var rowCount=IngDretDetailGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
				var item = IngDretDetailGrid.getStore().getAt(i).get("IncId");
				if (item != "") {
					detailCnt++;
				}
			}
	var result=false;
	//��Ϊ�µ�(gIngrt="")�����ӱ��Ƿ��в���
	if ((gIngrt<=0)||(gIngrt==''))
	{
		if (detailCnt==0) {
			result=false;
		} else{
			result= true;
		}		
	}else{  //����Ϊ�µ�����������ӱ�
		for(var index=0;index<rowCount;index++){
			var rec = IngDretDetailGrid.getStore().getAt(index);	
					//���������ݷ����仯ʱִ����������
		    if(rec.data.newRecord || rec.dirty){
				result = true;
			}	
	    }
	}
	return result;
}
/*����ԭʼֵ��ά�ֳ�ʼδ�޸�״̬*/
function setOriginalValue(formId)
{
	if (formId=="") return;
	Ext.getCmp(formId).getForm().items.each(function(f){ 		
		f.originalValue=String(f.getValue()); 
	});
}
//ȡ��ָ����λ�����۸񣨽���+�ۼۣ�
//ingri - �����ϸrowid
//uom - ��λrowid
function SetIngriPrice(rec,ingri,uom)
{
	Ext.Ajax.request({
		url:URL+'?actiontype=getIngriPrice'+"&ingri="+ingri+"&uom="+uom,
		failure:function(){
			Msg.info("error",$g("ʧ��!"));
		},
		success:function(result, request){
			//alert(result.responseText);
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
				rpAmt=FormatGridRpAmount(rpAmt);
				spAmt=FormatGridSpAmount(spAmt);
				rec.set('rpAmt',rpAmt);
				rec.set('spAmt',spAmt);
				rec.set('invAmt',rpAmt);
				GetAmount();
			}
		}	
	})
}

function BeforeSave()
{


}

//����ѡ�е��������
function handleSelectedIngri(rec)
{
	AddList(rec);
}

function test()
{
	
}

	
//�˳���ˢ��ʱ,������ʾ�Ƿ񱣴�
//Creator:bianshuai 2014-04-21
window.onbeforeunload = function(){
	var compFlag=Ext.getCmp('complete').getValue();
	var mod=Modified();
	if  (mod&&(!compFlag)) {
		return $g("������¼����޸�,�㵱ǰ�Ĳ�������ʧ��Щ���,�Ƿ������");
	} 
}
