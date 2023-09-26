/// 名称: DHCMed.DP.Meta.ActMain
/// 描述: 数据池主记录
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.ActMain Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// AMEpisodeID 指向Pa_Adm
Property AMEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = AM_EpisodeID ];

/// 数据分类（代码）
Property AMDataCate As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AM_DataCate ];

/// 数据子分类（代码）
Property AMDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AM_DataSubCat ];

/// 业务发生时间
Property AMActDate As %Date [ SqlColumnNumber = 5, SqlFieldName = AM_ActDate ];

/// 业务数据值
Property AMDataVal As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AM_DataVal ];

/// 业务数据指针
Property AMObejctID As %String [ SqlColumnNumber = 7, SqlFieldName = AM_ObejctID ];

/// 业务停止时间
Property AMXDate As %Date [ SqlColumnNumber = 8, SqlFieldName = AM_XDate ];

/// 是否有效
Property AMIsActive As %Boolean [ SqlColumnNumber = 9, SqlFieldName = AM_IsActive ];

/// 更新日期
Property AMUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = AM_UpdateDate ];

/// 更新时间
Property AMUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = AM_UpdateTime ];

/// 备注
Property AMResume As %String [ SqlColumnNumber = 12, SqlFieldName = AM_Resume ];

Index InEpisodeID On AMEpisodeID;

Index InEpisodeIDCate On (AMEpisodeID, AMDataCate, AMDataSubCat);

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池主记录
/// Table：       DHCMed.DP.Meta.ActMain
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.ActMain).Update("1^1^2^3^4^5^6^7^8^9^10^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.ActMain).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.ActMain).%OpenId(ID)
		}

	set obj.AMEpisodeID=$p(InStr,separete,2)
	set obj.AMDataCate=$p(InStr,separete,3)
	set obj.AMDataSubCat=$p(InStr,separete,4)
	set obj.AMActDate=+$p(InStr,separete,5)
	set obj.AMDataVal=$p(InStr,separete,6)
	set obj.AMObejctID=$p(InStr,separete,7)
	set obj.AMXDate=+$p(InStr,separete,8)
	set obj.AMIsActive=$p(InStr,separete,9)
	set obj.AMUpdateDate=+$p(InStr,separete,10)
	set obj.AMUpdateTime=+$p(InStr,separete,11)
	set obj.AMResume=$p(InStr,separete,12)
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
/// Description:  删除数据池主记录
/// Table：       DHCMed.DP.Meta.ActMain
/// Input：       DHCMed.DP.Meta.ActMain.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.DP.Meta.ActMain).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.ActMain).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.ActMain.ID
/// Return：      DHCMed.DP.Meta.ActMain
/// w ##class(DHCMed.DP.Meta.ActMain).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.ActMain
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.ActMain).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.ActMain).%OpenId(+id)
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
<Value>AMEpisodeID</Value>
</Value>
<Value name="3">
<Value>AMDataCate</Value>
</Value>
<Value name="4">
<Value>AMDataSubCat</Value>
</Value>
<Value name="5">
<Value>AMActDate</Value>
</Value>
<Value name="6">
<Value>AMDataVal</Value>
</Value>
<Value name="7">
<Value>AMObejctID</Value>
</Value>
<Value name="8">
<Value>AMXDate</Value>
</Value>
<Value name="9">
<Value>AMIsActive</Value>
</Value>
<Value name="10">
<Value>AMUpdateDate</Value>
</Value>
<Value name="11">
<Value>AMUpdateTime</Value>
</Value>
<Value name="12">
<Value>AMResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.ActMainD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.ActMainD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.ActMainI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.ActMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
