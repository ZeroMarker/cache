Import SQLUser

/// /已作废 V4.0 启用新版图片管理 JDL 20150828
Class web.DHCEQPicture Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 88;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PT_RowID";

Parameter SQLDESCRIPTION = "PT_RowID";

Parameter SQLROWID = "PT_RowID";

/*
ClassMethod GetPicture(equipdr)
{
	new html	
	s html="<div id='PicDiv' style='background-color: '>"
	s html=html_"<SPAN id=PicSpan_"_equipdr_">"
	s html=html_"<DIV noWrap><NOBR>"
	
	if equipdr'=""
	{
		s rowid=0
		f  s rowid=$o(^DHCEQPicture(0,"Equip",equipdr,rowid))  quit:rowid=""  d
		.s html=html_"<IMG id=Pic"_rowid_" style=""CURSOR:hand"" src=""../images/shebeipic/"_$p($g(^DHCEQPicture(rowid)),"^",4)_""" align=absMiddle hideFocus title="""_$p($g(^DHCEQPicture(rowid)),"^",3)_""" onclick=""SelectPic("_rowid_")"" ondblclick=""ShowPic("_rowid_")"">"
		.;s html=html_"<A id=Link"_id_" hideFocus title="""_text_""" onclick="_"""NodeClick("_id_")"""_" href=""#"">"_text_"</A>"
	}
	
	s html=html_"</NOBR></DIV>"	
	s html=html_"<SPAN id=Child"_id_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}

/// 修改:2009-08-20 党军 begin
/// 描述:设备与验收单图片信息操作,设备更改对应验收单图片时,验收单图片不发生变化
///     而增加一条设备操作验收单记录
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String, path As %Library.String, remark As %Library.String, equipdr As %Library.String, isDel As %Library.String, CheckListDR As %Library.String, SourceType As %Library.String, SourceID As %Library.String)
{
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	i rowid'="" s OCLDR=$p($g(^DHCEQPicture(rowid)),"^",5)
 	if (+isDel=1)
 	{
	 	i (CheckListDR'="")||(OCLDR="")||((SourceType'="")&&(SourceID'="")) //验收单或设备删除自己本身的图片
	 	{
		 	s OldRowID=$p($g(^DHCEQPicture(rowid)),"^",6)
		 	i OldRowID=""
		 	{
			 	&SQL(Select pt_path into :picpath  From SQLUSER.DHC_EQPicture where PT_RowID = :rowid)
	 			if SQLCODE q SQLCODE
 				&SQL(Delete From SQLUSER.DHC_EQPicture where PT_RowID = :rowid)
 				if SQLCODE q SQLCODE
 				
 				if picpath'=""
	 			{
		 			;Modified by JDL 2011-69 JDL0082
	 				set FtpFlag=##class(web.DHCEQCommon).GetSysInfo("990017")
	 				if FtpFlag'=1
	 				{
		 				//s picpath="d:\trakcare\web\csp\shebeipic\"_picpath
		 				s picpath=##class(web.DHCEQCommon).GetSysInfo("990004")_picpath
		 				If ##class(%File).Exists(picpath)
		 				{
			 				d ##class(%File).Delete(picpath)
			 			}
		 			}
		 			else
		 			{
			 			;Ftp上删除上传的文件
			 			Set ftp=##class(%Net.FtpSession).%New()
			 			set server=##class(web.DHCEQCommon).GetSysInfo("990018")
						set name=$p(server,"&",2)
						set password=$p(server,"&",3)
						set port=21
						i $p(server,"&",4)'="" set port=$p(server,"&",4)
						set server=$p(server,"&",1)						
						If ftp.Connect(server,name,password,port)
						{
							d ftp.Delete(picpath)
						}
			 		}
 				}
		 	}
		 	else
		 	{
			 	&SQL(Update SQLUSER.DHC_EQPicture set PT_OperFlag='2',PT_UpdateDate=:Date,PT_UpdateTime=:Time,PT_UpdateUser=:User where PT_RowID=:rowid)
		 	}
	 	}
	 	i (OCLDR'="")&&(equipdr'="")
	 	{
		 	&SQL(Insert Into SQLUSER.DHC_EQPicture(PT_EquipDR,PT_OldRowID,PT_OperFlag,PT_UpdateDate,PT_UpdateTime,PT_UpdateUser) values(:equipdr,:rowid,'2',:Date,:Time,:User))
	 	}
 	}	
 	elseif (rowid="")
 	{ 
 		&SQL(Insert into SQLUSER.DHC_EQPicture(PT_Path,PT_Remark,PT_EquipDR,PT_CheckListDR,PT_SourceType,PT_SourceID,PT_UpdateDate,PT_UpdateTime,PT_UpdateUser)
 			values (:path,:remark,:equipdr,:CheckListDR,:SourceType,:SourceID,:Date,:Time,:User))
 		s rowid=$g(%ROWID)
 	}
 	else{
	 	&SQL(Update SQLUSER.DHC_EQPicture set PT_Path=:path,PT_Remark=:remark,PT_UpdateDate=:Date,PT_UpdateTime=:Time,PT_UpdateUser=:User where PT_RowID = :rowid)
 	}
 	if SQLCODE  q SQLCODE
 	q rowid
}

/// modified by ZY ZY0095
/// 2009-08-20 党军 end
/// 修改:2009-08-20 党军 begin
/// 描述:GetPictureList查询增加验收单ID传入参数,实现设备图片信息与验收单图片信息综合处理
Query GetPictureList(EquipDR As %String, CheckListDR As %String, SourceType As %String, SourceID As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TPath:%String,TRemark:%String,TSourceType:%String")
{
}

ClassMethod GetPictureListExecute(ByRef qHandle As %Binary, EquipDR As %String, CheckListDR As %String, SourceType As %String, SourceID As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetPictureList
	Quit $$$OK
BuildDataGetPictureList
	i CheckListDR'="" d //验收单图片信息
	.f  s rowid=$o(^DHCEQPicture(0,"CheckListDR",CheckListDR,rowid)) q:rowid=""  d
	..d ResetVariablesGetPictureList
	..s TRowID=rowid
	..s TSourceType="验收单"
	..d GetListInfo
	..d OutputRowGetPictureList
	e  i EquipDR'=""  d
	.s SourceID=$p($g(^DHCEQEquip(EquipDR)),"^",77)
	.i SourceID'="" d
	..f  s rowid=$o(^DHCEQPicture(0,"CheckListDR",SourceID,rowid)) q:rowid=""  d
	...d ResetVariablesGetPictureList
	...s TRowID=rowid
	...s TSourceType="验收单"
	...s NewRowid=$o(^DHCEQPicture(0,"OldRowID",EquipDR,rowid,0))
	...i NewRowid'="" d
	....s TRowID=NewRowid
	....s TSourceType="改自验收单"
	...q:$p($g(^DHCEQPicture(TRowID)),"^",7)="2"
	...d GetListInfo
	...d OutputRowGetPictureList
	.s NewRowid=0
	.f  s NewRowid=$o(^DHCEQPicture(0,"Equip",EquipDR,NewRowid)) q:NewRowid=""  d
	..d ResetVariablesGetPictureList
	..s TRowID=NewRowid
	..s TSourceType="设备"
	..q:$p($g(^DHCEQPicture(TRowID)),"^",7)'=""
	..d GetListInfo
	..d OutputRowGetPictureList
	e  i (SourceType'="")&&(SourceID'="")  d
	.s NewRowid=0
	.f  s NewRowid=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,NewRowid)) q:NewRowid=""  d
	..d ResetVariablesGetPictureList
	..s TRowID=NewRowid
	..s TSourceType=$Case(SourceType,"1":"保养","2":"检测","3":"维修","4":"证件","5":"合同","99":"培训",:"")
	..q:$p($g(^DHCEQPicture(TRowID)),"^",7)'=""
	..d GetListInfo
	..d OutputRowGetPictureList
	quit
GetListInfo
	s TEquipDR=$p($g(^DHCEQPicture(TRowID)),"^",1)
	s TPath=$p($g(^DHCEQPicture(TRowID)),"^",4)
	s TRemark=$p($g(^DHCEQPicture(TRowID)),"^",3)
	quit
OutputRowGetPictureList
	s Data=$lb(TRowID,TEquipDR,TPath,TRemark,TSourceType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPictureList
	s (TRowID,TEquipDR,TPath,TRemark,TSourceType)=""
	quit
}

ClassMethod GetPictureListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPictureListExecute ]
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

ClassMethod GetPictureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPictureListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ShowPicture(path, remark)
{
	new html
	s rowid=1
	
	///Modified by jdl 2009-04-21 增加附加文件访问路径的设置
	s srcpath=##class(web.DHCEQCommon).GetSysInfo("990006")
	
	s html="<div id='PicDiv' style='background-color: '>"
	s html=html_"<SPAN id=PicSpan_"_rowid_">"
	s html=html_"<DIV noWrap><NOBR>"
	
	s html=html_"<IMG id=Pic"_rowid_" style=""CURSOR:hand"" src="""_srcpath_path_""" align=absMiddle hideFocus title="""_remark_""">"
	
	s html=html_"</NOBR></DIV>"	
	s html=html_"<SPAN id=Child"_rowid_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}
*/
}
