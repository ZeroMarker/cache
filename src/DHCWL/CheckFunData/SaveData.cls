Import SQLUser

Class DHCWL.CheckFunData.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 考核方案表增加数据
/// Table：       DHCWL_CheckFun.DHCWLCheckSet
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.CheckFunData.SaveData).AddCheckFunSet(.dim)
/// update: 考核方案 中的考核对象 以及考核对象类型全部存储为id.
ClassMethod AddCheckFunSet(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("SetCode")="as"
	 //s dim("SetDesc")="as"
	 //s dim("SetSecType")="M"
	 //s dim("SetObjType")="科室"
	 s name=""
	 s SetCode=$g(dim("SetCode"))
	 i SetCode="" q "ok^^" 
	 s mid=..GetCheckFunSetidByCode(SetCode)
	 i mid'="" q "ok^^"
	 s SetDesc=$g(dim("SetDesc"))
	 i SetDesc="" q "ok^^"
	 s SetSecType=$g(dim("SetSecType"))
	 i SetSecType="" q "ok^^"
	 s SetObjType=$g(dim("SetObjType"))
	 i SetObjType="" q "ok^^"
	 s SetObjDim=$g(dim("SetObjDim"))
	 s SetUpdateUser=$g(dim("SetUpdateUser"))
	 s SetUpdateDate=+$h
	 &sql(INSERT INTO DHCWL_CheckFun.DHCWLCheckSet(CheckSet_Code,CheckSet_Desc,CheckSet_SectionType,CheckSet_ObjType,CheckSet_ObjDim,CheckSet_UpdateDate,CheckSet_UpdateUser) values(:SetCode,:SetDesc,:SetSecType,:SetObjType,:SetObjDim,:SetUpdateDate,:SetUpdateUser))
	 s id=+$g(%ROWID)
	 s result="failure"
	 i SQLCODE=0  d  
	 .s result="ok"
	 .s name=$list(^DHCWL.CheckFun.CheckSetD(id),3)
	 q result_"^"_id_"^"_name
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 考核方案表修改数据
/// Table：       DHCWL_CheckFun.DHCWLCheckSet
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).UpdateCheckFunSet(.dim)
ClassMethod UpdateCheckFunSet(ByRef dim) As %String
{
   
	n (dim,%session)
	//s dim("SetDesc")="方案123"
	//s dim("SetCode")="as"
	//s dim("ID")=1
	//s dim("SetSecType")="M"
	//s dim("SetObjType")="科室"
	//s dim("SetUpdateUser")=""
	s id=$g(dim("ID"))
	//q id
	q:'$d(^DHCWL.CheckFun.CheckSetD(id)) "请选择要更新的行"
	s SetCode=$g(dim("SetCode"))
	i SetCode="" q "方案编码不能为空"
	s CodeId=..GetCheckFunSetidByCode(SetCode)
	q:CodeId="" "方案编码不允许修改"
	i CodeId'=id q:"方案编码不允许修改" 
	s SetDesc=$g(dim("SetDesc"))
	i SetDesc="" q "方案描述不能为空"
	s SetSecType=$g(dim("SetSecType"))
	s secDr=$list(^DHCWL.CheckFun.CheckSetD(id),4)
	q:secDr'=SetSecType "区间类型不允许修改"
	s SetObjType=$g(dim("SetObjType"))
	s objType=$list(^DHCWL.CheckFun.CheckSetD(id),5)
	q:objType'=SetObjType "对象类型不允许修改"
	s SetObjDim=$g(dim("SetObjDim"))
	s objDim=$list(^DHCWL.CheckFun.CheckSetD(id),8)
	q:objDim'=SetObjDim "对象属性不允许修改"
	s SetUpdateUser=$g(dim("SetUpdateUser"))
	//q SetUpdateUser
	s SetUpdateDate=+$h
	&sql(update DHCWL_CheckFun.DHCWLCheckSet set CheckSet_Desc=:SetDesc,CheckSet_UpdateDate=:SetUpdateDate,CheckSet_UpdateUser=:SetUpdateUser where ID=:id )
	s result="更新失败!"
	i SQLCODE=0 d
	.s result="ok"
	q result
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 考核方案表删除数据
/// Table：       DHCWL_CheckFun.DHCWLCheckSet
/// Input：       
/// Output：      
/// Return：    result：ok or failure  
/// Others：w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunSet(.dim)
/// 删除考核方案 需要同时删除对应的考核指标关系以及标准值和例外值
ClassMethod DeleteCheckFunSet(ByRef dim) As %String
{
	n (dim,%session)
	//s dim("ID")=20
	s id=$g(dim("ID"))
	s result="failure"
	q:'$d(^DHCWL.CheckFun.CheckSetD(id)) "请选择要删除的行"
	Tstart
	s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunStaValueBySetId(id)
	q:result1="failure" result
	s result2=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunRelBySetId(id)   ;note 20150714
	q:result2="failure" result
	s setObj=##class(DHCWL.CheckFun.CheckSet).%OpenId(id)
	s sc=##class(DHCWL.CheckFun.CheckSet).%DeleteId(id)	
	q:sc'=1 result
	s result="ok"
	i result="failure" Trollback
	e  TCommit
	q $g(result)
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 通过考核方案表Id删除考核标准值表记录
/// Table：      
/// Input：       
/// Output：      
/// Return：    result：ok or failure  
/// Others：w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunStaValueBySetId("3")
/// 
ClassMethod DeleteCheckFunStaValueBySetId(setId) As %String
{
	n (setId)
	q:'$d(^DHCWL.CheckFun.StandardValSetI("Set",setId)) "ok"
	s result="failure"
	s staValRowid="" f  s staValRowid=$o(^DHCWL.CheckFun.StandardValSetI("Set",setId,staValRowid)) q:staValRowid=""  d
	.s result="failure"
	.s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunExcValueByStaId(staValRowid)
	.q:result1="failure"
	.;w result1,!
	.s staValueObj=##class(DHCWL.CheckFun.StandardValSet).%OpenId(staValRowid)
	.s sc=##class(DHCWL.CheckFun.StandardValSet).%DeleteId(staValRowid)
	.q:sc'=1 
	.s result="ok"
	q $g(result)
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:：通过考核标准值表id删除例外值表记录
/// Table：       
/// Input：       staId:标准值id
/// Output：      
/// Return：      成功返回ok 失败返回failure
/// Others：w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunExcValueByStaId(staId)
/// 删除考核标准值界面记录时需要同时例外值
ClassMethod DeleteCheckFunExcValueByStaId(staId) As %String
{
	n (staId)
	q:'$d(^DHCWL.CheckFun.ExceptValSetI("Stand",staId)) "ok"
	s result="failure"
	s excValueRowid="" f  s excValueRowid=$o(^DHCWL.CheckFun.ExceptValSetI("Stand",staId,excValueRowid)) q:excValueRowid=""  d
	.s result="failure"
	.s excValueObj=##class(DHCWL.CheckFun.ExceptValSet).%OpenId(excValueRowid)
	.s sc=##class(DHCWL.CheckFun.ExceptValSet).%DeleteId(excValueRowid)
	.q:sc'=1 
	.s result="ok"
	q $g(result)
}

//w ##class(DHCWL.CheckFunData.SaveData).GetCheckFunSetidByCode("abs")

ClassMethod GetCheckFunSetidByCode(code)
{
	 n (code)
	 q:code="" ""
	 s id=$o(^DHCWL.CheckFun.CheckSetI("Code",$zcvt(code,"U"),""))
	 q id
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 考核指标表增加数据
/// Table：       DHCWL_CheckFun.DHCWLCheckKPI
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).AddCheckFunKpi(.dim)
ClassMethod AddCheckFunKpi(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("KpiCode")="asb"
	 //s dim("KpiDesc")="gg"
	 //s dim("KpiFlag")="Y"
	 s KpiCode=$g(dim("KpiCode"))
	 i KpiCode="" q "指标代码不能为空"
	 s id=..GetCheckFunKpiIdByCode(KpiCode)
	 i id'="" q "指标代码不能重复"
	 s KpiDesc=$g(dim("KpiDesc"))
	 i KpiDesc="" q "指标描述不能为空"
	 s mid=..GetCheckFunKpiIdByDesc(KpiDesc)
	 i mid'="" q "指标描述不能重复"
	 s KpiFlag=$g(dim("KpiFlag"))
	 i KpiFlag="是" s KpiFlag="Y"
	 i KpiFlag="否" s KpiFlag="N"
	 s KpiUpdateUser=$g(dim("KpiUpdateUser"))
	 s updateDate=+$h
	 &sql(INSERT INTO DHCWL_CheckFun.DHCWLCheckKPI(CheckKPI_Code,CheckKPI_Desc,CheckKPI_Flag,CheckKPI_UpdateDate,CheckKPI_UpdateUser) values(:KpiCode,:KpiDesc,:KpiFlag,:updateDate,:KpiUpdateUser))
	 s id=+$g(%ROWID)
	 i SQLCODE=0  d  
	 .s result="ok"
	 e  d
	 .s result="sorry,failure!"
	 q result
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 考核指标表更新数据
/// Table：       DHCWL_CheckFun.DHCWLCheckKPI
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).UpdateCheckFunKpi(.dim)
ClassMethod UpdateCheckFunKpi(ByRef dim) As %String
{
	n (dim,%session)
	///s dim("KpiDesc")="药占比"
	///s dim("KpiFlag")="N"
	///s dim("ID")=14
	///s dim("KpiCode")="bbbs"
	///b ///001
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.CheckFun.CheckKPID(id)) "请选择要更新的行"
	s KpiCode=$g(dim("KpiCode"))
	i KpiCode="" q "指标代码不能为空"
	s KpiCodeId=..GetCheckFunKpiIdByCode(KpiCode)
	q:KpiCodeId="" "指标代码不允许修改"
	i KpiCodeId'=id q:"指标代码不允许修改"
	s KpiDesc=$g(dim("KpiDesc"))
	i KpiDesc="" q "指标描述不能为空"
	s mid=..GetCheckFunKpiIdByDesc(KpiDesc)
	i (mid'=id)&&(mid'="") q "指标描述不能重复" 
	s KpiFlag=$g(dim("KpiFlag"))
	i KpiFlag="" q "有效标志不能为空"
	i KpiFlag="是" s KpiFlag="Y"
	i KpiFlag="否" s KpiFlag="N"
	s KpiUpdateUser=$g(dim("KpiUpdateUser"))
	s updateDate=+$h
	&sql(update DHCWL_CheckFun.DHCWLCheckKPI set CheckKPI_Desc=:KpiDesc,CheckKPI_Flag=:KpiFlag,CheckKPI_UpdateDate=:updateDate,CheckKPI_UpdateUser=:KpiUpdateUser where ID=:id )
	s result="更新失败!"
	i SQLCODE=0  d  
	.s result="ok"
	q result
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 考核指标表删除数据
/// Table：       DHCWL_CheckFun.DHCWLCheckKPI
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunKpi(.dim)
ClassMethod DeleteCheckFunKpi(ByRef dim) As %String
{
	n (dim,%session)
	//s dim("ID")=2
	s id=$g(dim("ID"))
	s result="failure"
	q:'$d(^DHCWL.CheckFun.CheckKPID(id)) "请选择要删除的行"
	s sc=##class(DHCWL.CheckFun.CheckKPI).%DeleteId(id)	
	i sc=1 d
	.s result="ok"
	q $g(result)
}

ClassMethod GetCheckFunKpiIdByCode(code)
{
	 n (code)
	 q:code="" ""
	 s id=$o(^DHCWL.CheckFun.CheckKPII("Code",$zcvt(code,"U"),""))
	 q id
}

ClassMethod GetCheckFunKpiIdByDesc(desc)
{
	 n (desc)
	 q:desc="" ""
	 s id=$o(^DHCWL.CheckFun.CheckKPII("Desc"," "_$zcvt(desc,"U"),""))
	 q id
}

/// Creator：      zyb
/// CreatDate：    2014-12-04
/// Description:： 根据传入日期和区间类型获取标准值日期格式
/// Table：       
/// Input：       考核日期：2014-04-05  区间类型：M
/// Output：      
/// Return：     标准值日期格式：20140405,201404,2014Q2,2014Y
/// Others：	 w ##class(DHCWL.CheckFunData.SaveData).getDateByType("2014-04-05","M")	
ClassMethod getDateByType(date, type) As %String
{
	n (date,type)
	
	s dateD=$p(date,"-",3)
	s dateM=$p(date,"-",2)
	s transDate=""
	i dateM#3=0  s dateQ="Q"_""_(dateM\3)  
	e  s dateQ="Q"_""_(dateM\3+1)
	s dateY=+date
	//日
	i type="日" s transDate=dateY_""_dateM_""_dateD
	//月
	i type="月" s transDate=dateY_""_dateM
	//季
	i type="季" s transDate=dateY_""_dateQ
	//年
	i type="年" s transDate=dateY_""_"Y"
	
	q $G(transDate)
}

/// Creator：      zyb
/// CreatDate：    2014-12-04
/// Description:： 根据日期和方案Id获取方案下所有指标该日期当前标准值
/// Table：       
/// Input：       考核日期：2014-04-05, 方案Id:2
/// Output：      
/// Return：      ^TEMPDHCWL("SKValue",$j,setId,kpiId,valSetId)  setId:方案id,kpiId:指标id,valSetId:标准值rowid
/// Others：	 w ##class(DHCWL.CheckFunData.SaveData).GetValueBySetDate("2014-12-13",22)	
ClassMethod GetValueBySetDate(checkDate, setId) As %Status
{
	n (checkDate,setId)
	k ^TEMPDHCWL("SKValue",$j)
	s secType=$li(^DHCWL.CheckFun.CheckSetD(setId),4)
	s transDate=..getDateByType(checkDate,secType)
	s valueDate=transDate
	s valSetId=""
	s kpiId=0
	f  s kpiId=$O(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId)) q:kpiId=""  d 
	.i valueDate="" s valueDate=transDate
	.i $d(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,valueDate)) d
	..s valSetId=$O(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,valueDate,""))
	..q:$d(^TEMPDHCWL("SKValue",$j,kpiId))
	..s ^TEMPDHCWL("SKValue",$j,kpiId)=valSetId
	.e  d
	..s valueDate=transDate
	..f  s valueDate=$O(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,valueDate),-1) q:valueDate=""  d
	...s valSetId=$O(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,valueDate,""))
	...q:$d(^TEMPDHCWL("SKValue",$j,kpiId))
	...s ^TEMPDHCWL("SKValue",$j,kpiId)=valSetId
	q 1
}

