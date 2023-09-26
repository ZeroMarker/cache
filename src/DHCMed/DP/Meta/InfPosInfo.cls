/// 名称: DHCMed.DP.Meta.InfPosInfo
/// 描述: 数据池之感染部位
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.InfPosInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 主记录ID
Property IPIMainID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IPI_MainID ];

/// 与主记录DataSubCat一致
Property IPIDataSubCat As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IPI_DataSubCat ];

/// 与主记录ObjectID一致
Property IPIObjectID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = IPI_ObjectID ];

/// 科室代码
Property IPIDeptCode As %String [ SqlColumnNumber = 5, SqlFieldName = IPI_DeptCode ];

/// 病区代码
Property IPIWardCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = IPI_WardCode ];

/// 感染类型代码（医院感染/社区感染）
Property IPIInfType As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = IPI_InfType ];

/// 感染日期
Property IPIInfDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPI_InfDate ];

/// 感染部位
Property IPIInfPos As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = IPI_InfPos ];

/// 感染诊断
Property IPIInfDiagnos As %String [ SqlColumnNumber = 10, SqlFieldName = IPI_InfDiagnos ];

/// 易感因素
Property IPIInfFactors As %String [ SqlColumnNumber = 11, SqlFieldName = IPI_InfFactors ];

/// 侵害性操作
Property IPIInvasiveOper As %String [ SqlColumnNumber = 12, SqlFieldName = IPI_InvasiveOper ];

/// 与感染相关侵害性操作
Property IPIInfInvaOper As %Boolean [ SqlColumnNumber = 13, SqlFieldName = IPI_InfInvaOper ];

/// 呼吸机相关肺炎感染
Property IPIVAPInf As %Boolean [ SqlColumnNumber = 14, SqlFieldName = IPI_VAPInf ];

/// 导尿管相关泌尿道感染
Property IPIUCInf As %Boolean [ SqlColumnNumber = 15, SqlFieldName = IPI_UCInf ];

/// 中心静脉置管相关血流感染
Property IPIPICCInf As %Boolean [ SqlColumnNumber = 16, SqlFieldName = IPI_PICCInf ];

/// 手术切口感染
Property IPIOPERInf As %Boolean [ SqlColumnNumber = 17, SqlFieldName = IPI_OPERInf ];

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池中感染部位
/// Table：       DHCMed.DP.Meta.InfPosInfo
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.InfPosInfo).Update("^27891^张三^12^32^1^2^3^4^5^6^7^8^1^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.InfPosInfo).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.InfPosInfo).%OpenId(ID)
		}
	set obj.IPIMainID=$p(InStr,separete,2)
	set obj.IPIDataSubCat=$p(InStr,separete,3)
	set obj.IPIObjectID=$p(InStr,separete,4)
	set obj.IPIDeptCode=$p(InStr,separete,5)
	set obj.IPIWardCode=$p(InStr,separete,6)
	set obj.IPIInfType=$p(InStr,separete,7)
	set obj.IPIInfDate=$p(InStr,separete,8)
	set obj.IPIInfPos=$p(InStr,separete,9)
	set obj.IPIInfDiagnos=$p(InStr,separete,10)
	set obj.IPIInfFactors=$p(InStr,separete,11)
	set obj.IPIInvasiveOper=$p(InStr,separete,12)
	set obj.IPIInfInvaOper=$p(InStr,separete,13)
	set obj.IPIVAPInf=$p(InStr,separete,14)
	set obj.IPIUCInf=$p(InStr,separete,15)
	set obj.IPIPICCInf=$p(InStr,separete,16)
	set obj.IPIOPERInf=$p(InStr,separete,17)

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
/// Description:  删除数据池中感染部位
/// Table：       DHCMed.DP.Meta.InfPosInfo
/// Input：       DHCMed.DP.Meta.InfPosInfo.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.InfPosInfo).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.InfPosInfo.ID
/// Return：      DHCMed.DP.Meta.InfPosInfo
/// w ##class(DHCMed.DP.Meta.InfPosInfo).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.InfPosInfo
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.InfPosInfo).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.InfPosInfo).%OpenId(+id)
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
<Value>IPIMainID</Value>
</Value>
<Value name="3">
<Value>IPIDataSubCat</Value>
</Value>
<Value name="4">
<Value>IPIObjectID</Value>
</Value>
<Value name="5">
<Value>IPIDeptCode</Value>
</Value>
<Value name="6">
<Value>IPIWardCode</Value>
</Value>
<Value name="7">
<Value>IPIInfType</Value>
</Value>
<Value name="8">
<Value>IPIInfDate</Value>
</Value>
<Value name="9">
<Value>IPIInfPos</Value>
</Value>
<Value name="10">
<Value>IPIInfDiagnos</Value>
</Value>
<Value name="11">
<Value>IPIInfFactors</Value>
</Value>
<Value name="12">
<Value>IPIInvasiveOper</Value>
</Value>
<Value name="13">
<Value>IPIInfInvaOper</Value>
</Value>
<Value name="14">
<Value>IPIVAPInf</Value>
</Value>
<Value name="15">
<Value>IPIUCInf</Value>
</Value>
<Value name="16">
<Value>IPIPICCInf</Value>
</Value>
<Value name="17">
<Value>IPIOPERInf</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.InfPosInfoD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.InfPosInfoD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.InfPosInfoI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.InfPosInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
