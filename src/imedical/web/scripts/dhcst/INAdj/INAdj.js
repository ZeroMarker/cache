// 名称:库存调整制单
// 编写日期:2012-08-27
var deptId = 0;
var deptName = "";
var purId = "";
var purNo = "";
var mainRowId="";
var reasonId = "";
//根据计划单号purId查询相关信息
if((purId!="")&&(purId!=null)&&(purId!=0)){
	Ext.Ajax.request({
		url : 'dhcst.inpurplanauxbyrequestaction.csp?actiontype=select&purId='+purId,
		method : 'POST',
		waitMsg : $g('查询中...'),
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var arr = jsonData.info.split("^");
			purNo = arr[1];
			deptName = arr[3];
		},
		scope : this
	});
}
var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";


//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name : 'locField',
	fieldLabel:$g('科室'),
	//width:120,
	listWidth:200,
	emptyText:$g('科室...'),
	groupId:gGroupId,
	anchor:'90%',
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
var adjUserField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:$g('调整人'),
	anchor:'90%',
	disabled:true
});


//=========================库存调整制单=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
	width:210,
	listWidth:210,
    allowBlank:false,
	fieldLabel:$g('制单日期'),
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
    allowBlank:false,
	fieldLabel:$g('制单时间'),
	//format:'HH-MM-SS',
	anchor:'90%',
	//value:new Time(),
	disabled:true
});

var adjNumField = new Ext.form.TextField({
	id:'adjNumField',
	fieldLabel:$g('调整单号'),
	allowBlank:true,
	//width:120,
	emptyText:$g('调整单号...'),
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:$g('备注'),
	allowBlank:true,
	width:200,
	height:50,
	listWidth:200,
	emptyText:$g('备注...'),
	anchor:'90%',
	selectOnFocus:true
});

// 药品类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:$g('类组'),
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:CtLocId,
	UserId:UserId,
	anchor : '90%'
});

// 调整原因
var causeField = new Ext.form.ComboBox({
	id:'causeField',
	fieldLabel:$g('调整原因'),
	listWidth:200,
	allowBlank:true,
	store:ReasonForAdjustMentStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:$g('调整原因...'),
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
	text:$g('单据完成'),
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		var finshCK = Ext.getCmp('finshCK').getValue();
        var mod = isDataChanged();
        if (mod && (!finshCK)) {
            Ext.Msg.confirm($g('提示'), $g('数据已发生改变,是否需要保存后完成?'),
                function(btn) {
                    if (btn == 'yes') {
                        return;
                    } else {
                        setComplete();
                    }

                }, this);
        } else {
            setComplete();
        }
	}
});

var cancelAdjComplete=new Ext.Toolbar.Button({
	text:$g('取消单据完成'),
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		cancelComplete();
	
	}
});

var printInadj = new Ext.Toolbar.Button({
	id : "printInadj",
	text : $g('打印'),
	tooltip : $g('打印调整单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId==null || mainRowId=="") {
			Msg.info("warning", $g("没有需要打印的调整单!"));
			return;
		}
		PrintInAdj(mainRowId);
	}
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	boxLabel:$g('完成'),
	disabled:true,
	allowBlank:true,
	listeners:{
		'check':function(chk,v){
			//alert('check');
			var grid=Ext.getCmp('INAdjMGrid');
			setGridEditable(grid,!v)
		}
	}
});

var auditCK = new Ext.form.Checkbox({
	id: 'auditCK',
	boxLabel:$g('审核'),
	disabled:true,
	allowBlank:true
	
});


var AddDetailBT=new Ext.Button({
	text:$g('增加一条'),
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
	text:$g('删除一条'),
	height:30,
	width:70,
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});

var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('列设置'),
    tooltip:$g('列设置'),
    iconCls:'page_gear',
//	width : 70,
//	height : 30,
	handler:function(){
		GridColSet(INAdjMGrid,"DHCSTSTOCKADJ");
	}
});

// 进价合计
var rpAmount = new Ext.form.Label({
	text : $g('进价合计:'),
	id : 'rpAmount',
	width:500,
	anchor : '90%'
	});	
		
