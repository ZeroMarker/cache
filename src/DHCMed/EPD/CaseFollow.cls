/// 名称: DHCMed.EPD.CaseFollow
/// 描述: HIV个案随访表结构
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-01
Class DHCMed.EPD.CaseFollow Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Property EPDSuper As DHCMed.EPD.Epidemic;

/// 病人ID
Property PatientID As %String(TRUNCATE = 1);

/// 报告编号
Property FollowNo As %String(TRUNCATE = 1);

/// 随访/失访/查无此人(EPDFollowStatus)
Property FollowStatus As DHCMed.SS.Dictionary;

/// 随访次数
Property FollowTimes As %String(TRUNCATE = 1);

/// 是否羁押(EPDIsCheck)
Property IsCustody As DHCMed.SS.Dictionary;

/// 失访原因(EPDNotFollowReasons)
Property Reasons As DHCMed.SS.Dictionary;

/// HIV检测(EPDIsCheck)
Property IsHIVTest As DHCMed.SS.Dictionary;

/// 无HIV阴性检测史
Property NeverHIVTest As %String(TRUNCATE = 1);

/// 最后一次HIV阴性检测时间(YYYY-MM)
Property LastHIVTestDate As %String(TRUNCATE = 1);

/// 第一次HIV阳性检测时间(YYYY-MM)
Property FirstHIVTestDate As %String(TRUNCATE = 1);

/// HIV阴性检测次数
Property HIVTestTimes As %String(TRUNCATE = 1);

/// 是否死亡
Property IsDead As DHCMed.SS.Dictionary;

/// 死亡日期(YYYY-MM-DD)
Property DeathDate As %String(TRUNCATE = 1);

/// 死亡时病程阶段(EPDDeathStage)
Property DeathStage As DHCMed.SS.Dictionary;

/// 死亡地点(EPDDeathPlace)
Property DeathPlace As DHCMed.SS.Dictionary;

/// 其它地点
Property DeathOtherPlace As %String(MAXLEN = 100, TRUNCATE = 1);

/// 死因来源(EPDDeathReasonSource)
Property DeathReasonSource As list Of DHCMed.SS.Dictionary;

/// 其它来源
Property DeathOtherSource As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主要死因(EPDDeathReason)
Property DeathReason As DHCMed.SS.Dictionary;

/// 死因相关艾滋病(EPDDeathReasonHIV)
Property DeathReasonHIV As list Of DHCMed.SS.Dictionary;

/// 死因无关艾滋病(EPDDeathReasonOthers)
Property DeathReasonOthers As list Of DHCMed.SS.Dictionary;

/// 艾滋病临床表现(EPDHIVManifestation)
Property HIVManifestation As list Of DHCMed.SS.Dictionary;

/// 艾滋其他相关性疾病
Property HIVOtherDisease As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病程阶段(EPDCourseStage)
Property CourseStage As DHCMed.SS.Dictionary;

/// 艾滋病确诊日期
Property HIVDate As %String(TRUNCATE = 1);

/// 配偶变化情况(EPDSpouseSituation)
Property SpouseSituation As DHCMed.SS.Dictionary;

/// 配偶HIV情况(EPDSpouseHIV)
Property SpouseHIV As DHCMed.SS.Dictionary;

/// 配偶检测日期
Property SpouseHIVDate As %String(TRUNCATE = 1);

/// 配偶随访编号
Property SpouseCaseNo As %String(TRUNCATE = 1);

/// 子女数
Property Children As %String(TRUNCATE = 1);

/// 子女阳性
Property Children1 As %String(TRUNCATE = 1);

/// 子女阴性
Property Children2 As %String(TRUNCATE = 1);

/// 子女不确定
Property Children3 As %String(TRUNCATE = 1);

/// 子女未查
Property Children4 As %String(TRUNCATE = 1);

/// 是否为教育员(EPDIsCheck)
Property HIVSurvey1 As DHCMed.SS.Dictionary;

/// (EPDIsCheckSurvey2)
Property HIVSurvey2 As DHCMed.SS.Dictionary;

Property HIVSurvey2No As %String(TRUNCATE = 1);

