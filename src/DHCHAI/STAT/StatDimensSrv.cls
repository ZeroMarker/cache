/// 名称: DHCHAI.STAT.StatDimensSrv
/// 描述: 统计维度相关服务
/// 编写者：zhufei
/// 编写日期: 2018-12-15
Class DHCHAI.STAT.StatDimensSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-12-15
/// Description:  获取统计维度信息(取全部统计维护)
/// Table：       无
/// Input：       aStatDimens: 统计维度
///               aHospDr    : 医院ID
///               aGroupDr   : 科室组ID
///               aLocDr     : 科室ID
///               aWard Dr   : 病区ID
/// Return：      返回String
/// w ##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensInfo("AGW",1,2,3,4)
ClassMethod GetStatDimensInfo(aStatDimens As %String, aHospDr As %String, aGroupDr As %String, aLocDr As %String, aWardDr As %String) As %String
{
	New (aStatDimens,aHospDr,aGroupDr,aLocDr,aWardDr)
	Set return=""
	Quit:aStatDimens="" return
	Quit:(aStatDimens["H")&(aHospDr="") return
	Quit:(aStatDimens["E")&(aLocDr="") return
	Quit:(aStatDimens["W")&(aWardDr="") return
	
	If aStatDimens["G" {
		If aGroupDr="" {
			Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjByDesc("其他科")
			If $IsObject(objGroup) {
				Set aGroupDr=objGroup.%Id()
			}
		}
		Quit:(aStatDimens["G")&(aGroupDr="") return
	}
	
	Set StatDimensList=""
	For indSD=1:1:$l(aStatDimens) {
		Set tKey=$e(aStatDimens,indSD,indSD)
		
		Set tTxt=""
		If tKey="A" {
			Set tTxt="0"
		} ElseIf tKey="H" {
			Set $p(tTxt,"0",9-$l(aHospDr))=aHospDr
		} ElseIf tKey="G" {
			Set $p(tTxt,"0",9-$l(aGroupDr))=aGroupDr
		} ElseIf tKey="E" {
			Set $p(tTxt,"0",9-$l(aLocDr))=aLocDr
		} ElseIf tKey="W" {
			Set $p(tTxt,"0",9-$l(aWardDr))=aWardDr
		}
		Continue:tTxt=""
		Set tTxt=tKey_tTxt
		
		If StatDimensList="" {
			Set StatDimensList=$lb(tTxt)
		} Else {
			Set pTxt=$lg(StatDimensList,$ll(StatDimensList))
			Set StatDimensList=StatDimensList_$lb(pTxt_"-"_tTxt)
		}
	}
	Set return=$listtostring(StatDimensList,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-12-15
/// Description:  获取统计维度信息(取最后一级统计维度)
/// Table：       无
/// Input：       aStatDimens: 统计维度
///               aHospDr    : 医院ID
///               aGroupDr   : 科室组ID
///               aLocDr     : 科室ID
///               aWard Dr   : 病区ID
/// Return：      返回String
/// w ##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensInfo2("AHGEW",1,1,2,3)
ClassMethod GetStatDimensInfo2(aStatDimens As %String, aHospDr As %String, aGroupDr As %String, aLocDr As %String, aWardDr As %String) As %String
{
	New (aStatDimens,aHospDr,aGroupDr,aLocDr,aWardDr)
	Set StatDimens=..GetStatDimensInfo(aStatDimens,aHospDr,aGroupDr,aLocDr,aWardDr)
	Quit:StatDimens="" return
	Set return=$p(StatDimens,"^",$l(StatDimens,"^"))
	Quit return
}

/// w ##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensDesc("A0-H00000001-G00000001-E00000002-W00000003")
ClassMethod GetStatDimensDesc(aDimensKey As %String) As %String
{
	New (aDimensKey)
	Set return=""
	Quit:aDimensKey="" return
	
	Set num=$l(aDimensKey,"-")
	Set tKey=$p(aDimensKey,"-",num)
	Set tType=$e(tKey,1,1)
	Set tValue=+$e(tKey,2,$l(tKey))
	If tType="A" {
		Set return="全院"
	} ElseIf tType="H" {
		Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(tValue)
		If $IsObject(objHosp) {
			Set return=objHosp.BTDesc
		}
	} ElseIf tType="G" {
		Set objGroup=##class(DHCHAI.BT.LocGroup).GetObjById(tValue)
		If $IsObject(objGroup) {
			Set return=objGroup.BTDesc
		} Else {
			
		}
	} ElseIf tType="E" {
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(tValue)
		If $IsObject(objLoc) {
			Set LocDesc=objLoc.BTDesc
			Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
			Set return=LocDesc
		}
	} ElseIf tType="W" {
		Set objWard=##class(DHCHAI.BT.Location).GetObjById(tValue)
		If $IsObject(objWard) {
			Set WardDesc=objWard.BTDesc
			Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
			Set return=WardDesc
		}
	}
	If num=3 {
		Set return="    "_return
	} ElseIf num=4 {
		Set return="        "_return
	}
	Quit return
}

/// w ##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensArgs("A0-H00000001-G00000001-E00000002-W00000003")
ClassMethod GetStatDimensArgs(aDimensKey As %String) As %String
{
	New (aDimensKey)
	Set return=""
	Quit:aDimensKey="" return
	
	Set StatDimens="",HospDr="",GroupDr="",LocDr="",WardDr=""
	For indDK=1:1:$l(aDimensKey,"-") {
		Set tKey=$p(aDimensKey,"-",indDK)
		Continue:tKey=""
		Set tType=$e(tKey,1,1)
		Set tValue=+$e(tKey,2,$l(tKey))
		Set:tValue=0 tValue=""
		If tType="H" {
			Set HospDr=tValue
		} ElseIf tType="G" {
			Set GroupDr=tValue
		} ElseIf tType="E" {
			Set LocDr=tValue
		} ElseIf tType="W" {
			Set WardDr=tValue
		}
		Set StatDimens=StatDimens_tType
	}
	Set return=StatDimens_"^"_HospDr_"^"_GroupDr_"^"_LocDr_"^"_WardDr
	Quit return
}

/// w ##class(DHCHAI.STAT.StatDimensSrv).GetStatDimensStr()
ClassMethod GetStatDimensStr(aType As %String = "") As %String
{
	New (aType)
	Set return=""
	
	If aType="E" {
		Set return="AGE"
	} Else {
		Set return="AGW"
	}
	Quit return
}

}
