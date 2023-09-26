/// VTE重点病例
/// 创建者：mazhaoyan
/// 创建时间：2019-07-23
Class DHCMA.VTE.VtePointCase Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

// 就诊ID

Property EpisodeDr As %String;

// 风险等级 1极低 2低危 3中危 4高危 5极高危

Property RiskLevel As %String;

// 出血等级 1低危 2 高危

Property BloodLevel As %String;

// 确诊类别 0未确诊 1肺栓塞 2下肢静脉血栓 3其他静脉血栓

Property VteType As %String;

// 是否临床待审核该患者  该患者有节点需求审核 0无需审核 1待审核

// 暂时定为只要临床审核过1次即记为0 临床一次未审核为1

Property ClcEval As %String;

// 是否是当日新增高危患者 0否 1是

Property NewRiskHigh As %String;

// 更新日期 yyyy-mm-dd

Property UpdateDate As %String;

Property ClcEvalDoc As %String;

/// Creator：     mazhaoyan
/// CreatDate：   2019-07-23
/// Description:  更新重点病例数据
/// Table：       DHCMA.VTE.VtePointCase
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// do ##Class(DHCMA.VTE.VtePointCase).Update("21895934^0^1^4")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete="^"
	}
	
	set ID=""
	Set EpisodeID=$p(InStr,separete,1) ;获取就诊ID

	Set ID=$o(^DHCMA.VTE.VtePointCaseI("IndexEpisodeDr"," "_EpisodeID,0))
	
	Set newRiskHigh="0" ;是否当日新增风险高危患者
	Set riskLevel=$p(InStr,separete,4)
	if ID="" {
		set obj=##class(DHCMA.VTE.VtePointCase).%New()
		if riskLevel>2{
			Set newRiskHigh="1"
		}
	} 
	else {
		set obj=##class(DHCMA.VTE.VtePointCase).%OpenId(ID)
		if obj.UpdateDate'=$p(InStr,separete,6){;如果更新日期不是当天
			if (obj.RiskLevel<3)&&(riskLevel>2){;原先是低危  现在变成中高危
				Set newRiskHigh="1"
			}else{
				Set newRiskHigh="0"
			}
		}else {;更新日期是当天
			if (riskLevel>2){;现在变成中高危
				Set newRiskHigh="1"
			}else {
				Set newRiskHigh="0"
			}
		}
	}
	set obj.EpisodeDr=$p(InStr,separete,1) ;就诊ID
	set obj.RiskLevel=$p(InStr,separete,4) ;风险等级
	set obj.BloodLevel=$p(InStr,separete,3) ;出血等级
	set obj.VteType=$p(InStr,separete,2) ;vte类型
	set obj.NewRiskHigh=newRiskHigh ;是否当日新增中高危
	set obj.UpdateDate=$p(InStr,separete,6)
	;if obj.ClcEval'="0"{//临床一次未审核过
		set obj.ClcEval=$p(InStr,separete,5) ;护士是否需临床审核
	;}
	set obj.ClcEvalDoc=$p(InStr,separete,7) ;医生是否需临床审核
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

Index IndexEpisodeDr On EpisodeDr;

Storage Default
{
<Data name="VtePointCaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeDr</Value>
</Value>
<Value name="3">
<Value>RiskLevel</Value>
</Value>
<Value name="4">
<Value>BloodLevel</Value>
</Value>
<Value name="5">
<Value>VteType</Value>
</Value>
<Value name="6">
<Value>ClcEval</Value>
</Value>
<Value name="7">
<Value>NewRiskHigh</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>ClcEvalDoc</Value>
</Value>
</Data>
<DataLocation>^DHCMA.VTE.VtePointCaseD</DataLocation>
<DefaultData>VtePointCaseDefaultData</DefaultData>
<IdLocation>^DHCMA.VTE.VtePointCaseD</IdLocation>
<IndexLocation>^DHCMA.VTE.VtePointCaseI</IndexLocation>
<StreamLocation>^DHCMA.VTE.VtePointCaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
