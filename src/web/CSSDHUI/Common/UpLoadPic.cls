Class web.CSSDHUI.Common.UpLoadPic Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 图片上传统一入口
/// wfg
/// 2019-7-31
ClassMethod UpLoad(File, Params, FileName)
{
	
	n (File,Params,FileName) 
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJobj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Type=PJobj.%Get("Type")
	i Type="Package" d
	.s RtnObj=##class(web.CSSDHUI.PackageInfo.Package).SavePkgImg(File,Params,FileName)
	q RtnObj.Json()
}

/// 根据图片文件名定义新图片名 lihui20230407
/// w ##class(web.CSSDHUI.Common.UpLoadPic).getPicNewFileName()
ClassMethod getPicNewFileName(FileName, PPkgDesc = "")
{
	n (FileName,PPkgDesc) 
	s FileSuffix="JPG"
	i FileName'=""  d
	.s Len=$L(FileName,".")
	.s FileSuffix=$p(FileName,".",Len)
	.s FileSuffix=$$ALPHAUP^SSUTIL4(FileSuffix)
	.s PicType=$$ALPHAUP^SSUTIL4("gif,jpg,jpeg,bmp,png")
	.i (PicType'[FileSuffix) s Type="PDF"
	.e  s Type="JPG"
	s NewFileName=PPkgDesc_$tr($j($RANDOM(1000000),6)," ","0")_"."_FileSuffix
	q NewFileName
}

}
