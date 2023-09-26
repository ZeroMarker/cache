/// 名称: DHCMA.CPW.SD.PCEntity
/// 描述: 按病种付费病种
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.CPW.SD.PCEntity Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 病种框架
Relationship ChildItem As DHCMA.CPW.SD.PCEntityItem [ Cardinality = children, Inverse = Parref ];

/// 病种代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 病种名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 排序码
Property BTIndNo As %Integer;

/// 主要诊断
Property BTDiagnos As %String(MAXLEN = 200, TRUNCATE = 1);

/// 疾病代码（ICD10）
Property BTICD10 As %String(MAXLEN = 200, TRUNCATE = 1);

/// 主要操作/治疗方式
Property BTOperation As %String(MAXLEN = 200, TRUNCATE = 1);

/// 手术代码
Property BTICD9CM As %String(MAXLEN = 200, TRUNCATE = 1);

/// 参考费用
Property BTReferCost As %Integer;

/// 预警费用
Property BTWarningCost As %Integer;

/// 最短住院日
Property BTHospitalDays As %Integer;

/// 再入院间隔天数
Property BTIntervalDays As %Integer;

Index IdxofCode On BTCode;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取单病种字典信息
/// Table：       DHCMA.CPW.SD.PCEntity
/// Input：       aId : DHCMA.CPW.SD.PCEntity.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.SD.PCEntity).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.PCEntity
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.PCEntity).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.PCEntity).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据Code取单病种字典信息
/// Table：       DHCMA.CPW.SD.PCEntity
/// Input：       aCode : DHCMA.CPW.SD.PCEntity.BTCode
/// Return：      返回String
/// w ##class(DHCMA.CPW.SD.PCEntity).GetObjByCode("11")
ClassMethod GetObjByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCMA.CPW.SD.PCEntityI("IdxofCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新单病种字典信息
/// Table：       DHCMA.CPW.SD.PCEntity
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCEntity).Update("^zz^zz^0^^^^^^^^^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set ID                    = $p(aInputStr,aSeparete,1)
	Set Code                  = $p(aInputStr,aSeparete,2)
	Set Desc                  = $p(aInputStr,aSeparete,3)
	Set IsActive              = +$p(aInputStr,aSeparete,4)
	Set IndNo                 = $p(aInputStr,aSeparete,5)
	Set Diagnos               = $p(aInputStr,aSeparete,6)
	Set ICD10                 = $p(aInputStr,aSeparete,7)
	Set Operation             = $p(aInputStr,aSeparete,8)
	Set ICD9CM                = $p(aInputStr,aSeparete,9)
	Set ReferCost             = $p(aInputStr,aSeparete,10)
	Set WarningCost           = $p(aInputStr,aSeparete,11)
	Set HospitalDays          = $p(aInputStr,aSeparete,12)
	Set IntervalDays        = $p(aInputStr,aSeparete,13)

	Quit:(Code="")||(Desc="") return
	Set tID=$o(^DHCMA.CPW.SD.PCEntityI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&(ID'=tID) -2  
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.PCEntity).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.PCEntity).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode           = Code
	Set obj.BTDesc           = Desc
	Set obj.BTIsActive       = IsActive
	Set obj.BTIndNo          = IndNo
	Set obj.BTDiagnos        = Diagnos
	Set obj.BTICD10          = ICD10
	Set obj.BTOperation      = Operation
	Set obj.BTICD9CM         = ICD9CM
	Set obj.BTReferCost      = ReferCost
	Set obj.BTWarningCost    = WarningCost
	Set obj.BTHospitalDays   = HospitalDays
	Set obj.BTIntervalDays   = IntervalDays
	
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

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  删除单病种字典信息
/// Table：       DHCMA.CPW.SD.PCEntity
/// Input：       aId : DHCMA.CPW.SD.PCEntity.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.SD.PCEntity).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.PCEntity).%DeleteId(aId)
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
<Data name="PCEntityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTIndNo</Value>
</Value>
<Value name="6">
<Value>BTDiagnos</Value>
</Value>
<Value name="7">
<Value>BTICD10</Value>
</Value>
<Value name="8">
<Value>BTOperation</Value>
</Value>
<Value name="9">
<Value>BTICD9CM</Value>
</Value>
<Value name="10">
<Value>BTReferCost</Value>
</Value>
<Value name="11">
<Value>BTWarningCost</Value>
</Value>
<Value name="12">
<Value>BTHospitalDays</Value>
</Value>
<Value name="13">
<Value>BTIntervalDays</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.PCEntityD</DataLocation>
<DefaultData>PCEntityDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.PCEntityD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.PCEntityI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.PCEntityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
