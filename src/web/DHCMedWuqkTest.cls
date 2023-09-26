Import SQLUser

Class web.DHCMedWuqkTest Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 15;

ClassMethod GetCTLocByDesc(Desc As %String)
{
	
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s count=0
	s record=""
	s alias=Desc
	i $d(^CTLOC(0,"Desc",alias)) d
	.s id=0
	.f  s id=$o(^CTLOC(0,"Desc",alias,id)) q:id=""  d
	..s count=count+1
	..s ctlocdesc=$p($g(^CTLOC(id)),"^",2)
	..s tmprecord="{id:"_"'"_id_"',desc:'"_ctlocdesc_"'}"
	..s record=record_tmprecord_","
	f  s alias=$o(^CTLOC(0,"Desc",alias)) q:(alias="")!(alias'[Desc)  d
	.s id=0
	.f  s id=$o(^CTLOC(0,"Desc",alias,id)) q:id=""  d
	..s count=count+1
	..s ctlocdesc=$p($g(^CTLOC(id)),"^",2)
	..s tmprecord="{'id':"_"'"_id_"','desc':'"_ctlocdesc_"'}"
	..s record=record_tmprecord_","
	s:record'="" record=$e(record,1,$l(record)-1)
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
}

Query QueryCtLoc(ss As %String) As %SQLQuery(CONTAINID = 1)
{
  SELECT %ID,CTLOC_Desc FROM CT_Loc where (CTLOC_Desc %STARTSWITH :ss)
}

ClassMethod Delete()
{
	s id=0
	f  s id=$o(^DHCMPOS(id)) q:id=""  d
	.s s=$g(^DHCMPOS(id))
	.s s=$tr(s,$c(0),"")
	.s ^DHCMPOS(id)=s
	q
}

}
