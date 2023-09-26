/// Creator:		陈乙
/// CreatDate:		2015-02-15
/// Description:	出入转界面与后台数据交互类
Class DHCWL.MRIPDayTask.MRIPDayTaskServer Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:		陈乙
/// CreatDate:		2015-02-28
/// Description:	插入出入转任务设置医嘱对应设置数据
/// w ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveDisCondicions(.dim)
ClassMethod SaveOrdSetting(ByRef dim) As %String
{
	n (dim)
	s ordSetCode=$g(dim("ordSetCode"))
	s ordSetDesc=$g(dim("ordSetDesc"))
	s ordSetCreateUser=$g(dim("ordSetCreateUser"))
	;s ^cy("存入配置医嘱统计项")=ordSetCode_"*"_ordSetDesc_"*"_ordSetCreateUser
	q:($d(^DHCWL.MRIPDayTask.OrdItmI("OrdItmCodeIndex",ordSetCode))) "保存失败：该CODE已存在！"
	q:$d(^DHCMRIPDetail(0,"TYPE",ordSetCode)) "保存失败：该CODE已存在于出入转明细表中，不可重复！"
	s ordObj=##class(DHCWL.MRIPDayTask.OrdItm).%New()
	s ordObj.OrdItmCode=$g(ordSetCode)
	s ordObj.OrdItmDesc=$g(ordSetDesc)
	s ordObj.OrdItmCreator=$g(ordSetCreateUser)
	s ordObj.OrdItmDiscardDate=""  //对象插入必须写满字段？
	s sc=ordObj.%Save()   //sc保存结果，1表示成功
	s result="保存失败！"
	i sc=1  d  
	.s result="ok"
	;s ^cy("tip1")=result
	q result
}

/// Creator:		陈乙
/// CreatDate:		2015-03-02
/// Description:	将医嘱统计项的作废时间更新上去
/// w ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveDisCondicions(.dim)
ClassMethod SetDateOrdSetting(ID) As %String
{
	n (ID)
	q:$li($g(^DHCWL.MRIPDayTask.OrdItmD(ID)),4)'="" "保存失败：该统计项已作废！"
	s nowDate=+$h
	&sql(update DHCWL_MRIPDayTask.OrdItm set OrdItm_DiscardDate=:nowDate where OrdItm_RowID=:ID)
	s result="保存失败！"
	i SQLCODE=0  d  
	.s result="ok"
	;s ^cy("tip1")=result
	q result
}

/// Creator:		陈乙
/// CreatDate:		2015-02-25
/// Description:	插入出入转任务设置出院情况对应设置数据
/// w ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveDisCondicions(.dim)
ClassMethod SaveDisCondicions(ByRef dim) As %String
{
	n (dim)

	s str=$g(dim("str"))
	s len=$l(str,"|")
	f i=1:1:len d
	.s objInfo=$p(str,"|",i)
	.s disID=$P(objInfo,"^",1)
	.s disSetDesc=$P(objInfo,"^",3)
	.q:($g(disSetDesc)="")||($g(disSetDesc)="请选择归组")
	.i disSetDesc="治愈人数" d
	..i $g(zyrsStr)="" s zyrsStr=disID
	..e  s zyrsStr=$g(zyrsStr)_","_disID
	.i disSetDesc="未愈人数" d
	..i $g(wyrsStr)="" s wyrsStr=disID
	..e  s wyrsStr=$g(wyrsStr)_","_disID
	.i disSetDesc="好转人数" d
	..i $g(hzrsStr)="" s hzrsStr=disID
	..e  s hzrsStr=$g(hzrsStr)_","_disID
	.i disSetDesc="死亡人数" d
	..i $g(swrsStr)="" s swrsStr=disID
	..e  s swrsStr=$g(swrsStr)_","_disID
	;.i disSetDesc="其他人数" d
	;..i $g(qtrsStr)="" s qtrsStr=disID
	;..e  s qtrsStr=$g(qtrsStr)+disID
	s creator=$g(dim("creator"))
	s date=+$h
	s time=$p($h,",",2)
	s disObj=##class(DHCWL.MRIPDayTask.DisCond).%New()
	s disObj.DisCondZYRS=$g(zyrsStr)
	s disObj.DisCondHZRS=$g(hzrsStr)
	s disObj.DisCondWYRS=$g(wyrsStr)
	s disObj.DisCondSWRS=$g(swrsStr)
	s disObj.DisCondCreator=$g(creator)
	s disObj.DisCondUpDate=+$h
	s disObj.DisCondUpTime=$p($h,",",2)
	s sc=disObj.%Save()   //sc保存结果，1表示成功
	
	s result="保存失败！"
	i sc=1  d  
	.s result="ok"
	;s ^cy("tip1")=result
	q result
}

