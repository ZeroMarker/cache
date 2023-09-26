/// 名称: DHCMA.CPW.SD.QCMrList
/// 描述: 质控病种病历列表
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCMrList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 单病种执行
Relationship ChildExec As DHCMA.CPW.SD.QCItemExec [ Cardinality = children, Inverse = Parref ];

/// 单病种表单状态记录
Relationship ChildState As DHCMA.CPW.SD.QCMrListState [ Cardinality = children, Inverse = Parref ];

/// 就诊ID（指向DHCMA.Util.EP.Episode.OID）
Property QCEpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 付费病种
Property PCEntityDr As %String;

/// 入单病种指针
Property QCEntityDr As DHCMA.CPW.SD.QCEntity [ Required ];

/// 入单病种医生ID（指向DHCMA.Util.EP.CareProv.OID）
Property QCInDocID As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1);

/// 入单病种科室ID（指向DHCMA.Util.EP.Location.OID）
Property QCInLocID As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1);

/// 入单病种病区ID（指向DHCMA.Util.EP.Location.OID）
Property QCInWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入单病种日期
Property QCInDate As %Date;

/// 入单病种时间
Property QCInTime As %Time;

/// 出单病种医生ID（指向DHCMA.Util.EP.CareProv.OID）
Property QCOutDocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出单病种日期
Property QCOutDate As %Date;

/// 出单病种时间
Property QCOutTime As %Time;

/// 出单病种人ID（指向DHCMA.Util.EP.SSUser.OID）
Property QCOutUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出单病种科室ID（指向DHCMA.Util.EP.Location.OID）
Property QCOutLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 出单病种病区ID（指向DHCMA.Util.EP.Location.OID）
Property QCOutWardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 单病种出入组状态(I确认,O排除,Save保存/Submit 提交/Check 已审核/tUp 测试上报/Up 正式上报/Back 退回)
Property QCState As %String;

/// 关联路径记录ID
Property RelativeCP As %String;

/// 已填数量
Property ECount As %Integer;

/// 自动采集数量
Property ACount As %Integer;

/// 未填数量
Property NCount As %Integer;

Index IndexLocID On QCInLocID;

Index IndexDocID On QCInDocID;

Index IndexOutDate On QCOutDate;

Index IndexInDate On QCInDate;

Index IndexEpisodeID On QCEpisodeID As Exact;

Index IndexAdmEntity On (QCEpisodeID, QCEntityDr);

Index IndexCPID On RelativeCP;

/// w ##class(DHCMA.CPW.SD.QCMrList).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCMrList
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCMrList).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCMrList).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCMrList).Update("^177^^9^1^110^197")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ID              = $p(aInputStr,aSeparete,1)
	Set QCEpisodeID     = $p(aInputStr,aSeparete,2)
	Set PCEntityDr		= $p(aInputStr,aSeparete,3)
	Set QCEntityDr      = $p(aInputStr,aSeparete,4)
	Set QCInDocID       = $p(aInputStr,aSeparete,5)
	Set QCInLocID       = $p(aInputStr,aSeparete,6)
	Set QCInWardID      = $p(aInputStr,aSeparete,7)
	Set QCInDate		= $p(aInputStr,aSeparete,8)
	Set QCInTime		= $p(aInputStr,aSeparete,9)
 	Set QCOutDocID		= $p(aInputStr,aSeparete,10)
	Set QCOutDate		= $p(aInputStr,aSeparete,11)
	Set QCOutTime		= $p(aInputStr,aSeparete,12)
	Set QCOutUserID		= $p(aInputStr,aSeparete,13)
	Set QCOutLocID		= $p(aInputStr,aSeparete,14)
	Set QCOutWardID		= $p(aInputStr,aSeparete,15)
	Set QCState			= $p(aInputStr,aSeparete,16)
	Set RelativeCP		= $p(aInputStr,aSeparete,17)
	Set:QCInDate="" QCInDate=+$h,QCInTime=$P($H,",",2)
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCMrList).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCMrList).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.QCEpisodeID        	= QCEpisodeID
	Set obj.PCEntityDr			= ""
	Set obj.QCEntityDr        	= ##class(DHCMA.CPW.SD.QCEntity).GetObjById(QCEntityDr)
	Set obj.QCInDocID			= QCInDocID
	Set obj.QCInLocID    		= QCInLocID
	Set obj.QCInWardID     		= QCInWardID
	Set obj.QCInDate			= QCInDate
	Set obj.QCInTime  			= QCInTime	
	Set obj.QCOutDocID    		= QCOutDocID
	Set obj.QCOutDate     		= QCOutDate
	Set obj.QCOutTime			= QCOutTime
	Set obj.QCOutUserID  		= QCOutUserID
	Set obj.QCOutLocID			= QCOutLocID
	Set obj.QCOutWardID			= QCOutWardID
	Set obj.QCState				= QCState
	Set obj.RelativeCP			= RelativeCP
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

/// w ##class(DHCMA.CPW.SD.QCMrList).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCMrList).%DeleteId(aId)
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
<Data name="QCMrListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QCEpisodeID</Value>
</Value>
<Value name="3">
<Value>QCEntityDr</Value>
</Value>
<Value name="4">
<Value>QCInDocID</Value>
</Value>
<Value name="5">
<Value>QCInLocID</Value>
</Value>
<Value name="6">
<Value>QCInWardID</Value>
</Value>
<Value name="7">
<Value>QCInDate</Value>
</Value>
<Value name="8">
<Value>QCInTime</Value>
</Value>
<Value name="9">
<Value>QCOutDocID</Value>
</Value>
<Value name="10">
<Value>QCOutDate</Value>
</Value>
<Value name="11">
<Value>QCOutTime</Value>
</Value>
<Value name="12">
<Value>QCOutUserID</Value>
</Value>
<Value name="13">
<Value>QCOutLocID</Value>
</Value>
<Value name="14">
<Value>QCOutWardID</Value>
</Value>
<Value name="15">
<Value>PCEntityDr</Value>
</Value>
<Value name="16">
<Value>QCState</Value>
</Value>
<Value name="17">
<Value>RelativeCP</Value>
</Value>
<Value name="18">
<Value>ECount</Value>
</Value>
<Value name="19">
<Value>ACount</Value>
</Value>
<Value name="20">
<Value>NCount</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCMrListD</DataLocation>
<DefaultData>QCMrListDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCMrListD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCMrListI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCMrListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
