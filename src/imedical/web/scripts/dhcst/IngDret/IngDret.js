// /名称: 退货单制单
// /描述: 退货单制单
// /编写者：zhangdongmei
// /编写日期: 2012.10.31
var colArr=[];
var IncId="";
var URL = 'dhcst.ingdretaction.csp';
var vendorId="";
var vendorName = "";
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var PurPlanParam = PHA_COM.ParamProp("DHCSTPURPLANAUDIT")
var ReturnParam  = PHA_COM.ParamProp("DHCSTRETURN")

//var arr = window.status.split(":");
//var length = arr.length;
var gIngrt= "";   //退货主表id
var Msg_LostModified=$g('数据已录入或修改，你当前的操作将丢失这些结果，是否继续?');
 
var buomRp="";   //基本单位进价
var buomSp=""; //基本单位售价
var puomRp="" ; //入库单位进价
var puomSp="" ; //入库单位售价
if(gParam.length<1){
    GetParam();  //初始化参数配置
}
if(gParamCommon.length<1){
	GetParamCommon();  //初始化公共参数配置 wyx 公共变量取类组设置gParamCommon[9]

}
var dateField = new Ext.form.DateField({
	id:'dateField',
	listWidth:150,
    allowBlank:false,
	fieldLabel:$g('日期'),
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var dretField = new Ext.form.TextField({
	id:'dret',
	fieldLabel:$g('退货单号'),
	allowBlank:true,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('退货科室'),
	emptyText:$g('退货科室...'),
	anchor:'90%',
	groupId:groupId,
	listeners : {
		'select' : function(e) {
                      var SelLocId=Ext.getCmp('locField').getValue();//add wyx 根据选择的科室动态加载类组
                      groupField.getStore().removeAll();
                      groupField.getStore().setBaseParam("locId",SelLocId)
                      groupField.getStore().setBaseParam("userId",UserId)
                      groupField.getStore().setBaseParam("type",App_StkTypeCode)
                      groupField.getStore().load();
		}
	}
});
	
var groupField=new Ext.ux.StkGrpComboBox({ 
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:locId,
	UserId:userId,
	anchor:'90%'
	
}); 
//=========统计添加=======		
		// 当页条数
		var NumAmount = new Ext.form.TextField({
					emptyText : $g('当页条数'),
					id : 'NumAmount',
					name : 'NumAmount',
					anchor : '90%',
					width:200
				});	
		// 进价合计
		var RpAmount = new Ext.form.TextField({
					emptyText : $g('进价合计'),
					id : 'RpAmount',
					name : 'RpAmount',
					width:200,
					anchor : '90%'
				});			
		// 售价合计
		var SpAmount = new Ext.form.TextField({
					emptyText : $g('售价合计'),
					id : 'SpAmount',
					name : 'SpAmount',
					anchor : '90%',
					width:200
				});
		//zhangxiao20130815			
		function GetAmount(){
			var RpAmt=0
			var SpAmt=0
			var Count = IngDretDetailGrid.getStore().getCount();
			for (var i = 0; i < Count; i++) {
				var rowData = IngDretDetailGridDs.getAt(i);
				var RecQty = rowData.get("qty");
				var Rp = rowData.get("rp");
				var Sp = rowData.get("sp");
				var RpAmt1=Rp*RecQty;
				var SpAmt1=Sp*RecQty;
			    RpAmt=RpAmt+RpAmt1;
			    SpAmt=SpAmt+SpAmt1;
				}
			Count=$g("当前条数:")+" "+Count	
			RpAmt=$g("进价合计:")+" "+ FormatGridRpAmount(RpAmt)+" "+$g("元")
			SpAmt=$g("售价合计:")+" "+ FormatGridSpAmount(SpAmt)+" "+$g("元")
			Ext.getCmp("NumAmount").setValue(Count)	
			Ext.getCmp("RpAmount").setValue(RpAmt)	
			Ext.getCmp("SpAmount").setValue(SpAmt)
			}		
//=========统计添加=======
var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('经营企业'),
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%',
	width : 140
});

var pNameField = new Ext.form.TextField({
	id:'pName',
	fieldLabel:$g('名称'),
	allowBlank:true,
	width:180,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//调出药品窗口
				var group = Ext.getCmp("groupField").getValue();
				//GetPhaOrderInfo(field.getValue(),group);
			
				var inputVen=field.getValue();
				var Locdr=Ext.getCmp('locField').getValue();
				var NotUseFlag='N';
				var QtyFlag='N';
				var ReqLoc='';
				var Vendor=Ext.getCmp('Vendor').getValue();
				var VendorName=Ext.getCmp('Vendor').getRawValue();
				VendorItmBatWindow(inputVen, group, App_StkTypeCode, Locdr,Vendor,VendorName, NotUseFlag,	QtyFlag, HospId, ReqLoc,handleSelectedIngri);
			}
		}	
	}
});

var transOrder = new Ext.form.Checkbox({
	id: 'transOrder',
	boxLabel:$g('调价换票'),
	anchor:'90%',
	allowBlank:true
});

//"完成"标志
var complete = new Ext.form.Checkbox({
	id: 'complete',
	boxLabel:$g('完成'),
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%',
	listeners:{
		'check':function(chk,v){
			var grid=Ext.getCmp('IngDretDetailGrid');
			setGridEditable(grid,!v)
		}
	}
});

//"审核"标志
var auditChk = new Ext.form.Checkbox({
	id: 'audited',
	boxLabel:$g('审核'),
	disabled:true,
	allowBlank:true,
	disabled:true,
	anchor:'90%'
});

var noViewZeroItem = new Ext.form.Checkbox({
	id: 'noViewZeroItem',
	fieldLabel:$g('不显示库存为零的项'),
	allowBlank:true,
	checked:true
});

var noViewZeroVendor = new Ext.form.Checkbox({
	id: 'noViewZeroVendor',
	fieldLabel:$g('不显示库存为零的经营企业'),
	allowBlank:true
});
//=========================退货管理=================================

