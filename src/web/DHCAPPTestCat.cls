Import SQLUSER

Class web.DHCAPPTestCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2017-10-10
/// Description：  保存检测项目分类维护表
/// Table：        User.DHCAppTestCat
/// Input：		   分类表ID^分类代码^分类描述^医院ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestCat).SaveTestCat("^22^22^65")
ClassMethod SaveTestCat(params As %String) As %String
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
	..s Err=..UpdateTestCat(ListData)  /// 更新
	.e  d
	..s Err=..InsertTestCat(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2017-10-10
/// Description：  保存检测项目分类维护表
/// Table：        User.DHCAppTestCat
/// Input：		   分类表ID^分类代码^分类描述^医院ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestCat).InsertTestCat("^33^33^65^Y^dsdfsdfs")
ClassMethod InsertTestCat(ListData As %String) As %String
{
	n (ListData)
	s ACCode=$p(ListData,"^",2)     	/// 分类代码
	s ACDesc=$p(ListData,"^",3)	 		/// 分类描述
	s ACHospID=$p(ListData,"^",4)       /// 医院ID
	&SQL(Insert into DHC_AppTestCat (AC_Code,AC_Desc,AC_Hosp_Dr) values 
	(:ACCode,:ACDesc,:ACHospID))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-10-10
/// Description：  更新检测项目分类维护表
/// Table：        User.DHCAppTestCat
/// Input：		   分类表ID^分类代码^分类描述^医院ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestCat).UpdateTestCat()
ClassMethod UpdateTestCat(ListData As %String) As %String
{
	n (ListData)
	s ACRowID=$p(ListData,"^",1)		/// 分类表ID
	s ACCode=$p(ListData,"^",2)			/// 分类代码
	s ACDesc=$p(ListData,"^",3)			/// 分类描述
	s ACHospID=$p(ListData,"^",4)		/// 医院ID
	&SQL( Update DHC_AppTestCat Set AC_Code=:ACCode,AC_Desc=:ACDesc,AC_Hosp_Dr=:ACHospID Where AC_RowID =:ACRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-10-10
/// Description：  删除检测项目分类维护表
/// Table：        User.DHCAppTestCat
/// Input：		   分类表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestCat).DeleteTestCat()
ClassMethod DeleteTestCat(ACRowID As %String) As %String
{
	n (ACRowID)
	&sql(delete from DHC_AppTestCat where AC_RowID=:ACRowID)
	q SQLCODE
}

/// Creator：  	   sufan
/// CreatDate:     2017-07-06
/// Description：  检查代码、描述是否重复
/// Table：    	   User.DHCAppTestCat
/// Others：   	   w ##class(web.DHCAPPTestCat).CheckRepeat("4^22^3443^65")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s ACCode=$p(ItmTempStr,"^",2)   ///代码
	s ACDesc=$p(ItmTempStr,"^",3)   ///描述
	s HospID=$p(ItmTempStr,"^",4)	///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPTC(0,"Code",$$ALPHAUP^SSUTIL4((ACCode))))   d
	..s ACID=""
	..for  s ACID=$o(^DHCAPPTC(0,"Code",$$ALPHAUP^SSUTIL4(ACCode),ACID)) q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTC(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPTC(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc)))  d
	..s ACID=""
	..f  s ACID=$o(^DHCAPPTC(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc),ACID))  q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTC(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPTC(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPTC(ID)),"^",2)    //描述
	.i (Code'=ACCode)&($d(^DHCAPPTC(0,"Code",$$ALPHAUP^SSUTIL4(ACCode))))  d
	..s ACID=""
	..f  s ACID=$o(^DHCAPPTC(0,"Code",$$ALPHAUP^SSUTIL4(ACCode),ACID)) q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTC(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=ACDesc)&($d(^DHCAPPTC(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc))))  d
	..s ACID=""
	..f  s ACID=$o(^DHCAPPTC(0,"Desc",$$ALPHAUP^SSUTIL4(ACDesc),ACID)) q:(ACID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTC(ACID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-10-10
/// Description：  查询检测项目分类维护表
/// Table：        User.DHCAppTestCat
/// Input：		   params:"分类代码^分类描述",HospID:医院ID
/// Output：       病理分类信息
/// Others：       w ##Class(web.DHCAPPTestCat).QueryTestCat(10,1,"","65")
ClassMethod QueryTestCat(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s ACRowID=0
	for  s ACRowID=$o(^DHCAPPTC(ACRowID)) q:ACRowID=""  d   // 查询表User.DHCAppTestCat
	.s ACCode=$p(^DHCAPPTC(ACRowID),"^",1)      			// 分类代码
	.s ACDesc=$p(^DHCAPPTC(ACRowID),"^",2)	  				// 分类描述
	.s HospDr=+$p(^DHCAPPTC(ACRowID),"^",3)	  				// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)	// 医院描述
	.q:(Code'="")&(ACCode'[Code)						// 代码过滤
	.q:(Desc'="")&(ACDesc'[Desc)						// 描述过滤
	.;q:HospID'=HospDr									// 医院过滤
	.s h=h+1
	.s tempstr=ACRowID_"^"_ACCode_"^"_ACDesc_"^"_HospDr_"^"_HospDesc
	.s ^TMP("DHCAPP","web.DHCAPPTestCat","QueryTestCat",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="ACRowID^ACCode^ACDesc^HospDr^HospDesc" 	// 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTestCat","QueryTestCat",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTestCat","QueryTestCat",pid,index))
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
	k ^TMP("DHCAPP","web.DHCAPPTestCat","QueryTestCat",pid)
}

}
