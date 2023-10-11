//////////////////预算项大类//////////1会计科目2医疗指标
var BTypeDs = new Ext.data.SimpleStore({
			fields : ['rowid', 'name'],
			data : [['1', '会计科目'], ['2', '医疗指标']]
		});

var BTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算大类',
			store : BTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,		
			triggerAction : 'all',
			emptyText:'选择...',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			mode : 'local', // 本地模式
			selectOnFocus : true
		});


/////////////////预算类别/////////////////////////////////
var budgetDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	budgetDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitaccdeptexe.csp?action=BudgTyplist',method:'POST'});		
	});		
	var BudgetType = new Ext.form.ComboBox({
		fieldLabel:'预算类别',
		store: budgetDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 150,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////编码/////////////////////////////////
var BudgetCode = new Ext.form.TextField({
		id: 'BudgetCode',
		fieldLabel: '预算编码',
		allowBlank: true,
		emptyText:'选择...',
		width:120,
	    listWidth : 120
	});

/////////////////年/////////////////////////////////
var YearDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	YearDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitaccdeptexe.csp?action=Yaerlist',method:'POST'});
		
	});
		
	var YearCombo = new Ext.form.ComboBox({
		fieldLabel:'年度',
		store: YearDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 120,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});
	
	
//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){

		var year=YearCombo.getValue();
		var btype=BTypeCombo.getValue();
		var bname=BudgetType.getValue();
		var bcode=BudgetCode.getValue();

		itemGrid.load(({params:{start:0, limit:25,year:year,type:btype,bname:bname,bcode:bcode}}));
	}
});	

//批量设置分解方法按钮
var editButton = new Ext.Toolbar.Button({
	text: '批量设置',
	tooltip: '批量设置',
	iconCls: 'add',
	handler: function(){
		EditFun();
		}
});

//批量设置分解方法
var editrButton = new Ext.Toolbar.Button({
	text: '批量',
	tooltip: '批量',
	iconCls: 'add',
	handler: function(){
		editrFun(itemGrid);
		}
});
//////////////////////分解方法//////////////////['1', '历史数据'], ////////
var SplitMethStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['2', '历史数据*调节比例'], ['3', '比例系数']]
		});
var SplitMethField = new Ext.form.ComboBox({
			id : 'SplitMethField',
			fieldLabel : '分解方法设置',
			width : 200,
			//listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : SplitMethStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

///////////////////////顶显示//////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">预算分解方法设置(全院-科室)</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
		            xtype : 'displayfield',
					value : '年度:',
					columnWidth : .06
				},YearCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '预算大类:',
					columnWidth : .10
				},BTypeCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '预算类别:',
					columnWidth : .10
				},BudgetType,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '编码:',
					columnWidth : .06
				},BudgetCode

		]
	}]
});

//////////////*************************************///////////////				
var itemGrid = new dhc.herp.Grid({
        //title: '预算分解方法设置(全院-科室)',
        region: 'center',
        url: 'herp.budg.budgschsplitaccdeptexe.csp',
		
		listeners : {
            'cellclick' : function(grid, rowIndex, columnIndex, e) {
                var record = grid.getStore().getAt(rowIndex);
                  // 根据条件设置单元格点击编辑是否可用  1是末级0不是
                 // alert(columnIndex);
                 //alert(record.get('isLast'))
                    if ((record.get('isLast') == '0')&& ((columnIndex == 9)||(columnIndex == 10))) {
                   // alert(222)
                         return false;
                     } else {return true;}
               },
            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				// 预算项目公式编辑
				if ((record.get('isLast') == '0') && ((columnIndex == 9)||(columnIndex == 10))) {
				
					return false;
				} else {
					return true;
				}
			}
            },

        fields: [
		new Ext.grid.CheckboxSelectionModel({editable:false}),
		{   id:'rowid',
            header: 'ID',
            dataIndex: 'rowid',
			editable:false,
            hidden: true
        },{
            id:'year',
            header: '年度',
			width:80,
			update : true,			
			editable:false,
            dataIndex: 'year',
            hidden: false
        },{
            id:'code',
            header: '科目编码',
			allowBlank: false,
			width:150,
			update : true,			
			editable:false,
            dataIndex: 'code'
        },{
		    id:'superCode',
		    header: '上级编码',
			//allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'superCode',
            hidden: true
		},{ 
		    id:'dname',
		    header: '科目名称',
			//allowBlank: false,
			width:250,
			editable:false,
            dataIndex: 'dname'
		},{ 
		    id:'level',
		    header: '预算级别',
			//allowBlank: false,
			width:250,
			editable:false,
            dataIndex: 'level',
            hidden: true
		},{ 
		    id:'lisLast',
		    header: '是否末级',
			allowBlank: false,
			width:60,
			editable:false,
            dataIndex: 'lisLast',
            hidden: false
		},{ 
		    id:'splitMeth',
		    header: '分解方法设置',
			allowBlank: false,
			width:250,	
			//update : true,	
			//overrender:true,							
			/*renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var sf = record.data['isLast'];
						//var sm = record.data['rowid'];
						//alert(sf+':'+sm);
						//alert(sf)
						if (sf == '1') {		
							return '<span style="color:blue;cursor:hand;"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},*/
			type : SplitMethField,
			editable:true,
            dataIndex: 'splitMeth'
		},{ 
		    id:'rate',
		    header: '调节比例',
			width:200,
            dataIndex: 'rate',
            align : 'center',
            editable:false,
            /*renderer : function(v, p, r) {
						return '<span style="color:blue;cursor:hand"><u>维护数据</u></span>';
					},*/
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var sf = record.data['isLast'];
						var sm = record.data['rowid'];
						//alert(sf)
						/*if((sf == '1')&&(sm !='')) {		
							return '<span style="color:blue;cursor:hand;"><u>维护数据</u></span>';
						} */
						if(sm !='') {		
							return '<span style="color:blue;cursor:hand;"><u>维护数据</u></span>';
						} 
						else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},					
			hidden : false      

		},{ 
		    id:'SplitLayer',
		    header: '分解层',
			//allowBlank: false,
			width:300,
			editable:false,
            dataIndex: 'SplitLayer',
            hidden: true
		},{ 
		    id:'isLast',
		    header: '是否末级',
			width:60,
			editable:false,
            dataIndex: 'isLast',
            hidden: true
		}],
		tbar:[findButton,'-',editButton,'-',editrButton,'-'],
		//viewConfig : {
		//				forceFit : true
		//			},
		loadMask: true,
		atLoad: true
    
    });
    
    /*itemGrid.addButton('-');
    itemGrid.addButton(findButton);
    itemGrid.addButton('-');
    itemGrid.addButton(editButton);*/

    itemGrid.btnAddHide();  //隐藏增加按钮
    //itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    //itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	// 前置方案设置
	var records = itemGrid.getSelectionModel().getSelections();
	var SpltMainDR = records[0].get("rowid");
	//alert(SpltMainDR);
	if(SpltMainDR!=""){
	//alert(222);
	if (columnIndex == 10) {
	    //alert(333)
		var records = itemGrid.getSelectionModel().getSelections();
		var SpltMainDR = records[0].get("rowid");
		//alert(rowid)
		//var DeptType = records[0].get("DeptType")
		//var DeptCode = records[0].get("DeptCode")
		//var DeptName = records[0].get("DeptName")
		var SplitLayer = records[0].get("SplitLayer")
		// 预算方案编辑页面
		BudgDetailFun(SpltMainDR,SplitLayer);
	}
	}
});
    
    
    
