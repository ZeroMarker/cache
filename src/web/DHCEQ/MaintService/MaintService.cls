/// web.DHCEQ.MaintService.MaintService
Class web.DHCEQ.MaintService.MaintService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "MaintService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/csp/websource";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// add by zx 2015-06-13
/// 根据设备编号获取设备信息,设备编号必须唯一且正确
ClassMethod GetEquipInfo(EquipNo As %String) As %String [ WebMethod ]
{
	if EquipNo=$C(0) set EquipNo=""
	q ##class(web.DHCEQM.DHCEQMaintForService).GetEquipByEquipNo(EquipNo)
}

/// add by zx 2015-06-18
/// 设备维修信息更新
ClassMethod SaveMaintRequest(valInfo As %String) As %String [ WebMethod ]
{
	if valInfo=$C(0) set valInfo=""
	set EvaluateInfo="EEvaluateTypeDR^EScore^EContent^ERemark^EUserDR^EDate^ETime"
	q ##class(web.DHCEQM.DHCEQMMaintRequest).UpdateMaintRequest("","",valInfo,EvaluateInfo)
}

/// add by zx 2015-06-18
/// 设备维修信息提交
/// 入参 维修单ID
ClassMethod SubmitMaintRequest(MRRowID As %String, MRGUser As %String, MRGroupID As %String) As %String [ WebMethod ]
{
	if MRRowID=$C(0) set MRRowID=""
	if MRGUser=$C(0) set MRGUser=""
	if MRGroupID=$C(0) set MRGroupID=""
	s ^DHCEQPDACount("submit",MRGUser,$h)=MRGUser  //add by zx 2016-05-17
	q ##class(web.DHCEQM.DHCEQMMaintRequest).SubmitMaintRequest("","",MRRowID,"1",MRGUser,MRGroupID)
}

/// add by zx 2015-06-19
/// 设备详细维修信息
/// 入参 维修单ID
/// modified By qw 20170929 需求号:458987 新增参数Action
ClassMethod GetMaintRequestInfo(MaintRequestID As %String, Action As %String = "") As %String [ WebMethod ]
{
	if MaintRequestID=$C(0) set MaintRequestID=""
	if Action=$C(0) set Action=""
	i MaintRequestID="" q:"-1001"
	q ##class(web.DHCEQM.DHCEQMMaintRequest).GetOneMaintRequest("","",MaintRequestID,"",Action,"")
}

/// add by zx 2015-06-23
/// 设备维修基础数据信息
/// 入参 表名
ClassMethod GetMaintBasisInfo(TableName As %String) As %String [ WebMethod ]
{
	if TableName=$C(0) set TableName=""
	q ##class(web.DHCEQM.DHCEQMaintForService).GetMaintBasisData(TableName)
}

/// add by zx 2015-06-25
/// 维修单信息
///                           Status, ExObjDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", LocFlag As %String = "", UserFlag As %String = "", GroupID As %String = "", CurUser As %String = "", ManageLimitFlag As %String = "", vData As %String = ""
ClassMethod QueryMaintRequest(Status, ExObjDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", LocFlag As %String = "", UserFlag As %String = "", GroupID As %String = "", CurUser As %String = "", ManageLimitFlag As %String = "", vData As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Status=$C(0) set Status=""
	if ExObjDR=$C(0) set ExObjDR=""
	if RequestLocDR=$C(0) set RequestLocDR=""
	if StartDate=$C(0) set StartDate=""
	if EndDate=$C(0) set EndDate=""
	if ApproveRole=$C(0) set ApproveRole=""
	if WaitAD=$C(0) set WaitAD=""
	if QXType=$C(0) set QXType=""
	if RequestNo=$C(0) set RequestNo=""
	if InvalidFlag=$C(0) set InvalidFlag=""
	if LocFlag=$C(0) set LocFlag=""
	if UserFlag=$C(0) set UserFlag=""
	if GroupID=$C(0) set GroupID=""
	if CurUser=$C(0) set CurUser=""
	if ManageLimitFlag=$C(0) set ManageLimitFlag=""
	if vData=$C(0) set vData=""   //add by zx 2015-09-25
	s ^DHCEQPDACount("query",CurUser,$h)=CurUser  //add by zx 2016-05-17
	//s ^DHCEQHHM("s")="'"_Status_"','"_ExObjDR_"','"_RequestLocDR_"','"_StartDate_"','"_EndDate_"','"_ApproveRole_"','"_WaitAD_"','"_QXType_"','"_RequestNo_"','"_InvalidFlag_"','"_LocFlag_"','"_UserFlag_"','"_GroupID_"','"_CurUser_"','"_ManageLimitFlag_"','"_vData
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequest")
	//Do result.SetArgs(Status, ExObjDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo, InvalidFlag, LocFlag, UserFlag, GroupID, CurUser, ManageLimitFlag, vData)  
	Do result.SetArgs(Status, ExObjDR, RequestLocDR, StartDate, EndDate, ApproveRole, WaitAD, QXType, RequestNo, InvalidFlag, LocFlag, UserFlag, GroupID, CurUser, vData)  //2016-01-15 去掉ManageLimitFlag参数
	Quit result
}

