
//////////////////////������ʼʱ��ؼ�


var startDateField = new Ext.form.DateField({
	id:'startDateField',
	fieldLabel: '��ʼ����',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

var endDateField = new Ext.form.DateField({
	id:'endDateField',
	fieldLabel: '��ʼ����',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

/////////////////////���п�Ŀ

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
			fieldLabel : '���п�Ŀ',
	
			store : bankDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			//forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ�����п�Ŀ',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			allowBlank: false
			//selectOnFocus : true
		});
		
		
	
	
	
///���㷽ʽ
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
			fieldLabel : '���㷽ʽ',
			store : cheqtypeStore,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			//forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ����㷽ʽ',
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
			data : [['102', '�ֽ�'], ['101', '֧Ʊ']]
		});
var cheqtypename = new Ext.form.ComboBox({
			fieldLabel : '���㷽ʽ',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : cheqtypeStore,
			anchor : '90%',
			//value:1, //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'method',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
});
*/

var miniAmountField = new Ext.form.NumberField({
	id:'miniAmountField',
	fieldLabel: '��С���',
	columnWidth : .1,
	allowBlank:true,
	selectOnFocus:'true'
});

var maxAmountField = new Ext.form.NumberField({
	id:'maxAmountField',
	fieldLabel: '�����',
	columnWidth : .1,
	allowBlank:true,
	selectOnFocus:'true'
});

/////////////////////����
var cheqno = new Ext.form.TextField({
	fieldLabel:'�����',
	width : 150,
	selectOnFocus : true
});







/////////////////////
var ischecked= new Ext.form.RadioGroup({ 
	fieldLabel:'״̬',
                       width : 150, 
                       hideLabel:true, 
                       style:'margin-left:0px;', 
                       
                       //vertical :true, 
                       items:[ 
                              {id:'all',boxLabel:'ȫ��',inputValue:'',name:'sevType',checked: true},
                              {id:'checked',boxLabel:'�Ѷ�',inputValue:'1',name:'sevType'}, 
                              {id:'unchecked',boxLabel:'δ��',inputValue:'0',name:'sevType'}] 
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
					text : '���',
					tooltip : '���',
					width:80,
					iconCls : 'option',
					handler : function() {
						//doaudit(this,1,userid);
					}
				});
*/
//////////��ѯ��ť////////////// 
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
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	
		dosearch();
	}
});

//////////�ֹ����˰�ť////////////// 
var checkButton = new Ext.Button({
	id:'checkbutton',
	text: '�ֹ����˿���',
	tooltip: '�ֹ����˿���',
	locked:true,
	iconCls: 'option',
	handler: function(){
		var self=this;
		check(self);

	}
});

//////////�ֹ�������֤���水ť////////////// 
var checkAndSaveButton = new Ext.Button({
	text: '�ֹ�������֤����',
	tooltip: '�ֹ�������֤����',
	disabled:true,
	iconCls: 'option',
	handler: function(){

		save();
	}
});
//////////�Զ����˰�ť////////////// 
var autoCheckButton = new Ext.Button({
	text: '�Զ�����',
	tooltip: '�Զ�����',
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
                //fieldLabel: '��ѯ����',
               // msgTarget : 'side',
				layout:'column',
                hideLabel: true,
                //anchor    : '-20',

                items: [
                {xtype: 'displayfield', value: 'ʱ�䷶Χ��',width: 80},
                	startDateField,
                	{xtype: 'displayfield', value: '-',width: 5},
                	endDateField,
                	{xtype: 'displayfield', value: '���п�Ŀ��',width: 80},
                	bankCombo,
                	{xtype: 'displayfield', value: '���㷽ʽ��',width: 80},
                	cheqtypename,] },
                	{xtype: 'panel',layout:"column",
				items: [
					{xtype: 'displayfield', value: '��Χ��',width: 80},
                	miniAmountField,
                	{xtype: 'displayfield', value: '-',width: 5},
               		maxAmountField,
               		{xtype: 'displayfield', value: '����ţ�',width: 80},
                    cheqno] },
                    {xtype: 'panel',layout:"column",
				items: [
				    {xtype: 'displayfield', value: '����״̬��',width:80},
				    {xtype: 'displayfield', value: ' ',width: 5},
					ischecked,findButton] },
				
				     {xtype: 'panel',layout:"column",
				items: [
				    checkButton,checkAndSaveButton,autoCheckButton
				
                ]
           
          
            }
            
            
            ,{
	                       	
            	xtype: 'compositefield',
                //fieldLabel: '��ѯ����',
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

