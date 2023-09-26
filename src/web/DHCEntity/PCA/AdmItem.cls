/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:就诊信息类
Class web.DHCEntity.PCA.AdmItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// AdmRowID
Property AdmRowid As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊科室
Property AdmLoc As %String(TRUNCATE = 1);

/// 就诊医生
Property AdmDoctor As %String(TRUNCATE = 1);

/// YBUploadFlag	医保上传标志
Property YBUploadFlag As %String(TRUNCATE = 1);

/// YBUploadData	医保上传数据
Property YBUploadData As %String(TRUNCATE = 1);

}
