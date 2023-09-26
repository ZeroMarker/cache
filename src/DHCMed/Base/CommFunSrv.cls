/// 名称: DHCMed.Base.CommFunSrv
/// 描述: 公共方法
/// 编写者：朱飞
/// 编写日期: 2010-07-21
Class DHCMed.Base.CommFunSrv Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.Base.CommFunSrv).GetListFromString(STR,SEPA)
ClassMethod GetListFromString(STR As %String, SEPA As %String) As %List
{
	New (STR,SEPA)
	Set return=""
	If $g(SEPA)="" {
		Set:STR'="" return=$lb(STR)
	} Else {
		For Ind=1:1:$l(STR,SEPA) {
			Set StrSub=$p(STR,SEPA,Ind)
			Set return=return_$lb(StrSub)
		}
	}
	Quit return
}

/// w ##Class(DHCMed.Base.CommFunSrv).GetListToString(STR,SEPA)
ClassMethod GetListToString(STR As %List, SEPA As %String) As %String
{
	New (STR,SEPA)
	Set return=""
	Set:SEPA="" SEPA="^"
	For Ind=1:1:$listlength(STR) {
		Set StrSub=$listget(STR,Ind)
		Set return=return_SEPA_StrSub
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// add by wuqk for RegNo length
/// w ##Class(DHCMed.Base.CommFunSrv).RegNoCon(登记号)
ClassMethod RegNoCon(PAPMINo As %String) As %String
{
	new (PAPMINo)
	q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	s:len="" len=8
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
}

ClassMethod GetSystemDate(argFormat As %String) As %String
{
	New (argFormat)
	Set return=$zd(+$h,3)
	Set:argFormat="3" return=$zd(+$h,3) //2010-12-01
	Set:argFormat="4" return=$zd(+$h,4) //01/12/2010
	Quit return
}

ClassMethod GetSystemTime(argFormat As %String) As %String
{
	New (argFormat)
	Set return=$zt($p($h,",",2),1)
	Set:argFormat="1" return=$zt($p($h,",",2),1) //10:10:10
	Set:argFormat="2" return=$zt($p($h,",",2),2) //10:10
	Quit return
}

/// Creator：     PanLei
/// CreatDate：   2013-04-24
/// Description:  根据医生RowID,获取对应医生名称
/// Table：       CT_CareProv
/// Input：       argDoctorID:%String:医生RowID
/// Return：      返回<0,系统程序报错;
/// W ##class(DHCMed.Base.CommFunSrv).GetDoctorNameById(1863)
ClassMethod GetDoctorNameById(argDoctorID As %String) As %String
{
	New (argDoctorID)
	Set return = ""
	Quit:argDoctorID="" return
	
	Set $ZT = "GetDoctorNameByIdErr"
	
	// 根据医生RowID,获取对应医生名称
	Set tmpDocData = $g(^CTPCP(+argDoctorID,1))
	Set AdmDoctorDesc = $p(tmpDocData,"^",2)
	
	Set:AdmDoctorDesc'="" return=AdmDoctorDesc
	
	Quit return
	
GetDoctorNameByIdErr
	Set return = -1
	Quit return
}

/// Creator：     PanLei
/// CreatDate：   2013-04-24
/// Description:  根据病区RowID和床号RowID,获取对应床位名称
/// Table：       PAC_Bed
/// Input：       argWardID:%String:病区RowID,argBedID:%String:床号RowID
/// Return：      返回<0,系统程序报错;
/// W ##class(DHCMed.Base.CommFunSrv).GetBedNameById("24","24||8")
ClassMethod GetBedNameById(argWardID As %String, argBedID As %String) As %String
{
	New (argWardID, argBedID)
	Set return = ""
	Quit:(argWardID="")||(argBedID="") return
	
	Set $ZT = "GetBedNameByIdErr"
	
	// 根据床号RowID,获取对应床位名称
	Set tmpBedData = $g(^PAWARD(argWardID,"BED",$p(argBedID,"||",2)))
	Set AdmBedDesc = $p(tmpBedData,"^",1)

	Set:AdmBedDesc'="" return=AdmBedDesc
	
	Quit return
	
GetBedNameByIdErr
	Set return = -1
	Quit return
}

}
