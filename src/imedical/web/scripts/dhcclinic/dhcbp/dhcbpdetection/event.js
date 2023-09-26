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
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}	
		//alert(selectObj)
	};
	
	//ɾ������
	obj.deletebutton_click=function(){
		var RowId=obj.bpdRowId.getValue();
		if(RowId=="")
		{
			ExtTool.alert("��ʾ","IDΪ��!��ѡ��һ������");
			return;
		}
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCBPDetection.DeleteBPDetection(RowId);
			if(ret==0) 
			{
				ExtTool.alert("��ʾ","ɾ���ɹ�");
				ClearData(obj);
				obj.retGridPanelStore.reload();
			}
			else ExtTool.alert("��ʾ","ɾ��ʧ��!");	
	  	});
	};
	
	//��ѯ����
	obj.selectbutton_click=function(){
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	
	function ClearData(obj){
		obj.bpdstartDate.setValue("")
		obj.bpdendDate.setValue("")	
	};	
	
	//���ݵ���
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
		var count=obj.retGridPanelStore.getCount(); //��������
		if(count==0){
			ExtTool.alert("��ʾ","Ҫ����������Ϊ��");
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
					titleDate=startyear+"��"+startMonth+"��"
				}else{titleDate=startyear+"��"+startMonth+"-"+endMonth+"��"}
			}else{
				if(startMonth==endMonth){
					titleDate=startyear+"-"+endYear+"��"+startMonth+"��"
				}else{titleDate=startyear+"-"+endYear+"��"+startMonth+"-"+endMonth+"��"}
			}
		}
		//alert(titleDate);
		//return;
		xlsSheet.cells(1,4)=titleDate
		var row=2
		for (var i = 0; i < count; i++) {
			row=row+1;
			var record = obj.retGridPanelStore.getAt(i); //����ж���
			xlsSheet.cells(row,1)=i+1;
			xlsSheet.cells(row,2)=record.get("tBPCDetectionDesc"); // �����Ʒ�������
			xlsSheet.cells(row,3)=record.get("tBPDBPCEquip"); //�������
			xlsSheet.cells(row,4)=record.get("tBPDSpecimenNo"); //��Ʒ����
			xlsSheet.cells(row,5)=record.get("tBPDDate"); //����ʱ��
			xlsSheet.cells(row,6)=record.get("IsQualified"); //�Ƿ�ϸ�
			xlsSheet.cells(row,7)=record.get("userNameList"); //�μ���
			xlsSheet.cells(row,8)=record.get("tBPDNote"); //��ע
		}
	    var savefileName="D:\\�ʿؼ�¼.xls"
		xlsSheet.SaveAs(savefileName);
		alert("�ļ��ѵ��뵽"+savefileName);
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
			//�����Ʒ��
			obj.winSampleNameStore.load({
					callback:function(records,options,success){
				    if(success == true){
				     //alert(obj.winSampleNameStore.getCount()) ;
				     obj.winSampleName.setValue(data.get("tBPCDetectionDr"))
				    }else{
				     alert("���ݼ���ʧ��") ;
				    }
			   	}
			}) ;
			obj.winSampleNoStore.load({
					callback:function(records,options,success){
				    if(success == true){
				     //alert(obj.winSampleNameStore.getCount()) ;
				     obj.winSampleNo.setValue(data.get("tBPDBPCEquipCode"))
				    }else{
				     alert("���ݼ���ʧ��") ;
				    }
				}
			});
			//�������
  			obj.winSamplingDate.setValue(data.get("tBPDDate"));
  			//��Ʒ���
			obj.winSpecimenNo.setValue(data.get("tBPDSpecimenNo"))
			
			obj.winIsQualified.setValue(data.get("tBPDIsQualified"))//�Ƿ�ϸ�
			//�μ���
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
		if (sampleName=="") {ExtTool.alert("��ʾ","�����Ʒ������Ϊ��");return;}
		var samplingDate=obj.winSamplingDate.getRawValue();
		// �����Ʒ��
		var txtSampleName=obj.winSampleName.getValue();
		// �豸
		var txtEquip=obj.winSampleNo.getValue();
		// ��Ʒ����
		var txtSpecimenNo=obj.winSpecimenNo.getValue();
		//alert(txtSpecimenNo)
		// �Ƿ�ϸ�
		var txtIsQualified=obj.winIsQualified.getValue();
		// �μ���
		var txtParticipants=obj.winParticipants.getValue();
		// ��ע
		var txtNote=obj.winNote.getValue();
		// ����ʱ��
		var txtSamplingDate=obj.winSamplingDate.getRawValue();
		var tBPDetectionInfo=txtSampleName+"^"+txtEquip+"^"+txtSamplingDate+"^"+
				txtNull+"^"+txtSpecimenNo+"^"+txtNote+"^"+userId+"^"+txtNull+"^"+txtNull+"^"+txtIsQualified+"^"+txtNull+"^"+txtParticipants
		try
		{
			//�������
			if(obj.winTxtRowId.getValue()=="")
			{
				var ret = _DHCBPDetection.InsertBPDetection(tBPDetectionInfo);
				if(ret!=0)
				{
					ExtTool.alert("��ʾ","����ʧ��");
					return;
				}else{ExtTool.alert("��ʾ","�����ɹ�");}
				obj.winScreen.close();
				parent.retGridPanelStore.removeAll();
				parent.retGridPanelStore.load({});
			}
			else  //���²���
			{
				var oriRowId=obj.winTxtRowId.getValue();
				tBPDetectionInfo=oriRowId+"^"+tBPDetectionInfo;
				var ret=_DHCBPDetection.UpdateBPDetection(tBPDetectionInfo)
				if(ret!=0)
				{
					ExtTool.alert("��ʾ","����ʧ��");
					return;
				}else{ExtTool.alert("��ʾ","���³ɹ�");}
				obj.winScreen.close(); //С���ڹر�
				parent.retGridPanelStore.removeAll();
				parent.retGridPanelStore.load({});
			}
		}
		catch(err)
		{
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}		
	};
	
	//ȡ����ť����
	obj.winBtnCancle_click=function()
	{		
		obj.winScreen.close();
	}	
}

