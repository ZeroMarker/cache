// 名称:虚拟入库
///编写人:徐超
// 编写日期:2013-05-31

var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

// 物资类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:CtLocId,
	UserId:UserId,
	anchor:'70%'
});
var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'科室',
	listWidth:200,
	emptyText:'科室...',
	groupId:gGroupId,
	anchor:'90%',
	stkGrpId : 'StkGrpType',
	childCombo : 'Vendor'
});
var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor:'90%',
		params : {LocId : 'LocField',ScgId : 'StkGrpType'}
	});
//=========================虚拟入库制单=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
	width:210,
	listWidth:210,
    allowBlank:false,
	fieldLabel:'制单日期',
	anchor:'90%',
	//value:'2008-08-08', //new Date(),
	editable:false,
	disabled:true
});
var InGrNo = new Ext.form.TextField({
	fieldLabel : '入库单号',
    id : 'InGrNo',
	name : 'InGrNo',
	anchor : '90%',
	disabled : true
	        });
var CTUom = new Ext.form.ComboBox({
					fieldLabel : '单位',
					id : 'CTUom',
					name : 'CTUom',
					anchor : '90%',
					width : 120,
					store : ItmUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '单位...',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 10,
					listWidth : 250,
					valueNotFoundText : ''
});

/// 单位展开事件
CTUom.on('expand', function(combo) {
					var cell = VirINGdRec.getSelectionModel().getSelectedCell();
					var record = VirINGdRec.getStore().getAt(cell[0]);
					var InciDr = record.get("inci");
					ItmUomStore.removeAll();
					ItmUomStore.load({params:{ItmRowid:InciDr}});
				});

///单位变换事件	 
CTUom.on('select', function(combo) {
					var cell = VirINGdRec.getSelectionModel().getSelectedCell();
					var record = VirINGdRec.getStore().getAt(cell[0]);
					
					var value = combo.getValue();  //目前选择的单位id
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系					
					var IngrUom = record.get("IngrUomId");    //目前显示的入库单位
					var Sp = record.get("Sp");
					var Rp = record.get("Rp");
					var NewSp = record.get("NewSp");
					if (value == null || value.length <= 0) {
						return;
					} else if (IngrUom == value) {
						return;
					} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
						record.set("Sp", Sp/ConFac);
						record.set("NewSp", NewSp/ConFac);
						record.set("Rp", Rp/ConFac);						
					} else{  //新选择的单位为大单位，原先是单位为小单位
						record.set("Sp", Sp*ConFac);
						record.set("NewSp", NewSp*ConFac);
						record.set("Rp", Rp*ConFac);
					}
					record.set("uom", combo.getValue());
				});

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'',
	height : 30,
	width : 70,
	iconCls:'page_add',
	handler:function()
	{	
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	height : 30,
	width : 70,
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});

var RpEditor=new Ext.ux.NumberField({
	formatType : 'FmtRP',
	selectOnFocus : true,
	allowBlank : false,
	listeners : {
		blur:function(field){
				var cost = field.getValue();
				if (cost == null
						|| cost.length <= 0) {
					Msg.info("warning", "进价不能为空!");
					return;
				}
				if (cost <= 0) {
					Msg.info("warning",
							"进价不能小于或等于0!");
					return;
				}
			}
		}
})


//配置数据源
var VirINGdRecUrl = 'dhcstm.viringdrecaction.csp?actiontype=QueryDetail';
var VirINGdRecProxy= new Ext.data.HttpProxy({url:VirINGdRecUrl});
var VirINGdRecDs = new Ext.data.Store({
	proxy:VirINGdRecProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        id:'Ingri',
		totalProperty:'results'
    }, [
		{name:'inclb',mapping:'Inclb'},
		{name:'inci',mapping:'IncId'},
		{name:'code',mapping:'IncCode'},
		{name:'desc',mapping:'IncDesc'},
		{name:'spec',mapping:'Spec'},
		{name:'manf',mapping:'Manf'},
		{name:'batNo',mapping:'BatchNo'},
		{name:'expDate',mapping:'ExpDate'},
		{name:'qty',mapping:'RecQty'},
		{name:'uom',mapping:'IngrUomId'},
	    {name:'uomDesc',mapping:'IngrUom'},
		{name:'InclbQty',mapping:'InclbQty'},
		{name:'rp',mapping:'Rp'},
		{name:'sp',mapping:'Sp'},
		{name:'Ingri',mapping:'Ingri'}
	]),
    remoteSort:false
});

var VirINGdRecCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
    {
        header:"批次rowid",
        dataIndex:'inclb',
        width:10,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资rowid",
        dataIndex:'inci',
        width:120,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        id:'desc',
        width:160,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue());
					}
				}
			}
        })
   
 },{
    header:"批次~效期",
    dataIndex:'batNo',
    width:150,
    align:'left',
    sortable:true
}, {
	header : "单位",
	dataIndex : 'uom',
	width : 90,
	align : 'left',
	sortable : true,
	renderer :Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
	editor : new Ext.grid.GridEditor(CTUom),
	listeners : {
	specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {									
									;									
								}
							}
						}
}, {
	header : "进价",
	dataIndex : 'rp',
	width : 60,
	align : 'right',				
	sortable : true
	//,
	//editor : RpEditor
}, {
	header : "库存量",
	dataIndex : 'InclbQty',
	width : 80,
	align : 'right',				
	sortable : true
	
	
   },{
        header:"入库数量",
        id:'qty',
        dataIndex:'qty',        
        width:80,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			listeners:{
				//change:function (monthsfield,newValue,oldValue){
				specialKey:function(field, e) {	
					var cell = VirINGdRec.getSelectionModel().getSelectedCell();
					var rowData = VirINGdRecDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
					var	newValue=field.getValue();
					//使页面的列中保留2位小数
					//小数位数变量
					var pos = 2;
					rowData.set("spAmt",Math.round(newValue*rowData.get('sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
					rowData.set("rpAmt",Math.round(newValue*rowData.get('rp')*Math.pow(10,pos))/Math.pow(10,pos));
					addNewRow();
					}
                }
               
			}
        })
      },{
        header:"厂商id",
        dataIndex:'manfid',
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
        header:"售价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    }
]);
//初始化默认排序功能
VirINGdRecCm.defaultSortable = true;

var addVirINGd = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		clearPage()
		addNewRow();
	}
});

var saveVirINGd = new Ext.ux.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save();
    }
});

var clearVirINGd = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		clearPage();
    }
});

var formPanel = new Ext.form.FormPanel({
	labelwidth : 20,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[addVirINGd,'-',saveVirINGd,'-',clearVirINGd],
	items : [{
		layout : 'fit',
		items : [{
			xtype : 'fieldset',
			title : '虚拟入库单信息',			
			autoHeight : true,
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .3,
					layout : 'form',
					items : [LocField,InGrNo]
				}, {
					columnWidth : .3,
					layout : 'form',
					items : [Vendor,dateField]
			   }, {
					columnWidth : .3,
					layout : 'form',
					items : [StkGrpType]
				}]
			}]
		}]
	}]
});

