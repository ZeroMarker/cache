/// 名称: DHCMed.DP.Meta.ActPatInfo
/// 描述: 数据池之病人基本信息
/// 编写者：zhugz
/// 编写日期: 2013-11-27
Class DHCMed.DP.Meta.ActPatInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊指针
Property APIEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = API_EpisodeID ];

/// 患者姓名
Property APIName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = API_Name ];

/// 登记号
Property APIRegNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = API_RegNo ];

/// 病案号
Property APIMrNo As %String [ SqlColumnNumber = 5, SqlFieldName = API_MrNo ];

/// 性别
Property APISex As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = API_Sex ];

/// 年龄
Property APIAge As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = API_Age ];

/// 身份证号
Property APIID As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = API_ID ];

/// 入院日期
Property APIAdmDate As %Date [ SqlColumnNumber = 9, SqlFieldName = API_AdmDate ];

/// 入院时间
Property APIAdmTime As %Time [ SqlColumnNumber = 10, SqlFieldName = API_AdmTime ];

/// 科室
Property APIAdmDept As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = API_AdmDept ];

/// 病区
Property APIAdmWard As %String [ SqlColumnNumber = 12, SqlFieldName = API_AdmWard ];

/// 床位
Property APIAdmBed As %String [ SqlColumnNumber = 13, SqlFieldName = API_AdmBed ];

/// 入院诊断
Property APIDiagnos As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = API_Diagnos ];

/// 出院日期
Property APIDischDate As %Date [ SqlColumnNumber = 15, SqlFieldName = API_DischDate ];

/// 出院时间
Property APIDischTime As %Time [ SqlColumnNumber = 16, SqlFieldName = API_DischTime ];

/// 出院情况
Property APIDischCond As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = API_DischCond ];

/// 是否死亡
Property APIIsDeath As %Boolean [ SqlColumnNumber = 18, SqlFieldName = API_IsDeath ];

/// 死亡日期
Property APIDeathDate As %Date [ SqlColumnNumber = 19, SqlFieldName = API_DeathDate ];

/// 死亡时间
Property APIDeathTime As %Time [ SqlColumnNumber = 20, SqlFieldName = API_DeathTime ];

/// 是否新生儿
Property APIIsNewBaby As %Boolean [ SqlColumnNumber = 21, SqlFieldName = API_IsNewBaby ];

/// EpisodeID的索引 2013-12-05
Index IndexEpisodeID On APIEpisodeID;

/// Creator：     zhugz
/// CreatDate：   2013-11-27
/// Description:  更新数据池中病人基本信息
/// Table：       DHCMed.DP.Meta.ActPatInfo
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.DP.Meta.ActPatInfo).Update("^27891^张三^12^32^1^2^3^4^5^6^7^8^9^0^1^^^^^^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{

	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
	}
	
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.DP.Meta.ActPatInfo).%New()
		} 
	else {
		set obj=##class(DHCMed.DP.Meta.ActPatInfo).%OpenId(ID)
		}
	set obj.APIEpisodeID=$p(InStr,separete,2)
	set obj.APIName=$p(InStr,separete,3)
	set obj.APIRegNo=$p(InStr,separete,4)
	set obj.APIMrNo=$p(InStr,separete,5)
	set obj.APISex=$p(InStr,separete,6)
	set obj.APIAge=$p(InStr,separete,7)
	set obj.APIID=$p(InStr,separete,8)
	set obj.APIAdmDate=$p(InStr,separete,9)
	set obj.APIAdmTime=$p(InStr,separete,10)
	set obj.APIAdmDept=$p(InStr,separete,11)
	set obj.APIAdmWard=$p(InStr,separete,12)
	set obj.APIAdmBed=$p(InStr,separete,13)
	set obj.APIDiagnos=$p(InStr,separete,14)
	set obj.APIDischDate=$p(InStr,separete,15)
	set obj.APIDischTime=$p(InStr,separete,16)
	set obj.APIDischCond=$p(InStr,separete,17)
	set obj.APIIsDeath=$p(InStr,separete,18)
	set obj.APIDeathDate=$p(InStr,separete,19)
	set obj.APIDeathTime=$p(InStr,separete,20)
	set obj.APIIsNewBaby=$p(InStr,separete,21)
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
/// Description:  删除数据池中病人基本信息
/// Table：       DHCMed.DP.Meta.ActPatInfo
/// Input：       DHCMed.DP.Meta.ActPatInfo.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.DP.Meta.ActPatInfo).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Input：       DHCMed.DP.Meta.ActPatInfo.ID
/// Return：      DHCMed.DP.Meta.ActPatInfo
/// w ##class(DHCMed.DP.Meta.ActPatInfo).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DP.Meta.ActPatInfo
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DP.Meta.ActPatInfo).%ExistsId(+id) return
	set obj=##Class(DHCMed.DP.Meta.ActPatInfo).%OpenId(+id)
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
<Value>APIEpisodeID</Value>
</Value>
<Value name="3">
<Value>APIName</Value>
</Value>
<Value name="4">
<Value>APIRegNo</Value>
</Value>
<Value name="5">
<Value>APIMrNo</Value>
</Value>
<Value name="6">
<Value>APISex</Value>
</Value>
<Value name="7">
<Value>APIAge</Value>
</Value>
<Value name="8">
<Value>APIID</Value>
</Value>
<Value name="9">
<Value>APIAdmDate</Value>
</Value>
<Value name="10">
<Value>APIAdmTime</Value>
</Value>
<Value name="11">
<Value>APIAdmDept</Value>
</Value>
<Value name="12">
<Value>APIAdmWard</Value>
</Value>
<Value name="13">
<Value>APIAdmBed</Value>
</Value>
<Value name="14">
<Value>APIDiagnos</Value>
</Value>
<Value name="15">
<Value>APIDischDate</Value>
</Value>
<Value name="16">
<Value>APIDischTime</Value>
</Value>
<Value name="17">
<Value>APIDischCond</Value>
</Value>
<Value name="18">
<Value>APIIsDeath</Value>
</Value>
<Value name="19">
<Value>APIDeathDate</Value>
</Value>
<Value name="20">
<Value>APIDeathTime</Value>
</Value>
<Value name="21">
<Value>APIIsNewBaby</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DP.Meta.ActPatInfoD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DP.Meta.ActPatInfoD</IdLocation>
<IndexLocation>^DHCMed.DP.Meta.ActPatInfoI</IndexLocation>
<StreamLocation>^DHCMed.DP.Meta.ActPatInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