// 售价合计
var spAmount = new Ext.form.Label({
	text : $g('售价合计:'),
	id : 'spAmount',
	anchor : '90%',
	width:200
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
	emptyText : $g('单位...'),
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250	,
	valueNotFoundText : ''
});
ItmUomStore.on('beforeload',function(store){
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var record = INAdjMGrid.getStore().getAt(cell[0]);
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
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var record = INAdjMGrid.getStore().getAt(cell[0]);
	
	var value = combo.getValue();        //目前选择的单位id
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //大单位到小单位的转换关系		
	var Uom = record.get("uom");    //目前显示的调整单位
	var BatStkQty=record.get("InclbAvaQty");
	var Rp=record.get("rp");
	var Sp=record.get("sp");
	var NewStkQty=BatStkQty;
	var NewRp=Rp
	var NewSp=Sp
	var qty=record.get("qty");
	var pos = 2;
	if(value!=Uom){
		var Inclb=record.get("inclb");
		var QtyAndPriceInfo = tkMakeServerCall("web.DHCST.Util.DrugUtil","GetIncilbInfo",Inclb,value)
		if (QtyAndPriceInfo=="") return;
		var InfoArr = QtyAndPriceInfo.split("^")
		record.set("sp", InfoArr[0] ); 
		record.set("rp", InfoArr[1] );
		//record.set("inclbQty", InfoArr[2]);
		record.set("InclbAvaQty", InfoArr[4]);
		/*
		if(value==BUom){
			NewStkQty=BatStkQty*ConFac;
			NewRp=Rp/ConFac;
			NewSp=Sp/ConFac;
		}else{
			NewStkQty=BatStkQty/ConFac;
			NewRp=Rp*ConFac;
			NewSp=Sp*ConFac;
		}

		record.set("InclbAvaQty",NewStkQty)
		record.set("rp",NewRp)
		record.set("sp",NewSp)
		*/	
		
	}


   //使页面的列中保留2位小数
   //小数位数变量
   if ((qty!=null)&&(qty!=0)){
		var newSpAmt=qty*record.get('sp');
		var newRpAmt=qty*record.get('rp');
		newSpAmt=1*FormatGridSpAmount(newSpAmt);
		newRpAmt=1*FormatGridRpAmount(newRpAmt);
		record.set("spAmt",newSpAmt);
		record.set("rpAmt",newRpAmt);
   		setStatAmount();
   }	
      
	record.set("uom", combo.getValue());	

	
});

//配置数据源
var INAdjMGridUrl = 'dhcst.inadjaction.csp';
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
		{name:'InclbAvaQty'},  //InclbAvaQty
		{name:'buom'},
		{name:'confac'}
	]),
    remoteSort:false
});

//模型
var INAdjMGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("明细rowid"),
        dataIndex:'adjitm',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("批次rowid"),
        dataIndex:'inclb',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("药品rowid"),
        dataIndex:'inci',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("代码"),
        dataIndex:'code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'desc',
        id:'desc',
        width:150,
        align:'left',
        sortable:true,
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
        header:$g("规格"),
        dataIndex:'spec',
        width:80,
        align:'left',
        sortable:true //,
		//hidden:true
    },{
        header:$g("生产企业"),
        dataIndex:'manf',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("批次~效期"),
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    
    },{
        header:$g("调整单位"),
        dataIndex:'uom',
        id:'uom',
        width:80,       
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
		editor : new Ext.grid.GridEditor(CTUom),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(INAdjMGrid,"uom");
					INAdjMGrid.startEditing(cell[0], colIndex);									
				}
			}
		}
    },{
        header:$g("批次可用库存"),
        dataIndex:'InclbAvaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:$g("调整数量"),
        id:'adjQty',
        dataIndex:'qty',        
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.ux.NumberField({
			id:'qtyField',
			formatType:'FmtSQ',
            allowBlank:false,
			listeners:{
                specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {	
						var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
						var rowData = INAdjMGridDs.getAt(cell[0]);
						var col=GetColIndex(INAdjMGrid,'qty');
						var newqty=field.getValue();
						
						var buomId=rowData.get("buom")
	                    var uom=rowData.get("uom")
	                    var buomQty=newqty
	                    var fac=rowData.get("confac")
						
						if(newqty<0 && (Math.abs(newqty)>rowData.get('InclbAvaQty'))){
							Msg.info("warning",$g("调整数量为负数时不能超过批次库存!"));
							return false;
						}else if(gParam[0]!="Y")  ////新增调整数量是否允许小数判断 2020-02-20 yangsj 1 允许录入小数
                		{
	                		if(buomId!=uom)
		                    {
		                        buomQty=Number(fac).mul(newqty);
		                    }
		                    if((buomQty.toString()).indexOf(".")>=0)
		                    {
			                    Msg.info("warning", $g(" 调整数量换算成基本单位之后存在小数，不能调整！请核对库存调整配置!：调整数量换算为基本单位是否允许小数"));
			                    return;
		                    }
                		}
						
						else{
							//使页面的列中保留2位小数
							//小数位数变量
							var newSpAmt=newqty*rowData.get('sp');
							var newRpAmt=newqty*rowData.get('rp');
							newSpAmt=1*FormatGridSpAmount(newSpAmt);
							newRpAmt=1*FormatGridRpAmount(newRpAmt);
							rowData.set("spAmt",newSpAmt);
							rowData.set("rpAmt",newRpAmt);
							//rowData.set("spAmt",Math.round(newqty*rowData.get('sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							//rowData.set("rpAmt",Math.round(newqty*rowData.get('rp')*Math.pow(10,pos))/Math.pow(10,pos));							
							addNewRow();
							setStatAmount();
	                	}
					}
				}
			}
        })
    },{
        header:$g("售价"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("售价金额"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:$g("进价"),
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("进价金额"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    }
]);
//初始化默认排序功能
INAdjMGridCm.defaultSortable = true;

var addINAdjM = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:$g('提示'),
				msg: $g('已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？'),
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
		mainRowId='';
		clearPage();
		addNewRow();

}
var findINAdjM = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			{
				Ext.Msg.show({
					title:$g('提示'),
					msg: $g('已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？'),
					buttons: Ext.Msg.YESNO,
					fn: function(btn){
				   		if (btn=='yes') {clearPage();FindINAdj(INAdjMGridDs,adjNumField,mainRowId,locField,dateField,addINAdjM,finshCK,auditCK,select);}
				   }
	
				})
			
			}	
		}
		else
		{
			//clearPage();
		FindINAdj(INAdjMGridDs,adjNumField,mainRowId,locField,dateField,addINAdjM,finshCK,auditCK,select);
	}
	
	
	
		
	}
});


