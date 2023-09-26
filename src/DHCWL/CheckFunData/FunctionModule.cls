Class DHCWL.CheckFunData.FunctionModule Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ans
/// CreatDate：    2014-12-06
/// Description:： 通过考核方案ID 和考核指标Id获取历史值记录
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgSubGroup
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CheckFunData.FunctionModule).GetHistoryValueBySetKpiId(.dim)
ClassMethod GetHistoryValueBySetKpiId(ByRef dim) As %String
{
	
	n (dim)
	//s dim("ID")=60
	//s dim("kpiId")=22
	//s dim("setId")=23
	//s dim("start")=4
	//s dim("end")=7
	s id=$g(dim("ID"))
	s kpiId=$g(dim("kpiId"))
	s setId=$g(dim("setId"))
	s start=$g(dim("start"))
	s end=$g(dim("end"))
    s ^TEMPDHCWLDJJ("startendsss")=$g(dim("start"))_"^"_$g(dim("end"))_"^"_$g(dim("kpiId"))_"^^^"_$g(dim("setId"))_"^^"_$g(dim("ID"))
	i (kpiId="")||(setId="") q "请选择一条记录"
	s count=0
	s subGrpList=""
	k ^TEMPDHCWL("HValue",$j)
	s hRowid=0 f  s hRowid=$o(^DHCWL.CheckFun.StandardValSetI("SetKPI",setId,kpiId,hRowid)) q:hRowid=""  d
	.s obj=##class(DHCWL.CheckFun.StandardValSet).%OpenId(hRowid)
	.s count=count+1
	.s value=obj.StandardValSetValue
	.s eDate=obj.StandardValSetDate
	.s uDate=obj.StandardValSetUpdateDate
	.s uUser=obj.StandardValSetUpdateUser
	.;s uDate=$zd(uDate,3)
	.s uDate=##class(websys.Conversions).DateLogicalToHtml(uDate)
	.i hRowid=id d
	..s flag="Y"
	.e  d
	..s flag="N"
	.s ^TEMPDHCWL("HValue",$j,count)=hRowid_"^"_value_"^"_eDate_"^"_uDate_"^"_uUser_"^"_flag
	.;s subGrpList=subGrpList_"{ID:"_hRowid_",hValue:'"_value_"',Date:'"_eDate_"',uDate:'"_uDate_"',uUser:'"_uUser_"',flag:'"_flag_"'},"
	f num=1:1:count{
			i (num<start) continue
			i (num>end) continue
			s hRowid=$p($g(^TEMPDHCWL("HValue",$j,num)),"^",1)
			s value=$p($g(^TEMPDHCWL("HValue",$j,num)),"^",2)
			s eDate=$p($g(^TEMPDHCWL("HValue",$j,num)),"^",3)
			s uDate=$p($g(^TEMPDHCWL("HValue",$j,num)),"^",4)
			s uUser=$p($g(^TEMPDHCWL("HValue",$j,num)),"^",5)
			s flag=$p($g(^TEMPDHCWL("HValue",$j,num)),"^",6)
			s subGrpList=subGrpList_"{ID:"_hRowid_",hValue:'"_value_"',Date:'"_eDate_"',uDate:'"_uDate_"',uUser:'"_uUser_"',flag:'"_flag_"'},"
		}
	
	k ^TEMPDHCWL("HValue",$j)
	q subGrpList_"^"_count
}

/// Creator：      ans
/// CreatDate：    2014-12-06
/// Description:： 通过标准值id 获取例外值
/// Table：       DHCWL_CheckFun.DHCWLExceptionalValSet
/// Input：       
/// Output：      
/// Return：      返回JsonData格式和记录数
/// Others：w ##class(DHCWL.CheckFunData.FunctionModule).GetExctraValueById(.dim)
ClassMethod GetExctraValueById(ByRef dim) As %String
{
	
	n (dim,%session)
	//s dim("ID")=1
	//s dim("setId")=1
	//s dim("objId")=""
	//s dim("value")=""
	k ^TEMPDHCWL("objId")
	s setId=dim("setId")
	s objId=dim("objId")
	s mvalue=dim("value")
	s id=$g(dim("ID"))
	do ##class(DHCWL.CheckFunData.CodeTypeItemQuery).GetObjItem(setId)
	s count=0
	s subGrpList=""
	s eRowid=0 f  s eRowid=$o(^DHCWL.CheckFun.ExceptValSetI("Stand",id,eRowid)) q:eRowid=""  d
	.//b ///001
	.s obj=##class(DHCWL.CheckFun.ExceptValSet).%OpenId(eRowid)
	.s value=obj.ExpValSetValue
	.s objDr=obj.ExpValSetObjDr
	.s uDate=obj.ExpValSetUpdateDate
	.s uUser=obj.ExpValSetUpdateUser
	.i objId'="" q:objDr'=objId
	.i mvalue'="" q:value'=mvalue
	.s count=count+1
	.;s uDate=$zd(uDate,3)
	.s uDate=##class(websys.Conversions).DateLogicalToHtml(uDate)
	.s objDesc=$g(^TEMPDHCWL("objId",objDr))
	.s subGrpList=subGrpList_"{ID:"_eRowid_",value:'"_value_"',objId:'"_objDr_"',objDesc:'"_objDesc_"',uUser:'"_uUser_"',uDate:'"_uDate_"'},"
	q subGrpList_"^"_count
	k ^TEMPDHCWL("objId")
}

}
