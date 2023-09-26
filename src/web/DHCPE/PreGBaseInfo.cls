Import SQLUser

Class web.DHCPE.PreGBaseInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 87;

Query SearchGList(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "PGBI_Desc:%String,PGBI_Code:%String,PGBI_RowId:%String")
{
SELECT PGBI_Desc,PGBI_Code,PGBI_RowId 
FROM DHC_PE_PreGBaseInfo
where PGBI_Desc %STARTSWITH :Desc
order by PGBI_RowId desc
}

Query SearchGListByDesc(GBIDesc As %String = "") As %Query(ROWSPEC = "GBI_Desc:%String:名称,GBI_Code:%String:编码,GBI_RowId:%String:ID")
{
}

ClassMethod SearchGListByDescExecute(ByRef qHandle As %Binary, GBIDesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s:GBIDesc'="" GBIDesc=$ZCVT(GBIDesc,"U")
 	s id=""
 	f  s id=$o(^DHCPEPreGBI(id),-1)  q:(id="")||(id=0)  d
	.s GDesc=$p($g(^DHCPEPreGBI(id)),"^",2)
	.s GCode=$p($g(^DHCPEPreGBI(id)),"^",1)
	.s TNamePY=##class(web.DHCINSUPort).GetCNCODE(GDesc,4,"")
	.q:((""'=GBIDesc)&('(($ZCVT(GDesc,"U")[GBIDesc)||(TNamePY[GBIDesc))))	
    .d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	s GDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",GDesc,"PGBIDesc","cls")
	//set Data=$lb(GDesc_TNamePY,GCode,$g(id))
	set Data=$lb(GDesc,GCode,$g(id))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGListByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGListByDescExecute ]
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

ClassMethod SearchGListByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGListByDescExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCPE.PreGBaseInfo).UpDateWrongTel()
ClassMethod UpDateWrongTel()
{
	s IBIID=0 
	f  s IBIID=$o(^DHCPEPreIBI(IBIID)) q:((IBIID="")||(IBIID>57566))  d
	.
	.
	.q:(+($p(^DHCPEPreIBI(IBIID),"^",6))'=0) 
	.q:(+($p(^DHCPEPreIBI(IBIID),"^",8))'=0) 
	.s $p(^DHCPEPreIBI(IBIID),"^",6)=""
	.s $p(^DHCPEPreIBI(IBIID),"^",8)=""
	.s ^DHCPE("DHCPE","WrongTel",IBIID)=IBIID
	
	
	q ""
}

/// d ##class(web.DHCPE.PreGBaseInfo).GBaseTest()
ClassMethod GBaseTest()
{
	s Num=1
	s GName=""
	s GPerson=""
	s GPerTel="",GNO=0
	f  s GNO=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO))  q:(GNO="")  d
	.;s HPNO=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO,0))
	.s CurData=$g(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO))
	.;w !,CurData
	.
	.s GName=$P($g(CurData),"^",2)
	.q:((GName="")||(GName="vip")||(GName="VIP")||(GName="个人"))
	.s GPerson=$P($g(CurData),"^",3)
	.s GPerTel=$P($g(CurData),"^",4)
	.w:((GPerson'="")) GName_"::"_GPerson_"  "_GPerTel
	.s:((GPerson'="")) Num=Num+1
	w !,Num
	
	q ""
}

/// 协和以前数据导入（建团）
/// w ##class(web.DHCPE.PreGBaseInfo).InsertGBaseXH()
ClassMethod InsertGBaseXH()
{
	s GName=""
	s GPerson=""
	s GPerTel="",GNO=0
	f  s GNO=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO))  q:(GNO="")  d
	.
	.s CurData=$g(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO))
	.
	.s GName=$P($g(CurData),"^",2)
	.q:((GName="")||(GName="vip")||(GName="VIP")||(GName="个人"))
	.s GPerson=$P($g(CurData),"^",3)
	.s GPerTel=$P($g(CurData),"^",4)
	.s:GPerson="" GPerson=1
	.s:GPerTel="" GPerTel=1
	.s Flag=0
	.s Flag=..Save("","","^^"_GName_"^^^"_GPerson_"^^^"_GPerTel)
	.s:(($p(Flag,"^",1))'=0) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRGBase","GInfo",GNO)=CurData
	.//新建合同
	.s HTFlag=0
	.s HTFlag=##class(web.DHCPE.Contract).Update("",GNO_"^"_$P($g(CurData),"^",6)_"^"_$zd($h,4)_"^"_""_"^"_"5918"_"^"_"572")
	.s:(($p(HTFlag,"^",1))=-1) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRGContract","GInfo",GNO)=CurData
	.s:(($p(HTFlag,"^",1))'=-1) $P(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO),"^",7)=HTFlag
	q "完成"
}

/// 团体预约信息 和分组
/// w ##class(web.DHCPE.PreGBaseInfo).InsertGADMXH()
ClassMethod InsertGADMXH()
{
	s $ZT="InsertGADMXHErr"
	s GName=""
	s GPerson=""
	s GPerTel="",GNO=0
	f  s GNO=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO))  q:(GNO="")  d
	.s CurData=$g(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO))
	.s GName=$P($g(CurData),"^",2)
	.q:GName=""
	.q:GName="个人"
	.q:((GName="VIP")||(GName="vip"))
	.s GDR=""
	.s GDR=$o(^DHCPEPreGBI(0,"Desc",GName,0))
	.s CurDate=$zd($h,4)                    //s:'$d(%session) DepLoc=572
	.s GReturnInfo=##class(web.DHCPE.PreGADM).Save2("","","^"_GDR_"^"_CurDate_"^"_CurDate_"^^^^Y^N^N^^N^N^^AC^IS^GD^^^^^^^^^1^@@@@^6^"_$P($g(CurData),"^",7))
	.s:(($p(GReturnInfo,"^",1))'=0) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRGADM","GInfo",GNO)=CurData
	.s GADM=$p(GReturnInfo,"^",2)
	.s $P(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNO),"^",5)=GADM
	.s TReturnInfo=##Class(web.DHCPE.PreGTeam).Save2("","",GADM_"^^^旧系统存留未检^"_CurDate_"^"_CurDate_"^10:06^^N^N^^N^N^^N^^^N^1^^6^")

	q "完成"
