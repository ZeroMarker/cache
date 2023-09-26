
var payRowId="";
var URL="dhcstm.payaction.csp";
var gGroupId=session['LOGON.GROUPID'];

//�������ֵ��object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

//�����
var payNoField = new Ext.form.TextField({
	id:"payNoField",
	fieldLabel:"�����",
	allowBlank:true,
	width:120,
	readOnly :true,
	//listWidth:120,
	//emptyText:"�����...",
	anchor:'90%',
	readOnly:true,
	selectOnFocus:true
});		
// ��ӡ�����ť
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '�����ӡ���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintPay(payRowId);
	}
});	
var payDetailCM=new Ext.grid.ColumnModel([
  {
	  header:'������ϸRowId',
	  dataIndex:"payi",
	  hidden:true
  },
  {
	  header:"���(�˻�)RowId",
	  dataIndex:"pointer",
	  hidden:true
  },
  {
	  header:"����(���/�˻�)",
	  dataIndex:"TransType",
	  width:100,
	  align:"left"
  },
  {
	  header:"inclb",
	  dataIndex:"inclb",
	  width:100,
	  align:"left",
	  hidden:true
  },
  {
	  header:"����RowId",
	  dataIndex:"INCI",
	  hidden:true
  },
  {
	  header:"���ʴ���",
	  dataIndex:"inciCode",
	  width:120,
	  align:"left"
  },
  {
	  header:"��������",
	  dataIndex:"inciDesc",
	  width:250,
	  align:"left"
  },
  {
	  header:"���",
	  dataIndex:"spec",
	  width:100,
	  align:"left"
  },
  {
	  header:"����",
	  dataIndex:"manf",
	  width:160,
	  align:"left"
  },
  {
	  header:"����",
	  dataIndex:"qty",
	  width:100,
	  align:"right"
  },		  
  {
	  header:"��λ",
	  dataIndex:"uomDesc",
	  width:100,
	  align:"left"
  },
    {
	  header:"�����",
	  dataIndex:"recAmt",
	  width:100,
	  align:"right"
  },	
 {
	  header:"������",
	  dataIndex:"payAmt",
	  width:100,
	  align:"right"
  },	 
 {
	  header:"�����ۼƽ��",
	  dataIndex:"sumPayAmt",
	  width:100,
	  align:"right"
  },	   
  {
	  header:"����",
	  dataIndex:"rp",
	  width:100,
	  align:"right"
  },
  {
	  header:"���۽��",
	  dataIndex:"rpAmt",
	  width:100,
	  align:"right"
  },
  
    {
	  header:"�ۼ�",
	  dataIndex:"sp",
	  width:100,
	  align:"right"
  },
    {
	  header:"�ۼ۽��",
	  dataIndex:"spAmt",
	  width:100,
	  align:"right"
  },  
  {
	  header:"��Ʊ��",
	  dataIndex:"invNo",
	  width:100,
	  align:"center"
  },
  {
	  header:"��Ʊ����",
	  dataIndex:"invDate",
	  type:"number",
	  width:100,
	  align:"center"
  },
{
	  header:"����(���/�˻�)",
	  dataIndex:"grNo",
	  width:120,
	  align:"left"
  },
  {
	  header:"���е���",
	  dataIndex:"insxNo",
	  width:100,
	  align:"left"
  },
  {
	  header:"����",
	  dataIndex:"batNo",
	  width:100,
	  align:"left"
  },
  {
	  header:"Ч��",
	  dataIndex:"expDate",
	  width:100,
	  align:"left"
  }
  ]);	

// �ɹ�����

var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '�ɹ�����',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	width : 120,
	emptyText : '�ɹ�����...',
	groupId:gGroupId,
	childCombo : 'Vendor'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	params : {LocId : 'PhaLoc'}
});

//��ɱ�־
var completedFlag = new Ext.form.Checkbox({
	fieldLabel : '��ɱ�־',
	id : 'completedFlag',
	name : 'completedFlag',
	anchor : '90%',
	checked : false,
	disabled:true,
	listeners:{
	'check':function(a,b){
		//alert(a.getValue());
		
	}
	}
});

