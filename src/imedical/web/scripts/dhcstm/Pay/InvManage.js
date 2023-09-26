// /����: ��Ʊ����
// /��д�ߣ�gwj
// /��д����: 2012.09.18
var invURL="dhcstm.invmanageaction.csp"
var gIncId="";
//var gTrType = "";			//��ǰѡ�е��ݵ�̨������(G\R)
var gGroupId=session['LOGON.GROUPID'];
var userId = session['LOGON.USERID'];
var CtLocId = session['LOGON.CTLOCID'];
var Userparams=gGroupId+"^"+CtLocId+"^"+userId;
var timer=null; ///����ȫ�ֱ�����ʱ��   ��ֹȫѡ��ʱ�� ִ�ж�β�ѯ������

// �ɹ�����
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'�ɹ�����',
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%',
	childCombo : 'Vendor'
});

var INVNo = new Ext.form.TextField({
	fieldLabel : '��Ʊ��',
	id : 'INVNo',
	name : 'INVNo',
	anchor : '90%'
});

var INVNocombo = new Ext.form.ComboBox({
	id:'INVNocombo',
	fieldLabel : '��Ʊ״̬',
        typeAhead: true,
        triggerAction: 'all',
        lazyRender:true,
        anchor : '90%',
        mode: 'local',
        store: new Ext.data.ArrayStore({
             id: 0,
             fields: [
                'myId',
                'displayText'
              ],
             data: [[1, 'ȫ��'], [2, '����д'],[3, 'δ��д']]
           }),
         valueField: 'myId',
         displayField: 'displayText'
});
Ext.getCmp("INVNocombo").setValue("1");


var SXNo = new Ext.form.TextField({
	fieldLabel : '���е���',
	id : 'SXNo',
	name : 'SXNo',
	anchor : '90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	params : {LocId : 'locField'}
});
	
// ��ʼ����
var StartDate = new Ext.ux.DateField({
	fieldLabel : '��ʼ����',
	id : 'StartDate',
	name : 'StartDate',
	anchor : '90%',
	
	width : 120,
	value : new Date().add(Date.DAY, - 30)
});

// ��ֹ����
var EndDate = new Ext.ux.DateField({
	fieldLabel : '��ֹ����',
	id : 'EndDate',
	name : 'EndDate',
	anchor : '90%',
	
	value : new Date()
});
// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
			id:'PrintBT',
			text : '��ӡ',
			tooltip : '�����ӡ',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var DhcIngr=record.get("RowId");
					var Type=record.get("TrType");
					if (Type=="R"){
					 PrintIngDret(DhcIngr);
					}else{
					PrintRec(DhcIngr);
					}
				}
			}
		});
var InciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'InciDesc',
	name : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
				GetPhaOrderInfo(field.getValue(),'');
			}
		}
	}
});

/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

/**
 * ���ط���
 */
function getDrugList(record) {
	if (record == null || record == "") {
		gIncId="";
		return;
	}
	gIncId = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(inciDesc);
}

