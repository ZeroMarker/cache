// ����:��������(����<���ļ�������׼>)
// ��д����:2012-08-3

var gLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var URL = 'dhcstm.inrequestaction.csp';

var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'������',
	listWidth:210,
	emptyText:'������...',
	groupId:gGroupId,
	protype : INREQUEST_LOCTYPE,
	linkloc:gLocId,
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
			Ext.getCmp("group").setFilterByLoc(requestLoc,provLoc);			
		}
	}
});

var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	anchor: '90%',
	StkType:App_StkTypeCode,
	LocId:gLocId,
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
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

//�Ƿ񰴱�׼�����ؼ���ʱ����
var isBZ = new Ext.form.Checkbox({
	id: 'isBZ',
	fieldLabel:'�Ƿ񰴱�׼����',
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
		{name:'dailyDispQty'}, //�շ�����
		{name:'reqQtyAll'}, //days��������
		{name:'applyQty'}, //����������
		{name:'dispQtyAll'} //���ڷ�Χ�ڷ�������
	]),
    remoteSort:false
});
//ģ��
var INRequestAuxByConsumeGridCm = new Ext.grid.ColumnModel([
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
        header:"���ÿ�ҽ����",
        dataIndex:'avaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"�շ�����",
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
        header:"����������",
        dataIndex:'applyQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'applyQtyField',
            allowBlank:false
        })
    },{
        header:"���ڷ�Χ�ڷ�������",
        dataIndex:'dispQtyAll',
        width:150,
        align:'right',
        sortable:true
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
		//����
		var groupId = Ext.getCmp('group').getValue();
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc;
		
		INRequestAuxByConsumeGridDs.load({params:{start:0,limit:999,strPar:strPar}});
		save.enable();
	}
});

var save = new Ext.Toolbar.Button({
	text:'��������',
    tooltip:'��������',
    iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:true,
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
		var scg = Ext.getCmp('group').getValue();	
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
				if((inc!=null)&&(inc!="")){
					var rowid = "";
					var uom = rec.data['uom'];
					var qty = rec.data['applyQty'];
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

var clear = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_delete',
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
INRequestAuxByConsumeGrid = new Ext.ux.EditorGridPanel({
	region:'center',
	id: 'INRequestAuxByConsumeGrid',
	title: '��������',
	store:INRequestAuxByConsumeGridDs,
	cm:INRequestAuxByConsumeGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.ux.FormPanel({
		region:'north',
		title:'��������(����<���ļ�������׼>)',
		tbar:[find,'-',save,'-',clear],
		items : [{
				layout : 'column',
				xtype : 'fieldset',
				title : 'ѡ����Ϣ',
				style:'padding:0px 0px 0px 0px',
				defaults:{border:false},
				items : [{
					columnWidth : .25,
					xtype:'fieldset',
					defaults:{width:180},
					items : [LocField,supplyLocField]
				},{
					columnWidth : .25,
					xtype:'fieldset',
					items : [startDateField,endDateField]
				},{
					columnWidth : .25,
					xtype:'fieldset',
					items : [days,group]
				},{
					columnWidth : .25,
					xtype:'fieldset',
					items : [isBZ]
				}]
		}]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INRequestAuxByConsumeGrid]
	});
});
