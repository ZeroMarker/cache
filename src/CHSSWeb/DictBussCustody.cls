/// 
/// App:从指标项目定义表中取出指标项目
/// CreateDate:2010-05-13
/// Created By : zwp
/// 
Class CHSSWeb.DictBussCustody Extends %RegisteredObject
{

/// 二级指标
ClassMethod GetFirstGradeIndexJD(Start, Limit) As %String
{
  s rs=##class(%ResultSet).%New()
  d rs.Prepare("Select RowId,IndexContent from CHSS.DictBussCustodyIndex WHERE RowidParref>0 ORDER BY RowId")
  d rs.Execute()
  Set start=$G(Start)
  Set limit=$G(Limit)
  Set end = start+limit
  Set json = ##class(Code.JsonObj).%New()
  s mess="",count=0
  while (rs.Next())
  {
	s RowId=rs.Get("RowId")	  
    s IndexContent=rs.Get("IndexContent")
    s temp=RowId_"^"_IndexContent
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(temp)
	}
	s resultString = json.getJsonData("RowId^IndexContent",count)
	k json	
	Quit resultString
}

/// 取出某一级指标下的二级指标
ClassMethod GetSecondGradeIndexJD(parref As %String = "", year, communitycode) As %String
{
  s parref=$g(parref)
  s rs=##class(%ResultSet).%New()
  i parref>0 d
  .d rs.Prepare("Select RowId,IndexContent,RowIdParref from CHSS.DictBussCustodyIndex WHERE RowidParref="_parref_" ORDER BY RowId")
  e  d
  .d rs.Prepare("Select RowId,IndexContent,RowIdParref from CHSS.DictBussCustodyIndex WHERE RowidParref>0 ORDER BY RowId")
  d rs.Execute()
  s mess="",count=0
  while (rs.Next())
  {
	s RowId=rs.Get("RowId")	  
    s IndexContent=rs.Get("IndexContent")	  
	s par=rs.Get("RowIdParref")	  

	s parRowId="",parIndexContent=""
	if par>0 d
	.s parObj=##class(CHSS.DictBussCustodyIndex).%OpenId(par)
	.s parRowId=par
	.s parIndexContent=parObj.IndexContent
	.d parObj.%Close()
	
	s count=count+1
	i (mess'="") s mess=mess_","
	s mess=mess_"{"_"RowId"_":"_""""_RowId_""""
	s mess=mess_","_"IndexContent"_":"_""""_IndexContent_""""
	s mess=mess_","_"parRowId"_":"_""""_parRowId_""""
	s mess=mess_","_"parIndexContent"_":"_""""_parIndexContent_""""
	s mess=mess_","_"result"_":"_""""_..getValue(IndexContent,year,communitycode)_""""
	s mess=mess_"}"
  
  }
 s mess="["_mess_"]"
 s mess="{"_"totalCount"_":"_""""_count_""""_","_"topics"_":"_mess_"}"
 q mess
}

ClassMethod getValue(IndexContent, year, communitycode)
{
	 s value=""
	 if (IndexContent="健康档案建档率"){
		  s value=..HealthBuild(communitycode,year)
		 }
	 if (IndexContent="健康档案合格率"){
		  s value=..RecordQualified(communitycode,year)
		 }
	 if (IndexContent="健康知识知晓率"){
		 s value=..HealthKnows(communitycode,year)
		 }
	 if (IndexContent="建证率"){
		  s value=..PreSeedBuild(communitycode,year)
		 }
	 if (IndexContent="疫苗接种率"){
		  s value=..PreSeed(communitycode,year)
		 }
	 if (IndexContent="传染病报告率"){
		 
		 }
	 if (IndexContent="传染病报告及时率"){
		 
		 }
	 if (IndexContent="传染病报告准确率"){
		 
		 }
	 if (IndexContent="传染病处理"){
		 
		 }
	 if (IndexContent="结核病防治"){
		 
		 }
	 if (IndexContent="艾滋病防制"){
		 
		 }
	 if (IndexContent="新生儿访视率"){
		 s value=..childBirthView(communitycode,year)
		 }
	  if (IndexContent="儿童系统管理率"){
	     s value=..childSysManage(communitycode,year)
		 }
		 
	if (IndexContent="早孕建册率"){
	
		 }
		 
	if (IndexContent="产前健康管理率"){
	     s value=..PrenatalHealthManage(communitycode,year)
		 }
		 
	if (IndexContent="产后访视率"){
		 s value=..AfterPrenatalHealthManage(communitycode,year)
		 }
	 if (IndexContent="老年人健康管理率") {
		 s value=..ElderManage(communitycode,year)
		 }
	if (IndexContent="健康检查表完整率") {
	     s value=..ElderManageComplete(communitycode,year)
		 }
	if (IndexContent="高血压患者健康管理率"){
	     s value=..HBPManage(communitycode,year)
	     }
	if (IndexContent="高血压患者规范管理率"){
	
	     }
	 if (IndexContent="2型糖尿病患者健康管理率"){
		 s value=..DiabetesManage(communitycode,year)
		 }
	if (IndexContent="2型糖尿病患者规范健康管理率"){
	
		 }
     if (IndexContent="重性精神疾病患者管理率"){
          s value=..SchizoManage(communitycode,year)
         }
     if (IndexContent="重性精神疾病患者规范管理率"){
       
         }
    if (IndexContent="儿童服务满意率"){
	
		 }
	if (IndexContent="孕产妇服务满意率"){
	
		 }
     if (IndexContent="老年人服务满意率"){
         
         }
     if (IndexContent="慢性病患者服务满意率"){
         
         }
	 
	
	 
	 
	 q value
}

//健康档案建档率       建档率=建档人数/机构覆盖常住居民数×100%

ClassMethod HealthBuild(communitycode, dyear)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 s dyear=$g(dyear)
	s startdate=dyear_"-01-01"
	S enddate=dyear_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	&sql(select count(*) into:recordnum from chss.personhealthrecordmain where communitycode=:communitycode)
	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
	
	
	&sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='健康档案建档率' and  itemrowid->Description='机构覆盖常住居民数' and year=:dyear)
	s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0


	 if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//健康档案合格率       合格率=填写合格的档案份数/抽查档案总份数×100%

