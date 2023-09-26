Class web.DHCCRM.FUPlan Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Test() As %String
{
 s MRRowID=0
 s int=0
 f  s MRRowID=$o(^DHCMRBase(MRRowID)) q:((MRRowID="")||(int=100))  d
 .s PAADM=$P(^DHCMRBase(MRRowID),"^",4)
 .s Subject=1
 .&sql(insert into sqluser.DHC_CRM_FUPlan (FUP_PAADM_DR,FUP_Subject_DR) values(:PAADM,:Subject ))
 .s int=int+1
 q ""
}

}
