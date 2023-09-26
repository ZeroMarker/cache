Import SQLUSER

/// Creator: 	 QuNianpeng
/// CreateDate:  2017-07-08
/// Descript:    病理病人病历分类字典表数据操作类
Class web.DHCAPPCaseClass Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【保存】病理病人病历分类字典表数据
/// Table：        DHC_APPCaseClass
/// Input:		   病理病人病历分类数据信息。 以字符"^"分割，id^代码^描述^医院描述^医院id^是否可用$$代码^描述^医院描述^医院id^是否可用
/// Return：	   保存成功0 失败 非0
/// Others：       w ##class(web.DHCAPPCaseClass).SaveCaseClass("1^001^病理申请1^东华标准版数字化医院^2^Y")
ClassMethod SaveCaseClass(params As %String) As %String
{
	n (params)

	s $Zt="Err"
	s err=0
	s len=$L(params,"$$")

	TS
	f i=1:1:len d
	.s tmpStr=$p(params,"$$",i)
	.s err=..CheckRepeatCaseClass(tmpStr)   /// 重复性判断
	.q:err'=0
	.i ($p(tmpStr,"^",1)'="")&($p(tmpStr,"^",1)'=0) d
	..s err=..UpdateCaseClass(tmpStr)
	..q:err'=0
	.e  d
	..s err=..InsertCaseClass(tmpStr)
	..q:err'=0
	
	i err'=0 Tro
	TC
	q err
	
Err
	TRo
	i err=0 s err=-1
	q err
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【保存】病理病人病历分类字典表数据
/// Table：        DHC_APPCaseClass
/// Input:		   病理病人病历分类数据信息。 以字符"^"分割，格式为 id^代码^描述^医院^是否可用
/// Return：	   保存成功0 失败 非0
/// Others：       w ##class(web.DHCAPPCaseClass).InsertCaseClass("^001^病理病人^2^Y")
ClassMethod InsertCaseClass(params As %String) As %String
{
	n (params)
	
	s accCode=$p(params,"^",2)
	s accDesc=$p(params,"^",3)
	s accHospDr=$p(params,"^",4)	//插入时界面hospDesc字段就是hospDr
	s accActiveFlag=$p(params,"^",6)
	
	&sql(insert into DHC_APPCaseClass (ACC_Code,ACC_Desc,ACC_Hosp_Dr,ACC_ActiveFlag) values (:accCode,:accDesc,:accHospDr,:accActiveFlag))
	q SQLCODE
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【删除】病理病人病历分类字典表数据
/// Table：        DHC_APPCaseClass
/// Input:		   表的id
/// Return：	   删除成功 0,删除失败 非0
/// Others：       w ##class(web.DHCAPPCaseClass).DeleteCaseClass("1")
ClassMethod DeleteCaseClass(accRowId As %String) As %String
{
	n (accRowId)
	&SQL(Delete From DHC_APPCaseClass Where ACC_RowId=:accRowId)
	Q SQLCODE
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:：【新】病理病人病历分类字典表数据
/// Table：        DHC_APPCaseClass
/// Input:		   分类数据信息。 以字符"^"分割，格式为 id^代码^描述^医院^是否可用
/// Return：	   更新成功0 失败 非0
/// Others：       w ##class(web.DHCAPPCaseClass).UpdateCaseClass("^001^病理病人^2^Y")
ClassMethod UpdateCaseClass(params As %String) As %String
{
	n (params)
	s accRowId=$p(params,"^",1)
	s accCode=$p(params,"^",2)
	s accDesc=$p(params,"^",3)
	s accHospDesc=$p(params,"^",4)
	s hospDr=$p(params,"^",5)
	s accActiveFlag=$p(params,"^",6)
	s accHospDr=accHospDesc
	i ((+accHospDesc=0)&&(accHospDesc'=0)) s accHospDr=hospDr  //更新时，描述未改变，取dr字段值。否则desc就是id

	&SQL(Update DHC_APPCaseClass Set ACC_Code=:accCode,ACC_Desc=:accDesc,ACC_Hosp_Dr=:accHospDr,Acc_ActiveFlag=:accActiveFlag Where ACC_RowId=:accRowId)
	Q SQLCODE
}

/// Creator：      QuNianpeng
/// CreatDate：    2017-07-08
/// Description:： 【查询】病理病人病历分类字典表数据
/// Table：        DHC_APPCaseClass
/// Input:		   代码或描述
/// Return：	   分类信息
/// Others：       w ##class(web.DHCAPPCaseClass).QueryCaseClass(100,1,"")
ClassMethod QueryCaseClass(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)

	s end = page*rows
	s start = (page-1)*rows+1
    //s pid=##Class(web.DHCAPPPathCom).NewPid()  //没有
    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s code=$p(params,"^",1)
    s desc=$p(params,"^",2)
	s h=0,count=0
	s accRowId=""
	f  s accRowId=$o(^DHCAPPCC(accRowId)) q:accRowId=""  d
	.q:accRowId=0
	.s accCode=$p(^DHCAPPCC(accRowId),"^",1)
	.s accDesc=$p(^DHCAPPCC(accRowId),"^",2)
	.s accHospDr=$p(^DHCAPPCC(accRowId),"^",3)
	.s accHospDesc=""
	.i accHospDr'="" s accHospDesc=$P(^CT("HOSP",accHospDr),"^",2)
	.s accActiveFlag=$p(^DHCAPPCC(accRowId),"^",4)
	.q:(code'="")&(accCode'[code)
	.q:(desc'="")&(accDesc'[desc)
	.s h=h+1
	.s tmpStr=accRowId_"^"_accCode_"^"_accDesc_"^"_accHospDesc_"^"_accHospDr_"^"_accActiveFlag
	.s ^TMP("DHCAPP","web.DHCAPPCaseClass","QueryCaseClass",pid,h)=tmpStr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="accRowId^accCode^accDesc^accHospDesc^accHospDr^accActiveFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPCaseClass","QueryCaseClass",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCAPP","web.DHCAPPCaseClass","QueryCaseClass",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description: 保存[检查代码、描述是否重复]
/// Creator:     QuNianpeng
/// CreateDate:  2017-07-08
/// Table:		 DHC_APPCaseClass
/// Input:		   id^代码^描述
/// Return：	   不重复0 重复 非0
/// Others:		 w ##class(web.DHCAPPCaseClass).CheckRepeatCaseClass("1^001^检查申请^东华标准版数字化医院^2^Y")
ClassMethod CheckRepeatCaseClass(tmpStr As %String) As %String
{
	n (tmpStr)
	s rowId=$p(tmpStr,"^",1)
	s code=$p(tmpStr,"^",2)
	s desc=$p(tmpStr,"^",3)
	
	/// 新记录
	q:(+rowId=0)&$d(^DHCAPPCC(0,"Code",$$ALPHAUP^SSUTIL4(code))) -2
	q:(+rowId=0)&$d(^DHCAPPCC(0,"Desc",$$ALPHAUP^SSUTIL4(desc))) -3
	q:+rowId=0 0
	
	/// 修改记录
	s codeFlag=0
	s descFlag=0
	s accRowId=0
	//判断代码重复性
	i $d(^DHCAPPCC(0,"Code",$$ALPHAUP^SSUTIL4(code))) d
	.s accRowId=$o(^DHCAPPCC(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.q:rowId=accRowId
	.s codeFlag=1

	//判断描述重复性
	i $d(^DHCAPPCC(0,"Desc",$$ALPHAUP^SSUTIL4(desc))) d
	.s accRowId=$o(^DHCAPPCC(0,"Desc",$$ALPHAUP^SSUTIL4(desc),""))
	.q:rowId=accRowId 
	.s descFlag=1

	q:codeFlag=1 -2
	q:descFlag=1 -3

	q 0
}

/// Description: k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCAPP","web.DHCAPPCaseClass","QueryCaseClass",pid)
}

}
