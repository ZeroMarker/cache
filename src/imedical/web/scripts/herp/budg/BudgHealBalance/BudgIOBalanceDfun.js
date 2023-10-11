//MADFun(sName, MAitemGrid)
balanceDFun = function(sName,SchemDR,Name, MAitemGrid,Year){

	var MADtitle = '当前预算项名称 ：'+Name ;
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
///////////////////////科室名称///////////////////////////
var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	    deptTypeDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=dept',method:'POST'});
		
	});
		
	var deptTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'科室名称',
		store: deptTypeDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 110,
		listWidth : 110,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});


/////////////////////科室名称/////////////////////////////
var DeptNamefield = new Ext.form.TextField({
		id: 'DeptNamefield',
		fieldLabel: '科室名称',
		allowBlank: true,
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});
		

// 调节比例明细设置grid
var balanceDitemGrid = new dhc.herp.Grid({
				title : MADtitle,
				width : 400,
				region : 'center',
				viewConfig : {
						forceFit : true
					},
				url : 'herp.budg.budghealbalanceitemexe.csp',
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                  //alert(columnIndex);
		                  //alert(record.get('Year'));
		                    if ((record.get('Year') =="合计")&& ((columnIndex == 5)||(columnIndex == 9)||(columnIndex == 10)||(columnIndex == 11))) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('Year') =="合计") && ((columnIndex == 5)||(columnIndex == 9)||(columnIndex == 10)||(columnIndex == 11))) {						
							return false;
						} else {
							return true;
						}
					}},
				fields : [
				//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'DeptDR',
							header : '科室dr',
							dataIndex : 'DeptDR',
							width : 50,
							editable:false,
							hidden : true

						},{
							id : 'ItemCode',
							header : '预算项编码',
							dataIndex : 'ItemCode',
							update : true,
							width : 70,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'Year',
							header : '年度',
							dataIndex : 'Year',
							update : true,
							width : 40,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'DName',
							header : '科室名称',
							dataIndex : 'DName',
							width : 80,
							editable:false,
							type: deptTypeCombo,
							hidden : false

						},{
							id : 'Class',
							header : '科室类别编码',
							dataIndex : 'Class',
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'TName',
							header : '科室类别',
							dataIndex : 'TName',
							width : 100,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'SName',
							header : '预算项名称',
							dataIndex : 'SName',
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true
						},{
							id : 'CalcValue',
							header : '全院下达',
							dataIndex : 'CalcValue',
							//update : true,
							width : 70,
							align : 'right',
							editable:true,
							hidden : false

						},{
							id : 'PlanValue',
							header : '科室预算',
							//update : true,
							dataIndex : 'PlanValue',
							width : 70,
							align : 'right',
							editable:true,
							hidden : false

						},{
							id : 'disSm',
							header : '差额',
							dataIndex : 'disSm',
							width : 50,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'ratioSm',
							header : '差异率(%)',
							dataIndex : 'ratioSm',
							width : 80,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'sumcal',
							header : '总额1',
							dataIndex : 'sumcal',
							width : 80,
							align : 'right',
							editable:false,
							hidden : true

						},{
							id : 'sumplan',
							header : '总额2',
							dataIndex : 'sumplan',
							width : 80,
							align : 'right',
							editable:false,
							hidden : true

						},{
							id : 'PlanValueModiMid',
							header : '预算修改中间数',
							dataIndex : 'PlanValueModiMid',
							width : 80,
							align : 'center',
							update:true,
							editable:false,
							hidden : true

						}]
				//tbar:['年度:',YearCombo,'-','科室分类:',deptTypeCombo,'-','科室名称:',DeptNamefield,'-',findButton]

			});
	

	    balanceDitemGrid.btnAddHide();  //隐藏增加按钮
	    //balanceDitemGrid.btnSaveHide()  //隐藏保存按钮
	    balanceDitemGrid.btnResetHide(); //隐藏重置按钮
	    balanceDitemGrid.btnDeleteHide(); //隐藏删除按钮
	    balanceDitemGrid.btnPrintHide(); //隐藏打印按钮

    
	balanceDitemGrid.load({params:{start:0,limit:15,sName:sName,Year:Year}});
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  itemGrid.load({params:{start:0,limit:15,Year:Year}});
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [balanceDitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '科目预算平衡',
				plain : true,
				width : 800,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};