/// Creator：xiongwang
/// CreatDate：2021-06-20
/// Description: 收费应急系统-机器码管理
Class BILL.CES.COM.MacManager Extends %RegisteredObject
{

/// Creator:	xiongwang
/// CreatDate:	2020-10-23
/// Input:	params
/// Desc:	应急收费系统终端注册
/// Debug:		w ##class(BILL.CES.COM.MacManager).MacRegister("B4:A9:FC:A8:41:CA^002^10.6.6.28^测试")
ClassMethod MacRegister(params As %String) As %String
{
	set rtnCode=0,rtnMsg="成功"
	set Mac=$p(params,"^",1)		;终端Mac地址
	set Code=$p(params,"^",2)	;机器码
	set IPAddr=$p(params,"^",3)		;IP
	set MacRemarks=$p(params,"^",4)	;备注
	set webAddr=$p(params,"^",5)
	;1.验证机器码是否注册过
		;1.1 注册过:验证已注册机器码对应mac是否与传入mac一致,一致直接返回成功,不一致表示机器码已被占用返回失败
		;1.2 未注册:验证mac是否注册过，注册过更新,未注册新增.
	set myrtn=##class(CF.BSP.SYS.SRV.Client).SaveClient(Code,IPAddr,Mac,webAddr,+$h,"",MacRemarks)
	set rtnCode=$p(myrtn,"^",1)
	set rtnMsg=$p(myrtn,"^",2)
	quit rtnCode_"^"_rtnMsg
}

}
