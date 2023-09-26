Class web.DHCBldTest Extends %RegisteredObject
{

//##Class(web.DHCBldTest).GetPackDateTime("=0160211055999|| 1")

//返回结果：病房接收日期，病房接收时间，血液输注开始日期，血液输注开始时间，血液输注结束日期，血液输注结束时间

///  ##Class(web.DHCBldTest).GetPackDateTime
ClassMethod GetPackDateTime(PackRowID) As %String
{
	s ^TMPPACK($ZN,$J,PackRowID)=""
	;Q +$H_"^"_$p($H,",",2)_"^"_+$H_"^"_$p($H,",",2)_"^"_+$H_"^"_$p($H,",",2)_"^"_"11-665"   
	s PackID=$p(PackRowID,"||",1), PackSub=$p(PackRowID,"||",2)
	s ProcductDR=$p(^TBBP(PackID,PackSub),"\",4)
	s bldproductno=$P(^TTAB("BB-BP",ProcductDR),"\",7) ;????????????
	S bldproductno=PackSub
	i '$l(bldproductno) q ""
	s bldbagno=$e(PackID,1,$l(PackID))
	s rw=$O(^Nur.BloodBagReciveI("Blood"," "_bldbagno," "_bldproductno,""))
	i '$l(rw) q ""
	   s a=##class(Nur.BloodBagRecive).%OpenId(rw)
       s recdate=a.ReciveDate
       s rectime=a.ReciveTime
	   s stdate=a.TransStartDate
	   s sttime=a.TransStartTime
	   s eddate=a.TransEdDate
	   s edutime=a.TransEdTime
	   S RecUsr=a.ReciveUser 
   Q recdate_"^"_rectime_"^"_stdate_"^"_sttime_"^"_eddate_"^"_edutime_"^"_RecUsr
}

}
