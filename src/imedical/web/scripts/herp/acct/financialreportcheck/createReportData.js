var createData=function(){




//����ģ��	
var reportDS=new Ext.data.Store({
    autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
	totalProperty:'results',
	root:'rows'},
	['ReportTempletID','ReportCode','ReportName'])
	
});
reportDS.on('beforeload', function(ds, o){

	ds.proxy=new Ext.data.HttpProxy({
	url:FinancialUrl+'?action=getReportTemplet&BookID='+AcctBook+'&Type='+Ext.getCmp('PerType').getValue(),method:'POST'
	});
});

var ReportTemplete=new Ext.form.ComboBox({
	id:'ReportTemplete',
    fieldLabel:'��������',
    width:200,
    listWidth:180,
	style:'margin-bottom:5px',
    allowBlank:false,
    store:reportDS,
    multiSelect: true,  
    valueField:'ReportTempletID',
    displayField:'ReportName',
    triggerAction:'all',
    emptyText:'��ѡ��Ҫ�������ݵı���',
    name: 'ReportTemplete',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true,
    resizable:true
	
});


var PerTypeDS = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '��'], ['S', '����'], ['H', '����'], ['Y', '��']]
		});
var PerType = new Ext.form.ComboBox({
			id : 'PerType',
			fieldLabel : '�ڼ�����',
			width : 200,
			listWidth : 125,
			selectOnFocus : true,
			style:'margin-bottom:2px',
			allowBlank : false,
			store : PerTypeDS,
			//anchor : '100%',
			value:'M', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			listeners: {
               select: function(){ 
			         var Type=Ext.getCmp('PerType').getValue();
					 //alert(Type);
					
			         AcctMonthDS.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetMonth&Type='+Type,
				     method:'POST'
				  });
				  reportDS.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=getReportTemplet&BookID='+AcctBook+'&Type='+Type,
				     method:'POST'
				  });
				  
				  
				  AcctMonth.setValue("");
				  ReportTemplete.setValue("");
				  AcctMonthDS.load({params : {start:0,limit:12}});
				  reportDS.load({params : {start:0,limit:10}});
				  
			   }
            }
		});
		
var YearDS=new Ext.data.Store({
    autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({
	totalProperty:'results',
	root:'rows'},
	['year','yearh'])
	
});

YearDS.on('beforeload', function(ds, o){

	ds.proxy=new Ext.data.HttpProxy({
	url:FinancialUrl+'?action=getyear&BookID='+AcctBook,method:'POST'
	});
});

var AcctYear=new Ext.form.ComboBox({
	id:'AcctYear',
    fieldLabel:'�������',
    width:200,
    listWidth:180,
	style:'margin-bottom:1px',
    allowBlank:false,
    store:YearDS,
    valueField:'year',
    displayField:'yearh',
    triggerAction:'all',
    emptyText:'��ѡ�����',
    name: 'AcctYear',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true,
    resizable:true
	
});
/*
 var AcctMonthDS=new Ext.data.SimpleStore({
      fields : ['key', 'keyValue'],
	  data : [['01', '01��'],['02', '02��'],['03', '03��'],['04', '04��'],['05', '05��'],['06', '06��'],['07', '07��'],
	  ['08', '08��'],['09', '09��'],['10', '10��'],['11', '11��'],['12', '12��']]
});
*/
var AcctMonthDS = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

 AcctMonthDS.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetMonth&Type='+Ext.getCmp('PerType').getValue()+"&start=0&limit=12",
				     method:'POST'
				  });

var AcctMonth=new Ext.form.ComboBox({
   id:'AcctMonth',
   fieldLabel : '',
	width : 200,
	listWidth : 180,
	style:'margin-bottom:2px',
	store : AcctMonthDS,
	valueNotFoundText : '',
	displayField : 'name',
	valueField : 'rowid',
	mode : 'local', // ����ģʽ
	triggerAction: 'all',
	emptyText:'��ѡ���·�',
	name:"AcctMonth",
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection : true,
	editable:true,
	allowBlank:false
	
});

var formPanel = new Ext.form.FormPanel({
		formId:'formUp',
		labelWidth:80,
		labelAlign:'right',
		bodyStyle:'padding:35 35 35 35',
		height:50,
		width:500,
		frame:true,
		
		fileUpload:true,
		items: [PerType,AcctYear,AcctMonth,ReportTemplete]
	});
	
	//���尴ť
	var CreatB = new Ext.Button({
		text:'��������',
		iconCls:'add'
	});
	
	var CloseB = new Ext.Button({
		text:'�ر�',
		iconCls:'cancel',
		handler:function(){
			window.close();
		}
	});
	
	var callback=function(id){
		//alert(id);
		if(id=='yes'){
		var type= PerType.getValue();
		var year=AcctYear.getValue();
		var month=AcctMonth.getValue();
		var ReportTempletID=ReportTemplete.getValue();
		if(type=="Y"){
			
			var ReportData=AcctBook+"^"+type+"^"+year+"^"+"01"+"^"+userid+"^"+ReportTempletID;
		}else{
			var ReportData=AcctBook+"^"+type+"^"+year+"^"+month+"^"+userid+"^"+ReportTempletID;
		}
		//var ReportData=AcctBook+"^"+type+"^"+year+"^"+month+"^"+userid+"^"+ReportTempletID;
		//alert(ReportData);
	Ext.Ajax.request({
		url:'herp.acct.financialreportcheckexe.csp?action=IfCheck&ReportData='+ReportData,	
				 failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '���ݻ�ȡ���� ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
							//alert("���ݻ�ȡ����")
				},
        success:function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var state=jsonData.info
			if(state==1){
				Ext.Msg.show({
									title : '��ʾ',
									msg : '�����Ѿ����,�����������ɱ������� ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
							});
			}else if(state==0){
		Ext.Ajax.request({
		url : 'herp.acct.financialreportcheckexe.csp?action=createReport&ReportData='+ReportData,
        failure : function(result, request) {
							Ext.Msg.show({
									title : '����',
									msg : '���ݻ�ȡ���� ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
							//alert("���ݻ�ȡ����")
				},
        success:function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var Info=jsonData.info;
			if (jsonData.success == 'true') {
				Ext.Msg.show({
									title : '��ʾ',
									msg : '�����ɹ� ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
							});
			}else{
				if(Info=="isNotAcct"){
					Ext.Msg.show({
									title : '��ʾ',
									msg : '������δ����ƾ֤���������ɱ������� ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
							});
					
				}else if(Info=="error"){
					Ext.Msg.show({
									title : '��ʾ',
									msg : '����ʽ����������ٲ鱨��ʽ��׼ȷ�� ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				}		
					
					}
		}					
				
				
			});
				
			}
		}					
			});
		
		};
	};
	var handler=function(){
		var type= PerType.getValue();
		var year=AcctYear.getValue();
		var month=AcctMonth.getValue();
		var ReportTempletID=ReportTemplete.getValue();
		//alert(year);
		if((year=="")||(month=="")||(ReportTempletID=="")){
			Ext.Msg.show({
									title : '����',
									msg : '��ѡ����Ӧ��������Ϣ ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.WARNING
							});
		}else{
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ���ɱ���������? ',callback);
		}
	};
	CreatB.addListener('click',handler);
	
var window = new Ext.Window({
		title: '���ɱ�������',
		width: 450,
		height:300,
		minWidth: 500,
		minHeight: 300,
		layout: 'fit',
		y:100,
		plain:true,
		modal:true,
		bodyStyle:'padding:20px;',
		buttonAlign:'center',
		items: formPanel,
		
		buttons: [
			CreatB,CloseB
		]
	});
	window.show();
};