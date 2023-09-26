/// 临床路径步骤,临床路径阶段的子表
Class User.DHCMRCClinPathWaysEpStep Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWS_RowId, SqlTableName = DHC_MRC_ClinPathWaysEpStep ]
{

Relationship CPWSParRef As User.DHCMRCClinPathWaysEp [ Cardinality = parent, Inverse = ChildStep, SqlFieldName = CPWS_ParRef ];

Relationship ChildItem As User.DHCMRCClinPathWaysEpStepItem [ Cardinality = children, Inverse = CPWSIParRef ];

/// 序号,代表步骤执行的顺序
Property CPWSDayNumber As %Float [ SqlColumnNumber = 3, SqlFieldName = CPWS_DayNumber ];

/// 天数每个步骤的所需要的天数
Property CPWSDay As %String [ SqlColumnNumber = 4, SqlFieldName = CPWS_Day ];

/// 备注
Property CPWSDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CPWS_Notes ];

/// 时间单位
Property CPWSUnit As %String(DISPLAYLIST = ",Day,Hour,Minute", MINLEN = 4, TRUNCATE = 1, VALUELIST = ",D,H,M") [ SqlColumnNumber = 6, SqlFieldName = CPWS_Unit ];

/// 步骤类型 add by wuqk 2011-07-25 reference User.DHCMRCBaseDictionary,SubCate Code='STEPTYPE'
Property CPWSStepTypeCode As %String [ SqlColumnNumber = 7, SqlFieldName = CPWS_StepTypeCode ];

/// Creator：     zhufei
/// CreatDate：   2015-06-16
/// Description:  根据ID取表单步骤
/// Table：       User.DHCMRCClinPathWaysEpStep
/// Input：       Id : User.DHCMRCClinPathWaysEpStep.ID
/// Return：      返回Object
/// w ##class(User.DHCMRCClinPathWaysEpStep).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRCClinPathWaysEpStep
{
	new (aId)
	quit:'##class(User.DHCMRCClinPathWaysEpStep).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRCClinPathWaysEpStep).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-06-16
/// Description:  删除表单步骤
/// Table：       User.DHCMRCClinPathWaysEpStep
/// Input：       Id : User.DHCMRCClinPathWaysEpStep.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	//new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(User.DHCMRCClinPathWaysEpStep).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWSDay</Value>
</Value>
<Value name="3">
<Value>CPWSDayNumber</Value>
</Value>
<Value name="4">
<Value>CPWSDesc</Value>
</Value>
<Value name="5">
<Value>CPWSUnit</Value>
</Value>
<Value name="6">
<Value>CPWSStepTypeCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("STEP")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("STEP")</IdLocation>
<IndexLocation>^DHCMRCi("CPW",0,"STEP")</IndexLocation>
<SqlChildSub>CPWS_Childsub</SqlChildSub>
<SqlRowIdName>CPWS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPathWaysEpStepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
