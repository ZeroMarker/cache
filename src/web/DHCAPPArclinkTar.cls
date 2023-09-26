Import SQLUser

Class web.DHCAPPArclinkTar Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor)
{

/// Creator：      zhouxin
/// CreatDate：    2016-05-18
/// Description:： 保存检查医嘱项与收费项对照关系表
/// Table：        DHC_AppArcLinkTar
/// Input：        ID^TarDr^ArcId^TarCode^TarDesc^PartNum^TarStart^TarEnd^TarPrice^BaseFlag
/// Output：       0:成功 ,其他:失败
/// Return：       0:成功 ,其他:失败            
/// Others：w ##class(web.DHCAPPArclinkTar).save("0^11^9461||1^A00N002^白凡士林[500g]^2^2016-05-18^^25^Y^1^0^0^2")
ClassMethod saveOrUpdate(str)
{
  	 Q:..isExist(str) -1
	 s ID=$p(str,"^",1)
	 s TarDr=$p(str,"^",2)
	 q:TarDr="0" -2
	 s ArcId=$p(str,"^",3)
	 s PartNum=$p(str,"^",6)
	 s TarStart=$p(str,"^",7)
	 s TarEnd=$p(str,"^",8)
	 s BaseFlag=$p(str,"^",10)
	 s PartID=$p(str,"^",14)        ///sufan   2016/07/23
	 i +ID=0 d
	 .s obj=##class(User.DHCAppArcLinkTar).%New()
	 e  d
	 .s obj=##class(User.DHCAppArcLinkTar).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.ALTArcDr=##class(User.ARCItmMast).%OpenId(ArcId)
	 s obj.ALTTarDr=##class(User.DHCTarItem).%OpenId(TarDr)
	 s obj.ALTStartDate=$case(+TarStart,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart)) // hxy 2017-03-02 $zdh(TarStart,3)
	 s obj.ALTEndDate=$case(TarEnd,"":"",:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd)) //hxy $zdh(TarEnd,3) ///sufan 2016/07/25
	 s obj.ALTUpdDate=..%SysDate()
	 s obj.ALTUpdTime=..%SysTime()
	 s:$d(%session) obj.ALTUpdUserDr=##class(User.SSUser).%OpenId(%session.Get("LOGON.USERID"))
	 s obj.ALTQty=PartNum
	 s obj.ALTBaseFlag=BaseFlag
	 s obj.ALTPartDr=##class(User.DHCAppPart).%OpenId(PartID)   ///sufan 2016/07/23
	 s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

