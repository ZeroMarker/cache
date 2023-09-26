Import SQLUser

Class web.DHCWMRImport.PatientInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 149;

/// *************************************************************************
/// 检查数据合法性
/// PatInfo=
/// 病历号^病人姓名^病人性别^出生日期^身份证号^户口地址^民族^婚否^国籍^籍贯^
/// 工作单位^电话^手机^联系人^联系电话^联系地址^与病人关系^入院次数^单位邮编^
/// 家庭邮编^病人性质^医保号(个人编号)
/// Dics=$lb("3|病人性别","7|民族","8|婚否","9|国籍","10|籍贯","17|与病人关系","21|病人性质")
/// *************************************************************************
ClassMethod CheckPatInfo(PatInfo)
{
	n (PatInfo)
	s ErrInfo=""
	
	s Medicare=$p(PatInfo,"^",1)           //住院病历号
	s:$l(Medicare)'=8 ErrInfo=ErrInfo_"病案号不是8位!"
	s Name=$p(PatInfo,"^",2)               //姓名
	s Name=$tr(Name," ","")
	s:Name="" ErrInfo=ErrInfo_"患者姓名为空!"
	i Medicare'="" d
	.s Medicare=$$ALPHAUP^SSUTIL4(Medicare)
	.s:$d(^PAPERi("Medicare",Medicare)) ErrInfo=ErrInfo_"存在相同病案号患者记录!"
	;s Soundex1=$p(PatInfo,"^",2)_"00"      //姓名00
	;s Name2=""                             //姓名拼音(首字母)
	s SexDR=$p(PatInfo,"^",3)              //性别
	i SexDR'="" d
	.s SexDR=$p($g(^DHCWMRPersonDic("病人性别",SexDR)),"|",1)
	.s:SexDR="" ErrInfo=ErrInfo_"性别字典未对应!"
	s Dob=$p(PatInfo,"^",4)                //出生日期
	s Dob=$p(Dob," ",1)
	s:(Dob'="")&&($l(Dob,"-")'=3) ErrInfo=ErrInfo_"出生日期错误!"
	s:Dob'="" Dob=$zdh(Dob,3)
	;s ID=$p(PatInfo,"^",5)                 //身份证号
	;s StName=$p(PatInfo,"^",6)             //家庭住址(户口地址)
	s NationDR=$p(PatInfo,"^",7)           //民族
	i NationDR'="" d
	.s NationDR=$p($g(^DHCWMRPersonDic("民族",NationDR)),"|",1)
	.s:NationDR="" ErrInfo=ErrInfo_"民族字典未对应!"
	s MaritalDR=$p(PatInfo,"^",8)          //婚否
	i MaritalDR'="" d
	.s MaritalDR=$p($g(^DHCWMRPersonDic("婚否",MaritalDR)),"|",1)
	.s:MaritalDR="" ErrInfo=ErrInfo_"婚否字典未对应!"
	s CountryDR=$p(PatInfo,"^",9)          //国籍
	i CountryDR'="" d
	.s CountryDR=$p($g(^DHCWMRPersonDic("国籍",CountryDR)),"|",1)
	.s:CountryDR="" ErrInfo=ErrInfo_"国籍字典未对应!"
	;s ProvinceBirthDR=""                   //籍贯省
	s CityBirthDR=$p(PatInfo,"^",10)       //籍贯市
	i CityBirthDR'="" d
	.s CityBirthDR=$p($g(^DHCWMRPersonDic("籍贯",CityBirthDR)),"|",1)
	.s:CityBirthDR="" ErrInfo=ErrInfo_"籍贯字典未对应!"
	;s SecondPhone=$p(PatInfo,"^",11)       //工作单位
	;s TelH=$p(PatInfo,"^",12)              //电话
	;s MobPhone=$p(PatInfo,"^",13)          //手机
	;s ForeignId=$p(PatInfo,"^",14)         //联系人
	;s ForeignPhone=$p(PatInfo,"^",15)      //联系人电话
	;s ForeignAddress=$p(PatInfo,"^",16)    //联系人地址
	s CTRLTDR=$p(PatInfo,"^",17)           //与病人关系
	i CTRLTDR'="" d
	.s CTRLTDR=$p($g(^DHCWMRPersonDic("与病人关系",CTRLTDR)),"|",1)
	.s:CTRLTDR="" ErrInfo=ErrInfo_"与病人关系字典未对应!"
	s ExemptionNumber=+$p(PatInfo,"^",18)   //住院次数
	;s:ExemptionNumber=0 ErrInfo=ErrInfo_"住院次数为零!"
	;s Comment2=$p(PatInfo,"^",19)          //单位邮编
	;s Comment1=$p(PatInfo,"^",20)          //家庭邮编
	s SocialStatusDR=$p(PatInfo,"^",21)    //病人性质(自费/医保)
	i SocialStatusDR'="" d
	.s SocialStatusDR=$p($g(^DHCWMRPersonDic("病人性质",SocialStatusDR)),"|",1)
	.s:SocialStatusDR="" ErrInfo=ErrInfo_"病人性质字典未对应!"
	s Name3=$p(PatInfo,"^",22)             //个人医保号
	;i Name3'="" d
	;.s Name3=$$ALPHAUP^SSUTIL4(Name3)
	;.s:$d(^PAPERi("PAPER_PatName",Name3)) ErrInfo=ErrInfo_"存在相同个人医保号患者记录!"
	
	q ErrInfo
}

