var gUserId = session['LOGON.USERID'];
var gUserName = session['LOGON.USERNAME'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
function IncApprovalEdit(drugrowid,drugdesc,Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
/**
 * ��������Դ
 */
var Url = 'dhcst.itmapprovalaction.csp';
var AppNumGridProxy= new Ext.data.HttpProxy({url:Url+'?actiontype=QueryAppNumInfo',method:'POST'});
var AppNumGridDs = new Ext.data.Store({
	proxy:AppNumGridProxy,
    reader:new Ext.data.JsonReader({
		totalProperty:'results',
        root:'rows'
    }, ['RowId','InciDr','ManfId','Manf','AppNum','CurrAppNum','AppExp',
		'Logo','ImpLicense','ImpLicExp','UpdDate','UpdUser','AppRet']),
	pruneModifiedRecords:true,
    remoteSort:false
});

//��֤���
var CertificatStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["GMP",'GMP'], ["��GMP",'��GMP']]
});
var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ʼ����</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	width : 300,
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ֹ����</font>',
	id : 'DateTo',
	name : 'DateTo',
	width : 300,
	value : new Date()
});

// ҩƷ����
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	width : 300,
});

var InciDr = new Ext.form.TextField({
	fieldLabel : 'ҩƷID',
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%'
});

var IncDesc = new Ext.form.TextField({
	fieldLabel : 'ҩƷ����',
	id : 'IncDesc',
	name : 'IncDesc',
	anchor : '90%',
	disabled:true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var inputText=field.getValue();
				var stkGrp=Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo(inputText,stkGrp);
			}
		}
	}
});

var ApprovalNum1 = new Ext.ux.ComboBox({
	fieldLabel : '��׼�ĺ�',
	id : 'ApprovalNum1',
	name : 'ApprovalNum1',
	width:140,
	store : INFORemarkStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var ApprovalNum2 = new Ext.form.TextField({
	id : 'ApprovalNum2',
	name : 'ApprovalNum2',
	width:135,
	valueNotFoundText : ''
});

// ��������
var Phmanf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Phmanf',
	name : 'Phmanf',
	anchor : '100%',
	width : 300,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
});

var ApprovalNumUp1 = new Ext.ux.ComboBox({
	fieldLabel : '<font color=blue>��׼�ĺ�</font>',
	id : 'ApprovalNumUp1',
	name : 'ApprovalNumUp1',
	width:140,
	store : INFORemarkStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var ApprovalNumUp2 = new Ext.form.TextField({
	id : 'ApprovalNumUp2',
	name : 'ApprovalNumUp2',
	width : 135,
	valueNotFoundText : ''
});

var AppNumUp1 = new Ext.ux.ComboBox({
	fieldLabel : 'ԭ��׼�ĺ�',
	id : 'AppNumUp1',
	name : 'AppNumUp1',
	width:140,
	store : INFORemarkStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var AppNumUp2 = new Ext.form.TextField({
	id : 'AppNumUp2',
	name : 'AppNumUp2',
	width : 135,
	valueNotFoundText : ''
});

// ��������(ά��)
var PhmanfUp = new Ext.ux.ComboBox({
	fieldLabel : '<font color=blue>��������</font>',
	id : 'PhmanfUp',
	name : 'PhmanfUp',
	anchor : '100%',
	width : 330,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
});
//������Ч��(ά��)
var AppExpUp = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>������Ч��</font>',
	id : 'AppExpUp',
	name : 'AppExpUp',
	anchor : '100%',
	width : 300,
	value :new Date()
});
//ע���̱�(ά��)
var LogoUp = new Ext.form.TextField({
	fieldLabel : '<font color=blue>ע���̱�</font>',
	id : 'LogoUp',
	name : 'LogoUp',
	width : 280,
});
//����ע��֤(ά��)
var ImpLicenseUp = new Ext.form.TextField({
	fieldLabel : '����ע��֤',
	id : 'ImpLicenseUp',
	name : 'ImpLicenseUp',
	width : 280,
});
//ע��֤Ч��(ά��)
var ImpLicExpUp = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>ע��֤Ч��</font>',
	id : 'ImpLicExpUp',
	name : 'ImpLicExpUp',
	anchor : '100%',
	width : 300,
	value :new Date()
});
//��֤���(ά��)
var CertificatFieldUp = new Ext.form.ComboBox({
	id:'CertificatFieldUp',
	fieldLabel:'��֤���',
	width : 280,
	store:CertificatStore,
	valueField:'key',
	displayField:'keyValue',
	mode:'local'
});
//Rowid(ά��)
var AppRowidUp = new Ext.form.TextField({
	fieldLabel : 'Rowid',
	id : 'AppRowidUp',
	name : 'AppRowidUp',
	width : 300,
	disabled:true,
	hidden:true
});
// ��������
var PhmanfGrid = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Manf',
	name : 'Manf',
	width : 300,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var value=field.getValue();
				if(value==""){
					startCellEditing(AppNumGrid,'ManfId');
				}else{
					startCellEditing(AppNumGrid,'CurrAppNum');
				}
			}
		}
	}
});

