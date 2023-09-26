Import sqluser

/// Descript:付款封面汇总
/// Creater:    zhangxiao
/// CreateDate:	2017-10-24
/// 
Class web.DHCSTMHUI.PayCoverStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PayCoverStat","PayCoverStat","2017-10-20","2017-10-23","153")	
Query PayCoverStat(StartDate As %String, EndDate As %String, Loc As %String) As Query(ROWSPEC = "RecRetI,gdNo,vendorName,rpamt:%Float,type,vendor") [ SqlProc ]
{
}

ClassMethod PayCoverStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Loc As %String) As %Status
{
 n (qHandle,StartDate,EndDate,Loc)
 ;s ^zx(2)=$lb(StartDate,EndDate,Loc)
 S repid=$I(^CacheTemp)
 S ind=1
 S qHandle=$lb(0,repid,0)
 Q:Loc="" ""
 Q:StartDate="" ""
 Q:EndDate="" ""
 S:StartDate["-" StartDate=$zdh(StartDate,3)
 S:EndDate["-" EndDate=$zdh(EndDate,3)
 S:StartDate["/" StartDate=$zdh(StartDate,4)
 S:EndDate["/" EndDate=$zdh(EndDate,4)
 
 s stkType=..sssCode()
 
 f Date=StartDate:1:EndDate  d
 .s CvrId=""
 .f  s CvrId=$o(^DHCINGRCover(0,"DATE",Loc,Date,CvrId)) q:CvrId=""  d
 ..q:+CvrId=0
 ..s ingr=0
 ..f  s ingr=$o(^DHCINGR(0,"DO",CvrId,ingr)) q:ingr=""   d
 ...s ch=0,ingri="",rpamt=0,vendor="",vendorName="",gdNo=""
 ...s gdNo=$p(^DHCINGR(ingr),"^",1)
 ...s vendor=$p(^DHCINGR(ingr),"^",3)
 ...s:vendor'="" vendorName=$p(^APC("APCVM",vendor),"^",3)
 ...s type="G"
 ...f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:ch=""   d
 ....s rpamt=$p(^DHCINGR(ingr,"GRI",ch),"^",31)
 ....s ingri=ingr_"||"_ch
 ....d OutPutRow
 ..s ingrt=0
 ..f  s ingrt=$o(^INGRT(0,"COVER",CvrId,ingrt)) q:ingrt=""   d
 ...s ch=0,ingrti="",rpamt=0,vendor="",vendorName="",gdNo=""
 ...s gdNo=$p(^INGRT(ingrt),"^",1)
 ...s vendor=$p(^INGRT(ingrt),"^",2)
 ...s:vendor'="" vendorName=$p(^APC("APCVM",vendor),"^",3)
 ...s type="R"
 ...f  s ch=$o(^INGRT(ingrt,"DHCGRR",ch)) q:ch=""   d
 ....s rpamt=$p(^INGRT(ingrt,"DHCGRR",ch),"^",4)
 ....s rpamt=rpamt*(-1)
 ....s ingrti=ingrt_"||"_ch
 ....d OutPutRowRet
 
 Quit $$$OK
OutPutRow
 s Data=$lb(ingri,gdNo,vendorName,rpamt,type,vendor)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
OutPutRowRet
 s Data=$lb(ingrti,gdNo,vendorName,rpamt,type,vendor)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
