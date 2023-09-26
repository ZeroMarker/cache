// 名称:辅助请求(依据<库存上下限>)
// 编写日期:2012-08-10
//=========================定义全局变量=================================
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var rowDelim=xRowDelim();


// 请求部门
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '请求部门',
	id : 'LocField',
	name : 'LocField',
	emptyText : '请求部门...',
	groupId:gGroupId,
	width:180,
	listeners : {
		'select' : function(e) {
			var SelLocId=Ext.getCmp('LocField').getValue();//add wyx 根据选择的科室动态加载类组
			group.getStore().removeAll();
			group.getStore().setBaseParam("locId",SelLocId)
			group.getStore().setBaseParam("userId",UserId)
			group.getStore().setBaseParam("type",App_StkTypeCode)
			group.getStore().load();
			GetParam(e.value);	//修改供给科室后,以供给科室配置为准
		}
	}
});
LocField.on('select', function(e) {
    Ext.getCmp("supplyLocField").setValue("");
    Ext.getCmp("supplyLocField").setRawValue("");
});
var supplyLocField = new Ext.ux.LocComboBox({
	id:'supplyLocField',
	fieldLabel:'供给部门',
	listWidth:210,
	emptyText:'供给部门...',
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
//类组
var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});
// 库存分类
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{StkGrpId:'group'}
});

var reqOrder = new Ext.form.TextField({
	id:'reqOrder',
	fieldLabel:'请求单号',
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
	boxLabel:'包装量取整',
	allowBlank:true
});

var ManagerDrugSigner = new Ext.form.Checkbox({
	id:'ManagerDrugSigner',
	boxLabel:'管理药标志',
	allowBlank:true
});
//=========================定义全局变量=================================
//=========================请求单主信息=================================
var INRequestAuxByStkLimitGrid="";
//配置数据源
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
		{name:'minQty'}, //下限
		{name:'maxQty'}, //上限
		{name:'repQty'}, 
		{name:'incil'},
		{name:'pUom'},
		{name:'pUomDesc'},
		{name:'sbdesc'}, //货位
		{name:'reqQty'}, //请求数量
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
//模型
var INRequestAuxByStkLimitGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"药品rowid",
        dataIndex:'inci',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'desc',
        width:250,
        align:'left',
        sortable:true
    },{
        header:"单位",
        dataIndex:'pUomDesc',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"建议申请量",
        dataIndex:'reqQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"实际申请量",
        dataIndex:'realReqQty',
        width:120,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'reqQtyField',
            allowBlank:false
        })
    },{
        header:"当前库存",
        dataIndex:'qty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"供应方库存",
        dataIndex:'prvoqty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"库存上限",
        dataIndex:'maxQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"库存下限",
        dataIndex:'minQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"标准库存",
        dataIndex:'repQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"库存分类",
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
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width:70,
	height:30,
	handler:function(){
		INRequestAuxByStkLimitGridDs.removeAll();
		//供给部门
		var frLoc = Ext.getCmp('supplyLocField').getValue(); 
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", "请选择供给部门!");
			return false;
		}
		//请求部门
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", "请选择请求部门!");
			return false;
		}
		/*求部门和供给部门不能相同*/
		if (frLoc==toLoc){
			Msg.info("error", "请求部门和供给部门不能相同!");
			return false;
		}

		//类组
		var groupId = Ext.getCmp('group').getValue();
		
		if ((groupId=='')||(groupId==null)){
			Msg.info("error", "类组不能为空!");
			return false;
		}
        //库存分类
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
		//管理药标志
        	var man = (Ext.getCmp('ManagerDrugSigner').getValue()==true?1:0);
		//取整标志
		var round = (Ext.getCmp('IntSigner').getValue()==true?'Y':'N');
		var pid=getPid();		
		
		strPar = toLoc+"^"+frLoc+"^"+groupId+"^"+man+"^"+round+"^"+pid+"^"+0+"^"+stkCatId;
		
		INRequestAuxByStkLimitGridDs.setBaseParam('strPar',strPar);
		INRequestAuxByStkLimitGridDs.load({
			params:{start:0,limit:pagingToolbar.pageSize,sort:'code',dir:'desc'},
			callback:function(r,options, success){
					if(success==false){
     					Msg.info("error", "查询错误，请查看日志!");
					}
			}
		});
	}
});

