/// 名称: DHCMA.Util.BT.DicTypeMap
/// 描述: 基础字典类型对照表
/// 编写者：pylian
/// 编写日期: 2020-06-09
Class DHCMA.Util.BT.DicTypeMap Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// MapDicType 标准字典类型
Property MapDicType As %String(MAXLEN = 100, TRUNCATE = 1);

/// Product 产品代码
Property MapProduct As %String(MAXLEN = 100, TRUNCATE = 1);

/// MapProDicType 产品字典类型
Property MapProDicType As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexMapProType On (MapDicType, MapProduct, MapProDicType) [ Unique ];

Index IndexMapType On MapDicType;

Index IndexMapPro On (MapDicType, MapProduct);

/// Creator     : pylian
/// CreatDate   : 2020-06-09
/// Description : 取基础字典类型对照表
/// Table       : DHCMA.Util.BT.DicTypeMap
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMA.Util.BT.DicTypeMap).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMA.Util.BT.DicTypeMap
{
	New (aID)
	Quit:'##class(DHCMA.Util.BT.DicTypeMap).%ExistsId(aID) ""
	Set obj=##class(DHCMA.Util.BT.DicTypeMap).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : pylian
/// CreatDate   : 2020-06-09
/// Description : 取基础字典类型ID
/// Table       : DHCMA.Util.BT.DicTypeMap
/// Return       : ID
/// w ##class(DHCMA.Util.BT.DicTypeMap).GetIdByType("HISCTSex","DTH","DTCSex")
ClassMethod GetIdByType(aDicType As %String, aProduct As %String, aProDicType As %String) As DHCMA.Util.BT.DicTypeMap
{
	New (aDicType,aProduct,aProDicType)
	Quit:(aDicType="")||(aProduct="")||(aProDicType="") ""
	Set ID=$o(^CT.MA.Util.BT.DicTypeMapI("IndexMapProType"," "_$zcvt(aDicType,"U")," "_$zcvt(aProduct,"U")," "_$zcvt(aProDicType,"U"),0))
	Quit:ID="" ""
	Quit ID
}

/// Creator     : pylian
/// CreatDate   : 2020-06-09
/// Description : 更新基础字典类型对照表
/// Table       : DHCMA.Util.BT.DicTypeMap
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMA.Util.BT.DicTypeMap).Update("^HISCTMarital^EPD^EpdSexWed","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID          = $p(aInputStr,aSeparete,1)
	Set DicType     = $p(aInputStr,aSeparete,2) 
	Set Product     = $p(aInputStr,aSeparete,3) 
	Set ProDicType  = $p(aInputStr,aSeparete,4) 
	Quit:(DicType="")||(Product="")||(ProDicType="") return
	
	Set tID=$o(^CT.MA.Util.BT.DicTypeMapI("IndexMapProType"," "_$zcvt(DicType,"U")," "_$zcvt(Product,"U")," "_$zcvt(ProDicType,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If (ID="") {
		Set obj=##class(DHCMA.Util.BT.DicTypeMap).%New()
	} Else {
		Set obj=##class(DHCMA.Util.BT.DicTypeMap).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MapDicType   = DicType
	Set obj.MapProduct      = Product 
	Set obj.MapProDicType   = ProDicType

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
/// CreatDate   : 2020-06-09
/// Description : 删除基础字典类型对照表
/// Table       : DHCMA.Util.BT.DicTypeMap
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMA.Util.BT.DicTypeMap).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMA.Util.BT.DicTypeMap).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MapDicType</Value>
</Value>
<Value name="3">
<Value>MapProduct</Value>
</Value>
<Value name="4">
<Value>MapProDicType</Value>
</Value>
</Data>
<DataLocation>^CT.MA.Util.BT.DicTypeMapD</DataLocation>
<DefaultData>MapDefaultData</DefaultData>
<IdLocation>^CT.MA.Util.BT.DicTypeMapD</IdLocation>
<IndexLocation>^CT.MA.Util.BT.DicTypeMapI</IndexLocation>
<StreamLocation>^CT.MA.Util.BT.DicTypeMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
