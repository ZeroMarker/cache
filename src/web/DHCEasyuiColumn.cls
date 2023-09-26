Class web.DHCEasyuiColumn Extends (%RegisteredObject, %XML.Adaptor)
{

Property field As %String;

Property title As %String;

Property width As %String;

Property align As %String;

Property checkbox As %String;

Property styler As %String;

/// d ##class(web.DHCEasyuiColumn).getColumn(0,"DefaultSee")
ClassMethod getColumn(HospitalRowId = "", queryTypeCode = "") As %String
{
	q:HospitalRowId="" ""
	q:queryTypeCode="" ""
	s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId"))
    q:$g(varStr)="" ""
    s len=$l(varStr,"^")
    q:len=0 ""
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
     w "[["
    s obj=##class(web.DHCEasyuiColumn).%New()
    s obj.title="选择"
    s obj.field="select"
    s obj.checkbox="true"
    w jsonObj.ObjToJson(obj) 
    f i=1:1:len d
    .s obj=##class(web.DHCEasyuiColumn).%New()
    .s obj.title=$p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",1)
    .s obj.field=$p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)
	.//w $case(i,1:"",:",")
	.i $p(^DHCCLNurseExec("Var",$p(varStr,"^",i)),"^",2)="arcimDesc" d
	..
	.w ","
	.w jsonObj.ObjToJson(obj) 
    w "]]"
    q ""
}

}
