function InitwinScreenEvent(obj)
{
	//加载类方法
	obj.ClsDicInfDiagnoseGist = ExtTool.StaticServerObject("DHCMed.NINF.Dic.InfDiagnoseGist");
	obj.ClsDicInfDiagnoseGistSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.InfDiagnoseGist");
	
	obj.LoadEvent = function(args){
		obj.btnSaveToGist.on("click",obj.btnSaveToGist_click,obj);
		obj.btnDeleteToGist.on("click",obj.btnDeleteToGist_click,obj);
		obj.btnExitToGist.on("click", obj.btnExitToGist_click, obj);
		obj.gridInfDiagnoseGist.on("rowclick",obj.gridInfDiagnoseGist_rowclick,obj);
		obj.gridInfDiagnoseGistStore.load({});
  	};
  	
  	obj.ClearFormItem = function()                         
	{
		obj.RecRowID = "";
		Common_SetValue("CboIDGType","","");                  
		Common_SetValue("txtIDGCode","");
		Common_SetValue("txtIDGDesc","");
	}
	
	obj.btnSaveToGist_click = function()
	{
		var errinfo = "";
		var Type = Common_GetValue("CboIDGType");              
		var Code = Common_GetValue("txtIDGCode");
		var InfDeas = Common_GetValue("txtIDGDesc");
		//update by likai for bug:3965
		if (!Type)
		{
			errinfo = errinfo + "类型为空!<br>";
		}
		if (!Code)
		{
			errinfo = errinfo + "代码为空!<br>";
		}
		if (errinfo)
		{
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var Parref='';
		var ChildSub='';
		if(obj.RecRowID!='')
		{
			var str=obj.RecRowID;
			var ss = str.split("||");
			Parref = ss[0];
			ChildSub = ss[1];
		}else{
			Parref = obj.InfDiagnosID;
			ChildSub = '';
		}
		var inputStr = Parref;              
		inputStr = inputStr + CHR_1 + ChildSub;               
		inputStr = inputStr + CHR_1 + Type;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + InfDeas;
		var flg = obj.ClsDicInfDiagnoseGistSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) 
		{
			if (parseInt(flg) == -1)  //update by likai for bug:4015
			{
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		obj.ClearFormItem();
		obj.gridInfDiagnoseGistStore.load({});
	}
	obj.btnDeleteToGist_click = function()
	{
		
		var objGrid = Ext.getCmp("gridInfDiagnoseGist");
		if (objGrid)
		{
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0)
			{
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text)
				{
					if(btn=="yes")
					{
						for (var indRec = 0; indRec < arrRec.length; indRec++)
						{
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicInfDiagnoseGist.DeleteById(objRec.get("IDGRowID"));
							if (parseInt(flg) < 0) 
							{
								var row = objGrid.getStore().index0fId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								ExtTool.alert('提示',"删除成功")
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
								
							}
						}
						
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	obj.btnExitToGist_click = function()
	{
		obj.winScreen.close();
	};
		
	obj.gridInfDiagnoseGist_rowclick = function()
	{                   
		var index=arguments[1];
		var objRec = obj.gridInfDiagnoseGist.getStore().getAt(index);   
		if (objRec.get("IDGRowID") == obj.RecRowID) 
		{
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("IDGRowID");
			Common_SetValue("CboIDGType",objRec.get("IDGTypeID"),objRec.get("IDGTypeDesc"));
			Common_SetValue("txtIDGCode",objRec.get("IDGCode"));
			Common_SetValue("txtIDGDesc",objRec.get("IDGDesc"));
		}
	};
}
	
	