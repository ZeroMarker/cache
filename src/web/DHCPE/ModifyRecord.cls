Class web.DHCPE.ModifyRecord Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Save(SourceID, SourceType, OldInfo, NewInfo, UserID)
{
	n (SourceID, SourceType, OldInfo, NewInfo, UserID)
	s $ZT="MRecordErr"
	q:OldInfo=NewInfo 0
	s obj=##class(User.DHCPEModifyRecord).%New()
	s obj.MRNewInfo=NewInfo
	s obj.MROldInfo=OldInfo
	s obj.MRDate=+$H
	s obj.MRTime=$P($H,",",2)
	s obj.MRSourceID=SourceID
	s obj.MRSourceType=SourceType
	d obj.MRUserDRSetObjectId(UserID)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		;s ^wrzRecord=SourceID_","_SourceType_","_OldInfo_","_NewInfo_","_UserID_"^"_$System.Status.GetErrorText(sc)
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
MRecordErr
	q 0
}

ClassMethod GetInfo(SourceID, SourceType)
{
	;w ##class(web.DHCPE.ModifyRecord).GetInfo("50","GSSDetail")
	n (SourceID,SourceType)
	s $ZT="MRGetInfoErr"
	s Info=""
	q:SourceID="" Info
	i SourceType="IBaseInfo"
	{
		s Name=$P($g(^DHCPEPreIBI(SourceID)),"^",2)
		s Info="姓名:"_Name
		s Sex=$P($g(^DHCPEPreIBI(SourceID)),"^",3)
		s:Sex'="" Sex=$P(^CT("SEX",Sex),"^",2)
		s:Sex'="" Info=Info_";性别:"_Sex
		s Dob=$P($g(^DHCPEPreIBI(SourceID)),"^",4)
		//s:Dob'="" Dob=$ZD(Dob,3)
		s:Dob'="" Dob=##class(websys.Conversions).DateLogicalToHtml(Dob)
		s:Dob'="" Info=Info_";生日:"_Dob
		s PatType=$P($g(^DHCPEPreIBI(SourceID)),"^",5)
		s:PatType'="" PatType=$P($g(^CT("SS",PatType)),"^",2)
		s:PatType'="" Info=Info_";类型:"_PatType
		s Tel1=$P($g(^DHCPEPreIBI(SourceID)),"^",6)
		s:Tel1'="" Info=Info_";电话1:"_Tel1
		s Tel2=$P($g(^DHCPEPreIBI(SourceID)),"^",7)
		s:Tel2'="" Info=Info_";电话2:"_Tel2
		s Mob=$P($g(^DHCPEPreIBI(SourceID)),"^",8)
		s:Mob'="" Info=Info_";手机:"_Mob
		s IDCard=$P($g(^DHCPEPreIBI(SourceID)),"^",9)
		s:IDCard'="" Info=Info_";证件号:"_IDCard
		s EMail=$P($g(^DHCPEPreIBI(SourceID)),"^",16)
		s:EMail'="" Info=Info_";EMail:"_EMail
		s Married=$P($g(^DHCPEPreIBI(SourceID)),"^",17)
		s:Married'="" Married=$P($g(^CT("MAR",Married)),"^",2)
		s:Married'="" Info=Info_";婚姻:"_Married
		s Address=$P($g(^DHCPEPreIBI(SourceID)),"^",14)
		s:Address'="" Info=Info_";住址:"_Address
		s Position=$P($g(^DHCPEPreIBI(SourceID)),"^",11)
		s:Position'="" Info=Info_";部门:"_Position
		s Company=$P($g(^DHCPEPreIBI(SourceID)),"^",12)
		s:Company'="" Info=Info_";公司:"_Company
		s Blood=$P($g(^DHCPEPreIBI(SourceID)),"^",18)
		s:Blood'="" Info=Info_";血型:"_$p($g(^PAC("BLDT",Blood)),"^",2)
		s Postalcode=$P($g(^DHCPEPreIBI(SourceID)),"^",13)
		s:Postalcode'="" Info=Info_";邮编:"_Postalcode
		
		S PIBIPAPMINo=$P($g(^DHCPEPreIBI(SourceID)),"^",1)
		
		s SPTypeDesc=""
		s SPTypeID=$g(^DHCPECBSpecial("PIBI",PIBIPAPMINo))	
		i SPTypeID'="" S SPTypeDesc=$LG($g(^User.DHCPESpecialTypeD(SPTypeID)),3)
		s:SPTypeDesc'="" Info=Info_";特殊客户类型:"_SPTypeDesc
		
		s PAPERRowId=$o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0))
		
		S PACCardDesc=""
		S PACCardTypeDR=$P($g(^PAPER(PAPERRowId,"PAT",3)),"^",7)
	    I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	    s:PACCardDesc'="" Info=Info_";证件类型:"_PACCardDesc
	    
	    s NationDesc=""
	    S NationDR=$P($G(^PAPER(PAPERRowId,"PER",2)),"^",1)
	    i NationDR'="" s NationDesc=$p($g(^CT("NAT",NationDR)),"^",2)
	    s:NationDesc'="" Info=Info_";民族:"_NationDesc
	     
	    s Vocation=$P($g(^DHCPEPreIBI(SourceID)),"^",10)
		if (Vocation'="") {
			s Info=Info_";职业:"_$P($g(^CT("OCC",Vocation)),"^",2)
		}else{
	    	s Occupation=""
	    	s OccupationDR=$P($G(^PAPER(PAPERRowId,"PER",2)),"^",6)
	    	i OccupationDR'="" s Occupation=$P($G(^CT("OCC",OccupationDR)),"^",2) 
	    	s:Occupation'="" Info=Info_";职业:"_Occupation
		}


	}
	i SourceType="GSSDetail"
	{
		s id=$o(^User.DHCPEModifyRecordI("SourceIndex","GSSDETAIL",SourceID,""),-1)
		s Info=$lg(^User.DHCPEModifyRecordD(id),8)
	}
	q Info
MRGetInfoErr
	q ""
}

}
