Import SQLUser

/// 数据上传信息相关类
/// wty 20210305
Class web.DHCINSUDataUL Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query QueryPat(PatNo As %String, MedNo As %String, UpFlag As %String, DateFlag As %String, SDate As %String, EDate As %String, InsuType As %String, OptType As %String, HOSPID As %String) As %Query(ROWSPEC = "TPatRegNo,TPatName,TMedcasNo,TAdmReason,TDepDesc,TAdmDate,TOutDate,TDisDate,TInsuNo,TInsuZylsh,TInsuDjlsh,TOpter,TOptDate,TOptFlag,Did,AdmDr,DivDr,TAdmType,THospID,TPrtDr,TInsuType,TPrtActStus")
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryPat","","","2","5","2021-04-17","2021-05-20","","IP",2)
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryPat","","","1","3",66141,66212,"00A","IP","2")
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryPat","","","1","3",66210,66219,"00A","IP","2")
ClassMethod QueryPatExecute(ByRef qHandle As %Binary, PatNo, MedNo, UpFlag, DateFlag, SDate, EDate, InsuType, OptType, HOSPID) As %Status
{
	s repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	
	s SDate=##class(websys.Conversions).DateHtmlToLogical(SDate)
	s EDate=##class(websys.Conversions).DateHtmlToLogical(EDate)
	s ^TMP("QueryPat")=$lb(PatNo,MedNo,UpFlag,DateFlag,SDate,EDate,InsuType, OptType, HOSPID)
	i UpFlag="2"{
		;s DateFlag=5 ;已上传数据只能按照上传日期查询
		i PatNo'="" d  ;登记号
		.s PAPMIDR=""
		.s PAPMIDR=$o(^PAPERi("PAPMI_PatNo",PatNo,PAPMIDR))
		.s Did=""
		.f  s Did=$o(^DHCINDULi("PapmiDr",PAPMIDR,Did)) q:Did=""  d
		..d queryItm
		e  i MedNo'="" d  ;病案号
		.s Did=""
		.f  s Did=$o(^DHCINDULi("MedNo",MedNo,Did)) q:Did=""  d
		..d queryItm		
		e  i DateFlag>0  d  ;DateFlag 3结算日期，4编目日期，5上传日期
		.i DateFlag=3 d
		..f iDate=SDate:1:EDate d
		...s Did=""
		...f  s Did=$o(^DHCINDULi("DisDate",iDate,Did)) q:Did=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINDUL(Did)),"^",10))
		....d queryItm
		.i DateFlag=4 d
		..f iDate=SDate:1:EDate d
		...s Did=""
		...f  s Did=$o(^DHCINDULi("BMDate",iDate,Did)) q:Did=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINDUL(Did)),"^",10))
		....d queryItm
		.i DateFlag=5 d
		..f iDate=SDate:1:EDate d
		...s Did=""
		...f  s Did=$o(^DHCINDULi("OptDate",iDate,Did)) q:Did=""  d
		....q:(InsuType'="")&(InsuType'=$p($g(^DHCINDUL(Did)),"^",10))
		....d queryItm
	}else {
		b ;ip
		i OptType="IP" d  ;住院
		.i DateFlag=3 d	;3结算日期
		..f iDate=SDate:1:EDate d		
		...s PrtDr=""
		...f  s PrtDr=$o(^DHCINVPRTZY(0,"DATE",iDate,PrtDr)) q:PrtDr=""  d
		....s PrtFlag=$p(^DHCINVPRTZY(PrtDr),"^",8)
		....q:(PrtFlag'="N")&&(PrtFlag'="I")
		....q:($d(^DHCINVPRTZY(0,"InitInv",PrtDr))'=0) //判断发票是否已经退费
		....s DivDr=$p(^DHCINVPRTZY(PrtDr),"^",34)
		....s HospDr=$p(^DHCINVPRTZY(PrtDr),"^",35)
		....//b ;HOSPID
		....q:HospDr'=HOSPID
		....s AdmDr=$p(^DHCINVPRTZY(PrtDr),"^",4)
		....d queryPrtItm
		.e  i DateFlag=4 d ;4编目日期
		..f iDate=SDate:1:EDate d
		...s xTime=""
		...f  s xTime=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,iDate,xTime)) q:xTime=""  d
		....s xFpID=""
		....f  s xFpID=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,iDate,xTime,xFpID)) q:xFpID=""  d
		.....s objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
		.....q:'$IsObject(objFrontPage)
		.....q:'$IsObject(objFrontPage.FPVolumeDr)
		.....q:objFrontPage.FPType'="F"  //首次编目
		.....s VolumeID=objFrontPage.FPVolumeDr.%Id()
		.....s AdmDr=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
		.....q:AdmDr=""
		.....s DepID=$p(^PAADM(AdmDr),"^",4) 
		.....s HospDr=$p(^CTLOC(DepID),"^",22)
		.....q:HospDr'=HOSPID
		.....s PrtDr=$o(^DHCINVPRTZY(0,"ADM",AdmDr,""),-1)
		.....i PrtDr'="" d
		......s DivDr=$p(^DHCINVPRTZY(PrtDr),"^",34)
		.....e  s DivDr=""
		.....d queryPrtItm	
		
		i OptType="OP" d ;门诊 只有结算日期
		.f iDate=SDate:1:EDate d
		..s PrtDr=""
		..f  s PrtDr=$o(^DHCINVPRT(0,"Date",iDate,PrtDr)) q:PrtDr=""  d
		...s PrtFlag=$p(^DHCINVPRT(PrtDr),"^",8)
		...q:PrtFlag'="N"
		...s DivDr=$p(^DHCINVPRT(PrtDr),"^",30)
		...s HospDr=$p(^DHCINVPRT(PrtDr),"^",39)
		...q:HospDr'=HOSPID
		...s BCIid=$o(^DHCBCI(0,"INV",PrtDr,""),-1)
		...q:BCIid=""
		...s AdmDr=$p(^DHCBCI(BCIid),"^",3)
		...d queryPrtItm		
    }
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
queryPrtItm
   	
	s PatID=+^PAADM(AdmDr)
	s AdmInfo=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmDr)
	s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospDr)		
	s TPatName=$p(PatInfo,"^",3)			;姓名
	s TPatRegNo=$p(PatInfo,"^",2)
	q:(PatNo'="")&(PatNo'=TPatRegNo) 		;登记号
	s TMedcasNo=$p(AdmInfo,"^",27)
	q:(MedNo'="")&(MedNo'=TMedcasNo) 		;病案号
	s TAdmReason=$p(AdmInfo,"^",29)		;费别
	s TDepDesc=$p(AdmInfo,"^",5)			;科室

	i DivDr'="" d
	.s DivInfo=$g(^DHCINDIV(DivDr))	
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s TInsuNo=$p(^DHCINADM(AdmInfoDr),"^",2)	;医保卡号
	.s TInsuZylsh=$p(DivInfo,"^",30)		;医保登记流水号
	.s TInsuDjlsh=$p(DivInfo,"^",8)		;医保结算流水号
	.s TInsuType=$p(^DHCINADM(AdmInfoDr),"^",18)	;医保类型
	e  d
	.s (TInsuNo,TInsuZylsh,TInsuDjlsh,TInsuType)=""	
	
	q:(InsuType'="")&(InsuType'=TInsuType)	;
	s TAdmType=OptType		;就诊类型
	b ;ooo
	s TAdmDate=$p(AdmInfo,"^",6)			;入院日期
	s TOutDate=$p(AdmInfo,"^",10)			;出院日期
	s TDisDate=$zd(iDate,3)				;结算日期
	s TOpter=""							;上传操作员
	s TOptDate=""							;上传日期
	s TOptFlag="未上传"							;上传标志
	s TCheckPrtActStus=..CheckPrtActStus(OptType,PrtDr)     //发票状态
	s Did=""
	if (TCheckPrtActStus="Y")
	{
	 s Did=$o(^DHCINDULi("PrtDr",OptType,PrtDr,""),-1)	
	 s TOptFlag=..GetOptFlag(Did,TAdmType,HOSPID,TInsuType)
	}
	s THospID=HospDr
	s TPrtDr=PrtDr
	s Data=$lb(TPatRegNo,TPatName,TMedcasNo,TAdmReason,TDepDesc,TAdmDate,TOutDate,TDisDate,TInsuNo,TInsuZylsh,TInsuDjlsh,TOpter,TOptDate,TOptFlag,Did,AdmDr,DivDr,TAdmType,THospID,TPrtDr,TInsuType,TCheckPrtActStus)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
