// 名称:辅助请求(依据<消耗及补货标准>)
// 编写日期:2012-08-3

var gLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var URL = 'dhcstm.inrequestaction.csp';

var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'请求部门',
	listWidth:210,
	emptyText:'请求部门...',
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
	fieldLabel:'供给部门',
	store:frLocListStore,	 
	params:{LocId:'LocField'},
	filterName:'FilterDesc',	
	displayField:'Description',
	valueField:'RowId',
	listWidth:210,
	emptyText:'供给部门...',
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
//自动加载登陆科室的默认供给部门
LocField.fireEvent('select',LocField);
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
    allowBlank:true,
	fieldLabel:'从',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
    allowBlank:true,
	fieldLabel:'至',
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
	fieldLabel:'是否按标准补货',
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
		{name:'dailyDispQty'}, //日发放量
		{name:'reqQtyAll'}, //days天需求量
		{name:'applyQty'}, //建议申请量
		{name:'dispQtyAll'} //日期范围内发放总量
	]),
    remoteSort:false
});
//模型
var INRequestAuxByConsumeGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"物资rowid",
        dataIndex:'inci',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
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
        header:"可用开医嘱量",
        dataIndex:'avaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"日发放量",
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
        header:"建议申请量",
        dataIndex:'applyQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'applyQtyField',
            allowBlank:false
        })
    },{
        header:"日期范围内发放总量",
        dataIndex:'dispQtyAll',
        width:150,
        align:'right',
        sortable:true
    }
]);

var find = new Ext.Toolbar.Button({
	text:'查找',
    tooltip:'查找',
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
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error", "请选择开始日期!");
			return false;
		}
		//结束日期
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error", "请选择结束日期!");
			return false;
		}
		//参考天数
		var day = Ext.getCmp('days').getValue();
		//类组
		var groupId = Ext.getCmp('group').getValue();
		var strPar = toLoc+"^"+startDate+"^"+endDate+"^"+day+"^"+groupId+"^"+frLoc;
		
		INRequestAuxByConsumeGridDs.load({params:{start:0,limit:999,strPar:strPar}});
		save.enable();
	}
});

var save = new Ext.Toolbar.Button({
	text:'生成请求单',
    tooltip:'生成请求单',
    iconCls:'page_save',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
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
		//类组
		var scg = Ext.getCmp('group').getValue();	
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
			if(str==""){Msg.info("error", "没有内容需要保存!");return false;};
			var req = "";
			var status = "";
			var remark = "";
			var reqInfo = frLoc+"^"+toLoc+"^"+UserId+"^"+scg+"^"+status+"^"+remark;
			
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=save',
				params:{req:req,reqInfo:reqInfo,data:str},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "保存成功!");
						req = jsonData.info;
						location.href="dhcstm.inrequest.csp?reqByabConsume="+req;
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
							Msg.info("error", "保存失败!");
						}
					}
				},
				scope : this
			});
		}
	}
});

var clear = new Ext.Toolbar.Button({
	text:'清除',
    tooltip:'清除',
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

//初始化默认排序功能
INRequestAuxByConsumeGridCm.defaultSortable = true;

//表格
INRequestAuxByConsumeGrid = new Ext.ux.EditorGridPanel({
	region:'center',
	id: 'INRequestAuxByConsumeGrid',
	title: '消耗数据',
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
		title:'辅助请求(依据<消耗及补货标准>)',
		tbar:[find,'-',save,'-',clear],
		items : [{
				layout : 'column',
				xtype : 'fieldset',
				title : '选项信息',
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
