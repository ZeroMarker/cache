var gUserId = session['LOGON.USERID'];
var gUserName = session['LOGON.USERNAME'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
function IncApprovalEdit(drugrowid,drugdesc,Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
/**
 * 配置数据源
 */
var Url = 'dhcst.itmapprovalaction.csp';
var AppNumGridProxy= new Ext.data.HttpProxy({url:Url+'?actiontype=QueryAppNumInfo',method:'POST'});
var AppNumGridDs = new Ext.data.Store({
	proxy:AppNumGridProxy,
    reader:new Ext.data.JsonReader({
		totalProperty:'results',
        root:'rows'
    }, ['RowId','InciDr','ManfId','Manf','AppNum','CurrAppNum','AppExp',
		'Logo','ImpLicense','ImpLicExp','UpdDate','UpdUser','AppRet']),
	pruneModifiedRecords:true,
    remoteSort:false
});

//认证情况
var CertificatStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["GMP",'GMP'], ["非GMP",'非GMP']]
});
var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>开始日期</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	width : 300,
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>截止日期</font>',
	id : 'DateTo',
	name : 'DateTo',
	width : 300,
	value : new Date()
});

// 药品类组
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'类组',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	width : 300,
});

var InciDr = new Ext.form.TextField({
	fieldLabel : '药品ID',
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%'
});

var IncDesc = new Ext.form.TextField({
	fieldLabel : '药品名称',
	id : 'IncDesc',
	name : 'IncDesc',
	anchor : '90%',
	disabled:true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var inputText=field.getValue();
				var stkGrp=Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo(inputText,stkGrp);
			}
		}
	}
});

var ApprovalNum1 = new Ext.ux.ComboBox({
	fieldLabel : '批准文号',
	id : 'ApprovalNum1',
	name : 'ApprovalNum1',
	width:140,
	store : INFORemarkStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var ApprovalNum2 = new Ext.form.TextField({
	id : 'ApprovalNum2',
	name : 'ApprovalNum2',
	width:135,
	valueNotFoundText : ''
});

// 生产厂商
var Phmanf = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'Phmanf',
	name : 'Phmanf',
	anchor : '100%',
	width : 300,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
});

var ApprovalNumUp1 = new Ext.ux.ComboBox({
	fieldLabel : '<font color=blue>批准文号</font>',
	id : 'ApprovalNumUp1',
	name : 'ApprovalNumUp1',
	width:140,
	store : INFORemarkStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var ApprovalNumUp2 = new Ext.form.TextField({
	id : 'ApprovalNumUp2',
	name : 'ApprovalNumUp2',
	width : 135,
	valueNotFoundText : ''
});

var AppNumUp1 = new Ext.ux.ComboBox({
	fieldLabel : '原批准文号',
	id : 'AppNumUp1',
	name : 'AppNumUp1',
	width:140,
	store : INFORemarkStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var AppNumUp2 = new Ext.form.TextField({
	id : 'AppNumUp2',
	name : 'AppNumUp2',
	width : 135,
	valueNotFoundText : ''
});

// 生产厂商(维护)
var PhmanfUp = new Ext.ux.ComboBox({
	fieldLabel : '<font color=blue>生产厂商</font>',
	id : 'PhmanfUp',
	name : 'PhmanfUp',
	anchor : '100%',
	width : 330,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName'
});
//批文有效期(维护)
var AppExpUp = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>批文有效期</font>',
	id : 'AppExpUp',
	name : 'AppExpUp',
	anchor : '100%',
	width : 300,
	value :new Date()
});
//注册商标(维护)
var LogoUp = new Ext.form.TextField({
	fieldLabel : '<font color=blue>注册商标</font>',
	id : 'LogoUp',
	name : 'LogoUp',
	width : 280,
});
//进口注册证(维护)
var ImpLicenseUp = new Ext.form.TextField({
	fieldLabel : '进口注册证',
	id : 'ImpLicenseUp',
	name : 'ImpLicenseUp',
	width : 280,
});
//注册证效期(维护)
var ImpLicExpUp = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>注册证效期</font>',
	id : 'ImpLicExpUp',
	name : 'ImpLicExpUp',
	anchor : '100%',
	width : 300,
	value :new Date()
});
//认证情况(维护)
var CertificatFieldUp = new Ext.form.ComboBox({
	id:'CertificatFieldUp',
	fieldLabel:'认证情况',
	width : 280,
	store:CertificatStore,
	valueField:'key',
	displayField:'keyValue',
	mode:'local'
});
//Rowid(维护)
var AppRowidUp = new Ext.form.TextField({
	fieldLabel : 'Rowid',
	id : 'AppRowidUp',
	name : 'AppRowidUp',
	width : 300,
	disabled:true,
	hidden:true
});
// 生产厂商
var PhmanfGrid = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'Manf',
	name : 'Manf',
	width : 300,
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var value=field.getValue();
				if(value==""){
					startCellEditing(AppNumGrid,'ManfId');
				}else{
					startCellEditing(AppNumGrid,'CurrAppNum');
				}
			}
		}
	}
});

