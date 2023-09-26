Class web.Entity.CT.CTLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLoc";

Property CTLOCRowID As %String;

/// 代码
Property CTLOCCode As %String;

/// 描述
Property CTLOCDesc As %String;

/// 地址
Property CTLOCAddress As %String;

/// 楼层
Property CTLOCFloor As %String;

/// 性别
Property CTLOCWardSingleSex As %String;

/// 开始年龄
Property CTLOCAgeFrom As %String;

/// 截止年龄
Property CTLOCAgeTo As %String;

/// 科室类型
Property CTLOCType As %String;

/// 部门组
Property CTLOCDepDR As %String;

/// 科主任
Property CTLOCDepartmentHeadUserDR As %String;

/// 医嘱索引 Y/N
Property CTLOCIndex As %String;

/// 在此科室病历可用
Property CTLOCMedicalRecordActive As %String;

/// 允许无收治限制
Property CTLOCAllowNoCureLimit As %String;

/// 是否住院总签床
Property CTLOCBeInHospital As %String;

/// 医院
Property CTLOCHospitalDR As %String;

/// 医嘱执行确认 Y/N
Property CTLOCExecuteConfirmation As %String;

/// 生效日期
Property CTLOCDateActiveFrom As %String;

/// 截止日期
Property CTLOCDateActiveTo As %String;

/// 科室检索码
Property CTLOCContactName As %String;

/// 指向科室多层分类
Property CTLOCCategoryDR As %String;

/// 表名称：//----------PAC_Ward -------------//
Property WARDSingleRoom As %String;

Property WARDActive As %String;

Property WARDViewLinkedRooms As %String;

Property WARDViewNextMostUrgent As %String;

Property WARDInactiveDateFrom As %String;

Property WARDInactiveDateTo As %String;

/// 预住院病区
Property WARDBeforehand As %String;

/// 科室分类 - 病人类型
Property OutPatient As %String;

Property InPatient As %String;

Property Emergency As %String;

Property HealthPromotion As %String;

/// 作为接收科室时能接收的就诊类型
Property CTLOCClinicType As %String;

/// 病人位置分组
Property CTLOCBroadPatientGroupDR As %String;

/// 联系电话
Property CTLOCTelephone As %String;

/// 检验条码科室简称
Property CTLOCNationCode As %String;

/// 是否有效(Y/N)
Property CTLOCActiveFlag As %String;

/// 组织外码-外键
Property CTLOCDeptCode As %String;

/// 业务域代码-外键
Property CTLOCDomainCode As %String;

/// 物理位置
Property CTLOCLocation As %String;

/// 系统创建日期
Property CTLOCCreateDate As %String;

/// 系统创建时间
Property CTLOCCreateTime As %String;

/// 系统创建人
Property CTLOCCreateUser As %String;

/// 系统排序号
Property CTLOCSeqNo As %String;

/// 系统最后更新日期
Property CTLOCLastUpdateDate As %String;

/// 系统最后更新时间
Property CTLOCLastUpdateTime As %String;

/// 系统最新更新人
Property CTLOCLastUpdateUser As %String;

/// 拼音码
Property CTLOCPYCode As %String;

/// 五笔码
Property CTLOCWBCode As %String;

/// 备注
Property CTLOCMark As %String;

}
