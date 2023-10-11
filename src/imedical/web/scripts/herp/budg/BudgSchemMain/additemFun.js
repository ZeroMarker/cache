additemFun = function(curSchemeDr,schemeDetailGrid){
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var schemmainbUrl = 'herp.budg.budgschemmainbexe.csp';

///////////////////////科室预算项类别///////////////////////////
var TypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['code','name'])
	});

	TypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:commonboxURL+'?action=itemtype&flag=1',method:'POST'});
		
	});
		
	var TypeCombo = new Ext.form.ComboBox({
		fieldLabel:'预算项类别',
		store: TypeDs,
		displayField:'name',
		valueField:'code',
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
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'add',
	handler:function(){

		var type=TypeCombo.getValue();
		var Year=yearCombo.getValue();
		budgDeptGrid.load(({params:{start:0, limit:25,Year:Year, type:type}}));
	}
});		

//确认按钮
var addButton = new Ext.Toolbar.Button({
	text: '确认',
    tooltip:'确认',        
    iconCls:'add'});


	// 科室设置grid
var budgDeptGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : schemmainbUrl,
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{//rowid^code^name^
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'Year',
							header : '年度',
							dataIndex : 'Year',
							width : 100,
							editable:false,
							hidden : false

						}, {
							id : 'code',
							header : '预算项编码',
							dataIndex : 'code',
							width : 100,
							editable:false,
							hidden : false

						},{
							id : 'name',
							header : '预算项名称',
							dataIndex : 'name',
							width : 280,
							editable:false,
							hidden : false

						}, {
							id : 'Level',
							header : '预算项级别',
							dataIndex : 'Level',
							width : 200,
							editable:false,
							hidden : false

						}],
						viewConfig : {forceFit : true},
						tbar:['预算项类别:',TypeCombo,'年度：',yearCombo,findButton]
			});



 budgDeptGrid.load({params:{start:0,limit:15}});
	
//定义添加按钮响应函数
addHandler = function(){

        var rowObj=budgDeptGrid.getSelectionModel().getSelections();
	    //定义并初始化行对象长度变量
	    var len = rowObj.length;
	    //判断是否选择了要修改的数据
	    if(len < 1){
		    Ext.Msg.show({title:'注意',msg:'请至少选择一个预算项！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    else{
	    for(var i = 0; i < len; i++){	    
		   var code = rowObj[i].get("code");
		   var Level = rowObj[i].get("Level");
			Ext.Ajax.request({
				url: schemmainbUrl+'?action=addD&SchemDR='+curSchemeDr+'&Code='+code+'&Level='+Level,
				waitMsg:'保存中...',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'添加预算项成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					schemeDetailGrid.load({params:{start:0,limit:15}});
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
		 // schemeDetailGrid.load({params:{start:0,limit:15}});	 
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
				title : '预算项选择',
				plain : true,
				width : 850,
				height : 500,
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