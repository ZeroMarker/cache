// ����:��������(����<ת�����>)
// ��д����:2012-08-9
//=========================����ȫ�ֱ���=================================
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];

// ������
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '������',
	id : 'LocField',
	name : 'LocField',
	emptyText : '������...',
	groupId:gGroupId,
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
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
			Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);
		}
	}
});

var supplyLocField = new Ext.ux.ComboBox({
	id:'supplyLocField',
	fieldLabel:'��������',
	store:frLocListStore,	 
	params:{LocId:'LocField'},
	filterName:'FilterDesc',
	displayField:'Description',
	valueField:'RowId',
	listWidth:210,
	emptyText:'��������...',
	//groupId:gGroupId,
	defaultLoc:{},
	listeners:{
		'select':function(cb)
		{
			var provLoc=cb.getValue();
			var requestLoc=Ext.getCmp('LocField').getValue();
			Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);			
		}
	}
});

//����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});
//�Զ����ص�½���ҵ�Ĭ�Ϲ�������
LocField.fireEvent('select',LocField);
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
    allowBlank:true,
	fieldLabel:'��',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
    allowBlank:true,
	fieldLabel:'��',
	anchor:'90%',
	value:new Date()
});

var days = new Ext.form.NumberField({
	id:'days',
	fieldLabel:'�ο�����',
	allowBlank:true,
	width:120,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	value:30,
	selectOnFocus:true
});

var isInt = new Ext.form.Checkbox({
	id: 'isInt',
	fieldLabel:'����������ȡ��',
	allowBlank:true
});

var isIncludeZero = new Ext.form.Checkbox({
	id:'isIncludeZero',
	fieldLabel:'����������=0',
	allowBlank:true
});

var useInt = new Ext.form.Checkbox({
	id: 'useInt',
	fieldLabel:'ʹ�ý���������',
	allowBlank:true
});

var isCheckKC = new Ext.form.Checkbox({
	id:'isCheckKC',
	fieldLabel:'��鲿�ſ��',
	allowBlank:true
});

//=========================����ȫ�ֱ���=================================
//=========================��������Ϣ=================================
var INRequestAuxByTransferGrid="";
//��������Դ
var INRequestAuxByTransferGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryFZByTrans',method:'GET'});
var INRequestAuxByTransferGridDs = new Ext.data.Store({
	proxy:INRequestAuxByTransferGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'stkQty'}, //���
		{name:'avaQty'}, //���ÿ�ҽ����
		{name:'dailyDispQty'}, //�շ�ҩ��
		{name:'reqQtyAll'}, //days��������
		{name:'applyQty'}, //����������
		{name:'ActualQty'} //ʵ��������
	]),
    remoteSort:false
});
//ģ��
var INRequestAuxByTransferGridCm = new Ext.grid.ColumnModel([
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
        width:80,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'uomDesc',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"�����",
        dataIndex:'stkQty',
        width:70,
        align:'right',
        sortable:true
    },{
        header:"������",
        dataIndex:'avaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"������",
        dataIndex:'dailyDispQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����������",
        dataIndex:'applyQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"ʵ��������",
        dataIndex:'ActualQty',
        width:150,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'actualQtyField',
            allowBlank:false
        })
    }
]);

var find = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_find',
	width:70,
	height:30,
	handler:function(){
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
		//��ʼ����
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error", "��ѡ��ʼ����!");
			return false;
		}
		//��������
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error", "��ѡ���������!");
			return false;
		}
		//�ο�����
		var day = Ext.getCmp('days').getValue();
		if((day=="")||(day==null)){
			Msg.info("error", "����д�ο�����!");
			return false;
			}
		//����
		var groupId = Ext.getCmp('groupField').getValue();
		//ʹ�ý���������
		var useInt = (Ext.getCmp("useInt").getValue()==true?'Y':'N');
		//����������ȡ��
		var roundInt = (Ext.getCmp('isInt').getValue()==true?'Y':'N');
		//��鲿�ſ��
		var checkKC = (Ext.getCmp('isCheckKC').getValue()==true?'Y':'N');		
		//����������=0
		var includeZero = (Ext.getCmp('isIncludeZero').getValue()==true?'Y':'N');
		
		//alert(useInt)
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc+"^"+useInt+"^"+roundInt+"^"+checkKC+"^"+includeZero;
		
		INRequestAuxByTransferGridDs.load({params:{strPar:strPar}});
		if(INRequestAuxByTransferGridDs.getCount()>0){
			productReqOrder.enable();
		}
	}
});

