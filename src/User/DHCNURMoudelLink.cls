Class User.DHCNURMoudelLink Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_NURMoudelLink ]
{

Property Name As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property PrintCode As %String(TRUNCATE = 1);

Property typ As %String(TRUNCATE = 1);

Property UserREC As %String(TRUNCATE = 1);

Property RECDate As %Library.Date;

Property RECTime As %Library.Time;

Property XuFlag As %String(TRUNCATE = 1);

Property MakePic As %String(TRUNCATE = 1);

Property Upload As %String(TRUNCATE = 1);

Property PrintDays As %String(TRUNCATE = 1);

Property SortDate As %String(TRUNCATE = 1);

Property SortTime As %String(TRUNCATE = 1);

Property PrintModelPage As %String(TRUNCATE = 1);

Index CodeIndex On Code;

Index PrintCodeIndex On (Code, PrintCode);

Index PrintCode On PrintCode;

// d ##class(User.DHCNURMoudelLink).%BuildIndices()

ClassMethod getlocward(loc) As %String
{
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

// d ##class(User.DHCNURMoudelLink).GetDepModel("48")

ClassMethod GetDepModel(adm As %String) As %String
{
   s LocId=$p(^PAADM(adm),"^",4)
     s curWardId=$p($g(^PAADM(adm)),"^",70) 
     s Ward=..getlocward(LocId)
     s totelstr=""
     s max=0
     s rw="" f  s rw=$o(^DHCNurDepModelSet(rw)) q:rw=""  d
     .s DepModelStr=$G(^DHCNurDepModelSet(rw))
     .s totelstr=totelstr_"^"_DepModelStr
     b
   
     f ii=1:1:$L(totelstr,"^") d
	 .s DepModel=$P(totelstr,"^",ii)
	 .//b ;99
	 .q:DepModel=""
	 .s ModelKey=$P(DepModel,"|",1)
	 .s ModelName=$P(DepModel,"|",2)
	 .s ModelSort=$P(DepModel,"|",3)
	 .s PrintCode=""
	 .i ModelKey'="" s PrintCode=..getPrintCode(ModelKey)
	 .s flag=..GetModelDataStatus(adm,ModelKey)
	 .//b ;55
	 .i flag'=0 s DepModel(ModelKey)=ModelKey_"|"_PrintCode
	 .//s DepModel(ModelKey)=ModelKey_"|"_PrintCode
	b ;44
	s ret=""
	s sort="" f  s sort=$O(DepModel(sort)) q:sort=""  d
	.s ret=ret_DepModel(sort)_"^"
	b ;66
 	q ret
}

// d ##class(User.DHCNURMoudelLink).GetPerModel("5019351")

ClassMethod GetPerModel(adm As %String) As %String
{
    
     s ret="" 
     s ^ookk=adm
     s id="" f  s id=$O(^User.DHCNURMoudelLinkD(id)) q:id=""  d
 	 .s a=##class(User.DHCNURMoudelLink).%OpenId(id)
 	 .s PrintCode=a.PrintCode
 	 .s Code=a.Code
 	 .s typ=a.typ
 	 .q:Code="DHCNURHYD_NURSHEETS"
 	 .q:Code="DHCNURHYD_ASSESSMENT"
 	 .s flag=..GetModelDataStatus(adm,Code)
 	 .//b ;33
	 .i flag'=0 d
	 ..i ret="" s ret=Code_"^"_PrintCode_"^"_typ
	 ..e  s ret=ret_"|"_Code_"^"_PrintCode_"^"_typ
	 s Consultret=..GetAdmConsult(adm)
	 s ssret=..GetAdmss(adm)
	 i ssret'="" s ret=ret_"|"_ssret
	 s ssretpgd=..GetAdmpgd(adm)
	 i ssretpgd'="" s ret=ret_"|"_ssretpgd
	 i Consultret'="" s ret=ret_"|"_Consultret

 	q ret
}

ClassMethod GetAdmConsult(adm) As %String
{
  	//w ##class(web.DHCConsult).GetConsult("340810^2011-05-23^2011-05-25^true","addconsult")
            q:adm="" ""
            s ret=""
			s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:id=""  d
			.s a=^User.DHCConsultationD(id)
			.s status=$listget(a,16)
			.q:status="C"
			.i ret="" s ret=id_"^"_"DHCConsultPrn^会诊"
			.e  s ret=ret_"|"_id_"^"_"DHCConsultPrn^会诊"
			q ret
}

// 入院评估

// w ##class(User.DHCNURMoudelLink).GetAdmss("5043874")

ClassMethod GetAdmpgd(adm) As %String
{
  	//w ##class(web.DHCConsult).GetConsult("340810^2011-05-23^2011-05-25^true","addconsult")
            q:adm="" ""
            s ret=""
			s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," DHCNURHYD_ASSESSMENT"," "_adm,id)) q:id=""  d
			.//s a=^Nur.DHCMoudDataD(id)
			.s a=##class(Nur.DHCMoudData).%OpenId(id)
			.s Cancelname=a.Cancelname
			.//W !,Cancelname
			.q:Cancelname'=""
			.i ret="" s ret=id_"^"_"DHCNURHYD_Assessment_Prn^多次评估单"
			.e  s ret=ret_"|"_id_"^"_"DHCNURHYD_Assessment_Prn^多次评估单"
			q ret
}

