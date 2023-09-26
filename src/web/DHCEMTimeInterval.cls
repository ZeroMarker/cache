Import SQLUser

/// Creator: 		yangyongtao
/// CreateDate: 	2019-09-16
/// Descript: 		预约时段维护
Class web.DHCEMTimeInterval Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	预约时段字典
/// w ##class(web.DHCEMTimeInterval).save("8^000003^测试000003^N^65")
ClassMethod save(mParam As %String) As %String
{
	n (mParam)
	s Err=0
	f i=1:1:$l(mParam,"$$") q:Err'=0  d
	.s mdata=$p(mParam,"$$",i)
	.s Err=..isExist(mdata)			/// 检查代码、描述是否重复
	.q:Err'=0
	.//s Err=..isTimeExist(mdata)		/// 检查时间段是否重复
	.q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	q Err
}

/// Descript:	增加 预约时段字典
/// w ##class(web.DHCEMTimeInterval).insert("")
ClassMethod insert(mParam As %String) As %String
{
	n (mParam)
	s Code=$p(mParam,"^",2)			/// 代码
	s Desc=$p(mParam,"^",3)			/// 描述
	s StartTime=$p(mParam,"^",4)   	/// 开始时间
	s:StartTime'="" StartTime=$zth(StartTime,2)
	s EndTime=$p(mParam,"^",5)   	/// 结束时间
	s:EndTime'="" EndTime=$zth(EndTime,2)
	s ActFlag=$p(mParam,"^",6)		/// 不可用标志
	s HospID=$p(mParam,"^",7)		/// 医院ID
	s ModuleID=$p(mParam,"^",8)		/// 模块
 	&SQL(INSERT INTO DHC_EmTimeInterval
 		(ER_Code,ER_Desc,ER_StartTime,ER_EndTime,ER_ActiveFlag,ER_Hosp_Dr,ER_Module) 
 	VALUES
 		(:Code,:Desc,:StartTime,:EndTime,:ActFlag,:HospID,:ModuleID))
 	q SQLCODE
}

/// Descript:	更新 预约时段字典
/// w ##class(web.DHCEMTimeInterval).update("")
ClassMethod update(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)   		/// ID
	s Code=$p(mParam,"^",2)   		/// 代码
	s Desc=$p(mParam,"^",3)   		/// 描述
	s StartTime=$p(mParam,"^",4)   	/// 开始时间
	s:StartTime'="" StartTime=$zth(StartTime,2)
	s EndTime=$p(mParam,"^",5)   	/// 结束时间
	s:EndTime'="" EndTime=$zth(EndTime,2)
	s ActFlag=$p(mParam,"^",6)  	/// 不可用标志
	s HospID=$p(mParam,"^",7)   	/// 医院ID
	s ModuleID=$p(mParam,"^",8)		/// 模块
	&SQL(UPDATE DHC_EmTimeInterval 
	SET ER_Code =:Code,ER_Desc =:Desc,ER_StartTime =:StartTime,ER_EndTime =:EndTime,ER_ActiveFlag =:ActFlag,
		ER_Hosp_Dr =:HospID,ER_Module=:ModuleID WHERE ER_RowID =:ID)
 	q SQLCODE
}

/// Descript:	删除 预约时段字典
/// w ##class(web.DHCEMTimeInterval).delete("1")
ClassMethod delete(ID As %String) As %String
{
	n (ID)
	&SQL(DELETE FROM DHC_EmTimeInterval WHERE ER_RowID =:ID)
	q SQLCODE
}

/// Descript:	查询 预约时段字典
/// w ##class(web.DHCEMTimeInterval).QryEmTimeInterval("12","1","")
ClassMethod QryEmTimeInterval(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s InHospID=$p(Params,"^",1)
	s InHospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmTimeInterval",InHospID)
	k TmpItemDet
	s ID="0",h=0,count=0
	f  s ID=$o(^DHCEMTI(ID)) q:ID=""  d
	.s Code=$p(^DHCEMTI(ID),"^",1)		/// 代码
	.s Desc=$p(^DHCEMTI(ID),"^",2)		/// 描述
	.s StartTime=$p(^DHCEMTI(ID),"^",3)	/// 开始时间
	.s:StartTime'="" StartTime=$zt(StartTime,2)
	.s EndTime=$p(^DHCEMTI(ID),"^",4)	/// 结束时间
	.s:EndTime'="" EndTime=$zt(EndTime,2)
	.s ActCode=$p(^DHCEMTI(ID),"^",5)	/// 可用标志
	.s ActDesc=$s(ActCode="Y":"是",ActCode="N":"否",1:"")
	.s HospID=$p(^DHCEMTI(ID),"^",6)	/// 医院
	.q:(InHospID'="")&&(InHospID'=HospID)
	.s HospDesc=""
	.s:HospID'="" HospDesc=$p(^CT("HOSP",HospID),"^",2)
	.s ModuleID=$p(^DHCEMTI(ID),"^",7)	/// 模块
	.s Module=$s(ModuleID="Doc":"医生班次",ModuleID="Nur":"护士班次",ModuleID="Inf":"输液预约",1:"")
	.s h=h+1
	.s ListData=ID_"^"_Code_"^"_Desc_"^"_StartTime_"^"_EndTime_"^"_ActCode_"^"_ActDesc_"^"_HospID_"^"_HospDesc_"^"_ModuleID_"^"_Module
	.s Index=Code_","_Module
	.s TmpItemDet(Index)=ListData
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)	/// 输出json结尾符
	q:h=0 ""
	
	/// 转换数据为Json格式
	s ListTitle="ID^Code^Desc^StartTime^EndTime^ActCode^ActDesc^HospID^HospDesc^ModuleID^Module"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h)			/// 输出json前缀串
	s index=""
	f  s index=$o(TmpItemDet(index)) q:index=""  d
	.s ListData=$g(TmpItemDet(index))
	.s count=count+1
	.q:(count<Start)||(count>End)
	.w $case(count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign()			/// 输出json结尾符
	q ""
}

