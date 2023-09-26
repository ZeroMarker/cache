Class web.INSUDIAGsInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "root";

//此对象节点名称,可根据实际实际情况修改

//注意：如果有XMLNAME属性，生成XML或XML转为本对象时以XMLNAME名称为准,

//就诊号

Property PAADM As %String(CONTENT = "就诊号");

//住院号

Property PatMedID As %String(CONTENT = "住院号");

//诊断明细表ID

Property MRCRowid As %String(CONTENT = "诊断明细表ID", XMLNAME = "Rowid", XMLPROJECTION = "ELEMENT");

//MRCId 

Property MRCId As %String(CONTENT = "诊断序号");

//诊断类型(预期诊断,入院诊断,出院诊断,主诊断等)

Property MRCType As %String(CONTENT = "诊断类型");

//中医/西医诊断标志

Property MRCType1 As %String(CONTENT = "中西医诊断标志");

//诊断编码

Property MRCCode As %String(CONTENT = "诊断编码");

//诊断名称

Property MRCDesc As %String(CONTENT = "诊断名称");

//诊断备注

Property MRCNode As %String(CONTENT = "诊断备注");

//诊断日期时间

Property MRCDateTime As %String(CONTENT = "诊断日期时间");

//诊断医生代码

Property MRCDocCode As %String(CONTENT = "诊断医生代码");

//诊断医生姓名

Property MRCDocDesc As %String(CONTENT = "诊断医生名称");

//诊断医生执业编号

Property MRCDocID As %String(CONTENT = "诊断医生执业编号");

//诊断医生身份证

Property MRCDocPatID As %String(CONTENT = "诊断医生身份证");

//主治医生代码

Property MRCMDocCode As %String(CONTENT = "主治医生代码");

//主治医生姓名

Property MRCMDocDesc As %String(CONTENT = "主治医生名称");

//主治医生执业编号

Property MRCMDocID As %String(CONTENT = "主治医生执业编号");

//主治医生身份证

Property MRCMDocPatID As %String(CONTENT = "主治医生身份证");

}
