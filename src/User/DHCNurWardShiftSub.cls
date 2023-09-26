Class User.DHCNurWardShiftSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship RecParref As User.DHCNurWardShift [ Cardinality = parent, Inverse = ChildRec ];

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Property Item101 As %String(TRUNCATE = 1);

Property Item102 As %String(TRUNCATE = 1);

Property Item103 As %String(TRUNCATE = 1);

Property Item104 As %String(TRUNCATE = 1);

Property Item105 As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Item106 As %String(MAXLEN = 1000, TRUNCATE = 1);

Property Item107 As %String(TRUNCATE = 1);

Property Item108 As %String(TRUNCATE = 1);

Property Item109 As %String(TRUNCATE = 1);

Property Item110 As %String(TRUNCATE = 1);

Property Item111 As %String(TRUNCATE = 1);

Property Item112 As %String(TRUNCATE = 1);

Property Item113 As %String(TRUNCATE = 1);

Property Item114 As %String(TRUNCATE = 1);

Property Item115 As %String(TRUNCATE = 1);

Property Item116 As %String(TRUNCATE = 1);

Property Item117 As %String(TRUNCATE = 1);

Property Item118 As %String(TRUNCATE = 1);

Property Item119 As %String(TRUNCATE = 1);

Property Item120 As %String(TRUNCATE = 1);

Property Item121 As %String(TRUNCATE = 1);

Property Item122 As %String(TRUNCATE = 1);

Property Item123 As %String(TRUNCATE = 1);

Property Item124 As %String(TRUNCATE = 1);

Property Item125 As %String(TRUNCATE = 1);

Property Item126 As %String(TRUNCATE = 1);

Property Item127 As %String(TRUNCATE = 1);

Property Item128 As %String(TRUNCATE = 1);

Property Item129 As %String(TRUNCATE = 1);

Property Item130 As %String(TRUNCATE = 1);

Property WorkType As %String(TRUNCATE = 1);

