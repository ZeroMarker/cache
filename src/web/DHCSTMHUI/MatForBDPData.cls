Import sqluser

/// Descript:	调用基础数据平台方法
/// Creator:	lihui
/// CreateDate:	20200327
Class web.DHCSTMHUI.MatForBDPData Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 公共调用
/// ##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag(2)	获取医院授权是否开启
/// ##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC","aa","DHC_SourceOfFund",2,"")	检查代码/名称是否重复
/// ##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE","高值材料","INC_StkCat",2)	依据代码/名称取ID
/// ##class(web.DHCSTMHUI.MatForBDPData).GetTableType("DHCST_BookCat")	获取表类型
/// 
/// 使用平台关联表（医院保存在关联表中）
/// ##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHCST_BookCat",1,2)	保存医院关联
/// ##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals(表名,rowid)	删除医院关联
/// ##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_StkCatGroup",1,2)	获取数据展示判断
/// 
/// 单独处理
/// 库存项，医嘱项
/// ##class(web.DHCSTMHUI.MatForBDPData).SaveInciHOSP(Incid,医院ID)	保存库存项医院关联
/// ##class(web.DHCSTMHUI.MatForBDPData).DeleteInciHOSP(Incid,医院ID)	删除库存项医院关联
/// ##class(web.DHCSTMHUI.MatForBDPData).SaveArcHOSP(ArcimId,医院ID)	保存医嘱项医院关联
/// ##class(web.DHCSTMHUI.MatForBDPData).DeleteArcHOSP(ArcimId,医院ID)	删除医嘱项医院关联
/// 
/// 
/// 
/// Descript:	根据session来获取此角色的真实医院级别权限
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	医院ID	
/// return: Y：有权限；N:无权限
/// (off:未启用医院级别授权;1:不受限制; {limited:1,IDS:[{ID:2},{ID:3}]} :其中2,3为所能看到哪些医院数据的 医院rowid)
/// w ##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag(2)
ClassMethod GetHospAutFlag(gHospId = "") As %String
{
	n (%session,gHospId)
	
	i '$d(^||TMPDHCSTM("GetHospAutFlag",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPConfig||GetConfigValue"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s BDPHospAutFlag="N"
	.i $IsObject(CompiledObj) d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPDHCSTM("GetHospAutFlag",$j)=BDPHospAutFlag
	e  d
	.s BDPHospAutFlag=$p(^||TMPDHCSTM("GetHospAutFlag",$j),"^",1)
	q BDPHospAutFlag
}

/// Descript:	获取BDP_MappingHosp内对应的数据ID
/// 			基础数据,多院区改造模式用到
/// Creator:	wangjiabin
/// CreateDate:	20200528
/// Input:		表名, 医院ID, 表内记录rowid
/// return:		BDP_MappingHosp记录rowid
ClassMethod GetBDPMapId(TableName, HospId, Reference) As %String
{
	n (TableName,HospId,Reference)
	q:(TableName="")||(HospId="")||(Reference="") ""
	s BDPMapId=$o(^User.BDPMappingHospI("DataRef",TableName,HospId,Reference,""),-1) 
	q BDPMapId
}

/// Descript:	保存库存项与医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Talbe: INC_Itm
/// Input: 	Incid,医院ID	
/// return: 成功:0；失败:负数
/// w ##class(web.DHCSTMHUI.MatForBDPData).SaveInciHOSP(Incid,医院ID)
ClassMethod SaveInciHOSP(Incid, HospId) As %String
{
	n (Incid, HospId,%session)
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	q:BDPHospAutFlag'="Y" 0
	q:HospId="" -1
	q:Incid="" -1
	q:'$d(^INCI(Incid)) -1
	
	s HospId=..GetDefHospId("INC_Itm",HospId)
	
	s ShowDataFlag=..GetShowDataFlag("INC_Itm",Incid, HospId,"Y")  ;已经存在
	q:ShowDataFlag="Y" 0
	s ret=0
	s NotUseFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(Incid)
	s NowDate=+$h
	&sql(INSERT INTO DHC_ItmAddHosp (IAH_IncItm_DR, IAH_Hospital_DR,IAH_StartDate, IAH_NotUseFlag) VALUES(:Incid,:HospId,:NowDate,:NotUseFlag))
	i SQLCODE s ret=-2
	q ret
}

/// Descript:	删除库存项与医院关联
/// Creator:	lihui
/// CreateDate:	20200514
/// Talbe: INC_Itm
/// Input: 	Incid,医院ID	
/// return: 成功:0；失败:负数
/// w ##class(web.DHCSTMHUI.MatForBDPData).DeleteInciHOSP(Incid,医院ID)
ClassMethod DeleteInciHOSP(Incid, HospId) As %String
{
	n (Incid, HospId,%session)
	q:HospId="" -1
	q:Incid="" -1
	q:'$d(^INCI(Incid)) -1
	s ret=0
	
	s HospId=..GetDefHospId("INC_Itm",HospId)
	
	s IAHROWID=$o(^ITMADDHOP(0,"HospInc",HospId,Incid,""))
	i IAHROWID'=""
	.&sql(DELETE DHC_ItmAddHosp WHERE IAH_ROWID=:IAHROWID)
	.i SQLCODE s ret=-2
	q ret
}

/// Descript:	保存医嘱项与医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	ArcimId,医院ID	
/// return: 成功:ID^添加成功；失败:-1^添加失败
/// w ##class(web.DHCSTMHUI.MatForBDPData).SaveArcHOSP(ArcimId,医院ID)
ClassMethod SaveArcHOSP(ArcimId, HospId) As %String
{
	n (ArcimId, HospId,%session)
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	q:BDPHospAutFlag'="Y" 0
	q:ArcimId="" -1
	q:HospId="" -1
	q:'$d(^ARCIM(+ArcimId,$p(ArcimId,"||",2))) -1
	
	s HospId=..GetDefHospId("ARC_ItmMast",HospId)
	
	s ShowDataFlag=..GetShowDataFlag("ARC_ItmMast",ArcimId, HospId,"Y")  ;已经存在
	q:ShowDataFlag="Y" 0
	s chl=$o(^ARCIM(+ArcimId,$p(ArcimId,"||",2),"HOSP",""),-1)+1
	s ret=0
	&sql(INSERT INTO ARC_ItemHosp (HOSP_ParRef,HOSP_Childsub,HOSP_Hospital_DR) VALUES (:ArcimId,:chl,:HospId))
	i SQLCODE s ret=-2
	q ret
}

/// Descript:	删除医嘱项与医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	ArcimId,医院ID	
/// return: 成功:ID^添加成功；失败:-1^添加失败
/// w ##class(web.DHCSTMHUI.MatForBDPData).DeleteArcHOSP(ArcimId,医院ID)
ClassMethod DeleteArcHOSP(ArcimId, HospId) As %String
{
	n (ArcimId, HospId,%session)
	q:ArcimId="" -1
	q:HospId="" -1
	q:'$d(^ARCIM(+ArcimId,$p(ArcimId,"||",2))) -1
	
	s HospId=..GetDefHospId("ARC_ItmMast",HospId)
	
	s HOSPchl=$o(^ARCIM(+ArcimId,$p(ArcimId,"||",2),"HOSP",0,"Hosp",HospId,""))
	q:HOSPchl="" 0
	s HOSPRowId=ArcimId_"||"_HOSPchl
	s ret=0
	i HOSPRowId'="" d
	.&sql(DELETE ARC_ItemHosp WHERE HOSP_RowId=:HOSPRowId)
	.i SQLCODE s ret=-2
	q ret
}

