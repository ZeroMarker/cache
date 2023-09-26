Import SQLUser

Class web.DHCBillCheckBusiData Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod INSERT() As %String
{
	s $ZT="ERROR^DHCSSERR"
	d ..tb()
	k PLIST(1)
	&sql(insert into DHC_BillCheckBusiData Values PLIST())
	d ..tc()
	i 'SQLCODE d  q ..SELECT(%ROWID)  
	q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_BillCheckBusiData WHERE DHCBCBD_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	&sql(UPDATE DHC_BillCheckBusiData VALUES PLIST() WHERE DHCBCBD_Rowid= :RowId)
	d ..tc()
	i 'SQLCODE q ..SELECT(%ROWID)
	q $$code^SSUTILSQ(SQLCODE)
	;
}

ClassMethod DELETE(RowId)
{
	k PLIST
	&sql(Delete FROM DHC_BillCheckBusiData WHERE DHCBCBD_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod DELETEALL()
{
	k PLIST
	&sql(Delete FROM DHC_BillCheckBusiData) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod DELETEBYTYPE(DELETEBYTYPE)
{
	k PLIST
	&sql(Delete FROM DHC_BillCheckBusiData WHERE DHCBCBD_Type= :DELETEBYTYPE) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  Set SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  Set SQLCODE=$zu(34)
	q
}

ClassMethod InsertBusiData(InsInfo)
{
	;s obj=##class(User.DHCOrderLinkTar).%OpenId(olt)
	;s jsonStr=##class(ext.util.JsonObject).ObjToJson(obj)
	Kill PLIST
	Set PLIST(2)=$p(InsInfo,"^",1)
	Set PLIST(3)=$p(InsInfo,"^",2)
	Set PLIST(4)=$p(InsInfo,"^",3)
	Set PLIST(5)=$p(InsInfo,"^",4)
	Set PLIST(6)=$p(InsInfo,"^",5)
	Set PLIST(7)=$p(InsInfo,"^",6)
	Set PLIST(8)=$p(InsInfo,"^",7)
	Set PLIST(9)=$p(InsInfo,"^",8)
	Set PLIST(10)=$p(InsInfo,"^",9)
	Set PLIST(11)=+$h
	Set PLIST(12)=$p($h,",",2)
	Set PLIST(13)=$p(InsInfo,"^",10)
	Set rtn=##class(web.DHCBillCheckBusiData).INSERT()
	Quit rtn
}

/// d ##class(%ResultSet).RunQuery("web.DHCBillCheckBusiData","FindBusiData","UnhandPrtErr")
Query FindBusiData(Node As %String = "") As websys.Query(ROWSPEC = "病人姓名:%String,就诊ID:%String,规则类型:%String,子规则:%String,描述:%String,医嘱ID:%String,医嘱项名称:%String,执行记录ID:%String,账户表ID:%String,发票表ID:%String,账单ID:%String,数据:%String,表ID:%String,HJFlag:%String")
{
}

ClassMethod FindBusiDataExecute(ByRef qHandle As %Binary, Node As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1,count=1
    Set ^TMP("tt",4)=Node
    Kill ArrayOrder
    If Node="" Do
    .Set Node=""
    .For  Set Node=$o(^DHCBILLCHECKBUSIDATA("0","Node",Node)) Quit:Node=""  d
    ..Quit:Node=0
    ..Set Rowid=""
    ..For  Set Rowid=$o(^DHCBILLCHECKBUSIDATA("0","Node",Node,Rowid)) Quit:Rowid=""  Do
    ...Quit:Rowid=0
    ...Do GetData(Rowid)
    Else  Do
    .Set Rowid=""
    .For  Set Rowid=$o(^DHCBILLCHECKBUSIDATA("0","Node",Node,Rowid)) Quit:Rowid=""  Do
    ..Quit:Rowid=0
    ..Do GetData(Rowid)
    Do OutputRowBD1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetData(Rowid)
	Set ArcimDesc="",PatName=""
    Set DHCBCBDType=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",1)
    Set DHCBCBDText=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",4)
    Set DHCBCBDData=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",9)
	Set DHCBCBDNode=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",2)
	Set DHCBCBDSubType=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",3)
    Set DHCBCBDAdm=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",5)
    Set DHCBCBDOEORI=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",6)
	Set DHCBCBDOEORE=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",7)
    Set DHCBCBDPB=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",8)
    Set DHCBCBDAccM=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",12)
    Set DHCBCBDPrt=$p(^DHCBILLCHECKBUSIDATA(Rowid),"^",13)
    If DHCBCBDType="YCFeeCheck" Do
    .If DHCBCBDOEORI'="" Do
    ..Set ArcimRowid=$p(^OEORD(+DHCBCBDOEORI,"I",$p(DHCBCBDOEORI,"||",2),1),"^",2)
    ..If ArcimRowid'="" Do
    ...Set ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
    .If DHCBCBDAdm'="" Do
    ..Set PapmiDr=$p(^PAADM(DHCBCBDAdm),"^",1)
    ..Set PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ..Set PatNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ..Set Medicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PapmiDr,"I","","")
    ..Set PatName="姓名:"_PatName_" 登记号:"_PatNo_" 病案号:"_Medicare
    If DHCBCBDType="OPAccMCheck" Do
    .If DHCBCBDAccM'="" Do
    ..Set PapmiDr=$p(^DHCACD("AccM",DHCBCBDAccM),"^",2)
    ..Set PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ..Set PatNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ..Set Medicare="" 
    ..Set PatName="姓名:"_PatName_" 登记号:"_PatNo_" 病案号:"_Medicare
    If DHCBCBDType="OPInsuPrtCheck" Do
    .If DHCBCBDPrt'="" Do
    ..Set flag=$p(DHCBCBDPrt,":",1)
    ..Set PrtRowid=$p(DHCBCBDPrt,":",2)
    ..If flag="PRT" Do
    ...Set PapmiDr=$p(^DHCINVPRT(PrtRowid),"^",15)
    ..If flag="API" Do
    ...Set PapmiDr=$p(^DHCINVPRTAP(PrtRowid),"^",11)
    ..If flag="PE" Do
    ...Set PapmiDr=$p(^DHCPEINVPRT(PrtRowid),"^",2)
    ..Set PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
    ..Set PatNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
    ..Set Medicare="" 
    ..Set PatName="姓名:"_PatName_" 登记号:"_PatNo_" 病案号:"_Medicare
    If DHCBCBDType="OPUnhandPrtCheck" Set PatName="OPUnhandPrtCheck"
    Set ArcimDesc=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(ArcimDesc)
    Set DHCBCBDData=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(DHCBCBDData)
    Set DHCBCBDText=##class(DHCBILLConfig.DHCBILLFIND).EvalJSON(DHCBCBDText)
   
    If DHCBCBDOEORI'="" Set DHCBCBDOEORI=DHCBCBDOEORI_" (OE_OrdItem.OEORI_RowId)"
    If DHCBCBDOEORE'="" Set DHCBCBDOEORE=DHCBCBDOEORE_" (OE_OrdExec.OEORE_RowId)"
    If DHCBCBDPB'="" Set DHCBCBDPB=DHCBCBDPB_" (DHC_PatientBill.PB_RowId)"
    
    Set Str=DHCBCBDNode_"!@#"_DHCBCBDSubType_"!@#"_DHCBCBDText_"!@#"_DHCBCBDAdm_"!@#"_DHCBCBDOEORI
    Set Str=Str_"!@#"_DHCBCBDOEORE_"!@#"_DHCBCBDPB_"!@#"_DHCBCBDData_"!@#"_ArcimDesc_"!@#"_Rowid
    Set Str=Str_"!@#"_PatName_"!@#"_DHCBCBDAccM_"!@#"_DHCBCBDPrt
    
    If DHCBCBDType="YCFeeCheck" Set ArrayOrder(DHCBCBDAdm,Node,DHCBCBDSubType,count)=Str
    If DHCBCBDType="OPAccMCheck" Set ArrayOrder(DHCBCBDAccM,Node,DHCBCBDSubType,count)=Str
    If DHCBCBDType="OPInsuPrtCheck" Set ArrayOrder(DHCBCBDPrt,Node,DHCBCBDSubType,count)=Str
    If DHCBCBDType="OPUnhandPrtCheck" Set ArrayOrder(DHCBCBDType,Node,DHCBCBDSubType,count)=Str

	Set count=count+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBD1
	Set Adm=""
	For  Set Adm=$o(ArrayOrder(Adm)) Quit:Adm=""  Do
	.Set Node="",AdmNum1=0
	.For  Set Node=$o(ArrayOrder(Adm,Node)) Quit:Node=""  Do
	..Set SubType="",AdmNum2=0
	..For  Set SubType=$o(ArrayOrder(Adm,Node,SubType)) Quit:SubType=""  Do
	...Set ID=""
	...For  Set ID=$o(ArrayOrder(Adm,Node,SubType,ID)) Quit:ID=""  Do
	....Set DHCBCBDNode=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",1)
	....Set DHCBCBDSubType=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",2)
	....Set DHCBCBDText=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",3)
	....Set DHCBCBDAdm=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",4)
    ....If DHCBCBDAdm'="" Set DHCBCBDAdm=DHCBCBDAdm_" (PA_Adm.PAADM_RowID)"
	....Set DHCBCBDOEORI=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",5)
	....Set DHCBCBDOEORE=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",6)
	....Set DHCBCBDPB=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",7)
	....Set DHCBCBDData=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",8)
	....Set ArcimDesc=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",9)
	....Set Rowid=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",10)
	....Set PatName=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",11)
	....Set DHCBCBDAccM=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",12)
	....Set DHCBCBDPrt=$p(ArrayOrder(Adm,Node,SubType,ID),"!@#",13)
    ....If DHCBCBDAccM'="" Set DHCBCBDAccM=DHCBCBDAccM_" (DHC_AccManager.AccM_RowID)"
    ....If DHCBCBDPrt'="" Do
    .....Set flag=$p(DHCBCBDPrt,":",1)
    .....Set PrtRowid=$p(DHCBCBDPrt,":",2)
    .....If flag="PRT" Set DHCBCBDPrt=PrtRowid_" (DHC_INVPRT.PRT_Rowid)"
    .....If flag="API" Set DHCBCBDPrt=PrtRowid_" (DHC_AccPayINV.API_RowID)"
    .....If flag="PE" Set DHCBCBDPrt=PrtRowid_" (DHC_PE_INVPRT.PRT_ROWID)"
	....Set AdmNum1=AdmNum1+1
	....Set AdmNum2=AdmNum2+1
	....Set HJFlag=""
	....Do OutputRowBD
	..Set (DHCBCBDAdm,DHCBCBDSubType,DHCBCBDText,DHCBCBDOEORI,ArcimDesc,DHCBCBDOEORE,DHCBCBDPB,DHCBCBDData,Rowid,DHCBCBDAccM,DHCBCBDPrt)=""
	..Set DHCBCBDNode=DHCBCBDNode_"____小计数量:"_AdmNum2_" 条",HJFlag=1
	..Do OutputRowBD
	.Set (DHCBCBDAdm,DHCBCBDNode,DHCBCBDSubType,DHCBCBDText,DHCBCBDOEORI,ArcimDesc,DHCBCBDOEORE,DHCBCBDPB,DHCBCBDData,Rowid,DHCBCBDAccM,DHCBCBDPrt)=""
	.Set PatName=$p(PatName," ",1)
	.Set DHCBCBDAdm=DHCBCBDAdm_"____合计数量:"_AdmNum1_" 条",HJFlag=2
	.Do OutputRowBD
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBD
	Set Data=$lb(PatName,DHCBCBDAdm,DHCBCBDNode,DHCBCBDSubType,DHCBCBDText,DHCBCBDOEORI,ArcimDesc,DHCBCBDOEORE,DHCBCBDAccM,DHCBCBDPrt,DHCBCBDPB,DHCBCBDData,Rowid,HJFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// 此方法每日执行，查询计费基础数据有错误的数据，并会对demo发送消息
/// d ##class(web.DHCBillCheckBusiData).AutoCheckBusiData()
ClassMethod AutoCheckBusiData()
{
	Do ..DELETEALL()
	Set VersionFlag="New"
	Set Date=+$h-1
	/*
	; 检查住院业务信息
	Set AdmRowid=""
	For  Set AdmRowid=$o(^PAADMi("AdmTypeCurr","I",AdmRowid)) Quit:AdmRowid=""  Do
	.Quit:AdmRowid=0
	.Set InBedDate=Date,OutDate=Date
	.Do ..FindAbnormalFee(AdmRowid,VersionFlag,InBedDate,OutDate)
	*/
	
	; 检查门诊账户信息
	Do ..CheckAccMData(Date)
	; 检查门诊医保发票数据是否一致
	Do ..CheckOPInsuPrtData(Date)
	
	If $d(^DHCBILLCHECKBUSIDATA("0","CreateDate",+$h)) Do
	.Set JsonStr="{""link"":""dhcbillcheck.showdata.csp?classname=web.DHCBillCheckBusiData&methodname=FindBusiData&menuparam=&menuparamnum=1"",""dialogHeight"":""1000px"",""dialogWidth"":""1200px""}"
	.Set Rtn=##class(websys.DHCMessageInterface).Send("费用核查业务数据有误","1057","1","","","1",JsonStr)

	Quit
}

/// d ##class(web.DHCBillCheckBusiData).FindAbnormalFee(59,"New")
ClassMethod FindAbnormalFee(EpisodeID, VersionFlag, InBedDate, OutDate)
{
	New (EpisodeID,VersionFlag,InBedDate,OutDate)
	Set (sureflag,PAPERNo,PAPERName,BedCode,PatInDays,WardDesc,PAPERDr,AbnormalDesc,AbnormalDr)=""
    If AbnormalDesc=""  d 
    .Set AbnormalDr="0"

	Kill ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j)
	Kill ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j)
	Kill ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j)
	Kill ^TMP("DHCIPBill","OEORDErr",EpisodeID,$j)
	Kill ^TMP("DHCIPBill","YCFeeCheckNDate",EpisodeID,$j)
	
	; 取基础系统配置
	Set Conf=""
	Set Conf=$o(^DHCTarC("CF",Conf))
	Set DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
	If DefaultCP="" Set DefaultCP="OD"
	Set PhOutFlag=##class(web.UDHCJFBILLIP).GetPhOutFlag(EpisodeID)

	Set OEOrdDr=$o(^OEORD(0,"Adm",EpisodeID,""))
	Quit:OEOrdDr=""
	; modify 2014-10-10 判断病人是否做过手术
	Set ssflag=..JudgeANOP(EpisodeID)
	; mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	Set AllowNegativeArcim=$g(^DHCINTBILLARC("ARC"))
	; modify 2015-12-15 获取核查配置
	Do ..GetAbFeeConfig(EpisodeID,InBedDate,OutDate)
	
	; modify 2015-12-16 获取数据不全的医嘱
	Set OEOriDr="0",PBNegativeNum=0
	For  Set OEOriDr=$o(^OEORD(OEOrdDr,"I",OEOriDr))  Quit:(OEOriDr="")  Do
	.Quit:($d(^OEORD(+OEOrdDr,"I",OEOriDr,1))=0)
	.Set OEORIRowid=OEOrdDr_"||"_OEOriDr
	.Set NullNum=..GetNullData(EpisodeID,OEOrdDr,OEOriDr)
	.Quit:NullNum'=0	; 判断医嘱项，医嘱子类，医嘱大类是否有空数据，空数据记录后，不往下执行
	.If VersionFlag'="New"  Do 
	..Do ..GetOEORIInfo(EpisodeID,OEORIRowid,ssflag)
    .Else  Do
    ..Do ..GetOEOREInfo(EpisodeID,OEOrdDr,OEOriDr,ssflag)
    
	//modfiy 2014-11-04 婴儿和母亲一个账单的核查
    Set Conf=$O(^DHCTarC("CF",""))
    Set BabyFlag=$p(^DHCTarC("CF",Conf),"^",5)
    If BabyFlag="Y"  Do
    .Set BabyAdmRowid="0"
    .For  Set BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  Quit:(BabyAdmRowid="")  Do
	..;Set ssflag=..JudgeANOP(BabyAdmRowid)
    ..Set BabyOEOrdDr="0"
    ..For  Set BabyOEOrdDr=$o(^OEORD(0,"Adm",BabyAdmRowid,BabyOEOrdDr))  Quit:(BabyOEOrdDr="")  Do 
    ...Set OEOriDr="0",PBNegativeNum=0
	...For  Set OEOriDr=$o(^OEORD(BabyOEOrdDr,"I",OEOriDr))  Quit:(OEOriDr="")  d
	....Quit:($d(^OEORD(+BabyOEOrdDr,"I",OEOriDr,1))=0)
	....Set OEORIRowid=BabyOEOrdDr_"||"_OEOriDr
	....Set NullNum=..GetNullData(EpisodeID,BabyOEOrdDr,OEOriDr)
	....Quit:NullNum'=0	; 判断医嘱项，医嘱子类，医嘱大类是否有空数据，空数据记录后，不往下执行
	....If VersionFlag'="New"  Do 
	.....Do ..GetOEORIInfo(EpisodeID,OEORIRowid,ssflag)
    ....Else  Do
    .....Do ..GetOEOREInfo(EpisodeID,BabyOEOrdDr,OEOriDr,ssflag)
    
    Do ..CheckDateFee(EpisodeID)
	Quit
}

/// 判断病人是否做过手术
ClassMethod JudgeANOP(EpisodeID)
{
	///modify 2014-10-10 判断病人是否做过手术
	Set ssflag=0,ssordflag=0,opdescs=""
	Set op="" For  Set op=$o(^DHCANOPArrange(0,"Adm",EpisodeID,op)) Quit:op=""  Do
	.Set opstatus=$p(^DHCANOPArrange(op),"^",27)
	.Quit:(opstatus="A")!(opstatus="D")!(opstatus="N")
	.Set arrdate=$p(^DHCANOPArrange(op),"^",7)
	.Set arrtime=$p(^DHCANOPArrange(op),"^",8)
	.Set arrusr=$p(^DHCANOPArrange(op),"^",9)
	.Quit:(arrdate="")!(arrusr="")
	.Set ssflag=1
	.Set arrdate=$zd(arrdate,3)
	.Set anaId=$P($G(^DHCANOPArrange(op)),"^",2)
	.Set anaSub=$P(anaId,"||",2)
	.Set anaopSub="" For  Set anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) Quit:(anaopSub="")||(+anaopSub=0)  Do
	..Set opDr=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",6)
	..If opDr'="" Set opdesc=$P($G(^ORC("OPER",operDr)),"^",2)
	..Quit  Set opdesc=""
	..If opdescs="" Set opdescs=arrdate_"|"_opdesc
	..Else  Set opdescs=opdescs_"|"_arrdate_"|"_opdesc
	Quit ssflag
}

