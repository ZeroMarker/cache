function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addJXUnitFun = function(schemGrid,ds,jxUnitGrid,pagingToolbar){

	var schemObj=schemGrid.getSelectionModel().getSelections()[0];
	if(schemObj==undefined){
		Ext.Msg.show({title:'注意',msg:'请选择自查项目！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	}else{
	
	var userCode = session['LOGON.USERCODE'];
	var sm = new Ext.grid.CheckboxSelectionModel();
	var jxUnitUrl = '../csp/dhc.pa.unitdeptschemexe.csp';
	var jxUnitProxy= new Ext.data.HttpProxy({url:jxUnitUrl + '?action=jxunit'});
	var jxUnitDs = new Ext.data.Store({
		proxy: jxUnitProxy,
		reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['rowid','code','name','type']),
		remoteSort: true
	});
	//设置默认排序字段和排序方向
	jxUnitDs.setDefaultSort('rowid', 'desc');
	//数据库数据模型
	var jxUnitCm = new Ext.grid.ColumnModel([
		sm,
		new Ext.grid.RowNumberer(),
		{header:'科室代码',dataIndex:'code',width:180},
		{header:'科室名称',dataIndex:'name',width:180}
		
	]);
	var grid = new Ext.grid.GridPanel({
		store:jxUnitDs,
		cm:jxUnitCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true
	});
	jxUnitDs.load({params:{userCode:userCode,start:0,limit:10000}});
			
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
				rowid=rowObj[i].get("rowid");
				if(idStr==""){
					idStr=rowid;
				}else{
					idStr=idStr+"-"+rowid
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
		if(jxUnitDrStr==""){
			Ext.Msg.show({title:'提示',msg:'绩效单元为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var schemDr=schemGrid.getSelections()[0].get("rowid");
		schemDr = trim(schemDr);
		if(schemDr==""){
			Ext.Msg.show({title:'提示',msg:'绩效方案为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		Ext.Ajax.request({
			url:'../csp/dhc.pa.unitdeptschemexe.csp?action=add&schemDr='+schemDr+'&JXUnit='+jxUnitDrStr,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info!=0){
						//alert(jsonData.info)
						Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}
					ds.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
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

	}}