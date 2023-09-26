Import SQLUSER

Class web.DHCAPPTreeAdd Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  保存检查分类表和检查分类和医嘱项关联表
/// Table：        DHC_AppTreeAdd,DHC_AppTreeLink
/// Input:         "TraID","TraCode^TraDesc^TraLastLevID^HospID^^$$^TreeLinkID^PartID^ItmmastID^StartDate^EndDate"
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTreeAdd).Save("","AB^AB^0^2^ab^$$^^^2016-7-31^")
ClassMethod Save(TraID As %String, ListData As %String) As %String
{
	n (TraID, ListData)
	s Err = 0
	s Err=..CheckItmCatord(TraID,ListData)     		 ///判断检查分类是否在同一个大分类下存在
	Q:Err'=0 Err
	i TraID="" s TraID=..GetLevTraID(ListData)       ///获取当前检查分类的id
	Q:TraID<0 TraID
	s sListData=$p(ListData,"$$",2)
	i TraID'="" s Err=..isExistPart(TraID,sListData)  ///判断是否存在子部位
	Q:Err'=0 Err
	s PartID=$p(sListData,"^",2)
	s ItmmastID=$p(sListData,"^",3)
	if TraID'="" d 
	.if PartID'="" d
	..s Err=..CheckItmRep(TraID, PartID, ItmmastID)  ///部位不为空，判断分类+部位+医嘱项
	.e  d
	..s Err=..CheckItm(TraID, ItmmastID)             ///部位为空，判断分类+医嘱项
    q:Err'=0 "-9"    

	TS
	i TraID="" d
	.s Err=..Insert(ListData)                        ///插入检查分类表
	e  d
	.s Err=..InsTreeLink(TraID,sListData)      		 ///插入检查分类与医嘱项关联表
	i Err'=0 tro
	q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  插入检查分类表和检查分类与医嘱项关联表
/// Table：        DHC_AppTreeAdd,DHC_AppTreeLink
/// Input：        "TraCode^TraDesc^TraLastLevID^HospID^$$TreeLinkID^PartID^ItmmastID^StartDate^EndDate"
/// Output：       0:成功 ,其他:失败
ClassMethod Insert(ListData As %String) As %String
{
	n (ListData)
	
	s Err=0
	/// 检查分类
	s mListData = $p(ListData,"$$",1)       ///取插入检查分类表的串  
	s TraID=..InsTree(mListData)
	i TraID<0 tro
	q:TraID<0 TraID
	
	///检查分类与医嘱项关联
	s sListData = $p(ListData,"$$",2)       ///取插入检查分类医医嘱项关联表的串
	s Err=..InsTreeLink(TraID,sListData)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	q 0
}

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  更新检查分类表
/// Table：        DHC_AppTreeAdd,DHC_AppTreeLink
/// Input：        "TraID","TraCode^TraDesc^TraLastLevID^HospID^$$^TreeLinkID^PartID^ItmmastID^StartDate^EndDate"
/// Output：       0:成功 ,其他:失败
ClassMethod Update(TraID As %String, ListData As %String) As %String
{
	n (TraID, ListData)
	s Err=0
	/// 检查分类
	s mListData = $p(ListData,"$$",1)
	s TraID=..UpdTree(TraID,mListData)	
	q 0
}

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  插入检查分类表
/// Table：        DHC_AppTreeAdd
/// Input:         "TraCode^TraDesc^TraLastLevID^HospID^TraAlias"
/// others：      w ##Class(web.DHCAPPTreeAdd).InsTree("AB^AB^426^2^ab^$$^^^2016-7-31^")
ClassMethod InsTree(ListData As %String) As %String
{
	n (ListData)
	s mListData=$p(ListData,"$$",1)
	s TraCode=$p(mListData,"^",1)                //分类代码
	s TraDesc=$p(mListData,"^",2)                //分类描述
	s TraLastLevID=$p(mListData,"^",3)           //上级ID
	s HospID=$p(mListData,"^",4)                 //医院id
	s OrdNum=..GetMaxOrdNum(TraLastLevID)        //序号
	s TraAlias=$p(mListData,"^",5)
	&sql(insert into DHC_AppTreeAdd (TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_OrdNum,TRA_Alias)
	  values (:TraCode,:TraDesc,:TraLastLevID,:HospID,:OrdNum,:TraAlias))
 	q +%ROWID
}

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  插入检查分类与医嘱项关联表
/// Table：        DHC_AppTreeLink
/// Input:         "TraID","TreeLinkID^PartID^ItmmastID^StartDate^EndDate"
/// Output：       0:成功 ,其他:失败
/// Others：	   w ##class(web.DHCAPPTreeAdd).InsTreeLink(38,"^2^31||1^2016-7-19^")
ClassMethod InsTreeLink(TraID As %String, sListData As %String) As %String
{
	n (TraID, sListData)
    s PartID=$p(sListData,"^",2)
    s ItmmastID=$p(sListData,"^",3)             ///获取医嘱项id
    Q:ItmmastID="" 0 
    s StartDate=$p(sListData,"^",4)             ///获取开始日期
    s:StartDate'="" StartDate=$zdh(StartDate,3)  
    s EndDate=$p(sListData,"^",5)               ///获取截止日期
    s:EndDate'="" EndDate=$zdh(EndDate,3)
    s OrdNum=..GetMaxOrdsubNum(TraID)
	s ChildSub=$o(^DHCAPPTRA(TraID,"I",""),-1)+1
	&sql(insert into DHC_AppTreeLink(TRA_Add_ParRef,TRA_ChildSub,TRA_Part_Dr,TRA_Arc_Dr,TRA_StDate,TRA_EndDate,TRA_OrdNum) 
		values(:TraID,:ChildSub,:PartID,:ItmmastID,:StartDate,:EndDate,:OrdNum))
    q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  更新检查分类表
/// Table：        DHC_AppTreeAdd
/// Input:          "TraID","TraCode^TraDesc^TraLastLevID^HospID"
/// Output：       0:成功 ,其他:失败
ClassMethod UpdTree(TraID As %String, mListData As %String) As %String
{
	n (TraID, mListData)
	s TraCode=$p(mListData,"^",1)              //分类代码
	s TraDesc=$p(mListData,"^",2)              //分类描述
	q:$d(^DHCAPPTRA(0,"Code",TraDesc)) TraID   //判断检查分类是否存在，若存在，返回检查分类ID
	s HospID=$p(mListData,"^",4)               //医院id
	&sql(update DHC_AppTreeAdd set TRA_Code=:TraCode,TRA_Desc=:TraDesc,TRA_Hosp_Dr=:HospID where TRA_RowID=:TraID)
	q +%ROWID     //返回特殊字符
}

/// Creator：      sufan
/// CreatDate：    2016-07-26
/// Description：  保存分类更新
/// Table：        DHC_AppTreeAdd
/// Input:         "TraID","TraCode^TraDesc"
/// Output：       0:成功 ,其他:失败
/// Others:        w ##class(web.DHCAPPTreeAdd).SaveType(222,"头部^头部^213")
ClassMethod SaveType(TraID As %String, ListData As %String) As %String
{
	n (TraID, ListData)
	Q:..isExistSameItemalias(TraID,ListData) "-2"    /// 判断是否存在相同的分类
	s Err=0
	s Err=..UpdType(TraID,ListData)
	q:Err'=0 Err
	q Err
}

/// Creator：      sufan
/// CreatDate：    2016-07-26
/// Description：  更新分类
/// Table：        DHC_AppTreeAdd
/// Input:         "TraID","TraCode^TraDesc"
/// Output：       0:成功 ,其他:失败
/// Others:        w ##class(web.DHCAPPTreeAdd).UpdType(205,"CT平扫^CT平扫")
ClassMethod UpdType(TraID As %String, ListData As %String) As %String
{
    
    s mListData=$p(ListData,"$$",1)
	s TraCode=$p(mListData,"^",1) 		//分类描述
	s TraDesc=$p(mListData,"^",2)   	//分类名称
	s Traalias=$p(mListData,"^",5)          
	&sql(update DHC_AppTreeAdd set TRA_Code=:TraCode,TRA_Desc=:TraDesc ,TRA_Alias=:Traalias where TRA_RowID=:TraID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-15
/// Description：  更新检查分类树关联医嘱项
/// Table：        DHC_AppTreeLink
/// Input：        "TraID","TraItmID^PartID^ItmmastID^StartDate^EndDate"
/// Output：       0:成功 ,其他:失败
ClassMethod UpdTreeLink(TraID As %String, sListData As %String) As %String
{
	n (TraID,sListData)
	s TraItmID=$p(sListData,"^",1)             ///获取部位id
    s PartID=$p(sListData,"^",2)               ///获取部位id
    q:PartID="" 0
    s ItmmastID=$p(sListData,"^",3)            ///获取医嘱项id
    s StartDate=$p(sListData,"^",4)            ///获取开始日期
    s StartDate=$zdh(StartDate,3)     
    s EndDate=$p(sListData,"^",5)              ///获取截止日期
    s EndDate=$zdh(EndDate,3)
	&sql(update DHC_AppTreeLink set TRA_Part_Dr=:PartID,TRA_Arc_Dr=:ItmmastID,TRA_StDate=:StartDate,TRA_EndDate=:EndDate where TRA_RowID=:TraItmID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-16
/// Description：  删除分类
/// Table：        DHC_AppTreeAdd
/// Input:         检查分类id
/// Output：       0:成功 ,其他:失败
/// w ##class(web.DHCAPPTreeAdd).Delete(74)
ClassMethod Delete(Id As %String) As %String
{
	n (Id)
	s Err=0
	i $l(Id,"^")>1 d
	.s TraItmID=$p(Id,"^",1)
	.s Err= ..DelTreeLink(TraItmID)
	e  d
	.s TraID=$p(Id,"||",1)
	.s lastId=$p(^DHCAPPTRA(TraID),"^",4)
	.s oldordnum=$p(^DHCAPPTRA(TraID),"^",6)
	.s Err= ..DelTreeAdd(TraID)
	.i Err=0 d
	..s Err= ..ReorderMain(lastId,oldordnum)
	q Err
}

ClassMethod DelTreeAdd(TraID As %String) As %String
{
	n (TraID)
	s Err=..GetTraTreeNextNode(TraID)
	&sql(delete from DHC_AppTreeAdd where TRA_RowID=:TraID)													
	q Err
}

/// 删除所有的分类节点
/// Descript: W ##Class(web.DHCAPPTreeAdd).GetTraTreeNextNode(15)
ClassMethod GetTraTreeNextNode(LastTraID As %String) As %String
{
	n (LastTraID)
	s Err=0
	s TraID=$o(^DHCAPPTRA(0,"LastRowid",LastTraID,""))
	q:TraID="" 0
	
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",LastTraID,TraID)) Q:(TraID="")||(Err'=0)  D
	.s Err=..GetTraTreeNextNode(TraID)
	.q:Err'=0
	.s Err=..DelTraAddTree(TraID)
	.
	Q Err
}

/// 删除后重新排序主表
/// w ##class(web.DHCAPPTreeAdd).GetNewNum(47)
ClassMethod ReorderMain(lastId, oldordnum)
{
	s traId=""
	f  s traId=$o(^DHCAPPTRA(0,"LastRowid",lastId,traId)) q:traId=""  d
	.s ordnum=$p(^DHCAPPTRA(traId),"^",6)
	.i ordnum>oldordnum d
	..s newordnum=ordnum-1
	..s:newordnum<1 newordnum=1
	.. &sql(update DHC_AppTreeAdd set TRA_OrdNum=:newordnum where TRA_RowID=:traId)
	q Err
}

ClassMethod DelTraAddTree(TraID As %String) As %String
{
	n (TraID)
	&SQL(delete from DHC_AppTreeAdd where TRA_RowID=:TraID)
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-16
/// Description：  删除医嘱项
/// Table：        DHC_AppTreeLink
/// Input：        检查分类与医嘱项关联表id
/// Output：       0:成功 ,其他:失败
ClassMethod DelTreeLink(version As %String, TraItmID As %String) As %String
{
	n (version, TraItmID)
	Q:..isArcExistPart(version,TraItmID)'=0 "-1"
	&sql(delete from DHC_AppTreeLink where TRA_RowID=:TraItmID)
	q SQLCODE
}

/// Descript: 是否存在相同的子部位
/// Input：   检查分类id，子部位id
/// Output：  1 存在 0 不存在
/// others：  w ##class(web.DHCAPPTreeAdd).isExistCurNote(93,3)
ClassMethod isExistCurNote(TraID As %String, PartID As %String) As %String
{
	n (TraID, PartID)
	q:$d(^DHCAPPTRA(0,"Part",PartID,TraID)) 1     ///判断子部位是否存在
	q 0
}

/// Descript: 判断在同一分类中是否存在相同的分类节点
/// Input:    "TraID","TraCode^TraDesc^TraLastLevID^HospID"
/// Output:   1 存在 0 不存在
/// others：  w ##class(web.DHCAPPTreeAdd).isExistSameItem("422","AB^AB^422||3^2^2$$^2^388||1^2016-7-31^")
ClassMethod isExistSameItem(TraID As %String, ListData As %String) As %String
{
	n (TraID, ListData)
	s retflag=0
	s LastLevID=$p(^DHCAPPTRA(TraID),"^",4)      ///上级ID
	s itemDesc=$p(ListData,"^",2)                ///分类描述
	s ID="" 
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID)) q:(ID="")||(retflag=1)  d
	.s ItemCat=$p(^DHCAPPTRA(ID),"^",2)          ///通过遍历获取分类描述
	.Q:ItemCat'=itemDesc
	.s retflag=1
	Q retflag
}

/// /descript: 判断更新时分类与别名,如果分类相同时，只更新别名
ClassMethod isExistSameItemalias(TraID As %String, ListData As %String) As %String
{
	n (TraID, ListData)
	s retflag=0
	s LastLevID=$p(^DHCAPPTRA(TraID),"^",4)      ///上级ID
	s itemDesc=$p(ListData,"^",2)                ///分类描述
	s alias=$p(ListData,"^",5)
	s ID="" 
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID)) q:(ID="")||(retflag=1)  d
	.s ItemCat=$p(^DHCAPPTRA(ID),"^",2)          ///通过遍历获取分类描述
	.s Traalias=$p(^DHCAPPTRA(ID),"^",7)
	.i ((ItemCat=itemDesc)&(Traalias'=alias)) d
	..s retflag=0
	.e  d
	..Q:ItemCat'=itemDesc
	..s retflag=1
	Q retflag
}

/// Descript: 如果检查分类的上一级不同，则可以插入相同的分类
/// Input：   "TraID","TraCode^TraDesc^TraLastLevID^HospID^$$^TreeLinkID^PartID^ItmmastID^StartDate^EndDate"
/// Output:   -1 存在  0 不存在
/// Others:   w ##class(web.DHCAPPTreeAdd).CheckItmCatord("","RR^RR^391^2$$^^^2016-7-31^")
ClassMethod CheckItmCatord(TraID As %String, ListData As %String) As %String
{
	n (TraID, ListData)
	s ItemCatDesc=$p(ListData,"^",2)     /// 分类描述
	s LastLevID=$p(ListData,"^",3)       /// 上级ID
	s sListData=$p(ListData,"$$",2)
	s ItmmastID=$p(sListData,"^",3)      /// 医嘱项id
	Q:ItmmastID'="" 0 
	s mainId=""                          /// 主表id
	s retflag=0
	s ID="" 
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID)) q:(ID="")||(retflag=-1)  d
	.s ItemCat=$p(^DHCAPPTRA(ID),"^",2)
	.Q:ItemCat'=ItemCatDesc
	.s retflag=-1
	Q:retflag'=0 retflag
	s CH=$o(^DHCAPPTRA(LastLevID,"I",""))
	Q:CH'="" "-2"
	Q retflag
}

/// Descript: 同一级别是否存在其它的节点
/// Input:    上一级的id
/// Output:   1 存在 0 不存在
ClassMethod isExistNextNode(LastLevID As %String) As %String
{
	n (LastLevID)
	Q:$D(^DHCAPPTRA(0,"LastRowid",LastLevID)) 1    /// 判断相同的分类下，是否存在平级的节点
	Q 0
}

/// Descript:获取子部位树
/// w ##class(web.DHCAPPTreeAdd).getTreeCombo()
ClassMethod getTreeCombo()
{

	  w "["
	  s partid="",count=0
	  f  s partid=$o(^DHCAPPART(0,"Parref",0,partid)) q:partid=""  d
	  .i count>0 d
	  ..w ","
	  .w "{"
	  .w """id"":"_partid_","
	  .w """text"":"""_$p(^DHCAPPART(partid),"^",2)_""""
	  .d ..getTreeComboChilden(partid)
	  .w "}"
	  .s count=count+1
	  w "]"
	  q ""
}

/// 递归调用
ClassMethod getTreeComboChilden(id)
{
	n (id)
	s sub=$o(^DHCAPPART(0,"Parref",id,""))
	q:+sub=0
	s subId="",i=0
	w ",""children"":["
	f  s subId=$o(^DHCAPPART(0,"Parref",id,subId)) q:subId=""  d
	.
	.i i>0 d
    ..w ","
	.w "{"
    .w """id"":"_subId_","
    .w """text"":"""_$p(^DHCAPPART(subId),"^",2)_""""
    .d ..getTreeComboChilden(subId)
    .w "}"
    .s i=i+1
	w "]"
}

/// Creator：      sufan
/// CreatDate：    2016-07-16
/// Description：  医嘱项列表
/// Table：        ARC_ItmMast     
/// Others：       w ##Class(web.DHCAPPTreeAdd).QueryCheckItemList("30","1","68||1")
ClassMethod QueryCheckItemList(rows As %String, page As %String, TraItmID As %String) As %String
{
	n (rows, page, TraItmID)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s TraID=$p(TraItmID,"||",1)  /// 主表ID
    s PartID=$p(TraItmID,"^",2)  /// 部位ID
	s h=0,count=0
	s CH=""
	//f  s CH=$o(^DHCAPPTRA(0,"Part",PartID,TraID,CH)) q:CH=""  d
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:CH=""  d
	.s itempartid=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)    //部位
	.Q:(PartID'="")&(itempartid'=PartID)
	.s itempartdesc=$p($g(^DHCAPPART(+itempartid)),"^",2)   //部位描述
	.s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
	.s ordnum=+$p(^DHCAPPTRA(TraID,"I",CH),"^",5)
	.s data=arcimid_"^"_ordnum
	.s h=h+1
	.s index=ordnum
	.s ^TMP("DHCST","web.DHCAPPTreeAdd","QueryCheckItemList",pid,TraID,"I",index,CH)=data
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 
	
	///转换数据为Json格式
	s ListTitle="TraItmID^ItemID^ItemCode^ItemDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h)       //输出json前缀串
	s index=""
	s CH=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPTreeAdd","QueryCheckItemList",pid,TraID,"I",index))  q:index=""  d
	.f  s CH=$o(^TMP("DHCST","web.DHCAPPTreeAdd","QueryCheckItemList",pid,TraID,"I",index,CH))  q:CH=""  d
	..s arcimid=$p(^TMP("DHCST","web.DHCAPPTreeAdd","QueryCheckItemList",pid,TraID,"I",index,CH),"^",1)
	..s ordnum=$p(^TMP("DHCST","web.DHCAPPTreeAdd","QueryCheckItemList",pid,TraID,"I",index,CH),"^",2)
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)    //医嘱项代码
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)    //医嘱项名称
	..s h=h+1
	..s ListData=TraID_"||"_CH_"^"_arcimid_"^"_arcitmcode_"^"_arcitmdesc
	..s count = count+1
	..q:(count<Start)||(count>End)
	..i count=Start d
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-07-18
/// Description：  保存检查分类表和检查分类和医嘱项关联表
/// Table：        DHC_AppTreeAdd,DHC_AppTreeLink
/// Input:         检查分类id,变量flag
/// Output：       0:成功 ,其他:失败   
/// Others：       w ##class(web.DHCAPPTreeAdd).Move("63",1)
ClassMethod Move(Id, Flag)
{
	i $l(Id,"^")>1 d                        //移动检查分类子表
	.s TraitmId=$p(Id,"^",1)
	.s TraID=$p(TraitmId,"||",1)               
	.s childsub=$p(TraitmId,"||",2)
	.s ordnum=$p(^DHCAPPTRA(TraID,"I",childsub),"^",5)
	.s newnum=ordnum+Flag
	.s:newnum<1 newnum=1
	.s:ordnum<1 ordnum=1
	.s:newnum=..GetMaxOrdsubNum(TraID) newnum=(..GetMaxOrdsubNum(TraID)-1)
	.s CH=..Getchildsub(TraID,newnum)
	.s TraItmID=TraID_"||"_CH
	.  &sql(update DHC_AppTreeLink set TRA_OrdNum=:ordnum where TRA_RowID=:TraItmID)
	.  &sql(update DHC_AppTreeLink set TRA_OrdNum=:newnum where TRA_RowID=:TraitmId)
	e  d
	.s TraID=Id                                       //移动DHC_AppTreeAdd
	.s lastid=$p(^DHCAPPTRA(+TraID),"^",4)
	.s ordnum=$p(^DHCAPPTRA(+TraID),"^",6)
	.s newnum=ordnum+Flag
	.s:newnum<1 newnum=1
	.s:ordnum<1 ordnum=1
	.s index=""
	.s flag=0
	.f  s index=$o(^DHCAPPTRA(0,"OrdNum",newnum,index)) q:(index="")||(flag=1)  d
	..s lastindex=$p(^DHCAPPTRA(+index),"^",4)
	..q:(lastindex'=lastid)
	..	&sql(update DHC_AppTreeAdd set TRA_OrdNum=:ordnum where TRA_RowID=:index)
	..	&sql(update DHC_AppTreeAdd set TRA_OrdNum=:newnum where TRA_RowID=:TraID)
	..s flag=1
	q 0
}

/// w ##class(web.DHCAPPTreeAdd).Getchildsub(13,1)
ClassMethod Getchildsub(traId, newnum)
{
	n (traId,newnum)
	s CH=""
	s child=""
	f  s CH=$o(^DHCAPPTRA(traId,"I",CH)) q:CH=""  d
	.s ordnum=$p(^DHCAPPTRA(traId,"I",CH),"^",5)
	.q:ordnum'=newnum
	.s child=CH
	q child
}

/// 移动医嘱项
/// w ##class(web.DHCAPPTreeAdd).MoveItmmast("54||2","false","54||3")
ClassMethod MoveItmmast(Id, isUp, nextId)
{
	s traId=$p(Id,"||",1)
	s nexttraId=$p(nextId,"||",1)
	s child=$p(Id,"||",2)
	s childsub=$p(nextId,"||",2)
	q:child=childsub
	s ordnum=$p(^DHCAPPTRA(traId,"I",child),"^",5)
	s nextordnum=$p(^DHCAPPTRA(nexttraId,"I",childsub),"^",5)
	i ordnum=nextordnum d
	.i isUp="true" d
	..s ordnum=ordnum+1
	.e  d
	..s nextordnum=nextordnum+1
	&sql(update DHC_AppTreeLink set TRA_OrdNum=:ordnum where TRA_RowID=:nextId)
	&sql(update DHC_AppTreeLink set TRA_OrdNum=:nextordnum where TRA_RowID=:Id)
	q 0
}

/// Descript： 获取序号
/// input:     上一级的id
/// Other:     w ##class(web.DHCAPPTreeAdd).GetMaxOrdNum(59)
ClassMethod GetMaxOrdNum(Lastlevid As %String) As %String
{
	s maxnum=0
	i +Lastlevid=0  d
	.s TraID=""
	.f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,TraID)) q:TraID=""  d
	..s ordnum=$p(^DHCAPPTRA(+TraID),"^",6)
	..i ordnum>maxnum s maxnum=ordnum
	e  d
	.s TraID="" 
	.f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,TraID)) q:TraID=""  d
	..s ordnum=$p(^DHCAPPTRA(+TraID),"^",6)
	..i ordnum>maxnum s maxnum=ordnum
	s maxnum=maxnum+1
	q maxnum
}