/// d ##class(web.DHCBillCheckBusiData).GetAbFeeConfig(1,1,2)
ClassMethod GetAbFeeConfig(EpisodeID, InBedDate, OutDate)
{
	Set node=""
	For  Set node=$o(^DHCCAbFeeConfig("YCFeeCheck",node)) Quit:node=""  Do
	.Set espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.Set useflag=$p(espression,"^",4)
	.Quit:useflag=0   ; 停用
	.Set NormalDesc=$p(espression,"^",3)
	.For PrtDate=InBedDate:1:OutDate  Do
	..If (node=1)!(node=2)!(node=5)!(node=6)  Do 
	...Set ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate)=""
	.If node=7   Do
	..Set ktfstart=$p(NormalDesc,"|",2)
    ..Set ktfend=$p(NormalDesc,"|",3)
    ..Set ktfstart=$zdh(ktfstart,3)
    ..Set ktfend=$zdh(ktfend,3)  
    ..For PrtDate=ktfstart:1:ktfend  Do
    ...Quit:(PrtDate>OutDate)
    ...Quit:(PrtDate<InBedDate)
    ...Set ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate)=""
	.If ((node=9)!(node=11))  Do
	..Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node)=""
	
	Quit
}

/// 7.0 之前滚医嘱模式下取数据
/// d ##class(web.DHCBillCheckBusiData).GetOEORIInfo(58,"48||1")
ClassMethod GetOEORIInfo(EpisodeID, OEORIRowid, ssflag)
{
	Set ArcimRowid=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1),"^",2)
	Set ArcItmCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10) 
	Set OecCatDr=$p(^ARC("IC",ArcItmCatDr),"^",8)
    Set ItmStatDr=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1),"^",13)
	Set StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
	; 获取医嘱的计费数量 PBOQtySum
	Set PBRowid=0,PBOQtySum=0
	For  Set PBRowid=$o(^DHCPBi(0,"OEORI",OEORIRowid,PBRowid))  Quit:(PBRowid="")  Do  
	.Set PBODr="0"
	.For  Set PBODr=$o(^DHCPBi(0,"OEORI",OEORIRowid,PBRowid,PBODr))  Quit:(PBODr="")  Do
	..Set PBOQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",5)
	..Set PBORefQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",6)
	..Set PBOQtySum=PBOQtySum+PBOQty+PBORefQty
	; 获取医嘱的实际发药数量 DspNum
	Set DspRowid="0",DspNum=0
	For  Set DspRowid=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowid,DspRowid))  Quit:(DspRowid="")  Do
	.Set DSPStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	.Set DSPQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
	.If DSPStatus="C"  Do
	..Set DspNum=DspNum+DSPQty
	.If DSPStatus="R"  Do
	..Set DspNum=DspNum-DSPQty
	; end
	Set node=""
	For  Set node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  Quit:(node="")  Do
	.Set espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.Set useflag=$p(espression,"^",4)
	.Quit:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  ;这些规则 不允许被停用
	.Set qflag="0"
	.If $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  Do
	..Set qflag="1"
	.If $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItmCatDr))'=0  Do
	..Set qflag="1"
	.If $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  Do
	..Set qflag="1"	
	.If ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  Do
	..Set ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,StDate)=""  
	.;If (node=13)&(OEORENum=0)  Do
	..;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEORENull",OEORIRowid)=""
	.If (node=4)&(StatCode="V")&(PBOQtySum>0)&(qflag="1")  Do 
	..;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEAlreadyPBAndNExec",OEORIRowid)=StatCode_"^"_PBOQtySum_"^"_qflag
	..Set CheckData="OEORI_ItemStat_DR:"_StatCode_", 计费数量:"_PBOQtySum
	..Set Expstr="YCFeeCheck^"_node_"^OEAlreadyPBAndNExec^检验检查已下医嘱已收费但相关医技科室未执行"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_CheckData_"^"_"^"
	..Set rtn=..InsertBusiData(Expstr)
	.If (node=8)&(qflag="1")  Do
	..If (PhOutFlag="N")&(PriorCode="OUT")  Do
	...If PBOQtySum=0  Do
	....; s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEOutDrugNPB",OEORIRowid)=""
	..Else  If LinkFlag="Y"  Do	
	..Else  Do
	...If PBOQtySum'=DspNum  Do
	....;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEDrugErr",OEORIRowid)=PBOQtySum_"^"_DspNum
	....Set CheckData="发药数量:"_DspNum_", 计费数量:"_PBOQtySum
	....Set Expstr="YCFeeCheck^"_node_"^OEDrugErr^计费数量与发药数量不一致"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_CheckData_"^"_"^"
	....Set rtn=..InsertBusiData(Expstr)
	.If (node=10)&(qflag="1")&(PBOQtySum=0)   Do
	..If (StatCode="V")!(StatCode="E")  Do
	...If (OrdType="R")&(+OEORIQty=0)  Do
	....;
	...Else  Do 
	....;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OENPBRowid",OEORIRowid)=""     
	....Set CheckData=""
	....Set Expstr="YCFeeCheck^"_node_"^OENPBRowid^需计费医嘱未停止未计费"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_CheckData_"^"_"^"
	....Set rtn=..InsertBusiData(Expstr)
	.If ((node=9)!(node=11))&(ssflag=1)&(qflag="1")  Do
	..If (StatCode="V")!(StatCode="E")  Do
	...;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE",OEORIRowid)=""
	...Set CheckData=""
	...Set Expstr="YCFeeCheck^"_node_"^OPAlreadyOE^已做手术申请但是没有手术室计费或没有麻醉科计费"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_CheckData_"^"_"^"
	...Set rtn=..InsertBusiData(Expstr)
	.; mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	.Set AllowNegativeNum=0
	.If ($g(AllowNegativeArcim)'="")  Do
	..Set AArcimRowid=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1),"^",2) 
	..If AllowNegativeArcim=AArcimRowid  Do
	...Set AllowNegativeNum=AllowNegativeNum+1 
	.If (node=15)&(PBOQtySum<0)&(AllowNegativeNum=0)  Do
	..;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"PBNegativeNum",OEORIRowid)=""    
	..Set CheckData=""
	..Set Expstr="YCFeeCheck^"_node_"^PBNegativeNum^医嘱账单数量小于0的医嘱"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_CheckData_"^"_"^"
	..Set rtn=..InsertBusiData(Expstr)
	Quit
}

