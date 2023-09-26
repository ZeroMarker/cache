Class web.DHCPE.PrintNewDirect Extends %RegisteredObject
{

/// w ##class(web.DHCPE.PrintNewDirect).GetPrintInfo("708^^CRM")
ClassMethod GetPrintInfo(InString, IsPreview As %String = "N")
{
    
    s AdmId=$P(InString,"^",1)
    s AdmType=$P(InString,"^",3)
    s AllItemFlag=$P(InString,"^",4)
    s curLoc=%session.Get("LOGON.CTLOCID")
    s curUser=%session.Get("LOGON.USERID")
    i AdmType'="CRM"
    {
        i AdmType="IADM"
        {
            s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(AdmId)
            //q:(Flag="1")&&(IsPreview="Y") "NoPayed"
            q:(Flag="1") "NoPayed"
            s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
        }else{
            s AdmId=$o(^DHCPEIADM(0,"PAADM",AdmId,0))
            s Flag=##class(web.DHCPE.DHCPEIAdm).HaveNoPayedItem(AdmId)
            //q:(Flag="1")&&(IsPreview="Y") "NoPayed"
            q:(Flag="1") "NoPayed"
            s AdmId=$p($g(^DHCPEIADM(AdmId)),"^",4)
        }
    }
    
    s BaseInfo=..GetPatBaseInfo(AdmId)
    s ItemInfo=..GetItemInfo(AdmId,AllItemFlag)
    s CTNum=$P(ItemInfo,$C(5),2)
    s ItemInfo=$P(ItemInfo,$C(5),1)
    s AddItem=$P(ItemInfo,$C(4),1)
    s ItemInfo=$P(ItemInfo,$C(4),2)
    //s AddItem="1+2+3"
    s BaseInfo=BaseInfo_"^"_AddItem_"^"_CTNum
    
    d ##class(web.DHCPE.AdmRecordManager).Insert(AdmId,"P","PrintDJD",curUser,"")
    
    s iadm=$O(^DHCPEIADM(0,"CRMADM",AdmId,0))
    i iadm'="" d
    .s PAADM=$P(^DHCPEIADM(iadm),"^",1)
    .d:PAADM'="" ..PatItemPrintFlag(PAADM)
    
    q BaseInfo_$C(4)_ItemInfo
}

/// Description: 获取导诊单的表头基本信息
/// Input:       PreIADMID(个人预约ID),NetPreFlag(网上预约ID),NoPrintAmount(是否打印金额)
///              HospID(院区ID),UserID (用户ID)
/// Debug: w ##class(web.DHCPE.PrintNewDirect).GetPatBaseInfo()
ClassMethod GetPatBaseInfo(PreIADMID, NetPreFlag As %String = "0", NoPrintAmount As %String = "N", HospID As %String = "", UserID As %String = "")
{
    ;w ##class(web.DHCPE.PrintNewDirect).GetPatBaseInfo(977)
    s BaseId=$p(^DHCPEPreIADM(PreIADMID),"^",1)  //预登记个人基本信息表
    q:BaseId=""
    s ParInfo=$g(^DHCPEPreIBI(BaseId))
    s recheck=##class(web.DHCPE.PreCommon).GetReCheckFlag(PreIADMID,"PreADM")
    s recheck=recheck+1
    s recheck="第"_recheck_"次"
    s RegNo=$P(ParInfo,"^",1)
    s BarRegNo="*"_RegNo_"*"
    s HPNo=$p($g(^DHCPEPreIADM(PreIADMID)),"^",27) //体检号
    s PatName = $P(ParInfo,"^",2)   // 姓名
    s PatLoc=$p($g(^DHCPEPreIADM(PreIADMID)),"^",26) //就诊科室
    s PatAge=""
    s PatMasID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
    i PatMasID'="" d
    .s PatName=$P(^PAPER(PatMasID,"ALL"),"^",1)
    .;s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatMasID)
    .s PatAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PatMasID,HospID,PatLoc)
    
    s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADMID))  //$P(ParInfo,"^",11)  // 部门
    i Position="" s Position=$P(ParInfo,"^",11) // 部门
    s MobilePhone=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",BaseId)
    ;i MobilePhone="" s MobilePhone=$P(ParInfo,"^",7)
    ;i MobilePhone="" s MobilePhone=$P(ParInfo,"^",6)
    s Sex = $P(ParInfo,"^",3)       // 性别
    i Sex'="" d
    .s Sex=$p($g(^CT("SEX",Sex)),"^",2)
    
    
    s RegDate=""
    s iadm=$O(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
    i iadm'="" d
    .s Status=$p(^DHCPEIADM(iadm),"^",8)
    .i Status="ARRIVED" d
    ..s RegDate=$p(^DHCPEIADM(iadm),"^",5)
    ..i RegDate'="" s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    .e  d
    ..s RegDate=$p(^DHCPEPreIADM(PreIADMID),"^",4)  //+$H
    ..s VIPID="",VIPDesc=""
    ..s VIPID=$p($g(^DHCPEPreIADM(PreIADMID)),"^",18)
    ..;s:(VIPID'="") VIPDesc=$p($G(^DHCPEVIPLevel("VIP",VIPID)),"^",2)
    ..s:(VIPID'="") VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPID)),3)
    ..s:((VIPDesc["VIP")||(VIPDesc["vip"))&&((VIPID'="")) RegDate=$p($g(^DHCPEPreIADM(PreIADMID)),"^",4)
    ..i RegDate'="" s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)

    s GADMDR=$p($g(^DHCPEPreIADM(PreIADMID)),"^",2)
    s GTeam=$p($g(^DHCPEPreIADM(PreIADMID)),"^",3)
    s SortNo=""
    s GTeamDesc=""
    s Company="个人"
    
    i ""'=GADMDR d
    .s GBIDR=$p($g(^DHCPEPreGADM(GADMDR)),"^",1)
    .s Company=$p($g(^DHCPEPreGBI(GBIDR)),"^",2)
    .s GTeamDesc=""
    .i GTeam'="" d
    ..s GTeamDesc=$p(^DHCPEPreGADM(+GTeam,"Team",$p(GTeam,"||",2)),"^",1)
    ..s Char=##class(web.DHCPE.PreIADM).NumToChar($p(GTeam,"||",2))
    ..s SortNo=Char_$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",PreIADMID))
    .s Company=Company
    ;s:NetPreFlag=0 RegDate=$ZD(+$H,3) ;打印当前日期 2014-05-06
    s:NetPreFlag=0 RegDate=##class(websys.Conversions).DateLogicalToHtml(+$H) ;打印当前日期

    s OrderSetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PreIADMID,"N",UserID)
    
    s TotalFee=0
    s TotalFee=##class(web.DHCPE.PreItemList).IGetOrdAmount(PreIADMID,"PERSON")
    s i=$l(TotalFee,$C(13))
    s TotalFee=$p(TotalFee,$C(13),4)
    s TotalFee=$j(TotalFee,3,2)
    s TotalFee="总金额"_TotalFee
    i NoPrintAmount="Y" s TotalFee=""
    
    s DietDesc=""
    s Diet=##class(web.DHCPE.PreIADM).GetDietFlagByID(PreIADMID)
    i Diet=1 s DietDesc="早餐"
    
    s PhotoDesc=""
    s PhotoFlag=##class(web.DHCPE.PreIADM).GetPhotoFlag(PreIADMID)
    if PhotoFlag>0 s PhotoDesc="出片"
    
    s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADMID)
    s VIPType=$P(VIPLevel,"^",2)
    
    s RoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",PreIADMID))
    s:RoomPlace'="" RoomPlace=$P($G(^DHCPECTDataEx("RoomPlace",RoomPlace)),"^",2)
    s:RoomPlace'="" VIPType=VIPType_" "_RoomPlace
    
    
    s SortForNorCus=""
    i VIPType'[("VIP")  d
    .;s TotalFee=""
    .s CurLoc=$P(^DHCPEPreIADM(PreIADMID),"^",26)
    .q:CurLoc'=53
    .s SortForNorCus=..GetPatSortForNorCus(PreIADMID)
    e  d
    .s PhotoDesc=""
    .s DietDesc=""
    
    s Position=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADMID)
    
    s BaseInfo=PatName_"^"_Sex_"^"_PatAge_"^"_MobilePhone_"^"_HPNo_"^"_BarRegNo
    s BaseInfo=BaseInfo_"^"_RegDate_"^"_OrderSetsDesc_"^"_Company_"^"_VIPType
    s BaseInfo=BaseInfo_"^"_Position_"^"_TotalFee_"^"_DietDesc_"^"_PhotoDesc
    s BaseInfo=BaseInfo_"^"_SortForNorCus
    q BaseInfo
}

/// Description: 获取导诊单的相关信息
/// Input:       Id  Type(ID类型)  ExpStrs(自定义扩展信息)  HospID(院区ID)  UserID  (用户ID)
/// Return: 	 Json 对象
/// Debug:		 w ##class(web.DHCPE.PrintNewDirect).GetDJDData("1452","PAADM")
/// 			 w ##class(web.DHCPE.PrintNewDirect).GetDJDData("1452","PAADM","1^",1,152,2)
ClassMethod GetDJDData(Id, Type, ExpStrs As %String = "", UserID As %String = "", LocID As %String = "", HospID As %String = "")
{
	set jsonData=##class(%Library.DynamicObject).%New()
	if (Id="Temporary") {
		set mdata=..OutTemporaryData("Head", UserID, LocID, HospID)
		set idata=..OutTemporaryData("Body", UserID, LocID, HospID)
		set fdata=..OutTemporaryData("Foot", UserID, LocID, HospID)
		
	    set tdata=##class(%Library.DynamicObject).%New()
	    set tdata.head=mdata, tdata.body=idata, tdata.foot=fdata
		do OutErrJsonData(0, "成功", tdata)
	    quit jsonData
	}
	
	if ((Id="")||(Type="")) d OutErrJsonData("-1", "参数为空！", "") q jsonData
	
	s PreIADM=""
	if (Type="PreIADM") {
		set PreIADM=Id
	} elseif (Type="IADM") {
		set PreIADM=$p($g(^DHCPEIADM(Id)),"^",4)
	} elseif (Type="PAADM") {
		set IADM=$o(^DHCPEIADM(0,"PAADM",Id,0))
		if IADM="" d OutErrJsonData("-1", "无效参数！", "") q jsonData
		set PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	} elseif (Type="NetPreID") {  // 网上预约ID
		set PreIADM=""
	}
	if PreIADM="" d OutErrJsonData("-1", "无效参数！", "") q jsonData
	
    set BaseId=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)  //预登记个人基本信息表
    if BaseId="" d OutErrJsonData("-1", "无效预约记录！", "") q jsonData
	
	set IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
    if IADM="" d OutErrJsonData("-1", "该记录未登记！", "") q jsonData
	set PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
    
	set BaseInfo=$g(^DHCPEPreIBI(BaseId))
	set RegNo=$p(BaseInfo,"^",1)  // 登记号 不带*
	set BarRegNo="*"_RegNo_"*"  // 登记号 带*
	set PatMasID=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	if PatMasID="" d OutErrJsonData("-1", "无效病人ID！", "") q jsonData
	
    set PrintAllFlag=$case($p(ExpStrs,"^",1),"0":"N",:"Y")  // 是否打印打印过的项目
    
    /******************** 获取信息 ********************/
    do GetPersonInfo
    
    // 指引单表头
    set mdata=##class(%Library.DynamicObject).%New()
	do SetHeaderInfo
	
    // 指引单项目
    set idata=##class(%Library.DynamicArray).%New()
	do SetPatItemInfo
	
    // 指引单页脚
	set fdata=##class(%Library.DynamicObject).%New()
	do SetFooterInfo
	
    set tdata=##class(%Library.DynamicObject).%New()
    set tdata.head=mdata, tdata.body=idata, tdata.foot=fdata
	do OutErrJsonData(0, "成功", tdata)
    quit jsonData
    
GetPersonInfo
	// 优先取体检表中数据
	s PatName=$p(BaseInfo,"^",2)  // 姓名
	s:PatName="" PatName=$p($g(^PAPER(PatMasID,"ALL")),"^",1)  // 姓名
	s PatSex=$p(BaseInfo,"^",3)  // 性别
	s:PatSex'="" PatSex=$p($g(^CT("SEX",PatSex)),"^",2)
	
	s PatDOB=$p(BaseInfo,"^",4)  // 出生日期
	s:PatDOB'="" PatDOB=##class(websys.Conversions).DateLogicalToHtml(PatDOB)
	s PatAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PatMasID,HospID,LocID)  // 年龄
	
	s PatCardType=$p($g(^PAPER(PatMasID,"PAT",3)),"^",7)  // 证件类型
	s:PatCardType'="" PatCardType=$p($g(^PAC("CARD",PatCardType)),"^",2)
	s PatIDCard=$p(BaseInfo,"^",9)  // 证件号
	s:PatIDCard="" PatIDCard=$p($g(^PAPER(PatMasID,"PAT",3)),"^",6)
	
	s PatTel=$p(BaseInfo,"^",8)  // 联系电话
	s:PatTel="" PatTel=$p(BaseInfo,"^",6)
	s:PatTel="" PatTel=$p(BaseInfo,"^",7)
	s PatMar=$p(BaseInfo,"^",17)  // 婚姻状况
	s:PatMar="" PatMar=$p($g(^PAPER(PatMasID,"PER",2)),"^",3)
	s:PatMar'="" PatMar=$p($G(^CT("MAR",PatMar)),"^",2)
	
	s Position=$g(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))  // 部门
	s:Position="" Position=$p(BaseInfo,"^",11)
	s PECheck=##class(web.DHCPE.PreCommon).GetReCheckFlag(PreIADM,"PreADM")  // 体检次数
	s PECheck="第"_(PECheck+1)_"次"
    	
	s VIPLevel=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)  // VIP等级
	//s:VIPLevel'="" VIPLevel=$p($g(^DHCPEVIPLevel("VIP",VIPLevel)),"^",2)
	s:VIPLevel'="" VIPLevel=$lg($g(^CT.PE.VIPLevelD(VIPLevel)),3)
	s HPNo=$p($g(^DHCPEPreIADM(PreIADM)),"^",27)  // 体检号 不带*
	s BarHPNo="*"_HPNo_"*"  // 体检号 带*
	
	s PreGADM=$p($g(^DHCPEPreIADM(PreIADM)),"^",2)
	s PreGTeam=$p($g(^DHCPEPreIADM(PreIADM)),"^",3)
	s Company="",TeamDesc="",SortNo=""
	i PreGADM'="" d
    .s PreGBI=$p($g(^DHCPEPreGADM(PreGADM)),"^",1)
    .s Company=$p($g(^DHCPEPreGBI(PreGBI)),"^",2)  // 单位
    .s GTeamDesc=$p($g(^DHCPEPreGADM(+PreGTeam,"Team",$p(PreGTeam,"||",2))),"^",1)  // 分组
    .s Char=##class(web.DHCPE.PreIADM).NumToChar($p(PreGTeam,"||",2))
    .s SortNo=Char_$g(^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",PreIADM))  // 分组中顺序
    
    s OrderSetsDesc=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(PreIADM,"N",UserID)  // 套餐
    
	s TotalFee=##class(web.DHCPE.PreItemList).IGetOrdAmount(PreIADM,"PERSON")  // 金额
	s TotalFee=$p(TotalFee,$C(13),4)
	s TotalFee=$fn(TotalFee,"N",2)
	
	s Diet=##class(web.DHCPE.PreIADM).GetDietFlagByID(PreIADM)
	s:Diet=1 Diet="早餐"
	
	s RisFlag=""  // 项目是否有片子 站点项目组合中维护的信息  // ##class(web.DHCPE.PreIADM).GetPhotoFlag(PreIADM)
	
	s QueueNo=..GetPatSortForNorCus(PreIADM)  // 排队序号 目前无法使用

    s RoomPlace=$g(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",PreIADM))  // 诊区
    s:RoomPlace'="" RoomPlace=$p($g(^DHCPECTDataEx("RoomPlace",RoomPlace)),"^",2)
    
    s RegDate=$p(^DHCPEIADM(IADM),"^",5)  // 登记或到达日期
    s:RegDate'="" RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    
    s PrtDate=##class(websys.Conversions).DateLogicalToHtml(+$H)  // 打印当前日期
    
    s PhotoBase64=##class(web.DHCPE.PreIBIUpdate).GetPhoto(PatMasID, "PAPMIID")  // 照片 data:image/png;base64,
    s:PhotoBase64="" PhotoBase64="Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAA////AA=="
    
	s DJDInfo=$g(^DHCPESetting("DHCPE","DJDInfo",LocID))
	s DJDTitel=$p(DJDInfo,"^",1)  // 导检单抬头
	s DJDNotice=$p(DJDInfo,"^",2)  // 注意事项
	s:DJDNotice="" DJDNotice="★抽血超声项目请空腹，抽血后请按压5分钟"_
					 "<br>★孕妇请勿做X线检查，妇科B超请先憋尿，未婚女性勿做妇科检查"_
					 "<br>★如自愿检查乙肝检查项目，请签字确认，放弃项目请签字确认"_
					 "<br>★体检完成，请把本指引单交回前台，以免影响您的体检报告的发放"
	s DJDRemark=$p(DJDInfo,"^",3)  // 备注内容
	s:DJDRemark="" DJDRemark="Qk06AAAAAAAAADYAAAAoAAAAAQAAAAEAAAABABgAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAA////AA=="
	q
	
SetHeaderInfo
	// 指引单表头
	s mdata.RegNo=RegNo, mdata.BarRegNo=BarRegNo, mdata.PatName=PatName, mdata.PatSex=PatSex, mdata.PatDOB=PatDOB
	s mdata.PatAge=PatAge, mdata.PatCardType=PatCardType, mdata.PatIDCard=PatIDCard, mdata.PatTel=PatTel, mdata.PatMar=PatMar
	s mdata.Position=Position, mdata.PECheck=PECheck, mdata.VIPLevel=VIPLevel, mdata.HPNo=HPNo, mdata.BarHPNo=BarHPNo
	s mdata.Company=Company, mdata.TeamDesc=TeamDesc, mdata.SortNo=SortNo, mdata.OrderSetsDesc=OrderSetsDesc, mdata.TotalFee=TotalFee
	s mdata.Diet=Diet, mdata.RisFlag=RisFlag, mdata.QueueNo=QueueNo, mdata.RoomPlace=RoomPlace, mdata.RegDate=RegDate
	s mdata.PrtDate=PrtDate, mdata.PhotoBase64=PhotoBase64
	s mdata.DJDTitel=DJDTitel, mdata.DJDNotice=DJDNotice, mdata.DJDRemark=DJDRemark
	q
	
SetPatItemInfo
	// // 指引单类别 项目
	s:LocID="" LocID=$p($g(^DHCPEPreIADM(PreIADM)),"^",26)
	s:LocID="" LocID=%session.Get("LOGON.CTLOCID")
	
	//s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))
	
	k tempDHCPESpecNum(PreIADM)
	k tempDHCPEPrintDirect(PreIADM)
	
	s ItemSub=0
	f {
		s ItemSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub))
		q:ItemSub=""
		s PreIOI=PreIADM_"||"_ItemSub
		s Stat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
		continue:Stat'="1"
		
		// 判断是否打印过的项目
		continue:((PrintAllFlag'="Y")&&(+$d(^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreIOI))'=0))
		s PrintRecord=+$o(^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreIOI,""),-1)+1
		s ^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreIOI,PrintRecord)=$H_"^"_UserID
		
		s ArcimID=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",1)
		;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,""))
		
		s CrmOrdID=$o(^DHCPECRMO(0,"CRMORI",PreIOI,0))
		continue:CrmOrdID=""
		s OrderItemID=$p($g(^DHCPECRMO(CrmOrdID)),"^",1)
		continue:OrderItemID=""
		s ItemStatDR=$p($g(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),1)),"^",13)  // 医嘱状态
		s:ItemStatDR=6 AppFlag=1
		;continue:((ItemStatDR=6)&&($g(^DHCPESetting("DHCPE","IsPrintEItem"))'="Y"))  //根据配置是否打印已执行医嘱
		continue:((ItemStatDR=6)&&($g(^DHCPESetting("DHCPE","IsPrintEItem",LocID))'="Y"))  //根据配置是否打印已执行医嘱
		
    	s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
    	s STID=$p(StatOrderDR,"||",1)      //站点ID
		continue:((STID="")||(STID=OtherStation))
		
    	s PatItemID=""
		s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
		s:StatOrdSetID'="" PatItemID=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),27)  // 项目导诊单类别
		
		s:PatItemID="" PatItemID="z"  // 没有分类
		
		s SpecNo=$p($g(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),3)),"^",20)  // 标本号
		// 根据标本号判断 采血数量
		if ((SpecNo'="")&&('$d(tempDHCPESpecNum(PreIADM,PatItemID,"Spec",SpecNo)))) {
			s tempDHCPESpecNum(PreIADM,PatItemID,"Spec",SpecNo)=""
			s SpecName=##class(web.DHCPE.BarPrint).GetSpecName(OrderItemID)
			i SpecName[("血") s tempDHCPESpecNum(PreIADM,PatItemID,"Blood")=+$g(tempDHCPESpecNum(PreIADM,PatItemID,"Blood"))+1
			e  s tempDHCPESpecNum(PreIADM,PatItemID,"Other")=+$g(tempDHCPESpecNum(PreIADM,PatItemID,"Other"))+1
		} else {
			s SpecNo="JC"  // 用于相同标本号的检验项目放一起，检查项目不变
		}
		s PatItemSort="z"  // 用于排序
		i PatItemID'="" {
			;s PatItemSort=$P($G(^DHCPECTDataEx("PatItem",PatItemID)),"^",2)
			s PatItemSort=$lg($g(^CF.PE.UsherItemCatD(PatItemID)),4)  // 导诊单分类顺序
		}
		s:PatItemSort="" PatItemSort="z"
		
		s ItemSort="",IsPrint="",PrintName=""
		i StatOrdSetID'="" {
			s ItemSort=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),28)  // 导诊单上项目顺序
			s IsPrint=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),29)   // 导诊单上是否打印
			s PrintName=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),30) // 导诊单上打印项目名称
		}
		s:IsPrint="" IsPrint="Y"
		continue:IsPrint'="Y"
		s:ItemSort="" ItemSort="z"
		s:PrintName="" PrintName=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID,"A",LocID)
		i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OrderItemID)) s PrintName=PrintName_"(已谢绝)"
		;s:IsPrint="N" PrintName=""
		
		s ItemNum=+$g(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreIOI))  // 项目数量
		s tempDHCPESpecNum(PreIADM,PatItemID,"ARCIM",ArcimID)=+$g(tempDHCPESpecNum(PreIADM,PatItemID,"ARCIM",ArcimID))+ItemNum
		s tempDHCPEPrintDirect(PreIADM,PatItemSort,PatItemID,ItemSort,SpecNo,ArcimID)=PrintName
	}
	q:'$d(tempDHCPEPrintDirect(PreIADM))
    	
	s tSort=""
	f  s tSort=$o(tempDHCPEPrintDirect(PreIADM,tSort)) q:tSort=""  d
	.s tId=""
	.f  s tId=$o(tempDHCPEPrintDirect(PreIADM,tSort,tId)) q:tId=""  d
	..s tName=$lg($g(^CF.PE.UsherItemCatD(tId)),3)      //导诊单分类描述
	..i tName="" s tName="没有分类"
	..i +$g(tempDHCPESpecNum(PreIADM,tId,"Blood"))>0 d
	...s tName=tName_"("_+$g(tempDHCPESpecNum(PreIADM,tId,"Blood"))_")"
	
	..;s PatItemNotice=$g(^DHCPECTDataEx("PatItem",tId,"Place",LocID))
	..;s DocFlag=$p($g(^DHCPECTDataEx("PatItem",tId)),"^",6)
	..;s PatSignName=$p($g(^DHCPECTDataEx("PatItem",tId)),"^",7)
	..s tNotice=$lg($g(^CF.PE.UsherItemCatD(tId)),5)  // 注意事项（导诊单）
	..s DocFlag=$lg($g(^CF.PE.UsherItemCatD(tId)),6)  // 医生签名（导诊单）
	..s PatSign=$lg($g(^CF.PE.UsherItemCatD(tId)),7)  // 患者签名（导诊单）
	
	..s pdObj=##class(%Library.DynamicObject).%New()
	..s pdObj.TypeName=tName
	..s pdObj.TypeNotice=tNotice
	..s pdObj.DocFlag=DocFlag
	..s pdObj.PatSign=PatSign
	..s pdObj.SpecList=##class(%Library.DynamicArray).%New()
	
	..s itemNum=0,specNum=0
	..s itemSort=""
	..f  s itemSort=$o(tempDHCPEPrintDirect(PreIADM,tSort,tId,itemSort)) q:itemSort=""  d
	...s sNo=""
	...f  s sNo=$o(tempDHCPEPrintDirect(PreIADM,tSort,tId,itemSort,sNo)) q:sNo=""  d
	....s specObj=##class(%Library.DynamicObject).%New()
	....s specObj.SpecNo=sNo
	....s specObj.ItemList=##class(%Library.DynamicArray).%New()
	....s specNum=specNum+1
	
	....s specItemNum=0
	....s itemId=""
	....f  s itemId=$o(tempDHCPEPrintDirect(PreIADM,tSort,tId,itemSort,sNo,itemId)) q:itemId=""  d
	.....s itemName=$g(tempDHCPEPrintDirect(PreIADM,tSort,tId,itemSort,sNo,itemId))
	.....s itemQty=+$g(tempDHCPESpecNum(PreIADM,tId,"ARCIM",itemId))
	.....s:itemQty>1 itemName=itemName_"*"_itemQty
	
	.....s itmObj=##class(%Library.DynamicObject).%New()
	.....s itmObj.ItemName=itemName
	.....d specObj.ItemList.%Push(itmObj)
	.....s specItemNum=specItemNum+1    // 标本中项目数量
	.....s itemNum=itemNum+1  // 总项目数量
	
	....s specObj.SpecItemNum=specItemNum
	....d pdObj.SpecList.%Push(specObj)
	..s pdObj.SpecNum=specNum
	..s pdObj.ItemNum=itemNum
	..d idata.%Push(pdObj)
	q

