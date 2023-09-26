/// 名称: DHCHAI.IRS.ASPProgramSrv
/// 描述: 抗生素评估相关服务
/// 编写者：mayanpeng
Class DHCHAI.IRS.ASPProgramSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2017-11-30
/// Description:  抗生素评估病人列表(通过就诊)
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.DP.OEOrdItem、DHCHAI.IR.ASPProgram
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               alocIDs 	: DHCHAI.BT.Location.ID列表,多个科室|分割
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ASPProgramSrv","QryAspPatList","","2017-07-01","2018-01-30","112|113|114|116|119")
Query QryAspPatList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, alocIDs As %String = "") As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,PatName:%String,MrNo:%String,Sex:%String,Age:%String,LocID:%String,AdmLoc:%String,WardID:%String,AdmWard:%String,AdmDate:%String,DischDate:%String,Generic:%String,SumPharOpt:%String,SumPharNotOpt:%String,SumExperOpt:%String,SumExperNotOpt:%String,SumOEOrd:%String") [ SqlProc ]
{
}

ClassMethod QryAspPatListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, alocIDs As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:alocIDs="" $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:(aDateTo-aDateFrom)<0 $$$OK
 	
 	Set alocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(alocIDs,"|")
 	
	Set ZIndex=$zn,JIndex=$j,NIndex="ASP"
	For i=1:1:$ListLength(alocIDs){
		Set xLocID=$List(alocIDs,i)
		Continue:xLocID=""
		
		Kill ^TMP(ZIndex,JIndex,NIndex)
		Set (SumPharOpt,SumExperOpt,SumPharNotOpt,SumExperNotOpt,SumOEOrd)=0
		//当前时间内就诊
		Set arrPAAdm = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc(aDateFrom,aDateTo,"W",xLocID,"I")
		For indAdm=1:1:arrPAAdm.Count() {
			Set xEpisodeID=$List(arrPAAdm.GetAt(indAdm),1)
			Continue:xEpisodeID=""
			
			Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
			Continue:'$IsObject(objAdm)
			Set PatName = objAdm.PAPatName
			Set MrNo = objAdm.PAMrNo
			Set Sex = objAdm.PASex
			Set Age = objAdm.PAAge
			Set LocID = xLocID
			Set AdmLoc = objAdm.PAAdmLocDr.BTDesc
			Set AdmLoc2 = objAdm.PAAdmLocDr.BTDesc2
			Set:AdmLoc2'="" AdmLoc=AdmLoc2
			Set WardID = objAdm.PAAdmWardDr.%Id()
			Set AdmWard = objAdm.PAAdmWardDr.BTDesc
			Set AdmWard2 = objAdm.PAAdmWardDr.BTDesc2
			Set:AdmWard2'="" AdmWard=AdmWard2
			Set AdmDate = objAdm.PAAdmDate
			Set DischDate = objAdm.PADischDate
			Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
			Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
			
			Set Generic=""
			Set (SumPharOpt,SumExperOpt,SumPharNotOpt,SumExperNotOpt,SumOEOrd)=0
			Set xOEOrdID=0
			For {
				Set xOEOrdID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",xEpisodeID,xOEOrdID))
				Quit:xOEOrdID=""
				
				Set objOEOrd = ##class(DHCHAI.DP.OEOrdItem).GetObjById(xOEOrdID)
				Continue:'$IsObject(objOEOrd)
				Continue:objOEOrd.OEIsActive=0	// 无效医嘱
				Continue:objOEOrd.OEAntUseFlag'=1 //过滤出抗生素
				/* Set OEGeneric = objOEOrd.OEGeneric
				Set:Generic'="" Generic=Generic_","
				Set Generic = Generic_OEGeneric
				*/
				Set OEOrdDesc = objOEOrd.OEOrdDesc
				Set xBTCode = $o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",""))
				Continue:xBTCode=""
				
				Set OEAntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTCode,OEOrdDesc,0))
				Continue:OEAntiMapID="" //过滤未对照
				
				Set objMapItem = ##class(DHCHAI.DP.OEAntiMastMap).GetObjById(OEAntiMapID)
				Continue:'$IsObject(objMapItem)
				Set objAnti = objMapItem.BTMapItemDr
				Continue:'$IsObject(objAnti)
				Set AntiDesc=objAnti.BTName
				Continue:AntiDesc=""
				Set:Generic'="" Generic=Generic_","
				Set Generic = Generic_AntiDesc
				//过滤出维护的抗生素
				Continue:##class("DHCHAI.IRS.CRuleAntiSrv").IsExistAntiMast(AntiDesc)=0
				
				Set ASPOrdID=$o(^DHCHAI.IR.ASPOrdItemI("IndexOrdItemDr",xOEOrdID,""))
				If (ASPOrdID'=""){
					Set objASPOrd = ##class(DHCHAI.IR.ASPOrdItem).GetObjById(ASPOrdID)
					Set objASPPro = objASPOrd.IRProgramDr
					Set CheckType = objASPPro.IRCheckType
					If (CheckType=1){ //药师处置,专家未处置
						Set SumPharOpt = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"Phar","已处置"))
						Set SumExperNotOpt = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"Exper","未处置"))
					}Elseif (CheckType=2){ //药师专家均处置
						Set SumPharOpt = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"Phar","已处置"))
						Set SumExperOpt = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"Exper","已处置"))
					}
				}Else{
					Set SumPharNotOpt = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"Phar","未处置"))
					Set SumExperNotOpt = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"Exper","未处置"))
				}
				//总医嘱数
				Set SumOEOrd = $i(^TMP(ZIndex,JIndex,NIndex,xEpisodeID,"总医嘱数"))
			}
			Continue:Generic=""
			Continue:SumOEOrd=0
			Set Generic = ##class(DHCHAI.Utils.CommonSrv).RemoveRepet(Generic,",") //去掉重复
			Set Data=$lb(ind,xEpisodeID,PatName,MrNo,Sex,Age,LocID,AdmLoc,WardID,AdmWard,AdmDate,DischDate,Generic,SumPharOpt,SumPharNotOpt,SumExperOpt,SumExperNotOpt,SumOEOrd)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryAspPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAspPatListExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAspPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAspPatListExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-04-16
