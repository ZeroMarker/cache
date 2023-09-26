Class web.DHCFHQTOOLS Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod FHQ()
{
	S RowId=""
 f  s RowId=$o(^FHQIQIQFHQIQIQ(RowId)) q:RowId=""  d
 .s CardNo=##class(web.DHCFBCM).ConvertStr(RowId_"^0^15")
	.IF '$d(^DHCCARDi("CF",0,"CardNo",CardNo))  D
	..s ^FHQNUM=$I(^FHQNUM)
	..S ^FHQIQIQNO(RowId)=$G(FHQIQIQFHQIQIQ(RowId))
	Q $G(^FHQNUM)
}

ClassMethod SearchNum()
{
 S RowId=""
 k ^FHQNUM
 f  s RowId=$o(^FHQIQIQ0109(RowId)) q:RowId=""  d
 .s ^FHQNUM=$I(^FHQNUM)
 Q $G(^FHQNUM)
}

ClassMethod UpOrdDoc()
{
   ;D ##class(web.DHCFHQTOOLS).UpOrdDoc()
	s del="^"
	s PaAdmId=0
	S PaAdmId=565800
	s i=0 
	f  s PaAdmId=$o(^PAADM(PaAdmId)) Q:((PaAdmId="")!(PaAdmId>565924))  D
	.
	.S DocId=$p(^PAADM(PaAdmId),del,9)
	.q:$g(DocId)=""
	.s OrdId1=$o(^OEORD(0,"Adm",PaAdmId,0))
	.q:$g(OrdId1)=""
	.s OrdId2=0
	.f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	..s OrdDocDr=$p(^OEORD(OrdId1,"I",OrdId2,1),del,11)
	..q:$g(OrdDocDr)'=""
	..s OrdId=OrdId1_"||"_OrdId2
	..&sql(update sqluser.Oe_OrdItem set OEORI_Doctor_DR=:DocId where OEORI_RowId=:OrdId )
	..w SQLCODE,"^"
	..s i=i+1
	w i
	Q
}

ClassMethod CHANGESTOCKaa()
{

 s del="^"
 s FromDate=$h-2
 S LocDescs="心理卫生中心药房"_del_"利康药房"
 s i=1
 f  s LocDesc=$p(LocDescs,del,i) q:LocDesc=""  d
 .s i=i+1
 .s ^FHQTMP("InitStock",LocDesc,$zd($h,3))=$zt($p($h,",",2))
 .s Result=$$CHANGERESVERQTY^DHCFINCI(LocDesc,FromDate)
 .s ^FHQTMP("InitStock",LocDesc,$zd($h,3))=^FHQTMP("InitStock",LocDesc,$zd($h,3))_"^"_$zt($p($h,",",2))
 .if Result'="" s ^FHQTMP("CHANGESTOCK",LocDesc)=Result
 q
}

