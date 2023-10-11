
//////////////////////������ʼʱ��ؼ�


var startDateField = new Ext.form.DateField({
	id:'startDateField',
	fieldLabel: '��ʼ����',
	width: 130,
	allowBlank:true,
	//value:new Date(),
	//format:'Y-m-d',
	selectOnFocus:'true'
});

var endDateField = new Ext.form.DateField({
	id:'endDateField',
	fieldLabel: '��ʼ����',
	width: 130,
	allowBlank:true,
	//format:'Y-m-d',
	selectOnFocus:'true'
});

/////////////////////���п�Ŀ

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
			fieldLabel : '���п�Ŀ',
			store : bankDs,
			displayField : 'subjCodeName',
			valueField : 'subjCode',
			typeAhead : true,
			//forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ�����п�Ŀ',
			width : 260,
			listWidth : 260,
			pageSize : 10,
			minChars : 1
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
			width : 180,
			listWidth : 220,
			pageSize : 10,
			minChars : 1
			//selectOnFocus : true
		});
			
		


var miniAmountField = new Ext.form.NumberField({
	id:'miniAmountField',
	fieldLabel: '��С���',
	width: 130,
	allowBlank:true,
	selectOnFocus:'true'
});

var maxAmountField = new Ext.form.NumberField({
	id:'maxAmountField',
	fieldLabel: '�����',
	width: 130,
	allowBlank:true,
	selectOnFocus:'true'
});

/////////////////////����
var cheqno = new Ext.form.TextField({
	fieldLabel:'Ʊ�ݺ�',
	width : 260,
	selectOnFocus : true
});


/////////////////////
var ischecked= new Ext.form.RadioGroup({ 
	fieldLabel:'״̬',
	width : 180, 
	hideLabel:true, 
	defaults:{
		style:"margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;" 
	},
	vertical :true, 
	items:[ 
		  {id:'all',boxLabel:'ȫ��',inputValue:'2',name:'sevType'},
		  {id:'checked',boxLabel:'�Ѷ�',inputValue:'1',name:'sevType'},
		  {id:'unchecked',boxLabel:'δ��',inputValue:'0',name:'sevType',checked: true}] 
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
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'find',
	width: 55,
	handler: function(){
	
		dosearch();
	}
});

//////////�ֹ����˰�ť////////////// 
var checkButton = new Ext.Button({
	id:'checkbutton',
	text: '�ֹ����˿���',
	tooltip: '�ֹ����˿���',
	width:100,
	locked:true,
	iconCls: 'startcheck ',
	handler: function(){
		var self=this;
		check(self);

	}
});

//////////�ֹ�������֤���水ť////////////// 
var checkAndSaveButton = new Ext.Button({
	text: '�ֹ�������֤����',
	tooltip: '�ֹ�������֤����',
	width:125,
	disabled:true,
	iconCls: 'save',
	handler: function(){
		
		save();
	}
});
//////////�Զ����˰�ť////////////// 
var autoCheckButton = new Ext.Button({
	text: '�Զ�����',
	tooltip: '�Զ�����',
	width:80,
	iconCls: 'autocheck',
	handler: function(){
	
		autoCheck();
	}
});


var queryPanel = new Ext.FormPanel({
	title:'��λ���ж��˵���ѯ',
	iconCls:'find',
	height : 140,
	region : 'north',
	frame : true,
	defaults : {	//�м��
		bodyStyle : 'padding:5px'
		},	
	items : [
				{	
            	xtype: 'panel',layout:'column',hideLabel: true,
				width:1200,
                items: [
					{xtype: 'displayfield', value: 'ʱ�䷶Χ',style:'padding:0 5px;'},startDateField,
					{xtype: 'displayfield', value: '',width: 4},
					{xtype: 'displayfield', value: '--',width: 15},endDateField,
					{xtype: 'displayfield', value: '',width: 20},
					{xtype: 'displayfield', value: '���п�Ŀ',style:'padding:0 5px;'},bankCombo,
					{xtype: 'displayfield', value: '',width: 20},
					{xtype: 'displayfield', value: '���㷽ʽ',style:'padding:0 5px;'},cheqtypename
					]
				},
				{
				xtype: 'panel',layout:"column",
				width:1200,
				items: [
					{xtype: 'displayfield', value: '��Χ',style:'padding:0 5px;'},miniAmountField,
                	{xtype: 'displayfield', value: '',width: 4},
					{xtype: 'displayfield', value: '--',width: 15},maxAmountField,
					{xtype: 'displayfield', value: '',width: 30},
               		{xtype: 'displayfield', value: '�����',style:'padding:0 5px;'},cheqno,
					{xtype: 'displayfield', value: '',width: 20},
					{xtype: 'displayfield', value: '����״̬',style:'padding:0 5px;'},
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

