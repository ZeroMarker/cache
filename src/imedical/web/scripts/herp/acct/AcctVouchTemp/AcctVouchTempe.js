///var  window.str = "addsfas";

var projUrl = 'herp.budg.budgadjustdeptyearauditexe.csp';

var UserID = session['LOGON.USERID'];

// 科目编码///////////////////////////////////

var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {
                     
			ds.proxy = new Ext.data.HttpProxy({
						url:'herp.acct.vouchtempexe.csp'+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),method:'POST'});
					
		});

var yearCombo = new Ext.form.ComboBox({
                        id: 'yearField',
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '年度...',
			width : 60,
			listWidth : 70,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


////////////// 会计期间//////////////////////
var MonthStore=  new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '01'],['2', '02'],['3', '03'],['4', '04'],['5', '05'],['6', '06'],['7', '07'],['8', '08'],['9', '09'],['10', '10'],['11', '11'],['12', '12']]
			});



var MonthCombo = new Ext.form.ComboBox({
	id : 'MonthCombo',
	fieldLabel : '月份',
	width : 60,
	listWidth : 70,
	selectOnFocus : true,
	allowBlank : false,
	store :MonthStore,
	anchor : '95%',			
	displayField : 'keyValue',
	valueField : 'key',
	triggerAction : 'all',
	emptyText : '月份...',
	mode : 'local', // 本地模式
        allowBlank : true,// 不允许为空
	editable : true,
	value:'',
        selectOnFocus : true,
	forceSelection : true
});

//////////////////////按天生成凭证/////////////////////
/*var DayCombo = new Ext.form.DateField({
		fieldLabel : '日期',
		id : 'DayCombo',
		name : 'DayCombo',
		width : 120,
		format:'Y-m-d',
		emptyText : '收入凭证日期...'
});

var vouchDayCombo = new Ext.form.DateField({
		fieldLabel : '日期',
		id : 'vouchCombo',
		name : 'vouchCombo',
		width : 120,
		format:'Y-m-d',
		emptyText : '凭证生成日期...'
});*/

//////////////////// 系统业务名称 //////////////////////
var BusiTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BusiTypeDs.on('beforeload', function(ds, o) {
                     
			ds.proxy = new Ext.data.HttpProxy({
						url:'herp.acct.vouchtempexe.csp'+'?action=getbusitype&str='+encodeURIComponent(Ext.getCmp('BusiTypeCombo').getRawValue()),method:'POST'});
					
		});

var BusiTypeCombo = new Ext.form.ComboBox({
                        id: 'BusiTypeCombo',
			fieldLabel : '系统业务名称',
			store : BusiTypeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '系统业务名称...',
			width : 160,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


////////////// 状态 //////////////////////
var StateStore=  new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '新增'],['2', '记账']]
			});



var StateCombo = new Ext.form.ComboBox({
	id : 'StateCombo',
	fieldLabel : '凭证状态',
	width : 100,
	listWidth : 100,
	selectOnFocus : true,
	allowBlank : false,
	store :StateStore,
	anchor : '95%',			
	displayField : 'keyValue',
	valueField : 'key',
	triggerAction : 'all',
	emptyText : '凭证状态...',
	mode : 'local', // 本地模式
    allowBlank : true,// 不允许为空
	editable : true,
	value:'',
    selectOnFocus : true,
	forceSelection : true
});


///////////////////// 查询  ////////////////////////
var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
	var dayDate="";
	var year = yearCombo.getValue();
	var month= MonthCombo.getValue();
	//var daysDate=DayCombo.getValue();
	//if(daysDate!=""){dayDate=daysDate.format("Y-m-d");}
	//var dayDate=daysDate.format("Y-m-d");
	var BusiType=BusiTypeCombo.getValue();
	var VouchState=StateCombo.getValue();
		
	itemMain.load(({params:{start:0, limit:25,UserID:UserID,year:year,month:month,BusiType:BusiType,VouchState:VouchState,dayDate:dayDate}}));
	
	}
});

