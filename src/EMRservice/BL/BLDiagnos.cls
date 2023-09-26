Import sqluser

/// 资源区诊断引用
Class EMRservice.BL.BLDiagnos Extends (%RegisteredObject, %XML.Adaptor)
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
	   s:(Date '= "") Date = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(Date,"date") //$ZD(Date,3)
	   s Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
	   s:(Time '="") Time = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(Time,"time") //$ZT(Time)
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
/// 			ADiagnosOnsetDate:发病日期
/// 			ATypeClassID:诊断分类ID
/// 			ATypeClass:诊断分类（中医、西医、证型）
/// 			AMainDiagFlag:是否主诊断
/// Others：do ##class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnos","GetMRDiagnosListNew","134002","")
Query GetMRDiagnosListNew(PEpisodeID As %String, PTypeID As %String) As %Query(ROWSPEC = "ARowID:%String,AMRADMRowId:%String,ADiaSubID:%String,ADiagnosTypeID:%String,ADiagnosType:%String,AICDID:%String,ADiagnosName:%String,ADemo:%String,AEvaluation:%String,AEvaluationDesc:%String,AICDCode:%String,AEffects:%String,AEffectsDesc:%String,ALevel:%String,ASquence:%String,AUserName:%String,ADateTime:%String,ADiagnosOnsetDate:%String,ATypeClassID:%String,ATypeClass:%String,AMainDiagFlag:%String")
{
}

ClassMethod GetMRDiagnosListNewExecute(ByRef qHandle As %Binary, PEpisodeID As %String, PTypeID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    s MRADMRowId = $p($g(^PAADM(PEpisodeID)),"^",61)
    q:(MRADMRowId = "") $$$OK
    k TempArr("EMRDiagnos",$J)
	s DiaSubID = "0" for {
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
	   if (ICDID '= "")&&(ICDID '= $c(0)) {
	       s ICDDesc = $p(^MRC("ID",ICDID),"^",2)
	       s ICDCode = $p(^MRC("ID",ICDID),"^",4)
	   }
	   //非ICD
	   s DemoDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	   if (($d(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))'=0) && (ICDDesc = "")) { 
	       s ICDDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	       s ICDCode = "99999" 
	   }
	   //级别
	   s Level = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",1)
	   //顺序
	   s Sequence = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",2)
	   if Sequence="" s Sequence=$g(^MR(3,"DIA",0))+1
	   if $d(^MR(MRADMRowId,"DIA",DiaSubID,"EPR"))'=0 {
		   //标准版数据变更存储位置
	      //s EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",3)
	      s EvaluationID =  $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",9)
          s EffectsID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",4)
	   }else{
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
	   s:(Date '= "") Date = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(Date,"date") //$ZD(Date,3)
	   s Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
	   s:(Time '="") Time = ##class(EMRservice.Util.DateTimeFormat).GetHisDateTimeFormat(Time,"time") //$ZT(Time)
	   s DateTime = Date_" "_Time
	   //医生
	   s UserID =  $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",12)
	   s:(UserID '="") UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	   s RowID=MRADMRowId_"||"_DiaSubID
	   //发病日期
		s DIAOnsetDate=$P($G(^MR(MRADMRowId,"DIA",DiaSubID)),"^",35) //取发病日期
		s:DIAOnsetDate'="" DIAOnsetDate=$zd(DIAOnsetDate,3) //取发病日期
	   //
	   s BillFlag1="",BillFlag3="",DiagnosCat=""
	   i ICDID'="" {
			s BillFlag1=$P($G(^MRC("ID",ICDID)),"^",13)
			s BillFlag3=$P($g(^MRC("ID",ICDID)),"^",15)
			i BillFlag3'="Y" s DiagnosCat="西医"
			else  if (BillFlag3="Y")&&(BillFlag1'="Y") s DiagnosCat="中医"
			else  s DiagnosCat="证候"
	   }else{
			s Questionnaire=$P($G(^MR(MRADMRowId,"DIA",DiaSubID)),"^",22)
			i Questionnaire=1 s DiagnosCat="西医"
			else  if (Questionnaire=2) s DiagnosCat="中医"
			else  if (Questionnaire=3) s DiagnosCat="证候"
	   }
	   s MainDiagFlag=$p($g(^MR(MRADMRowId,"DIA",DiaSubID,1)),"^",20)
	   i MainDiagFlag="Y" s MainDiagFlag="是"
	   e  s MainDiagFlag="否"
	   //
	   s TempArr("EMRDiagnos",$j,Sequence,DiaSubID)=RowID_"^"_MRADMRowId_"^"_DiaSubID_"^"_TypeID_"^"_TypeDesc_"^"_ICDID_"^"_ICDDesc_"^"_DemoDesc_"^"_EvaluationID_"^"_EvaluationDesc_"^"_ICDCode_"^"_EffectsID_"^"_EffectsDesc_"^"_Level_"^"_Sequence_"^"_UserName_"^"_DateTime_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MainDiagFlag
	}
   //按顺序输出设置
	s TempDia=""
	s ret=""
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("EMRDiagnos",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s RowID=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",1)
			s MRADMRowId=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",2)
			s DiaSubID=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",3)
			s TypeID=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",4)
			s TypeDesc=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",5)
			s ICDID=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",6)
			s ICDDesc=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",7)
			s DemoDesc=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",8)
			s EvaluationID=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",9)
			s EvaluationDesc=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",10)
			s ICDCode=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",11)
			s EffectsID=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",12)
			s EffectsDesc=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",13)
			s Level=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",14)
			s Sequence=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",15)
			s UserName=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",16)			
			s DateTime=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",17)
			s DIAOnsetDate=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",18)
			s DiagnosCat=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",19)
			s MainDiagFlag=$p(TempArr("EMRDiagnos",$j,DiagnosNumber,Temprowid),"^",20)
			s data = $lb(RowID,MRADMRowId,DiaSubID,TypeID,TypeDesc,ICDID,ICDDesc,DemoDesc,EvaluationID,EvaluationDesc,ICDCode,EffectsID,EffectsDesc,Level,Sequence,UserName,DateTime,DIAOnsetDate,DiagnosCat,DiagnosCat,MainDiagFlag)
			s ^CacheTemp(repid,ind) = data
			s ind=ind+1
		}
	}
	k TempArr("EMRDiagnos",$j)
	Quit $$$OK
}

ClassMethod GetMRDiagnosListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRDiagnosListNewExecute ]
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

ClassMethod GetMRDiagnosListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRDiagnosListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
