Import sqluser

/// Descript批文信息查询及维护
/// Creator:bianshuai
/// CreatDate:2013-11-27
Class web.DHCST.ItmApproval Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:获取项目批文信息
/// w ##class(web.DHCST.ItmApproval).QueryItmAppInfo("0","30","","417","","3")
ClassMethod QueryItmAppInfo(StPage, Limit, ApprovalNum, InciRowId, manfId, StkGrpId = "") As %String
{
	N (StPage,Limit,ApprovalNum,InciRowId,manfId,StkGrpId)
	s ^TMPDHCSTPARAMS("web.DHCST.ItmApproval","QueryItmAppInfo")=$lb(StPage,Limit,ApprovalNum,InciRowId,manfId,StkGrpId)
	S pid=..NewPid()
	q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	//i (ApprovalNum="")&&(InciRowId="")&&(manfId="") w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	//q:ApprovalNum="" ""
	k ^TMP("DHCST","ItmAppInfo","ItmApp",pid)
	S EndPage=StPage+Limit  //结束行
	S StPage=StPage+1 		//开始行
	S i=0   				//计数器
	i InciRowId'="" d
	.S IrId=""
	.F  S IrId=$o(^ITMREK("INCI",InciRowId,IrId))  Q:IrId=""  D
	..S mdata=^ITMREK(IrId)
	..S Inci=$p(mdata,"^",1)           //库存项ID
	..S manf=+$p(mdata,"^",2)          //厂家
	..Q:(manfId'="")&(manfId'=manf)
	..i $d(^PHMNF(manf)) d
	...S ManfDesc=$p(^PHMNF(manf),"^",2)
 	..s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
 	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	..q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
	..S Logo=$p(mdata,"^",3)          //商标
	..S LastAppNum=$p(mdata,"^",4)    //原批准文号
	..S CurrAppNum=$p(mdata,"^",5)    //现批准文号
	..i (LastAppNum="")||(LastAppNum="-") s LastAppNum=CurrAppNum	// 原批文为空时,取现批文
	..q:(ApprovalNum'="")&&(CurrAppNum'[ApprovalNum)
	..S UpDate=$p(mdata,"^",6)
	..S User=$p(mdata,"^",8)  
	..S TxtExpDate=$p(mdata,"^",10)   //注册证有效期
	..S RegCertNo=$p(mdata,"^",11)    //进口注册证书
	..S RegCertExp=$p(mdata,"^",12)   //进口注册证书有效期
	..S UserName=$p(^SSU("SSUSR",User),"^",2)
	..S Certif=$p(mdata,"^",9)        //认证情况
	..S InciCode=$p(^INCI(Inci,1),"^",1)
	..S InciDesc=$p(^INCI(Inci,1),"^",2)
	..S PurUom=$p(^INCI(Inci,3),"^",6)
	..Q:'$d(^CT("UOM",PurUom))
	..S PurUomDesc=$p(^CT("UOM",PurUom),"^",2)
	..S i=i+1  
	..S TxtExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TxtExpDate,"ST")
	..S RegCertExp=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(RegCertExp,"ST")
	..S UpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(UpDate,"ST")  
	..S str1=IrId_"^"_InciCode_"^"_InciDesc_"^"_PurUomDesc_"^"_ManfDesc_"^"_LastAppNum_"^"_CurrAppNum_"^"_TxtExpDate
	..S str1=str1_"^"_Logo_"^"_RegCertNo_"^"_RegCertExp_"^"_UpDate_"^"_UserName_"^"_Certif_"^"_Inci_"^"_manf
	..S ^TMP("DHCST","ItmAppInfo","ItmApp",pid,i)=str1
	e  d
	.s InciRowId=""
	.f  s InciRowId=$o(^ITMREK("INCI",InciRowId)) q:InciRowId=""  d
	..q:+InciRowId=0
	..S IrId=""
	..F  S IrId=$o(^ITMREK("INCI",InciRowId,IrId))  Q:IrId=""  D
	...S mdata=^ITMREK(IrId)
	...S Inci=$p(mdata,"^",1)           //库存项ID
	...//Q:(InciRowId'="")&(InciRowId'=Inci)
	...S manf=+$p(mdata,"^",2)          //厂家
	...Q:(manfId'="")&(manfId'=manf)
	...i $d(^PHMNF(manf)) d
	....S ManfDesc=$p(^PHMNF(manf),"^",2)
 	...s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
 	...s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	...q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
	...S Logo=$p(mdata,"^",3)          //商标
	...S LastAppNum=$p(mdata,"^",4)    //原批准文号
	...S CurrAppNum=$p(mdata,"^",5)    //现批准文号
	...q:(ApprovalNum'="")&&(CurrAppNum'[ApprovalNum)
	...S UpDate=$p(mdata,"^",6)
	...S User=$p(mdata,"^",8)  
	...S TxtExpDate=$p(mdata,"^",10)   //注册证有效期
	...S RegCertNo=$p(mdata,"^",11)    //进口注册证书
	...S RegCertExp=$p(mdata,"^",12)   //进口注册证书有效期
	...S UserName=$p(^SSU("SSUSR",User),"^",2)
	...S Certif=$p(mdata,"^",9)        //认证情况
	...S InciCode=$p(^INCI(Inci,1),"^",1)
	...S InciDesc=$p(^INCI(Inci,1),"^",2)
	...S PurUom=$p(^INCI(Inci,3),"^",6)
	...Q:'$d(^CT("UOM",PurUom))
	...S PurUomDesc=$p(^CT("UOM",PurUom),"^",2)
	...S i=i+1  
	...S TxtExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TxtExpDate,"ST")
	...S RegCertExp=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(RegCertExp,"ST")
	...S UpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(UpDate,"ST")  
	...S str1=IrId_"^"_InciCode_"^"_InciDesc_"^"_PurUomDesc_"^"_ManfDesc_"^"_LastAppNum_"^"_CurrAppNum_"^"_TxtExpDate
	...S str1=str1_"^"_Logo_"^"_RegCertNo_"^"_RegCertExp_"^"_UpDate_"^"_UserName_"^"_Certif_"^"_Inci_"^"_manf
	...S ^TMP("DHCST","ItmAppInfo","ItmApp",pid,i)=str1	
	Q:i=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	S MaxRow=i
	i EndPage>MaxRow s EndPage=MaxRow
	S count=0
	
	S j=""
	F  S j=$o(^TMP("DHCST","ItmAppInfo","ItmApp",pid,j)) Q:j=""  D
	.S mdata=$g(^TMP("DHCST","ItmAppInfo","ItmApp",pid,j))
	.S IrId=$P(mdata,"^",1)
	.S InciCode=$P(mdata,"^",2)
	.S InciDesc=$P(mdata,"^",3)
	.S PurUom=$P(mdata,"^",4)
	.S ManfDesc=$P(mdata,"^",5)
	.S LastAppNum=$P(mdata,"^",6)
	.S CurrAppNum=$P(mdata,"^",7)
	.S TxtExpDate=$P(mdata,"^",8)
	.S Logo=$P(mdata,"^",9)
	.S RegCertNo=$P(mdata,"^",10)
	.S RegCertExp=$P(mdata,"^",11)
	.S UpdDate=$P(mdata,"^",12)
	.S UpdUser=$P(mdata,"^",13)
	.S Certif=$P(mdata,"^",14)
	.S Inci=$P(mdata,"^",15)
	.S ManfId=$P(mdata,"^",16)
	.
	.S count=count+1
    .Q:count<StPage
    .Q:count>EndPage
    .
    .S IrId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RowId",IrId)
    .S Inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciDr",Inci)
	.S InciCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Code",InciCode)
	.S InciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Desc",InciDesc)
	.S PurUom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Uom",PurUom)
	.S ManfId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfId",ManfId)
	.S ManfDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Manf",ManfDesc)
	.S LastAppNum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("AppNum",LastAppNum)
	.S CurrAppNum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("CurrAppNum",CurrAppNum)
	.S TxtExpDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("AppExp",TxtExpDate)
	.S Logo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Logo",Logo)
	.S RegCertNo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ImpLicense",RegCertNo)
	.S RegCertExp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ImpLicExp",RegCertExp)
	.S UpdDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UpdDate",UpdDate)
	.S UpdUser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UpdUser",UpdUser)
	.S Certif=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("AppRet",Certif)
	.
	.S TmpStr=IrId_Inci_InciCode_InciDesc_PurUom_ManfId_ManfDesc_LastAppNum_CurrAppNum_TxtExpDate_Logo_RegCertNo_RegCertExp_UpdDate_UpdUser_Certif
	.
    .S StString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(MaxRow)
    .S FirstRow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(TmpStr)
    .S LastRow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(TmpStr)
	.
    .i count=StPage w StString
    .i count<EndPage w FirstRow
    .i count=EndPage w LastRow
        
    k ^TMP("DHCST","ItmAppInfo","ItmApp",pid)
    q ""
}

