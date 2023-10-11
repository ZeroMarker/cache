var Userid = session['LOGON.USERID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var deptyearURL='herp.budg.adjustdeptyearexe.csp';

//调整序号
var BSMnameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['AdjustNo','AdjustNo'])
});
BSMnameDs.on('beforeload', function(ds, o){  
	var year =yearCombo.getValue();
	if(!year) 
	{
		Ext.Msg.show({title:'注意',msg:'请先选择年度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
});
var adjustnumber = new Ext.form.ComboBox({
	id: 'adjustnumber',
	fieldLabel: '调整序号',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BSMnameDs,
	valueField: 'AdjustNo',
	displayField: 'AdjustNo',
	triggerAction: 'all',
	emptyText:'请先选择年度....',
	name: 'adjustnumber',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

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
						url : commonboxURL+'?action=year&flag=',
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
			emptyText : '年度...',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			listeners:{
				select:{
				fn:function(combo,record,index) { 
					BSMnameDs.removeAll();     
					BSMnameDs.proxy= new Ext.data.HttpProxy({url:commonboxURL+'?action=adjustno&flag=0&year='+combo.value+'&start=0'+'&limit=10',method:'POST'});      
					BSMnameDs.load({params:{start:0,limit:10}});   
				}
				}
			},
			selectOnFocus : true
});

// ////////////科室名称////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : deptyearURL+'?action=deptNList',
						method : 'POST'
					});
		});
var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '科室名称...',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
	    var year = yearCombo.getValue();
        var adjusnumber=adjustnumber.getValue();
        var deptcode = deptCombo.getValue();
	    itemGrid.load({params : {start : 0,limit : 25,year : year,dept: deptcode,adjusnumber:adjusnumber}});
	}
});


var itemGrid = new dhc.herp.Gridhss({
            title : '科室年度预算调整',
			region : 'north',
			url : deptyearURL,
			fields : [
                    new Ext.grid.CheckboxSelectionModel({editable:false}),
                    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'CompName',
						header : '医疗单位',
						width : 100,
						editable:false,
						allowBlank : false,
						dataIndex : 'CompName'

					},{
						id : 'year',
						header : '年度',
						width : 70,
						editable:false,
						allowBlank : false,
						dataIndex : 'year'

					},{
						id : 'deptDRs',
						header : '科室',
						width : 120,
						editable:false,
						hidden:false,
						dataIndex : 'deptDRs'

					},  {
						id : 'Code',
						header : '方案编码',
						width : 70,
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

					},{
						id : 'OrderBy',
						header : '编制顺序',
						editable:false,
						width : 80,
						dataIndex : 'OrderBy'

					}, {
						id : 'ItemCode',
						header : '结果对应预算项',
						editable:false,
                         align : 'left',
						width : 100,
						dataIndex : 'ItemCode'

					}, {
						header : '前置方案',
						editable : false,
						align : 'center',
						renderer : function(v, p, r) {
								return '<span style="color:blue;cursor:hand"><u>查询</u></span>';								
						},
						dataIndex : 'SupSchem'

					}, {
						header : '编制状态',
						width : 70,
						editable : false,
						dataIndex : 'ChkState'
						
					},{
						header : '编制步骤',
						editable : false,
                                                align : 'left',
						dataIndex : 'ChkStep'
					},{
						id : 'CHKFlowDR',
						header : '审批流',
						width : 110,
						editable:false,
						dataIndex : 'CHKFlowDR'

					},{
						id : 'File',
						header : '说明文件',
						width : 70,
						editable:false,
						//hidden:true,
						dataIndex : 'File'

					},{
						id : 'deptDR',
						header : '科室dr',
						width : 70,
						editable:false,
						hidden:true,
						dataIndex : 'deptDR'

					},{
						id : 'AdjustNo',
						header : '调整号',
						width : 70,
						editable:false,
						dataIndex : 'AdjustNo'
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
					//viewConfig : {forceFit : true},
					tbar : ['年度:', yearCombo,'-','调整序号:',adjustnumber,'-','科室名称:', deptCombo, '-', findButton],
					height:230,
					trackMouseOver: true,
					stripeRows: true
                                      

		});

    //itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    //itemGrid.btnResetHide();  //隐藏重置按钮
    //itemGrid.btnDeleteHide(); //隐藏删除按钮
    //itemGrid.btnPrintHide();  //隐藏打印按钮

itemGrid.load({	params:{}});

itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var schemeDr=selectedRow[0].data['rowid'];
    var dcode = selectedRow[0].data['deptDR'];
    var byear = selectedRow[0].data['year'];
    var adjustno = selectedRow[0].data['AdjustNo'];
	//注意：保持主窗体主表格查询参数名与明细表格查询参数名不同！否则下表格的查询参数被传入上表格查询函数致使查询结果与底部工具条结果显示不一致！
	selfitemGrid.load({params:{SchemDr:schemeDr,deptdr:dcode,byear:byear,adjustno:adjustno}});	
});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// 前置方案设置
	if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid");
		var schmName = records[0].get("Name");
		var OrderBy = records[0].get("OrderBy");
		var Code = records[0].get("Code");
		// 预算方案编辑页面
		supSchemeFun(schmDr, schmName, Code, OrderBy);
	}
});