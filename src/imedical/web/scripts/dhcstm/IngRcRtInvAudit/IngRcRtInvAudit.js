// /����: ��Ʊ���
// /��д�ߣ�lihui
// /��д����: 20171124
var invauditURL="dhcstm.invauditaction.csp"
var gIncId="";
var gTrType = "";			//��ǰѡ�е��ݵ�̨������(G\R)
var gGroupId=session['LOGON.GROUPID'];
var userId = session['LOGON.USERID'];
var CtLocId = session['LOGON.CTLOCID'];
var parastr=gGroupId+"^"+CtLocId+"^"+userId;
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
/// �ܾ�����
var RefuseReason = new Ext.form.TextField({
	id:'RefuseReason',
	fieldLabel:'�ܾ�����',
	anchor:'90%',
	height:30,
	selectOnFocus:true
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
// �����
var AuditFlag = new Ext.form.Checkbox({
	fieldLabel : '�����',
	id : 'AuditFlag',
	name : 'AuditFlag',
	anchor : '90%',
	width : 120,
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
				var IdStrs="";
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var ReAudUser=record.get("ReAudUser");
					var IngrNo=record.get("IngrNo");
					if ((ReAudUser=="")||(ReAudUser==null))
					{
						Msg.info("warning",IngrNo+"�������λ�δ��ˣ��������ӡ��");
						return;
					}
					var TrType=record.get("TrType");
					var RowId=record.get("RowId");
					var idstr=RowId+"^"+TrType;
					if (IdStrs=""){
						IdStrs=idstr;
					}else{
						IdStrs=IdStrs+","+idstr;
					}
				}
			    if(IdStrs==""){Msg.info("warning","û����Ҫ��ӡ�ĵ���!");return;}
			    var IdArr=GetRecRetIdStr(IdStrs).split(",");
			    alert(IdArr.length);
			    
			    
			}
		});
// ���
var AuditBT = new Ext.Toolbar.Button({
	id : "AuditBT",
	text : '���',
	tooltip : '���õ�ǰ����Ϊ<�����>',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
			if ((AllowAudit(parastr))!=0){Msg.info("warning","��û��Ȩ�����!");return;}
			Audit();
		}
});
function Audit(){
            var RcRtStr=""
			var rowDataArr = MasterGrid.getSelectionModel().getSelections();
			if (Ext.isEmpty(rowDataArr)) {
				Msg.info("warning", "��ѡ��Ҫ��˵ĵ���!");
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
			var paramstr=gGroupId+"^"+CtLocId+"^"+userId;
			if(RcRtStr==""){Msg.info("warning", "û�п�����˵ĵ���!");return}
			var url = invauditURL+"?actiontype=AuditStr";
			Ext.Ajax.request({
				url : url,
				params : {RcRtStr:RcRtStr,paramstr:paramstr},
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
						Msg.info("success", "��"+total+"�ŵ���,�ɹ����"+sucess+"����!");
						Query();
					} 
				},
				scope : this
			});
}

