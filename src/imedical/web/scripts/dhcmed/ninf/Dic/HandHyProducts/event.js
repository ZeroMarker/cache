
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsDicHandHyProducts = ExtTool.StaticServerObject("DHCMed.NINF.Dic.HandHyProducts");
	
	obj.LoadEvent = function(args)
    {
		obj.btnFind.on("click",obj.btnFind_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridHandHyProducts.on("rowclick",obj.gridHandHyProducts_rowclick,obj);
		obj.gridHandHyProductsStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtDesc1","");
		Common_SetValue("txtPinyin","");
		Common_SetValue("txtSpec","");
		Common_SetValue("txtUnit","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
		Common_SetValue("cboGroup","","");
	}
	
	obj.btnFind_click = function()
	{
		obj.gridHandHyProductsStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Desc1 = Common_GetValue("txtDesc1");
		var Pinyin = Common_GetValue("txtPinyin");
		var Spec = Common_GetValue("txtSpec");
		var Unit = Common_GetValue("txtUnit");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		var ProductGroup = Common_GetValue("cboGroup");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!Spec) {
			errinfo = errinfo + "规格为空!<br>";
		}
		if (!Unit) {
			errinfo = errinfo + "单位为空!<br>";
		}
		
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var selectObj = obj.gridHandHyProducts.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("HHPCode") : "");
		var strCode = obj.txtCode.getValue();
		var strSpec = obj.txtSpec.getValue();
		if ((strCode != strCodeLast) && (obj.gridHandHyProductsStore.findExact("HHPCode", strCode) >-1) && (obj.gridHandHyProductsStore.findExact("HHPSpec", strSpec) >-1))
		{
			ExtTool.alert("提示","该条记录已存在!");
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Desc1;
		inputStr = inputStr + CHR_1 + Pinyin;
		inputStr = inputStr + CHR_1 + Spec;
		inputStr = inputStr + CHR_1 + Unit;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		inputStr = inputStr + CHR_1 + ProductGroup;
		var flg = obj.ClsDicHandHyProducts.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridHandHyProducts");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridHandHyProducts");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicHandHyProducts.DeleteById(objRec.get("HHPID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
								Common_LoadCurrPage("gridHandHyProducts"); // add by zhoubo 2014-12-22
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
		//add by likai for bug:3944
		obj.ClearFormItem();
		Common_LoadCurrPage("gridHandHyProducts");
	}
	
	obj.gridHandHyProducts_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridHandHyProducts.getStore().getAt(index);
		if (objRec.get("HHPID") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridHandHyProducts.getSelectionModel().clearSelections(); //Modified By LiYang 2014-11-02 FixBug:3948 医院感染管理-手卫生调查-手卫生用品维护-点击取消选中的记录，底色仍为蓝色，且可进行删除操作
		} else {
			obj.RecRowID = objRec.get("HHPID");
			Common_SetValue("txtCode",objRec.get("HHPCode"));
			Common_SetValue("txtDesc",objRec.get("HHPDesc"));
			Common_SetValue("txtPinyin",objRec.get("HHPPinyin"));
			Common_SetValue("txtSpec",objRec.get("HHPSpec"));
			Common_SetValue("txtUnit",objRec.get("HHPUnit"));
			Common_SetValue("txtDesc1",objRec.get("HHPDesc1"));
			Common_SetValue("chkIsActive",(objRec.get("HHPActive")=='1'));
			Common_SetValue("txtResume",objRec.get("HHPResume"));
			Common_SetValue("cboGroup",objRec.get("HHPGroupID"),objRec.get("HHPGroupDesc"));
		}
	};
}

