
function InitViewport1Event(obj) {
	var CHR_1 = String.fromCharCode(1);
	var objSApp = ExtTool.StaticServerObject("DHCMed.CCService.SubjectAppSrv");
	var objSub = ExtTool.StaticServerObject("DHCMed.CC.SubjectApp");
	obj.LoadEvent = function()
  {};
	obj.BtnNew_click = function()
	{
		var objSA = new InitSAWindow();
		objSA.SAWindow.show();
	};
	obj.BtnEdit_click = function()
	{
		var objSA = new InitSAWindow();
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
			if(selectObj.get("ID")<1) return;
			objSA.SARowid.setValue(selectObj.get("ID"));
			var ret=objSApp.GetSubAppInfoByID(objSA.SARowid.getValue());
			if(ret!="")
			{
				str=ret.split("^");
				objSA.SACode.setValue(str[1]);
				objSA.SADesc.setValue(str[2]);
				ExtTool.AddComboItem (objSA.SASubjectDr, str[3].split(CHR_1)[1], str[3].split(CHR_1)[0]);
				objSA.SAShowScore.setValue(str[4]);
				ExtTool.AddComboItem(objSA.SAShowDr, str[5].split(CHR_1)[1], str[5].split(CHR_1)[0]);
				objSA.SAResume.setValue(str[6]);
				objSA.SAWindow.show();
			}
		}
		else
		{
			ExtTool.alert("��ʾ","����ѡ��һ���������!");		
			return;
		}
	};
	obj.BtnDelete_click = function()
	{
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
	 	if(!selectObj)
	 	{
	 		ExtTool.alert("��ʾ","����ѡ��һ�У�");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
                	
			var ret = objSub.DeleteById(selectObj.get("ID"));
			if(ret==0)
			{
				obj.SAGridPanelStore.removeAll();
				obj.SAGridPanelStore.load();
				return;
			}
	 		if(ret<0)
	 		{
	 			ExtTool.alert("��ʾ","ɾ��ʧ��!");
	 			return;	
	 		}
		});
	};
	obj.ColsBtnUpdate_click = function()
	{
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
			var objWinEdit = new InitSubAppCWindow();
			objWinEdit.sSARowid.setValue(selectObj.get("ID"));
			if(selectObj.get("ID")<1) return;
			objWinEdit.SACEditGridPanelStore.load();
			objWinEdit.SubAppCWindow.show();
		}
		else
		{
			ExtTool.alert("��ʾ","����ѡ��һ���������!");		
			return;
		}
	};
	obj.SubBtnUpdate_click = function()
	{
		var selectObj = obj.SAGridPanel.getSelectionModel().getSelected();
		if(selectObj)
		{
			var objSAS = new InitSASWindow();
			objSAS.SAID.setValue(selectObj.get("ID"));
			objSAS.SASGridPanelStore.load();
			objSAS.SASWindow.show();
		}
		else
		{
			ExtTool.alert("��ʾ","����ѡ��һ���������!");		
			return;
		}
	};
}

//***********************�������Ӧ��ά��*****************************

