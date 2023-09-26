Class DHCMed.NINF.Srv.NurseManage Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 录入日期
Property EntryDate As %Date;

/// 录入时间
Property EntryTime As %Time;

/// 项目名称
Property ItemName As %String(TRUNCATE = 1);

/// 项目值
Property ItemValue As %String(TRUNCATE = 1);

/// 修改日期
Property UpdateDate As %Date;

/// 修改时间
Property UpdateTime As %Time;

Index IndexAdmDateItem On (EpisodeID As Exact, ItemName As SqlString, EntryDate As Exact, EntryTime As Exact);

Index IndexEpisodeID On EpisodeID;

/// w ##Class(DHCMed.NINF.Srv.NurseManage).Update("^18214743^2013-01-23 14:00:00^体温^36.5^2013-02-18 13:12:37")
ClassMethod Update(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=-1
	Quit:aInputStr="" return
	;Set ^DHCMed.NurseManage($h)=aInputStr
	Set EpisodeID=$p(aInputStr,"^",2)               //就诊号
	Set tmpDateTime=$p(aInputStr,"^",3)             //录入时间
	Set EntryDate=$p(tmpDateTime," ",1)
	Set EntryDate=$zdh(EntryDate,3)
	Set EntryTime=$p(tmpDateTime," ",2)
	Set EntryTime=$zth(EntryTime,1)
	Set ItemName=$p(aInputStr,"^",4)                //项目名称
	Set ItemValue=$p(aInputStr,"^",5)               //项目值
	Set tmpDateTime=$p(aInputStr,"^",6)             //修改时间
	Set UpdateDate=$p(tmpDateTime," ",1)
	Set UpdateDate=$zdh(UpdateDate,3)
	Set UpdateTime=$p(tmpDateTime," ",2)
	Set UpdateTime=$zth(UpdateTime,1)
	Quit:(EpisodeID="")||(ItemName="") return
	Quit:(EntryDate="")||(EntryTime="") return
	
	Set ID=$o(^DHCMed.NINFSi("NurseManage",0,"IndexAdmDateItem",EpisodeID," "_$zcvt(ItemName,"U"),EntryDate,EntryTime,0))
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Srv.NurseManage).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Srv.NurseManage).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID=EpisodeID
	Set obj.EntryDate=EntryDate
	Set obj.EntryTime=EntryTime
	Set obj.ItemName=ItemName
	Set obj.ItemValue=ItemValue
	Set obj.UpdateDate=UpdateDate
	Set obj.UpdateTime=UpdateTime
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		//Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Set:return>0 return=0
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EntryDate</Value>
</Value>
<Value name="3">
<Value>EntryTime</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>ItemName</Value>
</Value>
<Value name="6">
<Value>ItemValue</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFS("NurseManage")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFS("NurseManage")</IdLocation>
<IndexLocation>^DHCMed.NINFSi("NurseManage",0)</IndexLocation>
<StreamLocation>^DHCMed.N.NurseManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