ClassMethod RecordQualified(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	;w startdate,!
	;w enddate,!
	//填写合格的档案份数
	s recordnum=7
	 ;&sql(select count(*) into:recordnum from chss.personhealthrecordmain where communitycode=:communitycode and DateRegister>=:startdate and DateRegister<=:enddate)
	//抽查档案总份数
	 &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='健康档案合格率' and  itemrowid->Description='抽查档案总份数' and year=:year)
	; w recordnum,!
	s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
	 if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//健康知识知晓率       健康知识知晓率=辖区居民基本知晓合格人数/抽样人数×100%

ClassMethod HealthKnows(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	;w startdate,!
	;w enddate,!
	//辖区居民基本知晓合格人数
	s recordnum=8
	 ;&sql(select count(*) into:recordnum from chss.personhealthrecordmain where communitycode=:communitycode and DateRegister>=:startdate and DateRegister<=:enddate)
	//抽样人数
	 &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='健康知识知晓率' and  itemrowid->Description='抽样人数' and year=:year)
	s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
	; w recordnum,!
	 if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//预防接种建证率       建证率=年度辖区内建立预防接种证人数/年度辖区内应建立预防接种证人数×100%

ClassMethod PreSeedBuild(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	
	&sql(select count(distinct PersonRowidParref) into:recordnum from CHSS.ChildPlanedImmuCard where dinovoldate>=:startdate and dinovoldate<=:enddate)
   	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
   
    &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='建证率' and  itemrowid->Description='年度辖区内应建立预防接种证人数' and year=:year)	
   s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
   ;&sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid='2' and  itemrowid->Description='年度辖区内应建立预防接种证人数' and year=:year)	
    ;w totalnum,!
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//预防接种疫苗接种率   疫苗接种率=接种的适龄儿童数/登记的适龄儿童数×100%×校正系数，校正系数=按免疫程序接种的适龄儿童数/随机抽取的适龄儿童数

