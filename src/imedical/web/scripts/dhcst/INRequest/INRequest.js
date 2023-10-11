// 名称:出库请求
// 编写日期:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var colArr = [];
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//=========================页面跳转变量=================================
	var abConsumeReq = reqByabConsume;
	Ext.Ajax.timeout = 900000;
	//=========================定义全局变量=================================
	var InRequestId = "";
	var CtLocId = session['LOGON.CTLOCID'];
	var UserId = session['LOGON.USERID'];
	
	//wyx add参数配置 2014-01-22
	if(gParam.length<1){
		GetParam();  //初始化参数配置
		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置 wyx 公共变量取类组设置gParamCommon[9]

	}
	//var arr = window.status.split(":");
	//var length = arr.length;
	var URL = 'dhcst.inrequestaction.csp';
	var strParam = "";
	var req = ""; //定义全局变量:主表rowid
	var statu = "N"; //定义全局变量:完成状态(默认状态:N)
	
	var requestNnmber = new Ext.form.TextField({
		id:'requestNnmber',
		fieldLabel:$g('请求单号'),
		listWidth:150,
		anchor:'90%',
		selectOnFocus:true,
		disabled:true
	});
	
	
	// 请求部门
	var LocField= new Ext.ux.LocComboBox({
		fieldLabel : $g('请求部门'),
		id : 'LocField',
		name : 'LocField',
		anchor:'90%',
		emptyText : $g('请求部门...'),
		groupId:gGroupId,
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
	LocField.on('select', function(e) {
	    Ext.getCmp("supplyLocField").setValue("");
	    Ext.getCmp("supplyLocField").setRawValue("");
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
		fieldLabel:$g('制单日期'),
		anchor:'90%',
		value:new Date(),
		disabled:true
	});
	
	var timeField=new Ext.form.TextField({
		id:'timeField',
		disabled:true,
		anchor:'90%',
		fieldLabel:$g('制单时间')
	});
	var userField=new Ext.form.TextField({
		id:'userField',
		disabled:true,
		anchor:'90%',
		fieldLabel:$g('制单人')
	});
	
	var supplyLocField = new Ext.ux.LocComboBox({
		id:'supplyLocField',
		fieldLabel:$g('供给部门'),
		anchor:'90%',
		listWidth:210,
		emptyText:$g('供给部门...'),
		//groupId:gGroupId,
		defaultLoc:{},
		relid:Ext.getCmp("LocField").getValue(),
		protype:'TR',
		params : {relid:'LocField'}
	});
	
	supplyLocField.on("select",function(cmb,rec,id ){
	    add.disable();
	});
	
	var remark = new Ext.form.TextArea({
		id:'remark',
		fieldLabel:$g('备注'),
		anchor:'90%',
		height:100,
		selectOnFocus:true
	});
		
	var completeCK = new Ext.form.Checkbox({
		id: 'completeCK',
		fieldLabel:$g('完成'),
		anchor:'90%',
		disabled:true,
		allowBlank:true
	});
	
	var TypeStore=new Ext.data.SimpleStore({
		fields:['RowId','Description'],
		data:[['O',$g('请领单')],['C',$g('申领计划')]]
	})
	var reqType=new Ext.form.ComboBox({
		id:'reqType',
		fieldLabel:$g('请求单类型'),
		store:TypeStore,
		valueField:'RowId',
		displayField:'Description',
		emptyText:$g('请求单类型...'),
		triggerAction:'all',
		anchor:'90%',
		minChars:1,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local'
	});
	
	var find = new Ext.Toolbar.Button({
		text:$g('查询'),
	    tooltip:$g('查询'),
	    iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			findRec(refresh);
		}
	});
	
	var clear = new Ext.Toolbar.Button({
		id:'clear',
		text:$g('清屏'),
	    tooltip:$g('清屏'),
	    iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			clearReq();
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
	
	
	
	function clearReq()
	{
		req="";
		InRequestGridDs.removeAll();
		remark.setValue("");
		requestNnmber.setValue("");  //groupField
		supplyLocField.setValue("");
		supplyLocField.setRawValue("");
		dateField.setValue(new Date());
		completeCK.setValue(false);
		del.enable();
		groupField.setValue("");
		groupField.setRawValue("");
		timeField.setValue("");
		userField.setValue("");
		reqType.setValue("O");
		Ext.getCmp('save').enable();
		setGridEditable(Ext.getCmp('reqItmEditGrid'),true)  //恢复编辑
		add.setDisabled(false);
		SetLogInDept(LocField.getStore(),'LocField');
		groupField.store.load();
		if(abConsumeReq>0){
			location.href="dhcst.inrequest.csp?reqByabConsume=";
		}
		rpText=$g("进价合计:  ")
		spText=$g("售价合计:  ")
		Ext.getCmp("rpAmount").setText(rpText);
		Ext.getCmp("spAmount").setText(spText);
		changeElementEnable();
		
	}
	//wyx 2013-10-11		
	function CheckInciRep(InputInciDr){
		var retflag="0"
		var Count = InRequestGrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = InRequestGridDs.getAt(i);
			var rowInciDr = rowData.get("inci");
			if ((rowInciDr!="")&&(InputInciDr==rowInciDr)){
				var retflag="1";
				var cellnum=i+1;
				return retflag+"^"+cellnum;
				}
			}
		return retflag+"^"+"0"	;
	}
	function getDrugList2(record) {
		if (record == null || record == "") {
			return false;
		}
		var inputincidr=record.get("InciDr");
		var retstr=CheckInciRep(inputincidr);
		var retlist=retstr.split("^");
		var repinciflag=retlist[0];
		var cellnum=retlist[1];
		if (repinciflag=="1") {
			Msg.info("warning", $g("该药品与第")+cellnum+$g("行,请求药品名称重复！"));
			return false;
			}
		//var rowrecord = InRequestGrid.getSelectionModel().getSelected();
		//var recordrow = InRequestGridDs.indexOf(rowrecord)
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     	var recordrow = cell[0];
		var rowData = InRequestGridDs.getAt(recordrow);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		
		//供应商id^供应商名称^产地id^产地名称^配送商id^配送商名称^入库单位id^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
		//{success:'true',info:'7^GAYY-北京广安医药联合中心^61^bjymzy-北京益民制药厂^^^26^盒[20片]^0^0^0^^^艾司唑仑片^^普通片剂^[1mg*20]'}
		//取其它药品信息
		
		var locId = Ext.getCmp('LocField').getValue();
		var prvlocId = Ext.getCmp('supplyLocField').getValue();
		//---------------add by myq 20141104
		
		var locDesc = Ext.getCmp('LocField').getRawValue();
		var prvlocDesc = Ext.getCmp('supplyLocField').getRawValue();
		var InciDesc = record.get("InciDesc") ;
		
		var prflag=tkMakeServerCall("web.DHCST.RelLoc","ChkPRLocFlagByInci",prvlocId,locId,record.get("InciDr"))
			//	alert("prflag:"+prflag)
		if (prflag!="1"){
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     	var recordrow = cell[0];
       var record = InRequestGridDs.getAt(recordrow);
       InRequestGridDs.remove(record);
			 InRequestGrid.getView().refresh();
			
		   Msg.info('warning',locDesc+$g('不能向')+prvlocDesc+$g('申领')+InciDesc);
			 return false ;
		
		}
		//---------------add by myq 20141104	
		var Params=""+"^"+locId+"^"+prvlocId
		if(locId!=""){
			Ext.Ajax.request({
				url : 'dhcst.inrequestaction.csp?actiontype=GetItmInfo&lncId='+ record.get("InciDr")+'&Params='+Params,
				method : 'POST',
				waitMsg : $g('查询中...'),
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
					if (jsonData.success == 'true') {
						var data=jsonData.info.split("^");
						var ManfId = data[2];
						var Manf = data[3];
						rowData.set("manf", data[3]);    //生产商						
						var UomId=data[6];
						var Uom=data[7];
						addComboData(ItmUomStore, UomId, Uom);
                    	rowData.set("uom", UomId);
						
						rowData.set("uom", UomId);    //单位Id
						rowData.set("uomDesc", Uom);    //单位名称
						rowData.set("sp", data[9]);   
						rowData.set("rp", data[8]);  
						rowData.set("generic", data[13]);     
						rowData.set("drugForm", data[15]);   
						rowData.set("spec", data[16]);
						rowData.set("reqqty", data[10]);
						rowData.set("prvqty", data[19]);
						rowData.set("buom", data[17]);
						rowData.set("confac", data[18]);
					}
				},
				scope:this
			});
		}else{
			Msg.info("error",$g("请选择科室!"));
		}
		 if (setEnterSort(InRequestGrid, colArr)) {
                        addNewRow();
                    }
	}
	
	function GetPhaOrderInfo2(item, group) {
		if (item != null && item.length > 0) {
			var prvlocId = Ext.getCmp('supplyLocField').getValue();
			GetPhaOrderWindow(item, group, App_StkTypeCode, prvlocId, "N", "0", "",getDrugList2);
		}
	}
	//=========================定义全局变量=================================
	//=========================请求单主信息=================================
	function addNewRow() {	
		if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
		{
			Msg.info('warning',$g('当前请求单已完成!'));
			return;
		}
		var rowCount =InRequestGrid.getStore().getCount();
		if(rowCount>0){
			var rowData = InRequestGridDs.data.items[rowCount - 1];
			var data=rowData.get("inci")
			if(data=="" || data.length<=0){
				var col=GetColIndex(InRequestGrid,'desc');
				InRequestGrid.getSelectionModel().selectRow(InRequestGridDs.getCount() - 1);
				InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, col);
				return;
			}
		}
		
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
				name : 'rp',
				type : 'int'
			}, {
				name : 'rpAmt',
				type : 'double'
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
			}, {
				name : 'consumqty',
				type : 'int'
			}, {
				name : 'buom',
				type : 'string'
			}, {
				name : 'confac',
				type : 'int'
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
			rp:'',
			rpAmt:'',
			sp:'',
			spAmt:'',
			generic:'',
			drugForm:'',
			remark:'',
			consumqty:'',
			buom:'',
			confac:''
		});
						
	InRequestGridDs.add(NewRecord);
	var col=GetColIndex(InRequestGrid,'desc');
	//InRequestGrid.getSelectionModel().selectRow(InRequestGridDs.getCount() - 1);
	InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, col);
	changeElementEnable();
	}
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
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if (setEnterSort(InRequestGrid, colArr)) {
                                addNewRow();
                            }		
			}
		}
	}
});
ItmUomStore.on('beforeload',function(store){
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
    var recordrow = cell[0];
	var record = InRequestGrid.getStore().getAt(recordrow);
	var InciDr = record.get("inci");
	if (InciDr=='') {
		return false;
	}
	else{
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
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
    var recordrow = cell[0];
	var record = InRequestGrid.getStore().getAt(recordrow);	
	var value = combo.getValue();        //目前选择的单位id	
	var Uom = record.get("uom");    //目前显示的单位
	var BUom=record.get("buom"); 
	var ConFac=record.get("confac"); 
	var ReqStkQty=record.get("reqqty");
	var PrvStkQty=record.get("prvqty");
	var Rp=record.get("rp");
	var Sp=record.get("sp");
	var NewReqStkQty=ReqStkQty;
	var NewPrvStkQty=PrvStkQty;
	var NewRp=Rp
	var NewSp=Sp
	var qty=record.get("qty");
	if(value!=Uom){
		if(value==BUom){
			NewReqStkQty=ReqStkQty*ConFac;
			NewPrvStkQty=PrvStkQty*ConFac;
			NewRp=Rp/ConFac;
			NewSp=Sp/ConFac;
		}else{
			NewReqStkQty=ReqStkQty/ConFac;
			NewPrvStkQty=PrvStkQty/ConFac;
			NewRp=Rp*ConFac;
			NewSp=Sp*ConFac;
		}
		record.set("reqqty",NewReqStkQty)
		record.set("prvqty",NewPrvStkQty)
		record.set("rp",NewRp)
		record.set("sp",NewSp)
	}
   if ((qty!=null)&&(qty!=0)){
		var newSpAmt=qty*record.get('sp');
		var newRpAmt=qty*record.get('rp');
		newSpAmt=1*FormatGridSpAmount(newSpAmt);
		newRpAmt=1*FormatGridRpAmount(newRpAmt);
		record.set("spAmt",newSpAmt);
		record.set("rpAmt",newRpAmt);	
   }	
	record.set("uom", combo.getValue());		
});
	
	var InRequestGrid="";
	//配置数据源
	var InRequestGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryDetail',method:'GET'});
	var InRequestGridDs = new Ext.data.Store({
		proxy:InRequestGridProxy,
	    reader:new Ext.data.JsonReader({
	        root:'rows',
			totalProperty:'results'
	    	}, [
			{name:'rowid'},
			{name:'inci'},
			{name:'code'},
			{name:'desc'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'generic'},
			{name:'drugForm'},
			{name:'remark'},
			{name:'reqqty'},
			{name:'prvqty'},
			{name:'buom'},
			{name:'confac'},
			{name:'consumqty'}
		]),
	    remoteSort:false,
	    pruneModifiedRecords:true,  //这句很重要,每次增删改后清空修改状态
	    listeners:{
		    'load':function(store)
		    {
		
		    }
	    
	    }
	});
	
	function setGridEditable(grid,b)
	{
		var colId=grid.getColumnModel().getIndexById('colQty');	        
		grid.getColumnModel().setEditable(colId,b);
		var colId=grid.getColumnModel().getIndexById('colDesc');	        
		grid.getColumnModel().setEditable(colId,b);
		var colId=grid.getColumnModel().getIndexById('colRemark');	        
		grid.getColumnModel().setEditable(colId,b);
	
	}
	
	
	//模型
	var InRequestGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:$g("明细rowid"),
	        dataIndex:'rowid',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:$g("药品rowid"),
	        dataIndex:'inci',
	        width:100,
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
	        id:'colDesc',
	        width:220,
	        align:'left',
	        sortable:true,
			editor:new Ext.form.TextField({
				id:'descField',
				selectOnFocus:true,
	            allowBlank:false,
				listeners:{
					specialKey:function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var stkGrp=Ext.getCmp("groupField").getValue();
							GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),stkGrp);
						}
					}
				}
	        })
	    },{
	        header:$g("生产企业"),
	        dataIndex:'manf',
	        width:150,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("请求数量"),
	        dataIndex:'qty',
	        id:'colQty',
	        width:100,
	        align:'right',
	        sortable:true,
			editor:new Ext.ux.NumberField({
				id:'qtyField',
				formatType:'FmtSQ',
	            allowBlank:false,
	            selectOnFocus:true,
				listeners:{
					specialKey:function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
						//InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 11);
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     					var recordrow = cell[0];
						var record = InRequestGrid.getStore().getAt(recordrow);
						var qty = field.getValue();
						if((qty == null) || (qty.length <= 0)||(qty.length == "")){
							Msg.info("warning", $g("数量不能为空!"));
							return;
							}
　　　　　　　　　　　　
						if (qty <= 0) {
							Msg.info("warning", $g("数量不能小于或等于0!"));
							return;
						}

						var PrQty = record.get("prvqty");
						
						if ((Number(qty) > Number(PrQty))){
						  Msg.info("warning", $g("请求数量大于供应方库存数量!"));
						  if(gParam[0]=='N'){
						  	InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 11);
						  	record.set("qty","");
						  	return;
						  }
						}
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     					var recordrow = cell[0];
						var rowData = InRequestGridDs.getAt(recordrow);
						var newSpAmt=qty*rowData.get('sp');
						var newRpAmt=qty*rowData.get('rp');
						newSpAmt=1*FormatGridSpAmount(newSpAmt);
						newRpAmt=1*FormatGridRpAmount(newRpAmt);
						rowData.set("spAmt",newSpAmt);
						rowData.set("rpAmt",newRpAmt);
						setStatAmount();　//设置合计
					    if (setEnterSort(InRequestGrid, colArr)) {
                       	 	addNewRow();
                    	}
						}
					}
				}
	        })
	    },{
	        header:$g("请求方库存"),
	        dataIndex:'reqqty',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:false
	    },{
	        header:$g("供应方库存"),
	        dataIndex:'prvqty',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:false
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
	    },{
	        header:$g("零售单价"),
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
	        header:$g("单位"),
	        dataIndex:'uom',
	        id:'uom',
	        width:100,       
	        align:'left',
	        sortable:true,
	        renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
			editor : new Ext.grid.GridEditor(CTUom)
			
			
	    },{
	        header:$g("备注"),
	        dataIndex:'remark',
	        id:'colRemark',
	        width:200,
	        align:'left',
	        sortable:true,
			editor:new Ext.form.TextField({
				id:'remarkField',
	            allowBlank:true,
				listeners:{
					specialKey:function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     						var recordrow = cell[0];
							if(InRequestGridDs.getAt(recordrow).get('qty')==0){
								Msg.info("error",$g("请求数量不能为0!"));
								InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 6);
								return false;
							}else{
								//增加一行
								 if (setEnterSort(InRequestGrid, colArr)) {
				                        addNewRow();
				                    }
							}
						}
					}
				}
	        })
	    },{
	        header:$g("规格"),
	        dataIndex:'spec',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("处方通用名"),
	        dataIndex:'generic',
	        width:150,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("剂型"),
	        dataIndex:'drugForm',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("建议请领数量"),
	        dataIndex:'consumqty',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:false
	    },{
	        header:"buom",
	        dataIndex:'buom',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:"confac",
	        dataIndex:'confac',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    }

	]);
	
	var add = new Ext.Toolbar.Button({
		text:$g('新建'),
		id:'newReq',
		iconCls:'page_add',
	    tooltip:$g('新建库存转移请求单'),
		width : 70,
		height : 30,
		//disabled:true,
		handler:function(){
			clearReq();
			
		}
	});
	function saveReq()
	{  
		//主表信息
		//供给部门
		var frLoc = Ext.getCmp('supplyLocField').getValue(); 
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", $g("请选择供给部门!"));
			return false;
		}
	
		//请求部门
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", $g("请选择请求部门!"));
			return false;
		}
		//登陆用户
		var user = UserId;
		//类组
		var scg = Ext.getCmp('groupField').getValue(); 
		if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
			Msg.info("error", $g("请选择类组!"));
			return false;
		}
		//完成标志(暂时为空)
		var status =Ext.getCmp('reqType').getValue(); 
		//备注
		var remark = Ext.getCmp('remark').getValue(); 
		var ss=remark.replace(/\r\n/g,xMemoDelim());
		var remark=ss;
		
		//主表信息字符串
		var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark;
		if(RowDelim==null){
			Msg.info("error", $g("行分隔符有误，不能保存!"));
			return false;
		}
		
		if(InRequestGrid.activeEditor != null){
			InRequestGrid.activeEditor.completeEdit();
		} 
		//子表明细
		var data = "";
		var count= InRequestGrid.getStore().getCount();
		if(count==0){
		    Msg.info("error", $g("明细不能为空!"));
			return false;
		}
		//获取所有的新记录   bianshuai 2014-04-24
		var itmIsNull=1;
		var mr=InRequestGridDs.getModifiedRecords();
		if(mr.length==0){itmIsNull=0}
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowid = mr[i].data["rowid"];
			var inc = mr[i].data["inci"];
			//------add by myq 2014104
		 var locDesc = Ext.getCmp('LocField').getRawValue();
		 var prvlocDesc = Ext.getCmp('supplyLocField').getRawValue();
		
		 var prflag=tkMakeServerCall("web.DHCST.RelLoc","ChkPRLocFlagByInci",frLoc,toLoc,inc)
	
		if (prflag!="1"){
			
		   Msg.info('warning',locDesc+$g('不能向')+prvlocDesc+$g('申领该药品'));
			 return false ;  //
		 
		}
		
		//------add by myq 2014104
			
			var qty = mr[i].data["qty"];
			var uomId = mr[i].data["uom"];
			var colRemark= mr[i].data['remark'];
			var PrQty =  mr[i].data['prvqty'];
			var desc= mr[i].data['desc'];
			var ppqty=mr[i].data['consumqty'];
			//alert("colRemark:"+colRemark)
			if ((inc!="")&&(((qty!=null)&&(Number(qty)<0))||(qty==""))) {
				 Msg.info("warning", desc+$g(",请求数量不能小于0或为空!"));      
				 return false;
			}	
			if ((Number(qty) > Number(PrQty))&&(gParam[0]=='N') ){
				 //Msg.info("warning", desc+",请求数量不能大于供应方库存数量!");
				 //return false;
			}
			if(desc.length!=0){
				
				itmIsNull=0;
				}
				
			if((inc!="")&&(inc!=null)&&(qty!="")&&(qty!=null)&&(qty!=0)){
				var tmp = rowid+"^"+inc+"^"+uomId+"^"+qty+"^"+colRemark+"^"+scg+"^"+ppqty;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
		if(itmIsNull==1){
			Msg.info("warning", $g("明细不能为空!"));      
				 return false;
			}
		if ((req=="")&&(data=="")){Msg.info("warning", $g("没有内容需要保存!"));return false;};
		if(!IsFormChanged(formPanel) && data==""){Msg.info("warning", $g("没有内容需要保存!"));return false;};
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=save',
			params:{req:req,reqInfo:reqInfo,data:data},
			method : 'POST',
			waitMsg : $g('查询中...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", $g("保存成功!"));
					req = jsonData.info;
					refresh(req);
				}else{
					if(jsonData.info==-1){
						Msg.info("error", $g("主表保存失败!"));
					}else if(jsonData.info==-99){
						Msg.info("error", $g("主表加锁失败!"));
					}else if(jsonData.info==-2){
						Msg.info("error", $g("主表解锁失败!"));
					}else if(jsonData.info==-5){
						Msg.info("error", $g("明细保存失败!"));
					}else if(jsonData.info==-4){
						Msg.info("error", $g("主表单号设置失败!"));
					}else if(jsonData.info==-3){
						Msg.info("error", $g("主表保存失败!"));
					}else if(jsonData.info==-1001){
						Msg.info("error", $g("当前单据已完成!"));
					}else if(jsonData.info==-1002){
						Msg.info("error", $g("当前单据明细已发生转移!"));
					}else if(jsonData.info==-1003){
						Msg.info("error", $g("当前单据明细已建为采购计划!"));
					}else{
						Msg.info("error", $g("保存失败!"));
					}
				}
			},
			scope : this,
			scope:InRequestGridDs.commitChanges()
		});
		complete.enable();
	    add.enable();
	}
	var save = new Ext.Toolbar.Button({
		text:$g('保存'),
		id:'save',
	    tooltip:$g('保存'),
	    iconCls:'page_save',
		width : 70,
		height : 30,
		handler:function(){
			if(abConsumeReq>0){
				req = abConsumeReq;
			}
			//保存时传入三个字符串
			//1.主表rowid
			//2.主表的信息：frLoc、toLoc、user、scg、status、remark
			//3.子表明细信息：req、明细字符串rows(rows信息：reqi(明细rowid)、data(inci、uom、qty))

			saveReq();
		}
	});
	
	function refresh(req){
		Select(req);
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
		
	}
	
	
	
	function Select(reqid){
		if(reqid==null || reqid==''){
			return;
		}
		req=reqid;
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=select&ReqId='+reqid,
			method : 'POST',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var data=jsonData.info;
					if(data.length>0){
						var dataArr=data.split("^");
						Ext.getCmp('requestNnmber').setValue(dataArr[1]);
						addComboData(Ext.getCmp('supplyLocField').getStore(),dataArr[8],dataArr[12]);
						Ext.getCmp('supplyLocField').setValue(dataArr[8]);
						addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
						Ext.getCmp('LocField').setValue(dataArr[2]); 
						Ext.getCmp('dateField').setValue(dataArr[6]);
						Ext.getCmp('timeField').setValue(dataArr[9]); 
						Ext.getCmp('userField').setValue(dataArr[14]); 
	//					addComboData(Ext.getCmp('reqType').getStore(),dataArr[5]);
						Ext.getCmp('reqType').setValue(dataArr[5]);
						addComboData(groupField.getStore(),dataArr[15],dataArr[16]);
						Ext.getCmp('groupField').setValue(dataArr[15]);
						if(dataArr[11]=="Y"){
							Ext.getCmp("completeCK").setValue(true);
							Ext.getCmp("save").disable();
							Ext.getCmp("delete").disable();
							Ext.getCmp("complete").disable();
							Ext.getCmp("cancelComp").enable();
						}
						else{
							Ext.getCmp("completeCK").setValue(false);				
							Ext.getCmp("save").enable();
							Ext.getCmp("delete").enable();
							Ext.getCmp("complete").enable();
							Ext.getCmp("cancelComp").disable();
						}
	 
						Ext.getCmp('remark').setValue(handleMemo(dataArr[10],xMemoDelim()));
						var grid=Ext.getCmp('reqItmEditGrid');
						if (grid){
							//alert(Ext.getCmp("completeCK").getValue());
							setGridEditable(grid,!Ext.getCmp("completeCK").getValue());  //将grid的可编辑列disable掉
						}
						SetFormOriginal(formPanel);
						setStatAmount();
					}				
				}
			},
			scope : this
		});
	}
	
	var complete = new Ext.Toolbar.Button({
		text:$g('确认完成'),
		id:'complete',
	    tooltip:$g('确认完成'),
	    iconCls:'page_gear',
		width : 70,
		height : 30,
		disabled:true,
		handler:function(){
			var completeCK = Ext.getCmp('completeCK').getValue();
            var mod = isDataChanged();
            if (mod && (!completeCK)) {
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
	/**
	 * 完成
	 */
	function Complete(){
		if (req=='') 
		{
			Msg.info('warning',$g('没有任何请求单！'));
			return ;
		}
		//子表明细
		var data = "";
		var count= InRequestGrid.getStore().getCount();
		if(count==0){
		    Msg.info("error", $g("明细不能为空!"));
		return ;
		}
		for(var index=0;index<count;index++){
		    var rec = InRequestGridDs.getAt(index);
			var inc = rec.data['inci'];
			var qty = rec.data['qty'];
			var colRemark=rec.data['remark'];
			var PrQty = rec.data['prvqty'];
			var desc=rec.data['desc']; 

	  	    if ((Number(qty) > Number(PrQty))){
			   Msg.info("warning", desc+$g(",请求数量大于供应方库存数量!")); //提示不限制
	  		   if(gParam[0]=='N'){
			  	 InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 11);
			  	 record.set("qty","");
			  	 return;
			   }
		    }
	
	      }
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			statu = "Y";
			Ext.Ajax.request({
				url : 'dhcst.inrequestaction.csp?actiontype=set&req='+req+'&statu='+statu,
				method : 'POST',
				waitMsg :$g( '查询中...'),
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", $g("确认完成成功!"));
						statu = "Y";
						completeCK.setValue(statu=='Y'?true:false);
						var grid=Ext.getCmp('reqItmEditGrid');
                                                    refresh(req);         //完成成功后重新加载
						if (grid){
							setGridEditable(grid,!Ext.getCmp("completeCK").getValue());  //将grid的可编辑列disable掉
						}
						
					}else{
						if(jsonData.info==-2){
							Msg.info("error", $g("设置失败!"));
						}else if(jsonData.info==-1){
							Msg.info("error", $g("加锁失败!"));
						}else{
							Msg.info("error", $g("设置失败!"));
						}
					}
				},
				scope : this
			});
		}
		complete.disable();
		save.disable();
		del.disable();
		cancelComplete.enable();
	}
	
	function isDataChanged() {
	    var changed = false;
	    var count1 = InRequestGrid.getStore().getCount();
	    //看主表数据是否有修改
	    //修改为主表有修改且子表有数据时进行提示
	    if ((IsFormChanged(formPanel)) && (count1 != 0)) {
	        changed = true;
	    };
	    if (changed) return changed;
	    //看明细数据是否有修改
	    var count = InRequestGrid.getStore().getCount();
	    for (var index = 0; index < count; index++) {
	        var rec = InRequestGrid.getStore().getAt(index);
	        //新增或数据发生变化时执行下述操作
	        if (rec.data.newRecord || rec.dirty) {
	            changed = true;
	        }
	    }
	    return changed;
	}
	
	//页面跳转来时 确认完成按钮的控制
	if(abConsumeReq>0){
		complete.enable();
		Select(abConsumeReq);
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:abConsumeReq}});
	       
	}
	
	var cancelComplete = new Ext.Toolbar.Button({
		text:$g('取消完成'),
	    tooltip:$g('取消完成'),
	    id:'cancelComp',
	    iconCls:'page_gear',
		width : 70,
		height : 30,
		disabled:true,
		handler:function(){
			if (req=='') 
			{
				Msg.info('warning',$g('没有任何请求单！'));
				return ;
			}
			//alert(Ext.getCmp('completeCK').getValue());
			
			var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
			//alert(statu);
			if(statu=="Y"){
				statu = "N";
				Ext.Ajax.request({
					url : 'dhcst.inrequestaction.csp?actiontype=set&req='+req+'&statu='+statu,
					method : 'POST',
					waitMsg : $g('查询中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", $g("取消完成成功!"));
							statu = "N";
							completeCK.setValue(statu=='Y'?true:false);
							var grid=Ext.getCmp('reqItmEditGrid');
			    				complete.enable();//取消完成成功置状态 ，将以前的屏蔽掉
			                		save.enable();
							del.enable();
							if (grid){
								setGridEditable(grid,!Ext.getCmp("completeCK").getValue());  //将grid的可编辑列disable掉
							}
							
						}else{
							if(jsonData.info==-2){
								Msg.info("error", $g("设置失败!")+jsonData.info);
							}else if(jsonData.info==-1){
								Msg.info("error", $g("当前请求单已转为正式库存转移单,禁止取消完成!"));
							}else if (jsonData.info==-99) {
								Msg.info("error", $g("加锁失败!"));
							}					
							else{
								Msg.info("error", $g("设置失败!")+jsonData.info);
							}
						}
					},
					scope : this
				});
			}
			/*complete.enable();
			save.enable();
			del.enable();*/
		}
	});
	
	function delReq()
	{
		if(req==null || req==""){
			Msg.info("warning",$g("请选择要删除的请求单!"));
			return;
		}
		
		Ext.Msg.show({
			title:$g('提示'),
			msg:$g('是否确定删除请求单？'),
			buttons:Ext.Msg.YESNO,
			icon: Ext.MessageBox.QUESTION,
			fn:function(b,txt){
				if (b=='no')	{return;}
				else 	
				{
					Ext.Ajax.request({
						url:DictUrl+"inrequestaction.csp?actiontype=Delete",
						method:'POST',
						params:{req:req},
						success:function(response,opts){
							var jsonData=Ext.util.JSON.decode(response.responseText);
							if(jsonData.success=='true'){
								Msg.info("success",$g("删除成功!"));
								Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
								//Ext.getCmp("clear").fireEvent('click');
								//clear.fireEvent('click');
								//clear_click();
							}else{
								if(jsonData.info==-1){
									Msg.info("warning",$g("该请求单已完成，不允许删除！"));
								}else{
									Msg.info("error",$g("删除失败:")+jsonData.info);
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
		text:$g('删除'),
		id:'delete',
	    tooltip:$g('删除'),
	    iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			delReq();
		}
	});
	
	var printBT = new Ext.Toolbar.Button({
		text : $g('打印'),
		tooltip : $g('打印请求单'),
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			if(req==null || req==""){
				Msg.info("warning",$g("没有需要打印的请求单!"));
				return;
			}
			PrintINRequest(req);
		}
	});
	// 按照科室库存生成请求单
    var ConWinBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : $g('生成请求单'),
	tooltip :$g( '生成请求单'),
	iconCls:'page_goto',
	width : 70,
	height : 30,
	handler : function() {
		var ProLoc=Ext.getCmp("supplyLocField").getValue()
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if (ProLoc==toLoc){
			Msg.info("warning", $g("请求部门和供应部门不能相同!"));
			return;
		}		
		var ProLocDesc=Ext.getCmp("supplyLocField").getRawValue()
		InRequestConWin(refresh,ProLoc,ProLocDesc);

		//InRequestGridDs.removeAll();
		//InRequestGridDs.load({params:{start:0,limit:PageSize,sort:'rowid',dir:'desc',req:req}});
	}
    });
    var copyBT = new Ext.Toolbar.Button({
		iconCls:'page_copy',
		height:30,
		width:70,
		text:$g('复制请求单'),
		tooltip:$g('复制请求单'),
		handler:function(){
			findRec(copyReq,$g("复制库存转移请求单"));
		}
	});
	function copyReq(req,transflag){
		selectReqLoc(createReq,req,transflag)
		}
	function createReq(req,reqloc,proloc,transflag)
	{
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=copy',
			params:{req:req,reqloc:reqloc,proloc:proloc,transflag:transflag},
			method : 'POST',
			waitMsg : $g('查询中...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", $g("复制成功!"));
					req = jsonData.info;
					refresh(req);
				}else{
					if(jsonData.info==-1){
						Msg.info("error", $g("主表保存失败!"));
					}else if(jsonData.info==-99){
						Msg.info("error", $g("主表加锁失败!"));
					}else if(jsonData.info==-2){
						Msg.info("error", $g("主表解锁失败!"));
					}else if(jsonData.info==-5){
						Msg.info("error", $g("明细保存失败!"));
					}else if(jsonData.info==-4){
						Msg.info("error", $g("主表单号设置失败!"));
					}else if(jsonData.info==-3){
						Msg.info("error", $g("主表保存失败!"));
					}else{
						Msg.info("error", $g("保存失败!"));
					}
				}
			},
			scope : this
		});
		
		}

	//删除转移请求明细
	function DeleteDetail(){		
		if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
		{
			Msg.info('warning',$g('当前请求单已完成'));
			return;
		}
		
		//var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		if (cell==null){
			Msg.info("error",$g("请选择数据!"));
			return false;
		}
     	var recordrow = cell[0];
		var selectrecord = InRequestGridDs.getAt(recordrow);		
		
		Ext.MessageBox.confirm($g('提示'),$g('确定要删除记录?'),
			function(btn) {
				if(btn == 'yes'){
						var reqItm = selectrecord.data['rowid'];
						if ((reqItm!="")&&(reqItm!=null)){  //不用异步,否则refresh不起作用
				            var deleteret=tkMakeServerCall("web.DHCST.INReqItm","Delete",reqItm);
				            if (deleteret=="0"){
				            	InRequestGridDs.remove(selectrecord);
				            }
				            else{
					            if (deleteret==-1){
						          Msg.info("warning",$g("当前单据已完成!"));  
						        }else if(deleteret==-2){
							       Msg.info("warning",$g("当前单据明细已发生转移!")); 
						        }else if(deleteret==-3){
							       Msg.info("warning",$g("当前单据明细已建为采购计划!")); 
						        }else{
							       Msg.info("error",$g("删除明细失败!"))
						        }						           
					         	return false; 
					         }
						}
						else{
							InRequestGridDs.remove(selectrecord);
						}
			
					
					InRequestGrid.getView().refresh();
					changeElementEnable();
					if (Ext.getCmp('requestNnmber').getValue()!=""){
						if (InRequestGrid.getStore().getCount()==0){
								delReq();
						}
					}
				}
			}
		 )
			
         setStatAmount();
	}
	
	function setStatAmount()
	{
		var rpAmt=0;
		var spAmt=0;
		var count = InRequestGrid.getStore().getCount();
		for (var i=0; i<count; i++)
		{
			var rowData = InRequestGridDs.getAt(i);
			rpAmt=rpAmt+rowData.get("rpAmt")*1;
			spAmt=spAmt+rowData.get("spAmt")*1;
		}
		spAmt=FormatGridSpAmount(spAmt);
		rpAmt=FormatGridRpAmount(rpAmt);
		rpText=$g("进价合计:  ")+rpAmt+$g("  元");
		spText=$g("售价合计:  ")+spAmt+$g("  元");
		Ext.getCmp("rpAmount").setText(rpText);
		Ext.getCmp("spAmount").setText(spText);	
	}
	///处理JS浮点型数据相加，产生多位小数问题
	function FmtAmt(price,pos)
	{
		var price=Math.round(price*Math.pow(10,pos))/Math.pow(10,pos);
		return price;
	}
	//初始化默认排序功能
	InRequestGridCm.defaultSortable = true;
	
	var AddDetailBT=new Ext.Button({
		text:$g('增加一条'),
		tooltip:$g('点击增加'),
		iconCls:'page_add',
		handler:function(){
			var toLoc = Ext.getCmp('LocField').getValue(); 
			if((toLoc=="")||(toLoc==null)){
				Msg.info("warning", $g("请选择请求部门!"));
				return ;
			}
			var frLoc = Ext.getCmp('supplyLocField').getValue(); 
			if((frLoc=="")||(frLoc==null)){
				Msg.info("warning", $g("请选择供给部门!"));
				return ;
			}
			if (toLoc == frLoc) {
				Msg.info("warning", $g("请求部门和供应部门不能相同!"));
				return;
			}
			var rowCount =InRequestGrid.getStore().getCount();
			if(rowCount>0){
				var rowData = InRequestGridDs.data.items[rowCount - 1];
				var data=rowData.get("inci")
				if(data=="" || data.length<=0){
					Msg.info("warning",$g("已存在新建行"));
					return;
				}
			}
			addNewRow();
		}
	})
	var DelDetailBT=new Ext.Button({
		text:$g('删除记录'),
		tooltip:'',
		iconCls:'page_delete',
		handler:function()
		{
			DeleteDetail();
		}
	})
	
	var GridColSetBT = new Ext.Toolbar.Button({
		text:$g('列设置'),
	    tooltip:$g('列设置'),
	    iconCls:'page_gear',
//		width : 70,
//		height : 30,
		handler:function(){
			GridColSet(InRequestGrid,"DHCSTINREQ");
		}
	});

