// 年度///////////////////////////////////
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
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
			width : 100,
			listWidth : 245,
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
			width : 120,
			listWidth : 245,
			selectOnFocus : true,
			store : typeStore,
			anchor : '90%',
		   // value:'key', //默认值
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


/////////////////科室名称/////////////////////////////////
var DnameDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});
	DnameDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=dept&flag=1',method:'POST'});		
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
		width: 120,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
      	var year = yearCombo.getValue();
		var type = typeField.getValue();
		var deptdr = DnameComb.getValue();
		itemGrid.load({params : {start : 0,limit : 25,year : year,type : type,deptdr:deptdr}});
	}
});


var itemGrid = new dhc.herp.Grid({
            title : '科室预算编制状态查询',
			region : 'west',
			url : 'herp.budg.budgschemmadstateexe.csp',
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'CompName',
						header : '医疗单位',
						width : 90,
						editable : false,
						hidden : true,
						dataIndex : 'CompName'
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
						width : 60,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'

					}, {
						id : 'Name',
						header : '方案名称',
						width : 180,
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
						width : 120,
						editable:false,
						allowBlank : false,
						hidden:true,
						dataIndex : 'deptdr'

					}, {
						id : 'dName',
						header : '适用科室',
						width : 120,
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
						header : '登录用户',
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
						width : 100,
						editable:false,
						hidden:false,
						dataIndex : 'ChkStep'

					},{
						id : 'auditdr',
						header : '归口表id',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'auditdr'

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
					//viewConfig : { forceFit : true },
					tbar : ['年度:', yearCombo, '-','方案类型:', typeField, '-','科室:',DnameComb,'-', findButton],
					width:650,
					trackMouseOver: true,
					stripeRows: true

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮
    
itemGrid.load({	
	params:{start:0, limit:12},

	callback:function(record,options,success ){
		//alert("a")
	detailitemGrid.fireEvent('rowclick',this,0);
	}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var schemeDr='';
    //alert(rowIndex);
	var selectedRow = itemGrid.getSelectionModel().getSelections();
    //alert(selectedRow);
	schemeDr=selectedRow[0].data['rowid'];
	auditdr=selectedRow[0].data['auditdr'];
	//alert(schemeDr);
	//alert(dcode);
	detailitemGrid.load({params:{start:0, limit:12,SchemDr:schemeDr,auditdr:auditdr}});	
});