/// add by zx 2015-06-29
/// 维修受理时更新受理日期
ClassMethod UpdateAccept(AcceptDate, MaintRequestID) As %String [ WebMethod ]
{
	if AcceptDate=$C(0) set AcceptDate=""
	if MaintRequestID=$C(0) set MaintRequestID=""	
	q ##Class(web.DHCEQM.DHCEQMaintForService).UpdateAcceptDate(AcceptDate, MaintRequestID)
}

/// add by zx 2015-06-29
/// 维修受理审核
/// modified By qw 20170929 需求号:458987 新增参数ActionCode
ClassMethod AuditMaintRequest(val, CurRole, RoleStep, editFieldsInfo, ApproveFlowID As %Library.String = "", MaintProcess, ActionCode As %String = "") As %String [ WebMethod ]
{
	if val=$C(0) set val=""
	if CurRole=$C(0) set CurRole=""
	if RoleStep=$C(0) set RoleStep=""
	if editFieldsInfo=$C(0) set editFieldsInfo=""
	if ApproveFlowID=$C(0) set ApproveFlowID=""	
	if MaintProcess=$C(0) set MaintProcess=""
	q ##Class(web.DHCEQM.DHCEQMMaintRequest).AuditData(val, CurRole, RoleStep, editFieldsInfo, ApproveFlowID,MaintProcess,ActionCode)
}

/// add by zx 2015-06-30
/// 获取配件信息
/// 
ClassMethod QueryAccessoryInfo(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if ASDRowID=$C(0) set ASDRowID=""
	if LocDR=$C(0) set LocDR=""
	if AccessoryTypeDR=$C(0) set AccessoryTypeDR=""
	if Desc=$C(0) set Desc=""
	if Flag=$C(0) set Flag=""
	if ChangeType=$C(0) set ChangeType=""
	if vMXRowID=$C(0) set vMXRowID=""
	if ProviderDR=$C(0) set ProviderDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMaintForService:GetAStockDetail")
	Do result.SetArgs(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID, ProviderDR)
	Quit result
}

/// add by zx 2015-07-03
/// 设备维修配件的使用与删除
/// 
ClassMethod SaveAccessory(val, isDel As %Library.String = "", user As %Library.String = "", loc As %Library.String = "") As %String [ WebMethod ]
{
	if val=$C(0) set val=""
	if isDel=$C(0) set isDel=""
	if user=$C(0) set user=""
	if loc=$C(0) set loc=""
	q ##class(web.DHCEQM.DHCEQMMaintPart).SaveData(val,isDel,user,loc)
}

/// add by zx 2015-07-06
/// 获取维修配件列表
ClassMethod QueryMaintPartInfo(MaintRequestDR As %String = "", MaintItemDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if MaintRequestDR=$C(0) set MaintRequestDR=""
	if MaintItemDR=$C(0) set MaintItemDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintPart:MaintPart")
	Do result.SetArgs(MaintRequestDR, MaintItemDR)
	Quit result
}