var findAppBT = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FineAppNum();
	}
});

var clearAppBT = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});

var newAppBT = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		
		addNewRow();
	}
});

var repAppBT = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		saveData();
	}
});
var closeAppBT = new Ext.Toolbar.Button({
	text:'�ر�',
    tooltip:'�ر�',
    iconCls:'page_close',
	width : 70,
	height : 30,
	handler:function(){
		//window.hide();
		window.close();
	}
});





///ģ��
var AppNumGridCm=new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
        width:40,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"InciDr",
        dataIndex:'InciDr',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"��������",
        dataIndex:'ManfId',
        width:200,
        align:'left',
        hidden:true,
        sortable:true/*,
		editor : new Ext.grid.GridEditor(PhmanfGrid),
		renderer :Ext.util.Format.comboRenderer2(PhmanfGrid,"ManfId","Manf")	*/ 
    },{
        header:"<font color=blue>��������</font>",
        dataIndex:'Manf',
        width:200,
        align:'left',
        sortable:true 
    },{
        header:"ԭ��׼�ĺ�",
        dataIndex:'AppNum',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>����׼�ĺ�</font>",
        dataIndex:'CurrAppNum',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>������Ч��</font>",
        dataIndex:'AppExp',
        width:100,
        align:'left',
        sortable:true,						
		renderer : function(value){
			return formatDate(value);
		}
    },{
        header:"<font color=blue>ע���̱�</font>",
        dataIndex:'Logo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����ע��֤",
        dataIndex:'ImpLicense',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"ע��֤Ч��",
        dataIndex:'ImpLicExp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'UpdDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"������",
        dataIndex:'UpdUser',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"��֤���",
        dataIndex:'AppRet',
        width:80,
        align:'left',
        sortable:true//,
        //editor :CertificatField
    }
]);




var PagingToolBar=new Ext.PagingToolbar({
	id:'PagingToolBar',
	store:AppNumGridDs,
	displayInfo:true,
	pageSize:PageSize,
	displayMsg:"��ǰ��¼{0}---{1}��  ��{2}����¼",
	emptyMsg:"û������",
	firstText:'��һҳ',
	lastText:'���һҳ',
	prevText:'��һҳ',
	refreshText:'ˢ��',
	nextText:'��һҳ'		
});

