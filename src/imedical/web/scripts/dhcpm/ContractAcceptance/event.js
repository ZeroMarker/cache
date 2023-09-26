//Create by zzp
// 20150427
//系统配置
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.TelAdd.on("click", obj.TelAdd_OnClick, obj);  //新增事件 
		
		obj.TelUpdate.on("click", obj.TelUpdate_OnClick, obj);  //修改 事件
		
		obj.TelQuery.on("click", obj.TelQuery_OnClick, obj);  //查询事件  
		
		obj.TelBatch.on("click", obj.TelBatch_OnClick, obj ); //重置事件  
		
		obj.TelLoc.on("specialkey", obj.TelLoc_specialkey,obj)  //科室回车事件
		
		obj.TelUser.on("specialkey", obj.TelUser_specialkey,obj)  //用户回车事件
		
		obj.TelText.on("specialkey", obj.TelText_specialkey,obj)  //联系方式回车事件
		
		obj.TelEmail.on("specialkey", obj.TelEmail_specialkey,obj)  //电子邮件回车事件
		
		//obj.TelGridPanel.on("rowdblclick", obj.TelGridPanel_rowclick,obj)  //双击击事件
		
		//obj.TelGridPanel.on("rowclick", obj.TelGridPanel_cellclick,obj)  //行单击事件
			
	};
	/*
	obj.TelGridPanel_cellclick=function(){
	
	};
	*/
	obj.TelAdd_OnClick=function(){
	var teltyperet=objAudit.UserTelType();
	if(teltyperet.split('^')[0]=="1"){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '您已经存在联系方式，只能进行修改!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	try{
		distrObj = new TelMenuWind();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   distrObj.TelMenuName.setValue(teltyperet.split('^')[1]);
	   distrObj.TelRowid.setValue('');
	   distrObj.TelFlag.setValue('Add');
	   distrObj.TelMenuText.setValue('');
	   distrObj.TelMenuEmail.setValue('');
	   distrObj.TelMenubz.setValue('');
	   distrObj.menuwind.show();
	};
	obj.TelUpdate_OnClick=function(){
	var _record = obj.TelGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	var TelGridRowid=_record.get('TelGridRowid');
	var teltyperet=objAudit.UserTelType();
	if(teltyperet.split('^')[2]!=TelGridRowid){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '您只能进行修改本人的信息!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	else {
	var TelGridName=_record.get('TelGridName');
	var TelGridTel=_record.get('TelGridTel');
	var TelGridEmail=_record.get('TelGridEmail');
	var TelGridbz=_record.get('TelGridbz');
	try {
	distrObj = new TelMenuWind();
	distrObj.TelMenuName.setValue(TelGridName);
	distrObj.TelRowid.setValue(TelGridRowid);
	distrObj.TelFlag.setValue('Update');
	distrObj.TelMenuText.setValue(TelGridTel);
	distrObj.TelMenuEmail.setValue(TelGridEmail);
	distrObj.TelMenubz.setValue(TelGridbz);
	distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	};
	};
	};
	/*
	obj.TelGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.TelUpdate_OnClick();
	};
	*/
	obj.TelLoc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelEmail_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelUser_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelText_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.TelQuery_OnClick();
	};
	};
	obj.TelQuery_OnClick=function(){
	var TelText=obj.TelText.getValue();
	var TelLoc=obj.TelLoc.getValue();
	var TelUser=obj.TelUser.getValue();
	var TelEmail=obj.TelEmail.getValue();
	var InPut=TelText+"^"+TelLoc+"^"+TelUser+"^"+TelEmail;
    obj.TelGridStore.removeAll();
	obj.TelGridStore.load({params:{InPut:InPut}});
	};
	obj.TelBatch_OnClick=function(){
	obj.TelText.setValue("");
	obj.TelLoc.setValue("");
	obj.TelUser.setValue("");
	obj.TelEmail.setValue("");
	obj.TelGridStore.removeAll();
	obj.TelGridStore.load();
	};
}
function TelMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.TelMenuAdd.on("click", obj.TelMenuAdd_OnClick, obj);  //保存 事件
	  obj.TelMenuDelete.on("click", obj.TelMenuDelete_OnClick, obj);  //返回 事件
   };
   obj.TelMenuAdd_OnClick=function(){
    var TelMenuName=obj.TelMenuName.getValue();
    var TelRowid=obj.TelRowid.getValue();
    var TelFlag=obj.TelFlag.getValue();
    var TelMenuText=obj.TelMenuText.getValue();
    var TelMenuEmail=obj.TelMenuEmail.getValue();
    var TelMenubz=obj.TelMenubz.getValue();
	if (TelMenuText==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '联系方式不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	try {
	 var inupt=TelRowid+"^"+TelFlag+"^"+TelMenuText+"^"+TelMenuEmail+"^"+TelMenubz;
	 var UpdateRet=objAudit.TelUpdate(inupt);
	 if (UpdateRet=="1"){
	  Ext.MessageBox.alert('完成', '操作数据完成');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('TelGridPanel');
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
   obj.TelMenuDelete_OnClick=function(){
   obj.menuwind.close();
   };

}