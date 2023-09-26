Class DHCMGNUR.Mould Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1);

Property MouldName As %String(TRUNCATE = 1);

Property Icon As %String(MAXLEN = 200, TRUNCATE = 1);

Property MSort As %String(TRUNCATE = 1);

Property Version As %String(TRUNCATE = 1);

Property Mem As %String(TRUNCATE = 1);

Index Code On Code [ Unique ];

ClassMethod Save(parr As %String) As %String
{
  //s a=##class(HDS.Register).Save()
	s tmp=""
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
	//m ^TMP("a")=tmp
     s id=$G(tmp("rw"))
     if id=""
     {
		 s a=##class(DHCMGNUR.Mould).%New()
	 }else{
		 
		 s a=##class(DHCMGNUR.Mould).%OpenId(id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.Mould","a",p)) q:p=""  d
	.if $D(tmp(p)) s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
	q 0
}

/// w ##class(DHCMGNUR.Mould).getMSort("MouldName|护理排班管理^Code|PersonArrange^Icon|^Version|^MSort| 2^Mem|^rw|2^")
ClassMethod getMSort(parr As %String) As %String
{
	q:parr="" ""
	;s ^temp("201712261921")=parr
	s tmp=""
	s flag=""
	b ;1
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s MSort=$G(tmp("MSort"))
	i MSort'="" s MSort=$tr(MSort," ","")
	s rw=$G(tmp("rw"))
	b ;2
	q:MSort="" ""
	s id=""  f  s id=$O(^DHCMGNUR.MouldD(id)) q:id=""  d
	.q:rw=id
	.s obj=##class(DHCMGNUR.Mould).%OpenId(id)
	.s msort=obj.MSort
	.i msort'=""  d
	..s msort=$tr(msort," ","")
	..i MSort=msort  s flag=$g(tmp("MouldName"))
	q flag
}

ClassMethod getVal(id) As %String
{
	s ret=""
	b
	if id'=""
	{
	s a=##class(DHCMGNUR.Mould).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.Mould","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod delItem(id As %String) As %String
{
	i id'=""
	{
		s ret=""
		s ^TEMP("g2014121901")=id
		TStart
		s obj=##class(DHCMGNUR.Mould).%OpenId(id)
		s sc = obj.%DeleteId(id)
		s rw=$O(^DHCMGNUR.MenuSystemI("Product",id,""))
		i rw'="" 
		{
			s ret="此模块已经被引用，不能删除！"
		}
		else
		{
			i $$$ISERR(sc)  
			{
				TRollBack
				Do $System.Status.DisplayError(sc)
   				s ret="删除失败"
			}
			else
			{
				TCommit
				s ret="删除成功"
			}
		}
		q ret
	}
}

Storage Default
{
<Data name="MouldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>MouldName</Value>
</Value>
<Value name="4">
<Value>Icon</Value>
</Value>
<Value name="5">
<Value>MSort</Value>
</Value>
<Value name="6">
<Value>Version</Value>
</Value>
<Value name="7">
<Value>Mem</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MouldD</DataLocation>
<DefaultData>MouldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MouldD</IdLocation>
<IndexLocation>^DHCMGNUR.MouldI</IndexLocation>
<StreamLocation>^DHCMGNUR.MouldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
