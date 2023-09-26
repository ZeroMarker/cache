/// 名称:	EMR.DOC.DTO.Lock
/// 描述:	病历锁对象
/// 编写者：yejian
/// 编写日期: 2023-5-8
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.Lock Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowID
Property ID As %String;

/// 实例ID
Property DocumentID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 业务活动记录分类编码
Property DOCCategoryCode As %String(TRUNCATE = 0);

/// 业务活动记录编码(标题代码)
Property DOCCode As %String(TRUNCATE = 0);

/// 模板ID
Property TemplateID As %String;

/// 锁定日期
Property LockDate As %Date;

/// 锁定日间
Property LockTime As %Time;

/// 用户ID
Property UserID As %String;

/// 用户名
Property UserName As %String;

/// 用户科室ID
Property UserLocID As %String;

/// 计算机IP
Property ComputerIP As %String;

/// 计算机名ComputerName
Property ComputerName As %String;

/// session(关闭浏览器)
Property SessionID As %String;

/// 项目标识（OP 门诊，IP 住院）
Property Product As %String;

/// 加载时病历状态 （created/saved）
Property PStatus As %String;

/// 加载时病历修改日期
Property PModifyDate As %Date;

/// 加载时病历修改时间
Property PModifyTime As %Time;

/// 病历名称
Property DocName As %String;

/// 返回分页开始页号
Property StartPage As %String(TRUNCATE = 1);

/// 返回分页结束页号
Property EndPage As %String(TRUNCATE = 1);

/// 就诊类型（住院 IP，门诊 OP，急诊 EP,空 查所有）
Property Type As %String;

/// 语言ID
Property LangID As %String;

}
