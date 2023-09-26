Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-12-30
/// Descript: 	检查申请公共类
Class web.DHCAPPExaRepCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCAPP("ExaRepCom"))
}

/// Descript:	检查申请单检查项目计费模式
ClassMethod GetItemTarFlag(itmmastid As %String, HospId As %String = "") As %String
{
	n (itmmastid,HospId,%session)
	i ($d(%session)){
			s HospId=%session.Get("LOGON.HOSPID")
	}
	Q:itmmastid="" ""
	s ArcAddID=""
	s TarFlag=""
	for {
		s ArcAddID=$o(^DHCAPPARA(0,"Arc",itmmastid,ArcAddID))
		q:ArcAddID=""
		continue:($p(^DHCAPPARA(ArcAddID),"^",5)'=HospId)
		s TarFlag=$p(^DHCAPPARA(ArcAddID),"^",3)
		q:TarFlag'=""
	}
	Q TarFlag
}

/// Descript:	检查医嘱项是否自动生成申请单
ClassMethod GetItemPopFlag(itmmastid As %String) As %String
{
	n (itmmastid)
	Q:itmmastid="" ""
	s ArcAddID=$o(^DHCAPPARA(0,"Arc",itmmastid,""))
	Q:ArcAddID="" ""
	s PopFlag=$p(^DHCAPPARA(ArcAddID),"^",4)
	Q PopFlag
}

/// Descript:  取计费点 
/// OutPut:    0-开医嘱计费，1-执行计费
/// W ##Class(web.DHCAPPExaRepCom).GetFeePoint("11207||1")
ClassMethod GetFeePoint(arcimid As %String, EpisodeID) As %String
{
	 n (arcimid, EpisodeID)
	 Q:$p(^PAADM(EpisodeID),"^",2)'="I" 0
	 s itmmastid=$p(arcimid,"||",1)
	 s itmmastver=$p(arcimid,"||",2)
	 s itmCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)  /// 医嘱项名称
	 s bc=$o(^DHCTarC("BC",0,itmCatID,""))
	 Q:bc="" ""
	 s condition=$p(^DHCTarC("BC",bc),"^",2) ;本行正式上线时放开
	 i condition="OD" q "0"  ;开医嘱计费
	 i condition="OE" q "1"  ;执行计费
	 Q ""
}

/// Descript:  获取His系统维护日期格式
/// W ##Class(web.DHCAPPExaRepCom).GetSysDateToHtml("1988-03-08")
ClassMethod GetSysDateToHtml(HtDate As %String) As %String
{
	n (HtDate)
	Q:HtDate="" ""
	/// 转换输入日期格式为系统存储格式
	s HtDate=##Class(web.DHCEMCommonUtil).DateHtmlToLogical(HtDate)
	Q:HtDate="" ""
	/// Demo配置的日期格式
	s HtDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(HtDate)
	Q HtDate
}

/// Creator:    	bianshuai
/// CreateDate: 	2018-12-20
/// Descript:   	按照指定内容拆分字符串，主要解决字符串包含符号、字母、数字导致按照字符拆分后，长短不一致问题
/// InPut:      	mListData - 字符串，LimitLen-每行字节数，rowLen-行数，TmpArr
/// w ##Class(web.DHCAPPExaRepCom).splitString("LimitLen-每行字节数", "14", "", .TmpArr)
ClassMethod splitString(mListData As %String, LimitLen As %String, rowLen As %String = 4, TmpArr As %String) As %String
{
	n (mListData, LimitLen, rowLen, TmpArr)
	s Len=0,j = 0,k = 0,QuitFlag=0
	F i=1:1:$L(mListData)
	{
		Quit:QuitFlag=1
		s vChar=$E(mListData,i) s vAsciiCode=$ASCII(vChar)
		/// 单字节加1
		if (vAsciiCode > 255)||(vAsciiCode < 0){
			s Len=Len+2
		}Else{
			s Len=Len+1
		}
		if ((Len#LimitLen=0)||(Len#LimitLen=1))&(Len'=1){
			
			if ((i - k) < 2) Continue
			s TmpArr(j) = $E(mListData, k+1, i)
			if (j = rowLen){
				s TmpArr(j) = TmpArr(j) _ "..."
				s QuitFlag=1
			}
			s j = j + 1
			s k = i
		}
		if ((i = $L(mListData))&(k '= i)){
			s TmpArr(j) = $E(mListData, k+1, i+1)
		}
    }
	if ($g(TmpArr(0)) = ""){
		s TmpArr(0) = mListData
	}
	Q ""
}

}