var newsm = new Ext.grid.CheckboxSelectionModel({  
        singleSelect : false, 
        ///yunhaibao20151118.shift,ctrl多选不冲突
		handleMouseDown : function(g, rowIndex, e){  
		        if (e.button !== 0 || this.isLocked()) {  
		               return;  
		        }  
		        var view = this.grid.getView();  
		        if (e.shiftKey && !this.singleSelect) {  
		             var last = this.last;  
		             this.selectRange(last, rowIndex, e.ctrlKey|| e.shiftKey);  
		             this.last = last;  
		             view.focusRow(rowIndex);  
		        }else{  
		             var isSelected = this.isSelected(rowIndex);  
		             if (e.ctrlKey && isSelected) {  
		                  this.deselectRow(rowIndex);  
		             }else if(!isSelected || this.getCount() > 0){  
		                  this.selectRow(rowIndex, e.ctrlKey || e.shiftKey);   
		                  view.focusRow(rowIndex);  
		             }  
		        }  
		  },
		onEditorKey : function(field, e){  
	        var k = e.getKey(),   
	        newCell,   
	        g = this.grid,   
	        last = g.lastEdit,  
	        ed = g.activeEditor,  
	        ae, last, r, c;  
	        var shift = e.shiftKey;  
	        if(k == e.TAB){  
	            e.stopEvent();  
	            ed.completeEdit();  
	            if(shift){  
	                newCell = g.walkCells(ed.row, ed.col-1, -1, this.acceptsNav, this);  
	            }else{  
	                newCell = g.walkCells(ed.row, ed.col+1, 1, this.acceptsNav, this);  
	            }  
	        }else if(k == e.ENTER){  
	            if(this.moveEditorOnEnter !== false){  
	                if(shift){  
	                    newCell = g.walkCells(last.row - 1, last.col, -1, this.acceptsNav, this);  
	                }else{  
	            //CheckboxSelectionModel调用父类Ext.grid.RowSelectionModel的onEditorKey方法  
	            //原方法这行是newCell = g.walkCells(last.row+1, last.col, 1, this.acceptsNav, this);  
	                    newCell = g.walkCells(last.row , last.col, 1, this.acceptsNav, this);  
	                }  
	            }  
	        }  
	        if(newCell){  
	            r = newCell[0];  
	            c = newCell[1];  
  
	            if(last.row != r){  
	                this.selectRow(r);   
	            }  
  
	            if(g.isEditor && g.editing){   
	                ae = g.activeEditor;  
	                if(ae && ae.field.triggerBlur){  
                      
	                    ae.field.triggerBlur();  
	                }  
	            }  
	            var noeditcol=GetColIndex(this.grid,"desc");
	            if (c!=noeditcol)  //解决IE11兼容问题
	            { 
	            	g.startEditing(r, c);
	            }   
	        }  
	    }  
}); 

	//表格
	InRequestGrid = new Ext.grid.EditorGridPanel({
		id:'reqItmEditGrid',
		title:$g('出库请求单'),
		store:InRequestGridDs,
		cm:InRequestGridCm,
		trackMouseOver:true,
		height:476,
		stripeRows:true,
		region:'center',
		sm:new Ext.grid.CellSelectionModel({}), //newsm,
		loadMask:true,
		clicksToEdit:1,
		tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
		bbar:[rpAmount,'-',spAmount]
	});
	
	//zdm,增加右键删除明细功能
	InRequestGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
		e.preventDefault();
		rightClickMenu.showAt(e.getXY());
	});
	InRequestGrid.store.on('load',function(){
		
		setStatAmount();
	})
	
	var rightClickMenu=new Ext.menu.Menu({
		id:'rightClickMenu',
		items:[{id:'mnuDelete',text:$g('删除'),handler:DeleteDetail}]
	});
	function changeElementEnable()
	{
		if (InRequestGrid.getStore().getCount()==0){
			groupField.setDisabled(false);
		}
		else{
			groupField.setDisabled(true);
		}
	}
