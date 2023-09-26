Import Sqluser

Class web.PMPPermisBusiness Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod insertPermisBusiness(PermissDR As %String, ssuser As %String) As %String
{
	set Date = +$h
	set Time = $p($h,",",2)
	&sql(insert into SQLUser.PMP_PermisBusiness (PMP_Permission_ParRef,PERBus_User_DR,PERBus_IsEffect,PERBus_Date,PERBus_Time) values (:PermissDR,:ssuser,"Y",:Date,:Time))
 	Quit SQLCODE
}

ClassMethod hasUser(PermissDR As %String, ssuser As %String) As %String
{
	s ret="1"
	s childsub=0 
	s ^shen1=PermissDR_"^"_ssuser
	if $d(^PMPPermisBusiness(PermissDR,"E"))'=0 d
	.f  s childsub=$o(^PMPPermisBusiness(PermissDR,"E",childsub)) q:(childsub="")  d 
	..q:$p(^PMPPermisBusiness(PermissDR,"E",childsub),"^",3)="N"
	..if $p(^PMPPermisBusiness(PermissDR,"E",childsub),"^",4)=ssuser  d  set ret="2"
	
	q ret
}

ClassMethod delByPermissDR(PermissDR As %String) As %String
{
	s ret=""
	if $d(^PMPPermisBusiness(PermissDR,"E"))'=0 d
	.s childsub=0 f  s childsub=$o(^PMPPermisBusiness(PermissDR,"E",childsub)) q:(childsub="")  d 
	..s $p(^PMPPermisBusiness(PermissDR,"E",childsub),"^",3)="N"
	..s ret = "1"
	e  d  s ret = "2"
	q ret
}

}
