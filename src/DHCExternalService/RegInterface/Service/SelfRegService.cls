/// DHCExternalService.RegInterface.Service.SelfRegService
Class DHCExternalService.RegInterface.Service.SelfRegService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Parameter LOCATION = "http://172.19.19.57/DTHealth/web/";
/// Name of the WebService.
Parameter SERVICENAME = "SelfRegService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: 获取病人基本信息
Method GetPatInfo(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatInfo(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 获取患者社会地位对应的可挂号费别
Method GetPatBillType(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatBillType(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 得到一级科室列表
Method QueryDepartmentGroup(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDepartmentGroup(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 得到二级科室列表
Method QueryDepartment(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDepartment(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 得到医生列表
Method QueryDoctor(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryDoctor(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 查询排班记录
Method QueryAdmSchedule(XMLRequest As %String, SeachType As %String = "") As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryAdmSchedule(XMLRequest,SeachType)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 医生号源分时信息查询(His具有分时段挂号功能可使用此接口)
Method QueryScheduleTimeInfo(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryScheduleTimeInfo(XMLRequest)
	;QueryScheduleTimeInfoNew接口,因为某些第三方需要将非分时段的排班也查询出来,该接口适用此需求
	;set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryScheduleTimeInfoNew(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO:锁号(交易代码10015)
Method LockOrder(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).LockOrder(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO:取消锁号(交易代码10016)
Method UnLockOrder(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).UnLockOrder(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO:患者就诊介质查询
Method QueryPatCard(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryPatCard(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 挂号、提前挂号
Method OPRegister(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegister(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 获取直接挂号的排班出诊信息(不受号源限制)
Method GetOPRapidRegistAS(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).GetOPRapidRegistAS(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 直接挂号(不受号源限制)
Method OPRapidRegist(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRapidRegist(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 查询挂号记录
Method QueryAdmOPReg(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryAdmOPReg(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 获取医保挂号HIS信息,此方法会随医院医保业务流程变化
Method GetInsuRegPara(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).GetInsuRegPara(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: his退号
Method OPRegReturn(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).OPRegReturn(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 查询病人候诊排队信息
Method QueryPatAdmList(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryPatList(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 预约
Method BookService(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).BookService(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 查询预约取号列表(含有卡取号:卡号必填,无卡取号:身份证必填;标识节点区分有卡,无卡)
Method QueryOrder(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryOPAppArriveList(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 预约取号
Method OPAppArrive(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).OPAppArrive(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 预约挂号系统取消确定预约HIS中资源
Method CancelOrder(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).CancelOrder(Input)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 停诊医生信息查询
Method QueryStopDoctorInfo(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryStopDoctorInfo(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 预约挂号状态回查接口，该接口用于网络或程序处理超时后获取预约记录状态
Method QueryRegStatus(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).QueryRegStatus(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: 实现自费挂号转医保挂号_方法核心为计费接口，标板暂缺少计费方法
Method ChangeRegFeeToInsu(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set rtn=##class(DHCExternalService.RegInterface.SelfRegMethods).ChangeRegFeeToInsu(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// TODO: webservice网络测试
Method NetTest(RequestStr As %String) As %String [ WebMethod ]
{
	quit ##class(DHCExternalService.RegInterface.SelfRegMethods).NetTest(RequestStr)
}

/*
---------------------------卡相关集成接口-----------------------------------
为方便接口平台使用一个内部地址做服务代理,将注册建卡相关接口添加到此类,调用的还是卡管理类下的方法
*/
/// TODO: 病人发卡判断
Method FindPatientCard(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).FindPatientCard(Input)
	d RtnObj.XMLExportToStream(.OutputStream,"Response")
	q OutputStream
}

/// TODO: 发卡
Method SavePatientCard(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	set RtnObj=##class(DHCExternalService.CardInterface.CardManager).SavePatientCard(Input)
	do RtnObj.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

/// 更新病人信息
Method UpdatePatInfo(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).UpdatePatInfo(Input)
	d RtnObj.XMLExportToStream(.RtnXml,"Response")
	q RtnXml
}

/// 补卡接口
Method CardReissue(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s RtnObj=##class(DHCExternalService.CardInterface.CardManager).PartientCardReissue(Input)
	d RtnObj.XMLExportToStream(.RtnXml,"Response")
	q RtnXml
}

}
