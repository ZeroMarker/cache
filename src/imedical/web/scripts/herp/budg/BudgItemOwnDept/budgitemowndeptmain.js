var projUrl = 'herp.budg.budgitemowndeptexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//科室名称
var DeptNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'value'])
		});

DeptNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=listdept', 
                        method:'POST'
					});
		});
		
var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : DeptNameDs,
			displayField : 'value',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


var DeptNameDs1 = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'value'])
		});

DeptNameDs1.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=listdept1', 
                        method:'POST'
					});
		});
		
var deptCombo1 = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : DeptNameDs1,
			displayField : 'value',
			valueField : 'value',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


var CodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'value'])
		});

CodeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=listcode', 
                        method:'POST'
					});
		});
		
var codeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算科目',
			store : CodeDs,
			displayField : 'value',
			valueField : 'value',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		

var Code1Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'value'])
		});

Code1Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=listcode1', 
                        method:'POST'
					});
		});
		
var codeCombo1 = new Ext.form.ComboBox({
			fieldLabel : '预算科目',
			store : Code1Ds,
			displayField : 'value',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
/////////////////// 查询按钮 //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var Dept  = deptCombo1.getValue();
	    var Code = codeCombo.getValue();
		itemGrid.load({params:{start:0,limit:25,Dept:Dept,Code:Code}});
		
	}
});
var itemGrid = new dhc.herp.Grid({
        title: '科目的归口科室维护',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.budg.budgitemowndeptexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            id:'rowid',
            dataIndex: 'rowid',
            hidden: true
        },{
	            id : 'CompName',
	        header : '医疗单位',
                         width : 90,
	      editable : false,
	       hidden: true,
                     dataIndex : 'CompName'

	    },{
            id:'BIDName',
            header: '预算科目',
			allowBlank: true,
			width:200,
			align:'left',
            dataIndex: 'BIDName',
            type:codeCombo1
        },{
            id:'Name',
            header: '预算科室', 
            allowBlank:true,
            width:200,
            align:'left',
            dataIndex: 'Name',
            type: deptCombo
        }],
 tbar:['预算科目:',codeCombo,'-','科室名称:',deptCombo1,'-',findButton]

});

itemGrid.btnResetHide(); 	//隐藏重置按钮
itemGrid.btnPrintHide(); 	//隐藏打印按钮