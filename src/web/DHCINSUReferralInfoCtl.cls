Import SQLUser

/// 转诊信息操作类
Class web.DHCINSUReferralInfoCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 633;

/// 保存
/// w ##class(web.DHCINSUReferralInfoCtl).Save("^14563057^^1708237^440203^44020000000000146062^GDA^440202196405180947^杨艳琼^女^1964-05-18^^^A^^^1^C73.x00^甲状腺恶性肿瘤^2021-01-04^^^598^H44020300006^^H44020300147^韶关爱尔眼科医院^^310^000000^^^^^^13826389083^cn_iptcp:192.168.0.40[1972]:DHC-APP|_system|3F3830|GlobalEMR^同意^[object HTMLTextAreaElement]^[object HTMLTextAreaElement]^2020-11-01^2021-03-01^甲状腺恶性肿瘤^^2^^曾宪平")
ClassMethod Save(InString As %String) As %String
{
	
	;n (InString)
	;s InString="^2^^4118020^419000^01^ZZC^411811199708275416^吴思颐^女^1996-08-26^4180040001^4800122^A^3^0^2^120.00.132^发热^2015-12-25^^^1^41930003^上海虹桥第一人民医院^401000005^郑州人民医院^1^1^410102002006^上海虹桥香焦镇^020^葡萄村^005^草莓组^^^^^^^^^^^"
	s InString=$tr(InString,$c(0),"")
	q:InString="" -100
	s Save=$$Save^DHCINSUReferralInfo(InString)
	q Save
}

/// 按照ADMDR查询医保转诊信息
/// w ##class(web.DHCINSUReferralInfoCtl).GetReferralInfoByAdm(9)
ClassMethod GetReferralInfoByAdm(AdmRowid As %String) As %String
{
	
	;n (AdmRowid)
	q:AdmRowid="" -1
	q:$d(^DHCINREFER("0","AdmDr",AdmRowid))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINREFER("0","AdmDr",AdmRowid,InfoId),-1)
	s OutStr=..GetReferralInfoById(InfoId)
	s GetReferralInfoByAdm="1!"_OutStr
	q GetReferralInfoByAdm
}

/// 根据医疗证号查询转诊信息列表
/// w ##class(web.DHCINSUReferralInfoCtl).GetReferralInfoByBookNo(4800122)
ClassMethod GetReferralInfoByBookNo(BookNo As %String) As %String
{
	;IndexOfInsuId
	n (BookNo)
	q:BookNo="" -1
	q:$d(^DHCINREFER("0","BookNo",BookNo))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINREFER("0","BookNo",BookNo,InfoId)) q:InfoId=""  d
	.s InfoStr=..GetReferralInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	s GetReferralInfoByBookNo=count_OutStr
	q GetReferralInfoByBookNo
}

/// 根据医疗卡号查询转诊信息列表
/// w ##class(web.DHCINSUReferralInfoCtl).GetReferralInfoByBookCardNo(4180040001)
ClassMethod GetReferralInfoByBookCardNo(BookCardNo As %String) As %String
{
	;IndexOfInsuId
	n (BookCardNo)
	q:BookCardNo="" -1
	q:$d(^DHCINREFER("0","BookCardNo",BookCardNo))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINREFER("0","BookCardNo",BookCardNo,InfoId)) q:InfoId=""  d
	.;b ;0
	.s InfoStr=..GetReferralInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	;b ;1
	s GetReferralInfoByBookCardNo=count_OutStr
	q GetReferralInfoByBookCardNo
}

/// 根据身份证号查询转诊信息列表
/// w ##class(web.DHCINSUReferralInfoCtl).GetReferralInfoByIdcardNo(411811199708275416)
ClassMethod GetReferralInfoByIdcardNo(IdcardNo As %String) As %String
{
	;IndexOfInsuId
	n (IdcardNo)
	q:IdcardNo="" -1
	q:$d(^DHCINREFER("0","IdcardNo",IdcardNo))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINREFER("0","IdcardNo",IdcardNo,InfoId)) q:InfoId=""  d
	.s InfoStr=..GetReferralInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	s GetReferralInfoByIdcardNo=count_OutStr
	q GetReferralInfoByIdcardNo
}

