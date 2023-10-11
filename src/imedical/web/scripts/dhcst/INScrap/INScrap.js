// 名称:库存报损制单
// 编写日期:2012-08-14
// 

var deptId = 0;
var deptName = "";
var purId = "";
var purNo = "";
var mainRowId="";
var reasonId = "";
var inscrapUrl='dhcst.inscrapaction.csp';
var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gParam = GetParam(); 

function GetParam(){
	var GetParamStr=tkMakeServerCall("web.DHCST.DHCINScrap","GetParamProp",groupId,CtLocId,userId)
	var gParamArr=GetParamStr.split('^');
	return gParamArr;
}


//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";
var colArr=[];

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('科室'),
	//width:200,
	listWidth:210,
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


//=========================库存报损制单=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
	//width:200,
	listWidth:200,
    allowBlank:false,
	fieldLabel:$g('制单日期'),
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
	//width:200,
    allowBlank:false,
	fieldLabel:$g('制单时间'),
	//format:'HH-MM-SS',
	anchor:'90%',
	//value:new Time(),
	disabled:true
});

var userField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:$g('制单人'),
	width:200,
	anchor:'90%',
	disabled:true
});

var inscrapNumField = new Ext.form.TextField({
	id:'inscrapNumField',
	fieldLabel:$g('报损单号'),
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:$g('报损单号...'),
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// 药品类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:$g('类组'),
	//width:200,
	anchor:'90%',
	listWidth:200,
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:CtLocId,
	UserId:UserId
});

// 报损原因
var causeField = new Ext.form.ComboBox({
	id:'causeField',
	fieldLabel:$g('报损原因'),
	//width:200,
	anchor:'90%',
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapurnStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:$g('报损原因...'),
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:0,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
ReasonForAdjustMentStore.load();
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
		
function GetAmount(){
	var RpAmt=0
	var SpAmt=0
	var Count = INScrapMGrid.getStore().getCount();
	for (var i = 0; i < Count; i++) {
		var rowData = INScrapMGridDs.getAt(i);
        if (rowData==undefined){
            continue;
        }
		var ScrapQty = rowData.get("qty");
		var Rp = rowData.get("rp");
		var Sp = rowData.get("sp");
		var RpAmt1=Number(Rp).mul(ScrapQty)
		var SpAmt1=Number(Sp).mul(ScrapQty);
	    RpAmt=accAdd(Number(RpAmt),Number(RpAmt1));
	    SpAmt=accAdd(Number(SpAmt),Number(SpAmt1));
	    //RpAmt=RpAmt+RpAmt1;
	    //SpAmt=SpAmt+SpAmt1;
		}
	RpAmt=FormatGridRpAmount(RpAmt);
	SpAmt=FormatGridSpAmount(SpAmt);
	Count=$g("当前条数:")+" "+Count	
	RpAmt=$g("进价合计:")+" "+RpAmt+" "+$g("元")
	SpAmt=$g("售价合计:")+" "+SpAmt+" "+$g("元")
	Ext.getCmp("NumAmount").setValue(Count)	
	Ext.getCmp("RpAmount").setValue(RpAmt)	
	Ext.getCmp("SpAmount").setValue(SpAmt)	
	}
var AddDetailBT=new Ext.Button({
	text:$g('增加一条'),
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{	
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
	}
});


var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:$g('备注'),
	allowBlank:true,
	//width:200,
	height:50,
	emptyText:$g('备注...'),
	anchor:'90%',
	selectOnFocus:true
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	boxLabel:$g('完成'),
	disabled:true,
	allowBlank:true,
	listeners:{
		'check':function(chk,v){
			//alert('check');
			var grid=Ext.getCmp('INScrapMGrid');
			setGridEditable(grid,!v);
		}	
	}
});

var auditCK = new Ext.form.Checkbox({
	id: 'auditCK',
	boxLabel:$g('审核'),
	disabled:true,
	allowBlank:true
});

var INScrapMGrid="";

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
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	var record = INScrapMGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	
	var InciDr=inclb.split("||")[0];
	if (InciDr=='') return false;
	else
	{
		ItmUomStore.baseParams={ItmRowid:InciDr};
	}
	
});

//单位展开事件


