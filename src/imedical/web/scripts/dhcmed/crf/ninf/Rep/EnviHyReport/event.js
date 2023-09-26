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
		obj.cboSpecimenType.setDisabled(true);
		obj.txtSpecimenNum.setDisabled(true);
		
		obj.gridEnviHyReportStore.load({});
		obj.lastgridEnviHyReportStore.load({});
		obj.cboLoc.on("select",obj.cboLoc_select,obj);		//add by yanjifu  20140411
		obj.txtItem.on("select",obj.txtItem_select,obj);
		obj.cboNormRange.on("select",obj.cboNormRange_select,obj);
		obj.lastgridEnviHyReport.on("rowdblclick",obj.lastgridEnviHyReport_rowdblclick,obj);
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.gridEnviHyReport.on("rowclick",obj.gridEnviHyReport_rowclick,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCopy.on("click",obj.btnCopy_click,obj);
		obj.btnPrintBar.on("click",obj.btnPrintBar_click,obj);
		obj.lastMonth.on("click",obj.lastMonth_click,obj);
		obj.nextMonth.on("click",obj.nextMonth_click,obj);
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnPrintRep.on("click",obj.btnPrintRep_click,obj);
  	};
	
  	obj.btnPrintRep_click = function(){
  		var arrList = obj.sm.getSelections();
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
				var row = obj.gridEnviHyReport.getStore().indexOf(objRec);
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
		obj.gridEnviHyReportStore.load({});
		obj.lastgridEnviHyReportStore.load({});
	}
	obj.lastMonth_click = function(){
		obj.theDate.setMonth(obj.theDate.getMonth()-1);
		obj.txtDateLastMonth = new Ext.form.DateField({
			id : 'txtDateLastMonth'
			,fieldLabel : '检测月份'
			,plugins: 'monthPickerPlugin'
			,editable : false
			,width : 10
			,anchor : '100%'
			,value :obj.theDate.dateFormat('Y-m')
		});
		obj.lastgridEnviHyReportStore.load({});
	}
	obj.nextMonth_click = function (){
		obj.theDate.setMonth(obj.theDate.getMonth()+1);
		//if的作用是为了使历史数据最多到了当月的前一月
		if(obj.theDate.getMonth()==new Date().getMonth()){
			obj.theDate.setMonth(obj.theDate.getMonth()-1);
			return
		}
		obj.txtDateLastMonth = new Ext.form.DateField({
			id : 'txtDateLastMonth'
			,fieldLabel : '检测月份'
			,plugins: 'monthPickerPlugin'
			,editable : false
			,width : 10
			,anchor : '100%'
			,value :obj.theDate.dateFormat('Y-m')
		});
		obj.lastgridEnviHyReportStore.load({});
	}
	obj.btnPrintBar_click = function(){
		var arrList = obj.sm.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("提示", "无选中记录，不能打印!");
			return;
		}
		
		var Bar="";
		Bar = new ActiveXObject("DHCMedBarCode.PrintBarEH");
		Bar.PrinterName = "tiaoma";      //打印机名称
		Bar.PrinterPort = "";            //打印机端口
		Bar.BarFormat = "1";             //条码样式编号
		Bar.SetPrinter();                //设置打印机
		
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
	
	hrefClick = function(repID,SpecimenNum,itemResult){
		var itemResultArray = itemResult.split(",")
		var objGrid = Ext.getCmp("gridEnviHyReport");
		var objRecArr = objGrid.getSelectionModel().getSelections();
		var objRec = objRecArr[0];
		var htmlStr = ""
		htmlStr += "<table border='0' align='center'>"
		for(var i=1;i<=objRec.get("SpecimenNum");i++){
			if(itemResult!=""){
				htmlStr +="<tr><td>结果"+i+"-"+objRec.get("EHRBarCode")+i+"：</td><td><input type='text' onkeyup='value=value.replace(/[^\\d]/g,\"\")'  value='"+itemResultArray[i-1]+"' id='"+("itemResult"+i)+"'/></td></tr>"
			}else{
				htmlStr +="<tr><td>结果"+i+"-"+objRec.get("EHRBarCode")+i+"：</td><td><input type='text' onkeyup='value=value.replace(/[^\\d]/g,\"\")'  id='"+("itemResult"+i)+"'/></td></tr>"
			}
		}
		htmlStr +="</table>"
		obj.grid_RowEditer(objRec,4,htmlStr)
	}

	obj.btnDelete_click = function(){
		var arrList = obj.sm.getSelections();
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
				obj.gridEnviHyReportStore.load({});
			}
		});
	}
	obj.ClearFormItem = function(){
		obj.RecRowID = "";
		//Common_SetValue("cboLoc",'');
		Common_SetValue("cboNormRange",'');
		Common_SetValue("txtItem",'');
		Common_SetValue("txtItemObj",'');
		Common_SetValue("cboSpecimenType",'');
		Common_SetValue("txtSpecimenNum",'');
		Common_SetValue("txtResume",'');
	}
	obj.gridEnviHyReport_rowclick = function(){
		var index=arguments[1];
		var objRec = obj.gridEnviHyReport.getStore().getAt(index);
		if (objRec.get("RepStatusDesc")!="申请")
		{
			return
		}
		if (objRec.get("ReportID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ReportID");
			Common_SetValue("txtDate",objRec.get("EHRDate")); //add by likai for bug:3924
			Common_SetValue("cboLoc",objRec.get("LocID"),objRec.get("LocDesc"));
			Common_SetValue("cboNormRange",objRec.get("NormID"),objRec.get("NormRange"));
			Common_SetValue("txtItem",objRec.get("ItemID"),objRec.get("ItemDesc"));
			Common_SetValue("txtItemObj",objRec.get("ItemObj"));
			Common_SetValue("cboSpecimenType",objRec.get("SpecimenTypeID"),objRec.get("SpecimenTypeDesc"));
			Common_SetValue("txtSpecimenNum",objRec.get("SpecimenNum"));
			Common_SetValue("txtResume",objRec.get("RepResume"));
		}
	}
	obj.txtItem_select = function(){
		obj.cboNormRange.getStore().load({});
		Common_SetValue("cboNormRange",'');
		Common_SetValue("cboSpecimenType",'');	
		Common_SetValue("txtSpecimenNum",'');
		Common_SetValue("txtItemObj",'');
	}
	
	obj.cboNormRange_select = function(){//选择检测范围，关联项目对象、标本类型、标本个数20140429 yanjifu
		var NormRangeId = Common_GetValue('cboNormRange');
  		var NormRangeRecord = obj.cboNormRange.getStore().getById(NormRangeId)
		Common_SetValue("cboSpecimenType",NormRangeRecord.get("SpecimenTypeID"),NormRangeRecord.get("SpecimenTypeDesc"));
  		Common_SetValue("txtSpecimenNum",NormRangeRecord.get("SpecimenNum"));
  		Common_SetValue("txtItemObj",NormRangeRecord.get("ItemObj"));
  	}
	
	obj.cboLoc_select = function(){		//add by yanjifu   20140411
		obj.gridEnviHyReportStore.load({});
		//obj.lastgridEnviHyReportStore.load({});
	}
	/*
	obj.cboNormRange_select = function(combo,record,index) {
		var objItem = obj.ClsDicEnviHyItmMapSrv.getObjItem(combo.getValue())
		if(objItem!=0){
			obj.txtItem.setValue(objItem.EHIDesc);
		}else{
			alert("项目没与标准关联！")
			return
		}
	}*/
	obj.btnCopy_click = function(){
		var arrList = obj.lastsm.getSelections();
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
					inputStr = inputStr + CHR_1 + SpecimenNum;
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
					obj.gridEnviHyReportStore.load({});
				}
			}
		});
		
	}
	obj.lastgridEnviHyReport_rowdblclick = function() {
		var str = new Array()
		var rowIndex = arguments[1];
		var r = obj.lastgridEnviHyReport.getStore().getAt(rowIndex);
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
		inputStr = inputStr + CHR_1 + SpecimenNum;
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + 1;
		inputStr = inputStr + CHR_1 + Resume;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];
		var  flg = obj.ClsRepEnviHyReportSrv.SaveRepRec(inputStr,CHR_1 + "," + CHR_2);
		if (parseInt(flg)<=0) {
			str[rowIndex] = "复制失败！<br/>"
		}
		obj.gridEnviHyReportStore.load({});
	}
	obj.btnSave_click = function(){
		var LocID = Common_GetValue('cboLoc');
		var ItemID = Common_GetValue('txtItem');
		var normID = Common_GetValue('cboNormRange');
		var ItemObj = Common_GetValue('txtItemObj');
		var DetectDate = Common_GetValue('txtDate');
		var SpecimenType = Common_GetValue('cboSpecimenType');
		var SpecimenNum = Common_GetValue('txtSpecimenNum');
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
		//add by likai for bug:3925
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		var flg = Common_CompareDate(DetectDate,CurrDate);
		if (!flg) {
			errInfo = errInfo + '检测日期不能大于当前日期!<br>'
		}
	
		if (SpecimenType == '') {
			errInfo = errInfo + '标本类型为空!<br>'
		}
		if (SpecimenNum == '') {
			errInfo = errInfo + '标本数量为空!<br>'
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
		inputStr = inputStr + CHR_1 + SpecimenNum;					//8-标本数量
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
		obj.gridEnviHyReportStore.load({});
		var storeNum = obj.gridEnviHyReportStore.getCount();
		obj.gridEnviHyReportStore.getAt(storeNum-1);
		//obj.gridEnviHyReport.getSelectionModel().selectLastRow();
	}
	obj.grid_RowEditer = function(objRec,ArgStat,htmlStr) {
		obj.objRec=objRec;
		obj.stat = ArgStat;
		obj.SpecimenNum = obj.objRec.get("SpecimenNum");
		var h = obj.SpecimenNum
		if(h>9){
			h = 9
		}
		var winGridRowEditer = Ext.getCmp('grid_RowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'grid_RowEditer',
				height : (100+30*h),
				width :360, 
				closeAction: 'close',
				modal : true,
				title : '结果录入',
				layout : 'fit',
				resizable : false,
				items: [
					{
						layout : 'form',
						labelAlign : 'center',
						labelWidth : 70,
						autoScroll : true,
						frame : true,
						html:htmlStr
					}
				],bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "grid_RowEditer_btnUpdate",
						iconCls : 'icon-update',
						width : 60,
						text : "保存",
						listeners : {
							'click' : function(){
								var resultArray = new Array();
								var EHRAutoIsNorm = '合格';
								for(var i = 0 ;i<obj.SpecimenNum;i++){
									resultArray[i] = document.getElementById("itemResult"+(i+1)).value
									/*结果录入的是菌落数量*/
									theResult = obj.ClsRepEnviHyReportSrv.getResult(obj.objRec.get('ReportID'),(resultArray[i]*1));
									if(((theResult*1).toFixed(3)>(obj.objRec.get("NormMax")*1))){//||(theResult.toFixed(3)<(obj.objRec.get("NormMin")*1))){
										EHRAutoIsNorm = '不合格';
									}
								}
								var inputStr = obj.objRec.get("ReportID");
								inputStr = inputStr + CHR_1 + resultArray.join(",");
								inputStr = inputStr + CHR_1 + EHRAutoIsNorm;
								inputStr = inputStr + CHR_1 + obj.stat;
								inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
								inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
								var  flg = obj.ClsRepEnviHyReport.SetResultIsNorm(inputStr,CHR_1);
								if (parseInt(flg)<=0) {
									ExtTool.alert("提示","保存数据失败!Error=" + flg);
									return false;
								}
								Common_LoadCurrPage("gridEnviHyReport");
								winGridRowEditer.close();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "grid_RowEditer_btnCancel",
						iconCls : 'icon-exit',
						width : 60,
						text : "关闭",
						listeners : {
							'click' : function(){
								winGridRowEditer.close();
							}
						}
					})
				]
			});
		}
		winGridRowEditer.show();
	}
}

