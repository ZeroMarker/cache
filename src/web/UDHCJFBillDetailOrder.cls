Import SQLUser

Class web.UDHCJFBillDetailOrder Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: zhuangna
/// CreatDate: 2015-08-12
/// Description: 查询就诊下的医嘱明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFBillDetailOrder","FindBillOrderDetail","26","","","")
Query FindBillOrderDetail(BillNo As %String, stDate As %String, endDate As %String, userDeptId As %String, ordCatId As %String, ordSubCatId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Ttaridesc:%String:项目分类,Torder:%String:医嘱,Tuom:%String:单位,Tunitprice:%Float:单价,Tqty:%String:数量,Tprice:%Float:金额,PhcfDesc:%String:剂型,PhmnfName:%String:产地,BillNo:%String:账单ID,tariID:%String,TOEORI:%String:医嘱ID")
{
}

ClassMethod FindBillOrderDetailExecute(ByRef qHandle As %Binary, BillNo As %String, stDate As %String, endDate As %String, userDeptId As %String, ordCatId As %String, ordSubCatId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindBillOrderDetail")=$lb(BillNo, stDate, endDate, userDeptId, ordCatId, ordSubCatId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	kill ^||TMP($j)
	
	do ..SetPBOrderDetail(BillNo, stDate, endDate, userDeptId, ordCatId, ordSubCatId)
	set motherAdm=$p(^DHCPB(BillNo),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(motherAdm)
	set conf=##class(web.DHCBillCommon).GetTarParaId(hospDR)
	set newBornToMother=$s((+conf'=0):$p(^DHCTarC("CF",conf),"^",5),1:"")
	if (($d(^PAADMi("Mother",motherAdm)))&&(newBornToMother="Y")) {
		do ..OutPutBillDetailInBabyNew(BillNo, motherAdm)
	}else {
		do ..OutPutBillDetailNew(BillNo)
	}
	
	kill ^||TMP($j)
	
	quit $$$OK
}

/// do ##class(web.UDHCJFBillDetailOrder).SetPBOrderDetail(118029)
ClassMethod SetPBOrderDetail(pb As %String, stDate As %String, endDate As %String, userDeptId As %String, ordCatId As %String, ordSubCatId As %String) As %String
{
	set pbo=0
	while($o(^DHCPB(pb,"O",pbo))) {
		set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set pboRowId=pb_"||"_pbo
		set arcim=$p(pboData,"^",3)
		set itmSubCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		continue:((ordSubCatId'="")&&(ordSubCatId'=itmSubCatDR))
		set itmCatDR=$p(^ARC("IC",itmSubCatDR),"^",8)    //ARCIC_OrdCat_DR
		continue:((ordCatId'="")&&(ordCatId'=itmCatDR))
		set oeitm=$p(pboData,"^",4)
		set oeAdm=+$p(^OEORD(+oeitm),"^",1)
		set userDeptDR=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),7)),"^",2) //开医嘱录入科室
		continue:((userDeptDR'=userDeptId)&&(userDeptId'=""))
		set orderDate=$p(pboData,"^",12)
		continue:((stDate'="")&&(orderDate<stDate))
		continue:((endDate'="")&&(orderDate>endDate))
		do ..GetOrder(pboRowId, oeAdm)
	}
  	
	quit
}

ClassMethod GetOrder(pboRowId, adm)
{
	set pb=$p(pboRowId,"||",1)
	set pbo=$p(pboRowId,"||",2)
	set pboData=$g(^DHCPB(pb,"O",pbo))
	set arcim=$p(pboData,"^",3)
	set PhInfo=..getdrginfo(arcim)
	set PhcfDesc=$p(PhInfo,"^",1)
	set PhmnfName=$p(PhInfo,"^",2)
	set oeitm=$p(pboData,"^",4)
	set ordtot=$p(pboData,"^",8)
	set ordtot=$fn(ordtot,"",2)
	set uomDesc=##class(web.DHCBillCommon).GetBaseUom(arcim, oeitm)
	set itmSubCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	set itmCatDR=$p(^ARC("IC",itmSubCatDR),"^",8)    //ARCIC_OrdCat_DR
	set qtyPrice=##class(BILL.IP.BL.NurseFee).GetOrderQtyPrice(pb, pbo)		//+WangXQ 20230424 获取医嘱已计费数量和单价
	set ordQty=$lg(qtyPrice,1)
	set ordPrice=$lg(qtyPrice,2)
	set ordPrice=$fn(ordPrice,"",4)
	if $d(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice)) {
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),1)=$lg($g(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice)),1)+ordQty
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),2)=$lg($g(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice)),2)+ordtot
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),3)=arcim
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),4)=uomDesc
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),5)=adm
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),8)=PhcfDesc
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),9)=PhmnfName
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),10)=oeitm
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),11)=""
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),12)=""
	}else {
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),1)=ordQty
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),2)=ordtot
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),3)=arcim
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),4)=uomDesc
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),5)=adm
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),8)=PhcfDesc
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),9)=PhmnfName
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),10)=oeitm
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),11)=""
		set $li(^||TMP($j,"ItemCat",adm,itmCatDR,arcim,ordPrice),12)=""
	}
	quit
}

