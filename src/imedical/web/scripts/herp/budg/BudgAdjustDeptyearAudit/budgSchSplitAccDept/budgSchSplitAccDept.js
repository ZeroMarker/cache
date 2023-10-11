//////////////////Ԥ�������//////////1��ƿ�Ŀ2ҽ��ָ��
var BTypeDs = new Ext.data.SimpleStore({
			fields : ['rowid', 'name'],
			data : [['1', '��ƿ�Ŀ'], ['2', 'ҽ��ָ��']]
		});

var BTypeCombo = new Ext.form.ComboBox({
			fieldLabel : 'Ԥ�����',
			store : BTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,		
			triggerAction : 'all',
			emptyText:'ѡ��...',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			mode : 'local', // ����ģʽ
			selectOnFocus : true
		});


/////////////////Ԥ�����/////////////////////////////////
var budgetDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	budgetDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitaccdeptexe.csp?action=BudgTyplist',method:'POST'});		
	});		
	var BudgetType = new Ext.form.ComboBox({
		fieldLabel:'Ԥ�����',
		store: budgetDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'ѡ��...',
		width: 150,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////����/////////////////////////////////
var BudgetCode = new Ext.form.TextField({
		id: 'BudgetCode',
		fieldLabel: 'Ԥ�����',
		allowBlank: true,
		emptyText:'ѡ��...',
		width:120,
	    listWidth : 120
	});

/////////////////��/////////////////////////////////
var YearDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	YearDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitaccdeptexe.csp?action=Yaerlist',method:'POST'});
		
	});
		
	var YearCombo = new Ext.form.ComboBox({
		fieldLabel:'���',
		store: YearDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'ѡ��...',
		width: 120,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});
	
	
//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){

		var year=YearCombo.getValue();
		var btype=BTypeCombo.getValue();
		var bname=BudgetType.getValue();
		var bcode=BudgetCode.getValue();

		itemGrid.load(({params:{start:0, limit:25,year:year,type:btype,bname:bname,bcode:bcode}}));
	}
});	

//�������÷ֽⷽ����ť
var editButton = new Ext.Toolbar.Button({
	text: '��������',
	tooltip: '��������',
	iconCls: 'add',
	handler: function(){
		EditFun();
		}
});

//�������÷ֽⷽ��
var editrButton = new Ext.Toolbar.Button({
	text: '����',
	tooltip: '����',
	iconCls: 'add',
	handler: function(){
		editrFun(itemGrid);
		}
});
//////////////////////�ֽⷽ��//////////////////['1', '��ʷ����'], ////////
var SplitMethStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['2', '��ʷ����*���ڱ���'], ['3', '����ϵ��']]
		});
var SplitMethField = new Ext.form.ComboBox({
			id : 'SplitMethField',
			fieldLabel : '�ֽⷽ������',
			width : 200,
			//listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : SplitMethStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

///////////////////////����ʾ//////////////////////////////////
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
			value : '<center><p style="font-weight:bold;font-size:120%">Ԥ��ֽⷽ������(ȫԺ-����)</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
		            xtype : 'displayfield',
					value : '���:',
					columnWidth : .06
				},YearCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : 'Ԥ�����:',
					columnWidth : .10
				},BTypeCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : 'Ԥ�����:',
					columnWidth : .10
				},BudgetType,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '����:',
					columnWidth : .06
				},BudgetCode

		]
	}]
});

//////////////*************************************///////////////				
var itemGrid = new dhc.herp.Grid({
        //title: 'Ԥ��ֽⷽ������(ȫԺ-����)',
        region: 'center',
        url: 'herp.budg.budgschsplitaccdeptexe.csp',
		
		listeners : {
            'cellclick' : function(grid, rowIndex, columnIndex, e) {
                var record = grid.getStore().getAt(rowIndex);
                  // �����������õ�Ԫ�����༭�Ƿ����  1��ĩ��0����
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
				// Ԥ����Ŀ��ʽ�༭
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
            header: '���',
			width:80,
			update : true,			
			editable:false,
            dataIndex: 'year',
            hidden: false
        },{
            id:'code',
            header: '��Ŀ����',
			allowBlank: false,
			width:150,
			update : true,			
			editable:false,
            dataIndex: 'code'
        },{
		    id:'superCode',
		    header: '�ϼ�����',
			//allowBlank: false,
			width:100,
			editable:false,
            dataIndex: 'superCode',
            hidden: true
		},{ 
		    id:'dname',
		    header: '��Ŀ����',
			//allowBlank: false,
			width:250,
			editable:false,
            dataIndex: 'dname'
		},{ 
		    id:'level',
		    header: 'Ԥ�㼶��',
			//allowBlank: false,
			width:250,
			editable:false,
            dataIndex: 'level',
            hidden: true
		},{ 
		    id:'lisLast',
		    header: '�Ƿ�ĩ��',
			allowBlank: false,
			width:60,
			editable:false,
            dataIndex: 'lisLast',
            hidden: false
		},{ 
		    id:'splitMeth',
		    header: '�ֽⷽ������',
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
		    header: '���ڱ���',
			width:200,
            dataIndex: 'rate',
            align : 'center',
            editable:false,
            /*renderer : function(v, p, r) {
						return '<span style="color:blue;cursor:hand"><u>ά������</u></span>';
					},*/
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var sf = record.data['isLast'];
						var sm = record.data['rowid'];
						//alert(sf)
						/*if((sf == '1')&&(sm !='')) {		
							return '<span style="color:blue;cursor:hand;"><u>ά������</u></span>';
						} */
						if(sm !='') {		
							return '<span style="color:blue;cursor:hand;"><u>ά������</u></span>';
						} 
						else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},					
			hidden : false      

		},{ 
		    id:'SplitLayer',
		    header: '�ֽ��',
			//allowBlank: false,
			width:300,
			editable:false,
            dataIndex: 'SplitLayer',
            hidden: true
		},{ 
		    id:'isLast',
		    header: '�Ƿ�ĩ��',
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

    itemGrid.btnAddHide();  //�������Ӱ�ť
    //itemGrid.btnSaveHide();  //���ر��水ť
    itemGrid.btnResetHide();  //�������ð�ť
    //itemGrid.btnDeleteHide(); //����ɾ����ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	// ǰ�÷�������
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
		// Ԥ�㷽���༭ҳ��
		BudgDetailFun(SpltMainDR,SplitLayer);
	}
	}
});
    
    
    
