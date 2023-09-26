/// Creator：      zhouxin
/// CreatDate：    2019-05-29
/// Description:： 不良事件BI统计
Class web.DHCADVModel Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator:zhouxin
/// CreatDate:2019-05-29
/// Input:
///       entity:实体类名
///       parStr:字段名称1_$c(1)_值1_"^"_字段名称2_$c(1)_值2
/// 	  saveType:1:更新全部字段，未传入的字典更新为空
/// 	  saveType:2:更新传入字段，未传入的字典不更新 
/// Description:： 通用保存"User.DHCADVModelAttr","ID"_$c(1)_"23"_$c(2)_"model"_$c(1)_"6"_$c(2)_"type"_$c(1,2)_"displayTitle"_$c(1)_"Ⅲ级事件"_$c(2)_"seq"_$c(1)_"999"_$c(2)_"class"_$c(1,2)_"func"_$c(1,2)_"filter"_$c(1,2)_"displayRate"_$c(1)_"y"_$c(2)_"measureType"_$c(1)_"count"_$c(2)_"extendType"_$c(1)_"dic"_$c(2)_"hidden"_$c(1)_"n"_$c(2)_"type"_$c(1)_"y"_$c(2)_"displayTotal"_$c(1)_"n","2"
/// d ##class(web.DHCADVModel).saveOrUpdate("User.DHCADVModelAttr","ID"_$c(1)_"22"_$c(2)_"model"_$c(1)_"6"_$c(2)_"type"_$c(1,2)_"displayTitle"_$c(1)_"Ⅱ级事件"_$c(2)_"seq"_$c(1)_"999"_$c(2)_"class"_$c(1,2)_"func"_$c(1,2)_"filter"_$c(1,2)_"displayRate"_$c(1)_"y"_$c(2)_"measureType"_$c(1)_"count"_$c(2)_"extendType"_$c(1)_"dic"_$c(2)_"hidden"_$c(1)_"n"_$c(2)_"type"_$c(1)_"y"_$c(2)_"displayTotal"_$c(1)_"n","2")
ClassMethod saveOrUpdate(entity = "", parStr = "", saveType = 1, hosp = "")
{
	
	n (entity,parStr,saveType,hosp)
	q:parStr="" 0
	s dcd = ##Class(%Dictionary.ClassDefinition).%OpenId(entity)
	q:'$IsObject(dcd) -99
	
	s ID=0
	k valueList
	f i=1:1:$l(parStr,$c(2)) d
	.s tmp=$p(parStr,$c(2),i)
	.s key=$p(tmp,$c(1),1)
	.s value=$p(tmp,$c(1),2)
	.s valueList(key)=value
	.s:key="ID" ID=+value
	
	if ID'=0 d
	.s bean = $classmethod(entity,"%OpenId",ID)
	else  d
	.s bean = $classmethod(entity,"%New")
	Q:bean="" -98
	s cnt=dcd.Properties.Count()
	f i=1:1:cnt  d
	.s propObj = dcd.Properties.GetAt(i)
	.s PropertyName = propObj.Name
	.q:$e(PropertyName,1)="%"
	.q:(saveType=2)&&('$d(valueList(PropertyName)))
	.
	.
	.q:propObj.Cardinality="children"
	.s type = propObj.Type
	.s private = propObj.Private
	.q:private=1
	.s value=""
	.s:$d(valueList(PropertyName)) value =valueList(PropertyName)
	.i $e(type,1)'="%" d
	..d $ZOBJMETHOD(bean,PropertyName_"SetObjectId",value)
	.e  d	
	..i ((type="%Library.Date")||(type="%Date"))&&(value'="") s value=$zdh(value, 3)
	..i ((type="%Library.Time")||(type="%Time"))&&(value'="") s value=$zth(value, 3)
	..s $ZOBJPROPERTY(bean,PropertyName)=value
	
	s sc=bean.%Save()
	s code=0
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	d dcd.%Close()
	k valueList
	s hospflag=0
	s:entity="User.DHCADVModel" dataId=bean.%Id()
	s:entity="User.DHCADVModel" hospflag=##Class(web.DHCADVCOMMON).SaveHOSP("DHC_ADVModel",dataId,hosp)
	q:(entity="User.DHCADVModel")&&(hospflag'=0) -3

	
	q code
}

/// Creator zhouxin
/// CreatDate:2019-05-29
/// Description:批量通用保存
/// @Input:entity:持久类名称
/// parStr:属性名称1$c(1)值1$c(2)属性名称2$c(1)值2
/// saveType:1:更新全部字段，未传入的字典更新为空
/// saveType:2:更新传入字段，未传入的字典不更新 
/// Return:保存成功 0，其他 失败
/// d ##class(web.DHCADVModel).Save("User.DHCADVModelAttr","ID"_$c(1)_"23"_$c(2)_"model"_$c(1)_"6"_$c(2)_"type"_$c(1,2)_"displayTitle"_$c(1)_"Ⅲ级事件"_$c(2)_"seq"_$c(1)_"999"_$c(2)_"class"_$c(1,2)_"func"_$c(1,2)_"filter"_$c(1,2)_"displayRate"_$c(1)_"y"_$c(2)_"measureType"_$c(1)_"count"_$c(2)_"extendType"_$c(1)_"dic"_$c(2)_"hidden"_$c(1)_"n"_$c(2)_"type"_$c(1)_"y"_$c(2)_"displayTotal"_$c(1)_"n","2")
ClassMethod Save(entity, params, saveType = 1, hosp = "")
{
	
	n (entity,params,saveType,hosp)
  	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,$c(3))
  	f i=1:1:len q:ret<0  d
  	.q:ret<0
  	.s ret=##class(web.DHCADVModel).saveOrUpdate(entity,$p(params,$c(3),i),saveType,hosp)
	i ret<0 TRollback
	q:ret<0 ret
	TCOMMIT
	q ret
Err
  TRollback
  w $ze
}

/// Creator:zhouxin
/// CreatDate:2019-05-29
/// Description:通用删除
/// Others:w ##class(web.DHCADVModel).remove("User.DHCADVModel","1")
ClassMethod remove(entity, id)
{
	
	n (entity,id)
	s code=0,msg="success"
	s sc=$classmethod(entity,"%DeleteId",id)
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	.s msg=$SYSTEM.Status.GetErrorText(sc)
	d ##class(web.DHCADVModel).R(code,msg)
	q ""
}

/// Creator:zhouxin
/// CreatDate:2019-05-29
/// Description:通用批量删除
/// Others:w ##class(web.DHCADVModel).removeBath("User.DHCADVModel","1")
ClassMethod removeBath(entity, idStr)
{
	
	n (entity,idStr)
	s $zt="TSErr"
	s code=0,msg="success"
	TS
	f i=1:1:$l(idStr,"^") d
	.q:code'=0
	.s id=+$p(idStr,"^",i)
	.q:id=0
	.s sc=$classmethod(entity,"%DeleteId",id)
	.s:$SYSTEM.Status.IsError(sc) code=-2
	
	i code'=0 TRO
	q:code'=0 code
	TC	
	d ##class(web.DHCADVModel).R(code,msg)
	q ""
TSErr
	TRO
 	d ##class(web.DHCADVModel).R(-999,$Ze)
 	q ""
}

/// Creator:zhouxin
/// CreatDate:2019-05-29
/// 获取属性值
/// w ##class(web.DHCADVModel).EntityToJson("User.DHCADVModelAttr",21)
ClassMethod EntityToJson(entity, id)
{
	n (entity,id)
	s bean=$classmethod(entity,"%OpenId",id)
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(entity)
	s titleStr="",valueStr="",count=1
	i $IsObject(dcd) d
	.s cnt=dcd.Properties.Count()
	.f i=1:1:cnt  d	
	..s propObj = dcd.Properties.GetAt(i)
	..s value=""
	..s PropertyName = propObj.Name
	..q:$e(PropertyName,1)="%"
	..q:propObj.Cardinality="children"
	..set PropertyValue = $ZOBJPROPERTY(bean,PropertyName)
	..set runtimeType = propObj.RuntimeType,type=runtimeType
	..if (runtimeType="%Library.CacheObject")&&$IsObject(PropertyValue) set type=$CLASSNAME(PropertyValue) ;$classname(%String)=val

	..; 指向
	..if $e(type,1)'="%"  set value = $ZOBJMETHOD(bean,PropertyName_"GetObjectId")
	..else  d
	...if value="" s value = PropertyValue			//String , Number
	...if (type["Date")&&(value'="") s value=##class(web.DHCADVCOMMON).DateLogicalToHtml(value) ;$zd(value, 3) 2021-07-15 cy 修改日期根据配置显示
	...if (type["Time")&&(value'="") s value=$zt(value, 3)
	..
	..s count=count+1
	..s $p(titleStr,"^",count)=PropertyName
	..s $p(valueStr,"^",count)=value
	.d dcd.%Close()
	.
	.s $p(titleStr,"^",1)="ID"
	.s $p(valueStr,"^",1)=id
	.
	s dcd=""
	w ##class(web.DHCADVJSONCOMMON).getJsonData(titleStr,valueStr) ;web.DHCAPPJsonCommon
	q ""
}

/// w ##class(web.DHCADVModel).GetEntityPropertyValue("User.DHCAdvMaster","ADVOccurDate",1)
ClassMethod GetEntityPropertyValue(entity, Property, id)
{
	n (entity,Property,id)
	s bean=$classmethod(entity,"%OpenId",id)
	s dcd = ##Class(%Dictionary.CompiledClass).%OpenId(entity)
	s ret="null"
	i $IsObject(dcd) d
	.s cnt=dcd.Properties.Count()
	.f i=1:1:cnt  d	
	..s propObj = dcd.Properties.GetAt(i)
	..s value=""
	..s PropertyName = propObj.Name
	..q:PropertyName'=Property
	..q:$e(PropertyName,1)="%"
	..q:propObj.Cardinality="children"
	..set PropertyValue = $ZOBJPROPERTY(bean,PropertyName)
	..set runtimeType = propObj.RuntimeType,type=runtimeType
	..if (runtimeType="%Library.CacheObject")&&$IsObject(PropertyValue) set type=$CLASSNAME(PropertyValue) ;$classname(%String)=val

	..; 指向
	..if $e(type,1)'="%"  d
	...set value = $ZOBJMETHOD(bean,PropertyName_"GetObjectId")
	...s value=value
	...i runtimeType="User.CTLoc" d
	....s value=$p(^CTLOC(value),"^",2) 
	..else  d
	...if value="" s value = PropertyValue			//String , Number
	...if (type["Date")&&(value'="") s value=##class(web.DHCADVCOMMON).DateLogicalToHtml(value) ;$zd(value, 3) 2021-07-15 cy 修改日期根据配置显示
	...if (type["Time")&&(value'="") s value=$zt(value, 3)
	..s ret=value
	.d dcd.%Close()
	q ret
}

/// /////////////***************************************common method**************************************////////
/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 查询报表
/// d ##class(web.DHCADVModel).ListModel()
ClassMethod ListModel(page = 1, rows = 10, queryCode = "", queryName = "", type = "", hosp = "")
{
  n (page,rows,queryCode,queryName,type,hosp)
  
  s start=(page-1)*rows+1
  s end=page*rows

  s TitleStr="ID^Code^Name^FormNameDesc^FormName^FilterClass^FilterFunc^SubModelDesc^SubModel"

  w "{""rows"":["
  s count=0 
  s id="" f  s id=$o(^DHCADVMODEL(id)) q:id=""  d
  .q:+id=0
  .s code=$p(^DHCADVMODEL(id),"^",1)
  .s name=$p(^DHCADVMODEL(id),"^",2)
  .s formNameId=$p(^DHCADVMODEL(id),"^",3)
  .q:(queryName'="")&&(name'[queryName)
  .q:(queryCode'="")&&(code'[queryCode)
  .s formName=""
  .s:+formNameId'=0 formName=$List(^User.DHCAdvFormNameD(formNameId),3)
  .s FilterClass=$p(^DHCADVMODEL(id),"^",4)
  .s FilterFunc=$p(^DHCADVMODEL(id),"^",5)
  .s reportType=$p(^DHCADVMODEL(id),"^",6)
  .s SubModel=$p(^DHCADVMODEL(id),"^",7)
  .s SubModelDesc=""
  .s:+SubModel'=0 SubModelDesc=$p(^DHCADVMODEL(SubModel),"^",2)
  .q:(type'="")&&(type'=reportType)
  .q:##class(web.DHCADVCOMMON).GetHospShowDataFlag("DHC_ADVModel",id,hosp,"")'="Y"
  .s tmp=id_"^"_code_"^"_name_"^"_formName_"^"_formNameId_"^"_FilterClass_"^"_FilterFunc_"^"_SubModelDesc_"^"_SubModel
  .s count=count+1
  .q:count<start
  .q:count>end
  .w $case(count,start:"",:",")
  .w ##class(web.DHCADVJSONCOMMON).getJsonData(TitleStr,tmp)
  w "],""total"":"_count_"}"
  q ""
}

/// ///////////////////////////////////////////////////////////////////////////////////报表统计
/// Creator:zhouxin
/// CreatDate:2019-05-30
/// 输出table的列头
/// w ##class(web.DHCADVModel).listColumn("",1)
ClassMethod listColumn(code = "", model = "")
{
 

	//s ^Temphhl("model")=code
	n (code,model)
	
	s:code'="" model=+$o(^DHCADVMODEL(0,"Code",code,""))
	q:+model=0 ""
	
	s pid=##class(web.DHCADVCOMMON).NewPid()
	s reportName=$p($g(^DHCADVMODEL(model)),"^",2)
	
	s axis="y"
	
	s colspan=1
	s seq="" f  s seq=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,0,seq)) q:seq=""  d
	.s ma="" f  s ma=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,0,seq,ma)) q:ma=""  d
	..; 2021-05-18 cy str
	..s maExtendType=$p(^DHCADVMODELATTR(ma),"^",13) // 扩展方式 value-取值 dic-字典
	..s:maExtendType="value" colspanSub=0 // 按取值扩展，不获取子元素
	..; 2021-05-18 cy end
    ..s:maExtendType'="value" colspanSub=##class(web.DHCADVModel).getSubColSpan(model,ma,axis,pid,0,1)
	..s columnSeq=##class(web.DHCADVModel).getColumnNextSeq(pid)
	..s column=$p(^DHCADVMODELATTR(ma),"^",3)
	..s ^TMP("web.DHCADVModel","listColumn",pid,1,columnSeq)=ma_"^"_colspanSub
	..i colspanSub=0 d
	...s ^TMP("web.DHCADVModel","columnSeq",pid,columnSeq)=ma
	...s ^TMP("web.DHCADVModel","column",pid,column)=columnSeq
	..s:colspanSub=0 colspanSub=1
	..s colspan=colspan+colspanSub
	..
	..
	s measureStr=##class(web.DHCADVModel).getAxis(model)
	s xAttrId=$p(measureStr,"^",1)
	s measureTitle=$p(measureStr,"^",3)
	
	s lev=$o(^TMP("web.DHCADVModel","listColumn",pid,""),-1)

	w "<tr align='center'>"
	w "	<th colspan="_colspan_"><b style='font-size: 16px'>"_reportName_"</b></th>"
	w "</tr>"
	
	s row="" f  s row=$o(^TMP("web.DHCADVModel","listColumn",pid,row)) q:row=""  d
	.
	.w "<tr align='center'>"
	.i row=1 d
	..s hidden=$case(+xAttrId,0:"n",:$p(^DHCADVMODELATTR(xAttrId),"^",15))
	..s display=$case(hidden,"y":"none",:"") 
	..w "<th rowspan="_lev_" style='display:"_display_"'>"_measureTitle_"</th>"
	.s colum=""  f  s colum=$o(^TMP("web.DHCADVModel","listColumn",pid,row,colum)) q:colum=""  d
	..s str=^TMP("web.DHCADVModel","listColumn",pid,row,colum)
	..
	..s attrId=$p(str,"^",1)
	..s col=$p(str,"^",2)
	..s title=$p(^DHCADVMODELATTR(attrId),"^",6)
	..s hidden=$p(^DHCADVMODELATTR(attrId),"^",15)
	..; 2021-05-18 cy str
	..s atExtendType=$p(^DHCADVMODELATTR(attrId),"^",13) // 扩展方式 value-取值 dic-字典
	..s rowspan=1
	..s subFlag=##class(web.DHCADVModel).checkSubAttr(model, axis, attrId)
	..s:atExtendType="value" subFlag=0 // 按取值扩展，不合并子元素列（因为子元素不显示）
	..s:subFlag=0 rowspan=lev-row+1
	..; 2021-05-18 cy end
	..s display=$case(hidden,"y":"none",:"")
	..s:$d(^TMP("web.DHCADVModel","columnTotal",pid,colum)) title="合计"
	..w "	<th colspan="_col_" rowspan="_rowspan_" style='display:"_display_"' id="_attrId_">"_title_"</th>"
	.w "</tr>"
	
	//k ^TMP("web.DHCADVModel","listColumn",pid)
	q pid
}

/// ##class(web.DHCADVModel).checkSubAttr(model, axis, attr)
ClassMethod checkSubAttr(model, axis, attr)
{
	n (model,axis,attr)
	q:+attr=0 0
	s sub=+$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,attr,""))
	q:sub=0 0
	q sub
}

ClassMethod getSubColSpan(model, parent, axis, pid, count = 0, lev)
{
	n (model,parent,axis,pid,count,lev)
	
	s lev=lev+1
	
	s seq="" f  s seq=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,parent,seq)) q:seq=""  d
	.s ma="" f  s ma=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,parent,seq,ma)) q:ma=""  d
	..
	..s tmpSub=##class(web.DHCADVModel).checkSubAttr(model,axis,ma)
	..; 2021-05-18 cy str
	..s maExtendType=$p(^DHCADVMODELATTR(ma),"^",13) // 扩展方式 value-取值 dic-字典
	..s:maExtendType="value" tmpSub=0 // 按取值扩展，不合并子元素列（因为子元素不显示）
	..; 2021-05-18 cy end
	..
	..s beforeCount=count
	..i tmpSub=0 d
	...s count=count+1
	..e  d
	...s count=##class(web.DHCADVModel).getSubColSpan(model,ma,axis,pid,count,lev)
	..
	..s subCount=count-beforeCount
	..s:tmpSub=0 subCount=1
	..
	..s columnSeq=##class(web.DHCADVModel).getColumnNextSeq(pid)
	..s ^TMP("web.DHCADVModel","listColumn",pid,lev,columnSeq)=ma_"^"_subCount
	..i tmpSub=0 d
	...s ^TMP("web.DHCADVModel","columnSeq",pid,columnSeq)=ma
	...s column=$p(^DHCADVMODELATTR(ma),"^",3)
	...s ^TMP("web.DHCADVModel","column",pid,column)=columnSeq
	
	s displayTotal=$p(^DHCADVMODELATTR(parent),"^",16)
	s extendType=$p(^DHCADVMODELATTR(parent),"^",13)
	i (displayTotal="y")&&(extendType="dic") d
	.s columnSeq=##class(web.DHCADVModel).getColumnNextSeq(pid)
	.s ^TMP("web.DHCADVModel","listColumn",pid,lev,columnSeq)=parent_"^"_1
	.s ^TMP("web.DHCADVModel","columnSeq",pid,columnSeq)=parent
	.s ^TMP("web.DHCADVModel","columnTotal",pid,columnSeq)=parent
	.s count=count+1
	q count
}

ClassMethod killTmp(pid)
{
	n (pid)
	k ^TMP("web.DHCADVModel","listData",pid)
	k ^TMP("web.DHCADVModel","attrCount",pid)
	k ^TMP("web.DHCADVModel","tmpData",pid)
	k ^TMP("web.DHCADVModel","TotalCount",pid)
}

/// Creator:zhouxin
/// CreatDate:2019-06-3
/// 动态统计报表
/// Input:
///          st|	yyyy-mm-dd   |开始日期
///          ed|    yyyy-mm-dd   |结束日期
///       model|    dhc_advmodel |模板id
///         pid|    Integer      | 
///        page|    Integer      |当前页数 
///        rows|    Integer      |每页条数
///    pageFlag|    Integer      |分页标志(1:不分页|其他；分页)
///      parStr|    String       |参数串,具体格式参考(##class(web.DHCADVModel).checkCondition)
/// Others:w ##class(web.DHCADVModel).listData("01/03/2019","15/03/2020","11","35","1","15","","","2^1^1^1")
ClassMethod listData(st, ed, model, pid, page = "", rows = "", pageFlag = "", parStr = "", params)
{
	n (st,ed,model, pid,page,rows,pageFlag,parStr,params)
	 //hxy 2020-02-26 st
	s UserId=$p(params,"^",1)
	s LocId=$p(params,"^",2)
	s GroupId=$p(params,"^",3)
	s LogHospID=$p(params,"^",4)
	S list=UserId_"^"_LocId_"^"_GroupId
	S IFDISTHOSP=##class(web.DHCADVCOMMON).GetEmSysConfig("IFDISTHOSP",params)
	S DateNode="RepDate"  ; 2021-02-22 cy DateNode 索引节点  QUERYDATE 1:根据发生日期查询报告，其他：根据报告日期查询报告。
	S QUERYDATE=##class(web.DHCADVCOMMON).GetEmSysConfig("QUERYDATE",params)
	S:QUERYDATE="1" DateNode="OccurDate"
	
	s:+page=0 page=1
	s:+rows=0 rows=10
	s start=(page-1)*rows+1  //开始行数
	s end=page*rows          //结束行数
	s reportName=$p($g(^DHCADVMODEL(model)),"^",2)
	s formName=$p($g(^DHCADVMODEL(model)),"^",3)
	
	s st=##class(websys.Conversions).DateHtmlToLogical(st)
	s ed=##class(websys.Conversions).DateHtmlToLogical(ed)
	
	d ##class(web.DHCADVModel).killTmp(pid)
	
	s xAxis=##class(web.DHCADVModel).getAxis(model,"x")
	s yAxis=##class(web.DHCADVModel).getAxis(model,"y")
	
	s xAttrId=$p(xAxis,"^",1)
	s xMeasureType=$p(xAxis,"^",2)
	s xTitle=$p(xAxis,"^",3)
	s xDic=$p(xAxis,"^",4)
	s xColumnType=$p(xAxis,"^",5)
	s xDisplayRate="n"
	s xDisplayTotal="n"
	s:+xAttrId'=0 xDisplayRate=$p(^DHCADVMODELATTR(xAttrId),"^",9)
	s:+xAttrId'=0 xDisplayTotal=$p(^DHCADVMODELATTR(xAttrId),"^",16)
	
	s yAttrId=$p(yAxis,"^",1)
	s yTitle=$p(yAxis,"^",3)
	s yDic=$p(yAxis,"^",4)
	s yExtendType=$p(^DHCADVMODELATTR(yAttrId),"^",13)
	s yDisplayTotal=$p(^DHCADVMODELATTR(yAttrId),"^",16)
	
	s:xTitle="" xTitle=yTitle
	

	i yExtendType="value" d
	.d ##class(web.DHCADVModel).removeAttrColumn(yAttrId,pid)
	
	F date=st:1:ed d
	.S adv="" F  S adv=$o(^DHCADVMASTER(0,DateNode,date,adv)) q:adv=""  d
	..S recordId=$p(^DHCADVMASTER(adv),"^",1)
	..S RepLoc=$p(^DHCADVMASTER(adv),"^",7) //hxy 2020-02-26 st
	..S RepHospID=""
	..S:RepLoc'="" RepHospID=$p($g(^CTLOC(+RepLoc)),"^",22) 
	..q:(IFDISTHOSP="1")&(RepHospID'="")&(LogHospID'="")&(LogHospID'=RepHospID) //登录科室医院不同于报告科室医院退出 ed
	..S RepTypeDr=$p(^DHCADVMASTER(adv),"^",2)
	..S RepTypeCode=""
	..S:(RepTypeDr'="")&&(RepTypeDr'["||") RepTypeCode=$p(^DHCMEDADREVT(RepTypeDr),"^",1)
	..S:(RepTypeDr'="")&&(RepTypeDr["||") RepTypeCode=$p(^DHCMEDADREVTI(+RepTypeDr,"MADREVI",$p(RepTypeDr,"||",2)),"^",1)
	..Q:(RepTypeCode'="")&&(##class(web.DHCADVFormName).CheckFormName(RepTypeCode,LogHospID)'=1) ;2021-04-28 cy 多院区改造 表单医院区分
	..S RepUserDr=$p(^DHCADVMASTER(adv),"^",6)
	..S RepList=RepTypeDr_"^"_RepLoc_"^"_RepUserDr_"^"_adv 
	..S flag=##class(web.DHCADVSEARCHREPORT).CheckQuerySec(RepList,params)
	..Q:((flag'="")&&(flag'=1))	
	..s recordFormName=$LG(^User.DHCAdvFormRecordD(recordId),2)
	..q:(+formName'=0)&&(formName'=recordFormName)
	..
	..q:##class(web.DHCADVModelFilter).CheckModelFilter(model,recordId)=0  //报表定义的过滤函数
	..q:##class(web.DHCADVModel).checkCondition(parStr,recordId,date)=0    //报表界面的动态查询条件
	../// 2021-06-15 cy 二维统计 st
	..s xkeylist=##class(web.DHCADVModel).getKeyByMeasure(xAxis,date,adv)        //  获取x轴扩展的值
	..s xkeylen=$L(xkeylist,"^")
	..f i=1:1:xkeylen d
 	...s xkey=$p(xkeylist,"^",i)
	...q:xkey=""
	...s xkeyflag=0
	...s:xkey'[$c(2) xkeyflag=1 
	...s:xkey[$c(2) xkeyflag=$p(xkey,$c(2),2)
	...s:xkey[$c(2) xkey=$p(xkey,$c(2),1)
	...;w "xkey:"_xkey,!
	...//y轴按数据动态扩展情况，不是按子元素扩展情况
	...i yExtendType="value" d
	....s ykey=##class(web.DHCADVModel).getKeyByMeasure(yAxis,date,adv)
	....;w "ykey:"_ykey,!
	....i ykey'="" d
	.....s ^TMP("web.DHCADVModel","columnSeq",pid,ykey)=yAttrId
	.....s num=+$g(^TMP("web.DHCADVModel","listData",pid,xkey,ykey)) //计数
	.....s:xkeyflag=1 num=num+1
	.....s ^TMP("web.DHCADVModel","listData",pid,xkey,ykey)=num
	....i yDisplayTotal="y" d
	.....s ^TMP("web.DHCADVModel","columnSeq",pid,"合计")=yAttrId
	.....s ^TMP("web.DHCADVModel","listData",pid,xkey,"合计")=1+$g(^TMP("web.DHCADVModel","listData",pid,xkey,"合计"))
	...q:yExtendType="value"
	...//字典情况
	...s ^TMP("web.DHCADVModel","listData",pid,xkey)=1
	...s column="" f  s column=$o(^TMP("web.DHCADVModel","column",pid,column)) q:column=""  d
	....s recordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",recordId,column,""))
	....;q:recordItm=0
	....s ConDicId="",recordItmValue=""
	....s:recordItm=0 ConDicId=..GetDicContrast(column, recordId)		//取对照元素
	....s:+ConDicId'=0 recordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",recordId,ConDicId,""))
	....; 2021-05-19 cy str
	....s:recordItm'=0 recordItmValue=$LG(^User.DHCAdvFormRecordItmD(recordItm),4)
	....;I (recordItm=0)&&($d(^User.DHCAdvFormRecordItmI("IndexRefFormDic",recordId,column))) D
	....s ItmValueList=##class(web.DHCADVModel).GetSubDicValList(recordId, column)
	....s:ItmValueList'="" recordItmValue=ItmValueList
	....q:(recordItm=0)&&(recordItmValue="")
	....; 2021-05-19 cy end
	....s seq=^TMP("web.DHCADVModel","column",pid,column)
	....s attrId=^TMP("web.DHCADVModel","columnSeq",pid,seq)
	....i xMeasureType="value" d 
	.....s num=recordItmValue   //取值
	....e  d
	.....s num=+$g(^TMP("web.DHCADVModel","listData",pid,xkey,seq)) //计数
	.....s:xkeyflag=1 num=num+1
	....s ^TMP("web.DHCADVModel","listData",pid,xkey,seq)=num_"^"_attrId
	.../// 2021-06-15 cy 二维统计修改 ed
	//计算字典的合计列
	s seq="" f  s seq=$o(^TMP("web.DHCADVModel","columnTotal",pid,seq)) q:seq=""  d
	.s x="" f  s x=$o(^TMP("web.DHCADVModel","listData",pid,x)) q:x=""  d
	..s count=0
	..s y="" f  s y=$o(^TMP("web.DHCADVModel","listData",pid,x,y)) q:y=""  d
	...s count=count+^TMP("web.DHCADVModel","listData",pid,x,y)
	..s ^TMP("web.DHCADVModel","listData",pid,x,seq)=count
	///计算比率
	i xDisplayRate="y" d
	.k columnYTotal
	.k columnX
	.s x="" f  s x=$o(^TMP("web.DHCADVModel","listData",pid,x)) q:x=""  d
	..s total=+$g(^TMP("web.DHCADVModel","listData",pid,x,"合计"))
	..
	..s count=0
	..s y=""  f  s y=$o(^TMP("web.DHCADVModel","listData",pid,x,y)) q:y=""  d
	...s columnX(x,y)=^TMP("web.DHCADVModel","listData",pid,x,y)
	...q:$d(^TMP("web.DHCADVModel","columnTotal",pid,y))
	...s count=count+^TMP("web.DHCADVModel","listData",pid,x,y)
	..s columnYTotal(x)=count
	..s:total'=0 columnYTotal(x)=total
	..
	..
	..
	.s x="" f  s x=$o(columnYTotal(x)) q:x=""  d
	..s total=columnYTotal(x)
	..s newX=x_"(百分比%)"
	..s ^TMP("web.DHCADVModel","listData",pid,newX)=""
	..s y="" f  s y=$o(columnX(x,y)) q:y=""  d
	...s num=columnX(x,y)
	...s rate="0%"
	...i (total'=0)&&(num'=0) d
	....s rate=$fn(num/total*100,"",2)_"%"
	...s ^TMP("web.DHCADVModel","listData",pid,newX,y)=rate
	.k columnYTotal
	.k columnX
	
	s titleDicStr=xDic
	s titleStr=""
	s titleCount=1
	s titleTypeStr=xColumnType
	s titleHtml="<th>"_xTitle_"</th>"
	s titleHidden=$case(+xAttrId,0:"n",:$p(^DHCADVMODELATTR(xAttrId),"^",15))
	s countSeq="" f  s countSeq=$o(^TMP("web.DHCADVModel","columnSeq",pid,countSeq)) q:countSeq=""  d
	.//w "countSeq:"_countSeq,!
	.s ma=$p(^TMP("web.DHCADVModel","columnSeq",pid,countSeq),"^",1)
	.
	.s dic=$p(^DHCADVMODELATTR(ma),"^",3)
    .s title=countSeq
    .s:+dic'=0 title=$ListGet(^User.DHCAdvFormDicD(dic),4)
    .s:yExtendType="value" title=countSeq   /// 2021-06-15 cy 二维统计修改，显示x轴数据
	.s $p(titleStr,"^",titleCount)=title
	.s titleCount=titleCount+1
    .s $p(titleDicStr,"^",titleCount)=dic
	.s $p(titleTypeStr,"^",titleCount)=$p(^DHCADVMODELATTR(ma),"^",5)
	.s titleHtml=titleHtml_"<th>"_title_"</th>"
	.s $p(titleHidden,"^",titleCount)=$p(^DHCADVMODELATTR(ma),"^",15)
	
	
	s:yExtendType'="value" titleHtml=""
	
	
	//***********************************************输出数据****************************************/	
	
	s subModel=+$p(^DHCADVMODEL(model),"^",7)  //子报表，弹出报表
	
	s count=0
	w "{""rows"":["
	s key=""  f  s key=$o(^TMP("web.DHCADVModel","listData",pid,key)) q:key=""  d
	.
	.s count=count+1
    .q:(count<start)&&(pageFlag'=1)
    .q:(count>end)&&(pageFlag'=1)
	.
	.w $case(count,start:"",:",")
	.
	.s rowData=0
	./// 2021-06-11 cy 目的x轴取子元素时按顺序显示 st
	.s:key'[$c(1) $p(rowData,"^",1)=key
	.s:key[$c(1) $p(rowData,"^",1)=$p(key,$c(1),2)
	./// 2021-06-11 cy ed
	.s countColum=1
	.s countSeq="" f  s countSeq=$o(^TMP("web.DHCADVModel","columnSeq",pid,countSeq)) q:countSeq=""  d
	..s str=^TMP("web.DHCADVModel","columnSeq",pid,countSeq)
	..s attrId=$p(str,"^",1)
	..s value=$g(^TMP("web.DHCADVModel","listData",pid,key,countSeq))
	..s columvalue=$p(^DHCADVMODELATTR(attrId),"^",3)
	..s className=$p(^DHCADVMODELATTR(attrId),"^",10)
	..s classMethod=$p(^DHCADVMODELATTR(attrId),"^",7)
	..i (className'="")&&(classMethod'="")&&(+columvalue'=0) d
	...s value=$classmethod(className,classMethod,key_"^"_pid_"^"_attrId)
	..s value=$p(value,"^",1)
	..s countColum=countColum+1
	..; 2021-05-18 cy str
	..s atMeasureType=$p(^DHCADVMODELATTR(attrId),"^",12)  //度量类型 value-取值 count-计数
	..s:(atMeasureType'="value")&&(value="") value=0
	..S:(value["-")&&($L(value)="10")&&($L(value,"-")="3") value=##class(web.DHCADVCOMMONPART).GetDateToHtml(value)  /// 2021-07-15 cy 修改日期根据配置显示
	..; 2021-05-18 cy end
	..s $p(rowData,"^",countColum)=value
	.s ^TMP("DHCADV","web.DHCADVModel","CountTotal",pid,count)=rowData
	.w "{""value"":"""_rowData_"""}"
	i xDisplayTotal="y"  d
	.s CountData=..CountTotal(pid)
	.w ",{""value"":"""_CountData_"""}"
	w "],""total"":"_count_""
	w ",""titleDicStr"":"""_titleDicStr_""""
	w ",""titleTypeStr"":"""_titleTypeStr_""""
	w ",""titleStr"":"""_titleStr_""""
	w ",""titleHtml"":"""_titleHtml_"""" 
	w ",""titleHidden"":"""_titleHidden_"""" 
	w ",""reportName"":"""_reportName_""""
	w ",""subModel"":"""_subModel_"""}"
	
	d ##class(web.DHCADVModel).killTmp(pid)
	q ""
}

/// Descript:取x轴合计数据
/// w ##class(web.DHCADVModel).CountTotal(236)
ClassMethod CountTotal(pid)
{
	n (pid)
	s RetStr=""
	s TempList=^TMP("DHCADV","web.DHCADVModel","CountTotal",pid,1)
	s Len=$L(TempList,"^")
	for i=2:1:Len  d
	.s PLIST(i)=""
	
	s Index=""
	for  s Index=$o(^TMP("DHCADV","web.DHCADVModel","CountTotal",pid,Index))  Q:Index=""  d
	.s Data=^TMP("DHCADV","web.DHCADVModel","CountTotal",pid,Index)
	.s sLen=$L(Data,"^")
	.for j=2:1:sLen  d
	..s value=$p(Data,"^",j)
	..i PLIST(j)=""  s PLIST(j)=value
	..e  s PLIST(j)=PLIST(j)+value
	
	s count=1
	for k=2:1:Len  d
	.s $p(RetStr,"^",count)=PLIST(k)
	.s count=count+1
	
	s RetStr="合计"_"^"_RetStr
	Q RetStr
}

/// Descript:取元素对照数据
/// w ##class(web.DHCADVModel).GetDicContrast(89001,43)
ClassMethod GetDicContrast(DicId, RecordId)
{
	n (DicId,RecordId)
	Q:DicId="" 0
	s DicCode=$LG(^User.DHCAdvFormDicD(DicId),2)
	s ForNameId=$LG(^User.DHCAdvFormRecordD(RecordId),2)
	s FormNameCode=$LG(^User.DHCAdvFormNameD(ForNameId),2)
	Q:'$d(^DHCADVDC(0,"FromCode",0,DicCode,FormNameCode)) 0
	s FormDicCode=$o(^DHCADVDC(0,"FromCode",0,DicCode,FormNameCode,""))
	s FormDicId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(FormDicCode),""))
	Q FormDicId
}

/// Creator:zhouxin
/// CreatDate:2019-065-3
/// 获取输出列的下一个位置
/// Others:w ##class(web.DHCADVModel).getColumnNextSeq(111)
ClassMethod getColumnNextSeq(pid)
{
	n (pid)
	q $i(^TMP("web.DHCADVModel","listSeq",pid))
}

/// Creator:zhouxin
/// CreatDate:2019-06-13
/// 获取报表统计列
/// Others:w ##class(web.DHCADVModel).getKeyByMeasure(111)
/// w ##class(web.DHCADVModel).getDicKey(93442,100,"dic")
ClassMethod getKeyByMeasure(measureStr, date, master)
{
	n (measureStr, date, master)
	s attrId=$p(measureStr,"^",1) 
	s measureTitle=$p(measureStr,"^",3)
	q:+attrId=0 "发生例数"    //没有维护x轴或者y轴的情况
	s columType=$p(^DHCADVMODELATTR(attrId),"^",5)
	s recordId=$p(^DHCADVMASTER(master),"^",1)
	s colum=$p(^DHCADVMODELATTR(attrId),"^",3)
    s extendType=$p(^DHCADVMODELATTR(attrId),"^",13)
    s model=$p(^DHCADVMODELATTR(attrId),"^",1)
    s type=$p(^DHCADVMODELATTR(attrId),"^",2)
    q:colum="" $p(^DHCADVMODELATTR(attrId),"^",6)
    q:(columType="dic")&&(type="x")&&($d(^DHCADVMODELATTR(0,"TypeParent",model,"x",attrId))) ##class(web.DHCADVModel).getDicKeyList(model,attrId,recordId)   /// 2021-06-15 cy 取二维x轴数据串
	q:columType="dic" ##class(web.DHCADVModel).getDicKey(colum,recordId,extendType)
	q:columType="dateRange" ##class(web.DHCADVModel).getDateRangeKey(date,colum)
	
	q ##class(web.DHCADVModel).getEntityKey(attrId,master)
}

/// Description: 获取x轴子元素数据串（按顺序输出）
/// Creator:     CongYue
/// CreateDate:  2021-06-11 
/// Table:		 DHC_ADVModelAttr
/// Input:  	 模板id ,x轴元素属性 父级id指向  , 表单保存数据记录id  
/// Return:  	 x轴元素子元素数据串($c(1)前拼接h:用来global排序;$c(2)后拼接flag:0无数据,1有数据; ^-拼接数据串)，如：1$c(2)住院$c(1)0^2$c(2)门诊$c(1)0^3$c(2)急诊$c(1)0^4$c(2)体检$c(1)1
/// /// 2021-06-11 cy 目的x轴取子元素时按顺序显示 st
/// Others:w ##class(web.DHCADVModel).getDicKeyList(17,877,1)
ClassMethod getDicKeyList(model, attrId, recordId)
{
	n (model,attrId,recordId)
	s list="" ,h=0
	s xcolseq="" f  s xcolseq=$o(^DHCADVMODELATTR(0,"TypeParent",model,"x",attrId,xcolseq)) q:xcolseq=""  d
	.s xcolattr="" f  s xcolattr=$o(^DHCADVMODELATTR(0,"TypeParent",model,"x",attrId,xcolseq,xcolattr)) q:xcolattr=""  d
	..s h=h+1
	..s xcoldic=$p(^DHCADVMODELATTR(xcolattr),"^",3)
	..s xkey=$ListGet(^User.DHCAdvFormDicD(xcoldic),4)
	..s flag=0
	..s:$d(^User.DHCAdvFormRecordItmI("IndexDic",recordId,xcoldic)) flag=1 
	..s:list'="" list=list_"^"_h_$c(1)_xkey_$c(2)_flag
	..s:list="" list=h_$c(1)_xkey_$c(2)_flag
	q list
}

/// 获取字典key
/// Others:w ##class(web.DHCADVModel).getEntityKey(803,1)
ClassMethod getEntityKey(attrId, master)
{
	n (attrId, master)
	q:+attrId=0 ""
	s columType=$p(^DHCADVMODELATTR(attrId),"^",5)
	s colum=$p(^DHCADVMODELATTR(attrId),"^",3)
	
	s classname=$p(^DHCADVMODELATTR(attrId),"^",10)
	s funcname=$p(^DHCADVMODELATTR(attrId),"^",7)
	
	q:colum="%ID" master
	s:(classname="")||(funcname="") value=##class(web.DHCADVModel).GetEntityPropertyValue(columType,colum,master)
	s:(classname'="")&&(funcname'="") value=$classmethod(classname,funcname,master)
	q value
}

/// 获取字典key
/// Others:w ##class(web.DHCADVModel).getDicKey(95455,100,"dic")
ClassMethod getDicKey(keyDic, recordId, extendType = "")
{
	n (keyDic,recordId,extendType)
	s key=""
	q:+keyDic=0 key
	s recordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",recordId,keyDic,""))
	i extendType="dic" d
	.s:recordItm'=0 key=$ListGet(^User.DHCAdvFormDicD(keyDic),4)
	.s:key="" key=##class(web.DHCADVModel).getSubDicKey(keyDic,recordId,extendType)
	e  d 
	.s:recordItm'=0 key=$LG(^User.DHCAdvFormRecordItmD(recordItm),4)
	.s:key="" key=##class(web.DHCADVModel).getSubDicKey(keyDic,recordId,extendType)
	
	i key="" d
	.s link="" f  s link=$o(^User.DHCAdvFormRecordI("IndexLink",recordId,link)) q:link=""  d
	..//w "link:"_link,!
	..q:key'=""
	..s key=##class(web.DHCADVModel).getDicKey(keyDic,link,extendType)
	..//w "key:"_key,!
	q key
}

/// Others:w ##class(web.DHCADVModel).getSubDicKey(93442,100,"dic")
ClassMethod getSubDicKey(keyDic, recordId, extendType)
{
	n (keyDic,recordId,extendType)
	s key="",subDic=""
	f  s subDic=$o(^User.DHCAdvFormDicI("IndexParef"," "_keyDic,subDic)) q:(subDic="")||(key'="")  d
	.s recordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",recordId,subDic,""))
	.
	.i extendType="dic" d
	..s:recordItm'=0 key=$ListGet(^User.DHCAdvFormDicD(subDic),4)
	..s:key="" key=##class(web.DHCADVModel).getSubDicKey(subDic,recordId,extendType)
	.e  d
	..s:recordItm'=0 key=$LG(^User.DHCAdvFormRecordItmD(recordItm),4)
	..s:key="" key=##class(web.DHCADVModel).getSubDicKey(subDic,recordId,extendType)
	q key
}

/// Others:w ##class(web.DHCADVModel).removeAttrColumn(93442,100,"dic")
ClassMethod removeAttrColumn(yAttrId, pid)
{
	n (yAttrId, pid)
	

	s columnSeqTmp=""
	s columnSeq="" f  s columnSeq=$o(^TMP("web.DHCADVModel","columnSeq",pid,columnSeq)) q:columnSeq=""  d
	.s ma=^TMP("web.DHCADVModel","columnSeq",pid,columnSeq)
	.q:yAttrId'=ma
	.s columnSeqTmp=columnSeq
	q:columnSeqTmp=""
	k ^TMP("web.DHCADVModel","columnSeq",pid,columnSeqTmp)
	
	s model=$p(^DHCADVMODELATTR(yAttrId),"^",1)
	s axis=$p(^DHCADVMODELATTR(yAttrId),"^",2)
	s seq="" f  s seq=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,yAttrId,seq)) q:seq=""  d
	.s ma="" f  s ma=$o(^DHCADVMODELATTR(0,"TypeParent",model,axis,yAttrId,seq,ma)) q:ma=""  d
	..d ##class(web.DHCADVModel).removeAttrColumn(ma,pid)
	q ""
}

/// 获取日期key
/// Others:w ##class(web.DHCADVModel).getDateRangeKey()
ClassMethod getDateRangeKey(date, colum)
{
	
	n (date,colum)
	s YEAR=$SYSTEM.SQL.YEAR($zd(date,3))
	s MONTH=$SYSTEM.SQL.MONTH($zd(date,3))
	s QUARTER=$SYSTEM.SQL.QUARTER($zd(date,3))
	s WEEK=$SYSTEM.SQL.WEEK($zd(date,3))
	
	s YEARKEY=YEAR
	s QUARTERKEY=YEAR_"-"_QUARTER
	s MONTHKEY=YEAR_"-"_MONTH
	s WEEKKEY=YEAR_"-"_WEEK
	
	q $CASE(colum,"year":YEARKEY,"quarter":QUARTERKEY,"month":MONTHKEY,"week":WEEKKEY,"day":$zd(date,3),:date)
}

/// 获取x,y轴的信息
/// Others:w ##class(web.DHCADVModel).getAxis(4)
ClassMethod getAxis(model, type = "x")
{
	n (model,type)
	s ret="",count=0
	
	s seq="" f  s seq=$o(^DHCADVMODELATTR(0,"TypeParent",model,type,0,seq)) q:seq=""  d
	.s attrId="" f  s attrId=$o(^DHCADVMODELATTR(0,"TypeParent",model,type,0,seq,attrId)) q:attrId=""  d
	..s count=count+1
	..s column=$p(^DHCADVMODELATTR(attrId),"^",3)        
	..s measure=$p(^DHCADVMODELATTR(attrId),"^",11)
	..s measureType=$p(^DHCADVMODELATTR(attrId),"^",12)  //取值类型
	..s columType=$p(^DHCADVMODELATTR(attrId),"^",5)     //轴类型
	..s displayTitle=$p(^DHCADVMODELATTR(attrId),"^",6)
	..s measureTitle=column
	..
	..i columType="dic" d
	...s measureTitle=$ListGet(^User.DHCAdvFormDicD(column),4)
	..i columType="dateRange" d
	...s measureTitle=##class(web.DHCADVModelDesign).GetDateRangeDesc(column)
	..
	..s:measureType="" measureType="count"
	..s:displayTitle'="" measureTitle=displayTitle
	..s $p(ret,$c(1),count)=attrId_"^"_measureType_"^"_measureTitle_"^"_column_"^"_columType
	q ret
}

/// <pre>过滤动态查询条件</pre>
/// Input:
///       比较类型_$c(1)_列_$c(1)_值_$c(1)_columType_$c(1)_逻辑关系
///       比较类型:
///         	  1:字典值存在（判断该字典是否有值存在）
///         	  2:字典值比较（对该字典的值进行逻辑判断) 
/// Others:w ##class(web.DHCADVModel).checkCondition("",6)
ClassMethod checkCondition(parStr, recordId, date = "")
{
	n (parStr,recordId,date)
	//s ^ZXZX(recordId)=parStr
	//s parStr="2"_$c(1)_"89037"_$c(1)_"内分泌科护理单元^1"_$c(1)_"94110"
	//s parStr="1"_$c(1)_"94111"_$c(1)_"Ⅰ级(radio)"_$c(1)_"dic"_$c(1)_"="_$c(1)_"and^2"_$c(1)_"94387"_$c(1)_"0000000037"_$c(1)_"dic"_$c(1)_"="_$c(1)_"and"

	q:parStr="" 1
	s ret=1
	f i=1:1:$l(parStr,"^") d

	.s dicStr=$p(parStr,"^",i)
	.//比较类型_$c(1)_列_$c(1)_值_$c(1)_columType_$c(1)_运算符_$c(1)_逻辑关系
	.s type=$p(dicStr,$c(1),1)
	.s column=$p(dicStr,$c(1),2)
	.s columnValue=$p(dicStr,$c(1),3)
	.s columType=$p(dicStr,$c(1),4)
	.s columnOp=$p(dicStr,$c(1),5)
	.s columnCondition=$p(dicStr,$c(1),6)
	.
	.s:columnOp="" columnOp="="
	.s:columnCondition="" columnCondition="and"
	.q:column=""
	.
	.q:(columnCondition="and")&&(ret=0)
	.q:(columnCondition="or")&&(ret=1)
	.s Flag=0
	.
	.i columType="dateRange" d
	..s key=##class(web.DHCADVModel).getDateRangeKey(date,column)
	..
	..s:key=columnValue Flag=1
	.
	.i columType="dic" d
	..s recordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",recordId,column,""))
	..q:recordItm=0
	..s:type=1 Flag=1
	..q:type=1
	..s value=""""_$LG(^User.DHCAdvFormRecordItmD(recordItm),4)_""""
	..s xcode=" s Flag="_value_columnOp_""""_columnValue_""""
	..x xcode
	.
	.s:Flag=0 ret=0
	//s:19=recordId ^ZXZX(recordId)=ret
	q ret
}

ClassMethod R(code, msg) As %String
{
	w ##class(web.DHCADVJSONCOMMON).getJsonData("code^msg",code_"^"_msg)
	q ""
}

/// Descript:查询统计模板
/// Creator:sufan
/// CreateDate：2020-02-21
/// w ##class(web.DHCADVModel).GetModelInfo("StatByMedical")
ClassMethod GetModelInfo(code = "", model = "") As %String
{
	s:code'="" model=+$o(^DHCADVMODEL(0,"Code",code,""))
	q:+model=0 ""
	s Str= ##class(web.DHCADVModel).listColumn(code,model)
	s pid=+Str
	q Str_"$$"_pid_"$$"_model
}

// desc: 取类的属性和方法

/// Description: 获取类方法名称（函数方法名称下拉数据）
/// Creator:     congyue
/// CreateDate:  2021-05-13
/// Input:  	 类名Description
/// Return: 	 函数方法下拉数据
/// Others:		 w ##class(web.DHCADVModel).QueryMethodCombo("web.DHCADVModelFun")
ClassMethod QueryMethodCombo(ClsName)
{
	N (ClsName)
	S ClsObj = ##class(%Dictionary.ClassDefinition).%OpenId(ClsName)
	S count = ClsObj.Methods.Count()
	W "["
	for i = 1:1:count {
		S Method=ClsObj.Methods.GetAt(i).Name   ; 获取类方法
		S MethodName=$p(ClsObj.Methods.GetAt(i).Description,$c(10),1) ;获取类方法注释
		Q:(MethodName="")
		S tmp=Method_"^"_MethodName
		I i=1 D
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text",tmp)
	}
	W "]"
	Q ""
}

/// Description: 获取元素数据值（）
/// Creator:     congyue
/// CreateDate:  2021-05-13
/// Input:  	 类名Description
/// Return: 	 函数方法下拉数据
/// Others:		 w ##class(web.DHCADVModel).QueryMethodCombo("web.DHCADVModelFun")
ClassMethod GetDicValList(RecordId, FormDic)
{
	N (RecordId,FormDic)
	;...I (recordItm=0)&&($d(^User.DHCAdvFormRecordItmI("IndexRefFormDic",recordId,column))) D
	s subdic="",DicList=""
	f  s subdic=$o(^User.DHCAdvFormRecordItmI("IndexRefFormDic",recordId,FormDic,subdic)) q:subdic=""  d
	.s recordItm=$o(^User.DHCAdvFormRecordItmI("IndexRefFormDic",recordId,FormDic,subdic,""))
	.s subValue=$LG(^User.DHCAdvFormRecordItmD(recordItm),4)
	.s:recordItmValue'="" recordItmValue=recordItmValue_"，"_subValue
	.s:recordItmValue="" recordItmValue=subValue
}

/// Description: 获取元素数据值（）
/// Creator:     congyue
/// CreateDate:  2021-05-13
/// Input:  	 类名Description
/// Return: 	 函数方法下拉数据
/// Others:		 w ##class(web.DHCADVModel).GetSubDicValList("27","94662")
ClassMethod GetSubDicValList(RecordId, FormDic)
{
	N (RecordId,FormDic)
	S List=""
	S Pid = ##class(web.DHCADVCOMMON).NewPid()
	S FormDicCode=$lg(^User.DHCAdvFormDicD(FormDic),2)
	S ParentDicCode=$p(FormDicCode,"-",1)
	S ParentDicId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(ParentDicCode),""))
	S PatentStyle=""
	S:ParentDicId'="" PatentStyle=$lg(^User.DHCAdvFormDicD(ParentDicId),3)
	S:(PatentStyle'="table")&&(PatentStyle'="datagrid") List=##class(web.DHCADVRepPrint).QueryDataInfo(RecordId,"",FormDicCode, Pid)
	S:(PatentStyle="table")||(PatentStyle="datagrid") List=##class(web.DHCADVModel).GetTableData(RecordId,ParentDicCode,FormDicCode, Pid)
	
	Q List
}

/// Descript:	取table数据
/// Creator: congyue
/// Input: 		报告主表ID,table唯一标识，指定列元素code
/// w ##class(web.DHCADVModel).GetTableData(32,"SuspectNewDrug","")
ClassMethod GetTableData(ADVFormRecDr, TableParrefCode, SelItmID, repid)
{
	n (ADVFormRecDr,TableParrefCode,SelItmID,repid)
	s Count=0
	k ^TMP("DHCADV","web.DHCADVModel","GetTableData",repid)
	q:ADVFormRecDr="" ""
	s RsDate="",RsString=""
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  		//元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  			//值
	.s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        				//元素唯一标示，对应界面的ID
	.q:ItmID'[TableParrefCode         											//只保留表格数据
	.q:ItmValue="title"
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  		//Key
	.q:DataRowKey=""
	.s ^TMP("DHCADV","web.DHCADVModel","GetTableData",repid,DataRowKey,ItmID) = ItmValue

	s Ret=""
	s DataRowKey="" 
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVModel","GetTableData",repid,DataRowKey)) q:DataRowKey=""  d
	.s HasData="",AreaDesc="",RowData=""
	.s ItmID= SelItmID
	.; 2021-05-21 cy str
	.s:ItmID'="" RowData=$g(^TMP("DHCADV","web.DHCADVModel","GetTableData",repid,DataRowKey,ItmID))
	.s:RowData'="" HasData=1
	.s:(Ret'="")&&(RowData'="") Ret=Ret_","_RowData
	.s:(Ret="")&&(RowData'="") Ret=RowData
	.; 2021-05-21 cy end
	.f  s ItmID = $o(^TMP("DHCADV","web.DHCADVModel","GetTableData",repid,DataRowKey,ItmID)) q:ItmID=""  d
	..q:ItmID'[SelItmID
	..s Data = $g(^TMP("DHCADV","web.DHCADVModel","GetTableData",repid,DataRowKey,ItmID))
	..i SelItmID'="UlcerPart-95158-95189" d
	...s HasData=1
	...i $l(ItmID,"-")=5 d
	....s:Ret'="" Ret=Ret_"("_Data_")"
	....s:Ret="" Ret=Data
	...i $l(ItmID,"-")'=5 d
	....s:Ret'="" Ret=Ret_","_Data
	....s:Ret="" Ret=Data
	..i SelItmID="UlcerPart-95158-95189" d
	...s HasData=1
	...s:AreaDesc'="" AreaDesc=AreaDesc_"*"_Data
	...s:AreaDesc="" AreaDesc=Data
	.i SelItmID="UlcerPart-95158-95189" d
	..q:+AreaDesc=0
	..s:Ret'="" Ret=Ret_","_AreaDesc
	..s:Ret="" Ret=AreaDesc
	.i HasData="" d
	..s:Ret'="" Ret=Ret_","
	..s:Ret="" Ret=""
	k ^TMP("DHCADV","web.DHCADVModel","GetTableData",repid)
	q Ret
}

}
