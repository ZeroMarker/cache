
//var acctbookid=bookID;//勿删
var userdr = session['LOGON.USERID'];//登录人ID
var projUrl='../csp/herp.acct.acctThreeBarDetailCashexe.csp';	
	//----------------- 会计科目---------------//

	//////////////科目三栏明细账查询条件start//////////				
	//----------------- 会计科目---------------//

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
		fieldLabel : '会计科目',
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

	
	/////////会计年度////////
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
		fieldLabel : '会计年度',
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
	
	/////////会计月份////////
	var MonthZB0301Ds = new Ext.data.SimpleStore({                         
		fields : ['key', 'keyValue'],
		data : [['01', '01月'],['02', '02月'],['03', '03月'],['04','04月'],
				['05', '05月'],['06', '06月'],['07', '07月'],['08','08月'],
				['09', '09月'],['10', '10月'],['11', '11月'],['12','12月']]
	});

    var AcctMonthZB0301Strat = new Ext.form.ComboBox({
		id : 'AcctMonthZB0301Strat',
		fieldLabel : '月',
		width : 100,
		listWidth : 100,
		store : MonthZB0301Ds,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		selectOnFocus:true,
		forceSelection : true
		//resizable:true
    });
	 var AcctMonthZB0301End = new Ext.form.ComboBox({
		id : 'AcctMonthZB0301End',
		fieldLabel : '月',
		width : 100,
		listWidth : 100,
		store : MonthZB0301Ds,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		selectOnFocus:true,
		forceSelection : true
    });
	
	//是否包含为记账
	var StateZB0301Field = new Ext.form.Checkbox({
		id : 'StateZB0301Field',
		fieldLabel: '包含未记账',
		//labelSeparator : '是否停用:',
		allowBlank : false,
		width:30
	});
	
/* 	
	//一个普通的表单  显示查询条件
			var frm = new Ext.form.FormPanel({ 
	
				labelAlign: 'right', 
				title: '查询条件', 
				labelWidth: 50, 
				frame: true, 
				width:350,
				region: 'east', 
				closable: true, //这个属性就可以控制关闭该from 
				items: [{ 
						xtype : 'fieldset',
						title : '报表类型',
						items : [AcctSubjCodeZB0301,AcctYearZB0301,AcctMonthZB0301Strat,AcctMonthZB0301End,StateZB0301Field]
						
				}], 
				buttons: [{ 
							text: '按钮' 
							}] 
			}); 
		 */	
			
