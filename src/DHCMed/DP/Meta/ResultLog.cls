/// 名称: DHCMed.DP.Meta.ResultLog
/// 描述: 数据池日志记录
/// 编写者：zhufei
/// 编写日期: 2014-07-01
Class DHCMed.DP.Meta.ResultLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 业务指针
Property RLRecordID As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RL_RecordID ];

/// RLEpisodeID 指向Pa_Adm
Property RLEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RL_EpisodeID ];

/// 数据分类
Property RLCategory As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RL_Category ];

/// 数据子分类
Property RLSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RL_SubCat ];

/// 状态标记（V核实、E执行、D停止、U作废、C撤销）
Property RLStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RL_Status ];

/// 记录日期
Property RLActDate As %Date [ SqlColumnNumber = 7, SqlFieldName = RL_ActDate ];

/// 记录时间
Property RLActTime As %Time [ SqlColumnNumber = 8, SqlFieldName = RL_ActTime ];

/// 备注
Property RLResume As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = RL_Resume ];

Index IndexPaadmStatus On (RLEpisodeID, RLStatus);

Index IndexCategStatus On (RLCategory, RLSubCat, RLStatus);

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  取值数据池日志记录
/// Input：       DHCMed.DP.Meta.ResultLog.ID
/// Return：      DHCMed.DP.Meta.ResultLog
/// w ##class(DHCMed.DP.Meta.ResultLog).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.ResultLog
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.ResultLog).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.ResultLog).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  更新数据池日志记录
/// Table：       DHCMed.DP.Meta.ResultLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.ResultLog).Update("1^1^2^3^4^5^6^7^8^9^10^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.ResultLog).%New()
	} else {
		set obj=##class(DHCMed.DP.Meta.ResultLog).%OpenId(ID)
	}
	
	set obj.RLRecordID=$p(InStr,separete,2)
	set obj.RLEpisodeID=$p(InStr,separete,3)
	set obj.RLCategory=$p(InStr,separete,4)
	set obj.RLSubCat=$p(InStr,separete,5)
	set obj.RLStatus=$p(InStr,separete,6)
	set obj.RLActDate=$p(InStr,separete,7)
	set obj.RLActTime=$p(InStr,separete,8)
	set obj.RLResume=$p(InStr,separete,9)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  删除数据池日志记录
/// Table：       DHCMed.DP.Meta.ResultLog
/// Input：       DHCMed.DP.Meta.ResultLog.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.DP.Meta.ResultLog).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.ResultLog).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
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
<Value name="13">
<Value>RLEpisodeID</Value>
</Value>
<Value name="14">
<Value>RLCategory</Value>
</Value>
<Value name="15">
<Value>RLSubCat</Value>
</Value>
<Value name="16">
<Value>RLActDate</Value>
</Value>
<Value name="17">
<Value>RLDataVal</Value>
</Value>
<Value name="18">
<Value>RLObejctID</Value>
</Value>
<Value name="19">
<Value>RLXDate</Value>
</Value>
<Value name="20">
<Value>RLIsActive</Value>
</Value>
<Value name="21">
<Value>RLUpdateDate</Value>
</Value>
<Value name="22">
<Value>RLUpdateTime</Value>
</Value>
<Value name="23">
<Value>RLResume</Value>
</Value>
<Value name="24">
<Value>RLStatus</Value>
</Value>
<Value name="25">
<Value>RLSttDate</Value>
</Value>
<Value name="26">
<Value>RLActTime</Value>
</Value>
<Value name="27">
<Value>RLEndDate</Value>
</Value>
<Value name="28">
<Value>RLRecordID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.ResultLogD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.ResultLogD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.ResultLogI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.ResultLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
