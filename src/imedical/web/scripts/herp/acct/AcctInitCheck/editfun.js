editfun = function() {
		var userdr = session['LOGON.USERID'];//登录人ID
		var projUrl = 'herp.acct.acctinitcheckexe.csp';
		var rowObj = itemGrid.getSelectionModel().getSelections();  
		var rowid=rowObj[0].get("rowid");
		/*var AcctCheckTypeID=rowObj[0].get("AcctCheckTypeID"); */
		//var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		//var len = rowObj.length;

//获取会计辅助核算类别//
var CheckTypeNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

CheckTypeNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetAcctCheckType&str='+encodeURIComponent(Ext.getCmp('CheckTypeNameField').getValue()),method:'POST'});
});

var CheckTypeNameField = new Ext.form.ComboBox({
	id: 'CheckTypeNameField',
	fieldLabel: '辅助核算类型',
	width:220,
	listWidth : 220,
	store: CheckTypeNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择核算类型...',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	name: 'CheckTypeName',
	listeners:{
		 select:function(combo,record,index){
			
			AcctCheckTypeID=CheckTypeNameField.getValue();
			//alert(AcctCheckTypeID)
			SubjNameDs.removeAll();
			Ext.getCmp('SubjCodeName').setRawValue()=='';
            Ext.getCmp('SubjCodeName').setValue()=='';
			SubjNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetSubjName&str='+encodeURIComponent(Ext.getCmp('SubjCodeName').getValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
			SubjNameDs.load({params:{start:0,limit:10}});	
		     
			 CheckItemNameDs.removeAll();
			 CheckItemNameField.setValue('');
			 CheckItemNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetTypeItemName&str='+encodeURIComponent(Ext.getCmp('CheckItemNameField').getRawValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
			 CheckItemNameDs.load({params:{start:0,limit:10}});	
		 }
	 }	
});



//获取会计科目//
var SubjNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['SubjCode','SubjNameAll','SubjCodeNameAll'])
});
SubjNameDs.on('beforeload', function(ds, o){

	SubjNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetSubjName&str='+encodeURIComponent(Ext.getCmp('SubjCodeName').getValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
});
var SubjCodeName = new Ext.form.ComboBox({
	id: 'SubjCodeName',
	fieldLabel: '会计科目',
	width:220,
	listWidth : 265,
	allowBlank: true,
	store: SubjNameDs,
	valueField: 'SubjCode',
	displayField: 'SubjCodeNameAll',
	triggerAction: 'all',
	emptyText:'请选择会计科目',
	name: 'SubjCodeName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners : {
				select:{
					fn:function(combo,record,index) { 
					Ext.Ajax.request({			        
						url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetNumOrFc&SubjCode='+SubjCodeName.getValue()+'&acctbookid='+acctbookid,	
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );  
							if (jsonData.success=='true'){
								var data = jsonData.info;
								var bcodes = jsonData.info;
								var arr = bcodes.split("^");
								var IsNum=arr[0];
								var IsFc=arr[1];
								if(IsNum!=1){  //非数量账
									NumField.disable();  //数量禁止输入
									PriceField.disable(); //单价禁止输入
									NumDebitField.disable();
									NumCreditField.disable();
									//非数量账清空数量条目
									NumField.setValue('');
									PriceField.setValue('');
									NumDebitField.setValue('');
									NumCreditField.setValue('');
								}else{
									NumField.enable();
									PriceField.enable();
									NumDebitField.enable();
									NumCreditField.enable();
								};
								if(IsFc!=1){
									ExchRateField.disable(); //汇率禁止填写
									CurrNameField.disable();	//币种类型禁止填写
									AmtField.disable();			//外币金额
									AmtDebitField.disable();
									AmtCreditField.disable();
									//非外币清空条目内容
									ExchRateField.setValue('');
									CurrNameField.setValue('');
									AmtField.setValue('');
									AmtDebitField.setValue('');
									AmtCreditField.setValue('');
								}else{
									ExchRateField.enable();
									CurrNameField.enable();
									AmtField.enable();
									AmtDebitField.enable();
									AmtCreditField.enable();
								};
						
							};
						},
					   scope: this
					});              
					}
                }	
				}
});