CTUom.on('expand', function(combo) {

	combo.store.removeAll();
	combo.store.load();	

});

//单位变换事件

CTUom.on('select', function(combo) {
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	var record = INScrapMGrid.getStore().getAt(cell[0]);
	
	var value = combo.getValue();        //目前选择的单位id
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //大单位到小单位的转换关系		
	var Uom = record.get("uom");    //目前显示的报损单位
	var BatStkQty=record.get("inclbQty");
	var AvaStkQty=record.get("avalbQty");
	var Rp=record.get("rp");
	var Sp=record.get("sp");
	var NewStkQty=BatStkQty;
	var NewAvaStkQty=AvaStkQty;
	var NewRp=Rp
	var NewSp=Sp
	var qty=record.get("qty");
	var inclb =record.get("inclb");
	if(value!=Uom){
		var Inclb=record.get("inclb");
		var QtyAndPriceInfo = tkMakeServerCall("web.DHCST.Util.DrugUtil","GetIncilbInfo",Inclb,value)
		if (QtyAndPriceInfo=="") return;
		var InfoArr = QtyAndPriceInfo.split("^")
		record.set("sp", InfoArr[0] ); 
		record.set("rp", InfoArr[1] );
		record.set("inclbQty", InfoArr[2]);
		record.set("avalbQty", InfoArr[4]);
		
		/*
		if(value==BUom){
			NewStkQty=BatStkQty*ConFac;
			NewAvaStkQty=AvaStkQty*ConFac;
			NewRp=Rp/ConFac;
			NewSp=Sp/ConFac;
		}else{
			NewStkQty=BatStkQty/ConFac;
			NewAvaStkQty=AvaStkQty/ConFac;
			NewRp=Rp*ConFac;
			NewSp=Sp*ConFac;
		}
		record.set("inclbQty",NewStkQty)
		record.set("avalbQty",NewAvaStkQty)
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
   }	
       //var ingri=record.get("ingri");
	record.set("uom", combo.getValue());
	GetAmount();	
	//var Uom=record.get("uom"); 
	//SetIngriPrice(record,ingri,Uom);


	
});
//====================================================
//====================================================



//配置数据源
var INScrapMGridUrl = 'dhcst.inscrapaction.csp';
var INScrapMGridProxy= new Ext.data.HttpProxy({url:INScrapMGridUrl+'?actiontype=queryItem',method:'GET'});
var INScrapMGridDs = new Ext.data.Store({
	proxy:INScrapMGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'inspi'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'pp'},
		{name:'ppAmt'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'inclbQty'},
		{name:'avalbQty'},
		{name:'buom'},
		{name:'confac'}
	]),
    remoteSort:false
});

//模型
var INScrapMGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'inspi',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"IncRowid",
        dataIndex:'inclb',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"incirowid",
        dataIndex:'inci',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:$g("代码"),
        dataIndex:'code',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'desc',
        id:'desc',
        width:300,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
            selectOnFocus : true,
			listeners:{
				specialKey:function(field, e) {
					setKeyEventSort(INScrapMGrid,colArr)
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp('groupField').getValue());
					}
				}
			}
        })
    },{
        header:$g("批次~效期"),
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("生产企业"),
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("批次库存"),
        dataIndex:'inclbQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("批次可用库存"),
        dataIndex:'avalbQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("报损数量"),
        dataIndex:'qty',
        id:'adjQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.ux.NumberField({
			id:'qtyField',
			formatType:'FmtSQ',
            allowBlank:false,
            allowNegative :false,
            selectOnFocus : true,
			listeners:{				
				specialKey:function(field, e) {
					if (setKeyEventSort(INScrapMGrid,colArr,false)){
						var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
						var rowData = INScrapMGridDs.getAt(cell[0]);
						var col=GetColIndex(INScrapMGrid,'qty');
						var newqty=field.getValue();
						
						var buomId=rowData.get("buom")
	                    var uom=rowData.get("uom")
	                    var buomQty=newqty
	                    var fac=rowData.get("confac")
						
						if(newqty>rowData.get('inclbQty')){
							Msg.info("warning",$g("报损数量不能大于批次库存!"));
							INScrapMGrid.startEditing(cell[0], col);
							return;
						}
						else if(newqty>rowData.get('avalbQty')){
							Msg.info("warning",$g("报损数量不能大于批次可用库存!"));			
							INScrapMGrid.startEditing(cell[0], col);
							return;
						}else if(gParam[0]!="Y")  ////新增报损数量是否允许小数判断 2021-04-17 yangsj 1 允许录入小数
                		{
	                		if(buomId!=uom)
		                    {
		                        buomQty=Number(fac).mul(newqty);
		                    }
		                    if((buomQty.toString()).indexOf(".")>=0)
		                    {
			                    Msg.info("warning", $g(" 报损数量换算成基本单位之后存在小数，不能调整！请核对库存调整配置!：报损数量换算为基本单位是否允许小数"));
			                    return;
		                    }
                		}else{
							//使页面的列中保留2位小数
							//小数位数变量
							//var pos = 2;
							//rowData.set("spAmt",Math.round(newqty*rowData.get('sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							//rowData.set("rpAmt",Math.round(newqty*rowData.get('rp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							//rowData.set("ppAmt",Math.round(newqty*rowData.get('pp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							var newSpAmt=newqty*rowData.get('sp');
							var newRpAmt=newqty*rowData.get('rp');
							var newPpAmt=newqty*rowData.get('pp');
							newSpAmt=1*FormatGridSpAmount(newSpAmt);
							newRpAmt=1*FormatGridRpAmount(newRpAmt);
							newPpAmt=1*FormatGridPpAmount(newPpAmt);
							rowData.set("spAmt",newSpAmt);
							rowData.set("rpAmt",newRpAmt);
							rowData.set("ppAmt",newPpAmt);
							if(setEnterSort(INScrapMGrid,colArr)){
									addNewRow();
							}
							GetAmount();
						}

					}
					setKeyEventSort(INScrapMGrid,colArr) 
                }
			}
        })
    },{
        header:$g("单位"),
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
					var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(INScrapMGrid,"uom");
					INScrapMGrid.startEditing(cell[0], colIndex);									
				}
			}
		}
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
INScrapMGridCm.defaultSortable = true;

var addINScrapM = new Ext.Toolbar.Button({
	text:$g('新建'),
    tooltip:$g('新建'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		newInscrap();
		//if (isDataChanged()){
		//	Ext.Msg.show({
		//		title:'提示',
		//		msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
		//		buttons: Ext.Msg.YESNO,
		//		fn: function(btn){
		//	   		if (btn=='yes') {newInscrap();}
		//	   }

		//	})		
		//}
		//else
		//{
		//	newInscrap();
		//}
	}
});
function newInscrap()
{
		mainRowId='';
		clearPage();
		addNewRow();
	}
var findINScrapM = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//clearPage();
		find();
		//if (isDataChanged())
		//{
		//	{
		//		Ext.Msg.show({
		//			title:'提示',
		//			msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
		//			buttons: Ext.Msg.YESNO,
		//			fn: function(btn){
		//		   		if (btn=='yes') {clearPage();find();}
		//		   }
	
		//		})
			
		//	}	
		//}
		//else{
		//	find();
			//if (Ext.getCmp('scrapWinFind'))
			//{Ext.getCmp('scrapWinFind').show();}
			//else
			//{FindINScrap(INScrapMGridDs,inscrapNumField,finshCK,auditCK,mainRowId,locField,dateField,reasonId,addINScrapM,selectInscrap);}
		//}
		
	}
});
function find()
{
		if (Ext.getCmp('scrapWinFind'))
		{Ext.getCmp('scrapWinFind').show();}
		else
		{FindINScrap(INScrapMGridDs,inscrapNumField,finshCK,auditCK,mainRowId,locField,dateField,reasonId,addINScrapM,selectInscrap);}
		
	}
	
var clearINScpM = new Ext.Toolbar.Button({
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

var saveINScrapM = new Ext.Toolbar.Button({
	text:$g('保存'),
    tooltip:$g('保存'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()==true){
			// 保存报损单
			save();
		}		
	}	
});


var deleteINScrapM = new Ext.Toolbar.Button({
	text:$g('删除'),
    tooltip:$g('删除'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var rowid=mainRowId;
		if(rowid!=""){
			Ext.MessageBox.confirm($g('提示'),$g('确定要删除当前报损单?'),function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url : 'dhcst.inscrapaction.csp?actiontype=delete&inscrap='+mainRowId,
						waitMsg:$g('删除中...'),
						failure: function(result, request) {
							Msg.info("error", $g("请检查网络连接!"));
							return false;
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", $g("删除成功!"));
								clearPage();
								//INScrapMGridDs.load({params:{inscrap:mainRowId}});
							}else{
								var ret=jsonData.info
								if(ret==-1){
									Msg.info("error", $g("报损单已经完成，不能删除!"));
								}else if(ret==-2){
									Msg.info("error", $g("报损单已经审核，不能删除!"));
								}else{
									Msg.info("error", $g("删除失败!"+ret));
								}
								return false;
							}
						},
						scope: this
					});
				}else{
					return false;
				}
			})
		}else{
			Msg.info('warning',$g('没有报损单，请先查询。'));
			return;
		}
	}
});

var finshScp = new Ext.Toolbar.Button({
	id:'finshScp',
	text:$g('完成'),
    tooltip:$g('完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var rowCount = INScrapMGrid.getStore().getCount();
		if(rowCount==0)
		{
			Msg.info('error',$g('没有任何明细记录!'));
			return false;
		}
		var finshCK = Ext.getCmp('finshCK').getValue();
        var mod = isDataChanged();
        if (mod && (!finshCK)) {
            Ext.Msg.confirm($g('提示'), $g('数据已发生改变,是否需要保存后完成?'),
                function(btn) {
                    if (btn == 'yes') {
                        return;
                    } else {
                        Complete();
                    }

                }, this);
        } else {
            Complete();
        }		
	}
});
    
     // 完成
     
	function Complete(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", $g("报损单为空!请先查询"));
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==true)	{	return;	}
			
			Ext.MessageBox.confirm($g('提示'),$g('确定要完成该报损单吗?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inscrapaction.csp?actiontype=finish&InscpId='+mainRowId,
							waitMsg:$g('更新中...'),
							failure: function(result, request) {
								Msg.info("error", $g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", $g("报损单完成!"));
									selectInscrap(mainRowId);
								}else{
									if(jsonData.info==-1){
										Msg.info("error", $g("报损单已经完成!"));
										return false;
									}
									if(jsonData.info==-3){
										Msg.info("error", $g("操作失败!"));
										return false;
									}
								}
							},
							scope: this
						});
					}else{
						return false;
					}
				})
			}
	}
var noFinshScp = new Ext.Toolbar.Button({
	text:$g('取消完成'),
    tooltip:$g('取消完成'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", $g("报损单为空!请先查询"));
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==false)	{Msg.info("error", $g("该报损单尚未完成!"));return;	}
			Ext.MessageBox.confirm($g('提示'),$g('确定要取消完成该报损单吗?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inscrapaction.csp?actiontype=noFinish&InscpId='+mainRowId,
							waitMsg:$g('处理中...'),
							failure: function(result, request) {
								Msg.info("error", $g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", $g("成功取消报损单完成状态!"));
									selectInscrap(mainRowId);
									
								}else{
									if(jsonData.info==-1){
										Msg.info("error", $g("报损单尚未完成!"));
										return false;
									}
									if(jsonData.info==-2){
										Msg.info("error", $g("报损单已经审核，不能取消完成!"));
										return false;
									}
									if(jsonData.info==-3){
										Msg.info("error", $g("操作失败!"));
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
	}
});

var printScp = new Ext.Toolbar.Button({
	text : $g('打印'),
	tooltip : $g('打印报损单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId ==null || mainRowId=="") {
			Msg.info("warning", $g("没有需要打印的报损单!"));
			return;
		}
		PrintINScrap(mainRowId);
	}
});


var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	layout:'fit',
	labelAlign : 'right',
	frame : true,
    tbar:[findINScrapM,'-',clearINScpM,'-',addINScrapM,'-',saveINScrapM,'-',finshScp,'-',noFinshScp,'-',printScp,'-',deleteINScrapM],
	items : [{
		xtype : 'fieldset',
		title : $g('报损单信息'),
		//defaultWidth:200,
		autoHeight : true,
		autoScroll:true,
		style:DHCSTFormStyle.FrmPaddingV,
		//layout:'fit',
		items : [{
			layout : 'column',
			autoScroll:true,
			items : [{
				columnWidth : .263,
				labelWidth: 60,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [inscrapNumField,locField,causeField]
			}, {
				columnWidth : .25,
				labelWidth: 60,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [dateField,timeField,userField]
			}, {
				columnWidth : .25,
				labelWidth: 60,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [groupField,remarkField]
			}, {
				columnWidth : .2,
				labelWidth: 10,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [finshCK,auditCK]
			}]
		}]
	}]
 
});
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('列设置'),
    tooltip:$g('列设置'),
    iconCls:'page_gear',
	handler:function(){
		GridColSet(INScrapMGrid,"DHCSTINSCRAP");
	}
});
//表格
INScrapMGrid = new Ext.grid.EditorGridPanel({
	title:$g('明细记录'),
	store:INScrapMGridDs,
	id:'INScrapMGrid',
	cm:INScrapMGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT]},
	clicksToEdit:1,
	bbar:new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]})
});
INScrapMGrid.getView().on('refresh',function(Grid){
	GetAmount()
	})

		//添加右键菜单
		
		
INScrapMGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
var rightClick = new Ext.menu.Menu({ 
	id:'rightClickCont', 
	items: [ 
		{ 
			id: 'mnuDelete', 
			handler: DeleteDetail, 
			text: $g('删除' )
		}
	] 
}); 
		
//右键菜单代码关键部分 
function rightClickFn(grid,rowindex,e){ 
	e.preventDefault(); 
	rightClick.showAt(e.getXY()); 
}

//=========================库存报损制单=============================	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "1", "","",returnInfo);
			
	}
}
		
function addNewRow() {

	//判断类组是否已经
	if  (Ext.getCmp('groupField').getRawValue()=='')
	{	 Ext.getCmp('groupField').setValue(null);}

	var scg = Ext.getCmp('groupField').getValue(); 
	if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error", $g("请选择类组!"));
		return ;
	}
	// 判断是否已经有添加行
	var rowCount = INScrapMGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INScrapMGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			var col=GetColIndex(INScrapMGrid,'desc');
			INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, col);
			return;
		}
	}
	var NewRecord=CreateRecordInstance(INScrapMGridDs.fields);				
	INScrapMGridDs.add(NewRecord);
	var col=GetColIndex(INScrapMGrid,'desc');
	INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, col);
	setEditDisable();
	GetAmount();
}		

function clearPage()
{
	mainRowId="";
	Ext.getCmp('inscrapNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('adjUserField').setValue("");		
	Ext.getCmp('causeField').setValue("");
	Ext.getCmp('causeField').setRawValue("");
	Ext.getCmp('remarkField').setValue("");
	
	Ext.getCmp('finshCK').setValue("");
	Ext.getCmp('auditCK').setValue("");
	Ext.getCmp("NumAmount").setValue("");
	Ext.getCmp("RpAmount").setValue("");
	Ext.getCmp("SpAmount").setValue("");
	
	INScrapMGridDs.removeAll();
	
	this.deleteINScrapM.enable();
	this.saveINScrapM.enable();
	
	setEditEnable();
}
function addComboData(store, id, desc) {
	var defaultData = {
		RowId : id,
		Description : desc
	};
	var r = new store.recordType(defaultData);
	store.add(r);
}
//科室库存项批次信息窗口关闭时回调函数
function returnInfo(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	var rowData = INScrapMGrid.getStore().getAt(cell[0]);
	var INCLBWARNFLAG= record.get("InclbWarnFlag");
	if (INCLBWARNFLAG=="2"){
		Msg.info("warning", $g("此药品该批次状态为不可用!"));
		return;
	}
	inciDr = record.get("InciDr");
	rowData.set("inci",inciDr);
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	rowData.set("batNo",record.get("BatExp"));
	rowData.set("manf",record.get("Manf"));
	var uom=record.get("PurUomId")
	var uomDesc=record.get("PurUomDesc")
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set("uom",record.get("PurUomId"));
	rowData.set("uomDesc",record.get("PurUomDesc"));
	rowData.set("sp",record.get("Sp"));
	rowData.set("rp",record.get("Rp"));
	rowData.set("inclbQty",record.get("InclbQty"));
	rowData.set("avalbQty",record.get("AvaQty"));
	rowData.set("inclb",record.get("Inclb"));
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
	var qty=rowData.get("qty")
	rowData.set("spAmt",Math.round(qty*rowData.get('sp')*Math.pow(10,2))/Math.pow(10,2)); 
	rowData.set("rpAmt",Math.round(qty*rowData.get('rp')*Math.pow(10,2))/Math.pow(10,2));
	if(setEnterSort(INScrapMGrid,colArr)){
			addNewRow();
	}
}
function CheckDataBeforeSave(){
	var user = UserId;
	var locId = Ext.getCmp('locField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error",$g("请选择供应科室!"));
		return false;
	}
	var scg = Ext.getCmp('groupField').getValue();
	if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error",$g("请选择类组!"));
		return false;
	}
	var scpReason = Ext.getCmp('causeField').getValue();
	if((scpReason=="")||(scpReason==null)){
		Msg.info("error",$g("请选择报损原因!"));
		return false;
	}
	
	//检查是否有明细(适用于新建的单据)
	if (mainRowId==''){
		var ListDetail="";
		var rowCnt=0;
		var rowCount = INScrapMGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				if (inclb=='') continue;
				var uom = rowData.get("uom");
				if (uom=='') continue;
				var qty = rowData.get("qty");
				if (qty=='') {
					Msg.info("warning",$g("第")+(i+1)+$g("行报损数量为空!"));
					return;
				}
				rowCnt++;
			}
		}
		if (rowCnt==0){Msg.info('warning',$g('没有任何明细!禁止保存.'));return false;}
		// 判断重复输入药品
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = INScrapMGridDs.getAt(i).get("inclb");;
				var item_j = INScrapMGridDs.getAt(j).get("inclb");;
				var itemdesc=INScrapMGridDs.getAt(i).get("desc");;
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
	}
	
	return true;
}
// 变换行颜色
function changeBgColor(row, color) {
	INScrapMGrid.getView().getRow(row).style.backgroundColor = color;
}
function save(){
	var scpUser = UserId;
	var scpInst = "";
	var scpNo = Ext.getCmp("inscrapNumField").getValue();
	var scpLoc = Ext.getCmp('locField').getValue();
	var scpComp = (Ext.getCmp('finshCK').getValue()==true?'Y':'N');
	var scpState = (Ext.getCmp('auditCK').getValue()==true?'Y':'N');
	var scpReason = Ext.getCmp('causeField').getValue();
	var scpScg = Ext.getCmp('groupField').getValue();
	var remark = Ext.getCmp('remarkField').getValue();  //备注
	var inscrapno = Ext.getCmp('inscrapNumField').getValue();
	
	remark=remark.replace(/\r\n/g,xMemoDelim());
	
	var tmpData = scpUser+"^"+scpLoc+"^"+scpComp+"^"+scpReason+"^"+scpScg+"^"+remark+"^"+inscrapno;
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INScrapMGrid.getStore().getCount();
		if(rowCount==0)
		{
			Msg.info('error',$g('没有任何明细记录!'));
			return false;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				if (inclb==""){
					continue;
				}
				var uom = rowData.get("uom");
				var qty = rowData.get("qty");
				var inclbQty=rowData.get("inclbQty");
				var avalbQty=rowData.get("avalbQty");
				///if(qty>inclbQty){Msg.info("warning","报损数量不能大于批次库存");
				///								return }
				if(qty>avalbQty){Msg.info("warning",$g("第")+(i+1)+$g("行报损数量不能大于批次可用库存"));
												return }
				if(qty<=0){Msg.info("warning",$g("第")+(i+1)+$g("行报损数量必须大于0"));return }
												
				var buomId=rowData.get("buom")
	            var buomQty=qty
	            var fac=rowData.get("confac")
				if(gParam[0]!="Y")  ////新增报损数量是否允许小数判断 2020-02-20 yangsj 1 允许录入小数
	    		{
	        		if(buomId!=uom)
	                {
	                    buomQty=Number(fac).mul(qty);
	                }
	                if((buomQty.toString()).indexOf(".")>=0)
	                {
	                    Msg.info("warning", rowData.get("desc")+$g("报损数量换算成基本单位之后存在小数，不能调整！请核对库存调整配置：报损数量换算为基本单位是否允许小数!"));
	                    return;
	                }
	    		}								
				
				var Rp = rowData.get("rp");
				var rpAmt = rowData.get("rpAmt");
				var Sp = rowData.get("sp");
				var spAmt =rowData.get("spAmt");
				var Pp = rowData.get("pp");
				var ppAmt = rowData.get("ppAmt");
				var rowStr = Inspi + "^" + inclb + "^"	+ uom + "^" + qty + "^"	+ Rp + "^" + rpAmt + "^"  + Pp + "^" + ppAmt + "^" + Sp+ "^" + spAmt
				if(ListDetail==""){
					ListDetail=rowStr;
				}
				else{
					ListDetail=ListDetail+ xRowDelim() + rowStr;
				}
			}
		}
		
		Ext.Ajax.request({
			//url: INScrapMGridUrl+'?actiontype=save&inscrap='+mainRowId+'&MainInfo='+tmpData+'&ListDetail='+ListDetail,
			url: INScrapMGridUrl+'?actiontype=save',
			params: {inscrap:mainRowId,MainInfo:tmpData,ListDetail:ListDetail},
			method : 'POST',
			waitMsg : $g('处理中...'),
			failure: function(result,request) {
				Msg.info("error",$g("请检查网络连接!"));
			},
			success: function(result,request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );			
				if (jsonData.success=='true') {
					Msg.info("success",$g("保存成功!"));
					mainRowId = jsonData.info;
					
					selectInscrap(mainRowId);
				}
				if(jsonData.success=='false'){
					var ret=jsonData.info;
					if(ret==-8){
						Msg.info("error", $g("报损单已经完成!"));
					}else if(ret==-9){
						Msg.info("error", $g("报损单已经审核!"));
					}else{
						Msg.info("error",$g("保存失败!")+ret);
					}
				}
			},
			scope: this
		});
	}
   
	
		
}

		
// 显示报损单明细数据
function getDetail(InscpRowid) {

	if (InscpRowid == null || InscpRowid.length <= 0 || InscpRowid <= 0) {
		return;
	}

	INScrapMGridDs.removeAll();
	INScrapMGridDs.load({
		params:{start:0,limit:999,inscrap:InscpRowid},
		callback : function(r,options, success){
			if(success==false){
				Ext.MessageBox.alert($g("查询错误"),this.reader.jsonData.Error); 
 			}
		}		
	});
	

	// 变更按钮是否可用
	//查询^清除^新增^保存^删除^完成^取消完成
	//var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	//i/f(inGrFlag==true){
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
		
		// 删除选中行药品
		 
function DeleteDetail() {
	// 判断报损单是否已完成
	var CmpFlag = Ext.getCmp("finshCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", $g("报损单已完成,禁止删除明细记录!"));
		return;
	}
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", $g("请选择数据!"));
		return;
	}
	// 选中行
	var row = cell[0];
	var record = INScrapMGrid.getStore().getAt(row);
	var Inspi = record.get("inspi");
	if (Inspi == "" ) {
		INScrapMGrid.getStore().remove(record);
		INScrapMGrid.getView().refresh();
		GetAmount();
		if (INScrapMGrid.getStore().getCount()==0){
			setEditEnable();
		}			
	} else {
		Ext.MessageBox.show({
			title : $g('提示'),
			msg : $g('是否确定删除该药品信息?'),
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});
	}
	

}
		
		 // 删除提示
		
function showResult(btn) {
	if (btn == "yes") {
		var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = INScrapMGrid.getStore().getAt(row);
		var Inspi = record.get("inspi");

		// 删除该行数据
		var url = DictUrl+ "inscrapaction.csp?actiontype=deldetail&RowId=" + Inspi;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : $g('删除中...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", $g("删除成功!"));
					INScrapMGrid.getStore().remove(record);
					INScrapMGrid.getView().refresh();
					GetAmount();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", $g("报损单已经完成，不能删除!"));
					}else if(ret==-2){
						Msg.info("error", $g("报损单已经审核，不能删除!"));
					}else{
						Msg.info("error", $g("删除失败,请查看错误日志!"));
					}
				}
				if (INScrapMGrid.getStore().getCount()==0){
					setEditEnable();
				}	
			},
			scope : this
		});
	}
}


//增加一条(明细)
function addDetailRow()
{
	
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true))
	{
		Msg.info('warning',$g('当前报损单已完成,禁止增加明细记录!'));
		return;
	}
	var rowCount =INScrapMGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = INScrapMGridDs.data.items[rowCount - 1];
		var data=rowData.get("inci")
		if(data=="" || data.length<=0){
		    Msg.info("warning",$g("已存在新建行")) ;
		    return;	  }
		}	
	addNewRow();
	
}
//取出报损单主表的数据，并填充到组件上
function selectInscrap(rowid)
{
	mainRowId=rowid;
	Ext.Ajax.request({
		url:inscrapUrl+'?actiontype=Select'+'&InscpId='+rowid,
		failure:function(){},
		success:function(result,request){
			
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.results>0) {
				data=jsonData.rows  ;
			 	var loc=data[0]['INSCP_CTLOC_DR']   ;			
			 	var locDesc=data[0]['locDesc']   ;
			 	var scg=data[0]['INSCP_SCG_DR'] ;
			 	var reason=data[0]['INSCP_Reason'];
			 	var reasonDesc=data[0]['reason'];
			 	addComboData(Ext.getCmp("locField").getStore(),loc,locDesc);
			 	Ext.getCmp('locField').setValue(loc);
			 	var inscrapNo=data[0]['INSCP_NO']  ;
			 	var adjDate=data[0]['INSCP_Date'];
			 	var adjTime=data[0]['INSCP_Time'] ;
			 	var completeFlag=data[0]['INSCP_Completed'] ; 
			 	var auditFlag=data[0]['INSCP_ChkFlag'] ;
			 	var remark=data[0]['INSCP_Remarks']  ;
			 	var userName=data[0]['userName'] ;
			 	var auditUserName=data[0]['INSCP_ChkUser_DR'] ;
			 	var chkDate=data[0]['INSCP_ChkDate'];
			 	var chkTime=data[0]['INSCP_ChkTime'];
			
				inscrapNumField.setValue(inscrapNo);
				locField.setValue(loc);
				//locField.setRawValue(locDesc);
				dateField.setValue(adjDate);
				timeField.setValue(adjTime);
				userField.setValue(userName);
				
				if(completeFlag=='Y'){
					finshCK.setValue(true);
					saveINScrapM.disable();
					deleteINScrapM.disable();
					finshScp.disable();
				}else{
					finshCK.setValue(false);
					saveINScrapM.enable();
					deleteINScrapM.enable();
					finshScp.enable();
				}
				if(auditFlag=='Y'){
					auditCK.setValue(true);
				
				}else{
					auditCK.setValue(false);
				}
				
				causeField.setValue(reason);
				causeField.setRawValue(reasonDesc);
				remark=handleMemo(remark,xMemoDelim());
				remarkField.setValue(remark);	
				groupField.setValue(scg);
			
				//检索明细
				getDetail(mainRowId);
				GetAmount();
				
			}	
		
		if (mainRowId>0)
		{
			setEditDisable();
			SetFormOriginal(formPanel);
		}
		}
	})


}
function setGridEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('adjQty');	        
	grid.getColumnModel().setEditable(colId,b);
	
}


//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}	
	var panel = new Ext.Panel({
		title:$g('库存报损制单'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(3),
		layout:'fit',
		//frame:true,
		items:[formPanel] //
		//autoScroll:true
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,INScrapMGrid], //
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INScrapMGrid,"DHCSTINSCRAP");   //根据自定义列设置重新配置列
	colArr=sortColoumByEnterSort(INScrapMGrid); //将回车的调整顺序初始化好
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
	var count1= INScrapMGrid.getStore().getCount();
	//看主表数据是否有修改
	//修改为主表有修改且子表有数据时进行提示
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	};
	if (changed) return changed;
	//看明细数据是否有修改
	var count= INScrapMGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INScrapMGrid.getStore().getAt(index);	
				//新增或数据发生变化时执行下述操作
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}	