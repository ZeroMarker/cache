// ����:��������(����<���������>)
// ��д����:2012-08-10
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var rowDelim=xRowDelim();


// ������
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '������',
	id : 'LocField',
	emptyText : '������...',
	groupId:gGroupId,
	linkloc:CtLocId,
	protype : INREQUEST_LOCTYPE,
	listeners:
	{
		'select':function(cb)
		{
			var requestLoc=cb.getValue();
			var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
			var mainArr=defprovLocs.split("^");
	        var defprovLoc=mainArr[0];
	        var defprovLocdesc=mainArr[1];
			addComboData(Ext.getCmp('supplyLocField').getStore(),defprovLoc,defprovLocdesc);
			Ext.getCmp("supplyLocField").setValue(defprovLoc);
			var provLoc=Ext.getCmp('supplyLocField').getValue();
			Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);	
		}
	}
});

var supplyLocField = new Ext.ux.ComboBox({
	id:'supplyLocField',
	fieldLabel:'��������',
	listWidth:210,
	emptyText:'��������...',
	displayField:'Description',
	valueField:'RowId',
	store:frLocListStore,
	params:{LocId:'LocField'},
	filterName:'FilterDesc',
	listeners:
	{
		'select':function(cb)
		{
			var provLoc=cb.getValue();
			var requestLoc=Ext.getCmp('LocField').getValue();
			Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);
		}
	}
});

var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});
//�Զ����ص�½���ҵ�Ĭ�Ϲ�������
LocField.fireEvent('select',LocField);
var reqOrder = new Ext.form.TextField({
	id:'reqOrder',
	fieldLabel:'���󵥺�',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	readOnly:true
});

var IntSigner = new Ext.form.Checkbox({
	id: 'IntSigner',
	fieldLabel:'��װ��ȡ��',
	allowBlank:true
});

var ManagerDrugSigner = new Ext.form.Checkbox({
	id:'ManagerDrugSigner',
	fieldLabel:'�ص��ע��־',
	allowBlank:true
});

var INRequestAuxByStkLimitGrid="";
//��������Դ
var INRequestAuxByStkLimitGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryFZByLimit',method:'GET'});
var INRequestAuxByStkLimitGridDs = new Ext.data.Store({
	proxy:INRequestAuxByStkLimitGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty : "results"
	}, [
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'uom'},
		{name:'qty'},
		{name:'minQty'}, //����
		{name:'maxQty'}, //����
		{name:'repQty'},
		{name:'incil'},
		{name:'pUom'},
		{name:'pUomDesc'},
		{name:'sbdesc'}, //��λ
		{name:'reqQty'}, //��������
		{name:'realReqQty'},
		{name:'pid'},
		{name:'ind'}
	]),
	remoteSort:false,
	pruneModifiedRecords:true,
	listeners:{
		'load':function(ds){
			if (ds.getCount()>0) {
				Ext.getCmp('LocField').setDisabled(true);
				Ext.getCmp('supplyLocField').setDisabled(true);
				Ext.getCmp('group').setDisabled(true);
				Ext.getCmp('IntSigner').setDisabled(true);
				Ext.getCmp('ManagerDrugSigner').setDisabled(true);
			}else{
				Ext.getCmp('LocField').setDisabled(false);
				Ext.getCmp('supplyLocField').setDisabled(false);
				Ext.getCmp('group').setDisabled(false);
				Ext.getCmp('IntSigner').setDisabled(false);
				Ext.getCmp('ManagerDrugSigner').setDisabled(false);
			}
		}
	}
});
//ģ��
var INRequestAuxByStkLimitGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header:"����rowid",
		dataIndex:'inci',
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
		width:250,
		align:'left',
		sortable:true
	},{
		header:"��λ",
		dataIndex:'pUomDesc',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"����������",
		dataIndex:'reqQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"ʵ��������",
		dataIndex:'realReqQty',
		width:120,
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'reqQtyField',
			allowBlank:false
		})
	},{
		header:"��ǰ���",
		dataIndex:'qty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"�������",
		dataIndex:'maxQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"�������",
		dataIndex:'minQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"��׼���",
		dataIndex:'repQty',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"pid",
		dataIndex:'pid',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"ind",
		dataIndex:'ind',
		width:80,
		align:'left',
		sortable:true,
		hidden:true
	}
]);

