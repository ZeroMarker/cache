Import SQLUser

Class web.DHCRisUnRegisterPatient Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 14;

/*
/// s Code=##class(web.DHCRisUnRegisterPatient).UnRegister("BC20080616-004","","780","ris001","","1")
ClassMethod UnRegister(StudyNo, Reason, LocDR, usercode, price, ckStopOrder, OrditemRowid As %String = "")
{
	s date1=+$h,time1=$p($h,",",2)
	s rrowid=""
	s OEordDr="",userid="",retCall=""
	
	s ^tts("Reg")=StudyNo_"^"_Reason_"^"_LocDR_"^"_usercode_"^"_price_"^"_ckStopOrder_"^"_OrditemRowid
Trans
	Set $ZT="ERROR"	

	TSTART
	
	i usercode'="" s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	
	s count=$l(OrditemRowid,"@")
	f i=1:1:count d
	.s perOrditemRowid=$p(OrditemRowid,"@",i)
	.s RecLocdr=$p(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3),"^",6)
	.s retCall=..DelCallQuenue(perOrditemRowid)
	.s regrowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,0))
	.q:regrowid=""   
	.&sql(delete from OE_OrdResult where RES_ParRef=:perOrditemRowid)
	.i ckStopOrder d
	..s ret=##class(web.DHCRisCommFunctionEx).StopOrderItem(perOrditemRowid,userid) 
	.else  d
	..;s ret=##class(web.DHCRisCommFunctionEx).VeriedOrditem(perOrditemRowid,userid)
    .if Reason'="" d
    ..&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    ..i (rrowid="") d 
    ...&sql(insert into DHCRB_ReturnReason (DBRR_Reason)values(:Reason))
    ...&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    .&sql(insert into  DHCRB_ReturnFee(DRBR_Reason_DR,DRBR_Loc_DR,DRBR_OEORDITEM_DR,DRBR_DATE,DRBR_Time,DRBR_USSER_DR,DRBR_TotalPrice)
    							values (:rrowid,:LocDR,:perOrditemRowid,:date1,:time1,:userid,:price))
    .&sql(delete from  DHCRB_RegInfo where RAR_Rowid=:regrowid)
    .s Now=$zd(+$H,8)_$zt($p($h,",",2))
    .s SQLCODE=##class(RISService.TrakRISService).ORMO01OC(perOrditemRowid, "CA", Now,userid)
    .s SvrGroup="",BKInfo=""
    .s SvrGroup=##class(web.DHCRisCommFunctionEx).NoBookedSvrGroup(perOrditemRowid)
    .i SvrGroup="Y" s BKInfo=##class(web.DHCRisAppointmentDo).DeleteBookInfo(perOrditemRowid)
    .i BKInfo'="" s SQLCODE=$p(BKInfo,"^",1)
   
    I SQLCODE TRollBack  Quit SQLCODE
    TCOMMIT
 
    if ($g(^DHCRisCheckFee)="Y")
	{
		s count=$l(OrditemRowid,"@")
		f i=1:1:count d
		.s perOrditemRowid=$p(OrditemRowid,"@",i)
		.if perOrditemRowid'="" d
		..s oeordrowid=$p(perOrditemRowid,"||",1)
    	..s paadmdr=$p(^OEORD(oeordrowid),"^",1) 
    	..s rtn=##Class(web.UDHCJFBILL).BILLN(paadmdr,userid,perOrditemRowid)
    }
     
    do ##class(web.DHCRisSendToRis4Set).SendUnRegtoRIS4(StudyNo,RecLocdr)
   
	q SQLCODE
	
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit SQLCODE
}

*/
/// w ##class(web.DHCRisUnRegisterPatient).UnRegister("CTR-209^^323^ris^^0^123||563$237,14")
ClassMethod UnRegister(UnRegisterlist As %String)
{
	;s ^TempDHCRis("UnRegister")=UnRegisterlist
	
	S StudyNo=$P(UnRegisterlist,"^",1)
	
	s usercode=$P(UnRegisterlist,"^",4)
	
	s perOrditemRowid=$P(UnRegisterlist,"^",7)
	s Now=$zd(+$H,8)_$zt($p($h,",",2))
   

	s (userid)=""
Trans
	Set $ZT="ERROR"	
    s SQLCODE=200
	TSTART
	i usercode'="" 
	{
		s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	}
	
	
	s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,0))
	i studydescrowid'="" 
	{
		s SQLCODE=-999
	}
	else 
	{
		s reginfoDr=""
		for
		{
			s reginfoDr=$o(^DHCPACRegInfoi("StudyNo",StudyNo,reginfoDr) )
			q:(reginfoDr="")
			b //001
			s orderRowid=$p(^DHCPACRegInfo(reginfoDr),"^",11)
			s bodyList=""
			s childsub=""
			for       //取部位
			{
				s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,reginfoDr,childsub))
				q:(childsub="")
				s bodyRowid=$p(^DHCPACRegInfoBD("BODYPARTS",0,reginfoDr,childsub),"^",1)
				if (bodyRowid'="")
				{
					if (bodyList="")
					{
						s bodyList=bodyRowid
					}
					else
					{
						s bodyList=bodyList_","_bodyRowid
					}
				}
			}
			if (bodyList'="")
			{
				s orderRowid=orderRowid_"^"_bodyList
			}
			//按部位取消登记
		
			s SQLCODE=##class(RISService.TrakRISService).ORMO01OC(orderRowid, "CA", Now,usercode)  //userid)
				
		}
		b //3
		&sql(delete from DHCRB_RegInfo where RAR_StudyNo=:StudyNo)
		;.s SQLCODE=##class(RISService.TrakRISService).ORMO01OC(perOrditemRowid, "CA", Now,userid)
	}
	I SQLCODE TRollBack  Quit SQLCODE
    TCOMMIT
	
     
    //do ##class(web.DHCRisSendToRis4Set).SendUnRegtoRIS4(StudyNo,RecLocdr)
   	
	q SQLCODE
	
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	b //01
 	TROLLBACK
 	s ^DHCRisTemp("Unregister","error")=ErrorMsg
 	lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit SQLCODE
}

