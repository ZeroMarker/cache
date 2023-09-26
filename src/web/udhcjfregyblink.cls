Import SQLUser

Class web.udhcjfregyblink Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod getregno(itmjs As %Library.String = "", itmjsex As %Library.String = "", val)
{
  q:(val="") "0^^"
  s cfrowid="0"
  s cfrowid=$o(^DHCCARDi("CF",0,"CardNo",val,cfrowid))
  s num=0
  s papmidr=""
  s papno=""
  i cfrowid'=""  d
  .s papmidr=$p(^DHCCARD("CF",cfrowid),"^",4)
  .s papno=$p(^DHCCARD("CF",cfrowid),"^",6)
  i papno'=""  d
  .s num=1
  e  d
  .s num=0
  q num_"^"_papmidr_"^"_papno
}

ClassMethod getcardno(itmjs As %Library.String = "", itmjsex As %Library.String = "", val)
{
  q:(val="") "0^"
  s cfrowid="0"
  s cfrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",val,cfrowid))
  s num=0
  s cardno=""
  i cfrowid'=""  d
  .s cardno=$p(^DHCCARD("CF",cfrowid),"^",2)
  i cardno'=""  d
  .s num=1
  e  d
  .s num=0
  q num_"^"_cardno
}

ClassMethod insertcardno(itmjs As %Library.String = "", itmjsex As %Library.String = "", val)
{
  q:(val="") "1"
  k PLIST
  k PLIST(1)
  s papno=$p(val,"^",1)
  s papdr=$p(val,"^",2)
  s cardno=$p(val,"^",3)
  s userid=$p(val,"^",4)
  s carddate=+$h
  s cardtime=$p($h,",",2)
  s PLIST(3)=cardno
  s PLIST(5)=papdr
  s PLIST(7)=papno
  s PLIST(8)=carddate
  s PLIST(9)=cardtime
  s PLIST(10)=userid
  s PLIST(11)="N"
  s err=##class(UDHCCardRef).INSERT()
  q err
}

ClassMethod getpapmidr(val)
{
  q:(val="") ""
  s papmidr=""
  s papmidr=$o(^PAPERi("PAPMI_PatNo",val,""))
  q:(papmidr="") ""
  q papmidr
}

}