/// 子表
/// w ##class(web.DHCAPPTreeAdd).GetMaxOrdsubNum(13)
ClassMethod GetMaxOrdsubNum(TraID As %String) As %String
{
	n (TraID)
	s maxnum=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH))  q:CH=""  d
	.s ordnum=$p(^DHCAPPTRA(TraID,"I",CH),"^",5)
	.i ordnum>maxnum s maxnum=ordnum
	s maxnum=maxnum+1
	q maxnum
}

/// Creator：      sufan
/// CreatDate：    2016-07-19
/// Description：  医嘱项别名检索
/// Table：        ARC_ItmMast ARC_Alias     
/// Others：       w ##Class(web.DHCAPPTreeAdd).QueryArcItmDetail("100","1","wss",1,"")
ClassMethod QueryArcItmDetail(rows As %String, page As %String, Input As %String, HospID As %String, q = "") As %String
{
	n (rows, page, Input , HospID, q,%session)
	if HospID="" s HospID=$g(%session.Data("LOGON.HOSPID"))
	i q'="" s Input=q
	i Input="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Input="" ""
	s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr ="select distinct alias_arcim_dr from arc_alias "_
    	"where %ALPHAUP(alias_text) like '"_Input_"' or  %ALPHAUP(ALIAS_Desc) like '"_Input_"'" 
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    if $$$ISERR(sc) d DisplayError^%apiOBJ(sc) q ""
    
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	d ..killTmpGlobal(pid)
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
    s Num = 0
    while(result.Next()){
	    s arcitemId = result.Data("ALIAS_ARCIM_DR")
	    continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcitemId,HospID)="N"
	    //s HosipitalStr=##class(web.DHCDocOrderEntry).ArcimCanUserHosipital(arcitemId)
		//continue:("^"_HosipitalStr_"^")'[("^"_HospID_"^") 
	    s itmmastid=$p(arcitemId,"||",1)
	    s itmmastver=$p(arcitemId,"||",2)
	    continue:+itmmastver=0
        continue:'$d(^ARCIM(itmmastid,itmmastver))
        s arcEndDate=$p(^ARCIM(itmmastid,itmmastver,7),"^",1)  //sufan 2018-11-21 判断医嘱是否可用
		continue:(arcEndDate'="")&&(arcEndDate'>+$H)
		s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
		s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
		s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcitemId,+$h,"","","","",HospID)
		s arcitmprice=+$p(arcitmprice,"^") 					//医嘱项价格
		i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice  //小于0的价格前补0
		s ServerMaterial=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",6)
		//continue:(ServerMaterial'="Service")&(ServerMaterial'="S")
        s ListData = arcitemId_"^"_arcitmcode_"^"_arcitmdesc_"^"_arcitmprice
        s Num=Num+1
		s ^TMP("DHCST","web.DHCAppTreeAdd","QueryArcItmDetail",pid,Num)=ListData
    }
  	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0" ""

	s maxrow=Num
	i EndPage>maxrow S EndPage=maxrow
	
	s ListTitle="itmID^itmCode^itmDesc^itmPrice"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num)        //输出json前缀串

	s quitflag=0
	s Num=0
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAppTreeAdd","QueryArcItmDetail",pid,index)) q:(index="")||(quitflag=1)  d
	.s ListData=^TMP("DHCST","web.DHCAppTreeAdd","QueryArcItmDetail",pid,index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.else  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign()             //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:判断能否连续保存医嘱项 
/// Input:   ItemCatCode^ItemCatDesc^LastLevID^^$$^^ItmmastID 
/// Others： w ##class(web.DHCAPPTreeAdd).GetLevTraID("^肩部^327^^$$^^329||4")
ClassMethod GetLevTraID(ListData) As %String
{
	n (ListData)
	s ItemCatDesc=$p(ListData,"^",2)     /// 检查分类名称
	s LastLevID=+$p(ListData,"^",3)       /// 上级ID
	s sListData=$p(ListData,"$$",2)
	s ItmmastID=$p(sListData,"^",3)
	Q:ItmmastID="" ""
	s TraID=""
	s ID="" 
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID)) q:ID=""  d
	.s ItemCat=$p(^DHCAPPTRA(ID),"^",2) /// 获取检查分类名称
	.Q:ItemCat'=ItemCatDesc             /// 如果不等于当前的分类名称，退出
	.s TraID=ID
	
	Q:TraID'="" TraID
	Q:LastLevID=0 ""
	Q:$p(^DHCAPPTRA(LastLevID),"^",2)=ItemCatDesc LastLevID
	s CH=$o(^DHCAPPTRA(LastLevID,"I",""))
	Q:CH'="" "-2"
	
	Q TraID
}