function InitSAWindowEvent(obj) {
	var parent=objControlArry['Viewport1'];
	obj.LoadEvent = function()
  {};
	obj.SABtnSave_click = function()
	{
		var LabStr="";
		if(ValidateData(obj.SACode,"���벻��Ϊ��!")==-1) return;
		if(ValidateData(obj.SADesc,"��������Ϊ��!")==-1) return;
		if(ValidateData(obj.SASubjectDr,"������ⲻ��Ϊ��!")==-1) return;
		if(ValidateData(obj.SAShowDr,"չ��ģʽ����Ϊ��!")==-1) return;
		
		if(obj.SASubjectDr.getValue()==obj.SASubjectDr.getRawValue())
		{
			ExtTool.alert("��ʾ","��ѡ��һ���������!");	
			return;
		}
		if(obj.SAShowDr.getValue()==obj.SAShowDr.getRawValue())
		{
			ExtTool.alert("��ʾ","��ѡ��һ��չ��ģʽ!");	
			return;
		}
		var objLab = ExtTool.StaticServerObject("DHCMed.CC.SubjectApp");
		var tmp = obj.SARowid.getValue();
		tmp += "^" + obj.SACode.getValue();
		tmp += "^" + obj.SADesc.getValue();
		tmp += "^" + obj.SASubjectDr.getValue();
		tmp += "^" + obj.SAShowScore.getValue();
		tmp += "^" + obj.SAShowDr.getValue();
		tmp += "^" + obj.SAResume.getValue();
		var ret=objLab.Update(tmp);
		if(ret>0) 
		{
			obj.SARowid.setValue("");
			obj.SACode.setValue("");
			obj.SADesc.setValue("");
			obj.SASubjectDr.setValue("");
			
			obj.SAShowScore.setValue("");
			obj.SAShowDr.setValue("");
			obj.SAResume.setValue("");
			
			ExtTool.alert("��ʾ","����ɹ�!");
			obj.SAWindow.close();
			parent.SAGridPanelStore.load();
		}
		else ExtTool.alert("��ʾ","����ʧ��!"); 
	};
	obj.SABtnExit_click = function()
	{
		obj.SAWindow.close();
	};
}

//*****************�����ĿӦ���б�����ά��***************************

function InitSubAppCWindowEvent(obj) {
	var CHR_1 = String.fromCharCode(1);
	var objSApp = ExtTool.StaticServerObject("DHCMed.CCService.SubjectAppSrv");
	obj.LoadEvent = function()
  {};
  	obj.SACBtnSave_click = function()
	{
		var TotalStr="";
		if(obj.SACEditGridPanelStore.getCount()==0) return;
		for(var i = 0; i < obj.SACEditGridPanelStore.getCount(); i ++)  //�����������Ӧ���б�
    	{
    		var str="",SACIsHide="",SACIsSort="";
    		var objData = obj.SACEditGridPanelStore.getAt(i);
    		str = objData.get('SACParref');	
    		str += "^"+ objData.get('SACName');
    		str += "^"+ objData.get('SACDesc');
    		if(objData.get('SACIsHide')=="Y") SACIsHide=1;
    		else SACIsHide=0;
    		str += "^"+ SACIsHide;
    		str += "^"+ objData.get('SACWidth');
    		if(objData.get('SACIsSort')=="Y") SACIsSort=1;
    		else SACIsSort=0;
    		str += "^"+ SACIsSort;
    		str += "^"+ objData.get('SACIndex');
    		
    		if(TotalStr=="") TotalStr=str;
    		else TotalStr += CHR_1 + str;
    	}
    	var ret=objSApp.InsertDataToSubAppCols(TotalStr);
    	if(ret==1)
    	{
    		ExtTool.alert("��ʾ","����ɹ�!");
    		obj.SubAppCWindow.close();
    		return;
    	}
    	else 
    	{
    		ExtTool.alert("��ʾ","����ʧ��!");
    		return;	
    	}
	};
	obj.SACBtnExit_click = function()
	{
		obj.SubAppCWindow.close();
	};
}

//*********************�������Ӧ�ü����Ŀά��***********************

