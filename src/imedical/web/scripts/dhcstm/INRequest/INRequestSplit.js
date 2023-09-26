// ����:���ܲ�����˲����Ϊ�ƻ����߽��г���

var guserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var url = 'dhcstm.inrequestaction.csp';

//ȡ��������
if(gParam==null ||gParam.length<1){
	GetParam();
}

//��ʼ����
var startDate = new Ext.ux.DateField({
	id:'startDate',
	fieldLabel:'��ʼ����',
	value:DefaultStDate()
});

//��ֹ����
var endDate = new Ext.ux.DateField({
	id:'endDate',
	fieldLabel:'��ֹ����',
	value:DefaultEdDate()
});

//����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:gLocId,
	UserId:guserId
});

var SupplyLoc = new Ext.ux.LocComboBox({
			fieldLabel : '��Ӧ����',
			id : 'SupplyLoc',
			name : 'SupplyLoc',
			emptyText : '��Ӧ����...',
			groupId : gGroupId
		});
var Loc = new Ext.ux.LocComboBox({
			id : 'Loc',
			fieldLabel : '������',
			emptyText : '������...',
			defaultLoc : {}
		});
var ProvLocAudited= new Ext.form.Checkbox({
	id: 'ProvLocAudited',
	fieldLabel:'�����',
	allowBlank:true
});
var Type = new Ext.grid.CheckColumn({
	header:'�ɹ���־',
	dataIndex:'Type',
	sortable:true,
	width:60
});
var fB = new Ext.ux.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	handler:function(){
		var scgStr=getScgStr();  ///���鴮
		var startDate = Ext.getCmp('startDate').getValue();
		if(!Ext.isEmpty(startDate)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if(!Ext.isEmpty(endDate)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		var toLocId = Ext.getCmp('Loc').getValue();
		var frLocId = Ext.getCmp('SupplyLoc').getValue();
		if(Ext.isEmpty(frLocId)){
			Msg.info("error","��ѡ��Ӧ����!");
			return false;
		}
		var isProvLocAudited= (Ext.getCmp('ProvLocAudited').getValue()==true?'Y':'N');
		var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+isProvLocAudited+"^"+scgStr;
	    OrderDs.setBaseParam('strPar',strPar);
		OrderDs.removeAll();
		OrderDs.load({
			params:{start:0,limit:9999},
			callback:function(r,options,success){
				if(!success){
					Msg.info("warning","��ѯ����,��鿴��־!");
					return;
				}
			}
		});
	}
});
// �ܾ����밴ť
	var refDetailBT = new Ext.Toolbar.Button({
				text : '�ܾ�һ����ϸ',
				tooltip : '����ܾ�ת����Ϣ',
				iconCls : 'page_gear',
				height:30,
				width:70,
				handler : function() {
					refDetail();
				}
			});	
	/////�ܾ�������ϸ
	function refDetail(){		
		var selectRow=Grid.getSelectionModel().getSelected();
		if (Ext.isEmpty(selectRow)){
			  Msg.info("warning", "��ѡ��Ҫ�ܾ�����ϸ��¼!");
			  return;
		}
		var reqi=selectRow.get("reqi");
		var url=DictUrl+"inrequestaction.csp?actiontype=refuse&reqi="+reqi;
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
	
		if (jsonData.success == 'true') {
			// ˢ�½���
          Msg.info("success", "�ܾ����뵥��ϸ�ɹ�!");
			Grid.getStore().reload()

		} else {
			Msg.info("error", "�ܾ����뵥ʧ��!");
		
		}	
	 }
// �任����ɫ
function changeBgColor(row, color) {
	Grid.getView().getRow(row).style.backgroundColor = color;
}
var cB = new Ext.ux.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	handler:function(){
		clearData();
	}
});
function clearData() {
	Ext.getCmp("Loc").setValue("");
	Ext.getCmp("ProvLocAudited").setValue(false);
	OrderDs.removeAll();
}

var provlocAuditB = new Ext.ux.Button({
	iconCls:'page_delete',
	text:'��˷���',
	handler:function(){
		var ds=Grid.getStore();
		var count=ds.getCount();
		var loc=SupplyLoc.getValue()
		if(Ext.isEmpty(loc)){Msg.info("warning","�������Ҳ���Ϊ��!"); return}
		var StrParam=loc+"^"+gGroupId+"^"+guserId
		var Cstr=""  ///�ƻ���
		var Ostr=""	 ///���⴮
		for (var i=0;i<count;i++)
		{	
			var rec=ds.getAt(i)
		    var provLocAudited=rec.get('ProvLocAudited');
		    var Type=rec.get('Type');
		    var reqi=rec.get('reqi');
			if (provLocAudited=="Y"){continue}
			if (Type=="Y")
				{
					if(Cstr==""){Cstr=reqi} 
					else{Cstr=Cstr+"^"+reqi}
				}
			else
				{
				if(Ostr==""){Ostr=reqi} 
				else{Ostr=Ostr+"^"+reqi}	
				}
			
			
			
		}
	
		if(Cstr==""&&Ostr==""){Msg.info("warning","û����Ҫ��˴��������!"); return}
		provlocAudit(Cstr,Ostr,StrParam);	
	}
});

