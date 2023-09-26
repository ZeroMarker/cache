Class web.DHCPE.PrintGroupPerson Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##class(web.DHCPE.PrintGroupPerson).GetInfoById(23892)
ClassMethod GetInfoById(PreIAdm, HospID As %String = "")
{
	//S ^tempdhcpe("GetInfoById")=$lb(PreIAdm, HospID )
    q:PreIAdm="" "^^^^^^^^^"
   
    s LocID=$p($g(^DHCPEPreIADM(PreIAdm)),"^",26)
	s PGADM=$p($g(^DHCPEPreIADM(PreIAdm)),"^",2)
	s Status=$p($g(^DHCPEPreIADM(PreIAdm)),"^",8)
	q:Status="CANCELPE" PreIAdm
	
	s FactAmount=##class(web.DHCPE.PreItemList).IGetOrdAmount(PreIAdm,"PERSON")
	s Amount=$p(FactAmount,$C(13),2)
	s FactAmount=$p(FactAmount,$C(13),4)
	
	s PGBIDR=$P($G(^DHCPEPreGADM(PGADM)),"^",1)
    s GBIDesc=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
	s PGTID=$p(^DHCPEPreIADM(PreIAdm),"^",3)
	s Char=##class(web.DHCPE.PreIADM).NumToChar($p(PGTID,"||",2))
	s Sort=$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",PreIAdm))
	s PGTNAME=$P($g(^DHCPEPreGADM(+PGTID,"Team",$p(PGTID,"||",2))),"^",1)
	s PIBIDR=$P($g(^DHCPEPreIADM(PreIAdm)),"^",1)
	s name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
	s IDCard=$p($g(^DHCPEPreIBI(PIBIDR)),"^",9)
	s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
	s SexDesc=$p($g(^CT("SEX",SexDR)),"^",2)
	s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)  //登记号
	s Married=$p($g(^DHCPEPreIBI(PIBIDR)),"^",17)  //婚姻状况
	s MarriedDesc=""
	i Married'="" s MarriedDesc=$P($g(^CT("MAR",Married)),"^",2)
   
    s RegNoIndex=$ZCVT(PAPMINo,"U")
	s PaPatID=$O(^PAPERi("PAPMI_PatNo",RegNoIndex,0))

    s Tel=""
    i PIBIDR'="" d
	.s Tel=$P($g(^DHCPEPreIBI(PIBIDR)),"^",8)
	.s:Tel="" Tel=$P($g(^DHCPEPreIBI(PIBIDR)),"^",6)
	.s:Tel="" Tel=$P($g(^DHCPEPreIBI(PIBIDR)),"^",7)
	s:Tel="" Tel=$P($g(^PAPER(PaPatID,"PER",4)),"^",21)
	s:Tel="" Tel=$P($g(^PAPER(PaPatID,"PER",1)),"^",11)
	s:Tel="" Tel=$P($g(^PAPER(PaPatID,"PER",1)),"^",9)
	
    s Age=""    
    s dob=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4) 
    i PaPatID'="" d
    .;s Age=##class(web.DHCBillInterface).GetPapmiAge(PaPatID)
    .s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PaPatID,HospID,LocID)
    
    s Position=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIAdm)
    
    s Level=$P($g(^DHCPEPreIADM(PreIAdm)),"^",18)
    s NewHPNo=$P($g(^DHCPEPreIADM(PreIAdm)),"^",27)
     
    s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
	S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PAPMINo,0)),"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	i PACCardDesc["身份证" s PIBIIDCard=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PAPMINo,0)),"PAT",3)),"^",6)
	
    // 收费状态	
    s ChargedStatusDesc=""
	s ChargedStatusDesc=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(PreIAdm)
	s ChargedStatusDesc=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlagDesc(ChargedStatusDesc)
    
    s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(PreIAdm)
    S GAmount=0,IAmount=0
	Q:(""=retvalue)
	//公费金额
	S GAmount=+$P(retvalue,"^",3)
	//自费金额
	s IAmount=+$P(retvalue,"^",6)

    ;s str="^"_PAPMINo_"^"_name_"^"_SexDesc_"^"_Age_"^"_IDCard_"^"_PGTID_"^"_PGTNAME_"^"_GBIDesc
	s str=Char_Sort_"^"_PAPMINo_"^"_name_"^"_SexDesc_"^"_Age_"^"_IDCard_"^"_Position_"^"_PGTID_"^"_PGTNAME_"^"_GBIDesc_"^"_FactAmount_"^"_Amount_"^"_MarriedDesc_"^"_Tel_"^"_Level_"^"_NewHPNo_"^"_$fn(GAmount,"",2)_"^"_$fn(IAmount,"",2)_"^"_PIBIIDCard_"^"_ChargedStatusDesc
	q str
}