var findAppBT = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FineAppNum();
	}
});

var clearAppBT = new Ext.Toolbar.Button({
	text:'清屏',
    tooltip:'清屏',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});

var newAppBT = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		
		addNewRow();
	}
});

var repAppBT = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		saveData();
	}
});
var closeAppBT = new Ext.Toolbar.Button({
	text:'关闭',
    tooltip:'关闭',
    iconCls:'page_close',
	width : 70,
	height : 30,
	handler:function(){
		//window.hide();
		window.close();
	}
});





///模型
var AppNumGridCm=new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
        width:40,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"InciDr",
        dataIndex:'InciDr',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"生产厂商",
        dataIndex:'ManfId',
        width:200,
        align:'left',
        hidden:true,
        sortable:true/*,
		editor : new Ext.grid.GridEditor(PhmanfGrid),
		renderer :Ext.util.Format.comboRenderer2(PhmanfGrid,"ManfId","Manf")	*/ 
    },{
        header:"<font color=blue>生产厂商</font>",
        dataIndex:'Manf',
        width:200,
        align:'left',
        sortable:true 
    },{
        header:"原批准文号",
        dataIndex:'AppNum',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>现批准文号</font>",
        dataIndex:'CurrAppNum',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>批文有效期</font>",
        dataIndex:'AppExp',
        width:100,
        align:'left',
        sortable:true,						
		renderer : function(value){
			return formatDate(value);
		}
    },{
        header:"<font color=blue>注册商标</font>",
        dataIndex:'Logo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"进口注册证",
        dataIndex:'ImpLicense',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"注册证效期",
        dataIndex:'ImpLicExp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"更新日期",
        dataIndex:'UpdDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"更新人",
        dataIndex:'UpdUser',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"认证情况",
        dataIndex:'AppRet',
        width:80,
        align:'left',
        sortable:true//,
        //editor :CertificatField
    }
]);




var PagingToolBar=new Ext.PagingToolbar({
	id:'PagingToolBar',
	store:AppNumGridDs,
	displayInfo:true,
	pageSize:PageSize,
	displayMsg:"当前记录{0}---{1}条  共{2}条记录",
	emptyMsg:"没有数据",
	firstText:'第一页',
	lastText:'最后一页',
	prevText:'上一页',
	refreshText:'刷新',
	nextText:'下一页'		
});