/// *************************************************************************
/// 导病人基本信息
/// PatInfo=
/// 病历号^病人姓名^病人性别^出生日期^身份证号^户口地址^民族^婚否^国籍^籍贯^
/// 工作单位^电话^手机^联系人^联系电话^联系地址^与病人关系^入院次数^单位邮编^
/// 家庭邮编^病人性质^医保号(个人编号)
/// Dics=$lb("3|病人性别","7|民族","8|婚否","9|国籍","10|籍贯","17|与病人关系","21|病人性质")
/// w ##Class(web.DHCWMRImport.PatientInfo).InsertPatInfo(PatInfo)
/// *************************************************************************
ClassMethod InsertPatInfo(PatInfo)
{
	n (PatInfo)
	s ret=-1,Papmi=0
	
	s PatInfo=$tr(PatInfo,$c(10),"")
	s PatInfo=$tr(PatInfo,$c(13),"")
	s Medicare=$p(PatInfo,"^",1)           //住院病历号
	s Medicare=$$ALPHAUP^SSUTIL4(Medicare)
	s Name=$p(PatInfo,"^",2)               //姓名
	s Name=$tr(Name," ","")
	s Soundex1=Name_"00"                   //姓名00
	s Name2=""                             //姓名拼音(首字母)
	s SexDR=$p(PatInfo,"^",3)              //性别
	s:SexDR'="" SexDR=$p($g(^DHCWMRPersonDic("病人性别",SexDR)),"|",1)
	s Dob=$p(PatInfo,"^",4)                //出生日期
	s Dob=$p(Dob," ",1)
	s:Dob'="" Dob=$zdh(Dob,3)
	s ID=$p(PatInfo,"^",5)                 //身份证号
	s StName=$p(PatInfo,"^",6)             //家庭住址(户口地址)
	s:$tr(StName," ","")="无" StName=""
	s:$tr(StName," ","")="同上" StName=""
	s NationDR=$p(PatInfo,"^",7)           //民族
	s:NationDR'="" NationDR=$p($g(^DHCWMRPersonDic("民族",NationDR)),"|",1)
	s MaritalDR=$p(PatInfo,"^",8)          //婚否
	s:MaritalDR'="" MaritalDR=$p($g(^DHCWMRPersonDic("婚否",MaritalDR)),"|",1)
	s CountryDR=$p(PatInfo,"^",9)          //国籍
	s:CountryDR'="" CountryDR=$p($g(^DHCWMRPersonDic("国籍",CountryDR)),"|",1)
	s ProvinceBirthDR=""                   //籍贯省(根据市判断省)
	s CityBirthDR=$p(PatInfo,"^",10)       //籍贯市
	i CityBirthDR'="" d
	.s CityBirthDR=$p($g(^DHCWMRPersonDic("籍贯",CityBirthDR)),"|",1)
	.s ProvinceBirthDR=$p($g(^CT("CIT",+CityBirthDR)),"^",4)
	s SecondPhone=$p(PatInfo,"^",11)       //工作单位
	s:$tr(SecondPhone," ","")="无" SecondPhone=""
	s:$tr(SecondPhone," ","")="同上" SecondPhone=""
	s TelH=$p(PatInfo,"^",12)              //电话
	s:$tr(TelH," ","")="无" TelH=""
	s:$tr(TelH," ","")="同上" TelH=""
	s MobPhone=$p(PatInfo,"^",13)          //手机
	s ForeignId=$p(PatInfo,"^",14)         //联系人
	s ForeignPhone=$p(PatInfo,"^",15)      //联系人电话
	s:$tr(ForeignPhone," ","")="无" ForeignPhone=""
	s:$tr(ForeignPhone," ","")="同上" ForeignPhone=""
	s ForeignAddress=$p(PatInfo,"^",16)    //联系人地址
	s:$tr(ForeignAddress," ","")="无" ForeignAddress=""
	s:$tr(ForeignAddress," ","")="同上" ForeignAddress=""
	s CTRLTDR=$p(PatInfo,"^",17)           //联系人与患者关系(与病人关系)
	s:CTRLTDR'="" CTRLTDR=$p($g(^DHCWMRPersonDic("与病人关系",CTRLTDR)),"|",1)
	s ExemptionNumber=$p(PatInfo,"^",18)   //住院次数
	s Comment2=$p(PatInfo,"^",19)          //单位邮编
	s Comment1=$p(PatInfo,"^",20)          //家庭邮编
	s SocialStatusDR=$p(PatInfo,"^",21)    //社会地位(自费/医保)(病人性质)
	s:SocialStatusDR'="" SocialStatusDR=$p($g(^DHCWMRPersonDic("病人性质",SocialStatusDR)),"|",1)
	s Name3=$p(PatInfo,"^",22)             //个人医保号
	s UpdateUser=$o(^SSU("SSUSR",0))
	s UpdateDate=+$h
	s UpdateTime=$p($h,",",2)
	
	TStart
	
	s ret=-2
	&sql(insert into SQLUSER.PA_Person(paper_name,paper_sex_dr,paper_id,
	PAPER_Marital_DR,PAPER_TelH,PAPER_SecondPhone,PAPER_MobPhone,
	paper_userupdate,paper_updatedate,paper_updatetime,paper_estdob,paper_dateadded,
	paper_useradded_dr,PAPER_SocialStatus_DR,PAPER_Nation_DR,PAPER_Country_DR,
	PAPER_Province_Birth_DR,PAPER_CityBirth_DR,
	PAPER_CTRLT_DR,PAPER_ForeignId,PAPER_ForeignPhone,PAPER_ForeignAddress,
	paper_name2,PAPER_Soundex1,PAPER_Name3,paper_exemptionnumber)
	values(:Name,:SexDR,:ID,
	:MaritalDR,:TelH,:SecondPhone,:MobPhone,
	:UpdateUser,:UpdateDate,:UpdateTime,'N',:UpdateDate,
	:UpdateUser,:SocialStatusDR,:NationDR,:CountryDR,
	:ProvinceBirthDR,:CityBirthDR,
	:CTRLTDR,:ForeignId,:ForeignPhone,:ForeignAddress,
	:Name2,:Soundex1,:Name3,:ExemptionNumber))
 	i SQLCODE'=0 TRollBack
 	q:SQLCODE'=0 ret
 	s Papmi=$g(%ROWID)
 	
 	s ret=-3
 	i Dob'="" d
 	.s tmpAge=##Class(web.UDHCJFIPReg).getpatage($zd(Dob,3),"")
 	.s AgeYear=$p(tmpAge,"^",2)
	.s AgeMounth=$p(tmpAge,"^",3)
	.s AgeDay=$p(tmpAge,"^",4)
	.s Age="|||||||||||"_AgeYear_"|"_AgeMounth_"|"_AgeDay
	e  d
	.s AgeYear=""
	.s AgeMounth=""
	.s AgeDay=""
	.S Age="|||||||||||||"
	&sql(update SQLUSER.pa_person(paper_dob,paper_age,paper_ageday,paper_agemth,paper_ageyr)values(:Dob,:Age,:AgeDay,:AgeMounth,:AgeYear) where paper_rowid=:Papmi)
    i SQLCODE'=0 TRollBack
 	q:SQLCODE'=0 ret
 	
 	s ret=-4
  	S ^PAPER(Papmi,"PER","ADD",0)=1
	S ^PAPER(Papmi,"PER","ADD",1)=StName
	S $p(^PAPER(Papmi,"ALL"),"^",9)=ID  //身份证号18位
	
	s ret=-5
	s RegNo=$I(^PAPER(0,"CNT","I"))
	s RegNo=##class(web.UDHCJFBaseCommon).regnocon(RegNo)
	&sql(update SQLUSER.pa_patmas(papmi_No,papmi_ipno,papmi_opno,PAPMI_Medicare) Values(:RegNo,:RegNo,:RegNo,:Medicare) where papmi_rowid=:Papmi)
    i SQLCODE'=0 TRollBack
 	q:SQLCODE'=0 ret
 	
 	s ret=-6
	&sql(insert into SQLUSER.DHC_Person(PAPER_PaPerson_dr,PAPER_Comment1,PAPER_Comment2)  values(:Papmi,:Comment1,:Comment2))
    i SQLCODE'=0 TRollBack
 	q:SQLCODE'=0 ret
 	
 	TCommit
 	s ret=Papmi
 	q ret
}

