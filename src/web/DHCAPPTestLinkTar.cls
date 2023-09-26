Import SQLUser

Class web.DHCAPPTestLinkTar Extends %Library.RegisteredObject [ ClassType = "", Not DdlAllowed, Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2017-09-27
/// Description：  查询检测项目
/// Table：        DHC_AppTestItem
/// Output：       病理检测项信息
/// Others：       w ##Class(web.DHCAPPTestLinkTar).QueryTestItem(10,1,"65")
ClassMethod QueryTestItem(rows As %String, page As %String, HospID As %String) As %String
{
	n (rows,page,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	s ATIRowID=0
	for  s ATIRowID=$o(^DHCAPPTI(ATIRowID))  q:ATIRowID=""  d
	.s ATICode=$p(^DHCAPPTI(ATIRowID),"^",1)		/// 检测项目code
	.s ATIDesc=$p(^DHCAPPTI(ATIRowID),"^",2)		/// 检测项目描述
	.s HospDr=$p(^DHCAPPTI(ATIRowID),"^",4)			/// 医院
	.q:HospDr'=HospID
	.s ActiveFlag=$p(^DHCAPPTI(ATIRowID),"^",5)		/// 是否可用
	.q:ActiveFlag'="Y"
	.s h=h+1
	.s tempstr=ATIRowID_"^"_ATICode_"^"_ATIDesc_"^"_HospDr_"^"_ActiveFlag
	.s ^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTestItem",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 		// 输出json结尾符
	
	///转换数据为Json格式
	s title="ATIRowID^ATICode^ATIDesc^HospDr^ActiveFlag" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTestItem",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTestItem",pid,index))
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

/// Creator：      sufan
/// CreatDate：    2017-09-27
/// Description：  查询检测项目关联的收费项目
/// Table：        DHC_AppTestLinkTar
/// Output：       收费项信息
/// Others：       w ##Class(web.DHCAPPTestLinkTar).QueryTarByItmID(10,1,"5")
ClassMethod QueryTarByItmID(rows As %String, page As %String, TsetItmID As %String) As %String
{
	n (rows,page,TsetItmID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s h=0,count=0
	s TarID=""
	for  s TarID=$o(^DHCAPPTESTAR(0,"Test",TsetItmID,TarID))  q:TarID=""  d
	.s TarSDate=""
	.for  s TarSDate=$o(^DHCAPPTESTAR(0,"Test",TsetItmID,TarID,TarSDate))  q:TarSDate=""  d
	..s ATLRowID=0
	..for  s ATLRowID=$o(^DHCAPPTESTAR(0,"Test",TsetItmID,TarID,TarSDate,ATLRowID)) q:ATLRowID=""  d
	...s ItemDr=$p(^DHCAPPTESTAR(ATLRowID),"^",1)			/// 检测项目ID
	...s StaDate=$p(^DHCAPPTESTAR(ATLRowID),"^",3)			/// 开始日期
	...s StaDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(StaDate) 
	...s StaTime=$p(^DHCAPPTESTAR(ATLRowID),"^",4)			/// 开始时间
	...s EndDate=$p(^DHCAPPTESTAR(ATLRowID),"^",5)			/// 结束日期
	...i EndDate="" s EndDate="" 
	...e  s EndDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(EndDate) 
	...s EndTime=$p(^DHCAPPTESTAR(ATLRowID),"^",6)			/// 结束时间
	...s UpdUser=$p(^DHCAPPTESTAR(ATLRowID),"^",7)			/// 更新用户ID
	...s UpdUserName=""
	...s:UpdUser'="" UpdUserName=$p(^SSU("SSUSR",UpdUser),"^",2)   /// 更新用户
	...s UpdDate=$p(^DHCAPPTESTAR(ATLRowID),"^",8)			/// 更新日期
	...s UpdDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(UpdDate) 
	...s UpdTime=$p(^DHCAPPTESTAR(ATLRowID),"^",9)			/// 更新时间
	...s UpdTime=$zt(UpdTime,3)
	...s TarQty=$p(^DHCAPPTESTAR(ATLRowID),"^",10)			/// 数量
	...s TarCode=$p(^DHCTARI(TarID),"^",1)					/// 收费项CODE
	...s TarDesc=$p(^DHCTARI(TarID),"^",2)					/// 收费项描述
	...s TarSub=$o(^DHCTARI(TarID,"P",""),-1)
	...s Price=$p(^DHCTARI(TarID,"P",TarSub),"^",5)			/// 价格
	...s h=h+1
	...s tempstr=ATLRowID_"^"_ItemDr_"^"_TarID_"^"_TarCode_"^"_TarDesc_"^"_TarQty_"^"_Price_"^"_StaDate_"^"_StaTime_"^"_EndDate_"^"_EndTime_"^"_UpdUserName_"^"_UpdDate_"^"_UpdTime
	...s ^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTarByItmID",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 		// 输出json结尾符
	
	///转换数据为Json格式
	s title="ATLRowID^ItemDr^TarID^TarCode^TarDesc^TarQty^Price^StaDate^StaTime^EndDate^EndTime^UpdUserName^UpdDate^UpdTime" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTarByItmID",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTarByItmID",pid,index))
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

/// Creator：      sufan
/// CreatDate：    2017-09-27
/// Description：  保存病理收费项目字典表
/// Table：        DHC_AppTestLinkTar
/// Input：		   收费项表ID^检测项目ID^收费项ID^收费项数量^开始日期^结束日期^更新用户
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestLinkTar).SaveTestTar("^1^3^1^24/02/2018^^1")
ClassMethod SaveTestTar(params As %String) As %String
{
	n (params)
	s Err=0
	TS
	s Len=$l(params,"$$")
	for i=1:1:Len  d
	.s ListData=$p(params,"$$",i)
	.s Err=..CompareTime(ListData)   	/// 判断日期
	.q:Err'=0
	.i $p(ListData,"^",1)'=""  q:Err'=0  d
	..s Err=..UpdateTestTar(ListData)   /// 更新
	.e  d
	..s Err=..InsertTestTar(ListData)   /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2017-09-27
/// Description：  保存病理收费项目字典表
/// Table：        DHC_AppTestLinkTar
/// Input：		   收费项表ID^检测项目ID^收费项ID^收费项数量^开始日期^结束日期^更新用户
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestLinkTar).InsertTestTar("^1^3^1^24/02/2018^^1")
ClassMethod InsertTestTar(ListData As %String) As %String
{
	n (ListData)
	s ItemDr=$p(ListData,"^",2)			/// 检测项目ID
	s TarID=$p(ListData,"^",3)			/// 收费项ID
	s TarQty=$p(ListData,"^",4)			/// 数量
	s StaDate=$p(ListData,"^",5)		/// 开始日期
	s StaDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(StaDate)   //$zdh(StaDate,3)
	s EndDate=$p(ListData,"^",6)		/// 结束日期
	i EndDate="" s EndDate="" 
	e  s EndDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(EndDate)	 //$zdh(EndDate,3)
	s UpdUser=$p(ListData,"^",7)		/// 更新用户ID
	s UpdDate=+$h						/// 更新日期
	s UpdTime=$p($h,",",2)				/// 更新时间
	&SQL(Insert into DHC_AppTestLinkTar (ATL_Itm_Dr,ATL_Tar_Dr,ATL_StartDate,ATL_EndDate,ATL_UpdUser_Dr,ATL_UpdDate,ATL_UpdTime,ATL_Qty) values 
	(:ItemDr,:TarID,:StaDate,:EndDate,:UpdUser,:UpdDate,:UpdTime,:TarQty))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-09-27
/// Description：  更新病理收费项目字典表
/// Table：        DHC_AppTestLinkTar
/// Input：		   收费项表ID^检测项目ID^收费项ID^收费项数量^开始日期^结束日期^更新用户
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestLinkTar).UpdateTestTar("3^5^3^3^2017-09-27^^2874")
ClassMethod UpdateTestTar(ListData As %String) As %String
{
	n (ListData)
	s ATLRowID=$p(ListData,"^",1)		/// 表ID	
	s ItemDr=$p(ListData,"^",2)			/// 检测项目ID
	s TarID=$p(ListData,"^",3)			/// 收费项ID
	s TarQty=$p(ListData,"^",4)			/// 数量
	s StaDate=$p(ListData,"^",5)		/// 开始日期
	s StaDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(StaDate) //$zdh(StaDate,3)
	s EndDate=$p(ListData,"^",6)		/// 结束日期
	i EndDate="" s EndDate="" 
	e  s EndDate=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(EndDate)  //$zdh(EndDate,3)
	s UpdUser=$p(ListData,"^",7)		/// 更新用户ID
	s UpdDate=+$h						/// 更新日期
	s UpdTime=$p($h,",",2)				/// 更新时间
	&SQL(Update DHC_AppTestLinkTar Set ATL_Itm_Dr=:ItemDr,ATL_Tar_Dr=:TarID,ATL_StartDate=:StaDate,ATL_EndDate=:EndDate,ATL_UpdUser_Dr=:UpdUser,ATL_UpdDate=:UpdDate,ATL_UpdTime=:UpdTime,ATL_Qty=:TarQty Where ATL_RowID =:ATLRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-09-27
/// Description：  删除病理收费项目字典表
/// Table：        DHC_AppTestLinkTar
/// Input：		   表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestLinkTar).DelTestTar()
ClassMethod DelTestTar(ATLRowID As %String) As %String
{
	n (ATLRowID)
	&sql(delete from DHC_AppTestLinkTar where ATL_RowID=:ATLRowID)
	q SQLCODE
}

/// Creator:     qunianpeng
/// CreateDate:  2017-09-27
/// Description: 检测项目与收费项关联[检查结束时间是否大于开始时间]
/// Table:		 DHC_AppTestLinkTar
/// Return: 	 是 0,否 非0
/// Others:		 w ##class(web.DHCAPPTestLinkTar).CompareTime("^^^^^^2016-08-08^2016-01-05^")
ClassMethod CompareTime(str)
{
	
	s TarStart=$p(str,"^",5)
	s TarEnd=$p(str,"^",6)
	s flag=0	
	s:TarStart'="" TarStart=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart)   		//$zdh(TarStart,3)
	s:(TarEnd'="")&(TarEnd'=0) TarEnd=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd)   //$zdh(TarEnd,3)
	s:(TarEnd>0)&(TarStart>TarEnd) flag=-11
	i TarStart<+$h  d   					//结束日期不能早于今天的判断
	.s:(TarEnd>0)&(TarEnd<+$h) flag=-12
	q flag
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTestItem",pid)
	k ^TMP("DHCAPP","web.DHCAPPTestLinkTar","QueryTarByItmID",pid)
}

}
