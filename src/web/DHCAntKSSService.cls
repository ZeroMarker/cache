Class web.DHCAntKSSService Extends %RegisteredObject
{

/// Creator：      hw
/// CreatDate：    2016-3-22
/// Description:： 通过医护人员code获取抗生素审核权限
/// Table：        CT_CareProv,CT_CarPrvTp,CarPrvTpPHPoison
/// Input：        医护人员code
/// Output：       不同情况下抗菌药物审核权限
/// Return：       住院非限制^住院限制^住院特殊^门诊非限制^门诊限制^门诊特殊^急诊非限制^急诊限制^急诊特殊
/// Others：       Y ：具备审核权限  其他： 无审核权限
/// w ##class(web.DHCAntKSSService).GetKSSPermission("298")
ClassMethod GetKSSPermission(UserCode As %String)
{
 s rtn="^^^^^^^^"
 q:$g(UserCode)="" rtn
 s UserCode=$zcvt(UserCode,"U")
 S CTCPRowid=$o(^CTPCP(0,"Code",UserCode,0))
 q:CTCPRowid="" rtn
 s CTCPTDr=$p(^CTPCP(CTCPRowid,1),"^",4)
 s Child=0 
 f  s Child=$O(^CT("CPT",CTCPTDr,"PHPO",Child)) q:Child=""  d
 .s loctype=$p(^CT("CPT",CTCPTDr,"PHPO",Child),"^",3)
 .;q:((loctype'="I")&&(loctype'="O")&&(loctype'="E"))
 .s PoisonRowId=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",1)
 .s PoisonCode=$p(^PHCPO(PoisonRowId),"^",1)
 .q:PoisonCode'["KSS"
 .s flag=$p(^CT("CPT",CTCPTDr,"PHPO",Child),"^",4)
 
 .i $d(^CT(0,"CPDR",CTCPRowid,CTCPTDr,Child)) d
 ..s rowid=$o(^CT(0,"CPDR",CTCPRowid,CTCPTDr,Child,""))
 ..s AntPrescBility=$P(^CT("CPT",CTCPTDr,"PHPO",Child,"CP",rowid),"^",5)
 ..s flag=$P(^CT("CPT",CTCPTDr,"PHPO",Child,"CP",rowid),"^",8)
 ..i AntPrescBility'="Y" s flag="N"
 
 .i loctype="I" s i=0
 .i loctype="O" s i=1
 .i loctype="E" s i=2
 .i PoisonCode="KSS1" s j=1
 .i PoisonCode="KSS2" s j=2
 .i PoisonCode="KSS3" s j=3
 .s num=i*3+j
 .s $p(rtn,"^",num)=flag
 q rtn
}

}
