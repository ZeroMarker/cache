/// 名称: DHCMed.DP.Meta.LabTestSetData
/// 描述: 检验结果
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.LabTestSetData Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// DHCMed.DP.Meta.LabTestSet Parent Reference
Relationship ParRef As DHCMed.DP.Meta.LabTestSet [ Cardinality = parent, Inverse = ChildData, Required ];

/// 检验项目代码
Property LTDTestCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LTD_TestCode ];

/// 检验项目名称
Property LTDTestDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LTD_TestDesc ];

/// 输出数据类型（V细菌、N数值、S标准意见、B2血型结果）
Property LTDDataFormat As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LTD_DataFormat ];

/// 检验结果 原始数据
Property LTDDataValue As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LTD_DataValue ];

/// 检验结果
Property LTDDataText As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LTD_DataText ];

/// 检验结果单位
Property LTDItemUnit As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LTD_ItemUnit ];

/// 异常标记
Property LTDAbnorFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = LTD_AbnorFlag ];

/// 参考范围
Property LTDItemRangs As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = LTD_ItemRangs ];

/// 英文
Property LTDSynonym As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = LTD_Synonym ];

/// 结果备注
Property LTDComments As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = LTD_Comments ];

/// 药敏试验(抗生素代码 $c(2) 抗生素名称 $c(2) 英文名称 $c(2) 药敏代码 $c(2) 药敏名称 $c(1) 抗生素代码 $c(2) ...)
Property LTDAntibiotics As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = LTD_Antibiotics ];

/// 耐药菌标记(0/1)
Property LTDIsRBugs As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = LTD_IsRBugs ];

/// ESBLs标记(0/1)
Property LTDIsESBLs As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = LTD_IsESBLs ];

/// 多重耐药菌分类
Property LTDMRBGroup As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = LTD_MRBGroup ];

/// 细菌代码
Property LTDPYCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = LTD_PYCode ];

/// 细菌名称
Property LTDPYDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = LTD_PYDesc ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新检验结果
/// Table：       DHCMed.DP.Meta.LabTestSetData
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.LabTestSetData).Update("3^^4^5^6^7^8^8^21^^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	q:$p(InStr,separete,1)="" -1
	set id=0
	set ChildID=$p(InStr,separete,2)
	if ChildID="" {
		set obj=##class(DHCMed.DP.Meta.LabTestSetData).%New()
	} else {
		set ParObjID=$p(InStr,separete,1)
		set ID=ParObjID_"||"_ChildID
		set obj=##class(DHCMed.DP.Meta.LabTestSetData).%OpenId(ID)
	}

	set ParObj=##class(DHCMed.DP.Meta.LabTestSet).GetObjById($p(InStr,separete,1))
	
	q:'$IsObject(ParObj)||'$IsObject(obj) -1
	set obj.ParRef=ParObj
	set obj.LTDTestCode=$p(InStr,separete,3)
	set obj.LTDTestDesc=$p(InStr,separete,4)
	set obj.LTDDataFormat=$p(InStr,separete,5)
	set obj.LTDDataValue=$p(InStr,separete,6)
	set obj.LTDDataText=$p(InStr,separete,7)
	set obj.LTDItemUnit=$p(InStr,separete,8)
	set obj.LTDAbnorFlag=$p(InStr,separete,9)
	set obj.LTDItemRangs=$p(InStr,separete,10)
	set obj.LTDSynonym=$p(InStr,separete,11)
	set obj.LTDComments=$p(InStr,separete,12)
	set obj.LTDAntibiotics=$p(InStr,separete,13)
	set obj.LTDIsRBugs=$p(InStr,separete,14)
	set obj.LTDIsESBLs=$p(InStr,separete,15)
	set obj.LTDMRBGroup=$p(InStr,separete,16)
	set obj.LTDPYCode=$p(InStr,separete,17)
	set obj.LTDPYDesc=$p(InStr,separete,18)
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  删除检验结果
/// Table：       DHCMed.DP.Meta.LabTestSetData
/// Input：       DHCMed.DP.Meta.LabTestSetData.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.LabTestSetData).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.LabTestSetData.ID
/// Return：      DHCMed.DP.Meta.LabTestSetData
/// w ##class(DHCMed.DP.Meta.LabTestSetData).GetObjById("3||1")
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.LabTestSetData
{
	new (id)
	set return=""
	quit:id="" return

	quit:'##class(DHCMed.DP.Meta.LabTestSetData).%ExistsId(id) return

	set obj=##Class(DHCMed.DP.Meta.LabTestSetData).%OpenId(id)
	set return=obj
	do obj.%Close()
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LTDTestCode</Value>
</Value>
<Value name="3">
<Value>LTDTestDesc</Value>
</Value>
<Value name="4">
<Value>LTDDataFormat</Value>
</Value>
<Value name="5">
<Value>LTDDataValue</Value>
</Value>
<Value name="6">
<Value>LTDDataText</Value>
</Value>
<Value name="7">
<Value>LTDItemUnit</Value>
</Value>
<Value name="8">
<Value>LTDAbnorFlag</Value>
</Value>
<Value name="9">
<Value>LTDItemRangs</Value>
</Value>
<Value name="10">
<Value>LTDSynonym</Value>
</Value>
<Value name="11">
<Value>LTDComments</Value>
</Value>
<Value name="12">
<Value>LTDAntibiotics</Value>
</Value>
<Value name="13">
<Value>LTDIsRBugs</Value>
</Value>
<Value name="14">
<Value>LTDIsESBLs</Value>
</Value>
<Value name="15">
<Value>LTDMRBGroup</Value>
</Value>
<Value name="16">
<Value>LTDPYCode</Value>
</Value>
<Value name="17">
<Value>LTDPYDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DATA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DATA")</IdLocation>
<IndexLocation>{%%PARENT}("DATA")(0)</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.LabTestSetDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
