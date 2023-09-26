Class DHCEPRFS.BL.HISInfo.BLFeeInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	读卡器activex的dll的object标签	
/// Debug:	d ##Class(DHCEPRFS.BL.HISInfo.BLFeeInfo).WriteCardReaderActiveXObj()
ClassMethod WriteCardReaderActiveXObj()
{
	d ##class(web.UDHCCardCommLinkRegister).GetCardHardJSFunction()
}

/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLFeeInfo).HasFeeDetail("5935992")
ClassMethod HasFeeDetail(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") "0"
	
	s motherAdmDR = $P($G(^PAADM(AEpisodeID)),"^",75)
	q:(motherAdmDR'="") "0"
	
	q "1"
}

/// Desc:	病案费用信息：按照费用大类，一般24项
/// Output：
/// Others：
/// Debug: w ##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareNew(adm,"")
ClassMethod InPatCostTrakCareNew(argAdmId As %String, argHospital As %String = "") As %String
{
	// 依照病案大类取费用(SQL:DHC_TarMc )(Global：^DHCTarC("TMC",rowid) )
	q:(($d(argAdmId)=0)||(argAdmId="")) ""

		s UniqueId=""
		s UniqueId=$i(^CacheTemp)
		k ^CacheTempPatMcCate(UniqueId),PLIST
		
		// 取费用大类信息
		s n=1
		s rowid="0"
		f  s rowid=$o(^DHCTarC("TMCNew",rowid))  q:rowid=""  d
		.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
		.i $p(^DHCTarC("TMCNew",rowid),"^",1)'="" d
		..s acctdesc=$p($p(^DHCTarC("TMCNew",rowid),"^",1),$c(1))  //DHC_TarMc  -> TARTMC_Code
		..s acctdesc2=$p($p(^DHCTarC("TMCNew",rowid),"^",2),$c(1)) //DHC_TarMc  -> TARTMC_Desc
		..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
		..s ^CacheTempPatMcCate(UniqueId)=n
		..s PLIST(n)=acctdesc
		..s n=n+1
	
		// 初始化
		s argAdmId=$g(argAdmId)
		q:(argAdmId="") 0
		s sum=0, P9=""
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s itmfee(i)=0
		
		// 将病人费用按费用大类归并
		s rowid=""
		f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
		.s pboid=""
		.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
		..s pbdid="0"
		..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
		...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
		...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
		...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
		...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
		...i totalamount=""  s totalamount=0
		...s sum=sum+totalamount
		...q:(taritem="")
		...q:($d(^DHCTARI(taritem))=0)
		...s subcate=$p(^DHCTARI(taritem),"^",30)
		...q:(subcate="")
		...//b
		...s acctcate=$p($g(^DHCTarC("MCNew",subcate)),"^",3)
		...q:(acctcate="")
		...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
		.....s itmfee(i)=totalamount+itmfee(i)
	
		// 将归并后的费用信息拼成字符串
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s P9=P9_"!"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",2)_"^"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
		s P9="Total^总费用^"_$fn(sum,"",2)_P9
		
		k ^CacheTempPatMcCate(UniqueId)
		
		q P9
}

/// Desc:	病案费用信息：按照费用子类
/// Output:	
/// Others:
ClassMethod InPatCostTrakCareSubNew(argAdmId As %String, argHospital As %String = "") As %String
{
	// 依照病案子类取费用(SQL:DHC_TarMrCate )(Global：^DHCTarC("MC",rowid) )
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""

	
		s UniqueId=$i(^CacheTemp)
		k ^CacheTempPatMcCate(UniqueId),PLIST
		
		// 取费用子类信息
		s n=1
		s rowid="0"
		f  s rowid=$o(^DHCTarC("MCNew",rowid))  q:rowid=""  d
		.i $g(^CacheTempPatMcCate(UniqueId))="" s ^CacheTempPatMcCate(UniqueId)=0
		.i $p(^DHCTarC("MCNew",rowid),"^",1)'="" d
		..s acctdesc=$p($p(^DHCTarC("MCNew",rowid),"^",1),$c(1)) //DHC_TarMrCate -> TARMC_Code
		..s acctdesc2=$p($p(^DHCTarC("MCNew",rowid),"^",2),$c(1)) //DHC_TarMrCate -> TARMC_Desc
		..s ^CacheTempPatMcCate(UniqueId,n)=$p(rowid,$c(1))_"^"_acctdesc_"^"_acctdesc2
		..s ^CacheTempPatMcCate(UniqueId)=n
		..s PLIST(n)=acctdesc
		..s n=n+1
		
		
		// 初始化
		s argAdmId=$g(argAdmId)
		q:(argAdmId="") 0
		s sum=0, P9=""
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s itmfee(i)=0
		
		// 将病人费用信息按费用子类归并
		s rowid=""
		f  s rowid=$o(^DHCPB(0,"ADM",argAdmId,rowid))  q:rowid=""  d
		.s pboid=""
		.f  s pboid=$o(^DHCPB(rowid,"O",pboid))  q:pboid=""  d
		..s pbdid="0"
		..f  s pbdid=$o(^DHCPB(rowid,"O",pboid,"D",pbdid))  q:pbdid=""  d
		...s taritem=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",3)     
		...s unitprice=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",4)   
		...s qty=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",5)         
		...s totalamount=$p(^DHCPB(rowid,"O",pboid,"D",pbdid),"^",7)
		...i totalamount=""  s totalamount=0
		...s sum=sum+totalamount
		...q:(taritem="")
		...q:($d(^DHCTARI(taritem))=0)
		...s subcate=$p(^DHCTARI(taritem),"^",30)  //DHC_TarMrCate -> Rowid
		...q:(subcate="")
		...//b
		...s acctcate=subcate
		...q:(acctcate="")
		...f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		....i $p(acctcate,$c(1))=$p($p(^CacheTempPatMcCate(UniqueId,i),"^",1),$c(1)) d
		.....s itmfee(i)=totalamount+itmfee(i)
		
		// 将归并后的费用信息拼成字符串
		f i=1:1:$g(^CacheTempPatMcCate(UniqueId)) d
		.s P9=P9_"!"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",2)_"^"_$p($g(^CacheTempPatMcCate(UniqueId,i)),"^",3)_"^"_$fn(itmfee(i),"",2)
		s P9="Total^总费用^"_$fn(sum,"",2)_P9
		
		k ^CacheTempPatMcCate(UniqueId)
		
		q P9
}

}
