
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
  {
	var objParent = Ext.getCmp("pnCpyInfo2");
	ExtTool.RunQuery(
		{
			ClassName : 'DHCWMR.SSService.DictionarySrv',
			QueryName : 'QryDicByType',
			Arg1 : 'COPY_CONTENT',
			Arg2 : '',
			Arg3 : '',
			ArgCnt : 3
		},
		function(arryResult){
			var arry = new Array();
			for(var i = 0; i < arryResult.length; i ++)
			{
				var objItm = arryResult[i];
				arry[i] = {
					boxLabel : objItm.DicDesc, 
					DicID : objItm.DicRowID, 
					name : 'chkContent'
				};
			}
			var objCtl = new Ext.form.CheckboxGroup({
					id:'grpContent', 
					columns: 4,
					fieldLabel: '复印内容',
					items : arry
				});
			objParent.add(objCtl);
			objParent.doLayout();			
			
		}
	)
	
	obj.txtMrNo.on("keypress", obj.txtMrNo_keypress, obj);
	obj.txtNum.on("blur", obj.txtNum_blur, obj);
	
  };
  
	obj.ValidateContent = function() {
		var errStr = "";
		if(obj.gridVolStore.getCount() == 0)
			errStr += "请输入病案号，并选择复印病案的就诊信息！";
		var intSelVol = 0;
		for(var i = 0; i < obj.gridVolStore.getCount(); i ++)
		{
			var objRec = obj.gridVolStore.getAt(i);
			if(objRec.get("checked"))
				intSelVol ++;
		}
		if(intSelVol == 0)
		{
			if(errStr != "")
				errStr += "<BR/>"
			errStr += "请勾选复印病案的就诊信息，";
		}
		if(obj.cboCopyGoal.getValue() == "")
		{
			if(errStr != "")
				errStr += "<BR/>"
			errStr += "请选择复印病案目的！";		
		}
		if(obj.cboReqPeople.getValue() == "")
		{
			if(errStr != "")
				errStr += "<BR/>"
			errStr += "请选择复印人员类别！";		
		}
		if(Ext.getCmp("grpContent").getValue().length == 0)
		{
			if(errStr != "")
				errStr += "<BR/>"
			errStr += "请选择复印病案内容！";		
		}		
		if(obj.txtNum.getValue() <= 0)
		{
			if(errStr != "")
				errStr += "<BR/>"
			errStr += "请正确输入复印页数！";		
		}		
		if(obj.txtPrice.getValue() < 0)
		{
			if(errStr != "")
				errStr += "<BR/>"
			errStr += "请正确输入复印缴费金额！";		
		}			
		return errStr;
	}
	
	obj.txtMrNo_keypress = function(sender, e) {
		if((e.getCharCode() != 13))
			return;
		ExtTool.RunQuery(
			{
				ClassName : 'DHCWMR.SSService.WorkFlowSrv',
				QueryName : 'QryByNum',
				Arg1 : CurrMrType.RowID,
				Arg2 : obj.txtMrNo.getValue(),
				ArgCnt : 2
			},
			function(arryResult){
				if(arryResult.length > 0)
				{
					var objRec = arryResult[0];
					obj.txtMrNo.setValue(objRec.MrNo);
					obj.gridVolStore.load({});
				}
			}
		);		
		
	}
  
	obj.btnSave_click = function()
	{
		var errStr = obj.ValidateContent();
		if(errStr != "")
		{
			ExtTool.alert("提示", errStr, Ext.MessageBox.INFO);
			return;
		}
		
		var strVolList = "";
		for(var i = 0; i < obj.gridVolStore.getCount(); i ++)
		{
			var objVol = obj.gridVolStore.getAt(i);
			if(objVol == null)
				continue;
			var VolID = objVol.get("VolID");
			if(strVolList != "")
				strVolList += "^";
			strVolList += VolID;
		}
		var strDtl = "";
		strDtl += dicDtl['COPY_GOAL'] + "^" + obj.cboCopyGoal.getValue() + "^" + obj.cboCopyGoal.getRawValue() + String.fromCharCode(1);
		strDtl += dicDtl['COPY_REQ_PEOPLE'] + "^" + obj.cboReqPeople.getValue() + "^" + obj.cboReqPeople.getRawValue() + String.fromCharCode(1);
		
		var strSelIDList = "";
		var strSelTxtList = "";
		var arrySelContents = Ext.getCmp("grpContent").getValue();
		for(var i = 0; i < arrySelContents.length; i++)
		{
			if(strSelIDList != "")
				strSelIDList += "#"
			strSelIDList += arrySelContents[i].initialConfig.DicID;
			if(strSelTxtList != "")
				strSelTxtList += "#"
			strSelTxtList += arrySelContents[i].initialConfig.boxLabel;			
				
		}
		
		strDtl += dicDtl['COPY_CONTENT'] + "^" + strSelIDList + "^" + strSelTxtList + String.fromCharCode(1);
		strDtl += dicDtl['COPY_PAGES'] + "^" + obj.txtNum.getValue() + "^"  + String.fromCharCode(1);
		strDtl += dicDtl['COPY_PRICE'] + "^" + obj.txtPrice.getValue() + "^"  + String.fromCharCode(1);
		strDtl += dicDtl['COPY_RESUME'] + "^" + obj.txtResume.getValue() + "^"  + String.fromCharCode(1);
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.MRCopySrv", "SaveMrCopy", 
			strVolList,
			WorkFlowItemID,
			strDtl,
			session['LOGON.USERID']
		);
		var arryRet = ret.split("^");
		if (arryRet[2] == "0")
		{
			ExtTool.alert("提示", "保存成功！", Ext.MessageBox.INFO);
			obj.btnClear_click()
		}
		else
		{
			ExtTool.alert("错误", ret, Ext.MessageBox.ERROR);
		}
	};
	obj.btnClear_click = function()
	{
		obj.txtMrNo.setValue("");
		obj.gridVolStore.removeAll();
		obj.cboCopyGoal.clearValue();
		obj.cboReqPeople.clearValue();
		obj.txtNum.setValue("");
		obj.txtPrice.setValue("");
		obj.txtResume.setValue("");
		var arryContent = Ext.getCmp("grpContent").getValue();
		for(var i = 0; i < arryContent.length; i++)
		{
			arryContent[i].setValue(false);
		}
	};
	
	obj.txtNum_blur = function(){
		obj.txtPrice.setValue(new Number(obj.txtNum.getValue() * PaperPrice).toFixed(2));
	}
	
	obj.btnQryPat_click = function()
	{
	};
/*viewScreen新增代码占位符*/}

