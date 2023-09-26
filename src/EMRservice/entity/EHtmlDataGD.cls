/// 名称：		EMRservice.entity.EHtmlDataGD
/// 描述：		HTML传输对象
/// 编写者：	yejian
/// 编写时间：	2020-3-10
Class EMRservice.entity.EHtmlDataGD Extends (%RegisteredObject, %XML.Adaptor)
{

/// 就诊类型（住院：I，门诊：0）
Property admType As %String(TRUNCATE = 1);

/// 患者编号
Property patientid As %String(TRUNCATE = 1);

/// 住院就诊编号（住院）
Property inpatid As %String(TRUNCATE = 1);

/// 住院就诊编号（门诊）
Property regid As %String(TRUNCATE = 1);

/// HTML名称
Property sourcerecordid As %String(TRUNCATE = 1);

/// 病历名称
Property patientname As %String(TRUNCATE = 1);

/// 年龄
Property age As %String(TRUNCATE = 1);

/// 年龄单位(岁、月、日)
Property ageunit As %String(TRUNCATE = 1);

/// 年龄换算
Property ageday As %String(TRUNCATE = 1);

/// 科室代码
Property deptcode As %String(TRUNCATE = 1);

/// 病人所在科室名称
Property deptname As %String(TRUNCATE = 1);

/// 病区代码
Property wardcode As %String(TRUNCATE = 1);

/// 病人所在病区名称
Property wardname As %String(TRUNCATE = 1);

/// 文书类型代码
Property recordtypecode As %String(TRUNCATE = 1);

/// 文书类型名称
Property recordtypename As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文书标题
Property recordtitle As %String(TRUNCATE = 1);

/// 原始xml内容
Property originalxmlcontent As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRHtmlDataStream($J)");

/// 原始html内容
Property originalhtmlcontent As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRHtmlDataStream($J)");

/// 原始txt内容
Property originaltxtcontent As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRHtmlDataStream($J)");

/// 原始其他格式内容
Property originalothercontent As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRHtmlDataStream($J)");

/// 原始其他格式内容（0-无标准化，1-章节标准化，2-元素标准化）
Property stdflag As %String(TRUNCATE = 1);

/// 标准的文书内容
Property stdcontent As %String(TRUNCATE = 1);

/// 文书调阅地址
Property weburl As %String(MAXLEN = 200, TRUNCATE = 1);

/// pdf调阅地址
Property pdfurl As %String(MAXLEN = 100, TRUNCATE = 1);

/// 记录时间
Property recordtime As %String(TRUNCATE = 1);

/// 文书创建人编号
Property createid As %String(TRUNCATE = 1);

/// 创建代码
Property createcode As %String(TRUNCATE = 1);

/// 文书创建人姓名
Property createname As %String(TRUNCATE = 1);

/// 建档时间
Property createtime As %String(TRUNCATE = 1);

/// 是否有效
Property isvalid As %String(TRUNCATE = 1);

/// 病历显示类型（0 html,1 xml,2 text,3 pdf）
Property emrshowtype As %String(TRUNCATE = 1);

/// 源系统最后更新时间
Property lastopertime As %String(TRUNCATE = 1);

/// 主诉结构化标志
Property nlpflagzs As %String(TRUNCATE = 1);

/// 现病史结化标志
Property nlpflagxbs As %String(TRUNCATE = 1);

/// 既往史结构化标志
Property nlpflagjws As %String(TRUNCATE = 1);

/// 体格检查结构化标志
Property nlpflagtgjc As %String(TRUNCATE = 1);

/// 结构化标志（门诊）
Property nlpflag As %String(TRUNCATE = 1);

/// 结构化调用标志（门诊）
Property nlpnote As %String(TRUNCATE = 1);

/// 操作时间
Property opertime As %String(TRUNCATE = 1);

/// 病历状态编号（住院）
Property inprecstateid As %String(TRUNCATE = 1);

/// 病历状态代码（住院）
Property inprecstatecode As %String(TRUNCATE = 1);

/// 病历状态名称（住院）
Property inprecstatename As %String(TRUNCATE = 1);

/// 病历状态编号（门诊）
Property outrecstateid As %String(TRUNCATE = 1);

/// 病历状态代码（门诊）
Property outrecstatecode As %String(TRUNCATE = 1);

/// 病历状态名称（门诊）
Property outrecstatename As %String(TRUNCATE = 1);

/// 跳转显示类型（门诊）
Property linkshowtype As %String(TRUNCATE = 1);

/// 病人基本信息编号
Property patbaseid As %String(TRUNCATE = 1);

}
