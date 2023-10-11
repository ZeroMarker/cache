/*
 *程序功能：
 *作者：
 *日期：
 *版本：
 *
 */
var userdr = session['LOGON.USERID'];//登录人ID
var projUrl='../csp/herp.acct.acctsubjcomparativeanalysexe.csp';	
	//----------------- 会计科目---------------//

/*********************查询条件***************/			

	//会计科目1
	var SubjCodeName1Ds = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['subjId','subjCode','subjName','subjCodeName','subjCodeNameAll'])
	}); //返回Json串
	SubjCodeName1Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=GetSubjCodeName&str='+Ext.getCmp('SubjCodeName1').getRawValue()+'&bookID='+acctbookid,method:'POST'});
	});
    
    var SubjCodeName1 = new Ext.form.ComboBox({
		id : 'SubjCodeName1',
		fieldLabel : '会计科目起',
		store: SubjCodeName1Ds,
		valueField : 'subjCode',
		displayField : 'subjCodeName',//编码+名称
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
    });
    
    //会计科目2
    var SubjCodeName2Ds = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['subjId','subjCode','subjName','subjCodeName','subjCodeNameAll'])
	});
	SubjCodeName2Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=GetSubjCodeName&str='+Ext.getCmp('SubjCodeName2').getRawValue()+'&bookID='+acctbookid,method:'POST'});
	});
    
    var SubjCodeName2 = new Ext.form.ComboBox({
		id : 'SubjCodeName2',
		fieldLabel : '会计科目起',
		store: SubjCodeName1Ds,
		valueField : 'subjCode',
		displayField : 'subjCodeName',
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
    });

	
	//起始会计年月
	var YearMonth1 = new Ext.form.DateField({
		id : 'YearMonth1',
		format : 'Y-m',
		width : 200,
		emptyText : '',
		plugins: 'monthPickerPlugin'
		});	
	//结束会计年月
	var YearMonth2 = new Ext.form.DateField({
		id : 'YearMonth2',
		format : 'Y-m',
		width : 200,
		emptyText : '',
		plugins: 'monthPickerPlugin'
		});

	//科目级别
	var SubjLevel = new Ext.data.SimpleStore({
		id : 'SubjLevel',
		fieldLabel: '科目级次',
		allowBlank : false,
		width:30,
		valueField : 'key',
		displayField : 'keyValue',
		fields : ['key', 'keyValue'],
		data : [['1', '1级'],['2', '2级'],['3', '3级'],['4','4级'],
				['5', '5级'],['6', '6级'],['7', '7级'],['8','8级']]
	});
  	//数据分析类型
  	//Descript:
  	//1:借方发生额，2:贷方发生额，3:借方发生额-贷方发生额  
  	//4:贷方发生额-借方发生额  5；借方期末余额 6：贷方期末余额
  	var AnalyType= new Ext.data.SimpleStore({
	  	id : 'AnalyType',
		fieldLabel: '数据分析类型',
		allowBlank : false,
		width:30,
		valueField : 'key',
		displayField : 'keyValue',
		fields : ['key', 'keyValue'],
		data : [['1', '借方发生额'],['2', '贷方发生额'],['3', '借方发生额-贷方发生额'],
		        ['4','贷方发生额-借方发生额'],
				['5', '借方期末余额'],['6', '贷方期末余额']]
	  	});
	alert(AnalyType.valueField);
	alert(AnalyType.getValue()+'aa');
	alert(AnalyType.displayField);
	alert(AnalyType.getRawValue()+"bb");

	
			