var AppNumGrid=new Ext.grid.GridPanel({
	title:'批文明细',
	id:'AppNumGridPanel',
	region:'center',
	store:AppNumGridDs,
	loadMask:true,
	cm:AppNumGridCm,
	trackMouseOver : true,
	stripeRows : true,
	sm:new Ext.grid.RowSelectionModel({}),
	takeMouseOver:true,
	bbar:PagingToolBar,
	clicksToEdit : 1,
	height:300
});
// 添加表格选取行事件
AppNumGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var selectedRow = AppNumGridDs.data.items[rowIndex];
			var RowId = selectedRow.data['RowId'];
			var ManfId = selectedRow.data['ManfId'];
			var Manf = selectedRow.data['Manf'];
			var AppNum = selectedRow.data['AppNum'];
			var AppNum1=AppNum.split("-")[0];
			var AppNum2=AppNum.split("-")[1];
			var CurrAppNum = selectedRow.data['CurrAppNum'];
			var CurrAppNum1=CurrAppNum.split("-")[0];
			var CurrAppNum2=CurrAppNum.split("-")[1];
			var AppExp = selectedRow.data['AppExp'];
			var Logo= selectedRow.data['Logo'];
			var ImpLicense= selectedRow.data['ImpLicense'];
			var ImpLicExp= selectedRow.data['ImpLicExp'];
			var AppRet= selectedRow.data['AppRet'];	
			Ext.getCmp("AppRowidUp").setValue(RowId); 
			addComboData(PhManufacturerStore,ManfId,Manf);
			Ext.getCmp("PhmanfUp").setValue(ManfId);//生产厂商
			Ext.getCmp("AppNumUp1").setValue(AppNum1); //原批准文号前缀
			Ext.getCmp("AppNumUp2").setValue(AppNum2); //原批准文号
			Ext.getCmp("ApprovalNumUp1").setValue(CurrAppNum1); //新批准文号前缀
			Ext.getCmp("ApprovalNumUp2").setValue(CurrAppNum2); //新批准文号
			Ext.getCmp("AppExpUp").setValue(AppExp); //批文有效期
			Ext.getCmp("LogoUp").setValue(Logo);      //注册商标      
			Ext.getCmp("ImpLicenseUp").setValue(ImpLicense);  //进口注册证
			Ext.getCmp("ImpLicExpUp").setValue(ImpLicExp); //注册证效期
			Ext.getCmp("CertificatFieldUp").setValue(AppRet); //认证情况
	              
	});


///查询条件Panel
var AppNumConPanel=new Ext.form.FormPanel({
	height:100,
	//labelWidth: 60,
	labelAlign : 'right',
	autoScroll:true,
	//autoHeight : true,
	frame : true,
	region:'north',
	bodyStyle : 'padding:0px;',
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout:'column',
		style:'padding:0px 0px 0px 0px',
		defaults:{border:false},
		items:[{
			columnWidth:0.9,
			xtype:'fieldset',
			//defaults:{width:200},
			items:[{xtype:'compositefield',items:[ApprovalNum1,ApprovalNum2]},Phmanf]
		}]
	}]
})
///维护Panel
var AppNumUpPanel=new Ext.form.FormPanel({
	labelAlign : 'right',
	autoScroll:true,
	//autoHeight : true,
	frame : true,
	region:'center',
	bodyStyle : 'padding:0px;',
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items:[{
		xtype:'fieldset',
		title:'维护',
		layout:'column',
		style:'padding:0px 0px 0px 0px',
		defaults:{border:false},
		items:[{
			columnWidth:0.9,
			xtype:'fieldset',
			//defaults:{width:200},
			items:[{xtype:'compositefield',items:[AppNumUp1,AppNumUp2]},
			       {xtype:'compositefield',items:[ApprovalNumUp1,ApprovalNumUp2]},PhmanfUp,
			       LogoUp,ImpLicenseUp,AppExpUp,ImpLicExpUp,CertificatFieldUp,AppRowidUp]
		}]
	}]
})

//=====================Event============================
/**
 * 调用药品窗体并返回结果
 */
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
				getDrugList);
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	
	Ext.getCmp("InciDr").setValue(inciDr);
	Ext.getCmp("IncDesc").setValue(inciDesc);
}

/**
 * 明细药品名称栏调用
 */
function GetPhaDrgInfo(item, group)
{
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
			setAppNunGridList);
	}
}

/**
 * 返回方法
 */
