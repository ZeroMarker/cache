Import SQLUser

Class web.DHCBPPunctureScheme Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod SavePunctureScheme(paraStr As %String, userId As %String) As %String
{
	s ret=0
	q:paraStr="" "没有要保存的数据"
	set $zt="Error"
	TSTART
	 for i=1:1:($l(paraStr,"^"))
	 {
		 
		s singlePara=$p(paraStr,"^",i)
		q:singlePara=""
		s pointId=$p(singlePara,$c(3),1)
		s regsiterId=$p(singlePara,$c(3),2)
		s vascularacessId=$p(singlePara,$c(3),3)
		s pointtype=$p(singlePara,$c(3),4)
		s pointnum=$p(singlePara,$c(3),5)
		s pointX=$p(singlePara,$c(3),6)
		s pointY=$p(singlePara,$c(3),7)
		s pointNote=$p(singlePara,$c(3),8)
		s pointStatus=$p(singlePara,$c(3),9)
		if (pointId'="")
		{
			s punctureObj=##class(User.DHCBPPunctureScheme).%OpenId(pointId)
		}else{
			&sql(select %ID into :pointId from DHC_BP_PunctureScheme where BPPun_PatRegister_Dr=:regsiterId and BPPun_VascularAccess_Dr=:vascularacessId and BPPun_Type=:pointtype and BPPun_PositionNum=:pointnum and BPPun_Status=:pointStatus)
			i pointId'="" s punctureObj=##class(User.DHCBPPunctureScheme).%OpenId(pointId)
			e  s punctureObj=##class(User.DHCBPPunctureScheme).%New()
		}
		s punctureObj.BPPunPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(regsiterId)
		s punctureObj.BPPunVascularAccessDr=##class(User.DHCBPVascularAccess).%OpenId(vascularacessId)
		s punctureObj.BPPunType=pointtype
		s punctureObj.BPPunPositionNum=pointnum
		s punctureObj.BPPunLocationX=pointX
		s punctureObj.BPPunLocationY=pointY
		s punctureObj.BPPunStatus=pointStatus
		s punctureObj.BPPunLocationNote=pointNote
		s punctureObj.BPPunUpdateUserDr=userId
		s punctureObj.BPPunUpdateDate=+$h
		s punctureObj.BPPunUpdateTime=$p($h,",",2)
		s sc=punctureObj.%Save()
		if ($System.Status.IsError(sc))
		{
			trollback
			quit 
			//$System.Status.GetErrorText(sc)
		}
	 }
     
	tcommit
	quit ret	
	
Error
	trollback
	quit "-1^"_$ze
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPPunctureScheme","FindPunctureSchemeList")
Query FindPunctureSchemeList(vascularacessId As %String) As %SQLQuery(CONTAINID = 1)
{
	   
       SELECT %ID As Id,
       BPPun_PatRegister_Dr As RegisterId,
       BPPun_VascularAccess_Dr As VasularAccessId,
       BPPun_Type As PointType,
       BPPun_PositionNum As PointNum,
       BPPun_LocationX As PointX,
       BPPun_LocationY As PointY,
       BPPun_LocationNote As PointNote,
       BPPun_Status As PointStatus
	   FROM DHC_BP_PunctureScheme
	   WHERE BPPun_VascularAccess_Dr=:vascularacessId and BPPun_Status!="D"
}

ClassMethod SaveVascularAccessImage(regsiterId, vascularAccessId, userId, imagebase As %Library.GlobalCharacterStream) As %String
{
	//s ^tempwq("0719",regsiterId,vascularAccessId)=imagebase
	s ^tempwq("0719",regsiterId,vascularAccessId)=imagebase
	q:regsiterId=""!vascularAccessId="" ""
	s obj=##class(User.DHCBPVascularAccessPicture).%New()
	i regsiterId'="" s obj.BPVPBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(regsiterId)
	//s vascularAccessId=d.GetAt("VascularAccessId")
	i vascularAccessId'="" s obj.BPVPVascularAccessDr=##class(User.DHCBPCVascularAccess).%OpenId(vascularAccessId)
	s obj.BPVPImage=imagebase
	s obj.BPVPIfActive="Y"
	s startDate=+$h
	s obj.BPVPStartDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=$p($h,",",2)
	s obj.BPVPStartTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	
	s obj.BPVPUpdateUserDr=userId
	s obj.BPVPNote=""
	d obj.%Save()
	
	s result=obj.%Id()
	d obj.%Close()
	q result
}

}
