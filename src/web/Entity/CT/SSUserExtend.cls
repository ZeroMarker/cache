/// 名称:用户信息扩展表实体类
/// 编写者:基础数据平台组 - ybq
/// 编写日期:2019-1-8
Class web.Entity.CT.SSUserExtend Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSUserExtend";

/// RowId
Property SSUSRERowId As %String;

/// 出生日期
Property SSUSREBirthday As %String;

/// 国籍
Property SSUSRECountryDR As %String;

/// 民族
Property SSUSRENationDR As %String;

/// 婚姻状况
Property SSUSREMaritalDR As %String;

/// 学历
Property SSUSREEducationDR As %String;

/// 联系地址
Property SSUSREAddress As %String;

/// 政治面貌
Property SSUSREPoliticalStatus As %String;

/// 职工简介
Property SSUSREIntroduction As %String;

/// 图片
Property SSUSREImg As web.BDP.sys.String;

/// 图片偏转角度
Property SSUSREImgOrientation As %String;

/// 职工号
Property SSUSRESerialNo As %String;

/// 证书编码
Property SSUSRECertificateNo As %String;

Property SSUSREText1 As %String;

Property SSUSREText2 As %String;

/// 职工特长
Property SSUSRESpeciality As %String;

Property SSUSREFlag1 As %String;

Property SSUSREFlag2 As %String;

/// 性别 2019-12-03
Property SSUSRESexDR As %String;

/// mulpracflag	多点执业标志
Property SSUSREMulpracFlag As %String;

/// mainpracinsflag	主执业机构标志
Property SSUSREMainpracinsFlag As %String;

/// hiservtype	医疗服务类型
Property SSUSREHiServType As %String;

/// begndate	医疗服务开始时间
Property SSUSREBeginDate As %String;

/// dr_prac_type	医师执业类别
Property SSUSREDrPracType As %String;

/// dr_pro_tech_duty	医师专业技术职务
Property SSUSREDrProTechDuty As %String;

/// dr_prac_scp_code	医师执业范围代码
Property SSUSREDrPracScpCode As %String;

/// pro_code	专业编号
Property SSUSREProCode As %String;

/// dcl_prof_flag	是否申报为本市专家库成员
Property SSUSREDclProfFlag As %String;

/// practice_code	医师执业情况
Property SSUSREPracticeCode As %String;

/// dr_profttl_code	医师职称编号
Property SSUSREDrProfttlCode As %String;

/// bind_flag	定岗标志
Property SSUSREBindFlag As %String;

/// siprof_flag	是否医保专家库成员
Property SSUSRESiprofFlag As %String;

/// loclprof_flag	是否本地申报专家
Property SSUSRELoclprofFlag As %String;

/// hi_dr_flag	是否医保医师
Property SSUSREHiDrFlag As %String;

/// cert_type	证件类型
Property SSUSRECertType As %String;

/// certno	证件号码
Property SSUSRECertno As %String;

/// 出生地
Property SSUSREBirthplace As %String;

}