function setAppNunGridList(drugrowid) {
	if (drugrowid == null || drugrowid == "") {
		return;
	}
	var inciDr = drugrowid;
	///获取原批准文号
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
	Ext.Ajax.request({
		url: Url+'?actiontype=CheckExist',
		params:{inciDr:inciDr},
		failure: function(result, request) {
			 mask.hide();
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			 mask.hide();
			if (jsonData.success=='true') {
				var oldAppNum = jsonData.info;
				/*var oldAppNum1=oldAppNum.split("-")[0];
				var oldAppNum2=oldAppNum.split("-")[1];
				Ext.getCmp("AppNumUp1").setValue(oldAppNum1);
				Ext.getCmp("AppNumUp2").setValue(oldAppNum2);*/
				
			}else{
				if(jsonData.info!=0){
				        //Msg.info("error","此药品当天存在更新记录");
					//startCellEditing(AppNumGrid,'ManfId');
				}
				
			}
		},
		scope: this
	});
}

/**
 * 查询
 */
function FineAppNum(){
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
  
	if(StartDate==null || StartDate==""){
		Msg.info("warning","开始日期不能为空!");
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning","截止日期不能为空!");
		return;
	}
	
	var ManfId=Ext.getCmp("Phmanf").getValue();           //厂家ID
	var ApprovalNum1=Ext.getCmp("ApprovalNum1").getValue();
	var ApprovalNum2=Ext.getCmp("ApprovalNum2").getRawValue();
	var ApprovalNum=ApprovalNum1+"-"+ApprovalNum2
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}

	var pageSize=PagingToolBar.pageSize;
	AppNumGrid.store.removeAll();
	AppNumGridDs.setBaseParam("ApprovalNum",ApprovalNum);
	AppNumGridDs.setBaseParam("ManfId",ManfId);
	AppNumGridDs.setBaseParam("InciDr",IncRowid);
	AppNumGridDs.load({params:{start:0,limit:pageSize}});
	AppNumGridDs.removeAll();
	AppNumGridDs.on('load',function(){
		if (AppNumGridDs.getCount()>0){
			//AppNumGrid.getSelectionModel().selectFirstRow();
			//AppNumGrid.getView().focusRow(0);
		}
	}); 
}

/**
 * 新建
 */	
function addNewRow() {
	
	// 判断是否已经有添加行
	var rowCount = AppNumGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = AppNumGridDs.data.items[rowCount - 1];
		var data = rowData.get("InciDr");
		if (data == null || data.length <= 0) {
			AppNumGrid.startEditing(AppNumGridDs.getCount() - 1, 4);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'string'
		},{
			name : 'InciDr',
			type : 'string'
		}/*,{
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'Uom',
			type : 'string'
		}*/, {
			name : 'ManfId',
			type : 'string'
		}, {
			name : 'Manf',
			type : 'string'
		}, {
			name : 'AppNum',
			type : 'string'
		}, {
			name : 'CurrAppNum',
			type : 'string'
		}, {
			name : 'AppExp',
			type : 'date'
		}, {
			name : 'Logo',
			type : 'string'
		}, {
			name : 'ImpLicense',
			type : 'string'
		}, {
			name : 'ImpLicExp',
			type : 'date'
		}, {
			name : 'UpdDate',
			type : 'string'
		}, {
			name : 'UpdUser',
			type : 'string'
		}, {
			name : 'AppRet',
			type : 'string'
		}
	]);

	var NewRecord = new record({
		RowId:'', InciDr:'', ManfId:'', Manf:'', AppNum:'', CurrAppNum:'', AppExp:'', 
		Logo:'', ImpLicense:'', ImpLicExp:'', UpdDate:'', UpdUser:'', AppRet:''
	});

	AppNumGridDs.add(NewRecord);
	AppNumGrid.getSelectionModel().select(AppNumGridDs.getCount() - 1, 4);
	var newcolIndex=GetColIndex(AppNumGrid,'ManfId');
	AppNumGrid.startEditing(AppNumGridDs.getCount() - 1, newcolIndex);
	
	var cell = AppNumGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = AppNumGrid.getStore().getAt(row);
	
	rowData.set("AppExp",new Date().format(App_StkDateFormat));
	rowData.set("ImpLicExp",new Date().format(App_StkDateFormat));
	rowData.set("UpdDate",new Date().format(App_StkDateFormat));
	rowData.set("UpdUser",gUserName);
	
}

