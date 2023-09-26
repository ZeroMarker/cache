// 名称:库存调整制单
// 编写日期:2012-08-27

var mainRowId="";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var inciDr = "";

//保存参数值的object
var InAdjParamObj = GetAppPropValue('DHCSTSTOCKADJM');

//取高值管理参数
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}
//若使用高值跟踪,分一般报损和高值报损两个菜单,否则不需区分
UseItmTrack=UseItmTrack&&gHVInAdj;

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'科室',
	//width:120,
	listWidth:200,
	emptyText:'科室...',
	groupId:gGroupId,
	anchor:'90%',
	stkGrpId : 'groupField'
});

var adjUserField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:'调整人',
	anchor:'90%',
	disabled:true
});


//=========================库存调整制单=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
    allowBlank:false,
	fieldLabel:'制单日期',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
    allowBlank:false,
	fieldLabel:'制单时间',
	anchor:'90%',
	disabled:true
});

var adjNumField = new Ext.form.TextField({
	id:'adjNumField',
	fieldLabel:'调整单号',
	allowBlank:true,
	//width:120,
	emptyText:'调整单号...',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:'备注',
	allowBlank:true,
	height:50,
	listWidth:200,
	emptyText:'备注...',
	anchor:'90%',
	selectOnFocus:true
});

// 物资类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:'类组',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:CtLocId,
	UserId:UserId,
	anchor : '90%'
});

// 调整原因
var causeField = new Ext.form.ComboBox({
	id:'causeField',
	fieldLabel:'调整原因',
	listWidth:200,
	allowBlank:true,
	store:ReasonForAdjustMentStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'调整原因...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%'
});
ReasonForAdjustMentStore.load();

var adjComplete=new Ext.Toolbar.Button({
	text:'单据完成',
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		setComplete();
	}
});

var cancelAdjComplete=new Ext.Toolbar.Button({
	text:'取消单据完成',
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		cancelComplete();
	}
});

var printInadj = new Ext.Toolbar.Button({
	id : "printInadj",
	text : '打印',
	tooltip : '打印调整单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId==null || mainRowId=="") {
			Msg.info("warning", "没有需要打印的调整单!");
			return;
		}
		PrintInAdj(mainRowId);
	}
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	fieldLabel:'完成',
	disabled:true,
	allowBlank:true
});

var auditCK = new Ext.form.Checkbox({
	id: 'auditCK',
	fieldLabel:'审核',
	disabled:true,
	allowBlank:true
});

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	height:30,
	width:70,
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{	
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'删除一条',
	height:30,
	width:70,
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});

//配置数据源
var INAdjMGridUrl = 'dhcstm.inadjaction.csp';
var INAdjMGridProxy= new Ext.data.HttpProxy({url:INAdjMGridUrl+'?actiontype=queryItem',method:'GET'});
var INAdjMGridDs = new Ext.data.Store({
	proxy:INAdjMGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'adjitm'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qtyBUOM'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'insti'},
		{name:'Inclbqty'},
		"HVFlag","HVBarCode",
		{name:'AvaQty'}
	]),
    remoteSort:false
});

var HVBarCodeEditor = new Ext.form.TextField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var row=INAdjMGrid.getSelectionModel().getSelectedCell()[0];
				var findHVIndex=INAdjMGridDs.findExact('HVBarCode',Barcode,0);
				if(findHVIndex>=0 && findHVIndex!=row){
					Msg.info("warning","不可重复录入!");
					field.setValue("");
					return;
				}
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
							if(Ext.getCmp("groupField").getValue()!=scgID){
								Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
								INAdjMGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(inclb==""){
								Msg.info("warning","该高值材料没有相应库存记录,不能制单!");
								INAdjMGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(lastDetailAudit!="Y"){
								Msg.info("warning","该高值材料有未审核的"+lastDetailOperNo+",请核实!");
								INAdjMGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(type=="T"){
								Msg.info("warning","该高值材料已经出库,不可制单!");
								INAdjMGrid.store.getAt(row).set("HVBarCode","");
								return;
							}else if(status!="Enable"){
								Msg.info("warning","该高值条码处于不可用状态,不可制单!");
								INAdjMGrid.store.getAt(row).set("HVBarCode","");
								return;
							}
							var record = Ext.data.Record.create([{
									name : 'InciDr',
									type : 'string'
								}, {
									name : 'InciCode',
									type : 'string'
								}, {
									name : 'InciDesc',
									type : 'string'
								}]);
							var InciRecord = new record({
								InciDr : inciDr,
								InciCode : inciCode,
								InciDesc : inciDesc
							});
							var phaLoc = Ext.getCmp("locField").getValue();
							var phaLocRQ = "";
							var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
								+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
							var LBResult=ExecuteDBSynAccess(url);
							var info=Ext.util.JSON.decode(LBResult);
							if(info.results=='0'){
								Msg.info("warning","该高值材料没有相应库存记录,不能制单!");
								INAdjMGrid.store.getAt(row).set("HVBarCode","");
								return;
							}
							var inforows=info.rows[0];
							Ext.applyIf(InciRecord.data,inforows);
							returnInfo(InciRecord);
						}else{
							Msg.info("warning","该条码尚未注册!");
							INAdjMGrid.store.getAt(row).set("HVBarCode","");
							return;
						}
					}
				});
			}
		}
	}
});

