function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}


addSchemFun = function(dataStore,grid,pagingTool, RowId ) {

	

	
	var nameUrl = '../csp/dhc.qm.uDeptProjectexe.csp';
	var nameProxy= new Ext.data.HttpProxy({url:nameUrl + '?action=nameList'});
	var nameDs = new Ext.data.Store({   //解析数据源
           
			proxy: nameProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'	
			},['rowid','deptGroupName']),
			remoteSort: true	
});
var sm = new Ext.grid.CheckboxSelectionModel();
	//设置默认排序字段和排序方向
	nameDs.setDefaultSort('rowid', 'deptGroupName');
	//数据库数据模型
	var nameCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{

            id:'deptGroupName',
            header: '科室名称',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'deptGroupName'
            
           
       }
		
		
	]);
	var grid = new Ext.grid.GridPanel({
		store:nameDs,
		cm:nameCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});
	nameDs.load({params:{start:0,limit:10000}});
			
	var addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	var jxUnitDrStr="";	
	//定义按钮响应函数
	Handler = function(){
		var rowObj=grid.getSelections();
		var len = rowObj.length;
		var idStr="";
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			for(var i=0;i<len;i++){
				name=rowObj[i].get("rowid");
				if(idStr==""){
					idStr=name;
				}else{
					idStr=idStr+","+name
				}
			}
			jxUnitDrStr=idStr;
			win.close();
		}
	}
		
	//添加处理函数
	var addHandler = function(){
		Handler();
		jxUnitDrStr = trim(jxUnitDrStr);
		
		
		
      		
        	var data = jxUnitDrStr+'^'+RowId;
		Ext.Ajax.request({
			url:'../csp/dhc.qm.uDeptProjectexe.csp?action=add&data='+data,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
				}else{
					if(jsonData.info!=0){
						//alert(jsonData.info)
						Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
					dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
				}
			},
			scope: this
		});
	}	
		
	//添加按钮的监听事件
	addButton.addListener('click',addHandler,false);
		
	//定义并初始化取消修改按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});
		
	//定义取消修改按钮的响应函数
	cancelHandler = function(){
		win.close();
	}
		
	//添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler,false);
		
	var win = new Ext.Window({
		title:'添加科室信息',
		width:460,
		height:300,
		minWidth: 460, 
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:grid,
		buttons: [
			addButton,
			cancelButton
		]
	});

	//窗口显示
	win.show();
};