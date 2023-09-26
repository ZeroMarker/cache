Import SQLUser

Class web.DHCEQAppendFile Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetFilePicture(OriginalType, OriginalID)
{
	new html	
	s html="<div id='PicDiv' style='background-color: '>"
	s html=html_"<SPAN id=PicSpan_"_equipdr_">"
	s html=html_"<DIV noWrap><NOBR>"
	
	if equipdr'=""
	{
		s rowid=0
		f  s rowid=$o(^DHCEQAppendFile(0,"Original",OriginalType,OriginalID,rowid))  quit:rowid=""  d
		.s html=html_"<IMG id=Pic"_rowid_" style=""CURSOR:hand"" src=""../images/shebeipic/"_$p($g(^DHCEQAppendFile(rowid)),"^",4)_""" align=absMiddle hideFocus title="""_$p($g(^DHCEQAppendFile(rowid)),"^",3)_""" onclick=""SelectPic("_rowid_")"" ondblclick=""ShowPic("_rowid_")"">"
		.;s html=html_"<A id=Link"_id_" hideFocus title="""_text_""" onclick="_"""NodeClick("_id_")"""_" href=""#"">"_text_"</A>"
	}
	
	s html=html_"</NOBR></DIV>"	
	s html=html_"<SPAN id=Child"_id_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}

ClassMethod SaveData(User As %Library.String = "", rowid As %Library.String, val As %Library.String = "", isDel As %Library.String)
{
	///new (OriginalType,OriginalID,DocName,FileName,FilePath,FileType,Remark,Hold1,Hold2,Hold3,Hold4,Hold5)
	if (+isDel'=1)
	{
		k PLIST
 		s PLIST(2) = $p(val,"^",1)	;OriginalType
 		s PLIST(3) = $p(val,"^",2)	; OriginalID
 		s PLIST(4) = $p(val,"^",3)	; DocName
 		s DocName=$p(val,"^",3)
 		s PLIST(5) = $p(val,"^",4)	; FileName
 		s PLIST(6) = $p(val,"^",5)	; FilePath
 		s PLIST(7) = $p(val,"^",6)	; FileType
 		s PLIST(8) = $p(val,"^",7)	; Remark
 		s PLIST(15) = $p(val,"^",8)	; Hold1
 		s PLIST(16) = $p(val,"^",9)	; Hold2
 		s PLIST(17) = $p(val,"^",10)	; Hold3
 		s PLIST(18) = $p(val,"^",11)	; Hold4
 		s PLIST(19) = $p(val,"^",12)	; Hold5
	}
 	
 	i User=""  s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Date=+$H
	s Time=$P($H,",",2)
	
 	if (+isDel=1)
 	{
	 	&SQL(Select AF_FileName into :filename  From SQLUSER.DHC_EQAppendFile where AF_RowID = :rowid)
	 	if SQLCODE q SQLCODE
 		&SQL(Update SQLUSER.DHC_EQAppendFile set AF_InvalidFlag='Y' where AF_RowID = :rowid)
 		if SQLCODE q SQLCODE
 		if filename'=""
 		{
	 		s path=##class(web.DHCEQCommon).GetSysInfo("990005")
	 		s filename=path_filename
	 		If ##class(%File).Exists(filename)
	 		{ d ##class(%File).Delete(filename)}
	 	}
 	}
 	elseif (rowid="")
 	{ 
 		s Find=0
 		&SQL(Select AF_RowID Into :Find From SQLUSER.DHC_EQAppendFile Where AF_DocName=:DocName)
 		i +Find'=0
 		{
	 		q -1009
 		}
 		s PLIST(9) = User
 		s PLIST(10) = Date
 		s PLIST(11) = Time
 		s PLIST(20) = "N"
 		&sql(insert into SQLUSER.DHC_EQAppendFile values :PLIST())
 		s rowid=$g(%ROWID)
 	}
 	else{
	 	s Find=0
 		&SQL(Select AF_RowID Into :Find From SQLUSER.DHC_EQAppendFile Where AF_DocName=:DocName)
 		i (+Find'=0)&&(Find'=rowid)
 		{
	 		q -1009
 		}
	 	s PLIST(12) = User
 		s PLIST(13) = Date
 		s PLIST(14) = Time
 		&sql(update SQLUSER.DHC_EQAppendFile values :PLIST() where AF_ROWID=:rowid)
 	}
 	if SQLCODE  q SQLCODE
 	q rowid
}

Query GetAppendFileList(OriginalType, OriginalID) As %SQLQuery(ROWSPEC = "TRowID:%String,TDocName:%String,TPath:%String,TRemark:%String,TFileName:%String")
{
SELECT AF_RowID TRowID,
	   AF_DocName TDocName,
	   AF_FilePath TPath, 
	   AF_Remark TRemark,
	   AF_FileName TFileName
FROM sqluser.DHC_EQAppendFile
where AF_InvalidFlag='N'
}

ClassMethod ShowFile(file, remark)
{
	new html
	s rowid=1
	///Modified by jdl 2009-04-21 增加附加文件访问路径的设置
	s srcpath=##class(web.DHCEQCommon).GetSysInfo("990007")
	s html="<div id='PicDiv' style='background-color: '>"
	s html=html_"<SPAN id=PicSpan_"_rowid_">"
	s html=html_"<DIV noWrap><NOBR>"
	
	s html=html_"<IMG id=Pic"_rowid_" style=""CURSOR:hand"" src="""_srcpath_file_""" align=absMiddle hideFocus title="""_remark_""">"
	
	s html=html_"</NOBR></DIV>"	
	s html=html_"<SPAN id=Child"_rowid_" style=""DISPLAY:none""></SPAN>"
	s html=html_"</SPAN>"
	w html
}

/*********************************************************/
/// Add By DJ 2014-10-15 DJ0129
/// 描述:获取资料列表
Query GetAppendFileListNew(OriginalType, OriginalID) As %Query(ROWSPEC = "TRowID:%String,TDocName:%String,TPath:%String,TRemark:%String,TFileName:%String,TOriginalTypeDR:%String,TOriginalType:%String")
{
}

ClassMethod GetAppendFileListNewExecute(ByRef qHandle As %Binary, OriginalType, OriginalID) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (OriginalType="")||(OriginalID="") Quit $$$OK
	
	s AFRowID=0
	f  s AFRowID=$o(^DHCEQAppendFile(0,"Original",OriginalType, OriginalID,AFRowID))  quit:AFRowID=""  d
	.d ResetVariablesGetAppendFileListNew
	.s InvalidFlag=$p($g(^DHCEQAppendFile(AFRowID)),"^",19)
	.q:InvalidFlag="Y"
	.s TRowID=AFRowID
	.s TDocName=$p($g(^DHCEQAppendFile(AFRowID)),"^",3)
	.s TPath=$p($g(^DHCEQAppendFile(AFRowID)),"^",5)
	.s TRemark=$p($g(^DHCEQAppendFile(AFRowID)),"^",7)
	.s TFileName=$p($g(^DHCEQAppendFile(AFRowID)),"^",4)
	.s TOriginalTypeDR=OriginalType
	.s TOriginalType=$CASE(TOriginalTypeDR,"1":"论证","2":"合同","3":"采购申请","4":"设备","5":"维修","6":"报废","7":"计划","8":"检查","9":"验收","":"未定义")
	.d OutputRowGetAppendFileListNew
	
	//台帐来自验收单记录
	i OriginalType=4  d
	.s OCLRowID=$p($g(^DHCEQEquip(OriginalID)),"^",77)
	.i OCLRowID'=""  d
	..s AFRowID=0
	..f  s AFRowID=$o(^DHCEQAppendFile(0,"Original", 9, OCLRowID,AFRowID))  quit:AFRowID=""  d
	...d ResetVariablesGetAppendFileListNew
	...s InvalidFlag=$p($g(^DHCEQAppendFile(AFRowID)),"^",19)
	...q:InvalidFlag="Y"
	...s TRowID=AFRowID
	...s TDocName=$p($g(^DHCEQAppendFile(AFRowID)),"^",3)
	...s TPath=$p($g(^DHCEQAppendFile(AFRowID)),"^",5)
	...s TRemark=$p($g(^DHCEQAppendFile(AFRowID)),"^",7)
	...s TFileName=$p($g(^DHCEQAppendFile(AFRowID)),"^",4)
	...s TOriginalTypeDR=9
	...s TOriginalType="验收单"
	...d OutputRowGetAppendFileListNew
	
	Quit $$$OK
OutputRowGetAppendFileListNew
	s Data=$lb(TRowID,TDocName,TPath,TRemark,TFileName,TOriginalTypeDR,TOriginalType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFileListNew
	quit
}

ClassMethod GetAppendFileListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFileListNewExecute ]
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

ClassMethod GetAppendFileListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFileListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*********************************************************/
}