/// add by zx 2015-07-08
/// 获取维修单据列表
/// modified By qw 20170929 需求号:458993 新增参数CurGroupID Android需要传入当前安全组修改传参LeaderFlag的值为空
ClassMethod QueryMaintDetailInfo(Status, ExObjDR, RequestLocDR, StartDate, EndDate, QXType, RequestNo As %String = "", InvalidFlag As %String = "N", AcceptUserDR As %String = "", CurUser As %String = "", ExObj As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Status=$C(0) set Status=""
	if ExObjDR=$C(0) set ExObjDR=""
	if RequestLocDR=$C(0) set RequestLocDR=""
	if StartDate=$C(0) set StartDate=""
	if EndDate=$C(0) set EndDate=""
	if QXType=$C(0) set QXType=""
	if RequestNo=$C(0) set RequestNo=""
	if InvalidFlag=$C(0) set InvalidFlag=""
	if AcceptUserDR=$C(0) set AcceptUserDR=""
	if CurUser=$C(0) set CurUser=""  //Add By QW20160229
	if ExObj=$C(0) set ExObj=""      //add by HHM2016-04-18
	if CurLocID=$C(0) set CurLocID=""
	if CurGroupID=$C(0) set CurGroupID=""    //modified By qw 20170929 需求号:458993
	i StartDate'="" s StartDate=$zdh(StartDate,4)  /// modified By qw 20170929 需求号:458993 
	i EndDate'="" s EndDate=$zdh(EndDate,4)  /// modified By qw 20170929 需求号:458993 
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMMaintRequest:GetMaintRequestDetail")
	Do result.SetArgs(Status, ExObjDR, RequestLocDR, StartDate, EndDate, QXType, RequestNo, InvalidFlag, AcceptUserDR,CurUser,ExObj,"","","",CurLocID,CurGroupID)  //modified By qw 20170929 需求号:458993
	Quit result
}

