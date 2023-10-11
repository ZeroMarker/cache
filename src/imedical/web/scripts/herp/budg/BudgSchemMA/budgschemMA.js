var USERID = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var IsDBStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '否'], ['1', '是']]
		});
var IsDBField = new Ext.form.ComboBox({
			id : 'IsDBField',
			fieldLabel : '是否代编',
			width : 70,
			listWidth : 70,
			selectOnFocus : true,
			allowBlank : false,
			store : IsDBStore,
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


// ////////////////////////////////////
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
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var schemNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 120,
			columnWidth : .12,
			selectOnFocus : true

		});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	
	      		var year = yearCombo.getValue();
				//alert(year);
				var schName = schemNo.getValue();
				itemGrid.load({params : {start : 0,limit : 25,year : year,schemtype : schName,USERID:USERID}});
	}
});

var itemDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

itemDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmamainexe.csp'
								+ '?action=BudgNList&str='
								+ encodeURIComponent(Ext.getCmp('budgItem')
										.getRawValue()) + '&year='
								+ yearCombo.getValue(),
						method : 'POST'
					})
		});

var itemcbbox = new Ext.form.ComboBox({
			id : 'budgItem',
			fieldLabel : '预算项目',
			width : 100,
			listWidth : 100,
			allowBlank : false,
			store : itemDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'budgItem',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//是否已经审批
var IsCheckStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','否'],['0','是']]
});
var IsCheckCom= new Ext.form.ComboBox({
	id: 'IsCheck',
	fieldLabel: '是否是当前审批',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	store: IsCheckStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'选择模块名称...',
	mode: 'local', // 本地模式
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

//编制状态
var ChkStateStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','新建'],['2','提交'],['3','通过'],['4','完成']]
});
var ChkStateStoreField = new Ext.form.ComboBox({
	id: 'ChkStateStoreField',
	fieldLabel: '编制状态',
	width:120,
	listWidth : 215,
	selectOnFocus: true,
	allowBlank: false,
	store: ChkStateStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'选择模块名称...',
	mode: 'local', // 本地模式
	editable:false,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

var itemGrid = new dhc.herp.Grid({
            title : '科室科目预算编制',
			region : 'north',
			url : 'herp.budg.budgschemmamainexe.csp',
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
						width : 60,
						editable:false,
						// type:itemcbbox,
						hidden : false

					}, {
						id : 'Code',
						header : '方案编码',
						width : 70,
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
						id : 'audtName',
						header : '方案归口科室',
						width : 100,
						editable:false,
						allowBlank : false,
						dataIndex : 'audtName'

					},{
						id : 'OrderBy',
						header : '编制顺序',
						editable:false,
						width : 60,
						dataIndex : 'OrderBy'

					}, {
						id : 'ItemName',
						header : '结果预算项',
						editable:false,
						dataIndex : 'ItemName'

					}, {
						header : '前置方案',
						editable : false,
						align : 'center',
						renderer : function(v, p, r) {
								return '<span style="color:blue;cursor:hand"><u>查询</u></span>';								
						},
						dataIndex : 'SupSchem'

					},{
						id : 'IsHelpEdit',
						header : '是否代编',
						width : 60,
						editable:false,
						type : IsDBField,
						hidden:true,
						dataIndex : 'IsHelpEdit'

					}, {
						id : 'ChkState',
						header : '编制状态',
						width : 60,
						editable : false,
						dataIndex : 'ChkState',
						type:ChkStateStoreField
						
					},{
						header : '编制步骤',
						editable : false,
						align : 'center',
						dataIndex : 'ChkStep'
					},{
						id : 'CHKFlowDR',
						header : '审批流',
						hidden:true,
						width : 60,
						editable:false,
						dataIndex : 'CHKFlowDR'
					},{
						id : 'ChkFlowName',
						header : '审批流',
						width : 60,
						editable:false,
						dataIndex : 'ChkFlowName'
					},{
						id : 'File',
						header : '文件',
						width : 60,
						editable:false,
						//hidden:true,
						dataIndex : 'File'

					},{
						id : 'Initials',
						header : '登录用户名',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'Initials'

					},{
						id:'IsCurStep',
						header: '是否为当前审批',
						width:110,
						//tip:true,
						allowBlank: true,
						editable:false,
						update:true,
						dataIndex: 'IsCurStep',
						hidden: true,
						type:IsCheckCom
					},{
						id:'schemAuditDR',
        				header: '方案归口表ID',
        				width:110,
	    				//tip:true,
	    				allowBlank: true,
	    				editable:false,
	    				hidden: true,
        				dataIndex: 'schemAuditDR'
        	
    				},{
    					id:'CurStepNO',
        				header: '当前审批顺序号',
        				width:110,
	    				editable:false,
	    				hidden: true,
        				dataIndex: 'CurStepNO'
        	
    				},{
    					id:'StepNOC',
        				header: '本人审批顺序号',
        				width:110,
	    				editable:false,
	    				hidden: true,
        				dataIndex: 'StepNOC'
        	
    				},{
    					id:'StepNO',
        				header: '本人审批流顺序号',
        				width:150,
						editable:false,
	    				hidden: true,
        				dataIndex: 'StepNO'
        	
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
					tbar : ['年度:', yearCombo, '方案名称:', schemNo, '-', findButton],
					height:230,
					trackMouseOver: true,
					stripeRows: true

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
	params:{start:0, limit:12,USERID:USERID},

	callback:function(record,options,success ){
		//alert("a")
	MAitemGrid.fireEvent('rowclick',this,0);
	}
});
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var schemeDr='';
    //alert(rowIndex);
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var iscurstep=selectedRow[0].data['IsCurStep'];
	var StepNO=selectedRow[0].data['StepNOC'];  //审批顺序号
	var CurStepNO=selectedRow[0].data['CurStepNO'];
	var BillState=selectedRow[0].data['ChkState'];
	var year = selectedRow[0].data['Year'];
	var schemeDr=selectedRow[0].data['rowid'];
	
	if(BillState=='2'){
			backoutButton.enable();
		 	submitButton.disable()
		}
		if((StepNO>=CurStepNO)&&(BillState!=='1')&&((StepNO!=="")&&(CurStepNO!==""))) {
			backoutButton.enable();
			submitButton.disable();
		}if(BillState=='1'){
			backoutButton.disable();
			submitButton.enable();
		}
		 
	
	MAitemGrid.load({params:{start:0, limit:12,SchemDr:schemeDr,year:year}});	
});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	// 前置方案设置
	if (columnIndex == 9) {
	
		var records = itemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid");
		var schmName = records[0].get("Name");
		var OrderBy = records[0].get("OrderBy");
		var year = records[0].get("Year");
        //alert(OrderBy);
		// 预算方案编辑页面
		supSchemeFun(schmDr, schmName, year, OrderBy);
	}

});