/// descript: 分类和医嘱项都存在的情况下，不允许添加子部位
/// input:    "TraID","TreeLinkID^PartID^ItmmastID^StartDate^EndDate"
ClassMethod isExistPart(TraID As %String, sListData As %String)
{
	n (TraID,sListData)
	s PartID=$p(sListData,"^",2)          // 遍历子表childsub
	s CH=$o(^DHCAPPTRA(TraID,"I",""))
	Q:CH="" 0
	s TPartID=+$p(^DHCAPPTRA(TraID,"I",CH),"^",1)     // 获取部位id
	Q:(TPartID=0)&(PartID'="") "-4"
	Q:(TPartID'=0)&(PartID="") "-5"
	Q 0
}

/// Descript：判断医嘱项是否重复
/// Input：   检查分类id,子部位id,医嘱项id
/// others：  w ##class(web.DHCAPPTreeAdd).check(422,3,"31||1")
ClassMethod CheckItmRep(TraID, PartID, ItmmastID) As %String
{
	s ret=0
	q:'$d(^DHCAPPTRA(0,"Part",PartID)) 0
	s child=""
	f  s child=$o(^DHCAPPTRA(0,"Part",PartID,TraID,child)) q:(child="")||(ret=1)  d    ///用索引遍历
	.s Arcdr=$p(^DHCAPPTRA(TraID,"I",child),"^",2)  
	.q:Arcdr'=ItmmastID
	.s ret=1	
	q ret
}

/// Descript：不存在子部位的情况下,判断医嘱项是否重复
/// others：  w ##Class(web.DHCAPPTreeAdd).CheckItm(240,"416||1")
ClassMethod CheckItm(TraID, ItmmastID) As %String
{
	s ret=0
	s child=""
	f  s child=$o(^DHCAPPTRA(0,"Arc",ItmmastID,TraID,child)) q:(child="")||(ret=1)  d    ///用索引遍历
	.s Arcdr=$p(^DHCAPPTRA(TraID,"I",child),"^",2)
	.q:Arcdr'=ItmmastID
	.s ret=1	
	q ret
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCAPPTreeAdd","QueryCheckItemList",pid)
	k ^TMP("DHCST","web.DHCAPPTreeAdd","List",pid)
	k ^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid)
}

/// Descript: 以节点获取检查分类树
/// w ##class(web.DHCAPPTreeAdd).jsonCheckCatByNodeID(8)
ClassMethod jsonCheckCatByNodeID(id) As %String
{
	n (id)
	s count=0
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	w "["
	s count=0
	s lastrowid=""
	f  s lastrowid=$o(^DHCAPPTRA(0,"LastRowid",lastrowid))  q:lastrowid=""  d
	.q:lastrowid<0
	.s ID=""
  	.f  s ID=$o(^DHCAPPTRA(0,"LastRowid",lastrowid,ID)) q:ID=""  d
	..s desc=$p(^DHCAPPTRA(ID),"^",2)
  	..s ordnum=+$p(^DHCAPPTRA(ID),"^",6)
	..s data=ID_"^"_desc_"^"_ordnum
  	..s index=ordnum
  	..s ^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,lastrowid,index,ID)=data
  	..s CH=""
  	..f  s CH=$o(^DHCAPPTRA(ID,"I",CH)) q:CH=""  d
	...s PartID=$p(^DHCAPPTRA(ID,"I",CH),"^",1)
  	...s ordnum=+$p(^DHCAPPTRA(ID,"I",CH),"^",5)
	...s str=PartID_"^"_ordnum
  	...s indexsub=ordnum
  	...s ^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,ID,"I",indexsub,CH)=str
	
	
	s index=""
  	f  s index=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,id,index))  q:index=""  d
  	.s ID=0
    .f  s ID=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,id,index,ID))  q:ID=""   d
  	..s Text=$p(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,id,index,ID),"^",2)
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..s TraID=$o(^DHCAPPTRA(0,"LastRowid",ID,""))
	..i TraID'="" D
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	..i TraID="" d ..GetCheckTreeLeafNote(ID,pid)   ///是否有叶子节点
	..w "}"
	w "]"
  	q ""
}

