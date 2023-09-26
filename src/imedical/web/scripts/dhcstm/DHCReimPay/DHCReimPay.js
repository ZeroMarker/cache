// ����:����֧����
// ��д����:2018-02-24
var gUserId = session['LOGON.USERID'];  
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gUrl="dhcstm.dhcreimpayaction.csp"

var Loc=new Ext.ux.LocComboBox({
	fieldLabel:'����',
	id:'Loc',
	name:'Loc',
	groupId:gGroupId
});
var InvNo = new Ext.form.TextField({
    id:'InvNo',
    fieldLabel:'��Ʊ��',
    anchor:'90%',
    listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
				findBT.handler();	
				}
			}
		} 
});
var ReimPayNo = new Ext.form.TextField({
    id:'ReimPayNo',
    fieldLabel:'��֧����',
    anchor:'90%',
	listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
				findReimBT.handler();	
				}
			}
		}    
});
var ReimPayInvNo = new Ext.form.TextField({
    id:'ReimPayInvNo',
    fieldLabel:'��Ʊ��',
    anchor:'90%',
 	listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
				var No=tkMakeServerCall("web.DHCSTM.DHCReimPay","getRPNoByInvNo",field.getValue())
				Ext.getCmp("ReimPayNo").setValue(No)
				findReimBT.handler()
				}
			}
		}  
});

var findBT = new Ext.ux.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    handler:function(){

	    var Locid=Ext.getCmp("Loc").getValue();
	    var InvNo=Ext.getCmp("InvNo").getValue();
	    if (Locid==null || Locid=="") {
		    Msg.info("warning","��ѡ�����!");
		    return;
		}
		if (InvNo==null || InvNo=="") {
		    Msg.info("warning","�����뷢Ʊ��!");
		    return;
		}
		var retinfo=tkMakeServerCall("web.DHCSTM.DHCReimPay","CheckLocInv",Locid,InvNo);
		if (retinfo==-1){
		   Msg.info("warning","����δ����˵���ⵥ!");
		   return;
		}else if (retinfo==-2){
		   Msg.info("warning","��Ʊ��:"+InvNo+"û����Ҫ���������!");
		   return;
		}else{
          ingGrid.load();   
		}

    }
});
var findReimBT = new Ext.ux.Button({
    text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
    handler:function(){
    	  if(Ext.isEmpty(Ext.getCmp("ReimPayNo").getValue())){
    	  	var InvNo=Ext.getCmp('ReimPayInvNo').getValue()
    	  	var No=tkMakeServerCall("web.DHCSTM.DHCReimPay","getRPNoByInvNo",InvNo)
			Ext.getCmp("ReimPayNo").setValue(No)
    	  }
          reimPayGrid.load();   

    }
});

var addBt = new Ext.ux.Button({
	text:'���뱨֧��',
    iconCls:'page_add',
	handler:function(){
		add()
	}
});
function add ()
{

	var ReimPayNo = Ext.getCmp("ReimPayNo").getValue();
	var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","getComFlag",ReimPayNo)
	if(Ret=="Y"){ Msg.info("error", "�Ѿ�����ƾ֤�����ܼ������");return}
	var LocId =gLocId;
	var CreateUser = gUserId;
	var MainInfo = ReimPayNo + "^" + LocId + "^" + CreateUser;
	var ListDetail="";
	var rowCount = ingGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = ingGrid.getStore().getAt(i);
			var Type=rowData.get("TrType");
			var Pointer = rowData.get("RowId");
			var InvNo=rowData.get("InvNo");
			var InvNoAmt=rowData.get("RpAmt")
			var str = Type + "^" + Pointer+"^"+InvNo + "^"+InvNoAmt;
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
	}
	if(ListDetail==""){
		Msg.info("error", "û��������Ҫ���!");
		loadMask.hide();
		return false;
	}
	loadMask=ShowLoadMask(Ext.getBody(),"������...");
	var url =gUrl+"?actiontype=addReimPay";
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{MainInfo:MainInfo,ListDetail:ListDetail},
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var RPIRowid = jsonData.info;
				if(Ext.isEmpty(Ext.getCmp("ReimPayNo").getValue())){
				var RPNo=tkMakeServerCall("web.DHCSTM.DHCReimPay","getRPNo",RPIRowid)
				Ext.getCmp("ReimPayNo").setValue(RPNo)
				}
				findReimBT.handler()
				Msg.info("success", "����ɹ�!");
				ClearBT.handler()
				} else {
				var ret=jsonData.info;
				if(ret==-99){
					Msg.info("error", "����ʧ��,���ܱ���!");
				}
				if(ret==-2){
					Msg.info("error", "����ʧ��,���ܱ���!");
				}else{
					Msg.info("error", "����ʧ��!");
				}
			}
			loadMask.hide();
		},
		scope : this
	});
}

