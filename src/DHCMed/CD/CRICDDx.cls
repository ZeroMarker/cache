/// 名称 : DHCMed.CD.CRICDDx
/// 描述 : 肿瘤诊断字典 用于肿瘤报卡
/// 编写者：pylian
/// 编写日期: 2019-02-20
Class DHCMed.CD.CRICDDx Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property CRCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断描述
Property CRDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断描述(全称)
Property CRFullName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否有效
Property CRIsActive As %Boolean;

/// 备注
Property CRResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以代码为索引
Index IndexCode On CRCode [ Unique ];

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 取肿瘤诊断字典信息
/// Table       : DHCMed.CD.CRICDDx
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.CD.CRICDDx).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.CD.CRICDDx
{
	New (aID)
	Quit:'##class(DHCMed.CD.CRICDDx).%ExistsId(aID) ""
	Set obj=##class(DHCMed.CD.CRICDDx).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 根据code取肿瘤诊断字典信息
/// Table       : DHCMed.CD.CRICDDx
/// Input       : aCode
/// Return      : Object
/// w ##class(DHCMed.CD.CRICDDx).GetObjByCode("")
ClassMethod GetObjByCode(aCode As %String) As DHCMed.CD.CRICDDx
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMed.CD.CRICDDxI("IndexCode"," "_$ZCVT(aCode,"U"),0))
	Set:ID'="" return=##class(DHCMed.CD.CRICDDx).GetObjById(ID)
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 根据ID取肿瘤诊断描述
/// Table       : DHCMed.CD.CRICDDx
/// Input       : aID
/// w ##class(DHCMed.CD.CRICDDx).GetDescByID("")
ClassMethod GetDescByID(aID As %String) As %String
{
	new (aID)
	set return=""
	set obj=..GetObjById(aID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()_$c(1)_obj.CRFullName
	quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 根据Code取肿瘤诊断信息
/// Table       : DHCMed.CD.CRICDDx
/// Input       : aCode
/// w ##class(DHCMed.CD.CRICDDx).GetICDByCode("C00.1")
ClassMethod GetICDByCode(aCode As %String) As %String
{
	new (aCode,session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:aCode="" return
	set xID=$o(^DHCMed.CD.CRICDDxI("IndexCode"," "_$ZCVT(aCode,"U"),0))
	set obj=..GetObjById(xID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()_$c(1)_obj.CRCode_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.CD.CRICDDx","CRDesc",Languages,obj.CRFullName)
	quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 取肿瘤诊断字典
/// Table       : DHCMed.CD.CRICDDx
/// Input       : Object
/// w ##class(DHCMed.CD.CRICDDx).GetDescByObj("")
ClassMethod GetDescByObj(obj As DHCMed.CD.CRICDDx) As %String
{
	new (obj)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_obj.CRFullName
	quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 更新肿瘤诊断字典信息
/// Table       : DHCMed.CD.CRICDDx
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRICDDx).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set Code=$p(aInputStr,aSeparete,2)
	Set Desc=$p(aInputStr,aSeparete,3)
	Set FullName=$p(aInputStr,aSeparete,4)
	Set IsActive=+$p(aInputStr,aSeparete,5)
	Set Resume=$p(aInputStr,aSeparete,6)
	
	Quit:($l(Code)<1)||(Desc="")||(FullName="") return
    Set flgCode=..CheckCode(Code)
	Quit:(ID="")&&(flgCode>0) return
	
	Set tID=$o(^DHCMed.CD.CRICDDxI("IndexCode"," "_$ZCVT(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If (ID="") {
		Set obj=##class(DHCMed.CD.CRICDDx).%New()
	} Else {
		Set obj=##class(DHCMed.CD.CRICDDx).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CRCode=Code
	Set obj.CRDesc=Desc
	Set obj.CRFullName=FullName
	Set obj.CRIsActive=IsActive
	Set obj.CRResume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 删除肿瘤诊断字典信息
/// Table       : DHCMed.CD.CRICDDx
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRICDDx).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.CD.CRICDDx).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2019-02-20
/// Description : 检查肿瘤诊断字典代码是否重复
/// Table       : DHCMed.CD.CRICDDx
/// Input       : Code
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.CD.CRICDDx).CheckCode("")
ClassMethod CheckCode(aCode As %String) As %String
{
	New (aCode)
	Set return=+$o(^DHCMed.CD.CRICDDxI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Quit return
}

Storage Default
{
<Data name="CRICDDxDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRCode</Value>
</Value>
<Value name="3">
<Value>CRDesc</Value>
</Value>
<Value name="4">
<Value>CRFullName</Value>
</Value>
<Value name="5">
<Value>CRIsActive</Value>
</Value>
<Value name="6">
<Value>CRResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CD.CRICDDxD</DataLocation>
<DefaultData>CRICDDxDefaultData</DefaultData>
<IdLocation>^DHCMed.CD.CRICDDxD</IdLocation>
<IndexLocation>^DHCMed.CD.CRICDDxI</IndexLocation>
<StreamLocation>^DHCMed.CD.CRICDDxS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