ReasonForReturnStore.load();
var newBT = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建退货单'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		//addDetailRow();
		NewRet()
	}
});


var clearBT = new Ext.Toolbar.Button({
	text:$g('清屏'),
    tooltip:$g('清屏'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler : function() {
		var compFlag=Ext.getCmp('complete').getValue();
		var mod=Modified();
		if  ( mod&&(!compFlag) ) {
			Ext.Msg.show({
			   title:$g('提示'),
			   msg: Msg_LostModified,
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
			   		if (b=='yes'){clearData() ;}			   		
			   	},
	 		   //animEl: 'elId',
			   icon: Ext.MessageBox.QUESTION
			});
		}
		else
		{	clearData() ;}
	}
	
	
});
function clearData(){
	Ext.getCmp("dateField").setValue(new Date());
	Ext.getCmp("dret").setValue("");
	Ext.getCmp("complete").setValue(false);
	groupField.setDisabled(false);
	locField.setDisabled(false);
	Ext.getCmp("Vendor").setDisabled(false);
	Ext.getCmp("Vendor").setValue("")
	IngDretDetailGridDs.removeAll();
	IngDretDetailGrid.getView().refresh();
	gIngrt='';
	saveIngDret.setDisabled(false);
    completeBT.setDisabled(false);
	Ext.getCmp("transOrder").setValue(false);		
	Ext.getCmp("audited").setValue(false);
	setOriginalValue('MainForm');
}



var AddDetailBT=new Ext.Button({
	text:$g('增加一条'),
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{
		groupField.setDisabled(true);
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:$g('删除一条'),
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
		if (IngDretDetailGridDs.getCount()==0)
		{
			groupField.setDisabled(false);
			Ext.getCmp("Vendor").setDisabled(false);
		
		}

	}
});

var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('列设置'),
    tooltip:$g('列设置'),
    iconCls:'page_gear',
//	width : 70,
//	height : 30,
	handler:function(){
		GridColSet(IngDretDetailGrid,"DHCSTRETURN");
	}
});

var findIngDret = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		findIngDret();

	}
});

var completeBT = new Ext.Toolbar.Button({
	text:$g('完成'),
    tooltip:$g('完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var compFlag=Ext.getCmp('complete').getValue();
		var mod=Modified();
		if (mod&&(!compFlag)) {
			Ext.Msg.confirm($g('提示'),$g('数据已发生改变,是否需要保存后完成?'),
			    function(btn){
				  if(btn=='yes'){
				     return;						
				  }else{
				     Complete();	
				  }
			 },this);
		 } else{
			Complete();
		}	
	}
});

var cancelCompleteBT = new Ext.Toolbar.Button({
	text:$g('取消完成'),
    tooltip:$g('取消完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		cancelComplete();
	}
});

// 打印退货单
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : $g('打印'),
	tooltip : $g('打印退货单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintIngDret(gIngrt);
	}
});
// 依据入库单退货
var findIngBT = new Ext.Toolbar.Button({
	id : "findIngBT",
	text : $g('依据入库单退货'),
	tooltip : $g('依据入库单退货'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		///有明细时不允许,功能类似依据请求出库
		if (IngDretDetailGridDs.getCount()>0)
		{
			Msg.info("warning",$g("已存在退货明细!"));
			return;
			
		}
		FindIngInfo();
	}
});

