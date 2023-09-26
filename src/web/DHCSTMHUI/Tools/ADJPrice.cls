Import sqluser

/// 物资批量调价(内容需为同一个调价科室)
/// 	Author:	wangjiabin
/// 	Date:	2014-04-02
Class web.DHCSTMHUI.Tools.ADJPrice Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

ClassMethod InputItm(RowObj, AdjSpNo, Params) As %String
{
	n (RowObj,AdjSpNo,Params)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d DataRtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s locDesc=RowObj.%Get("科室名称")
	s locId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(locDesc),0))
	i locId="" d RtnObj.Err(-1,"","科室不存在!","",0)
	q:RtnObj.success'=0 RtnObj
	s HospId=..sssHospId(locId)
	s UserId=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s Params=GroupId_"^"_locId_"^"_UserId_"^"_HospId
	
	i AdjSpNo="" d
	.s AdjSpNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTADJSPM","",locId)
	.i AdjSpNo="" d RtnObj.Err(-1,"","生成调价单号失败!")
	i RtnObj.success'=0 q RtnObj 

	s code=RowObj.%Get("物资代码")   ;代码
	s desc=RowObj.%Get("科室名称")	;描述
	s uom=RowObj.%Get("调价单位")		;单位
	s rp=RowObj.%Get("调后进价")		;进价
	s sp=RowObj.%Get("调后售价")		;售价
	s preExeDate=RowObj.%Get("计划生效日期")		;计划生效日期
	s preExeDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(preExeDate)
	i +preExeDate<0 d RtnObj.Err(-1,"","计划生效日期格式不正确!","",0)
	i RtnObj.success'=0 q RtnObj 
	s WarrentNo=RowObj.%Get("物价文件号")
	s WarrentDate=RowObj.%Get("物价文件日期")
	s WarrentDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(WarrentDate)
	i +WarrentDate<0 d RtnObj.Err(-1,"","物价文件日期格式不正确!","",0)
	i RtnObj.success'=0 q RtnObj 
	s AdjSpReason=RowObj.%Get("调价原因(系统内维护的描述)")
	s AspResonId=..AspReason(AdjSpReason)

	s IncId=""
	s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(code)_"Z",""))
	i IncId="" d RtnObj.Err(-1,"","此代码无效","",0)
	i RtnObj.success'=0 q RtnObj 
	s UomId=""
	&sql(select CTUOM_RowId into :UomId from ct_uom where CTUOM_Desc=:uom)
	i +UomId=0 d RtnObj.Err(-1,"","单位不存在","",0)
	i RtnObj.success'=0 q RtnObj 

	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PUomId=$p(^INCI(IncId,3),"^",6)
	i UomId'=BUomId,UomId'=PUomId d RtnObj.Err(-1,"","调价单位不是基本单位和入库单位","",0)
	i RtnObj.success'=0 q RtnObj 

	s Flag=..CheckItmAdjSp(IncId)
	i Flag=1 d RtnObj.Err(-1,"","存在未生效的调价单,不能新建调价单","",0)
	i RtnObj.success'=0 q RtnObj 
	s TodayFlag=..CheckItmAspToday(IncId)
	i TodayFlag=1 d RtnObj.Err(-1,"","存在当天生效的调价单,不能再次调价","",0)
	i RtnObj.success'=0 q RtnObj

	s Data1=IncId_"^"_UomId_"^"_rp_"^"_sp_"^"_preExeDate
	s Data2=WarrentNo_"^"_WarrentDate_"^"_AspResonId
	s AspInfo=Data1_"^"_Data2
	s RtnObj=..createAspItm(AdjSpNo,AspInfo,UserId,HospId)  //生成调价表记录
	s RtnObj.rowid=AdjSpNo
	q RtnObj
}