/// Description:  抗生素评估病人列表(通过医嘱)
/// Table：       DHCHAI.DP.OEOrdItem、DHCHAI.IR.ASPProgram
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               alocIDs 	: DHCHAI.BT.Location.ID列表,多个科室|分割
///               aPowerType: 0药师、1专家
///               aStatus 	: -1待处置、0不合理、1合理、2需关注，多个状态|分割
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.ASPProgramSrv","QryAspAntList","1|2","2018-11-01","2018-11-14","590|591|593|594|596|597|600|601|602|603|604|606|607|608|1003","1","0|1")
Query QryAspAntList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, alocIDs As %String = "", aPowerType As %String, aStatus As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,PatName:%String,MrNo:%String,Sex:%String,Age:%String,LocID:%String,AdmLoc:%String,WardID:%String,AdmWard:%String,AdmDate:%String,DischDate:%String,AntiID:%String,Generic:%String,OEOrdIDs:%String,PharOpinion:%String,ExperOpinion:%String") [ SqlProc ]
{
}

ClassMethod QryAspAntListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, alocIDs As %String = "", aPowerType As %String, aStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:alocIDs="" $$$OK
 	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:aDateTo<aDateFrom $$$OK
 	
 	Set Status=""
 	If (aStatus'=""){
	 	For inde=1:1:$length(aStatus,"|"){
		 	Set xStatus=$p(aStatus,"|",inde)
		 	Set xStatus=$s(xStatus="-1":"未处置",xStatus="0":"不合理",xStatus="1":"合理",xStatus="2":"需关注")
		 	Set Status=Status_$lb(xStatus)
		 }
	 }
 	
 	Set alocIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(alocIDs,"|")
	Set ZIndex=$zn,JIndex=$j,NIndex="ASPAnt"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//配置的医嘱筛查类型
 	Set ASPOEOrdPriority=##class(DHCHAI.BT.Config).GetValByCode("ASPOEOrdPriority")
	
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexAntUseSttDate",xSCode))
		Quit:xSCode=""
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexAntUseSttDate",xSCode,"1",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xOEOrdID=0
			For {
				Set xOEOrdID=$o(^DHCHAI.DP.OEOrdItemI("IndexAntUseSttDate",xSCode,"1",xDate,xOEOrdID))
				Quit:xOEOrdID=""
				
				Set objOEOrd=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOEOrdID)
				Continue:'$IsObject(objOEOrd)
				Continue:objOEOrd.OEIsActive=0	// 无效医嘱
				Set OEOrdLocDr=objOEOrd.OEOrdLocDr
				Set OEOrdLocID=""
				If $IsObject(OEOrdLocDr){
					Set OEOrdLocID = OEOrdLocDr.%Id()
					Continue:$ListFind(alocIDs,OEOrdLocID)<1 //开医嘱科室
				}
				
				Set Priority=objOEOrd.OEPriority //医嘱类型(长期/临时)
				If (ASPOEOrdPriority'="") {
					Continue:(ASPOEOrdPriority="1")&&(Priority'="长期医嘱")
					Continue:(ASPOEOrdPriority="2")&&(Priority'="临时医嘱")
				}
				Set OEOrdDesc = objOEOrd.OEOrdDesc
				Set objMapItem=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(xSCode,OEOrdDesc)
				Continue:'$IsObject(objMapItem) //过滤未对照
				
				Set objAnti = objMapItem.BTMapItemDr
				Continue:'$IsObject(objAnti)
				Set AntiID=objAnti.%Id()
				Set AntiDesc=objAnti.BTName
				Continue:AntiDesc=""
				//过滤出维护的抗生素
				Continue:##class("DHCHAI.IRS.CRuleAntiSrv").IsExistAntiMast(AntiDesc)=0
				
				Set objAdm=objOEOrd.OEEpisodeDr
				Continue:'$IsObject(objAdm)
				Set EpisodeID=objOEOrd.OEEpisodeDr.%Id()
				
				Set ^TMP(ZIndex,JIndex,NIndex,"Anti",EpisodeID,AntiID)=AntiDesc
				Set ^TMP(ZIndex,JIndex,NIndex,"OEOrd",EpisodeID,AntiID)=$g(^TMP(ZIndex,JIndex,NIndex,"OEOrd",EpisodeID,AntiID))_"|"_xOEOrdID
				//Set ^TMP(ZIndex,JIndex,NIndex,"Anti",EpisodeID)=$g(^TMP(ZIndex,JIndex,NIndex,"Anti",EpisodeID))_","_AntiID
				//Set ^TMP(ZIndex,JIndex,NIndex,"AntiDesc",EpisodeID)=$g(^TMP(ZIndex,JIndex,NIndex,"AntiDesc",EpisodeID))_","_AntiDesc
				//Set ^TMP(ZIndex,JIndex,NIndex,"OEOrd",EpisodeID)=$g(^TMP(ZIndex,JIndex,NIndex,"OEOrd",EpisodeID))_"|"_xOEOrdID
				
			}
		}
	}
	Set xEpisodeID=0
	For {
		Set xEpisodeID=$o(^TMP(ZIndex,JIndex,NIndex,"Anti",xEpisodeID))
		Quit:xEpisodeID=""
		
		Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Set PatName = objAdm.PAPatName
		Set MrNo = objAdm.PAMrNo
		Set Sex = objAdm.PASex
		Set Age = objAdm.PAAge
		Set LocID = objAdm.PAAdmLocDr.%Id()
		Set AdmLoc = objAdm.PAAdmLocDr.BTDesc
		Set AdmLoc2 = objAdm.PAAdmLocDr.BTDesc2
		Set:AdmLoc2'="" AdmLoc=AdmLoc2
		Set WardID = objAdm.PAAdmWardDr.%Id()
		Set AdmWard = objAdm.PAAdmWardDr.BTDesc
		Set AdmWard2 = objAdm.PAAdmWardDr.BTDesc2
		Set:AdmWard2'="" AdmWard=AdmWard2
		Set AdmDate = objAdm.PAAdmDate
		Set DischDate = objAdm.PADischDate
		Set:AdmDate'="" AdmDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
		Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
		
		Set xAntiID=""
		For {
			Set xAntiID=$o(^TMP(ZIndex,JIndex,NIndex,"Anti",xEpisodeID,xAntiID))
			Quit:xAntiID=""
			
			Set Generic=$g(^TMP(ZIndex,JIndex,NIndex,"Anti",xEpisodeID,xAntiID))
			
			Set OEOrdIDs=$g(^TMP(ZIndex,JIndex,NIndex,"OEOrd",xEpisodeID,xAntiID))
			Set OEOrdIDs=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(OEOrdIDs,"|")
			
			Set PharOpinion="",ExperOpinion=""
			For index=1:1:$Length(OEOrdIDs,"|"){
				Set xOEOrdID2=$P(OEOrdIDs,"|",index)
				Continue:xOEOrdID2=""
				Set Opinion=..GetOpStatus(xOEOrdID2)
				Set PharOpinion=PharOpinion_","_$p(Opinion,"^",1)
				Set ExperOpinion=ExperOpinion_","_$p(Opinion,"^",2)
			}
			Set:PharOpinion'="" PharOpinion=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(PharOpinion,",")
			Set:ExperOpinion'="" ExperOpinion=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(ExperOpinion,",")
			
			//过滤权限及状态
			If (Status'=""){
				Set flag=0
				For inde=1:1:$ListLength(Status){
					Set xStatus=$List(Status,inde)
					//药师
					Set:(aPowerType=0)&&((","_PharOpinion_",")[(","_xStatus_",")) flag=1
					//专家
					If (aPowerType="1") {
						//专家只查看药师不合理部分
						If (xStatus="未处置") {
							Set:((","_PharOpinion_",")[",不合理,")&&((","_ExperOpinion_",")[(",未处置,")) flag=1
						} Else {
							Set:(","_ExperOpinion_",")[(","_xStatus_",") flag=1
						}
					}
					If (aPowerType=""){
						Set:((","_PharOpinion_",")[(","_xStatus_","))||((","_ExperOpinion_",")[(","_xStatus_",")) flag=1
					}
					Quit:flag=1
				}
				Continue:flag=0
			}
			
			Set Data=$lb(ind,xEpisodeID,PatName,MrNo,Sex,Age,LocID,AdmLoc,WardID,AdmWard,AdmDate,DischDate,xAntiID,Generic,OEOrdIDs,PharOpinion,ExperOpinion)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		/*
		Set Generic=$g(^TMP(ZIndex,JIndex,NIndex,"AntiDesc",xEpisodeID))
		Set Generic=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(Generic,",")
		
		Set OEOrdIDs=$g(^TMP(ZIndex,JIndex,NIndex,"OEOrd",xEpisodeID))
		Set OEOrdIDs=##class(DHCHAI.Utils.CommonSrv).RemoveRepet(OEOrdIDs,"|")
		
		Set Data=$lb(ind,xEpisodeID,PatName,MrNo,Sex,Age,LocID,AdmLoc,WardID,AdmWard,AdmDate,DischDate,xAntiID,Generic,OEOrdIDs,PharOpinion,ExperOpinion)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		*/
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit $$$OK
}

ClassMethod QryAspAntListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAspAntListExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAspAntListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAspAntListExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-11-13
/// Description:  获取处置状态
/// Table：       DHCHAI.IR.ASPProgram
/// Input：       医嘱ID
/// Return：      药师处置结果^专家处置结果
/// w ##class("DHCHAI.IRS.ASPProgramSrv").GetOpStatus("6230669")
ClassMethod GetOpStatus(aOEOrdID As %String) As %String
{
	New (aOEOrdID)
	Set return=""
	Quit:(aOEOrdID="") return
	
	Set PharOpioion="未处置",ExperOpinion="未处置"
	Set xASPOrdItem=""
	For {
		Set xASPOrdItem=$o(^DHCHAI.IR.ASPOrdItemI("IndexOrdItemDr",aOEOrdID,xASPOrdItem))
		Quit:xASPOrdItem=""
		
		Set objASPOrdItem=##class(DHCHAI.IR.ASPOrdItem).GetObjById(xASPOrdItem)
		Continue:'$IsObject(objASPOrdItem)
		
		Set ProgramDr=objASPOrdItem.IRProgramDr
		Set CheckType=ProgramDr.IRCheckType //1药师Phar、2专家Exper
		Set CheckResult=ProgramDr.IRCheckResult //审核结果（0不合理、1合理、2需关注）
		Set CheckResult=$s(CheckResult="0":"不合理",CheckResult="1":"合理",CheckResult="2":"需关注",0:CheckResult)
		Set:CheckType="1" PharOpioion=CheckResult
		Set:CheckType="2" ExperOpinion=CheckResult
	}
	Quit PharOpioion_"^"_ExperOpinion
}

/// Creator：     mayanpeng
/// CreatDate：   2018-11-14
/// Description:  是否停用后n天内重复开药
/// Table：       DHCHAI.IR.ASPProgram
/// Input：       医嘱ID
/// Return：      返回1成功或小于0失败
/// w ##class("DHCHAI.IRS.ASPProgramSrv").RepetAnti("6230669")
ClassMethod RepetAnti(aOEOrdID As %String) As %String
{
	New (aOEOrdID)
	Set return=0
	Quit:(aOEOrdID="") return
	
	Set objOEOrd=##class(DHCHAI.DP.OEOrdItem).GetObjById(aOEOrdID)
	Quit:'$IsObject(objOEOrd) return
	Set SttDate=objOEOrd.OESttDate
	Set OEOrdDesc = objOEOrd.OEOrdDesc
	
	//配置的停药后免筛查天数
 	Set ASPRepetAntiDateNum=##class(DHCHAI.BT.Config).GetValByCode("ASPRepetAntiDateNum")
 	Set ASPRepetAntiDateNum=+$g(ASPRepetAntiDateNum)
 	
	Set EpisodeDr=objOEOrd.OEEpisodeDr
	Quit:'$IsObject(EpisodeDr) return
	Set EpisodeID=EpisodeDr.%Id()
	
	Set IsRepet=0,MaxXDate=0
	Set xsCode=""
	For {
		Set xsCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",EpisodeID,xsCode))
		Quit:xsCode=""
		
		Set objMapItem=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(xsCode,OEOrdDesc)
		Continue:'$IsObject(objMapItem) //过滤未对照
		
		Set objAnti = objMapItem.BTMapItemDr
		Continue:'$IsObject(objAnti)
		Set AntiID=objAnti.%Id()
		
		Set xDate=""
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",EpisodeID,xsCode,xDate))
			Quit:xDate=""
			
			Set xOrdID=""
			For {
				Set xOrdID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",EpisodeID,xsCode,xDate,xOrdID))
				Quit:xOrdID=""
				
				Set objOEOrd2=##class(DHCHAI.DP.OEOrdItem).GetObjById(xOrdID)
				Continue:'$IsObject(objOEOrd2)
				Continue:objOEOrd2.OEIsActive'=1
				Continue:objOEOrd2.OEAntUseFlag'=1
				
				Set OEOrdDesc2=objOEOrd2.OEOrdDesc
				Set objMapItem2=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(xsCode,OEOrdDesc2)
				Continue:'$IsObject(objMapItem2) //过滤未对照
				
				Set objAnti2 = objMapItem2.BTMapItemDr
				Continue:'$IsObject(objAnti2)
				Set AntiID2=objAnti2.%Id()
				Continue:AntiID'=AntiID2 //过滤不同抗生素
				
				Set SttDate2=objOEOrd2.OESttDate
				Set XDate2=objOEOrd2.OEXDate
				
				Continue:(XDate2="")&&(SttDate2<SttDate)
				Continue:(XDate2'="")&&(SttDate<XDate2)
				Set:(XDate2'="")&&(MaxXDate<XDate2) MaxXDate=XDate2
			}
			
		}
	}
	Quit:MaxXDate=0 return
	If (SttDate-MaxXDate)>ASPRepetAntiDateNum {
		Set IsRepet=1
	}
	Quit IsRepet
}

}
