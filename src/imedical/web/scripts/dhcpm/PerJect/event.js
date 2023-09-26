//Create by zzp
// 20150427
//项目维护
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		
		
		obj.JectAdd.on("click", obj.JectAdd_OnClick, obj);  //新增事件 
		
		obj.JectUpdate.on("click", obj.JectUpdate_OnClick, obj);  //修改 事件
		
		obj.JectQuery.on("click", obj.JectQuery_OnClick, obj);  //查询事件  
		
		obj.JectBatch.on("click", obj.JectBatch_OnClick, obj ); //重置事件  
		
		obj.JectName.on("specialkey", obj.JectName_specialkey,obj)  //科室回车事件
		
		obj.JectHosp.on("specialkey", obj.JectHosp_specialkey,obj)  //用户回车事件
		
		obj.JectCode.on("specialkey", obj.JectCode_specialkey,obj)  //联系方式回车事件
		
		obj.JectUser.on("specialkey", obj.JectUser_specialkey,obj)  //电子邮件回车事件
		
		//obj.JectGridPanel.on("rowdblclick", obj.JectGridPanel_rowclick,obj)  //双击击事件
		
		//obj.JectGridPanel.on("rowclick", obj.JectGridPanel_cellclick,obj)  //行单击事件
		
		obj.JectGridPanel.on("rowdblclick", obj.JectGridPanel_rowclick,obj)  //双击击事件
			
	};

	obj.JectGridPanel_rowclick=function(rowIndex,columnIndex,e){
	obj.JectUpdate_OnClick();
	};
	obj.JectAdd_OnClick=function(){
	try{
		distrObj = new JectMenuWind();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	} 
	   var RetRowid=objAudit.SelectRetRowid(""); 
	   distrObj.AUJectRowid.setValue('');
	   distrObj.AUJectFlag.setValue('Add');
	   distrObj.AUJectName.setValue('');
	   distrObj.AUJectCode.setValue('');
	   distrObj.AUJectDel.setValue('');
	   distrObj.AUJectDD.setValue('');
	   distrObj.AUJectTel.setValue('');
	   distrObj.AUJectBZ.setValue('');
	   if (RetRowid!=""){
	    distrObj.JectHosStore .on('load', function (){
        distrObj.AUJectHosName.setValue(RetRowid.split("^")[1]);    
         });
	   //distrObj.AUJectHosName.setValue(RetRowid.split("^")[2]);
	   distrObj.AUJectName.setValue(RetRowid.split("^")[2]);
	   distrObj.AUJectCode.setValue(RetRowid.split("^")[3]);
	   };
	   distrObj.menuwind.show();
	
	};
	obj.JectUpdate_OnClick=function(){
	var _record = obj.JectGridPanel.getSelectionModel().getSelected();
	if(!_record){
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择需要修改的数据!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	}
	else {
	distrObj = new JectMenuWind();
	var JectGridRowid=_record.get('JectGridRowid');
	var JectGridName=_record.get('JectGridName');
	var JectGridHosName=_record.get('JectGridHosName');
	var JectGridUser=_record.get('JectGridUser');
	var JectGridUserZL=_record.get('JectGridUserZL');
	var JectGridCode=_record.get('JectGridCode');
	var JectGridType=_record.get('JectGridType');
	var JectGridDel=_record.get('JectGridDel');
	var JectGridDelDD=_record.get('JectGridDelDD');
	var JectGridTel=_record.get('JectGridTel');
	var JectGridDate=_record.get('JectGridDate');
	var JectGridCreatUser=_record.get('JectGridCreatUser');
	var JectGridbz=_record.get('JectGridbz');
	var RetRowid=objAudit.SelectRetRowid(JectGridRowid);      //"PRO"_"^"_医院id_"^"_项目经理id_"^"_项目助理id_"^"_项目状态id
	   distrObj.AUJectRowid.setValue(JectGridRowid);
	   distrObj.AUJectFlag.setValue('Update');
	   distrObj.AUJectName.setValue(JectGridName);
	   distrObj.AUJectCode.setValue(JectGridCode);
	   distrObj.AUJectDel.setValue(JectGridDel);
	   distrObj.AUJectDD.setValue(JectGridDelDD);
	   distrObj.AUJectTel.setValue(JectGridTel);
	   distrObj.AUJectBZ.setValue(JectGridbz);
	   if(JectGridHosName){
	    distrObj.JectHosStore .on('load', function (){
        distrObj.AUJectHosName.setValue(RetRowid.split("^")[1]);    
         });
	   //distrObj.AUJectHosName.valueField.setValue(RetRowid.split("^")[1]);
	   //distrObj.AUJectHosName.setValue(JectGridHosName);
	   };
	   if(JectGridUser){
	    distrObj.JectUserStore .on('load', function (){
        distrObj.AUJectUser.setValue(RetRowid.split("^")[2]);    
         });
	   //distrObj.AUJectUser.setValue(JectGridUser);
	   };
	   if(JectGridUserZL){
	    distrObj.JectUserStore .on('load', function (){
        distrObj.AUJectUserZL.setValue(RetRowid.split("^")[3]);    
         });
	   //distrObj.AUJectUserZL.setValue(JectGridUserZL);
	   };
	   if(JectGridType){
	   distrObj.JectPerTypeStore .on('load', function (){
        distrObj.AUJectType.setValue(RetRowid.split("^")[4]);    
         });
	   //distrObj.AUJectType.setValue(JectGridType);
	   };
	   distrObj.menuwind.show();
	};
	};
	obj.JectName_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectUser_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectHosp_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.JectQuery_OnClick();
	};
	};
	obj.JectQuery_OnClick=function(){
	var JectName=obj.JectName.getValue();
	var JectHosp=obj.JectHosp.getValue();
	var JectCode=obj.JectCode.getValue();
	var JectUser=obj.JectUser.getValue();
	var InPut=JectName+"^"+JectHosp+"^"+JectCode+"^"+JectUser;
    obj.JectGridStore.removeAll();
	obj.JectGridStore.load({params:{InPut:InPut}});
	};
	obj.JectBatch_OnClick=function(){
	obj.JectName.setValue("");
	obj.JectHosp.setValue("");
	obj.JectCode.setValue("");
	obj.JectUser.setValue("");
	obj.JectGridStore.removeAll();
	obj.JectGridStore.load();
	};
}

