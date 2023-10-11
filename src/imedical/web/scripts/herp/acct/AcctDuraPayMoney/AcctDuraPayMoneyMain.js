var username = session['LOGON.USERNAME'];
 getMainJson=""
 getStr=""
 SysType=""
 function changeMoneyToChinese( money )
{
var cnNums = new Array("零","壹","贰","叁","肆","伍","陆","柒","捌","玖"); //汉字的数字
var cnIntRadice = new Array("","拾","佰","仟"); //基本单位
var cnIntUnits = new Array("","万","亿","兆"); //对应整数部分扩展单位
var cnDecUnits = new Array("角","分","毫","厘"); //对应小数部分单位
var cnInteger = "整"; //整数金额时后面跟的字符
var cnIntLast = "元"; //整型完以后的单位
var maxNum = 999999999999999.9999; //最大处理的数字

var IntegerNum; //金额整数部分
var DecimalNum; //金额小数部分
var ChineseStr=""; //输出的中文金额字符串
var parts; //分离金额后用的数组，预定义

if( money == "" ){
return "";
}

money = parseFloat(money);
//alert(money);
if( money >= maxNum ){
$.alert('超出最大处理数字');
return "";
}
if( money == 0 ){
ChineseStr = cnNums[0]+cnIntLast+cnInteger;
//document.getElementById("show").value=ChineseStr;
return ChineseStr;
}
money = money.toString(); //转换为字符串
if( money.indexOf(".") == -1 ){
IntegerNum = money;
DecimalNum = '';
}else{
parts = money.split(".");
IntegerNum = parts[0];
DecimalNum = parts[1].substr(0,4);
}
if( parseInt(IntegerNum,10) > 0 ){//获取整型部分转换
zeroCount = 0;
IntLen = IntegerNum.length;
for( i=0;i<IntLen;i++ ){
n = IntegerNum.substr(i,1);
p = IntLen - i - 1;
q = p / 4;
m = p % 4;
if( n == "0" ){
zeroCount++;
}else{
if( zeroCount > 0 ){
ChineseStr += cnNums[0];
}
zeroCount = 0; //归零
ChineseStr += cnNums[parseInt(n)]+cnIntRadice[m];
}
if( m==0 && zeroCount<4 ){
ChineseStr += cnIntUnits[q];
}
}
ChineseStr += cnIntLast;
//整型部分处理完毕
}
if( DecimalNum!= '' ){//小数部分
decLen = DecimalNum.length;
for( i=0; i<decLen; i++ ){
n = DecimalNum.substr(i,1);
if( n != '0' ){
ChineseStr += cnNums[Number(n)]+cnDecUnits[i];
}
}
}
if( ChineseStr == '' ){
ChineseStr += cnNums[0]+cnIntLast+cnInteger;
}
else if( DecimalNum == '' ){
ChineseStr += cnInteger;
}
return ChineseStr;

}


 function FormatMoney(je){
//-------------------------------
//作者：赵立国
//日期：2015-11-1
//函数说明：格式化金额为:亿千百十万千百十元角分
//参数说明：要求字符型，
//返回说明：返回数组，长度为11
//测试用例： var arr=FormatMoney("12354.25")
//--------------------------------------
	var jearr = new Array()
	//var je=	"123.56"
	var indxlen=je.indexOf(".")
	
	var zf=je.substr(0,indxlen)
	var jf=je.substr(indxlen+1,2)
	
	zf="￥"+zf;
	for(j=1 ;j<9-indxlen;j++)
	{
		zf="#"+zf;
	}
	jeAll=zf+jf;
	
	for(i=0;i<11;i++)
	{
		jearr[i]=jeAll.substr(i,1);
		if (jearr[i]=="#") 
		{
			jearr[i]=""
			}
	}
	return jearr;
	}
