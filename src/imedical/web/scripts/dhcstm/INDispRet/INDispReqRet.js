// 名称:物资退回
// 编写日期:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var gHospId = session['LOGON.HOSPID'];

//保存参数值的object
var InDispReqRetParamObj = GetAppPropValue('DHCSTINDISPRETM');
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.indispretaction.csp';
var strParam = "";
var dsr = ""; //定义全局变量:主表rowid
var gDsrRetLocId = "";	//退回单接收科室

var DsrNo = new Ext.form.TextField({
	id:'DsrNo',
	fieldLabel:'退回单号',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// 退回部门
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '退回部门',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '退回部门...',
	groupId:gGroupId
	//defaultLoc:{}    //默认值为空
});

//类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	listWidth:150,
	fieldLabel:'制单日期',
	anchor:'90%',
	value:new Date(),
	disabled:true
});

var timeField=new Ext.form.TextField({
	id:'timeField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'制单时间'
});
var userField=new Ext.form.TextField({
	id:'userField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'制单人'
});

var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'备注',
	anchor:'90%',
	height:75,
	selectOnFocus:true
});

var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	boxLabel : '完成',
	anchor:'90%',
	disabled:true,
	listeners : {
		check : function(checkBox, checked){
			if(checked){
				Ext.getCmp("save").disable();
				Ext.getCmp("delete").disable();
				Ext.getCmp("complete").disable();
				Ext.getCmp("cancelComp").enable();
			}else{				
				Ext.getCmp("save").enable();
				Ext.getCmp("delete").enable();
				Ext.getCmp("complete").enable();
				Ext.getCmp("cancelComp").disable();
			}
		}
	}
});

var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','请领单'],['C','申领计划']]
})

var find = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//find.btnEl.mask() 
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearDsRet();FindINDispRet(Ext.getCmp('LocField').getValue(),refresh);}
			   }	
			})	
		}else{
			FindINDispRet(Ext.getCmp('LocField').getValue(),refresh);
		}
	}
});

var clear = new Ext.Toolbar.Button({
	id:'clear',
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){		
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
			   		if (btn=='yes') {
			   			clearDsRet();
			   			SetFormOriginal(formPanel);
					}
				}
			});
		}else{
			clearDsRet(); 
			SetFormOriginal(formPanel);
		}
	}
});

function clearDsRet()
{
	dsr="";
	gDsrRetLocId = "";
	InDsRetGridDs.removeAll();
	remark.setValue("");
	DsrNo.setValue("");  //groupField

	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");

	Ext.getCmp('save').enable();
	add.setDisabled(false);
	Ext.getCmp('LocField').setDisabled(false);
	SetLogInDept(LocField.getStore(),'LocField');
	groupField.store.load();
	setEditEnable();
}

function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
	var rowData = InDsRetGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	
	//供应商id^供应商名称^厂商id^厂商名称^配送商id^配送商名称^入库单位id^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
	//{success:'true',info:'7^GAYY-北京广安医药联合中心^61^bjymzy-北京益民制药厂^^^26^盒[20片]^0^0^0^^^艾司唑仑片^^普通片剂^[1mg*20]'}
	//取其它物资信息
	
	var locId = Ext.getCmp('LocField').getValue();
	if(locId!=""){
		Ext.Ajax.request({
			url : 'dhcstm.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ record.get("InciDr")+'&locId='+locId,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
					var ManfId = data[2];
					var Manf = data[3];
					rowData.set("manf", data[3]);    //生产商
					
					var UomId=data[6];
					var Uom=data[7];
					rowData.set("uom", UomId);    //单位Id
					rowData.set("uomDesc", Uom);    //单位名称
					rowData.set("sp", data[9]);     
					rowData.set("generic", data[13]);     
					rowData.set("drugForm", data[15]);   
					rowData.set("spec", data[16]);
				}
			},
			scope:this
		});
	}else{
		Msg.info("error","请选择科室!");
	}
	InDsRetGrid.startEditing(InDsRetGridDs.getCount() - 1, 6);
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,getDrugList2);
	}
}
//=========================定义全局变量=================================
//=========================退回单主信息=================================
function addNewRow() {
	if ((dsr!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前退回单已完成');
		return false;
	}
	var NewRecord = CreateRecordInstance(InDsRetGridDs.fields);
	InDsRetGridDs.add(NewRecord);
	var col=GetColIndex(InDsRetGrid,'desc');
	InDsRetGrid.startEditing(InDsRetGridDs.getCount() - 1, col);
	setEditDisable();
}

//配置数据源
var InDsRetGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'GET'});
var InDsRetGridDs = new Ext.data.Store({
	proxy:InDsRetGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    	}, [
		{name:'rowid',mapping:'dsritm'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'manf'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'remark'},
		{name:'dispQty'},
		{name:'inclb'},
		{name:'indsi',mapping:'dsi'},
		{name:'availQty'},
		{name:'dsiRetQty'},
		{name:'retDirtyQty'},
		"Brand","Model","Abbrev"
	]),
	remoteSort:false
});