//�Ƶ���
var CreatUsr =new Ext.form.TextField({
	fieldLabel : '�Ƶ���',
	id : 'CreatUsr',
	disabled :true,
	name : 'CreatUsr',
	anchor : '90%'
});

//�Ƶ�����
var CreatDate =new Ext.form.TextField ({
	fieldLabel : '�Ƶ�����',
	id : 'CreatDate',
	name : 'CreatDate',
	disabled :true,
	anchor : '90%'
});

//�Ƶ�ʱ��
var CreatTim =new Ext.form.TextField({
	fieldLabel : '�Ƶ�ʱ��',
	id : 'CreatTim',
	name : 'CreatTim',
	anchor : '90%',
	disabled :true
});

//�ɹ�ȷ�ϱ�־
var ack1lag = new Ext.form.Checkbox({
	fieldLabel : '�ɹ�ȷ��',
	id : 'ack1lag',
	name : 'ack1lag',
	anchor : '90%',
	disabled:true,
	checked : false
});
//�ɹ�ȷ����
var Ack1Usr =new Ext.form.TextField({
	fieldLabel : '�ɹ�ȷ����',
	id : 'Ack1Usr',
	name : 'Ack1Usr',
	disabled:true,
	anchor : '90%'
});	

//�ɹ�ȷ������
var Ack1Date =new Ext.ux.DateField({
	fieldLabel : '�ɹ�ȷ������',
	id : 'Ack1Date',
	name : 'Ack1Date',
	disabled:true,
	anchor : '90%'
});	

//���ȷ������
var Ack2Date =new Ext.ux.DateField({
	fieldLabel : '���ȷ������',
	id : 'Ack2Date',
	name : 'Ack2Date',
	disabled:true,
	anchor : '90%'
});	



//���ȷ�ϱ�־
var ack2lag = new Ext.form.Checkbox({
	fieldLabel : '���ȷ��',
	id : 'ack2lag',
	name : 'ack2lag',
	anchor : '90%',
	checked : false,
	disabled:true
});

//���ȷ����
var Ack2Usr =new Ext.form.TextField({
	fieldLabel : '���ȷ����',
	id : 'Ack2Usr',
	name : 'Ack2Usr',
	anchor : '90%',
	disabled:true
});	

// ���/�˻�������
var createFromRec = new Ext.Toolbar.Button({
	text : '���/�˻�������',
	tooltip : '���/�˻�������',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��ɹ�����!");
			return;
		}
		CreateFromRec(phaLoc,setPayInfo,payRowId);
	}
});

// ��ѯ��ť- ���Ҹ��
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


// ȡ����ɰ�ť(��Ҫ�����Ȩ)
var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : 'ȡ�����',
	tooltip : '���ȡ�����',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		CancleComplete();
	}
});


// ɾ����ϸ��ť(��Ҫ�����Ȩ)
var DeletePayItmBT = new Ext.Toolbar.Button({
	id : "DeletePayItmBT",
	text : 'ɾ��һ����ϸ��¼',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		DeletePayItm();
	}
});
// ɾ����ϸ��ť(��Ҫ�����Ȩ)
var DeletePayBT = new Ext.Toolbar.Button({
	id : "DeletePayBT",
	text : 'ɾ��',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		DeletePay();
	}
});
var SetCompleteBT = new Ext.Toolbar.Button({
	id : "SavePay",
	text : '������',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		SetComplete();
	}
});

