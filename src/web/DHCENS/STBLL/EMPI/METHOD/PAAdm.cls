/// 患者就诊信息
Class web.DHCENS.STBLL.EMPI.METHOD.PAAdm Extends (%RegisteredObject, %XML.Adaptor)
{

/// 服务编码	T0015
/// 服务名称	患者入院登记信息查询
/// 服务所在类	web.DHCENS.STBLL.EMPI.METHOD.PAAdm
/// 方法名称	IpPAAdm
/// 方法入参	就诊RowID
/// 2016-5-31   lyh
/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).IpPAAdm("116162").Read()
ClassMethod IpPAAdm(admRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set PatDr=$P($g(^PAADM(admRowId)),"^",1)
	set Pat=##class(web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew).%New()
	set Pat=##class(web.DHCENS.STBLL.EMPI.METHOD.Patient).PAPatientByPatId(PatDr)
	set body.PATPatientInfo=Pat
	
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.IpPAAdm).%New()
	q:(($d(admRowId)=0)||(admRowId="")) request	
	set Obj.PAADMVisitNumber=admRowId
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)
	set Obj.PAADMEncounterTypeCode=AdmTypeCode
	set Obj.PAADMEncounterTypeDesc=""
		
	//入院医生
	set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	if AdmDoctorRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
		set:userId'="" Obj.PAADMAdmitDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
		set:userId'="" Obj.PAADMAdmitDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	}
	//入院时间
	set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	set:AdmDate'="" Obj.PAADMStartDate=$zd(AdmDate,3)
	set:AdmTime'="" Obj.PAADMStartTime=$zt(AdmTime)
	//入院科室,病区,床号
	set TRANSChildsub="",AdmDeptRowID="",TmpDeptRowID="",Bed=""
	set AdmWardCode="",AdmWardRowID="",AdmWardDesc=""
	f  s TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	.s Bed=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",8)
	.s TmpDeptRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",6)
	.s AdmWardRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",9)
	.if TmpDeptRowID'=""  d
	..s AdmDeptRowID=TmpDeptRowID
	
	//费别 2019-10-29
	s feetypeid=$p($g(^PAADM(admRowId,1)),"^",7)
	s feetypecode=$p($g(^PAC("ADMREA",feetypeid)),"^",1)
	s feetypedesc=$p($g(^PAC("ADMREA",feetypeid)),"^",2)
	s Obj.FeeTypeCode=feetypecode
	s Obj.FeeTypeDesc=feetypedesc
	s Obj.PAADMVisitTimes=$p($g(^PAADM(admRowId)),"^",29) //2019-11-06 
	if AdmDeptRowID'=""  {		
		set Obj.PAADMAdmDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMAdmDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)	
	}
	if AdmWardRowID'="" 
	{
		s AdmWardCode=$p($g(^PAWARD(AdmWardRowID)),"^",1)
		s AdmWardDesc=$p($g(^PAWARD(AdmWardRowID)),"^",2)
		s:AdmWardDesc["-" AdmWardDesc=$p($g(AdmWardDesc),"-",2)
		s Obj.PAADMAdmWardCode=AdmWardCode
		s Obj.PAADMAdmWardDesc=AdmWardDesc
	}
	s CurrentBedRowID=$P($g(^PAADM(admRowId)),"^",73)
	
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			s Obj.PAADMCurBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	//诊断信息
	set mainmradmdr = $p($g(^PAADM(admRowId)),"^",61)
	if ((mainmradmdr'="")&&($d(^MR(mainmradmdr))'=0)){
		set themrdiachildsub = ""
		set mrdiachildsub = ""
		set i=0
		for {
			set admDiagTypeCode="",admDiagTypeDesc=""
			set mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
			Quit:(mrdiachildsub="") 
			if (mrdiachildsub'=0) {
			    set admDiagTypeId=$g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",1))
		        set:admDiagTypeId'="" admDiagTypeCode=$p($g(^MRC("DTYP",admDiagTypeId)),"^",1)
		        set:admDiagTypeId'="" admDiagTypeDesc=$p($g(^MRC("DTYP",admDiagTypeId)),"^",2)
			    set themrdiachildsub = mrdiachildsub
			    set mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
		        if (mricdid="") {
			        set mricdCode=""
			        set mricdDesc=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
			    }
			    else {
			        set mricdCode = $p($g(^MRC("ID",mricdid)),"^",1)
			        set mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
			    }
			    set docId=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",12)
			    set diagDate=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",7)
			    set diagTime=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",8)
			    set diaObj=##class(web.DHCENS.STBLL.EMPI.MODEL.PADiagnose).%New()
			    set diaObj.PADDiagCode=mricdCode
			    set diaObj.PADDiagDesc=mricdDesc
			    set:admDiagTypeCode="" admDiagTypeCode="M"
			    set diaObj.PADDiagTypeCode=admDiagTypeCode
			    set diaObj.PADDiagTypeDesc=admDiagTypeDesc
			    set i=i+1
			    if i=1{
				    set diaObj.PADDiagCategory="主要诊断"
				}else{
					set diaObj.PADDiagCategory="次要诊断"
				}
				if docId'="" {
					set userId=docId
					set:userId'="" diaObj.PADDiagDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
					set:userId'="" diaObj.PADDiagDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
				}
				if diagDate'="" {
					set diaObj.PADDiagDate=$zd(diagDate,3)
				}
				if diagTime'="" {
					set diaObj.PADDiagTime=$zt(diagTime)
				}
				set diaObj.PADRemarks=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1)),"^")
			    d Obj.PAADMDiagnose.Insert(diaObj)
			}
		}
	}
	
	//最后更新时间,更新人
	set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	if UpdateDate'="" {
		set Obj.UpdateDate=$zd(UpdateDate,3)
	}
	if UpdateTime'="" {
		set Obj.UpdateTime=$zt(UpdateTime)
	}
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	d body.IpPAAdms.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// 服务编码	T0015
/// 服务名称	门诊患者挂号信息查询
/// 服务所在类	web.DHCENS.STBLL.EMPI.METHOD.PAAdm
/// 方法名称	OpPAAdm
/// 方法入参	就诊RowID
/// 2016-5-31   lyh
/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).OpPAAdm("1")
ClassMethod OpPAAdm(admRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.OpPAAdm).%New()
	q:(($d(admRowId)=0)||(admRowId="")) request	
	set Obj.PAADMVisitNumber=admRowId
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)
	s Obj.PAADMEncounterTypeCode=AdmTypeCode
	s Obj.PAADMEncounterTypeDesc=""
	
	//就诊医生
	set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	if AdmDoctorRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
		set:userId'="" Obj.PAADMOPDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
		set:userId'="" Obj.PAADMOPDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	}
	//就诊时间
	set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	set:AdmTime'="" AdmTime=$zt(AdmTime)
	set Obj.PAADMOPTime=AdmDate_" "_AdmTime
	//就诊科室
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set Obj.PAADMOPDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMOPDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set DeptshortDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",86)
		set:DeptshortDesc'="" Obj.PAADMOOPShortDeptDesc=DeptshortDesc
		set:DeptshortDesc="" Obj.PAADMOOPShortDeptDesc=Obj.PAADMOPDeptDesc
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	//最后更新时间,更新人
	set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	set timeRangeInfo=..TimeRange(admRowId)
	if timeRangeInfo'="" {
		set Obj.PAADMOPNo=$p(timeRangeInfo,"^",1)
		set Obj.PAADMOPTimeRange=$p(timeRangeInfo,"^",2)
		set Obj.PAADMOPRoomCode=$p(timeRangeInfo,"^",3)
		set Obj.PAADMOPQueueNumberStatus=$p(timeRangeInfo,"^",4)
	}
	if UpdateDate'="" {
		set Obj.UpdateDate=$zd(UpdateDate,3)
	}
	if UpdateTime'="" {
		set Obj.UpdateTime=$zt(UpdateTime)
	}
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	d body.OpPAAdms.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：duanhaihua
/// CreatDate：2016—06-19
/// Description：获取患者退号信息
/// Table：
/// Input：
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).OpPAAdmCancel("2869")
ClassMethod OpPAAdmCancel(admRowId As %String) As %GlobalCharacterStream
{
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.AdmStatus).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set $zt="Exception"
	if (($d(admRowId)=0)||(admRowId="")) {
		set request.body=body
		do request.XMLExportToStream(.stream)
		set (request,header,body,Obj)=""
		Quit stream
	}	
	set Obj.PAADMVisitNumber=admRowId
	
	//就诊科室
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set Obj.PAADMDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	//最后更新时间,更新人
	set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	if UpdateDate'="" {
		set Obj.UpdateDate=$zd(UpdateDate,3)
	}
	if UpdateTime'="" {
		set Obj.UpdateTime=$zt(UpdateTime)
	}
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	d body.OpAdmCancel.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	Quit stream
Exception
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：duanhaihua
/// CreatDate：2016—06-19
/// Description：获取患者取消住院信息
/// Table：
/// Input：
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).IpPAAdmCancel("1")
ClassMethod IpPAAdmCancel(admRowId As %String) As %GlobalCharacterStream
{
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.AdmStatus).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set $zt="Exception"
	if (($d(admRowId)=0)||(admRowId="")) {
		set request.body=body
		do request.XMLExportToStream(.stream)
		set (request,header,body,Obj)=""
		Quit stream
	}	
	set Obj.PAADMVisitNumber=admRowId
	//就诊科室
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set Obj.PAADMDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	//最后更新时间,更新人
	set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	if UpdateDate'="" {
		set Obj.UpdateDate=$zd(UpdateDate,3)
	}
	if UpdateTime'="" {
		set Obj.UpdateTime=$zt(UpdateTime)
	}
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	d body.IpAdmCancel.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	Quit stream
Exception
	set request.body=body
	do request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	Quit stream
}