/// 7.0 之后滚执行记录模式下取数据
ClassMethod GetOEOREInfo(EpisodeID, OEOrdDr, OEOriDr, ssflag)
{
	Set OEORIRowid=OEOrdDr_"||"_OEOriDr
	Set ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
	Set ArcItmCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10) 
	Set OecCatDr=$p(^ARC("IC",ArcItmCatDr),"^",8)
    Set ItmStatDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",13)
	Set StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
    Set Prior=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",8) 
    Set PriorCode=""
	If Prior'="" Set PriorCode=$p($g(^OECPR(+Prior)),"^",1)
    Set OrdType=$p(^ARC("IC",ArcItmCatDr),"^",7)
	Set StDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",9)
    Set OEORIQty=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",18)   ;医嘱首日次数，首日次数为0不插入打包表和医嘱执行记录表 
    Set OEORIOEORIDr=""
	Set OEORIOEORIDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,11)),"^",39)
	Set MOrdType="",MOrdQty="",MArcimDr="",MItemCatDr=""
	If OEORIOEORIDr'=""  Do
	.Quit:'$d(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2)))
	.Set MArcimDr=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",2)
	.Set MItemCatDr=$p(^ARCIM(+MArcimDr,$p(MArcimDr,"||",2),1),"^",10) 
	.If MItemCatDr'=""  Do
	..Set MOrdType=$p(^ARC("IC",MItemCatDr),"^",7)
	..Set MOrdQty=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",18)    
	Set inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))
	Set LinkFlag="N"
	If (inci'="")  Do
	.Set LinkFlag=##class(web.UDHCJFBILLIP).GetUserLocLinkRecLoc(OEORIRowid)
	Set Condition=$o(^DHCTarC("BC",0,ArcItmCatDr,""))
	If Condition'="" Set CP=$p(^DHCTarC("BC",Condition),"^",2)
	Else  Set CP=DefaultCP
	
	Set OEOreDr="0",OEORENum=0,NFirstQty=0
    For  Set OEOreDr=$o(^OEORD(OEOrdDr,"I",OEOriDr,"X",OEOreDr))  Quit:(OEOreDr="")  Do
	.Set OEORENum=OEORENum+1 	; 执行记录数量
    .Set OEORERowid=OEOrdDr_"||"_OEOriDr_"||"_OEOreDr     
    .Set OEStatDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,"X",OEOreDr,"BILL"),"^",1)
    .Set OEStatCode=""
    .If OEStatDr'=""  Do 
    ..Set OEStatCode=$p(^OEC("OSTAT",OEStatDr),"^",1)
    .; 获取医嘱的计费数量 PBOQtySum
	.Set PBRowid=0,PBOQtySum=0
	.For  Set PBRowid=$o(^DHCPB(0,"OEEXC",OEORERowid,PBRowid))  Quit:(PBRowid="")  Do  
	..Set PBODr="0"
	..For  Set PBODr=$o(^DHCPB(0,"OEEXC",OEORERowid,PBRowid,PBODr))  Quit:(PBODr="")  Do
	...Quit:($d(^DHCPB(PBRowid,"O",PBODr))=0)
	...Set PBOQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",5)
	...Set PBORefQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",6)
	...Set PBOQtySum=PBOQtySum+PBOQty+PBORefQty	
	.///获取医嘱的实际发药数量 DspNum
	.Set DspRowid="0",DspNum=0
	.For  Set DspRowid=$o(^DHCOEDISQTY(0,"OEORE",OEORERowid,DspRowid))  Quit:(DspRowid="")  Do
	..Set DSPStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	..Set DSPQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
	..If DSPStatus="C"  Do
	...Set DspNum=DspNum+DSPQty
	..If DSPStatus="R"  Do
	...Set DspNum=DspNum-DSPQty
	.;
	.Set node=""
	.For  Set node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  Quit:(node="")  Do
	..Set espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	..Set useflag=$p(espression,"^",4)
	..Quit:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  // 这几个规则不允许被停用。[停用无效]
	..Set qflag="0"
	..If $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  Do
	...Set qflag="1"
	..If $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItmCatDr))'=0  Do
	...Set qflag="1"
	..If $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  Do
	...Set qflag="1"	
	..Set OEOREStDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,"X",OEOreDr),"^",1)	
	..If ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  Do
	...Set ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,OEOREStDate)=""  	;收费天数与住院天数是否一致:存收费天数的global。
	..If (node=4)&(StatCode="V")&(PBOQtySum>0)&(qflag="1")  Do 
	...;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEAlreadyPBAndNExec",OEORERowid)=StatCode_"^"_PBOQtySum_"^"_qflag
	...Set CheckData="OEORI_ItemStat_DR:"_StatCode_", 计费数量:"_PBOQtySum
	...Set Expstr="YCFeeCheck^"_node_"^OEAlreadyPBAndNExec^检验检查已下医嘱已收费但相关医技科室未执行"_"^"_EpisodeID_"^"_OEORIRowid_"^"_OEORERowid_"^"_""_"^"_CheckData_"^"_"^"
	...Set rtn=..InsertBusiData(Expstr)
	..If (node=8)&(qflag="1")  Do
	...If (PhOutFlag="N")&(PriorCode="OUT")  Do
	....Set CP="OD"
	...If LinkFlag="Y"  Do
	....Set CP="OD"	
	...If ((CP="CR")&(OrdType="R")) Do
	....If PBOQtySum'=DspNum  Do
	.....;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEDrugErr",OEORERowid)=PBOQtySum_"^"_DspNum
	.....Set CheckData="发药数量:"_DspNum_", 计费数量:"_PBOQtySum
	.....Set Expstr="YCFeeCheck^"_node_"^OEAlreadyPBAndNExec^检验检查已下医嘱已收费但相关医技科室未执行"_"^"_EpisodeID_"^"_OEORIRowid_"^"_OEORERowid_"^"_""_"^"_CheckData_"^"_"^"
	.....Set rtn=..InsertBusiData(Expstr)
	..If (node=10)&(qflag="1")&(PBOQtySum=0)   Do
	...If (OEStatCode="V")!(OEStatCode="E")  Do
	....If (OrdType="R")&(OEORIQty=0)  Do
	.....
	....Else  d 
	.....;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OENPBRowid",OEORERowid)=""  ;需计费医嘱未停止未计费
	.....Set CheckData=""
	.....Set Expstr="YCFeeCheck^"_node_"^OENPBRowid^需计费医嘱未停止未计费"_"^"_EpisodeID_"^"_OEORIRowid_"^"_OEORERowid_"^"_""_"^"_CheckData_"^"_"^"
	.....Set rtn=..InsertBusiData(Expstr)
	..If ((node=9)!(node=11))&(ssflag=1)&(qflag="1")  Do
	...If (OEStatCode="V")!(OEStatCode="E")  Do
	....;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE",OEORERowid)=""
	....Set CheckData=""
	....Set Expstr="YCFeeCheck^"_node_"^OPAlreadyOE^已做手术申请但是没有手术室计费或没有麻醉科计费"_"^"_EpisodeID_"^"_OEORIRowid_"^"_OEORERowid_"^"_""_"^"_CheckData_"^"_"^"
	....Set rtn=..InsertBusiData(Expstr)
	..; mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	..Set AllowNegativeNum=0
	..If ($g(AllowNegativeArcim)'="")  Do
	...Set AArcimRowid=$p(^OEORD(+OEORERowid,"I",$p(OEORERowid,"||",2),1),"^",2) 
	...If AllowNegativeArcim=AArcimRowid  Do
	....Set AllowNegativeNum=AllowNegativeNum+1
	..If (node=15)&(PBOQtySum<0)&(AllowNegativeNum=0)  Do
	...;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"PBNegativeNum",OEORERowid)="" 
	...Set CheckData=""
	...Set Expstr="YCFeeCheck^"_node_"^PBNegativeNum^医嘱账单数量小于0的医嘱"_"^"_EpisodeID_"^"_OEORIRowid_"^"_OEORERowid_"^"_""_"^"_CheckData_"^"_"^"
	...Set rtn=..InsertBusiData(Expstr)
	..; 2015-06-30 长期医嘱首日执行次数为 0 时 首日可以没有执行记录,子医嘱的首日执行次数根据主医嘱的取值
	..; i (OrdType="R")&(OEOREStDate'=StDate)&(OEORENum=1)&(+OEORIQty'=0)  d
	..If (PriorCode="S")!(PriorCode="OMST")  Do
	...If (OEOREStDate'=StDate)&(OEORENum=1)&(+OEORIQty'=0)&(OEORIOEORIDr="")  Do
	....; OEORIOEORIDr:关联医嘱。没有关联医嘱,首日执行次数不为0 实际执行时间[OEOREStDate]和要求执行时间[StDate]不一致
	....Set NFirstQty=NFirstQty+1 
	...If (OEOREStDate'=StDate)&(OEORENum=1)&(+MOrdQty'=0)&(OEORIOEORIDr'="")  Do
	....;有关联医嘱,首日执行次数不为0 实际执行时间[OEOREStDate]和要求执行时间[StDate]不一致
	....Set NFirstQty=NFirstQty+1	
	..Else  Do
	...;非长期医嘱。要求执行时间和实际执行时间不一致。
	...If (OEOREStDate'=StDate)&(OEORENum=1)  Do
	....Set NFirstQty=NFirstQty+1 
	If (NFirstQty'=0)  Do
	.;这里没有执行记录的医嘱在 CheckOrdAllowNExec 方法中已经处理,可以注释掉。LookUpAbnormalFee 方法中
	.;s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,13,"OEORENull",OEORIRowid)=""
	;2015-06-10 chenxi 判断一直是执行记录时，判断该医嘱是否为子医嘱，
	;如果为子医嘱则判断主医嘱的执行记录是否停止,如果停止则该医嘱可以没有执行记录
	Set NExecFlag="Y"
	Set NExecFlag=##class(web.DHCIPBillCheckAdmFee).CheckOrdAllowNExec(OEORIRowid)
	If NExecFlag'="Y"  Do
	.;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,13,"OEORENull",OEORIRowid)="" 
	.Set CheckData=""
	.Set Expstr="YCFeeCheck^"_13_"^OEORENull^医嘱没有执行记录"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_CheckData_"^"_"^"
	.Set rtn=..InsertBusiData(Expstr)
	Quit
}

