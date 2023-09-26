Class web.DHCENS.STBLL.RIS.MODEL.Response.RisAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱号
Property Rowid As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Rowid");

/// 病人类别
Property PatientType As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "PatientType");

/// 费别 
Property FeeType As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "FeeType");

/// 住院号	
Property InpatientNo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "InpatientNo");

/// 门诊号
Property OutpatientNo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "OutpatientNo");

/// 姓名	 
Property Name As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Name");

/// 性别 
Property Sex As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Sex");

/// 年龄	 
Property Age As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Age");

/// 婚姻 
Property Marry As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Marry");

/// 地址
Property Address As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Address");

/// 电话 	 
Property Telephone As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Telephone");

/// 病区 	 
Property Ward As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Ward");

/// 床号	 
Property BedNo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "BedNo");

/// 身份证号 	 
Property IDCard As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "IDCard");

/// 民族	 
Property Nation As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Nation");

/// 职业	 
Property Profession As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Profession");

/// 送检医院	 
Property Hospital As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Hospital");

/// 送检科室	 
Property Loc As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Loc");

/// 送检医生	 
Property Doctor As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Doctor");

/// 申请日期	 
Property ApplyDate As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "ApplyDate");

/// 申请时间 	 
Property ApplyTime As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "ApplyTime");

/// 标本名称	 
Property SampleName As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "SampleName");

/// 临床诊断	 
Property ClinicDiagnose As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "ClinicDiagnose");

/// 临床病史 	 
Property ClinicDisease As %Library.String(MAXLEN = 100000, TRUNCATE = 1, XMLNAME = "ClinicDisease");

/// 手术资料 	 
Property OperationInfo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "OperationInfo");

/// 其他信息	 
Property OtherInfo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "OtherInfo");

/// 就诊ID	
Property AdmDR As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "AdmDR");

/// 出生日期 	 
Property PAPMIDOB As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "PAPMIDOB");

/// 医嘱名称	 
Property OrdName As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "OrdName");

/// 登记号	 
Property RegNo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "RegNo");

/// 身高	 
Property Height As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Height");

/// 体重	 
Property Weigth As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "Weigth");

/// 病历号 	 
Property EPRno As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "EPRno");

/// 医保号	 
Property ISUNo As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "ISUNo");

/// 执行科室	 
Property ExeLoc As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "ExeLoc");

Property DocumentID As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "DocumentID");

/// 申请单内容 
Property FormContent As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "FormContent");

/// 申请单金额 
Property FeeNum As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "FeeNum");

/// 申请单收费状态 
Property FeeBilled As %Library.String(MAXLEN = 30, TRUNCATE = 1, XMLNAME = "FeeBilled");

}
