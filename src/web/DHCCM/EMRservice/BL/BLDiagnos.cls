Import sqluser

/// 资源区诊断引用
Class web.DHCCM.EMRservice.BL.BLDiagnos Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      Candy
/// CreateDate：   2011-10-27
/// Description:： According to PEpisodeID search for MRDiagnos List
/// Table： MR_Diagnos
/// Input： PEpisodeID
/// Output：ARowID:诊断ID
///         AMRADMRowId
///         ADiaSubID
///         ADiagnosTypeID:类型ID
///         ADiagnosType:类型名称,
///         AIcdID:诊断ICDID
///         ADiagnosName:诊断名称
///         ADemo:备注
///         AEvaluation:状态属性,
///         AEvaluationDesc:状态属性名称
///         ICDCode 诊断代码
///         AEffects:转归属性
///         AEffectsDesc:转归属性名称,
///         ALevel:级别,ASquence:顺序,AUserName:医生,ADateTime:时间
/// Others：do ##class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnos","GetMRDiagnosList","76","")
Query GetMRDiagnosList(PEpisodeID As %String, PTypeID As %String) As %Query(ROWSPEC = "ARowID:%String,AMRADMRowId:%String,ADiaSubID:%String,ADiagnosTypeID:%String,ADiagnosType:%String,AICDID:%String,ADiagnosName:%String,ADemo:%String,AEvaluation:%String,AEvaluationDesc:%String,AICDCode:%String,AEffects:%String,AEffectsDesc:%String,ALevel:%String,ASquence:%String,AUserName:%String,ADateTime:%String")
{
}

ClassMethod GetMRDiagnosListExecute(ByRef qHandle As %Binary, PEpisodeID As %String, PTypeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    s MRADMRowId = $p($g(^PAADM(PEpisodeID)),"^",61)
    q:(MRADMRowId = "") $$$OK
	s DiaSubID = "0" 
	for {
	   s DiaSubID = $o(^MR(MRADMRowId,"DIA",DiaSubID))
	   q:(DiaSubID = "")
	   //诊断类型
	   s TypeID = $g(^MR(MRADMRowId,"DIA",DiaSubID,"TYP",1))
	   continue:((PTypeID '= TypeID) && (PTypeID '= "") && (PTypeID '= $c(0)))  
	   s TypeDesc = ""
	   s:(TypeID '="") TypeDesc = $p($g(^MRC("DTYP",TypeID)),"^",2)
	   //诊断
	   s ICDID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",1)
	   s ICDDesc = ""
	   s ICDCode = ""
	   if (ICDID '= "")&&(ICDID '= $c(0))
	   {
	       s ICDDesc = $p(^MRC("ID",ICDID),"^",2)
	       s ICDCode = $p(^MRC("ID",ICDID),"^",4)
	   }
	   //非ICD
	   s DemoDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	   if (($d(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))'=0) && (ICDDesc = ""))
	   { 
	       s ICDDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	       s ICDCode = "99999" 
	   }
	   //级别
	   s Level = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",1)
	   //顺序
	   s Sequence = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",2)
	   
	   if $d(^MR(MRADMRowId,"DIA",DiaSubID,"EPR"))'=0
	   {
	      s EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",3)
          s EffectsID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",4)
	   }
	   else 
	   {
		   s EvaluationID = ""
		   s EffectsID =""
	   }
	   //状态属性
       s EvaluationDesc =""
       if (EvaluationID '="") && (EvaluationID '="0") {s EvaluationDesc =$p($g(^MRC("DSTAT",EvaluationID)),"^",2)}
       //转归属性
       s EffectsDesc = ""
       if (EffectsID '= "") && (EffectsID '= "0") {s EffectsDesc = $Li($g(^DHCEPRM.CustomDictionaryD(EffectsID)),4)}
	   //日期时间
	   s Date = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",7)
	   s:(Date '= "") Date = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(Date)
	   s Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
	   s:(Time '="") Time = $ZT(Time)
	   s DateTime = Date_" "_Time
	   //医生
	   s UserID =  $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",12)
	   s:(UserID '="") UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	   
	   s RowID=MRADMRowId_"||"_DiaSubID
	   
	   s data = $lb(RowID,MRADMRowId,DiaSubID,TypeID,TypeDesc,ICDID,ICDDesc,DemoDesc,EvaluationID,EvaluationDesc,ICDCode,EffectsID,EffectsDesc,Level,Sequence,UserName,DateTime)
	   s ^CacheTemp(repid,ind) = data
	   s ind=ind+1  	 
	} 
	Quit $$$OK
}

ClassMethod GetMRDiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRDiagnosListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRDiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRDiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
