/// 名称: DHCMed.CCService.Ctrl.Evaluation
/// 描述: 监控评价信息
/// 编写者：zhufei
/// 编写日期: 2011-05-20
Class DHCMed.CCService.Ctrl.Evaluation Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  评价表ID取监控评价数据
/// Return:       $lb() 或 ""
ClassMethod BuildData(argEvalID As %String) As %List
{
	New (argEvalID)
	Set return=""
	Quit:argEvalID="" return
	
	Set $ZT="BuildDataErr"
	Set objEval=##class(DHCMed.CC.Evaluation).GetObjById(argEvalID)
    If $IsObject(objEval){
	    Set (SubjectID,SubjectDesc,EvalUserDesc,EvalLocDesc)=""
	    Set EvalID=objEval.%Id()
	    If $IsObject(objEval.SubjectDr){
		    Set SubjectID=objEval.SubjectDr.%Id()
		    Set SubjectDesc=objEval.SubjectDr.Title
		}
	    Set Paadm=objEval.PaadmDr
	    Set EvalDate=objEval.EvalDate
	    Set:EvalDate'="" EvalDate=$zd(EvalDate,3)
	    Set EvalTime=objEval.EvalTime
	    Set:EvalTime'="" EvalTime=$zt(EvalTime,2)
	    Set EvalUserID=objEval.EvalUser
	    Set:EvalUserID'="" EvalUserDesc=$p($g(^SSU("SSUSR",EvalUserID)),"^",2)
	    Set EvalLocID=objEval.EvalLoc
	    Set:EvalLocID'="" EvalLocDesc=$p($g(^CTLOC(EvalLocID)),"^",2)
	    Set EvalInfo=objEval.EvalInfo
	    Set IsActive=objEval.IsActive
	    Set IsActive=$s(IsActive=1:"Yes",1:"No")
	    Set ResumeTxt=objEval.Resume
	    Set Data=$lb(EvalID,SubjectID,Paadm,EvalDate,EvalTime,EvalUserID,EvalUserDesc,EvalLocID,EvalLocDesc,EvalInfo,IsActive,ResumeTxt)
	    Set return=Data
	}
    
	Quit return
	
BuildDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2011-05-20
/// Description:  取监控评价信息
/// Input：       Paadm(就诊号),SubjectID(主题ID)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CCService.Ctrl.Evaluation","QryEvaluation","1","1")
Query QryEvaluation(argSubjectID As %String, argPaadm As %String) As %Query(ROWSPEC = "EvalID:%String,SubjectID:%String,Paadm:%String,EvalDate:%String,EvalTime:%String,EvalUserID:%String,EvalUserDesc:%String,EvalLocID:%String,EvalLocDesc:%String,EvalInfo:%String,IsActive:%String,ResumeTxt:%String")
{
}

ClassMethod QryEvaluationExecute(ByRef qHandle As %Binary, argSubjectID As %String, argPaadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(argSubjectID="")||(argPaadm="") $$$OK
	
	Set EvalID=0
	For {
		Set EvalID=$o(^DHCMed.CCi("Eval",0,"IndexSubjectAdm",argSubjectID,argPaadm,EvalID))
		Quit:EvalID=""
		Set Data=..BuildData(EvalID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}			
	
	Quit $$$OK
}

ClassMethod QryEvaluationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEvaluationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEvaluationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEvaluationExecute ]
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

/// w ##Class(DHCMed.CCService.Ctrl.Evaluation).GetEvalInfo(1,64842)
ClassMethod GetEvalInfo(argSubjectID As %String, argPaadm As %String) As %String
{
	New (argSubjectID,argPaadm)
	Set return=""
	Quit:(argSubjectID="")||(argPaadm="") return
	
	Set EvalID=0
	For {
		Set EvalID=$o(^DHCMed.CCi("Eval",0,"IndexSubjectAdm",argSubjectID,argPaadm,EvalID))
		Quit:EvalID=""
		Set objEval=##class(DHCMed.CC.Evaluation).GetObjById(EvalID)
		If $IsObject(objEval) {
			Set IsActive=objEval.IsActive
			Continue:IsActive'=1
		    Set EvalInfo=objEval.EvalInfo
		    Set return=return_EvalInfo_";"
		}
	}
	
	Quit return
}

/// w ##Class(DHCMed.CCService.Ctrl.Evaluation).iconEvaluation(SubjectID,Paadm)
ClassMethod iconEvaluation(argSubjectID As %String, argPaadm As %String) As %String
{
	New (argSubjectID,argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="iconEvaluationErr"
	Set SubjectID=0
	For {
		Set SubjectID=$o(^DHCMed.CCi("Eval",0,"IndexSubjectAdm",SubjectID))
		Quit:SubjectID=""
		Continue:(argSubjectID'="")&&(SubjectID'=argSubjectID)
		Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
		Continue:'$IsObject(objSubject)
		Set SubjectDesc=objSubject.Title
		Set EvalID="",tmpInfo=""
		For {
			Set EvalID=$o(^DHCMed.CCi("Eval",0,"IndexSubjectAdm",SubjectID,argPaadm,EvalID))
			Quit:EvalID=""
			
			Set objEval=##class(DHCMed.CC.Evaluation).GetObjById(EvalID)
			Continue:'$IsObject(objEval)
			Set IsActive=objEval.IsActive
	    	Continue:IsActive'=1
	    	Set tmpInfo=tmpInfo_","_objEval.EvalInfo
		}
		Set:tmpInfo'="" return=return_SubjectDesc_":"_tmpInfo_";"
	}
	
	Quit return
	
iconEvaluationErr
	Quit ""
}

}