queryItm
	s DPLStr=$g(^DHCINDUL(Did))
	s PatID=$p(DPLStr,"^",1)
	s AdmID=$p(DPLStr,"^",2)
	s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HOSPID)
	s TPatName=$p(PatInfo,"^",3)		;姓名
	s TPatRegNo=$p(PatInfo,"^",2)		;登记号
	s AdmInfo=$$GetAdmInfoByAdmID^DHCINSUPatInfo(AdmID)
	s TMedcasNo=$p(DPLStr,"^",4)		;病案号
	;q:UpFlag'=$p(DPLStr,"^",14)
	s TAdmReason=$p(AdmInfo,"^",29)		;费别
	s TDepDesc=$p(AdmInfo,"^",5)		;科室
	s TPrtDr=$p(DPLStr,"^",5)		;发票id
	s TAdmType=$p(DPLStr,"^",6)			;就诊类型
	q:OptType'=TAdmType
	s TInsuNo=$p(DPLStr,"^",7)			;医保卡号
	s TInsuZylsh=$p(DPLStr,"^",8)		;医保登记流水号
	s TInsuDjlsh=$p(DPLStr,"^",9)		;医保结算流水号
	s TInsuType=$p(DPLStr,"^",10)		;医保类型
	q:(InsuType'="")&(InsuType'=TInsuType)
	s TAdmDate=$p(DPLStr,"^",11)			;入院日期
	s TOutDate=$p(DPLStr,"^",12)		;出院日期
	s TDisDate=$p(DPLStr,"^",13)		;结算日期
	s TOpter=$p(DPLStr,"^",14)			;上传操作员
	s TOpter=$p(^SSU("SSUSR",TOpter),"^",2) 
	s TOptDate=$p(DPLStr,"^",15)		;上传日期
	s TOptTime=$p(DPLStr,"^",16)		;上传日期
	s TOptDate=$zd(TOptDate,3)_" "_$zt(TOptTime)
	s TOptFlag=$p(DPLStr,"^",17)		;上传标志
	i TOptFlag="Y" s TOptFlag="已上传"
	s TPrtActStus=..CheckPrtActStus(OptType,TPrtDr)     //发票状态
	s TOptFlag=..GetOptFlag(Did,TAdmType,HOSPID,TInsuType)
	s THospID=$p(DPLStr,"^",21)		;院区
	q:(HOSPID'="")&(HOSPID'=THospID)
	s DivDr=$p(DPLStr,"^",3)
	s Data=$lb(TPatRegNo,TPatName,TMedcasNo,TAdmReason,TDepDesc,$zd(TAdmDate,3),$zd(TOutDate,3),$zd(TDisDate,3),TInsuNo,TInsuZylsh,TInsuDjlsh,TOpter,TOptDate,TOptFlag,Did,AdmID,DivDr,TAdmType,THospID,TPrtDr,TInsuType,TPrtActStus)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetOptFlag(Did, OptType, HospDr, InsuType)
{
	s TOptFlag=""
	s CountStr=..CheckDataPortList(Did,OptType,HospDr,InsuType) ;获取实际上传的交易个数
	s DicCount=$p(CountStr,"^",1)
	s PLCount=$p(CountStr,"^",2)
	s PLErrCount=$p(CountStr,"^",3)
	i PLCount=0 d
	.s TOptFlag="未上传"
	.s:PLErrCount>0 TOptFlag="未成功"
	e  i PLCount<DicCount d
	.s TOptFlag="部分上传"
	e  d
	.s TOptFlag="成功"	
	q TOptFlag
}

/// 根据就诊类型及发票Id校验是否有效
/// Y/N
/// w ##class(web.DHCINSUDataUL).CheckPrtActStus("IP","290")
ClassMethod CheckPrtActStus(OptType, PrtDr)
{
	s $zt="CheckPrtActStusEx"
	s PrtActStus="N"                   //发票状态
	i (OptType="IP"){
		s PrtFlag=$p(^DHCINVPRTZY(PrtDr),"^",8)
	    i ((PrtFlag="N")||(PrtFlag="I"))&&($d(^DHCINVPRTZY(0,"InitInv",PrtDr))=0){
		   s PrtActStus="Y"
		   }
	}
	i (OptType="OP")
	{
	    s PrtFlag=$p(^DHCINVPRT(PrtDr),"^",8)
		i PrtFlag="N"{
		 s PrtActStus="Y"
		}
	}	
   q PrtActStus
CheckPrtActStusEx
 s $zt=""
 q "N"
}