///////////////////// 凭证生成  ////////////////////////
var VouchButton = new Ext.Toolbar.Button({
	text: '记账',
    tooltip:'记账',        
    iconCls:'option',
	handler:function(){
	function handler(id) {
	if (id == "yes") {		
	var selectedRow=itemMain.getSelectionModel().getSelections();
	
	var length=selectedRow.length;
	if(length<=0)
	{	
		Ext.Msg.show({title : '注意',
					  msg : '请选择您需要记账的数据',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		});
		
		return;
	}
	
	for(var i=0;i<length;++i)
	{
		var rowid = selectedRow[i].data['rowid'];

		Ext.Ajax.request({
				url : 'herp.acct.vouchtempexe.csp?action=vouchcharge&rowid='+rowid,
				waitMsg : '记账中...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('提示','记账完成');
									itemMain.load({params:{start:0, limit:25,UserID:UserID}});
							} else {
								
									var message = "借贷不相等，借方减贷方/事业收入="+ jsonData.info;
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				},
				scope : this
				
		});
		}
		//findButton.click();	
	}

						
		itemMain.load({params:{start:0, limit:25,UserID:UserID}});
	}
	Ext.MessageBox.confirm('提示', '该条记录确信要记账吗?', handler);
	}
});



//---------------------------删除-----------------------//
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){
		delFun();			
	}
	
});


//////////////////// 取消记账 //////////////////////
var CancelButton = new Ext.Toolbar.Button({
	id:'CancelButton',
	text: '取消记账',
	tooltip: '取消记账',
	iconCls: 'option',
	handler: function(){
	
	function handler(id) {
	if (id == "yes") {		
	var selectedRow=itemMain.getSelectionModel().getSelections();
	
	var length=selectedRow.length;
	if(length<=0)
	{	
		Ext.Msg.show({title : '注意',
					  msg : '请选择您需要取消记账的数据',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
		});
		
		return;
	}
	
	for(var i=0;i<length;++i)
	{
		var rowid = selectedRow[i].data['rowid'];

		Ext.Ajax.request({
				url : 'herp.acct.vouchtempexe.csp?action=cancelcharge&rowid='+rowid,
				waitMsg : '记账取消中...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('提示','记账取消完成');
									itemMain.load({params:{start:0, limit:25,UserID:UserID}});
							} else {
									var message = ""+ jsonData.info;
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				},
				scope : this
				
		});
		}
		//findButton.click();	
	}

						
		itemMain.load({params:{start:0, limit:25,UserID:UserID}});
	}
		Ext.MessageBox.confirm('提示', '该条记录确信要取消记账吗?', handler);
	}
});