var AppNumGrid=new Ext.grid.GridPanel({
	title:'������ϸ',
	id:'AppNumGridPanel',
	region:'center',
	store:AppNumGridDs,
	loadMask:true,
	cm:AppNumGridCm,
	trackMouseOver : true,
	stripeRows : true,
	sm:new Ext.grid.RowSelectionModel({}),
	takeMouseOver:true,
	bbar:PagingToolBar,
	clicksToEdit : 1,
	height:300
});
// ��ӱ��ѡȡ���¼�
AppNumGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var selectedRow = AppNumGridDs.data.items[rowIndex];
			var RowId = selectedRow.data['RowId'];
			var ManfId = selectedRow.data['ManfId'];
			var Manf = selectedRow.data['Manf'];
			var AppNum = selectedRow.data['AppNum'];
			var AppNum1=AppNum.split("-")[0];
			var AppNum2=AppNum.split("-")[1];
			var CurrAppNum = selectedRow.data['CurrAppNum'];
			var CurrAppNum1=CurrAppNum.split("-")[0];
			var CurrAppNum2=CurrAppNum.split("-")[1];
			var AppExp = selectedRow.data['AppExp'];
			var Logo= selectedRow.data['Logo'];
			var ImpLicense= selectedRow.data['ImpLicense'];
			var ImpLicExp= selectedRow.data['ImpLicExp'];
			var AppRet= selectedRow.data['AppRet'];	
			Ext.getCmp("AppRowidUp").setValue(RowId); 
			addComboData(PhManufacturerStore,ManfId,Manf);
			Ext.getCmp("PhmanfUp").setValue(ManfId);//��������
			Ext.getCmp("AppNumUp1").setValue(AppNum1); //ԭ��׼�ĺ�ǰ׺
			Ext.getCmp("AppNumUp2").setValue(AppNum2); //ԭ��׼�ĺ�
			Ext.getCmp("ApprovalNumUp1").setValue(CurrAppNum1); //����׼�ĺ�ǰ׺
			Ext.getCmp("ApprovalNumUp2").setValue(CurrAppNum2); //����׼�ĺ�
			Ext.getCmp("AppExpUp").setValue(AppExp); //������Ч��
			Ext.getCmp("LogoUp").setValue(Logo);      //ע���̱�      
			Ext.getCmp("ImpLicenseUp").setValue(ImpLicense);  //����ע��֤
			Ext.getCmp("ImpLicExpUp").setValue(ImpLicExp); //ע��֤Ч��
			Ext.getCmp("CertificatFieldUp").setValue(AppRet); //��֤���
	              
	});


///��ѯ����Panel
var AppNumConPanel=new Ext.form.FormPanel({
	height:100,
	//labelWidth: 60,
	labelAlign : 'right',
	autoScroll:true,
	//autoHeight : true,
	frame : true,
	region:'north',
	bodyStyle : 'padding:0px;',
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout:'column',
		style:'padding:0px 0px 0px 0px',
		defaults:{border:false},
		items:[{
			columnWidth:0.9,
			xtype:'fieldset',
			//defaults:{width:200},
			items:[{xtype:'compositefield',items:[ApprovalNum1,ApprovalNum2]},Phmanf]
		}]
	}]
})
///ά��Panel
var AppNumUpPanel=new Ext.form.FormPanel({
	labelAlign : 'right',
	autoScroll:true,
	//autoHeight : true,
	frame : true,
	region:'center',
	bodyStyle : 'padding:0px;',
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items:[{
		xtype:'fieldset',
		title:'ά��',
		layout:'column',
		style:'padding:0px 0px 0px 0px',
		defaults:{border:false},
		items:[{
			columnWidth:0.9,
			xtype:'fieldset',
			//defaults:{width:200},
			items:[{xtype:'compositefield',items:[AppNumUp1,AppNumUp2]},
			       {xtype:'compositefield',items:[ApprovalNumUp1,ApprovalNumUp2]},PhmanfUp,
			       LogoUp,ImpLicenseUp,AppExpUp,ImpLicExpUp,CertificatFieldUp,AppRowidUp]
		}]
	}]
})

//=====================Event============================
/**
 * ����ҩƷ���岢���ؽ��
 */
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
				getDrugList);
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
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	
	Ext.getCmp("InciDr").setValue(inciDr);
	Ext.getCmp("IncDesc").setValue(inciDesc);
}

/**
 * ��ϸҩƷ����������
 */
function GetPhaDrgInfo(item, group)
{
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
			setAppNunGridList);
	}
}

/**
 * ���ط���
 */
function setAppNunGridList(drugrowid) {
	if (drugrowid == null || drugrowid == "") {
		return;
	}
	var inciDr = drugrowid;
	///��ȡԭ��׼�ĺ�
	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
	Ext.Ajax.request({
		url: Url+'?actiontype=CheckExist',
		params:{inciDr:inciDr},
		failure: function(result, request) {
			 mask.hide();
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			 mask.hide();
			if (jsonData.success=='true') {
				var oldAppNum = jsonData.info;
				/*var oldAppNum1=oldAppNum.split("-")[0];
				var oldAppNum2=oldAppNum.split("-")[1];
				Ext.getCmp("AppNumUp1").setValue(oldAppNum1);
				Ext.getCmp("AppNumUp2").setValue(oldAppNum2);*/
				
			}else{
				if(jsonData.info!=0){
				        //Msg.info("error","��ҩƷ������ڸ��¼�¼");
					//startCellEditing(AppNumGrid,'ManfId');
				}
				
			}
		},
		scope: this
	});
}

