Import sqluser

/// Descript:点评公共方法
/// Creater: wxj
/// CreateDate: 2019-11-15
Class web.DHCSTMHUI.CommentCommon Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:根据点评明细id获取点评明细的状态
/// 0--不合理未申诉 1--合理	2--已申诉未审核	3--已接受 4--未点评
/// w ##class(web.DHCSTMHUI.CommentCommon).GetDeatilStatus("3||1")
ClassMethod GetDeatilStatus(ComItmId) As %Library.String
{
    n (ComItmId)
    q:ComItmId="" ""
    s status=0
    s current=$LG(^User.DHCMatCommentsD(+ComItmId,"ChildDHCMatCommentsItm",$p(ComItmId,"||",2)),3)
    q:current="" 4	;未点评
    q:current="Y" 1	;点评合理
    s recheckid=""
    f {
    	s recheckid=$o(^User.DHCMatCNTOrdReCheckI("DHCSTMCRCIndex",ComItmId,recheckid)) 
	 	q:recheckid=""
	 	s ActiveFlag=$lg(^User.DHCMatCNTOrdReCheckD(recheckid),12)
	 	continue:ActiveFlag="N"
	 	s DocNote=$lg(^User.DHCMatCNTOrdReCheckD(recheckid),4)
    	s:$zcvt(DocNote,"U")="ACCEPT" status=3
    	s:($zcvt(DocNote,"U")'="")&&($zcvt(DocNote,"U")'="ACCEPT") status=2
    	q:status'=0
    }
    q status
}

/// Descript:根据点评单id获取点评单的状态
/// 0-未点评	1-点评中	2-点评完成	3-已提交
/// w ##class(web.DHCSTMHUI.CommentCommon).GetMainStatus("2")
ClassMethod GetMainStatus(ComId) As %Library.String
{
    n (ComId)
    q:ComId="" ""
    s status=0
    s submitflag=$LG(^User.DHCMatCommentsD(ComId),7)
    q:submitflag="Y" 3	;已提交
    s Ch=""
    s comFlag=0,unComFlag=0
    f  s Ch=$o(^User.DHCMatCommentsD(ComId,"ChildDHCMatCommentsItm",Ch)) q:(Ch="")||(status'=0)  d
    .s current=$LG(^User.DHCMatCommentsD(ComId,"ChildDHCMatCommentsItm",Ch),3)
    .s:current'="" comFlag=1
	.s:current="" unComFlag=1
	.s:(comFlag=1)&&(unComFlag=1) status=1	;点评中
	s:(comFlag=1)&&(unComFlag=0) status=2	;点评完成
    q status
}

/// Description : 检查该点评单是否符合点评单结果条件
/// Input : ComId - 点评主表ID , RetState - 点评结果条件(1-仅合理,2-仅不合理且医生未处理,3-仅医生已申诉,4-仅已接受)
/// Output : 0 - 不符合 , 1 - 符合 
/// w ##class(web.DHCSTMHUI.CommentCommon).ChkComResult(1,1)
ClassMethod ChkComResult(ComId, RetState) As %String
{
	n (ComId,RetState)
	q:RetState="" 1
	s ChkRet=0
	s Ch=""
	f  s Ch=$o(^User.DHCMatCommentsD(ComId,"ChildDHCMatCommentsItm",Ch)) q:(Ch="")||(ChkRet'=0)  d
	.s ComItmId=ComId_"||"_Ch
	.s DetailRet=..GetDeatilStatus(ComItmId)
	.s:(RetState=1)&&(DetailRet=1) ChkRet=1
	.s:(RetState=2)&&(DetailRet=0) ChkRet=1
	.s:(RetState=3)&&(DetailRet=2) ChkRet=1
	.s:(RetState=4)&&(DetailRet=3) ChkRet=1
	q ChkRet
}

/// Description : 检查该点评明细是否符合点评单结果条件
/// Input : Curret - 点评结果 , retState - 点评结果条件(1-仅有结果,2-仅无结果,3-仅合理,4-仅不合理,5-仅医生申诉未审核) 
/// 		ComItmId - 点评子表id
/// Output : 0 - 不符合 , 1 - 符合
/// DeBug : 
/// w ##class(PHA.PRC.Create.Main).ChkItmResult(,)
ClassMethod ChkItmResult(Curret, RetState, ComItmId) As %String
{
	q:RetState="" 1 
	q:(RetState=1)&&(Curret'=4) 1
	q:(RetState=2)&&(Curret'="") 0
	q:(RetState=2)&&(Curret="") 1
	q:(RetState=3)&&(Curret="Y") 1
	q:(RetState=4)&&(Curret="N") 1
	s ComId=$p(ComItmId,"||",1)
	s Ch=$p(ComItmId,"||",2)
	s ret=0
	i RetState=5 d
	.s recheckid=""
    .f  s recheckid=$o(^User.DHCMatCNTOrdReCheckD(recheckid)) q:(recheckid="")||(status'=0)  d
    ..s comitmid=$LG(^User.DHCMatCNTOrdReCheckD(recheckid),2)
    ..q:ComItmId'=comitmid
    ..s ActiveFlag=$lg(^User.DHCMatCNTOrdReCheckD(recheckid),12)
    ..q:ActiveFlag="N"
    ..s DocNote=$lg(^User.DHCMatCNTOrdReCheckD(recheckid),4)
    ..s:$zcvt(DocNote,"U")="ACCEPT" status=3
    ..s:($zcvt(DocNote,"U")'="")&&($zcvt(DocNote,"U")'="ACCEPT") status=2
	
	.s subId=""
	.f  s sub=$o(^DHCPHCNTS(pcntsId,"I",chlId,"L",subId),-1) q:(subId="")||(ret'=0)  d
	..s logData=$g(^DHCPHCNTS(pcntsId,"I",chlId,"L",subId))
	..s active=$p(logData,"^",11)
	..q:active'="Y"
	..s docNote=$p(logData,"^",10)  	//医生备注
	..q:docNote=""
	..s ret=1
	q ret
}

}