/// Description:： 是否存在
ClassMethod isExist(mListData As %String) As %String
{
	s QuitFlag=0
	s ID=$p(mListData,"^",1)
	s TarDr=$p(mListData,"^",2)
  	s ArcId=$p(mListData,"^",3)
	s PartID=$p(mListData,"^",14)  /// 部位ID
	s ALTStartDate=0
	for {
		s ALTStartDate=$o(^DHCAPARCLTA(0,"Arc",ArcId,TarDr,ALTStartDate)) Q:ALTStartDate=""
		s ALTRowId=0
		for {
			s ALTRowId=$o(^DHCAPARCLTA(0,"Arc",ArcId,TarDr,ALTStartDate,ALTRowId)) Q:ALTRowId=""
			s ALTPartDr=$p(^DHCAPARCLTA(ALTRowId),"^",12)
			continue:(PartID'="")&&(PartID'=ALTPartDr)
			continue:(ID'="")&&(ID=ALTRowId)
			s QuitFlag=1 Q
		}
		
	}
	Q QuitFlag
}

/// Creator：      zhouxin
/// CreatDate：    2016-05-18
/// Description:： 保存检查医嘱项与收费项对照关系
/// Table：        DHC_AppArcLinkTar
/// Input：        ID^TarDr^ArcId^TarCode^TarDesc^PartNum^TarStart^TarEnd^TarPrice^BaseFlag$$ID^TarDr^ArcId^TarCode^TarDesc^PartNum^TarStart^TarEnd^TarPrice^BaseFlag
/// Output：       0:成功 ,其他:失败
/// Return：       0:成功 ,其他:失败
/// Others：w ##class(web.DHCAPPArclinkTar).save("0^4^11209||1^9963^ICU陪护被服押金^1^2016-07-25^^450^Y^^^^0")
ClassMethod save(params)
{
    
    s ^ZXZX=params
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.s ret=..CompareTime(str)  //结束时间是否大于开始时间
  	.q:ret'=0
	.s ret=..saveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// Creator：      zhouxin
/// CreatDate：    2016-05-18
/// Description:： 查询医嘱对应的收费项
/// Table：        DHC_AppArcLinkTar
/// Input：        pointer 检查项目医嘱容器的
/// Output：       
/// Return：       
/// d ##class(web.DHCAPPArclinkTar).QueryArcLinkTar(10,1,"4497||1","258")
ClassMethod QueryArcLinkTar(rows = 10, page = 1, pointer = "", PartID = "", hospid = "")
{
	
		s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    w "{""rows"":["
	    

	    s tar="",sum=0
		f  s tar=$o(^DHCAPARCLTA(0,"Arc",pointer,tar)) q:tar=""  d
		.s startdate=""
		.f  s startdate=$o(^DHCAPARCLTA(0,"Arc",pointer,tar,startdate)) q:startdate=""  d
		..s link="" 
		..f  s link=$o(^DHCAPARCLTA(0,"Arc",pointer,tar,startdate,link)) q:link=""  d
		...q:+link=0
		...q:'$d(^DHCAPARCLTA(link))
		...q:$d(^DHCAPARCLTA(link))=10
		...s TarStart=$p(^DHCAPARCLTA(link),"^",3)
		...s TarEnd=$p(^DHCAPARCLTA(link),"^",5)
		...s qty=$p(^DHCAPARCLTA(link),"^",10)
		...s UpdUser=$p(^DHCAPARCLTA(link),"^",7)          
		...s UpdTime=$p(^DHCAPARCLTA(link),"^",9)
		...s UpdDate=$p(^DHCAPARCLTA(link),"^",8)
		...s BaseFlag=$p(^DHCAPARCLTA(link),"^",11)
		...s Partdr=+$p(^DHCAPARCLTA(link),"^",12)          ///sufan  2016/07/23
		...Q:(PartID'="")&(Partdr'=+PartID)
		...s PartDesc=""									///sufan  2016/07/23
		...i Partdr'=0 d									///sufan  2016/07/23
		....s PartDesc=$p(^DHCAPPART(Partdr),"^",2)     ///sufan  2016/07/23
		...s code=$p(^DHCTARI(tar),"^",1)
		...s desc=$p(^DHCTARI(tar),"^",2)
		...s tarSub=""
		...s price=0
		...f  s tarSub=$o(^DHCTARI(tar,"P",tarSub)) q:tarSub=""  d
		....s hospDr=$p(^DHCTARI(tar,"P",tarSub),"^",16)
		....set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", hospid)
		....q:hospDr'=GroupHospID
		....s Startdate=$p(^DHCTARI(tar,"P",tarSub),"^",3)
		....s enddate=$p(^DHCTARI(tar,"P",tarSub),"^",4)
		....i enddate="" s enddate=99999
		....q:((+$h<Startdate)||(+$h>=enddate))
		....s Oneprice=$p(^DHCTARI(tar,"P",tarSub),"^",5)
		....s price=Oneprice+price	
		...s sum=price*qty+sum
		...s count=count+1
		...q:count<start
		...q:count>end
	    ...w $case(count,start:"",:",")
	    ...s tarId=tar
		...s tmpObj=##class(web.DHCAPPJsonObject).%New()
	    ...d tmpObj.Put("TarCode",code)
	    ...d tmpObj.Put("TarDesc",desc)
	    ...d tmpObj.Put("ArcId",pointer)
	    ...d tmpObj.Put("TarPrice",price)
	    ...d tmpObj.Put("TarDr",tar)
	    ...d tmpObj.Put("TarStart",##class(web.DHCAPPCommonUtil).DateLogicalToHtml(TarStart)) //hxy $zd(TarStart,3)
	    ...d tmpObj.Put("TarEnd",$case(+TarEnd,0:"",:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(TarEnd))) //hxy $zd(TarEnd,3)
	    ...d tmpObj.Put("ID",link)
	    ...d tmpObj.Put("PartNum",$g(qty))
	    ...d tmpObj.Put("UpdDate",$case(+UpdDate,0:0,:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(UpdDate))) //hxy $zd(UpdDate,3)
	    ...d tmpObj.Put("UpdTime",$case(+UpdTime,0:0,:..%ZT(UpdTime,3)))
	    ...d tmpObj.Put("UpdUser",$p($g(^SSU("SSUSR",+UpdUser)),"^",2))
	    ...d tmpObj.Put("BaseFlag",BaseFlag)
	    ...d tmpObj.Put("PartID",Partdr)        ///sufan  2016/07/23
		...w tmpObj.Json()
		w $case(count,0:"",:",")
		s tmpObj=##class(web.DHCAPPJsonObject).%New()
	    d tmpObj.Put("TarCode","合计:")
	    d tmpObj.Put("TarPrice",sum)
	    w tmpObj.Json()
		s count=count+1
		w "],""total"":"_count_"}"
		q ""
}

/// Creator:     qunianpeng
/// CreateDate:  2016-06-29
/// Description: 检查医嘱项与收费项关联[检查结束时间是否大于开始时间]
/// Table:		 DHC_AppArcLinkTar
/// Return: 	 是 0,否 非0
/// Others:		 w ##class(web.DHCAPPArclinkTar).CompareTime("^^^^^^2016-08-08^2016-01-05^")
ClassMethod CompareTime(str)
{
	
	s TarStart=$p(str,"^",7)
	s TarEnd=$p(str,"^",8)
	s flag=0	
	s:TarStart'="" TarStart=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart) //hxy $zdh(TarStart,3)
	s:(TarEnd'="")&(TarEnd'=0) TarEnd=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd) //$zdh(TarEnd,3)
	s:(TarEnd>0)&(TarStart>TarEnd) flag=-11
	i TarStart<+$h  d   //2017-07-13 sufan 增加结束日期不能早于今天的判断
	.s:(TarEnd>0)&(TarEnd<+$h) flag=-12
	q flag
}

/// Creator：      sufan
/// CreatDate：    2016-07-23
/// Description:： 查询医嘱项与部位表
/// Table：        DHC_AppArcLink
/// Output：       0:成功 ,其他:失败
/// others：       w ##class(web.DHCAPPArclinkTar).QueryArcLink("30","1","^^^2729||1")
ClassMethod QueryArcLink(rows As %String, page As %String, params As %String) As %String
{
	s ^tmepqujian("QueryArcLink")=rows_","_page_","_params
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s code=$p(params,"^",1)    //在串params中取值 
	s desc=$p(params,"^",2)	   //
	s part=$p(params,"^",3)	   //
	s Mastitmmastid=$p(params,"^",4)
	if (code="")&&(desc="")&&(part="")&&(Mastitmmastid="") {
		w ##class(web.DHCAPPJsonCommon).getJsonStartSign(0) //输出json前缀串
		w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
		d ..killTmpGlobal(pid) //k掉临时global
		Q ""
	}
	s h=0,count=0
	s AlRowID=""
	f  s AlRowID=$o(^DHCAPARCL(AlRowID)) q:AlRowID=""  d  //查询表DHC_AppArcLink
	.q:AlRowID=0
	.s ItemID=$p(^DHCAPARCL(AlRowID),"^",1)
	.q:((Mastitmmastid'="")&&(ItemID'=Mastitmmastid))
	.s itmmastid=$p(ItemID,"||",1)
	.s itmmastver=$p(ItemID,"||",2)
	.s ItemCode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //器医嘱项code
	.s ItemDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //取医嘱项描述
	.s ItemPartID=+$p((^DHCAPARCL(AlRowID)),"^",2)        //取部位描述
	.s:ItemPartID=0 ItemPart=""
	.i ItemPartID'=0  d
	..s ItemPart=$p(^DHCAPPART(ItemPartID),"^",2)
	.q:(code'="")&(ItemCode'[code) 
	.q:(desc'="")&(ItemDesc'[desc) 
	.q:(part'="")&(ItemPart'[part) 
	.s h=h+1
	.s tempstr=AlRowID_"^"_ItemID_"^"_ItemDesc_"^"_ItemPartID_"^"_ItemPart
	.s ^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLink",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="AlRowID^ItemID^ItemDesc^ItemPartID^ItemPart"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLink",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLink",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：    2016-07-23
/// Description:： 保存检查医嘱项与部位表
/// Table：        DHC_AppArcLink
/// Input：        AlRowID^ItemID^ItemDesc^ItemPartID^ItemPart
/// Output：       0:成功 ,其他:失败
/// others：       w ##class(web.DHCAPPArclinkTar).SaveArcLink("4^1||1^^1^&&3^1||2^^3^")
ClassMethod SaveArcLink(params As %String) As %String
{
  	s ret=0
	s len=$L(params,"&&")
	f i=1:1:len d
	.s tmpstr=$p(params,"&&",i)
	.i $p(tmpstr,"^",1)'="" q:ret'=0  d
	..s ret=..UpdArcLink(tmpstr)
	.e  d
	..s ret=..InsArcLink(tmpstr)
	q ret
}

/// Creator：      sufan
/// CreatDate：    2016-07-23
/// Description:： 插入DHC_AppArcLink
/// Table：        DHC_AppArcLink
/// Input：        AlRowID^ItemID^ItemDesc^ItemPartID^ItemPart
/// Output：       0:成功 ,其他:失败
/// others：       w ##class(web.DHCAPPArclinkTar).InsArcLink("1^1||1^^1^")
ClassMethod InsArcLink(params As %String) As %String
{
	s ArcID=$p(params,"^",2)
	s PartID=+$p(params,"^",4)
	q:$d(^DHCAPARCL(0,"ArcPart",ArcID,PartID)) -10
	&sql(insert into DHC_AppArcLink (AL_Arc_Dr,AL_Part_Dr)values (:ArcID,:PartID ))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-23
/// Description:： 更新DHC_AppArcLink
/// Table：        DHC_AppArcLink
/// Input：        AlRowID^ItemID^ItemDesc^ItemPartID^ItemPart
/// Output：       0:成功 ,其他:失败
/// others：       w ##class(web.DHCAPPArclinkTar).InsArcLink("1^1||1^^1^")
ClassMethod UpdArcLink(params As %String) As %String
{
         
  	s AlRowID=$p(params,"^",1)
	s ArcID=$p(params,"^",2)
	s PartID=+$p(params,"^",4)
	q:$d(^DHCAPARCL(0,"ArcPart",ArcID,PartID)) -10
	&sql(update DHC_AppArcLink set AL_Arc_Dr=:ArcID,AL_Part_Dr=:PartID where AL_RowID=:AlRowID )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-22
/// Description:： 删除检查项目部位
/// Table：        DHC_AppArcLinkTar
/// Input：        表的id
/// Output：       0:成功 ,其他:失败
/// Others：       w ##class(web.DHCAPPArclinkTar).DeleteArcLink("14")
ClassMethod DeleteArcLink(AlRowID As %String) As %String
{
    
    q:(AlRowID="") 0
    s ret=0
    TS
    
    //部位关联医嘱项
    s ARCIMRowid=$p(^DHCAPARCL(AlRowID),"^",1)
    s PartID=$p(^DHCAPARCL(AlRowID),"^",2)
	s link=""
	for {
		s link=$o(^DHCAPARCLARCi("ArcPart",ARCIMRowid,PartID,link))
		q:link=""
		s ret=..DeleteArclinkArc(link)
	}
	if (ret'=0){
		TRO
		q ret
	}
    //部位关联体位
    s link=""
	for {
		s link=$o(^DHCAPARCPO(0,"Arc",ARCIMRowid,link))
		q:link=""
		s linkPartID=$P(^DHCAPARCPO(link),"^",3)
		continue:(linkPartID'=PartID)
		s ret=##class(web.DHCAppArcLinkPos).remove(link)
	}
	if (ret'=0){
		TRO
		q ret
	}
    
	&sql(delete from DHC_AppArcLink where AL_RowID=:AlRowID)
	if (SQLCODE'=0){
		TRO
		q SQLCODE
	}
	TC
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2016-07-22
/// Description:： 删除检查项目部位
/// Table：        DHC_AppArcLinkTar
/// Input：        表的id
/// Output：       0:成功 ,其他:失败
/// Others：       w ##class(web.DHCAPPArclinkTar).DeleteArclinkTar("1")
ClassMethod DeleteArclinkTar(AltRowID As %String) As %String
{
         
	&sql(delete from DHC_AppArcLinkTar where ALT_RowID=:AltRowID)
	q SQLCODE
}

/// Descript:  医嘱项+部位对应收费项目明细
/// Others:    w ##class(web.DHCAPPArclinkTar).QueryArcLinkTarStat("1","10","2561||1","374") //185
ClassMethod QueryArcLinkTarStat(rows As %String, page As %String, arcimid As %String, PartID As %String, hospid As %String = "") As %String
{
	//n (rows, page, arcimid, PartID)
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=##Class(web.DHCAPPExaRepCom).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s TarCost=0
    
    s h=0,count=0
    //// 医嘱对应收费项目明细
    s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate)) Q:StartDate=""  D
	.Q:StartDate>+$H
	.s LkTarID=""
	.f  s LkTarID=$o(^DHCOLT(0,"ARCIM",arcimid,"Z",StartDate,LkTarID)) Q:LkTarID=""  D
	..s EndDate=+$p(^DHCOLT(LkTarID),"^",5)
	..Q:(EndDate'=0)&&(EndDate<+$H)
	..i EndDate'=0 s EndDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(EndDate) //$zd(EndDate,3)
	..s:EndDate=0 EndDate=""
	..s TarId=$p(^DHCOLT(LkTarID),"^",2)
	..s BasFlag=$p(^DHCOLT(LkTarID),"^",8)				///"Y" /// 基价标志
	..s:BasFlag="" BasFlag="N"      				/// sufan  2017-03-01
	..s TarQty=$p(^DHCOLT(LkTarID),"^",3)
	..s TarCode=$p(^DHCTARI(TarId),"^",1)           /// 项目代码
	..s TarDesc=$p(^DHCTARI(TarId),"^",2)           /// 项目描述
	..s tarSub="",tar=TarId
	..s TarPrice=0
	..f  s tarSub=$o(^DHCTARI(tar,"P",tarSub)) q:tarSub=""  d
	...s hospDr=$p(^DHCTARI(tar,"P",tarSub),"^",16)
	...set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", hospid)
	...q:hospDr'=GroupHospID
	...s startdate=$p(^DHCTARI(tar,"P",tarSub),"^",3)
	...s enddate=$p(^DHCTARI(tar,"P",tarSub),"^",4)
	...i enddate="" s enddate=99999
	...q:((+$h<startdate)||(+$h>=enddate))
	...s Oneprice=$p(^DHCTARI(tar,"P",tarSub),"^",5)
	...s TarPrice=Oneprice+TarPrice	
	..s TarStart=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(StartDate) //hxy $zd(StartDate,3)
	..s TarCost=TarCost+(TarQty*TarPrice)
	..s h=h+1
	..s ListData=TarCode_"^"_TarDesc_"^"_arcimid_"^"_TarPrice_"^"_TarId_"^"_TarStart_"^"_EndDate
	..s ListData=ListData_"^"_""_"^"_TarQty_"^"_""_"^"_""_"^"_""_"^"_BasFlag_"^"_""
	..s ^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLinkTarStat",pid,h)=ListData
	..
	
    //// 医嘱+部位对应收费项目明细
	s TarId=""
	f  s TarId=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId)) q:TarId=""  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId,StartDate)) q:StartDate=""  d
	..s LinkID=""
	..f  s LinkID=$o(^DHCAPARCLTA(0,"Arc",arcimid,TarId,StartDate,LinkID)) q:LinkID=""  d
	...s EndDate=+$p(^DHCAPARCLTA(LinkID),"^",5)   /// 结束日期
	...Q:(EndDate'=0)&&(EndDate<+$H)
	...i EndDate'=0 s EndDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(EndDate) //hxy $zd(EndDate,3)
	...s:EndDate=0 EndDate=""
	...s InPartID=+$p(^DHCAPARCLTA(LinkID),"^",12)   /// 部位
	...Q:InPartID'=PartID
	...s TarQty=+$p(^DHCAPARCLTA(LinkID),"^",10)   /// 数量
	...s TarQty=$s(TarQty=0:1,1:TarQty)
	...s BasFlag=$p(^DHCAPARCLTA(LinkID),"^",11)   /// 基价标志
	...s UpdUser=$p(^DHCAPARCLTA(LinkID),"^",7)    /// 更新人
	...s:UpdUser'="" UpdUser=$p(^SSU("SSUSR",UpdUser),"^",2)       
	...s UpdTime=$p(^DHCAPARCLTA(LinkID),"^",9)    /// 更新时间
	...i UpdTime'=0 s UpdTime=..%ZT(UpdTime,1)
	...s UpdDate=+$p(^DHCAPARCLTA(LinkID),"^",8)    /// 更新日期
	...i UpdDate'=0 s UpdDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(UpdDate) //hxy $zd(UpdDate,3)
	...s PartDesc=$p(^DHCAPPART(PartID),"^",2)     /// 部位描述 sufan  2016/07/23
	...s TarCode=$p(^DHCTARI(TarId),"^",1)           /// 项目代码
	...s TarDesc=$p(^DHCTARI(TarId),"^",2)           /// 项目描述
	...s tarSub="",tar=TarId
	...s TarPrice=0
	...f  s tarSub=$o(^DHCTARI(tar,"P",tarSub)) q:tarSub=""  d
	....s hospDr=$p(^DHCTARI(tar,"P",tarSub),"^",16)
	....set GroupHospID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_TarItemPrice", hospid)
	....q:hospDr'=GroupHospID
	....s startdate=$p(^DHCTARI(tar,"P",tarSub),"^",3)
	....s enddate=$p(^DHCTARI(tar,"P",tarSub),"^",4)
	....i enddate="" s enddate=99999
	....q:((+$h<startdate)||(+$h>=enddate))
	....s Oneprice=$p(^DHCTARI(tar,"P",tarSub),"^",5)
	....s TarPrice=Oneprice+TarPrice	
	...s TarStart=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(StartDate) //hxy $zd(StartDate,3)
	...s TarCost=TarCost+(TarQty*TarPrice)
	...s h=h+1
	...s ListData=TarCode_"^"_TarDesc_"^"_arcimid_"^"_TarPrice_"^"_TarId_"^"_TarStart_"^"_EndDate
	...s ListData=ListData_"^"_LinkID_"^"_TarQty_"^"_UpdDate_"^"_UpdTime_"^"_UpdUser_"^"_BasFlag_"^"_PartID
	...s ^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLinkTarStat",pid,h)=ListData
	..
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 
	
	s ^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLinkTarStat",pid,h+1)="合计:^^^"_TarCost
	///转换数据为Json格式
	S ListTitle="TarCode^TarDesc^ArcId^TarPrice^TarDr^TarStart^TarEnd^ID^PartNum^UpdDate^UpdTime^UpdUser^BaseFlag^PartID"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLinkTarStat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLinkTarStat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLink",pid)
	k ^TMP("DHCST","web.DHCAPPArclinkTar","QueryArcLinkTarStat",pid)
	k ^TMP("DHCST","web.DHCAPPArclinkTar","QueryCheckItemList",pid)
}

/// Creator：  bianshuai
/// CreatDate：2016-07-23
/// Descript： 医嘱项与部位列表
/// w ##Class(web.DHCAPPArclinkTar).QueryCheckItemList("30","1","^^头")
ClassMethod QueryCheckItemList(rows As %String, page As %String, params As %String) As %String
{
	//n (rows, page, params)
	s ^BIANSHUAI(1)=page_"^"_rows
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
    d ..killTmpGlobal(pid) //k掉临时global
    
    s ItemCode=$p(params,"^",1)   /// 医嘱项代码
    s ItemDesc=$p(params,"^",2)   /// 医嘱项ID
    s IPartDesc=$p(params,"^",3)  /// 部位描述
	s h=0,count=0
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(TraID)) Q:TraID=""  D
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) Q:CH=""  D
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)   /// 部位
	..Q:PartID=""
	..s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2)   /// 部位描述
	..Q:(IPartDesc'="")&(PartDesc'[IPartDesc)
	..s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  /// 医嘱项代码
	..Q:(ItemCode'="")&(ItemCode'=arcitmcode)
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	..Q:(ItemDesc'="")&(arcitmdesc'[ItemDesc)
	..s h=h+1
	..s ListData=arcimid_"^"_arcitmdesc_"^"_PartID_"^"_PartDesc
	..s ^TMP("DHCST","web.DHCAPPArclinkTar","QueryCheckItemList",pid,h)=ListData
	.

	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ItemID^ItemDesc^ItemPartID^ItemPart"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPArclinkTar","QueryCheckItemList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPArclinkTar","QueryCheckItemList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// w ##Class(web.DHCAPPArclinkTar).saveArc("0^1616||1^11571||1^0^维生素K1注射液[10mg:1ml]^1^0-9^1-30^Y^0^0^0^0^389")
ClassMethod saveArc(params)
{
   	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
	.s ret=..saveOrUpdateArc(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q ret
}

ClassMethod saveOrUpdateArc(str)
{
  	 Q:..ExistArclinkArc(str) "-3"  //;"代码重复"	 
	 s ID=$p(str,"^",1)
	 s TarDr=$p(str,"^",2)
	 s ArcId=$p(str,"^",3)
	 s PartNum=$p(str,"^",6)
	 
	 s AgeLimits=$p(str,"^",7) 	///add by tanjishan 2020-06
	 s DateLimits=$p(str,"^",8)
	 s ByHandle=$p(str,"^",9)
	 
	 s TarStart=$p(str,"^",12)
	 s TarEnd=$p(str,"^",13)
	 s PartID=$p(str,"^",14)        ///sufan   2016/07/23
	 
	 if (AgeLimits'=""){
		 if (AgeLimits'["-")||(+$P(AgeLimits,"-")'=$P(AgeLimits,"-"))||(+$P(AgeLimits,"-",2)'=$P(AgeLimits,"-",2)){
		    q "-4"  //"年龄范围格式错误"	
	     }
	     s AgeLimits=+$P(AgeLimits,"-")_"-"_+$P(AgeLimits,"-",2)
	 }
	 if (DateLimits'=""){
		 if (DateLimits'["-")||(+$P(DateLimits,"-")'=$P(DateLimits,"-"))||(+$P(DateLimits,"-",2)'=$P(DateLimits,"-",2)){
		    q "-5" ///"日期范围格式错误"	
	     }
	     s DateLimits=+$P(DateLimits,"-")_"-"_+$P(DateLimits,"-",2)
	 }
	 i +ID=0 d
	 .s obj=##class(User.DHCAppArcPartLinkArc).%New()
	 e  d
	 .s obj=##class(User.DHCAppArcPartLinkArc).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.ALTAArcDr=##class(User.ARCItmMast).%OpenId(ArcId)
	 s obj.ALTAArcListDr=##class(User.ARCItmMast).%OpenId(TarDr)
	 s obj.ALTAStartDate=$case(+TarStart,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart)) // hxy 2017-03-02 $zdh(TarStart,3)
	 s obj.ALTAEndDate=$case(TarEnd,"":"",:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd)) //hxy $zdh(TarEnd,3) ///sufan 2016/07/25
	 s obj.ALTAUpdDate=..%SysDate()
	 s obj.ALTAUpdTime=..%SysTime()
	 s obj.ALTAAgeLimits=AgeLimits
	 s obj.ALTADateLimits=DateLimits
	 s obj.ALTAByHandle=ByHandle
	 s:$d(%session) obj.ALTAUpdUserDr=##class(User.SSUser).%OpenId(%session.Get("LOGON.USERID"))
	 s obj.ALTAQty=PartNum
	 s obj.ALTAPartDr=##class(User.DHCAppPart).%OpenId(PartID)   ///sufan 2016/07/23
	 s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

/// 删除部位关联医嘱项
ClassMethod DeleteArclinkArc(AltRowID As %String) As %String
{
         
	&sql(delete from DHC_AppArcPartLinkArc where RowID=:AltRowID)
	q SQLCODE
}

ClassMethod ExistArclinkArc(str)
{
	 s QuitFlag=0
	 s ID=$p(str,"^",1)
	 s TarDr=$p(str,"^",2)
	 s ArcId=$p(str,"^",3)
	 s PartNum=$p(str,"^",6)
	 
	 s AgeLimits=$p(str,"^",7) 	///add by tanjishan 2020-06
	 s DateLimits=$p(str,"^",8)
	 s ByHandle=$p(str,"^",9)
	 
	 s TarStart=$p(str,"^",12)
	 s TarEnd=$p(str,"^",13)
	 s PartID=$p(str,"^",14)        ///sufan   2016/07/23
	 s link=""
	 for {
			s link=$o(^DHCAPARCLARCi("ArcPart",ArcId,PartID,link))
			q:link=""
			continue:link=ID
			S ArcItem=$p(^DHCAPARCLARC(link),"^",1)
			continue:TarDr'=ArcItem
			s TAgeLimits=$p(^DHCAPARCLARC(link),"^",12) 	///add by tanjishan 2020-06
			s TDateLimits=$p(^DHCAPARCLARC(link),"^",13)
			s TByHandle=$p(^DHCAPARCLARC(link),"^",14)
			if (AgeLimits=TAgeLimits)&&(TDateLimits=DateLimits)&&(TByHandle=ByHandle){
				s QuitFlag=1 Q
				}
			
		 }
	q QuitFlag
}

ClassMethod QueryArcLinkArc(rows = 10, page = 1, pointer = "", PartID = "")
{
	
		s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    w "{""rows"":["
	    if (pointer = "")||(PartID=""){
			w "],""total"":"_count_"}"
			q ""
		}
		 s link=""
		 for {
			s link=$o(^DHCAPARCLARCi("ArcPart",pointer,PartID,link))
			q:link=""
			s qty=$p(^DHCAPARCLARC(link),"^",10)
			s UpdUser=$p(^DHCAPARCLARC(link),"^",7)          
			s UpdTime=$p(^DHCAPARCLARC(link),"^",9)
			s UpdDate=$p(^DHCAPARCLARC(link),"^",8)
			s Partdr=+$p(^DHCAPARCLARC(link),"^",11)
			S ArcItem=$p(^DHCAPARCLARC(link),"^",1)
			
			s AgeLimits=$p(^DHCAPARCLARC(link),"^",12) 	///add by tanjishan 2020-06
			s DateLimits=$p(^DHCAPARCLARC(link),"^",13)
			s ByHandle=$p(^DHCAPARCLARC(link),"^",14)
			
			continue:ArcItem="" 
			s TarCode=$p(^ARCIM(+ArcItem,$P(ArcItem,"||",2),1),"^",1) //医嘱项代码
			s TarDesc=$p(^ARCIM(+ArcItem,$P(ArcItem,"||",2),1),"^",2) //医嘱项名称
			s TarDr=ArcItem
			s count=count+1
			q:count<start
			q:count>end
			w $case(count,start:"",:",")
			s tmpObj=##class(web.DHCAPPJsonObject).%New()
			d tmpObj.Put("TarCode",TarCode)
			d tmpObj.Put("TarDesc",TarDesc)
			d tmpObj.Put("ArcId",pointer)
			d tmpObj.Put("TarDr",ArcItem)
			d tmpObj.Put("ID",link)
			d tmpObj.Put("PartNum",$g(qty))
			d tmpObj.Put("UpdDate",$case(+UpdDate,0:0,:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(UpdDate))) //hxy $zd(UpdDate,3)
			d tmpObj.Put("UpdTime",$case(+UpdTime,0:0,:..%ZT(UpdTime,3)))
			d tmpObj.Put("UpdUser",$p($g(^SSU("SSUSR",+UpdUser)),"^",2))
			d tmpObj.Put("PartID",Partdr)        ///sufan  2016/07/23
			d tmpObj.Put("AgeLimits",AgeLimits)
			d tmpObj.Put("DateLimits",DateLimits)
			d tmpObj.Put("ByHandle",ByHandle)
			w tmpObj.Json()
		 }
		
		//s count=count+1
		w "],""total"":"_count_"}"
		q ""
}

ClassMethod QueryArcItmDetail(rows As %String, page As %String, Input As %String, HospID As %String, q = "") As %String
{
	s ^tmpnk("QueryArcItmDetail")=Input_"^"_HospID_"^"_q
	i q'="" s Input=q
	i Input="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Input="" ""
	
	s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr ="select distinct alias_arcim_dr from arc_alias "_
    	"where %ALPHAUP(alias_text) like '"_Input_"' or  %ALPHAUP(ALIAS_Desc) like '"_Input_"'" 
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    if $$$ISERR(sc) d DisplayError^%apiOBJ(sc) q ""
    
    s pid=1
	s EndPage=page*rows  		   //结束行
	s StPage=((page-1)*rows)+1     //开始行
    s Num = 0
    while(result.Next()){
	    s arcitemId = result.Data("ALIAS_ARCIM_DR")
	    s itmmastid=$p(arcitemId,"||",1)
	    s itmmastver=$p(arcitemId,"||",2)
	    continue:+itmmastver=0
        continue:'$d(^ARCIM(itmmastid,itmmastver))
		s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
		s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcitemId,HospID)="N"
		s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcitemId,+$h,"","","","",HospID)
		s arcitmprice=+$p(arcitmprice,"^") 					//医嘱项价格
		i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice  //小于0的价格前补0
		s ServerMaterial=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",6)
		//continue:(ServerMaterial'="Service")&(ServerMaterial'="S")
		s arcitmCat=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10)
		s arcitmCat=$p(^ARC("IC",arcitmCat),"^",2)
		s datefrom=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",13)
	 	s dateto=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",1)
	 	i datefrom>$h continue
	 	i dateto,dateto<$h continue
        s ListData = arcitemId_"^"_arcitmcode_"^"_arcitmdesc_"^"_arcitmprice_"^"_arcitmCat
        s Num=Num+1
		s ArcItmDetail("DHCDocCure","DHCDoc.DHCDocCure.Config","QueryArcItmDetail",pid,Num)=ListData
    }
  	i Num="0" w ##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(0) //输出空的json串
	q:Num="0" ""

	s maxrow=Num
	i EndPage>maxrow S EndPage=maxrow
	
	s ListTitle="tarId^code^desc^price^itmCat"
	w ##class(DHCDoc.DHCDocCure.Util).getJsonStartSign(Num)        //输出json前缀串

	s quitflag=0
	s Num=0
	s index=""
	f  s index=$o(ArcItmDetail("DHCDocCure","DHCDoc.DHCDocCure.Config","QueryArcItmDetail",pid,index)) q:(index="")||(quitflag=1)  d
	.s ListData=ArcItmDetail("DHCDocCure","DHCDoc.DHCDocCure.Config","QueryArcItmDetail",pid,index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..w ##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData)
	.else  d
	..w ","_##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData)
	
	w ##class(DHCDoc.DHCDocCure.Util).getJsonEndSign()             //输出json结尾符
	q ""
}

}