InsertGADMXHErr
	q $ZERROR
}

/// / d ##class(web.DHCPE.PreGBaseInfo).Test22()
ClassMethod Test22()
{
	s ID=$O(^DHCPEPreIADM(""),-1)
	h 1
	s ID2=$O(^DHCPEPreIADM(""),-1)
	w ID2-ID,!
}

/// d ##class(web.DHCPE.PreGBaseInfo).ClearImpGlobal()
ClassMethod ClearImpGlobal()
{
	k ^DHCPEHCRelate("DHCPE")
	k ^DHCPEOldXHData("DHCPEImpOldDataXH")
}

/// /协和老数据导入 个人信息导入
/// w ##class(web.DHCPE.PreGBaseInfo).insertIInfo()
/// 10.29测试9450条预约数据3分钟
ClassMethod insertIInfo()
{
	s HPNO=0,IBIFlag=""
	f  s HPNO=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","IBaseInfo",HPNO))  q:(HPNO="")  d
	.s Curdata=$g(^DHCPEOldXHData("DHCPEImpOldDataXH","IBaseInfo",HPNO))
	.s GNo=""
	.s GNo=$p(Curdata,"^",2)
	.s GInfo=""
	.s:GNo'="" GInfo=$g(^DHCPEOldXHData("DHCPEImpOldDataXH","GInfo",GNo))
	.s GADM=""
	.s GADM=$p(GInfo,"^",5)
	.s GADMDESC=$p(Curdata,"^",3)
	.s TeamID=""
	.s TeamID=GADM_"||1"
	.
	.s Name=$p(Curdata,"^",6)
	.s Sex=$p(Curdata,"^",7)
	.i Sex="男" d
	..s Sex=2
	.e  d
	..s Sex=1
	.s bith=$p(Curdata,"^",8)
	.s:((Name="")||(Sex="")||(bith="")) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRIBASE","IBaseInfo1",HPNO)=Curdata
	.q:((Name="")||(Sex="")||(bith=""))
	.
	.s tel=$p(Curdata,"^",9)
	.i tel["*" s tel=$p(tel,"*",2)
	.s merrage=$p(Curdata,"^",11)
	.i merrage="已婚" s marrid=1
	.e  i merrage="未婚" s marrid=2
	.e  s marrid=""
	.s bumen=$p(Curdata,"^",13)
	.s IFGADM=1,IFVIP=0
	.s:((GADMDESC="个人")||(GADMDESC="VIP")||(GADMDESC="vip")||(GADMDESC="")) IFGADM=0
	.s VIPDR=1,IFTexu=6
	.s Date=$zd($h,4)
	.s shenfenzheng=$p(Curdata,"^",10)
	.s ZhiWu=$p(Curdata,"^",14)
	.s bith=$p(bith," ",1)
	.q:bith=""
	.s bith1=$p(bith,"/",1)
	.s $p(bith,"/",1)=$p(bith,"/",3)
	.s $p(bith,"/",3)=bith1
	.;s bith=$tr(bith,"-","/")
	.s HRowId=""
	.s HRowId=$o(^DHCPEPreIBI(0,"PAPMINo",HPNO,HRowId))
	.s:(HRowId="") String="^"_HPNO_"^"_Name_"^"_Sex_"^"_bith_"^1^"_tel_"^^"_tel_"^"_shenfenzheng_"^^"_bumen_"^^^^^^"_marrid_"^^^5918^^^^^"_VIPDR_"^;NoGen"
	.s:(HRowId'="") String=HRowId_"^"_HPNO_"^"_Name_"^"_Sex_"^"_bith_"^1^"_tel_"^^"_tel_"^"_shenfenzheng_"^^"_bumen_"^^^^^^"_marrid_"^^^5918^^^^^"_VIPDR_"^;NoGen"
	.s IBIFlag=##class(web.DHCPE.PreIBIUpdate).Save("","",String)
	.s PAPMINO=$p(IBIFlag,"^",3)
	.s IBaseInfoID=$p(IBIFlag,"^",2)
	.s BaseFlag=$p(IBIFlag,"^",1)
	.s:(BaseFlag'=0) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRIBASE","IBaseInfo2",HPNO)=Curdata_IBIFlag
	.s PreGIADMFlag=""
	.s PreGIADMFlag=""
	.i (IFGADM=1)  d 
	..s PreGIADMFlag=##class(web.DHCPE.PreIADM).InsertIADMInGTeam(IBaseInfoID,GADM,TeamID,ZhiWu)
	..S IFseccess=""
	..s IFseccess=$p(PreGIADMFlag,"^",1)
	..s:(IFseccess'=0) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRADM","IBaseInfo",HPNO)=Curdata_PreGIADMFlag
	.
	.i (IFGADM=0)  d
	..s PreGIADMFlag=##Class(web.DHCPE.PreIADM).Save("","","^"_IBaseInfoID_"^^^"_Date_"^"_Date_"^^^PREREG^Y^N^N^^N^N^^DC^ID^"_VIPDR_"^^^^^^^"_ZhiWu_"^^0^0^^1^^"_bumen_"^"_IFTexu)
	..S IFseccess=""
	..s IFseccess=$p(PreGIADMFlag,"^",1)
	.s:(IFseccess'=0) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRADM","IBaseInfo",HPNO)=Curdata_PreGIADMFlag
	.s CrmAdm=""
	.s:(IFseccess=0) CrmAdm=$p(PreGIADMFlag,"^",2)
	.
	.s fla=0
	.f  s fla=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","ITemInfo",HPNO,fla)) q:(fla="")  d
	..s ItemNo="",ifhaditem=0
	..f  s ItemNo=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","ITemInfo",HPNO,fla,ItemNo)) q:((ItemNo="")||(IFseccess'=0))  d
	...s CurItemdata=$g(^DHCPEOldXHData("DHCPEImpOldDataXH","ITemInfo",HPNO,fla,ItemNo))
	...s IFSet=$p(CurItemdata,"^",3)
	...s ITEMSETID="",ITEMID="",ItemInfo=""
	...s ItemInfo=..GetItemIDByHC(ItemNo,IFSet)
	...s:(ItemInfo="") ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRRelate","ITemInfo",HPNO,fla,ItemNo)=CurItemdata
	...s ITEMSETID=$p(ItemInfo,"^",1)
	...s ITEMID=$p(ItemInfo,"^",2)
	...s AddItemFlag=""
	...i IFSet=2  d
	....s ITEMID=0
	....f  s ITEMID=$o(^DHCPEHCRelate("DHCPE","2",ItemNo,ITEMID)) q:(ITEMID="")  d
	.....s iid1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ITEMID),0))
	.....s iid2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ITEMID),iid1,0))
	.....
	.....s iids=iid1_"||"_iid2
	.....s AddItemFlag=##Class(web.DHCPE.PreItemList).IInsertItem(CrmAdm,"PERSON","PRE",iids,"",5918)
	.....s:(AddItemFlag'="") ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRITEM","ITemInfo",HPNO,fla,iids)=CurItemdata_AddItemFlag
	...//插入套餐
	...s:(IFSet=1) AddItemFlag=##Class(web.DHCPE.PreItemList).IInsertItem(CrmAdm,"PERSON","PRE","",ITEMSETID,5918)
	...s:(AddItemFlag'="") ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRITEM","ITemInfo",HPNO,fla,ItemNo)=CurItemdata_AddItemFlag
	...;s:(AddItemFlag="") ifhaditem=1  作用是没预约成功的就不做登记了
	..;s BRegFlag=""
	..;i ((ifhaditem=1)&&(IFGADM=0))  d
	...;s BRegFlag=##Class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(CrmAdm,2)
	...;s:(BRegFlag'=0) ^DHCPEOldXHData("DHCPEImpOldDataXH","ERRRegst","IBaseInfo",HPNO)=BRegFlag_"^"_Curdata
	
	q "完成"
}

/// /d ##class(web.DHCPE.PreGBaseInfo).TestVIP()
/// //VIP 测试是否有空
ClassMethod TestVIP()
{
	s RegNo=0
	
	f  s RegNo=$o(^DHCPECBVIPLevel("PIBI",RegNo)) q:(RegNo="")  d
	.w:($g(^DHCPECBVIPLevel("PIBI",RegNo))="") !,RegNo
	q "1"
}

/// 整理为对应的数据
/// /d ##class(web.DHCPE.PreGBaseInfo).OutRepickItem()
ClassMethod OutRepickItem()
{
	s ItemName=0,Type=0,Code=0
	f  s ItemName=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","ERR","ITemInfo",ItemName)) q:(ItemName="")  d
	.s Type=0
	.f  s Type=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","ERR","ITemInfo",ItemName,Type)) q:(Type="")  d
	..s Code=0
	..f  s Code=$o(^DHCPEOldXHData("DHCPEImpOldDataXH","ERR","ITemInfo",ItemName,Type,Code)) q:(Code="")  d
	...s Name=$p($g(^DHCPEOldXHData("DHCPEImpOldDataXH","ERR","ITemInfo",ItemName,Type,Code)),"^",2)
	...s ^DHCPERepickItem(Type,Code)=Code_"^"_Name
	.
	;w !,"end"
	q ""
	;^DHCPEOldXHData("DHCPEImpOldDataXH","ERR","ITemInfo","099990003",1,15)
}

/// / 导入时锁住了审核表（(web.DHCPE.PreIADM).UpdateGroupAuditAmount），直接返回个0，s导入完成后执行这个方法 
/// d ##class(web.DHCPE.PreGBaseInfo).GADMFEE()
ClassMethod GADMFEE()
{
	s DHCPEPreGADM=1528
	f  s DHCPEPreGADM=$o(^DHCPEPreGADM(DHCPEPreGADM)) q:DHCPEPreGADM=""  d
	.w !,DHCPEPreGADM
	.d ##Class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(DHCPEPreGADM)
	q "OVER"
}

ClassMethod Test(IDBeg, IDEnd)
{
	;d ##class(web.DHCPE.PreGBaseInfo).Test("104037","105127")
	
	;s ^sxt("v")=IDBeg_"^"_IDEnd
	s CurPreIADMID=IDBeg-1
	f  s CurPreIADMID=$O(^DHCPEPreIADM(CurPreIADMID)) q:((CurPreIADMID="")||(CurPreIADMID>IDEnd))  d
	.s Status=""
	.
	.s Status=$p($g(^DHCPEPreIADM(CurPreIADMID)),"^",8)
	.q:((Status'="PREREG")&&(Status'="PREREGED"))
	.s Team=$p($g(^DHCPEPreIADM(CurPreIADMID)),"^",3)
	.q:Team'="1554||1"
	.;s ^sxt(CurPreIADMID)=CurPreIADMID
	.s ret=##Class(web.DHCPE.DHCPEIAdm).UpdateIADMInfo(CurPreIADMID,2)
	.;s ^sxt(CurPreIADMID,"33")=ret
	q "Over"
}

/// /  
/// 根据杭创医嘱id获得health医嘱id
/// w ##class(web.DHCPE.PreGBaseInfo).GetItemIDByHC(25,1)
ClassMethod GetItemIDByHC(ID, IFSet)
{
	s Ret=""
	i IFSet="2"  d
	.s ID=$p($g(^DHCPEHCRelate("DHCPE",IFSet,ID)),"^",4)
	.
	.q:(ID="")
	.s str=$$ALPHAUP^SSUTIL4(ID)
	.
	.s id1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ID),0))
	.q:(id1="")
	.s id2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ID),id1,0))
	.s ids=id1_"||"_id2
	.s Ret="^"_ids
	i IFSet="1"  d
	.s IDS=$o(^DHCPEHCRelate("DHCPE",IFSet,ID,0)) 
	.
	.q:(IDS="")
	.s Num=$o(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(IDS),0))
	.s Ret=Num_"^"
	.
	q Ret
}

