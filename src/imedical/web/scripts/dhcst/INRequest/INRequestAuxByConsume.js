// ����:��������(����<���ļ�������׼>)
// ��д����:2012-08-3
//=========================����ȫ�ֱ���=================================
var INRequestAuxByConsumeId = "";
var gLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
if(gParam.length<1){
	GetParam();  //��ʼ����������
}
var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'������',
	width:210,
	listWidth:210,
	emptyText:'������...',
	groupId:gGroupId,
	listeners : {
		'select' : function(e) {
			var SelLocId=Ext.getCmp('LocField').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
			group.getStore().removeAll();
			group.getStore().setBaseParam("locId",SelLocId)
			group.getStore().setBaseParam("userId",UserId)
			group.getStore().setBaseParam("type",App_StkTypeCode)
			group.getStore().load();
			GetParam(e.value);	//�޸Ĺ������Һ�,�Թ�����������Ϊ׼
		}
	}
});
LocField.on('select', function(e) {
    Ext.getCmp("supplyLocField").setValue("");
    Ext.getCmp("supplyLocField").setRawValue("");
});
var supplyLocField = new Ext.ux.LocComboBox({
	id:'supplyLocField',
	fieldLabel:'��������',
	width:210,
	listWidth:210,
	emptyText:'��������...',
	groupId:gGroupId,
	defaultLoc:{},
	relid:Ext.getCmp("LocField").getValue(),
	protype:'RF',
	params : {relid:'LocField'}
});
//����
var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	width:200,
	anchor:'90%',
	StkType:App_StkTypeCode,
	LocId:gLocId,
	UserId:UserId
});
// ������
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'M_StkCat',
	name : 'M_StkCat',
	width:200,
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{StkGrpId:'group'}
});
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'��ʼ����',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'��������',
	anchor:'90%',
	value:new Date()
});

var days = new Ext.form.NumberField({
	id:'days',
	fieldLabel:'�ο�����',
	allowBlank:true,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

//�Ƿ񰴱�׼�����ؼ���ʱ����
var isBZ = new Ext.form.Checkbox({
	id: 'isBZ',
	boxLabel:'�Ƿ񰴱�׼����',
	allowBlank:true,    
	listeners:{
		'check':function(obj,ischecked){
			if(ischecked==true){
				//startDateField.disable();
				//endDateField.disable();
			}else{
				//startDateField.enable();
				//endDateField.enable();
			}
		}
	}   
});
var CheckRound = new Ext.form.Checkbox({
	id: 'CheckRound',
	boxLabel:'����ȡ��',
	allowBlank:true,
	checked:true    
})

var CheckReqStock = new Ext.form.Checkbox({
	id: 'CheckReqStock',
	boxLabel:'���С������',
	allowBlank:true,
	checked:true 
})
var HelpBT = new Ext.Button({
	��������id:'HelpBtn',
			text : '����',
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
		});
//=========================����ȫ�ֱ���=================================
//=========================��������Ϣ=================================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'rowid',
			type : 'int'
		}, {
			name : 'inci',
			type : 'int'
		}, {
			name : 'code',
			type : 'string'
		}, {
			name : 'desc',
			type : 'string'
		}, {
			name : 'qty',
			type : 'int'
		}, {
			name : 'uom',
			type : 'int'
		}, {
			name : 'uomDesc',
			type : 'string'
		}, {
			name : 'spec',
			type : 'string'
		}, {
			name : 'manf',
			type : 'int'
		}, {
			name : 'sp',
			type : 'int'
		}, {
			name : 'spAmt',
			type : 'double'
		}, {
			name : 'generic',
			type : 'string'
		}, {
			name : 'drugForm',
			type : 'string'
		}, {
			name : 'remark',
			type : 'string'
		}
	]);
	
	var NewRecord = new record({
		rowid:'',
		inci:'',
		code:'',
		desc:'',
		qty:'',
		uom:'',
		uomDesc:'',
		spec:'',
		manf:'',
		sp:'',
		spAmt:'',
		generic:'',
		drugForm:'',
		remark:''
	});
					
	INRequestAuxByConsumeGridDs.add(NewRecord);
	INRequestAuxByConsumeGrid.startEditing(INRequestAuxByConsumeGridDs.getCount() - 1, 4);
}

var INRequestAuxByConsumeGrid="";
//��������Դ
var INRequestAuxByConsumeGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryFZ',method:'GET'});
var INRequestAuxByConsumeGridDs = new Ext.data.Store({
	proxy:INRequestAuxByConsumeGridProxy,
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
		{name:'StkQty'}, //���
		{name:'avaQty'}, //���ÿ�ҽ����
		{name:'dailyDispQty'}, //�շ�ҩ��
		{name:'reqQtyAll'}, //days��������
		{name:'applyQty'}, //����������
		{name:'dispQtyAll'}, //���ڷ�Χ�ڷ�ҩ����
		{name:'stkCatDesc'}, //������
		{name:'prvoqty'}, //��Ӧ�����
		{name:'proReqQty'}  // ����������ԭʼֵ
	]),
    remoteSort:false
});
//ģ��
var INRequestAuxByConsumeGridCm = new Ext.grid.ColumnModel([
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
        header:"������",
        dataIndex:'stkCatDesc',
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
        header:"���",
        dataIndex:'spec',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'manf',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"���",
        dataIndex:'StkQty',
        width:70,
        align:'right',
        sortable:true
    },{
        header:"��Ӧ�����",
        dataIndex:'prvoqty',
        width:70,
        align:'right',
        sortable:true
    },{
        header:"���ÿ�ҽ����",
        dataIndex:'avaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"�շ�ҩ��",
        dataIndex:'dailyDispQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�ο�������������",
        dataIndex:'reqQtyAll',
        width:150,
        align:'right',
        sortable:true
    },{
        header:"������",
        dataIndex:'applyQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'applyQtyField',
			selectOnFocus:true,
            allowBlank:false
        })
    },{
        header:"����������",
        dataIndex:'proReqQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"���ڷ�Χ�ڷ�ҩ����",
        dataIndex:'dispQtyAll',
        width:150,
        align:'right',
        sortable:true
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
		if(day==""){
			Msg.info("error", "����д�ο�����!");
			return false;
		}
		//����
		var groupId = Ext.getCmp('group').getValue();
		//������
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
        //����������ȡ��
		var roundflag = Ext.getCmp('CheckRound').getValue();
        //��֤���󷽿��
        var reqenough= Ext.getCmp('CheckReqStock').getValue();
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc+"^"+stkCatId+"^"+roundflag+"^"+reqenough;
		
		INRequestAuxByConsumeGridDs.load({params:{start:0,limit:999,strPar:strPar}});
		save.enable();
	}
});

