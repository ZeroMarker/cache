/// desc第三方智能诊断工具（CDSS）逻辑处理类
/// creator duan
/// createDate 2020-06-03
Class EMR.IP.BL.BLCDSSService Extends EMR.IP.COM.ActionBase
{

/// desc: 智能诊断工具相关js引入
/// creator：lifengbo
/// createdate: 20230320
/// debug: s retJsFiles = ##class(EMR.IP.BL.BLCDSSService).getCDSSUrl(191)
ClassMethod getCDSSUrl(argUserLocId As %String)
{
	s retJsFiles = ""
    s cdssType =""
    s cdssLock = ##class(EMRservice.BL.BLCDSSTool).GetCDSSLock()
    q:(cdssLock="") ""
	s userLocID = argUserLocId
	for i=1:1:$L(cdssLock,"#")
    {
	    s cdssLockMessage= $P(cdssLock,"#",i)
	    s cdssLockType = $P(cdssLockMessage,"&",2)
	    s cdssLockFlag = $P(cdssLockMessage,"&",1)
	    s cdssDoc = $P(cdssLockFlag,"^",2)
    	s isCdssLock = $P(cdssLockFlag,"^",1)
    	if ((isCdssLock="Y")&(cdssDoc="")){
	    	//全院开启
	    	s:cdssType'="" cdssType =cdssType_"#"_cdssLockType	
	    	s:cdssType="" cdssType= cdssLockType
	    }elseif ((isCdssLock="Y")&(cdssDoc'="")){
		    // 指定科室开启
        	for n=1:1:$L(cdssDoc,",")
        	{
            	if ($P(cdssDoc,",",n)=userLocID){
	            	s:cdssType'="" cdssType = cdssType_"#"_ cdssLockType	
	            	s:cdssType="" cdssType = cdssLockType
            	}
        	}  
    	}
	}
    q:cdssType="" ""
    s listJsFiles=""
    
    for m=1:1:$L(cdssType,"#")
    {
	    s listJsFiles= listJsFiles_$lb("../scripts/emr/js/"_$P(cdssType,"#",m)_".js")
    }
    s listJsFiles= listJsFiles_$lb("../scripts/emr/js/cdssTools.js")
    
    s retJsFiles = $lts(listJsFiles,$c(2))
   
   	q retJsFiles
}

}