/// *************************************************************************
/// 导患者基本信息
/// PatInfo=
/// 病历号^病人姓名^病人性别^出生日期^身份证号^户口地址^民族^婚否^国籍^籍贯^
/// 工作单位^电话^手机^联系人^联系电话^联系地址^与病人关系^入院次数^单位邮编^
/// 家庭邮编^病人性质^医保号(个人编号)
/// m ^DHCWMRPerson=^DHCMedTmpData
/// m ^PAPER090826=^PAPER
/// m ^PAPERi090826=^PAPERi
/// m ^DHCPERSON090826=^DHCPERSON
/// w ##Class(web.DHCWMRImport.PatientInfo).ImportPatInfo(From,To)
/// select papmi_medicare,* from pa_patmas where papmi_medicare like '9%' or papmi_medicare like 'T9%' or papmi_medicare like 'TM9%' or papmi_medicare like 'R9%' or papmi_medicare like 'L9%'
/// update pa_patmas set papmi_medicare=null where papmi_medicare like '9%' or papmi_medicare like 'T9%' or papmi_medicare like 'TM9%' or papmi_medicare like 'R9%' or papmi_medicare like 'L9%'
/// select papmi_medicare,* from pa_patmas where papmi_rowid1>165248 or papmi_rowid1<74
/// update pa_patmas set papmi_medicare=null where papmi_rowid1>165248 or papmi_rowid1<74
/// select paper_exemptionnumber,* from pa_person where paper_rowid =69
/// select papmi_rowid from pa_patmas where papmi_no='0000000070'
/// update pa_person set paper_exemptionnumber=0 where paper_rowid=69
/// *************************************************************************
ClassMethod ImportPatInfo(From, To)
{
	n (From,To)
	
	s Ind=+$o(^DHCWMRPerson(+From),-1)
	s:To="" To=$o(^DHCWMRPerson(""),-1)
	f  s Ind=$o(^DHCWMRPerson(Ind)) q:(Ind="")||(Ind>To)  d
	.w:(Ind-((Ind\1000)*1000))=0 "Ind="_Ind,!
	.//取数据
	.s PatInfo=$g(^DHCWMRPerson(Ind))
	.s:PatInfo="" ^DHCWMRPerson(Ind,0)=""
	.q:PatInfo=""
	.//数据检查
	.s flg=..CheckPatInfo(PatInfo)
	.s:flg'="" ^DHCWMRPerson(Ind,1)=flg
	.q:flg'=""
	.//数据导入
	.s flg=..InsertPatInfo(PatInfo)
	.s:flg<0 ^DHCWMRPerson(Ind,2)=flg
	.q:flg<0
	.//删除数据
	.k ^DHCWMRPerson(Ind)
	
	q "ImportPatInfo Over!"
}

