/// 名称 : DHCMed.DC.NIS.Observations
/// 说明 : 护理管理（体温、大便次数）
Class DHCMed.DC.NIS.Observations Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 记录ID
Property ResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊号/住院号
Property EpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 护理项目
Property ObItemDR As DHCMed.DC.NIS.BTObItem;

/// 项目值
Property ItemValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// 录入日期
Property EntryDate As %Date;

/// 录入时间
Property EntryTime As %Time;

/// 录入人
Property EntryUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %Boolean;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

Index IndexResultID On ResultID;

Index IndexEpisode On EpisodeID;

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据ID取护理记录
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       ID:    DHCMed.DC.NIS.Observations.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.NIS.Observations).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.NIS.Observations
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.NIS.Observations).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.NIS.Observations).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  更新护理记录
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.NIS.Observations).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set ResultID   = $p(InStr,separete,1)
	set EpisodeID  = $p(InStr,separete,2)
	set ObItemDR  = $p(InStr,separete,3)
	set ItemValue  = $p(InStr,separete,4)
	set EntryDate  = $p(InStr,separete,5)
	set:EntryDate["-" EntryDate=$zdh(EntryDate,3)
	set EntryTime  = $p(InStr,separete,6)
	set:EntryTime[":" EntryTime=$zth(EntryTime,1)
	set EntryUser  = $p(InStr,separete,7)
	set IsActive   = +$p(InStr,separete,8)
	set UpdateDate = +$h
	set UpdateTime = $p($h,",",2)
	quit:(ResultID="")||(EpisodeID="")||(ObItemDR="") return
	
	set objObsItem=##Class(DHCMed.DC.NIS.BTObItem).GetObjById(ObItemDR)
	quit:'$IsObject(objObsItem) return
	
	//记录唯一性
	set ID=$o(^DHCMed.DC.NIS.ObservationsI("IndexResultID"," "_$zcvt(ResultID,"U"),0))
	
	if ID="" {
		set obj=##class(DHCMed.DC.NIS.Observations).%New()
	}else{
		set obj=##class(DHCMed.DC.NIS.Observations).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.ResultID   = ResultID
	set obj.EpisodeID  = EpisodeID
	set obj.ObItemDR   = objObsItem
	set obj.ItemValue  = ItemValue
	set obj.EntryDate  = EntryDate
	set obj.EntryTime  = EntryTime
	set obj.EntryUser  = EntryUser
	set obj.IsActive   = IsActive
	set obj.UpdateDate = +$h
	set obj.UpdateTime = $p($h,",",2)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  删除护理记录
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.NIS.Observations).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResultID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ObItemDR</Value>
</Value>
<Value name="5">
<Value>ItemValue</Value>
</Value>
<Value name="6">
<Value>EntryDate</Value>
</Value>
<Value name="7">
<Value>EntryTime</Value>
</Value>
<Value name="8">
<Value>EntryUser</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.NIS.ObservationsD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.NIS.ObservationsD</IdLocation>
<IndexLocation>^DHCMed.DC.NIS.ObservationsI</IndexLocation>
<StreamLocation>^DHCMed.DC.NIS.ObservationsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
