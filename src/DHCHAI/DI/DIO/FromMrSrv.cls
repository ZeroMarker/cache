/// 名称: DHCHAI.DI.DIO.FromMrSrv
/// 描述: 病案编目数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromMrSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-07
/// Description:  通过HIS就诊ID取患者首页手术信息
/// Table：       接口
/// Input：       HIS就诊ID
/// Return：      首页手术信息
/// w ##Class(DHCHAI.DI.DIO.FromMrSrv).GetEmrOperInfo(20)
ClassMethod GetEmrOperInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetEmrOperInfoErr"
	// 首页手术接口信息
	Set EmrOperInfo = ""
	Set ds = ##class(%Library.ResultSet).%New("DHCHAI.DI.DIO.FromMrSrv:QryEMROprList")
	Do ds.Execute(aEpisodeID)
	
	Set IsSyncTCMPage = ##class(DHCHAI.BT.Config).GetValByCode("DPEmrIsSyncTCMPage")  // 1：同步	
	Set Flag=rs.Next()
	If (Flag=0)&&(IsSyncTCMPage=1) {

	  	Set ds=##Class(%Library.ResultSet).%New("DHCHAI.DI.DIO.FromMrSrv:QryTCMEMROprList")    //中医住院病案首页
	  	Do ds.Execute(aEpisodeID)
  	}
  	
	While (Flag||rs.Next()){
		Set Flag=0
		// 手术记录ID,首页没有记录ID,系统随机生成32GUID编码作为唯一标示
		Set OperID         = ##Class(DHCHAI.Utils.CommonSrv).GetGUIDCode()   
		Set EpisodeID      = aEpisodeID              // HIS就诊ID
		Set OperICD        = ds.Data("OperICD")      // 手术编码
		Set OperDesc       = ds.Data("OperDesc")     // 手术名称
		Set OperType       = ds.Data("OperType")     // 手术类型
		Set StartDate      = ds.Data("OperDate")     // 手术开始日期
		Set StartTime      = ds.Data("SttTime")      // 手术开始时间
		Set EndDate        = ds.Data("EndDate")      // 手术结束日期
		Set EndTime        = ds.Data("EndTime")      // 手术结束时间
		Set OperHour       = ds.Data("OperHour")     // 手术时长
		Set OperLocCode    = ds.Data("OperLocCode")  // 手术科室代码
		Set OperLocDesc    = ds.Data("OperLocDesc")  // 手术科室 
		Set OpertorCode    = ds.Data("OpertorCode")  // 术者代码
		Set OpertorName    = ds.Data("OpertorName")  // 术者名称
		Set Assistant1     = ds.Data("Assistant1")   // 一助
		Set Assistant2     = ds.Data("Assistant2")   // 二助
		Set IncisionCode   = ds.Data("IncisionCode") // 切口类型代码 和描述一样,首页数据没做存储
		Set Incision       = ds.Data("Incision")     // 切口类型
		Set HealingCode    = ds.Data("HealingCode")  // 愈合情况代码
		Set Healing        = ds.Data("Healing")      // 愈合情况
		Set AnesMethodCode = ds.Data("AnesMethodCode") // 麻醉方式代码
		Set AnesMethod     = ds.Data("AnesMethod")   // 麻醉方式
		Set Anesthesia     = ds.Data("Anesthesia")   // 麻醉医生
		Set ASAScore       = ds.Data("ASAScore")     // ASA评分
		Set NNISGrade      = ds.Data("NNISGrade")    // NNIS分级
		Set IsActive       = "1"                     // 有效标志
		
		Set tmpOperInfo = OperID_"^"_aEpisodeID_"^"_OperICD_"^"_OperDesc_"^"_OperType_"^"_StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_OperHour_"^"_OperLocCode
		Set tmpOperInfo = tmpOperInfo_"^"_OperLocDesc_"^"_OpertorCode_"^"_OpertorName_"^"_Assistant1_"^"_Assistant2_"^"_IncisionCode_"^"_Incision_"^"_HealingCode_"^"_Healing
		Set tmpOperInfo = tmpOperInfo_"^"_AnesMethodCode_"^"_AnesMethod_"^"_Anesthesia_"^"_ASAScore_"^"_NNISGrade_"^"_IsActive
		
		Set EmrOperInfo = EmrOperInfo_"#"_tmpOperInfo
		
	}
	Set:EmrOperInfo'="" EmrOperInfo=$e(EmrOperInfo,2,$l(EmrOperInfo))
	Set return=EmrOperInfo
	Quit return