/// Descript:  检查分类树
/// w ##class(web.DHCAPPTreeAdd).CheckClassifyTree() 
ClassMethod CheckClassifyTree() As %String
{
	s count=0
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()
	w "["
	s count=0
	s lastrowid=""
	f  s lastrowid=$o(^DHCAPPTRA(0,"LastRowid",lastrowid))  q:lastrowid=""  d
	.q:lastrowid<0
	.s ID=""
  	.f  s ID=$o(^DHCAPPTRA(0,"LastRowid",lastrowid,ID)) q:ID=""  d
	..s desc=$p(^DHCAPPTRA(ID),"^",2)
  	..s ordnum=+$p(^DHCAPPTRA(ID),"^",6)
	..s data=ID_"^"_desc_"^"_ordnum
  	..s index=ordnum
  	..s ^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,lastrowid,index,ID)=data
  	..s CH=""
  	..f  s CH=$o(^DHCAPPTRA(ID,"I",CH)) q:CH=""  d
	...s PartID=$p(^DHCAPPTRA(ID,"I",CH),"^",1)
  	...s ordnum=+$p(^DHCAPPTRA(ID,"I",CH),"^",5)
	...s str=PartID_"^"_ordnum
  	...s indexsub=ordnum
  	...s ^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,ID,"I",indexsub,CH)=str
  	

 	s index=""
  	f  s index=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,0,index))  q:index=""  d
  	.s ID=""
    .f  s ID=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,0,index,ID))  q:ID=""   d
  	..s Text=$p(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,0,index,ID),"^",2)
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..d ..GetCheckTreeChilden(ID,pid)
	..w "}"
	w "]"
  	q ""
}

