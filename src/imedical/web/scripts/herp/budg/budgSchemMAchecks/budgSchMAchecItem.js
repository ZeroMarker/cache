//rowid^Year^Code^Name^ItemCode^OrderBy^IsCheck^CheckDate^Checker^File^IsHelpEdit^CHKFlowDR^IsSys
//^SupSchem^ctStep
// ************************************************

//var DictSupplierTabUrl = 'herp.budg.budgSchemMAchecksitemexe.csp';
/*
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
		});*/
/*
var schemNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

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
						url : 'herp.budg.budgSchemMAchecksitemexe.csp'
								+ '?action=BudgNList&str='
								+ encodeURIComponent(Ext.getCmp('budgItem')
										.getRawValue()) + '&byear='
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
		});*/

// ////////////////////////////////////
var SchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgSchemMAchecksitemexe.csp?action=SchTypeList',
						method : 'POST'
					});
		});

var SchTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算项类别',
			store : SchTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var searchbotton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	

	      	var selectedRow = itemGrid.getSelectionModel().getSelections();
			SchemDr=selectedRow[0].data['rowid'];
			dcode=selectedRow[0].data['EditDeptDR'];
			var schtype=SchTypeCombo.getValue();
	      	//alert(schtype);
			//alert(dcode);
			//alert(SchemDr)
	      	if (SchemDr == ""){
							message = '请先选择对应方案的行！';
					}else{	
			detailitemGrid.load({params:{start:0, limit:12,SchemDr:SchemDr,dcode:dcode,type:schtype}})
			}
	}
});

var upstatebotton = new Ext.Toolbar.Button({
	text: '审批',
	tooltip: '审批',
	iconCls: 'option',
	handler: function(){
	    
	    var rowObj=detailitemGrid.getSelectionModel().getSelections();
	    var len = rowObj.length;
	    //alert(len);
	    var rowid = rowObj[0].data['rowid'];
	    //alert(rowid);
	    
	    if((len < 1)){
		    Ext.Msg.show({title:'注意',msg:'请选择一行！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    else if(rowid == " "){
	        Ext.Msg.show({title:'注意',msg:'预算项没有对应的科室！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	    }
	    else{
	      	Ext.MessageBox.confirm('提示', '确定要审核此方案对应的预算项吗', function(btn) {
			if (btn == 'yes') {
				var uurl = 'herp.budg.budgSchemMAchecksitemexe.csp?action=updState&&rowid='
						+ rowid;
				detailitemGrid.saveurl(uurl)
			}		});  			
		}
	}
});

var detailitemGrid = new dhc.herp.Grid({
            title : '预算项预算', 
			region : 'center',
			url : 'herp.budg.budgSchemMAchecksitemexe.csp',
			
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 // alert(record.get('EditMod'));
		                    if ((columnIndex == 8)&&(record.get('EditMod') == '1')) {
		                         return false;
		                     } 
		                    else {
		                     return true;
		                     }
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);

						if ((columnIndex == 8)&&(record.get('EditMod') == '1')) {						
							return false;
						} else {
							return true;
						}
					}
            },
						
			fields : [
			new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header : 'ID',
						dataIndex : 'rowid',
						update:true,
						width : 60,
						hidden : true
					}, {
						id : 'Code',
						header : '预算编码',
						dataIndex : 'Code',
						width : 70,
						editable:false,
						update:true,
						// type:itemcbbox,
						hidden : false

					}, {
						id : 'Name',
						header : '预算名称',
						width : 120,
						editable:false,
						//allowBlank : false,
						dataIndex : 'Name'

				}, {
						id : 'Year',
						header : '年度',
						width : 120,
						editable:false,
						update:true,
						hidden : true,
						dataIndex : 'Year'

				}, {
						id : 'TypeCode',
						header : '预算类别',
						width : 120,
						editable:false,
						//allowBlank : false,
						dataIndex : 'TypeCode'

					},{
						id : 'CalcValue',
						header : '全院',
						width : 70,
						editable: true,
						update:true,
						overrender: true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
							cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
							var cv="1";
							if(cv == '1'){
							return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
							}
						},				
						dataIndex : 'CalcValue'
					}, {
						id : 'PlanValue',
						header : '科室预算',
						width : 70,
						//align : 'center',
						editable: true,
						update:true,
						overrender: true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var em = record.data['EditMod']
						if (em == '2'||em == '3') {
							cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
							return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
						}else{
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}
					},
						dataIndex : 'PlanValue'

					}, {
						id : 'dis1',
						header : '差额',
						width : 70,
						editable : false,
						//align : 'center',
						dataIndex : 'dis1'
						
					},{
						id : 'disrate1',
						header : '差异率(%)',
						width : 100,
						editable:false,
						//type : IsDBField,
						//hidden:true,
						dataIndex : 'disrate1'

					}, {
						id : 'RealValueLast',
						header : '上年执行',
						width : 70,
						editable : false,
						dataIndex : 'RealValueLast'
						
					},{
						id : 'dis2',
						header : '差额',
						width : 70,
						editable : false,
						//align : 'center',
						dataIndex : 'dis2'
					},{
						id : 'disrate2',
						header : '差异率(%)',
						width : 100,
						editable:false,
						dataIndex : 'disrate2'
						
					},{
						id : 'CalFlag',
						header : '编制方法',
						width : 130,
						editable:false,
						//hidden:true,
						dataIndex : 'CalFlag'

					},{
						id : 'EditMod',
						header : '编制模式',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'EditMod'

					},{
						id : 'CalDesc',
						header : '参考方法',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'CalDesc'

					},{
						id : 'ChkDesc',
						header : '审批意见',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'ChkDesc'

					},{
						id : 'DeptDR',
						header : '科室',
						width : 80,
						editable:false,
						update:true,
						//hidden:true,
						dataIndex : 'DeptDR'

					},{
						id : 'PlanValueModi',
						header : '上次修改',
						width : 80,
						editable:false,
						hidden:true,
						update:true,
						dataIndex : 'PlanValueModi'

					},{
						id : 'PlanValueModiMid',
						header : '修改中间数',
						width : 80,
						editable:false,
						update:true,
						hidden:true,
						dataIndex : 'PlanValueModiMid'

					},{
						id : 'Level',
						header : '级次',
						width : 80,
						editable:false,
						update:true,
						hidden:true,
						dataIndex : 'Level'
						
					}],
					tbar:['预算项类别',SchTypeCombo,'-',searchbotton,'-',upstatebotton],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					viewConfig : {
						forceFit : true
					},		
					loadMask: true,
					atLoad: true,
					trackMouseOver: true,
					stripeRows: true
					

		});

  /*
    detailitemGrid.hiddenButton(6);
    detailitemGrid.hiddenButton(7);
    detailitemGrid.hiddenButton(8);
    detailitemGrid.hiddenButton(9);
    detailitemGrid.hiddenButton(10);

    */
    detailitemGrid.btnAddHide();  //隐藏增加按钮
    detailitemGrid.btnSaveHide(555);  //隐藏保存按钮
    detailitemGrid.btnResetHide();  //隐藏重置按钮
    detailitemGrid.btnDeleteHide(); //隐藏删除按钮
    detailitemGrid.btnPrintHide();  //隐藏打印按钮
    
    
    

