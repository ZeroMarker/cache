Class web.DHCEQMatchCatlist Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Author:Add By CZF 2018-04-23
/// Description:匹配设备分类
/// Command:d ##Class(web.DHCEQMatchCatlist).UpdateMatchCat()
ClassMethod UpdateMatchCat()
{
	k ^TempEQMatchCat("ReturnStr")
	s ReturnStr=""
	s ErrMsg=0
	s rowid=0
	f  s rowid=$o(^DHCEQMatchCatList(rowid))  quit:rowid=""  d
	.s Name=$p(^DHCEQMatchCatList(rowid),"^",1)
	.s MCLFinanceTypeDR=$p(^DHCEQMatchCatList(rowid),"^",13)	 //匹配时根据类组匹配  czf 20201028
	.s MCLStatCatDR=$p(^DHCEQMatchCatList(rowid),"^",14)
	.q:$p(^DHCEQMatchCatList(rowid),"^",6)'=""
	.s ReturnStr=##Class(web.DHCEQMatchCatlist).MatchMstCat(rowid,MCLFinanceTypeDR,MCLStatCatDR)
	.i ReturnStr'="OK" d
	..s ^TempEQMatchCat("ReturnStr",rowid)=ReturnStr
	..i ErrMsg=0 s ErrMsg=Name
	..e  s ErrMsg=ErrMsg_","_Name
	q ErrMsg
}

