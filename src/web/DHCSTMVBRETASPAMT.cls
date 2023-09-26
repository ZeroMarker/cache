/// Description：	业务发生损益表的维护
/// Creater：		zhouyg
Class web.DHCSTMVBRETASPAMT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	保存退货损益表
/// Creater:	zhouyg
/// CreateDate:	20130819
/// Input:		sdata-库存项ID^科室ID^售价差^数量^售价差额^用户ID^业务ID^业务类型(同Trans表的类型)^进价差^进价差额^单位ID
/// Output:		0-成功,其他-失败
ClassMethod InsAspAmt(sdata As %String) As %String
{
 N (sdata)
 K PLIST
 S PLIST(2)=$p(sdata,"^",1)		//RETA_INCI_DR
 S PLIST(3)=$p(sdata,"^",2)		//RETA_CTLOC_DR
 S PLIST(4)=$p(sdata,"^",3)		//售价差
 S PLIST(5)=$p(sdata,"^",4)		//RETA_Qty
 S PLIST(6)=$p(sdata,"^",5)		//售价差额
 S PLIST(7)=$p(sdata,"^",6)		//RETA_SSUSR_DR
 S PLIST(8)=+$h					//RETA_Date
 S PLIST(9)=$p($h,",",2) 		//RETA_Time
 S PLIST(10)=$p(sdata,"^",7)	//RETA_Pointer
 S PLIST(11)=$p(sdata,"^",8)	//RETA_Type
 S PLIST(12)=$p(sdata,"^",9)	//进价差
 S PLIST(13)=$p(sdata,"^",10)	//进价差额
 S PLIST(14)=$p(sdata,"^",11)	//单位ID
 &SQL(Insert Into SQLUser.DHC_RetAspAmount Values :PLIST())
 i SQLCODE'=0  d
 .s PLISTValue=""
 .s lenPlist=$o(PLIST(""),-1)
 .f ii=1:1:lenPlist d
 ..i PLISTValue="" d
 ...s PLISTValue=$g(PLIST(ii))
 ..e  d
 ...s PLISTValue=PLISTValue_"^"_$g(PLIST(ii))
 .s ret=$$SqlErrorRecord^DHCSTERROR("web.DHCSTMVBRETASPAMT.InsAspAmt",PLISTValue,SQLCODE_":"_$g(%msg))
 Q SQLCODE
}

/// Descript:	计算门诊发药的损益金额
/// Creater:	zhouyg
/// CreateDate:	20130819
/// Input:		PHDCLB-门诊发药批次表ID,userID-用户表ID
/// Return:		0-成功,其他-失败
ClassMethod CreateAspAmtF(PHDCLB As %String, userID As %String) As %String
{
	n (PHDCLB,userID)
	s PHDID=$p(PHDCLB,"||",1)
	s PHDSub=$p(PHDCLB,"||",2)
	s PHDCSub=$p(PHDCLB,"||",3)
	q:(PHDID="")!(PHDSub="")!(PHDCSub="") -1
	s PHDClbStr=^DHCPHDI(PHDID,"PHDI",PHDSub,"INCLB",PHDCSub)
	q:PHDClbStr="" -2
	s phlocID=$p(^DHCPHDISP(PHDID,1),"^",1)
	q:phlocID="" -2
	s locID=$p(^DHCPHLOC(phlocID),"^",1)
	q:locID="" -3
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locID)
	s HospID=$p(CustStr,"^",5)
	s CustID=$p(CustStr,"^",1)
	s qty=$p(PHDClbStr,"^",1)
	s inclb=$p(PHDClbStr,"^",3)
	s sp=$p(PHDClbStr,"^",7)
	s spAmt=$p(PHDClbStr,"^",8)
	s rp=$p(PHDClbStr,"^",5)
	s rpAmt=$p(PHDClbStr,"^",6)
	s inci=$p(inclb,"||",1)
	s bUomID=$p(^INCI(inci,1),"^",10)
	s CurSp=+##Class(web.DHCSTPRICE).GetCurSp(inclb,"",HospID)
	s CurSpAmt=CurSp*qty
	s CurRp=+##Class(web.DHCSTPRICE).GetCurRp(inclb,"",HospID)
	s CurRpAmt=CurRp*qty
	s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(inci)
	s StkTypeDesc=$P(CatGrpStr,"^",4)
    s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s CurSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurSpAmt,Perv,"FmtSA",1)
    s CurRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurRpAmt,Perv,"FmtRA",1)
	s SpDiff=CurSp-sp
	s SpAmtDiff=spAmt-CurSpAmt
	s RpDiff=CurRp-rp
	s RpAmtDiff=rpAmt-CurRpAmt
	s sdata=inci_"^"_locID_"^"_SpDiff_"^"_-qty_"^"_SpAmtDiff_"^"_userID_"^"_PHDCLB_"^"_"F"_"^"_RpDiff_"^"_RpAmtDiff_"^"_bUomID
	s RetCode=..InsAspAmt(sdata)
	q RetCode
}

}
