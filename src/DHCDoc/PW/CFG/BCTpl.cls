/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 医生站交班本模板类
Class DHCDoc.PW.CFG.BCTpl Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 保存/更新交班本关联科室
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTpl).Save("","1^1^")
ClassMethod Save(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,$C(1),1)
	s URL=$P(inPara,$C(1),2)
	s Name=$P(inPara,$C(1),3)
	s Active=$P(inPara,$C(1),4)
	s Rpx=$P(inPara,$C(1),5)
	Q:MID="" "-1^父表ID为空！"
	Q:URL="" "-1^链接为空为空！"
	Q:Name="" "-1^描述为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkBCTpl).%New(MID)
	e  s SaveOBJ = ##class(User.DHCDocPassWorkBCTpl).%OpenId(ID)
	d SaveOBJ.TPLParRefSetObjectId(MID)
	s SaveOBJ.TPLName=Name
	s SaveOBJ.TPLURL=URL
	s SaveOBJ.TPLActive=Active
	s SaveOBJ.TPLRpx=Rpx
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存模板失败！"
	}
		
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTpl).Delete("")
ClassMethod Delete(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkBCTpl WHERE ID=:ID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTpl).IsAdd("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,$C(1),1)
	s URL=$P(inPara,$C(1),2)
	s Active=$P(inPara,$C(1),4)
	
	i ID="" {
		i $d(^User.DHCDocPassWorkBCTplI("TPLURL",URL,MID)) {
			Q "-1^配置已存在！"
		}
	} else {
		s sub=$p(ID,"||",2)
		s oldURL=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTPL",sub),2)
		i $d(^User.DHCDocPassWorkBCTplI("TPLURL",URL,MID)) {
			i oldURL'=URL {
				Q "-1^配置已存在！"
			}
		}
	}
	
	i Active=0 {
		i $d(^User.DHCDocPassWorkBCPatTypeI("BPURL",URL,MID)) {
			Q "-1^该模板已在【病人类型】中配置，不能取消激活！"
		}		
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTpl).GetTPLName(MID,URL)
ClassMethod GetTPLName(MID, URL)
{
	s mRtn=""
	s SUB=$o(^User.DHCDocPassWorkBCTplI("TPLURL",URL,MID,""))
	Q:SUB="" mRtn
	s mRtn=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTPL",SUB),3)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-12
/// DESC: 生成默认数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTpl).CreateDefaultData()
ClassMethod CreateDefaultData(MID) As %String
{
	s rtn=1
	S MDList(1)="dhcdoc.passwork.nmain.comtpl.csp"_$C(1)_"公共模板"_$C(1)_"1"_$C(1)_"PassWork-PrintMainCom.rpx"
	S MDList(2)="dhcdoc.passwork.tpl.gzth.special.csp"_$C(1)_"合并特殊疾病模板"_$C(1)_"1"_$C(1)_"PassWork-PrintMainSpecial.rpx"
	S MDList(3)="dhcdoc.passwork.tpl.gzth.critical.csp"_$C(1)_"危重症、特级、一级护理模板"_$C(1)_"1"_$C(1)_"PassWork-PrintMainCritical.rpx"
	
	s id=""
	f  s id=$o(MDList(id)) q:(id="")||(rtn'=1)  d
	.s inPara=MID_$C(1)_MDList(id)
	.s rtn=+(..Save("",inPara))
	.q:rtn'=1
	
	Q rtn
}

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 查询模板
/// IN  : 
/// OUT : 
/// TABL: DHC_DocPassWorkBcs
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCTpl","QryBCTPL",1)
Query QryBCTPL(InMID = "", InActive = "") As %Library.Query(ROWSPEC = "rowid,url,name,active,rpx")
{
}

ClassMethod QryBCTPLExecute(ByRef qHandle As %Library.Binary, InMID = "", InActive = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(InMID,"ChildTPL",sub)) Q:sub=""  d
	.s url=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTPL",sub),2)
	.s name=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTPL",sub),3)
	.s active=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTPL",sub),4)
	.s rpx=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTPL",sub),5)
	.q:(InActive'="")&&(InActive'=active)
	.q:url=""
	.s rowid=InMID_"||"_sub
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,url,name,active,rpx)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBCTPLFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBCTPLExecute ]
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

ClassMethod QryBCTPLClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBCTPLFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