//模型
var InDsRetGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"明细rowid",
        dataIndex:'rowid',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资rowid",
        dataIndex:'inci',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        id:'colDesc',
        width:150,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stkGrp=Ext.getCmp("groupField").getValue();
						//查找并确定可退货的数量
						InDispItmBat(Ext.getCmp('descField').getValue(),stkGrp,App_StkTypeCode,Ext.getCmp("LocField").getValue(),"",
								"","",HandleRet,gDsrRetLocId);
					}
				}
			}
        })
    },{
        header:"简称",
        dataIndex:'Abbrev',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"品牌",
        dataIndex:'Brand',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"型号",
        dataIndex:'Model',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"规格",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
    	header:'批号~效期',
    	dataIndex:'batNo',
    	width:200,
    	aligh:'left'
    },{
    	header:'效期',
    	dataIndex:'expDate',
    	width:80,
    	aligh:'left',
    	hidden:true
    },{
    	header:'可退数量',
    	dataIndex:'dispQty',
    	align:'right'
    },{
        header:"退回数量",
        dataIndex:'qty',
        id:'colQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(InDsRetGrid,"remark");
						InDsRetGrid.startEditing(cell[0], col);
					}
				}
			}
        })
    },{
    	header:'已退占用',
    	dataIndex:'dsiRetQty',
    	width:60,
    	align:'right',
    	hidden:true
    },{
    	header:'本次占用',
    	dataIndex:'retDirtyQty',
    	width:60,
    	align:'right'
    },{
        header:"单位rowid",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"单位",
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"进价",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"进价金额",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"售价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"售价金额",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"备注",
        dataIndex:'remark',
        id:'colRemark',
        width:200,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'remarkField',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
						if(InDsRetGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","退回数量不能为0!");
							var col=GetColIndex(InDsRetGrid,"qty");
							InDsRetGrid.startEditing(InDsRetGridDs.getCount() - 1, col);
							return false;
						}else{
							//增加一行
							addNewRow();
						}
					}
				}
			}
        })
    },{
    	header:'inclb',
    	dataIndex:'inclb',
    	hidden:true
    },{
    	header:'indsi',
    	dataIndex:'indsi',
    	hidden:true
    }
]);

var add = new Ext.Toolbar.Button({
	text:'新建',
	id:'newReq',
	iconCls:'page_add',
	tooltip:'新建库存转移退回单',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
			   		if (btn=='yes') {clearDsRet();}
				}
			})
		}else {
			clearDsRet();
		}
	}
});

