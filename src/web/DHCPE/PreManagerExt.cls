/// Descript:预约限额管理---全程医疗
/// Creator:wangguoying
Class web.DHCPE.PreManagerExt Extends %RegisteredObject
{

/// Description:更新预约限额信息
/// Input:   
/// 				DateStr： 日期 HTML
/// 				InString:  类型^状态^明细$C(0)类型^状态^明细……
/// 							   按照总数量(T)^Y/N^限额
/// 							   按照性别(S)^Y/N^限额(男)^限额(女)
/// 							   按照个团(IG)^Y/N^限额(个)^限额(团)
/// 							   按照年龄(A)^Y/N$C(1)DeailID^年龄下限^年龄上限^限额$C(2)DeailID^年龄下限^年龄上限^限额……
/// 							   按照金额(M)^Y/N$C(1)DeailID^金额下限^金额上限^限额$C(2)DeailID^金额下限^金额上限^限额……
/// 				LocID： 科室
/// 				UserID：操作员
/// Return:		0^成功 非0^失败信息
/// Creator:	wangguoying
/// CreateDate:	2021-10-14
/// Debug: w ##class(web.DHCPE.PreManagerExt).Update("2021-10-15","T^Y^40"_$c(0)_"S^Y^9^8"_$c(0)_"IG^N^9^8"_$c(0)_"A^Y"_$c(1)_"^7^80^9"_$c(0)_"M^N"_$c(1),"304","11849")
ClassMethod Update(DateStr, InString, LocID = "", UserID = "")
{
	s ^tmpwgy("Update")=$lb(DateStr, InString, LocID, UserID)
	i LocID = ""
	{
		s LocID = ##class(HS.BL.PECommon).GetDftSessionParam("LOCID")
	}
	i UserID = ""
	{
		s UserID = ##class(HS.BL.PECommon).GetDftSessionParam("USERID")
	}
	s date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s err = ""
	s updDate = +$H
	s updTime = $P($H,",",2)
	s $zt = "UpdateErr"
	TS
	f i=1:1:$L(InString,$C(0))
	{
		s tmp = $P(InString,$C(0),i)
		s type = $p(tmp,"^",1)
		s status = $p(tmp,"^",2)
		s id = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,date,type,""))
		i type = "T"  d TotalHandler
		i type = "S"  d SexHandler
		i type = "IG" d GIHandler
		i (type="A")||(type="M") d AgeMoneyHandler
		i err'="" q  
	}
	i err'="" Tro  q err
	TC
	q 0	
TotalHandler
	s total = $p(tmp,"^",3)
	s properties = "PMELocDR^PMEDate^PMEType^PMEStatus^PMENumTotal^PMEUpdateUserDR^PMEUpdateDate^PMEUpdateTime"
	s valStr = LocID _ "^" _ date _ "^" _ type  _ "^" _ status_ "^" _ total  _ "^" _ UserID _ "^" _ updDate _ "^" _ updTime
	s ret = ##class(User.DHCPEPreManagerExt).SaveData(id,valStr,properties)
	b
	i +ret<0 s err = ret
	q
SexHandler
	s maleNum = $p(tmp,"^",3)
	s femaleNum = $p(tmp,"^",4)
	q:(maleNum="")&&(femaleNum="") 
	s properties = "PMELocDR^PMEDate^PMEType^PMEStatus^PMENumMale^PMENumFemale^PMEUpdateUserDR^PMEUpdateDate^PMEUpdateTime"
	s valStr = LocID _ "^" _ date _ "^" _ type  _ "^" _ status  _ "^" _ maleNum _ "^" _ femaleNum  _ "^" _ UserID _ "^" _ updDate _ "^" _ updTime
	s ret = ##class(User.DHCPEPreManagerExt).SaveData(id,valStr,properties)
	i +ret<0 s err = ret
	q
GIHandler
	s personNum = $p(tmp,"^",3)
	s groupNum = $p(tmp,"^",4)
	q:(personNum="")&&(groupNum="") 
	s properties = "PMELocDR^PMEDate^PMEType^PMEStatus^PMENumPerson^PMENumGroup^PMEUpdateUserDR^PMEUpdateDate^PMEUpdateTime"
	s valStr = LocID _ "^" _ date _ "^" _ type  _ "^" _ status  _ "^" _ personNum _ "^" _ groupNum  _ "^" _ UserID _ "^" _ updDate _ "^" _ updTime
	s ret = ##class(User.DHCPEPreManagerExt).SaveData(id,valStr,properties)
	i +ret<0 s err = ret
	q
