Import SQLUser

Class web.DHCDocIPBookTempCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

ClassMethod GetTemplateArry()
{
		set TemplateID = 0 
		set ret = ""
		while (1)
		{
			set TemplateID = $o(^DHCDocIPBKT(TemplateID))
			quit:TemplateID=""
			set TempData = $g(^DHCDocIPBKT(TemplateID))
			continue:$p(TempData,"^",3)'="Y"
			set ret=ret _ TemplateID _ "^" _ TempData
			set:ret'="" ret = ret _ $c(1)
		}
		quit ret
}

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}