///  Descript:	检查分类树孩子节点处理
ClassMethod GetCheckTreeChilden(patlev, pid) As %String
{
	n (patlev,pid)
	s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,""))
	i ID="" d ..GetCheckTreeLeafNote(patlev,pid) ///是否有叶子节点
	Q:ID="" ""
	s count=0	
	s lev=patlev+1
	///  有孩子节点的初始化时收缩
	w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
    s index=""
  	f  s index=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,patlev,index))  q:index=""  d
  	.s ID=""
    .f  s ID=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,patlev,index,ID))  q:ID=""   d
	..s Text=$p(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,patlev,index,ID),"^",2)
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..d ..GetCheckTreeChilden(ID,pid)
	..w "}"
	w "]"
	Q ""
}

/// Descript:  获取叶子节点
/// w ##class(web.DHCAppTreeAdd).GetCheckTreeLeafNote(475,8784)
ClassMethod GetCheckTreeLeafNote(TraID, pid) As %String
{
	n (TraID,pid)
	k TreeLeafNote
	///  是否存在孩子节点
	//s CH=$o(^DHCAPPTRA(TraID,"I",""))
	//Q:CH="" ""
	Q:'..isExistChildNote(TraID,pid) ""
	s count=0
	///  有孩子节点的初始化时收缩
	w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	w ",""children"":["
	s indexsub=""
	f  s indexsub=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,TraID,"I",indexsub))  q:indexsub=""  d
	.s CH=""
	.f  s CH=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,TraID,"I",indexsub,CH)) q:CH=""  d
	..s PartID=+$p(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,TraID,"I",indexsub,CH),"^",1)
	..Q:PartID=0
	..Q:'$D(^DHCAPPART(PartID))
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	..Q:$D(TreeLeafNote(PartID))
	..s TreeLeafNote(PartID)=PartDesc
	..s TraItmID=TraID_"||"_CH_"^"_PartID
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraItmID,PartDesc)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraItmID,PartDesc)
	..w "}"
	w "]"
	Q ""
}

