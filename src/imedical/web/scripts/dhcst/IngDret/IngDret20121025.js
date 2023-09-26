// 名称:退货管理
// 编写日期:2012-07-6

var IncId="";
var URL = 'dhcst.ingdretaction.csp';
var vendorId="";
var vendorName = "";
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var arr = window.status.split(":");
var length = arr.length;
var ret = "";

function getDrugList(record) {
	if (record == null || record == "") {
		return false;
	}else{
		Ext.getCmp("pName").setValue(record.get("InciDesc"));	
		IncId = record.get("InciDr");
	}		
}
		
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, "G", "", "N", "0", "",getDrugList);
	}
}

var dateField = new Ext.form.DateField({
	id:'dateField',
	width:150, 
	listWidth:150,
    allowBlank:false,
	fieldLabel:'日期',
	format:'Y-m-d',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var dretField = new Ext.form.TextField({
	id:'dret',
	fieldLabel:'退货单号',
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});



var locField = new Ext.form.ComboBox({
	id:'locField',
	fieldLabel:'退货科室',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GetGroupDeptStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'退货科室...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:999,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	Ext.getCmp('locField').setRawValue(arr[length-1]);
	Ext.getCmp('locField').setValue(locId);
});	
		
var GroupStore = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
GroupStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url : 'dhcst.extux.csp?actiontype=StkCatGroup&type=G',method:'GET'});
});	
var groupField = new Ext.form.ComboBox({
	id:'groupField',
	fieldLabel:'类组',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GroupStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'类组...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var Vendor = new Ext.form.ComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	width : 127,
	store : APCVendorStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : true,
	triggerAction : 'all',
	emptyText : '',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 210,
	valueNotFoundText : ''
});



var pNameField = new Ext.form.TextField({
	id:'pName',
	fieldLabel:'物品名称',
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//调出药品窗口
				var group = Ext.getCmp("groupField").getValue();
				GetPhaOrderInfo(field.getValue(),group);
			}
		}
	}
});

var transOrder = new Ext.form.Checkbox({
	id: 'transOrder',
	fieldLabel:'调价换票',
	allowBlank:true
});

var complete = new Ext.form.Checkbox({
	id: 'complete',
	fieldLabel:'完成',
	disabled:true,
	allowBlank:true,
	listeners :{
		'check':function (obj, ischecked) {
            if (ischecked) {
				if((ret!="")&&(ret!=null)){
					Ext.Ajax.request({
						url:URL+'?actiontype=complet&ret='+ret,
						waitMsg:'删除中...',
						failure: function(result, request) {
							Msg.info("error","请检查网络连接!");
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Msg.info("success","完成动作成功!");
							}else{
								Msg.info("error","完成动作失败!");
							}
						},
						scope: this
					});
				}
            }
        }        
	}
});

var noViewZeroItem = new Ext.form.Checkbox({
	id: 'noViewZeroItem',
	fieldLabel:'不显示库存为零的项',
	allowBlank:true
});

var noViewZeroVendor = new Ext.form.Checkbox({
	id: 'noViewZeroVendor',
	fieldLabel:'不显示库存为零的供应商',
	allowBlank:true
});
//=========================退货管理=================================

function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'MinRp',
			type : 'double'
		}, {
			name : 'MaxRp',
			type : 'double'
		}, {
			name : 'Margin',
			type : 'double'
		}, {
			name : 'MPrice',
			type : 'double'
		}, {
			name : 'MaxMargin',
			type : 'string'
		}, {
			name : 'MaxMPrice',
			type : 'double'
		}, {
			name : 'SdDr',
			type : 'int'
		}, {
			name : 'SdDesc',
			type : 'string'
		}, {
			name : 'MtDr',
			type : 'int'
		}, {
			name : 'MtDesc',
			type : 'string'
		}, {
			name : 'UseFlag',
			type : 'bool'
		}, {
			name : 'Remark',
			type : 'string'
		}
	]);
	
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		MinRp:'',
		MaxRp:'',
		Margin:'',
		MPrice:'',
		MaxMargin:'',
		MaxMPrice:'',
		SdDr:'',
		SdDesc:'',
		MtDr:'',
		MtDesc:'',
		UseFlag:true,
		Remark:''
	});
					
	IngDretGridDs.add(NewRecord);
	IngDretGrid.startEditing(IngDretGridDs.getCount() - 1, 12);
}
ReasonForReturnStore.load();
var Cause = new Ext.form.ComboBox({
	fieldLabel : '退货原因',
	id : 'Cause',
	name : 'Cause',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '退货原因...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var row = IngDretGridDs.getAt(IngDretGridDs.getCount()- 1);
				row.set('cause',field.getRawValue());
				row.set('causeName',field.getRawValue());
				row.set('causeId',field.getValue());
			}
		},
		'select':function(combo,record,index){
			var row = IngDretGridDs.getAt(IngDretGridDs.getCount()- 1);
			row.set('cause',combo.getRawValue());
			row.set('causeName',combo.getRawValue());
			row.set('causeId',combo.getValue());
		}
	}
});		