// ȡ�����
var CancleAuditBT = new Ext.Toolbar.Button({
	id : "CancleAuditBT",
	text : 'ȡ�����',
	tooltip : 'ȡ�����ݵ�<���>��־',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		if ((AllowAudit(parastr))!=0){Msg.info("warning","��û��Ȩ��ȡ�����!");return;}
		Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȡ����˸õ���?',
			buttons : Ext.MessageBox.YESNO,
			fn: function(b,t,o){
				if (b=='yes'){
					CancleAudit();
				}
			},
			icon : Ext.MessageBox.QUESTION
		});
	}
});
function CancleAudit(){
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ��Ҫȡ����˵ĵ���!");
				return;
			}
			var paramstr=gGroupId+"^"+CtLocId+"^"+userId;
			var RowId = rowData.get("RowId");
			var No=rowData.get("IngrNo");
			var Type = rowData.get("TrType");
			var url = invauditURL+"?actiontype=CancleAudit";
			Ext.Ajax.request({
				url : url,
				params : {RowId:RowId,Type:Type,paramstr:paramstr},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ����˳ɹ�!");
						Query();
					}else{
					    var Ret=jsonData.info;
					    if (Ret==-2){
						   Msg.info("error", No+"���ݻ�δȷ��!");
						}else if (Ret==-3){
						   Msg.info("error", No+"���ݻ�δ���!");
						}else if (Ret==-4){
						   Msg.info("error", No+"�����Ѹ���!");
						}else if (Ret==-5){
						   Msg.info("error", No+"���ݻ�δ����!");  //��������˵���ʾ
						}else{
						   Msg.info("error", "ȡ�����ʧ��:"+Ret);
						}
					    
					}
				},
				scope : this
			});
}
//�ܾ�
var AuditNoBT = new Ext.Toolbar.Button({
					id : "AuditNoBT",
					text : '��˾ܾ�',
					tooltip : '�����˾ܾ�,��ص�δȷ��',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						    if ((AllowAudit(parastr))!=0){Msg.info("warning","��û��Ȩ�޾ܾ�!");return;}
							Ext.MessageBox.show({
								title : '��ʾ',
								msg : '�Ƿ�ܾ��õ���?',
								buttons : Ext.MessageBox.YESNO,
								fn: function(b,t,o){
									if (b=='yes'){
										AuditNo();
									}
								},
								icon : Ext.MessageBox.QUESTION
							});
					}
				});
