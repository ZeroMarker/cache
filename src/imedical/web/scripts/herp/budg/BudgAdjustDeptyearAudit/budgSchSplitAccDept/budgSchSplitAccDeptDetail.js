
BudgDetailFun = function(SpltMainDR1,SplitLayer){

	var cschemeName = '当前对应科室：' ;


///////////////////////科室类别///////////////////////////
var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptTypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschsplitaccdeptdetailexe.csp?action=deptTypeist',method:'POST'});
		
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
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////////科室编码/////////////////////////////
var DeptCodefield = new Ext.form.TextField({
		id: 'DeptCodefield',
		fieldLabel: '科室编码',
		allowBlank: true,
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});

/////////////////////科室名称/////////////////////////////
var DeptNamefield = new Ext.form.TextField({
		id: 'DeptNamefield',
		fieldLabel: '科室编码',
		allowBlank: true,
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});


		
/////////////////////////是否独立核算////////////////////////////			
var isAlCompStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var isAlCompbox = new Ext.form.ComboBox({
			id : 'isAlCompbox',
			fieldLabel : '是否独立核算',
			width : 200,
			//listWidth : 200,
			selectOnFocus : true,
			allowBlank : false,
			store : isAlCompStore,
			anchor : '90%',
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
		

//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
//rowid, DeptType, DeptCode, DeptName,

		var DeptType=deptTypeCombo.getValue();
		var DeptCode=DeptCodefield.getValue();
		var DeptName=DeptNamefield.getValue();

		budgDetailGrid.load(({params:{start:0, limit:25,SpltMainDR1:SpltMainDR1,DeptType:DeptType,DeptCode:DeptCode,DeptName:DeptName}}));
	}
});		

///////////////////////批量修改/////////////////////////
//批量设置分解方法按钮
var editRateButton = new Ext.Toolbar.Button({
	text: '批量修改',
	tooltip: '对选中的科室设置相同的比例',
	iconCls: 'add',
	handler: function(){
	
	/*var rowObj=budgDetailGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var isAlComp=rowObj[0].get("isAlComp");
		
	}*/	
		//EditRateFun(rowid,isAlComp,len,budgDetailGrid);
		EditRateFun(budgDetailGrid);
		}
});


///////////////////////批量添加/////////////////////////
//批量设置分解方法按钮
var addDeptButton = new Ext.Toolbar.Button({
	text: '批量添加',
	tooltip: '选择科室添加',
	iconCls: 'add',
	handler: function(){
		addDeptFun(SpltMainDR1,budgDetailGrid);
		}
});

var bssdrateField = new Ext.form.NumberField({
		id: 'bssdrateField',
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
var budgDetailGrid = new dhc.herp.Grid({
				title : cschemeName,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschsplitaccdeptdetailexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'code',
							header : '编码科室',
							dataIndex : 'code',
							width : 230,
							align : 'center',
							editable:false,
							hidden : true

						}, {
							id : 'dname',
							header : '科室名称',
							dataIndex : 'dname',
							width : 230,
							align : 'left',
							editable:false,
							hidden : false

						},{
							id : 'SpltMainDR',
							header : '主表id',
							dataIndex : 'SpltMainDR',
							width : 230,
							align : 'center',
							editable:false,
							hidden : true

						},
						 {
							id : 'isAlComp',
							header : '是否独立核算',
							dataIndex : 'isAlComp',
							width : 230,
							align : 'left',
							editable:true,
							type : isAlCompbox,
							hidden : false

						}, {
							id : 'rate',
							header : '调节比例',
							dataIndex : 'rate',
							width : 230,
							align : 'right',
							editable:true,
							hidden : false,
							type:bssdrateField

						}],
				tbar:['科室类别:',deptTypeCombo,'-','科室编码:',DeptCodefield,'-','科室名称:',DeptNamefield,'-',findButton,'-',editRateButton,'-',addDeptButton]

			});
			
	
	
	budgDetailGrid.btnAddHide();  //隐藏增加按钮
    //budgDetailGrid.btnSaveHide();  //隐藏保存按钮
    budgDetailGrid.btnResetHide();  //隐藏重置按钮
    budgDetailGrid.btnDeleteHide(); //隐藏删除按钮
    budgDetailGrid.btnPrintHide();  //隐藏打印按钮
	//budgDetailGrid.hiddenButton(15);
    
	budgDetailGrid.load({params:{start:0,limit:15,SpltMainDR:SpltMainDR1}});
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function() { window.close(); };

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [budgDetailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '分解系数维护界面',
				plain : true,
				width : 800,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}