var saveINAdjM = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save();
    }
});

var deleteINAdjM = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		deleteAdj();
	}
});

var clearINAdjM = new Ext.Toolbar.Button({
	text:$g('清屏'),
    tooltip:$g('清屏'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:$g('提示'),
				msg: $g('已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？'),
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
	labelWidth : 60,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findINAdjM,'-',clearINAdjM,'-',addINAdjM,'-',saveINAdjM,'-',adjComplete,'-',cancelAdjComplete,'-',printInadj,'-',deleteINAdjM],
	items : [{
		//autoHeight : true,
		layout : 'fit',
		autoScroll:true,
		items : [{
			xtype : 'fieldset',
			title : $g('调整单信息'),	
			autoHeight : true,
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{				
				layout : 'column',
				items : [{
					columnWidth : .26,
					xtype : 'fieldset',
					border:false,	
					items : [adjNumField,causeField,adjUserField]
				}, {
					border:false,	
					columnWidth : .25,
					xtype : 'fieldset',
					items : [locField,dateField,timeField]
				}, {
					border:false,	
					columnWidth : .25,
					xtype : 'fieldset',
					items : [groupField,remarkField]
				},{
					border:false,	
					columnWidth : .2,
					xtype : 'fieldset',	
					listWidth:10,				
					items : [finshCK,auditCK]
				}]
			}]
		}]
	}]
});

//表格
var INAdjMGrid = new Ext.grid.EditorGridPanel({
	title:$g('明细记录'),
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
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	bbar:[rpAmount,'-',spAmount]
});
INAdjMGrid.store.on('load',function(){
	setStatAmount();
	})
//=========================库存调整制单=============================

function checkBeforeSave()
{	
	//检查是否有明细记录
	if (mainRowId=='')
	{
		if (INAdjMGrid.getStore().getCount()==0)
		{
			Msg.info('error',$g('没有任何明细记录!'));
			return false;
		}
	}
	//检查明细情况
	
			// 1.判断药品是否为空
			var rowCount = INAdjMGrid.getStore().getCount();
			// 有效行数
			var count = 0;
			for (var i = 0; i < rowCount; i++) {
				var item = INAdjMGridDs.getAt(i).get("inci");
				if (item != "") {
					count++;
				}
			}
			if (rowCount <= 0 || count <= 0) {
				Msg.info("warning", $g("请输入请求明细!"));
				return false;
			}
			// 2.重新填充背景
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			// 3.判断重复输入药品
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var item_i = INAdjMGridDs.getAt(i).get("inclb");;
					var item_j = INAdjMGridDs.getAt(j).get("inclb");;
					var itemdesc=INAdjMGridDs.getAt(i).get("desc");;
					var icnt=i+1;
					var jcnt=j+1;
					if (item_i != "" && item_j != ""
							&& item_i == item_j ) {
						changeBgColor(i, "yellow");
						changeBgColor(j, "yellow");
						Msg.info("warning", itemdesc+$g(",第")+icnt+","+jcnt+$g("行药品重复，请重新输入!"));
						return false;
					}
				}
			}
	
	
	return true;
}

		// 变换行颜色
		function changeBgColor(row, color) {
			INAdjMGrid.getView().getRow(row).style.backgroundColor = color;
		}



