Import SQLUser

/// Function:医嘱项价格 
/// Creator:sunfengchao
Class web.DHCBL.CT.UDHCJFPRICE Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

ClassMethod SELECT(RowId)
{
 k PLIST
 &sql(SELECT * INTO PLIST() FROM DHC_TarItemPrice WHERE TP_RowId= :RowId) 
 s PLIST=$o(PLIST(""),-1)
 s PLIST(1)=$P(PLIST(1),$C(1))
 s PLIST(2)=$P(PLIST(2),$C(1))
 i $p(PLIST(3),$C(1))'="" s PLIST(3)=$zd(+PLIST(3),3)
 i $p(PLIST(4),$C(1))'="" s PLIST(4)=$zd(+PLIST(4),3)
 s PLIST(3)=$P(PLIST(3),$C(1))
 s PLIST(4)=$P(PLIST(4),$C(1))
 s PLIST(5)=$P(PLIST(5),$C(1))
 s PLIST(6)=$P(PLIST(6),$C(1))
 s PLIST(7)=$P(PLIST(7),$C(1))
 s PLIST(8)=$P(PLIST(8),$C(1))
 s PLIST(9)=$P(PLIST(9),$C(1))
 s PLIST(10)=$P(PLIST(10),$C(1))
 s PLIST(11)=$P(PLIST(11),$C(1))
 s PLIST(12)=$P(PLIST(12),$C(1))
 s PLIST(13)=$P(PLIST(13),$C(1))
 s PLIST(14)=$P(PLIST(14),$C(1))
 s PLIST(15)=$P(PLIST(15),$C(1))
 q SQLCODE
}

ClassMethod UPDATE(RowId)
{
 k PLIST(1)
 i PLIST(5)'="" s PLIST(5)=+PLIST(5)
 i PLIST(6)'="" s PLIST(6)=+PLIST(6)
 i PLIST(7)'="" s PLIST(7)=+PLIST(7)
 i PLIST(12)'="" s PLIST(12)=+PLIST(12)
 i PLIST(14)'="" s PLIST(14)=+PLIST(14)
 i PLIST(15)'="" s PLIST(15)=+PLIST(15)
 s PLIST(9)=+$H
 s PLIST(10)=$P($H,",",2)
 s $ZT="ERROR^DHCSSERR" d ..tb()
 &sql(UPDATE DHC_TarItemPrice VALUES PLIST() WHERE TP_RowId= :RowId)
 d ..tc()
 i 'SQLCODE q ..SELECT(%ROWID)
 q $$code^SSUTILSQ(SQLCODE)
}

ClassMethod DELETE(RowId)
{
 s $ZT="ERROR^DHCSSERR" d ..tb()
 &sql(DELETE FROM DHC_TarItemPrice WHERE TP_RowId= :RowId)
 d ..tc()
 q SQLCODE
}

