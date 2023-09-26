Class web.DHCST.SoapModel.AdrReport Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "sBusinessData";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 报告编码
Property ADRRCode As %String(TRUNCATE = 1);

/// 报告日期
Property ADRRDate As %String(TRUNCATE = 1);

/// 报告名称
Property ADRRName As %String(TRUNCATE = 1);

/// 首次报告
Property ADRRPriority As %String(TRUNCATE = 1);

/// 首次报告代码
Property ADRRPriorityCode As %String(TRUNCATE = 1);

/// 报告类型
Property ADRRRepType As %String(TRUNCATE = 1);

/// 报告类型代码
Property ADRRRepTypeCode As %String(TRUNCATE = 1);

/// 报告单位类型
Property ADRRDeptType As %String(TRUNCATE = 1);

/// 报告单位类型代码
Property ADRRDeptTypeCode As %String(TRUNCATE = 1);

/// 报告单位其它类型描述
Property ADRRDeptElse As %String(TRUNCATE = 1);

/// 患者姓名
Property ADRRPatName As %String(TRUNCATE = 1);

/// 性别
Property ADRRPatSex As %String(TRUNCATE = 1);

/// 性别代码
Property ADRRPatSexCode As %String(TRUNCATE = 1);

/// 年龄
Property ADRRPatAge As %String(TRUNCATE = 1);

/// 出生日期
Property ADRRPatDOB As %String(TRUNCATE = 1);

/// 民族
Property ADRRPatNation As %String(TRUNCATE = 1);

/// 民族代码
Property ADRRPatNationCode As %String(TRUNCATE = 1);

/// 体重
Property ADRRPatWeight As %String(TRUNCATE = 1);

/// 联系方式
Property ADRRPatContact As %String(TRUNCATE = 1);

/// 病历号
Property ADRRPatMedNo As %String(TRUNCATE = 1);

/// 既往药品不良反应事件
Property ADRREventHistory As %String(TRUNCATE = 1);

/// 既往药品不良反应事件代码
Property ADRREventHistoryCode As %String(TRUNCATE = 1);

/// 既往药品不良反应事件
Property ADRREventHistDesc As %String(TRUNCATE = 1);

/// 家族药品不良反应事件
Property ADRREventFamily As %String(TRUNCATE = 1);

/// 家族药品不良反应事件代码
Property ADRREventFamilyCode As %String(TRUNCATE = 1);

/// 家族药品不良反应事件
Property ADRREventFamiDesc As %String(TRUNCATE = 1);

/// 事件发生日期
Property ADRRDateOccu As %String(TRUNCATE = 1);

/// 事件的结果
Property ADRRResult As %String(TRUNCATE = 1);

/// 事件的结果代码
Property ADRRResultCode As %String(TRUNCATE = 1);

/// 事件的结果描述
Property ADRRResultDesc As %String(TRUNCATE = 1);

/// 好转(死亡)日期
Property ADRRDateResult As %String(TRUNCATE = 1);

/// 好转(死亡)时间
Property ADRRTimeResult As %String(TRUNCATE = 1);

/// 停药后是否减轻
Property ADRRStopResult As %String(TRUNCATE = 1);

/// 停药后是否减轻代码
Property ADRRStopResultCode As %String(TRUNCATE = 1);

/// 再次使用时是否再次出现同样反应
Property ADRRTakingAgain As %String(TRUNCATE = 1);

/// 再次使用时是否再次出现同样反应代码
Property ADRRTakingAgainCode As %String(TRUNCATE = 1);

/// 对原疾病的影响
Property ADRREffectOfTreatment As %String(TRUNCATE = 1);

/// 对原疾病的影响代码
Property ADRREffectOfTreatmentCode As %String(TRUNCATE = 1);

/// 关联性评价之报告人评价
Property ADRRCommentOfUser As %String(TRUNCATE = 1);

/// 关联性评价之报告人评价代码
Property ADRRCommentOfUserCode As %String(TRUNCATE = 1);

/// 报告人评价签字
Property ADRRUserOfReport As %String(TRUNCATE = 1);

/// 报告人评价签字代码
Property ADRRUserOfReportCode As %String(TRUNCATE = 1);

/// 关联性评价之报告单位评价
Property ADRRCommentOfDept As %String(TRUNCATE = 1);

/// 关联性评价之报告单位评价代码
Property ADRRCommentOfDeptCode As %String(TRUNCATE = 1);

/// 报告单位评价签字
Property ADRRDeptOfReport As %String(TRUNCATE = 1);

/// 报告人联系电话
Property ADRRTelephone As %String(TRUNCATE = 1);

/// 报告人职业
Property ADRRCareerOfRepUser As %String(TRUNCATE = 1);

/// 报告人职业代码
Property ADRRCareerOfRepUserCode As %String(TRUNCATE = 1);

/// 报告人职业
Property ADRRCareerOfRepElse As %String(TRUNCATE = 1);

/// 报告人邮箱
Property ADRREmailOfRepUser As %String(TRUNCATE = 1);

/// 报告人所属科室
Property ADRRLocOfReporter As %String(TRUNCATE = 1);

/// 报告人所属科室代码
Property ADRRLocOfReporterCode As %String(TRUNCATE = 1);

/// 报告人职称
Property ADRRProTitleOfReporter As %String(TRUNCATE = 1);

/// 报告人职称代码
Property ADRRProTitleOfReporterCode As %String(TRUNCATE = 1);

/// 报告人职务
Property ADRRPosOfReporter As %String(TRUNCATE = 1);

/// 填报意愿
Property ADRRWishes As %String(TRUNCATE = 1);

/// 填报意愿代码
Property ADRRWishesCode As %String(TRUNCATE = 1);

/// 报告单位名称
Property ADRRDeptName As %String(TRUNCATE = 1);

/// 报告单位联系人
Property ADRRDeptContacts As %String(TRUNCATE = 1);

/// 报告单位联系电话
Property ADRRDeptTel As %String(TRUNCATE = 1);

/// 备注
Property ADRRRemark As %String(TRUNCATE = 1);

/// 重要信息
Property PatImpo As list Of web.DHCST.SoapModel.AdrRepImpInfo(XMLPROJECTION = "ELEMENT");

/// 诊断
Property Diag As list Of web.DHCST.SoapModel.AdrRepDiag(XMLPROJECTION = "ELEMENT");

/// 事件
Property Event As list Of web.DHCST.SoapModel.AdrRepEvent(XMLPROJECTION = "ELEMENT");

/// 过程描述
Property Proc As list Of web.DHCST.SoapModel.AdrRepProc(XMLPROJECTION = "ELEMENT");

/// 药品项
Property Drugs As list Of web.DHCST.SoapModel.AdrRepDrugItm(XMLPROJECTION = "ELEMENT");

}