//表格
var VirINGdRec = new Ext.grid.EditorGridPanel({
	title:'明细记录',
	store:VirINGdRecDs,
	cm:VirINGdRecCm,
	id:'VirINGdRec',
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	listeners : {
	afteredit : function(e){
				if(e.field=='qty'){
						if(e.value>e.record.get('InclbQty')){
							Msg.info("warning","虚拟入库数量不能超过批次可用库存!");
							e.record.set('qty',e.originalValue);
							return;
						}
				}
	}
	},
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{height:30,width:70,text:'列设置',iconCls:'page_gear',handler:function(){	GridColSet(VirINGdRec,"DHCSTVIRIMPORTM");}}]}
});
//=========================虚拟入库制单=============================
function Select(Ingrt)
{
	if((Ingrt==null)||(Ingrt=="")){
		return;
	}
	gIngrt=Ingrt;
	Ext.Ajax.request({
		url:'dhcstm.viringdrecaction.csp?actiontype=Select&IngrRowid='+Ingrt,
		waitMsg:'查询中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				var strData=jsonData.info;
				var arrData=strData.split("^");
				Ext.getCmp('InGrNo').setValue(arrData[0]);	
				Ext.getCmp('dateField').setValue(arrData[12]);	
			}
		},
		scope: this
	});
	
}
function checkBeforeSave()
{	
	//检查是否有明细记录
		if (VirINGdRec.getStore().getCount()==0)
		{
			Msg.info('error','没有任何明细记录!');
			return false;
		}
	return true;
}

function save()
{
	if (!checkBeforeSave()) return;
	
	var User = UserId;
	var StkType = App_StkTypeCode
	var Loc = Ext.getCmp('LocField').getValue();
	if((Loc=="")||(Loc==null)){
		Msg.info("error","请选择科室!");
		return false;
	}
  var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	if((StkGrpType=="")||(StkGrpType==null)){
		Msg.info("error","请选择类组!");
		return false;
	}

	var Vendor = Ext.getCmp('Vendor').getValue();
	if((Vendor=="")||(Vendor==null)){
		Msg.info("error","请选择供应商!");
		return false;
	}
	
	var dateField =Ext.util.Format.date(Ext.getCmp('dateField').getValue(),ARG_DATEFORMAT);
	if(dateField=='')
	{
		dateField='2008-08-08';
	}

	var mainData = User+"^"+StkType+"^"+Loc+"^"+Vendor+"^"+dateField+"^"+StkGrpType;
	
	//组织明细数据
	var detailData="";
	var count = VirINGdRecDs.getCount();
	for(var index=0;index<count;index++){		
		var rec = VirINGdRecDs.getAt(index);
		if (rec.data.newRecord || rec.dirty){		
			var inclb = rec.get('inclb');//批次rowid
			if((inclb!="")&&(inclb!=null)){
				var qty = rec.get('qty');
				if ((qty=='')||(parseFloat(qty)==0)||qty<0){
					Msg.info('error','第'+(index+1)+'行入库数量为空或者小于0!');
					return;				
				} 
				var uom = rec.get('uom');
				var sp = Number(rec.get('sp'));
				var rp = Number(rec.get('rp'));	
				if ((rp=='')||(parseFloat(rp)==0)){
					Msg.info('error','第'+(index+1)+'行进价不能为零!');
					return;	
				}
				if (rp>sp){
					//Msg.info('error','第'+(index+1)+'行进价不能大于售价!');
					//return;
					if(confirm('第'+(index+1)+'行进价大于售价, 是否继续?')==false){
						return false;
					}
				}
				var manfid = rec.get('manfid');	
				var tmp = inclb+"^"+qty+"^"+uom+"^"+rp+"^"+sp+"^"+manfid
				if(detailData!=""){
					detailData = detailData+xRowDelim()+tmp;
				}else{
					detailData = tmp;
				}
			}							
		}
	}
	if(detailData==""){
		Msg.info("warning","没有需要保存的明细!");
		return;
	}
	var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		
		url: 'dhcstm.viringdrecaction.csp?actiontype=Save',
		params: {mainData:mainData,detailData:detailData},
		failure: function(result,request) {
				loadMask.hide();
			Msg.info("error","请检查网络连接!");
		},
		success: function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText );
				loadMask.hide();
			if (jsonData.success=='true') {
				Msg.info("success","保存成功!");
				main=jsonData.info   //rowid - 主表单号
				Select(main);
				VirINGdRecDs.load({params:{start:0,limit:999,sort:'',dir:'',Parref:main}});

				
			}else{
				if(jsonData.info<0){
			
					Msg.info("error","保存失败!"+jsonData.info);
				}
			}
		},
		scope: this
	});
}

