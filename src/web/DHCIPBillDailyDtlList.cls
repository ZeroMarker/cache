/// 名称: web.DHCIPBillDailyDtlList.cls
/// 描述: 病区日清明细
/// 编写者: ZhYW
/// 编写日期: 2018-04-02
Class web.DHCIPBillDailyDtlList Extends BILL.COM.Abstract
{

/// 每行显示的分类数
Parameter CATECOLNUM [ Final ] = 5;

/// 页面显示间距
Parameter SPACCODE [ Final ] = "&emsp;";

/// 医保分类为空时的代码，方便排序
Parameter XMLBNULLCODE [ Final ] = "A";

/// Creator: ZhYW
/// CreatDate: 2018-04-02
/// Description: 查询病区内患者
/// Input:  
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "FindAdmList", "30","2","","")
Query FindAdmList(wardId As %String, hospId As %String, patientNo As %String = "", episodeId As %String = "", langId As %String = "") As websys.Query(ROWSPEC = "adm:%String,papmi:%String,patientNo:%String,patName:%String,bedName:%String,admDept:%String,admDate:%String,admTime:%String,disDate:%String,disTime:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, wardId As %String, hospId As %String, patientNo As %String = "", episodeId As %String = "", langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindAdmList")=$lb(wardId, hospId, patientNo, episodeId, langId)
	if (wardId="") quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set patientId=""
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set patientId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patientNo),""))
	}
	
	kill admList
	
	do ..BuildSeqAry(wardId, .seqAry)

	if (+episodeId'=0) {
		set adm=episodeId
		set bedDR=##class(BILL.IP.COM.Method).GetTransBedId(adm)
		if (bedDR'="") {
			set seqIdx=$g(seqAry(bedDR))
			set admList(seqIdx,adm)=""
		}
	}elseif (+patientId'=0) {
		set papmi=patientId
		set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
		set patName=$p(^PAPER(papmi,"ALL"),"^",1)
		set adm=""
		while($o(^PAPERdr(papmi,"ADM","I",adm),-1)) {
			set adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1)
			set admData=$g(^PAADM(adm))
			continue:(admData="")
			set admDeptDR=$p(admData,"^",4)
			set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
			continue:(admHospDR'=hospId)
			set wardDR=$p(admData,"^",70)
			continue:(wardId'=wardDR)
			set bedDR=##class(BILL.IP.COM.Method).GetTransBedId(adm)
			continue:(bedDR="")
			set seqIdx=$g(seqAry(bedDR))
			set admList(seqIdx,adm)=""
		}
	}else {
		set room=0
		while($o(^PAADMi("CurrWard",wardId,room))) {
			set room=$o(^PAADMi("CurrWard",wardId,room))
			set adm=0
			while($o(^PAADMi("CurrWard",wardId,room,adm))) {
				set adm=$o(^PAADMi("CurrWard",wardId,room,adm))
				set admData=$g(^PAADM(adm))
				continue:(admData="")
				set bedDR=..GetToSortBedId(adm)
				continue:(bedDR="")
				set seqIdx=$g(seqAry(bedDR))
				set admList(seqIdx,adm)=""
			}
		}
	}
	
	//输出
	set idx=0
	while($o(admList(idx))) {
		set idx=$o(admList(idx))
		set adm=0
		while($o(admList(idx,adm))) {
			set adm=$o(admList(idx,adm))
			set bedName=##class(web.DHCBillCommon).GetPatBedCode(adm)
			set papmi=$p(^PAADM(adm),"^",1)
			set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
			set admDeptDR=$p($g(^PAADM(adm)),"^",4)
			set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2),1:"")
			set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
			set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
			set admDate=$p(admInOutDateInfo,"^",1)
			set admTime=$p(admInOutDateInfo,"^",2)
			set disDate=$p(admInOutDateInfo,"^",4)
			set disTime=$p(admInOutDateInfo,"^",5)
			set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
			set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
			set disDate=##class(websys.Conversions).DateLogicalToHtml(disDate)
			set disTime=##class(websys.Conversions).TimeLogicalToHtml(disTime)
			do OutputAdmList
		}
	}
	
	kill admList
	
	quit $$$OK
OutputAdmList
	set Data=$lb(adm,papmi,regNo,patName,bedName,admDept,admDate,admTime,disDate,disTime)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-03-21
