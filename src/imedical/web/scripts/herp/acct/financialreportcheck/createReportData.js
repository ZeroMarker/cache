var createData=function(){




//报表模板	
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
    fieldLabel:'报表名称',
    width:200,
    listWidth:180,
	style:'margin-bottom:5px',
    allowBlank:false,
    store:reportDS,
    multiSelect: true,  
    valueField:'ReportTempletID',
    displayField:'ReportName',
    triggerAction:'all',
    emptyText:'请选择要生成数据的报表',
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
			data : [['M', '月'], ['S', '季度'], ['H', '半年'], ['Y', '年']]
		});
var PerType = new Ext.form.ComboBox({
			id : 'PerType',
			fieldLabel : '期间类型',
			width : 200,
			listWidth : 125,
			selectOnFocus : true,
			style:'margin-bottom:2px',
			allowBlank : false,
			store : PerTypeDS,
			//anchor : '100%',
			value:'M', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
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
    fieldLabel:'会计年月',
    width:200,
    listWidth:180,
	style:'margin-bottom:1px',
    allowBlank:false,
    store:YearDS,
    valueField:'year',
    displayField:'yearh',
    triggerAction:'all',
    emptyText:'请选择年度',
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
	  data : [['01', '01月'],['02', '02月'],['03', '03月'],['04', '04月'],['05', '05月'],['06', '06月'],['07', '07月'],
	  ['08', '08月'],['09', '09月'],['10', '10月'],['11', '11月'],['12', '12月']]
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
	mode : 'local', // 本地模式
	triggerAction: 'all',
	emptyText:'请选择月份',
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
	
	//定义按钮
	var CreatB = new Ext.Button({
		text:'生成数据',
		iconCls:'add'
	});
	
	var CloseB = new Ext.Button({
		text:'关闭',
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
									title : '错误',
									msg : '数据获取错误 ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
							//alert("数据获取错误")
				},
        success:function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var state=jsonData.info
			if(state==1){
				Ext.Msg.show({
									title : '提示',
									msg : '数据已经审核,不能重新生成报表数据 ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
							});
			}else if(state==0){
		Ext.Ajax.request({
		url : 'herp.acct.financialreportcheckexe.csp?action=createReport&ReportData='+ReportData,
        failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '数据获取错误 ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
							//alert("数据获取错误")
				},
        success:function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var Info=jsonData.info;
			if (jsonData.success == 'true') {
				Ext.Msg.show({
									title : '提示',
									msg : '操作成功 ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
							});
			}else{
				if(Info=="isNotAcct"){
					Ext.Msg.show({
									title : '提示',
									msg : '本期有未记账凭证，不能生成报表数据 ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
							});
					
				}else if(Info=="error"){
					Ext.Msg.show({
									title : '提示',
									msg : '报表公式解析出错，请假查报表公式的准确性 ',
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
									title : '错误',
									msg : '请选择相应的数据信息 ',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.WARNING
							});
		}else{
		Ext.MessageBox.confirm('提示','确定要生成报表数据吗? ',callback);
		}
	};
	CreatB.addListener('click',handler);
	
var window = new Ext.Window({
		title: '生成报表数据',
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