var HisListTab = new Ext.form.FormPanel({
	labelWidth : 30,
	labelAlign : 'right',
	frame : true,
	autoScroll : true,
	bodyStyle : 'padding:5px;',
	layout: 'column',    // Specifies that the items will now be arranged in columns
	items : [{ 				
			columnWidth: 0.25,
			xtype: 'fieldset',
			labelWidth: 60,	
			defaults: {width: 220, border:false},    // Default config options for child items
			defaultType: 'textfield',
			autoHeight: true,
			//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			border: false,
			items: [PhaLoc,payNoField,ack1lag]		
		},{ 				
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,	
			defaults: {width: 140, border:false},    // Default config options for child items
			defaultType: 'textfield',
			autoHeight: true,
			//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			border: false,
			items: [Vendor,CreatUsr,Ack1Usr]		
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,	
			defaults: {width: 140, border:false},    // Default config options for child items
			defaultType: 'textfield',
			autoHeight: true,
			//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			border: false,
			items: [CreatDate,ack2lag]
		},{
			columnWidth: 0.2,
			xtype: 'fieldset',
			labelWidth: 60,
			defaults: {width: 140, border:false},    // Default config options for child items
			defaultType: 'textfield',
			autoHeight: true,
			//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			border: false,
			items: [CreatTim,Ack2Usr]
		},{
			columnWidth: 0.15,
			xtype: 'fieldset',
			labelWidth: 60,	
			defaults: {width: 140, border:false},    // Default config options for child items
			defaultType: 'textfield',
			autoHeight: true,
			//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			border: false,
		    items: [completedFlag]
		}]
});

var PayDetailUrl = URL	+ '?actiontype=queryItem';
var payDetailProxy= new Ext.data.HttpProxy({
			url : PayDetailUrl,
			method : "POST"
});

var payItmFields = ["payi","pointer","TransType","inclb","INCI","inciCode","inciDesc","spec","manf","qty","uomDesc","recAmt","payAmt","sumPayAmt","rp","rpAmt","sp","spAmt","invNo","invDate","grNo","insxNo","batNo",{name:'expDate',mapping:"ExpDate"}]

// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "payi",
	fields : payItmFields
});

var payDetailStore = new Ext.data.Store({
	proxy : payDetailProxy,
	reader : reader,
	listeners:{
		'beforeload':function(store){
			var psize=payDetailGridPagingToolbar.pageSize;
			store.baseParams={start:0,limit:psize,parref:payRowId};
		}
	}
});

var payDetailGridPagingToolbar = new Ext.PagingToolbar({
	store:payDetailStore,
	pageSize:PageSize,
	displayInfo:true
});

//�����ϸ Grid
var PayDetailGrid = new Ext.grid.GridPanel({
	region: 'center',
	title: '������ϸ',
	id : 'PayDetailGrid',
	cm : payDetailCM, 
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	store : payDetailStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	tbar:[DeletePayItmBT],
	bbar:[payDetailGridPagingToolbar]
});

var HisListTab = new Ext.ux.FormPanel({
    title:'����Ƶ�',        
    tbar : [SearchBT, '-', ClearBT,'-', SetCompleteBT,'-',CancleCompleteBT,'-',createFromRec,'-',PrintBT,'-',DeletePayBT],
    items:{
    	xtype : 'fieldset',
    	title:'��������Ϣ',
    	layout:'column',
    	defaults : {layout : 'form'},
		items:[{ 				
			columnWidth: 0.25,
			items: [PhaLoc,Vendor,ack1lag]		
		},{ 				
			columnWidth: 0.2,
			items: [payNoField,CreatUsr,Ack1Usr]		
		},{ 				
			columnWidth: 0.2,
			items: [CreatDate,ack2lag]		
		},{ 				
			columnWidth: 0.2,
			items: [CreatTim,Ack2Usr]
		},{ 				
			columnWidth: 0.15,
		    items: [completedFlag]			
		}] 
    }
});

// /����: ����Ƶ�
// /��д�ߣ�gwj
// /��д����: 2012.09.20
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
 
	// ��¼����Ĭ��ֵ
	SetLogInDept(GetGroupDeptStore, "PhaLoc");
	
	//ȡ�Ƿ���Ҫ��������
	//GetParam();
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, PayDetailGrid],
		renderTo:"mainPanel"
	});	
});

