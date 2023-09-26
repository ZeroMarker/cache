Import SQLUser

Class web.DHCAPPPart Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 保存或者新增部位字典维护
/// Table：        DHC_AppOtherOpt
/// Input：	      APCode：代码
///               APDesc：描述
///               APActiveFlag：是否使用
///               APParPDr：父部位id
///               ID：部位表rowid
/// Return：       保存成功 0，其他 失败
ClassMethod saveOrUpdate(str)
{
 s APDesc=$p(str,"^",1)
 s APCode=$p(str,"^",2)
 s APParPDr=$p(str,"^",3)
 s APActiveFlag=$p(str,"^",4)
 s ID=$p(str,"^",5)
 s APPartNum=$p(str,"^",6)
 s APOrdNum=$p(str,"^",7)
 //Q:..isrepeat(APParPDr,APDesc) -10
 //Q:..isRepeatPartCode(APParPDr,APCode) -11 //部位代码已重复，并且保存失败
 Q:..isExist(str) -10   /// 重复性判断
 s PartAlias=##Class(web.DHCAPPTreeAdd).GetTreeCatAlias(APDesc) /// 获取拼音别名

 i +ID=0 d
 .s obj=##class(User.DHCAppPart).%New()
 .s tmppart="",count=0
 .f  s tmppart=$o(^DHCAPPART(0,"Parref",APParPDr,tmppart)) q:tmppart=""  d
 ..s count=count+1
 ..s obj.APOrdNum=count
 
 e  d
 .s obj=##class(User.DHCAppPart).%OpenId(ID)
 .d obj.%Reload()
 s obj.APActiveFlag=APActiveFlag
 s obj.APCode=APCode
 s obj.APDesc=APDesc
 s obj.APAlias=PartAlias

 //combotree
 i ($a(APParPDr)>=48)&&($a(APParPDr)<=71) d
 .s obj.APParPDr=+APParPDr
 s obj.APHospDr=##class(User.CTHospital).%OpenId(%session.Get("LOGON.HOSPID"))

 s obj.APPartNum=APPartNum
 s sc=obj.%Save()
 i $$$ISERR(sc) q -2
 q 0
}

