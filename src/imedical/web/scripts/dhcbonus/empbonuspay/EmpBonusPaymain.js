/**
 * name:tab of database author:liuyang Date:2011-1-24
 */

var EmpBonusTabUrl= '../csp/dhc.bonus.EmpBonusPayexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

// 配件数据源

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
// 设置默认排序字段和排序方向 
BankInfoTabDs.setDefaultSort('ItemName', 'EmpCode', 'EmpName', 'EmpUnitID', 'PayUnitID', 'BonusYear', 'BonusPeriod', 'DataType', 'DataValue','UpdateDate');

// 数据库数据模型
var BankInfoTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		 {
			header : '发放年份',
			dataIndex : 'BonusYear',
			width : 60,
			sortable: true		
		}, {
			header : '发放月份',
			dataIndex : 'BonusPeriod',
			width : 60,
			sortable: true		
		},{
			header : '所属科室',
			dataIndex : 'EmpUnitID',
			width : 120,
			sortable: true	
		},{
			header : '人员工号',
			dataIndex : 'EmpCode',
			width : 60,
			sortable: true
		}, {
			header : '人员姓名',
			dataIndex : 'EmpName',
			width : 60,
			sortable: true
		},  {
			header : '发放科室',
			dataIndex : 'PayUnitID',
			width : 120,
			sortable: true		
		},{
			header : '发放项目',
			dataIndex : 'ItemName',
			width : 100,
			sortable: true	
			},{
			header : '奖金金额',
			dataIndex : 'DataValue',
			width : 100,
			align : 'right',
			sortable: true
	
		},{
			header : '奖金类型',
			dataIndex : 'DataType',
			width : 80,
			sortable: true	
			}, {
			header : '更新日期',
			dataIndex : 'UpdateDate',
			width : 120,
			sortable: true		
		}

]);

// 初始化默认排序功能
BankInfoTabCm.defaultSortable = true;

//姓名工号查询
var CNField = new Ext.form.TextField({
			name : 'CNField',
			width : 100,
			minChars : 1 ,
			emptyText : '姓名/工号',
			editable: true
		});



//所属科室

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
	fieldLabel: '所属科室',
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
//发放科室
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
	fieldLabel: '发放科室',
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
	
	
//开始日期
var SD = new Ext.ux.MonthField({   
     id:'month',   
     fieldLabel: '月份',   
     allowBlank:true,   
     readOnly : true,   
     format:'Ym',   
        listeners:{"blur":function(){    
  }}   
});
     
//结束日期
var ED = new Ext.ux.MonthField({   
     id:'month2',   
     fieldLabel: '月份',   
     allowBlank:true,   
     readOnly : true,   
     format:'Ym',  
        listeners:{"blur":function(){  
  }}   
});
//Excel导入按钮
var ExcelButton = new Ext.Toolbar.Button({
    text : 'Excel导入', 
	tooltip : 'Excel导入',
	iconCls : 'add',
	handler : function(){
	importExcel();
	return;
}
}); 
 
//查询按钮
var findDataButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
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

  


// 分页工具栏
var BankInfoTabPagingToolbar = new Ext.PagingToolbar({
			store : BankInfoTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录"
			//buttons : ['-', BankInfoFilterItem, '-',
					//BankInfoSearchBox]

		});

// 表格
var BankInfoTab = new Ext.grid.EditorGridPanel({
			title : '人员绩效奖金管理',
			store : BankInfoTabDs,
			cm : BankInfoTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['姓名工号:', CNField, '-','所属科室:', EmpField, '-','发放科室:', PayField, '-','开始日期:', SD, '-','结束日期:', ED, '-', findDataButton, '-',ExcelButton],
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