ClassMethod Save(locId, parr As %String, user, CareDate, usergroup, type) As %String
{
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	if name="EpisodeID" s name="Item107"
	  	s val=$P(itm,"|",2)
	  	s tmp(name)=val
	}
	//q 0
	s:CareDate["/" CareDate=$zdh(CareDate,4),CareDate=$zd(CareDate,3)
	if locId="" q "请选择一个科室!"
	if CareDate="" q "请选择日期!"
	s type=##class(web.DHCNurShiftExchage).GetType(CareDate)
	i (($g(type)="Night")&($p($h,",",2)<$ZTH("07:00:00"))&&($ZDH(CareDate,3)=+$h)) s CareDate=$ZD($ZDH(CareDate,3)-1,3)
	s tmp("RecUser")=user
	s par=##class(User.DHCNurWardShift).getparentid(locId, $ZDH(CareDate,3), user)
	if par="" q "请先保存汇总记录!"
	
	
	s saveDate=$ZDH(CareDate,3)
	if $g(tmp("Item103"))="" q 0
	i type="" s ^DHCNurExchagePat(locId,saveDate,tmp("Item103"))=1
	
	if $G(tmp("rw"))'="" s tmp("Id")=par_"||"_tmp("rw")
	if $G(tmp("Id"))'="" 
	{ 
		s a=##class(User.DHCNurWardShiftSub).%OpenId(tmp("Id"))
		s recuserId=a.RecUser
		i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		e  s recuser=""
		;if (usergroup'["护士长")&(user'=recuserId) q "对不起您无修改权限,请联系护士长或"_recuser
	}
	else
	{  
		s a=##class(User.DHCNurWardShiftSub).%New()
	}
		s objParrent=##class(User.DHCNurWardShift).%OpenId(par)
		s a.RecParref=objParrent
		s a.WorkType=type
		if $D(tmp("Item101")) d
		 .s:(tmp("Item101")="") tmp("Item101")="在院"
		 .s a.Item101=tmp("Item101")
		if $D(tmp("RecUser")) s a.RecUser=tmp("RecUser")
		
		if $D(tmp("Item102")) s a.Item102=tmp("Item102")
		if $D(tmp("Item103")) s a.Item103=tmp("Item103")
		if $D(tmp("Item104")) s a.Item104=tmp("Item104")	
		if $D(tmp("Item105")) s a.Item105=tmp("Item105")
		if $D(tmp("Item106")) s a.Item106=tmp("Item106")
		if $D(tmp("Item107")) s a.Item107=tmp("Item107")
		if $D(tmp("Item108")) s a.Item108=tmp("Item108")
		if $D(tmp("Item109")) s a.Item109=tmp("Item109")
		if $D(tmp("Item110")) s a.Item110=tmp("Item110")
		if $D(tmp("Item111")) s a.Item111=tmp("Item111")
		if $D(tmp("Item112")) s a.Item112=tmp("Item112")
		if $D(tmp("Item113")) s a.Item113=tmp("Item113")
		if $D(tmp("Item114")) s a.Item114=tmp("Item114")	
		if $D(tmp("Item115")) s a.Item115=tmp("Item115")
		if $D(tmp("Item116")) s a.Item116=tmp("Item116")
		if $D(tmp("Item117")) s a.Item117=tmp("Item117")
		if $D(tmp("Item118")) s a.Item118=tmp("Item118")
		if $D(tmp("Item119")) s a.Item119=tmp("Item119")				
        if $D(tmp("Item120")) s a.Item120=tmp("Item120")
		if $D(tmp("Item121")) s a.Item121=tmp("Item121")
		if $D(tmp("Item122")) s a.Item122=tmp("Item122")
		if $D(tmp("Item123")) s a.Item123=tmp("Item123")
		if $D(tmp("Item124")) s a.Item124=tmp("Item124")
		if $D(tmp("Item125")) s a.Item125=tmp("Item125")
		if $D(tmp("Item126")) s a.Item126=tmp("Item126")
		if $D(tmp("Item127")) s a.Item127=tmp("Item127")
		if $D(tmp("Item128")) s a.Item128=tmp("Item128")
		if $D(tmp("Item129")) s a.Item129=tmp("Item129")
		if $D(tmp("Item130")) s a.Item130=tmp("Item130")
        d a.%Save()
        q 0
}

ClassMethod Delete(parr As %String) As %String
{
	//s a=##class(User.DHCNurWardShiftSub).Delete("1||1^3499^结直肠护士")
	s id=$P(parr,"^",1)
	//s ^NWLog("Delete",$zd(+$h,3),$zt($p($h,",",2)))=parr
	q:id="" 0
	q:$p(id,"||",2)="" "记录没保存"
	s userId=$P(parr,"^",2)
	s usergroup=$P(parr,"^",3)
	s a=##class(User.DHCNurWardShiftSub).%OpenId(id)
	;s ^testlf("id")=id
	s recuserId=a.RecUser
	i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
	e  s recuser=""
	;q:(usergroup'["护士长")&(userId'=recuserId) "对不起您无修改权限,请联系护士长或"_recuser
	s ^PJFDeleteWardShiftSub(id)=recuser
	s a.Item110=1
	d a.%Save()
	;d ##class(User.DHCNurWardShiftSub).%DeleteId(id)
	q 0
}

ClassMethod UnDelete(parr As %String) As %String
{
	//s a=##class(User.DHCNurWardShiftSub).Delete("1||1^3499^结直肠护士")
	s id=$P(parr,"^",1)
	
	q:id="" 0
	q:$p(id,"||",2)="" "记录没保存"
	s userId=$P(parr,"^",2)
	s usergroup=$P(parr,"^",3)
	s a=##class(User.DHCNurWardShiftSub).%OpenId(id)
	;s ^testlf("id")=id
	s recuserId=a.RecUser
	i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
	e  s recuser=""
	;q:(usergroup'["护士长")&(userId'=recuserId) "对不起您无修改权限,请联系护士长或"_recuser
	s ^PJFDeleteWardShiftSub(id)=recuser
	s a.Item110=""
	s sc=a.%Save()
	d $System.Status.DisplayError(sc)
	;d ##class(User.DHCNurWardShiftSub).%DeleteId(id)
	q 0
}

