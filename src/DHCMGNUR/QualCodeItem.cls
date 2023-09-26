Class DHCMGNUR.QualCodeItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As DHCMGNUR.QualCodeItemSub [ Cardinality = children, Inverse = QualParref ];

Property QualCode As %String(TRUNCATE = 1);

Property QualDesc As %String(TRUNCATE = 1);

Property QualValue As %String(TRUNCATE = 1);

Property QualLoc As %String(TRUNCATE = 1);

Property QualCheckOBJ As %String(TRUNCATE = 1);

Property QualCat As %String(TRUNCATE = 1);

Property QualWeight As %String(TRUNCATE = 1);

Property QualCheckMth As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

Property QualGradeMth As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0);

//版本号

Property QualVersion As %String(TRUNCATE = 1);

Property QualDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property QualTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Index Code On QualCode;

Index Version On (QualCode, QualVersion);

ClassMethod Save(parr As %String) As %String
{
	//s ^SZj1=parr
	//s parr=^SZj1
	s tmp=""
	//b 
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s tdata=""
    s id=$G(tmp("rw"))
   // m ^TMP("pp")=tmp
     if id=""
     {
		 s a=##class(DHCMGNUR.QualCodeItem).%New()
		 s a.QualVersion=0
	 }else{
		 
		 s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
	 }
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItem","a",p)) q:p=""  d
	.if $D(tmp(p)) d
	..s $ZOBJPROPERTY(a,p)=tmp(p)
    d a.%Save()
	q a.%Id()
}

//新增版本

ClassMethod addSave(oldID As %String) As %String
{
	q:oldID="" 0
	s NewId=""

	s old=##class(DHCMGNUR.QualCodeItem).%OpenId(oldID)
	s new=##class(DHCMGNUR.QualCodeItem).%New()
	s new.QualCode = old.QualCode 
	s new.QualDesc = old.QualDesc 
	s new.QualValue = old.QualValue 
	s new.QualLoc = old.QualLoc 
	s new.QualCheckOBJ = old.QualCheckOBJ 
	s new.QualCat = old.QualCat 
	s new.QualCheckMth = old.QualCheckMth 
	s new.QualGradeMth = old.QualGradeMth 
	s new.QualVersion = old.QualVersion+1
	d new.%Save()
	s NewId=new.%Id()
	
	i (NewId'="") d
	.s id="" f  s id=$O(^DHCMGNUR.QualCodeItemSubD(oldID,id)) q:id=""  d
	..s SubId=oldID_"||"_id
 	..s Sub=##class(DHCMGNUR.QualCodeItemSub).%OpenId(SubId)
 	..s newSub=##class(DHCMGNUR.QualCodeItemSub).%New()
	..s newSub.QualParref=##class(DHCMGNUR.QualCodeItem).%OpenId(NewId)
	..//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
	..s newSub.ItemCode=Sub.ItemCode
	..s newSub.ItemLevel=Sub.ItemLevel
	..s newSub.ItemDesc=Sub.ItemDesc
	..s newSub.ItemValue=Sub.ItemValue
	..s newSub.ItemDedStand=Sub.ItemDedStand
	..s sc = newSub.%Save()

	q new.%Id()
}

ClassMethod getqualid(qcode) As %String
{
  //##class(DHCMGNUR.QualCodeItem).getqualid(qucode)
   s qcode=$TR($ZConvert(qcode,"U")," ","")

   ;s rw=""  s rw=$O(^DHCMGNUR.QualCodeItemI("Code"," "_qcode,rw))
    s Ver=""  s Ver=$O(^DHCMGNUR.QualCodeItemI("Version"," "_qcode,Ver),-1) q:Ver=""  d
   .s rw=""  s rw=$O(^DHCMGNUR.QualCodeItemI("Version"," "_qcode,Ver,rw))
  
   q rw
}

ClassMethod getqualDesc(qcode) As %String
{
  ;##class(DHCMGNUR.QualCodeItem).getqualDesc(qucode)
   s qcode=$TR($ZConvert(qcode,"U")," ","")

   ;s rw=""  s rw=$O(^DHCMGNUR.QualCodeItemI("Code"," "_qcode,rw))
   s Ver=""  s Ver=$O(^DHCMGNUR.QualCodeItemI("Version"," "_qcode,Ver),-1) q:Ver=""  d
   .s rw=""  s rw=$O(^DHCMGNUR.QualCodeItemI("Version"," "_qcode,Ver,rw))
  
   s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
   
   q a.QualDesc
}

ClassMethod getVal(id) As %String
{
 //w ##class(DHCMGNUR.MenuSystem).getVal(
	s ret=""
	if id'=""
	{
	s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItem","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	.if ((p="QualLoc")&&(tmp(p)'="")) d
	..b ;001 
	..s tmp(p)=$p(^CTLOC(tmp(p)),"^",2) //_"!"_tmp(p)
    .;w !,temp
    b ;0012
	s k=""
	f {
		s k=$O(tmp(k))
		q:k=""
		//w !,tmp(k)
		s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	//w !,ret
	q ret
}

ClassMethod getWeight(id) As %String
{
 //w ##class(DHCMGNUR.MenuSystem).getVal(
	s we=""
	if id'=""
	{
	s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
	s tdata="",tmp=""
	s p="" f  s p=$O(^oddCOM("DHCMGNUR.QualCodeItem","a",p)) q:p=""  d
	.q:p["%"
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	.if (p="QualLoc")&(tmp(p)'="") s tmp(p)=$p(^CTLOC(tmp(p)),"^",2)_"!"_tmp(p)
	
    s k=""
	f {
		s k=$O(tmp(k))
		q:k=""
		if (k="QualWeight") s we=tmp(k)
		//s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q we
}

ClassMethod getQualScore(qual)
{
	s qcode=$TR($ZConvert(qual,"U")," ","")
	s par=##class(DHCMGNUR.QualCodeItem).getqualid(qcode)
	s a=##class(DHCMGNUR.QualCodeItem).%OpenId(par)
	s qualScore=a.QualValue
	q qualScore
}

Storage Default
{
<Data name="QualCodeItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualCode</Value>
</Value>
<Value name="3">
<Value>QualDesc</Value>
</Value>
<Value name="4">
<Value>QualValue</Value>
</Value>
<Value name="5">
<Value>QualLoc</Value>
</Value>
<Value name="6">
<Value>QualCheckOBJ</Value>
</Value>
<Value name="7">
<Value>QualCat</Value>
</Value>
<Value name="8">
<Value>QualMem</Value>
</Value>
<Value name="9">
<Value>QualCheckMth</Value>
</Value>
<Value name="10">
<Value>QualGradeMth</Value>
</Value>
<Value name="11">
<Value>QualWeight</Value>
</Value>
<Value name="12">
<Value>QualVersion</Value>
</Value>
<Value name="13">
<Value>QualDate</Value>
</Value>
<Value name="14">
<Value>QualTime</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.QualCodeItemD</DataLocation>
<DefaultData>QualCodeItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.QualCodeItemD</IdLocation>
<IndexLocation>^DHCMGNUR.QualCodeItemI</IndexLocation>
<StreamLocation>^DHCMGNUR.QualCodeItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