var OrderDs = new Ext.data.JsonStore({
	url:url+'?actiontype=QuerySplitDetail',
	root:'rows', 
	fields:[
		{name:'reqi'},
		{name:'reqNo'},
		{name:'recLocDesc'},
		{name:'reqUserName'},
		{name:'reqDate'},
		{name:'reqInci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'reqUomDesc'},
		{name:'reqQty'},
		{name:'qty'},
		{name:'QtyApproved'},
		{name:'SpecList'},
		{name:'Type'},
		{name:'manf'},
		{name:'ProvLocAudited'},
		{name:'Vendor'},
		{name:'remark'}
		
	],
	remoteSort: false
});
var OrderCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'rowid',
		dataIndex: 'reqi',
		width: 100,
		hidden:true,
		align: 'left'
	},{
		header: '���󵥺�',
		dataIndex: 'reqNo',
		width: 120,
		sortable:true,
		align: 'left'
	},{
		header: '������',
		dataIndex: 'recLocDesc',
		width: 100,
		sortable:true,
		align: 'left'
	},{
		header:'������',
		dataIndex: 'reqUserName',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "��������",
		dataIndex: 'reqDate',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header:'�����',
		dataIndex:'ProvLocAudited',
		align:'center',
		width:80,
		xtype : 'checkcolumn'
	},{
		header: '����',
		dataIndex: 'code',
		width: 72,
		sortable:true,
		align: 'left'
	},{
		header: '����',
		dataIndex: 'desc',
		width: 140,
		sortable:true,
		align: 'left'
	},{
		header:'���',
		dataIndex:'spec',
		align:'left',
		width:80,
		sortable:true
	},{
		header: "����",
		dataIndex: 'manf',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "��λ",
		dataIndex: 'reqUomDesc',
		width: 72,
		align: 'left',
		sortable: true
	},{
		header: "��������",
		dataIndex: 'reqQty',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "�������",
		dataIndex: 'qty',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "��׼����",
		dataIndex: 'QtyApproved',
		width: 80,
		align: 'right',
		editor:new Ext.form.NumberField({selectOnFocus:true})
	},Type,
	{
		header: "������",
		dataIndex: 'SpecList',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "��Ӧ��",
		dataIndex: 'Vendor',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "��ע",
		dataIndex: 'remark',
		width: 80,
		align: 'right',
		sortable: true
	}
]);

var Grid = new Ext.ux.EditorGridPanel({
	id:'Grid',
	title:'������������ϸ',
	region:'center',
	store:OrderDs,
	cm:OrderCm,
	trackMouseOver: true,
	stripeRows: true,
	plugins:Type,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask: true,
	viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){ 
				var qty=parseInt(record.get("qty"));
				var reqQty=parseInt(record.get("reqQty"));
				var ProvLocAudited=Ext.getCmp("ProvLocAudited").getValue();
				if(!ProvLocAudited){
					if(qty<reqQty){
						return 'classRed';
					}
				}
			}
		},
	listeners:{
		'beforeedit':function(e){
			
			if(e.record.get('ProvLocAudited')=='Y'){
				e.cancel = true;
			}
		},
		'afteredit':function(e){
			if(e.field=="QtyApproved"){
				var QtyApproved=e.value
				var reqi=e.record.get('reqi')
				var ret=tkMakeServerCall("web.DHCSTM.INRequestSplit","UpdateQtyApproved",reqi,QtyApproved)
				if(ret==0){e.record.commit();}
			}
		}
		}
	
});

var conPanel = new Ext.ux.FormPanel({
	region:'north',
	title:'������˷���',
	height:180,
	tbar:[fB,'-',cB,'-',provlocAuditB,'-',refDetailBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		frame:true,
		items:[{
			layout:'column',
			items:[
				{columnWidth:.3,layout:'form',items:[startDate,endDate]}
				,
				{columnWidth:.3,layout:'form',items:[SupplyLoc,Loc]}
				,
				{columnWidth:.4,layout:'form',items:[ProvLocAudited]}		
			]
		}]
	}]
});

function provlocAudit(Cstr,Ostr,StrParam)
{
	Ext.Ajax.request({
		url:url+"?actiontype=SplitDetail",
		method : 'POST',
		params:{Cstr:Cstr,Ostr:Ostr,StrParam:StrParam},
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','��˳ɹ�!');
			 	Grid.getStore().reload();
			 }
			 else
			 {
			 	Msg.info('error','���ʧ��!');
			 }			 
		}
	})
}
/*ȡ��¼�ߵ���Ȩ���鴮*/
function getScgStr()
{
	var str="";
	var st=groupField.getStore();
	var c=st.getCount();
	for (var i=0;i<c;i++)
	{
		var rec=st.getAt(i)
		var scg=rec.get('RowId');
		if (str=="") str=scg
		else
		 str=str+","+scg
	}
	return str
}
	
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[conPanel,Grid]
	});
});
