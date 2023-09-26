/// 名称 : DHCMed.DC.LIS.LabResultSen
/// 说明 : 检验报告结果 药敏结果
Class DHCMed.DC.LIS.LabResultSen Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.DC.LIS.LabResult [ Cardinality = parent, Inverse = ChildSen ];

/// 抗生素
Property AntibioticsDR As DHCMed.DC.LIS.BTAntibiotics;

/// 药敏结果（S敏感、R耐药、I中介、SDD）
Property SensitivityDR As DHCMed.DC.LIS.BTSensitivity;

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  根据ID取药敏结果
/// Table：       DHCMed.DC.LIS.LabResultSen
/// Input：       ID:    DHCMed.DC.LIS.LabResultSen.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.LabResultSen).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.LabResultSen
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.LabResultSen).%ExistsId(id) return
	set obj=##Class(DHCMed.DC.LIS.LabResultSen).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  更新药敏结果
/// Table：       DHCMed.DC.LIS.LabResultSen
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.LabResultSen).Update("100032||F053||1||F0540^^344^3","^")
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Parref         = $p(InStr,separete,1)
	set ChildSub       = $p(InStr,separete,2)
	set AntibioticsDR  = $p(InStr,separete,3)
	set SensitivityDR   = $p(InStr,separete,4)
	quit:(Parref="")||(AntibioticsDR="") return
	
	set objParref=##class(DHCMed.DC.LIS.LabResult).GetObjById(Parref)
	quit:'$IsObject(objParref) return
	
	set objAntibiotics=##Class(DHCMed.DC.LIS.BTAntibiotics).GetObjById(AntibioticsDR)
	quit:'$IsObject(objAntibiotics) return
	
	set objSensitivity=##Class(DHCMed.DC.LIS.BTSensitivity).GetObjById(SensitivityDR)
	//quit:'$IsObject(objSensitivity) return
	
	if ChildSub="" {
		set obj=##class(DHCMed.DC.LIS.LabResultSen).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.LabResultSen).%OpenId(Parref_"||"_ChildSub)
	}
	quit:'$IsObject(obj) return
	
	set obj.Parref        = objParref
	set obj.AntibioticsDR = objAntibiotics
	set obj.SensitivityDR = objSensitivity
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
/// Description:  删除药敏结果
/// Table：       DHCMed.DC.LIS.LabResultSen
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.LabResultSen).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2016-04-26
/// Description:  删除药敏结果
/// Table：       DHCMed.DC.LIS.LabResultSen
/// Input：       Parref
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod InitByRef(aParref As %String) As %String
{
	new (aParref)
	set ret=1
	set xSub=0
	for {
		set xSub=$o(^DHCMed.DC.LIS.LabResultD(aParref,"Sen",xSub))
		quit:xSub=""
		set flg=..DeleteById(aParref_"||"_xSub)
		set:flg<0 ret=-1
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
<Value>AntibioticsDR</Value>
</Value>
<Value name="3">
<Value>SensitivityDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Sen")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Sen")</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.LabResultI("Sen")</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.LabResultSenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
