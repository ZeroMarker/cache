Import SQLUser

Class web.DHCINSUFacade Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 29;

// w ##class(web.DHCINSUFacade).GetBillInfoByBillDr(197936, "LFA")

/// add InsuType
ClassMethod GetBillInfoByBillDr(strBillDr As %String, InsuType As %String) As %String
{
	s GetBillInfoByBillDr=$$GetBillInfoByBillDr^DHCINSUFacade(strBillDr,InsuType)
	q GetBillInfoByBillDr
}

ClassMethod GetBillInfoFromCacheTmp(ID As %String, i As %String) As %String
{
	s GetBillInfoFromCacheTmp=$$GetBillInfoFromCacheTmp^DHCINSUFacade(ID,i)
	q GetBillInfoFromCacheTmp
}

/// 分段取明细集合数据
/// w ##class(web.DHCINSUFacade).GetBillInfoStreamFromCacheTmp()
/// + DingSH 20230221 参考 wty 
ClassMethod GetBillInfoStreamFromCacheTmp(ID, starIndex, endIndex) As %Stream.GlobalCharacter
{
    s mStream  = ##class(%Stream.GlobalCharacter).%New()
    f index=starIndex:1:endIndex {
          s mCurrRowCacheTemp=$g(^CacheTemp("BillInfo",ID ,index))
          s mCurrRowCacheTemp=$tr(mCurrRowCacheTemp,$c(13),"")
          d mStream.Write(mCurrRowCacheTemp)
          d mStream.Write($c(13))
         k ^CacheTemp("BillInfo",ID,index)
     }			
     q mStream
}

ClassMethod GetBillSumByCate(strBillDr As %String, CateType As %String) As %String
{
	s GetBillSumByCate=$$GetFeeSumByCate^DHCINSUFacade(strBillDr,CateType)
	q GetBillSumByCate
}

/// add 2007 07 16 
ClassMethod GetOPBillInfoByBillDr(strBillDr As %String, InsuType As %String) As %String
{
	s GetBillInfoByBillDr=$$GetOPBillInfoByBillDr^DHCINSUFacade(strBillDr,InsuType)
	//s ^TempInsurance($j)=strBillDr_"^"_"GetOPBillInfoByBillDr"_"^"_$zt($p($h,",",2),1)_"^"_##class(%SYSTEM.Process).%OpenId($j).ClientIPAddressGet()
	q GetBillInfoByBillDr
}

ClassMethod GetOPBillInfoFromCacheTmp(ID As %String, i As %String) As %String
{
	s GetBillInfoFromCacheTmp=$$GetOPBillInfoFromCacheTmp^DHCINSUFacade(ID,i)
	q GetBillInfoFromCacheTmp
}

/// add by yjz_20081023
/// 取医嘱费用信息
/// strBillDr：账单号   ，InsuType ：医保类型"SZ"
/// w ##class(web.DHCINSUFacade).GetOrdBillInfoByBillDr("54","SZ")
ClassMethod GetOrdBillInfoByBillDr(strBillDr As %String, InsuType As %String) As %String
{
	s GetOrdBillInfoByBillDr=$$GetOrdBillInfoByBillDr^DHCINSUFacade(strBillDr,InsuType)
	q GetOrdBillInfoByBillDr
}

/// add by yjz_20081023
/// 根据进程号取CacheTemp数据
ClassMethod GetOrdBillInfoFromCacheTmp(ID As %String, i As %String) As %String
{
	s GetOrdBillInfoFromCacheTmp=$$GetOrdBillInfoFromCacheTmp^DHCINSUFacade(ID,i)
	q GetOrdBillInfoFromCacheTmp
}

ClassMethod GetPrtInvPreFix(strPapmiDr) As %String
{
	n (strPapmiDr)
	s outstr=""
	s strPat=$$GetPatInfoByPatID^DHCINSUPatInfo(strPapmiDr)
	s InsuCardNo=$p(strPat,"^",11)  ;手册号
	i $l(InsuCardNo)=12 d
	.s outstr="上传No:"
	q outstr
}