/// (EPDIsCheckSurvey3)
Property HIVSurvey3 As DHCMed.SS.Dictionary;

/// (EPDIsCheckSurvey4)
Property HIVSurvey4 As DHCMed.SS.Dictionary;

Property HIVSurvey4No As %String(TRUNCATE = 1);

/// (EPDIsCheckSurvey4)
Property HIVSurvey5 As DHCMed.SS.Dictionary;

Property HIVSurvey5No As %String(TRUNCATE = 1);

Property HIVSurvey5No1 As %String(TRUNCATE = 1);

/// (EPDIsCheck)
Property HIVSurvey6 As DHCMed.SS.Dictionary;

Property HIVSurvey6No As %String(TRUNCATE = 1);

/// (EPDIsCheckSurvey7)
Property HIVSurvey7 As DHCMed.SS.Dictionary;

/// (EPDIsCheck)
Property IsHIVSurvey7 As DHCMed.SS.Dictionary;

/// (EPDIsCheck)
Property HIVSurvey8 As DHCMed.SS.Dictionary;

/// (EPDIsCheck)
Property HIVSurvey8a As DHCMed.SS.Dictionary;

Property HIVSurvey8aNo1 As %String(TRUNCATE = 1);

Property HIVSurvey8aNo2 As %String(TRUNCATE = 1);

/// (EPDIsCheck)
Property HIVSurvey8b As DHCMed.SS.Dictionary;

/// (EPDIsCheck)
Property HIVSurvey8c As DHCMed.SS.Dictionary;

/// (EPDHIVSurvey9)
Property HIVSurvey9 As list Of DHCMed.SS.Dictionary;

/// (EPDIsCheck)
Property IsHIVSurvey10 As DHCMed.SS.Dictionary;

/// (EPDHIVSurvey10)
Property HIVSurvey10 As DHCMed.SS.Dictionary;

/// (EPDIsCheck)
Property IsHIVSurvey11 As DHCMed.SS.Dictionary;

Property IsHIVSurvey11No As %String(TRUNCATE = 1);

/// CD4检测次数
Property CD4TestTimes As %String(TRUNCATE = 1);

/// CD4检测结果
Property CD4TestResult As %String(TRUNCATE = 1);

/// CD4检测日期(YYYY-MM-DD)
Property CD4TestDate As %String(TRUNCATE = 1);

/// CD4检测单位
Property CD4TestUnit As %String(TRUNCATE = 1);

/// 随访单位
Property SurveyOrgan As %String(TRUNCATE = 1);

/// 随访责任人
Property SurveyName As %String(TRUNCATE = 1);

/// 随访日期(YYYY-MM-DD)
Property SurveyDate As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 备注
Property Comments As %String(MAXLEN = 500, TRUNCATE = 1);

/// 备用字段1  存储身份证号CardID，更新时判断反写传染病
Property FollowText1 As %String(TRUNCATE = 1);

/// 病人属于add by zsz20210812
Property HIVPatBelong As DHCMed.SS.Dictionary;

/// HIVrelevance(临床表现的备注)add by zsz20210812
Property HIVrelevance As %String(TRUNCATE = 1);

/// 病毒载量 add by zsz20210812
Property ViralloadTestResult As %String(TRUNCATE = 1);

/// 病毒载量的检测日期add by zsz20210812
Property ViralloadTestDate As %String(TRUNCATE = 1);

/// 母婴传播编号add by zsz20210812
Property posmonCaseNo As %String(TRUNCATE = 1);

/// 母婴传播检测单位add by zsz20210812
Property posmonTestUnit As %String(TRUNCATE = 1);

/// 目前艾滋病的抗病毒治疗情况add by zsz20210812
Property HIVTreatment As DHCMed.SS.Dictionary;

Index IndexPatID On PatientID;

/// 就诊号建立索引
Index HIVEpisodeIDIndex On EpisodeID;

