SbudgFun=function(){
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';	
// 年度///////////////////////////////////

var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
	
// ////////////方案类别////////////////////////
var typeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '计划指标'], ['2', '收支预算'], ['3', '费用标准'], ['4', '预算结果表']]
		});
var typeField = new Ext.form.ComboBox({
			id : 'typeField',
			fieldLabel : '方案类型',
			width : 200,
			selectOnFocus : true,
			store : typeStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});


var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	
	      	var year = yearCombo.getValue();
				//alert(year);
				var type = typeField.getValue();
				
				itemGridS.load({params : {start : 0,limit : 25,year : year,type : type}});
	}
});

var itemGridS = new dhc.herp.Grid({
            title : '全院预算编制状态',
			region : 'center',
			url : 'herp.budg.budgschemmasstateexe.csp',
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'Year',
						header : '年度',
						dataIndex : 'Year',
						width : 50,
						editable:false,
						hidden : false

					}, {
						id : 'Code',
						header : '方案编码',
						width : 50,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'

					}, {
						id : 'Name',
						header : '方案名称',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'Name'

					}, {
						id : 'OrderBy',
						header : '编制顺序',
						width : 60,
						editable:false,
						allowBlank : false,
						dataIndex : 'OrderBy'

					}, {
						id : 'Type',
						header : '方案类型',
						width : 60,
						editable:false,
						allowBlank : false,
						hidden:true,
						dataIndex : 'Type'

					}, {
						id : 'deptdr',
						header : '编制科室',
						width : 60,
						editable:false,
						allowBlank : false,
						hidden:true,
						dataIndex : 'deptdr'

					}, {
						id : 'dName',
						header : '编制科室',
						width : 60,
						editable:false,
						allowBlank : false,
						hidden:false,
						dataIndex : 'dName'

					},{
						id : 'UserDR',
						header : '用户',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'UserDR'

					},{
						id : 'Initials',
						header : '登录用户名',
						width : 60,
						editable:false,
						hidden:false,
						dataIndex : 'Initials'

					},{
						id : 'ChkState',
						header : '编制状态',
						width : 60,
						editable:false,
						hidden:false,
						dataIndex : 'ChkState'

					},{
						id : 'ChkStep',
						header : '审核步骤',
						width : 60,
						editable:false,
						hidden:false,
						dataIndex : 'ChkStep'

					}],
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					viewConfig : {
						forceFit : true
					},
					tbar : ['年度:', yearCombo, '方案类型:', typeField, '-', findButton],
					width:650,
					trackMouseOver: true,
					stripeRows: true

		});

    itemGridS.btnAddHide();  //隐藏增加按钮
    itemGridS.btnSaveHide();  //隐藏保存按钮
    itemGridS.btnResetHide();  //隐藏重置按钮
    itemGridS.btnDeleteHide(); //隐藏删除按钮
    itemGridS.btnPrintHide();  //隐藏打印按钮
    
itemGridS.load({	
	params:{start:0, limit:12}

	//callback:function(record,options,success ){
		//alert("a")
	//detailitemGrid.fireEvent('rowclick',this,0);
	//}
});
/*
itemGridS.on('rowclick',function(grid,rowIndex,e){	
	var schemeDr='';
    //alert(rowIndex);
	var selectedRow = itemGridS.getSelectionModel().getSelections();
    //alert(selectedRow);
	schemeDr=selectedRow[0].data['rowid']
	//alert(schemeDr);
	//alert(dcode);
	detailitemGrid.load({params:{start:0, limit:12,SchemDr:schemeDr}});	
});*/

	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [itemGridS]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '全院预算编制状态',
				plain : true,
				width : 900,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}
