Class DHCMGNUR.MgNurse Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As DHCMGNUR.MgNurseSub [ Cardinality = children, Inverse = Parref ];

Property WardLoc As %Integer;

Property Nurse As %Integer;

Property NurTyp As %String(TRUNCATE = 1);

Index typ On NurTyp;

Index Nurse On (Nurse, NurTyp);

Index loc On WardLoc;

ClassMethod Save(ward, nurse, typ, rw) As %String
{
	s ^TEMP("g201412251938001")=ward_"%"_nurse_"%"_typ_"%"_rw
	s NurId=""
	s typtem=$TR($ZConvert(typ,"U")," ","")
  	if (rw="")
  	{
    	s a=##class(DHCMGNUR.MgNurse).%New()
    	s NurId=$o(^DHCMGNUR.MgNurseI("Nurse",nurse," "_typtem,""))
    	q:NurId'="" "已存在，请修改！"
     	s a.WardLoc=ward
	 	s a.Nurse=nurse
	 	s a.NurTyp=typ
	 	d a.%Save()
	 	q a.%Id()
  	}
  	else
  	{
	  	//31%26%LocNur%8
	  	s a=##class(DHCMGNUR.MgNurse).%OpenId(rw)
	  	s a.Nurse=nurse
	  	s a.NurTyp=typ
	  	s a.WardLoc=ward
	  	d a.%Save()
	  	q a.%Id()
	  	;s NurId=$o(^DHCMGNUR.MgNurseI("Nurse",nurse," "_typtem,""))
	 	;if NurId'=""  
		;{
		;	s a=##class(DHCMGNUR.MgNurse).%OpenId(NurId)
	 	;	s a.WardLoc=ward
	 	;	s a.Nurse=nurse
	 	;	s a.NurTyp=typ
	 	;	d a.%Save()
	 	;	q a.%Id()
		;}
		//s a=##class(DHCMGNUR.MgNurse).%OpenId(rw)
  	}
  /*
	 s a.WardLoc=ward
	 s a.Nurse=nurse
	 s a.NurTyp=typ
	 d a.%Save()
	 q a.%Id()
	 */
}

ClassMethod CheckExist(parr As %String) As %String
{
	s ret=""
	s typ="" f  s typ=$O(^DHCMGNUR.MgNurseI("Nurse",parr,typ)) q:typ=""  d
	.s id=$O(^DHCMGNUR.MgNurseI("Nurse",parr,typ,""))
	.s ret=id
	.;i '="" s ret=id q:ret
	.;e  q:ret
	q ret
}

ClassMethod getCheckFlag(userid As %String) As %String
{
	s ret=""
	s max=0
	s max2=0
	s typ="" f  s typ=$O(^DHCMGNUR.MgNurseI("Nurse",userid,typ)) q:typ=""  d
	.s type=$replace(typ," ","")
	.i type="NUR" S max2=1
	.i type="LOCNUR" s max2=2
	.i type="MASTERNUR" s max2=3
	.i max<max2  s max=max2
	
	q max
}

ClassMethod delNur(id) As %String
{
  d ##class(DHCMGNUR.MgNurse).%DeleteId(id)
  q 0
}

Storage Default
{
<Data name="MgNurseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardLoc</Value>
</Value>
<Value name="3">
<Value>Nurse</Value>
</Value>
<Value name="4">
<Value>NurTyp</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurseD</DataLocation>
<DefaultData>MgNurseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurseD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurseI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
