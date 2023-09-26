/// 名称:	EMR.IP.BL.BLPatSign
/// 描述:	住院病历 病历导航业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-08
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLCDSS Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存文档
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_CDSS_JS","params":{},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCDSSJS(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userLocId=""
	s userLocId=argInJson.params.userLocId
	
    s strRes = ##Class(EMR.IP.BL.BLCDSS).GetCDSSJSJson(userLocId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入版本ID",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取患者签名配置信息
/// Input:	
/// Return:	CDSS引入的JS路径
/// 
/// Debug:	s argOutData= ##class(%GlobalBinaryStream).%New()
/// 			w ##Class(EMR.IP.BL.BLCDSS).GetCDSSJSJson("191",.argOutData)
ClassMethod GetCDSSJSJson(argUserLocId As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr=[]
	
	s retJsFiles = ##class(EMR.IP.BL.BLCDSS).getCDSSUrl(argUserLocId)
	for i=1:1:$l(retJsFiles,$c(2))
	{
		s jsonsub = {}
		s tmpJsFile = $p(retJsFiles,$c(2),i)
		
		s jsonsub.JsFile = tmpJsFile
		d jsonArr.%Push(jsonsub)
	
	}
	d jsonArr.%ToJSON(argOutData)
	q 1
}

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