ClassMethod QueryPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1 Set Row=""}
 Else      { Set Row=^CacheTemp(repid,ind) }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 保存上传记录主表
/// w ##class(web.DHCINSUDataUL).SaveDataUl(1,1809501,898760,"123","456")
/// 操作员id，就诊表id,结算表id,接口入参串，清单接口
ClassMethod SaveDataUl(InputInfo) As %String
{
	;userdr, admdr, divdr
	s TInsuType=$p(InputInfo,"^",1)
	s HospID=$p(InputInfo,"^",3)
	s userdr=$p(InputInfo,"^",4)
	s admdr=$p(InputInfo,"^",8)
	s divdr=$p(InputInfo,"^",9)
	s AdmType=$p(InputInfo,"^",10)
	s PrtDr=$p(InputInfo,"^",11)
	s PatID=+^PAADM(admdr)
	s AdmInfo=$$GetAdmInfoByAdmID^DHCINSUPatInfo(admdr)
	s PatInfo=$$GetPatInfoByPatID^DHCINSUPatInfo(PatID,HospID)
	s TPatName=$p(PatInfo,"^",3)			;姓名	
	s TMedcasNo=$p(AdmInfo,"^",27)
	s TAdmReason=$p(AdmInfo,"^",29)		;费别
	b ;lk
	s TDepDesc=$p(AdmInfo,"^",5)			;科室
	i divdr'="" d
	.s DivInfo=$g(^DHCINDIV(divdr))
	.s AdmInfoDr=$p(DivInfo,"^",2)
	.s TInsuNo=$p(^DHCINADM(AdmInfoDr),"^",2)	;医保卡号	
	.s TBillDr=$p(DivInfo,"^",3)		;
	.s TInsuZylsh=$p(DivInfo,"^",30)		;医保登记流水号
	.s TInsuDjlsh=$p(DivInfo,"^",8)		;医保结算流水号
	e  d
	.s (TInsuNo,TInsuZylsh,TInsuDjlsh)=""
	s TAdmDate=$zdh($p(AdmInfo,"^",6),3)			;入院日期
	//s TOutDate=$zdh($p(AdmInfo,"^",10),3)			;出院日期
	s TOutDate=$p(AdmInfo,"^",10)			        ;出院日期
	s:TOutDate'="" TOutDate=$zdh(TOutDate,3)       //修改 DingSH 20220615 
	i PrtDr'="" d
	.i AdmType="OP" s TDisDate=$p(^DHCINVPRT(PrtDr),"^",5)
	.i AdmType="IP" s TDisDate=$p(^DHCINVPRTZY(PrtDr),"^",2)
	s TOptDate=+$h							;上传日期
	s TOptTime=$p($h,",",2)
	s TOptFlag="Y"		;暂定
	s BMSJDate=##class(DHCWMR.IO.OutService).IGetFrontpageInfo(admdr) ;编目日期
	s BMSJDate=$p(BMSJDate,"^",2)
	i BMSJDate'="" s BMSJDate=$zdh(BMSJDate,3)
	s InString="^"_PatID_"^"_admdr_"^"_divdr_"^"_TMedcasNo_"^"_PrtDr_"^"_AdmType_"^"_TInsuNo_"^"_TInsuZylsh_"^"_TInsuDjlsh_"^"_TInsuType_"^"_TAdmDate
	s InString=InString_"^"_TOutDate_"^"_TDisDate_"^"_userdr_"^"_TOptDate_"^"_TOptTime_"^"_TOptFlag_"^"_HospID_"^"_BMSJDate
	s InString=InString_"^^^^^"
	b ;ulman
	s flag=$$InsertDataUL^DHCINSUDataUl(InString)
	q flag
}

/// 保存医保数据上传表，暂时只考虑住院，一个病人同时传多个交易
/// w ##class(web.DHCINSUDataUL).SaveDataMain("ZZB^4101^2^1^0^102^1^256^3^IP^489^^^^","","")
/// 操作员id，就诊表id,结算表id,交易编号，接口入参串，接口返回串
/// ExpStr:上传标识(Y 成功/N:失败)
/// w ##class(web.DHCINSUDataUL).SaveDataMain($lg(^temp("SaveDataMain"),1),$lg(^temp("SaveDataMain"),2),$lg(^temp("SaveDataMain"),3))
ClassMethod SaveDataMain(InputInfo, inargs, outargs, ExpStr = "") As %String
{
	s $zt="Err"
	k ^temp("SaveDataMain")
	s ^temp("SaveDataMain")=$lb(InputInfo,inargs,outargs,ExpStr)
	ts
	s RtnCode="-1"
	s userdr=$p(InputInfo,"^",4)
	s admdr=$p(InputInfo,"^",8)
	s divdr=$p(InputInfo,"^",9)
	s infno=$p(InputInfo,"^",2)
	s AdmType=$p(InputInfo,"^",10)  //此处做业务类型
	s PrtDr=$p(InputInfo,"^",11)
	s Did=$o(^DHCINDULi("PrtDr",AdmType,PrtDr,""),-1)	
	b ;kkk
	i Did="" d ;插主表(也可配置哪个infno交易插主表,其他交易就不判断了)
	.s Did=..SaveDataUl(InputInfo)
	i Did<0 d
	.tro
	q:Did<0 "-1^插主表失败"
	
	b ;数据上传接口表
	s DLid=..SaveDataPortList(Did, infno, userdr, inargs, outargs,ExpStr)
	i DLid<0 d
	.tro
	q:DLid<0 "-1^"
	
	 ;数据上传接口数据明细表，只能解析入参串得到数据。
	/*s DLSid=..SaveDataPortList(userdr, DLid, TableCode, SerialNO)
	i DLSid<0 d
	.tro
	q:DLSid<0 "-1"*/
	
	tc
	q Did	
Err
	s $zt=""
	tro	
	q -1_"^"_$ze
}