/// Creator:		陈乙
/// CreatDate:		2015-02-25
/// Description:	插入出入转任务设置医嘱明细对应数据
/// w ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveDisCondicions(.dim)
ClassMethod SaveOrdDetailSetting(str) As %String
{
	n (str)
	s errorFlag=0
	s len=$l(str,"#")
	s date=+$h
	s time=$p($h,",",2)
	;s ^cy("qisiwole")=str
	//医嘱项明细重复检查,如果重复给给出提示。
	f i=1:1:len d
	.s recStr=$p(str,"#",i)
	.s mainID=$P(recStr,"^",1)
	.s detailID=$P(recStr,"^",2)
	.q:errorFlag=1
	.i $d(data(mainID,detailID)) d
	..w "{success:true,tip:保存失败,"_detailID_"重复！'}"
	..s errorFlag=1
	.e  s data(mainID,detailID)=""
	q:errorFlag=1 "保存失败！"
	
	//如果没有重复，则正常保存
	f i=1:1:len d
	.s recStr=$p(str,"#",i)
	.s mainID=$P(recStr,"^",1)
	.s detailID=$P(recStr,"^",2)
	.;s desc=$p(recStr,"^",3)
	.&sql(INSERT INTO DHCWL_MRIPDayTask.OrdItmDet(OrdItmDet_OrdItmtDR,OrdItmDet_ARCItmMastDR,OrdItmDet_CreateDate,OrdItmDet_CreateTime) 
	VALUES(:mainID,:detailID,:date,:time))
	.i SQLCODE'=0 d
	..w "{success:true,tip:保存失败,SQLCODE='"_SQLCODE_"'}"
	..s errorFlag=1
	
	s result="保存失败！"
	i errorFlag=0  d  
	.s result="ok"
	;s ^cy("tip1")=result
	q result
}

/// Creator:		陈乙
/// CreatDate:		2015-02-25
/// Description:	删除出入转任务设置医嘱明细对应数据
/// w ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).DeleteOrdDetailSetting("1#1,2,3")
ClassMethod DeleteOrdDetailSetting(str) As %String
{
	n (str)
	s mainId=$p(str,"#",1)
	s rowIdStr=$p(str,"#",2)
	s date=+$h
	s result="删除失败！"
	s len=$l(rowIdStr,",")
	f i=1:1:len d
	.s rowId=$p(rowIdStr,",",i)
	.i '$d(^DHCWL.MRIPDayTask.OrdItmDetD(rowId)) s result="该统计项不存在！"
	.q:'$d(^DHCWL.MRIPDayTask.OrdItmDetD(rowId))
	.s lastDate=$li(^DHCWL.MRIPDayTask.OrdItmDetD(rowId),4)
	.i lastDate'=date s result="非当天加入，不可删除！"
	.q:lastDate'=date   //"非当天加入，不可删除！"
	.&sql(delete DHCWL_MRIPDayTask.OrdItmDet where OrdItmDet_RowID=:rowId)
	.i SQLCODE=0 d 
	..s result="ok"
	
	q result
}

/// Creator:		陈乙
/// CreatDate:		2015-02-25
/// Description:	插入出入转任务设置基本设置数据
/// w ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).SaveBaseSetting(.dim)
ClassMethod SaveBaseSetting(ByRef dim) As %String
{
	n (dim,%session)

	s disDateType=$g(dim("disDateType")) 
	s depStopFlag=$g(dim("depStopFlag"))
	s wardStopFlag=$g(dim("wardStopFlag"))
	s creator=$g(dim("creator"))
	s date=+$h
	s time=$p($h,",",2)
	/*对象的方式插入
	s typeObj=##class(DHCWL.MRIPDayTask.CRZTaskBaseSet).%New()
	s typeObj.TBaseSDisDateType=$g(disDateType)
	s typeObj.TBaseSDepStopFlag=$g(depStopFlag)
	s typeObj.TBaseSWardStopFlag=$g(wardStopFlag)
	s typeObj.TBaseSCreator=$g(creator)
	s typeObj.TBaseSUpDate=+$h
	s typeObj.TBaseSUpTime=$p($h,",",2)
	s sc=typeObj.%Save()   //sc保存结果，1表示成功
	*/
	//sql方式插入
	&sql(INSERT INTO DHCWL_MRIPDayTask.BaseSet(BaseSet_DisDateType,BaseSet_DepStopFlag,BaseSet_WardStopFlag,BaseSet_Creator,BaseSet_UpDate,BaseSet_UpTime) 
	VALUES(:disDateType,:depStopFlag,:wardStopFlag,:creator,:date,:time))
	s result="保存失败！"
	i SQLCODE=0  d  
	.s result="ok"
	;s ^cy("tip1")=result
	q result
}

