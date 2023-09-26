/// 描述：抓起三管相关数据
Class DHCMed.NINFService.Sta.InfStatICUInf Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatICUInf).ProcessICUData(20001613)
ClassMethod ProcessICUData(Paadm As %String)
{
	New (Paadm)	
	Set Rtn=##Class(DHCMed.NINF.Srv.InfStatICUInfo).DeleteByPaadm(Paadm)
	Set ICUDataSource=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFICUStatDataSource","")
	If (ICUDataSource=0){
		Set Rtn=..GetDataFromEPR(Paadm)
	}ElseIf(ICUDataSource=1){
		Set Rtn=..GetDataFromICUOfRep(Paadm)
	}
	Quit Rtn
}

/// 描述：根据Paadm获取ICU上报数据
ClassMethod GetDataFromICUOfRep(Paadm As %String)
{
	New (Paadm)	
	;^DHCMed.NINFi("InfRep",0,"IndexPaadm",18661742,3)
	Set RepID=0,Count=0
	For {
		Set RepID=$O(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,RepID))
		Quit:RepID=""
		Set SubID=0
		For {
			Set SubID=$O(^DHCMed.NINF("InfRep",RepID,"ICU",SubID))	
			Quit:SubID=""
			Set ICUObj=##Class(DHCMed.NINF.Rep.InfReportICU).GetObjById(RepID_"||"_SubID)
			Continue:'$IsObject(ICUObj)
			
			Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
			Set Obj.InDate=ICUObj.IntubateDate_","_ICUObj.IntubateTime
			Set Obj.OutDate=ICUObj.ExtubateDate_","_ICUObj.ExtubateTime
			Set PlaceDic=ICUObj.IntubatePlace
			Set Obj.Address=PlaceDic.Description
			Set Obj.InOperator=ICUObj.IntubateUser
			Set ICUDic=ICUObj.IntubateType,Type=""
			If ($IsObject(ICUDic)){
				Set DicCode=ICUDic.Code	
			}
			Set:DicCode="PICC" Obj.Type="VC"
			Set:DicCode="VAP" Obj.Type="VT"
			Set:DicCode="UC" Obj.Type="C"
			Set Obj.Paadm=Paadm
			
			Set sc=Obj.%Save()
	     	If $System.Status.IsError(sc) {  //检查Save是否成功
   			    Do $System.OBJ.DisplayError(sc)
   				Set return=-1
   		 		
	     	} Else {
		  		 Set return=Obj.%Id()
	    	}
	        Do Obj.%Close()
	        Set Count=$i(Count)
		}
	}
	
  Quit Count
}