/// add by zx 2015-07-20
/// 获取维修工程师工作量
ClassMethod QueryMaintEngineerInfo(EngineerDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %XML.DataSet [ WebMethod ]
{
	if EngineerDR=$C(0) set EngineerDR=""
	if StartMonth=$C(0) set StartMonth=""
	if EndMonth=$C(0) set EndMonth=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMaintForService:MaintEngineerWorkNum")
	Do result.SetArgs(EngineerDR, StartMonth, EndMonth)
	Quit result
}

/// 获取设备台账列表
ClassMethod QueryEquipListInfo(Equip, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "", GroupID As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Equip=$C(0) set Equip=""
	if vUseLoc=$C(0) set vUseLoc=""
	if vNeedUseLoc=$C(0) set vNeedUseLoc=""
	if vStockStatuType=$C(0) set vStockStatuType=""
	if vBAFlag=$C(0) set vBAFlag=""
	if QXType=$C(0) set QXType=""
	if GroupID=$C(0) set GroupID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQEquip:GetShortEquip")
	Do result.SetArgs(Equip, vUseLoc, vNeedUseLoc, vStockStatuType, vBAFlag, QXType, GroupID)
	Quit result
}

/// add by zx 2015-09-25
/// 设备维修自动保存维护对象
/// 
ClassMethod AutoSaveExObj(EQRowID) As %String [ WebMethod ]
{
	if EQRowID=$C(0) set EQRowID=""
	q ##class(web.DHCEQM.DHCEQMExObj).AutoSaveExObj(EQRowID)
}

/// add by zx 2015-12-15
/// 获取审批信息
/// 
ClassMethod GetApproveInfoBySourceID(ApproveTypeCode, rowid, ApproveRoleDR) As %String [ WebMethod ]
{
	if ApproveTypeCode=$C(0) set ApproveTypeCode=""
	if rowid=$C(0) set rowid=""
	if ApproveRoleDR=$C(0) set ApproveRoleDR=""
	q ##class(web.DHCEQApprove).GetApproveInfoBySourceID(ApproveTypeCode, rowid, ApproveRoleDR)
}

/// add by zx 2015-12-15
/// 获取可不编辑字段
/// 
ClassMethod GetRequiredFields(ApproveSetDR, Role, ActionCode As %String = "") As %String [ WebMethod ]
{
	if ApproveSetDR=$C(0) set ApproveSetDR=""
	if Role=$C(0) set Role=""
	if ActionCode=$C(0) set ActionCode=""  //add by zx 2016-05-12 
	q ##class(web.DHCEQApprove).GetRequiredFields(ApproveSetDR, Role, ActionCode)
}

/// BussType, Name, EquipDR As %String = "", MaintLocDR As %String = "", QXType As %String = ""
/// add by zx 2015-12-17
/// 获取检查计划 Modify By QW20160202 区分计量与检查
ClassMethod GetMaintPlanName(BussType, Name, EquipDR As %String = "", MaintLocDR As %String = "", QXType As %String = "", CurLocID As %String = "", TypeCode As %String = "") As %XML.DataSet [ WebMethod ]
{
	if BussType=$C(0) set BussType=""
	if Name=$C(0) set Name=""
	if EquipDR=$C(0) set EquipDR=""
	if MaintLocDR=$C(0) set MaintLocDR=""
	if QXType=$C(0) set QXType=""
	if CurLocID=$C(0) set CurLocID=""
	if TypeCode=$C(0) set TypeCode=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMaintPlanNew:GetPlanName")
	Do result.SetArgs(BussType, Name, EquipDR, MaintLocDR, QXType, CurLocID,TypeCode)
	Quit result
}

/// add by zx 2015-12-17
/// 获取检查方式
/// 修改query的调用 QW20160129
ClassMethod GetMaintType(para, type, code) As %XML.DataSet [ WebMethod ]
{
	if para=$C(0) set para=""
	if type=$C(0) set type=""
	if code=$C(0) set code=""
	//Set result=##class(%XML.DataSet).%New("web.DHCEQCMaintType:LookUp")
	Set result=##class(%XML.DataSet).%New("web.DHCEQCMaintType:MaintType")
	Do result.SetArgs(code,para,"",type)
	Quit result
}

/// add by zx 2015-12-17
/// 获取计量部门
ClassMethod GetMeasureDept(para) As %XML.DataSet [ WebMethod ]
{
	if para=$C(0) set para=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCMeasureDept:LookUp")
	Do result.SetArgs(para)
	Quit result
}

/// add by zx 2015-12-17
/// 检查信息保存
ClassMethod AddInspect(val, type As %String = "", User As %String = "") As %String [ WebMethod ]
{
	if val=$C(0) set val=""
	if type=$C(0) set type=""
	if User=$C(0) set User=""
	q ##class(web.DHCEQMaintNew).SaveData(val, type, User)
}

/// add by QW20160307
/// 查询检查信息
ClassMethod GetMaintList(BussType As %String = "", CurUser As %String = "", TypeCode As %String = "") As %XML.DataSet [ WebMethod ]
{
	if BussType=$C(0) set BussType=""
	if CurUser=$C(0) set CurUser=""
	if TypeCode=$C(0) set TypeCode=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMaintNew:GetMaint")
	Do result.SetArgs(BussType, "", "","","","","","","",CurUser,TypeCode)
	Quit result
}

/// 检查信息保存
ClassMethod GetOneMaint(RowID As %String = "") As %String [ WebMethod ]
{
	if RowID=$C(0) set RowID=""
    s result=##class(web.DHCEQMaintNew).GetOneMaint(RowID)
	q result_"^"_##class(web.DHCEQMaintForService).GetEquipByEquipNo($p($g(^DHCEQEquip($p(result,"^",1))),"^",71))
}

/// add by zx 2015-12-17
/// 检查信息提交
ClassMethod SubmitInspect(RowID, User As %String = "") As %String [ WebMethod ]
{
	if RowID=$C(0) set RowID=""
	if User=$C(0) set User=""
	q ##class(web.DHCEQMaintNew).SubmitData(RowID, User)
}

/// add by zx 2015-12-18
/// 根据设备id获取维修、租赁业务单信息
ClassMethod GetBusiness(EquipDR) As %XML.DataSet [ WebMethod ]
{
	if EquipDR=$C(0) set EquipDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMove:BusinessList")
	Do result.SetArgs(EquipDR)
	Quit result
}

/// add by zx 2015-12-18
/// 获取用户信息
ClassMethod GetEQUser(type As %String, name As %String = "", loc As %String = "", equiptype As %String = "", manageloc As %String = "") As %XML.DataSet [ WebMethod ]
{
	if type=$C(0) set type=""
	if name=$C(0) set name=""
	if loc=$C(0) set loc=""
	if equiptype=$C(0) set equiptype=""
	if manageloc=$C(0) set manageloc=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQFind:EQUser")
	Do result.SetArgs(type,name,loc,equiptype,manageloc)
	Quit result
}

/// add by zx 2015-12-18
/// 获取存放地点信息
ClassMethod GetLocation(Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Desc=$C(0) set Desc=""
	if HospitalDR=$C(0) set HospitalDR=""
	if LocDR=$C(0) set LocDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCLocation:GetShortLocation")
	Do result.SetArgs(Desc,HospitalDR,LocDR)
	Quit result
}

/// add by zx 2015-12-18
/// 获取生产厂商信息
ClassMethod GetManufacturer(Manufacturer As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Manufacturer=$C(0) set Manufacturer=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCManufacturer:LookUp")
	Do result.SetArgs(Manufacturer)
	Quit result
}

/// add by zx 2015-12-18
/// 获取供应商信息
ClassMethod GetProvider(Provider As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Provider=$C(0) set Provider=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCVendor:GetVendor")
	Do result.SetArgs(Provider)
	Quit result
}

/// add by zx 2015-12-18
/// 获取服务商信息
ClassMethod GetService(para) As %XML.DataSet [ WebMethod ]
{
	if para=$C(0) set para=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCService:LookUp")
	Do result.SetArgs(para)
	Quit result
}

/// add by zx 2015-12-27
/// 检查信息提交
ClassMethod SaveMoveInfo(val, user, frowid, trowid) As %String [ WebMethod ]
{
	if val=$C(0) set val=""
	if user=$C(0) set user=""
	if frowid=$C(0) set frowid=""
	if trowid=$C(0) set trowid=""
	q ##class(web.DHCEQMove).SaveMoveInfo(val, user, frowid, trowid)
}

/// add by zx 2015-12-27
/// 设备移动信息提交
ClassMethod SubitMoveInfo(flag, Rowid, User) As %String [ WebMethod ]
{
	if flag=$C(0) set flag=""
	if Rowid=$C(0) set Rowid=""
	if User=$C(0) set User=""
	q ##class(web.DHCEQMove).SubitMoveInfo(flag, Rowid, User)
}

/// add by zx 2015-12-27
/// 设备移动信息删除
ClassMethod DeleteMoveInfo(Rowid, User, frowid, trowid, InvalidReason) As %String [ WebMethod ]
{
	if Rowid=$C(0) set Rowid=""
	if User=$C(0) set User=""
	if frowid=$C(0) set frowid=""
	if trowid=$C(0) set trowid=""
	if InvalidReason=$C(0) set InvalidReason="" ;Add By QW201600302 增加无效原因
	q ##class(web.DHCEQMove).DeleteMoveInfo(Rowid, User, frowid, trowid,InvalidReason)
}

/// add by zx 2015-12-27
///                     No, EquipName, SourceType, EventType, FromDeptType, FromLocationDR, StartDate, SendUserDR, ToDeptType, ToLocationDR, EndDate, AcceptUserDR, Status, EquipNo
ClassMethod GetMoveList(No, EquipName, SourceType, EventType, FromDeptType, FromLocationDR, StartDate, SendUserDR, ToDeptType, ToLocationDR, EndDate, AcceptUserDR, Status, EquipNo, ObjID, CurUser) As %XML.DataSet [ WebMethod ]
{
	if No=$C(0) set No=""
	if EquipName=$C(0) set EquipName=""
	if SourceType=$C(0) set SourceType=""
	if EventType=$C(0) set EventType=""
	if FromDeptType=$C(0) set FromDeptType=""
	if FromLocationDR=$C(0) set FromLocationDR=""
	if StartDate=$C(0) set StartDate=""
	if SendUserDR=$C(0) set SendUserDR=""
	if ToDeptType=$C(0) set ToDeptType=""
	if ToLocationDR=$C(0) set ToLocationDR=""
	if EndDate=$C(0) set EndDate=""
	if AcceptUserDR=$C(0) set AcceptUserDR=""
	if Status=$C(0) set Status=""
	if EquipNo=$C(0) set EquipNo=""
	if ObjID=$C(0) set ObjID=""
	if CurUser=$C(0) set CurUser=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMove:MoveList")
	Do result.SetArgs(No, EquipName, SourceType, EventType, FromDeptType, FromLocationDR, StartDate, SendUserDR, ToDeptType, ToLocationDR, EndDate, AcceptUserDR, Status, EquipNo, ObjID,CurUser)
	Quit result
}

/// add by zx 2015-12-27
/// 设备移动信息获取
ClassMethod GetMoveInfo(rowid) As %String [ WebMethod ]
{
	if rowid=$C(0) set rowid=""
	q ##class(web.DHCEQMove).GetMoveInfo(rowid)
}

/// add by zx 2016-01-10
/// 设备移动人员更新
ClassMethod SaveMoveUser(RowID, MoveDR, UserDR, Remark) As %String [ WebMethod ]
{
	if RowID=$C(0) set RowID=""
	if MoveDR=$C(0) set MoveDR=""
	if UserDR=$C(0) set UserDR=""
	if Remark=$C(0) set Remark=""
	q ##class(web.DHCEQMove).SaveMoveUser(RowID, MoveDR, UserDR, Remark)
}

/// add by zx 2015-12-27
///                     
ClassMethod GetMoveUser(MoveDR) As %XML.DataSet [ WebMethod ]
{
	if MoveDR=$C(0) set MoveDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMove:MoveUser")
	Do result.SetArgs(MoveDR)
	Quit result
}

/// w ##Class(web.DHCEQMove).CreatMoveInfo()
/// add by QW 20160215
/// 在送出的基础上生成送回
ClassMethod CreatMoveInfo(rowid, user) As %String [ WebMethod ]
{
	if rowid=$C(0) set rowid=""
	if user=$C(0) set user=""
	s tmpid=##Class(web.DHCEQMove).CheckMoveUnqIdx(rowid)
	if tmpid'="" q 0
	q ##class(web.DHCEQMove).CreatMoveInfo(rowid, user,"","")
}

/*ClassMethod GetCertificateInfo(SourceID) As %XML.DataSet [ WebMethod ]
{
	if SourceID=$C(0) set SourceID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCertificateInfoNew:GetCertificateInfoList")
	Do result.SetArgs(SourceID)
	Quit result
}
*/

//Modified by HHM 2016-04-07 修改获取计量号信息

/// add by QW 20160215
/// 获取证书信息
ClassMethod GetCertificate(SourceID) As %String [ WebMethod ]
{
	i SourceID=$c(0) s SourceID=""
	q ##Class(web.DHCEQCertificateInfo).GetInfoByMobile(SourceID)
}

/// add by QW 20160316
/// 移动端转移单新增
ClassMethod SaveStoreMove(val, valList, DelRowid)
{
	if val=$C(0) set val=""
	if valList=$C(0) set valList=""
	if DelRowid=$C(0) set DelRowid=""
	q ##class(web.DHCEQStoreMoveNew).SaveData(val, valList, DelRowid)
}

/// add by zx 2016-04-17
/// 获取审批流类型   
/// modified By qw 20170929 需求号:458987 新增参数ActionCode                 
ClassMethod GetApproveFlowType(SourceID, CurRoleID, ApporveTypeCode, Type, RoleStep, ActionCode As %String = "") As %String [ WebMethod ]
{
	if SourceID=$C(0) set SourceID=""
	if CurRoleID=$C(0) set CurRoleID=""
	if ApporveTypeCode=$C(0) set ApporveTypeCode=""
	if Type=$C(0) set Type=""
	if RoleStep=$C(0) set RoleStep=""
	if ActionCode=$C(0) set ActionCode=""
	q ##class(web.DHCEQCApproveFlow).GetApproveFlowType(SourceID, CurRoleID, ApporveTypeCode, Type, RoleStep,ActionCode)
}

/// add by zx 2016-04-17
/// 获取可转向步奏 
/// modified By qw 20170929 需求号:458987 新增参数Action                    
ClassMethod GetUserApproves(SourceID As %String, CurRoleDR As %String, ApproveTypeCode As %String, Type As %String, CurStep As %String, Action As %String = "") As %XML.DataSet [ WebMethod ]
{
	if SourceID=$C(0) set SourceID=""
	if CurRoleDR=$C(0) set CurRoleDR=""
	if ApproveTypeCode=$C(0) set ApproveTypeCode=""
	if Type=$C(0) set Type=""
	if CurStep=$C(0) set CurStep=""
	if Action=$C(0) set Action=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCApproveFlow:GetUserApprovesForPDA")
	Do result.SetArgs(SourceID, CurRoleDR, ApproveTypeCode, Type, CurStep,Action)
	Quit result
}

/*
/// add by zx 2016-04-18
/// 工作台消息                     
ClassMethod GetBussByRole(MeunType As %String = "", GroupID As %String = "", UserID As %String = "") As %XML.DataSet [ WebMethod ]
{
	if MeunType=$C(0) set MeunType=""
	if GroupID=$C(0) set GroupID=""
	if UserID=$C(0) set UserID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCRoleBuss:GetBussByRole")
	Do result.SetArgs(MeunType,GroupID,UserID)
	Quit result
}
*/
/// add by zx 2016-04-18
/// 工作台消息                     
ClassMethod GetBussDataForPDA(GroupID As %String = "", UserID As %String = "") As %XML.DataSet [ WebMethod ]
{
	if GroupID=$C(0) set GroupID=""
	if UserID=$C(0) set UserID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMessages:GetBussDataForPDA")
	Do result.SetArgs(GroupID,UserID)
	Quit result
}

/// add by zx 2016-05-21
/// 审批进度
ClassMethod GetApproveInfo(BussType, SourceID) As %XML.DataSet [ WebMethod ]
{
	if BussType=$C(0) set BussType=""
	if SourceID=$C(0) set SourceID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMessages:GetApproveInfo")
	Do result.SetArgs(BussType,SourceID)
	Quit result
}

/// add by zx 2016-06-16
/// 设备租赁判断是否在租赁中心                    
ClassMethod GetEquipRentByEquip(Desc As %String = "", StoreLocDR As %String = "", ItemDR As %String = "", ModelDR As %String = "", CurRowID As %String = "", ActionCode As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Desc=$C(0) set Desc=""
	if StoreLocDR=$C(0) set StoreLocDR=""
	if ItemDR=$C(0) set ItemDR=""
	if ModelDR=$C(0) set ModelDR=""
	if CurRowID=$C(0) set CurRowID=""
	if ActionCode=$C(0) set ActionCode=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQEquipRent:GetEquipRentByEquip")
	Do result.SetArgs(Desc,StoreLocDR,ItemDR,ModelDR,CurRowID,ActionCode)
	Quit result
}

/// add by zx 2016-06-16
/// 租赁设备更新提交操作
ClassMethod SaveRent(val, type, Action As %String = "", User As %String = "") As %String [ WebMethod ]
{
	if val=$C(0) set val=""
	if type=$C(0) set type=""
	if Action=$C(0) set Action=""
	if User=$C(0) set User=""
	q ##Class(web.DHCEQRent).SaveData(val, type, Action, User)
}

/// add by zx 2016-06-17
/// 获取租赁单据信息
ClassMethod GetRentList(QXType As %String = "", vQXType As %String = "", Type As %String = "", RequestLocDR As %String = "", FromLocDR As %String = "", ItemDR As %String = "", StatusDR As %String = "", BeginDate As %String = "", EndDate As %String = "", RequestNo As %String = "", EquipType As %String = "", ApproveRole As %String = "", Action As %String = "", EquipDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if QXType=$C(0) set QXType=""
	if vQXType=$C(0) set vQXType=""
	if Type=$C(0) set Type=""
	if RequestLocDR=$C(0) set RequestLocDR=""
	if FromLocDR=$C(0) set FromLocDR=""
	if ItemDR=$C(0) set ItemDR=""
	if StatusDR=$C(0) set StatusDR=""
	if BeginDate=$C(0) set BeginDate=""
	if EndDate=$C(0) set EndDate=""
	if RequestNo=$C(0) set RequestNo=""
	if EquipType=$C(0) set EquipType=""
	if ApproveRole=$C(0) set ApproveRole=""
	if Action=$C(0) set Action=""
	if EquipDR=$C(0) set EquipDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQRent:GetRentList")
	Do result.SetArgs(QXType,vQXType,Type,RequestLocDR,FromLocDR,ItemDR,StatusDR,BeginDate,EndDate,RequestNo,EquipType,ApproveRole,Action,EquipDR)
	Quit result
}

/// add by zx 2016-06-17
/// 获取租赁单信息
ClassMethod GetRentByID(rowid As %Library.String = "", ApproveRoleDR As %Library.String) As %String [ WebMethod ]
{
	if rowid=$C(0) set rowid=""
	if ApproveRoleDR=$C(0) set ApproveRoleDR=""
	q ##Class(web.DHCEQRent).GetRentByID(rowid, ApproveRoleDR)
}

/// add by zx 2016-06-20
/// 判断租赁设备是否被其他单据占用
ClassMethod GetEquipUsedInfo(EquipDR, vRowID, vActionCode) As %String [ WebMethod ]
{
	if EquipDR=$C(0) set EquipDR=""
	if vRowID=$C(0) set vRowID=""
	if vActionCode=$C(0) set vActionCode=""
	q ##Class(web.DHCEQEquipRent).GetEquipUsedInfo(EquipDR, vRowID, vActionCode)
}

/// add by qw 2017-03-09
/// 获取维修消息列表
/// modified by qw 2017-11-03 新增参数CurLocDR 
ClassMethod GetBussDataByCode(BussType As %String = "", GroupID As %String = "", UserID As %String = "", CurLocDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if BussType=$C(0) set BussType=""
	if GroupID=$C(0) set GroupID=""
	if UserID=$C(0) set UserID=""
	;s ^DHCEQTemp("QW","GetBussDataByCode")=UserID_"^"_GroupID_"^"_BussType
	Set result=##class(%XML.DataSet).%New("web.DHCEQMessages:GetBussDataByCode")
	Do result.SetArgs(BussType, GroupID, UserID,CurLocDR)
	Quit result
}

/// add by qw 2017-03-09
/// 获取维修紧急程度
ClassMethod EmergencyLevel() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCEmergencyLevel:EmergencyLevel")
	Do result.SetArgs("","","","")
	Quit result
}