AgeMoneyHandler
	s status = $p(status,$C(1),1)
	s range = $P(tmp,$C(1),2)
	q:range=""
	s properties = "PMELocDR^PMEDate^PMEType^PMEStatus^PMEUpdateUserDR^PMEUpdateDate^PMEUpdateTime"
	s valStr = LocID _ "^" _ date _ "^" _ type  _ "^" _ status  _ "^" _ UserID _ "^" _ updDate _ "^" _ updTime
	s ret = ##class(User.DHCPEPreManagerExt).SaveData(id,valStr,properties)
	i +ret<0 s err = ret q
	s:id="" id = +ret
	d UpdateDetail
	q
UpdateDetail
	
	f n=1:1:$L(range,$C(2))
	{
		s rangeInfo = $P(range,$C(2),n)
		s detailId = $P(rangeInfo,"^",1)
		s minV = $P(rangeInfo,"^",2)
		s maxV = $P(rangeInfo,"^",3)
		s num = $P(rangeInfo,"^",4)
		s properties = "PMEDParRef^PMEDMinVal^PMEDMaxVal^PMEDNum^PMEDUpdateUserDR^PMEDUpdateDate^PMEDUpdateTime"
		s valStr = id _ "^" _ minV _ "^" _ maxV _ "^" _ num _ "^" _ UserID _ "^" _ updDate _ "^" _ updTime
		s ret = ##class(User.DHCPEPreManagerDetail).SaveData(detailId,valStr,properties)
		i +ret<0 s err = ret q
	}
	q	
UpdateErr
	s $zt = ""
	i $TL>0 Tro
	q "-100^"_$ZE
}

/// Description:查询某一天的限额信息
/// Input:   
/// 				DateStr： 日期 - - -
/// 				LocID： 科室
/// 				Type： 限额类型  为空时查全部
/// Return:		类型^状态^明细$C(0)类型^状态^明细……
/// 			按照总数量(T)^Y/N^限额
/// 			按照性别(S)^Y/N^限额(男)^限额(女)
/// 			按照个团(IG)^Y/N^限额(个)^限额(团)
/// 			按照年龄(A)^Y/N$C(1)DeailID^年龄下限^年龄上限^限额$C(2)DeailID^年龄下限^年龄上限^限额……
/// 			按照金额(M)^Y/N$C(1)DeailID^金额下限^金额上限^限额$C(2)DeailID^金额下限^金额上限^限额……
/// Creator:	wangguoying
/// CreateDate:	2021-10-14
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetManagerInfo("2021-10-15","304","")
ClassMethod GetManagerInfo(DateStr, LocID, Type = "")
{
	s mTypes = Type
	s:mTypes="" mTypes = "T^S^IG^A^M"
	s date = $ZDH(DateStr,3)
	s ret = ""
	f i=1:1:$L(mTypes,"^")
	{
		s type = $P(mTypes,"^",i)
		s id = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,date,type,""))
		b
		continue:id=""
		s status = $lg(^User.DHCPEPreManagerExtD(id),5)
		//continue:status'="Y"  //未启用的不显示
		i type = "T" d GetTotal
		i type = "S" d GetSex
		i type = "IG" d GetIG
		i (type = "A")||(type = "M") d GetAgeMoney
	} 
	q ret
GetTotal
	s num = $lg(^User.DHCPEPreManagerExtD(id),6)
	i ret'=""  s ret = ret_$C(0)_"T^"_status_"^"_num
	e  s ret = "T^"_status_"^"_num
	q
GetSex
	s maleNum = $lg(^User.DHCPEPreManagerExtD(id),7)
	s femaleNum = $lg(^User.DHCPEPreManagerExtD(id),8)
	i ret'=""  s ret = ret_$C(0)_"S^"_status_"^"_maleNum_"^"_femaleNum
	e  s ret = "S^"_status_"^"_num
	q
GetIG
	s personNum = $lg(^User.DHCPEPreManagerExtD(id),9)
	s groupNum = $lg(^User.DHCPEPreManagerExtD(id),10)
	i ret'=""  s ret = ret_$C(0)_"IG^"_status_"^"_personNum_"^"_groupNum
	e  s ret = "IG^"_status_"^"_num
	q