//模型
var INAdjMGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"明细rowid",
        dataIndex:'adjitm',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"批次rowid",
        dataIndex:'inclb',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资rowid",
        dataIndex:'inci',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        id:'desc',
        width:300,
        align:'left',
        sortable:true,
        editable:!UseItmTrack,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp('groupField').getValue());
					}
				}
			}
        })
    },{
        header:"高值标志",
        dataIndex:'HVFlag',
        width:60,
        align:'center',
        sortable:true,
        hidden:true
    },{
    	header:"高值条码",
    	dataIndex:'HVBarCode',
    	id:'HVBarCode',
    	width:150,
    	align:'left',
        hidden:!UseItmTrack,
        editable:UseItmTrack,
    	editor:HVBarCodeEditor
    },{
        header:"规格",
        dataIndex:'spec',
        width:200,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"批次~效期",
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"调整单位",
        dataIndex:'uomDesc',
        width:100,
        align:'left'
    },{
        header:"调整单位Rowid",
        dataIndex:'uom',
        width:100,
        align:'right',
        sortable:true,
		hidden:true
    },{
        header:"批次库存",
        dataIndex:'Inclbqty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"批次可用库存",
        dataIndex:'AvaQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"调整数量",
        id:'adjQty',
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
						var rowData = INAdjMGridDs.getAt(cell[0]);
						if(Number(field.getValue())+Number(rowData.get('AvaQty'))<0){
							var col=GetColIndex(INAdjMGrid,'qty');
							INAdjMGrid.startEditing(cell[0], col);
						}else{
							addNewRow();
						}
					}
				}
			}
        })
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
        sortable:true,
        summaryType : 'sum'
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
        sortable:true,
        summaryType : 'sum'
    }
]);
//初始化默认排序功能
INAdjMGridCm.defaultSortable = true;

var addINAdjM = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {newINAdj();}
				}
			})
		}
		else
		{newINAdj();}
	}
});

function newINAdj(){
	//新增^查询^保存^删除^完成^取消完成^清空^打印
	changeButtonEnable("1^1^1^0^0^0^1^0")
	mainRowId='';
	clearPage();
	addNewRow();

}
var findINAdjM = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearPage();FindINAdj(INAdjMGridDs,adjNumField,mainRowId,locField,dateField,addINAdjM,finshCK,auditCK,select);}
				}
			})
		}else{
			clearPage();
			FindINAdj(INAdjMGridDs,adjNumField,mainRowId,locField,dateField,addINAdjM,finshCK,auditCK,select);
		}
	}
});


var saveINAdjM = new Ext.ux.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save();
    }
});

var deleteINAdjM = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		deleteAdj();
	}
});

var clearINAdjM = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearPage();SetFormOriginal(formPanel);}
				}

			})
		}
		else
		{
			clearPage();
			SetFormOriginal(formPanel);
		}
	}
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 80,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
	tbar:[addINAdjM,'-',findINAdjM,'-',saveINAdjM,'-',deleteINAdjM,'-',adjComplete,'-',cancelAdjComplete,'-',clearINAdjM,'-',printInadj],
	items : [{
		//autoHeight : true,
		layout : 'fit',
		autoScroll:true,
		items : [{
			xtype : 'fieldset',
			title : '调整单信息',
			autoHeight : true,
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .263,
					layout : 'form',
					items : [adjNumField,causeField,adjUserField]
				}, {
					columnWidth : .25,
					layout : 'form',
					items : [locField,dateField,timeField]
				}, {
					columnWidth : .25,
					layout : 'form',
					items : [groupField,remarkField]
				}, {
					columnWidth : .2,
					layout : 'form',
					items : [finshCK,auditCK]
				}]
			}]
		}]
	}]
});

