function InitViewScreenEvent(obj)
{
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var _DHCBPCEquip=ExtTool.StaticServerObject('web.DHCBPCEquip');
	var userId=session['LOGON.USERID'];
	var equipAbbre=""
	var SelectedRowID = 0;
	var preRowID=0;	 
	//var timeReg=/([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])/
	//var timeReg=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
	obj.LoadEvent = function(args)
	{
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBPCEquip';
			param.QueryName = 'FindEquip';
			param.Arg1 = obj.equipType.getValue();
			param.Arg2 = obj.buyDate.getRawValue();
			param.Arg3 = obj.equipHosNo.getValue();
			param.Arg4 = obj.equipSeqNo.getValue();	
			param.Arg5 = obj.equipStatus.getValue();	
			param.ArgCnt = 5;
		});
		obj.retGridPanelStore.load({});
	};
	
	obj.retGridPanel_rowclick = function()
	{
	  var rc = obj.retGridPanel.getSelectionModel().getSelected();
	  SelectedRowID=rc.get("tBPCERowId");
	  if (rc){ 
	  	if(preRowID!=SelectedRowID){
		    obj.tRowId.setValue(rc.get("tBPCERowId"));
		    obj.equipType.setValue(rc.get("tBPCEBPCEquipModelDr")); //设备型号
		    obj.manufactName.setValue(rc.get("tBPCEBPCEquipMFDr")); //厂家
		    obj.buyDate.setValue(rc.get("tBPCEPurchaseDate"));
		    obj.buyMoney.setValue(rc.get("tBPCEPurchaseAmount"));
		    obj.installPersonOut.setValue(rc.get("installPersonOut"));
		    obj.guarYears.setValue(rc.get("tBPCEWarrantyYear"));
		    obj.equipSeqNo.setValue(rc.get("tBPCENo"));
		    obj.equipHosNo.setValue(rc.get("tBPCECode"));
		    obj.note.setValue(rc.get("tBPCENote"));
		    obj.equipStatus.setValue(rc.get("tBPCEStatus"));
		    obj.bedNo.setValue(rc.get("tBPBEBedDr"));
		    var installUserID=rc.get("installPerIdLtIn");
		    var installUserIDArray=installUserID.split(",")
		    var installUserName=rc.get("installPerNameLtIn")
		    var installUserNameArray=installUserName.split(",")
		    var setValueInstall=""
		    for(var i=0;i<installUserIDArray.length;i++){
			   if(setValueInstall==""){
				   setValueInstall=installUserIDArray[i]+"!"+installUserNameArray[i];
				}else{
					setValueInstall=setValueInstall+","+installUserIDArray[i]+"!"+installUserNameArray[i];
				}
			 }
		    obj.installPersonIn.setDefaultValue(setValueInstall)
		    var keepUserID=rc.get("keepPerIdList");
		    var keepUserIDArray=keepUserID.split(",")
		    var keepUserName=rc.get("keepPerNameList")
		    var keepUserNameArray=keepUserName.split(",")
		    var setValueKeep=""
		    for(var i=0;i<keepUserIDArray.length;i++){
			   if(setValueKeep==""){
				   setValueKeep=keepUserIDArray[i]+"!"+keepUserNameArray[i];
				}else{
					setValueKeep=setValueKeep+","+keepUserIDArray[i]+"!"+keepUserNameArray[i];
				}
			 }
		    obj.takeCarePerson.setDefaultValue(setValueKeep)
	 		equipAbbre=rc.get("tBPCEBPCEAbbre")
	 		preRowID=SelectedRowID;
		}else{
			ClearData(obj)
			SelectedRowID = 0;
		    preRowID=0;
		};
 		
	  }
	};
	
	obj.addbutton_click = function()
	{
		// 设备名称
		var equipType=obj.equipType.getValue();
		if(equipType==""){
			ExtTool.alert("提示","设备名称不能为空");
			return;
		};
		// 床位号
		var bedNo= obj.bedNo.getValue();
		// 厂家名称
		var manufactName=obj.manufactName.getValue();
		// 设备状态
		var status=obj.equipStatus.getValue();
		// 购买日期
		var purchaseDate=obj.buyDate.getRawValue();
		// 购买金额
		var purchaseAmount=obj.buyMoney.getValue();
		// 保修年限
		var guarYears=obj.guarYears.getValue();
		// 安装人员（内）
		var installPersonIn=obj.installPersonIn.getValue();
		// 安装人员（外）
		var installPersonOut=obj.installPersonOut.getValue();
		// 保管人员
		var takeCarePerson=obj.takeCarePerson.getValue();
		// 设备序列号
		var equipSeqNo=obj.equipSeqNo.getValue();
		// 院内编号
		var equipHosNo=obj.equipHosNo.getValue();
		// 备注
		var note=obj.note.getValue();
		//alert(note)		
		//return;
		var ret=_DHCBPCEquip.InsertEquip(equipHosNo,equipAbbre,equipSeqNo,"","",status,note,equipType,"","","","",purchaseDate,purchaseAmount,guarYears,installPersonIn,installPersonOut,takeCarePerson,bedNo);
		//alert(ret)
		if(ret!=0)
		{
			ExtTool.alert("提示",ret);
			return;
		}else{ExtTool.alert("提示","新增成功");}
		ClearData(obj)
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	
	obj.updatebutton_click = function()
	{
		var rowId=obj.tRowId.getValue();
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if (rowId==""){
			ExtTool.alert("提示","请选择一行记录");
			return;
		}
		// 设备名称
		var equipType=obj.equipType.getValue();
		if(equipType==""){
			ExtTool.alert("提示","设备名称不能为空");
			return;
		};
		// 床位号
		var bedNo= rc.get("tBPBEBedDr")
		// 厂家名称
		var manufactName=obj.manufactName.getValue();
		// 设备状态
		var status=obj.equipStatus.getValue();
		// 购买日期
		var purchaseDate=obj.buyDate.getRawValue();
		// 购买金额
		var purchaseAmount=obj.buyMoney.getValue();
		// 保修年限
		var guarYears=obj.guarYears.getValue();
		// 安装人员（内）
		var installPersonIn=obj.installPersonIn.getValue();
		// 安装人员（外）
		var installPersonOut=obj.installPersonOut.getValue();
		// 保管人员
		var takeCarePerson=obj.takeCarePerson.getValue();
		// 设备序列号
		var equipSeqNo=obj.equipSeqNo.getValue();
		// 院内编号
		var equipHosNo=obj.equipHosNo.getValue();
		// 备注
		var note=obj.note.getValue();
		if(bedNo!=""){
			if(status!="US"){
				ExtTool.alert("提示","请先解除床位绑定");
				return;
			}
		}else{
			if(status=="US"){
				ExtTool.alert("提示","请先将机器与床位做绑定");
				return;
			}
			
		};
		if(rc.get("tBPCEStatus")=="US"){
			
			equipAbbre=rc.get("tBPCEDesc")
		}
		//alert(note)		
		//return;
		var ret=_DHCBPCEquip.UpdateEquip(rowId,equipHosNo,equipAbbre,equipSeqNo,"","",status,note,equipType,"","","","",purchaseDate,purchaseAmount,guarYears,installPersonIn,installPersonOut,takeCarePerson,bedNo);
		if(ret!=0)
		{
			ExtTool.alert("提示",ret);
			return;
		}else{ExtTool.alert("提示","更新成功");}
		ClearData(obj)
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	
	obj.maintainBtn_click=function()
	{
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if(selectObj){
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.winScreen.show();
		}else{
			ExtTool.alert("提示","请先选中一行!");
		}
	};
	
	obj.deletebutton_click=function(){
		//alert()
		var RowId=obj.tRowId.getValue();
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(RowId=="")
		{
			ExtTool.alert("提示","ID为空!请选择一行数据");
			return;
		}
		if(rc.get("tBPCEStatus")=="US"){
			ExtTool.alert("提示","在用的设备不能删除，请先解除床位绑定");
			return;
		}
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCBPCEquip.DeleteEquip(RowId);
			if(ret!=0)
			{
				ExtTool.alert("提示","删除失败");	
				return;
			}else{ExtTool.alert("提示","删除成功");}
			ClearData(obj)
			obj.retGridPanelStore.removeAll();
			obj.retGridPanelStore.load({});
	  	});
	};
	
	obj.selectbutton_click=function(){
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	//厂家选择时
	obj.manufactName_select=function(){
		if(obj.manufactName.getValue()!=""){
			obj.equipTypeStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCBPCEquipModel';
				param.QueryName = 'FindEModel';
				param.Arg1 = obj.manufactName.getValue();
				param.ArgCnt = 1;
			});
			obj.equipTypeStore.load({});	
		}else{
			obj.equipTypeStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCBPCEquipModel';
				param.QueryName = 'FindEModel';
				param.Arg1 = "";
				param.ArgCnt = 1;
			});
			obj.equipTypeStore.load({});
		}
	};
	function ClearData(obj){
	    obj.tRowId.setValue("");
	    obj.equipType.setValue("");
	    obj.manufactName.setValue("");
	    obj.bedNo.setValue("");
	    obj.buyDate.setValue("");
	    obj.buyMoney.setValue("");
	    obj.note.setValue("");
	    obj.guarYears.setValue("");
	    obj.installPersonOut.setValue("");
	    obj.installPersonIn.setValue("");
	    obj.takeCarePerson.setValue("");
	    obj.equipSeqNo.setValue("");
	    obj.equipHosNo.setValue("");
	    obj.equipStatus.setValue("");
	};
	
	
	obj.equipType_select=function(store, record, index){
		equipAbbre=obj.equipTypeStore.getAt(index).get("tBPCEMAbbreviation")
		//alert(equipAbbre)
	};

	obj.ExportExlBtn_click = function(){
		var rc =obj.retGridPanel.getSelectionModel().getSelected();
		if(!rc){return;};
		var xlsExcel,xlsSheet,xlsBook;
	    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	    var LeftFooter,CenterFooter,RightFooter;
	    var path,fileName;
	    path = GetFilePath();
	    //alert(path)
	    fileName=path + "DHCBPEquip.xls";
	    xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName);
		xlsSheet = xlsBook.ActiveSheet;
	    xlsSheet.cells(2,2)=rc.get("tBPCEDesc");//设备类型
	    xlsSheet.Rows(2).RowHeight=0
	    xlsSheet.cells(3,2)=rc.get("tBPCEBPCEquipMFDesc");//厂家名称
	    xlsSheet.cells(4,2)=rc.get("tBPCEBPCEquipModel") //"设备型号"
	    xlsSheet.cells(5,2)="'"+rc.get("tBPCENo") //"设备序列号";
	    xlsSheet.cells(6,2)="'"+rc.get("tBPCECode")//"设备院内编号";
	    xlsSheet.cells(7,2)="'"+rc.get("tBPCEPurchaseDate")//"购买时间";
	    var purAmmount=rc.get("tBPCEPurchaseAmount")
	    if(purAmmount!=""){purAmmount=purAmmount+"万"}
	    xlsSheet.cells(8,2)=purAmmount//"购买金额";
	    xlsSheet.cells(9,2)=rc.get("installPerNameLtIn")//"安装人";
	    xlsSheet.cells(10,2)=rc.get("keepPerNameList")//"保管人";
	    if(rc.get("tBPCEWarrantyYear")!=""){
		    xlsSheet.cells(11,2)=rc.get("tBPCEWarrantyYear")+"年"//"保修年限";
		}
	    xlsSheet.cells(12,2)=rc.get("tBPCENote")//"备注";
	    
	    var savefileName="D:\\"+getExcelFileName()+".xls"
	    //alert(savefileName)
		xlsSheet.SaveAs(savefileName);
		alert("文件已导入到"+savefileName);
	    //xlsSheet.PrintPreview;
		//xlsSheet.PrintOut();
	    xlsSheet = null;
	    xlsBook.Close(savechanges=false)
	    xlsBook = null;
	    xlsExcel.Quit();
	    xlsExcel = null;
	};
	function GetFilePath()
	{
		var path=_DHCLCNUREXCUTE.GetPath();
		return path;
	};
	function getExcelFileName() {   
		var d = new Date();   
		var curYear = d.getYear();   
		var curMonth = "" + (d.getMonth() + 1);   
		var curDate = "" + d.getDate();   
	    var curHour = "" + d.getHours();   
	    var curMinute = "" + d.getMinutes();   
	    var curSecond = "" + d.getSeconds();   
	    if (curMonth.length == 1) {   
	       curMonth = "0" + curMonth;   
	    }   
	    if (curDate.length == 1) {   
	       curDate = "0" + curDate;   
	    }   
	    if (curHour.length == 1) {   
	        curHour = "0" + curHour;   
	   }   
	    if (curMinute.length == 1) {   
	        curMinute = "0" + curMinute;   
	    }   
	    if (curSecond.length == 1) {   
	        curSecond = "0" + curSecond;   
	    }   
	    var fileName = "设备基本信息" + "_" + curYear + curMonth + curDate + "_"   
	            + curHour + curMinute + curSecond + ".csv";   
	    //alert(fileName);   
	    return fileName;   
	}   

	//判断时间格式
}