SetFooterInfo
    /// 页脚信息
	s fdata.PageNumber="第1页/共1页"
	s fdata.FootStr="祝您身体健康！"
	s fdata.PrtDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s fdata.PatName=PatName
	s fdata.PatSex=PatSex
	s fdata.PatAge=PatAge
	s fdata.PatIDCard=PatIDCard
	s fdata.PatTel=PatTel
	s fdata.Position=Position
	s fdata.VIPLevel=VIPLevel
	s fdata.HPNo=HPNo
	s fdata.BarHPNo=BarHPNo
	s fdata.Company=Company
	
	s fdata.BarCode="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"
	s fdata.Remark="★扫描左侧二维码，关注公众号，可线上预约或查看报告"
    q
	
OutErrJsonData(code, msg, data)
	s jsonData.code=code
	s jsonData.msg=msg
	s jsonData.data=data
	q
}

/// 获取指引单临时数据 用于显示调试等
/// w ##class(web.DHCPE.PrintNewDirect).OutTemporaryData("Head").%ToJSON()
/// w ##class(web.DHCPE.PrintNewDirect).OutTemporaryData("Body").%ToJSON()
ClassMethod OutTemporaryData(Type, UserID As %String = "", LocID As %String = "", HospID As %String = "") As %Library.DynamicObject
{
	s:LocID="" LocID=%session.Get("LOGON.CTLOCID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	s tempdata=##class(%Library.DynamicObject).%New()
	if Type="Head" {
		s tempdata.RegNo="0000002333"
		s tempdata.BarRegNo="*"_"0000002333"_"*"
		s tempdata.PatName="临时预览"
		s tempdata.PatSex="男"
		s tempdata.PatDOB=##class(websys.Conversions).DateLogicalToHtml(+$h-(20*365))
		s tempdata.PatAge="20岁"
		s tempdata.PatCardType="居民身份证"
		s tempdata.PatIDCard="123456202001011234"
		s tempdata.PatTel="18888888888"
		s tempdata.PatMar="未婚"
		s tempdata.Position="部门"
		s tempdata.PECheck="第"_3_"次"
		s tempdata.VIPLevel="健康体检"
		s tempdata.HPNo="PE"_"0000002333"
		s tempdata.BarHPNo="*"_"PE"_"0000002333"_"*"
		s tempdata.Company="这仅仅是一个单位名称（临时预览用）"
		s tempdata.TeamDesc="分组名称"
		s tempdata.SortNo=""
		s tempdata.OrderSetsDesc="这是一个套餐名称（临时预览用）"
		s tempdata.TotalFee="2333.66"
		s tempdata.Diet="早餐"
		s tempdata.RisFlag=""
		s tempdata.QueueNo=""
		s tempdata.RoomPlace="VVIP区"
		s tempdata.RegDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
		s tempdata.PrtDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
		s tempdata.PhotoBase64="iVBORw0KGgoAAAANSUhEUgAAAGYAAAB+CAMAAADhhJSmAAAARVBMVEX/wzT/0WP/8c3/6LH/xTn//PP//vr/////x0D/ykv/89f/zlb/35D/2Hn/9+H/5af/24X/7cL///7/67v/+uv/1Gz/4pt85pfcAAACO0lEQVR42u3ZzdKdIAwG4IDAC/gP6v1fajedLjpTz0mCfIv63EAGDAETer1er9fr9fovxXO7hlrrsE4mPhrH4rdiN/dUlJRSwR/H2X4Z174E/KVMyZzn6BrF2PaAG8FOibTStOfF417ZDTWIlHGnzmMkrXEIuGdn0oprwGfZkIpZ8JWyOpKbA76VkzxKwfcWaRwTwLFEkogHeLIjgQFcK/GNBVxlJLYdfJa4UoCAIaYJEgMxWUh4RywxQOQkFgOZi1g2yOzEckFm4ZYAmYNYKmQCtwbIHH3C2D6btvZJgblPQo9djmdwXYpNJp6EPhfBAYmJmKr0HuiRA4mYxh6nk0yf23OHTCUWDxlPHBFSiXc6pcafCvPzm+Yg5bpk2kEsuc9zcAB6lOgZIiURS/SQqF1+o3wiLgu2MhNbZMcJG0ls1oPBGpLKjCgkt+n+1dvn9U4aK6OPopCC/EnTvrj5SDrJ4wsbaU2MZFZwmVHKFMYg2bL2Z3SgNlZ1J1Wf1TkSg3Q9NVI7UdWj0f9UeWppVoXRl4JCDIoUSNTQrrs09W+CiRryyi6NvlE0Uytxwb8FQ204izuhzXpSxgdDJK14BXy0KBc0rp7zgHbEMG6DXY4AgXLkYRrpMzMc0FrWD5HmjCZKTTe7ZdFMuNy/qn1ASzYqXsvaYfgKBvGQesIDqqSFqh+AuAWPOKK4uS2fg7oDD/GO22/Sf50dj6nMObd+1048yDDmdQoT99No52AZD7LMprN6tB/AIBq1/AIKHpzqlCANIQAAAABJRU5ErkJggg=="
		s $p(^DHCPESetting("DHCPE","DJDInfo",LocID),"^",1)=""
        s HospDesc="东华标准版数字化医院"_"<br>"_$p($g(^CTLOC(LocID)),"^",2)
        s:HospID'="" HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)_"<br>"_$p($g(^CTLOC(LocID)),"^",2)
		s:$p($g(^DHCPESetting("DHCPE","DJDInfo",LocID)),"^",1)="" $p(^DHCPESetting("DHCPE","DJDInfo",LocID),"^",1)=HospDesc
		s tempdata.DJDTitel=$p($g(^DHCPESetting("DHCPE","DJDInfo",LocID)),"^",1)
		s tempdata.DJDNotice="★抽血超声项目请空腹，抽血后请按压5分钟"_
						 "<br>★孕妇请勿做X线检查，妇科B超请先憋尿，未婚女性勿做妇科检查"_
						 "<br>★请认真核对检查项目是否一致"_
						 "<br>★体检完成后，请将指引单交予前台工作人员"
		s tempdata.DJDRemark="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"
	} elseif Type="Body" {
		s tempdata=##class(%Library.DynamicArray).%New()
    	s tmpStation=$lb("空腹抽血","彩色B超","一般检查","内科","外科","眼科","耳鼻喉科","口腔科","其他化验","放射科","心电图","病理检查","呼气试验","骨密度")
    	s tmpStation(1)=$lb("抽血前请空腹，抽血后请按压5分钟","Y","N")
    	s tmpStation(1,"0000232323")=$lb("血常规","空腹血糖")
    	s tmpStation(1,"0000232324")=$lb("肝功能","肾功能","血脂八项","心肌酶谱六项")
    	s tmpStation(1,"0000232325")=$lb("电解质七项")
    	s tmpStation(1,"0000232326")=$lb("乙肝两对半(定性)")
    	s tmpStation(1,"0000232327")=$lb("人免疫缺陷病毒抗体测定")
    	
    	s tmpStation(2)=$lb("体检中心二楼超声室","Y","N")
    	s tmpStation(2,"z")=$lb("腹部超声","甲状腺及颈部淋巴结超声","双肾输尿管膀胱前列腺超声","心脏彩超","颈部动脉超声")
    	
    	s tmpStation(3)=$lb("身高:&ensp;&ensp;&ensp;cm,&ensp;体重:&ensp;&ensp;&ensp;kg,&ensp;血压:&ensp;&ensp;&ensp;/&ensp;&ensp;&ensp;mmHg<br>脉搏:&ensp;&ensp;&ensp;,&ensp;心率&ensp;&ensp;&ensp;","N","Y")
    	s tmpStation(3,"z")=$lb("一般检查")
    	
    	s tmpStation(4)=$lb("","N","Y")
    	s tmpStation(4,"z")=$lb("内科检查")
    	
    	s tmpStation(5)=$lb("","N","Y")
    	s tmpStation(5,"z")=$lb("外科检查")
    	
    	s tmpStation(6)=$lb("裸眼视力:L&ensp;&ensp;&ensp;/R&ensp;&ensp;&ensp;,&ensp;矫正视力:L&ensp;&ensp;&ensp;/R&ensp;&ensp;&ensp;","N","Y")
    	s tmpStation(6,"z")=$lb("眼科检查")
    	
    	s tmpStation(7)=$lb("","N","Y")
    	s tmpStation(7,"z")=$lb("耳鼻喉科检查")
    	
    	s tmpStation(8)=$lb("","N","Y")
    	s tmpStation(8,"z")=$lb("口腔科检查")
    	
    	s tmpStation(9)=$lb("","Y","Y")
    	s tmpStation(9,"0000232328")=$lb("尿沉渣分析")
    	s tmpStation(9,"0000232329")=$lb("粪便常规隐血试验")
    	
    	s tmpStation(10)=$lb("","Y","Y")
    	s tmpStation(10,"z")=$lb("胸部正位","颈椎正侧位","腰椎正侧位(站立位)")
    	
    	s tmpStation(11)=$lb("","Y","N")
    	s tmpStation(11,"z")=$lb("十二导心电图检查","动态心电图")
    	
    	s tmpStation(12)=$lb("病理就到病理科","Y","N")
    	s tmpStation(12,"z")=$lb("活体组织病理诊断","穿刺细胞学病理诊断","超薄细胞检测(TCT)","分子生物学病理诊断(探针)CS1230")
    	
    	s tmpStation(13)=$lb("","Y","N")
    	s tmpStation(13,"z")=$lb("C14呼气试验")
    	
    	s tmpStation(14)=$lb("","Y","N")
    	s tmpStation(14,"z")=$lb("骨密度")
    	
    	s tNum=$ll(tmpStation)
    	f i=1:1:tNum d
    	.s tObj=##class(%Library.DynamicObject).%New()
    	.s tObj.TypeName=$lg(tmpStation,i)
    	.s tObj.TypeNotice=$lg(tmpStation(i),1)
    	.s tObj.DocFlag=$lg(tmpStation(i),2)
    	.s tObj.PatSign=$lg(tmpStation(i),3)
    	.s tObj.SpecList=##class(%Library.DynamicArray).%New()
    	
    	.s specNum=0,itemNum=0
    	.s spNo=""
    	.f  s spNo=$o(tmpStation(i,spNo)) q:spNo=""  d
    	..s iNum=$ll(tmpStation(i,spNo))
    	..s spObj=##class(%Library.DynamicObject).%New()
    	..s spObj.SpecNo=spNo
    	..s spObj.SpecItemNum=iNum
    	..s spObj.ItemList=##class(%Library.DynamicArray).%New()
    	
    	..f j=1:1:iNum d
    	...s itemName=$lg(tmpStation(i,spNo),j)
    	...s iObj=##class(%Library.DynamicObject).%New()
    	...s iObj.ItemName=itemName
    	...d spObj.ItemList.%Push(iObj)
    	..
    	..d tObj.SpecList.%Push(spObj)
    	..s itemNum=itemNum+iNum
    	..s specNum=specNum+1
    	.
    	.s tObj.SpecNum=specNum
    	.s tObj.ItemNum=itemNum
    	.d tempdata.%Push(tObj)
    	
	} elseif Type="Foot" {
		s tempdata.PageNumber="第1页/共1页"
		s tempdata.FootStr="祝您身体健康！"
		s tempdata.PrtDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
		
		s tempdata.PatName="临时预览"
		s tempdata.PatSex="男"
		s tempdata.PatAge="20岁"
		s tempdata.PatIDCard="123456202001011234"
		s tempdata.PatTel="18888888888"
		s tempdata.Position="部门"
		s tempdata.VIPLevel="健康体检"
		s tempdata.HPNo="PE"_"0000002333"
		s tempdata.BarHPNo="*"_"PE"_"0000002333"_"*"
		s tempdata.Company="这仅仅是一个单位名称（临时预览用）"
		
		s tempdata.BarCode="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"
		s tempdata.Remark="★扫描左侧二维码，关注公众号，可线上预约或查看报告"
	}
	q tempdata
}

ClassMethod GetPayedAmt(PreIADM)
{
    s TotalAmt=0
    s PAID=0
    f  s PAID=$O(^DHCPEPreA(0,"CRMADM","I",PreIADM,PAID)) q:PAID=""  d
    .s Status=$P(^DHCPEPreA(PAID),"^",21)
    .q:Status="NU"
    .s Status=$P(^DHCPEPreA(PAID),"^",14)
    .q:Status'="UNCHARGED"
    .s OneAmt=$P(^DHCPEPreA(PAID),"^",9)
    .s TotalAmt=TotalAmt+OneAmt
    q TotalAmt
}

/// w ##(web.DHCPE.PrintNewDirect).GetPatSortForNorCus()
ClassMethod GetPatSortForNorCus(PreIADM)
{
    
    ;获取一个普通客户的排队序号，打印指引单的时候存在TCD25754||1和心脏彩超33055||1
    s Sort=""
    i ""'=$G(^DHCPEPatSortForNorCus(PreIADM,"Sort",+$h)) q $G(^DHCPEPatSortForNorCus(PreIADM,"Sort",+$h))
    
   s LocID=$p(^DHCPEPreIADM(PreIADM),"^",26)
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))

    s NeedSortArcIdStr="^"_"25754||1"_"^"_"33055||1"_"^"
    s Flag=0
    s ItemSub=0
    f  s ItemSub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
    .s Stat=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
    .q:Stat'="1"
    .s ArcimID=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",1)
	.q:ArcimID=""
    .s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,""))
    .q:(STID="")||(STID=OtherStation)
    .s ArcimID="^"_ArcimID_"^"
    .s:NeedSortArcIdStr[ArcimID Flag=1
    .q
    i Flag=1 d
    .s Sort=$I(^DHCPEPatSortForNorCus("PatSortForNorCus",+$h))+40
    .s ^DHCPEPatSortForNorCus(PreIADM,"Sort",+$h)=Sort
    q Sort
}