ClassMethod GetOnePersonById(PIADMRowId As %Library.String = "", DepartFlag As %String = "Y")
{
	s str=""
	i DepartFlag'="Y"
    {
		s PGTRowID=""
		f  s PGTRowID=$G(^DHCPEPreGADM(PIADMRowId),3)  q:PGTRowID=""  d
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PGTRowID,"Team")="0"
		.s strOne=##class(web.DHCPE.PreGADM).GetAdmList(PGTRowID, "T")
		.q:strOne=""
		.i str'="" d
		..s str=str_"^"_strOne
		.e  d
		..s str=strOne
    }
     else
    {
	    s Job=$J
	    s GlobalSub="PGADM"
	    i $L(PGADMID,"||")>1 d
	    .s GlobalSub="PGTeam"
	    s IADM=0
	    f  s IADM=$o(^DHCPEPreIADM(0,GlobalSub,PGADMID,IADM))  q:IADM=""  d
	    .s Status=$P($G(^DHCPEPreIADM(IADM)),"^",7)
		.q:Status="CANCELPREREG"
		.q:Status="CANCELPE"
		.s Depart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",IADM)
		.i Depart="" s Depart="没分部门"
		.s TeamID=$P($G(^DHCPEPreIADM(IADM)),"^",3)
		.s ^TempDHCPEGADMList(Job,Depart,TeamID,IADM)=""
		s Depart=""
		f  s Depart=$O(^TempDHCPEGADMList(Job,Depart)) q:Depart=""  d
		.s TeamID=""
		.f  s TeamID=$O(^TempDHCPEGADMList(Job,Depart,TeamID)) q:TeamID=""  d
		..s IADM=""
		..f  s IADM=$O(^TempDHCPEGADMList(Job,Depart,TeamID,IADM)) q:IADM=""  d
		...i str="" d
		....s str=IADM
		...e  d
		....s str=str_"^"_IADM
		k ^TempDHCPEGADMList(Job)
    }
    q str
}

