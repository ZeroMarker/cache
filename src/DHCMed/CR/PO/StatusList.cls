/// 名称: DHCMed.CR.PO.StatusList
/// 描述: 实例数据状态列表
/// 编写者：wuqk
/// 编写日期: 2012-11-22
Class DHCMed.CR.PO.StatusList Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock ]
{

Relationship ParRef As DHCMed.CR.PO.Data [ Cardinality = parent, Inverse = StatusList ];

/// 修改日期
Property sDate As %Date;

/// 修改时间
Property sTime As %Time;

/// 修改用户
Property sUserID As %Integer;

/// 状态代码
Property sStatusCode As %String;

/// Creator：     maxp
/// CreatDate：   2013-05-20
/// Description:  判断表单实例数据状态列表中的状态是否操作过
/// Table：       DHCMed.CR.PO.StatusList
/// Input:		  DataId:表单实例数据id, sStatusCode:状态代码
/// Output: 
/// w ##class(DHCMed.CR.PO.StatusList).CheckStatus(11,"01")
ClassMethod CheckStatus(DataId As %String, sStatusCode As %String) As %Boolean
{
	set flag="false"
	set StatusListId=""
	//Modified By LiYang 2013-10-20 修改处理报表状态的逻辑
	//99-----删除状态，不允许再进行任何操作
	for {
		set StatusListId=$o(^DHCMed.CR.PO.DataD(+DataId,"StatusList",StatusListId))
		set objStatusList=##class(DHCMed.CR.PO.StatusList).%OpenId(DataId_"||"_StatusListId)
		quit:'$IsObject(objStatusList)
		do objStatusList.%Close()
		set StatusCode=objStatusList.sStatusCode
		set:StatusCode="99" flag="true"
	}	
	Quit:flag="true" flag
	
	//00----草稿状态，只允许以前是“草稿”状态，否则不再可以为“草稿”
	if (sStatusCode="00") {
		set otherStatus=0
		for {
			set StatusListId=$o(^DHCMed.CR.PO.DataD(+DataId,"StatusList",StatusListId))
			set objStatusList=##class(DHCMed.CR.PO.StatusList).%OpenId(DataId_"||"_StatusListId)
			quit:'$IsObject(objStatusList)
			do objStatusList.%Close()
			set:objStatusList.sStatusCode'="00" otherStatus=1
		}
		Set ret="false"
		Set:otherStatus=1 ret="true"
		Quit ret
	}
	
	//01----上报状态，只允许上一个状态是“上报”或者“草稿”
	if (sStatusCode="01") {
		Set ret="false"
		set StatusListId=$o(^DHCMed.CR.PO.DataD(+DataId,"StatusList",""),-1)
		Quit:StatusListId="" ret
		set objStatusList=##class(DHCMed.CR.PO.StatusList).%OpenId(DataId_"||"_StatusListId)
		quit:'$IsObject(objStatusList)		
		do objStatusList.%Close()
		Set:((objStatusList.sStatusCode'="00")&&(objStatusList.sStatusCode'="01")) ret="true"
		Quit ret
	}
	
	//02----审核状态，只允许上一个状态是“上报”
	if (sStatusCode="02") {
		Set ret="false"
		set StatusListId=$o(^DHCMed.CR.PO.DataD(+DataId,"StatusList",""),-1)
		Quit:StatusListId="" ret
		set objStatusList=##class(DHCMed.CR.PO.StatusList).%OpenId(DataId_"||"_StatusListId)
		quit:'$IsObject(objStatusList)		
		do objStatusList.%Close()
		Set:(objStatusList.sStatusCode'="01") ret="true"
		Quit ret
	}	
	
	//03----删除状态，只允许上一个状态是“上报”或“草稿”
	if (sStatusCode="99") {
		Set ret="false"
		s:DataId="" ret="true" //add by mxp 2013-12-10 新建表单时删除不能执行
		set StatusListId=$o(^DHCMed.CR.PO.DataD(+DataId,"StatusList",""),-1)
		Quit:StatusListId="" ret
		set objStatusList=##class(DHCMed.CR.PO.StatusList).%OpenId(DataId_"||"_StatusListId)
		quit:'$IsObject(objStatusList)		
		do objStatusList.%Close()
		Set:((objStatusList.sStatusCode'="00")&&(objStatusList.sStatusCode'="01")) ret="true"
		Quit ret
	}		
	/*
	for {
		set StatusListId=$o(^DHCMed.CR.PO.DataD(+DataId,"StatusList",StatusListId))
		set objStatusList=##class(DHCMed.CR.PO.StatusList).%OpenId(DataId_"||"_StatusListId)
		quit:'$IsObject(objStatusList)
		set StatusCode=objStatusList.sStatusCode
		;b
		continue:(sStatusCode'=StatusCode)
		set flag="true"
		;if (sStatusCode=StatusCode) d
		;.set flag="true"
	}
	*/
	quit flag
}

Storage Default
{
<Data name="StatusListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>sDate</Value>
</Value>
<Value name="3">
<Value>sTime</Value>
</Value>
<Value name="4">
<Value>sUserID</Value>
</Value>
<Value name="5">
<Value>sStatusCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("StatusList")</DataLocation>
<DefaultData>StatusListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("StatusList")</IdLocation>
<IndexLocation>^DHCMed.CR.PO.StatusListI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.StatusListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
