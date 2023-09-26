/// 
/// 
/// 文章管理
Class DHCMGNUR.MgNurArticleManage Extends %Persistent
{

/// 类别
Property ArtCategory As %String;

/// 杂志名称
Property ArtMagazine As %String;

/// 文章题目
Property ArtTitle As %String(TRUNCATE = 1);

/// 发表日期
Property ArtDate As %Library.Date(FORMAT = 1);

/// 卷
Property ArtVolume As %String(TRUNCATE = 1);

/// 期
Property ArtTerm As %String(TRUNCATE = 1);

/// 页码
Property ArtPage As %String(TRUNCATE = 1);

/// 发表栏目
Property ArtHeading As %String;

/// 文章类型
Property ArtType As %String;

/// 第一作者
Property ArtFirAuthor As %String;

/// 通讯作者
Property ArtWriter As %String;

/// 第二作者
Property ArtSecAuthor As %String;

/// 第三作者
Property ArtThirdAuthor As %String;

/// 其他作者
Property ArtOtAuthor As %String(TRUNCATE = 1);

/// 通讯作者层级
Property ArtWriterLev As %String;

/// 通讯作者职务
Property ArtWriterHead As %String;

/// 通讯作者职称
Property ArtWriterDuty As %String;

/// 通讯作者所在大科
Property ArtWriterBig As %String(TRUNCATE = 1);

/// 通讯作者所在病房
Property ArtWriterLoc As %String(TRUNCATE = 1);

/// 第一作者护士层级
Property ArtFirAuthorLev As %String;

/// 第一作者职务
Property ArtFirAuthorHead As %String;

/// 第一作者职称
Property ArtFirAuthorDuty As %String;

/// 第一作者所在大科
Property ArtFirAuthorBig As %String(TRUNCATE = 1);

/// 第一作者所在病房
Property ArtFirAuthorLoc As %String(TRUNCATE = 1);

/// 图片路径
Property ArtImg As list Of %String(MAXLEN = 1000, TRUNCATE = 1);

Index flag On (ArtDate, ArtTitle, ArtFirAuthor);

ClassMethod Save(parr As %String) As %String
{
	//parr="artCategoryVal@34||1^artMagzineVal@36||2^artDateVal@2015-09-01^artTitleVal@测试文章^artTypeVal@37||2^volTextVal@1^artTermVal@2^artPageVal@123^artHeadComVal@35||1^artFirstAuthVal@04428^artFirAutyLevVal@12||3^artFirAuthHeadVal@22||7^artFirAuthDutyVal@28||3^artFirAuthBigVal@OutWard^artFirAuthLocVal@76^artWriterVal@00511^artWriterLevVal@12||3^artWriteHeadVal@^artWriteDutyVal@28||4^artWriteBigVal@HCClinic^artWriteLocVal@16^artSecAuthVal@00497^artThirdAuthVal@00505^artOtAuthVal@^rw@"
	s tmp="" k tmp
	d ##class(web.DHCMgNurQuarterExamComm).setArray(parr,.tmp)
	;s ^TEMP("g0916001")=parr
	s rw=tmp("rw")
	i rw="" s obj=##class(DHCMGNUR.MgNurArticleManage).%New()
	e  s obj=##class(DHCMGNUR.MgNurArticleManage).%OpenId(rw)
	i $G(tmp("artCategoryVal"))'="" s obj.ArtCategory=tmp("artCategoryVal")
	e  s obj.ArtCategory=""
	i $G(tmp("artDateVal"))'="" s obj.ArtDate=$ZDH(tmp("artDateVal"),3)
	e  s obj.ArtDate=""
	i $G(tmp("artFirAuthBigVal"))'="" s obj.ArtFirAuthorBig=tmp("artFirAuthBigVal")
	e  s obj.ArtFirAuthorBig=""
	i $G(tmp("artFirAuthDutyVal"))'="" s obj.ArtFirAuthorDuty=tmp("artFirAuthDutyVal")
	e  s obj.ArtFirAuthorDuty=""
	i $G(tmp("artFirAuthHeadVal"))'="" s obj.ArtFirAuthorHead=tmp("artFirAuthHeadVal")
	e  s obj.ArtFirAuthorHead=""
	i $G(tmp("artFirAuthLocVal"))'="" s obj.ArtFirAuthorLoc=tmp("artFirAuthLocVal")
	e  s obj.ArtFirAuthorLoc=""
	i $G(tmp("artFirAuthLevVal"))'="" s obj.ArtFirAuthorLev=tmp("artFirAuthLevVal")
	e  s obj.ArtFirAuthorLev=""
	i $G(tmp("artFirstAuthVal"))'="" s obj.ArtFirAuthor=tmp("artFirstAuthVal")
	e  s obj.ArtFirAuthor=""
	i $G(tmp("artHeadComVal"))'="" s obj.ArtHeading=tmp("artHeadComVal")
	e  s obj.ArtHeading=""
	i $G(tmp("artMagzineVal"))'="" s obj.ArtMagazine=tmp("artMagzineVal")
	e  s obj.ArtMagazine=""
	i $G(tmp("artOtAuthVal"))'="" s obj.ArtOtAuthor=tmp("artOtAuthVal")
	e  s obj.ArtOtAuthor=""
	i $G(tmp("artPageVal"))'="" s obj.ArtPage=tmp("artPageVal")
	e  s obj.ArtPage=""
	i $G(tmp("artSecAuthVal"))'="" s obj.ArtSecAuthor=tmp("artSecAuthVal")
	e  s obj.ArtSecAuthor=""
	i $G(tmp("artTermVal"))'="" s obj.ArtTerm=tmp("artTermVal")
	e  s obj.ArtTerm=""
	i $G(tmp("artThirdAuthVal"))'="" s obj.ArtThirdAuthor=tmp("artThirdAuthVal")
	e  s obj.ArtThirdAuthor=""
	i $G(tmp("artTitleVal"))'="" s obj.ArtTitle=tmp("artTitleVal")
	e  s obj.ArtTitle=""
	i $G(tmp("artTypeVal"))'="" s obj.ArtType=tmp("artTypeVal")
	e  s obj.ArtType=""
	i $G(tmp("artWriteBigVal"))'="" s obj.ArtWriterBig=tmp("artWriteBigVal")
	e  s obj.ArtWriterBig=""
	i $G(tmp("artWriteDutyVal"))'="" s obj.ArtWriterDuty=tmp("artWriteDutyVal")
	e  s obj.ArtWriterDuty=""
	i $G(tmp("artWriteHeadVal"))'="" s obj.ArtWriterHead=tmp("artWriteHeadVal")
	e  s obj.ArtWriterHead=""
	i $G(tmp("artWriteLocVal"))'="" s obj.ArtWriterLoc=tmp("artWriteLocVal")
	e  s obj.ArtWriterLoc=""
	i $G(tmp("artWriterLevVal"))'="" s obj.ArtWriterLev=tmp("artWriterLevVal")
	e  s obj.ArtWriterLev=""
	i $G(tmp("artWriterVal"))'="" s obj.ArtWriter=tmp("artWriterVal")
	e  s obj.ArtWriter=""
	i $G(tmp("volTextVal"))'="" s obj.ArtVolume=tmp("volTextVal")
	e  s obj.ArtVolume=""
	d obj.%Save()
	q obj.%Id()
}

ClassMethod isExist(parr As %String) As %String
{
	//parr="2015-09-16^测试文章题目^04428^28"
	s date=$P(parr,"^",1)
	i date'="" s date=$ZDH(date,3)
	q:date=""
	s title=$ZConvert($P(parr,"^",2),"U")
	s nurse=$P(parr,"^",3)
	s rw=$P(parr,"^",4)
	s retVal=0
	s retVal=$O(^DHCMGNUR.MgNurArticleManageI("flag",date," "_title," "_nurse,""))
	i retVal=rw s retVal=0
	e  i ((retVal'="")&&(retVal'=rw)) s retVal=1
	e  i retVal="" s retVal=0
	q retVal
}

ClassMethod getVal(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'="" 
	{
		s obj=##class(DHCMGNUR.MgNurArticleManage).%OpenId(id)
		s category=obj.ArtCategory
		s arttitle=obj.ArtTitle
		s voltext=obj.ArtVolume
		s artheadcom=obj.ArtHeading
		s artfirstauth=obj.ArtFirAuthor
		s artmagazine=obj.ArtMagazine
		i obj.ArtDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s artdate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ArtDate)
		.e  s artdate=""
		e  s artdate=""
		s artterm=obj.ArtTerm
		s arttype=obj.ArtType
		s artfirauthlev=obj.ArtFirAuthorLev
		s artpage=obj.ArtPage
		s artfirauthhead=obj.ArtFirAuthorHead
		s artfirauthduty=obj.ArtFirAuthorDuty
		s artfirauthbig=obj.ArtFirAuthorBig
		s artfirauthloc=obj.ArtFirAuthorLoc
		s artwriter=obj.ArtWriter
		s artwriterlev=obj.ArtWriterLev
		s artwriterhead=obj.ArtWriterHead
		s artwriterduty=obj.ArtWriterDuty
		s artwriterbig=obj.ArtWriterBig
		s artwriterloc=obj.ArtWriterLoc
		s artsecauth=obj.ArtSecAuthor
		s artthirdauth=obj.ArtThirdAuthor
		s artotauth=obj.ArtOtAuthor
		s ret="category@"_category_"^arttitle@"_arttitle_"^voltext@"_voltext_"^artheadcom@"_artheadcom_"^artfirstauth@"_artfirstauth_"^artmagazine@"_artmagazine_"^artdate@"_artdate_"^artterm@"_artterm_"^arttype@"_arttype_"^artfirauthlev@"_artfirauthlev_"^artpage@"_artpage_"^artfirauthhead@"_artfirauthhead_"^artfirauthduty@"_artfirauthduty_"^artfirauthbig@"_artfirauthbig_"^artfirauthloc@"_artfirauthloc_"^artwriter@"_artwriter_"^artwriterlev@"_artwriterlev_"^artwriterhead@"_artwriterhead_"^artwriterduty@"_artwriterduty_"^artwriterbig@"_artwriterbig_"^artwriterloc@"_artwriterloc_"^artsecauth@"_artsecauth_"^artthirdauth@"_artthirdauth_"^artotauth@"_artotauth
	}
	q ret
}

