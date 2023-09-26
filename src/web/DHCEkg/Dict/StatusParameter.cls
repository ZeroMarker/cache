/// Creator：      yangyali
/// CreatDate：    2021-11-24
/// Description:   与平台接口交互，检查状态回传接口，状态信息字典
Class web.DHCEkg.Dict.StatusParameter Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "StatusParameter";

/// 患者登记号
Property PATPatientID As %String;

/// 患者就诊号
Property PAADMVisitNumber As %String;

/// 医嘱id
Property OEORIOrderItemID As %String;

/// 医嘱执行记录id
Property OEORIOrdExecID As %String;

/// 检验条码号/标本号
Property SpecimenID As %String;

/// 检查号
Property RISRExamID As %String;

/// 系统类型
Property RISRSystemType As %String;

/// 检查部位
Property Position As %String;

/// 手术申请id
Property OperAppID As %String;

/// 输血申请id
Property BloodAppID As %String;

/// 用血血袋号
Property BloodBagNo As %String;

/// 会诊申请id
Property ConsultAppID As %String;

/// 状态代码
Property StatusCode As %String;

/// 是否取消检查
Property Uncheck As %String;

/// 更新人工号
Property UpdateUserCode As %String;

/// 更新人姓名
Property UpdateUserName As %String;

/// 更新日期时间
Property UpdateDateTime As %String;

}
