/// 常量库
Class web.DHCCKBConstants Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s roots=[]
	s root={}
	s categories=##class(web.DHCCKBConstants).GetCategories()
	s root.categories=categories
	d roots.%Push(root)
	d roots.%ToJSON()
	Quit $$$OK
}

/// w ##class(web.DHCCKBConstants).GetCategories().%ToJSON()
ClassMethod GetCategories()
{
	
	s Categories=[]
	
	s Category={}.%Set("name","药品名称").%Set("label","药品名称")
	
	s Constants=[]
	d Category.%Set("constants",Constants)
	s Constants=[]
	s Constant={}.%Set("name","阿莫西林").%Set("label","阿莫西林")
	d Constants.%Push(Constant)
	
	s Constant={}.%Set("name","青霉素").%Set("label","青霉素")
	d Constants.%Push(Constant)
	d Category.%Set("constants",Constants)

	s Constant={}.%Set("name","头孢他啶").%Set("label","头孢他啶")
	d Constants.%Push(Constant)
	
	d Categories.%Push(Category)
    q Categories
}

}