var itemMain = new dhc.herp.Grid({
   title: '凭证临时主表',
    region : 'north',
    url: 'herp.acct.vouchtempexe.csp',
    edit:false,
    tbar:['会计年度:',yearCombo,'-','会计期间:',MonthCombo,'-','系统业务:',BusiTypeCombo,'-',StateCombo,'-',searchButton,'-',delButton,'-',VouchButton,'-',CancelButton],
	
    fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
    {	
        id:'rowid',
        header: '凭证临时主表ID',
        hidden: true,
        dataIndex: 'rowid'
    },{
        id:'VouchNo',
        header: '凭证号',
        dataIndex: 'VouchNo',
        width:60,
        hidden: true,
	editable:true,
        allowBlank: false
        
    },{
        id:'AcctBook',
        header: '凭证说明',
        dataIndex: 'AcctBook',
        width:130,
	editable:true,
        allowBlank: false,
        hidden: false
    },{ 
        id:'VouchType',
        header: '凭证类型',
        dataIndex: 'VouchType',
        width:60,
	editable:true,
        allowBlank: false,
	hidden: false
    },{
        id:'AcctYear',
        header: '会计年度',
        width:60,
	allowBlank: true,
        editable:true,
        dataIndex: 'AcctYear'		
    }, {	
        id:'Acctmonth',
        header: '会计期间',
        width:60,
        align: 'left',
	update:true,
	editable:true,
        allowBlank: true,
        dataIndex: 'Acctmonth'	
    },  {
        id:'Vouchdate',
        header: '凭证日期',
        width:90,
	allowBlank: true,
	editable:true,
        dataIndex: 'Vouchdate'		
    }, {
        id:'VouchBillNum',
        header: '附单数据',
        allowBlank: false,
        align: 'right',
        hidden: true,
	width:60,
	editable:true,
        dataIndex: 'VouchBillNum'	
    },{
        id:'Operator',
        header: '制单人',
        allowBlank: false,
        align: 'left',
	width:80,
	editable:true,
        dataIndex: 'Operator'	
    },{
        id:'MakeBilldate',
        header: '制单时间',
        allowBlank: false,
	width:90,
	editable:true,
        dataIndex: 'MakeBilldate'	
    },{
        id:'VouchState',
        header: '凭证状态',
        allowBlank: false,
        align: 'left',
	width:60,
	editable:true,
        dataIndex: 'VouchState'	
    },{
        id:'BusiPlanCode',
        header: '业务单据号',
        allowBlank: false,
        align: 'left',
	width:100,
	editable:true,
        dataIndex: 'BusiPlanCode'	
    },{
        id:'BusiTypeCode',
        header: '系统业务编码',
        allowBlank: false,
        align: 'left',
	width:80,
	editable:true,
        dataIndex: 'BusiTypeCode'	
    },{
        id:'BusiTypeName',
        header: '系统业务名称',
        allowBlank: false,
        align: 'left',
	width:100,
	editable:true,
        dataIndex: 'BusiTypeName'	
    },{
        id:'SysType',
        header: '业务分类汇总',
        allowBlank: true,
        align: 'left',
	width:150,
	editable:true,
        dataIndex: 'SysType'	
    }],
	sm : new Ext.grid.RowSelectionModel({	singleSelect : true	}),
	split : true,
	collapsible : true,
	containerScroll :true,
	xtype : 'grid',
	stripeRows : true,
	loadMask : true,
	height:300,
	trackMouseOver: true

});

itemMain.btnAddHide();    //隐藏增加按钮
itemMain.btnSaveHide();   //隐藏保存按钮
itemMain.btnResetHide();  //隐藏重置按钮
itemMain.btnDeleteHide(); //隐藏删除按钮
itemMain.btnPrintHide();  //隐藏打印按钮
//itemMain.hiddenButton(12) 	//隐藏第n个按钮

