/// 名称: DHCHAI.IRS.PDCAFileUrlSrv
/// 描述: PDCA上传地址服务
/// 编写者：ShenC
/// 编写日期: 2022-09-06
Class DHCHAI.IRS.PDCAFileUrlSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter FTP2WEB = "imedicalftp";

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  上传文件
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       aLocID
/// Return：      成功：返回0，失败：返回<0的代码
///  w ##class(DHCHAI.IRS.PDCAFileUrlSrv).FTPUpload("3@%CSP.BinaryStream","/dhcAdvEvt/picture/202048/","曹刚治疗前送检")
ClassMethod FTPUpload(FileStream As %CSP.BinaryStream, Dir As %String, FileName As %String = "")
{
	if 'FileStream Quit "-104"
	//根据系统参数取FTP服务器相关内容
	Set FTP=##class(DHCHAI.BT.Config).GetValByCode("PDCAFTP")
	Set IP=$p(FTP,"-",1)
	Set UserName=$p(FTP,"-",2)
	Set Password =$p(FTP,"-",3)
	Set Port=$p(FTP,"-",4)
	
	//避免文件名重复
	S FileName=$tr(FileName,"——,-","_")  // 处理特殊字符
	if $d(^MA.HAI.IR.PDCAFileUrlI("IndexName",FileName)){
		Set Count=0
		Set xFileName=""
		For{
			Set xFileName=$o(^MA.HAI.IR.PDCAFileUrlI("IndexName",xFileName))	
			Quit:xFileName=""
			
			Continue:xFileName'[$p(FileName,".",1)
			Set xID=""
			For{
				Set xID=$o(^MA.HAI.IR.PDCAFileUrlI("IndexName",xFileName,xID))	
				Quit:xID=""
				
				Set Count=Count+1	
			}
		}
		S len=$L(FileName,".")
		s FileName=$p(FileName,".",1,len-1)_"("_Count_")."_$p(FileName,".",len)
	}
	
	s ftp=##class(%Net.FtpSession).%New()
	d ftp.CommandTranslateTableSet("GB18030")
	Set Port=21
	i 'ftp.Connect(IP,UserName,Password,Port) q "-1^"_ftp.ReturnMessage
	
	i 'ftp.Binary() q "-2^"_ftp.ReturnMessage
	if (FileName="") Set FileName = FileStream.FileName
	;create dir and goto dir
	if Dir'="" {
		Set Dir = ##class(ext.util.String).Replace(Dir,"//","/")
		if Dir["/" Set DirLen = $l(Dir,"/"),sep="/"
		if Dir["\" Set DirLen = $l(Dir,"\"),sep="\"
		for i=1:1:DirLen {
			set CurrentDir = $p(Dir,sep,i)
			if $l(CurrentDir)>0 {
				i ftp.SetDirectory(CurrentDir){
				}else{
					s MakeDir = ftp.MakeDirectory(CurrentDir)
					s cdFlag = ftp.SetDirectory(CurrentDir)
				}
			}
		}
	}
	
	i 'ftp.Store(FileName,FileStream) q "-3^"_ftp.ReturnMessage
	d FileStream.Clear()
	s FileStream=""
	i 'ftp.Logout() quit "-4^"_ftp.ReturnMessage
	s ftp=""
	q 1_"^http://"_##class(ext.util.String).Replace(IP_"/"_..#FTP2WEB_"/"_$tr(Dir,"\","/")_"/"_FileName,"//","/")
	q 1
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  删除上传文件
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       aLocID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.PDCAFileUrlSrv).DeleteFileUrl(aFileUrl,"")
ClassMethod DeleteFileUrl(aFileUrl As %String, aFileName As %String) As %String
{
	New (aFileUrl,aFileName)
	Quit:(aFileUrl="")||(aFileName="") ""
	//根据系统参数取FTP服务器相关内容
	Set FTP=##class(DHCHAI.BT.Config).GetValByCode("PDCAFTP")
	Set IP=$p(FTP,"-",1)
	Set UserName=$p(FTP,"-",2)
	Set Password =$p(FTP,"-",3)
	Set Port=$p(FTP,"-",4)
	//处理地址
	Set aFileUrl="MAPDCA/"_$p(aFileUrl,"MAPDCA",2)
	s Dir=$p(aFileUrl,"/",1,$l(aFileUrl,"/")-1)
 	s FileName=$p(aFileName,"/",$l(aFileName,"/"))
 	
	s ftp=##class(%Net.FtpSession).%New()
	d ftp.CommandTranslateTableSet("GB18030")
	i 'ftp.Connect(IP,UserName,Password,Port) q "-1^"_ftp.ReturnMessage
	i 'ftp.Binary() q "-2^"_ftp.ReturnMessage
	if (FileName="") Set FileName = FileStream.FileName
	if Dir'="" {
		Set Dir = ##class(ext.util.String).Replace(Dir,"//","/")
		if Dir["/" Set DirLen = $l(Dir,"/"),sep="/"
		if Dir["\" Set DirLen = $l(Dir,"\"),sep="\"
		for i=1:1:DirLen {
			set CurrentDir = $p(Dir,sep,i)
			if $l(CurrentDir)>0 {
				i ftp.SetDirectory(CurrentDir){
				}else{
					s MakeDir = ftp.MakeDirectory(CurrentDir)
					s cdFlag = ftp.SetDirectory(CurrentDir)
				}
			}
		}
	}
	if 'ftp.Delete(FileName) q "删除失败,"_ftp.ReturnMessage
	do ftp.Logout()
	Quit "1"
}

/// Creator：     ShenC
/// CreatDate：   2022-09-14
/// Description:  加载对应上传记录
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       aLocID
/// Return：      成功：返回0，失败：返回<0的代码
/// d ##class(%ResultSet).RunQuery("DHCHAI.IRS.PDCAFileUrlSrv","QryFileUrl",1,"UpLoad_1")
Query QryFileUrl(aRepID As %String, aTxtID As %String) As %Query(ROWSPEC = "ID:%String,RepID:%String,TxtID:%String,Path:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod QryFileUrlExecute(ByRef qHandle As %Binary, aRepID As %String, aTxtID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aRepID="")||(aTxtID="") $$$OK
	
	Set xID=""
	For{
		Set xID=$o(^MA.HAI.IR.PDCAFileUrlI("IndexRepDiv",aRepID,aTxtID,xID))
		Quit:xID=""
		
		Set Data=$g(^MA.HAI.IR.PDCAFileUrlD(xID))
		Continue:Data=""
		
		Set Path=$lg(Data,4)
		Set Name=$lg(Data,5)
		
		Set Data=$lb(xID,aRepID,aTxtID,Path,Name)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryFileUrlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFileUrlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFileUrlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFileUrlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ShenC
/// CreatDate：   2022-10-20
/// Description:  删除对应上传记录
/// Table：       DHCHAI.IR.PDCAFileUrl
/// Input：       aLocID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IRS.PDCAFileUrlSrv).DelUpLoadRecords("","")
ClassMethod DelUpLoadRecords(aRepID As %String, aFileName As %String) As %String
{
	New (aRepID,aFileName)
	Quit:(aRepID="")||(aFileName="") -1
	
	Set ID=$o(^MA.HAI.IR.PDCAFileUrlI("IndexRepName",aRepID,aFileName,""))
	Quit:ID="" -1
	
	Set Flag=##class(DHCHAI.IR.PDCAFileUrl).DeleteById(ID)
	Quit Flag
}

}