var IngDretGrid="";
//配置数据源
var IngDretGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectBatch',method:'GET'});
var IngDretGridDs = new Ext.data.Store({
	proxy:IngDretGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'INGRI'},
		{name:'code'},
		{name:'desc'},
		{name:'mnf'},
		{name:'batch'},
		{name:'expdate'},
		{name:'recqty'},
		{name:'stkqty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'pp'},
		{name:'sven'},
		{name:'idate'},
		{name:'rp'},
		{name:'sp'},
		{name:'INCLB'},
		{name:'iniflag'},
		{name:'Drugform'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:'Y-m-d'},
		{name:'invAmt'},
		{name:'dretQty'},
		{name:'cause'},
		{name:'causeName'},
		{name:'causeId'}
	]),
    remoteSort:false
});
/*{results:1,rows:[{code:'H01N006',desc:'艾司唑仑片[舒乐安定][1mg*20]',mnf:'bjymzy-北京益民制药厂',batch:'20110101',expdate
:'2012-01-01',recqty:'20',uomDesc:'盒[20片]',stkqty:'20',INGRI:'4319||1',pp:'1.04',sven:'GAYY-北京广安医药联合
中心',idate:'2011-01-18',rp:'1.04',sp:'1.2',INCLB:'534||3||4',iniflag:'0',Drugform:'普通片剂',invNo:'普通片剂'
,invDate:'',invAmt:''}]}

	s code=result.Data("code")   //代码
	s desc=result.Data("desc")  //描述
	s mnf=result.Data("mnf")    //厂家
	s batch=result.Data("batch")  //批号
	s expdate=result.Data("expdate")  //效期
	s recqty=result.Data("recqty")  //入库数
	s uomDesc=result.Data("uomDesc")  //单位
	s stkqty=result.Data("stkqty")  //现库存数
	s INGRI=result.Data("INGRI")  //入库明细表rowid(DHC_INGdRecItm)
	s pp=result.Data("pp")  //批价
	s sven=result.Data("sven")  //供应商名称
	s idate=result.Data("idate")  //入库日期(入库审核日期)
	s rp=result.Data("rp")  //进价
	s sp=result.Data("sp")  //售价
	s INCLB=result.Data("INCLB")  //批次DR(INC_ItmLcBt)
	s iniflag=result.Data("iniflag")  //初始化标志
	s Drugform=result.Data("Drugform")  //剂型
	s invNo=result.Data("invNo")   //发票号
	s invDate=result.Data("invDate")  //发票日期
	s invAmt=result.Data("invAmt")   //发票金额
*/
//模型
var IngDretGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"批次DR",
        dataIndex:'INCLB',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"入库明细表rowid",
        dataIndex:'INGRI',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"剂型",
        dataIndex:'Drugform',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"产地",
        dataIndex:'mnf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"批号",
        dataIndex:'batch',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"进价",
        dataIndex:'rp',
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
        header:"效期",
        dataIndex:'expdate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"入库数量",
        dataIndex:'recqty',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"入库单位",
        dataIndex:'uomDesc',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"现库存数量",
        dataIndex:'stkqty',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"退货数量",
        dataIndex:'dretQty',
        width:80,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'dretQtyField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					var cell = IngDretGrid.getSelectionModel().getSelectedCell();
					var row = IngDretGridDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
						var count = field.getValue();
						if(count>row.get("stkqty")){
							field.setValue("");
							Msg.info("error","退货数量不能大于库存数量!");
							IngDretGrid.startEditing(IngDretGridDs.getCount()-1,15);
						}else{
							row.set("dretAmt", count*row.get("rp")); 
							row.set("spAmt", count*row.get("sp")); 
							//row.set("invAmt", count*row.get("rp")); 
						}
					}
				},
				blur:function(field){
					var cell = IngDretGrid.getSelectionModel().getSelectedCell();
					var row = IngDretGridDs.getAt(cell[0]);
					
					var qty = field.getValue();
					if(qty>row.get("stkqty")){
						field.setValue("");
						Msg.info("error","退货数量不能大于库存数量!");
						IngDretGrid.startEditing(IngDretGridDs.getCount()-1,15);
					}else{
						row.set("dretAmt", qty*row.get("rp")); 
						row.set("spAmt", qty*row.get("sp")); 
						//row.set("invAmt", count*row.get("rp")); 
					}
					
				}
			}
        })
    },{
        header:"退货金额",
        dataIndex:'dretAmt',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"退货原因Id",
        dataIndex:'causeId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"退货原因名称",
        dataIndex:'causeName',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"退货原因",
        dataIndex:'cause',
        width:100,
        align:'left',
        sortable:true,
		editor:new Ext.grid.GridEditor(Cause),
		renderer:Ext.util.Format.comboRenderer(Cause)
    },{
        header:"入库日期",
        dataIndex:'idate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"发票号",
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'invNoField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
									
					}
				}
			}
        })
    },{
        header:"发票日期",
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer('Y-m-d'),
		editor: new Ext.form.DateField({
			id:'invDateField',
            allowBlank:false,
			format:'Y-m-d',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();			
					}
				}
			}
        })
    },{
        header:"发票金额",
        dataIndex:'invAmt',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'invAmtField',
            allowBlank:true
        })
    },{
        header:"随行单号",
        dataIndex:'sxNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
            allowBlank:true
        })
    }
]);

