Class DHCMA.IMP.BTS.IMPCateRulesSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-05-21
/// Description:  根据重点患者分类查询重点患者判断规则信息
/// Table：       DHCMA.IMP.BT.IMPCateRules      
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPCateRulesSrv","QryIMPCateRules",1)
Query QryIMPCateRules(aParRef As %String, aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,aParRef:%String,RuleCode:%String,RuleDesc:%String,RuleExpress:%String,RuleTypeDesc:%String,BTIsActive:%String,RuleType:%String,RuleTypeDr:%String,ActDate:%String,ActTime:%String,ActUserID:%String")
{
}

ClassMethod QryIMPCateRulesExecute(ByRef qHandle As %Binary, aParRef As %String, aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK	
 	Set xChildID=""		
 	For
 	{	
 		Set xChildID = $o(^CT.MA.IMP.BTIMPCategoryD(aParRef,"Rules",xChildID))
 		Quit:xChildID=""
 		
 		Set (RuleCode,RuleDesc,RuleExpress,RuleType,BTIsActive,RuleTypeDesc,RuleTypeDr)=""
 		Set ObjRules		= ##class(DHCMA.IMP.BT.IMPCateRules).GetObjById(aParRef_"||"_xChildID)
 		Continue:'$IsObject(ObjRules)
 		
 		Set RuleCode        = ObjRules.BTCode
 		Set RuleDesc        = ObjRules.BTDesc
 		Set RuleExpress     = ObjRules.BTExpress
 		Set RuleType        = ObjRules.BTTypeDr
 		Set RuleTypeDr      = ObjRules.BTTypeDr.%Id()
 		Set RuleTypeDesc    = RuleType.BTDesc
 		Set BTIsActive      = ObjRules.BTIsActive
 		Set BTIsActive=$s(BTIsActive=1:"是",1:"否")
 		Set ActDate     	= ObjRules.BTActDate
 		Set ActTime     	= ObjRules.BTActTime
 		Set ActUserID     	= ObjRules.BTActUserID
 		
 		Continue:(aKey'="")&&(RuleCode'[aKey)&&(RuleDesc'[aKey)
 		
		Set Data=$lb(aParRef_"||"_xChildID,aParRef,RuleCode,RuleDesc,RuleExpress,RuleTypeDesc,BTIsActive,RuleType,RuleTypeDr,ActDate,ActTime,ActUserID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryIMPCateRulesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPCateRulesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPCateRulesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPCateRulesExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-06-08
/// Description:  导入重点患者判断规则
/// return： 	  成功：-1，失败：返回空
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).ImportIMPCateRules()
ClassMethod ImportIMPCateRules(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefDesc		 = $p(aInputStr,aSeparete,1)
	Set ChildSub		 = $p(aInputStr,aSeparete,2)
	Set Code     		 = $p(aInputStr,aSeparete,3)
	Set Desc         	 = $p(aInputStr,aSeparete,4)
	Set Express   		 = $p(aInputStr,aSeparete,5)	
	Set Type        	 = $p(aInputStr,aSeparete,6)
	Set IsActive         = +$p(aInputStr,aSeparete,7)
	Set BTActDate		 = +$h
	Set BTActTime		 = +$p($h,",",2)
	Set BTActUserID		 = ""
	
	Set Parref=##class(DHCMA.IMP.BT.IMPCategory).GetObjByDesc(ParrefDesc)
	Set:$IsObject(Parref) Parref=Parref.%Id()
	Quit:Parref="" return
	
	Set TypeObj=##class(DHCMA.Util.BT.Dictionary).GetObjByPCodeItemDesc("IMPRuleType",Type)	
	Set:$IsObject(TypeObj) TypeObj=TypeObj.%Id()
	
	Set inputStr=Parref_"^"_ChildSub_"^"_Code_"^"_Desc_"^"_Express_"^"_TypeObj_"^"_IsActive_"^"_BTActDate_"^"_BTActTime_"^"_BTActUserID
	Set return=##class(DHCMA.IMP.BT.IMPCateRules).Update(inputStr)
	Set:+return<1 return=""
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-02
/// Description:  非计划重返住院整体规则:
/// 				 有多次入院记录，且本次入院时间与上次出院时间间隔在31天内（只筛查在院病人）
/// return： 	  符合返回Y，不符合返回N          
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).NotPlanReturnHospIn(717)
ClassMethod NotPlanReturnHospIn(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="N"
	Quit:aEpisodeID="" return
	Set result = 100
	
	Set AdmInfo=$g(^PAADM(aEpisodeID))
	Set PAPatmas = $p(AdmInfo,"^",1)      //PA_Patmas
	Set PAADMType= $p(AdmInfo,"^",2)	  //就诊类型过滤  o门诊 I住院
	Quit:PAADMType'="I" return
	
	/*Set RowID = $o(^PAPERdr(PAPatmas,"ADM",PAADMType,""),-1)	//最新的住院就诊id
	
	Quit:RowID="" return*/
	Set AdmInfoNew		=$g(^PAADM(aEpisodeID)) //本次入院就诊信息
	//Set PAADMTypeNew	= $p(AdmInfoNew,"^",2)
	//Quit:PAADMTypeNew'="I" return
	Set DischgDateNew	= $p(AdmInfoNew,"^",17)	//出院日期
	Quit:DischgDateNew'="" return				//已出院
	Set AdmDateNew	 	= $p(AdmInfoNew,"^",6)	//就诊日期
	
	Set SecRowID = $o(^PAPERdr(PAPatmas,"ADM",PAADMType,aEpisodeID),-1)	//本次住院就诊id的上一条	
	Quit:SecRowID="" return
	Set AdmInfoSec		=$g(^PAADM(SecRowID))
	//Set PAADMTypeSec	= $p(AdmInfoSec,"^",2)
	//Quit:PAADMTypeNew'="I" return
	Set DischgDateSec	= $p(AdmInfoSec,"^",17)	//出院日期
	
	Set result = AdmDateNew-DischgDateSec
	Set:result<31 return="Y"
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-03
/// Description:  非计划重返住院排除规则:
/// 				 第二次入院为24小时入出院患者及化疗患者(化疗患者不能判断目前)
/// return： 	  排除返回N，不排除返回Y         
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).NotPlanReturnHospOut(247)
ClassMethod NotPlanReturnHospOut(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="Y"
	Quit:aEpisodeID="" return
	Set result = 100
	Set time   = 100000
	
	Set AdmInfo=$g(^PAADM(aEpisodeID))
	Set PAPatmas = $p(AdmInfo,"^",1)      //PA_Patmas
	Set PAADMType= $p(AdmInfo,"^",2)	  //就诊类型过滤  o门诊 I住院
	Quit:PAADMType'="I" return
	
	Set RowID = $o(^PAPERdr(PAPatmas,"ADM",PAADMType,""),-1)	//最新的住院就诊id
	Quit:RowID="" return
	Set AdmInfoNew		=$g(^PAADM(RowID))
	//Set PAADMTypeNew	= $p(AdmInfoNew,"^",2)
	//Quit:PAADMTypeNew'="I" return
	Set DischgDateNew	= $p(AdmInfoNew,"^",17)	//出院日期
	Quit:DischgDateNew'="" return				//已出院
	Set AdmDateNew	 	= $p(AdmInfoNew,"^",6)	//就诊日期
	Set AdmTimeNew	 	= $p(AdmInfoNew,"^",7)	//就诊时间
	
	Set SecRowID = $o(^PAPERdr(PAPatmas,"ADM",PAADMType,RowID),-1)	//最新住院就诊id的上一条	
	Quit:SecRowID="" return
	Set AdmInfoSec		=$g(^PAADM(SecRowID))
	//Set PAADMTypeSec	= $p(AdmInfoSec,"^",2)
	//Quit:PAADMTypeNew'="I" return
	Set DischgDateSec	= $p(AdmInfoSec,"^",17)	//出院日期
	Set DischgTimeSec	= $p(AdmInfoSec,"^",18)	//出院时间
	
	Set result = AdmDateNew-DischgDateSec
	Set time = AdmTimeNew-DischgTimeSec
	if (result=0){
		Set return="N"
	}elseif ((result=1)&&(time<=86400)){
		Set return="N"
	}
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-02
/// Description:  危重病例整体规则:
/// 				  	医嘱为病危或病重
/// return： 	  符合返回Y，不符合返回N          
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).CriticalCaseIn(3)
ClassMethod CriticalCaseIn(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="N"
	Quit:aEpisodeID="" return
	
	Set OrderID=$o(^OEORD(0,"Adm",aEpisodeID,""))						//医嘱表OE_Order
	Quit:OrderID="" return
	
	Set Num=0
	Set xID = 0
	For{
		Set xID = $o(^OEORD(OrderID,"I",xID))							//医嘱明细表OE_OrdItem 
		Quit:xID=""
		Set OEORIItmMastDR = $p($G(^OEORD(OrderID,"I",xID,1)),"^",2)	//OEORIItmMastDR->医嘱项ARC_ItmMast
		Continue:OEORIItmMastDR=""
		Set OEORIItemStatDR=$p($G(^OEORD(OrderID,"I",xID,1)),"^",13)	//OEORIItemStatDR->医嘱状态OEC_OrderStatus
		Set OSTATCode=$p($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)		//医嘱状态
		Continue:OSTATCode'="V"											//过滤为非核实状态的
		
		Set Code1=$p(OEORIItmMastDR,"||",1)				
		Set Code2=$p(OEORIItmMastDR,"||",2)
		Set Desc = $p(^ARCIM(Code1,Code2,1),"^",2)						//ARCIMDesc
		
		if ((Desc="病危") || (Desc="病重")){
			Set Num=Num+1
			Quit:Num'=0 
		}
	}
	Set:Num'=0 return="Y"
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-03
/// Description:  非计划重返手术室整体规则:
/// 				  	同一次住院，有多次手术，且本次手术开始时间与上次手术结束时间间隔在31天内
/// return： 	  符合返回Y，不符合返回N          
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).NotPlanReturnSurgeryIn(392)
ClassMethod NotPlanReturnSurgeryIn(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="N"
	Quit:aEpisodeID="" return
	
	Set OperArr=0
	Set Flag=0
	Set arrData=##Class(%Library.ArrayOfDataTypes).%New()
	Set result = 100
	For{
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",aEpisodeID,OperArr))			//手术排班表 DHC_AN_OPArrange
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)				//手术状态
		Continue:OperStatus="N"
		//A：申请,D：拒绝,R：安排,I：术中,L：术毕,F：完成,N：非预约,P：恢复,C：撤销
		Continue:(OperStatus="A")||(OperStatus="D")||(OperStatus="R")||(OperStatus="C")
		Set Flag=Flag+1
		Set Data=$lb(OperArr)
		Do arrData.SetAt(Data,Flag)
	}
	
	If (Flag>1){
		Set OperArrN = arrData.GetAt(Flag)
		Set OperArrNew=$LIST(OperArrN,1)
		Set StartDateNew=$p($g(^DHCANOPArrange(OperArrNew)),"^",14)				//手术日期
		
		Set OperArrL = arrData.GetAt(Flag-1)
		Set OperArrLast=$LIST(OperArrL,1)
		Set StartDateLast=$p($g(^DHCANOPArrange(OperArrLast)),"^",14)
		
		Set result=StartDateNew-StartDateLast
		Set:result<31 return="Y"
	}
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-03
/// Description:  非计划重返手术室排除规则:
/// 				  	不同部位：根据手术名称左、右、前、后判断，比如左眼、右眼。）
/// return： 	  排除返回N，不排除返回Y           
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).NotPlanReturnSurgeryOutByBodySite(392)
ClassMethod NotPlanReturnSurgeryOutByBodySite(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="Y"
	Quit:aEpisodeID="" return
	
	Set OperArr=0
	Set Flag=0
	Set arrData=##Class(%Library.ArrayOfDataTypes).%New()
	Set result = 100
	For{
		Set OperArr=$o(^DHCANOPArrange(0,"Adm",aEpisodeID,OperArr))			//手术排班表 DHC_AN_OPArrange
		Quit:OperArr=""
		
		Set OperStatus=$p($g(^DHCANOPArrange(OperArr)),"^",27)				//手术状态
		Continue:OperStatus="N"
		//A：申请,D：拒绝,R：安排,I：术中,L：术毕,F：完成,N：非预约,P：恢复
		Continue:(OperStatus="A")||(OperStatus="D")||(OperStatus="R")
		Set Flag=Flag+1
		Set Data=$lb(OperArr)
		Do arrData.SetAt(Data,Flag)
	}
	
	If (Flag>1){
		Set OperArrN = arrData.GetAt(Flag)
		Set OperArrNew=$LIST(OperArrN,1)
		Set StartDateNew=$p($g(^DHCANOPArrange(OperArrNew)),"^",14)				//手术日期
		
		Set OperArrL = arrData.GetAt(Flag-1)
		Set OperArrLast=$LIST(OperArrL,1)
		Set StartDateLast=$p($g(^DHCANOPArrange(OperArrLast)),"^",14)
		
		Set result=StartDateNew-StartDateLast
		if (result<31){
			Set AnaestDrNew=$p($g(^DHCANOPArrange(OperArrNew)),"^",2)				//麻醉表OR_Anaesthesia
			Quit:AnaestDrNew="" return
			Set AnaestDrChildNew=$p(AnaestDrNew,"||",2)
			Set ANAOPChildNew = $o(^OR(aEpisodeID,"ANA",AnaestDrChildNew,"OP",0))	//手术表OR_Anaest_Operation
			Quit:ANAOPChildNew="" return
			Set BodySiteDRNew=$p($g(^OR(aEpisodeID,"ANA",AnaestDrChildNew,"OP",ANAOPChildNew)),"^",24)				//手术部位
			Quit:BodySiteDRNew="" return
			Set BODSDescNew=$p($g(^OEC("BODS",BodySiteDRNew)),"^",2)
			Quit:BODSDescNew="" return
			
			Set AnaestDrLast=$p($g(^DHCANOPArrange(OperArrLast)),"^",2)
			Quit:AnaestDrLast="" return
			Set AnaestDrChildLast=$p(AnaestDrLast,"||",2)
			Set ANAOPChildLast = $o(^OR(aEpisodeID,"ANA",AnaestDrChildLast,"OP",0))
			Quit:ANAOPChildLast="" return
			Set BodySiteDRLast=$p($g(^OR(aEpisodeID,"ANA",AnaestDrChildLast,"OP",ANAOPChildLast)),"^",24)
			Quit:BodySiteDRLast="" return
			Set BODSDescLast=$p($g(^OEC("BODS",BodySiteDRLast)),"^",2)
			Quit:BODSDescLast="" return
			
			if ((BODSDescNew["左")||(BODSDescNew["右")||(BODSDescNew["前")||(BODSDescNew["后")){
				if ((BODSDescLast["左")||(BODSDescLast["右")||(BODSDescLast["前")||(BODSDescLast["后")){
					if (($e(BODSDescNew,1))'=($e(BODSDescLast,1))){
						Set:($e(BODSDescNew,2,*))=($e(BODSDescLast,2,*)) return="N"
					}
				}
			}
			
		}
	}
	
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-06-05
/// Description:  非计划重返ICU整体规则:
/// 				  	同一次住院期间出ICU后，因各种原因导致患者又重返ICU或重症医学科
/// return： 	  符合返回Y，不符合返回N          
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).NotPlanReturnICUIn(137)
ClassMethod NotPlanReturnICUIn(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="N"
	Quit:aEpisodeID="" return
	
	Set OrigICUNum = 0
	Set ToICUNum = 0
	Set TransRecordId=""
	For{
		Set TransRecordId = $o(^Nur.Data.TransRecordI("TransEpisodeID"," "_aEpisodeID,TransRecordId),-1)
		Quit:TransRecordId=""
		Set OrigLocID = $lg(^Nur.Data.TransRecordD(TransRecordId),4)			//转出科室ID
		Set ToLocID   = $lg(^Nur.Data.TransRecordD(TransRecordId),5)			//转入科室ID
		Set (ToLOCDesc,OrigTLOCDesc)=""
		Set:OrigLocID'="" OrigTLOCDesc=$p($g(^CTLOC(OrigLocID)),"^",2)
		Set:ToLocID'="" ToLOCDesc=$p($g(^CTLOC(ToLocID)),"^",2)	
			
		if ((ToLOCDesc["ICU")||(ToLOCDesc["重症医学科")){
			Set ToICUNum=ToICUNum+1
		}
		if (((OrigTLOCDesc["ICU")||(OrigTLOCDesc["重症医学科"))&&ToICUNum>0){
			Set OrigICUNum=OrigICUNum+1
		}
	}
	if (OrigICUNum>=1&ToICUNum>=1){
		Set return="Y"
	}
	
	/*Set TransRecordIdNew = $o(^Nur.Data.TransRecordI("TransEpisodeID"," "_aEpisodeID,""),-1)	//转科表Nur_Data.transRecord
	//Set TransRecordIdLast = $o(^Nur.Data.TransRecordI("TransEpisodeID"," "_aEpisodeID,TransRecordIdNew),-1)
	Quit:TransRecordIdNew="" return
	
	Set OrigLocID = $lg(^Nur.Data.TransRecordD(TransRecordIdNew),4)			//转出科室ID
	Set ToLocID   = $lg(^Nur.Data.TransRecordD(TransRecordIdNew),5)			//转入科室ID
	Set (ToLOCDesc,OrigTLOCDesc)=""
	Set:OrigLocID'="" OrigTLOCDesc=$p($g(^CTLOC(OrigLocID)),"^",2)
	Set:ToLocID'="" ToLOCDesc=$p($g(^CTLOC(ToLocID)),"^",2)				
	
	if ((OrigTLOCDesc["ICU")||(OrigTLOCDesc["重症医学科")){
		if ((ToLOCDesc["ICU")||(ToLOCDesc["重症医学科")){
			Set return="Y"
		}
	}*/
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-11-05
/// Description:  长期住院整体规则:
/// 				  	住院超过30日病人
/// return： 	  符合返回Y，不符合返回N          
/// w ##class(DHCMA.IMP.BTS.IMPCateRulesSrv).AdmDays30In(3)
ClassMethod AdmDays30In(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="N"
	Quit:aEpisodeID="" return
	
	Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
	Set AdmDays=(+$h)-AdmDate
	Quit:AdmDays<31 return //先做一个初步筛查，主要基于效率考虑
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aEpisodeID)
	Set DisDate=$p(DischDateTime,"^",1)
	If DisDate'="" {
		Set AdmDays=DisDate-AdmDate
	} Else {
		Set AdmDays=(+$h)-AdmDate
	}
	
	if AdmDays>31 {
		Set return="Y"
	}
	
	Quit return
}

}
