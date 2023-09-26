/// 名称: DHCMed.INFService.InfAntiDicSrv
/// 描述: 基于报告表的数据常用操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-25
Class DHCMed.INFService.InfReportSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询病人感染部位的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QryInfRepPosByPaadm","58008","1")
Query QryInfRepPosByPaadm(SumID As %String = "", RepRowid As %String) As %Query(ROWSPEC = "Rowid:%String,InfRepDr:%String,InfPosDr:%String,InfPosDesc:%String,InfDate:%String,InfDiagDr:%String,InfDiagDesc:%String,InroadOprCode:%String,InroadOprDesc:%String,InfEndDate:%String,InfDays:%String,InfOprStartDate:%String,InfOprEndDate:%String,InfOprStartTime:%String,InfOprEndTime:%String,ResumeText:%String,DiagReaIDList:%String,DiagReaDesc:%String")
{
}

ClassMethod QryInfRepPosByPaadmExecute(ByRef qHandle As %Binary, SumID As %String = "", RepRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	q:SumID="" $$$OK
 	//q:RepRowid="" $$$OK
 	//s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
 	//^DHCMed.INF.ReportI("TypePaadm",{Type},{Paadm_DR}
    //q:'$d(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx)) $$$OK
    //s RepRowid=""
    //s RepRowid=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm,RepRowid))
    //q:RepRowid="" $$$OK
    // ^DHCMed.INF.SummaryI("InfRepDr"
    q:'$d(^DHCMed.INF.RepPosI("InfRepDr",SumID)) $$$OK
    s SumRowid=SumID
    //s SumRowid=$o(^DHCMed.INF.SummaryI("InfRepDr",RepRowid,SumRowid))
    q:SumRowid="" $$$OK
    //^DHCMed.INF.RepPosI("InfRepDr"   该处是关联到最顶层的表 modi 摘要
    s tmpRowid=""
    f  s tmpRowid=$o(^DHCMed.INF.RepPosI("InfRepDr",+SumRowid,tmpRowid)) q:tmpRowid=""  d
    .s objCls=##class(DHCMed.INF.RepPos).GetObjById(tmpRowid)
    .q:'$IsObject(objCls)
    .s InfDays=objCls.InfDays
    .s InfPos=objCls.InfPosCode
    .s objClsPos=##class(DHCMed.INF.InfPosition).GetObjById(InfPos) 
    .s (PosTmpID,PosDesc,DiasTmpID,DiasDesc)=""
    .s:$IsObject(objClsPos) PosTmpID=objClsPos.%Id()
    .s:$IsObject(objClsPos) PosDesc=objClsPos.InfPosition
    .s objClsInfDia=##class(DHCMed.INF.InfDiagnose).GetObjById(objCls.InfDiagDR)
    .//
    .s:$IsObject(objClsInfDia) DiasTmpID=objClsInfDia.%Id()
    .s:$IsObject(objClsInfDia) DiasDesc=objClsInfDia.DiseaseName
    .s InroadOprDr="", InroadOprDesc=""
    .s:objCls.InroadOpr'="" InroadOprDr=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(objCls.InroadOpr,"InfectionDestructiveOperation")
    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(InroadOprDr)
    .s:$IsObject(objDic) InroadOprDesc=objDic.Description
    .s InfDate="",InfEndDate="",InfOprStartDate="",InfOprStartTime="",InfOprEndDate="",InfOprEndTime=""
    .s:+objCls.InfDate'=0 InfDate=$zd(+objCls.InfDate,3)    //InfEndDate
    .s:+objCls.InfEndDate'=0 InfEndDate=$zd(+objCls.InfEndDate,3)
    .s:+objCls.InfOprStartDate'=0 InfOprStartDate=$zd(+objCls.InfOprStartDate,3)
    .s:+objCls.InfOprEndDate'=0 InfOprEndDate=$zd(+objCls.InfOprEndDate,3)
    .s:+objCls.InfOprStartTime'=0 InfOprStartTime=$zt(+objCls.InfOprStartTime,1)
    .s:+objCls.InfOprEndTime'=0 InfOprEndTime=$zt(+objCls.InfOprEndTime,1)
    .s DiagReaIDList=""   //objCls.DiagReaIDList
    .s DiagReaDesc=""
    .i DiagReaIDList'="" d
    ..f i=01:1:$l(DiagReaIDList,"*") d
    ...s DiagReaID=$p(DiagReaIDList,"*",i)
    ...i DiagReaID'="" d
    ....q:'$d(^DHCMed.INF.InfDiagnoseReaD(DiagReaID))
    ....s ReaObj=##class(DHCMed.INF.InfDiagnoseRea).GetObjById(DiagReaID)
    ....q:'$IsObject(ReaObj)
    ....s ReaDesc=ReaObj.ReaDesc
    ....i DiagReaDesc'="" d
    .....s DiagReaDesc=DiagReaDesc_";"_ReaDesc
    ....e  d
    .....s DiagReaDesc=ReaDesc
    .s Data=$lb("")
    .s $li(Data,1)=tmpRowid
    .s $li(Data,2)=SumRowid
    .s $li(Data,3)=PosTmpID
    .s $li(Data,4)=PosDesc
    .s $li(Data,5)=InfDate  
    .s $li(Data,6)=DiasTmpID
    .s $li(Data,7)=DiasDesc
    .s $li(Data,8)=objCls.InroadOpr     //code
    .s $li(Data,9)=InroadOprDesc
    .s $li(Data,10)=InfEndDate
    .s $li(Data,11)=InfDays
    .s $li(Data,12)=InfOprStartDate
    .s $li(Data,13)=InfOprEndDate
    .s $li(Data,14)=InfOprStartTime
    .s $li(Data,15)=InfOprEndTime
    .s $li(Data,16)=objCls.ResumeText
    .;add by lyh for 添加诊断依据信息
    .s $li(Data,17)=DiagReaIDList
    .s $li(Data,18)=DiagReaDesc
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QryInfRepPosByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfRepPosByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfRepPosByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfRepPosByPaadmExecute ]
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

