// 名称:辅助请求(依据<消耗及补货标准>)
// 编写日期:2012-08-3
//=========================定义全局变量=================================
var INRequestAuxByConsumeId = "";
var gLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.inrequestaction.csp';
var strPar = "";
var gGroupId=session['LOGON.GROUPID'];
if(gParam.length<1){
	GetParam();  //初始化参数配置
}
var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'请求部门',
	width:210,
	listWidth:210,
	emptyText:'请求部门...',
	groupId:gGroupId,
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
	width:210,
	listWidth:210,
	emptyText:'供给部门...',
	groupId:gGroupId,
	defaultLoc:{},
	relid:Ext.getCmp("LocField").getValue(),
	protype:'RF',
	params : {relid:'LocField'}
});
//类组
var group = new Ext.ux.StkGrpComboBox({
	id:'group',
	width:200,
	anchor:'90%',
	StkType:App_StkTypeCode,
	LocId:gLocId,
	UserId:UserId
});
// 库存分类
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
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
	fieldLabel:'开始日期',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'结束日期',
	anchor:'90%',
	value:new Date()
});

var days = new Ext.form.NumberField({
	id:'days',
	fieldLabel:'参考天数',
	allowBlank:true,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

//是否按标准补货控件暂时不用
var isBZ = new Ext.form.Checkbox({
	id: 'isBZ',
	boxLabel:'是否按标准补货',
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
	boxLabel:'数量取整',
	allowBlank:true,
	checked:true    
})

var CheckReqStock = new Ext.form.Checkbox({
	id: 'CheckReqStock',
	boxLabel:'库存小于消耗',
	allowBlank:true,
	checked:true 
})
var HelpBT = new Ext.Button({
	　　　　id:'HelpBtn',
			text : '帮助',
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
		});
//=========================定义全局变量=================================
//=========================请求单主信息=================================
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
//配置数据源
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
		{name:'StkQty'}, //库存
		{name:'avaQty'}, //可用开医嘱量
		{name:'dailyDispQty'}, //日发药量
		{name:'reqQtyAll'}, //days天需求量
		{name:'applyQty'}, //建议申请量
		{name:'dispQtyAll'}, //日期范围内发药总量
		{name:'stkCatDesc'}, //库存分类
		{name:'prvoqty'}, //供应方库存
		{name:'proReqQty'}  // 建议申请量原始值
	]),
    remoteSort:false
});
//模型
var INRequestAuxByConsumeGridCm = new Ext.grid.ColumnModel([
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
        header:"库存分类",
        dataIndex:'stkCatDesc',
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
        header:"规格",
        dataIndex:'spec',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"库存",
        dataIndex:'StkQty',
        width:70,
        align:'right',
        sortable:true
    },{
        header:"供应方库存",
        dataIndex:'prvoqty',
        width:70,
        align:'right',
        sortable:true
    },{
        header:"可用开医嘱量",
        dataIndex:'avaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"日发药量",
        dataIndex:'dailyDispQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"参考天数内需求量",
        dataIndex:'reqQtyAll',
        width:150,
        align:'right',
        sortable:true
    },{
        header:"申请量",
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
        header:"建议申请量",
        dataIndex:'proReqQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"日期范围内发药总量",
        dataIndex:'dispQtyAll',
        width:150,
        align:'right',
        sortable:true
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
		if(day==""){
			Msg.info("error", "请填写参考天数!");
			return false;
		}
		//类组
		var groupId = Ext.getCmp('group').getValue();
		//库存分类
        var stkCatId = Ext.getCmp('M_StkCat').getValue();
        //建议申请量取整
		var roundflag = Ext.getCmp('CheckRound').getValue();
        //验证请求方库存
        var reqenough= Ext.getCmp('CheckReqStock').getValue();
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc+"^"+stkCatId+"^"+roundflag+"^"+reqenough;
		
		INRequestAuxByConsumeGridDs.load({params:{start:0,limit:999,strPar:strPar}});
		save.enable();
	}
});

var save = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:true,
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
		var scg = Ext.getCmp('group').getValue();
		var scgName = Ext.getCmp('group').getRawValue();		
		if((scg=="")||(scg==null)){
			Msg.info("error", "请选择类组!");
			return false;
		}
		
		var count = INRequestAuxByConsumeGridDs.getCount();
		if(count==0){
			Msg.info("error","没有出库请求明细,禁止保存!");
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
					var proReqQty=rec.data['proReqQty']; // 建议申请量
					if (Number(qty)<=0){continue;}
					var tmp = rowid+"^"+inc+"^"+uom+"^"+qty+"^"+colRemark+"^"+scg+"^"+proReqQty;
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
			var remark = "辅助请求(依据消耗及补货标准)";
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

var clear = new Ext.Toolbar.Button({
	text:'清屏',
    tooltip:'清屏',
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

//初始化默认排序功能
INRequestAuxByConsumeGridCm.defaultSortable = true;
//表格
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
//=========================请求单主信息=================================

//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 60,
		title:'辅助请求(依据<消耗及补货标准>)',
		region:'north',
		labelAlign : 'right',
		height: DHCSTFormStyle.FrmHeight(3),
		frame : true,
		tbar:[find,'-',clear,'-',save,'-',HelpBT],
		items : [{
			
				layout : 'column',		
				xtype : 'fieldset',
				title : '选项信息',
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
        html: "<font size=3><p>---建议申请量定义---</p></font><font size=2 color=blue><p>日期范围内的发药数量的平均数</p></font><font size=2 color=red><p>乘以</p></font><font size=2 color=blue><p>参考天数</p></font><font size=2 color=red><p>减去</p></font><font size=2 color=blue><p>可用开医嘱数量</p></font>"+
        "<font size=3><p>---申请量取整数---</p></font><font size=2 color=blue><p>建议申请量计算出后为小数则舍去小数后加1</p></font>"+
        "<font size=3><p>---库存小于消耗---</p></font><font size=2 color=blue><p>过滤掉建议申请量不大于0的数据</p></font>"
    });
    Ext.getCmp('HelpBtn').focus('',100); //初始化页面给某个元素设置焦点
});
//===========模块主页面===========================================