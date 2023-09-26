// 名称:报销支付单
// 编写日期:2018-02-24
var gUserId = session['LOGON.USERID'];  
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gUrl="dhcstm.dhcreimpayaction.csp"

var Loc=new Ext.ux.LocComboBox({
	fieldLabel:'科室',
	id:'Loc',
	name:'Loc',
	groupId:gGroupId
});
var InvNo = new Ext.form.TextField({
    id:'InvNo',
    fieldLabel:'发票号',
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
    fieldLabel:'报支单号',
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
    fieldLabel:'发票号',
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
    text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
    handler:function(){

	    var Locid=Ext.getCmp("Loc").getValue();
	    var InvNo=Ext.getCmp("InvNo").getValue();
	    if (Locid==null || Locid=="") {
		    Msg.info("warning","请选择科室!");
		    return;
		}
		if (InvNo==null || InvNo=="") {
		    Msg.info("warning","请输入发票号!");
		    return;
		}
		var retinfo=tkMakeServerCall("web.DHCSTM.DHCReimPay","CheckLocInv",Locid,InvNo);
		if (retinfo==-1){
		   Msg.info("warning","存在未来审核的入库单!");
		   return;
		}else if (retinfo==-2){
		   Msg.info("warning","发票号:"+InvNo+"没有需要处理的数据!");
		   return;
		}else{
          ingGrid.load();   
		}

    }
});
var findReimBT = new Ext.ux.Button({
    text:'查询',
    tooltip:'查询',
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
	text:'加入报支单',
    iconCls:'page_add',
	handler:function(){
		add()
	}
});
function add ()
{

	var ReimPayNo = Ext.getCmp("ReimPayNo").getValue();
	var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","getComFlag",ReimPayNo)
	if(Ret=="Y"){ Msg.info("error", "已经生成凭证，不能继续添加");return}
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
		Msg.info("error", "没有内容需要添加!");
		loadMask.hide();
		return false;
	}
	loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	var url =gUrl+"?actiontype=addReimPay";
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{MainInfo:MainInfo,ListDetail:ListDetail},
		waitMsg : '处理中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var RPIRowid = jsonData.info;
				if(Ext.isEmpty(Ext.getCmp("ReimPayNo").getValue())){
				var RPNo=tkMakeServerCall("web.DHCSTM.DHCReimPay","getRPNo",RPIRowid)
				Ext.getCmp("ReimPayNo").setValue(RPNo)
				}
				findReimBT.handler()
				Msg.info("success", "保存成功!");
				ClearBT.handler()
				} else {
				var ret=jsonData.info;
				if(ret==-99){
					Msg.info("error", "加锁失败,不能保存!");
				}
				if(ret==-2){
					Msg.info("error", "加锁失败,不能保存!");
				}else{
					Msg.info("error", "保存失败!");
				}
			}
			loadMask.hide();
		},
		scope : this
	});
}

var ClearBT = new Ext.ux.Button({
			text : '清空',
			iconCls : 'page_clearscreen',
			handler : function() {
				SetLogInDept(Loc.getStore(),'Loc');
				Ext.getCmp("InvNo").setValue("");
			    ingGrid.removeAll();
			}
		});
// 打印按钮
var PrintBT = new Ext.ux.Button({
	text : '打印报支单',
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
// 打印按钮
var CreateBT = new Ext.ux.Button({
	text : '生成凭证',
	iconCls : 'page_add',
	handler : function() {
		var ReimPayNo = Ext.getCmp("ReimPayNo").getValue();
		var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","setCom",ReimPayNo)
		 if(Ret==-2){ Msg.info("error", "已经生成凭证，不能重复生成");return}
		var Ret=tkMakeServerCall("web.DHCSTM.DHCReimPay","AcctVoucherNo",ReimPayNo,gUserId)
		if(Ret==0){
			Msg.info("success", "成功!");
		}
	}
});
// 打印按钮
var PrintBTReim = new Ext.ux.Button({
	text : '打印凭证',
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
			text : '清空',
			iconCls : 'page_clearscreen',
			handler : function() {
				Ext.getCmp("ReimPayNo").setValue("");
				Ext.getCmp("ReimPayInvNo").setValue("");
			    reimPayGrid.removeAll();
			}
		});
//模型
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
        header:"单号",
        dataIndex:'IngrNo',
        width:150,
        align:'left',
        sortable:true
    },
    {
        header:"类型",
        dataIndex:'TrType',
        width:60,
        align:'left',
        sortable:true,
     	renderer : function(value){
			var TrName = value;
			if(value == 'G'){
				TrName = '入库单';
			}else if (value == 'R'){
				TrName = '退货单';
			}
			return TrName;
     	}
     },{
        header:"物资代码",
        dataIndex:'InciCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'InciDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"发票号",
        dataIndex:'InvNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"金额",
        dataIndex:'RpAmt',
        width:100,
        align:'right',
        summaryType : 'sum',
        sortable:true
    },{
        header:"供应商",
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
		Msg.info("warning", "请录入发票号!");
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
//模型
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
        header:"发票号",
        dataIndex:'InvNo',
        width:120,
        align:'left',
        sortable:true
     },{
        header:"发票金额",
        dataIndex:'InvRpAmt',
        width:150,
        align:'right',
        sortable:true
     },{
        header:"扣款金额",
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
		header: "供应商",
		dataIndex: 'VendorId',
		xtype: 'combocolumn',
		valueField: 'VendorId',
		saveColIndex : 2,
		width:150,
		displayField: 'VendorDesc',
		editor: VendorField
	},{
        header:"实付金额",
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
	text:'保存',
	tooltip:'保存',
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
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success", "保存成功!");
					reimPayGrid.reload()
				}else{
					if(jsonData.info==-1){
							Msg.info("error","保存失败,已生成凭证!");
					}else{
						Msg.info("error","保存失败!");
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
reimPayGrid.AddNewRowButton.hidden = true;		//隐藏用不到的"增加一行"按钮
var ingformPanel = new Ext.ux.FormPanel({
	region:'north',
    tbar:[findBT,'-',addBt,'-',ClearBT],
    items : [{
        xtype : 'fieldset',
        title : '查询条件',
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
        title : '查询条件',
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
    
//===========模块主页面===========================================
Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    var ingPanel = new Ext.Panel({
        title:'发票明细',
        region:'west',
        width:600,
        layout:'border',
        items:[ingformPanel,ingGrid]                                 
    });
  var reimPayPanel = new Ext.Panel({
        title:'报销支付单',
        region:'center',
        layout:'border',
        items:[reimformPanel,reimPayGrid]                                 
    });   
    var mainPanel = new Ext.ux.Viewport({
        layout:'border',
        items:[ingPanel,reimPayPanel]
    });
    
});
    
//===========模块主页面===========================================