function InitSASWindowEvent(obj)
{	
	var objSApp = ExtTool.StaticServerObject("DHCMed.CC.SubjectAppSub");
	obj.LoadEvent = function(args)
	{
	}
	obj.SASBtnSave_click = function()
	{
		if(ValidateData(obj.SASItemDr,"�����Ŀ����Ϊ��!")==-1) return;
		if(ValidateData(obj.SASItemType,"��Ŀ���Ͳ���Ϊ��!")==-1) return;
		
		if(obj.SASItemDr.getValue()==obj.SASItemDr.getRawValue())
		{
			ExtTool.alert("��ʾ","��ѡ��һ�������Ŀ!");	
			return;
		}
		if(obj.SASItemType.getValue()==obj.SASItemType.getRawValue())
		{
			ExtTool.alert("��ʾ","��ѡ��һ����Ŀ����!");	
			return;
		}
		
		var tmp = obj.SASRowid.getValue();
		if(tmp=="") tmp=obj.SAID.getValue()+"||";
		tmp += "^" + obj.SASItemDr.getValue();
		tmp += "^" + obj.SASItemType.getValue();
		tmp += "^" + obj.SASItemScore.getValue();
		
		if(obj.SASLocDr.getRawValue()=="") tmp += "^";
		else if(obj.SASLocDr.getValue()==obj.SASLocDr.getRawValue()) tmp += "^";
		else tmp += "^"+ obj.SASLocDr.getValue();
		
		if(obj.SASGroupDr.getRawValue()=="") tmp += "^";
		else if(obj.SASGroupDr.getValue()==obj.SASGroupDr.getRawValue()) tmp += "^";
		else tmp += "^" + obj.SASGroupDr.getValue();
		
		tmp += "^" + obj.SASResume.getValue();

		var ret=objSApp.Update(tmp);
		if(ret<0) ExtTool.alert("��ʾ","����ʧ��!"); 
		else{
			RemoveSASData(obj);
			//ExtTool.alert("��ʾ","����ɹ�!");
			obj.SASGridPanelStore.load();
			return;
		}
	};
	obj.SASBtnDelete_click = function()
	{
		var selectObj = obj.SASGridPanel.getSelectionModel().getSelected();
	 	if(!selectObj)
	 	{
	 		ExtTool.alert("��ʾ","����ѡ��һ�У�");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
            var ID=selectObj.get("SASRowid");
			var ret = objSApp.DeleteById(ID);
			if(ret==0)
			{
				RemoveSASData(obj);
				obj.SASGridPanelStore.removeAll();
				obj.SASGridPanelStore.load();
				return;
			}
	 		if(ret<0)
	 		{
	 			ExtTool.alert("��ʾ","ɾ��ʧ��!");
	 			return;	
	 		}
		});
	};
	obj.SASBtnExit_click = function()
	{
		obj.SASWindow.close();
	};
	obj.SASGridPanel_rowclick = function()
	{
		var selectObj = obj.SASGridPanel.getSelectionModel().getSelected();
		if(selectObj.get("SASRowid")!=obj.SASRowid.getValue())
		{
			obj.SASRowid.setValue(selectObj.get("SASRowid"));
			ExtTool.AddComboItem(obj.SASItemDr,selectObj.get("SASItemDrDesc"),selectObj.get("SASItemDr"));
			ExtTool.AddComboItem(obj.SASItemType,selectObj.get("SASItemTypeDesc"),selectObj.get("SASItemType"));
			obj.SASItemScore.setValue(selectObj.get("SASItemScore"));
			ExtTool.AddComboItem(obj.SASLocDr,selectObj.get("SASLocDrDesc"),selectObj.get("SASLocDr"));
			ExtTool.AddComboItem(obj.SASGroupDr,selectObj.get("SASGroupDrDesc"),selectObj.get("SASGroupDr"));
			obj.SASResume.setValue(selectObj.get("SASResume"));
		}
		else{
			RemoveSASData(obj);
			return;
		}
	};
}

// 
function RemoveSASData(obj)
{
	obj.SASRowid.setValue("");
	obj.SASLocDr.setRawValue("");
	obj.SASItemDr.setValue("");
	obj.SASItemType.setValue("");
	obj.SASItemScore.setValue("");
	obj.SASGroupDr.setValue("");
	obj.SASResume.setValue("");
	obj.SASItemDrStore.removeAll();
	obj.SASItemTypeStore.removeAll();
	obj.SASLocDrStore.removeAll();
	obj.SASGroupDrStore.removeAll();
	obj.SASItemDrStore.load();
	obj.SASItemTypeStore.load();
	obj.SASLocDrStore.load();
	obj.SASGroupDrStore.load();
}
function ValidateData(tObj,str)
{
	if(tObj.getValue()=="")
	{
		ExtTool.alert("��ʾ",str);
		return -1;
	}
	else return 1;
}