itemMain.on('rowclick', function() {
	var selectedRow = itemMain.getSelectionModel().getSelections();
        var acctempID = selectedRow[0].data['rowid'];
        window.str = selectedRow[0].data['TempName'];
        itemDetail.load({params:{start:0, limit:12,acctempID:acctempID}});

})
//给U8发xml
var VoucherCreate=function(str)
{
	var url=u8url	
	var xmlHttp="";

	//alert(url)	
					
	if (window.XMLHttpRequest)
    {
	    
        xmlHttp = new XMLHttpRequest();
        
        if (xmlHttp.overrideMimeType)
        {
            xmlHttp.overrideMimeType("text/xml");
        }
    }
    else if (window.ActiveXObject)
    {
        try
        {    
            xmlHttp = new ActiveXObject("Mscml2.XMLHTTP");
        }
        catch(e)
        {
            try
            {   
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch(ex)
            { }
        }
    }
  
    if(xmlHttp)	 
    {    	
        
		xmlHttp.open("POST",url,true);
		
		xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		
		xmlHttp.send(str);	
			
		//alert("send ok");		
    }
    
    //alert("aa"+xmlHttp.responseText);
	
	/*if (xmlHttp.readyState==4 && xmlhttp.status==200){
		alert("aa"+xmlHttp.responseText);
		}*/
	
 
}

var XmlStr=function()
{
	var selectedRow = itemMain.getSelectionModel().getSelections();
	var length=selectedRow.length;
	
	var str="",curnum="",msgtext;
	
	if(length<1)
		{
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要同步的数据',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
		
Ext.MessageBox.confirm('提示', '请确认是否导入', function(btn){
if(btn=='yes')
{			
	//用友EAI外部注册号
	var senderNo="999"
	for(var i=0;i<length;++i)
	{
		

		if(selectedRow[i].data['VouchState']=="记账") continue;
				
		
		str="<ufinterface roottag=\"voucher\" receiver=\"u8\" sender=\""+senderNo+"\" proc=\"add\" >"+
				"<voucher id=\"\">";
		
		var acctempID = selectedRow[i].data['rowid'];
		var VouchNo=selectedRow[i].data['VouchNo'];
		var VouchType=selectedRow[i].data['VouchType'];
		var AcctYear=selectedRow[i].data['AcctYear'];
		var AcctMonth=selectedRow[i].data['Acctmonth'];
		var MakeBilldate=selectedRow[i].data['Vouchdate'];
		var VouchBillNum=selectedRow[i].data['VouchBillNum'];
		var Operator=selectedRow[i].data['Operator'];
		var BusiTypeCode=selectedRow[i].data['BusiTypeCode'];
		//var vouchDayValue=vouchDayCombo.getValue();
		//if(vouchDayValue!=""){MakeBilldate=vouchDayValue.format("Y-m-d");}
		//alert(MakeBilldate+"^"+vouchDayValue);
		
		if(AcctMonth<="10")
		{
			AcctMonth=AcctMonth.substr(1,2);
		}
			
		str=str+"<voucher_head>"+
					"<company><\/company>"+
					"<voucher_type>"+VouchType+"<\/voucher_type>"+
					"<fiscal_year>"+AcctYear+"<\/fiscal_year>"+
					"<accounting_period>"+AcctMonth+"<\/accounting_period>"+
					"<voucher_id>"+VouchNo+"<\/voucher_id>"+
					"<attachment_number>"+VouchBillNum+"<\/attachment_number>"+
					"<date>"+MakeBilldate+"<\/date>"+
					"<auditdate><\/auditdate>"+
					"<enter>"+Operator+"<\/enter>"+
					"<cashier><\/cashier>"+
					"<signature><\/signature>"+
					"<checker><\/checker>"+
					"<posting_date><\/posting_date>"+
					"<posting_person><\/posting_person>"+
					"<voucher_making_system><\/voucher_making_system>"+
					"<memo1><\/memo1>"+
					"<memo2><\/memo2>"+
					"<reserve1><\/reserve1>"+
					"<reserve2><\/reserve2>"+
					"<revokeflag><\/revokeflag>"+
				"<\/voucher_head>"+
				"<voucher_body>"
		
		
		Ext.Ajax.request({
				url : 'herp.acct.vouchtempdetail.csp?action=getdetaildata&acctempID='+acctempID,
				async: false,
				failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '数据获取错误',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
							//alert("数据获取错误")
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
		
							if (jsonData.success == 'true') {
									var data=jsonData.info;
	
						//alert("组装xml")
						//组装xml		
						BodyData(str,data,BusiTypeCode);
							} else {
									return;
							}
														
				},
				scope : this
				
		});
				
		VouchCreateState(acctempID);
		
	}
		
	itemMain.load({params:{start:0, limit:12,UserID:UserID}});
	
    Ext.Msg.show({
			title : '提示',
			msg : '凭证记账完成',
			buttons : Ext.Msg.OK,
			icon : Ext.MessageBox.INFO
	});
		
		}
	})		
}

var VouchCreateState=function(id)
{
	var info=0;
	
	Ext.Ajax.request({
				url : 'herp.acct.vouchtempexe.csp?action=state&rowid='+id,
				waitMsg : '凭证导入中...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									info=jsonData.info;
							} else {
									var info = jsonData.info;
							}
							
		
				},
				scope : this
				
		});
		
	
		return info;
}

