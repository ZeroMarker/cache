/// 病案复印登记表
Class DHCWMR.MO.CopyRecord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildVol As DHCWMR.MO.CopyRecordVol [ Cardinality = children, Inverse = Parref ];

Relationship ChildFee As DHCWMR.MO.CopyRecordFee [ Cardinality = children, Inverse = Parref ];

Relationship ChildStatus As DHCWMR.MO.CopyRecordStatus [ Cardinality = children, Inverse = Parref ];

/// 病案类型
Property CRMrType As DHCWMR.SS.MrType;

/// 病案主表
Property CRMainDr As DHCWMR.SS.Main;

/// 执行状态（登记RE、装订BO、收费CH、退费RF、作废U）
Property CRStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记日期
Property CRRegDate As %Date;

/// 登记时间
Property CRRegTime As %Time;

/// 登记人（指向SS_User）
Property CRRegUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 装订日期
Property CRBookDate As %Date;

/// 装订时间
Property CRBookTime As %Time;

/// 装订人（指向SS_User）
Property CRBookUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人姓名
Property CRClientName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人与患者关系（"RelationType"） 指向DHCWMR.SS.Dictionary
Property CRClientRelation As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人证明材料（"Certificate"） 指向DHCWMR.SS.Dictionary
Property CRCardTypeDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人身份证号/证件编号
Property CRPersonalID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人联系电话
Property CRTelephone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 委托人联系地址
Property CRAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印页数
Property CRPaperNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印内容（"MRCopyInfo"） 指向DHCWMR.SS.Dictionary  多个内容以#分割
Property CRContent As %String(MAXLEN = 100, TRUNCATE = 1);

/// 复印目的（"CopyAim"） 指向DHCWMR.SS.Dictionary  多个内容以#分割
Property CRPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注信息
Property CRNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 创建日期
Property CRCreateDate As %Date;

/// 创建时间
Property CRCreateTime As %Time;

/// 创建人（指向SS_User）
Property CRCreateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property CRUpdateDate As %Date;

/// 更新时间
Property CRUpdateTime As %Time;

/// 更新人（指向SS_User）
Property CRUpdateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记序号 格式：20150512001 日期+当天流水号
Property CRSerialNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 登记序号 索引
Index IndexSerialNumber On CRSerialNumber;

/// 病案类型 + 登记日期 索引
Index IndexMrTypeRegDate On (CRMrType, CRRegDate);