function InitwinScreenEvent(obj){
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var parent=objControlArry['ViewScreen'];
	var _DHCBPEquipMaintain=ExtTool.StaticServerObject('web.DHCBPEquipMaintain');
	var userId=session['LOGON.USERID']
	var SelectedRowID = 0;
	var preRowID=0;	 
	obj.LoadEvent = function(args){
		var data = arguments[0][0];
		//alert(data)
		if(data){
			//设备信息：设备Rowid^床位号^设备序列号^设备型号^设备状态
			var equipInfo=data.get("tBPCERowId")+"^"+data.get("tBPBEBed")+"^"+data.get("tBPCENo")+"^"+data.get("tBPCEBPCEquipModel")+"^"+data.get("tBPCEStatusD")
			//alert(equipInfo)
			obj.winEquipInfo.setValue(equipInfo);
			obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCBPEquipMaintain';
				param.QueryName = 'FindBPEquipMaintain';
				param.Arg1 = data.get("tBPCERowId")
				param.Arg2 = data.get("tBPCEBPCEquipModelDr");	
				param.ArgCnt = 2;
			});
			obj.retGridPanelStore.load({});
		}	
	}
		//取消功能
	obj.winBtnCancle_click=function()
	{		
		obj.winScreen.close();
	}
	obj.winBtnSave_click=function()
	{
		var txtNull=""
		//设备id
		var equipInfo=obj.winEquipInfo.getValue();
		var equipInfoArray=equipInfo.split("^");
		var equipId=equipInfoArray[0];
		//更换部件
		var equipPartdr=obj.winEquipReplace.getValue();
		//维护时间
		var maintainDate=obj.winMaintainDate.getRawValue()
		if(maintainDate==""){
			ExtTool.alert("提示","参加人不能为空!");
			return;
		}
		//维护内容
		var maintaindesc=obj.winMainDesc.getValue()
		//维护费用
		var mainMoney=obj.winMaintainMoney.getValue()
		//参加人(院内)
		var personIn=obj.winPersonMIn.getValue()
		if(personIn==""){
			ExtTool.alert("提示","参加人不能为空!");
			return;
		}
		//参加人(院外)
		var personOut=obj.winPersonMOut.getValue();
		//备注
		var note= obj.winNote.getValue()
		var info =equipId+"^"+equipPartdr+"^"+maintaindesc+"^^"+maintainDate+"^^^^"+note+"^"+mainMoney+"^"+userId+"^"+personIn+"^"+personOut
		try
		{
			//插入操作
			if(obj.winTxtRowId.getValue()=="")
			{
				var ret = _DHCBPEquipMaintain.InsertBPEquipMaintain(info);
				if(ret!=0)
				{
					ExtTool.alert("提示","新增失败");
					return;
				}else{ExtTool.alert("提示","新增成功");}
				obj.retGridPanelStore.removeAll();
				obj.retGridPanelStore.load({});
			}
			else  //更新操作
			{
				var oriRowId=obj.winTxtRowId.getValue();
				info=oriRowId+"^"+info;
				var ret=_DHCBPEquipMaintain.UpdateBPEquipMaintain(info)
				if(ret!=0)
				{
					ExtTool.alert("提示","更新失败");
					return;
				}else{ExtTool.alert("提示","更新成功");}
				obj.retGridPanelStore.removeAll();
				obj.retGridPanelStore.load({});
			}
		}
		catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	obj.retGridPanel1_rowclick = function()
	{
	  var rc = obj.retGridPanel1.getSelectionModel().getSelected();
	  if (rc){
		SelectedRowID=rc.get("tRowId"); 
		if(preRowID!=SelectedRowID){
		    obj.winTxtRowId.setValue(rc.get("tRowId"));
		    obj.winEquipReplace.setValue(rc.get("tDBPEquipPartDesc"));
		    obj.winMaintainDate.setValue(rc.get("StartDate"));
		    obj.winMainDesc.setValue(rc.get("tBPEMType"));
		    obj.winMaintainMoney.setValue(rc.get("tBPEMExpense"));
		    obj.winNote.setValue(rc.get("Note"));
		    obj.winPersonMOut.setValue(rc.get("userNameOut"));
	    
		    //参加人
		    var userid=rc.get("userIdList")
		    var useridArray=userid.split(",")
		    var UserName=rc.get("userNameList")
		    var UserNameArray=UserName.split(",")
		    var setUser=""
		    for(var i=0;i<useridArray.length;i++){
			   if(setUser==""){
				   setUser=useridArray[i]+"!"+UserNameArray[i];
				}else{
					setUser=setUser+","+useridArray[i]+"!"+UserNameArray[i];
				}
			 }
		    obj.winPersonMIn.setDefaultValue(setUser)
		    preRowID=SelectedRowID;
		}else{
			obj.winTxtRowId.setValue("");
		    obj.winEquipReplace.setValue("");
		    obj.winMaintainDate.setValue("");
		    obj.winMainDesc.setValue("");
		    obj.winMaintainMoney.setValue("");
		    obj.winNote.setValue("");
		    obj.winPersonMOut.setValue("");
		    obj.winPersonMIn.setValue("");
	        SelectedRowID = 0;
		    preRowID=0;
		};
	  };
	};
	obj.winBtnExcel_click = function(){ 
		//alert(0)
		var xlsExcel,xlsSheet,xlsBook;
	    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	    var LeftFooter,CenterFooter,RightFooter;
	    var path,fileName;
	    path = GetFilePath();
	    //alert(path)
	    fileName=path + "DHCBPEquipMaintain.xls";
	    //alert(fileName)
	    xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName);
		xlsSheet = xlsBook.ActiveSheet;
		var count=obj.retGridPanelStore.getCount(); //数据行数
		if(count==0){
			ExtTool.alert("提示","要导出的数据为空");
			return;
		}
		var equipInfo=obj.winEquipInfo.getValue();
		var equipInfoArray=equipInfo.split("^");
		//var equipId=equipInfoArray[0];
		//alert(equipInfo)
		xlsSheet.cells(2,1)="设备型号:"+equipInfoArray[3];
		xlsSheet.cells(2,3)="设备序列号:"+equipInfoArray[2];
		xlsSheet.cells(2,6)="设备状态:"+equipInfoArray[4];
		if(equipInfoArray[4]=="在用"){
			xlsSheet.cells(2,7)="床位:"+equipInfoArray[1];
		}
		var row=3
		for (var i = 0; i < count; i++) {
			row=row+1;
			var record = obj.retGridPanelStore.getAt(i); //获得行对象
			xlsSheet.cells(row,1)=i+1;
			xlsSheet.cells(row,2)=record.get("StartDate"); // 维护时间
			xlsSheet.cells(row,3)=record.get("tDBPEquipPartDesc"); //更换部件
			xlsSheet.cells(row,4)=record.get("tBPEMTypeDesc"); //维护内容
			xlsSheet.cells(row,5)=record.get("tBPEMExpense"); //维护费用
			xlsSheet.cells(row,6)=record.get("userNameList"); //参加人（院内）
			xlsSheet.cells(row,7)=record.get("userNameOut"); //参加人（院外）
			xlsSheet.cells(row,8)=record.get("Note"); //备注
		}
	    var savefileName="D:\\维护记录.xls"
		xlsSheet.SaveAs(savefileName);
		alert("文件已导入到"+savefileName);
	    //xlsSheet.PrintPreview;
		//xlsSheet.PrintOut();
	    xlsSheet = null;
	    xlsBook.Close(savechanges=false)
	    xlsBook = null;
	    xlsExcel.Quit();
	    xlsExcel = null;
	    
	};
	function GetFilePath()
	{
		var path=_DHCLCNUREXCUTE.GetPath();
		return path;
	}	
}
