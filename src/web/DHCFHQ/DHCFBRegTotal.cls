Class web.DHCFHQ.DHCFBRegTotal Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 取科室挂号数据
ClassMethod GetLocReg(ByRef repid As %Integer = 0, StartDate As %String = "", EndDate As %String = "", USERID As %String) As %Integer
{
	s del="^",RetNum=0
	q:StartDate="" RetNum
	q:EndDate="" RetNum	
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s:USERID="" USERID=1
	s AdmId=0
	s Date=StartDate-1
	f  s Date=$o(^PAADMi("PAADM_AdmDate",Date)) q:((Date>EndDate)!(Date=""))  d
	.s AdmId=0
	.f  s AdmId=$o(^PAADMi("PAADM_AdmDate",Date,AdmId)) q:AdmId=""  d
	..s AdmInfo=##class(web.DHCFHQ.DHCFBPat).GetAdmInfoByAdm(AdmId)
	..q:(AdmInfo="")
	..s AdmType=$p(AdmInfo,del,16)
	..q:AdmType="I"
	..s admdepcode=$p(AdmInfo,del,2)	
	..s depdr=$o(^CTLOC(0,"Code",admdepcode,""))
	..s hosdr=$P(^CTLOC(depdr),"^",22)
	..s userinfo=$g(^SSU("SSUSR",USERID))
	..S userhosid=$p(userinfo,"^",98)	
	..q:((hosdr'=userhosid)&&(userhosid'=2))	
	..s SessionType=""
	..s CtLoc=$p(AdmInfo,del,3)
	..q:CtLoc=""
	..s Doc=$p(AdmInfo,del,12)
	..s VisitStatu=$p(AdmInfo,del,13)
	..s RegType="现场挂号"
	..if ('$d(^User.DHCRegistrationFeeI("ADM"," "_AdmId))) d
	...s SessionType="直接就诊"
	..else  d
	...s:$d(^RBAS("PAADM_DR",AdmId)) RegType="预约挂号"
	...s RegFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_AdmId,""))
	...s SessionTypeDr=$LIST(^User.DHCRegistrationFeeD(RegFeeId),19)
	...s SessionType=$p(^RBC("SESS",SessionTypeDr),del,2)
	..s:$d(^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType)) ^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType)=^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType)+1
	..s:'$d(^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType)) ^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType)=1
	..if VisitStatu="C" d
    ...;s RegType="退号"
    ...;s:$d(^RBAS("PAADM_DR",AdmId)) RegType="预约挂号"
	...s RegFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_AdmId,""))
	...s SessionTypeDr=$LIST(^User.DHCRegistrationFeeD(RegFeeId),19)
	...s SessionType=$p(^RBC("SESS",SessionTypeDr),del,2)
    ...s:$d(^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType,1)) ^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType,1)=^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType,1)+1
	...s:('$d(^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType,1))) ^CacheTempFHQ(repid,0,CtLoc,SessionType,RegType,1)=1
	b
	s CtLoc="",SessionType=""
	f  s CtLoc=$o(^CacheTempFHQ(repid,0,CtLoc)) q:CtLoc=""  d
	.f  s SessionType=$o(^CacheTempFHQ(repid,0,CtLoc,SessionType)) q:SessionType=""  d
	..s AdmStatus=""
	..f  s AdmStatus=$o(^CacheTempFHQ(repid,0,CtLoc,SessionType,AdmStatus)) q:AdmStatus=""  d
	...s RetNum=RetNum+1
	...s RegNumRet=0,RegNum=0
	...s:AdmStatus'="退号" RegNum=^CacheTempFHQ(repid,0,CtLoc,SessionType,AdmStatus)
	...s:($d(^CacheTempFHQ(repid,0,CtLoc,SessionType,AdmStatus,1))) RegNumRet=^CacheTempFHQ(repid,0,CtLoc,SessionType,AdmStatus,1)
	...w RetNum_":"_CtLoc_del_AdmStatus_del_SessionType_del_(+$g(RegNum))_del_(+$g(RegNumRet)),!
	...s ^CacheTempFHQ(repid,RetNum)=$lb(CtLoc,AdmStatus,SessionType,(+$g(RegNum)),(+$g(RegNumRet)))
	.K ^CacheTempFHQ(repid,0,CtLoc)
	q RetNum
}