/// CreatDate: 2011-09-06
/// Creator: wangjian
/// Description: 获取剂型和产地
/// Input: 医嘱项RowId
/// Return: 剂型_"^"_产地
/// Debug: w ##class(web.UDHCJFBillDetailOrder).getdrginfo()
ClassMethod getdrginfo(Arcim As %String) As %String
{
	new (Arcim)
	set (PhcfDesc, PhmnfName)=""
	set PhcdfDr=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",12)
	quit:(PhcdfDr="") PhcfDesc_"^"_PhmnfName
	
	set PhcfDr=$p($g(^PHCD(+PhcdfDr,"DF",$p(PhcdfDr,"||",2),1)),"^",1)   //指向表phc_form
	set PhcfDesc=$s((+PhcfDr'=0):$p($g(^PHCF(PhcfDr)),"^",2),1:"")       //剂型
	set PhmnfDr=$p($g(^PHCD(+PhcdfDr,2)),"^",4)                               //phc_drgmast   指向表PH_Manufacturer 
	set PhmnfName=$s((+PhmnfDr'=0):$p($g(^PHMNF(PhmnfDr)),"^",2),1:"")   //产地

	quit PhcfDesc_"^"_PhmnfName
}

ClassMethod OutPutBillDetailNew(BillNo)
{
	set all=0, grzfSum=0
	set sumall=0, oeitm=""
	set cat=""
	for  set cat=$o(^||TMP($j,cat)) quit:(cat="")  do  ;区分是打印收费项目还是医嘱项
	.set AdmRowId=""
	.for  set AdmRowId=$o(^||TMP($j,cat,AdmRowId)) quit:(AdmRowId="")  do
	..set taricID=""
	..for  set taricID=$o(^||TMP($j,cat,AdmRowId,taricID)) quit:(taricID="")  do  ;分类Id
	...set tarisum=0, tarigrzfSum=0
	...set tariID=""
	...for  set tariID=$o(^||TMP($j,cat,AdmRowId,taricID,tariID)) quit:(tariID="")  do  //项目ID
	....set price=""
	....for  set price=$o(^||TMP($j,cat,AdmRowId,taricID,tariID,price)) quit:(price="")  do  //金额
	.....set itmInfo=$g(^||TMP($j,cat,AdmRowId,taricID,tariID,price))
	.....if (cat="IPCat") do
	......set taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......set taricDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", taricDesc, langId)
	......set tariDesc=$p(^DHCTARI(tariID),"^",2)
	......set taricDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tariDesc, langId)
	.....if (cat="ItemCat") do
	......set taricDesc=$p(^OEC("ORCAT",taricID),"^",2)
	......set taricDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", taricDesc, langId)
	......set tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
	......set tariDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", tariDesc, langId)
	.....set uomDesc=$lg(itmInfo,4)          //单位
	.....set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
	.....set qty=$lg(itmInfo,1)
	.....quit:(+qty=0)
	.....set sum=$fn($lg(itmInfo,2),"",2)
	.....set tarisum=tarisum+sum
	.....set all=all+sum
	.....set sumall=sumall+sum
	.....set myArcimId=$lg(itmInfo,3)
	.....set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....if (DrugCommonDesc'="") set tariDesc=DrugCommonDesc
	.....set myblzf=$lg(itmInfo,6)
	.....set mygrzf=$lg(itmInfo,7)
	.....set tarigrzfSum=tarigrzfSum+mygrzf
	.....set grzfSum=grzfSum+mygrzf
	.....set PhcfDesc=$lg(itmInfo,8)
	.....set PhmnfName=$lg(itmInfo,9)
	.....set oeitm=$lg(itmInfo,10)   //2015-08-12 zhuangna
	.....if (oeitm'="") do
	......set depProcNotes=$g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DEP",1))   //医嘱备注
	......if (depProcNotes'="") set tariDesc=tariDesc_"("_depProcNotes_")"
	.....do OutputRowNew
	set taricDesc=##class(websys.Translation).Get("", "合计", langId)
	set tariDesc="", uomDesc="", price="", qty="", oeitm="", sum=$fn(sumall,"",2), PhcfDesc="", PhmnfName=""
	set myblzf="", mygrzf=$fn(grzfSum,"",2)  ;医保比例自负，个人自费
	do OutputRowNew
	quit $$$OK
OutputRowNew
	set:(+myblzf=0) myblzf=""
	set:(+mygrzf=0) mygrzf=""
	set Data=$lb(taricDesc,tariDesc,uomDesc,price,qty,sum,PhcfDesc,PhmnfName,BillNo,tariID,oeitm)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

ClassMethod OutPutBillDetailInBabyNew(BillNo, motherAdm)
{
	set all=0, grzfSum=0
	set sumall=0
	set cat=""
	for  set cat=$o(^||TMP($j,cat)) quit:(cat="")  do   //区分是打印收费项目还是医嘱项
	.set AdmRowId=""
	.for  set AdmRowId=$o(^||TMP($j,cat,AdmRowId)) quit:(AdmRowId="")  do
	..quit:(AdmRowId'=motherAdm)
	..set isOP2IP=##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByOPAdm(AdmRowId)
	..quit:(isOP2IP=1)
	..set taricID=""
	..for  set taricID=$o(^||TMP($j,cat,AdmRowId,taricID)) quit:(taricID="")  do  ;分类Id
	...set tarisum=0, tarigrzfSum=0
	...set tariID=""
	...for  set tariID=$o(^||TMP($j,cat,AdmRowId,taricID,tariID)) quit:(tariID="")  do  ;项目ID
	....set price=""
	....for  set price=$o(^||TMP($j,cat,AdmRowId,taricID,tariID,price)) quit:(price="")  do  ;金额
	.....set itmInfo=$g(^||TMP($j,cat,AdmRowId,taricID,tariID,price))
	.....set ExternalCode=""
	.....if (cat="IPCat") do
	......set taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......set taricDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", taricDesc, langId)
	......set tariDesc=$p(^DHCTARI(tariID),"^",2)
	......set taricDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tariDesc, langId)
	......set tariCode=$p(^DHCTARI(tariID),"^",1)
	......set InsuName=$p(^DHCTARI(tariID),"^",18)	;医保名称
	......set ExternalCode=$p(^DHCTARI(tariID),"^",13)
	.....if (cat="ItemCat") do
	......set taricDesc=$p(^OEC("ORCAT",taricID),"^",2)
	......set taricDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", taricDesc, langId)
	......set tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
	......set tariDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", tariDesc, langId)
	......set tariCode=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",1)
	......set InsuName=""
	.....set uomDesc=$lg(itmInfo,4)          //单位
	.....set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
	.....set qty=$lg(itmInfo,1)
	.....quit:(+qty=0)
	.....set sum=$fn($lg(itmInfo,2),"",2)
	.....set tarisum=tarisum+sum
	.....set all=all+sum
	.....set sumall=sumall+sum
	.....set myArcimId=$lg(itmInfo,3)
	.....set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....if (DrugCommonDesc'="") set tariDesc=DrugCommonDesc 
	.....set myblzf=$lg(itmInfo,6)
	.....set mygrzf=$lg(itmInfo,7)
	.....set tarigrzfSum=tarigrzfSum+mygrzf
	.....set grzfSum=grzfSum+mygrzf
	.....set PhcfDesc=$lg(itmInfo,8)
	.....set PhmnfName=$lg(itmInfo,9)
	.....set oeitm=$lg(itmInfo,10)    //2015-08-12 zhuangna
	.....if (oeitm'="") do
	......set depProcNotes=$g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DEP",1))   //医嘱备注
	......if (depProcNotes'="") set tariDesc=tariDesc_"("_depProcNotes_")"
	.....do OutputRowInBabyNew
	set taricDesc=##class(websys.Translation).Get("", "母亲合计", langId)
	set tariDesc="", uomDesc="", price="", oeitm="", qty="", sum=$fn(sumall,"",2), PhcfDesc="", PhmnfName="", tariCode="", ExternalCode=""
	set myblzf="", mygrzf=$fn(grzfSum,"",2) ;医保比例自负，个人自费
	do OutputRowInBabyNew
	
	set sumall=0
	set cat=""
	for  set cat=$o(^||TMP($j,cat)) quit:(cat="")  do  ;区分是打印收费项目还是医嘱项
	.set AdmRowId=""
	.for  set AdmRowId=$o(^||TMP($j,cat,AdmRowId)) quit:(AdmRowId="")  do
	..quit:(AdmRowId=motherAdm)
	..set isOP2IP=##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByOPAdm(AdmRowId)
	..quit:(isOP2IP=1)
	..set taricID=""
	..for  set taricID=$o(^||TMP($j,cat,AdmRowId,taricID)) quit:(taricID="")  do  ;分类Id
	...set tarisum=0, tarigrzfSum=0
	...set tariID=""
	...for  set tariID=$o(^||TMP($j,cat,AdmRowId,taricID,tariID)) quit:(tariID="")  do  ;项目ID
	....set price=""
	....for  set price=$o(^||TMP($j,cat,AdmRowId,taricID,tariID,price)) quit:(price="")  do  ;金额
	.....set itmInfo=$g(^||TMP($j,cat,AdmRowId,taricID,tariID,price))
	.....if (cat="IPCat") do
	......set taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......set taricDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", taricDesc, langId)
	......set tariDesc=$p(^DHCTARI(tariID),"^",2)
	......set taricDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tariDesc, langId)
	......set tariCode=$p(^DHCTARI(tariID),"^",1)
	......set InsuName=$p(^DHCTARI(tariID),"^",18)	 //取医保名称
	.....if (cat="ItemCat") do
	......set taricDesc=$p(^OEC("ORCAT",taricID),"^",2)
	......set taricDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", taricDesc, langId)
	......set tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
	......set tariDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", tariDesc, langId)
	......set tariCode=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",1)
	......set InsuName=""
	.....set uomDesc=$lg(itmInfo,4)          //单位
	.....set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
	.....set qty=$lg(itmInfo,1)
	.....quit:(+qty=0)
	.....set sum=$fn($lg(itmInfo,2),"",2)
	.....set tarisum=tarisum+sum
	.....set all=all+sum
	.....set sumall=sumall+sum
	.....set myArcimId=$lg(itmInfo,3)
	.....set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....if (DrugCommonDesc'="") set tariDesc=DrugCommonDesc 
	.....set myblzf=$lg(itmInfo,6)
	.....set mygrzf=$lg(itmInfo,7)
	.....set tarigrzfSum=tarigrzfSum+mygrzf
	.....set grzfSum=grzfSum+mygrzf
	.....set PhcfDesc=$lg(itmInfo,8)
	.....set PhmnfName=$lg(itmInfo,9)
	.....set oeitm=$lg(itmInfo,10)    //2015-08-12 zhuangna
	.....if (oeitm'="") do
	......set depProcNotes=$g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DEP",1))   //医嘱备注
	......if (depProcNotes'="") set tariDesc=tariDesc_"("_depProcNotes_")"
	.....do OutputRowInBabyNew
	set taricDesc=##class(websys.Translation).Get("", "婴儿合计", langId)
	set tariDesc="", oeitm="", uomDesc="", price="", qty="", sum=$fn(sumall,"",2), PhcfDesc="", PhmnfName="", tariCode="", ExternalCode=""
	set myblzf="", mygrzf=$fn(grzfSum,"",2)   ;医保比例自负，个人自费
	do OutputRowInBabyNew
	
	set sumall=0
	set cat=""
	for  set cat=$o(^||TMP($j,cat)) quit:(cat="")  do   ;区分是打印收费项目还是医嘱项
	.set AdmRowId=""
	.for  set AdmRowId=$o(^||TMP($j,cat,AdmRowId)) quit:(AdmRowId="")  do
	..set isOP2IP=##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByOPAdm(AdmRowId)
	..quit:(isOP2IP'=1)
	..set taricID=""
	..for  set taricID=$o(^||TMP($j,cat,AdmRowId,taricID)) quit:(taricID="")  do  ;分类Id
	...set tarisum=0, tarigrzfSum=0
	...set tariID=""
	...for  set tariID=$o(^||TMP($j,cat,AdmRowId,taricID,tariID)) quit:(tariID="")  do  ;项目ID
	....set price=""
	....for  set price=$o(^||TMP($j,cat,AdmRowId,taricID,tariID,price)) quit:(price="")  do  ;金额
	.....set itmInfo=$g(^||TMP($j,cat,AdmRowId,taricID,tariID,price))
	.....if (cat="IPCat") do
	......set taricDesc=$p(^DHCTarC("TIC",taricID),"^",2)
	......set taricDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", taricDesc, langId)
	......set tariDesc=$p(^DHCTARI(tariID),"^",2)
	......set taricDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tariDesc, langId)
	......set tariCode=$p(^DHCTARI(tariID),"^",1)
	......set InsuName=$p(^DHCTARI(tariID),"^",18)	//医保名称
	.....if (cat="ItemCat") do
	......set taricDesc=$p(^OEC("ORCAT",taricID),"^",2)
	......set taricDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", taricDesc, langId)
	......set tariDesc=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",2)
	......set tariDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", tariDesc, langId)
	......set tariCode=$p(^ARCIM(+tariID,$p(tariID,"||",2),1),"^",1)
	......set InsuName=""
	.....set uomDesc=$lg(itmInfo,4)       //单位
	.....set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
	.....set qty=$lg(itmInfo,1)
	.....quit:(+qty=0)
	.....set sum=$fn($lg(itmInfo,2),"",2)
	.....set tarisum=tarisum+sum
	.....set all=all+sum
	.....set sumall=sumall+sum
	.....set myArcimId=$lg(itmInfo,3)
	.....set DrugCommonDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(myArcimId)
	.....if (DrugCommonDesc'="") set tariDesc=DrugCommonDesc
	.....set myblzf=$lg(itmInfo,6)
	.....set mygrzf=$lg(itmInfo,7)
	.....set tarigrzfSum=tarigrzfSum+mygrzf
	.....set grzfSum=grzfSum+mygrzf
	.....set PhcfDesc=$lg(itmInfo,8)
	.....set PhmnfName=$lg(itmInfo,9)
	.....set oeitm=$lg(itmInfo,10)    //2015-08-12 zhuangna
	.....if (oeitm'="") do
	......set depProcNotes=$g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DEP",1))   //医嘱备注
	......if (depProcNotes'="") set tariDesc=tariDesc_"("_depProcNotes_")"
	.....do OutputRowInBabyNew
	set taricDesc=##class(websys.Translation).Get("", "门诊转住院合计", langId)
	set tariDesc="", oeitm="", uomDesc="", price="", qty="", sum=$fn(sumall,"",2), PhcfDesc="", PhmnfName="", tariCode="", ExternalCode=""
	set myblzf="", mygrzf=$fn(grzfSum,"",2)  //医保比例自负，个人自费
	do OutputRowInBabyNew
	set taricDesc=##class(websys.Translation).Get("", "合计", langId)
	set tariDesc="", uomDesc="", oeitm="", price="", qty="", sum=$fn(all,"",2), PhcfDesc="", PhmnfName="", tariCode="", ExternalCode=""
	set myblzf="", mygrzf=$fn(grzfSum,"",2) //医保比例自负，个人自费
	do OutputRowInBabyNew
	quit
OutputRowInBabyNew
	set:(+myblzf=0) myblzf=""
	set:(+mygrzf=0) mygrzf=""
	set Data=$lb(taricDesc,tariDesc,uomDesc,price,qty,sum,PhcfDesc,PhmnfName,BillNo,tariID,oeitm)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFBillDetailOrder","FindOeordexecFee","553||11","","","",230551)
Query FindOeordexecFee(OEORI As %String, StDate As %String, EndDate As %String, BillNo As %String, LangId As %String = "") As websys.Query(ROWSPEC = "DateExecuted:%String:执行时间,OrderStatus:%String:执行状态,ctpcp:%String:处理人,OeoreLoc:%String:开单科室,TExStDate:%String:要求执行时间,TPatamt:%Float:金额,TBillOrdrowid:%String:账单医嘱ID,TBillFlag:%String:计费状态,TCollectQty:%String:发药数量,TRefundQty:%String:退药数量,TOrdExcRowID:%String:执行记录ID,Tconfflag:%String,Tdoctor:%String:开医嘱人,TordPrior:%String:医嘱优先级,TPatnum:%String:数量")
{
}

ClassMethod FindOeordexecFeeExecute(ByRef qHandle As %Binary, OEORI As %String, StDate As %String, EndDate As %String, BillNo As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
	if (OEORI="") quit $$$OK
	set ^TMP("FindOeordexecFee")=$lb(OEORI, StDate, EndDate, BillNo)
	if ((LangId="")&&($d(%session))) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
    set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
    set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
    
	set oeord=+OEORI, oeordsub=$p(OEORI,"||",2)
	set PriorityDR=$p($g(^OEORD(oeord,"I",oeordsub,1)),"^",8)		//2015-08-20 zhuangna 医嘱类型
	set PriorityCode=$p($g(^OECPR(PriorityDR)),"^",1)						//2015-08-20 zhuangna 医嘱类型code
	set Priority=$p($g(^OECPR(PriorityDR)),"^",2)
	set OrderCtpcpDr=$p($g(^OEORD(oeord,"I",oeordsub,7)),"^",1)  //开医嘱人
	//set OrderCtpcp=$s((+OrderCtpcpDr'=0):$p($g(^SSU("SSUSR",OrderCtpcpDr)),"^",2),1:"")   //开医嘱人

	set (BilledNum,BilledSum,OtherBilledNum,OtherBilledSum)=0
	if (PriorityCode="NORM")  do
	.set ArcItmast=$p($g(^OEORD(oeord,"I",oeordsub,1)),"^",2)		//2015-08-20 zhuangna 医嘱项
	.set OeordSub=0
	.for  set OeordSub=$o(^OEORD(oeord,"I",OeordSub)) quit:(OeordSub="")  do
	..set myArcItmast=$p($g(^OEORD(oeord,"I",OeordSub,1)),"^",2)		//2015-08-20 zhuangna 医嘱项
	..quit:(myArcItmast'=ArcItmast)
	..//根据科室id过滤
	..set PriorityDR=$p($g(^OEORD(oeord,"I",OeordSub,1)),"^",8)		//2015-08-20 zhuangna 医嘱类型
	..set Priority=$p($g(^OECPR(PriorityDR)),"^",2)
	..set Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc", Priority, LangId)
	..set OrderCtpcpDr=$p($g(^OEORD(oeord,"I",OeordSub,7)),"^",1)  //开医嘱人
	..set OrderCtpcp=$s((+OrderCtpcpDr'=0):$p($g(^SSU("SSUSR",OrderCtpcpDr)),"^",2),1:"")
	..set OrderCtpcp=##class(User.SSUser).GetTranByDesc("SSUSRName", OrderCtpcp, LangId)
	..set OEChildsub=0
	..for  set OEChildsub=$o(^OEORD(oeord,"I",OeordSub,"X",OEChildsub)) quit:(OEChildsub="")  do
	...quit:$g(^OEORD(oeord,"I",OeordSub,"X",OEChildsub))=""
	...set oeordexec=oeord_"||"_OeordSub_"||"_OEChildsub
	...set PBRowid=$o(^DHCPB(0,"OEEXC",oeordexec,""),-1)
	...quit:(PBRowid'=BillNo)
	...set ctpcpdr=$p(^OEORD(oeord,"I",OeordSub,"X",OEChildsub),"^",15)
	...set ctpcp=$s((+ctpcpdr'=0):$p($g(^CTPCP(ctpcpdr,1)),"^",2),1:"")  //执行人
	...set ctpcp=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", ctpcp, LangId)
	...set OrderStatusdr=$p(^OEORD(oeord,"I",OeordSub,"X",OEChildsub),"^",16)
	...set OrderStatus=$s((+OrderStatusdr'=0):$p($g(^OEC("STAT",OrderStatusdr)),"^",2),1:"")
	...set OrderStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc", OrderStatus, LangId)
	...set DateExecuted=$p(^OEORD(oeord,"I",OeordSub,"X",OEChildsub),"^",19)
	...set TimeExecuted=$p(^OEORD(oeord,"I",OeordSub,"X",OEChildsub),"^",20)
	...if (DateExecuted'="") set DateExecuted=##class(websys.Conversions).DateLogicalToHtml(DateExecuted)_" "_##class(websys.Conversions).TimeLogicalToHtml(TimeExecuted,1) ;执行时间
	...set OeoreLocdr=$p($g(^OEORD(oeord,"I",OeordSub,7)),"^",2)	 //开单科室
	...set OeoreLoc=$s((+OeoreLocdr'=0):$p($g(^CTLOC(OeoreLocdr)),"^",2),1:"")
	...set OeoreLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", OeoreLoc, LangId)
	...set TExStDate=$p(^OEORD(oeord,"I",OeordSub,"X",OEChildsub),"^",1)   //OEORE_ExStDate 要求执行时间
	...quit:((TExStDate<StDate)&&(StDate'=""))
	...quit:((TExStDate>EndDate)&&(EndDate'=""))
	...set TExStTime=$p(^OEORD(oeord,"I",OeordSub,"X",OEChildsub),"^",2) //OEORE_ExStTime
	...if (TExStDate'="") set TExStDate=##class(websys.Conversions).DateLogicalToHtml(TExStDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(TExStTime,1)
	...set Patamt="0.00", Patnum="0"
	...set BillOrdrowid=""
	...set OEExcRowID=oeord_"||"_OeordSub_"||"_OEChildsub
	...set PBRowid=0
	...for  set PBRowid=$o(^DHCPB(0,"OEEXC",OEExcRowID,PBRowid)) quit:(PBRowid="")  do
	....set OrdSub=0
	....for  set OrdSub=$o(^DHCPB(0,"OEEXC",OEExcRowID,PBRowid,OrdSub)) quit:(OrdSub="")  do
	.....set pboData=$g(^DHCPB(PBRowid,"O",OrdSub))
	.....quit:(pboData="")
	.....set Patamt=$fn($p(pboData,"^",8),"",2)
	.....set Patnum=$p(pboData,"^",5)
	.....set Refnum=$p(pboData,"^",6)
	.....set Patnum=Patnum+$g(Refnum)
	.....set BillOrdrowid=$g(PBRowid)_"||"_$g(OrdSub)
	...set rtnValue=##class(web.DHCBillInterface).IGetOrdItmBilled(oeordexec)
	...set billFlag=$p(rtnValue,"^",2)
	...set FreeChargeFlag=$p($g(^OEORD(oeord,"I",OeordSub,"X",OEChildsub,"BILL")),"^",18)
	...if (FreeChargeFlag="Y") set billFlag="免费"
	...set billFlag=##class(websys.Translation).Get("", billFlag, LangId)
	...set DspRowID="", TColQty=0, TRefQty=0
	...for  set DspRowID=$o(^DHCOEDISQTY(0,"OEORE",OEExcRowID,DspRowID)) quit:(DspRowID="")  do
	....set disp=$g(^DHCOEDISQTY(DspRowID))
	....set dspstatus=$p(disp,"^",7)
	....set DspQty=$p(disp,"^",11)
	....if (dspstatus="C") do
	.....set TColQty=TColQty+DspQty
	....if (dspstatus="R") do
	.....set TRefQty=TRefQty+DspQty
	...set confflag=""
	...if (BillOrdrowid'="") do
	....set confdr=$o(^DHCIPBillPatFeeConfirmi(0,"PBO",BillOrdrowid,""),-1)
	....set consub=""
	....if (confdr'="")  set consub=$o(^DHCIPBillPatFeeConfirmi(0,"PBO",BillOrdrowid,confdr,""),-1)
	....if (consub'="")  set confflag=$p(^DHCIPBillPatFeeConfirm(confdr,"O",consub),"^",3)
	....set confflag=$case(confflag,"R":"撤销审核","C":"审核","D":"拒绝",:"")
	....set confflag=##class(websys.Translation).Get("", confflag, LangId)
	...set BilledNum=BilledNum+Patnum					//计费数量
	...set BilledSum=BilledSum+Patamt
	...do OutputRow11
	.set (DateExecuted,OrderStatus,ctpcp,OeoreLoc,TExStDate,Patamt,BillOrdrowid,billFlag,TColQty,TRefQty,OEExcRowID,confflag,Patnum)=""
	.set DateExecuted=##class(websys.Translation).Get("", "合计", LangId)
	.set BilledSum=$fn(BilledSum,"",2)
	.set BilledNum=BilledNum
	.set Patamt=BilledSum
	.set Patnum=BilledNum
	.set Priority=""
	.set OrderCtpcp=""
	.do OutputRow11
	else  do
	.set OeoriRowId=oeord_"||"_oeordsub
	.set GetOeordStr=..GetOeordStr(OeoriRowId)
	.set Len=$l(GetOeordStr,",")
	.for i=1:1:Len do
	..set OeordRowID=$P(GetOeordStr,",",i)
	..set oeord=+OeordRowID
	..set oeordsub=$p(OeordRowID,"||",2)
	..set OEChildsub=0
	..for  set OEChildsub=$o(^OEORD(oeord,"I",oeordsub,"X",OEChildsub)) quit:(OEChildsub="")  do
	...quit:$g(^OEORD(oeord,"I",oeordsub,"X",OEChildsub))=""
	...set oeordexec=oeord_"||"_oeordsub_"||"_OEChildsub
	...set PBRowid=$o(^DHCPB(0,"OEEXC",oeordexec,""),-1)
	...quit:(PBRowid'=BillNo)
	...set ctpcpdr=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",15)
	...set ctpcp=$s((+ctpcpdr'=0):$p($g(^CTPCP(ctpcpdr,1)),"^",2),1:"")  //执行人
	...set ctpcp=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", ctpcp, LangId)
	...set OrderStatusdr=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",16)
	...set OrderStatus=$s((+OrderStatusdr'=0):$p($g(^OEC("STAT",OrderStatusdr)),"^",2),1:"")
	...set OrderStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc", OrderStatus, LangId)
	...set DateExecuted=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",19)
	...set TimeExecuted=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",20)
	...if (DateExecuted'="") set DateExecuted=##class(websys.Conversions).DateLogicalToHtml(DateExecuted)_" "_##class(websys.Conversions).TimeLogicalToHtml(TimeExecuted,1) ;执行时间
	...set OeoreLocdr=$p($g(^OEORD(oeord,"I",oeordsub,7)),"^",2)	 //开单科室
	...set OeoreLoc=$s((+OeoreLocdr'=0):$p($g(^CTLOC(OeoreLocdr)),"^",2),1:"")
	...set OeoreLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", OeoreLoc, LangId)
	...set TExStDate=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",1) // OEORE_ExStDate 要求执行时间
	...quit:((TExStDate<StDate)&&(StDate'=""))
	...quit:((TExStDate>EndDate)&&(EndDate'=""))
	...set TExStTime=$p(^OEORD(oeord,"I",oeordsub,"X",OEChildsub),"^",2) //OEORE_ExStTime
	...if (TExStDate'="") set TExStDate=##class(websys.Conversions).DateLogicalToHtml(TExStDate)_" "_##class(websys.Conversions).TimeLogicalToHtml(TExStTime,1)
	...set Patamt="0.00", Patnum="0"
	...set BillOrdrowid=""
	...set OEExcRowID=oeord_"||"_oeordsub_"||"_OEChildsub
	...set PBRowid=0  
	...for  set PBRowid=$o(^DHCPB(0,"OEEXC",OEExcRowID,PBRowid)) quit:(PBRowid="")  do
	....set OrdSub=0
	....for  set OrdSub=$o(^DHCPB(0,"OEEXC",OEExcRowID,PBRowid,OrdSub)) quit:(OrdSub="")  do
	.....set pboData=$g(^DHCPB(PBRowid,"O",OrdSub))
	.....quit:(pboData="")
	.....set Patamt=$fn($p(pboData,"^",8),"",2)
	.....set Patnum=$p(pboData,"^",5)
	.....set Refnum=$p(pboData,"^",6)
	.....set Patnum=Patnum+Refnum
	.....set BillOrdrowid=$g(PBRowid)_"||"_$g(OrdSub)
	...set rtnValue=##class(web.DHCBillInterface).IGetOrdItmBilled(oeordexec)
	...set billFlag=$p(rtnValue,"^",2)	
	...set FreeChargeFlag=$p($g(^OEORD(oeord,"I",oeordsub,"X",OEChildsub,"BILL")),"^",18)
	...if (FreeChargeFlag="Y") set billFlag="免费"
	...set billFlag=##class(websys.Translation).Get("", billFlag, LangId)
	...set DspRowID="", TColQty=0, TRefQty=0
	...for  set DspRowID=$o(^DHCOEDISQTY(0,"OEORE",OEExcRowID,DspRowID)) quit:(DspRowID="")  do
	....set disp=$g(^DHCOEDISQTY(DspRowID))
	....set dspstatus=$P(disp,"^",7)
	....set DspQty=$P(disp,"^",11)
	....if (dspstatus="C") do
	.....set TColQty=TColQty+DspQty
	....if (dspstatus="R") do
	.....set TRefQty=TRefQty+DspQty
	...set confflag=""
	...if (BillOrdrowid'="")  do
	....set confdr=$o(^DHCIPBillPatFeeConfirmi(0,"PBO",BillOrdrowid,""),-1)
	....set consub=""
	....if (confdr'="")  set consub=$o(^DHCIPBillPatFeeConfirmi(0,"PBO",BillOrdrowid,confdr,""),-1)
	....if (consub'="")  set confflag=$p(^DHCIPBillPatFeeConfirm(confdr,"O",consub),"^",3)
	....set confflag=$case(confflag,"R":"撤销审核","C":"审核","D":"拒绝",:"")
	....set confflag=##class(websys.Translation).Get("", confflag, LangId)
	...set BilledNum=BilledNum+Patnum					//计费数量
	...set BilledSum=BilledSum+Patamt
	...do OutputRow11
	.set (DateExecuted,OrderStatus,ctpcp,OeoreLoc,TExStDate,Patamt,BillOrdrowid,billFlag,TColQty,TRefQty,OEExcRowID,confflag)=""
	.set DateExecuted=##class(websys.Translation).Get("", "合计", LangId)
	.set BilledSum=$fn(BilledSum,"",2)
	.set BilledNum=BilledNum
	.set Patamt=BilledSum
	.set Patnum=BilledNum
	.set Priority=""
	.set OrderCtpcp=""
	.do OutputRow11
	
	quit $$$OK
OutputRow11
	set Data=$lb(DateExecuted,OrderStatus,ctpcp,OeoreLoc,TExStDate,Patamt,BillOrdrowid,billFlag,TColQty,TRefQty,OEExcRowID,confflag,OrderCtpcp,Priority,Patnum)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetOeordStr(OEORI As %String) As %String
{
	n (OEORI)
	set myArcItmast=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)		//2015-08-20 zhuangna 医嘱项
	set OEORISttDat="", OeordrowidStr=""
	for  set OEORISttDat=$o(^OEORDi(0,"ARCIM",+OEORI,myArcItmast,OEORISttDat)) quit:(OEORISttDat="")  do
	.set OEORIChildsub=""
	.for  set OEORIChildsub=$o(^OEORDi(0,"ARCIM",+OEORI,myArcItmast,OEORISttDat,OEORIChildsub)) quit:(OEORIChildsub="")  do
	..if (OeordrowidStr="") set OeordrowidStr=+OEORI_"||"_OEORIChildsub
	..else  set OeordrowidStr=OeordrowidStr_","_+OEORI_"||"_OEORIChildsub
	if (OeordrowidStr="") set OeordrowidStr=OEORI
	quit OeordrowidStr
}

/// 获取当前账单最新的费用审核状态
ClassMethod GetCodingFlag(Adm, BillNo)
{
	new (Adm, BillNo)
	set ConfirmFlag=""
	set ConRowid=$o(^DHCIPBILLCONFIRM("0","BillNo",BillNo,""),-1)
	if (+ConRowid'=0) {
		set ConfirmFlag=$p(^DHCIPBILLCONFIRM(ConRowid),"^",3)
	}
	quit ConfirmFlag
}

/// 获取当前账单最新的费用审核状态
ClassMethod GetCodingFlagByAdm(Adm)
{
	n (Adm)
	set ConfirmFlag=""
	quit:(Adm="") ConfirmFlag
	set billno=0
	for  set billno=$o(^DHCPB(0,"ADM",Adm,billno))  quit:((billno="")||(ConfirmFlag="Y"))  do
	.set paidflag=$p(^DHCPB(billno),"^",16)
	.quit:(paidflag="P")
	.set ConfirmFlag=..GetCodingFlag(Adm, billno)
	
	quit ConfirmFlag
}

/// Description: 费用审核
/// Input: Flag: Y:审核通过, N:审核拒绝, C:撤销审核
/// Debug: w ##class(web.UDHCJFBillDetailOrder).Confirm("1333","1788","10207","","Y")
ClassMethod Confirm(Adm As %String, BillNo As %String, User As %String, Reason As %String, Flag As %String) As %String
{
	new (Adm, BillNo, User, Reason, Flag)
	set ^TMP("Confirm")=$lb(Adm, BillNo, User, Reason, Flag)
	quit:(BillNo="") -1_"^"_"参数错误"
	set ConfirmFlag=..GetCodingFlag(Adm, BillNo)
	quit:((ConfirmFlag="")&&(Flag="C")) -1_"^"_"该账单未审核，无需撤销"
	if (ConfirmFlag=Flag) {
		quit -1_"^"_"账单已经"_$case(ConfirmFlag,"Y":"审核通过","N":"审核拒绝","C":"撤销审核")_"，不能重复"_$s((Flag="C"):"撤销",1:"审核")
	}
	/*
	set BillNum=##class(web.UDHCJFBaseCommon).JudgeBillNum(Adm)
	quit:(BillNum>1) -1_"^"_"患者有多个未结算账单，不能"_$s((Flag="C"):"撤销",1:"审核")
	*/
	set AdmLastStatus=##class(web.DHCBillInterface).GetAdmLastStatus(Adm)
	quit:(AdmLastStatus="B") -1_"^"_"患者正在进行费用调整，不能"_$s((Flag="C"):"撤销",1:"审核")
	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(BillNo)
	quit:(+prtRowId'=0) -1_"^"_"患者账单已结算，不能"_$s((Flag="C"):"撤销",1:"审核")
	set PaidCAcountFlag=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(BillNo)
	set VisitStatus=$p(^PAADM(Adm),"^",20)
	set qflag=1
	if (VisitStatus="A") {
		if (PaidCAcountFlag="N") set qflag=2
		else  set qflag=0
	}
	if (VisitStatus="D") set qflag=0
	quit:(qflag=1) -1_"^"_"患者未做最终结算，不能"_$s((Flag="C"):"撤销",1:"审核")
	quit:((qflag=2)&&(Flag="Y")) -1_"^"_"该账单未封账，不能"_$s((Flag="C"):"撤销",1:"审核")
	
	//财务结算时增加审核费用标志
	ts
	
	&SQL(
		INSERT DHC_IPBillConfirm (
			Con_Adm, Con_BillNo, Con_Flag, Con_Date, Con_Time,
			Con_User, Con_Reason
		)
		VALUES (
			:Adm, :BillNo, :Flag, CONVERT(DATE, NOW()), CONVERT(TIME, NOW()),
			:User, :Reason
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit 0
}

/// w ##class(web.UDHCJFBillDetailOrder).ConfirmByAdm(Adm, User, "费用调整", "C")
ClassMethod ConfirmByAdm(Adm, User, Reason, Flag)
{
	new (Adm, User, Reason, Flag)
	set rtn=0
	set hospitalDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(Adm)
	set confirmFlag=##class(web.DHCBillCommon).GetIPParamConfig(hospitalDR, "ConfirmPatFee")
	quit:(confirmFlag'="Y") rtn
	
	set pb=0
	while($o(^DHCPB(0,"ADM",Adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",Adm,pb))
		set payedflag=$p(^DHCPB(pb),"^",16)
		set PrtRowid=$o(^DHCINVPRTZY(0,"AR",pb,0))
		continue:(PrtRowid'="")	 //结算的发票不允许进行 费用审核 的操作
		set ConfirmFlag=..GetCodingFlag(Adm, pb)
		continue:(ConfirmFlag="")	 //空说明未做审核，不需要其他操作
		continue:(ConfirmFlag=Flag)	 //说明账单审核状态已经是需要修改状态
		//财务结算时增加审核费用标志
		&SQL(
			INSERT DHC_IPBillConfirm (
				Con_Adm, Con_BillNo, Con_Flag, Con_Date, Con_Time,
				Con_User, Con_Reason
			)
			VALUES (
				:Adm, :pb, :Flag, CONVERT(DATE, NOW()), CONVERT(TIME, NOW()),
				:User, :Reason
			)
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	
	quit rtn
}

}
