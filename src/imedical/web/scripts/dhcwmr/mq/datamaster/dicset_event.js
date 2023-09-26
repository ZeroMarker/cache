function InitDicSetEvent(obj) 
{
	obj.LoadEvent = function(args){
		obj.btnSave.on('click',obj.btnSave_onclick,obj);
		var objDicSet = ExtTool.RunServerMethod('DHCWMR.MQ.ItemDic','GetObjByItem',obj.ItemID);
		if (objDicSet)
		{
			Common_SetValue('txtQryClassName',objDicSet.IDQryClassName);
			Common_SetValue('txtQryMethodName',objDicSet.IDQryMethodName);
			Common_SetValue('txtArgs',objDicSet.IDArgs);
			Common_SetValue('txtDisCode',objDicSet.IDDisCode);
			Common_SetValue('txtDisDesc',objDicSet.IDDisDesc);
			Common_SetValue('txtChooseValue',objDicSet.IDChooseValue);
			Common_SetValue('chkIsLoadAll',objDicSet.IsLoadAll);
			Common_SetValue('chkIsActive',objDicSet.IsActive);
		}
	}

	obj.btnSave_onclick = function()
	{
		var err='';
		var QryClassName = Common_GetValue('txtQryClassName');
		var QryMethodName = Common_GetValue('txtQryMethodName');
		var Args = Common_GetValue('txtArgs');
		var DisCode = Common_GetValue('txtDisCode');
		var DisDesc = Common_GetValue('txtDisDesc');
		var ChooseValue = Common_GetValue('txtChooseValue');
		var IsLoadAll = Common_GetValue('chkIsLoadAll');
		var IsActive = Common_GetValue('chkIsActive');
		if (QryClassName=='') err +='检索类名、';
		if (QryMethodName=='') err +='检索Qry名、';
		if (DisCode=='') err +='代码、';
		if (DisDesc=='') err +='描述、';
		if (ChooseValue=='') err +='选择后值、';
		if (err)
		{
			ExtTool.alert('提示',err+'为空！');
			return;
		}
		var inputStr = '';
		inputStr += CHR_1 + obj.ItemID;
		inputStr += CHR_1 + QryClassName;
		inputStr += CHR_1 + QryMethodName;
		inputStr += CHR_1 + DisCode;
		inputStr += CHR_1 + DisDesc;
		inputStr += CHR_1 + Args;
		inputStr += CHR_1 + ChooseValue;
		inputStr += CHR_1 + (IsLoadAll?1:0);
		inputStr += CHR_1 + (IsActive?1:0);
		var ret = ExtTool.RunServerMethod('DHCWMR.MQ.ItemDic','Update',inputStr,CHR_1);
		if(ret<0) {
			ExtTool.alert("提示","保存失败！");
			return;
		}else{
			ExtTool.alert("提示","保存成功！");
		}
	}
}