//��ⵥ���տ���(ingr_reqloc_dr)
var RecReqLoc = new Ext.ux.LocComboBox({
	id : 'RecReqLoc',
	fieldLabel : '���տ���',
	anchor : '90%',
	defaultLoc : {}
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
// ���水ť
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '����',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

// ��ȷ��
var CompleteFlag = new Ext.form.Checkbox({
	fieldLabel : '��ȷ��',
	id : 'CompleteFlag',
	name : 'CompleteFlag',
	anchor : '90%',
	width : 120,
	checked : false
});
// ȷ��
var CompleteBT = new Ext.Toolbar.Button({
	id : "CompleteBT",
	text : 'ȷ��',
	tooltip : '���õ�ǰ����Ϊ<��ȷ��>',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if ((AllowAudit(Userparams))!=0){Msg.info("warning","��û��Ȩ��ȷ��!");return;}
		Confirm();
		}
});
function Confirm(){
            var RcRtStr=""
			var rowDataArr = MasterGrid.getSelectionModel().getSelections();
			if (Ext.isEmpty(rowDataArr)) {
				Msg.info("warning", "��ѡ��Ҫȷ�ϵĵ���!");
				return;
			}
			for(i=0;i<rowDataArr.length;i++)
				{
				var rowData=rowDataArr[i];
				var RowId = rowData.get("RowId");
				var Type = rowData.get("TrType");
				var RcRtInfo=RowId+"#"+Type;
				if (RcRtStr=="")
				{
				RcRtStr=RcRtInfo;}
				else{
				RcRtStr=RcRtStr+"^"+RcRtInfo;
				}
				}
			if(RcRtStr==""){Msg.info("warning", "û�п���ȷ�ϵĵ���!");return}
			var url = "dhcstm.invauditaction.csp?actiontype=ConfirmStr";
			Ext.Ajax.request({
				url : url,
				params : {RcRtStr:RcRtStr,User:userId},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						var ret=jsonData.info;// ��˵���
						var retarr=ret.split(",");
						var total=retarr[0];
						var sucess=retarr[1];
						Msg.info("success", "��"+total+"�ŵ���,�ɹ�ȷ��"+sucess+"����!");
						Query();
					} 
				},
				scope : this
			});
}
// ȡ��ȷ��
var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : 'ȡ��ȷ��',
	tooltip : 'ȡ�����ݵ�<ȷ��>��־',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if ((AllowAudit(Userparams))!=0){Msg.info("warning","��û��Ȩ��ȡ��!");return;}
		Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȡ��ȷ��?',
			buttons : Ext.MessageBox.YESNO,
			fn: function(b,t,o){
				if (b=='yes'){
					CancleConfirm();
				}
			},
			icon : Ext.MessageBox.QUESTION
		});
	}
});
function CancleConfirm(){
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ��Ҫȡ��ȷ�ϵĵ���!");
				return;
			}
			var RowId = rowData.get("RowId");
			var Type = rowData.get("TrType");
			var No = rowData.get("IngrNo");
			var url = "dhcstm.invauditaction.csp?actiontype=CancleConfirm";
			Ext.Ajax.request({
				url : url,
				params : {RowId:RowId,Type:Type},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ��ȷ�ϳɹ�!");
						Query();
					}else{
					    var Ret=jsonData.info;
					    if (Ret==-2){
						    Msg.info("error", No+"���ݻ�δȷ��!");
						}/*else if (Ret==-3){
						    Msg.info("error", No+"���������,����ȡ��!");
						}*/else{
							Msg.info("error", "ȡ��ȷ��ʧ��:"+Ret);
						}
					}
				},
				scope : this
			});
}
/**
 * ��ѯ����
 */
function Query() {
	var phaLoc = Ext.getCmp("locField").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ��ɹ�����!");
		return;
	}
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
	MasterStore.load();
}

/**
 * ��շ���
 */
function clearData() {
	SetLogInDept(locField.getStore(),"locField");
	Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
	Ext.getCmp("EndDate").setValue(new Date());
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("INVNo").setValue("");
	Ext.getCmp("SXNo").setValue("");
	Ext.getCmp("InciDesc").setValue("");
	MasterGrid.store.removeAll();
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}

/**
 * ���淢Ʊ��Ϣ
 */
function Save() {
	var successNum = 0;
	var rowCount = DetailGrid.getStore().getCount();
	var mr = DetailStore.getModifiedRecords();
	var len=mr.length;
	if (rowCount<=0||len<=0){
	   Msg.info("waring","û����Ҫ�������ϸ!");
	}
	for (var i=0; i<len; i++){
		var rowData = mr[i];
		var RowId = rowData.get('RowId');
		var invNo = rowData.get("InvNo");
		var invAmt = rowData.get("InvMoney");
		var invDate = Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
		var sxNo=rowData.get("SxNo");
		var itmType= rowData.get("Type");
		var StrParam = itmType+"^"+RowId+"^"+invNo+"^"+invAmt+"^"+invDate
					+"^"+sxNo;
		var ret = tkMakeServerCall("web.DHCSTM.DHCINGdRecInv","UpdateINV",StrParam);
		if(ret != 0){
			var InciDesc = rowData.get('IncDesc');
			Msg.info("error", IncDesc+"��Ʊ��Ϣ����ʧ��!");
		}else if(++successNum == len){
			Msg.info("success","����ɹ�!");
			DetailStore.commitChanges();
	        DetailStore.reload();
		}
	}

}

