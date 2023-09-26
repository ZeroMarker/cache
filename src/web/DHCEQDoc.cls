Import SQLUser

Class web.DHCEQDoc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 修改:2009-08-20 党军 begin
/// 描述:设备与验收单资料信息操作,设备更改对应验收单资料时,验收单资料不发生变化
///     而增加一条设备操作验收单记录
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", CheckListDR As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 i rowid'="" s OCLDR=$p($g(^DHCEQDoc(rowid)),"^",16)
 s EquipDR=$p(val,"^",2)
 s PLIST(15)=$p(val,"^",2)	;EquipDR
 i (+isDel=1)
 {
	 i (CheckListDR'="")||(OCLDR="") //验收单或设备删除自己本身的资料
	 {
		 s OldRowID=$p($g(^DHCEQDoc(rowid)),"^",17)
		 i OldRowID=""
		 {
			 &SQL(Delete From SQLUSER.DHC_EQDoc where DOC_RowID = :rowid) 
		 }
		 else
		 {
			 s PLIST(19)="2"
			 &SQL(Update SQLUSER.DHC_EQDoc Values :PLIST() where DOC_RowID = :rowid)
		 }
	 }
  	 i (OCLDR'="")&&(EquipDR'="")
	 {
		 s PLIST(18)=rowid
		 s PLIST(19)="2" 
		 &SQL(Insert Into SQLUSER.DHC_EQDoc Values :PLIST())
	 }
	 if SQLCODE  q SQLCODE
	 q rowid
 }
 s PLIST(2) = $p(val,"^",3)	;DocOriginalDR
 s PLIST(3) = $p(val,"^",4)	;DocName
 s PLIST(4) = $p(val,"^",5)	;LocDR
 s PLIST(5) = $p(val,"^",6)	;ManagerDR
 s PLIST(6) = $p(val,"^",7)	;ShareNum
 s PLIST(7) = $p(val,"^",8)	;PagesNum
 s PLIST(8) = $p(val,"^",9)	;Remark
 s PLIST(16) = $p(val,"^",10)   ;DocTypeDR
 s PLIST(17) = CheckListDR   ;CheckListDR
 //2010-06-11 党军 begin 检测数据是否重复
 s Find=..CheckRepeat(rowid,PLIST(15),PLIST(17),PLIST(3))
 if Find>0 q -99
 //2010-06-11 党军 end
 if (rowid'="") 
 {
	 s PLIST(12) = user
	 s PLIST(13) = +$H
	 s PLIST(14) = $P($H,",",2)
	 i (CheckListDR'="")||(OCLDR="") //验收单或设备更新自己本身的资料
	 {
		 &SQL(Update SQLUSER.DHC_EQDoc Values :PLIST() where DOC_RowID = :rowid)
	 }
	 i (OCLDR'="")&&(EquipDR'="")
	 {
		 s PLIST(18)=rowid
		 s PLIST(19)="1" 
		 &SQL(Insert Into SQLUSER.DHC_EQDoc Values :PLIST())
	 }
 }
 else
 {	 
  	 s PLIST(9) = user
	 s PLIST(10) = +$H
	 s PLIST(11) = $P($H,",",2)
	 &SQL(Insert Into SQLUSER.DHC_EQDoc Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQDoc(rowid)
	s resultex=resultex_"^"	;DocOriginalDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDocOriginal",$p(result,"^",1))),"^",2)
	s resultex=resultex_"^"	;LocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"	;ManagerDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;UpdateDate
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",14))),"^",1)
	s resultex=resultex_"^"	;DocTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDocType",$p(result,"^",15))),"^",2)
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 修改:2009-08-20 党军 begin
/// 描述:GetDoc查询增加验收单ID传入参数,实现设备资料信息与验收单资料信息综合处理
Query GetDoc(EquipDR As %String, CheckListDR As %String, ConfigFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDocOriginalDR:%String,TDocName:%String,TLocDR:%String,TManagerDR:%String,TShareNum:%String,TPagesNum:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TEquipDR:%String,TDocOriginal:%String,TLoc:%String,TManager:%String,TAddUser:%String,TUpdateUser:%String,TEquip:%String,TDocTypeDR:%String,TDocType:%String,TSourceType:%String,TRow:%String")
{
}

ClassMethod GetDocExecute(ByRef qHandle As %Binary, EquipDR As %String, CheckListDR As %String, ConfigFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataGetDoc
	Quit $$$OK
BuildDataGetDoc
	i CheckListDR'="" d //验收单资料信息
	.f  s rowid=$o(^DHCEQDoc(0,"CheckListDR",CheckListDR,rowid)) q:rowid=""  d
	..;验收明细对应为主设备的附件,附属设备的附件不在其中列出	Mozy	914928	2019-7-11
	..q:ConfigFlag'=""
	..d ResetVariablesGetDoc
	..s TRowID=rowid
	..s TSourceType="验收单"
	..d GetListInfo
	..d OutputRowGetDoc
	e  d
	.s SourceID=$p($g(^DHCEQEquip(EquipDR)),"^",77)
	.i SourceID'="" d
	..f  s rowid=$o(^DHCEQDoc(0,"CheckListDR",SourceID,rowid)) q:rowid=""  d
	...q:ConfigFlag'=""
	...d ResetVariablesGetDoc
	...s TRowID=rowid
	...s TSourceType="验收单"
	...s NewRowid=$o(^DHCEQDoc(0,"OldRowID",EquipDR,rowid,0))
	...i NewRowid'="" d
	....s TRowID=NewRowid
	....s TSourceType="改自验收单"
	...q:$p($g(^DHCEQDoc(TRowID)),"^",18)="2"
	...d GetListInfo
	...d OutputRowGetDoc
	.s NewRowid=0
	.f  s NewRowid=$o(^DHCEQDoc(0,"Equip",EquipDR,NewRowid)) q:NewRowid=""  d
	..d ResetVariablesGetDoc
	..s TRowID=NewRowid
	..s TSourceType="设备"
	..q:$p($g(^DHCEQDoc(TRowID)),"^",18)'=""
	..d GetListInfo
	..d OutputRowGetDoc
	quit
GetListInfo
	s TDocOriginalDR = $p($g(^DHCEQDoc(TRowID)),"^",1)
	i TDocOriginalDR '=""  d
	.s TDocOriginal = $p($g(^DHCEQCCode("DHCEQCDocOriginal",TDocOriginalDR)),"^",2)
	s TDocName = $p($g(^DHCEQDoc(TRowID)),"^",2)
	s TLocDR = $p($g(^DHCEQDoc(TRowID)),"^",3)
	i TLocDR '=""  d
	.s TLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	s TManagerDR = $p($g(^DHCEQDoc(TRowID)),"^",4)
	i TManagerDR '=""  d
	.s TManager = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TManagerDR)
	s TShareNum = $p($g(^DHCEQDoc(TRowID)),"^",5)
	s TPagesNum = $p($g(^DHCEQDoc(TRowID)),"^",6)
	s TRemark = $p($g(^DHCEQDoc(TRowID)),"^",7)
	s TAddUserDR = $p($g(^DHCEQDoc(TRowID)),"^",8)
	i TAddUserDR '=""  d
	.s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDoc(TRowID)),"^",9),"date")
	s TAddTime = $p($g(^DHCEQDoc(TRowID)),"^",10)
	s TUpdateUserDR = $p($g(^DHCEQDoc(TRowID)),"^",11)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDoc(TRowID)),"^",12),"date")
	s TUpdateTime = $p($g(^DHCEQDoc(TRowID)),"^",13)
	s TEquipDR = $p($g(^DHCEQDoc(TRowID)),"^",14)
	i TEquipDR '=""  d
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	s TDocTypeDR = $p($g(^DHCEQDoc(TRowID)),"^",15)
	i TDocTypeDR '=""  d
	.s TDocType = $p($g(^DHCEQCCode("DHCEQCDocType",TDocTypeDR)),"^",2)
	quit
