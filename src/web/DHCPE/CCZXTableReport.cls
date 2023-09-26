Class web.DHCPE.CCZXTableReport Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetResult(paadmid As %String, Desc As %String, ODDesc As %String)
{
 q:Desc=""||ODDesc=""
 s STRowId=$o(^DHCPEST(0,"Desc",Desc,0))
 q:STRowId="" 
 s ODChildSub=$o(^DHCPEST(0,"OD_Desc",ODDesc,STRowId,0))
 q:ODChildSub=""
 s ODRowId=STRowId_"||"_ODChildSub
 q:ODRowId=""
 s RLTRowId=$o(^DHCPERLT(0,"PAADM_OD",paadmid,ODRowId,0))
 q:RLTRowId="" 
 s Result=$p(^DHCPERLT(RLTRowId),"^",4)
 q Result
}

ClassMethod print(InString As %String = "")
{
 ;个人情况	
 s paadmid=$p(InString,"^",1)       //PA_Adm
 s papatid=$p(^PAADM(paadmid),"^",1)  //PA_PatMas
 s name=$p(^PAPER(papatid,"ALL"),"^",1)  //姓名
 s sexid=$p(^PAPER(papatid,"ALL"),"^",7)  //CT_Sex
 s sex=$p(^CT("SEX",sexid),"^",2)  //性别
 ;外科
 s length=..GetResult(paadmid,"外科","身长")
 s height=..GetResult(paadmid,"外科","体重")
 s chest=..GetResult(paadmid,"外科","胸围")
 s breath=..GetResult(paadmid,"外科","呼吸差")
 s lymph=..GetResult(paadmid,"外科","淋巴")
 s skin=..GetResult(paadmid,"外科","皮肤")
 s spine=..GetResult(paadmid,"外科","脊柱")
 s limbs=..GetResult(paadmid,"外科","四肢")
 s thyroid=..GetResult(paadmid,"外科","甲状腺")
 s mnszq=..GetResult(paadmid,"外科","泌尿生殖器")
 s anus=..GetResult(paadmid,"外科","肛门")
 s wkother=..GetResult(paadmid,"外科","其他")

 ;内科
 s bloodpressurehigh=..GetResult(paadmid,"内科","血压高")
 s bloodpressurelow=..GetResult(paadmid,"内科","血压低")
 s pulse=..GetResult(paadmid,"内科","脉搏")
 s heart=..GetResult(paadmid,"内科","心脏血管系统")
 s lung=..GetResult(paadmid,"内科","肺呼吸道")
 s nerve=..GetResult(paadmid,"内科","精神及神经")
 s belly=..GetResult(paadmid,"内科","腹部脏器")
 s nkother=..GetResult(paadmid,"内科","其他")

 ;五官科
 s eyeright=..GetResult(paadmid,"五官科","视力右")
 s eyeleft=..GetResult(paadmid,"五官科","视力左")
 s jzeyeright=..GetResult(paadmid,"五官科","矫正视力右")
 s jzeyeleft=..GetResult(paadmid,"五官科","矫正视力左")
 s blowholeright=..GetResult(paadmid,"五官科","砂眼右")
 s blowholeleft=..GetResult(paadmid,"五官科","砂眼左")
 s sejue=..GetResult(paadmid,"五官科","色觉")
 s yanji=..GetResult(paadmid,"五官科","眼疾")
 s earright=..GetResult(paadmid,"五官科","听力右")
 s earleft=..GetResult(paadmid,"五官科","听力左")
 s erji=..GetResult(paadmid,"五官科","耳疾")
 s smell=..GetResult(paadmid,"五官科","嗅觉")
 s biji=..GetResult(paadmid,"五官科","鼻疾")
 s throat=..GetResult(paadmid,"五官科","咽喉")
 s tooch=..GetResult(paadmid,"五官科","牙齿")
 s wgkother=..GetResult(paadmid,"五官科","其它")



 q name_"^"_sex
}

}
