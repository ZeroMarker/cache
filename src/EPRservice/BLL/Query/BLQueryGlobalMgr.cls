/// 名称：EPRservice.BLL.Query.BLQueryGlobalMgr
/// 描述：查询临时Global管理器
/// 创建者：houjian
/// 创建日期：2011-06-03
Class EPRservice.BLL.Query.BLQueryGlobalMgr Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, ProcedureBlock ]
{

/// 唯一标识符
Property GUID As %String(TRUNCATE = 1);

/// Desc:	生成唯一标识符, 用于存储查询结果	
ClassMethod GetGUID() As %String
{
	q $I(^CacheTempDHCEPR)
}

/// Desc:	实例化
ClassMethod CreateInstance(AGUID As %String) As EPRservice.BLL.Query.BLQueryGlobalMgr
{
	s obj = ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).%New()
	s obj.GUID = AGUID
	q obj
}

/// Desc:	存储EpisodeID到临时Global
Method SetEpisodeIDAt(AEpisodeID As %String, AKey As %String)
{
	s ^CacheTempDHCEPR(%this.GUID, "EpisodeID", AKey) = AEpisodeID
}

/// Desc:	从临时Global获取位置AKey处的EpisodeID
Method GetEpisodeIDAt(AKey As %String) As %String
{
	q $G(^CacheTempDHCEPR(%this.GUID, "EpisodeID", AKey))
}

/// Desc:	获取AKey下一个节点位置的EpisodeID
/// Input：	AKey：当前节点位置
/// Output:	AKey增加1，表示下一个节点位置；
///         若已到Global的末尾，则Akey返回空值
/// Return:	下一个节点位置的EpisodeID
/// 		若下一个节点位置不存在，返回空值
/// Other：	使用时，先判断Akey是否为空，若为空，表示已到Global结尾
/// 		此时返回值无业务意义，不可用
Method GetNextEpisodeID(ByRef AKey As %String) As %String
{
	s AKey = $O(^CacheTempDHCEPR(%this.GUID, "EpisodeID", AKey))
	q:(AKey = "") ""
	q $G(^CacheTempDHCEPR(%this.GUID, "EpisodeID", AKey))
}

/// Desc:	设置就诊列表总数
Method SetEpisodeCount(ACount As %Integer) As %Status
{
	if (ACount = "") s ACount = 0
	s ^CacheTempDHCEPR(%this.GUID, "EpisodeCount") = ACount
	q $$$OK
}

/// Desc:	获取就诊列表总数
Method GetEpisodeCount() As %Integer
{
	s count = $G(^CacheTempDHCEPR(%this.GUID, "EpisodeCount"))
	if (count = "") s count = 0
	q count
}

/// Desc:	存储查询结果到临时Global的位置Akey处
Method SetResultAt(AResultList As %List, AKey As %String)
{
	s ^CacheTempDHCEPR(%this.GUID, "Result", AKey) = AResultList
}

/// Desc:	从临时Global的位置Akey处获取查询结果
Method GetResultAt(AKey As %String) As %List
{
	q $g(^CacheTempDHCEPR(%this.GUID, "Result", AKey))
}

/// Desc:	获取AKey下一个节点位置的查询结果数据
/// Input：	AKey：当前节点位置
/// Output:	AKey增加1，表示下一个节点位置；
///         若已到Global的末尾，则Akey返回空值
/// Return:	下一个节点位置的查询结果数据
/// 		若下一个节点位置不存在，返回空值
/// Other：	使用时，先判断Akey是否为空，若为空，表示已到Global结尾
/// 		此时返回值无业务意义，不可用
Method GetNextResult(ByRef AKey As %String) As %List
{
	s AKey = $o(^CacheTempDHCEPR(%this.GUID, "Result", AKey))
	q:(AKey = "") ""
	q $g(^CacheTempDHCEPR(%this.GUID, "Result", AKey))
}

/// Desc:	临时Glboal的位置Akey处是否存储了查询结果数据
/// Input:	AKey：当前节点位置
/// Output: 无
/// Return:	1 查询结果数据已存在；0 查询结果数据不存在
Method IsResultExistedAt(AKey As %String) As %Boolean
{
	s status = $D(^CacheTempDHCEPR(%this.GUID, "Result", AKey))
	q:(status = "11") 1
	q 0
}

/// Desc:	清空唯一标识符GUID下的临时Glboal数据
Method ClearGlobal() As %Boolean
{
	q:(%this.GUID = "") 0
	q ..ClearGlobalByGUID(%this.GUID)
}

ClassMethod ClearGlobalByGUID(AGUID As %String) As %Boolean
{
	q:(AGUID = "") 0
	k ^CacheTempDHCEPR(AGUID)
	q 1
}

Storage Default
{
<Data name="BLTempGlobalMgrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GUID</Value>
</Value>
</Data>
<DataLocation>^EPRservice724.BLTempGlobal59BD</DataLocation>
<DefaultData>BLTempGlobalMgrDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservice724.BLTempGlobal59BD</IdLocation>
<IndexLocation>^EPRservice724.BLTempGlobal59BI</IndexLocation>
<StreamLocation>^EPRservice724.BLTempGlobal59BS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