/// Descript: 是否有孩子节点
ClassMethod isExistChildNote(TraID As %String, pid As %String) As %String
{
	n (TraID,pid)
	s QuitFlag=0
	s indexsub=""
	f  s indexsub=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,TraID,"I",indexsub))  q:indexsub=""  d
	.s CH=""
	.f  s CH=$o(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,TraID,"I",indexsub,CH)) Q:(CH="")||(QuitFlag=1)  d
	..s PartID=+$p(^TMP("DHCST","web.DHCAPPTreeAdd","CheckClassifyTree",pid,TraID,"I",indexsub,CH),"^",1)
	..Q:PartID=0
	..s QuitFlag=1
	Q QuitFlag
}

/// w ##class(web.DHCAPPTreeAdd).FindAlias(54)
ClassMethod FindAlias(TraID)
{
	n (TraID)
	s alias=$p(^DHCAPPTRA(TraID),"^",7)         
	s tempstr=alias
	q tempstr
}

/// Descript: 保存分类关联医嘱
/// w ##Class(web.DHCAPPTreeAdd).SaveTraTreeLink("7036^5417||1^")
ClassMethod SaveTraTreeLink(version As %String, params As %String) As %String
{
	n (version, params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s mListData=$p(params,"&&",i)
	.s Err=##Class(web.DHCAPPTreeAdd).isExistSameItm(mListData)
	.Q:Err'=0
	.i $p(mListData,"^",4)="" D
	..s Err=..InsTraTreeLink(mListData)
	.E  D
	..s Err=##Class(web.DHCAPPTreeAdd).isExistSubPart(version,mListData)
	..Q:Err'=0
	..s Err=..UpdTraTreeLink(mListData)
	Q Err
}

/// Descript: 更新分类关联医嘱
/// w ##Class(web.DHCAPPTreeAdd).UpdTreeLink("6884^^8618")
ClassMethod UpdTraTreeLink(mListData As %String) As %String
{
	n (mListData)
	s TraItmID=$p(mListData,"^",4)         /// ID
	s ItmmastID=$p(mListData,"^",2)        /// 医嘱项ID
	s PartID=$p(mListData,"^",3)           /// 部位ID
	s ToothFlag=$p(mListData,"^",5) 
	&sql(update DHC_AppTreeLink set TRA_Part_Dr=:PartID,TRA_Arc_Dr=:ItmmastID,TRA_ToothFlag=:ToothFlag where TRA_RowID=:TraItmID)
	q SQLCODE
}

/// Descript: 保存分类关联医嘱
/// w ##Class(web.DHCAPPTreeAdd).InsTraTreeLink("6884^^8618")
ClassMethod InsTraTreeLink(mListData As %String) As %String
{
	n (mListData)
	s TraID=$p(mListData,"^",1)            /// 主表ID
	s ItmmastID=$p(mListData,"^",2)        /// 医嘱项ID
	s PartID=$p(mListData,"^",3)           /// 部位ID
    s OrdNum=..GetMaxOrdsubNum(TraID)
	s ChildSub=$o(^DHCAPPTRA(TraID,"I",""),-1)+1
	s ToothFlag=$p(mListData,"^",5) 
	&sql(insert into DHC_AppTreeLink(TRA_Add_ParRef,TRA_ChildSub,TRA_Part_Dr,TRA_Arc_Dr,TRA_OrdNum,TRA_ToothFlag) 
		values(:TraID,:ChildSub,:PartID,:ItmmastID,:OrdNum,:ToothFlag))
    Q SQLCODE
}

/// Descript: 保存分类树
/// w ##Class(web.DHCAPPTreeAdd).InsTraTreeAdd("bianshuai^bianshuai^0^^65")
ClassMethod InsTraTreeAdd(mListData As %String) As %String
{
	n (mListData)
	s TraCode=$p(mListData,"^",1)       // 分类代码
	s TraDesc=$p(mListData,"^",2)       // 分类描述
	s TraLastLevID=$p(mListData,"^",3)  // 上级ID
	s TraAlias=$p(mListData,"^",4)      // 别名
	s HospID=$p(mListData,"^",5)        // 医院id
	s ItemType=$p(mListData,"^",6)      // 检查类型
	Q:##Class(web.DHCAPPTreeAdd).isExistCurItem(TraLastLevID,mListData) "-1"
	s OrdNum=..GetMaxOrdNum(TraLastLevID)        //序号
	&sql(insert into DHC_AppTreeAdd (TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_OrdNum,TRA_Alias,TRA_Type)
	  values (:TraCode,:TraDesc,:TraLastLevID,:HospID,:OrdNum,:TraAlias,:ItemType))
 	Q SQLCODE
}

/// Description：  更新检查分类表
/// w ##Class(web.DHCAPPTreeAdd).UpdTraTreeAdd("")
ClassMethod UpdTraTreeAdd(TraID As %String, mListData As %String) As %String
{
	n (TraID, mListData)
	s TraCode=$p(mListData,"^",1)              //分类代码
	s TraDesc=$p(mListData,"^",2)              //分类描述
	s TraAlias=$p(mListData,"^",3)             //别名
	s TraItmType=$p(mListData,"^",4)		   //类型
	&sql(update DHC_AppTreeAdd set TRA_Code=:TraCode,TRA_Desc=:TraDesc,TRA_Alias=:TraAlias,TRA_Type=:TraItmType where TRA_RowID=:TraID)
	Q SQLCODE
}

/// Description：  获取项目别名
/// w ##Class(web.DHCAPPTreeAdd).GetTreeCatAlias("更新检查分类表")
ClassMethod GetTreeCatAlias(ItemDesc As %String) As %String
{
	n (ItemDesc)
	s PyCode=##class(web.DHCST.Common.AppCommon).GetCNCODE(ItemDesc)
	Q PyCode
}

/// Description：  获取上级目录ID列表
/// w ##Class(web.DHCAppTreeAdd).GetTarILevCon("6884")
ClassMethod GetTarILevCon(TraID As %String) As %String
{
	n (TraID)
	s LastTraID=$p(^DHCAPPTRA(TraID),"^",4)  /// 上一级ID
	Q:LastTraID=0 TraID
	
	s ListTraID=..GetTarILevCon(LastTraID)
	Q ListTraID_"^"_TraID
}

/// Description： 同级别目录是否存在相同项目
/// w ##Class(web.DHCAPPTreeAdd).isExistCurItem("0","bianshuai")
ClassMethod isExistCurItem(LastLevID As %String, ListData As %String) As %String
{
	n (LastLevID, ListData)
	s retflag=0
	s itemDesc=$p(ListData,"^",2)                ///分类描述
	s HospID=$p(ListData,"^",5)                  ///医院id
	s ID="" 
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID)) q:(ID="")||(retflag=1)  d
	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
	.s TraCatDesc=$p(^DHCAPPTRA(ID),"^",2)          ///通过遍历获取分类描述
	.Q:itemDesc'=TraCatDesc
	.s retflag=1
	Q retflag
}

