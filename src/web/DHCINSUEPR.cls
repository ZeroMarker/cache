Import SQLUser

Class web.DHCINSUEPR Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 353;

/// w ##class(web.DHCINSUEPR).GetInsuEPRInfo("74","3440")
ClassMethod GetInsuEPRInfo(PAADM, FunID) As %String
{
	n (PAADM,FunID)
	q:($g(PAADM)="")||($g(FunID)="") "-1"
	s OutStr=""
	s eprsubid="HDSD00.11"
	s eprsubinfo=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(PAADM,eprsubid)

	//测试用 因无电子病历数据，人为拼数据。
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	d retArray.SetAt("病案号", "HDSD00.11.006")
	d retArray.SetAt("医保登记住院（门诊）号", 2)
	d retArray.SetAt("手术及操作编码", 3)
	d retArray.SetAt("手术及操作日期", 4)
	d retArray.SetAt("手术级别", 5)
	d retArray.SetAt("手术及操作名称", 6)
	d retArray.SetAt("术者", 7)
	d retArray.SetAt("切口愈合等级", 8)
	d retArray.SetAt("麻醉方式", 9)
	d retArray.SetAt("麻醉医师", 10)
	d retArray.SetAt("经办人", 11)
	d retArray.SetAt("经办时间", 12)
	d retArray.SetAt("所属统筹区", 13)
	s eprsubinfo=retArray
	//测试用

	//取出所有dictype相同的dicdata。 
	
	s DicType="DHCEMR"_FunID
	s OutString=$$Query^DHCINSUDicData(DicType,"")		//取所有对照的电子病历数据元
	s JustId=+$p(OutString,"^",2)

	s Index=""
	f  s Index=$o(^CacheTemp("INSUDic",JustId,Index)) q:Index=""  d
	.s DataString=$g(^CacheTemp("INSUDic",JustId,Index))
	.s id=$p(DataString,"^",1)
    .s cType=$p(DataString,"^",2)
    .s cCode=$p(DataString,"^",3)
    .s cDesc=$p(DataString,"^",4)
    .s cDemo=$p(DataString,"^",5)
    .s cBill1=$p(DataString,"^",6)
    .s cBill2=$p(DataString,"^",7)
    	
	.i cBill1'="" d
	..s eprValue=..GetEPRDesc(cBill1,FunID,eprsubinfo)
	.e           d
	..s eprValue=""
	..//	取不到元数据；21	血型	DE04.50.001.00	ABO血型代码	不确定 demo字段默认值
    .i (cDemo'="")&&(eprValue="") d
    ..s eprValue="空"	;测试			cDemo
	.s OutStr=OutStr_eprValue_"|"
	
	k ^CacheTemp("INSUDic",JustId)
	q OutStr
}

ClassMethod GetEPRDesc(DicBill1 As %String, FunID As %String, eprsubinfo As %ArrayOfDataTypes) As %String
{
	n (DicBill1, FunID,eprsubinfo)
	s eprValue=""	;返回值
	s Num=0
	f j=1:1:$l(DicBill1,"&")  d
	.s tmpeprCode=$p(DicBill1,"&",j) 
	.s tmpeprDesc=eprsubinfo.GetAt(tmpeprCode)	//根据数据元取电子病历信息	非3440直接连接，不加分隔符。
	.//待修改，多个手术的数据字典存储方式
	.i FunID="3440" d
	..i Num=0  d
	...s eprValue=tmpeprDesc
	...s Num=1
	..e   d
	...s eprValue=eprValue_"@"_tmpeprDesc
	.e            d
	..s eprValue=eprValue_tmpeprDesc 

	q eprValue
}

/// w ##class(web.DHCINSUEPR).QueryEprAdmInfo("2013-03-25","2013-03-30","")
ClassMethod QueryEprAdmInfo(StartDate As %String, EndDate As %String, RegNo As %String) As %String
{
	n (StartDate,EndDate,RegNo)
	k ^InsuEprInfo("AdmInfo",$j)
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s i=0
	f Date=StartDate:1:EndDate  d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAADMi("DischDate",Date,AdmDr)) q:AdmDr=""   d
	..s AdmType=$p(^PAADM(AdmDr),"^",2)
	..q:AdmType'="I"
	..s InsuAdmDr=$o(^DHCINADM("0","ADM",AdmDr,""),-1)
	..q:InsuAdmDr=""
	..s InsuType=$p(^DHCINADM(InsuAdmDr),"^",18)
	..q:InsuType'="ZZC"
	..s InsuNo=$p(^DHCINADM(InsuAdmDr),"^",2)
	..s PatInfo=##class(web.DHCINSUPatInfo).GetPatInfoByAdm(AdmDr)
	..s AdmInfo=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(AdmDr)
	..s TempRegNo=$p(PatInfo,"^",2)
	..q:(RegNo'="")&(RegNo'=TempRegNo)
	..s RPEFlag=##class(EPRservice.BIL.BIEPRLogs).HasCommitted(AdmDr,"196","1")
	..;q:RPEFlag="0"
	..s Name=$p(PatInfo,"^",3)
	..s Medicare=$p(PatInfo,"^",14)
	..s DepDesc=$p(AdmInfo,"^",5)
	..s AdmDate1=$p(AdmInfo,"^",6)
	..s AdmDate=$e(AdmDate1,1,4)_"-"_$e(AdmDate1,5,6)_"-"_$e(AdmDate1,7,8)
	..s OutDate=$zd(Date,3)
	..s i=i+1
	..s ^InsuEprInfo("AdmInfo",$j,i)=TempRegNo_"^"_Name_"^"_InsuNo_"^"_DepDesc_"^"_AdmDate_"^"_OutDate_"^"_AdmDr
	..;w ^InsuEprInfo("AdmInfo",$j,i),!
	q i_"|"_$j
}

