/// 临床路径项目子类
Class User.DHCMRCStepItemSubCategory Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SISC_RowId, SqlTableName = DHC_MRC_StepItemSubCategory ]
{

Property SISCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SISC_Code ];

Property SISCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SISC_Desc ];

Property SISCDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = SISC_DateFrom ];

Property SISCDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = SISC_DateTo ];

Property SISCPower As %String(DISPLAYLIST = ",D,N,OE,NE", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",D,N,OE,NE") [ SqlColumnNumber = 7, SqlFieldName = SISC_Power ];

Relationship SISCParRef As User.DHCMRCStepItemCategory [ Cardinality = parent, Inverse = ChildSubCat, SqlFieldName = SISC_ParRef ];

/// Creator：     zhufei
/// CreatDate：   2015-06-16
/// Description:  根据ID取项目子类
/// Table：       User.DHCMRCStepItemSubCategory
/// Input：       Id : User.DHCMRCStepItemSubCategory.ID
/// Return：      返回Object
/// w ##class(User.DHCMRCStepItemSubCategory).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRCStepItemSubCategory
{
	new (aId)
	quit:'##class(User.DHCMRCStepItemSubCategory).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRCStepItemSubCategory).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-06-16
/// Description:  删除项目子类
/// Table：       User.DHCMRCStepItemSubCategory
/// Input：       Id : User.DHCMRCStepItemSubCategory.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	//new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(User.DHCMRCStepItemSubCategory).%DeleteId(aId)
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
<Value>SISCCode</Value>
</Value>
<Value name="3">
<Value>SISCDesc</Value>
</Value>
<Value name="4">
<Value>SISCDateFrom</Value>
</Value>
<Value name="5">
<Value>SISCDateTo</Value>
</Value>
<Value name="6">
<Value>SISCPower</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SUB")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SUB")</IdLocation>
<IndexLocation>{%%PARENT}("SUB")(0)</IndexLocation>
<SqlChildSub>SISC_Childsub</SqlChildSub>
<SqlRowIdName>SISC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCStepIt944S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
