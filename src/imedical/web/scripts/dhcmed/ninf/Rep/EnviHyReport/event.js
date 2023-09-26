function InitViewport1Event(obj) {
	obj.RecRowID = "";
	obj.CtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
	obj.ClsRepEnviHyReport = ExtTool.StaticServerObject("DHCMed.NINF.Rep.EnviHyReport");
	obj.ClsRepEnviHyReportSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.EnviHyReport");
	obj.ClsDicEnviHyItmMapSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyItmMap");
	obj.ClsCommonClsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	obj.LoadEvent = function(args)
    {
		var objLoc = obj.CtlocSrv.GetObjById(session['LOGON.CTLOCID']);
		if (obj.AdminPower != '1') {
			obj.cboLoc.setDisabled(true);
			var LogLocID = session['LOGON.CTLOCID'];
			var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
			var objLoc = objCtlocSrv.GetObjById(LogLocID);
			if (objLoc) {
				obj.cboLoc.setValue(objLoc.Rowid);
				obj.cboLoc.setRawValue(objLoc.Descs);
			}
		}
		obj.cboSpecType.setDisabled(true);
		obj.txtSpecNum.setDisabled(true);
		
		obj.gridCurrEnviHyReportStore.load({});
		obj.gridLastEnviHyReportStore.load({});
		
		obj.cboLoc.on("select",obj.cboLoc_select,obj);		//add by yanjifu  20140411
		obj.cboItem.on("select",obj.cboItem_select,obj);
		obj.cboNorm.on("select",obj.cboNorm_select,obj);
		obj.gridLastEnviHyReport.on("rowdblclick",obj.gridLastEnviHyReport_rowdblclick,obj);
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.gridCurrEnviHyReport.on("rowclick",obj.gridCurrEnviHyReport_rowclick,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCopy.on("click",obj.btnCopy_click,obj);
		obj.btnPrintBar.on("click",obj.btnPrintBar_click,obj);
		obj.lastMonth.on("click",obj.lastMonth_click,obj);
		obj.nextMonth.on("click",obj.nextMonth_click,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnPrintRep.on("click",obj.btnPrintRep_click,obj);
		obj.btnPrintLastBar.on("click",obj.btnPrintLastBar_click,obj);
		obj.btnPrintLastRep.on("click",obj.btnPrintLastRep_click,obj);
  	};
	
  	obj.btnPrintLastRep_click = function(){
  		var arrList = obj.gridLastSM.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "未选择打印记录，请重新选择!");
			return;
		}
		
		var errorInfo = "";
		for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
			var objRec = arrList[rowIndex];
			if (!objRec) continue;
			var RepResults=objRec.get("EHRResult");
			if(RepResults==""){
				var row = obj.gridCurrEnviHyReport.getStore().indexOf(objRec);
				errorInfo += "第" + (row + 1) + "行记录无录入结果，不允许打印！\r\n<br/>";
				continue;
			}
			var ReportID=objRec.get("ReportID");
			PrintReport(ReportID);
		}
		
		if(errorInfo != ""){
			ExtTool.alert("提示","环境卫生学监测报告打印 错误提示：\r\n<br/>" + errorInfo);
		}
  	}
	
  	obj.btnPrintRep_click = function(){
  		var arrList = obj.gridCurrSM.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "未选择打印记录，请重新选择!");
			return;
		}
		
		var errorInfo = "";
		for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
			var objRec = arrList[rowIndex];
			if (!objRec) continue;
			var RepResults=objRec.get("EHRResult");
			if(RepResults==""){
				var row = obj.gridCurrEnviHyReport.getStore().indexOf(objRec);
				errorInfo += "第" + (row + 1) + "行记录无录入结果，不允许打印！\r\n<br/>";
				continue;
			}
			var ReportID=objRec.get("ReportID");
			PrintReport(ReportID);
		}
		
		if(errorInfo != ""){
			ExtTool.alert("提示","环境卫生学监测报告打印 错误提示：\r\n<br/>" + errorInfo);
		}
  	}
	
	obj.btnQuery_click = function(){
		obj.gridCurrEnviHyReportStore.load({});
		obj.gridLastEnviHyReportStore.load({});
	}
	obj.lastMonth_click = function(){
		obj.LastDate.setMonth(obj.LastDate.getMonth()-1);
		
		obj.gridLastEnviHyReportStore.removeAll();
		obj.gridLastEnviHyReportStore.load({});
		obj.lblLastMonth.setText(obj.LastDate.dateFormat('Y年m月'));
	}
	obj.nextMonth_click = function (){
		obj.LastDate.setMonth(obj.LastDate.getMonth()+1);
		if(obj.LastDate.getMonth()==new Date().getMonth()){
			obj.LastDate.setMonth(obj.LastDate.getMonth()-1);
			return
		}
		
		obj.gridLastEnviHyReportStore.removeAll();
		obj.gridLastEnviHyReportStore.load({});
		obj.lblLastMonth.setText(obj.LastDate.dateFormat('Y年m月'));
	}
	
	
	obj.btnPrintLastBar_click = function(){
		var arrList = obj.gridLastSM.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "无选中记录，不能打印!");
			return;
		}
		var strPrinterName = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //取条码打印机名称
		if (strPrinterName=='') strPrinterName='Zebra';
		var strBarFormat = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodeType');  //取条码打印格式（条码样式）
		
		var Bar;
		Bar = new ActiveXObject("DHCMedBarCode.PrintBarEH");
		Bar.PrinterName = strPrinterName;  //打印机名称
		Bar.PrinterPort = "";            //打印机端口
		Bar.BarFormat   = strBarFormat;    //设置条码样式编号
		
		for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
			var objRec = arrList[rowIndex];
			
			var SpecimenNum  = objRec.get("SpecimenNum");
			var CenterNum    = objRec.get("CenterNum");
			var SurroundNum  = objRec.get("SurroundNum");
			var LocDesc      = objRec.get("LocDesc");
			var ItemDesc     = objRec.get("ItemDesc");
			var NormRange    = objRec.get("NormRange");
			var NormObject   = objRec.get("ItemObj");
			var ItemDate     = objRec.get("EHRDate");
			var BarCode      = objRec.get("EHRBarCode");
			
			Bar.vDeptDesc   = LocDesc;
			Bar.vNormRange  = NormRange;
			Bar.vNormObject = NormObject;
			Bar.vItemDate   = ItemDate;
			Bar.vItemDesc   = ItemDesc;
			Bar.vDeptDesc   = LocDesc;
			
			SpecimenNum = SpecimenNum*1;
			CenterNum   = CenterNum*1;
			SurroundNum = SurroundNum*1;
			for(var i = 1; i <= SpecimenNum; i++){
				//条码：8位检验码+2位标本编码
				var SubBarCode = '00' + i;
				SubBarCode = SubBarCode.substring(SubBarCode.length-2,SubBarCode.length);
				Bar.vBarCode = BarCode + SubBarCode;   //
				
				//项目名称，添加中心、周边及序号
				var SubItemNo = i;
				var SubItemDesc = '';
				if ((CenterNum>0)&&(i<=CenterNum)){
					SubItemDesc = "中心-" + SubItemNo;
				} else if ((SurroundNum>0)&&(i<=(SurroundNum+CenterNum))){
					SubItemDesc = "周边-" + SubItemNo;
				} else if ((CenterNum>0)||(SurroundNum>0)) {
					SubItemDesc = "参照-" + SubItemNo;
				} else {
					SubItemDesc = "检测-" + SubItemNo;
				}
				
				Bar.vItemDate   = ItemDate + '【' + SubItemDesc + '/' + SpecimenNum + '】';
				
				//条码打印输出
				Bar.PrintOut();
			}
		}
	}
	
	obj.btnPrintBar_click = function(){
		var arrList = obj.gridCurrSM.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "无选中记录，不能打印!");
			return;
		}
		
		var strPrinterName = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //取条码打印机名称
		if (strPrinterName=='') strPrinterName='Zebra';
		var strBarFormat = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodeType');  //取条码打印格式（条码样式）
		
		var Bar;
		Bar = new ActiveXObject("DHCMedBarCode.PrintBarEH");
		Bar.PrinterName = strPrinterName;  //打印机名称
		Bar.PrinterPort = "";              //打印机端口
		Bar.BarFormat   = strBarFormat;    //设置条码样式编号
	
		
		for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
			var objRec = arrList[rowIndex];
			
			var SpecimenNum  = objRec.get("SpecimenNum");
			var CenterNum    = objRec.get("CenterNum");
			var SurroundNum  = objRec.get("SurroundNum");
			var LocDesc      = objRec.get("LocDesc");
			var ItemDesc     = objRec.get("ItemDesc");
			var NormRange    = objRec.get("NormRange");
			var NormObject   = objRec.get("ItemObj");
			var ItemDate     = objRec.get("EHRDate");
			var BarCode      = objRec.get("EHRBarCode");
			
			Bar.vDeptDesc   = LocDesc;
			Bar.vNormRange  = NormRange;
			Bar.vNormObject = NormObject;
			Bar.vItemDate   = ItemDate;
			Bar.vItemDesc   = ItemDesc;
			Bar.vDeptDesc   = LocDesc;
			
			SpecimenNum = SpecimenNum*1;
			CenterNum   = CenterNum*1;
			SurroundNum = SurroundNum*1;
			for(var i = 1; i <= SpecimenNum; i++){
				//条码：8位检验码+2位标本编码
				var SubBarCode = '00' + i;
				SubBarCode = SubBarCode.substring(SubBarCode.length-2,SubBarCode.length);
				Bar.vBarCode = BarCode + SubBarCode;   //
				
				//项目名称，添加中心、周边及序号
				var SubItemNo = i;
				var SubItemDesc = '';
				if ((CenterNum>0)&&(i<=CenterNum)){
					SubItemDesc = "中心-" + SubItemNo;
				} else if ((SurroundNum>0)&&(i<=(SurroundNum+CenterNum))){
					SubItemDesc = "周边-" + SubItemNo;
				} else if ((CenterNum>0)||(SurroundNum>0)) {
					SubItemDesc = "参照-" + SubItemNo;
				} else {
					SubItemDesc = "检测-" + SubItemNo;
				}
				
				Bar.vItemDate   = ItemDate + '【' + SubItemDesc + '/' + SpecimenNum + '】';
				
				//条码打印输出
				Bar.PrintOut();
			}
		}
	}
	
	obj.btnDelete_click = function(){
		var arrList = obj.gridCurrSM.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "无选中记录，不能删除!");
			return;
		}
		Ext.MessageBox.confirm('提示', '确定删除？', function(btn){
			var str = new Array()
			if (btn=="yes") {
				for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
					var r = arrList[rowIndex];
					var ReportID=r.get("ReportID");
					var RepStatus=r.get("RepStatusDesc");
					if(RepStatus=="申请"){
						var flag = obj.ClsRepEnviHyReport.DeleteById(ReportID)
						if(flag<=0){
							//正常操作是不会发生的
							str[rowIndex] = "选中数据第"+(rowIndex+1)+"条删除失败！<br/>"
						}
					}else{
						str[rowIndex] = "选中数据第"+(rowIndex+1)+"条为非申请状态，不能删除！<br/>"
					}
				}
				if(str.length>0){
					ExtTool.alert("提示", str.join(""));
				}
				obj.ClearFormItem();
				obj.gridCurrEnviHyReportStore.load({});
			}
		});
	}
	obj.ClearFormItem = function(){
		obj.RecRowID = "";
		//Common_SetValue("cboLoc",'');
		Common_SetValue("cboNorm",'');
		Common_SetValue("cboItem",'');
		Common_SetValue("txtItemObj",'');
		Common_SetValue("cboSpecType",'');
		Common_SetValue("txtSpecNum",'');
		Common_SetValue("txtResume",'');
		//Common_SetValue("txtDate",'');  //fix bug 184046 20160314保存一条申请单后，检测日期不再清空 
		//Add By LiYang 2014-07-04 FixBug:1804 医院感染管理-环境卫生学监测-科室申请单-再次选中申请单记录，复选框仍然被勾选
		obj.gridCurrSM.clearSelections();
		
	}
	obj.gridCurrEnviHyReport_rowclick = function(){
		var index=arguments[1];
		var objRec = obj.gridCurrEnviHyReport.getStore().getAt(index);
		if (objRec.get("RepStatusDesc")!="申请")
		{
			return
		}
		if (objRec.get("ReportID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ReportID");
			Common_SetValue("cboLoc",objRec.get("LocID"),objRec.get("LocDesc"));
			Common_SetValue("cboItem",objRec.get("ItemID"),objRec.get("ItemDesc"));
			obj.cboNorm.getStore().removeAll();
			obj.cboNorm.getStore().load({});
			Common_SetValue("cboNorm",objRec.get("NormID"),objRec.get("NormRange"));
			Common_SetValue("txtItemObj",objRec.get("ItemObj"));
			Common_SetValue("cboSpecType",objRec.get("SpecimenTypeID"),objRec.get("SpecimenTypeDesc"));
			Common_SetValue("txtSpecNum",objRec.get("SpecimenNum"));
			Common_SetValue("txtResume",objRec.get("RepResume"));
			Common_SetValue("txtDate",objRec.get("EHRDate"));
		}
	}
	
	obj.cboItem_select = function(){
		obj.cboNorm.getStore().removeAll();
		obj.cboNorm.getStore().load({});
		Common_SetValue("cboNorm",'','');
		Common_SetValue("cboSpecType",'','');
		Common_SetValue("txtSpecNum",'');
		Common_SetValue("txtItemObj",'');
	}
	
	obj.cboNorm_select = function(){
		var NormRangeId = Common_GetValue('cboNorm');
  		var NormRangeRecord = obj.cboNorm.getStore().getById(NormRangeId)
		Common_SetValue("cboSpecType",NormRangeRecord.get("SpecimenTypeID"),NormRangeRecord.get("SpecimenType"));
  		Common_SetValue("txtSpecNum",NormRangeRecord.get("SpecimenNum"));
  		Common_SetValue("txtItemObj",NormRangeRecord.get("ItemObj"));
  	}
	
	obj.cboLoc_select = function(){
		obj.cboItem.getStore().removeAll();
		obj.cboItem.getStore().load({});
		Common_SetValue("cboItem",'','');
		obj.cboItem_select();
		
		obj.gridCurrEnviHyReportStore.load({});
		obj.gridLastEnviHyReportStore.load({});
	}
	
	obj.btnCopy_click = function(){
		var arrList = obj.gridLastSM.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "无选中记录，不能复制!");
			return;
		}
		Ext.MessageBox.confirm('提示', '确定复制？', function(btn){
			var str = new Array()
			if (btn=="yes") {
				for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
					var r = arrList[rowIndex];
					var LocID = Common_GetValue('cboLoc');
					var ItemID = r.get("ItemID");
					var normID = r.get("NormID");
					var ItemObj = r.get("ItemObj");
					var DetectDate = new Date().dateFormat('Y-m-d');
					var SpecimenType = r.get("SpecimenTypeID");
					var SpecimenNum = r.get("SpecimenNum");
					var Resume = r.get("RepResume");
					var ReportID = '';
					var inputStr = ReportID;
					inputStr = inputStr + CHR_1 + LocID;
					inputStr = inputStr + CHR_1 + ItemID;
					inputStr = inputStr + CHR_1 + normID;
					inputStr = inputStr + CHR_1 + ItemObj;
					inputStr = inputStr + CHR_1 + DetectDate;
					inputStr = inputStr + CHR_1 + SpecimenType;
					inputStr = inputStr + CHR_1 + 0;
					inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
					inputStr = inputStr + CHR_1 + 1;
					inputStr = inputStr + CHR_1 + Resume;
					inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];
					var  flg = obj.ClsRepEnviHyReportSrv.SaveRepRec(inputStr,CHR_1 + "," + CHR_2);
					if (parseInt(flg)<=0) {
						str[rowIndex] = "选中数据第"+(rowIndex+1)+"条复制失败！<br/>"
					}
				}
				if(str.length>0){
					ExtTool.alert("提示", str.join(""));
				}else{
					obj.gridCurrEnviHyReportStore.load({});
				}
			}
		});
		
	}
	obj.gridLastEnviHyReport_rowdblclick = function() {
		var str = new Array()
		var rowIndex = arguments[1];
		var r = obj.gridLastEnviHyReport.getStore().getAt(rowIndex);
		var LocID = Common_GetValue('cboLoc');
		var ItemID = r.get("ItemID");
		var normID = r.get("NormID");
		var ItemObj = r.get("ItemObj");
		var DetectDate = new Date().dateFormat('Y-m-d');
		var SpecimenType = r.get("SpecimenTypeID");
		var SpecimenNum = r.get("SpecimenNum");
		var Resume = r.get("RepResume");
		var ReportID = '';
		var inputStr = ReportID;
		inputStr = inputStr + CHR_1 + LocID;
		inputStr = inputStr + CHR_1 + ItemID;
		inputStr = inputStr + CHR_1 + normID;
		inputStr = inputStr + CHR_1 + ItemObj;
		inputStr = inputStr + CHR_1 + DetectDate;
		inputStr = inputStr + CHR_1 + SpecimenType;
		inputStr = inputStr + CHR_1 + 0;
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + 1;
		inputStr = inputStr + CHR_1 + Resume;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];
		var  flg = obj.ClsRepEnviHyReportSrv.SaveRepRec(inputStr,CHR_1 + "," + CHR_2);
		if (parseInt(flg)<=0) {
			str[rowIndex] = "复制失败！<br/>"
		}
		obj.gridCurrEnviHyReportStore.load({});
	}
	obj.btnSave_click = function(){
		var LocID = Common_GetValue('cboLoc');
		var ItemID = Common_GetValue('cboItem');
		var normID = Common_GetValue('cboNorm');
		var ItemObj = Common_GetValue('txtItemObj');
		var DetectDate = Common_GetValue('txtDate');
		var SpecimenType = Common_GetValue('cboSpecType');
		var SpecimenNum = Common_GetValue('txtSpecNum');
		var Resume = Common_GetValue('txtResume');
		if (!Resume) Resume='';
		var errInfo = '';
		if (normID == '') {
			errInfo = errInfo + '检测范围为空!<br>'
		}
		if (ItemID == '') {
			errInfo = errInfo + '检测项目为空!<br>'
		}
		if (ItemObj == '') {
			errInfo = errInfo + '项目对象为空!<br>'
		}
		if (DetectDate == '') {
			errInfo = errInfo + '检测日期为空!<br>'
		}
		if (SpecimenType == '') {
			errInfo = errInfo + '标本类型为空!<br>'
		}
		if (errInfo != '') {
			ExtTool.alert("提示",errInfo);
			return;
		}
		var ReportID = '';
		if(obj.RecRowID){
			ReportID = obj.RecRowID;
		}
		var inputStr = ReportID;									//1-报告ID
		inputStr = inputStr + CHR_1 + LocID;  						//2-申请科室
		inputStr = inputStr + CHR_1 + ItemID;						//3-项目ID
		inputStr = inputStr + CHR_1 + normID;  						//4-检测范围ID
		inputStr = inputStr + CHR_1 + ItemObj;						//5-项目对象
		inputStr = inputStr + CHR_1 + DetectDate;   				//6-检测日期
		inputStr = inputStr + CHR_1 + SpecimenType;  				//7-标本类型
		inputStr = inputStr + CHR_1 + 0;				        	//8-发放标本数量
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];   	//9-申请人
		inputStr = inputStr + CHR_1 + 1;  							//10-申请状态
		inputStr = inputStr + CHR_1 + Resume;						//11-备注
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];  //12-登陆科室，登陆用户
		var flg = obj.ClsRepEnviHyReportSrv.SaveRepRec(inputStr,CHR_1 + "," + CHR_2);
		if (parseInt(flg)<=0) {
			ExtTool.alert("提示","保存数据失败!Error=" + flg);
			return false;
		}
		obj.ClearFormItem();
		obj.gridCurrEnviHyReportStore.load({});
		var storeNum = obj.gridCurrEnviHyReportStore.getCount();
		obj.gridCurrEnviHyReportStore.getAt(storeNum-1);
		//obj.gridCurrEnviHyReport.getSelectionModel().selectLastRow();
	}
	
    obj.ViewEnviHyReport = function(ReportID){
		InputEnviHyRst(ReportID,0);
	}
}