/// Creator：     ChenJB
/// CreatDate：   2010-05-19
/// Description:  查询感染报告ID
/// Table：       DHCMed.INF.Report
/// Input：       Paadm ： 就诊 TypeCode:报告类型code
/// output:       符合条件的ID            
/// Return：      
/// w ##class(DHCMed.INFService.InfReportSrv).GetReportID("58008","1")
ClassMethod GetReportID(Paadm As %String = "", TypeCode As %String = "") As %String
{
	n (Paadm,TypeCode)
	s ret=""
	q:Paadm="" ret
 	q:TypeCode="" ret
 	s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
 	//^DHCMed.INF.ReportI("TypePaadm",{Type},{Paadm_DR}
    q:'$d(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx)) ret
    s ret=""
    s ret=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCodeIdx,Paadm,ret))
    q ret
}

/// Creator：     陈剑波
/// CreatDate：   2010-05-28
/// Description:  查询所有的易感因素字典，追加几个可编辑的字段
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QryRepInfReason",51104,1)
Query QryRepInfReason(Paadm As %String, TypeCode As %String, InfRepDr As %String = "") As %Query(ROWSPEC = "myid:%String,Code:%String,Description:%String,ReasonStDate:%String,ReasonEdDate:%String,ReasonStTime:%String,ReasonEdTime:%String,ResumeText:%String,checked:%String")
{
}

ClassMethod QryRepInfReasonExecute(ByRef qHandle As %Binary, Paadm As %String, TypeCode As %String, InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
    q:Paadm="" $$$OK
    q:TypeCode="" $$$OK
    //s RepID=..GetReportID(Paadm,TypeCode)
    s RepID=InfRepDr
    //q:RepID="" $$$OK
    s dicID=""
 	f  s dicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," INFECTIONDANGEROUSFACTOR",dicID)) q:+dicID=0  d
 	.s objDic=##class(DHCMed.SS.Dictionary).%OpenId(dicID)
	.q:'$IsObject(objDic)
	.q:objDic.Active'=1
	.s Code=objDic.Code
	.s CodeIdx=" "_$ZCVT(Code,"U")
	.s Description=objDic.Description
	.//w Description,!
	.s myid="",ReasonStDate="",ReasonEdDate="",ReasonStTime="",ReasonEdTime="",ResumeText="",checked=""
	.s:RepID'="" myid=$o(^DHCMed.INF.RepReasonI("RepDrInfReason",RepID,CodeIdx,0))
	.i +myid'=0  d
	..s objReason=##class(DHCMed.INF.RepReason).GetObjById(myid)
	..q:'$IsObject(objReason)
	..s checked=1
	..s ReasonStDate=objReason.ReasonStDate
	..s ReasonEdDate=objReason.ReasonEdDate
	..s ReasonStTime=objReason.ReasonStTime
	..s ReasonEdTime=objReason.ReasonEdTime
	..s ResumeText=objReason.ResumeText
	.s:ReasonStDate="" ReasonStDate=$p($h,",",1) 
    .s:ReasonEdDate="" ReasonEdDate=$p($h,",",1)
    .s:ReasonStTime="" ReasonStTime=$p($h,",",2)
    .s:ReasonEdTime="" ReasonEdTime=$p($h,",",2)
	.s:ReasonStDate'="" ReasonStDate=$zd(ReasonStDate,3) 
    .s:ReasonEdDate'="" ReasonEdDate=$zd(ReasonEdDate,3)
    .s:ReasonStTime'="" ReasonStTime=$zt(ReasonStTime,1)
    .s:ReasonEdTime'="" ReasonEdTime=$zt(ReasonEdTime,1)
    .//s ReasonStDate=""
	.s Data=$lb(myid,Code,Description,ReasonStDate,ReasonEdDate,ReasonStTime,ReasonEdTime,ResumeText,checked)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QryRepInfReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepInfReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfReasonExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-05-28
