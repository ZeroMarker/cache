Import SQLUser

Class web.DHCPE.LabNo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SetPlacerNo(userId, oeoreId, placerNo, clearFlag = "N") As %String
{
	//新增参数 userId,061113
	//置检验瓶号
	q:$g(oeoreId)="" "医嘱不能为空!"
	q:$g(placerNo)="" "瓶号不能为空!"
	
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub
    
    s EpisodeID=+^OEORD(oeordId)
    q:EpisodeID=0 "医嘱未关联病人就诊!"
    s admType=$p(^PAADM(EpisodeID),"^",2)
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    i admType'="I",oeoriBilled'="P" q "未收费医嘱!"
	
	i ($d(^OEORDi(0,"PlacerNo",placerNo))>2)&(clearFlag'="Y") q "已有该瓶号!"
	i (placerNo'=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36))&(clearFlag="Y") q "无此瓶号!"
	i ($d(^OEORDi(0,"PlacerNo",placerNo))<2)&(clearFlag="Y") q 0
	s oriLabEpisodeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)  ;OEORI_LabEpisodeNo
	i oriLabEpisodeNo="" q "不是检验医嘱!"

	//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR  //ypz 061113
    //s ordStatDesc=$p($g(^OEC("OSTAT",+ordStatId)),"^",2) //ypz 061113
    //i ordStatDesc["执行" q "医嘱状态为执行,不能置条码!" //ypz 061113
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
    i ordStatCode="D" q "医嘱状态为停止,不能置条码!"
    i ordStatCode="E" q "医嘱状态为执行,不能置条码!"
    
    s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
    i oeoreSub'="" i $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)'="" q "护士已执行,不能置条码!"

	s placerStr=..GetSpecContainerCode(oeoriId)
	q:placerStr="" "标本容器标签未定义!"
	s placerColor=$p(placerStr,"^",1)
	s placerCat=$p(placerStr,"^",2)
	//q:placerCat="" "标本容器标签未定义分类!"
	i (placerCat'="")&($p(placerNo,placerCat,1)'="") q "瓶号分类不对!"
		
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	zn dataNameSpace
	;
	s curOriSub=0,err="",oeoriIdStr=""
	f  s curOriSub=$o(^OEORD(oeordId,"I",curOriSub)) q:curOriSub=""  d
	    .s curLabEpisodeNo=$p($g(^OEORD(oeordId,"I",curOriSub,3)),"^",20)
	    .q:curLabEpisodeNo'=oriLabEpisodeNo
	    .s oeoriId=oeordId_"||"_curOriSub
	    .s err=$$select^MVBOEITM(oeoriId)
	    .s PLIST(215)=placerNo         ;OEORI_PlacerNo
	    .i clearFlag="Y" s PLIST(215)=""
	    .i err=0 s err=$$update^MVBOEITM(oeoriId)
	    .i err'=0 q
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	zn oldNameSpace  ; Restore the namespace
	i err=0,oeoriIdStr'="" d
	   	.s num=$l(oeoriIdStr,"^")
	   	.f i=1:1:num d
	   	    ..s oeoriId=$p(oeoriIdStr,"^",i)
	   	    ..s oeordId=+oeoriId
	   	    ..s oeoriSub=$p(oeoriId,"||",2)
	   	    ..s oeoreId=""
	        ..i oeoreSub="" d
	    	    ...i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d
            	    ....k PLIST
            	    ....s PLIST(0)=oeoriId
            	    ....s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            	    ....s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            	    ....&sql(insert into OE_OrdExec Values PLIST())
            	    ....i SQLCODE s err="执行记录插入有误!" q
            	    ....s oeoreId=$g(%ROWID)
            ..e  d
    		    ...s oeoreId=oeoriId_"||"_oeoreSub  
            ..i err'=0 q //ypz 070206
            ..i ($p(oeoreId,"||",1)="")!($p(oeoreId,"||",2)="")!($p(oeoreId,"||",3)="") q
            ..s curDate=+$h,curTime=$p($h,",",2)
            ..i clearFlag="Y" s userId="",curDate="",curTime=""
            ..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
            ..i dhcoreId'="" d
                ...&sql(update DHC_OE_OrdExec set DHCORE_SpecCollUser=:userId,DHCORE_SpecCollDate=:curDate,DHCORE_SpecCollTime=:curTime where DHCORE_RowId=:dhcoreId)
            ..e  d
                ...&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime) Values(:oeoreId,:userId,:curDate,:curTime))
            ..s err=SQLCODE
	q err
}