ClassMethod CHANGERESVERQTY(LocDesc, FromDate)
{
 K ^FHQTMP($j)
 s del="^"
 S LocId=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc),""))
 Q:$G(LocId)="" "科室指针为空"_LocDesc
 s IncId=0,OeoriSTTime=0
 f  s OeoriSTTime=$o(^OEORDi(0,"LocStDtTm",LocId,FromDate,OeoriSTTime)) q:OeoriSTTime=""  d
 .s OrdId1=0
 .f  s OrdId1=$o(^OEORDi(0,"LocStDtTm",LocId,FromDate,OeoriSTTime,OrdId1)) q:OrdId1=""  d
 ..s OrdId2=0
 ..f  s OrdId2=$o(^OEORDi(0,"LocStDtTm",LocId,FromDate,OeoriSTTime,OrdId1,OrdId2)) q:OrdId2=""  d
 ...s BillFlag=$p(^OEORD(OrdId1,"I",OrdId2,3),del,5)
 ...s OrdStatus=$p(^OEORD(OrdId1,"I",OrdId2,1),del,13)
 ...s AdmId=$p(^OEORD(OrdId1),del,1)
 ...s AdmType=$p(^PAADM(AdmId),del,2)
 ...s CircleFlag=0
 ...if (($g(BillFlag)="TB")&(OrdStatus=1)) s CircleFlag=1
 ...IF (($g(BillFlag)="B")&($G(AdmType)="O")) s CircleFlag=1
 ...q:CircleFlag=0
 ...s DHCOeDispId=$o(^DHCOEDISQTY(0,"OEORI",OrdId1_"||"_OrdId2,0))
 ...s Qty=$p(^DHCOEDISQTY(DHCOeDispId),del,5)
 ...q:(+Qty=0)
 ...s ArcimId=$p(^OEORD(OrdId1,"I",OrdId2,1),del,2)
 ...q:$g(ArcimId)=""
 ...s IncId=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),0))
 ...q:$g(IncId)=""
 ...if $d(^FHQTMP($j,ArcimId)) s ^FHQTMP($j,ArcimId,IncId)=$g(^FHQTMP($j,ArcimId,IncId))+Qty
 ...if '$d(^FHQTMP($j,ArcimId)) s ^FHQTMP($j,ArcimId,IncId)=+Qty
 s ArcimId=0,IncId=0
 f  s ArcimId=$o(^FHQTMP($j,ArcimId)) q:ArcimId=""  d
 .s IncId=0
 .f  s IncId=$o(^FHQTMP($j,ArcimId,IncId)) q:IncId=""  d
 ..s Qty=$g(^FHQTMP($j,ArcimId,IncId))
 ..q:(+Qty=0)
 ..s IncLocSubId=$o(^INCI("IL_LOC",LocId,IncId,0))
 ..q:$g(IncLocSubId)=""
 ..s IncLocId=IncId_"||"_IncLocSubId
 ..s ResQty=$p(^INCI(IncId,"IL",IncLocSubId),del,10)
 ..q:(+ResQty<1)
 ..IF (ResQty<Qty) D
 ...s $p(^INCI(IncId,"IL",IncLocSubId),del,10)=0
 ..e  d
 ...s $p(^INCI(IncId,"IL",IncLocSubId),del,10)=ResQty-Qty
 ..;w "1"_Qty_"^"_ResQty,!
 K ^FHQTMP($j)
 q ""
}

ClassMethod aa(aa)
{
 s desc=$ZCONVERT(desc,"U")
  Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s Description="",Code=""
  s ^fhqalia(+$g(^fhqalia1))=desc
  s ^fhqalia1=+$g(^fhqalia1)+1
  s CircleFlag=1
  s tmpAilas=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(desc)),-1)
	f  s tmpAilas=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(tmpAilas))) q:((tmpAilas="")!(CircleFlag'=1))  d
	.if ($e($$ALPHAUP^SSUTIL4(tmpAilas),1,$l($$ALPHAUP^SSUTIL4(desc)))'=$$ALPHAUP^SSUTIL4(desc)) d
	..s CircleFlag=0
	.q:CircleFlag'=1
  .s ICDRowid=""  
  .f  s ICDRowid=$o(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(tmpAilas),ICDRowid)) q:ICDRowid=""  d
  ..s Description=$p(^MRC("ID",ICDRowid),"^",2)
	..s Code=$p(^MRC("ID",ICDRowid),"^",1)
	..Do OutputRow
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	 set Data=$lb(Description,ICDRowid,Code)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	 Quit
}

ClassMethod CHECKID(Id)
{
   s del="^"
   ;S Id="510122197301104360"
   s PapmiId=0,CircleFlag=1
   f  s PapmiId=$o(^PAPER(PapmiId)) Q:((PapmiId="")!(CircleFlag'=1))  d
   .s id=$p(^PAPER(PapmiId,"ALL"),del,9)
   .if id=Id s CircleFlag=0
   .if CircleFlag=0 w PapmiId,!
   .q:(CircleFlag'=1)
   .if $d(^PAPER(PapmiId,"PAT",3))  d
   ..s divno=$p(^PAPER(PapmiId,"PAT",3),del,6)
   ..if divno=Id s CircleFlag=0 w PapmiId,!
   ..q:CircleFlag'=1
  q
}

/*
1:  ^ARC("IC",73)="73^干部动态心电检查^^N^N^^N^3^1^^N^^^^^^^^^^^^^^^^^^^" 
2:  ^ARC("IC",73,"RL",0)=1 
3:  ^ARC("IC",73,"RL",1) ="Execute^^90^Y^^^^61071^^" 


^ARC("IC",0,"Code",73,73)="" 
^ARC("IC",0,"Desc","干部动态心电检查",73)="" 
^ARC("IC",0,"ExecType",1,73)="" 
^ARC("IC",0,"OrdCat",3,73)="" 
^ARC("IC",0,"OrderType","N",73)="" 
*/
}