/// Debug:W ##Class(DHCMed.NINFService.Sta.InfStatICUInf).GetDataFromEPR(277)
ClassMethod GetDataFromEPR(Paadm As %String)
{
	New (Paadm)
	Set ReportID="",InstanceDataID="",NPaadm=" "_Paadm,return=-100
	Set ProjID=##class(DHCMed.CR.Project).GetIdByCode("ICU","Y")
	For {
	     Set ReportID=$O(^DHCMed.CR.ReportI("EpisodeID",NPaadm,ReportID),-1)
	     Quit:ReportID=""
	     
	     Set ObjReport=##Class(DHCMed.CR.Report).%OpenId(ReportID)
	     Set InstanceDataID=ObjReport.InstanceID
	     Set ProjectID=ObjReport.ProjectID
	     Continue:ProjID'=ProjectID   ;判断是不是ICU报告
	     
	     Set TIDValue=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("InfICUTIDValue","")
	     Quit:TIDValue=""
	     
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     
	     Set Obj.Text3=..GetEPRData(Paadm,"静脉导管腔数1.O0068#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0068#VTYPE:V",InstanceDataID)
	     Set Obj.Text2=..GetEPRData(Paadm,"静脉部位1.O0071#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0071#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"静脉插管日期1.D0074#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0074#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"静脉拔管或转出日期1.D0077#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0077#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"静脉插管操作者1.O0080#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0080#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"静脉插管操作者1.O0080#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0080#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"静脉置管地点1.O0083#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0083#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"静脉感染日期1.D0123#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0123#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="VC"
	     ;TStart
	     If ((InDate>0)&&(OutDate>0)){
	     		Set sc=Obj.%Save()
	     		If $System.Status.IsError(sc) {  //检查Save是否成功
   				 Do $System.OBJ.DisplayError(sc)
   				 Set return=-1
   		 		;TRollBack
	     		} Else {
		  		 Set return=Obj.%Id()
	    		 }
	     }
	     Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	
	     Set Obj.Text3=..GetEPRData(Paadm,"静脉导管腔数1.O0069#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0069#VTYPE:V",InstanceDataID)
	     Set Obj.Text2=..GetEPRData(Paadm,"静脉部位1.O0072#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0072#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"静脉插管日期1.D0075#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0075#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"静脉拔管或转出日期1.D0078#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0078#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"静脉插管操作者1.O0081#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0081#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"静脉插管操作者1.O0081#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0081#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"静脉置管地点1.O0084#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0084#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"静脉感染日期1.D0124#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0124#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="VC"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	          If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		       Set return=-1
   		       ;TRollBack
	           } Else {
		        Set return=Obj.%Id()
	          }
	     }
	     Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text3=..GetEPRData(Paadm,"静脉导管腔数1.O0070#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0070#VTYPE:V",InstanceDataID)
	     Set Obj.Text2=..GetEPRData(Paadm,"静脉部位1.O0073#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0073#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"静脉插管日期1.D0076#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0076#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"静脉拔管或转出日期1.D0079#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0079#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"静脉插管操作者1.O0082#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0082#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"静脉插管操作者1.O0082#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0082#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"静脉置管地点1.O0085#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0085#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"静脉感染日期1.D0125#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0125#VTYPE:V",InstanceDataID)
	     Set Obj.InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.Type="VC"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	     //呼吸机1
	     Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text1=..GetEPRData(Paadm,"呼吸机导管类型1.O0086#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0086#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"呼吸机插管日期1.D0089#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0089#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"呼吸机拔管或转出日期1.D0092#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0092#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"呼吸机插管操作者1.O0095#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0095#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"呼吸机插管操作者1.O0095#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0095#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"呼吸机置管地点1.O0098#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0098#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"呼吸机感染日期1.D0129#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0129#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="VT"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	     
	      //呼吸机3
	      Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text1=..GetEPRData(Paadm,"呼吸机导管类型1.O0087#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0087#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"呼吸机插管日期1.D0090#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0090#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"呼吸机拔管或转出日期1.D0093#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0093#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"呼吸机插管操作者1.O0096#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0096#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"呼吸机插管操作者1.O0096#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0096#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"呼吸机置管地点1.O0099#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0099#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"呼吸机感染日期1.D0130#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0130#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="VT"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	     
	      //呼吸机3
	      Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text1=..GetEPRData(Paadm,"呼吸机导管类型1.O0088#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0088#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"呼吸机插管日期1.D0091#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0091#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"呼吸机拔管或转出日期1.D0094#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0094#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"呼吸机插管操作者1.O0097#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0097#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"呼吸机插管操作者1.O0097#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0097#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"呼吸机置管地点1.O0100#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0100#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"呼吸机感染日期1.D0131#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0131#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="VT"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	     
	     //尿管导管1
	     Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text1=..GetEPRData(Paadm,"尿管导管类型1.O0101#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0101#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"尿管插管日期1.D0104#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0104#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"尿管拔管或转出日期1.D0107#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0107#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"尿管插管操作者1.O0111#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0111#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"尿管插管操作者1.O0111#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0111#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"尿管置管地点1.O0114#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0114#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"尿管感染日期1.D0139#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0139#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="C"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	     
	     //尿管导管2
	     Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text1=..GetEPRData(Paadm,"尿管导管类型1.O0102#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0102#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"尿管插管日期1.D0104#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0105#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"尿管拔管或转出日期1.D0109#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0109#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"尿管插管操作者1.O0112#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0112#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"尿管插管操作者1.O0112#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0112#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"尿管置管地点1.O0115#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0115#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"尿管感染日期1.D0140#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0140#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="C"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	     
	     //尿管导管3
	     Do Obj.%Close()
	     Set Obj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%New()
	     Set InICUDate=..GetEPRData(Paadm,"转入ICU日期/时间D0006#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0006#VTYPE:V",InstanceDataID)
	   
	     Set InICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InICUDate)
	     Set Obj.InICUDate=InICUDate
	     Set OutICUDate=..GetEPRData(Paadm,"转出ICU日期/时间D0007#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0007#VTYPE:V",InstanceDataID)
	     Set OutICUDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutICUDate)
	     Set Obj.OutICUDate=OutICUDate
	     //Set Obj.ParOfBaseInfo=ParRef
	     Set Obj.Paadm=Paadm
	     
	     Set Obj.OutICUPlace=..GetEPRData(Paadm,"转出至I0008#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0008#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag1=..GetEPRData(Paadm,"转入ICU的诊断1I0010#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0010#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag2=..GetEPRData(Paadm,"转入ICU的诊断2I0011#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0011#VTYPE:V",InstanceDataID)
	     Set Obj.InICUDiag3=..GetEPRData(Paadm,"转入ICU的诊断3I0012#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0012#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag1=..GetEPRData(Paadm,"ICU的诊断1I0013#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0013#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag2=..GetEPRData(Paadm,"ICU的诊断2I0014#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0014#VTYPE:V",InstanceDataID)
	     Set Obj.ICUDiag3=..GetEPRData(Paadm,"ICU的诊断3I0015#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:I0015#VTYPE:V",InstanceDataID)
	     Set Obj.Text1=..GetEPRData(Paadm,"尿管导管类型1.O0103#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0103#VTYPE:V",InstanceDataID)
	     Set InDate=..GetEPRData(Paadm,"尿管插管日期1.D0106#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0106#VTYPE:V",InstanceDataID)
	     Set InDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InDate)
	     Set Obj.InDate=InDate
	     Set OutDate=..GetEPRData(Paadm,"尿管拔管或转出日期1.D0110#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0110#VTYPE:V",InstanceDataID)
	     Set OutDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(OutDate)
	     Set Obj.OutDate=OutDate
	     Set Obj.InOperator=..GetEPRData(Paadm,"尿管插管操作者1.O0113#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0113#VTYPE:V",InstanceDataID)
	     Set Obj.OutOperator=..GetEPRData(Paadm,"尿管插管操作者1.O0113#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0113#VTYPE:V",InstanceDataID)
	     Set Obj.Address=..GetEPRData(Paadm,"尿管置管地点1.O0116#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:O0116#VTYPE:V",InstanceDataID)
	     Set InfDate=..GetEPRData(Paadm,"尿管感染日期1.D0141#TYPE:Simple#TID:"_TIDValue_"#TVER:0#SCODE:D0141#VTYPE:V",InstanceDataID)
	     Set InfDate=##Class(DHCMed.NINF.Srv.InfStatICUInfo).ConvertToDate(InfDate)
	     Set Obj.InfDate=InfDate
	     Set Obj.Type="C"
	     If ((InDate>0)&&(OutDate>0)){
	          Set sc=Obj.%Save()
	     	   If $System.Status.IsError(sc) {  //检查Save是否成功
   		       Do $System.OBJ.DisplayError(sc)
   		 	Set return=-1
   		 	;TRollBack
	    	   } Else {
			   Set return=Obj.%Id()
	         }
	     }
	    ;TCommit
	    Do Obj.%Close()
	}
	Quit return
}

/// w ##Class(DHCMed.NINFService.Sta.InfStatICUInf).GetEPRData(277,"#TYPE:Simple#TID:105#TVER:0#SCODE:S0001#VTYPE:V","645||2")
ClassMethod GetEPRData(Paadm As %String, ItemPara As %String, InstanceDataID As %String) As %String
{
	New (Paadm, ItemPara ,InstanceDataID)
	Set Rtn=##class(EPRservice.BOScatterData).GetEPRMultipleData(Paadm, ItemPara ,InstanceDataID)
	Quit Rtn
}

}
