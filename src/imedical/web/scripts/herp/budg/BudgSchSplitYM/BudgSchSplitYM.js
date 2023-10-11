var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var SchSplitUrl='herp.budg.budgschsplitymexe.csp';

/////////////////年/////////////////////////////////
var YearDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['year','year'])
	});
	YearDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:commonboxUrl+'?action=year',method:'POST'});
	});
	var YearCombo = new Ext.form.ComboBox({
		fieldLabel:'年度',
		store: YearDs,
		displayField:'year',
		valueField:'year',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 120,
		listWidth : 285,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////科室名称/////////////////////////////////
var DnameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	DnameDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:commonboxUrl+'?action=dept&flag=1&str=',method:'POST'});		
	});		
	var DnameComb = new Ext.form.ComboBox({
		fieldLabel:'科室名称',
		store: DnameDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 150,
		listWidth : 285,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});
	
/////////////////编码/////////////////////////////////
var BudgetCode = new Ext.form.TextField({
		id: 'BudgetCode',
		fieldLabel: '预算科目编码',
		allowBlank: true,
		emptyText:'选择...',
		width:150,
	    listWidth : 150
	});
	
//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'search',
	handler:function(){
		var year=YearCombo.getValue();
		var deptdr=DnameComb.getValue();
		var code=BudgetCode.getValue();
		if(deptdr ==""){
			Ext.Msg.show({title:'注意',msg:'科室为必选项!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		itemGrid.load(({params:{start:0, limit:25,year:year,deptdr:deptdr,code:code}}));
	}
});	

//批量
var batchEditButton = new Ext.Toolbar.Button({
	text: '批量设置',
	tooltip: '批量设置',
	iconCls: 'add',
	handler: function(){
		var deptname   = DnameComb.getValue();
			batchEditFun(itemGrid,deptname);
		}
});

//批量设置分解方法按钮
var editRButton = new Ext.Toolbar.Button({
	text: '批量维护系数',
	tooltip: '批量维护系数',
	iconCls: 'add',
	handler: function(){
	    var rowObj=itemGrid.getSelectionModel().getSelections();
	    //定义并初始化行对象长度变量
	    var len = rowObj.length;
	    //判断是否选择了要修改的数据
	    if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要设置的科目!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }else if(rowObj[0].get("isLast")==0)
	    {
		    Ext.Msg.show({title:'注意',msg:'不是末级，不能设置!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
	    }
			var Bcode = rowObj[0].get("code");
			var Sname = rowObj[0].get("Sname");
			var year = rowObj[0].get("year");
			var deptdr=DnameComb.getValue();
			EditRFun(Sname,Bcode,itemGrid,deptdr,year);
		}
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
			value : '<center><p style="font-weight:bold;font-size:120%">预算分解方法设置(年度-月)</p></center>',
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
					columnWidth : .05
				},YearCombo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .09
				},DnameComb, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '科目编码:',
					columnWidth : .09
				},BudgetCode
		]
	}]
});

//ComboBox in an Editor Grid: create reusable renderer
//适用于渲染时combobox中数据已装载的情况
Ext.util.Format.comboRenderer = function(combo){
    return function(value){    	
        var record = combo.findRecord(combo.valueField, value);
        return record ? record.get(combo.displayField) : combo.valueNotFoundText;
    }
}

//是否末级
var IsLastStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '否'], ['1', '是']]
		});
var IsLastCombo = new Ext.form.ComboBox({
			id : 'IsLastCombo',
			fieldLabel : '是否末级',
			width : 200,
			selectOnFocus : true,
			store : IsLastStore,
			anchor : '90%',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			selectOnFocus : true,
			forceSelection : true
		});
		
//////////////////////分解方法/////////////////////
var SplitMethField = new Ext.form.ComboBox({												
				fieldLabel: '分解方法设置',
				width:120,
				anchor: '90%',
				store : new Ext.data.ArrayStore({
					fields:['key','keyValue'],
					data : [['1', '历史数据'], ['2', '历史数据*调节比例'], ['3', '比例系数'],
							['4', '全面贯彻'], ['5', '均摊']]
				}),
				displayField : 'keyValue',
				valueField : 'key',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});