ClassMethod PreSeed(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	//接种的适龄儿童数
	&sql(select count(distinct immucardrowid) into:recordnum  from chss.ImmunityBacterinRecord  where immunitystatus='true' and   ImmunityDate<=:enddate  and ImmunityDate>=:startdate)
		s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
	
	
	//辖区内所有居住满3个月的0～6岁儿童
    &sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>=0 and DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})<=6 and  DATEDIFF('mm',CHSS.PersonHealthRecordMain.DateInput,{fn CURDATE()})>=3 and DateInput<=:enddate  and DateInput>=:startdate)
    s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
    
    //按免疫程序接种的适龄儿童数
    //随机抽取的适龄儿童数
    //校正系数   目前设置为1
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//传染病报告和处理传染病报告率     报告率=网络直报病例数/登记病例数×100％

//传染病报告及时率                 及时率=及时报告病例数/网络直报病例数×100％

ClassMethod InfectiousReportTime(communitycode, year)
{
}

//传染病报告准确率                  准确率=正确报告病例数/网络直报病例数×100％。

ClassMethod InfectiousTrueReport(communitycode, year)
{
}

//传染病处理                       传染病处理率=辖区内处理传染病例数/辖区内实际传染病发生例数

//结核病防治      辖区非住院结核病人建档率＝辖区内已经建档的非住院结核病人数/辖区内非住院结核病人数×100%。

//结核病人追踪管理率＝接受追踪督导管理的结核病人数/辖区已经建档的结核病人数×100%

//艾滋病防制     艾滋病管理率=接受追踪督导管理的艾滋病人数/辖区已经建档的艾滋病人数×100%

//0-36个月儿童健康管理新生儿访视率  访视率=年度辖区内接受1次及以上访视的新生儿人数/年度辖区内活产数×100%×校正系数，校正系数=接受访视新生儿数/抽查新生儿数。

ClassMethod childBirthView(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	//年度辖区内接受1次及以上访视的新生儿人数
	&sql(select count(rowid) into:recordnum  from chss.childfirstcheck  where    DateOfCheck<=:enddate  and DateOfCheck>=:startdate and childrowid->communitycode=:communitycode)
		s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
	
	//年度辖区内活产数
    ;&sql(select isnull(sum(FetusNum),0) into:totalnum from CHSS.WhBirthRecord where WomanRowId->CommunityCode =:CommunityCode and  DateOfBirth<=:enddate  and DateOfBirth>=:startdate)
    &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='新生儿访视率' and  itemrowid->Description='年度辖区内活产数' and year=:year)	
    s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
    //抽查新生儿人数
    //接受访视新生儿数
    //校正系数   目前设置为1
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//儿童系统管理率   系统管理率=年度辖区中按相应频次要求管理的0～36个月儿童数/年度辖区内应管理的0～36个月儿童数×100％×校正系数，校正系数=规范管理儿童数/抽查儿童数。