//ѡ����Ҫ���ƻ����������Ϣ
var CopyTypeData=[['��Ʊ��','1'],['���е���','2'],['��Ʊ����','3']];
	
		var CopyTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : CopyTypeData
		});

		var CopyTypeCombo = new Ext.form.ComboBox({
			store: CopyTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'CopyTypeCombo',
			fieldLabel : '���ƻ��������',
			triggerAction:'all', //ȡ���Զ�����
			valueField : 'typeid'
		});
		Ext.getCmp("CopyTypeCombo").setValue("1");

// ���Ʒ�Ʊ�����е���
var CopyNo = new Ext.Toolbar.Button({
	id : "CopyINVNo",
	text : '���Ƶ���',
	tooltip : '���Ƶ���',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Copy();
	}
});
function Copy(){
	var type=Ext.getCmp("CopyTypeCombo").getValue();
	var Rowcount=DetailGrid.getStore().getCount();
	//��ȡ��һ�еķ�Ʊ��
	var rowdata1=DetailGrid.getStore().getAt(0);
	var invno1=rowdata1.get("InvNo");
	var sxno1=rowdata1.get("SxNo");
	var InvDate1=rowdata1.get("InvDate");
	if ((type==1)&&((invno1=="")||(invno1==null))){
		Msg.info("warning","���ȸ���һ�з�Ʊ�Ÿ�ֵ!");
		return false;
	}
	if ((type==2)&&((sxno1=="")||(sxno1==null))){
	Msg.info("warning","���ȸ���һ�����е��Ÿ�ֵ!");
	return false;
	}
	if ((type==3)&&((InvDate1=="")||(InvDate1==null))){
	Msg.info("warning","���ȸ���һ�з�Ʊ���ڸ�ֵ!");
	return false;
	} 
    for (i=1;i<Rowcount;i++)
      { 
        var Rowdata=DetailGrid.getStore().getAt(i);
        var invnotmp=Rowdata.get("InvNo");
        var sxnotmp=Rowdata.get("SxNo");
		var invdatetmp=Rowdata.get("InvDate");
        if ((type==1)&&((invnotmp=="")||(invnotmp==null))){
            Rowdata.set("InvNo",invno1);
            Rowdata.set("InvDate",InvDate1);
        }else if ((type==2)&&((sxnotmp=="")||(sxnotmp==null))){
            Rowdata.set("SxNo",sxno1);
        }else if ((type==3)&&((invdatetmp=="")||(invdatetmp==null))){
            Rowdata.set("InvDate",InvDate1);
        }else{return false;}
	  }
    }

// �����Ʊ��
var ClearNo = new Ext.Toolbar.Button({
	id : "ClearINVNo",
	text : '�������',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Clear();
	}
});

//�����Ʊ��Ϣ
function Clear(){
	var type=Ext.getCmp("CopyTypeCombo").getValue();
	var Rowcount=DetailGrid.getStore().getCount();
    for (i=0;i<Rowcount;i++)
      { 
        var Rowdata=DetailGrid.getStore().getAt(i);
        if (type==1){
            Rowdata.set("InvNo","");
        }else if(type==2){
	        Rowdata.set("SxNo","");
	    }else if(type==3){
	        Rowdata.set("InvDate","");
	    }
	  }
    }

// ����·��
var MasterUrl = invURL + '?actiontype=query';
// ͨ��AJAX��ʽ���ú�̨����
var mProxy = new Ext.data.HttpProxy({
	url : MasterUrl,
	method : "POST"
});

