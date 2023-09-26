/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生站交班本规则配置
Class DHCDoc.PW.CFG.BCRule Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 保存/更新交班本规则配置
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCRule).Save("","1^1")
ClassMethod Save(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,$C(1),1)
	s code=$P(inPara,$C(1),2)
	s desc=$P(inPara,$C(1),3)
	s val=$P(inPara,$C(1),4)
	s note=$P(inPara,$C(1),5)
	Q:MID="" "-1^父表ID为空！"
	Q:code="" "-1^代码为空！"
	Q:desc="" "-1^描述为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkBCRule).%New(MID)
	e  s SaveOBJ = ##class(User.DHCDocPassWorkBCRule).%OpenId(ID)
	d SaveOBJ.BRParRefSetObjectId(MID)
	s SaveOBJ.BRCode=code
	s SaveOBJ.BRDesc=desc
	s SaveOBJ.BRValue=val
	s SaveOBJ.BRNote=note
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存规则配置失败！"
	}
		
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCRule).Save("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,$C(1),1)
	s code=$P(inPara,$C(1),2)
	//s codeUP=$$ALPHAUP^SSUTIL4(code)    
	i ID="" {
		i $d(^User.DHCDocPassWorkBCRuleI("BRCode",code,MID)) {
			Q "-1^配置已存在！"
		}
	} else {
		s sub=$p(ID,"||",2)
		s oldCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildRule",sub),2)
		i $d(^User.DHCDocPassWorkBCRuleI("BRCode",code,MID)) {
			i oldCode'=code {
				Q "-1^配置已存在！"
			}
		}
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-12
/// DESC: 生成默认数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCRule).CreateDefaultData()
ClassMethod CreateDefaultData(MID) As %String
{
	s rtn=1
	//S MDList(1)="NoDisplay"_$C(1)_"无需显示的类型"_$C(1)
	S MDList(1)="PreSum"_$C(1)_"原有计算方式"_$C(1)_"NowSum!1^DeathNum!1^OutWardNum!1^OutHospNum!1^InWardNum!0^InHospNum!0"
	S MDList(2)="SSCode"_$C(1)_"手术申请代码"_$C(1)_"WFY001899"
	S MDList(3)="FixBCBtn"_$C(1)_"显示调整班次时间按钮"_$C(1)_0_$c(1)_"1:显示,0:不显示(默认)"
	S MDList(4)="FoldBC"_$C(1)_"是否折叠病人类型"_$C(1)_0_$c(1)_"0:折叠(默认),1:不折叠"
	
	s id=""
	f  s id=$o(MDList(id)) q:(id="")||(rtn'=1)  d
	.s inPara=MID_$C(1)_MDList(id)
	.s rtn=+(..Save("",inPara))
	.q:rtn'=1
	
	Q rtn
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 获取规则配置值
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCRule).GetRuleValue("113","FixBCBtn")
ClassMethod GetRuleValue(LocID, Code) As %String
{
	s mRtn=""
	//s Code=$$ALPHAUP^SSUTIL4(Code)   
	Q:LocID=""||Code="" mRtn
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	Q:MID="" mRtn
	s ID=$O(^User.DHCDocPassWorkBCRuleI("BRCode",Code,MID,""))
	Q:ID="" mRtn
	s mRtn=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildRule",ID),4)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询规则配置
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCRule","QryBCRule",1)
Query QryBCRule(InMID = "") As %Library.Query(ROWSPEC = "rowid,code,desc,value,note")
{
}

ClassMethod QryBCRuleExecute(ByRef qHandle As %Library.Binary, InMID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(InMID,"ChildRule",sub)) Q:sub=""  d
	.s code=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildRule",sub),2)
	.s desc=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildRule",sub),3)
	.s value=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildRule",sub),4)
	.s note=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildRule",sub),5)
	.s rowid=InMID_"||"_sub
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,code,desc,value,note)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBCRuleFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBCRuleExecute ]
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

ClassMethod QryBCRuleClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBCRuleFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
