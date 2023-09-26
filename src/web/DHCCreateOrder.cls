Class web.DHCCreateOrder Extends DHCDoc.Util.RegisteredObject
{

/// d ##class(web.DHCCreateOrder).CreateOrder("2018-05-04","2018-05-05","0000000290",315,5)
ClassMethod CreateOrder(StartDate As %String, EndDate As %String, PatientNo As %String, EpisodeID As %String, WardID As %String)
{
	s ^tempscl("CreateOrder")=StartDate_","_EndDate_","_PatientNo_","_EpisodeID_","_WardID
	Set:StartDate["/" StartDate=$zdh(StartDate,4)
	Set:EndDate["/" EndDate=$zdh(EndDate,4)
	Set:StartDate["-" StartDate=$zdh(StartDate,3)
	Set:EndDate["-" EndDate=$zdh(EndDate,3)
  	;i (PatientNo="")&(EpisodeID="") q -1
  	s armcat="",currcat="0"
	
  	f  s currcat=$o(^ARC("IC",0,"OrderType","R",currcat)) q:(currcat="")  d
    .i armcat=""  s armcat=currcat
    .e  s armcat=armcat_"^"_currcat
      /* 
    s StartDate=StartDate-1
  	s EndDate=EndDate-1
  	*/
 
  	i PatientNo=""  d
   	.s ret=..DoAllWardOrd(StartDate,EndDate,WardID,armcat) 
  	e  d
   	.s ret=..DoPatAdmOrd(StartDate,EndDate,EpisodeID,armcat)
  	q ret
}

ClassMethod DoAllWardOrd(st, dateto, ward, itmcat)
{
	;超过30分钟自动清除未完成标记
	i ((+$h_..%SysTime())-+$g(^DHCDocCreatLongOrder("Working",ward)))>..%ZTH("00:30:00",1) {
		Kill ^DHCDocCreatLongOrder("Working",ward)
	}
	q:$d(^DHCDocCreatLongOrder("Working",ward)) -101
  	s ^DHCDocCreatLongOrder("Working",ward)=..%SysDate()_..%SysTime()
  	s err=""
  	/*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
    Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
    Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
    ZN MEDDATA  
	s err=$$prechapt^DHCDocCreatLongOrder(st,dateto,ward,itmcat)  q:$g(err)'=0 -1
	ZN CurrentNS
	*/
	s err=..prechapt(st,dateto,ward,itmcat) 
	k ^DHCDocCreatLongOrder("Working",ward)
	q:$g(err)'=0 -1
	q err
}

ClassMethod DoPatAdmOrd(st, dateto, padm, itmcat) As %String
{
	;超过30分钟自动清除未完成标记
	i ((+$h_..%SysTime())-+$g(^DHCDocCreatLongOrder("Working",padm)))>..%ZTH("00:30:00",1) {
		Kill ^DHCDocCreatLongOrder("Working",padm)
	}
	q:$d(^DHCDocCreatLongOrder("Working",padm)) -101
  	s ^DHCDocCreatLongOrder("Working",padm)=..%SysDate()_..%SysTime()
    s err=""
    /*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace            ;得到当前的MEDTRAK的NameSpace,保存到MEDDATA中
    Set LABDATA=Config.LabDataNamespace         ;得到当前的LABTRAK的NameSpace,保存到LABDATA中
    Set CurrentNS=$ZNSPACE                      ;保存当前所用的NameSpace  
    ZN MEDDATA 
        
	s err=$$prechaptadm^DHCDocCreatLongOrder(st,dateto,padm,itmcat) q:$g(err)'=0 -1
	ZN CurrentNS
	*/
	s err=..prechaptadm(st,dateto,padm,itmcat) 
	k ^DHCDocCreatLongOrder("Working",padm) 
	q:$g(err)'=0 -1
	q err
}

ClassMethod prechapt(datefrom, dateto, ward, subcat)
{
	;subcat 是要滚动所有医嘱子类rowid 的字符串，如“23^34^35”
	;d prechapt^DHCDocCreatLongOrder(62443,62444,56,"")

 	q:$g(ward)="" "-1"
 	;
 	for date=datefrom:1:dateto do
 	.s index=$o(^TSABatch($zn,date,"Day",$j,""),-1)+1
 	.s ^TSABatch($zn,date,"Day",$j,index)="Pre Standing Order Batch Start : "_$h
 	.;w !,$zn,"Pre Standing Order Batch Start : "_$h
 	.set room="" for  set room=$o(^PAADMi("CurrWard",ward,room)) q:room=""  do
 	..set adm="" for  set adm=$o(^PAADMi("CurrWard",ward,room,adm)) q:adm=""  do
 	...s err=$$oneadm^CHPAT13NEW(adm,date,subcat,"PRE","R")
  	...;s err=$$oneadm^CHPAT13(adm,date-1,subcat,"PRE","")
	.s index=$o(^TSABatch($zn,date,"Day",$j,""),-1)+1
 	.s ^TSABatch($zn,date,"Day",$j,index)="Pre Standing Order Batch End : "_$h  
 	.;w !,$zn_"Pre Standing Order Batch End : "_$h
 	q 0
}

ClassMethod prechaptadm(datefrom, dateto, adm, subcat) As %String
{
 	q:$g(adm)="" "-1"
 	q:$g(subcat)="" "-1"
 	;
 	for date=datefrom:1:dateto do
 	.s index=$o(^TSABatch($zn,date,"Day",$j,""),-1)+1
 	.s ^TSABatch($zn,date,"Day",$j,index)="Pre Standing Order Batch Start : "_$h
 	.;w !,$zn,"Pre Standing Order Batch Start : "_$h
 	.s err=$$oneadm^CHPAT13NEW(adm,date,subcat,"PRE","R")
 	.s index=$o(^TSABatch($zn,date,"Day",$j,""),-1)+1
 	.s ^TSABatch($zn,date,"Day",$j,index)="Pre Standing Order Batch End : "_$h  
 	.;w !,$zn_"Pre Standing Order Batch End : "_$h
 	;
 	q 0
}

}