// ָ���в���
var mFields = ['RowId', 'VendorName', 'PhaLoc', 'IngrNo', 'CreateDate',
		'CreateUser', 'AuditDate', 'AuditUser', 'RpAmt', 'PayedAmt',
		'PayOverFlag', 'TrType', 'State', 'ComDate', 'ComTime',
		'ComUser', 'AudDate', 'AudTime', 'AudUser', 'ReAudDate', 'ReAudTime', 'ReAudUser','RefuseReason'];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var mReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId"+"TrType",
	fields : mFields
});
// ���ݼ�
var MasterStore = new Ext.data.Store({
	proxy : mProxy,
	reader : mReader,
	listeners:{
		'beforeload':function(ds){
			var vendor = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var invno = Ext.getCmp("INVNo").getValue();
			var sxno = Ext.getCmp("SXNo").getValue();
			var INVNoFlag=Ext.getCmp("INVNocombo").getValue();
			if (Ext.getCmp('InciDesc').getValue()==''){
				gIncId='';
			}
			var inciid = gIncId;  //Ext.getCmp("InciDesc").getValue();
			var phaLoc=Ext.getCmp("locField").getValue();
			var RecReqLoc = Ext.getCmp('RecReqLoc').getValue();
			var CompleteFlag=(Ext.getCmp("CompleteFlag").getValue()?"Y":"N");  //��ȷ��
			//����id^��ʼ����^��ֹ����^��Ӧ��id^��Ʊ��^���е���^����id^��Ʊ״̬^�����տ���
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+vendor+'^'+invno+'^'+sxno+'^'+inciid+'^'+INVNoFlag+'^'+RecReqLoc+'^'+Userparams+'^'+CompleteFlag;
			//var Page=GridPagingToolbar.pageSize;
			ds.baseParams={start:0, limit:9999,strParam:ListParam};
			ds.removeAll();
		},
		load : function(store,records,options){
			if (records.length>0){
				MasterGrid.getSelectionModel().selectFirstRow();
			}
		}
	}
});
var sm =new Ext.grid.CheckboxSelectionModel({
		listeners:{
		selectionchange:function(ssm){
			clearTimeout(timer)
			timer=change.defer(100,this,[ssm])
		} 
	}
});
	function change(ssm){
		var recarr=ssm.getSelections();
		var count=recarr.length;
		var parstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('RowId');
			var type=rec.get('TrType');
			if (parstr=="")
			 {parstr=reqid+"^"+type}
			 else
			 {parstr=parstr+","+reqid+"^"+type}
		}
	DetailStore.setBaseParam('parstr',parstr);
	DetailStore.removeAll();
	DetailStore.load({params:{start:0,limit:99999}});

	}
var MasterCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),sm,
	{
		header : '����',
		dataIndex : 'TrType',
		width : 60,
		renderer : function(value){
			var TrName = value;
			if(value == 'G'){
				TrName = '��ⵥ';
			}else if (value == 'R'){
				TrName = '�˻���';
			}
			return TrName;
		}
	},{
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	},{
		header : "��Ӧ��",
		dataIndex : 'VendorName',
		width : 240,
		align : 'left',
		sortable : true
	}, {
		header : "�ɹ�����",
		dataIndex : 'PhaLoc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "���ݺ�",
		dataIndex : 'IngrNo',
		width : 160,
		align : 'left',
		sortable : true
	}, {
		header : "�Ƶ�����",
		dataIndex : 'CreateDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : "�Ƶ���",
		dataIndex : 'CreateUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�������",
		dataIndex : 'AuditDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�����",
		dataIndex : 'AuditUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "ȷ������",
		dataIndex : 'ComDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "ȷ����",
		dataIndex : 'ComUser',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "�Ѹ����",
		dataIndex : 'PayedAmt',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "�����־",
		dataIndex : 'PayOverFlag',
		width : 60,
		align : 'center',
		sortable : true
	}]);
	
MasterCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:PageSize,
	displayInfo:true
});