//------------------------------------------填写条件---------------------------------------------//
var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj=mainGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var IsCheck=rowObj[0].get("IsCheck");
			var MakeBillPerson=rowObj[0].get("MakeBillPerson");
			
		
			if(!((IsCheck=="")||(IsCheck==0)))
			{
				Ext.Msg.show({title:'注意',msg:'已审核的数据不能删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		    }
		    
			if(MakeBillPerson!=username)
			{
				Ext.Msg.show({title:'注意',msg:'只有制单人才能删除未审核数据！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		    }
			
		}
		function handler(id){
			if(id=="yes"){
			
				 
					Ext.Ajax.request({
						url:'herp.acct.acctPayMoneyMainexe.csp?action=del&rowid='+rowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0, limit:25}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});
var SupplierDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

SupplierDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctPayMoneyMainexe.csp?action=GetSupplier&str='+encodeURIComponent(SupplierComb.getRawValue()),
						method : 'POST'
					});
		});

var SupplierComb = new Ext.form.ComboBox({
			id:'SupplierComb',
			store : SupplierDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			
			width : 120,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .22,
			selectOnFocus : true,
			autoLoad:true
			/*,
		
			listeners : {   
            load : function() {   
                SupplierComb.setValue(SupplierComb.getValue());   
            }   
            
        }   */
		});
		
SupplierComb.on("select", function(cmb, rec, id) {
	    var ovalue=SupplierComb.getValue();
        BankNameText.setValue("");
        BankNoText.setValue("");
        PayableText.setValue("");
		ActualSumText.setValue("");
		getMainJson= "";  
        getStr="";
        Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneymainexe.csp?action=addBankSys&str='+encodeURIComponent(ovalue),
				waitMsg : '审核中...',
				
				success : function(result, request) {
                           
				var jsonData = result.responseText;
				var data=jsonData.split("^");
				var BankName=data[0];
				var BankNo=data[1];
				var Sys=data[2];
				BankNameText.setValue(BankName);
				BankNoText.setValue(BankNo);
				SysTypeComb.setValue(Sys);
				
				
				
				
				}
		});

			
		});
		
var SysTypeComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 150,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['1','总务'],['2','卫材'],['3','药剂'],['4','药品'],['5','固定资产'],['6','其他']]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			selectOnFocus:'true',
			columnWidth : .183
});	


	var BankNameText = new Ext.form.TextField({
		fieldLabel : '银行名称：',
		id : ' BankNameText',
		name : ' BankNameText',
		width : 150
		
});		
        var BankNoText = new Ext.form.TextField({
		fieldLabel : '银行账号',
		id : ' BankNoText',
		name : ' BankNoText',
		width : 150
	   
});		
		
var MoneyTypeComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 160,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['01','人民币']]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			value:'01',
		
			selectOnFocus:'true',
			columnWidth : .169
});	
  var PercentText = new Ext.form.TextField({
		fieldLabel : '兑换比率',
		id : ' PercentText',
		name : ' PercentText',
		width : 120,
		
		value:1,
		columnWidth : .17
});	
var BalanceTypeComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 160,
			anchor: '85%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['1','现金'],['2','转账'],['3','支票']]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
		    value:'2',
			selectOnFocus:'true',
			columnWidth : .146
});	
var BalanceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

BalanceDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctPayMoneyMainexe.csp?action=GetAcctSubj&str='+encodeURIComponent(BalanceComb.getRawValue()),
						method : 'POST'
					});
		});

var BalanceComb = new Ext.form.ComboBox({
			id:'BalanceComb',
			store : BalanceDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
		
			width : 80,
			listWidth : 190,
			pageSize : 10,
			minChars : 1,
			columnWidth : .106,
			selectOnFocus : true
		});
		
		var PayableText = new Ext.form.TextField({
		fieldLabel : '应付金额',
		id : ' PayableText',
		name : ' PayableText',
		width : 120,
		
		columnWidth : .156,
		readOnly:true,
		disabled:true
});	
	var ActualSumText = new Ext.form.TextField({
		fieldLabel : '实付金额',
		id : ' ActualSumText',
		name : ' ActualSumText',
		width : 120,
		
		columnWidth : .145
});	
	var PayableBillNoText = new Ext.form.TextField({
		fieldLabel : '票据号',
		id : ' PayableBillNoText',
		name : ' PayableBillNoText',
		width : 120
		
});	
	var UseText = new Ext.form.TextField({
		fieldLabel : '用途',
		id : ' UseText',
		name : ' UseText',
		width : 120
		
});	
		
		
		var DeptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

DeptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctPayMoneyMainexe.csp?action=GetDept&str='+encodeURIComponent(DeptComb.getRawValue()),
						method : 'POST'
					});
		});