/// Creator:		陈乙
/// CreatDate:		2015-02-15
/// Description:	将将医嘱设置信息改为json数据
/// set json = ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).GetOrdSetting()
ClassMethod GetOrdSetting() As DHCWL.util.Json
{
	
	k arrs
	s num=1
	s rowid=""
	f  s rowid=$o(^DHCWL.MRIPDayTask.OrdItmD(rowid)) Q:rowid=""  d
	.q:rowid=0
	.s ordCode=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),2)
	.s ordDesc=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),3)
	.s ordDiscardDate=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),4)
	.s ordCreator=$li($g(^DHCWL.MRIPDayTask.OrdItmD(rowid)),5)
	.s arrs(num,"ID")=rowid
	.s arrs(num,"OrdSetCODE")=ordCode
	.s arrs(num,"OrdSetDesc")=ordDesc
	.;i $g(ordDiscardDate)'="" s arrs(num,"AbolishDate")=$zd(ordDiscardDate,3)	;--modify by wz
	.i $g(ordDiscardDate)'="" s arrs(num,"AbolishDate")=##class(websys.Conversions).DateLogicalToHtml(ordDiscardDate)
	.e  s arrs(num,"AbolishDate")=""
	.s arrs(num,"OrdSetCreater")=ordCreator
	.s num=num+1
	;zw arrs   ;必须注释，不然界面无法显示数据
	if ($d(arrs)) s json=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).MetrixToJson(.arrs)
	q $g(json)
}

/// Creator:		陈乙
/// CreatDate:		2015-02-15
/// Description:	将明细对应数据改为json数据
/// set json = ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).GetOrdDetailSetting(1)
ClassMethod GetOrdDetailSetting(mainID) As DHCWL.util.Json
{
	
	n (mainID)
	s num=1
	s lastDate=$o(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID,""),-1)
	s lastTime=$o(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID,lastDate,""),-1)
	s rowID=0
	f  s rowID=$o(^DHCWL.MRIPDayTask.OrdItmDetI("OrdItmDetOrdItmtDRIndex",mainID,lastDate,lastTime,rowID)) q:rowID=""  d
	.s mARCItmID=$li($g(^DHCWL.MRIPDayTask.OrdItmDetD(rowID)),2) ;医嘱项ID
	.s par=$p(mARCItmID,"||",1)
	.s sub=$p(mARCItmID,"||",2)
	.s mARCCode=$p($g(^ARCIM(par,sub,1)),"^",1)
	.s mARCDesc=$p($g(^ARCIM(par,sub,1)),"^",2)
	.s arrs(num,"DetRowId")=rowID
	.s arrs(num,"ID")=mARCItmID
	.s arrs(num,"ARCItmCode")=mARCCode
	.s arrs(num,"ARCItmDesc")=mARCDesc
	.s num=num+1
	;zw arrs   ;必须注释，不然界面无法显示数据
	if ($d(arrs)) s json=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).MetrixToJson(.arrs)
	q $g(json)
}

/// Creator:		陈乙
/// CreatDate:		2015-02-15
/// Description:	将将模糊查询到的医嘱项改为json数据
/// set json = ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).GetARCItms()
ClassMethod GetARCItms(cond1, cond2) As DHCWL.util.Json
{
	
	n (cond1,cond2)
	k arrs

	s num=1
	s par=0
	f  s par=$o(^ARCIM(par)) Q:$g(par)=""  d
	.;q:par>100
	.s sub=0 f  s sub=$o(^ARCIM(par,sub)) q:sub=""  d
	..s rowid=par_"||"_sub
	..s mARCCode=$p($g(^ARCIM(par,sub,1)),"^",1)
	..s mARCDesc=$p($g(^ARCIM(par,sub,1)),"^",2)
	..q:(cond1="ARCItmID")&&(rowid'[cond2)&&($g(cond2)'="")
	..q:(cond1="ARCItmCode")&&(mARCCode'[cond2)&&($g(cond2)'="")
	..q:(cond1="ARCItmDesc")&&(mARCDesc'[cond2)&&($g(cond2)'="")
	..s arrs(num,"ID")=par_"||"_sub
	..s arrs(num,"ARCItmCode")=$g(mARCCode)
	..s arrs(num,"ARCItmDesc")=$g(mARCDesc)
	..s num=num+1
	;zw arrs   ;必须注释，不然界面无法显示数据
	if ($d(arrs)) s json=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).MetrixToJson(.arrs)
	q $g(json)
}

