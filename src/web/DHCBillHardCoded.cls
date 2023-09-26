/// Creator: Lid
/// CreatDate: 2011-09-14
/// Description: 计费组各医院写死代码
Class web.DHCBillHardCoded Extends %RegisteredObject
{

/// Creater: Lid
/// CreatDate: 2011-09-14
/// Description: 判断是否是检查医嘱
/// Input: ArcimRowid: ARC_ItmMast.ARCIM_RowId
/// Return: 0: 否, 1:是
/// Debug: w ##class(web.DHCBillHardCoded).IsExamSubCat("2572||1")
ClassMethod IsExamSubCat(ArcimRowid As %String) As %String
{
	set ServMaterial=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),7)),"^",6)   //ARCIM_ServMaterial
	quit (ServMaterial="S")
}

///  Creater:Lid
///  CreatDate:2011-09-14
///  Description:协和医院 根据费别判断病人是否为本院职工/合同单位/商业保险
///  Input:费别(Pac_admReason表Rowid)
///  Return:1:普通职工,2:合同单位,3:商业保险,0:其他,4:普通卫干,5:院士
///  Other:同协和医院高级客户讨论后归纳:
///       	合同单位:正部级干部/公费记账/副部级干部/合同单位/外国专家特需病人/外国专家副部级/医科院职工/医科院学生
///  		商业保险:商业保险
///  		本院职工:
///  					院士:
///  					普通卫干:普通卫干
///  					普通职工:本院医照/本院在职/本院退休/本院离休/本院特殊/本院特殊2（在职）/本院特殊2（退休）
/// Debug: w ##class(web.DHCBillHardCoded).GetPatType(137)
ClassMethod GetPatType(admresid)
{
	q:(admresid="") ""
	s desc=$p(^PAC("ADMREA",admresid),"^",2)
	s StaffHs="^本院医照^本院在职^本院退休^本院离休^本院特殊^本院特殊2(在职)^本院特殊2(退休)^本院在职(住院)^本院离休(住院)^本院退休(住院)"
	s StaffHs=StaffHs_"^本院公费(住院)^本院特殊2(退休住院)^"
	q:StaffHs[("^"_desc_"^") 1
	s GenWorker="^普通卫干^"
	q:GenWorker[("^"_desc_"^") 4
	s Academician="^院士^"
	q:Academician[("^"_desc_"^") 5
	s comp="^正部级干部^公费记账^副部级干部^合同单位^外国专家特需病人^外国专家副部级^医科院职工^医科院学生^" 
	q:comp[("^"_desc_"^") 2
	q:desc="商业保险" 3
	q 0
}

}
