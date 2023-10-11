var regPaperUrl='herp.acct.acctPayMoneyCheckMainexe.csp';
var username=session['LOGON.USERNAME'];
var StatusComb = new Ext.form.ComboBox({												
			width:60,
			listWidth : 150,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['100','未审核'],['0','通过'],['1','未通过']]
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
		fieldLabel : '供应商名称',
		id : ' CompanyNameText',
		name : ' CompanyNameText',
		width : 120,
		emptyText : '供应商名称'
});	

var yearmonthField = new Ext.form.DateField({
		fieldLabel: '起始年月',
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
	text: '查询',
	tooltip: '查询',
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
		text: '通过',  
        id:'auditButton', 
        iconCls:'option',
        handler:function(){
	   // throughfun();
        
	    
		//定义并初始化行对象
		var rowObj=mainGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERNAME'];
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		var CheckResult=rowObj[0].get("CheckResult");
		
		if(CheckResult!="未审核")
		{
			Ext.Msg.show({title:'注意',msg:'数据已审核，不能再次审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }
       
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					var PayMoneyMainID=rowObj[i].get("rowid");
					var PayBillNo=rowObj[i].get("PayBillNo");
					var NextCheckNo=rowObj[i].get("NextCheckNo");
					var CheckNo=rowObj[i].get("CheckNo");
					var CheckDesc="";//通过就不要写理由了吧
					var username   = session['LOGON.USERNAME'];
					var CheckResult=rowObj[i].get("CheckResult");
					var IsLastCheck=rowObj[i].get("IsLastCheck");
					if(CheckResult!="未审核")
				    continue;
					var hospBankNo=rowObj[i].get("hospBankNo");
					if((hospBankNo=="")&&(IsLastCheck==1))
					{
					 Ext.Msg.show({title:'注意',msg:'最后审批人需要先确认医院付款银行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			        return;
				    }
					    Ext.Ajax.request({
						url:regPaperUrl+'?action=through&PayMoneyMainID='+PayMoneyMainID+'&PayBillNo='+PayBillNo+'&CheckNo='+CheckNo+'&CheckDesc='+CheckDesc+'&username='+encodeURIComponent(username),
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								mainGrid.load({params:{start:0,limit:25,username:username}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
    
});
 var NoAuditButton = new Ext.Toolbar.Button({
					text : '不通过',
					iconCls : 'option',
					handler : function() {
						var rowObj=mainGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						
							 noauditfun();
						
						
						
				   }
  });
   var BankButton1 = new Ext.Toolbar.Button({
	                id: 'BankButton1',
					text : '添加付款银行',
					iconCls : 'option',
					handler : function() {
						var rowObj=mainGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						AddBank();
						
						
						
						
				   },
				   listeners : {
					   'render':function()
					   {
						   
						   Ext.Ajax.request({
								url : 'herp.acct.acctPayMoneyCheckMainexe.csp?action=IsLastCheck',
								//waitMsg : '采集中...',
								
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
       // title: '物资供应商付款管理审核',
  
        region: 'north',
        height: 300,
        url: 'herp.acct.acctPayMoneyCheckMainexe.csp',
		atLoad : true,
		//tbar:['一维码：',DimensionCodeText,'-','期间:',YearComb,'-',MonthComb,'-',SysComb,'-',DataStateComb,'-',StoreManComb,'-',findButton,'-',CollectDataButton,'-',DeleteDataButton,'-',AuditDataButton,'-',CacelDataButton,'-',VoucherCreateButton],
		tbar:['年月:',yearmonthField,'-','供应商名称或编码:',CompanyNameText,'-','审核状态',StatusComb,'-',findButton,'-',BankButton1,'-',AuditButton,'-',NoAuditButton],

		fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
		{

		     id:'rowid',
		     header: '物资付款数据采集表ID',
		     allowBlank: false,
		     width:100,
		     align:'right',
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'PayBillNo',
		     header: '系统业务编码',
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
		     header: '所属年月',
		     allowBlank: false,
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
		     allowBlank: false,
		     align:'left',
		     width:200,
		     editable:false,
		     dataIndex: 'SupplierName'
		}, {
		     id:'BankName',
		     header: '供应商银行名称',
		     allowBlank: false,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankName'
		}, {
		     id:'BankNo',
		     header: '供应商银行账号',
		     allowBlank: false,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'BankNo'
		}, {
		     id:'ActualSum',
		     header: '实付金额',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'ActualSum',
		     hidden:true
		}, {
		     id:'ActualCurSum',
		     header: '实付本币',
		     allowBlank: true,
		     align:'right',
		     width:80,
		     editable:false,
		     dataIndex: 'ActualCurSum'
		}, {
		     id:'NextCheckNo',
		     header: '下个审批序号',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'NextCheckNo',
		     hidden:true
		}, {
		     id:'CheckNo',
		     header: '审批序号',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'CheckNo',
		     hidden:true
		}, {
		     id:'IsCheck',
		     header: '审核状态',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'IsCheck',
		     hidden:true
		},{
		     id:'IsLastCheck',
		     header: '审核状态',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:true,
		     dataIndex: 'IsLastCheck',
		     hidden:true
		},{
		     id:'hospBankName',
		     header: '医院付款银行名称',
		     allowBlank: true,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'hospBankName'
		},{
		     id:'hospBankNo',
		     header: '医院付款银行账号',
		     allowBlank: true,
		     align:'left',
		     width:160,
		     editable:false,
		     dataIndex: 'hospBankNo'
		},{
		     id:'CheckResult',
		     header: '审核状态',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'CheckResult'
		}]
    
    });
    mainGrid.load(({params:{start:0,limit:25,username:username}}));	
    
    
    mainGrid.btnAddHide();  //隐藏保存按钮
	mainGrid.btnDeleteHide(); //隐藏重置按钮
	mainGrid.btnSaveHide();  //隐藏保存按钮
	mainGrid.btnResetHide();  //隐藏重置按钮
	mainGrid.btnPrintHide();  //隐藏打印按钮

	
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
