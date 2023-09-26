Class EPRservice.tool.DataImportMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(EPRservice.tool.DataImportMgr).Import()
/// 导入CA.UsrSignatureInfo，扩增表之后，进行导入，再重建其索引
/// 使用前，请修改文件名文件第一列为ID，第二列为UsrCertCode
ClassMethod ImportCAUsrSignatureInfo()
{
	s filePath = "D:\HYD11.txt"
 	s sub = "CA.UsrSignatureInfo"
 	
	set $zt="ImportErrorHandler"

 	k ^CacheTempDHCEPRDebug("DHCEPRImport","DataImportMgr",sub)
 	
 	//上传文件至临时global
 	write "File Upload Starting...",!
 	
 	If '##class(%File).Exists(filePath) 
 	{
	 	Write "fliel is not exist!",!
 	}
 	
 	s count = 0
 	Set stream = ##class(%FileCharacterStream).%New()
	Set stream.Filename = filePath
	While 'stream.AtEnd {
		//b "s"
		s count =  count + 1
		quit:(count > 10000)
		Set sRec = stream.ReadLine()
		//w sRec,!
		set num=$get(^CacheTempDHCEPRDebug("DHCEPRImport","DataImportMgr",sub,0))+1
		set ^CacheTempDHCEPRDebug("DHCEPRImport","DataImportMgr",sub,0)=num
 		set ^CacheTempDHCEPRDebug("DHCEPRImport","DataImportMgr",sub,num)=$tr(sRec,$c(9),$c(9))	
	}
	do stream.%Close()
	
 	w "File Upload Finished!",!!
 	
 	//b
 	
 	//更新表数据
 	s del=$c(9)
 	s ind = 0
 	s idx=0
 	for {
	 	s ind=$o(^CacheTempDHCEPRDebug("DHCEPRImport","DataImportMgr",sub,ind))
	 	q:(ind="")
	 	
	 	s sRec = ^CacheTempDHCEPRDebug("DHCEPRImport","DataImportMgr",sub,ind)
	 	//b "s"
	 	s pID=$p(sRec,del,1),UsrCertCode=$p(sRec,del,2)	
    	&sql(UPDATE CA.UsrSignatureInfo SET UsrCertCode=:UsrCertCode 
           WHERE ID=:pID)           
 		
 		s idx=idx+1
 		w "successfully  "_idx,!
 	}
 	
 	quit 

ImportErrorHandler
	w "error occured:"_$Zerror
	quit
}

}
