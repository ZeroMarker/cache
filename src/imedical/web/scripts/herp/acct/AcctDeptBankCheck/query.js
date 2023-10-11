
//////////////////////定义起始时间控件


var startDateField = new Ext.form.DateField({
	id:'startDateField',
	fieldLabel: '起始日期',
	width: 130,
	allowBlank:true,
	//value:new Date(),
	//format:'Y-m-d',
	selectOnFocus:'true'
});

var endDateField = new Ext.form.DateField({
	id:'endDateField',
	fieldLabel: '起始日期',
	width: 130,
	allowBlank:true,
	//format:'Y-m-d',
	selectOnFocus:'true'
});

/////////////////////银行科目

var bankDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['subjId','subjCode', 'subjName','subjCodeName'])
		});

bankDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

						url : '../csp/herp.acct.acctcheckexe.csp?action=ListAcctSubjName&bookID='+bookID+'&str='+Ext.getCmp('bankCombo').getRawValue(),method:'POST'
					});
		});
var bankCombo = new Ext.form.ComboBox({
			id:'bankCombo',
			fieldLabel : '银行科目',
			store : bankDs,
			displayField : 'subjCodeName',
			valueField : 'subjCode',
			typeAhead : true,
			//forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择银行科目',
			width : 260,
			listWidth : 260,
			pageSize : 10,
			minChars : 1
			//selectOnFocus : true
		});
		
		
	
	
	
///结算方式
var cheqtypeStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, [ 'rowid','name'])
		});

cheqtypeStore.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

						url : '../csp/herp.acct.acctcheckexe.csp?action=GetSysChequeType',method:'POST'
					});
		});
var cheqtypename = new Ext.form.ComboBox({
			fieldLabel : '结算方式',
			store : cheqtypeStore,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			//forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择结算方式',
			width : 180,
			listWidth : 220,
			pageSize : 10,
			minChars : 1
			//selectOnFocus : true
		});
			
		


var miniAmountField = new Ext.form.NumberField({
	id:'miniAmountField',
	fieldLabel: '最小金额',
	width: 130,
	allowBlank:true,
	selectOnFocus:'true'
});

var maxAmountField = new Ext.form.NumberField({
	id:'maxAmountField',
	fieldLabel: '最大金额',
	width: 130,
	allowBlank:true,
	selectOnFocus:'true'
});

/////////////////////结算
var cheqno = new Ext.form.TextField({
	fieldLabel:'票据号',
	width : 260,
	selectOnFocus : true
});


/////////////////////
var ischecked= new Ext.form.RadioGroup({ 
	fieldLabel:'状态',
	width : 180, 
	hideLabel:true, 
	defaults:{
		style:"margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;" 
	},
	vertical :true, 
	items:[ 
		  {id:'all',boxLabel:'全部',inputValue:'2',name:'sevType'},
		  {id:'checked',boxLabel:'已对',inputValue:'1',name:'sevType'},
		  {id:'unchecked',boxLabel:'未对',inputValue:'0',name:'sevType',checked: true}] 
	  }); 
/*
var checkstate=Ext.form.RadioGroup({
	
            
            fieldLabel: 'Auto Layout',
            items: [
                {boxLabel: 'Item 1', name: 'rb-auto', inputValue: 1,checked: true},
                {boxLabel: 'Item 2', name: 'rb-auto', inputValue: 2},
                {boxLabel: 'Item 3', name: 'rb-auto', inputValue: 3}
            ]
        
	});
*/