// 手术

// w ##class(User.DHCNURMoudelLink).GetAdmss("7640940")

ClassMethod GetAdmss(adm) As %String
{
  	//w ##class(web.DHCConsult).GetConsult("340810^2011-05-23^2011-05-25^true","addconsult")
            q:adm="" ""
            s ret=""
			s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," DHCNURHYD_NURSHEETS"," "_adm,id)) q:id=""  d
			.//s a=^Nur.DHCMoudDataD(id)
			.set a=##class(Nur.DHCMoudData).%OpenId(id)
	        .s anaesid=a.AnaesId
	        .s status=..GetOpaStatus(anaesid)
	        .q:status="D"
	        .b ;
			.i ret="" s ret=id_"^"_"DHCNURHYD_NurSheets_Prn^多次评估单"
			.e  s ret=ret_"|"_id_"^"_"DHCNURHYD_NurSheets_Prn^多次评估单"
			q ret
}

ClassMethod GetOpaStatus(opaId As %String) As %String
{
	q:opaId="" "opaId is null"
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	q opaStatus
}

ClassMethod GetModelDataStatus(EpisodeID, EmrCode) As %String
{
	//w ##class(web.DHCMGNurData).GetModelDataStatus(11062752,"DHCNURANHUISPLIST")
	s ret=0
	s id=""
	if (EpisodeID'="")&&(EmrCode'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 i code="DHCNURANHUISPLIST" s code="DHCNURANHUI21"
	 //s ^fuckwxy(EpisodeID,code)=code
	 //s id=""  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,id))
	 //s id=""
	 s DHCMoudid=##class(Nur.DHCMoudData).GetId(code,EpisodeID)
	 //s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid))
	 //b ;4422
	 i DHCMoudid'="" s id=DHCMoudid
	 //s DHCMoudid=""  f  s DHCMoudid=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,DHCMoudid)) q:DHCMoudid=""  d
	 //.i DHCMoudid'="" d
	 //..s b=##class(Nur.DHCMoudData).%OpenId(DHCMoudid)
	 //..b ;77
	 //..i (b.RecCancelUser="") s id=DHCMoudid
	 
	 s par=""  s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,par))
	 //b ;22
	 if par'=""
	 {
	 s rw="" f  s rw=$o(^Nur.DHCNurseRecSubD(par,rw)) q:rw=""  d
	 .s tmp("Id")=par_"||"_rw
	 .s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
	 .//w !,a.RecTyp_"^"_a.RecCancelUser
	 .i (a.RecTyp=EmrCode)&&(a.RecCancelUser="") s id=tmp("Id")
	 }	 
	}
	//b ;44
	i id'="" s ret=1
	q ret
}

ClassMethod getdata() As %String
{
   s ret="" 
   s id="" f  s id=$O(^User.DHCNURMoudelLinkD(id)) q:id=""  d
 	.s a=##class(User.DHCNURMoudelLink).%OpenId(id)
 	.s PrintCode=a.PrintCode
 	
	.s ret=ret_"^rw|"_id_"^PrintCode|"_PrintCode
	q ret
}

// d ##class(User.DHCNURMoudelLink).getPrintCode("DHCNURXH2")