//获取科室名称

var CheckItemNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});
//科室名称
CheckItemNameDs.on('beforeload', function(ds, o){
	
	CheckItemNameDs.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=GetTypeItemName&str='+encodeURIComponent(Ext.getCmp('CheckItemNameField').getRawValue())+'&CheckTypeID='+AcctCheckTypeID+'&acctbookid='+acctbookid,method:'POST'})
	
});
var CheckItemNameField = new Ext.form.ComboBox({
	id: 'CheckItemNameField',
	fieldLabel: '辅助核算项',
	width:220,
	listWidth : 220,
	allowBlank: true,
	store: CheckItemNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择所属名称',
	name: 'CheckItemName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//年初余额
var SumField = new Ext.form.TextField({
	fieldLabel: '年初余额',
	width:200,
	selectOnFocus : true
});	

//累计借方金额
var SumDebitField = new Ext.form.TextField({
	fieldLabel: '累计借方金额',
	width:200,
	selectOnFocus : true
});

//累计贷方金额
var SumCreditField = new Ext.form.TextField({
	fieldLabel: '累计贷方金额',
	width:200,
	selectOnFocus : true
});
/////////////////////////////数量/////////////////////////////////////
//年初数量
var NumField = new Ext.form.TextField({
	fieldLabel: '年初数量',
	width:200,
	selectOnFocus : true
});	

//单价
var PriceField = new Ext.form.TextField({
	fieldLabel: '单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价',
	width:200,
	selectOnFocus : true
});	

//累计借方数量
var NumDebitField = new Ext.form.TextField({
	fieldLabel: '累计借方数量',
	width:200,
	selectOnFocus : true
});

//累计贷方数量
var NumCreditField = new Ext.form.TextField({
	fieldLabel: '累计贷方数量',
	width:200,
	selectOnFocus : true
});

////////////////////////////外币///////////////////////////

//年初外币
var AmtField = new Ext.form.TextField({
	fieldLabel: '年初外币金额',
	width:200,
	selectOnFocus : true
});	

//汇率
var ExchRateField = new Ext.form.TextField({
	fieldLabel: '汇&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率',
	width:200,
	enableKeyEvents:true,
	selectOnFocus : true
});

//累计借方外币
var AmtDebitField = new Ext.form.TextField({
	fieldLabel: '累计借方外币金额',
	width:200,
	selectOnFocus : true
});

//累计贷方外币
var AmtCreditField = new Ext.form.TextField({
	fieldLabel: '累计贷方外币金额',
	width:200,
	selectOnFocus : true
});

ExchRateField.on('keyup',function(field,e,op){
	var Sum=SumField.getValue();
	if(Sum==""){
		Ext.Msg.show({
			title:'提示',
			msg:'请输入余额! ',
			buttons: Ext.Msg.OK,
			icon:Ext.MessageBox.WARNING
			
		});
		ExchRateField.setValue("");
		return;
	 }
	//alert(Sum+"*"+ExchRateField.getValue());
	//AmtField.setValue(Ext.util.Format.number(Sum/ExchRateField.getValue(), '0,000.0000'));

});

//提交人
var InitPuterField = new Ext.form.TextField({
	fieldLabel:'提交人',
	width:220,
	selectOnFocus : true,
	name:'InitPuter',
	editable:false
});	

//合同编号
var OrderIDField = new Ext.form.TextField({
	fieldLabel: '合同编号',
	width:220,
	name:'OrderID',
	selectOnFocus : true,
	editable:false
});	

//业务发生日期

var OccurDateField = new Ext.form.DateField({
	id : 'OccurDateField',
	name:'OccurDateField',
	fieldLabel: '业务发生时间',
	//format : 'Y-m-d',
	width : 220,
	emptyText : '',
	value:new Date(),
	editable:true
});

//合同到期日期

var OrderDateField = new Ext.form.DateField({
	id : 'OrderDateField',
	name:'OrderDateField',
	fieldLabel: '合同截止日期',
	//format : 'Y-m-d',
	width : 220,
	emptyText : '',
	editable:true
});

//数量核算标志
var IsNumField = new Ext.form.TextField({
	fieldLabel: '数量核算标志',
	width:220,
	name:'IsNum',
	selectOnFocus : true,
	editable:false
});	
//外币核算标志
var IsFcField = new Ext.form.TextField({
	fieldLabel: '外币核算标志',
	width:220,
	name:'IsFc',
	selectOnFocus : true,
	editable:false
});	

		
//获取币种名称

var CurrNameFieldDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

CurrNameFieldDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetCurrName&str='+encodeURIComponent(Ext.getCmp('CurrNameField').getRawValue()),method:'POST'});
});

