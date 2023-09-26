/// 名称: DHCMA.IMP.IP.CriticalIllReg
/// 描述: 危重症病例报告登记
/// 编写者：dengshaopeng
/// 编写日期: 2020-11-12
Class DHCMA.IMP.IP.CriticalIllReg Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 登记主表ID
Property RegisterDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 简要病史
Property BriefCaseRecord As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 辅助检查
Property AssistInspect As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 临床诊断
Property ClinicalDiagnosis As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 目前存在的主要问题
Property MainProblem As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 疗效评价及预后
Property EfficacyAssessment As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 可能发生的并发症及处理措施
Property CompAndMeasures As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 护理要点
Property NursingPoint As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 三级医师
Property TertiaryDoc As %String;

/// 护士长
Property HeadNurse As %String;

Index IdxofRegisterDr On RegisterDr [ Unique ];

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  更新危重症病例报告登记表
/// Table：       DHCMA.IMP.IP.CriticalIllReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.CriticalIllReg).Update("^9^^^9^古典风格的^42^80^发生的发生的^水费水电费^Submit^")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID             		= $p(aInputStr,aSeparete,1)
	Set RegisterDr			= $p(aInputStr,aSeparete,2)
	Set BriefCaseRecord     = $p(aInputStr,aSeparete,3)
	Set AssistInspect	    = $p(aInputStr,aSeparete,4)
	Set ClinicalDiagnosis   = $p(aInputStr,aSeparete,5)
	Set MainProblem      	= $p(aInputStr,aSeparete,6)
	Set EfficacyAssessment  = $p(aInputStr,aSeparete,7)
	Set CompAndMeasures		= $p(aInputStr,aSeparete,8)
	Set NursingPoint		= $p(aInputStr,aSeparete,9)
	Set TertiaryDoc		    = $P(aInputStr,aSeparete,10)
	Set HeadNurse			= $P(aInputStr,aSeparete,11)
	
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.CriticalIllReg).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.CriticalIllReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.RegisterDr   	   = RegisterDr
	Set obj.BriefCaseRecord	   = BriefCaseRecord      
	Set obj.AssistInspect      = AssistInspect
	Set obj.ClinicalDiagnosis  = ClinicalDiagnosis	
	Set obj.MainProblem		   = MainProblem
	Set obj.EfficacyAssessment = EfficacyAssessment
	Set obj.CompAndMeasures    = CompAndMeasures
	Set obj.NursingPoint  	   = NursingPoint
	Set obj.TertiaryDoc		   = TertiaryDoc
	Set obj.HeadNurse		   = HeadNurse
	
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
/// Description:  根据ID获取危重症病例报告登记表信息
/// Table：       DHCMA.IMP.IP.CriticalIllReg
/// Input：       aId :  DHCMA.IMP.IP.CriticalIllReg.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.CriticalIllReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.CriticalIllReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.CriticalIllReg).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.CriticalIllReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  删除危重症病例报告登记表信息
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       aId :  DHCMA.IMP.IP.URTOperReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.CriticalIllReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.CriticalIllReg).%DeleteId(aId)
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
/// Description:  查询是否存在登记主表的危重症病例报告登记信息
/// Table：       DHCMA.IMP.IP.CriticalIllReg
/// Input：       aRegisterDr
/// Return：      成功：返回obj，失败：返回""
/// w ##class(DHCMA.IMP.IP.CriticalIllReg).GetObjByRegisterDr(1)
ClassMethod GetObjByRegisterDr(aRegisterDr As %String) As DHCMA.IMP.IP.CriticalIllReg
{
	New (aRegisterDr)
	Set objCriticalIllReg=""
	
	Set xCriticalIllRegID = ""
	For{
		Set xCriticalIllRegID = $O(^MA.IMP.IPCriticalIllRegI("IdxofRegisterDr"," "_+aRegisterDr,xCriticalIllRegID))
		Quit:xCriticalIllRegID=""
		
		Set objCriticalIllReg = ..GetObjById(xCriticalIllRegID)
	}
	Quit objCriticalIllReg
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
<Value>BriefCaseRecord</Value>
</Value>
<Value name="4">
<Value>AssistInspect</Value>
</Value>
<Value name="5">
<Value>ClinicalDiagnosis</Value>
</Value>
<Value name="6">
<Value>MainProblem</Value>
</Value>
<Value name="7">
<Value>EfficacyAssessment</Value>
</Value>
<Value name="8">
<Value>CompAndMeasures</Value>
</Value>
<Value name="9">
<Value>NursingPoint</Value>
</Value>
<Value name="10">
<Value>TertiaryDoc</Value>
</Value>
<Value name="11">
<Value>HeadNurse</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPCriticalIllRegD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPCriticalIllRegD</IdLocation>
<IndexLocation>^MA.IMP.IPCriticalIllRegI</IndexLocation>
<StreamLocation>^MA.IMP.IPCriticalIllRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