/// Creator：      ans
/// CreatDate：    2015-06-30
/// Description:： 标准值增加数据加数据
/// Table：       DHCWL_CheckFun.DHCWLStandardValSet
/// Input：       kpiId:指标id,nvalue:标准值,setId:考核方案Id, edate:生效日期
/// Output：      
/// Return：      执行结果^新加标准值id^该方案 该考核指标下的标准值记录数
/// Others： w ##class(DHCWL.CheckFunData.SaveData).AddStandardValue(.dim)
ClassMethod AddStandardValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("kpiId")="3"
	 //s dim("nvalue")="12"
	 //s dim("setId")="64"
	 //s dim("medate")="201503"
	 s count=0
	 s kpiId=$g(dim("kpiId"))
	 s nvalue=$g(dim("nvalue"))
	 s setId=$g(dim("setId"))
	 s medate=$g(dim("medate"))
	 s id=""
	 s count=0
	 s type=$list(^DHCWL.CheckFun.CheckSetD(setId),4)
	 //s edate=##class(DHCWL.CheckFunData.SaveData).getDateByType(medate,type)
	 s edate=$g(medate)
	 s edate=" "_edate
	 s updateUser=$g(dim("SetUpdateUser"))
	 s updateDate=+$h
	 s result="ok"
	 q:$d(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,edate)) result_"^"_id_"^0"
	 &sql(INSERT INTO DHCWL_CheckFun.DHCWLStandardValSet(StandardValSet_Set_Dr,StandardValSet_KPI_Dr,StandardValSet_Value,StandardValSet_Date,StandardValSet_UpdateDate,StandardValSet_UpdateUser) values(:setId,:kpiId,:nvalue,:medate,:updateDate,:updateUser))
	 s id=+$g(%ROWID)
	 i SQLCODE=0  d  
	 .s result="ok"
	 s count=##class(DHCWL.CheckFunData.SaveData).StValueCounts(setId,kpiId) ///获取 该考核方案 该考核指标的标准值记录数
	 q result_"^"_id_"^"_count
}