//初始化默认排序功能
IngDretGridCm.defaultSortable = true;

var addIngDret = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp("Vendor").setValue("");
		IngDretGridDs.removeAll();
		IngDretDetailGridDs.removeAll();
	}
});

var findIngDret = new Ext.Toolbar.Button({
	text:'查找',
    tooltip:'查找',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		findIngDret();
	}
});

var saveIngDret = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	disabled:true,
	height : 30,
	handler:function(){
		//1.保存主表信息
		var retNo = Ext.getCmp('dret').getValue();
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","请选择类组!");
			return false;
		}
		if((vendorId=="")||(vendorId==null)){
			Msg.info("error","请选择供应商!");
			return false;
		}
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择科室!");
			return false;
		}
		var stkType = "";
		var adjChequeFlag = (Ext.getCmp('transOrder').getValue()==true?'Y':'N');
		var mainInfo=locId+"^"+vendorId+"^"+userId+"^"+scg+"^"+adjChequeFlag;
		var rows = "";
		var count = IngDretDetailGridDs.getCount();
		
		for(var index=0;index<count;index++){
			var row = IngDretDetailGridDs.getAt(index);
			//新增或数据发生变化时执行下述操作
			if(row.data.newRecord || row.dirty){	
				var ingrti = row.get('ingrti'); 	//退货子表rowid(DHC_INGRtItm)
				var ingri = row.get('ingri'); 		//入库子表rowid(DHC_INGdRecItm)
				var qty = row.get('qty'); 			//数量
				var uomId = row.get('uomId'); 		//单位
				var rp = row.get('rp'); 			//进价
				var rpAmt = row.get('rpAmt'); 		//进价金额
				var sp = row.get('sp'); 			//售价
				var spAmt = row.get('spAmt'); //售价金额
				var pp = row.get('pp'); //批价
				var ppAmt = row.get('ppAmt'); //批价金额
				var oldSp = row.get('oldSp'); //批次售价
				var oldSpAmt = row.get('oldSpAmt'); //批次售价金额
				var invNo = row.get('invNo'); //发票号
				var invDate = row.get('invDate'); //发票日期
				if((invDate!="")&&(invDate!=null)){invDate = invDate.format('Y-m-d');}
				var invAmt = row.get('invAmt'); //发票金额
				var sxNo = row.get('sxNo'); //随行单号
				if(sxNo=="undefined"){
					sxNo = "";
				}
				var reason = row.get('retReasonId'); //退货原因
				var aspa = row.get('aspAmt'); //退货调价金额
				
				//
				//退货明细id^入库明细id^数量^单位^进价^售价^发票号^发票日期^发票金额^随行单^退货原因
				var data =  ingrti+"^"+ingri+"^"+qty+"^"+uomId+"^"+rp+"^"+sp+"^"+invNo+"^"+invDate+"^"+invAmt+"^"+sxNo+"^"+reason;
				if(rows!=""){
					rows = rows+","+data;
				}else{
					rows = data;
				}
			}
		}
		Ext.Ajax.request({
			url: URL+'?actiontype=save&ret='+ret+'&MainData='+mainInfo+'&Detail='+rows,
			failure: function(result, request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					//alert(jsonData.info);
					ret =  jsonData.info; //退货单主表Id
					Select(ret);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:ret}});
				}else{
					Msg.info("error","保存失败!");
				}
			},
			scope: this
		});
		
		complete.enable();
    }
});