var MasterGrid = new Ext.grid.GridPanel({
	region: 'center',
	title: '��ⵥ(�˻���)',
	cm : MasterCm,
	sm : sm,
	store : MasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:GridPagingToolbar,
	viewConfig:{
		getRowClass : function(record,rowIndex,rowParams,store){ 
			var State=record.get("State");
			if(State=="1"){
				return 'classYellow';
			}					
		}
	}
});
/*
// ��ӱ�񵥻����¼�
MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
	gTrType = MasterStore.getAt(rowIndex).get("TrType");
	var parref = MasterStore.getAt(rowIndex).get("RowId");
	DetailStore.setBaseParam('TrType',gTrType);
	DetailStore.setBaseParam('parref',parref);
	DetailStore.removeAll();
	DetailStore.load({params:{start:0,limit:99999}});
});
*/
// ת����ϸ
// ����·��
var DetailUrl =  invURL + '?actiontype=queryItemAll';
// ͨ��AJAX��ʽ���ú�̨����
var dProxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// ָ���в���
var dFields = ["RowId", "IncId", "IncCode", "IncDesc", "Spec",
			"Manf", "BatchNo", "ExpDate", "Qty", "Uom",
			"Rp", "Sp","RpAmt","SpAmt","InvNo",
			{name:'InvDate',type:'date',dateFormat:DateFormat}, "InvMoney", "SxNo","Type","InvCode"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var dReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : dFields
});
// ���ݼ�
var DetailStore = new Ext.data.Store({
	proxy : dProxy,
	reader : dReader
});

var DetailCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "����Id",
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
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'IncDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "���",
		dataIndex : 'Spec',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'BatchNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "Ч��",
		dataIndex : 'ExpDate',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'Uom',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "�ۼ�",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 80,
		align : 'right',
		hidden : true,
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		width : 80,
		align : 'right',
		hidden : true,
		sortable : true
	}, {
		header : "��Ʊ��",
		dataIndex : 'InvNo',
		width : 100,
		align : 'left',
		sortable : true,
		editor:new Ext.form.TextField({
			listeners:{
				'blur':function(field){
					var invNo=field.getValue();
					var IngrRecord=MasterGrid.getSelectionModel().getSelected();
					var Ingr=IngrRecord.get('RowId');
					var flag=InvNoValidator(invNo,Ingr);
					if(flag==false){
						Msg.info("warning","��Ʊ��"+invNo+"������������ⵥ��!");
						//field.setValue("");
					}
				}
			}
		})
	}, {
		header : "��Ʊ����",
		dataIndex : 'InvCode',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "��Ʊ����",
		dataIndex : 'InvDate',
		
		width : 100,
		align : 'center',
		sortable : true,
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor:new Ext.ux.DateField({
		})
	}, {
		header : "��Ʊ���",
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		sortable : true,
		editor:new Ext.form.NumberField({})
	}, {
		header : "���е���",
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true,
		editor:new Ext.form.TextField({})
},{
		header : "Type",
		dataIndex : 'Type',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
}]);
	
var GridDetailPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:PageSize,
	displayInfo:true
});

var DetailGrid = new Ext.grid.EditorGridPanel({
	region: 'south',
	split: true,
	height: 240,
	minSize: 200,
	maxSize: 350,
	title: '������ϸ',
	cm : DetailCm,
	clicksToEdit:1,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	tbar:new Ext.Toolbar({items:[CopyTypeCombo,CopyNo,ClearNo,"*����������ѡ������ݽ��з�Ʊ�Ż������е��ŵĸ������*"]}),
	//bbar:GridDetailPagingToolbar,
	loadMask : true
});

var HisListTab = new Ext.ux.FormPanel({
	title:'��Ʊ����',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT,'-',CompleteBT,'-',CancleCompleteBT,'-',PrintBT],
	layout: 'column',
	items : [{
		xtype:'fieldset',
		title:"��ѯ����",
		columnWidth : 1,
		layout:'column',
		style:'padding:5px 0px 0px 0px;',
		defaults : {xtype: 'fieldset', border: false},
		labelWidth: 60,
		items : [{
			columnWidth: 0.2,
			items: [locField,Vendor]
		},{
			columnWidth: 0.2,
			items: [StartDate,EndDate]
		},{
			columnWidth: 0.2,
			items: [INVNo,SXNo]
		},{
			columnWidth: 0.2,
			items: [InciDesc,INVNocombo]
		},{
			columnWidth: 0.2,
			items: [RecReqLoc,CompleteFlag]
		}]
	}]
});
function AllowAudit(paramstr)
{
    	var ifallowedaudit=tkMakeServerCall("web.DHCSTM.DHCIngRcRtInv","IFAllowedAudit",paramstr);
        return ifallowedaudit;
}
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var CtLocId = session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, MasterGrid, DetailGrid],
		renderTo : 'mainPanel'
	});
})