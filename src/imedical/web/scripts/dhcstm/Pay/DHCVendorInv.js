// ����:��ⵥ��Ʊ������ǰ���
// ��д����:2014-09-10
var invRowId="";
var URL="dhcstm.vendorinvaction.csp"
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];

var invNoField = new Ext.form.TextField({
	id:"invNoField",
	fieldLabel:"��Ʊ��ϵ���",
	allowBlank:true,
	readOnly :true,
	anchor:'90%',
	readOnly:true,
	selectOnFocus:true
});		

var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '�����ӡ',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		Printinv(invRowId);
	}
});	

var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '����',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	emptyText : '����˻�����...',
	groupId:gGroupId,
	stkGrpId : 'StkGrpType',
	childCombo : 'Vendor'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
});

//��ɱ�־
var completedFlag = new Ext.form.Checkbox({
	fieldLabel : '��ɱ�־',
	id : 'completedFlag',
	name : 'completedFlag',
	anchor : '90%',
	checked : false,
	disabled:true
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

// ����
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	anchor:'90%',
	StkType:App_StkTypeCode,     
	LocId:CtLocId,
	UserId:UserId
});

var INVRpTotalAmt=new Ext.form.TextField({
	id : 'INVRpTotalAmt',
	fieldLabel:'��Ͻ����ܶ�',
	anchor : '90%',
	disabled:true
});

var INVSpTotalAmt=new Ext.form.TextField({
	id : 'INVSpTotalAmt',
	fieldLabel:'����ۼ��ܶ�',
	anchor : '90%',
	disabled:true
});	
	
var createFromRec = new Ext.Toolbar.Button({
	text : '������ϸ��Ʊ���',
	tooltip : '��ⵥ���˻�����ϸ��Ʊ���',
	width : 70,
	height : 30,
	iconCls : 'page_edit',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��������!");
			return;
		}
		CreateFromRec(phaLoc,setinvInfo);
	}
});

var createFromRecRet = new Ext.Toolbar.Button({
	text : '�����ݷ�Ʊ���',
	tooltip : '��ⵥ���˻�����Ʊ���',
	width : 70,
	height : 30,
	iconCls : 'page_edit',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��������!");
			return;
		}
		createFromRecRet(phaLoc,setinvInfo);
	}
});

var SearchBT = new Ext.Toolbar.Button({
	text : '��ѯ',
	tooltip : '�����ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ������˻�����!");
			return;
		}
		QueryVendorInv(phaLoc,setinvInfo);
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

var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : 'ȡ�����',
	tooltip : '���ȡ�����',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		CancleComplete();
	}
});
var DeleteBT = new Ext.Toolbar.Button({
	text:'ɾ��',
	id:'DeleteBT',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		Delete();
	}
});
var DeleteinvItmBT = new Ext.Toolbar.Button({
	id : "DeleteinvItmBT",
	text : 'ɾ��һ��',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		DeleteinvItm();
	}
});

var SetCompleteBT = new Ext.Toolbar.Button({
	id : "Saveinv",
	text : '���',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		SetComplete();
	}
});

var invDetailUrl = URL	+ '?actiontype=queryItem';
var invDetailProxy= new Ext.data.HttpProxy({
			url : invDetailUrl,
			method : "POST"
});

var invItmFields = ["invi","ingridr","IncId","IncCode","IncDesc","spec","RecQty","UomDesc","manf","rp","sp","rpAmt","spAmt","TransType"]

// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "invi",
	fields : invItmFields
});

var invDetailStore = new Ext.data.Store({
	proxy : invDetailProxy,
	reader : reader,
	listeners:{
		'beforeload':function(store){
			var psize=invDetailGridPagingToolbar.pageSize;
			store.baseParams={start:0,limit:psize,parref:invRowId};
		}
	}
});

var invDetailCM=new Ext.grid.ColumnModel([
  		{
			header : "RowId",
			dataIndex : 'invi',
			hidden : true
		}, {
			header : "����˻�Id",
			dataIndex : 'ingridr',
			width : 80,
			hidden : true
		}, {
			header : "����Id",
			dataIndex : 'IncId',
			width : 80,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 180
		}, {
			header : "���",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "����",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			header : "��λ",
			dataIndex : 'UomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "����",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "�ۼ�",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "���۽��",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "�ۼ۽��",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "����",
			dataIndex : 'TransType',
			width : 70,
			align : 'left',
			sortable : true	
		}, {
			header : "����",
			dataIndex : 'manf',
			width : 150
		}
  ]);	