function save()
{
	if (!checkBeforeSave()) return;
	
	var adjUser = UserId;
	var adjStkType = App_StkTypeCode
	var adjInst = "";
	var adjLoc = Ext.getCmp('locField').getValue();
	if((adjLoc=="")||(adjLoc==null)){
		Msg.info("error",$g("请选择供应科室!"));
		return false;
	}
	
	var adjScg = Ext.getCmp('groupField').getValue();
	if(((adjScg=="")||(adjScg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error",$g("请选择类组!"));
		return false;
	}
	
	var adjComp = (Ext.getCmp('finshCK').getValue()==true?'Y':'N');
	var adjState = (Ext.getCmp('auditCK').getValue()==true?'Y':'N');
	
	var adjReason = Ext.getCmp('causeField').getValue();
	if((adjReason=="")||(adjReason==null)){
		Msg.info("error",$g("请选择调整原因!"));
		return false;
	}
	var remark = Ext.getCmp('remarkField').getValue();	

	var ss=remark.replace(/\r\n/g,xMemoDelim())
    remark=ss;
    
	var tmpData = adjLoc+"^"+adjUser+"^"+adjReason+"^"+adjScg+"^"+adjStkType+"^"+adjInst+"^"+adjComp+"^"+adjState+"^"+remark;
	var mainData=tmpData;
	
	//组织明细数据
	var detailData="";
	var count = INAdjMGridDs.getCount();
	for(var index=0;index<count;index++){		
		var rec = INAdjMGridDs.getAt(index);
		if (rec.data.newRecord || rec.dirty){		
			var adjitm = rec.get('adjitm'); //子表明细rowid
			var inclb = rec.get('inclb');//批次rowid
			var InclbAvaQty=rec.get("InclbAvaQty");
		
			if((inclb!="")&&(inclb!=null)){
				var qty = rec.get('qty');
				
				if ((qty=='')||(parseFloat(qty)==0)){
					Msg.info('error',$g('当前行调整数量不可为空!'));
					var qtyColIndex=Ext.getCmp('INAdjMGrid').getColumnModel().getIndexById('adjQty');
					Ext.getCmp('INAdjMGrid').getSelectionModel().select(index,qtyColIndex);	
					return;				
				} 
				if(qty<0 && (Math.abs(qty)>InclbAvaQty)){
					         Msg.info("error",$g("调整数量为负数时不能超过批次库存!"));
					         return;}
				var uom = rec.get('uom');
				
				var buomId=rec.get("buom")
	            var buomQty=qty
	            var fac=rec.get("confac")
				
				if(gParam[0]!="Y")  ////新增调整数量是否允许小数判断 2020-02-20 yangsj 1 允许录入小数
	    		{
	        		if(buomId!=uom)
	                {
	                    buomQty=Number(fac).mul(qty);
	                }
	                if((buomQty.toString()).indexOf(".")>=0)
	                {
	                    Msg.info("warning", rec.get("desc")+$g(" 调整数量换算成基本单位之后存在小数，不能调整！请核对库存调整配置：调整数量换算为基本单位是否允许小数!"));
	                    return;
	                }
	    		}
		
				var sp = rec.get('sp');
				var spAmt = rec.get('spAmt');
				var rp = rec.get('rp');
				var rpAmt = rec.get('rpAmt');
				var insti = rec.get('insti');			
				var tmp = adjitm+"^"+inclb+"^"+qty+"^"+uom+"^"+rp+"^"+sp+"^"+rpAmt+"^"+spAmt+"^"+insti;
				if(detailData!=""){
					detailData = detailData+xRowDelim()+tmp;
				}else{
					detailData = tmp;
				}
			}							
		}
	}

	if((!IsFormChanged(formPanel))&&(detailData=="")){
		Msg.info("error", $g("没有内容需要保存!"));
		return false;
	};
	
	var loadMask=ShowLoadMask(Ext.getBody(),$g("处理中..."));
	Ext.Ajax.request({
		url: INAdjMGridUrl+'?actiontype=saveAdj',
		params:{adj:mainRowId,mainData:tmpData,detailData:detailData},
		failure: function(result,request) {
			Msg.info("error",$g("请检查网络连接!"));
		},
		success: function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success",$g("保存成功!"));
				mainRowId=jsonData.info   //rowid - 主表rowid	
				select(mainRowId)		
			}else{
				if(jsonData.info==-1){
					Msg.info("error",$g("插入出错!"));
				}else{
					Msg.info("error",$g("保存失败!")+jsonData.info);
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
				data=jsonData.rows  ;
				if (!data) return;
			 	var loc=data[0]['INAD_CTLOC_DR']   ;
			 	var locdesc=data[0]['locDesc']
			 	var scg=data[0]['INAD_SCG_DR'] ;
			 	var reason=data[0]['INAD_ReasonAdj_DR'];
			 
			 	var no=data[0]['INAD_No']  ;
			 	var adjDate=data[0]['INAD_Date'];
			 	var adjTime=data[0]['INAD_Time'] ;
			 	var completeFlag=data[0]['INAD_Completed'] ; 
			 	var auditFlag=data[0]['INAD_ChkFlag'] ;
			 	var remark=data[0]['INAD_Remarks']  ;
			 	remark=handleMemo(remark,xMemoDelim());
		 		
			 	var userName=data[0]['userName'] ;
			 	var auditUserName=data[0]['INAD_ChkUser_DR'] ;
			 	var chkDate=data[0]['INAD_ChkDate'];
			 	var chkTime=data[0]['INAD_ChkTime'];
			 	addComboData(Ext.getCmp("locField").getStore(),loc,locdesc);
			 	Ext.getCmp('locField').setValue(loc);
		               
			 	Ext.getCmp('adjNumField').setValue(no);
			 
			 	Ext.getCmp('dateField').setValue(adjDate);
			 
			 	Ext.getCmp('adjUserField').setValue(userName);
			 
			 	Ext.getCmp('timeField').setValue(adjTime);
			 	Ext.getCmp('finshCK').setValue(((completeFlag=='Y')?'true':'false'));
			 	
			 	//alert(completeFlag);
			 	INAdjMGridDs.load({
				 	params:{start:0,limit:9999,adj:rowid},
					callback : function(r,options, success){
						if(success==false){
							Ext.MessageBox.alert($g("查询错误"),this.reader.jsonData.Error); 
		     			}
					}
				 });
			 	
			 	if (completeFlag=='Y') 
			 	{saveINAdjM.disable();}
			 	else
			 	{saveINAdjM.enable();}
			 	
			 	Ext.getCmp('auditCK').setValue(((auditFlag=='Y')?'true':'false'));
			 	Ext.getCmp('causeField').setValue(reason);
			 	Ext.getCmp('groupField').setValue(scg);
			 	Ext.getCmp('remarkField').setValue(remark);  //备注
			 	
			}else{
				if(jsonData.info==-1){
					Msg.info("error",$g("检索主表出错!"));
				}else{
					Msg.info("error",$g("检索主表失败!")+jsonData.info);
				}
			}
			
			setEditDisable();
			SetFormOriginal(formPanel);
		}
	});
	
	//Ext.getCmp('INAdjMGrid').getStore().load(rowid);
	
}

function addComboData(store, id, desc) {
	var defaultData = {
		RowId : id,
		Description : desc
	};
	var r = new store.recordType(defaultData);
	store.add(r);
}

/*	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "0", "","",returnInfo);
	}
}
*/


function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		var AllBatFlag ="" // Ext.getCmp("zeroFlag").getValue();  //包含0批次 
		if (AllBatFlag==true){AllBatFlag=0}
		else {AllBatFlag=1}
		if ((group=="")||(group==null)){group=""}
		//IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", ZeroFlag, "","",returnInfo);
		IncItmBatMutiSelectWindow(item, group, App_StkTypeCode, phaLoc, "N", AllBatFlag, "","",returnInfo);
	}
}

