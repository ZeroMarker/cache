Class web.DHCEQ.Process.DHCEQPictureList Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

// GetPictureList

Query GetPictureList(PicRowID) As %Query(ROWSPEC = "TRowID:%String,TPicName:%String,TPicListSort:%String,TSuffix:%String,TDefaultFlag:%String,TFtpStreamSrc:%String")
{
}

ClassMethod GetPictureListExecute(ByRef qHandle As %Binary, PicRowID) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	q:PicRowID=""
 	
	d BuildDataGetPictureList
	Quit $$$OK
BuildDataGetPictureList
	//s PLRowID=""
	//f  s PLRowID=$o(^DHCEQPictureList(PLRowID)) q:PLRowID=""  d
	//.q:$p($g(^DHCEQPictureList(PLRowID)),"^",1)'=PicRowID
	s PLRowID=""
	q:$Data(^DHCEQPictureList(0,"Picture",PicRowID))=0 "{results:0,rows:[]}"
	f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PicRowID,PLRowID)) q:PLRowID=""  d
	.q:$p($g(^DHCEQPictureList(PLRowID)),"^",12)="Y"
	.d ResetVariablesGetPictureList
	.d GetListInfo
	.d OutputRowGetPictureList
	quit
GetListInfo
	s TRowID=PLRowID
	s TPicName=$p($g(^DHCEQPicture(PicRowID)),"^",13)
	s TPicListSort=$p($g(^DHCEQPictureList(PLRowID)),"^",2)
	s TSuffix=$p($g(^DHCEQPictureList(PLRowID)),"^",3)
	s TDefaultFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",4)
	s:TDefaultFlag=$c(0) TDefaultFlag="false"
	s TFtpStreamSrc=##Class(web.DHCEQ.Process.DHCEQPicture).GetFtpStreamSrcByPLRowID(PLRowID)
	quit
OutputRowGetPictureList
	s Data=$lb(TRowID,TPicName,TPicListSort,TSuffix,TDefaultFlag,TFtpStreamSrc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPictureList
	s (TRowID,TPicName,TPicSort,TSuffix,TDefaultFlag)=""
	quit
}

ClassMethod GetPictureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPictureListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
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

ClassMethod UploadByFtpStream(Path, Stream As %Stream.Object)
{
		Set ftp=##class(%Net.FtpSession).%New()
		///modified by ZY0278 20210826
		i (##class(web.DHCEQCommon).GetSysInfo("990086")=1) Set ftp.SSLConfiguration="FTPS"   ////Modefied by zc0107 2021-11-22  将系统参数990026改成990086
		set server=##class(web.DHCEQCommon).GetSysInfo("990018")
		set name=$p(server,"&",2)
		set password=##Class(web.Util.Encryption).SimpleDecrypt($p(server,"&",3),"DHCEQ")
		set port=21
		i $p(server,"&",4)'="" set port=$p(server,"&",4)
		set server=$p(server,"&",1)
		If 'ftp.Connect(server,name,password,port) Quit -1				//Not connected 
		If 'ftp.Binary() Quit -2										//Can not swap to binary mode
		If 'ftp.Store(Path,Stream) Quit -3
		If 'ftp.Logout() Quit -4										//Failed to logout
		Quit 0
}

ClassMethod SavePictureList(PTData = "", PLData, User As %String = "")
{
	Set PTRowID=$p($G(PTData),"^",1)
	
 	Set PLRowID=$p($G(PLData),"^",1)
 	//Set PLPicSort=$p($G(PLData),"^",3)		//Modify DJ 2016-09-26
 	Set PLSuffix=$p($G(PLData),"^",4)
 	Set PLDefaultFlag=$p($G(PLData),"^",5)
 	Set:PLDefaultFlag="" PLDefaultFlag="N"
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s PLPicSort=$o(^DHCEQPictureList(0,"PicSort",PTRowID,""),-1)+1		//Add By DJ 2016-09-26
	i ##Class(%Library.Integer).IsValid(PLPicSort)'=1 q -3
	 	
	if PLRowID=""
	{
		&SQL(insert into SQLUSER.DHC_EQPictureList (PL_PictureDR,PL_PicSort,PL_UploadUserDR,PL_UploadDate,PL_UploadTime,PL_InvalidFlag,PL_DefaultFlag,PL_UpLoadFlag) values(:PTRowID,:PLPicSort,:User,:Date,:Time,'N',:PLDefaultFlag,'Y'))
	 	s rowid=$g(%ROWID)
	 	if SQLCODE
		{
	   		q SQLCODE	//-6
	 	}
	}
	else
	{
	 	&SQL(Update SQLUSER.DHC_EQPictureList set PL_PicSort=:PLPicSort,PL_UploadUserDR=:User,PL_UploadDate=:Date,PL_UploadTime=:Time,PL_DefaultFlag=:PLDefaultFlag,PL_UpLoadFlag='Y' where PL_RowID = :PLRowID)
	 	s rowid=$g(%ROWID)
	 	if SQLCODE
		{
	   		q SQLCODE	//-9
	 	}
	}
	if (PLSuffix'="")
	{
	 	&SQL(Update SQLUSER.DHC_EQPictureList set PL_Suffix=:PLSuffix where PL_RowID = :rowid)
	 	if SQLCODE
		{
	   		q SQLCODE	//-12
	 	}
	}
	&SQL(select * from SQLUSER.DHC_EQPictureList where PL_PictureDR=:PTRowID and PL_PicSort=:PLPicSort and PL_RowID != :rowid and PL_InvalidFlag='N')
	if SQLCODE'=100
	{
		q SQLCODE	//-15
	}
	if (PLDefaultFlag="Y")&&(PTRowID'="")
	{
		&SQL(Update SQLUSER.DHC_EQPictureList set PL_DefaultFlag='N' where PL_RowID != :rowid and PL_PictureDR=:PTRowID and PL_InvalidFlag='N' )
		if SQLCODE&&(SQLCODE'=100)
		{
	  		q SQLCODE	//-18
		}
	}
 	q rowid
}

ClassMethod DeletePictureList(RowID)
{
	&SQL(Update SQLUSER.DHC_EQPictureList set PL_InvalidFlag='Y' where PL_RowID = :RowID)
	if SQLCODE
	{
	   	q -1
 	}
 	q 1
}

// Add BY QW-2015-12-30

// w ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQPictureList","GetPictureListInfo","03",15)

Query GetPictureListInfo(SourceType As %String = "", SourceID As %String = "", PLID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TPicName:%String,TPicListSort:%String,TSuffix:%String,TUploadFlag:%String,TPicRemark:%String")
{
}

ClassMethod GetPictureListInfoExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", PLID As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	

	i PLID'=""   d
	.d ResetVariablesGetPictureListInfo
	.s PLRowID=PLID
	.s PicRowID=$p($g(^DHCEQPictureList(PLRowID)),"^",1)
	.d GetPicListInfo
	.d OutputRowGetPictureListInfo 
	e  d 
	.q:SourceType=""
 	.q:SourceID=""
	.d BuildDataGetPictureListInfo
	Quit $$$OK
BuildDataGetPictureListInfo
	s PicRowID=0
	f  s PicRowID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PicRowID)) q:PicRowID=""  d
	.q:$p($g(^DHCEQPicture(PicRowID)),"^",7)="2"		//czf 20200703
	.s PLRowID=0
	.f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PicRowID,PLRowID)) q:PLRowID=""  d
	..q:$p($g(^DHCEQPictureList(PLRowID)),"^",12)="Y"
	..d ResetVariablesGetPictureListInfo
	..d GetPicListInfo
	..d OutputRowGetPictureListInfo
	quit
GetPicListInfo
	s TRowID=PLRowID
	s TPicName=$p($g(^DHCEQPicture(PicRowID)),"^",13)
	s TPicRemark=$p($g(^DHCEQPicture(PicRowID)),"^",3)
	s TPicListSort=$p($g(^DHCEQPictureList(PLRowID)),"^",2)
	s TSuffix=$p($g(^DHCEQPictureList(PLRowID)),"^",3)
	s TUploadFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",13)
	;s:TDefaultFlag=$c(0) TDefaultFlag="false"
	quit
OutputRowGetPictureListInfo
	s Data=$lb(TRowID,TPicName,TPicListSort,TSuffix,TUploadFlag,TPicRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPictureListInfo
	s (TRowID,TPicName,TPicSort,TSuffix,TUploadFlag,TPicRemark)=""
	quit
}

ClassMethod GetPictureListInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPictureListInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPictureListInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPictureListInfoExecute ]
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