/**
 * 保存
 */
function saveData(){
	var ListDate="";
	var IrId=Ext.getCmp("AppRowidUp").getValue(); //id
	var Inci =drugrowid                           //incid
	var ManfId = Ext.getCmp("PhmanfUp").getValue();//生产厂商
	var Logo =Ext.getCmp("LogoUp").getValue().trim();      //注册商标
	var AppRet =Ext.getCmp("CertificatFieldUp").getValue().trim(); //认证情况
	var AppExp =Ext.getCmp("AppExpUp").getValue().format(App_StkDateFormat).toString();; //批文有效期
	var AppNum1 =Ext.getCmp("AppNumUp1").getValue(); //原批准文号前缀
	var AppNum2 =Ext.getCmp("AppNumUp2").getValue().trim(); //原批准文号
	var AppNum=AppNum1+"-"+AppNum2
	var UpdDate =""                                //更新日期
	var CurrAppNum1 =Ext.getCmp("ApprovalNumUp1").getValue(); //新批准文号前缀
	var CurrAppNum2 =Ext.getCmp("ApprovalNumUp2").getValue().trim(); //新批准文号
	var CurrAppNum=CurrAppNum1+"-"+CurrAppNum2
	var ImpLicense=Ext.getCmp("ImpLicenseUp").getValue().trim();  //进口注册证
	var ImpLicExp=Ext.getCmp("ImpLicExpUp").getValue().format(App_StkDateFormat).toString();; //注册证效期
	if(Inci==""){
		Msg.info("error","药品信息为空请查实！");
		return;
	}
	if(ManfId==""){
		Msg.info("error","生产厂商不能为空");
		return;
	}
	if(CurrAppNum1==""){
		Msg.info("error","批文前缀不能为空");
		return;
	}
	if(CurrAppNum2==""){
		Msg.info("error","批准文号不能为空");
		return;
	}
	if(Logo==""){
		Msg.info("error","注册商标不能为空");
		return;
	}
	if(AppExp==""){
		Msg.info("error","批文效期不能为空");
		return;
	}
	if(ImpLicExp==""){
		Msg.info("error","注册证效期不能为空");
		return;
	}
	if(Inci!=""){
		var dataRow = IrId+"^"+Inci+"^"+ManfId+"^"+Logo+"^"+AppRet+"^"+AppExp+
		"^"+AppNum+"^"+UpdDate+"^"+gUserId+"^"+CurrAppNum+"^"+ImpLicense+"^"+ImpLicExp;
		if(ListDate==""){
			ListDate = dataRow;
		}else{
			ListDate = ListDate+"#"+dataRow;
		}
	}
	if(ListDate==""){
		Msg.info("error","没有修改或添加新数据!");
		return false;
	}else{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: Url+'?actiontype=SaveAppNum',
			params:{ListDate:ListDate},
			failure: function(result, request) {
				 mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					FineAppNum();
					ClearDataM();
					//AppNumGrid.store.removeAll();
					//AppNumGridDs.load({params:{start:0,limit:PagingToolBar.pageSize}});
				}else{
					if (jsonData.info==-11){
						Msg.info("warning","该厂商批准文号已存在!");
					}else if(jsonData.info!=0){
						Msg.info("error","保存失败"+jsonData);
					}
					AppNumGrid.store.removeAll();
					AppNumGridDs.load({params:{start:0,limit:PagingToolBar.pageSize}});
				}
			},
			scope: this
		});
	}
}

/**
 * 清空
 */