/*
var auditButton = new Ext.Button({
					text : '审核',
					tooltip : '审核',
					width:80,
					iconCls : 'option',
					handler : function() {
						//doaudit(this,1,userid);
					}
				});
*/
//////////查询按钮////////////// 
function dosearch(){
	    var startdate= startDateField.getValue();
	    if (startdate!=="")
	    {
	       startdate=startdate.format ('Y-m-d');
	    }
	    //alert(startdate);
	    var enddate = endDateField.getValue();
	    if (enddate!=="")
	    {
	       enddate=enddate.format ('Y-m-d');
	    }
		
	    var acctbankName =bankCombo.getValue();
	    var typename = cheqtypename.getValue(); 
	    var miniAmount = miniAmountField.getValue();
	    var maxAmount= maxAmountField.getValue();
        var checkno = cheqno.getValue();
        var state  =ischecked.getValue().inputValue;
		//var bookID= GetAcctBookID();
        //ischecked.getValue().inputValue
		//alert(window.bookID);
		//var bookID=bookID;
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    startdate:startdate,
		    enddate:enddate,
		    acctbankName:acctbankName,
		    method:typename,
		    miniAmount:miniAmount,
		    maxAmount:maxAmount,
		    settlementNo:checkno,
		    state:state,
			bookID:bookID
		   }	
	  });
		Detail.load({
		    params:{
			    start:0,
			    limit:25,
			    startdate:startdate,
			    enddate:enddate,
			    acctbankName:acctbankName,
			    method:typename,
			    miniAmount:miniAmount,
			    maxAmount:maxAmount,
			    settlementNo:checkno,
			    state:state,
				bookID:bookID
			   }
			
			
		  });
  }



var findButton = new Ext.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	width: 55,
	handler: function(){
	
		dosearch();
	}
});

//////////手工对账按钮////////////// 
var checkButton = new Ext.Button({
	id:'checkbutton',
	text: '手工对账开启',
	tooltip: '手工对账开启',
	width:100,
	locked:true,
	iconCls: 'startcheck ',
	handler: function(){
		var self=this;
		check(self);

	}
});

//////////手工对账验证保存按钮////////////// 
var checkAndSaveButton = new Ext.Button({
	text: '手工对账验证保存',
	tooltip: '手工对账验证保存',
	width:125,
	disabled:true,
	iconCls: 'save',
	handler: function(){
		
		save();
	}
});
//////////自动对账按钮////////////// 
var autoCheckButton = new Ext.Button({
	text: '自动对账',
	tooltip: '自动对账',
	width:80,
	iconCls: 'autocheck',
	handler: function(){
	
		autoCheck();
	}
});


var queryPanel = new Ext.FormPanel({
	title:'单位银行对账单查询',
	iconCls:'find',
	height : 140,
	region : 'north',
	frame : true,
	defaults : {	//行间距
		bodyStyle : 'padding:5px'
		},	
	items : [
				{	
            	xtype: 'panel',layout:'column',hideLabel: true,
				width:1200,
                items: [
					{xtype: 'displayfield', value: '时间范围',style:'padding:0 5px;'},startDateField,
					{xtype: 'displayfield', value: '',width: 4},
					{xtype: 'displayfield', value: '--',width: 15},endDateField,
					{xtype: 'displayfield', value: '',width: 20},
					{xtype: 'displayfield', value: '银行科目',style:'padding:0 5px;'},bankCombo,
					{xtype: 'displayfield', value: '',width: 20},
					{xtype: 'displayfield', value: '结算方式',style:'padding:0 5px;'},cheqtypename
					]
				},
				{
				xtype: 'panel',layout:"column",
				width:1200,
				items: [
					{xtype: 'displayfield', value: '金额范围',style:'padding:0 5px;'},miniAmountField,
                	{xtype: 'displayfield', value: '',width: 4},
					{xtype: 'displayfield', value: '--',width: 15},maxAmountField,
					{xtype: 'displayfield', value: '',width: 30},
               		{xtype: 'displayfield', value: '结算号',style:'padding:0 5px;'},cheqno,
					{xtype: 'displayfield', value: '',width: 20},
					{xtype: 'displayfield', value: '对账状态',style:'padding:0 5px;'},
				    {xtype: 'displayfield', value: '',width: 5},ischecked,
					{xtype: 'displayfield', value: '',width: 10},
					findButton
					] 
				},
				{
				xtype: 'panel',layout:"column",
				items: [				
					checkButton,
					{xtype: 'displayfield', value: '',width: 10},checkAndSaveButton,
					{xtype: 'displayfield', value: '',width: 10},autoCheckButton
					]
				}
	        
	        ]
});

