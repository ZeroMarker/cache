Class DHCINSU.Model.BJ.INSUOPDiagInfo Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "INSUOPDiagInfo";

//只增加了北京医保所用字段，标准版要使用，需要增加通用字段。

//门诊收费流水号   

Property InvprtDr As %String;

//诊断序号

Property DiagIdx As %String;

//处方序号

Property OeordDR As %String;

//诊断编码

Property DiagCode As %String;

//诊断名称

Property DiagDesc As %String;

//病历信息

Property PatEPRInfo As %String;

//处方日期

Property OeordDate As %String;

//就诊科别代码

Property BasDicDepCode As %String;

//就诊科别名称

Property BasDicDepDesc As %String;

//HIS就诊科别名称

Property AdmDepDesc As %String;

//医师姓名

Property DocName As %String;

//医师编码

Property DocCode As %String;

//处方类别 0：医保内处方 1：医保外处方

Property OeordType As %String;

//处方备注

Property OeordDemo As %String;

//诊断备注 

Property remark As %String;

//挂号交易流水号

Property registertradeno As %String;

//单据类型 

Property billstype As %String;

}
