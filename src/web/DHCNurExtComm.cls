Class web.DHCNurExtComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getgrptitle(grpid, typ) As %String
{
    //s a=##class(web.DHCNurExtComm).getgrptitle("DEMOGROUP")
    s ret="["
    s rw=""  f  s rw=$O(^Nur.DHCMGSSGRPLAYOUTI("grp"," "_grpid,rw)) q:rw=""  d
    .s a=^Nur.DHCMGSSGRPLAYOUTD(rw)
    .s grp=$List(a,2) 
    .s title=$List(a,3)
	.s pos=$List(a,4)
	.s t="^"_pos_"^"
	.b
	.q:(typ'[t)&(typ'="All")
	.b //
	.s flag=$List(a,5)
	.//q:flag="N"
	.s ret=ret_"{text:'"_title_"',id:'grp"_rw_"',leaf:false,children:["_..getsubitm(rw)_"]},"
   s a=$e(ret,0,$l(ret)-1)
   s ret=a_"]"
   q ret
}

ClassMethod getsubitm(rw) As %String
{
    s ret=""
    s sub="" f  s sub=$O(^Nur.DHCMGSSGRPLAYOUTSUBD(rw,sub)) q:sub=""  d
    .s moud=$listget(^Nur.DHCMGSSGRPLAYOUTSUBD(rw,sub),4)
    .q:'$D(^Nur.DHCNurExtMoudleD(moud))
    .s a=^Nur.DHCNurExtMoudleD(moud)
    .s mname=$List(a,3) //
    .s mcode=$List(a,2)
    .s ret=ret_"{text:'"_mname_"',id:'"_mcode_"',leaf:true},"
    s a=$e(ret,0,$l(ret)-1)
   q a
}

}