/// 搜索（预登记）团体客户基本信息表																																								单位编码				描述			地址				邮政编码					联系人				业务银行			帐号				联系电话1			联系电话2				Email
Query SearchPreGBaseInfo(GCode As %Library.String = "", GName As %Library.String = "", GAddress As %Library.String = "", GLinkman As %Library.String = "") As %Query(ROWSPEC = "PGBI_RowId:%String, PGBI_Code:%String, PGBI_Desc:%String, PGBI_Address:%String, PGBI_Postalcode:%String, PGBI_Linkman:%String, PGBI_Bank:%String, PGBI_Account:%String, PGBI_Tel1:%String, PGBI_Tel2:%String, PGBI_Email:%String, PGBI_Linkman2:%String, PGBI_FAX:%String, PGBI_PAPMINo:%String")
{
}

ClassMethod SearchPreGBaseInfoExecute(ByRef qHandle As %Binary, GCode As %Library.String = "", GName As %Library.String = "", GAddress As %Library.String = "", GLinkman As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	s GName=##class(web.DHCPE.DHCPECommon).UnEscape(GName)
	s GAddress=##class(web.DHCPE.DHCPECommon).UnEscape(GAddress)
	s GLinkman=##class(web.DHCPE.DHCPECommon).UnEscape(GLinkman)
	/*
 	if ((""=GCode) && (""=GName) && (""=GAddress) && (""=GLinkman)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	*/
	f  s id=$O(^DHCPEPreGBI(id)) Q:(""=id)  d
	.s CurData=$G(^DHCPEPreGBI(id))
	.s iLLoop=1
	.
	.//单位编码	PGBI_Code	1
	.s PGBICode=$p(CurData,"^",iLLoop)
	.q:((""'=GCode)&('(PGBICode[GCode)))
	.s iLLoop=iLLoop+1
	.
	.//描    述	PGBI_Desc	2
	.s PGBIDesc=$p(CurData,"^",iLLoop)
	.q:((""'=GName)&('(PGBIDesc[GName)))
	.s iLLoop=iLLoop+1
	.
	.//地    址	PGBI_Address	3
	.s PGBIAddress=$p(CurData,"^",iLLoop)
	.q:((""'=GAddress)&('(PGBIAddress[GAddress)))
	.s iLLoop=iLLoop+1
	.
	.//邮政编码	PGBI_Postalcode	4
	.s PGBIPostalcode=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系人	PGBI_Linkman1	5
	.s PGBILinkman1=$p(CurData,"^",iLLoop)
	.q:((""'=GLinkman)&('(PGBILinkman1[GLinkman)))
	.s iLLoop=iLLoop+1
	.
	.//业务银行	PGBI_Bank	6
	.s PGBIBank=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//帐    号	PGBI_Account	7
	.s PGBIAccount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系电话1	PGBI_Tel1	8
	.s PGBITel1=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系电话2	PGBI_Tel2	9
	.s PGBITel2=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//电子邮件	PGBI_Email	10
	.s PGBIEmail=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系人	PGBI_Linkman2	11
	.s PGBILinkman2=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//传真	PGBI_FAX	11
	.s PGBIFAX=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//登记号	PGBI_PAPMINo	11
	.s PGBIPAPMINo=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//						单位编码	描述	地址			邮政编码		联系人		业务银行	帐号	联系电话1	联系电话2	Email		联系人2			传真	登记号
    .set Data=$lb(	$g(id), PGBICode, PGBIDesc, PGBIAddress, PGBIPostalcode, PGBILinkman1, PGBIBank, PGBIAccount, PGBITel1, PGBITel2, PGBIEmail, PGBILinkman2, PGBIFAX, PGBIPAPMINo)
    .
    .d OutPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	s PGBIDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBIDesc,"ODDesc","cls")
	s PGBIAddress=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBIAddress,"PGBIAddress","cls")
	s PGBILinkman1=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBILinkman1,"PGBILinkman1","cls")
	s PGBILinkman2=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBILinkman2,"PGBILinkman2","cls")
	s PGBIBank=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBIBank,"PGBIBank","cls")
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreGBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreGBaseInfoExecute ]
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