var ClearBT = new Ext.ux.Button({
			text : '���',
			iconCls : 'page_clearscreen',
			handler : function() {
				SetLogInDept(Loc.getStore(),'Loc');
				Ext.getCmp("InvNo").setValue("");
			    ingGrid.removeAll();
			}
		});
// ��ӡ��ť
var PrintBT = new Ext.ux.Button({
	text : '��ӡ��֧��',
	iconCls : 'page_print',
	handler : function() {
		var ReimPayNo = Ext.getCmp("ReimPayNo").getValue();
		Print(ReimPayNo);
	}
});
function Print(ReimPayNo) {
	var RaqName = 'DHCSTM_ReimPay.raq';
	var fileName = "{" + RaqName + "(strPar=" + ReimPayNo + ")}";
	DHCCPM_RQDirectPrint(fileName);

}
// ��ӡ��ť
var CreateBT = new Ext.ux.Button({
	text : '����ƾ֤',
	iconCls : 'page_add',
	handler : function() {
		var ReimPayNo = Ext.getCmp("ReimPayNo").getValue();
		var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","setCom",ReimPayNo)
		 if(Ret==-2){ Msg.info("error", "�Ѿ�����ƾ֤�������ظ�����");return}
		var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","AcctVoucherNo",ReimPayNo,gUserId)
		if(Ret==0){
			Msg.info("success", "�ɹ�!");
		}
	}
});
// ��ӡ��ť
var PrintBTReim = new Ext.ux.Button({
	text : '��ӡƾ֤',
	iconCls : 'page_print',
	handler : function() {
		var ReimPayNo = Ext.getCmp("ReimPayNo").getValue();
		//var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","setCom",ReimPayNo)
		//if(Ret==0){
		PrintRiem(ReimPayNo);
		//}
	}
});
function PrintRiem(ReimPayNo) {
	var RaqName = 'DHCSTM_ReimPayPZ.raq';
	var fileName = "{" + RaqName + "(strPar=" + ReimPayNo + ")}";
	DHCCPM_RQDirectPrint(fileName);

}
var ClearReimBT = new Ext.ux.Button({
			text : '���',
			iconCls : 'page_clearscreen',
			handler : function() {
				Ext.getCmp("ReimPayNo").setValue("");
				Ext.getCmp("ReimPayInvNo").setValue("");
			    reimPayGrid.removeAll();
			}
		});
//ģ��
var ingGridCm =[
     {
        header:"Key",
        dataIndex:'Key',
        hidden:true
    },
       {
        header:"RowId",
        dataIndex:'RowId',
        hidden:true
    },{
        header:"����",
        dataIndex:'IngrNo',
        width:150,
        align:'left',
        sortable:true
    },
    {
        header:"����",
        dataIndex:'TrType',
        width:60,
        align:'left',
        sortable:true,
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
        header:"���ʴ���",
        dataIndex:'InciCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'InciDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��Ʊ��",
        dataIndex:'InvNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"���",
        dataIndex:'RpAmt',
        width:100,
        align:'right',
        summaryType : 'sum',
        sortable:true
    },{
        header:"��Ӧ��",
        dataIndex:'VendorName',
        width:150,
        align:'left',
        sortable:true
    }  
];

 function paramsFn(){
	var Loc = Ext.getCmp('Loc').getValue();
	var InvNo = Ext.getCmp('InvNo').getValue();
	if(Ext.isEmpty(InvNo)){
		Msg.info("warning", "��¼�뷢Ʊ��!");
		return;
	}
	var Params = Loc + "^" + InvNo
	return {'Params' : Params};
}   
ingGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'ingGrid',
	plugins : new Ext.grid.GridSummary(),
	contentColumns : ingGridCm,
	smRowSelFn : Ext.emptyFn,
	singleSelect:false,
	selectFirst : false,
	actionUrl : gUrl,
	queryAction : "queryIng",
	idProperty : "Key",
	//checkProperty : "RowId",
	paramsFn : paramsFn,
	showTBar:false,
	paging:false
});
var VendorField = new Ext.ux.VendorComboBox({
		id: 'VendorField',
		name: 'VendorField',
		anchor: '90%'
	});