// s ret=##class(web.DHCRisUnRegisterPatient).GetItemName("378||6$8022@393||3$8022")

ClassMethod GetItemName(Mutiorditmrowid As %String)
{
	s ^tmp("pan2016")=Mutiorditmrowid
	s MutiOrdName=""
	s TotalPrice=0
	q:Mutiorditmrowid=""
	s count=$l(Mutiorditmrowid,"@")
	for i=1:1:count d
	.s orditmrowidbody=$p(Mutiorditmrowid,"@",i)
	.s orditmrowid=$p(orditmrowidbody,"$",1) 
	.s bodylist=$p(orditmrowidbody,"$",2) 
	.s OErowid=$p(orditmrowid,"||",1)
	.s Childsub=$p(orditmrowid,"||",2)
	.s ItemMasterDr=$p(^OEORD(OErowid,"I",Childsub,1),"^",2)
	.//^ARCIM({ARCIM_Subscript},{ARCIM_Version})    
	.s Qty=$p(^OEORD(OErowid,"I",Childsub,1),"^",18)
	.i Qty="" s Qty=1
	
	.s subscript=$p(ItemMasterDr,"||",1)
	.s version=$p(ItemMasterDr,"||",2)
	.s ItemName=$p(^ARCIM(subscript,version,1),"^",2)
	.i MutiOrdName="" s MutiOrdName=ItemName
	.else  s MutiOrdName=MutiOrdName_","_ItemName 
	.s arcimid=subscript_"||"_version
	
	.s paadmdr=$p(^OEORD(OErowid),"^",1)
	.s SttDate=$p(^OEORD(OErowid,"I",Childsub,1),"^",9)  
	.s arcimid=$p(^OEORD(OErowid,"I",Childsub,1),"^",2)
	.s OEPrice=$p($g(^OEORD(OErowid,"I",Childsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	.s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	.s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	.s price=$p(priceinfo,"^",1)
	.s Num=$p(^OEORD(OErowid,"I",Childsub,1),"^",12)
	.s perPrice=price*Num
	.s TotalPrice=TotalPrice+perPrice
		
	q MutiOrdName_"^"_TotalPrice
}

ClassMethod GetOrdDate(OrditmRowid)
{
	s OrditmRowidbody=$p(OrditmRowid,"@",1)
	s OrditmRowid=$p(OrditmRowidbody,"$",1)
	q:OrditmRowid="" "" 
	s Oeodrowid=$p(OrditmRowid,"||",1)
    s OeodChild=$p(OrditmRowid,"||",2)
    s ordate=$p(^OEORD(Oeodrowid,"I",OeodChild,3),"^",7)
    i ordate'="" s ordate=##class(websys.Conversions).DateLogicalToHtml(ordate)  ;$zd(ordate,3)
    q ordate
}

/// do ##class(web.DHCRisUnRegisterPatient).DelCallQuenue("20017||3876")
ClassMethod DelCallQuenue(OEordItemDR As %String) As %String
{
   
    s ret="",RARRowid="",StudyNo=""
	q:(OEordItemDR="") ret
	
	&sql(select RAR_Rowid into:RARRowid from DHCRB_RegInfo where RAR_OEORI_DR=:OEordItemDR)
	i (RARRowid'="")
	{
		s StudyNo=$p($g(^DHCPACRegInfo(RARRowid)),"^",2)
		i StudyNo'="" d
		.&sql(delete from DHCRB_CallQueue where DRCQ_StudyNo=:StudyNo)
		.s ret=SQLCODE
	}
	
	q ret
}

/// w ##class(web.DHCRisUnRegisterPatient).UnRegisterNow("CTR-477^^323^ris^^0^5||209$13")
ClassMethod UnRegisterNow(UnRegisterlist As %String = "")
{
	s ^TempDHCRis("UnRegister")=UnRegisterlist
	
	S StudyNo=$P(UnRegisterlist,"^",1)
	s Reason=$P(UnRegisterlist,"^",2)
	s LocDR=$P(UnRegisterlist,"^",3)
	s usercode=$P(UnRegisterlist,"^",4)
	s OrditemRowid=$P(UnRegisterlist,"^",7)
	s Now=$zd(+$H,8)_$zt($p($h,",",2))
	
	
	s date1=+$h,time1=$p($h,",",2)
	s (userid,rrowid)=""

	Set $ZT="ERRORNew"
	
	//如果病人已经出院或最终结算，不能取消登记
	s orderListBodyJudge=$p(OrditemRowid,"@",1)
    s orderRowidJudge=$p(orderListBodyJudge,"$",1)
    s GetPaadmID=$p(^OEORD($p(orderRowidJudge,"||",1)),"^",1)
	    
	i (##class(websys.Conversions).IsValidMethodName("web.DHCDischargeHistory","GetCurrentDischargeStatus") )
    {
	    s disChargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(GetPaadmID)
	    q:((disChargeStatus="F")||(disChargeStatus="T")) "-10003"
    }
    else
    {
	    q:($p(^PAADM(GetPaadmID),"^",17)'="")&&(($p(^PAADM(GetPaadmID),"^",2))="I") "-10003"
    }
    
	if Reason'=""
	{
    	&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    	i (rrowid="")
    	{
	    	b //02
	    	&sql(insert into DHCRB_ReturnReason (DBRR_Reason)values(:Reason))
	    	&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    	}
	}	
	b //01
    s SQLCODE=200
    
	TSTART
	i usercode'="" 
	{
		s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	}
	
	s countOrder=$l(OrditemRowid,"@")
	s bodyInsert=""
	f ii=1:1:countOrder d
	.;w !,ii
	.s OrditemBodyList=$p(OrditemRowid,"@",ii)
	.s perOrditemRowid=$p(OrditemBodyList,"$",1)
	.s BodyList=$p(OrditemBodyList,"$",2)
	.s RecLocdr=$p(^OEORD($p(perOrditemRowid,"||",1),"I",$p(perOrditemRowid,"||",2),3),"^",6)
	.;w !,perOrditemRowid_"**"_BodyList
	.s regrowid="" f  s regrowid=$o(^DHCPACRegInfoi("OEORI",perOrditemRowid,regrowid)) q:regrowid=""  d
	..;w !,"regrowid="_regrowid
	..i BodyList'="" d 
	...s RRBChildSub="" f  s RRBChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,RRBChildSub)) q:RRBChildSub=""  d
	....s RRBBodyPartDR=$p(^DHCPACRegInfoBD("BODYPARTS",0,regrowid,RRBChildSub),"^",1)
	....s count=$l(BodyList,",")
	....f L=1:1:count d
	.....s bodyCode=$p(BodyList,",",L)
	.....s bodyInsert=bodyInsert_"-"_bodyCode
	.....s bWrite=0
    .....&sql(select count(*) into:bWrite from DHCRB_RegInfo_BodyParts where (RRB_ParRef=:regrowid))
    .....i RRBBodyPartDR=bodyCode d
    ......i bWrite=1 d
    .......s StudyNoGet=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
	.......&sql(delete from  DHCRB_RegInfo_BodyParts where RRB_ParRef=:regrowid and RRB_BodyPart_DR=:RRBBodyPartDR)
	.......&sql(delete from  DHCRB_RegInfo where RAR_Rowid=:regrowid)
	......e  d
	.......s StudyNoGet=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
	.......&sql(delete from  DHCRB_RegInfo_BodyParts where RRB_ParRef=:regrowid and RRB_BodyPart_DR=:bodyCode) 
	..e  d
	...s StudyNoGet=$p($g(^DHCPACRegInfo(regrowid)),"^",2)
	...&sql(delete from  DHCRB_RegInfo where RAR_Rowid=:regrowid)
	.i BodyList'="" s OrditemRowidBodyList=perOrditemRowid_"^"_BodyList
	.e  s OrditemRowidBodyList=perOrditemRowid
	.;s SQLCODE=##class(RISService.TrakRISService).ORMO01OC(OrditemRowidBodyList, "CA", Now,userid)
	.s unRegisterlistOC(OrditemRowidBodyList)=$lb(OrditemRowidBodyList,Now,userid)
    .&sql(insert into  DHCRB_ReturnFee(DRBR_Reason_DR,DRBR_Loc_DR,DRBR_OEORDITEM_DR,DRBR_DATE,DRBR_Time,DRBR_USSER_DR)
    							values (:rrowid,:LocDR,:perOrditemRowid,:date1,:time1,:userid))
	.b //02
	.s bookDetailRowid=##class(web.DHCRisResourceApptSchudle).getBookDetailID(perOrditemRowid_"$"_BodyList)
	.i bookDetailRowid'=""  d
	..s bookNo=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",6)
	..s bookNoList(bookNo)=""
	.e  d
	..s ret=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(StudyNo,perOrditemRowid,BodyList,"Y")
	..//s ^DHCRisTemp("unRegisterToApp",perOrditemRowid,BodyList)=$lb(StudyNo,perOrditemRowid,BodyList,"Y",ret)

	B //03
	
    ;需要取消登记到预约
    if ($d(bookNoList))
    {
	    //判断还有没有登记的记录
	    s regRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNoGet,""))
	    if (regRowid="")
	    {
		    s ret1=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(StudyNoGet,"","","Y")
	    	s bookNoGet="" 
	    	for 
		    {
			    s bookNoGet=$o(bookNoList(bookNoGet))
			    q:(bookNoGet="")
			    s ret1=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNoGet,"","","Y")
			    s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(bookNoGet,"B")
		    }
	    }
	    else
	    {
		    s bookNoGet="" 
		    for 
		    {
			    s bookNoGet=$o(bookNoList(bookNoGet))
			    q:(bookNoGet="")
			    s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(bookNoGet,"B")
			    s ^DHCRisTemp("unRegisterToBook",bookNoGet)=$lb(bookNoGet,"B",ret)
			    ;判断是否有登记记录
			    B //04
			    s detailRowid="" 
			    for  
			    {
				    s detailRowid=$o(^DHCRBCResSchduleDetaili("StudyNo",bookNoGet,detailRowid)) 
				    q:(detailRowid="")
				    s orderItemId=$p(^DHCRBCResSchduleDetail("Detail",detailRowid),"^",1)
				    b //05
				    s hasBody=""
			    	s bodyRowidGet="" 
			    	for
			    	{
				    	s bodyRowidGet=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",detailRowid,bodyRowidGet))
				    	q:(bodyRowidGet="")
				    	s hasBody="Y"
				    	s regRowid1=##class(web.DHCRisRegisterPatientDoEx).getRegRowid(orderItemId,bodyRowidGet)
				    	if (regRowid1'="")
				    	{
				    		s studyNo1=$p($g(^DHCPACRegInfo(regRowid1)),"^",2)
				    		s ret1=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNoGet,orderItemId,bodyRowidGet,"Y")
							s ^DHCRisTemp("unRegisterBookToApp",orderItemId,bodyRowidGet)=$lb(bookNoGet,orderItemId,bodyRowidGet,"Y",ret1)
				    		s ret2=##class(RISService.InvokeRISService).InsertStudyInfoPACS(studyNo1,"A")
				    		s ^DHCRisTemp("unRegisterReg",studyNo1)=$lb(studyNo1,ret2)
				    		b //07
				    	}/*
				    	else
				    	{
					    	//s studyNo1=$p($g(^DHCPACRegInfo(regRowid1)),"^",2)
				    		s ret1=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(StudyNoGet,orderItemId,bodyRowidGet)
				    		s ^DHCRisTemp("unRegisterReg",studyNo1)=$lb(StudyNoGet,ret1)
				    	}*/
				    	
			    	}
			    	//不带部位的
			    	if (hasBody="")
			    	{
				    	s regRowid1=##class(web.DHCRisRegisterPatientDoEx).getRegRowid(orderItemId,"")
				    	if (regRowid1'="")
				    	{
				    		s studyNo1=$p($g(^DHCPACRegInfo(regRowid1)),"^",2)
				    		s ret1=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNoGet,orderItemId,"","Y")
							s ^DHCRisTemp("unRegisterBookToApp",orderItemId,"nobody")=$lb(bookNoGet,orderItemId,"","Y",ret1)
				    		s ret2=##class(RISService.InvokeRISService).InsertStudyInfoPACS(studyNo1,"A")
				    		s ^DHCRisTemp("unRegisterReg",studyNo1)=$lb(studyNo1,ret2)
				    	}
				    	/*
				    	else
				    	{
					    	//s studyNo1=$p($g(^DHCPACRegInfo(regRowid1)),"^",2)
				    		s ret1=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(StudyNoGet,orderItemId,"")
				    		s ^DHCRisTemp("unRegisterReg",studyNo1)=$lb(StudyNoGet,ret1)
				    	}*/
			    	}
			    }
		    }
	    }
    }
	
	
	I SQLCODE TRollBack  Quit SQLCODE
	

	s success="Y"
	s orderGet="" f  s orderGet=$o(unRegisterlistOC(orderGet)) q:(orderGet="")  d
    .s ret=##class(RISService.TrakRISService).ORMO01OC(orderGet, "CA", Now,usercode) //   userid)
    .if ret'="0" s success="N"
    
    k unRegisterlistOC
    
    if (success="N")
    {
	    TRollback
		
		q SQLCODE
    }
    
    TCOMMIT
	
	//传状态信息
	if ($g(userid))'=""
	{
		s userName=$p($g(^SSU("SSUSR",userid)),"^",2)
	}
  	
   
   	//##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus("59||35","222",studyNo,"SC",$g(operateDocDr),$g(userName))
	s Count=$l(OrditemRowid,"@")
    for num=1:1:Count 
    {
      s perOrditemRowid=$p(OrditemRowid,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyListNoBook=""
	      s bodyLength=$l(bodyList,",")
	      s bodyDescList=""
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      
		      if (bodyRowid'="")
		      {
			      s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			      if bodyDescList= "" s bodyDescList=bodyDesc
			      else  s bodyDescList=bodyDescList_"@@"_bodyDesc			      
		      }
	      }
	      
	      s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,bodyDescList,StudyNoGet,"CSC",$g(userid),$g(userName))
		  s ^TempDHCRis("postStatus",perOrditemRowid,bodyDescList,$zd(+$h,3),$zt($p($h,",",2),1))=StudyNoGet_"^"_"CSC"_"^"_$g(userid)_"^"_$g(userName)_"^"_$g(ret)
	      
      }
      else
      {
      	  s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,"",StudyNoGet,"CSC",$g(userid),$g(userName))
		  s ^TempDHCRis("postStatus",perOrditemRowid,"nobody",$zd(+$h,3),$zt($p($h,",",2),1))=StudyNoGet_"^"_"CSC"_"^"_$g(userid)_"^"_$g(userName)_"^"_$g(ret)

      }
      
    }
    //do ##class(web.DHCRisSendToRis4Set).SendUnRegtoRIS4(StudyNo,RecLocdr)
   	
	q SQLCODE
	
ERRORNew	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	b //error
 	TROLLBACK
 	//lock -(^DHCRisTMPReg)     		       //回滚事务
 	Quit "-1"
}

}