//表格
var INAdjMGrid = new Ext.grid.EditorGridPanel({
	title:'明细记录',
	store:INAdjMGridDs,
	cm:INAdjMGridCm,
	id:'INAdjMGrid',
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	plugins : new Ext.grid.GridSummary(),
	tbar:[AddDetailBT,'-',DelDetailBT,'-',{height:30,width:70,text:'列设置',iconCls:'page_gear',handler:function(){	GridColSet(INAdjMGrid,"DHCSTSTOCKADJM");}}],
	listeners:{
		beforeedit:function(e){
			if(Ext.getCmp("finshCK").getValue()===true){
				return false;
			}
			if(e.field=="desc" || e.field=="qty" || e.field=="uom"){
				if(e.record.get("HVBarCode")!=""){
					e.cancel=true;
				}
			}
			if(e.field=="HVBarCode" && e.record.get("inclb")!=""){
				e.cancel=true;
			}
		},
		afteredit:function(e){
			if(e.field=='qty'){
				if(e.value<0 && Math.abs(e.value)>Number(e.record.get('AvaQty'))){
					Msg.info("error","调整数量为负数时不能超过批次库存!");
					e.record.set('qty',e.originalValue)
					return;
				}else{
					e.record.set("spAmt",accMul(e.value,e.record.get('sp')));
					e.record.set("rpAmt",accMul(e.value,e.record.get('rp')));
				}
			}
		}
	}
});
//=========================库存调整制单=============================

function checkBeforeSave()
{	
	//检查是否有明细记录
	if (mainRowId=='')
	{
		if (INAdjMGrid.getStore().getCount()==0)
		{
			Msg.info('error','没有任何明细记录!');
			return false;
		}
	}
	//检查明细情况
	
	return true;
}
function save()
{
	if (!checkBeforeSave()) return;
	
	var adjUser = UserId;
	var adjStkType = App_StkTypeCode
	var adjInst = "";
	var adjLoc = Ext.getCmp('locField').getValue();
	if((adjLoc=="")||(adjLoc==null)){
		Msg.info("error","请选择供应科室!");
		return false;
	}
	
	var adjScg = Ext.getCmp('groupField').getValue();
	if((adjScg=="")||(adjScg==null)){
		Msg.info("error","请选择类组!");
		return false;
	}
	
	var adjComp = (Ext.getCmp('finshCK').getValue()==true?'Y':'N');
	//var adjState = (Ext.getCmp('auditCK').getValue()==true?'Y':'N');
	var adjState = '10';
	var adjReason = Ext.getCmp('causeField').getValue();
	if((adjReason=="")||(adjReason==null)){
		Msg.info("error","请选择调整原因!");
		return false;
	}
	var remark = Ext.getCmp('remarkField').getValue();
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var mainData = adjLoc+"^"+adjUser+"^"+adjReason+"^"+adjScg+"^"+adjStkType+"^"+adjInst+"^"+adjComp+"^"+adjState+"^"+remark;
	
	//alert(mainData);
	//组织明细数据
	var detailData="";
	var count = INAdjMGridDs.getCount();
	for(var index=0;index<count;index++){		
		var rec = INAdjMGridDs.getAt(index);
		if (rec.data.newRecord || rec.dirty){		
			var adjitm = rec.get('adjitm'); //子表明细rowid
			var inclb = rec.get('inclb');//批次rowid
			var Inclbqty=rec.get("Inclbqty");
		
			if((inclb!="")&&(inclb!=null)){
				var qty = rec.get('qty');
				
				if ((qty=='')||(parseFloat(qty)==0)){
					Msg.info('error','当前行调整数量不可为空!');
					var qtyColIndex=Ext.getCmp('INAdjMGrid').getColumnModel().getIndexById('adjQty');
					Ext.getCmp('INAdjMGrid').getSelectionModel().select(index,qtyColIndex);	
					return;				
				} 
				if(qty<0 && (Math.abs(qty)>Inclbqty)){
					         Msg.info("error","调整数量为负数时不能超过批次库存!");
					         return;}
				var uom = rec.get('uom');
				var sp = rec.get('sp');
				var spAmt = rec.get('spAmt');
				var rp = rec.get('rp');
				var rpAmt = rec.get('rpAmt');
				var insti = rec.get('insti');
				var HVBarCode = rec.get('HVBarCode');
				var tmp = adjitm+"^"+inclb+"^"+qty+"^"+uom+"^"+rp+"^"+sp+"^"+rpAmt+"^"+spAmt+"^"+insti+"^"+HVBarCode;
				if(detailData!=""){
					detailData = detailData+xRowDelim()+tmp;
				}else{
					detailData = tmp;
				}
			}							
		}
	}
	if(!IsFormChanged(formPanel) && detailData=="")
		{Msg.info("error", "没有内容需要保存!");
		return false;};
	var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		url: INAdjMGridUrl+'?actiontype=saveAdj',
		params:{adj:mainRowId,mainData:mainData,detailData:detailData},
		failure: function(result,request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","保存成功!");
				mainRowId=jsonData.info   //rowid - 主表rowid
				select(mainRowId)
				//新增^查询^保存^删除^完成^取消完成^清空^打印
	            changeButtonEnable("1^1^1^1^1^0^1^1")
			}else{
				if(jsonData.info==-1){
					Msg.info("error","插入出错!");
				}else{
					Msg.info("error","保存失败!"+jsonData.info);
				}
			}
		},
		scope: this
	});
	loadMask.hide();
}