var saveIngDret = new Ext.Toolbar.Button({
	id:"saveIngDret",
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	disabled:true,
	height : 30,
	handler:function(){
		var rowCount =IngDretDetailGridDs.getCount();
		if(rowCount==0) 
		{
			Msg.info('warning',$g('明细数据为空，请核对明细!'))
			return;
		} 
		//1.保存主表信息
		var retNo = Ext.getCmp('dret').getValue();
		var scg = Ext.getCmp('groupField').getValue();
		if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
			Msg.info("error",$g("请选择类组!"));
			return false;
		}
		var vendorId=Ext.getCmp("Vendor").getValue();
		if((vendorId=="")||(vendorId==null)){
			Msg.info("error",$g("请选择经营企业!"));
			return false;
		}
		var locId=Ext.getCmp("locField").getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("请选择科室!"));
			return false;
		}
		var stkType = "";
		var adjChequeFlag = (Ext.getCmp('transOrder').getValue()==true?'Y':'N');
		var rlocid=Ext.getCmp('locField').getValue(); //取退货科室id不能取登录科室
		var mainInfo=rlocid+"^"+vendorId+"^"+userId+"^"+scg+"^"+adjChequeFlag;
		if (locId=='') {Msg.info('error',$g('请选择退货科室!') );}
		if (vendorId=='') {Msg.info('error',$g('请选择退货经营企业!')) ;}
		if (userId=='') {Msg.info('error',$g('请选择退货人!')) ;}
		if ((scg=='')&&(gParamCommon[9]=="N")) {Msg.info('error',$g('请选择类组!')) ;}
		
		if(IngDretDetailGrid.activeEditor != null){
			IngDretDetailGrid.activeEditor.completeEdit();
		}
		var rows = "";
		var count = IngDretDetailGridDs.getCount();	
		if(!count>0){Msg.info('error',$g('没有需要保存的数据!')) ;return}
		for(var index=0;index<count;index++){
			var row = IngDretDetailGridDs.getAt(index);
			//新增或数据发生变化时执行下述操作
			if(row.data.newRecord || row.dirty || row.get('ingrti')==""){	
				var ingrti = row.get('ingrti'); 	//退货子表rowid(DHC_INGRtItm)
				var ingri = row.get('ingri'); 		//入库子表rowid(DHC_INGdRecItm)
				var inclbrowid=row.get('inclb');
				if((inclbrowid=="")||(inclbrowid==null)){continue;}
				var qty = row.get('qty'); 			//数量
				if(qty==null || qty==""||qty<=0){
					Msg.info("warning",$g("第")+(index+1)+$g("行退货数量为空或者小于0!"));
					var newcolIndex = GetColIndex(IngDretDetailGrid, 'qty');
                	IngDretDetailGrid.startEditing(index, newcolIndex);
					return;
				}
				var uomId = row.get('uom'); 		//单位
				var rp = row.get('rp'); 			//进价
				var rpAmt = row.get('rpAmt'); 		//进价金额
				var sp = row.get('sp'); 			//售价
				var spAmt = row.get('spAmt'); //售价金额
				var oldSp = row.get('oldSp'); //批次售价
				var oldSpAmt = row.get('oldSpAmt'); //批次售价金额
				var invNo = row.get('invNo'); //发票号
				var invDate = row.get('invDate'); //发票日期
				if((invDate!="")&&(invDate!=null)){
					invDate = invDate.format(App_StkDateFormat);
				}else{
					invDate="";
				}
				if (((invNo=="")&&(invDate!=""))||((invNo!="")&&(invDate=="")))
                {
	                Msg.info("warning", $g("第")+(index+1)+$g("行,发票号和发票日期需同时填入！"));
                    return;
                }
				var invAmt = row.get('invAmt'); //发票金额
				var sxNo = row.get('sxNo'); //随行单号
				if(sxNo==null){
					sxNo = "";
				}
				var reason = row.get('reasonId'); //退货原因
				if(reason==null || reason==""){
					Msg.info("warning",$g("第")+(index+1)+$g("行退货原因为空!"));
					var newcolIndex = GetColIndex(IngDretDetailGrid, 'reasonId');
                	IngDretDetailGrid.startEditing(index, newcolIndex);
					return;
				}
				var aspa = row.get('aspAmt'); //退货调价金额
				if(ingri==null || ingri==""){
				  continue;
				}
				//
				//退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因
				var data =  ingrti+"^"+ingri+"^"+qty+"^"+uomId+"^"+rp+"^"+sp+"^"+invNo+"^"+invDate+"^"+invAmt+"^"+sxNo+"^"+reason;
				if(rows!=""){
					rows = rows+xRowDelim()+data;
				}else{
					rows = data;
				}
			}
		}
		//if(rows==""){Msg.info('error','没有需要保存的数据!') ;return}
		//检查预算数据
		var ret = CheckSaveBudget(gIngrt,rows)
 		if(!ret) return;

		
		var loadMask=ShowLoadMask(Ext.getBody(),$g("处理中..."));
		Ext.Ajax.request({
			url: URL+'?actiontype=save',
			params:{ret:gIngrt,MainData:mainInfo,Detail:rows},
			failure: function(result, request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success",$g("保存成功!"));
					//alert(jsonData.info);
					gIngrt =  jsonData.info; //退货单主表Id
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
					SendBusiData(gIngrt,"RETURN","SAVE");
				}else{
					var ret=jsonData.info;
					if(ret=='-10'){
						Msg.info("warning",$g("可用库存不足于退货!"));
					}else if(ret=='-3'){
						Msg.info("warning",$g("生成退货单号失败!"));
					}else if(ret=='-4'){
						Msg.info("warning",$g("保存退货单失败!"));
					}else if(ret=='-6'){
						Msg.info("warning",$g("保存退货明细失败!"));
					}else if(ret=='-8'){
						Msg.info("warning",$g("退货单已完成!"));
					}else if(ret=='-9'){
						Msg.info("warning",$g("退货单已审核!"));
					}else{
						Msg.info("error",$g("保存失败:")+ret);
					}
					
				}
				
				loadMask.hide();
			},
			scope: this
		});

    }
});


function CheckSaveBudget(gIngrt,data){
	if (_BudgetSaveFlag != "LIMIT" && _BudgetSaveFlag != "WARN") return true;
	var locId = Ext.getCmp('locField').getValue();
	var locDesc = Ext.getCmp('locField').getRawValue();
	var budgetId = Ext.getCmp('BudgetProComb').getRawValue();
	if(!budgetId) {
		Msg.info("warning","保存数据需核对HRP预算系统，请选择一个预算项目!");
		return false;
	}
	var MianObj={
		project_id : "", //项目id
		project_desc: "", //项目名称
		loc_id : locId, //科室id
		loc_desc : locDesc, //科室名称
		business : "RETURN", //业务类型
		businode : "SAVE", //业务节点
		main_id : "gIngrt", //业务主表id
		main_no : "", //业务单号
		operate : "INSERT", //操作类型
		Detail : data //明细数据
	}
	var BusiData = JSON.stringify(MianObj)
	var ret = tkMakeServerCall("PHA.IN.Budget.Client.Interface","SendBusiData",BusiData)
	var RetJson = JSON.parse(ret);
	if(RetJson.code < 0 )
	{
		Msg.info("error",RetJson.msg);
		return false;
	}
	else if(RetJson.code == 1)
	{
		Msg.info("warning",RetJson.msg);
	}
	return true;
}


var deleteIngDret = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(gIngrt==null || gIngrt==""){
			Msg.info("error",$g("没有要删除的退货单!"));
			return false;
		}else{			
			if (Ext.getCmp('complete').getValue()==true)
			{
				Msg.info("warning",$g("已经完成,禁止删除!"));
				return;
			}

			Ext.MessageBox.confirm($g('提示'),$g('确定要删除该退货单?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=delete&Ingrt='+gIngrt,
							waitMsg:$g('删除中...'),
							failure: function(result, request) {
								Msg.info("error",$g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("删除成功!"));
									Clear();
								}else if(jsonData.info==-99){
									Msg.info("error",$g("退货单不为未完成状态,不能删除!"));
								}else{
									Msg.info("error",$g("删除失败!"));
								}
							},
							scope: this
						});
					}
				}
			)			
		}
    }
});

