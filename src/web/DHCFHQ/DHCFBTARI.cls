/// 收费项目相关
Class web.DHCFHQ.DHCFBTARI Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetTarPrice(TarId, AdmReason) As %String
{
	q:$g(TarId)="" "False"
	s del="^"
	if $g(AdmReason)="" s AdmReason=$o(^PAC("ADMREA",0))
	Q:'$d(^DHCTARIi("Type",AdmReason,TarId)) "False^此费别没有设置价格"
	s pricestartdate=""
  s pricestartdate=$o(^DHCTARIi("Type",AdmReason,TarId,pricestartdate),-1)
  q:$g(pricestartdate)="" "False"
  s pricerid=$o(^DHCTARIi("Type",AdmReason,TarId,pricestartdate,""))
  s tarprice=$p($g(^DHCTARI(TarId,"P",pricerid)),del,5)
  s tarprice1=$p($g(^DHCTARI(TarId,"P",pricerid)),del,14)
  s tarprice2=$p($g(^DHCTARI(TarId,"P",pricerid)),del,15)
  s DisRate=$p($g(^DHCTARI(TarId,"P",pricerid)),del,12)
  s PayRate=$p($g(^DHCTARI(TarId,"P",pricerid)),del,7)
  s LimitPrice=$p($g(^DHCTARI(TarId,"P",pricerid)),del,6)
  q +tarprice_del_+tarprice1_del_+tarprice2_del_+DisRate_del_+PayRate_del_+LimitPrice
}

ClassMethod GetTarInof(TarId) As %String
{
	s del="^",RetStr="False"
	q:$g(TarId)="" RetStr
	q:'$d(^DHCTARI(TarId)) RetStr
	set itemprice="",pricedr="",payrate="",disrate=""
  SET uom="",str=""
  s str=$g(^DHCTARI(TarId))
  s code=$p(str,del,1),desc=$p(str,del,2)
  q:($g(code)="") RetStr_del_"收费项目代码为空" 
  s uomdr=$p(str,del,3),subcatdr=$p(str,del,4),acctdr=$p(str,del,5)
  s mrdr=$p(str,del,6),active=$p(str,del,7)
  s inpdr=$p(str,del,14),outdr=$p(str,del,15)
  s emdr=$p(str,del,16)
  if $g(uomdr)="" s uom=""
  else  s uom=$p($g(^CT("UOM",uomdr)),del,1)
  IF active="Y" set active="1"
  else  set active="0"
  if $g(subcatdr)="" set subcat="",cat=""
  else  s subcat=$p($g(^DHCTarC("SC",subcatdr)),del,1),catid=$p($g(^DHCTarC("SC",subcatdr)),del,3),cat=$p($g(^DHCTarC("CC",catid)),del,1)
  if $g(acctdr)="" s acct="",acgrp=""
  else  s acct=$p($g(^DHCTarC("AC",acctdr)),del,1),acgrpid=$p($g(^DHCTarC("AC",acctdr)),del,3),acgrp=$p($g(^DHCTarC("TAC",acgrpid)),del,1)
  if $g(mrdr)="" s mr="",mrgrp=""  
  else  s mr=$p($g(^DHCTarC("MC",mrdr)),del,1),mrgrpid=$p($g(^DHCTarC("MC",mrdr)),del,3),mrgrp=$p($g(^DHCTarC("TMC",mrgrpid)),del,1)
  if $g(inpdr)="" s inp="",inpgrp=""  
  else  s inp=$p($g(^DHCTarC("IC",inpdr)),del,1),inpgrpid=$p($g(^DHCTarC("IC",inpdr)),del,3),inpgrp=$p($g(^DHCTarC("TIC",inpgrpid)),del,1)
  if $g(outdr)="" s out="",outgrp=""  
  else  s out=$p($g(^DHCTarC("OC",outdr)),del,1),outgrpid=$p($g(^DHCTarC("OC",outdr)),del,3),outgrp=$p($g(^DHCTarC("TOC",outgrpid)),del,1)
  if $g(emdr)="" s em="",emgrp=""  
  else  s em=$p($g(^DHCTarC("EC",emdr)),del,1),emgrpid=$p($g(^DHCTarC("EC",emdr)),del,3),emgrp=$p($g(^DHCTarC("TEC",emgrpid)),del,1)
  s RetStr=code_del_desc_del_active_del_uom_del_cat_del_subcat_del_inpgrp_del_inp_del_outgrp_del_out_del_emgrp_del_em_del_acgrp_del_acct_del_mrgrp_del_mr
  s RetStr=$tr(RetStr,$c(10,13),"")
  q RetStr
}

}