/// Descript:保存批文信息
ClassMethod SaveAppNum(ListDate) As %String
{
	N (ListDate)
	S Err=0
	TS
	S Len=$L(ListDate,"#")
	F i=1:1:Len Q:Err'=0  d
	.S mdate=$P(ListDate,"#",i)
	.S IrID=$p(mdate,"^",1)
	.S Inci=$p(mdate,"^",2)
	.S Manf=$p(mdate,"^",3)
	.S Label=$p(mdate,"^",4)       //商标
	.S LastAppNum=$p(mdate,"^",7)      //原批准文号
	.S CurrAppNum=$p(mdate,"^",10) //现批准文号
	.S AppExp=$p(mdate,"^",6)      //批文有效期
	.S AppExp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AppExp)        
	.S Certif=$p(mdate,"^",5)      //认证情况
	.//S ImpLicExp=$p(mdate,"^",7)   //注册证校期
	.S CerNo=$p(mdate,"^",11)      //进口注册证
	.S CerDate=$p(mdate,"^",12)    //注册证校期
	.S CerDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CerDate)
	.S UserId=$p(mdate,"^",9)
	.S ListStr=Inci_"^"_Manf_"^"_Label_"^"_LastAppNum_"^"_CurrAppNum_"^"_UserId
	.S ListStr=ListStr_"^"_Certif_"^"_AppExp_"^"_CerNo_"^"_CerDate
	.s ItmRid=$o(^ITMREK(0,"INCIMNF",Inci,Manf,""))
	.i ItmRid'="" d
	..i IrID'="" d
	...i IrID'=ItmRid s Err=-11
	..e  d
	...i ItmRid'="" s Err=-11
	.q:Err'=0
	.If IrID'="" D
	..S Err=..UpdItmRemark(IrID,ListStr)
	.Else  D
	..S Err=..InsertItmRemark(ListStr)
	.Q:Err'=0
	.
	.If Err=0 d
	..S Err=..UpdItmAddInfoRemark(Inci)
	.
	I Err'=0 Tro
	I Err'=0 q Err
	TC
	q Err
}