/// para:PGADMID,
/// return:PIADM_RowId^^^^
/// w ##class(web.DHCPE.PrintGroupPerson).GetPreGPerson(1285,"N")
ClassMethod GetPreGPerson(PGADMID As %Library.String = "", DepartFlag As %String = "Y", ConRegNo As %Library.String = "", VIPLevel As %String = "")
{
    s str=""
    i DepartFlag'="Y"
    {
		s childsub=""
		f  s childsub=$o(^DHCPEPreGADM(PGADMID,"Team",childsub))  q:childsub=""  d
		.s PGTRowID=PGADMID_"||"_childsub
		.q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(PGTRowID,"Team")="0"
		.s strOne=##class(web.DHCPE.PreGADM).GetAdmList(PGTRowID, "T",VIPLevel)
		.b strOne
		.q:strOne=""
		.i str'="" d
		..s str=str_"^"_strOne
		.e  d
		..s str=strOne
    }
    else
    {
	    
	    s Job=$J
	    k ^TempDHCPEGADMList(Job)
	    s GlobalSub="PGADM"
	    i $L(PGADMID,"||")>1 d
	    .s GlobalSub="PGTeam"
	   	i ConRegNo'="" d
	   	.s IADM=$O(^DHCPEPreIADM(0,"HPNo",ConRegNo,0))
	   	.s IADM=IADM-1
	   	e  d
	   	.s IADM=0
	    s i=0
	    f  s IADM=$o(^DHCPEPreIADM(0,GlobalSub,PGADMID,IADM))  q:IADM=""  d
	    .s Status=$P($G(^DHCPEPreIADM(IADM)),"^",7)
		.q:Status="CANCELPREREG"
		.q:Status="CANCELPE"
		.s CurVIPLevel=$P($G(^DHCPEPreIADM(IADM)),"^",18)
		.q:(VIPLevel'="")&&(CurVIPLevel'=VIPLevel)
		.s Depart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",IADM)
		.i Depart="" s Depart="没分部门"
		.s TeamID=$P($G(^DHCPEPreIADM(IADM)),"^",3)
		.s ^TempDHCPEGADMList(Job,Depart,TeamID,IADM)=""
		/*
		s Depart=""
		s TeamID=""
		s IADM=""
		i ConRegNo'="" d
	    .s PIBIRowId=$o(^DHCPEPreIBI(0,"PAPMINo",ConRegNo,0))
	    .s PIADM="" 
	    .f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIRowId,PIADM))  q:(PIADM="")||(IADM'="")  d
	    ..s PGADMDR=$p($G(^DHCPEPreIADM(PIADM)),"^",3)
	    ..q:PGADMDR'=PGADMID
	    ..s Status=$P($G(^DHCPEPreIADM(PIADM)),"^",7)
		..q:Status="CANCELPREREG"
		..q:Status="CANCELPE"
	    ..s IADM=PIADM
	   	..s IDepart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PIADM)
		..i IDepart="" s IDepart="没分部门"
		..s TeamID=$P($G(^DHCPEPreIADM(PIADM)),"^",3)
	    ..s Depart=$O(^TempDHCPEGADMList(Job,IDepart),-1)
		
		
		*/
		s Depart=""
		f  s Depart=$O(^TempDHCPEGADMList(Job,Depart)) q:Depart=""  d
		.s TeamID=""
		.f  s TeamID=$O(^TempDHCPEGADMList(Job,Depart,TeamID)) q:TeamID=""  d
		..s IADM=""
		..f  s IADM=$O(^TempDHCPEGADMList(Job,Depart,TeamID,IADM)) q:IADM=""  d
		...s Status=$P(^DHCPEPreIADM(IADM),"^",8)
		...q:Status="ARRIVED"
		...q:Status="CANCELPE"
		...i str="" d
		....s str=IADM
		...e  d
		....s str=str_"^"_IADM
		k ^TempDHCPEGADMList(Job)
    }
    q str
}

ClassMethod getpath()
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