/// Creator：      ans
/// CreatDate：    2016-02-02
/// Description:：查询考核方案 考核指标下的标准值记录数
/// Table：       DHCWL_CheckFun.DHCWLStandardValSet
/// Input：       setId:考核方案id,kpiId:考核指标id
/// Output：      
/// Return：      count:标准值记录数
/// Others：w ##class(DHCWL.CheckFunData.SaveData).StValueCounts("","")
ClassMethod StValueCounts(setId, kpiId) As %String
{
	 n (setId,kpiId)
	 s count=0
	 s dateId="" f  s dateId=$o(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,dateId)) q:dateId=""  d
	 .s mid=""  f  s mid=$o(^DHCWL.CheckFun.StandardValSetI("SetKPIDate",setId,kpiId,dateId,mid)) q:mid=""  d
	 ..s count=$g(count)+1
	 q count
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 标准值更新数据
/// Table：       DHCWL_CheckFun.DHCWLStandardValSet
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).UpdateStandardValue(.dim)
ClassMethod UpdateStandardValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("ID")=14
	 //s dim("kpiId")=15
	 //s dim("setId")=22
	 //s dim("edate")="2014-12-01"
	 s id=$g(dim("ID"))
	 s kpiId=$g(dim("kpiId"))
	 s nvalue=$g(dim("nvalue"))
	 s setId=$g(dim("setId"))
	 s medate=$g(dim("edate"))
	 s type=$list(^DHCWL.CheckFun.CheckSetD(setId),4)
	 //s edate=##class(DHCWL.CheckFunData.SaveData).getDateByType(medate,type)
	 s edate=$g(medate)
	 s updateUser=$g(dim("SetUpdateUser"))
	 s updateDate=+$h
	 q:'$d(^DHCWL.CheckFun.StandardValSetD(id)) "请选择要更新的行"
	 s mkpi=$li(^DHCWL.CheckFun.StandardValSetD(id),3)
	 q:mkpi'=kpiId "考核指标不允许更新"
	 s mnDate=$li(^DHCWL.CheckFun.StandardValSetD(id),5)
	 q:mnDate'=edate "生效日期不允许修改"
	 &sql(update DHCWL_CheckFun.DHCWLStandardValSet set StandardValSet_Value=:nvalue,StandardValSet_UpdateDate=:updateDate,StandardValSet_UpdateUser=:updateUser where ID=:id) 
	 s id=+$g(%ROWID)
	 s result="failure"
	 i SQLCODE=0  d  
	 .s result="ok"
	 q result
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 标准值删除数据,以及需要删除该标准值下的例外值
/// Table：       DHCWL_CheckFun.DHCWLStandardValSet DHCWL_CheckFun.DHCWLExceptionalValSet
/// Input：       
/// Output：      
/// Return：      成功返回ok 失败返回failure
/// Others：w ##class(DHCWL.CheckFunData.SaveData).DeleteStandardValue(.dim)
/// 删除考核标准值界面记录时需要同时例外值
/// modify 因标准值界面取消了当前值和历史值之分,因此现在删除标准值时只需要同时删除该标准值对应的历史值就ok
ClassMethod DeleteStandardValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("ID")=54
	 //s dim("kpiId")=23
	 //s dim("setId")=23
	 s id=$g(dim("ID"))
	 //s kpiId=$g(dim("kpiId"))
	 //s setId=$g(dim("setId"))
	 q:'$d(^DHCWL.CheckFun.StandardValSetD(id)) "请选择要删除的行"
	 s result="failure"
	 Tstart
	 s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunExcValueByStaId(id)  
	 q:result1="failure"
	 s staValueObj=##class(DHCWL.CheckFun.StandardValSet).%OpenId(id)
	 s sc=##class(DHCWL.CheckFun.StandardValSet).%DeleteId(id)
	 q:sc'=1 
	 s result="ok"
	 i result="failure" Trollback
	 e  TCommit
	 q $g(result)
}