ClassMethod SearchPreGBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreGBaseInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// /////////////////////////////////////////////////////////////////////////

/// 更新 增加/修改
/// d ##class(web.DHCPE.PreGBaseInfo).Save("","",InString)
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	new Rebate
	s iLLoop=1

	//						1
	s value=$p(InString,"^",iLLoop)
	s:(""'=value) PLIST(1)=value
	s iLLoop=iLLoop+1
	
 	//单位编码	PGBI_Code	2
	s value=$p(InString,"^",iLLoop)
	s:(""'=value) PLIST(2)=value
	s iLLoop=iLLoop+1
	
 	//描    述	PGBI_Desc	3
	s value=$p(InString,"^",iLLoop)
	s:(""'=value) PLIST(3)=value
	s iLLoop=iLLoop+1
	
 	//地    址	PGBI_Address	4
	s value=$p(InString,"^",iLLoop)
	s PLIST(4)=value
	s iLLoop=iLLoop+1
	
 	//邮政编码	PGBI_Postalcode	5
	s value=$p(InString,"^",iLLoop)
	s PLIST(5)=value
	s iLLoop=iLLoop+1
	
 	//联系人	PGBI_Linkman1	6
	s value=$p(InString,"^",iLLoop)
	s PLIST(6)=value
	s iLLoop=iLLoop+1
	
 	//业务银行	PGBI_Bank	7
	s value=$p(InString,"^",iLLoop)
	s PLIST(7)=value
	s iLLoop=iLLoop+1
	
 	//帐    号	PGBI_Account	8
	s value=$p(InString,"^",iLLoop)
	s PLIST(8)=value
	s iLLoop=iLLoop+1
	
 	//联系电话1	PGBI_Tel1	9
	s value=$p(InString,"^",iLLoop)
	s PLIST(9)=value
	s iLLoop=iLLoop+1
	
 	//联系电话2	PGBI_Tel2	10
	s value=$p(InString,"^",iLLoop)
	s PLIST(10)=value
	s iLLoop=iLLoop+1
	
 	//电子邮件	PGBI_Email	11
	s value=$p(InString,"^",iLLoop)
	s PLIST(11)=value
	s iLLoop=iLLoop+1
	
 	// 联系人 PGBI_Linkman2	12
	s value=$p(InString,"^",iLLoop)
	s PLIST(12)=value
	s iLLoop=iLLoop+1
	
 	// 传真 PGBI_FAX	13
	s value=$p(InString,"^",iLLoop)
	s PLIST(13)=value
	s iLLoop=iLLoop+1
	
 	// 就诊号 PGBI_PAPMINo	14
	s value=$p(InString,"^",iLLoop)
	s value=##class(web.DHCPE.DHCPECommon).RegNoMask(value)
	s PLIST(14)=value
	s iLLoop=iLLoop+1
	
	// 优惠率 PGBI_Rebate	15
	s value=$p(InString,"^",iLLoop)
	s PLIST(16)=value
	i (PLIST(16)'="")&&(PLIST(16)[".")&&($p(PLIST(16),".",1)="") s PLIST(16)=0_PLIST(16)
	s iLLoop=iLLoop+1
	//s Rebate=$p(InString,"^",iLLoop) //wrz
	//s iLLoop=iLLoop+1
	s CardNo=$p(InString,"^",iLLoop)
	
	//纳税人识别号
	s iLLoop=iLLoop+1
	s TaxIDNum=$p(InString,"^",iLLoop)
	s PLIST(17)=TaxIDNum

	s ret=..ISave()
	
	q ret
}

ClassMethod GetPreGBaseInfo(InString As %Library.String = "")
{
	//PGBI_RowId_"^"_PGBI_Code
	
	new Rebate
	s Rebate=""
	
	
	s id=$p($g(InString),"^",1)
	s Code=$p($g(InString),"^",2)
	
	Q:(""=id)&(""=Code) "0^"
	
	s CurData=""
	
	i ""'=id d
	.s CurData=$G(^DHCPEPreGBI(id))
	e  d
	.s id=0
	
	i 0=id d
	.s id=$O(^DHCPEPreGBI(0,"Code",Code,id))
	.i ""'=id d
	..s CurData=$G(^DHCPEPreGBI(id))
	
	i ""=CurData d
	.s Data="0"_"^"_Code
	e  d
	.s iLLoop=1
	.
	.//单位编码	PGBI_Code	1
	.s PGBICode=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//描    述	PGBI_Desc	2
	.s PGBIDesc=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//地    址	PGBI_Address	3
	.s PGBIAddress=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//邮政编码	PGBI_Postalcode	4
	.s PGBIPostalcode=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系人	PGBI_Linkman1	5
	.s PGBILinkman1=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//业务银行	PGBI_Bank	6
	.s PGBIBank=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//帐    号	PGBI_Account	7
	.s PGBIAccount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系电话1	PGBI_Tel1	8
	.s PGBITel1=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系电话2	PGBI_Tel2	9
	.s PGBITel2=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//电子邮件	PGBI_Email	10
	.s PGBIEmail=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//联系人	PGBI_Linkman2	11
	.s PGBILinkman2=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//传真	PGBI_FAX	11
	.s PGBIFAX=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.//登记号	PGBI_PAPMINo	11
	.s PGBIPAPMINo=$p(CurData,"^",iLLoop)
	.
	.//折扣率
	.s Rebate=$p(CurData,"^",14)
	.i ((Rebate[".")&&(Rebate'="")) d
	..i $p(Rebate,".",1)="" s Rebate=0_Rebate

	.s CardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(PGBIPAPMINo, "R")
	
	.//纳税人识别号 
	.s TaxIDNum=$p(CurData,"^",15)
	
	.s PGBIDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBIDesc,"ODDesc","cls")
	.s PGBIAddress=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBIAddress,"PGBIAddress","cls")
	.s PGBILinkman1=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBILinkman1,"PGBILinkman1","cls")
	.s PGBILinkman2=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBILinkman2,"PGBILinkman2","cls")
	.s PGBIBank=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",PGBIBank,"PGBIBank","cls")
		
	.s Data=$g(id)_"^"_PGBICode_"^"_PGBIDesc_"^"_PGBIAddress_"^"_PGBIPostalcode_"^"_PGBILinkman1_"^"_PGBIBank_"^"_PGBIAccount_"^"_PGBITel1_"^"_PGBITel2_"^"_PGBIEmail_"^"_PGBILinkman2_"^"_PGBIFAX_"^"_PGBIPAPMINo_"^"_Rebate_"^"_CardNo_"^"_TaxIDNum
	
	Q Data
}

/// 获取团体信息
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s Data=""
	
	i (""'=InString) s data=..GetPreGBaseInfo(InString)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	q Data
}

/// 删除
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s RowId=InString
	TSTART
	//wrz
	s SQLCODE=..UpdatePEGBaseInfo(RowId,"1")
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//end
	&sql(delete from DHC_PE_PreGBaseInfo where PGBI_RowId = :RowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

/// 保存数据RowId As %String, Code As %String, Desc As %String, Address As %String, Postalcode As %String, Linkman As %String, Bank As %String, Account As %String, Tel1 As %String, Tel2 As %String, Email As %String
ClassMethod ISave()
{
	
	new GBaseInfoID,SuccesFlag
	i 0'=$D(PLIST(1)) s GBaseInfoID=PLIST(1)
	s SuccesFlag=0
	TSTART

	i 0=$D(PLIST(1)) d
	.s ReturnFlag=..Insert()
	.s SuccesFlag=$p(ReturnFlag,"^",1)
	.s GBaseInfoID=$p(ReturnFlag,"^",2)
	e  d
	.s ReturnFlag=..Update()
	.s SuccesFlag=ReturnFlag 
	i SuccesFlag
	{
		TROLLBACK
		q ReturnFlag
	}
	s SQLCODE=..UpdatePEGBaseInfo(GBaseInfoID,"0")
	i SQLCODE
	{
		TROLLBACK
		s $p(ReturnFlag,"^",1)=SQLCODE
		q ReturnFlag
	}
	TCOMMIT
	q ReturnFlag
}

/// 修改CRM团体基本信息
/// GBaseInfoID预约团体基本信息
/// isDel=1 删除 Rebate折扣率
ClassMethod UpdatePEGBaseInfo(GBaseInfoID, isDel)
{
	new PEGBaseInfoID,GBaseInfo,PEGPLIST,Date,Time,User,ADMID
	s Date=+$H
	s Time=$p($H,",",2)
	s:($d(%session)) User=%session.Get("LOGON.USERID")
	s:'$d(%session) User=5918
	s GBaseInfo=$G(^DHCPEPreGBI(GBaseInfoID))
	s ADMID=..GetPAPIDByNo(..GetGBaseInfo(GBaseInfo,13))
	s PEGBaseInfoID=..GetPEGBaseInfo(ADMID)
	//s CRMBaseInfoID=..GetGBaseInfo(GBaseInfo,14)
	if isDel=1
	{
		&SQL(delete from sqluser.DHC_PE_GBaseInfo where GBI_RowId=:PEGBaseInfoID)
	}
	else
	{
		s PEGPLIST(2)=..GetGBaseInfo(GBaseInfo,1) //Code
		s PEGPLIST(3)=..GetGBaseInfo(GBaseInfo,2) //Desc
		s PEGPLIST(4)=..GetGBaseInfo(GBaseInfo,3) //Address
		s PEGPLIST(5)=..GetGBaseInfo(GBaseInfo,4) //postcode
		s PEGPLIST(6)=..GetGBaseInfo(GBaseInfo,5) //linkman1
		s PEGPLIST(7)=..GetGBaseInfo(GBaseInfo,6) //Bank
		s PEGPLIST(8)=..GetGBaseInfo(GBaseInfo,7) //Account
		s PEGPLIST(9)=..GetGBaseInfo(GBaseInfo,8) //Tel1
		s PEGPLIST(10)=..GetGBaseInfo(GBaseInfo,9) //Tel2
		s PEGPLIST(11)=..GetGBaseInfo(GBaseInfo,10) //Email 11
		s PEGPLIST(13)=ADMID //PAPMIDR 13
		s PEGPLIST(14)=..GetGBaseInfo(GBaseInfo,5) //Principal 14
		s PEGPLIST(15)=..GetGBaseInfo(GBaseInfo,14) //Rebate 15
		s PEGPLIST(16)=Date //Date 16
		s PEGPLIST(17)=Time
		s PEGPLIST(18)=User
		s PEGPLIST(19)=..GetGBaseInfo(GBaseInfo,11) //Linkman2
		s PEGPLIST(20)=..GetGBaseInfo(GBaseInfo,12) //Fax
		s PEGPLIST(22)=GBaseInfoID
		i PEGBaseInfoID=""
		{
			&SQL(insert into sqluser.DHC_PE_GBaseInfo values :PEGPLIST())
			//i SQLCODE q SQLCODE
			//s CRMBaseInfoID=$G(%ROWID)
			//&SQL(update sqluser.DHC_PE_PreGBaseInfo set PGBI_CRM_DR=:CRMBaseInfoID where PGBI_RowId=:GBaseInfoID)
		}
		else
		{
			&SQL(update sqluser.DHC_PE_GBaseInfo values :PEGPLIST() where GBI_RowId=:PEGBaseInfoID)
		}
		i SQLCODE q SQLCODE
		&SQL(update sqluser.PA_Patmas set PAPMI_Name=:PEGPLIST(3) where PAPMI_RowId1=:ADMID)
	}
	q SQLCODE
}

ClassMethod GetPEGBaseInfo(ADMID)
{
	new PEGBaseInfoID
	i ADMID="" q ""
	s PEGBaseInfoID=$o(^DHCPEGBI(0,"PAPMIDr",ADMID,""))
	q PEGBaseInfoID
}

ClassMethod UpdatePAPerson(PAPNo, Name)
{
	new PAPID
	//s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate"))
	s SQLCODE=0
	s PAPID=..GetPAPIDByNo(PAPNo)
	q:PAPID="" SQLCODE
	&SQL(update sqluser.pa_patmas set PAPMI_Name=:Name where PAPMI_RowId1=:PAPID)
	//i SQLCODE'=0 q SQLCODE
	//i CardRelate="Yes" d
	//.s SQLCODE=##class(web.DHCPE.PreIBIUpdate).UpdateCardInfo(PAPID, CardNo)
	q SQLCODE
}

ClassMethod GetPAPIDByNo(PAPNo)
{
	new PAPID
	s PAPID=$o(^PAPERi("PAPMI_PatNo",PAPNo,""))
	q PAPID
}

/// 得到传入数据的顺序为Order的值
ClassMethod GetGBaseInfo(GBaseInfo, Order)
{
	q $p(GBaseInfo,"^",Order)
}

ClassMethod IsExistCode(aCode As %String = "")
{
	&sql(select PGBI_RowId into :IsExistCode from DHC_PE_PreGBaseInfo where PGBI_Code=:aCode)
	q:(""=IsExistCode) 0
	q IsExistCode
}

/// 更新
ClassMethod Update()
{
	//优先取session
	s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
	s:LocID="" LocID = 105 //先考虑从业务表中取就诊科室，没有就诊的再赋个默认值？
	
	s RowId=PLIST(1)		// PIADM_RowId
	k PLIST(1)
	k PLIST(2)
	&SQL(Update SQLUSER.DHC_PE_PreGBaseInfo Values :PLIST() 
		where PGBI_RowId = :RowId
		)
	q:SQLCODE'=0 SQLCODE
	//s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate"))
	s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate",LocID))
	i (CardRelate="Yes")&&(CardNo'="") d
	.s RegNo=$p(^DHCPEPreGBI(RowId),"^",13)
	.s PAPIMID=..GetPAPIDByNo(RegNo)
	.;s ^renzwang(2)=CardNo_"^"_PAPIMID
	.s SQLCODE=##class(web.DHCPE.PreIBIUpdate).UpdateCardInfo(PAPIMID, CardNo)
	
	q SQLCODE
}

ClassMethod Insert()
{
	k PLIST(1)				// PIADM_RowId
	s PLIST(2)=##class(web.DHCPE.Public.Setting).GetGroupPatNO()
	s SQLCODE=..InsertPaPerson()
	i SQLCODE'=0 q SQLCODE_"b^"_%ROWID_"^"_PLIST(2)_"^"
	s PLIST(14)=P5
	&SQL(
			Insert Into SQLUSER.DHC_PE_PreGBaseInfo Values :PLIST()
		)
	i SQLCODE'=0 q SQLCODE_"g^"_%ROWID_"^"_$G(PLIST(2))_"^"_$G(PLIST(14))
	q SQLCODE_"^"_%ROWID_"^"_$G(PLIST(2))_"^"_$G(PLIST(14))
}

ClassMethod InsertPaPerson()
{
	//优先取session
	s:$D(%session) LocID = %session.Get("LOGON.CTLOCID")
	s:LocID="" LocID = 105 //先考虑从业务表中取就诊科室，没有就诊的再赋个默认值？
	
	k P6
	k P5
	s name=PLIST(3)
	s telh=PLIST(9)
	s telo=PLIST(10)
	/*
	s patType=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",1) //默认体检类型
	s SexDR=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",2)
	i SexDR="" s SexDR=$P($G(^DHCPESetting("DHCPE","DefPatientType")),"^",3)
	s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate"))
	*/
	s patType=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",1) //默认体检类型
	s SexDR=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",2)
	i SexDR="" s SexDR=$P($G(^DHCPESetting("DHCPE","DefPatientType",LocID)),"^",3)
	s CardRelate=$G(^DHCPESetting("DHCPE","CardRelate",LocID))
	s RegModel=$G(^DHCPESetting("DHCPE","PAPMINo_GenModel"))
	
	i PLIST(14)'=""&&(+PLIST(14)'=0){
		s PAPID=$o(^PAPERi("PAPMI_PatNo",PLIST(14),""))
		i PAPID'="" d
		.s SQLCODE=..UpdatePAPerson(PLIST(14), name)
		.s P5=PLIST(14)
		e  d
		.&sql(
		insert into pa_person
		(
		paper_name,paper_telh,
		paper_secondphone,
		PAPER_Sex_DR,
		PAPER_SocialStatus_DR
		)
     	values(
     	:name,:telh,:telo,:SexDR,:patType
		)
		) 
		.q:"0"'=SQLCODE
		.s P6=$p(%ROWID,$c(1),1)
		.s myrowid=P6
		.s mytype=$g(mytype)
		.s mypano=PLIST(14)
		.&sql(update pa_patmas
					set papmi_No=:mypano,
					papmi_ipno=:mypano,
					papmi_opno=:mypano
					where papmi_rowid=:myrowid
		)      
		.s P5=mypano
		.q:SQLCODE'=0
		.i ((CardRelate="Yes")&&(CardNo'="")) d
		..s SQLCODE=##class(web.DHCPE.PreIBIUpdate).UpdateCardInfo(myrowid, CardNo) 
		q SQLCODE
		
	}
	&sql(
		insert into pa_person
		(
		paper_name,paper_telh,
		paper_secondphone,
		PAPER_Sex_DR
		)
     	values(
     	:name,:telh,:telo,:SexDR
		)
	) 
	q:("0"'=SQLCODE) SQLCODE
	
	i SQLCODE="0"
	{
		s P6=$p(%ROWID,$c(1),1)
		s myrowid=P6
		s mytype=$g(mytype)
	     
		lock ^PAPER(0,"CNT","I")
		s CurRegNo=^PAPER(0,"CNT","I")
		s ^PAPER(0,"CNT","I")=CurRegNo+1
		lock -^PAPER(0,"CNT","I")
	     
		s mypano=$g(CurRegNo)    ;8位的登记号
		s mypano=mypano+1
		s mypano=##class(web.DHCPE.DHCPECommon).RegNoMask(mypano)
		&sql(update pa_patmas
					set papmi_No=:mypano,
					papmi_ipno=:mypano,
					papmi_opno=:mypano
					where papmi_rowid=:myrowid
	)      
	}	     
	s P5=mypano
	q:SQLCODE'=0 SQLCODE
	i (CardRelate="Yes")&&(CardNo'="") d
	.s SQLCODE=##class(web.DHCPE.PreIBIUpdate).UpdateCardInfo(myrowid, CardNo)
	q SQLCODE
}

/// Created by SongDeBo 2006/6/16
/// Description: 根据查询条件取PreGBAseInfo的ResultSet
/// Paremeter:
/// 		QueryType: "GROUPID"/"GROUPNAME"/"GRPREGID"
/// 		QueryValue: 对就QueryType的值
/// Return: A %ResultSet object
ClassMethod QueryRST(QueryType, QueryValue) As %ResultSet
{
	s sqlCondition=""
	if (QueryType="GRPREGID"){
		s sqlStr="select pgadm_pgbi_dr as RowId from DHC_PE_PreGADM where pgadm_rowid="_QueryValue
	}
	else {
		s sqlCondition=$select(
			QueryType="GROUPID":" pgbi_rowId='"_QueryValue_"'",
			QueryType="GROUPNAME":" pgbi_desc like '"_QueryValue_"'",
			1:"")
		q:sqlCondition="" "Error: Arguments is wrong, in "_$zn	
		s sqlStr="select pgbi_rowid as RowId from DHC_PE_PreGBaseInfo where "_sqlCondition
	}
	s retRST=##class(%ResultSet).%New()
	d retRST.Prepare(sqlStr)
	d retRST.Execute()
	b
	q retRST
}

/// 输入登记号 从HIS获取信息
/// w ##class(web.DHCPE.PreGBaseInfo).GetHISInfo("","","^1700001^")
/// 
ClassMethod GetHISInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ^tempdhcpe("GetHISInfo","Param")=InString
	//s id=$P($g(InString),"^",1)
	s RegNo=$p($g(InString),"^",2)
	i ""'=RegNo s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s CardTypeID=$p($g(InString),"^",3) //卡类型
	//s Name=$p($g(InString),"^",3)
	Q:(""=RegNo) ""
	s PAPMIRowId=""
	s PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId))
	b // w RegNo_"   "_PAPMIRowId
	//S:(""=PAPMIRowId) Data="^"_RegNo_"^"_"无此记录"
	Q:(""=PAPMIRowId) ""

    
    // 登记号 PA_PatMas.{PAPMI_IPNo}
    //s PAPMIIPNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)

    // 患者姓名 PA_PatMas.{PAPMI_Name}
    s PAPMIName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1) 
	s CardNo=##class(web.DHCPE.PreIBIUpdate).GetRelate(PAPMIRowId_"$"_CardTypeID, "P")
	//			0				登记号 1		姓名 2	
	//s Data=$g(id)		_"^"_PIBIPAPMINo_"^"_PIBIName	
	s Data=PAPMIRowId	_"^"_RegNo		_"^"_PAPMIName_"^"_CardNo
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>	
	q Data
}

ClassMethod GetGCodeByADM(ADMID)
{
	new GCode,GID
	s GID=$o(^DHCPEPreGBI(0,"PAPAMINo",ADMID,""))
	i GID="" q ""
	s GCode=$p($G(^DHCPEPreGBI(GID)),"^",1)
	q GCode
}

ClassMethod GetGDescByADM(ADMID)
{
	q:ADMID="" ""
	q:'$d(^DHCPEPreGBI(ADMID)) ADMID
	s GDesc=$p($g(^DHCPEPreGBI(ADMID)),"^",2)
	q GDesc
}

}
