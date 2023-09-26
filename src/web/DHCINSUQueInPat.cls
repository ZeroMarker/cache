/// 医保结算信息操作类
Class web.DHCINSUQueInPat Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 2;

//查询在院病人信息

ClassMethod GetAdmAndInsu(I) As %String
{
 s OutStr=$$GetAdmAndInsu^DHCINSUQueInPat(I) 
 s GetAdmAndInsu=OutStr
 q GetAdmAndInsu
}

ClassMethod QueryPatType() As %String
{
 s OutStr=$$QueryPatType^DHCINSUQueInPat() 
 i +OutStr>0  d
 .s QueryPatType="1!"_OutStr
 e     d
 .s QueryPatType="-1!"_OutStr
 q QueryPatType
}

ClassMethod GetPatType(I) As %String
{
 s OutStr=$$GetPatType^DHCINSUQueInPat(I) 
 s GetPatType=OutStr
 q GetPatType
}

ClassMethod QueryHosWard() As %String
{
 s OutStr=$$QueryHosWard^DHCINSUQueInPat() 
 i +OutStr>0  d
 .s QueryHosWard="1!"_OutStr
 e     d
 .s QueryHosWard="-1!"_OutStr
 q QueryHosWard
}

ClassMethod GetHosWard(I) As %String
{
 s OutStr=$$GetHosWard^DHCINSUQueInPat(I) 
 s GetHosWard=OutStr
 q GetHosWard
}

ClassMethod QueryAllInsu(PatRegNo, PatName, WardId, PatType) As %String
{
 s AdmAndInsuStr="0!0"
 s OutStr=$$QueryAdmAndInsu^DHCINSUQueInPat(PatRegNo,PatName,WardId,PatType) 
 i +OutStr>0  d
 .s AdmAndInsuStr="1!"_OutStr
 e     d
 .s AdmAndInsuStr="-1!"_OutStr
 q AdmAndInsuStr
}

ClassMethod GetAllInsuInfo(PatRegNo As %Library.String, PatName As %Library.String, WardId As %Library.String, PatType As %Library.String) As %Library.String
{
	s AdmAndInsuStr="0!0"
	s OutStr=""
	s OutStr=$$QueryAdmAndInsu^DHCINSUQueInPat(PatRegNo,PatName,WardId,PatType)
	w OutStr,!
	i +OutStr>0  d
	.s AdmAndInsuStr="1!"_OutStr
	e     d
	.s AdmAndInsuStr="-1!"_OutStr
	q AdmAndInsuStr
}

ClassMethod QueryAdmAndInsu(RegNo As %String, PatName As %String, WardID As %String, PatType As %String) As %String
{
 s OutStr=$$QueryAdmAndInsu^DHCINSUQueInPat(RegNo, PatName, WardID, PatType) 
 i +OutStr>0  d
 .s QueryAdmAndInsu="1!"_OutStr
 e     d
 .s QueryAdmAndInsu="-1!"_OutStr
 q QueryAdmAndInsu
}

ClassMethod QueryOutAdmAndInsu(RegNo As %String, PatName As %String, WardID As %String, PatType As %String, startdate As %String, enddate As %String) As %String
{
 s OutStr=$$QueryOutAdmAndInsu^DHCINSUQueInPat(RegNo, PatName, WardID, PatType,startdate, enddate) 
 i +OutStr>0  d
 .s QueryAdmAndInsu="1!"_OutStr
 e     d
 .s QueryAdmAndInsu="-1!"_OutStr
 q QueryAdmAndInsu
}

}