ClassMethod GetPreGPersonIADM(PreGADM, Type As %String = "RecLoc", ExecFlag As %String = "", Depart As %String = "")
{
    
    
    k ^DHCPETemp("PersonItem")
	s IADMStr="",Amount=0 ,FactAmount=0
	s PAID=0
	f  s PAID=$o(^DHCPEPreA(0,"CRMADM","G",PreGADM,PAID)) q:PAID=""  d
	.s Status=$p(^DHCPEPreA(PAID),"^",21)
	.q:Status="NU"
	.s IADM=0
	.f  s IADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM)) q:IADM=""  d
	..s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",IADM))  //add 20121208
	..q:(Position'=Depart)&&(Depart'="")                           //add 20121208
	..s Status=$p(^DHCPEPreIADM(IADM),"^",8)
	..Q:Status="CANCELPE"
	..s CancelFlag=##class(web.DHCPE.CancelPE).CheckIAdmCanCancel(IADM) //1不能取消
	..
	..i IADMStr=""  s IADMStr=IADM 
	..e  s IADMStr=IADMStr_"^"_IADM
	..s ^DHCPETemp("PersonItem","IADMStr",IADM)=1
	..//得到医嘱项信息
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM,ItemSub)) q:ItemSub=""  d
	...s Stat=$p(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub),"^",16)
	...q:Stat'="1"
	...s ARCIM=$p(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub),"^",1)
	...s crmorderID=$O(^DHCPECRMO(0,"CRMORI",IADM_"||"_ItemSub,0))
	...q:crmorderID=""
	...s oeordID=$P(^DHCPECRMO(crmorderID),"^",1)
	...q:oeordID=""
	
	...s Stat=$p($G(^OEORD(+oeordID,"I",$p(oeordID,"||",2),1)),"^",13)
	...q:(ExecFlag="N")&&(Stat'="1")
	...s stationID=$O(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
	...q:(CancelFlag=1)&&(ExecFlag="N")&&(stationID=$G(^DHCPESetting("DHCPE","StationId_Other")))
	
	...i Type="RecLoc" d
	....s ARCIM=$P(^OEORD(+oeordID,"I",$P(oeordID,"||",2),3),"^",6)
	...i $D(^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM)) d
	....s Sort=+$G(^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM))
	...e  d
	....s ^DHCPETemp("PersonItem","$ZN","ARCIM")=+$G(^DHCPETemp("PersonItem","$ZN","ARCIM"))+1
	....s Sort=+$G(^DHCPETemp("PersonItem","$ZN","ARCIM"))
	....s ^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM)=Sort
	....s ^DHCPETemp("PersonItem","$ZN","Sort",Sort)=ARCIM
	...s Amount=+$p(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub),"^",14)
	...s FeeSub=0,FactAmount=0
	...f  s FeeSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PAID,IADM,ItemSub,FeeSub)) q:FeeSub=""  d
	....s FactAmount=FactAmount+$p(^DHCPEPreIADM(IADM,"ORDITEM",ItemSub,"FEE",FeeSub),"^",2)
	...s ^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Total")=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Total"))+1
	...s ^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Amount")=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Amount"))+Amount
	...s ^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"FactAmount")=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"FactAmount"))+FactAmount
	.//通过医嘱套得到医嘱信息
	.//W !,"DDD"_IADM
	.s IADM=0
	.f  s IADM=$o(^DHCPEPreIADM(0,"PAORDENT",PAID,IADM)) q:IADM=""  d
	..s CancelFlag=##class(web.DHCPE.CancelPE).CheckIAdmCanCancel(IADM) //1不能取消
	
	..s Status=$p(^DHCPEPreIADM(IADM),"^",8)
	..Q:Status="CANCELPE"
    ..s ^DHCPETemp("PersonItem","IADMStr",IADM)=1
	..s EntSub=0
	..f  s EntSub=$o(^DHCPEPreIADM(0,"PAORDENT",PAID,IADM,EntSub)) q:EntSub=""  d
	...s PIOEItemStat=$p(^DHCPEPreIADM(IADM,"ORDENT",EntSub),"^",9)
	...q:PIOEItemStat'="1"
	...s PIOEDR=IADM_"||"_EntSub
    ...s PIOIChildSub=0
    ...f  s PIOIChildSub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOEDR,IADM,PIOIChildSub))  q:PIOIChildSub=""  d
   	....s PIOIStat=$p(^DHCPEPreIADM(IADM,"ORDITEM",PIOIChildSub),"^",16)
	....q:PIOIStat'="1"
	....s ARCIM=$p(^DHCPEPreIADM(IADM,"ORDITEM",PIOIChildSub),"^",1)
	....s crmorderID=$O(^DHCPECRMO(0,"CRMORI",IADM_"||"_PIOIChildSub,0))
	....q:crmorderID=""
	....s oeordID=$P(^DHCPECRMO(crmorderID),"^",1)
	....q:oeordID=""
	
	....s Stat=$p($G(^OEORD(+oeordID,"I",$p(oeordID,"||",2),1)),"^",13)
	....q:(ExecFlag="N")&&(Stat'="1")
	....s stationID=$O(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
	....q:(CancelFlag=1)&&(ExecFlag="N")&&(stationID=$G(^DHCPESetting("DHCPE","StationId_Other")))
	
	....i Type="RecLoc" d
	.....s ARCIM=$P(^OEORD(+oeordID,"I",$P(oeordID,"||",2),3),"^",6)
	....i $D(^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM)) d
	.....s Sort=+$G(^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM))
	....e  d
	.....s ^DHCPETemp("PersonItem","$ZN","ARCIM")=+$G(^DHCPETemp("PersonItem","$ZN","ARCIM"))+1
	.....s Sort=+$G(^DHCPETemp("PersonItem","$ZN","ARCIM"))
	.....s ^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM)=Sort
	.....s ^DHCPETemp("PersonItem","$ZN","Sort",Sort)=ARCIM
    ....s FactAmount=0
    ....s Amount=+$p(^DHCPEPreIADM(IADM,"ORDITEM",PIOIChildSub),"^",14)
	....d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOEDR)
	....s FactAmount=^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOEDR,(IADM_"||"_PIOIChildSub))
	....s ^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Total")=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Total"))+1
	....s ^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Amount")=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Amount"))+Amount
	....s ^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"FactAmount")=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"FactAmount"))+FactAmount
	
	s Strings=""
	s Sort=0
	f  s Sort=$o(^DHCPETemp("PersonItem","$ZN","Sort",Sort)) q:Sort=""  d
	.s ARCIM=$G(^DHCPETemp("PersonItem","$ZN","Sort",Sort))
	.i Type="RecLoc" d
	..s ARCIMDesc=$P(^CTLOC(ARCIM),"^",2)
	.e  d
	..s ARCIMDesc=$P($G(^ARCIM(+ARCIM,"1",1)),"^",2)
	.i Strings="" d
	..s Strings="1^序号&2^姓名/项目&"_(Sort+2)_"^"_ARCIMDesc
	.e  d
	..s Strings=Strings_"&"_(Sort+2)_"^"_ARCIMDesc
 	s MaxSort=$o(^DHCPETemp("PersonItem","$ZN","Sort",""),-1)+1
 	//i Strings'="" s Strings=Strings_"&"_(MaxSort+1)_"^合计"
 	s IADM=0,IADMStr=""
 	f  s IADM=$o(^DHCPETemp("PersonItem","IADMStr",IADM))  q:IADM=""  d
 	.i IADMStr=""  s IADMStr=IADM
 	.else  s IADMStr=IADMStr_"^"_IADM
 	
 	i Strings'="" s Strings=Strings_"&"_(MaxSort+2)_"^合计"_"&"_(MaxSort+3)_"^折后合计"_"%"_IADMStr
	q Strings
}

