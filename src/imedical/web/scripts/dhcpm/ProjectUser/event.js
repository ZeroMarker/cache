//Create by zzp
// 20150504
//工程师管理
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	var Document = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		obj.PUAdd.on("click", obj.PUAdd_OnClick, obj);  //新增事件 
		
		obj.PUUpdate.on("click", obj.PUUpdate_OnClick, obj);  //修改 事件
		
		obj.PUQuery.on("click", obj.PUQuery_OnClick, obj);  //查询事件  
		
		obj.PUBatch.on("click", obj.PUBatch_OnClick, obj ); //重置事件  
		
		obj.PUTel.on("specialkey", obj.PUTel_specialkey,obj)  //联系方式回车事件
		
		obj.PUPerject.on("specialkey", obj.PUPerject_specialkey,obj)  //项目回车事件
		
		obj.PUUserName1.on("specialkey", obj.PUUserName1_specialkey,obj)  //工程师名称回车事件
		
		obj.PUGridPanel.on("rowclick", obj.PUGridPanel_cellclick,obj)  //行单击事件
		
		obj.PUModNamejs.on("specialkey", obj.PUModNamejs_specialkey,obj)  //模块名称回车事件
		
		obj.PUUpdateMod.on("click", obj.PUUpdateMod_OnClick, obj ); //模块修改事件  
		
		obj.PUAddMod.on("click", obj.PUAddMod_OnClick, obj);  //模块新增事件 
		
		obj.PUQueryMod.on("click", obj.PUQueryMod_OnClick, obj);  //模块查询事件
		
		obj.PUGridPanel.on("rowdblclick", obj.PUGridPanel_rowclick,obj)  //工程师grid双击击事件
		
		obj.PUModulePanel.on("rowdblclick", obj.PUModulePanel_rowclick,obj)  //模块grid双击击事件
			
	};
	obj.PUGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.PUUpdate_OnClick();
	};
	obj.PUModulePanel_rowclick=function(rowIndex,columnIndex,e){
	obj.PUUpdateMod_OnClick();
	};
	obj.PUAddMod_OnClick=function(){   //模块新增事件
	try{
	   distrObj = new PUUserModAddUpWind();
	   var peruserid=obj.PURowid.getValue();
	   if (peruserid==""){
	   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择工程师信息',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	   return;
	   }
	   else {
	   distrObj.AddModeRowid.setValue(peruserid);
	   distrObj.AddModeFlag.setValue('Add');
	   distrObj.menuwindadd.show();
	   };
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	};
	obj.PUQueryMod_OnClick=function(){  //模块查询事件
	obj.PUModuleStore.removeAll();
	obj.PUModuleStore.load({params : {start:0,limit:10}});
	};
	obj.PUUpdateMod_OnClick=function(){  //模块修改事件
	var _record = obj.PUModulePanel.getSelectionModel().getSelected();
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
	   var ModRowid=_record.get('TRowid');
	   var TMDUModuleID=_record.get('TMDUModuleID');
	   var TMDUStDate=_record.get('TMDUStDate');
	   var TMDUStTime=_record.get('TMDUStTime');
	   var TMDUEnDate=_record.get('TMDUEnDate');
	   var TMDUEnTime=_record.get('TMDUEnTime');
	   var TMDURemark=_record.get('TMDURemark');
	   distrObj = new PUUserModAddUpWind();
	   distrObj.AddModebz.setValue(TMDURemark);
	   var peruserid=obj.PURowid.getValue();
	   if (peruserid==""){
	   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择工程师信息',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	   return;
	   }
	   else {
	   distrObj.AddModeRowid.setValue(peruserid+"||"+ModRowid);
	   distrObj.AddModeFlag.setValue('Update');
	   if (TMDUStDate!=""){
	   distrObj.AddModeInDate.setValue(TMDUStDate);
	   };
	   if (TMDUStTime!=""){
	   distrObj.AddModeInTime.setValue(TMDUStTime);
	   };
	   if (TMDUEnDate!=""){
	   distrObj.AddModeOuDate.setValue(TMDUEnDate);
	   };
	   if (TMDUEnTime!=""){
	   distrObj.AddModeOuTime.setValue(TMDUEnTime);
	   };
	   if (TMDUModuleID!=""){
	    distrObj.AddPuModeNameStore.on('load', function (){
        distrObj.AddModeName.setValue(TMDUModuleID);    
         });
	   };
	   distrObj.menuwindadd.show();
	   };
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	
	};
	};
	obj.PUModNamejs_specialkey=function(){
	obj.PUModuleStore.removeAll();
	obj.PUModuleStore.load({params : {start:0,limit:10}});
	};
	obj.PUGridPanel_cellclick=function(rowIndex,columnIndex,e){
	var _record = obj.PUGridPanel.getSelectionModel().getSelected();
	var Rowid=_record.get('TRowid');
	obj.PURowid.setValue(Rowid);
	obj.PUModuleStore.removeAll();
	obj.PUModuleStore.load({params : {start:0,limit:10}});
	};
	obj.PUAdd_OnClick=function(){
	try{
	   distrObj = new PUUserAddUpWind();
	   distrObj.PUUserAddRowid.setValue('');
	   distrObj.PUUserAddFlag.setValue('Add');
	   distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   
	};
	obj.PUUpdate_OnClick=function(){
	var _record = obj.PUGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	try {
	var TRowid=_record.get('TRowid');
	var TUserid=_record.get('TUserid');
	var TProjectID=_record.get('TProjectID');
	var TPhone=_record.get('TPhone');
	var TEmail=_record.get('TEmail');
	var TDate1=_record.get('TDate1');
	var TTime1=_record.get('TTime1');
	var TDate2=_record.get('TDate2');
	var TTime2=_record.get('TTime2');
	var TNewUserName=_record.get('TNewUserName');
	var TNewUserNO=_record.get('TNewUserNO');
	var TDictionaryId=_record.get('TDictionaryId');
	var TRemark=_record.get('TRemark');
	distrObj = new PUUserAddUpWind();
	distrObj.PUUserAddRowid.setValue(TRowid);
	distrObj.PUUserAddFlag.setValue('Update');
	distrObj.PUUserAddbz.setValue(TRemark);
	distrObj.PUUserNewName.setValue(TNewUserName);
	distrObj.PUUserNewNo.setValue(TNewUserNO);
	//var PUUserAddPassWordRet=Document.PUUserAddPassWord(TRowid);
	//distrObj.PUUserAddPassWord.setValue(PUUserAddPassWordRet);
	if (TDictionaryId!=""){
	    distrObj.PUUserZCStore.on('load', function (){
        distrObj.PUUserAddZC.setValue(TDictionaryId);    
         });
	};
	if (TUserid!=""){
	   distrObj.PUUserStore.on('load', function (){
       distrObj.PUUserName.setValue(TUserid);    
         });
	};
	if (TProjectID!=""){
	   distrObj.PUUserProNameStore.on('load', function (){
       distrObj.PUUserAddPerName.setValue(TProjectID);    
         });
	};
	if (TDate1!=""){
	distrObj.PUUserAddInDate.setValue(TDate1);
	};
	if (TDate2!=""){
	distrObj.PUUserAddOuDate.setValue(TDate2);
	};
	if (TTime1!=""){
	distrObj.PUUserAddInTime.setValue(TTime1);
	};
	if (TTime2!=""){
	distrObj.PUUserAddOuTime.setValue(TTime2);
	};
	distrObj.PUUserAddUserTel.setValue(TPhone);
	distrObj.PUUserAddUserEmail.setValue(TEmail);
	distrObj.menuwind.show();
    }catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	};
	};
	obj.PUTel_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PUQuery_OnClick();
	};
	};
	obj.PUPerject_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PUQuery_OnClick();
	};
	};
	obj.PUUserName1_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PUQuery_OnClick();
	};
	};
	obj.PUQuery_OnClick=function(){
	obj.PURowid.setValue('');
    obj.PUGridStore.removeAll();
	obj.PUGridStore.load();
	obj.PUModuleStore.removeAll();
	obj.PUModuleStore.load({params : {start:0,limit:10}});
	};
	obj.PUBatch_OnClick=function(){
	obj.PUTel.setValue("");
	obj.PURowid.setValue('');
	obj.PUPerject.setValue("");
	obj.PUUserName1.setValue("");
	obj.PUGridStore.removeAll();
	obj.PUGridStore.load();
	obj.PUModuleStore.removeAll();
	obj.PUModuleStore.load({params : {start:0,limit:10}});
	};
}

function PUUserAddUpWindEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
   var Document = ExtTool.StaticServerObject("web.PMP.Document");
   var InitializationPassWordRet=Document.InitializationPassWord();
   obj.LoadEvent = function(){
      obj.PUMenuAdd.on("click", obj.PUMenuAdd_OnClick, obj);  //保存 事件
	  obj.PUMenuDelete.on("click", obj.PUMenuDelete_OnClick, obj);  //返回 事件
   };
   obj.PUMenuAdd_OnClick=function(){
   var PUUserAddRowid=obj.PUUserAddRowid.getValue();
   var PUUserAddFlag=obj.PUUserAddFlag.getValue();
   var PUUserAddPerName=obj.PUUserAddPerName.getValue();
   var PUUserName=obj.PUUserName.getValue();
   var PUUserAddUserTel=obj.PUUserAddUserTel.getValue();
   var PUUserAddUserEmail=obj.PUUserAddUserEmail.getValue();
   var PUUserAddZC=obj.PUUserAddZC.getValue();
   var PUUserAddInDate=obj.PUUserAddInDate.getValue();
   var PUUserAddInTime=obj.PUUserAddInTime.getValue();
   var PUUserAddOuDate=obj.PUUserAddOuDate.getValue();
   var PUUserAddOuTime=obj.PUUserAddOuTime.getValue();
   var PUUserNewName=obj.PUUserNewName.getValue();
   var PUUserNewNo=obj.PUUserNewNo.getValue();
   var PUUserAddPassWord=obj.PUUserAddPassWord.getValue();
   if (PUUserAddPassWord==""){
   var PUUserAddPassWord=InitializationPassWordRet;
   };
   if (PUUserNewName==""){
      Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请填写用户名！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PUUserNewNo==""){
      Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请填写协同帐号！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   var PUUserAddbz=obj.PUUserAddbz.getValue();
   if (PUUserAddInDate!=""){
       PUUserAddInDate=PUUserAddInDate.format('Y-m-d');
   };
   if (PUUserAddOuDate!=""){
       PUUserAddOuDate=PUUserAddOuDate.format('Y-m-d');
   };
   if (PUUserAddPerName==""){
      Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择项目名称！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (PUUserName==""){
      Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选HIS用户名！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if ((PUUserAddInDate=="")||(PUUserAddInTime=="")){
      Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“到达日期”或“到达时间”不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if ((PUUserAddUserTel=="")&(PUUserAddUserEmail=="")){
      Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“联系方式”和“电子邮件不能同时为空”！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   var input=PUUserAddRowid+"^"+PUUserAddFlag+"^"+PUUserAddPerName+"^"+PUUserName+"^"+PUUserAddUserTel+"^"+PUUserAddUserEmail;
   input=input+"^"+PUUserAddZC+"^"+PUUserAddInDate+"^"+PUUserAddInTime+"^"+PUUserAddOuDate+"^"+PUUserAddOuTime+"^"+PUUserNewName+"^"+PUUserNewNo+"^"+PUUserAddPassWord;
   try {
     var AddUpPerUserRet=objAudit.AddUpdatePerUser(input,PUUserAddbz);
	 if (AddUpPerUserRet=="1"){
	  Ext.MessageBox.alert('完成', '操作数据完成');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('PUGridPanel');
	  ExtTool.LoadCurrPage('PUModulePanel');
	 }
	 else {
	 Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据操作失败，错误代码：'+AddUpPerUserRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	   return;
	 }
   }catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
   
   };
   obj.PUMenuDelete_OnClick=function(){
   obj.menuwind.close();
   };

}

function PUUserModAddUpWindEvent(obj){
    var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
   obj.LoadEvent = function(){
      obj.AddModeAdd.on("click", obj.AddModeAdd_OnClick, obj);  //保存 事件
	  obj.AddModeDelete.on("click", obj.AddModeDelete_OnClick, obj);  //返回 事件
   };
   obj.AddModeAdd_OnClick=function (){
   var AddModeRowid=obj.AddModeRowid.getValue();
   var AddModeFlag=obj.AddModeFlag.getValue();
   var AddModeName=obj.AddModeName.getValue();
   var AddModeInDate=obj.AddModeInDate.getValue();
   var AddModeInTime=obj.AddModeInTime.getValue();
   var AddModeOuDate=obj.AddModeOuDate.getValue();
   var AddModeOuTime=obj.AddModeOuTime.getValue();
   var AddModebz=obj.AddModebz.getValue();
   if (AddModeInDate!=""){
       AddModeInDate=AddModeInDate.format('Y-m-d');
   };
   if (AddModeOuDate!=""){
       AddModeOuDate=AddModeOuDate.format('Y-m-d');
   };
   if (AddModeName==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '模块名称不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (AddModeInDate==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '开始日期不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   if (AddModeInTime==""){
   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '开始时间不能为空！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
   };
   var input=AddModeRowid+"^"+AddModeFlag+"^"+AddModeName+"^"+AddModeInDate+"^"+AddModeInTime+"^"+AddModeOuDate+"^"+AddModeOuTime;
   try {
     var AddUserModeRet=objAudit.AddUpdateUserMode(input,AddModebz);
	 if (AddUserModeRet=="1"){
	  Ext.MessageBox.alert('完成', '操作数据完成');
	  obj.menuwindadd.close();
	  //ExtTool.LoadCurrPage('PUGridPanel');
	  ExtTool.LoadCurrPage('PUModulePanel');
	 }
	 else{
	 Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据操作失败，错误代码：'+AddUserModeRet,
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
   obj.AddModeDelete_OnClick=function(){
   obj.menuwindadd.close();
   };

}