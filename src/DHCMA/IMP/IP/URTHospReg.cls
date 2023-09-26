/// 名称: DHCMA.IMP.IP.URTHospReg
/// 描述: 非计划重返住院报告登记表
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.IP.URTHospReg Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 登记主表ID
Property RegisterDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院诊断
Property AdmDiagnosis As %String;

/// 再次入院日期
Property ReInHospDate As %Date;

/// 再住院方式
Property ReadmissionWay As %String;

/// 首次住院情况
Property FirstHospSituation As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 首次出院后情况
Property FirstDischSituation As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 再次住院原因分析
Property ReadmissionReason As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 拟采取预防手段
Property PreventionMeasures As %String(MAXLEN = 2000, TRUNCATE = 1);

Index IdxofRegisterDr On RegisterDr [ Unique ];

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  更新非计划重返住院报告登记表
/// Table：       DHCMA.IMP.IP.URTHospReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.URTHospReg).Update("^9^副伤寒^2020-10-26^87^水电费多少^萨芬撒地方^撒旦法撒旦法^^")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID             		= $p(aInputStr,aSeparete,1)
	Set RegisterDr     		= $p(aInputStr,aSeparete,2)
	Set AdmDiagnosis   		= $p(aInputStr,aSeparete,3)
	Set ReInHospDate   		= $p(aInputStr,aSeparete,4)
	Set ReadmissionWay  	= $p(aInputStr,aSeparete,5)
	Set FirstHospSituation  = $p(aInputStr,aSeparete,6)
	Set FirstDischSituation = $p(aInputStr,aSeparete,7)
	Set ReadmissionReason   = $p(aInputStr,aSeparete,8)
	Set PreventionMeasures  = $P(aInputStr,aSeparete,9)
	
	Set:ReInHospDate'="" ReInHospDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(ReInHospDate)
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.URTHospReg).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.URTHospReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.RegisterDr   	    = RegisterDr      
	Set obj.AdmDiagnosis        = AdmDiagnosis
	Set obj.ReInHospDate 	    = ReInHospDate
	Set obj.ReadmissionWay	    = ReadmissionWay
	Set obj.FirstHospSituation  = FirstHospSituation
	Set obj.FirstDischSituation = FirstDischSituation
	Set obj.ReadmissionReason   = ReadmissionReason
	Set obj.PreventionMeasures  = PreventionMeasures
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

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  根据ID获取非计划重返住院报告登记表信息
/// Table：       DHCMA.IMP.IP.URTHospReg
/// Input：       aId :  DHCMA.IMP.IP.URTHospReg.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.URTHospReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.URTHospReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.URTHospReg).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.URTHospReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  删除非计划重返住院报告登记表
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       aId :  DHCMA.IMP.IP.URTOperReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.URTHospReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.URTHospReg).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  查询是否存在登记主表的非计划重返手术信息
/// Table：       DHCMA.IMP.IP.URTHospReg
/// Input：       aRegisterDr
/// Return：      成功：返回obj，失败：返回""
/// w ##class(DHCMA.IMP.IP.URTHospReg).GetObjByRegisterDr(1)
ClassMethod GetObjByRegisterDr(aRegisterDr As %String) As DHCMA.IMP.IP.URTHospReg
{
	New (aRegisterDr)
	Set objURTHospReg=""
	
	Set xURTHospRegID = ""
	For{
		Set xURTHospRegID = $O(^MA.IMP.IPURTHospRegI("IdxofRegisterDr"," "_+aRegisterDr,xURTHospRegID))
		Quit:xURTHospRegID=""
		
		Set objURTHospReg = ..GetObjById(xURTHospRegID)
	}
	Quit objURTHospReg
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegisterDr</Value>
</Value>
<Value name="3">
<Value>AdmDiagnosis</Value>
</Value>
<Value name="4">
<Value>ReInHospDate</Value>
</Value>
<Value name="5">
<Value>ReadmissionWay</Value>
</Value>
<Value name="6">
<Value>FirstHospSituation</Value>
</Value>
<Value name="7">
<Value>FirstDischSituation</Value>
</Value>
<Value name="8">
<Value>ReadmissionReason</Value>
</Value>
<Value name="9">
<Value>PreventionMeasures</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPURTHospRegD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPURTHospRegD</IdLocation>
<IndexLocation>^MA.IMP.IPURTHospRegI</IndexLocation>
<StreamLocation>^MA.IMP.IPURTHospRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
