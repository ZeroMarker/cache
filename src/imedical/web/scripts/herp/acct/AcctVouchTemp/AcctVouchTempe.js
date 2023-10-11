///var  window.str = "addsfas";

var projUrl = 'herp.budg.budgadjustdeptyearauditexe.csp';

var UserID = session['LOGON.USERID'];

// ��Ŀ����///////////////////////////////////

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
			fieldLabel : '���',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '���...',
			width : 60,
			listWidth : 70,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


////////////// ����ڼ�//////////////////////
var MonthStore=  new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '01'],['2', '02'],['3', '03'],['4', '04'],['5', '05'],['6', '06'],['7', '07'],['8', '08'],['9', '09'],['10', '10'],['11', '11'],['12', '12']]
			});



var MonthCombo = new Ext.form.ComboBox({
	id : 'MonthCombo',
	fieldLabel : '�·�',
	width : 60,
	listWidth : 70,
	selectOnFocus : true,
	allowBlank : false,
	store :MonthStore,
	anchor : '95%',			
	displayField : 'keyValue',
	valueField : 'key',
	triggerAction : 'all',
	emptyText : '�·�...',
	mode : 'local', // ����ģʽ
        allowBlank : true,// ������Ϊ��
	editable : true,
	value:'',
        selectOnFocus : true,
	forceSelection : true
});

//////////////////////��������ƾ֤/////////////////////
/*var DayCombo = new Ext.form.DateField({
		fieldLabel : '����',
		id : 'DayCombo',
		name : 'DayCombo',
		width : 120,
		format:'Y-m-d',
		emptyText : '����ƾ֤����...'
});

var vouchDayCombo = new Ext.form.DateField({
		fieldLabel : '����',
		id : 'vouchCombo',
		name : 'vouchCombo',
		width : 120,
		format:'Y-m-d',
		emptyText : 'ƾ֤��������...'
});*/

//////////////////// ϵͳҵ������ //////////////////////
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
			fieldLabel : 'ϵͳҵ������',
			store : BusiTypeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : 'ϵͳҵ������...',
			width : 160,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


////////////// ״̬ //////////////////////
var StateStore=  new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '����'],['2', '����']]
			});



var StateCombo = new Ext.form.ComboBox({
	id : 'StateCombo',
	fieldLabel : 'ƾ֤״̬',
	width : 100,
	listWidth : 100,
	selectOnFocus : true,
	allowBlank : false,
	store :StateStore,
	anchor : '95%',			
	displayField : 'keyValue',
	valueField : 'key',
	triggerAction : 'all',
	emptyText : 'ƾ֤״̬...',
	mode : 'local', // ����ģʽ
    allowBlank : true,// ������Ϊ��
	editable : true,
	value:'',
    selectOnFocus : true,
	forceSelection : true
});


///////////////////// ��ѯ  ////////////////////////
var searchButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
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

///////////////////// ƾ֤����  ////////////////////////
var VouchButton = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'����',        
    iconCls:'option',
	handler:function(){
	function handler(id) {
	if (id == "yes") {		
	var selectedRow=itemMain.getSelectionModel().getSelections();
	
	var length=selectedRow.length;
	if(length<=0)
	{	
		Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ������Ҫ���˵�����',
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
				waitMsg : '������...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '������������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('��ʾ','�������');
									itemMain.load({params:{start:0, limit:25,UserID:UserID}});
							} else {
								
									var message = "�������ȣ��跽������/��ҵ����="+ jsonData.info;
									Ext.Msg.show({
											title : '����',
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
	Ext.MessageBox.confirm('��ʾ', '������¼ȷ��Ҫ������?', handler);
	}
});



//---------------------------ɾ��-----------------------//
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){
		delFun();			
	}
	
});