function getPid(){
	var pid="";
	if(INRequestAuxByStkLimitGridDs.getCount()>0){
		var record=INRequestAuxByStkLimitGridDs.getAt(0);
		pid=record.get("pid")
	}
	return pid;
}

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width:70,
	height:30,
	handler:function(){
		INRequestAuxByStkLimitGridDs.removeAll();
		//��������
		var frLoc = Ext.getCmp('supplyLocField').getValue();
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", "��ѡ�񹩸�����!");
			return false;
		}
		//������
		var toLoc = Ext.getCmp('LocField').getValue();
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", "��ѡ��������!");
			return false;
		}
		/*���ź͹������Ų�����ͬ*/
		if (frLoc==toLoc){
			Msg.info("error", "�����ź͹������Ų�����ͬ!");
			return false;
		}
		//����
		var groupId = Ext.getCmp('group').getValue();
		//alert(groupId)
		if ((groupId=='')||(groupId==null)){
			Msg.info("error", "���鲻��Ϊ��!");
			return false;
		}
		//�ص��ע��־
		var man = (Ext.getCmp('ManagerDrugSigner').getValue()==true?1:0);
		//ȡ����־
		var round = (Ext.getCmp('IntSigner').getValue()==true?'Y':'N');
		var pid=getPid();
		strPar = toLoc+"^"+frLoc+"^"+groupId+"^"+man+"^"+round;
		INRequestAuxByStkLimitGridDs.load({
			params:{start:0,limit:pagingToolbar.pageSize,sort:'code',dir:'desc',strPar:strPar+"^"+pid+"^0"},
			callback:function(r,options, success){
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
				}
			}
		});
	}
});

//�������쵥
function CreateReq(){
	var frLoc = Ext.getCmp('supplyLocField').getValue();
	if((frLoc=="")||(frLoc==null)){
		Msg.info("warning", "��ѡ�񹩸�����!");
		return;
	}
	//������
	var toLoc = Ext.getCmp('LocField').getValue();
	if((toLoc=="")||(toLoc==null)){
		Msg.info("warning", "��ѡ��������!");
		return;
	}
	//����
	var scg = Ext.getCmp('group').getValue();
	var reqInfo=frLoc+"^"+toLoc+"^"+UserId+"^"+scg;
	var count = INRequestAuxByStkLimitGridDs.getCount();
	if(count==0){
		Msg.info("warning","û��������ϸ,������������!");
		return;
	}
	var record=INRequestAuxByStkLimitGridDs.getAt(0);
	var pid=record.get("pid");
	if(pid==null || pid==""){
		Msg.info("warning","û��������ϸ,������������!");
		return;
	}

	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=CreateReqByLim&Pid='+pid+'&ReqInfo='+reqInfo,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "�������󵥳ɹ�!");
				var infoArr = jsonData.info.split("^");
				var req = infoArr[0];
				var reqNo = infoArr[1];
				Ext.getCmp("reqOrder").setValue(reqNo);

				location.href="dhcstm.inrequest.csp?reqByabConsume="+req;
			}else{
				Msg.info("error", "��������ʧ��:"+jsonData.info);
			}
		},
		scope : this
	});
}
var CreateBtn = new Ext.Toolbar.Button({
	text:'��������',
	tooltip:'�����������',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:false,
	handler:function(){
		CreateReq();
	}
});
var productReqOrder = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:false,
	handler:function(){
		var count = INRequestAuxByStkLimitGridDs.getCount();
		if(count==0){
			Msg.info("warning","û��������ϸ,��ֹ����!");
			return;
		}
		var str = "";
		var pid="";
		for(var index=0;index<count;index++){
			var rec = INRequestAuxByStkLimitGridDs.getAt(index);
			if(rec.data.newRecord || rec.dirty){
				pid=rec.data["pid"];
				var ind = rec.data['ind'];
				var qty = rec.data['realReqQty'];

				var tmp = ind+"^"+qty;
				if(str==""){
					str = tmp;
				}else{
					//str = str +","+ tmp;
					str = str + rowDelim+ tmp;
				}
			}
		}
		if(pid==""){
			Msg.info("warning","û��������ϸ,��ֹ����!");
			return;
		}

		Ext.Ajax.request({
			url : 'dhcstm.inrequestaction.csp?actiontype=SaveForAuxByLim',
			params:{Pid:pid,ListData:str},
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
//					var reqNo=jsonData.info;
//					Ext.getCmp('reqOrder').setValue(reqNo);  //���󵥺�
				}else{
					Msg.info("error", "����ʧ��:"+jsonData.info);
				}
			},
			scope : this
		});
	}
});
var clear = new Ext.Toolbar.Button({
	id:'clearData',
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.Msg.show({
			title:'��ʾ',
			msg: '�Ƿ�ȷ����ո�����������?(ע:������Ϊ��ʱͳ�ƽ��,������ͳ��.)',
			buttons: Ext.Msg.YESNO,
			fn: function(btn){
				if (btn=='yes') {clearDataGrid();}
			}
		})
	}
});