//ģ��
var reimPayGridCm =[
     {
        header:"RPIRowId",
        dataIndex:'RPIRowId',
        width:150,
        align:'left',
        sortable:true,
        saveColIndex : 0,
        hidden : true
   
    },
    {
        header:"��Ʊ��",
        dataIndex:'InvNo',
        width:120,
        align:'left',
        sortable:true
     },{
        header:"��Ʊ���",
        dataIndex:'InvRpAmt',
        width:150,
        align:'right',
        sortable:true
     },{
        header:"�ۿ���",
        dataIndex:'UnPayAmt',
        width:150,
        align:'right',
        saveColIndex : 1,
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.NumberField({
            selectOnFocus : true,
            allowBlank : false,
            listeners : {
                specialkey : function(field, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {                  
                    }
                }
            }
        }))
    }, {
		header: "��Ӧ��",
		dataIndex: 'VendorId',
		xtype: 'combocolumn',
		valueField: 'VendorId',
		saveColIndex : 2,
		width:150,
		displayField: 'VendorDesc',
		editor: VendorField
	},{
        header:"ʵ�����",
        dataIndex:'PayAmt',
        width:150,
        align:'right',
        sortable:true
	}
];
function paramsFnReimPay(){
	var ReimPayNo = Ext.getCmp('ReimPayNo').getValue();
	var ReimPayInvNo=Ext.getCmp('ReimPayInvNo').getValue();
	var Params = ReimPayNo+"^"+ReimPayInvNo
	return {'Params' : Params};
}

var save = new Ext.ux.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		var data = reimPayGrid.getModifiedInfo()
		if(data===false){
			return;
		}
		Ext.Ajax.request({
			url:'dhcstm.dhcreimpayaction.csp?actiontype=Save',
			params:{data:data},
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success", "����ɹ�!");
					reimPayGrid.reload()
				}else{
					if(jsonData.info==-1){
							Msg.info("error","����ʧ��,������ƾ֤!");
					}else{
						Msg.info("error","����ʧ��!");
					}
				}
			},
			scope: this
		});
	}	
});
reimPayGrid = new Ext.dhcstm.EditorGridPanel({
   	region : 'center',
	id : 'reimPayGrid',
	contentColumns : reimPayGridCm,
	smRowSelFn : Ext.emptyFn,
	singleSelect:false,
	selectFirst : false,
	actionUrl : gUrl,
	queryAction : "queryReimPay",
	idProperty : "RPIRowId",
	checkProperty : "",
	paramsFn : paramsFnReimPay,
	//beforeAddFn : beforeAddFn,
	tbar:save,
	delRowAction : "Delete",
	delRowParam : "RPIRowId",
	showTBar:true
});
reimPayGrid.AddNewRowButton.hidden = true;		//�����ò�����"����һ��"��ť
var ingformPanel = new Ext.ux.FormPanel({
	region:'north',
    tbar:[findBT,'-',addBt,'-',ClearBT],
    items : [{
        xtype : 'fieldset',
        title : '��ѯ����',
        autoHeight : true,
        layout : 'column',          
        items : [{
                columnWidth : .5,
                layout : 'form',
                items : [Loc]
            },{
                columnWidth : .5,
                layout : 'form',
                items : [InvNo]
            }]
    }]

});

var reimformPanel = new Ext.ux.FormPanel({
	region:'north',
    tbar:[findReimBT,'-',PrintBT,'-',CreateBT,'-',PrintBTReim,'-',ClearReimBT],
    items : [{
        xtype : 'fieldset',
        title : '��ѯ����',
        autoHeight : true,
        layout : 'column',          
        items : [{
                columnWidth : .5,
                layout : 'form',
                items : [ReimPayNo]
            },{
                columnWidth : .5,
                layout : 'form',
                items : [ReimPayInvNo]
            }]
    }]

});
    
//===========ģ����ҳ��===========================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var ingPanel = new Ext.Panel({
        title:'��Ʊ��ϸ',
        region:'west',
        width:600,
        layout:'border',
        items:[ingformPanel,ingGrid]                                 
    });
  var reimPayPanel = new Ext.Panel({
        title:'����֧����',
        region:'center',
        layout:'border',
        items:[reimformPanel,reimPayGrid]                                 
    });   
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[ingPanel,reimPayPanel]
    });
    
});
    
//===========ģ����ҳ��===========================================
