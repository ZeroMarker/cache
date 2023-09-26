/// Import SQLUser
/// 名称:收费项目查询
/// 描述:查询收费项目信息
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-04-01
Class web.DHCBL.CT.DHCTarItem Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter SQLTableName = "DHC_TarItem";

/// Function:收费项查找
/// CreateDate: 2016-04-01
/// Creator: 基础数据平台组 - 陈莹
/// w ##class(web.DHCBL.CT.DHCTarItem).GetList("","","","","", "","","","","", "","","","","", "","","","","", "")
/// 1 id ,  2code , 3desc ,  4alias , 5start , 6limit,  7sort , 8dir, 9hospid，10ExpParams
/// ExpParams：1单位^2激活标志(Y/N)^3医保名称（传的空）^4外部代码^5收费依据  ^6收费说明^7分类^8子分类^9价格从 ^10到价格  ^11开始日期从^12开始日期到^13项目分类(药品/材料/诊疗项目)^14国家医保编码^15国家医保编码对照状态(Y/N)
ClassMethod GetList(rowid, code, desc, alias, start, limit, sort, dir, hospid, ExpParams) As %String
{
	
	
	k ^TMP("GetList","DHCTarItem")
	s count=0
	if (rowid'="") 
	{
		s id=rowid
		w "{""data"":["
		s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(id,hospid)
		s TARIInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
		s TARIInsuName=$p(InsuInfo,"^",2)  //国家医保名称
		w ##class(web.DHCBL.CT.DHCTarItem).GetItmByRowID(id,hospid)
		w "],""total"":""1"",""success"":""true""}"
		
	 }
	 else
	 {
		if start="" s start=0
		if limit="" s limit=20
		s:code'="" code=$zcvt(code,"U")
		s:desc'="" desc=$zcvt(desc,"U")
		s:alias'="" alias=$zcvt(alias,"U")
		
		
		s UOM=$p(ExpParams,"^",1)           //单位
		s ActiveFlag=$p(ExpParams,"^",2)  //激活标志
		s InsuName=$p(ExpParams,"^",3)    //医保名称
		s ExternalCode=$p(ExpParams,"^",4)  //外部代码
		s ChargeBasis=$p(ExpParams,"^",5)  //收费依据
		s EngName=$p(ExpParams,"^",6)   //收费说明  
		s treetype=$p(ExpParams,"^",7)   //分类
		s category=$p(ExpParams,"^",8)   //子分类
		s price1=$p(ExpParams,"^",9)   //价格从
		s price2=$p(ExpParams,"^",10)   //到价格
		s datefrom1=$p(ExpParams,"^",11)  //开始日期从
		s datefrom2=$p(ExpParams,"^",12)  //开始日期到
		s ItemType=$p(ExpParams,"^",13)   //项目分类(药品/材料/诊疗项目)
		s InsuCode=$p(ExpParams,"^",14)   //国家医保编码
		s InsuCodeMapedFlag=$p(ExpParams,"^",15)  //国家医保编码对照状态(Y/N)
		
		if ActiveFlag="A" s ActiveFlag=""
		s:InsuCode'="" InsuCode=$zcvt(InsuCode,"U") 
		s:InsuName'="" InsuName=$zcvt(InsuName,"U")
		s:ExternalCode'="" ExternalCode=$zcvt(ExternalCode,"U")
		s:ChargeBasis'="" ChargeBasis=$zcvt(ChargeBasis,"U")
		s:EngName'="" EngName=$zcvt(EngName,"U")
		
		s:datefrom1'="" datefrom1= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom1)
		s:datefrom2'="" datefrom2= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(datefrom2)
		if (treetype="") s treetype="DHCTarCate"
		
		s LookUpMode=""
		s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPAlias||GetConfig")
	    i $IsObject(myobj)
	    {
	       s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("DHC_TarItem")
	    }
	    
		s AuStr=##class(web.DHCBL.Authorize.DHCTarItem).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
		s DHCTarSubCateAuStr=##class(web.DHCBL.Authorize.DHCTarSubCate).DHCGetDataByDefaultSession()  //收费项目子类
		s DHCTarSubCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCTarSubCateAuStr="")||(DHCTarSubCateAuStr["limited:0") s DHCTarSubCateAuFlag=1
		
		s DHCTarOutpatCateAuStr=##class(web.DHCBL.Authorize.DHCTarOutpatCate).DHCGetDataByDefaultSession() //门诊费用子类 
		s DHCTarOutpatCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCTarOutpatCateAuStr="")||(DHCTarOutpatCateAuStr["limited:0") s DHCTarOutpatCateAuFlag=1
		
		s DHCTarAcctCateAuStr=##class(web.DHCBL.Authorize.DHCTarAcctCate).DHCGetDataByDefaultSession()  //会计费用子类
		s DHCTarAcctCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCTarAcctCateAuStr="")||(DHCTarAcctCateAuStr["limited:0") s DHCTarAcctCateAuFlag=1
		
		s DHCTarEMCCateAuStr=##class(web.DHCBL.Authorize.DHCTarEMCCate).DHCGetDataByDefaultSession()  //经济核算子类
		s DHCTarEMCCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCTarEMCCateAuStr="")||(DHCTarEMCCateAuStr["limited:0") s DHCTarEMCCateAuFlag=1
		
		s DHCTarMRCateAuStr=##class(web.DHCBL.Authorize.DHCTarMRCate).DHCGetDataByDefaultSession()  //病案首页子类
		s DHCTarMRCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCTarMRCateAuStr="")||(DHCTarMRCateAuStr["limited:0") s DHCTarMRCateAuFlag=1
		
		s DHCTarInpatCateAuStr=##class(web.DHCBL.Authorize.DHCTarInpatCate).DHCGetDataByDefaultSession()  //住院费用子类
		s DHCTarInpatCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCTarInpatCateAuStr="")||(DHCTarInpatCateAuStr["limited:0") s DHCTarInpatCateAuFlag=1
		
		s DHCNewTarMRCateAuStr=##class(web.DHCBL.Authorize.DHCNewTarMRCate).DHCGetDataByDefaultSession() //新病案首页子类
		s DHCNewTarMRCateAuFlag=0
		;未授权情况下，默认显示全部数据
		if (DHCNewTarMRCateAuStr="")||(DHCNewTarMRCateAuStr["limited:0") s DHCNewTarMRCateAuFlag=1

		s count=0
		s start=start+1
		
		w "{""data"":["
		s CurrentCount=0
		
		if sort="" s sort="TARIRowId"
		
		k ^TMPDHCTARI
		s TARIRowId=0
		for
		{
			s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
			s id = TARIRowId
			if $g(^DHCTARI(id))="" continue  ///过滤空数据
			s strRowId="{ID:"_id_"}"
			continue:'((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARIRowId,hospid)
			continue:showflag="N"
			s TarSubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
			s TarAcctCate = $p($g(^DHCTARI(id)),"^",5)   ///收费会计子类
			s TarOutpatCate =  $p($g(^DHCTARI(id)),"^",15)  ///门诊费用子类
			s TarInpatCate =$p($g(^DHCTARI(id)),"^",14)  ///住院费用子类
			s TarEMCCate = $p($g(^DHCTARI(id)),"^",16)  ///经济核算子类
			s TarMRCate =$p($g(^DHCTARI(id)),"^",6)  ///旧病案首页子类
			s NewTarMRCate=$p($g(^DHCTARI(id)),"^",30) ///新病案首页子类
				
			continue:'(((DHCTarSubCateAuStr[("{ID:"_TarSubCate_"}"))||(DHCTarSubCateAuFlag=1))&((DHCTarAcctCateAuStr[("{ID:"_TarAcctCate_"}"))||(DHCTarAcctCateAuFlag=1))&((DHCTarOutpatCateAuStr[("{ID:"_TarOutpatCate_"}"))||(DHCTarOutpatCateAuFlag=1))&((DHCTarInpatCateAuStr[("{ID:"_TarInpatCate_"}"))||(DHCTarInpatCateAuFlag=1))&((DHCTarEMCCateAuStr[("{ID:"_TarEMCCate_"}"))||(DHCTarEMCCateAuFlag=1))&((DHCTarMRCateAuStr[("{ID:"_TarMRCate_"}"))||(DHCTarMRCateAuFlag=1))&((DHCNewTarMRCateAuStr[("{ID:"_NewTarMRCate_"}"))||(DHCNewTarMRCateAuFlag=1)))
				
			s cateflag=0
			if (treetype="ItemCat")
			{
				s resultp=""
    			if category'="" s resultp=##class(web.DHCBL.CT.DHCTarItem).GetChildCatId(category,"")
				s TARIItemCatDR=$p($g(^DHCTARI(TARIRowId)),"^",31)    ;科目类别
				if (resultp[("^"_TARIItemCatDR_"^"))||(category="") s cateflag=1
			}
			else
			{
				if (category'="")
				{
					s cate=$p(category,"&",1),subcate=$p(category,"&",2),Cate=""  //2022-05-16改成&分隔
					if (treetype="DHCTarCate")
					{
						s SubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
						s:(SubCate'="") Cate=$p($g(^DHCTarC("SC",SubCate)),"^",3) ///收费项目大类 
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="DHCTarAC")
					{
						s SubCate = $p($g(^DHCTARI(id)),"^",5)   ///收费会计子类
						s:(SubCate'="") Cate = $p($g(^DHCTarC("AC",SubCate)),"^",3)   ///收费会计大类
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="DHCTarOC")
					{
						s SubCate =  $p($g(^DHCTARI(id)),"^",15)  ///门诊费用子类
						s:(SubCate'="") Cate = $p($g(^DHCTarC("OC",SubCate)),"^",3)  ///门诊费用大类
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="DHCTarIC")
					{
						s SubCate =$p($g(^DHCTARI(id)),"^",14)  ///住院费用子类
						s:(SubCate'="") Cate =$p($g(^DHCTarC("IC",SubCate)),"^",3)  ///住院费用大类
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="DHCTarEC")
					{
						s SubCate = $p($g(^DHCTARI(id)),"^",16)  ///经济核算子类
						s:(SubCate'="") Cate = $p($g(^DHCTarC("EC",SubCate)),"^",3)  ///经济核算大类
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="DHCTarMC")
					{
						s SubCate =$p($g(^DHCTARI(id)),"^",6)  ///旧病案首页子类
						s:(SubCate'="") Cate =$p($g(^DHCTarC("MC",SubCate)),"^",3)  ///旧病案首页大类
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="DHCTarMCNew")
					{
						s SubCate=$p($g(^DHCTARI(id)),"^",30) ///新病案首页子类
						s:(SubCate'="") Cate=$p($g(^DHCTarC("MCNew",SubCate)),"^",3) ///新病案首页大类
						if ((SubCate=subcate)||(subcate=""))&&((Cate=cate)||(cate="")) s cateflag=1
					}
					elseif (treetype="OPERCategory")
					{
						s SubCate=$p($g(^DHCTARI(id)),"^",37) ///手术分级
						if ((SubCate=cate)||(cate="")) s cateflag=1
					}
				}
				else
				{
					s cateflag=1
				}
			}
			continue:cateflag=0
			
			s SubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
			/*IF (SubCate'="")&&(ItemType'="")
			{
				s Cate=$p($g(^DHCTarC("SC",SubCate)),"^",3) ///收费项目大类 
				s:Cate'="" Cate=$p($g(^DHCTarC("CC",Cate)),"^",2) ///收费项目大类 -描述
				if '(((Cate="药品费")&&(ItemType="药品"))||((Cate="材料费")&&(ItemType="材料"))||((Cate'="药品费")&&(ItemType="诊疗项目")&&(Cate'="材料费")))
				{
					continue
				}
			}
			*/
			IF (SubCate'="")&&(ItemType'="")
			{
				s Cate=$p($g(^DHCTarC("SC",SubCate)),"^",4) ///收费项目子类类型
				if (Cate'=ItemType)
				{
					continue
				}
			}			
			s TARICode =$p($g(^DHCTARI(id)),"^",1)
			continue:'($zcvt(TARICode,"U")[code)
			
			s TARIDesc =$p($g(^DHCTARI(id)),"^",2)
			if desc'=""
			{
				s DescFlag=0
				s ALIASText1=""
				s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,TARIDesc,desc)
				if (Flag1=1) s DescFlag=1
			}
			else
			{
				s DescFlag=1
			}
			if (DescFlag'=1) continue
				
			if alias'=""
			{
				s AliasFlag=0
				s ALIASText1=""
				s TIARowId=0
				for
				{
					s TIARowId=$o(^DHCTARAL("A",id,TIARowId))  q:TIARowId=""
					s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(TIAAlias,"U")
				}
				s AliasFlag=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,alias)	

			}
			else
			{
				s AliasFlag=1
			}
			if (AliasFlag'=1) continue
			
			s TARIUOM =$p($g(^DHCTARI(id)),"^",3)        ///单位
			if '((TARIUOM=UOM)||(UOM="")) continue
			
			s TARIActiveFlag=$p($g(^DHCTARI(id)),"^",7)  ///有效
			s TARIEndDate =$p($g(^DHCTARI(id)),"^",12) ///结束日期
			if ((TARIEndDate'="")&&(TARIEndDate<+$h)) s TARIActiveFlag="N"  //2020-09-11 开始日期结束日期不在有效范围内时有效标志显示N
			
			if '((TARIActiveFlag=ActiveFlag)||(ActiveFlag="")) continue
		
			s TARIExternalCode = $p($g(^DHCTARI(id)),"^",13)
			if '($zcvt(TARIExternalCode,"U")[ExternalCode) continue
			
			s TARIChargeBasis = $p($g(^DHCTARI(id)),"^",20)  //收费依据
			if '($zcvt(TARIChargeBasis,"U")[ChargeBasis) continue

			s TARIInsuName = $p($g(^DHCTARI(id)),"^",18) //医保名称
			if '($zcvt(TARIInsuName,"U")[InsuName) continue
			
			s TARIEngName = $p($g(^DHCTARI(id)),"^",19)  //收费说明
			if '($zcvt(TARIEngName,"U")[EngName) continue
			//s TARIInsuCode = $p($g(^DHCTARI(id)),"^",59)  //国家医保编码
			//2022-04-11
			s InsuInfo=""
			s GettingFlag=0
			IF (InsuCode'="")||(InsuCodeMapedFlag'="")
			{
				s GettingFlag=1
				s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(id,hospid)
				s TARIInsuCode =$p(InsuInfo,"^",1)  //国家医保编码
				s TARIInsuName =$p(InsuInfo,"^",2)  //国家医保名称
				if TARIInsuCode'="-1"
				{
					if '($zcvt(TARIInsuCode,"U")[$zcvt(InsuCode,"U")) continue
					if (InsuCodeMapedFlag="Y")&&(TARIInsuCode="") continue //国家医保编码已对照/未对照筛选
					if (InsuCodeMapedFlag="N")&&(TARIInsuCode'="") continue
				}
			}
			
			s TARIStartDate =$p($g(^DHCTARI(id)),"^",11) ///开始日期
			
			s dateflag=0
			if ((datefrom1'="")&&(datefrom1<=TARIStartDate)||(datefrom1=""))&&((datefrom2'="")&(datefrom2>=TARIStartDate)||(datefrom2="")) s dateflag=1
			if (dateflag'=1) continue
			
			s sortvalue=TARIRowId
			if (sort="TARICode")  ///2017-09-04 按照代码排序
			{
				s sortvalue="S"_TARICode
				s sortvalue=$zcvt(sortvalue,"U")
			}
			if (sort="TARIDesc")  ///2019-06-12 按照描述排序
			{
				s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(TARIDesc,3,"")
				
			}
			if (sort="TARIStartDate")  ///2019-06-12 按照单位排序
			{
				if TARIStartDate="" s TARIStartDate=0
				s sortvalue=TARIStartDate
			}
			if (sort="TARIChargeBasis")  ///2019-06-12 按照收费依据排序
			{
				s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(TARIChargeBasis,3,"")
				
			}
			if (sort="TARIExternalCode")  ///2019-06-12 按照外部编码排序
			{
				s sortvalue="S"_##class(web.DHCBL.BDP.FunLib).GetCNCODE(TARIExternalCode,3,"")
			}
			if (sort="TariPrice")  ///2019-06-12 按照价格排序
			{
				s TariPrice= ##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(id,hospid)
				if TariPrice="" s TariPrice=0
				s sortvalue=1+TariPrice   //考虑0.7,存的时候会带引号，如果不加1，会比正常的数字排在后面
				
			}
			s ^TMPDHCTARI(sort,sortvalue,TARIRowId)=InsuInfo
		}
		
		
		s sortvalue=0,sdir=1   ///ASC,正序
		if (dir="DESC")   //倒序
		{
			s sortvalue="",sdir=-1
		}
		for  
		{			
			s sortvalue=$o(^TMPDHCTARI(sort,sortvalue),sdir) q:sortvalue=""
			s TARIRowId=0
			if (dir="DESC") s TARIRowId=""
			for 
			{
				s TARIRowId=$o(^TMPDHCTARI(sort,sortvalue,TARIRowId),sdir) q:(TARIRowId="")
				s id = TARIRowId
				s TariPriceInfo="",priceflag=1
				if (price1'="")||(price2'="")
				{
					s TariPrice= ##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(id,hospid)
					if ((price1'="")&(price1<=TariPrice)||(price1=""))&&((price2'="")&(price2>=TariPrice)||(price2="")) s priceflag=1
					else  s priceflag=0
				}
				if (priceflag'=1) continue
		
				s count=count+1
				s ^TMP("GetList","DHCTarItem",count)=id  //2017-11-15  增加导出查询出的数据功能
				if (count<start) continue
				if ((count<(start+limit)))
				{
					
					if (CurrentCount=0) 
					{
						s CurrentCount=1
					}
					else
					{
						s CurrentCount=CurrentCount+1
						w ","
					}
					if (GettingFlag=0)
					{
						s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(id,hospid)
						s TARIInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
						s TARIInsuName=$p(InsuInfo,"^",2)  //国家医保名称
					}
					else
					{
						s InsuInfo=$g(^TMPDHCTARI(sort,sortvalue,TARIRowId))
						s TARIInsuCode=$p(InsuInfo,"^",1)  //国家医保编码
						s TARIInsuName=$p(InsuInfo,"^",2)  //国家医保名称
					}
					
					w ##class(web.DHCBL.CT.DHCTarItem).GetItmByRowID(id,hospid,TARIInsuCode,TARIInsuName)
				}
				
					
			}
		}
		w "],""total"":"""_count_""",""success"":""true""}"
	 }
	 k ^TMPDHCTARI
	 s ^TMP("GetList","DHCTarItem",0)=count
	 q ""
}

/// Function:通过ID 查找收费项的信息，返回Josn串
/// Creator:陈莹
/// CreateDate: 2019-06-12
/// Input:id（收费项rowid)
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).GetItmByRowID("13367",2)
ClassMethod GetItmByRowID(id As %String, hospid As %String = "", TARIInsuCode As %String = "", TARIInsuName As %String = "") As %String
{
	n (id,hospid,%session,TARIInsuCode,TARIInsuName)
	s strResult=""

	if (id'="") 
	{
		s TARIRowId = id
		s TARICode =$p($g(^DHCTARI(id)),"^",1)
		s TARIDesc =$p($g(^DHCTARI(id)),"^",2)
		s TARIUOM =$p($g(^DHCTARI(id)),"^",3)     ///单位
		s TARIUOMID=TARIUOM
		s:TARIUOM'="" TARIUOM=$p($g(^CT("UOM",TARIUOM)),"^",2)
		s TARISubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
		s TARISubCateID =TARISubCate
		s:TARISubCate'="" TARISubCate=$p($g(^DHCTarC("SC",TARISubCate)),"^",2)
		s TARIAcctCate = $p($g(^DHCTARI(id)),"^",5)   ///收费会计子类
		s TARIAcctCateID =TARIAcctCate
		s:TARIAcctCate'="" TARIAcctCate=$p($g(^DHCTarC("AC",TARIAcctCate)),"^",2)
		s TARIOutpatCate =  $p($g(^DHCTARI(id)),"^",15)  ///门诊费用子类
		s TARIOutpatCateID =TARIOutpatCate
		s:TARIOutpatCate'="" TARIOutpatCate=$p($g(^DHCTarC("OC",TARIOutpatCate)),"^",2)
		s TARIInpatCate =$p($g(^DHCTARI(id)),"^",14)  ///住院费用子类
		s TARIInpatCateID =TARIInpatCate
		s:TARIInpatCate'="" TARIInpatCate=$p($g(^DHCTarC("IC",TARIInpatCate)),"^",2)
		s TARIEMCCate = $p($g(^DHCTARI(id)),"^",16)  ///经济核算子类
		s TARIEMCCateID =TARIEMCCate
		s:TARIEMCCate'="" TARIEMCCate=$p($g(^DHCTarC("EC",TARIEMCCate)),"^",2)
		s TARIMRCate =$p($g(^DHCTARI(id)),"^",6)  ///旧病案首页子类
		s TARIMRCateID =TARIMRCate
		s:TARIMRCate'="" TARIMRCate=$p($g(^DHCTarC("MC",TARIMRCate)),"^",2)
		s TARIMCNew=$p($g(^DHCTARI(id)),"^",30) ///新病案首页子类
		s TARIMCNewID=TARIMCNew
		s:TARIMCNew'="" TARIMCNew=$p($g(^DHCTarC("MCNew",TARIMCNew)),"^",2)
		
		s TARIExternalCode = $p($g(^DHCTARI(id)),"^",13)
		s TARIChargeBasis = $p($g(^DHCTARI(id)),"^",20)  //收费依据
		s TARIEngName = $p($g(^DHCTARI(id)),"^",19)  //收费说明
		
		s TARIConnote = $p($g(^DHCTARI(id)),"^",32)  //项目内涵 ///2017-11-29
		s TARIRemark = $p($g(^DHCTARI(id)),"^",33)  //备注
		s TARIExclude = $p($g(^DHCTARI(id)),"^",34)  //除外内容
		s TARIOPERCategoryDR = $p($g(^DHCTARI(id)),"^",37)  //手术分级 2020-04-13
		if TARIOPERCategoryDR'="" s TARIOPERCategoryDR=$p($g(^ORC("CATEG",TARIOPERCategoryDR)),"^",2)
		s TARIPriceCode = $p($g(^DHCTARI(id)),"^",50)  //物价编码
		s TARIPriceDesc = $p($g(^DHCTARI(id)),"^",55)  //物价名称
		s TARISpecialProcurementFlag = $p($g(^DHCTARI(id)),"^",58)  //特需项目标识
		//s TARIInsuName = $p($g(^DHCTARI(id)),"^",18) //医保名称
		//s TARIInsuCode = $p($g(^DHCTARI(id)),"^",59)  //国家医保编码
		//s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(id,hospid)
		//s TARIInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
		//s TARIInsuName=$p(InsuInfo,"^",2)  //国家医保名称
		
		
		s TARIRepeatedChargeFlag = $p($g(^DHCTARI(id)),"^",68)  //不允许重复收费
		s TARIPriceRemark = $p($g(^DHCTARI(id)),"^",64)  //物价备注
		s TARIManufactorType = $p($g(^DHCTARI(id)),"^",69)  //进口标志
		
		s TARISpecialFlag=$p($g(^DHCTARI(id)),"^",17)
		s TARIActiveFlag=$p($g(^DHCTARI(id)),"^",7)
		s TARIStartDate =$p($g(^DHCTARI(id)),"^",11) ///开始日期
		s TARIEndDate = $p($g(^DHCTARI(id)),"^",12)  
		if ((TARIEndDate'="")&&(TARIEndDate<+$h)) s TARIActiveFlag="N"  //2020-07-02 开始日期结束日期不在有效范围内时有效标志显示N
		s:TARIStartDate'="" TARIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIStartDate)
		s:TARIEndDate'="" TARIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIEndDate)
		s TariPrice= ##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(id,hospid)
		s TARIItemCatDR=$p($g(^DHCTARI(id)),"^",31)    ;科目类别
		s TARIItemCatDRID=TARIItemCatDR
		if TARIItemCatDR'=""
		{
			s TARIItemCatDR=$listget($g(^User.BDPItemCategoryD(TARIItemCatDR)),3)
		}
		
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("DHC_TarItem",id)
		s BDPInternalCode =$p($g(resultStr),"^",1)
		s BDPInternalDesc = $p($g(resultStr),"^",2)
		s BDPHospNationalCode=$p($g(resultStr),"^",3)  
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		
		s TARICode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARICode)
		s TARIDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIDesc)
		s TARIUOM=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIUOM)
		s TARISubCate=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARISubCate)
		s TARIAcctCate=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIAcctCate)
		s TARIOutpatCate=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIOutpatCate)
		s TARIInpatCate=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIInpatCate)
		s TARIEMCCate=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIEMCCate)
		s TARIMRCate=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIMRCate)
		s TARIMCNew=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIMCNew)
		s TARIInsuName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIInsuName)
		s TARIExternalCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIExternalCode)
		s TARIChargeBasis=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIChargeBasis)
		s TARIEngName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIEngName)
		s TARIItemCatDR=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIItemCatDR)
		s TARIConnote=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIConnote)
		s TARIRemark=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIRemark)
		s TARIExclude=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIExclude)
		s TARIPriceCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIPriceCode)
		s TARIPriceDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIPriceDesc)
		s TARIInsuCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIInsuCode)
		
		s strResult= "{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_TARICode_""",""TARIDesc"":"""_TARIDesc_""",""TARIUOM"":"""_TARIUOM_""",""TARIUOMID"":"""_TARIUOMID_""",""TARISubCate"":"""_TARISubCate_""",""TARISubCateID"":"""_TARISubCateID_""",""TARIAcctCate"":"""_TARIAcctCate_""",""TARIAcctCateID"":"""_TARIAcctCateID_""",""TARIOutpatCate"":"""_TARIOutpatCate_""",""TARIOutpatCateID"":"""_TARIOutpatCateID_""",""TARIInpatCate"":"""_TARIInpatCate_""",""TARIInpatCateID"":"""_TARIInpatCateID_""",""TARIEMCCate"":"""_TARIEMCCate_""",""TARIEMCCateID"":"""_TARIEMCCateID_""",""TARIMRCate"":"""_TARIMRCate_""",""TARIMRCateID"":"""_TARIMRCateID_""",""TARIMCNew"":"""_TARIMCNew_""",""TARIMCNewID"":"""_TARIMCNewID_""",""TARIInsuName"":"""_TARIInsuName_""",""TARIExternalCode"":"""_TARIExternalCode_""",""TARIChargeBasis"":"""_TARIChargeBasis_""",""TARIEngName"":"""_TARIEngName_""",""TARIOPERCategoryDR"":"""_TARIOPERCategoryDR_""",""TARISpecialFlag"":"""_TARISpecialFlag_""",""TARIActiveFlag"":"""_TARIActiveFlag_""",""TARIStartDate"":"""_TARIStartDate_""",""TARIEndDate"":"""_TARIEndDate_""",""TariPrice"":"""_TariPrice_""",""TARIItemCatDR"":"""_TARIItemCatDR_""",""TARIItemCatDRID"":"""_TARIItemCatDRID_""",""TARIConnote"":"""_TARIConnote_""",""TARIRemark"":"""_TARIRemark_""",""TARIExclude"":"""_TARIExclude_""",""TARIInsuCode"":"""_TARIInsuCode_""",""TARIPriceRemark"":"""_TARIPriceRemark_""",""TARIManufactorType"":"""_TARIManufactorType_""",""TARIPriceCode"":"""_TARIPriceCode_""",""TARIPriceDesc"":"""_TARIPriceDesc_""",""TARISpecialProcurementFlag"":"""_TARISpecialProcurementFlag_""",""TARIRepeatedChargeFlag"":"""_TARIRepeatedChargeFlag_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}" 
	}
	q strResult
}

/// /导出start
/// Function: 获取查询出的收费项数据总数
/// CreateDate:2017-11-15
/// Creator: chenying
/// w ##class(web.DHCBL.CT.DHCTarItem).GetDataCount()
ClassMethod GetDataCount() As %String
{
	s n=$g(^TMP("GetList","DHCTarItem",0))
	q n
}

/// Function: 获取第K条收费项信息,导出信息时调用
/// Input:k (查询到的第几条收费项数据）
/// Retrun:收费项信息
/// CreateDate:2017-11-16
/// Creator: chenying
/// w ##class(web.DHCBL.CT.DHCTarItem).GetFieldValue(1)
ClassMethod GetFieldValue(k, HospId) As %String
{
	n (%session,k,HospId)	
	q:k="" ""
	s HOSPtalID=HospId
	//s:$d(%session) HOSPtalID=$g(%session.Data("LOGON.HOSPID"))
	
	s TARIRowId=$g(^TMP("GetList","DHCTarItem",k))
	q:TARIRowId="" ""
	s TARICode =$p($g(^DHCTARI(TARIRowId)),"^",1)
	s TARIDesc =$p($g(^DHCTARI(TARIRowId)),"^",2)
	s TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)  ///有效
	s TARIEndDate =$p($g(^DHCTARI(TARIRowId)),"^",12) ///结束日期
	if ((TARIEndDate'="")&&(TARIEndDate<+$h)) s TARIActiveFlag="N"  //2020-09-11 开始日期结束日期不在有效范围内时有效标志显示N
			
			
	s TARIItemCatDR=$p($g(^DHCTARI(TARIRowId)),"^",31)    ;科目类别
	s:TARIItemCatDR'="" TARIItemCatDR=$listget($g(^User.BDPItemCategoryD(TARIItemCatDR)),3)
	s TariPrice=##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(TARIRowId,HOSPtalID)  //价格
	s TARIUOM =$p($g(^DHCTARI(TARIRowId)),"^",3)        ///单位
	s:TARIUOM'="" TARIUOM=$p($g(^CT("UOM",TARIUOM)),"^",2)
	s TARIStartDate =$p($g(^DHCTARI(TARIRowId)),"^",11) ///开始日期
	s:TARIStartDate'="" TARIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIStartDate)
	s TARIEndDate =$p($g(^DHCTARI(TARIRowId)),"^",12) ///结束日期
	s:TARIEndDate'="" TARIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIEndDate)
	s TARISubCate =$p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项目子类
	s:TARISubCate'="" TARISubCate=$p($g(^DHCTarC("SC",TARISubCate)),"^",2)
	s TARIAcctCate = $p($g(^DHCTARI(TARIRowId)),"^",5)   ///收费会计子类
	s:TARIAcctCate'="" TARIAcctCate=$p($g(^DHCTarC("AC",TARIAcctCate)),"^",2)
	s TARIOutpatCate =  $p($g(^DHCTARI(TARIRowId)),"^",15)  ///门诊费用子类
	s:TARIOutpatCate'="" TARIOutpatCate=$p($g(^DHCTarC("OC",TARIOutpatCate)),"^",2)
	s TARIInpatCate =$p($g(^DHCTARI(TARIRowId)),"^",14)  ///住院费用子类
	s:TARIInpatCate'="" TARIInpatCate=$p($g(^DHCTarC("IC",TARIInpatCate)),"^",2)
	s TARIEMCCate = $p($g(^DHCTARI(TARIRowId)),"^",16)  ///经济核算子类
	s:TARIEMCCate'="" TARIEMCCate=$p($g(^DHCTarC("EC",TARIEMCCate)),"^",2)
	s TARIMRCate =$p($g(^DHCTARI(TARIRowId)),"^",6)  ///旧病案首页子类
	s:TARIMRCate'="" TARIMRCate=$p($g(^DHCTarC("MC",TARIMRCate)),"^",2)
	s TARIMCNew=$p($g(^DHCTARI(TARIRowId)),"^",30) ///新病案首页子类
	s:TARIMCNew'="" TARIMCNew=$p($g(^DHCTarC("MCNew",TARIMCNew)),"^",2)
	s TARISpecialFlag=$p($g(^DHCTARI(TARIRowId)),"^",17)
	
	s TARIChargeBasis = $p($g(^DHCTARI(TARIRowId)),"^",20)  //收费依据
	s TARIExternalCode = $p($g(^DHCTARI(TARIRowId)),"^",13)  //外部代码
	s TARIEngName = $p($g(^DHCTARI(TARIRowId)),"^",19)  //收费说明
	s TARIConnote = $p($g(^DHCTARI(TARIRowId)),"^",32)  //项目内涵
	s TARIRemark = $p($g(^DHCTARI(TARIRowId)),"^",33)  //备注
	s TARIExclude = $p($g(^DHCTARI(TARIRowId)),"^",34)  //除外内容
	s TARIOPERCategoryDR = $p($g(^DHCTARI(TARIRowId)),"^",37)  //手术分级 2020-04-13
	if TARIOPERCategoryDR'="" s TARIOPERCategoryDR=$p($g(^ORC("CATEG",TARIOPERCategoryDR)),"^",2)
	s TARIPriceCode = $p($g(^DHCTARI(TARIRowId)),"^",50)  //物价编码
	s TARIPriceDesc = $p($g(^DHCTARI(TARIRowId)),"^",55)  //物价名称
	s TARISpecialProcurementFlag = $p($g(^DHCTARI(TARIRowId)),"^",58)  //特需项目标识
	//s TARIInsuCode = $p($g(^DHCTARI(TARIRowId)),"^",59)  //国家医保编码
	//s TARIInsuName = $p($g(^DHCTARI(TARIRowId)),"^",18) //医保名称
	s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(TARIRowId,HospId)
	s TARIInsuCode=$p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
	s TARIInsuName=$p(InsuInfo,"^",2)  //国家医保名称
	
	s TARIRepeatedChargeFlag = $p($g(^DHCTARI(TARIRowId)),"^",68)  //不允许重复收费标志
	s TARIPriceRemark = $p($g(^DHCTARI(TARIRowId)),"^",64)  //物价备注
	s TARIManufactorType= $p($g(^DHCTARI(TARIRowId)),"^",69)  //进口标志
	s Value=TARICode_"^"_TARIDesc_"^"_TARIUOM_"^"_TariPrice_"^"_TARIActiveFlag_"^"_TARIItemCatDR_"^"_TARIStartDate_"^"_TARIEndDate_"^"_TARISubCate_"^"_TARIAcctCate_"^"_TARIOutpatCate_"^"_TARIInpatCate_"^"_TARIEMCCate_"^"_TARIMRCate_"^"_TARIMCNew_"^"_TARISpecialFlag_"^"_TARIInsuCode_"^"_TARIInsuName_"^"_TARIChargeBasis_"^"_TARIExternalCode_"^"_TARIEngName_"^"_TARIConnote_"^"_TARIRemark_"^"_TARIExclude_"^"_TARIOPERCategoryDR_"^"_TARIPriceCode_"^"_TARIPriceDesc_"^"_TARISpecialProcurementFlag_"^"_TARIRepeatedChargeFlag_"^"_TARIPriceRemark   //_"^"_TARIManufactorType
	q Value
}

/// Function: 获取导出表格的标题
/// CreateDate:2017-11-15
/// Creator: chenying
/// w ##class(web.DHCBL.CT.DHCTarItem).GetExceltitlename()
ClassMethod GetExceltitlename() As %String
{
	s Exceltitlename="收费项目代码^收费项目描述^单位^价格^是否有效^科目类别^开始日期^结束日期^收费项目子类^收费会计子类^门诊费用子类^住院费用子类^经济核算子类^旧病案首页子类^新病案首页子类^特殊项目标识^国家医保编码^国家医保名称^收费依据^外部编码^收费说明^项目内涵^备注^除外内容^手术分级^物价编码^物价名称^特需项目标识^不允许重复收费^物价备注"  //^进口标志
	q Exceltitlename
}

/// /导出end
/// Function:查询收费项的内容  真分页  下拉框调用
/// CreateDate: 2017-06-14
/// Creator: 基础数据平台组 - 陈莹
/// w ##class(web.DHCBL.CT.DHCTarItem).GetDataForCmbM("","","","","" )
ClassMethod GetDataForCmbM(rowid, code, desc, start, limit) As %String
{
	if start="" s start=0
	if limit="" s limit=10

	if (rowid'="") 
	{
		s id=rowid
		s TARIRowId = rowid
		s TARICode =$p($g(^DHCTARI(id)),"^",1)
		s TARIDesc =$p($g(^DHCTARI(id)),"^",2)
		
		s TARICode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARICode)
		s TARIDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIDesc)
		
		w "{""data"":["
		w "{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_TARICode_""",""TARIDesc"":"""_TARIDesc_"""}" 
		w "],""total"":""1"",""success"":""true""}"
	 }
	 else
	 {
		s:code'="" code=$zcvt(code,"U")
		s:desc'="" desc=$zcvt(desc,"U")
		s LookUpMode=""
		s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.DHCBL.BDP.BDPAlias||GetConfig")
	    i ($IsObject(myobj)){
	       s LookUpMode=##class(web.DHCBL.BDP.BDPAlias).GetConfig("DHC_TarItem")
	    }
		
		s AuStr=##class(web.DHCBL.Authorize.DHCTarItem).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s count=0
		s start=start+1  ///2016/7/26 不加会导致第一页显示的记录比设置的“每页显示记录数”少一条
		
		w "{""data"":["
		s CurrentCount=0
		
	    s TARIRowId=0
		for
		{
			s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
			s id = TARIRowId
			if $g(^DHCTARI(TARIRowId))="" continue  ///过滤空数据
			s strRowId="{ID:"_TARIRowId_"}"
			if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
			{
				s TARICode =$p($g(^DHCTARI(id)),"^",1)
				s TARIDesc =$p($g(^DHCTARI(id)),"^",2)
				s TARIActiveFlag=$p($g(^DHCTARI(id)),"^",7)
				s TARIEndDate =$p($g(^DHCTARI(id)),"^",12) ///结束日期
				if ((TARIEndDate'="")&&(TARIEndDate<+$h)) s TARIActiveFlag="N"  //2020-09-11 开始日期结束日期不在有效范围内时有效标志显示N
				continue:TARIActiveFlag="N"
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,TARIRowId,hospid)
				continue:showflag="N"
				if ($zcvt(TARICode,"U")[code)
				{
					if desc'=""
					{
						s DescFlag=0
						s ALIASText1=""
						s TIARowId=0
						for
						{
							s TIARowId=$o(^DHCTARAL("A",id,TIARowId))  q:TIARowId=""
							s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
							s ALIASText1=ALIASText1_"^"_$ZCONVERT(TIAAlias,"U")
						}
						s Flag1=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,TARIDesc,desc)
						s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARIDesc)
						s Flag2=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,PINYIN,desc)
						s Flag3=##class(web.DHCBL.BDP.FunLib).GetAliasFlag(LookUpMode,ALIASText1,desc)	
						if (Flag1=1)||(Flag2=1)||(Flag3=1) s DescFlag=1
					}
					else
					{
						s DescFlag=1
					}
					if (DescFlag'=1) continue
					
					
					s count=count+1
					if (count<start) continue
					if ((count<(start+limit)))
					{
						
						if (CurrentCount=0) 
						{
							s CurrentCount=1
						}
						else
						{
							s CurrentCount=CurrentCount+1
							w ","
						}
						s TARICode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARICode)
						s TARIDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TARIDesc)
						w "{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_TARICode_""",""TARIDesc"":"""_TARIDesc_"""}" 
					}
				
				}
			}
		
		}
		w "],""total"":"""_count_""",""success"":""true""}"
	 }
	 q ""
}

/// Creator:陈莹
/// CreatDate:2016-04-01
/// Description:获取某条收费项目的信息
/// Table:User.DHCTarItem
/// Input:id
/// Return:Json格式的字符串str={list:[Code,Desc,RowId]}
/// Other:w ##class(web.DHCBL.CT.DHCTarItem).OpenData("11")
ClassMethod OpenData(id As %String, hospid As %String = "") As %String
{
	n (id,hospid)
	s str=""
	s TARIRowId=id
	s pobj = ##class(User.DHCTarItem).%OpenId(TARIRowId)
	s eobj = ##class(web.Entity.CT.DHCTarItem).%New()
	s eobj.TARIRowId = TARIRowId
	s eobj.TARICode = pobj.TARICode
	s eobj.TARIDesc = pobj.TARIDesc
	
	s eobj.TARIExternalCode = pobj.TARIExternalCode  //外部编码
	s eobj.TARIChargeBasis = pobj.TARIChargeBasis  //收费依据
	
	s eobj.TARIEngName = pobj.TARIEngName  //收费说明
	s eobj.TARIConnote = pobj.TARIConnote  //项目内涵
	s eobj.TARIRemark = pobj.TARIRemark  //备注
	s eobj.TARIExclude = pobj.TARIExclude  //除外内容
	s eobj.TARIPriceCode = pobj.TARIPriceCode  //物价编码
	s eobj.TARIPriceDesc = pobj.TARIPriceDesc  //物价名称
	s eobj.TARISpecialProcurementFlag = pobj.TARISpecialProcurementFlag  //特需项目标识
	s eobj.TARIRepeatedChargeFlag = pobj.TARIRepeatedChargeFlag  //不允许重复收费
	//s eobj.TARIInsuCode = pobj.TARIInsuCode  //国家医保编码
	//s eobj.TARIInsuName = pobj.TARIInsuName //医保名称
	s InsuInfo=##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo(TARIRowId,hospid)
	s eobj.TARIInsuCode = $p(InsuInfo,"^",1)  //国家医保编码  2022-04-11
	s eobj.TARIInsuName = $p(InsuInfo,"^",2)  //国家医保名称
	
	s eobj.TARIPriceRemark = pobj.TARIPriceRemark  //物价备注
	s eobj.TARIManufactorType = pobj.TARIManufactorType  //进口标志
	
	if $IsObject(pobj.TARIUOM){
		s eobj.TARIUOM = pobj.TARIUOM.%Id() 
		}
	if $IsObject(pobj.TARIOPERCategoryDR){
		s eobj.TARIOPERCategoryDR = pobj.TARIOPERCategoryDR.%Id()    //手术分级
		}

	if $IsObject(pobj.TARISubCate){
		s eobj.TARISubCate = pobj.TARISubCate.%Id() 
		}
	if $IsObject(pobj.TARIAcctCate){
		s eobj.TARIAcctCate = pobj.TARIAcctCate.%Id() 
		}
	if $IsObject(pobj.TARIOutpatCate){
		s eobj.TARIOutpatCate = pobj.TARIOutpatCate.%Id() 
		}
	
	if $IsObject(pobj.TARIEMCCate){
		s eobj.TARIEMCCate = pobj.TARIEMCCate.%Id() 
		}
	if $IsObject(pobj.TARIMRCate){
		s eobj.TARIMRCate = pobj.TARIMRCate.%Id() 
		}
	
	if $IsObject(pobj.TARIInpatCate){
		s eobj.TARIInpatCate = pobj.TARIInpatCate.%Id() 
		}
	if $IsObject(pobj.TARIItemCatDR){
		s eobj.TARIItemCatDR = pobj.TARIItemCatDR.%Id() 
		}	
	
	s eobj.TARIMCNew=$p($g(^DHCTARI(TARIRowId)),"^",30)   ;pobj.TARIMCNew   ;新病案首页 有些项目是没有字段的

	s:pobj.TARISpecialFlag="Y" eobj.TARISpecialFlag="true" //checkbox
	s:pobj.TARISpecialProcurementFlag="Y" eobj.TARISpecialProcurementFlag="true" //checkbox
	s:pobj.TARIRepeatedChargeFlag="Y" eobj.TARIRepeatedChargeFlag="true" //checkbox
	
	s:pobj.TARIActiveFlag="Y" eobj.TARIActiveFlag="true"
	if ((pobj.TARIEndDate'="")&&(pobj.TARIEndDate<+$h)) s eobj.TARIActiveFlag="false"  //2020-07-02 开始日期结束日期不在有效范围内时有效标志显示N
	s eobj.TARIStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.TARIStartDate)
	s eobj.TARIEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.TARIEndDate)


	d pobj.%Close()
	k pobj
	/*s eobj.TARICode=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARICode)
	s eobj.TARIDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIDesc)
	s eobj.TARIInsuName=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIInsuName)
	s eobj.TARIExternalCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIExternalCode)
	s eobj.TARIChargeBasis=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIChargeBasis)
	s eobj.TARIEngName=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIEngName)	
	s eobj.TARIConnote =##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIConnote)  //项目内涵
	s eobj.TARIRemark = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIRemark)  //备注
	s eobj.TARIExclude = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIExclude)  //除外内容
	s eobj.TARIInsuCode = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIInsuCode)  //国家医保编码
	*/
	s str = eobj.JsonS()
	s str=$tr(str,$c(0),"") //北京老年医院有TARIEngName为$c(0)的数据
	s str = "{list:["_str_"]}"
	q str
}

/// Function: 找到一个分类下包括自己在内的所有分类id 无论嵌套几层  ^id1^id2^
/// CreateDate: 2016-04-26
/// Creator: 基础数据平台组 - 陈莹
/// w ##class(web.DHCBL.CT.DHCTarItem).GetChildCatId("TreeRoot")
ClassMethod GetChildCatId(ParentCatId, rs) As %String
{
	
	n (ParentCatId,rs)
	if ParentCatId="TreeRoot" s ParentCatId=-100000000000000
	if rs="" s rs="^"_ParentCatId_"^"
	if (ParentCatId'="")
	{
		S childid=0
		for
		{
			s childid=$O(^User.BDPItemCategoryI("ParCatIdx",ParentCatId,childid)) q:childid=""
			s rs=rs_childid_"^"
			s rs=..GetChildCatId(childid,rs)
		}
	}
	q rs
}

/// Creator:陈莹
/// CreatDate:2016-04-01
/// Description:点击科目类别 ， 新增收费项获取最后一条数据的的默认值信息
/// Table:User.DHCTarItem
/// Input:HiddenCat 左侧树节点的rowid  6^8，type：树的类型，如会计费用类别，rowid：收费项rowid,不为空时为复制收费项
/// Return:Json格式的字符串str={list:[Code,Desc,RowId]}
/// Other:w ##class(web.DHCBL.CT.DHCTarItem).AddOpenData("2","ItemCat","")
ClassMethod AddOpenData(HiddenCat, type, rowid, hospid As %String = "") As %String
{
	n (HiddenCat,rowid,type,hospid)
	s str=""
	
	
	s eobj = ##class(web.Entity.CT.DHCTarItem).%New()
	s eobj.TARIRowId = ""
	if type="" s type="ItemCat"
	s CatStr=""
	if (type="ItemCat") s CatStr=HiddenCat
	s eobj.TARICode =##class(web.DHCBL.CT.DHCTarItem).AutoCreateCode(CatStr)
	s eobj.TARIActiveFlag="true"
	s eobj.TARIStartDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	s eobj.TARIEndDate = ""
	
	if (rowid'="")
	{
		s pobj = ##class(User.DHCTarItem).%OpenId(rowid)
		s eobj.TARIRowId = ""
		///s:eobj.TARICode="" eobj.TARICode =pobj.TARICode
		s eobj.TARIDesc = pobj.TARIDesc
		
		s eobj.TARIExternalCode = pobj.TARIExternalCode  //外部编码
		s eobj.TARIChargeBasis = pobj.TARIChargeBasis
		
		s eobj.TARIEngName = pobj.TARIEngName  //收费说明
		s eobj.TARIConnote = pobj.TARIConnote  //项目内涵
		s eobj.TARIRemark = pobj.TARIRemark  //备注
		s eobj.TARIExclude = pobj.TARIExclude  //除外内容
		s eobj.TARIPriceCode = pobj.TARIPriceCode  //物价编码
		s eobj.TARIPriceDesc = pobj.TARIPriceDesc  //物价名称
		s eobj.TARISpecialProcurementFlag = pobj.TARISpecialProcurementFlag  //特需项目标识
		s eobj.TARIRepeatedChargeFlag = pobj.TARIRepeatedChargeFlag  //不允许重复收费
		//s eobj.TARIInsuCode = pobj.TARIInsuCode  //国家医保编码
		//s eobj.TARIInsuName = pobj.TARIInsuName //医保名称
		s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(hospid,"DHC_TarItem")
		if Config="INSU"
		{
			
		}
		else
		{
			s eobj.TARIInsuCode = pobj.TARIInsuCode  //国家医保编码
			s eobj.TARIInsuName = pobj.TARIInsuName //医保名称
		}
		
		s eobj.TARIPriceRemark = pobj.TARIPriceRemark  //物价备注
		s eobj.TARIManufactorType = pobj.TARIManufactorType  //进口标志
		if $IsObject(pobj.TARIUOM){
			s eobj.TARIUOM = pobj.TARIUOM.%Id() 
			}
		if $IsObject(pobj.TARIOPERCategoryDR){
			s eobj.TARIOPERCategoryDR = pobj.TARIOPERCategoryDR.%Id()    //手术分级
		}
		if $IsObject(pobj.TARISubCate){
			s eobj.TARISubCate = pobj.TARISubCate.%Id() 
			}
		if $IsObject(pobj.TARIAcctCate){
			s eobj.TARIAcctCate = pobj.TARIAcctCate.%Id() 
			}
		if $IsObject(pobj.TARIOutpatCate){
			s eobj.TARIOutpatCate = pobj.TARIOutpatCate.%Id() 
			}

		if $IsObject(pobj.TARIEMCCate){
			s eobj.TARIEMCCate = pobj.TARIEMCCate.%Id() 
			}
		if $IsObject(pobj.TARIMRCate){
			s eobj.TARIMRCate = pobj.TARIMRCate.%Id() 
			}

		if $IsObject(pobj.TARIInpatCate){
			s eobj.TARIInpatCate = pobj.TARIInpatCate.%Id() 
			}
		if $IsObject(pobj.TARIItemCatDR){
			s eobj.TARIItemCatDR = pobj.TARIItemCatDR.%Id() 
			}	

		s eobj.TARIMCNew=$p($g(^DHCTARI(rowid)),"^",30)   ///string类型 不是dr
		d pobj.%Close()
		k pobj
	
	}
	else
	{
		
		s HiddenCat1=$p(HiddenCat,"^",2)
		s TARIRowId=""
		if (HiddenCat'="")
		{
			if (type="ItemCat")
			{
				s eobj.TARIItemCatDR =HiddenCat
				s TARIRowId=$o(^DHCTARI(0,"SIC",HiddenCat,""),-1)
			}
			if (type="DHCTarCate")  
			{
				s eobj.TARISubCate = HiddenCat1
				if (HiddenCat1'="")  s TARIRowId=$o(^DHCTARI(0,"SC",HiddenCat1,""),-1)
			}
			if (type="DHCTarAC")
			{
				s eobj.TARIAcctCate =HiddenCat1
				if (HiddenCat1'="") s TARIRowId=$o(^DHCTARI(0,"AC",HiddenCat1,""),-1)
			}
			if (type="DHCTarOC")
			{
				s eobj.TARIOutpatCate = HiddenCat1
				if (HiddenCat1'="") s TARIRowId=$o(^DHCTARI(0,"OC",HiddenCat1,""),-1)
			}
			if (type="DHCTarIC")
			{
				s eobj.TARIInpatCate =HiddenCat1
				if (HiddenCat1'="") s TARIRowId=$o(^DHCTARI(0,"IC",HiddenCat1,""),-1)
			}
			if (type="DHCTarEC")
			{
				s eobj.TARIEMCCate =HiddenCat1
				if (HiddenCat1'="") s TARIRowId=$o(^DHCTARI(0,"EC",HiddenCat1,""),-1)
			}
			if (type="DHCTarMC")
			{
				s eobj.TARIMRCate =HiddenCat1
				if (HiddenCat1'="") s TARIRowId=$o(^DHCTARI(0,"MC",HiddenCat1,""),-1)
				
			}
			if (type="DHCTarMCNew")
			{	
				s eobj.TARIMCNew=HiddenCat1 ///string类型 不是dr
				if (HiddenCat1'="") s TARIRowId=$o(^DHCTARI(0,"MCNew",HiddenCat1,""),-1)	
			}
			if (TARIRowId'="")
			{
				s pobj = ##class(User.DHCTarItem).%OpenId(TARIRowId)
				s eobj.TARIExternalCode = pobj.TARIExternalCode  //外部编码
				s eobj.TARIChargeBasis = pobj.TARIChargeBasis
				
				s eobj.TARIEngName = pobj.TARIEngName  //收费说明
				s eobj.TARIConnote = pobj.TARIConnote  //项目内涵
				s eobj.TARIRemark = pobj.TARIRemark  //备注
				s eobj.TARIExclude = pobj.TARIExclude  //除外内容
				s eobj.TARIPriceCode = pobj.TARIPriceCode  //物价编码
				s eobj.TARIPriceDesc = pobj.TARIPriceDesc  //物价名称
				s eobj.TARISpecialProcurementFlag = pobj.TARISpecialProcurementFlag  //特需项目标识
				s eobj.TARIRepeatedChargeFlag = pobj.TARIRepeatedChargeFlag  //不允许重复收费
				//s eobj.TARIInsuCode = pobj.TARIInsuCode  //国家医保编码
				//s eobj.TARIInsuName = pobj.TARIInsuName //医保名称
				s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(hospid,"DHC_TarItem")
				if Config="INSU"
				{
					
				}
				else
				{
					s eobj.TARIInsuCode = pobj.TARIInsuCode  //国家医保编码
					s eobj.TARIInsuName = pobj.TARIInsuName //医保名称
				}
				s eobj.TARIPriceRemark = pobj.TARIPriceRemark  //物价备注
				s eobj.TARIManufactorType = pobj.TARIManufactorType  //进口标志
				if $IsObject(pobj.TARIUOM){
					s eobj.TARIUOM = pobj.TARIUOM.%Id() 
					}
				if $IsObject(pobj.TARIOPERCategoryDR){
					s eobj.TARIOPERCategoryDR = pobj.TARIOPERCategoryDR.%Id()    //手术分级
				}
				if $IsObject(pobj.TARISubCate){
					s eobj.TARISubCate = pobj.TARISubCate.%Id() 
					}
				if $IsObject(pobj.TARIAcctCate){
					s eobj.TARIAcctCate = pobj.TARIAcctCate.%Id() 
					}
				if $IsObject(pobj.TARIOutpatCate){
					s eobj.TARIOutpatCate = pobj.TARIOutpatCate.%Id() 
					}

				if $IsObject(pobj.TARIEMCCate){
					s eobj.TARIEMCCate = pobj.TARIEMCCate.%Id() 
					}
				if $IsObject(pobj.TARIMRCate){
					s eobj.TARIMRCate = pobj.TARIMRCate.%Id() 
					}

				if $IsObject(pobj.TARIInpatCate){
					s eobj.TARIInpatCate = pobj.TARIInpatCate.%Id() 
					}
				if $IsObject(pobj.TARIItemCatDR){
					s eobj.TARIItemCatDR = pobj.TARIItemCatDR.%Id() 
					}	

				s eobj.TARIMCNew=$p($g(^DHCTARI(TARIRowId)),"^",30)   ///string类型 不是dr
			
				d pobj.%Close()
				k pobj
			}
		}
	}
	/*s eobj.TARICode=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARICode)
	s eobj.TARIDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIDesc)
	s eobj.TARIInsuName=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIInsuName)
	s eobj.TARIExternalCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIExternalCode)
	s eobj.TARIChargeBasis=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIChargeBasis)
	s eobj.TARIEngName=##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIEngName)
	
	
	s eobj.TARIConnote =##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIConnote)  //项目内涵
	s eobj.TARIRemark =##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIRemark)  //备注
	s eobj.TARIExclude =##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIExclude)  //除外内容
	s eobj.TARIInsuCode =##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.TARIInsuCode)  //国家医保编码
	*/
	s str = eobj.JsonS()
	s str=$tr(str,$c(0),"")
	s str=$tr(str,$c(13),"")
	s str=$tr(str,$c(10),"")
	s str = "{list:["_str_"]}"
	q str
}

/// 判断医嘱项是否已经有开出医嘱 
/// Return:Y:是，N:否
/// w ##class(web.DHCBL.CT.DHCTarItem).GetOrderLinkFlag("1||1")
ClassMethod GetOrderLinkFlag(OLTARCIMDR) As %String
{
	n (OLTARCIMDR)
	q:OLTARCIMDR="" "N"
	s OrderFlag="Y"
 	i $d(^DHCPBi(0,"ARCIM",OLTARCIMDR)) s OrderFlag="Y"
 	e  s OrderFlag="N"
 	q OrderFlag
}

/// Creator:陈莹
/// CreatDate:2016-04-14
/// Description:保存收费项目的信息
/// Table:User.DHCTarItem
/// Input:id
/// Return:
/// Other:w ##class(web.DHCBL.CT.DHCTarItem).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.DHCTarItem) As %String
{
	n (eobj,%session)
	s qresult=""
	if $IsObject(eobj)
	{
		s:eobj.TARIStartDate'="" eobj.TARIStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TARIStartDate)
		s:eobj.TARIEndDate'="" eobj.TARIEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.TARIEndDate)
		
		s:eobj.TARISpecialFlag="" eobj.TARISpecialFlag="N" //checkbox
		s:eobj.TARISpecialProcurementFlag="" eobj.TARISpecialProcurementFlag="N" //checkbox
		s:eobj.TARIRepeatedChargeFlag="" eobj.TARIRepeatedChargeFlag="N" //checkbox
		s:eobj.TARIActiveFlag="" eobj.TARIActiveFlag="N"
		s:eobj.TARIStartDate="" eobj.TARIStartDate=+$h
		
		///代码自动转换大写
		//s:eobj.TARICode'="" eobj.TARICode=$zcvt(eobj.TARICode,"U")
		//if (eobj.TARISubCate="")||(eobj.TARIInpatCate="")||(eobj.TARIAcctCate="")||(eobj.TARIOutpatCate="")||(eobj.TARIEMCCate="")||(eobj.TARIMCNew="")||(eobj.TARIMRCate="")
		//{
		//	s eobj.TARIActiveFlag="N"
		//}
		if (eobj.TARIEndDate="")&&(eobj.TARIActiveFlag="N") s eobj.TARIEndDate=+$h   ///2017-05-03 
		S valideflag= ##class(web.DHCBL.CT.DHCTarItem).FormValidate(eobj.TARIRowId,eobj.TARICode,eobj.TARIDesc,eobj.LinkHospId)
		if (valideflag=0) //判断代码或描述是否重复
		{
			//增加
			if (eobj.TARIRowId="")       
			{
				s obj=##class(User.DHCTarItem).%New()
			}
			//如果RowId已赋值则修改
			else                           
			{
			
				s obj=##class(User.DHCTarItem).%OpenId(eobj.TARIRowId)
				s bobj=##class(web.Entity.CT.DHCTarItem).%New()
			
				s bobj.TARIRowId=eobj.TARIRowId
				s bobj.TARICode = obj.TARICode                     
				s bobj.TARIDesc= obj.TARIDesc          
				s bobj.TARIInsuName= obj.TARIInsuName 
				s bobj.TARIExternalCode= obj.TARIExternalCode 
				s bobj.TARIEngName= $tr(obj.TARIEngName,$c(0),"") 
				
				s bobj.TARIChargeBasis= obj.TARIChargeBasis
				s bobj.TARIStartDate = obj.TARIStartDate 
				s bobj.TARIEndDate=obj.TARIEndDate
				s bobj.TARISpecialFlag=obj.TARISpecialFlag
				s bobj.TARIActiveFlag=obj.TARIActiveFlag
				if $IsObject(obj.TARIUOM){
					s bobj.TARIUOM = obj.TARIUOM.%Id() 
				}
				if $IsObject(obj.TARIOPERCategoryDR){
					s bobj.TARIOPERCategoryDR = obj.TARIOPERCategoryDR.%Id()    //手术分级
				}
				if $IsObject(obj.TARISubCate){
					s bobj.TARISubCate = obj.TARISubCate.%Id() 
				}
				if $IsObject(obj.TARIInpatCate){
					s bobj.TARIInpatCate = obj.TARIInpatCate.%Id() 
				}
				if $IsObject(obj.TARIEMCCate){
					s bobj.TARIEMCCate = obj.TARIEMCCate.%Id() 
				}
				if $IsObject(obj.TARIAcctCate){
					s bobj.TARIAcctCate = obj.TARIAcctCate.%Id() 
				}
				if $IsObject(obj.TARIOutpatCate){
					s bobj.TARIOutpatCate = obj.TARIOutpatCate.%Id() 
				}
				if $IsObject(obj.TARIMRCate){
					s bobj.TARIMRCate = obj.TARIMRCate.%Id() 
				}
				if $IsObject(obj.TARIItemCatDR){
					s bobj.TARIItemCatDR = obj.TARIItemCatDR.%Id() 
				}
				s bobj.TARIMCNew =$p($g(^DHCTARI(eobj.TARIRowId)),"^",30)
				s bobj.TARIConnote = obj.TARIConnote  //项目内涵
				s bobj.TARIRemark = obj.TARIRemark  //备注
				s bobj.TARIExclude = obj.TARIExclude  //除外内容
				s bobj.TARIPriceCode = obj.TARIPriceCode  //物价编码
				s bobj.TARIPriceDesc = obj.TARIPriceDesc  //物价名称
				s bobj.TARISpecialProcurementFlag = obj.TARISpecialProcurementFlag  //特需项目标识
				s bobj.TARIRepeatedChargeFlag = obj.TARIRepeatedChargeFlag  //不允许重复收费
				s bobj.TARIInsuCode = obj.TARIInsuCode  //国家医保编码
				s bobj.TARIPriceRemark = obj.TARIPriceRemark  //物价备注
				s bobj.TARIManufactorType = obj.TARIManufactorType  //进口标志
				
			}	
			
			s obj.TARICode = eobj.TARICode                      //修改代码
			s obj.TARIDesc= eobj.TARIDesc                      //修改描述
			
			s obj.TARIExternalCode= eobj.TARIExternalCode 
			s obj.TARIEngName= eobj.TARIEngName 
			s obj.TARIChargeBasis= eobj.TARIChargeBasis
			s obj.TARIStartDate = eobj.TARIStartDate 
			s obj.TARIEndDate=eobj.TARIEndDate
			s obj.TARISpecialFlag=eobj.TARISpecialFlag
			s obj.TARIActiveFlag=eobj.TARIActiveFlag
		
			d:eobj.TARIUOM'="" obj.TARIUOMSetObjectId(eobj.TARIUOM)
			d:eobj.TARIUOM="" obj.TARIUOMSetObjectId("")
		
			d:eobj.TARISubCate'="" obj.TARISubCateSetObjectId(eobj.TARISubCate)
			d:eobj.TARISubCate="" obj.TARISubCateSetObjectId("")
			d:eobj.TARIInpatCate'="" obj.TARIInpatCateSetObjectId(eobj.TARIInpatCate)
			d:eobj.TARIInpatCate="" obj.TARIInpatCateSetObjectId("")
			d:eobj.TARIAcctCate'="" obj.TARIAcctCateSetObjectId(eobj.TARIAcctCate)
			d:eobj.TARIAcctCate="" obj.TARIAcctCateSetObjectId("")
			d:eobj.TARIOutpatCate'="" obj.TARIOutpatCateSetObjectId(eobj.TARIOutpatCate)
			d:eobj.TARIOutpatCate="" obj.TARIOutpatCateSetObjectId("")
			d:eobj.TARIEMCCate'="" obj.TARIEMCCateSetObjectId(eobj.TARIEMCCate)
			d:eobj.TARIEMCCate="" obj.TARIEMCCateSetObjectId("")
		
			d:eobj.TARIMRCate'="" obj.TARIMRCateSetObjectId(eobj.TARIMRCate)
			d:eobj.TARIMRCate="" obj.TARIMRCateSetObjectId("")		
			
			///科目类别
			d:eobj.TARIItemCatDR'="" obj.TARIItemCatDRSetObjectId(eobj.TARIItemCatDR)
			d:eobj.TARIItemCatDR="" obj.TARIItemCatDRSetObjectId("")
			
			
			s obj.TARIConnote = eobj.TARIConnote  //项目内涵
			s obj.TARIRemark = eobj.TARIRemark  //备注
			s obj.TARIExclude = eobj.TARIExclude  //除外内容
			d obj.TARIOPERCategoryDRSetObjectId(eobj.TARIOPERCategoryDR)  //手术分级	
			s obj.TARIPriceCode = eobj.TARIPriceCode  //物价编码
			s obj.TARIPriceDesc = eobj.TARIPriceDesc  //物价名称
			s obj.TARISpecialProcurementFlag = eobj.TARISpecialProcurementFlag  //特需项目标识
			s obj.TARIRepeatedChargeFlag = eobj.TARIRepeatedChargeFlag  //不允许重复收费
			//s obj.TARIInsuName= eobj.TARIInsuName 
			//s obj.TARIInsuCode = eobj.TARIInsuCode  //国家医保编码
			s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(eobj.LinkHospId,"DHC_TarItem")
			if Config="INSU"
			{
				
			}
			else
			{
				s obj.TARIInsuName= eobj.TARIInsuName 
				s obj.TARIInsuCode = eobj.TARIInsuCode  //国家医保编码
			}
		
			s obj.TARIPriceRemark = eobj.TARIPriceRemark  //物价备注
			s obj.TARIManufactorType = eobj.TARIManufactorType  //进口标志		
			Tstart
			s sc=obj.%Save()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				s $p(^DHCTARI(id),"^",30)=eobj.TARIMCNew      ;;新病案首页 有些项目是没有字段的
				s qresult = "{success:'true',id:'"_id_"'}"        //保存数据后,通过RowId返回到这条数据
			
				if (eobj.TARIRowId="")
				{
					//开启医院级授权后，收费项添加关联医院
					s flag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
					if (flag="Y")
					{
						d ##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP("DHC_TarItem",id,eobj.LinkHospId)
					}
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItem","User.DHCTarItem","收费项目",id,eobj.TARIDesc,"A",eobj)
			
					///2017-04-07
					s aliasobj=##class(User.DHCTarItemAlias).%New()
					s aliasobj.TIAAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TARIDesc)
					d aliasobj.TIATARIDRSetObjectId(id)
					s aliasobj.TIADesc = eobj.TARIDesc
					s sc=aliasobj.%Save()
					do aliasobj.%Close()					
					//33 NewTarExpYJPTBM   //DHC_TaritemExpInfo
			
			
					;打印名称 同仁医院使用
					/*s TariExpRowID=$o(^DHCTARIEXPINFO(0,"TARI",id,0))
					if (TariExpRowID="")
					{
						s TariExpRowID=$o(^DHCTARIEXPINFO(""),-1)+1
						s $p(^DHCTARIEXPINFO(TariExpRowID),"^",1)=id
						s $p(^DHCTARIEXPINFO(TariExpRowID),"^",28)=eobj.TariExpPrintName
						s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
					}
					elseif(TariExpRowID'="")
					{
						s $p(^DHCTARIEXPINFO(TariExpRowID),"^",1)=id
						s $p(^DHCTARIEXPINFO(TariExpRowID),"^",28)=eobj.TariExpPrintName
						s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
					}	
					*/
			
				}
				else
				{
			
			
					d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_TarItem","User.DHCTarItem","收费项目",eobj.TARIRowId,eobj.TARIDesc,"U",eobj,bobj)
				
					if ( bobj.TARIDesc'=eobj.TARIDesc)
					{
						///2017-04-07
						s aliasobj=##class(User.DHCTarItemAlias).%New()
						s aliasobj.TIAAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.TARIDesc)
						d aliasobj.TIATARIDRSetObjectId(id)
						s aliasobj.TIADesc = eobj.TARIDesc
						s sc=aliasobj.%Save()
						do aliasobj.%Close()	
					
					}
					;打印名称 同仁医院使用
					/*s TariExpRowID=$o(^DHCTARIEXPINFO(0,"TARI",id,0))
					if (TariExpRowID="")
					{
						s TariExpRowID=$o(^DHCTARIEXPINFO(""),-1)+1
						s ^DHCTARIEXPINFO(TariExpRowID)=id_"^^^^^^^^^^^^^^^^^^^^^^^^^^^"_eobj.TariExpPrintName
						s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
					}
					elseif(TariExpRowID'="")
					{
						s ^DHCTARIEXPINFO(TariExpRowID)=id_"^^^^^^^^^^^^^^^^^^^^^^^^^^^"_eobj.TariExpPrintName
						s ^DHCTARIEXPINFO(0,"TARI",id,TariExpRowID)=""
					}	
					*/
			
				}
			
			}else{
				Trollback
				s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目","web.DHCBL.CT.DHCTarItem","SaveEntity",eobj)
 				s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			}
		}
		else //如果重复
		{
			s qresult="{success:'false',errorinfo:'收费项目代码或描述已经存在，请重新填写！'}"
		}
	}
	else
	{
		s qresult = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q qresult
}

/// Creator:陈莹
/// CreatDate:2017-07-12
/// Description:对存储方式为%CacheSQLStorage ,%Library.CacheSQLStorage类型的表，根据索引名 获取具体索引
/// Table:
/// Input:
/// Return:
/// Other:W ##class(web.DHCBL.CT.DHCTarItem).GetSubStringByName("User.DHCTarItem","INDEXCode")
ClassMethod GetSubStringByName(AllClassName, Name) As %String
{
	n (AllClassName,Name)
	s subString=""
	set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(AllClassName,0)
	if (dcd'="")
	{
		set dsd=dcd.Storages
		set dsdCount=dsd.Count()
		for j=1:1:dsdCount
		{
			s storage = dsd.GetAt(j)
			s storageType = storage.Type
			s sqlMapsID = storage.SQLMaps  ///%CacheSQLStorage ,%Library.CacheSQLStorage
			s sqlMapsCount=sqlMapsID.Count()
			for i=1:1:sqlMapsCount
			{
				set sqlMapID=sqlMapsID.GetAt(i)
				set type=sqlMapID.Type
				set indexName=sqlMapID.Name
				if indexName=Name
				{
					s subScripts=sqlMapID.Subscripts
					s subString=""
					s subCnt=subScripts.Count(),subString="("
					for k=1:1:subCnt {
						set subScript=subScripts.GetAt(k)	
						set expr=subScript.Expression
						set subString=subString_""_expr_","
					}
					set $e(subString,$l(subString))=""   //去掉最后的逗号
					s subString=subString_")"
				}
				
			}	
		
		}
	}
	q subString
}

/// Creator:陈莹
/// CreatDate:2015-5-11  @20170215
/// Description:数据重复验证方法,js调用
/// Table:User.DHCTarItem
/// Input:id, code, desc,hospid(医院id）
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:W ##class(web.DHCBL.CT.DHCTarItem).FormValidate("","A01AB5101","复方氯己定含漱液(口泰)[200ml]",2)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	new (id,code,desc,hospid)	
	s flag=0
	if code'=""
	{
		//$ZCONVERT(desc,"U")
		//$$ALPHAUP^SSUTIL4(desc)
		s idc=0
		for
		{
			s idc=$o(^DHCTARI(0,"Code",code,idc)) q:idc=""
			s TARICode=$p($g(^DHCTARI(idc)),"^",1)
			if (code=TARICode)&&((id="")||((id'="")&&(idc'=id)))
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	if $p($g(^Config.BDP(..#SQLTableName,+hospid)),"^",5)'="false"
	{
		if desc'="" 
		{
			//$ZCONVERT(desc,"U")
			//$$ALPHAUP^SSUTIL4(desc)
			s idd=0
			for
			{
				s idd=$o(^DHCTARI(0,"Desc",desc,idd)) q:idd=""
				s TARIDesc=$p($g(^DHCTARI(idd)),"^",2)
				s TARIActiveFlag=$p($g(^DHCTARI(idd)),"^",7)
				s TARIEndDate =$p($g(^DHCTARI(idd)),"^",12) ///结束日期
				if ((TARIEndDate'="")&&(TARIEndDate<+$h)) s TARIActiveFlag="N"  //2020-09-11 开始日期结束日期不在有效范围内时有效标志显示N
				continue:TARIActiveFlag="N"
				if (desc=TARIDesc)&&((id="")||((id'="")&&(idd'=id)))
				{
					s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
					continue:showflag="N"
					s flag=1
				}
			}
		}
	}
		
	q flag
}

/// Function: 增加收费项的时候同步 添加医嘱项 并关联
/// CreateDate: 2016-4-15
/// Creator:陈莹
/// Input: AddOrdLinkTar:数量1^开始日期2^结束日期3     ArcItmMastStr:代码1^描述2^单位3^医嘱子分类4^账单子组5^优先级6^独立医嘱7^无库存医嘱8^加急医嘱9^开始日期10^截止日期11
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).SyncAddARCItmMast("bb^bb^^204^59^59||1^16^1^false^false^^^^^^","","1^2016/03/22^")
ClassMethod SyncAddARCItmMast(ArcItmMastStr, TARIRowId, AddOrdLinkTar) As %String
{
	n (ArcItmMastStr,TARIRowId,AddOrdLinkTar,%session)

	s eobj=##class(web.Entity.CT.ARCItmMast).%New()
	s eobj.ARCIMCode=$p(ArcItmMastStr,"^",1)  
	s eobj.ARCIMDesc=$p(ArcItmMastStr,"^",2)
	s eobj.ARCIMCode =##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMCode)
	s eobj.ARCIMDesc =##class(web.DHCBL.BDP.FunLib).Util(eobj.ARCIMDesc)		                                        

	s eobj.ARCIMBillingUOMDR=$p(ArcItmMastStr,"^",3)     ;账单单位 
	s eobj.ARCIMItemCatDR=$p(ArcItmMastStr,"^",4)        ;医嘱子分类   
	s eobj.ARCIMBillSubDR= $p(ArcItmMastStr,"^",5)       ;帐单子组
	s eobj.ARCIMDefPriorityDR=$p(ArcItmMastStr,"^",6)    ;默认优先级
	
	s eobj.ARCIMOrderOnItsOwn=$p(ArcItmMastStr,"^",7)    ;独立医嘱
	if (eobj.ARCIMOrderOnItsOwn="true")||(eobj.ARCIMOrderOnItsOwn="Y") s eobj.ARCIMOrderOnItsOwn="Y"
	else  s eobj.ARCIMOrderOnItsOwn="N"
	s eobj.ARCIMAllowOrderWOStockCheck=$p(ArcItmMastStr,"^",8)  ;无库存医嘱
	if (eobj.ARCIMAllowOrderWOStockCheck="true")||(eobj.ARCIMAllowOrderWOStockCheck="Y") s eobj.ARCIMAllowOrderWOStockCheck="Y"
	else  s eobj.ARCIMAllowOrderWOStockCheck="N"
	s eobj.ARCIMSensitive=$p(ArcItmMastStr,"^",9)        ;加急医嘱
	if (eobj.ARCIMSensitive="true")||(eobj.ARCIMSensitive="Y") s eobj.ARCIMSensitive="Y"
	else  s eobj.ARCIMSensitive="N"
	s eobj.ARCIMEffDate=$p(ArcItmMastStr,"^",10)         ;开始日期
	s eobj.ARCIMEffDateTo=$p(ArcItmMastStr,"^",11)   ;结束日期 
	s ARCIMAlias=$p(ArcItmMastStr,"^",12)  //医嘱项别名 2020-03-04
	s eobj.LinkHospId=$p(ArcItmMastStr,"^",13)  //医院
	
	s eobj.ARCIMAbbrev=$p(ArcItmMastStr,"^",14)  //医嘱缩写
	s eobj.ARCIMOEMessage=$p(ArcItmMastStr,"^",15)  //医嘱备注
	s eobj.ARCIMServMaterial=$p(ArcItmMastStr,"^",16)  //服务/材料
	s eobj.ARCIMDefSensitive=$p(ArcItmMastStr,"^",17)  //默认加急
	if (eobj.ARCIMDefSensitive="true")||(eobj.ARCIMDefSensitive="Y") s eobj.ARCIMDefSensitive="Y"
	else  s eobj.ARCIMDefSensitive="N"
	s result=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(eobj)
	if result["success:'true'"
	{
		 s Addarcimrowid= ##class(web.DHCBL.BDP.FunLib).GetResultRowId(result)
		 //增加收费项目、并关联医嘱项事务-04
		if (AddOrdLinkTar'="")  //^数量^开始日期^结束日期
		{
			s newAddOrdLinkTar=Addarcimrowid_"^"_TARIRowId_"^"_AddOrdLinkTar  //医嘱项rowid^收费项目dr^数量^开始日期^结束日期^基价标志
			s SaveRet=##class(web.DHCBL.CT.DHCOrderLinkTar).AddOrdLinkTar(newAddOrdLinkTar)
			if (SaveRet'["success:'true'" ) Quit "{success:'false',info:'医嘱项增加成功! 医嘱项与收费项目关联失败, 请重新关联!'}"
		}
		
		if ARCIMAlias'=""
		{
			s Aliaslength=$length(ARCIMAlias,"/")
			for i=1:1:Aliaslength 
			{
				s aliaseobj = ##class(web.Entity.CT.ARCAlias).%New()
				s aliaseobj.ALIASRowId=""
				s aliaseobj.ALIASARCIMDR=Addarcimrowid
				s aliaseobj.ALIASText=$P(ARCIMAlias,"/",i)
				s aliaseobj.ALIASDateFrom=$p(ArcItmMastStr,"^",10)
				s aliaseobj.ALIASDateTo=$p(ArcItmMastStr,"^",11)
				s Result=##class(web.DHCBL.CT.ARCAlias).SaveEntity(aliaseobj)
				if Result["success:'false'" s flag=1
			}
		}
	}
	else
	{
		Q result
		
	}
	
	Quit "{success:'true',id:'"_Addarcimrowid_"'}"
}

/// Function: 点击一条收费项 查询与这条收费项关联了的医嘱项信息 及医嘱项与收费项关联表信息
/// CreateDate: 2016-5-3
/// Creator:陈莹
/// Input: TarRowid 收费项rowid
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarItem","FindArcByTar",10,"","")
Query FindArcByTar(TarRowid, ARCIMCode, ARCIMDesc) As %Query(ROWSPEC = "TArcRowid:%String,TArcCode:%String,TArcDesc:%String,TOrderCatDesc,TArcItmCatDesc,TBillSubCatDesc,StDate:%String,EndDate:%String,LinkQty:%String,LinkStDate:%String,LinkEndDate:%String,OLTRowid:%String,Relation:%String,LinkHospial:%String")
{
}

ClassMethod FindArcByTarExecute(ByRef qHandle As %Binary, TarRowid, ARCIMCode, ARCIMDesc) As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	If TarRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	
	S:ARCIMCode'="" ARCIMCode=$ZCVT(ARCIMCode,"U")
	S:ARCIMDesc'="" ARCIMDesc=$ZCVT(ARCIMDesc,"U")
	
	Set tStDate=""
	For
	{
		Set tStDate=$o(^DHCOLT(0,"TAR",TarRowid,tStDate),-1) Quit:tStDate=""  Quit:tStDate=0
		Set OLTRowid=""
		For
		{
			Set OLTRowid=$o(^DHCOLT(0,"TAR",TarRowid,tStDate,OLTRowid),-1) Quit:OLTRowid=""  Quit:OLTRowid=0
			Set TArcRowid=$p($G(^DHCOLT(OLTRowid)),"^",1)
			Set (TArcCode,TArcDesc,TOrderCat,TArcItmCat,TBillCat)=""
			s ARCIMSubscript=$p(TArcRowid,"||",1)
	  		s ARCIMVersion=$p(TArcRowid,"||",2)
			Set TArcCode=$p($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
			Set TArcDesc=$p($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
			Set TBillCat=$p($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",9)
			Set TBillSubCatDesc=""
			If TBillCat'="" Set TBillSubCatDesc=$p($g(^ARCBG(+TBillCat,"SG",$p(TBillCat,"||",2))),"^",2)
			Set TArcItmCat=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
			Set TArcItmCatDesc=""
			If TArcItmCat'="" Set TArcItmCatDesc=$p($g(^ARC("IC",TArcItmCat)),"^",2)
			Set TOrderCat="",TOrderCatDesc=""
			If TArcItmCat'="" Set TOrderCat=$p($g(^ARC("IC",TArcItmCat)),"^",8)
			If TOrderCat'="" Set TOrderCatDesc=$p($g(^OEC("ORCAT",TOrderCat)),"^",2)
			Set StDate=$p($p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13),"Z",1)
			Set EndDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)
			If StDate'="" Set StDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StDate) 
			If EndDate'="" Set EndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EndDate) 
			/*Set TArcCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(TArcCode)
			Set TArcDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TArcDesc)
			Set TArcItmCatDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TArcItmCatDesc)
			Set TOrderCatDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TOrderCatDesc)
			Set TBillSubCatDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(TBillSubCatDesc)
			*/
			
			s LinkQty=$p($g(^DHCOLT(OLTRowid)),"^",3)
			s LinkStDate=$p($g(^DHCOLT(OLTRowid)),"^",4)
			s LinkEndDate=$p($g(^DHCOLT(OLTRowid)),"^",5)
			If LinkStDate'="" Set LinkStDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LinkStDate) 
			If LinkEndDate'="" Set LinkEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(LinkEndDate) 
			s Relation=0
			s LinkHospial=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospital("ARC_ItmMast",TArcRowid,"Desc")
			s tardr=0
			For
			{
				Set tardr=$o(^DHCOLT(0,"ARTTA",TArcRowid,tardr)) Quit:tardr=""
				s Relation=Relation+1
			}	
			
			if ($zcvt(TArcCode,"U")[ARCIMCode)&&($ZCVT(TArcDesc,"u")[ARCIMDesc)
			{
				Do OutputRowArcByTar
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowArcByTar
	Set Data=$lb(TArcRowid,TArcCode,TArcDesc,TOrderCatDesc,TArcItmCatDesc,TBillSubCatDesc,StDate,EndDate,LinkQty,LinkStDate,LinkEndDate,OLTRowid,Relation,LinkHospial)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindArcByTarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcByTarExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcByTarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcByTarExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：陈莹
/// CreatDate: 2016-5-6
/// Description：在将收费项置为无效时，需要获取与该收费项关联的医嘱项信息；
/// Input：收费项Rowid
/// Return：一条收费项只被一条医嘱项关联时，返回关联的医嘱项的rowid，一条收费项被多条医嘱项关联时 返回空
/// w ##class(web.DHCBL.CT.DHCTarItem).GetARCIMRowIdByTarid("11")
ClassMethod GetARCIMRowIdByTarid(tarirowid As %String) As %String
{
	n (tarirowid)
	s n=0
	Kill ArcArray
	s tStDate=""
	For
	{ 
		s tStDate=$o(^DHCOLT(0,"TAR",tarirowid,tStDate)) Quit:tStDate=""
		Quit:tStDate=0
		Set OLTRowid=""
		For
		{
			s OLTRowid=$o(^DHCOLT(0,"TAR",tarirowid,tStDate,OLTRowid)) Quit:OLTRowid=""
			Quit:OLTRowid=0
			s ARCIMRowId=$p($G(^DHCOLT(OLTRowid)),"^",1)
			Quit:$d(ArcArray(ARCIMRowId))
			s n=n+1
			s ARCIMSubscript=$p(ARCIMRowId,"||",1)
  			s ARCIMVersion=$p(ARCIMRowId,"||",2)
			s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
  			s ARCIMDesc=##class(web.DHCBL.BDP.FunLib).Util(ARCIMDesc)
  			s ArcArray(ARCIMRowId)=ARCIMDesc
		}
	}
	
	if (n=1)
	{
		s rs=ARCIMRowId
	}
	else
	{
		s rs=""
	}
	q rs
}

/// Creator：陈莹
/// CreatDate: 2016-5-6
/// Description：在将收费项置为无效时，将于该收费项关联的医嘱项结束日期置为明天
/// Input：医嘱项Rowid
/// Return：保存成功返回医嘱项描述，保存失败返回错误信息
/// w ##class(web.DHCBL.CT.DHCTarItem).EndLinkedARCIM("11||1","2017-05-10")
ClassMethod EndLinkedARCIM(LARCIMRowId As %String, enddate As %String = "") As %String
{
	s obj=##class(User.ARCItmMast).%OpenId(LARCIMRowId)
	s Desc=obj.ARCIMDesc
	if enddate'="" s enddate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(enddate)
	if enddate="" s enddate=+$h    ////2017-05-04由+$h+1 改成  +$h
	s eobj = ##class(web.Entity.CT.ARCItmMast).%New()
 	s eobj.ARCIMRowId=LARCIMRowId
 	s eobj.ARCIMCode=obj.ARCIMCode
 	s eobj.ARCIMDesc=obj.ARCIMDesc
 	s eobj.ARCIMEffDate=$p(obj.ARCIMEffDate,",",1)
 	s eobj.ARCIMEffDateTo=enddate         
 	s eobj.ARCIMUpdateDate=+$h
	s eobj.ARCIMUpdateTime=$p($h,",",2)
 	
 	s oobj = ##class(web.Entity.CT.ARCItmMast).%New()
 	s oobj.ARCIMRowId=LARCIMRowId
 	s oobj.ARCIMCode=obj.ARCIMCode
 	s oobj.ARCIMDesc=obj.ARCIMDesc
 	s oobj.ARCIMEffDate=$p(obj.ARCIMEffDate,",",1)
 	s oobj.ARCIMEffDateTo=obj.ARCIMEffDateTo
 	s oobj.ARCIMUpdateDate=obj.ARCIMUpdateDate
	s oobj.ARCIMUpdateTime=obj.ARCIMUpdateTime
	 s EffDateOld=$p(obj.ARCIMEffDate,",",1)
	 s EffDateToOld=obj.ARCIMEffDateTo
	 if (EffDateToOld="")   ///||((EffDateToOld'="")&&(EffDateToOld>(+$h+1)))
	 {
		 Set obj.ARCIMUpdateDate=+$h
		 Set obj.ARCIMUpdateTime=$p($h,",",2)
		 Set obj.ARCIMEffDateTo=enddate 
		 Set obj.ARCIMEffDate=$p(obj.ARCIMEffDate,",",1)    //唐山人民报错了。
	 	 s obj.ARCIMChgPostFlg="O"
		 Tstart
		 Set sc=obj.%Save()
		 If $$$ISERR(sc){
		    Trollback
		    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目","web.DHCBL.CT.DHCTarItem","EndLinkedARCIM",eobj)
     		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

		    Quit "{success:'false',info:'医嘱项结束日期修改失败, 请重新操作!'}"
		 }
		 else
		 {
		 	Tc
		 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项",LARCIMRowId,Desc,"U",eobj,oobj)
	 	
		 }
		 d obj.%Close()
		 ///ofy5 吉大三院  保存医嘱项的有效日期记录
		 s flag= ##class(websys.Conversions).IsValidClassName("web.DHCBL.CT.ARCItmMastUpdInfo")
		 if (flag=1)
		 { 	
		 	d ##class(web.DHCBL.CT.ARCItmMastUpdInfo).SaveData(LARCIMRowId,EffDateOld,enddate)	
		 }
 
	 }
	 q Desc
}

/// Creator：陈莹
/// CreatDate: 2016-5-6
/// Description：在将收费项置为无效时，可选择将医嘱项关联收费项的结束日期置为选择的结束日期
/// Input：oltrowid(医嘱项与收费项关联rowid)， enddate（结束日期)
/// Return：1（成功）,0（失败）
/// w ##class(web.DHCBL.CT.DHCTarItem).EndOrderLinkTar("111","2017-05-20")
ClassMethod EndOrderLinkTar(oltrowid As %String, enddate As %String) As %String
{
	n (oltrowid,enddate,%session)
	s obj=##class(User.DHCOrderLinkTar).%OpenId(oltrowid)
	if obj.OLTEndDate'=""  q "医嘱项与收费项的关联关系已经有截止日期，不能再次截止!"
	Set enddate1=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(enddate)
	if (enddate1'="")&&(enddate1<+$h) q "医嘱项与收费项关联表的结束日期生效时间为当天的24:00，不能早于今天!"
	
	s eobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
	s eobj.OLTRowId=oltrowid
	s eobj.OLTARCIMDR=$p($g(^DHCOLT(oltrowid)),"^",1)
	s eobj.OLTTariffDR=$p($g(^DHCOLT(oltrowid)),"^",2)
	s eobj.OLTQty= $p($g(^DHCOLT(oltrowid)),"^",3)
	s eobj.OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($p($g(^DHCOLT(oltrowid)),"^",4))
	s eobj.OLTEndDate=enddate
	s eobj.OLTBascPriceFlag=$p($g(^DHCOLT(oltrowid)),"^",8)
	s eobj.OLTBillOnceFlag=$p($g(^DHCOLT(oltrowid)),"^",9)
	s Ret=""
	s Result= ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "1^"
	else  s Ret=$p(Result,"errorinfo:",2)
	q Ret
}

/// Creator:chenying
/// CreatDate:2016-5-24
/// Description:收费项目界面，左侧树形列表，获取收费项各个大类-子类Tree类型的json串 分级加载 
/// Input：LastLevel 父节点id，
///        Type：DHCTarCate/收费项目分类,DHCTarAC/会计费用分类,DHCTarOC/门诊费用分类,DHCTarIC/住院费用分类,DHCTarEC/核算费用分类,DHCTarMC/病案首页分类,DHCTarMCNew/新病案首页分类,ItemCat/收费项目分类（树形）,OPERCategory/手术分级
/// Return：Json串
/// w ##class(web.DHCBL.CT.DHCTarItem).GetCategoryTreeJson("TreeRoot","DHCTarCate",2)
/// w ##class(web.DHCBL.CT.DHCTarItem).GetCategoryTreeJson("TreeRoot","DHCTarMCNew",2)
ClassMethod GetCategoryTreeJson(LastLevel As %String, Type As %String, hospid As %String = "") As %String
{
	n (LastLevel,Type,%session,hospid)
	//输出菜单JSON串
	s myJsonStr=""
	
	if Type="" S Type="DHCTarCate" //收费项目分类
		
	//收费项目分类(树形）
	if (Type="ItemCat")
	{
		
		if (LastLevel="TreeRoot") s LastLevel=-100000000000000
		s myJsonStr=""
		s myRowID=0
		s myCount=0
		s mySeq=0
		k myArray
	
		//生成菜单索引数组
		s mySeq=0
		s n=0
		for {
			s mySeq=$o(^User.BDPItemCategoryI("ParSeqIdx",LastLevel,mySeq))
			q:(mySeq="")
			s n=n+1
			s a(n)= $p(mySeq," ",2)
		}
		set left=1,right=n
		d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序
	
		s myRowID=0
		s n=0
		s mySeq=0
		for {
			s n=$o(a(n))
			q:(n="")
			s mySeq=$g(a(n))
			for {
				s myRowID=$o(^User.BDPItemCategoryI("ParSeqIdx",LastLevel," "_mySeq,myRowID))
				q:(myRowID="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("BDP_ItemCategory",myRowID,hospid)
				continue:showflag="N"
				s myCount=myCount+1
				s myArray(myCount)=myRowID
				;w !,myRowID
			}
		}

		//输出菜单JSON串
		s myRowID=0
		s mySeq=0
		s myJsonStr=""
	
		for {
			;q:(+mySeq>1)
			s mySeq=$o(myArray(mySeq))
			q:(mySeq="")
			s myRowID=$g(myArray(mySeq))
			
			s myObj=##Class(User.BDPItemCategory).%OpenId(myRowID,0)
			if $IsObject(myObj) {
				s myCode = myObj.Code
				s myDesc = myObj.Caption		
				s myActiveFlag = myObj.ActiveFlag
				s myType = myObj.Type
			
				if (myType=Type)&&(myActiveFlag="Y")
				{
			
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
				//	s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"

					s myJsonStr=myJsonStr_"}"
				}
				d myObj.%Close()
			}
		}
		k myArray

	
	}
	
	
	//收费项目分类
	if ((Type="DHCTarCate")||(Type=""))  //为空时默认为收费项目分类
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //DHC_TarCate
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarCate).DHCGetDataByDefaultSession()
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			
			s myRowId=0
			for 
			{
				s myRowId=$o(^DHCTarC("CC",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("CC",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					//s myJsonStr=myJsonStr_"""expanded"":true,"		
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else //DHC_TarSubCate
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarSubCate).DHCGetDataByDefaultSession()  //收费项目子类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("SC",0,"TCC",parentid,myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarSubCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("SC",myRowId)),"^",2)
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=LastLevel_myRowId
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","	
					s myJsonStr=myJsonStr_"""expanded"":false,"
					s myJsonStr=myJsonStr_"""leaf"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}
	}
	
	//会计费用大类3
	if (Type="DHCTarAC") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //DHC_TarAC
		{
			S AuStr=##class(web.DHCBL.Authorize.DHCTarAC).DHCGetDataByDefaultSession() //会计费用大类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("TAC",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarAC",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("TAC",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					//s myJsonStr=myJsonStr_"""expanded"":true,"		
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else  //DHC_TarAcctCate
		{
			
			s AuStr=##class(web.DHCBL.Authorize.DHCTarAcctCate).DHCGetDataByDefaultSession()  //会计费用子类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		

			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("AC",0,"TAC",parentid,myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarAcctCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("AC",myRowId)),"^",2)
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=LastLevel_myRowId
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","		
					s myJsonStr=myJsonStr_"""expanded"":false,"
					s myJsonStr=myJsonStr_"""leaf"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}
	}
	
	//门诊费用分类4
	if (Type="DHCTarOC") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //DHC_TarOC
		{
			S AuStr=##class(web.DHCBL.Authorize.DHCTarOC).DHCGetDataByDefaultSession() //门诊费用分类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("TOC",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarOC",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{

					s myDesc =$p($g(^DHCTarC("TOC",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else  //DHC_TarOutpatCate
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarOutpatCate).DHCGetDataByDefaultSession() //门诊费用子类 
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
		
			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("OC",0,"TOC",parentid,myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarOutpatCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("OC",myRowId)),"^",2)
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=LastLevel_myRowId
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","		
					s myJsonStr=myJsonStr_"""expanded"":false,"
					s myJsonStr=myJsonStr_"""leaf"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}
	}
	
	//住院费用分类5
	if (Type="DHCTarIC") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //DHC_TarIC
		{
			S AuStr=##class(web.DHCBL.Authorize.DHCTarIC).DHCGetDataByDefaultSession() //住院费用分类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("TIC",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("TIC",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else  //DHC_TarInpatCate
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarInpatCate).DHCGetDataByDefaultSession()  //住院费用子类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("IC",0,"TIC",parentid,myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarInpatCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("IC",myRowId)),"^",2)
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=LastLevel_myRowId
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","		
					s myJsonStr=myJsonStr_"""expanded"":false,"
					s myJsonStr=myJsonStr_"""leaf"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}
	}
	
	//核算费用分类6
	if (Type="DHCTarEC") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //DHC_TarEC
		{
			S AuStr=##class(web.DHCBL.Authorize.DHCTarEC).DHCGetDataByDefaultSession() //核算费用分类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("TEC",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarEC",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("TEC",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else  //DHC_TarEMCCate
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarEMCCate).DHCGetDataByDefaultSession()  //经济核算子类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("EC",0,"TEC",parentid,myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarEMCCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("EC",myRowId)),"^",2)
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=LastLevel_myRowId
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","		
					s myJsonStr=myJsonStr_"""expanded"":false,"
					s myJsonStr=myJsonStr_"""leaf"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}
	}
	
	//旧病案首页分类7
	if (Type="DHCTarMC") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //DHC_TarMC
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarMC).DHCGetDataByDefaultSession() //旧病案首页分类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("TMC",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMC",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("TMC",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else  //DHC_TarMRCate
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCTarMRCate).DHCGetDataByDefaultSession()  //病案首页子类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
		
			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("MC",0,"TMC",parentid,myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMRCate",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("MC",myRowId)),"^",2)
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=LastLevel_myRowId
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","		
					s myJsonStr=myJsonStr_"""expanded"":false,"
					s myJsonStr=myJsonStr_"""leaf"":true"
					s myJsonStr=myJsonStr_"}"
				}
			}
		}
	}
	
	//新病案首页分类8
	if (Type="DHCTarMCNew") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //不对应表 只对应global
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCNewTarMC).DHCGetDataByDefaultSession() //新病案首页分类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("TMCNew",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMCNew",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDesc =$p($g(^DHCTarC("TMCNew",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		else  //不对应表 只对应global
		{
			s AuStr=##class(web.DHCBL.Authorize.DHCNewTarMRCate).DHCGetDataByDefaultSession() //新病案首页子类
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		
			s childid=$p(LastLevel,"&",2)
			Q:childid'="" "[]"
			s parentid=$p(LastLevel,"&",1)
			Q:parentid="" "[]"
			
			s myRowId=0
			for {
				s myRowId=$o(^DHCTarC("MCNew",myRowId))
				q:(myRowId="")
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarMCCateNew",myRowId,hospid)
				continue:showflag="N"
				s strRowId="{ID:"_myRowId_"}"
				if ((AuStr[strRowId)||(AuFlag=1))  ;用来筛选授权数据
				{
					s myDr =$p($g(^DHCTarC("MCNew",myRowId)),"^",3)
				
					if (myDr=parentid)
					{
						s myDesc =$p($g(^DHCTarC("MCNew",myRowId)),"^",2)
						s:(myJsonStr'="") myJsonStr=myJsonStr_","
						s myJsonStr=myJsonStr_"{"
						s mid=LastLevel_myRowId
						s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","		
						s myJsonStr=myJsonStr_"""expanded"":false,"
						s myJsonStr=myJsonStr_"""leaf"":true"
						s myJsonStr=myJsonStr_"}"
					}
				}
			}
		}
	}
	
	
	//手术分级  
	if (Type="OPERCategory") 
	{
		if ((LastLevel="TreeRoot")||(LastLevel=-100000000000000))  //根节点
		{
			s AuStr=##class(web.DHCBL.Authorize.ORCOperationCategory).DHCGetDataByDefaultSession()
			s AuFlag=0
			;未授权情况下，默认显示全部数据
			if (AuStr="")||(AuStr["limited:0") s AuFlag=1
			s myRowId=0
			for
			{
				s myRowId=$o(^ORC("CATEG",myRowId)) q:myRowId=""
				s strRowId="{ID:"_myRowId_"}"
				if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
				{
					
					s DateTo=$p($g(^ORC("CATEG",myRowId)),"^",4)
					continue:(DateTo'="")&&(DateTo<+$h)
					s myDesc =$p($g(^ORC("CATEG",myRowId)),"^",2)	
					s:(myJsonStr'="") myJsonStr=myJsonStr_","
					s myJsonStr=myJsonStr_"{"
					s mid=myRowId_"&"
					s myJsonStr=myJsonStr_"""id"":"""_""_mid_""",""text"":"""_myDesc_""","
					s myJsonStr=myJsonStr_"""leaf"":true,"
					s myJsonStr=myJsonStr_"""expanded"":false"
					s myJsonStr=myJsonStr_"}"
				}
			
			}
		}
		
	}
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator：陈莹
/// CreatDate: 2016-9-8
/// Description：河南省人民医院需求 保存医嘱项和收费项目时，将收费项代码 同步生成到医嘱项别名和收费项目别名
/// Input：
/// Return
/// w ##class(web.DHCBL.CT.DHCTarItem).SyncAlias("ACNAC001","444")
ClassMethod SyncAlias(TARICode, TARIRowId) As %String
{
	n (TARICode,TARIRowId,%session)
	Q:TARICode="" "1"
	Q:TARIRowId="" "2"
	s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARICode)
	s TARIDesc =$p($g(^DHCTARI(TARIRowId)),"^",2)
	s TARIDesc=##class(web.DHCBL.BDP.FunLib).Util(TARIDesc)
	
	s listData=""_"^"_PINYIN_"^"_TARIRowId_"^"_TARIDesc
	d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveAll(listData)
	s str=3
	s ARCIMRowId=##class(web.DHCBL.CT.DHCTarItem).GetARCIMRowIdByTarid(TARIRowId)
	if (ARCIMRowId'="")
	{
		s ARCIMSubscript=$p(ARCIMRowId,"||",1)
  		s ARCIMVersion=$p(ARCIMRowId,"||",2)
  		s orderdesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2) 
  		s orderdesc=##class(web.DHCBL.BDP.FunLib).Util(orderdesc)
  		
		s arcitemcatdr=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
		s aobj1=##class(User.ARCAlias).%New()
	    d aobj1.ALIASARCIMDRSetObjectId(ARCIMRowId)
	    s aobj1.ALIASText=TARICode
	    s aobj1.ALIASType="ARCIM" 
	    s aobj1.ALIASOrderOnItsOwn="Y" 
	    s aobj1.ALIASDateFrom=+$h
	    s aobj1.ALIASDesc=orderdesc
	    d:arcitemcatdr'="" aobj1.ALIASOrderSubCatDRSetObjectId(arcitemcatdr)
	    d:arcitemcatdr="" aobj1.ALIASOrderSubCatDRSetObjectId("")
    	s sc=aobj1.%Save()
		s str=4
	}
	q str
}

/// Creator：陈莹
/// CreatDate: 2016-9-8
/// Description：需要获取与该收费项关联的医嘱项Rowid；
/// Input：收费项Rowid
/// Return：返回关联的医嘱项的rowid （新增收费项时调用，所以最多只有一条医嘱项与其关联） 
/// w ##class(web.DHCBL.CT.DHCTarItem).GetARCIMRowIdByTarid("11")
ClassMethod GetLinkedARCIMByTarid(tarirowid As %String) As %String
{
	n (tarirowid)
	s ARCIMRowId=""
	s tStDate=0
	For
	{ 
		s tStDate=$o(^DHCOLT(0,"TAR",tarirowid,tStDate)) Quit:((tStDate="")||(ARCIMRowId'=""))
		Set OLTRowid=0
		For
		{
			s OLTRowid=$o(^DHCOLT(0,"TAR",tarirowid,tStDate,OLTRowid)) Quit:((OLTRowid="")||(ARCIMRowId'=""))
			s ARCIMRowId=$p($G(^DHCOLT(OLTRowid)),"^",1)
		}
	}
	q ARCIMRowId
}

/// Function: 删除收费项
/// CreateDate:2016-11-29
/// others: chenying
/// w ##class(web.DHCBL.CT.DHCTarItem).RepairData()
ClassMethod RepairData(id As %String) As %String
{
	//收费项目和收费项目价格如果保存后，再回滚会导致存在^DHCTARI(5679,"P",0)=1的数据，属于垃圾数据，要清理
	s TARIRowId=0
	for
	{
		s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
		IF ($D(^DHCTARI(TARIRowId))=10)&&($G(^DHCTARI(TARIRowId))="") k ^DHCTARI(TARIRowId)
	}
	q ""
}

/// Function: 南方医院  获取默认"自费"患者类别的rowid
/// CreateDate:2017-05-03  update@20190326
/// others: chenying
/// w ##class(web.DHCBL.CT.DHCTarItem).GetDefPatInsType(hospid)
ClassMethod GetDefPatInsType(hospid As %String = "") As %String
{
	n (hospid)
	//s HOSPID=$g(%session.Data("LOGON.HOSPID"))
	s InsType=""
	s REARowId=0
	for 
	{
		s REARowId=$o(^PAC("ADMREA",REARowId)) q:REARowId="" 
		s READesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
		if READesc["自费" 
		{
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason",REARowId,hospid)
			continue:showflag="N"
			s InsType=REARowId
			q
		}
	}
	
	Q InsType
}

/// Function:获取是否自动生成收费项代码 是返回1，否返回0
/// Creator:陈莹
/// CreateDate: 2017-11-9
/// input:
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).GetAutoCreateFlag()
/// ^Config.BDP("DHC_TarItem",2)="true^F^10^YP"
ClassMethod GetAutoCreateFlag(hospid As %String = "") As %String
{
	n (hospid)
	s flag=0
	s ConfigType=..#SQLTableName
	s Global=$g(^Config.BDP(ConfigType,+hospid))
	s AutoCode=$p(Global,"^",1)
	if AutoCode="true" s flag=1	
	
	q flag
}

/// Function:添加时，自动生成收费项代码，根据配置，取开头字符+总位数   最大数字+1
/// Creator:陈莹
/// CreateDate: 2017-07-07
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).AutoCreateCode()
/// ^Config.BDP("DHC_TarItem",2)="true^F^10^YP"
ClassMethod AutoCreateCode(CatStr As %String = "", hospid As %String = "") As %String
{
	n (CatStr,hospid)
	s itemcatid=$p(CatStr,"^",1)  //收费项目类别rowid
	s Status=$p(CatStr,"^",2) ///状态判断
	s MaxCode=""
	s ConfigType=..#SQLTableName
	
	if $d(^Config.BDP(ConfigType,+hospid))
	{
		s Global=$g(^Config.BDP(ConfigType,+hospid))
		s AutoCode=$p(Global,"^",1)
		if AutoCode="true"
		{
			k ^TMPCODE(ConfigType)
			s CodeType=$p(Global,"^",2)          ///代码规则：1，F，所有代码一套规则 字母开头  2，收费项目子类代码开头
			s TotalLength=$p(Global,"^",3)
			if CodeType="F"
			{
				s OriginCode=$p(Global,"^",4)   //起始字符
			}
			else
			{
				if Status="0" q ""

				if CodeType="I"
				{
					if itemcatid="" q ""
					s OriginCode=$lg($g(^User.BDPItemCategoryD(itemcatid)),2)
				}
				
			}
			s olength=$l(OriginCode)
			
			if ((TotalLength-$l(OriginCode))<=0)
			{
				 s MaxCode=""
			}
			else
			{
			
				s Code1=""
				s Code=0
				for
				{
					S Code=$o(^DHCTARI(0,"Code",Code)) q:Code=""
					s id=0
					for
					{
						S id=$o(^DHCTARI(0,"Code",Code,id)) q:id=""
						
						s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,id,hospid)
						continue:showflag="N"
	
						s RCode=$p($g(^DHCTARI(id)),"^",1)
						s RCode=##class(web.DHCBL.BDP.FunLib).Util(RCode)
						if ($e(RCode,1,olength)=OriginCode)&&($l(RCode)=TotalLength)
						{
							if ($e(RCode,olength+1,TotalLength)?1n.n)
							{
								s Code1=$e(RCode,olength+1,TotalLength)+1
								S:Code1'="" TMPCODE(ConfigType,Code1)=RCode
							}
						}
					}
				
				}
				s Code1=$o(TMPCODE(ConfigType,""),-1)
				s Code1=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code1,TotalLength-$l(OriginCode)) 
				s MaxCode=OriginCode_Code1
				k TMPCODE(ConfigType)
			}
		}
	}
	q MaxCode
}

/// Creator:陈莹
/// CreatDate:2017-07-03
/// Description:获取页面的配置
/// w ##class(web.DHCBL.CT.DHCTarItem).GetConfigValue(2)
/// ^Config.BDP("DHC_TarItem",2)="true^F^10^YP"
ClassMethod GetConfigValue(hospid As %String = "") As %String
{
	n (hospid)
	s str=""
	S FCode="",ICode="",OriginCode="",TotalLength="",CodeType=""
	s ConfigType=..#SQLTableName
	s Global=$g(^Config.BDP(ConfigType,+hospid))
	s AutoCode=$p(Global,"^",1)          //自动生成代码，默认false
	if (AutoCode="") S AutoCode="false"
	if AutoCode="true"
	{
		s TotalLength=$p(Global,"^",3)       ///自动生成总共多少位的代码
		s CodeType=$p(Global,"^",2)          ///代码规则：1，F F所有医嘱项一套规则 YP字母开头  2，I  收费项目科目类别代码开头
		if CodeType="F"
		{
			s FCode="F"
			s OriginCode=$p(Global,"^",4)       ///代码开头 字母开头 或者纯数字(不填)
		}
		if CodeType="I"
		{
			s ICode="I"	
		}
	}
	s ValidDesc=$p(Global,"^",5)         //校验描述是否重复，默认true
	if (ValidDesc="") S ValidDesc="true"
	s str="AutoCode:"""_AutoCode_""",OriginCode:"""_OriginCode_""",ICode:"""_ICode_""",FCode:"""_FCode_""",CodeType:"""_CodeType_""",TotalLength:"""_TotalLength_""",ValidDesc:"""_ValidDesc_""""
	s str = "{list:[{"_str_"}]}"
	q str
}

/// Creator:陈莹
/// CreatDate:2017-07-03
/// Description:保存页面的配置
/// Input：（1）是否自动生成代码^（2）代码规则：F字母开头 或者纯数字不填 / I 收费项目类别代码开头 ^(3)自动生成总共多少位的代码^(4)代码规则为F 时开头代码 （5）是否校验名称
/// w ##class(web.DHCBL.CT.DHCTarItem).SaveConfigValue("true^F^10^YP^true",2)
ClassMethod SaveConfigValue(ConfigStr, hospid As %String = "") As %String
{
	n (ConfigStr,hospid)
	s ConfigType=..#SQLTableName
	s ^Config.BDP(ConfigType,+hospid)=ConfigStr    //true^F^10^YP^true
	q "{success:'true'}"
}

/// Creator:陈莹
/// CreatDate:2017-07-13
/// Description:通过收费项代码获取收费项别名
/// w ##class(web.DHCBL.CT.DHCTarItem).GetAliasByRowId("1")
ClassMethod GetAliasByRowId(id) As %String
{
	n (id)
	s ALIASText1=""
	s TIARowId=0
	for
	{
		s TIARowId=$o(^DHCTARAL("A",id,TIARowId))  q:TIARowId=""
		s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
		s:ALIASText1'="" ALIASText1=ALIASText1_"/"_TIAAlias
		s:ALIASText1="" ALIASText1=TIAAlias
	}
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2018-04-13
/// Description:通过医嘱项代码获取关联的收费项信息
/// Input:医嘱项代码
/// Output:收费项代码^描述^单位^价格^数量&!收费项代码^描述^单位^价格^数量  不同的收费项之间用%!连接
/// 如果没有关联收费项，就返回空
/// w ##class(web.DHCBL.CT.DHCTarItem).GetTariInfoByARCIMCode("A02AD0301w")
ClassMethod GetTariInfoByARCIMCode(code) As %String
{
	s result=""
	s arcimrowid=""
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s flag=0,arcimrowid=""
		s sub=0
		for
		{
			s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),sub)) q:(sub="")||(arcimrowid'="")
			s version=0
			for
			{
				s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),sub,version)) q:version=""
				s SCODE=$p($g(^ARCIM(sub,version,1)),"^",1) 
				IF (SCODE=code)
				{
					S arcimrowid=sub_"||"_version
					q 
				}
			}
		}
		
	}
	
	if arcimrowid'=""
	{
		s olttariffdr=0
		for
		{
			s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:olttariffdr=""   
			s startdate=0
			for
			{
				s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:startdate=""
				s associaterowid=0
				for
				{
					s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:associaterowid=""
					
					s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5) ///结束日期
					if (startdate>+$h)||((tarDateTo'="")&&(tarDateTo<+$h)) continue  ///过滤当前无效关联
					
					s tarcode=$P($G(^DHCTARI(olttariffdr)),"^",1) 
					s tardesc=$P($G(^DHCTARI(olttariffdr)),"^",2) 
					
					s tarqty=$p($g(^DHCOLT(associaterowid)),"^",3)
					s taruom=$p($g(^DHCTARI(olttariffdr)),"^",3)
					s:taruom'="" taruom=$p($g(^CT("UOM",taruom)),"^",2)
					s HOSPtalID=$g(%session.Data("LOGON.HOSPID"))	 
					s tarprice=##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(olttariffdr,HOSPtalID)  //价格	
					if result=""
					{
						s result=tarcode_"^"_tardesc_"^"_taruom_"^"_tarprice_"^"_tarqty
					}
					else
					{
						
						s result=result_"&!"_tarcode_"^"_tardesc_"^"_taruom_"^"_tarprice_"^"_tarqty
					}
				}
			}
		}	
	}
	q result
}

/// Function: 查询数据中以某字符串开头的收费项代码最大值，并自动+1
/// Creator:陈莹
/// CreateDate: 2018-09-10
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).GetMaxCode("A01BA")
ClassMethod GetMaxCode(SearchStr, hospid As %String = "") As %String
{
	n (SearchStr,hospid)
	q:SearchStr="" ""
	s MaxCode=""
	s zCode=SearchStr
	for
	{
		S zCode=$o(^DHCTARI(0,"Code",zCode)) q:(zCode="")
		if ($e(zCode,1,$l(SearchStr))'=SearchStr) continue
		s rowid=0
		for
		{
			S rowid=$o(^DHCTARI(0,"Code",zCode,rowid)) q:rowid=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,rowid,hospid)
			continue:showflag="N"
			s Code=$p($g(^DHCTARI(rowid)),"^",1)
			if ($e(Code,1,$l(SearchStr))'=SearchStr) continue
			if $l(SearchStr)>$l(Code) continue 
			if ($e(Code,$l(SearchStr)+1,$l(Code))?1n.n)   //str?1n.n ///全是数字 返回1，含有其他字符 返回0
			{
				s maxvalue=$e(Code,$l(SearchStr)+1,$l(Code))
				s TMPMAXCODE(+maxvalue+1)=$L(Code)
			}	
		}
	}
	s sub=$o(TMPMAXCODE(""),-1)
	if sub'=""
	{
		s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(sub,$g(TMPMAXCODE(sub))-$l(SearchStr))     ///自动补全0
	}
	else
	{
		s Code=""
	}
	
	s MaxCode=SearchStr_Code
	q MaxCode
}

/// Function: 获取收费项价格
/// CreateDate:2018-11-14
/// Creator: chenying
/// Input:tarirowide(收费项rowid),HOSPtalID（角色医院）
/// Retrun:收费项价格
/// w ##class(web.DHCBL.CT.DHCTarItem).GetTariPrice("22",2)
ClassMethod GetTariPrice(tarirowid As %String, hospid As %String = "", date As %String = "") As %String
{
	n (tarirowid,hospid,date,%session)
	s $zt="ERROR"
	q:tarirowid="" ""
	s:date="" date=+$h
	if hospid="" s hospid=$g(%session.Data("LOGON.HOSPID"))
	if $d(^DHCINCTARi("TAR",tarirowid))>0  //药品需要传医嘱项才能取到价格 20230404update
	{
		s INCIOriginalARCIMDR="",INCIRowId=""
		s INCTRRowId=$o(^DHCINCTARi("TAR",tarirowid,0))
		s:INCTRRowId'="" INCIRowId=$P($G(^DHCINCTAR(INCTRRowId)),"^",1)
		s:INCIRowId'="" INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
		s ExpString="^^^^^"_INCIOriginalARCIMDR_"^^^^^"_INCIRowId
		s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,date,"","","",hospid,ExpString)
	}
	else
	{
		s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,date,"","","",hospid)
	}
	//s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,date,"","","")
	s tarprice=$p(priceinfo,"^",1)
	if $e(tarprice,1)="." s tarprice="0"_tarprice
	s tarprice=$tr(tarprice,$c(10),"")
	s tarprice=$tr(tarprice,$c(13),"")
	s tarprice=$tr(tarprice,$c(0),"")	 
	q tarprice
ERROR
	Q "ERROR"
}

/// Function: 获取收费项对应库存项的规格 重庆宽仁医院
/// CreateDate:2019-10-25
/// Creator: chenying
/// Input:tarirowide(收费项rowid)
/// Retrun:库存项的规格
/// s INFOSpec= ##class(web.DHCBL.CT.DHCTarItem).GetINFOSpecByTARIRowId("22")
ClassMethod GetINFOSpecByTARIRowId(tarirowid As %String) As %String
{
	n (tarirowid)
	s INFOSpec=""
	s INCIRowid=""
	s INCTRRowId=$o(^DHCINCTARi("TAR",tarirowid,0))
	if INCTRRowId'=""
	{
		s INCIRowid=$p($g(^DHCINCTAR(INCTRRowId)),"^",1)  //药品
	}
	else
	{
		 //材料
		s startdate=$o(^DHCOLT(0,"TAR",tarirowid,0)) 
		IF startdate'=""
		{
			S oltrowid=$o(^DHCOLT(0,"TAR",tarirowid,startdate,0))
			s arcimdr=$p($g(^DHCOLT(oltrowid)),"^",1)
			S ARCIMSubscript=$p(arcimdr,"||",1)
			if ARCIMSubscript'="" s INCIRowid=$o(^INCI(0,"ARCIM_DR",ARCIMSubscript,0)) 

		}

	}

	if (INCIRowid'="")
	{
		s INFOSpecRowId=$O(^DHCITMINFO(0,"INCI",INCIRowid,0))
		s:INFOSpecRowId'="" INFOSpec=$p($g(^DHCITMINFO(INFOSpecRowId)),"^",27)
		s INFOSpec=##class(web.DHCBL.BDP.FunLib).Util(INFOSpec)
	}
	q INFOSpec
}

/// Function:收费项置为无效的时候，停掉对应的医嘱项和收费项对照
/// Creator: 陈莹
/// CreateDate:2020-05-27
/// Input: hospid（医院的rowid)
/// debug:   d ##class(web.DHCBL.CT.DHCTarItem).EndLinkedARCIMByTARIRowId(2)
ClassMethod EndLinkedARCIMByTARIRowId(TARIRowId) As %String
{
	n (TARIRowId)
	s tStDate=0
	For
	{ 
		s tStDate=$o(^DHCOLT(0,"TAR",TARIRowId,tStDate)) Quit:tStDate=""
		Set OLTRowid=0
		For
		{
			s OLTRowid=$o(^DHCOLT(0,"TAR",TARIRowId,tStDate,OLTRowid)) Quit:(OLTRowid="")
			s ARCIMRowId=$p($G(^DHCOLT(OLTRowid)),"^",1)
			s OLTEndDate=$p($g(^DHCOLT(OLTRowid)),"^",5)		
			IF ((OLTEndDate="")||((OLTEndDate'="")&&(OLTEndDate>=+$h)))
			{
				s ARCIMEffDateTo=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),7)),"^",1)      ; 结束日期 
				if ARCIMEffDateTo=""
				{
					
					s obj=##class(User.ARCItmMast).%OpenId(ARCIMRowId)
					s obj.ARCIMEffDateTo=+$h
					s obj.ARCIMChgPostFlg="O"
					d obj.%Save()
				}
			}
		}
	}
}

/// Creator：陈莹
/// CreatDate: 2020-09-03
/// Description：在将收费项置为无效时，可选择将医嘱项关联收费项的结束日期置为选择的结束日期,批量处理多条数据。
/// Input：LinkStr(医嘱项与收费项关联rowid^医嘱项一对一还是一对多^医嘱项rowid&医嘱项与收费项关联rowid^医嘱项一对一还是一对多^医嘱项rowid)， enddate（结束日期)
/// Return：Json 格式数据
/// w ##class(web.DHCBL.CT.DHCTarItem).BatchEndOrderLinkTar("29^3^30||1","2020-09-11")
ClassMethod BatchEndOrderLinkTar(LinkStr As %String, enddate As %String) As %String
{
	n (LinkStr,enddate,%session)
	Set enddate1=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(enddate)
	if (enddate1'="")&&(enddate1<+$h) q "{success:'false',info:'医嘱项与收费项关联表的结束日期生效时间为当天的24:00，不能早于今天!'}"
	s ErrorResult=""
	s length=$l(LinkStr,"&")
	for linki=1:1:length
	{
		s Str=$p(LinkStr,"&",linki)
		s oltrowid=$p(Str,"^",1)
		s Relation=$p(Str,"^",2)
		s TArcRowid=$p(Str,"^",3)
		s obj=##class(User.DHCOrderLinkTar).%OpenId(oltrowid)
		if obj.OLTEndDate'=""
		{
			  s ErrorResult= ErrorResult_"医嘱项<"_$p($g(^ARCIM(+TArcRowid,$p(TArcRowid,"||",2),1)),"^",2)_">"_"与收费项的关联关系已经有截止日期，不能再次截止!"
		}
		else
		{
			s eobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
			s eobj.OLTRowId=oltrowid
			s eobj.OLTARCIMDR=$p($g(^DHCOLT(oltrowid)),"^",1)
			s eobj.OLTTariffDR=$p($g(^DHCOLT(oltrowid)),"^",2)
			s eobj.OLTQty= $p($g(^DHCOLT(oltrowid)),"^",3)
			s eobj.OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml($p($g(^DHCOLT(oltrowid)),"^",4))
			s eobj.OLTEndDate=enddate
			s eobj.OLTBascPriceFlag=$p($g(^DHCOLT(oltrowid)),"^",8)
			s eobj.OLTBillOnceFlag=$p($g(^DHCOLT(oltrowid)),"^",9)
			s Result= ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
			b ;1
			if Result'["success:'true'"  
			{
				 s ErrorResult= ErrorResult_"医嘱项<"_$p($g(^ARCIM(+TArcRowid,$p(TArcRowid,"||",2),1)),"^",2)_">"_"与收费项的关联关系截止失败:"_Result_"!" 
			}
			else
			{
				//如果这条医嘱项只关联了这一条收费项，则把这条医嘱项也停用，医嘱项结束日期也为选中的日期；
				if (Relation=1)
				{
					s Result= ##class(web.DHCBL.CT.DHCTarItem).EndLinkedARCIM(TArcRowid,enddate)
					if Result["success:'false'"  s ErrorResult= ErrorResult_"医嘱项<"_$p($g(^ARCIM(+TArcRowid,$p(TArcRowid,"||",2),1)),"^",2)_">停止失败:"_Result_"!" 
				}
			}	
		}
	}
	if ErrorResult=""
	{
		s result="{success:'true',info:'结束日期更新成功！'}"
	}
	else
	{
		s result="{success:'false',info:'更新失败！"_ErrorResult_"'}"		
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2020-09-03
/// Description：批量关联医嘱项和收费项
/// Input：ArcimDRStr(医嘱项rowid^医嘱项rowid)， 收费项Rowid^数量^开始日期^结束日期^基价模式^多部位计价一次
/// Return：1（成功）,0（失败）
/// w ##class(web.DHCBL.CT.DHCTarItem).BatchAddOrderLinkTar("111","2017-05-20")
ClassMethod BatchAddOrderLinkTar(ArcimDRStr As %String, LinkStr As %String) As %String
{
	n (ArcimDRStr,LinkStr,%session)
	
	s TARIRowId=$p(LinkStr,"^",1)
	s OLTQty=$p(LinkStr,"^",2)
	s OLTStartDate=$p(LinkStr,"^",3)
	s OLTEndDate=$p(LinkStr,"^",4)
	s OLTBascPriceFlag=$p(LinkStr,"^",5)
	s OLTBillOnceFlag=$p(LinkStr,"^",6)
	s OLTBascPriceFlag=$CASE(OLTBascPriceFlag,"true":"Y","Y":"Y",:"N")  //基价模式
	s OLTBillOnceFlag=$CASE(OLTBillOnceFlag,"true":"Y","Y":"Y",:"N")  //多部位计价一次
		
	s startdate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OLTStartDate)
	s enddate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(OLTEndDate)
	If (OLTQty="") Quit "{success:'false',errorinfo:'关联收费项的数量不能为空!'}"
	if (startdate<+$h) q "{success:'false',info:'医嘱项与收费项关联表的开始日期不能早于今天!'}"
	if (enddate'="")&&(startdate'="")&&(startdate>enddate) q "{success:'false',info:'结束日期不能早于开始日期!'}"
	if (enddate'="")&&(enddate<+$h) q "{success:'false',info:'医嘱项与收费项关联表的结束日期生效时间为当天的24:00，不能早于今天!'}"
	s ErrorResult=""
	s length=$l(ArcimDRStr,"^")
	k ArrayARCIM
	for linkarcim=1:1:length
	{
		s ARCIMRowId=$p(ArcimDRStr,"^",linkarcim)
		if $D(ArrayARCIM(ARCIMRowId))>0 continue
		S ArrayARCIM(ARCIMRowId)=""
		k eobj
		s eobj=##class(web.Entity.CT.DHCOrderLinkTar).%New()
		s eobj.OLTRowId=""
		s eobj.OLTARCIMDR=ARCIMRowId
		s eobj.OLTTariffDR=TARIRowId
		s eobj.OLTQty= OLTQty
		s eobj.OLTStartDate=OLTStartDate
		s eobj.OLTEndDate=OLTEndDate
		s eobj.OLTBascPriceFlag=OLTBascPriceFlag
		s eobj.OLTBillOnceFlag=OLTBillOnceFlag
		s Result= ##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(eobj)
		if Result["success:'false'"
		{
			s errorInfo=$p($p(Result,"errorinfo:'",2),"'}",1)
			s ErrorResult= ErrorResult_"医嘱项‘"_$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",2)_"’"_errorInfo
	
		}
	}
	if ErrorResult=""
	{
		s result="{success:'true',info:'医嘱项和收费项批量关联成功！'}"
	}
	else
	{
		s result="{success:'false',info:'"_ErrorResult_"'}"		
	}
	q result
}

/// Function: 清除回滚后的只有价格节点的global
/// Creator:陈莹
/// CreateDate: 
/// Debug: d ##class(web.DHCBL.CT.DHCTarItem).KillNullGlobal()
ClassMethod KillNullGlobal() As %String
{
	s RowId=0
	for
	{
		s RowId=$o(^DHCTARI(RowId)) q:((RowId="")||(RowId'>0))
		IF ($G(^DHCTARI(RowId))="")&&($D(^DHCTARI(RowId))=10) k ^DHCTARI(RowId)
	}
}

/// chenying
/// 根据收费项代码获取收费项rowid
/// Debug: w##class(web.DHCBL.CT.DHCTarItem).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code, hospid) As %String
{
	n (code)
	q:code="" ""
	s tarirowid=""
	if code'=""
	{
		/*s tariid=0
		for
		{
			s tariid=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(code),tariid)) q:tariid=""  //$$UPPER^SSUTIL4
			if $p($g(^DHCTARI(tariid)),"^",1)=code s tarirowid=tariid
		}
		*/
		
		s tarirowid=$O(^DHCTARI(0,"Code",code,0))
		/*
		s tariid=0
		for
		{
			s tariid=$O(^DHCTARI(0,"Code",code,tariid)) q:tariid=""
			
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem",TARIRowId,hospid)
			continue:showflag="N"
			s tarirowid=tariid
		}
		*/
	}
	q tarirowid
}

/// chenying
/// 根据收费项名称获取收费项rowid
ClassMethod GetRowIdByDesc(desc) As %String
{
	n (desc)
	q:desc="" ""
	s tarirowid=""
	if desc'=""
	{
		/*s tariid=0
		for
		{
			s tariid=$O(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(desc),tariid)) q:tariid=""  //UPPER
			if $p($g(^DHCTARI(tariid)),"^",2)=desc s tarirowid=tariid
		}
		*/
		s tarirowid=$O(^DHCTARI(0,"Desc",desc,0))
	}
	q tarirowid
}

/// Function: 根据收费项rowid更新收费项国家医保编码/名称
/// Creator:陈莹
/// CreateDate: 2021-08-24
/// Input:TARIRowId收费项rowid,TARIInsuCode国家医保编码
/// Return :0成功，-1^错误信息
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).UpdateInsuCode(1,"C0342031070301008023","")
ClassMethod UpdateInsuCode(TARIRowId, TARIInsuCode, TARIInsuName As %String = "") As %String
{
	n (TARIRowId, TARIInsuCode, TARIInsuName,%session)
	s result=0
	if TARIRowId="" q "-1^收费项ID不能为空"
	Tstart		
	s obj=##class(User.DHCTarItem).%OpenId(TARIRowId)
	s NewJsonStr="{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_obj.TARICode_""",""TARIDesc"":"""_obj.TARIDesc_""",""TARIInsuCode"":"""_TARIInsuCode_""",""TARIInsuName"":"""_TARIInsuName_"""}"     
	s OldJsonStr="{""TARIRowId"":"""_TARIRowId_""",""TARICode"":"""_obj.TARICode_""",""TARIDesc"":"""_obj.TARIDesc_""",""TARIInsuCode"":"""_obj.TARIInsuCode_""",""TARIInsuName"":"""_obj.TARIInsuName_"""}"     
	s obj.TARIInsuCode=TARIInsuCode
	s obj.TARIInsuName=TARIInsuName
	s sc=obj.%Save()
	if $$$ISOK(sc){
		Tcommit
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_TarItem","User.DHCTarItem","收费项目国家医保编码",TARIRowId,obj.TARIDesc,"U",NewJsonStr,OldJsonStr)
		do obj.%Close()
	}
	else
	{
		Trollback
		s result="-1^"_$SYSTEM.Status.GetErrorText(sc)
	}
	q result
}

/// Function: 根据收费项rowid获取收费项国家医保编码
/// Creator:陈莹
/// CreateDate: 2021-08-24
/// Input:TARIRowId：收费项rowid
/// Return :国家医保编码
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).GetInsuCodeByRowId("1")
ClassMethod GetInsuCodeByRowId(TARIRowId) As %String
{
	n (TARIRowId,%session)
	q:TARIRowId="" ""
	s TARIInsuCode = $p($g(^DHCTARI(TARIRowId)),"^",59)  //国家医保编码
	//取翻译后的内容 2022-12-19
	s:TARIInsuCode'="" TARIInsuCode=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCTarItem","TARIInsuCode","",TARIInsuCode)
	q TARIInsuCode
}

/// Function: 根据收费项rowid获取收费项国家医保名称
/// Creator:陈莹
/// CreateDate: 2021-08-24
/// Input:TARIRowId： 收费项rowid
/// Return :国家医保名称
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).GetInsuName("1")
ClassMethod GetInsuName(TARIRowId) As %String
{
	n (TARIRowId,%session)
	q:TARIRowId="" ""
	s TARIInsuName = $p($g(^DHCTARI(TARIRowId)),"^",18)  //国家医保名称
	//取翻译后的内容 2022-12-19
	s:TARIInsuName'="" TARIInsuName=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCTarItem","TARIInsuName","",TARIInsuName)
	q TARIInsuName
}

/// Function: 根据收费项rowid获取国家医保编码和国家医保名称
/// Creator:陈莹
/// CreateDate: 2022-04-11
/// Input:Rowid收费项rowid,HospDr医院rowid
/// Return:国家医保编码^国家医保名称
/// Debug:w ##class(web.DHCBL.CT.DHCTarItem).GetStdInsuInfo("1","2")
ClassMethod GetStdInsuInfo(Rowid As %String, HospDr As %String) As %String
{
	n (Rowid,HospDr)
	s $ZT="ErrorStd"
	q:Rowid="" ""
	if (HospDr="")
	{
		s HospDr= ##class(web.DHCBL.BDP.BDPDataExport).GetHospital("DHC_TarItem",Rowid,"")
		if HospDr'="" s HospDr=+HospDr
		if (HospDr="") s HospDr=$o(^CT("HOSP",0))
	}
	s InsuStr=""
	s Config=##class(web.DHCBL.BDP.INSUConfig).GetConfigByHospId(HospDr,"DHC_TarItem")
	if Config="INSU"
	{
		s InsuStr=##class(web.DHCINSUPort).GetStdInfoByDHCTarItemRowId(Rowid,HospDr)
	}
	else
	{
		s InsuCode=##class(web.DHCBL.CT.DHCTarItem).GetInsuCodeByRowId(Rowid)
		s InsuName=##class(web.DHCBL.CT.DHCTarItem).GetInsuName(Rowid)
		s InsuStr=InsuCode_"^"_InsuName
	}
	q InsuStr
ErrorStd
	q "-1^"_$ZE
}

/// Function: 根据收费项rowid和结束日期 停止医嘱项
/// Creator:陈莹
/// CreateDate: 2022-08-16
/// Input:收费项rowid  结束日期
/// Return :
/// Debug: w ##class(web.DHCBL.CT.DHCTarItem).EndARCIM("6038","2022-08-18")
ClassMethod EndARCIM(TARIRowId, TARIEndDate) As %String
{
	n (TARIRowId, TARIEndDate,%session)
	if (TARIEndDate'="")
	{
		s tStDate=0
		For
		{ 
			s tStDate=$o(^DHCOLT(0,"TAR",TARIRowId,tStDate)) Quit:tStDate=""
			Quit:tStDate=0
			Set OLTRowid=0
			For
			{
				s OLTRowid=$o(^DHCOLT(0,"TAR",TARIRowId,tStDate,OLTRowid)) Quit:OLTRowid=""
				s tarDateTo=$p($g(^DHCOLT(OLTRowid)),"^",5)  //关联关系已经截止的医嘱项不停
				CONTINUE:(tarDateTo'="")
				s ARCIMRowId=$p($G(^DHCOLT(OLTRowid)),"^",1)
				s ARCIMEffDateTo=$p($g(^ARCIM($P(ARCIMRowId,"||",1),$P(ARCIMRowId,"||",2),7)),"^",1)      ; 结束日期 
				CONTINUE:(ARCIMEffDateTo'="")
				S ret= ##class(web.DHCBL.CT.DHCTarItem).EndLinkedARCIM(ARCIMRowId,TARIEndDate)
				B ;2
			}
		}
	}
	Q ""
}

/// Function:将收费项代码同步到物价编码列（除了药品和材料）
/// Creator:陈莹
/// CreateDate: 2022-11-01
/// w ##class(web.DHCBL.CT.DHCTarItem).UpdatePriceCode()
ClassMethod UpdatePriceCode() As %String
{
	s TARIRowId=0
	for
	{
		s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
		s id = TARIRowId
		if $g(^DHCTARI(id))="" continue  ///过滤空数据
		s TarSubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
		s Cate=""
		s:(TarSubCate'="") Cate=$p($g(^DHCTarC("SC",TarSubCate)),"^",3) ///收费项目大类 DR
		S:Cate'="" Cate=$p($g(^DHCTarC("CC",Cate)),"^",2)  ///收费项目大类描述
		continue:((Cate="药品")||(Cate="医用材料"))
		s taricode=$p($g(^DHCTARI(id)),"^",1)  //收费项代码
		s obj=##class(User.DHCTarItem).%OpenId(TARIRowId)
		Set obj.TARIPriceCode=taricode
		s sc=obj.%Save()
		if $$$ISOK(sc){
			do obj.%Close()
		}
		else
		{
			w "收费项物价编码更新失败："_TARIRowId_" "_taricode_" "_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!	
		}
	}
	q ""
}

/// Function:对某医院的数据 收费项代码批量加前缀
/// Creator:陈莹
/// CreateDate: 2022-11-01
/// Input:hospid医院id,prefix要加的前缀
/// w ##class(web.DHCBL.CT.DHCTarItem).UpdateCodeByHosp("3","F")
ClassMethod UpdateCodeByHosp(hospid As %String, prefix As %String) As %String
{
    n (hospid,prefix)
    q:hospid="" ""
    q:prefix="" ""
    s length=$l(prefix)
    s TARIRowId=0
	for
	{
		s TARIRowId=$o(^DHCTARI(TARIRowId)) q:TARIRowId=""
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarItem",TARIRowId,hospid)
		continue:showflag="N"
		s id = TARIRowId
		if $g(^DHCTARI(id))="" continue  ///过滤空数据
		s TarSubCate =$p($g(^DHCTARI(id)),"^",4) ///收费项目子类
		s Cate=""
		s:(TarSubCate'="") Cate=$p($g(^DHCTarC("SC",TarSubCate)),"^",3) ///收费项目大类 DR
		S:Cate'="" Cate=$p($g(^DHCTarC("CC",Cate)),"^",2)  ///收费项目大类描述
		continue:((Cate="药品")||(Cate="医用材料"))
		s taricode=$p($g(^DHCTARI(id)),"^",1)  //收费项代码
		s pre=$e(taricode,1,length)
        if pre'=prefix
        {
            s obj=##class(User.DHCTarItem).%OpenId(TARIRowId)
			Set obj.TARICode=prefix_taricode
			s sc=obj.%Save()
			if $$$ISOK(sc){
				do obj.%Close()
			}
			else
			{
				w "收费项更新失败："_TARIRowId_" "_prefix_taricode_" "_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!	
			}
		}
	}
	q ""
}

/// Creator:陈莹
/// CreatDate:2023-04-14
/// Description:通过医嘱项id获取关联的收费项厂商名称
/// Input:医嘱项id
/// Output:收费项厂商名称
/// w ##class(web.DHCBL.CT.DHCTarItem).GetTariManfByARCIMRowId("1||1")
ClassMethod GetTariManfByARCIMRowId(arcimrowid) As %String
{
	n (arcimrowid)
	s manfname=""
	if arcimrowid'=""
	{
		s olttariffdr=0
		for
		{
			s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:olttariffdr=""   
			s startdate=0
			for
			{
				s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:startdate=""
				s associaterowid=0
				for
				{
					s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:associaterowid=""
					
					s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5) ///结束日期
					if (startdate>+$h)||((tarDateTo'="")&&(tarDateTo<+$h)) continue  ///过滤当前无效关联
					s manfname=$P($G(^DHCTARI(olttariffdr)),"^",89)   //厂商名称	
				}
			}
		}	
	}
	q manfname
}

}