/// Creator：duanhaihua
/// CreatDate：2016—06-19
/// Description：获取患者退号信息
/// Table：
/// Input：
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).OutChargePAAdmCancel("1")
ClassMethod OutChargePAAdmCancel(admRowId As %String) As %GlobalCharacterStream
{
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.AdmStatus).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set $zt="Exception"
	if (($d(admRowId)=0)||(admRowId="")) {
		set request.body=body
		do request.XMLExportToStream(.stream)
		set (request,header,body,Obj)=""
		Quit stream
	}	
	set Obj.PAADMVisitNumber=admRowId
	//就诊科室
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set Obj.PAADMDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	//最后更新时间,更新人
	set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	if UpdateDate'="" {
		set Obj.UpdateDate=$zd(UpdateDate,3)
	}
	if UpdateTime'="" {
		set Obj.UpdateTime=$zt(UpdateTime)
	}
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	d body.OutChargeCancel.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	Quit stream
Exception
	set request.body=body
	do request.XMLExportToStream(.stream)
	set (request,header,body,Obj)=""
	Quit stream
}

/// Creator：duanhaihua
/// CreatDate：2016—06-19
/// Description：获取患者出院登记信息
/// Table：
/// Input：
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).OutChargePAAdm("106273")
ClassMethod OutChargePAAdm(admRowId As %String) As %GlobalCharacterStream
{
	set request=##class(web.DHCENS.STBLL.EMPI.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.EMPI.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.EMPI.MODEL.Body).%New()
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.DisCharge).%New()
	set stream=##class(%GlobalCharacterStream).%New()
	set $zt="Exception"
	if (($d(admRowId)=0)||(admRowId="")) {
		set request.body=body
		do request.XMLExportToStream(.stream)
		Quit stream
	}	
	set Obj.PAADMVisitNumber=admRowId
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	//出院情况代码
	set DisChargCondRowID = $P($G(^PAADM(admRowId)),"^",49)
	if DisChargCondRowID'="" {
		set DisChargCondCode=$p($g(^PAC("DISCON",DisChargCondRowID)),"^",1)
		set Obj.PAADMDisStatusCode=DisChargCondCode

	}
	//出院日期时间
	set EndDate= $P($G(^PAADM(admRowId)),"^",17)
	set EndTime=$P($G(^PAADM(admRowId)),"^",18)
	set:EndDate'="" EndDate=$zd(EndDate,3)
	set:EndTime'="" EndTime=$zt(EndTime)
	set Obj.PAADMEndDate=EndDate
	set Obj.PAADMEndTime=EndTime
	//出院科室
	set AdmDeptRowID=$p($g(^PAADM(admRowId)),"^",4)	
	if AdmDeptRowID'=""  {		
		set Obj.PAADMDisDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		//set Obj.PAADMOPDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.HospitalCode=$p($g(^CT("HOSP",hopitalId)),"^",1)
	}
	s CurrentWardRowID=$P($g(^PAADM(admRowId)),"^",70)
	s:CurrentWardRowID'="" Obj.PAADMDisWardCode=$p($g(^PAWARD(CurrentWardRowID)),"^",1)
	//最后更新时间,更新人
	set UpdateDate=$p($g(^PAADM(admRowId,1)),"^",42)
	set UpdateTime=$p($g(^PAADM(admRowId,1)),"^",43)
	set UpdateUserDr=$p($g(^PAADM(admRowId,1)),"^",44)
	if UpdateDate'="" {
		set Obj.UpdateDate=$zd(UpdateDate,3)
	}
	if UpdateTime'="" {
		set Obj.UpdateTime=$zt(UpdateTime)
	}
	if UpdateUserDr'="" {
		set Obj.UpdateUserCode=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",1)
		set Obj.UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	else {
		set Obj.UpdateUserCode="-"
		set Obj.UpdateUserDesc="-"
	}
	d body.OutCharge.Insert(Obj)
	set request.body=body
	d request.XMLExportToStream(.stream)
	Quit stream
