
function InitWinScreenEvent(obj)
{
    var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _DHCANOPArrange=ExtTool.StaticServerObject('web.DHCANOPArrange');
	var _DHCANOPCom=ExtTool.StaticServerObject('web.DHCANOPCom');
	var intReg=/^[1-9]\d*$/;
	var opStr='';
	var opIdStr='';
	var admType=''
	var LabInfoStr="",IfInsertLabInfo="N"
	obj.LoadEvent = function(args)
	{
      var userId=session['LOGON.USERID'];
	  InitialElement()
	  if ((opaId!="")||(EpisodeID!=""))
	   {
		 
	     var retStr0=_DHCANOPArrange.GetAnSingle(opaId,EpisodeID,userId,"In")
		 var appList=retStr0.split("@");
		 LoadData(appList)
		 if(opaId=="")
		 {
		 var checkinbedflag=_DHCANOPArrange.CheckInBedFlag(EpisodeID);
		 if(checkinbedflag=="N")
		 {
			 alert("������δ���Ŵ�λ")
		 	obj.btnSave.disable();
		 }
		var checkDisflag=_DHCANOPArrange.CheckDISFlag(EpisodeID);
		 if(checkDisflag=="Y")
		 {
			 alert("�û������г�Ժ���,������������")
		 	obj.btnSave.disable();
		 }
		 	//20170627+dyl
			 var opSetInfoStr=_DHCANOPCom.GetOpSetInfo();
			 var opSetInfo=opSetInfoStr.split("^");
			 IfInsertLabInfo=opSetInfo[1];
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
		alert("����ʱ������,����������������!")
	  }
      if((ifDisbled==2)&(appType=="ward")&(opaId=="")&(admType!="E"))
      { 
      alert("����ʱ������,����������������!");	
      //obj.btnSave.disable();
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
				alert(itm+"δ���!");

	    }
			if((itmCtr==2)&(appType=="ward")&(opaId=="")) alert(itm+"δ���!");
			if((itmCtr==3)&(appType=="ward")&(opaId=="")) alert(itm+"Σ��ֵ");
      }	  
	}
	
	function GetLabInfo(EpisodeID)
	{
	  LabInfoStr=_DHCANOPCom.GetLabInfo("^"+EpisodeID);
	  var LabInfo=LabInfoStr.split("^");			  
	  if(LabInfo[0].length>0){
		  obj.SetComboxValueByDesc(obj.comBloodType,LabInfo[0]);  //Ѫ��			    
	  }	  		  
	  if(LabInfo[1].length>0){
		 obj.SetComboxValueByDesc(obj.comRHBloodType,LabInfo[1]); //RHѪ��					    
	  }
      if(LabInfo[3].length>0){
	      obj.SetComboxValueByDesc(obj.comHbsAg,LabInfo[3]); //HbsAg		
	  }
	  if(LabInfo[4].length>0){
		  obj.SetComboxValueByDesc(obj.comHcvAb,LabInfo[4]); //RCVѪ��		 			    
	  }
	  if(LabInfo[5].length>0){
		  obj.SetComboxValueByDesc(obj.comHivAb,LabInfo[5]); //HivAbѪ��				    
	  }
	  if(LabInfo[6].length>0){
		  obj.SetComboxValueByDesc(obj.comRPR,LabInfo[6]); //÷��					    
	  }
    }

	 function LoadData(appList)
	 {
	   ////����ʱ��
	   var opDateTime=appList[4]
	   var opDateTimeList=opDateTime.split("^")
	   ////���˻�����Ϣ
	   var patBaseInfo=appList[0]
	   var baseInfoList=patBaseInfo.split("^")
	   EpisodeID=baseInfoList[0]
       obj.txtPatname.setValue(baseInfoList[1]); //����
	   obj.txtPatRegNo.setValue(baseInfoList[2]); //�ǼǺ�
	   obj.txtPatSex.setValue(baseInfoList[3]); //�Ա�
	   obj.txtPatAge.setValue(baseInfoList[4]); //����
	   obj.txtPatLoc.setValue(baseInfoList[5]); //�������ڿ���
	   obj.txtPatWard.setValue(baseInfoList[6]); //����
	   obj.txtPatBedNo.setValue(baseInfoList[7]); //����
	   obj.txtAdmReason.setValue(baseInfoList[8]); //�ѱ�
	   obj.txtPatSecret.setValue(baseInfoList[9]);	//20160928+dyl
	   obj.txtPatLevel.setValue(baseInfoList[10]);	//20160928+dyl
	   //
	   var admDisChargeFlag=baseInfoList[11];
	   	if(admDisChargeFlag=="Y") 
	   {
		  if(appType=="ward")
			{
		   alert("�ò�����ҽ�ƽ���,�޷�����������");
		   obj.btnSave.disable();
			}
			else if(appType=="RegOp")
			{
				 alert("�û�������ҽ�ƽ���,��������������޷���������");
		     obj.btnSave.disable();
		     obj.btnAnSave.disable();
		   	 obj.btnOpSave.disable();
			}
	   }

	   ////������Ϣ
	   var patWardInfo=appList[1]
	   var wardInfoList=patWardInfo.split("^")
	   var operLoc=wardInfoList[0]
	   obj.LoadCombox(obj.comOperLocation,operLoc) //������
	   var opStDate=opDateTimeList[0]
	   obj.dateOper.setValue(opStDate) //��������
	   var opStTime=opDateTimeList[1]
	   obj.timeOper.setRawValue(opStTime) //����ʱ��
	   var estiOperDuration=opDateTimeList[7]
	   obj.timeOperPro.setValue(estiOperDuration) //����Ԥ����ʱ
	   var appLoc=wardInfoList[1]
       obj.LoadCombox(obj.comAppLoc,appLoc) //�������
       //Ĭ�����߿���Ϊ��ǰ��¼���ң����޸�
       obj.LoadCombox(obj.surgeonLoc,appLoc)	//���߿���20180118
	   var appDoc=wardInfoList[2]
	   obj.LoadCombox(obj.comAppDoc,appDoc)
	   var preDiagAndNotes=wardInfoList[3]     //��ǰ��Ϻ���ϱ�ע 
	   var preDiag=preDiagAndNotes.split("#")[0];
	   obj.comOpPreDiagnosis.setDefaultValue(preDiag);
	   var preDiagNotes=preDiagAndNotes.split("#")[1];
	   obj.txtOpPreDiagMem.setValue(preDiagNotes)
	   /*
	   var surgeon=wardInfoList[5]            //����
	   obj.LoadCombox(obj.comSurgeon,surgeon)
	   var assistants=wardInfoList[6]       //����
       var assNum=assistantsList.length
       if(assNum>3) assNum=3; 
	   for(var i=0;i<assNum;i++)
	   {
	    var comboxObj=Ext.getCmp("comAssistDoc"+(i+1))
		var assistant=assistantsList[i]
		obj.LoadCombox(comboxObj,assistant)
	   }
	   var assistantsList=assistants.split("#");  
	   var assistantsO=""
	   for(var j=3;j<assistantsList.length;j++)
	   {
		if(assistantsO=="")assistantsO=assistantsList[j]
		else assistantsO=assistantsO+","+assistantsList[j]
	   }
	   obj.comAssistDocO.setDefaultValue(assistantsO)
	   */
	   var opDocNote=wardInfoList[7]  //ҽ����ע
	   obj.txtOpDocNote.setValue(opDocNote)
	   var opMem=wardInfoList[8]     //����Ҫ��
	   obj.txtAreaOpMem.setValue(opMem)
	   var bodsList=wardInfoList[9]   //���岿λ
       obj.comBodySite.setDefaultValue(bodsList);  
       var operPosition=wardInfoList[10]	//������λ
       obj.LoadCombox(obj.comOperPosition,operPosition)   
	   var bloodType=wardInfoList[11]  //Ѫ��
	   obj.LoadCombox(obj.comBloodType,bloodType)
	   var opSeqNote=wardInfoList[12]
	   obj.txtOpSeqNote.setValue(opSeqNote)
	   var opDocGroup=wardInfoList[13]	//����ҽʦ��20160115
	   obj.OpDocGroup.setValue(opDocGroup)
       ////������Ϣ
	   var anaesInfo=appList[2]
       var anaesInfoList=anaesInfo.split("^")
       var anDoc=anaesInfoList[0]            //����ҽ��
       obj.LoadCombox(obj.comAnaDoc,anDoc) 
       var anSupDoc=anaesInfoList[1]        //����ָ��ҽ��
       obj.LoadCombox(obj.comAnaSupervisor,anSupDoc)   
	   var anNurse=anaesInfoList[2]        //����ʿ
	   obj.LoadCombox(obj.comAnaNurse,anNurse) 
       var anAssStr=anaesInfoList[3]	//��������
       obj.comAnaDocO.setDefaultValue(anAssStr);
       var shiftAnAssStr=anaesInfoList[4]  //������������
       obj.comSAnaDoc.setDefaultValue(shiftAnAssStr);	
       var anMethodStr=anaesInfoList[5]	  //������
       obj.comAnaMethod.setDefaultValue(anMethodStr);
       var anDocMethodStr=anaesInfoList[8]	  //��ʩ������
       obj.comDocAnaMethod.setDefaultValue(anDocMethodStr);
      // var anaLevel=anaesInfoList[6]	//�����ģ	//20160908+dyl
       //obj.LoadCombox(obj.comAnaLevel,anaLevel) 
       var anDocNote=anaesInfoList[7]	//����ע
       obj.txtAnaDocNote.setValue(anDocNote)	
       ////��������Ϣ
       var opTheatreInfo=appList[3]	   
	   var opTheatreInfoList=opTheatreInfo.split("^")
	   var opRoom=opTheatreInfoList[0]   //������
	   obj.LoadCombox(obj.comOperRoom,opRoom) 
	   var ordNo=opTheatreInfoList[1]
	   obj.comOrdNo.setValue(ordNo)    //̨��
	   var opArrTime=opDateTimeList[3]
	   obj.timeArrOper.setRawValue(opArrTime)
	   var scNurStr=opTheatreInfoList[2]  //��е��ʿ
	   obj.comScrubNurse.setDefaultValue(scNurStr);
	   var sScNurStr=opTheatreInfoList[3]
	   obj.comShiftScrubNurse.setDefaultValue(sScNurStr);
	   var cirNurStr=opTheatreInfoList[4] //Ѳ�ػ�ʿ
	   obj.comCirculNurse.setDefaultValue(cirNurStr);
	   var sCirNurStr=opTheatreInfoList[5]
	   obj.comShiftCirculNurse.setDefaultValue(sCirNurStr);
	   var scNurNote=opTheatreInfoList[6]
	   obj.txtScrubNurseNote.setValue(scNurNote)
	   var cirNurNote=opTheatreInfoList[7]
	   obj.txtCirculNurseNote.setValue(cirNurNote);
	   if (appType=="RegOp")
	   {
		    obj.dateOpStt.setRawValue(opDateTimeList[8])
			obj.timeOpStt.setRawValue(opDateTimeList[9])
			obj.dateOpEnd.setRawValue(opDateTimeList[10])
			obj.timeOpEnd.setRawValue(opDateTimeList[11])
	   }
	 } 
	 function LoadOtherData(appOtherList)
	 {
	  var checkList=appOtherList[0].split("^");
	  var RHBloodTypeDesc=checkList[6]	  //RHѪ������
      obj.SetComboxValueByDesc(obj.comRHBloodType,RHBloodTypeDesc)
	  //Ext.getDom('comRHBloodType').style.color ="red"
	  var HbsAgDesc=checkList[0] //HbsAg����
	  obj.SetComboxValueByDesc(obj.comHbsAg,HbsAgDesc)
	  var HcvAbDesc=checkList[1] //HcvAb����
	  obj.SetComboxValueByDesc(obj.comHcvAb,HcvAbDesc)
	  var HivAbDesc=checkList[2] //HivAb����
	  obj.SetComboxValueByDesc(obj.comHivAb,HivAbDesc)
	  var RPRDesc=checkList[3] //÷������
	  obj.SetComboxValueByDesc(obj.comRPR,RPRDesc)
	  var opType=checkList[4]  //�Ƿ���
	  obj.chkOpType.setValue(opType)
	  var needAnaesthetist=checkList[11]   //�Ƿ���Ҫ����
	  obj.chkNeedAnaesthetist.setValue(needAnaesthetist=="Y"?true:false)
	  //�ط�����unPlanedOper
	   var unPlanedOperFlag=checkList[15] 
	  obj.unPlanedOper.setValue(unPlanedOperFlag=="Y"?true:false)
	  
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
	  obj.chkIfShift.setValue(ifNurseShift)
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
	 obj.SetComboxValueByDesc(obj.comRHBloodType,"����") //�˴�����ֵҪ�ͺ�̨RHBlood�����е���������һ��
	 obj.SetComboxValueByDesc(obj.comHbsAg,"����")
	 obj.SetComboxValueByDesc(obj.comHcvAb,"����")
	 obj.SetComboxValueByDesc(obj.comHivAb,"����")
	 obj.SetComboxValueByDesc(obj.comRPR,"����")
	  obj.dateOpStt.setRawValue("");
	  obj.dateOpEnd.setRawValue("");

	 var chkNeedAnaesthetist=_UDHCANOPArrange.NeedAnaesthetist(opaId) //�Ƿ�����
	 obj.chkNeedAnaesthetist.setValue(chkNeedAnaesthetist)
	  switch(appType)
	  {
		case "RegOp":   //operatioen register
		case "RegNotApp":
			DisableDiag();
			break;
		case "ward":
			DisableOP();
			DisableAna();
			break;
		case "anaes":
		    obj.contentTab.setActiveTab("anPanel")
			DisableWard();
			DisableOP();
			var needAnaesthetist=obj.chkNeedAnaesthetist.getValue()
			if(!needAnaesthetist)DisableAna(); 
			break;
		case "op":
		    obj.contentTab.setActiveTab("opPanel");
		    //20160830:
		    obj.dateOpStt.disable();
      		obj.dateOpEnd.disable();
		    //20160822+dyl
		     obj.timeOpStt.disable();
      		 obj.timeOpEnd.disable();
			DisableWard();
			DisableAna();	 
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
	  obj.txtPatBedNo.disable();
	  obj.txtAdmReason.disable()
      obj.txtPatSecret.disable();	//20160928+dyl
      obj.txtPatLevel.disable();
      if(obj.comAppDoc){obj.comAppDoc.disable();}
      if(obj.comAppLoc){obj.comAppLoc.disable();}
      
	}
	function DisableDiag()
	{
	 obj.comOperLocation.disable()
	 obj.comAppLoc.disable()
	 obj.comAppDoc.disable()
	 obj.dateOper.disable()
	 obj.timeOper.disable()
	 obj.timeOperPro.disable()
	 obj.comOpPreDiagnosis.disable()
     obj.txtOpPreDiagMem.disable()
	 obj.comBloodType.disable() 
	}
	function DisableWard()
	{
	  obj.comAppLoc.disable()	  
	  obj.comOperLocation.disable()
	  obj.dateOper.disable()
	  obj.comAppDoc.disable()
	  obj.timeOper.disable()
	  obj.chkOpType.disable()
	  obj.timeOperPro.disable()
	  obj.chkNeedAnaesthetist.disable()
	  obj.comOpPreDiagnosis.disable()
      obj.txtOpPreDiagMem.disable()
      obj.comSurgeon.disable()
      obj.comAssistDoc1.disable()
      obj.comAssistDoc2.disable()
      obj.comAssistDoc3.disable()
      obj.txtOpDocNote.disable()
      obj.comAssistDocO.disable()
      obj.txtOpSeqNote.disable()
      obj.comOpName.disable()
      obj.comAnaOpLevel.disable()
      obj.comOpBladeType.disable()
      obj.txtOpNote.disable()
      obj.txtAreaOpMem.disable()
      obj.btnAdd.disable()
      obj.btnUpdate.disable()
      obj.btnDelete.disable()
      obj.comBodySite.disable()
      obj.comOperPosition.disable()
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
      //20161008+dyl
       obj.comDocAnaMethod.disable()	
       obj.unPlanedOper.disable()
       obj.unPlanedOper.disable()
       obj.OpDocGroup.disable()
      obj.btnSave.disable()
      obj.btnClose.disable()
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
	}
	function DisableAna()
	{
	 obj.comAnaDoc.disable()
     obj.comAnaDocO.disable()
     obj.comSAnaDoc.disable()
     obj.comAnaNurse.disable()
     obj.comAnaMethod.disable()
     obj.comAnaSupervisor.disable()
     //obj.comAnaLevel.disable()	//20160908+dyl
     obj.txtAnaDocNote.disable()
     obj.btnAnSave.disable()
     obj.btnAnClose.disable()
	}
	//20160114
	obj.OpDocGroup_select=function()
	 {
		 //20161024+dyl
		   obj.comSurgeon.setValue("");
		   obj.comAssistDoc1.setValue("")
		   obj.comAssistDoc2.setValue("")
		   obj.comAssistDoc3.setValue("")
		  
		 	var appLoc=obj.comAppLoc.getRawValue()
		  var opDocGroupId=obj.OpDocGroup.getValue()
	      var retStr=_UDHCANOPArrange.GetDocGroupRelated(appLoc,opDocGroupId)
	      
	      if (retStr=="") return;
		  var operRelatedList=retStr.split("^");
		  if(operRelatedList[0])
		  {
		  obj.LoadCombox(obj.comSurgeon,operRelatedList[0]+"!"+operRelatedList[1])
			}
		if(operRelatedList[2])
		{
		  obj.LoadCombox(obj.comAssistDoc1,operRelatedList[2]+"!"+operRelatedList[3])
		}
		if(operRelatedList[4])
		{
		      obj.LoadCombox(obj.comAssistDoc2,operRelatedList[4]+"!"+operRelatedList[5])
		    }
		    if(operRelatedList[6])
		    {
		      obj.LoadCombox(obj.comAssistDoc3,operRelatedList[6]+"!"+operRelatedList[7])
		    }
     	  
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
	  //����  	 
	  var surgeonId=selRecord.get("surgeonId")
	  var surgeon=selRecord.get("surgeon")
	  obj.LoadCombox(obj.comSurgeon,surgeonId+"!"+surgeon)
	  //���߿���
	  var opdocLocId=selRecord.get('opdocLocId',opdocLocId)
	  var opdocLoc=selRecord.get('opdocLoc',opdocLoc)
	  obj.LoadCombox(obj.surgeonLoc,opdocLocId+"!"+opdocLoc)
	  //
	  var Ass1=selRecord.get('Ass1',Ass1)
	 var Ass1Id= selRecord.get('Ass1Id',Ass1Id)
	  obj.LoadCombox(obj.comAssistDoc1,Ass1Id+"!"+Ass1 )
	  
	  var Ass2=selRecord.get('Ass2',Ass2)
	 var Ass2Id= selRecord.get('Ass2Id',Ass2Id)
	  obj.LoadCombox(obj.comAssistDoc2,Ass2Id+"!"+Ass2 )
	  
	  var Ass3=selRecord.get('Ass3',Ass3)
	 var Ass3Id= selRecord.get('Ass3Id',Ass3Id)
	  obj.LoadCombox(obj.comAssistDoc3,Ass3Id+"!"+Ass3 )
	  var assistantsO=""
	  var Asso=selRecord.get('Asso',Asso)
	 var AssoId= selRecord.get('AssoId',AssoId)
	 var assList=Asso.split(","); 
	 var assIdList=AssoId.split(","); 
	  for(var j=0;j<assIdList.length;j++)
   		{
		if(assistantsO=="")assistantsO=assIdList[j]+"!"+assList[j]
		else assistantsO=assistantsO+","+assIdList[j]+"!"+assList[j]
   		}
  	  obj.comAssistDocO.setDefaultValue(assistantsO)
 		
	 }
	 obj.btnAdd_click=function()
	 {
	
	  var operId=obj.comOpName.getValue()
	  var operDesc=obj.comOpName.getRawValue()
	  var opLevelId=obj.comAnaOpLevel.getValue()
	  if(opLevelId=="")
	  {
	   alert("��ѡ����������")
	   return;
	  }
	  var opLevelDesc=obj.comAnaOpLevel.getRawValue()
	  var bldTpId=obj.comOpBladeType.getValue()
	  var bldTypeDesc=obj.comOpBladeType.getRawValue()
	  var operNotes=obj.txtOpNote.getValue()
	  if(((operId=="")&&(operNotes=="")))
	  {
	   alert("��ѡ������")
	   return;
	  }
	  //20180118+dyl
	  var surgeonId=obj.comSurgeon.getValue()
	  var surgeon=obj.comSurgeon.getRawValue()
	  if(surgeonId=="")
	  {
	   alert("��ѡ������ҽʦ")
	   return;
	  }
	  var opdocLocId=obj.surgeonLoc.getValue()
	  var opdocLoc=obj.surgeonLoc.getRawValue()
	  var Ass1Id=obj.comAssistDoc1.getValue()
	  var Ass1=obj.comAssistDoc1.getRawValue()
	  var Ass2=obj.comAssistDoc2.getRawValue()
	  var Ass2Id=obj.comAssistDoc2.getValue()
	  var Ass3=obj.comAssistDoc3.getRawValue()
	  var Ass3Id=obj.comAssistDoc3.getValue()
	  //��������
	  var AssoId=obj.comAssistDocO.getValue()
	  var Asso=obj.comAssistDocO.getRawValue()
	  var subopId=""
	  var record=new Ext.data.Record(['operId','operDesc','opLevelId','opLevelDesc','bldTpId','bldTypeDesc','operNotes','opdocLoc','opdocLocId','surgeon','surgeonId','Ass1','Ass1Id','Ass2','Ass2Id','Ass3','Ass3Id','Asso','AssoId'])
	  record.set('operId',operId);
	  record.set('operDesc',operDesc)
	  record.set('opLevelId',opLevelId)
	  record.set('opLevelDesc',opLevelDesc)
	  record.set('bldTpId',bldTpId)
	  record.set('bldTypeDesc',bldTypeDesc)
	  record.set('operNotes',operNotes)
	  record.set('opdocLocId',opdocLocId)
	  record.set('opdocLoc',opdocLoc)
	  record.set('surgeonId',surgeonId)
	  record.set('surgeon',surgeon)
	  record.set('Ass1',Ass1)
	  record.set('Ass1Id',Ass1Id)
	  record.set('Ass2',Ass2)
	  record.set('Ass2Id',Ass2Id)
	  record.set('Ass3',Ass3)
	  record.set('Ass3Id',Ass3Id)
	  record.set('Asso',Asso)
	  record.set('AssoId',AssoId)
	  record.set('opSub',subopId)
	  //,opdocLoc,opdocLocId,surgeon,surgeonId,Ass1,Ass1Id,Ass2,Ass2Id,Ass3,Ass3Id,Asso,AssoId
	  //20161104+dyl
	  if((obj.listOpNameStore.find('operId',operId)==-1)||(obj.listOpNameStore.find('operDesc',operDesc)==-1))
	  {
	    obj.listOpNameStore.add(record);
		obj.comOpName.setValue("")
		obj.comAnaOpLevel.setValue("")
		obj.comOpBladeType.setValue("")
		obj.txtOpNote.setValue("")
		//20180118
		obj.comSurgeon.setValue("")
		//obj.surgeonLoc.setValue("")
		obj.comAssistDoc1.setValue("")
		obj.comAssistDoc2.setValue("")
		obj.comAssistDoc3.setValue("")
		obj.comAssistDocO.setValue("")
	  }
	  else 
	  alert("�����������")
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
	   alert("��ѡ����������������")
	   return;
	  } 
	  var surgeonId=obj.comSurgeon.getValue()
	  var surgeon=obj.comSurgeon.getRawValue()
	  if(surgeonId=="")
	  {
	   alert("��ѡ������ҽʦ")
	   return;
	  }
	  var opdocLocId=obj.surgeonLoc.getValue()
	  var opdocLoc=obj.surgeonLoc.getRawValue()
	  var Ass1Id=obj.comAssistDoc1.getValue()
	  var Ass1=obj.comAssistDoc1.getRawValue()
	  var Ass2Id=obj.comAssistDoc2.getValue()
	  var Ass2=obj.comAssistDoc2.getRawValue()
	  var Ass3Id=obj.comAssistDoc3.getValue()
	  var Ass3=obj.comAssistDoc3.getRawValue()
	  //��������
	  var AssoId=obj.comAssistDocO.getValue()
	  var Asso=obj.comAssistDocO.getRawValue()
	  
	  selRecord.set('operId',operId);
	  selRecord.set('operDesc',operDesc)
	  selRecord.set('opLevelId',opLevelId)
	  selRecord.set('opLevelDesc',opLevelDesc)
	  selRecord.set('bldTpId',bldTpId)
	  selRecord.set('bldTypeDesc',bldTypeDesc)
	  selRecord.set('operNotes',operNotes)
	  //
	  selRecord.set('opdocLocId',opdocLocId)
	  selRecord.set('opdocLoc',opdocLoc)
	  selRecord.set('surgeonId',surgeonId)
	  selRecord.set('surgeon',surgeon)
	  selRecord.set('Ass1',Ass1)
	  selRecord.set('Ass1Id',Ass1Id)
	  selRecord.set('Ass2',Ass2)
	  selRecord.set('Ass2Id',Ass2Id)
	  selRecord.set('Ass3',Ass3)
	  selRecord.set('Ass3Id',Ass3Id)
	  selRecord.set('Asso',Asso)
	  selRecord.set('AssoId',AssoId)
	  obj.listOpNameStore.commitChanges() 
	  }
	  else
	  {
	   alert("��ѡ��һ����������")
	  }
	 }
	 obj.btnDelete_click=function()
	 {
	  var selRecord=obj.listOpName.getSelectionModel().getSelected()
	  obj.listOpNameStore.remove(selRecord)
	  obj.listOpNameStore.commitChanges() 
	  obj.comOpName.setValue("")
	  obj.comAnaOpLevel.setValue("")
	  obj.comOpBladeType.setValue("")
	  obj.txtOpNote.setValue("")
	  obj.comSurgeon.setValue("")
		//obj.surgeonLoc.setValue("")
		obj.comAssistDoc1.setValue("")
		obj.comAssistDoc2.setValue("")
		obj.comAssistDoc3.setValue("")
		obj.comAssistDocO.setValue("")
	 }
	 obj.btnSave_click=function()
	 {
	  var checkRes=CheckData();    
      if (checkRes==false){ return; }
	  var appLocId=obj.comAppLoc.getValue();
	  var appDocId=obj.comAppDoc.getValue();
	  var preDiscussDate=""
	  //20161214+dyl
	  //var estiOperDuration=obj.timeOperPro.getRawValue()
	  var estiOperDuration=obj.timeOperPro.getValue();
	  var startDate=obj.dateOper.getRawValue()
	  var startTime=obj.timeOper.getRawValue()
	  var opMem=obj.txtAreaOpMem.getValue();
	  var logUserId=session['LOGON.USERID'];
	  var bloodTypeId=obj.comBloodType.getValue();
	  var patHeight=""
	  var patWeight=""
	  var opDocNote=obj.txtOpDocNote.getValue();
	  var opSeqNote=obj.txtOpSeqNote.getValue();
	  var operRoomId=""
	  var arrTime=""
	  var opLevelId=obj.comAnaOpLevel.getValue();
	  var ordNo=""
	  var opaMedInfect=""
	  var transferMeansCode=""
	  //��ȡ������,�����б��еĵ�һ������
	  if(obj.listOpNameStore.getCount()>0)
	  {
	   var mainOPId=obj.listOpNameStore.getAt(0).get("operId")
	   var mainOPLevelId=obj.listOpNameStore.getAt(0).get("opLevelId")
	   var mainBladeTypeId=obj.listOpNameStore.getAt(0).get("bldTpId");
	   var mainOPNote=obj.listOpNameStore.getAt(0).get("operNotes").replace(" ","");

	   var mainopdocLocId=obj.listOpNameStore.getAt(0).get("opdocLocId")
	   var mainSurgeonId=obj.listOpNameStore.getAt(0).get("surgeonId")
	   var mainAss1Id=obj.listOpNameStore.getAt(0).get("Ass1Id")
	   var mainAss2Id=obj.listOpNameStore.getAt(0).get("Ass2Id")
	   var mainAss3Id=obj.listOpNameStore.getAt(0).get("Ass3Id")
	   var mainAssoId=obj.listOpNameStore.getAt(0).get("AssoId")
	   var otherStr=mainopdocLocId+"|"+mainSurgeonId+"|"+mainAss1Id+"|"+mainAss2Id+"|"+mainAss3Id+"|"+mainAssoId;
	   var mainOperIdStr=mainOPId+"|"+mainOPLevelId+"|"+mainOPNote+"|"+mainBladeTypeId+"||"+otherStr; 
	   //
	   //20160114+dyl
		operDescByDing=""
		for(j=0;j<obj.listOpNameStore.getCount();j++)
		{
			var toperDesc=obj.listOpNameStore.getAt(j).get("operDesc");
			if(operDescByDing=="")operDescByDing=toperDesc;
			else
			{
				operDescByDing=toperDesc+"/"+operDescByDing;
			}
		}	
	  }
	  
	  //��ǰ��ϣ���ע
	  var preDiagId=obj.comOpPreDiagnosis.getValue()
	  var preDiagMem=obj.txtOpPreDiagMem.getValue();
	  //������ϣ���ע ����ʱΪ�գ�
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
	 var assDoc1Id=obj.comAssistDoc1.getValue();
	 var assDocIdStr=""
	 for(var i=0;i<3;i++)
	   {
	    var comboxObj=Ext.getCmp("comAssistDoc"+(i+1))
		if(assDocIdStr=="") assDocIdStr=comboxObj.getValue()
		else assDocIdStr=assDocIdStr+"^"+comboxObj.getValue()
	   }
	 var assistDocOIdStr=obj.comAssistDocO.getValue();
	 assistDocOIdStr=assistDocOIdStr.replace(/,/g, "^")
	 if(assDocIdStr=="")assDocIdStr=assistDocOIdStr;
	 else assDocIdStr=assDocIdStr+"^"+assistDocOIdStr
	 //����ֵ��������
	  var RHBloodTypeDesc=obj.comRHBloodType.getRawValue()	  //RHѪ������
	  var HbsAgDesc=obj.comHbsAg.getRawValue() //HbsAg����
	  var HcvAbDesc=obj.comHcvAb.getRawValue() //HcvAb����
	  var HivAbDesc=obj.comHivAb.getRawValue() //HivAb����
	  var RPRDesc=obj.comRPR.getRawValue() //÷������
	  var otherTest=obj.txtOther.getValue()
	  var opType=obj.chkOpType.getValue()  //�Ƿ���
	  var anaSourceType=opType?1:0
	  var needAnaesthetist=obj.chkNeedAnaesthetist.getValue()?"Y":"N"  //�Ƿ���Ҫ����
	  var isolated=obj.chkIsolated.getValue()?"Y":"N"  //�Ƿ����
	  var isPrepareBlood=obj.chkIsPrepareBlood.getValue()?"Y":"N"  //�Ƿ�д
	  var isUseSelfBlood=obj.chkIsUseSelfBlood.getValue()?"Y":"N"  //�Ƿ�����Ѫ����
	  var isExCirculation= obj.chkIsExCirculation.getValue()?"Y":"N" //�Ƿ�����ѭ��
	  var ifMiniInvasive="" //�Ƿ�΢������ʱû�ӣ�
	  var needNavigation=""  //�Ƿ񵼺�����ʱû�ӣ�
	  var anmthId=""
	  var anDocId=obj.comAnaDoc.getValue() 
	  var anSupDocId=obj.comAnaSupervisor.getValue();
	  var anNurseId=obj.comAnaNurse.getValue();
	  var anAssIdStr=obj.comAnaDocO.getValue();
	  var shiftAnAssIdStr=obj.comSAnaDoc.getValue();
	  var anMethodIdStr=obj.comAnaMethod.getValue();
	  var anmthId=obj.comDocAnaMethod.getValue();
	 var anaLevelId=""	//20160908+dyl
	  //var anaLevelId=obj.comAnaLevel.getValue();
	 
	  var anDocNote=obj.txtAnaDocNote.getValue();
	  var ASAId="" //ASA�ּ���ʱû�Ӵ�Ԫ�أ�ȱʡΪ��
	  //���������
	  arrTime=obj.timeArrOper.getRawValue()
      operRoomId=obj.comOperRoom.getValue()
	  ordNo=obj.comOrdNo.getRawValue();
	  var isAddInstrument="" //��ʱû�ӣ�Ϊ��
	  var instrumentId=""
      var scrNurIdStr=obj.comScrubNurse.getValue()
      var sScrNurIdStr=obj.comShiftScrubNurse.getValue()
	  var scrNurNote=obj.txtScrubNurseNote.getValue()
	  var scrNurse=scrNurIdStr+"#"+sScrNurIdStr+"#"+scrNurNote
	  var cirNurIdStr=obj.comCirculNurse.getValue()
	  var sCirNurIdStr=obj.comShiftCirculNurse.getValue()
	  var cirNurNote=obj.txtCirculNurseNote.getValue()
	  var cirNurse=cirNurIdStr+"#"+sCirNurIdStr+"#"+cirNurNote
	  var opReq=obj.txtOpReq.getValue();   //��ע
	  var note=obj.txtNote.getValue();     //ע������
	  var ifShift=obj.chkIfShift.getValue()?"1":"0" 
       var unPlanedOper=obj.unPlanedOper.getValue()?"Y":"N"  //�ط�����
     var OpDocGroup =obj.OpDocGroup.getValue();
      var opDateTime="" ;
      if (appType=="RegOp"){
	    var opDateTime= obj.dateOpStt.getRawValue()+"|"+obj.timeOpStt.getRawValue()+"|"+obj.dateOpEnd.getRawValue()+"|"+obj.timeOpEnd.getRawValue();
       }
	  var strCheck=HbsAgDesc+"^"+HcvAbDesc+"^"+HivAbDesc+"^"+RPRDesc+"^"+anaSourceType+"^"+otherTest+"^"+RHBloodTypeDesc+"^"+isolated+"^"+isPrepareBlood+"^"+isUseSelfBlood
	  +"^"+isExCirculation+"^"+needAnaesthetist+"^"+ifMiniInvasive+"^"+needNavigation+"^"+""+"^"+OpDocGroup+"^"+unPlanedOper+"^"
	  var str1=appLocId+"^"+appDocId+"^"+startDate+"^"+startTime+"^"+logUserId+"^"+EpisodeID+"^"+operRoomId+"^"+opMem+"^"+bloodTypeId+"^"+arrTime+"^"
	  +anaLevelId+"^"+patHeight+"^"+patWeight+"^"+preDiscussDate+"^"+estiOperDuration+"^"+opDocNote+"^"+opSeqNote+"^"+ordNo+"^^"+opaMedInfect+"^"
	  +transferMeansCode
	  var strOp=logUserId+"^"+opReq+"^"+note+"^"+ifShift+"^"+ordNo+"^"+isAddInstrument+"|"+instrumentId+"^"+opDateTime;
	  switch(appType)
      {
	   case "RegOp":
	   case "RegNotApp":
	    if(arguments[0].id=="btnSave")
	    {
	        if (opaId!="")
			{
				var ret=_UDHCANOPArrange.updatewardRecord("InsertAddOnOperation","",opaId,str1,appOperInfo,assDocIdStr,strCheck,anmthId,"RegOp");
				if (ret!=0)
				{
				 window.returnValue=0
				 alert(ret);
				 return;
				}
				else
	            {
				   window.returnValue=1
			       var closeWindow = confirm("����������Ϣ�޸ĳɹ����Ƿ�����޸�������Ϣ��")
			       if(!closeWindow)
			       {
			        window.close()
			       }
				}
			}
			else
			{
			 var ret=_UDHCANOPArrange.insertAnRecord("InsertAddOnOperation","",str1,appOperInfo,assDocIdStr,strCheck,anmthId,"",appType);
			 //alert(ret);
			 //20160830+dyl+��ʾ
			 if (ret.split("^")[0]<0) {alert(ret.split("^")[1]);return;}
			 else opaId=ret;
			}
		}
		 if(arguments[0].id=="btnOpSave")
		   {
			 var ret=_DHCANOPArrange.UpdateOpRecord(opaId,str1,scrNurse,cirNurse,strOp,appType);
			if (ret!=0){
			window.returnValue=0
			alert(ret);return}
			else 
			{
             window.returnValue=1
			 var closeWindow = confirm("��������Ϣ�޸ĳɹ����Ƿ�����޸�������Ϣ��")
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
			  var closeWindow = confirm("������Ϣ�޸ĳɹ����Ƿ�����޸�������Ϣ��")
			  if(!closeWindow)
			  {
			   window.close()
			  }
			 }
		   }
	         break;  
       case "ward": //����
	         var ifDisbled=_UDHCANOPArrange.GetIfOutTime()
			 if((ifDisbled==1)&(opaId=="")&(opType==false)&(admType!="E"))
				{
					alert("����ʱ������,����������������,�빴ѡ����!")
					return ;
				}
			 //------���Ԥ�����ж������Ƿ��ظ�+20160114+dyl
              retSameOper=_UDHCANOPArrange.GetOperByEpisodeID(opaId,EpisodeID,operDescByDing,startDate)
              if(retSameOper=="1")
              {
	            var hh=confirm("�û��ߵ���������һ̨����,ȷ������������?")
				if(hh){}
				else{return;}
          		}		
			//
			if (opaId!="")
			{
				var ret=_UDHCANOPArrange.updatewardRecord("InsertAddOnOperation","",opaId,str1,appOperInfo,assDocIdStr,strCheck,anmthId,"Ward");
				if (ret!=0)
				{
				 window.returnValue=0
				 alert(ret);
				 return
				}
				else
	            {
				   window.returnValue=1
			       var closeWindow = confirm("�����޸ĳɹ����Ƿ�رմ��ڣ�")
			       if(closeWindow)
			       {
			        window.close()
			       }
				}
			}
			else
			{
			 var ret=_UDHCANOPArrange.insertAnRecord("InsertAddOnOperation","",str1,appOperInfo,assDocIdStr,strCheck,anmthId,"",appType);
			 //alert(ret);
			 if (ret.split("^")[0]<0) 
			  {
			    window.returnValue=0;
			    //20160830
			    alert(ret.split("^")[1]);
			    return;
			   }
			  else
	           {
				   window.returnValue=1
			       var closeWindow = confirm("��������ɹ����Ƿ�رմ��ڣ�")
			       if(closeWindow)
			       {
			        window.close()
			       }
				}
			}
        break;	
		case "anaes":   //����
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
			  var closeWindow = confirm("������Ϣ���³ɹ����Ƿ�رմ��ڣ�")
			  if(closeWindow)
			  {
			   window.close()
			  }
			 }
		break;		
        case "op":  //������
			var ret=_DHCANOPArrange.UpdateOpRecord(opaId,str1,scrNurse,cirNurse,strOp,appType);
			if (ret!=0){
			window.returnValue=0
			alert(ret);return}
			else 
			{
             window.returnValue=1
             
			 var closeWindow = confirm("��������Ϣ���³ɹ����Ƿ�رմ��ڣ�")
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
	    //alert(0);
	    var opStr="";
        var anCompStr=""; 
		var n=obj.listOpNameStore.getCount()
	    if (n==0) return;
	    //alert(1);
	   //�ӵڶ���������ʼΪ������
		for(var i=1;i<n;i++)
		{
			var subOPId=obj.listOpNameStore.getAt(i).get("operId");
			var subOPLevelId=obj.listOpNameStore.getAt(i).get("opLevelId");
			var subBladeTypeId=obj.listOpNameStore.getAt(i).get("bldTpId");
			var subOPNote=obj.listOpNameStore.getAt(i).get("operNotes").replace(" ","");
			var subopdocLocId=obj.listOpNameStore.getAt(i).get("opdocLocId")
	   		var subSurgeonId=obj.listOpNameStore.getAt(i).get("surgeonId")
	   		var subAss1Id=obj.listOpNameStore.getAt(i).get("Ass1Id")
	   		var subAss2Id=obj.listOpNameStore.getAt(i).get("Ass2Id")
	   		var subAss3Id=obj.listOpNameStore.getAt(i).get("Ass3Id")
	   		var subAssoId=obj.listOpNameStore.getAt(i).get("AssoId")
			var otherStr=subopdocLocId+"|"+subSurgeonId+"|"+subAss1Id+"|"+subAss2Id+"|"+subAss3Id+"|"+subAssoId;
			var subId=obj.listOpNameStore.getAt(i).get("opSub");
			opStr=opStr+subOPId+"|"+subOPLevelId+"|"+subOPNote+"|"+subBladeTypeId+"|"+subId+"|"+otherStr+"^";
		}
		//alert(2);
   		var ret=_UDHCANOPArrange.insertchlop("","",anaId,opStr,appType);
   		//alert("ret="+ret);
   		if (ret!=0) alert(ret)
	}	

	 CheckData=function()
	 {
	   if((appType=="op")&&(obj.comOperRoom.getValue()==""))
	   {
	       alert("��ѡ��������!");
		   obj.comOperRoom.focus();
		   return false;
	   }
	   if((appType=="op")&&(obj.comOrdNo.getValue()==""))
	   {
	       alert("��ѡ��̨��!");
		   obj.comOrdNo.focus();
		   return false;
	   } 
	  if (EpisodeID==""){
		alert("��ѡ����!");
		return false;
       } 
	   if(obj.comOperLocation.getValue()=="")
	   {
	    alert("��ѡ��������!")
		obj.comOperLocation.focus()
		return false;
	   }
	   if(obj.dateOper.getRawValue()=="")
	   {
	    alert("��ѡ����������!")
		obj.dateOper.focus()
		return false;
	   }
	   if(obj.timeOper.getRawValue()=="")
	   {
	    alert("��ѡ������ʱ��!")
		obj.timeOper.focus()
		return false;
	   }
	   if(obj.comBloodType.getValue()=="")
	   {
	    alert("��ѡ��Ѫ��!")
		obj.comBloodType.focus();
		return false;
	   }
	   //20170324+dyl
	   if(obj.txtOther.getValue().length>30)
	   {
	    alert("������Ϣ�����ַ�������������������")
		obj.txtOther.focus();
		return false;
	   }
	   if(obj.comOpPreDiagnosis.getValue()=="")
	   {
	    alert("��ѡ�����!")
		if ((appType=="ward")||(appType==""))
		obj.comOpPreDiagnosis.focus();
		return false;
	   }
	   if(obj.listOpName.getStore().getCount()==0)
	   {
	    alert("��ѡ������!")
		obj.comOpName.focus()
		return false;
	   }
	   if(obj.comSurgeon.getValue()=="")
	   {
	   // alert("��ѡ������ҽ��!");
		//obj.comSurgeon.focus();
		//return false;
	   }
	   if((appType!="op")&&(appType!="ward")&&(obj.comAnaDoc.getValue()==""))
	   {
	     alert("��ѡ����������ҽʦ��")
		 obj.comAnaDoc.focus()
		 return false;
	   }
	    if((appType!="op")&&(appType!="ward")&&(obj.comAnaMethod.getValue()==""))
	   {
	     alert("��ѡ����������")
		 obj.comAnaMethod.focus()
		 return false;
	   }
	 }
	 //
	 obj.chkOpType_check=function()
	 {
		  var ifDisbled=_UDHCANOPArrange.GetIfOutTime()  //yq 20180720 �Ƿ�ٳ�ʱ�䷶Χ
		  var opType=obj.chkOpType.getValue()  //�Ƿ���
		  var anaSourceType=opType?1:0;
		  
		  if(anaSourceType==1)
		  {
			  obj.dateOper.setRawValue(_DHCANOPCom.GetCurentDate("1"));
		  }
		  else
  		  {
  			obj.dateOper.setRawValue(_DHCANOPCom.GetInitialDateTow(session['LOGON.USERID'],session['LOGON.GROUPID'],session['LOGON.CTLOCID']))
  		  }
  		  if((ifDisbled==0)||(anaSourceType==1))
  		  {
	  		 obj.btnSave.enable()
	  	  }
	  	  if((ifDisbled!=0)&&(anaSourceType!=1))
	  	  {
		  	  obj.btnSave.disable(); 
		  }
	 }
	 //
	 obj.surgeonLoc_select=function()
	 {
	  obj.OpDocGroupStore.reload({})
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
}