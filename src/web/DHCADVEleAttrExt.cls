Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2019-07-18
/// Descript:    元素属性维护
Class web.DHCADVEleAttrExt Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2019-07-18
/// Description：  元素属性维护
/// Table：        User.DHCAdvEleAttrExt
/// Input：		   params:"代码^描述"
/// Output：       元素属性字典表信息
/// Others：       w ##Class(web.DHCADVEleAttrExt).QueryAttrExt("30","1","88124")
ClassMethod QueryAttrExt(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	Q:params="" ##class(web.DHCADVJSONCOMMON).GetNoJson()
	s pid=##Class(web.DHCADVCOMMON).NewPid()	
	d ..killTmpGlobal(pid)     			// k掉临时global
	s FormDicCode=$p(params,"^",1)    	// 元素ID

	s h=0,count=0
	w "{""rows"":["
	s AttrRowId="0"
	for  s AttrRowId=$o(^DHCADVEAE(0,"DIC",$$ALPHAUP^SSUTIL4(FormDicCode),AttrRowId)) q:AttrRowId=""  d 
	.s AttrCode=$p(^DHCADVEAE(AttrRowId),"^",1)      		// 代码
	.s AttrId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(AttrCode),""))
	.s AttrDesc=$lg(^User.DHCAdvFormDicD(AttrId),4)  			// 描述
	.s AttrDicCode=$p(^DHCADVEAE(AttrRowId),"^",2)
	.s AttrValue=$p(^DHCADVEAE(AttrRowId),"^",3)	 
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.AttrRowId=AttrRowId
	.s tmpObj.AttrCode=AttrCode
	.s tmpObj.AttrDesc=AttrDesc
	.s tmpObj.AttrDicCode=AttrDicCode
	.s tmpObj.AttrValue=AttrValue
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

ClassMethod SaveAttr(params As %String) As %String
{
	n (params)
	
  	s Err=0
  	TS
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.s Err=..CheckRepeat(tmpstr)   	 /// 重复性判断
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdAttr(tmpstr)		 /// 更新数据
	.e  d
	..s Err=..InsertAttr(tmpstr)     /// 插入数据
	i Err'="0" TRO
	Q:Err'="0" Err
	TC
	q Err
}

/// Descript: 保存数据
/// Others  : w ##class(web.DHCADVEleAttrExt).InsertAttr() 
ClassMethod InsertAttr(ListData As %String) As %String
{
	n (ListData)
	s AttrCode=$p(ListData,"^",2)			/// 代码
	s AttrValue=$p(ListData,"^",3)			/// 属性值
	s AttrDicCode=$p(ListData,"^",4)			/// 关联元素ID
	&sql(insert into DHC_AdvEleAttrExt (EAE_AttrCode,EAE_DicCode,EAE_AttrValue) values (:AttrCode,:AttrDicCode,:AttrValue) )
	q SQLCODE
}

/// Descript: 更新数据
/// Others  : w ##class(web.DHCADVEleAttrExt).UpdAttr() 
ClassMethod UpdAttr(ListData As %String) As %String
{
	n (ListData)
	s AttrRowId=$p(ListData,"^",1)			/// RowId
	s AttrCode=$p(ListData,"^",2)			/// 代码
	s AttrValue=$p(ListData,"^",3)			/// 属性值
	s AttrDicCode=$p(ListData,"^",4)		/// 关联元素code
	&sql(update DHC_AdvEleAttrExt set EAE_AttrCode=:AttrCode,EAE_DicCode=:AttrDicCode,EAE_AttrValue=:AttrValue where EAE_RowID=:AttrRowId)
	q SQLCODE
}

ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	 ///ID
	s Code=$p(ItmTempStr,"^",2)  	 ///代
	/// 新记录
	if ID=""  d
	.i $d(^DHCADVEAE(0,"Code",$$ALPHAUP^SSUTIL4((Code))))   d
	..s ret=-1
	/// 修改记录
	else  d
	.s AttrCode=$p($g(^DHCADVEAE(ID)),"^",1)    //代码
	.i (Code'=AttrCode)&($d(^DHCADVEAE(0,"Code",$$ALPHAUP^SSUTIL4(Code))))  d
	..s ret=-2
	.
	
	q ret
}

/// Creator：      sufan
/// CreatDate：    2019-07-18
/// Description：  元素属性维护
/// Table：        User.DHCAdvEleAttrExt
/// input:		   待保存数据串，分割符："^".多个串，以&&分割
/// Output：       0 ：保存成功  其他：保存失败
/// Others：       w ##class(web.DHCADVEleAttrExt).SaveAttr("^height^高度^input元素的高度")
/// Creator：  sufan
/// CreatDate: 2019-07-18
/// Descript:  检查代码、描述是否重复
/// Table：    DHC_AdvEleAttrExt
/// Others：   w ##class(web.DHCADVEleAttrExt).CheckRepeat("^height^高度^input元素的高度")
/// Descript: 删除
/// Others  : w ##class(web.DHCADVEleAttrExt).DelAttr()
ClassMethod DelAttr(EaeRowId As %String) As %String
{
	n (EaeRowId)
	&sql(delete from DHC_AdvEleAttrExt where EAE_RowID=:EaeRowId)
	q SQLCODE
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCADV","web.DHCADVEleAttrExt","QueryExaArc",pid)
}

/// 判断是否存在子元素
ClassMethod IsExitSub(ParrefId)
{
	n (ParrefId)
	Q:$d(^User.DHCAdvFormDicI("IndexParef"," "_ParrefId)) 1
	Q 0
}

/// Descript:取表单属性元素
/// w ##class(web.DHCADVEleAttrExt).QueryAttrDic(30,1,"advPipeOff")
ClassMethod QueryAttrDic(rows As %String, page As %String, RepCode, q = "")
{
	n (rows, page, RepCode,q)
	Q:RepCode="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0)
	s RepCode=$$ALPHAUP^SSUTIL4(RepCode)
	s RepId=$o(^User.DHCAdvFormNameI("IndexCode",RepCode,""))
	d ##class(web.DHCADVEXPFIELD).QueryAllItmByFormID(rows,page,RepId,q)
	q ""
}

}
