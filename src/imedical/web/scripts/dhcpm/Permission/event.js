//Create by zzp
// 20150505
//权限管理
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){	
	    obj.PerAdd.on("click", obj.PerAdd_OnClick, obj);  //新增事件 
		
		obj.PerUpdate.on("click", obj.PerUpdate_OnClick, obj);  //修改 事件
		
		obj.PerQuery.on("click", obj.PerQuery_OnClick, obj);  //查询事件  
		
		obj.PerBatch.on("click", obj.PerBatch_OnClick, obj ); //重置事件 

        obj.PerDelete.on("click", obj.PerDelete_OnClick, obj ); //删除事件		
		
		obj.PerName.on("specialkey", obj.PerName_specialkey,obj)  //项目名称回车事件
		
		obj.PerSName.on("specialkey", obj.PerSName_specialkey,obj)  //级别名称回车事件
		
		obj.PerLive.on("specialkey", obj.PerLive_specialkey,obj)  //权限级别回车事件
		
		obj.PerGridPanel.on("rowclick", obj.PerGridPanel_cellclick,obj)  //行单击事件
		
		obj.PerDetailLoc.on("specialkey", obj.PerDetailLoc_specialkey,obj)  //明细科室类型回车事件
		
		obj.PerDetailUser.on("specialkey", obj.PerDetailUser_specialkey,obj)  //明细用户回车事件
		
		obj.PerDetailAdd.on("click", obj.PerDetailAdd_OnClick, obj ); //权限明细增加事件  
		
		obj.PerDetailUpdate.on("click", obj.PerDetailUpdate_OnClick, obj);  //权限明细更新事件 
		
		obj.PerDetailDelete.on("click", obj.PerDetailDelete_OnClick, obj);  //明细删除事件
		
		obj.PerDetailQuery.on("click", obj.PerDetailQuery_OnClick, obj);  //模块查询事件
		
		obj.PerDetailBatch.on("click", obj.PerDetailBatch_OnClick, obj);   //明细重置事件
		
		//obj.PUGridPanel.on("rowdblclick", obj.PUGridPanel_rowclick,obj)  //工程师grid双击击事件
		
		//obj.PUModulePanel.on("rowdblclick", obj.PUModulePanel_rowclick,obj)  //模块grid双击击事件
	};
	obj.PerGridPanel_cellclick=function(rowIndex,columnIndex,e){
	var _record = obj.PerGridPanel.getSelectionModel().getSelected();
	var Rowid=_record.get('PermisRowid');
	obj.PerRowidHid.setValue(Rowid);
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerDetailUpdate_OnClick=function(){
	var _record = obj.PerDetailGridPanel.getSelectionModel().getSelected();
	if(!_record){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else{
	try{
	var PermisSRowid=_record.get('PermisSRowid');
	var PermisSUserId=_record.get('PermisSUserId');
	var PermisSLocId=_record.get('PermisSLocId');
	distrObj = new PerAddUpDetailWind();
    distrObj.PerDetailAddRowid.setValue(PermisSRowid);
	distrObj.PerDetailAddFlag.setValue('Update');
	if (PermisSUserId!=""){
	    distrObj.PerDetailUserStore .on('load', function (){
        distrObj.PerDetailAddUser.setValue(PermisSUserId);    
         });
	};
	if (PermisSLocId!=""){
	    distrObj.PerDetailLocStore .on('load', function (){
        distrObj.PerDetailLocType.setValue(PermisSLocId);    
         });
	};
	distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	}
	};
	obj.PerDetailAdd_OnClick=function(){
	try{
	    var PerRowid=obj.PerRowidHid.getValue();
		if (PerRowid==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择审核流程!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
		}
		else {
		distrObj = new PerAddUpDetailWind();
		distrObj.PerDetailAddRowid.setValue(PerRowid);
	    distrObj.PerDetailAddFlag.setValue('Add');
	    distrObj.menuwind.show();
		};
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	};
	obj.PerDetailDelete_OnClick=function(){
	var _record = obj.PerDetailGridPanel.getSelectionModel().getSelected();
	if(!_record){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要删除的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else{
	try{
	var PermisSRowid=_record.get('PermisSRowid');
	Ext.MessageBox.confirm('提示', '确定要删除该条数据吗?', function(btn) {
	if(btn=='yes'){
	//alert(PermisSRowid);
	var DeletePermisRet=objAudit.DeletePermisDetail(PermisSRowid);
	if (DeletePermisRet=="0"){
	Ext.MessageBox.alert('成功', '数据删除成功！');
	obj.PerBatch_OnClick();
	}
	else {
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+DeletePermisRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	}
	else{
	return;
	}
	});
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	};
	obj.PerDetailQuery_OnClick=function(){
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	function obj.PerDelete_OnClick(){
	var _record = obj.PerGridPanel.getSelectionModel().getSelected();
	if(!_record){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要删除的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else{
	try{
	var PermisRowid=_record.get('PermisRowid');
	Ext.MessageBox.confirm('提示', '确定要删除该条数据吗?', function(btn) {
	if(btn=='yes'){
	var DeletePermisRet=objAudit.DeletePermission(PermisRowid);
	if (DeletePermisRet=="1"){
	Ext.MessageBox.alert('成功', '数据删除成功！');
	obj.PerBatch_OnClick();
	}
	else {
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+DeletePermisRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	}
	else{
	return;
	}
	});
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	};
	obj.PerAdd_OnClick=function(){   //权限新增事件
	try{
		distrObj = new PerAddUpWind();
		distrObj.PermisSAddRowid.setValue('');
	    distrObj.PermisSAddFlag.setValue('Add');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   
	};
	obj.PerUpdate_OnClick=function(){
	var _record = obj.PerGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	}
	else {
	try{
	    distrObj = new PerAddUpWind();
	    var PermisRowid=_record.get('PermisRowid');
		var PermisPerId=_record.get('PermisPerId');
		var PermisMustAuId=_record.get('PermisMustAuId');
		var PermisLiveName=_record.get('PermisLiveName');
		var PermisLive=_record.get('PermisLive');
		var PermisAuditId=_record.get('PermisAuditId');
		var PermisTAuditId=_record.get('PermisTAuditId');
		var PermisTypeid=_record.get('PermisTypeid');
		if (PermisTypeid!=""){
		distrObj.PerCATtypeStore .on('load', function (){
        distrObj.PermisSAddType.setValue(PermisTypeid);    
         });
		};
		if (PermisPerId!=""){
		distrObj.PerProNameStore .on('load', function (){
        distrObj.PermisSAddPerName.setValue(PermisPerId);    
         });
		};
		if (PermisTAuditId!=""){
		distrObj.PermisTAuditStore .on('load', function (){
        distrObj.PermisSAddACTT.setValue(PermisTAuditId);    
         });
		};
		if (PermisAuditId!=""){
		distrObj.PerStatusStore .on('load', function (){
        distrObj.PermisSAddACT.setValue(PermisAuditId);    
         });
		};
	    if (PermisMustAuId!=""){
		distrObj.PermisMustAuStore .on('load', function (){
        distrObj.PermisSMustA.setValue(PermisMustAuId);    
         });
		};
		distrObj.PermisSAddName.setValue(PermisLiveName);
		distrObj.PermisSAddLive.setValue(PermisLive);
		distrObj.PermisSAddRowid.setValue(PermisRowid);
	    distrObj.PermisSAddFlag.setValue('Update');
	    distrObj.menuwind.show();
	}catch(err)
	{
	    ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	
	};
	};
	obj.PerQuery_OnClick=function(){
	obj.PerRowidHid.setValue('');
	obj.PerGridStore.removeAll();
	obj.PerGridStore.load({params : {start:0,limit:10}});
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerBatch_OnClick=function(){
	obj.PerName.setValue("");
	obj.PerRowidHid.setValue('');
	obj.PerSName.setValue("");
	obj.PerLive.setValue("");
	obj.PerGridStore.removeAll();
	obj.PerGridStore.load({params : {start:0,limit:10}});
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerDetailBatch_OnClick=function(){
	obj.PerDetailLoc.setValue("");
	obj.PerDetailUser.setValue('');
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	};
	obj.PerName_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerQuery_OnClick();
	};
	};
	obj.PerSName_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerQuery_OnClick();
	};
	};
	obj.PerLive_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerQuery_OnClick();
	};
	};
	obj.PerDetailLoc_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerDetailQuery_OnClick();
	};
	};
	obj.PerDetailUser_specialkey=function(field,e){
	if ((e.keyCode== 13)||(e.keyCode== 8)){
	obj.PerDetailQuery_OnClick();
	};
	};
}
function PerAddUpWindEvent(obj){
    var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){	
	    obj.PermisSAdd.on("click", obj.PermisSAdd_OnClick, obj);  //保存事件 
		
		obj.PermisSDelete.on("click", obj.PermisSDelete_OnClick, obj);  //返回事件
	}
  obj.PermisSAdd_OnClick=function(){
   try{
   var PermisSAddRowid=obj.PermisSAddRowid.getValue();
   var PermisSAddFlag=obj.PermisSAddFlag.getValue();
   var PermisSAddPerName=obj.PermisSAddPerName.getValue();
   var PermisSMustA=obj.PermisSMustA.getValue();
   var PermisSAddName=obj.PermisSAddName.getValue();
   var PermisSAddLive=obj.PermisSAddLive.getValue();
   var PermisSAddACT=obj.PermisSAddACT.getValue();
   var PermisSAddUser=obj.PermisSAddUser.getValue();
   var PermisSAddACTT=obj.PermisSAddACTT.getValue();
   var PermisSAddType=obj.PermisSAddType.getValue();
   if (PermisSAddType==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“审核类型”为必填项目!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSAddPerName==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '必选选择项目!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSMustA==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“必须审核”不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSAddName==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“权限名称”不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PermisSAddACT==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“审核结果”不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   //           Rowid                操作类型             项目名称          必须审核标识      权限名称            权限级别            审核结果         权限用户         提醒审核标志        审核类型
   var input=PermisSAddRowid+"^"+PermisSAddFlag+"^"+PermisSAddPerName+"^"+PermisSMustA+"^"+PermisSAddName+"^"+PermisSAddLive+"^"+PermisSAddACT+"^"+PermisSAddUser+"^"+PermisSAddACTT+"^"+PermisSAddType;
   var AddUpdatePermisRet=objAudit.AddUpdatePermis(input);
   if (AddUpdatePermisRet=="1"){
      Ext.MessageBox.alert('成功', '操作成功！');
      obj.menuwind.close();
	  ExtTool.LoadCurrPage('PerGridPanel');
	  ExtTool.LoadCurrPage('PerDetailGridPanel');
	}
	else {
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+AddUpdatePermisRet,
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
  obj.PermisSDelete_OnClick=function(){
  obj.menuwind.close();
  };
}

function PerAddUpDetailWindEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){	
	    obj.PerDetailAdd.on("click", obj.PerDetailAdd_OnClick, obj);  //新增事件 
		
		obj.PerDetailDelete.on("click", obj.PerDetailDelete_OnClick, obj);  //修改 事件
	}
	obj.PerDetailAdd_OnClick=function(){
	try{
       var PerDetailAddRowid=obj.PerDetailAddRowid.getValue();
       var PerDetailAddFlag=obj.PerDetailAddFlag.getValue();
       var PerDetailAddUser=obj.PerDetailAddUser.getValue();
       var PerDetailLocType=obj.PerDetailLocType.getValue();
	   if (PerDetailAddUser==""){
	   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“用户名称”不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
	   };
	   if ((PerDetailAddFlag=="Add")&&(PerDetailLocType=="")){
	    var LocTypeRet=objAudit.PerLocType(PerDetailAddRowid,PerDetailAddUser,'');
		if (LocTypeRet=="1"){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '该用户已经存在全部权限',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
		};
	   };
	   if ((PerDetailAddFlag=="Add")&&(PerDetailLocType!="")){
	   var LocTypeRet=objAudit.PerLocType(PerDetailAddRowid,PerDetailAddUser,PerDetailLocType);
		if (LocTypeRet=="1"){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '该用户已经存在该科室类型权限',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	    return;
		};
	   };
	   var input=PerDetailAddRowid+"^"+PerDetailAddFlag+"^"+PerDetailAddUser+"^"+PerDetailLocType;
	   var AddUpdateRet=objAudit.AddUpdatePerDetail(input);
	   if (AddUpdateRet=="1"){
	   Ext.MessageBox.alert('成功', '操作成功！');
       obj.menuwind.close();
	   ExtTool.LoadCurrPage('PerGridPanel');
	   ExtTool.LoadCurrPage('PerDetailGridPanel');
	   }
	   else{
	   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+AddUpdateRet,
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
	obj.PerDetailDelete_OnClick=function(){
	obj.menuwind.close();
	};
}