OutputRowGetDoc
	s TRow=TRow+1
	s Data=$lb(TRowID,TDocOriginalDR,TDocName,TLocDR,TManagerDR,TShareNum,TPagesNum,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquipDR,TDocOriginal,TLoc,TManager,TAddUser,TUpdateUser,TEquip,TDocTypeDR,TDocType,TSourceType,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDoc
	s (TRowID,TDocOriginalDR,TDocName,TLocDR,TManagerDR,TShareNum,TPagesNum,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TEquipDR,TDocOriginal,TLoc,TManager,TAddUser,TUpdateUser,TEquip,TDocTypeDR,TDocType,TSourceType)=""
	quit
}

ClassMethod GetDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocExecute ]
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

ClassMethod GetDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckRepeat(DocID, EquipID, CheckListID, DocName)
{
	n (DocID,EquipID,CheckListID,DocName)
	s RepeatFlag=0
	s OldRowID=0
	s RowID=0
	if (EquipID'="")  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQDoc(0,"Equip",EquipID,RowID)) q:((RowID="")||(RepeatFlag=1))  d
	..q:$p(^DHCEQDoc(RowID),"^",2)'=DocName
	..q:$p(^DHCEQDoc(RowID),"^",18)=2		;OperFlag:0:新增|1:修改|2:删除
	..q:RowID=DocID
	..s RepeatFlag=1
	.i RepeatFlag=0  d
	..s CheckListID=$p(^DHCEQEquip(EquipID),"^",77)
	..i DocID'="" s OldRowID=$p(^DHCEQDoc(DocID),"^",17)
	i RepeatFlag=1 q RepeatFlag
	i CheckListID'=""  d
	.s RowID=0
	.f  s RowID=$o(^DHCEQDoc(0,"CheckListDR",CheckListID,RowID)) q:((RowID="")||(RepeatFlag=1))  d
	..q:$p(^DHCEQDoc(RowID),"^",2)'=DocName
	..q:$p(^DHCEQDoc(RowID),"^",18)=2		;OperFlag:0:新增|1:修改|2:删除
	..q:RowID=DocID
	..q:RowID=OldRowID
	..s RepeatFlag=1
	
	q RepeatFlag
}

/// Mozy	2017-1-11
/// 判断该设备是否有文本资料
/// 返回:有
/// w ##Class(web.DHCEQDoc).HasDoc(43745)
ClassMethod HasDoc(EquipID As %String = "")
{
	i EquipID="" q ""
	
	n DocID,CheckListID,StringFlag
	s StringFlag=""
	
	s DocID=0
	f  s DocID=$o(^DHCEQDoc(0,"Equip",EquipID,DocID)) q:((DocID="")||(StringFlag'=""))  d
	.q:$p(^DHCEQDoc(DocID),"^",18)=2		;OperFlag:0:新增|1:修改|2:删除
	.s StringFlag="有"
	i StringFlag'="" q StringFlag
	
	s CheckListID=$p(^DHCEQEquip(EquipID),"^",77)
	i CheckListID'=""  d
	.s DocID=0
	.f  s DocID=$o(^DHCEQDoc(0,"CheckListDR",CheckListID,DocID)) q:((DocID="")||(StringFlag'=""))  d
	..q:$p(^DHCEQDoc(DocID),"^",18)=2		;OperFlag:0:新增|1:修改|2:删除
	..q:$d(^DHCEQDoc(0,"OldRowID",EquipID,DocID))
	..s StringFlag="有"
	
	q StringFlag
}

/// modified by ZY0305 20220617 2724602
/// 判断该设备是否有电子资料
/// 返回:有
/// w ##Class(web.DHCEQDoc).HasFile(448496,"1,2,3,4,5")
ClassMethod HasFile(EquipID As %String = "", AppendFileInclude As %String = "")
{
	i EquipID="" q ""
	;s TSourceTypeDesc=$CASE(TSourceType,0:"无",11:"开箱验收",12:"安装调试验收",21:"入库",22:"转移",23:"减少",31:"维修",32:"保养",33:"检查",34:"报废",35:"折旧",41:"使用记录",51:"设备调帐",52:"设备",61:"工程管理",62:"科研课题",91:"采购申请",92:"采购计划",93:"采购招标",94:"采购合同",:"")
	;^DHCEQAppendFile(0,"SourceType",52,14662,1)
	n FileID,CheckListID,StringFlag
	s StringFlag=""
	
	s FileID=0
	f  s FileID=$o(^DHCEQAppendFile(0,"SourceType",52,EquipID,FileID)) q:((FileID="")||(StringFlag'=""))  d
	.q:$p(^DHCEQAppendFile(FileID),"^",19)'="N"
	.s TAppendFileTypeID=$p(^DHCEQAppendFile(FileID),"^",3)
	.i (AppendFileInclude'="")&&((","_AppendFileInclude_",")[(","_TAppendFileTypeID_","))  d
	..s StringFlag="有"
	i StringFlag'="" q StringFlag
	
	s CheckListID=$p(^DHCEQEquip(EquipID),"^",77)
	i CheckListID'=""  d
	.s FileID=0
	.f  s FileID=$o(^DHCEQAppendFile(0,"SourceType",11,CheckListID,FileID)) q:((FileID="")||(StringFlag'=""))  d
	..q:$p(^DHCEQAppendFile(FileID),"^",19)'="N"
	..s TAppendFileTypeID=$p(^DHCEQAppendFile(FileID),"^",3)
	..i (AppendFileInclude'="")&&((","_AppendFileInclude_",")[(","_TAppendFileTypeID_","))  d
	...s StringFlag="有"
	
	q StringFlag
}

/// czf 2022-09-77
/// 获取验收文件
/// 返回:有
/// w ##Class(web.DHCEQDoc).GetDocInfo(1)
ClassMethod GetDocInfo(CheckListID As %String = "")
{
	i CheckListID="" q ""
	s DocInfo=""
	
	s DocID=0
	f  s DocID=$o(^DHCEQDoc(0,"CheckListDR",CheckListID,DocID)) q:(DocID="")  d
	.s DocName=$p($g(^DHCEQDoc(DocID)),"^",2)
	.s DocNum=$p($g(^DHCEQDoc(DocID)),"^",5)
	.s DocRemark=$p($g(^DHCEQDoc(DocID)),"^",7)
	.i DocInfo'="" s DocInfo=DocInfo_"&"
	.s DocInfo=DocInfo_DocName_"^"_DocNum_"^"_DocRemark
	
	q DocInfo
}

}