function JectMenuWindEvent(obj){
      var objAudit = ExtTool.StaticServerObject("web.PMP.Common");
      obj.LoadEvent = function(){
      obj.AUJectAdd.on("click", obj.AUJectAdd_OnClick, obj);  //保存 事件
	  obj.AUJectDelete.on("click", obj.AUJectDelete_OnClick, obj);  //返回 事件
	  
   };
   obj.AUJectAdd_OnClick=function(){
    var AUJectRowid=obj.AUJectRowid.getValue();
    var AUJectFlag=obj.AUJectFlag.getValue();
    var AUJectName=obj.AUJectName.getValue();
    var AUJectCode=obj.AUJectCode.getValue();
    var AUJectHosName=obj.AUJectHosName.getValue();
    var AUJectUser=obj.AUJectUser.getValue();
	var AUJectUserZL=obj.AUJectUserZL.getValue();
	var AUJectType=obj.AUJectType.getValue();
	var AUJectDel=obj.AUJectDel.getValue();
	var AUJectDD=obj.AUJectDD.getValue();
	var AUJectTel=obj.AUJectTel.getValue();
	var AUJectBZ=obj.AUJectBZ.getValue();
	if (AUJectType==""){AUJectType="Y"};
	if (AUJectName==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '项目名称不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (AUJectCode==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '项目编码不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (AUJectHosName==""){
	Ext.Msg.show({
	          title : '温馨提示',
			  msg : '医院名称不能为空!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	return;
	};
	if (AUJectUser==""){
	Ext.MessageBox.confirm('提示', '项目经理为空，是否要继续操作？', function(btn) {
	if (btn=="yes"){
	try {
	  var Input=AUJectFlag+"^"+AUJectName+"^"+AUJectCode+"^"+AUJectHosName+"^"+AUJectUser+"^"+AUJectUserZL+"^"+AUJectType+"^"+AUJectDel+"^"+AUJectDD+"^"+AUJectTel+"^"+AUJectRowid;
	  var AddUpdateRet=objAudit.ProAddUpdate(Input,AUJectBZ);
	  if (AddUpdateRet=="1"){
	  Ext.MessageBox.alert('完成', '操作数据完成');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('JectGridPanel');
	  }
	  else{
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据操作失败，错误代码：'+AddUpdateRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	   return;
	  };
	  
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	}
	}
	else{
	return;
	};
	});
	}
	else {
	try {
	  var Input=AUJectFlag+"^"+AUJectName+"^"+AUJectCode+"^"+AUJectHosName+"^"+AUJectUser+"^"+AUJectUserZL+"^"+AUJectType+"^"+AUJectDel+"^"+AUJectDD+"^"+AUJectTel+"^"+AUJectRowid;
	  var AddUpdateRet=objAudit.ProAddUpdate(Input,AUJectBZ);
	  if (AddUpdateRet=="1"){
	  Ext.MessageBox.alert('完成', '操作数据完成');
	  obj.menuwind.close();
	  ExtTool.LoadCurrPage('JectGridPanel');
	  }
	  else{
	  Ext.Msg.show({
	          title : '温馨提示',
			  msg : '数据操作失败，错误代码：'+AddUpdateRet,
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
   };
   obj.AUJectDelete_OnClick=function(){
   obj.menuwind.close();
   };

}
