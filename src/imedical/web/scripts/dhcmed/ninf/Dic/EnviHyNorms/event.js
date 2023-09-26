
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsDicEnviHyNorms = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyNorms");
	obj.ClsDicEnviHyNormsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyNorms");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		
		obj.gridEnviHyNorms.on("rowclick",obj.gridEnviHyNorms_rowclick,obj);
		obj.gridEnviHyNormsStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("cboCateg","","");
		Common_SetValue("txtRange","");
		Common_SetValue("txtNorm","");
		Common_SetValue("txtNormMax","");
		Common_SetValue("txtNormMin","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
		Common_SetValue("cboSpecimenType","");
		Common_SetValue("txtSpecimenNum","");
		Common_SetValue("txtCenterNum","");
		Common_SetValue("txtSurroundNum","");
		Common_SetValue("txtItemObj","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Categ = Common_GetValue("cboCateg");
		var Range = Common_GetValue("txtRange");
		var Norm = Common_GetValue("txtNorm");
		var NormMax = Common_GetValue("txtNormMax");
		var NormMin = Common_GetValue("txtNormMin");
		var SpecimenType = Common_GetValue("cboSpecimenType");
		var SpecimenNum = Common_GetValue("txtSpecimenNum");
		var CenterNum = Common_GetValue("txtCenterNum");
		var SurroundNum = Common_GetValue("txtSurroundNum");
		var ItemObj = Common_GetValue("txtItemObj");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		
		if (!Categ) {
			errinfo = errinfo + "环境类别为空!<br>";
		}
		if (!Range) {
			errinfo = errinfo + "检测范围为空!<br>";   //update by likai for bug:3865
		}
		if (!Norm) {
			errinfo = errinfo + "检测标准为空!<br>";
		}
		if ((!NormMax)&&(NormMax.toString()=="")) { //add by zhoubo 2014-12-19 fixbug:3867
			errinfo = errinfo + "中心值为空!<br>";
		}
		if ((!NormMin)&&(NormMin.toString()=="")) { //add by zhoubo 2014-12-19 fixbug:3867
			errinfo = errinfo + "周边值为空!<br>";
		}
		if (!SpecimenType) { 
			errinfo = errinfo + "标本类型为空!<br>";
		}
		if ((!SpecimenNum)&&(SpecimenNum.toString()=="")) { //add by zhoubo 2014-12-19 fixbug:3867
			errinfo = errinfo + "标本数量为空!<br>";
		}
		if ((!CenterNum)&&(CenterNum.toString()=="")) { //add by zhoubo 2014-12-19 fixbug:3867
			errinfo = errinfo + "中心个数为空!<br>";
		}
		if ((!SurroundNum)&&(SurroundNum.toString()=="")) {
			errinfo = errinfo + "周边个数为空!<br>";
		}
		if (!ItemObj) {
			errinfo = errinfo + "项目对象为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;						    //1--ID 
		inputStr = inputStr + CHR_1 + Categ;					//2--环境类别
		inputStr = inputStr + CHR_1 + Range;					//3--检测范围
		inputStr = inputStr + CHR_1 + Norm;					    //4--判定标准
		inputStr = inputStr + CHR_1 + NormMax;					//5--中心值
		inputStr = inputStr + CHR_1 + NormMin;					//6--周边值
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');	//7--是否有效		
		inputStr = inputStr + CHR_1 + Resume;					//8--备注
		inputStr = inputStr + CHR_1 + SpecimenType;  			//9--标本类型
		inputStr = inputStr + CHR_1 + SpecimenNum;  			//10--标本数量
		inputStr = inputStr + CHR_1 + CenterNum;  				//11--中心个数
		inputStr = inputStr + CHR_1 + SurroundNum; 				//12--周边个数
		inputStr = inputStr + CHR_1 + ItemObj;    				//13--项目对象
		inputStr = inputStr + CHR_1 + obj.ItemID;		  		//14--检测项目
		
		var ret=obj.ClsDicEnviHyNormsSrv.CheckRec(inputStr,CHR_1);
		if (ret == "Y") {
			ExtTool.alert("错误提示","数据重复，请仔细填写!");
			return;
		}
		var flg = obj.ClsDicEnviHyNormsSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			return;
		}
		obj.ClearFormItem();
		Common_LoadCurrPage("gridEnviHyNorms");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridEnviHyNorms");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicEnviHyNorms.DeleteById(objRec.get("ID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
								objGrid.getStore().load({params : {start : 0,limit : 50}});
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridEnviHyNorms_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridEnviHyNorms.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("cboCateg",objRec.get("EHNCategID"),objRec.get("EHNCategDesc"));
			Common_SetValue("txtRange",objRec.get("EHNRange"));
			Common_SetValue("txtNorm",objRec.get("EHNNorm"));
			Common_SetValue("txtNormMax",objRec.get("EHNNormMax"));
			Common_SetValue("txtNormMin",objRec.get("EHNNormMin"));
			Common_SetValue("chkIsActive",(objRec.get("EHNIsActive")=='1'));
			Common_SetValue("txtResume",objRec.get("EHNResume"));
			Common_SetValue("cboSpecimenType",objRec.get("SpecimenTypeID"),objRec.get("SpecimenTypeDesc"));
			Common_SetValue("txtSpecimenNum",objRec.get("SpecimenNum"));
			Common_SetValue("txtCenterNum",objRec.get("CenterNum"));
			Common_SetValue("txtSurroundNum",objRec.get("SurroundNum"));
			Common_SetValue("txtItemObj",objRec.get("ItemObj"));
		}
	}
}