/// Description:  查询所有的感染相关模块
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output:       某一个字典项      
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QryTypeConfig","1")
Query QryTypeConfig(TypeCode As %String) As %Query(ROWSPEC = "myid:%String,Code:%String,Description:%String,checked:%String")
{
}

ClassMethod QryTypeConfigExecute(ByRef qHandle As %Binary, TypeCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
    q:TypeCode="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s dicID=""
 	f  s dicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT("InfectionPrjType","U"),dicID)) q:+dicID=0  d
 	.s objDic=##class(DHCMed.SS.Dictionary).%OpenId(dicID)
	.q:'$IsObject(objDic)
	.s Code=objDic.Code
	.s CodeIdx=" "_$ZCVT(Code,"U")
	.s Description=objDic.Description
	.//w Description,!
	.s myid="",checked=""
	.s myid=$o(^DHCMed.INF.RepConfigI("TypeCode",TypeCodeIdx,CodeIdx,0))
	.i +myid'=0  d
	..s checked=1
	.s Data=$lb(myid,Code,Description,checked)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QryTypeConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTypeConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTypeConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTypeConfigExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-06-17
/// Description:  查询某段时间内的某些报告情况
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output: D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QryRepByTypeMore","1")          
/// Return：d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QryRepByTypeMore","1","2011-06-01","2011-06-09","","","2")
Query QryRepByTypeMore(TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", Sstatus As %String = "", DateType As %String = "") As %Query(ROWSPEC = "rowid:%String,typeCode:%String,typeDesc:%String,paadm:%String,patName:%String,patLoc:%String,RepLoc:%String,patID:%String,statusDesc:%String,RepDate:%String,RepTime:%String,RepUser:%String,repLocID:%String,repStaDr:%String,DisDate:%String,DisTime:%String")
{
}

ClassMethod QryRepByTypeMoreExecute(ByRef qHandle As %Binary, TypeCode As %String = "", DateFrom As %String = "", DateTo As %String = "", cLoc As %String = "", Sstatus As %String = "", DateType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
    q:DateFrom="" $$$OK
    q:DateTo="" $$$OK
    s TypeCodeIdx=" "_$ZCVT(TypeCode,"U")
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    q:+DateFrom>+DateTo $$$OK
    s tmpDt=DateFrom-1
	
	// DateType 1:报告日期 2:出院日期
    i (DateType="")||(DateType=1) d
    .i (TypeCodeIdx'="")&(TypeCodeIdx'=" ") d
 	..f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)!(tmpDt>DateTo)  d
 	...s rowid=""
 	...f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	....s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	....q:'$IsObject(objCls)
	....s repStaDr=objCls.StatusDr
	....q:(Sstatus'="")&(Sstatus'[repStaDr)
	....s typeCode=objCls.Type
	....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(typeCode,"InfectionType")
	....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	....s typeDesc=""
	....i $IsObject(objDic)  d
	.....s typeDesc=objDic.Description
	.....k objDic
	....s paadm=objCls.PaadmDR
	....s DisDate=$p($g(^PAADM(paadm)),"^",17)
	....q:(Sstatus["101")&(DisDate'="")&(objCls.RepDate>DisDate)	//报告日期大于出院日期为漏报
	....s DisTime=$p($g(^PAADM(paadm)),"^",18)
	....s:DisDate'="" DisDate=$zd(DisDate,3)
	....s:DisTime'="" DisTime=$zt(DisTime,1)
	....s patName=""
	....s patLoc=""
	....s repLoc=""
	....s patID=""
	....s userID=objCls.UserDR
	....s RepUser=""
	....i userID'="" d
	.....s objUser=##class(DHCMed.Base.SSUser).GetObjById(userID)
	.....s:$IsObject(objUser) RepUser=objUser.Name
	....s statusDesc=""
	....s RepDate=objCls.RepDate
	....s RepTime=objCls.RepTime
	....s:+RepDate'=0 RepDate=$zd(+RepDate,3)
	....s:+RepTime'=0 RepTime=$zt(+RepTime,1)
	....i repStaDr'="" d
	.....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(repStaDr,"InfectionReportStatus")
	.....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	.....s:$IsObject(objDic) statusDesc=objDic.Description
	....s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	....i $IsObject(objPaadm)  d
	.....s patLoc=objPaadm.Department
	.....s patID=objPaadm.PatientID
	.....s objPat=##class(DHCMed.Base.Patient).GetObjById(patID)
	.....i $IsObject(objPat)  d
	......s patName=objPat.PatientName
	......k objPat
	.....k objPaadm
	....s repLocID=objCls.CtLoc
	....q:(cLoc'="")&(cLoc'=repLocID)
	....s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(repLocID)
	....i $IsObject(objLoc) d
	.....s repLoc=objLoc.Descs
	.....k objLoc
	....s Data=$lb(rowid,typeCode,typeDesc,paadm,patName,patLoc,repLoc,patID,statusDesc,RepDate,RepTime,RepUser,repLocID,repStaDr,DisDate,DisTime)
    ....s ^CacheTemp(repid,ind)=Data
    ....s ind=ind+1
    
    .e  d
    ..s TypeCodeIdx=""
    ..f  s TypeCodeIdx=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx)) q:TypeCodeIdx=""  d
 	...s tmpDt=DateFrom-1
 	...f  s tmpDt=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt)) q:(tmpDt<+DateFrom)||(tmpDt>DateTo)||(tmpDt="")  d
 	....s rowid=""
 	....f  s rowid=$o(^DHCMed.INF.ReportI("TypeDate",TypeCodeIdx,tmpDt,rowid)) q:rowid=""  d
 	.....s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
	.....q:'$IsObject(objCls)
	.....s repStaDr=objCls.StatusDr
	.....q:(Sstatus'="")&(Sstatus'[repStaDr)
	.....s typeCode=objCls.Type
	.....s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(typeCode,"InfectionType")
	.....s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	.....s typeDesc=""
	.....i $IsObject(objDic)  d
	......s typeDesc=objDic.Description
	......k objDic
	.....s paadm=objCls.PaadmDR
	.....s DisDate=$p($g(^PAADM(paadm)),"^",17)
	.....q:(Sstatus["101")&(DisDate'="")&(objCls.RepDate>DisDate)	//报告日期大于出院日期为漏报
    .....s DisTime=$p($g(^PAADM(paadm)),"^",18)
	.....s:DisDate'="" DisDate=$zd(DisDate,3)
	.....s:DisTime'="" DisTime=$zt(DisTime,1)
	.....s patName=""
	.....s patLoc=""
	.....s repLoc=""
	.....s patID=""
	.....s userID=objCls.UserDR
	.....s RepUser=""
	.....i userID'="" d
	......s objUser=##class(DHCMed.Base.SSUser).GetObjById(userID)
	......s:$IsObject(objUser) RepUser=objUser.Name
	.....s statusDesc=""
	.....s RepDate=objCls.RepDate
	.....s RepTime=objCls.RepTime
	.....s:+RepDate'=0 RepDate=$zd(+RepDate,3)
	.....s:+RepTime'=0 RepTime=$zt(+RepTime,1)
	.....i repStaDr'="" d
	......s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(repStaDr,"InfectionReportStatus")
	......s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	......s:$IsObject(objDic) statusDesc=objDic.Description
	.....s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	.....i $IsObject(objPaadm)  d
	......s patLoc=objPaadm.Department
	......s patID=objPaadm.PatientID
	......s objPat=##class(DHCMed.Base.Patient).GetObjById(patID)
	......i $IsObject(objPat)  d
	.......s patName=objPat.PatientName
	.......k objPat
	......k objPaadm
	.....s repLocID=objCls.CtLoc
	.....q:(cLoc'="")&(cLoc'=repLocID)
	.....s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(repLocID)
	.....i $IsObject(objLoc) d
	......s repLoc=objLoc.Descs
	......k objLoc
	.....s Data=$lb(rowid,typeCode,typeDesc,paadm,patName,patLoc,repLoc,patID,statusDesc,RepDate,RepTime,RepUser,repLocID,repStaDr,DisDate,DisTime)
    .....s ^CacheTemp(repid,ind)=Data
    .....s ind=ind+1
    
    i DateType=2 d
    .s rowid=""
    .f  s rowid=$o(^DHCMed.INF.ReportD(rowid)) q:rowid=""  d
    ..s objCls=##class(DHCMed.INF.Report).GetObjById(rowid)
    ..q:'$IsObject(objCls)
    ..s paadm=objCls.PaadmDR
    ..s DisDate=$p($g(^PAADM(paadm)),"^",17)
    ..s DisTime=$p($g(^PAADM(paadm)),"^",18)
    ..q:DisDate=""
    ..q:DisTime=""
    ..q:(DisDate>DateTo)||(DisDate<DateFrom)
    ..s:DisDate'="" DisDate=$zd(DisDate,3)
    ..s:DisTime'="" DisTime=$zt(DisTime,1)
	..s repStaDr=objCls.StatusDr
	..q:(Sstatus'="")&(Sstatus'[repStaDr)
	..s typeCode=objCls.Type
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(typeCode,"InfectionType")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..s typeDesc=""
	..i $IsObject(objDic)  d
	...s typeDesc=objDic.Description
	...k objDic
	..q:(Sstatus["101")&(DisDate'="")&(objCls.RepDate>DisDate)	//报告日期大于出院日期为漏报
	..s patName=""
	..s patLoc=""
	..s repLoc=""
	..s patID=""
	..s userID=objCls.UserDR
	..s RepUser=""
	..i userID'="" d
	...s objUser=##class(DHCMed.Base.SSUser).GetObjById(userID)
	...s:$IsObject(objUser) RepUser=objUser.Name
	..s statusDesc=""
	..s RepDate=objCls.RepDate
	..s RepTime=objCls.RepTime
	..s:+RepDate'=0 RepDate=$zd(+RepDate,3)
	..s:+RepTime'=0 RepTime=$zt(+RepTime,1)
	..i repStaDr'="" d
	...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(repStaDr,"InfectionReportStatus")
	...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	...s:$IsObject(objDic) statusDesc=objDic.Description
	..s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..i $IsObject(objPaadm)  d
	...s patLoc=objPaadm.Department
	...s patID=objPaadm.PatientID
	...s objPat=##class(DHCMed.Base.Patient).GetObjById(patID)
	...i $IsObject(objPat)  d
	....s patName=objPat.PatientName
	....k objPat
	...k objPaadm
	..s repLocID=objCls.CtLoc
	..q:(cLoc'="")&(cLoc'=repLocID)
	..s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(repLocID)
	..i $IsObject(objLoc) d
	...s repLoc=objLoc.Descs
	...k objLoc
	..s Data=$lb(rowid,typeCode,typeDesc,paadm,patName,patLoc,repLoc,patID,statusDesc,RepDate,RepTime,RepUser,repLocID,repStaDr,DisDate,DisTime)
    ..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    
    
	Quit $$$OK
}

ClassMethod QryRepByTypeMoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByTypeMoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRepByTypeMoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByTypeMoreExecute ]
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

/// Creator：     陈剑波
/// CreatDate：   2010-07-11
/// Description:  查询某段时间内的某些感染情况
/// Table：       DHCMed.SS.Dictionary
/// Input：       
/// output: 
/// Return：d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QryInfSummary",1)
Query QryInfSummary(InfRepDr As %String = "") As %Query(ROWSPEC = "rowid:%String,LapseTo:%String,LapseToDesc:%String,DeathConnection:%String,DeathConnectionDesc:%String,ICUFlag:%String,ICUFlagDesc:%String,DrugEffect:%String,DrugEffectDesc:%String,DblInfFlag:%String,DblInfFlagDesc:%String,InfPlace:%String,InfPlaceDesc:%String,Treatment:%String,Analysis:%String,ResumeText:%String,InfCtLocHDMDesc:%String")
{
}

ClassMethod QryInfSummaryExecute(ByRef qHandle As %Binary, InfRepDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
    q:InfRepDr="" $$$OK
    q:'$d(^DHCMed.INF.SummaryI("InfRepDr",InfRepDr)) $$$OK
    s SumID=""
    //s ret=##class(DHCMed.INF.Summary).GetStringById(SumID,separate)
 	f  s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",InfRepDr,SumID)) q:(+SumID=0)  d
 	.s objTmp=##class(DHCMed.INF.Summary).GetObjById(SumID)
 	.q:'$IsObject(objTmp)
 	.s (LapseTo,LapseToDesc,DeathConnection,DeathConnectionDesc,ICUFlag,ICUFlagDesc,DrugEffect)=""
	.s (DrugEffectDesc,DblInfFlag,DblInfFlagDesc,InfPlace,InfPlaceDesc,Treatment,Analysis,ResumeText,InfCtLocHDMDesc)=""
	.s LapseTo=objTmp.LapseTo
	.s DeathConnection=objTmp.DeathConnection
	.s ICUFlag=objTmp.ICUFlag
	.s DrugEffect=objTmp.DrugEffect
	.s DblInfFlag=objTmp.DblInfFlag
	.s InfPlace=objTmp.InfPlace
	.s Treatment=objTmp.Treatment
	.s Analysis=objTmp.Analysis
	.s ResumeText=objTmp.ResumeText
	.i +ResumeText'=0 d
    ..s objTmp=##class(DHCMed.Base.Ctloc).GetObjById(+ResumeText)
    ..q:'$IsObject(objTmp)
    ..s InfCtLocHDMDesc=objTmp.Descs
    ..k objTmp
	.i LapseTo'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(LapseTo,"InfectionDiagnosePrognosis")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..i $IsObject(objDic)  d
	...s LapseToDesc=objDic.Description
	...k objDic
	.i DeathConnection'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DeathConnection,"InfDieRelation")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..i $IsObject(objDic)  d
	...s DeathConnectionDesc=objDic.Description
	...k objDic
	.i ICUFlag'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ICUFlag,"InfectionICUType")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..i $IsObject(objDic)  d
	...s ICUFlagDesc=objDic.Description
	...k objDic
	.s:DrugEffect["N" DrugEffectDesc="No"
	.s:DrugEffect["Y" DrugEffectDesc="Yes" 
	.s:DblInfFlag["N" DblInfFlagDesc="No"
	.s:DblInfFlag["Y" DblInfFlagDesc="Yes"
	.i InfPlace'="" d
	..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfPlace,"InfectionRepPlace")
	..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	..i $IsObject(objDic)  d
	...s InfPlaceDesc=objDic.Description
	...k objDic
	.s Data=$lb("")
	.s $li(Data,1)=SumID
	.s $li(Data,2)=LapseTo
	.s $li(Data,3)=LapseToDesc
	.s $li(Data,4)=DeathConnection
	.s $li(Data,5)=DeathConnectionDesc
	.s $li(Data,6)=ICUFlag
	.s $li(Data,7)=ICUFlagDesc
	.s $li(Data,8)=DrugEffect
	.s $li(Data,9)=DrugEffectDesc
	.s $li(Data,10)=DblInfFlag
	.s $li(Data,11)=DblInfFlagDesc
	.s $li(Data,12)=InfPlace
    .s $li(Data,13)=InfPlaceDesc
    .s $li(Data,14)=Treatment
    .s $li(Data,15)=Analysis
    .s $li(Data,16)=ResumeText
    .s $li(Data,17)=InfCtLocHDMDesc
	.s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QryInfSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSummaryExecute ]
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

ClassMethod GetInfSummary(InfRepDr As %String, separate As %String) As %String
{
  n (InfRepDr,separate)
  s ret=""
  q:InfRepDr="" ret
  q:'$d(^DHCMed.INF.SummaryI("InfRepDr",InfRepDr)) ret
  s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",InfRepDr,""),"-1")   //唯一
  s ret=##class(DHCMed.INF.Summary).GetStringById(SumID,separate)
  q ret
}

ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}

/// 准入ICD范围检查方法
/// w ##Class(DHCMed.INFService.InfReportSrv).CheckICDArea("D57 ","C00-D48,D98-E78,D57")
ClassMethod CheckICDArea(argICD As %String, argArea As %String) As %String
{
	New (argICD,argArea)
	Set return=-1
	Quit:(argArea="")||(argICD="") return
	
	Set argArea=$tr(argArea,"，",",")
	Set argArea=$tr(argArea,"－","-")
	Set argArea=$tr(argArea,"~","-")
	For Index=1:1:$l(argArea,",") {
		Set Area=$p(argArea,",",Index)
		Continue:Area=""
		Set Area1=$p(Area,"-",1)
		Set Area2=$p(Area,"-",2)
		If (Area1'="")&&(Area2'="") {
			Kill ICD,ICDO
			Set ICD(" "_Area1)=""
			Set ICD(" "_Area2)=""
			If $o(ICD(" "_Area1))="" {
				Set Areatmp=Area1
				Set Area1=Area2
				Set Area2=Areatmp
			}
			Set ICD=$o(ICD(" "_argICD),-1)
			Set ICDO=$e(ICD,2,$l(ICD))
			Set:(ICDO=Area1) return=1
			Set:(ICDO=Area2)&&($e(argICD,1,$l(Area2))=Area2) return=1
		} Else {
			Set:$e(argICD,1,$l(Area))=Area return=1
		}
	}
	
	Quit return
}

/// Creator：     刘宇辉
/// CreatDate：   2011-09-21
/// Description:  查询一段时间内某诊断数量大于给定值的病人信息
/// Table：      
/// Input：       "7/K35.902-急性阑尾炎-2||K36.02-慢性阑尾炎-3"
/// output: 
/// Return：d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfReportSrv","QueryWarmPatInfo","InfWarmDiag","")
Query QueryWarmPatInfo(key As %String, hospId As %String) As %Query(ROWSPEC = "ind:%String,desc:%String,PatName:%String,PatNo:%String,Dep:%String,ICDDesc:%String")
{
}

ClassMethod QueryWarmPatInfoExecute(ByRef qHandle As %Binary, key As %String, hospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	k ^TEMP("DHCMed")
 	q:key="" $$$OK
	s key=" "_$ZCVT(key,"U")
	s hospId=+$g(hospId)
	q:'$d(^DHCMed.SS.ConfigI("IndexKHV",key,hospId)) $$$OK
	s val=$o(^DHCMed.SS.ConfigI("IndexKHV",key,hospId,""))
	q:val="" $$$OK
	
	s DiagVal=$p(val,"&",1)		//监控诊断信息
	s CtlocVal=$p(val,"&",2)	//监控科室报告信息
	
	s days=$p(DiagVal,"/",1)
	s:days[" " days=$tr(days," ","")
	s days=+days	//往上浮动天数
	//q:days>365	$$$OK   //往上浮动天数不能大于365天
	s diagInfo=$p(DiagVal,"/",2)
	
	s len=$l(diagInfo,"||")
	f i=1:1:len  d
	.s count=0
	.s diagStr=$p(diagInfo,"||",i)
	.q:diagStr=""
	.s icd=$p(diagStr,"-",1)
	.s desc=$p(diagStr,"-",2)
	.s num=+$p(diagStr,"-",3) //触发诊断数目不能小于1
	.q:icd=""
	.q:desc=""
	.q:num<1
	.s sDate=+$h-days
	.f AdmDate=sDate:1:$h d
	..s paadm=0
	..f  s paadm=$o(^PAADMi("AdmDateCurr",AdmDate,paadm)) q:paadm=""  d
	...s AdmInfo=$g(^PAADM(paadm))
	...q:$p(AdmInfo,"^",2)'="I"                 //就诊类型过滤
	
	...s MRAdm=..GetMRAdm(paadm)
	...q:MRAdm=""
	
	...s DiagnosID=0
	...f  s DiagnosID=$o(^MR(MRAdm,"DIA",DiagnosID)) q:DiagnosID=""  d
	....s tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	....s ICDDxID=$p(tmpDiagnos,"^",1)
	....q:ICDDxID=""
	....s ICD10=$p($g(^MRC("ID",ICDDxID)),"^",4)
	....q:ICD10=""
	....s flg=..CheckICDArea(ICD10,icd)
	....q:flg<0
	....q:$d(^TEMP("DHCMed","WARM",diagStr,paadm)) //每个病人一种ICD只取一次
	....s count=count+1
	....s ^TEMP("DHCMed","WARMNUM",diagStr)=count
	....s ^TEMP("DHCMed","WARM",diagStr,paadm)=ICDDxID	
	
	
	s diagStr=""
	f  s diagStr=$o(^TEMP("DHCMed","WARM",diagStr)) q:diagStr=""  d
	.s icd=$p(diagStr,"-",1)
	.s desc=$p(diagStr,"-",2)
	.s num=+$p(diagStr,"-",3) //触发诊断数目不能小于1
	.s count=$g(^TEMP("DHCMed","WARMNUM",diagStr))
	.q:count<num
	.s paadm=0
	.f  s paadm=$o(^TEMP("DHCMed","WARM",diagStr,paadm)) q:paadm=""  d
	..s ICDDxID=^TEMP("DHCMed","WARM",diagStr,paadm)
	..s ICDDesc=$p($g(^MRC("ID",ICDDxID)),"^",2)	//诊断名称
	..s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(objPaadm)
	..s Department=objPaadm.Department	//就诊科室名称
	..s:Department["-" Department=$p(Department,"-",2)
	..s PatientID=objPaadm.PatientID
	..q:PatientID=""
	..s objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	..q:'$IsObject(objPat)
	..s PatientName=objPat.PatientName
	..s PapmiNo=objPat.PapmiNo
	..s Data=$lb("")
	..s $li(Data,1)=ind
	..s $li(Data,2)=desc	//监控诊断名称
	..s $li(Data,3)=PatientName
	..s $li(Data,4)=PapmiNo
	..s $li(Data,5)=Department
	..s $li(Data,6)=ICDDesc
	..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    
    s days=$p(CtlocVal,"/",1)
	s:days[" " days=$tr(days," ","")
	s days=+days	//往上浮动天数
	//q:days>365	$$$OK   //往上浮动天数不能大于365天
	s num=$p(CtlocVal,"/",2)
	
	s rowid=""
	f  s rowid=$o(^DHCMed.INF.ReportI("Type"," 1",rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.Report).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s LocID=obj.CtLoc
	.s RepDate=obj.RepDate
	.s PaadmDR=obj.PaadmDR
	.q:+$h-RepDate>days		//当前日期-报告日期>浮动天数 退出
	.s:$d(^TEMP("DHCMed","LocID",LocID)) ^TEMP("DHCMed","LocID",LocID)=^TEMP("DHCMed","LocID",LocID)+1
	.s:'$d(^TEMP("DHCMed","LocID",LocID)) ^TEMP("DHCMed","LocID",LocID)=1
	.s ^TEMP("DHCMed","LocID",LocID,"InfID",rowid)=""
	
	s DepID=0
	f  s DepID=$o(^TEMP("DHCMed","LocID",DepID)) q:DepID=""  d
	.q:$g(^TEMP("DHCMed","LocID",DepID))<num //科室报告数量小于给定数量
    .s InfID=0
    .f  s InfID=$o(^TEMP("DHCMed","LocID",DepID,"InfID",InfID)) q:InfID=""  d
    ..s obj=##class(DHCMed.INF.Report).GetObjById(InfID)
	..q:'$IsObject(obj)
	..s paadm=obj.PaadmDR
	..s objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(objPaadm)
	..s Department=objPaadm.Department	//就诊科室名称
	..s:Department["-" Department=$p(Department,"-",2)
	..s PatientID=objPaadm.PatientID
	..q:PatientID=""
	..s objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	..q:'$IsObject(objPat)
	..s PatientName=objPat.PatientName
	..s PapmiNo=objPat.PapmiNo
	..s DepObj=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
	..q:'$IsObject(DepObj)
	..s DepDesc=DepObj.Descs
	..s:DepDesc["-" DepDesc=$p(DepDesc,"-",2)
	..s Data=$lb("")
	..s $li(Data,1)=ind
	..s $li(Data,2)=DepDesc_" 院感报告数量>="_num
	..s $li(Data,3)=PatientName
	..s $li(Data,4)=PapmiNo
	..s $li(Data,5)=Department
	..s $li(Data,6)=""
	..s ^CacheTemp(repid,ind)=Data
    ..s ind=ind+1
    
    
	Quit $$$OK
}

ClassMethod QueryWarmPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWarmPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryWarmPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWarmPatInfoExecute ]
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