GetAgeMoney
	s sub = ""
	s list = ""
	f  s sub = $O(^User.DHCPEPreManagerExtD(id,"PMEDetail",sub))  q:sub=""  d
	.s minV = $lg(^User.DHCPEPreManagerExtD(id,"PMEDetail",sub),2)
	.s maxV = $lg(^User.DHCPEPreManagerExtD(id,"PMEDetail",sub),3)
	.s num = $lg(^User.DHCPEPreManagerExtD(id,"PMEDetail",sub),4)
	.s info = id_"||"_sub_"^"_minV_"^"_maxV_"^"_num
	.i list'=""  s list = list _$C(2)_info
	.e  s list = info
	s list = type_"^"_status_$C(1)_list
	i ret'=""  s ret = ret _$C(0)_list
	e  s ret = list
	q
}

/// Description:获取预约总量
/// Input:   
/// 				DateStr： 日期 - - -
/// 				LocID： 科室
/// 				SexDR： 性别
/// 				GIType：个人团体标记  I：个人  G：团体
/// 				AgeRange：	年龄范围  最新值-最大值
/// 				MoneyRange：金额范围  最新值-最大值
/// Return:			已预约总量
/// CreateDate:	2021-10-14
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetPreTotal("2021-10-15","304","")
ClassMethod GetPreNum(DateStr, LocID, SexDR = "", GIType = "", AgeRange = "", MoneyRange = "")
{
	s regNum=0
	// 线上预约且未同步至体检系统的记录
	s regNum = regNum + ..GetOnlyNetPreNum(DateStr, LocID, SexDR, GIType, AgeRange, MoneyRange)	
	
	// 预约未登记的
	s regNum = regNum + ..GetNoRegisterPreNum(DateStr, LocID, SexDR, GIType, AgeRange, MoneyRange)	
	// 登记或到达的
	s regNum = regNum + ..GetRegisterPreNum(DateStr, LocID, SexDR, GIType, AgeRange, MoneyRange)		
	q regNum
}

/// Description:获取线上预约总量 （未同步至体检系统）
/// Input:   
/// 				DateStr： 日期 - - -
/// 				LocID： 科室
/// 				SexDR： 性别
/// 				GIType：个人团体标记  I：个人  G：团体
/// 				AgeRange：	年龄范围  最新值-最大值
/// 				MoneyRange：金额范围  最新值-最大值
/// Return:			线上已预约总量
/// CreateDate:	2021-10-15
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetOnlyNetPreNum("2019-03-20","304")
ClassMethod GetOnlyNetPreNum(DateStr, LocID, SexDR = "", GIType = "", AgeRange = "", MoneyRange = "")
{
	s regNum = 0
	s Date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s netpid = ""
	f  s netpid = $O(^User.DHCPENetPreRecordI("PreDateIndex",Date,netpid))  q:netpid=""  d 
	.s status = $lg(^User.DHCPENetPreRecordD(netpid),7)
	.q:status'=0
	.s netpreiadm = $lg(^User.DHCPENetPreRecordD(netpid),13)
	.q:netpreiadm'=""
	.s locId = $lg(^User.DHCPENetPreRecordD(netpid),17)
	.q:locId'=LocID
	.s matched = ..IsMatchedByNetPreID(netpid,SexDR , GIType, AgeRange, MoneyRange )
	.q:matched'=1
	.s regNum = regNum + 1
	q regNum
}

/// Description:获取前台预约未登记总量 
/// Input:   
/// 				DateStr： 日期 - - -
/// 				LocID： 科室
/// 				SexDR： 性别
/// 				GIType：个人团体标记  I：个人  G：团体
/// 				AgeRange：	年龄范围  最新值-最大值
/// 				MoneyRange：金额范围  最新值-最大值
/// Return:			预约总量
/// CreateDate:	2021-10-15
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetNoRegisterPreNum("2019-03-20","304")
ClassMethod GetNoRegisterPreNum(DateStr, LocID, SexDR = "", GIType = "", AgeRange = "", MoneyRange = "")
{
	s regNum = 0
	s Date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s time=""
	f  s time=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date,time))  q:time=""  d
	.s preIadm=0
	.f  s preIadm=$O(^DHCPEPreIADM(0,"BookDateTime",Date,Date,time,preIadm))  q:preIadm=""  d
	..s status = $P(^DHCPEPreIADM(preIadm),"^",8)
	..q:(status'="PREREG")&&(status'="PREREGED")
	..s locId = $P(^DHCPEPreIADM(preIadm),"^",26)
	..q:locId'=LocID
	..s matched = ..IsMatchedByPreIADM(preIadm,SexDR , GIType, AgeRange, MoneyRange)
	..q:matched'=1
	..s regNum = regNum + 1
	q regNum
}

