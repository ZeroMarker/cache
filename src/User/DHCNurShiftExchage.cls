Class User.DHCNurShiftExchage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeId As %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Property CareDate As %Library.Date(FORMAT = 1);

Property CareTime As %Library.Time;

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

Property Item21 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Item22 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Item23 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Item24 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Item25 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Item26 As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Item27 As %String(TRUNCATE = 1);

Property Item28 As %String(TRUNCATE = 1);

Property Item29 As %String(TRUNCATE = 1);

Property Item30 As %String(TRUNCATE = 1);

Property Item31 As %String(TRUNCATE = 1);

Property Item32 As %String(TRUNCATE = 1);

Property Item33 As %String(TRUNCATE = 1);

Property Item34 As %String(TRUNCATE = 1);

Property Item35 As %String(TRUNCATE = 1);

Property Item36 As %String(TRUNCATE = 1);

Property Item37 As %String(TRUNCATE = 1);

Property Item38 As %String(TRUNCATE = 1);

Property Item39 As %String(TRUNCATE = 1);

Property Item40 As %String(TRUNCATE = 1);

Property Item41 As %String(TRUNCATE = 1);

Property Item42 As %String(TRUNCATE = 1);

Property Item43 As %String(TRUNCATE = 1);

Property Item44 As %String(TRUNCATE = 1);

Property Item45 As %String(TRUNCATE = 1);

Property Item46 As %String(TRUNCATE = 1);

Property Item47 As %String(TRUNCATE = 1);

Property Item48 As %String(TRUNCATE = 1);

Property Item49 As %String(TRUNCATE = 1);

Property Item50 As %String(TRUNCATE = 1);

Index AdmDatTim On (EpisodeId, CareDate, CareTime);

Method ListProperties() As %String [ CodeMode = objectgenerator ]
{
  //s a=##class(web.DHCNurHdComm).ListProperties()
    k ^tdata("User.DHCNurShiftExchage")
    For i = 1:1:%compiledclass.Properties.Count() {
        Set prop = %compiledclass.Properties.GetAt(i).Name
        if $F(prop,"%")=0
        {
        s ^tdata("User.DHCNurShiftExchage",prop)=""
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
		s a=##class(User.DHCNurShiftExchage).%OpenId(id)
		s tmp=""
		if '$D(^tdata("User.DHCNurShiftExchage")) d a.ListProperties()
		s p="" f  s p=$O(^tdata("User.DHCNurShiftExchage",p)) q:p=""  d
		.s tmp(p)=$ZOBJPROPERTY(a,p)
	}
	q 0
}

ClassMethod setSpecialFlag(EpisodeID, CareDate, CareTime, Flag)
{
 	s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_$G(EpisodeID),$ZDH(CareDate,3),$ZTH(CareTime),""))
 	i Id'="" s a=##class(User.DHCNurShiftExchage).%OpenId(Id)
 	e  s a=##class(User.DHCNurShiftExchage).%New()
 	s a.Item50=Flag
 	s a.CareDate=$ZDH(CareDate,3)
 	s a.CareTime=$ZTH(CareTime)
 	s a.EpisodeId=EpisodeID
 	d a.%Save()
 	q a.%Id()
}

ClassMethod getSpecialFlag(EpisodeID, CareDate, CareTime)
{
	s ret=0
 	s Id=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_$G(EpisodeID),$ZDH(CareDate,3),$ZTH(CareTime),""))
 	i Id'="" d
 	.s a=##class(User.DHCNurShiftExchage).%OpenId(Id)
 	.s ret=a.Item50
 	q ret
}

ClassMethod Save(EpisodeID, parr As %String, user, CareDate, CareTime, usergroup) As %String
{
	//CareTime字段备用/暂固定为8点
	s CareTime="08:00:00"
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s val=$P(itm,"|",2)
	  	s tmp(name)=val
	}
	s tmp("RecUser")=user
	s tmp("EpisodeId")=EpisodeID	
	if $G(tmp("EpisodeId"))="" q "请选择一个病人!"
	s tmp("CareDate")=CareDate
	s tmp("CareTime")=CareTime
	if $G(tmp("CareDate"))="" q "请选择日期!"

    s tmp("Id")=$O(^User.DHCNurShiftExchageI("AdmDatTim"," "_$G(tmp("EpisodeId")),$ZDH(tmp("CareDate"),3),$ZTH(tmp("CareTime")),""))
	if $G(tmp("Id"))'="" 
	{ 
		s a=##class(User.DHCNurShiftExchage).%OpenId(tmp("Id"))
		s recuserId=a.RecUser
		i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		e  s recuser=""
		//if (usergroup'["护士长")&(user'=recuserId) q "对不起您无修改权限,请联系护士长或"_recuser
	}
	else
	{  
		s a=##class(User.DHCNurShiftExchage).%New()
	}
		if $D(tmp("EpisodeId")) s a.EpisodeId=tmp("EpisodeId")
		if $D(tmp("RecUser")) s a.RecUser=tmp("RecUser")
		if $D(tmp("CareDate")) s a.CareDate=$ZDH(tmp("CareDate"),3)
        if $D(tmp("CareTime")) s a.CareTime=$ZTH(tmp("CareTime"))

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
		if $D(tmp("Item21")) s a.Item21=tmp("Item21")
		if $D(tmp("Item22")) s a.Item22=tmp("Item22")
		if $D(tmp("Item23")) s a.Item23=tmp("Item23")
		if $D(tmp("Item24")) s a.Item24=tmp("Item24")	
		if $D(tmp("Item25")) s a.Item25=tmp("Item25")
		if $D(tmp("Item26")) s a.Item26=tmp("Item26")
		if $D(tmp("Item27")) s a.Item27=tmp("Item27")
		if $D(tmp("Item28")) s a.Item28=tmp("Item28")
		if $D(tmp("Item29")) s a.Item29=tmp("Item29")
		if $D(tmp("Item30")) s a.Item30=tmp("Item30")
		if $D(tmp("Item31")) s a.Item31=tmp("Item31")
		if $D(tmp("Item32")) s a.Item32=tmp("Item32")
		if $D(tmp("Item33")) s a.Item33=tmp("Item33")
		if $D(tmp("Item34")) s a.Item34=tmp("Item34")	
		if $D(tmp("Item35")) s a.Item35=tmp("Item35")
		if $D(tmp("Item36")) s a.Item36=tmp("Item36")
		if $D(tmp("Item37")) s a.Item37=tmp("Item37")
		if $D(tmp("Item38")) s a.Item38=tmp("Item38")
		if $D(tmp("Item39")) s a.Item39=tmp("Item39")
		if $D(tmp("Item40")) s a.Item40=tmp("Item40")
		if $D(tmp("Item41")) s a.Item41=tmp("Item41")
		if $D(tmp("Item42")) s a.Item42=tmp("Item42")
		if $D(tmp("Item43")) s a.Item43=tmp("Item43")
		if $D(tmp("Item44")) s a.Item44=tmp("Item44")	
		if $D(tmp("Item45")) s a.Item45=tmp("Item45")
		if $D(tmp("Item46")) s a.Item46=tmp("Item46")
		if $D(tmp("Item47")) s a.Item47=tmp("Item47")
		if $D(tmp("Item48")) s a.Item48=tmp("Item48")
		if $D(tmp("Item49")) s a.Item49=tmp("Item49")
		if $D(tmp("Item50")) s a.Item50=tmp("Item50")
        d a.%Save()
        q 0
}