//调出主表的数据到控件
function select(rowid)
{
	mainRowId=rowid;
	Ext.Ajax.request({
		url:INAdjMGridUrl+"?actiontype=select&adj="+rowid,
		failure:function(){alert('failure');},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.results>0) {
				data=jsonData.rows;
				if (!data) return;
				//alert(data);
				//if (data=='') return;

				//var ss=data.split("^");
				var loc=data[0]['INAD_CTLOC_DR'];
				var locDesc=data[0]['locDesc'];
				var scg=data[0]['INAD_SCG_DR'];
				var scgDesc=data[0]['scgDesc'];
				var reason=data[0]['INAD_ReasonAdj_DR'];
				var reasonDesc=data[0]['reasonDesc'];
			
				var no=data[0]['INAD_No'];
				var adjDate=data[0]['INAD_Date'];
				var adjTime=data[0]['INAD_Time'];
				var completeFlag=data[0]['INAD_Completed']; 
				var auditFlag=data[0]['INAD_ChkFlag'] ;
				var remark=data[0]['INAD_Remarks']  ;
				remark=handleMemo(remark,xMemoDelim());
				
				var userName=data[0]['userName'] ;
				var auditUserName=data[0]['INAD_ChkUser_DR'];
				var chkDate=data[0]['INAD_ChkDate'];
				var chkTime=data[0]['INAD_ChkTime'];
				
				addComboData(Ext.getCmp("locField").getStore(),loc,locDesc);
				Ext.getCmp('locField').setValue(loc);
				Ext.getCmp('adjNumField').setValue(no);
				
				Ext.getCmp('dateField').setValue(adjDate);
			
				Ext.getCmp('adjUserField').setValue(userName);
			
				Ext.getCmp('timeField').setValue(adjTime);
				Ext.getCmp('finshCK').setValue(((completeFlag=='Y')?'true':'false'));
				
				//alert(completeFlag);
				INAdjMGridDs.load({params:{start:0,limit:999,adj:rowid}});
				
				if (completeFlag=='Y') 
				{//saveINAdjM.disable();
				changeButtonEnable("1^1^0^0^0^1^1^1");}
				else
				{//saveINAdjM.enable();
				changeButtonEnable("1^1^1^1^1^0^1^1");}
				
				Ext.getCmp('auditCK').setValue(((auditFlag=='Y')?'true':'false'));
				addComboData(Ext.getCmp('causeField').getStore(),reason,reasonDesc);
				Ext.getCmp('causeField').setValue(reason);
				addComboData(null,scg,scgDesc,groupField);
				Ext.getCmp('groupField').setValue(scg);
				Ext.getCmp('remarkField').setValue(remark);  //备注
				
			}else{
				if(jsonData.info==-1){
					Msg.info("error","检索主表出错!");
				}else{
					Msg.info("error","检索主表失败!"+jsonData.info);
				}
			}
			
			setEditDisable();
			SetFormOriginal(formPanel);
		}
	});
	
	//Ext.getCmp('INAdjMGrid').getStore().load(rowid);
	
}
	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "0", HospId,"",returnInfo,"A");
	}
}

//增加一条(明细)
function addDetailRow(){
	//新增^查询^保存^删除^完成^取消完成^清空^打印
	  changeButtonEnable("1^1^1^0^0^0^1^0")
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true)){
		Msg.info('warning','当前调整单已完成,禁止增加明细记录!');
		return;
	}
	addNewRow();
}

