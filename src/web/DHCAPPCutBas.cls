Import SQLUSER

Class web.DHCAPPCutBas Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理取材信息字典表
/// Table：        User.DHCAppCutBas
/// Input：		   取材表ID^取材代码^取材描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPCutBas).SaveCutBas("^22^22^65^Y^dsds")
ClassMethod SaveCutBas(params As %String) As %String
{
	n (params)
	s Err=0
	TS
	s Len=$l(params,"$$")
	for i=1:1:Len  d
	.s ListData=$p(params,"$$",i)
	.s Err=..CheckRepeat(ListData)   	/// 重复性判断
	.q:Err'=0
	.i $p(ListData,"^",1)'=""  q:Err'=0  d
	..s Err=..UpdateCutBas(ListData)  /// 更新
	.e  d
	..s Err=..InsertCutBas(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理取材信息字典表
/// Table：        User.DHCAppCutBas
/// Input：		   取材表ID^取材代码^取材描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPCutBas).InsertCutBas("^33^33^65^Y")
ClassMethod InsertCutBas(ListData As %String) As %String
{
	n (ListData)
	s ACCode=$p(ListData,"^",2)     	/// 取材代码
	s ACDesc=$p(ListData,"^",3)	 		/// 取材描述
	s ACHospID=$p(ListData,"^",4)   	/// 医院ID
	s ACFlag=$p(ListData,"^",5)	 		/// 可用标识
	&SQL(Insert into DHC_AppCutBas (AC_Code,AC_Desc,AC_Hosp_Dr,AC_ActiveFlag) values 
	(:ACCode,:ACDesc,:ACHospID,:ACFlag))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  更新病理取材信息字典表
/// Table：        User.DHCAppCutBas
/// Input：		   取材表ID^取材代码^取材描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPCutBas).UpdateCutBas()
ClassMethod UpdateCutBas(ListData As %String) As %String
{
	n (ListData)
	s ACRowID=$p(ListData,"^",1)		/// 取材表ID
	s ACCode=$p(ListData,"^",2)			/// 取材代码
	s ACDesc=$p(ListData,"^",3)			/// 取材描述
	s ACHospID=$p(ListData,"^",4)		/// 医院ID
	s ACFlag=$p(ListData,"^",5)			/// 可用标识
	&SQL(Update DHC_AppCutBas Set AC_Code=:ACCode,AC_Desc=:ACDesc,AC_Hosp_Dr=:ACHospID,AC_ActiveFlag=:ACFlag Where AC_RowID =:ACRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  删除病理取材信息字典表
/// Table：        User.DHCAppCutBas
/// Input：		   取材表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPCutBas).DeleteTestMet()
ClassMethod DeleteCutBas(ACRowID As %String) As %String
{
	n (ACRowID)
	&sql(delete from DHC_AppCutBas where AC_RowID=:ACRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAppCutBas
/// Others：   w ##class(web.DHCAPPCutBas).CheckRepeat("3^55^11^65^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s ACCode=$p(ItmTempStr,"^",2)  ///代码
	s ACDesc=$p(ItmTempStr,"^",3)  ///描述
	s HospID=$p(ItmTempStr,"^",4)	///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPCB(0,"Code",$$ALPHAUP^SSUTIL4((ACCode))))   d
	..s ACID=""
	..for  s ACID=$o(^DHCAPPCB(0,"Code",$$ALPHAUP^SSUTIL4(ACCode),ACID)) q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPCB(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPCB(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc)))  d
	..s ACID=""
	..f  s ACID=$o(^DHCAPPCB(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc),ACID))  q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPCB(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPCB(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPCB(ID)),"^",2)    //描述
	.i (Code'=ACCode)&($d(^DHCAPPCB(0,"Code",$$ALPHAUP^SSUTIL4(ACCode))))  d
	..s ACID=""
	..f  s ACID=$o(^DHCAPPCB(0,"Code",$$ALPHAUP^SSUTIL4(ACCode),ACID)) q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPCB(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=ACDesc)&($d(^DHCAPPCB(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc))))  d
	..s ACID=""
	..f  s ACID=$o(^DHCAPPCB(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc),ACID)) q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPCB(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询病理取材信息字典表
/// Table：        User.DHCAppCutBas
/// Input：		   params:"代码^描述",HospID:医院ID
/// Output：       取材信息表信息
/// Others：       w ##Class(web.DHCAPPCutBas).QueryTestMet(10,1,"","65")
ClassMethod QueryCutBas(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s ACRowID=""
	for  s ACRowID=$o(^DHCAPPCB(ACRowID)) q:ACRowID=""  d  // 查询表User.DHCAppTesItmMet
	.q:ACRowID=0
	.s ACCode=$p(^DHCAPPCB(ACRowID),"^",1)      		// 取材代码
	.s ACDesc=$p(^DHCAPPCB(ACRowID),"^",2)	  			// 取材描述
	.s HospDr=+$p(^DHCAPPCB(ACRowID),"^",3)	  			// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)	// 医院描述
	.s ACFlag=$p(^DHCAPPCB(ACRowID),"^",4)				// 是否可用标识
	.s FlagCode=ACFlag
	.s ACFlag=$s(ACFlag="Y":"是",ACFlag="N":"否",1:"")
	.q:(Code'="")&(ACCode'[Code)						// 代码过滤
	.q:(Desc'="")&(ACDesc'[Desc)						// 描述过滤
	.;q:HospID'=HospDr									// 医院过滤
	.s h=h+1
	.s tempstr=ACRowID_"^"_ACCode_"^"_ACDesc_"^"_HospDr_"^"_HospDesc_"^"_ACFlag_"^"_FlagCode
	.s ^TMP("DHCAPP","web.DHCAPPCutBas","QueryCutBas",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="ACRowID^ACCode^ACDesc^HospDr^HospDesc^ACFlag^FlagCode" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPCutBas","QueryCutBas",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPCutBas","QueryCutBas",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCAPP","web.DHCAPPCutBas","QueryCutBas",pid)
}

}