/// 病案主表 索引
Index IndexMainDr On CRMainDr;

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  更新病案复印登记表
/// Table：       DHCWMR.MO.CopyRecord
/// Input：       InputStr ：ID^病案类型^病案主表^执行状态^登记日期^登记时间^登记人^装订日期^装订时间^装订人^委托人姓名^委托人与患者关系^委托人证明材料^委托人身份证号/证件编号^委托人联系电话^委托人联系地址^复印页数^复印内容^复印目的^备注信息^创建日期^创建时间^创建人^更新日期^更新时间^更新人^登记序号
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.CopyRecord).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID 				= $p(aInputStr,aSeparate,1)
	Set MrTypeID		= $p(aInputStr,aSeparate,2)
	Set MainID			= $p(aInputStr,aSeparate,3)
	Set Status			= $p(aInputStr,aSeparate,4)
	Set RegDate			= $p(aInputStr,aSeparate,5)
	set:RegDate["-" RegDate=$zdh(RegDate,3)
	set:RegDate["/" RegDate=$zdh(RegDate,4)
	Set RegTime			= $p(aInputStr,aSeparate,6)
	set:RegTime[":" RegTime=$zth(RegTime,1)
	Set RegUser			= $p(aInputStr,aSeparate,7)
	Set BookDate		= $p(aInputStr,aSeparate,8)
	set:BookDate["-" BookDate=$zdh(BookDate,3)
	set:BookDate["/" BookDate=$zdh(BookDate,4)
	Set BookTime		= $p(aInputStr,aSeparate,9)
	set:BookTime[":" BookTime=$zth(BookTime,1)
	Set BookUser		= $p(aInputStr,aSeparate,10)
	Set ClientName		= $p(aInputStr,aSeparate,11)
	Set ClientRelation	= $p(aInputStr,aSeparate,12)
	Set CardType		= $p(aInputStr,aSeparate,13)
	Set PersonalID		= $p(aInputStr,aSeparate,14)
	Set Telephone		= $p(aInputStr,aSeparate,15)
	Set Address			= $p(aInputStr,aSeparate,16)
	Set PaperNumber		= $p(aInputStr,aSeparate,17)
	Set Content			= $p(aInputStr,aSeparate,18)
	Set Purpose			= $p(aInputStr,aSeparate,19)
	Set Note			= $p(aInputStr,aSeparate,20)
	Set CreateDate		= $p(aInputStr,aSeparate,21)
	set:CreateDate["-" CreateDate=$zdh(CreateDate,3)
	set:CreateDate["/" CreateDate=$zdh(CreateDate,4)
	Set CreateTime		= $p(aInputStr,aSeparate,22)
	set:CreateTime[":" CreateTime=$zth(CreateTime,1)
	Set CreateUser		= $p(aInputStr,aSeparate,23)
	Set UpdateDate		= $p(aInputStr,aSeparate,24)
	set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	set:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	Set UpdateTime		= $p(aInputStr,aSeparate,25)
	set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set UpdateUser		= $p(aInputStr,aSeparate,26)
	Set SerialNumber	= $p(aInputStr,aSeparate,27)

	Quit:(MrTypeID="")||(MainID="") return
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return

	Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MO.CopyRecord).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.CopyRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CRMrType		= objMrType
	Set obj.CRMainDr		= objMain
	Set obj.CRStatus		= Status
	Set obj.CRRegDate		= RegDate
	Set obj.CRRegTime		= RegTime
	Set obj.CRRegUser		= RegUser
	Set obj.CRBookDate		= BookDate
	Set obj.CRBookTime		= BookTime
	Set obj.CRBookUser		= BookUser
	Set obj.CRClientName	= ClientName
	Set obj.CRClientRelation= ClientRelation
	Set obj.CRCardTypeDr	= CardType
	Set obj.CRPersonalID	= PersonalID
	Set obj.CRTelephone		= Telephone
	Set obj.CRAddress		= Address
	Set obj.CRPaperNumber	= PaperNumber
	Set obj.CRContent		= Content
	Set obj.CRPurpose		= Purpose
	Set obj.CRNote			= Note
	Set obj.CRCreateDate	= CreateDate
	Set obj.CRCreateTime	= CreateTime
	Set obj.CRCreateUser	= CreateUser
	Set obj.CRUpdateDate	= UpdateDate
	Set obj.CRUpdateTime	= UpdateTime
	Set obj.CRUpdateUser	= UpdateUser
	Set obj.CRSerialNumber	= SerialNumber
	
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
/// CreatDate：   2015-08-02
/// Description:  取复印登记表记录
/// Table：       DHCWMR.MO.CopyRecord
/// Input：       Id : DHCWMR.MO.CopyRecord.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.CopyRecord).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.CopyRecord
{
	new (aId)
	set return=""
	quit:'##class(DHCWMR.MO.CopyRecord).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MO.CopyRecord).%OpenId(aId)
	quit:'$IsObject(obj) return
	quit:'$IsObject(obj.CRMainDr) return
	if obj.CRMainDr.SMIsActive'=1 {
		Set objMain=##class(DHCWMR.SS.Main).GetActMainByID(obj.CRMainDr.%Id())
		If $IsObject(objMain){
			Set obj.CRMainDr=objMain
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
/// CreatDate：   2015-08-02
/// Description:  删除复印登记表
/// Table：       DHCWMR.MO.CopyRecord
/// Input：       Id : DHCWMR.MO.CopyRecord.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.CopyRecord).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  初始化当天登记序号
/// w ##class(DHCWMR.MO.CopyRecord).InitSerialNumber()
ClassMethod InitSerialNumber() As %String
{
	New
	Set return = -1
	Set CurrentDate = $tr($zd(+$h,3),"-","")
	Quit:$d(^DHCWMR.MO.CopyRecordC("COPY",CurrentDate)) 1
	Set ^DHCWMR.MO.CopyRecordC("COPY",CurrentDate)=0
	Quit 1
}

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  获取登记序列号
/// w ##class(DHCWMR.MO.CopyRecord).GetSerialNumber()
ClassMethod GetSerialNumber() As %String
{
	New
	Set CurrentDate = $tr($zd(+$h,3),"-","")
	Set CurrentNo = $i(^DHCWMR.MO.CopyRecordC("COPY",CurrentDate))
	Set Number =""
	Set $p(Number,"0",4-$l(CurrentNo)) = CurrentNo 
	Set return = CurrentDate_Number
	Quit return
}

/// 处理因修改病案号导致MainDr改变数据处理
/// w ##class(DHCWMR.MO.CopyRecord).UpdateErrorMainDr(363)
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
			Set xRecordID=$o(^DHCWMR.MO.CopyRecordI("IndexMainDr",xMainID,xRecordID))
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
<Value>CRMrType</Value>
</Value>
<Value name="3">
<Value>CRMainDr</Value>
</Value>
<Value name="4">
<Value>CRStatus</Value>
</Value>
<Value name="5">
<Value>CRRegDate</Value>
</Value>
<Value name="6">
<Value>CRRegTime</Value>
</Value>
<Value name="7">
<Value>CRRegUser</Value>
</Value>
<Value name="8">
<Value>CRBookDate</Value>
</Value>
<Value name="9">
<Value>CRBookTime</Value>
</Value>
<Value name="10">
<Value>CRBookUser</Value>
</Value>
<Value name="11">
<Value>CRClientName</Value>
</Value>
<Value name="12">
<Value>CRClientRelation</Value>
</Value>
<Value name="13">
<Value>CRCardTypeDr</Value>
</Value>
<Value name="14">
<Value>CRPersonalID</Value>
</Value>
<Value name="15">
<Value>CRTelephone</Value>
</Value>
<Value name="16">
<Value>CRAddress</Value>
</Value>
<Value name="17">
<Value>CRPaperNumber</Value>
</Value>
<Value name="18">
<Value>CRContent</Value>
</Value>
<Value name="19">
<Value>CRPurpose</Value>
</Value>
<Value name="20">
<Value>CRNote</Value>
</Value>
<Value name="21">
<Value>CRCreateDate</Value>
</Value>
<Value name="22">
<Value>CRCreateTime</Value>
</Value>
<Value name="23">
<Value>CRCreateUser</Value>
</Value>
<Value name="24">
<Value>CRUpdateDate</Value>
</Value>
<Value name="25">
<Value>CRUpdateTime</Value>
</Value>
<Value name="26">
<Value>CRUpdateUser</Value>
</Value>
<Value name="27">
<Value>CRSerialNumber</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MO.CopyRecordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MO.CopyRecordD</IdLocation>
<IndexLocation>^DHCWMR.MO.CopyRecordI</IndexLocation>
<StreamLocation>^DHCWMR.MO.CopyRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