/// Creator：      ans
/// CreatDate：    2014-12-08
/// Description:： 考核例外值表更新数据
/// Table：       DHCWL_CheckFun.DHCWLExceptionalValSet
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.CheckFunData.SaveData).UpdateExceptValue(.dim)
ClassMethod UpdateExceptValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("ID")=100
	 //s dim("extraId")=60
	 //s dim("value")=1200
	 //s dim("objId")=21
	 s dim("extradateUser")="dthealth demo"
	 s mID=$g(dim("ID"))
	 s extraId=$g(dim("extraId"))
     s value=$g(dim("value"))
     s objId=$g(dim("objId"))
     s id=..GetCheckFunExcIdByCode(extraId,objId)
     q:id'=mID "考核对象不允许更新"
     s extradateUser=$g(dim("extradateUser"))
	 s extraUpdateDate=+$h
	 &sql(update DHCWL_CheckFun.DHCWLExceptValSet set ExpValSet_Value=:value,ExpValSet_UpdateDate=:extraUpdateDate,ExpValSet_UpdateUser=:extradateUser where ID=:mID)
	 s id=+$g(%ROWID)
	 s result="failure"
	 i SQLCODE=0  d  
	 .s result="ok"
	 q result
}

/// Creator：      ans
/// CreatDate：    2014-12-08
/// Description:： 考核例外值表增加数据
/// Table：       DHCWL_CheckFun.DHCWLExceptionalValSet
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.CheckFunData.SaveData).AddexceptValue(.dim)
ClassMethod AddexceptValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("extraId")="2"
	 //s dim("value")="100"
	 //s dim("objId")="1"
	 //s dim("extradateUser")="DTHealth demo"
	 s extraId=$g(dim("extraId"))
     s value=$g(dim("value"))
     s objId=$g(dim("objId"))
     s id=..GetCheckFunExcIdByCode(extraId,objId)
     q:id'="" "该考核对象在该标准值下的例外值已经存在"
     s extradateUser=$g(dim("extradateUser"))
	 s extraUpdateDate=+$h
	 &sql(INSERT INTO DHCWL_CheckFun.DHCWLExceptValSet(ExpValSet_Std_Dr,ExpValSet_Obj_Dr,ExpValSet_Value,ExpValSet_UpdateDate,ExpValSet_UpdateUser) values(:extraId,:objId,:value,:extraUpdateDate,:extradateUser))
	 s id=+$g(%ROWID)
	 s result="failure"
	 i SQLCODE=0  d  
	 .s result="ok"
	 q result
}

