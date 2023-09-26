
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsDicPathogeny = ExtTool.StaticServerObject("DHCMed.NINF.Dic.Pathogeny");
	obj.ClsDicPathogenySrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.Pathogeny");
	
	obj.LoadEvent = function(args)
    {
		//add by zf 20130604
		if (CateCode != '') {
			obj.comboCate.setValue(CateCode);
			obj.comboCate.setRawValue(CateDesc);
		}
		if (SubCateCode != '') {
			obj.comboSubCate.setValue(SubCateCode);
			obj.comboSubCate.setRawValue(SubCateDesc);
		}
		
    	obj.btnFind.on("click",obj.btnFind_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridPathogeny.on("rowclick",obj.gridPathogeny_rowclick,obj);
		obj.gridPathogenyStore.load({params : {start : 0,limit : 50}});
		obj.comboCate.on("change",obj.comboCate_change,obj);
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtWhonet","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtPinyin","");   //update by zhangxing 20121018
		Common_SetValue("txtDesc1","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
		Common_SetValue("chkIsMultires",false);
		Common_SetValue("cboMultiresGroup","","");
		Common_SetValue("comboCate","");
		Common_SetValue("comboSubCate","");
	}
	
	obj.btnFind_click = function()
	{
		obj.gridPathogenyStore.load({params : {start : 0,limit : 50}});
	}
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Whonet = Common_GetValue("txtWhonet");
		var Desc = Common_GetValue("txtDesc");
		var Pinyin = Common_GetValue("txtPinyin");   //update by zhangxing 20121018
		var Desc1 = Common_GetValue("txtDesc1");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		var IsMultires = Common_GetValue("chkIsMultires");
		var MultiresGroup = Common_GetValue("cboMultiresGroup");
		
		//add by wuqk 2013-03-04
		var PYCateCode = Common_GetValue("comboCate");
		var PYSubCateCode = Common_GetValue("comboSubCate");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Desc1;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		inputStr = inputStr + CHR_1 + (IsMultires ? '1' : '0');
		inputStr = inputStr + CHR_1 + MultiresGroup;
		inputStr = inputStr + CHR_1 + Whonet;
		inputStr = inputStr + CHR_1 + Pinyin;   //update by zhangxing 20121018
		inputStr = inputStr + CHR_1 + PYCateCode;      //add by wuqk 2013-03-04
		inputStr = inputStr + CHR_1 + PYSubCateCode;   //add by wuqk 2013-03-04
		var flg = obj.ClsDicPathogenySrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridPathogeny");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridPathogeny");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicPathogeny.DeleteById(objRec.get("PyID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
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
	
	obj.gridPathogeny_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridPathogeny.getStore().getAt(index);
		if (objRec.get("PyID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("PyID");
			Common_SetValue("txtCode",objRec.get("PyCode"));
			Common_SetValue("txtWhonet",objRec.get("PyWhonet"));
			Common_SetValue("txtDesc",objRec.get("PyDesc"));
			Common_SetValue("txtPinyin",objRec.get("PyPinyin"));   //update by zhangxing 20121018
			Common_SetValue("txtDesc1",objRec.get("PyDesc1"));
			Common_SetValue("chkIsActive",(objRec.get("PyActive")=='1'));
			Common_SetValue("txtResume",objRec.get("PyResume"));
			Common_SetValue("chkIsMultires",(objRec.get("PYIsMultires")=='1'));
			Common_SetValue("cboMultiresGroup",objRec.get("MultiresGroupID"),objRec.get("MultiresGroupDesc"));			
			
			//add by wuqk 2013-03-04
			Common_SetValue("comboCate",objRec.get("PYCateCode"),objRec.get("PYCateDesc"));
			Common_SetValue("comboSubCate",objRec.get("PYSubCateCode"),objRec.get("PYSubCateDesc"));
		}
	};
	obj.comboCate_change = function(){
		Common_SetValue("comboSubCate","");
		obj.comboSubCate.getStore().load();
	}
}