/// Descript:	检查代码、描述是否重复
/// w ##class(web.DHCEMTimeInterval).isExist("^早班^早班^00:00^04:00^Y^3^Nur")
ClassMethod isExist(mParam As %String) As %String
{
	n (mParam)
	s ID=$p(mParam,"^",1)		/// ID
	s Code=$p(mParam,"^",2)		/// 代码
	s Desc=$p(mParam,"^",3)		/// 描述
	s HospID=$p(mParam,"^",7)	/// 医院ID
	s ModuleID=$p(mParam,"^",8) /// 模块
	s HasID="",RowID=""
	b ;err
	f  s RowID=$o(^DHCEMTI(0,"Code",$$ALPHAUP^SSUTIL4(Code),RowID)) q:(RowID="")||(HasID'="")  d
	.s RowHospID=$p(^DHCEMTI(RowID),"^",6)
	.s RowModule=$p(^DHCEMTI(RowID),"^",7)
	.;q:(HospID'=RowHospID) //hxy 2023-02-01注释 私有数据医院组间代码不能重复
	.q:(ModuleID'=RowModule)
	.s HasID=RowID
	
	q:(HasID'="")&&(ID="") -1
	q:(HasID'="")&&(ID'="")&&(HasID'=ID) -1
	q 0
}

/// Descript:	描述是否重复
/// w ##class(web.DHCEMTimeInterval).isExistDesc("^AM^^10:00^12:00^Y^2")
ClassMethod isExistDesc(Desc As %String, ModuleID As %String) As %String
{
	n (Desc, ModuleID)
	s ID="", Flag=0
	F  s ID=$o(^DHCEMTI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),ID)) Q:(ID="")||(Flag=1)  D
	.Q:$p(^DHCEMTI(ID),"^",7)'=ModuleID	 /// 模块
	.s Flag=1
	.
	Q Flag
}

/// Descript:	检查时间段是否重复
/// w ##class(web.DHCEMTimeInterval).isTimeExist("^AM^^10:00^12:00^Y^2")
ClassMethod isTimeExist(mParam As %String) As %String
{
	n (mParam)
	s mStartTime=+$p(mParam,"^",4)   	/// 开始时间
	s mEndTime=+$p(mParam,"^",5)   		/// 结束时间
	s rtn=0
	f i=mStartTime:1:mEndTime q:rtn'=0  d
	.s ID=0
	.f  s ID=$o(^DHCEMTI(ID)) q:ID=""  d
	..s StartTime=$p(^DHCEMTI(ID),"^",3)	/// 开始时间
	..s:StartTime'="" StartTime=+$zt(StartTime,2)
	..s EndTime=$p(^DHCEMTI(ID),"^",4)	/// 结束时间
	..s:EndTime'="" EndTime=+$zt(EndTime,2)
	..f j=StartTime+1:1:EndTime-1 d
	...s:i=j rtn="-5"
	q rtn
}

/// Descritp:	预约时段
/// w ##Class(web.DHCEMTimeInterval).jsonTimeInterval("1")
ClassMethod jsonTimeInterval(HospID As %String, Module As %String) As %String
{
	n (HospID, Module,%session)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmTimeInterval",HospID)
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="SELECT ER_RowID,ER_Desc,ER_ActiveFlag FROM DHC_EmTimeInterval"
	i HospID'="" s sqlStr = sqlStr_" Where  ER_Hosp_Dr="_HospID_" AND ER_Module="_""""_Module_""""
    d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	w "["
	while(result.Next())
	{	
		s RowId=result.Data("ER_RowID")
		s Desc=result.Data("ER_Desc")
		S Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmTimeInterval","ERDesc","",Desc)
		continue:Desc=""
		continue:result.Data("ER_ActiveFlag")'="Y"
		s tmp=Desc_"^"_Desc
		s count=count+1
		w $case(count,1:"",:",")
		w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:	预约时间
/// w ##Class(web.DHCEMTimeInterval).jsonTimes("1")
ClassMethod jsonTimes(q As %String) As %String
{
	n (q)
	s count=""
	w "["
	f i=0:1:23 d
	.s time=i
	.s:$l(time)=1 time="0"_time
	.s time=time_":00"
	.s tmp=time_"^"_time
	.q:(q'="")&&(time'[q)
	.s count=count+1
	.w $case(count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

}
