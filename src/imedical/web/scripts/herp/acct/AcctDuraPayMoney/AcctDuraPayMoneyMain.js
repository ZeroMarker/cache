var username = session['LOGON.USERNAME'];
 getMainJson=""
 getStr=""
 SysType=""
 function changeMoneyToChinese( money )
{
var cnNums = new Array("��","Ҽ","��","��","��","��","½","��","��","��"); //���ֵ�����
var cnIntRadice = new Array("","ʰ","��","Ǫ"); //������λ
var cnIntUnits = new Array("","��","��","��"); //��Ӧ����������չ��λ
var cnDecUnits = new Array("��","��","��","��"); //��ӦС�����ֵ�λ
var cnInteger = "��"; //�������ʱ��������ַ�
var cnIntLast = "Ԫ"; //�������Ժ�ĵ�λ
var maxNum = 999999999999999.9999; //����������

var IntegerNum; //�����������
var DecimalNum; //���С������
var ChineseStr=""; //��������Ľ���ַ���
var parts; //��������õ����飬Ԥ����

if( money == "" ){
return "";
}

money = parseFloat(money);
//alert(money);
if( money >= maxNum ){
$.alert('�������������');
return "";
}
if( money == 0 ){
ChineseStr = cnNums[0]+cnIntLast+cnInteger;
//document.getElementById("show").value=ChineseStr;
return ChineseStr;
}
money = money.toString(); //ת��Ϊ�ַ���
if( money.indexOf(".") == -1 ){
IntegerNum = money;
DecimalNum = '';
}else{
parts = money.split(".");
IntegerNum = parts[0];
DecimalNum = parts[1].substr(0,4);
}
if( parseInt(IntegerNum,10) > 0 ){//��ȡ���Ͳ���ת��
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
zeroCount = 0; //����
ChineseStr += cnNums[parseInt(n)]+cnIntRadice[m];
}
if( m==0 && zeroCount<4 ){
ChineseStr += cnIntUnits[q];
}
}
ChineseStr += cnIntLast;
//���Ͳ��ִ������
}
if( DecimalNum!= '' ){//С������
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
//���ߣ�������
//���ڣ�2015-11-1
//����˵������ʽ�����Ϊ:��ǧ��ʮ��ǧ��ʮԪ�Ƿ�
//����˵����Ҫ���ַ��ͣ�
//����˵�����������飬����Ϊ11
//���������� var arr=FormatMoney("12354.25")
//--------------------------------------
	var jearr = new Array()
	//var je=	"123.56"
	var indxlen=je.indexOf(".")
	
	var zf=je.substr(0,indxlen)
	var jf=je.substr(indxlen+1,2)
	
	zf="��"+zf;
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
//------------------------------------------��д����---------------------------------------------//
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
   // tooltip:'ɾ��',       
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=mainGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var IsCheck=rowObj[0].get("IsCheck");
			var MakeBillPerson=rowObj[0].get("MakeBillPerson");
			
		
			if(!((IsCheck=="")||(IsCheck==0)))
			{
				Ext.Msg.show({title:'ע��',msg:'����˵����ݲ���ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		    }
		    
			if(MakeBillPerson!=username)
			{
				Ext.Msg.show({title:'ע��',msg:'ֻ���Ƶ��˲���ɾ��δ������ݣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
		    }
			
		}
		function handler(id){
			if(id=="yes"){
			
				 
					Ext.Ajax.request({
						url:'herp.acct.acctPayMoneyMainexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0, limit:25}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
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
				waitMsg : '�����...',
				
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
					data : [['1','����'],['2','����'],['3','ҩ��'],['4','ҩƷ'],['5','�̶��ʲ�'],['6','����']]
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
		fieldLabel : '�������ƣ�',
		id : ' BankNameText',
		name : ' BankNameText',
		width : 150
		
});		
        var BankNoText = new Ext.form.TextField({
		fieldLabel : '�����˺�',
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
					data : [['01','�����']]
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
		fieldLabel : '�һ�����',
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
					data : [['1','�ֽ�'],['2','ת��'],['3','֧Ʊ']]
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
		fieldLabel : 'Ӧ�����',
		id : ' PayableText',
		name : ' PayableText',
		width : 120,
		
		columnWidth : .156,
		readOnly:true,
		disabled:true
});	
	var ActualSumText = new Ext.form.TextField({
		fieldLabel : 'ʵ�����',
		id : ' ActualSumText',
		name : ' ActualSumText',
		width : 120,
		
		columnWidth : .145
});	
	var PayableBillNoText = new Ext.form.TextField({
		fieldLabel : 'Ʊ�ݺ�',
		id : ' PayableBillNoText',
		name : ' PayableBillNoText',
		width : 120
		
});	
	var UseText = new Ext.form.TextField({
		fieldLabel : '��;',
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
		fieldLabel : '������Ա',
		id : ' PayPersonText',
		name : 'PayPersonText',
		width : 120
		
});	
	var PayDate = new Ext.form.DateField({
		id : 'PayDate',
		format : 'Y-m-d',
		width : 120

	});

//------------------------------------------��ѯ����---------------------------------------------//
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
			emptyText : '�·�',
			selectOnFocus:'true'
});


/////////////////////////////////////// ������ /////////////////////////////////////////

		
	

//////////////////////////////////////// ����·� //////////////////////////////////////



/////////////////////////////////////// ������ /////////////////////////////////////////
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
			emptyText : '���',
			width : 80,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//////////////////////////////////gongingshang /////////////////////////////
var CompanyName = new Ext.form.TextField({
		fieldLabel : 'ҽԺ����',
		id : ' CompanyName',
		name : ' CompanyName',
		width : 120,
		emptyText : '��Ӧ�����ƻ����'
});		



//////////////////// ��ѯ��ť //////////////////////
var FindButton = new Ext.Toolbar.Button({
	id:'Findbutton',
	text: '��ѯ',
	tooltip: '��ѯ',
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
	text: 'Ӧ��������',
	tooltip: '��Ӧ��Ӧ�������',
	iconCls:'option',
	handler: function(){
	   	SelectFun();
	}
});
var PayMoneyInsertButton = new Ext.Toolbar.Button({
	id:'PayMoneyInsertButton',
	text: '���ɸ��',
	tooltip: '���ɸ��',
	iconCls:'option',
	handler: function(){
	   	InsertFun();
	}
});



///////////////////////����ʾ//////////////////////////////////
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
			value : '<center><p style="font-weight:bold;font-size:120%">��Ӧ�̸������</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '��Ӧ������:',
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
				value : '��������:',
				columnWidth : .09
				},BankNameText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.03
				},{
				xtype : 'displayfield',
				value : '�����˺�:',
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
				value : '��Ӧ�����:',
				columnWidth : .092
				},SysTypeComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.035
				},{
				xtype : 'displayfield',
				value : '��������:',
				columnWidth : .074
				},MoneyTypeComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.027
				},{
				xtype : 'displayfield',
				value : '�һ�����:',
				columnWidth : .067
				},PercentText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : 'Ʊ�ݺ�: ',
				columnWidth : .07
				},PayableBillNoText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},{
				xtype : 'displayfield',
				value : '��;:',
				columnWidth : .035
				},UseText]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : 'Ӧ�����: ',
				columnWidth : .078
				},PayableText,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.030
				},{
				xtype : 'displayfield',
				value : 'ʵ�����:',
				columnWidth : .063
				},ActualSumText,{
				xtype:'displayfield',
				value:'',
				columnWidth:.022
				},{
				xtype : 'displayfield',
				value : '���㷽ʽ:',
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
				value : '�����Ŀ:',
				columnWidth : .057
				},BalanceComb,{
				xtype:'displayfield',
				value:'',
				columnWidth:.014
				},{
				xtype : 'displayfield',
				value : '����:',
				columnWidth : .03
				},DeptComb*/]
	}]
});
var printButtonJSS = new Ext.Toolbar.Button({
	id:'printButtonJSS',
	text: '֧��ƾ����ӡ',
	iconCls: 'add',
	handler: function(){
	var rowObj = mainGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		
		var tmpRowid = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��ӡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{

			var xje=0
			var SupplierName = rowObj[0].get("SupplierName");//��Ӧ������
			var PayableSum = rowObj[0].get("ActualSum");//ʵ�����
			var BankName = rowObj[0].get("BankName")    ;//��������
			var BankNo = rowObj[0].get("BankNo").toString();     	//�����ʺ�
		 
		    var payMoneyUse=rowObj[0].get("payMoneyUse"); 
		
			xje=parseFloat(PayableSum)	
			//Сд���ת��д���
		    var dxje=changeMoneyToChinese(xje)
		
		
		
			//����excel����
			var xlApp,xlsheet,xlBook,arr;
			xlApp = new ActiveXObject("Excel.Application");
			var printFile="http://172.16.51.188/dthealth/web/scripts/herp/acct/print/���д��֧��ƾ��.xls";
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
			xlsheet.cells(10,4).value=dxje;  //��д���
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
	text : '��Ӧ����Ϣ�޸�',
	tooltip : '��Ӧ����Ϣ�޸�',
	iconCls : 'option',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = mainGrid.getSelectionModel().getSelections();;
		// ���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫ�޸ĵ�����!',
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
					fieldLabel : '��Ӧ������',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("SupplierName"),
					emptyText : '��Ӧ������...',
					anchor : '90%',
					selectOnFocus : 'true'
				});
        var BankNoField = new Ext.form.TextField({
					id : 'BankNoField',
					fieldLabel : '��Ӧ�������˺�',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("BankNo"),
					emptyText : '��Ӧ�������˺�...',
					anchor : '90%',
					selectOnFocus : 'true'
				});
		var BankNameField = new Ext.form.TextField({
					id : 'BankNameField',
					fieldLabel : '��Ӧ����������',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("BankName"),
					emptyText : '��Ӧ����������...',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		var ActualSumField = new Ext.form.TextField({
					id : 'ActualSumField',
					fieldLabel : 'ʵ�����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("ActualSumField"),
					emptyText : 'ʵ�����...',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		// ���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [SupplierNameField,BankNoField,BankNameField,ActualSumField]
				});

		// ������
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					SupplierNameField.setValue(rowObj[0].get("SupplierName"));
					BankNoField.setValue(rowObj[0].get("BankNo"));
					BankNameField.setValue(rowObj[0].get("BankName"));
					ActualSumField.setValue(rowObj[0].get("ActualSum"));
				});

		// ���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
					text : '�����޸�'
				});

		// �����޸İ�ť��Ӧ����
		editHandler = function() {
			var username   = session['LOGON.USERNAME'];
			
			var suppliername = SupplierNameField.getValue().trim();
			var bankno = BankNoField.getValue().trim();
			var bankname= BankNameField.getValue().trim();
			var actualsum=ActualSumField.getValue().trim();
		

			if (suppliername == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��Ӧ������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (bankno == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��Ӧ�������ʺ�Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (bankname == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��Ӧ����������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (actualsum == "") {
				Ext.Msg.show({
							title : '����',
							msg : 'ʵ�����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			var updateData=rowid+"^"+SupplierName+"^"+BankNo+"^"+BankName+"^"+ActualSum+"^"+suppliername+"^"+bankno+"^"+bankname+"^"+actualsum ;
			Ext.Ajax.request({
				url : 'herp.acct.acctPayMoneyMainexe.csp?action=Edit&data='
						+ encodeURIComponent(updateData)+'&username='+encodeURIComponent(username),
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
					}
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR,
								fn : Handler
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : 'ע��',
									msg : '�޸ĳɹ�!',
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

		// ��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click', editHandler, false);

		// ���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ���޸�'
				});

		// ����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function() {
			editwin.close();
		}

		// ���ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ���岢��ʼ������
		var editwin = new Ext.Window({
					title : '�޸ļ�¼',
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

		// ������ʾ
		editwin.show();
	}
});

var mainGrid = new dhc.herp.Grid({
       // title: '���ʹ�Ӧ��Ӧ�������',
        width: 400,
        region: 'center',
        url: 'herp.acct.acctPayMoneyMainexe.csp',
		atLoad : true,
		//tbar:['һά�룺',DimensionCodeText,'-','�ڼ�:',YearComb,'-',MonthComb,'-',SysComb,'-',DataStateComb,'-',StoreManComb,'-',findButton,'-',CollectDataButton,'-',DeleteDataButton,'-',AuditDataButton,'-',CacelDataButton,'-',VoucherCreateButton],
		//tbar:[AuditDataButton/*,'-',VoucherCreateButton*/],
        tbar:['��ȣ�',YearComb,'-','�·�:',MonthComb,'-','��Ӧ������',CompanyName,'-',FindButton,'-',delButton,editButton,printButtonJSS],
		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '���ʸ������ݲɼ���ID',
		     
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'PayBillNo',
		     header: '�������',
		     
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
		     header: '��������',
		     
		     width:80,
		     editable:false,
		     hidden:false,
			 //sortable:true,
		     dataIndex: 'PayMonth'
		}, {
		     id:'SupplierCode',
		     header: '��Ӧ�̱���',
		     allowBlank: false,
		     align:'left',		  
		     width:80,
		     editable:false,	     
		     dataIndex: 'SupplierCode'
		     
		
		}, {
		     id:'SupplierName',
		     header: '��Ӧ������',
		    
		     align:'left',
		     width:180,
		     editable:false,
		     dataIndex: 'SupplierName'
		}, {
		     id:'BankName',
		     header: '��Ӧ����������',
		    
		     align:'left',
		     width:100,
		     editable:false,
		     dataIndex: 'BankName'
		}, {
		     id:'BankNo',
		     header: '��Ӧ�������˺�',
		    
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankNo'
		}, {
		     id:'PayableSum',
		     header: 'Ӧ�����',
		    
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'PayableSum',
		     hidden:true
		}, {
		     id:'ActualSum',
		     header: 'ʵ�����',
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
		     header: '�һ�����',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ExchangeRate',
		     hidden:true
		}, {
		     id:'ActualCurSum',
		     header: 'ʵ������',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ActualCurSum',
		     hidden:true
		}, {
		     id:'MakeBillDate',
		     header: '�Ƶ�ʱ��',
		     allowBlank: true,
		     align:'left',
		     width:90,
		     editable:false,
		     dataIndex: 'MakeBillDate'
		}, {
		     id:'MakeBillPerson',
		     header: '�Ƶ���Ա',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'MakeBillPerson'
		}, {
		     id:'IsCheck',
		     header: '�Ƿ����',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'IsCheck',
		     hidden:true
		},{
		     id:'payMoneyUse',
		     header: '��;',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'payMoneyUse',
		     hidden:false
		},{
		     id:'IsCheckResult',
		     header: '���״̬',
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





