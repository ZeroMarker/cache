/*
 *�����ܣ�
 *���ߣ�
 *���ڣ�
 *�汾��
 *
 */
var userdr = session['LOGON.USERID'];//��¼��ID
var projUrl='../csp/herp.acct.acctsubjcomparativeanalysexe.csp';	
	//----------------- ��ƿ�Ŀ---------------//

/*********************��ѯ����***************/			

	//��ƿ�Ŀ1
	var SubjCodeName1Ds = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['subjId','subjCode','subjName','subjCodeName','subjCodeNameAll'])
	}); //����Json��
	SubjCodeName1Ds.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:projUrl+'?action=GetSubjCodeName&str='+Ext.getCmp('SubjCodeName1').getRawValue()+'&bookID='+acctbookid,method:'POST'});
	});
    
    var SubjCodeName1 = new Ext.form.ComboBox({
		id : 'SubjCodeName1',
		fieldLabel : '��ƿ�Ŀ��',
		store: SubjCodeName1Ds,
		valueField : 'subjCode',
		displayField : 'subjCodeName',//����+����
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
    });
    
    //��ƿ�Ŀ2
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
		fieldLabel : '��ƿ�Ŀ��',
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

	
	//��ʼ�������
	var YearMonth1 = new Ext.form.DateField({
		id : 'YearMonth1',
		format : 'Y-m',
		width : 200,
		emptyText : '',
		plugins: 'monthPickerPlugin'
		});	
	//�����������
	var YearMonth2 = new Ext.form.DateField({
		id : 'YearMonth2',
		format : 'Y-m',
		width : 200,
		emptyText : '',
		plugins: 'monthPickerPlugin'
		});

	//��Ŀ����
	var SubjLevel = new Ext.data.SimpleStore({
		id : 'SubjLevel',
		fieldLabel: '��Ŀ����',
		allowBlank : false,
		width:30,
		valueField : 'key',
		displayField : 'keyValue',
		fields : ['key', 'keyValue'],
		data : [['1', '1��'],['2', '2��'],['3', '3��'],['4','4��'],
				['5', '5��'],['6', '6��'],['7', '7��'],['8','8��']]
	});
  	//���ݷ�������
  	//Descript:
  	//1:�跽�����2:���������3:�跽������-����������  
  	//4:����������-�跽������  5���跽��ĩ��� 6��������ĩ���
  	var AnalyType= new Ext.data.SimpleStore({
	  	id : 'AnalyType',
		fieldLabel: '���ݷ�������',
		allowBlank : false,
		width:30,
		valueField : 'key',
		displayField : 'keyValue',
		fields : ['key', 'keyValue'],
		data : [['1', '�跽������'],['2', '����������'],['3', '�跽������-����������'],
		        ['4','����������-�跽������'],
				['5', '�跽��ĩ���'],['6', '������ĩ���']]
	  	});
	alert(AnalyType.valueField);
	alert(AnalyType.getValue()+'aa');
	alert(AnalyType.displayField);
	alert(AnalyType.getRawValue()+"bb");

	
			
