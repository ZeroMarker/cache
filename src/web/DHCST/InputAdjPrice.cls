Import sqluser

/// creator:yunhaibao
/// createdate:20161014
/// description:BS版本药库导价格程序
/// model: 药品代码	药品名称	单位	进价	售价	医院名称	
/// others:注意统一价的进价售价必须导入,且进售价应与单位统一,导入前请仔细核对
/// 		  文件为制表符格式的txt文件
/// windows路径:w ##class(web.DHCST.InputAdjPrice).StartInput("D:\tmp\inputadjprice.txt","")
/// 小机路径:w ##class(web.DHCST.InputAdjPrice).StartInput("/tmp/stockrec.txt","")
Class web.DHCST.InputAdjPrice Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/// 执行导入的总入口
ClassMethod StartInput(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="web.DHCST.InputAdjPrice"
  s p=$zn
  k ^zTSA(p,sub)
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s adjPriceId=""
  s AdjSpNo=##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTADJSP","","")
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .s cnt=cnt+1
  .tstart
  .s insRet=..InsertAdjPrice(AdjSpNo,rowStr)
  .i insRet>0 d
  ..tcommit
  ..s successCnt=successCnt+1
  .e  d
  ..tro
  k ^zTSA(p,sub)  //删除临时global
  q "总记录数:"_cnt_",成功记录数:"_successCnt
}

/// 返回值:>0成功,否则失败
ClassMethod InsertAdjPrice(adjspno, rowdata)
{
	n (adjspno,rowdata)
	s inputcode=$p(rowdata,"^",1)
	s inputdesc=$p(rowdata,"^",2)
	s inputuomdesc=$p(rowdata,"^",3)
	s inputrp=+$p(rowdata,"^",4)
	s inputsp=+$p(rowdata,"^",5)
	s inputhospdesc=$p(rowdata,"^",6)
	i inputcode="" w "代码为空",!
	q:inputcode="" -1
	i inputhospdesc="" w "代码"_inputcode_"的医院名称为空",!
	s hosprowid=$o(^CT("HOSP",0,"Desc",inputhospdesc,""))
	i hosprowid="" w "代码"_inputcode_"的医院名称不存在",!
	q:hosprowid="" -7
  	s incirowid=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(inputcode)_"Z",""))
  	i incirowid="" w "代码"_inputcode_"不存在",!
  	q:incirowid="" -1
  	s inputuom=""
  	&sql(select CTUOM_RowId into :inputuom from ct_uom where CTUOM_Desc=:inputuomdesc)
  	i inputuom="" w "代码"_inputcode_"的单位:"_inputuomdesc_"不存在",!
  	q:inputuom="" -2
	s puom=$p(^INCI(incirowid,3),"^",6)
	s buom=$p(^INCI(incirowid,1),"^",10)
	s uomflag=""
	i (puom'=inputuom)&&(buom'=inputuom) d
	.w "代码"_inputcode_"的单位不为基本单位或入库单位之一",!
	.s uomflag="1"
	q:uomflag=1 -3
	s chkadjret=..CheckItmAdjSp(incirowid)
  	i chkadjret=1 d
  	.w "代码"_inputcode_"存在未生效的调价单",!
  	q:chkadjret=1 -4
    s todayflag=..CheckItmAspToday(incirowid)
	i todayflag=1 d
	.w "代码"_inputcode_"存在当天生效的调价单,不能再次调价"
	q:todayflag=1 -5
	s preExeDate=+$h+1
	s data1=incirowid_"^"_inputuom_"^"_inputrp_"^"_inputsp_"^"_preExeDate
	s data2=""_"^"_""_"^"_""
	s aspinfo=data1_"^"_data2
	s retvalue=..CreateAspItm(adjspno,aspinfo,1,hosprowid)  //生成调价表记录
	i retvalue'>0 w "代码"_inputcode_"生成调价记录失败",!
	q:retvalue'>0 -100
	q retvalue
}

ClassMethod CreateAspItm(AdjSpNo, AspInfo, AdjUserId, HospId) As %String
{
    n (AdjSpNo,AspInfo,AdjUserId,HospId)
    s AdjDate=+$h
    s ExecuteDate=$zdh("9999-12-31",3)
    s ItmRowid=$p(AspInfo,"^",1)
    s AdjUomId=$p(AspInfo,"^",2)        ;调价单位   
    s ResultRp=$p(AspInfo,"^",3)        ;调后进价
    s ResultSp=$p(AspInfo,"^",4)        ;调后售价
    s PreExecuteDate=$p(AspInfo,"^",5)  ;计划生效日期
    s WarrentNo=$p(AspInfo,"^",6)       ;物价文件号
    s WarrentDate=$p(AspInfo,"^",7)     ;物价文件日期
    s AdjSpReason=$p(AspInfo,"^",8)     ;调价原因id    
    s:PreExecuteDate="" PreExecuteDate=+$h+1    ;计划生效日期为空, 缺省为第二天    
    s ret=0
    &sql(select inci_incsc_dr,inci_ctuom_dr,inci_ctuom_purch_dr into :StkCatId,:uom,:puom from inc_itm where inci_rowid=:ItmRowid)
    i SQLCODE s ret=-1
    q:ret<0 ret
    s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(AdjUomId,uom)   
    s BResultSp=ResultSp/fac
    s BResultRp=ResultRp/fac
    s BPriorRp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(ItmRowid,+$h,uom,HospId)
    s BPriorSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ItmRowid,+$h,uom,HospId)
    s Status="Audit"
    s Remark="批量调价"
   	s AuditUser=1
   	s AuditDate=+$h
   	s AuditTime=$p($h,",",2)
    &sql(insert into in_adjsaleprice(inasp_date,inasp_inci_dr,inasp_incsc_dr,inasp_priorsp,inasp_resultsp,
        inasp_ssusr_dr,inasp_status,inasp_no,INASP_ExecuteDate,inasp_ctuom_dr,
        inasp_ctuom_price,INASP_PriorRP,INASP_ResultRP,INASP_CTUOM_Rp,INASP_Hospital_Dr,
        INASP_PreExeDate,INASP_Remark,INASP_WarrentNo,INASP_WNODate,INASP_REASON_DR,INASP_AuditUser,INASP_AuditDate,INASP_AuditTime) 
        values(:AdjDate,:ItmRowid,:StkCatId,:BPriorSp,:BResultSp,
        :AdjUserId,:Status,:AdjSpNo,:ExecuteDate,:AdjUomId,
        :ResultSp,:BPriorRp,:BResultRp,:ResultRp,:HospId,
        :PreExecuteDate,:Remark,:WarrentNo,:WarrentDate,:AdjSpReason,:AuditUser,:AuditDate,:AuditTime))
    i SQLCODE'=0 d
    .s ret=-10
    e  s ret=$p(%ROWID,$c(1))
    q ret
}

/// Descript:   检查是否存在某库存项对应的未生效的调价单
/// Creater:    ZhangDongmei
/// CreateDate: 2012-02-06
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
    f  s ExeDate=$o(^INASP(0,"INCI",ItmRowid,ExeDate))  q:ExeDate=""  d
    .s AspId=""
    .f  s AspId=$o(^INASP(0,"INCI",ItmRowid,ExeDate,AspId)) q:AspId=""  d
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