/// 按照ID取医保就诊信息
/// w ##class(web.DHCINSUReferralInfoCtl).GetReferralInfoById(1)
ClassMethod GetReferralInfoById(InfoId As %String) As %String
{
	;n (InfoId)
	s GetReferralInfoById=$$GetReferInfoById^DHCINSUReferralInfo(InfoId)
	q GetReferralInfoById
}

/// 根据ID更新就诊状态
/// w ##class(web.DHCINSUReferralInfoCtl).UpdateReferralInfoFlag(3,"B")
ClassMethod UpdateReferralInfoFlag(INRefDr As %String, Flag As %String) As %String
{
	q:(+INRefDr<1) "-1"
	&sql(Update INSU_ReferralInfo set Inref_activeflag=:Flag where INREF_RowID=:INRefDr)
	q SQLCODE
}

ClassMethod Delete(INRefDr As %String) As %String
{
	q:(+INRefDr<1) "-1"
	&sql(delete from  INSU_ReferralInfo  where INREF_RowID=:INRefDr)
	q SQLCODE
}

/// Creator：      丁少华
/// CreatDate：    2015 12 28
/// Description:   作废转诊时调用的函数，作废时往Insu_ReferralInfo表插一条新记录
/// Table：        
/// Input：        
/// Output：       
/// Return：       成功返回 0
/// Others：
/// w ##class(web.DHCINSUReferralInfoCtl).StrikeInsuReferralInfo("^14563057^^1952321^440203^44020000000000146062^GDA^440202196405180947^杨艳琼^女^1964-05-18^^^S^^^1^C73.x00^甲状腺恶性肿瘤^2021-01-07^2021-01-07^17:30:46^1^H44020300006^^广东省人民医院^H44010400081^^杨艳琼^000000^^^^^^13826389083^cn_iptcp:192.168.0.40[1972]:DHC-APP|_system|3F3830|GlobalEMR^同意^[object HTMLTextAreaElement]^[object HTMLTextAreaElement]^2021-01-07^2021-04-01^咳嗽咳痰咯血1周;患者1周前无明显诱因出现咳嗽、咯血痰,多为鲜红色血痰，量约5-10毫升，无畏寒、发热。无胸痛、心悸，无午后潮热、消瘦，无明显喘息、气促，无腹胀、腹痛，症状反复发作，在当地医院治疗后（具体不详）症状无明显好转，为进一步治疗入住我科。本次起病以来，体重减轻，胃纳尚可，睡眠欠佳，大小便正常。;预防接种史不详。否认“高血压、冠心病、糖尿病”史。否认外伤手术史及输血史，否认药物过敏史及食物和其他接触性过敏史。否认“肝炎”、“结核”和其他传染病史。^需要重新备案^cn_iptcp:192.168.0.40[1972]:DHC-APP|_system|3F3830|GlobalEMR^^3^demo^")
ClassMethod StrikeInsuReferralInfo(Instring As %String) As %String
{
	;s Instring="^2^^4118020^419000^01^ZZC^411811199708275416^吴思颐^女^1996-08-26^4180040001^4800122^S^3^0^2^120.00.132^发热^2015-12-25^2015-12-28^14:47:56^1^41930003^上海虹桥第一人民医院^401000005^郑州人民医院^1^1^410102002006^上海虹桥香焦镇^020^葡萄村^005^草莓组^^^^^^^^^^^3"
	s StrikeInsuReferralInfo=$$StrikeInsuReferral^DHCINSUReferralInfo(Instring)
	q StrikeInsuReferralInfo
}

/// 按照insu_divide rowid查询医保转诊信息
/// w ##class(web.DHCINSUReferralInfoCtl).GetInfoByDivDr("887")  
ClassMethod GetReferralInfoByDivDr(DivDr As %String) As %String
{
	
	n (DivDr)
	q:DivDr="" -1
	s GetDivById=$$GetDivideInfo^DHCINSUDivide(DivDr)
	s INPAYAdmInfoDr=$p(GetDivById,"^",3)
	s OutStr=..GetReferralInfoById(INPAYAdmInfoDr)
	s GetInfoByDivDr="1!"_OutStr
	q GetInfoByDivDr
}

