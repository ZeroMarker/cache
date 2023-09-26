/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生站交班本操作类
Class DHCDoc.PW.CFG.BCMain Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 保存/更新交班本配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCMain).Save("","L^测试^2")
ClassMethod Save(ID = "", inPara = "") As %String
{
	
	s BType=$p(inPara,"^",1)
	s BDesc=$p(inPara,"^",2)
	s active=$p(inPara,"^",3)
	s BHosp=$p(inPara,"^",4)
	Q:BHosp="" "-1^医院为空！"
	Q:BDesc="" "-1^交班类型为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	TS
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkBCMain).%New()
	e  s SaveOBJ = ##class(User.DHCDocPassWorkBCMain).%OpenId(ID)
	
	d SaveOBJ.BMHospSetObjectId(BHosp)
	s SaveOBJ.BMType=BType
	s SaveOBJ.BMDesc=BDesc
	s SaveOBJ.BMActive=active
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		TRO
		Quit "-1^保存交班类型失败！"
	}
	i ID="" {
		s mRtn=##class(DHCDoc.PW.CFG.BCPatType).CreateDefaultData(SaveOBJ.%Id())
		i mRtn'=1 {
			TRO
			Quit "-1^生成病人类型数据失败！"
		}
		s mRtn=##class(DHCDoc.PW.CFG.BCRule).CreateDefaultData(SaveOBJ.%Id())
		i mRtn'=1 {
			TRO
			Quit "-1^生成规则配置数据失败！"
		}	
		s mRtn=##class(DHCDoc.PW.CFG.BCTpl).CreateDefaultData(SaveOBJ.%Id())
		i mRtn'=1 {
			TRO
			Quit "-1^生成模板数据失败！"
		}	
	} else {
		if (BType="C") {
			s mRtn=##class(DHCDoc.PW.CFG.BCLoc).DeleteByMID(ID)	
			i mRtn'=0 {
				TRO
				Quit "-1^清空关联科室失败！"
			}	
		}
	}
	TC
	q SaveOBJ.%Id()_"^保存成功！"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCMain).Save("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s BType=$p(inPara,"^",1)
	s BHosp=$p(inPara,"^",4)
	Q:BType'="C" 0
	if (ID="") {
		i $d(^User.DHCDocPassWorkBCMainI("BMHospType",BHosp,BType)) {
			Q "-1^通用类型已经存在，不允许重复添加！"
		}
	} else {
		s oldHosp=$lg(^User.DHCDocPassWorkBCMainD(ID),2)
		s oldType=$lg(^User.DHCDocPassWorkBCMainD(ID),3)
		i $d(^User.DHCDocPassWorkBCMainI("BMHospType",BHosp,BType)) {
			i (oldHosp'=BHosp)||(oldType'=BType) {
				Q "-1^通用类型已经存在，不允许重复添加！"
			}
		}
	}
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 得到类型描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BCMain).GetBTypeDesc("L")
ClassMethod GetBTypeDesc(BType = "") As %String
{
	s mRtn=""
	i BType="L"	s mRtn="科室类型"
	i BType="C" s mRtn="通用类型"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询交班本配置
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.BCMain","QryBCMain")
Query QryBCMain(InHosp = "", InType = "") As %Library.Query(ROWSPEC = "rowid,hosp,type,typeDesc,desc,hospDesc,active,locDesc")
{
}

ClassMethod QryBCMainExecute(ByRef qHandle As %Library.Binary, InHosp = "", InType = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^User.DHCDocPassWorkBCMainD(rowid)) q:rowid=""  d
	.s hosp=$lg(^User.DHCDocPassWorkBCMainD(rowid),2)
	.s type=$lg(^User.DHCDocPassWorkBCMainD(rowid),3)
	.s typeDesc=..GetBTypeDesc(type)
	.s desc=$lg(^User.DHCDocPassWorkBCMainD(rowid),4)
	.s active=$lg(^User.DHCDocPassWorkBCMainD(rowid),5)
	.s hospDesc=$p(^CT("HOSP",hosp),"^",2)
	.q:(InHosp'="")&&(InHosp'=hosp)
	.q:(InType'="")&&(InType'=type)
	.s locDesc=##class(DHCDoc.PW.CFG.BCLoc).GetLocStr(rowid)
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,hosp,type,typeDesc,desc,hospDesc,active,locDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBCMainFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBCMainExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryBCMainClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBCMainFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询交班本类型
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.BCMain","QryBType")
Query QryBType() As %Library.Query(ROWSPEC = "rowid,desc")
{
}

ClassMethod QryBTypeExecute(ByRef qHandle As %Library.Binary) As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s rowid="L",desc=..GetBTypeDesc(rowid)
	d OuputRow2
	s rowid="C",desc=..GetBTypeDesc(rowid)
	d OuputRow2
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow2
	set Data=$lb(rowid,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBTypeFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryBTypeClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBTypeFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 清楚表数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCMain).ClearTable()
ClassMethod ClearTable() As %String
{
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkBCTime)
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkBCLoc)
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkBCRule)
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkBCPatType)
	&SQL(TRUNCATE TABLE SQLUser.DHCDocPassWorkBCMain)
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询交班本类型
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCMain","QryHospType",2)
Query QryHospType(InHosp = "") As %Library.Query(ROWSPEC = "id,text")
{
}

ClassMethod QryHospTypeExecute(ByRef qHandle As %Library.Binary, InHosp = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InHosp="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	//
	s langid=..%LanguageID()
	s type=""
	f  s type=$o(^User.DHCDocPassWorkBCMainI("BMHospType",InHosp,type)) q:type=""  d
	.s id=""
	.f  s id=$o(^User.DHCDocPassWorkBCMainI("BMHospType",InHosp,type,id)) q:id=""  d
	..s typeDesc=..GetBTypeDesc(type)
	..s typeDesc= ##class(User.DHCDocPassWorkBCMain).GetTranByDesc("BMType",typeDesc,langid)
	..s desc=$lg(^User.DHCDocPassWorkBCMainD(id),4)
	..s desc= ##class(User.DHCDocPassWorkBCMain).GetTranByDesc("BMDesc",desc,langid)
	..s active=$lg(^User.DHCDocPassWorkBCMainD(id),5)
	..q:active'=1
	..s text=typeDesc_"("_desc_")"
	..d OuputRow44
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow44
	set Data=$lb(id,text)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryHospTypeFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryHospTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QryHospTypeClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryHospTypeFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
