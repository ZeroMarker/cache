/**
 * name:tab of database author:liuyang Date:2011-1-24
 */

var EmpBonusTabUrl= '../csp/dhc.bonus.EmpBonusPayexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

// �������Դ

var BankInfoTabProxy = new Ext.data.HttpProxy({
			url : EmpBonusTabUrl + '?action=EmpBonuslist'
		});
var BankInfoTabDs = new Ext.data.Store({
			proxy : BankInfoTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['EmpBonusPayID', 'EmpCode', 'EmpName', 'EmpUnitID','PayUnitID','BonusYear','BonusPeriod','DataType','DataValue','UpdateDate','ItemName']),
			remoteSort : true
		});
//EmpBonusPayID^EmpCode^EmpName^EmpUnitID^PayUnitID^BonusYear^BonusPeriod^DataType^DataValue^UpdateDate^ItemName
// ����Ĭ�������ֶκ������� 
BankInfoTabDs.setDefaultSort('ItemName', 'EmpCode', 'EmpName', 'EmpUnitID', 'PayUnitID', 'BonusYear', 'BonusPeriod', 'DataType', 'DataValue','UpdateDate');

// ���ݿ�����ģ��
var BankInfoTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		 {
			header : '�������',
			dataIndex : 'BonusYear',
			width : 60,
			sortable: true		
		}, {
			header : '�����·�',
			dataIndex : 'BonusPeriod',
			width : 60,
			sortable: true		
		},{
			header : '��������',
			dataIndex : 'EmpUnitID',
			width : 120,
			sortable: true	
		},{
			header : '��Ա����',
			dataIndex : 'EmpCode',
			width : 60,
			sortable: true
		}, {
			header : '��Ա����',
			dataIndex : 'EmpName',
			width : 60,
			sortable: true
		},  {
			header : '���ſ���',
			dataIndex : 'PayUnitID',
			width : 120,
			sortable: true		
		},{
			header : '������Ŀ',
			dataIndex : 'ItemName',
			width : 100,
			sortable: true	
			},{
			header : '������',
			dataIndex : 'DataValue',
			width : 100,
			align : 'right',
			sortable: true
	
		},{
			header : '��������',
			dataIndex : 'DataType',
			width : 80,
			sortable: true	
			}, {
			header : '��������',
			dataIndex : 'UpdateDate',
			width : 120,
			sortable: true		
		}

]);

// ��ʼ��Ĭ��������
BankInfoTabCm.defaultSortable = true;

//�������Ų�ѯ
var CNField = new Ext.form.TextField({
			name : 'CNField',
			width : 100,
			minChars : 1 ,
			emptyText : '����/����',
			editable: true
		});



//��������

var EmpDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    EmpDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:EmpBonusTabUrl + '?action=EmpField&str='
		                               +Ext.getCmp('EmpField').getRawValue(),
					method:'POST'})
});
      
var EmpField = new Ext.form.ComboBox({
	id: 'EmpField',
	fieldLabel: '��������',
	width:100,
	listWidth : 200,
	allowBlank: false,
	store: EmpDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'EmpField',
	minChars: 1,
	pageSize: 25,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
//���ſ���
var PayDs = new Ext.data.Store({
	     autoLoad:true,
	     proxy:"",
	     reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

    PayDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:EmpBonusTabUrl + '?action=PayField&str='
		                               +Ext.getCmp('PayField').getRawValue(),
					method:'POST'})
});	
	var PayField = new Ext.form.ComboBox({
	id: 'PayField',
	fieldLabel: '���ſ���',
	width:100,
	listWidth : 200,
	allowBlank: false,
	store: PayDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'',
	name: 'PayField',
	minChars: 1,
	pageSize: 25,
	selectOnFocus:false,
	forceSelection:'true',
	editable:true
	});
	
	
//��ʼ����
var SD = new Ext.ux.MonthField({   
     id:'month',   
     fieldLabel: '�·�',   
     allowBlank:true,   
     readOnly : true,   
     format:'Ym',   
        listeners:{"blur":function(){    
  }}   
});
     
//��������
var ED = new Ext.ux.MonthField({   
     id:'month2',   
     fieldLabel: '�·�',   
     allowBlank:true,   
     readOnly : true,   
     format:'Ym',  
        listeners:{"blur":function(){  
  }}   
});
//Excel���밴ť
var ExcelButton = new Ext.Toolbar.Button({
    text : 'Excel����', 
	tooltip : 'Excel����',
	iconCls : 'add',
	handler : function(){
	importExcel();
	return;
}
}); 
 
//��ѯ��ť
var findDataButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'add',
			handler : function() {

				findData();
			}
		}); 
		
		
 function findData() { 
                var CNDr = CNField.getValue(); 
 				var EmpFieldDr = EmpField.getValue();
				var PayFieldDr = PayField.getValue();
				var SDDr = Ext.util.Format.date(SD.getValue(), 'Ym');
				var EDDr = Ext.util.Format.date(ED.getValue(), 'Ym');
				//alert(SDDr)
				BankInfoTabDs.load({
				params : {
					start : 0,
					limit : BankInfoTabPagingToolbar.pageSize,
					CNDr : CNDr , 
					EmpFieldDr : EmpFieldDr ,
					PayFieldDr : PayFieldDr ,
					SDDr  : SDDr ,
					EDDr  : EDDr
					
				}
			});

}

  


// ��ҳ������
var BankInfoTabPagingToolbar = new Ext.PagingToolbar({
			store : BankInfoTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼"
			//buttons : ['-', BankInfoFilterItem, '-',
					//BankInfoSearchBox]

		});

// ���
var BankInfoTab = new Ext.grid.EditorGridPanel({
			title : '��Ա��Ч�������',
			store : BankInfoTabDs,
			cm : BankInfoTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['��������:', CNField, '-','��������:', EmpField, '-','���ſ���:', PayField, '-','��ʼ����:', SD, '-','��������:', ED, '-', findDataButton, '-',ExcelButton],
			bbar : BankInfoTabPagingToolbar
		});
/*		
BankInfoTabDs.load({
			params : {
				start : 0,
				limit : BankInfoTabPagingToolbar.pageSize
			}
		});
     */