//删除一条(明细)
function DeleteDetail()
{	
	var complete=Ext.getCmp('finshCK').getValue();
	if (complete==true)
	{
		Msg.info('warning','已经完成,禁止删除明细记录!');	return;
	}
	
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();

	if(cell==null){
		Msg.info("warning","请选择数据!");
		return false;
	}else{
		var record = INAdjMGridDs.getAt(cell[0]);
		var rowid = record.get("adjitm");
		if(rowid!=""){
			Ext.MessageBox.confirm('提示','确定要删除该记录?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcstm.inadjaction.csp?actiontype=deleteItem&rowid='+rowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									INAdjMGridDs.load({params:{start:0,limit:999,adj:mainRowId}});
								}else{
									Msg.info("error", "删除失败!");
									return false;
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				}
			)
		}else{
			//Msg.info("error", "明细Id为空,不允许删除!");
			INAdjMGridDs.remove(record);
			INAdjMGrid.getView().refresh();
		}
	
		if (INAdjMGridDs.getCount()==0){
			setEditEnable();
		}	
	}
}
//科室库存项批次信息窗口关闭时回调函数
function returnInfo(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records,function(record,index,allItems){
		var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
		var selectRow = cell[0];
		var HVFlag=record.get("HVFlag");
		var inclb = record.get("Inclb");
		if(!UseItmTrack || HVFlag!='Y'){
			var findIndex=INAdjMGridDs.findExact('inclb',inclb,0);
			if(findIndex>=0 && findIndex!=selectRow){
				var batInfo = record.get("InciDesc")+":"+record.get("BatExp");
				Msg.info("warning", batInfo+"批次重复!");
				return;
			}
		}
		var ItmTrack=gItmTrackParam[0]=='Y'?true:false;
		if(!(ItmTrack==gHVInAdj) && HVFlag=='Y'){
			Msg.info("warning",record.get("InciDesc")+"是高值材料,请根据条码录入!");
			return;
		}
		var rowData = INAdjMGrid.getStore().getAt(cell[0]);
		inciDr = record.get("InciDr");
		rowData.set("inci",inciDr);
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("batNo",record.get("BatExp"));
		rowData.set("manf",record.get("Manf"));
		rowData.set("uom",record.get("PurUomId"));
		rowData.set("uomDesc",record.get("PurUomDesc"));
		rowData.set("sp",record.get("Sp"));
		rowData.set("rp",record.get("Rp"));
		rowData.set("inclb",record.get("Inclb"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("Inclbqty",record.get("InclbQty"));
		rowData.set("AvaQty",record.get("AvaQty"));
		
		rowData.set("qty",record.get("OperQty"));
		rowData.set("spAmt",accMul(record.get('Sp'),record.get("OperQty")));
		rowData.set("rpAmt",accMul(record.get('Rp'),record.get("OperQty")));
		
		var lastIndex = INAdjMGridDs.getCount()-1;
		if(INAdjMGridDs.getAt(lastIndex).get('inclb')!=""){
			addNewRow();
		}else{
			var col=GetColIndex(INAdjMGrid,'desc')
			INAdjMGrid.startEditing(lastIndex,col);
		}
	});
}

//增加新行(明细)
function addNewRow() {
	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "请选择类组!");
		return ;
	}
	var descIndex=GetColIndex(INAdjMGrid,"desc");
	var barcodeIndex = GetColIndex(INAdjMGrid,"HVBarCode");
	var colIndex = gHVInAdj?barcodeIndex:descIndex;
	// 判断是否已经有添加行
	var rowCount = INAdjMGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INAdjMGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			INAdjMGrid.startEditing(INAdjMGridDs.getCount() - 1, colIndex);
			return;
		}
	}
	
	var NewRecord=CreateRecordInstance(INAdjMGridDs.fields);
	INAdjMGridDs.add(NewRecord);
	INAdjMGrid.startEditing(INAdjMGridDs.getCount() - 1, colIndex);
	
	setEditDisable();
}

 //删除库存调整单
