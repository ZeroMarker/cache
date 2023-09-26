Class web.DHCANCall Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod InsertAnOrder(opaId As %String, userId As %String, locId As %String, docUserId As %String) As %String
{
	n (opaId, userId, locId, docUserId)
	//DHCDocOrderCommon.mac,InsertMultiple(Adm, OrdItemStr, User , Loc , Doc , LABDATA )
	//q "0^1"  //ypz temp 060303
	q:(opaId="") -1
	s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
 	s inDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
 	s inTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",40)
 	s outDate=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",41)
 	s outTime=$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",42)
 	s anoId=0,resStr=-2
 	f  s anoId=$o(^DHCANOrder("Order",0,"OPApp",opaId,anoId)) q:anoId=""  d
    	.s anoEditFlag=$p(^DHCANOrder("Order",anoId),"^",25)
    	.q:((anoEditFlag'="N")&(anoEditFlag'="E")) //只写正常和修改的
    	.s anoUpdateDate=$p(^DHCANOrder("Order",anoId),"^",21)
    	.s anoUpdateTime=$p(^DHCANOrder("Order",anoId),"^",22)
    	.q:(anoUpdateDate<inDate)!((anoUpdateDate=inDate)&(anoUpdateTime<inTime))
    	.;q:(anoUpdateDate>outDate)!((anoUpdateDate=outDate)&(anoUpdateTime<outTime)) //??离室后的允许插入?
    	.//admId,arcim^qty^recloc^price^specimen^admreason
    	.s oriStr=$p(^DHCANOrder("Order",anoId),"^",9)_"^"_$p(^DHCANOrder("Order",anoId),"^",11)_"^"_$p(^DHCANOrder("Order",anoId),"^",26)_"^^"
    	.//Adm,OrdItemStr,User,Loc,LABDATA,DocUserId
    	.s resStr=##class(web.DHCOPCashier).CashierInsertOrdItem(+anaId,oriStr,userId,locId,docUserId,1)
    	.
    	.//w oriStr_"/"_resStr,!
	q resStr
}

/// 返回：第一级^分割的接收科室串，第二级以#c(3)分割为科室Id，科室名
ClassMethod GetOrderItemRecloc(opaId As %String, arcimId As %String, EpisodeID As %String = "", recLocId = "") As %String
{
	//web.DHCDocOrderCommon.GetLocRecLoc
	n (opaId, arcimId, EpisodeID,recLocId)
	q:arcimId="" -3
	i EpisodeID="",opaId'="" s EpisodeID=+$p(^DHCANOPArrange(opaId),"^",2)
	//q:(+EpisodeID=0) -2
	s Config=##Class(websys.Configuration).%OpenId(1)
	s MEDDATA=Config.DataNamespace
	s LABDATA=Config.LabDataNamespace
	s CurrentNS=$ZNSPACE
	zn MEDDATA
	s retStr=$$getall^aOET3a(EpisodeID,arcimId,recLocId)
	i retStr'="0" k PLIST //w "kill",!
	s retStr=""
	s inum=0
	f  s inum=$o(PLIST(inum))  q:inum=""  d
		.//w PLIST(inum)," /"_$p(PLIST(inum),$c(2),3),!
		.q:$p(PLIST(inum),$c(2),3)'="Y"
		.s PLIST(inum)=$tr(PLIST(inum),$c(2),$c(3))
		.i retStr'="" s retStr=retStr_"^"
		.s retStr=retStr_PLIST(inum)
	zn CurrentNS
	q retStr
}

ClassMethod InsertOrderItem(EpisodeID, oeoriStr, userId, locId, docId, LABDATA) As %String
{
	n (EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
	q:(EpisodeID="")!(oeoriStr="")!(userId="")!(locId="")!(docId="")!(LABDATA="") "0^输入数据有误!"
	
	
	s Config=##Class(websys.Configuration).%OpenId(1)
    s MEDDATA=Config.DataNamespace
    s CurrentNS=$ZNSPACE
    zn MEDDATA     //转换命名空间

	s NewUpdate=1
	s retStr=$$InsertMultiple^DHCDocOrderCommon(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
	s NewUpdate=0
	
	zn CurrentNS   //恢复命名空间
	
	s NeedCreateAdmSheets=##class(web.DHCOEOrdItem).NeedCreateAdmSheets(retStr)
	i NeedCreateAdmSheets=1 d ##class(web.DHCOEOrdItem).InsertAdmSheets(EpisodeID,retStr,userId,locId)
	d ##class(web.DHCOEOrdItem).UpdateOrderStatus(retStr,EpisodeID,userId)
	q retStr
}

}