ClassMethod saveImg(parr As %String) As %String
{
	s ret=0
	s id=$P(parr,"^",1)
	s img=$P(parr,"^",2)
	q:id=""
	s obj=##class(DHCMGNUR.MgNurArticleManage).%OpenId(id)
	;i obj.ArtImg'="" d
	;.;s obj.ArtImg=obj.ArtImg_";"_img
	s sc=obj.ArtImg.Insert(img)
	d obj.%Save()
	s ret=obj.%Id()
	q ret
}

ClassMethod getArtImg(id As %String) As %String
{
	q:id=""
	s ret=""
	s obj=##class(DHCMGNUR.MgNurArticleManage).%OpenId(id)
	;s ret=obj.ArtImg
	s ret=..getArticle(obj)
	b ;00001
	q ret
}

ClassMethod delArticle(id As %String, parr As %String) As %String
{
	;s ^TEMP("gdelarticle001")=id_"^"_parr
	q:id=""
	s ret=""
	s obj=##class(DHCMGNUR.MgNurArticleManage).%OpenId(id)
	s article=..getArticle(obj)
	q:article=""
	s l=obj.ArtImg.Count()
	for i=1:1:l
	{
		s item=obj.ArtImg.GetAt(i) 
		;b ;0011
		i item'=parr s ret=ret_item_";"
	}
	s ret=$E(ret,1,$L(ret)-1)
	;s obj.ArtImg=""
	d obj.ArtImg.Clear()
	d obj.%Save()
	
	s l2=$L(ret,";")
	for j=1:1:l2
	{
		s item2=$P(ret,";",j)
		s a=##class(DHCMGNUR.MgNurArticleManage).%OpenId(id)
		i item2'="" s sc=obj.ArtImg.Insert(item2)
		d a.%Save()
	}
	q a.%Id()
}

