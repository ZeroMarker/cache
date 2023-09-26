function InitViewport1Event(obj){
	obj.LoadEvent = function (){
		obj.GridFPItemList.on('rowclick',obj.GridFPItemList_rowclick,obj);
		obj.btnSave.on('click',obj.btnSave_click,obj);
		obj.btnDelete.on('click',obj.btnDelete_click,obj);
		
		obj.cboWorkFlow.on("select",obj.cboWorkFlow_select,obj);
		obj.GridFPItemListStore.load({});
	}
	
	obj.cboWorkFlow_select = function(combo,record,index){
		obj.cboWFItem.setValue('');
		obj.cboWFItem.setRawValue('');
		obj.cboWFItem.getStore().removeAll();
		obj.cboWFItem.getStore().load({});
	}
	
	obj.btnSave_click = function(){
		var CHR_1 = String.fromCharCode(1);
		var ID = obj.CurrFPItemID;
		var Error = "";
		var WorkFlowID = Common_GetValue('cboWorkFlow');
		var WFItemID = Common_GetValue('cboWFItem');
		var FPType = Common_GetValue('cbgFPType');
		var Resume = Common_GetValue('txtResume');
		var ICDVerID = Common_GetValue('cboICDVersion');
		var OprVerID = Common_GetValue('cboOprVersion');
		var ICDVer2ID = Common_GetValue('cboICDVer2');
		var ICDVer3ID = Common_GetValue('cboICDVer3');
		if (WorkFlowID=="") Error+="工作流、";
		if (WFItemID=="") Error+="操作项目、";
		if (FPType=="")  Error+="类型、";
		if (ICDVerID=="")  Error+="诊断库、";
		if (OprVerID=="")   Error+="手术库、";
		if (Error!="")
		{
			ExtTool.alert("提示",Error+"为空!");
			return;
		}
		
		var InputStr = ID;
		InputStr += CHR_1 + WFItemID;
		InputStr += CHR_1 + FPType;
		InputStr += CHR_1 + Resume;
		InputStr += CHR_1 + ICDVerID;
		InputStr += CHR_1 + OprVerID;
		InputStr += CHR_1 + ICDVer2ID;
		InputStr += CHR_1 + ICDVer3ID;
		
		var Index=obj.GridFPItemListStore.findExact("WFItemID", WFItemID);
		if (Index >-1)
		{
			var objRec = obj.GridFPItemListStore.getAt(Index);
			if (objRec.get("FPItemID")!=ID)
			{
				ExtTool.alert("提示","该工作流下此操作项目已存在，请仔细检查!");
				return;
			}
		}
		
		var flg = ExtTool.RunServerMethod("DHCWMR.FP.WorkFItem","Update",InputStr,CHR_1);
		if (parseInt(flg)<0){
			ExtTool.alert("提示","保存失败！");
			return;
		} else {
			ExtTool.alert("提示","保存成功！");
			obj.GridFPItemListStore.load({});
			obj.CleanFormList();
		}
	}
	
	obj.btnDelete_click = function(){
		var ID = obj.CurrFPItemID;
		if (ID==""){
			ExtTool.alert("提示","请选择编目项目!");
			return;
		}
		Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
			if(btn=="yes"){
				var flg = ExtTool.RunServerMethod("DHCWMR.FP.WorkFItem","DeleteById",ID);
				if (parseInt(flg)<0){
					ExtTool.alert("提示","删除失败!");
					return;
				} else {
					obj.GridFPItemListStore.load({});
					obj.CleanFormList();
				}
			}
		});
	}
	
	obj.CleanFormList = function(){
		obj.CurrFPItemID = '';
		Common_SetValue('cboWorkFlow','','');
		Common_SetValue('cboWFItem','','');
		Common_SetValue('cbgFPType','','');
		Common_SetValue('cboICDVersion','','');
		Common_SetValue('cboOprVersion','','');
		Common_SetValue('cboICDVer2','','');
		Common_SetValue('txtResume','');
		obj.cboWorkFlow_select();
		obj.cboWorkFlow.getStore().removeAll();
		obj.cboWorkFlow.getStore().load({});
	}
	
	obj.GridFPItemList_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.GridFPItemListStore.getAt(rowIndex);
		if (obj.CurrFPItemID == objRec.get("FPItemID")) {
			obj.CleanFormList();
		} else {
			obj.CurrFPItemID = objRec.get("FPItemID");
			Common_SetValue('cboWorkFlow',objRec.get("WFlowID"),objRec.get("WFlowDesc"));
			//Common_SetValue('cboWFItem',objRec.get("WFItemID"),objRec.get("WFItemDesc"));
			Common_SetValue('cbgFPType',objRec.get("TypeCode"),objRec.get("TypeDesc"));
			Common_SetValue('txtResume',objRec.get("Resume"));
			Common_SetValue('cboICDVersion',objRec.get("ICDVerID"),objRec.get("ICDVerDesc"));
			Common_SetValue('cboOprVersion',objRec.get("OPRVerID"),objRec.get("OPRVerDesc"));
			Common_SetValue('cboICDVer2',objRec.get("ICDVer2ID"),objRec.get("ICDVer2Desc"));
			
			Ext.getCmp("cboWFItem").setValue(objRec.get("WFItemID")); // 加载操作项目所用query,未获取到工作流ID,用Common_SetValue无法赋值
			Ext.getCmp("cboWFItem").setRawValue(objRec.get("WFItemDesc"));
		}
	}
}

function DisplayFPItemExtraWin(FPItemID){
	var win= new InitFPItemExtraWin(FPItemID);
	win.winFPItemExtra.show();
}