//////////////////// ȡ������ //////////////////////
var CancelButton = new Ext.Toolbar.Button({
	id:'CancelButton',
	text: 'ȡ������',
	tooltip: 'ȡ������',
	iconCls: 'option',
	handler: function(){
	
	function handler(id) {
	if (id == "yes") {		
	var selectedRow=itemMain.getSelectionModel().getSelections();
	
	var length=selectedRow.length;
	if(length<=0)
	{	
		Ext.Msg.show({title : 'ע��',
					  msg : '��ѡ������Ҫȡ�����˵�����',
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
				waitMsg : '����ȡ����...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '������������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('��ʾ','����ȡ�����');
									itemMain.load({params:{start:0, limit:25,UserID:UserID}});
							} else {
									var message = ""+ jsonData.info;
									Ext.Msg.show({
											title : '����',
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
		Ext.MessageBox.confirm('��ʾ', '������¼ȷ��Ҫȡ��������?', handler);
	}
});


var itemMain = new dhc.herp.Grid({
   title: 'ƾ֤��ʱ����',
    region : 'north',
    url: 'herp.acct.vouchtempexe.csp',
    edit:false,
    tbar:['������:',yearCombo,'-','����ڼ�:',MonthCombo,'-','ϵͳҵ��:',BusiTypeCombo,'-',StateCombo,'-',searchButton,'-',delButton,'-',VouchButton,'-',CancelButton],
	
    fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
    {	
        id:'rowid',
        header: 'ƾ֤��ʱ����ID',
        hidden: true,
        dataIndex: 'rowid'
    },{
        id:'VouchNo',
        header: 'ƾ֤��',
        dataIndex: 'VouchNo',
        width:60,
        hidden: true,
	editable:true,
        allowBlank: false
        
    },{
        id:'AcctBook',
        header: 'ƾ֤˵��',
        dataIndex: 'AcctBook',
        width:130,
	editable:true,
        allowBlank: false,
        hidden: false
    },{ 
        id:'VouchType',
        header: 'ƾ֤����',
        dataIndex: 'VouchType',
        width:60,
	editable:true,
        allowBlank: false,
	hidden: false
    },{
        id:'AcctYear',
        header: '������',
        width:60,
	allowBlank: true,
        editable:true,
        dataIndex: 'AcctYear'		
    }, {	
        id:'Acctmonth',
        header: '����ڼ�',
        width:60,
        align: 'left',
	update:true,
	editable:true,
        allowBlank: true,
        dataIndex: 'Acctmonth'	
    },  {
        id:'Vouchdate',
        header: 'ƾ֤����',
        width:90,
	allowBlank: true,
	editable:true,
        dataIndex: 'Vouchdate'		
    }, {
        id:'VouchBillNum',
        header: '��������',
        allowBlank: false,
        align: 'right',
        hidden: true,
	width:60,
	editable:true,
        dataIndex: 'VouchBillNum'	
    },{
        id:'Operator',
        header: '�Ƶ���',
        allowBlank: false,
        align: 'left',
	width:80,
	editable:true,
        dataIndex: 'Operator'	
    },{
        id:'MakeBilldate',
        header: '�Ƶ�ʱ��',
        allowBlank: false,
	width:90,
	editable:true,
        dataIndex: 'MakeBilldate'	
    },{
        id:'VouchState',
        header: 'ƾ֤״̬',
        allowBlank: false,
        align: 'left',
	width:60,
	editable:true,
        dataIndex: 'VouchState'	
    },{
        id:'BusiPlanCode',
        header: 'ҵ�񵥾ݺ�',
        allowBlank: false,
        align: 'left',
	width:100,
	editable:true,
        dataIndex: 'BusiPlanCode'	
    },{
        id:'BusiTypeCode',
        header: 'ϵͳҵ�����',
        allowBlank: false,
        align: 'left',
	width:80,
	editable:true,
        dataIndex: 'BusiTypeCode'	
    },{
        id:'BusiTypeName',
        header: 'ϵͳҵ������',
        allowBlank: false,
        align: 'left',
	width:100,
	editable:true,
        dataIndex: 'BusiTypeName'	
    },{
        id:'SysType',
        header: 'ҵ��������',
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

itemMain.btnAddHide();    //�������Ӱ�ť
itemMain.btnSaveHide();   //���ر��水ť
itemMain.btnResetHide();  //�������ð�ť
itemMain.btnDeleteHide(); //����ɾ����ť
itemMain.btnPrintHide();  //���ش�ӡ��ť
//itemMain.hiddenButton(12) 	//���ص�n����ť

itemMain.on('rowclick', function() {
	var selectedRow = itemMain.getSelectionModel().getSelections();
        var acctempID = selectedRow[0].data['rowid'];
        window.str = selectedRow[0].data['TempName'];
        itemDetail.load({params:{start:0, limit:12,acctempID:acctempID}});

})
//��U8��xml
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
						title : 'ע��',
						msg : '��ѡ����Ҫͬ��������',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		}
		
Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ���', function(btn){
if(btn=='yes')
{			
	//����EAI�ⲿע���
	var senderNo="999"
	for(var i=0;i<length;++i)
	{
		

		if(selectedRow[i].data['VouchState']=="����") continue;
				
		
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
									title : '����',
									msg : '���ݻ�ȡ����',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
							//alert("���ݻ�ȡ����")
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
		
							if (jsonData.success == 'true') {
									var data=jsonData.info;
	
						//alert("��װxml")
						//��װxml		
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
			title : '��ʾ',
			msg : 'ƾ֤�������',
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
				waitMsg : 'ƾ֤������...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '������������!',
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
						
		if(BusiTypeCode=="Budg01" && arryB[5]=="0") // ΪԤ��ƾ֤���� ��Ϊ�������Ŀʱ
		{
				str=str+"<settlement><\/settlement>"+
						"<document_id><\/document_id>"+
						"<document_date><\/document_date>";
		}
		
		str=str+		"<natural_debit_currency>"+arryB[3]+"<\/natural_debit_currency>"+
						"<natural_credit_currency>"+arryB[4]+"<\/natural_credit_currency>";
						
			if(arryB[5]=="1") // �Ƿ����
			{
				str=str+"<auxiliary_accounting>";
				
				if(arryB[6]!="") str=str+"<item name=\"dept_id\">"+arryB[6]+"<\/item>";
				
				if(arryB[7]!="") str=str+"<item name=\"personnel_id\">"+arryB[7]+"<\/item>";				
				
				if(arryB[8]!="") str=str+"<item name=\"cust_id\">"+arryB[8]+"<\/item>";
				
				if(arryB[9]!="") str=str+"<item name=\"supplier_id\">"+arryB[9]+"<\/item>";
				
				if(arryB[10]!="") str=str+"<item name=\"item_id\">"+arryB[10]+"<\/item>";
						
				str=str+"<\/auxiliary_accounting>";
					
			}else if(BusiTypeCode=="Budg01") // ������  ��ΪԤ��ƾ֤����
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
						title : 'ע��',
						msg : '��ѡ����Ҫɾ��������',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ�ɾ��', function(btn){
		if(btn=='yes')
		{	
		for(var i=0;i<len;++i)
		{
			var rowid=records[i].get("rowid");
			var state=records[i].get("VouchState");
			var BusiTypeCode=records[i].get("BusiTypeCode");
			var BusiPlanCode=records[i].get("BusiPlanCode");	
			
			if(state=="����") continue;
		
			Ext.Ajax.request({
						url : 'herp.acct.vouchtempexe.csp?action=del&rowid='+rowid+'&BusiTypeCode='+BusiTypeCode+'&BusiPlanCode='+BusiPlanCode,
						waitMsg : 'ɾ����...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('��ʾ','ɾ�����');
										itemMain.load({params:{start:0,limit:12,UserID:UserID}});
										itemDetail.load({params:{start:0, limit:12,acctempID:""}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '����',
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