/// Add By DJ 2017-04-26
/// 描述:高拍仪采集图片存储
ClassMethod CameraPicSave(vPTInfo As %String = "", vPLInfo As %String = "")
{
	s CPTRowID=$p($g(vPTInfo),"^",1)
	s CPLRowID=$p($g(vPLInfo),"^",1)
	i CPTRowID=""  d
	.s PSourceType=$p($g(vPTInfo),"^",9)
	.s PSourceID=$p($g(vPTInfo),"^",10)
	.s PPTypeDR=$p($g(vPTInfo),"^",6)
	.s PRowID=0
	.f  s PRowID=$o(^DHCEQPicture(0,"Source",PSourceType,PSourceID,PRowID))  q:(PRowID="")||(CPTRowID'="")  d
	..s InvalidFlag=$p($g(^DHCEQPicture(PRowID)),"^",7)
	..q:InvalidFlag=2
	..s TPPTypeDR=$p($g(^DHCEQPicture(PRowID)),"^",5)
	..q:TPPTypeDR'=PPTypeDR
	..s CPTRowID=PRowID
	.i CPTRowID="" s CPTRowID=##Class(web.DHCEQ.Process.DHCEQPicture).SavePicture(vPTInfo)
	i +CPTRowID<=0	q CPTRowID		//主表插入失败
	i CPLRowID=""	s CPLRowID=##Class(web.DHCEQ.Process.DHCEQPictureList).SavePictureList(CPTRowID,vPLInfo)
	i +CPLRowID<=0	q CPLRowID		//明细表插入失败
	q CPTRowID_"^"_CPLRowID
}

/// add by czf 2020-10-18
ClassMethod GetPictureNumBySourceID(SourceType As %String = "", SourceID As %String = "", PicTypeDR As %String = "")
{
 	i (SourceType="")||(SourceID="") q 0
 	
 	s PicNum=0
 	s PicRowID=0
	f  s PicRowID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PicRowID)) q:PicRowID=""  d
	.s PLRowID=0
	.f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PicRowID,PLRowID)) q:PLRowID=""  d
	..q:$p($g(^DHCEQPictureList(PLRowID)),"^",12)="Y"
	..;s TRowID=PLRowID
	..;s TPicName=$p($g(^DHCEQPicture(PicRowID)),"^",13)
	..;s TPicRemark=$p($g(^DHCEQPicture(PicRowID)),"^",3)
	..;s TPicListSort=$p($g(^DHCEQPictureList(PLRowID)),"^",2)
	..;s TSuffix=$p($g(^DHCEQPictureList(PLRowID)),"^",3)
	..;s TUploadFlag=$p($g(^DHCEQPictureList(PLRowID)),"^",13)
	..s PicNum=PicNum+1
		
	quit PicNum
}

}