ClassMethod GetPreGPersonItem(IADM)
{
 	s OneStrings="",Strings=""
	s OneAmount=0,OneFactAmount=0
	s Name=..GetPatientName(IADM)
	s PGTID=$p(^DHCPEPreIADM(IADM),"^",3)
	s Char=##class(web.DHCPE.PreIADM).NumToChar($p(PGTID,"||",2))
	s Sort=$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",IADM))
	s xh=Char_Sort
	s OneStrings="1"_"^"_xh_"&2^"_Name
	s ARCIM=""
	f  s ARCIM=$o(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM)) q:ARCIM=""  d
	.s Sort=$G(^DHCPETemp("PersonItem","$ZN","ARCIM",ARCIM))	
	.s Num=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Total"))
	.s Amount=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"Amount"))
	.s FactAmount=+$G(^DHCPETemp("PersonItem","$ZN","IADM",IADM,"ARCIM",ARCIM,"FactAmount"))
	.s OneStrings=OneStrings_"&"_(Sort+2)_"^"_Amount //_"("_FactAmount_")"
	.s PLIST(Sort+2)=+$G(PLIST(Sort+2))+Amount
	.s PLIST2(Sort+2)=+$G(PLIST2(Sort+2))+FactAmount
	.s OneAmount=OneAmount+Amount
	.s OneFactAmount=OneFactAmount+FactAmount
	.s ^DHCPETemp("PersonItem","ColTotal",(Sort+2))=+$G(^DHCPETemp("PersonItem","ColTotal",(Sort+2)))+Amount
	.s ^DHCPETemp("PersonItem","ColFactTotal",(Sort+2))=+$G(^DHCPETemp("PersonItem","ColFactTotal",(Sort+2)))+FactAmount
	.//w !,$G(^DHCPETemp("PersonItem","ColTotal",(Sort+1)))
	//设置一个人的合计
	s MaxSort=$o(^DHCPETemp("PersonItem","$ZN","Sort",""),-1)+1
	s OneStrings=OneStrings_"&"_(MaxSort+2)_"^"_OneAmount //_"("_OneFactAmount_")"
	s PLIST(MaxSort+2)=+$G(PLIST(MaxSort+2))+OneAmount
	s PLIST2(MaxSort+2)=+$G(PLIST2(MaxSort+2))+OneFactAmount
	s ^DHCPETemp("PersonItem","TotalFee",(MaxSort+2))=+$g(^DHCPETemp("PersonItem","TotalFee",(MaxSort+2)))+PLIST(MaxSort+2)
	q:+$G(PLIST(MaxSort+2))=0 ""
	s ^DHCPETemp("PersonItem","TotalFactFee",(MaxSort+2))=+$g(^DHCPETemp("PersonItem","TotalFactFee",(MaxSort+2)))+PLIST2(MaxSort+2)
	i Strings="" d
	.s Strings=OneStrings
	e  d
	.s Strings=Strings_"$"_OneStrings
	//设置所有人某一项的总计   //显示一个人一行的信息
	i Strings'="" d 
	.s Strings=Strings_"$"_"1^合计&2^"_Name
	.for i=3:1:(MaxSort+2) d
	..i $G(PLIST(i))=""  s PLIST(i)="0"
    ..i $G(PLIST2(i))=""  s PLIST2(i)="0"
	..s Strings=Strings_"&"_i_"^"_$G(PLIST(i))
	s Strings=Strings_"&"_(i+1)_"^"_$G(PLIST2(i)) //_"("_$G(PLIST2(i))_")"
	//k ^DHCPETemp("PersonItem","$ZN")
	q Strings
}

