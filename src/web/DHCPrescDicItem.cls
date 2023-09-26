Import SQLUser

/// Creator:     	chenzhaobo
/// CreateDate:   	2021-09-01
/// Descript:		审核状态字典项目操作
Class web.DHCPrescDicItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	审核状态申请字典项目表新增或修改
/// w ##class(web.DHCPrescDicItem).save("8^000003^测试000003^N^65")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Descript:	增加
/// w ##class(web.DHCPrescDicItem).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
 	&SQL(INSERT INTO CT_PHA_PREADT.DicItem(PDI_Code, PDI_Desc, PDI_ActiveFlag, PDI_Hosp_Dr, PDI_Type_Dr) VALUES(:Code,:Desc,:ActFlag,:HospID,:TypeID))
 	q SQLCODE
}

/// Descript:	更新
/// w ##class(web.DHCPrescDicItem).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	&SQL(Update CT_PHA_PREADT.DicItem Set PDI_Code=:Code, PDI_Desc=:Desc, PDI_ActiveFlag=:ActFlag, PDI_Hosp_Dr=:HospID WHERE PDI_RowID=:ID)
 	q SQLCODE
}

/// Descript:	删除
/// w ##class(web.DHCPrescDicItem).delete("1")
ClassMethod delete(ID As %String) As %String
{
	N (ID)
	s $Zt="Err"
	ts
	s ItmPropID="0",ret=0
	F  s ItmPropID=$o(^CT.PHA.PREADT.DicItemI("ItemPar",ID,ItmPropID)) Q:(ItmPropID="")||(ret'=0)  D
	.s ret=##class(web.DHCPrescDicItemProp).delete(ItmPropID)
	i ret'=0 tro
	q:ret'=0 ret
	&SQL(Delete From CT_PHA_PREADT.DicItem Where PDI_RowID=:ID)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 SQLCODE
	tc
	Q SQLCODE
Err
	tro //ed
	Q SQLCODE
}

/// Descript:查询
/// w ##class(web.DHCPrescDicItem).QryPrescDicItem("40","1","17","")
ClassMethod QryPrescDicItem(rows As %String, page As %String, mID As %String, IsTreeGrid = "") As %String
{
	N (rows,page,mID,IsTreeGrid)
	s End = page*rows
	s Start=(page-1)*rows+1
	s:+IsTreeGrid=1 Start=1,End=999        //huanghongping 添加树节点参数以及判断
	
	k TmpItemDet
	s h=0,count=0
	s ID=""
	F  s ID=$o(^CT.PHA.PREADT.DicItemI("TypePar",mID,ID)) Q:ID=""  D
	.s str = $g(^CT.PHA.PREADT.DicItemD(ID))
	.s Code=$list($g(str),2)   						//代码
	.s Desc=$list($g(str),3)    					//描述
	.s ActCode=$list($g(str),4)  					//可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$list($g(str),5)   					//医院
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s mID=$list($g(str),6)     					//类型ID
	.s ParID=$lg(str,7)               //huanghongping 添加父节点，用于树结构
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_mID_"^"_ParID
	.s TmpItemDet(h)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^Code^Desc^ActCode^ActDesc^HospID^HospDesc^mID^_parentId"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	F  s index=$o(TmpItemDet(index)) Q:index=""  D
	.s ListData=$g(TmpItemDet(index))
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  D
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符

	Q ""
}

/// Descript:检查代码、描述是否重复
ClassMethod isExist(mParam As %String) As %String
{
	N (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	Q:(ID="")&($d(^CT.PHA.PREADT.DicItemI("Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	Q:(ID="")&($d(^CT.PHA.PREADT.DicItemI("Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	Q:ID="" 0
	
	/// 修改记录
	s TmpCode=$list($g(^CT.PHA.PREADT.DicItemD(ID)),2)    //代码
	s TmpDesc=$list($g(^CT.PHA.PREADT.DicItemD(ID)),3)    //描述
	Q:(TmpCode'=Code)&($d(^CT.PHA.PREADT.DicItemI("Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^CT.PHA.PREADT.DicItemI("Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	Q 0
}

/// Creator: 		hxy
/// CreateDate: 	2021-06-29
/// Descript:复制
/// w ##class(web.DHCPrescDicItem).SaveCopy("27","c1","3")
ClassMethod SaveCopy(ID As %String, Code As %String, Hosp As %String) As %String
{
	n (ID,Code,Hosp)
	s ^temptest("mID") = $lb(ID,Code,Hosp)
	s ret=0
	q:$d(^CT.PHA.PREADT.DicTypeI("Code",$$ALPHAUP^SSUTIL4(Code),Hosp)) "-1" /// 重复性判断
	
	//s $Zt="Error"
	ts	
	s DicObj=##class(CT.PHA.PREADT.DicType).%New()
	s DicObj.PDSCode=Code
	s DicObj.PDSDesc=$list($g(^CT.PHA.PREADT.DicTypeD(ID)),3)
	s DicObj.PDSActiveFlag=$list($g(^CT.PHA.PREADT.DicTypeD(ID)),4)
	s DicObj.PDSHospDr=##class(User.CTHospital).%OpenId(Hosp)
	d DicObj.%Save()
	
 	s ret=##class(web.DHCPrescDicItem).CopyDicItm(DicObj.%Id(),ID)
	i ret'=0 tro
	q:ret'=0 ret
		
	tc
	q ret
Error
	tro
	q -2
}

/// w ##class(web.DHCPrescDicItem).CopyDicItm(23,17)
ClassMethod CopyDicItm(DicID As %String, ID As %String) As %String
{
	n (DicID,ID)
	s ret=0
	s HospID=$list($g(^CT.PHA.PREADT.DicTypeD(DicID)),5) //医院
	s ItmID=0
	F  s ItmID=$o(^CT.PHA.PREADT.DicItemI("TypePar",ID,ItmID)) Q:(ItmID="")||(ret'=0)  D
	.s ItemObj=##class(CT.PHA.PREADT.DicItem).%New()
	.s ItemObj.PDICode=$list($g(^CT.PHA.PREADT.DicItemD(ItmID)),2)    //代码 
	.s ItemObj.PDIDesc=$list($g(^CT.PHA.PREADT.DicItemD(ItmID)),3)   //描述
	.s ItemObj.PDIActiveFlag=$list($g(^CT.PHA.PREADT.DicItemD(ItmID)),4)  //可用标志
	.s ItemObj.PDIHospDr=##class(User.CTHospital).%OpenId(HospID)
	.s ItemObj.PDITypeDr=##class(CT.PHA.PREADT.DicType).%OpenId(DicID)
	.s sc=ItemObj.%Save()
	.s parId = $list($g(^CT.PHA.PREADT.DicItemD(ItmID)),7)
	.s inParId = "",parCode = ""
	.i parId'="" s parCode = $list($g(^CT.PHA.PREADT.DicItemD(parId)),2)
	.s:parCode'="" inParId = $o(^CT.PHA.PREADT.DicItemI("HospCode",HospID,$$ALPHAUP^SSUTIL4(parCode),""))
	.s curId = ItemObj.%Id()
	.s updObj = ##class(CT.PHA.PREADT.DicItem).%OpenId(curId)
	.s updObj.PDIParId = inParId
	.s upsc = updObj.%Save()
 	.s:$$$ISERR(sc) ret="-2"
	.i $d(^CT.PHA.PREADT.ItemPropI("ItemPar",ItmID)) d
	..s PropID=0
	..F  s PropID=$o(^CT.PHA.PREADT.ItemPropI("ItemPar",ItmID,PropID)) Q:(PropID="")||(ret'=0)  D
 	...s PropObj=##class(CT.PHA.PREADT.ItemProp).%New()
	...s PropObj.PIPCode=$list($g(^CT.PHA.PREADT.ItemPropD(PropID)),2)
	...s PropObj.PIPDesc=$list($g(^CT.PHA.PREADT.ItemPropD(PropID)),3)
	...s PropObj.PIPActiveFlag=$list($g(^CT.PHA.PREADT.ItemPropD(PropID)),4)
	...s PropObj.PIPItemDr=##class(CT.PHA.PREADT.DicItem).%OpenId(ItemObj.%Id())
	...s sc=PropObj.%Save()
 	...s:$$$ISERR(sc) ret="-2"
	..
	.
 	q ret
}

/// Author: huanghongping
/// Debug: d ##class(web.DHCPrescDicItem).QryPrescDicItemArray("3")
/// Function: 查询下拉框数据
/// Input: mID:字典类型ID
/// CreateDate:2021/11/5
ClassMethod QryPrescDicItemArray(mID)
{
	n (mID)
	//s ^Temp("QryPrescDicItemArray")=$lb(mID)
	q:+mID=0 "[]"
	s count=0
	w "["
	s id=""
	f 
	{
		s id=$o(^CT.PHA.PREADT.DicItemI("TypePar",mID,id)) q:id=""
		s code=$lg(^CT.PHA.PREADT.DicItemD(id),2)
		s desc=$lg(^CT.PHA.PREADT.DicItemD(id),3)
		s count=count+1
		w $case(count,1:"",:",")
		s ItmData = id_"^"_desc
		w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",ItmData)	
	}
	w $case(count,0:"",:",")
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","0^无")  // 加一条"0^无"表示无父节点,即根节点		
	 w "]"
	q ""
}

/// Author： huanghongping
/// Function: 保存
/// Others: 
/// d ##class(web.DHCPrescDicItem).treeItmSave("92^5^收藏主题5^N^2^16^")
/// CreateDate:2021/11/5
ClassMethod treeItmSave(mParam)
{
	
	n (mParam)
	s ^Temp("treeItmSave")=$lb(mParam)
	s Err=0
	F i=1:1:$L(mParam,"$$") Q:Err'=0  D
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isTreeItmExist(mdata)   /// 重复性判断
	.Q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..treeInsert(mdata)
	.e  d
	..s Err=..treeUpdate(mdata)
	..Q:Err'=0
	..s Err = ..updSubNode(mdata)
	Q Err
}

/// Others: var mListData=ID +"^"+ Code +"^"+ Desc +"^"+ ActCode +"^"+ HospID +"^"+ mID +"^"+ ParID;
/// Author: huanghongping
/// Descript:检查代码、描述是否重复
/// w ##class(web.DHCPrescDicItem).isTreeItmExist("24^mdt^mdt^Y^2^2^10")
/// CreateDate:2021/11/5
ClassMethod isTreeItmExist(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   	/// ID
	s Code=$p(mParam,"^",2)   	/// 代码
	s Desc=$p(mParam,"^",3)   	/// 描述
	s HospID=$p(mParam,"^",5)   /// 医院ID
	/// 新记录
	q:(ID="")&($d(^CT.PHA.PREADT.DicItemI("Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-1"
	q:(ID="")&($d(^CT.PHA.PREADT.DicItemI("Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-2"
	q:ID="" 0
	
	/// 修改记录
	s TmpCode=$list($g(^CT.PHA.PREADT.DicItemD(ID)),2)    //代码
	s TmpDesc=$list($g(^CT.PHA.PREADT.DicItemD(ID)),3)    //描述
	Q:(TmpCode'=Code)&($d(^CT.PHA.PREADT.DicItemI("Code",$$ALPHAUP^SSUTIL4(Code),HospID))) "-3"
	Q:(TmpDesc'=Desc)&($d(^CT.PHA.PREADT.DicItemI("Desc",$$ALPHAUP^SSUTIL4(Desc),HospID))) "-4"
	q 0
}

/// Author:haunghongping
/// Function:树节点插入
/// CreateDate:2021/11/5
ClassMethod treeInsert(mdata)
{
	n (mParam)
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s TypeID=$p(mParam,"^",6)   ///类型ID
	s ParID=$p(mParam,"^",7)    ///父节点ID
 	&SQL(INSERT INTO CT_PHA_PREADT.DicItem(PDI_Code, PDI_Desc, PDI_ActiveFlag, PDI_Hosp_Dr, PDI_Type_Dr,PDI_Par_Id) VALUES(:Code,:Desc,:ActFlag,:HospID,:TypeID,:ParID))
 	q SQLCODE
}

/// Author:haunghongping
/// Function:树节点修改
/// CreateDate:2021/11/5
ClassMethod treeUpdate(mParam)
{
	n (mParam)
	s ret = 0
	s ID=$p(mParam,"^",1)   	///ID
	s Code=$p(mParam,"^",2)   	///代码
	s Desc=$p(mParam,"^",3)   	///描述
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s ParID=$p(mParam,"^",7)    ///父节点ID
	&SQL(Update CT_PHA_PREADT.DicItem Set PDI_Code=:Code, PDI_Desc=:Desc, PDI_ActiveFlag=:ActFlag, PDI_Hosp_Dr=:HospID,PDI_Par_Id=:ParID WHERE PDI_RowID=:ID)
 	B  //S1
 	s ret = SQLCODE
 	Q:ret'=0 ret
 	q ret
}

/// Descript:更新子节点的状态
/// Author:sufan
/// w ##class(web.DHCPrescDicItem).updSubNode("92^5^收藏主题5^N^2^16^")
ClassMethod updSubNode(mParam)
{
	s ret = 0
	s ID=$p(mParam,"^",1)   	///ID
	s ActFlag=$p(mParam,"^",4)  ///不可用标志
	s HospID=$p(mParam,"^",5)   ///医院ID
	s nodeList = ""
	s nodeList = ..GetSubNode(ID,.nodeList)
	b  //s2
	s len = $l(nodeList,"&")
	for i=1:1:len  q:ret'=0  d
	.s nodeId = $p(nodeList,"&",i)
	.s Code=$lg(^CT.PHA.PREADT.DicItemD(nodeId),2)   	///代码
	.s Desc=$lg(^CT.PHA.PREADT.DicItemD(nodeId),3)   	///描述
	.s ParID=$lg(^CT.PHA.PREADT.DicItemD(nodeId),7)    ///父节点ID
	.s list = nodeId_"^"_Code_"^"_Desc_"^"_ActFlag_"^"_HospID_"^^"_ParID
	.s ret = ..treeUpdate(list)
	.q:ret'=0
	q ret
}

/// w ##class(web.DHCPrescDicItem).QueryNodes("16")
ClassMethod QueryNodes(ID)
{
	s nodeList = ""
	s itmId = ""
	for  s itmId = $o(^CT.PHA.PREADT.DicItemI("TypePar",ID,itmId))  Q:itmId=""  d
	.i nodeList="" s nodeList = itmId
	.e  s nodeList = nodeList_"&"_itmId
	.s nodeList = ..GetSubNode(itmId,.nodeList)
	Q nodeList
}

/// Descript:获取所有叶子节点
/// Author:sufan
/// w ##class(web.DHCPrescDicItem).GetSubNode("92","")
ClassMethod GetSubNode(ID, nodeList)
{
	s subId = $o(^CT.PHA.PREADT.DicItemI("parref",ID,""))
	Q:subId="" nodeList
	i subId'=""  d
	.i nodeList="" s nodeList = subId
	.e  s nodeList = nodeList_"&"_subId
	.s treeNodeId = ""
	.for  s treeNodeId = $o(^CT.PHA.PREADT.DicItemI("parref",subId,treeNodeId))  Q:treeNodeId=""  d
	..i nodeList="" s nodeList = treeNodeId
	..e  s nodeList = nodeList_"&"_treeNodeId
	..d ..GetSubNode(treeNodeId,.nodeList)
	Q nodeList
}

/// w ##class(web.DHCPrescDicItem).treeDelete("52")
/// Author:haunghongping
/// Function:树节点删除
/// CreateDate:2021/11/5
ClassMethod treeDelete(IDStr)
{
	n (IDStr)
	//s ^Temp("treeDelete")=$lb(IDStr)
	s $zt="Erp"
	ts
	s flag=0
 	f i=1:1:$l(IDStr,"^")
 	{
	 	q:flag'=0
	 	s ID=$p(IDStr,"^",i)
	 	s flag=..delete(ID)	
	 	b //11
	}
	b //22
	i flag'=0 tro
	q:flag'=0 flag
	tc
	q flag	
Erp
	tro //ed
	q flag
}

}