/// *************************************************************************
/// 取基础字典做对照
/// PatInfo=
/// 病历号^病人姓名^病人性别^出生日期^身份证号^户口地址^民族^婚否^国籍^籍贯^
/// 工作单位^电话^手机^联系人^联系电话^联系地址^与病人关系^入院次数^单位邮编^
/// 家庭邮编^病人性质^医保号(个人编号)
/// Dics=$lb("3|病人性别","7|民族","8|婚否","9|国籍","10|籍贯","17|与病人关系","21|病人性质")
/// w Class(web.DHCWMRImport.PatientInfo).GetDictionary("")
/// *************************************************************************
ClassMethod GetDictionary(Dics)
{
	n (Dics)
	s:Dics="" Dics=$lb("3|病人性别","7|民族","8|婚否","9|国籍","10|籍贯","17|与病人关系","21|病人性质")
	
	s Ind=0
	f  s Ind=$o(^DHCWMRPerson(Ind)) q:Ind=""  d
	.s PatInfo=$g(^DHCWMRPerson(Ind))
	.q:PatInfo=""
	.f IndTitle=1:1:$listlength(Dics) d
	..s tmpID=$p($list(Dics,IndTitle),"|",1)
	..s tmpDesc=$p($list(Dics,IndTitle),"|",2)
	..s tmpVal=$p(PatInfo,"^",tmpID)
	..q:tmpVal=""
	..s:'$d(^DHCWMRPersonDic(tmpDesc,tmpVal)) ^DHCWMRPersonDic(tmpDesc,tmpVal)=""
	.w:(Ind-((Ind\1000)*1000))=0 "Ind="_Ind,!
	
	q "GetDictionary Over!"
}