/// add by qw 2017-03-09
/// 获取维修严重程度
ClassMethod SeverityLevel() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQM.DHCEQMCSeverityLevel:SeverityLevel")
	Do result.SetArgs("","","","")
	Quit result
}

/// add by qw 2017-03-09
/// 获取维修组人员
/// modified By qw 20170929 需求号:458986 新增参数MaintGroupDR
ClassMethod GetMaintGroupList(mInput As %String = "", UserID As %String = "", MaintGroupDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if mInput=$C(0) set mInput=""
	if UserID=$C(0) set UserID=""
	if MaintGroupDR=$C(0) set MaintGroupDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQMCMaintGroupList:GetMaintGroupList")
	Do result.SetArgs(mInput,MaintGroupDR,"",UserID)
	Quit result
}

/// add by qw 2017-03-09
/// 获取维修组
ClassMethod MaintGroup(Desc As %String = "", UserDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if Desc=$C(0) set Desc=""
	if UserDR=$C(0) set UserDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQFind:MaintGroup")
	Do result.SetArgs("1",Desc,UserDR)
	Quit result
}

/// add by qw 2017-03-09
/// 获取配件类组
ClassMethod GetAccessoryType(GroupID As %String = "") As %XML.DataSet [ WebMethod ]
{
	if GroupID=$C(0) set GroupID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQFind:GetAccessoryType")
	Do result.SetArgs("",GroupID)
	Quit result
}

