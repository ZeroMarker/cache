/// 修改：Mozy 2009-07-23
/// 增加方法:MaskList
/// 描述:返回匹配列表值
/// -------------------------------
/// 修改：Mozy 2009-07-19
/// 增加方法:GetNum
/// 描述:返回对照类型表记录数量
/// -------------------------------
/// 修改：Mozy 2009-07-19
/// 增加方法:GetList
/// 描述:返回对照类型表记录
/// -------------------------------
/// 修改：Mozy 2009-07-18
/// 增加方法:GetDocByID
/// 描述:根据ID查询对照类型表记录
/// -------------------------------
/// 修改：Mozy 2009-07-17
/// 增加方法:SaveData
/// 描述:对照类型表数据新增、更新、删除
/// -------------------------------
/// 创建:Mozy 2009-07-16	Mzy0018
/// 描述：对照类型表
/// --------------------------------
Class web.DHCEQContrastInfo Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CI_EXCODE";

Parameter SQLDESCRIPTION = "CI_EXDESC";

Parameter SQLROWID = "CI_RowID";

/// 创建：Mozy 2009-07-17
/// 描述：返回设备名称列对照类型表
/// 访问表:DHC_EQContrastInfo
/// 输入：Desc：描述
/// 输出：无
/// 返回：成功返回记录，否则返回出错信息
/// 备注： TRowID,TContrastTypeDR,TSysID,TSysCode,TSysDesc,TExID,TExCode,TExDesc,TFromDate,TToDate,TRemark,TFlag
/// d ##class(%ResultSet).RunQuery("web.DHCEQContrastInfo","GetContrastInfo","","0","")
Query GetContrastInfo(SysDesc As %String = "", Flag As %String = "", TypeCode As %String = "") As %Query(ROWSPEC = "TRowID:%String,TContrastTypeDR:%String,TSysID:%String,TSysCode:%String,TSysDesc:%String,TExID:%String,TExCode:%String,TExDesc:%String,TFromDate:%String,TToDate:%String,TRemark:%String,TFlag:%String")
{
}

