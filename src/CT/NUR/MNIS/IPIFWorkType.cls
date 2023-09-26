/// Creator:      fengliang
/// CreatDate:    2021-03-12
/// Description:  工作统计类型表
Class CT.NUR.MNIS.IPIFWorkType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作类型CODE
Property WorkTypeCode As %String(TRUNCATE = 1);

/// 操作类型描述
Property WorkTypeDesc As %String(TRUNCATE = 1);

/// Creator: 		fengliang
/// CreatDate: 		2021-03-12
/// Description: 	保存
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Despensing^配液^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("AuditDes^复核^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Puncture^穿刺^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Change^续液^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Tour^巡视^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Suspend^暂停^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Continue^继续^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Stop^停止^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("Finish^拔针^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("AutoFinish^续液完成^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("PutOrd^摆药^")
/// Method			w ##class(CT.NUR.MNIS.IPIFWorkType).Save("JPRec^接收^")
ClassMethod Save(parr As %String) As %String
{
	s workTypeCode=$p(parr,"^",1)
	s workTypeDesc=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	i id=""{
		s obj=##class(CT.NUR.MNIS.IPIFWorkType).%New()
	}
	else
	{
		s obj=##class(CT.NUR.MNIS.IPIFWorkType).%OpenId(modelId)
	}
	
	s obj.WorkTypeCode=workTypeCode
	s obj.WorkTypeDesc=workTypeDesc
	d obj.%Save()
	d obj.%Close()

	q ""
}

Storage Default
{
<Data name="IPIFWorkTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkTypeCode</Value>
</Value>
<Value name="3">
<Value>WorkTypeDesc</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MNIS.IPIFWorkTypeD</DataLocation>
<DefaultData>IPIFWorkTypeDefaultData</DefaultData>
<IdLocation>^CT.NUR.MNIS.IPIFWorkTypeD</IdLocation>
<IndexLocation>^CT.NUR.MNIS.IPIFWorkTypeI</IndexLocation>
<StreamLocation>^CT.NUR.MNIS.IPIFWorkTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