/// w ##class(web.DHCINSUReferralInfoCtl)GetInsuReferralInfoByStr("36","11")  
ClassMethod GetInsuReferralInfoByStr(AdmRowid As %String, InStr As %String) As %String
{
	;n (InRefRowid)
	q:InRefRowid="" -1
	q:$d(^DHCINREFER("0","AdmDr",AdmRowid))=0 -100
	s OutStr=""
	s InfoId="",flag=""
	f  s InfoId=$o(^DHCINREFER("0","AdmDr",AdmRowid,InfoId)) q:(InfoId="")||(flag="N")  d
	.s OutStr=..GetReferralInfoById(InfoId)
	.q:$p(OutStr,"^",15)'=InStr
	.s flag="N"
	q:flag="" -100
	s GetInsuReferralInfoByStr="1!"_OutStr
	q GetInsuReferralInfoByStr
}

/// 根据就诊获取病情描述
/// DingSH 20210105
/// w ##class(web.DHCINSUReferralInfoCtl).GetReferDiseCondDscr("14563057")  
ClassMethod GetReferDiseCondDscr(AdmDr)
{
	
	s MERC13=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AdmDr,"HDSD00.13.01")
    s ZS = MERC13.GetAt("HDSD00.13.114")   //主诉
    s XBS = MERC13.GetAt("HDSD00.13.095")  //现病史
    s JWS = MERC13.GetAt("HDSD00.13.042")  //既往史
    q ZS_";"_XBS_";"_JWS
}