/// Creator: 	  CZQ
/// CreatDate：	  2009-07-16
/// Description:  记录医保登记次数 for CC
/// Table:		  No
/// Input:		  Adm
/// Output:		  No
/// Return:		  0
/// Others:		  No
ClassMethod AdmInsuRegNum(Adm As %String) As %String
{
	q:($g(Adm)="") 0
	s Ret=0
	i '$d(^DHCINSUCHAIN("INSUDADMNUM",Adm))  d
	.s ^DHCINSUCHAIN("INSUDADMNUM",Adm)=0
	e    d
	.s Ret=$g(^DHCINSUCHAIN("INSUDADMNUM",Adm))
	.s Ret=Ret+1
	.s ^DHCINSUCHAIN("INSUDADMNUM",Adm)=Ret
	q Ret
}

/// Creator: 	  CZQ
/// CreatDate：	  2009-07-16
/// Description:  更新医保限价
/// Table:		  No
/// Input:		  Jpid，i，限价
/// Output:		  No
/// Return:		  0
/// Others:		  No
ClassMethod SetOPBillInfoFromCacheTmp(ID As %String, i As %String, LimitPrice As %String, InsuInfo As %String) As %String
{
	s SetOPBillInfoFromCacheTmp=$$SetOPBillInfoFromCacheTmp^DHCINSUFacade(ID,i,LimitPrice,InsuInfo)
	q SetOPBillInfoFromCacheTmp
}

//  w ##class(web.DHCINSUFacade).GetBillListByAdmDr(76)

/// Creator: 	  CZQ
/// CreatDate：	  2009-07-16
/// Description:  通过上传明细得到帐单列表
/// Table:		  DHC_Insuupdetails
/// Input:		  AdmDr
/// Output:		  No
/// Return:		  帐单rowid (bill1^bill2)
/// Others:		  No
ClassMethod GetBillListByAdmDr(AdmDr As %String) As %String
{
	s GetBillListByAdmDr=$$GetBillListByAdmDr^DHCINSUFacade(AdmDr)
	q GetBillListByAdmDr
}

/// 根据INVPRT取处方信息
ClassMethod GetRecipeInfoByInvprtdr(InvprtDr As %String) As %String
{
	//"179131^1^O12103000010^20121030^0000^^^^^传染科门诊^^^2"
	s GetRecipeInfoByInvprtdr=$$GetRecipeInfoByInvprtdr^DHCINSUFacade(InvprtDr)
	q GetRecipeInfoByInvprtdr
}

