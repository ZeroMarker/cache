/// 病案封存登记表
Class DHCWMR.MO.SealRecord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildVol As DHCWMR.MO.SealRecordVol [ Cardinality = children, Inverse = Parref ];

Relationship ChildStatus As DHCWMR.MO.SealRecordStatus [ Cardinality = children, Inverse = Parref ];

/// 病案类型
Property SRMrType As DHCWMR.SS.MrType;

/// 病案主表
Property SRMainDr As DHCWMR.SS.Main;

/// 执行状态（S封存、F解封、U作废）
Property SRStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存日期
Property SRSealDate As %Date;

/// 封存时间
Property SRSealTime As %Time;

/// 封存人（指向SS_User）
Property SRSealUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 解封日期
Property SRFreeDate As %Date;

/// 解封时间
Property SRFreeTime As %Time;

/// 解封人（指向SS_User）
Property SRFreeUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人姓名
Property SRClientName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人与患者关系（"RelationType"） 指向DHCWMR.SS.Dictionary
Property SRClientRelation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人证明材料（"Certificate"） 指向DHCWMR.SS.Dictionary
Property SRCardTypeDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人身份证号/证件编号
Property SRPersonalID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人联系电话
Property SRTelephone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人联系地址
Property SRAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存内容（"StoreContent"） 指向DHCWMR.SS.Dictionary
Property SRContent As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存原因（"StoreReason"） 指向DHCWMR.SS.Dictionary
Property SRPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存数量
Property SRCount As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医师工号
Property SRDocCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医师姓名
Property SRDocName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医务处人员工号
Property SRMedUserCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 封存医务处人员姓名
Property SRMedUserName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注信息
Property SRNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 创建日期
Property SRCreateDate As %Date;

/// 创建时间
Property SRCreateTime As %Time;

/// 创建人（指向SS_User）
Property SRCreateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property SRUpdateDate As %Date;

/// 更新时间
Property SRUpdateTime As %Time;

/// 更新人（指向SS_User）
Property SRUpdateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案类型 + 封存日期 + 执行状态 索引
Index IndexMrTypeSealDateStatus On (SRMrType, SRSealDate, SRStatus);

/// 病案类型 + 解封日期 + 执行状态 索引
Index IndexMrTypeFreeDateStatus On (SRMrType, SRFreeDate, SRStatus);

