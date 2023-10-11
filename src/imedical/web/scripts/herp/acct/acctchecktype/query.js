
//////////////////////定义起始时间控件


var startDateField = new Ext.form.DateField({
	id:'startDateField',
	fieldLabel: '起始日期',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

var endDateField = new Ext.form.DateField({
	id:'endDateField',
	fieldLabel: '起始日期',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

/////////////////////银行科目

var bankDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','acctbankName', 'name'])
		});

bankDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

						url : '../csp/herp.acct.acctcheckexe.csp?action=ListAcctSubjName',method:'POST'
					});
		});
var bankCombo = new Ext.form.ComboBox({
			fieldLabel : '银行科目',
	
			store : bankDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			//forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择银行科目',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			allowBlank: false
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
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			allowBlank: false
			//selectOnFocus : true
		});
			
		

/*
var cheqtypeStore = new Ext.data.SimpleStore({
			fields : ['rowid', 'method'],
			data : [['102', '现金'], ['101', '支票']]
		});
var cheqtypename = new Ext.form.ComboBox({
			fieldLabel : '结算方式',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : cheqtypeStore,
			anchor : '90%',
			//value:1, //默认值
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
});
*/

var miniAmountField = new Ext.form.NumberField({
	id:'miniAmountField',
	fieldLabel: '最小金额',
	columnWidth : .1,
	allowBlank:true,
	selectOnFocus:'true'
});

var maxAmountField = new Ext.form.NumberField({
	id:'maxAmountField',
	fieldLabel: '最大金额',
	columnWidth : .1,
	allowBlank:true,
	selectOnFocus:'true'
});

/////////////////////结算
var cheqno = new Ext.form.TextField({
	fieldLabel:'结算号',
	width : 150,
	selectOnFocus : true
});







/////////////////////
var ischecked= new Ext.form.RadioGroup({ 
	fieldLabel:'状态',
                       width : 150, 
                       hideLabel:true, 
                       style:'margin-left:0px;', 
                       
                       //vertical :true, 
                       items:[ 
                              {id:'all',boxLabel:'全部',inputValue:'',name:'sevType',checked: true},
                              {id:'checked',boxLabel:'已对',inputValue:'1',name:'sevType'}, 
                              {id:'unchecked',boxLabel:'未对',inputValue:'0',name:'sevType'}] 
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
	    var  maxAmount= maxAmountField.getValue();
        var checkno = cheqno.getValue();
        var state  =ischecked.getValue().inputValue;
        //ischecked.getValue().inputValue
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
		    state:state
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
			    state:state
			   }
			
			
		  });
  }



var findButton = new Ext.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	
		dosearch();
	}
});

//////////手工对账按钮////////////// 
var checkButton = new Ext.Button({
	id:'checkbutton',
	text: '手工对账开启',
	tooltip: '手工对账开启',
	locked:true,
	iconCls: 'option',
	handler: function(){
		var self=this;
		check(self);

	}
});

//////////手工对账验证保存按钮////////////// 
var checkAndSaveButton = new Ext.Button({
	text: '手工对账验证保存',
	tooltip: '手工对账验证保存',
	disabled:true,
	iconCls: 'option',
	handler: function(){

		save();
	}
});
//////////自动对账按钮////////////// 
var autoCheckButton = new Ext.Button({
	text: '自动对账',
	tooltip: '自动对账',
	iconCls: 'option',
	handler: function(){
	
		autoCheck();
	}
});


var queryPanel = new Ext.FormPanel({
	height : 110,
	region : 'north',
	frame : true,
	 items   : [

            {	
            	xtype: 'compositefield',
                //fieldLabel: '查询条件',
               // msgTarget : 'side',
				layout:'column',
                hideLabel: true,
                //anchor    : '-20',

                items: [
                {xtype: 'displayfield', value: '时间范围：',width: 80},
                	startDateField,
                	{xtype: 'displayfield', value: '-',width: 5},
                	endDateField,
                	{xtype: 'displayfield', value: '银行科目：',width: 80},
                	bankCombo,
                	{xtype: 'displayfield', value: '结算方式：',width: 80},
                	cheqtypename,] },
                	{xtype: 'panel',layout:"column",
				items: [
					{xtype: 'displayfield', value: '金额范围：',width: 80},
                	miniAmountField,
                	{xtype: 'displayfield', value: '-',width: 5},
               		maxAmountField,
               		{xtype: 'displayfield', value: '结算号：',width: 80},
                    cheqno] },
                    {xtype: 'panel',layout:"column",
				items: [
				    {xtype: 'displayfield', value: '对账状态：',width:80},
				    {xtype: 'displayfield', value: ' ',width: 5},
					ischecked,findButton] },
				
				     {xtype: 'panel',layout:"column",
				items: [
				    checkButton,checkAndSaveButton,autoCheckButton
				
                ]
           
          
            }
            
            
            ,{
	                       	
            	xtype: 'compositefield',
                //fieldLabel: '查询条件',
               // msgTarget : 'side',
				layout:'column',
                hideLabel: true,
                //anchor    : '-20',
                defaults: {
                    flex: 1
                },
                items: [
                {xtype: 'displayfield', value: '',width: 15},
              

                ] 
                
            
	        
	        
	        }
	        
	        
	        ]
});

