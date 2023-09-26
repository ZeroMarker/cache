function InitfrmPathWayDicEditEvent(obj)
{
	obj.currSelRowIndex = -1; //Add By LiYang 2011-05-25 保存当前行号
	var CPWDID="";            //add by wuqk 2011-11-17
	
	obj.LoadEvent = function(args)
	{
		//obj.btnAdd.on("click", obj.btnAdd_click, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.gridResult.on("rowclick",obj.gridResult_rowclick, obj);
		obj.cboPathType.on("expand", obj.cboPathType_OnExpand, obj);
		
		// add by wuqk 2011-11-17 for 路径常用科室
		obj.btnLocList.on("click", obj.btnLocList_click, obj);
	}
	
	obj.cboPathType_OnExpand = function()
	{
		obj.cboPathTypeStore.load({});
	}
	
	//Add By LiYang 2011-05-22 FixBug:50 临床路径维护--基础字典维护-路径字典维护-可以新增空白的临床路径
	obj.ValidateContents = function()
	{
		if(obj.txtCode.getValue() == "")
		{
			ExtTool.alert("提示", "请输入代码！");
			return false;	
		}
		if(obj.txtDesc.getValue() == "")
		{
			ExtTool.alert("提示", "请输入描述！");
			return false;	
		}
		//******* Add by zhaoyu 2013-04-26 247、248 临床路径定义 路径类型、生效日期为必填
		if(obj.cboPathType.getValue() == ""){
			ExtTool.alert("提示", "请输入路径类型！");
			return false;
		}
		if(obj.dtFrom.getValue() == ""){
			ExtTool.alert("提示", "请输入生效日期！");
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
		修改字典时不允许修改当前版本
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
		//Add By LiYang 2011-05-22 FixBug:50 临床路径维护--基础字典维护-路径字典维护-可以新增空白的临床路径
		if (!obj.ValidateContents())
			return;
		try
		{
			var strArg = obj.SaveToString(true);
			//alert(strArg);
			var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
			//Add By LiYang 2011-02-26 校验临床路径字典是否重复（判断Code）
			if(DHCMRCClinPathWaysDic.IsClinPathWayDicExists(obj.txtCode.getValue(), obj.txtDesc.getValue()) == "1")
			{
				ExtTool.alert("提示", "这个临床路径已经存在了！");
				return;
			}
			var ret = DHCMRCClinPathWaysDic.Update(strArg);
			obj.gridResultStore.load({});	
			//ExtTool.alert("提示", "保存成功！");
		}catch(e)
		{
			ExtTool.alert("错误", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}
		
	};
	*/
	obj.btnSave_click = function()
	{
		if (!obj.ValidateContents())
			return;
		try
		{
			//Add By NiuCaicai 2011-07-19 FixBug:91 临床路径维护--基础信息维护-路径字典维护-生效时间可以大于废止时间
			//.......................................................................................
			var DateFrom = Date.parse(obj.dtFrom.getValue());
			var DateTo = Date.parse(obj.dtTo.getValue());
			if ((DateTo) && (DateFrom>DateTo)){
				ExtTool.alert("提示", "生效日期不能大于废止日期！保存失败！!");
				return;
			}
			//.......................................................................................
			if(obj.currSelRowIndex == -1)
			{
				//Add By LiYang 2011-02-26 校验临床路径字典是否重复（判断Code）
				//Add By LiYang 2011-05-22 FixBug:50 临床路径维护--基础字典维护-路径字典维护-可以新增空白的临床路径
				//Update By NiuCaicai 2011-07-21 FixBug:90 临床路径维护--基础信息维护-临床路径字典-通过修改已存在的路径纪录可重复添加相同的临床路径
				/*
				var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
				if(DHCMRCClinPathWaysDic.IsClinPathWayDicExists(obj.txtCode.getValue(), obj.txtDesc.getValue()) == "1")
			    {
					ExtTool.alert("提示", "这个临床路径已经存在了！");
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
			//******** Add by zhaoyu 2013-04-26 临床路径定义-新增记录（代码、描述和界面中的某记录重复），修改原来记录信息 244
			var CheckCodeFlg = DHCMRCClinPathWaysDic.CheckCPWDicCode(strArg);
			if (CheckCodeFlg == "1"){
                		ExtTool.alert("提示", "代码重复！");
				return;
			}
			//****************************************************
			//Update By NiuCaicai 2011-07-22 FixBug:90 临床路径维护--基础信息维护-临床路径字典-通过修改已存在的路径纪录可重复添加相同的临床路径
			//.................................................................
			var newret = DHCMRCClinPathWaysDic.Update(strArg,obj.txtCode.getValue(), obj.txtDesc.getValue());
			if(newret == "0")
			{
                ExtTool.alert("提示", "此临床路径已存在！");
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
			//ExtTool.alert("提示", "保存成功！");
		}catch(e)
		{
			ExtTool.alert("错误", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
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
			ExtTool.alert("错误", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}
	}
	
	//add by wuqk 2011-11-17
	obj.btnLocList_click = function(){
		if (CPWDID=="") {ExtTool.alert("提示", "请先选择路径!");return;}
		var winLocList=new InitWinLocList(CPWDID,obj.txtDesc.getValue());
		winLocList.winScreen.show();
	}
}
