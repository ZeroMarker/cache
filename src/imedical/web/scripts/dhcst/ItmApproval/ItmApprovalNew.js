var gUserId = session['LOGON.USERID'];
var gUserName = session['LOGON.USERNAME'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

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
    }, ['RowId','InciDr','Code','Desc','Uom','ManfId','Manf','AppNum','CurrAppNum','AppExp',
		'Logo','ImpLicense','ImpLicExp','UpdDate','UpdUser','AppRet']),
	pruneModifiedRecords:true,
    remoteSort:false
});


var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ʼ����</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%',
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ֹ����</font>',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%',
	value : new Date()
});

// ҩƷ����
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
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
	width:'200',
	//anchor : '90%',
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

// ��������
var Phmanf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Phmanf',
	name : 'Phmanf',
	anchor : '90%',
	width : 100,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
});

// ��������
var PhmanfGrid = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Manf',
	name : 'Manf',
	anchor : '90%',
	width : 100,
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

//��֤���
var CertificatStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["GMP",'GMP'], ["��GMP",'��GMP']]
});

var CertificatField = new Ext.form.ComboBox({
	id:'conditionStateField',
	fieldLabel:'��֤���',
	anchor:'90%',
	store:CertificatStore,
	valueField:'key',
	displayField:'keyValue',
	mode:'local',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				addNewRow();
			}
		}
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
        header:"����",
        dataIndex:'Code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var group = Ext.getCmp("StkGrpType").getValue();
						GetPhaDrgInfo(field.getValue(),group);
					}
				}
			}
		}))
    },{
        header:"��λ",
        dataIndex:'Uom',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'ManfId',
        width:300,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(PhmanfGrid),
		renderer :Ext.util.Format.comboRenderer2(PhmanfGrid,"ManfId","Manf")	 
    },{
        header:"ԭ��׼�ĺ�",
        dataIndex:'AppNum',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>����׼�ĺ�</font>",
        dataIndex:'CurrAppNum',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.form.TextField({
        	selectOnFocus : true,
        	allowBlank : false,
        	listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var value=field.getValue();
						if(value==""){
							Msg.info("warning","��׼�ĺŲ���Ϊ�գ�");
							startCellEditing(AppNumGrid,'CurrAppNum')
						}else{
							startCellEditing(AppNumGrid,'AppExp')
						}
					}
				}
			}
        })
    },{
        header:"<font color=blue>������Ч��</font>",
        dataIndex:'AppExp',
        width:80,
        align:'left',
        sortable:true,						
		renderer : function(value){
			return formatDate(value);
		} , 
		editor : new Ext.grid.GridEditor(new Ext.form.DateField({
			format:App_StkDateFormat,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						startCellEditing(AppNumGrid,'Logo');
					}
				}
			}
		}))
    },{
        header:"<font color=blue>ע���̱�</font>",
        dataIndex:'Logo',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.form.TextField({
        	selectOnFocus : true,
        	allowBlank : false,
        	listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var value=field.getValue();
						if(value==""){
							Msg.info("warning","ע���̱겻��Ϊ�գ�");
							startCellEditing(AppNumGrid,'CurrAppNum')
						}else{
							//��ת
							startCellEditing(AppNumGrid,'ImpLicense')
						}
					}
				}
			}
        })
    },{
        header:"����ע��֤",
        dataIndex:'ImpLicense',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.form.TextField({
        	selectOnFocus : true,
        	allowBlank : true,
        	listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						startCellEditing(AppNumGrid,'ImpLicExp')
					}
				}
        	}
        })
    },{
        header:"ע��֤Ч��",
        dataIndex:'ImpLicExp',
        width:80,
        align:'left',
        sortable:true,						
		renderer : function(value){
			return formatDate(value);
		} , 
		editor : new Ext.grid.GridEditor(new Ext.form.DateField({format:App_StkDateFormat,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						startCellEditing(AppNumGrid,'AppRet');
					}
				}
			}
		}))
    },{
        header:"��������",
        dataIndex:'UpdDate',
        width:80,
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
        sortable:true,
        editor :CertificatField
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

var AppNumGrid=new Ext.grid.EditorGridPanel({
	title:'������ϸ',
	id:'AppNumGridPanel',
	region:'center',
	store:AppNumGridDs,
	loadMask:true,
	cm:AppNumGridCm,
	trackMouseOver : true,
	stripeRows : true,
	sm:new Ext.grid.CellSelectionModel({}),
	takeMouseOver:true,
	bbar:PagingToolBar,
	clicksToEdit : 1
});

///��ѯ����Panel
var AppNumConPanel=new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	autoScroll:true,
	//autoHeight : true,
	frame : true,
	region:'north',
	tbar:[findAppBT,'-',clearAppBT,'-',newAppBT,'-',repAppBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout:'column',
		style:DHCSTFormStyle.FrmPaddingV,
		defaults:{border:false},
		items:[{
			columnWidth:0.35,
			xtype:'fieldset',
			defaults:{width:250},
			items:[IncDesc]
		},{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:200},
			items:[StkGrpField]
		},{
			columnWidth:0.4,
			xtype:'fieldset',
			defaults:{width:200},
			items:[Phmanf]
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
function setAppNunGridList(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var purUomDesc=record.get("PuomDesc");

	///��鵱���Ƿ���ڴ�ҩƷ��¼
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
				// ѡ����
				var cell = AppNumGrid.getSelectionModel().getSelectedCell();
				var row = cell[0];
				var rowData = AppNumGrid.getStore().getAt(row);
				var oldAppNum = jsonData.info;
				rowData.set("InciDr",inciDr);
				rowData.set("Code",inciCode);
				rowData.set("Desc",inciDesc);
				rowData.set("Uom",purUomDesc);
				rowData.set("AppNum",oldAppNum);
				
				AppNumGrid.startEditing(cell[0], 6);
			}else{
				if(jsonData.info!=0){
					Msg.info("error","��ҩƷ������ڸ��¼�¼");
					startCellEditing(AppNumGrid,'Desc');
				}
			}
		},
		scope: this
	});
	/*
	// ѡ����
	var cell = AppNumGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = AppNumGrid.getStore().getAt(row);
	
	rowData.set("InciDr",inciDr);
	rowData.set("Code",inciCode);
	rowData.set("Desc",inciDesc);
	rowData.set("Uom",purUomDesc);
	
	AppNumGrid.startEditing(cell[0], 6);
	*/
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
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}
       var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var pageSize=PagingToolBar.pageSize;
	AppNumGrid.store.removeAll();
	AppNumGridDs.setBaseParam("StDate",StartDate);
	AppNumGridDs.setBaseParam("EndDate",EndDate);
	AppNumGridDs.setBaseParam("ManfId",ManfId);
	AppNumGridDs.setBaseParam("InciDr",IncRowid);
	AppNumGridDs.setBaseParam("StkGrpId",GrpType);
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
		},{
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'Uom',
			type : 'string'
		}, {
			name : 'ManfId',
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
		RowId:'', InciDr:'',Code:'', Desc:'',Uom:'', ManfId:'', Manf:'', AppNum:'', CurrAppNum:'', AppExp:'', 
		Logo:'', ImpLicense:'', ImpLicExp:'', UpdDate:'', UpdUser:'', AppRet:''
	});

	AppNumGridDs.add(NewRecord);
	AppNumGrid.getSelectionModel().select(AppNumGridDs.getCount() - 1, 4);
	AppNumGrid.startEditing(AppNumGridDs.getCount() - 1, 4);
	
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
function saveData()
{
	//�����¼ 
	var mr=AppNumGridDs.getModifiedRecords();
	var ListDate="";
	for(var i=0;i<mr.length;i++){
		var IrId=mr[i].data["RowId"].trim();
		var Inci = mr[i].data["InciDr"].trim();
		var ManfId = mr[i].data["ManfId"].trim();
		var Logo = mr[i].data["Logo"].trim();
		var AppRet = mr[i].data["AppRet"].trim();
		var AppExp = formatDate(mr[i].data["AppExp"]);
		var AppNum = mr[i].data["AppNum"].trim();
		var UpdDate = mr[i].data["UpdDate"].trim();
		var CurrAppNum = mr[i].data["CurrAppNum"].trim();
		var ImpLicense = mr[i].data["ImpLicense"].trim();
		var ImpLicExp = formatDate(mr[i].data["ImpLicExp"]);
		if(Inci=="")
		{
			continue;
			}
		if(ManfId=="")
		{
			Msg.info("error","���Ҳ���Ϊ��");
			return;
			}
		if(CurrAppNum=="")
		{
			Msg.info("error","��׼�ĺŲ���Ϊ��");
			return;
			}
		if(Logo=="")
		{
			Msg.info("error","ע���̱겻��Ϊ��");
			return;
			}
		if(AppExp=="")
		{
			Msg.info("error","����Ч�ڲ���Ϊ��");
			return;
		}
		if(ImpLicExp=="")
		{
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
					//AppNumGrid.store.removeAll();
					//AppNumGridDs.load({params:{start:0,limit:PagingToolBar.pageSize}});
				}else{
					if(jsonData.info==-11){
						Msg.info("warning","ҩƷ�ó�����׼�ĺ��Ѵ���!");
						return;
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
	Ext.getCmp("InciDr").setValue('');
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	Ext.getCmp("Phmanf").setValue('');
	//AppNumGrid.store.removeAll();
	AppNumGrid.getStore().removeAll();
    AppNumGrid.store.load({params:{start:0,limit:0}});
    AppNumGrid.getView().refresh();
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
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var AspAmtPanel=new Ext.Panel({
		title:'������Ϣά��'+'<font color=blue>ע:��ɫΪ������</font>',
		activeTab: 0,
		region:'north',
		height : DHCSTFormStyle.FrmHeight(1),
		items:[AppNumConPanel]
	})
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[AspAmtPanel,AppNumGrid],
		renderTo: 'mainPanel'
	});
})