/// add by qw 2017-03-09
/// 获取配件
ClassMethod GetOneMaintPart(rowid) As %String [ WebMethod ]
{
		i rowid=$c(0) s rowid=""
		Set result= ##class(web.DHCEQM.DHCEQMMaintPart).GetOneMaintPart("","",rowid)
		Quit result
}

/// add by qw 2017-03-09
/// 提交配件
ClassMethod SubmitManage(rowid, LocID, UserID) As %String [ WebMethod ]
{
		i rowid=$c(0) s rowid=""
		i LocID=$c(0) s LocID=""
		i UserID=$c(0) s UserID=""
		Set result= ##class(web.DHCEQM.DHCEQMMaintPart).SubmitManage(rowid,LocID,UserID)
		Quit result
}

/// add by qw 2017-03-09
/// 取消提交配件
ClassMethod CancelManage(rowid) As %String [ WebMethod ]
{
	
		i rowid=$c(0) s rowid=""
		Set result= ##class(web.DHCEQM.DHCEQMMaintPart).CancelManage(rowid,"")
		Quit result
}

/// add by QW20171011 需求号:458190
/// 获取租赁中心科室ID
ClassMethod GetFirstIDByLoc() As %String [ WebMethod ]
{
		s RentLocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0301","")
		s RentLoc=##Class(web.DHCEQCommon).GetFirstIDByLocType("0301","Y")
		s result=RentLocDR_"^"_RentLoc
		Quit result
}

}