Exception
	Quit "-1^"_$ze
}

/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).TimeRange("1")
ClassMethod TimeRange(admRowid As %String) As %String
{
	s RegfeeNo="",TimeRangeCode="",RBASId="",CallStatus="",roomCode="",RegFeeDr=""
	;s RegAdm=" "_admRowid 
    ;s RegFeeDr=$o(^User.DHCRegistrationFeeI("ADM",RegAdm,""))
	&SQL(SELECT ID into :RegFeeDr FROM SQLUser.DHCRegistrationFee Where RegfeeAdmDr=:admRowid)
    i RegFeeDr'=""  {
	    s Str=$g(^User.DHCRegistrationFeeD(RegFeeDr))
    	s RBASId=$li(Str,18)
    	s RegfeeNo=$li(Str,8)
		s roomDr=$li(Str,20)
		if roomDr'="" d 
		.s roomCode=$p($g(^CTLOC(roomDr)),"^",2)
		.s roomCode=$e(roomCode,$l(roomCode)-1,$l(roomCode))
		s QueueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",admRowid,""))
		Quit:QueueDr=""
		//1 优先 2 正常
		s QueFirstDr=$li($g(^User.DHCQueueD(QueueDr)),7)
		//1 复诊 2 等候 3 过号 4 到达 5 退号 6 未分配 7 报道
		s QueStateDr=$li($g(^User.DHCQueueD(QueueDr)),14)
		i QueFirstDr=1 {
			if QueStateDr=1 {
				s CallStatus=4
			}
			else {
				s CallStatus=2
			}
		}
		else{
			i QueStateDr=1 {
				s CallStatus=3
			}
			elseif QueStateDr=2 {
				s CallStatus=0
			}
		}	
		//复诊时取复诊顺序号
		s ReSeqNo=$lg(^User.DHCQueueD(QueueDr),26)
		i (ReSeqNo'="")&&(QueStateDr=1){
			s RegfeeNo=ReSeqNo
		}
    }
    q:RBASId="" "^"
    s ResRowId=$P(RBASId,"||",1)
	s ASChildSub=$P(RBASId,"||",2)
	s RBASSessionTypeId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",6)
	i RBASSessionTypeId'="" s RBASSessionType=$P(^RBC("SESS",RBASSessionTypeId),"^",2)
	s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)    //就诊时段
	i TRRowId="" {
		//s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(ASSessStartTime)
		//set TimeRangeCode=##class(web.DHCOPAdmReg).GetAdmTimeBySeqNo(RBASId,RegfeeNo)
	}
	else {
		s TimeRangeDesc=$P(^DHCTimeRange(TRRowId),"^",2) 
		s TimeRangeCode=$P(^DHCTimeRange(TRRowId),"^",1)
	}
	Quit RegfeeNo_"^"_TimeRangeCode_"^"_roomCode_"^"_CallStatus
}

