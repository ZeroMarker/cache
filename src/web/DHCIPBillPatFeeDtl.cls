/// 名称: web.DHCIPBillPatFeeDtl.cls
/// 描述: 患者费用明细
/// 编写者: ZhYW
/// 编写日期: 2019-05-22
Class web.DHCIPBillPatFeeDtl Extends BILL.COM.Abstract
{

/// 医保分类为空时的代码，方便排序
Parameter XMLBNULLCODE [ Final ] = "A";

/// Creator: ZhYW
/// CreatDate: 2019-05-22
/// Description: 患者费用明细
/// Input: otherQryStr:住院费用大类Id(DHC_TarIC.RowId)!是否按明细拆分标识(1:是,0:否)
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatFeeDtl", "FindBillDtl","32","","","18","!0",1,"")
Query FindBillDtl(billId As %String, stDate As %String, endDate As %String, episodeId As %String = "", otherQryStr As %String = "", dtlColNum As %Integer = 1, langId As %String = "") As websys.Query(ROWSPEC = "TAdm:%String,TCateID:%String,TCateDesc:%String:分类,TDtlFlag:%String,TItmID:%String,TItmCode:%String:项目代码,TItmDesc:%String:项目名称,TUOM:%String:单位,TPrice:%Float:单价,TQty:%String:数量,TAmount:%Float:金额,TZFBL:%String:自付比例,TGRZF:%String:个人自付,TYBLevel:%String:医保分类,TPhcfDesc:%String:剂型,TPhmnfName:%String:产地,TChargeBasis:%String:物价编码,TMedListCode:%String:国家医保编码,TMedListDesc:%String:国家医保名称,TItmID1:%String,TItmCode1:%String:项目代码,TItmDesc1:%String:项目名称,TUOM1:%String:单位,TPrice1:%Float:单价,TQty1:%String:数量,TAmount1:%Float:金额,TZFBL1:%String:自付比例,TGRZF1:%String:个人自付,TYBLevel1:%String:医保分类,TPhcfDesc1:%String:剂型,TPhmnfName1:%String:产地,TChargeBasis1:%String:物价编码,TMedListCode1:%String:国家医保编码,TMedListDesc1:%String:国家医保名称") [ SqlProc ]
{
}

ClassMethod FindBillDtlExecute(ByRef qHandle As %Binary, billId As %String, stDate As %String, endDate As %String, episodeId As %String = "", otherQryStr As %String = "", dtlColNum As %Integer = 1, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((+billId=0)&&(+episodeId=0)) quit $$$OK
	set ^TMP("FindBillDetail")=$lb(billId, stDate, endDate, episodeId, otherQryStr, dtlColNum, langId)

	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set (totSum, totZFBLSum, totGRZFSum)=0
	kill OP2IPAdmAry    //临时存储门诊转住院的就诊

	set job=$j
	kill ^||TMP(job)
		
	if (+billId'=0) {
		do OutPutDtlList(billId)
		kill ^||TMP(job)
		quit $$$OK
	}
	
	//+2022-08-22 ZhYW 根据就诊查询
	set pb=0
	while($o(^DHCPB(0,"ADM",episodeId,pb))) {
		set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
		do OutPutDtlList(pb)
	}
	
	kill ^||TMP(job)
	quit $$$OK

OutPutDtlList(pb)
	set pbData=$g(^DHCPB(pb))
	set motherAdm=$p(pbData,"^",1)
	do ..SetPatDetail(pb, stDate, endDate, otherQryStr, job)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(motherAdm)
	set conf=##class(web.DHCBillCommon).GetTarParaId(hospDR)
	set newBornToMother=$s((+conf'=0):$p(^DHCTarC("CF",conf),"^",5),1:"")
	set isContainBabyFee=($d(^PAADMi("Mother",motherAdm))&&(newBornToMother="Y"))  //是否包含新生儿费用(1:是，0:否)
	if (isContainBabyFee) {
		do GetBillDtlInBaby
	}else {
		do GetBillDtl
	}
	quit
InitDtlCol
	set (itmId, itmCode, itmDesc, uomDesc, price, qty, amt, zfbl, grzf, ybLevel, phcfDesc, phmnfName, chargeBasis, medListCode, medListDesc)=""
	for i=1:1:dtlColNum {
		set itmDtlAry(i)=$$GetDtlData()
	}
	quit
GetDtlData()
	//若需要修改输出列,只需要修改这里
	set dtlData=$lb(itmId,itmCode,itmDesc,uomDesc,price,qty,amt,zfbl,grzf,ybLevel,phcfDesc,phmnfName,chargeBasis,medListCode,medListDesc)
	quit dtlData
GetBillDtl
	set (amtSum, zfblSum, grzfSum)=0
	set adm=""
	while($o(^||TMP(job,adm))'="") {
		set adm=$o(^||TMP(job,adm))
		if (##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByOPAdm(adm)=1) {
			set OP2IPAdmAry(adm)=""
			continue                  //过滤门诊就诊(门急诊转住院)
		}
		do LoopToOutput
	}
	set totSum=$i(totSum, amtSum)
	set totZFBLSum=$i(totZFBLSum, zfblSum)
	set totGRZFSum=$i(totGRZFSum, grzfSum)
	if ($o(OP2IPAdmAry(""))) {
		do InitDtlCol
		set cateDesc=##class(websys.Translation).Get("", "住院合计", langId)
		set amt=$fn(amtSum,"",2)
		set zfbl=$s((+zfblSum'=0):$fn(zfblSum,"N"),1:"")    //医保自付比例
		set grzf=$s((+grzfSum'=0):$fn(grzfSum,"N"),1:"")    //个人自付
		set dtlFlag=0
		set itmDtlAry(1)=$$GetDtlData()
		do OutputDtl
	}
	
	//门诊转住院费用明细
	set (amtSum, zfblSum, grzfSum)=0
	set adm=""
	while($o(^||TMP(job,adm))'="") {
		set adm=$o(^||TMP(job,adm))
		continue:('$d(OP2IPAdmAry(adm)))    //过滤非门诊转住院费用
		do LoopToOutput
	}
	set totSum=$i(totSum, amtSum)
	set totZFBLSum=$i(totZFBLSum, zfblSum)
	set totGRZFSum=$i(totGRZFSum, grzfSum)
	if ($o(OP2IPAdmAry(""))) {
		do InitDtlCol
		set cateDesc=##class(websys.Translation).Get("", "门诊转住院合计", langId)
		set amt=$fn(amtSum,"",2)
		set zfbl=$s((+zfblSum'=0):$fn(zfblSum,"N"),1:"")        //医保自付比例
		set grzf=$s((+grzfSum'=0):$fn(grzfSum,"N"),1:"")        //个人自付
		set dtlFlag=0
		set itmDtlAry(1)=$$GetDtlData()
		do OutputDtl
	}
	
	do InitDtlCol
	set cateDesc=##class(websys.Translation).Get("", "合计", langId)
	set amt=$fn(totSum,"",2)
	set zfbl=$s((+totZFBLSum'=0):$fn(totZFBLSum,"N"),1:"")   //医保自付比例
	set grzf=$s((+totGRZFSum'=0):$fn(totGRZFSum,"N"),1:"")   //个人自付
	set dtlFlag=0
	set itmDtlAry(1)=$$GetDtlData()
	do OutputDtl
	
	quit

GetBillDtlInBaby
	//母亲费用
	set (amtSum, zfblSum, grzfSum)=0
	
	set adm=motherAdm
	do LoopToOutput
	
	set totSum=$i(totSum, amtSum)
	set totZFBLSum=$i(totZFBLSum, zfblSum)
	set totGRZFSum=$i(totGRZFSum, grzfSum)
	do InitDtlCol
	set cateDesc=##class(websys.Translation).Get("", "母亲合计", langId)
	set amt=$fn(amtSum,"",2)
	set zfbl=$s((+zfblSum'=0):$fn(zfblSum,"N"),1:"")   //医保自付比例
	set grzf=$s((+grzfSum'=0):$fn(grzfSum,"N"),1:"")   //个人自付
	set dtlFlag=0
	set itmDtlAry(1)=$$GetDtlData()
	do OutputDtl
	
	//婴儿费用
	set (amtSum, zfblSum, grzfSum)=0
	set adm=""
	while($o(^||TMP(job,adm))'="") {
		set adm=$o(^||TMP(job,adm))
		if (##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByOPAdm(adm)=1) {
			set OP2IPAdmAry(adm)=""
			continue      //过滤门诊就诊(门急诊转住院)
		}
		continue:(adm=motherAdm)
		continue:('$d(^PAADMi("Mother",motherAdm,adm)))
		do LoopToOutput
	}
	set totSum=$i(totSum, amtSum)
	set totZFBLSum=$i(totZFBLSum, zfblSum)
	set totGRZFSum=$i(totGRZFSum, grzfSum)
	do InitDtlCol
	set cateDesc=##class(websys.Translation).Get("", "婴儿合计", langId)
	set amt=$fn(amtSum,"",2)
	set zfbl=$s((+zfblSum'=0):$fn(zfblSum,"N"),1:"")   //医保自付比例
	set grzf=$s((+grzfSum'=0):$fn(grzfSum,"N"),1:"")   //个人自付
	set dtlFlag=0
	set itmDtlAry(1)=$$GetDtlData()
	do OutputDtl
	
	//门诊转住院
	set (amtSum, zfblSum, grzfSum)=0
	set adm=""
	while($o(^||TMP(job,adm))'="") {
		set adm=$o(^||TMP(job,adm))
		continue:('$d(OP2IPAdmAry(adm)))    //过滤非门诊转住院费用
		continue:(adm=motherAdm)            //过滤母亲费用
		continue:($d(^PAADMi("Mother",motherAdm,adm)))   //过滤婴儿费用
		do LoopToOutput
	}
	set totSum=$i(totSum, amtSum)
	set totZFBLSum=$i(totZFBLSum, zfblSum)
	set totGRZFSum=$i(totGRZFSum, grzfSum)
	if ($o(OP2IPAdmAry(""))) {
		do InitDtlCol
		set cateDesc=##class(websys.Translation).Get("", "门诊转住院合计", langId)
		set amt=$fn(amtSum,"",2)
		set zfbl=$s((+zfblSum'=0):$fn(zfblSum,"N"),1:"")        //医保自付比例
		set grzf=$s((+grzfSum'=0):$fn(grzfSum,"N"),1:"")        //个人自付
		set dtlFlag=0
		set itmDtlAry(1)=$$GetDtlData()
		do OutputDtl
	}
	
	do InitDtlCol
	set cateDesc=##class(websys.Translation).Get("", "合计", langId)
	set amt=$fn(totSum,"",2)
	set zfbl=$s((+totZFBLSum'=0):$fn(totZFBLSum,"N"),1:"")   //医保自付比例
	set grzf=$s((+totGRZFSum'=0):$fn(totGRZFSum,"N"),1:"")   //个人自付
	set dtlFlag=0
	set itmDtlAry(1)=$$GetDtlData()
	do OutputDtl
	
	quit
	
LoopToOutput
	set cat=""
	while($o(^||TMP(job,adm,cat))'="") {
		set cat=$o(^||TMP(job,adm,cat))
		set seqIdx=""
		while($o(^||TMP(job,adm,cat,seqIdx))'="") {
			set seqIdx=$o(^||TMP(job,adm,cat,seqIdx))
			set cateId=""
			while($o(^||TMP(job,adm,cat,seqIdx,cateId))'="") {      //分类Id
				set cateId=$o(^||TMP(job,adm,cat,seqIdx,cateId))
				set (cateSum, cateZFBLSum, cateGRZFSum, cateDtlNum)=0
				kill cateDtlAry
				set itmId=""
				while($o(^||TMP(job,adm,cat,seqIdx,cateId,itmId))'="") {         //项目Id
					set itmId=$o(^||TMP(job,adm,cat,seqIdx,cateId,itmId))
					if (cat="IPCat") {
						set cateDesc=$p(^DHCTarC("TIC",cateId),"^",2)
						set cateDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", cateDesc, langId)
						set itmCode=$p(^DHCTARI(itmId),"^",1)
						set itmDesc=$p(^DHCTARI(itmId),"^",2)
						set itmDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", itmDesc, langId)
						set chargeBasis=$p(^DHCTARI(itmId),"^",50)    //物价编码
					}
					if (cat="ItemCat") {
						set cateDesc=$p(^ARC("IC",cateId),"^",2)
						set cateDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc", cateDesc, langId)
						set itmCode=$p(^ARCIM(+itmId,$p(itmId,"||",2),1),"^",1)
						set itmDesc=$p(^ARCIM(+itmId,$p(itmId,"||",2),1),"^",2)
						set itmDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", itmDesc, langId)
						set chargeBasis=""
					}
					set tmpNode=""
					while($o(^||TMP(job,adm,cat,seqIdx,cateId,itmId,tmpNode))'="") {
						set tmpNode=$o(^||TMP(job,adm,cat,seqIdx,cateId,itmId,tmpNode))
						set xmlb=""
						while($o(^||TMP(job,adm,cat,seqIdx,cateId,itmId,tmpNode,xmlb))'="") {
							set xmlb=$o(^||TMP(job,adm,cat,seqIdx,cateId,itmId,tmpNode,xmlb))
							set info=$g(^||TMP(job,adm,cat,seqIdx,cateId,itmId,tmpNode,xmlb))
							set price=$lg(info,1)
							set price=$fn(price,"",4)
							set qty=$lg(info,2)
							set qty=$fn(qty,"N")
							continue:(+qty=0)
							set amt=$lg(info,3)
							set amt=$fn(amt,"",2)
							set cateSum=$i(cateSum, amt)
							set amtSum=$i(amtSum, amt)
							set arcim=$lg(info,4)
							set drugComDesc=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(arcim)
							if (drugComDesc'="") set itmDesc=drugComDesc
							set drugSpec=##class(web.UDHCJFCOMMON).GetDrugSpec(arcim)
							if (drugSpec'="") set itmDesc=itmDesc_"("_drugSpec_")"
							set uomDesc=$lg(info,5)
							set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
							set zfbl=$lg(info,6)
							set zfbl=$s((+zfbl'=0):$fn(zfbl,"N"),1:"")
							set grzf=$lg(info,7)
							set grzf=$s((+grzf'=0):$fn(grzf,"N"),1:"")
							set cateZFBLSum=$i(cateZFBLSum, zfbl)
							set cateGRZFSum=$i(cateGRZFSum, grzf)
							set zfblSum=$i(zfblSum, zfbl)
							set grzfSum=$i(grzfSum, grzf)
							set phcfDesc=$lg(info,8)
							set phmnfName=$lg(info,9)
							set medListCode=$lg(info,10)     //国家医保编码
							set medListDesc=$lg(info,11)    //国家医保名称
							set ybLevel=$s((xmlb=..#XMLBNULLCODE):"",1:xmlb)
							set dtlFlag=1
							set cateDtlNum=$i(cateDtlNum)
							set cateDtlAry(cateDtlNum)=$$GetDtlData()
						}
					}
				}
				set maxCateIdx=$o(cateDtlAry(""),-1)
				set idx=0
				while($o(cateDtlAry(idx))) {
					set idx=$o(cateDtlAry(idx))
					set info=$g(cateDtlAry(idx))
					set mod=idx#dtlColNum
					set itmDtlAry($case(mod, 0:dtlColNum, :mod))=info
					if ((mod=0)||(idx=maxCateIdx)) {
						do OutputDtl
						do InitDtlCol
					}
				}
				//小计
				continue:(cateDtlNum=0)
				do InitDtlCol
				set cateDesc=##class(websys.Translation).Get("", "小计", langId)
				set amt=$fn(cateSum,"",2)
				set zfbl=$s((+cateZFBLSum'=0):$fn(cateZFBLSum,"N"),1:"")
				set grzf=$s((+cateGRZFSum'=0):$fn(cateGRZFSum,"N"),1:"")
				set dtlFlag=0
				set itmDtlAry(1)=$$GetDtlData()
				do OutputDtl
			}
		}
	}
	quit
OutputDtl
	set Data=$lb(adm,cateId,cateDesc,dtlFlag)
	for i=1:1:dtlColNum {
		set Data=Data_$g(itmDtlAry(i))
	}
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

ClassMethod SetPatDetail(pb As %String, stDate As %String, endDate As %String, otherQryStr As %String, job As %String) As %String
{
	set adm=$p(^DHCPB(pb),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	do ..BuildCateSeqAry(hospDR, .seqAry)

	set tarCateId=$p(otherQryStr,"!",1)
	set isSplit=$p(otherQryStr,"!",2)   //+2022-08-23 ZhYW 是否按明细拆分
	
  	set pbo=0
  	while($o(^DHCPB(pb,"O",pbo))) {
	  	set pbo=$o(^DHCPB(pb,"O",pbo))
		set pboData=$g(^DHCPB(pb,"O",pbo))
		continue:(pboData="")
		set pboRowId=pb_"||"_pbo
		set arcim=$p(pboData,"^",3)
		continue:(arcim="")
	 	//如果按住院分类或按明细拆分查询时，不按医嘱查，只能按收费项目查
	 	if ((+tarCateId=0)&&(+isSplit=0)) {
		 	set itemCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		 	set itemCatCfg=..IsShowArcimCat(itemCatDR, hospDR)
		 	if (itemCatCfg=1) {
				continue:('..IsShowPatBillOrder(pboRowId, stDate, endDate))   //对应的账单明细记录都不在查询日期内时不显示
		  		//查询医嘱项
		  		do ..GetOrder(pb, pbo, job)
		  		continue
			}
		}
		//查询收费项
	 	do ..GetDetail(pb, pbo, stDate, endDate, otherQryStr, job, .seqAry)
	}
  
	quit 0
}

ClassMethod GetOrder(pb As %String, pbo As %String, job As %String) As %String
{
	set pbData=$g(^DHCPB(pb))
	set pboData=$g(^DHCPB(pb,"O",pbo))
	set oeitm=$p(pboData,"^",4)
	set adm=+$p(^OEORD(+oeitm),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set arcim=$p(pboData,"^",3)
	set itemCatDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)   //ARCIM_ItemCat_DR(医嘱子分类)
	set seqIdx=1      //2022-09-13 ZhYW 排序序号，显示医嘱项时，先不做具体排序，写死为1
  	set phInfo=..GetDrugInfo(arcim)
  	set phcfDesc=$p(phInfo,"^",1)
  	set phmnfName=$p(phInfo,"^",2)
  	set billQty=$p(pboData,"^",5)
  	set refQty=$p(pboData,"^",6)
	set price=$p(pboData,"^",7)
	set price=$fn(price,"",4)
  	set qty=billQty+refQty
  	set amt=$p(pboData,"^",8)
	set uomDesc=##class(web.DHCBillCommon).GetBaseUom(arcim, oeitm)
	set insTypeDR=$p(pbData,"^",4)
	set ordSttDate=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",9)   //OEORI_SttDat
	if (+ordSttDate'=0) {
		set ordSttDate=$zd(ordSttDate,3)
	}
	set insuExpStr=ordSttDate
  	set insuStr=##class(web.DHCINSUPort).ArcimLinkInsu(arcim, insTypeDR, hospDR, insuExpStr)
  	set xmlb=$p(insuStr,"^",1)
  	if (+xmlb<0) set xmlb=""
  	if (xmlb="") set xmlb=..#XMLBNULLCODE
  	set medListCode=$p(insuStr,"^",12)    //国家医保编码
	set medListDesc=$p(insuStr,"^",13)    //国家医保名称
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),1)=price
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),2)=$lg($g(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb)),2)+qty
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),3)=$lg($g(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb)),3)+amt
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),4)=arcim
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),5)=uomDesc
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),6)=""       //医保自付比例
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),7)=""       //个人自付
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),8)=phcfDesc
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),9)=phmnfName
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),10)=medListCode
	set $li(^||TMP(job,adm,"ItemCat",seqIdx,itemCatDR,arcim,price,xmlb),11)=medListDesc
  
  	quit 0
}

ClassMethod GetDetail(pb As %String, pbo As %String, stDate As %String, endDate As %String, otherQryStr As %String, job As %String, ByRef seqAry) As %String
{
	set tarCateId=$p(otherQryStr,"!",1)
	set isSplit=$p(otherQryStr,"!",2)   //+2022-08-23 ZhYW 是否按明细拆分
	
	set pbData=$g(^DHCPB(pb))
	set insTypeDR=$p(pbData,"^",4)
	set nationalCode=+$p(^PAC("ADMREA",insTypeDR),"^",5)
	
	set pboData=$g(^DHCPB(pb,"O",pbo))
	set oeitm=$p(pboData,"^",4)
	set adm=+$p(^OEORD(+oeitm),"^",1)
	set arcim=$p(pboData,"^",3)
	set phInfo=..GetDrugInfo(arcim)
	set phcfDesc=$p(phInfo,"^",1)
 	set phmnfName=$p(phInfo,"^",2)
  	
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)

	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		continue:(pbdData="")
		set pbdRowId=pb_"||"_pbo_"||"_pbd
		set billDate=$p(pbdData,"^",11)
		set billTime=$p(pbdData,"^",12)
		continue:((stDate'="")&&(billDate<stDate))
	 	continue:((endDate'="")&&(billDate>endDate))
		set tarItmDR=$p($g(pbdData),"^",3)    //PBD_TARI_DR,指向DHC_TarItem
		continue:(+tarItmDR=0)||('$d(^DHCTARI(tarItmDR)))
	  	set tariUom=$p($g(^DHCTARI(tarItmDR)),"^",3)
	  	set uomDesc=$s((+tariUom'=0):$p($g(^CT("UOM",tariUom)),"^",2),1:"")
	  	set price=$p(pbdData,"^",4)           //PBD_UnitPrice
		set price=$fn(price,"",4)
	  	set qty=$p(pbdData,"^",5)             //PBD_BillQty
	  	set amt=$p(pbdData,"^",7)
	  	continue:(+amt=0)
	  	set tarcId=$p($g(^DHCTARI(tarItmDR)),"^",14)         //TARI_InpatCate->DHC_TarInpatCate
	  	set tarCatDR=$p($g(^DHCTarC("IC",tarcId)),"^",3)     //TARIC_TARTIC_DR(住院收费大类)
	  	continue:((tarCateId'="")&&(tarCateId'=tarCatDR))
	  	set seqIdx=$g(seqAry(tarCatDR))     //2022-09-13 ZhYW 排序序号
	  	set zfbl="", grzf=0, medListCode="", medListDesc=""
	  	if (+nationalCode>0) {
			set ybInfo=##class(web.DHCINSUPort).PBDLinkInsu(pbdRowId)
			set zfbl=$p(ybInfo,"^",1)      //自付比例
			set grzf=$p(ybInfo,"^",2)      //个人自付
		}
	  	set insuStr=##class(web.DHCINSUPort).TarItmLinkInsu(tarItmDR, insTypeDR, oeitm, adm, price, hospDR)
	  	set xmlb=$p(insuStr,"^",1)
	  	if (xmlb="") set xmlb=..#XMLBNULLCODE
	  	set medListCode=$p(insuStr,"^",12)    //国家医保编码
		set medListDesc=$p(insuStr,"^",13)    //国家医保名称
		if (+isSplit=0) {
			//合并
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),1)=price
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),2)=$lg($g(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb)),2)+qty
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),3)=$lg($g(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb)),3)+amt
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),4)=arcim
		 	set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),5)=uomDesc
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),6)=zfbl
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),7)=$lg($g(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb)),7)+grzf
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),8)=phcfDesc
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),9)=phmnfName
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),10)=medListCode
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,price,xmlb),11)=medListDesc
		}else {
			//不合并
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),1)=price
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),2)=qty
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),3)=amt
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),4)=arcim
		 	set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),5)=uomDesc
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),6)=zfbl
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),7)=grzf
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),8)=phcfDesc
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),9)=phmnfName
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),10)=medListCode
			set $li(^||TMP(job,adm,"IPCat",seqIdx,tarCatDR,tarItmDR,pbdRowId,xmlb),11)=medListDesc
		}
	}
  
  	quit 0
}

