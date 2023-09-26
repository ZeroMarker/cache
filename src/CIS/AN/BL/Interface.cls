/// 与旧版本的接口类
Class CIS.AN.BL.Interface Extends %RegisteredObject
{

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入科室信息
/// Table：        	CF.AN.Location
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportCTLoc()
ClassMethod ImportCTLoc()
{
	TSTART
	s locDr=0,fe=0
	f  s locDr=$o(^CTLOC(locDr)) q:(locDr="")||(fe=1)  d
	.s code=$p(^CTLOC(locDr),"^",1)
	.s desc=$p(^CTLOC(locDr),"^",2)
	.s dateFrom=$p(^CTLOC(locDr),"^",24)
	.s dateTo=$p(^CTLOC(locDr),"^",25)
	.s wardFlag=$p(^CTLOC(locDr),"^",5)
	.s locType=$p(^CTLOC(locDr),"^",13)
	.s hosDr=$p(^CTLOC(locDr),"^",22)
	.s Active="Y"
	.s:(dateTo'="")&&(dateTo<=+$h) Active="N"
	.s obj=""
	.i $d(^CF.AN.LocationI("Ext"," "_locDr))>0 d
	..s objId=$o(^CF.AN.LocationI("Ext"," "_locDr,0))
	..s obj=##class(CF.AN.Location).%OpenId(objId)
	.e  d
	..s obj=##class(CF.AN.Location).%New()
	.s obj.Active=Active
	.s obj.ActiveDate=dateFrom
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExpireDate=dateTo
	.s:(dateTo'="")&&(dateTo<=+$h) obj.Active="N"
	.s obj.ExternalID=locDr
	.d:hosDr'="" obj.HospitalSetObjectId(hosDr)
	.s obj.LocType=locType
	.s obj.WardFlag=wardFlag
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q "E^"_$system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入医院信息
/// Table：        	CF.AN.Hospital
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportHospital()
ClassMethod ImportHospital()
{
	TSTART
	s hosDr=0,fe=0
	f  s hosDr=$o(^CT("HOSP",hosDr)) q:(hosDr="")||(fe=1)  d
	.s code=$p(^CT("HOSP",hosDr),"^",1)
	.s desc=$p(^CT("HOSP",hosDr),"^",2)
	.s dateFrom=$p(^CT("HOSP",hosDr),"^",9)
	.s dateTo=$p(^CT("HOSP",hosDr),"^",10)
	.s Active="Y"
	.s:(dateTo'="")&&(dateTo<=+$h) Active="N"
	.s obj=""
	.i $d(^CF.AN.HospitalI("ExtID",hosDr))>0 d
	..s objId=$o(^CF.AN.HospitalI("ExtID",hosDr,0))
	..s obj=##class(CF.AN.Hospital).%OpenId(objId)
	.e  d
	..s obj=##class(CF.AN.Hospital).%New()
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExtCode=code
	.s obj.ExternalID=hosDr
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入麻醉类型
/// Table：        	CT.AN.AnaMethod
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportAnaestType()
ClassMethod ImportAnaestType()
{
	TSTART
	s anTypeId=0,fe=0
	f  s anTypeId=$o(^ORC("ANTYPE",anTypeId)) q:(anTypeId="")||(fe=1)  d
	.s code=$p(^ORC("ANTYPE",anTypeId),"^",1)
	.s desc=$p(^ORC("ANTYPE",anTypeId),"^",2)
	.s dateFrom=$p(^ORC("ANTYPE",anTypeId),"^",3)
	.s dateTo=$p(^ORC("ANTYPE",anTypeId),"^",4)
	.s Active="Y"
	.s:(dateTo'="")&&(dateTo<=+$h) Active="N"
	.s obj=""
	.i $d(^CT.AN.AnaTypeI("Ext"," "_anTypeId))>0 d
	..s objId=$o(^CT.AN.AnaTypeI("Ext"," "_anTypeId,0))
	..s obj=##class(CT.AN.AnaType).%OpenId(objId)
	.e  d
	..s obj=##class(CT.AN.AnaType).%New()
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExternalID=anTypeId
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)_"123"
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入麻醉方式
/// Table：        	CT.AN.AnaMethod
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportAnaMethod()
ClassMethod ImportAnaMethod()
{
	TSTART
	s anaMethodDr=0,fe=0
	f  s anaMethodDr=$o(^ORC("ANMET",anaMethodDr)) q:(anaMethodDr="")||(fe=1)  d
	.s code=$p(^ORC("ANMET",anaMethodDr),"^",1)
	.s desc=$p(^ORC("ANMET",anaMethodDr),"^",2)
	.s typeDr=$p(^ORC("ANMET",anaMethodDr),"^",3)
	.s dateFroom=$p(^ORC("ANMET",anaMethodDr),"^",5)
	.s dateTo=$p(^ORC("ANMET",anaMethodDr),"^",6)
	.s Active="Y"
	.s:(dateTo'="")&&(dateTo<=+$h) Active="N"
	.;^CT.AN.AnaTypeI("Ext"," 1",1)
	.s anaTypeDr=""
	.;s:typeDr="" typeDr=16
	.s:($d(^CT.AN.AnaTypeI("Ext"," "_typeDr))'=0) anaTypeDr=$o(^CT.AN.AnaTypeI("Ext"," "_typeDr,0))
	.s obj=""
	.i $d(^CT.AN.AnaMethodI("Ext"," "_anaMethodDr))>0 d
	..s objId=$o(^CT.AN.AnaMethodI("Ext"," "_anaMethodDr,0))
	..s obj=##class(CT.AN.AnaMethod).%OpenId(objId)
	.e  d
	..s obj=##class(CT.AN.AnaMethod).%New()
	.s obj.Active=Active
	.s obj.Alias=$p(desc,"-",1)
	.d:anaTypeDr'="" obj.AnaTypeSetObjectId(anaTypeDr)
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExternalID=anaMethodDr
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入切口类型
/// Table：        	CT.AN.BladeType
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportBladeType()
ClassMethod ImportBladeType()
{
	
	TSTART
	s bladeTypeDr=0,fe=0
	f  s bladeTypeDr=$o(^ORC("BLDTP",bladeTypeDr)) q:(bladeTypeDr="")||(fe=1)  d
	.s code=$p(^ORC("BLDTP",bladeTypeDr),"^",1)
	.s desc=$p(^ORC("BLDTP",bladeTypeDr),"^",2)
	.s obj=""
	.i $d(^CT.AN.BladeTypeI("Ext"," "_bladeTypeDr))>0 d
	..s objId=$o(^CT.AN.BladeTypeI("Ext"," "_bladeTypeDr,0))
	..s obj=##class(CT.AN.BladeType).%OpenId(objId)
	.e  d
	..s obj=##class(CT.AN.BladeType).%New()
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExternalID=bladeTypeDr
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入手术部位
/// Table：        	CT.AN.BodySite
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportBodySite()
ClassMethod ImportBodySite()
{
	TSTART
	s bodsDr=0,fe=0
	f  s bodsDr=$o(^OEC("BODS",bodsDr)) q:(bodsDr="")||(fe=1)  d
	.s code=$p(^OEC("BODS",bodsDr),"^",1)
	.s desc=$p(^OEC("BODS",bodsDr),"^",2)
	.s obj=""
	.i $d(^CT.AN.BodySiteI("Ext"," "_bodsDr))>0 d
	..s objId=$o(^CT.AN.BodySiteI("Ext"," "_bodsDr,0))
	..s obj=##class(CT.AN.BodySite).%OpenId(objId)
	.e  d
	..s obj=##class(CT.AN.BodySite).%New()
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExternalID=bodsDr
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入手术体位
/// Table：        	CT.AN.OperPosition
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportOperPosition()
ClassMethod ImportOperPosition()
{
	TSTART
	s opposDr=0,fe=0
	f  s opposDr=$o(^ORC("OPPOS",opposDr)) q:(opposDr="")||(fe=1)  d
	.s code=$p(^ORC("OPPOS",opposDr),"^",1)
	.s desc=$p(^ORC("OPPOS",opposDr),"^",2)
	.s obj=""
	.i $d(^CT.AN.OperPositionI("Ext"," "_opposDr))>0 d
	..s objId=$o(^CT.AN.OperPositionI("Ext"," "_opposDr,0))
	..s obj=##class(CT.AN.OperPosition).%OpenId(objId)
	.e  d
	..s obj=##class(CT.AN.OperPosition).%New()
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExternalID=opposDr
	.s obj.Active="Y"
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入手术字典
/// Table：        	CT.AN.Operation
/// Input:			 
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportOperation()
ClassMethod ImportOperation()
{
	TSTART
	s operId=0,fe=0
	f  s operId=$o(^ORC("OPER",operId)) q:(operId="")||(fe=1)  d
	.s code=$p(^ORC("OPER",operId),"^",1)
	.s desc=$p(^ORC("OPER",operId),"^",2)
	.s operCatDr=$p(^ORC("OPER",operId),"^",7)
	.s operCatDr=+operCatDr
	.s operCatDesc=""
	.s:(operCatDr'=0)&&$d(^ORC("CATEG",operCatDr)) operCatDesc=$p(^ORC("CATEG",operCatDr),"^",2)
	.s operClass=""
	.s:operCatDesc["一" operClass=2
	.s:operCatDesc["二" operClass=6
	.s:operCatDesc["三" operClass=7
	.s:operCatDesc["四" operClass=8
	.s dateFrom=$p(^ORC("OPER",operId),"^",5)
	.s dateTo=$p(^ORC("OPER",operId),"^",6)
	.s ICD10=$p(^ORC("OPER",operId),"^",14)
	.s Active="Y"
	.s:(dateTo'="")&&(dateTo<=+$h) Active="N"
	.s Alias=""
	.s:$d(^ORC("OPER",operId,"ALIAS",1)) Alias=$p(^ORC("OPER",operId,"ALIAS",1),"^",1)
	.s obj=""
	.i $d(^CT.AN.OperationI("Ext"," "_operId))>0 d
	..s objId=$o(^CT.AN.OperationI("Ext"," "_operId,0))
	..s obj=##class(CT.AN.Operation).%OpenId(objId)
	.e  d
	..s obj=##class(CT.AN.Operation).%New()
	.s obj.Active=Active
	.;s:(dateTo'="")&&(dateTo<=+$h) obj.Active="N"
	.s obj.Alias=Alias
	.s obj.Code=code
	.s obj.Description=desc
	.s obj.ExternalID=operId
	.s obj.ICDCode=ICD10
	.d:operClass'="" obj.OperClassSetObjectId(operClass)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d
	..s fe=1
	i fe=1 TRollBack  q $system.Status.GetErrorText(sc)
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入手术列表信息
/// Table：        	CT.AN.Operation
/// Input:			stdate 开始日期, enddate 结束日期
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportOperInfoList("2018-12-05","2019-12-05")
ClassMethod ImportOperInfoList(stdate As %String, enddate As %String)
{
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(stdate,""),edate=+##class(CIS.AN.COM.DateTime).ConvertToDateH(enddate,"")
    s SubNode="SDate",errorInfo=""
    TSTART
    f date=sdate:1:edate
    {
		s opaId="",fe=0
		f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:(opaId="")||(fe=1)  d
		.q:'##class(User.DHCANOPArrange).%ExistsId(opaId)
		.s ret=..ImportOperInfo(opaId)
		.i ret'="S^" d
		..s fe=1
		..s errorInfo=ret
		q:fe=1 
	}
	i errorInfo'="" TRollBack  q errorInfo
	TCOMMIT
	q "S^操作完毕"
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-03
/// Description： 	导入手术信息
/// Table：        	CT.AN.Operation
/// Input:			opaId
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).ImportOperInfo("")
ClassMethod ImportOperInfo(opaId As %String)
{
	s $zt="Error"
	s EpisodeID=$p(^DHCANOPArrange(opaId),"^",1) //就诊号
	s ExternalID=opaId
	s AppDeptID=$p(^DHCANOPArrange(opaId),"^",54) //申请科室
	s PatDeptID=$P(^PAADM(EpisodeID),"^",4)   		//病人所在科室ID
	s PatWardID=$p($g(^PAADM(EpisodeID)),"^",70) 	//病人所在病区ID
	s PatBedID=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2) //床位ID 
	i PatBedID'="" s PatBedDesc=$p($g(^PAWARD(PatWardID,"BED",PatBedID)),"^",1)
	s StatusCode=$P(^DHCANOPArrange(opaId),"^",27)
	s Status=""
	i StatusCode="A" s Status=1
	i StatusCode="R" s Status=3
	i StatusCode="I" s Status=4
	i StatusCode="L" s Status=5
	i StatusCode="P" s Status=6
	i StatusCode="F" s Status=7
	i StatusCode="D" s Status=8
	i StatusCode="C" s Status=9
	;b ;001
	;i StatusCode="" s Status=1
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s extAnaMethodDr= $P(^OR(EpisodeID,"ANA",anaSub),"^",5) //麻醉方法
	s PrevAnaMethod="" //拟施麻醉
	//^CT.AN.AnaMethodI("Ext"," 2",75)
	i (extAnaMethodDr'="")&&($d(^CT.AN.AnaMethodI("Ext"," "_extAnaMethodDr))>0) d
	.s PrevAnaMethod=$o(^CT.AN.AnaMethodI("Ext"," "_extAnaMethodDr,0))
	s PrevAnaMethodDesc=""
	s:$g(extAnaMethodDr)'="" PrevAnaMethodDesc=$p($g(^ORC("ANMET",extAnaMethodDr)),"^",2)
	s OperRoom="",OperRoomCode="" //手术间
	s opaRoomDr=$P(^DHCANOPArrange(opaId),"^",20)
	s:opaRoomDr'="" OperRoomCode=$p($g(^DHCANC("OPRoom",opaRoomDr)),"^",1)
	s:OperRoomCode'="" OperRoom=$O(^CF.AN.LocationI("Code"," "_OperRoomCode,0))
	s OperSeq=$P(^DHCANOPArrange(opaId),"^",26) //台次
	s planOperSeq=$P(^DHCANOPArrange(opaId),"^",41) //申请台次
	s AppDate=$P(^DHCANOPArrange(opaId),"^",3) //申请日期
	s AppTime=$P(^DHCANOPArrange(opaId),"^",5) //申请时间
	s OperDate=$P(^DHCANOPArrange(opaId),"^",14) //手术日期
	s OperTime=$P(^DHCANOPArrange(opaId),"^",15) //手术开始时间
	s AppCareProvID=$P(^DHCANOPArrange(opaId),"^",6) //手术申请医护人员ID
	s SourceType=$P(^OR(EpisodeID,"ANA",anaSub),"^",32) //手术类型
	s Anaesthesia=$P(^DHCANOPArrange(opaId),"^",44) //是否麻醉
	s ReentryOperation=$P(^DHCANOPArrange(opaId),"^",46) //是否重返手术(非计划二次手术)
	s IsoOperation=$P(^DHCANOPArrange(opaId),"^",10)	//是否隔离
	s ECC=$P(^DHCANOPArrange(opaId),"^",36)			//体外循环
	s TransAutoblood=$P(^DHCANOPArrange(opaId),"^",34)	//是否输血
	s PrepareBlood=$P(^DHCANOPArrange(opaId),"^",33)	//是否备血
	s BloodTypeDr=$P(^DHCANOPArrange(opaId),"^",11)	//血型
	s BloodType=""
	s:(BloodTypeDr'="")&&$d(^PAC("BLDT",BloodTypeDr))>0 BloodType=$P($G(^PAC("BLDT",BloodTypeDr)),"^",2)
	s RHBloodType=$P(^DHCANOPArrange(opaId),"^",25) 	// RH血型
	s HbsAg=$P(^DHCANOPArrange(opaId, "PALab"),"^",29)  
	s HcvAb=$P(^DHCANOPArrange(opaId, "PALab"),"^",34)
	s HivAb=$P(^DHCANOPArrange(opaId, "PALab"),"^",35)
	s Syphilis=$P(^DHCANOPArrange(opaId, "PALab"),"^",36) // 梅毒
	s OperRequirement=$P(^DHCANOPArrange(opaId),"^",19)  //手术要求
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s PatDOB=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	;s MrNo =##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
	;s:+MrNo'>0 MrNo=""
	;s medCareNo=MrNo
	;s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s PatGender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s AnaExpert=$P(^OR(EpisodeID,"ANA",anaSub),"^",7) //麻醉指导
	s Anesthesiologist=$P(^OR(EpisodeID,"ANA",anaSub),"^",6) //麻醉医生
	s AnaNurse=$P(^OR(EpisodeID,"ANA",anaSub),"^",8) //麻醉护士
	s PrevDiagnosis="",PostDiagnosis="",OperDeptID="",OperPosition=""
	s AnaAssistant="",ScrubNurse="",CircualNurse=""
	s anaopSub=0,anaopI=0
	f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
	.s anaopI=anaopI+1
	.s anassSub=0 //麻醉助手
	.f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
	..s:AnaAssistant'="" AnaAssistant=AnaAssistant_","
	..s:$d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))>0 AnaAssistant=AnaAssistant_$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub))
	.s xs=5 //洗手(器械)护士
	.f i=1:1:xs d
	..s:ScrubNurse'="" ScrubNurse=ScrubNurse_","
	..s:$d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs))>0 ScrubNurse=ScrubNurse_$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",xs),"^",1)
	.s xcl=5 //巡回护士
	.f i=1:1:xcl d
	..s:CircualNurse'="" CircualNurse=CircualNurse_","
	..s:$d(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xcl))>0 CircualNurse=CircualNurse_$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",xcl),"^",1)
	.
	.s:anaopI=1 OperDeptID=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10) //手术室ID
	.//术前诊断
	.s preDiagId=$P(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub),"^",4) 
	.s preDiagTem=""
	.s:(preDiagId)="" preDiagTem=$g(^OR(EpisodeID,"ANA", anaSub,"TXT",2)) ;手写的术前诊断
	.s preDiagTem=$g(preDiagTem)
	.i preDiagId'="" d
	..s preDiagLen=$l(preDiagId,"|")
	..f i=1:1:preDiagLen d
	...s curPreDiag=$p(^MRC("ID",$p(preDiagId,"|",i)),"^",2)
	...s:preDiagTem'="" preDiagTem=preDiagTem_","
	...s preDiagTem=preDiagTem_curPreDiag
	.i preDiagTem'="" d
	..s:PrevDiagnosis'="" PrevDiagnosis=PrevDiagnosis_","
	..s PrevDiagnosis=PrevDiagnosis_preDiagTem
	.//术后诊断
	.s postDiagTem=""
	.s postDiagId=$P(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub),"^",5) ;术后诊断ID
	.i postDiagId'="" d
	..s postDiagLen=$l(postDiagId,"|")
	..f i=1:1:postDiagLen d
	...s curPosDiag=$p(^MRC("ID",$p(postDiagId,"|",i)),"^",2)
	...s:postDiagTem'="" postDiagTem=postDiagTem_","
	...s postDiagTem=postDiagTem_curPosDiag
	.i postDiagTem'="" d
	..s:PostDiagnosis'="" PostDiagnosis=PostDiagnosis_","
	..s PostDiagnosis=PostDiagnosis_postDiagTem
	.s OperPos=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
	.i $g(OperPos)'="" d
	..s OperPos=+OperPos
	..;^CT.AN.OperPositionI("Ext"," 1",9)
	..s:$d(^CT.AN.OperPositionI("Ext"," "_OperPos))>0 OperPosition=$o(^CT.AN.OperPositionI("Ext"," "_OperPos,0))
	.
	s Antibiosis=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"Antibiosis") // 是否使用抗生素
	s InfectedOper=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"InfectedOper") // 是否感染手术
	s SpecialInstrument=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"SpecialInstrument") // 特殊仪器及器械
	s HighConsum=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"HighConsum") // 高值手术耗材
	s SeqNote=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"SeqNote") // 排台说明
	
	s isNewId=0,OperSchedule="",OperScheduleId=""
	i ($d(^CIS.AN.OperScheduleI("Ext"," "_opaId))>0) d
	.s OperScheduleId=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,0))
	
	i (OperScheduleId'="")&&(##class(CIS.AN.OperSchedule).%ExistsId(OperScheduleId)) d
	.s OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(OperScheduleId)
	e  d
	.s isNewId=1
	.s OperSchedule=##class(CIS.AN.OperSchedule).%New()
	;b ;002
	s OperSchedule.EpisodeID=EpisodeID
	s OperSchedule.ExternalID=opaId
	s OperSchedule.AppDeptID=AppDeptID
	s OperSchedule.OperDeptID=OperDeptID
	s OperSchedule.PatDeptID=PatDeptID
	s OperSchedule.PatWardID=PatWardID
	s OperSchedule.PatBedID=PatBedID
	d:Status'="" OperSchedule.StatusSetObjectId(Status)
	s OperSchedule.PrevDiagnosis=PrevDiagnosis
	s OperSchedule.PostDiagnosis=PostDiagnosis
	s OperSchedule.PrevAnaMethod=PrevAnaMethod
	d:OperRoom'="" OperSchedule.OperRoomSetObjectId(OperRoom)
	s:OperSeq'="" OperSchedule.OperSeq=OperSeq  //揭阳测试，暂不同步为空的台次
	s OperSchedule.AppDate=AppDate
	s OperSchedule.AppTime=AppTime
	s OperSchedule.OperDate=OperDate
	s OperSchedule.OperTime=OperTime
	s OperSchedule.AppCareProvID=AppCareProvID
	s OperSchedule.SourceType=SourceType
	s OperSchedule.Anaesthesia=Anaesthesia
	s OperSchedule.ReentryOperation=ReentryOperation
	s OperSchedule.IsoOperation=IsoOperation
	s OperSchedule.ECC=ECC
	s OperSchedule.TransAutoblood=TransAutoblood
	s OperSchedule.PrepareBlood=PrepareBlood
	s OperSchedule.BloodType=BloodType
	s OperSchedule.RHBloodType=RHBloodType
	s OperSchedule.HbsAg=HbsAg
	s OperSchedule.HcvAb=HcvAb
	s OperSchedule.HivAb=HivAb
	s OperSchedule.Syphilis=Syphilis
	s OperSchedule.OperRequirement=OperRequirement
	s OperSchedule.PatName=PatName
	s OperSchedule.PatGender=PatGender
	s OperSchedule.PatDOB=PatDOB
	s OperSchedule.PrevAnaMethod=PrevAnaMethod
	s OperSchedule.ExtAnaestID=anaId
	;d:OperPosition'="" OperSchedule.OperPositionSetObjectId(OperPosition)
	s OperSchedule.OperPosition=OperPosition
	s OperSchedule.AnaExpert=AnaExpert
	s OperSchedule.Anesthesiologist=Anesthesiologist
	s OperSchedule.AnaAssistant=AnaAssistant
	s OperSchedule.ScrubNurse=ScrubNurse
	s OperSchedule.CircualNurse=CircualNurse
	s OperSchedule.AnaNurse=AnaNurse
	s OperSchedule.SurgicalMaterials=$p(SpecialInstrument,$c(3),1)
	s OperSchedule.SeqType=$p(SeqNote,$c(3),1)
	s OperSchedule.HighConsume=$p(HighConsum,$c(3),1)
	s OperSchedule.Antibiosis=$p(Antibiosis,$c(3),1)
	s OperSchedule.InfectionOper=$p(InfectedOper,$c(3),1)
	s OperSchedule.PlanSeq=planOperSeq
	s OperSchedule.OperSeq=planOperSeq
	s medExamInfo=##class(CIS.AN.BL.OperSchedule).GetMedExamination(EpisodeID)
	set:(OperSchedule.PatHeight="") OperSchedule.PatHeight=$p(medExamInfo,"^",2)
	set:(OperSchedule.PatWeight="") OperSchedule.PatWeight=$p(medExamInfo,"^",1)
	set:(OperSchedule.BloodType="")!("未知^不详" [ OperSchedule.BloodType) OperSchedule.BloodType=$p(medExamInfo,"^",4)
	set:(OperSchedule.RHBloodType="")!("未知^不详" [ OperSchedule.RHBloodType) OperSchedule.RHBloodType=$p(medExamInfo,"^",5) 
	s sc=OperSchedule.%Save()
	q:$$$ISERR(sc) "E^"_$system.Status.GetErrorText(sc)_"^opaId:"_opaId
	s opsId=OperSchedule.%Id()
	s editOrAdd=0 //是否允许继续添加手术信息
	i (StatusCode="A")||(StatusCode="") d
	.s editOrAdd=1
	e  d
	.s:isNewId=1 editOrAdd=1
	q:editOrAdd=0 "S^" 
	i isNewId=0
	{
		&sql(delete from CIS_AN.OperList where OperSchedule=:opsId)
		&sql(delete from CIS_AN.PlanOperList where OperSchedule=:opsId)
	}
	s anaopSub=0,fe=0
	f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")||(fe=1)  d
	.s opaOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub),"^",6)
	.s Operation="",OperNote="" //手术名称
	.s:(opaOperId'="")&&($d(^CT.AN.OperationI("Ext"," "_opaOperId))>0) Operation=$o(^CT.AN.OperationI("Ext"," "_opaOperId,0))
	.i opaOperId="" d
	..s OperNote=$G(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub,"REM",2))
	.e  d
	..s OperNote=$p($g(^ORC("OPER",opaOperId)),"^",2)
	.s BladeType="" //切口类型
	.s opaBladeType= $P(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub),"^",9)
	.s:(opaBladeType'="")&&($d(^CT.AN.BladeTypeI("Ext"," "_opaBladeType))>0) BladeType=$o(^CT.AN.BladeTypeI("Ext"," "_opaBladeType,0))
	.s BodySite="" //手术部位
	.s opaBds=$P(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub),"^",24)
	.s:(opaBds'="")&&($d(^CT.AN.BodySiteI("Ext"," "_(+opaBds)))>0) BodySite=$o(^CT.AN.BodySiteI("Ext"," "_(+opaBds),0))
	.s Note= $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",1))
	.s Surgeon="" //手术医生
	.s opaSurgeon=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)
	.s Surgeon=opaSurgeon
	.s Assistant="" //手术助手
	.s opasSub=0 f  s opasSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub,"ASS",opasSub)) q:opasSub=""  d
	..s ass=$P(^OR(EpisodeID,"ANA",anaSub,"OP", anaopSub,"ASS",opasSub),"^",1)
	..i ass'="" d
	...s:Assistant'="" Assistant=Assistant_","
	...s Assistant=Assistant_ass
	.s PostDiagnosis=PostDiagnosis
	.s OperationObj=""
	.s:##class(CT.AN.Operation).%ExistsId(Operation) OperationObj=##class(CT.AN.Operation).%OpenId(Operation)
	.s operInfoObj=##class(CIS.AN.OperList).%New() //实施手术
	.s operInfoObj.OperSchedule=OperSchedule
	.s operInfoObj.Operation=OperationObj
	.s operClassId=""
	.s:(OperationObj'="")&&(OperationObj.OperClass'="") operClassId=OperationObj.OperClass.%Id()
	.d:operClassId'="" operInfoObj.OperClassSetObjectId(operClassId)
	.d:BladeType'="" operInfoObj.BladeTypeSetObjectId(BladeType)
	.d:BodySite'="" operInfoObj.BodySiteSetObjectId(BodySite)
	.s operInfoObj.Note=Note
	.s operInfoObj.Surgeon=Surgeon
	.s operInfoObj.Assistant=Assistant
	.s operInfoObj.OperNote=OperNote
	.s operInfoObj.ExternalID=opaId
	.s sc=operInfoObj.%Save()
	.s:$$$ISERR(sc) fe=1
	.q:$$$ISERR(sc)
	.i (StatusCode="A")||(StatusCode="") d
	..s planOperInfoObj=##class(CIS.AN.PlanOperList).%New() //拟施手术
	..s planOperInfoObj.OperSchedule=OperSchedule
	..s planOperInfoObj.Operation=OperationObj
	..s operClassId=""
	..s:(OperationObj'="")&&(OperationObj.OperClass'="") operClassId=OperationObj.OperClass.%Id()
	..d:operClassId'="" planOperInfoObj.OperClassSetObjectId(operClassId)
	..d:BladeType'="" planOperInfoObj.BladeTypeSetObjectId(BladeType)
	..d:BodySite'="" planOperInfoObj.BodySiteSetObjectId(BodySite)
	..s planOperInfoObj.Note=Note
	..s planOperInfoObj.Surgeon=Surgeon
	..s planOperInfoObj.Assistant=Assistant
	..s planOperInfoObj.OperNote=OperNote
	..s planOperInfoObj.ExternalID=opaId
	..s sc=planOperInfoObj.%Save()
	..s:$$$ISERR(sc) fe=1
	q:fe=1 "E^"_$system.Status.GetErrorText(sc)_"^opaId:"_opaId
	q "S^"
Error 
	q "E^"_$ze_"^opaId:"_opaId
}

/// w ##class(CIS.AN.BL.Interface).ImportDemoMenu("dhcan.datacategoryitem","分类数据项维护","dhcan.datacategoryitem.csp","1721","4")
ClassMethod ImportDemoMenu(Code As %String, Caption As %String, LinkUrl As %String, ParentId As %String, Seq As %String)
{
	s $zt="Error"
	s errorInfo=""
	s obj=##class(User.BDPMenu).%New()
	s obj.Code=Code
	s obj.Caption=Caption
	s obj.LinkUrl=LinkUrl
	d:ParentId'="" obj.ParentMenuDrSetObjectId(ParentId)
	s obj.Sequence=Seq
	s obj.FirstPYCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption)
	s obj.WholePYCODE=##class(web.DHCBL.BDP.FunLib).GetCNCODE(Caption,3,"")
	s obj.ActiveFlag="1^1^1"
	s sc=obj.%Save()
	q "S^操作成功"
Error
	q "E^"_$ze
}

/// w ##class(CIS.AN.BL.Interface).ImportDemoMenuList()
ClassMethod ImportDemoMenuList()
{
	s menuId=0,fe=0,errorInfo=""
	TSTART
	f  s menuId=$o(^CF.AN.MenuD(menuId)) q:(menuId="")||(fe=1)  d
	.s curData=^CF.AN.MenuD(menuId)
	.s retInfo=..ImportDemoMenu($List(curData,2),$List(curData,3),$List(curData,4),$List(curData,5),$List(curData,6))
	.i $p(retInfo,"^",1)="E" d
	..s fe=1
	..s errorInfo=retInfo
	i errorInfo'="" TRollBack  q errorInfo
	TCOMMIT
	q "S^操作完毕"
}

/// 菜单维护码表
/// w ##class(CIS.AN.BL.Interface).AddANMenuConfig("dhcan.legend","图例维护","dhcan.legend.csp","1721","1")
ClassMethod AddANMenuConfig(Code As %String, Caption As %String, LinkUrl As %String, ParentId As %String, Seq As %String)
{
	TStart
	s errorInfo=""
	s obj=##class(CF.AN.Menu).%New()
	s obj.Code=Code
	s obj.Captain=Caption
	s obj.LinkUrl=LinkUrl
	s obj.ParentId=ParentId
	s obj.Seq=Seq
	s sc=obj.%Save()
	i $$$ISERR(sc) d
	.s errorInfo=$system.Status.GetErrorText(sc)
	i errorInfo'="" TRollBack  q errorInfo
	TCOMMIT
	q "S^操作成功"
}

/// Creator：      	唐潇
/// CreatDate：    	2019-01-17
/// Description： 	手术信息回传(暂时只回传状态)
/// Table：        	CT.AN.Operation
/// Input:			opaId
/// Return：       	S^操作成功   E^错误信息
/// w ##class(CIS.AN.BL.Interface).UpdateOpaInfo(opsId)
ClassMethod UpdateOpaInfo(opsId)
{
	s operScedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s opaId=operScedule.ExternalID
	s status=""
	s:operScedule.Status.Code="Application" status="A"
	s:operScedule.Status.Code="Audit" status="A"
	s:operScedule.Status.Code="Arrange" status="R"
	s:operScedule.Status.Code="RoomIn" status="I"
	s:operScedule.Status.Code="RoomOut" status="L"
	s:operScedule.Status.Code="PACUIn" status="P"
	s:operScedule.Status.Code="Finish" status="F"
	s:operScedule.Status.Code="Cancel" status="D"
	s:operScedule.Status.Code="Decline" status="D"
	s:status'="" $p(^DHCANOPArrange(opaId),"^",27)=status
}

ClassMethod SubmitArrange(opsId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="R"
	set operRoomCode=operSchedule.OperRoom.Code
	set oldRoomId=""
	&sql(select %ID into :oldRoomId from SQLUser.DHC_ANC_OperRoom where OPR_Code=:operRoomCode)
	set operArrange.OPAOpRoomDr=##class(User.DHCANCOperRoom).%OpenId(oldRoomId)
	set operArrange.OPASeq=operSchedule.OperSeq
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set ret=..UpdateOperNurse(operSchedule.OperDate,opaId,operSchedule.ScrubNurse,"D",userId)
	quit:($p(ret,"^",1)="E") ret
	set ret=..UpdateOperNurse(operSchedule.OperDate,opaId,operSchedule.CircualNurse,"T",userId)
	quit:($p(ret,"^",1)="E") ret
	quit "S^"
}

// w ##class(CIS.AN.BL.Interface).UpdateOperNurse("65094","74","80","D","3")

ClassMethod UpdateOperNurse(opDate As %String, opaIdStr As %String, nurStr As %String, nurType As %String, userId As %String) As %String
{

 s ^TMPCCQ(nurType)=opDate_"^"_opaIdStr_"^"_nurStr_"^"_userId
	//AnNurse,ScrubNurse,ExScrubNurse,CirculNurse,ExCirculNurse   A,D,J,T,X
 //麻醉护士，器械护士，交器械护士，巡回护士，交巡回护士
 i opDate'="" s nowDate=opDate  //##Class(web.DHCClinicCom).ConvertToDateH(opDate)
 e  s nowDate=+$H
 s nowTime=$P($H,",",2)
 s upDate=+$H 
 s retStr="S^"
 s nurStr=$tr(nurStr,",","^")
 s SQLCODE=-1
 f i=1:1:$l(opaIdStr,"^") d
	 .s opaId=$p(opaIdStr,"^",i)
	 .q:opaId=""
	 .//b //ccq3
	 .s roomId=$P($G(^DHCANOPArrange(opaId)),"^",20)
	 .i roomId="" s retStr="E^未安排手术间"
	 .q:roomId=""
	 .s arrId="" f  s arrId=$O(^DHCANArr(0,"AnArrDate",nowDate,arrId)) q:arrId=""  d
		 ..s arrOpDr=$P($G(^DHCANArr(arrId)),"^",4)
		 ..q:arrOpDr'=opaId
		 ..s arrNurDoc=$P($G(^DHCANArr(arrId)),"^",6)
		 ..q:arrNurDoc'="N"
		 ..s nurCat=$P($G(^DHCANArr(arrId)),"^",8)
		 ..q:nurCat'=nurType
		 ..&SQL(delete from SQLUser.DHC_AN_Arrange  where AN_Arr_RowId=:arrId)
		 ..i SQLCODE'=0  s retStr="E^删除护士失败!" q
	 .q:$p(retStr,"^",1)="E"
	 .s num=$L(nurStr,"^")
	 .//b //ccq
	 .f j=1:1:num d
		 ..s ctcpDr=$P(nurStr,"^",j)
		 ..q:ctcpDr=""
		 ..s arrNurDoc="N"
		 ..s docCat=""
		 ..s nurCat=nurType
		 ..s ctcpNum=j
		 ..;b //ccq2
		 ..&SQL(insert into SQLUser.DHC_AN_Arrange (AN_Arr_Date,AN_Arr_Time,AN_Arr_Room_DR,AN_Arr_Op_DR,AN_Arr_Ctcp_DR,AN_Arr_NurDoc,AN_Arr_DocCat,AN_Arr_NurCat,AN_Arr_CtcpNum,AN_Arr_UpdateDate,AN_Arr_UpdateTime,AN_Arr_UpdateUserId) values (:nowDate,:nowTime,:roomId,:opaId,:ctcpDr,:arrNurDoc,:docCat,:nurCat,:ctcpNum,:upDate,:nowTime,:userId))
		 ..i SQLCODE'=0  s retStr="E^护士插入失败!" q
 quit:($p(retStr,"^",1)="E") retStr
 set syncRet=##class(web.DHCANOPArrange).UpdateAllAnOpArr(opDate,opaIdStr,nurType)
 set:(syncRet'="") retStr="E^"_syncRet
 q retStr
}

ClassMethod AcceptArrange(opsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="AT"
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

ClassMethod RevokeArrange(opsId As %String, statusCode As %String = "R") As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)	
	set opaId=operSchedule.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus=statusCode
	set operArrange.OPAOpRoomDr=""
	set operArrange.OPASeq=""
	set sc=operArrange.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

}
