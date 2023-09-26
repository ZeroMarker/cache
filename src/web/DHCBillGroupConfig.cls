/// 名称: web.DHCBillGroupConfig.cls
/// 描述: 计费安全组配置
/// 编写者：ZhYW
/// 编写日期: 2018-03-08
Class web.DHCBillGroupConfig Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-03-08
/// Description: 取结算发票明细列头
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillGroupConfig).GetInvDetColumns()
ClassMethod GetInvDetColumns(langId As %String = "") As %String
{
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	kill columnAry
	set i=0
	set columnAry($i(i))="TInvDate^交款日期"
	set columnAry($i(i))="TInvTime^交款时间"
	set columnAry($i(i))="TPatName^交款人"
	set columnAry($i(i))="TMedicareNo^病案号"
	set columnAry($i(i))="TRegNo^登记号"
	set columnAry($i(i))="TInvSum^总金额"
	set columnAry($i(i))="TStatus^状态"
	set columnAry($i(i))="TInvNo^发票号"
	set columnAry($i(i))="TRowId^记录号"
	set columnAry($i(i))="TInitInvDR^原发票记录"
	set columnAry($i(i))="TInvFootDR^结账号"
	set columnAry($i(i))="TAdmReaDesc^费别"
	set columnAry($i(i))="TCTDepSum^冲押金金额"
	set columnAry($i(i))="TCTDepRcptNoStr^冲押金号码"

	set paymIdx=0
	set paymId=0
	while($o(^CT("CTPM",paymId))) {
		set paymId=$o(^CT("CTPM",paymId))
		set paymData=$g(^CT("CTPM",paymId))
		continue:(paymData="")
		set dateFrom=$p(paymData,"^",5)
		set dateTo=$p(paymData,"^",6)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set colField="TPaym"_$i(paymIdx)
		set paymDesc=$p(paymData,"^",2)
		set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
		set columnAry($i(i))=colField_"^"_paymDesc
	}
	
	set columnAry($i(i))="TInvRoundErrSum^分币误差"
	set columnAry($i(i))="TEncryptLevel^级别"
	set columnAry($i(i))="TPatLevel^密级"
	
	set ary=[]
	set index=0
	while($o(columnAry(index))) {
		set index=$o(columnAry(index))
		set opts=$g(columnAry(index))
		set field=$p(opts,"^",1)
		set title=$p(opts,"^",2)
		set align="left"
		if ((field["TPaym")||(field["Sum")) {
			set align="right"
		}
		set d={}
		do d.%Set("field", field)
		do d.%Set("title", title)
		do d.%Set("align", align)
		do d.%Set("width", 100)
		do ary.%Push(d)
	}
	set stream=##class(%GlobalCharacterStream).%New()
	do ary.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

}
