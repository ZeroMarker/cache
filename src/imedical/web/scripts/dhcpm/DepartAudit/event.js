//Create by zzp
// 20150427
//科室主任配置
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.DepartAdd.on("click", obj.DepartAdd_OnClick, obj);  //新增事件 
		
		obj.DepartUpdate.on("click", obj.DepartUpdate_OnClick, obj);  //修改 事件
		
		obj.DepartQuery.on("click", obj.DepartQuery_OnClick, obj);  //查询事件  
		
		obj.DepartBatch.on("click", obj.DepartBatch_OnClick, obj ); //重置事件  
		
		obj.DepartLoc.on("specialkey", obj.DepartLoc_specialkey,obj)  //科室回车事件
		
		obj.DepartUser.on("specialkey", obj.DepartUser_specialkey,obj)  //用户回车事件
		
		obj.DepartGridPanel.on("rowdblclick", obj.DepartGridPanel_rowclick,obj)  //双击击事件
			
	};
	obj.DepartGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.DepartUpdate_OnClick();
	};
	obj.DepartAdd_OnClick=function(){
	try{
		distrObj = new DepartMenuWind();
		distrObj.DepartRowid.setValue('');
	    distrObj.DepartFlag.setValue('Add');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	};
	obj.DepartUpdate_OnClick=function(){
	var _record = obj.DepartGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	try{
	var AuditRowid=_record.get('AuditRowid');
	var AuditLocName=_record.get('AuditLocDr');
	var AuditUserName=_record.get('AuditUserDr');
	var Typedesc=_record.get('Typedesc');
	var TypeRowid=objAudit.SelectTypeRowid(AuditRowid);
	distrObj = new DepartMenuWind();
	distrObj.DepartRowid.setValue(AuditRowid);
	distrObj.DepartFlag.setValue('Update');
	distrObj.DepartLocStore.on('load', function (){
       distrObj.DepartAddLoc.setValue(AuditLocName);    
         });
	distrObj.DepartUserStore.on('load', function (){
       distrObj.DepartAddUser.setValue(AuditUserName);    
         });
	if(Typedesc!=""){
	distrObj.DepartTypeStore.on('load', function (){
       distrObj.DepartAddType.setValue(TypeRowid);    
         });
	};
	distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.DepartLoc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.DepartQuery_OnClick();
	};
	};
	obj.DepartUser_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.DepartQuery_OnClick();
	};
	};
	obj.DepartQuery_OnClick=function(){
    obj.DepartGridStore.removeAll();
	obj.DepartGridStore.load({params : {start:0,limit:20}});
	};
	obj.DepartBatch_OnClick=function(){
	obj.DepartLoc.setValue("");
	obj.DepartUser.setValue("");
	obj.DepartType.setValue("");
	obj.DepartGridStore.removeAll();
	obj.DepartGridStore.load({params : {start:0,limit:20}});
	};
}


function DepartMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.DepartMenuAdd.on("click", obj.DepartMenuAdd_OnClick, obj);  //保存 事件
	  obj.DepartMenuDelete.on("click", obj.DepartMenuDelete_OnClick, obj);  //返回 事件
   };
   obj.DepartMenuAdd_OnClick=function(){
    var DepartRowid=obj.DepartRowid.getValue();
    var DepartFlag=obj.DepartFlag.getValue();
    var DepartAddLoc=obj.DepartAddLoc.getValue();
    var DepartAddUser=obj.DepartAddUser.getValue();
    var DepartAddType=obj.DepartAddType.getValue();
	if (DepartAddLoc==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '科室不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (DepartAddUser==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '用户不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (DepartAddType=="科室分配") {
	DepartAddType="L";
	};
	if (DepartAddType=="需求分配") {
	DepartAddType="F";
	};
	if (DepartAddType==""){DepartAddType="L"}
	if (DepartAddType==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '类型不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	try {
	 var inupt=DepartRowid+"^"+DepartFlag+"^"+DepartAddLoc+"^"+DepartAddUser+"^"+DepartAddType;
	 var UpdateRet=objAudit.DepartUpdate(inupt);
	 if (UpdateRet=="1"){
	  ExtTool.LoadCurrPage('DepartGridPanel');
	  Ext.MessageBox.alert('完成', '操作数据完成');
	  obj.menuwind.close();
	  
	  //ExtTool.LoadCurrPage('DepartGridPanel');
	 }
	 else {
	 Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据操作失败，错误代码：'+UpdateRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	 };
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
   };
   obj.DepartMenuDelete_OnClick=function(){
   obj.menuwind.close();
   };

}

