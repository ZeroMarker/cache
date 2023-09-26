// 名称:辅助请求(依据<转移入库>)
// 编写日期:2012-08-9
//=========================定义全局变量=================================
//var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];

// 请求部门
var LocField= new Ext.ux.LocComboBox({
	fieldLabel:'请求部门',
	id : 'LocField',
	name : 'LocField',
	emptyText:'请求部门...',
	groupId:gGroupId,
	width:180,
	listeners : {
		'select' : function(e) {
			var SelLocId=Ext.getCmp('LocField').getValue();//add wyx 根据选择的科室动态加载类组
			groupField.getStore().removeAll();
			groupField.getStore().setBaseParam("locId",SelLocId)
			groupField.getStore().setBaseParam("userId",UserId)
			groupField.getStore().setBaseParam("type",App_StkTypeCode)
			groupField.getStore().load();
			GetParam(e.value);	//修改供给科室后,以供给科室配置为准
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
	fieldLabel:'供给部门',
	listWidth:210,
	emptyText:'供给部门...',
	groupId:gGroupId,
	defaultLoc:{},
	width:180,
	relid:Ext.getCmp("LocField").getValue(),
	protype:'RF',
	params : {relid:'LocField'}
});

//类组
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
	fieldLabel:'开始日期',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:100,
	listWidth:100,
    allowBlank:true,
	fieldLabel:'结束日期',
	anchor:'90%',
	value:new Date()
});

var days = new Ext.form.NumberField({
	id:'days',
	fieldLabel:'参考天数',
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
	boxLabel:'建议请求量取整',
	allowBlank:true
});

var isIncludeZero = new Ext.form.Checkbox({
	id:'isIncludeZero',
	boxLabel:'包含请求量=0',
	allowBlank:true
});

var useInt = new Ext.form.Checkbox({
	id: 'useInt',
	boxLabel:'使用建议请求量',
	allowBlank:true
});

var isCheckKC = new Ext.form.Checkbox({
	id:'isCheckKC',
	boxLabel:'检查部门库存',
	allowBlank:true
});

//=========================定义全局变量=================================
//=========================请求单主信息=================================
var INRequestAuxByTransferGrid="";
//配置数据源
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
		{name:'stkQty'}, //库存
		{name:'avaQty'}, //可用开医嘱量
		{name:'dailyDispQty'}, //日发药量
		{name:'reqQtyAll'}, //days天需求量
		{name:'applyQty'}, //建议申请量
		{name:'ActualQty'} //实际申请量
	]),
    remoteSort:false
});
//模型
var INRequestAuxByTransferGridCm = new Ext.grid.ColumnModel([
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
        width:80,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"单位",
        dataIndex:'uomDesc',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"库存量",
        dataIndex:'stkQty',
        width:70,
        align:'right',
        sortable:true
    },{
        header:"可用量",
        dataIndex:'avaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"需求量",
        dataIndex:'dailyDispQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"建议申请量",
        dataIndex:'applyQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"实际申请量",
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
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width:70,
	height:30,
	handler:function(){
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
		//开始日期
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error", "请选择开始日期!");
			return false;
		}
		//结束日期
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}else{
			Msg.info("error", "请选择结束日期!");
			return false;
		}
		//参考天数
		var day = Ext.getCmp('days').getValue();
		if((day=="")||(day==null)){
			Msg.info("error", "请填写参考天数!");
			return false;
			}
		//类组
		var groupId = Ext.getCmp('groupField').getValue();
		//建议请求量取整
		var roundInt = (Ext.getCmp('isInt').getValue()==true?'Y':'N');
		//包含请求量=0
		var includeZero = (Ext.getCmp('isIncludeZero').getValue()==true?'Y':'N');
		//使用建议请求量
		var useInt = (Ext.getCmp('useInt').getValue()==true?'Y':'N');
		//检查部门库存
		var checkKC = (Ext.getCmp('isCheckKC').getValue()==true?'Y':'N');		
		
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc+"^"+roundInt+"^"+includeZero+"^"+useInt+"^"+checkKC;
		
		INRequestAuxByTransferGridDs.load({params:{strPar:strPar}});
		if(INRequestAuxByTransferGridDs.getCount()>0){
			productReqOrder.enable();
		}
	}
});

var productReqOrder = new Ext.Toolbar.Button({
	text:'生成请求单',
    tooltip:'生成请求单',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		var frLoc = Ext.getCmp('supplyLocField').getValue(); 
		var frLocName = Ext.getCmp('supplyLocField').getRawValue();
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", "请选择供给部门!");
			return false;
		}
		//请求部门
		var toLoc = Ext.getCmp('LocField').getValue(); 
		var toLocName = Ext.getCmp('LocField').getRawValue();
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", "请选择请求部门!");
			return false;
		}
		//类组
		var scg = Ext.getCmp('groupField').getValue();
		var scgName = Ext.getCmp('groupField').getRawValue();		
		if((scg=="")||(scg==null)){
			Msg.info("error", "请选择类组!");
			return false;
		}
		var count = INRequestAuxByTransferGridDs.getCount();
		if(count==0){
			Msg.info("error","没有出库请求明细,禁止保存!");
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
			if(str==""){Msg.info("error", "没有内容需要保存!");return false;};
			var req = "";
			var status = "";
			var remark = "转移入库";
			var reqInfo = frLoc+"^"+toLoc+"^"+UserId+"^"+scg+"^"+status+"^"+remark;
			
			Ext.Ajax.request({
				url : 'dhcst.inrequestaction.csp?actiontype=save',
				params:{req:req,reqInfo:reqInfo,data:str},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "保存成功!");
						req = jsonData.info;
						location.href="dhcst.inrequest.csp?reqByabConsume="+req;
					}else{
						if(jsonData.info==-1){
							Msg.info("error", "主表保存失败!");
						}else if(jsonData.info==-99){
							Msg.info("error", "主表加锁失败!");
						}else if(jsonData.info==-2){
							Msg.info("error", "主表解锁失败!");
						}else if(jsonData.info==-5){
							Msg.info("error", "明细保存失败!");
						}else if(jsonData.info==-4){
							Msg.info("error", "主表单号设置失败!");
						}else if(jsonData.info==-3){
							Msg.info("error", "主表保存失败!");
						}else{
							Msg.info("error", "保存失败!"+jsonData.info);
						}
					}
				},
				scope : this
			});
		}
	}
});

//初始化默认排序功能
INRequestAuxByTransferGridCm.defaultSortable = true;
/*
var pagingToolbar = new Ext.PagingToolbar({
    store:INRequestAuxByTransferGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
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
//表格
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
		title:'辅助请求(依据<转移入库>)',
		tbar:[find,'-',productReqOrder],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
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
//===========模块主页面===========================================