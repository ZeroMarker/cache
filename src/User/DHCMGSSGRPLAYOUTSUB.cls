Class User.DHCMGSSGRPLAYOUTSUB Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHCMG_SSGRPLAYOUTSUB ]
{

Relationship layparref As User.DHCMGSSGRPLAYOUT [ Cardinality = parent, Inverse = ChildSub, Required ];

Property laysubmoud As User.DHCMGMoudle;

Property laysubitem As %String(TRUNCATE = 1);

Property laysubSort As %String(TRUNCATE = 1);

ClassMethod DelPar(p As %String) As %String
{
   //s a=##class(User.DHCMGSSGRPLAYOUTSUB).DelPar()
	s a=##class(User.DHCMGSSGRPLAYOUT).%DeleteId(p)
	q 0
}

ClassMethod save(p As %String, parr As %String) As %String
{
	//s parr="1!1||1^1||2^1||3^&2!&3!&4!&5!&6!&7!&8!&9!&"
	s parent=##class(User.DHCMGSSGRPLAYOUT).%OpenId(p)
	s ln=$l(parr,"&")
	b
	s i=1
	s ret=..del(p)
	//q 1
	f i=1:1:ln
	{
	   s itm=$P(parr,"&",i)
	   if itm="" continue
	   s par=$P(itm,"!")
	   s a=##class(User.DHCMGSSGRPLAYOUTSUB).%New()
	   s a.layparref=parent
	   s a.laysubmoud=##class(User.DHCMGMoudle).%OpenId(par)
	   s subitm=$P(itm,"!",2)
	   if subitm'="" s a.laysubitem=subitm
	   b //
	   d a.%Save()
	}
	q 1
}

ClassMethod del(p As %String) As %String
{
	s chl=""  f  s chl=$O(^User.DHCMGSSGRPLAYOUTD(p,"ChildSub",chl)) q:chl=""  d
	.s a=##class(User.DHCMGSSGRPLAYOUTSUB).%DeleteId(p_"||"_chl)
	q 0
}

ClassMethod SaveSubSort(p As %String, str As %String) As %String
{
 //s a=##class(User.DHCMGSSGRPLAYOUTSUB).SaveSubSort()
	//s p=5,str="NurseManager.frmEmrData|itm11|0^NurseManager.frmEmrData|itm13|1^NurseManager.frmEmrData|itm12|2^NurseManager.frmEmrData|itm14|3^NurseManager.frmEmrData|itm15|4^NurseManager.frmMgNurEmrSch|5^NurseManager.frmEmrData|fold2|6^"
	if str="" q ""
	
	//s ^TM=str
  	s l=$L(str,"^")
  	for i=1:1:l
  	{
	  
	  s itm=$P(str,"^",i)
	  if itm="" continue
	  s sort($P(itm,"!"))=$P(itm,"!",2)
	}
  	s chl=""  f  s chl=$O(^User.DHCMGSSGRPLAYOUTD(p,"ChildSub",chl)) q:chl=""  d
	.s a=##class(User.DHCMGSSGRPLAYOUTSUB).%OpenId(p_"||"_chl)
	.s moud=a.laysubmoud
	.s modid=$P(moud,"@")
	.s dd=""_modid_""
	.s a.laysubSort=sort(moud.mlname)
	.//w !, a.laysubSort
	.d a.%Save()
  q 0
}

Storage Default
{
<Data name="DHCMGSSGRPLAYOUTSUBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>laysubitem</Value>
</Value>
<Value name="3">
<Value>laysubmoud</Value>
</Value>
<Value name="4">
<Value>laysubSort</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCMGSSGRPLAYOUTSUBDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGSSGRPLAYOUTC("ChildSub")</IdLocation>
<IndexLocation>^User.DHCMGSSGRPLAYOUTSUBI</IndexLocation>
<StreamLocation>^User.DHCMGSSGRPLAYOUTSUBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
