/// 名称: DHCMed.DP.Meta.LabRecData
/// 描述: 检验结果
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.LabRecData Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// DHCMed.DP.Meta.LabRec Parent Reference
Relationship ParRef As DHCMed.DP.Meta.LabRec [ Cardinality = parent, Inverse = ChildData, Required ];

Relationship ChildAnti As DHCMed.DP.Meta.LabRecDataAnti [ Cardinality = children, Inverse = ParRef ];

/// 检验项目代码
Property LDTestCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LD_TestCode ];

/// 检验项目名称
Property LDTestDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LD_TestDesc ];

/// 英文描述
Property LDSynonym As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LD_Synonym ];

/// 检验结果类型
Property LDDataType As %String [ SqlColumnNumber = 5, SqlFieldName = LD_DataType ];

/// 检验结果
Property LDTestData As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = LD_TestData ];

/// 检验结果备注
Property LDComments As %String [ SqlColumnNumber = 7, SqlFieldName = LD_Comments ];

/// 结果状态
Property LDRepStatus As %String [ SqlColumnNumber = 8, SqlFieldName = LD_RepStatus ];

/// 结果最低值
Property LDRangeLow As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = LD_RangeLow ];

/// 结果最高值
Property LDRangeHigh As %String [ SqlColumnNumber = 10, SqlFieldName = LD_RangeHigh ];

/// 是否ESBLs（超广谱β-内酰胺酶），多耐检测会用到
Property LDIsESBLs As %Boolean [ SqlColumnNumber = 11, SqlFieldName = LD_IsESBLs ];

/// 细菌名称
Property LDBugsName As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = LD_BugsName ];

/// 多重耐药菌分类
Property LDMRBCate As %String [ SqlColumnNumber = 13, SqlFieldName = LD_MRBCate ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新检验结果
/// Table：       DHCMed.DP.Meta.LabRecData
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.LabRecData).Update("3^^4^5^6^7^8^8^21^^^^^^^")
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
		set obj=##class(DHCMed.DP.Meta.LabRecData).%New()
		} 
	else {
		set ParObjID=$p(InStr,separete,1)
		set ID=ParObjID_"||"_ChildID
		set obj=##class(DHCMed.DP.Meta.LabRecData).%OpenId(ID)
		}

	set ParObj=##class(DHCMed.DP.Meta.LabRec).GetObjById($p(InStr,separete,1))
	
	q:'$IsObject(ParObj)||'$IsObject(obj) -1
	set obj.ParRef=ParObj
	set obj.LDTestCode=$p(InStr,separete,3)
	set obj.LDTestDesc=$p(InStr,separete,4)
	set obj.LDSynonym=$p(InStr,separete,5)
	set obj.LDDataType=$p(InStr,separete,6)
	set obj.LDTestData=$p(InStr,separete,7)
	set obj.LDComments=$p(InStr,separete,8)
	set obj.LDRepStatus=$p(InStr,separete,9)
	set obj.LDRangeLow=$p(InStr,separete,10)
	set obj.LDRangeHigh=$p(InStr,separete,11)
	set obj.LDIsESBLs=$p(InStr,separete,12)
	set obj.LDBugsName=$p(InStr,separete,13)
	set obj.LDMRBCate=$p(InStr,separete,14)

	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  删除检验结果
/// Table：       DHCMed.DP.Meta.LabRecData
/// Input：       DHCMed.DP.Meta.LabRecData.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.LabRecData).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.LabRecData.ID
/// Return：      DHCMed.DP.Meta.LabRecData
/// w ##class(DHCMed.DP.Meta.LabRecData).GetObjById("3||1")
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.LabRecData
{
	new (id)
	set return=""
	quit:id="" return

	quit:'##class(DHCMed.DP.Meta.LabRecData).%ExistsId(id) return

	set obj=##Class(DHCMed.DP.Meta.LabRecData).%OpenId(id)
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
<Value>LDTestCode</Value>
</Value>
<Value name="3">
<Value>LDTestDesc</Value>
</Value>
<Value name="4">
<Value>LDSynonym</Value>
</Value>
<Value name="5">
<Value>LDDataType</Value>
</Value>
<Value name="6">
<Value>LDTestData</Value>
</Value>
<Value name="7">
<Value>LDComments</Value>
</Value>
<Value name="8">
<Value>LDRepStatus</Value>
</Value>
<Value name="9">
<Value>LDRangeLow</Value>
</Value>
<Value name="10">
<Value>LDRangeHigh</Value>
</Value>
<Value name="11">
<Value>LDIsESBLs</Value>
</Value>
<Value name="12">
<Value>LDBugsName</Value>
</Value>
<Value name="13">
<Value>LDMRBCate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("DATA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("DATA")</IdLocation>
<IndexLocation>{%%PARENT}("DATA")(0)</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.LabRecDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