var CurrNameField = new Ext.form.ComboBox({
	id: 'CurrNameField',
	fieldLabel: '币&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;种',
	width:220,
	listWidth : 220,
	allowBlank: true,
	store: CurrNameFieldDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择币种类型',
	name: 'CurrName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//修改面板
var colItems=[{
	layout: 'column',
	border: false,
	defaults: {
		columnWidth: '.5',
		bodyStyle:'padding:5px 5px 0',
		border: false
	},            
	items: [{
		xtype: 'fieldset',
		autoHeight: true,
		labelWidth: 100,
		labelSeparator: " ",
		items: [{
			xtype : 'displayfield',
			value : '',
			columnWidth : .1
		},
			CheckTypeNameField,
			SubjCodeName, 
			CheckItemNameField,  
			//DirectionField,
			SumField,	
			SumDebitField,
			SumCreditField
			//OccurDateField,
			//OrderIDField,
			//OrderDateField
		]	 
	}, {
		xtype: 'fieldset',
		autoHeight: true,
		labelWidth: 120,
		labelSeparator: " ",
		items: [{
			xtype : 'displayfield',
			value : '',
			columnWidth : .1
		},
			NumField,
			//PriceField,
			NumDebitField,
			NumCreditField,
			//CurrNameField,
			//ExchRateField, 
			AmtField,
			AmtDebitField,
			AmtCreditField
		]
	}]
}]			
var formPanel = new Ext.form.FormPanel({
	//labelWidth: 100,
	frame: true,
	labelAlign: 'right',
	items: colItems
});
//面板加载

formPanel.on('afterlayout', function(panel, layout){
	this.getForm().loadRecord(rowObj[0]);
	CheckTypeNameField.setValue(rowObj[0].get("CheckTypeName"));
	AcctCheckTypeID=rowObj[0].get("CheckTypeID")

	SubjCodeName.setValue(rowObj[0].get("SubjCodeName"));
	CheckItemNameField.setValue(rowObj[0].get("CheckItemName")); 
	//DirectionField.getValue(rowObj[0].get("Direction"));  
	NumField.setValue(rowObj[0].get("BeginNum"));
	NumDebitField.setValue(rowObj[0].get("TotalDebitNum"));
	NumCreditField.setValue(rowObj[0].get("TotalCreditNum"));
	//PriceField.getValue(rowObj[0].get("Price"));	
	//CurrNameField.getValue(rowObj[0].get("CurrName")); 
	AmtField.setValue(rowObj[0].get("BeginSumF")); 
	AmtDebitField.setValue(rowObj[0].get("TotalDebitSumF"));
	AmtCreditField.setValue(rowObj[0].get("TotalCreditSumF"));
	//ExchRateField.getValue(rowObj[0].get("ExchRate")); 
	//OrderIDField.getValue(rowObj[0].get("OrderID")); 
// 日期控件的获取 示例：	PSField.setValue(rowObj[0].get("plansdate"));
	//OccurDateField.setValue(rowObj[0].get("OccurDate")); 
	//OrderDateField.setValue(rowObj[0].get("OrderDate"));
			 
	SumField.setValue(rowObj[0].get("BeginSum")); 
	SumDebitField.setValue(rowObj[0].get("TotalDebitSum")); 
	SumCreditField.setValue(rowObj[0].get("TotalCreditSum")); 
	IsFcField.getValue(rowObj[0].get("IsFc"));
	IsNumField.getValue(rowObj[0].get("IsNum"));
			
	var SubjCode=SubjCodeName.getValue();
			
	if(SubjCode==rowObj[0].get("SubjCodeName")){
		SubjCode="";
		//alert(rowObj[0].get("IsNum"))
		if((rowObj[0].get("IsNum"))!=1){
			NumField.disable();
			PriceField.disable();
			NumDebitField.disable();
			NumCreditField.disable();
			//非数量清空数量条目
			NumField.setValue('');
			PriceField.setValue('');
			NumDebitField.setValue('');
			NumCreditField.setValue('');
		}else{
			NumField.enable();
			PriceField.enable();
			NumDebitField.enable();
			NumCreditField.enable();
		};
		if((rowObj[0].get("IsFc"))!=1){
			ExchRateField.disable();
			CurrNameField.disable();
			AmtField.disable();
			AmtDebitField.disable();
			AmtCreditField.disable();
			//清空非外币条目
			ExchRateField.setValue('');
			CurrNameField.setValue('');
			AmtField.setValue('');
			AmtDebitField.setValue('');
			AmtCreditField.setValue('');	
		}else{
			ExchRateField.enable();
			CurrNameField.enable();
			AmtField.enable();
			AmtDebitField.enable();
			AmtCreditField.enable();				
		} ;
	}else {
		Ext.Ajax.request({			        
			url: '../csp/herp.acct.acctinitcheckexe.csp?action=GetNumOrFc&SubjCode='+SubjCodeName.getValue()+'&acctbookid='+acctbookid,	
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );  
				if (jsonData.success=='true'){
					var data = jsonData.info;
					var bcodes = jsonData.info;
					var arr = bcodes.split("^");
					var IsNum=arr[0];
					var IsFc=arr[1];
					if(IsNum!=1){
						NumField.disable();
						PriceField.disable();
						NumDebitField.disable();
						NumCreditField.disable();
						//非数量清空数量条目
						NumField.setValue('');
						PriceField.setValue('');
						NumDebitField.setValue('');
						NumCreditField.setValue('');
					}else{
						NumField.enable();
						PriceField.enable();
						NumDebitField.enable();
						NumCreditField.enable();
					};
					if(IsFc!=1){
						ExchRateField.disable();
						CurrNameField.disable();
						AmtField.disable();
						AmtDebitField.disable();
						AmtCreditField.disable();
						//清空非外币条目
						ExchRateField.setValue('');
						CurrNameField.setValue('');
						AmtField.setValue('');
						AmtDebitField.setValue('');
						AmtCreditField.setValue('');	
					}else{
						ExchRateField.enable();
						CurrNameField.enable();
						AmtField.enable();
						AmtDebitField.enable();
						AmtCreditField.enable();
					};				
				};
			},
			scope: this
		});
	}
});
		
