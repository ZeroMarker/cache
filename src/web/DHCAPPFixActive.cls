Import SQLUSER

Class web.DHCAPPFixActive Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      Liyarong 
/// CreatDate：    2018-05-10
/// Description：  保存固定液字典表
/// Table：        User.DHCAPPFixActive
/// Input：		   固定液表ID^固定液代码^固定液描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPFixActive).SavePatFixActive("^22^22^2^Y")
ClassMethod SavePatFixActive(params As %String) As %String
{
	n (params)
	s ^ZXZX=params
	s Err=0
	TS
	s Len=$l(params,"$$")
	for i=1:1:Len  d
	.s ListData=$p(params,"$$",i)
	.s Err=..CheckRepeat(ListData)   	/// 重复性判断
	.q:Err'=0
	.i $p(ListData,"^",1)'=""  q:Err'=0  d
	..s Err=..UpdateFixActive(ListData)  /// 更新
	.e  d
	..s Err=..InsertFixActive(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      Liyarong
/// CreatDate：    2018-05-10
/// Description：  保存固定液字典表
/// Table：        User.DHCAppFixActive
/// Input：		   固定液ID^固定液代码^固定液描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPFixActive).InsertFixActive("^33^33^65^Y")
ClassMethod InsertFixActive(ListData As %String) As %String
{
	n (ListData)
	s APFixCode=$p(ListData,"^",2)     	/// 固定液代码
	s APFixDesc=$p(ListData,"^",3)	 		/// 固定液描述
	s APHospID=$p(ListData,"^",4)   	/// 医院ID
	s APFlag=$p(ListData,"^",5)	 		/// 可用标识
	//s obj=#class(User.DHCAPPFixActive)
	&SQL(Insert into DHC_AppFixActive (AP_FixCode,AP_FixDesc,AP_Hosp_Dr,AP_ActiveFlag) values 
	(:APFixCode,:APFixDesc,:APHospID,:APFlag))
	q SQLCODE
}

/// Creator：      Liyarong
/// CreatDate：    2018-05-10
/// Description：  保存固定液字典表
/// Table：        User.DHCAppFixActive
/// Input：		   固定液表ID^固定液代码^固定液描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPFixActive).UpdateFixActive()
ClassMethod UpdateFixActive(ListData As %String) As %String
{
	n (ListData)
	s APFixRowID=$p(ListData,"^",1)		/// 固定液表ID
	s APFixCode=$p(ListData,"^",2)			/// 固定液代码
	s APFixDesc=$p(ListData,"^",3)			/// 固定液描述
	s APHospID=$p(ListData,"^",4)		/// 医院ID
	s APFlag=$p(ListData,"^",5)			/// 可用标识
	&SQL(Update DHC_AppFixActive Set AP_FixCode=:APFixCode,AP_FixDesc=:APFixDesc,AP_Hosp_Dr=:APHospID,AP_ActiveFlag=:APFlag Where AP_FixRowId =:APFixRowID)
	q SQLCODE
}

/// Creator：      Liyarong
/// CreatDate：    2018-05-10
/// Description：  删除固定液字典表
/// Table：        User.DHCAppFixActive
/// Input：		   固定液表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPFixActive).DeleteFixActive()
ClassMethod DeleteFixActive(APFixRowID As %String) As %String
{
	n (APFixRowID)
	&sql(delete from DHC_AppFixActive where AP_FixRowId=:APFixRowID)
	q SQLCODE
}

/// Creator：  Liyarong
/// CreatDate: 2018-05-10
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAPPFixActive
/// Others：   w ##class(web.DHCAPPFixActive).CheckRepeat("^11^11^65^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	 ///ID
	s APFixCode=$p(ItmTempStr,"^",2)  	 ///代码
	s APFixDesc=$p(ItmTempStr,"^",3) 	 ///描述
	s HospID=$p(ItmTempStr,"^",4)	 ///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPFIX(0,"Code",$$ALPHAUP^SSUTIL4((APFixCode))))   d
	..s APFixID=""
	..for  s APFixID=$o(^DHCAPPFIX(0,"Code",$$ALPHAUP^SSUTIL4(APFixCode),APFixID)) q:(APFixID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPFIX(APFixID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPFIX(0,"Desc",$$ALPHAUP^SSUTIL4(APFixDesc)))  d
	..s APFixID=""
	..f  s APFixID=$o(^DHCAPPFIX(0,"Desc",$$ALPHAUP^SSUTIL4(APFixDesc),APFixID))  q:(APFixID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPFIX(APFixID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPFIX(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPFIX(ID)),"^",2)    //描述
	.i (Code'=APFixCode)&($d(^DHCAPPPR(0,"Code",$$ALPHAUP^SSUTIL4(APFixCode))))  d
	..s APFixID=""
	..f  s APFixID=$o(^DHCAPPFIX(0,"Code",$$ALPHAUP^SSUTIL4(APFixCode),APFixID)) q:(APFixID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPFIX(APFixID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=APFixDesc)&($d(^DHCAPPFIX(0,"Desc",$$ALPHAUP^SSUTIL4(APFixDesc))))  d
	..s APFixID=""
	..f  s APFixID=$o(^DHCAPPFIX(0,"Desc",$$ALPHAUP^SSUTIL4(APFixDesc),APFixID)) q:(APFixID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPFIX(APFixID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      Liyarong
/// CreatDate：    2018-05-10
/// Description：  查询固定液字典表
/// Table：        User.DHCAppFixActive
/// Input：		   params:"代码^描述",HospID:医院ID
/// Output：       固定液字典表信息
/// Others：       w ##Class(web.DHCAPPFixActive).QueryFixActive(10,1,"","65")
ClassMethod QueryFixActive(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s APFixRowID=""
	for  s APFixRowID=$o(^DHCAPPFIX(APFixRowID)) q:APFixRowID=""  d  // 查询表User.DHCAPPFixActive
	.q:APFixRowID=0
	.s APFixCode=$p(^DHCAPPFIX(APFixRowID),"^",1)      			// 固定液代码
	.s APFixDesc=$p(^DHCAPPFIX(APFixRowID),"^",2)	  				// 固定液描述
	.s HospDr=+$p(^DHCAPPFIX(APFixRowID),"^",3)	  				// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)		// 医院描述
	.s APFlag=$p(^DHCAPPFIX(APFixRowID),"^",4)					// 是否可用标识
	.s FlagCode=APFlag
	.s APFlag=$s(APFlag="Y":"是",APFlag="N":"否",1:"")
	.q:(Code'="")&(APFixCode'[Code)							// 代码过滤
	.q:(Desc'="")&(APFixCode'[Desc)							// 描述过滤
	.;q:HospID'=HospDr										// 医院过滤
	.s h=h+1
	.s tempstr=APFixRowID_"^"_APFixCode_"^"_APFixDesc_"^"_HospDr_"^"_HospDesc_"^"_APFlag_"^"_FlagCode
	.s ^TMP("DHCAPP","web.DHCAPPFixActive","QueryFixActive",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	///转换数据为Json格式
	s title="APFixRowID^APFixCode^APFixDesc^HospDr^HospDesc^APFlag^FlagCode" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPFixActive","QueryFixActive",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPFixActive","QueryFixActive",pid,index))
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
	k ^TMP("DHCAPP","web.DHCAPPFixActive","QueryFixActive",pid)
}

}
