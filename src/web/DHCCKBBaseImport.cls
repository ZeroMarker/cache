Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2019-05-15
/// Descript: 		知识库基础数据导入类
Class web.DHCCKBBaseImport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript: 临时存储数据  【尝试直接把流取过来吗？？？】
/// W ##Class(web.DHCCKBBaseImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobal(pid As %String, mListData) As %String
{
	n (pid, mListData)
	i $CLASSNAME(mListData)="%CSP.CharacterStream" D
	.D ..InsTmpGlobalStream(pid, mListData)
	E  D
	.D ..InsTmpGlobalString(pid, mListData)
	Q 0
}

/// Descript: 临时存储数据[流]
/// W ##Class(web.DHCCKBBaseImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalStream(pid As %String, mListData) As %String
{
	n (pid, mListData)
	d mListData.Rewind()
	While (mListData.AtEnd = 0) {
		s IOStrLen=5000
		s ListData=mListData.Read(.IOStrLen)
		F i=1:1:$L(ListData,$C(2)) D
	    .s mData=$p(ListData,$C(2),i)
		.i mData[$C(1) D
		..s index=$I(^TMP("Num",pid))
		..s ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index)=$REPLACE($p(mData,$C(2)),$C(1),"")
		.E  D
		..s ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index)=$g(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index))_""_$p(mData,$C(2))
	}
	Q ""
}

/// Descript: 临时存储数据[字符串]
/// W ##Class(web.DHCCKBBaseImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalString(pid As %String, mListData) As %String
{
	n (pid, mListData)
	F i=1:1:$L(mListData,$C(2)) D
	.s ListData=$p(mListData,$C(2),i)
	.s ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,$I(^TMP("Num",pid)))=$REPLACE(ListData,$C(1),"")
	.
	Q ""
}

/// Descript: 取待导入的基础数据
/// w ##Class(web.DHCCKBBaseImport).QryDataWaitToImp("10","1","1","")
ClassMethod QryDataWaitToImp(rows As %String, page As %String, pid As %String, Params As %String) As %String
{
	n (rows, page, pid, Params)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s itemCode=$p(Params,"^",1) /// 药品代码
	s itemDesc=$p(Params,"^",2) /// 药品名称
	
	k TmpArr
	s index=1
	F  s index=$o(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index))
	.Q:ListData=""
	.Q:(itemCode'="")&($p(ListData,"^",1)'=itemCode)
	.Q:(itemDesc'="")&($p(ListData,"^",2)'[itemDesc)
	.s itmErrMsg=$g(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpErrMsg",pid,index))
	.s TmpArr(+index)=ListData_"^"_itmErrMsg
	.

	s ListTitle="itmIndex^itmCode^itmGeneric^itmEnglish^itmGoodName^itmIngr^itmInd^itmUsage^itmEffects^itmTaboo^itmAttent^itmInter^itmToxi^itmAppNum^itmManf^itmClass^itmErrMsg"
	w ##Class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=index_"^"_$g(TmpArr(index))
	.//Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..w ##Class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##Class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)

	w ##Class(web.DHCAPPJsonCommon).getJsonEndConTotal(count) //输出json结尾符
	Q ""
}

/// Descript: 插入知识库
/// w ##Class(web.DHCCKBBaseImport).InsTmpDic(1)
ClassMethod InsTmpDic(pid As %String) As %String
{
	n (pid)
	s SuccessNum=0,ErrorNum=0
	s tmpNum=$o(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,""))
	s ListTitle=$g(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,tmpNum))
	s mListTitle=$LISTFROMSTRING(ListTitle,"^")
	s Len=$LISTLENGTH(mListTitle)

	s index=1,Err=0
	F  s index=$o(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index)) Q:index=""  D
	.s ListData=$g(^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid,index))
	.Q:ListData=""
	.s mListData=$LISTFROMSTRING(ListData,"^")
	.s itmCode=$LISTGET(mListData,1)    /// 药品编码
	.s itmCode=$tr(itmCode,$c(10),"")
	.s itmDesc=$LISTGET(mListData,2)    /// 通用名称
	.s itmDesc=$tr(itmDesc,$c(10),"")
	.s dicId=""
	.i (itmCode'="")&(itmDesc'="") s dicId=..InsDic(itmCode, itmDesc, 1) /// 插入知识库类型项
	.i dicId'>0 s ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpErrMsg",pid,index)="错误原因:"_dicId 
	.q:dicId=""
	.s ErrMsg=""
	.F i=3:1:Len  D
	..s itmText=$LISTGET(mListData,i) 	 /// 属性值
	..s itmValue=$LISTGET(mListTitle,i)  /// 属性
	..//Q:itmText=""    /// 属性值为空时，不插入
	..s Err=..InsDicLinkAttr(dicId, itmValue, itmText)  /// 插入知识库实体属性表
	..Q:Err=0
	..s ErrMsg=Err
	..s ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpErrMsg",pid,index)="错误原因:"_ErrMsg
	.i ErrMsg="" s SuccessNum=SuccessNum+1
	.E  s ErrorNum=ErrorNum+1
	.
	w ##Class(web.DHCAPPJsonCommon).getJsonData("SuccessNum^ErrorNum",SuccessNum_"^"_ErrorNum)
	Q ""
}

///  Descript: 插入知识库类型项
ClassMethod InsDic(itemcode As %String, itemdesc As %String, InsFlag As %String) As %String
{
	n (itemcode, itemdesc, InsFlag)
	s itmid=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(itemcode),""))
	Q:itmid'="" itmid
	s InsType=$s(InsFlag=1:"Drug",1:"Drug_Prop")
	s typeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(InsType),""))
	Q:typeId="" "药品类型为维护！"
	//&SQL(insert into CT_CKB_PDSS.CommonDiction (CD_Code, CD_Desc, CD_Type)values(:itemcode, :itemdesc, :typeId))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

///  Descript: 插入知识库实体属性表
ClassMethod InsDicLinkAttr(dicId As %String, itmvalue As %String, itmtext As %String) As %String
{
	n (dicId, itmvalue, itmtext)
	q:itmvalue="" ""
	s itmId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(itmvalue),""))      /// 通用名在实体类ID
	i itmId="" s itmId=..InsDic(itmvalue, itmvalue, 0) /// 插入知识库类型项
	Q:itmId<0 "属性类型插入失败！"
	s itmAttrId=..GetDicLinkAttr(dicId, itmId)
	i itmAttrId="" D
	.&SQL(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr, DLA_AttrCode, DLA_Result)values(:dicId, :itmId, :itmtext))
	E  D
	.&SQL(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:itmtext where DLA_RowID=:itmAttrId)
	i SQLCODE'=0 Q %msg
	Q SQLCODE
}

/// Descript: 实体类型对应属性是否存在
ClassMethod GetDicLinkAttr(dicId As %String, itmId As %String)
{
	n (dicId, itmId)
	s ID="",TmpID=""
	F  s ID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicId,ID)) Q:(ID="")||(TmpID'="")  D
	.Q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ID)),3)'=itmId
	.s TmpID=ID
	.
	Q TmpID
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpGlobal",pid)
	k ^TMP("DHCCKB","web.DHCCKBBaseImport","InsTmpErrMsg",pid)
	k ^TMP("Num",pid)
	Q ""
}

}
