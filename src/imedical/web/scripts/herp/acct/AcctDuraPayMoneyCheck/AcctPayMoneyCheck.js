var regPaperUrl='herp.acct.acctPayMoneyCheckMainexe.csp';
var username=session['LOGON.USERNAME'];
var StatusComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 150,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['100','δ���'],['0','ͨ��'],['1','δͨ��']]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			selectOnFocus:'true',
			columnWidth : .13
});	
var CompanyNameText = new Ext.form.TextField({
		fieldLabel : '��Ӧ������',
		id : ' CompanyNameText',
		name : ' CompanyNameText',
		width : 120,
		emptyText : '��Ӧ������'
});	

var yearmonthField = new Ext.form.DateField({
		fieldLabel: '��ʼ����',
		name: 'yearmonth',
		width: 110,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false,
		allowBlank:true
	
	});
	
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	handler: function(){
	   	var Status=StatusComb.getValue();
	   	var Supplier=CompanyNameText.getValue();
		var yearm=yearmonthField.getRawValue();
		var  yearh=yearm.split("-");
		var year=yearh[0];
		var month=yearh[1];
	    mainGrid.load({params:{start:0,limit:25,username:username,year:year,month:month,str:Supplier,status:Status}});
	
}});	
	
var AuditButton  = new Ext.Toolbar.Button({
		text: 'ͨ��',  
        id:'auditButton', 
        iconCls:'option',
        handler:function(){
	   // throughfun();
        
	    
		//���岢��ʼ���ж���
		var rowObj=mainGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		var checker = session['LOGON.USERNAME'];
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var CheckResult=rowObj[0].get("CheckResult");
		
		if(CheckResult!="δ���")
		{
			Ext.Msg.show({title:'ע��',msg:'��������ˣ������ٴ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }
       
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					var PayMoneyMainID=rowObj[i].get("rowid");
					var PayBillNo=rowObj[i].get("PayBillNo");
					var NextCheckNo=rowObj[i].get("NextCheckNo");
					var CheckNo=rowObj[i].get("CheckNo");
					var CheckDesc="";//ͨ���Ͳ�Ҫд�����˰�
					var username   = session['LOGON.USERNAME'];
					var CheckResult=rowObj[i].get("CheckResult");
					var IsLastCheck=rowObj[i].get("IsLastCheck");
					if(CheckResult!="δ���")
				    continue;
					var hospBankNo=rowObj[i].get("hospBankNo");
					if((hospBankNo=="")&&(IsLastCheck==1))
					{
					 Ext.Msg.show({title:'ע��',msg:'�����������Ҫ��ȷ��ҽԺ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			        return;
				    }
					    Ext.Ajax.request({
						url:regPaperUrl+'?action=through&PayMoneyMainID='+PayMoneyMainID+'&PayBillNo='+PayBillNo+'&CheckNo='+CheckNo+'&CheckDesc='+CheckDesc+'&username='+encodeURIComponent(username),
						waitMsg:'�����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0,limit:25,username:username}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'���ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ��˸�����¼��?',handler);
    }
    
});
 var NoAuditButton = new Ext.Toolbar.Button({
					text : '��ͨ��',
					iconCls : 'option',
					handler : function() {
						var rowObj=mainGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						
							 noauditfun();
						
						
						
				   }
  });
   var BankButton1 = new Ext.Toolbar.Button({
	                id: 'BankButton1',
					text : '��Ӹ�������',
					iconCls : 'option',
					handler : function() {
						var rowObj=mainGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						AddBank();
						
						
						
						
				   },
				   listeners : {
					   'render':function()
					   {
						   
						   Ext.Ajax.request({
								url : 'herp.acct.acctPayMoneyCheckMainexe.csp?action=IsLastCheck',
								//waitMsg : '�ɼ���...',
								
								success : function(result, request) {
											var jsonData =result.responseText.trim();
											var username=session['LOGON.USERNAME'];
										
											if(jsonData!=username)
											{
												
												Ext.getCmp('BankButton1').setVisible(false);
										    }
													
								},
								scope : this
				
							});	                
						   
					   }
					   
				   }
  });
var mainGrid = new dhc.herp.Grid({
       // title: '���ʹ�Ӧ�̸���������',
  
        region: 'north',
        height: 300,
        url: 'herp.acct.acctPayMoneyCheckMainexe.csp',
		atLoad : true,
		//tbar:['һά�룺',DimensionCodeText,'-','�ڼ�:',YearComb,'-',MonthComb,'-',SysComb,'-',DataStateComb,'-',StoreManComb,'-',findButton,'-',CollectDataButton,'-',DeleteDataButton,'-',AuditDataButton,'-',CacelDataButton,'-',VoucherCreateButton],
		tbar:['����:',yearmonthField,'-','��Ӧ�����ƻ����:',CompanyNameText,'-','���״̬',StatusComb,'-',findButton,'-',BankButton1,'-',AuditButton,'-',NoAuditButton],

		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '���ʸ������ݲɼ���ID',
		     allowBlank: false,
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'PayBillNo',
		     header: 'ϵͳҵ�����',
		     allowBlank: false,
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
		     allowBlank: false,
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
		     allowBlank: false,
		     align:'left',
		     width:200,
		     editable:false,
		     dataIndex: 'SupplierName'
		}, {
		     id:'BankName',
		     header: '��Ӧ����������',
		     allowBlank: false,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankName'
		}, {
		     id:'BankNo',
		     header: '��Ӧ�������˺�',
		     allowBlank: false,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankNo'
		}, {
		     id:'ActualSum',
		     header: 'ʵ�����',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ActualSum',
		     hidden:true
		}, {
		     id:'ActualCurSum',
		     header: 'ʵ������',
		     allowBlank: true,
		     align:'right',
		     width:80,
		     editable:false,
		     dataIndex: 'ActualCurSum'
		}, {
		     id:'NextCheckNo',
		     header: '�¸��������',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'NextCheckNo',
		     hidden:true
		}, {
		     id:'CheckNo',
		     header: '�������',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'CheckNo',
		     hidden:true
		}, {
		     id:'IsCheck',
		     header: '���״̬',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'IsCheck',
		     hidden:true
		},{
		     id:'IsLastCheck',
		     header: '���״̬',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'IsLastCheck',
		     hidden:true
		},{
		     id:'hospBankName',
		     header: 'ҽԺ������������',
		     allowBlank: true,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'hospBankName'
		},{
		     id:'hospBankNo',
		     header: 'ҽԺ���������˺�',
		     allowBlank: true,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'hospBankNo'
		},{
		     id:'CheckResult',
		     header: '���״̬',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'CheckResult'
		}]
    
    });
    mainGrid.load(({params:{start:0,limit:25,username:username}}));	
    
    
    mainGrid.btnAddHide();  //���ر��水ť
	mainGrid.btnDeleteHide(); //�������ð�ť
	mainGrid.btnSaveHide();  //���ر��水ť
	mainGrid.btnResetHide();  //�������ð�ť
	mainGrid.btnPrintHide();  //���ش�ӡ��ť

	
 mainGrid.on('rowclick',function(grid,rowIndex,e){
var records = mainGrid.getSelectionModel().getSelections();
	var PayMoneyMainID = records[0].get("rowid");	
	LogMain.load({params:{start:0,limit:25,rowid:PayMoneyMainID}});	
});

mainGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var records = mainGrid.getSelectionModel().getSelections();
	var PayBillNo = records[0].get("PayBillNo");
    
	
 	
 	if (columnIndex == 3) 
	{		
		DetailFun(PayBillNo);		
	}
});
/*
mainGrid.getStore().on("load",function()
{
				
			
			var len=mainGrid.getStore().getCount();
		
	
			
            if(len==0)
            {
	        Ext.getCmp('BankButton1').setVisible(false);
            }
			else
			{
		    Ext.getCmp('BankButton1').setVisible(true);
			var record= mainGrid.getStore().getAt(0); 
			var IsLastCheck=record.get('IsLastCheck');
			var SupplierName=record.get('SupplierName');
			
			
			
			if(IsLastCheck=="0")
			{
				
			Ext.getCmp('BankButton1').setVisible(false);
			
			
			}
			}
			  
});

*/