/// Description: 组织床号序号数组
/// Input: wardId:PAC_Ward.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyDtlList).BuildSeqAry(1, "")
ClassMethod BuildSeqAry(wardId As %String, ByRef seqAry) As %String
{
	quit:(+wardId=0) ""
	
	set maxSeqIdx=$o(^PAWARD(0,"Sequence",wardId,""),-1)   //床位表中已排最大序号
	
	set bed=0
	while($o(^PAWARD(wardId,"BED",bed))) {
		set bed=$o(^PAWARD(wardId,"BED",bed))
		set bedData=$g(^PAWARD(wardId,"BED",bed))
		continue:(bedData="")
		set seqIdx=$p(bedData,"^",24)
		if (seqIdx="") set seqIdx=$i(maxSeqIdx)
		set bedRowId=wardId_"||"_bed
		set seqAry(bedRowId)=seqIdx
	}
	
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2018-04-02
/// Description: 获取病区患者树
/// Input: 
/// Output: 
/// Debug: do ##class(web.DHCIPBillDailyDtlList).GetPatTree("21","2","")
ClassMethod GetPatTree(wardId As %String, hospId As %String, episodeId As %String = "", langId As %String = "") As %String
{
	set ^TMP("GetPatTree")=$lb(wardId, hospId, episodeId, langId)
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

	set stream=##class(%Stream.GlobalCharacter).%New()
	set ary=[]
	
	if (+wardId=0) {
		do ary.%ToJSON(.stream)
		do stream.OutputToDevice()
		quit ""
	}
	
	set wardDesc=$p($g(^PAWARD(wardId)),"^",2)
	set wardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc", wardDesc, langId)
	
	set o={}
	set o.id=wardId
	set o.text=wardDesc
	set cld=[]
	set rs=##class(%ResultSet).%New("web.DHCIPBillDailyDtlList:FindAdmList")
	do rs.Execute(wardId, hospId, "", episodeId)
	while (rs.Next()) {
		set adm=rs.Get("adm")
		set papmi=rs.Get("papmi")
		set patientNo=rs.Get("patientNo")
		set patName=rs.Get("patName")
		set bedName=rs.Get("bedName")
		set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
		set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
		set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
		set iconCls=$case(sex,"男":"icon-man","女":"icon-woman",:"icon-unman")
		set d={}
		set d.id=adm
		set d.text=patientNo_", "_patName_", "_bedName_", "_adm
		do d.%Set("checked", 1, "Boolean")
		set d.iconCls=iconCls
		do cld.%Push(d)
	}
	set o.children=cld
	do ary.%Push(o)
	
	do ary.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2018-04-10
/// Description: 病区日清明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "FindDailyDtl","10","174","26/07/2022","00:00:00","26/07/2022","23:59:59","!!!!1")
Query FindDailyDtl(wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, langId As %String = "") As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TBedName:%String:床号,TCateDesc:%String:分类,TItemDesc:%String:项目名称,TQty:%String:数量,TUom:%String:单位,TPrice:%Float:单价,TAmt:%Float:金额,TDate:%String:日期,TTime:%String:时间,TChargeBasis:%String:物价编码,TYBLevel:%String:医保分类,TYBSelfRate:%String:自付比例,TMedListCode:%String:国家医保编码,TMedListDesc:%String:国家医保名称")
{
}

ClassMethod FindDailyDtlExecute(ByRef qHandle As %Binary, wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ((wardId="")||(admStr="")) quit $$$OK
	set ^TMP("FindDailyDtl")=$lb(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr, langId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
   	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)

	set job=$j
    kill ^||TMP(job)
    
	do ..BuildSeqAry(wardId, .seqAry)
    
	for i=1:1:$l(admStr,"!") {
		set adm=$p(admStr,"!",i)
		continue:(+adm=0)
		do ..GetPatDetail(adm, stDate, stTime, endDate, endTime, otherQryStr, job, .seqAry)
	}
	
	//输出
	set seqIdx=""
	while($o(^||TMP(job,seqIdx))) {
		set seqIdx=$o(^||TMP(job,seqIdx))
		set adm=""
		while($o(^||TMP(job,seqIdx,adm))) {
			set adm=$o(^||TMP(job,seqIdx,adm))
			set admFeeStr=$g(^||TMP(job,adm))
			do InitDailyDtl
			set bedName=##class(web.DHCBillCommon).GetPatBedCode(adm)
			set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
			set admReaDesc=$s((+admReaDR'=0):$p(^PAC("ADMREA",admReaDR),"^",2),1:"")
			set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
			set papmi=$p(^PAADM(adm),"^",1)
			set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
			set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)       //性别
			set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
			set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
		 	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
			set patDepAmt=##class(web.UDHCJFBaseCommon).deposit(adm)           //未结算押金金额
			set patTotalAmt=$lg(admFeeStr,1)         //总金额
			set patDiscAmt=$lg(admFeeStr,2)          //折扣金额
			set patPayorShareAmt=$lg(admFeeStr,3)    //记账金额
			set patShareAmt=$lg(admFeeStr,4)         //自付金额
			set patPaidAmt=$lg(admFeeStr,5)          //已结算金额
			set patPaidShareSum=$lg(admFeeStr,6)     //已结算自付金额
			set patInsuPayAmt=$lg(admFeeStr,7)       //医保金额(预结算)
			set cateDesc=##class(websys.Translation).Get("", "费别", langId)_": "_admReaDesc_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "预缴款", langId)_": "_$fn(patDepAmt,"",2)_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "费用", langId)_": "_$fn(patTotalAmt,"",2)
			if (+patPaidAmt'=0) {
				set cateDesc=cateDesc_..#SPACCODE_"("_##class(websys.Translation).Get("", "其中已结算", langId)_": "_$fn(patPaidAmt,"",2)_")"
			}
			set cateDesc=cateDesc_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "自付费用", langId)_": "_$fn(patShareAmt,"",2)
			set cateDesc=cateDesc_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "余额", langId)_": "_$fn(((patDepAmt+patInsuPayAmt)-(patShareAmt-patPaidShareSum)),"",2)   //(未结算押金+医保预结算金额)-未结算金额
			set dtlFlag=4
			do OutputDailyDtl
			do InitDailyDtl
			set dtlNum=0, totalSum=0
			set cateId=0
			while($o(^||TMP(job,seqIdx,adm,cateId))) {
				set cateId=$o(^||TMP(job,seqIdx,adm,cateId))
				set cateDesc=$p(^DHCTarC("TIC",cateId),"^",2)     //住院收费大类
				set cateDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", cateDesc, langId)
				set cateDtlNum=0, cateSum=0
				set itemId=0
				while($o(^||TMP(job,seqIdx,adm,cateId,itemId))) {
					set itemId=$o(^||TMP(job,seqIdx,adm,cateId,itemId))
					set itemDesc=$p($g(^DHCTARI(itemId)),"^",2)
					set itemDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", itemDesc, langId)
					set tmpNode=""
					while($o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode))'="") {
						set tmpNode=$o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode))
						set xmlb=""
						while($o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode,xmlb))'="") {
							set xmlb=$o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode,xmlb))
							set info=$g(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode,xmlb))
							set price=$lg(info,1)
							set price=$fn(price,"",2)       //单价保留四位有效数字
							set qty=$lg(info,2)
							set qty=$fn(qty,"N")
							set amt=$lg(info,3)
							continue:(+amt=0)                        //过滤金额为0的
							set amt=$fn(amt,"",2)
							set totalSum=$i(totalSum,amt)            //合计
							set cateSum=$i(cateSum,amt)              //分类小计
							set uomDR=$lg(info,4)
							set uomDesc=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
							set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
							set date=$lg(info,5)
							set time=$lg(info,6)
							set chargeBasis=$lg(info,7)            //物价编码
							set ybLevel=$s((xmlb=..#XMLBNULLCODE):"",1:xmlb)     //医保等级
							set ybSelfRate=$lg(info,8)                        //自付比例
							set medListCode=$lg(info,9)        //国家医保编码
							set medListDesc=$lg(info,10)       //国家医保名称
							set dtlNum=$i(dtlNum)
							set cateDtlNum=$i(cateDtlNum)
							if (cateDtlNum>1) set cateDesc=""     //一个分类下的明细，分类名称只显示在第一条明细上
							do OutputDailyDtl
						}
					}
				}
				//小计
				do InitDailyDtl
				continue:(cateDtlNum=0)
				set cateDesc=##class(websys.Translation).Get("", "小计", langId)
				set amt=$fn(cateSum,"",2)
				do OutputDailyDtl
			}
			do InitDailyDtl
			continue:(dtlNum=0)
			set cateDesc=##class(websys.Translation).Get("", "总计", langId)
			set amt=$fn(totalSum,"",2)
			do OutputDailyDtl
		}
	}

    kill ^||TMP(job)

	quit $$$OK
	
InitDailyDtl
	set (regNo, mrNo, patName, sex, bedName, cateDesc, itemDesc, qty, uomDesc, price, amt, date, time, chargeBasis, ybLevel, ybSelfRate, medListCode, medListDesc)=""
	quit
	