var DeptComb = new Ext.form.ComboBox({
			id:'DeptComb',
			store : DeptDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
		
			width : 80,
			listWidth : 180,
			pageSize : 10,
			minChars : 1,
			columnWidth : .105,
			selectOnFocus : true
		});
		
	var PayPersonText = new Ext.form.TextField({
		fieldLabel : '付款人员',
		id : ' PayPersonText',
		name : 'PayPersonText',
		width : 120
		
});	
	var PayDate = new Ext.form.DateField({
		id : 'PayDate',
		format : 'Y-m-d',
		width : 120

	});

//------------------------------------------查询条件---------------------------------------------//
var MonthComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 80,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['month', 'month'],
					data : [['01','01'],['02','02'],['03','03'],['04','04'],['05','05'],['06','06'],['07','07'],['08','08'],['09','09'],['10','10'],['11','11'],['12','12']]
				}),
			displayField : 'month',
			valueField : 'month',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '月份',
			selectOnFocus:'true'
});


/////////////////////////////////////// 会计年度 /////////////////////////////////////////

		
	

//////////////////////////////////////// 会计月份 //////////////////////////////////////



/////////////////////////////////////// 会计年度 /////////////////////////////////////////
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctPayMoneyMainexe.csp?action=yearlist',
						method : 'POST'
					});
		});

