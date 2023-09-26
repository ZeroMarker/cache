function InitViewport1Event(obj) {
	//�����෽��
	obj.ClsPatType = ExtTool.StaticServerObject("DHCMed.SPE.PatType");
	obj.ClsPatTypeSub = ExtTool.StaticServerObject("DHCMed.SPE.PatTypeSub");
	obj.ClsPatTypeSrv = ExtTool.StaticServerObject("DHCMed.SPEService.PatType");
	obj.ClsPatTypeSubSrv = ExtTool.StaticServerObject("DHCMed.SPEService.PatTypeSub");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate1.on("click",obj.btnUpdate1_click,obj);
		obj.btnDelete1.on("click",obj.btnDelete1_click,obj);
		obj.btnUpdate2.on("click",obj.btnUpdate2_click,obj);
		obj.btnDelete2.on("click",obj.btnDelete2_click,obj);
		obj.gridPatType.on("rowclick",obj.gridPatType_rowclick,obj);
		obj.gridPatTypeSub.on("rowclick",obj.gridPatTypeSub_rowclick,obj);
		obj.gridPatTypeStore.load({params : {start : 0,limit : 15}});
  	};
  	
	obj.ClearFormItem1 = function()
	{
		obj.RecRowID1 = "";
		Common_SetValue("PTCode","");
		Common_SetValue("PTDesc","");
		Common_SetValue("PTIsActive",false);
		Common_SetValue("PTResume","");
	}
	obj.ClearFormItem2 = function()
	{
		obj.RecRowID2 = "";
		Common_SetValue("PTSCode","");
		Common_SetValue("PTSDesc","");
		Common_SetValue("PTSIcon","");
		Common_SetValue("PTSAutoMark",false);
		Common_SetValue("PTSAutoCheck",false);
		Common_SetValue("PTSAutoClose",false);
		Common_SetValue("PTSIsActive",false);
		Common_SetValue("PTSResume","");
	}
	
	
	//���⻼�����͸���
	obj.btnUpdate1_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("PTCode");
		var Desc = Common_GetValue("PTDesc");
		var IsActive = Common_GetValue("PTIsActive");
		var Resume = Common_GetValue("PTResume");
		if (!Code) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		
		var IsCheck=obj.ClsPatType.CheckPTCode(Code,obj.RecRowID1);
	  	if(IsCheck==1)
	  	{
	  		errinfo = errinfo + "�������б���������Ŀ�ظ��������޸�!<br>";
	  	}
		
		if (errinfo) {
			ExtTool.alert("������ʾ",errinfo);
			return;
		}
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		var flg = obj.ClsPatType.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("������ʾ","�����ظ�!Error=" + flg);
			} else {
				ExtTool.alert("������ʾ","�������ݴ���!Error=" + flg);
			}
			return;
		}
		obj.ClearFormItem1();
		Common_LoadCurrPage("gridPatType");
	}
	//���⻼������ɾ��
	obj.btnDelete1_click = function()
	{
		if (obj.RecRowID1!=""){
			Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
				if(btn=="yes"){
					var flg = obj.ClsPatType.DeleteById(obj.RecRowID1);
					if (parseInt(flg) < 0) {
						ExtTool.alert("������ʾ","ɾ�����ݴ���!Error=" + flg);
					} else {
						obj.ClearFormItem2();
						Common_LoadCurrPage("gridPatTypeSub");
						obj.ClearFormItem1();
						Common_LoadCurrPage("gridPatType");
					}
				}
			});
		} else {
			ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
		}
	}
	//���⻼���ӷ������
	obj.btnUpdate2_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("PTSCode");
		var Desc = Common_GetValue("PTSDesc");
		var Icon = Common_GetValue("PTSIcon");
		var AutoMark = Common_GetValue("PTSAutoMark");
		var AutoCheck = Common_GetValue("PTSAutoCheck");
		var AutoClose = Common_GetValue("PTSAutoClose");
		var IsActive = Common_GetValue("PTSIsActive");
		var Resume = Common_GetValue("PTSResume");
		if (!Code) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		if (!Icon) {
			errinfo = errinfo + "ͼ�궨��Ϊ��!<br>";
		}
		//�������Ƿ��ظ�
		var SubID = obj.RecRowID1 + "||" + obj.RecRowID2;
		var IsCheck = obj.ClsPatTypeSub.CheckPTSCode(Code,SubID);
	  	if(IsCheck==1)
	  	{
	  		errinfo = errinfo + "�������б���������Ŀ�ظ��������޸�!<br>";
	  	}
		if (errinfo) {
			ExtTool.alert("������ʾ",errinfo);
			return;
		}
		var inputStr = obj.RecRowID1;
		inputStr = inputStr + CHR_1 + obj.RecRowID2;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Icon;
		inputStr = inputStr + CHR_1 + (AutoMark ? '1' : '0');
		inputStr = inputStr + CHR_1 + (AutoCheck ? '1' : '0');
		inputStr = inputStr + CHR_1 + (AutoClose ? '1' : '0');
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		var flg = obj.ClsPatTypeSubSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("������ʾ","�����ظ�!Error=" + flg);
			} else {
				ExtTool.alert("������ʾ","�������ݴ���!Error=" + flg);
			}
			return;
		}
		obj.ClearFormItem2();
		Common_LoadCurrPage("gridPatTypeSub");
	}
	//���⻼���ӷ���ɾ��
	obj.btnDelete2_click = function()
	{
		if ((obj.RecRowID1!="")&&(obj.RecRowID2!="")){
			Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
				if(btn=="yes"){
					var flg = obj.ClsPatTypeSub.DeleteById(obj.RecRowID1+"||"+obj.RecRowID2);
					if (parseInt(flg) < 0) {
						ExtTool.alert("������ʾ","ɾ�����ݴ���!Error=" + flg);
					} else {
						obj.ClearFormItem2();
						Common_LoadCurrPage("gridPatTypeSub");
					}
				}
			});
		} else {
			ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
		}
	}
	
	obj.gridPatType_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridPatType.getStore().getAt(index);
		if (objRec.get("PTID") == obj.RecRowID1) {
			obj.ClearFormItem1();
			obj.RecRowID1="";
		} else {
			obj.RecRowID1 = objRec.get("PTID");
			Common_SetValue("PTCode",objRec.get("PTCode"));
			Common_SetValue("PTDesc",objRec.get("PTDesc"));
			Common_SetValue("PTIsActive",(objRec.get("PTIsActiveDesc")=='��'));
			Common_SetValue("PTResume",objRec.get("PTResume"));
			obj.gridPatTypeSubStore.load({});
			obj.ClearFormItem2();
		}
	}
	obj.gridPatTypeSub_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridPatTypeSub.getStore().getAt(index);
		if (objRec.get("PTSID") == obj.RecRowID2) {
			obj.ClearFormItem2();
			obj.RecRowID2="";
		} else {
			obj.RecRowID2 = objRec.get("PTSID");
			Common_SetValue("PTSCode",objRec.get("PTSCode"));
			Common_SetValue("PTSDesc",objRec.get("PTSDesc"));
			Common_SetValue("PTSIcon",objRec.get("PTSIcon"));
			Common_SetValue("PTSAutoMark",(objRec.get("PTSAutoMarkDesc")=='��'));
			Common_SetValue("PTSAutoCheck",(objRec.get("PTSAutoCheckDesc")=='��'));
			Common_SetValue("PTSAutoClose",(objRec.get("PTSAutoCloseDesc")=='��'));
			Common_SetValue("PTSIsActive",(objRec.get("PTSIsActiveDesc")=='��'));
			Common_SetValue("PTSResume",objRec.get("PTSResume"));
		}
	}
}

