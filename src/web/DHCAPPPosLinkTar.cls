Class web.DHCAPPPosLinkTar Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor)
{

/// d ##class(web.DHCAPPPosLinkTar).QueryLinkTar()
ClassMethod QueryLinkTar(rows = 10, page = 1, type = "", pointer = "", hospid = "")
{
	
		s ^tempqujina("QueryLinkTar")=rows_","_page_","_type _","_ pointer_","_hospid 
		s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    w "{""rows"":["
	    
	    i type="MED" d
	    .s tar=""
		.f  s tar=$o(^DHCAPMEDTAR(0,"Med",pointer,tar)) q:tar=""  d
		..s startdate=""
		..f  s startdate=$o(^DHCAPMEDTAR(0,"Med",pointer,tar,startdate)) q:startdate=""  d
		...s link="" 
		...f  s link=$o(^DHCAPMEDTAR(0,"Med",pointer,tar,startdate,link)) q:link=""  d
		....q:+link=0
		....q:'$d(^DHCAPMEDTAR(link))
		....q:$d(^DHCAPMEDTAR(link))=10
		....s TarStart=$p(^DHCAPMEDTAR(link),"^",3)
		....s TarEnd=$p(^DHCAPMEDTAR(link),"^",5)
		....s:TarEnd=0 TarEnd=""  //sufan  2016年7月11日
		....s qty=$p(^DHCAPMEDTAR(link),"^",10)
	    ....s UpdUser=$p(^DHCAPMEDTAR(link),"^",7)
		....s UpdDate=$p(^DHCAPMEDTAR(link),"^",8)
		....s UpdTime=$p(^DHCAPMEDTAR(link),"^",9)
		....s code=$p(^DHCTARI(tar),"^",1)
		....s desc=$p(^DHCTARI(tar),"^",2)
		....s tarSub=""
		....s price=0
		....f  s tarSub=$o(^DHCTARI(tar,"P",tarSub)) q:tarSub=""  d
		.....s hospDr=$p(^DHCTARI(tar,"P",tarSub),"^",16)
		.....set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", hospid)
		.....q:hospDr'=GroupHospID
		.....s Startdate=$p(^DHCTARI(tar,"P",tarSub),"^",3)
		.....s enddate=$p(^DHCTARI(tar,"P",tarSub),"^",4)
		.....i enddate="" s enddate=99999
		.....q:((+$h<Startdate)||(+$h>=enddate))
		.....s Oneprice=$p(^DHCTARI(tar,"P",tarSub),"^",5)
		....s price=Oneprice+price
		....i price<1 d //处理小数点前的0不显示
		.....s price=0_price
		
		....s count=count+1
		....q:count<start
		....q:count>end
	    ....w $case(count,start:"",:",")
	    ....s tarId=tar
		....d OutPutRow
		
	    i type="POS" d
	    .s link=""
		.f  s link=$o(^DHCAPPOSTAR(link)) q:link=""  d
		..q:+link=0
		..q:'$d(^DHCAPPOSTAR(link))
		..q:$d(^DHCAPPOSTAR(link))=10
		..s pos=$p(^DHCAPPOSTAR(link),"^",1)
		..q:pointer'=pos
		..s tar=$p(^DHCAPPOSTAR(link),"^",2)
		..s TarStart=$p(^DHCAPPOSTAR(link),"^",3)
		..s TarEnd=$p(^DHCAPPOSTAR(link),"^",5)
		..s:TarEnd=0 TarEnd=""   //sufan 2016年7月11日
		..s qty=$p(^DHCAPPOSTAR(link),"^",10)
		..s UpdUser=$p(^DHCAPPOSTAR(link),"^",7)
		..s UpdDate=$p(^DHCAPPOSTAR(link),"^",8)
		..s UpdTime=$p(^DHCAPPOSTAR(link),"^",9)
		..s code=$p(^DHCTARI(tar),"^",1)
		..s desc=$p(^DHCTARI(tar),"^",2)
		..s tarSub=""
		..s price=0
		..f  s tarSub=$o(^DHCTARI(tar,"P",tarSub)) q:tarSub=""  d
		...s hospDr=$p(^DHCTARI(tar,"P",tarSub),"^",16)
		...set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", hospid)
		...q:hospDr'=GroupHospID
		...b ;0-93
		...s startdate=$p(^DHCTARI(tar,"P",tarSub),"^",3)
		...s enddate=$p(^DHCTARI(tar,"P",tarSub),"^",4)
		...i enddate="" s enddate=99999
		...q:((+$h<startdate)||(+$h>=enddate))
		...s Oneprice=$p(^DHCTARI(tar,"P",tarSub),"^",5)
		..s price=Oneprice+price	
		..i price<1 d //处理小数点前的0不显示
		...s price=0_price		

		..s count=count+1
		..q:count<start
		..q:count>end
	    ..w $case(count,start:"",:",")
	    ..s tarId=tar
		..d OutPutRow

		w "],""total"":"_count_"}"
		q ""
OutPutRow
		s tmpObj=##class(web.DHCAPPJsonObject).%New()
	    d tmpObj.Put("TarCode",code)
	    d tmpObj.Put("TarDesc",desc)
	    d tmpObj.Put("Type",type)
	    d tmpObj.Put("Pointer",pointer)
	    d tmpObj.Put("TarPrice",price)
	    d tmpObj.Put("APLTarDr",tar)
	    d tmpObj.Put("TarStart",##class(web.DHCAPPCommonUtil).DateLogicalToHtml(TarStart)) //hxy 2017-03-02 $zd(TarStart,3)
	    d tmpObj.Put("TarEnd",$case(TarEnd,"":"",:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(TarEnd)))  //hxy $zd(TarEnd,3)//sufan 2016年7月11日
	    d tmpObj.Put("ID",link)
	    d tmpObj.Put("PartNum",$g(qty))
	    d tmpObj.Put("UpdDate",$case(+UpdDate,0:0,:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(UpdDate))) //$zd(UpdDate,3)
	    d tmpObj.Put("UpdTime",$case(+UpdTime,0:0,:..%ZT(UpdTime)))
	    i $g(UpdUser)'="" d
	    .d tmpObj.Put("UpdUser",$p(^SSU("SSUSR",UpdUser),"^",2))
		w tmpObj.Json()
}

/// d ##class(web.DHCAPPPosLinkTar).QueryTar()
ClassMethod QueryTar(rows = 10, page = 1, q = "", HospID = "")
{
	
		s start=(page-1)*rows+1
	    s end=page*rows
	    if ((HospID="")&&($d(%session))) s HospID=%session.Get("LOGON.HOSPID")
	    s count=0
	    w "{""rows"":["
		s tar=""
		f  s tar=$o(^DHCTARI(tar)) q:tar=""  d
		.q:+tar=0
		.q:'$d(^DHCTARI(tar))
		.q:$d(^DHCTARI(tar))=10
		.s code=$p(^DHCTARI(tar),"^",1)
		.s desc=$p(^DHCTARI(tar),"^",2)
		.Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem",tar,HospID)="N"
		.s activeFlag=$p(^DHCTARI(tar),"^",7)		///sufan 2017-04-11 过滤过期的、不可用的、开始日期在当前日期之后的收费项目
		.q:activeFlag'="Y"
		.s startDate=$p(^DHCTARI(tar),"^",11)
		.q:startDate>$h			
		.s endDate=$p(^DHCTARI(tar),"^",12)    
		.q:(endDate'="")&(endDate<+$h)
		.s tarSub=""
		.s price=0
		.f  s tarSub=$o(^DHCTARI(tar,"P",tarSub)) q:tarSub=""  d
		..s hospDr=$p(^DHCTARI(tar,"P",tarSub),"^",16)
		..set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", HospID)
		..q:hospDr'=GroupHospID
		..s startdate=$p(^DHCTARI(tar,"P",tarSub),"^",3)
		..s enddate=$p(^DHCTARI(tar,"P",tarSub),"^",4)
		..i enddate="" s enddate=99999
		..q:((+$h<startdate)||(+$h>=enddate))
		..s Oneprice=$p(^DHCTARI(tar,"P",tarSub),"^",5)
		.s price=Oneprice+price	
		.i price<1 d //处理小数点前的0不显示
		..s price=0_price
		.s AlasRowid="",Alasflag=0
		.f  s AlasRowid=$o(^DHCTARAL("A",tar,AlasRowid)) q:AlasRowid=""  d
		..s AlascDesc=$P(^DHCTARAL(AlasRowid),"^",3)
		..if ((q'="")&&(AlascDesc[$zcvt(q,"U"))) s Alasflag=1
		.q:((q'="")&(desc'[q)&(Alasflag=0))
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",")
	    .s tarId=tar
	    .s tmpObj=##class(web.DHCAPPJsonObject).%New()
	    .d tmpObj.Put("code",code)
	    .d tmpObj.Put("desc",desc)
	    .d tmpObj.Put("price",price)
	    .d tmpObj.Put("tarId",tarId)
		.w tmpObj.Json()
		w "],""total"":"_count_"}"
		q ""
}

// 保存位置和收费项关联

/// 	^DHCAPPOSTAR(0,"Pos",{APL_Pos_Dr},{APL_Tar_Dr},{APL_StartDate},{APL_RowId})
ClassMethod savePos(str)
{
  	
	 s ID=$p(str,"^",1)
	 s tar=$p(str,"^",2)
	 s poniter=$p(str,"^",4)	
	 s PartNum=$p(str,"^",7)
	 //s Discount=$p(str,"^",8)
	 s TarStart=$p(str,"^",8)
	 s TarEnd=$p(str,"^",9)	 
	 
	 i +ID=0 d
	 .s obj=##class(User.DHCAppPosLinkTar).%New()
	 e  d
	 .s obj=##class(User.DHCAppPosLinkTar).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.APLPosDr=##class(User.DHCAppPosition).%OpenId(poniter)
	 s obj.APLTarDr=##class(User.DHCTarItem).%OpenId(tar)
	 s obj.APLStartDate=$case(+TarStart,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart)) //hxy $zdh(TarStart,3)
	 s obj.APLEndDate=$case(+TarEnd,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd)) //hxy $zdh(TarEnd,3)
	 s obj.APLUpdDate=..%SysDate()
	 s obj.APLUpdTime=..%SysTime()
	 s obj.APLUpdUserDr=##class(User.SSUser).%OpenId(%session.Get("LOGON.USERID"))
	 s obj.APLQty=PartNum
	 s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

// 保存后执行方法和收费项关联

// w ##class(web.DHCAPPPosLinkTar).saveMed("0^12^MED^2^A00N003^钠石灰[500g]^123^31^2016-05-18^2016-05-04^10.5")

/// ^DHCAPMEDTAR(0,"Med",{AML_Disp_Dr},{AML_Tar_Dr},{AML_StartDate},{AML_RowId})
ClassMethod saveMed(str)
{
  		 
	 s ID=$p(str,"^",1)
	 s tar=$p(str,"^",2)
	 s poniter=$p(str,"^",4)	
	 s PartNum=$p(str,"^",7)
	 //s Discount=$p(str,"^",8)
	 s TarStart=$p(str,"^",8)
	 s TarEnd=$p(str,"^",9)

	 i +ID=0 d
	 .s obj=##class(User.DHCAppMedLinkTar).%New()
	 .
	 e  d
	 .s obj=##class(User.DHCAppMedLinkTar).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.AMLDispDr=##class(User.DHCAppDispMedthod).%OpenId(poniter)
	 s obj.AMLTarDr=##class(User.DHCTarItem).%OpenId(tar)
	 s obj.AMLStartDate=$case(+TarStart,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart)) //hxy  $zdh(TarStart,3)
	 s obj.AMLEndDate=$case(+TarEnd,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd)) //hxy  $zdh(TarEnd,3)
	 s obj.AMLUpdDate=..%SysDate()
	 s obj.AMLUpdTime=..%SysTime()
	 s:$d(%session) obj.AMLUpdUserDr=##class(User.SSUser).%OpenId(%session.Get("LOGON.USERID"))
	 s obj.AMLQty=PartNum
	 s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

/// d ##class(web.DHCAPPPosLinkTar).save("0^7806^MED^4^1204000021^^1^2020-05-14^^1.5^0^0^0")
/// w ##class(web.DHCAPPPosLinkTar).save("0^7806^MED^4^1204000021^^1^2020-05-14^^1.5^0^0^0")
ClassMethod save(params)
{
    s ^ZXZX=params
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
	.s ret=..CheckRepeatDeal(str)  //增加判断（防止重复添加）
	.q:ret'=0 
	.s ret=..CompareTime(str)  //结束时间是否大于开始时间
	.q:ret'=0
  	.s:$p(str,"^",3)="POS" ret=..savePos(str)
	.s:$p(str,"^",3)="MED" ret=..saveMed(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// Creator:    qunianpeng
/// CreateDate:  2016-06-27
/// Description: 保存或者修改部位字典表[检查代码是否重复]
/// Table:		 DHC_AppMedLinkTar，DHC_AppPosLinkTar
/// Return: 	 无重复 0,重复 -10
/// Others:		 w ##class(web.DHCAPPPosLinkTar).CheckRepeatDeal()
ClassMethod CheckRepeatDeal(str)
{

	s ID=$p(str,"^",1)
	s tar=$p(str,"^",2)
	s type=$p(str,"^",3)
	s poniter=$p(str,"^",4)	

	// 新记录  POS
	q:(ID=0)&(type="POS")&($d(^DHCAPPOSTAR(0,"Pos",poniter,tar))) "-10"
	//MED
	q:(ID=0)&(type="MED")&($d(^DHCAPMEDTAR(0,"Med",poniter,tar))) "-10"
	q:ID=0 0

	s Postar="",Medtar=""
	/// 修改记录
	i (type="POS") d
	.s Postar=$p($g(^DHCAPPOSTAR(ID)),"^",2)    //取当前修改行ID对应的描述  POS
	i (type="MED") d
	.s Medtar=$p($g(^DHCAPMEDTAR(ID)),"^",2)
	q:(tar'=Postar)&($d(^DHCAPPOSTAR(0,"Pos",poniter,tar))) "-10" //Pos
	q:(tar'=Medtar)&($d(^DHCAPMEDTAR(0,"Med",poniter,tar))) "-10" //Med
	q 0
}

/// Creator:     CongYue
/// CreateDate:  2016-06-28
/// Description: 收费项目维护[检查结束时间是否大于开始时间]
/// Table:		 DHC_AppMedLinkTar，DHC_AppPosLinkTar
/// Return: 	 是 0,否 非0
/// Others:		 w ##class(web.DHCAPPPosLinkTar).CompareTime("^^^^^^^2016-01-05^")
ClassMethod CompareTime(str)
{
	
	s TarStart=$p(str,"^",8)
	s TarEnd=$p(str,"^",9)
	s flag=0	
	s:TarStart'="" TarStart=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart) //hxy $zdh(TarStart,3)
	s:(TarEnd'="")&(TarEnd'=0) TarEnd=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd) //hxy $zdh(TarEnd,3)
	s:(TarEnd>0)&(TarStart>TarEnd) flag=-11
	i TarStart<+$h  d   //2017-07-13 sufan 增加结束日期不能早于今天的判断
	.s:(TarEnd>0)&(TarEnd<+$h) flag=-12
	q flag
}

}