function Select(Ingrt)
{
	if((Ingrt==null)||(Ingrt=="")){
		return;
	}
	Ext.Ajax.request({
		url:URL+'?actiontype=getOrder&rowid='+Ingrt,
		waitMsg:'查询中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.getCmp('dret').setValue(jsonData.info);
			}
		},
		scope: this
	});
	
}
var deleteIngDret = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = IngDretDetailGrid.getStore().getAt(cell[0]);
			var RowId = record.get("ingrti");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:URL+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										IngDretDetailGridDs.load({params:{start:0,limit:20,sort:'ingrti',dir:'desc',ret:ret}});
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error","数据有错!");
			}
		}
    }
});

var IngDretPagingToolbar = new Ext.PagingToolbar({
    store:IngDretGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['strPar']=Ext.getCmp('locField').getValue()+"^"+IncId+"^"+vendorId+"^"+HospId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	cm:IngDretGridCm,
	trackMouseOver:true,
	height:200,
	stripeRows:true,
	clicksToEdit:0,
	region:'north',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IngDretPagingToolbar
});
//=========================退货管理=================================
var Cause2 = new Ext.form.ComboBox({
	fieldLabel : '退货原因',
	id : 'Cause2',
	name : 'Cause2',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '退货原因...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var row = IngDretDetailGridDs.getAt(IngDretDetailGridDs.getCount()- 1);
				row.set('retReason',field.getRawValue());
				row.set('retReasonId',field.getValue());
			}
		},
		'select':function(combo,record,index){
			var row = IngDretDetailGridDs.getAt(IngDretDetailGridDs.getCount()- 1);
			row.set('retReason',combo.getRawValue());
			row.set('retReasonId',combo.getValue());
		}
	}
});		

function addRow() {
	var rec = Ext.data.Record.create([
		{name : 'ingrti',type : 'string'}, 
		{name : 'ingri',type : 'string'}, 
		{name : 'manf',type : 'string'}, 
		{name : 'inclb',type : 'string'}, 
		{name : 'uom',type : 'string'}, 
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
		{name : 'aspAmt',type : 'double'},
		{name : 'code',type : 'string'},
		{name : 'desc',type : 'string'},
		{name : 'spec',type : 'string'},
		{name : 'batNo',type : 'string'},
		{name : 'expDate',type : 'string'},
		{name : 'retReasonId',type : 'int'},
		{name : 'retReason',type : 'string'},
		{name : 'pp',type : 'double'},
		{name : 'ppAmt',type : 'double'}
	]);
	var NewRec = new rec({
		ingrti:'',
		ingri:'',
		manf:'',
		inclb:'',
		uom:'',
		qty:'',
		rp:'',
		rpAmt:'',
		sp:'',
		spAmt:'',
		invNo:'',
		invDate:'',
		invAmt:'',
		sxNo:'',
		oldSp:'',
		oldSpAmt:'',
		aspAmt:'',
		code:'',
		desc:'',
		spec:'',
		batNo:'',
		expDate:'',
		retReasonId:'',
		retReason:'',
		pp:'',
		ppAmt:''
	});
					
	IngDretDetailGridDs.add(NewRec);
	IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, 1);
}