function saveDsRet()
{  
	//主表信息
	//退回部门
	var toLoc = Ext.getCmp('LocField').getValue(); 
	if((toLoc=="")||(toLoc==null)){
		Msg.info("error", "请选择退回部门!");
		return false;
	}
	//登陆用户
	var user = UserId;
	//类组
	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "请选择类组!");
		return false;
	}
	
	//备注
	var remark = Ext.getCmp('remark').getValue(); 
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var RetLocId = gDsrRetLocId;
	if(RetLocId==""){
		RetLocId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",toLoc);
		if(RetLocId==""){
			Msg.info("warning","退回科室为空!");
			return;
		}
	}
	//主表信息字符串
	var dsrInfo = toLoc+"^"+user+"^"+scg+"^"+App_StkTypeCode+"^"+remark+"^"+RetLocId;
	//子表明细
	var data = "";
	var count= InDsRetGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InDsRetGridDs.getAt(index);	
		//新增或数据发生变化时执行下述操作
		if(rec.data.newRecord || rec.dirty){
			var inc = rec.data['inci'];
			var rowid= rec.data['rowid']
			var inclb= rec.data['inclb'];
			var qty = rec.data['qty'];
			var uom=rec.data['uom'];
			var rp= rec.data['rp'];
			var sp= rec.data['sp'];
			var rpAmt= rec.data['rpAmt'];
			var spAmt= rec.data['spAmt'];
			var indsi= rec.data['indsi'];
			var colRemark=rec.data['remark'];
			if((inclb!="")&&(inclb!=null)&&(qty!="")&&(qty!=null)&&(qty!=0)){
				var tmp = rowid+"^"+inclb+"^"+qty +"^"+uom+"^"+rp+"^"+rpAmt+"^"+sp+"^"+spAmt+"^"+indsi+"^"+colRemark;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
	}
	
	if ( (dsr=='')&& (data=="")) {Msg.info("error", "没有内容需要保存!");return false;};	
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "没有内容需要保存!");return false;};
	
	Ext.Ajax.request({
		url : URL+'?actiontype=SaveDispRet',
		params:{dsr:dsr,mainData:dsrInfo,detailData:data},
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				dsr = jsonData.info;
				refresh(dsr);
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

var save = new Ext.ux.Button({
	text:'保存',
	id:'save',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(InDsRetGrid.activeEditor!=null){
			InDsRetGrid.activeEditor.completeEdit();
		}
		//保存时传入三个字符串
		//1.主表rowid
		//2.主表的信息：frLoc、toLoc、user、scg、status、remark
		//3.子表明细信息：dsr、明细字符串rows(rows信息：reqi(明细rowid)、data(inci、uom、qty))
		saveDsRet();
	}
});

function refresh(dsr){
	Select(dsr);
	InDsRetGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsr:dsr}});
}

function Select(dsrId){
	if(dsrId==null || dsrId==''){
		return;
	}
	dsr=dsrId;
	Ext.Ajax.request({
		url : URL+'?actiontype=select&dsr='+dsrId,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);

			if (jsonData.results>0) {
				var data=jsonData.rows;
				if (!data) return;
				gDsrRetLocId = data[0]['DSR_RetLOC_DR'];
				Ext.getCmp('DsrNo').setValue(data[0]['DSR_No']);
				addComboData(Ext.getCmp('LocField').getStore(),data[0]['DSR_CTLOC_DR'],data[0]['locDesc']);
				Ext.getCmp('LocField').setValue(data[0]['DSR_CTLOC_DR']);
				Ext.getCmp('LocField').setDisabled(true);
				Ext.getCmp('dateField').setValue(data[0]['DSR_Date']);
				Ext.getCmp('timeField').setValue(data[0]['DSR_Time']); 
				Ext.getCmp('userField').setValue(data[0]['userName']); 
				addComboData(groupField.getStore(),data[0]['DSR_SCG_DR'],data[0]['scgDesc']);
				Ext.getCmp('groupField').setValue(data[0]['DSR_SCG_DR']);
				
				var completedFlag=data[0]['DSR_Completed'];
				Ext.getCmp("completeCK").setValue(completedFlag=="Y");
				Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),completedFlag=="Y");
				var remark=data[0]['remark'];
				remark=handleMemo(remark,xMemoDelim());
				Ext.getCmp('remark').setValue(remark);
				setEditDisable();
				SetFormOriginal(formPanel);
			}
		},
		scope : this
	});
}

var complete = new Ext.Toolbar.Button({
	id:'complete',
	text:'确认完成',
	tooltip:'确认完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (dsr=='') 
		{
			Msg.info('warning','没有任何退回单！');
			return ;
		}
		var completedFlag=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((completedFlag=="N")||(completedFlag=="")||(completedFlag==null)){
			Ext.Ajax.request({
				url : URL+'?actiontype=setComplete&dsr='+dsr+'&completedFlag=Y',
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "确认完成成功!");
						completeCK.setValue(true);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "设置失败!");
						}else if(jsonData.info==-1){
							Msg.info("error", "加锁失败!");
						}else{
							Msg.info("error", "设置失败!");
						}
					}
				},
				scope : this
			});
		}
	}
});

