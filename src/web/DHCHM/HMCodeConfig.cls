Import SQLUser

/// HM代码维护
/// 编写者：GWJ
/// 2010-9-26
Class web.DHCHM.HMCodeConfig Extends web.DHCHM.Abstract [ Not ProcedureBlock ]
{

Query FindCodebyType(CType) As %Query(ROWSPEC = "ID:%String:ID,CTActive:%String:CTActive,CTCode:%String:CTCode,CTDefault:%String:CTDefault,CTDesc:%String:CTDesc,CTExpandCode:%String:CTExpandCode,CTRemark:%String:CTRemark,CTType:%String:CTType")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCHM.HMCodeConfig","FindCodebyType","10010003")
ClassMethod FindCodebyTypeExecute(ByRef qHandle As %Binary, CType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CType=" "_CType
	s ID=0
	f  s ID=$o(^User.DHCHMCCodeTableI("Type",CType,ID))  quit:ID=""  d
	.d BuildDataFindCodebyType
	Quit $$$OK
BuildDataFindCodebyType
	d ResetVariablesFindCodebyType
	s obj=##class(User.DHCHMCCodeTable).%OpenId(ID)
	s CTActive = obj.CTActive
	s CTCode = obj.CTCode
	s CTDefault = obj.CTDefault
	s CTDesc = obj.CTDesc
	s CTExpandCode = obj.CTExpandCode
	s CTRemark = obj.CTRemark
	s CTType = obj.CTType
	i CTActive="Y"  s CTActive="true"
	e  s CTActive="false"
	i CTDefault="Y"  s CTDefault="true"
	e  s CTDefault="false"
	d OutputRowFindCodebyType
	quit
OutputRowFindCodebyType
	s Data=$lb(ID,CTActive,CTCode,CTDefault,CTDesc,CTExpandCode,CTRemark,CTType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindCodebyType
	s (CTActive,CTCode,CTDefault,CTDesc,CTExpandCode,CTRemark,CTType)=""
	quit
}

ClassMethod FindCodebyTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCodebyTypeExecute ]
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

ClassMethod FindCodebyTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCodebyTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindCPlnss(CodeType) As %Query(ROWSPEC = "ID:%String:ID,PActive:%String:PActive,PCode:%String:PCode,PDesc:%String:PDesc,PExpandCode:%String:PExpandCode,PRemark:%String:PRemark,PType:%String:PType")
{
}

///  d ##class(%ResultSet).RunQuery("web.DHCHM.HMCodeConfig","FindCPlnss","10020001")
ClassMethod FindCPlnssExecute(ByRef qHandle As %Binary, CodeType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CodeType=" "_CodeType
	s ID=0
	f  s ID=$o(^User.DHCHMCPlainnessI("PTypeIndex",CodeType,ID))  quit:ID=""  d
	.d BuildDataFindCPlnss
	Quit $$$OK
BuildDataFindCPlnss
	d ResetVariablesFindCPlnss
	s obj=##class(User.DHCHMCPlainness).%OpenId(ID)
	s PActive = obj.PActive
	s PCode = obj.PCode
	s PDesc = obj.PDesc
	s PExpandCode = obj.PExpandCode
	s PRemark = obj.PRemark
	s PType = obj.PType
	i PActive="Y"  s PActive="true"
	e  s PActive="false"
	d OutputRowFindCPlnss
	quit
OutputRowFindCPlnss
	s Data=$lb(ID,PActive,PCode,PDesc,PExpandCode,PRemark,PType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindCPlnss
	s (PActive,PCode,PDesc,PExpandCode,PRemark,PType)=""
	quit
}

ClassMethod FindCPlnssFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCPlnssExecute ]
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

ClassMethod FindCPlnssClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCPlnssExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindClaLevel(CodeType) As %Query(ROWSPEC = "ID:%String:ID,CLActive:%String:CLActive,CLCode:%String:CLCode,CLDesc:%String:CLDesc,CLExpandCode:%String:CLExpandCode,CLRemark:%String:CLRemark,CLType:%String:CLType")
{
}

///  d ##class(%ResultSet).RunQuery("web.DHCHM.HMCodeConfig","FindClaLevel","10030001")
ClassMethod FindClaLevelExecute(ByRef qHandle As %Binary, CodeType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CodeType=" "_CodeType
	s ID=0
	f  s ID=$o(^User.DHCHMCClassLevelI("CLTypeIndex",CodeType,ID))  quit:ID=""  d
	.d BuildDataFindClaLevel
	Quit $$$OK
BuildDataFindClaLevel
	d ResetVariablesFindClaLevel
	s obj=##class(User.DHCHMCClassLevel).%OpenId(ID)
	s CLActive = obj.CLActive
	s CLCode = obj.CLCode
	s CLDesc = obj.CLDesc
	s CLExpandCode = obj.CLExpandCode
	s CLRemark = obj.CLRemark
	s CLType = obj.CLType
	if CLActive="Y"  s CLActive="true"
	e  s CLActive="false"
	d OutputRowFindClaLevel
	quit
OutputRowFindClaLevel
	s Data=$lb(ID,CLActive,CLCode,CLDesc,CLExpandCode,CLRemark,CLType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindClaLevel
	s (CLActive,CLCode,CLDesc,CLExpandCode,CLRemark,CLType)=""
	quit
}

ClassMethod FindClaLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClaLevelExecute ]
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

ClassMethod FindClaLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClaLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindHumClass(CodeType) As %Query(ROWSPEC = "ID:%String:ID,HCActive:%String:HCActive,HCCode:%String:HCCode,HCDesc:%String:HCDesc,HCExpandCode:%String:HCExpandCode,HCMonths:%String:HCMonths,HCRemark:%String:HCRemark,HCType:%String:HCType")
{
}

///  d ##class(%ResultSet).RunQuery("web.DHCHM.HMCodeConfig","FindHumClass","10040001")
ClassMethod FindHumClassExecute(ByRef qHandle As %Binary, CodeType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CodeType=" "_CodeType
	s ID=0
	f  s ID=$o(^User.DHCHMCHumanClassI("HCTypeIndex",CodeType,ID))  quit:ID=""  d
	.d BuildDataFindHumClass
	Quit $$$OK
BuildDataFindHumClass
	d ResetVariablesFindHumClass
	s obj=##class(User.DHCHMCHumanClass).%OpenId(ID)
	s HCActive = obj.HCActive
	s HCCode = obj.HCCode
	s HCDesc = obj.HCDesc
	s HCExpandCode = obj.HCExpandCode
	s HCMonths = obj.HCMonths
	s HCRemark = obj.HCRemark
	s HCType = obj.HCType
	i HCActive="Y"  s HCActive="true"
	e  s HCActive="false"
	d OutputRowFindHumClass
	quit
OutputRowFindHumClass
	s Data=$lb(ID,HCActive,HCCode,HCDesc,HCExpandCode,HCMonths,HCRemark,HCType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindHumClass
	s (HCActive,HCCode,HCDesc,HCExpandCode,HCMonths,HCRemark,HCType)=""
	quit
}

ClassMethod FindHumClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHumClassExecute ]
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

ClassMethod FindHumClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHumClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

///  d ##class(%ResultSet).RunQuery("web.DHCHM.HMCodeConfig","FindTblTree","1001")
Query FindTblTree(CodeType) As %Query(ROWSPEC = "id:%String:id,text:%String:text,leaf:%String:leaf,checked:%String:checked")
{
}

ClassMethod FindTblTreeExecute(ByRef qHandle As %Binary, CodeType) As %Status
{
 	new repid, index,ID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CodeType=" "_CodeType
	s Ordersub="" 
	f  s Ordersub=$o(^User.DHCHMCSettingI("STypeCodeIndex",CodeType,Ordersub)) q:Ordersub=""  d
	.s ID=0
	.f  s ID=$o(^User.DHCHMCSettingI("STypeCodeIndex",CodeType,Ordersub,ID))  quit:ID=""  d
	..d BuildDataFindTblTree
	Quit $$$OK
BuildDataFindTblTree
	d ResetVariablesFindTblTree
	s obj=##class(User.DHCHMCSetting).%OpenId(ID)
	s SCode = obj.SCode
	//s SOrder = obj.SOrder
	s SRemark = obj.SRemark
	//s STable = obj.STable
	//s STypeCode = obj.STypeCode
	s SValue = obj.SValue
	q:SValue'="Y"
	s SRemark="'"_SRemark_"'"
	s Sleaf="true"
	s Tch="null"
	d OutputRowFindTblTree
	quit
OutputRowFindTblTree
	s Data=$lb(SCode,SRemark,Sleaf,Tch)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesFindTblTree
	s (SCode,SRemark,Sleaf,Tch)=""
	quit
}

ClassMethod FindTblTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTblTreeExecute ]
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