OutputDailyDtl
	set Data=$lb(regNo,mrNo,patName,sex,adm,bedName,cateDesc,itemDesc,qty,uomDesc,price,amt,date,time,chargeBasis,ybLevel,ybSelfRate,medListCode,medListDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod GetPatDetail(adm As %String, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, job As %String, ByRef seqAry) As %String
{
	set cateId=$p(otherQryStr,"!",1)
	set userDeptId=$p(otherQryStr,"!",2)
	set userDeptGrpId=$p(otherQryStr,"!",3)
	set recDeptId=$p(otherQryStr,"!",4)
	set mergeFlag=$p(otherQryStr,"!",5)

	quit:(adm="") 0
	
	set bedDR=..GetToSortBedId(adm)
	quit:(bedDR="") 0
	set seqIdx=$g(seqAry(bedDR))
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set insTypeDR=$p(pbData,"^",4)
		set payedFlag=$p(pbData,"^",16)
		set patFeeInfo=..GetPatFeeInfo(pb, "", "", endDate, endTime)
		set patTotalSum=$p(patFeeInfo,"^",1)
		set patDiscSum=$p(patFeeInfo,"^",2)
		set patPayorShareSum=$p(patFeeInfo,"^",3)
		set patShareSum=$p(patFeeInfo,"^",4)
		set patPaidSum=$p(patFeeInfo,"^",5)
		set patPaidShareSum=$p(patFeeInfo,"^",6)
		set insuPaySum=$p(patFeeInfo,"^",7)
		set $li(^||TMP(job,adm),1)=$lg($g(^||TMP(job,adm)),1)+patTotalSum
		set $li(^||TMP(job,adm),2)=$lg($g(^||TMP(job,adm)),2)+patDiscSum
		set $li(^||TMP(job,adm),3)=$lg($g(^||TMP(job,adm)),3)+patPayorShareSum
		set $li(^||TMP(job,adm),4)=$lg($g(^||TMP(job,adm)),4)+patShareSum
		set $li(^||TMP(job,adm),5)=$lg($g(^||TMP(job,adm)),5)+patPaidSum
		set $li(^||TMP(job,adm),6)=$lg($g(^||TMP(job,adm)),6)+patPaidShareSum
		set $li(^||TMP(job,adm),7)=$lg($g(^||TMP(job,adm)),7)+insuPaySum
		for date=stDate:1:endDate {
			set pbo=0
			while($o(^DHCPB(0,pb,"PBBILLDATE",date,pbo))) {
				set pbo=$o(^DHCPB(0,pb,"PBBILLDATE",date,pbo))
				set pboData=$g(^DHCPB(pb,"O",pbo))
				continue:(pboData="")
				set oeori=$p(pboData,"^",4)
				continue:(oeori="")
			 	set userDeptDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",2)   //开单科室
			 	continue:((userDeptId'="")&&(userDeptId'=userDeptDR))
			 	set userDeptGrpDR=$s((+userDeptDR'=0):$p($g(^CTLOC(userDeptDR)),"^",19),1:"")
				continue:((userDeptGrpId'="")&&(userDeptGrpId'=userDeptGrpDR))
				set recDeptDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),3)),"^",6)   //接收科室
				continue:((recDeptId'="")&&(recDeptId'=recDeptDR))
				set pbd=0
				while($o(^DHCPB(0,pb,"PBBILLDATE",date,pbo,pbd))) {
					set pbd=$o(^DHCPB(0,pb,"PBBILLDATE",date,pbo,pbd))
					set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
					continue:(pbdData="")
					set pbdRowId=pb_"||"_pbo_"||"_pbd
					set billTime=$p(pbdData,"^",12)
					continue:((stDate=date)&&(stTime'="")&&(billTime<stTime))
					continue:((endDate=date)&&(endTime'="")&&(billTime>endTime))
					set tarItmDR=$p(pbdData,"^",3)
					continue:(+tarItmDR=0)
					set subCateDR=$p(^DHCTARI(tarItmDR),"^",14)
					set cateDR=$p(^DHCTarC("IC",subCateDR),"^",3)          //收费项目住院大类
					continue:((cateId'="")&&(cateId'=cateDR))
					do GetDetail()       //打印收费项
				}
			}
		}
	}
	
	quit 0
	
GetDetail()
	set billDate=##class(websys.Conversions).DateLogicalToHtml(date)
	set billTime=##class(websys.Conversions).TimeLogicalToHtml(billTime)
	set price=$p(pbdData,"^",4)         //PBD_UnitPrice
	set price=$fn(price,"",4)           //单价保留四位有效数字
    set qty=$p(pbdData,"^",5)
    set amt=$p(pbdData,"^",7)           //PBD_TotalAmount
    quit:(+amt=0)
	set uomDR=$p(^DHCTARI(tarItmDR),"^",3)          //单位
	set chargeBasis=$p(^DHCTARI(tarItmDR),"^",50)          //TARI_PriceCode 物价编码
	set subCateDR=$p(^DHCTARI(tarItmDR),"^",14)
	set cateDR=$p(^DHCTarC("IC",subCateDR),"^",3)          //收费项目住院大类
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set insuStr=##class(web.DHCINSUPort).TarItmLinkInsu(tarItmDR, insTypeDR, "", adm, price, admHospDR)
    set xmlb=$p(insuStr,"^",1)        //医保等级
    if (xmlb="") set xmlb=..#XMLBNULLCODE
    set ybSelfRate=$p(insuStr,"^",2)     //自付比例
    if ((ybSelfRate'="")&&(ybSelfRate<1)) {
	    set ybSelfRate=(+ybSelfRate*100)_"%"
	}
	set medListCode=$p(insuStr,"^",12)    //国家医保编码
	set medListDesc=$p(insuStr,"^",13)    //国家医保名称
	if (mergeFlag=1) {
		//合并
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),1)=price
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),2)=$lg($g(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb)),2)+qty
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),3)=$lg($g(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb)),3)+amt
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),4)=uomDR
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),5)=""
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),6)=""
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),7)=chargeBasis
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),8)=ybSelfRate
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),9)=medListCode
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,price,xmlb),10)=medListDesc
	}else {
		//不合并
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),1)=price
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),2)=qty
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),3)=amt
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),4)=uomDR
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),5)=billDate
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),6)=billTime
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),7)=chargeBasis
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),8)=ybSelfRate
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),9)=medListCode
		set $li(^||TMP(job,seqIdx,adm,cateDR,tarItmDR,pbdRowId,xmlb),10)=medListDesc
	}
	
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-04-20
/// Description: 根据账单取患者费用信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyDtlList).GetPatFeeInfo()
ClassMethod GetPatFeeInfo(bill As %String, stDate As %String, stTime As %String, endDate As %String, endTime As %String)
{
	quit:(+bill=0) 0
	if (stDate="") set stDate=0
	if (endDate="") set endDate=+$h
	set (totalSum, discSum, payorShareSum, patShareSum, paidSum, paidPatShare, insuPaySum) = 0
    set insuPaySum=##class(web.DHCINSUPort).GetDividePreByPBDr(bill)     //医保预结算
   	
   	set minBillDate=$o(^DHCPB(0,bill,"PBBILLDATE",0))   //取最小日期
	if (+stDate<minBillDate) set stDate=minBillDate
	
	for date=stDate:1:endDate {
		set pbo=0
		while($o(^DHCPB(0,bill,"PBBILLDATE",date,pbo))) {
			set pbo=$o(^DHCPB(0,bill,"PBBILLDATE",date,pbo))
			set pboData=$g(^DHCPB(bill,"O",pbo))
			set oeori=$p(pboData,"^",4)
			continue:(oeori="")
			set pbd=0
			while($o(^DHCPB(0,bill,"PBBILLDATE",date,pbo,pbd))) {
				set pbd=$o(^DHCPB(0,bill,"PBBILLDATE",date,pbo,pbd))
				set pbdData=$g(^DHCPB(bill,"O",pbo,"D",pbd))
				set pbdTotalAmt=$p(pbdData,"^",7)
				set pbdDiscAmt=$p(pbdData,"^",8)
				set pbdPayorShareAmt=$p(pbdData,"^",9)
				set pbdPatShareAmt=$p(pbdData,"^",10)
				set billTime=$p(pbdData,"^",12)
				set pbdBillStatus=$p(pbdData,"^",14)
				continue:((stDate=date)&&(stTime'="")&&(billTime<stTime))
				continue:((endDate=date)&&(endTime'="")&&(billTime>endTime))
				set totalSum=$i(totalSum, pbdTotalAmt)
				set discSum=$i(discSum, pbdDiscAmt)
				set payorShareSum=$i(payorShareSum, pbdPayorShareAmt)
				set patShareSum=$i(patShareSum, pbdPatShareAmt)
				if (pbdBillStatus="P") {
					set paidSum=$i(paidSum, pbdTotalAmt)
					set paidPatShare=$i(paidPatShare, pbdPatShareAmt)
				}
			}
		}
	}

	quit totalSum_"^"_discSum_"^"_payorShareSum_"^"_patShareSum_"^"_paidSum_"^"_paidPatShare_"^"_insuPaySum
}

/// Creator: ZhYW
/// CreatDate: 2018-04-02
/// Description: 查询分类费用
/// Input: 
/// Output: 以cate开头的为分类及金额
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "FindCateFee","3","5!285","2022-03-31","00:00:00","2022-03-31","23:59:59","!!!","2")
Query FindCateFee(wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TBedName:%String:床号,TCateDesc1:%String:分类,TCateFee1:%Float:金额,TCateDesc2:%String:分类,TCateFee2:%Float:金额,TCateDesc3:%String:分类,TCateFee3:%Float:金额,TCateDesc4:%String:分类,TCateFee4:%Float:金额,TCateDesc5:%String:分类,TCateFee5:%Float:金额")
{
}

ClassMethod FindCateFeeExecute(ByRef qHandle As %Binary, wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("FindCateFee")=$lb(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr, hospId, langId)
	if ((wardId="")||(admStr="")) quit $$$OK
    
    if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
   	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	set job=$j
	kill ^||TMP(job)

	do ..BuildSeqAry(wardId, .seqAry)
	
	for i=1:1:$l(admStr,"!") {
		set adm=$p(admStr,"!",i)
		continue:(+adm=0)
		do ..GetCateFee(adm, stDate, stTime, endDate, endTime, otherQryStr, job, .seqAry)
	}
	
	//获取最后一条住院费用大类rowId
	set maxCateDR=..GetTarICMaxRowID(hospId)

	set seqIdx=""
	while($o(^||TMP(job,seqIdx))) {
		set seqIdx=$o(^||TMP(job,seqIdx))
		set adm=""
		while($o(^||TMP(job,seqIdx,adm))) {
			set adm=$o(^||TMP(job,seqIdx,adm))
			set admFeeStr=$g(^||TMP(job,adm))
			set bedName=##class(web.DHCBillCommon).GetPatBedCode(adm)
			set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
		 	set admReaDesc=$s((+admReaDR'=0):$p(^PAC("ADMREA",admReaDR),"^",2),1:"")
		 	set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
			set papmi=$p(^PAADM(adm),"^",1)
			set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
			set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)       //性别
			set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
			set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
		 	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
		 	set patDepAmt=##class(web.UDHCJFBaseCommon).deposit(adm)           //未结算押金金额
			set patTotalAmt=$lg(admFeeStr,1)         //总金额
			set patDiscAmt=$lg(admFeeStr,2)          //折扣金额
		 	set patPayorShareAmt=$lg(admFeeStr,3)    //记账金额
			set patShareAmt=$lg(admFeeStr,4)         //自付金额
			set patPaidAmt=$lg(admFeeStr,5)          //已结算金额
			set patInsuPayAmt=$lg(admFeeStr,6)       //医保金额(预结算)
			if (+patPaidAmt'=0) {
				set patTotalAmt=$fn(patTotalAmt,"",2)_"("_##class(websys.Translation).Get("", "其中已结算", langId)_"："_$fn(patPaidAmt,"",2)_")"
			}
			set cateDescAry(1)=##class(websys.Translation).Get("", "费别", langId)_": "_admReaDesc_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "预缴款", langId)_": "_$fn(patDepAmt,"",2)_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "费用", langId)_": "_$fn(patTotalAmt,"",2)
			if (+patPaidAmt'=0) {
				set cateDescAry(1)=cateDescAry(1)_..#SPACCODE_"("_##class(websys.Translation).Get("", "其中已结算", langId)_": "_$fn(patPaidAmt,"",2)_")"
			}
			set cateDescAry(1)=cateDescAry(1)_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "自付费用", langId)_": "_$fn(patShareAmt,"",2)
			set cateDescAry(1)=cateDescAry(1)_..#SPACCODE_"/"_..#SPACCODE_##class(websys.Translation).Get("", "余额", langId)_": "_$fn(((patDepAmt+patInsuPayAmt)-(patShareAmt-patPaidAmt)),"",2)   //(押金+医保支付额)-未结算金额
			do OutputCateFee
			do InitOutputCateFee
		 	set num=0, totalSum=0
			//set maxCateDR=$o(^||TMP(job,seqIdx,adm,""),-1)    //放开此句时, 无费用的分类不显示
			set cateDR=0
			//while($o(^||TMP(job,seqIdx,adm,cateDR))) {     //放开此句, 注释掉下面的一句时, 无费用的分类不显示
			while($o(^DHCTarC("TIC",cateDR))) {
				set cateDR=$o(^DHCTarC("TIC",cateDR))
				set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", cateDR, hospId)
				continue:(showFlag="N")
				set num=$i(num)
				set cateDesc=$p(^DHCTarC("TIC",cateDR),"^",2)
				set cateDesc=##class(User.DHCTarIC).GetTranByDesc("TARTICDesc", cateDesc, langId)
				set amt=$g(^||TMP(job,seqIdx,adm,cateDR))
				set amt=$fn(amt,"",2)
				set totalSum=$i(totalSum,amt)
				set mod=num#..#CATECOLNUM
				set cateDescAry($case(mod, 0:..#CATECOLNUM, :mod))=cateDesc
				set cateFeeAry($case(mod, 0:..#CATECOLNUM, :mod))=amt
				if ((mod=0)||(cateDR=maxCateDR)) {
					do OutputCateFee
					do InitOutputCateFee
				}
			}
			do InitOutputCateFee
			set cateDescAry(1)=##class(websys.Translation).Get("", "总计", langId)
			set cateFeeAry(1)=$fn(totalSum,"",2)
			do OutputCateFee
		}
	}

	kill ^||TMP(job)
 	
	quit $$$OK
	
InitOutputCateFee
	set (patName, bedName)=""
	kill cateDescAry
	kill cateFeeAry
	quit
	
OutputCateFee
	set Data=$lb(regNo,mrNo,patName,sex,adm,bedName,cateDescAry(1),cateFeeAry(1),cateDescAry(2),cateFeeAry(2),cateDescAry(3),cateFeeAry(3),cateDescAry(4),cateFeeAry(4),cateDescAry(5),cateFeeAry(5))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod GetCateFee(adm As %String, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, job As %String, ByRef seqAry) As %String
{
	set cateId=$p(otherQryStr,"!",1)
	set userDeptId=$p(otherQryStr,"!",2)
	set userDeptGrpId=$p(otherQryStr,"!",3)
	set recDeptId=$p(otherQryStr,"!",4)

	quit:(adm="") 0
	
	//+2023-02-10 ZhYW 如果是婴儿，则根据母亲床位排序
	set bedDR=..GetToSortBedId(adm)
	quit:(bedDR="") 0
	set seqIdx=$g(seqAry(bedDR))
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		set payedFlag=$p(pbData,"^",16)
		set patFeeInfo=..GetPatFeeInfo(pb, "", "", endDate, endTime)
		set patTotalSum=$p(patFeeInfo,"^",1)
		set patDiscSum=$p(patFeeInfo,"^",2)
		set patPayorShareSum=$p(patFeeInfo,"^",3)
		set patShareSum=$p(patFeeInfo,"^",4)
		set patPaidSum=$p(patFeeInfo,"^",5)
		set patPaidShareSum=$p(patFeeInfo,"^",6)
		set insuPaySum=$p(patFeeInfo,"^",7)
		set $li(^||TMP(job,adm),1)=$lg($g(^||TMP(job,adm)),1)+patTotalSum
		set $li(^||TMP(job,adm),2)=$lg($g(^||TMP(job,adm)),2)+patDiscSum
		set $li(^||TMP(job,adm),3)=$lg($g(^||TMP(job,adm)),3)+patPayorShareSum
		set $li(^||TMP(job,adm),4)=$lg($g(^||TMP(job,adm)),4)+patShareSum
		set $li(^||TMP(job,adm),5)=$lg($g(^||TMP(job,adm)),5)+patPaidSum
		set $li(^||TMP(job,adm),6)=$lg($g(^||TMP(job,adm)),6)+patPaidShareSum
		set $li(^||TMP(job,adm),7)=$lg($g(^||TMP(job,adm)),7)+insuPaySum
		for date=stDate:1:endDate {
			set pbo=0
			while($o(^DHCPB(0,pb,"PBBILLDATE",date,pbo))) {
				set pbo=$o(^DHCPB(0,pb,"PBBILLDATE",date,pbo))
				set pboData=$g(^DHCPB(pb,"O",pbo))
				continue:(pboData="")
				set oeori=$p(pboData,"^",4)
			 	continue:((oeori="")||('$d(^OEORD(+oeori,"I",$p(oeori,"||",2)))))
				set userDeptDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),7)),"^",2)   //开单科室
				continue:((userDeptId'="")&&(userDeptId'=userDeptDR))
				set userDeptGrpDR=$s((+userDeptDR'=0):$p($g(^CTLOC(userDeptDR)),"^",19),1:"")
				continue:((userDeptGrpId'="")&&(userDeptGrpId'=userDeptGrpDR))
				set recDeptDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),3)),"^",6)   //接收科室
				continue:((recDeptId'="")&&(recDeptId'=recDeptDR))
				set pbd=0
				while($o(^DHCPB(0,pb,"PBBILLDATE",date,pbo,pbd))) {
					set pbd=$o(^DHCPB(0,pb,"PBBILLDATE",date,pbo,pbd))
					set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
				 	continue:(pbdData="")
					set billTime=$p(pbdData,"^",12)
					set pbdTotalAmt=$p(pbdData,"^",7)
					continue:(+pbdTotalAmt=0)
					continue:((stDate=date)&&(stTime'="")&&(billTime<stTime))
					continue:((endDate=date)&&(endTime'="")&&(billTime>endTime))
				 	set tarItmDR=$p(pbdData,"^",3)
				 	continue:(+tarItmDR=0)
					set subCateDR=$p(^DHCTARI(tarItmDR),"^",14)
					continue:(+subCateDR=0)
					set cateDR=$p(^DHCTarC("IC",subCateDR),"^",3)          //收费项目住院大类
					continue:((cateId'="")&&(cateId'=cateDR))
					set ^||TMP(job,seqIdx,adm,cateDR)=$i(^||TMP(job,seqIdx,adm,cateDR), pbdTotalAmt)
				}
			}
		}
	}
 	
 	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2018-04-10
/// Description: 病区日清明细单
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "GetPrintDtl","21","2887!1624!6119!4113!73!44!280!71!41!4114!38!1552!3473!781!533!293!441!799!3582!999!3042!1457!1571!2650!3570!322!1897!1246!5464!3637!1721!2068!3342!3673!2465!2573!3077!1770!3544!3675!3595!4279!3715!4929!3717!3737!3738!5796!5760","2021-12-08","00:00:00","2021-12-08","23:59:59","!!!","2",1)
Query GetPrintDtl(wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String, dtlColNum As %Integer) As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TBedName:%String:床号,TWardDesc:%String:病区,TAdmReaDesc:%String:费别,TDtlFlag:%String,TStDate:%String,TStTime:%String,TEndDate:%String,TEndTime:%String,TPrtDate:%String,TCateDesc:%String,TItemDesc:%String,TQty:%String,TUom:%String,TPrice:%String,TAmt:%String,TDate:%String,TTime:%String,TChargeBasis:%String,TYBLevel:%String,TYBSelfRate:%String,TMedListCode:%String,TMedListDesc:%String,TItemDesc1:%String,TQty1:%String,TUom1:%String,TPrice1:%String,TAmt1:%String,TDate1:%String,TTime1:%String,TChargeBasis1:%String,TYBLevel1:%String,TYBSelfRate1:%String,TMedListCode1:%String,TMedListDesc1:%String") [ SqlProc ]
{
}

ClassMethod GetPrintDtlExecute(ByRef qHandle As %Binary, wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String, dtlColNum As %Integer) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("GetDailyDtlColPrint")=$lb(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr, hospId, dtlColNum)
	if ((wardId="")||(admStr="")) quit $$$OK
	
   	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	do ..BuildSeqAry(wardId, .seqAry)
	
	set prtMode=..GetPrtMode(hospId)
	for i=1:1:$l(admStr,"!") {
		set episodeId=$p(admStr,"!",i)
		continue:(+episodeId=0)
		if (prtMode=1) {
			//按天拆分打印
			for myDate=stDate:1:endDate {
				set myStTime=$case(myDate,stDate:stTime,:0)
				set myEndTime=$case(myDate,endDate:endTime,:86399)
				do GetDtl(myDate, myStTime, myDate, myEndTime, myDate)
			}
		}else {
			//不按天拆分打印
			do GetDtl(stDate, stTime, endDate, endTime, stDate)
		}
	}
	
	quit $$$OK

GetDtl(myStDate, myStTime, myEndDate, myEndTime, prtDate)
	set job=$j
    kill ^||TMP(job)
    
    do ..GetPatDetail(episodeId, myStDate, myStTime, myEndDate, myEndTime, otherQryStr, job, .seqAry)
	
	set myStDate=##class(websys.Conversions).DateLogicalToHtml(myStDate)
	set myStTime=##class(websys.Conversions).TimeLogicalToHtml(myStTime, 2)
	set myEndDate=##class(websys.Conversions).DateLogicalToHtml(myEndDate)
	set myEndTime=##class(websys.Conversions).TimeLogicalToHtml(myEndTime, 2)
	
	//输出
	set seqIdx=""
	while($o(^||TMP(job,seqIdx))) {
		set seqIdx=$o(^||TMP(job,seqIdx))
		set adm=""
		while($o(^||TMP(job,seqIdx,adm))) {
			set adm=$o(^||TMP(job,seqIdx,adm))
			set admFeeStr=$g(^||TMP(job,adm))
			set bedName=##class(web.DHCBillCommon).GetPatBedCode(adm)
		 	set wardDR=$p(^PAADM(adm),"^",70)
		 	set wardDesc=$s((+wardDR'=0):$p(^PAWARD(wardDR),"^",2),1:"")
			set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
		 	set admReaDesc=$s((+admReaDR'=0):$p(^PAC("ADMREA",admReaDR),"^",2),1:"")
			set papmi=$p(^PAADM(adm),"^",1)
			set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
		 	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
		 	set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)       //性别
			set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
		 	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
		 	set patDepAmt=##class(web.UDHCJFBaseCommon).deposit(adm)           //未结算押金金额
		 	set patTotalAmt=$lg(admFeeStr,1)         //总金额
		 	set patDiscAmt=$lg(admFeeStr,2)          //折扣金额
		 	set patPayorShareAmt=$lg(admFeeStr,3)    //记账金额
		 	set patShareAmt=$lg(admFeeStr,4)         //自付金额
		 	set patPaidAmt=$lg(admFeeStr,5)          //已结算金额
		 	set patPaidShareSum=$lg(admFeeStr,6)     //已结算自付金额
		 	set patInsuPayAmt=$lg(admFeeStr,7)       //医保金额(预结算)
		 	set dtlNum=0, totalSum=0
		  	set cateId=0
		  	while($o(^||TMP(job,seqIdx,adm,cateId))) {
			  	set cateId=$o(^||TMP(job,seqIdx,adm,cateId))
				set cateDesc=$p(^DHCTarC("TIC",cateId),"^",2)     //住院收费大类
				set cateDtlNum=0, cateSum=0
				kill cateDtlAry
				set itemId=0
				while($o(^||TMP(job,seqIdx,adm,cateId,itemId))) {
					set itemId=$o(^||TMP(job,seqIdx,adm,cateId,itemId))
					set itemDesc=$p($g(^DHCTARI(itemId)),"^",2)
					set tmpNode=""
					while($o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode))'="") {
						set tmpNode=$o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode))
						set xmlb=""
						while($o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode,xmlb))'="") {
							set xmlb=$o(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode,xmlb))
							set info=$g(^||TMP(job,seqIdx,adm,cateId,itemId,tmpNode,xmlb))
							set dtlFlag=0                            //隐藏元素,打印报表用
							set price=$lg(info,1)
							set price=$fn(price,"",4)          //单价保留四位有效数字
							set qty=$lg(info,2)
							set qty=$fn(qty,"N")
							set amt=$lg(info,3)
							continue:(+amt=0)                            //过滤金额为0的
							set amt=$fn(amt,"",2)
							set totalSum=$i(totalSum,amt)            //合计
							set cateSum=$i(cateSum,amt)              //分类小计
							set uomDR=$lg(info,4)
							set uomDesc=$s((+uomDR'=0):$p($g(^CT("UOM",uomDR)),"^",2),1:"")
							set date=$lg(info,5)
							set time=$lg(info,6)
							set chargeBasis=$lg(info,7)            //物价编码
							set ybLevel=$s((xmlb=..#XMLBNULLCODE):"",1:xmlb)        //医保等级
							set ybSelfRate=$lg(info,8)            //自付比例
							set medListCode=$lg(info,9)           //国家医保编码
							set medListDesc=$lg(info,10)          //国家医保名称
							set dtlNum=$i(dtlNum)
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
						do OutputPrintDtl
						do InitPrintDtl
					}
				}
				//小计
				continue:(cateDtlNum=0)
				do InitPrintDtl
				set dtlFlag=1
				set cateDesc="小计"
				set amt=$fn(cateSum,"",2)
				set itmDtlAry(1)=$$GetDtlData()
				do OutputPrintDtl
			}
		  	//
		  	continue:(dtlNum=0)
		  	do InitPrintDtl
		  	set dtlFlag=2
			set cateDesc="总计"
			set amt=$fn(totalSum,"",2)
			set itmDtlAry(1)=$$GetDtlData()
			do OutputPrintDtl
			do InitPrintDtl
			set dtlFlag=3
			set cateDesc="预缴款", itemDesc=$fn(patDepAmt,"",2)
			set qty="费用", uomDesc=$fn(patTotalAmt,"",2)
			if (+patPaidAmt'=0) {
				set uomDesc=uomDesc_"(其中已结算:"_$fn(patPaidAmt,"",2)_")"
			}
			set price="自付费用", amt=$fn(patShareAmt,"",2)
			set date="余额", time=$fn(((patDepAmt+patInsuPayAmt)-(patShareAmt-patPaidShareSum)),"",2)   //(未结算押金+医保预结算金额)-未结算金额
			set itmDtlAry(1)=$$GetDtlData()
			do OutputPrintDtl
		}
	}

    kill ^||TMP(job)

	quit

InitPrintDtl
	set (itemDesc, qty, uomDesc, price, amt, date, time, chargeBasis, ybLevel, ybSelfRate, medListCode, medListDesc)=""
	for j=1:1:dtlColNum {
		set itmDtlAry(j)=$$GetDtlData()
	}
	quit
	
GetDtlData()
	//若需要修改输出列,只需要修改这里
	set dtlData=$lb(itemDesc, qty, uomDesc, price, amt, date, time, chargeBasis, ybLevel, ybSelfRate, medListCode, medListDesc)
	quit dtlData
	
OutputPrintDtl
	set Data=$lb(regNo,mrNo,patName,sex,adm,bedName,wardDesc,admReaDesc,dtlFlag,myStDate,myStTime,myEndDate,myEndTime,prtDate,cateDesc)
	for k=1:1:dtlColNum {
		set Data=Data_$g(itmDtlAry(k))
	}
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-04-02
/// Description: 查询分类费用
/// Input: 
/// Output: 以cate开头的为分类及金额
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "GetCateFeePrint","21","2887!1624!6119!4113!73!44!280!71!41!4114!38!1552!3473!781!533!293!441!799!3582!999!3042!1457!1571!2650!3570!322!1897!1246!5464!3637!1721!2068!3342!3673!2465!2573!3077!1770!3544!3675!3595!4279!3715!4929!3717!3737!3738!5796!5760","2021-12-08","00:00:00","2021-12-08","23:59:59","!!!","2")
Query GetCateFeePrint(wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String) As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TBedName:%String:床号,TWardDesc:%String,TAdmReaDesc:%String,TPatDepAmt:%Float,TPatTotalAmt:%String,TPatShareAmt:%Float,TLeftAmt:%Float,TDtlFlag:%String,TStDate:%String,TStTime:%String,TEndDate:%String,TEndTime:%String,TPrtDate:%String,TCateDesc1:%String:分类,TCateFee1:%Float:金额,TCateDesc2:%String:分类,TCateFee2:%Float:金额,TCateDesc3:%String:分类,TCateFee3:%Float:金额,TCateDesc4:%String:分类,TCateFee4:%Float:金额,TCateDesc5:%String:分类,TCateFee5:%Float:金额") [ SqlProc ]
{
}

ClassMethod GetCateFeePrintExecute(ByRef qHandle As %Binary, wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("GetCateFeePrint")=$lb(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr, hospId)
	if ((wardId="")||(admStr="")) quit $$$OK
	
   	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)
	
	do ..BuildSeqAry(wardId, .seqAry)
	
	set prtMode=..GetPrtMode(hospId)
	for i=1:1:$l(admStr,"!") {
		set episodeId=$p(admStr,"!",i)
		continue:(+episodeId=0)
		if (prtMode=1) {
			//按天拆分打印
			for myDate=stDate:1:endDate {
				set myStTime=$case(myDate,stDate:stTime,:0)
				set myEndTime=$case(myDate,endDate:endTime,:86399)
				do GetCateFee(myDate, myStTime, myDate, myEndTime, myDate)
			}
		}else {
			//不按天拆分打印
			do GetCateFee(stDate, stTime, endDate, endTime, stDate)
		}
	}
	
	quit $$$OK
	
GetCateFee(myStDate, myStTime, myEndDate, myEndTime, prtDate)
	set job=$j
	kill ^||TMP(job)

	do ..GetCateFee(episodeId, myStDate, myStTime, myEndDate, myEndTime, otherQryStr, job, .seqAry)
	
	set myStDate=##class(websys.Conversions).DateLogicalToHtml(myStDate)
	set myStTime=##class(websys.Conversions).TimeLogicalToHtml(myStTime, 2)
	set myEndDate=##class(websys.Conversions).DateLogicalToHtml(myEndDate)
	set myEndTime=##class(websys.Conversions).TimeLogicalToHtml(myEndTime, 2)

	//获取最后一条住院费用大类rowId
	set maxCateDR=..GetTarICMaxRowID(hospId)
	
	set seqIdx=""
	while($o(^||TMP(job,seqIdx))) {
		set seqIdx=$o(^||TMP(job,seqIdx))
		set adm=""
		while($o(^||TMP(job,seqIdx,adm))) {
			set adm=$o(^||TMP(job,seqIdx,adm))
			set admFeeStr=$g(^||TMP(job,adm))
			set bedName=##class(web.DHCBillCommon).GetPatBedCode(adm)
			set wardDR=$p(^PAADM(adm),"^",70)
			set wardDesc=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2),1:"")
			set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
		 	set admReaDesc=$s((+admReaDR'=0):$p(^PAC("ADMREA",admReaDR),"^",2),1:"")
			set papmi=$p(^PAADM(adm),"^",1)
			set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
			set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)       //性别
			set sex=$s((+sexDR'=0):$p($g(^CT("SEX",sexDR)),"^",2),1:"")
		 	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
		 	set patDepAmt=##class(web.UDHCJFBaseCommon).deposit(adm)           //未结算押金金额
			set patTotalAmt=$lg(admFeeStr,1)         //总金额
			set patDiscAmt=$lg(admFeeStr,2)          //折扣金额
		 	set patPayorShareAmt=$lg(admFeeStr,3)    //记账金额
			set patShareAmt=$lg(admFeeStr,4)         //自付金额
			set patPaidAmt=$lg(admFeeStr,5)          //已结算金额
			set patPaidShareSum=$lg(admFeeStr,6)     //已结算自付金额
			set patInsuPayAmt=$lg(admFeeStr,7)       //医保金额(预结算)
			set patDepAmt=$fn(patDepAmt,"",2)
			set patTotalAmt=$fn(patTotalAmt,"",2)
			set patShareAmt=$fn(patShareAmt,"",2)
			set leftAmt=$fn(((patDepAmt+patInsuPayAmt)-(patShareAmt-patPaidShareSum)),"",2)       //(未结算押金+医保预结算金额)-未结算金额
			if (+patPaidAmt'=0) {
				set patTotalAmt=$fn(patTotalAmt,"",2)_"(其中已结算:"_$fn(patPaidAmt,"",2)_")"
			}
		 	set num=0, totalSum=0
			//set maxCateDR=$o(^||TMP(job,seqIdx,adm,""),-1)    //放开此句时, 无费用的分类不显示
			set cateDR=0
			//while($o(^||TMP(job,seqIdx,adm,cateDR))) {       //放开此句,注释掉下面的一句时, 无费用的分类不显示
			while($o(^DHCTarC("TIC",cateDR))) {
				set cateDR=$o(^DHCTarC("TIC",cateDR))
				set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", cateDR, hospId)
				continue:(showFlag="N")
				set dtlFlag=0
				set num=$i(num)
				set cateDesc=$p(^DHCTarC("TIC",cateDR),"^",2)
				set amt=$g(^||TMP(job,seqIdx,adm,cateDR))
				set amt=$fn(amt,"",2)
				set totalSum=$i(totalSum,amt)
				set mod=num#..#CATECOLNUM
				set cateDescAry($case(mod, 0:..#CATECOLNUM, :mod))=cateDesc
				set cateFeeAry($case(mod, 0:..#CATECOLNUM, :mod))=amt
				if ((mod=0)||(cateDR=maxCateDR)) {
					do OutputPrintCate
					do InitPrintCate
				}
			}
			do InitPrintCate
			set dtlFlag=1
			set cateDescAry(1)="总计"
			set cateFeeAry(1)=$fn(totalSum,"",2)
			do OutputPrintCate
		}
	}

	kill ^||TMP(job)
 	
	quit
	
InitPrintCate
	kill cateDescAry
	kill cateFeeAry
	quit
	
OutputPrintCate
	set Data=$lb(regNo,mrNo,patName,sex,adm,bedName,wardDesc,admReaDesc,patDepAmt,patTotalAmt,patShareAmt,leftAmt,dtlFlag,myStDate,myStTime,myEndDate,myEndTime,prtDate,cateDescAry(1),cateFeeAry(1),cateDescAry(2),cateFeeAry(2),cateDescAry(3),cateFeeAry(3),cateDescAry(4),cateFeeAry(4),cateDescAry(5),cateFeeAry(5))
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-11-12
/// Description: 获取清单打印模式
/// Input: hospId:CT_Hospital.RowId
/// Return: 0: 不按天拆分打印; 1:按天拆分打印
/// Debug: w ##class(web.DHCIPBillDailyDtlList).GetPrtMode(2)
ClassMethod GetPrtMode(hospId As %String) As %String
{
	quit ##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.ipbill.dailydtllist.csp", "DSD", "", hospId)
}

/// Creator: ZhYW
/// CreatDate: 2021-07-27
/// Description: 病区日清明细单
/// Input: 一栏显示
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "QryPrintDtl1","21","2887","01/08/2021","00:00:00","11/08/2021","23:59:59","!!!!1","2")
Query QryPrintDtl1(wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String) As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TBedName:%String:床号,TWardDesc:%String,TAdmReaDesc:%String,TDtlFlag:%String,TStDate:%String,TStTime:%String,TEndDate:%String,TEndTime:%String,TPrtDate:%String,TCateDesc:%String,TItemDesc:%String,TQty:%String,TUom:%String,TPrice:%String,TAmt:%String,TDate:%String,TTime:%String,TChargeBasis:%String,TYBLevel:%String,TYBSelfRate:%String,TMedListCode:%String,TMedListDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPrintDtl1Execute(ByRef qHandle As %Binary, wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("QryPrintDtl1")=$lb(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr,  hospId)
	if ((wardId="")||(admStr="")) quit $$$OK
		
	set rset=##class(%ResultSet).%New("web.DHCIPBillDailyDtlList:GetPrintDtl")
	do rset.Execute(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr,  hospId, 1)
	while (rset.Next()) {
		set regNo=rset.Get("TRegNo")
		set mrNo=rset.Get("TMrNo")
		set patName=rset.Get("TPatName")
		set sex=rset.Get("TSex")
		set adm=rset.Get("TAdm")
		set bedName=rset.Get("TBedName")
		set wardDesc=rset.Get("TWardDesc")
		set admReaDesc=rset.Get("TAdmReaDesc")
		set dtlFlag=rset.Get("TDtlFlag")
		set myStDate=rset.Get("TStDate")
		set myStTime=rset.Get("TStTime")
		set myEndDate=rset.Get("TEndDate")
		set myEndTime=rset.Get("TEndTime")
		set prtDate=rset.Get("TPrtDate")
		set cateDesc=rset.Get("TCateDesc")
		
		set itemDesc=rset.Get("TItemDesc")
		set qty=rset.Get("TQty")
		set uomDesc=rset.Get("TUom")
		set price=rset.Get("TPrice")
		set amt=rset.Get("TAmt")
		set date=rset.Get("TDate")
		set time=rset.Get("TTime")
		set chargeBasis=rset.Get("TChargeBasis")
		set ybLevel=rset.Get("TYBLevel")
		set ybSelfRate=rset.Get("TYBSelfRate")
		set medListCode=rset.Get("TMedListCode")
		set medListDesc=rset.Get("TMedListDesc")
		
		set Data=$lb(regNo,mrNo,patName,sex,adm,bedName,wardDesc,admReaDesc,dtlFlag,myStDate,myStTime,myEndDate,myEndTime,prtDate,cateDesc,itemDesc,qty,uomDesc,price,amt,date,time,chargeBasis,ybLevel,ybSelfRate,medListCode,medListDesc)
	 	set ^CacheTemp(repid,ind)=Data
	 	set ind=$i(ind)
	}
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2021-07-27
/// Description: 病区日清明细单
/// Input: 分两栏显示
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillDailyDtlList", "QryPrintDtl2","21","2887","01/08/2021","00:00:00","11/08/2021","23:59:59","!!!!1","2")
Query QryPrintDtl2(wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String) As websys.Query(ROWSPEC = "TRegNo:%String:登记号,TMrNo:%String:病案号,TPatName:%String:患者姓名,TSex:%String:性别,TAdm:%String:就诊ID,TBedName:%String:床号,TWardDesc:%String,TAdmReaDesc:%String,TDtlFlag:%String,TStDate:%String,TStTime:%String,TEndDate:%String,TEndTime:%String,TPrtDate:%String,TCateDesc:%String,TItemDesc:%String,TQty:%String,TUom:%String,TPrice:%String,TAmt:%String,TDate:%String,TTime:%String,TChargeBasis:%String,TYBLevel:%String,TYBSelfRate:%String,TMedListCode:%String,TMedListDesc:%String,TItemDesc1:%String,TQty1:%String,TUom1:%String,TPrice1:%String,TAmt1:%String,TDate1:%String,TTime1:%String,TChargeBasis1:%String,TYBLevel1:%String,TYBSelfRate1:%String,TMedListCode1:%String,TMedListDesc1:%String") [ SqlProc ]
{
}

ClassMethod QryPrintDtl2Execute(ByRef qHandle As %Binary, wardId As %String, admStr As %Text, stDate As %String, stTime As %String, endDate As %String, endTime As %String, otherQryStr As %String, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("QryPrintDtl2")=$lb(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr, hospId)
	if ((wardId="")||(admStr="")) quit $$$OK
	
	set rset=##class(%ResultSet).%New("web.DHCIPBillDailyDtlList:GetPrintDtl")
	do rset.Execute(wardId, admStr, stDate, stTime, endDate, endTime, otherQryStr,  hospId, 2)
	while (rset.Next()) {
		set regNo=rset.Get("TRegNo")
		set mrNo=rset.Get("TMrNo")
		set patName=rset.Get("TPatName")
		set sex=rset.Get("TSex")
		set adm=rset.Get("TAdm")
		set bedName=rset.Get("TBedName")
		set wardDesc=rset.Get("TWardDesc")
		set admReaDesc=rset.Get("TAdmReaDesc")
		set dtlFlag=rset.Get("TDtlFlag")
		set myStDate=rset.Get("TStDate")
		set myStTime=rset.Get("TStTime")
		set myEndDate=rset.Get("TEndDate")
		set myEndTime=rset.Get("TEndTime")
		set prtDate=rset.Get("TPrtDate")
		set cateDesc=rset.Get("TCateDesc")
		
		set itemDesc=rset.Get("TItemDesc")
		set qty=rset.Get("TQty")
		set uomDesc=rset.Get("TUom")
		set price=rset.Get("TPrice")
		set amt=rset.Get("TAmt")
		set date=rset.Get("TDate")
		set time=rset.Get("TTime")
		set chargeBasis=rset.Get("TChargeBasis")
		set ybLevel=rset.Get("TYBLevel")
		set ybSelfRate=rset.Get("TYBSelfRate")
		set medListCode=rset.Get("TMedListCode")
		set medListDesc=rset.Get("TMedListDesc")
		
		set itemDesc1=rset.Get("TItemDesc1")
		set qty1=rset.Get("TQty1")
		set uomDesc1=rset.Get("TUom1")
		set price1=rset.Get("TPrice1")
		set amt1=rset.Get("TAmt1")
		set date1=rset.Get("TDate1")
		set time1=rset.Get("TTime1")
		set chargeBasis1=rset.Get("TChargeBasis1")
		set ybLevel1=rset.Get("TYBLevel1")
		set ybSelfRate1=rset.Get("TYBSelfRate1")
		set medListCode1=rset.Get("TMedListCode1")
		set medListDesc1=rset.Get("TMedListDesc1")
		
		set Data=$lb(regNo,mrNo,patName,sex,adm,bedName,wardDesc,admReaDesc,dtlFlag,myStDate,myStTime,myEndDate,myEndTime,prtDate,cateDesc,itemDesc,qty,uomDesc,price,amt,date,time,chargeBasis,ybLevel,ybSelfRate,medListCode,medListDesc,itemDesc1,qty1,uomDesc1,price1,amt1,date1,time1,chargeBasis1,ybLevel1,ybSelfRate1,medListCode1,medListDesc1)
	 	set ^CacheTemp(repid,ind)=Data
	 	set ind=$i(ind)
	}
	
	quit $$$OK
}

/// Creator: ZhYW
/// CreatDate: 2021-12-08
/// Description: 获取最后一条住院费用大类rowId
/// Input: hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillDailyDtlList).GetTarICMaxRowID(2)
ClassMethod GetTarICMaxRowID(hospId As %String) As %String
{
	if ($d(%MaxCateID(hospId))) {
		quit %MaxCateID(hospId)
	}
	set maxCateDR=""
	set cateDR=""
	while($o(^DHCTarC("TIC",cateDR),-1)) {
		set cateDR=$o(^DHCTarC("TIC",cateDR),-1)
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", cateDR, hospId)
		continue:(showFlag="N")
		set maxCateDR=cateDR
		quit
	}
	set %MaxCateID(hospId)=maxCateDR
	quit maxCateDR
}

/// Creator: ZhYW
/// CreatDate: 2023-02-10
/// Description: 获取待排序的床号Id
/// Input: adm:PA_Adm.RowId
/// Return: PAC_Bed.RowId
/// Debug: w ##class(web.DHCIPBillDailyDtlList).GetToSortBedId(2)
ClassMethod GetToSortBedId(adm As %String) As %String
{
	set bedId=""
	set seqByMom=..IsSortedByMotherAdm(adm)
	if (seqByMom=1) {
		set momAdm=$p($g(^PAADM(adm)),"^",75)
		set bedId=##class(BILL.IP.COM.Method).GetTransBedId(momAdm)
		quit:(bedId'="") bedId
	}
	set bedId=##class(BILL.IP.COM.Method).GetTransBedId(adm)
	quit bedId
}

/// Creator: ZhYW
/// CreatDate: 2023-02-10
/// Description: 是否根据母亲床位排序
/// Input: adm:PA_Adm.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCIPBillDailyDtlList).IsSortedByMotherAdm(2)
ClassMethod IsSortedByMotherAdm(adm As %String) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	set admData=$g(^PAADM(adm))
	set momAdm=$p(admData,"^",75)
	quit:(+momAdm=0) rtn
	set currWardDR=$p(admData,"^",70)
	quit:(+currWardDR=0) rtn
	set momCurrWardDR=$p($g(^PAADM(momAdm)),"^",70)
	set rtn=(momCurrWardDR=currWardDR)
	quit rtn
}

}
