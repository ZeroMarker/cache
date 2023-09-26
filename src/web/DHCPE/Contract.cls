/// 团体合同管理
Class web.DHCPE.Contract Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod Update(ID As %String = "", Str As %String = "") As %String
{
	i ID="" d
	.s obj=##class(User.DHCPEContract).%New()
	.s obj.CCreateDate=+$H
	.s obj.CCreateTime=$P($H,",",2)
	.d obj.CCreateUserDRSetObjectId($P(Str,"^",5))
	.d obj.CDepartCodeDRSetObjectId($P(Str,"^",6))
	e  d
	.s obj=##class(User.DHCPEContract).%OpenId(ID)
	s obj.CNo=$P(Str,"^",1)
	s obj.CName=$P(Str,"^",2)
	s obj.CSignDate=$P(Str,"^",3)
	//i obj.CSignDate'="" s obj.CSignDate=$ZDH(obj.CSignDate,4)
	i obj.CSignDate'="" s obj.CSignDate=##class(websys.Conversions).DateHtmlToLogical(obj.CSignDate)
	s obj.CRemark=$P(Str,"^",4)
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod GetInfoByID(ID)
{
	q:ID="" "^^^^"
	s obj=##class(User.DHCPEContract).%OpenId(ID)
	s No=obj.CNo
	s Name=obj.CName
	s SighDate=obj.CSignDate
	//s:SighDate'="" SighDate=$ZD(SighDate,4)
	s:SighDate'="" SighDate=##class(websys.Conversions).DateLogicalToHtml(SighDate)
	s Remark=obj.CRemark
	q ID_"^"_No_"^"_Name_"^"_SighDate_"^"_Remark
}

Query SerchContract(Contract As %String = "") As %Query(ROWSPEC = "TID:%String,TNo:%String:合同编号,TName:%String:合同名称,TSignDate:%String:签订日期,TRemark:%String:备注,TCreateDate:%String:录入日期,TCreateUser:%String:录入人")
{
}

ClassMethod SerchContractExecute(ByRef qHandle As %Binary, Contract As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Contract=##class(web.DHCPE.DHCPECommon).UnEscape(Contract)
 	s:Contract'="" Contract=$ZCVT(Contract,"U")

 	s ID=""
 	f  s ID=$O(^User.DHCPEContractD(ID)) q:ID=""  d
 	.d Clear
 	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",ID)         //Add by 090702
  	.q:LocFlag=1  
 	.s TNo=$LG(^User.DHCPEContractD(ID),2)
	.s TName=$LG(^User.DHCPEContractD(ID),3)
	.s TNamePY=##class(web.DHCINSUPort).GetCNCODE(TName,4,"")
	.i (""'=Contract) d
	..s ParaTNamePY=##class(web.DHCINSUPort).GetCNCODE(Contract,4,"")
	.e  d
	..s ParaTNamePY=""
	.q:(""'=ParaTNamePY)&('(TNamePY[ParaTNamePY))
	.s TRemark=$LG(^User.DHCPEContractD(ID),4)
	.s TSignDate=$LG(^User.DHCPEContractD(ID),9)
	.;s:TSignDate'="" TSignDate=$ZD(TSignDate,3)
	.s:TSignDate'="" TSignDate=##class(websys.Conversions).DateLogicalToHtml(TSignDate)
	.s TCreateDate=$LG(^User.DHCPEContractD(ID),6)
	.;s:TCreateDate'="" TCreateDate=$ZD(TCreateDate,3)
	.s:TCreateDate'="" TCreateDate=##class(websys.Conversions).DateLogicalToHtml(TCreateDate)
	.s TCreateUser=$LG(^User.DHCPEContractD(ID),5)
	.s:TCreateUser'="" TCreateUser=$P(^SSU("SSUSR",TCreateUser),"^",2)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Clear
	s (TNo,TName,TSignDate,TRemark,TCreateDate,TCreateUser)=""
	q 
FindBuild      
	set Data=$lb(ID,TNo,TName,TSignDate,TRemark,TCreateDate,TCreateUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchContractExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				
 	Set Row=^CacheTemp(repid,ind)
 	}
 	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod SerchContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchContractExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

Query SerchContractNew(Name As %String = "", No As %String = "", SignDate As %String = "", StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TID:%String,TNo:%String:合同编号,TName:%String:合同名称,TSignDate:%String:签订日期,TRemark:%String:备注,TCreateDate:%String:录入日期,TCreateUser:%String:录入人")
{
}

ClassMethod SerchContractNewExecute(ByRef qHandle As %Binary, Name As %String = "", No As %String = "", SignDate As %String = "", StartDate As %String = "", EndDate As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
 	s:Name'="" Name=$ZCVT(Name,"U")
    i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	
 	//i StartDate="" s StartDate=+$h-1
 	//i EndDate="" s EndDate=+$h

    /*i (Name="")&&(No="")&&(StartDate="")&&(EndDate="")
    {
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
    }
    */

 	s ID=""
 	f  s ID=$O(^User.DHCPEContractD(ID)) q:ID=""  d
 	.d Clear
 	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",ID)         //Add by 090702
  	.q:LocFlag=1  
 	.s TNo=$LG(^User.DHCPEContractD(ID),2)
 	.q:(No'="")&&(No'=TNo)
	.s TName=$LG(^User.DHCPEContractD(ID),3)
	.s TNamePY=##class(web.DHCINSUPort).GetCNCODE(TName,4,"")
	.i (""'=Name) d
	..s ParaTNamePY=##class(web.DHCINSUPort).GetCNCODE(Name,4,"")
	.e  d
	..s ParaTNamePY=""
	.q:(""'=ParaTNamePY)&('(TNamePY[ParaTNamePY))
	.s TRemark=$LG(^User.DHCPEContractD(ID),4)
	.s TSignDate=$LG(^User.DHCPEContractD(ID),9)
	.s:TSignDate'="" TSignDate=##class(websys.Conversions).DateLogicalToHtml(TSignDate)
	.;q:(SignDate'="")&&(TSignDate'=SignDate)
	.s TCreateDate=$LG(^User.DHCPEContractD(ID),6)
	.q:(""'=StartDate)&(TCreateDate<StartDate)
	.q:(""'=EndDate)&(TCreateDate>EndDate)
	.s:TCreateDate'="" TCreateDate=##class(websys.Conversions).DateLogicalToHtml(TCreateDate)
	.s TCreateUser=$LG(^User.DHCPEContractD(ID),5)
	.s:TCreateUser'="" TCreateUser=$P(^SSU("SSUSR",TCreateUser),"^",2)
	.d FindBuild
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Clear
	s (TNo,TName,TSignDate,TRemark,TCreateDate,TCreateUser)=""
	q 
FindBuild     
    s TName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEContract",TName,"CName","cls") 
    s TCreateUser=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpecontract.hisui.csp","录入人")
	set Data=$lb(ID,TNo,TName,TSignDate,TRemark,TCreateDate,TCreateUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchContractNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchContractNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				
 	Set Row=^CacheTemp(repid,ind)
 	}
 	 	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod SerchContractNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchContractNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

}