var IngDretDetailGrid="";
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
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:'Y-m-d'},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'aspAmt'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'retReasonId'},
		{name:'retReason'},
		{name:'pp'},
		{name:'ppAmt'}
		
		/*
		s ingrti=result.Data("ingrti")   //退货子表rowid(DHC_INGRtItm)
		s ingri=result.Data("ingri")    //入库子表rowid(DHC_INGdRecItm)
		s manf=result.Data("manf")   //厂家 
		s inclb=result.Data("inclb")   //批次DR(INC_ItmLcBt)
		s uom=result.Data("uom")    //单位名称
		s qty=result.Data("qty")      //数量
		s rp=result.Data("rp")    //进价
		s rpAmt=result.Data("rpAmt")   //进价金额
		s sp=result.Data("sp")   //售价
		s spAmt=result.Data("spAmt")   //售价金额
		s invNo=result.Data("invNo")    //发票号
		s invDate=result.Data("invDate")  //发票日期
		s invAmt=result.Data("invAmt")    //发票金额
		s sxNo=result.Data("sxNo")    //随行单号
		s oldSp=result.Data("oldSp")   //批次售价
		s oldSpAmt=result.Data("oldSpAmt")   //批次售价金额
		s aspAmt=result.Data("aspAmt")     //退货调价
		s code=result.Data("aspAmt")     //代码 
		s desc=result.Data("desc")   //描述
		s spec =result.Data("spec")   //规格
		s batNo=result.Data("batNo")   //批号
		s expDate=result.Data("expDate")   //效期
		s retReason=result.Data("retReason")   //退货原因
		*/
	]),
    remoteSort:false
});

//模型
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"退货子表rowid",
        dataIndex:'ingrti',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"入库子表rowid",
        dataIndex:'ingri',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"批次DR",
        dataIndex:'inclb',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"规格",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"退货数量",
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"退货单位Id",
        dataIndex:'uomId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"退货单位",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"退货原因Id",
        dataIndex:'retReasonId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"退货原因",
        dataIndex:'retReasonId',
        width:100,
        align:'left',
        sortable:true,
		editor:new Ext.grid.GridEditor(Cause2),
		renderer:Ext.util.Format.comboRenderer(Cause2)
    },{
        header:"退货进价",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"退货金额",
        dataIndex:'dretAmt',
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
        header:"批号",
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"效期",
        dataIndex:'expDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"退发票号",
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"退发票日期",
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer('Y-m-d'),
		editor: new Ext.form.DateField({
			id:'invDateField2',
            allowBlank:false,
			format:'Y-m-d',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();			
					}
				}
			}
        })
    },{
        header:"退发票金额",
        dataIndex:'invAmt',
        width:100,
        align:'right',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'invAmtField2',
            allowBlank:true
        })
    },{
        header:"随行单号",
        dataIndex:'sxNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
            allowBlank:true
        })
    },{
        header:"退货调价",
        dataIndex:'aspAmt',
        width:100,
        align:'right',
        sortable:true,
		hidden:true
    },{
        header:"批价",
        dataIndex:'pp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"批价金额",
        dataIndex:'ppAmt',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"进价金额",
        dataIndex:'rpAmt',
        width:100,
        align:'left',
        sortable:true
    }
]);

//初始化默认排序功能
IngDretDetailGridCm.defaultSortable = true;