/// 随访日期索引
Index HIVSurveyDateIndex On SurveyDate;

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-04
/// Description:  根据ID取报告对象
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       ID
/// Return：      返回obj
/// s obj=##class(DHCMed.EPD.CaseFollow).GetObjById(1)
ClassMethod GetObjById(ID As %String) As DHCMed.EPD.CaseFollow
{
	New (ID)
	Set return=""
	Quit:ID="" return
	
	Quit:'##class(DHCMed.EPD.CaseFollow).%ExistsId(+ID) return
	Set obj=##Class(DHCMed.EPD.CaseFollow).%OpenId(+ID)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-14
/// Description:  根据PatientID取报告对象
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       ID
/// Return：      返回obj
/// s obj=##class(DHCMed.EPD.CaseFollow).GetObjByPatId(1)
ClassMethod GetObjByPatId(PatientID As %String) As DHCMed.EPD.CaseFollow
{
	New (PatientID)
	Set return=""
	Quit:PatientID="" return
	
	Set RepID=""
	Set RepID=$o(^DHCMed.EPD.CaseFollowI("IndexPatID"," "_PatientID,RepID))
	Quit:PatientID="" return
	Set obj=##Class(DHCMed.EPD.CaseFollow).%OpenId(+RepID)
	Set return=obj
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-07-19
/// Description:  根据ID取所有报告时间
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       ID
/// Return：      返回AllDate
/// s obj=##class(DHCMed.EPD.CaseFollow).GetDateById(12)
ClassMethod GetDateById(aId As %String) As DHCMed.EPD.CaseFollow
{
	New (aId)
	Set return=""
	Quit:aId="" return
	Set objHIVRep=..GetObjById(+aId)
	
	Set LastHIVTestDate =##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.LastHIVTestDate)
	Set return    = LastHIVTestDate
	Set FirstHIVTestDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.FirstHIVTestDate)
	Set return    =return_"^"_FirstHIVTestDate
	Set DeathDate =##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.DeathDate)
	Set return    =return_"^"_DeathDate
	Set HIVDate   =##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.HIVDate)
	Set return    =return_"^"_HIVDate
	Set SpouseHIVDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.SpouseHIVDate)
	Set return    =return_"^"_SpouseHIVDate
	Set CD4TestDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.CD4TestDate)
	Set return    =return_"^"_CD4TestDate
	Set SurveyDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.SurveyDate)
	Set return    =return_"^"_SurveyDate
	Set ViralloadTestDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objHIVRep.ViralloadTestDate)
	Set return    =return_"^"_ViralloadTestDate
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-10
/// Description:  更新HIV个案随访表
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.EPD.CaseFollow).Update()
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ID=$p(aInput,aSeparate,1)
	
	If (ID="") {
		Set obj=##class(DHCMed.EPD.CaseFollow).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.CaseFollow).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set FollowNo=$p(aInput,aSeparate,2)
	if (FollowNo="") {
		Set obj.FollowNo=##class(DHCMed.EPDService.Service).GetNewRepNo("HIV") 
	} Else {
		Set obj.FollowNo=FollowNo
	} 
	Set obj.FollowStatus=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))
	Set obj.FollowTimes=$p(aInput,aSeparate,4)
	Set obj.IsCustody=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,5))
	Set obj.Reasons=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,6))
	//Set obj.PatName=$p(aInput,aSeparate,7)
	//Set obj.PatSex=$p(aInput,aSeparate,8)
	//Set obj.ParentName=$p(aInput,aSeparate,9)
	//Set obj.PatNo=$p(aInput,aSeparate,10)
	//Set obj.PhoneNo=$p(aInput,aSeparate,11)
	//Set obj.Address=$p(aInput,aSeparate,12)
	Set obj.IsHIVTest=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,13))
	Set obj.NeverHIVTest=$p(aInput,aSeparate,14)
	Set obj.LastHIVTestDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,15))
	Set obj.FirstHIVTestDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,16))
	Set obj.HIVTestTimes=$p(aInput,aSeparate,17)
	Set obj.IsDead=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,18))
	Set obj.DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,19))
	Set obj.DeathStage=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,20))
	Set obj.DeathPlace=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,21))
	Set obj.DeathOtherPlace=$p(aInput,aSeparate,22)
	Set DeathReasonSources=$p(aInput,aSeparate,23)
	
	While (obj.DeathReasonSource.Count()>0) {
		Do obj.DeathReasonSource.RemoveAt(1)
	}
	Set DeathReasonSourceLB=""
	For ind=1:1:$length(DeathReasonSources,",") {
		Set ReasonSource=$p(DeathReasonSources,",",ind)
		Continue:($listfind(DeathReasonSourceLB,ReasonSource)>0)
		Set DeathReasonSourceLB=DeathReasonSourceLB_$lb(ReasonSource)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(ReasonSource)
		Continue:'$IsObject(objDic)
		Do obj.DeathReasonSource.Insert(objDic)
	}
	
	Set obj.DeathOtherSource=$p(aInput,aSeparate,24)
	Set obj.DeathReason=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,25))
	Set DeathReasonHIVs=$p(aInput,aSeparate,26)
	
	While (obj.DeathReasonHIV.Count()>0) {
		Do obj.DeathReasonHIV.RemoveAt(1)
	}
	Set DeathReasonHIVLB=""
	For ind=1:1:$length(DeathReasonHIVs,",") {
		Set DeathReasonHIV=$p(DeathReasonHIVs,",",ind)
		Continue:($listfind(DeathReasonHIVLB,DeathReasonHIV)>0)
		Set DeathReasonHIVLB=DeathReasonHIVLB_$lb(DeathReasonHIV)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DeathReasonHIV)
		Continue:'$IsObject(objDic)
		Do obj.DeathReasonHIV.Insert(objDic)
	}
	
	Set DeathReasonOthers=$p(aInput,aSeparate,27)
	
	While (obj.DeathReasonOthers.Count()>0) {
		Do obj.DeathReasonOthers.RemoveAt(1)
	}
	Set DeathReasonOthersLB=""
	For ind=1:1:$length(DeathReasonOthers,",") {
		Set DeathReasonOther=$p(DeathReasonOthers,",",ind)
		Continue:($listfind(DeathReasonOthersLB,DeathReasonOther)>0)
		Set DeathReasonOthersLB=DeathReasonOthersLB_$lb(DeathReasonOther)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DeathReasonOther)
		Continue:'$IsObject(objDic)
		Do obj.DeathReasonOthers.Insert(objDic)
	}
	
	Set HIVManifestations=$p(aInput,aSeparate,28)
	
	While (obj.HIVManifestation.Count()>0) {
		Do obj.HIVManifestation.RemoveAt(1)
	}
	Set HIVManifestationsLB=""
	For ind=1:1:$length(HIVManifestations,",") {
		Set HIVManifestation=$p(HIVManifestations,",",ind)
		Continue:($listfind(HIVManifestationsLB,HIVManifestation)>0)
		Set HIVManifestationsLB=HIVManifestationsLB_$lb(HIVManifestation)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(HIVManifestation)
		Continue:'$IsObject(objDic)
		Do obj.HIVManifestation.Insert(objDic)
	}
	
	Set obj.CourseStage=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,29))
	Set obj.HIVDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,30))
	Set obj.SpouseSituation=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,31))
	Set obj.SpouseHIV=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,32))
	Set obj.SpouseHIVDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,33))
	Set obj.SpouseCaseNo=$p(aInput,aSeparate,34)
	Set obj.Children=$p(aInput,aSeparate,35)
	Set obj.Children1=$p(aInput,aSeparate,36)
	Set obj.Children2=$p(aInput,aSeparate,37)
	Set obj.Children3=$p(aInput,aSeparate,38)
	Set obj.Children4=$p(aInput,aSeparate,39)
	Set obj.HIVSurvey1=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,40))
	Set obj.HIVSurvey2=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,41))
	Set obj.HIVSurvey2No=$p(aInput,aSeparate,42)
	Set obj.HIVSurvey3=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,43))
	Set obj.HIVSurvey4=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,44))
	Set obj.HIVSurvey4No=$p(aInput,aSeparate,45)
	Set obj.HIVSurvey5=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,46))
	Set obj.HIVSurvey5No=$p(aInput,aSeparate,47)
	Set obj.HIVSurvey5No1=$p(aInput,aSeparate,48)
	Set obj.HIVSurvey6=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,49))
	Set obj.HIVSurvey6No=$p(aInput,aSeparate,50)
	Set obj.HIVSurvey7=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,51))
	Set obj.IsHIVSurvey7=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,52))
	Set obj.HIVSurvey8=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,53))
	Set obj.HIVSurvey8a=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,54))
	Set obj.HIVSurvey8aNo1=$p(aInput,aSeparate,55)
	Set obj.HIVSurvey8aNo2=$p(aInput,aSeparate,56)
	Set obj.HIVSurvey8b=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,57))
	Set obj.HIVSurvey8c=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,58))
	Set HIVSurvey9s=$p(aInput,aSeparate,59)
	
	While (obj.HIVSurvey9.Count()>0) {
		Do obj.HIVSurvey9.RemoveAt(1)
	}
	Set HIVSurvey9LB=""
	For ind=1:1:$length(HIVSurvey9s,",") {
		Set HIVSurvey9=$p(HIVSurvey9s,",",ind)
		Continue:($listfind(HIVSurvey9LB,HIVSurvey9)>0)
		Set HIVSurvey9LB=HIVSurvey9LB_$lb(HIVSurvey9)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(HIVSurvey9)
		Continue:'$IsObject(objDic)
		Do obj.HIVSurvey9.Insert(objDic)
	}
	
	Set obj.IsHIVSurvey10=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,60))
	Set obj.HIVSurvey10=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,61))
	Set obj.IsHIVSurvey11=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,62))
	Set obj.IsHIVSurvey11No=$p(aInput,aSeparate,63)
	Set obj.CD4TestTimes=$p(aInput,aSeparate,64)
	Set obj.CD4TestResult=$p(aInput,aSeparate,65)
	Set obj.CD4TestDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,66))
	Set obj.CD4TestUnit=$p(aInput,aSeparate,67)
	Set obj.SurveyOrgan=$p(aInput,aSeparate,68)
	Set obj.SurveyName=$p(aInput,aSeparate,69)
	Set obj.SurveyDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,70))
	Set obj.Comments=$p(aInput,aSeparate,71)
	
	Set obj.PatientID=$p(aInput,aSeparate,72)
	Set obj.EpisodeID=$p(aInput,aSeparate,73)
	
	Set obj.FollowText1 = $p(aInput,aSeparate,74)   //身份证号
	Set EPDRepID=$p(aInput,aSeparate,75)
	Set obj.EPDSuper=##Class(DHCMed.EPD.Epidemic).GetObjById(EPDRepID)
	
	Set obj.HIVPatBelong=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,76))
	Set obj.HIVrelevance=$p(aInput,aSeparate,77)
	Set obj.ViralloadTestResult=$p(aInput,aSeparate,78)
	Set obj.ViralloadTestDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInput,aSeparate,79))
	Set obj.posmonCaseNo=$p(aInput,aSeparate,80)
	Set obj.posmonTestUnit=$p(aInput,aSeparate,81)
	Set obj.HIVTreatment=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,82))
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	//视情况回写传染病 1.身份证号不为空，传染病里证件类型为居民身份证号，且对应的身份证号不等
	Set Status=obj.FollowStatus.Description
	If ($IsObject(obj.EPDSuper))&&(obj.FollowText1'=""){
		Set EPDID = obj.EPDSuper.%Id()
		Set CardType = obj.EPDSuper.MEPDText4
		Set CardID = obj.EPDSuper.MEPDText5
		
		Set objCardType = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicCardType",CardType,"")
		If $IsObject(objCardType){
			Set CardType = objCardType.Description
		}
		/*If (( CardType = "居民身份证号" )&&( CardID '= obj.FollowText1 )) {
			//有效证件类型
			tStart
			Set objEPD = ##Class(DHCMed.EPD.Epidemic).%OpenId(EPDID)
			Set objEPD.MEPDText5 = obj.FollowText1
			Set sc = objEPD.%Save()
			If $System.Status.IsError( sc ) { 
				tRollback
			}else{
				do objEPD.%Close()
				tCommit
			}
		}*/
	}
	
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-10
/// Description:  删除HIV随访报告
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       DHCMed.EPD.CaseFollow.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.EPD.CaseFollow).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-10
/// Description:  取list属性RowID
/// Table：       DHCMed.EPD.CaseFollow
/// Input：       ID，属性名
/// Return：      返回String
/// w ##class(DHCMed.EPD.CaseFollow).GetFieldById(1,"DeathReasonSource")
ClassMethod GetFieldById(aId As %String, aFieldName As %String) As %String
{
	New (aId,aFieldName)
	Set return=""
	Quit:(aId="")||(aFieldName="") return
	
	Set obj=##Class(DHCMed.EPD.CaseFollow).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	If (aFieldName="DeathReasonSource") {
		For ind=1:1:obj.DeathReasonSource.Count() {
			Set objDic=obj.DeathReasonSource.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_","_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	}ElseIf(aFieldName="DeathReasonHIV") {
		For ind=1:1:obj.DeathReasonHIV.Count() {
			Set objDic=obj.DeathReasonHIV.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_","_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	}ElseIf(aFieldName="DeathReasonOthers") {
		For ind=1:1:obj.DeathReasonOthers.Count() {
			Set objDic=obj.DeathReasonOthers.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_","_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	}ElseIf(aFieldName="HIVManifestation") {
		For ind=1:1:obj.HIVManifestation.Count() {
			Set objDic=obj.HIVManifestation.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_","_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	}ElseIf(aFieldName="HIVSurvey9") {
		For ind=1:1:obj.HIVSurvey9.Count() {
			Set objDic=obj.HIVSurvey9.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set return=return_","_objDic.%Id()
		}
		Set:return'="" return=$e(return,2,$l(return))
	}
	
	Quit return
}

/*
/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-10
/// Description:  根据EpisodeID取传染病报告信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       EpisodeID
/// Return：      返回ID
/// w ##class(DHCMed.EPD.CaseFollow).GetEPDInfoByAdm(7542464,"")
ClassMethod GetEPDInfoByAdm(aEpisodeID As %String, aReportID As %String = "") As %String
{
	New (aEpisodeID,aReportID)
	Set return=""
	Set aRepID=""
	set ^tempzsztest("sdfhhhhhjjjksdkfkskdfskkdf")=$lb(aEpisodeID,aReportID)
	If (aReportID'=""){
		Set obj=..GetObjById(aReportID)
		Quit:'$IsObject(obj) return
		Set aRepID=obj.EPDSuper.%Id()
		//Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
		Set return=$$GetReturn(aRepID)
		Quit:return'="" return 
	}
	Quit:(aEpisodeID="") return
	//Set aRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,""),-1)
	//Quit:aRepID="" return
	//Set return=$$GetReturn(aRepID)
	//Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	
	set aRepID=""
	for {
		Set aRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,aRepID))
		;b ;1111
		Quit:aRepID="" 
		Set return=$$GetReturn(aRepID)	
	}
	Quit return
GetReturn(RepID)
	Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	Quit:'$IsObject(objRep) return
	Quit:objRep.MEPDStatus="4" return //被订状态报告无效
	Quit:objRep.MEPDStatus="6" return //草稿状态报告无效
	Quit:objRep.MEPDStatus="7" return //删除状态报告无效
	Quit:'$IsObject(objRep.MEPDICDDR) return
	;b ;2
	Set Diagnos=objRep.MEPDICDDR.MIFDisease
    ;b ;33
	Quit:(Diagnos'="HIV")&&(Diagnos'="艾滋病") return
	;b ;344
	//获取证件类型
	Set CardType=objRep.MEPDText4
	Set objCardType = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicCardType",CardType,"")
	If $IsObject(objCardType){
		Set CardType = objCardType.Description
	}
	;b ;5766
	Set return=RepID_"^"_objRep.MEPDFamName_"^"_objRep.MEPDTelPhone_"^"_objRep.MEPDAddress_"号"_"^"_CardType_"^"_objRep.MEPDText5
	
	Quit return
}*/
/// Creator：     jiangpengpeng
/// CreatDate：   2015-08-10
/// Description:  根据EpisodeID取传染病报告信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       EpisodeID
/// Return：      返回ID
/// w ##class(DHCMed.EPD.CaseFollow).GetEPDInfoByAdm(2799,2)
ClassMethod GetEPDInfoByAdm(aEpisodeID As %String, aReportID As %String = "") As %String
{
	New (aEpisodeID,aReportID)
	Set return=""
	Set aRepID=""
	
	If (aReportID'=""){
		Set obj=..GetObjById(aReportID)
		Quit:'$IsObject(obj) return
		Set aRepID=obj.EPDSuper.%Id()
		//Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
		Set return=$$GetReturnnew(aRepID)
		Quit:return'="" return 
	}
	Quit:(aEpisodeID="") return
	//Set aRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",aEpisodeID,""),-1)
	//Quit:aRepID="" return
	//Set return=$$GetReturn(aRepID)
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	Set AdmType=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Quit:AdmType=""
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
			Continue:VisitStatus="C" 
			set aRepID=""
			for {
				Set aRepID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",Paadm,aRepID))
				Quit:aRepID="" 
				Set return=$$GetReturnnew(aRepID)	
			    }	
	       }
	    }
	Quit return
GetReturnnew(RepID)
	Set objRep=##Class(DHCMed.EPD.Epidemic).GetObjById(RepID)
	Quit:'$IsObject(objRep) return
	Quit:objRep.MEPDStatus="4" return //被订状态报告无效
	if (aReportID=""){
		Quit:objRep.MEPDStatus="6" return //草稿状态报告无效
		Quit:objRep.MEPDStatus="7" return //删除状态报告无效
	}
	Quit:'$IsObject(objRep.MEPDICDDR) return
	Set Diagnos=objRep.MEPDICDDR.MIFDisease
	Quit:(Diagnos'="HIV")&&(Diagnos'="艾滋病") return
	//获取证件类型
	Set CardType=objRep.MEPDText4
	Set objCardType = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicCardType",CardType,"")
	If $IsObject(objCardType){
		Set CardType = objCardType.Description
	}
	Set return=RepID_"^"_objRep.MEPDFamName_"^"_objRep.MEPDTelPhone_"^"_objRep.MEPDAddress_"号"_"^"_CardType_"^"_objRep.MEPDText5
	
	Quit return
}

Storage Default
{
<Data name="CaseFollowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPDSuper</Value>
</Value>
<Value name="3">
<Value>CaseNo</Value>
</Value>
<Value name="4">
<Value>IsFollow</Value>
</Value>
<Value name="5">
<Value>NotFollow</Value>
</Value>
<Value name="6">
<Value>NotFind</Value>
</Value>
<Value name="7">
<Value>FollowTimes</Value>
</Value>
<Value name="8">
<Value>IsCustody</Value>
</Value>
<Value name="9">
<Value>Reasons</Value>
</Value>
<Value name="10">
<Value>IsHIVTest</Value>
</Value>
<Value name="11">
<Value>NeverHIVTest</Value>
</Value>
<Value name="12">
<Value>LastHIVTestDate</Value>
</Value>
<Value name="13">
<Value>FirstHIVTestDate</Value>
</Value>
<Value name="14">
<Value>HIVTestTimes</Value>
</Value>
<Value name="15">
<Value>IsDead</Value>
</Value>
<Value name="16">
<Value>DeathDate</Value>
</Value>
<Value name="17">
<Value>DeathStage</Value>
</Value>
<Value name="18">
<Value>DeathPlace</Value>
</Value>
<Value name="19">
<Value>DeathReasonSource</Value>
</Value>
<Value name="20">
<Value>DeathReason</Value>
</Value>
<Value name="21">
<Value>DeathReasonHIV</Value>
</Value>
<Value name="22">
<Value>DeathReasonOthers</Value>
</Value>
<Value name="23">
<Value>HIVManifestation</Value>
</Value>
<Value name="24">
<Value>CourseStage</Value>
</Value>
<Value name="25">
<Value>HIVDate</Value>
</Value>
<Value name="26">
<Value>SpouseSituation</Value>
</Value>
<Value name="27">
<Value>SpouseHIV</Value>
</Value>
<Value name="28">
<Value>SpouseHIVDate</Value>
</Value>
<Value name="29">
<Value>SpouseCaseNo</Value>
</Value>
<Value name="30">
<Value>Children</Value>
</Value>
<Value name="31">
<Value>Children1</Value>
</Value>
<Value name="32">
<Value>Children2</Value>
</Value>
<Value name="33">
<Value>Children3</Value>
</Value>
<Value name="34">
<Value>Children4</Value>
</Value>
<Value name="35">
<Value>HIVSurvey1</Value>
</Value>
<Value name="36">
<Value>HIVSurvey2</Value>
</Value>
<Value name="37">
<Value>HIVSurvey2No</Value>
</Value>
<Value name="38">
<Value>HIVSurvey3</Value>
</Value>
<Value name="39">
<Value>HIVSurvey4</Value>
</Value>
<Value name="40">
<Value>HIVSurvey4No</Value>
</Value>
<Value name="41">
<Value>HIVSurvey5</Value>
</Value>
<Value name="42">
<Value>HIVSurvey5No</Value>
</Value>
<Value name="43">
<Value>HIVSurvey5No1</Value>
</Value>
<Value name="44">
<Value>HIVSurvey6</Value>
</Value>
<Value name="45">
<Value>HIVSurvey6No</Value>
</Value>
<Value name="46">
<Value>HIVSurvey7</Value>
</Value>
<Value name="47">
<Value>IsHIVSurvey7</Value>
</Value>
<Value name="48">
<Value>HIVSurvey8a</Value>
</Value>
<Value name="49">
<Value>HIVSurvey8aNo1</Value>
</Value>
<Value name="50">
<Value>HIVSurvey8aNo2</Value>
</Value>
<Value name="51">
<Value>HIVSurvey8b</Value>
</Value>
<Value name="52">
<Value>HIVSurvey8c</Value>
</Value>
<Value name="53">
<Value>HIVSurvey9</Value>
</Value>
<Value name="54">
<Value>IsHIVSurvey10</Value>
</Value>
<Value name="55">
<Value>HIVSurvey10</Value>
</Value>
<Value name="56">
<Value>IsHIVSurvey11</Value>
</Value>
<Value name="57">
<Value>IsHIVSurvey11No</Value>
</Value>
<Value name="58">
<Value>CD4TestTimes</Value>
</Value>
<Value name="59">
<Value>CD4TestResult</Value>
</Value>
<Value name="60">
<Value>CD4TestDate</Value>
</Value>
<Value name="61">
<Value>CD4TestUnit</Value>
</Value>
<Value name="62">
<Value>SurveyOrgan</Value>
</Value>
<Value name="63">
<Value>SurveyName</Value>
</Value>
<Value name="64">
<Value>SurveyDate</Value>
</Value>
<Value name="65">
<Value>Comments</Value>
</Value>
<Value name="66">
<Value>DeathOtherPlace</Value>
</Value>
<Value name="67">
<Value>DeathOtherSource</Value>
</Value>
<Value name="68">
<Value>HIVOtherDisease</Value>
</Value>
<Value name="69">
<Value>FollowStatus</Value>
</Value>
<Value name="70">
<Value>EpisodeID</Value>
</Value>
<Value name="71">
<Value>FollowNo</Value>
</Value>
<Value name="72">
<Value>PatientID</Value>
</Value>
<Value name="73">
<Value>HIVSurvey8</Value>
</Value>
<Value name="74">
<Value>FollowText1</Value>
</Value>
<Value name="75">
<Value>HIVPatBelong</Value>
</Value>
<Value name="76">
<Value>HIVrelevance</Value>
</Value>
<Value name="77">
<Value>ViralloadTestResult</Value>
</Value>
<Value name="78">
<Value>ViralloadTestDate</Value>
</Value>
<Value name="79">
<Value>posmonCaseNo</Value>
</Value>
<Value name="80">
<Value>posmonTestUnit</Value>
</Value>
<Value name="81">
<Value>HIVTreatment</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.CaseFollowD</DataLocation>
<DefaultData>CaseFollowDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.CaseFollowD</IdLocation>
<IndexLocation>^DHCMed.EPD.CaseFollowI</IndexLocation>
<StreamLocation>^DHCMed.EPD.CaseFollowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
