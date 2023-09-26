/// 名称: DHCMed.CR.PO.Data
/// 描述: 实例数据超类
/// 编写者：wuqk
/// 编写日期: 2012-11-22
Class DHCMed.CR.PO.Data Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock ]
{

/// 病人ID User.PAPatMas.PAPMI_RowID
Property PatientID As %Integer;

/// 就诊ID User.Paadm.PAADM_RowID
Property EpisodeID As %Integer;

/// 目标用户ID User.SSUser.SSU_RowID
Property GoalUserID As %Integer;

/// 创建用户ID User.SSUser.SSU_RowID
Property CreateUserID As %Integer;

/// 创建用户代码 User.SSUser.SSUSRInitials
Property CreateUserCode As %String [ Calculated ];

/// 创建用户 User.SSUser.SSUSRName
Property CreateUserName As %String [ Calculated ];

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 创建用户科室ID User.CTLoc.CTLOC_RowID
Property CreateCTLocID As %Integer;

/// 创建用户科室 User.CTLoc.CTLOCDesc
Property CreateCTLocDesc As %String [ Calculated ];

/// 当前状态代码 DHCMed.SS.Dictionary, dicCode='CRFDataStatus'
Property CurrentStatusCode As %String;

/// 当前状态描述
Property CurrentStatus As %String [ Calculated ];

/// 状态列表
Relationship StatusList As DHCMed.CR.PO.StatusList [ Cardinality = children, Inverse = ParRef ];

/// 表单布局版本
Property FormVerDR As %String [ Required ];

/// Add By LiYang 2013-11-01
/// 用来生成自定义的主键，针对不同报告需要不同的判断机制判断是否已上报
/// 比如：慢性病报告卡需要区分慢性病的病种
/// 用来生成索引节点的值（在子类中重写这个函数，以便确定某种报告应该以何种方式判定重复报告）
Property CustomPK As %String;

/// 患者ID的索引 Add By LiYang 2013-10-24
Index IndexPatientID On PatientID;

/// Add By LiYang 2013-11-03
/// 自定义主键，用来判断报告是否重复上报
Index IndexCustomPK On (FormVerDR, PatientID, CustomPK);

/// 就诊ID的索引
Index IndexEpisodeID On EpisodeID;

//FormVer

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	
	//需要通过request或者session传入：用户信息/状态信息/科室信息
	//对于指定类型的报告，需要传入：PatientID/EpisodeID等信息
	
	if insert { //data中始终记录初次报告人、报告科室、报告时间
		set ..CreateUserID =+%session.Get("LOGON.USERID") // 
		set ..CreateCTLocID =+%session.Get("LOGON.CTLOCID") // 
		set ..CreateDate = +$h
		set ..CreateTime = $p($h,",",2)
		;set ..FormVerDR = %request.Get("formVerId") //##class(DHCMed.CR.PO.FormVer).%OpenId(formVerId)
	}
	//set ..CurrentStatusCode =  i%CurrentStatusCode //_CurrentStatusCode   ///move
	Set ..CustomPK=..GetCustomPK() //Add By LiYang 2013-11-03 用来判断是否重复保卡的问题
	
	set objStatus = ##class(DHCMed.CR.PO.StatusList).%New()
	set objStatus.ParRef = %this
	set objStatus.sDate = +$h //i%CreateDate
	set objStatus.sTime = $p($h,",",2)
	set objStatus.sUserID = i%CreateUserID
	set objStatus.sStatusCode = i%CurrentStatusCode
	set sc=objStatus.%Save()
	
	Quit $$$OK
}

/// Creator：     wuqk
/// CreatDate：   2012-12-20
/// Description:  根据ID取表单示例数据
/// Table：       DHCMed.CR.PO.Data
/// Input：       ID:    DHCMed.CR.PO.Data.ID
/// Return：      返回obj
/// w ##class(DHCMed.CR.PO.Data).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CR.PO.Data
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CR.PO.Data).%ExistsId(+id) return
	set obj=##Class(DHCMed.CR.PO.Data).%OpenId(+id)
	set return=obj
	set obj=""
	quit return
}

/// 获取当前状态
/// DHCMed.SS.Dictionary, dicCode='CRFDataStatus'
Method CurrentStatusGet() As %String
{
	set objDicCurrentStatus = ##class(DHCMed.SS.Dictionary).GetByTypeCode("CRFDataStatus",i%CurrentStatusCode,"")
	set ^tmpcrf("CurrentStatusGet",1)=i%CurrentStatusCode
	
	set formCurrentStatus = ""
	if $IsObject(objDicCurrentStatus) {
		set formCurrentStatus = objDicCurrentStatus.Description
		set ^tmpcrf("CurrentStatusGet",2)=formCurrentStatus
	}
	set objDicCurrentStatus = ""
	quit formCurrentStatus
}

/// 获取创建用户代码
Method CreateUserCodeGet() As %String
{
	if (+i%CreateUserID>0){
		quit $p($g(^SSU("SSUSR",+i%CreateUserID)),"^",1)
	}
	else {
		quit ""
	}
}

/// 获取创建用户名称
Method CreateUserNameGet() As %String
{
	if (+i%CreateUserID>0){
		quit $p($g(^SSU("SSUSR",+i%CreateUserID)),"^",2)
	}
	else {
		quit ""
	}
}

/// 获取创建科室
Method CreateCTLocDescGet() As %String
{
	if (+i%CreateCTLocID>0){
		quit $p($g(^CTLOC(+i%CreateCTLocID)),"^",2)
	}
	else {
		quit ""
	}
}

/// Add By LiYang 2013-11-03
/// 用来生成自定义主键索引（用来判断是否重复报告）
/// 默认值是返回报告的ID
/// 应该在DHCMed.CR.PO.Data的子类中重写这个函数
Method GetCustomPK() As %String
{
	Quit 1
}

/// Creator:李阳
/// Create Date:2013-11-23
/// 功能：通过ID查询各字段的值
/// ID:数据的RowID
///  do ##class(%Library.ResultSet).RunQuery("DHCMed.CR.ManXingBingDiaoCha","QryByID",19)
Query QryByID(ID As %String) As %Query(ROWSPEC = "FieldName:%String,FieldValue:%String") [ SqlProc ]
{
}

ClassMethod QryByIDExecute(ByRef qHandle As %Binary, ID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set ClassName=..%ClassName(1)
	set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
	Set objIns=..%OpenId(ID)
	Quit:'$IsObject(objIns) $$$OK
	for i=1:1:cdef.Properties.Count() {
		Set objProperty=cdef.Properties.GetAt(i)
		Set data=$lb("")
		s type = objProperty.Type
		S arg="Set value=objIns."_objProperty.Name //Modified By LiYang 2014-05-14为了老数据库的兼容性修改
		X arg
		;s value=$property(objIns,objProperty.Name)
		s:((type="%Library.Date")||(type="%Date"))&&(value'="") value=$zd(value, 3)
		Set $li(data,1)=objProperty.Name
		Set $li(data,2)=value
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="DataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>GoalUserID</Value>
</Value>
<Value name="5">
<Value>CreateUserID</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>CreateCTLocID</Value>
</Value>
<Value name="9">
<Value>CurrentStatusCode</Value>
</Value>
<Value name="10">
<Value>FormVerDR</Value>
</Value>
<Value name="11">
<Value>CustomPK</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.PO.DataD</DataLocation>
<DefaultData>DataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.PO.DataD</IdLocation>
<IndexLocation>^DHCMed.CR.PO.DataI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.DataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