/// Description:获取前台已登记或到达总量 
/// Input:   
/// 				DateStr： 日期 - - -
/// 				LocID： 科室
/// 				SexDR： 性别
/// 				GIType：个人团体标记  I：个人  G：团体
/// 				AgeRange：	年龄范围  最新值-最大值
/// 				MoneyRange：金额范围  最新值-最大值
/// Return:			预约总量
/// CreateDate:	2021-10-15
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetRegisterPreNum("2019-03-20","304")
ClassMethod GetRegisterPreNum(DateStr, LocID, SexDR = "", GIType = "", AgeRange = "", MoneyRange = "")
{
	s regNum = 0
	s Date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s time=""
	f  s time=$O(^DHCPEIADM(0,"AdmDateTime",Date,time))  q:time=""  d
	.s iadm=0
	.f  s iadm=$O(^DHCPEIADM(0,"AdmDateTime",Date,time,iadm))  q:iadm=""  d
	..s preIadm = $p(^DHCPEIADM(iadm),"^",4)
	..s status = $P(^DHCPEPreIADM(preIadm),"^",8)
	..q:(status'="REGISTERED")&&(status'="ARRIVED")
	..s locId = $P(^DHCPEPreIADM(preIadm),"^",26)
	..q:locId'=LocID
	..s matched = ..IsMatchedByPreIADM(preIadm,SexDR , GIType, AgeRange, MoneyRange)
	..q:matched'=1
	..s regNum = regNum + 1
	q regNum
}