ClassMethod FETCH(ParRef)
{
 k PLIST
 s sub=$o(^DHCTARI(ParRef,"P",sub)) 
 i $g(sub)="" s SQLCODE=100 
 i ($g(sub)'="") d
   .i ($g(sub)'="0") d
   ..s ROW=ParRef_"||"_sub
   ..s SQLCODE=..SELECT(ROW)
 e  s SQLCODE=100
 q SQLCODE
}

ClassMethod AdjARCPrice(arcim, StDate, StPrice, User, AdjNo, PN)
{
 n (arcim,StDate,StPrice,User,AdjNo,PN)
 i arcim="" q 0
 s Itm=$o(^DHCOLT(0,"ARTTA",arcim,"")) q:Itm="" 0
 s err=..AdjItmPrice(Itm,StDate,StPrice,User,AdjNo,PN)
 q 0
}

ClassMethod AdjINCIPrice(INCI, StDate, StPrice, User, AdjNo, PN)
{
 n (INCI,StDate,StPrice,User,AdjNo,PN)
 i INCI="" q 0
 s Arc=$p(^INCI(INCI,1),"^",3)
 i Arc="" q 0
 s Itm=$o(^DHCOLT(0,"ARTTA",Arc,"")) q:Itm="" 0
 s err=..AdjItmPrice(Itm,StDate,StPrice,User,AdjNo,PN)
 q 0
}

ClassMethod AdjItmPrice(Itm, StDate, StPrice, User, AdjNo, PN)
{
 n (Itm,StDate,StPrice,User,AdjNo,PN)
 q:$g(Itm)="" 100
 q:$g(StPrice)="" 100
 q:+$g(StDate)<+$H 100
 
 s StartDate=+$H+1
 s $ZT="ERROR^DHCSSERR" d ..tb()
 s Num=0
 s PatIns="" f  s PatIns=$o(^DHCTARIi("TARI",Itm,PatIns)) q:PatIns=""  d
 .s Date="" s Date=$o(^DHCTARIi("TARI",Itm,PatIns,StartDate),-1)
 .q:Date=""
 .s Cld="" s Cld=$o(^DHCTARIi("TARI",Itm,PatIns,Date,Cld))
 .q:Cld=""
 .k PLIST
 .s err=..SELECT(Itm_"||"_Cld)
 .s PLIST(1)=Itm
 .s PLIST(3)=StDate
 .k PLIST(4)
 .s PLIST(5)=+StPrice
 .i PN=""!(PN=0) s PLIST(5)=+StPrice
 .i PN=1 s PLIST(14)=+StPrice
 .i PN=2 s PLIST(15)=+StPrice
 .s PLIST(8)=User
 .s PLIST(9)=+$H,PLIST(10)=$p($H,",",2)
 .s PLIST(11)=AdjNo
 .s err="" //..INSERT()
 .i 'err s Num=Num+1

 i Num=0 d
 .k PLIST
 .s Conf=$o(^DHCTarC("CF","")) q:Conf=""
 .s InsType=$p(^DHCTarC("CF",Conf),"^",3)
 .s PLIST(1)=Itm
 .s PLIST(3)=StDate
 .s PLIST(5)=+StPrice
 .s PLIST(6)=""
 .s PLIST(7)=""
 .i PN=""!(PN=0) s PLIST(5)=+StPrice
 .i PN=1 s PLIST(14)=+StPrice
 .e  s PLIST(14)=""
 .i PN=2 s PLIST(15)=+StPrice
 .e  s PLIST(15)=""
 .s PLIST(8)=User
 .s PLIST(9)=+$H
 .s PLIST(10)=$p($H,",",2)
 .s PLIST(11)=AdjNo
 .s PLIST(12)=""
 .s PLIST(13)=InsType
 .;s err=..INSERT()
 d ..tc()
 q 0
}

ClassMethod DeleteTarPrice(AdjNo)
{
 n (AdjNo)
 q:AdjNo="" 0
 s $ZT="ERROR^DHCSSERR" d ..tb()
 &SQL(DELETE FROM DHC_TarItemPrice WHERE TP_AdjustNo=:AdjNo)
 d ..tc()
 q 0
}

//get last record whose enddate is blank or is great than  StDate before  StDate

ClassMethod GetCatDisc(Cat, StDate, InsType, Price)
{
 n (Cat,StDate,InsType,Price)
 q:Cat="" "^"
 s Conf=$o(^DHCTarC("CF","")) q:Conf="" "^"
 
 q:InsType="" "^"
 s getf=0
 s:StDate="" StDate=+$H
 s StDate0=StDate+1
 Set DiscRate="",PayorRate="",AlterLevel="",AlterPayorRate=""
 For  Set StDate0=$o(^DHCTARF(0,"TARSC",InsType,Cat,StDate0),-1) Quit:StDate0=""!(getf=1)  Do
 .Set tf=""
 .For  Set tf=$o(^DHCTARF(0,"TARSC",InsType,Cat,StDate0,tf),-1) Quit:tf=""!(getf=1)  Do
 ..Set Itm=$p($g(^DHCTARF(tf)),"^",3)
 ..Quit:Itm'=""   
 ..Set EndDate=$p($g(^DHCTARF(tf)),"^",5)
 ..Quit:(EndDate'="")&(EndDate<StDate)
 ..s DiscRate=$p($g(^DHCTARF(tf)),"^",6),PayorRate=$p($g(^DHCTARF(tf)),"^",7)
 ..s AlterLevel=$p($g(^DHCTARF(tf)),"^",8),AlterPayorRate=$p($g(^DHCTARF(tf)),"^",9)
 ..s getf=1
 ;当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
 i (Price>AlterLevel)&((+AlterLevel)'=0) d
 .s DiscRate=+AlterPayorRate
 q DiscRate_"^"_PayorRate
}

ClassMethod GetItmDisc(Itm, StDate, InsType, Price)
{
 n (Itm,StDate,InsType,Price)
 q:Itm="" "^"
 s Conf=$o(^DHCTarC("CF","")) q:Conf="" "^"
 q:InsType="" "^"
 s getf=0
 s:StDate="" StDate=+$H
 s StDate0=StDate+1
 Set DiscRate="",PayorRate="",AlterLevel="",AlterPayorRate=""
 For  Set StDate0=$o(^DHCTARF(0,"TARI",InsType,Itm,StDate0),-1) Quit:StDate0=""!(getf=1)  Do
 .Set tf=""
 .For  Set tf=$o(^DHCTARF(0,"TARI",InsType,Itm,StDate0,tf),-1) Quit:tf=""!(getf=1)  Do
 ..Set EndDate=$p(^DHCTARF(tf),"^",5)
 ..Quit:(EndDate'="")&(EndDate<StDate)
 ..s DiscRate=$p(^DHCTARF(tf),"^",6),PayorRate=$p(^DHCTARF(tf),"^",7)
 ..s AlterLevel=$p($g(^DHCTARF(tf)),"^",8),AlterPayorRate=$p($g(^DHCTARF(tf)),"^",9)
 ..s getf=1
 ;当价格大于限额时，按限价后的折扣系数，否则按限价前的折扣系数
 i (Price>AlterLevel)&((+AlterLevel)'=0) d
 .s DiscRate=+AlterPayorRate
 q DiscRate_"^"_PayorRate
}

ClassMethod GetItmPrice(Itm, StDate, InsType, PatType, OEPrice, HospID, ExpStr As %String = "")
{
 s HospID=$g(HospID)
 n (Itm,StDate,InsType,PatType,OEPrice,HospID,ExpStr)
 q:+$g(Itm)=0 0_"^"_0_"^"_0_"^"_0
 q:'$d(^DHCTARIi("TARI",Itm)) 0_"^"_0_"^"_0_"^"_0
 s Conf=$o(^DHCTarC("CF","")) q:Conf="" 0_"^"_0_"^"_0_"^"_0
 s:InsType="" InsType=$p(^DHCTarC("CF",Conf),"^",3)
 s InsType0=InsType
 s DefaultFlag=0
 s SpecialFlag=$p(^DHCTARI(Itm),"^",17)
 i '$d(^DHCTARIi("TARI",Itm,InsType)) s DefaultFlag=1,InsType=$p(^DHCTarC("CF",Conf),"^",3)
 q:'$d(^DHCTARIi("TARI",Itm,InsType)) 0_"^"_0_"^"_0_"^"_0
 s:StDate="" StDate=+$H
 s StDate0=StDate+1
 s ExeDate=""
 s ExeDate=$o(^DHCTARIi("TARI",Itm,InsType,StDate0),-1)
 q:ExeDate="" 0_"^"_0_"^"_0_"^"_0
 ;根据不同的医院取不同的价格
 i HospID="" d
    .s tp=$o(^DHCTARIi("TARI",Itm,InsType,ExeDate,""),-1)
    e  d
    .s tp=$o(^DHCTARIi("HospInsType",Itm,InsType,HospID,ExeDate,""),-1)   ;YYX 根据医院取价格
    .i tp="" d
    ..s tp=$o(^DHCTARIi("TARI",Itm,InsType,ExeDate,""),-1)
    
    q:tp="" 0_"^"_0_"^"_0_"^"_0
 
 ;Standard Price
 s STP=..GetSTP(PatType,StDate)
 s Price=+$p(^DHCTARI(Itm,"P",tp),"^",5)
 i STP="P0" s Price=+$p(^DHCTARI(Itm,"P",tp),"^",5)
 i STP="P1" s Price=+$p(^DHCTARI(Itm,"P",tp),"^",14)
 i STP="P2" s Price=+$p(^DHCTARI(Itm,"P",tp),"^",15)
 ;When Order is "Price" Order
 i $g(OEPrice)'="" s Price=$g(OEPrice)
 ;
 ;Limited Price
 s LimitedPrice=$p(^DHCTARI(Itm,"P",tp),"^",6)
 s DiscRate=$p(^DHCTARI(Itm,"P",tp),"^",12)
 if DiscRate="" s ItmDiscRateFlag="N"
 else  s ItmDiscRateFlag="Y"
 
 s PayorRate=$p(^DHCTARI(Itm,"P",tp),"^",7)
 if PayorRate="" s ItmPayorRateFlag="N"
 else  s ItmPayorRateFlag="Y"

 s DiscRate=+DiscRate
 s PayorRate=+PayorRate
 s Cat=$p(^DHCTARI(Itm),"^",4)
 s CatRate=..GetCatDisc(Cat,StDate,InsType0,Price)
 s ItmRate=..GetItmDisc(Itm,StDate,InsType0,Price)
 s Discflag=$p(^DHCTarC("CF",Conf),"^",4)
 
 ;Discount and Payor Rate
 i (Discflag="P")&(ItmDiscRateFlag="N")&(DefaultFlag=0) do
 .s DiscRate=$p(ItmRate,"^",1)
 .i DiscRate="" s DiscRate=$p(CatRate,"^",1)

 i (Discflag="P")&(ItmPayorRateFlag="N")&(DefaultFlag=0) do
 .s PayorRate=$p(ItmRate,"^",2)
 .i PayorRate="" s PayorRate=$p(CatRate,"^",2)
 
 i (Discflag="P")&(DefaultFlag=1) do
 .s DiscRate=$p(ItmRate,"^",1)
 .i DiscRate="" s DiscRate=$p(CatRate,"^",1)
 .s PayorRate=$p(ItmRate,"^",2)
 .i PayorRate="" s PayorRate=$p(CatRate,"^",2)
 
 s DiscRate=+DiscRate
 s PayorRate=+PayorRate
 
 i (Discflag'="P")&(DefaultFlag=1) do
 .s DiscRate=0
 .s PayorRate=0
 
 i SpecialFlag="Y" s PayorRate=0,DiscRate=0
 
 s DiscPrice=Price*DiscRate
 i (LimitedPrice'="")&((Price-DiscPrice)>LimitedPrice) s InsPrice=LimitedPrice*PayorRate
 e  s InsPrice=(Price-DiscPrice)*PayorRate
 s PatPrice=(Price-DiscPrice)-InsPrice
 q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
}

ClassMethod GetOrderPrice(pattype, instype, arcim, sttdate, prior, instr, linkto, oeprice, HospID, ExpStr As %String = "")
{
 s HospID=$g(HospID)
 n (pattype,instype,arcim,sttdate,prior,instr,linkto,oeprice, HospID,ExpStr)
 s pattype=$g(pattype),instype=$g(instype),arcim=$g(arcim),sttdate=$g(sttdate)
 s prior=$g(prior),instr=$g(instr),linkto=$g(linkto),oeprice=$g(oeprice)
 s Price=0,DiscPrice=0,InsPrice=0,PatPrice=0
 s Conf=$o(^DHCTarC("CF","")) q:Conf="" Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
 s ExecuDate=""
 f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) q:ExecuDate=""  d
 .q:ExecuDate>sttdate
 .s OLT=""
 .f  s OLT=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,OLT)) q:OLT=""  d
 ..s EndDate=$p(^DHCOLT(OLT),"^",5)
 ..i EndDate="" s EndDate=+$H+31
 ..q:EndDate<sttdate
 ..s qty0=$p(^DHCOLT(OLT),"^",3)
 ..s Itm=$p(^DHCOLT(OLT),"^",2)
 ..s err=..GetItmPrice(Itm,sttdate,instype,pattype,oeprice,HospID,ExpStr)
 ..s Price=$p(err,"^",1)*qty0+Price
 ..s DiscPrice=$p(err,"^",2)*qty0+DiscPrice
 ..s InsPrice=$p(err,"^",3)*qty0+InsPrice
 ..s PatPrice=$p(err,"^",4)*qty0+PatPrice
 i ($p($g(^DHCTarC("CF",Conf)),"^",6)="Y")&(linkto="")&(instr'="") d
 .s ExecuDate=""
 .f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,instr_"Z",ExecuDate)) q:ExecuDate=""  d
 ..q:ExecuDate>sttdate
 ..s OLT=""
 ..f  s OLT=$o(^DHCOLT(0,"ARCIM",arcim,instr_"Z",ExecuDate,OLT)) q:OLT=""  d
 ...s EndDate=$p(^DHCOLT(OLT),"^",5)
 ...i EndDate="" s EndDate=+$H+31
 ...q:EndDate<sttdate
 ...s qty0=$p(^DHCOLT(OLT),"^",3)
 ...s Itm=$p(^DHCOLT(OLT),"^",2)
 ...s err=..GetItmPrice(Itm,sttdate,instype,pattype,oeprice,HospID,ExpStr)
 ...s Price=$p(err,"^",1)*qty0+Price
 ...s DiscPrice=$p(err,"^",2)*qty0+DiscPrice
 ...s InsPrice=$p(err,"^",3)*qty0+InsPrice
 ...s PatPrice=$p(err,"^",4)*qty0+PatPricez
 q Price_"^"_DiscPrice_"^"_InsPrice_"^"_PatPrice
}

ClassMethod GetSTP(PatType, StDate)
{
 n (PatType,StDate)
 s Conf=$o(^DHCTarC("CF","")) q:Conf="" "P0"
 s:StDate="" StDate=+$H
 s StDate0=StDate+1
 i $g(PatType)="" s STP=$p(^DHCTarC("CF",Conf),"^",1) q STP
 s ExeDate=$o(^DHCTAREP(0,"EP",PatType,StDate0),-1)
 i ExeDate="" s STP=$p(^DHCTarC("CF",Conf),"^",1) q STP
 s stp=$o(^DHCTAREP(0,"EP",PatType,ExeDate,""))        
 i stp="" s STP=$p(^DHCTarC("CF",Conf),"^",1)
 e  s STP=$p(^DHCTAREP(stp),"^",2)
 q STP
}

ClassMethod UpdateTarPrice(AdjNo, NewDate, Newprice, NewUser, PN)
{
 n (AdjNo,NewDate,Newprice,NewUser,PN)
 q:AdjNo="" 0
 s Newprice=+$g(Newprice)
 ;Start a Transaction
 s $ZT="ERROR^DHCSSERR" d ..tb() 
 i PN=""!(PN=0) &SQL(UPDATE DHC_TarItemPrice SET TP_StartDate=:NewDate,TP_Price=:Newprice,TP_UpdateUser=:NewUser
          WHERE TP_AdjustNo=:AdjNo)
 i PN=1 &SQL(UPDATE DHC_TarItemPrice SET TP_StartDate=:NewDate,TP_AlterPrice1=:Newprice,TP_UpdateUser=:NewUser
          WHERE TP_AdjustNo=:AdjNo)
 i PN=2 &SQL(UPDATE DHC_TarItemPrice SET TP_StartDate=:NewDate,TP_AlterPrice2=:Newprice,TP_UpdateUser=:NewUser
          WHERE TP_AdjustNo=:AdjNo)
 d ..tc()
 q 0
}

ClassMethod tb()
{
 n SQLCODE
 TSTART  s SQLCODE=$zu(34)
 q
}

ClassMethod tc()
{
 n SQLCODE
 i $$intp^%qartp TCOMMIT  s SQLCODE=$zu(34)
 q
}

ClassMethod AlterRate(Rate As %String, Price As %String) As %String
{
 If $g(Rate)="" Quit "^"
 Set RateLevel=$P($g(Rate),"^",3)
 Set AlterPayorRate=$P($g(Rate),"^",4)
 If RateLevel="" Quit $P($g(Rate),"^",1)_"^"_$P($g(Rate),"^",2)
 If AlterPayorRate="" Quit $P($g(Rate),"^",1)_"^"_$P($g(Rate),"^",2)
 If $g(Price)="" Quit $P($g(Rate),"^",1)_"^"_$P($g(Rate),"^",2)
 Set RateLevel=+$g(RateLevel)
 Set Price=+$g(Price)
 If Price>RateLevel Quit $P($g(AlterPayorRate),"^",1)_"^"_$P($g(AlterPayorRate),"^",4)
 Quit $P($g(Rate),"^",1)_"^"_$P($g(Rate),"^",2)
}

}