//////////////*************************************///////////////				
var itemGrid = new dhc.herp.Grid({
        //title: '预算分解方法设置(年度-月)',
        region: 'center',
        url: SchSplitUrl,
		listeners : {
            'cellclick' : function(grid, rowIndex, columnIndex, e) {
                var record = grid.getStore().getAt(rowIndex);
                  // 根据条件设置单元格点击编辑是否可用  1是末级0不是
                    if ((record.get('isLast') == '0')&& ((columnIndex == 13)||(columnIndex == 12))) {
                         return false;
                     } else {return true;}
               },
            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				// 预算项目公式编辑
				if ((record.get('isLast') == '0') && ((columnIndex == 13)||(columnIndex == 12))) {
				
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
	        id : 'CompName',
	        header : '医疗单位',
	        hidden: true,
            width : 90,
	      	editable : false,
            dataIndex : 'CompName'
	    },{
            id:'year',
            header: '年度',
			width:80,		
			editable:false,
			update:true,
            dataIndex: 'year',
            hidden: false
        },{
            id:'deptDR',
            header: '科室编码',
			width:150,		
			editable:false,
            dataIndex: 'deptDR',
            hidden: true
        },{
            id:'deptname',
            header: '科室名称',
			width:150,		
			editable:false,
            dataIndex: 'deptname',
            hidden: false
        },{
            id:'code',
            header: '科目编码',
			allowBlank: false,
			width:100,
			update : true,			
			editable:false,
            dataIndex: 'code'
        },{ 
		    id:'superCode',
		    header: '上级编码',
			//allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'superCode',
            hidden: true
		},{ 
		    id:'Sname',
		    header: '科目名称',
			//allowBlank: false,
			width:200,
			editable:false,
            dataIndex: 'Sname'
		},{ 
		    id:'level',
		    header: '预算级别',
			//allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'level',
            hidden: true
		},{ 
		    id:'isLast',
		    header: '是否末级',
			allowBlank: false,
			width:100,
			editable:false,
			update:true,
            dataIndex: 'isLast',
			editor : new Ext.grid.GridEditor(IsLastCombo),
			renderer :Ext.util.Format.comboRenderer(IsLastCombo)	 
		},{ 
			id:'splitMeth',
		    header: '分解方法设置',
			allowBlank: false,
			width:200,	
			type : SplitMethField,
			editable:true,
            dataIndex: 'splitMeth'
		},{ 
		    id:'rate',
		    header: '调节比例',
			width:150,
            dataIndex: 'rate',
            align : 'center',
            editable:false,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var sf = record.data['isLast'];
						var sm = record.data['rowid'];
						//alert(sf)
						if((sf == '1')&&(sm !='')) {		
							return '<span style="color:blue;cursor:hand;"><u>维护数据</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},					
			hidden : false      
		},{ 
		    id:'SplitLayer',
		    header: '分解层',
			//allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'SplitLayer',
            hidden: false
		}],
		//loadMask: true,
		viewConfig : {forceFit : true},
		tbar:[findButton,'-',batchEditButton,'-',editRButton]
		//atLoad: true
    });
    
    itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮
 
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// 前置方案设置
	var records = itemGrid.getSelectionModel().getSelections();
	var SpltMainDR = records[0].get("rowid");
	if(SpltMainDR!=""){
		if (columnIndex == 13) {
			var deptname   = DnameComb.getValue();
			if(deptname ==""){
				Ext.Msg.show({title:'注意',msg:'请选择预算项对应的科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			var records = itemGrid.getSelectionModel().getSelections();
			var SpltMainDR = records[0].get("rowid")
			var SpltMainDR = records[0].get("rowid")
			var Sname      = records[0].get("Sname")
			var SplitLayer = records[0].get("SplitLayer")
	       	var ddname = records[0].get("deptname")
			// 预算方案编辑页面
			YMDetailFun(itemGrid,SpltMainDR,SplitLayer,Sname,deptname,ddname);
		}
	}
});      