function ClearData()
{
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	Ext.getCmp("StkGrpType").getStore().load();
	Ext.getCmp("Phmanf").setValue('');
	AppNumGrid.store.removeAll();
	Ext.getCmp("AppRowidUp").setValue(''); 
	Ext.getCmp("PhmanfUp").setValue('');//生产厂商
	Ext.getCmp("AppNumUp1").setValue(''); //原批准文号前缀
	Ext.getCmp("AppNumUp2").setValue(''); //原批准文号
	Ext.getCmp("ApprovalNumUp1").setValue(''); //新批准文号前缀
	Ext.getCmp("ApprovalNumUp2").setValue(''); //新批准文号
    Ext.getCmp("AppExpUp").setValue(new Date()); //批文有效期
	Ext.getCmp("LogoUp").setValue('');      //注册商标      
	Ext.getCmp("ImpLicenseUp").setValue('');  //进口注册证
	Ext.getCmp("ImpLicExpUp").setValue(new Date()); //注册证效期
	Ext.getCmp("CertificatFieldUp").setValue(''); //认证情况
	Ext.getCmp("ApprovalNum1").setValue('');
	Ext.getCmp("ApprovalNum2").setValue('');
	AppNumGrid.store.removeAll();
	AppNumGridDs.removeAll();
	AppNumGridDs.setBaseParam('ApprovalNum',"");
	AppNumGridDs.setBaseParam("ManfId","");
	AppNumGridDs.setBaseParam("InciDr","");
	AppNumGridDs.load({
		params:{start:0,limit:0},			
		callback : function(r,options, success) {					
			if(success==false){
				Ext.MessageBox.alert("查询错误",AppNumGridDs.reader.jsonData.Error);  
			}         				
		}
	});	
} 
/**
 * 清空维护信息
 */
function ClearDataM()
{
    setAppNunGridList(drugrowid)
	Ext.getCmp("AppRowidUp").setValue(''); 
	Ext.getCmp("PhmanfUp").setValue('');//生产厂商
	Ext.getCmp("AppNumUp1").setValue(''); //原批准文号前缀
	Ext.getCmp("AppNumUp2").setValue(''); //原批准文号
	Ext.getCmp("ApprovalNumUp1").setValue(''); //新批准文号前缀
	Ext.getCmp("ApprovalNumUp2").setValue(''); //新批准文号
    Ext.getCmp("AppExpUp").setValue(new Date()); //批文有效期
	Ext.getCmp("LogoUp").setValue('');      //注册商标      
	Ext.getCmp("ImpLicenseUp").setValue('');  //进口注册证
	Ext.getCmp("ImpLicExpUp").setValue(new Date()); //注册证效期
	Ext.getCmp("CertificatFieldUp").setValue(''); //认证情况
} 

/**
 * 效期验证
 */
function ExpDateValidator(expDate){
	
	if (expDate == null || expDate.length <= 0) {
		return true;
	}
	var today=new Date().format('Y-m-d');
	if(expDate<today){
		return false;
	}
	var days=DaysBetween(expDate,today);
    if(days<30){
    	return false;
    }    
    return true;
}
/**
 * 格式化日期
 */
function formatDate(value){
	if(value instanceof Date){
		return new Date(value).format(App_StkDateFormat);
	}else{
		return value;
	}
}
/**
 * 设置列可编辑
 */
function startCellEditing(Grid,ColName)
{
	var cell = Grid.getSelectionModel().getSelectedCell();
	Grid.startEditing(cell[0], GetColIndex(Grid,ColName));
}
//=========================================================
//Ext.onReady(function()
	var AspAmtPanel=new Ext.Panel({
		activeTab: 0,
		region:'center',
		layout: 'border', 
		items:[AppNumConPanel,AppNumUpPanel]
	})
	var window = new Ext.Window({
				title : '批文信息维护'+'<font color=blue>注:蓝色为必填项</font>',
				width :1200,
				height : 600,
				modal:true,
				layout:'border',
				items: [{         
				  region:'west',
		                height: 300, // give north and south regions a height
		                width: 450, 
                              layout:'fit',
				  items:[AspAmtPanel]  
					 },{   
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
					  items:[AppNumGrid]    
					   }],
			  tbar:[findAppBT,'-',clearAppBT,'-',repAppBT,'-',closeAppBT] 
			});

	window.show();
	Ext.getCmp("InciDr").setValue(drugrowid);
	Ext.getCmp("IncDesc").setValue(drugdesc);
	FineAppNum();
	setAppNunGridList(drugrowid)
	//关闭窗口事件
	window.on('close', function(panel) {
			Fn(drugrowid);
	});
}