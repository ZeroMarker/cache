/// 名称 : DHCMed.FBD.SignDic
/// 描述 : 主要症状与体征字典
Class DHCMed.FBD.SignDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
/// 规则(001、001001、001001001；002、002001、002001001)
Property SDCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property SDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 值类型(数字N、文本T)
Property SDExtraType As DHCMed.SS.Dictionary;

/// 值单位
Property SDExtraUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property SDIsActive As %Boolean;

/// 备注
Property SDResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以代码为索引
Index IndexCode On SDCode [ Unique ];

/// Creator     : zhaoyu
/// CreatDate   : 2014-11-17
/// Description : 取主要症状与体征信息
/// Table       : DHCMed.FBD.SignDic
/// Input       : ID
/// Return      : Object
/// w ##class(DHCMed.FBD.SignDic).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.SignDic
{
	New (aID)
	Quit:'##class(DHCMed.FBD.SignDic).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.SignDic).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator     : zhaoyu
/// CreatDate   : 2014-11-17
/// Description : 更新主要症状与体征信息
/// Table       : DHCMed.FBD.SignDic
/// Input       : InputStr; Separate:分隔符
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.FBD.SignDic).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String) As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:(aInputStr="")||(aSeparete="") return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set Code=$p(aInputStr,aSeparete,2)
	Set Desc=$p(aInputStr,aSeparete,3)
	Set ExtraTypeID=$p(aInputStr,aSeparete,4)
	Set ExtraUnit=$p(aInputStr,aSeparete,5)
	Set IsActive=$p(aInputStr,aSeparete,6)
	Set Resume=$p(aInputStr,aSeparete,7)
	
	Quit:($l(Code)<1)||($l(Code)#3'=0)||(Desc="") return
	Set flgCode=..CheckCode(Code)
	Quit:(ID="")&&(flgCode>0) return
	
	Set objExtraType=##class(DHCMed.SS.Dictionary).GetObjById(ExtraTypeID)
	Quit:'$IsObject(objExtraType) return
	
	If (ID="") {
		Set obj=##class(DHCMed.FBD.SignDic).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.SignDic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SDCode=Code
	Set obj.SDDesc=Desc
	Set obj.SDExtraType=objExtraType
	Set obj.SDExtraUnit=ExtraUnit
	Set obj.SDIsActive=IsActive
	Set obj.SDResume=Resume
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

/// Creator     : zhaoyu
/// CreatDate   : 2014-11-17
/// Description : 删除主要症状与体征信息
/// Table       : DHCMed.FBD.SignDic
/// Input       : ID
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.FBD.SignDic).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.SignDic).%DeleteId(+aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator     : zhaoyu
/// CreatDate   : 2014-11-17
/// Description : 检查主要症状与体征代码是否重复
/// Table       : DHCMed.FBD.SignDic
/// Input       : Code
/// Return      : return>0:成功; return<=0:失败
/// w ##class(DHCMed.FBD.SignDic).CheckCode("")
ClassMethod CheckCode(aCode As %String) As %String
{
	New (aCode)
	Set return=+$o(^DHCMed.FBD.SignDicI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDCode</Value>
</Value>
<Value name="3">
<Value>SDDesc</Value>
</Value>
<Value name="4">
<Value>SDExtraType</Value>
</Value>
<Value name="5">
<Value>SDExtraUnit</Value>
</Value>
<Value name="6">
<Value>SDIsActive</Value>
</Value>
<Value name="7">
<Value>SDResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.FBD.SignDicD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.FBD.SignDicD</IdLocation>
<IndexLocation>^DHCMed.FBD.SignDicI</IndexLocation>
<StreamLocation>^DHCMed.FBD.SignDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
