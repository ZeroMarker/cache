/// 为门诊患者填写建议
Class web.DHCPE.GenForOP Extends %Persistent
{

// w ##class(web.DHCPE.GenForOP).SaveMain(1,1)

ClassMethod SaveMain(PAADM, UserID)
{
	s OID=$O(^User.DHCPEGenForOPI("AdmIndex",PAADM,0))
	q:OID'="" OID
	s Date=+$H
	s Time=$P($H,",",2)
	s obj=##class(User.DHCPEGenForOP).%New()
	s obj.GFOCreateDate=Date
	s obj.GFOCreateTime=Time
	d obj.GFOCreateUserDRSetObjectId(UserID)
	d obj.GFOAdmDRSetObjectId(PAADM)
	s obj.GFOStatus="N"
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q "0^"_obj.%Id()
	}
}

ClassMethod AuditMain(ID, UserID)
{
	s obj=##class(User.DHCPEGenForOP).%OpenId(ID)
	s Date=+$H
	s Time=$P($H,",",2)
	s obj.GFOAuditDate=Date
	s obj.GFOAduitTime=Time
	s obj.GFOStatus="A"
	d obj.GFOAuditUserDRSetObjectId(UserID)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q "0^"_obj.%Id()
	}
}

// w ##class(web.DHCPE.GenForOP).SaveDetail("",2,1,"1^a^b")

ClassMethod SaveDetail(ID, PAADM, UserID, Strs)
{
	i ID="" {
		s OID=$O(^User.DHCPEGenForOPI("AdmIndex",PAADM,0))
		i OID=""{
			s OID=+..SaveMain(PAADM,UserID)
			q:OID=-1 "-2^生成主表记录错误"
		}
		s obj=##class(User.DHCPEGFOGChild).%New()
		d obj.GFOGParRefSetObjectId(OID)
		d obj.GFOGEDDRSetObjectId($P(Strs,"^",1))
	}
	else{
		s obj=##class(User.DHCPEGFOGChild).%OpenId(ID)
	}
	s Date=+$H
	s Time=$P($H,",",2)
	s obj.GFOEGStatus="N"
	s obj.GFOGEAddDate=Date
	s obj.GFOGEAddTime=Time
	d obj.GFOGEAddUserDRSetObjectId(UserID)
	s obj.GFOEGEDesc=$P(Strs,"^",2)
	s obj.GFOEGAdvice=$P(Strs,"^",3)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q "0"
	}
}

ClassMethod DeleteDetail(ID, UserID)
{
	s obj=##class(User.DHCPEGFOGChild).%OpenId(ID)
	d obj.GFOGEDeleteUserDRSetObjectId(UserID)
	s obj.GFOEGStatus="D"
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q "0"
	}
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.GenForOP", "SearchDetail",1)

Query SearchDetail(EpisodeID As %Library.String = "") As %SQLQuery(ROWSPEC = "TGFOGEDDR:%String,TGFOEGEDesc:%String, TGFOEGAdvice:%String, TAddUser:%String, TID:%String")
{
 select GFOGEDDR,GFOEGEDesc,GFOEGAdvice,GFOGEAddUserDR->SSUSR_Name,ID from Sqluser.DHCPEGFOGChild where GFOGParRef->GFOAdmDR=:EpisodeID and GFOEGStatus="N"
}

// w ##class(web.DHCPE.GenForOP).GetMainInfoByPAADM(1)

ClassMethod GetMainInfoByPAADM(PAADM)
{
	s OID=$O(^User.DHCPEGenForOPI("AdmIndex",PAADM,0))
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s PAPMIID=$p($g(^PAADM(PAADM)),"^",1)
	s Name=obj.PAADMPAPMIDR.PAPMIName
	s Sex=obj.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s Age=obj.PAADMPAPMIDR.PAPMIDOB
	s CheckDate=obj.PAADMAdmDate
	//s:Age'="" Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,CheckDate)
	s:Age'="" Age=##class(web.DHCBillInterface).GetPapmiAge(PAPMIID)
	s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
	s CheckDepart=obj.PAADMDepCodeDR.CTLOCDesc
	q OID_"^"_Name_"^"_Sex_"^"_Age_"^"_CheckDate_"^"_CheckDepart
}

// w ##class(web.DHCPE.GenForOP).GetInfo(1)

ClassMethod GetInfo(PAADM)
{
	s obj=##class(User.PAAdm).%OpenId(PAADM)
	s RegNo=obj.PAADMPAPMIDR.PAPMINo
	s CheckDate=obj.PAADMAdmDate
	s:CheckDate'="" CheckDate=$ZD(CheckDate,8)
	//s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
	s CheckTime=obj.PAADMAdmTime
	s:CheckTime="" CheckTime=$P($H,",",2)
	s CheckTime=$ZT(CheckTime)
	s CheckDate=CheckDate_CheckTime
	s Name=obj.PAADMPAPMIDR.PAPMIName
	//医保编号  或者调用接口获取
	s InsuNo=obj.PAADMPAPMIDR.PAPMIMedicare
	s EDDesc=""
	s EDAdvice=""
	s OID=$O(^User.DHCPEGenForOPI("AdmIndex",PAADM,0))
	s DSub=0
	f  s DSub=$O(^User.DHCPEGenForOPD(OID,"GFOChild",DSub)) q:DSub=""  d
	.s Status=$LG(^User.DHCPEGenForOPD(OID,"GFOChild",DSub),5)
	.q:Status="D"
	.s OneDesc=$LG(^User.DHCPEGenForOPD(OID,"GFOChild",DSub),3)
	.s OneAdvice=$LG(^User.DHCPEGenForOPD(OID,"GFOChild",DSub),4)
	.i EDDesc="" d
	..s EDDesc=OneDesc
	.e  d
	..s EDDesc=EDDesc_";"_OneDesc
	.i EDAdvice="" d
	..s EDAdvice=OneAdvice
	.e  d
	..s EDAdvice=EDAdvice_";"_OneAdvice
	q PAADM_"|"_RegNo_"|"_CheckDate_"|"_InsuNo_"|"_Name_"|"_EDDesc_"|"_EDAdvice
}

Storage Default
{
<Data name="GenForOPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.GenForOPD</DataLocation>
<DefaultData>GenForOPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.GenForOPD</IdLocation>
<IndexLocation>^web.DHCPE.GenForOPI</IndexLocation>
<StreamLocation>^web.DHCPE.GenForOPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