/// Descript:插入批文信息表
ClassMethod InsertItmRemark(ListStr)
{
	N (ListStr)
	k PLIST
	S PLIST(2)=$P(ListStr,"^",1)
	S PLIST(3)=$P(ListStr,"^",2)
	S PLIST(4)=$P(ListStr,"^",3)
	S PLIST(5)=$P(ListStr,"^",4)
	S PLIST(6)=$P(ListStr,"^",5)
	S PLIST(7)=+$h
	S PLIST(8)=$p($h,",",2)
	S PLIST(9)=$P(ListStr,"^",6)
	S PLIST(10)=$P(ListStr,"^",7)
	S PLIST(11)=$P(ListStr,"^",8)
	S PLIST(12)=$P(ListStr,"^",9)
	S PLIST(13)=$P(ListStr,"^",10)
	&SQL(INSERT INTO DHC_ItmRemark VALUES PLIST())
 	Q:SQLCODE'=0 SQLCODE
 	Q 0
}

/// Descript:更新批文信息表
ClassMethod UpdItmRemark(IrID, ListStr)
{
	N (IrID,ListStr)
	k PLIST
	S PLIST(3)=$P(ListStr,"^",2)
	S PLIST(4)=$P(ListStr,"^",3)
	S PLIST(5)=$P(ListStr,"^",4)
	S PLIST(6)=$P(ListStr,"^",5)
	S PLIST(7)=+$h
	S PLIST(8)=$p($h,",",2)
	S PLIST(9)=$P(ListStr,"^",6)
	S PLIST(10)=$P(ListStr,"^",7)
	S PLIST(11)=$P(ListStr,"^",8)
	S PLIST(12)=$P(ListStr,"^",9)
	S PLIST(13)=$P(ListStr,"^",10)
	&SQL(Update DHC_ItmRemark VALUES PLIST() where IR_RowID=:IrID)
 	Q:SQLCODE'=0 SQLCODE
 	Q 0
}

/// Descript:更新库存项附加表
/// modify by wyx 2014-11-24改为取更新日期最新的一个。
ClassMethod UpdItmAddInfoRemark(inci)
{
	;更新dhc_itmaddioninfo中的最新批文号 2007-08-01
	n (inci)
	s ret=0
	s NewDate=$o(^ITMREK(0,"INCIDATE",inci,""),-1)
	s NewTime=$o(^ITMREK(0,"INCIDATE",inci,NewDate,""),-1)	
	s re=$o(^ITMREK(0,"INCIDATE",inci,NewDate,NewTime,""),-1)   ;最新的批准文号
	q:re="" 0
	s remark=$p(^ITMREK(re),"^",5)   ;最新的批准文号
	s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	i info="" d
	.s ret=$$AddItmInfo^DHCSTITMINFO(inci,"")   ;插入dhc_itmaddioninfo
	q:ret -1
	s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:info="" -2
	&sql(update dhc_itmaddioninfo set info_remark=:remark where info_rowid=:info)
	q:SQLCODE -3
	q 0
}

/// Descript:进程pid
ClassMethod NewPid() As %String
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

/// Descript:判断当天是否有更新记录
/// Result:0 没有 返回空或者原批准文号 1 有 
ClassMethod CheckExist(inci) As %String
{
	 n (inci)
	 s ret=""
	 q:inci="" ret
	 q:'$d(^ITMREK("INCI",inci)) ret
	 // modify wyx 2014-11-24 改为取更新最新的记录
	 s newDate=$o(^ITMREK(0,"INCIDATE",inci,""),-1)
	 q:newDate="" ret
	 s newTime=$o(^ITMREK(0,"INCIDATE",inci,newDate,""),-1)
	 q:newTime="" ret
	 // 最新的批准文号
	 s irId=$o(^ITMREK(0,"INCIDATE",inci,newDate,newTime,""),-1)   
	 q:irId="" ret
	 //S ret=1 不限制当天更新
	 s manf=$p(^ITMREK(irId),"^",2)
	 q:'$d(^PHMNF(manf)) ret
	 s label=$p(^ITMREK(irId),"^",5)  //原批准文号
	 q:ret'=1 label
	 q ret
}

}
