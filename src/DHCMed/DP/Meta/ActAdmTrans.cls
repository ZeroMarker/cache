/// 名称: DHCMed.DP.Meta.ActAdmTrans
/// 描述: 数据池之转科记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.ActAdmTrans Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 转科记录指针
Property AATTransID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AAT_TransID ];

/// 科室代码
Property AATDeptCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AAT_DeptCode ];

/// 病区代码
Property AATWardCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AAT_WardCode ];

/// 入科来源
Property AATPlaceFrom As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = AAT_PlaceFrom ];

/// 出科去向
Property AATPlaceTo As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AAT_PlaceTo ];

/// 转入时间/入院时间
Property AATInDate As %Date [ SqlColumnNumber = 7, SqlFieldName = AAT_InDate ];

/// 转出时间/出院时间
Property AATOutDate As %Date [ SqlColumnNumber = 8, SqlFieldName = AAT_OutDate ];

/// 入科诊断
Property AATInDiagnos As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = AAT_InDiagnos ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池之转科记录
/// Table：       DHCMed.DP.Meta.ActAdmTrans
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.ActAdmTrans).Update("^1^2^3^4^5^6^7^8")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.ActAdmTrans).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.ActAdmTrans).%OpenId(ID)
		}

	set obj.AATTransID=$p(InStr,separete,2)
	set obj.AATDeptCode=$p(InStr,separete,3)
	set obj.AATWardCode=$p(InStr,separete,4)
	set obj.AATPlaceFrom=+$p(InStr,separete,5)
	set obj.AATPlaceTo=$p(InStr,separete,6)
	set obj.AATInDate=$p(InStr,separete,7)
	set obj.AATOutDate=+$p(InStr,separete,8)
	set obj.AATInDiagnos=$p(InStr,separete,9)

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
/// Description:  删除数据池之转科记录
/// Table：       DHCMed.DP.Meta.ActAdmTrans
/// Input：       DHCMed.DP.Meta.ActAdmTrans.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.ActAdmTrans).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.ActAdmTrans.ID
/// Return：      DHCMed.DP.Meta.ActAdmTrans
/// w ##class(DHCMed.DP.Meta.ActAdmTrans).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.ActAdmTrans
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.ActAdmTrans).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.ActAdmTrans).%OpenId(+id)
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
<Value>AATTransID</Value>
</Value>
<Value name="3">
<Value>AATDeptCode</Value>
</Value>
<Value name="4">
<Value>AATWardCode</Value>
</Value>
<Value name="5">
<Value>AATPlaceFrom</Value>
</Value>
<Value name="6">
<Value>AATPlaceTo</Value>
</Value>
<Value name="7">
<Value>AATInDate</Value>
</Value>
<Value name="8">
<Value>AATOutDate</Value>
</Value>
<Value name="9">
<Value>AATInDiagnos</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.ActAdmTransD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.ActAdmTransD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.ActAdmTransI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.ActAdmTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
