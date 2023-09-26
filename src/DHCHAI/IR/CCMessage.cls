/// 名称: DHCHAI.IR.CCMessage
/// 描述: 消息记录
/// 编写者：chenjb
/// 编写日期: 2017-01-17
Class DHCHAI.IR.CCMessage Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property CSEpisodeDr As DHCHAI.DP.PAAdm;

/// 消息类型（1院感、2临床、3多耐）
Property CSMsgType As %Integer;

/// 消息日期
Property CSMsgDate As %Date;

/// 消息时间
Property CSMsgTime As %Time;

/// 消息人
Property CSMsgUserDr As DHCHAI.BT.SysUser;

/// 消息科室
Property CSMsgLocDr As DHCHAI.BT.Location;

/// 消息内容
Property CSMessage As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否阅读
Property CSIsRead As %Boolean;

/// 阅读日期
Property CSReadDate As %Date;

/// 阅读时间
Property CSReadTime As %Time;

/// 阅读人
Property CSReadUserDr As DHCHAI.BT.SysUser;

/// HIS消息外部消息ID 为同步状态使用 ^websys.DHCMessageDetails
Property CSMsgDtlID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 根据患者+发消息时间索引
Index IndexCSMsgDtlID On CSMsgDtlID As Exact;

/// 根据患者+发消息时间索引
Index IndexPaadmDate On (CSEpisodeDr As Exact, CSMsgDate, CSMsgTime);

/// 根据消息类型+发消息时间索引
Index IndexTypeDateTime On (CSMsgType, CSMsgDate, CSMsgTime);

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  根据ID取消息记录信息
/// Table：       DHCHAI.IR.CCMessage
/// Input：       Id : DHCHAI.IR.CCMessage.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CCMessage).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CCMessage
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CCMessage).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CCMessage).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  更新消息记录信息
/// Table：       DHCHAI.IR.CCMessage
/// Input：       各属性列表 ^分隔
/// 1 ID 2 CSEpisodeDr 3 CSMsgType 4 CSMsgDate 5 CSMsgTime 6 CSMsgUserDr 7 CSMsgLocDr 8 CSMessage 
/// 9 CSIsRead 10 CSReadDate 11 CSReadTime 12 CSReadUserDr
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCMessage).Update("^1^2^^^9^117^检出多重耐药^0^^^9","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID          = $p(aInputStr,aSeparete,1)
	Set CSEpisodeDr   = $p(aInputStr,aSeparete,2)
	Set CSMsgType    = $p(aInputStr,aSeparete,3)
	Set CSMsgDate   = $p(aInputStr,aSeparete,4)
	Set CSMsgTime  = $p(aInputStr,aSeparete,5)
	Set CSMsgUserDr  = $p(aInputStr,aSeparete,6)
	Set CSMsgLocDr  = $p(aInputStr,aSeparete,7)
	Set CSMessage  = $p(aInputStr,aSeparete,8)
	Set CSIsRead  = $p(aInputStr,aSeparete,9)
	Set CSReadDate  = $p(aInputStr,aSeparete,10)
	Set CSReadTime  = $p(aInputStr,aSeparete,11)
	Set CSReadUserDr  = $p(aInputStr,aSeparete,12)
	Set CSMsgDtlID = $p(aInputStr,aSeparete,13)
	
	Quit:(CSEpisodeDr="")||(CSMsgType="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(CSEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set:CSMsgDate'="" CSMsgDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(CSMsgDate)
	Set:CSMsgTime[":" CSMsgTime = $zth(CSMsgTime,1)
	If ID="" {
		Set obj=##class(DHCHAI.IR.CCMessage).%New()
		Set:CSMsgDate="" CSMsgDate=+$h
		Set:CSMsgTime="" CSMsgTime=$p($h,",",2)
		Set obj.CSMsgType   = CSMsgType
		Set obj.CSEpisodeDr  = objEpisode
		Set obj.CSMsgDate  = CSMsgDate
		Set obj.CSMsgTime = CSMsgTime
		Set obj.CSMsgUserDr = ##class(DHCHAI.BT.SysUser).GetObjById(CSMsgUserDr)
		Set obj.CSMsgLocDr = ##class(DHCHAI.BT.Location).GetObjById(CSMsgLocDr)
		Set obj.CSMessage = CSMessage
		//根据系统配置获取是否往HIS下同时发送消息
		Set MsgSendFlag=##class(DHCHAI.BT.Config).GetValByCode("MsgSendFlag")	
		If (MsgSendFlag="1")&&(CSMsgType=1) {//只考虑院感科向临床发送消息，临床消息加入推送会出现临床能看到一条自己发送的消息待处理
			Set HisPaadm = $p(obj.CSEpisodeDr.PAEpisodeIDx,"||",2)
			Set otherInfoJson="{""linkParam"":""EpisodeDr="_CSEpisodeDr_"&Paadm="_HisPaadm_"&MsgType=2""}"   //处理消息对应的链接
			Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(CSMessage,"1011",$p(obj.CSMsgUserDr.BTXCode,"||",2),HisPaadm,"",otherInfoJson)			
		}
		Set obj.CSMsgDtlID = CSMsgDtlID  //HIS下消息明细ID
	}Else{
		Set obj=##class(DHCHAI.IR.CCMessage).%OpenId(ID)
	}
	
	Quit:'$IsObject(obj) return
	
	//Set:CSMsgDate["-" CSMsgDate=$zdh(CSMsgDate,3)
	//Set:CSMsgTime[":" CSMsgTime=$zth(CSMsgTime,1)
	
	Set obj.CSIsRead = CSIsRead
	if (CSIsRead) 
	{
		//是阅读则更新阅读信息
		Set obj.CSReadDate =+$h
		Set obj.CSReadTime =$p($h,",",2)
		Set obj.CSReadUserDr =##class(DHCHAI.BT.SysUser).GetObjById(CSReadUserDr)
	}	
		
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2016-12-16
/// Description:  删除消息记录信息
/// Table：       DHCHAI_IR.CCScreening
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CCMessage).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CCMessage).%DeleteId(aId)
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
<Data name="CCMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSEpisodeDr</Value>
</Value>
<Value name="3">
<Value>CSMsgType</Value>
</Value>
<Value name="4">
<Value>CSMsgDate</Value>
</Value>
<Value name="5">
<Value>CSMsgTime</Value>
</Value>
<Value name="6">
<Value>CSMsgUserDr</Value>
</Value>
<Value name="7">
<Value>CSMessage</Value>
</Value>
<Value name="8">
<Value>CSIsRead</Value>
</Value>
<Value name="9">
<Value>CSReadDate</Value>
</Value>
<Value name="10">
<Value>CSReadTime</Value>
</Value>
<Value name="11">
<Value>CSReadUserDr</Value>
</Value>
<Value name="12">
<Value>CSMsgLocDr</Value>
</Value>
<Value name="13">
<Value>CSMsgDtlID</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.CCMessageD</DataLocation>
<DefaultData>CCMessageDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.CCMessageD</IdLocation>
<IndexLocation>^DHCHAI.IR.CCMessageI</IndexLocation>
<StreamLocation>^DHCHAI.IR.CCMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