////删除一条明细记录
function DeleteDetail(){	

	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true))
	{
		Msg.info('warning',$g('当前退货单已完成,禁止删除明细记录!'));
		return;
	}	
	
	
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	if (!cell) {
		Msg.info("warning",$g('请选择明细记录!'));
		return;
	}
	
	var rowindex=cell[0];
	if(rowindex==null){
		
		Msg.info("error",$g("请选择数据!"));
		return false;
	}else{
		var record = IngDretDetailGrid.getStore().getAt(rowindex);
		var RowId = record.get("ingrti");
		if(RowId!=""){
			Ext.MessageBox.confirm($g('提示'),$g('确定要删除选定的行?'),
				function(btn) {
					if(btn == 'yes'){
						
						Ext.Ajax.request({
							
							url:URL+'?actiontype=deleteDetail&rowid='+RowId,
							waitMsg:$g('删除中...'),
							failure: function(result, request) {
								Msg.info("error",$g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("删除成功!"));
									IngDretDetailGridDs.load({params:{start:0,limit:20,sort:'ingrti',dir:'desc',ret:gIngrt}});
								        GetAmount();
								}else{
									Msg.info("error",$g("删除失败!"));
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			IngDretDetailGrid.getStore().remove(record);
			IngDretDetailGrid.getView().refresh();
			GetAmount();
		}
	}

}


//=========================退货管理=================================
var Cause2 = new Ext.form.ComboBox({
	fieldLabel : $g('退货原因'),
	id : 'Cause2',
	name : 'Cause2',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : $g('退货原因...'),
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
				var row = IngDretDetailGridDs.getAt(cell[0]);				
				var colIndex=GetColIndex(IngDretDetailGrid,'Cause2');
				IngDretDetailGrid.stopEditing(cell[0], colIndex); //弹出前先置完成编辑 LiangQiang 2013-11-22
				if(setEnterSort(IngDretDetailGrid,colArr)){
						addDetailRow();
					}

			}
		}
	}
});		



//配置数据源
var IngDretDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'GET'});
var IngDretDetailGridDs = new Ext.data.Store({
	proxy:IngDretDetailGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'ingrti'},
		{name:'ingri'},
		{name:'manf'},
		{name:'inclb'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:App_StkDateFormat},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'reasonId'},
		{name:'retReason'},
		{name:'stkqty'},
		{name:'buom'},
		{name:'confac'},
		{name:'InsuCode'},
		{name:'InsuDesc'}
		
	]),
    remoteSort:false
});

// 单位
var CTUom = new Ext.form.ComboBox({
	//fieldLabel : '单位',
	id : 'CTUom',
	name : 'CTUom',
	anchor : '90%',
	width : 120,
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText :$g( '单位...'),
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250	,
	valueNotFoundText : ''
});
		
ItmUomStore.on('beforeload',function(store){
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	
	var InciDr=inclb.split("||")[0];
	if (InciDr=='') return false;
	else
	{
		ItmUomStore.baseParams={ItmRowid:InciDr};
	}
	
});
/**
 * 单位展开事件
 */

CTUom.on('expand', function(combo) {

	combo.store.removeAll();
	combo.store.load();	

});


/**
 * 单位变换事件
 */
CTUom.on('select', function(combo) {
	var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var record = IngDretDetailGrid.getStore().getAt(cell[0]);	
	var value = combo.getValue();        //目前选择的单位id
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //大单位到小单位的转换关系		
	var Uom = record.get("uom");    //目前显示的退货单位
	var BatStkQty=record.get("stkqty");
	var NewStkQty=BatStkQty;
	if(value!=Uom){
		if(value==BUom){
			NewStkQty=Number(BatStkQty).mul(ConFac);
		}else{
			NewStkQty=Number(BatStkQty).div(ConFac);
		}
		record.set("stkqty",NewStkQty)
	}
	//alert(value+"$"+BUom+"$"+Uom+"$"+NewStkQty+"^"+ConFac)
	var ingri=record.get("ingri");
	record.set("uom", combo.getValue());	
	var Uom=record.get("uom"); 
	SetIngriPrice(record,ingri,Uom);
	
});
var RpEditor=new Ext.form.NumberField({
	selectOnFocus : true,
	allowBlank : false,
	decimalPrecision:3,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {

				var cost = field.getValue();
		
				if (cost == null
						|| cost.length <= 0) {
					Msg.info("warning", $g("进价不能为空!"));
					return;
				}
				if (cost <= 0) {
					Msg.info("warning",$g("进价不能小于或等于0!"));
					return;
				}
			var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();	
			var colIndex=GetColIndex(IngDretDetailGrid,'rp');
			IngDretDetailGrid.stopEditing(cell[0], colIndex); //弹出前先置完成编辑 LiangQiang 2013-11-22				
			if(setEnterSort(IngDretDetailGrid,colArr)){
					addDetailRow();
				}	
			}
		}
	}
})
var SpEditor=new Ext.form.NumberField({
	selectOnFocus : true,
	allowBlank : false,
	decimalPrecision:3,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
//		blur:function(field){
				var cost = field.getValue();
		
				if (cost == null
						|| cost.length <= 0) {
					Msg.info("warning", $g("售价不能为空!"));
					return;
				}
				if (cost <= 0) {
					Msg.info("warning",$g("售价不能小于或等于0!"));
					return;
				}
				
			var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
			var colIndex=GetColIndex(IngDretDetailGrid,'Sp');
			IngDretDetailGrid.stopEditing(cell[0], colIndex); //弹出前先置完成编辑 LiangQiang 2013-11-22
			if(setEnterSort(IngDretDetailGrid,colArr)){
						addDetailRow();
					}

			}
		}
	}
})				
				
