
function InitviewScreenEvent(obj) {
	
	obj.objCurrRec = null;
	obj.objAppendixManage = ExtTool.StaticServerObject("DHCMed.EPD.AppendixCard");
	obj.intCurrRowIndex = -1;
	
	obj.LoadEvent = function(args)
    {
    };
    

    
    obj.DisplayInfo = function(objAppendix)
    {
    	if(objAppendix != null)
    	{
	    	obj.txtCode.setValue(objAppendix.MACCode);
	    	obj.txtDesc.setValue(objAppendix.MACDesc);
	    	obj.chkIsActive.setValue((objAppendix.MACActive == "Y"));
	    	obj.txtType.setValue(objAppendix.MACType);
	    	obj.dtActiveDate.setValue(objAppendix.MACDate);
	    	obj.txtResumeText.setValue(objAppendix.MACDemo);
    	}
    	else
    	{
 	    	obj.txtCode.setValue("");
	    	obj.txtDesc.setValue("");
	    	obj.chkIsActive.setValue(true);
	    	obj.txtType.setValue("");
	    	obj.dtActiveDate.setValue(new Date());
	    	obj.txtResumeText.setValue("");  
    	}
    	obj.objCurrRec = objAppendix;
    }
    
    
    obj.SaveToString = function()
    {
    	var strRet = "";
    	if(obj.intCurrRowIndex != -1)
    	{
    		strRet += obj.objCurrRec.RowID;
    	}
    	strRet += "^";
    	strRet += obj.txtCode.getValue() + "^";
    	strRet += obj.txtDesc.getValue() + "^";
    	strRet += (obj.chkIsActive.getValue() ? "Y" : "N") + "^";
    	strRet += obj.txtType.getValue() + "^";
    	strRet += obj.dtActiveDate.getRawValue() + "^";
    	strRet += obj.txtResumeText.getValue() + "^";
    	return strRet;
    }
    
    obj.gridResult_rowclick = function(objGrid, rowIndex, eventObj)
    {
    	var objRec = objGrid.getStore().getAt(rowIndex);
    	if((obj.intCurrRowIndex != rowIndex) && (rowIndex != -1))
    	{
    		var objAppendix = obj.objAppendixManage.GetObjById(objRec.get("ID"));
    		obj.intCurrRowIndex = rowIndex;	
    		obj.DisplayInfo(objAppendix);
    	}
    	else
    	{
    		obj.intCurrRowIndex = -1;
    		obj.DisplayInfo(null);
    	}
    }
    
    obj.ValidateConents = function()
    {
    	if(obj.txtCode.getValue() == "")
    	{
    		ExtTool.alert("��ʾ", "��������룡", Ext.MessageBox.INFO);
    		return false;
    	}
    	if(obj.txtDesc.getValue() == "")
    	{
    		ExtTool.alert("��ʾ", "������������", Ext.MessageBox.INFO);
    		return false;
    	}
    	if(obj.txtType.getValue() == "")
    	{
    		ExtTool.alert("��ʾ", "���������", Ext.MessageBox.INFO);
    		return false;
    	}    	
    	return true;
    }
    
	obj.btnSave_click = function()
	{
		if(!obj.ValidateConents())
			return;
		var strData = obj.SaveToString();
		try {
			var strResult = obj.objAppendixManage.Update(strData, "^");
			if(strResult > 0){
				ExtTool.alert("��ʾ", "����ɹ���" , Ext.MessageBox.INFO);
				obj.gridResultStore.load({});
			}else{
				if(strResult==-1){
					ExtTool.alert("��ʾ", "�����ظ�����������д��");
				}else{
					ExtTool.alert("��ʾ", "����ʧ�ܣ�����ֵ��" + strResult , Ext.MessageBox.ERROR);
				}
			}
		}catch(e){
			ExtTool.alert("��ʾ", e.description, Ext.MessageBox.ERROR);
		}
	};
	
	obj.gridResult_rowdblclick  = function(objGrid, rowIndex)
	{
		var objRec = obj.gridResultStore.getAt(rowIndex);
		var objEdit = new InitwinItems(objRec.get("ID"));
		objEdit.winItems.show();
	}
}