/**
 * ��ѯ
 */
function FineAppNum(){
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
  
	if(StartDate==null || StartDate==""){
		Msg.info("warning","��ʼ���ڲ���Ϊ��!");
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning","��ֹ���ڲ���Ϊ��!");
		return;
	}
	
	var ManfId=Ext.getCmp("Phmanf").getValue();           //����ID
	var ApprovalNum1=Ext.getCmp("ApprovalNum1").getValue();
	var ApprovalNum2=Ext.getCmp("ApprovalNum2").getRawValue();
	var ApprovalNum=ApprovalNum1+"-"+ApprovalNum2
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}

	var pageSize=PagingToolBar.pageSize;
	AppNumGrid.store.removeAll();
	AppNumGridDs.setBaseParam("ApprovalNum",ApprovalNum);
	AppNumGridDs.setBaseParam("ManfId",ManfId);
	AppNumGridDs.setBaseParam("InciDr",IncRowid);
	AppNumGridDs.load({params:{start:0,limit:pageSize}});
	AppNumGridDs.removeAll();
	AppNumGridDs.on('load',function(){
		if (AppNumGridDs.getCount()>0){
			//AppNumGrid.getSelectionModel().selectFirstRow();
			//AppNumGrid.getView().focusRow(0);
		}
	}); 
}

/**
 * �½�
 */	
function addNewRow() {
	
	// �ж��Ƿ��Ѿ��������
	var rowCount = AppNumGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = AppNumGridDs.data.items[rowCount - 1];
		var data = rowData.get("InciDr");
		if (data == null || data.length <= 0) {
			AppNumGrid.startEditing(AppNumGridDs.getCount() - 1, 4);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'string'
		},{
			name : 'InciDr',
			type : 'string'
		}/*,{
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'Uom',
			type : 'string'
		}*/, {
			name : 'ManfId',
			type : 'string'
		}, {
			name : 'Manf',
			type : 'string'
		}, {
			name : 'AppNum',
			type : 'string'
		}, {
			name : 'CurrAppNum',
			type : 'string'
		}, {
			name : 'AppExp',
			type : 'date'
		}, {
			name : 'Logo',
			type : 'string'
		}, {
			name : 'ImpLicense',
			type : 'string'
		}, {
			name : 'ImpLicExp',
			type : 'date'
		}, {
			name : 'UpdDate',
			type : 'string'
		}, {
			name : 'UpdUser',
			type : 'string'
		}, {
			name : 'AppRet',
			type : 'string'
		}
	]);

	var NewRecord = new record({
		RowId:'', InciDr:'', ManfId:'', Manf:'', AppNum:'', CurrAppNum:'', AppExp:'', 
		Logo:'', ImpLicense:'', ImpLicExp:'', UpdDate:'', UpdUser:'', AppRet:''
	});

	AppNumGridDs.add(NewRecord);
	AppNumGrid.getSelectionModel().select(AppNumGridDs.getCount() - 1, 4);
	var newcolIndex=GetColIndex(AppNumGrid,'ManfId');
	AppNumGrid.startEditing(AppNumGridDs.getCount() - 1, newcolIndex);
	
	var cell = AppNumGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = AppNumGrid.getStore().getAt(row);
	
	rowData.set("AppExp",new Date().format(App_StkDateFormat));
	rowData.set("ImpLicExp",new Date().format(App_StkDateFormat));
	rowData.set("UpdDate",new Date().format(App_StkDateFormat));
	rowData.set("UpdUser",gUserName);
	
}

/**
 * ����
 */
