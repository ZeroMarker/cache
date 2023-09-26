/// 用来处理出院的设置
/// 并提供接口获取配置,以及根据日期和配置得到出院病人admId
/// 出院设置存储在Global:^DHCWLYGYYCFG("Discharg")
/// 值为0表示出入转,值为1表示取护士结算,值为2表示取医生结算
Class DHCWL.YGYY.DischaCFG Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 设置可写的值及其描述
/// Table：       
/// Input：       
/// Output：      data:data为数组,节点下标为可写的值,值为对应描述
/// Return：      成功返回1,否则返回0
/// Others：	  d ##class(DHCWL.YGYY.DischaCFG).InitCFGDesc(.data)
ClassMethod InitCFGDesc(data) As %Status [ Private ]
{
	s data(0)="出入转方式"
	s data(1)="最终结算方式"
	s data(2)="医疗结算方式"
	
	q 1
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 将值写入设置,如果值非法,则不修改原值
/// Table：       
/// Input：       val
/// Output：      
/// Return：      成功返回1,否则返回0
/// Others：	w ##class(DHCWL.YGYY.DischaCFG).SetDischaCFG(2)
ClassMethod SetDischaCFG(val) As %Status
{
	s $zt="ErrSet"
	d ##class(DHCWL.YGYY.DischaCFG).InitCFGDesc(.data)
	q:'$d(data(val)) 0	//如果设置的值非法,则退出
	s ^DHCWLYGYYCFG("Discharg")=val

	q 1
	
ErrSet
	w "设置非法",!
	q 0
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 获得设置值的数字格式,如果未定义或非法,则默认为0
/// Table：       
/// Input：       
/// Output：      
/// Return：      返回设置值的数字格式
/// Others：	  w ##class(DHCWL.YGYY.DischaCFG).GetDischaCFG()
ClassMethod GetDischaCFG() As %String
{
	d ##class(DHCWL.YGYY.DischaCFG).InitCFGDesc(.data)
	s cfg=+$g(^DHCWLYGYYCFG("Discharg"))
	q:$d(data(cfg)) cfg	//如果是合法定义,返回定义值
	q 0	//如果是非法定义,返回0
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 获得设置值的数字格式,如果未定义或非法,则默认为0的描述
/// Table：       
/// Input：       
/// Output：      
/// Return：      返回设置值的描述形式
/// Others：	  w ##class(DHCWL.YGYY.DischaCFG).GetDischaCFGDesc()
ClassMethod GetDischaCFGDesc() As %String
{
	s $zt="ErrGetCFGDesc"
	s cfg=##class(DHCWL.YGYY.DischaCFG).GetDischaCFG()
	d ##class(DHCWL.YGYY.DischaCFG).InitCFGDesc(.data)
	q data(cfg)

ErrGetCFGDesc

	q ""
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 通过最终结算日期获取所有的出院的admId
/// Table：       
/// Input：       disDate,日期,自然格式,如:2014-03-11;
/// Output：      admData:admData为数组,节点下标为admId,值为出院科室^出院病区^出院医生的字符串
///               
/// Return：      成功返回1,否则返回0
/// Others：	  d ##class(DHCWL.YGYY.DischaCFG).GetDischargAdm("2012-12-02",.admData)
ClassMethod GetDischargAdm(disDate, admData) As %Status [ Private ]
{
	s $zt="ErrGetDischargAdm"
	s disDate=$zdh(disDate,3)
	s admId=0
	f  s admId=$o(^PAADMi("DischDate",disDate,admId)) q:admId=""  d
	.s disLoc=$p(^PAADM(admId),"^",4)
	.s disDoc=$p(^PAADM(admId),"^",9)
	.s disWard=$p(^PAADM(admId),"^",70)
	.s admData(admId)=disLoc_"^"_disWard_"^"_disDoc
	
	q 1
	
ErrGetDischargAdm


	q 0
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 通过医疗结算日期获取所有的出院的admId
/// Table：       
/// Input：       disDate,日期,自然格式,如:2014-03-11;
/// Output：      admData:admData为数组,节点下标为admId,值为出院科室^出院病区^出院医生的字符串
///               
/// Return：      成功返回1,否则返回0
/// Others：	  d ##class(DHCWL.YGYY.DischaCFG).GetEstDischargAdm("2014-03-05",.admData)
ClassMethod GetEstDischargAdm(disDate, admData) As %Status [ Private ]
{
	s $zt="ErrGetEstDischargAdm"
	s disDate=$zdh(disDate,3)
	s admId=0
	f  s admId=$o(^PAADMi("EstDisch",disDate,admId)) q:admId=""  d
	.s disLoc=$p(^PAADM(admId),"^",4)
	.s disDoc=$p(^PAADM(admId),"^",9)
	.s disWard=$p(^PAADM(admId),"^",70)
	.s admData(admId)=disLoc_"^"_disWard_"^"_disDoc
	
	q 1
	
ErrGetEstDischargAdm


	q 0
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 通过出入转日期获取所有的出院的admId
/// Table：       
/// Input：       disDate,日期,自然格式,如:2014-03-11;
/// Output：      admData:admData为数组,节点下标为admId,值为出院科室^出院病区^出院医生的字符串
///               
/// Return：      成功返回1,否则返回0
/// Others：	  d ##class(DHCWL.YGYY.DischaCFG).GetMRDischargAdm("2014-03-05",.admData)
ClassMethod GetMRDischargAdm(disDate, admData) As %Status [ Private ]
{
	n (disDate, admData)
	s $zt="ErrGetMRDischargAdm"
	s disDate=$zdh(disDate,3)
	s mrId=0
	f  s mrId=$o(^MRIPdaily("MRIP_DATE",disDate,mrId)) q:mrId=""  d
	.s disLoc=$p(^MRIPdaily(mrId),"^",7)
	.
	.s disWard=$p(^MRIPdaily(mrId),"^",19)
	.
	.s admId=0
	.f  s admId=$o(^DHCMRIPDetail(0,"IPDayDr",mrId,"Type","CYRS","Paadm",admId)) q:admId=""  d
	..s disDoc=$p(^PAADM(admId),"^",9)
	..
	..i disLoc'="" d
	...s $p(admData(admId),"^",1)=disLoc
	..i disWard'="" d
	...s $p(admData(admId),"^",2)=disWard
	..s $p(admData(admId),"^",3)=disDoc
	
	q 1
	
ErrGetMRDischargAdm

	q 0
}

/// Creator：      ban
/// CreatDate：    2014-03-11
/// Description:： 通过出院设置获取所有的出院的admId
/// Table：       
/// Input：       disDate,日期,自然格式,如:2014-03-11;cfgValue,设置的值,如果不传,则取系统设置的值
/// Output：      admData:admData为数组,节点下标为admId,值为出院科室^出院病区^出院医生的字符串
///               
/// Return：      成功返回1,否则返回0
/// Others：	  d ##class(DHCWL.YGYY.DischaCFG).GetDischCFGAdm("2012-12-05",.admData)
ClassMethod GetDischCFGAdm(disDate, admData, cfgValue) As %Status
{
	s $zt="ErrGetDischCFGAdm"
	d ##class(DHCWL.YGYY.DischaCFG).InitCFGDesc(.cfgData)
	i '$d(cfgValue)||('$d(cfgData(cfgValue))) s cfgValue=..GetDischaCFG()
	i cfgValue=0 d ..GetMRDischargAdm(disDate,.admData)	//出入转
	i cfgValue=1 d ..GetDischargAdm(disDate,.admData)	//最终结算
	i cfgValue=2 d ..GetEstDischargAdm(disDate,.admData) //医疗结算
	q 1
	
ErrGetDischCFGAdm


	q 0
}

/// Creator：      zyb
/// CreatDate：    2014-04-15
/// Description:： 通过调查表获取所有的出院的admId
/// Table：        DHCWLPatAntiDrugInfo
/// Input：       disDate,日期,自然格式,如:2014-03-11
/// Output：      admData:admData为数组,节点下标为admId,值为出院科室^出院病区^出院医生的字符串
///               
/// Return：      成功返回1,否则返回0
/// Others：	  d ##class(DHCWL.YGYY.DischaCFG).GetDischCFGAdmPADI("2012-12-01",.admData)
ClassMethod GetDischCFGAdmPADI(disDate, admData) As %Status
{
	s $zt="ErrGetDischCFGAdmPADI"

	s disDate=$zdh(disDate,3)
	s padRowid=0
	f  s padRowid=$o(^DHCWLPADI(0,"DisDate",disDate,padRowid)) q:padRowid=""  d
	.s admId=$p(^DHCWLPADI(padRowid),"^",1)   
	.s disLoc=$p(^PAADM(admId),"^",4)
	.s disDoc=$p(^PAADM(admId),"^",9)
	.s disWard=$p(^PAADM(admId),"^",70)
	.i disLoc'="" d
	..s $p(admData(admId),"^",1)=disLoc
	.i disWard'="" d
	..s $p(admData(admId),"^",2)=disWard
	.s $p(admData(admId),"^",3)=disDoc
	
	q 1
	
ErrGetDischCFGAdmPADI


	q 0
}

}