/// Description:判断网上预约记录 是否符合条件
/// Input:
/// 				SexDR： 性别
/// 				GIType：个人团体标记  I：个人  G：团体
/// 				AgeRange：	年龄范围  最新值-最大值
/// 				MoneyRange：金额范围  最新值-最大值
/// Return:  	0：不符合 1：符合
/// Creator:	wangguoying
/// CreateDate:	2021-10-15
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetAavilNum("1||1",+$H,"000000001","",304)
ClassMethod IsMatchedByNetPreID(NetPreID, SexDR = "", GIType = "", AgeRange = "", MoneyRange = "")
{
	q:(SexDR="")&&(GIType="")&&(AgeRange="")&&(MoneyRange="") 1
	s curSex = $lg(^User.DHCPENetPreRecordD(NetPreID),4)
	q:(SexDR'="")&&(SexDR'=curSex) 0
	s curAge = $lg(^User.DHCPENetPreRecordD(NetPreID),5)
	i AgeRange'=""
	{
		s minAge = +$P(AgeRange,"-",1)
		s maxAge = +$P(AgeRange,"-",2)
		q:(curAge<minAge)||(curAge>maxAge) 0
	}
	s pmType = $lg(^User.DHCPENetPreRecordD(NetPreID),22)
	q:(GIType'="")&&(GIType="I")&&(pmType'="I") 0
	q:(GIType'="")&&(GIType="G")&&(pmType="I") 0
	q:MoneyRange="" 1
	s Amount = 0 //项目金额
	//不可拆分套餐
	s entSub = ""
	f  s entSub = $O(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",entSub)) q:(entSub="")  d
	.s break = $lg(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",entSub),4)
	.q:break="Y"  //可拆分的存储 在项目表
	.s ordSetsId = $lg(^User.DHCPENetPreRecordD(NetPreID,"NPRPreOrdSetsRec",entSub),2)
	.s price = ##class(web.DHCPE.Handle.ARCOrdSets).GetPrice(ordSetsId)
	.s Amount = Amount + price
	//单项 或拆分的套餐项目
	s itemSub = ""
	f  s itemSub = $O(^User.DHCPENetPreRecordD(NetPreID,"NPRPreItemRecord",itemSub)) q:(itemSub="")  d
	.s itemId = $lg(^User.DHCPENetPreRecordD(NetPreID,"NPRPreItemRecord",entSub),2)
	.s price = ##class(web.DHCPE.Handle.ARCItmMast).GetItmPrice(itemId,"","","","","","","","","")
	.s Amount = Amount + price
	i MoneyRange'=""
	{
		s minAmt = +$P(MoneyRange,"-",1)
		s maxAmt = +$P(MoneyRange,"-",2)
		q:(Amount<minAmt)||(Amount>maxAmt) 0
	}	
	q 1
}

/// Description:判断PreIADM是否符合条件
/// Input:
/// 				SexDR： 性别
/// 				GIType：个人团体标记  I：个人  G：团体
/// 				AgeRange：	年龄范围  最新值-最大值
/// 				MoneyRange：金额范围  最新值-最大值
/// Return:  	0：不符合 1：符合
/// Creator:	wangguoying
/// CreateDate:	2021-10-15
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetAavilNum("1||1",+$H,"000000001","",304)
ClassMethod IsMatchedByPreIADM(PreIADM, SexDR = "", GIType = "", AgeRange = "", MoneyRange = "")
{
	q:(SexDR="")&&(GIType="")&&(AgeRange="")&&(MoneyRange="") 1
	s pibi = $P(^DHCPEPreIADM(PreIADM),"^",1)
	s curSex = $P(^DHCPEPreIBI(pibi),"^",3)
	q:(SexDR'="")&&(SexDR'=curSex) 0
	s dob = $P(^DHCPEPreIBI(pibi),"^",4)
	s curAge = ##class(web.DHCDocCommon).GetAgeDescNew(dob,"")
	s curAge = $P(curAge,"岁",1)
	s:curAge="" curAge=1
	i AgeRange'=""
	{
		s minAge = +$P(AgeRange,"-",1)
		s maxAge = +$P(AgeRange,"-",2)
		q:(curAge<minAge)||(curAge>maxAge) 0
	}
	s pgid =  $P(^DHCPEPreIADM(PreIADM),"^",2)
	q:(GIType="I")&&(pgid'="") 0
	q:(GIType="G")&&(pgid="") 0
	s Amount = ##class(web.DHCPE.PreItemList).IGetOrdAmount(PreIADM,"PERSON")
	s Amount = $P(Amount,$C(13),$L(Amount,$C(13)))
	i MoneyRange'=""
	{
		s minAmt = +$P(MoneyRange,"-",1)
		s maxAmt = +$P(MoneyRange,"-",2)
		q:(Amount<minAmt)||(Amount>maxAmt) 0
	}	
	q 1
}

/// Description:获取范围区间
/// Input:
/// 						LocID：科室ID
/// 						Date：日期 Logical
/// 						Type：A 年龄，M：金额
/// 							Val : 值
/// Return:  "" 或 限额^最小值-最大值
/// Creator:	wangguoying
/// CreateDate:	2021-10-18
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetDetailRangeNum()
ClassMethod GetDetailRangeNum(LocID, Date, Type, Val)
{
	s parRef = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,Date,Type,""))
	q:parRef="" ""
	s ret = ""
	s sub = ""
	f  s sub = $O(^User.DHCPEPreManagerExtD(parRef,"PMEDetail",sub),-1)  q:(sub="")||(ret'="")  d
	.s minVal = $lg(^User.DHCPEPreManagerExtD(parRef,"PMEDetail",sub),2)
	.s maxVal = $lg(^User.DHCPEPreManagerExtD(parRef,"PMEDetail",sub),3)
	.s num = $lg(^User.DHCPEPreManagerExtD(parRef,"PMEDetail",sub),4)
	.i (Val>=minVal)&&(Val<=maxVal)  d
	..s ret = num_"^"_minVal_"-"_maxVal
	q ret
}

/// Description:获取剩余名额
/// Input:
/// 						DateStr：日期 Html
/// 						LocID：科室ID
/// 						PmType：预约类型	I：个人 G：团体
/// 						RegNo：登记号
/// 						ExtStr: 性别^年龄
/// 						Amount：项目金额
/// Return:  剩余名额  不存在限额时返回9999
/// Creator:	wangguoying
/// CreateDate:	2021-10-15
/// Debug: w ##class(web.DHCPE.PreManagerExt).GetAvailNum("1||1",+$H,"000000001","",304)
ClassMethod GetAvailNum(DateStr, LocID, PmType, RegNo, ExStr, Amount)
{
	s flag = 0 //启用了某个限额  都没有启用时，不可预约
	s num = 9999,totalANum=0,sexANum=0,igANum=0,ageANum=0,moneyANum=0
	s totalTypeStat="N",sexTypeStat="N",igTypeStat="N",ageTypeStat="N",moneyTypeStat="N"
	s Date = ##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s SexDR = $P(ExStr,"^",1)
	s Age = $P(ExStr,"^",2)
	i RegNo'=""
	{
		s pibi = $O(^DHCPEPreIBI(0,"RegNo",RegNo,""))
		s SexDR = $P(^DHCPEPreIBI(pibi),3)
		s dob = $P(^DHCPEPreIBI(pibi),4)
		s Age = ##class(web.DHCDocCommon).GetAgeDescNew(dob,"")
		s Age = $P(Age,"岁",1)
	}
	s existManager = 0 //存在限额
	s totalTypeId = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,Date,"T",""))
	s:totalTypeId'="" totalTypeStat = $lg(^User.DHCPEPreManagerExtD(totalTypeId),5)
	s sexTypeId = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,Date,"S",""))
	s:sexTypeId'="" sexTypeStat = $lg(^User.DHCPEPreManagerExtD(sexTypeId),5)
	s igTypeId = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,Date,"IG",""))
	s:igTypeId'="" igTypeStat = $lg(^User.DHCPEPreManagerExtD(igTypeId),5)
	s ageTypeId = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,Date,"A",""))
	s:ageTypeId'="" ageTypeStat = $lg(^User.DHCPEPreManagerExtD(ageTypeId),5)
	s moneyTypeId = $O(^User.DHCPEPreManagerExtI("LocDateTypeIndex",LocID,Date,"M",""))
	s:moneyTypeId'="" moneyTypeStat = $lg(^User.DHCPEPreManagerExtD(moneyTypeId),5)
	i (totalTypeStat="Y")||(sexTypeStat="Y")||(igTypeStat="Y")||(ageTypeStat="Y")||(moneyTypeStat="Y") s existManager = 1
	q:existManager=0 0 //全部未启用，则可用预约为0
	d GetTotalAvailNum
	d GetSexAvailNum
	d GetIGAvailNum
	d GetAgeAvailNum
	d GetMoneyAvailNum
	i totalANum<num s num = totalANum
	i sexANum<num s num = sexANum
	i ageANum<num s num = ageANum
	i igANum<num s num = igANum
	i moneyANum<num s num = moneyANum
	q num
