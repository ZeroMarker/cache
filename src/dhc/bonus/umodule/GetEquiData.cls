Class dhc.bonus.umodule.GetEquiData Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//w ##class(dhc.bonus.umodule.GetEquiData).GetEquiData("2015","01","3","chenwen")

ClassMethod GetEquiData(sYear, sMonth, MethodDr, user) As %String
{
	n (sYear,sMonth,MethodDr,user)
	s Month="M"_sMonth
	s sBeginDate=sYear _"-"_ sMonth_"-01"
	s sMonth=sMonth+1
	s sEndDate=sYear_"-"_ sMonth _"-01"
	s sMonth=sMonth-1
	
	s sBeginDate=$zdh(sBeginDate,3)
	s sEndDate=$zdh(sEndDate,3)-1 
	;w sBeginDate_":"_sEndDate,!
	i $l(sMonth)=1 d
	.s sMonth="0"_sMonth
	&sql( delete from dhc_bonus_module.BonusExpendCollect where BonusYear=:sYear and  BonusPeriod =:Month and  Methord=3)
	
	k ^TMP("dhc","ca","Depreciation")
	d ##Class(web.DHCEQForCA).getDepreciation(sBeginDate,sEndDate,"",1)

	s rowid=""
	f  s rowid=$o(^TMP("dhc","ca","Depreciation",$j,rowid)) quit:rowid=""  d
	.s DeptCode=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",2)
	.s DeptName=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",3)
	.s DeptName=$p(DeptName,"-",2)
	.s ItemCode=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",4)
	.s ItemCode="03_"_ItemCode
	.k ^cwtemp
	.s ^cwtemp=ItemCode
	.s ItemName=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",5)
	.s ItemVale=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",6)
	.s date=$zd($h,3)
	.s date=$zdh(date,3)
	.;s ZjlyCode=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",10)
	.;s ZjlyName=$p(^TMP("dhc","ca","Depreciation",$j,rowid),"^",11)
	.;w DeptCode_":"_DeptName_":"_ItemCode_":"_ItemName_":"_ItemVale_":"_ZjlyCode_":"_ZjlyName,!
	.&SQL(insert into dhc_bonus_module.BonusExpendCollect(DeptCode,DeptName,BonusYear,
		BonusPeriod,ItemCode,ItemName,ItemValue,CollectDate,Operator,state,Methord,IsValue
	) values(:DeptCode,:DeptName,:sYear,:Month,:ItemCode,:ItemName,:ItemVale,:date,:user,0,:MethodDr,"Y"))
	.;W SQLCODE,!
	q 0
}

Storage Default
{
<StreamLocation>^dhc.bonus.umodule.GetEquiDataS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
