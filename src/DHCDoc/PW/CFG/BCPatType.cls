/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生站交班本病人类型
Class DHCDoc.PW.CFG.BCPatType Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 保存/更新交班本病人类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).Save("","1^PreSum^12^1^21^12^12")
ClassMethod Save(ID = "", inPara = "", Flag = "") As %String
{
	s ^QP("TH",1)=$LB(ID,inPara)
	s MID=$P(inPara,"^",1)
	s code=$P(inPara,"^",2)
	s desc=$P(inPara,"^",3)
	s active=$P(inPara,"^",4)
	s num=$P(inPara,"^",5)
	s wh=$P(inPara,"^",6)
	s url=$P(inPara,"^",7)
	s selected=$P(inPara,"^",8)
	TS
	s nosel=0
	Q:MID="" "-1^父表ID为空！"
	Q:code="" "-1^代码为空！"
	Q:desc="" "-1^描述为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	i Flag="" {
		i selected=1 {
			//更新其余默认选中项
			&SQL(
				UPDATE SQLUser.DHCDocPassWorkBCPatType(BP_Selected)
				VALUES(:nosel)
				WHERE BP_ParRef=:MID
			)
			I SQLCODE'=0 {
				TRO
				Quit "-1^保存病人类型失败！"	
			}
			
		}
	}
	
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkBCPatType).%New(MID)
	e  s SaveOBJ = ##class(User.DHCDocPassWorkBCPatType).%OpenId(ID)
	d SaveOBJ.BPParRefSetObjectId(MID)
	s SaveOBJ.BPActive=active
	s SaveOBJ.BPCode=code
	s SaveOBJ.BPDesc=desc
	s SaveOBJ.BPNum=num
	s SaveOBJ.BPURL=url
	s SaveOBJ.BPWH=wh
	s SaveOBJ.BPSelected=selected
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		TRO
		Quit "-1^保存病人类型失败！"
	}
	TC
	
	
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).Save("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,"^",1)
	s code=$P(inPara,"^",2) 
	s selected=$P(inPara,"^",8)
	i ID="" {
		i $d(^User.DHCDocPassWorkBCPatTypeI("BPCode",code,MID)) {
			Q "-1^配置已存在！"
		}
	} else {
		s sub=$p(ID,"||",2)
		s oldCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",sub),2)
		s oldSelected=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",sub),8)
		
		i $d(^User.DHCDocPassWorkBCPatTypeI("BPCode",code,MID)) {
			i oldCode'=code {
				Q "-1^配置已存在！"
			}
		}
		
	}
	
			
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 根据CODE得到描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).GetDescByCode("1","PreSum")
ClassMethod GetDescByCode(MID = "", Code = "") As %String
{
	s mRtn=""
	Q:MID=""||Code="" mRtn
	;s Code=$$ALPHAUP^SSUTIL4(Code)    
	s id=$o(^User.DHCDocPassWorkBCPatTypeI("BPCode",Code,MID,""))
	Q:id="" mRtn
	s mRtn=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",id),3)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 根据CODE得到宽度
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).GetWidthByCode("1","PreSum")
ClassMethod GetWidthByCode(MID = "", Code = "") As %String
{
	s mRtn=""
	Q:MID=""||Code="" mRtn
	;s Code=$$ALPHAUP^SSUTIL4(Code)    
	s id=$o(^User.DHCDocPassWorkBCPatTypeI("BPCode",Code,MID,""))
	Q:id="" mRtn
	s mRtn=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",id),6)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 是否激活
/// IN  : 
/// OUT : 1激活，0隐藏
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).IsHiddenByCode("1","PreSum")
ClassMethod IsHiddenByCode(MID = "", Code = "") As %String
{
	s mRtn=0
	Q:MID=""||Code="" mRtn
	;s Code=$$ALPHAUP^SSUTIL4(Code)    
	s id=$o(^User.DHCDocPassWorkBCPatTypeI("BPCode",Code,MID,""))
	Q:id="" mRtn
	s mRtn=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",id),4)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-12
/// DESC: 生成默认数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).CreateDefaultData()
ClassMethod CreateDefaultData(MID) As %String
{
	s rtn=1
	S MDList(1)="ALL^全部^1^1^80^dhcdoc.passwork.nmain.comtpl.csp^1"
	S MDList(2)="PreSum^原有^1^2^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(3)="OutHospNum^出院^1^3^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(4)="InHospNum^入院^1^4^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(5)="OutWardNum^转出^1^5^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(6)="InWardNum^转入^1^6^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(7)="OperNum^手术^1^7^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(8)="SeverityNum^病危^1^8^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(9)="CritiNum^病重^1^9^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(10)="DeathNum^死亡^1^10^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	S MDList(11)="NowSum^现有^1^11^80^dhcdoc.passwork.nmain.comtpl.csp^0"
	
	s id=""
	f  s id=$o(MDList(id)) q:(id="")||(rtn'=1)  d
	.s inPara=MID_"^"_MDList(id)
	.s rtn=+(..Save("",inPara,1))
	.q:rtn'=1
	
	Q rtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 获取有效的类型串
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCPatType).GetActiveTypeStr("","113")
ClassMethod GetActiveTypeStr(MID = "", LocID = "") As %String
{
	s mRtn=""
	Q:(MID="")&&(LocID="") mRtn
	i MID="" {
		s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	}
	Q:MID="" mRtn
	s num=""
	f  s num=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",num)) Q:num=""  d
	.s sub=""
	.f  s sub=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",num,MID,sub)) Q:sub=""  d
	..s code=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",sub),2)
	..s desc=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",sub),3)
	..s active=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",sub),4)
	..q:active'=1
	..i mRtn="" s mRtn=code_":"_desc
	..e  s mRtn=mRtn_"^"_code_":"_desc
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询类型
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCPatType","QryPatType",1)
Query QryPatType(InMID = "") As %Library.Query(ROWSPEC = "rowid,code,desc,active,num,wh,url,urlName,selected")
{
}

ClassMethod QryPatTypeExecute(ByRef qHandle As %Library.Binary, InMID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s num=""
	f  s num=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",num)) Q:num=""  d
	.s sub=""
	.f  s sub=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",num,InMID,sub)) Q:sub=""  d
	..s code=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),2)
	..s desc=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),3)
	..s active=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),4)
	..s num=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),5)
	..s wh=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),6)
	..s url=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),7)
	..s selected=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildPatType",sub),8)
	..s urlName=##class(DHCDoc.PW.CFG.BCTpl).GetTPLName(InMID,url)
	..s rowid=InMID_"||"_sub
	..d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,code,desc,active,num,wh,url,urlName,selected)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryPatTypeFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryPatTypeExecute ]
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

ClassMethod QryPatTypeClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryPatTypeFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询类型
/// IN  : NoDisplayALL:不显示全部类型
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCPatType","PTypeQry",113)
Query PTypeQry(LocID = "", NoDisplayALL = "") As %Library.Query(ROWSPEC = "code,desc")
{
}

ClassMethod PTypeQryExecute(ByRef qHandle As %Library.Binary, LocID = "", NoDisplayALL = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (LocID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	if (MID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	s seqno=""
	f  s seqno=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",seqno)) q:seqno=""  d
	.s id=""
	.f  s id=$o(^User.DHCDocPassWorkBCPatTypeI("BPNum",seqno,MID,id)) q:id=""  d
	..s code=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",id),2)
	..s desc=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",id),3)
	..s desc= ##class(User.DHCDocPassWorkBCPatType).GetTranByDesc("BPDesc",desc,langid)
	..s active=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",id),4)
	..q:active'=1
	..q:(NoDisplayALL'="")&&(code="ALL")
	..d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(code,desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod PTypeQryFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = PTypeQryExecute ]
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

ClassMethod PTypeQryClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PTypeQryFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