GetTotalAvailNum	//按照总额限制
	i (totalTypeId="")||(totalTypeStat'="Y") s totalANum = 9999 q	
	s managerNum = $lg(^User.DHCPEPreManagerExtD(totalTypeId),6)
	s preNum = ..GetPreNum(DateStr,LocID)
	s totalANum = managerNum - preNum
	q
GetSexAvailNum	//按照性别限制
	i (sexTypeId="")||(sexTypeStat'="Y") s sexANum = 9999 q	
	s managerNum = 0
	i SexDR = "1" s managerNum = $lg(^User.DHCPEPreManagerExtD(sexTypeId),7)
	e  s managerNum = $lg(^User.DHCPEPreManagerExtD(sexTypeId),8)
	s preNum = ..GetPreNum(DateStr,LocID,SexDR)
	s sexANum = managerNum - preNum
	q
GetIGAvailNum	//按照个团限制	
	i (igTypeId="")||(igTypeStat'="Y") s igANum = 9999 q	
	s managerNum = 0
	i PmType = "I" s managerNum = $lg(^User.DHCPEPreManagerExtD(sexTypeId),9)
	e  s managerNum = $lg(^User.DHCPEPreManagerExtD(sexTypeId),10)
	s preNum = ..GetPreNum(DateStr,LocID,"",PmType)
	s igANum = managerNum - preNum
	q
GetAgeAvailNum	//按照年龄限制  
	i (ageTypeId="")||(ageTypeStat'="Y") s igANum = 9999 q	
	s range = ..GetDetailRangeNum(LocID,Date,"A",Age)
	i range=""  s ageANum = 9999 q //已启用限额，但是不存在指定的范围区间，则不限制名额 
	s managerNum = $P(range,"^",1)
	s range = $P(range,"^",2)
	s preNum = ..GetPreNum(DateStr,LocID,"","",range)
	s ageANum = managerNum - preNum
	q
GetMoneyAvailNum	//按照年龄限制  
	i (moneyTypeId="")||(moneyTypeStat'="Y") s moneyANum = 9999 q	
	s range = ..GetDetailRangeNum(LocID,Date,"M",Amount)
	i range=""  s moneyANum = 9999 q //已启用限额，但是不存在指定的范围区间，则不限制名额 
	s managerNum = $P(range,"^",1)
	s range = $P(range,"^",2)
	s preNum = ..GetPreNum(DateStr,LocID,"","","",range)
	s moneyANum = managerNum - preNum
	q
}

}
