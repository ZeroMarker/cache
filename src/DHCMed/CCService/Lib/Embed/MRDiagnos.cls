/// 诊断监控
Class DHCMed.CCService.Lib.Embed.MRDiagnos Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过ID取临床诊断数量
/// Table：       MR_Diagnos,MRC_Icddx
/// Input：       Input: "诊断||1234||霍乱"
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Embed.MRDiagnos).GetNumByID("")
ClassMethod GetNumByID(argInput As %String) As %String
{
	New (argInput,%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Quit:argInput="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetNumByIDErr"
	Set ICDID=$p(argInput,"||",2)
	Quit:ICDID="" return
	Set MRAdm=$p(%Value,"||",1)
	Set DiagnosID=$p(%Value,"||",2)
	
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Quit:ICDDxID'=ICDID return
	Set ICDDate=$p(tmpDiagnos,"^",7)
	Set ICDTime=$p(tmpDiagnos,"^",8)	
	Set:ICDDate'="" ICDDate=$zd(ICDDate,3)
	Set:ICDTime'="" ICDTime=$zt(ICDTime,2)
	Set ICDDesc=$p($g(^MRC("ID",ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set:(ICDDES'="")&&(ICDDES'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDES
	Set:(ICDDHC'="")&&(ICDDHC'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDHC
	Set ICDRst=ICDDesc	//_"("_ICDDate_" "_ICDTime_")" update by liuyh 2013-02-27
	Set ICDRst=$$BuildGetNumByIDResult(ICDRst)
	Set %ExtraData=%ExtraData_$lb(ICDRst)
	
	Quit return
	
GetNumByIDErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildGetNumByIDResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=arg0
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(MRAdm_"||"_DiagnosID)
	Do objDia.%Close()
	Set strUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+objDia.DocCodeDr)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=objDia.DiaDate
	Set $p(tmp,$c(3),3)=objDia.DiaTime
	Set $p(tmp,$c(3),4)=ICDDesc
	Set $p(tmp,$c(3),5)=MRAdm_"||"_DiagnosID
	Set $p(tmp,$c(3),6)=+$p(strUser,"^",1)
	Set $p(tmp,$c(3),7)="argInput"_argInput
	Quit tmp
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过Name取临床诊断数量
/// Table：       MR_Diagnos,MRC_Icddx
/// Input：       Input: "霍乱"
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Embed.MRDiagnos).GetNumByName("肝硬化")
ClassMethod GetNumByName(argNames As %String) As %String
{
	New (argNames,%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Quit:argNames="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetNumByNameErr"
	Set MRAdm=$p(%Value,"||",1)
	Set DiagnosID=$p(%Value,"||",2)
	
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Quit:ICDDxID="" return //Modified By LiYang 2012-07-01
	Set ICDDesc=$p($g(^MRC("ID",ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set:(ICDDES'="")&&(ICDDES'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDES
	Set:(ICDDHC'="")&&(ICDDHC'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDHC
	
	Set flg=0
	For i=1:1:$l(argNames,",")
	{
		Set argName=$p(argNames,",",i)
		Set:ICDDesc[argName flg=1
	}
	Quit:flg=0 return
	Set Count=Count+1
	Set ICDDate=$p(tmpDiagnos,"^",7)
	Set ICDTime=$p(tmpDiagnos,"^",8)
	Set:ICDDate'="" ICDDate=$zd(ICDDate,3)
	Set:ICDTime'="" ICDTime=$zt(ICDTime,2)
	Set ICDRst=ICDDesc	//_"("_ICDDate_" "_ICDTime_")" update by liuyh 2013-02-27
	Set ICDRst=$$BuildGetNumByNameResult(ICDRst)
	Set %ExtraData=%ExtraData_$lb(ICDRst)
	Set return=Count
	Quit return
	
GetNumByNameErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildGetNumByNameResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=arg0
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(MRAdm_"||"_DiagnosID)
	Do objDia.%Close()
	Set strUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+objDia.DocCodeDr)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=objDia.DiaDate
	Set $p(tmp,$c(3),3)=objDia.DiaTime
	Set $p(tmp,$c(3),4)=ICDDesc
	Set $p(tmp,$c(3),5)=MRAdm_"||"_DiagnosID
	Set $p(tmp,$c(3),6)=+$p(strUser,"^",1)
	Set $p(tmp,$c(3),7)="argNames"_argNames
	Quit tmp
}

/// Creator：     zhufei
/// CreatDate：   2011-03-18
/// Description:  通过ICD10(模糊和区间对比)取临床诊断数量
/// Table：       MR_Diagnos,MRC_Icddx
/// Input：       Input: "霍乱"
/// Return：      返回临床诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Lib.Embed.MRDiagnos).GetNumByICD10("A01,B01-B03")
ClassMethod GetNumByICD10(argICD10 As %String) As %String
{
	New (argICD10,%EpisodeID,%ExtraData,%ErrorData,%Value)
	Set return=0,Count=0
	Quit:argICD10="" return
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="GetNumByICD10Err"
	Set MRAdm=$p(%Value,"||",1)
	Set DiagnosID=$p(%Value,"||",2)
	Quit:MRAdm="" return
	
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Quit:ICDDxID="" return
	Set ICD10=$p($g(^MRC("ID",ICDDxID)),"^",4)
	Quit:ICD10="" return
	Set flg=##Class(DHCMed.CCService.Lib.Common).CheckICDArea(ICD10,argICD10)
	Quit:flg<0 return
	Set ICDDesc=$p($g(^MRC("ID",ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set:(ICDDES'="")&&(ICDDES'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDES
	Set:(ICDDHC'="")&&(ICDDHC'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDHC
	Set Count=Count+1
	Set ICDDate=$p(tmpDiagnos,"^",7)
	Set ICDTime=$p(tmpDiagnos,"^",8)
	Set:ICDDate'="" ICDDate=$zd(ICDDate,3)
	Set:ICDTime'="" ICDTime=$zt(ICDTime,2)
	Set ICDRst=ICD10_" "_ICDDesc	//_"("_ICDDate_" "_ICDTime_")" update by liuyh 2013-02-27
	Set ICDRst=$$BuildGetNumByICD10Result(ICDRst)
	Set %ExtraData=%ExtraData_$lb(ICDRst)
	
	Set return=Count
	Quit return
	
GetNumByICD10Err
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
BuildGetNumByICD10Result(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=arg0
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(MRAdm_"||"_DiagnosID)
	Do objDia.%Close()
	Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+objDia.DocCodeDr)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Do objUser.%Close()
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set strUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+objDia.DocCodeDr)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=objDia.DiaDate
	Set $p(tmp,$c(3),3)=objDia.DiaTime
	Set $p(tmp,$c(3),4)=ICDDesc
	Set $p(tmp,$c(3),5)=MRAdm_"||"_DiagnosID
	Set $p(tmp,$c(3),6)=+$p(strUser,"^",1)
	Set $p(tmp,$c(3),7)="argICD10"_argICD10
	Quit tmp
}

}