function saveData(){
	var ListDate="";
	var IrId=Ext.getCmp("AppRowidUp").getValue(); //id
	var Inci =drugrowid                           //incid
	var ManfId = Ext.getCmp("PhmanfUp").getValue();//��������
	var Logo =Ext.getCmp("LogoUp").getValue().trim();      //ע���̱�
	var AppRet =Ext.getCmp("CertificatFieldUp").getValue().trim(); //��֤���
	var AppExp =Ext.getCmp("AppExpUp").getValue().format(App_StkDateFormat).toString();; //������Ч��
	var AppNum1 =Ext.getCmp("AppNumUp1").getValue(); //ԭ��׼�ĺ�ǰ׺
	var AppNum2 =Ext.getCmp("AppNumUp2").getValue().trim(); //ԭ��׼�ĺ�
	var AppNum=AppNum1+"-"+AppNum2
	var UpdDate =""                                //��������
	var CurrAppNum1 =Ext.getCmp("ApprovalNumUp1").getValue(); //����׼�ĺ�ǰ׺
	var CurrAppNum2 =Ext.getCmp("ApprovalNumUp2").getValue().trim(); //����׼�ĺ�
	var CurrAppNum=CurrAppNum1+"-"+CurrAppNum2
	var ImpLicense=Ext.getCmp("ImpLicenseUp").getValue().trim();  //����ע��֤
	var ImpLicExp=Ext.getCmp("ImpLicExpUp").getValue().format(App_StkDateFormat).toString();; //ע��֤Ч��
	if(Inci==""){
		Msg.info("error","ҩƷ��ϢΪ�����ʵ��");
		return;
	}
	if(ManfId==""){
		Msg.info("error","�������̲���Ϊ��");
		return;
	}
	if(CurrAppNum1==""){
		Msg.info("error","����ǰ׺����Ϊ��");
		return;
	}
	if(CurrAppNum2==""){
		Msg.info("error","��׼�ĺŲ���Ϊ��");
		return;
	}
	if(Logo==""){
		Msg.info("error","ע���̱겻��Ϊ��");
		return;
	}
	if(AppExp==""){
		Msg.info("error","����Ч�ڲ���Ϊ��");
		return;
	}
	if(ImpLicExp==""){
		Msg.info("error","ע��֤Ч�ڲ���Ϊ��");
		return;
	}
	if(Inci!=""){
		var dataRow = IrId+"^"+Inci+"^"+ManfId+"^"+Logo+"^"+AppRet+"^"+AppExp+
		"^"+AppNum+"^"+UpdDate+"^"+gUserId+"^"+CurrAppNum+"^"+ImpLicense+"^"+ImpLicExp;
		if(ListDate==""){
			ListDate = dataRow;
		}else{
			ListDate = ListDate+"#"+dataRow;
		}
	}
	if(ListDate==""){
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: Url+'?actiontype=SaveAppNum',
			params:{ListDate:ListDate},
			failure: function(result, request) {
				 mask.hide();
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					FineAppNum();
					ClearDataM();
					//AppNumGrid.store.removeAll();
					//AppNumGridDs.load({params:{start:0,limit:PagingToolBar.pageSize}});
				}else{
					if (jsonData.info==-11){
						Msg.info("warning","�ó�����׼�ĺ��Ѵ���!");
					}else if(jsonData.info!=0){
						Msg.info("error","����ʧ��"+jsonData);
					}
					AppNumGrid.store.removeAll();
					AppNumGridDs.load({params:{start:0,limit:PagingToolBar.pageSize}});
				}
			},
			scope: this
		});
	}
}

/**
 * ���
 */