/// Description： 是否允许添加下一项目
/// w ##class(web.DHCAPPTreeAdd).isAllowAddPartItem(4,"")
ClassMethod isAllowAddPartItem(TraID As %String, AddType As %String) As %String
{
	n (TraID, AddType, %session)
	s version=##Class(web.DHCAPPExaReportQuery).GetConfigBySession("Version")
	/// 是否存在下级分类
	Q:$d(^DHCAPPTRA(0,"LastRowid",TraID)) 0
	/// 是否存在对应医嘱项目
	s ret=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) Q:(CH="")||(ret=1)  D
	.s Part=+$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.s:(Part'=0)&&(version=1) ret=1
	Q:ret=1 0
	Q 1
}

/// Description： 是否允许添加下一项目
ClassMethod isAllowAddCatItem(TraID As %String, AddType As %String) As %String
{
	n (TraID, AddType)
	s CH=$o(^DHCAPPTRA(TraID,"I",""))
	Q:CH="" 0
	Q 1
}

/// Creator:    bianshuai
/// CreateDate: 2016-12-20
/// Descript：  删除检查申请分类
/// W ##Class(web.DHCAPPTreeAdd).delTraTreeAdd("")
ClassMethod delTraTreeAdd(TraID As %String) As %String
{
	n (TraID)
	s Err=0
	TS
	s Err=##Class(web.DHCAPPTreeAdd).DelTreeAdd(TraID)
	i Err'=0 Tro
	Q:Err'=0 "-1"
	TC
	Q 0
}

/// Description： 检查方法是否维护了相同项目
/// w ##Class(web.DHCAPPTreeAdd).isExistSameItm("6884^11207||1^")
ClassMethod isExistSameItm(mListData As %String) As %String
{
	n (mListData)
	s TraID=$p(mListData,"^",1)            /// 主表ID
	s itmmastid=$p(mListData,"^",2)        /// 医嘱项ID
	s IPartID=$p(mListData,"^",3)          /// 部位ID
	s TraItmID=$p(mListData,"^",4)
	s retflag=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) Q:(CH="")||(retflag=-1)  D
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.q:TraItmID=(TraID_"||"_CH)
	.Q:(IPartID'="")&(IPartID'=PartID)
	.q:(IPartID="")&(PartID'="")
	.s retflag=-1
	Q retflag
}

/// Description： 检查方法进行删除或更新操作时，判断是否存在对应部位
/// w ##Class(web.DHCAPPTreeAdd).isExistSubPart("1","6884^247||1^^6884||22")
ClassMethod isExistSubPart(version As %String, mListData As %String) As %String
{
	n (version, mListData)
	s TraID=$p(mListData,"^",1)        /// 主表ID
	s IPartID=$p(mListData,"^",3)      /// 部位ID
	s TraItmID=$p(mListData,"^",4)     /// 分类树ID
	s Mitmmastid=$p(mListData,"^",2)        /// 医嘱项ID
	s itmmastid=$p(^DHCAPPTRA(+TraItmID,"I",$p(TraItmID,"||",2)),"^",2)
	s retflag=0
	i ((version = 1)&&(Mitmmastid'=itmmastid)) D
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) Q:(CH="")||(retflag=-2)  D
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:PartID=""
	..s retflag=-2
	Q retflag
}

ClassMethod isExistSubPartSame(version As %String, mListData As %String) As %String
{
	n (version, mListData)
	s TraID=$p(mListData,"^",1)        /// 主表ID
	s IPartID=$p(mListData,"^",3)      /// 部位ID
	s TraItmID=$p(mListData,"^",4)     /// 分类树ID
	s Mitmmastid=$p(mListData,"^",2)        /// 医嘱项ID
	s itmmastid=$p(^DHCAPPTRA(+TraItmID,"I",$p(TraItmID,"||",2)),"^",2)
	s retflag=0
	i ((version = 1)) D
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) Q:(CH="")||(retflag=-2)  D
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:PartID=""
	..s retflag=-2
	Q retflag
}

/// Descript: 保存分类关联医嘱
/// w ##Class(web.DHCAPPTreeAdd).insTreeLink("7036^5417||1^")
ClassMethod insPartTreeLink(params As %String) As %String
{
	n ( params)
  	s Err=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s mListData=$p(params,"&&",i)
	.s Err=##Class(web.DHCAPPTreeAdd).isExistSameItm(mListData)
	.Q:Err'=0
	.i $p(mListData,"^",4)="" D
	..s Err=..InsTraTreeLink(mListData)
	.E  D
	..s Err=..UpdTraTreeLink(mListData)
	Q Err
}