function AuditNo(){
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ��Ҫ�ܾ��ĵ���!");
				return;
			}
			var RefuseReason = Ext.getCmp('RefuseReason').getValue();
			if ((RefuseReason ==null)||(RefuseReason=="")) {
				Msg.info("warning", "ûд�ܾ�����,���ܾܾ���!");
				return;
			}
			//RefuseReason=RefuseReason.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
			var paramstr=gGroupId+"^"+CtLocId+"^"+userId;
			var RowId = rowData.get("RowId");
			var Type = rowData.get("TrType");
			var No=rowData.get("IngrNo");
			var url = invauditURL+"?actiontype=AuditNo";
			Ext.Ajax.request({
				url : url,
				params : {RowId:RowId,Type:Type,paramstr:paramstr,RefuseReason:RefuseReason},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "�ܾ���˳ɹ�!");
						Query();
					}else{
					    var Ret=jsonData.info;
					    if (Ret==-2){
						   Msg.info("error", No+"���ݻ�δȷ��!");
						}else if (Ret==-3){
						   Msg.info("error", No+"�����Ѹ���!");
						}else if (Ret==-4){
						   Msg.info("error", No+"���������!");
						}else if (Ret==-5){
						   Msg.info("error", No+"����δ���!");  //��������˵���ʾ
						}else{
						   Msg.info("error", "�ܾ����ʧ��:"+Ret);
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
	Ext.getCmp("AuditFlag").setValue(false);
	Ext.getCmp("RefuseReason").setValue("");
	MasterGrid.store.removeAll();
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}
var RcRttotalrp = new Ext.form.TextField({
	fieldLabel : '���ϼ�',
	width:200,
	id : 'RcRttotalrp',
	name : 'RcRttotalrp',
	anchor : '100%',
	readOnly : true
});
function getRcRttotalrp(){   
	var selarr = MasterGrid.getSelectionModel().getSelections();
	var totalrp=0
	var totalqty=0
	for (var i = 0; i < selarr.length; i++) {
		var rowData = selarr[i];
		var Rp = rowData.get("RpAmt");
		//var Qty= rowData.get("QtyAmt");
		totalrp=accAdd(totalrp,Rp)
		//totalqty=accAdd(totalqty,Qty)
	}
	Ext.getCmp("RcRttotalrp").setValue(" ���ϼ�:"+totalrp);
}
// ����·��
var MasterUrl = 'dhcstm.invmanageaction.csp?actiontype=query';
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
			var inciid = gIncId;  
			var phaLoc=Ext.getCmp("locField").getValue();
			var AuditFlag=(Ext.getCmp("AuditFlag").getValue()?"Y":"N");
			//����id^��ʼ����^��ֹ����^��Ӧ��id^��Ʊ��^���е���^����id
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+vendor+'^'+invno+'^'+sxno+'^'+inciid+'^'+INVNoFlag+'^'+gGroupId+'^'+CtLocId+'^'+userId+'^'+AuditFlag;
			ds.baseParams={start:0, limit:9999,strParam:ListParam};
			ds.removeAll();
		},
		load : function(store,records,options){
			if (records.length>0){
				MasterGrid.getSelectionModel().selectFirstRow();
			}
			var rowCount = MasterStore.getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = MasterStore.getAt(i);
				var State = rowData.get("State");
				if(State==1){
					MasterGrid.getView().getRow(i).style.backgroundColor = "yellow";
				}	
			}
		}
	}
});
var sm =new Ext.grid.CheckboxSelectionModel({
	listeners:{
		selectionchange:function(ssm){
			getRcRttotalrp();
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
		hidden : false
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
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�ɹ��������",
		dataIndex : 'AudDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�ɹ������",
		dataIndex : 'AudUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�����������",
		dataIndex : 'ReAudDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "���������",
		dataIndex : 'ReAudUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�ܾ�����",
		dataIndex : 'RefuseReason',
		width : 100,
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
	tbar:['->','�ϼ�:','-',RcRttotalrp],
	bbar:GridPagingToolbar
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
///��ϸ����
var SearchData=[['ȫ��','ALL'],['����','DESC'],['���','SPEC'],['�ͺ�','MODEL'],['����','BATCHNO']];
var SearchStore = new Ext.data.SimpleStore({
	fields: ['searchdesc', 'searchid'],
	data : SearchData
});
var SearchCombo = new Ext.form.ComboBox({
	store: SearchStore,
	mode: 'local', 
	anchor : '90%',
	emptyText:'',
	id:'SearchCombo',
	fieldLabel : '���˷�ʽ',
	triggerAction:'all', //ȡ���Զ�����
	displayField:'searchdesc',
	valueField : 'searchid'
});
Ext.getCmp("SearchCombo").setValue("ALL");
function SearchDetails(){
	var Searchtype=Ext.getCmp("SearchCombo").getValue(); //���˷�ʽ
	var SearchText=Ext.getCmp("SearchText").getValue();  //��������
	var SearchData=Searchtype+"^"+SearchText;
	var RcRtidstr="";
	var rowDataArr = MasterGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "û����Ҫ���˵ĵ���!");
		return;
	}
	for(i=0;i<rowDataArr.length;i++){
		var rowData=rowDataArr[i];
			var RcRtid=rowData.get('RowId');
			var type=rowData.get('TrType');
			if (RcRtidstr=="")
			 {RcRtidstr=RcRtid+"^"+type;}
			else
			 {RcRtidstr=RcRtidstr+","+RcRtid+"^"+type;}
		}
	DetailStore.setBaseParam('parstr',RcRtidstr);
	DetailStore.setBaseParam('SearchData',SearchData);
	DetailStore.removeAll();
	DetailStore.load({params:{start:0,limit:99999}});
 }
var SearchDetail = new Ext.Toolbar.Button({
	id : "SearchDetail",
	text : '����',
	tooltip : '����',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		SearchDetails();
	}
});
var SearchText = new Ext.form.TextField({
	id : 'SearchText',
	name : 'SearchText',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
				SearchDetails();
			}
		}
	}
});
// ת����ϸ
// ����·��
var DetailUrl =  'dhcstm.invmanageaction.csp?actiontype=queryItemAll';
// ͨ��AJAX��ʽ���ú�̨����
var dProxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// ָ���в���
var dFields = ["RowId", "IncId", "IncCode", "IncDesc", "Spec",
			"Manf", "BatchNo", "ExpDate", "Qty", "Uom",
			"Rp", "Sp","RpAmt","SpAmt","InvNo",
			{name:'InvDate',type:'date',dateFormat:DateFormat}, "InvMoney", "SxNo","Model","InciCodeBatNo"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var dReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : dFields
});
// ���ݼ�
var DetailStore = new Ext.data.GroupingStore({
	sortInfo:{field:'InciCodeBatNo',direction:'ASC'},
	//groupOnSort:true,
	groupField:'InciCodeBatNo',
	proxy : dProxy,
	reader : dReader
});
 Ext.ux.grid.GroupSummary.Calculations['TotalAmt'] = function(v, record, field){
        return Number(v) + Number(record.data[field]);
};
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
		header : '���ʴ�������',
		dataIndex : 'InciCodeBatNo',
		width : 80,
		align : 'left',
		summaryRenderer: function(v, params, data){
                    return "С�ƣ�";
                },
		sortable : true
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
	},{
		header : "�ͺ�",
		dataIndex : 'Model'
	}, {
		header : "����",
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'BatchNo',
		width : 150,
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
		summaryType: 'TotalAmt',
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
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		width : 80,
		align : 'right',
		hidden : true,
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "��Ʊ��",
		dataIndex : 'InvNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ����",
		dataIndex : 'InvDate',
		
		width : 100,
		align : 'center',
		sortable : true
	}, {
		header : "��Ʊ���",
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "���е���",
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true
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
	plugins: new Ext.ux.grid.GroupSummary(),
	title: '������ϸ',
	cm : DetailCm,
	clicksToEdit:1,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	tbar:new Ext.Toolbar({items:["���˷�ʽ:",SearchCombo,SearchText,SearchDetail]}),
	loadMask : true,
	view: new Ext.grid.GroupingView({
	    forceFit: true,
		headersDisabled :false,
		hideGroupedColumn :false,
        groupTextTpl: '{text} ���ƣ�{[values.rs[0].data.IncDesc]} ���{[values.rs[0].data.Spec]}�ͺţ� {[values.rs[0].data.Model]} ���ţ� {[values.rs[0].data.BatchNo]}({[values.rs.length]} {[values.rs.length > 1 ? "��" : "��"]})'
    
	})
});

