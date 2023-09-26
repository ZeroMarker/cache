Class DHCMGNUR.QualCodeItemSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship QualParref As DHCMGNUR.QualCodeItem [ Cardinality = parent, Inverse = ChildSub, Required ];

Property ItemCode As %String(TRUNCATE = 1);

Property ItemDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Property ItemValue As %String(TRUNCATE = 1);

Property ItemLevel As %String(TRUNCATE = 1);

//扣分标准

Property ItemDedStand As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Index Level On (ItemLevel, ItemCode);

ClassMethod ForNur()
{
  s RowId="1695"
 
 f  s RowId=$o(^Nur.Qual1D(RowId)) q:RowId="1767"  d
  .s ItemCode=$list(^Nur.Qual1D(RowId),2)
  .s ItemDesc=$list(^Nur.Qual1D(RowId),3)
  .s ItemValue=$list(^Nur.Qual1D(RowId),4)
  .s ItemDedStand=$list(^Nur.Qual1D(RowId),5)
  .s ItemLeve=$list(^Nur.Qual1D(RowId),6)
  .s ^SZJ="rw|"_"^"_"Par|"_"13"_"^"_"ItemDesc|"_ItemDesc_"^"_"ItemValue|"_ItemValue_"^"_"ItemCode|"_ItemCode_"^"_"ItemDedStand|"_ItemDedStand_"^"_"ItemLeve|"_ItemLeve_"^"
  .s aa=##class(DHCMGNUR.QualCodeItemSub).Save(^SZJ)
  //.w !,^SZJ
  q aa
}

ClassMethod Save(parr As %String) As %String
{
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	
    s id=$G(tmp("rw"))
    //s ^SZJ=parr
    //m tmp=^TMP("pp")//
    m ^TMP("pp")=tmp
     if id=""
     {
		 s a=##class(DHCMGNUR.QualCodeItemSub).%New()
		 s a.QualParref=##class(DHCMGNUR.QualCodeItem).%OpenId(tmp("Par"))
	 }else{
		 
		 s a=##class(DHCMGNUR.QualCodeItemSub).%OpenId(tmp("Par")_"||"_id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItemSub","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
    //b ///sss
	q a.%Id()
}

ClassMethod getItmValue(qucode As %String) As %String
{

   	s qualdr=##class(DHCMGNUR.QualCodeItem).getqualid(qucode)
   	if qualdr="" q ""
   	s a=##class(DHCMGNUR.QualCodeItem).%OpenId(qualdr)
   	q a.QualValue
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.QualCodeItemSub).getVal(
	s ret=""
	if id'=""
	{
		s a=##class(DHCMGNUR.QualCodeItemSub).%OpenId(id)
		s tdata="",tmp=""
		s code=a.ItemCode
	    s level=a.ItemLevel
		s tmp("MinLevel")="Y"
		s subitm=code_".1"
		s Par=$P(id,"||")
		
		if $D(^DHCMGNUR.QualCodeItemSubI("Level"," "_code," "_subitm,Par)) s tmp("MinLevel")="N"

		s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItemSub","a",p)) q:p=""  d
		.q:p["%"
		.s tmp(p)=$ZOBJPROPERTY(a,p)
		s k=""
		f {
			s k=$O(tmp(k))
			q:k=""
			s ret=ret_k_"|"_tmp(k)_"^"
		 }
		 //if level=""
		// {
			s l=$L(code,".")
		    if l=1 s level=code
		    if l>1 
		    {
			    s itm=$P(code,".",l)
			    s l1=$L(code)
			    s l2=$L(itm)
			    s level=$E(code,1,(l1-l2-1))
		    }
			s a.ItemLevel=level
			d a.%Save()
		// }
	}
	q ret
}

Storage Default
{
<Data name="QualCodeItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
<Value name="5">
<Value>ItemLevel</Value>
</Value>
<Value name="6">
<Value>ItemMem</Value>
</Value>
<Value name="7">
<Value>ItemDedStand</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.QualCodeItemSubD</DataLocation>
<DefaultData>QualCodeItemSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCMGNUR.QualCodeItemSubI</IndexLocation>
<StreamLocation>^DHCMGNUR.QualCodeItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