ClassMethod GetPatientName(IADM)
{
	q:IADM="" ""
	s Name=""
	s PIBI=$p($G(^DHCPEPreIADM(IADM)),"^",1)
	s Name=$p($G(^DHCPEPreIBI(PIBI)),"^",2)
	q Name
}

// w ##class(web.DHCPE.PrintGroupPerson).GetItemFeeTotal()

ClassMethod GetItemFeeTotal()
{
	
    s MaxSort=$o(^DHCPETemp("PersonItem","$ZN","Sort",""),-1)+1
    s Strings="1^合计&2^"
    for i=3:1:(MaxSort+1) d        
    .s Strings=Strings_"&"_i_"^"_$G(^DHCPETemp("PersonItem","ColTotal",i)) //_"("_+$G(^DHCPETemp("PersonItem","ColFactTotal",i))_")"
    S PreIADM=0
    s DataStr=""
    f  s PreIADM=$o(^DHCPETemp("PersonItem","PreIADMTotal",PreIADM))  q:PreIADM=""  d
    .s Data=$G(^DHCPETemp("PersonItem","PreIADMTotal",PreIADM,(MaxSort+1)))
    .s FactData=$G(^DHCPETemp("PersonItem","PreIADMFactTotal",PreIADM,(MaxSort+1)))
    s TotalData=$g(^DHCPETemp("PersonItem","TotalFee",(MaxSort+2)))
    s FactTotalData=$g(^DHCPETemp("PersonItem","TotalFactFee",(MaxSort+2)))
    s Strings=Strings_"&"_(MaxSort+2)_"^"_TotalData_"&"_(MaxSort+3)_"^"_FactTotalData
 	q Strings
}

ClassMethod IsHPNo(ConRegNo)
{
 s flag=0
 i '$d(^DHCPEPreIADM(0,"HPNo",ConRegNo)) s flag=1
 q flag
}

}