var cancelComplete = new Ext.Toolbar.Button({
	text:'取消完成',
    tooltip:'取消完成',
    id:'cancelComp',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (dsr=='') 
		{
			Msg.info('warning','没有任何退回单！');
			return ;
		}
		var completedFlag=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(completedFlag=="Y"){
			Ext.Ajax.request({
				url : URL+'?actiontype=cancelComplete&dsr='+dsr+'&completedFlag=N',
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "取消完成成功!");
						completeCK.setValue(false);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "设置失败!"+jsonData.info);
						}else if(jsonData.info==-1){
							Msg.info("error", "当前退回单已转为正式库存转移单,禁止取消完成!");
						}else if (jsonData.info==-99) {
							Msg.info("error", "加锁失败!");
						}else{
							Msg.info("error", "设置失败!"+jsonData.info);
						}
					}
				},
				scope : this
			});
		}
	}
});

function delReq(){
	if(dsr==null || dsr==""){
		Msg.info("warning","请选择要删除的退回单!");
		return;
	}
	
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='yes'){
				Ext.Ajax.request({
					url:URL+"?actiontype=Delete",
					method:'POST',
					params:{dsr:dsr},
					success:function(response,opts){
						var jsonData=Ext.util.JSON.decode(response.responseText);
						if(jsonData.success=='true'){
							Msg.info("success","删除成功!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
				   			clearDsRet();
				   			SetFormOriginal(formPanel);
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","该退回单已完成，不允许删除！");
							}else{
								Msg.info("error","删除失败:"+jsonData.info);
							}
						}
					},
					failure:function(response,opts){
						Msg.info("error","server-side failure with status code："+response.status);
					}
				});
			}
		}
	});
}

var del = new Ext.Toolbar.Button({
	text:'删除',
	id:'delete',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		delReq();
	}
});

var printBT = new Ext.Toolbar.Button({
	text : '打印',
	tooltip : '打印退回单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(dsr==null || dsr==""){
			Msg.info("warning","没有需要打印的退回单!");
			return;
		}
		PrintDsr(dsr);
	}
});

//删除转移退回明细
function DeleteDetail(){
	if ((dsr!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','当前退回单已完成');
		return;
	}
	
	var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","请选择数据!");
		return false;
	}
	else{
		var record = InDsRetGridDs.getAt(cell[0]);
		var reqItm = record.get("rowid");
		if(reqItm!=""){
			Ext.MessageBox.confirm('提示','确定要删除该记录?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : URL+'?actiontype=deleteItem&rowid='+reqItm,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									InDsRetGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsr:dsr}});
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "明细Id为空，删除失败!");
										return false;
									}else if(jsonData.info==-2){
										Msg.info("error", "不允许删除!");
										return false;
									}else{
										Msg.info("error", "删除失败!");
										return false;
									}
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
			)
		}
		else{
			InDsRetGridDs.remove(record);
			InDsRetGrid.getView().refresh();
		}
	
		if (InDsRetGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//初始化默认排序功能
InDsRetGridCm.defaultSortable = true;

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'增加一条明细记录',
	height : 30,
	width : 70,
	iconCls:'page_add',
	handler:function(){
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "请选择退回部门!");
			return ;
		}

		//类组
		var scg = Ext.getCmp('groupField').getValue(); 
		if((scg=="")||(scg==null)){
			Msg.info("warning", "请选择类组!");
			return false;
		}
		var rowCount =InDsRetGrid.getStore().getCount();
		if(rowCount>0){
			var rowData = InDsRetGridDs.data.items[rowCount - 1];
			var data=rowData.get("inci")
			if(data=="" || data.length<=0){
				Msg.info("warning","已存在新建行");
				return;
			}
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'删除一条明细记录',
	height : 30,
	width : 70,
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
})

var InDsRetGrid = new Ext.ux.EditorGridPanel({
	region : 'center',
	id:'reqItmEditGrid',
	store:InDsRetGridDs,
	cm:InDsRetGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT],
	listeners:{
		beforeedit : function(e){
			return !Boolean(Ext.getCmp('completeCK').getValue());
		},
		afteredit:function(e){
			if(e.field=="qty"){
				var dispQty=Number(e.record.get('dispQty'));	//可退数量
				var retDirtyQty=Number(e.record.get('retDirtyQty'));
				
				if(e.value-retDirtyQty-dispQty>0){
					Msg.info('error','退货数量不合理!');
					e.record.set('qty',e.originalValue);
					return;
				}
				e.record.set("rpAmt",accMul(e.value,e.record.get('rp')));
				e.record.set("spAmt",accMul(e.value,e.record.get('sp'))); 
			}
		}
	}
});

