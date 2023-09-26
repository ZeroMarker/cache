Import SQLUser

Class web.DHCRisRejectApplication Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCRisRejectApplication).GetPatientInfo("20019")
ClassMethod GetPatientInfo(paadmrowid)
{
	s DOB="",strAge="",wardname="",bedname=""
	s PAPMIdr=$p(^PAADM(paadmrowid),"^",1)
	s patname=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	
	s Sexdr=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	i Sexdr'="" s Sex=$p(^CT("SEX",Sexdr),"^",2)
	s NO=$p(^PAPER(PAPMIdr,"PAT",1),"^",1)
	s DOB=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
	i DOB'="" d 
	.s DOB=$zd(DOB,3)
	.s strToday=$ZD(+$h,3)
    .s strAge=##class(web.DHCRisWorkBenchDo).CalAge(DOB,strToday)
    s WardDr=$p(^PAADM(paadmrowid),"^",70)
    i WardDr'=""  s wardname=$p(^PAWARD(WardDr),"^",2)
    s beddr=$p(^PAADM(paadmrowid),"^",73)
    i beddr'=""  d 
     .s wardrowid=$p(beddr,"||",1)
     .s bedchildsub=$p(beddr,"||",2)
     .s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
	q patname_"^"_Sex_"^"_NO_"^"_DOB_"^"_$g(strAge)_"^"_wardname_"^"_bedname
}

/// w ##class(web.DHCRisRejectApplication).GetOrdItemInfo("20017||3863")
ClassMethod GetOrdItemInfo(OeOrditemID)
{
	s strDate="",strTime="",strItemName="",arcimid="",strOrderName="",requestdoc=""
	q:(OeOrditemID="") "^^"
	
	s OrderRowid =$p($g(OeOrditemID),"||",1)
	s itemsub=$p($g(OeOrditemID),"||",2)
	i (OrderRowid'="")&(itemsub'="") d
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ReqDocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,7)),"^",1) ;下医嘱医生
    .;i ssusrdr'="" s requestdoc=$p($g(^SSU("SSUSR",ssusrdr)),"^",2)
    .q:'$d(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1))
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2) 
	.s AppRowid=$o(^DHCRBAppOrdi(0,OeOrditemID,0))
	.i AppRowid'="" d
	..s Date=$p($g(^DHCRBApp("Bill",AppRowid)),"^",1) ;申请日期
    ..i Date'="" s strDate=$zd(Date,3)
	..s Time=$p($g(^DHCRBApp("Bill",AppRowid)),"^",8) ;申请时间
    ..i Time'="" s strTime=$zt(Time,3)
    
    s Info=strOrderName_"^"_strDate_"^"_strTime_"^"_ReqDocdr
    
    q Info
}

ClassMethod RejectApp(Info As %String)
{
	s OeOrditemID=$p($g(Info),"^",1)
	s LocDr=$p($g(Info),"^",2)
	s usercode=$p($g(Info),"^",3)
	s Reason=$p($g(Info),"^",4)
	s Paadmdr=$p($g(Info),"^",5)
	s RJDate=+$h
	s RJTime=$p($h,",",2)
	
	q:(OeOrditemID="") "-1"
	
	s OrderRowid =$p($g(OeOrditemID),"||",1)
	s itemsub=$p($g(OeOrditemID),"||",2)
	s (UserName,ResStatDR)=""
	s Status="RJ"
	
	i usercode'="" s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	i userid'=""
	{
		s UserName= $p($g(^SSU("SSUSR",userid)),"^",2)
	}
	
	s ResStatDR=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(Status),""),-1)
	s RejAppInfo=Paadmdr_"^"_LocDr_"^"_$g(userid)_"^"_Reason_"^"_RJDate_"^"_RJTime
	
	s rowid=""
 	&sql(select DRA_RowID into :rowid from DHCRB_RejectApplication where DRA_OeordItm_DR =:OeOrditemID)
	i (rowid="") d
	 .&sql(insert into DHCRB_RejectApplication(DRA_OeordItm_DR)values(:OeOrditemID))
	 .s srowid=$p(%ROWID,$c(1))
     .i srowid'="" d
     ..s ^DHCRBReject("Reject",srowid,OeOrditemID)=RejAppInfo
     ..s $p(^OEORD(OrderRowid,"I",itemsub,1),"^",5)="RJ"
     ..Kill PLIST
     ..s PLIST(0)=OeOrditemID  
	 ..s PLIST(3)=ResStatDR 
	 ..s PLIST(4)=UserName
	 ..s PLIST(5)=userid 
	 ..s PLIST(7)=+RJDate
     ..s PLIST(9)=+RJTime
     ..&sql( INSERT INTO SQLUSER.OE_OrdResult VALUES :PLIST())
	e  d
	.&sql(update DHCRB_RejectApplication(DRA_OeordItm_DR)values(:OeOrditemID) where DRA_RowID=:rowid)
	.s srowid=$p($g(%ROWID),$c(1))
    .i srowid'="" d
    ..s ^DHCRBReject("Reject",srowid,OeOrditemID)=RejAppInfo
    //s ^dhcrisrejectappght=OeOrditemID
    d ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OeOrditemID,usercode)
	q SQLCODE
}