/// Descript:	获取重复id
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	授权开启标志，表类型，表名称，医院id，重复id，原始id，计数	
/// return: 成功:ID^添加成功；失败:-1^添加失败
/// w ##class(web.DHCSTMHUI.MatForBDPData).DeleteArcHOSP(ArcimId,医院ID)
ClassMethod GetRepeatId(BDPHospAutFlag, TableType, tableName, HospId, Rowid, OriRowId, count)
{
	n (BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,count)
	s repeatFlag="Y"
	q:(OriRowId'="")&&(OriRowId=Rowid) ""	;过滤修改
	s flag="Y"
	s count=count+1
	i ((BDPHospAutFlag="Y")&&(TableType'="G")&&(TableType'="C"))  d
	.s flag = ..GetShowDataFlag(tableName,Rowid,HospId,"",repeatFlag) //医院级别授权
	q:flag="N" ""
	q:(BDPHospAutFlag'="Y")&&(count>0) Rowid
	q Rowid
}

/// Descript:	库存分类,库存项,医嘱项,收费项等 判断代码或者名称是否重复
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	type(代码:CODE;名称:DESC),类型值,表名,医院ID,原始数据RowId	
/// return: 重复:id 不重复:空 报错:小于0
/// w ##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE","代码1","",817,"")
ClassMethod CodeDescIfRepeat(type, value, tableName, HospId, OriRowId = "", StkType = "M", other = "")
{
	n (type, value, tableName, HospId, OriRowId,StkType,other,%session)
	//q:(type="")||(value="")||(tableName="")||(HospId="") -1
	q:(type="")||(value="")||(tableName="") -1	//||(HospId="") 2021/1/28   医院为空，则判断所有医院数据
	
	s TableType=..GetTableType(tableName)  //表类型
	s RetRowID=""
	s tmpvalue=value
	s tmpOriRowId=OriRowId
	s tmpStkType=StkType
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //医院级别授权是否开启
	s repeatFlag="Y"
	
	;库存分类
	i (type="CODE")&&(tableName="INC_StkCat") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^INC("SC",0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..
	i (type="DESC")&&(tableName="INC_StkCat") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^INC("SC",0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="PRECODE")&&(tableName="INC_StkCat") d
	.s Rowid=0,count=0
	.&sql(declare codecatrepeat cursor for 
		select %ID from INC_StkCat
		where INCSC_Prefix=:tmpvalue and INCSC_StkType='M')
	.&sql(open codecatrepeat)
	.f  &sql(fetch codecatrepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close codecatrepeat)
	
	;类组
	i (type="CODE")&&(tableName="DHC_StkCatGroup") d
	.s Rowid=0,count=0
	.&sql(declare codescgrepeat cursor for 
		select %ID from DHC_StkCatGroup
		where SCG_Code=:tmpvalue and SCG_Type='M')
	.&sql(open codescgrepeat)
	.f  &sql(fetch codescgrepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close codescgrepeat)
	
	i (type="DESC")&&(tableName="DHC_StkCatGroup") d
	.s Rowid=0,count=0
	.&sql(declare descscgrepeat cursor for 
		select %ID from DHC_StkCatGroup
		where SCG_Desc=:tmpvalue and SCG_Type='M')
	.&sql(open descscgrepeat)
	.f  &sql(fetch descscgrepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close descscgrepeat)
	
	;库存项
	i (type="CODE")&&(tableName="INC_Itm") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s HospId=..GetDefHospId(tableName,HospId)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^INCI(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="DESC")&&(tableName="INC_Itm") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^INCI(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;医嘱项
	i (type="CODE")&&(tableName="ARC_ItmMast") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s HospId=..GetDefHospId(tableName,HospId)
	.s Paref=0,count=0
	.f  s Paref=$o(^ARCIM(0,"Code",value,Paref)) q:(+Paref=0)||(RetRowID'="")  d
	..s chl=$o(^ARCIM(0,"Code",value,Paref,""))
	..q:chl=""
	..s Rowid=Paref_"||"_chl
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="ARC_ItmMast") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s HospId=..GetDefHospId(tableName,HospId)
	.s Paref=0,count=0
	.f  s Paref=$o(^ARCIM(0,"Desc",value,Paref)) q:(+Paref=0)||(RetRowID'="")  d
	..s chl=$o(^ARCIM(0,"Desc",value,Paref,""))
	..q:chl=""
	..s Rowid=Paref_"||"_chl
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;收费项
	i (type="CODE")&&(tableName="DHC_TarItem") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCTARI(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="DHC_TarItem") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCTARI(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;定价类型
	i (type="CODE")&&(tableName="DHC_MarkType") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCINMT(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d  
	..s Type=$p(^DHCINMT(Rowid),"^",5)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="DHC_MarkType") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCINMT(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCINMT(Rowid),"^",5)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;小数规则
	i (type="CODE")&&(tableName="DHC_StkDecimal") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCSD(0,"NAME",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d  
	..s Type=$p(^DHCSD(Rowid),"^",4)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;定价规则
	i (type="CODE")&&(tableName="DHC_MarkRule") d
	.s Rowid=0,count=0
	.&sql(declare codemarkrulerepeat cursor for 
		select %ID from DHC_MarkRule
		where MR_Code=:tmpvalue and MR_Type='M')
	.&sql(open codemarkrulerepeat)
	.f  &sql(fetch codemarkrulerepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close codemarkrulerepeat)
	
	i (type="DESC")&&(tableName="DHC_MarkRule") d
	.s Rowid=0,count=0
	.&sql(declare descmarkrulerepeat cursor for 
		select %ID from DHC_MarkRule
		where MR_Desc=:tmpvalue and MR_Type='M')
	.&sql(open descmarkrulerepeat)
	.f  &sql(fetch descmarkrulerepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close descmarkrulerepeat)
	
	;配送商
	i (type="CODE")&&(tableName="DHC_Carrier") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCCARR(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCCARR(Rowid),"^",3)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="DHC_Carrier") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCCARR(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCCARR(Rowid),"^",3)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;科室项目组
	i (type="CODE")&&(tableName="DHC_LocItemGrp") d
	.s Rowid=0,count=0
	.&sql(declare codelocitemgrprepeat cursor for 
		select %ID from DHC_LocItemGrp
		where LIG_Code=:tmpvalue)
	.&sql(open codelocitemgrprepeat)
	.f  &sql(fetch codelocitemgrprepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close codelocitemgrprepeat)
	
	i (type="DESC")&&(tableName="DHC_LocItemGrp") d
	.s Rowid=0,count=0
	.&sql(declare desclocitemgrprepeat cursor for 
		select %ID from DHC_LocItemGrp
		where LIG_Desc=:tmpvalue)
	.&sql(open desclocitemgrprepeat)
	.f  &sql(fetch desclocitemgrprepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close desclocitemgrprepeat)
	
	;科室组
	i (type="CODE")&&(tableName="DHC_StkLocGroup") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare codestklocgrouprepeat cursor for 
		select %ID from DHC_StkLocGroup
		where SLG_Code=:tmpvalue and SLG_Type='M')
	.&sql(open codestklocgrouprepeat)
	.f  &sql(fetch codestklocgrouprepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close codestklocgrouprepeat)
	
	i (type="DESC")&&(tableName="DHC_StkLocGroup") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare descstklocgrouprepeat cursor for 
		select %ID from DHC_StkLocGroup
		where SLG_Desc=:tmpvalue and SLG_Type='M')
	.&sql(open descstklocgrouprepeat)
	.f  &sql(fetch descstklocgrouprepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close descstklocgrouprepeat)
	
	;招标轮次
	i (type="CODE")&&(tableName="DHC_PublicBiddingList") d
	.s Rowid=0,count=0
	.&sql(declare CODEPublicBiddingListRepeat cursor for 
		select %ID from DHC_PublicBiddingList
		where DHCPBL_Code=:tmpvalue and DHCPBL_Type='M')
	.&sql(open CODEPublicBiddingListRepeat)
	.f  &sql(fetch CODEPublicBiddingListRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEPublicBiddingListRepeat)
	
	i (type="DESC")&&(tableName="DHC_PublicBiddingList") d
	.s Rowid=0,count=0
	.&sql(declare DESCPublicBiddingListRepeat cursor for 
		select %ID from DHC_PublicBiddingList
		where DHCPBL_Desc=:tmpvalue and DHCPBL_Type='M')
	.&sql(open DESCPublicBiddingListRepeat)
	.f  &sql(fetch DESCPublicBiddingListRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCPublicBiddingListRepeat)
	
	;招标级别
	i (type="CODE")&&(tableName="DHC_ItmPBLevel") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCITMPBL(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="DHC_ItmPBLevel") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCITMPBL(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;支付方式
	i (type="CODE")&&(tableName="CT_PayMode") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEPayModeRepeat cursor for 
		select %ID from CT_PayMode
		where CTPM_Code=:tmpvalue)
	.&sql(open CODEPayModeRepeat)
	.f  &sql(fetch CODEPayModeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEPayModeRepeat)
	
	i (type="DESC")&&(tableName="CT_PayMode") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCPayModeRepeat cursor for 
		select %ID from CT_PayMode
		where CTPM_Code=:tmpvalue)
	.&sql(open DESCPayModeRepeat)
	.f  &sql(fetch DESCPayModeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCPayModeRepeat)
	
	;收费类型
	i (type="CODE")&&(tableName="DHC_ItmChargeType") d
	.s Rowid=0,count=0
	.&sql(declare CODEItmChargeTypeRepeat cursor for 
		select %ID from DHC_ItmChargeType
		where ICT_Code=:tmpvalue)
	.&sql(open CODEItmChargeTypeRepeat)
	.f  &sql(fetch CODEItmChargeTypeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEItmChargeTypeRepeat)
	
	i (type="DESC")&&(tableName="DHC_ItmChargeType") d
	.s Rowid=0,count=0
	.&sql(declare DESCItmChargeTypeRepeat cursor for 
		select %ID from DHC_ItmChargeType
		where ICT_Desc=:tmpvalue)
	.&sql(open DESCItmChargeTypeRepeat)
	.f  &sql(fetch DESCItmChargeTypeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCItmChargeTypeRepeat)
	
	;账簿分类
	i (type="CODE")&&(tableName="DHCST_BookCat") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCSTBC(0,"CODE",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="DHCST_BookCat") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCSTBC(0,"DESC",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;资金来源
	i (type="CODE")&&(tableName="DHC_SourceOfFund") d
	.s Rowid=0,count=0
	.&sql(declare CODESourceOfFundRepeat cursor for 
		select %ID from DHC_SourceOfFund
		where SOF_Code=:tmpvalue)
	.&sql(open CODESourceOfFundRepeat)
	.f  &sql(fetch CODESourceOfFundRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODESourceOfFundRepeat)
	
	i (type="DESC")&&(tableName="DHC_SourceOfFund") d
	.s Rowid=0,count=0
	.&sql(declare DESCSourceOfFundRepeat cursor for 
		select %ID from DHC_SourceOfFund
		where SOF_Desc=:tmpvalue)
	.&sql(open DESCSourceOfFundRepeat)
	.f  &sql(fetch DESCSourceOfFundRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCSourceOfFundRepeat)
	
	;不可用原因
	i (type="DESC")&&(tableName="DHC_ItmNotUseReason") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCNUR(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;质量层次
	i (type="CODE")&&(tableName="DHC_ItmQualityLevel") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCITMQL(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="DHC_ItmQualityLevel") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCITMQL(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;灭菌分类
	i (type="DESC")&&(tableName="INC_SterileCategory") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCSterileCategoryRepeat cursor for 
		select %ID from INC_SterileCategory
		where SCAT_Desc=:tmpvalue)
	.&sql(open DESCSterileCategoryRepeat)
	.f  &sql(fetch DESCSterileCategoryRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCSterileCategoryRepeat)
	
	;调整原因
	i (type="CODE")&&(tableName="INC_ReasonForAdjustment") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEReasonForAdjustmentRepeat cursor for 
		select %ID from INC_ReasonForAdjustment
		where ADJ_Code=:tmpvalue and ADJ_StkType='M')
	.&sql(open CODEReasonForAdjustmentRepeat)
	.f  &sql(fetch CODEReasonForAdjustmentRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEReasonForAdjustmentRepeat)
	
	i (type="DESC")&&(tableName="INC_ReasonForAdjustment") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCReasonForAdjustmentRepeat cursor for 
		select %ID from INC_ReasonForAdjustment
		where ADJ_Desc=:tmpvalue and ADJ_StkType='M')
	.&sql(open DESCReasonForAdjustmentRepeat)
	.f  &sql(fetch DESCReasonForAdjustmentRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCReasonForAdjustmentRepeat)
	
	;调价原因
	i (type="CODE")&&(tableName="DHC_ReasonForAdjustPrice") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEReasonForAdjustPriceRepeat cursor for 
		select %ID from DHC_ReasonForAdjustPrice
		where REA_Code=:tmpvalue and REA_StkType='M')
	.&sql(open CODEReasonForAdjustPriceRepeat)
	.f  &sql(fetch CODEReasonForAdjustPriceRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEReasonForAdjustPriceRepeat)
	
	i (type="DESC")&&(tableName="DHC_ReasonForAdjustPrice") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCReasonForAdjustPriceRepeat cursor for 
		select %ID from DHC_ReasonForAdjustPrice
		where REA_Desc=:tmpvalue and REA_StkType='M')
	.&sql(open DESCReasonForAdjustPriceRepeat)
	.f  &sql(fetch DESCReasonForAdjustPriceRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCReasonForAdjustPriceRepeat)
	
	;报损原因
	i (type="CODE")&&(tableName="DHC_IncReasonForStockScrap") d
	.s Rowid=0,count=0
	.&sql(declare CODEIncReasonForStockScrapRepeat cursor for 
		select %ID from DHC_IncReasonForStockScrap
		where REASON_ScrapCode=:tmpvalue and REASON_ScrapType='M')
	.&sql(open CODEIncReasonForStockScrapRepeat)
	.f  &sql(fetch CODEIncReasonForStockScrapRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEIncReasonForStockScrapRepeat)
	
	i (type="DESC")&&(tableName="DHC_IncReasonForStockScrap") d
	.s Rowid=0,count=0
	.&sql(declare DESCIncReasonForStockScrapRepeat cursor for 
		select %ID from DHC_IncReasonForStockScrap
		where REASON_ScrapDesc=:tmpvalue and REASON_ScrapType='M')
	.&sql(open DESCIncReasonForStockScrapRepeat)
	.f  &sql(fetch DESCIncReasonForStockScrapRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCIncReasonForStockScrapRepeat)
	
	;退货原因
	i (type="CODE")&&(tableName="INC_ReasonForReturn") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEReasonForReturnRepeat cursor for 
		select %ID from INC_ReasonForReturn
		where RET_Code=:tmpvalue and RET_StkType='M')
	.&sql(open CODEReasonForReturnRepeat)
	.f  &sql(fetch CODEReasonForReturnRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEReasonForReturnRepeat)
	
	i (type="DESC")&&(tableName="INC_ReasonForReturn") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCReasonForReturnRepeat cursor for 
		select %ID from INC_ReasonForReturn
		where RET_Desc=:tmpvalue and RET_StkType='M')
	.&sql(open DESCReasonForReturnRepeat)
	.f  &sql(fetch DESCReasonForReturnRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCReasonForReturnRepeat)
	
	;订单取消原因
	i (type="CODE")&&(tableName="INC_POCanc_FullFillReason") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEPOCancFullFillReasonRepeat cursor for 
		select %ID from INC_POCanc_FullFillReason
		where CFR_Code=:tmpvalue and CFR_StkType='M')
	.&sql(open CODEPOCancFullFillReasonRepeat)
	.f  &sql(fetch CODEPOCancFullFillReasonRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEPOCancFullFillReasonRepeat)
	
	i (type="DESC")&&(tableName="INC_POCanc_FullFillReason") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCPOCancFullFillReasonRepeat cursor for 
		select %ID from INC_POCanc_FullFillReason
		where CFR_Desc=:tmpvalue and CFR_StkType='M')
	.&sql(open DESCPOCancFullFillReasonRepeat)
	.f  &sql(fetch DESCPOCancFullFillReasonRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCPOCancFullFillReasonRepeat)
	
	;请求单拒绝原因
	i (type="CODE")&&(tableName="DHC_ReasonForRefuseRequest") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEReasonForRefuseRequestRepeat cursor for 
		select %ID from DHC_ReasonForRefuseRequest
		where RF_Code=:tmpvalue and RF_StkType='M')
	.&sql(open CODEReasonForRefuseRequestRepeat)
	.f  &sql(fetch CODEReasonForRefuseRequestRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEReasonForRefuseRequestRepeat)
	
	i (type="DESC")&&(tableName="DHC_ReasonForRefuseRequest") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCReasonForRefuseRequestRepeat cursor for 
		select %ID from DHC_ReasonForRefuseRequest
		where RF_Desc=:tmpvalue and RF_StkType='M')
	.&sql(open DESCReasonForRefuseRequestRepeat)
	.f  &sql(fetch DESCReasonForRefuseRequestRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCReasonForRefuseRequestRepeat)
	
	; 盘点损益原因
	i (type="CODE")&&(tableName="DHC_InStktkReason") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEDHCInStktkReasonRepeat cursor for 
		select %ID from DHC_InStktkReason
		where ISR_Code=:tmpvalue and ISR_Type='M')
	.&sql(open CODEDHCInStktkReasonRepeat)
	.f  &sql(fetch CODEDHCInStktkReasonRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEDHCInStktkReasonRepeat)
	i (type="DESC")&&(tableName="DHC_InStktkReason") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCDHCInStktkReasonRepeat cursor for 
		select %ID from DHC_InStktkReason
		where ISR_Desc=:tmpvalue and ISR_Type='M')
	.&sql(open DESCDHCInStktkReasonRepeat)
	.f  &sql(fetch DESCDHCInStktkReasonRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCDHCInStktkReasonRepeat)
	;出入库类型
	i (type="CODE")&&(tableName="DHC_OperateType") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEOperateTypeRepeat cursor for 
		select %ID from DHC_OperateType
		where IPT_Code=:tmpvalue and IPT_Type=:tmpStkType)
	.&sql(open CODEOperateTypeRepeat)
	.f  &sql(fetch CODEOperateTypeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEOperateTypeRepeat)
	
	i (type="DESC")&&(tableName="DHC_OperateType") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCOperateTypeRepeat cursor for 
		select %ID from DHC_OperateType
		where IPT_Desc=:tmpvalue and IPT_Type=:tmpStkType)
	.&sql(open DESCOperateTypeRepeat)
	.f  &sql(fetch DESCOperateTypeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCOperateTypeRepeat)
	
	;高值标志关联医嘱收费
	i (type="CODE")&&(tableName="DHC_HvMapArc") d
	.&sql(select %ID into :Rowid from DHC_HvMapArc
		where HMA_HvFlag=:tmpvalue and HMA_RowID<>nvl(:tmpOriRowId,''))
	.i Rowid'="" d
	..i BDPHospAutFlag="Y" d
	...s flag = ..GetShowDataFlag(tableName,Rowid,HospId,"",repeatFlag) //医院级别授权
	...i flag="Y" s RetRowID=Rowid
	..e  d
	...s RetRowID=Rowid
	
	;供应商分类
	i (type="CODE")&&(tableName="APC_VendCat") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare CODEVendCatRepeat cursor for 
		select %ID from APC_VendCat
		where APCVC_Code=:tmpvalue and APCVC_StkType='M')
	.&sql(open CODEVendCatRepeat)
	.f  &sql(fetch CODEVendCatRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEVendCatRepeat)
	
	i (type="DESC")&&(tableName="APC_VendCat") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.&sql(declare DESCVendCatRepeat cursor for 
		select %ID from APC_VendCat
		where APCVC_Desc=:tmpvalue and APCVC_StkType='M')
	.&sql(open DESCVendCatRepeat)
	.f  &sql(fetch DESCVendCatRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCVendCatRepeat)
	
	;供应商评价指标
	i (type="CODE")&&(tableName="DHC_VendorEvaluationIndex") d
	.s Rowid=0,count=0
	.&sql(declare CODEVendorEvaluationIndexRepeat cursor for 
		select %ID from DHC_VendorEvaluationIndex
		where VEI_Code=:tmpvalue)
	.&sql(open CODEVendorEvaluationIndexRepeat)
	.f  &sql(fetch CODEVendorEvaluationIndexRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEVendorEvaluationIndexRepeat)
	
	i (type="DESC")&&(tableName="DHC_VendorEvaluationIndex") d
	.s Rowid=0,count=0
	.&sql(declare DESCVendorEvaluationIndexRepeat cursor for 
		select %ID from DHC_VendorEvaluationIndex
		where VEI_Desc=:tmpvalue)
	.&sql(open DESCVendorEvaluationIndexRepeat)
	.f  &sql(fetch DESCVendorEvaluationIndexRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCVendorEvaluationIndexRepeat)
	
	;产地
	i (type="CODE")&&(tableName="DHC_STOrigin") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCSTORI(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCSTORI(Rowid),"^",3)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..
	i (type="DESC")&&(tableName="DHC_STOrigin") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCSTORI(0,"Name",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCSTORI(Rowid),"^",3)
	..q:Type'="M"
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;供应商
	i (type="CODE")&&(tableName="APC_Vendor") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^APC("APCVM",0,"APCVM_Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s STV=$o(^DHCSTV(0,Rowid,0))
	..s StkType=$p(^APC("APCVM",Rowid),"^",9)
	..q:tmpStkType'=StkType
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	i (type="DESC")&&(tableName="APC_Vendor") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^APC("APCVM",0,"APCVM_Name",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s STV=$o(^DHCSTV(0,Rowid,0))
	..s StkType=$p(^APC("APCVM",Rowid),"^",9)
	..q:tmpStkType'=StkType
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;生产厂家
	i (type="CODE")&&(tableName="PH_Manufacturer") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^PHMNF(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s dhcmanfid=$o(^DHCMANF(0,"MANF",Rowid,""))
	..s StkType=$p(^DHCMANF(dhcmanfid),"^",7)
	..q:tmpStkType'=StkType
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..
	i (type="DESC")&&(tableName="PH_Manufacturer") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^PHMNF(0,"Name",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s dhcmanfid=$o(^DHCMANF(0,"MANF",Rowid,""))
	..s StkType=$p(^DHCMANF(dhcmanfid),"^",7)
	..q:tmpStkType'=StkType
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;采购审核级别
	i (type="CODE")&&(tableName="DHC_PlanStatus") d
	.s Rowid=0,count=0
	.&sql(declare CODEPlanStatusRepeat cursor for 
		select %ID from DHC_PlanStatus
		where DHCPS_Code=:tmpvalue and DHCPS_StkType='M')
	.&sql(open CODEPlanStatusRepeat)
	.f  &sql(fetch CODEPlanStatusRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEPlanStatusRepeat)
	
	i (type="DESC")&&(tableName="DHC_PlanStatus") d
	.s Rowid=0,count=0
	.&sql(declare DESCPlanStatusRepeat cursor for 
		select %ID from DHC_PlanStatus
		where DHCPS_Desc=:tmpvalue and DHCPS_StkType='M')
	.&sql(open DESCPlanStatusRepeat)
	.f  &sql(fetch DESCPlanStatusRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCPlanStatusRepeat)
	
	;官方分类
	i (type="CODE")&&(tableName="DHC_MatCatOfficial") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCMCO(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..
	i (type="DESC")&&(tableName="DHC_MatCatOfficial") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCMCO(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;临床分类
	i (type="CODE")&&(tableName="DHC_MatCatClinical") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCMCC(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..
	i (type="DESC")&&(tableName="DHC_MatCatClinical") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCMCC(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;特殊分类
	i (type="CODE")&&(tableName="DHC_MatCatSpecial") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCMCS(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..
	i (type="DESC")&&(tableName="DHC_MatCatSpecial") d
	.s value=$$ALPHAUP^SSUTIL4(value)
	.s Rowid=0,count=0
	.f  s Rowid=$o(^DHCMCS(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;资质类型
	i (type="CODE")&&(tableName="DHC_CertType") d
	.s Rowid=0,count=0
	.&sql(declare CODEDHCCertTypeeRepeat cursor for 
		select %ID from DHC_CertType
		where CT_Code=:tmpvalue and CT_Type=:tmpStkType)
	.&sql(open CODEDHCCertTypeeRepeat)
	.f  &sql(fetch CODEDHCCertTypeeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEOperateTypeRepeat)
	
	i (type="DESC")&&(tableName="DHC_CertType") d
	.s Rowid=0,count=0
	.&sql(declare DESCDHCCertTypeeRepeat cursor for 
		select %ID from DHC_CertType
		where CT_FullName=:tmpvalue and CT_Type=:tmpStkType)
	.&sql(open DESCDHCCertTypeeRepeat)
	.f  &sql(fetch DESCDHCCertTypeeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEOperateTypeRepeat)
	
	i (type="ALIASDESC")&&(tableName="DHC_CertType") d
	.s Rowid=0,count=0
	.&sql(declare ALIASDESCDHCCertTypeeRepeat cursor for 
		select %ID from DHC_CertType
		where CT_ShortName=:tmpvalue and CT_Type=:tmpStkType)
	.&sql(open ALIASDESCDHCCertTypeeRepeat)
	.f  &sql(fetch ALIASDESCDHCCertTypeeRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEOperateTypeRepeat)
	
	;经销商
	i (type="CODE")&&(tableName="DHC_Dealer") d
	.s Rowid=0,count=0
	.&sql(declare CODEDHCDealerRepeat cursor for 
		select %ID from DHC_Dealer
		where DL_Code=:tmpvalue)
	.&sql(open CODEDHCDealerRepeat)
	.f  &sql(fetch CODEDHCDealerRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEDHCDealerRepeat)
	
	i (type="DESC")&&(tableName="DHC_Dealer") d
	.s Rowid=0,count=0
	.&sql(declare DESCDHCDealerRepeat cursor for 
		select %ID from DHC_Dealer
		where DL_Name=:tmpvalue)
	.&sql(open DESCDHCDealerRepeat)
	.f  &sql(fetch DESCDHCDealerRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCDHCDealerRepeat)
	;通用字典类型值
	i (type="CODE")&&(tableName="CT_HRP_MAT.ComDictValue") d
	.s Rowid=0,count=0
	.&sql(declare CODEDictValueRepeat cursor for 
		select %ID from CT_HRP_MAT.ComDictValue
		where ComDI_ValCode=:tmpvalue and ComDI_ValType=:other)
	.&sql(open CODEDictValueRepeat)
	.f  &sql(fetch CODEDictValueRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close CODEDictValueRepeat)
	
	i (type="DESC")&&(tableName="CT_HRP_MAT.ComDictValue") d
	.s Rowid=0,count=0
	.&sql(declare DESCDDictValueRepeat cursor for 
		select %ID from CT_HRP_MAT.ComDictValue
		where ComDI_ValDesc=:tmpvalue and ComDI_ValType=:other)
	.&sql(open DESCDHCDealerRepeat)
	.f  &sql(fetch DESCDDictValueRepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	.&sql(close DESCDDictValueRepeat)
	
	
	q $g(RetRowID)
}

/// Descript:	根据代码 名称获取对应ID(注意自带院区字段的表)
/// Creator:	lihui
/// CreateDate:	202000416
/// Input: 	type(代码:CODE;名称:DESC),类型值,表名,医院ID	
/// return: 重复:id 不重复:空 报错:小于0
ClassMethod GetShowId(BDPHospAutFlag, TableType, tableName, HospId, Rowid)
{
	n (BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	s repeatFlag="Y"
	s flag="N",BDPMapId=""
	
	i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	.s flag = ..GetShowDataFlag(tableName,Rowid,HospId,"",repeatFlag) //医院级别授权
	q:flag="Y" Rowid
	
	i (BDPHospAutFlag'="Y") d
	.s BDPMapId=..GetBDPMapId(tableName,HospId,Rowid)
	q:BDPMapId'="" Rowid
	
	q ""
}

/// Descript:	根据代码 名称获取对应ID(注意自带院区字段的表)
/// Creator:	lihui
/// CreateDate:	202000416
/// Input: 	type(代码:CODE;名称:DESC),类型值,表名,医院ID	
/// return: 重复:id 不重复:空 报错:小于0
/// w ##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE","高值材料","INC_StkCat",2)
/// w ##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC","高值材料","INC_StkCat",2)
ClassMethod CodeDescGetId(type, value, tableName, HospId, other = "")
{
	n (type, value, tableName, HospId,other,%session)
	q:(type="")||(value="")||(tableName="")||(HospId="") ""
	
	s TableType=..GetTableType(tableName)  //表类型
	s RetRowID=""
	s tmpvalue=value
	s tmpStkType=$p(other,"^",1)
	s value=$$ALPHAUP^SSUTIL4(value)
	s repeatFlag="Y"
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //医院级别授权是否开启
	
	;库存分类
	i (type="CODE")&&(tableName="INC_StkCat") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^INC("SC",0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="INC_StkCat") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^INC("SC",0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;类组
	i (type="CODE")&&(tableName="DHC_StkCatGroup") d
	.s count=0,tmpid=""
	.&sql(declare codescg cursor for 
		select %ID  from DHC_StkCatGroup
		where SCG_Code=:tmpvalue and SCG_Type='M')
	.&sql(open codescg)
	.f  &sql(fetch codescg into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codescg)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_StkCatGroup") d
	.s count=0,tmpid=""
	.&sql(declare descscg cursor for 
		select %ID  from DHC_StkCatGroup
		where SCG_Desc=:tmpvalue and SCG_Type='M')
	.&sql(open descscg)
	.f  &sql(fetch descscg into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descscg)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;库存项
	i (type="CODE")&&(tableName="INC_Itm") d
	.s HospId=..GetDefHospId(tableName,HospId)
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^INCI(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	i (type="DESC")&&(tableName="INC_Itm") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^INCI(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	;医嘱项
	i (type="CODE")&&(tableName="ARC_ItmMast") d
	.s HospId=..GetDefHospId(tableName,HospId)
	.s Paref=0,count=0,tmpid=""
	.f  s Paref=$o(^ARCIM(0,"Code",value,Paref)) q:(+Paref=0)||(RetRowID'="")  d
	..s chl=$o(^ARCIM(0,"Code",value,Paref,""))
	..q:chl=""
	..s Rowid=Paref_"||"_chl
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="ARC_ItmMast") d
	.s HospId=..GetDefHospId(tableName,HospId)
	.s Paref=0,count=0,tmpid=""
	.f  s Paref=$o(^ARCIM(0,"Desc",value,Paref)) q:(+Paref=0)||(RetRowID'="")  d
	..s chl=$o(^ARCIM(0,"Desc",value,Paref,""))
	..q:chl=""
	..s Rowid=Paref_"||"_chl
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;收费项
	i (type="CODE")&&(tableName="DHC_TarItem") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTARI(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_TarItem") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCTARI(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;定价类型
	i (type="CODE")&&(tableName="DHC_MarkType") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCINMT(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d  
	..s Type=$p(^DHCINMT(Rowid),"^",5)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_MarkType") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCINMT(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCINMT(Rowid),"^",5)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;小数规则
	i (type="CODE")&&(tableName="DHC_StkDecimal") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCSD(0,"NAME",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d  
	..s Type=$p(^DHCSD(Rowid),"^",4)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;定价规则
	i (type="CODE")&&(tableName="DHC_MarkRule") d
	.s count=0,tmpid=""
	.&sql(declare codemarkrule cursor for 
		select %ID from DHC_MarkRule
		where MR_Code=:tmpvalue and MR_Type='M')
	.&sql(open codemarkrule)
	.f  &sql(fetch codemarkrule into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codemarkrule)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_MarkRule") d
	.s count=0,tmpid=""
	.&sql(declare descmarkrule cursor for 
		select %ID from DHC_MarkRule
		where MR_Desc=:tmpvalue and MR_Type='M')
	.&sql(open descmarkrule)
	.f  &sql(fetch descmarkrule into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descmarkrule)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;配送商
	i (type="CODE")&&(tableName="DHC_Carrier") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCCARR(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCCARR(Rowid),"^",3)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_Carrier") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCCARR(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCCARR(Rowid),"^",3)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;科室项目组
	i (type="CODE")&&(tableName="DHC_LocItemGrp") d
	.s count=0,tmpid=""
	.&sql(declare codelocitmgrp cursor for 
		select %ID from DHC_LocItemGrp
		where LIG_Code=:tmpvalue)
	.&sql(open codelocitmgrp)
	.f  &sql(fetch codelocitmgrp into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codelocitmgrp)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_LocItemGrp") d
	.s count=0,tmpid=""
	.&sql(declare desclocitmgrp cursor for 
		select %ID from DHC_LocItemGrp
		where LIG_Desc=:tmpvalue)
	.&sql(open desclocitmgrp)
	.f  &sql(fetch desclocitmgrp into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close desclocitmgrp)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;科室组
	i (type="CODE")&&(tableName="DHC_StkLocGroup") d
	.s count=0,tmpid=""
	.&sql(declare codestklocgrp cursor for 
		select %ID from DHC_StkLocGroup
		where SLG_Code=:tmpvalue and SLG_Type='M')
	.&sql(open codestklocgrp)
	.f  &sql(fetch codestklocgrp into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codestklocgrp)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_StkLocGroup") d
	.s count=0,tmpid=""
	.&sql(declare descstklocgrp cursor for 
		select %ID from DHC_StkLocGroup
		where SLG_Desc=:tmpvalue and SLG_Type='M')
	.&sql(open descstklocgrp)
	.f  &sql(fetch descstklocgrp into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descstklocgrp)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;招标轮次
	i (type="CODE")&&(tableName="DHC_PublicBiddingList") d
	.s count=0,tmpid=""
	.&sql(declare codepblst cursor for 
		select %ID from DHC_PublicBiddingList
		where DHCPBL_Code=:tmpvalue and DHCPBL_Type='M')
	.&sql(open codepblst)
	.f  &sql(fetch codepblst into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codepblst)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	.
	i (type="DESC")&&(tableName="DHC_PublicBiddingList") d
	.s count=0,tmpid=""
	.&sql(declare descpblst cursor for 
		select %ID from DHC_PublicBiddingList
		where DHCPBL_Desc=:tmpvalue and DHCPBL_Type='M')
	.&sql(open descpblst)
	.f  &sql(fetch descpblst into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descpblst)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;招标级别
	i (type="CODE")&&(tableName="DHC_ItmPBLevel") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCITMPBL(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_ItmPBLevel") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCITMPBL(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;支付方式
	i (type="CODE")&&(tableName="CT_PayMode") d
	.s count=0,tmpid=""
	.&sql(declare codepaymode cursor for 
		select %ID from CT_PayMode
		where CTPM_Code=:tmpvalue)
	.&sql(open codepaymode)
	.f  &sql(fetch codepaymode into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codepaymode)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="CT_PayMode") d
	.s count=0,tmpid=""
	.&sql(declare descpaymode cursor for 
		select %ID from CT_PayMode
		where CTPM_Desc=:tmpvalue)
	.&sql(open descpaymode)
	.f  &sql(fetch descpaymode into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descpaymode)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;收费类型
	i (type="CODE")&&(tableName="DHC_ItmChargeType") d
	.s count=0,tmpid=""
	.&sql(declare codeitmchargetype cursor for 
		select %ID from DHC_ItmChargeType
		where ICT_Code=:tmpvalue)
	.&sql(open codeitmchargetype)
	.f  &sql(fetch codeitmchargetype into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codeitmchargetype)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_ItmChargeType") d
	.s count=0,tmpid=""
	.&sql(declare descitmchargetype cursor for 
		select %ID from DHC_ItmChargeType
		where ICT_Desc=:tmpvalue)
	.&sql(open descitmchargetype)
	.f  &sql(fetch descitmchargetype into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descitmchargetype)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;账簿分类
	i (type="CODE")&&(tableName="DHCST_BookCat") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCSTBC(0,"CODE",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHCST_BookCat") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCSTBC(0,"DESC",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;资金来源
	i (type="CODE")&&(tableName="DHC_SourceOfFund") d
	.s count=0,tmpid=""
	.&sql(declare codesourceofund cursor for 
		select %ID from DHC_SourceOfFund
		where SOF_Code=:tmpvalue)
	.&sql(open codesourceofund)
	.f  &sql(fetch codesourceofund into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codesourceofund)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_SourceOfFund") d
	.s count=0,tmpid=""
	.&sql(declare descsourceofund cursor for 
		select %ID from DHC_SourceOfFund
		where SOF_Desc=:tmpvalue)
	.&sql(open descsourceofund)
	.f  &sql(fetch descsourceofund into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descsourceofund)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;不可用原因
	i (type="DESC")&&(tableName="DHC_ItmNotUseReason") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCNUR(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;质量层次
	i (type="CODE")&&(tableName="DHC_ItmQualityLevel") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCITMQL(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_ItmQualityLevel") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCITMQL(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;灭菌分类(Y)
	i (type="DESC")&&(tableName="INC_SterileCategory") d
	.s count=0,tmpid=""
	.&sql(declare descsterilecate cursor for 
		select %ID from INC_SterileCategory
		where SCAT_Desc=:tmpvalue)
	.&sql(open descsterilecate)
	.f  &sql(fetch descsterilecate into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descsterilecate)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;调整原因(Y)
	i (type="CODE")&&(tableName="INC_ReasonForAdjustment") d
	.s count=0,tmpid=""
	.&sql(declare codereasonadj cursor for 
		select %ID from INC_ReasonForAdjustment
		where ADJ_Code=:tmpvalue and ADJ_StkType='M')
	.&sql(open codereasonadj)
	.f  &sql(fetch codereasonadj into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codereasonadj)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="INC_ReasonForAdjustment") d
	.s count=0,tmpid=""
	.&sql(declare descreasonadj cursor for 
		select %ID from INC_ReasonForAdjustment
		where ADJ_Desc=:tmpvalue and ADJ_StkType='M')
	.&sql(open descreasonadj)
	.f  &sql(fetch descreasonadj into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descreasonadj)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;调价原因(Y)
	i (type="CODE")&&(tableName="DHC_ReasonForAdjustPrice") d
	.s count=0,tmpid=""
	.&sql(declare codereasonadjrp cursor for 
		select %ID from DHC_ReasonForAdjustPrice
		where REA_Code=:tmpvalue and REA_StkType='M')
	.&sql(open codereasonadjrp)
	.f  &sql(fetch codereasonadjrp into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codereasonadjrp)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_ReasonForAdjustPrice") d
	.s count=0,tmpid=""
	.&sql(declare descreasonadjrp cursor for 
	      select %ID from DHC_ReasonForAdjustPrice
		where REA_Desc=:tmpvalue and REA_StkType='M')
	.&sql(open descreasonadjrp)
	.f  &sql(fetch descreasonadjrp into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descreasonadjrp)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;报损原因(Y)
	i (type="CODE")&&(tableName="DHC_IncReasonForStockScrap") d
	.s count=0,tmpid=""
	.&sql(declare codereasonscrap cursor for 
		select %ID from DHC_IncReasonForStockScrap
		where REASON_ScrapCode=:tmpvalue and REASON_ScrapType='M')
	.&sql(open codereasonscrap)
	.f  &sql(fetch codereasonscrap into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codereasonscrap)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_IncReasonForStockScrap") d
	.s count=0,tmpid=""
	.&sql(declare descreasonscrap cursor for 
		select %ID from DHC_IncReasonForStockScrap
		where REASON_ScrapDesc=:tmpvalue and REASON_ScrapType='M')
	.&sql(open descreasonscrap)
	.f  &sql(fetch descreasonscrap into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descreasonscrap)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;退货原因(Y)
	i (type="CODE")&&(tableName="INC_ReasonForReturn") d
	.s count=0,tmpid=""
	.&sql(declare codereasonreturn cursor for 
	      select %ID from INC_ReasonForReturn
		where RET_Code=:tmpvalue and RET_StkType='M')
	.&sql(open codereasonreturn)
	.f  &sql(fetch codereasonreturn into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codereasonreturn)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="INC_ReasonForReturn") d
	.s count=0,tmpid=""
	.&sql(declare descreasonreturn cursor for 
	      select %ID from INC_ReasonForReturn
		where RET_Desc=:tmpvalue and RET_StkType='M')
	.&sql(open descreasonreturn)
	.f  &sql(fetch descreasonreturn into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descreasonreturn)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;订单取消原因(Y)
	i (type="CODE")&&(tableName="INC_POCanc_FullFillReason") d
	.s count=0,tmpid=""
	.&sql(declare codereasonfullfill cursor for 
	      select %ID from INC_POCanc_FullFillReason
		where CFR_Code=:tmpvalue and CFR_StkType='M')
	.&sql(open codereasonfullfill)
	.f  &sql(fetch codereasonfullfill into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codereasonfullfill)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="INC_POCanc_FullFillReason") d
	.s count=0,tmpid=""
	.&sql(declare descreasonfullfill cursor for 
	      select %ID from INC_POCanc_FullFillReason
		where CFR_Desc=:tmpvalue and CFR_StkType='M')
	.&sql(open descreasonfullfill)
	.f  &sql(fetch descreasonfullfill into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descreasonfullfill)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;请求单拒绝原因(Y)
	i (type="CODE")&&(tableName="DHC_ReasonForRefuseRequest") d
	.s count=0,tmpid=""
	.&sql(declare codereasonrefreq cursor for 
	      select %ID from DHC_ReasonForRefuseRequest
		where RF_Code=:tmpvalue and RF_StkType='M')
	.&sql(open codereasonrefreq)
	.f  &sql(fetch codereasonrefreq into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codereasonrefreq)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_ReasonForRefuseRequest") d
	.s count=0,tmpid=""
	.&sql(declare descreasonrefreq cursor for 
	      select %ID from DHC_ReasonForRefuseRequest
		where RF_Desc=:tmpvalue and RF_StkType='M')
	.&sql(open descreasonrefreq)
	.f  &sql(fetch descreasonrefreq into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descreasonrefreq)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;出入库类型（web.DHCSTMHUI.PCHCOLLSM未改）
	i (type="CODE")&&(tableName="DHC_OperateType") d
	.s count=0,tmpid=""
	.&sql(declare codeopetype cursor for 
	      select %ID from DHC_OperateType
		where IPT_Code=:tmpvalue and IPT_Type=:tmpStkType)
	.&sql(open codeopetype)
	.f  &sql(fetch codeopetype into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codeopetype)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_OperateType") d
	.s count=0,tmpid=""
	.&sql(declare descopetype cursor for 
	      select %ID from DHC_OperateType
		where IPT_Desc=:tmpvalue and IPT_Type=:tmpStkType)
	.&sql(open descopetype)
	.f  &sql(fetch descopetype into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descopetype)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;高值标志关联医嘱收费(Y)
	i (type="CODE")&&(tableName="DHC_HvMapArc") d
	.s count=0,tmpid=""
	.&sql(declare codehvmaparc cursor for 
	      select %ID from DHC_HvMapArc
		where HMA_HvFlag=:tmpvalue)
	.&sql(open codehvmaparc)
	.f  &sql(fetch codehvmaparc into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1
	..s tmpid=Rowid
	..s flag="N"
	..i BDPHospAutFlag="Y" d
	...s flag = ..GetShowDataFlag(tableName,Rowid,HospId,"",repeatFlag) //医院级别授权
	..i flag="Y" s RetRowID=Rowid
	..q:RetRowID'=""
	..i (BDPHospAutFlag'="Y") d
	...&sql(SELECT ID INTO:bdpid FROM BDP_MappingHosp WHERE BDPMPH_TableName=:tableName AND BDPMPH_Hospital=:HospId AND BDPMPH_DataReference=:Rowid)
	...i 'SQLCODE s RetRowID=Rowid
	.
	.&sql(close codehvmaparc)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;供应商分类(Y)
	i (type="CODE")&&(tableName="APC_VendCat") d
	.s count=0,tmpid=""
	.&sql(declare codevencat cursor for 
	      select %ID from APC_VendCat 
		where APCVC_Code=:tmpvalue and APCVC_StkType='M')
	.&sql(open codevencat)
	.f  &sql(fetch codevencat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codevencat)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="APC_VendCat") d
	.s count=0,tmpid=""
	.&sql(declare descvencat cursor for 
	      select %ID from APC_VendCat 
		where APCVC_Desc=:tmpvalue and APCVC_StkType='M')
	.&sql(open descvencat)
	.f  &sql(fetch descvencat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descvencat)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;供应商（web.DHCSTMHUI.APCVenNew,导入相关未改）
	i (type="CODE")&&(tableName="APC_Vendor") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^APC("APCVM",0,"APCVM_Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s STV=$o(^DHCSTV(0,Rowid,0))
	..s StkType=$p(^APC("APCVM",Rowid),"^",9)
	..q:tmpStkType'=StkType
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="APC_Vendor") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^APC("APCVM",0,"APCVM_Name",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s STV=$o(^DHCSTV(0,Rowid,0))
	..s StkType=$p(^APC("APCVM",Rowid),"^",9)
	..q:tmpStkType'=StkType
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="BARCODE")&&(tableName="APC_Vendor") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^APC("APCVM",Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s STV=$o(^DHCSTV(0,Rowid,0))
	..s StkType=$p(^APC("APCVM",Rowid),"^",9)
	..q:tmpStkType'=StkType
	..s STVBarCode=$p(^DHCSTV(STV),"^",42)
	..q:STVBarCode'=value
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;生产厂家（web.DHCSTMHUI.ItmManfNew,导入相关未改）
	i (type="CODE")&&(tableName="PH_Manufacturer") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^PHMNF(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s dhcmanfid=$o(^DHCMANF(0,"MANF",Rowid,""))
	..s StkType=$p(^DHCMANF(dhcmanfid),"^",7)
	..q:tmpStkType'=StkType
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="PH_Manufacturer") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^PHMNF(0,"Name",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s dhcmanfid=$o(^DHCMANF(0,"MANF",Rowid,""))
	..s StkType=$p(^DHCMANF(dhcmanfid),"^",7)
	..q:tmpStkType'=StkType
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;产地(Y)
	i (type="CODE")&&(tableName="DHC_STOrigin") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCSTORI(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCSTORI(Rowid),"^",3)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_STOrigin") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCSTORI(0,"Name",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s Type=$p(^DHCSTORI(Rowid),"^",3)
	..q:Type'="M"
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;科室(web.DHCSTMHUI.SRVCOMMON未改)
	i (type="CODE")&&(tableName="CT_Loc") d
	.s Rowid=0
	.f  s Rowid=$o(^CTLOC(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s lochospid=..sssHospId(Rowid)
	..i (lochospid'="")&&(HospId=lochospid) d
	...s RetRowID=Rowid
	
	i (type="DESC")&&(tableName="CT_Loc") d
	.s Rowid=0
	.f  s Rowid=$o(^CTLOC(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s lochospid=..sssHospId(Rowid)
	..i (lochospid'="")&&(HospId=lochospid) d
	...s RetRowID=Rowid
	
	;采购审核级别
	i (type="CODE")&&(tableName="DHC_PlanStatus") d
	.s count=0,tmpid=""
	.&sql(declare codeplanstatus cursor for 
	      select %ID from DHC_PlanStatus
		where DHCPS_Code=:tmpvalue and DHCPS_StkType='M')
	.&sql(open codeplanstatus)
	.f  &sql(fetch codeplanstatus into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close codeplanstatus)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_PlanStatus") d
	.s count=0,tmpid=""
	.&sql(declare descplanstatus cursor for 
	      select %ID from DHC_PlanStatus
		where DHCPS_Desc=:tmpvalue and DHCPS_StkType='M')
	.&sql(open descplanstatus)
	.f  &sql(fetch descplanstatus into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.&sql(close descplanstatus)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;官方分类
	i (type="CODE")&&(tableName="DHC_MatCatOfficial") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCMCO(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_MatCatOfficial") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCMCO(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;临床分类
	i (type="CODE")&&(tableName="DHC_MatCatClinical") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCMCC(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_MatCatClinical") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCMCC(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	;特殊分类
	i (type="CODE")&&(tableName="DHC_MatCatSpecial") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCMCS(0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="DHC_MatCatSpecial") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^DHCMCS(0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	q $g(RetRowID)
}

/// Descript:	保存医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Table: BDP_MappingHosp
/// Input: 	表名,rowid,医院ID	
/// return: 成功:ID^添加成功；失败:-1^添加失败; 已经存在：1
/// w ##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHCST_BookCat",1,2)
ClassMethod SaveHOSP(BDPMPHTableName, BDPMPHDataReference, BDPMPHHospital) As %String
{
	n (BDPMPHTableName, BDPMPHDataReference, BDPMPHHospital,%session)
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //医院级别授权是否开启
	q:BDPHospAutFlag'="Y" 0
	
	s TableType=..GetTableType(BDPMPHTableName)
	q:TableType="G" 0
	
	i '$d(^||TMPDHCSTM("SaveHOSP",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||SaveHOSP"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("SaveHOSP",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("SaveHOSP",$j),"^",1)
	q:Flag'="Y" 0
	s ret=0
	s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital)
	i +ReturnStr'>0 s ret=-1
	q ret
}

/// Descript:	删除医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 		
/// return: 成功:1；失败:-1^关联医院表数据删除失败
/// w ##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_CertType")
ClassMethod DeleteHospitals(BDPMPHTableName, BDPMPHDataReference = "", hospid = "") As %String
{
	n (BDPMPHTableName, BDPMPHDataReference,hospid,%session)
	
	s TableType=..GetTableType(BDPMPHTableName)
	q:TableType="G" 1
	
	i '$d(^||TMPDHCSTM("DeleteHospitals",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||DeleteHospitals"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("DeleteHospitals",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("DeleteHospitals",$j),"^",1)
	q:Flag'="Y" 1
	
	s ReturnStr=0
	i hospid'="" d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital(BDPMPHTableName,BDPMPHDataReference,hospid)
	e  i (BDPMPHDataReference'="") d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(BDPMPHTableName,BDPMPHDataReference)
	e  d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals(BDPMPHTableName)
	i ReturnStr=1 s ReturnStr=0
	q ReturnStr
}

/// Descript:	当前登录人是否有权限查看(基础平台配置,是否公有,是否授权院区)
/// Creator:	lihui
/// CreateDate:	20200327
/// talbe : DHC_ItmAddHosp，BDP_MappingHosp,ARC_ItemHosp(针对存储在这三张表的数据判断)
/// Input: 	表名,rowid,医院ID,是否忽略医院授权管理启用与否	(Y:忽略,N|"":不忽略),是否判断基础信息重名 (Y:是；否则：否)
/// return: Y:有权限；N:无权限
/// w ##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_Itm",4856,9)
ClassMethod GetShowDataFlag(tableName, dataid, HospId, Flag = "", repeatFlag = "", ShowAllFlag = "") As %String
{
	n (%session,tableName, dataid, HospId, Flag, repeatFlag, ShowAllFlag)
	q:(ShowAllFlag="Y")||(HospId="") "Y"	//取所有医院范围 //院区为空默认取全部
	q:(tableName="")||(dataid="") "N"
	
	i '$d(^||TMPDHCSTM("GetShowDataFlag",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetHospShowDataFlag"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s IsObject=$s($IsObject(CompiledObj):"Y",1:"N")
	.s BDPHospAutFlag="N"
	.i IsObject="Y" d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPDHCSTM("GetShowDataFlag",$j)=BDPHospAutFlag_"^"_IsObject
	e  d
	.s BDPConfigInfo=^||TMPDHCSTM("GetShowDataFlag",$j)
	.s BDPHospAutFlag=$p(BDPConfigInfo,"^",1)
	.s IsObject=$p(BDPConfigInfo,"^",2)
	q:((Flag'="Y")&&(BDPHospAutFlag'="Y")) "Y"
	q:IsObject="N" "Y"
	s retValue=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tableName,dataid,HospId)
	
	q retValue
}

/// Descript:	获取表的类型（公有G ，私有S，管控C，绝对私有A）
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.DHCSTMHUI.MatForBDPData).GetTableType("DHCST_BookCat")
ClassMethod GetTableType(BDPMPHTableName) As %String
{
	n (BDPMPHTableName,%session)
	
	i '$d(^||TMPDHCSTM("GetTableType",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDataType"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("GetTableType",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("GetTableType",$j),"^",1)
	q:Flag'="Y" "G"
	
	s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(BDPMPHTableName)	 //获取数据共有私有类型
	
	q DataTypeFlag
}

/// Descript:	获取院区Id(多院区)
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	多院区下拉框Id，登录院区Id，院区下拉框为空时是否赋值登录医院id	
/// return: 表类型
/// w ##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId("","","","")
ClassMethod GetBDPHospId(BDPHospId, gHospId, SetDefFlag = "Y", TableName = "") As %String
{
	n (BDPHospId,gHospId,SetDefFlag,TableName,%session)
	s HospId=""
	
	s:HospId="" HospId=BDPHospId	//取医院下拉框取值
	q:(HospId="")&&(SetDefFlag="N") ""	//不取默认值
	
	s:HospId="" HospId=gHospId
	s:(HospId="")&&($g(%session)) HospId=$g(%session.Data("LOGON.HOSPID"))
	
	i (HospId'="")&&(TableName'="") d	//依据表名和当前医院获取对应展示医院的ID
	.s HospId=..GetDefHospId(TableName,HospId)
	
	q HospId
}

/// Descript:	根据表名、业务数据中的医院、日期取要取哪个医院的配置，返回医院id
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.DHCSTMHUI.MatForBDPData).GetTableType("DHCST_BookCat")
ClassMethod GetDefHospId(TableName, HospId) As %String
{
	n (TableName,HospId,%session)
	
	i '$d(^||TMPDHCSTM("GetDefHospId",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDefHospIdByTableName"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("GetDefHospId",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("GetDefHospId",$j),"^",1)
	q:Flag'="Y" HospId
	
	s Date=$zd(+$h,3)
	s HospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HospId,Date)
	
	q HospId
}

/// Descript:	根据表名、日期取要取哪个医院的配置，返回医院id
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("DHC_CertType")
ClassMethod GetDefHospStr(TableName) As %String
{
	n (TableName,%session)
	s HospStr=""
	
	s BDPHospAutFlag=..GetHospAutFlag() //是否开启医院授权
	q:BDPHospAutFlag'="Y" HospStr
	
	s TableType=..GetTableType(TableName)
	q:TableType="G" HospStr
	
	i '$d(^||TMPDHCSTM("GetDefHospId",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDefHospIdByTableName"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPDHCSTM("GetDefHospId",$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("GetDefHospId",$j),"^",1)
	q:Flag'="Y" HospStr
	
	s HospId=0
	f  s HospId=$o(^CT("HOSP",HospId)) q:+HospId=0  d
	.s tmpHospId=..GetDefHospId(TableName,HospId)
	.i HospStr="" d
	..s HospStr=tmpHospId
	.e  d
	..q:(HospStr[tmpHospId)
	..s HospStr=HospStr_"^"_tmpHospId
	
	q HospStr
}

}