function GetPhaOrderInfo2(item) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("LocField").getValue();
		var StkGrpType=Ext.getCmp("StkGrpType").getValue();
		IncItmBatWindow(item,StkGrpType, App_StkTypeCode, phaLoc, "N", "0", HospId,"",returnInfo,"VG");
	}
}

//增加一条(明细)
function addDetailRow()
{
	addNewRow();
}

//删除一条(明细)
function DeleteDetail()
{	
	var cell = VirINGdRec.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning","请选择数据!");
		return false;
	}else{
		var record = VirINGdRecDs.getAt(cell[0]);
		VirINGdRecDs.remove(record);
		VirINGdRec.getView().refresh();
		return false;
	}
}
//科室库存项批次信息窗口关闭时回调函数
function returnInfo(records) {
	var records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records,function(record,index,allItems){
		inciDr = record.get("InciDr");
		var cell = VirINGdRec.getSelectionModel().getSelectedCell();
		var rowData = VirINGdRec.getStore().getAt(cell[0]);
		rowData.set("inci",inciDr);
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("batNo",record.get("BatExp"));
		rowData.set("manf",record.get("ManfName"));
		//rowData.set("uom",record.get("PurUomId"));
		//rowData.set("uomDesc",record.get("PurUomDesc"));
		addComboData(ItmUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
		rowData.set("uom",record.get("PurUomId"));
		rowData.set("sp",record.get("Sp"));
		rowData.set("InclbQty",record.get("InclbQty"));
		rowData.set("rp",record.get("Rp"));
		rowData.set("inclb",record.get("Inclb"));
		rowData.set("qty",record.get("OperQty"));
		rowData.set("spAmt",accMul(record.get("OperQty"),record.get('Sp'))); 
		rowData.set("rpAmt",accMul(record.get("OperQty"),record.get('Rp')));	
		//取其它物资信息,同步处理
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+session['LOGON.USERID'];
		var url = DictUrl
					+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
					+ inciDr+"&Params="+Params;
		var result = ExecuteDBSynAccess(url);
		var info = Ext.util.JSON.decode(result).info;
		var data = info.split("^");
		addComboData(PhManufacturerStore,data[0],data[1]);
		rowData.set("manfid", data[0]);
		var lastIndex = VirINGdRec.getStore().getCount()-1;
		if(VirINGdRec.getStore().getAt(lastIndex).get('inci')!=""){
			addNewRow();
		}else{
			var col=GetColIndex(VirINGdRec,'desc')
			VirINGdRec.startEditing(lastIndex,col);
		}
	});
}

//增加新行(明细)
function addNewRow() {
	
	var rowCount =VirINGdRec.getStore().getCount();
	if(rowCount>0){
		var rowData = VirINGdRecDs.data.items[rowCount - 1];
		var data=rowData.get("inclb")
		if(data=="" || data.length<=0){
			Msg.info("warning","已存在新建行");
			return;
		}
	}
	var NewRecord = CreateRecordInstance(VirINGdRecDs.fields);
	VirINGdRecDs.add(NewRecord);
	//修改列设置后出错
	var colIndex=GetColIndex(VirINGdRec,"desc");
	VirINGdRec.getSelectionModel().select(VirINGdRecDs.getCount() - 1, colIndex);
	VirINGdRec.startEditing(VirINGdRecDs.getCount() - 1, colIndex);
	//VirINGdRec.startEditing(VirINGdRecDs.getCount()-1 ,4);
}

//清空页面
function clearPage()
{
	Ext.getCmp('Vendor').setValue("");
	Ext.getCmp('InGrNo').setValue("");
	VirINGdRecDs.removeAll();
}
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'虚拟入库制单',
		activeTab:0,
		layout:'fit',
		region:'north',
		height:170,
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel,VirINGdRec],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(VirINGdRec,"DHCSTVIRIMPORTM");   //根据自定义列设置重新配置列
});
//===========模块主页面=============================================