ClassMethod GetCheckFunExcIdByCode(standId, objId)
{
	 n (standId,objId)
	 q:(standId="")||(objId="") ""
	 s id=$o(^DHCWL.CheckFun.ExceptValSetI("StandObject",$zcvt(standId,"U")," "_$zcvt(objId,"U"),""))
	 q id
}

/// Creator：      ans
/// CreatDate：    2014-12-08
/// Description:： 考核例外值表删除数据
/// Table：       DHCWL_CheckFun.DHCWLExceptValSet
/// Input：       
/// Output：      
/// Return：      
/// Others：w ##class(DHCWL.CheckFunData.SaveData).DeleteExceptValue(.dim)
ClassMethod DeleteExceptValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("SetCode")="as"
	 //s dim("SetDesc")="as"
	 //s dim("SetSecType")="M"
	 //s dim("SetObjType")="科室"
	 
	 s id=$g(dim("ID"))
     q:'$d(^DHCWL.CheckFun.ExceptValSetD(id)) "请选择要删除的行"
	 s result="failure"
	 s staValueObj=##class(DHCWL.CheckFun.ExceptValSet).%OpenId(id)
	 s sc=##class(DHCWL.CheckFun.ExceptValSet).%DeleteId(id)
	 q:sc'=1 
	 s result="ok"
	 q result
}

