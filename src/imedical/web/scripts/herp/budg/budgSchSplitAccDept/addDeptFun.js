addDeptFun = function(SpltMainDR,budgDetailGrid){
    //alert(SpltMainDR);
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
//herp.budg.budgSchSplitAccDeptDexe.csp
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


//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){
//rowid, DeptType, DeptCode, DeptName,

		var Dtype=deptTypeCombo.getValue();
		var Dcode=DeptCodefield.getValue();
		var Dname=DeptNamefield.getValue();

		budgDeptGrid.load(({params:{start:0, limit:25, Dtype:Dtype, Dcode:Dcode, Dname:Dname}}));
	}
});		

//确认按钮
var addButton = new Ext.Toolbar.Button({
	text: '确认',
    tooltip:'确认',        
    iconCls:'add'});


	// 科室设置grid
var budgDeptGrid = new dhc.herp.Grid({
				title :' 科室选择',
				width : 400,
				region : 'center',
				url : 'herp.budg.budgSchSplitAccDeptDexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'Dcode',
							header : '科室代码',
							dataIndex : 'Dcode',
							width : 200,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'Dname',
							header : '科室名称',
							dataIndex : 'Dname',
							width : 200,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'Dtype',
							header : '科室类别',
							dataIndex : 'Dtype',
							width : 200,
							align : 'left',
							editable:false,
							hidden : false

						}],
				tbar:['科室类别:',deptTypeCombo,'-','科室代码:',DeptCodefield,'-','科室名称:',DeptNamefield,'-',findButton]
			});



 budgDeptGrid.load({params:{start:0,limit:15}});
	
//定义添加按钮响应函数
addHandler = function(){
		
		//var UnitID = Ext.getCmp('UnField').getValue();			
		//var data=UnitID.trim();
        var rowObj=budgDeptGrid.getSelectionModel().getSelections();
	    //定义并初始化行对象长度变量
	    var len = rowObj.length;
	    //判断是否选择了要修改的数据
	    if(len < 1){
		    Ext.Msg.show({title:'注意',msg:'请至少选择一个科室',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    else{
	    for(var i = 0; i < len; i++){	    
		   var Dcode = rowObj[i].get("Dcode");
			Ext.Ajax.request({
				url: '../csp/herp.budg.budgschsplitaccdeptdexe.csp?action=addD&SpltMainDR='+SpltMainDR+'&Dcode='+Dcode,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'添加科室成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					budgDetailGrid.load({params:{start:0,limit:15}});
					}
					/*else{
						if(jsonData.info=='RepName'){
							Ext.Msg.show({title:'错误',msg:'名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
						}
					}*/
				},
				scope: this
			});
			}
			 
		  }	
		 // budgDetailGrid.load({params:{start:0,limit:15}});	 
		  window.close();
		  
		};
	
	addButton.addListener('click',addHandler,false);
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
				items : [budgDeptGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '科室选择',
				plain : true,
				width : 660,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton,cancelButton]

			});
			
	window.show();
    budgDeptGrid.btnAddHide();  //隐藏增加按钮
    budgDeptGrid.btnSaveHide();  //隐藏保存按钮
    budgDeptGrid.btnResetHide();  //隐藏重置按钮
    budgDeptGrid.btnDeleteHide(); //隐藏删除按钮
    budgDeptGrid.btnPrintHide();  //隐藏打印按钮
};