//=========================请求单主信息=================================

//===========模块主页面===========================================

	
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		title:$g('出库请求制单'),
		frame : true,
		tbar:[find,'-',clear,'-',add,'-',save,'-',complete,'-',cancelComplete,'-',ConWinBT,'-',copyBT,'-',printBT,'-',del],
		autoHeight:true,
		items : [{
			layout : 'column',			
			xtype : 'fieldset',
			title : $g('请求单信息'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults:{border:false},
			items : [{
				columnWidth:0.3,
				xtype:'fieldset',
				//defaults:{width:200},
				items : [LocField,supplyLocField,groupField,reqType]
			},{
				columnWidth : 0.25,
				xtype:'fieldset',
				//defaults:{width:140},
				items : [requestNnmber,dateField,timeField,userField]
			},{
				columnWidth : 0.25,
				xtype:'fieldset',
				//defaults:{width:140},
				items : [remark]
			},{
				columnWidth : 0.2,
				xtype:'fieldset',
				//defaults:{width:120},
				items : [completeCK]
			}]
		}]	
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[{
			region:'north',
			layout:'fit',
			height:DHCSTFormStyle.FrmHeight(4),
			items:[formPanel]
		},{
			region:'center',
			layout:'fit',
			items:[InRequestGrid]
		}],
		renderTo:'mainPanel'
	});
	reqType.setValue("O");
	RefreshGridColSet(InRequestGrid,"DHCSTINREQ");   //根据自定义列设置重新配置列
	colArr = sortColoumByEnterSort(InRequestGrid);
});
//===========模块主页面===========================================