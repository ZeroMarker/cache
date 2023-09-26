Class User.DHCNurWardShift Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildRec As User.DHCNurWardShiftSub [ Cardinality = children, Inverse = RecParref ];

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Property CareDate As %Library.Date(FORMAT = 1);

Property LocDr As %String(TRUNCATE = 1);

Property Item1 As %String(TRUNCATE = 1);

Property Item2 As %String(TRUNCATE = 1);

Property Item3 As %String(TRUNCATE = 1);

Property Item4 As %String(TRUNCATE = 1);

Property Item5 As %String(TRUNCATE = 1);

Property Item6 As %String(TRUNCATE = 1);

Property Item7 As %String(TRUNCATE = 1);

Property Item8 As %String(TRUNCATE = 1);

Property Item9 As %String(TRUNCATE = 1);

Property Item10 As %String(TRUNCATE = 1);

Property Item11 As %String(TRUNCATE = 1);

Property Item12 As %String(TRUNCATE = 1);

Property Item13 As %String(TRUNCATE = 1);

Property Item14 As %String(TRUNCATE = 1);

Property Item15 As %String(TRUNCATE = 1);

Property Item16 As %String(TRUNCATE = 1);

Property Item17 As %String(TRUNCATE = 1);

Property Item18 As %String(TRUNCATE = 1);

Property Item19 As %String(TRUNCATE = 1);

Property Item20 As %String(TRUNCATE = 1);

Property Item21 As %String(TRUNCATE = 1);

Property Item22 As %String(TRUNCATE = 1);

Property Item23 As %String(TRUNCATE = 1);

Property Item24 As %String(TRUNCATE = 1);

Property Item25 As %String(TRUNCATE = 1);

Property Item26 As %String(TRUNCATE = 1);

Property Item27 As %String(TRUNCATE = 1);

Property Item28 As %String(TRUNCATE = 1);

Property Item29 As %String(TRUNCATE = 1);

Property Item30 As %String(TRUNCATE = 1);

Property DayWork As %String(TRUNCATE = 1);

Property NightWork As %String(TRUNCATE = 1);

Index LocDate On (LocDr, CareDate);

Method ListProperties() As %String [ CodeMode = objectgenerator ]
{
  //s a=##class(web.DHCNurHdComm).ListProperties()
    k ^tdata("User.DHCNurWardShift")
    For i = 1:1:%compiledclass.Properties.Count() {
        Set prop = %compiledclass.Properties.GetAt(i).Name
        if $F(prop,"%")=0
        {
        s ^tdata("User.DHCNurWardShift",prop)=""
        }
        //Do %code.WriteLine(" Write """ _ prop _ """,!")      
    }
   // Do %code.WriteLine(" Quit")
    Quit $$$OK
}

ClassMethod getVal(id, tmp) As %String
{
	if id'=""
	{
		s a=##class(User.DHCNurWardShift).%OpenId(id)
		s tmp=""
		if '$D(^tdata("User.DHCNurWardShift")) d a.ListProperties()
		s p="" f  s p=$O(^tdata("User.DHCNurWardShift",p)) q:p=""  d
		.s tmp(p)=$ZOBJPROPERTY(a,p)
	}
	q 0
}

