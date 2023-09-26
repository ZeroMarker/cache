Class web.DHCPE.ImportCardInfo Extends %RegisteredObject
{

ClassMethod GetCardInfo(CardId, InString, Type, job, TotalAmt = "", HospID As %Library.String = "", LocID As %Library.String = "")
{
	s $zt="GetErr"
	s ErrInfo=""
	q:CardId="" "源卡号ID不能为空！"
	q:$g(^DHCPEAP(CardId))="" "源卡信息为空！"
	
	s No=$p($g(^DHCPEAP(CardId)),"^",2)
	s DoType=$p($g(^DHCPEAP(CardId)),"^",3)
	q:No="" "源卡号为空！"
	q:DoType="" "源卡类型为空！"
	
	s CardInfo=##class(web.DHCPE.AdvancePayment).GetInfoByNo(No,DoType,HospID,LocID)
	q:CardInfo="" "源卡信息为空！"
	;0^RegNo^Info^ID^Status^Amount
	q:$p(CardInfo,"^",1)'="0" "源卡信息获取有误！"
	q:$p(CardInfo,"^",5)'="正常" "源卡状态为"_$p(CardInfo,"^",5)_"！"
	q:TotalAmt>$p(CardInfo,"^",6) "金额不足，源卡金额为"_$p(CardInfo,"^",6)_"元，转移金额为"_TotalAmt_"！"
	
	s:TotalAmt="" TotalAmt=$p(CardInfo,"^",6)
	
	s rowSort=$p(InString,"^",$L(InString,"^"))
	
	s CardNo=$p(InString,"^",1)
	s:CardNo="" ErrInfo=ErrInfo_"充值卡号不能为空！"_$c(10)
	s:No=CardNo ErrInfo=ErrInfo_"充值卡号与源卡号相同，不能转移！"_$c(10)
	
	s Name=$p(InString,"^",2)
	s:Name="" ErrInfo=ErrInfo_"姓名不能为空！"_$c(10)
	
	s Sex=$p(InString,"^",3)
	
	s Amt=$p(InString,"^",4)
	s:Amt="" ErrInfo=ErrInfo_"充值金额不能为空！"_$c(10)
	s:+Amt<0 ErrInfo=ErrInfo_"充值金额不能为负数！"_$c(10)
	
	s rCardId=##class(web.DHCPE.AdvancePayment).GetRowIDByRegNo(CardNo,DoType)
	i rCardId'="" d
	.s cNo=$p($g(^DHCPEAP(rCardId)),"^",2)
	.s cDoType=$p($g(^DHCPEAP(rCardId)),"^",3)
	.s cInfo=##class(web.DHCPE.AdvancePayment).GetInfoByNo(cNo,cDoType,HospID,LocID)
	.s info=$p(cInfo,"^",3)
	.s:info'=(Name_" "_Sex) ErrInfo=ErrInfo_"已有卡信息，但姓名或性别不正确！;"_$c(10)
	.s:$p(cInfo,"^",5)'="正常" ErrInfo=ErrInfo_"该充值卡状态为"_$p(cInfo,"^",5)_"！"_$c(10)
	
	s Remark=$p(InString,"^",5)
	s Tel=$p(InString,"^",6)
	s IDCard=$p(InString,"^",7)
	s EndDate=$p(InString,"^",8)
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	s:EndDate<+$H ErrInfo=ErrInfo_"截止日期不能小于今天！;"_$c(10)
	q:ErrInfo'="" ErrInfo
	
	s ^DHCPEImportCardInfo("TotalAmt",job,"CardId",CardId)=+Amt+$g(^DHCPEImportCardInfo("TotalAmt",job,"CardId",CardId))
	s:$g(^DHCPEImportCardInfo("TotalAmt",job,"CardId",CardId))>TotalAmt ErrInfo=ErrInfo_"源卡金额不足！"_$c(10)
	q:ErrInfo'="" ErrInfo
	
	
	s Sort=+$G(^DHCPEImportCardInfo("Import",job,"CardId",CardId,"Sort"))
	s Sort=Sort+1
	
	s ^DHCPEImportCardInfo("Import",job,"CardId",CardId,"CardInfo",Sort)=CardNo_"^"_DoType_"^"_Name_"^"_Sex_"^"_Amt_"^"_Remark_"^"_Tel_"^"_IDCard_"^"_EndDate_"^"_rowSort
	s ^DHCPEImportCardInfo("Import",job,"CardId",CardId,"Sort")=Sort
	q 0
GetErr
	q $g(CardNo)_"^"_$g(DoType)_"^"_$g(Name)_"^"_$g(Sex)_"^"_$g(Amt)_"^"_$g(Remark)_"^"_$g(Tel)_"^错误:"_$ZERROR
}

ClassMethod Main(CardId, job)
{
	k ^DHCPEImportCardInfo("ImportErr",job,"CardId",CardId)
	s TotaNum=0
	s SussNum=0
	s FailNum=0
	s SQLCODE=0
	s sort=0
	f  s sort=$O(^DHCPEImportCardInfo("Import",job,"CardId",CardId,"CardInfo",sort)) q:((sort="")||(SQLCODE'=0))  d
	.TSTART
	.s SQLCODE=..ImportCardInfo(CardId,job,sort)
	.TCOMMIT:SQLCODE=0
	.//q:SQLCODE'=0
	.TROLLBACK:SQLCODE'=0
	.
	.s TotaNum=TotaNum+1
	.s:SQLCODE=0 SussNum=SussNum+1
	.q:SQLCODE=0
	.
	.s FailNum=FailNum+1
	.s Info=$G(^DHCPEImportCardInfo("Import",job,"CardId",CardId,"CardInfo",sort))
	.s RowSort=$P(Info,"^",$L(Info,"^"))
	.s ^DHCPEImportCardInfo("ImportErr",job,"CardId",CardId,RowSort)=SQLCODE_"^"_Info
	
	//TCOMMIT
	d ..KillImportGlobal(job)
	q TotaNum_"^"_SussNum_"^"_FailNum
}

ClassMethod ImportCardInfo(SourceID, job, Sort)
{
	s rowData=$g(^DHCPEImportCardInfo("Import",job,"CardId",SourceID,"CardInfo",Sort))
	q:rowData="" "-1^无信息"
	// CardNo_"^"_DoType_"^"_Name_"^"_Sex_"^"_Amt_"^"_Remark_"^"_Tel_"^"_IDCard_"^"_EndDate_"^"_rowSort
	
	s MoveAmt=$p(rowData,"^",5)
	s SourceAmt=$p($g(^DHCPEAP(SourceID)),"^",4)
	q:(+SourceAmt)<(+MoveAmt) "-1^转出总金额:"_MoveAmt_"大于当前剩余总金额:"_SourceAmt
	
	s ret=""
	s RealNo=$p(rowData,"^",1)
	s Type=$p(rowData,"^",2)
	s SourcePassWord=$p(^DHCPEAP(SourceID),"^",10)
	s ToID=##class(web.DHCPE.AdvancePayment).GetRowIDByRegNo(RealNo,Type)
	i ToID="" d
	.//^^1112^C^^N^^^^备注^&0^1^1^^Y^&王任重^男^23
	.s InfoStr="^^"_RealNo_"^"_Type_"^^N^^^^"_$p(rowData,"^",6)_"^"_SourcePassWord_"^^^^"_$p(rowData,"^",9)_"^&0^1^1^^Y^&"_$p(rowData,"^",3)_"^"_$p(rowData,"^",4)_"^&"_$p(rowData,"^",7)_"^"_$p(rowData,"^",8)
	.s ret=##class(web.DHCPE.AdvancePayment).UpdateData("1",InfoStr)
	
	i $P(ret,"^",1)=0 d
	.s ToID=+$P(ret,"^",2)
	
	q:ToID="" "-1^"_RealNo_"：建卡失败！"
	
	//s:Type="C" ^DHCPEDataEx("DHCPEAD","Info",ToID)=$p(rowData,"^",3)_"^"_$p(rowData,"^",4)_"^"
	s Name=$p(rowData,"^",3)
	s Sex=$p(rowData,"^",4)
	s Tel=$p(rowData,"^",7)
	s IDCard=$p(rowData,"^",8)
	s EndDate=$p(rowData,"^",9)
	s BaseInfo=Name_"^"_Sex_"^"_Tel_"^"_IDCard_"^"_EndDate
	s ErrInfo=0
	s ret=##class(web.DHCPE.AdvancePayment).MoveAmount(SourceID, ToID, MoveAmt,BaseInfo)
	i $P(ret,"^",1)'=0 d
	.s ErrInfo="-1^"_RealNo_"：转卡金额失败;"_ret
	
	q ErrInfo
}

ClassMethod GetImportErr(CardId, job, RowSort)
{
	q $g(^DHCPEImportCardInfo("ImportErr",job,"CardId",CardId,RowSort))
}

ClassMethod KillImportGlobal(job)
{
	k ^DHCPEImportCardInfo("Import",job)
	k ^DHCPEImportCardInfo("TotalAmt",job)
	q 0
}

}