/// w ##class(web.DHCINSUEPR).GetEprAdmInfo(Job,i)
ClassMethod GetEprAdmInfo(Job As %String, i As %String) As %String
{
	n (Job,i)
	s OutStr=^InsuEprInfo("AdmInfo",Job,i)
	q OutStr
}

/// Creator：      liusf
/// CreatDate：    2015 07 17
/// Description:： 根据就诊号取电子病历信息
/// Input：        PAADM:就诊号，FunID:医保函数对应的医保字典表字典的系统代码
/// Return：       电子病历信息字符流
/// Others:		   请注意.net在调用此接口时要用CacheStream,有问题再联系我  9113838
/// w ##class(web.DHCINSUEPR).GetEPRInfoCom("3055894","DHCEMR01")
/// w ##class(web.DHCINSUEPR).GetEPRInfoCom("3397027","DHCEMR01")
ClassMethod GetEPRInfoCom(PAADM As %String, FunID As %String) As %String
{
	n (PAADM,FunID)
	q:($g(PAADM)="")||($g(FunID)="") "-1"
	s OutStr=""
	/*
	s:FunID="3410" Cnt=37,eprsubid="HDSD00.11"	//电子病历人员基本信息
	s:FunID="3420" Cnt=43,eprsubid="HDSD00.11"	//电子病历病历信息
	s:FunID="3430" Cnt=13,eprsubid="HDSD00.11"	//电子病历诊断信息
	s:FunID="3440" Cnt=13,eprsubid="HDSD00.11"	//电子病历手术信息
	s:FunID="3450" Cnt=35,eprsubid="HDSD00.11"	//电子病历结算信息
	s:FunID="3610" Cnt=17,eprsubid="HDSD00.16"	//3.5.3 出院小结信息上传			术语集HDSD00.16(出院小结CSV版)	
	s:FunID="3630" Cnt=15,eprsubid="HDSD00.13"	//3.5.5 首次病程记录 信息上传		术语集HDSD00.13(入院记录CSV版）\
	s:FunID="3730" Cnt=15,eprsubid="HDSD00.03.01"	//3.5.5 首次病程记录 信息上传		术语集HDSD00.13(入院记录CSV版）
 	i FunID="3610" d
	.s CommitFlag=##class(EPRservice.BIL.BIEPRLogs).HasCommitted(PAADM,"70","1")
	.i CommitFlag=0 d
	..s CommitFlag=##class(EPRservice.BIL.BIEPRLogs).HasCommitted(PAADM,"118","1")
	..i CommitFlag=0 d
	...s CommitFlag=##class(EPRservice.BIL.BIEPRLogs).HasCommitted(PAADM,"81","1")
	...i CommitFlag=1 d
	....s FunID="36101"
	....s eprsubid="HDSD00.14.02"
	..e  d
	...s FunID="36102"
	...s eprsubid="HDSD00.13.01"
	*/
    s SysStr=##class(web.INSUDicDataCom).QueryByCode("SYS",FunID)    //取系统字典
    //1014^SYS^DHCEMR01^住院病人基本信息^HDSD00.11^@^XML
    q:+SysStr=0 -2
    s RtnMode=$p(SysStr,"^",7)       //返回值模式   XML串或者某种分隔符的字段
    s eprsubid=$p(SysStr,"^",5)      //电子病历字典分类
    s DicType=$p(SysStr,"^",3)       //函数分类的系统代码
    s ConCode=$p(SysStr,"^",6)       //医保一个字段对应电子病历多个字段的链接符
    //w ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(1,"HDSD00.11")
    s eprsubinfo=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(PAADM,eprsubid)
    //w ##class(web.INSUDicDataCom).GetDicByCode("SYS","") 
    //s SysStr=##class(web.INSUDicDataCom).GetDicByCode(DicType,"")
    //$l(##class(web.INSUDicDataCom).GetDicByCode("SYS",""),"!")
     s SysStr=##class(web.INSUDicDataCom).GetSys("","",DicType)
    s Cnt=$l(SysStr,"!")
    f i=2:1:Cnt  d
	.;w !,"Cnt=",Cnt,"SysStr=",SysStr
	.s eprValue=""
	.s TmpDicStr=$P(SysStr,"!",i)
	.//1002^DHCEMR01^21^yzy021|单位电话^空|200^HDSD00.12.041&HDSD00.12.041^
	.s DicEMRCode=$p(TmpDicStr,"^",6)               ;电子病历字典串
	.s eprValue=$p($p(TmpDicStr,"^",5),"|",1)       ;默认初始值
	.s EprValueLong=$p($p(TmpDicStr,"^",5),"|",2)   ;字段长度
	.s EprValueType=$p($p(TmpDicStr,"^",5),"|",3)   ;字段类型 by bsw 2015-09-15 方便存储过程类型传递
	.s XMLNodeName=$P($p(TmpDicStr,"^",4),"|")      ;XML节点名称
	.i DicEMRCode'=""   d
	..;start 注释 标准版
	..;f j=1:1:$l(DicEMRCode,"&")  d              //取出以&分割符的病历字典数据用连接符ConCode拼在一起传给医保，
	..;.s tmpepr1=$p(DicEMRCode,"&",j) 
	..;.s tmpeprValue=eprswubinfo.GetAt(tmpepr1)	//根据数据元取电子病历信息
	..;.s eprValue=eprValue_ConCode_tmpeprValue
	..;End 注释 标准版
	
	..;start 郑州医院用
	..;DicEMRCode HDSD00.12.041#HDSD00.12.042&HDSD00.12.043#HDSD00.12.044
	..;b ;1111
	..if (DicEMRCode'["DHCEMRFUNC") d     ;非函数字典取值方式
    ...f j=1:1:$l(DicEMRCode,"&")  d              //取出以&分割符的病历字典数据用连接符ConCode拼在一起传给医保，
	....s tmpepr1=$p(DicEMRCode,"&",j) 
	....s tmpeprVal=""
	....f k=1:1:$l(tmpepr1,"#")  d
	.....s tmpepr2=$p(tmpepr1,"#",k)
	.....s tmpeprValue=eprsubinfo.GetAt(tmpepr2)	//根据数据元取电子病历信息
	.....;s eprValue=eprValue_"#"_tmpeprValue
	.....;s eprValue=eprValue_"&"_tmpeprValue
	.....i k="1"  d
	......s tmpeprVal=tmpeprValue
	.....e  d
	......s tmpeprVal=tmpeprVal_"#"_tmpeprValue
	....i j="1" d
	.....s eprValue=tmpeprVal
	....e  d
	.....s eprValue=eprValue_"&"_tmpeprVal
	..e  d
	...s eprValue=..GetEPRInfoComExt(DicEMRCode,PAADM) ;通过配置字典函数获取值
	..;End 郑州医院用
	
	..f j=1:1:$l(DicEMRCode,"!") q:eprValue'=""  d      //取出以|分割符的病历字典数据传给医保，取到不为空的就不取了
	...s tmpepr1=$p(DicEMRCode,"!",j) 
	...s tmpeprValue=eprsubinfo.GetAt(tmpepr1)	//根据数据元取电子病历信息
	...s eprValue=tmpeprValue
	.e           d
	..s eprValue=""
	
	.;s eprValue=$$ALPHAUP^SSUTIL4(eprValue)              //去除字符以外的特殊符号
	.;s eprValue=..GetStringLong(eprValue,EprValueLong)  //格式化字段为固定长度
	.i RtnMode="XML"  d
	..s OutStr=OutStr_"<"_XMLNodeName_">"_eprValue_"</"_XMLNodeName_">"
	..//	.s Ret=Ret_"<pc>"_PHFreqCode_"</pc>"
	.e    d
	..i $l(eprValue,"^")<4 d
	...s eprValue=$tr(eprValue,"^","-")
	..i $l(eprValue,"^")=1 d                  ;加XML节点名称拼串，方便存储过程填写，by BSW 2015-09-15
	...s eprValue=XMLNodeName_"^"_eprValue_"^"_EprValueLong_"^"_EprValueType    ;加XML节点名称拼串，方便存储过程填写，by BSW 2015-09-15
	..i OutStr=""  d
	...s OutStr=eprValue
	..e       d
	...s OutStr=OutStr_"|"_eprValue
	.//##class(web.DHCINSUFacade).GetStringLong(PAADM,Instr)
	.//##class(web.DHCINSUFacade).GetStringLong(BIllDr,Instr,3)
	
	q OutStr
}

/// Creator：      liusf
/// CreatDate：    2015 07 20
/// Description:： 截取字符串的长度
/// Input：        eprValue：字符串  EprValueLong：要截取的长度
/// Return：       
/// Others:		   
/// w ##class(web.DHCINSUEPR).GetStringLong("1哈哈，","6")
ClassMethod GetStringLong(eprValue As %String, EprValueLong As %String) As %String
{
 s TmpLong=0
 s StrLong=0
 s RtnStr=""
 f j=1:1:$l(eprValue) q:StrLong>EprValueLong  d
 .s TmpVal=$e(eprValue,j,j)
 .i ($ASCii(TmpVal)<0)!($ASCii(TmpVal)>250) d   ;中文字符
 ..s TmpLong=2
 .e   d
 ..s TmpLong=1
 .s StrLong=StrLong+TmpLong
 .i (StrLong<EprValueLong)!(StrLong=EprValueLong)  d
 ..s RtnStr=RtnStr_TmpVal
 
 q RtnStr
}

/// 根据字典配置函数获取非电子病历数据集数据
/// DingSH 2015-09-10
/// w ##class(web.DHCINSUEPR).GetEPRInfoComExt("DHCEMRFUNC01X","3055894")
ClassMethod GetEPRInfoComExt(FuncType As %String, PAADM As %String) As %String
{
	n (FuncType,PAADM)
	q:($g(FuncType)="")||($g(PAADM)="") "-1"
	s OutStr=""
    s SysStr=##class(web.INSUDicDataCom).QueryByCode("SYS",FuncType)    //取系统字典
    //s SysStr="1014^SYS^DHCEMRFUNC12X^住院病案首页费用集函数^EPRservice.SystemData|GetMCFeeInfo|^^|"
    q:+SysStr=0 -2
    s RtnMode=$p(SysStr,"^",7)       //返回值模式   XML串或者某种分隔符的字段
    s RunWebClass=$p($p(SysStr,"^",5),"|",1)     //执行
    s RunMethod=$p($p(SysStr,"^",5),"|",2)     //执行
    s DicType=$p(SysStr,"^",3)       //函数分类的系统代码
    s eprInfoExt=""
    s eprInfoExt=..ClassMethodRun(RunWebClass,RunMethod,PAADM)
    s SysStr=##class(web.INSUDicDataCom).GetSys("","",DicType)
    //s SysStr="!1002^DHCEMRFUNC12X^1^HDSD00_12_169|住院总费用^空|200^1|Total^"
   // s SysStr=SysStr_"!1003^DHCEMRFUNC12X^1^HDSD00_12_170|住院自付费用^空|200^2|ZFFY^"
    s Cnt=$l(SysStr,"!")
    ;b ;01
    f i=2:1:Cnt  d
	.;w !,"Cnt=",Cnt,"SysStr=",SysStr
	.s TmpDicStr=$P(SysStr,"!",i)
	.//1002^DHCEMRFUNC12X^1^HDSD00_12_169|住院总费用^空|200^1|Total^
	.s eprValue=""
	.s DicEMRCode=$p(TmpDicStr,"^",6)               ;电子病历字典串
	.s eprValue=$p($p(TmpDicStr,"^",5),"|",1)       ;默认初始值
	.s EprValueLong=$p($p(TmpDicStr,"^",5),"|",2)   ;字段长度
	.s EprValueType=$p($p(TmpDicStr,"^",5),"|",3)   ;字段类型 by bsw 2015-09-15 方便存储过程类型传递
	.s XMLNodeName=$P($p(TmpDicStr,"^",4),"|")      ;XML节点名称
	.s eprValueInd=$p($p(TmpDicStr,"^",6),"|",1)
	.s eprValue=$p(eprInfoExt,"^",eprValueInd)
	.;b ;tt
	.;s eprValue=$$ALPHAUP^SSUTIL4(eprValue)              //去除字符以外的特殊符号
	.;b ;t1
	.;s eprValue=..GetStringLong(eprValue,EprValueLong)  //格式化字段为固定长度
	.;b ;t2
	.i RtnMode="XML"  d
	..s OutStr=OutStr_"<"_XMLNodeName_">"_eprValue_"</"_XMLNodeName_">"
	..//	.s Ret=Ret_"<pc>"_PHFreqCode_"</pc>"
	.e    d
	..i $l(eprValue,"^")<4 d
	...s eprValue=$tr(eprValue,"^","-")
	..s eprValue=XMLNodeName_"^"_eprValue_"^"_EprValueLong_"^"_EprValueType  ;加XML节点名称拼串，方便存储过程填写，by BSW 2015-09-15
	..i OutStr=""  d
	...s OutStr=eprValue
	..e       d
	...s OutStr=OutStr_"|"_eprValue
	
	q OutStr
}

/// DingSH 2015-09-10
/// w ##class(web.DHCINSUEPR).ClassMethodRun("EPRservice.SystemData","GetMCFeeInfo","3055894")
ClassMethod ClassMethodRun(RunWebClass As %String, RunMethod As %String, PAADM As %String) As %String
{
	n (RunWebClass,RunMethod,PAADM)
	s OutStr=""
	i $$$comMemberDefined(RunWebClass,$$$cCONSmethod,RunMethod) {
	   ;run ClassMethod
	   s OutStr=$classmethod(RunWebClass,RunMethod,PAADM)}
    elseif $$$comMemberDefined(RunWebClass,$$$cCLASSquery,RunMethod){
        ;run ClassQuery
        s rs=##class(%ResultSet).%New(RunWebClass_":"_RunMethod)
        s %Xsc="-1"
        s %Xsc=$method(rs,"Execute",PAADM)
        q:$$$ISERR(%Xsc) OutStr
		s columns=rs.GetColumnCount()
		f  q:rs.Next(.%Xsc)=0  i $$$ISOK(%Xsc) d
		.s rowdata=""
		.f coli=1:1:columns  d
		..s:rowdata'="" rowdata=rowdata_"^"_rs.GetData(coli)
		..s:rowdata="" rowdata=rs.GetData(coli)
	 	.i OutStr="" d 
	 	..s OutStr=rowdata
	 	.e  d
	 	..s OutStr=OutStr_"@"_rowdata
	 	;b ;01
	    d rs.%Close()
	 }
	
	 q OutStr
}

/// Creator：      Zhanmingchao
/// Description:： 根据就诊号和数据元电子病历病案首页信息,新项目用
/// Input：        PAADM:就诊号
/// 			  AGlossaryInternalID:数据元代码
/// Return：       电子病历病案首页信息
/// Others:	
/// w ##class(web.DHCINSUEPR).GetEprValueByCode(7379918,"HDSD00.11.110")
ClassMethod GetEprValueByCode(PAADM As %String, AGlossaryInternalID As %String) As %String
{
	q:((PAADM="")||($l(AGlossaryInternalID,".")'=3)) ""
	s tmpeprvalue=""
	s elementKey=""
	s:$d(^||TMPEPRAR(PAADM))=0 ^||TMPEPRAR(PAADM)=0
	;s eprsubinfo=##class(%ArrayOfDataTypes).%New()
	s eprsubid=$p(AGlossaryInternalID,".",1)_"."_$p(AGlossaryInternalID,".",2)
	i $d(^||TMPEPRAR(PAADM,eprsubid)) d
	.s:$d(^||TMPEPRAR(PAADM,eprsubid,AGlossaryInternalID))'=0 tmpeprvalue=$g(^||TMPEPRAR(PAADM,eprsubid,AGlossaryInternalID))	//根据数据元取电子病历信息
	e  d
	.s eprsubinfo=##class(%ArrayOfDataTypes).%New()
	.;s eprsubinfo=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(PAADM,eprsubid)
	.s eprsubinfo=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(PAADM,eprsubid)
	.q:eprsubinfo.Count()=0
	.f   s elementKey=eprsubinfo.Next(.elementKey)	q:elementKey=""  d
	..s ^||TMPEPRAR(PAADM,eprsubid,elementKey)=eprsubinfo.GetAt(elementKey)
	..s:elementKey=AGlossaryInternalID tmpeprvalue=^||TMPEPRAR(PAADM,eprsubid,elementKey)
	;s tmpeprvalue=eprsubinfo.GetAt(AGlossaryInternalID)	//根据数据元取电子病历信息
	q tmpeprvalue
GetEprValueByCodeEx
	w $ze
	s tmpeprvalue=""
	q tmpeprvalue
}

/// Creator：      Zhanmingchao
/// CreatDate：    20180503
/// Description:： 根据数据元取编目后的病案首页信息,新项目用
/// Input：        AppType:应用类型(Clinic,WT4,HQMS,Coding,参考病案接口说明)
/// 					PAADM:就诊号
/// 					AGlossaryInternalID:节点代码,例如：P00060000可以取到姓名
/// Return：       编目后的病案首页信息
/// Others:		   
/// w ##class(web.DHCINSUEPR).GetMRValueByCode("Clinic",10025128,"P00060000")
ClassMethod GetMRValueByCode(AppType As %String, PAADM As %String, AGlossaryInternalID As %String) As %String
{
	q:((PAADM="")||(AGlossaryInternalID="")) ""
	try{
		s dep=$p(^PAADM(PAADM),"^",4)
		s hospcode="",hosp=""
		s:dep'="" hosp=$P($G(^CTLOC(dep)),"^",22)
		i hosp=""  s hosp=$o(^CT("HOSP",0))
		i hosp'="" s hospcode=$p($g(^CT("HOSP",hosp)),"^",1)  ;医院代码
		s tmpeprvalue=""
		s elementKey=""
		;s PAADM=8739973	;test
		;s hospcode="400012916"
		s:$d(^||TMPMRAR(PAADM))=0 ^||TMPMRAR(PAADM)=0
		s mrsubid=AppType
		i $d(^||TMPMRAR(PAADM,mrsubid)) d
		.s:$d(^||TMPMRAR(PAADM,mrsubid,AGlossaryInternalID))'=0 tmpeprvalue=$g(^||TMPMRAR(PAADM,mrsubid,AGlossaryInternalID))	//根据数据元取电子病历信息
		e  d
		.b ;00
		.s mrsubinfo=##class(%ArrayOfDataTypes).%New()
		.;s mrsubinfo=##Class(DHCMRQ.IO.GetDataByMed).GetArrayOfDataByAdm(AppType,hospcode,PAADM,AGlossaryInternalID)
		.s mrsubinfo=##Class(DHCMRQ.IO.GetDataByMed).GetArrayOfDataByAdm(AppType,hospcode,PAADM)
		.b ;01
		.q:mrsubinfo.Count()=0
		.f   s elementKey=mrsubinfo.Next(.elementKey)	q:elementKey=""  d
		..s ^||TMPMRAR(PAADM,mrsubid,elementKey)=mrsubinfo.GetAt(elementKey)
		..s:elementKey=AGlossaryInternalID tmpeprvalue=^||TMPMRAR(PAADM,mrsubid,elementKey)
	}catch bs64err{
		w "Error！Location:"_bs64err.Location_",maybe "_bs64err.Data_" is "_bs64err.Name_",Args:PAADM:"_PAADM,",AGlossaryInternalID:"_AGlossaryInternalID,!
		s tmpeprvalue=""
	}
	q tmpeprvalue
}

/// w ##class(web.DHCINSUEPR).IGetFrontPageICDAll("10274090","O/1")
ClassMethod IGetFrontPageICDAll(PAADM, AppType) As %String
{
	 
	 s PreStr="",SelStr="",LastStr="",OutStr="",OutFlag=""
	 
	 s OutData=##Class(DHCWMR.IO.OutService).IGetFrontPageICDAll(PAADM,AppType)
	 
	 i AppType="O/1" d
	 .s OutData1=##Class(DHCWMR.IO.OutService).IGetFrontPageICDAll(PAADM,AppType)
	 .s OutData2=##Class(DHCWMR.IO.OutService).IGetFrontPageICDAll(PAADM,"O/2")
	 .i ((OutData1'="")&&(OutData2'="")) d
	 ..s OutData=OutData1_$C(1)_OutData2
	 .i ((OutData1'="")&&(OutData2="")) d
	 ..s OutData=OutData1
	 .i ((OutData1="")&&(OutData2'="")) d
	 ..s OutData=OutData2
	 .i ((OutData1="")&&(OutData2="")) d
	 ..s OutData=""
	  
	  i AppType="O/1" d
	  .s OutDataO3=##Class(DHCWMR.IO.OutService).IGetFrontPageICDAll(PAADM,"O/3") ;医保主要手术
	  .i OutDataO3'="" d
	  ..s OutStr=OutDataO3_$C(1)_OutData
	  ..s OutFlag="1" 
	  q:OutFlag="1" OutStr
	  
	  
	  s OutStr=OutData ;默认
	  s RowCnt=$l(OutData,$c(1))
      s YbRowInd="" ,Flag="N"
	  f i=1:1:RowCnt   d 
	  .s TmpRowData=$P(OutData,$c(1),i)
	  .i TmpRowData["医保主要" d 
	  ..s YbRowInd=i
	  ..s Flag="Y"
	  ..s SelStr=TmpRowData
	  .i ((Flag="N")&&(SelStr="")) d
	  ..i PreStr="" d
	  ...s PreStr=TmpRowData
	  ..e  d
	  ...s PreStr=PreStr_$C(1)_TmpRowData
	  .i ((i'=YbRowInd)&&(SelStr'="")) d
	  ..i LastStr="" d
	  ...s LastStr=TmpRowData
	  ..e  d
	  ...s LastStr=LastStr_$C(1)_TmpRowData
	  i SelStr'="" d
	  .s OutStr=SelStr_$C(1)_PreStr_$C(1)_LastStr
	  
	  q OutStr
}

/// Creator：      DingSH
/// CreatDate：    20180503
/// Description:： 根据数据元取编目后的病案首页信息,老项目用
/// Input：       
/// 					PAADM:就诊号
/// AppType: 类型（D:诊断、O/1:手术、O/2:操作）
/// RowInd：行数据第几行
/// ColInd: 列数据第几列			
/// Return：       编目后的病案首页信息
/// Others:	说明如果：RowInd=0时，是取医保主要诊断(手术)信息那一行的数据  
/// w ##class(web.DHCINSUEPR).GetMRValueByInd("10025128","D",1,1)
/// ##class(web.DHCINSUEPR).GetMRValueByInd({PAADM},"D",1,1)
/// w ##class(web.DHCINSUEPR).GetMRValueByInd("10274090","D",0,1)
ClassMethod GetMRValueByInd(PAADM As %String, AppType As %String, RowInd As %String, ColInd As %String) As %String
{
	q:((PAADM="")||(AppType="")) ""
   s tmpeprvalue=""
	try{
		;##Class(DHCWMR.IO.OutService).IGetFrontPageICDAll(AdmRowid,"O/1") 
		s:$d(^||TMPMRAR(PAADM))=0 ^||TMPMRAR(PAADM)=0
		s mrsubid=AppType
		i $d(^||TMPMRAR(PAADM,mrsubid)) d
		.i $d(^||TMPMRAR(PAADM,mrsubid))'=0  d
		..s OutData=$g(^||TMPMRAR(PAADM,mrsubid))
		..s RowCnt=$l(OutData,$c(1))
		..;s YbRowInd="" ,Flag="N"
		..;f i=1:1:RowCnt  q:Flag="Y"  d 
		..;.s TmpRowData=$P(OutData,$c(1),i)
		..;.i TmpRowData["医保主要" d 
		..;..s YbRowInd=i
		..;..s Flag="Y"
		..s RowData="" 
		..;i ((RowInd=0)&&(Flag="Y")) d 
		..;.s RowInd=YbRowInd
		..;e  d
		..;.s:RowInd=0 RowInd=1
		..s:+RowInd<=+RowCnt RowData=$P(OutData,$C(1),RowInd)	//根据数据元取电子病历信息
		..s:+ColInd<=$l(RowData,$C(2)) tmpeprvalue=$P(RowData,$C(2),ColInd)

		e  d

		.;s OutData=##Class(DHCWMR.IO.OutService).IGetFrontPageICDAll(PAADM,AppType)
		.s OutData=..IGetFrontPageICDAll(PAADM,AppType)
	    .s RowCnt=$l(OutData,$c(1))
		.;s YbRowInd="" ,Flag="N"
		.;f i=1:1:RowCnt  q:Flag="Y"  d 
		.;.s TmpRowData=$P(OutData,$c(1),i)
		.;.i TmpRowData["医保主要" d 
		.;..s YbRowInd=i
		.;..s Flag="Y"
		.s RowData="" 
		.;i ((RowInd=0)&&(Flag="Y")) d 
		.;.s RowInd=YbRowInd
		.;e  d
		.;.s:RowInd=0 RowInd=1
		.s:+RowInd<=+RowCnt RowData=$P(OutData,$C(1),RowInd)	//根据数据元取电子病历信息
		.s:+ColInd<=$l(RowData,$C(2)) tmpeprvalue=$P(RowData,$C(2),ColInd)
		.s ^||TMPMRAR(PAADM,mrsubid)=OutData
	}catch bs64err{
		w "Error！Location:"_bs64err.Location_",maybe "_bs64err.Data_" is "_bs64err.Name_",Args:PAADM:"_PAADM,",AGlossaryInternalID:"_AGlossaryInternalID,!
		s tmpeprvalue=""
	}
	q tmpeprvalue
}

}