ClassMethod FindTblTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTblTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##class(web.DHCHM.HMCodeConfig).SaveData("23","Y^02^Y^高中^^^10010002")

ClassMethod SaveData(SID, SValuestr)
{
    set pro=##class(web.DHCHM.Tools).GetPros("User.DHCHMCCodeTable","")
	set ret=##class(User.DHCHMCCodeTable).SaveData(SID,SValuestr,pro)
	//如果设了默认，清除其他的默认属性
	i ret'="-1"  d
	.s DefaultValue=$p(SValuestr,"^",3)
	.i (DefaultValue="Y")  d
	..s DefaultValue=" "_DefaultValue
	..s TypeCode=$p(SValuestr,"^",7)
	..s TypeCode=" "_TypeCode
	..s ID=0
	..f  s ID=$o(^User.DHCHMCCodeTableI("CTDefault",TypeCode,DefaultValue,ID))  quit:ID=""  d
	...q:(ID=ret)
	...s obj=##class(User.DHCHMCCodeTable).%OpenId(ID)
	...s obj.CTDefault="N"
	...s sc=obj.%Save()
	...d obj.%Close()
	q ret
}

ClassMethod SaveCPlnss(SID, SValuestr)
{
    set pro=##class(web.DHCHM.Tools).GetPros("User.DHCHMCPlainness","")
	set ret=##class(User.DHCHMCPlainness).SaveData(SID,SValuestr,pro)
	
	q ret
}