ClassMethod GetContrastInfoExecute(ByRef qHandle As %Binary, SysDesc, Flag, TypeCode) As %Status
{
	Set gnum=1
	Set curuser="1732" ;##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Kill ^DHCEQTemp("ContrastInfo",curuser)
	
 	new repid, index,rowid
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set SysDesc=##Class(web.DHCEQCommon).UnEscape(SysDesc)
 	Set SysDesc=$ZCONVERT(SysDesc ,"U")
	Set index=1
	Set rowid=0
	Do BuildDataGetContrastInfo
	Quit $$$OK
BuildDataGetContrastInfo
	For  Set rowid=$Order(^DHCEQCCode("DHCEQContrastInfo",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetContrastInfo
	.Set flag = 0
	.Set TRowID = rowid
	.Set TContrastTypeDR = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",1)
	.Set TTypeCode = $Piece($Get(^DHCEQCCode("DHCEQContrastType",TContrastTypeDR)),"^",6)
	.Quit:(TypeCode'="")&&(TTypeCode'=TypeCode)
	.Set mask = $Piece($Get(^DHCEQCCode("DHCEQContrastType",TContrastTypeDR)),"^",4)
	.Set TSysID = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",2)
	.Set TSysCode = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",3)
	.Set TSysDesc = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",4)
	.Quit:(SysDesc'="")&&(TSysDesc'[SysDesc)
	.Set TExID = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",5)
	.Set TExCode = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",6)
	.Set TExDesc = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",7)
	.IF mask'=""  Do
	..If ($EXTRACT(mask,1) '= 0) && (TExID = "") Set flag = "1"
	..If ($EXTRACT(mask,2) '= 0) && (TExCode = "") Set flag = "1"
	..If ($EXTRACT(mask,3) '= 0) && (TExDesc = "") Set flag = "1"
	.Quit:(Flag'="")&&(Flag'=flag)
	.Set TFromDate = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",8)
	.If TFromDate'="" Set TFromDate = ##Class(web.DHCEQCommon).TransValueToPage(TFromDate,"date")	
	.Set TToDate = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",9)
	.If TToDate'="" Set TToDate = ##Class(web.DHCEQCommon).TransValueToPage(TToDate,"date")
	.Set TRemark = $Piece($Get(^DHCEQCCode("DHCEQContrastInfo",rowid)),"^",10)
	.Do OutputRowGetContrastInfo
	Quit
OutputRowGetContrastInfo
	Set Data=$ListBuild(TRowID,TContrastTypeDR,TSysID,TSysCode,TSysDesc,TExID,TExCode,TExDesc,TFromDate,TToDate,TRemark,TUnmatchFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	Set ^DHCEQTemp("ContrastInfo",curuser,gnum)=TContrastTypeDR_"^"_TSysID_"^"_TSysCode_"^"_TSysDesc_"^"_TExID_"^"_TExCode_"^"_TExDesc_"^"_TFromDate_"^"_TToDate_"^"_TRemark_"^"_TUnmatchFlag
	Set gnum=gnum+1
	Quit
ResetVariablesGetContrastInfo
	Set (TRowID,TContrastTypeDR,TSysID,TSysCode,TSysDesc,TExID,TExCode,TExDesc,TFromDate,TToDate,TRemark,TUnmatchFlag,mask)=""
	Quit
}

ClassMethod GetContrastInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContrastInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetContrastInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContrastInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建：Mozy 2009-07-17
/// 描述：对照类型表数据新增、更新、删除
/// 访问表:DHC_EQContrastInfo
/// 输入：val：列表信息，字符串格式为：TRowID^TContrastTypeDR^TSysID^TSysCode^TSysDesc^TExID^TExCode^TExDesc^TFromDate^TToDate^TRemark
/// 			Type:0, 插入、更新		1, 删除	
/// 输出：无
/// 返回：成功返回所操作表的RowID，否则返回出错信息
/// 备注： TRowID,TContrastTypeDR,TSysID,TSysCode,TSysDesc,TExID,TExCode,TExDesc,TFromDate,TToDate,TRemark
/// w ##class(web.DHCEQContrastInfo).SaveData("","",val,Type)
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Type As %Library.String = "")
{
	Set RowID = $Piece(val,"^",1)				//TRowID
 	Set PLIST(2) = $Piece(val,"^",2)			//TContrastTypeDR
 	Set PLIST(3) = $Piece(val,"^",3)			//TSysID
 	Set PLIST(4) = $Piece(val,"^",4)			//TSysCode
 	Set PLIST(5) = $Piece(val,"^",5)			//TSysDesc
 	Set PLIST(6) = $Piece(val,"^",6)			//TExID
 	Set PLIST(7) = $Piece(val,"^",7)			//TExCode
 	Set PLIST(8) = $Piece(val,"^",8)			//TExDesc
 	If $Piece(val,"^",9) '= ""  Set PLIST(9) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",9),"date")		//TFromDate
 	If $Piece(val,"^",10) '= ""  Set PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",10),"date")	//TToDate
 	Set PLIST(11) = $Piece(val,"^",11)			//TRemark

	TSTART
	If +Type=0
	{
		If RowID=""
		{
			&SQL(insert into sqluser.DHC_EQContrastInfo values :PLIST())
		}
		Else
		{
			&SQL(update sqluser.DHC_EQContrastInfo values :PLIST() where CI_RowID=:RowID)
		}
	}
	If +Type=1
	{
		&SQL(delete from sqluser.DHC_EQContrastInfo where CI_RowID=:RowID)
	}
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set ID=$Get(%ROWID)
	TCOMMIT
	Quit ID
}

/// 创建：Mozy 2009-07-17
/// 描述：增加返回设备名称列对照类型表
/// 访问表:无
/// 输入：name：列表名称
/// 输出：无
/// 返回：成功返回列表，否则返回空
/// 备注：
/// d ##class(web.DHCEQContrastInfo).ContrastTypeList("","","")
ClassMethod ContrastTypeList(name, width) As %String
{
	//下拉列表
	Write "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	Write "<option value=></option>"
	Write "<option value=0>国别匹配</option>"
	Write "<option value=1>科室匹配</option>"
	Write "</select>",!
}

/// 创建：Mozy 2009-07-18
/// 描述：根据ID查询对照类型表记录
/// 访问表:DHC_EQContrastInfo
/// 输入：rowid
/// 输出：无
/// 返回：成功返回记录信息，否则返回空
/// 备注：CI_ContrastTypeDR CI_SYSID CI_SYSCODE CI_SYSDESC CI_EXID CI_EXCODE CI_EXDESC CI_FromDate CI_ToDate CI_Remark 
/// w ##class(web.DHCEQContrastInfo).GetDocByID("","","11")
ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	New result,resultex,mask
	Set (result,resultex,mask) = ""
	Set flag="0"		// 0 已匹配		1 未匹配
	Set result = ^DHCEQCCode("DHCEQContrastInfo",rowid)
	Set resultex = rowid

	Set resultex = resultex_"^"		// ContrastTypeDR
	If $Piece(result,"^",1) '= ""  Do
	.Set ContrastTypeDR = $Piece(result,"^",1)
	.Set resultex = resultex_ContrastTypeDR
	.Set mask = $Piece($Get(^DHCEQCCode("DHCEQContrastType",ContrastTypeDR)),"^",4)
	Set resultex = resultex_"^"		// SYSID
	If $Piece(result,"^",2) '= ""  Do
	.Set resultex = resultex_$Piece(result,"^",2)
	Set resultex = resultex_"^"			// SYSCODE
	If $Piece(result,"^",3) '= ""  Do
	.Set resultex = resultex_$Piece(result,"^",3)
	Set resultex = resultex_"^"			// SYSDESC		描述
	If $Piece(result,"^",4) '= ""  Do
	.Set resultex = resultex_$Piece(result,"^",4)
	Set resultex = resultex_"^"		// EXID
	If $Piece(result,"^",5)'=""  Do
	.Set resultex = resultex_$Piece(result,"^",5)
	Set resultex = resultex_"^"			// EXCODE		扩展代码
	If $Piece(result,"^",6) '= ""  Do
	.Set resultex = resultex_$Piece(result,"^",6)
	Set resultex = resultex_"^"			// EXDESC		扩展描述
	If $Piece(result,"^",7) '= ""  Do
	.Set resultex = resultex_$Piece(result,"^",7)
	Set resultex = resultex_"^"			// FromDate		开始日期
	If $Piece(result,"^",8) '= ""  Do
	.Set resultex = resultex_ ##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")
	Set resultex = resultex_"^"			// ToDate		结束日期
	If $Piece(result,"^",9) '= ""  Do
	.Set resultex = resultex_ ##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")
	Set resultex = resultex_"^"			// Remark		备注
	If $Piece(result,"^",10) '= ""  Do
	.Set resultex = resultex_$Piece(result,"^",10)
	
	Set resultex = resultex_"^"			// 	Flag		匹配标志
	If ($EXTRACT(mask,1) '= 0) && ($Piece(result,"^",5) = "") Set flag = "1"
	If ($EXTRACT(mask,2) '= 0) && ($Piece(result,"^",6) = "") Set flag = "1"
	If ($EXTRACT(mask,3) '= 0) && ($Piece(result,"^",7) = "") Set flag = "1"
	Set resultex = resultex_flag
	
	Quit resultex
}

/// 创建：Mozy 2009-07-19
/// 描述：返回对照类型表记录
/// 访问表:无
/// 输入：gnum:获取记录序号
/// 输出：无
/// 返回：成功返回记录信息，否则返回空
/// 备注：
/// w ##class(web.DHCEQContrastInfo).GetList("","","1")
ClassMethod GetList(itmjs As %Library.String = "", itmjsex As %Library.String = "", gnum)
{
	Set curuser = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set str = ^DHCEQTemp("ContrastInfo",curuser,gnum)
  	Quit str
}

/// 创建：Mozy 2009-07-19
/// 描述：返回对照类型表记录数量
/// 访问表: 无
/// 输入：无
/// 输出：无
/// 返回：成功返回记录数量，否则返回空
/// 备注：
/// w ##class(web.DHCEQContrastInfo).GetNum("","")
ClassMethod GetNum(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	Set curuser = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set gnum = $Order(^DHCEQTemp("ContrastInfo",curuser,""),-1)
  	Quit gnum
}

/// 创建：Mozy 2009-07-23
/// 描述：匹配列表
/// 访问表: 无
/// 输入：无
/// 输出：无
/// 返回：返回匹配列表值
/// 备注：
/// w ##class(web.DHCEQContrastInfo).MaskList("MatchFlag","150")
ClassMethod MaskList(name, width) As %String
{
	;;下拉列表
	Write "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	Write "<option value=></option>"
	Write "<option value=0>"_"匹配"_"</option>"
	Write "<option value=1>"_"未匹配"_"</option>"
	Write "</select>",!
}

}