//增加一条(明细)
function addDetailRow()
{
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true))
	{
		Msg.info('warning',$g('当前调整单已完成,禁止增加明细记录!'));
		return;
	}	
	var rowCount=INAdjMGrid.getStore().getCount();
	if(rowCount>0){
		var rowData=INAdjMGridDs.data.items[rowCount-1]
		var data=rowData.get("inci");
		if(data==""||data.length<=0)
		{Msg.info("warning",$g("已存在新建行"));
		 return;}
		}
	addNewRow();
	
}

//删除一条(明细)
function DeleteDetail()
{	
	var complete=Ext.getCmp('finshCK').getValue();
	if (complete==true)
	{
		Msg.info('warning',$g('已经完成,禁止删除明细记录!'));	return;
	}
	
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning",$g("请选择数据!"));
		return false;
	}else{
		var record = INAdjMGridDs.getAt(cell[0]);
		var rowid = record.get("adjitm");
		if(rowid!=""){
			Ext.MessageBox.confirm($g('提示'),$g('确定要删除该记录?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcst.inadjaction.csp?actiontype=deleteItem&rowid='+rowid,
							waitMsg:$g('删除中...'),
							failure: function(result, request) {
								Msg.info("error", $g("请检查网络连接!"));
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
								 	INAdjMGridDs.load({
									 	params:{start:0,limit:9999,adj:mainRowId},
										callback : function(r,options, success){
											if(success==false){
												Ext.MessageBox.alert($g("查询错误"),this.reader.jsonData.Error); 
							     			}
										}
									 });
								}else{
									var jsonInfo=jsonData.info;
									if (jsonInfo==-5){
										Msg.info("warning", $g("已存在台账记录,无法删除!"));
									}else{
										Msg.info("error", $g("删除失败!"));
									}
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
	setStatAmount();		
	}

}
/*
//科室库存项批次信息窗口关闭时回调函数
function returnInfo(record) {
	if (record == null || record == "") {
		return;
	}
	inciDr = record.get("InciDr");
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var rowData = INAdjMGrid.getStore().getAt(cell[0]);
	var INCLBWARNFLAG= record.get("InclbWarnFlag");
	if (INCLBWARNFLAG=="2"){
		Msg.info("warning", "此药品该批次状态为不可用!");
		return;
	}
	rowData.set("inci",inciDr);
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	rowData.set("batNo",record.get("BatExp"));
	rowData.set("manf",record.get("Manf"));

	rowData.set("sp",record.get("Sp"));
	rowData.set("rp",record.get("Rp"));
	rowData.set("inclb",record.get("Inclb"));
	rowData.set("spec",record.get("Spec"));
	//rowData.set("Inclbqty",record.get("InclbQty"));
	rowData.set("InclbAvaQty",record.get("AvaQty"));    //改为取可用库存
	//INAdjMGrid.startEditing(cell[0],12);
	var uom=record.get("BUomId")
	var uomDesc=record.get("BUomDesc")
	//var uom=record.get("PurUomId")
	//var uomDesc=record.get("PurUomDesc")
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set("uom",record.get("BUomId"));
	rowData.set("uomDesc",record.get("BUomDesc"));
	//rowData.set("uom",record.get("PurUomId"));
	//rowData.set("uomDesc",record.get("PurUomDesc"));
	var buom=record.get('BUomId');
	var confac=record.get('ConFac');
	var rp=record.get("Rp")
	var sp=record.get("Sp")
	puomRp=rp;
	puomSp=sp;
	buomRp=puomRp/confac;
	buomSp=puomSp/confac;
    rowData.set("confac",confac);
	rowData.set("buom",buom);
	rowData.set("rp",rp);
	rowData.set("sp",sp);
	//var BatStkQty=record.get("InclbQty");
	var BatStkQty=record.get("AvaQty");
	NewStkQty=BatStkQty*confac;
	rowData.set("InclbAvaQty",NewStkQty)
	rowData.set("rp",buomRp)
	rowData.set("sp",buomSp)
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var colIndex=GetColIndex(INAdjMGrid,"qty");
	INAdjMGrid.startEditing(cell[0], colIndex);	
}
*/

 ///yunhaibao,库存调整多选批次回调函数
function returnInfo(modifyrecord,recorditm) {
	if (modifyrecord == null || modifyrecord == "") {
		return;
	}
	var rowCount = INAdjMGrid.getStore().getCount();
	var ati=rowCount-1
	for(var i=0;i<modifyrecord.length;i++){
		if (i!=0){
			addNewRow()
		}
		inciDr = recorditm.get("InciDr");
		var rowData = INAdjMGrid.getStore().getAt(ati);
		ati=ati+1
		rowData.set("inci",inciDr);
		rowData.set("code",recorditm.get("InciCode"));
		rowData.set("desc",recorditm.get("InciDesc"));
		rowData.set("batNo",modifyrecord[i].data["BatExp"]);
		rowData.set("manf",recorditm.get("ManfName"));
		rowData.set("sp",modifyrecord[i].data["Sp"]);
		rowData.set("rp",modifyrecord[i].data["Rp"]);
		rowData.set("inclb",modifyrecord[i].data["Inclb"]);
		rowData.set("spec",recorditm.get("Spec"))
		rowData.set("Inclbqty",modifyrecord[i].data["InclbQty"]);
		rowData.set("InclbAvaQty",modifyrecord[i].data["AvaQty"]);     //改为取可用库存
		//rowData.set("InclbqtyUom",modifyrecord[i].data["InclbQtyO"]);
		rowData.set("qty",modifyrecord[i].data["ReqQty"]);
		var uom=modifyrecord[i].data["PurUomId"]
		var uomDesc=modifyrecord[i].data["PurUomDesc"]
		addComboData(ItmUomStore,uom,uomDesc);
		rowData.set("uom",modifyrecord[i].data["PurUomId"]);
		rowData.set("uomDesc",modifyrecord[i].data["PurUomDesc"]);
		var buom=modifyrecord[i].data['BUomId'];
		var confac=modifyrecord[i].data['ConFac'];
		var rp=modifyrecord[i].data["Rp"]
		var sp=modifyrecord[i].data["Sp"]
		puomRp=rp;
		puomSp=sp;
		buomRp=puomRp/confac;
		buomSp=puomSp/confac;
		rowData.set("confac",confac);
		rowData.set("buom",buom);
		rowData.set("rp",rp);
		rowData.set("sp",sp);
		var qty=modifyrecord[i].data["ReqQty"]
   		rowData.set("spAmt",Math.round(qty*rowData.get('sp')*Math.pow(10,2))/Math.pow(10,2)); 
   		rowData.set("rpAmt",Math.round(qty*rowData.get('rp')*Math.pow(10,2))/Math.pow(10,2));
		
	}
	addNewRow()
	setStatAmount();
}
//====================================================
//====================================================

//增加新行(明细)
function addNewRow() {
	//判断类组是否已经
	if(Ext.getCmp('groupField').getRawValue()==''){	 
		Ext.getCmp('groupField').setValue(null);
	}
	var scg = Ext.getCmp('groupField').getValue(); 
	if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error", $g("请选择类组!"));
		return ;
	}
	
	// 判断是否已经有添加行
	var rowCount = INAdjMGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INAdjMGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			INAdjMGrid.startEditing(INAdjMGridDs.getCount() - 1, 5);
			return;
		}
	}
	
	var record = Ext.data.Record.create([
		{
			name : 'adjitm',
			type : 'string'
		}, {
			name : 'inclb',
			type : 'string'
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
			name : 'spec',
			type : 'string'
		}, {
			name : 'manf',
			type : 'string'
		}, {
			name : 'batNo',
			type : 'string'
		}, {
			name : 'expDate',
			type : 'string'
		},{
			name : 'InclbAvaQty',
			type : 'int'
		}, {
			name : 'qty',
			type : 'int'
		}, {
			name : 'uom',
			type : 'int'
		}, {
			name : 'qtyBUOM',
			type : 'int'
		}, {
			name : 'rp',
			type : 'double'
		}, {
			name : 'rpAmt',
			type : 'double'
		}, {
			name : 'sp',
			type : 'double'
		}, {
			name : 'spAmt',
			type : 'double'
		}, {
			name : 'insti',
			type : 'stirng'
		},{
			name:'buom',
			type:'string'
		},
		{
			name:'confac',
			type:'string'	
		}
	]);
	
	var NewRecord = new record({
		adjitm:'',
		inclb:'',
		inci:'',
		code:'',
		desc:'',
		spec:'',
		manf:'',
		batNo:'',
		expDate:'',
		InclbAvaQty:'',
		qty:'',
		uom:'',
		qtyBUOM:'',
		rp:'',
		rpAmt:'',
		sp:'',
		spAmt:'',
		insti:'',
		buom:'',
		confac:''
	});
					
	INAdjMGridDs.add(NewRecord);
	INAdjMGrid.startEditing(INAdjMGridDs.getCount() - 1, 5);
	
	setEditDisable();
}

 //删除库存调整单