/// Creator：      ans
/// CreatDate：    2014-12-13
/// Description:： 历史值删除数据
/// Table：       DHCWL_CheckFun.DHCWLStandardValSet
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).DeleteHStandardValue(.dim)
/// 删除历史值和例外值
ClassMethod DeleteHStandardValue(ByRef dim) As %String
{
	 n (dim,%session)
	 //s dim("ID")=39
	 s id=$g(dim("ID"))
	 q:'$d(^DHCWL.CheckFun.StandardValSetD(id)) "请选择要删除的行"
	 s result="failure"
	 Tstart
	 s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunExcValueByStaId(id)  
	 q:result1="failure"
	 s staValueObj=##class(DHCWL.CheckFun.StandardValSet).%OpenId(id)
	 s sc=##class(DHCWL.CheckFun.StandardValSet).%DeleteId(id)
	 q:sc'=1 
	 s result="ok"
	 i result="failure" Trollback
	 e  TCommit
	 q $g(result)
}

/// Creator：      ans
/// CreatDate：    2014-12-14
/// Description:： 复制历史值下的例外值记录
/// Table：       DHCWL_CheckFun.DHCWLExceptionalValSet
/// Input：       
/// Output：      
/// Return：      成功返回 ok 失败返回 failure
/// Others：w ##class(DHCWL.CheckFunData.SaveData).InsertExcValue(.dim)
ClassMethod InsertExcValue(ID, id) As %String
{
	 n (ID,id)
	 //s ID=11
	 //s id=41
	 k ^TEMPDHCWL($j)
     d GetExcValueObjID(id)
     s sucNum=0
     s result="ok"
     s excRowid=0 f  s excRowid=$o(^DHCWL.CheckFun.ExceptValSetI("Stand",ID,excRowid)) q:excRowid=""  d
     .s objId=$List(^DHCWL.CheckFun.ExceptValSetD(excRowid),3)
     .s value=$List(^DHCWL.CheckFun.ExceptValSetD(excRowid),4)
     .s uDate=$List(^DHCWL.CheckFun.ExceptValSetD(excRowid),5)
     .s uUser=$List(^DHCWL.CheckFun.ExceptValSetD(excRowid),6)
     .q:$d(^TEMPDHCWL($j,"objId",objId))
     .//w excRowid_"^^"_objId_"^^"_value,!  ;
     .&sql(INSERT INTO DHCWL_CheckFun.DHCWLExceptValSet(ExpValSet_Std_Dr,ExpValSet_Obj_Dr,ExpValSet_Value,ExpValSet_UpdateDate,ExpValSet_UpdateUser) values(:id,:objId,:value,:uDate,:uUser))
	 .s result="failure"
	 .i SQLCODE=0  d  
	 ..s result="ok"
	 ..s sucNum=sucNum+1
	 k ^TEMPDHCWL($j)
	 q result

GetExcValueObjID(id)
	n (id)
    s excRowid=0 f  s excRowid=$o(^DHCWL.CheckFun.ExceptValSetI("Stand",id,excRowid)) q:excRowid=""  d
    .s objDr=$List(^DHCWL.CheckFun.ExceptValSetD(excRowid),3)
    .s ^TEMPDHCWL($j,"objId",objDr)=""
    q
}