ClassMethod GetNullData(EpisodeID, OEOrdDr, OEOriDr)
{
	Set NullNum=0
	Set ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
	Set OEORIRowid=OEOrdDr_"||"_OEOriDr
	Set node=14
	If ArcimRowid="" Do
	.Set NullNum=1
	.;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"ArcimRowidNull",OEORIRowid)=""	
	.Set Expstr="YCFeeCheck^"_node_"^ArcimRowidNull^医嘱对应的医嘱项为空"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_""_"^"
	.Set rtn=..InsertBusiData(Expstr)
	Else  Do
	.Set ArcItmCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10) 
	.If ArcItmCatDr=""  Do
	..Set NullNum=1
	..;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"ItemCatNull",OEORIRowid)=""	
	..Set Expstr="YCFeeCheck^"_node_"^ItemCatNull^医嘱对应的医嘱项医嘱子类为空"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_""_"^"
	..Set rtn=..InsertBusiData(Expstr)
	.Else  Do
	..Set OecCatDr=$p(^ARC("IC",ArcItmCatDr),"^",8)
	..If OecCatDr=""  Do
	...Set NullNum=1
	...;Set ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OECCatNull",OEORIRowid)=""
	...Set Expstr="YCFeeCheck^"_node_"^OECCatNull^医嘱对应的医嘱项医嘱大类为空"_"^"_EpisodeID_"^"_OEORIRowid_"^"_""_"^"_""_"^"_""_"^"
	...Set rtn=..InsertBusiData(Expstr)
	Quit NullNum
}