/// 在发送申请时判断是被拒绝的申请 是-删除，否-返回0  
/// sunyi 2011-12-31
/// w ##class(web.DHCRisRejectApplication).IsDelRejAppData("20017||3863")
ClassMethod IsDelRejAppData(OeOrditemID As %String)
{
	q:(OeOrditemID="") "-1"
	
	s OEorditemID=$p(OeOrditemID,"@",1)
	s rowid=""
	
 	s rowid=$o(^DHCRBRejecti("OeordDR",OeOrditemID,0))
	
    i (rowid'="")
    {
        k ^DHCRBReject("Reject",rowid,OeOrditemID)
        &sql(Delete from DHCRB_RejectApplication where DRA_RowID = :rowid) 
        
        q SQLCODE 
    }
   
    q 0
}

/// 查询拒绝申请信息
/// sunyi 2012-01-03
/// w ##class(web.DHCRisRejectApplication).QueryRejAppInfo("20017||3863")
ClassMethod QueryRejAppInfo(OeOrditemID As %String)
{
	q:(OeOrditemID="") ""
	s rowid="",RejAppInfo="",LocName="",User="",Info=""
	
	s rowid=$o(^DHCRBRejecti("OeordDR",OeOrditemID,0))
	i (rowid'="")
	{
	   s RejAppInfo=$g(^DHCRBReject("Reject",rowid,OeOrditemID))
	   i RejAppInfo'="" d
	   .s LocDr=$p($g(RejAppInfo),"^",2)
	   .s userid=$p($g(RejAppInfo),"^",3)
	   .s Reason=$p($g(RejAppInfo),"^",4)
	   .s RJDate=$p($g(RejAppInfo),"^",5)
	   .s RJTime=$p($g(RejAppInfo),"^",6)
	   .i LocDr'="" s LocName=$p($g(^CTLOC(LocDr)),"^",2)
	   .i userid'="" s User=$p($g(^SSU("SSUSR",userid)),"^",2)
	   .i RJDate'="" s RJDate=$zd(RJDate,3)
	   .i RJTime'="" s RJTime=$zt(RJTime,3)
	   s Info=OeOrditemID_"^"_LocName_"^"_User_"^"_Reason_"^"_$g(RJDate)_"^"_$g(RJTime)
	}
	
	q Info
}

/// Description: 发送一条消息给某个用户
/// Table ss_message ss_messagrecipient
/// Input   message： 要发的消息 id： ss_user表id
/// Return 0 发送失败 1 发送成功
ClassMethod SendRejApp(Info As %String)
{
	s Reason=$p($g(Info),"^",1)
	s ReqDocdr=$p($g(Info),"^",2)
	
	s ret=##class(web.SSMessage).InsertMessageToUser(Reason,ReqDocdr)
	i (ret=1)
	{
		q 0
	}
	else
	{
		q "-1"
	}
}

}