function deleteAdj()
{
	if (mainRowId=='')
	{
		Msg.info('warning',$g('没有任何库存调整单!'));return false;	
	}
	var complete=Ext.getCmp('finshCK').getValue();
	if (complete==true)
	{
		Msg.info('warning',$g('该单已经完成,禁止删除!'));	return false;
	}

	var rowid=mainRowId;
	Ext.MessageBox.confirm($g('提示'),$g('确定要删除该库存调整单?'),
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url : 'dhcst.inadjaction.csp?actiontype=delete&adj='+rowid,
					waitMsg:$g('删除中...'),
					failure: function(result, request) {
						Msg.info("error", $g("请检查网络连接!"));
						return false;
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success",$g('删除成功!'));
							clearPage();
							return true;
						}else{
							var jsonInfo=jsonData.info;
							if (jsonInfo==-5){
								Msg.info("warning", $g("明细已存在台账记录,无法删除!"));
							}else{
								Msg.info("error", $g("删除失败!")+jsonData.info);
							}							
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
	//Ext.getCmp('locField').setValue("");
	//Ext.getCmp('locField').setRawValue("");
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
	Ext.getCmp("rpAmount").setText($g("进价金额:"));
	Ext.getCmp("spAmount").setText($g("售价金额:"));
	INAdjMGridDs.removeAll();
	saveINAdjM.enable();
	setEditEnable();
}


//设置单据完成
function setComplete()
{
	if (INAdjMGrid.getStore().getCount()==0)
	{
		Msg.info('error',$g('没有任何明细记录!'));
		return false;
	}
	//alert(mainRowId);
	if (mainRowId=='') {Msg.info('warning',$g('没有任何单据,请先查询!'));return; }
	if (Ext.getCmp('finshCK').getValue()==true){
		Msg.info('warning',$g('当前单据已完成!'));return;
	}
	Ext.Ajax.request({
		url:INAdjMGridUrl+'?actiontype=setComplete'+"&adj="+mainRowId,
		failure:function(){
			Msg.info('error',$g('请检查网络!'));return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.getCmp('finshCK').setValue(true);
				saveINAdjM.disable();
				Msg.info('success',$g('设置成功！'));
				
			}else{
				Msg.info("error", $g("设置失败!")+jsonData.info);
				return false;
			}			
		}
	
	});
}

//取消完成
function cancelComplete()
{
	if (mainRowId=='') {Msg.info('warning',$g('没有任何单据,请先查询!'));return; }
	if (Ext.getCmp('finshCK').getValue()==false){Msg.info('error',$g('该单据尚未完成!'));return;}	
	Ext.Ajax.request({
		url:INAdjMGridUrl+'?actiontype='+'cancelComplete'+'&adj='+mainRowId,
		failure:function(){Msg.info('error',$g('请检查网络!'));return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.getCmp('finshCK').setValue(false);
				Msg.info('success',$g('设置成功！'));
				saveINAdjM.enable();
			}else{
				if (jsonData.info==-3){
					Msg.info("warning", $g("该单据已审核,无法取消完成!"));
				}else{
					Msg.info("error", $g("设置失败!")+jsonData.info);
				}
				return;
			}		
		}
	});

}
function setGridEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('adjQty');	        
	grid.getColumnModel().setEditable(colId,b);
	
}
function setStatAmount()
{
	var rpAmt=0;
	var spAmt=0;
	var count = INAdjMGrid.getStore().getCount(); 
	for (var i=0; i<count; i++)
	{
		var rowData = INAdjMGridDs.getAt(i);
		rpAmt=rpAmt+rowData.get("rpAmt")*1;
		spAmt=spAmt+rowData.get("spAmt")*1;
		rpAmt=rpAmt;
		spAmt=spAmt;
	}
	rpText=$g("进价合计:  ")+FormatGridRpAmount(rpAmt)+$g("  元");
	spText=$g("售价合计:  ")+FormatGridSpAmount(spAmt)+$g("  元");
	Ext.getCmp("rpAmount").setText(rpText);
	Ext.getCmp("spAmount").setText(spText);	
}
///处理JS浮点型数据相加，产生多位小数问题
function FmtAmt(price,pos)
{
	var price=Math.round(price*Math.pow(10,pos))/Math.pow(10,pos);
	return price;
}
/*
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return realkey;
}

function handleMemo(memo,token) 
{
	var xx='';
 	var ss=memo.split(token);
 	for (var i=0;i<ss.length;i++)
 	{
 		xx=xx+ss[i]+'\n\r';
 	}
	return xx	
}
*/
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}	
	
	var panel = new Ext.Panel({
		title:$g('库存调整制单'),
		activeTab:0,
		layout:'fit',
		region:'north',
		height:DHCSTFormStyle.FrmHeight(3),
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,INAdjMGrid],
		renderTo:'mainPanel'
	});
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
