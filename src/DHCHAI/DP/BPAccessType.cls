/// 名称: DHCHAI.DP.BPAccessType
/// 描述: 血管通路类型
/// 编写者: zhoubo
/// 编写日期: 2022-10-13
Class DHCHAI.DP.BPAccessType Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 血管通路类型ID
Property BAccessID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 血透登记ID
Property BABPRegID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 血管通路类型 BPAccessType
Property BAccessType As DHCHAI.BT.Dictionary;

/// 通路建立部位
Property BATypeBody As %String(MAXLEN = 100, TRUNCATE = 1);

/// 建立状态 暂停、使用
Property BAStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 通路建立日期
Property BAccessDate As %Date;

/// 启用日期
Property BAStartDate As %Date;

/// 停止日期
Property BAEndDate As %Date;

/// 建立入员（ID|Code|Desc）
Property BADoUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property BAIsActive As %Boolean;

/// 更新日期
Property BAUpdateDate As %Date;

/// 更新时间
Property BAUpdateTime As %Time;

/// 通路日期时间索引
Index IndexAccessDate On BAccessDate As Exact;

/// 血透登记ID 索引
Index IndexBABPRegID On BABPRegID As Exact;

/// 血透登记ID 索引
Index IndexBARegAccessID On (BABPRegID, BAccessID) [ Unique ];

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  根据Id取血管通路类型
/// Table：       DHCHAI.DP.BPAccessType
/// Input：       aId : DHCHAI.DP.BPAccessType
/// Return：      返回obj
/// w ##class(DHCHAI.DP.BPAccessType).GetObjById("11")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.BPAccessType
{
	New (aId)
	Quit:'##class(DHCHAI.DP.BPAccessType).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.BPAccessType).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-13
/// Description:  更新血管通路类型
/// Table：       DHCHAI.DP.BPAccessType
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.BPAccessType).Update("")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	 = $p(InStr,aSeparete,1)
	Set BAccessID	 = $p(InStr,aSeparete,2)
	Set BABPRegID    = $p(InStr,aSeparete,3)
	Set BAccessType	 = $p(InStr,aSeparete,4)
	Set BATypeBody	 = $p(InStr,aSeparete,5)
	Set BAStatus	 = $p(InStr,aSeparete,6)
	Set BAccessDate	 = $p(InStr,aSeparete,7)
	Set BAStartDate	 = $p(InStr,aSeparete,8)
	Set BAEndDate	 = $p(InStr,aSeparete,9)
	Set BADoUser	 = $p(InStr,aSeparete,10)
	Set BAIsActive   = +$p(InStr,aSeparete,11)
	Set BAUpdateDate = $p(InStr,aSeparete,12)
	Set BAUpdateTime = $p(InStr,aSeparete,13)
	Set:BADoUser'["|" BADoUser="|"_BADoUser_"|"_BADoUser
	Set:BAccessDate["-" BAccessDate = $zdh(BAccessDate,3)
	Set:BAStartDate["-" BAStartDate = $zdh(BAStartDate,3)
	Set:BAEndDate["-" BAEndDate = $zdh(BAEndDate,3)
	
	Quit:(BAccessID="")||(BABPRegID="") return
	Set objBP = ##class(DHCHAI.DP.BPRegister).GetObjById(BABPRegID)
	Quit:'$IsObject(objBP) return
	Set objAccess = ##class(DHCHAI.BT.Dictionary).GetObjById(BAccessType)
	Quit:'$IsObject(objAccess) return
	//血透登记录+血管通路索引码 唯一性
	Set tID=$o(^MA.HAI.DP.BPAccessTypeI("IndexBARegAccessID"," "_BABPRegID," "_BAccessID,0))
	If (ID'=""){
		Quit:(tID'="")&(ID'=tID) -100
	}Else{
		Set ID = tID
	}
	if ID="" {
		Set obj=##class(DHCHAI.DP.BPAccessType).%New()
	}else{
		Set obj=##class(DHCHAI.DP.BPAccessType).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BAccessID	 = BAccessID	
	Set obj.BABPRegID    = BABPRegID   
	Set obj.BAccessType	 = objAccess	
	Set obj.BATypeBody	 = BATypeBody	
	Set obj.BAStatus	 = BAStatus	
	Set obj.BAccessDate	 = BAccessDate	
	Set obj.BAStartDate	 = BAStartDate	
	Set obj.BAEndDate	 = BAEndDate	
	Set obj.BADoUser	 = BADoUser	
	Set obj.BAIsActive   = BAIsActive
	Set obj.BAUpdateDate = +$h
	Set obj.BAUpdateTime = $p($h,",",2)
	
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
/// Description:  删除血管通路类型
/// Table：       DHCHAI.DP.BPAccessType
/// Input：       aId : DHCHAI.DP.BPAccessType.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.DP.BPAccessType).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.BPAccessType).%DeleteId(aId)
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
<Data name="BPAccessTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BAccessID</Value>
</Value>
<Value name="3">
<Value>BABPRegID</Value>
</Value>
<Value name="4">
<Value>BAccessType</Value>
</Value>
<Value name="5">
<Value>BATypeBody</Value>
</Value>
<Value name="6">
<Value>BAStatus</Value>
</Value>
<Value name="7">
<Value>BAccessDate</Value>
</Value>
<Value name="8">
<Value>BAStartDate</Value>
</Value>
<Value name="9">
<Value>BAEndDate</Value>
</Value>
<Value name="10">
<Value>BADoUser</Value>
</Value>
<Value name="11">
<Value>BAIsActive</Value>
</Value>
<Value name="12">
<Value>BAUpdateDate</Value>
</Value>
<Value name="13">
<Value>BAUpdateTime</Value>
</Value>
</Data>
<DataLocation>^MA.HAI.DP.BPAccessTypeD</DataLocation>
<DefaultData>BPAccessTypeDefaultData</DefaultData>
<IdLocation>^MA.HAI.DP.BPAccessTypeD</IdLocation>
<IndexLocation>^MA.HAI.DP.BPAccessTypeI</IndexLocation>
<StreamLocation>^MA.HAI.DP.BPAccessTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