/// 医保数据上传接口表
/// w ##class(web.DHCINSUDataUL).SaveDataPortListSub(1,1,2222)
/// INSU_DataPortList表id，唯一序号
ClassMethod SaveDataPortList(Did, infno, userdr, inargs, outargs, ExpStr) As %String
{
	k PLIST
	s UptFlag=$P(ExpStr,"^",1) // DingSH 20220422
	s PLIST(2)=Did 
	s PLIST(3)=infno
	s PLIST(4)=userdr
	s PLIST(5)=+$h	
	s PLIST(6)=$p($h,",",2)
	s PLIST(7)=UptFlag
	s PLIST(8)=inargs
	s PLIST(9)=outargs
	&sql(insert into INSU_DataPortList values :PLIST())
	
	q SQLCODE
}

/// 医保数据上传接口数据明细表
/// w ##class(web.DHCINSUDataUL).SaveDataPortListSub(1,1,"Input",2222)
/// INSU_DataPortList表id，唯一序号
ClassMethod SaveDataPortListSub(userdr, PARID, TableCode, SerialNO) As %String
{
	k PLIST
	s PLIST(2)=PARID 
	s PLIST(3)=TableCode
	s PLIST(4)=SerialNO
	s PLIST(5)=userdr
	s PLIST(6)=+$h
	s PLIST(7)=$p($h,",",2)	
	s PLIST(8)="Y"	
	&sql(insert into INSU_DataPortListSub values PLIST())
	
	q SQLCODE
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDataUL","ReadInsuType")
Query ReadInsuType(HospDr) As %SQLQuery(CONTAINID = 1)
{
	SELECT INDID_DicCode, INDID_DicDesc  FROM INSU_DicData where INDID_DicType="DLLType" and INDID_HospDr=:HospDr
}

/// 获取实际上传的交易个数
/// w ##class(web.DHCINSUDataUL).CheckDataPortList(2,"IP",2)
/// 总共需要上传交易个数^上传成功个数^上传失败个数
ClassMethod CheckDataPortList(PARID, OptType, HospDr = "", InsuType = "") As %String
{
   s $zt="CheckDataPortListEx"
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("InsuDataULTradeNo00A",HospDr) 
	s rowid="",diccount=0 ;医保字典中配置的需要上传的交易个数
	s DPLcount=0    ;接口交易表中存的已经上传的交易个数
	s DPLErrcount=0 ;接口交易表中存的已经上传的失败交易个数 
	s NOptType=OptType
	//已经上传记录的
	i PARID'="" d
	.s DivDr=$P($g(^DHCINDUL(PARID)),"^",3)
	.s:DivDr="" InsuType=""
	i (InsuType="") d
	.s NOptType=OptType_"ZF" //自费
	f  s rowid=$o(^DHCINDID(0,"IType","InsuDataULTradeNo00A",rowid))	q:rowid=""  d
	.s s=$g(^DHCINDID(rowid))
	.s DicCode=$p(s,"^",2)
	.s DicDesc=$p(s,"^",3)
	.s tGroupHospDr=$p(s,"^",15)
	.q:GroupHospDr'=tGroupHospDr   
	.q:$p(s,"^",10)="Y" ;停用标志
	.//s ConfigStr=$p(s,"^",4)
	.s ConfigStr=$p(s,"^",8)
	.//q:$p(ConfigStr,"|",3)'=OptType  ;业务类型不一致退出
	.//q:ConfigStr'[OptType  ;业务类型不一致退出
	.q:("|"_ConfigStr_"|")'[("|"_NOptType_"|") ;业务类型不一致退出
	.s diccount=diccount+1
	.q:$g(PARID)=""
	.s DPLid=$o(^DHCINDPLi("TradeNo",PARID,DicCode,""),-1)   //User.INSUDataPortList 医保数据上传接口表
	.q:DPLid=""
	.s OptFlag=$p(^DHCINDPL(DPLid),"^",6)
	.//q:OptFlag'="Y"
	.s:OptFlag="Y" DPLcount=DPLcount+1
	.s:OptFlag="N" DPLErrcount=DPLErrcount+1
	q diccount_"^"_DPLcount_"^"_DPLErrcount
CheckDataPortListEx
 s $zt=""
 b ;异常 CheckDataPortListEx
 q "-1^"_$ze
}

/// 获取上传的交易个数
/// 注意：调用query:..QueryPortList
/// w ##class(web.DHCINSUDataUL).GetPortList(2,"IP",2,"00A")
/// 返回多行数据(!分割),其中行数据格式:交易代码^交易描述^上传人^上传日期^上传时间^上传记录Id^上传主记录Id
ClassMethod GetPortList(PARID As %String, OptType As %String, HospDr = "", InsuType = "") As %String
{
	s $zt="GetPortListEx"
	s rset=##class(%ResultSet).%New("web.DHCINSUDataUL.QueryPortList")
	s Status=rset.Execute(PARID,OptType,HospDr,InsuType)
	i ($$$ISERR(Status)){q "-1^"_$System.Status.DisplayError(Status)}
	s PortList=""
	while(rset.Next())
	{
	  s RStr=rset.GetDataByName("TradeNo")
	  s RStr=RStr_"^"_rset.GetDataByName("TradeDesc")
	  s RStr=RStr_"^"_rset.GetDataByName("UpFlag")
	  s RStr=RStr_"^"_rset.GetDataByName("OptUser")
	  s RStr=RStr_"^"_rset.GetDataByName("OptDate")
	  s RStr=RStr_"^"_rset.GetDataByName("OptTime")
	  s RStr=RStr_"^"_rset.GetDataByName("DPLid")
	  s RStr=RStr_"^"_rset.GetDataByName("DParid")
	  if PortList=""{
		   s PortList=RStr
		  }	
	   else{
		   s PortList=PortList_"!"_RStr
		 }
		
	}
	k rset
	s rset=""
	q PortList
GetPortListEx
 s $zt=""
 q "-1^"_$ze
}

Query QueryPortList(PARID As %String, OptType As %String, HospDr = "", InsuType = "") As %Query(ROWSPEC = "TradeNo,TradeDesc,UpFlag,OptUser,OptDate,OptTime,DPLid,DParid") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryPortList","","IP",2)
ClassMethod QueryPortListExecute(ByRef qHandle As %Binary, PARID As %String, OptType As %String, HospDr = "", InsuType = "") As %Status
{
	s repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	k ^temp("QueryPortList")
	s ^temp("QueryPortList")=$lb(PARID,OptType,HospDr,InsuType)
	s NOptType=OptType
	i InsuType="" d
	.s NOptType=OptType_"ZF" //自费
    s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("InsuDataULTradeNo00A",HospDr) 
	s rowid="",diccount=0 ;医保字典中配置的需要上传的交易个数
	f  s rowid=$o(^DHCINDID(0,"IType","InsuDataULTradeNo00A",rowid))	q:rowid=""  d
	.s s=$g(^DHCINDID(rowid))
	.s DicCode=$p(s,"^",2)
	.s DicDesc=$p(s,"^",3)
	.s tGroupHospDr=$p(s,"^",15)
	.q:GroupHospDr'=tGroupHospDr   
	.q:$p(s,"^",10)="Y" ;停用标志
	.//s ConfigStr=$p(s,"^",4)
	.s ConfigStr=$p(s,"^",8)
	.//q:$p(ConfigStr,"|",3)'=OptType  ;业务类型不一致退出
	.//q:ConfigStr'[OptType  ;业务类型不一致退出
	.q:("|"_ConfigStr_"|")'[("|"_NOptType_"|")  ;业务类型不一致退出
	.s UpFlag="未上传"
	.s (OptUser,OptDate,OptTime)=""
	.s DPLid=""
	.i PARID="" d output
	.q:PARID=""
	.s DPLid=$o(^DHCINDPLi("TradeNo",PARID,DicCode,""),-1)
	.i DPLid'="" d
	..s OptFlag=$p(^DHCINDPL(DPLid),"^",6)
	..//i OptFlag="Y" s UpFlag="已上传"
	..i OptFlag="Y" s UpFlag="上传成功"
	..i OptFlag="N" s UpFlag="上传失败"
	..s OptUser=$p(^DHCINDPL(DPLid),"^",3)
	..s OptUser=$p(^SSU("SSUSR",OptUser),"^",2) 
	..s OptDate=$zd($p(^DHCINDPL(DPLid),"^",4),3)
	..s OptTime=$zt($p(^DHCINDPL(DPLid),"^",5))
	..d output
	.e  d
	..d output	
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
output
	s Data=$lb(DicCode,DicDesc,UpFlag,OptUser,OptDate,OptTime,DPLid,PARID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QueryPortListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPortListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPortListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPortListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1 Set Row=""}
 Else      { Set Row=^CacheTemp(repid,ind) }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryDicInfo","InsuDataULTradeNo","2")
Query QueryDicInfo(DicType, HospDr) As websys.Query(ROWSPEC = "Rowid,Code,Desc") [ SqlProc ]
{
}

ClassMethod QueryDicInfoExecute(ByRef qHandle As %Binary, DicType, HospDr) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Rowid=0
	f  s Rowid=$o(^DHCINDID(0,"IType",DicType,Rowid)) q:Rowid=""  d
	.s Code=$p(^DHCINDID(Rowid),"^",2)
	.s Desc=$p(^DHCINDID(Rowid),"^",3)
	.q:(HospDr'="")&(HospDr'=$p(^DHCINDID(Rowid),"^",15))
	.d QueryDicInfo	
	
	s Code=""
	s Desc="全部(含自费)"
	d QueryDicInfo	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryDicInfo
	set Data=$lb(Rowid,Code,Desc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// w ##class(web.DHCINSUDataUL).GetPLInPutData("2163047",1)
ClassMethod GetPLInPutData(PLRowid As %String, ULRowid As %String, TradeNo As %String) As %String
{
	
	q:(PLRowid="")&&(ULRowid="") "-1^上传明细ID和上传主ID不能都为空"
	q:(PLRowid="")&&(ULRowid'="")&&(TradeNo="") "-1^上传明细ID为空时，上传主ID和交易代码都不能为空"
	if PLRowid="" {
		//s AdmDr=$p(^DHCINDIV(DivDr),"^",1)
		//q:$d(^DHCINDPLi("TradeNo",ULRowid,TradeNo))=0 "-1^未找到对应的上传记录"
		s:PLRowid="" PLRowid=$o(^DHCINDPLi("TradeNo",ULRowid,TradeNo,""),-1)
		
		if PLRowid =""{
			   //todo 调用数据维护方法动态生成交易入参
			}
		
		
	}
	q:PLRowid="" "-1^未找到对应的上传的明细记录"	
	s UlSRowid=$P(^DHCINDPL(PLRowid),"^",7)
	i +UlSRowid>0 d
    .s OutData=$g(^User.INSUDataPortListS(UlSRowid,1)) //IRIS2022后，写法有问题 要进行解压处理
	s OutData=$zcvt($SYSTEM.Encryption.Base64Decode(OutData),"I","UTF8") 
	q OutData
}

/// w ##class(web.DHCINSUDataUL).GetPLInPutData("",2)
ClassMethod GetPLOutPutData(PLRowid As %String, ULRowid As %String, TradeNo As %String) As %String
{
	;q ^DHCINEULi(1) ;测试
	s OutData=""
	q:(PLRowid="")&&(ULRowid="") "-1^上传明细ID和上传主ID不能都为空"
	q:(PLRowid="")&&(ULRowid'="")&&(TradeNo="") "-1^上传明细ID为空时，上传主ID和交易代码都不能为空"
	if PLRowid="" {
		//s AdmDr=$p(^DHCINDIV(DivDr),"^",1)
		q:$d(^DHCINDPLi("TradeNo",ULRowid,TradeNo))=0 "-1^未找到对应的上传记录"
		s:PLRowid="" PLRowid=$o(^DHCINDPLi("TradeNo",ULRowid,TradeNo,""),-1)
	}
	q:PLRowid="" "-1^未找到对应的上传的明细记录"	
	s UlSRowid=$P(^DHCINDPL(PLRowid),"^",8)
	i +UlSRowid>0 d
    .s OutData=$g(^User.INSUDataPortListS(UlSRowid,1)) //IRIS2022后，写法有问题 要进行解压处理
	s OutData=$zcvt($SYSTEM.Encryption.Base64Decode(OutData),"I","UTF8") 
	q OutData
}

/// 判断最后一次上传的上传标志
///  input: TradeNo->交易编号 SerialNo->唯一序号 TableCode->节点名
/// output:
/// w ##class(web.DHCINSUDataUL).GetOptFlagByTradeNoSerialNo("","")
ClassMethod GetOptFlagByTradeNoSerialNo(TradeNo As %String, SerialNo As %String, TableCode As %String = "") As %String
{
	s rtn=""	
	s rowid=""
	s rowid=$o(^DHCINDPLS("TradeNoSerino", TradeNo, SerialNo, rowid))
	if (rowid="")
	{
		s rtn=""
		q rtn
	}
	s temp=^DHCINDPLS(rowid)
	s OptFlag=$p(temp,"^",7)
	if (OptFlag="Y")
	{
		s rtn="上传成功"
		q rtn	
	}else
		{
			s rtn="上传失败"
			q rtn
		}
}

/// 通过PARID和TradeNo获取交易记录
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryPortListUL","8","4402")
Query QueryPortListUL(PARID As %String, TradeNo As %String) As %Query(ROWSPEC = "INDPLOpter,INDPLOptDate,INDPLOptTime,UpFlag,DPLid,DParid,TradeNo") [ SqlProc ]
{
}

ClassMethod QueryPortListULExecute(ByRef qHandle As %Binary, PARID As %String, TradeNo As %String) As %Status
{
	s ^Temp("QueryPortListUL")=$lb(PARID,TradeNo)
	s repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	s Rowid=""
	s UpFlag=""
	s Num=0
	i PARID'="" f  s Rowid=$O(^DHCINDPLi("TradeNo",PARID,TradeNo,Rowid),-1) q:Rowid=""  d
	.s s=$g(^DHCINDPL(Rowid))
	.s INDPLOpter=$p(s,"^",3)
	.s INDPLOptDate=$p(s,"^",4)
	.s:INDPLOptDate'="" INDPLOptDate=$zd(INDPLOptDate,3)
	.s INDPLOptTime=$p(s,"^",5)
	.s:INDPLOptTime'="" INDPLOptTime=$zt(INDPLOptTime)
	.s INDPLOptFlag=$p(s,"^",6)
	.i INDPLOptFlag="Y" s UpFlag="上传成功"
	.i INDPLOptFlag="N" s UpFlag="上传失败"
	.s Num=Num+1
	.d outputUL
	i Num=0 d
	.s Rowid=""
	.s INDPLOpter=""
	.s INDPLOptDate=""
	.s INDPLOptTime=""
	.s INDPLOptFlag=""
	.s UpFlag="未上传"
	.d outputUL
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
outputUL
	s Data=$lb(INDPLOpter,INDPLOptDate,INDPLOptTime,UpFlag,Rowid,PARID,TradeNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QueryPortListULClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPortListULExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPortListULFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPortListULExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1 Set Row=""}
 Else      { Set Row=^CacheTemp(repid,ind) }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 根据交易编号获取接口配置表PARID
/// w ##class(web.DHCINSUDataUL).GetPORTLISTIDByINFNO("2","0","00A","4201")
/// TYPE:线上：1,线下：0
ClassMethod GetPORTLISTIDByINFNO(HOSPID As %String, TYPE As %String, HITYPE As %String, INFNO As %String)
{
	s PARID=""
	s PARID=$o(^CF.INSU.MI.PORTLISTI("IndexHOSPTYPEHITYPEINFNO",HOSPID,TYPE,HITYPE,INFNO,""),-1)
	q PARID
}

/// 根据接口配置表ID获取接口入参数据集配置表SEQ=1的MethodName,ClassName,MethodType
/// w ##class(web.DHCINSUDataUL).GetMethodByPORTLISTID("15")
/// 类名^方法名^方法类型(QUERY或METHOD)^节点类型(S:单行/M:多行)
ClassMethod GetMethodByPORTLISTID(PORTLISTID As %String, SEQ As %String = 1)
{
	if (PORTLISTID="")
	{
		q "" 
		}
	s RowId=""
	s RowId=$o(^CF.INSU.MI.PORTNODEI("IndexOfPARIDSEQ",PORTLISTID,SEQ,""),-1)
	q:RowId="" ""
	s temp=^CF.INSU.MI.PORTNODED(RowId)
	s ClassName=$lg(temp,8)
	s MethodName=$lg(temp,9)
	s MethodType=$lg(temp,10)
	s NodeType=$lg(temp,6)
	q ClassName_"^"_MethodName_"^"_MethodType_"^"_NodeType
}

/// 明细详细
/// d ##class(%ResultSet).RunQuery("web.DHCINSUDataUL","Query","","")
Query QueryPortListSub(Code As %String, TradeNo As %String, Desc As %String, UpFlag As %String) As %Query(ROWSPEC = "")
{
}

ClassMethod QueryPortListSubExecute(ByRef qHandle As %Binary, Code As %String, TradeNo As %String, Desc As %String, UpFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (Desc="")
 	{
		s RowId=0
	 	for{
	 	 s RowId=""
	 	 q:RowId=""
	 	 s temp=^XXX(RowId)
		 s OptFlag=""
		 i OptFlag=UpFlag d
		 .s AAA=""
		 .d Build 
 			}
	 	}else
	 	{
		 s RowId=0
	 	for{
	 	 s RowId=""
	 	 q:RowId=""
	 	 s temp=^XXX(RowId)
		 s OptFlag=""
		 s Name=""
		 i (OptFlag=UpFlag)&&(Name[Desc) d
		 .s AAA=""
		 .d Build
		 	}
 	
	 	}
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
Build
	set Data=$lb()
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryPortListSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPortListSubExecute ]
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

ClassMethod QueryPortListSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPortListSubExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取上传字典
Query QueryPortListDic(PARID As %String, OptType As %String, HospDr = "", InsuType = "") As %Query(ROWSPEC = "TradeNo,TradeDesc,UpFlag,OptUser,OptDate,OptTime,DPLid,DParid") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUDataUL","QueryPortListDic","","IP",2)
ClassMethod QueryPortListDicExecute(ByRef qHandle As %Binary, PARID As %String, OptType As %String, HospDr = "", InsuType = "") As %Status
{
	s repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	k ^temp("QueryPortList")
	s ^temp("QueryPortList")=$lb(PARID,OptType,HospDr,InsuType)
	s DivDr=""
	i PARID'="" d
	.s DivDr=$P($g(^DHCINDUL(PARID)),"^",3)
	.s:DivDr="" InsuType=""
	s NOptType=OptType
	i (InsuType="") d
	.s NOptType=OptType_"ZF" //自费
    s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("InsuDataULTradeNo00A",HospDr) 
	s rowid="",diccount=0 ;医保字典中配置的需要上传的交易个数
	f  s rowid=$o(^DHCINDID(0,"IType","InsuDataULTradeNo00A",rowid))	q:rowid=""  d
	.s s=$g(^DHCINDID(rowid))
	.s DicCode=$p(s,"^",2)
	.s DicDesc=$p(s,"^",3)
	.s tGroupHospDr=$p(s,"^",15)
	.q:GroupHospDr'=tGroupHospDr   
	.q:$p(s,"^",10)="Y" ;停用标志
	.//s ConfigStr=$p(s,"^",4)
	.s ConfigStr=$p(s,"^",8)
	.//q:$p(ConfigStr,"|",3)'=OptType  ;业务类型不一致退出
	.//q:ConfigStr'[OptType  ;业务类型不一致退出
	.q:("|"_ConfigStr_"|")'[("|"_NOptType_"|")  ;业务类型不一致退出
	.s UpFlag="未上传"
	.s (OptUser,OptDate,OptTime)=""
	.s DPLid=""
	.i PARID="" d outputdic
	.q:PARID=""
	.s DPLid=$o(^DHCINDPLi("TradeNo",PARID,DicCode,""),-1)
	.i DPLid'="" d
	..s OptFlag=$p(^DHCINDPL(DPLid),"^",6)
	..//i OptFlag="Y" s UpFlag="已上传"
	..i OptFlag="Y" s UpFlag="上传成功"
	..i OptFlag="N" s UpFlag="上传失败"
	..s OptUser=$p(^DHCINDPL(DPLid),"^",3)
	..s OptUser=$p(^SSU("SSUSR",OptUser),"^",2) 
	..s OptDate=$zd($p(^DHCINDPL(DPLid),"^",4),3)
	..s OptTime=$zt($p(^DHCINDPL(DPLid),"^",5))
	..d outputdic
	.e  d
	..d outputdic
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
outputdic
	s Data=$lb(DicCode,DicDesc,UpFlag,OptUser,OptDate,OptTime,DPLid,PARID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod QueryPortListDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPortListDicExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPortListDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPortListDicExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { Set AtEnd=1 Set Row=""}
 Else      { Set Row=^CacheTemp(repid,ind) }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 获取医保数据采集接口上传数据集合
/// DingSH 20220622 
/// s rtn=##class(web.DHCINSUDataUL).GetInsuDataUL("医保类型^接口编号^医院ID^操作员ID^0^102^1^就诊号^InsuDivID^^发票dr^账单号","STR","JSON")
/// s rtn=##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4101^2^1^0^102^1^4409^644","STR","XML")
/// s rtn=##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4101^2^1^0^102^1^3107^519","STR","JSON")
/// s rtn=##class(web.DHCINSUDataUL).GetInsuDataUL("00A^5204^2^1^0^102^1^4101^10590","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL"BJA^4101BJ^2^1^0^102^1^4409^644","STR","XML")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4401^2^1^0^102^1^1902^39","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4402^2^909^0^^1^1902^39","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4201^2^909^0^^1^17857^^^573","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4401^2^13952^0^^1^17859^91^IP^574^","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4401^2^13952^0^^1^17859^91^IP^574^","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4503^2^13952^0^^1^1902^69^IP^465^","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4502^2^13952^0^^1^1902^69^IP^465^","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4503^2^909^0^^1^21^13^IP^15^","STR","JSON")
/// w ##class(web.DHCINSUDataUL).GetInsuDataUL("00A^4504^2^18928^0^^1^21^13^IP^15^","STR","JSON")
/// 入参：InputInfo：JSON或字符串
/// 	  InArgType:入参类型(JSON、STR)
/// 			HI_TYPE:医保类型
/// 			HOSPID：医院编号
/// 			UserId：操作员ID
/// 			TYPE：配置类型0：线下，1：线上
/// 		    INFNO：接口编号
/// 		  OutArgType:出参格式(JSON,XML,STR)
/// 出参：	
ClassMethod GetInsuDataUL(InputInfo As %String, InArgType As %String, OutArgType As %String) As %String
{
	s ^temp("GetInsuDataUL")=$lb(InputInfo,InArgType,OutArgType)
	s $zt="GetInsuDataULEx"
	s InsuPID=$I(^CacheTemp("InsuDataUL"))
	k ^CacheTemp("InsuDataUL",InsuPID)
	s Num=0
	s HiType=$P(InputInfo,"^",1)
	s Infno=$P(InputInfo,"^",2)
	s HospDr=$P(InputInfo,"^",3)
	s Type=$P(InputInfo,"^",5)
	//1 根据交易代码获取数据上传维护模板Id
	s PortLISTID=##class(web.DHCINSUDataUL).GetPORTLISTIDByINFNO(HospDr,Type,HiType,Infno)
	//2 根据维护模板Id获取配置的 类方法等信息
	s PortNodeInfo=##class(web.DHCINSUDataUL).GetMethodByPORTLISTID(PortLISTID)
	q:PortNodeInfo="" "-1^未获取到类方方法请核对上传模板维护"
	s ClassName=$P(PortNodeInfo,"^",1)
	s MethodName=$P(PortNodeInfo,"^",2)
	s MethodType=$P(PortNodeInfo,"^",3)
	s NodeType=$P(PortNodeInfo,"^",4)
	s InArgALLArr=##class(INSU.OFFBIZ.BL.BIZ00A).BulidInArgALLArr(InputInfo,InArgType,OutArgType)
	q:+InArgALLArr<0 "-1^入参转换数据数组出错，请检查入参"
	s ErrFlag="N",ErrMsg=""
	b ;MethodType
	if (NodeType="S")&&(MethodType="QUERY")
	{
		s tmpInput="" 
		s rs=##class(%ResultSet).%New(ClassName_":"_MethodName)
		s paramcnt=rs.GetParamCount()
		f i=1:1:paramcnt {
			s paramsName=rs.GetParamName(i)
			continue:paramsName=""
			i +i=1
			{
			   s tmpInput =InArgALLArr.GetAt(paramsName)
				
			}else{
				
				s tmpInput=tmpInput_","_InArgALLArr.GetAt(paramsName)
				}
			s SPT=""""
			//i className="EMRservice.BL.Interface.RecordInfoToINSU" d
			//.b ;QUERY
			//i InArgALLArr.GetAt(paramsName)="%EXPDATAARY"  d
			//.s SPT=""
			
		}
		s exeStr="rset=##class(%ResultSet).%New("""_ClassName_"."_MethodName_""")"
		s @exeStr
		s rset=@"rset"
		s exeStr="Status=rset.Execute"_"("_tmpInput_")"
		s @exeStr
	    q:'$IsObject(rset) "-1^执行Query加载数据失败"
	    s MainRArgName="",MainRArgKey=""
	    s MainRArr=##class(%ArrayOfDataTypes).%New() //主记录索引数组
	    s:Infno="4201" MainRArgName="feedetl_sn",MainRArgKey="PBDDr"
	    s:Infno="4401" MainRArgName="",MainRArgKey=""
	    s:Infno="4301" MainRArgName="",MainRArgKey=""
	    s:Infno="4501" MainRArgName="rpotc_no",MainRArgKey="Rpotcno" 
	    s:Infno="4502" MainRArgName="rpotc_no",MainRArgKey="Rpotcno" 
	    s:Infno="4503" MainRArgName="rpotc_no",MainRArgKey="Rpotcno" 
	    s:Infno="4504" MainRArgName="rpotc_no",MainRArgKey="Rpotcno" 
	    b ;rset0
		While ((rset.Next())&&(ErrFlag="N")) {
			b ;rset1
			s MainRArgVal=""
		    s:MainRArgName'="" MainRArgVal=rset.GetDataByName(MainRArgName)	
		    i MainRArgKey'="" d
		    .d MainRArr.SetAt(MainRArgVal,MainRArgKey)
		    s RtnS=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputInfo, InArgType,OutArgType,MainRArr)
		    i '$isObject($g(RtnS)){
			    s ErrFlag="Y"
			    s ErrMsg=RtnS
			    }
		    continue:'$isObject($g(RtnS))
		    d RtnS.Rewind()
		    s ^CacheTemp("InsuDataUL",InsuPID,Num)=RtnS.Read()
		    ;循环读取数据 upt 20221017 HanZH
		    set RtnSR=""
			set Size=RtnS.Size
			do{
				set Size=Size-32767
				set RtnSR=RtnSR_RtnS.Read()
			}while Size>0
			s ^CacheTemp("InsuDataUL",InsuPID,Num)=RtnSR
			
		    b ;num
		    s Num=Num+1
		    d MainRArr.Clear()
		}
	}
	else
	{
	 s Num=0
	 s RtnS=##class(INSU.OFFBIZ.BL.BIZ00A).InsuDataUL(InputInfo, InArgType,OutArgType)
	  i '$isObject($g(RtnS))
	   {
			s ErrFlag="Y"
			s ErrMsg=RtnS
		 }
		else
		{
		    d RtnS.Rewind()
		    ;s ^CacheTemp("InsuDataUL",InsuPID,Num)=RtnS.Read()
		    ;循环读取数据 upt 20221017 HanZH
		    set RtnSR=""
			set Size=RtnS.Size
			do{
				set Size=Size-32767
				set RtnSR=RtnSR_RtnS.Read()
			}while Size>0
			s ^CacheTemp("InsuDataUL",InsuPID,Num)=RtnSR
		    s Num=Num+1
		}
	}
	q:ErrFlag="Y" -1_"^"_InsuPID_"^"_ErrMsg
	q Num_"^"_InsuPID_"^"_""
GetInsuDataULEx
 s $zt=""
 k ^CacheTemp("InsuDataUL",InsuPID)
 q "-99^"_$ze
}

/// 跟进PID和Index获取医保数据采集接口上传数据
/// DingSH 20220622 
ClassMethod GetInsuDataULFromCacheTemp(PID As %String, index As %String) As %String
{
	s $zt="GetInsuDataULFromCacheTempEx"
	 s outstr=""
     s mCurrRowCacheTemp=$g(^CacheTemp("InsuDataUL",PID ,index))
     s outstr=mCurrRowCacheTemp
     i $o(^CacheTemp("InsuDataUL",PID,""),-1)=index d
  	 .k ^CacheTemp("InsuDataUL",PID)	
  	 q outstr		
  	 
GetInsuDataULFromCacheTempEx
 s $zt=""
 q "-99^"_$ze
}

/// add HanZH 20220628 from GuoN
/// 判断改交易是否已经上传 Y上传 N未上传
/// w ##class(web.DHCINSUDataUL).CheckUPFlag("7101","O22062000001")
ClassMethod CheckUPFlag(TradeNo, MainIndex) As %String
{
	q:(TradeNo="")&&(MainIndex="") "N"
	s ULRowid=$o(^DHCINDULi("0","MainIndex",MainIndex,""),-1)	
	q:ULRowid="" "N"
	s PLRowid=""
	s PLRowid=$o(^DHCINDPLi("TradeNo",ULRowid,TradeNo,""),-1)
	q:PLRowid="" "N"
	s OptFlag=$p(^DHCINDPL(PLRowid),"^",6)
	Q:OptFlag'="Y" "N"
	q "Y"
}

/// add HanZH 20220628 from GuoN
/// 判断改交易是否已经上传 Y上传 N未上传
/// w ##class(web.DHCINSUDataUL).GetOutputData("7101","E220701000006")
ClassMethod GetOutputData(TradeNo, MainIndex) As %String
{
	q:(TradeNo="")&&(MainIndex="") ""
	s ULRowid=$o(^DHCINDULi("0","MainIndex",MainIndex,""),-1)	
	q:ULRowid="" ""
	s PLRowid=""
	s PLRowid=$o(^DHCINDPLi("TradeNo",ULRowid,TradeNo,""),-1)
	q:PLRowid="" ""
	b ;PLRowid
	s UlSRowid=$P(^DHCINDPL(PLRowid),"^",8)
	q:UlSRowid="" ""
	i +UlSRowid>0 d
    .s OutData=$g(^User.INSUDataPortListS(UlSRowid,1)) //IRIS2022后，写法有问题 要进行解压处理
	q OutData
}

/// add HanZH 20220628 from GuoN
/// 判断改交易是否已经上传 Y上传 N未上传
/// w ##class(web.DHCINSUDataUL).GetOutputData("7101","O22052500001")
ClassMethod StrikeUpFlag(TradeNo, MainIndex) As %String
{
	q:(TradeNo="")&&(MainIndex="") ""
	s ULRowid=$o(^DHCINDULi("0","MainIndex",MainIndex,""),-1)	
	q:ULRowid="" ""
	s PLRowid=""
	s PLRowid=$o(^DHCINDPLi("TradeNo",ULRowid,TradeNo,""),-1)
	q:PLRowid="" ""
	b ;PLRowid
	s UlSRowid=$P(^DHCINDPL(PLRowid),"^",8)
	q:UlSRowid="" ""
	i +UlSRowid>0 d
    .s OutData=$g(^User.INSUDataPortListS(UlSRowid,1)) //IRIS2022后，写法有问题 要进行解压处理
	q OutData
}

}