ClassMethod SaveClaLevel(SID, SValuestr)
{
    set pro=##class(web.DHCHM.Tools).GetPros("User.DHCHMCClassLevel","")
	set ret=##class(User.DHCHMCClassLevel).SaveData(SID,SValuestr,pro)
	q ret
}

ClassMethod SaveHumClass(SID, SValuestr)
{
    set pro=##class(web.DHCHM.Tools).GetPros("User.DHCHMCHumanClass","")
	set ret=##class(User.DHCHMCHumanClass).SaveData(SID,SValuestr,pro)
	q ret
}

// w ##class(web.DHCHM.HMCodeConfig).CheckCodeExist("10010001","033333","22")

ClassMethod CheckCodeExist(Type, Code, ID = "")
{
	s ^tmpwgy("CheckCodeExist")=$lb(Type, Code, ID)
	q:(Code="")||(Type="") 0
	i ID="" q $D(^User.DHCHMCCodeTableI("TypeCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Type),$C(32)_$$ALPHAUP^SSUTIL4(Code)))
	s CID=$O(^User.DHCHMCCodeTableI("TypeCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Type),$C(32)_$$ALPHAUP^SSUTIL4(Code),""))
	i (ID=CID)||(CID="") q 0
	e  q 1
}

ClassMethod CheckTipsCodeExist(Code, ID = "")
{
	q:Code="" 0
	i ID="" q $D(^User.DHCHMCMedicalTipsI("MTCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Code)))
	s CID=$O(^User.DHCHMCMedicalTipsI("MTCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Code),""))
	i (ID=CID)||(CID="") q 0
	e  q 1
}

ClassMethod CheckEDCodeExist(Code, ID = "")
{
	q:Code="" 0
	i ID="" q $D(^User.DHCHMCEvaluationDetailI("EDCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Code)))
	s CID=$O(^User.DHCHMCEvaluationDetailI("EDCodeIndex",$C(32)_$$ALPHAUP^SSUTIL4(Code),""))
	i (ID=CID)||(CID="") q 0
	e  q 1
}

}
