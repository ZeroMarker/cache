Class DHCMGNUR.MenuSystem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As DHCMGNUR.MenuSystemSub [ Cardinality = children, Inverse = MenuParref ];

Property NurProduct As DHCMGNUR.Mould;

Property ParentMenuNod As %String(TRUNCATE = 1);

Property MenuTitle As %String(TRUNCATE = 1);

Property MenuCode As %String(TRUNCATE = 1);

Property MenuLink As %String(MAXLEN = 200, TRUNCATE = 1);

Property MenuRelComponent As %String(TRUNCATE = 1);

Property MenuSort As %String(TRUNCATE = 1);

Property MenuIcon As %String(TRUNCATE = 1);

Property MenuParam As %String(TRUNCATE = 1);

// 参数

Index Product On NurProduct;

Index MenuCode On MenuCode [ Unique ];

Index parmenu On ParentMenuNod;

ClassMethod Save(parr As %String) As %String
{
	s ^TEMP("g11020935001")=parr
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
    s id=$G(tmp("rw"))
     if id=""
     {
		 s a=##class(DHCMGNUR.MenuSystem).%New()
	 }else{
		 
		 s a=##class(DHCMGNUR.MenuSystem).%OpenId(id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MenuSystem","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..if ((p="NurProduct")&(tmp(p)'="")) d
	...s $ZOBJPROPERTY(a,p)=##class(DHCMGNUR.Mould).%OpenId(tmp(p))
	...q
	..e  i p'="NurProduct" s $ZOBJPROPERTY(a,p)=tmp(p)
	.//e  s $ZOBJPROPERTY(a,p)=""
    d a.%Save()
	q a.%Id()
}

ClassMethod getLink(code As %String) As %String
{
   //返回csp，component
    //w ##class(DHCMGNUR.MenuSystem).getLink(
     s paritm=$TR($ZConvert(code,"U")," ","")
     s menuid=$O(^DHCMGNUR.MenuSystemI("MenuCode"," "_paritm,""))
     b
     s a=##class(DHCMGNUR.MenuSystem).%OpenId(menuid)
     s component=a.MenuRelComponent
     s csplink=a.MenuLink
     s MenuParam=a.MenuParam
     s ret=csplink
     if ret="" d
     .;s ret="DHCNurEmrComm.csp?EmrCode="_component
     .s ret="dhcmgnurcomm.csp?EmrCode="_component
     if MenuParam'="" s ret=ret_MenuParam
     q ret
}

ClassMethod getFlag(parr As %String) As %String
{
   s tmp=""
   s flag=""
   s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
   b ;12
   s id=""  f  s id=$O(^DHCMGNUR.MenuSystemI("Product",tmp("NurProduct"),id))  q:id=""  d
   .s obj=##class(DHCMGNUR.MenuSystem).%OpenId(id)
   .s sort=obj.MenuSort
   .i sort'="" s sort=$tr(sort," ","")
   .i tmp("MenuSort")'=""  d
   ..i ($tr(tmp("MenuSort")," ","")=sort)  s flag=1
   q flag
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.MenuSystem).getVal(
	s ret=""
	if id'=""
	{
	s a=##class(DHCMGNUR.MenuSystem).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.MenuSystem","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	.if ((p="NurProduct")&(tmp(p)'="")) d
	..s tmp(p)=a.NurProduct.MouldName_"!"_a.NurProduct.%Id()
	.if ((p="ParentMenuNod")&(tmp(p)'="")) d
	..s b=##class(DHCMGNUR.MenuSystem).%OpenId(tmp(p))
	..s tmp(p)=b.MenuTitle_"!"_tmp(p)
	..;b
	s k=""
	f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"
	  }
	}
	q ret
}

ClassMethod Delete(rw As %String) As %String
{
   s a=##class(DHCMGNUR.MenuSystem).%DeleteId(rw)
   q 0
}

Storage Default
{
<Data name="MenuSystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MenuCode</Value>
</Value>
<Value name="3">
<Value>MenuIcon</Value>
</Value>
<Value name="4">
<Value>MenuLink</Value>
</Value>
<Value name="5">
<Value>MenuRelComponent</Value>
</Value>
<Value name="6">
<Value>MenuSort</Value>
</Value>
<Value name="7">
<Value>MenuTitle</Value>
</Value>
<Value name="8">
<Value>NurProduct</Value>
</Value>
<Value name="9">
<Value>ParentMenuNod</Value>
</Value>
<Value name="10">
<Value>MenuParam</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MenuSystemD</DataLocation>
<DefaultData>MenuSystemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MenuSystemD</IdLocation>
<IndexLocation>^DHCMGNUR.MenuSystemI</IndexLocation>
<StreamLocation>^DHCMGNUR.MenuSystemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
