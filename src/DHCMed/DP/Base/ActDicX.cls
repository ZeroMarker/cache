/// 名称: DHCMed.DP.Base.ActDicX
/// 描述: 数据字典
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Base.ActDicX Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 字典类别COde
Property ADXDicCate As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADX_DicCate ];

/// 项目代码
Property ADXCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADX_Code ];

/// 名称
Property ADXDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ADX_Desc ];

/// 标注1
Property ADXText1 As %String [ SqlColumnNumber = 5, SqlFieldName = ADX_Text1 ];

/// 标注2
Property ADXText2 As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ADX_Text2 ];

/// 标注3
Property ADXText3 As %String [ SqlColumnNumber = 7, SqlFieldName = ADX_Text3 ];

/// 标注4
Property ADXText4 As %String [ SqlColumnNumber = 8, SqlFieldName = ADX_Text4 ];

/// 标注5
Property ADXText5 As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ADX_Text5 ];

/// 标注6
Property ADXText6 As %String [ SqlColumnNumber = 10, SqlFieldName = ADX_Text6 ];

/// 标注7
Property ADXText7 As %String [ SqlColumnNumber = 11, SqlFieldName = ADX_Text7 ];

/// 标注8
Property ADXText8 As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ADX_Text8 ];

/// 标注9
Property ADXText9 As %String [ SqlColumnNumber = 13, SqlFieldName = ADX_Text9 ];

/// 标注10
Property ADXText10 As %String [ SqlColumnNumber = 14, SqlFieldName = ADX_Text10 ];

/// 是否有效
Property ADXIsActive As %Boolean [ SqlColumnNumber = 15, SqlFieldName = ADX_IsActive ];

/// 备注
Property ADXResume As %String [ SqlColumnNumber = 16, SqlFieldName = ADX_Resume ];

Index IndexCategoryCode On (ADXDicCate As SqlUpper, ADXCode As SqlUpper);

Index IndexCategoryDesc On (ADXDicCate As SqlUpper, ADXDesc As SqlUpper);

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据字典
/// Table：       DHCMed.DP.Base.ActDicX
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Base.ActDicX).Update("^SS-WORD-CAT^LIS-PY^检验病原体^^^^^^^^^^^1^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Base.ActDicX).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Base.ActDicX).%OpenId(ID)
		}

	set obj.ADXDicCate=$p(InStr,separete,2)
	set obj.ADXCode=$p(InStr,separete,3)
	set obj.ADXDesc=$p(InStr,separete,4)
	set obj.ADXText1=$p(InStr,separete,5)
	set obj.ADXText2=$p(InStr,separete,6)
	set obj.ADXText3=$p(InStr,separete,7)
	set obj.ADXText4=$p(InStr,separete,8)
	set obj.ADXText5=$p(InStr,separete,9)
	set obj.ADXText6=$p(InStr,separete,10)
	set obj.ADXText7=$p(InStr,separete,11)
	set obj.ADXText8=$p(InStr,separete,12)
	set obj.ADXText9=$p(InStr,separete,13)
	set obj.ADXText10=$p(InStr,separete,14)
	set obj.ADXIsActive=+$p(InStr,separete,15)
	set obj.ADXResume=$p(InStr,separete,16)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  删除数据字典
/// Table：       DHCMed.DP.Base.ActDicX
/// Input：       DHCMed.DP.Base.ActDicX.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Base.ActDicX).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Base.ActDicX.ID
/// Return：      DHCMed.DP.Base.ActDicX
/// w ##class(DHCMed.DP.Base.ActDicX).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Base.ActDicX
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Base.ActDicX).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Base.ActDicX).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Input：       DHCMed.DP.Base.ActDicX.DicCate、DHCMed.DP.Base.ActDicX.Code
/// Return：      DHCMed.DP.Base.ActDicX
/// w ##class(DHCMed.DP.Base.ActDicX).GetObjByCode(1)
ClassMethod GetObjByCode(aCategory As %String, aCode As %String) As DHCMed.DP.Base.ActDicX
{
	new (aCategory,aCode)
	set return=""
	quit:(aCategory="")||(aCode="") return
	
	set ID=$o(^DHCMed.DP.Base.ActDicXI("IndexCategoryCode"," "_$zcvt(aCategory,"U")," "_$zcvt(aCode,"U"),0))
	quit:'##class(DHCMed.DP.Base.ActDicX).%ExistsId(+ID) return
	set obj=##Class(DHCMed.DP.Base.ActDicX).%OpenId(+ID)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ADXDicCate</Value>
</Value>
<Value name="3">
<Value>ADXCode</Value>
</Value>
<Value name="4">
<Value>ADXDesc</Value>
</Value>
<Value name="5">
<Value>ADXText1</Value>
</Value>
<Value name="6">
<Value>ADXText2</Value>
</Value>
<Value name="7">
<Value>ADXText3</Value>
</Value>
<Value name="8">
<Value>ADXText4</Value>
</Value>
<Value name="9">
<Value>ADXText5</Value>
</Value>
<Value name="10">
<Value>ADXText6</Value>
</Value>
<Value name="11">
<Value>ADXText7</Value>
</Value>
<Value name="12">
<Value>ADXText8</Value>
</Value>
<Value name="13">
<Value>ADXText9</Value>
</Value>
<Value name="14">
<Value>ADXText10</Value>
</Value>
<Value name="15">
<Value>ADXIsActive</Value>
</Value>
<Value name="16">
<Value>ADXResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Base.ActDicXD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Base.ActDicXD</IdLocation>
<IndexLocation>^DHCMed.DP.Base.ActDicXI</IndexLocation>
<StreamLocation>^DHCMed.DP.Base.ActDicXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