//模型
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:$g("退货子表rowid"),
        dataIndex:'ingrti',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("入库子表rowid"),
        dataIndex:'ingri',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("批次DR"),
        dataIndex:'inclb',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("代码"),
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'desc',
        id:'desc',
        width:200,
        align:'left',
        sortable:true,
        editor:pNameField
    },{
        header:$g("生产企业"),
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("规格"),
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("批次库存"),
        dataIndex:'stkqty',
        width:100,
        align:'left',
        sortable:true    	
    },{
        header:$g("退货数量"),
        dataIndex:'qty',
        width:100,
        id:'qty',
        align:'right',
        sortable:true,
        editor:new Ext.ux.NumberField({
			id:'dretQtyField',
			formatType:'FmtSQ',
            allowBlank:true,
			allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var row = IngDretDetailGridDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
						var count = field.getValue();
						if(count>row.get("stkqty")){
							field.setValue("");
							Msg.info("error",$g("退货数量不能大于库存数量!"));
						}else{
							if(setEnterSort(IngDretDetailGrid,colArr)){
									addDetailRow();
								}
							GetAmount();
						}
					}
				}
			}
        })
    },{
        header:$g("退货单位"),
        dataIndex:'uom',
        id:'uom',
        width:100,       
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
		editor : new Ext.grid.GridEditor(CTUom),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(IngDretDetailGrid,"uom");
					IngDretDetailGrid.startEditing(cell[0], colIndex);
					GetAmount();										
				}
			}
		}
    },{
        header:$g("退货原因"),
        dataIndex:'reasonId',
        width:100,
        id:'reasonId',
        align:'left',
        sortable:true,
		editor:new Ext.grid.GridEditor(Cause2),
		renderer:Ext.util.Format.comboRenderer(Cause2)
    },{
        header:$g("退货进价"),
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true,
        editor : RpEditor

        
    },{
        header:$g("退货进价金额"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("售价"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true,
        editor : SpEditor
    },{
        header:$g("退货售价金额"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:$g("批号"),
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("效期"),
        dataIndex:'expDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("发票号"),
        dataIndex:'invNo',
        id:'invNo',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'invNoField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}

					}
				}
			}
        })
    },{
        header:$g("发票日期"),
        dataIndex:'invDate',
        id:'invDate',
        width:100,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
		editor: new Ext.ux.DateField({
			id:'invDateField2',
            allowBlank:true,
			format:App_StkDateFormat,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
						var row = IngDretDetailGridDs.getAt(cell[0]);	
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}
	
					}
				}
			}
        })
    },{
        header:$g("退发票金额"),
        dataIndex:'invAmt',
        id:'invAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount,
		editor: new Ext.ux.NumberField({
			id:'invAmtField2',
			formatType:'FmtSA',
            allowBlank:true,			
            listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}
	
					}
				}
			}
        })
    },{
        header:$g("随行单号"),
        dataIndex:'sxNo',
        id:'sxNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
            allowBlank:true,
            listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(IngDretDetailGrid,colArr)){
								addDetailRow();
							}
	
					}
				}
			}
        })
    }
    ,{
        header:$g("国家医保编码"),
        dataIndex:'InsuCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("国家医保名称"),
        dataIndex:'InsuDesc',
        width:100,
        align:'left',
        sortable:true
    }
]);

//初始化默认排序功能
IngDretDetailGridCm.defaultSortable = true;

//表格
var IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	id:'IngDretDetailGrid',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	height:450,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({
		listeners:{
			'beforecellselect':function(sm,row,col){
				var ind=IngDretDetailGridCm.getIndexById('uom');
				if ( col==ind){

				}
			}
		}
	}),
	loadMask:true,
    //tbar:['物品名称',pNameField,'-',findVendor,'-',addList,'-','不显示库存为零的项',noViewZeroItem,'-','不显示库存为零的经营企业',noViewZeroVendor],
	clicksToEdit:1
});

IngDretDetailGrid.on('afteredit',function(e){
	if(e.field=='qty'){
		if(e.record.get("qty")>e.record.get("stkqty")){
			Msg.info("error",$g("退货数量不能大于库存数量!"));
			e.record.set("qty","");
		}else{
			e.record.set("rpAmt", accMul(e.value,e.record.get("rp"))); 
			e.record.set("spAmt", accMul(e.value,e.record.get("sp")));
			e.record.set("invAmt",accMul(e.value,e.record.get("rp")))
		}
	}
	if(e.field=='rp'){
		if(e.record.get("qty")>0){
			e.record.set("rpAmt", accMul(e.record.get("qty"),e.record.get("rp"))); 
			e.record.set("invAmt",accMul(e.record.get("qty"),e.record.get("rp")))
		}
	}
	if(e.field=='sp'){
		if(e.record.get("qty")>0){
		
			e.record.set("spAmt", accMul(e.record.get("qty"),e.record.get("sp")));
		}
	}
});

IngDretDetailGrid.addListener("rowcontextmenu",rightClickFn);
IngDretDetailGrid.on('beforeedit',function(e){
       	
       	
       	if(e.field=="sp"){
			 if (gParam[4]!='Y'){	
                          e.cancel=true;
                          }
			}
		if(e.field=="rp"){
			 if (gParam[3]!='Y'){	
                          e.cancel=true;
                          }
			}
		});
IngDretDetailGrid.addListener("rowcontextmenu",rightClickFn);
        IngDretDetailGrid.getView().on('refresh',function(Grid){
			GetAmount()
			})
var rightMenu=new Ext.menu.Menu({
	id:"rightClickMenu",
	items:[{
		id:"mnuDelete",
		text:$g("删除"),
		handler:DeleteDetail
	}]
});

function rightClickFn(grid,rowindex,e){
	grid.getSelectionModel().select(rowindex,0);
	e.preventDefault();
	rightMenu.showAt(e.getXY());
}