/// Description: 获取导诊单打印的项目信息
/// Input:       PreIADM(个人预约ID)
/// Debug: w ##class(web.DHCPE.PrintNewDirect).GetItemInfo("619")
ClassMethod GetItemInfo(PreIADM, PrintAllFlag As %Library.String = "")
{

    s ArcimIDStr="^"_"22172||1^33774||1"_"^"
    s NoPhotoArcimID="33649||1"
    s CTStation="13"
    s RaxStation="14"
    s NJStation="15"
    s CTNum=0
    s RaxNum=0
    s NJNum=0
    s CTAppNum=0
    s RaxAppNum=0
    s NJAppNum=0
    s IBInfoId=$p(^DHCPEPreIADM(PreIADM),"^",1)  //预登记个人基本信息表
    q:IBInfoId=""
    s IBInfo=$g(^DHCPEPreIBI(IBInfoId))
    s IBSex = $P(IBInfo,"^",3)      // 性别
    i IBSex'="" d
    .s IBSex=$p($g(^CT("SEX",IBSex)),"^",2)
    s curUser=%session.Get("LOGON.USERID")
    s BloodSpecNum=0
    s OtherSpecNum=0
    s BloodPatItemID=""
    s OtherPatItemID=""
    s AddItem=""
    s Job=$J
    k ^TempDHCPEPrintDirect(Job)
    k ^TempDHCPEPrintDirectSpecNum(Job)
    k ^TempDHCPEPrintDirectItemNum("PrintNewDirect","Qty",Job)
    s LocID=$p(^DHCPEPreIADM(PreIADM),"^",26)
	//s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))	

   
    s LocID=$p(^DHCPEPreIADM(PreIADM),"^",26)
    s NoPhotoFlag=0
    s ItemSub=0
    f  s ItemSub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
    .s Stat=$P($G(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
    .q:Stat'="1"
    .s PatItemHadPrint=+$D(^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreIADM_"||"_ItemSub))
    .q:(PatItemHadPrint'=0)&&(PrintAllFlag'="1")
    .s PrintRecord=+$O(^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreIADM_"||"_ItemSub,""),-1)+1
    .s ^DHCPEDataEx("OEOrder","PatTtemHadPrint",PreIADM_"||"_ItemSub,PrintRecord)=$H_"^"_curUser
    .s ItemNum=+$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PreIADM_"||"_ItemSub))
    .s ArcimID=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",1)
    .S ^TempDHCPEPrintDirectItemNum("PrintNewDirect","Qty",Job,PreIADM,ArcimID)=$g(^TempDHCPEPrintDirectItemNum("PrintNewDirect","Qty",Job,PreIADM,ArcimID))+ItemNum
    .i ArcimID=NoPhotoArcimID s NoPhotoFlag="1"
    .;s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,""))
    .s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ArcimID,LocID)
    .s STID=$p(StatOrderDR,"||",1)      //站点ID
    .q:(STID="")||(STID=OtherStation)
    .i STID=CTStation d
    ..s CTNum=CTNum+1
    .i STID=RaxStation d
    ..s RaxNum=RaxNum+1
    .i STID=NJStation d
    ..s NJNum=NJNum+1
    .;PatItemID^ItemSort^ItemIsPrint^ItemPrintName
    .;s PatItemInfo=$G(^DHCPECTDataEx("PatItemSort",ArcimID))
    .;s PatItemID=$P(PatItemInfo,"^",1) 
    .//导诊单分类ID
    .s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StatOrderDR,""))
    .s PatItemID=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),27)
    .
    .s CrmOrdID=$O(^DHCPECRMO(0,"CRMORI",PreIADM_"||"_ItemSub,0))
    .s AppFlag=0
    .s ItemStatFlag=0
    .i CrmOrdID'="" d
    ..s OrderItemID=$P(^DHCPECRMO(CrmOrdID),"^",1)
    ..i OrderItemID'=""  d
    ...s SpecNo=$P(^OEORD(+OrderItemID,"I",$P(OrderItemID,"||",2),3),"^",20)
    ...s OEORIItemStatDR=$p($G(^OEORD(+OrderItemID,"I",$p(OrderItemID,"||",2),1)),"^",13)
    ...s:OEORIItemStatDR=6 AppFlag=1
   	...;i (OEORIItemStatDR=6)&&($G(^DHCPESetting("DHCPE","IsPrintEItem"))'="Y") s ItemStatFlag=1 //根据配置是否打印已执行医嘱
	...i (OEORIItemStatDR=6)&&($G(^DHCPESetting("DHCPE","IsPrintEItem",LocID))'="Y") s ItemStatFlag=1 //根据配置是否打印已执行医嘱
    ...q:SpecNo=""
    ...q:$D(^TempDHCPEPrintDirectSpecNum(Job,SpecNo))
    ...s ^TempDHCPEPrintDirectSpecNum(Job,SpecNo)=""
    ...s SpecName=##class(web.DHCPE.BarPrint).GetSpecName(OrderItemID)
    ...i SpecName[("血") d
    ....s BloodSpecNum=BloodSpecNum+1
    ....s BloodPatItemID=PatItemID
    ...e  d
    ....s OtherSpecNum=OtherSpecNum+1
    ....s OtherPatItemID=PatItemID
    .q:ItemStatFlag=1
    .i AppFlag=1 d
    ..i STID=CTStation d
    ...s CTAppNum=CTNum+1
    ..i STID=RaxStation d
    ...s RaxAppNum=RaxNum+1
    ..i STID=NJStation d
    ...s NJAppNum=NJNum+1
    .;s ItemSort=$P(PatItemInfo,"^",2)
    .;s IsPrint=$P(PatItemInfo,"^",3)
    .;s PrintName=$P(PatItemInfo,"^",4)
    .s ItemSort=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),28)  //导诊单上项目顺序
    .s IsPrint=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),29)   //导诊单上是否打印
    .s PrintName=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),30) //导诊单上打印项目名称
    .i PatItemID'="" d
    ..;s PatItemSort=$P($G(^DHCPECTDataEx("PatItem",PatItemID)),"^",2)
    ..s PatItemSort=$lg($g(^CF.PE.UsherItemCatD(PatItemID)),4)            //导诊单分类顺序
    ..s:PatItemSort="" PatItemSort="99999"
    .e  d
    ..s PatItemSort="99999"
    .s:PatItemID="" PatItemID="99999"
    .s:ItemSort="" ItemSort="9999999999"
    .s:IsPrint="" IsPrint="Y"
    .s:PrintName="" PrintName=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcimID,"",LocID)
    .
    .s SetID=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",2)
    .s AddFlag=0
    .i SetID="" d
    ..i AddItem="" d
    ...s AddItem=PrintName
    ..e  d
    ...s AddItem=AddItem_"+"_PrintName
    ..s AddFlag=1
    .s:IsPrint="N" PrintName=""
    .s ^TempDHCPEPrintDirect(Job,PatItemSort,PatItemID,ItemSort,ArcimID)=PrintName_"^"_AddFlag
    k ^TempDHCPEPrintDirectSpecNum(Job)
    s ItemInfo=""
    s PatItemSort=""
    f  s PatItemSort=$O(^TempDHCPEPrintDirect(Job,PatItemSort)) q:PatItemSort=""  d
    .s PatItemID=""
    .f  s PatItemID=$O(^TempDHCPEPrintDirect(Job,PatItemSort,PatItemID)) q:PatItemID=""  d
    ..s OneInfo=""
    ..;s PatItemName=$P($G(^DHCPECTDataEx("PatItem",PatItemID)),"^",1) 
    ..s PatItemName=$lg($g(^CF.PE.UsherItemCatD(PatItemID)),3)      //导诊单分类描述
    ..i PatItemName="" s PatItemName="没有分类"
    
    ..i PatItemID="5" d  ;放射不出片
    ...i NoPhotoFlag="1" d
    ....s PatItemName=PatItemName_"(不出片)"
    
    ..i PatItemID=BloodPatItemID d
    ...s PatItemName=PatItemName_"("_BloodSpecNum_")"
    ..;i PatItemID=OtherPatItemID d
    ..;.s PatItemName=PatItemName_"("_OtherSpecNum_")"
    ..;s PatItemNotice=$G(^DHCPECTDataEx("PatItem",PatItemID,"Place",LocID))
    ..;s DocFlag=$P($G(^DHCPECTDataEx("PatItem",PatItemID)),"^",6)
    ..;s PatSignName=$P($G(^DHCPECTDataEx("PatItem",PatItemID)),"^",7)
    ..s PatItemNotice=$lg($g(^CF.PE.UsherItemCatD(PatItemID)),5) //注意事项（导诊单）
    ..s DocFlag=$lg($g(^CF.PE.UsherItemCatD(PatItemID)),6)       //医生签名（导诊单）
    ..s PatSignName=$lg($g(^CF.PE.UsherItemCatD(PatItemID)),7)	//患者签名（导诊单）
    ..s PatInfo=PatItemName_"^"_PatItemNotice_"^"_DocFlag_"^"_PatSignName
    ..s OneItemInfo=""
    ..s PrtFlag=0
    ..s ItemSort=""
    ..f  s ItemSort=$O(^TempDHCPEPrintDirect(Job,PatItemSort,PatItemID,ItemSort)) q:ItemSort=""  d
    ...s ArcimID=""
    ...f  s ArcimID=$O(^TempDHCPEPrintDirect(Job,PatItemSort,PatItemID,ItemSort,ArcimID)) q:ArcimID=""  d
    ....
    ....i (PatItemID=6)&(IBSex="男") d
    .....s:LocID="53" $P(PatInfo,"^",2)="★腹部超声需要空腹、前列腺超声需要憋尿"
    ....i (PatItemID=6)&(IBSex="女") d
    .....s:LocID="53" $P(PatInfo,"^",2)="★腹部超声需要空腹、妇科B超需要憋尿"
    ....i (ArcimIDStr[("^"_ArcimID_"^")) d
    .....s PrtFlag=1
    ....
    ....s OneArcInfo=$G(^TempDHCPEPrintDirect(Job,PatItemSort,PatItemID,ItemSort,ArcimID))
    ....q:$P(OneArcInfo,"^",1)=""
    ....s ItemNum=$g(^TempDHCPEPrintDirectItemNum("PrintNewDirect","Qty",Job,PreIADM,ArcimID))
    ....i ItemNum>1 s $p(OneArcInfo,"^",1)=$p(OneArcInfo,"^",1)_"*"_ItemNum
    ....i OneItemInfo="" d
    .....s OneItemInfo=OneArcInfo
    ....e  d
    .....s OneItemInfo=OneItemInfo_$C(3)_OneArcInfo
    ...s:(PrtFlag=1) $P(PatInfo,"^",2)="★阴式B超请先行妇科检查"
    ..s OneInfo=PatInfo_$C(2)_OneItemInfo
    ..i ItemInfo="" d
    ...s ItemInfo=OneInfo
    ..e  d
    ...s ItemInfo=ItemInfo_$C(1)_OneInfo
    k ^TempDHCPEPrintDirect(Job)
    K ^TempDHCPEPrintDirectItemNum("PrintNewDirect","Qty",Job)
    q AddItem_$C(4)_ItemInfo_$C(5)_CTNum_"("_CTAppNum_")"_"^"_RaxNum_"("_RaxAppNum_")"_"^"_NJNum_"("_NJAppNum_")"
}