ClassMethod Save(locId, parr As %String, user, CareDate, usergroup, type = "") As %String
{
	
	s recDate=$p($h,",",1)
	s recTime=$p($h,",",2)
	s l=$L(parr,"^")
	s type=##class(web.DHCNurShiftExchage).GetType(CareDate)
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s val=$P(itm,"|",2)
	  	s tmp(name)=val
	}
	s:CareDate["/" CareDate=$zdh(CareDate,4),CareDate=$zd(CareDate,3)
	s saveName=""
	if $D(^SSU("SSUSR",user)) d
	 .s saveName=$p(^SSU("SSUSR",user),"^",2)
	if (type="Night") s tmp("Item22")=saveName
	if (type="Day") s tmp("Item21")=saveName
	i (($g(type)="Night")&($p($h,",",2)<$ZTH("07:00:00"))&&($ZDH(CareDate,3)=+$h)) s CareDate=$ZD($ZDH(CareDate,3)-1,3)
	s tmp("RecUser")=user
	s tmp("LocDr")=locId	
	if $G(tmp("LocDr"))="" q "请选择一个科室!"
	s tmp("CareDate")=CareDate
	if $G(tmp("CareDate"))="" q "请选择日期!"

    s tmp("Id")=$O(^User.DHCNurWardShiftI("LocDate"," "_$G(tmp("LocDr")),$ZDH(tmp("CareDate"),3),""))
	if $G(tmp("Id"))'="" 
	{ 
		s a=##class(User.DHCNurWardShift).%OpenId(tmp("Id"))
		s recuserId=a.RecUser
		i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		e  s recuser=""
		//if (usergroup'["护士长")&(user'=recuserId) q "对不起您无修改权限,请联系护士长或"_recuser
	}
	else
	{  
		s a=##class(User.DHCNurWardShift).%New()
	}
		
		if $D(tmp("LocDr")) s a.LocDr=tmp("LocDr")
		if $D(tmp("RecUser")) s a.RecUser=tmp("RecUser")
		if $D(tmp("CareDate")) s a.CareDate=$ZDH(tmp("CareDate"),3)
		s a.RecDate=recDate
		s a.RecTime=recTime
		
		if $D(tmp("Item1")) s a.Item1=tmp("Item1")
			if $D(tmp("Item2")) s a.Item2=tmp("Item2")
			if $D(tmp("Item3")) s a.Item3=tmp("Item3")
			if $D(tmp("Item4")) s a.Item4=tmp("Item4")	
			if $D(tmp("Item5")) s a.Item5=tmp("Item5")
			if $D(tmp("Item6")) s a.Item6=tmp("Item6")
			if $D(tmp("Item7")) s a.Item7=tmp("Item7")
			if $D(tmp("Item8")) s a.Item8=tmp("Item8")
			if $D(tmp("Item9")) s a.Item9=tmp("Item9")
			if $D(tmp("Item10")) s a.Item10=tmp("Item10")
			if $D(tmp("Item21")) s a.Item21=tmp("Item21")
			
			if $D(tmp("Item11")) s a.Item11=tmp("Item11")
			if $D(tmp("Item12")) s a.Item12=tmp("Item12")
			if $D(tmp("Item13")) s a.Item13=tmp("Item13")
			if $D(tmp("Item14")) s a.Item14=tmp("Item14")	
			if $D(tmp("Item15")) s a.Item15=tmp("Item15")
			if $D(tmp("Item16")) s a.Item16=tmp("Item16")
			if $D(tmp("Item17")) s a.Item17=tmp("Item17")
			if $D(tmp("Item18")) s a.Item18=tmp("Item18")
			if $D(tmp("Item19")) s a.Item19=tmp("Item19")				
	       if $D(tmp("Item20")) s a.Item20=tmp("Item20")
			if $D(tmp("Item22")) s a.Item22=tmp("Item22")
		if (type="Day")
		{
			s a.DayWork=1
			
		}
		elseif (type="Night")
		{
			s a.NightWork=1
			

		}
		else
		{
			s a.DayWork=1
			s a.NightWork=1
			
		}
		
		if $D(tmp("Item23")) s a.Item23=tmp("Item23")
		if $D(tmp("Item24")) s a.Item24=tmp("Item24")	
		if $D(tmp("Item25")) s a.Item25=tmp("Item25")
		if $D(tmp("Item26")) s a.Item26=tmp("Item26")
		if $D(tmp("Item27")) s a.Item27=tmp("Item27")
		if $D(tmp("Item28")) s a.Item28=tmp("Item28")
		if $D(tmp("Item29")) s a.Item29=tmp("Item29")
		if $D(tmp("Item30")) s a.Item30=tmp("Item30")
        d a.%Save()
        q 0
}

ClassMethod getparentid(locId, CareDate, user) As %String
{
   s rw=""  s rw=$O(^User.DHCNurWardShiftI("LocDate"," "_locId,CareDate,""))
   if rw=""  s a=##class(User.DHCNurWardShift).%New()
   e  q rw
   s a.LocDr=locId
   s a.CareDate=CareDate
   s a.RecUser=user
   d a.%Save()
   q a.%Id()
}

Storage Default
{
<Data name="DHCNurWardShiftDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RecDate</Value>
</Value>
<Value name="3">
<Value>RecTime</Value>
</Value>
<Value name="4">
<Value>RecUser</Value>
</Value>
<Value name="5">
<Value>CareDate</Value>
</Value>
<Value name="6">
<Value>LocDr</Value>
</Value>
<Value name="7">
<Value>Item1</Value>
</Value>
<Value name="8">
<Value>Item2</Value>
</Value>
<Value name="9">
<Value>Item3</Value>
</Value>
<Value name="10">
<Value>Item4</Value>
</Value>
<Value name="11">
<Value>Item5</Value>
</Value>
<Value name="12">
<Value>Item6</Value>
</Value>
<Value name="13">
<Value>Item7</Value>
</Value>
<Value name="14">
<Value>Item8</Value>
</Value>
<Value name="15">
<Value>Item9</Value>
</Value>
<Value name="16">
<Value>Item10</Value>
</Value>
<Value name="17">
<Value>Item11</Value>
</Value>
<Value name="18">
<Value>Item12</Value>
</Value>
<Value name="19">
<Value>Item13</Value>
</Value>
<Value name="20">
<Value>Item14</Value>
</Value>
<Value name="21">
<Value>Item15</Value>
</Value>
<Value name="22">
<Value>Item16</Value>
</Value>
<Value name="23">
<Value>Item17</Value>
</Value>
<Value name="24">
<Value>Item18</Value>
</Value>
<Value name="25">
<Value>Item19</Value>
</Value>
<Value name="26">
<Value>Item20</Value>
</Value>
<Value name="27">
<Value>Item21</Value>
</Value>
<Value name="28">
<Value>Item22</Value>
</Value>
<Value name="29">
<Value>Item23</Value>
</Value>
<Value name="30">
<Value>Item24</Value>
</Value>
<Value name="31">
<Value>Item25</Value>
</Value>
<Value name="32">
<Value>Item26</Value>
</Value>
<Value name="33">
<Value>Item27</Value>
</Value>
<Value name="34">
<Value>Item28</Value>
</Value>
<Value name="35">
<Value>Item29</Value>
</Value>
<Value name="36">
<Value>Item30</Value>
</Value>
<Value name="37">
<Value>DayWork</Value>
</Value>
<Value name="38">
<Value>NightWork</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurWardShiftD</DataLocation>
<DefaultData>DHCNurWardShiftDefaultData</DefaultData>
<IdLocation>^User.DHCNurWardShiftD</IdLocation>
<IndexLocation>^User.DHCNurWardShiftI</IndexLocation>
<StreamLocation>^User.DHCNurWardShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