var formPanel = new Ext.form.FormPanel({
	id:'MainForm',
	labelWidth : 60,
	labelAlign : 'right',
	frame:true,
	autoHeight:true,
	//bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar : [findIngDret,'-',clearBT,'-',newBT,'-',saveIngDret,'-',completeBT,'-',cancelCompleteBT,'-',findIngBT,'-',printBT,'-',deleteIngDret],
	items:[{
		xtype:'fieldset',
		title:$g('退货单信息'),
		style:DHCSTFormStyle.FrmPaddingV,
		layout: 'column',    // Specifies that the items will now be arranged in columns
		items : [{ 				
			columnWidth: 0.25,
			xtype : 'fieldset',
			border:false,
        	items: [locField,groupField]
			
		},{ 				
			columnWidth: 0.25,
			xtype : 'fieldset',
			border:false,
	       	items: [Vendor,dretField]			
		},{ 				
			columnWidth: 0.20,
			xtype : 'fieldset',
			border:false,
        	items: [dateField,BudgetProComb]
			
		},{ 				
			columnWidth: 0.1,
			xtype : 'fieldset',
			border:false,
			labelWidth:10,
      		items: [complete,transOrder]			
		},{
			columnWidth: 0.15,
			xtype : 'fieldset',
			border:false,
			labelWidth:10,
			items:[auditChk]
		}
		]				
	}]
});

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.Viewport({
		layout:'border',	
		items:[{
	                region: 'north',
	                split: true,
        			height: DHCSTFormStyle.FrmHeight(2),
	                title: $g('退货制单'),
	                layout:'fit',
	                items: formPanel               
	            },{             
	                region: 'center',		                
                	title:$g('明细记录'),
                	split:false,
                	//height:250,
                	//minSize:100,
                	//maxSize:200,
                	//collapsible:true,
                	layout:'fit',
                	items:IngDretDetailGrid,
                	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
                	bbar:new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]})
	            }],
		renderTo:'mainPanel'
	});
	
	RefreshGridColSet(IngDretDetailGrid,"DHCSTRETURN");   //根据自定义列设置重新配置列
	colArr=sortColoumByEnterSort(IngDretDetailGrid); //将回车的调整顺序初始化好
	SetBudgetPro(Ext.getCmp("locField").getValue(),"RETURN",[1,2],"saveIngDret") //加载HRP预算项目
});
//===========模块主页面=================================================





function addDetailRow() {
	if ((gIngrt!="")&&(Ext.getCmp('complete').getValue()==true))
	{
		Msg.info('warning',$g('当前退货单已完成,禁止增加明细记录!'));
		return;
	}	
	locField.setDisabled(true);
	// 判断是否已经有添加行
	var rowCount = IngDretDetailGrid.getStore().getCount();
	var invNo="";
	var invDate="";
	var retReason="";
	var sxNo=""
	if (rowCount > 0) {
		var rowData = IngDretDetailGridDs.data.items[rowCount - 1];
		var data = rowData.get("inclb");
		if (data == null || data.length <= 0) {
			var col=GetColIndex(IngDretDetailGrid,"desc");
			IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, col);
			return;
		}
			var invNo=rowData.get("invNo");
		    var invDate=rowData.get("invDate");
		    var reasonId=rowData.get("reasonId");
		    var retReason=rowData.get("retReason");	
		    sxNo=rowData.get("sxNo");	
	}
	var rec = Ext.data.Record.create([
		{name : 'ingrti',type : 'string'}, 
		{name : 'ingri',type : 'string'}, 
		{name : 'manf',type : 'string'}, 
		{name : 'inclb',type : 'string'}, 
		{name : 'uom',type : 'string'}, 
		{name : 'uomDesc',type : 'string'}, 
		{name : 'qty',type : 'int'}, 
		{name : 'rp',type : 'double'}, 
		{name : 'rpAmt',type : 'double'},
		{name : 'sp',type : 'double'},
		{name : 'spAmt',type : 'double'},
		{name : 'invNo',type : 'string'},
		{name : 'invDate',type : 'string'},
		{name : 'invAmt',type : 'double'},
		{name : 'sxNo',type : 'string'},
		{name : 'oldSp',type : 'double'},
		{name : 'oldSpAmt',type : 'double'},
		{name : 'code',type : 'string'},
		{name : 'desc',type : 'string'},
		{name : 'spec',type : 'string'},
		{name : 'batNo',type : 'string'},
		{name : 'expDate',type : 'string'},
		{name : 'reasonId',type : 'int'},
		{name : 'retReason',type : 'string'},
		{name : 'stkqty',type : 'double'},
		{name:'buom',type:'string'},
		{name:'confac',type:'string'},
		{name:'InsuCode',type:'string'},
		{name:'InsuDesc',type:'string'}
		
	]);
	var NewRec = new rec({
		ingrti:'',
		ingri:'',
		manf:'',
		inclb:'',
		uom:'',
		uomDesc:'',
		qty:'',
		rp:'',
		rpAmt:'',
		sp:'',
		spAmt:'',
		invNo:invNo,
		invDate:invDate,
		invAmt:'',
		sxNo:sxNo,
		oldSp:'',
		oldSpAmt:'',
		code:'',
		desc:'',
		spec:'',
		batNo:'',
		expDate:'',
		reasonId:reasonId,
		retReason:retReason,
		stkqty:'',
		buom:'',
		confac:'',
		InsuCode:'',
		InsuDesc:''
	});
					
	IngDretDetailGridDs.add(NewRec);
	var colIndex=GetColIndex(IngDretDetailGrid,"desc");
	IngDretDetailGrid.getSelectionModel().select(IngDretDetailGridDs.getCount() - 1, colIndex);
	IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, colIndex);
        GetAmount();
}

