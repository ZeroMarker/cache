
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsDicAntibiotics = ExtTool.StaticServerObject("DHCMed.NINF.Dic.Antibiotics");
	obj.ClsDicAntibioticsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.Antibiotics");
	
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
		obj.gridAntibiotics.on("rowclick",obj.gridAntibiotics_rowclick,obj);
		obj.gridAntibioticsStore.load({params : {start : 0,limit : 50}});
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
		Common_SetValue("comboCate","");
		Common_SetValue("comboSubCate","");
	}
	
	obj.btnFind_click = function()
	{
		obj.gridAntibioticsStore.load({params : {start : 0,limit : 50}});
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
		
		//add by wuqk 2013-03-04
		var ANTCateCode = Common_GetValue("comboCate");
		var ANTSubCateCode = Common_GetValue("comboSubCate");
		
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
		inputStr = inputStr + CHR_1 + Whonet;
		inputStr = inputStr + CHR_1 + Pinyin;   //update by zhangxing 20121018
		inputStr = inputStr + CHR_1 + ANTCateCode;      //add by wuqk 2013-03-04
		inputStr = inputStr + CHR_1 + ANTSubCateCode;   //add by wuqk 2013-03-04
		var flg = obj.ClsDicAntibioticsSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridAntibiotics");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridAntibiotics");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0&& (obj.RecRowID!= "")){  //fix Bug 113096 by pylian 2015-07-02 取消选中的记录，记录仍能被删除
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicAntibiotics.DeleteById(objRec.get("AntiID"));
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
	
	obj.gridAntibiotics_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridAntibiotics.getStore().getAt(index);
		if (objRec.get("AntiID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("AntiID");
			Common_SetValue("txtCode",objRec.get("AntiCode"));
			Common_SetValue("txtWhonet",objRec.get("AntiWhonet"));
			Common_SetValue("txtDesc",objRec.get("AntiDesc"));
			Common_SetValue("txtPinyin",objRec.get("AntiPinyin"));   //update by zhangxing 20121018
			Common_SetValue("txtDesc1",objRec.get("AntiDesc1"));
			Common_SetValue("chkIsActive",(objRec.get("AntiActive")=='1'));
			Common_SetValue("txtResume",objRec.get("AntiResume"));
			
			//add by wuqk 2013-03-04
			Common_SetValue("comboCate",objRec.get("ANTCateCode"),objRec.get("ANTCateDesc"));
			Common_SetValue("comboSubCate",objRec.get("ANTSubCateCode"),objRec.get("ANTSubCateDesc"));
		}
	};
	
	obj.comboCate_change = function(){
		Common_SetValue("comboSubCate","");
		obj.comboSubCate.getStore().load();
	}
}