var findVendor = new Ext.Toolbar.Button({
	text:'查找供应商',
    tooltip:'查找供应商',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","请选择类组!");
			return false;
		}
		//科室rowid
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择科室!");
			return false;
		}
		//库存rowid
		if((IncId=="")||(IncId==null)){
			Msg.info("error","请选择库存项!");
			return false;
		}
		//不显示库存为零的供应商
		var noVZV = (Ext.getCmp('noViewZeroVendor').getValue()==true?'Y':'N');
		
		//弹出窗口
		var VendorProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectVendor',method:'GET'});
		var VendorDs = new Ext.data.Store({
			proxy: VendorProxy,
			reader: new Ext.data.JsonReader({
				totalProperty:'results',
				root:'rows'
			}, [
			    {name:'vendor'},
		        {name:'vendorName'},
		        {name:'latestRecDate'},
				{name:'venStkQty'},
				{name:'puomDesc'}
			]),
			remoteSort: false
		});
		var VendorCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
		    	header: '供应商名称',
		        dataIndex: 'vendorName',
		        width: 250,
		        sortable:true,
		        align: 'left'
		    },{
		        header: "最近入库日期",
		        dataIndex: 'latestRecDate',
		        width: 100,
		        align: 'center',
		        sortable: true
		    },{
		        header: "库存数量",
		        dataIndex: 'venStkQty',
		        width: 100,
		        align: 'right',
		        sortable: true
		    },{
		        header: "入库单位",
		        dataIndex: 'puomDesc',
		        width: 100,
		        align: 'center',
		        sortable: true
		    }
		]);
		grid = new Ext.grid.GridPanel({
			store:VendorDs,
			cm:VendorCm,
			trackMouseOver: true,
			stripeRows: true,
			sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
			loadMask: true
		});
		
		//strPar - 参数串(库存项目rowid^科室rowid^不包括0库存的供应商(Y/N))
		VendorDs.load({params:{strPar:IncId+"^"+locId+"^"+noVZV}});
		
		var win = new Ext.Window({
			title:'供应商列表',
			width:620,
			height:300,
			minWidth:620, 
			minHeight:300,
			layout:'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:grid
		});

		//显示窗口
		win.show();
		
		grid.on('rowdblclick',function(grid,rowIndex,e){
			var selectedRow = VendorDs.data.items[rowIndex];
			vendorId = selectedRow.data["vendor"];
			vendorName = selectedRow.data["vendorName"];
			Ext.getCmp('Vendor').setValue(vendorId);
			Ext.getCmp('Vendor').setRawValue(vendorName);
			IngDretGridDs.load({params:{strPar:Ext.getCmp('locField').getValue()+"^"+IncId+"^"+vendorId+"^"+HospId,start:0,limit:20}});
			win.close();
			addList.enable();
		});
	}
});