/// Author:Add By CZF 2018-04-23
/// Desc:设备分类匹配
/// Input:DHC_EQMatchCatList的RowID
/// Method:d ##Class(web.DHCEQMatchCatlist).MatchMstCat(21)
ClassMethod MatchMstCat(rowid, MCLFinanceTypeDR As %String = "", MCLStatCatDR As %String = "")
{
	s RetStr=""
 	s Equip=$p(^DHCEQMatchCatList(rowid),"^",1)
 	s Equip=$ZCONVERT(Equip,"U")
 	i Equip="" s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"名称不能为空")
 	i RetStr'="" q RetStr
	s Name=Equip
	s MCLDesc=Equip
 	s len=$l(Name)
 	s CatCount=0
 	s Find=0
 	s Type=0
 	s (MatchName,FstCatDR,SndCatDR,TrdCatDR,FstFTCatDR,SndFTCatDR,TrdFTCatDR,FstStatCatDR,SndStatCatDR,TrdStatCatDR)=""
 	s (FstKBSItmDR,SndKBSItmDR,TrdKBSItmDR)=""
 	
 	i $d(^DHCEQKB("DHCEQKBSMstItem",0,"Frequency","N",Name)) d
 	.s Find=1
 	.s MatchName=Name
 	.s Type=1			;全字精确匹配
 	e  d
 	.s Name=$ZCONVERT(Name,"U")
 	.s Name=$replace(Name,"（","(")
 	.s Name=$replace(Name,"）",")")
 	.s Name=$replace(Name,"，",",")
 	.s FstPiece=$p(Name,"(",1)
 	.i (Name["(")&&(FstPiece'="") s Name=FstPiece
 	.e  d
 	..s SndPiece=$p(Name,")",2)
 	..i (Name[")")&&(SndPiece'="") s Name=SndPiece
 	.s len=$l(Name)
 	.f i=1:1:3 d
 	..;q:(len-i+1<i)||(Find=1)
 	..;s Equip=$e(Name,i,len-i+1)
 	..q:(len<i)||(Find=1)
 	..s Equip=$e(Name,i,len)	//改为去左边的字 2021-12-09
 	..q:$l(Equip)<2		;过滤去字后长度小于2的 czf 20201026
 	..i (MCLDesc'=Equip)&&($d(^DHCEQKB("DHCEQKBSMstItem",0,"Frequency","N",Equip))) d
 	...s Find=1
 	...s MatchName=Equip
 	...s Type=2
 	..q:Find=1				//czf 2021-12-10 end 去字后首先匹配全等的数据
 	..s MstItem=""
 	..f  s MstItem=$o(^DHCEQKB("DHCEQKBSMstItem",0,"Frequency","N",MstItem)) q:(MstItem="")||(Find=1)  d
 	...q:$l(MstItem)<3	;过滤库中单个字或两字的设备项 czf 20201026
 	...i ((MstItem[Equip)||(Equip[MstItem)) d
 	....s Find=1
 	....s MatchName=MstItem
 	....s:i=1 Type=2		;全字模糊匹配
 	....s:i=2 Type=3		;首尾去一字模糊匹配
 	....s:i=3 Type=4		;首尾去两字模糊匹配
 	//为匹配到的设备取得分类
 	i Find=1 d
 	.d GetEquipCatDR
 	d SavaEquipCatDR
 	q:RetStr="" "OK"
	q RetStr
	
GetEquipCatDR
	i MatchName="" quit
 	s Frequency=""
 	f  s Frequency=$o(^DHCEQKB("DHCEQKBSMstItem",0,"Frequency","N",MatchName,Frequency),-1) q:(Frequency="")||(Frequency=0)||(CatCount=3)  d
 	.s KBSRowID=""
 	.f  s KBSRowID=$o(^DHCEQKB("DHCEQKBSMstItem",0,"Frequency","N",MatchName,Frequency,KBSRowID)) q:(KBSRowID="")||(CatCount=3)  d
 	..s EquipCatDR=$p(^DHCEQKB("DHCEQKBSMstItem",KBSRowID),"^",5)
 	..s FinanceTypeDR=$p(^DHCEQKB("DHCEQKBSMstItem",KBSRowID),"^",3)
 	..s StatCatDR=$p(^DHCEQKB("DHCEQKBSMstItem",KBSRowID),"^",4)
 	..q:(FinanceTypeDR=6)						//过滤低值易耗品和图书,档案 czf 20210408
 	..;q:(MCLFinanceTypeDR'="")&&(MCLFinanceTypeDR'=FinanceTypeDR)	//匹配时根据类组匹配  czf 20201028
 	..;q:(MCLStatCatDR'="")&&(MCLStatCatDR'=StatCatDR)				//根据类型匹配 czf 20201028
 	..i (EquipCatDR'=FstCatDR)&&(EquipCatDR'=SndCatDR)&&(EquipCatDR'=TrdCatDR) d
 	...i (FstCatDR'="")&&(SndCatDR'="")&&(TrdCatDR="") d
 	....s TrdCatDR=EquipCatDR
 	....s TrdFTCatDR=FinanceTypeDR
 	....s TrdStatCatDR=StatCatDR
 	....s TrdKBSItmDR=KBSRowID
 	...i (FstCatDR'="")&&(SndCatDR="") d
 	....s SndCatDR=EquipCatDR
 	....s SndFTCatDR=FinanceTypeDR
 	....s SndStatCatDR=StatCatDR
 	....s SndKBSItmDR=KBSRowID
 	...i FstCatDR="" d
 	....s FstCatDR=EquipCatDR
 	....s FstFTCatDR=FinanceTypeDR
 	....s FstStatCatDR=StatCatDR
 	....s FstKBSItmDR=KBSRowID
 	...s CatCount=CatCount+1
	quit
	
SavaEquipCatDR
	k PLIST
	s PLIST(3)=Type
	s PLIST(4)=MatchName
	s PLIST(5)=FstFTCatDR
	s PLIST(6)=FstStatCatDR
	s PLIST(7)=FstCatDR
	s PLIST(8)=SndFTCatDR
	s PLIST(9)=SndStatCatDR
	s PLIST(10)=SndCatDR
	s PLIST(11)=TrdFTCatDR
	s PLIST(12)=TrdStatCatDR
	s PLIST(13)=TrdCatDR
	s PLIST(19)=FstKBSItmDR
	s PLIST(20)=SndKBSItmDR
	s PLIST(21)=TrdKBSItmDR
 	&SQL(Update SQLUSER.DHC_EQMatchCatList Values :PLIST() where MCL_RowID=:rowid)
	i SQLCODE  s RetStr=##Class(web.DHCEQImportData2CSP).RetErrorValue(RetStr,"更新DHC_EQMatchCatList失败: 设备名称="_Name_"SQLCODE="_SQLCODE)
 	quit
}

/// Author:CZF 20180423
/// Description:分类匹配表数据
/// Command:d ##class(%ResultSet).RunQuery("web.DHCEQMatchCatlist","GetCatlist","","")
Query GetCatlist(Name As %String = "", Type As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TType:%String,TMatchName:%String,TFstFtTypeDR:%String,TFstStatCatDR:%String,TFstCatDR:%String,TSndFtTypeDR:%String,TSndStatCatDR:%String,TSndCatDR:%String,TTrdFtTypeDR:%String,TTrdStatCatDR:%String,TTrdCatDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TFstFtType:%String,TFstStatCat:%String,TFstCat:%String,TSndFtType:%String,TSndStatCat:%String,TSndCat:%String,TTrdFtType:%String,TTrdStatCat:%String,TTrdCat:%String,TRow:%String,TJob:%String")
{
}

ClassMethod GetCatlistExecute(ByRef qHandle As %Binary, Name As %String = "", Type As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("MatchCatList",User)
	s TJob=$J
	s rowid=0
	f  s rowid=$o(^DHCEQMatchCatList(rowid))  q:rowid=""  d
	.d ResetVariablesGetCatlist
	.s TRowID = rowid
	.s DataList=$G(^DHCEQMatchCatList(rowid))
	.s TName=$p(DataList,"^",1)
	.q:(Name'="")&&(TName'[Name)
	.s TType=$p(DataList,"^",2)
	.s TType=$CASE(TType,"1":"高度匹配","2":"中度匹配","3":"低度匹配","4":"低度匹配","0":"未匹配","":"")
	.q:(Type'="")&&(Type'=TType)
	.s TMatchName=$p(DataList,"^",3)
	.s TFstFtTypeDR=$p(DataList,"^",4)
	.s TFstStatCatDR=$p(DataList,"^",5)
	.s TFstCatDR=$p(DataList,"^",6)
	.s TSndFtTypeDR=$p(DataList,"^",7)
	.s TSndStatCatDR=$p(DataList,"^",8)
	.s TSndCatDR=$p(DataList,"^",9)
	.s TTrdFtTypeDR=$p(DataList,"^",10)
	.s TTrdStatCatDR=$p(DataList,"^",11)
	.s TTrdCatDR=$p(DataList,"^",12)
	.s THold1=$p(DataList,"^",13)
	.s THold2=$p(DataList,"^",14)
	.s THold3=$p(DataList,"^",15)
	.s THold4=$p(DataList,"^",16)
	.s THold5=$p(DataList,"^",17)
	.s TFstFtType=##Class(web.DHCEQCommon).GetTrakNameByID("financetype", TFstFtTypeDR)
	.s TFstStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat", TFstStatCatDR)
	.s TFstCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat", TFstCatDR)
	.s TSndFtType=##Class(web.DHCEQCommon).GetTrakNameByID("financetype", TSndFtTypeDR)
	.s TSndStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat", TSndStatCatDR)
	.s TSndCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat", TSndCatDR)
	.s TTrdFtType=##Class(web.DHCEQCommon).GetTrakNameByID("financetype", TTrdFtTypeDR)
	.s TTrdStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat", TTrdStatCatDR)
	.s TTrdCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat", TTrdCatDR)
	.d OutputRowGetCatlist
	Quit $$$OK
OutputRowGetCatlist
	s Data=$lb(TRowID,TName,TType,TMatchName,TFstFtTypeDR,TFstStatCatDR,TFstCatDR,TSndFtTypeDR,TSndStatCatDR,TSndCatDR,TTrdFtTypeDR,TTrdStatCatDR,TTrdCatDR,THold1,THold2,THold3,THold4,THold5,TFstFtType,TFstStatCat,TFstCat,TSndFtType,TSndStatCat,TSndCat,TTrdFtType,TTrdStatCat,TTrdCat,TRow,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	Set ^DHCEQTemp("MatchCatList",User,TJob,TRow)=TRowID_"^"_TName_"^"_TType_"^"_TMatchName_"^"_TFstFtType_"^"_TFstStatCat_"^"_TFstCat_"^"_TSndFtType_"^"_TSndStatCat_"^"_TSndCat_"^"_TTrdFtType_"^"_TTrdStatCat_"^"_TTrdCat
	Set TRow=TRow+1
	quit
ResetVariablesGetCatlist
	s (TRowID,DataList,TName,TType,TMatchName,TFstFtTypeDR,TFstStatCatDR,TFstCatDR,TSndFtTypeDR,TSndStatCatDR,TSndCatDR,TTrdFtTypeDR,TTrdStatCatDR,TTrdCatDR,THold1,THold2,THold3,THold4,THold5,TFstFtType,TFstStatCat,TFstCat,TSndFtType,TSndStatCat,TSndCat,TTrdFtType,TTrdStatCat,TTrdCat)=""
	quit
}

ClassMethod GetCatlistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCatlistExecute ]
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

ClassMethod GetCatlistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCatlistExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Author：add by czf 20180516
/// Description:取到打印导出的查询信息
/// Input:PNum:行号,
ClassMethod GetOneMatchCatList(PNum, job)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i PNum=0 q $o(^DHCEQTemp("MatchCatList",User,job,""),-1)
	q $g(^DHCEQTemp("MatchCatList",User,job,PNum))
}

/// Author：add by czf 20180516
/// Description:更新DHCEQKBSMstItem表分类对照类型及财务大类
/// Output:0:成功 其他:失败
/// Command:d ##Class(web.DHCEQMatchCatlist).EquipCatISLinkStatCat()
ClassMethod EquipCatISLinkStatCat()
{
	s count=0
	s EquipCatDR=""
	f  s EquipCatDR=$o(^DHCEQKB("DHCEQKBSMstItem",0,"CatDR",EquipCatDR)) q:EquipCatDR=""  d
	.s KBSRowID=""
	.f  s KBSRowID=$o(^DHCEQKB("DHCEQKBSMstItem",0,"CatDR",EquipCatDR,KBSRowID)) q:KBSRowID=""  d
	..;q:$p($g(^DHCEQKB("DHCEQKBSMstItem",KBSRowID)),"^",8)="Y"
	..s KBStatCatDR=$p($g(^DHCEQKB("DHCEQKBSMstItem",KBSRowID)),"^",4)
	..s ECStatCatDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",11)
	..;s LinkFlag="N"
	..;i KBStatCatDR=ECStatCatDR s LinkFlag="Y"
	..s ECFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",10)
	..&SQL(Update SQLUSER.DHC_EQKBSMstItem Set SMI_Hold1=:ECFinanceTypeDR,SMI_Hold2=:ECStatCatDR where SMI_RowID=:KBSRowID)
	..i SQLCODE s count=count+1
	..q:SQLCODE
	
	q count
}

/// czf 2021-12-03
/// 更新标准设备项库
/// 根据匹配数据与项目提供数据进行比对，记录项目匹配数与相同的
/// Command:d ##Class(web.DHCEQMatchCatlist).UpdKBSMasterItem()
ClassMethod UpdKBSMasterItem()
{
	s SQLCODE=0
	s ErrMsg=0
	s rowid=0
	f  s rowid=$o(^DHCEQMatchCatList(rowid))  quit:rowid=""  d
	.s Name=$p(^DHCEQMatchCatList(rowid),"^",1)
	.s Code=##class(web.DHCEQCHanZiEncoding).GetEncoding(Name,4,"","U")
	.s MCLFTDR=$p(^DHCEQMatchCatList(rowid),"^",4)
	.s MCLSCDR=$p(^DHCEQMatchCatList(rowid),"^",5)
	.s MCLECDR=$p(^DHCEQMatchCatList(rowid),"^",6)
	.s FinanceTypeDR=$p(^DHCEQMatchCatList(rowid),"^",13)	 //匹配时根据类组匹配  czf 20201028
	.s StatCatDR=$p(^DHCEQMatchCatList(rowid),"^",14)
	.s CatDR=$p(^DHCEQMatchCatList(rowid),"^",15)
	.s UnitID=$p(^DHCEQMatchCatList(rowid),"^",16)
	.s HospID=$p(^DHCEQMatchCatList(rowid),"^",17)
	.q:HospID=""
	.s FstKBSItemDR=$p(^DHCEQMatchCatList(rowid),"^",18)
	.s SndKBSItemDR=$p(^DHCEQMatchCatList(rowid),"^",19)
	.s TrdKBSItemDR=$p(^DHCEQMatchCatList(rowid),"^",20)
	.s MCLHold1=$p(^DHCEQMatchCatList(rowid),"^",21)
	.;SMI_Hold7记录每个标准设备项被匹配的次数，SMI_Hold4
	.i (FinanceTypeDR=FstKBSItemDR)&&(StatCatDR=SndKBSItemDR)&&(CatDR=TrdKBSItemDR) d
	..
	.i FstKBSItemDR'="" d
	..s FstKBSItemMatchNum=$p($g(^DHCEQKB("DHCEQKBSMstItem",FstKBSItemDR)),"^",24)
	..s FstKBSItemMatchNum=FstKBSItemMatchNum+1
	..&SQL(Update SQLUSER.DHC_EQKBSMstItem Set SMI_Hold7=:FstKBSItemMatchNum where SMI_RowID=:FstKBSItemDR)
	.i SndKBSItemDR'="" d
	..s SndKBSItemMatchNum=$p($g(^DHCEQKB("DHCEQKBSMstItem",SndKBSItemDR)),"^",24)
	..s SndKBSItemMatchNum=SndKBSItemMatchNum+1
	..&SQL(Update SQLUSER.DHC_EQKBSMstItem Set SMI_Hold7=:SndKBSItemMatchNum where SMI_RowID=:SndKBSItemDR)
	.i TrdKBSItemDR'="" d
	..s TrdKBSItemMatchNum=$p($g(^DHCEQKB("DHCEQKBSMstItem",TrdKBSItemDR)),"^",24)
	..s TrdKBSItemMatchNum=TrdKBSItemMatchNum+1
	..&SQL(Update SQLUSER.DHC_EQKBSMstItem Set SMI_Hold7=:TrdKBSItemMatchNum where SMI_RowID=:TrdKBSItemDR)
	/*	
	.;新医院数据,或未匹配到的数据导入标准设备项表
	.k PLIST
	.i (MCLHold1="1")||(MCLFTDR="") d
	..s PLIST(2)=Name
	..s PLIST(3)=Code
	..s PLIST(4)=FinanceTypeDR		;财务大类
	..s PLIST(5)=StatCatDR			;设备类型
	..s PLIST(6)=CatDR			;设备分类
	..s PLIST(8)=UnitID			;单位
	..s PLIST(9)="N"			;无效标志
	..s PLIST(17)=HospID			;医院ID
	..s PLIST(18)="N"				;设备分类末级标志
	..s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",CatDR))
	..i Find=0 s PLIST(18) ="Y"
	..&SQL(Insert Into SQLUSER.DHC_EQKBMstItem Values :PLIST())
	..q:SQLCODE'=0
	..s RowID=$G(%ROWID)
	..s KBSValue=##Class(web.DHCEQImportData2CSP).UpdateKBSMstItem(RowID,"")
	..q:KBSValue'=0
	.;标记匹配分类和医院给的不一致的设备项
	.i (MCLFTDR'=FinanceTypeDR)||(MCLSCDR'=StatCatDR)||(MCLECDR'=CatDR) d
	..&SQL(Update SQLUSER.DHC_EQMatchCatList Set MCL_Hold2='1' where MCL_RowID=:rowid)
	.q:SQLCODE'=0
	.;
	*/
	q SQLCODE
}

/// 根据医院设备项生成标准设备项库数据
/// Command:w ##Class(web.DHCEQMatchCatlist).InsertKBSMstItem()
ClassMethod InsertKBSMstItem()
{
	k ^DHCEQTempCZF("InsertKBSMstItem")
	s count=0
	s KBRowID=0
	f  s KBRowID=$o(^DHCEQKB("DHCEQKBMstItem",KBRowID)) q:KBRowID=""  d
	.s KBInfo=$g(^DHCEQKB("DHCEQKBMstItem",KBRowID))
	.s KBSValue=##Class(web.DHCEQImportData2CSP).UpdateKBSMstItem(KBRowID,"")
	.i KBSValue s ^DHCEQTempCZF("InsertKBSMstItem",KBRowID)=KBSValue,count=count+1
	.q:+KBSValue'=0
	
	q count
}

/// 标准设备项库名称规范化
/// Command:w ##Class(web.DHCEQMatchCatlist).UpdateKBSMstItem()
ClassMethod UpdateKBSMstItem()
{
	k ^DHCEQTempCZF("UpdateKBSMstItem")
	s count=0
	s KBRowID=0
	f  s KBRowID=$o(^DHCEQKB("DHCEQKBSMstItem",KBRowID)) q:KBRowID=""  d
	.s KBInfo=$g(^DHCEQKB("DHCEQKBSMstItem",KBRowID))
	.s desc=$p(KBInfo,"^",1)
	.s desc=$ZCONVERT(desc,"U")
 	.s desc=$replace(desc,"（","(")
 	.s desc=$replace(desc,"）",")")
 	.s desc=$replace(desc,"，",",")
 	.s code=$p(KBInfo,"^",2)
	.s code=$ZCONVERT(code,"U")
 	.s code=$replace(code,"（","(")
 	.s code=$replace(code,"）",")")
 	.s code=$replace(code,"，",",")
 	.&SQL(Update SQLUSER.DHC_EQKBSMstItem set SMI_Desc=:desc,SMI_Code=:code where SMI_RowID=:KBRowID)
 	.i SQLCODE s ^DHCEQTempCZF("UpdateKBSMstItem",KBRowID)=desc,count=count+1
 	.q:SQLCODE'=0
	
	q count
}

}