var YearComb = new Ext.form.ComboBox({
			id:'YearComb',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '年度',
			width : 80,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//////////////////////////////////gongingshang /////////////////////////////
var CompanyName = new Ext.form.TextField({
		fieldLabel : '医院名称',
		id : ' CompanyName',
		name : ' CompanyName',
		width : 120,
		emptyText : '供应商名称或编码'
});		



//////////////////// 查询按钮 //////////////////////
var FindButton = new Ext.Toolbar.Button({
	id:'Findbutton',
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	   	var year=YearComb.getValue();
	   	var month=MonthComb.getValue();
		var Supplier=CompanyName.getValue();
		mainGrid.load({params:{start:0,limit:25,year:year,month:month,str:Supplier}});
	}
});

var PayMoneyButton = new Ext.Toolbar.Button({
	id:'PayMoneyButton',
	text: '应付单导入',
	tooltip: '供应商应付款单导入',
	iconCls:'option',
	handler: function(){
	   	SelectFun();
	}
});
var PayMoneyInsertButton = new Ext.Toolbar.Button({
	id:'PayMoneyInsertButton',
	text: '生成付款单',
	tooltip: '生成付款单',
	iconCls:'option',
	handler: function(){
	   	InsertFun();
	}
});



///////////////////////顶显示//////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 160,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:3px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">供应商付款管理</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '供应商名称:',
					columnWidth : .11
				},SupplierComb, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				},{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				},{
				xtype : 'displayfield',
				value : '银行名称:',
				columnWidth : .09
				},BankNameText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.03
				},{
				xtype : 'displayfield',
				value : '银行账号:',
				columnWidth : .08
				},BankNoText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.03
				}, PayMoneyButton
		]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '供应商类别:',
				columnWidth : .092
				},SysTypeComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.035
				},{
				xtype : 'displayfield',
				value : '货币类型:',
				columnWidth : .074
				},MoneyTypeComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.027
				},{
				xtype : 'displayfield',
				value : '兑换比率:',
				columnWidth : .067
				},PercentText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '票据号: ',
				columnWidth : .07
				},PayableBillNoText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '用途:',
				columnWidth : .035
				},UseText]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '应付金额: ',
				columnWidth : .078
				},PayableText,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.030
				},{
				xtype : 'displayfield',
				value : '实付金额:',
				columnWidth : .063
				},ActualSumText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.022
				},{
				xtype : 'displayfield',
				value : '结算方式:',
				columnWidth : .055
				},BalanceTypeComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.013
				},{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				}, PayMoneyInsertButton/*,{
				xtype : 'displayfield',
				value : '结算科目:',
				columnWidth : .057
				},BalanceComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.014
				},{
				xtype : 'displayfield',
				value : '部门:',
				columnWidth : .03
				},DeptComb*/]
	}]
});
var printButtonJSS = new Ext.Toolbar.Button({
	id:'printButtonJSS',
	text: '支出凭单打印',
	iconCls: 'add',
	handler: function(){
	var rowObj = mainGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		
		var tmpRowid = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要打印的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{

			var xje=0
			var SupplierName = rowObj[0].get("SupplierName");//供应商名称
			var PayableSum = rowObj[0].get("ActualSum");//实付金额
			var BankName = rowObj[0].get("BankName")    ;//银行名称
			var BankNo = rowObj[0].get("BankNo").toString();     	//银行帐号
		 
		    var payMoneyUse=rowObj[0].get("payMoneyUse"); 
		
			xje=parseFloat(PayableSum)	
			//小写金额转大写金额
		    var dxje=changeMoneyToChinese(xje)
		
		
		
			//创建excel对象
			var xlApp,xlsheet,xlBook,arr;
			xlApp = new ActiveXObject("Excel.Application");
			var printFile="http://172.16.51.188/dthealth/web/scripts/herp/acct/print/银行存款支出凭单.xls";
			xlBook = xlApp.Workbooks.Add(printFile);
			xlsheet = xlBook.ActiveSheet;
	        var myDate = new Date();
            var year=myDate.getFullYear();
            var month=myDate.getMonth()+1;
            var day=myDate.getDate();
			xlsheet.cells(3,5).value=year;
			xlsheet.cells(3,7).value=month;
			xlsheet.cells(3,9).value=day;
			
	
			xlsheet.cells(4,3).value=SupplierName;
			xlsheet.cells(4,10).value=BankNo;
			
			xlsheet.cells(6,10).value=BankName;
			xlsheet.cells(10,4).value=dxje;  //大写金额
			xlsheet.cells(10,13).value=xje;
	        xlsheet.cells(14,3).value=username;
	        xlsheet.cells(14,13).value=username;
	        xlsheet.cells(8,3).value=payMoneyUse;
	        
			xlApp.Visible=true;
			xlsheet.PrintPreview();
			//xlsheet.printout;
			xlBook.Close (savechanges=false);
			xlApp.Quit();
			
				}	
	return;
	}
});
var editButton = new Ext.Toolbar.Button({
	text : '供应商信息修改',
	tooltip : '供应商信息修改',
	iconCls : 'option',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = mainGrid.getSelectionModel().getSelections();;
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要修改的数据!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
			var SupplierName= rowObj[0].get("SupplierName");
			var BankNo= rowObj[0].get("BankNo");
			var BankName= rowObj[0].get("BankName");
			var ActualSum= rowObj[0].get("ActualSum");
		}

		var SupplierNameField = new Ext.form.TextField({
					id : 'SupplierNameField',
					fieldLabel : '供应商名称',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("SupplierName"),
					emptyText : '供应商名称...',
					anchor : '90%',
					selectOnFocus : 'true'
				});
        var BankNoField = new Ext.form.TextField({
					id : 'BankNoField',
					fieldLabel : '供应商银行账号',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("BankNo"),
					emptyText : '供应商银行账号...',
					anchor : '90%',
					selectOnFocus : 'true'
				});
		var BankNameField = new Ext.form.TextField({
					id : 'BankNameField',
					fieldLabel : '供应商银行名称',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("BankName"),
					emptyText : '供应商银行名称...',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		var ActualSumField = new Ext.form.TextField({
					id : 'ActualSumField',
					fieldLabel : '实付金额',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("ActualSumField"),
					emptyText : '实付金额...',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [SupplierNameField,BankNoField,BankNameField,ActualSumField]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					SupplierNameField.setValue(rowObj[0].get("SupplierName"));
					BankNoField.setValue(rowObj[0].get("BankNo"));
					BankNameField.setValue(rowObj[0].get("BankName"));
					ActualSumField.setValue(rowObj[0].get("ActualSum"));
				});

		// 定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {
			var username   = session['LOGON.USERNAME'];
			
			var suppliername = SupplierNameField.getValue().trim();
			var bankno = BankNoField.getValue().trim();
			var bankname= BankNameField.getValue().trim();
			var actualsum=ActualSumField.getValue().trim();
		

			if (suppliername == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '供应商名称为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (bankno == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '供应商银行帐号为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (bankname == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '供应商银行名称为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (actualsum == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '实付金额为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			var updateData=rowid+"^"+SupplierName+"^"+BankNo+"^"+BankName+"^"+ActualSum+"^"+suppliername+"^"+bankno+"^"+bankname+"^"+actualsum ;
			Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneyMainexe.csp?action=Edit&data='
						+ encodeURIComponent(updateData)+'&username='+encodeURIComponent(username),
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
					}
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR,
								fn : Handler
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : '注意',
									msg : '修改成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK
								});
						mainGrid.load({
									params : {
										start : 0,
										limit : 25
									}
								});
						editwin.close();
					} 
				},
				scope : this
			});
		}

		// 添加保存修改按钮的监听事件
		editButton.addListener('click', editHandler, false);

		// 定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
					text : '取消修改'
				});

		// 定义取消修改按钮的响应函数
		cancelHandler = function() {
			editwin.close();
		}

		// 添加取消按钮的监听事件
		cancelButton.addListener('click', cancelHandler, false);

		// 定义并初始化窗口
		var editwin = new Ext.Window({
					title : '修改记录',
					width : 400,
					height : 200,
					minWidth : 400,
					minHeight : 300,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [editButton, cancelButton]
				});

		// 窗口显示
		editwin.show();
	}
});