var HisListTab = new Ext.ux.FormPanel({
	title:'��Ʊ���',
	tbar : [SearchBT,'-',ClearBT,'-',AuditBT,'-',AuditNoBT,'-',CancleAuditBT,'-',PrintBT],
	layout: 'column',
	items : [{
		xtype:'fieldset',
		title:"��ѯ����",		
		columnWidth : 1,
		layout:'column',
		style:'padding:5px 0px 0px 0px;',
		items : [{
			columnWidth: 0.34,
			xtype: 'fieldset',
			labelWidth: 60,
			defaults: {width: 220, border:false},
			autoHeight: true,
			border: false,
			items: [locField,Vendor,StartDate]
		},{
			columnWidth: 0.22,
			xtype: 'fieldset',
			labelWidth: 60,
			defaults: {width: 140, border:false},
			autoHeight: true,
			border: false,
			items: [INVNo,SXNo,EndDate]
		},{
			columnWidth: 0.22,
			xtype: 'fieldset',
			labelWidth: 60,	
			defaults: {width: 140, border:false},
			autoHeight: true,
			border: false,
			items: [InciDesc,INVNocombo,AuditFlag]
		},{
			columnWidth: 0.22,
			xtype: 'fieldset',
			labelWidth: 60,
			autoHeight: true,
			border: false,
			items: [RefuseReason]  ///RefuseReason
		}]
	}]
});
function AllowAudit(paramstr)
{
    	var ifallowedaudit=tkMakeServerCall("web.DHCSTM.DHCIngRcRtInv","IFAllowedAudit",paramstr);
        return ifallowedaudit;
}
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, MasterGrid, DetailGrid],
		renderTo : 'mainPanel'
	});
})