ClassMethod CheckDateFee(EpisodeID)
{
	//再处理费床位费、诊查费、护理费等类医嘱(需按天计算)  ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate)
	Set node=""
	For  Set node=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node))  Quit:(node="")  Do
	.Quit:(AbnormalDr'="0")&(AbnormalDr'=node)
	.Set CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.Set Message=$p(CAbFeeConfig,"^",3)
	.Set PrtDate=""
	.Set PrtNum=0
	.For  Set PrtDate=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate))  Quit:(PrtDate="")  Do
	..If $d(^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,PrtDate))=0  Do
	...;Set ^TMP("DHCIPBill","YCFeeCheckNDate",EpisodeID,$j,node,PrtDate)=""
	...Set Expstr="YCFeeCheck^"_node_"^YCFeeCheckNDate^"_Message_"^"_EpisodeID_"^"_""_"^"_""_"^"_""_"^"_""_"^"
	...Set rtn=..InsertBusiData(Expstr)
	Do
}

/// 检查账户余额数据,如果有shadow库，一定在shadow上执行
/// 如果没有shadow库，可以先在测试库执行预估执行时间后选择合适时间在正式库执行，一定在晚上人少的时候检查执行此函数
/// 这个函数主要是检查已经上了卡消费的项目的账户情况
/// 自动任务检查前一天发生变化的账户
/// w ##class(web.DHCBillCheckBusiData).CheckAccMData()
ClassMethod CheckAccMData(Date)
{
	New (Date)
	Set OutInfo="", AccBalStr=""
	Set accm=0, BalSum=0, DepositAll=0, PayAll=0
	For  Set accm=$o(^DHCACD("AccM",accm))  Quit:(accm="")   Do
	.Set accMInfo=$g(^DHCACD("AccM",accm))
	.Quit:(accMInfo="")
	.Set Accbal=$p(accMInfo,"^",8)
	.If (Accbal<0)  Set AccBalStr=AccBalStr_"^"_accm_":"_Accbal
	.; 检查前一天有变化的账户
	.Quit:(('$d(^DHCACDi("AccM",0,"PayDate",Date)))&&('$d(^DHCACDi("AccM",0,"APDDate",Date))))
	.Set DepositAll=0, PayAll=0
	.Set mySub=0,PDSum=0,PaySum=0,AfAdd=0,AfPay=0
	.For  Set mySub=$o(^DHCACD("AccM",accm,"AccPD",mySub))   Quit:(mySub="")   Do
	..Set myAccPDInfo=$g(^DHCACD("AccM",accm,"AccPD",mySub))
	..Quit:(myAccPDInfo="")
	..Set myPreSum=$p(myAccPDInfo,"^",2)
	..Set PDSum=PDSum+myPreSum
	..Set pdate=$p(myAccPDInfo,"^",3)
	..Set DepositAll=myPreSum+DepositAll
	.Set mySub=0
	.For  Set mySub=$o(^DHCACD("AccM",accm,"AccPL",mySub))   Quit:(mySub="")   Do
	..Set myAccPLInfo=$g(^DHCACD("AccM",accm,"AccPL",mySub))
	..Quit:(myAccPLInfo="")
	..Set myPaySum=$p(myAccPLInfo,"^",8)
	..Set PayAll=PayAll+myPaySum
	..Set pdate=$p(myAccPLInfo,"^",6)
	.Set BalSum=+DepositAll-(+PayAll)
	.If (+Accbal'=+BalSum) Do
	..Set CheckData="当前账户余额:"_Accbal_", 计算账户余额:"_BalSum_", 交预交金总额:"_DepositAll_", 消费总额:"_PayAll
	..Set Expstr="OPAccMCheck^AccMErr^AccMErr^账户金额错误"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_CheckData_"^"_accm_"^"
	..Set rtn=..InsertBusiData(Expstr)

	Quit
}

ClassMethod CheckOPInsuPrtData(Date)
{
	Set job=$i(^DHCBillInsuCheck("InvInsuErr"))
	
	Set insuInfo=##class(web.INSUCollating).GetDivDrbyDate(Date, Date)
	Set insuTMPID=""
    Set invdr=""
    For  Set invdr=$o(^DHCINVPRT(0,"Date",Date,invdr))   Quit:invdr=""   Do
    .Set insdr=$p(^DHCINVPRT(invdr),"^",30)
    .Set flag=$p(^DHCINVPRT(invdr),"^",8)
    .Set initinv=$p(^DHCINVPRT(invdr),"^",13)
    .Set instype=$p(^DHCINVPRT(invdr),"^",9)
    .Set hisamt=$p(^DHCINVPRT(invdr),"^",1)
	.Set hisinsu=$p(^DHCINVPRT(invdr),"^",31)
    .If (insdr="")&(initinv'="") Do
    ..Set insdr=$p(^DHCINVPRT(initinv),"^",30)
    ..Set hisamt=$p(^DHCINVPRT(initinv),"^",1)
    ..Set hisinsu=$p(^DHCINVPRT(initinv),"^",31)
    .Quit:+insdr=0
    .If (flag'="N")&(insdr'="")   Do
    ..Set lastinv=$o(^DHCINVPRT(0,"INSDIV",insdr,""),-1)
    ..Quit:+lastinv=(+invdr)
    ..Set fairtype=$p(^DHCINVPRT(lastinv),"^",34)
    ..Quit:fairtype="R"
    ..Set flag=$p(^DHCINVPRT(lastinv),"^",8)
    ..Set hisamt=$p(^DHCINVPRT(lastinv),"^",1)
	..Set hisinsu=$p(^DHCINVPRT(lastinv),"^",31)
    .If flag="N"   s insflag="+"
    .Else  Set insflag="-"
    .Quit:+insdr=0
    .Set fairtype=$p(^DHCINVPRT(invdr),"^",34)
    .Quit:fairtype="R"
    .Set insuerr=##class(web.DHCINSUPort).GetDivInfobyDivDr(insdr,insflag,hisamt_"^"_hisinsu)
	.If +insuerr'=1 Do
	..;Set ^DHCBillInsuCheck("InvInsuErr",job,"Inv",invdr)=insuerr_"@@"_flag
	..Set errnote=$p(insuerr,"^",1)
	..Set insamt=$p(insuerr,"^",2)
	..Set inspay=$p(insuerr,"^",3)
	..Set CheckData="HIS金额"_hisamt_", HIS医保支付:"_hisinsu
	..Set CheckData=CheckData_", 医保错误:"_errnote_", 医保金额:"_insamt_", 医保支付:"_inspay
	..Set Expstr="OPInsuPrtCheck^InsuPrtErr^PRTInsuPrtErr^医保发票数据错误"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_CheckData_"^"_""_"^PRT:"_invdr
	..Set rtn=..InsertBusiData(Expstr)
	
    Set api=""
    For  Set api=$o(^DHCINVPRTAPi(0,"Date",Date,api))   Quit:api=""  Do
    .Set insdr=$p(^DHCINVPRTAP(api),"^",19)
    .Set flag=$p(^DHCINVPRTAP(api),"^",2)
    .Set initinv=$p(^DHCINVPRTAP(api),"^",10)
    .Set hisamt=$p(^DHCINVPRTAP(api),"^",1)
	.Set hisinsu=$p(^DHCINVPRTAP(api),"^",17)
    .If (insdr="")&(initinv'="") Do
    ..Set insdr=$p(^DHCINVPRTAP(initinv),"^",19)
    ..Set hisamt=$p(^DHCINVPRTAP(initinv),"^",1)
    ..Set hisinsu=$p(^DHCINVPRTAP(initinv),"^",17)
    .Quit:+insdr=0
    .If (flag'="N")&(insdr'="")   Do
    ..Set lastinv=$o(^DHCINVPRTAPi(0,"InsDR",insdr,""),-1)
    ..Quit:+lastinv=(+invdr)
    ..Set flag=$p(^DHCINVPRTAP(lastinv),"^",2)
    ..Set hisamt=$p(^DHCINVPRTAP(lastinv),"^",1)
	..Set hisinsu=$p(^DHCINVPRTAP(lastinv),"^",17)
    .If flag="N"   s insflag="+"
    .Else  Set insflag="-"
    .Set insuerr=##class(web.DHCINSUPort).GetDivInfobyDivDr(insdr,insflag,hisamt_"^"_hisinsu)
	.If +insuerr'=1 Do
	..;Set ^DHCBillInsuCheck("InvInsuErr",job,"API",api)=insuerr_"@@"_flag
	..Set errnote=$p(insuerr,"^",1)
	..Set insamt=$p(insuerr,"^",2)
	..Set inspay=$p(insuerr,"^",3)
	..Set CheckData="HIS金额"_hisamt_", HIS医保支付:"_hisinsu
	..Set CheckData=CheckData_", 医保错误:"_errnote_", 医保金额:"_insamt_", 医保支付:"_inspay
	..Set Expstr="OPInsuPrtCheck^InsuPrtErr^APIInsuPrtErr^医保发票数据错误"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_CheckData_"^"_""_"^API:"_api
	..Set rtn=..InsertBusiData(Expstr)
		
	;体检
    Set peinvdr=""
    For  Set peinvdr=$o(^DHCPEINVPRT(0,"DATE",Date,peinvdr))   Quit:peinvdr=""   Do
    .Set flag=$p(^DHCPEINVPRT(peinvdr),"^",8)
    .Set realinv=peinvdr
    .If flag'="N" s realinv=$p(^DHCPEINVPRT(peinvdr),"^",9)
    .Set hisamt=$p(^DHCPEINVPRT(realinv),"^",7)
    .Set insdr=$p(^DHCPEOEITEM(realinv),"^",4)
	.Set hisinsu=$p(^DHCPEOEITEM(realinv),"^",5)
    .If flag="N"   s insflag="+"
    .Else  Set insflag="-"
    .Quit:+insdr=0
    .Set insuerr=##class(web.DHCINSUPort).GetDivInfobyDivDr(insdr,insflag,hisamt_"^"_hisinsu)
	.If +insuerr'=1 Do
	..;Set ^DHCBillInsuCheck("InvInsuErr",job,"PEInv",realinv)=insuerr_"@@"_flag
	..Set errnote=$p(insuerr,"^",1)
	..Set insamt=$p(insuerr,"^",2)
	..Set inspay=$p(insuerr,"^",3)
	..Set CheckData="HIS金额"_hisamt_", HIS医保支付:"_hisinsu
	..Set CheckData=CheckData_", 医保错误:"_errnote_", 医保金额:"_insamt_", 医保支付:"_inspay
	..Set Expstr="OPInsuPrtCheck^InsuPrtErr^PEInsuPrtErr^医保发票数据错误"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_CheckData_"^"_""_"^PE:"_peinvdr
	..Set rtn=..InsertBusiData(Expstr)
		
	Quit
}

ClassMethod CheckUnhandinData()
{
	Set PrtRowid=""
	;Set PrtRowid=$o(^DHCINVPRT(0,"HandIn","N",User))
	
	Set grp="O",type=3
	Set rowid=""
    Set rowid=$o(^DHCJFRcptGroupSet(0,"Type",grp,type,""))
    If rowid'="" d
    .Set sub=0
    .For  Set sub=$o(^DHCJFRcptGroupSet(rowid,"Sub",sub)) Quit:sub=""  Do
    ..Set usrrowid=$p(^DHCJFRcptGroupSet(rowid,"Sub",sub),"^",4)
    ..Quit:'$d(^SSU("SSUSR",usrrowid))
    ..Quit:'$d(^DHCINVPRT(0,"HandIn","N",usrrowid))
    ..Quit:'$d(^DHCOPInsFootI(0,"User",usrrowid))
	..Set PrtRowid=$o(^DHCINVPRT(0,"HandIn","N",usrrowid,0))
	..Set PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	..Set PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	..Set HisRowid=$o(^DHCOPInsFootI(0,"User",usrrowid,""),-1)
	..Set HisDate=$p(^DHCOPInsFoot(HisRowid),"^",2)
	..Set HisTime=$p(^DHCOPInsFoot(HisRowid),"^",7)
	..Set usrinials=$p(^SSU("SSUSR",usrrowid),"^",1)
	..Set ustname=$p(^SSU("SSUSR",usrrowid),"^",2)
	..If ((PrtDate<HisDate)!((PrtDate=HisDate)&(PrtTime<HisTime))) Do
	...Set CheckData="收费员:"_ustname_"("_usrinials_")"_" 最早未结算日期:"_$zd(PrtDate,3)_" "_$zt(PrtTime,1)
	...Set Expstr="OPUnhandPrtCheck^UnhandPrtErr^UnhandPrtErr^有最后一次结算之前未结算的发票数据"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_CheckData_"^"_""_"^PRT:"_PrtRowid
	...Set rtn=..InsertBusiData(Expstr)
	Quit
}

}