GetEmrOperInfoErr
	Quit "-999^"_$ZError
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-06
/// Description:  通过编目ID获取手术编目信息
/// Table：       接口
/// Input：       HIS就诊ID
/// Return：      手术编目信息,多条以"$c(1)"分隔
/// w ##Class(DHCHAI.DI.DIO.FromMrSrv).GetWmrOperInfo(2)
ClassMethod GetWmrOperInfo(aFpID As %String) As %String
{
	New (aFpID)
	Set return=""
	Quit:aFpID="" return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-30
/// Description:  查询编目手术信息
/// Input：       aEpisodeID : HIS就诊ID
/// Return：      ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromMrSrv","QryWMROprList","1544904")
Query QryWMROprList(aEpisodeID As %String) As %Query(ROWSPEC = "OperID:%String,OperDesc:%String,OperICD:%String,OperType:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OperHour:%String,OperLocDesc:%String,OperLocCode:%String,OpertorName:%String,OpertorCode:%String,Assistant1:%String,Assistant2:%String,Incision:%String,IncisionCode:%String,Healing:%String,HealingCode:%String,AnesMethod:%String,AnesMethodCode:%String,Anesthesia:%String,ASAScore:%String,NNISGrade:%String") [ SqlProc ]
{
}

ClassMethod QryWMROprListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
 	Quit:'$IsObject(objVol) $$$OK
 	Set VolID=objVol.%Id()
 	
 	Set xFPID=0
 	For {
 		Set xFPID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",VolID,"F",xFPID))
 		Quit:xFPID=""
 		
		Set xTypeID=0
		For {
			Set xTypeID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",xFPID,xTypeID))
			Quit:xTypeID=""
			
			Set xIndex=""
			For {
				Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",xFPID,xTypeID,xIndex))
				Quit:xIndex=""
				
				Set xSubID=0
				For {
					Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",xFPID,xTypeID,xIndex,xSubID))
					Quit:xSubID=""
					
					Set Data=..GetWMROperByID(xFPID_"||"_xSubID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
 	}
	Quit $$$OK
}

ClassMethod QryWMROprListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWMROprListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWMROprListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWMROprListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetWMROperByID(aFPOperID As %String) As %String
{
	New (aFPOperID)
	Set return=""
	Quit:aFPOperID="" return
	
	Set obj=##class(DHCWMR.FP.FPOperation).GetObjById(aFPOperID)
	Quit:'$IsObject(obj) return
	If $IsObject(obj.FPOICDDr){
		Set ICD10=obj.FPOICDDr.IDICD10
		Set ICDDesc=obj.FPOICDDr.IDDesc
	}
	Set OperDate=obj.FPOSttDate
	Set:OperDate'="" OperDate=$zd(OperDate,3)
	Set OSttTime=obj.FPOSttTime
	Set:OSttTime'="" OSttTime=$zt(OSttTime,1)
	Set OEndDate=obj.FPOEndDate
	Set:OEndDate'="" OEndDate=$zd(OEndDate,3)
	Set OEndTime=obj.FPOEndTime
	Set:OEndTime'="" OEndTime=$zt(OEndTime,1)
	Set OperatorCode=obj.FPOOperator
	Set OperatorName=obj.FPOOperatorTxt
	Set Ass1Code=obj.FPOAssistant1
	Set Ass1Name=obj.FPOAssistant1Txt
	Set Ass2Code=obj.FPOAssistant2
	Set Ass2Name=obj.FPOAssistant2Txt
	Set NarcDocCode=obj.FPONarcosisDoc
	Set NarcDocDesc=obj.FPONarcosisDocTxt
	If $IsObject(obj.FPONarcosisType){
		Set NarcTypeCode=obj.FPONarcosisType.SDCode
		Set NarcTypeDesc=obj.FPONarcosisType.SDDesc
	}
	If $IsObject(obj.FPOCutType){
		Set CutTypeCode=obj.FPOCutType.SDCode
		Set CutTypeDesc=obj.FPOCutType.SDDesc
	}
	If $IsObject(obj.FPOHealing){
		Set HealingCode=obj.FPOHealing.SDCode
		Set HealingDesc=obj.FPOHealing.SDDesc
	}
	If $IsObject(obj.FPOOperLevel){  //手术级别：一级、二级、三级、四级手术
		Set OperLevelCode=obj.FPOOperLevel.SDCode
		Set OperLevelDesc=obj.FPOOperLevel.SDDesc
	}
	Set return=""
	Set $list(return,1)=$g(aFPOperID)        // 手术记录ID
	Set $list(return,2)=$g(ICDDesc)          // 手术名称
	Set $list(return,3)=$g(ICD10)            // 手术ICD
	Set $list(return,4)=""                   // 手术类型  择期、急诊编目没有
	Set $list(return,5)=$g(OperDate)         // 手术开始日期
	Set $list(return,6)=$g(OSttTime)         // 手术开始时间
	Set $list(return,7)=$g(OEndDate)         // 手术结束日期
	Set $list(return,8)=$g(OEndTime)         // 手术结束时间
	Set $list(return,9)=""                   // 手术时长(小时)
	Set $list(return,10)=""                  // 手术科室
	Set $list(return,11)=""                  // 手术科室代码
	Set $list(return,12)=$g(OperatorName)    // 术者
	Set $list(return,13)=$g(OperatorCode)    // 术者代码
	Set $list(return,14)=$g(Ass1Name)        // 1助
	Set $list(return,15)=$g(Ass2Name)        // 2助
	Set $list(return,16)=$g(CutTypeDesc)     // 切口类型
	Set $list(return,17)=$g(CutTypeCode)     // 切口类型代码
	Set $list(return,18)=$g(HealingDesc)     // 愈合情况
	Set $list(return,19)=$g(HealingCode)     // 愈合情况代码
	Set $list(return,20)=$g(NarcTypeDesc)    // 麻醉方式
	Set $list(return,21)=$g(NarcTypeCode)    // 麻醉方式代码
	Set $list(return,22)=$g(NarcDocDesc)     // 麻醉医师
	Set $list(return,23)=""                  // ASA评分
	Set $list(return,24)=""                  // NNIS分级
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-08-13
/// Description:  查询编目手术信息
/// Input：       aEpisodeID : HIS就诊ID
/// Return：      ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromMrSrv","QryIPMROprList","1544904")
Query QryIPMROprList(aEpisodeID As %String) As %Query(ROWSPEC = "OperID:%String,OperDesc:%String,OperICD:%String,OperType:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OperHour:%String,OperLocDesc:%String,OperLocCode:%String,OpertorName:%String,OpertorCode:%String,Assistant1:%String,Assistant2:%String,Incision:%String,IncisionCode:%String,Healing:%String,HealingCode:%String,AnesMethod:%String,AnesMethodCode:%String,Anesthesia:%String,ASAScore:%String,NNISGrade:%String") [ SqlProc ]
{
}

ClassMethod QryIPMROprListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	
 	Set objVolPaadm=##class(MA.IPMR.SS.VolPaadm).GetPatObjByAdm(aEpisodeID)
	Quit:'$IsObject(objVolPaadm) $$$OK
	Quit:'$IsObject(objVolPaadm.Parref) $$$OK
	Set VolumeID=objVolPaadm.Parref.%Id()

	Set DataMasterID = $o(^MA.IPMR.FP.DataMasterI("IndexVolume",VolumeID,""))
	Set objDataMaster=##class(MA.IPMR.FP.DataMaster).GetObjById(DataMasterID)
	Quit:'$IsObject(objDataMaster) $$$OK
	Quit:objDataMaster.FDStatus'="C" $$$OK //未完成

 	Set xIndex=""
	For {
		Set xIndex=$o(^MA.IPMR.FP.DataMasterI("Oper","IndexFCIndex",DataMasterID,xIndex))
		Quit:xIndex=""
		Set xSubID=0
		For {
			Set xSubID=$o(^MA.IPMR.FP.DataMasterI("Oper","IndexFCIndex",DataMasterID,xIndex,xSubID))
			Quit:xSubID=""
			Set obj=##class(MA.IPMR.FP.CodeOper).GetObjById(DataMasterID_"||"_xSubID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.FCType)
			//Continue:obj.FCType.BDCode'="O"// OperType 1手术 2诊断性操作 3治疗性操作 4介入治疗
			
			Set Data=..GetIPMROperByID(DataMasterID_"||"_xSubID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 
		}		
		
 	}
	Quit $$$OK
}

ClassMethod QryIPMROprListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIPMROprListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIPMROprListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIPMROprListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIPMROperByID(aOperID As %String) As %String
{
	New (aOperID)
	Set return=""
	Quit:aOperID="" return
	
	Set obj=##class(MA.IPMR.FP.CodeOper).GetObjById(aOperID)
	Quit:'$IsObject(obj) return
	If $IsObject(obj.FCICDDr){
		Set ICD10=obj.FCICDDr.FIICD10
		Set ICDDesc=obj.FCICDDr.FIDesc
	}
	Set SttDate=obj.FCSttDate
	Set:SttDate'="" SttDate=$zd(SttDate,3)
	Set SttTime=obj.FCSttTime
	Set:SttTime'="" SttTime=$zt(SttTime)
	Set EndTime=obj.FCEndTime
	Set:EndTime'="" EndTime=$zt(EndTime)
	Set EndDate=obj.FCEndDate
	Set:EndDate'="" EndDate=$zd(EndDate,3)
	Set Index = obj.FCIndex
	Set OperatorID		= obj.FCOperatorID
	Set OperatorTxt		= obj.FCOperatorTxt
	Set Assistant1ID	= obj.FCAssistant1ID
	Set Assistant1Txt	= obj.FCAssistant1Txt
	Set Assistant2ID	= obj.FCAssistant2ID
	Set Assistant2Txt	= obj.FCAssistant2Txt
	Set NarcosisDocID	= obj.FCNarcosisDocID
	Set NarcosisDocTxt	= obj.FCNarcosisDocTxt
	Set (NarcosisTypeCode,NarcosisTypeCode,CutTypeCode,CutTypeDesc,HealingCode,HealingDesc,OperLevelCode,OperLevelDesc)=""
	If $IsObject(obj.FCNarcosisType){
		Set NarcosisTypeCode=obj.FCNarcosisType.BDCode
		Set NarcosisTypeDesc=obj.FCNarcosisType.BDDesc
	}
	If $IsObject(obj.FCCutType){
		Set CutTypeCode=obj.FCCutType.BDCode
		Set CutTypeDesc=obj.FCCutType.BDDesc
	}
	If $IsObject(obj.FCHealing){
		Set HealingCode=obj.FCHealing.BDCode
		Set HealingDesc=obj.FCHealing.BDDesc
	}
	//把切口类型与愈合情况合并
	Set CloseUpCode=$g(CutTypeCode)_"/"_$g(HealingCode)
	Set CloseUpDesc=$g(CutTypeDesc)_"/"_$g(HealingDesc)
	
	If $IsObject(obj.FCOperLevel){   //手术级别：一级、二级、三级、四级手术
		Set OperLevelCode=obj.FCOperLevel.BDCode
		Set OperLevelDesc=obj.FCOperLevel.BDDesc
	}
		
	Set return=""
	Set $list(return,1)=$g(aOperID)          // 手术记录ID
	Set $list(return,2)=$g(ICDDesc)          // 手术名称
	Set $list(return,3)=$g(ICD10)            // 手术ICD
	Set $list(return,4)=""                   // 手术类型  择期、急诊编目没有
	Set $list(return,5)=$g(SttDate)          // 手术开始日期
	Set $list(return,6)=$g(SttTime)          // 手术开始时间
	Set $list(return,7)=$g(EndDate)          // 手术结束日期
	Set $list(return,8)=$g(EndTime)          // 手术结束时间
	Set $list(return,9)=""                   // 手术时长(小时)
	Set $list(return,10)=""                  // 手术科室
	Set $list(return,11)=""                  // 手术科室代码
	Set $list(return,12)=$g(OperatorTxt)     // 术者
	Set $list(return,13)=$g(OperatorID)      // 术者代码
	Set $list(return,14)=$g(Assistant1Txt)        // 1助
	Set $list(return,15)=$g(Assistant2Txt)        // 2助
	Set $list(return,16)=$g(CutTypeDesc)     // 切口类型
	Set $list(return,17)=$g(CutTypeCode)     // 切口类型代码
	Set $list(return,18)=$g(HealingDesc)     // 愈合情况
	Set $list(return,19)=$g(HealingCode)     // 愈合情况代码
	Set $list(return,20)=$g(NarcosisTypeDesc)    // 麻醉方式
	Set $list(return,21)=$g(NarcosisTypeCode)    // 麻醉方式代码
	Set $list(return,22)=$g(NarcosisDocTxt)      // 麻醉医师
	Set $list(return,23)=""                  // ASA评分
	Set $list(return,24)=""                  // NNIS分级
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-07
/// Description:  查询首页手术信息
/// Input：       aEpisodeID : HIS就诊ID
/// Return：      ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromMrSrv","QryEMROprList","1544904")
Query QryEMROprList(aEpisodeID As %String) As %Query(ROWSPEC = "OperID:%String,OperDesc:%String,OperICD:%String,OperType:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OperHour:%String,OperLocDesc:%String,OperLocCode:%String,OpertorName:%String,OpertorCode:%String,Assistant1:%String,Assistant2:%String,Incision:%String,IncisionCode:%String,Healing:%String,HealingCode:%String,AnesMethod:%String,AnesMethodCode:%String,Anesthesia:%String,ASAScore:%String,NNISGrade:%String") [ SqlProc ]
{
}

ClassMethod QryEMROprListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	
 	//取病历首页唯一索引
 	Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(aEpisodeID,"HDSD00.11.090","","")
 	Set XCode="",OperID=""
	Set xInstanceID=""
	For	{
	    Set value=arr.GetNext(.xInstanceID)
	    Quit:xInstanceID=""
	    Continue:XCode'=""
		Set XCode = $p(xInstanceID,",",1)      // 记录索引码 xInstanceID=InstanceID_","_GlossaryCode
	}
	Set OperID=$s(XCode'="":XCode,1:aEpisodeID)
 	// 三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
 	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
 
	// 手术一
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.11.090",.ArrGlossary)        // 手术及操作名称1
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.11.089",.ArrGlossary) // 手术编码1
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.11.869",.ArrGlossary) // 手术类型1
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.11.091",.ArrGlossary) // 手术开始日期时间1
		Set OperDate     = $p(OperDateTime," ",1)
		//处理日期问题
		Set OperDateL =+$l(OperDate)
		If ((OperDateL<10)||(OperDateL>10)){
			Set OperDate =""
			}
		else{
			Set OperDate = $zdh(OperDate,3)
			}
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.11.406",.ArrGlossary) // 手术结束日期时间1
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.11.974",.ArrGlossary) // 手术持续时间1
		Set OperLocDesc  =..GetEPRData(aEpisodeID,"HDSD00.11.783",.ArrGlossary) // 手术科室1
		Set OperLocCode  =..GetEPRData(aEpisodeID,"HDSD00.11.784",.ArrGlossary) // 手术科室代码1
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.11.094",.ArrGlossary) // 手术医生1
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.11.407",.ArrGlossary) // 手术医生工号1
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.11.001",.ArrGlossary) // 一助1
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.11.002",.ArrGlossary) // 二助1
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.11.093",.ArrGlossary) // 切口等级代码1
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.11.615",.ArrGlossary) // 切口等级1
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.11.616",.ArrGlossary) // 愈合情况1
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.11.082",.ArrGlossary) // 愈合情况代码1
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.11.852",.ArrGlossary) // 麻醉方式1
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.11.073",.ArrGlossary) // 麻醉方式代码1
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.11.074",.ArrGlossary) // 麻醉医师1
		Set ASAScore     = "" // ASA评分1
		Set NNISGrade    = "" // NNIS分级1
		Set Data = $lb(OperID_"||"_1,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术二
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.11.414",.ArrGlossary)        // 手术及操作名称2
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.11.410",.ArrGlossary) // 手术编码2
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.11.869",.ArrGlossary) // 手术类型2
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.11.411",.ArrGlossary) // 手术开始日期时间2
		Set OperDate     = $p(OperDateTime," ",1)
		Set OperDateL =+$l(OperDate)
		If ((OperDateL<10)||(OperDateL>10)){
			Set OperDate =""
			}
		else{
			Set OperDate = $zdh(OperDate,3)
			}
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.11.412",.ArrGlossary) // 手术结束日期时间2
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.11.975",.ArrGlossary) // 手术持续时间2
		Set OperLocDesc  =..GetEPRData(aEpisodeID,"HDSD00.11.785",.ArrGlossary) // 手术科室2
		Set OperLocCode  =..GetEPRData(aEpisodeID,"HDSD00.11.786",.ArrGlossary) // 手术科室代码2
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.11.416",.ArrGlossary) // 手术医生2
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.11.415",.ArrGlossary) // 手术医生工号2
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.11.418",.ArrGlossary) // 一助2
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.11.420",.ArrGlossary) // 二助2
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.11.617",.ArrGlossary) // 切口等级2
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.11.421",.ArrGlossary) // 切口等级代码2
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.11.618",.ArrGlossary) // 愈合情况2
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.11.422",.ArrGlossary) // 愈合情况代码2
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.11.853",.ArrGlossary) // 麻醉方式2
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.11.423",.ArrGlossary) // 麻醉方式代码2
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.11.424",.ArrGlossary) // 麻醉医师2
		Set ASAScore     = "" // ASA评分2
		Set NNISGrade    = "" // NNIS分级2
		Set Data = $lb(OperID_"||"_2,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术三
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.11.429",.ArrGlossary)        // 手术及操作名称3
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.11.425",.ArrGlossary) // 手术编码3
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.11.869",.ArrGlossary) // 手术类型3
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.11.426",.ArrGlossary) // 手术开始日期时间3
		Set OperDate     = $p(OperDateTime," ",1)
		Set OperDateL =+$l(OperDate)
		If ((OperDateL<10)||(OperDateL>10)){
			Set OperDate =""
			}
		else{
			Set OperDate = $zdh(OperDate,3)
			}
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.11.427",.ArrGlossary) // 手术结束日期时间3
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.11.976",.ArrGlossary) // 手术持续时间3
		Set OperLocDesc  =..GetEPRData(aEpisodeID,"HDSD00.11.787",.ArrGlossary) // 手术科室3
		Set OperLocCode  =..GetEPRData(aEpisodeID,"HDSD00.11.788",.ArrGlossary) // 手术科室代码3
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.11.431",.ArrGlossary) // 手术医生3
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.11.430",.ArrGlossary) // 手术医生工号3
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.11.433",.ArrGlossary) // 一助3
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.11.435",.ArrGlossary) // 二助3
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.11.619",.ArrGlossary) // 切口等级3
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.11.436",.ArrGlossary) // 切口等级代码3
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.11.620",.ArrGlossary) // 愈合情况3
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.11.437",.ArrGlossary) // 愈合情况代码3
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.11.854",.ArrGlossary) // 麻醉方式3
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.11.438",.ArrGlossary) // 麻醉方式代码3
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.11.439",.ArrGlossary) // 麻醉医师3
		Set ASAScore     = "" // ASA评分3
		Set NNISGrade    = "" // NNIS分级3
		Set Data = $lb(OperID_"||"_3,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术四
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.11.444",.ArrGlossary)        // 手术及操作名称4
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.11.440",.ArrGlossary) // 手术编码4
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.11.869",.ArrGlossary) // 手术类型4
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.11.441",.ArrGlossary) // 手术开始日期时间4
		Set OperDate     = $p(OperDateTime," ",1)
		Set OperDateL =+$l(OperDate)
		If ((OperDateL<10)||(OperDateL>10)){
			Set OperDate =""
			}
		else{
			Set OperDate = $zdh(OperDate,3)
			}
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.11.442",.ArrGlossary) // 手术结束日期时间4
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.11.977",.ArrGlossary) // 手术持续时间4
		Set OperLocDesc  =..GetEPRData(aEpisodeID,"HDSD00.11.789",.ArrGlossary) // 手术科室4
		Set OperLocCode  =..GetEPRData(aEpisodeID,"HDSD00.11.790",.ArrGlossary) // 手术科室代码4
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.11.446",.ArrGlossary) // 手术医生4
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.11.445",.ArrGlossary) // 手术医生工号4
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.11.448",.ArrGlossary) // 一助4
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.11.450",.ArrGlossary) // 二助4
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.11.621",.ArrGlossary) // 切口等级4
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.11.451",.ArrGlossary) // 切口等级代码4
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.11.622",.ArrGlossary) // 愈合情况4
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.11.452",.ArrGlossary) // 愈合情况代码4
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.11.855",.ArrGlossary) // 麻醉方式4
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.11.453",.ArrGlossary) // 麻醉方式代码4
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.11.454",.ArrGlossary) // 麻醉医师4
		Set ASAScore     = "" // ASA评分4
		Set NNISGrade    = "" // NNIS分级4
		Set Data = $lb(OperID_"||"_4,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术五
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.11.459",.ArrGlossary)        // 手术及操作名称5
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.11.455",.ArrGlossary) // 手术编码5
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.11.869",.ArrGlossary) // 手术类型5
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.11.456",.ArrGlossary) // 手术开始日期时间5
		Set OperDate     = $p(OperDateTime," ",1)
		Set OperDateL =+$l(OperDate)
		If ((OperDateL<10)||(OperDateL>10)){
			Set OperDate =""
			}
		else{
			Set OperDate = $zdh(OperDate,3)
			}
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.11.457",.ArrGlossary) // 手术结束日期时间5
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.11.978",.ArrGlossary) // 手术持续时间5
		Set OperLocDesc  =..GetEPRData(aEpisodeID,"HDSD00.11.791",.ArrGlossary) // 手术科室5
		Set OperLocCode  =..GetEPRData(aEpisodeID,"HDSD00.11.792",.ArrGlossary) // 手术科室代码5
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.11.461",.ArrGlossary) // 手术医生5
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.11.460",.ArrGlossary) // 手术医生工号5
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.11.463",.ArrGlossary) // 一助5
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.11.465",.ArrGlossary) // 二助5
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.11.623",.ArrGlossary) // 切口等级5
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.11.466",.ArrGlossary) // 切口等级代码5
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.11.624",.ArrGlossary) // 愈合情况5
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.11.467",.ArrGlossary) // 愈合情况代码5
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.11.856",.ArrGlossary) // 麻醉方式5
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.11.468",.ArrGlossary) // 麻醉方式代码4
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.11.469",.ArrGlossary) // 麻醉医师5
		Set ASAScore     = "" // ASA评分5
		Set NNISGrade    = "" // NNIS分级5
		Set Data = $lb(OperID_"||"_5,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryEMROprListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEMROprListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEMROprListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEMROprListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-08-12
/// Description:  查询中医病案首页手术信息
/// Input：       aEpisodeID : HIS就诊ID
/// Return：      ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromMrSrv","QryTCMEMROprList","1544904")
Query QryTCMEMROprList(aEpisodeID As %String) As %Query(ROWSPEC = "OperID:%String,OperDesc:%String,OperICD:%String,OperType:%String,OperDate:%String,SttTime:%String,EndDate:%String,EndTime:%String,OperHour:%String,OperLocDesc:%String,OperLocCode:%String,OpertorName:%String,OpertorCode:%String,Assistant1:%String,Assistant2:%String,Incision:%String,IncisionCode:%String,Healing:%String,HealingCode:%String,AnesMethod:%String,AnesMethodCode:%String,Anesthesia:%String,ASAScore:%String,NNISGrade:%String") [ SqlProc ]
{
}

ClassMethod QryTCMEMROprListExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK
 	
 	//取病历首页唯一索引
 	Set arr=##Class(DHCHAI.DI.DIO.FromEmrSrv).GetDataByGlossaryX(aEpisodeID,"HDSD00.11.090","","")
 	Set XCode="",OperID=""
	Set xInstanceID=""
	For	{
	    Set value=arr.GetNext(.xInstanceID)
	    Quit:xInstanceID=""
	    Continue:XCode'=""
		Set XCode = $p(xInstanceID,",",1)      // 记录索引码 xInstanceID=InstanceID_","_GlossaryCode
	}
	Set OperID=$s(XCode'="":XCode,1:aEpisodeID)
	
 	// 三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
 	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	// 手术一
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.105",.ArrGlossary)        // 手术及操作名称1
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.104",.ArrGlossary) // 手术编码1
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.605",.ArrGlossary) // 手术级别1
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.106",.ArrGlossary) // 手术开始日期时间1
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.406",.ArrGlossary) // 手术结束日期时间1
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.974",.ArrGlossary) // 手术持续时间1
		Set OperLocDesc  ="" // 手术科室1
		Set OperLocCode  ="" // 手术科室代码1
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.109",.ArrGlossary) // 手术医生1
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.407",.ArrGlossary) // 手术医生工号1
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.001",.ArrGlossary) // 一助1
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.002",.ArrGlossary) // 二助1
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.108",.ArrGlossary) // 切口等级代码1
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.615",.ArrGlossary) // 切口等级1
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.616",.ArrGlossary) // 愈合情况1
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.093",.ArrGlossary) // 愈合情况代码1
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.852",.ArrGlossary) // 麻醉方式1
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.080",.ArrGlossary) // 麻醉方式代码1
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.081",.ArrGlossary) // 麻醉医师1
		Set ASAScore     = "" // ASA评分1
		Set NNISGrade    = "" // NNIS分级1
		Set Data = $lb(OperID_"||"_1,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术二
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.414",.ArrGlossary)        // 手术及操作名称2
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.410",.ArrGlossary) // 手术编码2
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.606",.ArrGlossary) // 手术类型2
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.411",.ArrGlossary) // 手术开始日期时间2
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.412",.ArrGlossary) // 手术结束日期时间2
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.975",.ArrGlossary) // 手术持续时间2
		Set OperLocDesc  ="" // 手术科室2
		Set OperLocCode  ="" // 手术科室代码2
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.416",.ArrGlossary) // 手术医生2
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.415",.ArrGlossary) // 手术医生工号2
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.418",.ArrGlossary) // 一助2
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.420",.ArrGlossary) // 二助2
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.617",.ArrGlossary) // 切口等级2
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.421",.ArrGlossary) // 切口等级代码2
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.618",.ArrGlossary) // 愈合情况2
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.422",.ArrGlossary) // 愈合情况代码2
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.853",.ArrGlossary) // 麻醉方式2
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.423",.ArrGlossary) // 麻醉方式代码2
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.424",.ArrGlossary) // 麻醉医师2
		Set ASAScore     = "" // ASA评分2
		Set NNISGrade    = "" // NNIS分级2
		Set Data = $lb(OperID_"||"_2,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术三
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.429",.ArrGlossary)        // 手术及操作名称3
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.425",.ArrGlossary) // 手术编码3
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.428",.ArrGlossary) // 手术类型3
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.426",.ArrGlossary) // 手术开始日期时间3
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.427",.ArrGlossary) // 手术结束日期时间3
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.976",.ArrGlossary) // 手术持续时间3
		Set OperLocDesc  ="" // 手术科室3
		Set OperLocCode  ="" // 手术科室代码3
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.431",.ArrGlossary) // 手术医生3
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.430",.ArrGlossary) // 手术医生工号3
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.433",.ArrGlossary) // 一助3
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.435",.ArrGlossary) // 二助3
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.619",.ArrGlossary) // 切口等级3
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.436",.ArrGlossary) // 切口等级代码3
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.620",.ArrGlossary) // 愈合情况3
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.437",.ArrGlossary) // 愈合情况代码3
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.854",.ArrGlossary) // 麻醉方式3
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.438",.ArrGlossary) // 麻醉方式代码3
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.439",.ArrGlossary) // 麻醉医师3
		Set ASAScore     = "" // ASA评分3
		Set NNISGrade    = "" // NNIS分级3
		Set Data = $lb(OperID_"||"_3,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术四
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.444",.ArrGlossary)        // 手术及操作名称4
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.440",.ArrGlossary) // 手术编码4
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.443",.ArrGlossary) // 手术类型4
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.441",.ArrGlossary) // 手术开始日期时间4
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.442",.ArrGlossary) // 手术结束日期时间4
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.977",.ArrGlossary) // 手术持续时间4
		Set OperLocDesc  ="" // 手术科室4
		Set OperLocCode  ="" // 手术科室代码4
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.446",.ArrGlossary) // 手术医生4
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.445",.ArrGlossary) // 手术医生工号4
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.448",.ArrGlossary) // 一助4
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.450",.ArrGlossary) // 二助4
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.621",.ArrGlossary) // 切口等级4
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.451",.ArrGlossary) // 切口等级代码4
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.622",.ArrGlossary) // 愈合情况4
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.452",.ArrGlossary) // 愈合情况代码4
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.855",.ArrGlossary) // 麻醉方式4
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.453",.ArrGlossary) // 麻醉方式代码4
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.454",.ArrGlossary) // 麻醉医师4
		Set ASAScore     = "" // ASA评分4
		Set NNISGrade    = "" // NNIS分级4
		Set Data = $lb(OperID_"||"_4,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术五
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.459",.ArrGlossary)        // 手术及操作名称5
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.455",.ArrGlossary) // 手术编码5
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.458",.ArrGlossary) // 手术类型5
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.456",.ArrGlossary) // 手术开始日期时间5
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.457",.ArrGlossary) // 手术结束日期时间5
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.978",.ArrGlossary) // 手术持续时间5
		Set OperLocDesc  ="" // 手术科室5
		Set OperLocCode  ="" // 手术科室代码5
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.461",.ArrGlossary) // 手术医生5
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.460",.ArrGlossary) // 手术医生工号5
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.463",.ArrGlossary) // 一助5
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.465",.ArrGlossary) // 二助5
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.623",.ArrGlossary) // 切口等级5
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.466",.ArrGlossary) // 切口等级代码5
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.624",.ArrGlossary) // 愈合情况5
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.467",.ArrGlossary) // 愈合情况代码5
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.856",.ArrGlossary) // 麻醉方式5
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.468",.ArrGlossary) // 麻醉方式代码5
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.469",.ArrGlossary) // 麻醉医师5
		Set ASAScore     = "" // ASA评分5
		Set NNISGrade    = "" // NNIS分级5
		Set Data = $lb(OperID_"||"_5,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	// 手术六
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.474",.ArrGlossary)        // 手术及操作名称6
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.470",.ArrGlossary) // 手术编码6
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.473",.ArrGlossary) // 手术类型6
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.471",.ArrGlossary) // 手术开始日期时间6
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.472",.ArrGlossary) // 手术结束日期时间6
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.979",.ArrGlossary) // 手术持续时间6
		Set OperLocDesc  ="" // 手术科室6
		Set OperLocCode  ="" // 手术科室代码6
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.476",.ArrGlossary) // 手术医生6
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.475",.ArrGlossary) // 手术医生工号6
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.478",.ArrGlossary) // 一助6
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.480",.ArrGlossary) // 二助6
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.625",.ArrGlossary) // 切口等级6
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.481",.ArrGlossary) // 切口等级代码6
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.626",.ArrGlossary) // 愈合情况6
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.482",.ArrGlossary) // 愈合情况代码6
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.857",.ArrGlossary) // 麻醉方式6
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.483",.ArrGlossary) // 麻醉方式代码6
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.484",.ArrGlossary) // 麻醉医师6
		Set ASAScore     = "" // ASA评分6
		Set NNISGrade    = "" // NNIS分级6
		Set Data = $lb(OperID_"||"_6,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
    // 手术七
 	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.489",.ArrGlossary)        // 手术及操作名称7
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.485",.ArrGlossary) // 手术编码7
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.488",.ArrGlossary) // 手术类型7
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.486",.ArrGlossary) // 手术开始日期时间7
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.487",.ArrGlossary) // 手术结束日期时间7
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.980",.ArrGlossary) // 手术持续时间7
		Set OperLocDesc  ="" // 手术科室7
		Set OperLocCode  ="" // 手术科室代码7
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.491",.ArrGlossary) // 手术医生7
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.490",.ArrGlossary) // 手术医生工号7
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.493",.ArrGlossary) // 一助7
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.495",.ArrGlossary) // 二助7
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.627",.ArrGlossary) // 切口等级7
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.496",.ArrGlossary) // 切口等级代码7
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.628",.ArrGlossary) // 愈合情况7
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.497",.ArrGlossary) // 愈合情况代码7
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.858",.ArrGlossary) // 麻醉方式7
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.498",.ArrGlossary) // 麻醉方式代码7
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.499",.ArrGlossary) // 麻醉医师7
		Set ASAScore     = "" // ASA评分7
		Set NNISGrade    = "" // NNIS分级7
		Set Data = $lb(OperID_"||"_7,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}   
	// 手术八
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.504",.ArrGlossary)        // 手术及操作名称8
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.500",.ArrGlossary) // 手术编码8
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.503",.ArrGlossary) // 手术类型8
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.501",.ArrGlossary) // 手术开始日期时间8
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.502",.ArrGlossary) // 手术结束日期时间8
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.981",.ArrGlossary) // 手术持续时间8
		Set OperLocDesc  ="" // 手术科室8
		Set OperLocCode  ="" // 手术科室代码8
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.506",.ArrGlossary) // 手术医生8
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.505",.ArrGlossary) // 手术医生工号8
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.508",.ArrGlossary) // 一助8
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.510",.ArrGlossary) // 二助8
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.629",.ArrGlossary) // 切口等级8
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.511",.ArrGlossary) // 切口等级代码8
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.630",.ArrGlossary) // 愈合情况8
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.512",.ArrGlossary) // 愈合情况代码8
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.859",.ArrGlossary) // 麻醉方式8
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.513",.ArrGlossary) // 麻醉方式代码8
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.514",.ArrGlossary) // 麻醉医师8
		Set ASAScore     = "" // ASA评分8
		Set NNISGrade    = "" // NNIS分级8
		Set Data = $lb(OperID_"||"_8,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
    // 手术九
 	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.519",.ArrGlossary)        // 手术及操作名称9
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.515",.ArrGlossary) // 手术编码9
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.518",.ArrGlossary) // 手术类型9
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.516",.ArrGlossary) // 手术开始日期时间9
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.517",.ArrGlossary) // 手术结束日期时间9
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.982",.ArrGlossary) // 手术持续时间9
		Set OperLocDesc  ="" // 手术科室9
		Set OperLocCode  ="" // 手术科室代码9
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.521",.ArrGlossary) // 手术医生9
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.520",.ArrGlossary) // 手术医生工号9
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.523",.ArrGlossary) // 一助9
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.525",.ArrGlossary) // 二助9
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.631",.ArrGlossary) // 切口等级9
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.526",.ArrGlossary) // 切口等级代码9
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.631",.ArrGlossary) // 愈合情况9
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.527",.ArrGlossary) // 愈合情况代码9
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.860",.ArrGlossary) // 麻醉方式9
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.528",.ArrGlossary) // 麻醉方式代码9
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.529",.ArrGlossary) // 麻醉医师9
		Set ASAScore     = "" // ASA评分9
		Set NNISGrade    = "" // NNIS分级9
		Set Data = $lb(OperID_"||"_9,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	//手术十
	Set OperDesc = ..GetEPRData(aEpisodeID,"HDSD00.12.534",.ArrGlossary)        // 手术及操作名称10
	If ((OperDesc'="")&&(OperDesc'="-")) {
		Set OperICD      =..GetEPRData(aEpisodeID,"HDSD00.12.530",.ArrGlossary) // 手术编码10
		Set OperType     =..GetEPRData(aEpisodeID,"HDSD00.12.533",.ArrGlossary) // 手术类型10
		Set OperDateTime =..GetEPRData(aEpisodeID,"HDSD00.12.531",.ArrGlossary) // 手术开始日期时间10
		Set OperDate     = $p(OperDateTime," ",1)
		Set:(OperDate["-")&&(OperDate'="-") OperDate = $zdh(OperDate,3)
		Set SttTime      = $p(OperDateTime," ",2)
		Set:SttTime[":" SttTime = $zth(SttTime,1)
		Set EndDateTime  =..GetEPRData(aEpisodeID,"HDSD00.12.532",.ArrGlossary) // 手术结束日期时间10
		Set EndDate      = $p(EndDateTime," ",1)
		Set:(EndDate["-")&&(EndDate'="-") EndDate = $zdh(EndDate,3)
		Set EndTime      = $p(EndDateTime," ",2)
		Set:EndTime[":" EndTime = $zth(EndTime,1)
		Set OperHour     =..GetEPRData(aEpisodeID,"HDSD00.12.983",.ArrGlossary) // 手术持续时间10
		Set OperLocDesc  ="" // 手术科室10
		Set OperLocCode  ="" // 手术科室代码10
		Set OpertorName  =..GetEPRData(aEpisodeID,"HDSD00.12.536",.ArrGlossary) // 手术医生10
		Set OpertorCode  =..GetEPRData(aEpisodeID,"HDSD00.12.535",.ArrGlossary) // 手术医生工号10
		Set Assistant1   =..GetEPRData(aEpisodeID,"HDSD00.12.538",.ArrGlossary) // 一助10
		Set Assistant2   =..GetEPRData(aEpisodeID,"HDSD00.12.540",.ArrGlossary) // 二助10
		Set Incision     =..GetEPRData(aEpisodeID,"HDSD00.12.633",.ArrGlossary) // 切口等级10
		Set IncisionCode =..GetEPRData(aEpisodeID,"HDSD00.12.541",.ArrGlossary) // 切口等级代码10
		Set Healing      =..GetEPRData(aEpisodeID,"HDSD00.12.634",.ArrGlossary) // 愈合情况10
		Set HealingCode  =..GetEPRData(aEpisodeID,"HDSD00.12.542",.ArrGlossary) // 愈合情况代码10
		Set AnesMethod   =..GetEPRData(aEpisodeID,"HDSD00.12.861",.ArrGlossary) // 麻醉方式10
		Set AnesMethodCode =..GetEPRData(aEpisodeID,"HDSD00.12.543",.ArrGlossary) // 麻醉方式代码10
		Set Anesthesia   =..GetEPRData(aEpisodeID,"HDSD00.12.544",.ArrGlossary) // 麻醉医师10
		Set ASAScore     = "" // ASA评分10
		Set NNISGrade    = "" // NNIS分级10
		Set Data = $lb(OperID_"||"_10,OperDesc,OperICD,OperType,OperDate,SttTime,EndDate,EndTime,OperHour,OperLocDesc,OperLocCode,OpertorName)
		Set Data=Data_$lb(OpertorCode,Assistant1,Assistant2,Incision,IncisionCode,Healing,HealingCode,AnesMethod,AnesMethodCode,Anesthesia,ASAScore,NNISGrade)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryTCMEMROprListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTCMEMROprListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTCMEMROprListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTCMEMROprListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过数语集取电子病历数据
/// w ##class(DHCHAI.DI.DIO.FromMrSrv).GetEPRData(892,"HDSD00.11.056",.ArrGlossary)
ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,ArrGlossary)
	Set return=""
	Quit:(aEpisodeID="")||(aElCode="") return
	
	Set $ZT="GetEPRDataErr"
	
	Set Count=0    // 二版、三版电子病历标志  默认三版电子病历
	If Count>0 {
		//二版电子病历，GetEPRData方法即可通过模板单元调用，也可通过术语集调用
		Set return=##class(EPRservice.BOScatterData).GetEPRData(aEpisodeID,aElCode)
		
		//二版电子病历，GetDataByGlossary方法为术语集调用接口
		//Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(aEpisodeID,aElCode)
	} Else {
		//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
		Set Category=$e(aElCode,1,9)
		Quit:Category="" return
		If ArrGlossary.GetAt(Category)'=aEpisodeID {
			Set ArrGlossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,Category)
			Do ArrGlossary.SetAt(aEpisodeID,Category)
		}
		Set return=ArrGlossary.GetAt(aElCode)
		
	}
	Quit return
	
GetEPRDataErr
	Quit ""
}

}
