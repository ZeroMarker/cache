
//var acctbookid=bookID;//��ɾ
var userdr = session['LOGON.USERID'];//��¼��ID
var projUrl='../csp/herp.acct.acctThreeBarDetailCashexe.csp';	
	//----------------- ��ƿ�Ŀ---------------//

	//////////////��Ŀ������ϸ�˲�ѯ����start//////////				
	//----------------- ��ƿ�Ŀ---------------//

	var SubjCodeZB0301Ds = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','SubjCode','SubjName','SubjCodeName'])
	});
	SubjCodeZB0301Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=GetAcctSubjZB0301&str='+Ext.getCmp('AcctSubjCodeZB0301').getRawValue()+'&bookID='+acctbookid,method:'POST'});
	});
    
    var AcctSubjCodeZB0301 = new Ext.form.ComboBox({
		id : 'AcctSubjCodeZB0301',
		fieldLabel : '��ƿ�Ŀ',
		store: SubjCodeZB0301Ds,
		valueField : 'SubjCode',
		displayField : 'SubjCodeName',
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
    });

	
	/////////������////////
	var YearZB0301Ds = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['AcctYear'])
	});
	YearZB0301Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=GetAcctYearZB0301&&bookID='+acctbookid,method:'POST'});
	});

    var AcctYearZB0301 = new Ext.form.ComboBox({
		id : 'AcctYearZB0301',
		fieldLabel : '������',
		store: YearZB0301Ds,
		valueField : 'AcctYear',
		displayField : 'AcctYear',
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
    });
	
	/////////����·�////////
	var MonthZB0301Ds = new Ext.data.SimpleStore({                         
		fields : ['key', 'keyValue'],
		data : [['01', '01��'],['02', '02��'],['03', '03��'],['04','04��'],
				['05', '05��'],['06', '06��'],['07', '07��'],['08','08��'],
				['09', '09��'],['10', '10��'],['11', '11��'],['12','12��']]
	});

    var AcctMonthZB0301Strat = new Ext.form.ComboBox({
		id : 'AcctMonthZB0301Strat',
		fieldLabel : '��',
		width : 100,
		listWidth : 100,
		store : MonthZB0301Ds,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		selectOnFocus:true,
		forceSelection : true
		//resizable:true
    });
	 var AcctMonthZB0301End = new Ext.form.ComboBox({
		id : 'AcctMonthZB0301End',
		fieldLabel : '��',
		width : 100,
		listWidth : 100,
		store : MonthZB0301Ds,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		selectOnFocus:true,
		forceSelection : true
    });
	
	//�Ƿ����Ϊ����
	var StateZB0301Field = new Ext.form.Checkbox({
		id : 'StateZB0301Field',
		fieldLabel: '����δ����',
		//labelSeparator : '�Ƿ�ͣ��:',
		allowBlank : false,
		width:30
	});
	
/* 	
	//һ����ͨ�ı�  ��ʾ��ѯ����
			var frm = new Ext.form.FormPanel({ 
	
				labelAlign: 'right', 
				title: '��ѯ����', 
				labelWidth: 50, 
				frame: true, 
				width:350,
				region: 'east', 
				closable: true, //������ԾͿ��Կ��ƹرո�from 
				items: [{ 
						xtype : 'fieldset',
						title : '��������',
						items : [AcctSubjCodeZB0301,AcctYearZB0301,AcctMonthZB0301Strat,AcctMonthZB0301End,StateZB0301Field]
						
				}], 
				buttons: [{ 
							text: '��ť' 
							}] 
			}); 
		 */	
			