//zdm,增加右键删除明细功能
InDsRetGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	e.preventDefault();
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'删除',handler:DeleteDetail}]
});

//=========================退回单主信息=================================

//===========模块主页面===========================================

var formPanel = new Ext.ux.FormPanel({
	title:'物资退回制单',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT],
	items : [{
		xtype : 'fieldset',
		title : '退回单信息',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
			columnWidth:0.3,
			items : [LocField,groupField,DsrNo]
		},{
			columnWidth : 0.25,
			items : [dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			items : [remark]
		},{
			columnWidth : 0.2,
			items : [completeCK]
		}]
	}]
	
});

//查看退回单数据是否有修改
function isDataChanged()
{
	var changed=false;
	var count1= InDsRetGrid.getStore().getCount();
	//看主表数据是否有修改
	//修改为主表有修改且子表有数据时进行提示
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	}
	if (changed) return changed;
	//看明细数据是否有修改
	var count= InDsRetGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InDsRetGridDs.getAt(index);	
				//新增或数据发生变化时执行下述操作
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}	
	
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items : [formPanel,InDsRetGrid]
	});
});

//===========模块主页面===========================================
 ///设置可编辑组件的disabled属性
function setEditDisable(){
	Ext.getCmp('LocField').setDisabled(true);
	Ext.getCmp('groupField').setDisabled(true);
}
 ///放开可编辑组件的disabled属性
function setEditEnable(){
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('groupField').setDisabled(false);
}

function HandleRet(selectRows)
{
	var rowCnt=selectRows.length;
	for (var i=0;i<rowCnt;i++)
	{
		var rec=selectRows[i];
		var inclb = rec.get('inclb');
		var indsi =rec.get('indsi');
		var retqty =rec.get('retQty');
		var dispQty = rec.get('dispQty');
		var dsiRetQty = rec.get('dsiRetQty');
		//var retDirtyQty = rec.get('retDirtyQty');
		var uom =rec.get('dispUom');
		var uomDesc =rec.get('dispUomDesc');
		var inci=rec.get('inci');
		var code=rec.get('inciCode');
		var desc=rec.get('inciDesc');
		var spec=rec.get('spec');
		var batNo=rec.get('batNo');
		var expDate=rec.get('expDate');
 		var manf=rec.get('manf');
		var rp =rec.get('rp');
		var sp=rec.get('sp');
		
		var rpAmt=accMul(rp,retqty)
		var spAmt=accMul(sp,retqty)
		
		var findIndex=InDsRetGridDs.findExact('indsi',indsi,0);
		var curRow=InDsRetGrid.getSelectionModel().getSelectedCell()[0];
		if(findIndex>=0 && findIndex!=curRow){
			Msg.info("warning",desc+":"+batNo+"~"+expDate+"已存在于第"+(findIndex+1)+"行,不再新建记录!");
			continue;
		}else if(findIndex>=0 && findIndex==curRow){
			var recX=InDsRetGridDs.getAt(curRow);
		}else{
			if (i>0){addNewRow();}
			var lastRow=InDsRetGridDs.getCount()-1;
			var recX=InDsRetGridDs.getAt(lastRow);
		}
		
		recX.set('inclb',inclb);
		recX.set('indsi',indsi);
		recX.set('dispQty',dispQty);
		recX.set('qty',retqty);
		recX.set('dsiRetQty',dsiRetQty);
		recX.set('retDirtyQty',0);
		recX.set('uom',uom);
		recX.set('uomDesc',uomDesc);
		recX.set('inci',inci);
		recX.set('code',code);
		recX.set('desc',desc);
		recX.set('spec',spec);
		recX.set('manf',manf);
		recX.set('batNo',batNo+"~"+expDate);
		recX.set('expDate',expDate);
		recX.set('rp',rp);
		recX.set('rpAmt',rpAmt);
		recX.set('sp',sp);
		recX.set('spAmt',spAmt);
		recX.set('Brand',rec.get('Brand'));
		recX.set('Model',rec.get('Model'));
		recX.set('Abbrev',rec.get('Abbrev'));
	}
	
	var lastIndex=InDsRetGridDs.getCount()-1;
	if(InDsRetGridDs.getAt(lastIndex).get('indsi')!=""){
		addNewRow();
	}else{
		var col=GetColIndex(InDsRetGrid,'desc')
		InDsRetGrid.startEditing(lastIndex,col);
	}
}
