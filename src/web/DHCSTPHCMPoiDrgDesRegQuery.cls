Import sqluser

/// Descript:   麻精药品销毁登记查询
Class web.DHCSTPHCMPoiDrgDesRegQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:查询麻精药品销毁登记记录表
/// w ##class(web.DHCSTPHCMPoiDrgDesRegQuery).QueryDesRegNoList("30","1","2015-11-10^2016-12-10")
ClassMethod QueryDesRegNoList(rows As %String, page As %String, StrParam As %String) As %String
{
	n (rows,page,StrParam)
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s ddrStartDate=$p(StrParam,"^",1)    //开始日期
	s ddrStartDate=$zdh(ddrStartDate,3)
	s ddrEndDate=$p(StrParam,"^",2)      //结束日期
	s ddrEndDate=$zdh(ddrEndDate,3)
	s ddrWinDept=$p(StrParam,"^",3)      //销毁科室
	s ddrWinUser=$p(StrParam,"^",4)      //销毁人员
	s ddrChkVal=$p(StrParam,"^",5)       //单据状态
	
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	f dd=ddrStartDate:1:ddrEndDate d
	.s ddrID=""
	.f  s ddrID=$o(^DHCPHPDDR(0,"CreateDate",dd,ddrID)) Q:ddrID=""  D
	..s ddrCDate=$p(^DHCPHPDDR(ddrID),"^",1)
	..s:ddrCDate'="" ddrCDate=$zd(ddrCDate,3)
	..s ddrCTime=$p(^DHCPHPDDR(ddrID),"^",2)
	..s:ddrCTime'="" ddrCTime=$zt(ddrCTime,1)
	..s ddrNo=$p(^DHCPHPDDR(ddrID),"^",3)      ///销毁单号
	..s ddrDeptID=$p(^DHCPHPDDR(ddrID),"^",4)    ///销毁科室
	..q:(ddrWinDept'="")&(ddrWinDept'=ddrDeptID)
	..s ddrDept=""
	..s:ddrDeptID'="" ddrDept=$p(^CTLOC(ddrDeptID),"^",2)
	..s ddrUserID=$p(^DHCPHPDDR(ddrID),"^",5)  ///销毁人员
	..q:(ddrWinUser'="")&(ddrWinUser'=ddrUserID)
	..s ddrUser=""
	..s:ddrUserID'="" ddrUser=$p(^SSU("SSUSR",ddrUserID),"^",2)
	..s ddrComFlag=$p(^DHCPHPDDR(ddrID),"^",6)
	..s ddrComFlag=$s(ddrComFlag="Y":"是",1:"否")
	..s ddrChkFlag=$p(^DHCPHPDDR(ddrID),"^",7)
	..q:(ddrChkVal'="")&(ddrChkVal'=ddrChkFlag)
	..s ddrChkFlag=$s(ddrChkFlag="Y":"是",1:"否")
	..s ddrChkDate=$p(^DHCPHPDDR(ddrID),"^",8)  ///核对日期
	..s:ddrChkDate'="" ddrChkDate=$zd(ddrChkDate,3)
	..s ddrChkTime=$p(^DHCPHPDDR(ddrID),"^",9)  ///核对时间
	..s:ddrChkTime'="" ddrChkTime=$zt(ddrChkTime,1) 
	..s ddrChkUsrID=$p(^DHCPHPDDR(ddrID),"^",10) ///核对人员
	..s ddrChkUsr=""
	..s:ddrChkUsrID'="" ddrChkUsr=$p(^SSU("SSUSR",ddrChkUsrID),"^",2)
	..s ddrDesWayCode=$p(^DHCPHPDDR(ddrID),"^",11)
	..s ddrDesWayDesc=$s(ddrDesWayCode="10":"送医疗废物管理办",1:"")
	..s ListData=ddrID_"^"_ddrCDate_"^"_ddrCTime_"^"_ddrNo_"^"_ddrDeptID_"^"_ddrDept_"^"_ddrUserID_"^"_ddrUser_"^"_ddrComFlag_"^"_ddrChkFlag_"^"_ddrChkDate_"^"_ddrChkTime_"^"_ddrChkUsr_"^"_ddrDesWayCode_"^"_ddrDesWayDesc
	..
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoList",pid,Num)=ListData
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S ListTitle="ddrID^ddrCDate^ddrCTime^ddrNo^ddrDeptID^ddrDept^ddrUserID^ddrUser^ddrComFlag^ddrChkFlag^ddrChkDate^ddrChkTime^ddrChkUsr^ddrDesWayCode^ddrDesWayDesc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoList",pid,index)
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

