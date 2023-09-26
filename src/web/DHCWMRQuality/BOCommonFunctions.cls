/// DHC Web Medical Record runtime quality monitor 
/// Common Function.
/// By wuqk 2007-12
Class web.DHCWMRQuality.BOCommonFunctions Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod GetHours(DateFrom, TimeFrom, DateTo, TimeTo)
{
	n (DateFrom, TimeFrom,DateTo, TimeTo)
	Set ret=""
	Set:+TimeFrom=0 TimeFrom=+$p(DateFrom,",",2)
	Set:+TimeTo=0 TimeTo=+$p(DateTo,",",2)
	Set DateFrom=+DateFrom
	Set DateTo=+DateTo
	Set dHour=(DateTo-DateFrom)*24
	Set tHour=(TimeTo-TimeFrom)/3600
	Set ret=dHour+tHour
	Quit ret
}

ClassMethod IsAccordLetter(sLetter)
{
	n (sLetter)
	Set ret=0
	Set aLetter=$A(sLetter)
	If (aLetter>45)&(aLetter<58)   ;./0 ---  9      46-57
	{
		Set ret=1
	}
	ElseIf (aLetter>64)&(aLetter<91)   ;A ---  Z      65-90
	{
		Set ret=1
	}
	ElseIf (aLetter>96)&(aLetter<123)  ;a ---  z      97-122
	{
		Set ret=1
	}
	Else
	{
		Set ret=0
	}    
	Quit ret
}

}