var addList = new Ext.Toolbar.Button({
	text:'加入退货列表',
    tooltip:'加入退货列表',
    iconCls:'page_add',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		var count = IngDretGridDs.getCount();
		for(var j=0;j<count;j++){
			
			var row = IngDretGridDs.getAt(j);
			var INGRI = row.get('INGRI');
			var INCLB = row.get('INCLB');
			var code = row.get('code');
			var desc = row.get('desc');
			var mnf = row.get('mnf');
			var batch = row.get('batch');
			var sven = row.get('sven');
			var pp = row.get('pp');
			var expdate = row.get('expdate');
			var uom = row.get('uom');
			var uomDesc = row.get('uomDesc');
			var idate = row.get('idate');
			var invDate = row.get('invDate');
			var recqty = row.get('recqty');
			var stkqty = row.get('stkqty');
			var rp = row.get('rp');
			//var rpAmt = row.get('rpAmt');
			var sp = row.get('sp');
			var spAmt = row.get('spAmt');
			var invAmt = row.get('invAmt');
			var invNo = row.get('invNo');
			var qty = row.get('dretQty');
			var sxNo = row.get('sxNo');
			var dretAmt = row.get('dretAmt');
			var cause = row.get('causeName');
			var causeId = row.get('causeId');
			var Drugform = row.get('Drugform');
			//alert("cause="+cause+"^causeId="+causeId);
			/*
			s code=result.Data("code")   //代码
			s desc=result.Data("desc")  //描述
			s mnf=result.Data("mnf")    //厂家
			s batch=result.Data("batch")  //批号
			s expdate=result.Data("expdate")  //效期
			s recqty=result.Data("recqty")  //入库数
			s uomDesc=result.Data("uomDesc")  //单位
			s stkqty=result.Data("stkqty")  //现库存数
			s INGRI=result.Data("INGRI")  //入库明细表rowid(DHC_INGdRecItm)
			s pp=result.Data("pp")  //批价
			s sven=result.Data("sven")  //供应商名称
			s idate=result.Data("idate")  //入库日期(入库审核日期)
			s rp=result.Data("rp")  //进价
			s sp=result.Data("sp")  //售价
			s INCLB=result.Data("INCLB")  //批次DR(INC_ItmLcBt)
			s iniflag=result.Data("iniflag")  //初始化标志
			s Drugform=result.Data("Drugform")  //剂型
			s invNo=result.Data("invNo")   //发票号
			s invDate=result.Data("invDate")  //发票日期
			s invAmt=result.Data("invAmt")   //发票金额
			*/
			if(qty>0){
				addRow();
				var rowData = IngDretDetailGridDs.getAt(IngDretDetailGridDs.getCount()-1);
				rowData.set('code',code);
				rowData.set('desc',desc);
				rowData.set('ingri',INGRI);
				rowData.set('inclb',INCLB);
				rowData.set('invNo',invNo);
				rowData.set('qty',qty);
				rowData.set('sp',sp);
				rowData.set('rp',rp);
				rowData.set('batNo',batch);
				rowData.set('expDate',expdate);
				rowData.set('sxNo',sxNo);
				rowData.set('uomId',uom);
				rowData.set('uom',uomDesc);
				rowData.set('spAmt',spAmt);
				rowData.set('rpAmt',rp*qty);
				rowData.set('dretAmt',dretAmt);
				rowData.set('invDate',invDate);
				rowData.set('invAmt',invAmt);
				rowData.set('retReason',cause);
				rowData.set('retReasonId',causeId);
				rowData.set('spec',Drugform);
				rowData.set('manf',mnf);
				rowData.set('pp',pp);
				/*
				s ingrti=result.Data("ingrti")   //退货子表rowid(DHC_INGRtItm)
				s ingri=result.Data("ingri")    //入库子表rowid(DHC_INGdRecItm)
				s manf=result.Data("manf")   //厂家 
				s inclb=result.Data("inclb")   //批次DR(INC_ItmLcBt)
				s uom=result.Data("uom")    //单位名称
				s qty=result.Data("qty")      //数量
				s rp=result.Data("rp")    //进价
				s rpAmt=result.Data("rpAmt")   //进价金额
				s sp=result.Data("sp")   //售价
				s spAmt=result.Data("spAmt")   //售价金额
				s invNo=result.Data("invNo")    //发票号
				s invDate=result.Data("invDate")  //发票日期
				s invAmt=result.Data("invAmt")    //发票金额
				s sxNo=result.Data("sxNo")    //随行单号
				s oldSp=result.Data("oldSp")   //批次售价
				s oldSpAmt=result.Data("oldSpAmt")   //批次售价金额
				s aspAmt=result.Data("aspAmt")     //退货调价
				s code=result.Data("aspAmt")     //代码 
				s desc=result.Data("desc")   //描述
				s spec =result.Data("spec")   //规格
				s batNo=result.Data("batNo")   //批号
				s expDate=result.Data("expDate")   //效期
				s retReason=result.Data("retReason")   //退货原因
				*/
			}
		}
		IngDretGridDs.removeAll();
		addList.disable();
		saveIngDret.enable();
	}
});

var IngDretDetailPagingToolbar = new Ext.PagingToolbar({
    store:IngDretGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='ingrti';
		B['dir']='desc';
		B['ret']=ret;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	height:450,
	stripeRows:true,
	region:'center',
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:['物品名称',pNameField,'-',findVendor,'-',addList,'-','不显示库存为零的项',noViewZeroItem,'-','不显示库存为零的供应商',noViewZeroVendor],
	clicksToEdit:1
});

var formPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		autoScroll:true,
		labelAlign : 'right',
		region:'north',
		height:143,
		frame:true,
		tbar:[addIngDret,'-',findIngDret,'-',saveIngDret,'-',deleteIngDret],
		autoScroll : true,
		bodyStyle : 'padding:0px;',
		items : [{
			autoHeight : true,
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				title : '选项',
				width:1340,
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [{
						columnWidth : .2,
						layout : 'form',
						items : [dretField]
					}, {
						columnWidth : .25,
						layout : 'form',
						items : [locField]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [groupField]
					}, {
						columnWidth : .2,
						layout : 'form',
						items : [dateField]
					}]
				},{
					layout : 'column',
					items : [{
						columnWidth : .2,
						layout : 'form',
						items : [Vendor]
					}, {
						columnWidth : .25,
						layout : 'form',
						items : [transOrder]
					}, {
						columnWidth : .25,
						layout : 'form',
						items : [complete]
					}]
				}]
			}]
		}]
	});
//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var IngDretPanel = new Ext.Panel({
		layout:'border',
    	region:'center',
		title:'退货管理',
		activeTab: 0,
		items:[IngDretGrid,IngDretDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[formPanel,IngDretPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================