function InitwinItemsEvent(obj)
{	
	obj.AppendixID = "";
	obj.objAppendixItemManage = ExtTool.StaticServerObject("DHCMed.EPD.AppendixCardSub");
	
	obj.LoadEvent = function(args)
	{
		obj.AppendixID = args[0];
		
		obj.gridResultStore.load({
			params : {
				ClassName : 'DHCMed.EPDService.AppendixCardSrv',
			    QueryName : 'QryAppendixCartItem',
				Arg1 : obj.AppendixID,
				Arg2 : '', //Modified By LiYang 2012-03-13 FixBug:34 ��Ⱦ������-��Ⱦ������ά��-ʧЧ�Ĵ�Ⱦ��������Ŀ���Զ�ɾ��
				ArgCnt : 2
			}
		});
		
	}
	
	//Modified By LiYang 2012-03-13 FixBug:39 ��Ⱦ������-��Ⱦ������ά��-��Ⱦ��������Ŀ-�������ֵ䡿�ֶ����ú��޷����
	obj.objComboDicName.on("expand", 
  	function()
  	{
  		obj.objComboDicName.clearValue();
  		var objCurrRec = obj.gridResult.getSelectionModel().getSelected() ;
  		if(objCurrRec == null)
  			return;
  		objCurrRec.set("HiddenValueDicName", "");
  		objCurrRec.set("DicName","");
  	}
  );
	
	
	
	obj.btnSave_click = function()
	{
		var boolIsPassed = false;
		for(var i = 0; i < obj.gridResultStore.getCount(); i ++) {
			boolIsPassed = obj.ValidateContents(i);
			if(boolIsPassed == false) {
				break;
			}
		}
		if (boolIsPassed) {
			var strTmp = "";
			var objRec = null;
			for(var i = 0; i < obj.gridResultStore.getCount(); i ++) {
				objRec = obj.gridResultStore.getAt(i);
				if (!objRec.dirty) continue;
				var strRowID = objRec.get("ID");
				strTmp = objRec.get("ID") + "^";
				strTmp += obj.AppendixID + "^";
				strTmp += objRec.get("Name") + "^";
				strTmp += objRec.get("IsActive") + "^";
				strTmp += objRec.get("HiddenValueDataType") + "^";
				strTmp += objRec.get("HiddenValueDicName") + "^";
				strTmp += objRec.get("ValExp") + "^";
				strTmp += objRec.get("IsNecess") + "^";
				var ret = obj.objAppendixItemManage.Update(strTmp, "^");
				objRec.commit();
			}
			ExtTool.alert("��ʾ", "����ɹ���", Ext.MessageBox.INFO);
		}
		//obj.gridResultStore.commitAll(true);
	};
	
	obj.btnAdd_click = function()
	{
		var objRec = new Ext.data.Record({
			ID : "",
			Name : "a",
			IsActive : "Y",
			DataType : "",
			DicName : "",
			HiddenValueDataType : "",
			HiddenValueDicName : "",
			ValExp:""  //fix bug 108574 ά����Ⱦ��������ĿĬ��ֵ���ʽ��ʾΪundefined
		});
		objRec.set("Name", "");
		obj.gridResultStore.add([objRec]);
		
	}
	
	obj.btnCancel_click = function()
	{
		obj.winItems.close();
	};
	
	obj.gridResult_beforeedit = function(objEvent)
	{
		
		
	};
	
	obj.ValidateContents = function(intRow)
	{
		var objRec = obj.gridResultStore.getAt(intRow);
		if(!objRec.dirty)
			return true;
		if(objRec.get("Name") == "")
		{
			ExtTool.alert("��ʾ", "��" + (intRow + 1) + "�����ݣ���������Ŀ���ƣ�", Ext.MessageBox.INFO);
			return false;
		}
		if (objRec.get("DataType") == "")
		{
			ExtTool.alert("��ʾ", "��" + (intRow + 1) + "�����ݣ���ѡ���������ͣ�", Ext.MessageBox.INFO);
			return false;			
		}
		if((objRec.get("DataType") == "4") && (objRec.get("HiddenValueDicName") == ""))
		{
			ExtTool.alert("��ʾ", "��" + (intRow + 1) + "�����ݣ���ѡ�����ֵ����ƣ�", Ext.MessageBox.INFO);
			return false;
		}
		return true;
	}
	
	obj.gridResult_afteredit = function(objEvent)
	{
		var objCurrRec = objEvent.record;
		switch(objEvent.column)
		{
			case 2:
				objCurrRec.set("IsActive", (objEvent.value ? "Y" : "N"));
				break;
			case 3:
				var objStore = obj.objComboDataType.getStore();
				var index = objStore.findExact("Code", obj.objComboDataType.getValue());
				var objRec = objStore.getAt(index);
				objCurrRec.set("DataType", objRec.get("Description"));
				objCurrRec.set("HiddenValueDataType", objRec.get("Code"));
				break;
			case 4:
				var objStore = obj.objComboDicName.getStore();
				var index = objStore.findExact("Code", obj.objComboDicName.getValue());
				if(index >= 0) //Modified By LiYang 2012-03-13 FixBug:39 ��Ⱦ������ά��-��Ⱦ��������Ŀ-�������ֵ䡿�ֶ����ú��޷����
				{
					var objRec = objStore.getAt(index);
					objCurrRec.set("DicName", objRec.get("Description"));
					objCurrRec.set("HiddenValueDicName", objRec.get("Code"));			
				}
				else
				{
					objCurrRec.set("DicName", "");
					objCurrRec.set("HiddenValueDicName", "");						
				}
				break;
			case 5:
				objCurrRec.set("IsNecess", (objEvent.value ? "Y" : "N"));
				break;
		}
	};
	
	
/*winItems��������ռλ��*/
}