function deleteAdj()
{
	if (mainRowId=='')
	{
		Msg.info('warning','没有任何库存调整单!');return false;	
	}
	var complete=Ext.getCmp('finshCK').getValue();
	if (complete==true)
	{
		Msg.info('warning','该单已经完成,禁止删除!');	return false;
	}

	var rowid=mainRowId;
	Ext.MessageBox.confirm('提示','确定要删除该库存调整单?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url : 'dhcstm.inadjaction.csp?actiontype=delete&adj='+rowid,
					waitMsg:'删除中...',
					failure: function(result, request) {
						Msg.info("error", "请检查网络连接!");
						return false;
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success",'删除成功!');
							clearPage();
							//新增^查询^保存^删除^完成^取消完成^清空^打印
	                        changeButtonEnable("1^1^1^0^0^0^1^0")
							return true;
						}else{
							Msg.info("error", "删除失败!"+jsonData.info);
							return false;
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

//清空页面
function clearPage()
{
	mainRowId="";
	
	Ext.getCmp('adjNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('adjUserField').setValue("");	
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('causeField').setValue("");
	Ext.getCmp('causeField').setRawValue("");
	Ext.getCmp('finshCK').setValue("");
	Ext.getCmp('remarkField').setValue("");
	Ext.getCmp('auditCK').setValue("");
	INAdjMGridDs.removeAll();
	saveINAdjM.enable();
	setEditEnable();
}

//设置单据完成
function setComplete()
{
	//alert(mainRowId);
	if (mainRowId=='') {Msg.info('warning','没有任何单据,请先查询!');return; }
	if (Ext.getCmp('finshCK').getValue()==true){
		Msg.info('warning','当前单据已完成!');return;
	}
	Ext.Ajax.request({
		url:INAdjMGridUrl+'?actiontype=setComplete'+"&adj="+mainRowId,
		failure:function(){
			Msg.info('error','请检查网络!');return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.getCmp('finshCK').setValue(true);
				//saveINAdjM.disable();
				//新增^查询^保存^删除^完成^取消完成^清空^打印
	            changeButtonEnable("1^1^0^0^0^1^1^1")
				Msg.info('success','设置成功！');
				
			}else{
				Msg.info("error", "设置失败!"+jsonData.info);
				return false;
			}			
		}
	});
}

//取消完成
function cancelComplete()
{
	if (mainRowId=='') {Msg.info('warning','没有任何单据,请先查询!');return; }
	if (Ext.getCmp('finshCK').getValue()==false){Msg.info('error','该单据尚未完成!');return;}	
	Ext.Ajax.request({
		url:INAdjMGridUrl+'?actiontype='+'cancelComplete'+'&adj='+mainRowId,
		failure:function(){Msg.info('error','请检查网络!');return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.getCmp('finshCK').setValue(false);
				Msg.info('success','设置成功！');
				//saveINAdjM.enable();
				//新增^查询^保存^删除^完成^取消完成^清空^打印
	             changeButtonEnable("1^1^1^1^1^0^1^1")
			}else{
				Msg.info("error", "设置失败!"+jsonData.info);
				return;
			}		
		}
	});
}

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:gHVInAdj?'库存调整制单(高值)':'库存调整制单',
		activeTab:0,
		layout:'fit',
		region:'north',
		height:200,
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel,INAdjMGrid],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INAdjMGrid,"DHCSTSTOCKADJM");   //根据自定义列设置重新配置列
	
});
//===========模块主页面=============================================

 //设置可编辑组件的disabled属性
function setEditDisable()
{
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('locField').setDisabled(true);
}
 //放开可编辑组件的disabled属性
function setEditEnable()
{
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('locField').setDisabled(false);
}

//查看请求单数据是否有修改
function isDataChanged()
{
	var changed=false;
	var count1= INAdjMGrid.getStore().getCount();
	//看主表数据是否有修改
	//修改为主表有修改且子表有数据时进行提示
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	};
	if (changed) return changed;
	//看明细数据是否有修改
	var count= INAdjMGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INAdjMGrid.getStore().getAt(index);	
				//新增或数据发生变化时执行下述操作
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}
// 变更按钮是否可用
function changeButtonEnable(str) {
	var list = str.split("^");
	for (var i = 0; i < list.length; i++) {
		if (list[i] == "1") {
			list[i] = false;
		} else {
			list[i] = true;
		}
	}
	//新增^查询^保存^删除^完成^取消完成^清空^打印
	addINAdjM.setDisabled(list[0]);
	findINAdjM.setDisabled(list[1]);
	saveINAdjM.setDisabled(list[2]);
	deleteINAdjM.setDisabled(list[3]);
	adjComplete.setDisabled(list[4]);
	cancelAdjComplete.setDisabled(list[5]);
	clearINAdjM.setDisabled(list[6]);
	printInadj.setDisabled(list[7]);
}
//新增^查询^保存^删除^完成^取消完成^清空^打印
	changeButtonEnable("1^1^1^0^0^0^1^0")