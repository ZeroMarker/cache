Class DHCMed.EPD.AppendixCardSub Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// MACI_ParRef
Property MACIParRef As %Library.Integer;

/// Modified By LiYang 附卡项目名称
Property MACIName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0);

/// MACI_Active
Property MACIActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 数据类型
/// 传染病附卡项目的数据类型，原来保存在公共字典结构中，现在保存在这里了。 
Property MACIDataType As %Integer;

/// 辅助字典名称--指向公共字典名字
Property MACIDicName As %String;

/// 默认值表达式
Property MACIValExp As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0);

/// 是否必填项
Property MACIIsNecess As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// add By pylian 2018-09-11 附卡项目code(前台html中项目的id)
Property MACICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0);

Index IndexParef On MACIParRef;

Index IndexCode On (MACIParRef, MACICode);

ClassMethod GetObjById(ID As %String) As DHCMed.EPD.AppendixCardSub
{
	New (ID)
	Set obj=##Class(DHCMed.EPD.AppendixCardSub).%OpenId(ID)
	if (obj'="")
	{
		d obj.%Close()
	}
	Quit obj
}

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=return_..%Id()_separete
	set return=return_..MACIParRef_separete
	set return=return_..MACIName_separete
	set return=return_..MACIDataType_separete
	set return=return_..MACIDicName_separete
	set return=return_..MACIActive_separete
	set return=return_..MACIValExp_separete
	set return=return_..MACIIsNecess_separete
	set return=return_..MACICode_separete
	q return
}

/// Creator：     李阳
/// CreatDate：   2010-04-08
/// Description:  根据ID取传染病附卡信息
/// Input：       DHCMed.EPD.AppendixCard.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.EPD.AppendixCardSub).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// 功能：保存传染病附卡信息
/// 参数：Parref^ChildSub^DictionaryDr^IsActive
/// 返回值：生成的Rowid
/// w ##class(DHCMed.EPD.AppendixCardSub).Update("^1^1^Y^1^^")
ClassMethod Update(InString As %String, separete As %String) As %String
{
	//n (InString,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
    Set RowID=$p(InString,separete,1)
    Set Code=$p(InString,separete,9)
    Set:RowID="" RowID = ..GetIDByCode(Code)
    IF (RowID'="")
    {
    	Set obj=##class(DHCMed.EPD.AppendixCardSub).GetObjById(RowID)
    }
    else
    {
	    Set obj=##class(DHCMed.EPD.AppendixCardSub).%New()
	}
	
	Set obj.MACIParRef=$p(InString,separete,2)
    Set obj.MACIName=$p(InString,separete,3)
    Set obj.MACIActive=$s($p(InString,separete,4)["Y":"Y",1:"N")
    Set obj.MACIDataType=$p(InString,separete,5)
    Set obj.MACIDicName=$p(InString,separete,6)
    Set obj.MACIValExp=$p(InString,separete,7)
    Set obj.MACIIsNecess=$s($p(InString,separete,8)["Y":"Y",1:"N")
    Set obj.MACICode=$p(InString,separete,9)
    Set ret=obj.%Save()
    Set RowID=obj.%Id()
    Do obj.%Close()
    Set obj=""
    Kill obj
	quit RowID
}

/// w ##class(DHCMed.EPD.AppendixCardSub).GetIDByCode("num-HIVInjection")
ClassMethod GetIDByCode(aCode As %String) As %String
{
	new (aCode)
	Set return = ""
	Set aFlag  = 0
	Set xID = ""
	For{
		Set xID = $o(^DHCMed.EPDC("ACSUB",xID))
		Quit:xID=""
		Quit:aFlag=1
		Set ACSUBInfo = $g(^DHCMed.EPDC("ACSUB",xID))
		Set ACSUBCode = $LG(ACSUBInfo,9)
		Continue:ACSUBCode'=aCode
		Set aFlag = 1
		Set return = xID
	}
	Quit return
}

Storage Default
{
<Data name="DataMasterMap">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MACIActive</Value>
</Value>
<Value name="3">
<Value>MACIDataType</Value>
</Value>
<Value name="4">
<Value>MACIDicName</Value>
</Value>
<Value name="5">
<Value>MACIName</Value>
</Value>
<Value name="6">
<Value>MACIParRef</Value>
</Value>
<Value name="7">
<Value>MACIValExp</Value>
</Value>
<Value name="8">
<Value>MACIIsNecess</Value>
</Value>
<Value name="9">
<Value>MACICode</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPDC("ACSUB")</DataLocation>
<DefaultData>DataMasterMap</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.EPDC("ACSUB")</IdLocation>
<IndexLocation>^DHCMed.EPDCi("ACSUB")</IndexLocation>
<StreamLocation>^DHCMed.EPD.AppendixCardSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