ClassMethod PatItemPrintFlag(PAADM)
{
    Q:PAADM=""
    s ^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM)="Y"
    q ""
}

ClassMethod GetPhotoPathByPAADM(PAADM)
{
    s PatMasID=""
    s PatMasID=$P(^PAADM(PAADM),"^",1)
   s LocID=$P($G(^PAADM(PAADM)),"^",4)
	q "http://100.100.96.248:8080/"_PatMasID_".jpg"
	//s FTPInfo=$G(^DHCPESetting("DHCPE","PhotoFTP"))
	s FTPInfo=$G(^DHCPESetting("DHCPE","PhotoFTP",LocID))

    //var imgStr="ftp://"+FTPArr[1]+":"+FTPArr[2]+"@"+FTPArr[0]+":"+FTPArr[3]+"/"+FTPArr[4]+"/"+BaseInfo[7]+".jpg"
    s imgStr="ftp://"_$P(FTPInfo,"^",2)_":"_$P(FTPInfo,"^",3)_"@"_$P(FTPInfo,"^",1)_":"_$P(FTPInfo,"^",4)_"/"_$P(FTPInfo,"^",5)_"/"_PatMasID_".jpg"
    q imgStr
}

// 不用作废

ClassMethod GetTemplateName(VIPLevelDesc)
{
    s VIPLevelID=##class(web.DHCPE.VIPLevel).GetVIPIDByDesc(VIPLevelDesc)
    //s VIPLevelID=##class(web.DHCPE.CT.VIPLevel).GetVIPIDByDesc(VIPLevelDesc)
    q:VIPLevelID="" ""
    q $P($G(^DHCPEVIPLevel("VIP",VIPLevelID)),"^",13)
}

