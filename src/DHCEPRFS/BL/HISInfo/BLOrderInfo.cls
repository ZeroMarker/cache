Class DHCEPRFS.BL.HISInfo.BLOrderInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	根据医嘱号 获取就诊号
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetEpisodeIDByOrd("5366809")	
ClassMethod GetEpisodeIDByOrd(AOrdID As %String) As %String
{
	s:(AOrdID = $c(0)) AOrdID = ""
	q:(AOrdID = "") ""
	
	s ord = ^OEORD(AOrdID)
	q:(ord = "") ""
	
	s episodeID = $p(ord,"^",1)
	q episodeID
}

/// Desc:	根据就诊号 获取医嘱信息
/// Debug:	d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLOrderInfo","QueryOrderByAdm","10259")
Query QueryOrderByAdm(AEpisodeID As %String) As %SQLQuery
{
  	select OEORI_Rowid as OrderItemRowid, OEORI_ItmMast_DR as ARCIMRowid, OEORI_ItmMast_DR->ARCIM_Desc as OrderName, OEORI_SttDat as OrderSttDate, OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType as OrderType
	from SQLUser.OE_OrdItem 
	where  OEORI_OEORD_PARREF->OEORD_ADM_DR=:AEpisodeID
	order by OEORI_SttDat desc
}

/// Desc:	根据就诊取所有检查医嘱id
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetPACSOrdIdByAdm("10958144")
ClassMethod GetPACSOrdIdByAdm(AEpisodeID As %String) As %String
{
	s ret = ""
	s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLOrderInfo:QueryOrderByAdm")
	s sc = rset.Execute(AEpisodeID)
	
	while (rset.Next())
	{
		s OrderItemRowid = rset.Data("OrderItemRowid")
		s ARCIMRowid = rset.Data("ARCIMRowid")
		s OrderName = rset.Data("OrderName")
		s OrderSttDate = rset.Data("OrderSttDate")
		s OrderType = rset.Data("OrderType")
		continue:(ARCIMRowid = "")
		s ServerMaterial=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
		if ((" Service S ")[(" "_ServerMaterial_" "))
		{
			s order = $p(OrderItemRowid,"||",1)
			s orderSub = $p(OrderItemRowid,"||",2)
			s orderIDParam = order_"_"_orderSub
			
			//s TypeClass="检查"
			if (ret = "")
			{
				s ret = orderIDParam	
			}
			else
			{
				s ret = ret_"^"_orderIDParam
			}
		} 
	}
	
	q ret
}

/// Desc:	根据Adm取是否有病理  1 为有 0 为无
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetPathologyInfo("11141404")
ClassMethod GetPathologyInfo(Adm As %String) As %String
{
	q:Adm="" 0
	s ret=0
	s Adm=$g(Adm)
	s Ord="" f  s Ord=$o(^OEORD(0,"Adm",Adm,Ord)) q:Ord=""  d
	.s chl=0 f  s chl=$o(^OEORD(Ord,"I",chl)) q:chl=""  d
	..q:'$d(^OEORD(Ord,"I",chl,1))
 	..s Arcimid=$p(^OEORD(Ord,"I",chl,1),"^",2)  //医嘱项id
    ..s Arcimdesc=$p(^ARCIM(+Arcimid,$p(Arcimid,"||",2),1),"^",2) //医嘱名称
	..s ARCCATRowid=$p(^ARCIM(+Arcimid,1,1),"^",10)	 //取医嘱子分类  ARCItemCat
	..s itmcatdr=$p(^ARCIM(+Arcimid,$p(Arcimid,"||",2),1),"^",10)
	..s Status=$p(^OEORD(Ord,"I",chl,1),"^",13) //医嘱状态
	..q:((Status'="1")&&(Status'="6"))
	..s itmcode=$p(^ARC("IC",itmcatdr),"^",1)  //医嘱子Code
	..i ((itmcode="PATHOLOGY01")||(itmcode="PATHOLOGY02")||(itmcode="BL07")) d
 	...s ret=1 
	q ret
}

/// Desc:	预估医嘱张数
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetOrdPages("14403471","temp")
ClassMethod GetOrdPages(AEpisodeID As %String, ALongOrTemp As %String) As %String
{
	s admDeptId=$p(^PAADM(AEpisodeID),"^",4)
	s Ordnumber=0 //医嘱数量
    s ret="" //页码数
    s TransNu= 1
    s TransNu=..GetTranLocNew(AEpisodeID) //获取转科记录。
    f i=1:1:TransNu
    {
    	i ALongOrTemp="temp" s rs=##class(%ResultSet).%New("web.DHCTEMPOERPRINT:GetTempOrd")
      	e  s rs=##class(%ResultSet).%New("web.DHCLONGTIMEORD:GetLongOrd")
      	d rs.Execute(AEpisodeID, "", "", "", 1,3880,i, "" ,"","","","","")
   		while(rs.Next()){
       		s Ordnumber=Ordnumber+1
     	}
   		d rs.Close()
     }
     //一页显示25条医嘱
  	i Ordnumber=0 s ret=0
  	e  i (Ordnumber#25)=0 s ret=(Ordnumber#25)
  	e  s ret=(Ordnumber#25)+1
    q ret
}

/// Desc:	是否有长期医嘱需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).HasCQordToPrint("10312318")
ClassMethod HasCQordToPrint(AEpisodeID) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s printInfo = ##class(Nur.NIS.Service.OrderSheet.Sheet).ifExistSheetOrder(AEpisodeID,"L") 
	//s printInfo = ##Class(web.DHCNurseInterface).ifLongTimeOrderExist(AEpisodeID)
	q:(printInfo '= "0") "1"
	q "0"
}

/// Desc:	是否有临时医嘱需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).HasLSordToPrint("10312318")
ClassMethod HasLSordToPrint(AEpisodeID) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")	

	s printInfo = ##class(Nur.NIS.Service.OrderSheet.Sheet).ifExistSheetOrder(AEpisodeID,"T")
	//s printInfo = ##class(web.DHCNurseInterface).ifTempTimeOrderExist(AEpisodeID)	
	q:(printInfo '= "0") "1"
	q "0"
}

/// Desc:	根据就诊号 获取转科科室数量
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).GetTranLocNew("10312318")
ClassMethod GetTranLocNew(Adm) As %String
{
	s LocStr=""
    d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(Adm)
	s AdmLoc=$P(^PAADM(Adm),"^",4)
	s i=0
	s no="" f  s no=$O(^TMP($J,"loc",Adm,no)) q:no=""  d
	.s Dep=""  f  s Dep=$O(^TMP($J,"loc",Adm,no,Dep)) q:Dep=""  d
	..s DepDes=$P(^CTLOC(Dep),"^",2)
	..s i=i+1
	q i
}

}
