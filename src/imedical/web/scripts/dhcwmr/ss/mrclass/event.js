
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSMrClass = ExtTool.StaticServerObject("DHCWMR.SS.MrClass");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.GridMrClass.on("rowclick",obj.GridMrClass_rowclick,obj);
		
		obj.GridMrClassStore.load({params : {start : 0,limit : 100}});
		
  	};
	
	obj.ClearFormItem = function()
	{
		obj.txtCode.setDisabled(false);
		obj.RecRowID = "";
		obj.MrCode = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Resume = Common_GetValue("txtResume") 
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = obj.ClsSSMrClass.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) ==-100)
			{
				ExtTool.alert("错误提示","代码重复!");
				return;
			}else{
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
				return;
			}
		}
		
		obj.ClearFormItem();
		obj.GridMrClassStore.load({params : {start : 0,limit : 100}});
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("GridMrClass");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if((arrRec.length>0) && (obj.RecRowID!= "")){  //修改Bug 6548
				Ext.MessageBox.confirm('提示', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var MrID = objRec.get("MrID");
							if (MrID == '') {
								ExtTool.alert("提示","无科室组记录!");
								continue;
							}
							
							var flg = obj.ClsSSMrClass.DeleteById(MrID);
							//obj.btnFind_click(); 
							obj.ClearFormItem();
							//objGrid.getStore().remove(objRec);
							obj.GridMrClassStore.load({params : {start : 0,limit : 100}});
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.GridMrClass_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.GridMrClass.getStore().getAt(index);
		if (objRec.get("MrID") == obj.RecRowID) {
			
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("MrID");
			obj.MrCode   = objRec.get("MrCode");
			obj.txtCode.setDisabled(true);
			Common_SetValue("txtCode",objRec.get("MrCode"));
			Common_SetValue("txtDesc",objRec.get("MrDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
		}
	}
}