function setPayInfo(xpayRowId)
{
	payRowId = xpayRowId;
	//���������Ϣ
	//1.����Ϣ
	Ext.Ajax.request({
	    url: 'dhcstm.payqueryaction.csp?actiontype=payMainInfo&pay='+xpayRowId,
	    success: function(result, request)
	    {
	    	//alert(result.responseText);
			var jsonData = Ext.util.JSON.decode(result.responseText );
			//alert(jsonData);		
			
			if (jsonData.results>0) 
			{
				var payId=jsonData.rows[0]['PAY_Rowid'];
				var vendor=jsonData.rows[0]['PAY_APCVM_DR'];
				var vendorName=jsonData.rows[0]['vendorName'];
				var payLoc =jsonData.rows[0]['PAY_CTLOC_DR'];
				var payDate=jsonData.rows[0]['PAY_Date'];
				var payTime=jsonData.rows[0]['PAY_Time'];
				var payUser=jsonData.rows[0]['PAY_SSUSR_DR'];
				var payUserName=jsonData.rows[0]['userName'];
				
				var payNo=jsonData.rows[0]['PAY_No'];
				var completedFlag=jsonData.rows[0]['PAY_Completed'];
				//alert(completedFlag);
				var ack1Flag=jsonData.rows[0]['PAY_Ack1']=='Y'?true:false;
				var ack1Date=jsonData.rows[0]['PAY_Date_Ack1'];
				var ack1User=jsonData.rows[0]['ack1UserName'];
				
				var ack2Flag=jsonData.rows[0]['PAY_Ack2']=='Y'?true:false;
				var ack2Date=jsonData.rows[0]['PAY_Date_Ack2'];
				var ack2User=jsonData.rows[0]['ack2UserName'];					
				var chqNo=jsonData.rows[0]['PAY_CheckNo'];
				var chqAmt=jsonData.rows[0]['PAY_CheckAmt'];
				var chqDate=jsonData.rows[0]['PAY_CheckDate'];

			 	Ext.getCmp('PhaLoc').setValue(payLoc);				 	
			 	
			 	Ext.getCmp('Vendor').setRawValue(vendorName);
			 	Ext.getCmp('Vendor').store.reload();
			 	
			 	Ext.getCmp('payNoField').setValue(payNo);
			 	
			 	Ext.getCmp('CreatDate').setValue(payDate);
			 	Ext.getCmp('CreatTim').setValue(payTime);
			 	Ext.getCmp('CreatUsr').setValue(payUserName);				 	
				Ext.getCmp('ack1lag').setValue(ack1Flag);
				Ext.getCmp('Ack1Usr').setValue(ack1User);
				Ext.getCmp('Ack1Date').setValue(ack1Date);
				
			 	Ext.getCmp('ack2lag').setValue(ack2Flag);			 				 	
			 	Ext.getCmp('Ack2Usr').setValue(ack2User);				 	
			 	Ext.getCmp('Ack2Date').setValue(ack2Date);			 	

			 	if (completedFlag=="Y"){
			 		Ext.getCmp('completedFlag').setValue(true);
			 		Ext.getCmp('CancleCompleteBT').setDisabled(false);
			 	}else{
			 		Ext.getCmp('completedFlag').setValue(false);
					Ext.getCmp('CancleCompleteBT').setDisabled(true);
				}
				PayDetailGrid.store.load();
			}
	    },
	    failure: function(){Msg.info("error","ʧ��!");}

	});

}
/**
* ��ѯ����
*/
function Query() {
	
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ��ɹ�����!");
		return;
	}
	QueryPay(phaLoc,setPayInfo);
// 
//	var lnk="dhcstm.payfind.csp";
//	var completed="N"; //δ��ɵ�
//	var data=phaLoc+"^"+completed;
//	 
//	var xpayRowId=showModalDialog(lnk,data,"dialogWidth=1100px;dialogHeight=600px;resizable=yes");
//	if (xpayRowId!=undefined &&xpayRowId!="")
//	{	payRowId=xpayRowId;	
//		setPayInfo(xpayRowId);
//	}
}

/**
 * ��ɸ��
 */
