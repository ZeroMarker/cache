//Create by zzp
// 20150504
//合同工期管理
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
		obj.CAgingQuery.on("click",obj.CAgingQuery_OnClick,obj);  //查询工期事件
		
		obj.CAgingAdd.on("click", obj.CAgingAdd_OnClick, obj);  //新增工期事件 
		
		obj.CAgingUpdate.on("click", obj.CAgingUpdate_OnClick, obj);  //修改工期 事件
		
		obj.CAgingBatch.on("click", obj.CAgingBatch_OnClick, obj ); //重置工期事件 
		
		obj.CAgingCode.on("specialkey", obj.CAgingCode_specialkey,obj);  //工期编码回车事件
		
		obj.CAgingDesc.on("specialkey", obj.CAgingDesc_specialkey,obj);  //工期名称回车事件
		
		obj.CAgingModeAdd.on("click",obj.CAgingModeAdd_OnClick,obj);  //新增模块事件
		
		obj.CAgingModeUpdate.on("click",obj.CAgingModeUpdate_OnClick,obj);  //更新模块事件
		
		obj.CAgingModeQuery.on("click",obj.CAgingModeQuery_OnClick,obj);  //查询模块事件
		
		obj.CAgingModeBatch.on("click",obj.CAgingModeBatch_OnClick,obj);  //重置模块事件
		
		obj.CAgingModeCode.on("specialkey", obj.CAgingModeCode_specialkey,obj);  //模块编码回车事件
		
		obj.CAgingModeDesc.on("specialkey", obj.CAgingModeDesc_specialkey,obj);  //模块名称回车事件
		
		obj.CAgingContract.on("select",obj.CAgingContract_Select,obj); //合同改变值事件
		
		obj.CAgingGridPanel.on("rowclick", obj.CAgingGridPanel_cellclick,obj)  //行单击事件
		
		obj.CAgingGridPanel.on("rowdblclick", obj.CAgingGridPanel_rowclick,obj)  //工期双击击事件
		
		obj.CAgingModulePanel.on("rowdblclick", obj.CAgingModulePanel_rowclick,obj)  //模块双击击事件
	};
	obj.CAgingModulePanel_rowclick=function(){
	obj.CAgingModeUpdate_OnClick();
	};
	obj.CAgingGridPanel_rowclick=function(){
	obj.CAgingUpdate_OnClick();
	};
	obj.CAgingCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.CAgingQuery_OnClick();
	};
	};
	obj.CAgingDesc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.CAgingQuery_OnClick();
	};
	};
	obj.CAgingModeAdd_OnClick=function(){
	try{
	    var rowid=obj.CAgingHrowid.getValue();
		if (rowid==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择工期!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	       return;
		}
		else{
		distrObj = new ContractAgingModeWind();
	    distrObj.CAModeRowid.setValue(rowid);
		distrObj.CAModeNStore.load({params : {Rowid:rowid}});
	    distrObj.CAModeFlag.setValue('Add');
	    distrObj.menuwind.show();
		};
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	obj.CAgingModeUpdate_OnClick=function(){
	var _record = obj.CAgingModulePanel.getSelectionModel().getSelected();
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
	var ContractModeRowid=_record.get('ContractModeRowid');
	var ContractModeDesc=_record.get('ContractModeDesc');
	var ContractModeRemark=_record.get('ContractModeRemark');
	var Modeid=objAudit.ModeId(ContractModeDesc);
	try{
		distrObj = new ContractAgingModeWind();
	    distrObj.CAModeRowid.setValue(ContractModeRowid);
		//distrObj.CAModeNStore.load({params : {Rowid:ContractModeRowid}});
		if (Modeid!=""){
		  distrObj.CAModeNStore.on('load', function (){
          distrObj.CAAgingModeName.setValue(Modeid);    
         });
		};
		distrObj.CAAgingModeRemark.setValue(ContractModeRemark);
	    distrObj.CAModeFlag.setValue('Update');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.CAgingModeQuery_OnClick=function(){
	obj.CAgingModuleStore.removeAll();
	obj.CAgingModuleStore.load({params : {start:0,limit:10}});
	};
	obj.CAgingModeBatch_OnClick=function(){
	obj.CAgingModeCode.setValue('');
	obj.CAgingModeDesc.setValue('');
	obj.CAgingModuleStore.removeAll();
	obj.CAgingModuleStore.load({params : {start:0,limit:10}});
	};
	obj.CAgingModeCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.CAgingModeQuery_OnClick();
	};
	};
	obj.CAgingModeDesc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.CAgingModeQuery_OnClick();
	};
	};
	obj.CAgingAdd_OnClick=function(){
	try{
		distrObj = new ContractAgingWind();
	    distrObj.CAAddRowid.setValue('');
	    distrObj.CAAddFlag.setValue('Add');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	obj.CAgingUpdate_OnClick=function(){
	var _record = obj.CAgingGridPanel.getSelectionModel().getSelected();
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
	var CAgingGRowid=_record.get('CAgingGRowid');
	var CAgingGContractid=_record.get('CAgingGContractid');
	var CAgingGCode=_record.get('CAgingGCode');
	var CAgingGDesc=_record.get('CAgingGDesc');
	var CAgingGAging=_record.get('CAgingGAging');
	var CAgingGStatusid=_record.get('CAgingGStatusid');
	var CAgingGPlanStartDate=_record.get('CAgingGPlanStartDate');
	var CAgingGPlanStartTime=_record.get('CAgingGPlanStartTime');
	var CAgingGStartDate=_record.get('CAgingGStartDate');
	var CAgingGStartTime=_record.get('CAgingGStartTime');
	var CAgingGPlanEndDate=_record.get('CAgingGPlanEndDate');
	var CAgingGPlanEndTime=_record.get('CAgingGPlanEndTime');
	var CAgingGEndDate=_record.get('CAgingGEndDate');
	var CAgingGEndTime=_record.get('CAgingGEndTime');
	var CAgingGRemark=_record.get('CAgingGRemark');
	var CAgingGAgingid=_record.get('CAgingGAgingid');
	try{
		distrObj = new ContractAgingWind();
	    distrObj.CAAddRowid.setValue(CAgingGRowid);
		distrObj.CACode.setValue(CAgingGCode);
		distrObj.CADesc.setValue(CAgingGDesc);
		if (CAgingGAgingid!=""){
		distrObj.CAAgingStore.on('load', function (){
        distrObj.CAAgingName.setValue(CAgingGAgingid);    
         });
		};
		if (CAgingGStatusid!=""){
		distrObj.CAStratusStore.on('load', function (){
        distrObj.CAStatus.setValue(CAgingGStatusid);    
         });
		};
		if (CAgingGPlanStartDate!=""){
		distrObj.CAPlanStartDate.setValue(CAgingGPlanStartDate);
		};
		if (CAgingGPlanStartTime!=""){
		distrObj.CAPlanStratTime.setValue(CAgingGPlanStartTime);
		};
		if (CAgingGStartDate!=""){
		distrObj.CAStartDate.setValue(CAgingGStartDate);
		};
		if (CAgingGStartTime!=""){
		distrObj.CAStartTime.setValue(CAgingGStartTime);
		};
		if (CAgingGPlanEndDate!=""){
		distrObj.CAPlanEndDate.setValue(CAgingGPlanEndDate);
		};
		if (CAgingGPlanEndTime!=""){
		distrObj.CAPlanEndTime.setValue(CAgingGPlanEndTime);
		};
		if (CAgingGEndDate!=""){
		distrObj.CAEndDate.setValue(CAgingGEndDate);
		};
		if (CAgingGEndTime!=""){
		distrObj.CAEndTime.setValue(CAgingGEndTime);
		};
		distrObj.CARemark.setValue(CAgingGRemark);
		if(CAgingGContractid!=""){
		distrObj.CAContractStore.on('load', function (){
        distrObj.CAContractName.setValue(CAgingGContractid);    
         });
		};
	    distrObj.CAAddFlag.setValue('Update');
	    distrObj.menuwind.show();
	}catch(err)
	{
	   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	};
	obj.CAgingBatch_OnClick=function(){
	obj.CAgingHrowid.setValue('');
	obj.CAgingCode.setValue('');
	obj.CAgingDesc.setValue('');
	obj.CAgingAging.setValue('');
	obj.CAgingGridStore.removeAll();
	obj.CAgingGridStore.load({params : {start:0,limit:10}});
	obj.CAgingModuleStore.removeAll();
	obj.CAgingModuleStore.load({params : {start:0,limit:10}});
	};
	obj.CAgingQuery_OnClick=function(){
	obj.CAgingGridStore.removeAll();
	obj.CAgingGridStore.load({params : {start:0,limit:10}});
	};
	obj.CAgingContract_Select=function(){
	obj.CAgingQuery_OnClick();
	};
	obj.CAgingGridPanel_cellclick=function(rowIndex,columnIndex,e){
	var _record = obj.CAgingGridPanel.getSelectionModel().getSelected();
	var CAgingGRowid=_record.get('CAgingGRowid');
	obj.CAgingHrowid.setValue(CAgingGRowid);
	obj.CAgingModuleStore.removeAll();
	obj.CAgingModuleStore.load({params : {start:0,limit:10}});
	};
}

function ContractAgingWindEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
   var ip=getIpAddress();
   obj.LoadEvent = function(args){
   
       obj.CAAdd.on("click",obj.CAAdd_OnClick,obj);  //保存事件
	   
	   obj.CADelete.on("click",obj.CADelete_OnClick,obj);   //取消事件
   
   };
   obj.CAAdd_OnClick=function(){
        var CAAddRowidValue=obj.CAAddRowid.getValue();
		var CAAddFlagValue=obj.CAAddFlag.getValue();
		var CACodeValue=obj.CACode.getValue();
		var CADescValue=obj.CADesc.getValue();
        var CAAgingNameValue=obj.CAAgingName.getValue();
		var CAStatusValue=obj.CAStatus.getValue(); 
		var CAPlanStartDateValue=obj.CAPlanStartDate.getValue();
		if(CAPlanStartDateValue!=""){
	      CAPlanStartDateValue=CAPlanStartDateValue.format('Y-m-d');
	     };
		var CAPlanStratTimeValue=obj.CAPlanStratTime.getValue();
		var CAStartDateValue=obj.CAStartDate.getValue();
		if(CAStartDateValue!=""){
	      CAStartDateValue=CAStartDateValue.format('Y-m-d');
	     };
		var CAStartTimeValue=obj.CAStartTime.getValue();
		var CAPlanEndDateValue=obj.CAPlanEndDate.getValue();
		if(CAPlanEndDateValue!=""){
	      CAPlanEndDateValue=CAPlanEndDateValue.format('Y-m-d');
	     };
		var CAPlanEndTimeValue=obj.CAPlanEndTime.getValue();
		var CAEndDateValue=obj.CAEndDate.getValue();
		if(CAEndDateValue!=""){
	      CAEndDateValue=CAEndDateValue.format('Y-m-d');
	     };
		var CAEndTimeValue=obj.CAEndTime.getValue();
		var CARemarkValue=obj.CARemark.getValue();
        var CAContractNameValue=obj.CAContractName.getValue();
        if((CAPlanStartDateValue>CAPlanEndDateValue)&&(CAPlanEndDateValue!="")&&(CAPlanStartDateValue!="")){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“计划开始日期”和“计划结束日期”和不合理！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};	
		if ((CAStartDateValue>CAEndDateValue)&&(CAStartDateValue!="")&&(CAEndDateValue!="")){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '“实际开始日期”和“实际结束日期”和不合理！',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};
		if (CAStatusValue==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '工期状态是必填项哟~~~!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};
		if (CAContractNameValue==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '合同名称是必填项哟~~~!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};
		if (CACodeValue==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '工期编码是必填项哟~~~!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};
		if (CADescValue==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '工期名称是必填项哟~~~!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};
		if (CAAgingNameValue==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '合同工期是必填项哟~~~!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		
		};
		var AddUpdateString=CAAddRowidValue+"^"+CAAddFlagValue+"^"+CACodeValue+"^"+CADescValue+"^"+CAAgingNameValue+"^"+CAStatusValue+"^"+CAPlanStartDateValue+"^"+CAPlanStratTimeValue+"^"+CAStartDateValue+"^"+CAStartTimeValue+"^"+CAPlanEndDateValue+"^"+CAPlanEndTimeValue+"^"+CAEndDateValue+"^"+CAEndTimeValue+"^"+CAContractNameValue;
		var AddUpdateRet=objAudit.AddUpdateContractAging(AddUpdateString,CARemarkValue,ip);
		if (AddUpdateRet=="1"){
		Ext.MessageBox.alert('Status','数据操作成功！');
		ExtTool.LoadCurrPage('CAgingGridPanel');
		ExtTool.LoadCurrPage('CAgingModulePanel');
		obj.menuwind.close();
		}
		else {
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+AddUpdateRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		};
	    
   };
   obj.CADelete_OnClick=function(){
   obj.menuwind.close();
   };
   
};

function ContractAgingModeWindEvent(obj){
   var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
   var ip=getIpAddress();
   obj.LoadEvent = function(args){
       obj.CAModeAdd.on("click",obj.CAModeAdd_OnClick,obj);  //保存事件
	   
	   obj.CAModeDelete.on("click",obj.CAModeDelete_OnClick,obj);   //取消事件
   };
   obj.CAModeAdd_OnClick=function(){
        var CAModeRowidValue=obj.CAModeRowid.getValue();
		var CAModeFlagValue=obj.CAModeFlag.getValue();
		var CAAgingModeNameValue=obj.CAAgingModeName.getValue();
		if(CAAgingModeNameValue==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '模块名称是必填项哟~~~!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
		 };
	   var CAAgingModeRemarkValue=obj.CAAgingModeRemark.getValue();
	   var ModeString=CAModeRowidValue+"^"+CAModeFlagValue+"^"+CAAgingModeNameValue;
	   var ModeAddUpdateRet=objAudit.ModeAddUpdateAging(ModeString,CAAgingModeRemarkValue,ip);
	   if (ModeAddUpdateRet=="1"){
	    Ext.MessageBox.alert('Status','数据操作成功！');
		ExtTool.LoadCurrPage('CAgingModulePanel');
		obj.menuwind.close();
	   }
	   else{
	   Ext.Msg.show({
	          title : '温馨提示',
			  msg : '操作失败，错误代码：'+ModeAddUpdateRet,
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
	      return;
	   }
   };
   obj.CAModeDelete_OnClick=function(){
   obj.menuwind.close();
   };
};