/// Creator：      ans
/// CreatDate：    2014-12-01
/// Description:： 例外值复制
/// Table：       DHCWL_CheckFun.DHCWLStandardValSet DHCWL_CheckFun.DHCWLExceptionalValSet
/// Input：       
/// Output：      
/// Return：      
/// Others： w ##class(DHCWL.CheckFunData.SaveData).AddInsertExcValue(.dim)
ClassMethod AddInsertExcValue(ByRef dim) As %String
{
	  n (dim,%session)
	 //s dim("ID")="26"
	 s stId=$g(dim("stId"))
	 s ID=$g(dim("ID"))
	 s result="failure"
	 s flag=0
	 Tstart
	 s result2=##class(DHCWL.CheckFunData.SaveData).InsertExcValue(ID,stId)
	 q:result2="failure" result
	 s result="ok"
	 i result="failure" Trollback
	 e  TCommit
	 q result
}

/// Creator：      ans
/// CreatDate：    2015-06-29
/// Description:： 考核方案与考核指标关系表
/// Table：       DHCWL_CheckFun.DHCWLSetKpiRe
/// Input：       
/// Output：      
/// Return：     成功：ok,失败:failure     
/// Others：w ##class(DHCWL.CheckFunData.SaveData).AddCheckFunRel(.dim)
ClassMethod AddCheckFunRel(ByRef dim) As %String
{
	 n (dim,%session)
	 s setId=$g(dim("setId"))
	 i setId="" q "考核方案不能为空"
	 s relkpiId=$g(dim("relkpiId"))
	 i relkpiId="" q "考核指标不能为空"
	 q:$d(^DHCWL.CheckFun.SetKpiReI("SetKpi",setId,relkpiId)) "该指标已经维护"
	 s relUpdateUser=$g(dim("relUpdateUser"))
	 s relUpdateDate=+$h
	 &sql(INSERT INTO DHCWL_CheckFun.DHCWLSetKpiRe(SetKpiRe_Set_Dr,SetKpiRe_Kpi_Dr,SetKpiRe_UpdateDate,SetKpiRe_UpdateUser) values(:setId,:relkpiId,:relUpdateDate,:relUpdateUser))
	 s id=+$g(%ROWID)
	 s result="failure"
	 i SQLCODE=0  d  
	 .s result="ok"
	 q result
}