/// 生成调价记录
/// inci -库存项目rowid
/// user -用户
/// rp -进价
/// sp -售价
/// hosp -医院rowid
/// 
ClassMethod createAspItm(AdjSpNo, AspInfo, AdjUserId, HospId) As %String
{
	n (AdjSpNo,AspInfo,AdjUserId,HospId)
  	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s AdjDate=+$h
	s ExecuteDate=$zdh("9999-12-31",3)
	s ItmRowid=$p(AspInfo,"^",1)
	s AdjUomId=$p(AspInfo,"^",2)		;调价单位	
	s ResultRp=$p(AspInfo,"^",3)		;调后进价
	s ResultSp=$p(AspInfo,"^",4)		;调后售价
	s PreExecuteDate=$p(AspInfo,"^",5)	;计划生效日期
	s WarrentNo=$p(AspInfo,"^",6)		;物价文件号
	s WarrentDate=$p(AspInfo,"^",7)		;物价文件日期
	s AdjSpReason=$p(AspInfo,"^",8)		;调价原因id
	
	s:PreExecuteDate="" PreExecuteDate=+$h+1	;计划生效日期为空, 缺省为第二天
	
	&sql(select inci_incsc_dr,inci_ctuom_dr,inci_ctuom_purch_dr into :StkCatId,:uom,:puom from inc_itm where inci_rowid=:ItmRowid)
	i SQLCODE d RtnObj.Err(-1,"","查询库存项基础信息失败")
  	i RtnObj.success'=0 q RtnObj   
	
	s AdjUserId=..User()
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AdjUomId,uom)
	
	s BResultSp=ResultSp/fac
	s BResultRp=ResultRp/fac
	s BPriorRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,uom,HospId)
	s BPriorSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,uom,HospId)
	
	s Status="No"
	s Remark="批量调价"
   
	&sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,inasp_resultsp,
		inasp_ssusr_dr,inasp_status,inasp_no,INASP_ExecuteDate,inasp_ctuom_dr,
		inasp_ctuom_price,INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,
		INASP_PreExeDate,INASP_Remark,INASP_WarrentNo,INASP_WNODate,INASP_REASON_DR) 
		values(:AdjDate,:ItmRowid,:StkCatId,:BPriorSp,:BResultSp,
		:AdjUserId,:Status,:AdjSpNo,:ExecuteDate,:AdjUomId,
		:ResultSp,:BPriorRp,:BResultRp,:ResultRp,:HospId,
		:PreExecuteDate,:Remark,:WarrentNo,:WarrentDate,:AdjSpReason))
	i SQLCODE d RtnObj.Err(-1,"","查询库存项基础信息失败")
  	i RtnObj.success'=0 q RtnObj   
	q RtnObj
}

/// 获取调价原因rowid
ClassMethod AspReason(reasonDesc) As %String
{
	n (reasonDesc)
	q:reasonDesc="" ""
	s reasonId=""
	s stktype=..sssCode()
	&sql(select %id into :reasonId from DHC_ReasonForAdjustPrice
	 where REA_Desc=:reasonDesc and REA_StkType=:stktype)
	q reasonId
}

/// 取demo的rowid
ClassMethod User() As %String
{
  s user="" 
  &sql(select %id into :user from ss_user where ssusr_initials='demo')
  q user
}

/// Descript:	检查是否存在某库存项对应的未生效的调价单
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-06
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:		
/// Return：1：存在；0：不存在
ClassMethod CheckItmAdjSp(ItmRowid As %String) As %Library.String
{
	n (ItmRowid)
	q:ItmRowid="" 0 
	s Flag=0
	;
	s ExeDate=""
	f  s ExeDate=$o(^INASP(0,"INCI",ItmRowid,ExeDate),-1)  q:ExeDate=""  d
	.s AspId=""
	.f  s AspId=$o(^INASP(0,"INCI",ItmRowid,ExeDate,AspId),-1) q:AspId=""  d
	..s Status=$p(^INASP(AspId),"^",9)
	..q:Status="Yes"    ;已生效
	..s Flag=1
	.
	q Flag
}

/// Descript:   检查是否存在某库存项对应的当天调价记录
/// Creater:    wangjiabin
/// CreateDate: 2013-06-25
/// Table:in_adjsaleprice
/// Input:库存项id
/// Output:     
/// Return：1：存在；0：不存在
ClassMethod CheckItmAspToday(ItmRowid As %String) As %Library.String
{
    n (ItmRowid)
    q:ItmRowid="" 0 
    s Flag=0
    ;
    s ExeDate=+$h+1
    f  s ExeDate=$o(^INASP(0,"INCI",ItmRowid,ExeDate),-1)  q:ExeDate=""  d
    .i ExeDate=+$h d
    ..s Flag=1
    .
    q Flag
}

}