//加入退货列表
function AddList(row){
	if(row==null || row==""){
		return;
	}		
	var colIndex=GetColIndex(IngDretDetailGrid,"qty");
	var coldescIndex=GetColIndex(IngDretDetailGrid,"desc");
	//var row = IngDretGridDs.getAt(j);
	var INGRI = row.get('INGRI');
	var INCLB = row.get('INCLB');
	var code = row.get('code');
	var desc = row.get('desc');
	var mnf = row.get('mnf');
	var batch = row.get('batch');
	var sven = row.get('sven');
	var venid=row.get('venid');
	var pp = row.get('pp');
	var expdate = row.get('expdate');
	var uom = row.get('uom');
	var uomDesc = row.get('uomDesc');
	var idate = row.get('idate');
	var invDate = row.get('invDate');
	var recqty = row.get('recqty');
	var stkqty = row.get('stkqty');
	var rp = row.get('rp');
	var sp = row.get('sp');
	var sp = row.get('sp');
	if(ReturnParam.ChoiceRp == 2 ) var rp = row.get('CurRp');
	if(ReturnParam.ChoiceSp == 2 ) var sp = row.get('CurSp');
	//var rpAmt = row.get('rpAmt');
	//var spAmt = row.get('spAmt');
	//var invAmt = row.get('invAmt');
	var invNo = row.get('invNo');
	//var qty = row.get('dretQty');
	var sxNo = row.get('sxNo');
	//var dretAmt = row.get('dretAmt');
	var cause = row.get('causeName');
	var causeId = row.get('causeId');
	var Drugform = row.get('Drugform');
	var spec = row.get('Spec');
	var buom=row.get('buom');
	var confac=row.get('confac');
	var InsuCode = row.get('InsuCode');
	var InsuDesc = row.get('InsuDesc');
	puomRp=rp;
	puomSp=sp;
	buomRp=puomRp/confac;
	buomSp=puomSp/confac;
	var cell=IngDretDetailGrid.getSelectionModel().getSelectedCell();
	var rowIndex=cell[0];
	if(stkqty<=0){
		Msg.info("warning",$g("该项目库存为零，不能退货!"));
		IngDretDetailGrid.startEditing(rowIndex,coldescIndex);
		return;
	}		
	var selectVenid=Ext.getCmp("Vendor").getValue();
	if(selectVenid!=null & selectVenid!=""){
		if(selectVenid!=venid){    
			Msg.info("warning",$g("该项目经营企业不等于已选择项目的经营企业，不能在同一张退货单上退货"));
			IngDretDetailGrid.startEditing(rowIndex,coldescIndex);
			return;
		}
	}else{
		addComboData(Vendor.getStore(),venid,sven);
		Ext.getCmp("Vendor").setValue(venid);
	}	
	var count=IngDretDetailGridDs.getCount();
	for(var j=0;j<count;j++){
		var tmpData=IngDretDetailGridDs.getAt(j);
		var tmpInclb=tmpData.get("inclb");
		if((tmpInclb==INCLB)&(j!=rowIndex)){
			Msg.info("warning",$g("该批次已经存在于退货列表！"))
			IngDretDetailGrid.startEditing(rowIndex,coldescIndex);
			return;
		}
	}
	;
	var rowData = IngDretDetailGridDs.getAt(rowIndex);
	rowData.set('code',code);
	rowData.set('desc',desc);
	rowData.set('ingri',INGRI);
	rowData.set('inclb',INCLB);
	//rowData.set('invNo',invNo);
	//rowData.set('qty',qty);
	rowData.set('sp',sp);
	rowData.set('rp',rp);
	rowData.set('batNo',batch);
	rowData.set('expDate',expdate);
	//rowData.set('sxNo',sxNo);
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set('uom',uom);
	rowData.set('uomDesc',uomDesc);
	//rowData.set('spAmt',spAmt);
	//rowData.set('rpAmt',rp*qty);
	//rowData.set('dretAmt',dretAmt);
	//rowData.set('invDate',invDate);
	//rowData.set('invAmt',invAmt);
	//rowData.set('retReason',cause);
	//rowData.set('reasonId',causeId);
	rowData.set('spec',spec);
	rowData.set('manf',mnf);
	rowData.set('stkqty',stkqty);

	rowData.set('buom',buom);
	rowData.set('confac',confac);
	rowData.set('InsuCode',InsuCode);
	rowData.set('InsuDesc',InsuDesc);
	if(setEnterSort(IngDretDetailGrid,colArr)){
		addDetailRow();
	}

	//IngDretDetailGrid.startEditing(rowIndex,colIndex);
	saveIngDret.enable();
	Ext.getCmp("Vendor").setDisabled(true);
	locField.setDisabled(true);
	groupField.setDisabled(true);
}


//新建退货单
function NewRet()
{
	Clear();
	addDetailRow();
}

//清空页面
function Clear(){
	//alert(App_StkTypeCode);
	gIngrt="";
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("dret").setValue("");
	Ext.getCmp("complete").setValue(false);
	Ext.getCmp("transOrder").setValue(false);		
	Ext.getCmp("audited").setValue(false);
	Ext.getCmp("dateField").setValue(new Date());
	Ext.getCmp("Vendor").setDisabled(false);
	groupField.setDisabled(false);
	locField.setDisabled(false);
	IngDretDetailGridDs.removeAll();
}


/*退货单完成*/
function Complete() {    
	var rowCount =IngDretDetailGridDs.getCount();
	if(rowCount==0) 
	{
		Msg.info('warning',$g('明细数据为空，请核对明细!'))
		return;
	} 

	     
	if((gIngrt!="")&&(gIngrt!=null)){
		/// 检查预算项目
	    var ret = SendBusiData(gIngrt,"RETURN","COMP");
	    if(!ret) return;

		Ext.Ajax.request({
			url:URL+'?actiontype=complet&ret='+gIngrt,
			waitMsg:$g('执行中...'),
			failure: function(result, request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success",$g("设置完成成功!"));
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
				}else{
					if (jsonData.info==-2)
					{
						Msg.info("error",$g("退货单已完成!"));
					}
					else
					{
						Msg.info("error",$g("设置完成失败!")+jsonData.info);
					}
				}
			},
			scope: this
		});
	}
	else
	{
		Msg.info("warning",$g( "没有需要完成的退货单!"));
		return;
	}
            
}        

