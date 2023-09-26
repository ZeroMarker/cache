Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-05-10
/// Descript: 	检查申请医嘱项模板
Class web.DHCAppArcTemp Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 保存检查申请记录
/// w ##Class(web.DHCAppArcTemp).saveArcTemp("^^4_row_1","PS_11^PS_12^AC_9474||1^PO_1^DM_2")
ClassMethod saveArcTemp(mListData As %String, arListData As %String) As %String
{
	n (mListData, arListData)
	s ret=##Class(web.DHCAppArcTemp).CheckIfExist(arListData)
	Q:ret'=0 "-1"
	s Err = 0
	TS
	/// 医嘱项目
	s Err=..Insert(mListData,arListData)
	i Err'=0 tro
	q:Err'=0 "-11"
	TC
	Q 0
}

/// Descript: 插入检查申请记录
ClassMethod Insert(mListData As %String, arListData As %String) As %String
{
	N (mListData, arListData)
	
	s Err=0

	/// 医嘱项,体位
	s arArcListData=..GetInsArcListData(arListData,"AC_PO")  /// 获取医嘱项,体位
	s arArcTempID=..InsArcTemp(mListData,arArcListData)
	q:arArcTempID<0 arArcTempID
	
	/// 部位
	s arPartListData=..GetInsArcListData(arListData,"PS")  /// 获取部位
	s Err=..InsArcTempPart(arArcTempID,arPartListData)
	q:Err'=0 "-12"
	
	/// 后处理
	s arDispListData=..GetInsArcListData(arListData,"DM")  /// 获取后处理方法
	s Err=..InsArcTempDisp(arArcTempID,arDispListData)
	q:Err'=0 "-13"

	Q 0
}

/// Descript:  准备插入数据
ClassMethod GetInsArcListData(arListData As %String, arType As %String) As %String
{
	n (arListData, arType)
	q:arListData="" ""
	s retListData=""
	s Len = $L(arListData,"^")
	f i=1:1:Len d
	.s ItemLabel = $p(arListData,"^",i)
	.s LabelRowId = $p(ItemLabel,"_",2)
	.i arType [ $p(ItemLabel,"_",1) d
	..s retListData = $s(retListData'="":retListData_"^"_LabelRowId,1:LabelRowId)
	Q retListData
}

/// Descript: 检查医嘱项模版表
ClassMethod InsArcTemp(mListData As %String, ListData As %String) As %String
{
	n (mListData, ListData)
	
	s arSaveFor=$p(mListData,"^",1)       ///保存模式
	s arPointerID=$p(mListData,"^",2)     ///指针
	s arArcCatID=$p(mListData,"^",3)      ///检查分类id
	
	s arItmmastID=$p(ListData,"^",1)     ///医嘱项ID
	s arPosiID=$p(ListData,"^",2)        ///体位

	&SQL(Insert Into DHC_AppArcTemp(ATE_SaveFor,ATE_Pointer,ATE_Cat_Dr,ATE_Arc_Dr,ATE_Pos_Dr)
		values(:arSaveFor,:arPointerID,:arArcCatID,:arItmmastID,:arPosiID))
	i SQLCODE'=0  q SQLCODE
	q $p(%ROWID,$C(1))
}

/// Descript: 检查报告医嘱项对应部位记录表
ClassMethod InsArcTempPart(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,"^")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s arPartID=$p(ListData,"^",i)     ///部位
	.s arChildSub=$o(^DHCAPATE(+arParref,"P",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppArcTempPart(ATP_ParRef_Dr,ATP_ChildSub,ATP_Part_Dr)
		values(:arParref,:arChildSub,:arPartID))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 检查报告检查后处理表
ClassMethod InsArcTempDisp(arParref As %String, ListData As %String) As %String
{
	n (arParref, ListData)
	s Len = $L(ListData,"^")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s arDispID=$p(ListData,"^",i)     ///部位
	.s arChildSub=$o(^DHCAPATE(+arParref,"D",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppArcTempDisp(ATD_ParRef_Dr,ATD_ChildSub,ATD_Disp_Dr)
		values(:arParref,:arChildSub,:arDispID))
	.i SQLCODE'=0 S quitflag="1"
	.
	q quitflag
}

/// Descript: 删除检查报告模板
ClassMethod delArcTemp(arcTempID As %String) As %String
{
	n (arcTempID)
	&SQL(delete DHC_AppArcTemp Where ATE_Rowid=:arcTempID)
	Q SQLCODE
}

/// Descript: 检查是否存在相同的模板
/// w ##Class(web.DHCAppArcTemp).CheckIfExist("PS_11^PS_12^AC_9471||1^PO_1^DM_1^DM_2")
ClassMethod CheckIfExist(arListData As %String) As %String
{
	n (arListData)
	
	/// 医嘱项,体位
	s arArcListData=..GetInsArcListData(arListData,"AC_PO")  /// 获取医嘱项,体位
	s itmmastid=$p(arArcListData,"^",1)  /// 医嘱项
	s arcPosiID=$p(arArcListData,"^",2)  /// 医嘱项
	Q:'$d(^DHCAPATE(0,"Arc",itmmastid)) 0
	
	s quitflag=0,sameflag=0
	s arcTempID=""
	f  s arcTempID=$o(^DHCAPATE(0,"Arc",itmmastid,arcTempID)) Q:arcTempID=""  D
	.s PosiID=$p(^DHCAPATE(arcTempID),"^",5)  /// 体位
	.Q:arcPosiID'=PosiID
	.
	.///部位
	.s arPartListData=..GetInsArcListData(arListData,"PS")  /// 获取部位
	.s Len=$L(arPartListData,"^")
	.s InStrArrList=$LISTFROMSTRING(arPartListData,"^")
	.i arPartListData="" s Len=0
	.s num=0
	.s Sub=""
	.f  s Sub=$o(^DHCAPATE(arcTempID,"P",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPATE(arcTempID,"P",Sub),"^",1) ///部位ID
	..Q:PartID=""
	..s num=num+1
    ..Q:$lf(InStrArrList,PartID)'=0
	..s quitflag=1
	..
	.Q:quitflag=1
	.Q:Len'=num
	.
	./// 后处理
	.s arDispListData=..GetInsArcListData(arListData,"DM")  /// 获取后处理方法
	.s Len=$L(arDispListData,"^")
	.s InStrArrList=$LISTFROMSTRING(arDispListData,"^")
	.i arDispListData="" s Len=0
	.s num=0
	.s Sub=""
	.f  s Sub=$o(^DHCAPATE(arcTempID,"D",Sub)) Q:Sub=""  D
	..s DispMID=$p(^DHCAPATE(arcTempID,"D",Sub),"^",1) ///后处理ID
	..Q:DispMID=""
	..s num=num+1
    ..Q:$lf(InStrArrList,DispMID)'=0
	..s quitflag=1
	..
	.Q:quitflag=1
	.Q:Len'=num
	.s sameflag=1
	
	Q:sameflag=1 "-2"
	Q 0
}

}