/// Description:   查询条件查询转院信息
/// Table      ：        
/// Input      ：        SDate:开始日期;EDate:结束日期;UserDr:操作员Dr;Rptlb:审批类别;RptSt:审批状态;HospId:院区指针;     
/// Output     ：       
/// Others     ：       w ##class(web.INSUReport).GetRptInfo("2021-01-05","2021-01-05","","01","I","")
ClassMethod GetReferralInfo(SDate As %String, EDate As %String, UserDr As %String, Rptlb As %String, RptSt As %String = "", HospId As %String = "") As %String
{
	
	n (SDate,EDate,UserDr,Rptlb,RptSt,HospId)
	
	s:($l(SDate)=10)&&(SDate["-") SDate=$zdh(SDate,3)
	s:($l(EDate)=10)&&(EDate["-") EDate=$zdh(EDate,3)
	s:($l(SDate)=10)&&(SDate["/") SDate=$zdh(SDate,4)
	s:($l(EDate)=10)&&(EDate["/") EDate=$zdh(EDate,4)
	s:($l(SDate)=8) SDate=$zdh(SDate,8)
	s:($l(EDate)=8) EDate=$zdh(EDate,8)
	s ReferralPID=$I(^CacheTemp("Referral"))			
	k ^CacheTemp("Referral",ReferralPID)
	s i=0

	f iDate=SDate:1:EDate d
	.s rowid=""
	.f  s rowid=$o(^DHCINREFER("0","iDate",iDate,rowid)) q:rowid=""  d
	..s s=$g(^DHCINREFER(rowid))
	..s INREFUserDr=$p(s,"^",22)
	..q:(UserDr'="")&&(INREFUserDr'=UserDr)
	..s tFlag=$p(s,"^",13)
	..q:tFlag'=RptSt
	..s i = i+1
	..s ReferralIfno=..GetReferralInfoById(rowid)
	..s ^CacheTemp("Referral",ReferralPID,i)=ReferralIfno
	q i_"^"_ReferralPID
}

ClassMethod GetReferralFromCacheTmp(ID, Index) As %String
{
	 n (ID,Index)
     s mCurrRowCacheTemp=""
     s outstr=""
     s mCurrRowCacheTemp=$g(^CacheTemp("Referral",ID ,Index))
     s outstr=mCurrRowCacheTemp
     i $o(^CacheTemp("Referral",ID,""),-1)=Index d
  	 .k ^CacheTemp("Referral",ID)
  	 q mCurrRowCacheTemp
}

/// 查询转诊登记信息
Query QueryReferInfo(StartDate As %String, EndDate As %String, ReferType As %String, INSUType, HospId, ExpStr = "") As %Query(ROWSPEC = "TRowid,TAdmDr,TInsuAdmInfoDr,TTurnCode,TCenterNo,TMemberNo,TInsuType,TIdcardNo,TName,TSex,TBirthday,TBookCardNo,TBookNo,TActiveFlag,TRelation,TIsrelief,TTurnType,TIcdCode,TIcdName,TurnDate,TiDate,TiTime,TUserDr,TFromHospCode,TFromHospName,TToHospCode,TToHospName,TJoinType,TFamilyType,TTownCode,TTownName,TVillageCode,TVillageName,TGroupCode,TGroupName,TDemo1,TDemo2,TDemo3,TDemo4,TDemo5,TDemo6,TDemo7,TDemo8,TDemo9,TDemo10,TInRefDr") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUReferralInfoCtl","QueryReferInfo","2021-01-01","2021-01-08","1","","2","|")
ClassMethod QueryReferInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Rptlb As %String, ParamINSUType As %String, HospId, ExpStr = "") As %Status
{
	s ^CacheTemp("QueryReferInfo")=$lb(StartDate , EndDate, Rptlb,ParamINSUType,HospId,ExpStr)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i +StartDate=0 s StartDate=+$H
	i +EndDate=0 s EndDate=+$H
	
	s TurnCode=$p(ExpStr,"|",1)   // 审批编号
	s InsuNo=$p(ExpStr,"|",2)     // 人员编号
	s PatName=$p(ExpStr,"|",3)    // 姓名
	s PatId=$p(ExpStr,"|",4)      // 身份证号
	
	i TurnCode'=""  { 
	    //根据审批编号查询
		s rowid=""
		for  s rowid=$o(^DHCINREFER("0","TurnCode",TurnCode,rowid))  q:rowid=""  d
		.d Build1	
	}elseif(InsuNo'="") {	
	     //根人员编号查询
		s rowid=""
		for  s rowid=$o(^DHCINREFER("0","MemberNo",InsuNo,rowid))  q:rowid=""  d
		.d Build1	
	}else{
		//根据日期查询
		for TmpDate=StartDate:1:EndDate  d
		.s rowid=""
		.for  s rowid=$o(^DHCINREFER("0","iDate",TmpDate,rowid))  q:rowid=""  d
		..d Build1		
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1  

    s (TRowid,TAdmDr,TInsuAdmInfoDr,TTurnCode,TCenterNo,TMemberNo,TInsuType,TIdcardNo,TName,TSex,TBirthday,TBookCardNo,TBookNo,TActiveFlag,TRelation,TIsrelief,TTurnType,TIcdCode,TIcdName,TurnDate,TiDate,TiTime,TUserDr,TFromHospCode,TFromHospName,TToHospCode,TToHospName,TJoinType,TFamilyType,TTownCode,TTownName,TVillageCode,TVillageName,TGroupCode,TGroupName,TDemo1,TDemo2,TDemo3,TDemo4,TDemo5,TDemo6,TDemo7,TDemo8,TDemo9,TDemo10,TInRefDr) = ""
	s ReferInfo=$g(^DHCINREFER(rowid))
	q:ReferInfo=""
	
	//s TabRptTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_$g(DataINSUType),TabRptType,4,HospId)
	//s TabRptDate=##class(websys.Conversions).DateLogicalToHtml(TabRptDate)
	//s TabSDate=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",12))
	//s TabEDate=##class(websys.Conversions).DateLogicalToHtml($p(s,"^",13))
	s HospId=""
    s TRowid = rowid
    s TAdmDr = $P(ReferInfo,"^",1)                                  ;指向就诊pa_adm
    s TInsuAdmInfoDr = $P(ReferInfo,"^",2)                          ;指向insu_adminfo
    s TTurnCode = $P(ReferInfo,"^",3)  
    q:(TurnCode'="")&&(TurnCode'=TTurnCode)
    s TCenterNo = $P(ReferInfo,"^",4)                               ;参保机构医保区划()   objinsuadm.center
	s TMemberNo = $P(ReferInfo,"^",5)                               ;成员编码                               objinsuadm.insuid
	q:(InsuNo'="")&&(InsuNo'=TMemberNo)
	s TInsuType = $P(ReferInfo,"^",6)                               ;医保类型                          objinsuadm.insutype
	s TInsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",TInsuType,4)
	s TIdcardNo = $P(ReferInfo,"^",7)                               ;身份证号                            objinsuadm.xstring5
	q:(PatId'="")&&(PatId'=TIdcardNo)
	s TName = $P(ReferInfo,"^",8)                                   ;姓名                                     objinsuadm.xstring6.split("|")(0)
	q:(PatName'="")&&(PatName'=TName)
	s TSex = $P(ReferInfo,"^",9)                                    ;性别                                     objinsuadm.xstring7.split("|")(1)
	s TBirthday =$P(ReferInfo,"^",10)                               ;出生日期                             objpatmas.dob
	s TBookCardNo = $P(ReferInfo,"^",11)  
	s TBookNo =$P(ReferInfo,"^",12)  
    s TActiveFlag = $P(ReferInfo,"^",13)                            ;生效标志        
    s TActiveFlag=$case(TActiveFlag,"A":"已备案","B":"被作废","S":"作废")                  
	s TRelation = $P(ReferInfo,"^",14)  
	s TIsrelief =$P(ReferInfo,"^",15)  
	s TTurnType = $P(ReferInfo,"^",16)                              ;转院类型      1 市内转院 2 转往省内异地3:              转往省外异地()
	q:(Rptlb'="")&&(Rptlb'=TTurnType)
	s TTurnType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("ref_Type"_$P(ReferInfo,"^",6) ,TTurnType,4)
	s TIcdCode = $P(ReferInfo,"^",17)                               ;转诊诊断编码
	s TIcdName = $P(ReferInfo,"^",18)                               ;转诊诊断名称
	s TurnDate = $P(ReferInfo,"^",19)                               ;转诊日期
	s TiDate = $P(ReferInfo,"^",20)  
	s TiDate = ##class(websys.Conversions).DateLogicalToHtml(TiDate)
	s TiTime = $P(ReferInfo,"^",21)  
	s TiTime = ##class(websys.Conversions).TimeLogicalToHtml(TiTime)
	s TUserDr = $P(ReferInfo,"^",22)                                ;操作员Dr applociationframework.clsDefineConst.userid
	s TFromHospCode = $P(ReferInfo,"^",23)                          ;applociationframework.clsDefineConst.InsuHospCode
	s TFromHospName = $P(ReferInfo,"^",24)                          ;applociationframework.clsDefineConst.InsuHospName
	s TToHospCode = $P(ReferInfo,"^",25)                            ;1201下载取值
	s TToHospName = $P(ReferInfo,"^",26)                            ;1201下载取值
	s TJoinType = $P(ReferInfo,"^",27)                              ;objinsuadm.pattype	
	s TFamilyType = $P(ReferInfo,"^",28)                            ;险种类型objinsuadm.xstring15
	s TFamilyType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insutype"_$P(ReferInfo,"^",6) ,TFamilyType,4)
	s TTownCode = $P(ReferInfo,"^",29)                              ;转往医院所属的行政区(划)  1201下载取值
	s TTownName = $P(ReferInfo,"^",30)  
	s TVillageCode = $P(ReferInfo,"^",31)  
	s TVillageName = $P(ReferInfo,"^",32)  
	s TGroupCode = $P(ReferInfo,"^",33)  
	s TGroupName = $P(ReferInfo,"^",34)  
	s TDemo1 = $P(ReferInfo,"^",35)                                  ;联系电话
	s TDemo2 = $P(ReferInfo,"^",36)                                  ;联系地址
	s TDemo3 = $P(ReferInfo,"^",37)                                  ;医院同意转院标志
	s TDemo4 = $P(ReferInfo,"^",38)                                  ;转院原因
	s TDemo5 = $P(ReferInfo,"^",39)                                  ;转院意见
	s TDemo6 = $P(ReferInfo,"^",40)                                  ;开始日期
	s TDemo7 = $P(ReferInfo,"^",41)                                  ;结束日期
	s TDemo8 = $P(ReferInfo,"^",42)                                  ;病情描述
	s TDemo9 = $P(ReferInfo,"^",43)  
	s TDemo10 = $P(ReferInfo,"^",44)  
	s TInRefDr = $P(ReferInfo,"^",45)                                ;冲销指针
	
	//s TabINSUType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",DataINSUType,4,HospId)
	set Data=$lb(TRowid,TAdmDr,TInsuAdmInfoDr,TTurnCode,TCenterNo,TMemberNo,TInsuType,TIdcardNo,TName,TSex,TBirthday,TBookCardNo,TBookNo,TActiveFlag,TRelation,TIsrelief,TTurnType,TIcdCode,TIcdName,TurnDate,TiDate,TiTime,TUserDr,TFromHospCode,TFromHospName,TToHospCode,TToHospName,TJoinType,TFamilyType,TTownCode,TTownName,TVillageCode,TVillageName,TGroupCode,TGroupName,TDemo1,TDemo2,TDemo3,TDemo4,TDemo5,TDemo6,TDemo7,TDemo8,TDemo9,TDemo10,TInRefDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryReferInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReferInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryReferInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReferInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
