Import sqluser

Class web.DHCSTPHCMTinyDrugRegQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询拆零记录表
/// w ##class(web.DHCSTPHCMTinyDrugRegQuery).QueryTdrNoList("30","1","2015-11-10^2016-12-10")
ClassMethod QueryTdrNoList(rows As %String, page As %String, StrParam As %String) As %String
{
	n (rows,page,StrParam)
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s tdrStartDate=$p(StrParam,"^",1)    //开始日期
	s tdrStartDate=$zdh(tdrStartDate,3)
	s tdrEndDate=$p(StrParam,"^",2)      //结束日期
	s tdrEndDate=$zdh(tdrEndDate,3)
	s tdrWinDept=$p(StrParam,"^",3)      //拆零科室
	s tdrWinUser=$p(StrParam,"^",4)      //拆零人员
	s tdrChkVal=$p(StrParam,"^",5)       //单据状态
	s Incidr=$p(StrParam,"^",6)       //药品ID
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	f dd=tdrStartDate:1:tdrEndDate d
	.s tdrID=""
	.f  s tdrID=$o(^DHCPHTDR(0,"CreateDate",dd,tdrID)) Q:tdrID=""  D
	..s ret=..IfPhtDesc(tdrID,Incidr)
	..q:ret'="1"
	..s tdrCDate=$p(^DHCPHTDR(tdrID),"^",1)
	..s:tdrCDate'="" tdrCDate=$zd(tdrCDate,3)
	..s tdrCTime=$p(^DHCPHTDR(tdrID),"^",2)
	..s:tdrCTime'="" tdrCTime=$zt(tdrCTime,1)
	..s tdrNo=$p(^DHCPHTDR(tdrID),"^",3)      ///拆零单号
	..s tdrDeptID=$p(^DHCPHTDR(tdrID),"^",4)    ///拆零科室
	..q:(tdrWinDept'="")&(tdrWinDept'=tdrDeptID)
	..s tdrDept=""
	..s:tdrDeptID'="" tdrDept=$p(^CTLOC(tdrDeptID),"^",2)
	..s tdrUserID=$p(^DHCPHTDR(tdrID),"^",5)  ///拆零人员
	..q:(tdrWinUser'="")&(tdrWinUser'=tdrUserID)
	..s tdrUser=""
	..s:tdrUserID'="" tdrUser=$p(^SSU("SSUSR",tdrUserID),"^",2)
	..s tdrComFlag=$p(^DHCPHTDR(tdrID),"^",6)
	..s tdrComFlag=$s(tdrComFlag="Y":"是",1:"否")
	..s tdrChkFlag=$p(^DHCPHTDR(tdrID),"^",7)
	..q:(tdrChkVal'="")&(tdrChkVal'=tdrChkFlag)
	..s tdrChkFlag=$s(tdrChkFlag="Y":"是",1:"否")
	..s tdrChkDate=$p(^DHCPHTDR(tdrID),"^",8)  ///核对日期
	..s:tdrChkDate'="" tdrChkDate=$zd(tdrChkDate,3)
	..s tdrChkTime=$p(^DHCPHTDR(tdrID),"^",9)  ///核对时间
	..s:tdrChkTime'="" tdrChkTime=$zt(tdrChkTime,1) 
	..s tdrChkUsrID=$p(^DHCPHTDR(tdrID),"^",10) ///核对人员
	..s tdrChkUsr=""
	..s:tdrChkUsrID'="" tdrChkUsr=$p(^SSU("SSUSR",tdrChkUsrID),"^",2)
	..s tdrPurCode=$p(^DHCPHTDR(tdrID),"^",11)
	..s tdrPurDesc=$s(tdrPurCode="10":"自动分包机",tdrPurCode="20":"中转盒",tdrPurCode="30":"窗口分包给患者",tdrPurCode="40":"DTA",1:"")
	..s ListData=tdrID_"^"_tdrCDate_"^"_tdrCTime_"^"_tdrNo_"^"_tdrDeptID_"^"_tdrDept_"^"_tdrUserID_"^"_tdrUser_"^"_tdrComFlag_"^"_tdrChkFlag_"^"_tdrChkDate_"^"_tdrChkTime_"^"_tdrChkUsr_"^"_tdrPurCode_"^"_tdrPurDesc
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoList",pid,Num)=ListData
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S ListTitle="tdrID^tdrCDate^tdrCTime^tdrNo^tdrDeptID^tdrDept^tdrUserID^tdrUser^tdrComFlag^tdrChkFlag^tdrChkDate^tdrChkTime^tdrChkUsr^tdrPurCode^tdrPurDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoList",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:查询拆零记录单明细
/// w ##class(web.DHCSTPHCMTinyDrugRegQuery).QueryTdrNoDetList("30","1","6")
ClassMethod QueryTdrNoDetList(rows As %String, page As %String, tdrID As %String) As %String
{
	n (rows,page,tdrID)
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	s ch=""
	f  s ch=$o(^DHCPHTDR(tdrID,"I",ch)) Q:ch=""  D
	.s tdrInci=$p(^DHCPHTDR(tdrID,"I",ch),"^",1)
	.q:tdrInci=""
	.s tdrInciCode=$p(^INCI(tdrInci,1),"^",1)  ///药品代码
	.s tdrInciDesc=$p(^INCI(tdrInci,1),"^",2)  ///药品描述
	.s tdrBatNo=$p(^DHCPHTDR(tdrID,"I",ch),"^",2) 	///批号
	.s tdrExpDate=$p(^DHCPHTDR(tdrID,"I",ch),"^",3) ///效期
	.//s:tdrExpDate'="" tdrExpDate=$zd(tdrExpDate,3)
	.s tdrQty=$p(^DHCPHTDR(tdrID,"I",ch),"^",4)  	///拆零数量
	.s tdrUom=""
	.s tdrUomID=$p(^DHCPHTDR(tdrID,"I",ch),"^",5) 	///拆零单位
	.s:tdrUomID'="" tdrUom=$p(^CT("UOM",tdrUomID),"^",2)
	.s tdrInclb=$p(^DHCPHTDR(tdrID,"I",ch),"^",6)
	.//i tdrInclb '= "" d
	.//.s incib=$p(^INCI(tdrInci,"IL",$p(tdrInclb,"||",2),"LB",$p(tdrInclb,"||",3)),"^",1)
    .//.s tdrBatNo=$p(^INCI(tdrInci,"IB",$p(incib,"||",2)),"^",1)
    .//.s tdrExpDate=$p(^INCI(tdrInci,"IB",$p(incib,"||",2)),"^",2)
    .//.s:tdrExpDate'="" tdrExpDate=$zd(tdrExpDate,3)
    .s manfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(tdrInci)
	.s tdrManfID=$p(manfInfo,"^",1)
	.s tdrManf=$p(manfInfo,"^",3)
	.s tdrSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",tdrInci)
	.s tdrMacSitNum=$p(^DHCPHTDR(tdrID,"I",ch),"^",7)  ///药位号
    .s tdrItmID=tdrID_"||"_ch
	.s ListData=tdrItmID_"^"_tdrInci_"^"_tdrInciCode_"^"_tdrInciDesc_"^"_tdrBatNo_"^"_tdrBatNo_"^"_tdrExpDate_"^"_tdrQty_"^"_tdrUomID_"^"_tdrUom_"^"_tdrInclb_"^"_tdrManfID_"^"_tdrManf_"^"_tdrSpec_"^"_tdrMacSitNum
	.
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoDetList",pid,Num)=ListData
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S ListTitle="tdrItmID^tdrInci^tdrInciCode^tdrInciDesc^tdrBatNo^tdrBatNoH^tdrExpDate^tdrQty^tdrUomID^tdrUom^tdrBatID^tdrManfID^tdrManf^tdrSpec^tdrMacSitNum"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoDetList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoDetList",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:获取拆零单据信息
/// w ##class(web.DHCSTPHCMTinyDrugRegQuery).GetTdrInfo("10")
ClassMethod GetTdrInfo(tdrID As %String) As %String
{
	n (tdrID)
	q:'$D(^DHCPHTDR(tdrID)) ""
	s tdrCDate=$p(^DHCPHTDR(tdrID),"^",1)
	s:tdrCDate'="" tdrCDate=$zd(tdrCDate,3)
	s tdrCTime=$p(^DHCPHTDR(tdrID),"^",2)
	s:tdrCTime'="" tdrCTime=$zt(tdrCTime,1)
	s tdrNo=$p(^DHCPHTDR(tdrID),"^",3)      ///拆零单号
	s tdrDeptID=$p(^DHCPHTDR(tdrID),"^",4)    ///拆零科室
	s tdrDept=""
	s:tdrDeptID'="" tdrDept=$p(^CTLOC(tdrDeptID),"^",2)
	s tdrUserID=$p(^DHCPHTDR(tdrID),"^",5)  ///拆零人员
	s tdrUser=""
	s:tdrUserID'="" tdrUser=$p(^SSU("SSUSR",tdrUserID),"^",2)
	s tdrComFlag=$p(^DHCPHTDR(tdrID),"^",6)
	s tdrComFlag=$s(tdrComFlag="Y":"是",1:"否")
	s tdrChkFlag=$p(^DHCPHTDR(tdrID),"^",7)
	s tdrChkFlag=$s(tdrChkFlag="Y":"是",1:"否")
	s tdrChkDate=$p(^DHCPHTDR(tdrID),"^",8)  ///核对日期
	s:tdrChkDate'="" tdrChkDate=$zd(tdrChkDate,3)
	s tdrChkTime=$p(^DHCPHTDR(tdrID),"^",9)  ///核对时间
	s:tdrChkTime'="" tdrChkTime=$zt(tdrChkTime,1) 
	s tdrChkUsrID=$p(^DHCPHTDR(tdrID),"^",10) ///核对人员
	s tdrChkUsr=""
	s:tdrChkUsrID'="" tdrChkUsr=$p(^SSU("SSUSR",tdrChkUsrID),"^",2)
	s tdrPurCode=$p(^DHCPHTDR(tdrID),"^",11)
	s tdrPurDesc=$s(tdrPurCode="10":"自动分包机",tdrPurCode="20":"中转盒",tdrPurCode="30":"窗口分包给患者",tdrPurCode="40":"DTA",1:"")
	s ListData=tdrID_"^"_tdrCDate_"^"_tdrCTime_"^"_tdrNo_"^"_tdrDeptID_"^"_tdrDept_"^"_tdrUserID_"^"_tdrUser_"^"_tdrComFlag_"^"_tdrChkFlag_"^"_tdrChkDate_"^"_tdrChkTime_"^"_tdrChkUsr_"^"_tdrPurCode_"^"_tdrPurDesc
		
	s ListTitle="tdrID^tdrCDate^tdrCTime^tdrNo^tdrDeptID^tdrDept^tdrUserID^tdrUser^tdrComFlag^tdrChkFlag^tdrChkDate^tdrChkTime^tdrChkUsr^tdrPurCode^tdrPurDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoList",pid)
	k ^TMP("DHCST","web.DHCSTPHCMTinyDrugRegQuery","QueryTdrNoDetList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMTinyDrugRegQuery"))
}

/// w ##Class(web.DHCSTPHCMTinyDrugRegQuery).IfPhtDesc(422,40018)
ClassMethod IfPhtDesc(tdrID, inci) As %String
{
	n (tdrID,inci)
	s ret=0
	s:inci="" ret=1
    s ch=""
	f  s ch=$o(^DHCPHTDR(tdrID,"I",ch)) Q:ch=""  D
	.s tdrInci=$p(^DHCPHTDR(tdrID,"I",ch),"^",1)
	.q:tdrInci=""
	.s:inci=tdrInci ret=1
	q ret
}

}
