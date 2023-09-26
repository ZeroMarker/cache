/// creator:	 QianHuanjuan
/// createdate:	 2018-03-14
/// description: 配液大类维护
Class web.DHCSTPIVAS.OrderLink Extends web.DHCSTPIVAS.Common [ ProcedureBlock ]
{

Parameter AppTable [ Final ] = "PIVA_OrderLink";

Parameter LogSign [ Final ] = "配液中心 - 配液大类";

/// description:配液大类列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderLink","QueryOrderLink","")
Query QueryOrderLink(inputStr = "", HospId = "", pNeedTrans = "") As websys.Query(ROWSPEC = "polId,polDesc,polOrdNum,polCode")
{
}

ClassMethod QueryOrderLinkExecute(ByRef qHandle As %Binary, inputStr = "", HospId = "", pNeedTrans = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT POL_Rowid as polId,POL_Desc as polDesc,POL_OrdNum as polOrdNum,POL_Code as polCode FROM PIVA_OrderLink ORDER BY POL_OrdNum"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
	    s polId= result.Data("polId") 
	    s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,polId,HospId) //医院级别授权
        continue:flag="N"  
	    s polDesc= result.Data("polDesc") 
        if (pNeedTrans = "Y"){
            s polDesc = ##class(PHA.COM.Data.Base).PIVAOrderLinkDesc(polId)
        }
	    s polOrdNum=result.Data("polOrdNum") 
	    s polCode= result.Data("polCode") 
        d outputOrderLink
    }
    d result.Close()
	Quit $$$OK
outputOrderLink
	s Data=$lb(polId,polDesc,polOrdNum,polCode)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存配液大类
