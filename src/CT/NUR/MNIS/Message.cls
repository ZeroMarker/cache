/// Creator:      fengliang
/// CreatDate:    2021-03-12
/// Description:  PDA护理病历模板模板配置	
Class CT.NUR.MNIS.Message Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MsgName As %String(TRUNCATE = 1);

Property MsgCode As %String(TRUNCATE = 1);

Property MsgSort As %String(TRUNCATE = 1);

Property MsgCanFlag As %String(TRUNCATE = 1);

Index codeIndex On MsgCode;

Index sortIndex On MsgSort;

/// Creator: 		lms
/// CreatDate: 		2019-07-25
/// Description: 	保存维护的模板配置	
/// Input			"模板名称^模板代码^顺序^是否启用^模板Id^用户Id"
/// Return：		""
/// Method			w ##class(CT.NUR.MNIS.Message).Save("新医嘱^NewOrd^1^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.Message).Save("新停医嘱^StopOrd^2^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.Message).Save("危急值^Abnormal^3^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.Message).Save("会诊^Consult^4^Y^^1")
/// Method			w ##class(CT.NUR.MNIS.Message).Save("皮试^Skin^5^Y^^1")
ClassMethod Save(parr As %String) As %String
{
	s modelName=$p(parr,"^",1)
	s modelCode=$p(parr,"^",2)
	s modelSort=$p(parr,"^",3)
	s modelcanFlag=$p(parr,"^",4)
	s modelId=$p(parr,"^",5)
	i modelcanFlag="" s modelcanFlag="Y"
	i modelId=""{
		s obj=##class(CT.NUR.MNIS.Message).%New()
	}
	else
	{
		s obj=##class(CT.NUR.MNIS.Message).%OpenId(modelId)
	}
	
	s obj.MsgName=modelName
	s obj.MsgCode=modelCode
	s obj.MsgSort=modelSort
	s obj.MsgCanFlag=modelcanFlag
	d obj.%Save()
	d obj.%Close()

	q ""
}

/// Creator: 		lms
/// CreatDate: 		2019-07-25
/// Description: 	删除模板配置	
/// Input			"模板ID"
/// Return：		""
/// Method			w ##class(CT.NUR.MNIS.Message).Delete("1")
ClassMethod Delete(idStr As %String) As %String
{
	s len=$l(idStr,"^")
	f i=1:1:len  d
	.s modelId=$p(idStr,"^",i)
	.s obj=##class(CT.NUR.MNIS.Message).%OpenId(modelId)
	.d obj.%DeleteId(modelId)
	q ""
}

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MsgName</Value>
</Value>
<Value name="3">
<Value>MsgCode</Value>
</Value>
<Value name="4">
<Value>MsgSort</Value>
</Value>
<Value name="5">
<Value>MsgCanFlag</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.MNIS.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<IdLocation>^CT.NUR.MNIS.MessageD</IdLocation>
<IndexLocation>^CT.NUR.MNIS.MessageI</IndexLocation>
<StreamLocation>^CT.NUR.MNIS.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
