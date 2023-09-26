/// 病案借阅登记表
Class DHCWMR.MO.LendRecord Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildVol As DHCWMR.MO.LendRecordVol [ Cardinality = children, Inverse = Parref ];

Relationship ChildStatus As DHCWMR.MO.LendRecordStatus [ Cardinality = children, Inverse = Parref ];

/// 病案类型
Property LRMrType As DHCWMR.SS.MrType;

/// 病案主表
Property LRMainDr As DHCWMR.SS.Main;

/// 执行状态（R申请、L借阅、B还回、U作废）
Property LRStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 申请日期
Property LRReqDate As %Date;

/// 申请时间
Property LRReqTime As %Time;

/// 申请人（指向SS_User）
Property LRReqUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出库日期
Property LRLendDate As %Date;

/// 出库时间
Property LRLendTime As %Time;

/// 出库人（指向SS_User）
Property LRLendUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 入库日期
Property LRBackDate As %Date;

/// 入库时间
Property LRBackTime As %Time;

/// 入库人（指向SS_User）
Property LRBackUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅科室（指向CT_loc）
Property LRLocID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅科室代码
Property LRLocCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅科室名称
Property LRLocDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅科室电话
Property LRLocTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人员（指向SS_User）
Property LRUserID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人员工号
Property LRUserCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人员姓名
Property LRUserDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅人员电话
Property LRUserTel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 借阅目的("LendAim")指向DHCWMR.SS.Dictionary(多个内容以#分割)
Property LRPurpose As %String(MAXLEN = 100, TRUNCATE = 1);

/// 预计归还日期
Property LRExpBackDate As %Date;

/// 备注信息
Property LRNote As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 创建日期
Property LRCreateDate As %Date;

/// 创建时间
Property LRCreateTime As %Time;

/// 创建人（指向SS_User）
Property LRCreateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 更新日期
Property LRUpdateDate As %Date;

/// 更新时间
Property LRUpdateTime As %Time;

/// 更新人（指向SS_User）
Property LRUpdateUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 打印标记
Property LRPrintFlag As %Boolean;

/// 就诊号
Property LREpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 分类(纸张病历1、电子病历2)
Property LRCategory As %String(MAXLEN = 100, TRUNCATE = 1);

/// 出库标记（建档出库N、申请自动出库A、副页打印出库F）
Property LRLendFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病案类型 + 申请日期 + 执行状态 索引
Index IndexMrTypeReqDateStatus On (LRMrType, LRReqDate, LRStatus);

/// 病案类型 + 出库日期 + 执行状态 索引
Index IndexMrTypeLendDateStatus On (LRMrType, LRLendDate, LRStatus);

/// 病案类型 + 入库日期 + 执行状态 索引
Index IndexMrTypeBackDateStatus On (LRMrType, LRBackDate, LRStatus);

/// 病案主表 索引
Index IndexMainDr On LRMainDr;

/// 病案主表 + 状态 索引
Index IndexMainDrStatus On (LRMainDr, LRStatus);

/// 就诊号 索引
Index IndexEpisodeID On LREpisodeID;

/// Creator：     liyi
/// CreatDate：   2015-11-04
/// Description:  更新打印标志
/// Table：       DHCWMR.MO.LendRecord
/// Input：       InputStr ：ID^打印标志
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.LendRecord).UpdatePrintFlag("","^")
ClassMethod UpdatePrintFlag(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID 				= $p(aInputStr,aSeparate,1)
	Set PrintFlag		= $p(aInputStr,aSeparate,2)
	Quit:(ID="")||(PrintFlag="") return
	
	Set obj=##class(DHCWMR.MO.LendRecord).%OpenId(ID)
	Quit:'$IsObject(obj) return
	
	Set obj.LRPrintFlag		=PrintFlag
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
/// Description:  更新病案借阅登记表
/// Table：       DHCWMR.MO.LendRecord
/// Input：       InputStr ：ID^病案类型^病案主表^执行状态^申请日期^申请时间^申请人^借阅日期^借阅时间^借阅人员^借阅科室^还回日期^还回时间^还回人^借阅科内电话^借阅人员工号^借阅人员姓名^借阅人员电话^借阅目的^预计归还日期^备注信息^创建日期^创建时间^创建人^更新日期^更新时间^更新人^打印标记^就诊号^批次号^分类
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.LendRecord).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return

	Set ID 				= $p(aInputStr,aSeparate,1)
	Set MrTypeID		= $p(aInputStr,aSeparate,2)
	Set MainID			= $p(aInputStr,aSeparate,3)
	Set Status			= $p(aInputStr,aSeparate,4)
	Set ReqDate			= $p(aInputStr,aSeparate,5)
	set:ReqDate["-" ReqDate=$zdh(ReqDate,3)
	set:ReqDate["/" ReqDate=$zdh(ReqDate,4)
	Set ReqTime			= $p(aInputStr,aSeparate,6)
	set:ReqTime[":" ReqTime=$zth(ReqTime,1)
	Set ReqUser			= $p(aInputStr,aSeparate,7)
	Set LendDate		= $p(aInputStr,aSeparate,8)
	set:LendDate["-" LendDate=$zdh(LendDate,3)
	set:LendDate["/" LendDate=$zdh(LendDate,4)
	Set LendTime		= $p(aInputStr,aSeparate,9)
	set:LendTime[":" LendTime=$zth(LendTime,1)
	Set LendUser		= $p(aInputStr,aSeparate,10)
	Set BackDate		= $p(aInputStr,aSeparate,11)
	set:BackDate["-" BackDate=$zdh(BackDate,3)
	set:BackDate["/" BackDate=$zdh(BackDate,4)
	Set BackTime		= $p(aInputStr,aSeparate,12)
	set:BackTime[":" BackTime=$zth(BackTime,1)
	Set BackUser		= $p(aInputStr,aSeparate,13)
	Set LocID			= $p(aInputStr,aSeparate,14)
	Set LocCode			= $p(aInputStr,aSeparate,15)
	Set LocDesc			= $p(aInputStr,aSeparate,16)
	Set LocTel			= $p(aInputStr,aSeparate,17)
	Set UserID			= $p(aInputStr,aSeparate,18)
	Set UserCode		= $p(aInputStr,aSeparate,19)
	Set UserDesc		= $p(aInputStr,aSeparate,20)
	Set UserTel			= $p(aInputStr,aSeparate,21)
	Set Purpose			= $p(aInputStr,aSeparate,22)
	Set ExpBackDate		= $p(aInputStr,aSeparate,23)
	;set:ExpBackDate["-" ExpBackDate=$zdh(ExpBackDate,3)
	;set:ExpBackDate["/" ExpBackDate=$zdh(ExpBackDate,4)
	Set:ExpBackDate'="" ExpBackDate=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(ExpBackDate) 
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
	Set PrintFlag		= $p(aInputStr,aSeparate,31)
	Set EpisodeID		= $p(aInputStr,aSeparate,32)
	Set Category		= $p(aInputStr,aSeparate,33)
	Set LendFlag        = $p(aInputStr,aSeparate,34)

	Quit:(MrTypeID="")||(MainID="") return
	
	Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(MrTypeID)
	Quit:'$IsObject(objMrType) return

	Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
	Quit:'$IsObject(objMain) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MO.LendRecord).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.LendRecord).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LRMrType		=objMrType
	Set obj.LRMainDr		=objMain
	Set obj.LRStatus		=Status
	Set obj.LRReqDate		=ReqDate
	Set obj.LRReqTime		=ReqTime
	Set obj.LRReqUser		=ReqUser
	Set obj.LRLendDate		=LendDate
	Set obj.LRLendTime		=LendTime
	Set obj.LRLendUser		=LendUser
	Set obj.LRBackDate		=BackDate
	Set obj.LRBackTime		=BackTime
	Set obj.LRBackUser		=BackUser
	Set obj.LRLocID		    =LocID
	Set obj.LRLocCode		=LocCode
	Set obj.LRLocDesc		=LocDesc
	Set obj.LRLocTel		=LocTel
	Set obj.LRUserID		=UserID
	Set obj.LRUserCode		=UserCode
	Set obj.LRUserDesc		=UserDesc
	Set obj.LRUserTel		=UserTel
	Set obj.LRPurpose		=Purpose
	Set obj.LRExpBackDate	=ExpBackDate
	Set obj.LRNote			=Note
	Set obj.LRCreateDate	=CreateDate
	Set obj.LRCreateTime	=CreateTime
	Set obj.LRCreateUser	=CreateUser
	Set obj.LRUpdateDate	=UpdateDate
	Set obj.LRUpdateTime	=UpdateTime
	Set obj.LRUpdateUser	=UpdateUser
	Set obj.LRPrintFlag		=PrintFlag
	Set obj.LREpisodeID		=EpisodeID
	Set obj.LRCategory		=Category
	Set obj.LRLendFlag      =LendFlag
	
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
/// Description:  取病案借阅登记表记录
/// Table：       DHCWMR.MO.LendRecord
/// Input：       Id : DHCWMR.MO.LendRecord.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.LendRecord).GetObjById(41)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.LendRecord
{
	new (aId)
	set return=""
	quit:'##class(DHCWMR.MO.LendRecord).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MO.LendRecord).%OpenId(aId)
	quit:'$IsObject(obj) return
	quit:'$IsObject(obj.LRMainDr) return
	if obj.LRMainDr.SMIsActive'=1 {
		Set objMain=##class(DHCWMR.SS.Main).GetActMainByID(obj.LRMainDr.%Id())
		If $IsObject(objMain){
			Set obj.LRMainDr=objMain
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
/// Description:  删除病案借阅登记表
/// Table：       DHCWMR.MO.LendRecord
/// Input：       Id : DHCWMR.MO.LendRecord.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.LendRecord).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// 处理因修改病案号导致MainDr改变数据处理
/// w ##class(DHCWMR.MO.LendRecord).UpdateErrorMainDr(363)
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
			Set xRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMainDr",xMainID,xRecordID))
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
<Value>LRMrType</Value>
</Value>
<Value name="3">
<Value>LRMainDr</Value>
</Value>
<Value name="4">
<Value>LRStatus</Value>
</Value>
<Value name="5">
<Value>LRReqDate</Value>
</Value>
<Value name="6">
<Value>LRReqTime</Value>
</Value>
<Value name="7">
<Value>LRReqUser</Value>
</Value>
<Value name="8">
<Value>LRLendDate</Value>
</Value>
<Value name="9">
<Value>LRLendTime</Value>
</Value>
<Value name="10">
<Value>LRLendUser</Value>
</Value>
<Value name="11">
<Value>LRBackDate</Value>
</Value>
<Value name="12">
<Value>LRBackTime</Value>
</Value>
<Value name="13">
<Value>LRBackUser</Value>
</Value>
<Value name="14">
<Value>LRLocID</Value>
</Value>
<Value name="15">
<Value>LRLocCode</Value>
</Value>
<Value name="16">
<Value>LRLocDesc</Value>
</Value>
<Value name="17">
<Value>LRLocTel</Value>
</Value>
<Value name="18">
<Value>LRUserID</Value>
</Value>
<Value name="19">
<Value>LRUserCode</Value>
</Value>
<Value name="20">
<Value>LRUserDesc</Value>
</Value>
<Value name="21">
<Value>LRUserTel</Value>
</Value>
<Value name="22">
<Value>LRPurpose</Value>
</Value>
<Value name="23">
<Value>LRExpBackDate</Value>
</Value>
<Value name="24">
<Value>LRNote</Value>
</Value>
<Value name="25">
<Value>LRCreateDate</Value>
</Value>
<Value name="26">
<Value>LRCreateTime</Value>
</Value>
<Value name="27">
<Value>LRCreateUser</Value>
</Value>
<Value name="28">
<Value>LRUpdateDate</Value>
</Value>
<Value name="29">
<Value>LRUpdateTime</Value>
</Value>
<Value name="30">
<Value>LRUpdateUser</Value>
</Value>
<Value name="31">
<Value>LRPrintFlag</Value>
</Value>
<Value name="32">
<Value>LREpisodeID</Value>
</Value>
<Value name="33">
<Value>LRCategory</Value>
</Value>
<Value name="34">
<Value>LRLendFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MO.LendRecordD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MO.LendRecordD</IdLocation>
<IndexLocation>^DHCWMR.MO.LendRecordI</IndexLocation>
<StreamLocation>^DHCWMR.MO.LendRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