ClassMethod childSysManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	//年度辖区中按相应频次要求管理的0～36个月儿童数
	&sql(select  count(pp.pchildrowid) into:recordnum from (
        select childrowid as pchildrowid,sum(p.one) as onep,sum(p.two) as twop,sum(p.three)  as threep from (
        select childrowid, (case when(checkmonth in ('1','2','3','4','5','6','7','8','9','10','11') )then 1 else 0 end) as one,
        (case when(checkmonth<24 and checkmonth in ('12','13','14','15','16','17','18','19','20','21','22','23','24'))then 1 else 0 end) as two,
        (case when(checkmonth<36 and checkmonth in ('25','26','27','28','29','30','31','32','33','34','35','36'))then 1 else 0 end) as three from CHSS.childcheckrecord where DateOfCheck<=:enddate  and DateOfCheck>=:startdate and childrowid->communitycode=:communitycode
        )
         p  group by p.childrowid) pp where pp.onep>=4 and pp.twop>=2 and pp.threep>=2
    )
    	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
	
    
	//年度辖区内应管理的0～36个月儿童数
     &sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('mm',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>=0 and DATEDIFF('mm',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})<=36  and DateInput<=:enddate  and DateInput>=:startdate)
      s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
     
     //抽查儿童数
    //规范管理儿童数
     //校正系数   目前设置为1
    ;w recordnum,!
    ;w totalnum,!
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//孕产妇健康管理  建册率=辖区内怀孕12周之前建册的人数/该地该时间段内活产数×100％

//产前健康管理率   产前管理率=辖区内按照规范要求在孕期接受5次及以上产前随访服务的人数/该地该时间段内活产数×100％×校正系数，校正系数=接受规范随访人数/抽查孕妇数。

ClassMethod PrenatalHealthManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	//辖区内按照规范要求在孕期接受5次及以上产前随访服务的人数
	&sql(select count(num) into:recordnum from (select count(womanrowidparref)  as num from chss.WhAntepartumRecheck  where checkDate<=:enddate  and checkDate>=:startdate  group by womanrowidparref) a where a.num>=4 )
		s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
	
	//该地该时间段内活产数
     &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='产前健康管理率' and  itemrowid->Description='该地该时间段内活产数' and year=:year)	
     s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
 
 //接受规范随访人数
    //抽查孕妇数
    //校正系数   目前设置为1
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//产后访视率       产后访视率=辖区内产后28天内的接受过1次及1次以上产后访视的产妇人数/该地该时间段活产数×100％×校正系数，校正系数=接受规范访视人数/抽查产妇数。

ClassMethod AfterPrenatalHealthManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	//辖区内产后28天内的接受过1次及1次以上产后访视的产妇人数
	&sql(select count(distinct womanrowid) into:recordnum from chss.WhAfterBirthVisitRecord  where checkDate<=:enddate  and checkDate>=:startdate )
		s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
	
	//该地该时间段内活产数
     &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='产后访视率' and  itemrowid->Description='该地该时间段内活产数' and year=:year)	
    s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
    //接受规范访视人数
    //抽查孕妇数
    //校正系数   目前设置为1
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//老年人健康管理  老年人健康管理率=接受健康管理人数/年内辖区内65岁及以上常住居民数×100％。

ClassMethod ElderManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	
	&sql(select count(distinct(a.personrowid))  into:recordnum from chss.ElerlyHealthCheckRecord a left join CHSS.PersonHealthRecordMain b on a.personrowid=b.personrowid where  b.communitycode=:communitycode)
   	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
   
   
    &sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>=65 and DateInput<=:enddate  and DateInput>=:startdate)	
	s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0

     if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//老年人健康管理健康体检表完整率  健康体检表完整率=填写完整的健康体检表数/抽样的健康体检表数×100％。

ClassMethod ElderManageComplete(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	
	;&sql(select count(distinct(a.personrowid))  into:recordnum from chss.ElerlyHealthCheckRecord a left join CHSS.PersonHealthRecordMain b on a.personrowid=b.personrowid where  b.communitycode=:communitycode)
    //填写完整的健康体检表数
    s recordnum=10
    ;&sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>=65 and DateInput<=:enddate  and DateInput>=:startdate)	
    //抽样的健康体检表数
    &sql(select WorkValue into:totalnum from CHSS.DictWorkIndexVsItem where indexrowid->IndexContent='健康体检表完整率' and  itemrowid->Description='抽样的健康体检表数' and year=:year)	
    s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
   if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//高血压患者管理  高血压患者健康管理率=年内已管理高血压人数/年内辖区内高血压患病总人数×100％