// w ##class(web.DHCPE.CT.VIPLevel).GetVIPIDByDesc

/// w ##class(web.DHCPE.PrintNewDirect).GetPhotoPath(0003147387)
ClassMethod GetPhotoPath(RegNo)
{
    s PatMasID=""
    /*
    i Type="RegNo" d
    .//s ID=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
    .s PatMasID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
    b ;PatMasID
    i Type="PAADM" d
    .s PatMasID=$P(^PAADM(RegNo),"^",1)
    */
    s PatMasID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
    q:PatMasID="" ""
    //s PatMasID="3147393"
    q "http://100.100.96.248:8080/"_PatMasID_".jpg"
   
    //s FTPInfo=$G(^DHCPESetting("DHCPE","PhotoFTP"))
	s FTPInfo=$G(^DHCPESetting("DHCPE","PhotoFTP",LocID))

    //var imgStr="ftp://"+FTPArr[1]+":"+FTPArr[2]+"@"+FTPArr[0]+":"+FTPArr[3]+"/"+FTPArr[4]+"/"+BaseInfo[7]+".jpg"
    s imgStr="ftp://"_$P(FTPInfo,"^",2)_":"_$P(FTPInfo,"^",3)_"@"_$P(FTPInfo,"^",1)_":"_$P(FTPInfo,"^",4)_"/"_$P(FTPInfo,"^",5)_"/"_PatMasID_".jpg"
    q imgStr
}

}
