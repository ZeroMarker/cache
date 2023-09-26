/// 名称: DHCMA.IMP.IP.LangHospReg
/// 描述: 长期住院病例上报登记
/// 编写者：dengshaopeng
/// 编写日期: 2020-11-12
Class DHCMA.IMP.IP.LangHospReg Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 登记主表ID
Property RegisterDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入院科室
Property InHospLoc As %String;

/// 上报科室
Property RegLoc As %String;

/// 入院诊断
Property AdmDiagnosis As %String;

/// 诊断经过
Property DiagnosisProcess As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 目前诊断
Property NowDiagnosis As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 长期住院原因分析
Property LongHospReason As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 拟采取的进一步诊疗计划
Property DiagnosisPlan As %String(MAXLEN = 2000, TRUNCATE = 1);

Index IdxofRegisterDr On RegisterDr [ Unique ];

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  更新长期住院病例上报登记表
/// Table：       DHCMA.IMP.IP.LangHospReg
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.LangHospReg).Update("^9^^^9^古典风格的^42^80^发生的发生的^水费水电费^Submit^")  
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID 		    		= $p(aInputStr,aSeparete,1)
	Set RegisterDr			= $p(aInputStr,aSeparete,2)
	Set InHospLoc     		= $p(aInputStr,aSeparete,3)
	Set RegLoc   		    = $p(aInputStr,aSeparete,4)
	Set AdmDiagnosis   		= $p(aInputStr,aSeparete,5)
	Set DiagnosisProcess  	= $p(aInputStr,aSeparete,6)
	Set NowDiagnosis	    = $p(aInputStr,aSeparete,7)
	Set LongHospReason 		= $p(aInputStr,aSeparete,8)
	Set DiagnosisPlan		= $p(aInputStr,aSeparete,9)
	
	//根据ID判断是添加还是修改
	If ID="" { 
		Set obj=##class(DHCMA.IMP.IP.LangHospReg).%New()
	}Else{
		Set obj=##class(DHCMA.IMP.IP.LangHospReg).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	
	//写入数据
	Set obj.RegisterDr   	   = RegisterDr
	Set obj.InHospLoc	   	   = InHospLoc      
	Set obj.RegLoc        	   = RegLoc
	Set obj.AdmDiagnosis 	   = AdmDiagnosis	
	Set obj.DiagnosisProcess   = DiagnosisProcess
	Set obj.NowDiagnosis       = NowDiagnosis
	Set obj.LongHospReason     = LongHospReason
	Set obj.DiagnosisPlan  	   = DiagnosisPlan
	
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
/// Description:  根据ID获取长期住院病例上报登记表信息
/// Table：       DHCMA.IMP.IP.LangHospReg
/// Input：       aId :  DHCMA.IMP.IP.LangHospReg.ID
/// Return：      返回obj
/// w ##class( DHCMA.IMP.IP.LangHospReg).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.IP.LangHospReg
{
	New (aId)
	Quit:'##class(DHCMA.IMP.IP.LangHospReg).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.IP.LangHospReg).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     dsp
/// CreatDate：   2020-11-12
/// Description:  删除长期住院病例上报登记表信息
/// Table：       DHCMA.IMP.IP.URTOperReg
/// Input：       aId :  DHCMA.IMP.IP.URTOperReg.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.IP.LangHospReg).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.IP.LangHospReg).%DeleteId(aId)
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
/// Description:  查询是否存在登记主表的长期住院病例上报登记信息
/// Table：       DHCMA.IMP.IP.LangHospReg
/// Input：       aRegisterDr
/// Return：      成功：返回obj，失败：返回""
/// w ##class(DHCMA.IMP.IP.LangHospReg).GetObjByRegisterDr(1)
ClassMethod GetObjByRegisterDr(aRegisterDr As %String) As DHCMA.IMP.IP.LangHospReg
{
	New (aRegisterDr)
	Set objLangHospReg=""
	
	Set xLangHospRegID = ""
	For{
		Set xLangHospRegID = $O(^MA.IMP.IPLangHospRegI("IdxofRegisterDr"," "_+aRegisterDr,xLangHospRegID))
		Quit:xLangHospRegID=""
		
		Set objLangHospReg = ..GetObjById(xLangHospRegID)
	}
	Quit objLangHospReg
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
<Value>InHospLoc</Value>
</Value>
<Value name="4">
<Value>RegLoc</Value>
</Value>
<Value name="5">
<Value>AdmDiagnosis</Value>
</Value>
<Value name="6">
<Value>DiagnosisProcess</Value>
</Value>
<Value name="7">
<Value>NowDiagnosis</Value>
</Value>
<Value name="8">
<Value>LongHospReason</Value>
</Value>
<Value name="9">
<Value>DiagnosisPlan</Value>
</Value>
</Data>
<DataLocation>^MA.IMP.IPLangHospRegD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^MA.IMP.IPLangHospRegD</IdLocation>
<IndexLocation>^MA.IMP.IPLangHospRegI</IndexLocation>
<StreamLocation>^MA.IMP.IPLangHospRegS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