/// Description： 医嘱项目是否存在子部位
/// w ##Class(web.DHCAPPTreeAdd).isArcExistPart("1","")
ClassMethod isArcExistPart(version As %String, TraItmID As %String) As %String
{
	n (version, TraItmID)
	s retflag=0
	Q:version'=1 0
	s TraID=+TraItmID
	s itmmastid=$p(^DHCAPPTRA(TraID,"I",$p(TraItmID,"||",2)),"^",2)
	s CH=""
	f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) Q:(CH="")||(retflag=-1)  D
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:PartID=""
	.s retflag=-1
	Q retflag
}

/// Descript: 获取检查分类树别名
/// w ##Class(web.DHCAPPTreeAdd).GetTreeAlise("1")
ClassMethod GetTreeAlise(TraID As %String) As %String
{
	n (TraID)
	Q:TraID="" ""
	Q:'$d(^DHCAPPTRA(TraID)) ""
	s TraAlias=$p(^DHCAPPTRA(TraID),"^",7)		/// 分类别名
	Q TraAlias
}

/// Descript:  更新检查分类树关联医嘱项顺序号
/// Others  : w ##class(web.DHCAPPTreeAdd).moveTreeLink("21^19^20^21) 
ClassMethod moveTreeLink(mListData As %String) As %String
{
	n (mListData)
	s ^tempqujian("moveTreeLink")=mListData
	s TrsID=$p(mListData,"^",1)
	s TrsOrdNum=+$p(^DHCAPPTRA(+TrsID,"I",$p(TrsID,"||",2)),"^",5)
	i TrsOrdNum=0 s TrsOrdNum=$p(TrsID,"||",2)
	s LastID=$p(mListData,"^",2)
	s LastOrdNum=+$p(^DHCAPPTRA(+LastID,"I",$p(LastID,"||",2)),"^",5)
	i LastOrdNum=0 s LastOrdNum=$p(LastID,"||",2)
	TS
	&sql(update DHC_AppTreeLink set TRA_OrdNum=:LastOrdNum where TRA_RowID=:TrsID)
	i SQLCODE'=0 tro
	Q:SQLCODE'=0 -1
	&sql(update DHC_AppTreeLink set TRA_OrdNum=:TrsOrdNum where TRA_RowID=:LastID)
	i SQLCODE'=0 tro
	Q:SQLCODE'=0 -2
	TC
	Q 0
}

/// Descript:  更新检查分类树顺序号
/// Others  : w ##class(web.DHCAPPTreeAdd).moveTree("3^4") 
ClassMethod moveTree(mListData As %String) As %String
{
	n (mListData)
	s ^tempqujian("moveTree")=mListData
	s TrsID=$p(mListData,"^",1)
	s TrsOrdNum=$p(^DHCAPPTRA(TrsID),"^",6)    /// 顺序号
	s LastID=$p(mListData,"^",2)
	s LastOrdNum=$p(^DHCAPPTRA(LastID),"^",6)  /// 顺序号
	Q:$p(^DHCAPPTRA(TrsID),"^",4)'=$p(^DHCAPPTRA(LastID),"^",4) "-1"
	TS
	&sql(update DHC_AppTreeAdd set TRA_OrdNum=:LastOrdNum where TRA_RowID=:TrsID)
	i SQLCODE'=0 tro
	Q:SQLCODE'=0 -2
	&sql(update DHC_AppTreeAdd set TRA_OrdNum=:TrsOrdNum where TRA_RowID=:LastID)
	i SQLCODE'=0 tro
	Q:SQLCODE'=0 -3
	TC
	Q 0
}

/// Others  : w ##class(web.DHCAPPTreeAdd).moveTreeNew("14^12^bottom") 
ClassMethod moveTreeNew(mListData As %String) As %String
{
	n (mListData)
	s ^tempqujian("moveTree")=mListData
	s TrsID=$p(mListData,"^",1)
	s TrsOrdNum=$p(^DHCAPPTRA(TrsID),"^",6)    /// 顺序号
	s LastID=$p(mListData,"^",2)
	s LastOrdNum=$p(^DHCAPPTRA(LastID),"^",6)  /// 顺序号
	Q:$p(^DHCAPPTRA(TrsID),"^",4)'=$p(^DHCAPPTRA(LastID),"^",4) "-1"
	s Type=$p(mListData,"^",3)
	if (Type="top"){
		&sql(update DHC_AppTreeAdd set TRA_OrdNum=:TrsOrdNum where TRA_RowID=:LastID)
		i SQLCODE'=0 tro
		s Trsid="0"
		for {
			s Trsid=$o(^DHCAPPTRA(Trsid))
			q:Trsid=""
			continue:$p(^DHCAPPTRA(TrsID),"^",4)'=$p(^DHCAPPTRA(Trsid),"^",4)
			continue:LastID=Trsid
			s OrdNum=$p(^DHCAPPTRA(Trsid),"^",6)
			if (OrdNum>=TrsOrdNum){
				s OrdNum=OrdNum+1
				&sql(update DHC_AppTreeAdd set TRA_OrdNum=:OrdNum where TRA_RowID=:Trsid)
				}
			}
	}else{
		&sql(update DHC_AppTreeAdd set TRA_OrdNum=:TrsOrdNum where TRA_RowID=:LastID)
		i SQLCODE'=0 tro
		s Trsid="0"
		for {
			s Trsid=$o(^DHCAPPTRA(Trsid))
			q:Trsid=""
			continue:$p(^DHCAPPTRA(TrsID),"^",4)'=$p(^DHCAPPTRA(Trsid),"^",4)
			continue:LastID=Trsid
			s OrdNum=$p(^DHCAPPTRA(Trsid),"^",6)
			b ;0932323
			if (OrdNum<=TrsOrdNum){
				s OrdNum=OrdNum-1
				&sql(update DHC_AppTreeAdd set TRA_OrdNum=:OrdNum where TRA_RowID=:Trsid)
				}
			}
		}
	Q 0
}

ClassMethod SaveTreeconfigloc(Type, Treeid, LocStr, HospId)
{
	s HospCodeNode="HospDr_"_HospId
	s NoteOne=Type_"_"_Treeid
	d ##class(DHCDoc.DHCApp.BasicConfig).SaveConfig1(HospCodeNode,NoteOne,LocStr)
	q 0
}

ClassMethod ShowTreeconfigloc(Type, Treeid, HospId)
{
	s NoteOne=Type_"_"_Treeid
	q ##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode(NoteOne,HospId)
}

/// 出参1 成功 0失败
ClassMethod CheckTreeConfigloc(Type, Treeid, HospId, LocID)
{
	s ^tempqujian("CheckTreeConfigloc")=$lb(Type, Treeid, HospId, LocID)
	if (Type="")||(Treeid="")||(HospId="")||(LocID="") q 1
 	s NoteOne=Type_"_"_Treeid
	s rtn=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode(NoteOne,HospId)
	if rtn="" q 1
	if (("^"_rtn_"^")[("^"_LocID_"^")){
		 q 1
	}else{
		q 0
		}
}

}