/// Creator：Zhanglinyun
/// CreatDate：2019—06-21
/// Description：根据患者AdmNo获取患者就诊信息
/// Table：
/// Input：patRowId：患者AdmNo
/// Output：
/// Return：患者就诊信息model
/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdm("224")
ClassMethod PAAdmInfoByAdm(admRowId As %String) As web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo
{
	set $zt="Exception"
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	q:(($d(admRowId)=0)||(admRowId="")) Obj	
	set Obj.PAADMVisitNumber=admRowId
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)
	set Obj.PAADMTypeCode=AdmTypeCode
	set Obj.PAADMTypeDesc=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"急诊","H":"体检","N":"新生儿")
	//门特病人判断
	if (AdmTypeCode="I")&&(##class(websys.Conversions).IsValidClassName("DHCDoc.Local.SpecialIllAdm"))  {
		set SpecIllAdm=##class(DHCDoc.Local.SpecialIllAdm).IsSpecIllAdm(admRowId)
		if SpecIllAdm="1"
		{
			set Obj.PAADMTypeCode="O"
			set Obj.PAADMTypeDesc="门诊"
		}

	}
	s AdmStatusCode=$p($g(^PAADM(admRowId)),"^",20)
	s Obj.PAAdmStatusCode=AdmStatusCode
	s Obj.PAAdmStatusDesc=$case(AdmStatusCode,"A":"在就诊","C":"取消就诊","D":"出院","P":"预约")
	
	s FeeTypeRowID=$p($g(^PAADM(admRowId,1)),"^",7)
	s:FeeTypeRowID'="" Obj.PAADMFeeTypeCode=$p($g(^PAC("ADMREA",FeeTypeRowID)),"^",1)
	s:FeeTypeRowID'="" Obj.PAADMFeeTypeDesc=$p($g(^PAC("ADMREA",FeeTypeRowID)),"^",2)
	
	s Obj.PAADMVisitTimes=$p($g(^PAADM(admRowId)),"^",29)
	//入院医生
	set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	if AdmDoctorRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
		set:userId'="" Obj.PAADMDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
		set:userId'="" Obj.PAADMDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	}
	//入院时间
	set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	set:AdmDate'="" Obj.PAADMStartDate=$zd(AdmDate,3)
	set:AdmTime'="" Obj.PAADMStartTime=$zt(AdmTime)
	//入院科室,病区,床号
	set TRANSChildsub="",AdmDeptRowID="",TmpDeptRowID="",Bed=""
	set AdmWardCode="",AdmWardRowID="",AdmWardDesc=""
	f  s TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	.s Bed=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",8)
	.s TmpDeptRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",6)
	.s AdmWardRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",9)
	.if TmpDeptRowID'=""  d
	..s AdmDeptRowID=TmpDeptRowID
	if AdmDeptRowID'=""  {		
		set Obj.PAADMDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.PAADMHosCode=$p($g(^CT("HOSP",hopitalId)),"^",1) 
		set:hopitalId'="" Obj.PAADMHosDesc=$p($g(^CT("HOSP",hopitalId)),"^",2) 
	}
	if AdmWardRowID'="" 
	{
		s AdmWardCode=$p($g(^PAWARD(AdmWardRowID)),"^",1)
		s AdmWardDesc=$p($g(^PAWARD(AdmWardRowID)),"^",2)
		s:AdmWardDesc["-" AdmWardDesc=$p($g(AdmWardDesc),"-",2)
		s Obj.PAADMAdmWardCode=AdmWardCode
		s Obj.PAADMAdmWardDesc=AdmWardDesc
	}
	s CurrentDetpRowID=""
	s CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	s:CurrentDetpRowID'="" Obj.PAADMCurDeptCode=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	s:CurrentDetpRowID'="" Obj.PAADMCurDeptDesc=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	
	s CurrentBedRowID=$P($g(^PAADM(admRowId)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			s Obj.PAADMCurBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	s Obj.Charger=""
	s Obj.ChargeDate=""
	s CurrentRoomRowID=$P($g(^PAADM(admRowId)),"^",69)
	s:CurrentRoomRowID'="" Obj.PAADMAdmRoomCode=$p($g(^PAROOM(CurrentRoomRowID)),"^",1)
	s:CurrentRoomRowID'="" Obj.PAADMAdmRoomDesc=$p($g(^PAROOM(CurrentRoomRowID)),"^",2)
	q Obj
Exception
	s Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	Quit Obj
}

/// 专供检验就诊类型转码使用wxl2019-11-15
/// LIS系统只有 门诊2、住院1、体检5 
ClassMethod PAAdmInfoByAdmToLIS(admRowId As %String) As web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo
{
	set $zt="Exception"
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	q:(($d(admRowId)=0)||(admRowId="")) Obj	
	set Obj.PAADMVisitNumber=admRowId
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set AdmTypeCode=$p($g(^PAADM(admRowId)),"^",2)	
	set Obj.PAADMTypeCode=$case(AdmTypeCode,"O":"2","I":"1","E":"2","H":"5","N":"1",:"")
	set Obj.PAADMTypeDesc=$case(AdmTypeCode,"O":"门诊","I":"住院","E":"门诊","H":"体检","N":"住院")
	//门特病人判断
	if AdmTypeCode="I"  {
		set SpecIllAdm=##class(DHCDoc.Local.SpecialIllAdm).IsSpecIllAdm(admRowId)
		if SpecIllAdm="1"
		{
			set Obj.PAADMTypeCode="2"
			set Obj.PAADMTypeDesc="门诊"
		}

	}
	s AdmStatusCode=$p($g(^PAADM(admRowId)),"^",20)
	s Obj.PAAdmStatusCode=AdmStatusCode
	s Obj.PAAdmStatusDesc=$case(AdmStatusCode,"A":"在就诊","C":"取消就诊","D":"出院","P":"预约")
	
	s FeeTypeRowID=$p($g(^PAADM(admRowId,1)),"^",7)
	s:FeeTypeRowID'="" Obj.PAADMFeeTypeCode=$p($g(^PAC("ADMREA",FeeTypeRowID)),"^",1)
	s:FeeTypeRowID'="" Obj.PAADMFeeTypeDesc=$p($g(^PAC("ADMREA",FeeTypeRowID)),"^",2)
	
	s Obj.PAADMVisitTimes=$p($g(^PAADM(admRowId)),"^",29)
	//入院医生
	set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	if AdmDoctorRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
		set:userId'="" Obj.PAADMDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
		set:userId'="" Obj.PAADMDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
	}
	//入院时间
	set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	set:AdmDate'="" Obj.PAADMStartDate=$zd(AdmDate,3)
	set:AdmTime'="" Obj.PAADMStartTime=$zt(AdmTime)
	//入院科室,病区,床号
	set TRANSChildsub="",AdmDeptRowID="",TmpDeptRowID="",Bed=""
	set AdmWardCode="",AdmWardRowID="",AdmWardDesc="",AdmWardRoomRowID=""
	f  s TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	.s Bed=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",8)
	.s TmpDeptRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",6)
	.s AdmWardRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",9)
	.s AdmWardRoomRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",7)
	.if TmpDeptRowID'=""  d
	..s AdmDeptRowID=TmpDeptRowID
	if AdmDeptRowID'=""  {		
		set Obj.PAADMDeptCode=$p($g(^CTLOC(AdmDeptRowID)),"^",1)
		set Obj.PAADMDeptDesc=$p($g(^CTLOC(AdmDeptRowID)),"^",2)
		set hopitalId=$p($g(^CTLOC(AdmDeptRowID)),"^",22)
		set:hopitalId'="" Obj.PAADMHosCode=$p($g(^CT("HOSP",hopitalId)),"^",1) 
	}
	if AdmWardRowID'="" 
	{
		s AdmWardCode=$p($g(^PAWARD(AdmWardRowID)),"^",1)
		s AdmWardDesc=$p($g(^PAWARD(AdmWardRowID)),"^",2)
		s:AdmWardDesc["-" AdmWardDesc=$p($g(AdmWardDesc),"-",2)
		s Obj.PAADMAdmWardCode=AdmWardCode
		s Obj.PAADMAdmWardDesc=AdmWardDesc
	}
	if AdmWardRoomRowID'="" 
	{
		s AdmWardRoomCode=$p($g(^PAROOM(AdmWardRoomRowID)),"^",1)
		s AdmWardRoomDesc=$p($g(^PAROOM(AdmWardRoomRowID)),"^",2)
		s Obj.PAADMAdmRoomCode=AdmWardRoomCode
		s Obj.PAADMAdmRoomDesc=AdmWardRoomDesc
	}
	s CurrentDetpRowID=""
	s CurrentDetpRowID=$P($g(^PAADM(admRowId)),"^",4)
	s:CurrentDetpRowID'="" Obj.PAADMCurDeptCode=$p($g(^CTLOC(CurrentDetpRowID)),"^",1)
	s:CurrentDetpRowID'="" Obj.PAADMCurDeptDesc=$p($g(^CTLOC(CurrentDetpRowID)),"^",2)
	
	s CurrentBedRowID=$P($g(^PAADM(admRowId)),"^",73)
	i ($d(CurrentBedRowID)'=0)&&(CurrentBedRowID'="")&&($l(CurrentBedRowID,"||")>1)
	{
		s BedWordRowID = $p(CurrentBedRowID,"||",1)
		s BedChildSub = $p(CurrentBedRowID,"||",2)
		i $d(^PAWARD(BedWordRowID,"BED"))=10
		{
			s Obj.PAADMCurBedNo=$p($g(^PAWARD(BedWordRowID,"BED",BedChildSub)),"^",1)
		}
	}
	s Obj.Charger=""
	s Obj.ChargeDate=""
	q Obj
Exception
	s Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.PAAdmInfo).%New()
	Quit Obj
}