/// Creator：      ans
/// CreatDate：    2015-06-29
/// Description:： 删除考核方案下的考核指标
/// Table：        DHCWL_CheckFun.DHCWLSetKpiRe
/// Input：       
/// Output：      
/// Return：      成功：ok,失败:failure  
/// Others：      w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunRel(.dim)
///               删除该考核方案下的考核指标时，需要同时删除考核指标对应的标准值和例外值
/// Modify:       2015-07-13
ClassMethod DeleteCheckFunRel(ByRef dim) As %String
{
	 n (dim,%session)
	 
	 
	 s id=$g(dim("ID"))
	 Tstart
     q:'$d(^DHCWL.CheckFun.SetKpiReD(id)) "请选择要删除的行"
	 s result="failure"
	 s kpiId=$list(^DHCWL.CheckFun.SetKpiReD(id),3)
	 s setId=$list(^DHCWL.CheckFun.SetKpiReD(id),2)
	 s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunStandValue(setId,kpiId)
	 q:result1'="ok" result
	 s staValueObj=##class(DHCWL.CheckFun.SetKpiRe).%OpenId(id)
	 s sc=##class(DHCWL.CheckFun.SetKpiRe).%DeleteId(id)
	 q:sc'=1 
	 s result="ok"
	 i result="failure" Trollback
	 e  TCommit
	 q result
}

/// Creator：      ans
/// CreatDate：    2015-07-13
/// Description:： 删除考核方案下的考核指标的标准值以及例外值
/// Table：        DHCWL_CheckFun.DHCWLSetKpiRe
/// Input：        setId:考核方案Id,kpiId:考核指标id
/// Output：      
/// Return：      成功：ok,失败:failure  
/// Others：      w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunStandValue(setId,kpiId)
///               该接口返回值不为failure 即成功
ClassMethod DeleteCheckFunStandValue(setId, kpiId) As %String
{
	 n (setId ,kpiId)
	 q:'$d(^DHCWL.CheckFun.StandardValSetI("SetKPI",setId,kpiId)) "ok"
	 s result="failure"
	 s stId="" f  s stId=$o(^DHCWL.CheckFun.StandardValSetI("SetKPI",setId,kpiId,stId)) q:stId=""  d
	 .s result1=##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunExcValueByStaId(stId)
	 .q:result1="failure" 
	 .s stValueObj=##class(DHCWL.CheckFun.StandardValSet).%OpenId(stId)
	 .s sc=##class(DHCWL.CheckFun.StandardValSet).%DeleteId(stId)
	 .q:sc'=1
	 .s result="ok"
	 q result
}

/// Creator：      ans
/// CreatDate：    2015-07-14
/// Description:： 删除考核方案下的考核指标
/// Table：        DHCWL_CheckFun.DHCWLSetKpiRe
/// Input：       
/// Output：      
/// Return：      成功：ok,失败:failure  
/// Others：      w ##class(DHCWL.CheckFunData.SaveData).DeleteCheckFunRelBySetId(setId)
///               
ClassMethod DeleteCheckFunRelBySetId(setId) As %String
{
	 n (setId)
     q:'$d(^DHCWL.CheckFun.SetKpiReI("Set",setId)) "ok"
	 s result="failure"
	 s id=0 f  s id=$o(^DHCWL.CheckFun.SetKpiReI("Set",setId,id)) q:id=""  d
	 .s staValueObj=##class(DHCWL.CheckFun.SetKpiRe).%OpenId(id)
	 .s sc=##class(DHCWL.CheckFun.SetKpiRe).%DeleteId(id)
	 .q:sc'=1 
	 .s result="ok"
	 q result
}

Storage Default
{
<Data name="SaveDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckFunData.SaveDataD</DataLocation>
<DefaultData>SaveDataDefaultData</DefaultData>
<IdLocation>^DHCWL.CheckFunData.SaveDataD</IdLocation>
<IndexLocation>^DHCWL.CheckFunData.SaveDataI</IndexLocation>
<StreamLocation>^DHCWL.CheckFunData.SaveDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
