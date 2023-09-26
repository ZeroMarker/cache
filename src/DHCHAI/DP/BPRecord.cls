/// 名称: DHCHAI.DP.BPRecord
/// 描述: 血液透析记录
/// 编写者: zhoubo
/// 编写日期: 2022-10-13
Class DHCHAI.DP.BPRecord Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 透析记录ID
Property HDialysisID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 血透登记ID
Property HDBPRegID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 床位组
Property HDBedGroup As %String(MAXLEN = 100, TRUNCATE = 1);

/// 床位号
Property HDBedNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 透析状态 是否完成
Property HDStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 透析日期
Property HDDoDate As %Date;

/// 治疗（净化）方式
Property HDDoMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 计划透析频率（每周）
Property HDFreqWeek As %String(MAXLEN = 100, TRUNCATE = 1);

/// 透析时长（每次）
Property HDFreqTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 血管通路 BPAccessType
Property HDAccessType As DHCHAI.BT.Dictionary [ Required ];

/// 通路建立部位
Property HDAccessPos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property HDIsActive As %Boolean;

/// 更新日期
Property HDUpdateDate As %Date;

/// 更新时间
Property HDUpdateTime As %Time;

/// 透析日期时间索引
Index IndexDoDate On HDDoDate As Exact;

/// 血透登记ID 索引
Index IndexHDBPRegID On HDBPRegID As Exact;

/// 血透登记ID+透析记录ID 索引
Index IndexHDRegHDialID On (HDBPRegID, HDialysisID) [ Unique ];

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  根据Id取血液透析记录
/// Table：       DHCHAI.DP.BPRecord
/// Input：       aId : DHCHAI.DP.BPRecord
/// Return：      返回obj
/// w ##class(DHCHAI.DP.BPRecord).GetObjById("11")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.BPRecord
{
	New (aId)
	Quit:'##class(DHCHAI.DP.BPRecord).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.BPRecord).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  更新血液透析记录
/// Table：       DHCHAI.DP.BPRecord
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.BPRecord).Update("^12^1^22^22^wanc^2022-11-01^2^2^2^2^2^1^^")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	 = $p(InStr,aSeparete,1)
	Set HDialysisID	 = $p(InStr,aSeparete,2)
	Set HDBPRegID    = $p(InStr,aSeparete,3)
	Set HDBedGroup	 = $p(InStr,aSeparete,4)
	Set HDBedNo		 = $p(InStr,aSeparete,5)
	Set HDStatus	 = $p(InStr,aSeparete,6)
	Set HDDoDate	 = $p(InStr,aSeparete,7)
	Set HDDoMethod	 = $p(InStr,aSeparete,8)
	Set HDFreqWeek	 = $p(InStr,aSeparete,9)
	Set HDFreqTime	 = $p(InStr,aSeparete,10)
	Set HDAccessType = $p(InStr,aSeparete,11)
	Set HDAccessPos	 = $p(InStr,aSeparete,12)
	Set HDIsActive	 = +$p(InStr,aSeparete,13)
	Set HDUpdateDate = $p(InStr,aSeparete,14)
	Set HDUpdateTime = $p(InStr,aSeparete,15)

	Set:HDDoDate["-" HDDoDate = $zdh(HDDoDate,3)
	
	Quit:(HDialysisID="")||(HDBPRegID="") return
	Set objBP = ##class(DHCHAI.DP.BPRegister).GetObjById(HDBPRegID)
	Quit:'$IsObject(objBP) return
	Set objAccess = ##class(DHCHAI.BT.Dictionary).GetObjById(HDAccessType)
	Quit:'$IsObject(objAccess) return
	//血透登记录索引码 唯一性
	Set tID=$o(^MA.HAI.DP.BPRecordI("IndexHDRegHDialID"," "_HDBPRegID," "_HDialysisID,0))
	If (ID'=""){
		Quit:(tID'="")&(ID'=tID) -100
	}Else{
		Set ID = tID
	}
	if ID="" {
		Set obj=##class(DHCHAI.DP.BPRecord).%New()
	}else{
		Set obj=##class(DHCHAI.DP.BPRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HDialysisID	 = HDialysisID	
	Set obj.HDBPRegID    = HDBPRegID   
	Set obj.HDBedGroup	 = HDBedGroup	
	Set obj.HDBedNo		 = HDBedNo		
	Set obj.HDStatus	 = HDStatus	
	Set obj.HDDoDate	 = HDDoDate	
	Set obj.HDDoMethod	 = HDDoMethod	
	Set obj.HDFreqWeek	 = HDFreqWeek	
	Set obj.HDFreqTime	 = HDFreqTime	
	Set obj.HDAccessType = objAccess
	Set obj.HDAccessPos	 = HDAccessPos	
	Set obj.HDIsActive	 = HDIsActive
	Set obj.HDUpdateDate = +$h
	Set obj.HDUpdateTime = $p($h,",",2)
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  删除血液透析记录信息
/// Table：       DHCHAI.DP.BPRecord
/// Input：       aId : DHCHAI.DP.BPRecord.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.BPRecord).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.BPRecord).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="BPRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HDialysisID</Value>
</Value>
<Value name="3">
<Value>HDBPRegID</Value>
</Value>
<Value name="4">
<Value>HDBedGroup</Value>
</Value>
<Value name="5">
<Value>HDBedNo</Value>
</Value>
<Value name="6">
<Value>HDStatus</Value>
</Value>
<Value name="7">
<Value>HDDoDate</Value>
</Value>
<Value name="8">
<Value>HDDoMethod</Value>
</Value>
<Value name="9">
<Value>HDFreqWeek</Value>
</Value>
<Value name="10">
<Value>HDFreqTime</Value>
</Value>
<Value name="11">
<Value>HDAccessType</Value>
</Value>
<Value name="12">
<Value>HDAccessPos</Value>
</Value>
<Value name="13">
<Value>HDIsActive</Value>
</Value>
<Value name="14">
<Value>HDUpdateDate</Value>
</Value>
<Value name="15">
<Value>HDUpdateTime</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.BPRecordD</DataLocation>
<DefaultData>BPRecordDefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.BPRecordD</IdLocation>
<IndexLocation>^MA.HAI.DP.BPRecordI</IndexLocation>
<StreamLocation>^MA.HAI.DP.BPRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