//生成请领单
function CreateReq(){
	var frLoc = Ext.getCmp('supplyLocField').getValue(); 
	var frLocName = Ext.getCmp('supplyLocField').getRawValue();
	if((frLoc=="")||(frLoc==null)){
		Msg.info("warning", "请选择供给部门!");
		return;
	}
	//请求部门
	var toLoc = Ext.getCmp('LocField').getValue(); 
	var toLocName = Ext.getCmp('LocField').getRawValue();
	if((toLoc=="")||(toLoc==null)){
		Msg.info("warning", "请选择请求部门!");
		return;
	}
	//类组
	var scg = Ext.getCmp('group').getValue();
	var scgName=Ext.getCmp('group').getRawValue();
	var reqInfo=frLoc+"^"+toLoc+"^"+UserId+"^"+scg;
	var count = INRequestAuxByStkLimitGridDs.getCount();
	if(count==0){
		Msg.info("warning","没有请领明细,不能生成请求单!");
		return;
	}
	var record=INRequestAuxByStkLimitGridDs.getAt(0);
	var pid=record.get("pid");
	if(pid==null || pid==""){
		Msg.info("warning","没有请领明细,不能生成请求单!");
		return;
	}
	var data=INRequestAuxByStkLimitGridDs.getModifiedRecords();
	if(data.length>0){
		Msg.info("warning","存在尚未保存的记录，请先点击保存！");
		return;
	}
	Ext.Ajax.request({
		url : 'dhcst.inrequestaction.csp?actiontype=CreateReqByLim&Pid='+pid+'&ReqInfo='+reqInfo,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "生成请求单成功!");
				var infoArr = jsonData.info.split("^");
				var req = infoArr[0];
				var reqNo = infoArr[1];
				Ext.getCmp("reqOrder").setValue(reqNo);
				location.href="dhcst.inrequest.csp?reqByabConsume="+req;
			}else{					
				Msg.info("error", "生成请求单失败:"+jsonData.info);					
			}
		},
		scope : this
	});
}
var CreateBtn = new Ext.Toolbar.Button({
	text:'生成请求单',
    tooltip:'点击生成请求单',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:false,
	handler:function(){
		CreateReq();
	}	
});
var productReqOrder = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:false,
	handler:function(){
		var count = INRequestAuxByStkLimitGridDs.getCount();
		if(count==0){
			Msg.info("warning","没有请求明细,禁止保存!");
			return;
		}
		var str = "";
		var pid="";
		for(var index=0;index<count;index++){
			var rec = INRequestAuxByStkLimitGridDs.getAt(index);
			//if(rec.data.newRecord || rec.dirty){ 如果有新纪录或有改动
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
			Msg.info("warning","没有请求明细,禁止保存!");
			return;
		}	
		
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=SaveForAuxByLim',
			params:{Pid:pid,ListData:str},
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "保存成功!");
					INRequestAuxByStkLimitGridDs.commitChanges();
//					var reqNo=jsonData.info;
//					Ext.getCmp('reqOrder').setValue(reqNo);  //请求单号
				}else{					
					Msg.info("error", "保存失败:"+jsonData.info);					
				}
			},
			scope : this
		});
	}	
});
var clear = new Ext.Toolbar.Button({
	id:'clearData',
	text:'清屏',
    tooltip:'清屏',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.Msg.show({
			title:'提示',
			msg: '是否确定清空辅助请求数据?(注:此数据为临时统计结果,可重新统计.)',
			buttons: Ext.Msg.YESNO,
			fn: function(btn){
		   		if (btn=='yes') {clearDataGrid();}
		   }
		})
	}
});

function clearDataGrid()
{
	//清空临时global数据
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

//初始化默认排序功能
INRequestAuxByStkLimitGridCm.defaultSortable = true;

var pagingToolbar = new Ext.PagingToolbar({
    store:INRequestAuxByStkLimitGridDs,
	pageSize:PageSize,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
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
		staParArr[6]=1	//1:表示翻页
		B['strPar']=staParArr.join("^") //1:表示翻页
		var data=INRequestAuxByStkLimitGridDs.getModifiedRecords();
		if(data.length>0){
			Msg.info("warning","本页有尚未保存的记录，请先保存！");
			return;
		}
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
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
			Msg.info('error','后台临时数据清空错误!')	
		}		
	});

}

//=========================请求单主信息=================================

//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoScroll : false,
		title:'辅助请求(依据<库存上下限>)',
		tbar:[find,'-',clear,'-',productReqOrder,'-',CreateBtn],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
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
//===========模块主页面===========================================