/*取消完成*/
function cancelComplete() {
	
	if((gIngrt!="")&&(gIngrt!=null)){
		Ext.Ajax.request({
			url:URL+'?actiontype=cancelComompleted&ret='+gIngrt,
			waitMsg:$g('执行中......'),
			failure: function(result, request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success",$g("取消完成成功!"));
					Select(gIngrt);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:gIngrt}});
				}else{
					switch (jsonData.info)
					{
					 case '-1':
					 	Msg.info("warning",$g("退货单不存在!"));
					 	break;
					 case '-10':
					 	Msg.info("warning",$g("退货单已经审核,禁止取消完成!"));
					 	break;
					 case '-2':
					 	Msg.info("warning",$g("退货单未完成!"));
					 	break;
					 case '-99':
					 	Msg.info("error",$g("加锁失败!"));
					 	break;
					 default:
					 	Msg.info("error",$g("取消完成失败!")+jsonData.info);
					 	break;
					}
				}
			},
			scope: this
		});
	}
	else
	{
		Msg.info("warning", $g("没有需要取消完成的退货单!"));
		return;
	}
            
}        
function Select(Ingrt)
{
	if((Ingrt==null)||(Ingrt=="")){
		return;
	}
	gIngrt=Ingrt;
	Ext.Ajax.request({
		url:URL+'?actiontype=getOrder&rowid='+Ingrt,
		waitMsg:$g('查询中...'),
		failure: function(result, request) {
			Msg.info("error",$g("请检查网络连接!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				Ext.getCmp('dret').setValue(arrData[6]);
				addComboData(Vendor.getStore(),arrData[1],arrData[27]);
				Ext.getCmp('Vendor').setValue(arrData[1]);
				addComboData(GetGroupDeptStore,arrData[7],arrData[19]);
				Ext.getCmp("locField").setValue(arrData[7]);
				var compFlag=(arrData[4]=='Y'?true:false);
				Ext.getCmp("complete").setValue(compFlag);
				var adjchqFlag=(arrData[11]=='Y'?true:false);
				Ext.getCmp("transOrder").setValue(adjchqFlag);
				Ext.getCmp('groupField').setValue(arrData[14]);
				
				var audited=(arrData[15]=='Y'?true:false);  //已审核
				Ext.getCmp("audited").setValue(audited);
				var ingrdate=arrData[29];
				Ext.getCmp("dateField").setValue(ingrdate);
				//alert(compFlag);
				if(compFlag==true){
					saveIngDret.setDisabled(true);
					completeBT.setDisabled(true);
					//newBT.setDisabled(true);
				}else{
					saveIngDret.setDisabled(false);
					completeBT.setDisabled(false);
					//newBT.setDisabled(false);
					GetAmount();
				}
				Ext.getCmp("Vendor").setDisabled(true);
				groupField.setDisabled(true);
				locField.setDisabled(true);
			}
		},
		scope: this
	});
	
}
function SelectRec(Ingr)
{
	if((Ingr==null)||(Ingr=="")){
		return;
	}
	//gIngrt=Ingr;
	Ext.Ajax.request({
		url:URL+'?actiontype=getRec&rowid='+Ingr,
		waitMsg:$g('查询中...'),
		failure: function(result, request) {
			Msg.info("error",$g("请检查网络连接!"));
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				addComboData(Vendor.getStore(),arrData[1],arrData[2]);
				Ext.getCmp('Vendor').setValue(arrData[1]);
				addComboData(GetGroupDeptStore,arrData[10],arrData[11]);
				Ext.getCmp("locField").setValue(arrData[10]);
				Ext.getCmp("complete").setValue(false);
				Ext.getCmp('groupField').setValue(arrData[27]);
				saveIngDret.setDisabled(false);
				completeBT.setDisabled(false);
				groupField.setDisabled(true);
				Ext.getCmp("Vendor").setDisabled(true);
				
			}
		},
		scope: this
	});
	
}

function setGridEditable(grid,b)
{
		
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('qty');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('uom');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('reasonId');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('invNo');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('invDate');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('invAmt');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('sxNo');	        
	grid.getColumnModel().setEditable(colId,b);
	
}



/*看是否修改*/
function Modified(){
	var detailCnt=0
	var rowCount=IngDretDetailGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
				var item = IngDretDetailGrid.getStore().getAt(i).get("IncId");
				if (item != "") {
					detailCnt++;
				}
			}
	var result=false;
	//若为新单(gIngrt="")，看子表是否有插入
	if ((gIngrt<=0)||(gIngrt==''))
	{
		if (detailCnt==0) {
			result=false;
		} else{
			result= true;
		}		
	}else{  //若不为新单，看主表或子表
		for(var index=0;index<rowCount;index++){
			var rec = IngDretDetailGrid.getStore().getAt(index);	
					//新增或数据发生变化时执行下述操作
		    if(rec.data.newRecord || rec.dirty){
				result = true;
			}	
	    }
	}
	return result;
}
/*设置原始值，维持初始未修改状态*/
function setOriginalValue(formId)
{
	if (formId=="") return;
	Ext.getCmp(formId).getForm().items.each(function(f){ 		
		f.originalValue=String(f.getValue()); 
	});
}
//取得指定单位的入库价格（进价+售价）
//ingri - 入库明细rowid
//uom - 单位rowid
function SetIngriPrice(rec,ingri,uom)
{
	Ext.Ajax.request({
		url:URL+'?actiontype=getIngriPrice'+"&ingri="+ingri+"&uom="+uom,
		failure:function(){
			Msg.info("error",$g("失败!"));
		},
		success:function(result, request){
			//alert(result.responseText);
			var jsonData = Ext.util.JSON.decode( result.responseText );
			
			if (jsonData.success=='true') {
				var strData=jsonData.info;				
				var arrData=strData.split("^");
				var rp=arrData[0];
				var sp=arrData[1];
				rec.set('rp',rp);
				rec.set('sp',sp);	
				var qty=rec.get('qty');
				var rpAmt=accMul(rp,qty);	
				var spAmt=accMul(sp,qty);
				rpAmt=FormatGridRpAmount(rpAmt);
				spAmt=FormatGridSpAmount(spAmt);
				rec.set('rpAmt',rpAmt);
				rec.set('spAmt',spAmt);
				rec.set('invAmt',rpAmt);
				GetAmount();
			}
		}	
	})
}

function BeforeSave()
{


}

//处理选中的入库批次
function handleSelectedIngri(rec)
{
	AddList(rec);
}

function test()
{
	
}

	
//退出或刷新时,界面提示是否保存
//Creator:bianshuai 2014-04-21
window.onbeforeunload = function(){
	var compFlag=Ext.getCmp('complete').getValue();
	var mod=Modified();
	if  (mod&&(!compFlag)) {
		return $g("数据已录入或修改,你当前的操作将丢失这些结果,是否继续？");
	} 
}