var invDetailGridPagingToolbar = new Ext.PagingToolbar({
	store:invDetailStore,
	pageSize:PageSize,
	displayInfo:true
});

var invDetailGrid = new Ext.grid.GridPanel({
	region: 'center',
	title: '��Ʊ��ϵ���ϸ',
	cm : invDetailCM, 
	sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
	store : invDetailStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	tbar:[DeleteinvItmBT],
	bbar:[invDetailGridPagingToolbar]
});

var HisListTab = new Ext.ux.FormPanel({
    title:'��ⵥ���˻�����Ʊ���',
    tbar : [SearchBT, '-', ClearBT,'-', SetCompleteBT,'-',CancleCompleteBT,'-',DeleteBT,'-',createFromRec,'-', createFromRecRet,'-',PrintBT],
    items:{
    	xtype : 'fieldset',
    	title:'��Ʊ�������Ϣ',
    	autoHeight:true,
    	layout:'column',
    	defaults : {layout : 'form'},
		items:[{
			columnWidth: 0.25,
			items: [PhaLoc,Vendor]
		},{
			columnWidth: 0.2,
			labelWidth : 100,
			items: [invNoField,StkGrpType]
		},{
			columnWidth: 0.2,
			labelWidth : 100,
			items: [INVRpTotalAmt,CreatUsr]
		},{
			columnWidth: 0.2,
			items: [CreatDate,CreatTim]
		},{
			columnWidth: 0.15,
		    items: [completedFlag]
		}]
    }
});
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
 	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border', 
		items : [HisListTab, invDetailGrid],
		renderTo:"mainPanel"
	});	
});


/**
 * ��ɸ��
 */
function SetComplete() {
	if (invRowId== null || invRowId.length <= 0) {
		Msg.info("warning", "û����Ҫ��ɵķ�Ʊ��ϵ�!");
		return;
	}
	var RowData=invDetailStore.getAt(0);
	if(RowData==""||RowData==undefined){
		Msg.info("warning","û����Ҫ��ɵķ�Ʊ��ϵ���ϸ!");
		return;
	}
	var INVRpTotalAmt = Ext.getCmp('INVRpTotalAmt').getValue();
	if(INVRpTotalAmt==0){
		Msg.info("warning","��ϵ���ⵥ���˻�����ϸ�����ܶ�Ϊ��!");
		return;
	}
	var url = URL+ "?actiontype=SetComp&invid="+ invRowId;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "�ɹ�!");								
				setinvInfo(invRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "����ʧ��,��Ʊ��ϵ�IdΪ�ջ�Ʊ��ϵ�������!");
				}else if(Ret==-2){
					Msg.info("error", "��Ʊ��ϵ��Ѿ����!");
				}else {
					Msg.info("error", "����ʧ��!");
				}
			}
		},
		scope : this
	});
}

function setinvInfo(xinvRowId)
{ 
	invRowId = xinvRowId;
	Ext.Ajax.request({
	    url: URL+'?actiontype=invMainInfo&invid='+invRowId,
	    method : 'POST',
	    success: function(result, request)
	    {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.results>0) 
			{
				var invId=jsonData.rows[0]['INV_RowId'];
				var vendor=jsonData.rows[0]['INV_APCVM_DR'];
				var vendorName=jsonData.rows[0]['vendorName'];
				var invLoc =jsonData.rows[0]['INV_CTLOC_DR'];
				var invDate=jsonData.rows[0]['INV_CreateDate'];
				var invTime=jsonData.rows[0]['INV_CreateTime'];
				var invUser=jsonData.rows[0]['INV_CreateUser'];
				var invUserName=jsonData.rows[0]['UserName'];
				var AssemNo=jsonData.rows[0]['INV_AssemNo'];
				var completedFlag=jsonData.rows[0]['INV_UserCompleted'];
				var scgdr=jsonData.rows[0]['INV_SCG_DR'];
				var scgDesc=jsonData.rows[0]['scgDesc'];
				var rpAmt=jsonData.rows[0]['INV_RpAmt'];

			 	Ext.getCmp('PhaLoc').setValue(invLoc);				 	
			 	Ext.getCmp('Vendor').setRawValue(vendorName);
			 	Ext.getCmp('Vendor').store.reload();
			 	Ext.getCmp('invNoField').setValue(AssemNo);
			 	
			 	Ext.getCmp('CreatDate').setValue(invDate);
			 	Ext.getCmp('CreatTim').setValue(invTime);
			 	Ext.getCmp('CreatUsr').setValue(invUserName);
				addComboData(null,scgdr,scgDesc,StkGrpType);
				Ext.getCmp('StkGrpType').setValue(scgdr);
				Ext.getCmp('INVRpTotalAmt').setValue(rpAmt);

			 	if (completedFlag=="Y"){
			 		Ext.getCmp('completedFlag').setValue(true);
			 		Ext.getCmp('CancleCompleteBT').setDisabled(false);
			 	}else{
			 		Ext.getCmp('completedFlag').setValue(false);
					Ext.getCmp('CancleCompleteBT').setDisabled(true);
				}
				invDetailStore.load();
			}
	    },
	    failure: function(){Msg.info("error","ʧ��!");}

	});
}

