//Create by zzp
// 20150519
//任务计划
function InitviewScreenEvent(obj) {
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	//obj.intCurrRowIndex = -1;
	obj.LoadEvent = function(args){
	  obj.Plantree.on("click",obj.Plantree_OnClick,obj);  //树形结构单击事件
	  
	  obj.PlanAdd.on("click", obj.PlanAdd_OnClick, obj);  //新增事件 
		
	  obj.PlanUpdate.on("click", obj.PlanUpdate_OnClick, obj);  //修改 事件
		
	  obj.PlanQuery.on("click", obj.PlanQuery_OnClick, obj);  //查询事件  
		
	  obj.PlanBatch.on("click", obj.PlanBatch_OnClick, obj ); //重置事件 

      obj.PlanCode.on("specialkey", obj.PlanCode_specialkey,obj)  //编码回车事件
		
	  obj.PlanDesc.on("specialkey", obj.PlanDesc_specialkey,obj)  //名称回车事件

     obj.ContractGridPanel.on('cellclick',obj.ContractGridPanel_CellClick,obj)  	  
		
   };
   obj.ContractGridPanel_CellClick=function(grid, rowIndex, columnIndex, e){
	var btn = e.getTarget('.controlBtn');  
	if (btn){  
    var t = e.getTarget();  
    var record = obj.ContractGridPanel.getStore().getAt(rowIndex);  
	var control = t.className; 
	var PPPGridRowid=record.get('PPPGridRowid');
	if(control=="ContractDetail"){
	try{

			var PPPGridRowid=record.get('PPPGridRowid');
			var PPPGridFlag=record.get('PPPGridFlag');
			var PPPGridCode=record.get('PPPGridCode');
			var PPPGridDesc=record.get('PPPGridDesc');
			var PPPGridPlanStartDate=record.get('PPPGridPlanStartDate');
			
			var PPPGridPlanStartTime=record.get('PPPGridPlanStartTime');
			var PPPGridStartDate=record.get('PPPGridStartDate');
			var PPPGridStartTime=record.get('PPPGridStartTime');
			var PPPGridPlanEndDate=record.get('PPPGridPlanEndDate');
			var PPPGridPlanEndTime=record.get('PPPGridPlanEndTime');

			var PPPGridEndDate=record.get('PPPGridEndDate');
			var PPPGridEndTime=record.get('PPPGridEndTime');
			var PPPGridStatus=record.get('PPPGridStatus');
			var PPPGridStatusid=record.get('PPPGridStatusid');
			var PPPGridImprovment=record.get('PPPGridImprovment');
			var PPPGridImprovmentid=record.get('PPPGridImprovmentid');
			var PPPGridJobLogg=record.get('PPPGridJobLogg');
			var PPPGridJobLoggid=record.get('PPPGridJobLoggid');

			var PPPGridContractAging=record.get('PPPGridContractAging');
			var PPPGridContractAgingid=record.get('PPPGridContractAgingid');
			var PPPGridModule=record.get('PPPGridModule');
			var PPPGridModuleid=record.get('PPPGridModuleid');
			var PPPGridContract=record.get('PPPGridContract');
			var PPPGridContractid=record.get('PPPGridContractid');
			var PPPGridUser=record.get('PPPGridUser');
			var PPPGridMenu=record.get('PPPGridMenu');

			var PPPGridRemark=record.get('PPPGridRemark');
			
			
			distrObj = new PPPMenuWind();
			Ext.getCmp('PPPMenuAdd').hide();
			
			distrObj.PPPMenuRowid.setValue(PPPGridRowid);
			distrObj.PPPMenuFlag.setValue('Update');
			distrObj.PPPMenuCode.setValue(PPPGridCode);
			distrObj.PPPMenuDesc.setValue(PPPGridDesc);
			distrObj.PPPMenuPlanStartDate.setValue(PPPGridPlanStartDate);
			
			distrObj.PPPMenuPlanStartTime.setValue(PPPGridPlanStartTime);
			distrObj.PPPMenuStartDate.setValue(PPPGridStartDate);
			distrObj.PPPMenuStartTime.setValue(PPPGridStartTime);
			distrObj.PPPMenuPlanEndDate.setValue(PPPGridPlanEndDate);
			distrObj.PPPMenuPlanEndTime.setValue(PPPGridPlanEndTime);

			distrObj.PPPMenuEndDate.setValue(PPPGridEndDate);
			distrObj.PPPMenuEndTime.setValue(PPPGridEndTime);
			
			if (PPPGridStatusid!="")
				{
					distrObj.PPPMenuStatusStore.on('load', function (){
					distrObj.PPPMenuStatus.setValue(PPPGridStatusid);});
				};

			if (PPPGridImprovmentid!="")
				{
					distrObj.PPPMenuIMPROStore.on('load', function (){
					distrObj.PPPMenuImpro.setValue(PPPGridImprovmentid);});
				};

			if (PPPGridJobLoggid!="")
				{
					distrObj.PPPJobStore.on('load', function (){
					distrObj.PPPMenuJob.setValue(PPPGridJobLoggid);});
				};

			if (PPPGridContractAgingid!="")
				{
					distrObj.PPPMenuContractAgingStore.on('load', function (){
					distrObj.PPPMenuContractAging.setValue(PPPGridContractAgingid);});
				};

			if (PPPGridModuleid!="")
				{
					distrObj.PPPMenuModeStore.on('load', function (){
					distrObj.PPPMenuMode.setValue(PPPGridModuleid);});
				};
			
			if (PPPGridContractid!="")
				{
					distrObj.PPPMenuContractStore.on('load', function (){
					distrObj.PPPMenuContract.setValue(PPPGridContractid);});
				};
			
			if (PPPGridUser!="")
				{
					distrObj.PPPMenuUserStore.on('load', function (){
					distrObj.PPPMenuUser.setValue(PPPGridUser);});
				};
			
			distrObj.PPPMenuMenu.setValue(PPPGridMenu);
			distrObj.PPPMenuRemark.setValue(PPPGridRemark);
			
			distrObj.menuwindadd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="ContractUser"){
	try{
		UserAddObj=new ResponsUserWind(obj);
		UserAddObj.ResponsRowid.setValue(PPPGridRowid);
		UserAddObj.ResponsUserGridStore.load({});
		UserAddObj.menuwindResponsAd.show();	
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	if(control=="Download"){
	try{
	//附件下载列表
	DownLoadWind=new AdjunctAllWind();
	DownLoadWind.AdjunctAllRowid.setValue(PPPGridRowid);
	DownLoadWind.AdjunctAllType.setValue('PMP_ProjectPlan');
	DownLoadWind.AdjunctAllTypeStoreProxy.on('beforeload', function(objProxy, param){
	param.ClassName = 'DHCPM.Query.PMQueryAll';
    param.QueryName = 'ContracAdjunctStore';
    param.Arg1 = 'PMP_ProjectPlan';   //  IPAJ_Affiliation  附件表中的归属字段
    param.Arg2 = PPPGridRowid;      //rowid
    param.ArgCnt = 2; 
	});
	DownLoadWind.AdjunctAllTypeStore.load({}); 
	DownLoadWind.menuwindContracAd.show();
	}catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};
	};
	}
	}
   obj.PlanAdd_OnClick=function(){
   try{
        var node=obj.PlanRowid.getValue();
		if (node==""){
		Ext.Msg.show({
	          title : '温馨提示',
			  msg : '请选择左侧节点!',
			  icon : Ext.Msg.WARNING,
			  buttons : Ext.Msg.OK
			  });
		return;
		}
		else{
		distrObj = new PPPMenuWind();
	    distrObj.PPPMenuRowid.setValue(node);
	    distrObj.PPPMenuFlag.setValue('Add');
	    distrObj.menuwindadd.show();
		};        
   }catch(err)
	{
	ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
	};  
   };
obj.PlanUpdate_OnClick=function()
{
   var _record = obj.ContractGridPanel.getSelectionModel().getSelected();
	if(!_record)
		{
		  Ext.Msg.show({
				  title : '温馨提示',
				  msg : '请选择数据!',
				  icon : Ext.Msg.WARNING,
				  buttons : Ext.Msg.OK
				  });
		   return;
		}
	else 
	{
		try{
			var PPPGridRowid=_record.get('PPPGridRowid');
			var PPPGridFlag=_record.get('PPPGridFlag');
			var PPPGridCode=_record.get('PPPGridCode');
			var PPPGridDesc=_record.get('PPPGridDesc');
			var PPPGridPlanStartDate=_record.get('PPPGridPlanStartDate');
			
			var PPPGridPlanStartTime=_record.get('PPPGridPlanStartTime');
			var PPPGridStartDate=_record.get('PPPGridStartDate');
			var PPPGridStartTime=_record.get('PPPGridStartTime');
			var PPPGridPlanEndDate=_record.get('PPPGridPlanEndDate');
			var PPPGridPlanEndTime=_record.get('PPPGridPlanEndTime');

			var PPPGridEndDate=_record.get('PPPGridEndDate');
			var PPPGridEndTime=_record.get('PPPGridEndTime');
			var PPPGridStatus=_record.get('PPPGridStatus');
			var PPPGridStatusid=_record.get('PPPGridStatusid');
			var PPPGridImprovment=_record.get('PPPGridImprovment');
			var PPPGridImprovmentid=_record.get('PPPGridImprovmentid');
			var PPPGridJobLogg=_record.get('PPPGridJobLogg');
			var PPPGridJobLoggid=_record.get('PPPGridJobLoggid');

			var PPPGridContractAging=_record.get('PPPGridContractAging');
			var PPPGridContractAgingid=_record.get('PPPGridContractAgingid');
			var PPPGridModule=_record.get('PPPGridModule');
			var PPPGridModuleid=_record.get('PPPGridModuleid');
			var PPPGridContract=_record.get('PPPGridContract');
			var PPPGridContractid=_record.get('PPPGridContractid');
			var PPPGridUser=_record.get('PPPGridUser');
			var PPPGridMenu=_record.get('PPPGridMenu');

			var PPPGridRemark=_record.get('PPPGridRemark');
			
			
			distrObj = new PPPMenuWind();
			Ext.getCmp("PPPMenuUser").disabled = true;
			
			distrObj.PPPMenuRowid.setValue(PPPGridRowid);
			distrObj.PPPMenuFlag.setValue('Update');
			distrObj.PPPMenuCode.setValue(PPPGridCode);
			distrObj.PPPMenuDesc.setValue(PPPGridDesc);
			distrObj.PPPMenuPlanStartDate.setValue(PPPGridPlanStartDate);
			
			distrObj.PPPMenuPlanStartTime.setValue(PPPGridPlanStartTime);
			distrObj.PPPMenuStartDate.setValue(PPPGridStartDate);
			distrObj.PPPMenuStartTime.setValue(PPPGridStartTime);
			distrObj.PPPMenuPlanEndDate.setValue(PPPGridPlanEndDate);
			distrObj.PPPMenuPlanEndTime.setValue(PPPGridPlanEndTime);

			distrObj.PPPMenuEndDate.setValue(PPPGridEndDate);
			distrObj.PPPMenuEndTime.setValue(PPPGridEndTime);
			
			if (PPPGridStatusid!="")
				{
					distrObj.PPPMenuStatusStore.on('load', function (){
					distrObj.PPPMenuStatus.setValue(PPPGridStatusid);});
				};

			if (PPPGridImprovmentid!="")
				{
					distrObj.PPPMenuIMPROStore.on('load', function (){
					distrObj.PPPMenuImpro.setValue(PPPGridImprovmentid);});
				};

			if (PPPGridJobLoggid!="")
				{
					distrObj.PPPJobStore.on('load', function (){
					distrObj.PPPMenuJob.setValue(PPPGridJobLoggid);});
				};

			if (PPPGridContractAgingid!="")
				{
					distrObj.PPPMenuContractAgingStore.on('load', function (){
					distrObj.PPPMenuContractAging.setValue(PPPGridContractAgingid);});
				};

			if (PPPGridModuleid!="")
				{
					distrObj.PPPMenuModeStore.on('load', function (){
					distrObj.PPPMenuMode.setValue(PPPGridModuleid);});
				};
			
			if (PPPGridContractid!="")
				{
					distrObj.PPPMenuContractStore.on('load', function (){
					distrObj.PPPMenuContract.setValue(PPPGridContractid);});
				};
			
			if (PPPGridUser!="")
				{
					distrObj.PPPMenuUserStore.on('load', function (){
					distrObj.PPPMenuUser.setValue(PPPGridUser);});
				};
			
			distrObj.PPPMenuMenu.setValue(PPPGridMenu);
			distrObj.PPPMenuRemark.setValue(PPPGridRemark);
			
			distrObj.menuwindadd.show();
		}catch(err)
			{
				ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
			};
	};
};
   obj.PlanBatch_OnClick=function(){
   obj.PlanCode.setValue('');
   obj.PlanDesc.setValue('');
   obj.PlanQuery_OnClick();
   };
   obj.PlanQuery_OnClick=function(){
      obj.PlanGridStore.removeAll();
	  obj.PlanGridStore.load({params : {start:0,limit:20}});
   };
   obj.PlanCode_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PlanQuery_OnClick();
	};
   };
   obj.PlanDesc_specialkey=function(field,e){
	if (e.keyCode== 13){
	obj.PlanQuery_OnClick();
	};
   };
   obj.Plantree_OnClick=function(node,event){
	  var Rowid=node.id;
	  var Text=node.text;
	  obj.PlanRowid.setValue(Rowid);
	  obj.PlanGridStore.removeAll();
	  obj.PlanGridStore.load({params : {start:0,limit:20}});
	  };

}
function ContractMenuWindEvent(obj){
    
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	obj.LoadEvent = function(args)
	{
	  obj.PPPMenuAdd.on("click",obj.PerformancePlanFun_OnClick,obj);
	  
	  obj.PPPMenuDelete.on("click",obj.PerformancePlanReset_OnClick,obj);
	  
	};
	obj.PerformancePlanFun_OnClick=function()
		{
			var PPPMenuRowid=obj.PPPMenuRowid.getValue();
			var PPPMenuFlag=obj.PPPMenuFlag.getValue();
			var PPPMenuCode=obj.PPPMenuCode.getValue();
			var PPPMenuDesc=obj.PPPMenuDesc.getValue();
			var PPPMenuPlanStartDate=obj.PPPMenuPlanStartDate.getValue();
			
			var PPPMenuPlanStartTime=obj.PPPMenuPlanStartTime.getValue();
			var PPPMenuStartDate=obj.PPPMenuStartDate.getValue();
			var PPPMenuStartTime=obj.PPPMenuStartTime.getValue();
			var PPPMenuPlanEndDate=obj.PPPMenuPlanEndDate.getValue();
			var PPPMenuPlanEndTime=obj.PPPMenuPlanEndTime.getValue();

			var PPPMenuEndDate=obj.PPPMenuEndDate.getValue();
			var PPPMenuEndTime=obj.PPPMenuEndTime.getValue();
			var PPPMenuStatus=obj.PPPMenuStatus.getValue();
			var PPPMenuImpro=obj.PPPMenuImpro.getValue();
			var PPPMenuJob=obj.PPPMenuJob.getValue();

			var PPPMenuContractAging=obj.PPPMenuContractAging.getValue();
			var PPPMenuMode=obj.PPPMenuMode.getValue();
			var PPPMenuContract=obj.PPPMenuContract.getValue();
			var PPPMenuUser=obj.PPPMenuUser.getValue();
			var PPPMenuMenu=obj.PPPMenuMenu.getValue();

			var PPPMenuRemark=obj.PPPMenuRemark.getValue();

			if (PPPMenuPlanStartDate!="")
				{
					PPPMenuPlanStartDate=PPPMenuPlanStartDate.format('Y-m-d');
				};
			if (PPPMenuStartDate!="")
				{
					PPPMenuStartDate=PPPMenuStartDate.format('Y-m-d');
				};			
			if (PPPMenuPlanEndDate!="")
				{
					PPPMenuPlanEndDate=PPPMenuPlanEndDate.format('Y-m-d');
				};
			if (PPPMenuEndDate!="")
				{
					PPPMenuEndDate=PPPMenuEndDate.format('Y-m-d');
				};
			/*******************************************校验数据******************************************************/
			if((PPPMenuPlanStartDate!="")&&(PPPMenuPlanEndDate!="")&&(PPPMenuPlanEndDate<PPPMenuPlanStartDate))
				{
				  Ext.Msg.show({
						  title : '温馨提示',
						  msg : '计划开始或结束日期不合理，请重新选择！！！',
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				}
				
				if((PPPMenuCode==""))
					{
					  Ext.Msg.show({
							  title : '温馨提示',
							  msg : '计划编码不能为空，请重新填写！！！',
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
					   return;
					}
				
				if((PPPMenuDesc==""))
					{
					  Ext.Msg.show({
							  title : '温馨提示',
							  msg : '计划名称不能为空，请重新填写！！！',
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
					   return;
					}
				
			if((PPPMenuPlanStartDate==""))
				{
				  Ext.Msg.show({
						  title : '温馨提示',
						  msg : '计划开始日期不能为空，请重新选择！！！',
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				}
			
			if((PPPMenuPlanStartDate!="")&&(PPPMenuPlanEndDate!="")&&(PPPMenuEndDate<=PPPMenuStartDate))
				{
				  Ext.Msg.show({
						  title : '温馨提示',
						  msg : '实际开始日期大于实际结束日期，请重新选择！！！',
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				}
			var inputStr=PPPMenuRowid+"^"+PPPMenuFlag+"^"+PPPMenuCode+"^"+PPPMenuDesc+"^"+PPPMenuPlanStartDate+"^"+PPPMenuPlanStartTime+"^"+PPPMenuStartDate
				inputStr=inputStr+"^"+PPPMenuStartTime+"^"+PPPMenuPlanEndDate+"^"+PPPMenuPlanEndTime+"^"+PPPMenuEndDate+"^"+PPPMenuEndTime+"^"+PPPMenuStatus
				inputStr=inputStr+"^"+PPPMenuImpro+"^"+PPPMenuJob+"^"+PPPMenuContractAging+"^"+PPPMenuMode+"^"+PPPMenuContract+"^"+PPPMenuUser
				inputStr=inputStr+"^"+PPPMenuMenu+"^"+PPPMenuRemark
			try {
				 var PerformancePlanFun=objAudit.PerformancePlanFun(inputStr);
				 
				 if (PerformancePlanFun>0)
				 {
					  Ext.MessageBox.alert('完成', '操作数据完成');
					  obj.menuwindadd.close();
					  ExtTool.LoadCurrPage('ContractGridPanel');
				 }
				 else {
				 Ext.Msg.show({
						  title : '温馨提示',
						  msg : '数据操作失败，错误代码：'+PerformancePlanFun,
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
	obj.PerformancePlanReset_OnClick=function()
		{
			obj.menuwindadd.close();
		};

};

function ResponsUserWindEvent(obj)
{		
		obj.LoadEvent = function(args)
		{
			obj.ResponsUserAdd.on("click",obj.ResponsUserAdd_OnClick,obj);
			obj.ResponsUserDelete.on("click",obj.ResponsUserDelete_OnClick,obj);
		}
		obj.ResponsUserAdd_OnClick=function()
		{
			try{
				distrObj = new PUUserModAddUpWind();
				distrObj.AddModeRowid.setValue(obj.ResponsRowid.getValue());
				distrObj.AddModeFlag.setValue('Add');
				distrObj.menuwindadd.show();
			}catch(err)
				{
				   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				} 
		};
		obj.ResponsUserDelete_OnClick=function()
		{
			try{
				var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
				var PlanID=obj.ResponsUserGridPanel.getSelectionModel().getSelected().get('ResponsGridPlanRowID')
				var SubID=obj.ResponsUserGridPanel.getSelectionModel().getSelected().get('ResponsGridRowid')
				var DeleteID=PlanID+"||"+SubID
				var AddModeFlag="Delete"
				if(DeleteID=="")
				{
				  Ext.Msg.show({
						  title : '温馨提示',
						  msg : '请选择要删除的记录！！！',
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				}
			var inputStr=AddModeFlag+"^"+DeleteID
			var AddModeAddFun=objAudit.DeleteModeAddFun(inputStr);
				 
			if (AddModeAddFun==0)
				 {
					  Ext.MessageBox.alert('完成', '操作数据完成');
					  ExtTool.LoadCurrPage('ResponsUserGridPanel');
				 }
			else {
				Ext.Msg.show({
						title : '温馨提示',
						msg : '数据操作失败，错误代码：'+AddModeAddFun,
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
						});
				   return;
				 }

			}catch(err)
				{
				   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				} 
		}
}

function PUUserModAddUpWindEvent(obj)
{		
		var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
		obj.LoadEvent = function(args)
		{
			obj.AddModeAdd.on("click",obj.AddModeAdd_OnClick,obj);
			obj.AddModeDelete.on("click",obj.AddModeDelete_OnClick,obj);
		}
		obj.AddModeAdd_OnClick=function()
		{	
			var AddModeRowid=obj.AddModeRowid.getValue();
			var AddModeFlag=obj.AddModeFlag.getValue();
			var AddModeUserName=obj.AddModeUserName.getValue();
			var AddModeInDate=obj.AddModeInDate.getValue();
			var AddModeOutDate=obj.AddModeOutDate.getValue();
			var AddModeCreatUser=session['LOGON.USERNAME'];

			if (AddModeInDate!="")
				{
					AddModeInDate=AddModeInDate.format('Y-m-d');
				};
			if (AddModeOutDate!="")
				{
					AddModeOutDate=AddModeOutDate.format('Y-m-d');
				};			
				
			if((AddModeUserName==""))
					{
					  Ext.Msg.show({
							  title : '温馨提示',
							  msg : '责任人不能为空，请重新填写！！！',
							  icon : Ext.Msg.WARNING,
							  buttons : Ext.Msg.OK
							  });
					   return;
					}
				
			if((AddModeInDate==""))
				{
				  Ext.Msg.show({
						  title : '温馨提示',
						  msg : '责任人开始日期不能为空，请重新选择！！！',
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				}
			
			if((AddModeInDate!="")&&(AddModeOutDate!="")&&(AddModeOutDate<AddModeInDate))
				{
				  Ext.Msg.show({
						  title : '温馨提示',
						  msg : '结束事件大于开始时间，请重新选择！！！',
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				}
			var inputStr=AddModeFlag+"^"+AddModeRowid+"^"+AddModeUserName+"^"+AddModeInDate+"^"+AddModeOutDate+"^"+AddModeCreatUser
			try {
				 var AddModeAddFun=objAudit.AddModeAddFun(inputStr);
				 
				 if (AddModeAddFun==0)
				 {
					  Ext.MessageBox.alert('完成', '操作数据完成');
					  obj.menuwindadd.close();
					  ExtTool.LoadCurrPage('ResponsUserGridPanel');
				 }
				 else {
				 Ext.Msg.show({
						  title : '温馨提示',
						  msg : '数据操作失败，错误代码：'+AddModeAddFun,
						  icon : Ext.Msg.WARNING,
						  buttons : Ext.Msg.OK
						  });
				   return;
				 }
		   }catch(err)
				{
				   ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
		}
		obj.AddModeDelete_OnClick=function()
		{
			obj.menuwindadd.close();
		}
}