/// Creator:		陈乙
/// CreatDate:		2015-02-15
/// Description:	将出院情况改为json数据
/// set json = ##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).GetDisConditiont()
ClassMethod GetDisConditiont() As DHCWL.util.Json
{
	s disSetRowId=$o(^DHCWL.MRIPDayTask.DisCondD(""),-1)   ;最后一条记录
	i $g(disSetRowId)'="" {
		s zyrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),2)  ;治愈人数ID串
		s hzrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),3)  ;好转人数ID串
		s swrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),5)  ;死亡人数ID串
		s wyrsStr=$li(^DHCWL.MRIPDayTask.DisCondD(disSetRowId),4)  ;未愈人数ID串
		i $g(zyrsStr)'="" d SetArray(zyrsStr,"治愈人数")
		i $g(hzrsStr)'="" d SetArray(hzrsStr,"好转人数")
		i $g(swrsStr)'="" d SetArray(swrsStr,"死亡人数")
		i $g(wyrsStr)'="" d SetArray(wyrsStr,"未愈人数")
	}
	s num=1
	s rowid=""
	f  s rowid=$o(^PAC("DISCON",rowid)) Q:rowid=""  d
	.q:rowid=0
	.s disDesc=$p($g(^PAC("DISCON",rowid)),"^",2)
	.s arrs(num,"ID")=rowid
	.s arrs(num,"Desc")=disDesc
	.i $d(dim(rowid)) d
	..s arrs(num,"DescSet")=$g(dim(rowid))
	.e  d 
	..i $g(disSetRowId)="" s arrs(num,"DescSet")="请选择归组"    ;未设置过，提示归组
	..e  s arrs(num,"DescSet")="其他人数"   ;设置过，未保存的ID，归为“其他人数”
	.s num=num+1
	;zw arrs   ;必须注释，不然界面无法显示数据
	if ($d(arrs)) s json=##class(DHCWL.MRIPDayTask.MRIPDayTaskServer).MetrixToJson(.arrs)
	q $g(json)
	
SetArray(str,desc)
	s len=$l(str,",")
	f i=1:1:len d
	.s disId=$p(str,",",i)
	.s dim(disId)=desc
	;.s ^cy("dim",disId)=desc
}

/// Creator:		chenyi
/// CreatDate:		
/// Description:	将二维矩阵转换为json数据
/// Table:			
/// Input:			arrs:待转换的二维矩阵
/// return:			json数据
/// HowToUse:		s arr(1,"id")=1,arr(1,"name")="JEFF",arr(1,"nickName")="JEFF",arr(2,"id")=2,arr(2,"name")="JEFF2",arr(2,"nickName")="JEFF23",json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arr)
ClassMethod MetrixToJson(ByRef arrs) As DHCWL.util.Json
{
	n (arrs)
	/// 处理二维矩阵转换为json数据(目前仅支持二维矩阵,对于二维数组尚不能很好支持)
	s tab="", nod="", nod=$o(arrs(nod)), tab=$o(arrs(nod,tab)), tabList="", valueList=""
	k valueArray	//edited by lhh
	while(""'=tab){
			/// 组装json标签列表
			i (""=tabList) s tabList=tab
			e  s tabList=tabList_"^"_tab
			s valueArray(tab)=""
			s tab=$o(arrs(nod,tab))
	}
	/// 用定义的json标准格式初始化json容器
	s json=##class(DHCWL.util.Json).Json(tabList)	
	s tab=$o(arrs(nod,""))
	
	while(""'=nod){
		s valueList="", tab=$o(arrs(nod,""))
		s property="" //edited by lhh20131105
		f {
			s property=$o(valueArray(property))
			q:property=""
			if ('$d(arrs(nod,property))){
				s value=""
			}else{
				s value=arrs(nod,property)
			}
			i (""=valueList) s valueList="'"_value_"'"
			e  s valueList=valueList_"^'"_value_"'"
		}
		/*
		while(""'=tab){
			/// 组装json值列表
			i (""=valueList) s valueList="'"_$g(arrs(nod,tab))_"'"
			e  s valueList=valueList_"^'"_$g(arrs(nod,tab))_"'"
			s tab=$o(arrs(nod,tab))
		}
		if (tab=""){
			i (""=valueList) s valueList="''"
			e  s valueList=valueList_"^''"
		}*/
		/// 将组装好的json值列表有序的填充json容器
		d json.Insert(valueList)
		s nod=$o(arrs(nod))
	}
	q json
}

}