/**
 * ȡ�������ⵥ
 */
function CancleComplete() {
	if (invRowId== null || invRowId.length <= 0) {
		Msg.info("warning", "û����Ҫ��ɵķ�Ʊ��ϵ�!");
		return;
	}
	var url = URL+ "?actiontype=CnlComp&invid="+ invRowId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ��ɵ���
				Msg.info("success", "�ɹ�!");			
				setinvInfo(invRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "����ʧ��,��Ʊ��ϵ�IdΪ�ջ�Ʊ��ϵ�������!");
				}else if(Ret==-2){
					Msg.info("error", "��Ʊ��ϵ������뷢Ʊ��!");
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
function DeleteinvItm(){
	var rec=this.invDetailGrid.getSelectionModel().getSelected();
	if (rec==undefined)	{return;}
	var invi=rec.get('invi') ;
	if (invi=="") {return;}
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","��Ʊ��ϵ��Ѿ����,����ɾ����ϸ!");
		return;
	}
	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ��ɾ��������ϸ��',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no') {return;}
			else {
				Ext.Ajax.request({
					url:URL+'?actiontype=DelinvItm&RowId='+invi,
					method:"POST",
					success:function(result,request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true')
						{		
							Msg.info("success", "ɾ���ɹ�!");
							setinvInfo(invRowId);								
						}else if (jsonData.success=='false'){
							if (jsonData.info=='-99') 	Msg.info("error","����ʧ�ܣ�")
						    if (jsonData.info=='-2') 	Msg.info("error","����д��Ʊ�ţ�")
						    if (jsonData.info=='-3') 	Msg.info("error","��Ʊ��ϵ�����ɣ�")
							if (jsonData.info=='-4') 	Msg.info("error","ɾ����,��Ʊ��Ͻ��С��0��")
						}else{
							Msg.info("error", "ɾ��ʧ��!");
						}
					}
				})
			}
		}
	});
}
/**
 * ɾ����ϵ�����
 */
function Delete(){
	if (invRowId== null || invRowId.length <= 0) {
		Msg.info("warning", "û����Ҫɾ���ķ�Ʊ��ϵ�!");
		return;
	}
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","��Ʊ��ϵ��Ѿ����,����ɾ����ϸ!");
		return;
	}
	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ��ɾ����',
		buttons:Ext.Msg.YESNO,
		icon:Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if(b=='no'){return;}
			else{
				Ext.Ajax.request({
					url:URL+'?actiontype=Delete',
					method:'POST',
					params:{invRowId:invRowId},
					success:function(response,opts){
						var jsonData=Ext.util.JSON.decode(response.responseText)
						if(jsonData.success=='true'){
							Msg.info("success","ɾ���ɹ�!");
							clearData()
						}else{
							Msg.info("error","ɾ��ʧ��!")
							}
							
						},
						failure:function(response,opts){
						Msg.info("error","server-side failure with status code��"+response.status);
					}
					
					});
				}
			}
		
		});
	
	}
/**
 * ��շ���
 */
function clearData() {
	
	invRowId="";
	Ext.getCmp("invNoField").setValue("");
	Ext.getCmp("CreatUsr").setValue("");	
	Ext.getCmp("CreatDate").setValue("");	
	Ext.getCmp("CreatTim").setValue("");		
 	Ext.getCmp('Vendor').setValue("");
 	Ext.getCmp('completedFlag').setValue("false");	
	invDetailGrid.store.removeAll();
	invDetailGrid.getView().refresh();
	
}