var mainGrid = new dhc.herp.Grid({
       // title: '物资供应商应付款管理',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctPayMoneyMainexe.csp',
		atLoad : true,
		//tbar:['一维码：',DimensionCodeText,'-','期间:',YearComb,'-',MonthComb,'-',SysComb,'-',DataStateComb,'-',StoreManComb,'-',findButton,'-',CollectDataButton,'-',DeleteDataButton,'-',AuditDataButton,'-',CacelDataButton,'-',VoucherCreateButton],
		//tbar:[AuditDataButton/*,'-',VoucherCreateButton*/],
        tbar:['年度：',YearComb,'-','月份:',MonthComb,'-','供应商名称',CompanyName,'-',FindButton,'-',delButton,editButton,printButtonJSS],
		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '物资付款数据采集表ID',
		     
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'PayBillNo',
		     header: '付款单编码',
		     
		     width:100,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'PayBillNo',
		     renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						}
		},{
		     id:'PayMonth',
		     header: '所属年月',
		     
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'PayMonth'
		}, {
		     id:'SupplierCode',
		     header: '供应商编码',
		     allowBlank: false,
		     align:'left',		  
		     width:80,
		     editable:false,	     
		     dataIndex: 'SupplierCode'
		     
		
		}, {
		     id:'SupplierName',
		     header: '供应商名称',
		    
		     align:'left',
		     width:180,
		     editable:false,
		     dataIndex: 'SupplierName'
		}, {
		     id:'BankName',
		     header: '供应商银行名称',
		    
		     align:'left',
		     width:100,
		     editable:false,
		     dataIndex: 'BankName'
		}, {
		     id:'BankNo',
		     header: '供应商银行账号',
		    
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankNo'
		}, {
		     id:'PayableSum',
		     header: '应付金额',
		    
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'PayableSum',
		     hidden:true
		}, {
		     id:'ActualSum',
		     header: '实付金额',
		     allowBlank: true,
		     align:'right',
		     width:80,
		     editable:true,
		     dataIndex: 'ActualSum',
		     renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						}
		}, {
		     id:'ExchangeRate',
		     header: '兑换比率',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ExchangeRate',
		     hidden:true
		}, {
		     id:'ActualCurSum',
		     header: '实付本币',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ActualCurSum',
		     hidden:true
		}, {
		     id:'MakeBillDate',
		     header: '制单时间',
		     allowBlank: true,
		     align:'left',
		     width:90,
		     editable:false,
		     dataIndex: 'MakeBillDate'
		}, {
		     id:'MakeBillPerson',
		     header: '制单人员',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'MakeBillPerson'
		}, {
		     id:'IsCheck',
		     header: '是否审核',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'IsCheck',
		     hidden:true
		},{
		     id:'payMoneyUse',
		     header: '用途',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'payMoneyUse',
		     hidden:false
		},{
		     id:'IsCheckResult',
		     header: '审核状态',
		     allowBlank: true,
		     align:'left',
		     width:100,
		     editable:false,
		     dataIndex: 'IsCheckResult',
		     hidden:false
		}]
    
    });
    
mainGrid.btnAddHide();
//mainGrid.btnSaveHide();
mainGrid.btnDeleteHide();
mainGrid.btnPrintHide();
mainGrid.btnResetHide();

mainGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var records = mainGrid.getSelectionModel().getSelections();
	var PayBillNo = records[0].get("PayBillNo");
	
 	
 	if (columnIndex == 3) 
	{		
		DetailFun(PayBillNo);		
	}
});





