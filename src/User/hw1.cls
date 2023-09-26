Class User.hw1 Extends %RegisteredObject
{

/// w ## Class (User.hw1).GetPAAdmSexDesc
ClassMethod GetPAAdmSexDesc(AdmRowId)
{
 s admStr = $p($g(^PAADM(AdmRowId)),"^",1)
 s PatMasStr = $p($g(^PAPER(admStr,"ALL")),"^",7)
 s SexDesc = $p($g(^CT("SEX", PatMasStr)),"^",2)
 w SexDesc
}

}
