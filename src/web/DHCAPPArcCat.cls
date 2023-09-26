Import SQLUSER

Class web.DHCAPPArcCat Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 查询检查表
/// Table：        DHC_AppArcCat 
/// Others：       w ##class(web.DHCAPPArcCat).QueryArcCat("10","1","")
ClassMethod QueryArcCat(rows As %String, page As %String, params As %String, HospID As %String = "") As %String
{
	n (rows,page,params,HospID)

	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s code=$p(params,"^",1)    //在串params中取值
	s desc=$p(params,"^",2)
	s h=0,count=0
	s acrowid=""
	f  s acrowid=$o(^DHCAPARCCA(acrowid)) q:acrowid=""  d  //查询表DHC_AppArcCat
	.q:acrowid=0
	.s catcode=$p(^DHCAPARCCA(acrowid),"^",1)
	.s catdesc=$p(^DHCAPARCCA(acrowid),"^",2)
	.s HospDr=+$p(^DHCAPARCCA(acrowid),"^",4)
	.q:((HospID'="")&&(HospDr'=HospID))
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)
	.q:(code'="")&(catcode'[code)
	.q:(desc'="")&(catdesc'[desc)
	.s h=h+1
	.s tempstr=acrowid_"^"_catcode_"^"_catdesc_"^"_HospDesc_"^"_HospDr
	.s ^TMP("DHCST","web.DHCAPPArcCat","QueryArcCat",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="acrowid^catcode^catdesc^hospdesc^hospdr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArcCat","QueryArcCat",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPArcCat","QueryArcCat",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 保存检查分类表
/// Table：        DHC_AppArcCat 
ClassMethod SaveArcCat(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.s Err=..CheckRepeat(tmpstr)   /// 重复性判断 bianshuai 2017-01-03
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdArcCat(tmpstr)
	.e  d
	..s Err=..AddArcCat(tmpstr)
	q Err
}

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 增加检查分类表
/// Table：        DHC_AppArcCat 
/// Others：       w ##class(web.DHCAPPArcCat).AddArcCat("^005^ds^CT")
ClassMethod AddArcCat(params As %String) As %String
{
	n (params)
	s catcode=$p(params,"^",2)     /// 分类代码
	s catdesc=$p(params,"^",3)	   /// 分类描述
	s hospDr=$p(params,"^",4)	   /// 医院ID
	&sql(insert into DHC_AppArcCat (AC_CatCode,AC_CatDesc,AC_Hosp_Dr) values (:catcode,:catdesc,:hospDr))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 更新检查分类表
/// Table：        DHC_AppPosition 
/// Others：       w ##class(web.DHCAPPArcCat).UpdArcCat("1^001^ds^普通床位")
ClassMethod UpdArcCat(params As %String) As %String
{
	n (params)
	s acrowid=$p(params,"^",1)		/// 分类ID
	s catcode=$p(params,"^",2)		/// 分类代码
	s catdesc=$p(params,"^",3)		/// 分类描述
	s hospDr=$p(params,"^",4)		/// 医院ID
	&sql(update DHC_AppArcCat set AC_CatCode=:catcode,AC_CatDesc=:catdesc ,AC_Hosp_Dr=:hospDr where AC_RowID=:acrowid )
	q SQLCODE
}

/// Creator:   bianshuai
/// CreatDate: 2017-01-03
/// Descript:  检查代码、描述是否重复
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s ICode=$p(ItmTempStr,"^",2)   	///代码
	s IDesc=$p(ItmTempStr,"^",3)   	///描述
	s hospDr=$p(ItmTempStr,"^",4)		///医院ID
	/// 新记录    ///sufan  2017-03-21 新增医院的信息，增加不同的医院在保存时的判断
	if ID=""  d
	.i $d(^DHCAPARCCA(0,"Code",$$ALPHAUP^SSUTIL4(ICode))) d
	..s CatID=""
	..f  s CatID=$o(^DHCAPARCCA(0,"Code",$$ALPHAUP^SSUTIL4(ICode),CatID)) q:(CatID="")||(ret'=0)  d
	...s HospID=$p(^DHCAPARCCA(CatID),"^",4)
	...q:HospID'=hospDr
	...s ret=-1
	.i $d(^DHCAPARCCA(0,"Desc",$$ALPHAUP^SSUTIL4(IDesc)))  d
	..s CatID=""
	..f  s CatID=$o(^DHCAPARCCA(0,"Desc",$$ALPHAUP^SSUTIL4(IDesc),CatID))  q:(CatID="")||(ret'=0)  d
	...s HospID=$p(^DHCAPARCCA(CatID),"^",4)
	...q:HospID'=hospDr
	...s ret=-2
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPARCCA(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPARCCA(ID)),"^",2)    //描述
	.i (Code'=ICode)&($d(^DHCAPARCCA(0,"Code",$$ALPHAUP^SSUTIL4(ICode))))  d
	..s CatID=""
	..f  s CatID=$o(^DHCAPARCCA(0,"Code",$$ALPHAUP^SSUTIL4(ICode),CatID)) q:(CatID="")||(ret'=0)  d
	...s HospID=$p(^DHCAPARCCA(CatID),"^",4)
	...q:HospID'=hospDr
	...s ret=-3
	.i (Desc'=IDesc)&($d(^DHCAPARCCA(0,"Desc",$$ALPHAUP^SSUTIL4(IDesc))))  d
	..s CatID=""
	..f  s CatID=$o(^DHCAPARCCA(0,"Desc",$$ALPHAUP^SSUTIL4(IDesc),CatID)) q:(CatID="")||(ret'=0)  d
	...s HospID=$p(^DHCAPARCCA(CatID),"^",4)
	...q:HospID'=hospDr
	...s ret=-4
	q ret
}

/// Creator：      宋春莉
/// CreatDate：    2020-07-23
/// Descript：	   判断检查分类是否关联医嘱项
/// Input:    	   分类ID
/// Return：	   0 不存在  1存在
/// Others:	  	   w ##class(web.DHCAPPArcCat).isRelateItem()
ClassMethod isRelateItem(ItmId)
{
	n (ItmId)
	s ret=0
	s ChildSub=$o(^DHCAPARCCA(ItmId,"ArcItm","")) //$o(^DHCAPREP(id,"I",""))
	s:ChildSub'="" ret="-6"
	q ret
}

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 删除检查分类表
/// Table：        DHC_AppPosition 
/// thers：       w ##class(web.DHCAPPArcCat).DelArcCat("")
ClassMethod DelArcCat(params As %String) As %String
{
	n (params)
	s ret=0
	//s catcode=$p(^DHCAPARCCA(params),"^",1)
	//k ^DHCAPARCCA(0,"IndexCatCode",catcode,params)
	s ret=..isRelateCat(params)    		///  调用函数，判断分类是否关联医嘱子类
	q:ret'=0 ret
	s ret=..isUseInReport(params)		///  调用函数，判断分类是否开医嘱
	q:ret'=0 ret
	s ret=..isRelateItem(params)    		///  调用函数，判断分类是否关联医嘱子类
	q:ret'=0 ret
	q:$d(^DHCAPARCCA(params,"A")) -1	/// 
	q:$d(^DHCAPCATO(params,"O")) -2		/// 已经维护其他项目
	q:$d(^DHCAPPPRT(0,"Arc",params)) -4 /// 已维护打印模板
	&sql(delete from DHC_AppArcCat where AC_RowID=:params)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-02-27
/// Descript：	   通过医嘱子类获取医嘱项ID
/// Input:    	   分类ID
/// Return：	   医嘱项ID
/// Others:	  	   w ##class(web.DHCAPPArcCat).isUseInReport()
ClassMethod isUseInReport(id)
{
	n (id)
	s ret=0
	s CHildSub=""
	f  s CHildSub=$o(^DHCAPARCCA(id,"I",CHildSub)) q:(CHildSub="")||(ret'=0)  d
	.s CatDr=$p(^DHCAPARCCA(id,"I",CHildSub),"^",1)
	.s arcSub="",arcVersion=""
	.f  s arcSub=$o(^ARCIM(0,"ARCIC_DR",CatDr,arcSub)) q:(arcSub="")||(ret'=0)  d
	..f  s arcVersion=$o(^ARCIM(0,"ARCIC_DR",CatDr,arcSub,arcVersion))  q:(arcVersion="")||(ret'=0)  d
	...s arcItmID=arcSub_"||"_arcVersion
	...s ret=..InRepArc(arcItmID)
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-02-27
/// Descript：	   判断该分类是否已使用
/// Input:    	   分类ID
/// Return：	   医嘱项ID
/// Others:	  	   w ##class(web.DHCAPPArcCat).InRepArc("10378||1")
ClassMethod InRepArc(arcItmID)
{
	n (arcItmID)
	s ret=0
	q:arcItmID="" ret
	s RepArcID="",CHildSub=""
	f  s RepArcID=$o(^DHCAPREP(RepArcID)) q:(RepArcID="")||(ret'=0)  d
	.f  s CHildSub=$o(^DHCAPREP(RepArcID,"AR",CHildSub)) q:(CHildSub="")||(ret'=0)  d
	..s arcItmDr=$p(^DHCAPREP(RepArcID,"AR",CHildSub),"^",1)
	..q:arcItmDr'=arcItmID
	..s ret=-3
	q ret
}

/// Descript : 判断分类是否关联医嘱子类
/// Input    : 分类ID
/// Return   : 0:不存在 ，其他:存在
/// Others   : w ##class(web.DHCAPPArcCat).isRelateCat()
ClassMethod isRelateCat(CatRowId As %String) As %String
{
	n (CatRowId)
	s ret=0
	s ChildSub=$o(^DHCAPARCCA(CatRowId,"I",""))
	s:ChildSub'="" ret="-5"
	q ret
}

/// Creator：      sufan
/// CreatDate：    2016-4-14
/// Description:： 查询医嘱子类描述
/// Table：        DHC_AppPosition 
/// Others：       w ##class(web.DHCAPPArcCat).SelItemCat()
ClassMethod SelItemCat() As %String
{
	s count=0
	w "["
	s arcicrowid=""
	f  s arcicrowid=$o(^ARC("IC",arcicrowid)) q:arcicrowid=""  d
	.q:arcicrowid=0
	.s arcicdesc=$p(^ARC("IC",arcicrowid),"^",2)
	.s arcicordertype=$p(^ARC("IC",arcicrowid),"^",7)
	.//q:arcicordertype'="X" 
	.s tmp=arcicrowid_"^"_arcicdesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCAPPArcCat","QueryArcCat",pid)
	k ^TMP("DHCST","web.DHCAPPArcCat","QueryCatLink",pid)
	k ^TMP("DHCST","web.DHCAPPOtherOpt","QueryPrintTemp",pid)
	k ^TMP("DHCST","web.DHCAPPArcCat","QueryCatLinkArcItm",pid)
}

/// Creator    ：sufan
/// CreatDate  ：2016-02-22
/// Descript   : 保存分类子表
/// Table      ：DHC_AppArcCat,DHC_AppCatLinkOrd
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(web.DHCAPPArcCat).Save("^17^检查CT^18^2")
ClassMethod Save(params As %String) As %String
{
	n (params)
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s tmpstr=$p(params,"&&",i)
	.s ret=..isExistSamearcCat(tmpstr)    /// 判断相同的分类，是否关联相同的医嘱子类
	.q:ret'=0
	.i $p(tmpstr,"^",1)'="" q:ret'=0  d
	..s ret=..UpdCatLink(tmpstr)
	.e  d
	..s ret=..SaveCatLink(tmpstr)
	q ret
}

/// Descript   : 判断相同的分类，是否关联相同的医嘱子类
/// Table      ：DHC_AppArcCat,DHC_AppCatLinkOrd
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:不存在 ，其他：存在
/// Others     ：w ##class(web.DHCAPPArcCat).isExistSamearcCat("^1^胆道镜^116")
ClassMethod isExistSamearcCat(tmpstr As %String) As %String
{
	n (tmpstr)
	s ret=0
	s arcId=$p(tmpstr,"^",4)	 /// 医嘱子类ID
	s Hospdr=$p(tmpstr,"^",5)	 /// 医院ID
	s ExaCatID=0,ChildSub=""
	f  s ExaCatID=$o(^DHCAPARCCA(ExaCatID))	 q:(ExaCatID="")||(ret'=0)  d
	.s HospID=$p(^DHCAPARCCA(ExaCatID),"^",4)	
	.q:HospID'=Hospdr
	.f  s ChildSub=$o(^DHCAPARCCA(ExaCatID,"I",ChildSub)) q:(ChildSub="")||(ret'=0)  d
	..s OrdCatDr=$p(^DHCAPARCCA(ExaCatID,"I",ChildSub),"^",1)  /// 医嘱子类ID
	..q:arcId'=OrdCatDr
	..s ret="-11"
	q ret
}

/// Descript   : 保存分类子表
/// Table      ：DHC_AppCatLinkOrd
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(web.DHCAPPArcCat).SaveCatLink(1,115)
ClassMethod SaveCatLink(params As %String) As %String
{
	n (params)
	s ItmID=$p(params,"^",2)		/// 分类ID
	s CatLinkDr=$p(params,"^",4)	/// 医嘱子类ID
	s ChildSub=$o(^DHCAPARCCA(ItmID,"I",""),-1)+1
	&sql(insert into DHC_AppCatLinkOrd(AC_Cat_ParRef,AC_ChildSub,AC_OrdCat_Dr) values(:ItmID,:ChildSub,:CatLinkDr))
	q SQLCODE
}

/// Descript   : 更新分类子表
/// Table      ：DHC_AppCatLinkOrd
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(web.DHCAPPArcCat).UpdCatLink()
ClassMethod UpdCatLink(params As %String) As %String
{
	n (params)
	s CatLinkID=$p(params,"^",1)	/// 子表ID
	s ItmID=$p(params,"^",2)		/// 分类ID
	s CatDr=$p(params,"^",4)		/// 医嘱子类ID
	&sql(update DHC_AppCatLinkOrd set AC_Cat_ParRef=:ItmID,AC_OrdCat_Dr=:CatDr where AC_RowID=:CatLinkID )
	q SQLCODE
}

/// Descript   : 删除分类子表
/// Table      ：DHC_AppCatLinkOrd
/// Input      : 子表ID
/// Others     ：w ##class(web.DHCAPPArcCat).DelCatLink()
ClassMethod DelCatLink(CatLinkId As %String) As %String
{
	n (CatLinkId)
	&sql(delete from DHC_AppCatLinkOrd where AC_RowID=:CatLinkId)
	q SQLCODE
}

/// Descript   : 查询分类子表
/// Table      ：DHC_AppCatLinkOrd
/// Input      : 分类ID
/// Others     ：w ##class(web.DHCAPPArcCat).QueryCatLink(10,1,17) 
ClassMethod QueryCatLink(rows, page, ItmId) As %String
{
	n (rows,page,ItmId)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()		
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s ChildSub=""
	f  s ChildSub=$o(^DHCAPARCCA(ItmId,"I",ChildSub)) q:ChildSub=""  d
	.s CatDr=+$p(^DHCAPARCCA(ItmId,"I",ChildSub),"^",1)   /// 医嘱子类ID
	.s CatDesc=""
	.q:'$d(^ARC("IC",CatDr))
	.s:CatDr'=0 CatDesc=$p(^ARC("IC",CatDr),"^",2)        /// 医嘱子类描述
	.s CatLinkID=ItmId_"||"_ChildSub					  /// 分类子表ID
	.s h=h+1
	.s tempstr=CatLinkID_"^"_CatDesc_"^"_CatDr
	.s ^TMP("DHCST","web.DHCAPPArcCat","QueryCatLink",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="CatLinkID^CatDesc^CatDr"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArcCat","QueryCatLink",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPArcCat","QueryCatLink",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator    ：Qunianpeng
/// CreatDate  ：2018-03-19
/// Descript   : 保存医嘱项子表
/// Table      ：DHC_AppArcCat,DHC_AppCatLinkARCItm
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(web.DHCAPPArcCat).SaveLinkArc("^404||1^1^Y")
ClassMethod SaveLinkArc(params As %String) As %String
{
	n (params)
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s tmpstr=$p(params,"&&",i)
	.s ret=..isExistSameCatArcItm(tmpstr)    /// 判断相同的分类，是否关联相同的医嘱项
	.q:ret'=0
	.i $p(tmpstr,"^",1)'="" q:ret'=0  d
	..s ret=..UpdLinkArcItm(tmpstr)
	.e  d
	..s ret=..SaveLinkArcItm(tmpstr)
	q ret
}

/// Creator    ：Qunianpeng
/// CreatDate  ：2018-03-19
/// Descript   : 保存关联医嘱项子表
/// Table      ：DHC_AppCatLinkArcItm
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(web.DHCAPPArcCat)。SaveLinkArcItm("^404||1^1^Y")
ClassMethod SaveLinkArcItm(params As %String) As %String
{
	n (params)
	s arcItm=$p(params,"^",2)		/// 医嘱项id
	s catID=$p(params,"^",3)		/// 分类ID
	s frostFlag=$p(params,"^",4)	/// 冰冻标志
	s ACSingleFlag=$p(params,"^",5)
	i ACSingleFlag="否" s ACSingleFlag="N"
	i ACSingleFlag="是" s ACSingleFlag="Y"
	s ChildSub=$o(^DHCAPARCCA(catID,"ArcItm",""),-1)+1   
	&sql(insert into DHC_AppCatLinkARCItm(AC_CatArcItm_ParRef,AC_ChildSub,AC_ArcItm_Dr,AC_FrostFlag,AC_SingleFlag) values(:catID,:ChildSub,:arcItm,:frostFlag,:ACSingleFlag))
	q SQLCODE
}

/// Creator    ：Qunianpeng
/// CreatDate  ：2018-03-19
/// Descript   : 更新关联医嘱项子表
/// Table      ：DHC_AppCatLinkArcItm
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(web.DHCAPPArcCat).UpdLinkArcItm("1||1^404||1^1^Y")
ClassMethod UpdLinkArcItm(params As %String) As %String
{
	n (params)
	s acRowID=$p(params,"^",1)
	s arcItm=$p(params,"^",2)		/// 医嘱项id
	s catID=$p(params,"^",3)		/// 分类ID
	s frostFlag=$p(params,"^",4)	/// 冰冻标志
	i frostFlag="否" s frostFlag="N"
	i frostFlag="是" s frostFlag="Y"
	s ACSingleFlag=$p(params,"^",5)
	i ACSingleFlag="否" s ACSingleFlag="N"
	i ACSingleFlag="是" s ACSingleFlag="Y"
	&sql(update DHC_AppCatLinkARCItm set AC_CatArcItm_ParRef=:catID,AC_ArcItm_Dr=:arcItm,AC_FrostFlag=:frostFlag,AC_SingleFlag=:ACSingleFlag where AC_RowID=:acRowID )
	q SQLCODE
}

/// Creator    ：Qunianpeng
/// CreatDate  ：2018-03-19
/// Descript   : 删除分类子表
/// Table      ：DHC_AppCatLinkArcItm
/// Input      : 子表ID
/// Others     ：w ##class(web.DHCAPPArcCat).DelCatLinkArcItm("1||1")
ClassMethod DelCatLinkArcItm(AcRowId As %String) As %String
{
	n (AcRowId)
	&sql(delete from DHC_AppCatLinkArcItm where AC_RowID=:AcRowId)
	q SQLCODE
}

/// Creator    ：Qunianpeng
/// CreatDate  ：2018-03-19
/// Descript   : 查询关联医嘱项子表
/// Table      ：DHC_AppCatLinkArcItm
/// Input      : 子表id
/// Others     ：w ##class(web.DHCAPPArcCat).QueryCatLinkArcItm(10,1,1) 
ClassMethod QueryCatLinkArcItm(rows, page, ItmId) As %String
{
	n (rows,page,ItmId)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()		
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s ChildSub=""
	f  s ChildSub=$o(^DHCAPARCCA(ItmId,"ArcItm",ChildSub)) q:ChildSub=""  d
	.s AcRowId=ItmId_"||"_ChildSub
	.s ArcDr=$p(^DHCAPARCCA(ItmId,"ArcItm",ChildSub),"^",1)    	/// 医嘱项ID
	.s ArcimSub=$p(ArcDr,"||",1)
	.s ArcimVer=$p(ArcDr,"||",2)
	.s ArcDesc=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	.s ArcCode=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",1)
	.s FrostFlag=$p(^DHCAPARCCA(ItmId,"ArcItm",ChildSub),"^",2) /// 冰冻标志
	.s FrostFlag=$s(FrostFlag="Y":"是",FrostFlag="N":"否",1:"")
	.s ArcSingleFlag=$p(^DHCAPARCCA(ItmId,"ArcItm",ChildSub),"^",3) 
	.s ArcSingleFlag=$s(ArcSingleFlag="Y":"是",ArcSingleFlag="N":"否",1:"")
	.s h=h+1
	.s tempstr=AcRowId_"^"_ArcDr_"^"_ArcCode_"^"_ArcDesc_"^"_FrostFlag_"^"_ArcSingleFlag
	.s ^TMP("DHCST","web.DHCAPPArcCat","QueryCatLinkArcItm",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	/// 输出json结尾符
	
	///转换数据为Json格式
	s title="AcRowId^ArcDr^ArcCode^ArcDesc^FrostFlag^ArcSingleFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		/// 输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArcCat","QueryCatLinkArcItm",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCST","web.DHCAPPArcCat","QueryCatLinkArcItm",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign()			/// 输出json结尾符
	d ..killTmpGlobal(pid) 										/// k掉临时global
	q ""
}

/// Creator    ：Qunianpeng
/// CreatDate  ：2018-03-19
/// Descript   : 判断相同的分类，是否关联相同的医嘱项
/// Table      ：DHC_AppArcCat,DHC_AppCatLinkARCItm
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:不存在 ，其他：存在
/// Others     ：w ##class(web.DHCAPPArcCat).isExistSamearcCat("^1^胆道镜^116")
ClassMethod isExistSameCatArcItm(tmpstr As %String) As %String
{
	n (tmpstr)
	s ret=0
	s ArcID=$p(tmpstr,"^",2)	 /// 医嘱项id
	s CatID=$p(tmpstr,"^",3)	 /// 医嘱子类id
	s ForstFlag=$p(tmpstr,"^",4)
	s ArcSingleFlag=$p(tmpstr,"^",5)
	q:CatID="" 0
	s ChildSub=""
	f  s ChildSub=$o(^DHCAPARCCA(CatID,"ArcItm",ChildSub)) q:(ChildSub="")||(ret'=0)  d
	.s tmpArcID=$p(^DHCAPARCCA(CatID,"ArcItm",ChildSub),"^",1)  /// 医嘱子类ID
	.s tmpForstFlag=$p(^DHCAPARCCA(CatID,"ArcItm",ChildSub),"^",2)  /// 医嘱子类
	.q:tmpArcID'=ArcID
	.q:ForstFlag'=tmpForstFlag
	.s tmpArcSingleFlag=$p(^DHCAPARCCA(CatID,"ArcItm",ChildSub),"^",3)  /// 单独
	.q:ArcSingleFlag'=tmpArcSingleFlag
	.s ret="-11"
	q ret
}

}
