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
			var dayOperNeedAn= appSet[14];	//�ռ��Ƿ���Ҫ����
			var oneOperName=appSet[15]			//20190102 yq
			//���������Ӧҽ����
			var AppArcim = AppArcimStr.split("^");
			//alert()
			obj.appArcim.setValue(AppArcim[1]);
			obj.appArcim.setRawValue(AppArcim[0]);
			//obj.LoadCombox(obj.appArcim,AppArcimStr)
			//��������ʱ������
			obj.appTime.setRawValue(AppTime);
			
			//������Ӧҽ���ע
			obj.arcimNote.setValue(arcimNote);
			
			//��ע�����Ӧ����
			obj.noteVar.setValue(NoteVar);
			
			//�Ƿ����Ĭ��������
			if(InsertDefRoom=="Y")
			{
				//obj.chkInsertDefRoom.setValue(true);
			}
			
			//�Ƿ�����Ϣ
			if(SendMessage=="Y")
			{
				obj.chkSendMessage.setValue(true);
			}
			
			//�Ƿ��Զ����������
			if(InsertLabInfo=="Y")
			{
				obj.chkInsertLabInfo.setValue(true);
			}
			//�Ƿ�ϲ��շ�+20161220+dyl
			if(chargeTogether=="Y")
			{
				obj.chkChargeTogether.setValue(true);
			}
			if(dayOperNeedAn=="Y")
			{
				obj.chkDayOperNeedAN.setValue(true);
			}
			//��ʩ�������ƺ�ʵʩ���������Ƿ�һ�� 20190102 yq
			if(oneOperName=="Y")
			{
				obj.chkOneOperName.setValue(true);
			}
			//סԺ����Ĭ��������
			var IPDefOpLoc=IPDefOpLocStr.split("^");
			obj.IPDefOpLoc.setValue(IPDefOpLoc[0]);
			obj.IPDefOpLoc.setRawValue(IPDefOpLoc[1]);
			
			//��������Ĭ��������
			var OPDefOpLoc=OPDefOpLocStr.split("^");
			obj.OPDefOpLoc.setValue(OPDefOpLoc[0]);
			obj.OPDefOpLoc.setRawValue(OPDefOpLoc[1]);
			
			//���˵��Ȱ�ȫ�� 20170811 YuanLin
			var PatSchedule=PatScheduleStr.split("^");
			obj.PatSchedule.setValue(PatSchedule[0]);
			obj.PatSchedule.setRawValue(PatSchedule[1]);
			
			//������ȫ��     20170811 YuanLin
			var NursingWorker=NursingWorkerStr.split("^");
			obj.NursingWorker.setValue(NursingWorker[0]);
			obj.NursingWorker.setRawValue(NursingWorker[1]);
			
			//��������˰�ȫ��
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

	//��������˰�ȫ��������ѡ��ʱ
	obj.DirAudit_select=function()
	{
		var DirAudit=obj.DirAudit.getRawValue();
		var DirAuditId=obj.DirAudit.getValue();
		obj.DirAudit.clearValue();
		
		//�ж��Ƿ��Ѿ����б���
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
	
	//��������˰�ȫ���б�˫��ʱɾ��
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
	
	
	//����������������
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
		//�ϲ��շ�+20161220+dyl
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
		
		//���˵��� 20170811 YuanLin
		var PatScheduleId = obj.PatSchedule.getValue();
		//����     20170811 YuanLin
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
		
		//��ʩʵʩ���������Ƿ�һ�� 20190102 yq
		var oneOperName=obj.chkOneOperName.getValue()?"Y":"N";
		
		var appSetStr=AppArcimId+"@"+AppTime+"@"+arcimNote+"@"+NoteVar+"@"+InsertDefRoom+"@"
		+SendMessage+"@"+InsertLabInfo+"@"+IPDefOpLocId+"@"+OPDefOpLocId+"@"+DirAuditList+"@"
		+"@"+chargeTogether+"@"+PatScheduleId+"@"+NursingWorkerId+"@"+dayoperneedan+"@"+oneOperName;
		
		//alert(appSetStr);
		//return;
		var ret = _DHCANOPAppSet.SaveAppSet(appSetStr);
		if(ret=="0")
		{
			Ext.Msg.alert("��ʾ","����ɹ�");
		}
		else
		{
			Ext.Msg.alert("��ʾ","����ʧ��");
		}
	};
	//
	obj.appArcim_select=function()
	{
	  	obj.appArcimStore.reload({});
	 }

	//�������ҽ������
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
				Ext.Msg.alert("��ʾ","���ʧ��");
			}
		}
		else
		{
			Ext.Msg.alert("��ʾ","��������ҽ����Ա������ѡ��һ��");
		}
	}
	
	//�ж�Ҫ��ӵ������Ƿ�������ҽ���������Ѵ���
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
	
	//ɾ������ҽ������
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
				Ext.Msg.alert("��ʾ","ɾ��ʧ��");
			}
		}
		else
		{
			Ext.Msg.alert("��ʾ","������������ҽ��������ѡ��һ��");
		}
	}
	
	//������������
	obj.SaveOpCatButton_click=function()
	{
		var rcsCarPrvTp = obj.CarPrvTp.getSelectionModel().getSelections();
		var rcsOpCategory = obj.OpCategory.getSelectionModel().getSelections();
		
		if(rcsCarPrvTp.length!=1)
		{
			Ext.Msg.alert("��ʾ","����ҽ����Ա������ѡ��һ��");
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
			Ext.Msg.alert("��ʾ","������������ɹ�");
		}
		else
		{
			Ext.Msg.alert("��ʾ","������������ʧ��");
		}
	}
	//˫��ҽ����Ա�����б���������������౻ѡ��
	obj.CarPrvTp_rowdblclick=function()
	{
		var rcsCarPrvTp = obj.CarPrvTp.getSelectionModel().getSelections();
		//alert(rcsCarPrvTp)
		var CTCPTRowId=rcsCarPrvTp[0].get("CTCPTRowId");
		obj.OpCategory.getSelectionModel().clearSelections();//�������ѡ��
		
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
					  	//��һ��ѡ�е���
					  	if(firstSelectRowIndex==-1)
					  	{
						  	firstSelectRowIndex=rowIndex;
						}
					}
				  	
				}
				rowIndex++;
		  	}
			//�۽�����һ��ѡ�е���
			if(firstSelectRowIndex>=0)
			{
			  	//obj.OpCategory.getView().focusRow(firstSelectRowIndex);
			}
	
		}
	}
	

}�1�3