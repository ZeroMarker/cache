var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
MADFun = function(sName,SchemDR, MAitemGrid,schName,Year){

	var MADtitle = '当前预算项名称 ：'+schName ;

///////////////////////科室类别///////////////////////////
var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	    deptTypeDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=deptType',method:'POST'});
		
	});
		
	var deptTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'科室类别',
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

/////////////////年/////////////////////////////////
var YearDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	YearDs.on('beforeload', function(ds, o){		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemmadexe.csp?action=Yaerlist',method:'POST'});		
	});
		
	var YearCombo = new Ext.form.ComboBox({
		fieldLabel:'年度',
		store: YearDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 100,
		listWidth : 100,
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



		

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
       
        //var year=YearCombo.getValue();   
        
        //alert(year);
		var dtype=deptTypeCombo.getValue();
		var dname=DeptNamefield.getValue();
		MADitemGrid.load({params:{start:0, limit:25,sName:sName,year:Year,dtype:dtype,dname:dname}});
	}
});	


// 调节比例明细设置grid
var MADitemGrid = new dhc.herp.Grid({
				title : MADtitle,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschemmadexe.csp',
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                  //alert(columnIndex);
		                  //alert(record.get('rowid'));
		                    if ((record.get('rowid') =="")&& ((columnIndex == 9)||(columnIndex == 10))) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('rowid') =="") && ((columnIndex == 9)||(columnIndex == 10))) {						
							return false;
						} else {
							return true;
						}
					}},
				fields : [
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
							update : true,
							width : 50,
							//align : 'center',
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
							//align : 'center',
							editable:false,
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
							hidden : false

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
							width : 120,
							editable:true,
							align : 'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							  	cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							  	return '<span style="color:blue;cursor:hand;backgroundColor:blue">'+value+'</span>';
							},
							dataIndex : 'CalcValue'

						},{
							id : 'PlanValue',
							header : '科室预算',
							//update : true,
							dataIndex : 'PlanValue',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							align : 'right',
							editable:true,
							hidden : false

						},{
							id : 'disSm',
							header : '差额',
							dataIndex : 'disSm',
							width : 120,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'ratioSm',
							header : '差异率(%)',
							dataIndex : 'ratioSm',
							width : 100,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'RealValueLast',
							header : '上年执行',
							dataIndex : 'RealValueLast',
							width : 120,
							align : 'right',
							editable:false,
							hidden : false

						},{
							id : 'disSmNL',
							header : '差额',
							dataIndex : 'disSmNL',
							width : 120,
							align : 'right',
							editable:false,
							hidden : false
							
						},{
							id : 'ratioSmNL',
							header : '差异率(%)',
							dataIndex : 'ratioSmNL',
							width : 100,
							align : 'right',
							editable:false,
							hidden : false
							
						},{
							id : 'EditMeth',
							header : '编制方法',
							dataIndex : 'EditMeth',
							width : 80,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'EditMod',
							header : '编制模式',
							dataIndex : 'EditMod',
							width : 80,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'ChkDesc',
							header : '审核意见',
							dataIndex : 'ChkDesc',
							width : 60,
							//align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'PlanValueModiMid',
							header : '修改中间数',
							dataIndex : 'PlanValueModiMid',
							update : true,
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						},{
							id : 'PlanValueModi',
							header : '上次修改',
							dataIndex : 'PlanValueModi',
							update : true,
							width : 50,
							//align : 'center',
							editable:false,
							hidden : true

						}],
				tbar:['科室分类:',deptTypeCombo,'-','科室名称:',DeptNamefield,'-',findButton]

			});
	//'年度:',YearCombo,'-',

	    MADitemGrid.btnAddHide();  //隐藏增加按钮
	    //MADitemGrid.btnSaveHide()  //隐藏保存按钮
	    MADitemGrid.btnResetHide(); //隐藏重置按钮
	    MADitemGrid.btnDeleteHide(); //隐藏删除按钮
	    MADitemGrid.btnPrintHide(); //隐藏打印按钮

    
	MADitemGrid.load({params:{start:0,limit:15,sName:sName,year:Year,SchemDR:SchemDR}});
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  var year=YearCombo.getValue();  
	  MAitemGrid.load({params:{start:0,limit:15,SchemDR:SchemDR}});
	  itemGrid.load({params : {start : 0,limit : 25,year : year}});
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [MADitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '科室年度预算维护',
				plain : true,
				width : 1200,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};