ClassMethod GetSpecContainerCode(oeoriId)
{
    //n (oeoriId)
    s retno=""
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    q:oeordId="" retno
    q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) retno
    s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    q:arcimId="" retno
    s arcsub=$p(arcimId,"||",2)
    q:arcsub="" retno
    s excode=""
    s chl="" f  s chl=$o(^ARCIM(+arcimId,arcsub,"EXT",chl)) q:chl=""  d
    	.s tod=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",2)
    	.q:(tod'="")&(tod<+$h)
    	.s excode=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",4)
  	q:excode="" retno

  	//ypz 070131 begin
  	i '$d(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)) q retno
  	s specCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",1),"^")
  	q:specCode="" retno
  	s curCtconId="",ctconId=""
  	f  s curCtconId=$o(^TTAB("TS",excode,"SC",curCtconId)) q:(curCtconId="")  d
  	    .i $d(^TTAB("TS",excode,"SC",curCtconId,specCode))>0 s ctconId=curCtconId
  	//ypz 070131
	//s ctconId=$o(^TTAB("TS",excode,"SC","")) //ypz 070131
	i ctconId'="" d  //ypz 061115
		.s ctlabId=$p(^TTAB("CON",ctconId),"\",2)
		.s len=$l(ctlabId)
		.s retno=$e(ctlabId,1,1)_"^"_$e(ctlabId,2,len)
	q retno
}

//w ##class(web.DHCPE.LabNo).InsertOtherFee(145,"PERSON")

ClassMethod InsertOtherFee(ID, Type)
{
	s Job=$J
	s continerArcimID=$G(^DHCPESetting("DHCPE","continerArcimID"))
	q:continerArcimID="" "没有设置管费医嘱"
	s BooldArcimID=$P(continerArcimID,"^",2)
	s continerArcimID=$P(continerArcimID,"^",1)
	s UserID=%session.Get("LOGON.USERID")
	s ret=""
	TSTART
	i Type="PERSON"
	{
		d InsertIADM(ID)
		
	}
	else
	{
		s PreIADM=0
		f  s PreIADM=$O(^DHCPEPreIADM(0,"PGTeam",ID,PreIADM)) q:(PreIADM="")||(ret'="")  d
		.d InsertIADM(PreIADM)
	}
	k ^TempDHCPE(Job)
	i ret'=""
	{
		TROLLBACK
		q ret
	}
	TCOMMIT
	q ret
InsertIADM(id)
	k ^TempDHCPE(Job)
	s j=0  //按标本采血	有的话就累加一次采血费
	s i=0  //统一采血的次数，有的话就是一个采血费
 	s ExecCount=0
	s Count=$O(^DHCPEDataEx("DHCPEPreIADM","BooldFee",id,""),-1)
	s Count=Count+1
	s sub=0
	f  s sub=$O(^DHCPEPreIADM(id,"ORDITEM",sub)) q:(sub="")||(ret'="")  d
	.s arcimID=$P(^DHCPEPreIADM(id,"ORDITEM",sub),"^",1)
	.s arcimCatID=$P(^ARCIM(+arcimID,1,1),"^",10)
	.q:arcimCatID=""
	.s arcimCatTyoe=$P(^ARC("IC",arcimCatID),"^",7)
	.q:arcimCatTyoe'="L"
	.s stat=$P(^DHCPEPreIADM(id,"ORDITEM",sub),"^",16)
	.q:stat'="1"
	.s recLoc=$P(^DHCPEPreIADM(id,"ORDITEM",sub),"^",17)
	.s Ext=$o(^ARCIM(+arcimID,1,"EXT",""),-1)
	.q:Ext=""
	.s ExtCode=$p(^ARCIM(+arcimID,1,"EXT",Ext),"^",4)
	.q:ExtCode=""
	.s specID=$G(^DHCPEDataEx("DHCPEPreIOrdItem","PERSON",id_"||"_sub))
	.q:specID=""
	.s specID=$P(specID,"^",1)
	.s Type=$P($G(^TTAB("SPEC",specID,"DHC")),"\",1)
	.q:(Type'=1)&&(Type'=2)
	.s ExecFlag=0
	.s PreItemID=id_"||"_sub
	.s crmOrderID=$O(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	.i crmOrderID'="" d
	..s OrderItemID=$P($G(^DHCPECRMO(crmOrderID)),"^",1)
	..i OrderItemID'="" d
	...s OrderStat=$p($G(^OEORD(+OrderItemID,"I",$p(OrderItemID,"||",2),1)),"^",13)
	...i OrderStat="6"  d
	....s ExecFlag=1
	....s CurCount=$G(^DHCPEDataEx("DHCPEPreIOrdItem","BooldFee",PreItemID))
	....i CurCount>ExecCount s ExecCount=CurCount
	.q:ExecFlag=1
	.q:$D(^DHCPEPreIADM(id,"ORDITEM",sub,"HadInsert"))
	.s ^DHCPEPreIADM(id,"ORDITEM",sub,"HadInsert")=$H
	.i Type=1 s i=1
	.i Type=2 s j=j+1
	.s ^TempDHCPE(Job,PreItemID)=""	
	.s continer=$O(^TTAB("TS",ExtCode,1,specID,""))
	.q:continer=""
	.q:$D(^DHCPEDataEx("DHCPEPreIOrdItem","InsertOtherFee",id,"N",recLoc,specID,continer))
	.s ^DHCPEDataEx("DHCPEPreIOrdItem","InsertOtherFee",id,"N",recLoc,specID,continer)=""
	.//增加采血管
	.s ret=##class(web.DHCPE.PreItemList).IInsertItem(id,"PERSON","PRE",continerArcimID,"",UserID)
	q:ret'=""
	//增加采血费
	i Count=1 d  //第一次的话
	.f k=1:1:i+j  d
	..q:ret'=""
	..s ^DHCPEDataEx("DHCPEPreIADM","BooldFee",id,Count)=""
	..s ret=##class(web.DHCPE.PreItemList).IInsertItem(id,"PERSON","PRE",BooldArcimID,"",UserID)
	e  d
	.i Count-1>ExecCount d  //如果最后一次增加大于最后一次执行的时间，就不需要增加统一采血费，也不累加增加的次数
	..s Count=Count-1
	..s i=0
	.f k=1:1:i+j  d
	..q:ret'=""
	..s ^DHCPEDataEx("DHCPEPreIADM","BooldFee",id,Count)=""
	..s ret=##class(web.DHCPE.PreItemList).IInsertItem(id,"PERSON","PRE",BooldArcimID,"",UserID)
	q:ret'=""
	s PreItemID=""
	f  s PreItemID=$O(^TempDHCPE(Job,PreItemID)) q:PreItemID=""  d
	.s ^DHCPEDataEx("DHCPEPreIOrdItem","BooldFee",PreItemID)=Count
	k ^TempDHCPE(Job)
	q
}

}
