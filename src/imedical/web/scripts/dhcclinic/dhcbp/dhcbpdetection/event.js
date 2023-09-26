function InitViewScreenEvent(obj)
{
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	var _DHCBPDetection=ExtTool.StaticServerObject('web.DHCBPDetection');
	var userId=session['LOGON.USERID'];
	var timeArray=new Array();
	
	
	obj.LoadEvent = function(args)
	{
		obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBPDetection';
			param.QueryName = 'FindBPDetection';
			param.Arg1 = obj.bpdstartDate.getRawValue();
			param.Arg2 = obj.bpdendDate.getRawValue();
			param.Arg3 = obj.equipName.getValue();
			param.Arg4 = obj.equipSeqNo.getValue();
			param.ArgCnt = 4;
		});
		obj.retGridPanelStore.load({});  
	};
	
	obj.retGridPanel_rowclick = function()
	{
		var selectObj =obj.retGridPanel.getSelectionModel().getSelected();
		if(selectObj){
			obj.bpdRowId.setValue(selectObj.get("tRowId"))
		};
	};
	
	obj.addbutton_click = function()
	{
		var objWinEdit = new InitwinScreen();
		objWinEdit.winScreen.show();
	};

	obj.updatebutton_click = function()
	{
		var selectObj =obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var objWinEdit = new InitwinScreen(selectObj);
			objWinEdit.winScreen.show();
		}
		else
		{
			ExtTool.alert("提示","请先选中一行!");
		}	
		//alert(selectObj)
	};
	
	//删除方法
	obj.deletebutton_click=function(){
		var RowId=obj.bpdRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("提示","ID为空!请选择一行数据");
			return;
		}
		Ext.Msg.confirm("选择","确认要删除？",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCBPDetection.DeleteBPDetection(RowId);
			if(ret==0) 
			{
				ExtTool.alert("提示","删除成功");
				ClearData(obj);
				obj.retGridPanelStore.reload();
			}
			else ExtTool.alert("提示","删除失败!");	
	  	});
	};
	
	//查询方法
	obj.selectbutton_click=function(){
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	
	function ClearData(obj){
		obj.bpdstartDate.setValue("")
		obj.bpdendDate.setValue("")	
	};	
	
	//数据导出
	obj.excel_click = function(){ 
		var xlsExcel,xlsSheet,xlsBook;
	    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
	    var LeftFooter,CenterFooter,RightFooter;
	    var path,fileName;
	    path = GetFilePath();
	    //alert(path)
	    fileName=path + "DHCBPDetection.xls";
	    //alert(fileName)
	    xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName);
		xlsSheet = xlsBook.ActiveSheet;
		var count=obj.retGridPanelStore.getCount(); //数据行数
		if(count==0){
			ExtTool.alert("提示","要导出的数据为空");
			return;
		}
		var startDate=obj.bpdstartDate.getRawValue();
		var startDateArray=startDate.split("-");
		var endDate=obj.bpdendDate.getRawValue();
		var endDateArray=endDate.split("-");
		var startyear=startDateArray[0];
		var startMonth=startDateArray[1];
		var endYear=endDateArray[0];
		var endMonth=endDateArray[1];
		var titleDate=""
		if(startDate!=""&&endDate!=""){
			if(startyear==endYear){
				if(startMonth==endMonth){
					titleDate=startyear+"年"+startMonth+"月"
				}else{titleDate=startyear+"年"+startMonth+"-"+endMonth+"月"}
			}else{
				if(startMonth==endMonth){
					titleDate=startyear+"-"+endYear+"年"+startMonth+"月"
				}else{titleDate=startyear+"-"+endYear+"年"+startMonth+"-"+endMonth+"月"}
			}
		}
		//alert(titleDate);
		//return;
		xlsSheet.cells(1,4)=titleDate
		var row=2
		for (var i = 0; i < count; i++) {
			row=row+1;
			var record = obj.retGridPanelStore.getAt(i); //获得行对象
			xlsSheet.cells(row,1)=i+1;
			xlsSheet.cells(row,2)=record.get("tBPCDetectionDesc"); // 检测样品名、标号
			xlsSheet.cells(row,3)=record.get("tBPDBPCEquip"); //检测内容
			xlsSheet.cells(row,4)=record.get("tBPDSpecimenNo"); //样品批号
			xlsSheet.cells(row,5)=record.get("tBPDDate"); //抽烟时间
			xlsSheet.cells(row,6)=record.get("IsQualified"); //是否合格
			xlsSheet.cells(row,7)=record.get("userNameList"); //参加人
			xlsSheet.cells(row,8)=record.get("tBPDNote"); //备注
		}
	    var savefileName="D:\\质控记录.xls"
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

function InitwinScreenEvent(obj)
{
	var userId=session['LOGON.USERID'];
	var parent=objControlArry['ViewScreen'];
	var _DHCBPDetection=ExtTool.StaticServerObject('web.DHCBPDetection');
	var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	obj.LoadEvent = function(args)
	{
		obj.winParticipantsStore.load({});
		var data = arguments[0][0];
		if (data)
		{
			obj.winTxtRowId.setValue(data.get("tRowId"));
			//检测样品名
			obj.winSampleNameStore.load({
					callback:function(records,options,success){
				    if(success == true){
				     //alert(obj.winSampleNameStore.getCount()) ;
				     obj.winSampleName.setValue(data.get("tBPCDetectionDr"))
				    }else{
				     alert("数据加载失败") ;
				    }
			   	}
			}) ;
			obj.winSampleNoStore.load({
					callback:function(records,options,success){
				    if(success == true){
				     //alert(obj.winSampleNameStore.getCount()) ;
				     obj.winSampleNo.setValue(data.get("tBPDBPCEquipCode"))
				    }else{
				     alert("数据加载失败") ;
				    }
				}
			});
			//检测日期
  			obj.winSamplingDate.setValue(data.get("tBPDDate"));
  			//样品标号
			obj.winSpecimenNo.setValue(data.get("tBPDSpecimenNo"))
			
			obj.winIsQualified.setValue(data.get("tBPDIsQualified"))//是否合格
			//参加人
			var useridlist=data.get("userIdList")
			var useridlistArray=useridlist.split(",")
			var userNameList=data.get("userNameList")
			var userNameListArray=userNameList.split(",")
			var userInfor=""
		    for(var i=0;i<useridlistArray.length;i++){
			   if(userInfor==""){
				   userInfor=useridlistArray[i]+"!"+userNameListArray[i];
				}else{
					userInfor=userInfor+","+useridlistArray[i]+"!"+userNameListArray[i];
				}
			 }
			obj.winParticipants.setDefaultValue(userInfor)
			obj.winNote.setValue(data.get("tBPDNote"))
		};	
	}

	function InitialElement()
	{
		obj.winSampleNameStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBPCDetection';
			param.QueryName = 'FindBPCDetection';
			param.ArgCnt = 0;
		});
		obj.winSampleNoStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCBPBedEquip';
			param.QueryName = 'FindBedEquip';
			param.ArgCnt = 0;
		});
		//obj.winSampleNameStore.load({});
		//alert(obj.winSampleNameStore.getAt(0).get("tRowId"))
		//obj.winSampleNoStore.load({});
	}
	
	obj.winBtnSave_click = function()
	{
		var txtNull=""
		var sampleName=obj.winSampleName.getValue();
		if (sampleName=="") {ExtTool.alert("提示","检测样品名不能为空");return;}
		var samplingDate=obj.winSamplingDate.getRawValue();
		// 检测样品名
		var txtSampleName=obj.winSampleName.getValue();
		// 设备
		var txtEquip=obj.winSampleNo.getValue();
		// 样品批号
		var txtSpecimenNo=obj.winSpecimenNo.getValue();
		//alert(txtSpecimenNo)
		// 是否合格
		var txtIsQualified=obj.winIsQualified.getValue();
		// 参加人
		var txtParticipants=obj.winParticipants.getValue();
		// 备注
		var txtNote=obj.winNote.getValue();
		// 抽样时间
		var txtSamplingDate=obj.winSamplingDate.getRawValue();
		var tBPDetectionInfo=txtSampleName+"^"+txtEquip+"^"+txtSamplingDate+"^"+
				txtNull+"^"+txtSpecimenNo+"^"+txtNote+"^"+userId+"^"+txtNull+"^"+txtNull+"^"+txtIsQualified+"^"+txtNull+"^"+txtParticipants
		try
		{
			//插入操作
			if(obj.winTxtRowId.getValue()=="")
			{
				var ret = _DHCBPDetection.InsertBPDetection(tBPDetectionInfo);
				if(ret!=0)
				{
					ExtTool.alert("提示","新增失败");
					return;
				}else{ExtTool.alert("提示","新增成功");}
				obj.winScreen.close();
				parent.retGridPanelStore.removeAll();
				parent.retGridPanelStore.load({});
			}
			else  //更新操作
			{
				var oriRowId=obj.winTxtRowId.getValue();
				tBPDetectionInfo=oriRowId+"^"+tBPDetectionInfo;
				var ret=_DHCBPDetection.UpdateBPDetection(tBPDetectionInfo)
				if(ret!=0)
				{
					ExtTool.alert("提示","更新失败");
					return;
				}else{ExtTool.alert("提示","更新成功");}
				obj.winScreen.close(); //小窗口关闭
				parent.retGridPanelStore.removeAll();
				parent.retGridPanelStore.load({});
			}
		}
		catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}		
	};
	
	//取消按钮功能
	obj.winBtnCancle_click=function()
	{		
		obj.winScreen.close();
	}	
}

