// ����:��������(����<ת�����>)
// ��д����:2012-08-9
//=========================����ȫ�ֱ���=================================
//var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];

// ������
var LocField= new Ext.ux.LocComboBox({
	fieldLabel:'������',
	id : 'LocField',
	name : 'LocField',
	emptyText:'������...',
	groupId:gGroupId,
	width:180,
	listeners : {
		'select' : function(e) {
			var SelLocId=Ext.getCmp('LocField').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
			groupField.getStore().removeAll();
			groupField.getStore().setBaseParam("locId",SelLocId)
			groupField.getStore().setBaseParam("userId",UserId)
			groupField.getStore().setBaseParam("type",App_StkTypeCode)
			groupField.getStore().load();
			GetParam(e.value);	//�޸Ĺ������Һ�,�Թ�����������Ϊ׼
		}
	}
});
SetLogInDept(LocField.getStore(),"LocField");
LocField.on('select', function(e) {
    Ext.getCmp("supplyLocField").setValue("");
    Ext.getCmp("supplyLocField").setRawValue("");
});
var supplyLocField = new Ext.ux.LocComboBox({
	id:'supplyLocField',
	fieldLabel:'��������',
	listWidth:210,
	emptyText:'��������...',
	groupId:gGroupId,
	defaultLoc:{},
	width:180,
	relid:Ext.getCmp("LocField").getValue(),
	protype:'RF',
	params : {relid:'LocField'}
});

//����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	width:100,
	listWidth:100,
    allowBlank:true,
	fieldLabel:'��ʼ����',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:100,
	listWidth:100,
    allowBlank:true,
	fieldLabel:'��������',
	anchor:'90%',
	value:new Date()
});

var days = new Ext.form.NumberField({
	id:'days',
	fieldLabel:'�ο�����',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'',
	anchor:'90%',
	value:30,
	selectOnFocus:true
});

var isInt = new Ext.form.Checkbox({
	id: 'isInt',
	boxLabel:'����������ȡ��',
	allowBlank:true
});

var isIncludeZero = new Ext.form.Checkbox({
	id:'isIncludeZero',
	boxLabel:'����������=0',
	allowBlank:true
});

var useInt = new Ext.form.Checkbox({
	id: 'useInt',
	boxLabel:'ʹ�ý���������',
	allowBlank:true
});

var isCheckKC = new Ext.form.Checkbox({
	id:'isCheckKC',
	boxLabel:'��鲿�ſ��',
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
        header:"ҩƷrowid",
        dataIndex:'inci',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
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
            allowBlank:true
        })
    }
]);

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
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
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error", "��ѡ��ʼ����!");
			return false;
		}
		//��������
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
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
		//����������ȡ��
		var roundInt = (Ext.getCmp('isInt').getValue()==true?'Y':'N');
		//����������=0
		var includeZero = (Ext.getCmp('isIncludeZero').getValue()==true?'Y':'N');
		//ʹ�ý���������
		var useInt = (Ext.getCmp('useInt').getValue()==true?'Y':'N');
		//��鲿�ſ��
		var checkKC = (Ext.getCmp('isCheckKC').getValue()==true?'Y':'N');		
		
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc+"^"+roundInt+"^"+includeZero+"^"+useInt+"^"+checkKC;
		
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
		var frLocName = Ext.getCmp('supplyLocField').getRawValue();
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", "��ѡ�񹩸�����!");
			return false;
		}
		//������
		var toLoc = Ext.getCmp('LocField').getValue(); 
		var toLocName = Ext.getCmp('LocField').getRawValue();
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", "��ѡ��������!");
			return false;
		}
		//����
		var scg = Ext.getCmp('groupField').getValue();
		var scgName = Ext.getCmp('groupField').getRawValue();		
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
					var applyqty=rec.data['applyQty'];
					var tmp = rowid+"^"+inc+"^"+uom+"^"+qty+"^"+colRemark+"^"+scg+"^"+applyqty;
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
			var remark = "ת�����";
			var reqInfo = frLoc+"^"+toLoc+"^"+UserId+"^"+scg+"^"+status+"^"+remark;
			
			Ext.Ajax.request({
				url : 'dhcst.inrequestaction.csp?actiontype=save',
				params:{req:req,reqInfo:reqInfo,data:str},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "����ɹ�!");
						req = jsonData.info;
						location.href="dhcst.inrequest.csp?reqByabConsume="+req;
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
							Msg.info("error", "����ʧ��!"+jsonData.info);
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
	height:476,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true //,
	//bbar:pagingToolbar*/
});
//=========================��������Ϣ=================================

//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoScroll : false,
		title:'��������(����<ת�����>)',
		tbar:[find,'-',productReqOrder],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			style : DHCSTFormStyle.FrmPaddingV,
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {border:false}, 		
				items : [{
					columnWidth : .22,
					xtype: 'fieldset',
					items : [LocField,supplyLocField]
				},{
					columnWidth : .22,
					xtype: 'fieldset',
					items : [startDateField,endDateField]
				},{
					columnWidth : .22,
					xtype: 'fieldset',
					items : [days,groupField]
				},{
					columnWidth : .12,
					xtype: 'fieldset',
					labelWidth: 10,
					items : [useInt,isInt]
				},{
					columnWidth : .16,
					xtype: 'fieldset',
					labelWidth: 10,
					items : [isCheckKC,isIncludeZero]
				}]
		}]
	});
	
	var INRequestAuxByTransferPanel = new Ext.Panel({
		deferredRender : true,
		activeTab: 0,
		region:'center',
		collapsible: true,
        split: true,
		layout:'border',
		items:[INRequestAuxByTransferGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[		
			{
                region: 'north',
                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
                layout: 'fit', // specify layout manager for items
                items:formPanel
            }, {
                region: 'center',		               
                layout: 'fit', // specify layout manager for items
                items: INRequestAuxByTransferPanel       
               
            }],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===========================================