ClassMethod getPrintCode(RecTyp) As %String
{
   s ret="" 
   s RecTyp=$zconvert(RecTyp,"U")
   s id="" f  s id=$O(^User.DHCNURMoudelLinkI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	.s a=##class(User.DHCNURMoudelLink).%OpenId(id)
 	.s PrintCode=a.PrintCode
 	.s typ=a.typ
 	.s xuflag=a.XuFlag
 	.s makepic=a.MakePic
 	.s upload=a.Upload
	.s ret=PrintCode_"|"_typ_"|"_xuflag_"|"_makepic_"|"_upload

	q ret
}

ClassMethod Save(parr As %String, id As %String) As %String
{
	//s ^objcyfddd=parr_"&"_id
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	q:$g(tmp("Code"))="" "界面模板关键字不能为空"
	s rw=""
	s code=$zcvt(tmp("PrintCode"),"U")
	i id="" s rw=$o(^User.DHCNURMoudelLinkI("PrintCode"," "_code,""))
	q:rw'="" "该打印模板已经保存过"
	q:$g(tmp("PrintCode"))="" "打印模板关键字不能为空"
	q:$g(tmp("typ"))="" "类型不能为空"
	q:$g(tmp("Name"))="" "模板名称不能为空"
	
	
	if id=""
	{
	 s a=##class(User.DHCNURMoudelLink).%New()
	}else
	{
	 s a=##class(User.DHCNURMoudelLink).%OpenId(id)
	}
	if $D(tmp("Code")) s a.Code=tmp("Code")
	if $D(tmp("PrintCode")) s a.PrintCode=tmp("PrintCode")
	if $D(tmp("typ")) s a.typ=tmp("typ")
	if $D(tmp("MakePic")) s a.MakePic=tmp("MakePic")
	if $D(tmp("Upload")) s a.Upload=tmp("Upload")
	if $D(tmp("Name")) s a.Name=tmp("Name")
	if $g(tmp("XuFlag"))="" s a.XuFlag="N"
	else  s a.XuFlag=tmp("XuFlag")
	s a.RECDate=$p($h,",",1)
	s a.RECTime=$p($h,",",2)
	s a.UserREC=%session.Get("LOGON.USERNAME")
	
	//多次评估
	if $D(tmp("PrintDays")) s a.PrintDays=tmp("PrintDays")
	if $D(tmp("SortDate")) s a.SortDate=tmp("SortDate")
	if $D(tmp("SortTime")) s a.SortTime=tmp("SortTime")
	if $D(tmp("PrintModelPage")) s a.PrintModelPage=tmp("PrintModelPage")
	
	d a.%Save()
	q 0
}

ClassMethod QtDelete(id As %String) As %String
{
  
   s a=##class(User.DHCNURMoudelLink).%DeleteId(id)
   q 0
}

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","CRItem","parr$111")

ClassMethod getVal(id) As %String
{
	s ret=""
	
	if id'=""
	{
	s a=##class(User.DHCNURMoudelLink).%OpenId(id)	

	//多次评估
	s tmp("PrintDays")=a.PrintDays
	s tmp("SortDate")=a.SortDate
	s tmp("SortTime")=a.SortTime
	s tmp("PrintModelPage")=a.PrintModelPage	
	
	s tmp("Code")=a.Code
	s tmp("typ")=a.typ
	s tmp("Name")=a.Name
	s tmp("MakePic")=a.MakePic
	s tmp("Upload")=a.Upload
	s tmp("PrintCode")=a.PrintCode	
	s tmp("XuFlag")=a.XuFlag	
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

/// d ##class(%ResultSet).RunQuery("User.DHCNURMoudelLink","CRItem","")
ClassMethod CRItemExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s id="" f  s id=$O(^User.DHCNURMoudelLinkD(id)) q:id=""  d
 	.s a=##class(User.DHCNURMoudelLink).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=..getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
 	/*Set repid=$I(^CacheTemp)
 	s ind=1
 	s SetStr=^DHCNurDepModelSet("9000")_^DHCNurDepModelSet("All")  //取得已筛选和全院显示的配置
 	s SetStrLen=$l(SetStr,"^")
 	f i=1:1:SetStrLen d
 	.s part=$p(SetStr,"^",i)
 	.q:part=""
 	.s KCode=$p(part,"|",1)
 	.s KName=$p(part,"|",2)
 	.q:$g(TMP(KCode))'=""   //已经查询过的退出
 	.s TMP(KCode)=KName
 	.s id=$O(^User.DHCNURMoudelLinkI("CodeIndex"," "_KCode,""))
 	.i id'="" d
 	..s a=##class(User.DHCNURMoudelLink).%OpenId(id)
	..s rw=id
	..s ret=""
	..s ret=..getVal(rw)
	..s ret=ret_"^rw|"_id
	..d outtyp2
	.e  d
	..s ret="Name|"_KName_"^Code|"_KCode_"^typ|^PrintCode|^XuFlag|N^MakePic|N^Upload|N^rw|"
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK*/
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CRItem(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Storage Default
{
<Data name="DHCNURMoudelLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>PrintCode</Value>
</Value>
<Value name="5">
<Value>typ</Value>
</Value>
<Value name="6">
<Value>UserREC</Value>
</Value>
<Value name="7">
<Value>RECDate</Value>
</Value>
<Value name="8">
<Value>RECTime</Value>
</Value>
<Value name="9">
<Value>XuFlag</Value>
</Value>
<Value name="10">
<Value>MakePic</Value>
</Value>
<Value name="11">
<Value>Upload</Value>
</Value>
<Value name="12">
<Value>PrintDays</Value>
</Value>
<Value name="13">
<Value>SortDate</Value>
</Value>
<Value name="14">
<Value>SortTime</Value>
</Value>
<Value name="15">
<Value>PrintModelPage</Value>
</Value>
</Data>
<DataLocation>^User.DHCNURMoudelLinkD</DataLocation>
<DefaultData>DHCNURMoudelLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNURMoudelLinkD</IdLocation>
<IndexLocation>^User.DHCNURMoudelLinkI</IndexLocation>
<StreamLocation>^User.DHCNURMoudelLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