ClassMethod GetLocDocReg(ByRef repid As %Integer = 0, StartDate As %String = "", EndDate As %String = "", USERID As %String) As %Integer
{
	s del="^",RetNum=0
	;s ^fhqreg(1)=StartDate_":"_EndDate
	q:StartDate="" RetNum
	q:EndDate="" RetNum
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	s userdr=$g(USERID)
	s AdmId=0
	s Date=StartDate-1
	f  s Date=$o(^PAADMi("PAADM_AdmDate",Date)) q:((Date>EndDate)!(Date=""))  d
	.s AdmId=0
	.f  s AdmId=$o(^PAADMi("PAADM_AdmDate",Date,AdmId)) q:AdmId=""  d
	..s AdmInfo=##class(web.DHCFHQ.DHCFBPat).GetAdmInfoByAdm(AdmId)
	..s AdmType=$p(AdmInfo,del,16)	
	..q:AdmType="I"
	..s SessionType=""
	..s CtLoc=$p(AdmInfo,del,3)
	..s Doc=$p(AdmInfo,del,12)
	..s DocCode=$p(AdmInfo,del,11)
	..q:$g(DocCode)=""
	..s:$g(DocCode)="" DocCode="1"
	..s VisitStatu=$p(AdmInfo,del,13)
	..q:VisitStatu="C"
	..s SessionCharge=0
	..s RegType="现场挂号"
	..if ('$d(^User.DHCRegistrationFeeI("ADM"," "_AdmId))) d
	...s SessionType="直接就诊"
	..else  d
	...s:$d(^RBAS("PAADM_DR",AdmId)) RegType="预约挂号"
	...s RegFeeId=$o(^User.DHCRegistrationFeeI("ADM"," "_AdmId,""))
	...s SessionTypeDr=$LIST(^User.DHCRegistrationFeeD(RegFeeId),19)
	...s SessionCharge=$LIST(^User.DHCRegistrationFeeD(RegFeeId),4)
	...s InvPrtId=$LIST(^User.DHCRegistrationFeeD(RegFeeId),11)
	...s:InvPrtId'="" SessionCharge=$p(^DHCINVPRT(InvPrtId),del,16)
	...s:$g(SessionCharge)="" SessionCharge=0
	...if SessionCharge=".5" s SessionCharge="0.5"
	...s SessionType=$p(^RBC("SESS",SessionTypeDr),del,2)
	..;w CtLoc_del_DocCode_del_SessionCharge,!
	..s:$d(^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)) ^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)=^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)+1,^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge,1)=$g(^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge,1))+$g(SessionCharge)
	..s:'$d(^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)) ^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)=1,^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge,1)=SessionCharge
	s CtLoc="",DocCode="",SessionCharge=""
	f  s CtLoc=$o(^CacheTempFHQ(repid,0,CtLoc)) q:CtLoc=""  d
	.f  s DocCode=$o(^CacheTempFHQ(repid,0,CtLoc,DocCode)) q:DocCode=""  d
	..s CtCareId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(DocCode),""))
	..s CtCareTypeDr=$p(^CTPCP(CtCareId,1),del,4)
	..s CtCareType=""
	..s:$g(CtCareTypeDr)'="" CtCareType=$p(^CT("CPT",CtCareTypeDr),del,2)
	..s DocName=$p(^CTPCP(CtCareId,1),del,2)_"("_CtCareType_")"
	..s SessionCharge=""
	..f  s SessionCharge=$o(^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)) q:SessionCharge=""  d
	...s RetNum=RetNum+1
	...s RegCharge=0,RegNum=0
	...s RegNum=^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge)
	...s RegCharge=^CacheTempFHQ(repid,0,CtLoc,DocCode,SessionCharge,1)
	...;w CtLoc_del_DocName_del_SessionCharge_del_RegNum,!
	...s ^CacheTempFHQ(repid,RetNum)=$lb(CtLoc,DocName,SessionCharge,RegNum,RegCharge)
	..K ^CacheTempFHQ(repid,0,CtLoc,DocCode)
	q RetNum
}

}
