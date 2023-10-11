
// 年度///////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgSchemMAchecksexe.csp?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 50,
			listWidth : 50,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ////////////fangan名称////////////////////////
var SnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

SnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgSchemMAchecksexe.csp?action=SnameList',
						method : 'POST'
					});
		});

var SnameCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : SnameDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 90,
			listWidth : 90,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	
	      	var year = yearCombo.getValue();
				//alert(year);
				var deptcode = SnameCombo.getValue();
					//alert(schName);
				itemGrid.load({params : {start : 0,limit : 25,byear : year,dcode : deptcode}});
	}
});


var itemGrid = new dhc.herp.Grid({
            title : '科室年度预算编制',
			region : 'west',
			url : 'herp.budg.budgSchemMAchecksexe.csp',
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
						header : '科室编码',
						width : 50,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'

					}, {
						id : 'Name',
						header : '科室名称',
						width : 100,
						editable:false,
						allowBlank : false,
						dataIndex : 'Name'

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
						hidden:true,
						dataIndex : 'Initials'

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
					tbar : ['年度:', yearCombo, '方案名称:', SnameCombo, '-', findButton],
					width:280,
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
	dcode=selectedRow[0].data['Code'];
	//alert(schemeDr);
	//alert(dcode);
	detailitemGrid.load({params:{start:0, limit:12,SchemDr:schemeDr,dcode:dcode}});	
});

