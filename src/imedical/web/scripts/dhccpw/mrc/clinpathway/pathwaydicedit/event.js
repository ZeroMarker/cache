function InitfrmPathWayDicEditEvent(obj)
{
	obj.currSelRowIndex = -1; //Add By LiYang 2011-05-25 ���浱ǰ�к�
	var CPWDID="";            //add by wuqk 2011-11-17
	
	obj.LoadEvent = function(args)
	{
		//obj.btnAdd.on("click", obj.btnAdd_click, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.gridResult.on("rowclick",obj.gridResult_rowclick, obj);
		obj.cboPathType.on("expand", obj.cboPathType_OnExpand, obj);
		
		// add by wuqk 2011-11-17 for ·�����ÿ���
		obj.btnLocList.on("click", obj.btnLocList_click, obj);
	}
	
	obj.cboPathType_OnExpand = function()
	{
		obj.cboPathTypeStore.load({});
	}
	
	//Add By LiYang 2011-05-22 FixBug:50 �ٴ�·��ά��--�����ֵ�ά��-·���ֵ�ά��-���������հ׵��ٴ�·��
	obj.ValidateContents = function()
	{
		if(obj.txtCode.getValue() == "")
		{
			ExtTool.alert("��ʾ", "��������룡");
			return false;	
		}
		if(obj.txtDesc.getValue() == "")
		{
			ExtTool.alert("��ʾ", "������������");
			return false;	
		}
		//******* Add by zhaoyu 2013-04-26 247��248 �ٴ�·������ ·�����͡���Ч����Ϊ����
		if(obj.cboPathType.getValue() == ""){
			ExtTool.alert("��ʾ", "������·�����ͣ�");
			return false;
		}
		if(obj.dtFrom.getValue() == ""){
			ExtTool.alert("��ʾ", "��������Ч���ڣ�");
			return false;
		}
		//*******	
		return true;
	}
	
	
	obj.SaveToString = function(AddNew)
	{
		var objSel = ExtTool.GetGridSelectedData(obj.gridResult);
		var str = "";
		if((objSel != null)&&(AddNew == false)){
			str = objSel.get("ID");
		}
		str += "^";
		str += obj.txtCode.getValue() + "^";
		str += obj.txtDesc.getValue() + "^";
		str += obj.cboPathType.getValue() + "^";
		str += (obj.chkIsActive.getValue() ? "Y" : "N") + "^";
		str += obj.dtFrom.getRawValue() + "^";
		str += obj.dtTo.getRawValue() + "^";
		str += "";
		str += "^" + (obj.chkIsOpCPW.getValue() ? "Y" : "N");
		/***************************************
		�޸��ֵ�ʱ�������޸ĵ�ǰ�汾
		if((objSel != null)&&(AddNew == false)){
			str += objSel.get("CurrVersion");
		}else{
			str += "";
		}
		****************************************/
		return str;
	}
	
	/*
	obj.btnAdd_click = function()
	{
		//Add By LiYang 2011-05-22 FixBug:50 �ٴ�·��ά��--�����ֵ�ά��-·���ֵ�ά��-���������հ׵��ٴ�·��
		if (!obj.ValidateContents())
			return;
		try
		{
			var strArg = obj.SaveToString(true);
			//alert(strArg);
			var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
			//Add By LiYang 2011-02-26 У���ٴ�·���ֵ��Ƿ��ظ����ж�Code��
			if(DHCMRCClinPathWaysDic.IsClinPathWayDicExists(obj.txtCode.getValue(), obj.txtDesc.getValue()) == "1")
			{
				ExtTool.alert("��ʾ", "����ٴ�·���Ѿ������ˣ�");
				return;
			}
			var ret = DHCMRCClinPathWaysDic.Update(strArg);
			obj.gridResultStore.load({});	
			//ExtTool.alert("��ʾ", "����ɹ���");
		}catch(e)
		{
			ExtTool.alert("����", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}
		
	};
	*/
	obj.btnSave_click = function()
	{
		if (!obj.ValidateContents())
			return;
		try
		{
			//Add By NiuCaicai 2011-07-19 FixBug:91 �ٴ�·��ά��--������Ϣά��-·���ֵ�ά��-��Чʱ����Դ��ڷ�ֹʱ��
			//.......................................................................................
			var DateFrom = Date.parse(obj.dtFrom.getValue());
			var DateTo = Date.parse(obj.dtTo.getValue());
			if ((DateTo) && (DateFrom>DateTo)){
				ExtTool.alert("��ʾ", "��Ч���ڲ��ܴ��ڷ�ֹ���ڣ�����ʧ�ܣ�!");
				return;
			}
			//.......................................................................................
			if(obj.currSelRowIndex == -1)
			{
				//Add By LiYang 2011-02-26 У���ٴ�·���ֵ��Ƿ��ظ����ж�Code��
				//Add By LiYang 2011-05-22 FixBug:50 �ٴ�·��ά��--�����ֵ�ά��-·���ֵ�ά��-���������հ׵��ٴ�·��
				//Update By NiuCaicai 2011-07-21 FixBug:90 �ٴ�·��ά��--������Ϣά��-�ٴ�·���ֵ�-ͨ���޸��Ѵ��ڵ�·����¼���ظ������ͬ���ٴ�·��
				/*
				var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
				if(DHCMRCClinPathWaysDic.IsClinPathWayDicExists(obj.txtCode.getValue(), obj.txtDesc.getValue()) == "1")
			    {
					ExtTool.alert("��ʾ", "����ٴ�·���Ѿ������ˣ�");
					return;
			    }	
				*/				
				var strArg = obj.SaveToString(true);
			}else
			{
				var strArg = obj.SaveToString(false);
			}			
			//alert(strArg);
			var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
			//******** Add by zhaoyu 2013-04-26 �ٴ�·������-������¼�����롢�����ͽ����е�ĳ��¼�ظ������޸�ԭ����¼��Ϣ 244
			var CheckCodeFlg = DHCMRCClinPathWaysDic.CheckCPWDicCode(strArg);
			if (CheckCodeFlg == "1"){
                		ExtTool.alert("��ʾ", "�����ظ���");
				return;
			}
			//****************************************************
			//Update By NiuCaicai 2011-07-22 FixBug:90 �ٴ�·��ά��--������Ϣά��-�ٴ�·���ֵ�-ͨ���޸��Ѵ��ڵ�·����¼���ظ������ͬ���ٴ�·��
			//.................................................................
			var newret = DHCMRCClinPathWaysDic.Update(strArg,obj.txtCode.getValue(), obj.txtDesc.getValue());
			if(newret == "0")
			{
                ExtTool.alert("��ʾ", "���ٴ�·���Ѵ��ڣ�");
				return;
			}
			obj.gridResultStore.load({			
				//params : {
				//		start : 0,
				//		limit : 20
				//	}
			});	
			//.................................................................	
			window.parent.RefreshPathVerFn();             //add by wuqk 2011-07-26 bug 116
			//ExtTool.alert("��ʾ", "����ɹ���");
		}catch(e)
		{
			ExtTool.alert("����", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}		
	};
	
	obj.gridResult_rowclick = function(grid, rowIndex)
	{
		if(rowIndex == obj.currSelRowIndex)
		{
			obj.txtCode.setValue("");
			obj.txtDesc.setValue("");
			obj.chkIsActive.setValue(true);
			obj.chkIsOpCPW.setValue(false);
			obj.cboPathType.clearValue() ;
			obj.dtFrom.setRawValue("");
			obj.dtTo.setRawValue("");
			obj.currSelRowIndex = -1;
			CPWDID="";
			return;
		}
		else
		{
			obj.currSelRowIndex = rowIndex;
		}
		var objSel = ExtTool.GetGridSelectedData(obj.gridResult);
		if(objSel == null) return;
		try{
			CPWDID=objSel.get("ID")        
			var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
			var ret = DHCMRCClinPathWaysDic.GetStringById(CPWDID);
			if(ret != "")
			{
				var arryFields = ret.split("^");
				obj.txtCode.setValue(arryFields[1]);
				obj.txtDesc.setValue(arryFields[2]);
				obj.cboPathType.setRawValue("");
				obj.cboPathTypeStore.load(
					{
						callback : function(){
							obj.cboPathType.setValue(arryFields[3]);
						}
					});
				obj.chkIsActive.setValue(arryFields[4] == "Yes");
				obj.chkIsOpCPW.setValue(arryFields[9] == "Yes");
				obj.dtFrom.setRawValue(arryFields[5]);
				obj.dtTo.setRawValue(arryFields[6]);
			}
		}catch(e){
			ExtTool.alert("����", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}
	}
	
	//add by wuqk 2011-11-17
	obj.btnLocList_click = function(){
		if (CPWDID=="") {ExtTool.alert("��ʾ", "����ѡ��·��!");return;}
		var winLocList=new InitWinLocList(CPWDID,obj.txtDesc.getValue());
		winLocList.winScreen.show();
	}
}
