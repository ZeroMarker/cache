YMDetailFun = function(itemGrid,SpltMainDR1,SplitLayer,Sname,deptname,ddname){
	var YMName = '"'+Sname+'"分解系数维护：' ;
	var YMtitile='当前科室：'+ddname;

	//月份
	var monthDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['code','code'])
	});
	monthDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitymdetailexe.csp?action=monthlist',method:'POST'});
		
	});
	var monthbox = new Ext.form.ComboBox({
		fieldLabel:'月份',
		store: monthDs,
		displayField:'code',
		valueField:'code',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 200,
		listWidth : 245,
		pageSize: 12,
		minChars: 1,
		selectOnFocus:true
	});

///////////////////////批量填写/////////////////////////
//批量设置分解方法按钮
var YMRateButton = new Ext.Toolbar.Button({
	text: '批量填写',
	tooltip: '对选中的月份设置相同的比例',
	iconCls: 'add',
	handler: function(){
		YMRateFun(YMDetailGrid,SpltMainDR1,deptname);
	}
});

var bssdrateField = new Ext.form.NumberField({
		id: 'bssdrateField',
		//fieldLabel: '预算项编码',
		width:215,
		listWidth : 215,
		name: 'bssdrateField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});


	// 调节比例明细设置grid
var YMDetailGrid = new dhc.herp.Grid({
				title : YMtitile,
				width : 400,
				viewConfig : {forceFit : true},
				region : 'center',
				url : 'herp.budg.budgschsplitymdetailexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'mcode',
							header : '月份',
							dataIndex : 'mcode',
							update : true,
							width : 200,
							//align : 'center',
							//type : monthbox,
							editable:false,
							hidden : false

						},{
							id : 'SpltMainDR',
							header : '主表id',
							dataIndex : 'SpltMainDR',
							width : 200,
							align : 'center',
							editable:false,
							hidden : true

						}, {
							id : 'rate',
							header : '调节比例',
							dataIndex : 'rate',
							width : 200,
							align : 'right',
							editable:true,
							hidden : false,
							type:bssdrateField

						}, {
							id : 'DeptDR',
							header : '科室',
							dataIndex : 'DeptDR',
							width : 200,
							align : 'left',
							editable:true,
							hidden : true

						}]			

			});
			
    YMDetailGrid.addButton('-');
    YMDetailGrid.addButton(YMRateButton);
    
    YMDetailGrid.btnAddHide();  //隐藏增加按钮
    //YMDetailGrid.btnSaveHide();  //隐藏保存按钮
    YMDetailGrid.btnResetHide();  //隐藏重置按钮
    YMDetailGrid.btnDeleteHide(); //隐藏删除按钮
    YMDetailGrid.btnPrintHide();  //隐藏打印按钮
    
	YMDetailGrid.load({params:{start:0,limit:15,SpltMainDR1:SpltMainDR1,deptname:deptname}});
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function() 
	{ 
	//itemGrid.load(({params:{start:0, limit:25}}));
	window.close(); };

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [YMDetailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : YMName,
				plain : true,
				width : 600,
				height : 450,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};