//注：辖区高血压患病总人数估算：辖区18岁以上人口总数×18%。

ClassMethod HBPManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	
	&sql(select count(a.PersonRowIdParref) into:recordnum from CHSS.PersonHealthDiagnose a left join CHSS.PersonHealthRecordMain b on a.personrowidparref=b.personrowid where a.ItemdCode = '22' and a.ItemAssortName = '高血压' and b.communitycode=:communitycode)
   	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
   
   
    &sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>18 and DateInput<=:enddate  and DateInput>=:startdate)	
    s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//高血压患者规范管理率   规范管理率=按照要求进行高血压患者管理的人数/年内管理高血压患者人数×100％×校正系数，校正系数=规范管理病人数/抽查患者数。

//2型糖尿病患者管理  // 2型糖尿病患者健康管理率=年内已管理糖尿病人数/年内辖区内糖尿病患病总人数×100％。

// 注：辖区糖尿病患病总人数估算：辖区18岁以上人口总数×1.6%。

ClassMethod DiabetesManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	
	&sql(select count(a.PersonRowIdParref) into:recordnum from CHSS.PersonHealthDiagnose a left join CHSS.PersonHealthRecordMain b on a.personrowidparref=b.personrowid where a.ItemdCode = '22' and a.ItemAssortName = '糖尿病' and b.communitycode=:communitycode)
    	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
    
    
    
    &sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>18 and DateInput<=:enddate  and DateInput>=:startdate)		
   s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0


 if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//2型糖尿病患者管理  规范管理率=按照要求进行糖尿病患者健康管理的人数/年内管理糖尿病患者人数×100％×校正系数，校正系数=规范管理患者数/抽查患者数。

//重性精神病患者管理   重性精神疾病患者管理率 所有登记在册的确诊重性精神疾病患者数/（辖区内15岁及以上人口总数×0.1%）×100％。

ClassMethod SchizoManage(communitycode, year)
{
	 s recordnum=0
	 s totalnum=0
	 s returnValue=0
	 
	 
	s startdate=year_"-01-01"
	S enddate=year_"-12-31"
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	
	&sql(select count(a.PersonRowIdParref) into:recordnum from CHSS.PersonHealthDiagnose a left join CHSS.PersonHealthRecordMain b on a.personrowidparref=b.personrowid where a.ItemdCode = '22' and a.ItemAssortName = '精神病' and b.communitycode=:communitycode)
   	s sqld=SQLCODE
	i sqld=100 d
	.s recordnum=0
   
   
    &sql(select count(PersonRowId) into:totalnum from  CHSS.PersonHealthRecordMain where DATEDIFF('yy',CHSS.PersonHealthRecordMain.Birth,{fn CURDATE()})>15 and DateInput<=:enddate  and DateInput>=:startdate)		
    s sqlc=SQLCODE
	i sqlc=100 d
	.s totalnum=0
    if ((recordnum'=0)&(totalnum'=0)) d
	 .s returnValue=(recordnum/totalnum)*100
	 .s retValue=$NORMALIZE(returnValue,3)
	 .i retValue<1 d
	 ..s returnValue="0"_$NORMALIZE(returnValue,3)_"%"
	 .e  d 
	 ..s returnValue=$NORMALIZE(returnValue,3)_"%"
	 ;w returnValue,!
	 i returnValue=0 s returnValue="-"
	
	 q returnValue
}

//重性精神疾病患者规范管理率  规范管理率=每年按照规范要求进行管理的确诊重性精神疾病患者数/所有登记在册的确诊重性精神疾病患者数×100％×校正系数，校正系数=规范管理患者数/抽查患者数。

// 满意度 儿童服务满意率 满意率=表示满意人数/所调查人数×100％。

//孕产妇服务满意率

//老年人服务满意率

//慢性病患者服务满意率

}
