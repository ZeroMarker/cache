Import sqluser

/// table: Mr_diagnos 
/// Globle:^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub},"EPR")=Level^Sequence^DiagnosticEvaluation^TherapeuticEffects
/// Creator:Candyxu
/// Date:20111027
Class EPRservice.BLL.MRDiagnos.BLMRDiagnosData Extends %RegisteredObject [ ProcedureBlock ]
{

/// 获得MR_Adm RowID
ClassMethod GetMRADMID(AEpisodeID As %String) As %String
{
	//20120917 wangwentao add
	q:(AEpisodeID="") ""
	s MRADMID=$p($g(^PAADM(AEpisodeID)),"^",61)
    q MRADMID
	/*
    &sql(SELECT MRADM_RowId
         into :MRADMID 
         FROM MR_Adm 
         Where MRADM_ADM_DR=:AEpisodeID)
    */
}

/// Creator：      Candy
/// CreateDate：   2011-10-27
/// Description:： According to PEpisodeID search for MRDiagnos List
/// Table： MR_Diagnos
/// Input： PEpisodeID
/// Output：ARowID:诊断ID,AMRADMRowId,ADiaSubID,ADiagnosTypeID:类型ID,ADiagnosType:类型名称,
///         AIcdID:诊断ICDID,ADiagnosName:诊断名称,ADemo:备注,AEvaluation:状态属性,
///         AEvaluationDesc:状态属性名称,ICDCode 诊断代码,AEffects:转归属性,AEffectsDesc:转归属性名称,
///         ALevel:级别,ASquence:顺序,AUserName:医生,ADateTime:时间
/// Others：do ##class(%ResultSet).RunQuery("EPRservice.BLL.MRDiagnos.BLMRDiagnosData","GetMRDiagnosList","50729","2")
Query GetMRDiagnosList(PEpisodeID As %String, PTypeID As %String) As %Query(ROWSPEC = "ARowID:%String,AMRADMRowId:%String,ADiaSubID:%String,ADiagnosTypeID:%String,ADiagnosType:%String,AICDID:%String,ADiagnosName:%String,ADemo:%String,AEvaluation:%String,AEvaluationDesc:%String,AICDCode:%String,AEffects:%String,AEffectsDesc:%String,ALevel:%String,ASquence:%String,AUserName:%String,ADateTime:%String")
{
}

ClassMethod GetMRDiagnosListExecute(ByRef qHandle As %Binary, PEpisodeID As %String, PTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    set MRADMRowId=..GetMRADMID(PEpisodeID)
    if MRADMRowId=""  Quit $$$OK
	set DiaSubID = "0" 
	for {
	   set DiaSubID=$o(^MR(MRADMRowId,"DIA",DiaSubID))
	   quit:(DiaSubID = "")
	   //诊断类型
	   set TypeID = $g(^MR(MRADMRowId,"DIA",DiaSubID,"TYP",1))
	   continue:((PTypeID '= TypeID) && (PTypeID '= "") && (PTypeID '= $c(0)))  
	   set TypeDesc = ""
	   if TypeID '=""  set TypeDesc = $p($g(^MRC("DTYP",TypeID)),"^",2)
	   //诊断
	   set ICDID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",1)
	   set ICDDesc = ""
	   set ICDCode = ""
	   if (ICDID '= "")&&(ICDID '= $c(0))
	   {
	       set ICDDesc = $p(^MRC("ID",ICDID),"^",2)
	       set ICDCode = $p(^MRC("ID",ICDID),"^",4)
	   }
	   //非ICD
	   set DemoDesc = ""
	   if (($d(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))'=0) && (ICDDesc = ""))
	   { 
	       set ICDDesc = $g(^MR(MRADMRowId,"DIA",DiaSubID,"DES",1))
	       set ICDCode = "99999" 
	   }
	   //级别
	   set Level = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",1)
	   if (Level = ""){set Level = 1}  else{ For i=1:1:(Level-1) {s ICDDesc = "   "_ICDDesc}}
	   //顺序
	   set Sequence = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",2)
	   
	   if $d(^MR(MRADMRowId,"DIA",DiaSubID,"EPR"))'=0
	   {
	      set EvaluationID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",3)
          set EffectsID = $p($g(^MR(MRADMRowId,"DIA",DiaSubID,"EPR")),"^",4)
	   }
	   else 
	   {
		   set EvaluationID = ""
		   set EffectsID =""
	   }
	   //状态属性
       set EvaluationDesc =""
       if (EvaluationID '="") && (EvaluationID '="0") {set EvaluationDesc =$p($g(^MRC("DSTAT",EvaluationID)),"^",2)}
       //转归属性
       set EffectsDesc = ""
       if (EffectsID '= "") && (EffectsID '= "0") {set EffectsDesc = $Li($g(^DHCEPRM.CustomDictionaryD(EffectsID)),4)}
	   //日期时间
	   set Date = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",7)
	   if Date '= "" set Date = $ZD(Date,3)
	   set Time = $p($g(^MR(MRADMRowId,"DIA",DiaSubID)),"^",8)
	   if Time '="" set Time = $ZT(Time,3)
	   set DateTime = Date_" "_Time
	   //医生
	   set UserID =  $p(^MR(MRADMRowId,"DIA",DiaSubID),"^",12)
	   if UserID '="" set UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
	   
	   set RowID=MRADMRowId_"||"_DiaSubID
	   
	   set data = $lb(RowID,MRADMRowId,DiaSubID,TypeID,TypeDesc,ICDID,ICDDesc,DemoDesc,EvaluationID,EvaluationDesc,ICDCode,EffectsID,EffectsDesc,Level,Sequence,UserName,DateTime)
	   set ^CacheTemp(repid,ind)=data
	   set ind=ind+1  	 
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

/// Desc: 获得诊断类型
/// output: 诊断类型列表
Query SelectDiagnosType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Desc:%String", SELECTMODE = "RUNTIME") [ SqlName = SELECT_DIAGNOSTYPE, SqlProc ]
{
    SELECT DTYP_RowId,DTYP_Desc FROM MRC_DiagnosType
}

/// Desc: 诊断类型、转归类型、状态类型
/// output:诊断类型、转归类型、状态类型列表
Query SelectDiagnosTypes() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Desc:%String:%String,Type:%String", SELECTMODE = "RUNTIME") [ SqlName = SELECT_DIAGNOSTYPES, SqlProc ]
{
   SELECT ID,CtmDictCode,CtmDictDesc,CtmDictType FROM EPRmeta.CustomDictionary where (CtmDictType='TherapeuticEffects') 
   union SELECT DTYP_RowId as ID,DTYP_Code as CtmDictCode,DTYP_Desc as CtmDictDesc,'DiagnosType'as CtmDictType FROM MRC_DiagnosType 
   union SELECT DSTAT_RowId AS ID, DSTAT_Code AS CtmDictCode, DSTAT_Desc AS CtmDictDesc,'DiagnosticEvaluation'as CtmDictType FROM MRC_DiagnosStatus
}

/// Desc: 保存级别、顺序 [AResult(RowID(MEDIAref,SubID),Evaluation,Effects,Level,sequnece,IcdID,IcdDesc),AUserID当前用户]
/// Debug: do ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).SaveDiagnos("201876^30^1^0^1&201876^31^2^1^5","3928")
ClassMethod SaveDiagnos(AResult As %String, AUserID As %String)
{
	set RowCount = $LENGTH(AResult,"&")
	quit:(RowCount <=0) 
    for I=  1 :1:RowCount
    {
        set MRDIAref=$p($p(AResult,"&",I),"^",1)
	    set SubID=$p($p(AResult,"&",I),"^",2)
		set Level=$p($p(AResult,"&",I),"^",3)
		set Sequence=$p($p(AResult,"&",I),"^",4)
		if (MRDIAref'="") && (SubID'="")
		{
          set $p(^MR(MRDIAref,"DIA",SubID,"EPR"),"^",1)=Level
          set $p(^MR(MRDIAref,"DIA",SubID,"EPR"),"^",2)=Sequence
	      set $p(^MR(MRDIAref,"DIA",SubID),"^",12) = AUserID
	      set $p(^MR(MRDIAref,"DIA",SubID),"^",7) = $p($h,",",1)
	      set $p(^MR(MRDIAref,"DIA",SubID),"^",8) = $p($h,",",2)          
		}
     }
}

/// Desc: 添加或修改诊断记录
/// Input: AEpsodeID^ADiagnosID^ASubID^AType^AIcdID^AIcdDesc^AEvaluation^AEffect^AUserID^ALevel
/// Debug: d ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).UpdateOrInsertDiagnos("50729","50729","115","1","4","霍乱轻型","1","57","105","1")
ClassMethod UpdateOrInsertDiagnos(AEpsodeID As %String, ADiagnosID As %String, ASubID As %String, AType As %String, AIcdID As %String, AIcdDesc As %String, AEvaluation As %String, AEffect As %String, AUserID As %String, ASequence As %String) As %String
{
	//s ^TTCandyxu=AEpsodeID_"^"_ADiagnosID_"^"_ASubID_"^"_AType_"^"_AIcdID_"^"_AIcdDesc_"^"_AEvaluation_"^"_AEffect_"^"_AUserID
	set IsExist = "F"
	if (ADiagnosID = $c(0)) || (ADiagnosID = "")
	{
		set IsExist = ..IsICDExistInDiagnos(AEpsodeID,AIcdDesc,AType)
		//添加诊断记录
		if IsExist = "F"
		{
		    set MRDIAID = ..CMSaveDiagnos(AEpsodeID,AType,AIcdID,AIcdDesc,AUserID,"1",ASequence,AEvaluation,AEffect,"")	
		}
		else
		{
			set MRDIAID = "0"
		}
	}                               
	else
	{
		//修改诊断记录
	    set MRDIAID = ADiagnosID_"||"_ASubID
	    set MrIcdID = $p(^MR(ADiagnosID,"DIA",ASubID),"^",1)
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",1) = AIcdID
	    if ( AIcdID '= "")&&(AIcdID '= $c(0)) 
	    {
		   set ^MR(ADiagnosID,"DIA",ASubID,"DES",1) = " "
	    }
		else
		{
		   set ^MR(ADiagnosID,"DIA",ASubID,"DES",1) = AIcdDesc
		} 
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",12) = AUserID
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",7) = $p($h,",",1)
	    set $p(^MR(ADiagnosID,"DIA",ASubID),"^",8) = $p($h,",",2)
	    set ^MR(ADiagnosID,"DIA",ASubID,"TYP",1) = AType
	    if (AEvaluation=$c(0)) || (AEvaluation = "") set AEvaluation = ""
	    if (AEffect=$c(0)) || (AEffect = "") set AEffect = ""	   
        set $P(^MR(ADiagnosID,"DIA",ASubID,"EPR"),"^",3)= AEvaluation
        set $P(^MR(ADiagnosID,"DIA",ASubID,"EPR"),"^",4)= AEffect
	}
	//判断疾病上报
	set SeriousDisease = ##class(DHCMed.EPDService.Service).CheckDiagnosToEpd(AEpsodeID)
	set SeriousDiseaseMeg = ""
	if SeriousDisease '= ""
	{
		set RowCount = $LENGTH(SeriousDisease,";")
        for I=  1 :1:RowCount
        {
	        s RetCode = $p($p(SeriousDisease,";",I),"^",1)
	        if (RetCode = "1"){ s SeriousDiseaseMeg = $p(SeriousDisease,";",I) q}
	    }
	}
	q MRDIAID_"&"_SeriousDiseaseMeg_"&"_IsExist
}

/// Desc: 删除诊断记录
/// input: AMRID,SubID 诊断ID
/// output: 0失败，1成功
/// Debug: d ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).DiagnosDelete(AMRID,SubID)
ClassMethod DiagnosDelete(AMRID As %String, SubID As %String) As %String
{
   s Flag = "0"
   q:((AMRID="")||(SubID=""))
   s RowID = AMRID_"||"_SubID
   &sql(delete from mr_diagnos where MRDIA_RowId = :RowID)
   s Flag = "1"
   q Flag
}

/// Desc: 复制目前诊断
/// Input: AResult 以"^"分隔 诊断代码^级别^备注,AType 类型,AEpsodeID 就诊号, AUserID 用户ID
/// do ##class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).PrensetDiagnosCopyed("5","1","50729","105")
ClassMethod PrensetDiagnosCopyed(ApresentType As %String, AType As %String, AEpsodeID As %String, AUserID As %String)
{
	Set ds = ##Class(%Library.ResultSet).%New("EPRservice.BLL.MRDiagnos.BLMRDiagnosData:GetMRDiagnosList")
 	Do ds.Execute(AEpsodeID,ApresentType)
 	Set I=1
 	While(ds.Next())
 	{
	 	s IcdID = ds.Data("AICDID")
	 	s LevelID = ds.Data("ALevel")
	 	s TempIcdDesc = ds.Data("ADiagnosName")
	 	s IcdDesc = $tr(TempIcdDesc," ","")
	 	s Demo = ds.Data("ADemo")
	 	s EvaluationID = ds.Data("AEvaluation")
	 	s AEffectID = ds.Data("AEffects")
	 	d ..CMSaveDiagnos(AEpsodeID,AType,IcdID,IcdDesc,AUserID,LevelID,I,EvaluationID,AEffectID,Demo)
	 	s I = I+1
	}
}

/// Desc: 保存为当前诊断
/// input: AResult As %String, EpsodeID As %String, AUserID As %String
/// Debug: do ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).SaveAsPresentDiagnos("50729^50^1^0^7^","50729","105")
ClassMethod SaveAsPresentDiagnos(AResult As %String, EpsodeID As %String, AUserID As %String)
{
    q:(EpsodeID = "")||(EpsodeID = $c(0))
	set RowCount = $LENGTH(AResult,"&")
	q:(RowCount <= 0)
	set TypeRowID = "0"
    for {
	   set TypeRowID = $o(^MRC("DTYP",TypeRowID))
	   q:(TypeRowID = "")
	   q:($p(^MRC("DTYP",TypeRowID),"^",1) = "CURRENT")
	}
	set MRADMRowId = ..GetMRADMID(EpsodeID)
	set DiaSubID = 0
	for {
		set DiaSubID = $o(^MR(MRADMRowId,"DIA",DiaSubID))
		q:DiaSubID=""
		set DiaType = $g(^MR(MRADMRowId,"DIA",DiaSubID,"TYP",1))
		if (DiaType = TypeRowID) {d ..DiagnosDelete(MRADMRowId,DiaSubID)}
	} 
	for I=  1 :1:RowCount
    {	
		set Level = $p($p(AResult,"&",I),"^",3)		  
	    set IcdID = $p($p(AResult,"&",I),"^",5)
		set Demo = $p($p(AResult,"&",I),"^",6)
		set Evaluation = $p($p(AResult,"&",I),"^",7)
		set Effects = $p($p(AResult,"&",I),"^",8)
		set ICDDesc = $p($p(AResult,"&",I),"^",9)
		set ID = ..CMSaveDiagnos(EpsodeID,TypeRowID,IcdID,ICDDesc,AUserID,Level,I,Evaluation,Effects,Demo)            
	}
}

/// Desc: 保存诊断数据
/// Input: AEpsodeID就诊号^AType类型^AIcdID就诊代码^AIcdDesc就诊描述^AUserID用户^ALevel级别^ASequence顺序^AEvaluationID转归属性^AEffect类型属性
/// OutPut: 诊断表的 RowID 
/// Debug: do ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).CMSaveDiagnos("77128","2","-1","main","105","1","","1","57")
ClassMethod CMSaveDiagnos(AEpsodeID As %String, AType As %String, AIcdID As %String, AIcdDesc As %String, AUserID As %String, ALevel As %String, ASequence As %String, AEvaluationID As %String, AEffect As %String, ADemo As %String) As %String
{
	set RowID = "0"
	set MrAdmID= ..GetMRADMID(AEpsodeID)
	set objMRDiagnos=##Class(User.MRDiagnos).%New(MrAdmID)
    do objMRDiagnos.MRDIAMRADMParRefSetObjectId(MrAdmID)
    if (AIcdID '= $c(0)) && (AIcdID '="")  do objMRDiagnos.MRDIAICDCodeDRSetObjectId(AIcdID)
 	set objMRDiagnos.MRDIADate=$p($h,",",1)
	set objMRDiagnos.MRDIATime=$p($h,",",2)
	Do objMRDiagnos.MRDIAUpdateUserDRSetObjectId(AUserID)
	set objMRDiagnos.MRDIAUpdateDate=$p($h,",",1)
	set objMRDiagnos.MRDIAUpdateTime=$p($h,",",2)
	Do objMRDiagnos.MRDIAUserCreatedDRSetObjectId(AUserID)	
    if (AUserID'="") && (AUserID'=$c(0)) 
    {
       set CTPCPRowId=$P($g(^SSU("SSUSR",AUserID)),"^",14)
       if CTPCPRowId'="" Do objMRDiagnos.MRDIADocCodeDRSetObjectId(CTPCPRowId)
    }
    if (objMRDiagnos.%Save())
	{ 
	   set RowID = objMRDiagnos.%Id()
	   set SubID = $p(RowID,"||",2)
       if (AIcdID =$c(0)) || (AIcdID ="") set ^MR(MrAdmID,"DIA",SubID,"DES",1) = AIcdDesc
	   if (AEvaluationID = $c(0)) set AEvaluationID=""
	   if (AEffect = $c(0)) || (AEffect = "")  set AEffect=""
	   if (ALevel = $c(0)) || (ALevel = "")  set ALevel = "1"
	   if (ASequence = $c(0)) || (ASequence = "") set ASequence=SubID	   
	   set ^MR(MrAdmID,"DIA",SubID,"EPR") = ALevel_"^"_SubID_"^"_AEvaluationID_"^"_AEffect
       set ^MR(MrAdmID,"DIA",SubID,"TYP",0) = 1
       set ^MR(MrAdmID,"DIA",SubID,"TYP",1) = AType
       if (ADemo '= $c(0)) && (ADemo '="")  set ^MR(MrAdmID,"DIA",SubID,"DES",1) =ADemo
	} 
   d objMRDiagnos.%Close()    
   q RowID
}

/// Desc:判断就诊表中是否下过AICDDesc这个诊断
/// debug: w ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).IsICDExistInDiagnos(50729,"霍乱轻型",1)
ClassMethod IsICDExistInDiagnos(AEpisodeID As %String, AICDDesc As %String, ATypeID As %String) As %Boolean
{
	set AMRADMRowId = ..GetMRADMID(AEpisodeID)
	s MRSubID = "0" , Result = "F"
	for {
		 s MRSubID = $o(^MR(AMRADMRowId,"DIA",MRSubID))
		 q:(MRSubID = "")
		 s ICDID = $p($g(^MR(AMRADMRowId,"DIA",MRSubID)),"^",1)
		 i (ICDID '= "")&&(ICDID '= $c(0)){ set ICDDesc = $p(^MRC("ID",ICDID),"^",2)}else{set ICDDesc = $g(^MR(AMRADMRowId,"DIA",MRSubID,"DES",1))}
		 s TypeID = $g(^MR(AMRADMRowId,"DIA",MRSubID,"TYP",1))
		 i ((ICDDesc = AICDDesc)&&(TypeID = ATypeID)) 
		 {
			 s Result = "T"
			 q
		 }
    }
    q Result
}

//desc: 查找icd

//do ##class(%ResultSet).RunQuery("EPRservice.BLL.MRDiagnos.BLMRDiagnosData","GetICDDX","h")

Query GetICDDX(PQueryText As %String) As %Query(ROWSPEC = "ARowID:%String,ADesc:%String,ACode:%String")
{
}

ClassMethod GetICDDXExecute(ByRef qHandle As %Binary, PQueryText As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
 	set Flag = "False"
 	set i = 0
 	set MaxRecord = 20 	
 	set PQueryText = $ZCVT(PQueryText,"U")
 	if $D(^MRC("ID",0,"ALIAS",PQueryText)) '= 0
 	{
	  	set TempText = PQueryText	
	}
	else
	{
		set TempText = $o(^MRC("ID",0,"ALIAS",PQueryText))
	}
 	for {
	 	quit:((TempText = "") ||(TempText '[ PQueryText))
	 	set Flag = "True"
	 	set AliasRowID = "0"
	 	for {
		 	quit:(i > MaxRecord)
		 	set AliasRowID =  $o(^MRC("ID",0,"ALIAS",TempText,AliasRowID))
		 	quit:(AliasRowID = "")
		 	
		 	set RowID = AliasRowID
		 	set Desc = $p(^MRC("ID",AliasRowID),"^",2)
		 	set Code = $p(^MRC("ID",AliasRowID),"^",4)
		 	do setDataName
		}
		set TempText = $o(^MRC("ID",0,"ALIAS",TempText))
	}
	if Flag = "False"
	{
	   if $D(^MRC("ID",0,"Desc",PQueryText)) '= 0
 	   {
	  	   set TempText = PQueryText	
	   }
	   else
	   {
		   set TempText = $o(^MRC("ID",0,"Desc",PQueryText))
	   }
 	   for {
	 	   quit:((TempText = "") ||(TempText '[ PQueryText))
	 	   set ICDRowID = "0"
	 	   for {
		 	   quit:(i > MaxRecord)
		 	   set ICDRowID = $o(^MRC("ID",0,"Desc",TempText,ICDRowID))
		 	   quit:(ICDRowID = "")
		 	   
	 	       set RowID = ICDRowID
		       set Desc = $p(^MRC("ID",ICDRowID),"^",2)
		       set Code = $p(^MRC("ID",ICDRowID),"^",4)
		       do setDataName
	 	   }
	       set TempText = $o(^MRC("ID",0,"Desc",TempText)) 
	   }
	}
	Quit $$$OK
setDataName
  set data = $lb(RowID,Desc,Code)
  set ^CacheTemp(repid,ind) = data
  set ind = ind + 1
  set i = i + 1
}

ClassMethod GetICDDXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDDXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDDXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDDXExecute ]
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

}
