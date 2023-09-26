
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsRepHandHyProductsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.HandHyProducts");
	
	obj.LoadEvent = function(args)
    {
		if (obj.AdminPower != '1') {
			Common_SetValue('cboExamLoc',LogonLocID,LogonLocDesc);
			Common_SetDisabled('cboExamLoc',true);
		} else {
			//Common_SetValue('cboExamLoc',LogonLocID,LogonLocDesc);
			Common_SetDisabled('cboExamLoc',false);
		}
		
		obj.cboProduct.on("select",obj.cboProduct_select,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridHandHyProducts.on("rowclick",obj.gridHandHyProducts_rowclick,obj);
		
		obj.gridHandHyProductsStore.load({params : {start : 0,limit : 100}});
  	};
	
	obj.cboProduct_select = function() {
		var ProductID = Common_GetValue('cboProduct');
		if (ProductID != '') {
			var objProductStore = obj.cboProduct.getStore();
			var ind = objProductStore.find("HHPID",ProductID);
			if (ind > -1) {
				var objRec = objProductStore.getAt(ind);
				var ProUnit = objRec.get('HHPUnit');
				obj.txtProUnit.setText(ProUnit);
			}
		}
	}
	
	obj.btnQuery_click = function() {
		obj.gridHandHyProductsStore.removeAll();
		obj.gridHandHyProductsStore.load({params : {start : 0,limit : 100}});
	}
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("cboProduct","","");
		Common_SetValue("txtConsumption","");
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function() {
		var ExamLocID = Common_GetValue('cboExamLoc');
		var ExamDate = Common_GetValue('txtExamYYMM');
		var ProductID = Common_GetValue('cboProduct');
		var Consumption = Common_GetValue('txtConsumption');
		var Resume = Common_GetValue('txtResume');
		
		var errInfo = '';
		if (ExamLocID == '') {
			errInfo = errInfo + '科室为空!<br>'
		}
		if (ExamDate == '') {
			errInfo = errInfo + '年月为空!<br>'
		}
		if (ProductID == '') {
			errInfo = errInfo + '手卫生用品为空!<br>'
		}
		if (Consumption == '') {
			errInfo = errInfo + '消耗量为空!<br>'
		}
		if (errInfo != '') {
			ExtTool.alert("提示",errInfo);
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + ExamLocID;
		inputStr = inputStr + CHR_1 + ExamDate;
		inputStr = inputStr + CHR_1 + ProductID;
		inputStr = inputStr + CHR_1 + Consumption;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + 1;
		inputStr = inputStr + CHR_1 + Resume;
		//alert(inputStr);
		var  flg = obj.ClsRepHandHyProductsSrv.SaveRepRec(inputStr,CHR_1);
		if (parseInt(flg)<=0) {
			ExtTool.alert("提示","保存数据失败!Error=" + flg);
			return false;
		} else {
			obj.ClearFormItem();
			Common_LoadCurrPage("gridHandHyProducts");
		}
	}
	
	obj.btnDelete_click = function() {
		var objGrid = Ext.getCmp("gridHandHyProducts");
		if (objGrid){
			var objRecArr = objGrid.getSelectionModel().getSelections();
			if (objRecArr.length>0){
				Ext.MessageBox.confirm('删除', '是否【删除】选中数据记录?', function(btn,text){
					if (btn=="yes") {
						for (var indRec = 0; indRec < objRecArr.length; indRec++){
							var objRec = objRecArr[indRec];
							var inputStr = objRec.get('ReportID');
							inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
							inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
							inputStr = inputStr + CHR_1 + '0';
							inputStr = inputStr + CHR_1 + text;
							var flg = obj.ClsRepHandHyProductsSrv.SaveRepStatus(inputStr,CHR_1);
						}
						Common_LoadCurrPage("gridHandHyProducts");
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击【删除】!");
			}
		}
	}
	
	obj.gridHandHyProducts_rowclick = function() {
		var index=arguments[1];
		var objRec = obj.gridHandHyProducts.getStore().getAt(index);
		if (objRec.get("ReportID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ReportID");
			Common_SetValue("cboExamLoc",objRec.get("ExamLocID"),objRec.get("ExamLocDesc"));
			Common_SetValue("txtExamYYMM",objRec.get("ExamYYMM"));
			Common_SetValue("cboProduct",objRec.get("ProductID"),objRec.get("ProductDesc"));
			Common_SetValue("txtConsumption",objRec.get("Consumption"));
			Common_SetValue("txtResume",objRec.get("RepResume"));
		
		}	
	}
}

