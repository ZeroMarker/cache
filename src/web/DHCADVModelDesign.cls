Class web.DHCADVModelDesign Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// Description:： 查询表下的字段
/// d ##class(web.DHCADVModelDesign).ListColumnByTable("User.DHCAdvMaster")
ClassMethod ListColumnByTable(table = "")
{
	n (table)
	s TitleStr="Name^Description"
	
	s dcd = ##Class(%Dictionary.ClassDefinition).%OpenId(table)
	w "{""rows"":["
	w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,"%ID^主键")
	s cnt=dcd.Properties.Count()
	f i=1:1:cnt  d
	.s propObj = dcd.Properties.GetAt(i)
	.s PropertyName = propObj.Name
	.s Description=propObj.Description
	.s tmp=PropertyName_"^"_Description
	
    .w ","_##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,tmp)
    w "]}"
  q ""
}

/// 查询模型的x轴和y轴
/// Others:w ##class(web.DHCADVModelDesign).DimensionTree(1)
ClassMethod DimensionTree(model)
{
	
	n (model)
	q:+model=0 ""
	
	s axisStr="x^y"
	w "["
	f i=1:1:$l(axisStr,"^") d
	.s axis=$p(axisStr,"^",i)
	.w $case(i,1:"",:",")
	.w "{"
    .w """id"":"""_axis_""","
    .w """text"":"""_axis_"轴"","
    .w """children"":"
    .d ##class(web.DHCADVModelDesign).DimensionSubTree(model,axis,0)
    .w "}"
	w "]"
	q ""
}

ClassMethod DimensionSubTree(model, axis, parent)
{
	n (model,axis,parent)
	s count=0
	w "["
	s seq="" f  s seq=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,parent,seq)) q:seq=""  d
	.s ma="" f  s ma=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,parent,seq,ma)) q:ma=""  d
	..i count>0 d
    ...w ","
    ..s colum=$p(^DHCADVMODELATTR(ma),"^",3)
    ..s columType=$p(^DHCADVMODELATTR(ma),"^",5)
    ..i columType="dic" d
    ...s colum=$ListGet(^User.DHCAdvFormDicD(colum),4)_"("_$ListGet(^User.DHCAdvFormDicD(colum),3)_")"
    ..i columType="dateRange" d
    ...s colum=##class(web.DHCADVModelDesign).GetDateRangeDesc(colum)
    ...
    ..s displayTitle=$p(^DHCADVMODELATTR(ma),"^",6)
    ..s:displayTitle'="" colum=displayTitle
    ..w "{"
    ..w """id"":"_ma_","
    ..w """text"":"""_colum_""","
    ..w """children"":"
    ..d ##class(web.DHCADVModelDesign).DimensionSubTree(model,axis,ma)
    ..w "}"
    ..s count=count+1
    w "]"
	q ""
}

/// 保存报表模型的列
/// Others:w ##class(web.DHCADVModelDesign).SaveModelAttr()
ClassMethod SaveModelAttr(model, par, columType, axis = "y", dateValue = "")
{
	n (model, par,columType ,axis,dateValue)
	s ret=0
	f i=1:1:$l(par,"^") d
	.s column=$p(par,"^",i)
	.q:column=""
	.s ma=$o(^DHCADVMODELATTR(0,"ColumnType",model,columType,column,""))
	.s:+ma'=0 ret=-1
	.q:ret'=0
	.s obj=##class(User.DHCADVModelAttr).%New()
	.d obj.modelSetObjectId(model)
	.s obj.columType=columType
	.s obj.colum=column
	.s obj.type=axis
	.s sc=obj.%Save()
	q ret
}

/// 通过日期类型code获取日期描述
ClassMethod GetDateRangeDesc(type)
{
	n (type)
	q $CASE(type,"year":"年","quarter":"季度","month":"月",
					"week":"周","day":"日期","day":"日期","hour":"小时"
					,"minute":"分钟","second":"秒",:"")
}

/// 已tree的形式显示字典元素子元素
/// d ##class(web.DHCADVModelDesign).listTree()
ClassMethod listTree(id, attr)
{
  
  n (id,attr)
  s dic="",count=0
  w "[{"
  w """id"":"_id_","
  w """text"":"""_$List(^User.DHCAdvFormDicD(id),4)_""","
  w """checked"":""true"""
  w ",""children"":"
  w "["
  f  s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_+id,dic)) q:dic=""  d
  .w $case(count,0:"",:",")
  .s data=^User.DHCAdvFormDicD(dic)
  .w "{"
  .w """id"":"_dic_","
  .w """text"":"""_$List(data,4)_""","
  .w """checked"":""true"""
  .d ..listChildren(dic,attr)
  .w "}"
  .s count=count+1
  w "]"
  w "}]"
  q ""
}

/// 递归调用的子方法
ClassMethod listChildren(id, attr)
{
  
    n (id,attr)
    s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,""))
	q:+subId=0
	s subId="",i=0
	w ",""children"":["
	f  s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,subId)) q:subId=""  d
	.w $case(i,0:"",:",")
	.s data=^User.DHCAdvFormDicD(subId)
	.w "{"
  	.w """id"":"_subId_","
    .w """text"":"""_$List(data,4)_""","
    .w """checked"":""true"""
  	.d ..listChildren(subId,attr)
    .w "}"
    .s i=i+1
	w "]"
}

/// 把字典结构保存到维度
/// d ##class(web.DHCADVModelDesign).saveAttrByDic()
ClassMethod saveAttrByDic(model, par, axis, root)
{
	n (model, par,axis,root)
	s pid=##class(web.DHCADVCOMMON).NewPid()
	s ret=0
	f i=1:1:$l(par,$c(1)) d
	.q:ret'=0
	.s column=$p(par,$c(1),i)
	.q:+column=0
	.
	.s ma=+$o(^DHCADVMODELATTR(0,"ColumnType",model,"dic",column,""))
	.s:+ma'=0 sc=##class(User.DHCADVModelAttr).%DeleteId(ma)
	.
	.s obj=##class(User.DHCADVModelAttr).%New()
	.d obj.modelSetObjectId(model)
	.s obj.columType="dic"
	.s obj.colum=column
	.s obj.type=axis
	.s obj.displayTitle=$LG(^User.DHCAdvFormDicD(column),4)
	.s sc=obj.%Save()
	.s:$SYSTEM.Status.IsError(sc) ret=-10
	.q:ret'=0
	.s ^TMP("web.DHCADVModelDesign","saveAttrByDic",pid,column)=obj.%Id()
	
	q:ret'=0 ret
	
	s ret=##class(web.DHCADVModelDesign).updateAttrParent(pid,root)
	k ^TMP("web.DHCADVModelDesign","saveAttrByDic",pid)
	q ret
}

ClassMethod updateAttrParent(pid, root)
{
	n (pid,root)
	s ret=0
	s parentId=$g(^TMP("web.DHCADVModelDesign","saveAttrByDic",pid,root))
	s subId="" f  s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_root,subId)) q:(subId="")||(ret'=0)  d
	.
	.s attrId=+$g(^TMP("web.DHCADVModelDesign","saveAttrByDic",pid,subId))
	.q:attrId=0
	.
	.s obj=##class(User.DHCADVModelAttr).%OpenId(attrId)
	.d obj.parentSetObjectId(+parentId)
	.s sc=obj.%Save()
	.s:$SYSTEM.Status.IsError(sc) ret=-11
	.q:ret'=0
	.s ret=##class(web.DHCADVModelDesign).updateAttrParent(pid,subId)
	q ret
}

}