ClassMethod getArticle(itm) As %String
{
	s ret1=""
	s l=itm.ArtImg.Count()
	for i=1:1:l
	{
		s path=itm.ArtImg.GetAt(i)
		;b ;01
		s ret1=ret1_path_";"
	}
	s ret1=$E(ret1,1,$L(ret1)-1)
	q ret1
}

Storage Default
{
<Data name="MgNurArticleManageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArtCategory</Value>
</Value>
<Value name="3">
<Value>ArtMagazine</Value>
</Value>
<Value name="4">
<Value>ArtTitle</Value>
</Value>
<Value name="5">
<Value>ArtDate</Value>
</Value>
<Value name="6">
<Value>ArtVolume</Value>
</Value>
<Value name="7">
<Value>ArtTerm</Value>
</Value>
<Value name="8">
<Value>ArtPage</Value>
</Value>
<Value name="9">
<Value>ArtHeading</Value>
</Value>
<Value name="10">
<Value>ArtType</Value>
</Value>
<Value name="11">
<Value>ArtFirAuthor</Value>
</Value>
<Value name="12">
<Value>ArtWriter</Value>
</Value>
<Value name="13">
<Value>ArtSecAuthor</Value>
</Value>
<Value name="14">
<Value>ArtThirdAuthor</Value>
</Value>
<Value name="15">
<Value>ArtOTAuthor</Value>
</Value>
<Value name="16">
<Value>ArtWriterLev</Value>
</Value>
<Value name="17">
<Value>ArtWriterHead</Value>
</Value>
<Value name="18">
<Value>ArtWriterDuty</Value>
</Value>
<Value name="19">
<Value>ArtWriterBig</Value>
</Value>
<Value name="20">
<Value>ArtWriterLoc</Value>
</Value>
<Value name="21">
<Value>ArtFirAuthorLev</Value>
</Value>
<Value name="22">
<Value>ArtFirAuthorHead</Value>
</Value>
<Value name="23">
<Value>ArtFirAuthorDuty</Value>
</Value>
<Value name="24">
<Value>ArtFirAuthorBig</Value>
</Value>
<Value name="25">
<Value>ArtFirAuthorLoc</Value>
</Value>
<Value name="26">
<Value>ArtOtAuthor</Value>
</Value>
<Value name="27">
<Value>ArtImg</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurArticleManageD</DataLocation>
<DefaultData>MgNurArticleManageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurArticleManageD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurArticleManageI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurArticleManageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