// w ##class(User.DHCNurWardShiftSub).inRecord(781,"16/04/2018","DHCNURXH2")

ClassMethod inRecord(Adm, CareDate, RecTyp) As %String
{
	s ret=""
	s AmMeasure=""
	s PmMeasure=""
	s StDate=##class(websys.Conversions).DateHtmlToLogical(CareDate)
	s AmTime=$ZTH("7:00")
	s PmTime=$ZTH("16:00")
	s par=""
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	s AmRw=""
	s AmRw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,StDate,AmTime,par,AmRw)) 
	s PmRw=""
	s PmRw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,StDate,PmTime,par,PmRw)) 
	i AmRw'="" d
	.s AmId=##class(Nur.DHCNurseRecSub).%OpenId(par_"||"_AmRw)
	.s AmMeasure=AmId.CaseMeasure
	i PmRw'="" d
	.s PmId=##class(Nur.DHCNurseRecSub).%OpenId(par_"||"_PmRw)
	.s PmMeasure=PmId.CaseMeasure
	s ret=AmMeasure_"@"_PmMeasure
	q ret
}

Storage Default
{
<Data name="DHCNurWardShiftSubDefaultData">
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
<Value>Item101</Value>
</Value>
<Value name="6">
<Value>Item102</Value>
</Value>
<Value name="7">
<Value>Item103</Value>
</Value>
<Value name="8">
<Value>Item104</Value>
</Value>
<Value name="9">
<Value>Item105</Value>
</Value>
<Value name="10">
<Value>Item106</Value>
</Value>
<Value name="11">
<Value>Item107</Value>
</Value>
<Value name="12">
<Value>Item108</Value>
</Value>
<Value name="13">
<Value>Item109</Value>
</Value>
<Value name="14">
<Value>Item110</Value>
</Value>
<Value name="15">
<Value>Item111</Value>
</Value>
<Value name="16">
<Value>Item112</Value>
</Value>
<Value name="17">
<Value>Item113</Value>
</Value>
<Value name="18">
<Value>Item114</Value>
</Value>
<Value name="19">
<Value>Item115</Value>
</Value>
<Value name="20">
<Value>Item116</Value>
</Value>
<Value name="21">
<Value>Item117</Value>
</Value>
<Value name="22">
<Value>Item118</Value>
</Value>
<Value name="23">
<Value>Item119</Value>
</Value>
<Value name="24">
<Value>Item120</Value>
</Value>
<Value name="25">
<Value>Item121</Value>
</Value>
<Value name="26">
<Value>Item122</Value>
</Value>
<Value name="27">
<Value>Item123</Value>
</Value>
<Value name="28">
<Value>Item124</Value>
</Value>
<Value name="29">
<Value>Item125</Value>
</Value>
<Value name="30">
<Value>Item126</Value>
</Value>
<Value name="31">
<Value>Item127</Value>
</Value>
<Value name="32">
<Value>Item128</Value>
</Value>
<Value name="33">
<Value>Item129</Value>
</Value>
<Value name="34">
<Value>Item130</Value>
</Value>
<Value name="35">
<Value>WorkType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRec")</DataLocation>
<DefaultData>DHCNurWardShiftSubDefaultData</DefaultData>
<IdLocation>^User.DHCNurWardShiftC("ChildRec")</IdLocation>
<IndexLocation>^User.DHCNurWardShiftSubI</IndexLocation>
<StreamLocation>^User.DHCNurWardShiftSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
