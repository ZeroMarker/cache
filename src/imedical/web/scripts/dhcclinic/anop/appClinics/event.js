
function InitWinScreenEvent(obj)
{
    var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _DHCANOPArrangeClinics=ExtTool.StaticServerObject('web.DHCANOPArrangeClinics');
	var _DHCANOPArrange=ExtTool.StaticServerObject('web.DHCANOPArrange');
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var _DHCClinicCom=ExtTool.StaticServerObject('web.DHCClinicCom');
    var _UDHCANOPSET=ExtTool.StaticServerObject('web.UDHCANOPSET');
    //var _DHCCLCom=ExtTool.StaticServerObject('web.DHCCLCom');
	var intReg=/^[1-9]\d*$/;
	var opStr='';
	var opIdStr='';
	var admType=''
	var LabInfoStr="",IfInsertLabInfo="Y"
	//var PatComeHospiTime="";  	//患者来院手术时间  add by lyn 20160411 
	var RSAsLoad=0;				//选择的手术预约资源总数  add by lyn 20160411 
	var operQueueNo="";
	var beforQueueNo=""  //前一次手术预约号源
	var totalTimeH=_DHCANOPArrangeClinics.GetClinicsOpAppInfo("",session['LOGON.USERID']); //上午或者下午的手术总时长为3个半小时  可以修改的
	obj.LoadEvent = function(args)
	{
		var userId=session['LOGON.USERID'];
		InitialElement()
		if ((opaId!="")||(EpisodeID!=""))
		{
			var retStr0=_DHCANOPArrange.GetAnSingle(opaId,EpisodeID,userId,"Out")
			var appList=retStr0.split("@");
			LoadData(appList)
			if(opaId=="")
			{
				if(IfInsertLabInfo=="Y") GetLabInfo(EpisodeID);			  
			}
			if(opaId!="")
			{
				obj.listOpNameStore.load({})
				var retStr1=_UDHCANOPArrange.GetQTData(opaId);
				var appOtherList=retStr1.split("$");
				LoadOtherData(appOtherList)
			}
		}
		admType=_DHCANOPCom.GetAdmType(EpisodeID)
		var ifDisbled=_UDHCANOPArrange.GetIfOutTime()
		if((ifDisbled==1)&(appType=="ward")&(opaId=="")&(admType!="E"))
		{
			//obj.btnSave.disable()
			alert("手术时间限制,不能申请择期手术!")
		}
		if((ifDisbled==2)&(appType=="ward")&(opaId=="")&(admType!="E")) 
		{
		alert("手术时间限制,不能申请择期手术!");
		//obj.btnSave.disable()
		}	
		var checkAppData=_UDHCANOPArrange.CheckAppData(EpisodeID)	 
		var n=checkAppData.split("!").length
		var itmStr=checkAppData.split("!")
		for(i=0;i<n;i++)
		{ 
			var itm=itmStr[i].split("^")[0];
			var itmCtr=itmStr[i].split("^")[1];
			if((itmCtr==1)&(appType=="ward")&(opaId==""))
			{
	            obj.btnSave.disable()
				alert(itm+"未完成!");

			}
			if((itmCtr==2)&(appType=="ward")&(opaId=="")) alert(itm+"未完成!");
			if((itmCtr==3)&(appType=="ward")&(opaId=="")) alert(itm+"危急值");
		}	  
	}
	
	function GetLabInfo(EpisodeID)
	{
	  LabInfoStr=_DHCANOPCom.GetLabInfo("^"+EpisodeID);
	  var LabInfo=LabInfoStr.split("^");	
	  if(LabInfo[0].length>0){
		  obj.SetComboxValueByDesc(obj.comBloodType,LabInfo[0]);  //血型			    
	  }	  		  
	  if(LabInfo[1].length>0){
		 obj.SetComboxValueByDesc(obj.comRHBloodType,LabInfo[1]); //RH血型					    
	  }
      if(LabInfo[3].length>0){
	      obj.SetComboxValueByDesc(obj.comHbsAg,LabInfo[3]); //HbsAg		
	  }
	  if(LabInfo[4].length>0){
		  obj.SetComboxValueByDesc(obj.comHcvAb,LabInfo[4]); //RCV血型		 			    
	  }
	  if(LabInfo[5].length>0){
		  obj.SetComboxValueByDesc(obj.comHivAb,LabInfo[5]); //HivAb血型				    
	  }
	  if(LabInfo[6].length>0){
		  obj.SetComboxValueByDesc(obj.comRPR,LabInfo[6]); //梅毒					    
	  }
    }

	function LoadData(appList)
	{
	   ////手术时间
	   var opDateTime=appList[4]
	   var opDateTimeList=opDateTime.split("^")
	   ////病人基本信息
	   var patBaseInfo=appList[0]
	   var baseInfoList=patBaseInfo.split("^")
	   EpisodeID=baseInfoList[0]
       obj.txtPatname.setValue(baseInfoList[1]); //姓名
	   obj.txtPatRegNo.setValue(baseInfoList[2]); //登记号
	   obj.txtPatSex.setValue(baseInfoList[3]); //性别
	   obj.txtPatAge.setValue(baseInfoList[4]); //年龄
	   obj.txtPatLoc.setValue(baseInfoList[5]); //病人所在科室
	   obj.txtPatWard.setValue(baseInfoList[6]); //病区
	   obj.txtPatBedNo.setValue(baseInfoList[7]); //床号
	   obj.txtAdmReason.setValue(baseInfoList[8]) //费别
	   obj.txtPatTele.setValue(baseInfoList[12]) //电话号码
	   ////病区信息
	   var patWardInfo=appList[1];
	   var wardInfoList=patWardInfo.split("^")
	   var operLoc=wardInfoList[0];
	   obj.comOperLocationStore.reload({})
	   var operLocId=operLoc.split('!')[0];
	   var operLocDesc=operLoc.split('!')[1];
	   operLoc=operLocId+"!"+operLocDesc;
	   obj.LoadCombox(obj.comOperLocation,operLoc) //手术室
	   
	   var opStTime=opDateTimeList[1]
	   obj.timeOper.setRawValue(opStTime) //手术时间
	   var appLoc=wardInfoList[1]
	   
       obj.LoadCombox(obj.comAppLoc,appLoc) //申请科室
	   var appDoc=wardInfoList[2]
	   obj.comAppDoc.setValue(appDoc.split('!')[0]);
	   var bloodType=wardInfoList[11]  //血型
	   obj.LoadCombox(obj.comBloodType,bloodType);
	   var selfReport=wardInfoList[14];
	   var patNotice=wardInfoList[17]
		obj.txtPatKnow.setValue(patNotice);
	   if(opaId!=""){
			var opStDate=opDateTimeList[0];
			obj.dateOper.setValue(opStDate); //手术日期
		   	obj.txtPatSelfReport.setValue(selfReport); //主诉
			var operResource=wardInfoList[15];
			// alert(operResource)
			var opMem=wardInfoList[8]     //手术说明、手术要求
			obj.txtAreaOpMem.setValue(opMem)
			
			var bodsList=wardInfoList[9]   //身体部位
			obj.comBodySite.setDefaultValue(bodsList);  
			
			var queueNo=wardInfoList[16];
			beforQueueNo=queueNo
			obj.comNumResourceStore.reload({});
			obj.comNumResource.setRawValue(queueNo);
		   
			obj.LoadCombox(obj.comOperResource,operResource)//资源
			//obj.comOperResource_select();
			 var surgeon=wardInfoList[5]            //主刀
			obj.LoadCombox(obj.comSurgeon,surgeon)
			
			var operStock=wardInfoList[18];
			obj.comOpConsumable.setDefaultValue(operStock);	
			var operStockNote=wardInfoList[19];
			obj.txtstockItemNote.setValue(operStockNote);
			var comeHDTime=wardInfoList[20];
			obj.comeHosTime.setRawValue(comeHDTime) //手术时间
			
	   }
		//alert(obj.comOperLocation.getValue())
		obj.comOperResourceStore.removeAll({});
		obj.comOperResourceStore.load({});
       ////麻醉信息
	   var anaesInfo=appList[2]
       var anaesInfoList=anaesInfo.split("^")
       /*var anDoc=anaesInfoList[0]            //麻醉医生
       obj.LoadCombox(obj.comAnaDoc,anDoc) 
       var anSupDoc=anaesInfoList[1]        //麻醉指导医生
       obj.LoadCombox(obj.comAnaSupervisor,anSupDoc)   
	   var anNurse=anaesInfoList[2]        //麻醉护士
	   obj.LoadCombox(obj.comAnaNurse,anNurse) 
       var anAssStr=anaesInfoList[3]	//麻醉助手
       obj.comAnaDocO.setDefaultValue(anAssStr);
       
       
       obj.comAnaMethod.setDefaultValue(anMethodStr);
       var anaLevel=anaesInfoList[6]	//麻醉规模
       obj.LoadCombox(obj.comAnaLevel,anaLevel) 
       var anDocNote=anaesInfoList[7]	//麻醉备注
       obj.txtAnaDocNote.setValue(anDocNote)	
	   */
	   var shiftAnAssStr=anaesInfoList[4]  //交班麻醉助手
	   obj.comSAnaDoc.setDefaultValue(shiftAnAssStr);	
       var anMethodStr=anaesInfoList[5]	  //麻醉方法
	   if(anMethodStr=="") anMethodStr=_DHCANOPArrangeClinics.GetANAMethod("局部麻醉");
		obj.comAnaMethod.setDefaultValue(anMethodStr);
       ///手术室信息
       var opTheatreInfo=appList[3]	   
	   var opTheatreInfoList=opTheatreInfo.split("^")
	   /*
	   var opRoom=opTheatreInfoList[0]   //手术间
	   obj.LoadCombox(obj.comOperRoom,opRoom) 
	   var ordNo=opTheatreInfoList[1]
	   obj.comOrdNo.setValue(ordNo)    //台次
	   var opArrTime=opDateTimeList[3]
	   obj.timeArrOper.setRawValue(opArrTime)
	   var scNurStr=opTheatreInfoList[2]  //器械护士
	   obj.comScrubNurse.setDefaultValue(scNurStr);
	   var sScNurStr=opTheatreInfoList[3]
	   obj.comShiftScrubNurse.setDefaultValue(sScNurStr);
	   
	   var sCirNurStr=opTheatreInfoList[5]
	   obj.comShiftCirculNurse.setDefaultValue(sCirNurStr);
	   var scNurNote=opTheatreInfoList[6]
	   obj.txtScrubNurseNote.setValue(scNurNote)
	   var cirNurNote=opTheatreInfoList[7]
	   obj.txtCirculNurseNote.setValue(cirNurNote)
	   */
	   var cirNurStr=opTheatreInfoList[4]
	   if((cirNurStr=="")&&(appType=="op"||appType=="RegOp")){
		   cirNurStr=_DHCANOPArrangeClinics.GetUserInfo(session['LOGON.USERID'])
	   }
	   obj.LoadCombox(obj.comCirculNurse,cirNurStr)  
	   if (appType=="RegOp"){
	    obj.dateOpStt.setRawValue(opDateTimeList[8])
		obj.timeOpStt.setRawValue(opDateTimeList[9])
		obj.dateOpEnd.setRawValue(opDateTimeList[10])
		obj.timeOpEnd.setRawValue(opDateTimeList[11])
	   }
	 } 
	function LoadOtherData(appOtherList)
	{
	  var checkList=appOtherList[0].split("^");
	  var RHBloodTypeDesc=checkList[6]	  //RH血型描述
	  
      obj.SetComboxValueByDesc(obj.comRHBloodType,RHBloodTypeDesc)
	  
	  //Ext.getDom('comRHBloodType').style.color ="red"
	  var HbsAgDesc=checkList[0] //HbsAg描述
	  obj.SetComboxValueByDesc(obj.comHbsAg,HbsAgDesc)
	  var HcvAbDesc=checkList[1] //HcvAb描述
	  obj.SetComboxValueByDesc(obj.comHcvAb,HcvAbDesc)
	  var HivAbDesc=checkList[2] //HivAb描述
	  obj.SetComboxValueByDesc(obj.comHivAb,HivAbDesc)
	  var RPRDesc=checkList[3] //梅毒描述
	  obj.SetComboxValueByDesc(obj.comRPR,RPRDesc)
	  var opType=checkList[4]  //是否急诊
	  //obj.chkOpType.setValue(opType)
	  var needAnaesthetist=checkList[11]   //是否需要麻醉
	  obj.chkNeedAnaesthetist.setValue(needAnaesthetist=="Y"?true:false)
	  var isolated=checkList[7] 
	  obj.chkIsolated.setValue(isolated=="Y"?true:false)
	  var isPrepareBlood=checkList[8] 
	  obj.chkIsPrepareBlood.setValue(isPrepareBlood=="Y"?true:false)
	  var isUseSelfBlood=checkList[9]
	  obj.chkIsUseSelfBlood.setValue(isUseSelfBlood=="Y"?true:false)
	  var isExCirculation=checkList[10]
	  obj.chkIsExCirculation.setValue(isExCirculation=="Y"?true:false)
	  var otherTest=checkList[5]
	  obj.txtOther.setValue(otherTest)
	  var ifNurseShift=appOtherList[5]
	  //obj.chkIfShift.setValue(ifNurseShift)
	  var opReq=appOtherList[2]
	  obj.txtOpReq.setValue(opReq)
	  var note=appOtherList[1]
	  obj.txtNote.setValue(note)
	 }
	obj.LoadCombox=function(combox,item)
	{
	 if("undefined" == typeof item) return;
	 var itemList=item.split("!")
	 if(itemList.length>1)
	 {
	 combox.setValue(itemList[0]);
	 combox.setRawValue(itemList[1])
	 }
	}
	function InitialElement()
	{
     DisableBaseInfo()	
	 obj.SetComboxValueByDesc(obj.comBloodType,"未知") 
	 obj.SetComboxValueByDesc(obj.comRHBloodType,"不详") //此处描述值要和后台RHBlood方法中的描述保持一致
	 obj.SetComboxValueByDesc(obj.comHbsAg,"不详")
	 obj.SetComboxValueByDesc(obj.comHcvAb,"不详")
	 obj.SetComboxValueByDesc(obj.comHivAb,"不详")
	 obj.SetComboxValueByDesc(obj.comRPR,"不详")
	 var chkNeedAnaesthetist=_UDHCANOPArrange.NeedAnaesthetist(opaId) //是否麻醉
	 obj.chkNeedAnaesthetist.setValue(chkNeedAnaesthetist)
	  switch(appType)
	  {
		case "RegOp":   //operatioen register
			DisableWard();
			obj.contentTab.setActiveTab("opPanel")
		case "RegNotApp":
			DisableDiag();
			break;
		case "ward":
			DisableOP();
			//DisableAna();
			break;
		case "anaes":
		    obj.contentTab.setActiveTab("anPanel")
			DisableWard();
			DisableOP();
			var needAnaesthetist=obj.chkNeedAnaesthetist.getValue()
			if(!needAnaesthetist)DisableAna(); 
			break;
		case "op":
			DisableWard();
			obj.dateOpStt.disable()
		    obj.dateOpEnd.disable()
		    obj.timeOpStt.disable()
		    obj.timeOpEnd.disable()
			//DisableAna();	 
		    obj.contentTab.setActiveTab("opPanel")
			
		default:
	  }
	}
	function DisableBaseInfo()
	{
	  obj.txtPatname.disable()
	  obj.txtPatRegNo.disable()
	  obj.txtPatSex.disable()
	  obj.txtPatAge.disable()
	  obj.txtPatLoc.disable()
	  obj.txtPatWard.disable()
	  obj.txtPatBedNo.disable()
      obj.txtAdmReason.disable()
      obj.txtPatSecret.disable()
      obj.txtPatLevel.disable()
	}
	function DisableDiag()
	{
	 obj.comOperLocation.disable()
	 obj.comAppLoc.disable()
	 obj.comAppDoc.disable()
	 obj.dateOper.disable()
	 obj.timeOper.disable()
	 //obj.timeOperPro.disable()
	 //obj.comOpPreDiagnosis.disable()
     //obj.txtOpPreDiagMem.disable()
	 obj.comBloodType.disable() 
	}
	function DisableWard()
	{
	  obj.comAppLoc.disable()	  
	  obj.comOperLocation.disable()
	  obj.dateOper.disable()
	  obj.comAppDoc.disable()
	  obj.timeOper.disable()
	  obj.chkNeedAnaesthetist.disable()
      obj.comOpName.disable()
      obj.comAnaOpLevel.disable()
      obj.comOpBladeType.disable()
      obj.btnAdd.disable()
      obj.btnUpdate.disable()
      obj.btnDelete.disable()
      obj.chkIsolated.disable()
      obj.chkIsExCirculation.disable()
      obj.chkIsUseSelfBlood.disable()
      obj.chkIsPrepareBlood.disable()
      obj.comBloodType.disable()
      obj.comRHBloodType.disable()
      obj.comHbsAg.disable()
      obj.comHcvAb.disable()
      obj.comHivAb.disable()
      obj.comRPR.disable()
      obj.txtOther.disable()	
      obj.btnSave.disable()
      obj.btnClose.disable()
	  obj.comOpCat.disable(); //手术分类
	  obj.txtPatSelfReport.disable(); //主诉
	  obj.txtPatTele.disable(); //病人电话
	  obj.comeHosTime.disable();
	  obj.txtPatKnow.disable();
	  obj.txtOpNote.disable()
	  obj.comOpConsumable.disable();
	  obj.txtstockItemNote.disable();
	  obj.comBodySite.disable();
	  obj.comNumResource.disable();
	  obj.comOperResource.disable();
	  obj.txtAreaOpMem.disable()
	  obj.tb.disable();
	 /* 未使用项目
	  obj.chkOpType.disable()
	  obj.timeOperPro.disable()
	  obj.comOpPreDiagnosis.disable()
      obj.txtOpPreDiagMem.disable()
      obj.comSurgeon.disable()
      obj.comAssistDoc1.disable()
      obj.comAssistDoc2.disable()
      obj.comAssistDoc3.disable()
      obj.txtOpDocNote.disable()
      obj.comAssistDocO.disable()
      obj.txtOpSeqNote.disable()
	  //
      //obj.txtAreaOpMem.disable()
	  */
	}
	function DisableOP()
	{
	  obj.comOperRoom.disable()
      obj.comOrdNo.disable()
      obj.timeArrOper.disable()
      obj.chkIfShift.disable()
      obj.comScrubNurse.disable()
      obj.comShiftScrubNurse.disable()
	  obj.comCirculNurse.disable()
	  obj.comShiftCirculNurse.disable()
	  obj.txtScrubNurseNote.disable()
	  obj.txtCirculNurseNote.disable()
	  obj.txtOpReq.disable()
      obj.txtNote.disable()
      obj.dateOpStt.disable()
      obj.dateOpEnd.disable()
      obj.timeOpStt.disable()
      obj.timeOpEnd.disable()
      obj.btnOpSave.disable()
      obj.btnOpClose.disable()
	  obj.comSurgeon.disable() //add by lyn
	  obj.comAnaMethod.disable()//add by lyn
	}
	function DisableAna()
	{
	 obj.comAnaDoc.disable()
     obj.comAnaDocO.disable()
     obj.comSAnaDoc.disable()
     obj.comAnaNurse.disable()
     //obj.comAnaMethod.disable()
     obj.comAnaSupervisor.disable()
     obj.comAnaLevel.disable()
     obj.txtAnaDocNote.disable()
     obj.btnAnSave.disable()
     obj.btnAnClose.disable()
	}
	
	
	///活性项目
	///add by lyn
	///20160408
	function EnableWard()
	{
	  obj.comAppLoc.enable()	  
	  obj.comOperLocation.enable()
	  obj.dateOper.enable()
	  obj.comAppDoc.enable()
	  obj.timeOper.enable()
      obj.comOpName.enable()
      obj.comOpBladeType.enable()
      obj.txtOpNote.enable()
	  obj.comAnaOpLevel.enable();
	  obj.chkNeedAnaesthetist.enable()
      obj.btnAdd.enable()
      obj.btnUpdate.enable()
      obj.btnDelete.enable()
      obj.chkIsolated.enable()
      obj.chkIsExCirculation.enable()
      obj.chkIsUseSelfBlood.enable()
      obj.chkIsPrepareBlood.enable()
      obj.comBloodType.enable()
      obj.comRHBloodType.enable()
      obj.comHbsAg.enable()
      obj.comHcvAb.enable()
      obj.comHivAb.enable()
      obj.comRPR.enable()
      obj.txtOther.enable()	
      obj.btnSave.enable()
      obj.btnClose.enable()
	  obj.comOpCat.enable(); //手术分类
	  obj.txtPatSelfReport.enable(); //主诉
	  obj.txtPatTele.enable(); //病人电话
	  obj.txtPatKnow.enable();
	  obj.txtOpNote.enable()
	  obj.comOpConsumable.enable();
	  obj.txtstockItemNote.enable();
	  obj.comBodySite.enable();
	  obj.comNumResource.enable();
	  obj.comOperResource.enable();
	}
	
	obj.comOpName_select=function()
	 {
	  var operId=obj.comOpName.getValue()
      var retStr=_UDHCANOPArrange.GetOperRelated(operId)
      if (retStr=="") return;
	  var operRelatedList=retStr.split("^");
	  if (operRelatedList.length<8) return;
	  obj.LoadCombox(obj.comAnaOpLevel,operRelatedList[0]+"!"+operRelatedList[1])
	  obj.LoadCombox(obj.comOpBladeType,operRelatedList[2]+"!"+operRelatedList[3])
	  if(obj.listOpNameStore.getCount()<1)
	  {
	  obj.comBodySite.setDefaultValue(operRelatedList[4]+"!"+operRelatedList[5]); 
      obj.LoadCombox(obj.comOperPosition,operRelatedList[6]+"!"+operRelatedList[7])
      } 	  
	 }
	 obj.listOpName_rowclick=function()
	 {
	  var selRecord=obj.listOpName.getSelectionModel().getSelected()
	  var operId=selRecord.get("operId")
	  var operDesc=selRecord.get("operDesc")
	  obj.LoadCombox(obj.comOpName,operId+"!"+operDesc)
	  var opLevelId=selRecord.get("opLevelId")
	  var opLevelDesc=selRecord.get("opLevelDesc")
	  obj.LoadCombox(obj.comAnaOpLevel,opLevelId+"!"+opLevelDesc)
	  var bldTpId=selRecord.get("bldTpId")
	  var bldTypeDesc=selRecord.get("bldTypeDesc")
	  obj.LoadCombox(obj.comOpBladeType,bldTpId+"!"+bldTypeDesc)
	  var operNotes=selRecord.get("operNotes")
	  obj.txtOpNote.setValue(operNotes)
	 }
	 obj.btnAdd_click=function()
	 {
	  var operId=obj.comOpName.getValue()
	  var operDesc=obj.comOpName.getRawValue()
	  var opLevelId=obj.comAnaOpLevel.getValue()
	  var opLevelDesc=obj.comAnaOpLevel.getRawValue()
	  var bldTpId=obj.comOpBladeType.getValue()
	  var bldTypeDesc=obj.comOpBladeType.getRawValue()
	  var operNotes=obj.txtOpNote.getValue()
	  var record=new Ext.data.Record(['operId','operDesc','opLevelId','opLevelDesc','bldTpId','bldTypeDesc','operNotes'])
	  if(opLevelId=="")
	  {
	   alert("请选择手术级别")
	   return;
	  }
	  if((operId=="")&&(operNotes==""))
	  {
	  	alert("请选择手术")
	   	return;
	  }
	  record.set('operId',operId);
	  record.set('operDesc',operDesc)
	  record.set('opLevelId',opLevelId)
	  record.set('opLevelDesc',opLevelDesc)
	  record.set('bldTpId',bldTpId)
	  record.set('bldTypeDesc',bldTypeDesc)
	  record.set('operNotes',operNotes)
	  if((obj.listOpNameStore.find('operId',operId)==-1)||(obj.listOpNameStore.find('operDesc',operDesc)==-1))
	  {
	    obj.listOpNameStore.add(record);
		obj.comOpName.setValue("")
		obj.comAnaOpLevel.setValue("")
		obj.comOpBladeType.setValue("")
		obj.txtOpNote.setValue("")
	  }
	  else 
	  alert("该手术已添加")
	  obj.listOpNameStore.commitChanges() 
	 }
	 obj.btnUpdate_click=function()
	 {
	  var selRecord=obj.listOpName.getSelectionModel().getSelected()
	  var operId=obj.comOpName.getValue()
	  var operDesc=obj.comOpName.getRawValue()
	  var opLevelId=obj.comAnaOpLevel.getValue()
	  var opLevelDesc=obj.comAnaOpLevel.getRawValue()
	  var bldTpId=obj.comOpBladeType.getValue()
	  var bldTypeDesc=obj.comOpBladeType.getRawValue()
	  var operNotes=obj.txtOpNote.getValue()
	  if(selRecord)
	  {
	  if(((operId=="")&&(operNotes==""))||(opLevelId==""))
	  {
	   alert("请选择手术和手术级别")
	   return;
	  } 
	  selRecord.set('operId',operId);
	  selRecord.set('operDesc',operDesc)
	  selRecord.set('opLevelId',opLevelId)
	  selRecord.set('opLevelDesc',opLevelDesc)
	  selRecord.set('bldTpId',bldTpId)
	  selRecord.set('bldTypeDesc',bldTypeDesc)
	  selRecord.set('operNotes',operNotes)
	  obj.listOpNameStore.commitChanges() 
	  }
	  else
	  {
	   alert("请选择一条手术名称")
	  }
	 }
	 obj.btnDelete_click=function()
	 {
	  var selRecord=obj.listOpName.getSelectionModel().getSelected() 
	  if (selRecord)
	  {
	  obj.listOpNameStore.remove(selRecord)
	  obj.listOpNameStore.commitChanges() 
	  obj.comOpName.setValue("")
	  obj.comAnaOpLevel.setValue("")
	  obj.comOpBladeType.setValue("")
	  obj.txtOpNote.setValue("")  
	  }
	  else
	  {
	   alert("请选中一行拟施手术！")
	  } 
	 }
	 obj.btnSave_click=function()
	 {
	  var checkRes=CheckData();    
      if (checkRes==false){ return; }
	  var appLocId=obj.comAppLoc.getValue();
	  var appDocId=obj.comAppDoc.getValue();
	  //var appDocId=session['LOGON.USERID'];
	  var preDiscussDate=""
	  var estiOperDuration="" //obj.timeOperPro.getRawValue()
	  var startDate=obj.dateOper.getRawValue()
	  var startTime=obj.timeOper.getRawValue()
	  var opMem=obj.txtAreaOpMem.getValue();
	  var logUserId=session['LOGON.USERID'];
	  var bloodTypeId=obj.comBloodType.getValue();
	  var patHeight=""
	  var patWeight=""
	  var opDocNote="" //obj.txtOpDocNote.getValue();
	  var opSeqNote="" //obj.txtOpSeqNote.getValue();
	  var operRoomId=""
	  var arrTime=""
	  var opLevelId=obj.comAnaOpLevel.getValue();
	  var ordNo=""
	  var opaMedInfect=""
	  var transferMeansCode=""
	  //获取主手术,手术列表中的第一条手术
	  if(obj.listOpNameStore.getCount()>0)
	  {
	   var mainOPId=obj.listOpNameStore.getAt(0).get("operId")
	   var mainOPLevelId=obj.listOpNameStore.getAt(0).get("opLevelId")
	   var mainBladeTypeId=obj.listOpNameStore.getAt(0).get("bldTpId");
	   var mainOPNote=obj.listOpNameStore.getAt(0).get("operNotes").replace(" ","");
	   var mainOperIdStr=mainOPId+"|"+mainOPLevelId+"|"+mainOPNote+"|"+mainBladeTypeId; 	
	  }
	  //术前诊断，备注
	  var preDiagId="" //obj.comOpPreDiagnosis.getValue()
	  var preDiagMem="" //obj.txtOpPreDiagMem.getValue();
	  //术后诊断，备注 （暂时为空）
	  var postDiagId=""
	  var postDiagMem=""
	  if(postDiagId=="")   //preDiagId and postDiagId
	  {
		var diagId=preDiagId;
	  }
     else
      {
	    var diagId=preDiagId+"/"+postDiagId;
	  }
	 if(postDiagMem!="") //preDiagMem and postDiagMem
	 {
		var diagMem=preDiagMem+"/"+postDiagMem;
	 }
	 else
	 {
	 	var diagMem=preDiagMem;
	 }
	 var diag=""
	 diag=diagId+"|"+diagMem;
	 var surgeonId=obj.comSurgeon.getValue();
	 var operLocationId=obj.comOperLocation.getValue()
	 var bodySiteId=obj.comBodySite.getValue()
	 bodySiteId=bodySiteId.replace(/,/g, "|")
	 var operPositionId=obj.comOperPosition.getValue();
	 var appOperInfo=mainOperIdStr+"^"+diag+"^"+surgeonId+"^"+preDiagMem+"^"+operLocationId+"^"+bodySiteId+"^"+operPositionId;
	 var assDoc1Id="" //obj.comAssistDoc1.getValue();
	 var assDocIdStr=""
	 //检验值（描述）
	  var RHBloodTypeDesc=obj.comRHBloodType.getRawValue()	  //RH血型描述
	  var HbsAgDesc=obj.comHbsAg.getRawValue() //HbsAg描述
	  var HcvAbDesc=obj.comHcvAb.getRawValue() //HcvAb描述
	  var HivAbDesc=obj.comHivAb.getRawValue() //HivAb描述
	  var RPRDesc=obj.comRPR.getRawValue() //梅毒描述
	  var otherTest=obj.txtOther.getValue()
	  var opType="" //obj.chkOpType.getValue()  //是否急诊
	  var anaSourceType=opType?1:0
	  var needAnaesthetist=obj.chkNeedAnaesthetist.getValue()?"Y":"N"  //是否需要麻醉
	  var isolated=obj.chkIsolated.getValue()?"Y":"N"  //是否隔离
	  var isPrepareBlood=obj.chkIsPrepareBlood.getValue()?"Y":"N"  //是否备写
	  var isUseSelfBlood=obj.chkIsUseSelfBlood.getValue()?"Y":"N"  //是否自体血回输
	  var isExCirculation= obj.chkIsExCirculation.getValue()?"Y":"N" //是否体外循环
	  var ifMiniInvasive="" //是否微创（暂时没加）
	  var needNavigation=""  //是否导航（暂时没加）
	  var anmthId=""
	  var anDocId=obj.comAnaDoc.getValue() 
	  var anSupDocId=obj.comAnaSupervisor.getValue();
	  var anNurseId=obj.comAnaNurse.getValue();
	  var anAssIdStr=obj.comAnaDocO.getValue();
	  var shiftAnAssIdStr=obj.comSAnaDoc.getValue();
	  var anMethodIdStr=obj.comAnaMethod.getValue();
	  var anaLevelId=obj.comAnaLevel.getValue();
	  var anDocNote=obj.txtAnaDocNote.getValue();
	  var ASAId="" //ASA分级暂时没加此元素，缺省为空
	  var selfReport=obj.txtPatSelfReport.getRawValue(); //主诉
	  var operResource=obj.comOperResource.getValue(); //手术资源
	  var operQueueNo=obj.comNumResource.getValue();
	  if(operQueueNo=="") operQueueNo=beforQueueNo;
		var operStockId=obj.comOpConsumable.getValue();
		var operStockNote=obj.txtstockItemNote.getValue();
	  ////////////////////手术室相关//////////////////////////
	  arrTime=obj.timeArrOper.getRawValue()
      operRoomId=obj.comOperRoom.getValue()
	  ordNo=obj.comOrdNo.getRawValue();
	  var isAddInstrument="" //暂时没加，为空
	  var instrumentId=""
      var scrNurIdStr="" //obj.comScrubNurse.getValue()
      var sScrNurIdStr="" //obj.comShiftScrubNurse.getValue()
	  var scrNurNote=""; //obj.txtScrubNurseNote.getValue()
	  var scrNurse="" //scrNurIdStr+"#"+sScrNurIdStr+"#"+scrNurNote
	  var cirNurIdStr=obj.comCirculNurse.getValue()  //巡回护士
	  var sCirNurIdStr="" //obj.comShiftCirculNurse.getValue()
	  var cirNurNote="" //obj.txtCirculNurseNote.getValue()
	  var cirNurse=cirNurIdStr		//cirNurIdStr+"#"+sCirNurIdStr+"#"+cirNurNote
	  var opReq=obj.txtOpReq.getValue();   //备注
	  var note=obj.txtNote.getValue();     //注意事项
	  var ifShift=obj.chkIfShift.getValue()?"1":"0" 
      var opDateTime="" ;
	  var patNotice=obj.txtPatKnow.getValue(); // 病人须知
	  var comHosTime=startDate+" "+obj.comeHosTime.getRawValue(); //患者来院时间
	  var telNum=obj.txtPatTele.getValue()
      if (appType=="RegOp"){
	    var opDateTime= obj.dateOpStt.getRawValue()+"|"+obj.timeOpStt.getRawValue()+"|"+obj.dateOpEnd.getRawValue()+"|"+obj.timeOpEnd.getRawValue();
       }
	  var strCheck=HbsAgDesc+"^"+HcvAbDesc+"^"+HivAbDesc+"^"+RPRDesc+"^"+anaSourceType+"^"+otherTest+"^"+RHBloodTypeDesc+"^"+isolated+"^"+isPrepareBlood+"^"+isUseSelfBlood+"^"+isExCirculation+"^"+needAnaesthetist+"^"+ifMiniInvasive+"^"+needNavigation
	  var str1=appLocId+"^"+appDocId+"^"+startDate+"^"+startTime+"^"+logUserId+"^"+EpisodeID+"^"+operRoomId+"^"+opMem+"^"+bloodTypeId+"^"+arrTime+"^"+anaLevelId+"^"+patHeight+"^"+patWeight+"^"+preDiscussDate+"^"+estiOperDuration+"^"+opDocNote+"^"+opSeqNote+"^"+ordNo+"^^"+opaMedInfect+"^"+transferMeansCode
	  var strOp=logUserId+"^"+opReq+"^"+note+"^"+ifShift+"^"+ordNo+"^"+isAddInstrument+"|"+instrumentId+"^"+opDateTime+"^"+surgeonId;
	  //主诉^预约资源^号源^来院时间^病人须知^耗材^度数^之前预约的号源
	  var strClinic=selfReport+"^"+operResource+"^"+operQueueNo+"^"+comHosTime+"^"+patNotice+"^"+operStockId+"^"+operStockNote+"^"+beforQueueNo+"^"+telNum
	  //alert(strClinic)
	  switch(appType)
      {
	   case "RegOp":
	   case "RegNotApp":
	    if(arguments[0].id=="btnSave")
	    {
	        if (opaId!="")
			{
				var ret=_DHCANOPArrangeClinics.updatewardRecord("InsertAddOnOperation","",opaId,str1,appOperInfo,assDocIdStr,strCheck,anmthId);
				if (ret!=0)
				{
				 window.returnValue=0
				 alert(ret);
				 return;
				}
				else
	            {
				   window.returnValue=1
			       var closeWindow = confirm("手术申请信息修改成功，是否继续修改其他信息？")
			       if(!closeWindow)
			       {
			        window.close()
			       }
				}
			}
			else
			{
			 var ret=_DHCANOPArrangeClinics.insertAnRecord("InsertAddOnOperation","",str1,appOperInfo,assDocIdStr,strCheck,anmthId,appType,strClinic);
			 if (ret.split("^")[0]<0) {alert(ret.split("^")[1]);;return;}
			 else opaId=ret;
			}
		}
		 if(arguments[0].id=="btnOpSave")
		   {
			   //alert(anMethodIdStr)
				var ret=_DHCANOPArrange.UpdateOpRecord(opaId,str1,scrNurse,cirNurse,strOp,appType,"O",anMethodIdStr);
				if (ret!=0){
					window.returnValue=0
					alert(ret);return;
				}
				else 
				{
					window.returnValue=1
					var closeWindow = confirm("手术室信息修改成功，是否继续修改其他信息？")
					if(!closeWindow)
					{
					window.close()
				}
			}
		   }
		   if(arguments[0].id=="btnAnSave")
		   {
			 var ret=_DHCANOPArrange.UpdateAnRecord(opaId,anMethodIdStr,anDocId,anNurseId,anAssIdStr,shiftAnAssIdStr,anSupDocId,anDocNote,anaLevelId,ASAId);
			 if (ret!=0)
			 {
			 window.returnValue=0
			 alert(ret);
			 return;
			 }
			 else
			 {
			  window.returnValue=1
			  var closeWindow = confirm("麻醉信息修改成功，是否继续修改其他信息？")
			  if(!closeWindow)
			  {
			   window.close()
			  }
			 }
		   }
	         break;  
       case "ward": //病区
	         var ifDisbled=_UDHCANOPArrange.GetIfOutTime()
			 if((ifDisbled==1)&(opaId=="")&(opType==false)&(admType!="E"))
				{
					alert("手术时间限制,不能申请手术!")
					return ;
				}
			if (opaId!="")
			{
				var ret=_DHCANOPArrangeClinics.updatewardRecord("InsertAddOnOperation","",opaId,str1,appOperInfo,assDocIdStr,strCheck,anmthId,"","","","","","",strClinic);
				if (ret!=0)
				{
				 window.returnValue=0
				 alert(ret);
				 return
				}
				else
	            {
				   window.returnValue=1
			       var closeWindow = confirm("手术修改成功，是否打印预约单？")
			       if(closeWindow)
			       {	
					    PrintMZSSYYD("MZSSYYD","N",opaId);
					    
			       }
			       window.close();
				}
			}
			else
			{
				//alert(0)
				var ret=_DHCANOPArrangeClinics.insertAnRecord("InsertAddOnOperation","",str1,appOperInfo,assDocIdStr,strCheck,anmthId,"",appType,strClinic);
				if (ret.split("^")[0]<0) 
				{
					window.returnValue=0
					alert(ret.split("^")[1]);
					return;
				}
				else
				{
				   window.returnValue=1
			       var closeWindow = confirm("手术申请成功，是否打印预约单？")
			       if(closeWindow)
			       {	
					    PrintMZSSYYD("MZSSYYD","N",ret);
			       }
			       window.close();
				}
			}
        break;	
		case "anaes":   //麻醉
			var ret=_DHCANOPArrange.UpdateAnRecord(opaId,anMethodIdStr,anDocId,anNurseId,anAssIdStr,shiftAnAssIdStr,anSupDocId,anDocNote,anaLevelId,ASAId);
			if (ret!=0)
			{
			 window.returnValue=0
			 alert(ret);
			 return;
			 }
			 else
			 {
			  window.returnValue=1
			  var closeWindow = confirm("麻醉信息更新成功，是否关闭窗口？")
			  if(closeWindow)
			  {
			   window.close()
			  }
			 }
		break;		
        case "op":  //手术室
			//alert(anMethodIdStr)
			var ret=_DHCANOPArrange.UpdateOpRecord(opaId,str1,scrNurse,cirNurse,strOp,appType,"O",anMethodIdStr);
			if (ret!=0){
			window.returnValue=0
			alert(ret);return}
			else 
			{
             window.returnValue=1
			 var closeWindow = confirm("手术室信息更新成功，是否关闭窗口？")
			 if(closeWindow)
			 {
			  window.close()
			 }
			}
		break;		
	  }
	 }
	 obj.btnClose_click=function()
	 {
	   window.close()
	 }
	 obj.InsertSlaveOperation=function(anaId)
	 {
	    var opStr="";
        var anCompStr=""; 
		var n=obj.listOpNameStore.getCount()
	    if (n==0) return;
	   //从第二条手术开始为从手术
		for(var i=1;i<n;i++)
		{
			var subOPId=obj.listOpNameStore.getAt(i).get("operId");
			var subOPLevelId=obj.listOpNameStore.getAt(i).get("opLevelId");
			var subBladeTypeId=obj.listOpNameStore.getAt(i).get("bldTpId");
			var subOPNote=obj.listOpNameStore.getAt(i).get("operNotes").replace(" ","");
			opStr=opStr+subOPId+"|"+subOPLevelId+"|"+subOPNote+"|"+subBladeTypeId+"|"+"^";
		}
   		var ret=_UDHCANOPArrange.insertchlop("","",anaId,opStr,appType);
   		if (ret!=0) alert(ret)
	}	

	 CheckData=function()
	 {
	  /*if((appType=="op")&&(obj.comOperRoom.getValue()==""))
	   {
	       alert("请选择手术间!");
		   obj.comOperRoom.focus();
		   return false;
	   }
	   if((appType=="op")&&(obj.comOrdNo.getValue()==""))
	   {
	       alert("请选择台次!");
		   obj.comOrdNo.focus();
		   return false;
	   } */
	   if(obj.txtPatSelfReport.getValue()!="")
		{
			var txtPatSelfReport=obj.txtPatSelfReport.getValue();
			if(txtPatSelfReport.length>100)
			{
			    alert("“主诉”内容长度不得超过100个汉字、字符或数字!");
				obj.txtPatSelfReport.focus()
				return false;
			}
		}
	   	if(obj.txtstockItemNote.getValue()!="")
		{
			var txtNoteInfo=obj.txtstockItemNote.getValue();
			if(txtNoteInfo.length>50)
			{
			    alert("“耗材说明”长度不得超过50个汉字、字符或数字!");
				obj.txtstockItemNote.focus()
				return false;
			}
		}
		if(obj.txtOther.getValue()!="")
		{
			var txtOtherInfo=obj.txtOther.getValue();
			if(txtOtherInfo.length>30)
			{
			    alert("“其他”内容长度不得超过30个汉字、字符或数字!");
				obj.txtOther.focus()
				return false;
			}
		}
	    if (EpisodeID==""){
			alert("请选择病人!");
			return false;
        } 
	    if(obj.comOperLocation.getValue()=="")
	    {
			alert("请选择手术室!")
			obj.comOperLocation.focus()
			return false;
	    }
	    if(obj.dateOper.getRawValue()=="")
	    {
			alert("请选择手术日期!")
			obj.dateOper.focus()
			return false;
	    }
	    if(obj.listOpName.getStore().getCount()==0)
	    {
			alert("请选择手术!")
			obj.comOpName.focus()
			return false;
	    }
	    if((obj.comeHosTime.getRawValue()=="")&&(appType=="ward"))
		{
			alert("请患者来院时间!")
			return false;
		}
	   /*
	   if(obj.timeOper.getRawValue()=="")
	   {
	    //alert("请选择手术时间!")
		//obj.timeOper.focus()
		//return false;
	   }
	   if(obj.comBloodType.getValue()=="")
	   {
	    alert("请选择血型!")
		obj.comBloodType.focus();
		return false;
	   }
	   if(obj.comOpPreDiagnosis.getValue()=="")
	   {
	    alert("请选择诊断!")
		if ((appType=="ward")||(appType==""))
		obj.comOpPreDiagnosis.focus();
		return false;
	   }
	   */
	   if((appType=="op")&&(obj.comSurgeon.getValue()==""))
	   {
	    alert("请选择手术医生!");
		obj.comSurgeon.focus();
		return false;
	   }
	   
	    if((appType=="op")&&(obj.comAnaMethod.getValue()==""))
	   {
	     alert("请选择麻醉方法！")
		 obj.comAnaMethod.focus()
		 return false;
	   }
	 }
	 obj.comAppLoc_select=function()
	 {
	  obj.comAppDocStore.reload({});
	  obj.comSurgeonStore.reload({})
	  obj.comAssistDoc1Store.reload({})
	  obj.comAssistDoc2Store.reload({})
	  obj.comAssistDoc3Store.reload({})
	  obj.comAssistDocOStore.reload({})
	 }
	
	obj.SetComboxValueByDesc=function(combox,desc)
	{
	  var store=combox.getStore();
	  store.load({
	  callback:function(records,option,success)
	  {
	   if(success)
	   {
	    Ext.each(records,function(r)
		{
		 if(r.get(combox.displayField)==desc)
		 {
		  combox.setValue(r.get(combox.valueField))
		 }
		})
	   }
	   }
	  })
	}
	
	///手术室选择时的事件
	///add by lyn
	///20160408
	obj.comOperLocation_select=function()
	{
		obj.comOperResourceStore.removeAll({});
		obj.comOperResourceStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCANOPArrangeClinics';
			param.QueryName = 'FindOpResource';
			param.Arg1 = obj.comOperLocation.getValue();
			param.Arg2 = obj.dateOper.getValue();
			param.ArgCnt = 2;
		});
		obj.comOperResourceStore.load({
			callback: function(records, options, success){ 
				if(records[0]==null) alert("该手术室在选择的日期内没有排班，请选择其他的手术室！")
				obj.comOperResource.setValue("");
			}
		});
	}
	
	///手术资源选择时的事件  (暂未使用)
	///add by lyn
	/*//20160408
	obj.comOperResource_select=function()
	{
		
		var rsId=obj.comOperResource.getValue();
		if(rsId==""){
			alert("请选择手术资源！");
			return;
		}
		//alert(rsId)
		obj.comNumResource.setValue("");
		//选择的手术资源有可用资源时
		var ret=_DHCANOPArrangeClinics.JudgeResourceEffect(rsId);
		RSAsLoad=ret.split('|')[0];
		var unUsedLoad=ret.split('|')[1];
		var usedLoad=ret.split('|')[2];
		obj.lbNumResource.setText("总资源数: "+RSAsLoad+"   已用资源数: "+usedLoad+"   未用资源数: "+unUsedLoad)
		if(parseInt(unUsedLoad) > 1){ //有可用资源时，设置资源对应的时间点和画面项目的活性不活性的设置
			if(appType=="ward") EnableWard();
			var reCount=obj.comOperResourceStore.getCount()
			for(var i=0;i<reCount;i++)
			{
				var rowId=obj.comOperResourceStore.getAt(i).get("rowId");
				if(rsId==rowId){
					obj.comNumResourceStore.removeAll({});
					obj.comNumResourceStoreProxy.on('beforeload', function(objProxy, param){
						param.ClassName = 'web.DHCANOPArrangeClinics';
						param.QueryName = 'FindNumResource';
						param.Arg1 = rsId;
						param.ArgCnt = 1;
					});
					obj.comNumResourceStore.load({})
					RSStartDT=obj.comOperResourceStore.getAt(i).get("asSessTime");
					//alert(RSStartDT)
					break;
				}
			}
		}else{
			DisableWard();
			obj.timeOper.setRawValue("");
		}
	}
	
	///手术分类选择事件触发
	///add by lyn
	///20160408
	obj.comOpCat_select=function(){
		obj.comOpNameStore.removeAll({});
		obj.comOpNameStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANOPArrangeClinics';
		    param.QueryName = 'FindOPerByCat';
		    param.Arg1 = obj.comOpCat.getValue();
	    	param.ArgCnt = 1;
	    });
		obj.comOpNameStore.load({});
		
	}*/

	///预约号源选择时事件触发时，设定手术预约开始的时间
	///add by lyn
	///20160411
	obj.comNumResource_select=function(){
		var num=obj.comNumResource.getValue();
		if(num==""){
			alert("请选择预约号源！");
			return;
		}
		//alert(RSAsLoad);
		
		if(RSAsLoad<1){
			alert("预约号源不存在！请核实号源信息！");
			return;
		}
		var rsId=obj.comOperResource.getValue();
		var opStartDate=obj.dateOper.getRawValue();
		var ret=_DHCANOPArrangeClinics.GetOPStartTimeByResource(rsId,opStartDate,num,1) //获取来院时间和手术时间
		
		var opStartDT=ret.split('||')[1]; //手术开始时间
		obj.timeOper.setRawValue(opStartDT.split(' ')[1]);
	}
	
	///手术日期选择后，号源信息重新加载
	///add by lyn
	///20160411
	obj.dateOper_select=function(){
		obj.comOperResource.setValue("");
		var opLoc=obj.comOperLocation.getValue();
		if(opLoc!=""){
			obj.comOperResourceStore.removeAll({});
			obj.comOperResourceStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCANOPArrangeClinics';
				param.QueryName = 'FindOpResource';
				param.Arg1 = obj.comOperLocation.getValue();
				param.Arg2 = obj.dateOper.getValue();
				param.ArgCnt = 2;
			});
			obj.comOperResourceStore.load({
				callback: function(records, options, success){ 
					if(records[0]==null) alert("该手术室在选择的日期内没有排班，请选择其他的手术室！")
				}
			});
		}
	}
		
    function GetFilePath()
    {
        var path=_UDHCANOPArrange.GetPath();
        return path;
    }		
		///门诊手术预约单打印
	///LYN ADD 20160414
		function PrintMZSSYYD(prnType,exportFlag,printOpaId)
	{
		if (prnType=="") return;
		var printInfo=_DHCANOPArrangeClinics.GetMZSSMZYYD(printOpaId); //获取打印信息
		if(printInfo=="") return ;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path=GetFilePath();
		
		fileName=path+prnType+".xls";
		try{
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Open(fileName);
		}
		catch(e){
			alert(e.name+"^"+e.message+"^"+e.description+"^"+e.number)
			}
		xlsSheet = xlsBook.ActiveSheet;
		
		
		//var loc=window.status.split(':')[3].split(' ')[1];
		//alert(loc)
		//var hospital=window.status.split(':')[3].split(' ')[2]
		//var hospitalDesc="首都医科大学附属"+hospital;
		///***************打印表头**************
		var hospital=_DHCClinicCom.GetHospital();
		xlsSheet.cells(1,1)=hospital;
			var position=""
		position=printInfo.split('^')[14];
		xlsSheet.cells(1,8)=position;	//手术部位
		var appointnum=""	//预约号
		appointnum=printInfo.split('^')[19]+"";
		xlsSheet.cells(2,8)=appointnum;	
		var appdept=""	//预约科室
		appdept=printInfo.split('^')[13];
		xlsSheet.cells(2,1)="    "+appdept+"手术预约单";
		var patname=""	//患者姓名
		patname=printInfo.split('^')[0];
		xlsSheet.cells(3,2)=patname; 
		var patgender=""	//性别
		patgender=printInfo.split('^')[1];
		xlsSheet.cells(3,4)=patgender;	
		//DZY^女^25岁^^370***********641X^
		//13649500432^^^^^
		//头部血管治疗性超声^^医生01^手术室^内分泌门诊^
		//左前胸^27/09/2017^27/09/2017 09:00^27/09/2017 ^测试模板hkdhfkhfkdhfiehie^
		//^kkdkfdsfkd
		var patage=""	//年龄
		patage=printInfo.split('^')[2];
		xlsSheet.cells(3,6)=patage;	
		var patmed=""  //病案号
		patmed=printInfo.split('^')[3];
		xlsSheet.cells(3,8)=patmed;	
		var patidnum=""	//身份证号
		patidnum=printInfo.split('^')[4];
		xlsSheet.cells(4,2)=patidnum;
		var patworkplace=""	//工作单位
		patworkplace=printInfo.split('^')[6];
		xlsSheet.cells(4,5)=patworkplace;
		var patphone=""		//电话
		patphone=printInfo.split('^')[5];		
		xlsSheet.cells(5,2)="'"+patphone; 
		var pataddress=""
		pataddress=printInfo.split('^')[7];
		xlsSheet.cells(5,5)=pataddress; //家庭住址
		var patmedinfo=""
		patmedinfo=printInfo.split('^')[20];
		xlsSheet.cells(6,2)=patmedinfo;	//病历摘要
		var patdiag=""
		patdiag=printInfo.split('^')[8];	//诊断
		xlsSheet.cells(7,2)=patdiag;
		var opname="" //手术名称
		opname=printInfo.split('^')[9];
		xlsSheet.cells(8,2)=opname;
		var opsurgeon=""
		opsurgeon=printInfo.split('^')[10];
		xlsSheet.cells(9,2)=opsurgeon; //手术医生
			 
		var oploc=""	//手术科室
		oploc=printInfo.split('^')[12];
		xlsSheet.cells(9,4)=oploc;
		var appointtime="" //预约日期
		appointtime=printInfo.split('^')[16];
		xlsSheet.cells(9,7)=appointtime;
		var appdoc=""	//申请医生
		appdoc=printInfo.split('^')[11]
		xlsSheet.cells(10,2)=appdoc;	
		var apploc=""	//申请科室
		apploc=printInfo.split('^')[13];
		xlsSheet.cells(10,4)=apploc;
		var apptime=""	//申请时间
		apptime=printInfo.split('^')[15];
		xlsSheet.cells(10,7)=apptime;
		
		var patnotice=""	//病人须知
		patnotice=printInfo.split('^')[18];
		xlsSheet.cells(12,1)=patnotice;
		var cometime=""	//来院时间
		cometime=printInfo.split('^')[17];
		xlsSheet.cells(12,7)=cometime;
		

		
		if (exportFlag=="Y")
		{
			var savefileName="C:\\Documents and Settings\\";
			var savefileName=_UDHCANOPSET.GetExportParth()
			var d = new Date();
			savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xls"
			xlsSheet.SaveAs(savefileName);	
		}
		//xlsExcel.Visible = true;
		//xlsSheet.PrintPreview;
		xlsSheet.PrintOut();
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}
	///保存个人模板信息
	obj.saveTempleteDoc_click=function()
	{
		//alert(obj.comAppDoc.getValue())
		if(obj.comAppDoc.getValue()==""){
			alert("申请医生信息异常，无法保存，请联管理员！");
			return;
		}
		//alert(obj.txtPatKnow.getValue())
		if(obj.txtPatKnow.getValue()=="")
		{
			alert("‘病人须知’不能为空！");
			return;
		}
		var docId=obj.comAppDoc.getValue();
		var saveInfo=obj.txtPatKnow.getValue();
		var ret=_DHCANOPArrange.SaveSetingInfo("",docId,saveInfo);
		if(ret==1)alert("保存成功！");
		else alert("保存失败！");
	}
}