var save = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:true,
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
		var scg = Ext.getCmp('group').getValue();
		var scgName = Ext.getCmp('group').getRawValue();		
		if((scg=="")||(scg==null)){
			Msg.info("error", "��ѡ������!");
			return false;
		}
		
		var count = INRequestAuxByConsumeGridDs.getCount();
		if(count==0){
			Msg.info("error","û�г���������ϸ,��ֹ����!");
			return false;
		}else{
			var str = "";
			var colRemark="";
			for(var index=0;index<count;index++){
				var rec = INRequestAuxByConsumeGridDs.getAt(index);
				var inc = rec.data['inci'];
				var prvoqty = rec.data['prvoqty'];
				if((inc!=null)&&(inc!="")){
					if ((gParam[0]=='N')&&(prvoqty<=0)){
						continue;
					}
					var rowid = "";
					var uom = rec.data['uom'];
					var qty = rec.data['applyQty'];
					var proReqQty=rec.data['proReqQty']; // ����������
					if (Number(qty)<=0){continue;}
					var tmp = rowid+"^"+inc+"^"+uom+"^"+qty+"^"+colRemark+"^"+scg+"^"+proReqQty;
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
			var remark = "��������(�������ļ�������׼)";
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

var clear = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('supplyLocField').setValue("");
		Ext.getCmp('supplyLocField').setRawValue("");
		Ext.getCmp('LocField').setValue("");
		Ext.getCmp('LocField').setRawValue("");
		Ext.getCmp('group').setValue("");
		Ext.getCmp('group').setRawValue("");
		Ext.getCmp('days').setValue("");
		INRequestAuxByConsumeGridDs.removeAll();
		save.disable();
	}
});

//��ʼ��Ĭ��������
INRequestAuxByConsumeGridCm.defaultSortable = true;
//���
INRequestAuxByConsumeGrid = new Ext.grid.EditorGridPanel({
	store:INRequestAuxByConsumeGridDs,
	cm:INRequestAuxByConsumeGridCm,
	trackMouseOver:true,
	height:476,
	stripeRows:true,
	region:'center',
	clicksToEdit:1,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true
	//bbar:pagingToolbar
});
//=========================��������Ϣ=================================

//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 60,
		title:'��������(����<���ļ�������׼>)',
		region:'north',
		labelAlign : 'right',
		height: DHCSTFormStyle.FrmHeight(3),
		frame : true,
		tbar:[find,'-',clear,'-',save,'-',HelpBT],
		items : [{
			
				layout : 'column',		
				xtype : 'fieldset',
				title : 'ѡ����Ϣ',
				style:DHCSTFormStyle.FrmPaddingV,
				defaults:{border:false},
				items : [{					
					columnWidth : .25,
					xtype:'fieldset',
					items : [LocField,supplyLocField,days]
				},{
					columnWidth : .25,
					xtype:'fieldset',
					items : [startDateField,endDateField]
				},{
					columnWidth : .25,
					xtype:'fieldset',
					items : [group,M_StkCat]					
				},{
					columnWidth : .25,	
					xtype:'fieldset',
					items : [CheckRound,CheckReqStock]
				}
				]
		}]
	});
	
	var INRequestAuxByConsumePanel = new Ext.Panel({
		deferredRender : true,
		activeTab: 0,
		region:'center',
		layout:'border',
		items:[INRequestAuxByConsumeGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[formPanel,INRequestAuxByConsumePanel],
		renderTo:'mainPanel'
	});
   new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 500,
        anchorOffset: 50,
		hideDelay : 90000,
        html: "<font size=3><p>---��������������---</p></font><font size=2 color=blue><p>���ڷ�Χ�ڵķ�ҩ������ƽ����</p></font><font size=2 color=red><p>����</p></font><font size=2 color=blue><p>�ο�����</p></font><font size=2 color=red><p>��ȥ</p></font><font size=2 color=blue><p>���ÿ�ҽ������</p></font>"+
        "<font size=3><p>---������ȡ����---</p></font><font size=2 color=blue><p>�����������������ΪС������ȥС�����1</p></font>"+
        "<font size=3><p>---���С������---</p></font><font size=2 color=blue><p>���˵�����������������0������</p></font>"
    });
    Ext.getCmp('HelpBtn').focus('',100); //��ʼ��ҳ���ĳ��Ԫ�����ý���
});
//===========ģ����ҳ��===========================================