var productReqOrder = new Ext.Toolbar.Button({
	text:'��������',
    tooltip:'��������',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
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
		//����
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error", "��ѡ������!");
			return false;
		}
		
		var count = INRequestAuxByTransferGridDs.getCount();
		if(count==0){
			Msg.info("error","û�г���������ϸ,��ֹ����!");
			return false;
		}else{
			var str = "";
			var colRemark="";
			for(var index=0;index<count;index++){
				var rec = INRequestAuxByTransferGridDs.getAt(index);
				var inc = rec.data['inci'];
				var ActualQty = rec.data['ActualQty'];
				if((inc!=null)&&(inc!="")&&(ActualQty!=null)&&(ActualQty!="")){
					var rowid = "";
					var uom = rec.data['uom'];
					var qty = rec.data['ActualQty'];
					var tmp = rowid+"^"+inc+"^"+uom+"^"+qty+"^"+colRemark+"^"+scg;
					if(str==""){
						str = tmp;
					}else{
						str = str + xRowDelim() + tmp;
					}
				}
			}
			if(str==""){Msg.info("error", "û��������Ҫ����!");return false;};
			var req = "";
			var status = "";
			var remark = "";
			var reqInfo = frLoc+"^"+toLoc+"^"+UserId+"^"+scg+"^"+status+"^"+remark;
			
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=save',
				params:{req:req,reqInfo:reqInfo,data:str},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "����ɹ�!");
						req = jsonData.info;
						location.href="dhcstm.inrequest.csp?reqByabConsume="+req;
					}else{
						if(jsonData.info==-1){
							Msg.info("error", "������ʧ��!");
						}else if(jsonData.info==-99){
							Msg.info("error", "�������ʧ��!");
						}else if(jsonData.info==-2){
							Msg.info("error", "�������ʧ��!");
						}else if(jsonData.info==-5){
							Msg.info("error", "��ϸ����ʧ��!");
						}else if(jsonData.info==-4){
							Msg.info("error", "����������ʧ��!");
						}else if(jsonData.info==-3){
							Msg.info("error", "������ʧ��!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
					}
				},
				scope : this
			});
		}
	}
});

//��ʼ��Ĭ��������
INRequestAuxByTransferGridCm.defaultSortable = true;
/*
var pagingToolbar = new Ext.PagingToolbar({
    store:INRequestAuxByTransferGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['strPar']=strPar;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});
*/
//���
INRequestAuxByTransferGrid = new Ext.grid.EditorGridPanel({
	store:INRequestAuxByTransferGridDs,
	cm:INRequestAuxByTransferGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true/*,
	bbar:pagingToolbar*/
});
//=========================��������Ϣ=================================

//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.form.FormPanel({
		region:'north',
		autoHeight:true,
		title:'��������(����<ת�����>)',
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding:5px 0 0 0;',
		tbar:[find,'-',productReqOrder],
		items : [{
				layout : 'column',	
				xtype : 'fieldset',
				title : 'ѡ����Ϣ',
				//autoHeight : true,
				style:'padding:0px 0px 0px 0px',
				items : [{
						columnWidth : .3,
						layout : 'form',
						items : [LocField,supplyLocField]
				},{
						columnWidth : .15,
						layout : 'form',
						labelWidth : 30,
						items : [startDateField,endDateField]
				},{
						columnWidth : .23,
						layout : 'form',
						labelWidth : 60,
						items : [days,groupField]
				},{
						columnWidth : .15,
						layout : 'form',
						labelWidth : 120,
						items : [useInt,isInt]
				},{
						columnWidth : .15,
						layout : 'form',
						items : [isCheckKC,isIncludeZero]
				}]
		}]
	});
	
	var INRequestAuxByTransferPanel = new Ext.Panel({
		deferredRender : true,
		activeTab: 0,
		region:'center',
		layout:'border',
		items:[INRequestAuxByTransferGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INRequestAuxByTransferPanel]
	});
	SetLogInDept(LocField.getStore(),"LocField");
});
//===========ģ����ҳ��===========================================