Storage Default
{
<Data name="DHCNurShiftExchageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CareDate</Value>
</Value>
<Value name="3">
<Value>CareTime</Value>
</Value>
<Value name="4">
<Value>EpisodeId</Value>
</Value>
<Value name="5">
<Value>Item1</Value>
</Value>
<Value name="6">
<Value>Item10</Value>
</Value>
<Value name="7">
<Value>Item11</Value>
</Value>
<Value name="8">
<Value>Item12</Value>
</Value>
<Value name="9">
<Value>Item13</Value>
</Value>
<Value name="10">
<Value>Item14</Value>
</Value>
<Value name="11">
<Value>Item15</Value>
</Value>
<Value name="12">
<Value>Item16</Value>
</Value>
<Value name="13">
<Value>Item17</Value>
</Value>
<Value name="14">
<Value>Item18</Value>
</Value>
<Value name="15">
<Value>Item19</Value>
</Value>
<Value name="16">
<Value>Item2</Value>
</Value>
<Value name="17">
<Value>Item20</Value>
</Value>
<Value name="18">
<Value>Item21</Value>
</Value>
<Value name="19">
<Value>Item22</Value>
</Value>
<Value name="20">
<Value>Item23</Value>
</Value>
<Value name="21">
<Value>Item24</Value>
</Value>
<Value name="22">
<Value>Item25</Value>
</Value>
<Value name="23">
<Value>Item26</Value>
</Value>
<Value name="24">
<Value>Item27</Value>
</Value>
<Value name="25">
<Value>Item28</Value>
</Value>
<Value name="26">
<Value>Item29</Value>
</Value>
<Value name="27">
<Value>Item3</Value>
</Value>
<Value name="28">
<Value>Item30</Value>
</Value>
<Value name="29">
<Value>Item31</Value>
</Value>
<Value name="30">
<Value>Item32</Value>
</Value>
<Value name="31">
<Value>Item33</Value>
</Value>
<Value name="32">
<Value>Item34</Value>
</Value>
<Value name="33">
<Value>Item35</Value>
</Value>
<Value name="34">
<Value>Item36</Value>
</Value>
<Value name="35">
<Value>Item37</Value>
</Value>
<Value name="36">
<Value>Item38</Value>
</Value>
<Value name="37">
<Value>Item39</Value>
</Value>
<Value name="38">
<Value>Item4</Value>
</Value>
<Value name="39">
<Value>Item40</Value>
</Value>
<Value name="40">
<Value>Item41</Value>
</Value>
<Value name="41">
<Value>Item42</Value>
</Value>
<Value name="42">
<Value>Item43</Value>
</Value>
<Value name="43">
<Value>Item44</Value>
</Value>
<Value name="44">
<Value>Item45</Value>
</Value>
<Value name="45">
<Value>Item46</Value>
</Value>
<Value name="46">
<Value>Item47</Value>
</Value>
<Value name="47">
<Value>Item48</Value>
</Value>
<Value name="48">
<Value>Item49</Value>
</Value>
<Value name="49">
<Value>Item5</Value>
</Value>
<Value name="50">
<Value>Item50</Value>
</Value>
<Value name="51">
<Value>Item6</Value>
</Value>
<Value name="52">
<Value>Item7</Value>
</Value>
<Value name="53">
<Value>Item8</Value>
</Value>
<Value name="54">
<Value>Item9</Value>
</Value>
<Value name="55">
<Value>RecDate</Value>
</Value>
<Value name="56">
<Value>RecTime</Value>
</Value>
<Value name="57">
<Value>RecUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurShiftExchageD</DataLocation>
<DefaultData>DHCNurShiftExchageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurShiftExchageD</IdLocation>
<IndexLocation>^User.DHCNurShiftExchageI</IndexLocation>
<StreamLocation>^User.DHCNurShiftExchageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
