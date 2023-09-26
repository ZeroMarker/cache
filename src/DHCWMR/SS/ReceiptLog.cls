/// 接诊（取消接诊）日志
Class DHCWMR.SS.ReceiptLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 接诊类别   接诊入口:0、接诊出口:1、取消接诊入口:2、取消接诊出口:3
Property OperType As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 病案类型
Property MrType As DHCWMR.SS.MrType;

/// 病案号码
Property MrNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案卷DHCWMR.SS.Volume.ID
Property Volume As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊ID
Property Paadm As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人ID add by zf 20150513
Property PatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室(指向CT_Loc)
Property RecLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用户(指向SS_User)
Property RecUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期
Property RecDate As %Date;

/// 时间
Property RecTime As %Time;

Index IndexPaadm On Paadm;

/// Creator：     liyi
/// CreatDate：   2014-09-15
/// Description:  根据ID取接诊日志
/// Table：       DHCWMR.SS.ReceiptLog
/// Input：       Id : DHCWMR.SS.ReceiptLog.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.ReceiptLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.ReceiptLog
{
	new (aId)
	quit:'##class(DHCWMR.SS.ReceiptLog).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.ReceiptLog).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2014-09-12
/// Description:  插入接诊日志
/// Table：       DHCWMR.SS.ReceiptLog
/// Input：       InputStr ：ID^OperType^MrTypeID^MrNo^VolumeID^Paadm^RecLoc^RecUser^RecDate^RecTime
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.SS.ReceiptLog).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set OperType=$p(aInputStr,aSeparate,2)
	Set MrTypeID=$p(aInputStr,aSeparate,3)
	Set MrNo=$p(aInputStr,aSeparate,4)
	Set VolumeID=$p(aInputStr,aSeparate,5)
	Set Paadm=$p(aInputStr,aSeparate,6)
	Set RecLoc=$p(aInputStr,aSeparate,7)
	Set RecUser=$p(aInputStr,aSeparate,8)
	Set RecDate=$p(aInputStr,aSeparate,9)
	Set RecTime=$p(aInputStr,aSeparate,10)
	Set PatientID=$p(aInputStr,aSeparate,11)  //add by zf 20150513 增加病人ID
	Set:Paadm'="" PatientID=$p($g(^PAADM(Paadm)),"^",1)
	Quit:(OperType="") return
	Quit:(PatientID="")&&(Paadm="") return
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.ReceiptLog).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.ReceiptLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.OperType  = OperType
	Set obj.MrType    = objMrType
	Set obj.MrNo      = MrNo
	Set obj.Volume    = VolumeID
	Set obj.Paadm     = Paadm
	Set obj.PatientID = PatientID
	Set obj.RecLoc    = RecLoc
	Set obj.RecUser   = RecUser
	Set obj.RecDate   = RecDate
	Set obj.RecTime   = RecTime
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

Storage Default
{
<Data name="ReceiptLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MrType</Value>
</Value>
<Value name="3">
<Value>MrNo</Value>
</Value>
<Value name="4">
<Value>Volume</Value>
</Value>
<Value name="5">
<Value>Papmi</Value>
</Value>
<Value name="6">
<Value>Paadm</Value>
</Value>
<Value name="7">
<Value>RecLoc</Value>
</Value>
<Value name="8">
<Value>RecUser</Value>
</Value>
<Value name="9">
<Value>RecDate</Value>
</Value>
<Value name="10">
<Value>RecTime</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>ResumeText</Value>
</Value>
<Value name="13">
<Value>OperType</Value>
</Value>
<Value name="14">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.ReceiptLogD</DataLocation>
<DefaultData>ReceiptLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.ReceiptLogD</IdLocation>
<IndexLocation>^DHCWMR.SS.ReceiptLogI</IndexLocation>
<StreamLocation>^DHCWMR.SS.ReceiptLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
