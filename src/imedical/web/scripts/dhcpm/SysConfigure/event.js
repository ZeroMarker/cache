//Create by zzp
// 20150427
//系统配置
function InitviewScreenEvent(obj) {
	
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.SysAdd.on("click", obj.SysAdd_OnClick, obj);  //新增事件 
		
		obj.SysUpdate.on("click", obj.SysUpdate_OnClick, obj);  //修改 事件
		
		obj.SysDelete.on("click", obj.SysDelete_OnClick, obj);  //删除 事件
		
		obj.SysQuery.on("click", obj.SysQuery_OnClick, obj);  //查询事件  
		
		obj.SysBatch.on("click", obj.SysBatch_OnClick, obj ); //重置事件  
		
		obj.SysTypeName.on("specialkey", obj.SysTypeName_specialkey,obj)  //类型回车事件
		
		obj.SysMenu.on("specialkey", obj.SysMenu_specialkey,obj)  //值域回车事件
		
		obj.SysText.on("specialkey", obj.SysText_specialkey,obj)  //注释回车事件
		
		obj.SysGridPanel.on("rowdblclick", obj.SysGridPanel_rowclick,obj)  //双击击事件
		
		obj.SysGridPanel.on("rowclick", obj.SysGridPanel_cellclick,obj)  //行单击事件
		
		obj.SysGridPanel.on('cellclick',obj.SysGridPanel_CellClick,obj)  
			
	};
	obj.SysGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.SysGridPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var SysGridDesc=record.get('SysGridDesc');
	if(control=="Test"){
	try{
	var ip=SysGridDesc.split('#')[0];
	var password=SysGridDesc.split('#')[1];
	var user=SysGridDesc.split('#')[2];
	var PortDll = new ActiveXObject("FtpPortDLL.FtpPortList");
	var TestRet=PortDll.FTPConnect(ip,user,password);
	if (TestRet==true){
	Ext.MessageBox.alert('Status','恭喜您，测试成功！');
	}
	else{
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '连接失败，请检查网络或配置!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
		return;
	};
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	}
	}
	}
	obj.SysGridPanel_cellclick=function(){
	
	};
	obj.SysAdd_OnClick=function(){
	try{
		distrObj = new SysMenuWind();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   distrObj.MenuRowid.setValue('');
	   distrObj.MenuFlag.setValue('Add');
	   distrObj.MenuFromDate.setValue(new Date());
	   distrObj.menuwind.show();
	};
	obj.SysUpdate_OnClick=function(){
	var _record = obj.SysGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	var SysGridRowid=_record.get('SysGridRowid');
	var SysGridCode=_record.get('SysGridCode');
	var SysGridDesc=_record.get('SysGridDesc');
	var SysGridText=_record.get('SysGridText');
	var SysGridStdate=_record.get('SysGridStdate');
	var SysGridEndate=_record.get('SysGridEndate');
	try{
		distrObj = new SysMenuWind();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	//alert(SysGridStdate+"^"+SysGridEndate+"^"+SysGridCode+"^"+SysGridDesc+"^"+SysGridText)
	   distrObj.MenuRowid.setValue(SysGridRowid);
	   distrObj.MenuFlag.setValue('Update');
	   distrObj.MenuFromDate.setValue(SysGridStdate);
	   distrObj.MenuToDate.setValue(SysGridEndate);
	   distrObj.MenuTypeName.setValue(SysGridCode);
	   distrObj.MenuMenu.setValue(SysGridDesc);
	   distrObj.MenuText.setValue(SysGridText);
	   distrObj.menuwind.show();
	};
	};
	obj.SysDelete_OnClick=function(){
	var _record = obj.SysGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	var SysGridRowid=_record.get('SysGridRowid');
	Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
	if(btn=='yes'){
	var Deleteret=objAudit.SysGridDelete(SysGridRowid);
	if(Deleteret=='0'){
	Ext.MessageBox.alert('成功', '数据删除成功！');
	obj.SysQuery_OnClick();
	}
	else {
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请数据删除失败！代码：'+Deleteret,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	};
	};
	else{
	return;
	};
	});
	
	};
	};
	obj.SysGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.SysUpdate_OnClick();
	};
	obj.SysTypeName_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.SysQuery_OnClick();
	};
	};
	obj.SysMenu_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.SysQuery_OnClick();
	};
	};
	obj.SysText_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.SysQuery_OnClick();
	};
	};
	obj.SysQuery_OnClick=function(){
	var typename=obj.SysTypeName.getValue();
	var SysMenu=obj.SysMenu.getValue();
	var SysText=obj.SysText.getValue();
	var SysFromDate=obj.SysFromDate.getValue();
	var SysToDate=obj.SysToDate.getValue();
	if(SysFromDate!=""){
	SysFromDate=SysFromDate.format('Y-m-d');
	};
	if(SysToDate!=""){
	SysToDate=SysToDate.format('Y-m-d');
	};
	var input1=typename+"^"+SysFromDate+"^"+SysToDate
	obj.SysGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'SysGridStorequery';
			param.Arg1 = input1;  //Ext.getCmp('SysTypeName').getValue()+"^"+Ext.getCmp('SysFromDate').getValue()+"^"+Ext.getCmp('SysToDate').getValue();
			param.Arg2 = SysMenu;  //Ext.getCmp('SysMenu').getValue();
			param.Arg3 = SysText;  //Ext.getCmp('SysText').getValue();
			param.ArgCnt = 3;
	});
	
	obj.SysGridStore.removeAll();
	obj.SysGridStore.load({params : {start:0,limit:20}});
	};
	obj.SysBatch_OnClick=function(){
	obj.SysTypeName.setValue("");
	obj.SysMenu.setValue("");
	obj.SysText.setValue("");
	obj.SysFromDate.setValue("");
	obj.SysToDate.setValue("");
	obj.SysQuery_OnClick();
	//obj.SysGridStore.removeAll();
	//obj.SysGridStore.load({params : {start:0,limit:20}});
	};
}

function SysMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.MenuUpdate.on("click", obj.MenuUpdate_OnClick, obj);  //保存 事件
	  obj.MenuDelete.on("click", obj.MenuDelete_OnClick, obj);  //返回 事件
   };
   obj.MenuUpdate_OnClick=function(){
   var MenuRowid=obj.MenuRowid.getValue();
   var MenuFlag=obj.MenuFlag.getValue();
   var MenuFromDate=obj.MenuFromDate.getValue();
   var MenuToDate=obj.MenuToDate.getValue();
   var MenuTypeName=obj.MenuTypeName.getValue();
   var MenuMenu=obj.MenuMenu.getValue();
   var MenuText=obj.MenuText.getValue();
   if(MenuFromDate!=""){
	MenuFromDate=MenuFromDate.format('Y-m-d');
	};
	if(MenuToDate!=""){
	MenuToDate=MenuToDate.format('Y-m-d');
	};
	try{
	if (MenuFlag=="Add"){
	if (MenuTypeName==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据类型必选填写',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
			  return;
	};
	if(MenuMenu==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '值域必选填写',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
			  return;
	};
	var updaterowid=MenuRowid+"^"+MenuFlag+"^"+MenuToDate+"^"+MenuTypeName+"^"+MenuFromDate;
	var Addret=objAudit.SysUpdate(updaterowid,MenuMenu,MenuText);
	if (Addret=='1'){
	  Ext.MessageBox.alert('完成', '新增数据完成');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('SysGridPanel');
	}
	else {
	  Ext.MessageBox.alert('失败', '数据新增失败，错误代码：'+Addret);
	  return;
	};
	};
	if(MenuFlag=="Update"){
	if(MenuTypeName==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据类型必选填写',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if(MenuMenu==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '值域必选填写',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	var updaterowid=MenuRowid+"^"+MenuFlag+"^"+MenuToDate+"^"+MenuTypeName+"^"+MenuFromDate;
	var Addret=objAudit.SysUpdate(updaterowid,MenuMenu,MenuText);
	if (Addret=='1'){
	  Ext.MessageBox.alert('完成', '更新数据完成');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('SysGridPanel');
	}
	else {
	  Ext.MessageBox.alert('失败', '数据更新失败，错误代码：'+Addret);
	  return;
	};
	};	
	}catch(err)
	{
		ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
   };
   obj.MenuDelete_OnClick=function(){
   obj.menuwind.close();
   };

}