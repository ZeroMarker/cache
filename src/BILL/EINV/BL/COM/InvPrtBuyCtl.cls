Class BILL.EINV.BL.COM.InvPrtBuyCtl Extends %RegisteredObject
{

/// 功能说明：导入发票购入信息
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// 修改履历：
/// s RowAmtmagInfo="100^Y^10207^1^1996-02-20^00000001^00000002^00000001^O^2^3^4^5^6^Lisi^2"
/// s ErrMsg=""
/// w ##class(BILL.EINV.BL.COM.InvPrtBuyCtl).ImportAmtmagByExcel(RowAmtmagInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportAmtmagByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s RtnFlg="0"
	s finacloc=$p(RowDataInfo, "^", 9)   ;发票类型
	s:finacloc="" ErrMsg="发票类型不能为空。"
	q:finacloc="" RtnFlg
	s Rowid=$o(^DHCAMTMAG(0,"L",finacloc,""))
	i Rowid="" d
	.s objAmtMag=##class(User.DHCAMTMAG).%New()
	e  d
	.s objAmtMag=##class(User.DHCAMTMAG).%OpenId(Rowid)
	
	s objAmtMag.finacamount=$p(RowDataInfo, "^", 1)     ;账户金额
	s objAmtMag.finacavail=$p(RowDataInfo, "^", 2)       ;标记状态
	d objAmtMag.finacbuyerSetObjectId($p(RowDataInfo,"^",3)) ;购入人 /// DR + SetObjectId(DR)
	s objAmtMag.finaccomment1=$p(RowDataInfo, "^", 4)
	s:$p(RowDataInfo,"^",5)'="" objAmtMag.finacdate=$zdh($p(RowDataInfo,"^",5),3) ;开始日期
	s objAmtMag.finacstnum=$p(RowDataInfo, "^", 6)       ;开始号码
	s objAmtMag.finacednum=$p(RowDataInfo, "^", 7)       ;结束号码
	s objAmtMag.finacnote=$p(RowDataInfo, "^", 8)      ;当前可用号码
	s objAmtMag.finacloc=$p(RowDataInfo, "^", 9)     ;发票类型
	s objAmtMag.finacjynum=$p(RowDataInfo, "^", 10)       ;
	s objAmtMag.finacserialno=$p(RowDataInfo, "^", 11)       ;
	s objAmtMag.finaccomment2=$p(RowDataInfo, "^", 12)    ;
	s objAmtMag.finactitle=$p(RowDataInfo, "^", 13)       ;
	s objAmtMag.finacupdatedat=$p(RowDataInfo, "^", 14)       ;
	d objAmtMag.finacupdateusrSetObjectId($p(RowDataInfo,"^",3)) ;更新购入人 /// DR + SetObjectId(DR)
	s objAmtMag.finachospital=$p(RowDataInfo, "^", 16)       ;医院编号
	
    ///保存数据
    s sc=objAmtMag.%Save()
    i $System.Status.IsError(sc) d
    .;$system.Status.GetErrorText(sc)
    .s RtnFlg="0"
    e  d
    .s RtnFlg=objAmtMag.%Id()
    
    q RtnFlg
}

// w ##class(BILL.EINV.BL.COM.InvPrtBuyCtl).invprtgetStartNo("O","2")

ClassMethod invprtgetStartNo(type, HospDr As %Library.String = "") As %String
{
	       s buyendno="",title=""
	       &sql(select max(finac_rowid) into:maxrow from SQLUser.dhc_amtmag where finac_loc=:type and finac_hospital=:HospDr)
	       ;w !,"^"_maxrow_"^"
	       &sql(select nvl(finac_ednum,"") into:buyendno from SQLUser.dhc_amtmag where finac_rowid=:maxrow)
	       ;w !,"!"_buyendno_"!"
	       i buyendno="" d
	       .s buyendno="00000001"
	       e  d
	       .s buyendno=##class(BILL.EINV.BL.COM.InvPrtBuyCtl).incre("","",buyendno)
	       q buyendno
}

ClassMethod incre(itmjs As %Library.String = "", itmjsex As %Library.String = "", invno As %String) As %String
{
    ;发票号自动累加1
	s invno=$g(invno)
	s lng=$l(invno)
	s ret=invno+1
	s l=$l(ret)
	f i=lng:(-1):(l+1) d
	.s ret="0"_""_ret
	q ret
}

}
