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
		    obj.equipType.setValue(rc.get("tBPCEBPCEquipModelDr")); //�豸�ͺ�
		    obj.manufactName.setValue(rc.get("tBPCEBPCEquipMFDr")); //����
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
		// �豸����
		var equipType=obj.equipType.getValue();
		if(equipType==""){
			ExtTool.alert("��ʾ","�豸���Ʋ���Ϊ��");
			return;
		};
		// ��λ��
		var bedNo= obj.bedNo.getValue();
		// ��������
		var manufactName=obj.manufactName.getValue();
		// �豸״̬
		var status=obj.equipStatus.getValue();
		// ��������
		var purchaseDate=obj.buyDate.getRawValue();
		// ������
		var purchaseAmount=obj.buyMoney.getValue();
		// ��������
		var guarYears=obj.guarYears.getValue();
		// ��װ��Ա���ڣ�
		var installPersonIn=obj.installPersonIn.getValue();
		// ��װ��Ա���⣩
		var installPersonOut=obj.installPersonOut.getValue();
		// ������Ա
		var takeCarePerson=obj.takeCarePerson.getValue();
		// �豸���к�
		var equipSeqNo=obj.equipSeqNo.getValue();
		// Ժ�ڱ��
		var equipHosNo=obj.equipHosNo.getValue();
		// ��ע
		var note=obj.note.getValue();
		//alert(note)		
		//return;
		var ret=_DHCBPCEquip.InsertEquip(equipHosNo,equipAbbre,equipSeqNo,"","",status,note,equipType,"","","","",purchaseDate,purchaseAmount,guarYears,installPersonIn,installPersonOut,takeCarePerson,bedNo);
		//alert(ret)
		if(ret!=0)
		{
			ExtTool.alert("��ʾ",ret);
			return;
		}else{ExtTool.alert("��ʾ","�����ɹ�");}
		ClearData(obj)
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	
	obj.updatebutton_click = function()
	{
		var rowId=obj.tRowId.getValue();
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if (rowId==""){
			ExtTool.alert("��ʾ","��ѡ��һ�м�¼");
			return;
		}
		// �豸����
		var equipType=obj.equipType.getValue();
		if(equipType==""){
			ExtTool.alert("��ʾ","�豸���Ʋ���Ϊ��");
			return;
		};
		// ��λ��
		var bedNo= rc.get("tBPBEBedDr")
		// ��������
		var manufactName=obj.manufactName.getValue();
		// �豸״̬
		var status=obj.equipStatus.getValue();
		// ��������
		var purchaseDate=obj.buyDate.getRawValue();
		// ������
		var purchaseAmount=obj.buyMoney.getValue();
		// ��������
		var guarYears=obj.guarYears.getValue();
		// ��װ��Ա���ڣ�
		var installPersonIn=obj.installPersonIn.getValue();
		// ��װ��Ա���⣩
		var installPersonOut=obj.installPersonOut.getValue();
		// ������Ա
		var takeCarePerson=obj.takeCarePerson.getValue();
		// �豸���к�
		var equipSeqNo=obj.equipSeqNo.getValue();
		// Ժ�ڱ��
		var equipHosNo=obj.equipHosNo.getValue();
		// ��ע
		var note=obj.note.getValue();
		if(bedNo!=""){
			if(status!="US"){
				ExtTool.alert("��ʾ","���Ƚ����λ��");
				return;
			}
		}else{
			if(status=="US"){
				ExtTool.alert("��ʾ","���Ƚ������봲λ����");
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
			ExtTool.alert("��ʾ",ret);
			return;
		}else{ExtTool.alert("��ʾ","���³ɹ�");}
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
			ExtTool.alert("��ʾ","����ѡ��һ��!");
		}
	};
	
	obj.deletebutton_click=function(){
		//alert()
		var RowId=obj.tRowId.getValue();
		var rc = obj.retGridPanel.getSelectionModel().getSelected();
		if(RowId=="")
		{
			ExtTool.alert("��ʾ","IDΪ��!��ѡ��һ������");
			return;
		}
		if(rc.get("tBPCEStatus")=="US"){
			ExtTool.alert("��ʾ","���õ��豸����ɾ�������Ƚ����λ��");
			return;
		}
		Ext.Msg.confirm("ѡ��","ȷ��Ҫɾ����",function(btn){
	  		if(btn=="no")return;
	  		var ret=_DHCBPCEquip.DeleteEquip(RowId);
			if(ret!=0)
			{
				ExtTool.alert("��ʾ","ɾ��ʧ��");	
				return;
			}else{ExtTool.alert("��ʾ","ɾ���ɹ�");}
			ClearData(obj)
			obj.retGridPanelStore.removeAll();
			obj.retGridPanelStore.load({});
	  	});
	};
	
	obj.selectbutton_click=function(){
		obj.retGridPanelStore.removeAll();
		obj.retGridPanelStore.load({});
	};
	//����ѡ��ʱ
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
	    xlsSheet.cells(2,2)=rc.get("tBPCEDesc");//�豸����
	    xlsSheet.Rows(2).RowHeight=0
	    xlsSheet.cells(3,2)=rc.get("tBPCEBPCEquipMFDesc");//��������
	    xlsSheet.cells(4,2)=rc.get("tBPCEBPCEquipModel") //"�豸�ͺ�"
	    xlsSheet.cells(5,2)="'"+rc.get("tBPCENo") //"�豸���к�";
	    xlsSheet.cells(6,2)="'"+rc.get("tBPCECode")//"�豸Ժ�ڱ��";
	    xlsSheet.cells(7,2)="'"+rc.get("tBPCEPurchaseDate")//"����ʱ��";
	    var purAmmount=rc.get("tBPCEPurchaseAmount")
	    if(purAmmount!=""){purAmmount=purAmmount+"��"}
	    xlsSheet.cells(8,2)=purAmmount//"������";
	    xlsSheet.cells(9,2)=rc.get("installPerNameLtIn")//"��װ��";
	    xlsSheet.cells(10,2)=rc.get("keepPerNameList")//"������";
	    if(rc.get("tBPCEWarrantyYear")!=""){
		    xlsSheet.cells(11,2)=rc.get("tBPCEWarrantyYear")+"��"//"��������";
		}
	    xlsSheet.cells(12,2)=rc.get("tBPCENote")//"��ע";
	    
	    var savefileName="D:\\"+getExcelFileName()+".xls"
	    //alert(savefileName)
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
	    var fileName = "�豸������Ϣ" + "_" + curYear + curMonth + curDate + "_"   
	            + curHour + curMinute + curSecond + ".csv";   
	    //alert(fileName);   
	    return fileName;   
	}   

	//�ж�ʱ���ʽ
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
			//�豸��Ϣ���豸Rowid^��λ��^�豸���к�^�豸�ͺ�^�豸״̬
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
		//ȡ������
	obj.winBtnCancle_click=function()
	{		
		obj.winScreen.close();
	}
	obj.winBtnSave_click=function()
	{
		var txtNull=""
		//�豸id
		var equipInfo=obj.winEquipInfo.getValue();
		var equipInfoArray=equipInfo.split("^");
		var equipId=equipInfoArray[0];
		//��������
		var equipPartdr=obj.winEquipReplace.getValue();
		//ά��ʱ��
		var maintainDate=obj.winMaintainDate.getRawValue()
		if(maintainDate==""){
			ExtTool.alert("��ʾ","�μ��˲���Ϊ��!");
			return;
		}
		//ά������
		var maintaindesc=obj.winMainDesc.getValue()
		//ά������
		var mainMoney=obj.winMaintainMoney.getValue()
		//�μ���(Ժ��)
		var personIn=obj.winPersonMIn.getValue()
		if(personIn==""){
			ExtTool.alert("��ʾ","�μ��˲���Ϊ��!");
			return;
		}
		//�μ���(Ժ��)
		var personOut=obj.winPersonMOut.getValue();
		//��ע
		var note= obj.winNote.getValue()
		var info =equipId+"^"+equipPartdr+"^"+maintaindesc+"^^"+maintainDate+"^^^^"+note+"^"+mainMoney+"^"+userId+"^"+personIn+"^"+personOut
		try
		{
			//�������
			if(obj.winTxtRowId.getValue()=="")
			{
				var ret = _DHCBPEquipMaintain.InsertBPEquipMaintain(info);
				if(ret!=0)
				{
					ExtTool.alert("��ʾ","����ʧ��");
					return;
				}else{ExtTool.alert("��ʾ","�����ɹ�");}
				obj.retGridPanelStore.removeAll();
				obj.retGridPanelStore.load({});
			}
			else  //���²���
			{
				var oriRowId=obj.winTxtRowId.getValue();
				info=oriRowId+"^"+info;
				var ret=_DHCBPEquipMaintain.UpdateBPEquipMaintain(info)
				if(ret!=0)
				{
					ExtTool.alert("��ʾ","����ʧ��");
					return;
				}else{ExtTool.alert("��ʾ","���³ɹ�");}
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
	    
		    //�μ���
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
		var count=obj.retGridPanelStore.getCount(); //��������
		if(count==0){
			ExtTool.alert("��ʾ","Ҫ����������Ϊ��");
			return;
		}
		var equipInfo=obj.winEquipInfo.getValue();
		var equipInfoArray=equipInfo.split("^");
		//var equipId=equipInfoArray[0];
		//alert(equipInfo)
		xlsSheet.cells(2,1)="�豸�ͺ�:"+equipInfoArray[3];
		xlsSheet.cells(2,3)="�豸���к�:"+equipInfoArray[2];
		xlsSheet.cells(2,6)="�豸״̬:"+equipInfoArray[4];
		if(equipInfoArray[4]=="����"){
			xlsSheet.cells(2,7)="��λ:"+equipInfoArray[1];
		}
		var row=3
		for (var i = 0; i < count; i++) {
			row=row+1;
			var record = obj.retGridPanelStore.getAt(i); //����ж���
			xlsSheet.cells(row,1)=i+1;
			xlsSheet.cells(row,2)=record.get("StartDate"); // ά��ʱ��
			xlsSheet.cells(row,3)=record.get("tDBPEquipPartDesc"); //��������
			xlsSheet.cells(row,4)=record.get("tBPEMTypeDesc"); //ά������
			xlsSheet.cells(row,5)=record.get("tBPEMExpense"); //ά������
			xlsSheet.cells(row,6)=record.get("userNameList"); //�μ��ˣ�Ժ�ڣ�
			xlsSheet.cells(row,7)=record.get("userNameOut"); //�μ��ˣ�Ժ�⣩
			xlsSheet.cells(row,8)=record.get("Note"); //��ע
		}
	    var savefileName="D:\\ά����¼.xls"
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