/// Creator：Zhanglinyun
/// CreatDate：2019—11-19
/// Description：根据患者AdmNo获取患者就诊信息
/// Table：
/// Input：patRowId：患者AdmNo
/// Output：
/// Return：患者就诊信息model
/// test: w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).PAAdmInfoByAdm("224")
ClassMethod PAAdmInfoByadmStream(admRowId As %String) As %GlobalCharacterStream
{
	set $zt="Exception"
	set Obj=##class(web.DHCENS.STBLL.EMPI.MODEL.VNISBASICINFO).%New()
	set patRowId=$p($g(^PAADM(admRowId)),"^",1)
	set Obj.PATIENTID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
	set Obj.VISITID=$p($g(^PAADM(admRowId)),"^",29)
	set Obj.INPNO=admRowId
	set sexRowID=$p($g(^PAPER(patRowId,"ALL")),"^",7)
	if sexRowID'="" {
		set sexCode=$p($g(^CT("SEX",sexRowID)),"^",1)
		set sexDesc=$p($g(^CT("SEX",sexRowID)),"^",2)
		set Obj.SEX=sexCode
	}
	set birthDay=$p($g(^PAPER(patRowId,"ALL")),"^",6)
	set:birthDay'="" Obj.DATEOFBIRTH=$zd(birthDay,3)	
	set Obj.NAME=$p($g(^PAPER(patRowId,"ALL")),"^",1)
	set PAADMStartDate="",PAADMStartTime=""
	set AdmDate= $P($G(^PAADM(admRowId)),"^",6)
	set AdmTime=$P($G(^PAADM(admRowId)),"^",7)
	set:AdmDate'="" PAADMStartDate=$zd(AdmDate,3)
	set:AdmTime'="" PAADMStartTime=$zt(AdmTime)
	set Obj.ADMISSIONDATETIME=PAADMStartDate_" "_PAADMStartTime
	//入院科室,病区,床号
	set TRANSChildsub="",AdmDeptRowID="",TmpDeptRowID="",Bed=""
	set AdmWardCode="",AdmWardRowID="",AdmWardDesc=""
	f  s TRANSChildsub=$o(^PAADM(admRowId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Bed'="")  d
	.s Bed=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",8)
	.s TmpDeptRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",6)
	.s AdmWardRowID=$p($g(^PAADM(admRowId,"TRANS",TRANSChildsub)),"^",9)
	if AdmWardRowID'="" 
	{
		set AdmWardCode=$p($g(^PAWARD(AdmWardRowID)),"^",1)
		set Obj.DEPTADMISSIONTO=AdmWardCode
	}
	s CurrentWardRowID=$P($g(^PAADM(admRowId)),"^",70)
	s:CurrentWardRowID'="" Obj.DEPTDISCHARGEFROM=$p($g(^PAWARD(CurrentWardRowID)),"^",1)
	//出院日期时间
	set EndDate="", EndTime=""
	set EndDate= $P($G(^PAADM(admRowId)),"^",17)
	set EndTime=$P($G(^PAADM(admRowId)),"^",18)
	set:EndDate'="" EndDate=$zd(EndDate,3)
	set:EndTime'="" EndTime=$zt(EndTime)
	set Obj.DISCHARGEDATETIME=EndDate_" "_EndTime
	set Obj.DISCHARGETYPE=""
	set Obj.TOTALCOST=""
	set AdmDoctorRowID = $P($G(^PAADM(admRowId)),"^",9)
	if AdmDoctorRowID'="" {
		set userId=$o(^SSU("SSUSR",0,"CTPCP",AdmDoctorRowID,""))
		set:userId'="" PAADMOPDocCode=$p($g(^SSU("SSUSR",userId)),"^",1)
		set:userId'="" PAADMOPDocDesc=$p($g(^SSU("SSUSR",userId)),"^",2)
		set Obj.ATTENDINGDOCTOR=PAADMOPDocDesc_"("_PAADMOPDocCode_")"
	}	
	d Obj.XMLExportToStream(.xml)
	q xml
Exception
	s xml=##class(%GlobalCharacterStream).%New()
	d xml.Write("-1"_$ze)
	Quit xml
}

/// w ##class(web.DHCENS.STBLL.EMPI.METHOD.PAAdm).Test()
ClassMethod Test()
{
	set i=0
	set rowId="0"  for  set rowId=$o(^PAADM(rowId)) q:rowId=""  d
	.set typeCode=$p($g(^PAADM(rowId)),"^",2)
	.if typeCode="I" d
	..set sc=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMINFO",rowId)
	.else  d
	..set sc=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPREGINFO",rowId) 
	.set i=i+1
	QUit i
}

}