/// Descript:麻精药品销毁登记记录单明细
/// w ##class(web.DHCSTPHCMPoiDrgDesRegQuery).QueryDesRegNoDetList("30","1","6")
ClassMethod QueryDesRegNoDetList(rows As %String, page As %String, ddrID As %String) As %String
{
	n (rows,page,ddrID)
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num=0
	s ch=""
	f  s ch=$o(^DHCPHPDDR(ddrID,"I",ch)) Q:ch=""  D
	.s ddrInci=$p(^DHCPHPDDR(ddrID,"I",ch),"^",1)
	.q:ddrInci=""
	.s ddrInciCode=$p(^INCI(ddrInci,1),"^",1)  ///药品代码
	.s ddrInciDesc=$p(^INCI(ddrInci,1),"^",2)  ///药品描述
	.s ddrBatNo=$p(^DHCPHPDDR(ddrID,"I",ch),"^",2) 	///批号
	.s ddrExpDate=$p(^DHCPHPDDR(ddrID,"I",ch),"^",3) ///效期
	.s:ddrExpDate'="" ddrExpDate=$zd(ddrExpDate,3)
	.s ddrQty=$p(^DHCPHPDDR(ddrID,"I",ch),"^",4)  	///销毁数量
	.s ddrUom=""
	.s ddrUomID=$p(^DHCPHPDDR(ddrID,"I",ch),"^",5) 	///销毁单位
	.s:ddrUomID'="" ddrUom=$p(^CT("UOM",ddrUomID),"^",2)
	.s ddrInclb=$p(^DHCPHPDDR(ddrID,"I",ch),"^",6)
	.i ddrInclb '= "" d
	..s incib=$p(^INCI(ddrInci,"IL",$p(ddrInclb,"||",2),"LB",$p(ddrInclb,"||",3)),"^",1)
    ..s ddrBatNo=$p(^INCI(ddrInci,"IB",$p(incib,"||",2)),"^",1)
    ..s ddrExpDate=$p(^INCI(ddrInci,"IB",$p(incib,"||",2)),"^",2)
    ..s:ddrExpDate'="" ddrExpDate=$zd(ddrExpDate,3)
    .s manfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(ddrInci)
	.s ddrManfID=$p(manfInfo,"^",1)
	.s ddrManf=$p(manfInfo,"^",3)
	.s ddrSpec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",ddrInci)
    .s ddrItmID=ddrID_"||"_ch
	.s ListData=ddrItmID_"^"_ddrInci_"^"_ddrInciCode_"^"_ddrInciDesc_"^"_ddrBatNo_"^"_ddrExpDate_"^"_ddrQty_"^"_ddrUomID_"^"_ddrUom_"^"_ddrInclb_"^"_ddrManfID_"^"_ddrManf_"^"_ddrSpec
	.
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoDetList",pid,Num)=ListData
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S ListTitle="ddrItmID^ddrInci^ddrInciCode^ddrInciDesc^ddrBatNo^ddrExpDate^ddrQty^ddrUomID^ddrUom^ddrBatID^ddrManfID^ddrManf^ddrSpec"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoDetList",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoDetList",pid,index)
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

/// Descript:获取麻精药品销毁登记单据信息
/// w ##class(web.DHCSTPHCMPoiDrgDesRegQuery).GetDesDrgRegNoInfo("10")
ClassMethod GetDesDrgRegNoInfo(ddrID As %String) As %String
{
	n (ddrID)
	q:'$D(^DHCPHPDDR(ddrID)) ""
	s ddrCDate=$p(^DHCPHPDDR(ddrID),"^",1)
	s:ddrCDate'="" ddrCDate=$zd(ddrCDate,3)
	s ddrCTime=$p(^DHCPHPDDR(ddrID),"^",2)
	s:ddrCTime'="" ddrCTime=$zt(ddrCTime,1)
	s ddrNo=$p(^DHCPHPDDR(ddrID),"^",3)        ///销毁单号
	s ddrDeptID=$p(^DHCPHPDDR(ddrID),"^",4)    ///销毁科室
	s ddrDept=""
	s:ddrDeptID'="" ddrDept=$p(^CTLOC(ddrDeptID),"^",2)
	s ddrUserID=$p(^DHCPHPDDR(ddrID),"^",5)   ///销毁人员
	s ddrUser=""
	s:ddrUserID'="" ddrUser=$p(^SSU("SSUSR",ddrUserID),"^",2)
	s ddrComFlag=$p(^DHCPHPDDR(ddrID),"^",6)
	s ddrComFlag=$s(ddrComFlag="Y":"是",1:"否")
	s ddrChkFlag=$p(^DHCPHPDDR(ddrID),"^",7)
	s ddrChkFlag=$s(ddrChkFlag="Y":"是",1:"否")
	s ddrChkDate=$p(^DHCPHPDDR(ddrID),"^",8)  ///核对日期
	s:ddrChkDate'="" ddrChkDate=$zd(ddrChkDate,3)
	s ddrChkTime=$p(^DHCPHPDDR(ddrID),"^",9)  ///核对时间
	s:ddrChkTime'="" ddrChkTime=$zt(ddrChkTime,1) 
	s ddrChkUsrID=$p(^DHCPHPDDR(ddrID),"^",10) ///核对人员
	s ddrChkUsr=""
	s:ddrChkUsrID'="" ddrChkUsr=$p(^SSU("SSUSR",ddrChkUsrID),"^",2)
	s ddrDesWayCode=$p(^DHCPHPDDR(ddrID),"^",11)
	s ddrDesWayDesc=$s(ddrDesWayCode="10":"送医疗废物管理办",1:"")
	s ddrDesReaCode=$p(^DHCPHPDDR(ddrID),"^",12)
	s ddrDesReaDesc=$s(ddrDesReaCode="10":"质量问题",ddrDesReaCode="20":"药品过期",ddrDesReaCode="30":"药品召回",1:"")
	s ListData=ddrID_"^"_ddrCDate_"^"_ddrCTime_"^"_ddrNo_"^"_ddrDeptID_"^"_ddrDept_"^"_ddrUserID_"^"_ddrUser_"^"_ddrComFlag_"^"_ddrChkFlag_"^"_ddrChkDate_"^"_ddrChkTime_"^"_ddrChkUsr_"^"_ddrDesWayCode_"^"_ddrDesWayDesc_"^"_ddrDesReaCode_"^"_ddrDesReaDesc
		
	s ListTitle="ddrID^ddrCDate^ddrCTime^ddrNo^ddrDeptID^ddrDept^ddrUserID^ddrUser^ddrComFlag^ddrChkFlag^ddrChkDate^ddrChkTime^ddrChkUsr^ddrDesWayCode^ddrDesWayDesc^ddrDesReaCode^ddrDesReaDesc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoList",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPoiDrgDesRegQuery","QueryDesRegNoDetList",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPoiDrgDesRegQuery"))
}

}