function clearDataGrid()
{
	//�����ʱglobal����
	var record=INRequestAuxByStkLimitGridDs.getAt(0);
	if (record!=undefined&&record!=""){
		var pid=record.get("pid");
		KillTmpGlobal(pid) ;
	}
	INRequestAuxByStkLimitGrid.getStore().removeAll();
	INRequestAuxByStkLimitGrid.getView().refresh();
	Ext.getCmp('supplyLocField').setDisabled(false);
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('group').setDisabled(false);
	Ext.getCmp('IntSigner').setDisabled(false);
	Ext.getCmp('ManagerDrugSigner').setDisabled(false);
	
	Ext.getCmp("supplyLocField").setValue("");
	Ext.getCmp("LocField").setValue("");
	Ext.getCmp("group").setValue("");
	Ext.getCmp("IntSigner").setValue(false);
	Ext.getCmp("ManagerDrugSigner").setValue(false);
	SetLogInDept(LocField.getStore(),"LocField");
	
	var requestLoc=Ext.getCmp("LocField").getValue();
	var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
	var mainArr=defprovLocs.split("^");
	var defprovLoc=mainArr[0];
	var defprovLocdesc=mainArr[1];
	addComboData(Ext.getCmp('supplyLocField').getStore(),defprovLoc,defprovLocdesc);
	Ext.getCmp("supplyLocField").setValue(defprovLoc);
	var provLoc=Ext.getCmp('supplyLocField').getValue();
	Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);
}

//��ʼ��Ĭ��������
INRequestAuxByStkLimitGridCm.defaultSortable = true;

var pagingToolbar = new Ext.PagingToolbar({
	store:INRequestAuxByStkLimitGridDs,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='rowid';
		B[A.dir]='desc';
		var pid=getPid();
		B['strPar']=strPar+"^"+pid+"^1";  //1:��ʾ��ҳ
		var data=INRequestAuxByStkLimitGridDs.getModifiedRecords();
		if(data.length>0){
			Msg.info("warning","��ҳ����δ����ļ�¼�����ȱ��棡");
			return;
		}
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
INRequestAuxByStkLimitGrid = new Ext.grid.EditorGridPanel({
	store:INRequestAuxByStkLimitGridDs,
	cm:INRequestAuxByStkLimitGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});

function KillTmpGlobal(pid)
{
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=KillTmpGlobal',
		params:{Pid:pid},
		method : 'POST',
		success:function(){

		},
		failure:function(){
			Msg.info('error','��̨��ʱ������մ���!')
		}
	});
}


Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var formPanel = new Ext.form.FormPanel({
		title : '����������Ƶ�(��������)',
		region:'north',
		labelAlign : 'right',
		autoHeight : true,
		frame : true,
		bodyStyle : 'padding:5px;',
		tbar:[find,'-',productReqOrder,'-',CreateBtn,'-',clear],
		items : [{
			title : 'ѡ����Ϣ',
			xtype : 'fieldset',
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : 0.25,
				items : [LocField, supplyLocField]
			},{
				columnWidth : 0.25,
				items : [group]
			},{
				columnWidth : 0.25,
				items : [IntSigner, ManagerDrugSigner]
			}]
		}]
	});

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INRequestAuxByStkLimitGrid]
	});
});
