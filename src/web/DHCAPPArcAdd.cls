Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2017-02-07
/// Descript:    医嘱项维护类
Class web.DHCAPPArcAdd Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2017-02-07
/// Description：  检查医嘱项保存
/// Table：        User.DHCAppArcAdd,User.ARCItmMast
/// input:		   ArcDesc : 医嘱项
/// Others：       w ##class(web.DHCAPPArcAdd).QueryExaArc(10,1,"")
ClassMethod QueryExaArc(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s Code=$p(params,"^",1)
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s AraRowId=0
	f  s AraRowId=$o(^DHCAPPARA(AraRowId)) q:AraRowId=""  d  //查询表DHC_AppArcCat
	.s ArcDr=$p(^DHCAPPARA(AraRowId),"^",1)
	.s ArcimSub=$p(ArcDr,"||",1)
	.s ArcimVer=$p(ArcDr,"||",2)
	.s AraArcDesc=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	.s AraArcCode=$p(^ARCIM(ArcimSub,ArcimVer,1),"^",1)
	.q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcDr,HospID)="N"
	.q:$p(^DHCAPPARA(AraRowId),"^",5)'=HospID
	.s ExecCode=$p(^DHCAPPARA(AraRowId),"^",2)
	.s ExecFlag=ExecCode
	.s ExecFlag=$s(ExecFlag="Y":"是",ExecFlag="N":"否",1:"")
	.s TarCode=$p(^DHCAPPARA(AraRowId),"^",3)
	.s TarFlag=TarCode
	.s TarFlag=$s(TarFlag="Y":"是",TarFlag="N":"否",1:"")
	.s ReqCode=$p(^DHCAPPARA(AraRowId),"^",4)
	.s ReqFlag=ReqCode
	.s ReqFlag=$s(ReqFlag="Y":"是",ReqFlag="N":"否",1:"")
	.q:(Code'="")&(AraArcCode'[Code)
	.q:(Desc'="")&(AraArcDesc'[Desc)
	.s h=h+1
	.s tempstr=AraRowId_"^"_ArcDr_"^"_AraArcCode_"^"_AraArcDesc_"^"_ExecCode_"^"_ExecFlag_"^"_TarCode_"^"_TarFlag_"^"_ReqCode_"^"_ReqFlag
	.s ^TMP("DHCST","web.DHCAPPArcAdd","QueryExaArc",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="AraRowId^ArcDr^AraArcCode^AraArcDesc^ExecCode^ExecFlag^TarCode^TarFlag^ReqCode^ReqFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArcAdd","QueryExaArc",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPArcAdd","QueryExaArc",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2017-02-07
/// Description：  检查医嘱项保存
/// Table：        User.DHCAppArcAdd
/// input:		   待保存数据串，分割符："^".多个串，以&&分割
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCAPPArcAdd).SaveExaArc()
ClassMethod SaveExaArc(params As %String) As %String
{
	n (params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdArcAdd(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsertArcAdd(tmpstr)   /// 插入数据
	q Err
}

/// Descript: 保存数据
/// Others  : w ##class(web.DHCAPPArcAdd).InsertArcAdd() 
ClassMethod InsertArcAdd(ListData As %String) As %String
{
	n (ListData)
	s ArcDr=$p(ListData,"^",2)			/// 医嘱项Id
	q:$d(^DHCAPPARA(0,"Arc",ArcDr)) -1
	s ExecFlag=$p(ListData,"^",4)   	/// 是否按部位生成执行记录标志
	s TarFlag=$p(ListData,"^",5)		/// 是否按部位生成收费记录标志
	s ReqFlag=$p(ListData,"^",6)		/// 是否自动产生申请
	s HospID=$p(ListData,"^",7)
	&sql(insert into DHC_AppArcAdd (ARA_Arc_Dr,ARA_ExecFlag,ARA_TarFlag,ARA_AutoReqFlag,ARA_Hospital) values (:ArcDr,:ExecFlag,:TarFlag,:ReqFlag,:HospID) )
	q SQLCODE
}

/// Descript: 更新数据
/// Others  : w ##class(web.DHCAPPArcAdd).UpdArcAdd() 
ClassMethod UpdArcAdd(ListData As %String) As %String
{
	n (ListData)
	s AraRowId=$p(ListData,"^",1)		/// RowId
	s ArcId=$p(^DHCAPPARA(AraRowId),"^",1)
	s ArcDr=$p(ListData,"^",2)			/// 医嘱项Id
	i ArcId'=ArcDr  q:$d(^DHCAPPARA(0,"Arc",ArcDr)) -1
	s ExecFlag=$p(ListData,"^",4)   	/// 是否按部位生成执行记录标志
	s TarFlag=$p(ListData,"^",5)		/// 是否按部位生成收费记录标志
	s ReqFlag=$p(ListData,"^",6)		/// 是否自动产生申请
	s HospID=$p(ListData,"^",7)
	&sql(update DHC_AppArcAdd set ARA_Arc_Dr=:ArcDr,ARA_ExecFlag=:ExecFlag,ARA_TarFlag=:TarFlag,ARA_AutoReqFlag=:ReqFlag, ARA_Hospital=:HospID where ARA_RowID=:AraRowId)
	q SQLCODE
}

/// Descript: 删除
/// Others  : w ##class(web.DHCAPPArcAdd).UpdArcAdd()
ClassMethod DeleteArcAdd(AraRowId As %String) As %String
{
	n (AraRowId)
	&sql(delete from DHC_AppArcAdd where ARA_RowID=:AraRowId)
	q SQLCODE
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCAPPArcAdd","QueryExaArc",pid)
}

}
