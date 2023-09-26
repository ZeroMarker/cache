/// 名称: DHCMed.NINFService.Rep.InfReportInfPos
/// 描述: 医院感染报告 感染相关
/// 编写者：zhufei
/// 编写日期: 2011-06-19
Class DHCMed.NINFService.Rep.InfReportInfPos Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 感染相关
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReportInfPos.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As %String
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"InfPos",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 感染相关
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReportInfPos.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportInfPos
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportInfPos).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-25
/// Description:  取医院感染报告 感染信息 侵害性操作
///               主要处理"List"类型数据
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReportInfPos.ID
/// Return：      返回String
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).GetFieldById(1,"InfPosOpr")
ClassMethod GetFieldById(aId As %String, aFieldName As %String) As %String
{
	New (aId,aFieldName)
	Set return=""
	Quit:(aId="")||(aFieldName="") return
	
	Set $ZT="GetFieldByIdErr"
	
	Set obj=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(aId)
	Quit:'$IsObject(obj) return
	
	If aFieldName="InfPosOpr" {
		For ind=1:1:obj.InfPosOpr.Count() {
			Set objDic=obj.InfPosOpr.GetAt(ind)
			Continue:'$IsObject(objDic)
			Set InvasiveOperID=""
			If $IsObject(objDic.InvasiveOper) {
				Set InvasiveOperID=objDic.InvasiveOper.%Id()
			}
			Set StartDate=objDic.StartDate
			Set StartTime=objDic.StartTime
			Set EndDate=objDic.EndDate
			Set EndTime=objDic.EndTime
			Set return=return_$c(1)_InvasiveOperID_$c(2)_StartDate_$c(2)_StartTime_$c(2)_EndDate_$c(2)_EndTime
		}
		Set:return'="" return=$e(return,2,$l(return))
	} Else {
		Set valExpress="Set return=obj."_aFieldName
		X valExpress
	}
	
	Quit return
	
GetFieldByIdErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 感染相关 侵害性操作
/// Table：       DHCMed.NINF.Rep.InfReportInfPosOpr
/// Input：       DHCMed.NINF.Rep.InfReportInfPosOpr.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).GetChildObj()
ClassMethod GetChildObj() As DHCMed.NINF.Rep.InfReportInfPosOpr
{
	New 
	Set return=##Class(DHCMed.NINF.Rep.InfReportInfPosOpr).%New()
	If return'="" Do return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  删除医院感染报告 感染信息
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).DelSubRec(1)
ClassMethod DelSubRec(aId As %String) As %String
{
	New (aId)
	Set return=##Class(DHCMed.NINF.Rep.InfReportInfPos).DeleteById(aId)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-05-04
/// Description:  删除医院感染报告 感染信息
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).DelInfPos(1)
ClassMethod DelInfPos(aReportID As %String) As %String
{
	New (aReportID)
	Set return=0
	
	Set xSubID=0,flg=1
	For {
		Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"InfPos",xSubID))
		Quit:xSubID=""
		Set flg=##Class(DHCMed.NINF.Rep.InfReportInfPos).DeleteById(aReportID_"||"_xSubID)
	}
	Quit:flg<1 return
	
	Set return=1
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告 感染相关
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input：       
/// Return：      返回ID
/// w ##class(DHCMed.NINFService.Rep.InfReportInfPos).SaveSubRec("18"_$c(1,1,1,1)_"2014-05-04"_$c(1,1,1,1,1,1,1)_"3369",$c(1)_","_$c(2)_","_$c(3))
ClassMethod SaveSubRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveSubRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Quit:(CHR1="")||(CHR2="")||(CHR3="") return
	
	Set RepID=$p(aInput,CHR1,1)
	Quit:RepID="" return
	Quit:'$d(^DHCMed.NINF("InfRep",RepID)) return
	
	Set InfPos=$p(aInput,CHR1,4)
	//Quit:InfPos="" return  //新生儿感染没有感染部位
	
	Set InfDate=$p(aInput,CHR1,5)
	;Set:InfDate["-" InfDate=$zdh(InfDate,3)
	Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InfDate)
	
	//Add By LiYang 2013-05-18 增加修改医院感染结束日期
	Set InfEndDate=$p(aInput,CHR1,8)
	;Set:InfEndDate["-" InfEndDate=$zdh(InfEndDate,3)
	Set:InfEndDate'="" InfEndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(InfEndDate)
	
	//与感染部位有关的侵害性操作
	Set InfPosOpr="",tmpInfPosOpr=$p(aInput,CHR1,7)
	For indOpr=1:1:$l(tmpInfPosOpr,CHR2) {
		Set InfPosOprRec=$p(tmpInfPosOpr,CHR2,indOpr)
		Continue:InfPosOprRec=""
		
		Set StartDate=$p(InfPosOprRec,CHR3,2)
		;Set:StartDate["-" StartDate=$zdh(StartDate,3)
		Set:StartDate'="" StartDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(StartDate)
		Set StartTime=$p(InfPosOprRec,CHR3,3)
		Set:StartTime[":" StartTime=$zth(StartTime,1)
		Set EndDate=$p(InfPosOprRec,CHR3,4)
		;Set:EndDate["-" EndDate=$zdh(EndDate,3)
		Set:EndDate'="" EndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EndDate)
		Set EndTime=$p(InfPosOprRec,CHR3,5)
		Set:EndTime[":" EndTime=$zth(EndTime,1)
		
		Set $p(InfPosOprRec,CHR3,2)=StartDate
		Set $p(InfPosOprRec,CHR3,3)=StartTime
		Set $p(InfPosOprRec,CHR3,4)=EndDate
		Set $p(InfPosOprRec,CHR3,5)=EndTime
		
		Set InfPosOpr=InfPosOpr_CHR2_InfPosOprRec
	}
	Set:InfPosOpr'="" InfPosOpr=$e(InfPosOpr,2,$l(InfPosOpr))
	
	Set $p(aInput,CHR1,5)=InfDate
	Set $p(aInput,CHR1,7)=InfPosOpr
	Set $p(aInput,CHR1,8)=InfEndDate //感染结束日期
	
	Set return=##Class(DHCMed.NINF.Rep.InfReportInfPos).Update(aInput,CHR1_","_CHR2_","_CHR3)
	Quit return
	
SaveSubRecErr
	Quit -999
}

/// Creator : LiYang
/// CreateDate: 2013-05-19
/// Description: 保存医院感染结束日期
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input:  
/// RowID: DHCMed.NINF.Rep.InfReportInfPos的RowID
/// EndDate: 结束日期
ClassMethod SaveInfEndResult(RowID As %String, EndDate As %String, InfEndResultID As %String) As %String
{
	n (RowID,EndDate,InfEndResultID)
	Set ret=-1
	Set obj=##class(DHCMed.NINF.Rep.InfReportInfPos).%OpenId(RowID)
	Quit:'$IsObject(obj) ret
	Set:EndDate["-" EndDate=$zdh(EndDate,3)
	Set:EndDate["/" EndDate=$zdh(EndDate,4)
	Set obj.InfEndDate=EndDate
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(InfEndResultID)
	Set:'$IsObject(objDic) objDic=##class(DHCMed.SS.Dictionary).%New()
	Set obj.InfEndResult=objDic
	Set tmp=obj.%Save()
	Do objDic.%Close()
	Do obj.%Close()
	Set ret=obj.%Id()
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  查询感染信息
/// Table：       DHCMed.NINF.Rep.InfReportInfPos
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReportInfPos","QrySubRec","1","")
Query QrySubRec(aReportID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,SubID:%String,InfPosID:%String,InfPosDesc:%String,InfDate:%String,InfDiagnosID:%String,InfDiagnosDesc:%String,InfDiagCatID:%String,InfDiagCatDesc:%String,InfPosOprValues:%String,InfPosOprDescs:%String,DataSource:%String,InfEndDate:%String,InfEndResultID:%String,InfEndResultDesc:%String,DiagnosisBasis:%String,DiseaseCourse:%String")
{
}

ClassMethod QrySubRecExecute(ByRef qHandle As %Binary, aReportID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aReportID="")&&(aEpisodeID="") $$$OK
	
	If aReportID'="" {
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCMed.NINF("InfRep",aReportID,"InfPos",xSubID))
			Quit:xSubID=""
			
			Set objSub=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(aReportID_"||"_xSubID)
			Continue:'$IsObject(objSub)
			
			Set (InfPosID,InfPosDesc,InfDate,InfDiagID,InfDiagDesc,InfDiagCatID,InfDiagCatDesc)=""
			Set (InfPosOprValues,InfPosOprDescs,DataSource)=""
			
			If $IsObject(objSub.InfPos) {
				Set InfPosID=objSub.InfPos.%Id()
				Set InfPosDesc=objSub.InfPos.IPDesc
			}
			Set InfDate=objSub.InfDate
			;Set:InfDate'="" InfDate=$zd(InfDate,3)
			Set:InfDate'="" InfDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InfDate)
			If $IsObject(objSub.InfDiag) {
				Set InfDiagID=objSub.InfDiag.%Id()
				Set InfDiagDesc=objSub.InfDiag.IDDesc
			}
			If $IsObject(objSub.InfDiagCat) {
				Set InfDiagCatID=objSub.InfDiagCat.%Id()
				Set InfDiagCatDesc=objSub.InfDiagCat.Description
			}
			
			For indOpr=1:1:objSub.InfPosOpr.Count() {
				Set objInfPosOpr=objSub.InfPosOpr.GetAt(indOpr)
				Set StartDate=objInfPosOpr.StartDate
				Set StartTime=objInfPosOpr.StartTime
				Set EndDate=objInfPosOpr.EndDate
				Set EndTime=objInfPosOpr.EndTime
				Set InfPosOprValue="",InfPosOprDesc=""
				If $IsObject(objInfPosOpr.InvasiveOper) {
					Set InfPosOprValue=objInfPosOpr.InvasiveOper.%Id()
					Set InfPosOprDesc=objInfPosOpr.InvasiveOper.Description
				}
				Set InfPosOprValues=InfPosOprValues_$c(1)_InfPosOprValue_$c(2)_StartDate_$c(2)_StartTime_$c(2)_EndDate_$c(2)_EndDate
				Set InfPosOprDescs=InfPosOprDescs_","_InfPosOprDesc
			}
			Set:InfPosOprValues'="" InfPosOprValue=$e(InfPosOprValues,2,$l(InfPosOprValues))
			Set:InfPosOprDescs'="" InfPosOprDescs=$e(InfPosOprDescs,2,$l(InfPosOprDescs))
			
			Set DataSource=objSub.DataSource
			//Add By LiYang 2013-05-18 增加感染结束日期、转归
			Set EndDate=objSub.InfEndDate 
			;Set:EndDate'="" EndDate=$zd(EndDate,3)
			Set:EndDate'="" EndDate=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EndDate)
			Set EndResultID=""
			Set EndResultDesc=""
			if $IsObject(objSub.InfEndResult)
			{
				Set EndResultID=objSub.InfEndResult.%Id()
				Set EndResultDesc=objSub.InfEndResult.Description
			}
			//诊断依据
			Set DiagnosisBasis=objSub.DiagnosisBasis
			Set DiagnosisBasis=$zcvt(DiagnosisBasis,"O","HTML")
			//感染性疾病病程
			Set DiseaseCourse=objSub.DiseaseCourse
			Set DiseaseCourse=$zcvt(DiseaseCourse,"O","HTML")
			
			Set Data=$lb(aReportID,xSubID)
			Set Data=Data_$lb(InfPosID,InfPosDesc,InfDate,InfDiagID,InfDiagDesc,InfDiagCatID,InfDiagCatDesc)
			Set Data=Data_$lb(InfPosOprValues,InfPosOprDescs,DataSource,EndDate,EndResultID,EndResultDesc) //Modified By LiYang 2013-05-19 //增加列：感染结束日期
			Set Data=Data_$lb(DiagnosisBasis,DiseaseCourse)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		//保留
	}
	Quit $$$OK
}

ClassMethod QrySubRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySubRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySubRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySubRecExecute ]
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

}