/// Creator：      zhouxin
/// CreatDate：    2016-04-12
/// Description:： 批量保存或者修改部位字典表
/// Table：        DHC_AppOtherOpt
/// Input：	       部位描述^部位代码^使用状态^部位表ID$$部位描述^部位代码^使用状态^部位表ID
/// Return：       保存成功 0，其他 失败
ClassMethod save(params)
{
  
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..saveOrUpdate(str)
	i ret<0 TRollback
	q:ret<0 ret
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// d ##class(web.DHCAPPPart).move()
ClassMethod move(Id, isUp, nextId)
{
	
	q:+Id=0 0
	q:+nextId=0 0
	s lastId=+$p(^DHCAPPART(Id),"^",3)
	s nextLastId=+$p(^DHCAPPART(nextId),"^",3)
	q:lastId'=nextLastId 0
	s curordnum=+$p(^DHCAPPART(Id),"^",8)
	s curnextordnum=+$p(^DHCAPPART(nextId),"^",8)
	s:curnextordnum<1 curnextordnum=1
	s:curordnum<1 curordnum=1 
	i curordnum=curnextordnum d
	.i isUp="true" d
	..s curordnum=curordnum+1
	.e  d
	..s curnextordnum=curnextordnum+1
	;s $p(^DHCAPPART(Id),"^",8)=curnextordnum   ///sufan  2017-02-04  修改为更新表中的数据，左侧的树需要按顺序输出
	;s $p(^DHCAPPART(nextId),"^",8)=curordnum
	&sql(update DHC_AppPart set AP_Ordnum=:curnextordnum where AP_RowId=:Id)
	&sql(update DHC_AppPart set AP_Ordnum=:curordnum where AP_RowId=:nextId)
	q 0
}

/// d ##class(web.DHCAPPPart).getTreeCombo()
ClassMethod getTreeCombo()
{

  w "["
  s partid=0,count=0
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

/// d ##class(web.DHCAPPPart).getTreeComboNew()
ClassMethod getTreeComboNew()
{

  w "["
  w "{"
  w """id"":"_"0"_","
  w """text"":"""_"父节点"_""""
  w "}"
  s partid=0,count=0
  f  s partid=$o(^DHCAPPART(0,"Parref",0,partid)) q:partid=""  d
  .i count>0 d
  .w ","
  .w "{"
  .w """id"":"_partid_","
  .w """text"":"""_$p(^DHCAPPART(partid),"^",2)_""""
  .d ..getTreeComboChilden(partid)
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

// 递归调用

ClassMethod getTreeComboChilden(id)
{
	n (id)
	s subId=$o(^DHCAPPART(0,"Parref",id,""))
	q:+subId=0
	s subId="",i=0
	w ",""children"":["
	f  s subId=$o(^DHCAPPART(0,"Parref",id,subId)) q:subId=""  d
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

/// d ##class(web.DHCAPPPart).listTreeGrid()
ClassMethod listTreeGrid()
{
  
  w "["
  s partid=0,count=0
  f  s partid=$o(^DHCAPPART(0,"Parref",0,partid)) q:partid=""  d
  .i count>0 d
  ..w ","
  .w "{"
  .w """ID"":"_partid_","
  .w """APCode"":"""_$p(^DHCAPPART(partid),"^",1)_""","
  .w """APDesc"":"""_$p(^DHCAPPART(partid),"^",2)_""","
  .w """APLevel"":"""_$p(^DHCAPPART(partid),"^",4)_""","
  .w """APActiveFlag"":"""_$p(^DHCAPPART(partid),"^",5)_""""
  .d ..listChildren(partid)
  .w "}"
  .s count=count+1
  w "]"
  q ""
}

ClassMethod listChildren(id)
{
  

    s subId=$o(^DHCAPPART(0,"Parref",id,""))
	q:+subId=0
	s subId="",i=0
	w ",""children"":["
	f  s subId=$o(^DHCAPPART(0,"Parref",id,subId)) q:subId=""  d
	.i i>0 d
    ..w ","
	.w "{"
    .w """ID"":"_subId_","
    .w """APCode"":"""_$p(^DHCAPPART(subId),"^",1)_""","
    .w """APDesc"":"""_$p(^DHCAPPART(subId),"^",2)_""","
    .w """APLevel"":"""_$p(^DHCAPPART(subId),"^",4)_""","
    .w """APActiveFlag"":"""_$p(^DHCAPPART(subId),"^",5)_""""
    .d ..listChildren(subId)
    .w "}"
    .s i=i+1
	w "]"
}

/// d ##class(web.DHCAPPPart).list()
ClassMethod list(parentId = "", rootflag = "")
{
  
  s pid=##class(web.DHCAPPExaRepCom).NewPid()
  k ^TMP("DHCST","web.DHCAPPPart","list",pid)
 
  s partId=0
  f  s partId=$o(^DHCAPPART(partId)) q:partId=""  d
  .q:+partId=0
  .s lastid=$p(^DHCAPPART(partId),"^",3)
  .q:(+parentId'=0)&&(lastid'=parentId)&&(partId'=parentId)
  .q:(+rootflag=1)&&(lastid'=0)
  .s ^TMP("DHCST","web.DHCAPPPart","list",pid,lastid,+$p(^DHCAPPART(partId),"^",8),partId)=partId    /// sufan  2017-02-16  修改global存值的节点 lastid_"||"_+$p(^DHCAPPART(partId) --- lastid,+$p(^DHCAPPART(partId)
  
  
  s count=0
  w "{""rows"":["
  s tmp="",LastId=""
  f  s LastId=$o(^TMP("DHCST","web.DHCAPPPart","list",pid,LastId))  q:LastId=""  d   /// sufan  2017-02-16 增加循环上一级Id
  .f  s tmp=$o(^TMP("DHCST","web.DHCAPPPart","list",pid,LastId,tmp)) q:tmp=""  d
  ..s part=""
  ..f  s part=$o(^TMP("DHCST","web.DHCAPPPart","list",pid,LastId,tmp,part)) q:part=""  d
  ...w $case(count,0:"",:",")
  ...s partId=part
  ...s lastid=$p(^DHCAPPART(partId),"^",3)
  ...s jsonObj=##class(web.DHCAPPJsonObject).%New()
  ...d jsonObj.Put("APDesc",$p(^DHCAPPART(partId),"^",2))
  ...d jsonObj.Put("APCode",$p(^DHCAPPART(partId),"^",1))
  ...d jsonObj.Put("APParPDr",$case(lastid,0:"根节点",:$p(^DHCAPPART(lastid),"^",2)))
  ...d jsonObj.Put("APActiveFlag",$p(^DHCAPPART(partId),"^",5))
  ...d jsonObj.Put("ID",partId)
  ...d jsonObj.Put("APPartNum",$p(^DHCAPPART(partId),"^",7))
  ...d jsonObj.Put("APOrdNum",tmp)    ///$p(tmp,"||",2)  sufan  2017-02-16  修改顺序号的取值
  ...d jsonObj.Put("APAlias",$p(^DHCAPPART(partId),"^",9))
  ...w jsonObj.Json()
  ...s count=count+1
  w "],""total"":"_count_"}"
  k ^TMP("DHCST","web.DHCAPPPart","list",pid)
  q ""
}

/// d ##class(web.DHCAPPPart).listUseState()
ClassMethod listUseState()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","Y").Put("text","可用"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","N").Put("text","停用"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

ClassMethod find(Id)
{
   q:+Id=0 -1
   s ret=$p(^DHCAPPART(Id),"^",3)
   q ret
}

ClassMethod remove(Id)
{
   q:+Id=0 -1
   d ##class(User.DHCAppPartItm).%DeleteId(Id)
   q 0
}

/// Creater:   bianshuai
/// Descript:  部位别名
/// w ##Class(web.DHCAPPPart).QueryPartAlias("30","1","")
ClassMethod QueryPartAlias(rows As %String, page As %String, PartID As %String) As %String
{
	//n (rows, page, PartID)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	if ('$d(^DHCAPPART(PartID))) {
		w ##class(web.DHCAPPJsonCommon).getJsonStartSign(0) //输出json前缀串
		w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
		Q ""
	}
	
	s PartAliList=$p(^DHCAPPART(PartID),"^",9)  /// 部位别名
	if (PartAliList=""){
		w ##class(web.DHCAPPJsonCommon).getJsonStartSign(0) //输出json前缀串
		w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
		Q ""
	}
	
	s count=0
	s ListTitle="ItemLabel"
	s Len=$L(PartAliList,"/")
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Len) //输出json前缀串
	
	f i=1:1:Len D
	.s PartAlias=$p(PartAliList,"/",i)
	.s ListData=PartAlias
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creater:   bianshuai
/// Descript:  保存部位别名
/// w ##Class(web.DHCAPPPart).SavePartAlias("8005","55/88")
ClassMethod SavePartAlias(PartID As %String, PartAlias As %String) As %String
{
	//n (PartID, PartAlias)
	Q:'$d(^DHCAPPART(PartID)) ""
	Q:PartAlias="" ""
	&SQL(update DHC_AppPart set AP_Alias=:PartAlias where AP_RowId=:PartID)
	Q SQLCODE
}

/// Descript:  删除后，更新别名
/// w ##Class(web.DHCAPPPart).UpdPartAlias("8005","55/88")
ClassMethod UpdPartAlias(PartID As %String, PartAlias As %String) As %String
{
	//n (PartID, PartAlias)
	Q:'$d(^DHCAPPART(PartID)) ""
	&SQL(update DHC_AppPart set AP_Alias=:PartAlias where AP_RowId=:PartID)
	Q SQLCODE
}

/// Creater:    bianshuai
/// CreateDate: 2016-09-09
/// Descript:   检查部位树
/// w ##Class(web.DHCAPPPart).jsonCheckPartByNodeID()
ClassMethod jsonCheckPartByNodeID(id) As %String
{
	n (id)
	w "["
	s count=0
	s ID=0
  	f  s ID=$o(^DHCAPPART(0,"Parref",id,ID)) q:ID=""  d
  	.s Text=$p(^DHCAPPART(ID),"^",2)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
    .///  是否存在孩子节点
	.s trID=$o(^DHCAPPART(0,"Parref",ID,""))
	.i trID'="" D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	.w "}"
	w "]"
  	q ""
}

/// Descript:  检查分类树
/// w ##Class(web.DHCAPPPart).jsonCheckPartByPyCode("头部")
ClassMethod jsonCheckPartByPyCode(PyCode) As %String
{
	n (PyCode)
	s PyCode=$$ALPHAUP^SSUTIL4(PyCode)
	w "["
	s count=0
	s ID=0
  	f  s ID=$o(^DHCAPPART(0,"Parref",0,ID)) q:ID=""  d
  	.s Text=$p(^DHCAPPART(ID),"^",2)
  	.Q:'..isExistPyCodeOnChilden(ID,PyCode)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	.d ..GetCheckTreeChildenByPyCode(ID,PyCode)
	.w "}"
	w "]"
  	q ""
}

/// Descript: 本级节点是否需要显示
ClassMethod isExistPyCodeOnChilden(LastLevID As %String, PyCode As %String) As %String
{
	n (LastLevID, PyCode)

	s isExistFlag=0
	/// 不存在下级节点
	s ID=$o(^DHCAPPART(0,"Parref",LastLevID,""))
	i ID="" D
	.i ($p(^DHCAPPART(LastLevID),"^",2)[PyCode)||($p(^DHCAPPART(LastLevID),"^",9)[PyCode) D
	..s isExistFlag=1

	Q:ID="" isExistFlag

	s ID=""
	f  s ID=$o(^DHCAPPART(0,"Parref",LastLevID,ID))  q:(ID="")||(isExistFlag=1)  d
	.s Text=$p(^DHCAPPART(ID),"^",2)
	.s isExistFlag=..isExistPyCodeOnChilden(ID,PyCode)
	.
	Q isExistFlag
}

///  Descript:	检查分类树孩子节点处理
ClassMethod GetCheckTreeChildenByPyCode(patlev, PyCode) As %String
{
	n (patlev,PyCode)
    ///  是否存在孩子节点
	s ID=$o(^DHCAPPART(0,"Parref",patlev,""))
	Q:ID="" ""
	s count=0	
	s lev=patlev+1
	w ",""children"":["
	s ID=""
	f  s ID=$o(^DHCAPPART(0,"Parref",patlev,ID))  q:ID=""  d
	.s Text=$p(^DHCAPPART(ID),"^",2)
	.Q:'..isExistPyCodeOnChilden(ID,PyCode)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	.d ..GetCheckTreeChildenByPyCode(ID,PyCode)
	.w "}"
	w "]"
	Q ""
}

/// Creator:  	bianshuai
/// CreateDate: 2017-01-12
/// Descript: 	删除部位
/// W ##Class(web.DHCAPPPart).delPart("")
ClassMethod delPart(ID As %String) As %String
{
	n (ID)
	Q:$D(^DHCAPPTRA(0,"Part",ID)) "-1"  /// 检查是否和检查分类绑定
	Q:$D(^DHCAPREP(0,"Part",ID)) "-2"   /// 部位是否已开检查申请
	&SQL(delete from DHC_APPPart where AP_RowId=:ID)
	Q SQLCODE
}

/// Descript: 	重复性检查
/// W ##Class(web.DHCAPPPart).isrepeat("8005","膀胱")
ClassMethod isrepeat(ParID As %String, PartDesc As %String) As %String
{
	n (ParID, PartDesc)
	s quitflag=0
	s ID=""
	f  s ID=$o(^DHCAPPART(0,"Parref",ParID,ID))  q:(ID="")||(quitflag=1)  d
	.s Text=$p(^DHCAPPART(ID),"^",2)
	.Q:Text'=PartDesc
	.s quitflag=1
 	
 	Q quitflag
}

/// Creater:    sufan
/// CreateDate: 2017-02-04
/// Descript:   检查部位树按顺序加载
/// w ##Class(web.DHCAPPPart).jsonCheckPartByOrdnum()
ClassMethod jsonCheckPartByOrdnum(id) As %String
{
	n (id)
	w "["
	s count=0
	s ID=0,Ordnum=""
  	f  s Ordnum=$o(^DHCAPPART(0,"OrdNum",id,Ordnum)) q:Ordnum=""  d
  	.f  s ID=$o(^DHCAPPART(0,"OrdNum",id,Ordnum,ID))  q:ID=""  d
  	..s Text=$p(^DHCAPPART(ID),"^",2)
	..s count = count+1
	..i count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
    ..///  是否存在孩子节点
	..s trID=$o(^DHCAPPART(0,"Parref",ID,""))
	..i trID'="" D
	...w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	..w "}"
	w "]"
  	q ""
}

/// descript:上下移动部位树
/// input:当前节点的id
/// w ##class(web.DHCAPPPart).MoveUp(6)
ClassMethod MoveUp(Id)
{
	q:+Id=0 0
	s lastId=+$p(^DHCAPPART(Id),"^",3)
	s curordnum=+$p(^DHCAPPART(Id),"^",8)
	s curnextordnum=+$o(^DHCAPPART(0,"OrdNum",lastId,curordnum),-1)
	s nextId=$o(^DHCAPPART(0,"OrdNum",lastId,curnextordnum,""))
	s:curnextordnum<1 curnextordnum=1
	s:curordnum<1 curordnum=1 
	i curordnum=curnextordnum d
	.s curordnum=curordnum+1
	&sql(update DHC_AppPart set AP_Ordnum=:curnextordnum where AP_RowId=:Id)
	&sql(update DHC_AppPart set AP_Ordnum=:curordnum where AP_RowId=:nextId)
	q 0
}

/// descript:上下移动部位树
/// input:当前节点的id
/// w ##class(web.DHCAPPPart).MoveUp()
ClassMethod MoveDown(Id)
{
	q:+Id=0 0
	s lastId=+$p(^DHCAPPART(Id),"^",3)
	s curordnum=+$p(^DHCAPPART(Id),"^",8)
	s curnextordnum=+$o(^DHCAPPART(0,"OrdNum",lastId,curordnum))
	s nextId=$o(^DHCAPPART(0,"OrdNum",lastId,curnextordnum,""))
	s:curnextordnum<1 curnextordnum=1
	s:curordnum<1 curordnum=1 
	i curordnum=curnextordnum d
	.s curnextordnum=curnextordnum+1
	&sql(update DHC_AppPart set AP_Ordnum=:curnextordnum where AP_RowId=:Id)
	&sql(update DHC_AppPart set AP_Ordnum=:curordnum where AP_RowId=:nextId)
	q 0
}

/// Creator：      huaxiaoying
/// CreatDate：    2018-06-19
/// Descript: 	重复性检查
/// W ##Class(web.DHCAPPPart).isRepeatPartCode("8005","膀胱")
ClassMethod isRepeatPartCode(ParID As %String, PartCode As %String) As %String
{
	n (ParID, PartCode)
	s quitflag=0
	s ID=""
	f  s ID=$o(^DHCAPPART(0,"Parref",ParID,ID))  q:(ID="")||(quitflag=1)  d
	.s Text=$p(^DHCAPPART(ID),"^",1)
	.Q:Text'=PartCode
	.s quitflag=1
 	
 	Q quitflag
}

/// Descript:检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
 
	s ID=$p(mParam,"^",5)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",1)   	/// 描述
	/// 新记录
	Q:(ID="")&($d(^DHCAPPART(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-1"
	Q:(ID="")&($d(^DHCAPPART(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$p($g(^DHCAPPART(ID)),"^",1)    //代码
	s TmpDesc=$p($g(^DHCAPPART(ID)),"^",2)    //描述
	Q:(TmpCode'=Code)&($d(^DHCAPPART(0,"Code",$$ALPHAUP^SSUTIL4(Code)))) "-3"
	Q:(TmpDesc'=Desc)&($d(^DHCAPPART(0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) "-4"
	Q 0
}

}