function ClearData()
{
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	Ext.getCmp("StkGrpType").getStore().load();
	Ext.getCmp("Phmanf").setValue('');
	AppNumGrid.store.removeAll();
	Ext.getCmp("AppRowidUp").setValue(''); 
	Ext.getCmp("PhmanfUp").setValue('');//��������
	Ext.getCmp("AppNumUp1").setValue(''); //ԭ��׼�ĺ�ǰ׺
	Ext.getCmp("AppNumUp2").setValue(''); //ԭ��׼�ĺ�
	Ext.getCmp("ApprovalNumUp1").setValue(''); //����׼�ĺ�ǰ׺
	Ext.getCmp("ApprovalNumUp2").setValue(''); //����׼�ĺ�
    Ext.getCmp("AppExpUp").setValue(new Date()); //������Ч��
	Ext.getCmp("LogoUp").setValue('');      //ע���̱�      
	Ext.getCmp("ImpLicenseUp").setValue('');  //����ע��֤
	Ext.getCmp("ImpLicExpUp").setValue(new Date()); //ע��֤Ч��
	Ext.getCmp("CertificatFieldUp").setValue(''); //��֤���
	Ext.getCmp("ApprovalNum1").setValue('');
	Ext.getCmp("ApprovalNum2").setValue('');
	AppNumGrid.store.removeAll();
	AppNumGridDs.removeAll();
	AppNumGridDs.setBaseParam('ApprovalNum',"");
	AppNumGridDs.setBaseParam("ManfId","");
	AppNumGridDs.setBaseParam("InciDr","");
	AppNumGridDs.load({
		params:{start:0,limit:0},			
		callback : function(r,options, success) {					
			if(success==false){
				Ext.MessageBox.alert("��ѯ����",AppNumGridDs.reader.jsonData.Error);  
			}         				
		}
	});	
} 
/**
 * ���ά����Ϣ
 */
function ClearDataM()
{
    setAppNunGridList(drugrowid)
	Ext.getCmp("AppRowidUp").setValue(''); 
	Ext.getCmp("PhmanfUp").setValue('');//��������
	Ext.getCmp("AppNumUp1").setValue(''); //ԭ��׼�ĺ�ǰ׺
	Ext.getCmp("AppNumUp2").setValue(''); //ԭ��׼�ĺ�
	Ext.getCmp("ApprovalNumUp1").setValue(''); //����׼�ĺ�ǰ׺
	Ext.getCmp("ApprovalNumUp2").setValue(''); //����׼�ĺ�
    Ext.getCmp("AppExpUp").setValue(new Date()); //������Ч��
	Ext.getCmp("LogoUp").setValue('');      //ע���̱�      
	Ext.getCmp("ImpLicenseUp").setValue('');  //����ע��֤
	Ext.getCmp("ImpLicExpUp").setValue(new Date()); //ע��֤Ч��
	Ext.getCmp("CertificatFieldUp").setValue(''); //��֤���
} 

/**
 * Ч����֤
 */
function ExpDateValidator(expDate){
	
	if (expDate == null || expDate.length <= 0) {
		return true;
	}
	var today=new Date().format('Y-m-d');
	if(expDate<today){
		return false;
	}
	var days=DaysBetween(expDate,today);
    if(days<30){
    	return false;
    }    
    return true;
}
/**
 * ��ʽ������
 */
function formatDate(value){
	if(value instanceof Date){
		return new Date(value).format(App_StkDateFormat);
	}else{
		return value;
	}
}
/**
 * �����пɱ༭
 */
function startCellEditing(Grid,ColName)
{
	var cell = Grid.getSelectionModel().getSelectedCell();
	Grid.startEditing(cell[0], GetColIndex(Grid,ColName));
}
//=========================================================
//Ext.onReady(function()
	var AspAmtPanel=new Ext.Panel({
		activeTab: 0,
		region:'center',
		layout: 'border', 
		items:[AppNumConPanel,AppNumUpPanel]
	})
	var window = new Ext.Window({
				title : '������Ϣά��'+'<font color=blue>ע:��ɫΪ������</font>',
				width :1200,
				height : 600,
				modal:true,
				layout:'border',
				items: [{         
				  region:'west',
		                height: 300, // give north and south regions a height
		                width: 450, 
                              layout:'fit',
				  items:[AspAmtPanel]  
					 },{   
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
					  items:[AppNumGrid]    
					   }],
			  tbar:[findAppBT,'-',clearAppBT,'-',repAppBT,'-',closeAppBT] 
			});

	window.show();
	Ext.getCmp("InciDr").setValue(drugrowid);
	Ext.getCmp("IncDesc").setValue(drugdesc);
	FineAppNum();
	setAppNunGridList(drugrowid)
	//�رմ����¼�
	window.on('close', function(panel) {
			Fn(drugrowid);
	});
}