Class DHCINSU.OeordInfo Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "OeordInfo";

Property OEORDDATE As %String;

Property OEORDTIME As %String;

Property OEORDDoctorDr As %String;

Property CTPCPCode As %String;

Property CTPCPID As %String;

Property PriorityDR As %String;

Property OECPRode As %String;

Property OECPRDesc As %String;

Property OEORIRowID As %String;

Property OEORISubChild As %String;

//以上是标准版字段

Property ArcItmCode As %String;

Property ArcItmDesc As %String;

Property CoverMainIns As %String;

Property BBExtCode As %String;

Property OEORIPHFreq As %String;

Property UomDesc As %String;

Property DoseQtyOEORIUnitDes As %String;

//add by zhangdongliang at 2017-02-22 for 北京专用 

Property DoseQty As %String;

Property OEORIUnitDes As %String;

//end

Property ARCIMBillingUOMdes As %String;

Property PHCDUDesc As %String;

Property Factor As %String;

Property PrescNo As %String;

Property ReqCheckFlag As %String;

Property HisCheckFlag As %String;

Property Billed As %String;

Property ExecPcpCode As %String;

Property ExecPcpDesc As %String;

Property DateExecuted As %String;

Property TimeExecuted As %String;

Property BabyFlag As %String;

Property PBOExeDr As %String;

Property PackageFlag As %String;

Property PackageCode As %String;

Property PackageMainitemFlag As %String;

Property PackageMegFlag As %String;

Property PackageMaxamt As %String;

Property PackageExtStr As %String;

Property DrugApprovalNumber As %String;

}