/// 病案主表 索引
Index IndexMainDr On SRMainDr;

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  更新病案封存登记表
/// Table：       DHCWMR.MO.SealRecord
/// Input：       InputStr ：ID^病案类型^病案主表^执行状态^封存日期^封存时间^封存人^解封日期^解封时间^解封人^委托人姓名^委托人与患者关系^委托人证明材料^委托人身份证号/证件编号^委托人联系电话^委托人联系地址^封存内容^封存原因^封存数量^封存医师工号^封存医师姓名^封存医务处人员工号^封存医务处人员姓名^备注信息^创建日期^创建时间^创建人^更新日期^更新时间^更新人
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.SealRecord).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return

	Set ID 				= $p(aInputStr,aSeparate,1)
	Set MrTypeID		= $p(aInputStr,aSeparate,2)
	Set MainID			= $p(aInputStr,aSeparate,3)
	Set Status			= $p(aInputStr,aSeparate,4)
	Set SealDate		= $p(aInputStr,aSeparate,5)
	set:SealDate["-" SealDate=$zdh(SealDate,3)
	set:SealDate["/" SealDate=$zdh(SealDate,4)
	Set SealTime		= $p(aInputStr,aSeparate,6)
	set:SealTime[":" SealTime=$zth(SealTime,1)
	Set SealUser		= $p(aInputStr,aSeparate,7)
	Set FreeDate		= $p(aInputStr,aSeparate,8)
	set:FreeDate["-" FreeDate=$zdh(FreeDate,3)
	set:FreeDate["/" FreeDate=$zdh(FreeDate,4)
	Set FreeTime		= $p(aInputStr,aSeparate,9)
	set:FreeTime[":" FreeTime=$zth(FreeTime,1)
	Set FreeUser		= $p(aInputStr,aSeparate,10)
	Set ClientName		= $p(aInputStr,aSeparate,11)
	Set ClientRelation	= $p(aInputStr,aSeparate,12)
	Set CardTypeDr		= $p(aInputStr,aSeparate,13)
	Set PersonalID		= $p(aInputStr,aSeparate,14)
	Set Telephone		= $p(aInputStr,aSeparate,15)
	Set Address			= $p(aInputStr,aSeparate,16)
	Set Content			= $p(aInputStr,aSeparate,17)
	Set Purpose			= $p(aInputStr,aSeparate,18)
	Set Count			= $p(aInputStr,aSeparate,19)
	Set DocCode			= $p(aInputStr,aSeparate,20)
	Set DocName			= $p(aInputStr,aSeparate,21)
	Set MedUserCode		= $p(aInputStr,aSeparate,22)
	Set MedUserName		= $p(aInputStr,aSeparate,23)
	Set Note			= $p(aInputStr,aSeparate,24)
	Set CreateDate		= $p(aInputStr,aSeparate,25)
	set:CreateDate["-" CreateDate=$zdh(CreateDate,3)
	set:CreateDate["/" CreateDate=$zdh(CreateDate,4)
	Set CreateTime		= $p(aInputStr,aSeparate,26)
	set:CreateTime[":" CreateTime=$zth(CreateTime,1)
	Set CreateUser		= $p(aInputStr,aSeparate,27)
	Set UpdateDate		= $p(aInputStr,aSeparate,28)
	set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	Set UpdateTime		= $p(aInputStr,aSeparate,29)
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set UpdateUser		= $p(aInputStr,aSeparate,30)
	Quit:(MrTypeID="")||(MainID="") return
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return

	Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MO.SealRecord).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.SealRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SRMrType 		=objMrType		
	Set obj.SRMainDr		= objMain		
	Set obj.SRStatus		= Status		
	Set obj.SRSealDate		= SealDate		
	Set obj.SRSealTime		= SealTime		
	Set obj.SRSealUser		= SealUser		
	Set obj.SRFreeDate		= FreeDate		
	Set obj.SRFreeTime		= FreeTime		
	Set obj.SRFreeUser		= FreeUser		
	Set obj.SRClientName	= ClientName		
	Set obj.SRClientRelation= ClientRelation	
	Set obj.SRCardTypeDr	= CardTypeDr		
	Set obj.SRPersonalID	= PersonalID		
	Set obj.SRTelephone		= Telephone		
	Set obj.SRAddress		= Address		
	Set obj.SRContent		= Content		
	Set obj.SRPurpose		= Purpose		
	Set obj.SRCount			= Count		
	Set obj.SRDocCode		= DocCode		
	Set obj.SRDocName		= DocName		
	Set obj.SRMedUserCode	= MedUserCode		
	Set obj.SRMedUserName	= MedUserName		
	Set obj.SRNote			= Note		
	Set obj.SRCreateDate	= CreateDate		
	Set obj.SRCreateTime	= CreateTime		
	Set obj.SRCreateUser	= CreateUser		
	Set obj.SRUpdateDate	= UpdateDate		
	Set obj.SRUpdateTime	= UpdateTime		
	Set obj.SRUpdateUser	= UpdateUser		
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  取病病案封存登记表记录
/// Table：       DHCWMR.MO.SealRecord
/// Input：       Id : DHCWMR.MO.SealRecord.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.SealRecord).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.SealRecord
{
	new (aId)
	set return=""
	quit:'##class(DHCWMR.MO.SealRecord).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MO.SealRecord).%OpenId(aId)
	quit:'$IsObject(obj) return
	quit:'$IsObject(obj.SRMainDr) return
	if obj.SRMainDr.SMIsActive'=1 {
		Set objMain=##class(DHCWMR.SS.Main).GetActMainByID(obj.SRMainDr.%Id())
		If $IsObject(objMain){
			Set obj.SRMainDr=objMain
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {  //检查Save是否成功
		   		Set return=""
			} Else {
				Set return=obj
			}
		}
	}
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  删除病案封存登记表
/// Table：       DHCWMR.MO.SealRecord
/// Input：       Id : DHCWMR.MO.SealRecord.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.SealRecord).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// 处理因修改病案号导致MainDr改变数据处理
/// w ##class(DHCWMR.MO.SealRecord).UpdateErrorMainDr(363)
ClassMethod UpdateErrorMainDr(aHisMainIDs As %String) As %String
{
	New (aHisMainIDs)
	Set return=0
	Quit:(aHisMainIDs="") return
	
	For indM=1:1:$l(aHisMainIDs,",") {
		Set xMainID=$p(aHisMainIDs,",",indM)
		Continue:xMainID=""
		
		Set xRecordID=""
		For {
			Set xRecordID=$o(^DHCWMR.MO.SealRecordI("IndexMainDr",xMainID,xRecordID))
			Quit:xRecordID=""
			Set obj=..GetObjById(xRecordID)
			Set:'$IsObject(obj) return=-1
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SRMrType</Value>
</Value>
<Value name="3">
<Value>SRMainDr</Value>
</Value>
<Value name="4">
<Value>SRStatus</Value>
</Value>
<Value name="5">
<Value>SRSealDate</Value>
</Value>
<Value name="6">
<Value>SRSealTime</Value>
</Value>
<Value name="7">
<Value>SRSealUser</Value>
</Value>
<Value name="8">
<Value>SRFreeDate</Value>
</Value>
<Value name="9">
<Value>SRFreeTime</Value>
</Value>
<Value name="10">
<Value>SRFreeUser</Value>
</Value>
<Value name="11">
<Value>SRClientName</Value>
</Value>
<Value name="12">
<Value>SRClientRelation</Value>
</Value>
<Value name="13">
<Value>SRCardTypeDr</Value>
</Value>
<Value name="14">
<Value>SRPersonalID</Value>
</Value>
<Value name="15">
<Value>SRTelephone</Value>
</Value>
<Value name="16">
<Value>SRAddress</Value>
</Value>
<Value name="17">
<Value>SRContent</Value>
</Value>
<Value name="18">
<Value>SRPurpose</Value>
</Value>
<Value name="19">
<Value>SRCount</Value>
</Value>
<Value name="20">
<Value>SRDocCode</Value>
</Value>
<Value name="21">
<Value>SRDocName</Value>
</Value>
<Value name="22">
<Value>SRMedUserCode</Value>
</Value>
<Value name="23">
<Value>SRMedUserName</Value>
</Value>
<Value name="24">
<Value>SRNote</Value>
</Value>
<Value name="25">
<Value>SRCreateDate</Value>
</Value>
<Value name="26">
<Value>SRCreateTime</Value>
</Value>
<Value name="27">
<Value>SRCreateUser</Value>
</Value>
<Value name="28">
<Value>SRUpdateDate</Value>
</Value>
<Value name="29">
<Value>SRUpdateTime</Value>
</Value>
<Value name="30">
<Value>SRUpdateUser</Value>
</Value>
<Value name="31">
<Value>SRBatchNumber</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MO.SealRecordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MO.SealRecordD</IdLocation>
<IndexLocation>^DHCWMR.MO.SealRecordI</IndexLocation>
<StreamLocation>^DHCWMR.MO.SealRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