/// *************上传医嘱接口*************///
/// Creator: 	  Wangwei
/// CreatDate：	  2012-11-20
/// Description:  通过Paadmrowid\BillNo得到医嘱明细
/// Table:		  
/// Input:		  
/// Output:		  
/// Return:		  
/// Others:	
/// w ##class(web.DHCINSUFacade).GetOrderDetailsByNo("3834240","8432318")  
ClassMethod GetOrderDetailsByNo(PaadmRowid As %String, BillNo As %String) As %CharacterStream
{
	s objstream = ##class(%Stream.GlobalCharacter).%New()
	d objstream.Clear()
	s Ret="<Response><ResultCode>-1</ResultCode><ErrorMsg>未找到医嘱信息 </ErrorMsg></Response>"
	d objstream.Write(Ret)
	q:$g(BillNo)="" objstream
	//q:$d(^DHCINDIV("0","DHCPB",BillNo))=0 Ret
	s Ret="<Response><ResultCode>0</ResultCode>"
    d objstream.Clear()
	d objstream.Write(Ret)
	s Orderdate="",OrderStdate="",XDate="",OrderDocRowid="",OrderDocID=""
	s BillSubRowid=0
	f  s BillSubRowid=$o(^DHCPB(BillNo,"O",BillSubRowid)) q:BillSubRowid=""  d
	.s PBOrderRowid=$P(^DHCPB(BillNo,"O",BillSubRowid),"^",4)
	.s AricmRowid=$P(^DHCPB(BillNo,"O",BillSubRowid),"^",3)
	.s AricmSubRowid=$p(AricmRowid,"||",2)
	.s OrderRowid=$p(PBOrderRowid,"||",1),OrderSubRowid=$p(PBOrderRowid,"||",2)
	.s OEORIPriorityRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,1),"^",8)
	.s OEORIPriority=$p(^OECPR(OEORIPriorityRowid),"^",2)  //医嘱类型
	.//w OEORIPriorityRowid_"^"_PBOrderRowid_"+"
	.i OEORIPriorityRowid'="5"  d      //非长期医嘱
	..s Priority=1
	..s AricmDesc=$p(^ARCIM(+AricmRowid,AricmSubRowid,1),"^",2)  //医嘱名称
	..s OrderDocRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,1),"^",11)
	..q:OrderDocRowid=""  //滚出的医嘱不计算
	..s OrderDocID=$p(^CTPCP(OrderDocRowid,1),"^",1),OrderDocName=$p(^CTPCP(OrderDocRowid,1),"^",2)  //开单医生姓名
	..s Orderdate=$p(^OEORD(OrderRowid,"I",OrderSubRowid,3),"^",7)  //下医嘱时间
	..s OrderStdate=$p(^OEORD(OrderRowid,"I",OrderSubRowid,1),"^",9)  //开始日期
	..s Orderdate=$zd(Orderdate,3)
	..s OrderStdate=$zd(OrderStdate,3)
	..s XDate=$p(^OEORD(OrderRowid,"I",OrderSubRowid,3),"^",34) //结束日期
	..i XDate'="" s XDate=$zd(XDate,3)
	..i XDate="" s XDate=Orderdate
	..s OrderXDocRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,3),"^",29)
	..s XDocID="",XDocName=""
	..i OrderXDocRowid'="" s XDocID=$p(^CTPCP(OrderXDocRowid,1),"^",1),XDocName=$p(^CTPCP(OrderXDocRowid,1),"^",2)  //停医嘱相关信息
	..i XDocID=""  s XDocID=OrderDocID
	..s ArcimCode=$p(^ARCIM(+AricmRowid,AricmSubRowid,1),"^",1) //医嘱代码
	..s OLTStdate=$o(^DHCOLT(0,"ARCIM",AricmRowid,"Z",0))
	..s OLTRowid=$o(^DHCOLT(0,"ARCIM",AricmRowid,"Z",OLTStdate,0))
	..s TarRowid=$p(^DHCOLT(OLTRowid),"^",2)
	..s TarCode=$p(^DHCTARI(TarRowid),"^",1)
	..s OrderPHFreqRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,2),"^",4)
	..s PHFreqCode="St"
	..i OrderPHFreqRowid'="" d
	...s PHFreqCode=$p(^PHCFR(OrderPHFreqRowid),"^",1)  //频次
	
	.i OEORIPriorityRowid=5 d   //长期医嘱
	..s Priority=2
	..s OrderFillerNo=$p(^OEORD(OrderRowid,"I",OrderSubRowid,9),"^",12)
	..q:OrderFillerNo'=""   //滚出来的长嘱不上传 
	..s AricmDesc=$p(^ARCIM(+AricmRowid,AricmSubRowid,1),"^",2)  //医嘱名称
	..s OrderDocRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,1),"^",11)
	..q:OrderDocRowid=""
	..s OrderDocID=$p(^CTPCP(OrderDocRowid,1),"^",1)
	..s OrderDocName=$p(^CTPCP(OrderDocRowid,1),"^",2)  //开单医生姓名
	..s Orderdate=$p(^OEORD(OrderRowid,"I",OrderSubRowid,3),"^",7)  //下医嘱时间
	..s OrderStdate=$p(^OEORD(OrderRowid,"I",OrderSubRowid,1),"^",9)  //开始日期
	..//s OrderXDocRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,3),"^",29)
	..s Orderdate=$zd(Orderdate,3)
	..s OrderStdate=$zd(OrderStdate,3)
	..s XDate="",XDocID=""
	..s ArcimCode=$p(^ARCIM(+AricmRowid,AricmSubRowid,1),"^",1) //医嘱代码
	..s OLTStdate=$o(^DHCOLT(0,"ARCIM",AricmRowid,"Z",0))
	..s OLTRowid=$o(^DHCOLT(0,"ARCIM",AricmRowid,"Z",OLTStdate,0))
	..s TarRowid=$p(^DHCOLT(OLTRowid),"^",2)
	..s TarCode=$p(^DHCTARI(TarRowid),"^",1)
	..s OrderPHFreqRowid=$p(^OEORD(OrderRowid,"I",OrderSubRowid,2),"^",4)
	..s PHFreqCode="St"
	..i OrderPHFreqRowid'="" s PHFreqCode=$p(^PHCFR(OrderPHFreqRowid),"^",1)  //频次
	..s XStr=##class(web.DHCLONGTIMEORD).PRX(OrderRowid,OrderSubRowid)
	..s XDate=$p(XStr,"|",1),XTime=$p(XStr,"|",2),XDoc=$p(XStr,"|",3)  //停医嘱信息
	..i XDoc'="" d 
	...s XDocRowidID=$o(^CTPCP(0,"Decs",XDoc,0))
	...s XDocID=$p(^CTPCP(XDocRowidID,1),"^",1)
	..i XDate="" s XDate=$ZD(+$h,3)
	..i XDocID=""  s XDocID=OrderDocID
	

	.//i OrderDocID["Z" s OrderDocID="0007"
	.//i XDocID["Z" s XDocID="0007"
	.//--------------------循环写XML------------->
	
	.s Ret="<Row>"
	.s Ret=Ret_"<lsh>"_PBOrderRowid_"</lsh>"
	.s Ret=Ret_"<nr>"_AricmDesc_"</nr>"
	.s Ret=Ret_"<ysbm>"_OrderDocID_"</ysbm>"
	.s Ret=Ret_"<fssj>"_Orderdate_"</fssj>"
	.s Ret=Ret_"<lx>"_Priority_"</lx>"
	.s Ret=Ret_"<blxmmc>"_""_"</blxmmc>"
	.s Ret=Ret_"<sxh>"_OrderSubRowid_"</sxh>"
	.s Ret=Ret_"<yyxmbm>"_TarCode_"</yyxmbm>"
	.s Ret=Ret_"<qsrq>"_OrderStdate_"</qsrq>"
	.s Ret=Ret_"<zzrq>"_XDate_"</zzrq>"
	.s Ret=Ret_"<kjys>"_OrderDocID_"</kjys>"
	.s Ret=Ret_"<zzys>"_XDocID_"</zzys>"
	.s Ret=Ret_"<pc>"_PHFreqCode_"</pc>"
	.s Ret=Ret_"</Row>"
	.s ^DHCWangtmp(OrderRowid,OrderSubRowid)=Ret
	.d objstream.Write(Ret)
	.//<------------------循环结束 -------------------------------//
	s Ret="</Response>"
	d objstream.Write(Ret)
	q objstream
}