/// 住院次数以病案首页住院次数为准(病人基本信息住院次数不准)
/// w ##Class(web.DHCWMRImport.PatientInfo).UpdateIPCount()
ClassMethod UpdateIPCount()
{
	n
	s Rowid=$o(^DHCMedTmpData(0))
	s Count=0
	while (Rowid'="")
	{
		s MrNo=$p($g(^DHCMedTmpData(Rowid)),"^",1)
		s MrNo=$$ALPHAUP^SSUTIL4(MrNo)
		s IPCount=$p($g(^DHCMedTmpData(Rowid)),"^",10)
		continue:MrNo=""
		
		if (IPCount>=(+$g(^DHCWMRIPCount(+$h,MrNo,0))))
		{
			s ^DHCWMRIPCount(+$h,MrNo,0)=(+IPCount)
		}
		
		//^PAPERi("Medicare",$$ALPHAUP({PAPMI_MedicareString}),{PAPMI_RowId})
		s Papmi=$o(^PAPERi("Medicare",MrNo_"Z",0))
		if (Papmi="")
		{
			s ^DHCWMRIPCount(+$h,MrNo,-1)=$g(^DHCMedTmpData(Rowid))
			w "Pa_Person Have No This MrNo,Error!MrNo="_MrNo_",Name="_$p($g(^DHCMedTmpData(Rowid)),"^",2),!
		}
		while (Papmi'="")
		{
			s PapmiIPCount=$p($g(^PAPER(Papmi,"PER",4)),"^",8)
			s ^DHCWMRIPCount(+$h,MrNo,Papmi)=PapmiIPCount
			s Papmi=$o(^PAPERi("Medicare",MrNo,Papmi))
		}
		
		s Rowid=$o(^DHCMedTmpData(Rowid))
		s Count=Count+1
		w:(Count#5000)=0 "Count="_Count,!
	}
	
	s MrNo=""
	f  s MrNo=$o(^DHCWMRIPCount(+$h,MrNo)) q:MrNo=""  d
	.s Ind=0
	.f  s Ind=$o(^DHCWMRIPCount(+$h,MrNo,Ind)) q:Ind=""  d
	..s IPCount=+$g(^DHCWMRIPCount(+$h,MrNo,0))
	..i ((+$g(^DHCWMRIPCount(+$h,MrNo,Ind)))'=IPCount)&&((+$g(^DHCWMRIPCount(+$h,MrNo,Ind)))'=(IPCount+1)) d
	...w "IPCount Error!MrNo="_MrNo_",IPCount="_IPCount,!
	...//&sql(update pa_person set paper_exemptionnumber=:IPCount where paper_rowid=:Ind)
	
	q "UpdateIPCount,Count="_Count_"!"
}

}