var BodyData=function(strs,data,BusiTypeCode)
{
	

	var arryA=data.split("|"); 
	var len=arryA.length;
	
	var str=strs;
		
	for(var i=1;i<len;++i)
	{
		var arryB=arryA[i].split("*");
		
		str=str+"<entry>"+
						"<entry_id>"+arryB[0]+"<\/entry_id>"+
						"<account_code>"+arryB[1]+"<\/account_code>"+
						"<abstract>"+arryB[2]+"<\/abstract>";
						
		if(BusiTypeCode=="Budg01" && arryB[5]=="0") // 为预算凭证数据 且为不核算科目时
		{
				str=str+"<settlement><\/settlement>"+
						"<document_id><\/document_id>"+
						"<document_date><\/document_date>";
		}
		
		str=str+		"<natural_debit_currency>"+arryB[3]+"<\/natural_debit_currency>"+
						"<natural_credit_currency>"+arryB[4]+"<\/natural_credit_currency>";
						
			if(arryB[5]=="1") // 是否核算
			{
				str=str+"<auxiliary_accounting>";
				
				if(arryB[6]!="") str=str+"<item name=\"dept_id\">"+arryB[6]+"<\/item>";
				
				if(arryB[7]!="") str=str+"<item name=\"personnel_id\">"+arryB[7]+"<\/item>";				
				
				if(arryB[8]!="") str=str+"<item name=\"cust_id\">"+arryB[8]+"<\/item>";
				
				if(arryB[9]!="") str=str+"<item name=\"supplier_id\">"+arryB[9]+"<\/item>";
				
				if(arryB[10]!="") str=str+"<item name=\"item_id\">"+arryB[10]+"<\/item>";
						
				str=str+"<\/auxiliary_accounting>";
					
			}else if(BusiTypeCode=="Budg01") // 不核算  且为预算凭证数据
			{
				str=str+"<auxiliary_accounting>"+
							"<item name=\"dept_id\">"+arryB[6]+"<\/item>"+
							"<item name=\"personnel_id\">"+arryB[7]+"<\/item>"+
							"<item name=\"cust_id\">"+arryB[8]+"<\/item>"+
							"<item name=\"supplier_id\">"+arryB[9]+"<\/item>"+
							"<item name=\"item_id\">"+arryB[10]+"<\/item>"+
							"<item name=\"item_class\"><\/item>"+
							"<item name=\"operator\"><\/item>"+					
						"<\/auxiliary_accounting>";
			}
			
			str=str+"<\/entry>";	

	}
	
	str=str+"<\/voucher_body>"+
			"<\/voucher>"+
		"<\/ufinterface>";
	
	 VoucherCreate(str);		
	
}


function delFun()
{
	var records = itemMain.getSelectionModel().getSelections();
	var len=records.length;
	
	if(len<=0)
	{
		Ext.Msg.show({
						title : '注意',
						msg : '请选择需要删除的数据',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	Ext.MessageBox.confirm('提示', '请确认是否删除', function(btn){
		if(btn=='yes')
		{	
		for(var i=0;i<len;++i)
		{
			var rowid=records[i].get("rowid");
			var state=records[i].get("VouchState");
			var BusiTypeCode=records[i].get("BusiTypeCode");
			var BusiPlanCode=records[i].get("BusiPlanCode");	
			
			if(state=="记账") continue;
		
			Ext.Ajax.request({
						url : 'herp.acct.vouchtempexe.csp?action=del&rowid='+rowid+'&BusiTypeCode='+BusiTypeCode+'&BusiPlanCode='+BusiPlanCode,
						waitMsg : '删除中...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('提示','删除完成');
										itemMain.load({params:{start:0,limit:12,UserID:UserID}});
										itemDetail.load({params:{start:0, limit:12,acctempID:""}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '错误',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});				
			
			}	
		}
		
		})

}
