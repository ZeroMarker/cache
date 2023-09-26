/// 名称 : DHCMed.DC.LIS.LabReport
/// 说明 : 检验报告（检验系统审核报告的同时，可以推送消息到此表）
Class DHCMed.DC.LIS.LabReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验医嘱索引序号
Property TestSetNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告索引序号
Property OrderNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告ID
Property ReportID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验医嘱
Property TestSetDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 标本
Property SpecimenDR As DHCMed.DC.LIS.BTSpecimen;

/// 申请科室
Property LocationDR As DHCMed.DC.BTLoc;

/// 采集日期
Property CollectDate As %Date;

/// 采集时间
Property CollectTime As %Time;

/// 采集者
Property CollectUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 接收日期
Property ReceiveDate As %Date;

/// 接收时间
Property ReceiveTime As %Time;

/// 接收者
Property ReceiveUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 审核日期
Property AuthDate As %Date;

/// 审核时间
Property AuthTime As %Time;

/// 审核者
Property AuthUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效（1有效、0无效）
Property IsActive As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 审核日期时间索引
Index IndexAuthDT On (AuthDate, AuthTime);

/// 接收日期时间索引
Index IndexReceiveDT On (ReceiveDate, ReceiveTime);

/// 采集日期时间索引
Index IndexCollectDT On (CollectDate, CollectTime);

/// TestSetNo、OrderNo索引
Index IndexTestSetNo On (TestSetNo As Exact, OrderNo As Exact);

/// ReportID索引
Index IndexReportID On ReportID As Exact;

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  根据ID取检验报告记录
/// Table：       DHCMed.DC.LIS.LabReport
/// Input：       ID:    DHCMed.DC.LIS.LabReport.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.LabReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.LabReport
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.LabReport).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.LabReport).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  更新检验报告记录
/// Table：       DHCMed.DC.LIS.LabReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.LabReport).Update("25^1^3^2^^^^^64027^13:10:52^检验01^2016-04-19^13:11:56^检验01^1")
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set TestSetNo   = $p(InStr,separete,1)
	set OrderNo     = $p(InStr,separete,2)
	set ReportID    = $p(InStr,separete,3)
	set TestSetDesc = $p(InStr,separete,4)
	set SpecimenDR  = $p(InStr,separete,5)
	set LocationDR  = $p(InStr,separete,6)
	set CollectDate = $p(InStr,separete,7)
	set:CollectDate["-" CollectDate=$zdh(CollectDate,3)
	set CollectTime = $p(InStr,separete,8)
	set:CollectTime[":" CollectTime=$zth(CollectTime,1)
	set CollectUser = $p(InStr,separete,9)
	set ReceiveDate = $p(InStr,separete,10)
	set:ReceiveDate["-" ReceiveDate=$zdh(ReceiveDate,3)
	set ReceiveTime = $p(InStr,separete,11)
	set:ReceiveTime[":" ReceiveTime=$zth(ReceiveTime,1)
	set ReceiveUser = $p(InStr,separete,12)
	set AuthDate = $p(InStr,separete,13)
	set:AuthDate["-" AuthDate=$zdh(AuthDate,3)
	set AuthTime = $p(InStr,separete,14)
	set:AuthTime[":" AuthTime=$zth(AuthTime,1)
	set AuthUser = $p(InStr,separete,15)
	set IsActive    = +$p(InStr,separete,16)
	quit:(TestSetNo="")||(OrderNo="")||(ReportID="") return
	
	set objSpecimen=##Class(DHCMed.DC.LIS.BTSpecimen).GetObjById(SpecimenDR)
	//quit:'$IsObject(objSpecimen) return
	
	set objLocation=##Class(DHCMed.DC.BTLoc).GetObjById(LocationDR)
	//quit:'$IsObject(objLocation) return
	
	//报告记录唯一性
	set ID=$o(^DHCMed.DC.LIS.LabReportI("IndexTestSetNo",TestSetNo,OrderNo,0))
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.LabReport).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.LabReport).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.TestSetNo   = TestSetNo
	set obj.OrderNo     = OrderNo
	set obj.ReportID    = ReportID
	set obj.TestSetDesc = TestSetDesc
	set obj.SpecimenDR  = objSpecimen
	set obj.LocationDR  = objLocation
	set obj.CollectDate = CollectDate
	set obj.CollectTime = CollectTime
	set obj.CollectUser = CollectUser
	set obj.ReceiveDate = ReceiveDate
	set obj.ReceiveTime = ReceiveTime
	set obj.ReceiveUser = ReceiveUser
	Set obj.AuthDate    = AuthDate
	Set obj.AuthTime    = AuthTime
	Set obj.AuthUser    = AuthUser
	set obj.UpdateDate  = +$h
	set obj.UpdateTime  = $p($h,",",2)
	Set obj.IsActive    = IsActive
	
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
/// CreatDate：   2016-03-04
/// Description:  删除检验报告记录
/// Table：       DHCMed.DC.LIS.LabReport
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.LabReport).%DeleteId(+Id)
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
<Value>ReportID</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>""</Value>
</Value>
<Value name="5">
<Value>SpecimenDR</Value>
</Value>
<Value name="6">
<Value>LocationDR</Value>
</Value>
<Value name="7">
<Value>CollectDate</Value>
</Value>
<Value name="8">
<Value>CollectTime</Value>
</Value>
<Value name="9">
<Value>CollectUser</Value>
</Value>
<Value name="10">
<Value>ReceiveDate</Value>
</Value>
<Value name="11">
<Value>ReceiveTime</Value>
</Value>
<Value name="12">
<Value>ReceiveUser</Value>
</Value>
<Value name="13">
<Value>AuthDate</Value>
</Value>
<Value name="14">
<Value>AuthTime</Value>
</Value>
<Value name="15">
<Value>AuthUser</Value>
</Value>
<Value name="16">
<Value>IsActive</Value>
</Value>
<Value name="17">
<Value>UpdateDate</Value>
</Value>
<Value name="18">
<Value>UpdateTime</Value>
</Value>
<Value name="19">
<Value>TestSetDesc</Value>
</Value>
<Value name="20">
<Value>TestSetNo</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.LabReportD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.LabReportD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.LabReportI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.LabReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
