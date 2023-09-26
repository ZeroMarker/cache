// ����:��������(����<���������>)
// ��д����:2012-08-10
//=========================����ȫ�ֱ���=================================
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var rowDelim=xRowDelim();


// ������
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '������',
	id : 'LocField',
	name : 'LocField',
	emptyText : '������...',
	groupId:gGroupId,
	width:180,
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
	listWidth:210,
	emptyText:'��������...',
	//groupId:gGroupId,
	defaultLoc:{},
	width:180,
	relid:Ext.getCmp("LocField").getValue(),
	protype:'RF',
	params : {relid:'LocField'}
});


var GStore = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
GStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url : 'dhcst.extux.csp?actiontype=StkCatGroup&type=G',method:'GET'});
});	
//����
var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});
// ������
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{StkGrpId:'group'}
});

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
	boxLabel:'��װ��ȡ��',
	allowBlank:true
});

var ManagerDrugSigner = new Ext.form.Checkbox({
	id:'ManagerDrugSigner',
	boxLabel:'����ҩ��־',
	allowBlank:true
});
//=========================����ȫ�ֱ���=================================
//=========================��������Ϣ=================================
var INRequestAuxByStkLimitGrid="";
//��������Դ
var INRequestAuxByStkLimitGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryFZByLimit',method:'GET'});
var INRequestAuxByStkLimitGridDs = new Ext.data.Store({
	proxy:INRequestAuxByStkLimitGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty : "results"
    }, [
	/*inci,code,desc,uom,avaQty,minQty,maxQty,repQty,incil,pUom,pUomDesc,sbdesc,reqQty*/
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
		{name:'ind'},
		{name:'stkCatDesc'},
		{name:'prvoqty'}
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

    	}
    	else{
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
        header:"ҩƷrowid",
        dataIndex:'inci',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
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
        header:"��Ӧ�����",
        dataIndex:'prvoqty',
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
        header:"������",
        dataIndex:'stkCatDesc',
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
		
		if ((groupId=='')||(groupId==null)){
			Msg.info("error", "���鲻��Ϊ��!");
			return false;
		}
        //������
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
		//����ҩ��־
        	var man = (Ext.getCmp('ManagerDrugSigner').getValue()==true?1:0);
		//ȡ����־
		var round = (Ext.getCmp('IntSigner').getValue()==true?'Y':'N');
		var pid=getPid();		
		
		strPar = toLoc+"^"+frLoc+"^"+groupId+"^"+man+"^"+round+"^"+pid+"^"+0+"^"+stkCatId;
		
		INRequestAuxByStkLimitGridDs.setBaseParam('strPar',strPar);
		INRequestAuxByStkLimitGridDs.load({
			params:{start:0,limit:pagingToolbar.pageSize,sort:'code',dir:'desc'},
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
	var frLocName = Ext.getCmp('supplyLocField').getRawValue();
	if((frLoc=="")||(frLoc==null)){
		Msg.info("warning", "��ѡ�񹩸�����!");
		return;
	}
	//������
	var toLoc = Ext.getCmp('LocField').getValue(); 
	var toLocName = Ext.getCmp('LocField').getRawValue();
	if((toLoc=="")||(toLoc==null)){
		Msg.info("warning", "��ѡ��������!");
		return;
	}
	//����
	var scg = Ext.getCmp('group').getValue();
	var scgName=Ext.getCmp('group').getRawValue();
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
	var data=INRequestAuxByStkLimitGridDs.getModifiedRecords();
	if(data.length>0){
		Msg.info("warning","������δ����ļ�¼�����ȵ�����棡");
		return;
	}
	Ext.Ajax.request({
		url : 'dhcst.inrequestaction.csp?actiontype=CreateReqByLim&Pid='+pid+'&ReqInfo='+reqInfo,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "�������󵥳ɹ�!");
				var infoArr = jsonData.info.split("^");
				var req = infoArr[0];
				var reqNo = infoArr[1];
				Ext.getCmp("reqOrder").setValue(reqNo);
				location.href="dhcst.inrequest.csp?reqByabConsume="+req;
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
			//if(rec.data.newRecord || rec.dirty){ ������¼�¼���иĶ�
				pid=rec.data["pid"];
				var ind = rec.data['ind'];
				var qty = rec.data['realReqQty'];
				var prvoqty = rec.data['prvoqty'];	
				if (qty>0) {
					var tmp = ind+"^"+qty;
					if(str==""){
						str = tmp;
					}else{
						str = str + rowDelim+ tmp;			
					}
				}				
			//}
		}	
		if(pid==""){
			Msg.info("warning","û��������ϸ,��ֹ����!");
			return;
		}	
		
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=SaveForAuxByLim',
			params:{Pid:pid,ListData:str},
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					INRequestAuxByStkLimitGridDs.commitChanges();
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
	text:'����',
    tooltip:'����',
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
	M_StkCat.setRawValue("");
	var record=INRequestAuxByStkLimitGridDs.getAt(0);
	var pid=record.get("pid");	
	KillTmpGlobal(pid) ;
	INRequestAuxByStkLimitGrid.getStore().removeAll();
	INRequestAuxByStkLimitGrid.getView().refresh();
	Ext.getCmp('supplyLocField').setDisabled(false);
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('group').setDisabled(false);
	Ext.getCmp('IntSigner').setDisabled(false);
	Ext.getCmp('ManagerDrugSigner').setDisabled(false);
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
		var staParArr=strPar.split("^");
		staParArr[5]=pid
		staParArr[6]=1	//1:��ʾ��ҳ
		B['strPar']=staParArr.join("^") //1:��ʾ��ҳ
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
	height:476,
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
		url : 'dhcst.inrequestaction.csp?actiontype=KillTmpGlobal',
		params:{Pid:pid},
		method : 'POST',
		success:function(){
		
		},
		failure:function(){
			Msg.info('error','��̨��ʱ������մ���!')	
		}		
	});

}

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
		title:'��������(����<���������>)',
		tbar:[find,'-',clear,'-',productReqOrder,'-',CreateBtn],
		items : [{
			xtype:'fieldset',
			title:'��ѯ����',
			style : DHCSTFormStyle.FrmPaddingV,
			layout: 'column',    // Specifies that the items will now be arranged in columns		
			defaults: {border:false}, 
					items : [{
						columnWidth : .25,
						xtype: 'fieldset',
						items : [reqOrder,group]
					},{
						columnWidth : .25,
						xtype: 'fieldset',
						items : [LocField,supplyLocField]
					},{
						columnWidth : .25,
						xtype: 'fieldset',
						items : [M_StkCat]
					},{
						columnWidth : .25,
						xtype: 'fieldset',
						labelWidth: 10,	
						items : [IntSigner,ManagerDrugSigner]
					}]
		}]
	});
	
	var INRequestAuxByStkLimitPanel = new Ext.Panel({
		deferredRender : true,
		activeTab: 0,
		region:'center',
		collapsible: true,
        split: true,
		layout:'border',
		items:[INRequestAuxByStkLimitGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[		
			{
                region: 'north',
                height: DHCSTFormStyle.FrmHeight(2), // give north1 and south regions a height
                layout: 'fit', // specify layout manager for items
                items:formPanel
            }, {
                region: 'center',		               
                layout: 'fit', // specify layout manager for items
                items: INRequestAuxByStkLimitPanel       
               
            }],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===========================================