ClassMethod SaveOrderLinkMulti(inputData, HospId = "")
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveOrderLink(iData,HospId)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存配液大类信息
/// input:		 inputStr^1:描述
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.OrderLink).SaveOrderLink("焕娟测试")
ClassMethod SaveOrderLink(inputStr, HospId = "")
{
	s polId=$p(inputStr,"^",1)
	s polDesc=$p(inputStr,"^",2)
	s polOrdNum=$p(inputStr,"^",3)
  	q:polDesc="" "-1^名称不能为空"
  	q:polOrdNum="" "-1^优先级不能为空"
  	s polCode=$p(inputStr,"^",4)
	s chkRet=..CheckExist(polId,polCode,polDesc,HospId)
	q:+chkRet<0 chkRet
  	s errCode=""
  	i polId=""  d
  	.&SQL(
		INSERT INTO PIVA_OrderLink (POL_Desc, POL_OrdNum, POL_Code)
		VALUES (:polDesc, :polOrdNum, :polCode)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败"
  	.e  d
  	..s Rowid=$p(%ROWID,$c(1))
    ..i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
    e   d
	.s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", polId)
	.&sql(
		UPDATE PIVA_OrderLink
		SET POL_Desc=:polDesc,
		    POL_OrdNum=:polOrdNum,
		    POL_Code=:polCode
		WHERE POL_Rowid = :polId 
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"
	s rowID = $g(%ROWID)
	q:errCode'="" errCode
	s logSignDesc = ..GetLogSignDesc(rowID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", rowID)
	s logType = $s(polId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLink","User.PIVAOrderLink", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))	
	q 0_"^保存成功"
}

/// description: 删除配液大类信息
/// w ##class(web.DHCSTPIVAS.OrderLink).DeletePIVAOrderLink("34")
ClassMethod DeletePIVAOrderLink(polId, HospId = "")
{
	q:polId="" "-1^Id为空"
 	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", polId)
	s logSignDesc = ..GetLogSignDesc(polId)
	&SQL(
		DELETE
		FROM PIVA_OrderLink
		WHERE POL_Rowid = :polId
	)
	i SQLCODE=0 d
	.i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,polId,HospId)
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLink","User.PIVAOrderLink", ..#LogSign, polId, logSignDesc, "D", delJsonStr)
	q SQLCODE
}

/// description:配液小类列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderLink","QueryPivasCat","")
Query QueryPivasCat(inputStr = "", HospId = "") As websys.Query(ROWSPEC = "poliId,pivasCatId,pivasCatDesc")
{
}

ClassMethod QueryPivasCatExecute(ByRef qHandle As %Binary, inputStr = "", HospId = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:inputStr="" $$$OK
    s polId=$p(inputStr,"^",1)
	s sub=""
	f  s sub=$o(^POLI(polId,"G",sub)) q:sub=""  d
	.s pivaCatDrStr=$p(^POLI(polId,"G",sub),"^",4)
	.q:+pivaCatDrStr=0
	.s pivaCatDescStr=""
	.f i=1:1:$l(pivaCatDrStr,",") d
	..s pivaCatDr=$p(pivaCatDrStr,",",i)
	..q:(+pivaCatDr=0)
	..s pivasCatDesc=##class(PHA.COM.Data.Base).PHCPivaCatDesc(pivaCatDr)
	..s pivaCatDescStr=$s(pivaCatDescStr="":pivasCatDesc,1:pivaCatDescStr_","_pivasCatDesc)
	.s poliId=polId_"||"_sub
	.d outputPivasCat
	Quit $$$OK
outputPivasCat
	s Data=$lb(poliId,pivaCatDrStr,pivaCatDescStr)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存配液大类规则-配液小类
ClassMethod SavePivasCatMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SavePivasCat(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存配液小类信息
/// input:	     inputStr^1:配液小类Id,inputStr^2:配液大类Id,inputStr^3:配液小类描述
/// w ##class(web.DHCSTPIVAS.OrderLink).SavePivasCat("^35^1")
ClassMethod SavePivasCat(inputStr)
{
	s poliId=$p(inputStr,"^",1)
	s polId=$p(inputStr,"^",2)
	s pivasCatDr=$p(inputStr,"^",3)
	q:pivasCatDr="" "-1^配液小类为空"
	s pivasCatDr=##class(web.DHCSTPIVAS.Common).AscOrder(pivasCatDr,",")
	s errCode=""
	i poliId=""  d
	.&SQL(SELECT * FROM PIVA_OrderLinkItm WHERE POLI_POL_ParRef=:polId and POLI_PHCPivaCat_Dr=:pivasCatDr)
	.i SQLCODE=0 s errCode="-1^已维护该配液小类"
  	.q:errCode'=""
	.s maxSub=$o(^POLI(polId,"G",""),-1)+1
	.&SQL(
		insert into PIVA_OrderLinkItm
		(POLI_POL_ParRef,POLI_Childsub,POLI_PHCPivaCat_Dr)
		values
		(:polId,:maxSub,:pivasCatDr)
		)
	.i SQLCODE'=0 s errCode="-1^插入失败" 
	q:errCode'="" errCode
	s rowID = $g(%ROWID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLinkItm", rowID)
	s newJsonStr = ##class(web.DHCSTPIVAS.Util).ReplaceJsonComma(newJsonStr, "POLI_PHCPivaCat_Dr")
	s logType = "A"
	s logSignDesc="关联配液小类: " _ ..GetLogSignDesc(+rowID)
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLinkItm","User.PIVAOrderLinkItm", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))	
	q 0_"^保存成功"
}

/// description: 删除配液小类规则
ClassMethod DeletePoli(poliId)
{
	q:(poliId = "") "-1^Id为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLinkItm", poliId)
	s delJsonStr = ##class(web.DHCSTPIVAS.Util).ReplaceJsonComma(delJsonStr, "POLI_PHCPivaCat_Dr")
	s logSignDesc = "关联配液小类:" _ ..GetLogSignDesc(+poliId)
	&SQL(
		DELETE
		FROM PIVA_OrderLinkItm
		WHERE POLI_RowID = :poliId
	)
	q:(SQLCODE '= 0) SQLCODE
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLinkItm","User.PIVAOrderLinkItm", ..#LogSign, poliId, logSignDesc, "D", delJsonStr)	
	q 0
}

/// description:用法列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderLink","QueryInstruct","")
Query QueryInstruct(inputStr = "") As websys.Query(ROWSPEC = "polsId,instrucId,instrucDesc")
{
}

ClassMethod QueryInstructExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:inputStr="" $$$OK
    s polId=$p(inputStr,"^",1)
	s ChildSub=""
	f  s ChildSub=$o(^POLI(polId,"S",ChildSub))    q:ChildSub=""  d
	.s instrucDr=$p(^POLI(polId,"S",ChildSub),"^",3)
	.s instrucDesc=##class(PHA.COM.Data.Base).InstDesc(instrucDr)
	.s polsId=(polId_"||"_ChildSub)
	.d outputInstruct
	Quit $$$OK
outputInstruct
	s Data=$lb(polsId,instrucDr,instrucDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存配液大类规则-用法
ClassMethod SaveInstructMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveInstruct(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// description: 保存用法信息
/// input:	     inputStr^1:用法Id,inputStr^2:配液大类Id,inputStr^3:用法描述Id
/// w ##class(web.DHCSTPIVAS.OrderLink).SaveInstruct("^34^4")
ClassMethod SaveInstruct(inputStr)
{
	s polsId=$p(inputStr,"^",1)
	s polId=$p(inputStr,"^",2)
	s instrucDr=$p(inputStr,"^",3)
	q:instrucDr="" "-1^用法为空"
	s errCode=""
	i polsId=""  d
	.&SQL(SELECT * FROM PIVA_OrderLinkInstruc WHERE POLS_POL_ParRef=:polId and POLS_PHCInstruc_Dr=:instrucDr)
	.i SQLCODE=0 s errCode="-1^已维护该用法"
  	.q:errCode'=""
	.s maxSub=$o(^POLI(polId,"S",""),-1)+1
	.&SQL(
		insert into PIVA_OrderLinkInstruc
		(POLS_POL_ParRef,POLS_Childsub,POLS_PHCInstruc_Dr)
		values
		(:polId,:maxSub,:instrucDr)
		)
	.i SQLCODE'=0 s errCode="-1^插入失败" 
	q:errCode'="" errCode
	s rowID = $g(%ROWID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLinkInstruc", rowID)
	s logType = "A"
	s logSignDesc="关联用法: " _ ..GetLogSignDesc(+rowID)
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLinkInstruc","User.PIVAOrderLinkInstruc", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))	
	q 0_"^保存成功"
}

/// description: 删除用法
ClassMethod DeletePols(polsId)
{
	q:(polsId = "") "-1^Id为空"
	s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLinkInstruc", polsId)
	s logSignDesc = "关联用法: " _ ..GetLogSignDesc(+polsId)	
	&SQL(
		DELETE
		FROM PIVA_OrderLinkInstruc
		WHERE POLS_RowID = :polsId
	)
	q:(SQLCODE '= 0) SQLCODE
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLinkInstruc","User.PIVAOrderLinkInstruc", ..#LogSign, polsId, logSignDesc, "D", delJsonStr)		
	q 0
}

/// description:查询液体量年龄等
/// others:		
/// input:	
/// w ##class(web.DHCSTPIVAS.OrderLink).SaveLiquid("34")
ClassMethod GetLinkSingle(polId)
{
	q:polId="" ""
	s poliData = $g(^POLI(polId))
	s minVol = $p(poliData, "^", 2)
	s maxVol = $p(poliData, "^", 3)
	s minAge = $p(poliData, "^", 7)
	s maxAge = $p(poliData, "^", 8)
	q {
		"minVol": ($s(minVol '= "" : $fn(minVol, "N") , 1 : minVol)),
		"maxVol": ($s(maxVol '= "" : $fn(maxVol, "N") , 1 : maxVol)),
		"minAge": ($s(minAge '= "" : $fn(minAge, "N") , 1 : minAge)),
		"maxAge": ($s(maxAge '= "" : $fn(maxAge, "N") , 1 : maxAge))
	}.%ToJSON()
}

/// description: 保存液体量信息
/// input:		 inputStr^1:描述
/// return:		 +ret=0 成功
/// w ##class(web.DHCSTPIVAS.OrderLink).SaveLiquid("")
ClassMethod SaveSingle(inputStr)
{
	s polId=$p(inputStr,"^",1)
	s POLMinVolume=$p(inputStr,"^",2)
	s POLMaxVolume=$p(inputStr,"^",3)
	s POLMinAge=$p(inputStr,"^",4)
	s POLMaxAge=$p(inputStr,"^",5)
	q:+POLMinVolume<0 "-1^最小液体量小于0"
	q:+POLMaxVolume<0 "-1^最大液体量小于0"
	q:+POLMinAge<0 "-1^最小年龄小于0"
	q:+POLMaxAge<0 "-1^最大年龄小于0"
	q:polId="" "-1^配液大类Id为空"
	s errCode=""
  	i polId=""  d
  	.&SQL(
		INSERT INTO PIVA_OrderLink (POL_MinVolume, POL_MaxVolume, POL_MinAge, POL_MaxAge)
		VALUES (:POLMinVolume, :POLMaxVolume, :POLMinAge, :POLMaxAge)
  	  )
  	.i SQLCODE'=0 s errCode="-1^增加失败"
  	e   d
  	.s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", polId)
	.&sql(
		UPDATE PIVA_OrderLink
		SET POL_MinVolume=:POLMinVolume,
		    POL_MaxVolume=:POLMaxVolume,
		    POL_MinAge=:POLMinAge,
		    POL_MaxAge=:POLMaxAge
		WHERE POL_Rowid = :polId 
	 )
	.i SQLCODE'=0 s errCode="-1^修改失败"_%msg
	q:errCode'="" errCode
	s rowID = %ROWID
	s logSignDesc = ..GetLogSignDesc(+rowID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", rowID)
	s logType = $s(polId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLink","User.PIVAOrderLink", ..#LogSign, rowID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0_"^保存成功"
}

/// description:查询医嘱项列表
/// others:		
/// input:	
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderLink","QueryOrdLinkOrd","55")
Query QueryOrdLinkOrd(inputStr = "") As websys.Query(ROWSPEC = "poloId,arcItmId,arcItmCode,arcItmDesc,arcItmQty,linkOrdPack,linkOrdPackDesc,linkOrdSeq,linkOrdSeqDesc")
{
}

ClassMethod QueryOrdLinkOrdExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:inputStr="" $$$OK
    s polId=$p(inputStr,"^",1)
	s ChildSub=""
	f  s ChildSub=$o(^POLI(polId,"M",ChildSub))    q:ChildSub=""  d
	.q:+ChildSub=0
	.s POLIM=^POLI(polId,"M",ChildSub)
	.s arcimId=$p(POLIM,"^",1)
	.s arcimQty=$p(POLIM,"^",4)
	.s arcSub=$P(arcimId,"||",1)
 	.s arcVer=$P(arcimId,"||",2)
 	.q:arcSub="" 
 	.q:arcVer="" 
 	.q:'$D(^ARCIM(arcSub,arcVer)) 
	.s arcimCode=$p(^ARCIM(arcSub,arcVer,1),"^",1)
	.s arcimDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcimId)
	.s linkOrdPack=$p(POLIM,"^",6)
	.i linkOrdPack="" s linkOrdPack="A"
	.s linkOrdPackDesc=$case(linkOrdPack,"A":"全部","N":"配液","Y":"打包")
    .s linkOrdPackDesc=..Translate(linkOrdPackDesc, "dhcpha.pivas.orderlinkord.csp")
	.s linkOrdSeq=$p(POLIM,"^",7)
	.i linkOrdSeq="" s linkOrdSeq="A"
	.s linkOrdSeqDesc=$case(linkOrdSeq,"A":"全部","N":"非关联医嘱","Y":"关联医嘱")
	.s linkOrdSeqDesc=..Translate(linkOrdSeqDesc, "dhcpha.pivas.orderlinkord.csp")
    .s poloId=(polId_"||"_ChildSub)
	.d outputOrdLinkOrd
	Quit $$$OK
outputOrdLinkOrd
	s Data=$lb(poloId,arcimId,arcimCode,arcimDesc,arcimQty,linkOrdPack,linkOrdPackDesc,linkOrdSeq,linkOrdSeqDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// description: 批量保存配液大类设置-关联收费项
ClassMethod SaveOrdLinkOrdMulti(inputData)
{
	q:inputData="" "-1^没有需要保存的数据"
	s errCode=""
	s inputLen=$l(inputData,"!!")
	f inputI=1:1:inputLen d
	.s iData=$p(inputData,"!!",inputI)
	.q:iData=""
	.s saveRet=..SaveOrdLinkOrd(iData)
	.i $p(saveRet,"^",1)<0 d
	..s saveErrInfo=$p(saveRet,"^",2)
	..i errCode="" s errCode="-1^"_saveErrInfo
	..e  s errCode=errCode_"</br>"_saveErrInfo
	q:errCode'="" errCode
	q 0
}

/// creator: 	 yunhaibao
/// createdate:  2018-03-19
/// description: 保存关联的收费用医嘱项
ClassMethod SaveOrdLinkOrd(inputStr)
{
	s polId=$p(inputStr,"^",1)
	s arcItmId=$p(inputStr,"^",2)
	s arcItmQty=$p(inputStr,"^",3)
	s linkOrdPack=$p(inputStr,"^",4)
	s seqFlag=$p(inputStr,"^",5)
	i linkOrdPack="A" s linkOrdPack=""
	i seqFlag="A" s seqFlag=""
	q:polId="" "-1^配液大类Id为空"
	q:arcItmId="" "-1^医嘱项Id为空"
	q:arcItmQty="" "-1^数量为空"
	q:+arcItmQty<=0 "-1^数量不大于0"
	s errInfo=""
	&SQL(
		SELECT POLO_RowID FROM PIVA_OrderLinkOrder 
		WHERE 
		POLO_POL_ParRef=:polId AND POLO_Arcim_Dr=:arcItmId AND POLO_PackFlag=:linkOrdPack AND POLO_SeqFlag=:seqFlag
	)
	q:SQLCODE=0 "-1^已维护该类型此医嘱项"
	s polSub=$o(^POLI(polId,"M",""),-1)+1
	&SQL(
		insert into PIVA_OrderLinkOrder
		(POLO_POL_ParRef,POLO_ChildSub,POLO_Arcim_Dr,POLO_AddQty,POLO_PackFlag,POLO_SeqFlag)
		values
		(:polId,:polSub,:arcItmId,:arcItmQty,:linkOrdPack,:seqFlag)
	)
	q:SQLCODE'=0 "-2^保存失败"_%msg
	s poloId=$P(%ROWID,$C(1))
	s newJson={}
	s POLIM=$G(^POLI(+poloId,"M",+$p(poloId,"||",2)))
	q:POLIM="" "-1^数据库已不存在该记录"
	s arcimId=$p(POLIM,"^",1)
	s arcimQty=$p(POLIM,"^",4)	
	s linkOrdPack=$p(POLIM,"^",6)
	i linkOrdPack="" s linkOrdPack="A"
	s linkOrdPackDesc=$case(linkOrdPack,"A":"全部","N":"配液","Y":"打包")
	s linkOrdSeq=$p(POLIM,"^",7)
	i linkOrdSeq="" s linkOrdSeq="A"
	s linkOrdSeqDesc=$case(linkOrdSeq,"A":"全部","N":"非关联医嘱","Y":"关联医嘱")
	s ordLinkDesc=$p($g(^POLI(+poloId)),"^",1)
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
	s newJson={}
	s newJson."医嘱项代码"=$p($g(^ARCIM(+arcimId,1,1)),"^",1)
	s newJson."医嘱项名称"=arcimDesc
	s newJson."数量"=arcimQty
	s newJson."类型"=linkOrdPackDesc
	s newJson."配液大类"=ordLinkDesc
	s newJson."关联医嘱"=linkOrdSeqDesc
	
	s newJsonStr=newJson.%ToJSON()
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLinkOrder","User.PIVAOrderLinkOrder",..#LogSign,poloId,"收费设置: "_ordLinkDesc_"->"_arcimDesc,"A",newJsonStr)	
	q 0_"^保存成功"
}

/// creator: 	 yunhaibao
/// createdate:  2018-03-19
/// description: 删除关联的收费用医嘱项
ClassMethod DeletePIVAOrderLinkOrder(poloId)
{
	q:poloId="" "-1^Id为空"
	s POLIM=$G(^POLI(+poloId,"M",+$p(poloId,"||",2)))
	q:POLIM="" "-1^数据库已不存在该记录"
	s arcimId=$p(POLIM,"^",1)
	s arcimQty=$p(POLIM,"^",4)	
	s linkOrdPack=$p(POLIM,"^",6)
	i linkOrdPack="" s linkOrdPack="A"
	s linkOrdPackDesc=$case(linkOrdPack,"A":"全部","N":"配液","Y":"打包")
	s linkOrdSeq=$p(POLIM,"^",7)
	i linkOrdSeq="" s linkOrdSeq="A"
	s linkOrdSeqDesc=$case(linkOrdSeq,"A":"全部","N":"非关联医嘱","Y":"关联医嘱")
	s ordLinkDesc=$p($g(^POLI(+poloId)),"^",1)
	s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
	s delJson={}
	s delJson."医嘱项代码"=$p($g(^ARCIM(+arcimId,1,1)),"^",1)
	s delJson."医嘱项名称"=arcimDesc
	s delJson."数量"=arcimQty
	s delJson."类型"=linkOrdPackDesc
	s delJson."配液大类"=ordLinkDesc
	s delJson."关联医嘱"=linkOrdSeqDesc
	s delJsonStr=delJson.%ToJSON()
	&SQL(DELETE FROM PIVA_OrderLinkOrder WHERE POLO_RowID=:poloId)
	q:SQLCODE'=0 "-2^删除失败"_$g(%msg)
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLinkOrder","User.PIVAOrderLinkOrder",..#LogSign,poloId,"收费设置: "_ordLinkDesc_"->"_arcimDesc,"D",delJsonStr)
	q 0
}

/// Deccription:查询配液大类关联的收费规则
/// Table:      User.PHAPIVASFeeRule
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.OrderLink","OrderLinkFeeRule",1)
Query OrderLinkFeeRule(POLIID = "", HospId = "", LinkFlag As %Boolean = "") As websys.Query(ROWSPEC = "ruleID,ruleDesc,ruleItmData,ruleLinkData,linked")
{
}

ClassMethod OrderLinkFeeRuleExecute(ByRef qHandle As %Binary, POLIID = "", HospId = "", LinkFlag As %Boolean = "") As %Status
{
	k OrderLinkFeeRuleDATA
	s ind=1
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	q:+POLIID=0 $$$OK
	q:(LinkFlag = "") $$$OK
	s feeRulesList=$lfs($p($g(^POLI(POLIID)),"^",6),",")
	s ruleID=0
	f  s ruleID=$o(^CF.PHA.PIVAS.FeeRule(ruleID)) q:ruleID=""  d
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("PHAPIVAS_FeeRule",ruleID,HospId) //医院级别授权
    .q:flag="N"
	.s ruleDesc=$p(^CF.PHA.PIVAS.FeeRule(ruleID),"^",1)
	.s ruleItmData=""
	.s ruleItm=0,cnt=0
	.f  s ruleItm=$o(^CF.PHA.PIVAS.FeeRule(ruleID,"I",ruleItm)) q:ruleItm=""  d
	..s FeeRuleIData=^CF.PHA.PIVAS.FeeRule(ruleID,"I",ruleItm)
	..s type=$p(FeeRuleIData,"^",1)
	..s typeDesc=##class(web.DHCSTPIVAS.FeeRule).TypeToDesc(type)
	..s operate=$p(FeeRuleIData,"^",2)
	..s operateDesc=##class(web.DHCSTPIVAS.FeeRule).OperateToDesc(operate)
	..s typeVal=$p(FeeRuleIData,"^",3)
	..s typeValDesc=##class(web.DHCSTPIVAS.FeeRule).TypeValToDesc(type,typeVal)
	..s itmData="<b>"_typeDesc_"</b>　<b>"_operateDesc_"</b>　"_typeValDesc
	..s cnt=cnt+1
	..i cnt=1 s itmData="<div style='line-height:28px;white-space: nowrap;'>"_itmData_"</div>"
	..e  s itmData="<div style='border-top:1px dashed #cccccc;line-height:28px;white-space: nowrap;'>"_itmData_"</div>"
	..s ruleItmData=ruleItmData_itmData
	.s ruleLinkData=""
	.s cnt=0
	.s ruleLink=0
	.f  s ruleLink=$o(^CF.PHA.PIVAS.FeeRule(ruleID,"L",ruleLink)) q:ruleLink=""  d
	..s FeeRuleLData=^CF.PHA.PIVAS.FeeRule(ruleID,"L",ruleLink)
	..s arcim=$p(FeeRuleLData,"^",1)
	..s arcimDesc=$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",2)
	..s qty=$p(FeeRuleLData,"^",2)
	..s itmData="<div style='float:left;width:20px;text-align:right;'>"_qty_"</div><div style='float:left;padding-left:10px;'>/　"_arcimDesc_"</div>"
	..s cnt=cnt+1
	..i cnt=1 s itmData="<div style='width:1000px'>"_itmData_"</div>"
	..e  s itmData="<div style='border-top:1px dashed #cccccc;width:1000px'>"_itmData_"</div>"
	..s ruleLinkData=ruleLinkData_itmData
	.i $lf(feeRulesList,ruleID)>0 s linked="Y"
	.e  s linked=""
	.q:(LinkFlag = $$$YES)&&(linked '= "Y")
	.q:(LinkFlag = $$$NO)&&(linked = "Y")
	.s ^CacheTemp(repid,ind)=$lb(ruleID,ruleDesc,ruleItmData,ruleLinkData,linked)    
	.s ind=ind+1
	q $$$OK
}

/// Description: 保存配液大类与收费规则的关联
ClassMethod SaveOrderFeeRule(POLIID, FeeRuleIDStr)
{
	q:+POLIID=0 "-1^配液大类为空"
	s oldJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", POLIID)
	s oldJsonStr = ##class(web.DHCSTPIVAS.Util).ReplaceJsonComma(oldJsonStr, "POL_FeeRules")
	&SQL(
		UPDATE PIVA_OrderLink 
		SET POL_FeeRules=:FeeRuleIDStr
		WHERE POL_Rowid=:POLIID
	)
	q:SQLCODE'=0 "-1^保存失败"_$g(%msg)
	
	s logSignDesc = "关联收费规则: " _ ..GetLogSignDesc(POLIID)
	s newJsonStr = ##class(web.DHCST.Common.JsonObj).GetValue("PIVA_OrderLink", POLIID)
	s newJsonStr = ##class(web.DHCSTPIVAS.Util).ReplaceJsonComma(newJsonStr, "POL_FeeRules")
	s logType = "A"
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PIVA_OrderLink","User.PIVAOrderLink", ..#LogSign, POLIID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))
	q 0
}

ClassMethod CodeToID(code, HospId)
{
	s RetRowID=""
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^POLI(Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s tmpCode=$p(^POLI(Rowid),"^",5)
	.q:tmpCode'=code
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod DescToID(desc, HospId)
{
	
	s RetRowID=""
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^POLI(Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s tmpDesc=$p(^POLI(Rowid),"^",1)
	.q:tmpDesc'=desc
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

/// description: 判断代码描述是否重复
/// return:      -1^验证信息
ClassMethod CheckExist(rowId, code, desc, HospId = "")
{
 	s errCode=""
 	s tmpId=..CodeToID(code,HospId)
 	i (tmpId'="")&&(tmpId'=rowId) s errCode="-1^代码已存在:"_code
	s tmpId=..DescToID(desc,HospId)
 	i (tmpId'="")&&(tmpId'=rowId) s errCode="-1^名称已存在:"_desc
	q errCode
}

ClassMethod GetLogSignDesc(rowID)
{
    &SQL(
		SELECT POL_Desc INTO :ret
		FROM PIVA_OrderLink		
		WHERE %ID = :rowID
    )
    q $g(ret)
}

}