function SetComplete() {
	if (payRowId== null || payRowId.length <= 0) {
		Msg.info("warning", "û����Ҫ��ɵĸ��!");
		return;
	}
	var url = URL+ "?actiontype=SetComp&payid="+ payRowId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ��ɵ���
				Msg.info("success", "�ɹ�!");								
				setPayInfo(payRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "����ʧ��,���IdΪ�ջ򸶿������!");
				}else if(Ret==-2){
					Msg.info("error", "����Ѿ����!");
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
	if (payRowId== null || payRowId.length <= 0) {
		Msg.info("warning", "û����Ҫ��ɵĸ��!");
		return;
	}
	var url = URL+ "?actiontype=CnlComp&payid="+ payRowId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			//alert(result.responseText);
			var jsonData = Ext.util.JSON.decode(result.responseText);
			//alert(jsonData.info);
			if (jsonData.success == 'true') {
				// ��ɵ���
				Msg.info("success", "�ɹ�!");			
				setPayInfo(payRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "����ʧ��,���IdΪ�ջ򸶿������!");
				}else if(Ret==-2){
					Msg.info("error", "����Ѿ�ȷ��!");
				}else {
					Msg.info("error", "����ʧ��!");
				}
			}
		},
		failure:function(){
			Msg.info("error","ʧ��!");
		},
		scope : this
	});
}
	
/*ɾ��������ϸ��¼*/
function DeletePayItm(){
	var rec=this.PayDetailGrid.getSelectionModel().getSelected();
	if (rec==undefined)	{return;}
	var payi=rec.get('payi') ;
	if (payi=="") return;
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","����Ѿ����,����ɾ����ϸ!");
		return;
	}
	var ack1Flag=Ext.getCmp("ack1lag").getValue();
	if(ack1Flag==true){
		Msg.info("warning","����Ѳɹ�ȷ��,����ɾ����ϸ!");
		return;
	}
	var ack2Flag=Ext.getCmp("ack2lag").getValue();
	if(ack2Flag==true){
		Msg.info("warning","����ѻ��ȷ��,����ɾ����ϸ!");
		return;
	}
	
	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ��ɾ����',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no') {return;}
			else {
				Ext.Ajax.request({
					url:URL+'?actiontype=DelPayItm&RowId='+payi,
					method:"POST",
					success:function(result,request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true')
						{		
							Msg.info("success", "ɾ���ɹ�!");
							this.PayDetailGrid.store.reload();	
						}else if (jsonData.success=='false'){
							if (jsonData.info=='-99') 	Msg.info("error","����ʧ�ܣ�")
						    if (jsonData.info=='-100') 	Msg.info("error","������ɾ����")
						}
					}
				})
			}
		}
	});
}

/*ɾ��������ϸ��¼*/
function DeletePay(){
	if (payRowId=="") return;
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","����Ѿ����,����ɾ��!");
		return;
	}
	var ack1Flag=Ext.getCmp("ack1lag").getValue();
	if(ack1Flag==true){
		Msg.info("warning","����Ѳɹ�ȷ��,����ɾ��!");
		return;
	}
	var ack2Flag=Ext.getCmp("ack2lag").getValue();
	if(ack2Flag==true){
		Msg.info("warning","����ѻ��ȷ��,����ɾ��!");
		return;
	}
	
	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ��ɾ����',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no') {return;}
			else {
				var mytrn=tkMakeServerCall("web.DHCSTM.DHCPay","Delete",payRowId);
				if(mytrn==0){Msg.info("sucess","ɾ���ɹ�!");clearData();}
				else{Msg.info("error","ɾ��ʧ��!");}
			}
		}
	});
}

/**
 * ��շ���
 */
function clearData() {
	
	payRowId="";
	//Ext.getCmp("PhaLoc").setValue("");
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("payNoField").setValue("");
	
	Ext.getCmp("CreatUsr").setValue("");	
	Ext.getCmp("CreatDate").setValue("");	
	Ext.getCmp("CreatTim").setValue("");		
	 
	Ext.getCmp('ack1lag').setValue("");
	Ext.getCmp('Ack1Usr').setValue("");
	Ext.getCmp('Ack1Date').setValue("");
	
 	Ext.getCmp('ack2lag').setValue("");			 				 	
 	Ext.getCmp('Ack2Usr').setValue("");				 	
 	Ext.getCmp('Ack2Date').setValue("");			 	
 
 	Ext.getCmp('Vendor').setValue("");
 	Ext.getCmp('completedFlag').setValue("");	
	
	
	PayDetailGrid.store.removeAll();
	PayDetailGrid.getView().refresh();
	
}
		
		
function rendorPoFlag(value){
    return value=='Y'? '��': '��';
}

function rendorCmpFlag(value){
    return value=='Y'? '���': 'δ���';
}