/// Creator: wangjian
/// CreatDate: 2011-09-06
/// Description: 获取剂型和产地
/// Input: arcim: ARC_ItmMast.RowId
/// Return: 
/// Debug: 剂型、产地
ClassMethod GetDrugInfo(arcim As %String) As %String
{
 	set PhcdfDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",12)
 	quit:(PhcdfDR="") "^"
 	set DrgMast=+PhcdfDR
 	set PHCDFSub=$p(PhcdfDR,"||",2)
 	set PhcfDR=$p($g(^PHCD(DrgMast,"DF",PHCDFSub,1)),"^",1)          //指向表phc_form
 	set phcfDesc=$s((+PhcfDR'=0):$p($g(^PHCF(PhcfDR)),"^",2),1:"")
 	set PhmnfDR=$p($g(^PHCD(DrgMast,2)),"^",4)                       //phc_drgmast
	set phmnfName=$s((+PhmnfDR'=0):$p(^PHMNF(PhmnfDR),"^",2),1:"")   //产地
	
 	quit phcfDesc_"^"_phmnfName
}

/// Creator: ZhYW
/// CreatDate: 2019-05-22
/// Description: 患者费用明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatFeeDtl", "QryBillDtlPrtTitle", "281500")
Query QryBillDtlPrtTitle(billId As %String, episodeId As %String = "") As websys.Query(ROWSPEC = "PatName:%String,PatientNo:%String,MedicareNo:%String,AdmReaDesc:%String,Dept:%String,BedInfo:%String,AdmDate:%String,DisDate:%String,AdmDays:%String,BillFromDateTo:%String,DepositSum:%String,TotalAmt:%String,ICDDesc:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBillDtlPrtTitleExecute(ByRef qHandle As %Binary, billId As %String, episodeId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindBillDtlPrtTitle")=$lb(billId, episodeId)
	if ((+billId=0)&&(+episodeId=0))  quit $$$OK
	
	set adm=$s((+billId'=0):$p($g(^DHCPB(billId)),"^",1),1:episodeId)
	if (+adm=0)  quit $$$OK
	
	set inOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
	set admDate=$p(inOutDateInfo,"^",1)
	set admDays=$p(inOutDateInfo,"^",3)
	set disDate=$p(inOutDateInfo,"^",4)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set disDate=##class(websys.Conversions).DateLogicalToHtml(disDate)
	
	set deptDR=$p(^PAADM(adm),"^",4)
	set dept=$s((+deptDR'=0):$p($g(^CTLOC(deptDR)),"^",2),1:"")   //科室
	
	set wardDR=$p(^PAADM(adm),"^",70)
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")   //病区
		
	set roomDR=$p(^PAADM(adm),"^",69)
	set room=$s((+roomDR'=0):$p($g(^PAROOM(roomDR)),"^",2),1:"")
	set bedCode=##class(web.DHCBillCommon).GetPatBedCode(adm)
	set bedInfo=ward_"/"_room_"/"_bedCode
	
	set admReaDR=$p(^PAADM(adm,1),"^",7)
	set admReaDesc=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2),1:"")

	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")	//病案号
	
	set papmi=$p(^PAADM(adm),"^",1)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)     //姓名
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)     //登记号
	
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptDR) //2023-04-19 LUANZH 取医院名称
	set hospDesc=$s((hospDR'=""):$p(^CT("HOSP",hospDR),"^",2),1:"")

	if (+billId'=0) {
		set totalSum=$p($g(^DHCPB(billId)),"^",8)
		set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(billId)
		if (+prtRowId'=0) {
		    //账单已结算
		    set depositSum=##class(web.UDHCJFBaseCommon).GetPaidDeposit(billId)
		}else {
			//账单未结算
			set depositSum=##class(web.UDHCJFBaseCommon).getdeposit(adm)
		}
		//获取账单的开始日期、结束日期
		set admInDays=##class(web.UDHCJFBaseCommon).GetPatAdmInDays(adm, billId)
	    set billStDate=$p(admInDays,"^",1)	  //账单开始日期
	    set billEndDate=$p(admInDays,"^",2)	  //账单结束日期
	}else {
		set patFeeInfo=##class(BILL.IP.COM.Method).GetTotalFeeInfo(adm)
		set totalSum=$p(patFeeInfo,"^",1)
		set depositSum=##class(web.UDHCJFBaseCommon).getdeposit(adm)
		//没有账单，根据就诊查询时，将入院日期、出院日期作为开始日期、结束日期
		set billStDate=admDate
		set billEndDate=disDate
	}
	set depositSum=$fn(depositSum,"",2)
	set totalSum=$fn(totalSum,"",2)
	set billFromDateTo=billStDate_" 至 "_billEndDate

	set diagDesc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(adm)
	do OutputPrtTitle
	
	quit $$$OK
OutputPrtTitle
 	set Data=$lb(patName,regNo,mrNo,admReaDesc,dept,bedInfo,admDate,disDate,admDays,billFromDateTo,depositSum,totalSum,diagDesc,hospDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2021-07-27
/// Description: 费用清单
/// Input: 一栏显示
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatFeeDtl", "QryPrintDtl1","","2022-06-27","2022-08-22","8","!1")
Query QryPrintDtl1(billId As %String, stDate As %String, endDate As %String, episodeId As %String = "", otherQryStr As %String = "") As websys.Query(ROWSPEC = "Adm:%String,CateID:%String,CateDesc:%String,DtlFlag:%String,ItmID:%String,ItmCode:%String,ItmDesc:%String,UOM:%String,Price:%Float,Qty:%String,Amount:%Float,ZFBL:%String,GRZF:%String,YBLevel:%String,PhcfDesc:%String,PhmnfName:%String,ChargeBasis:%String,MedListCode:%String,MedListDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPrintDtl1Execute(ByRef qHandle As %Binary, billId As %String, stDate As %String, endDate As %String, episodeId As %String = "", otherQryStr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("QryPrintDtl1")=$lb(billId, stDate, endDate, episodeId, otherQryStr)
	if ((+billId=0)&&(+episodeId=0)) quit $$$OK

	set rset=##class(%ResultSet).%New("web.DHCIPBillPatFeeDtl:FindBillDtl")
	do rset.Execute(billId, stDate, endDate, episodeId, otherQryStr, 1)
	while (rset.Next()) {
		set adm=rset.Get("TAdm")
		set cateId=rset.Get("TCateID")
		set cateDesc=rset.Get("TCateDesc")
		set dtlFlag=rset.Get("TDtlFlag")
		
		set itmId=rset.Get("TItmID")
		set itmCode=rset.Get("TItmCode")
		set itmDesc=rset.Get("TItmDesc")
		set uomDesc=rset.Get("TUOM")
		set price=rset.Get("TPrice")
		set qty=rset.Get("TQty")
		set amt=rset.Get("TAmount")
		set zfbl=rset.Get("TZFBL")
		set grzf=rset.Get("TGRZF")
		set ybLevel=rset.Get("TYBLevel")
		set phcfDesc=rset.Get("TPhcfDesc")
		set phmnfName=rset.Get("TPhmnfName")
		set chargeBasis=rset.Get("TChargeBasis")
		set medListCode=rset.Get("TMedListCode")
		set medListDesc=rset.Get("TMedListDesc")
		set Data=$lb(adm,cateId,cateDesc,dtlFlag,itmId,itmCode,itmDesc,uomDesc,price,qty,amt,zfbl,grzf,ybLevel,phcfDesc,phmnfName,chargeBasis,medListCode,medListDesc)
	 	set ^CacheTemp(repid,ind)=Data
	 	set ind=$i(ind)
	}
	
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2021-07-27
/// Description: 费用清单
/// Input: 分两栏显示
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatFeeDtl", "QryPrintDtl2","21","2887","2021-07-25","00:00:00","2021-07-25","23:59:59","!!!!1","12177","2")
Query QryPrintDtl2(billId As %String, stDate As %String, endDate As %String, episodeId As %String = "", otherQryStr As %String = "") As websys.Query(ROWSPEC = "Adm:%String,CateID:%String,CateDesc:%String,DtlFlag:%String,ItmID:%String,ItmCode:%String,ItmDesc:%String,UOM:%String,Price:%Float,Qty:%String,Amount:%Float,ZFBL:%String,GRZF:%String,YBLevel:%String,PhcfDesc:%String,PhmnfName:%String,ChargeBasis:%String,MedListCode:%String,MedListDesc:%String,ItmID1:%String,ItmCode1:%String,ItmDesc1:%String,UOM1:%String,Price1:%Float,Qty1:%String,Amount1:%Float,ZFBL1:%String,GRZF1:%String,YBLevel1:%String,PhcfDesc1:%String,PhmnfName1:%String,ChargeBasis1:%String,MedListCode1:%String,MedListDesc1:%String") [ SqlProc ]
{
}

ClassMethod QryPrintDtl2Execute(ByRef qHandle As %Binary, billId As %String, stDate As %String, endDate As %String, episodeId As %String = "", otherQryStr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("QryPrintDtl2")=$lb(billId, stDate, endDate, episodeId, otherQryStr)
	if ((+billId=0)&&(+episodeId=0)) quit $$$OK
	
	set rset=##class(%ResultSet).%New("web.DHCIPBillPatFeeDtl:FindBillDtl")
	do rset.Execute(billId, stDate, endDate, episodeId, otherQryStr, 2)
	while (rset.Next()) {
		set adm=rset.Get("TAdm")
		set cateId=rset.Get("TCateID")
		set cateDesc=rset.Get("TCateDesc")
		set dtlFlag=rset.Get("TDtlFlag")
		
		set itmId=rset.Get("TItmID")
		set itmCode=rset.Get("TItmCode")
		set itmDesc=rset.Get("TItmDesc")
		set uomDesc=rset.Get("TUOM")
		set price=rset.Get("TPrice")
		set qty=rset.Get("TQty")
		set amt=rset.Get("TAmount")
		set zfbl=rset.Get("TZFBL")
		set grzf=rset.Get("TGRZF")
		set ybLevel=rset.Get("TYBLevel")
		set phcfDesc=rset.Get("TPhcfDesc")
		set phmnfName=rset.Get("TPhmnfName")
		set chargeBasis=rset.Get("TChargeBasis")
		set medListCode=rset.Get("TMedListCode")
		set medListDesc=rset.Get("TMedListDesc")
		
		set itmId1=rset.Get("TItmID1")
		set itmCode1=rset.Get("TItmCode1")
		set itmDesc1=rset.Get("TItmDesc1")
		set uomDesc1=rset.Get("TUOM1")
		set price1=rset.Get("TPrice1")
		set qty1=rset.Get("TQty1")
		set amt1=rset.Get("TAmount1")
		set zfbl1=rset.Get("TZFBL1")
		set grzf1=rset.Get("TGRZF1")
		set ybLevel1=rset.Get("TYBLevel1")
		set phcfDesc1=rset.Get("TPhcfDesc1")
		set phmnfName1=rset.Get("TPhmnfName1")
		set chargeBasis1=rset.Get("TChargeBasis1")
		set medListCode1=rset.Get("TMedListCode1")
		set medListDesc1=rset.Get("TMedListDesc1")

		set Data=$lb(adm,cateId,cateDesc,dtlFlag,itmId,itmCode,itmDesc,uomDesc,price,qty,amt,zfbl,grzf,ybLevel,phcfDesc,phmnfName,chargeBasis,medListCode,medListDesc,itmId1,itmCode1,itmDesc1,uomDesc1,price1,qty1,amt1,zfbl1,grzf1,ybLevel1,phcfDesc1,phmnfName1,chargeBasis1,medListCode1,medListDesc1)
	 	set ^CacheTemp(repid,ind)=Data
	 	set ind=$i(ind)
	}
	
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2022-04-02
/// Description: 根据医嘱子分类判断是否显示医嘱项目
/// Input: arcGrpId:ARC_ItemCat.RowId, hospId:CT_Hospital.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCIPBillPatFeeDtl).IsShowArcimCat(2)
ClassMethod IsShowArcimCat(arcGrpId As %String, hospId As %String) As %String
{
	set rtn=0
	quit:((+arcGrpId=0)||(+hospId=0)) rtn
	if ($d(%IsShowARCIM(hospId,arcGrpId))) {
		quit %IsShowARCIM(hospId,arcGrpId)
	}
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_IP_PrtArcimCat", hospId)
	set cfgId=0
	while($o(^DHCJFORDITEMCATSET(0,"ItemCat",arcGrpId,cfgId))) {
		set cfgId=$o(^DHCJFORDITEMCATSET(0,"ItemCat",arcGrpId,cfgId))
		set data=$g(^DHCJFORDITEMCATSET(cfgId))
		continue:(data="")
		set cfgHospDR=$p(data,"^",3)
		continue:(cfgHospDR'=defHospId)
		set rtn=1
		quit
	}
	set %IsShowARCIM(hospId,arcGrpId)=rtn
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-04-02
/// Description: 判断账单医嘱表记录能否显示(其对应的账单明细记录都不在查询日期内时不显示)
/// Input: pboRowId:DHC_PatBillOrder.RowId, stDate:开始日期, endDate:结束日期
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCIPBillPatFeeDtl).IsShowPatBillOrder(2)
ClassMethod IsShowPatBillOrder(pboRowId As %String, stDate As %String, endDate As %String) As %String
{
	set rtn=0
	quit:(pboRowId="") rtn
	
	set pb=+pboRowId
	set pbo=$p(pboRowId,"||",2)
	quit:(pbo="") rtn
	
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
		continue:(pbdData="")
		set billDate=$p(pbdData,"^",11)
		set billTime=$p(pbdData,"^",12)
		continue:((stDate'="")&&(billDate<stDate))
	 	continue:((endDate'="")&&(billDate>endDate))
	 	set rtn=1
	 	quit
	}
  	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-09-13
/// Description: 组织费用分类序号数组
/// Table: DHC_TarIC
/// Input: hospId:CT_Hospital.RowId
/// Return: 
/// Debug: do ##class(web.DHCIPBillPatFeeDtl).BuildCateSeqAry(2, "")
ClassMethod BuildCateSeqAry(hospId As %String, ByRef seqAry) As %String
{
	set seqIdx=0
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute("IPCHRG.PatFeeDetlList.FYFLXSSX", "", "", hospId)
	while (rset.Next()) {
		set id=rset.Get("ID")
		set seqAry(id)=$i(seqIdx)
	}
	set maxSeqIdx=$o(seqAry(""),-1)   //已排序最大序号
	
	set id=0
	while($o(^DHCTarC("TIC",id))) {
		set id=$o(^DHCTarC("TIC",id))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", id, hospId)
		continue:(showFlag="N")
		set seqIdx=$g(seqAry(id))
		if (seqIdx="") set seqIdx=$i(maxSeqIdx)
		set seqAry(id)=seqIdx
	}
	quit ""
}

}
