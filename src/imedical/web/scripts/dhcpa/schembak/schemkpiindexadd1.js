function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addSchemDetailFun = function(node){

	var userCode = session['LOGON.USERCODE'];
	var sm = new Ext.grid.CheckboxSelectionModel();
	var grid="";
			//type=1,添加指标
			var KPIUrl = '../csp/dhc.pa.schemexe.csp';
			var KPIProxy= new Ext.data.HttpProxy({url:KPIUrl + '?action=kpi&schem='+node});
			var KPIDs = new Ext.data.Store({
				proxy: KPIProxy,
				reader: new Ext.data.JsonReader({root: 'rows',totalProperty: 'results'}, ['KPIDr','KPIName']),
				remoteSort: true
			});
			//设置默认排序字段和排序方向
			KPIDs.setDefaultSort('KPIDr', 'desc');
			//数据库数据模型
			var KPICm = new Ext.grid.ColumnModel([
				sm,
				new Ext.grid.RowNumberer(),
				{header:'指标名称',dataIndex:'KPIName',width:325}
			]);
			var grid = new Ext.grid.GridPanel({
				store:KPIDs,
				cm:KPICm,
				trackMouseOver: true,
				stripeRows: true,
				sm:sm,
				loadMask: true
			});
			KPIDs.load({params:{userCode:userCode}});
			
	var addkpiButton = new Ext.Toolbar.Button({
		text:'保存'
	});
			
	var jxUnitDrStr="";	
	//定义按钮响应函数
	Handler = function(node){
		var rowObj=grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		var idStr="";
		alert(len);
		if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要添加指标的方案!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
		}else{
			for(var i=0;i<len;i++){
				jxUnitDr=rowObj[i].get("KPIDr");
				if(idStr==""){
					idStr=jxUnitDr;
				}else{
					idStr=idStr+"-"+jxUnitDr
				}
			}
			jxUnitDrStr=idStr;
			alert(jxUnitDrStr);
			//win.close();
		}
	}
		
	//添加处理函数
	var addHandler = function(node){
		Handler(node);
		jxUnitDrStr = trim(jxUnitDrStr);
		var name = jxUnitDrStr;
		name = trim(name);
        var data = node+'^'+name;
        data = trim(data);
		alert(data);		
		Ext.Ajax.request({
			url:SchemUrl+'?action=addkpi&data='+data,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'保存成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							Ext.getCmp('detailReport').getNodeById("roo").reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='EmptyRecData') message='空数据!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
			scope: this
		});
	}	
		
	//添加按钮的监听事件
	addkpiButton.addListener('click',addHandler(node),false);
		
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
		title:'添加绩效单元',
		width:420,
		height:300,
		minWidth: 420, 
		minHeight: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:grid,
		buttons: [
			addkpiButton,
			cancelButton
		]
	});

	//窗口显示
	win.show();
}