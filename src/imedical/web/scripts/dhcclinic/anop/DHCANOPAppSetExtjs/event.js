function InitViewScreenEvent(obj)
{
	var _DHCANOPAppSet=ExtTool.StaticServerObject('web.DHCANOPAppSet');
	
	obj.LoadEvent = function(args)
	{
		var ret=_DHCANOPAppSet.GetAppSet();
		if(ret)
		{
			var appSet = ret.split("@");
			var AppArcimStr = appSet[0];
			var AppTime = appSet[1];
			var arcimNote = appSet[2];
			var NoteVar = appSet[3];
			var InsertDefRoom = appSet[4];
			var SendMessage = appSet[5];
			var InsertLabInfo = appSet[6];
			var IPDefOpLocStr = appSet[7];
			var OPDefOpLocStr = appSet[8];
			var DirAuditStr = appSet[9];
			var chargeTogether = appSet[11];	//20161220+dyl
			var PatScheduleStr= appSet[12];	    //20170811 YuanLin
			var NursingWorkerStr= appSet[13];	//20170811 YuanLin
			var dayOperNeedAn= appSet[14];	//日间是否需要麻醉
			var oneOperName=appSet[15]			//20190102 yq
			//手术申请对应医嘱项
			var AppArcim = AppArcimStr.split("^");
			//alert()
			obj.appArcim.setValue(AppArcim[1]);
			obj.appArcim.setRawValue(AppArcim[0]);
			//obj.LoadCombox(obj.appArcim,AppArcimStr)
			//手术申请时间限制
			obj.appTime.setRawValue(AppTime);
			
			//手术对应医嘱项备注
			obj.arcimNote.setValue(arcimNote);
			
			//备注代码对应名称
			obj.noteVar.setValue(NoteVar);
			
			//是否插入默认手术间
			if(InsertDefRoom=="Y")
			{
				//obj.chkInsertDefRoom.setValue(true);
			}
			
			//是否发送消息
			if(SendMessage=="Y")
			{
				obj.chkSendMessage.setValue(true);
			}
			
			//是否自动带入检验结果
			if(InsertLabInfo=="Y")
			{
				obj.chkInsertLabInfo.setValue(true);
			}
			//是否合并收费+20161220+dyl
			if(chargeTogether=="Y")
			{
				obj.chkChargeTogether.setValue(true);
			}
			if(dayOperNeedAn=="Y")
			{
				obj.chkDayOperNeedAN.setValue(true);
			}
			//拟施手术名称和实施手术名称是否一致 20190102 yq
			if(oneOperName=="Y")
			{
				obj.chkOneOperName.setValue(true);
			}
			//住院申请默认手术室
			var IPDefOpLoc=IPDefOpLocStr.split("^");
			obj.IPDefOpLoc.setValue(IPDefOpLoc[0]);
			obj.IPDefOpLoc.setRawValue(IPDefOpLoc[1]);
			
			//门诊申请默认手术室
			var OPDefOpLoc=OPDefOpLocStr.split("^");
			obj.OPDefOpLoc.setValue(OPDefOpLoc[0]);
			obj.OPDefOpLoc.setRawValue(OPDefOpLoc[1]);
			
			//病人调度安全组 20170811 YuanLin
			var PatSchedule=PatScheduleStr.split("^");
			obj.PatSchedule.setValue(PatSchedule[0]);
			obj.PatSchedule.setRawValue(PatSchedule[1]);
			
			//护工安全组     20170811 YuanLin
			var NursingWorker=NursingWorkerStr.split("^");
			obj.NursingWorker.setValue(NursingWorker[0]);
			obj.NursingWorker.setRawValue(NursingWorker[1]);
			
			//科主任审核安全组
			var DirAuditList=DirAuditStr.split("^")
			for(var i=0; i<DirAuditList.length; i++ )
			{
				var DirAudit = (DirAuditList[i]).split("!");
				var DirAuditArry = [];
				DirAuditArry.push(DirAudit[1]);
				DirAuditArry.push(DirAudit[0]);
				obj.data.push(DirAuditArry);
			}
			obj.DirAuditListStore.load();
		}
	};
	obj.LoadCombox=function(combox,item)
	{
	 if("undefined" == typeof item) return;
	 var itemList=item.split("^")
	 if(itemList.length>1)
	 {
	 combox.setValue(itemList[0]);
	 combox.setRawValue(itemList[1])
	 }
	}

	//科主任审核安全组下拉框选中时
	obj.DirAudit_select=function()
	{
		var DirAudit=obj.DirAudit.getRawValue();
		var DirAuditId=obj.DirAudit.getValue();
		obj.DirAudit.clearValue();
		
		//判断是否已经在列表中
		for(var i=0; i<obj.data.length;i++)
		{
			if(DirAuditId==obj.data[i][0])
			{
				return;
			}
		}
		var DirAuditArry = [];
		DirAuditArry.push(DirAuditId);
		DirAuditArry.push(DirAudit);
		obj.data.push(DirAuditArry);
		obj.DirAuditListStore.load();
	};
	
	//科主任审核安全组列表双击时删除
	obj.DirAuditListGridPanel_rowdblclick=function()
	{
		var rcs = obj.DirAuditListGridPanel.getSelectionModel().getSelections();
		
		var DirAuditId=rcs[0].get("listId");
		var DirAuditDesc=rcs[0].get("listDesc");
		for(var i=0; i<obj.data.length; i++)
		{
			if(DirAuditId==obj.data[i][0])
			{
				obj.data.splice(i,1);
				break;
			}
		}
		obj.DirAuditListStore.load();
	}
	
	
	//保存手术申请配置
	obj.saveButton_click=function()
	{
		var AppArcimId = obj.appArcim.getValue();
		var AppTime = obj.appTime.getRawValue();
		var arcimNote = obj.arcimNote.getValue();
		var NoteVar = obj.noteVar.getValue();
		
		var InsertDefRoom = "N";
		/*
		if(obj.chkInsertDefRoom.getValue())
		{
			InsertDefRoom = "Y";
		}
		*/
		
		var SendMessage = "N";
		if(obj.chkSendMessage.getValue())
		{
			SendMessage = "Y";
		}
		
		var InsertLabInfo = "N";
		if(obj.chkInsertLabInfo.getValue())
		{
			InsertLabInfo = "Y";
		}
		//合并收费+20161220+dyl
		var chargeTogether = "N";
		if(obj.chkChargeTogether.getValue())
		{
			chargeTogether = "Y";
		}
		
		var dayoperneedan = "N";
		if(obj.chkDayOperNeedAN.getValue())
		{
			dayoperneedan = "Y";
		}
		
		var IPDefOpLocId = obj.IPDefOpLoc.getValue();
		var OPDefOpLocId = obj.OPDefOpLoc.getValue();
		
		//病人调度 20170811 YuanLin
		var PatScheduleId = obj.PatSchedule.getValue();
		//护工     20170811 YuanLin
		var NursingWorkerId = obj.NursingWorker.getValue();
		
		var DirAuditList="";
		for(var i=0; i<obj.data.length; i++)
		{
			if(DirAuditList=="")
			{
				DirAuditList=obj.data[i][0];
			}
			else
			{
				DirAuditList=DirAuditList+"^"+obj.data[i][0];
			}
		}
		
		//拟施实施手术名称是否一致 20190102 yq
		var oneOperName=obj.chkOneOperName.getValue()?"Y":"N";
		
		var appSetStr=AppArcimId+"@"+AppTime+"@"+arcimNote+"@"+NoteVar+"@"+InsertDefRoom+"@"
		+SendMessage+"@"+InsertLabInfo+"@"+IPDefOpLocId+"@"+OPDefOpLocId+"@"+DirAuditList+"@"
		+"@"+chargeTogether+"@"+PatScheduleId+"@"+NursingWorkerId+"@"+dayoperneedan+"@"+oneOperName;
		
		//alert(appSetStr);
		//return;
		var ret = _DHCANOPAppSet.SaveAppSet(appSetStr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存成功");
		}
		else
		{
			Ext.Msg.alert("提示","保存失败");
		}
	};
	//
	obj.appArcim_select=function()
	{
	  	obj.appArcimStore.reload({});
	 }

	//添加手术医生类型
	obj.addOpDocButton_click=function()
	{
		var OpDocTypeIdStr="";
		for(var i=0;i<obj.OpDocTypeStore.getCount();i++)
		{
			var OpDocTypeId=obj.OpDocTypeStore.getAt(i).get("OpDocTypeId");
			if(OpDocTypeIdStr=="")
			{
				OpDocTypeIdStr=OpDocTypeId;
			}
			else
			{
				OpDocTypeIdStr=OpDocTypeIdStr+"^"+OpDocTypeId;
			}
		}
		
		
		var rcs = obj.CarPrvTp.getSelectionModel().getSelections();
		var len=rcs.length;
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				var CTCPTRowId=rcs[i].get("CTCPTRowId");
				if(IsInOpDocType(CTCPTRowId))
				{
					continue;
				}
				if(OpDocTypeIdStr=="")
				{
					OpDocTypeIdStr=CTCPTRowId;
				}
				else
				{
					OpDocTypeIdStr=OpDocTypeIdStr+"^"+CTCPTRowId;
				}
			}
			var ret = _DHCANOPAppSet.SaveOpDocType(OpDocTypeIdStr);
			if(ret=="0")
			{
				obj.OpDocTypeStore.load({});
			}
			else
			{
				Ext.Msg.alert("提示","添加失败");
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在医护人员类型中选择一行");
		}
	}
	
	//判断要添加的类型是否在手术医生类型中已存在
	function IsInOpDocType(CTCPTRowId)
	{
		for(var i=0;i<obj.OpDocTypeStore.getCount();i++)
		{
			var OpDocTypeId=obj.OpDocTypeStore.getAt(i).get("OpDocTypeId");
			if(OpDocTypeId==CTCPTRowId)
			{
				return true;
			}
		}
		return false;
	}
	
	//删除手术医生类型
	obj.delOpDocButton_click=function()
	{	
		var rcs = obj.OpDocType.getSelectionModel().getSelections();
		var len=rcs.length;
		
		if(len>0)
		{
			for(var i=0;i<len;i++)
			{
				obj.OpDocTypeStore.remove(rcs[i]);
			}
			var OpDocTypeIdStr="";
			for(var i=0;i<obj.OpDocTypeStore.getCount();i++)
			{
				var OpDocTypeId=obj.OpDocTypeStore.getAt(i).get("OpDocTypeId");
				if(OpDocTypeIdStr=="")
				{
					OpDocTypeIdStr=OpDocTypeId;
				}
				else
				{
					OpDocTypeIdStr=OpDocTypeIdStr+"^"+OpDocTypeId;
				}
			}
			var ret = _DHCANOPAppSet.SaveOpDocType(OpDocTypeIdStr);
			if(ret=="0")
			{
				obj.OpDocTypeStore.load({});
			}
			else
			{
				Ext.Msg.alert("提示","删除失败");
			}
		}
		else
		{
			Ext.Msg.alert("提示","请至少在手术医生类型中选择一行");
		}
	}
	
	//保存手术分类
	obj.SaveOpCatButton_click=function()
	{
		var rcsCarPrvTp = obj.CarPrvTp.getSelectionModel().getSelections();
		var rcsOpCategory = obj.OpCategory.getSelectionModel().getSelections();
		
		if(rcsCarPrvTp.length!=1)
		{
			Ext.Msg.alert("提示","请在医护人员类型中选择一行");
			return;
		}
		
		var CTCPTRowId=rcsCarPrvTp[0].get("CTCPTRowId");
		
		var CATEGRowIdStr="";
		for(var i=0;i<rcsOpCategory.length;i++)
		{
			var CATEGRowId=rcsOpCategory[i].get("CATEGRowId");
			if(CATEGRowIdStr=="")
			{
				CATEGRowIdStr=CATEGRowId;
			}
			else
			{
				CATEGRowIdStr=CATEGRowIdStr+"^"+CATEGRowId;
			}
		}
		
		var ret = _DHCANOPAppSet.SavePrvTpOpCat(CTCPTRowId,CATEGRowIdStr);
		if(ret=="0")
		{
			Ext.Msg.alert("提示","保存手术分类成功");
		}
		else
		{
			Ext.Msg.alert("提示","保存手术分类失败");
		}
	}
	//双击医护人员类型列表项，关联的手术分类被选中
	obj.CarPrvTp_rowdblclick=function()
	{
		var rcsCarPrvTp = obj.CarPrvTp.getSelectionModel().getSelections();
		//alert(rcsCarPrvTp)
		var CTCPTRowId=rcsCarPrvTp[0].get("CTCPTRowId");
		obj.OpCategory.getSelectionModel().clearSelections();//清除所有选择
		
		var ret = _DHCANOPAppSet.GetPrvTpOpCat(CTCPTRowId);
		if(ret!="")
		{
			var CATEGRowIdArray=ret.split("^");
			var firstSelectRowIndex=-1;
			var rowIndex=0;
			for(var i=0; i<obj.OpCategoryStore.getCount(); i++)
		  	{
				var CATEGRowId=obj.OpCategoryStore.getAt(i).get("CATEGRowId");
			  	for(var j=0; j<CATEGRowIdArray.length; j++)
			  	{
				  	if(CATEGRowId==CATEGRowIdArray[j])
				  	{
					  	obj.OpCategory.getSelectionModel().selectRow(rowIndex, true);
					  	//第一个选中的行
					  	if(firstSelectRowIndex==-1)
					  	{
						  	firstSelectRowIndex=rowIndex;
						}
					}
				  	
				}
				rowIndex++;
		  	}
			//聚焦到第一个选中的行
			if(firstSelectRowIndex>=0)
			{
			  	//obj.OpCategory.getView().focusRow(firstSelectRowIndex);
			}
	
		}
	}
	

}﻿