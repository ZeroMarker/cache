/// 名称: DHCPM.Abstract
/// 描述: 所有类的抽象父类
/// 编写者：zzp
/// 编写日期: 2015-01-11
Class DHCPM.Abstract Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// 默认分隔符
Parameter SEPARATE = "^";

Method ListFromString(STR As %String, SEPA As %String) As %List
{
	New (STR,SEPA)
	Set return=""
	For Ind=1:1:$l(STR,SEPA) {
		Set StrSub=$p(STR,SEPA,Ind)
		Set return=return_$lb(StrSub)
	}
	Quit return
}

Method ListToString(STR As %List, SEPA As %String) As %String
{
	New (STR,SEPA)
	Set return=""
	For Ind=1:1:$listlength(STR) {
		Set StrSub=$listget(STR,Ind)
		Set return=return_SEPA_StrSub
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

}