/// w ##class(web.DHCINSUFacade).GetBillInfoByPEInvPrtDrr("72","WHA")
ClassMethod GetBillInfoByPEInvPrtDr(strBillDr As %String, InsuType As %String) As %String
{
	s GetBillInfoByPEInvPrtDr=$$GetPEBillInfoByInvPrtDr^DHCINSUFacade(strBillDr,InsuType)
	//s ^TempInsurance($j)=strBillDr_"^"_"GetOPBillInfoByBillDr"_"^"_$zt($p($h,",",2),1)_"^"_##class(%SYSTEM.Process).%OpenId($j).ClientIPAddressGet()
	q GetBillInfoByPEInvPrtDr
}

/// 转换门诊挂号医生站传进来的入参
/// Creator: 	  zhangdongliang
/// CreatDate：	  2015-10-20
/// Description:  目的是挂号信息中取到 科室、诊断、收费项等的对照信息。根据各项目实际情况，修改web.DHCINSUFacade.TransforRegInfo
/// Table:		  
/// Input:		  InStr:Type^Name^TotalAmount^HisDepCode^UserId^Doctor^InsuNo^CardType^YLLB^DiagCode^ DiagDesc!TarItemDr^Code^Desc^Amount!TarItemDr2^Code2^Desc2^Amount2!……	  
/// Output:		  
/// Return:		  
/// Others:	
/// w ##class(web.DHCINSUFacade).TransforRegInfo("E^保保保^11^ZYJZ001^7^HBJZ01^^0^^^^01^cn_iptcp:114.242.246.235[1972]:DHC-APP|_system|3508460A3453|GlobalEMR||18080|HOSPID:2^119^57^9925.77^3^2020-06-01 11:24:19^急诊内科门诊!7930^110200003^急诊诊查费^10.000000!7933^110100001A^挂号费^1.000000","4")
ClassMethod TransforRegInfo(InStr As %String, AdmReasonDr As %String) As %String
{
	s OutStr=InStr
	;标准版测试数据
	;s InStr=Type^Name^TotalAmount^HisDepCode^UserId^Doctor^InsuNo^CardType^YLLB^DiagCode^DiagDesc^GHLY^数据库连接串!TarItemDr^Code^Desc^Amount!TarItemDr2^Code2^Desc2^Amount2!……
	;如果不需要任何转换，此处直接q返回
	;q OutStr
	s tempAdmInfo=$p(InStr,"!",1)
	s HisDepCode=$p(tempAdmInfo,"^",4)
	;科室诊断对照
	;s INSUDepCode=$p($$QueryByCode^DHCINSUDicData(" ",HisDepCode),"^",6) 
	;s INSUDiagCode=$p($$QueryByCode^DHCINSUDicData(" ",DiagCode),"^",6) 
    ;增加
    s doctCode=$p(tempAdmInfo,"^",6)
    s HospDr = $p($P($P(InStr,"HOSPID:",2),"^",1),"|","1")  //+ DingSH 20200601
    s InsuType = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDr,6,HospDr)
    q:InsuType="" "-1^组织挂号拼串，医保类型不能为空"
    //开始 todo 对 tempAdmInfo 数据的处理
	s MRDIADocId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(doctCode),""),-1)
	s doctUnit=$P(##class(web.DHCINSUBase).GetStdInfoByCareProvDR(MRDIADocId,HospDr),"^",1)
     //s doctUnit=$P(##class(web.DHCINSUPort).GetStdInfoByUserCode(doctCode,HospDr),"^",1) //+DingSH 20220830
     s $p(tempAdmInfo,"^",6) = doctUnit
     //s $p(Instr,"!",1)=tempAdmInfo
     s $p(InStr,"!",1)=tempAdmInfo	//upt HanZH 20230601 需求号	3569556
    //结束 对 tempAdmInfo 数据的处理
	s len=$l(InStr,"!")
	f index=2:1:len  
	{
		s BillInfo=$p(InStr,"!",index)
		s TarItemDr=$p(BillInfo,"^",1)
		s Code=$p(BillInfo,"^",2)
		s Desc=$p(BillInfo,"^",3)
		s Amount=$p(BillInfo,"^",4)
		;s InsuType=$p(##class(web.INSUDicDataCom).QueryByCode("AdmReasonDrToTariType",AdmReasonDr,HospDr),"^",6)  ;通过AdmReasonDr判断目录类别
		; 标准版测试数据 
		;s InsuType="BJ"
		;q:InsuType=""
		;收费项对照
		s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(TarItemDr,InsuType,$zd(+$h,3),"", HospDr)
		s TarItemInsuInfo=$p(TarItemInsuInfo,"^",1,23) 	;截取到tjdm字段 暂时够用。
		;分割HIS、INSU数据信息的分隔符，暂时用#
		s TarContrastInfo=$$GetContrastInfo^DHCINSUTarContrast(TarItemDr,InsuType,$zd(+$h,3),HospDr)
		s BillInfo=BillInfo_"#"_TarItemInsuInfo_"#"_TarContrastInfo
		s $p(InStr,"!",index)=BillInfo
	}
	s OutStr=InStr
	q OutStr
}

}