//addwin的添加按钮
addButton = new Ext.Toolbar.Button({
		text:'保存',
		iconCls:'save'
	});
	
addHandler = function(){      			
				
	var CheckTypeID		= 	CheckTypeNameField.getValue();
	var SubjCode 		=	SubjCodeName.getValue();
	var CheckItemID		= 	CheckItemNameField.getValue();  
				
	//对于下拉框的取值，如果没有更改则 置为空,否则 后台 取
	if(CheckTypeID==rowObj[0].get("CheckTypeName")){CheckTypeID=""}
	//如果没变
	if(SubjCode==rowObj[0].get("SubjCodeName")){SubjCode=""}
				
	if(CheckItemID==rowObj[0].get("CheckItemName")){CheckItemID=""}
	var Sum 			=	SumField.getValue(); 
	var SumDebit        =   SumDebitField.getValue();
	var SumCredit		=	SumCreditField.getValue();
	var Num				=	NumField.getValue();
	var NumDebit        =   NumDebitField.getValue();
	var NumCredit       =   NumCreditField.getValue();
	var Price			=	PriceField.getValue();	
	var CurrCode		= 	CurrNameField.getValue();
	var CurrCodeText	=	CurrNameField.getRawValue();
				
	var AmtF 			= 	AmtField.getValue(); 
	var AmtDebit        =   AmtDebitField.getValue();
	var AmtCredit		=	AmtCreditField.getValue();
	var ExchRate 		= 	ExchRateField.getValue(); 
	var OrderID			=	OrderIDField.getValue(); 
	var OccurDateTime 		=	OccurDateField.getValue(); 
	if (OccurDateTime!==""){
	  	var OccurDate=OccurDateTime.format ('Y-m-d');
	}
	else {
		var OccurDate="" 
	};
	var OrderDateTime 		=	OrderDateField.getValue();
	if (OrderDateTime!==""){
	   	var OrderDate=OrderDateTime.format ('Y-m-d');
	}
	else{
		var OrderDate="" 
	};
								
	if (CheckTypeNameField.getRawValue()==""){
		Ext.Msg.show({title:'提示',msg:' 会计核算类别不能为空 ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
				
	if(CurrNameField.getRawValue()==""){
		 CurrCode="";
	}else{
		CurrCode=CurrCodeText;
	}
				
	Ext.Ajax.request({
		url: '../csp/herp.acct.acctinitcheckexe.csp?action=update&rowid='+rowid+'&CheckTypeID='+CheckTypeID+'&CheckItemID='+CheckItemID+'&SubjCode='+encodeURIComponent(SubjCode)+'&Num='+Num+'&Price='+Price+'&CurrCode='+encodeURIComponent(CurrCode)+'&AmtF='+AmtF+'&ExchRate='+ExchRate+'&OrderID='+encodeURIComponent(OrderID)+'&OccurDate='+OccurDate+'&OrderDate='+OrderDate+'&Sum='+Sum+'&acctbookid='+acctbookid+'&SumDebit='+SumDebit+'&SumCredit='+SumCredit+'&NumDebit='+NumDebit+'&NumCredit='+NumCredit+'&AmtDebit='+AmtDebit+'&AmtCredit='+AmtCredit,
		waitMsg:'保存中...',
		failure: function(result, request){
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode( result.responseText );					
			if (jsonData.success=='true'){
				Ext.Msg.show({title:'注意',msg:'修改成功',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
				itemGrid.load({params:{start:0,limit:25,userdr:userdr,acctbookid:acctbookid}});			
			}else if (jsonData.success == 'false'){
				var information = jsonData.info;
				if (information == "RecordExist"){
					Ext.Msg.show({title: '提示',msg: '此数据已存在，请进行修改! ',
						buttons: Ext.Msg.OK,icon: Ext.MessageBox.INFO});
				}else{
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		scope: this
	});
	editwin.close();		
}

	////// 添加监听事件 ////////////////	
addButton.addListener('click',addHandler,false);


///addwin的取消按钮
cancelButton = new Ext.Toolbar.Button({
			text:'取消',
			iconCls:'back'
		});
cancelHandler = function(){
			editwin.close();
		}
cancelButton.addListener('click',cancelHandler,false);

editwin = new Ext.Window({
			title: '修改记录',
			width: 720,
			height: 325,
			//autoHeight: true,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});		
editwin.show();			
}

   				
			