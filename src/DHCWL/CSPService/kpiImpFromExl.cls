Class DHCWL.CSPService.kpiImpFromExl Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod CheckImpData(impData As %Text)
{
	n (impData)
	s impDataobj=##class(DHCWL.util.Json).buildCollectFromJsonStr(.impData)
	/*
	s key=impDataobj.Next("")
	while $g(key)'="" {
		w !,key

		s obj=impDataobj.GetAt(key)
		s key=impDataobj.Next(key)
	}
	*/
	
	//1、把导入的数据转换为global，格式为：^TEMPDHCWL($J,类名称,记录个数索引,字段名)=字段值
	s aryClassName(1)="DHCWL.MKPI.MMgrModuleCfg"
	s aryClassName(2)="DHCWL.MKPI.MMgrRptCfg"
	s aryClassName(3)="DHCWL.MKPI.MMgrDataSetCfg"
	
	s classInx=""
	f {
		s classInx=$o(aryClassName(classInx))
		q:$g(classInx)=""
		s className=aryClassName(classInx)
		s keyName=""""_className_""""
		s moduleObj=impDataobj.GetAt(keyName)
		if $isObject(moduleObj) {
			s aryInx=moduleObj.Next("")
			while $g(aryInx)'="" {
				s rec=moduleObj.GetAt(aryInx)
				if $isObject(rec) {
					s filedCol=rec.Next("")	//filedInx=ModuleCfgCode
					while $g(filedCol)'="" {
						s field=rec.GetAt(filedCol)
						s filedName=filedCol
						s fieldV=field.GetAt(filedName)
						s fieldV=##class(DHCWL.util.StringUtil).Trim(fieldV,"""")
						s filedName=##class(DHCWL.util.StringUtil).Trim(filedName,"""")
						s ^TEMPDHCWL($J,className,"inx",aryInx,filedName)=fieldV
						
						s filedCol=rec.Next(filedCol)
					}
				}
				
				if className="DHCWL.MKPI.MMgrModuleCfg" {
					s moduleCfgPTreeCode=^TEMPDHCWL($J,className,"inx",aryInx,"ModuleCfgPTreeCode")
					s moduleCfgTreeCode=^TEMPDHCWL($J,className,"inx",aryInx,"ModuleCfgTreeCode")
					s ^TEMPDHCWL($J,className,"field",moduleCfgTreeCode,moduleCfgPTreeCode)=1
				}elseif className="DHCWL.MKPI.MMgrRptCfg" {
					s rptCfgTreeCode=^TEMPDHCWL($J,className,"inx",aryInx,"RptCfgTreeCode")
					s rptCfgCode=^TEMPDHCWL($J,className,"inx",aryInx,"RptCfgCode")
					s ^TEMPDHCWL($J,className,"field",rptCfgTreeCode,rptCfgCode)=1
				}elseif className="DHCWL.MKPI.MMgrDataSetCfg" {
					s datasetTreeCode=^TEMPDHCWL($J,className,"inx",aryInx,"DatasetTreeCode")
					s datasetRptCode=^TEMPDHCWL($J,className,"inx",aryInx,"DatasetRptCode")
					s datasetCfgCode=^TEMPDHCWL($J,className,"inx",aryInx,"DatasetCfgCode")
					s ^TEMPDHCWL($J,className,"field",datasetTreeCode,datasetRptCode,datasetCfgCode)=1
				}
				
				s aryInx=moduleObj.Next(aryInx)
			}
		}
	}
	

	//2、检查要导入的数据在系统中是否已经存在
	//2.1检查模块
	//^TEMPDHCWL($j,className,recInx,"ModuleCfgTreeCode")
	b
	s jsonDatas=""
	s classInx=""
	w "{success:true,data:["
	f {
		s classInx=$o(aryClassName(classInx))
		q:classInx=""
		s className=aryClassName(classInx)
		s recInx=""
		f {
			s recInx=$o(^TEMPDHCWL($j,className,"inx",recInx))
			q:recInx=""
			s jsonData="{""className"":"""_className_""""
			s fieldName=""
			s fields=""
			f {
				s fieldName=$o(^TEMPDHCWL($j,className,"inx",recInx,fieldName))
				q:fieldName=""
				
				if fields'="" s fields=fields_ ","
				s fields=fields_""""_fieldName_""":"""_^TEMPDHCWL($j,className,"inx",recInx,fieldName)_""""
			}
			//b
			if (className="DHCWL.MKPI.MMgrModuleCfg") {
				s treeCode=^TEMPDHCWL($j,className,"inx",recInx,"ModuleCfgTreeCode")
				if $d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode)) {
					//已存在
					s jsonData=jsonData_","_fields_","_"""type"""_":"_"""repeat"""_"}"
				}else{
					/*
					s fields=""
					s jsonData=""
					continue
					*/
					
					
					
					
					
					s pTreeCode=^TEMPDHCWL($j,"DHCWL.MKPI.MMgrModuleCfg","inx",recInx,"ModuleCfgPTreeCode")
					if (('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",pTreeCode)))
						&& ('$d(^TEMPDHCWL($J,"DHCWL.MKPI.MMgrModuleCfg","field",pTreeCode)))
						&& ('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgPTreeCodeIndex",pTreeCode)))) 
					 {
						//父节点不存在	
						s jsonData=jsonData_","_fields_","_"""type"""_":"_"""noparent"""_"}"
						k ^TEMPDHCWL($J,className,"field",treeCode)
					}else{
						//s fields=""
						s jsonData=jsonData_","_fields_","_"""type"""_":"_"""yes"""_"}"
						//continue
					}
					
				}
			}elseif(className="DHCWL.MKPI.MMgrRptCfg") {
				s treeCode=^TEMPDHCWL($j,className,"inx",recInx,"RptCfgTreeCode")
				s RptCfgCode=^TEMPDHCWL($j,className,"inx",recInx,"RptCfgCode")
				if $d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,RptCfgCode)) {
					//已存在
					s jsonData=jsonData_","_fields_","_"""type"""_":"_"""repeat"""_"}"
				}else{
					/*
					s fields=""
					s jsonData=""
					continue
					*/					
					//^TEMPDHCWL($J,className,"field",treeCode,RptCfgCode)=1
					if (('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode))) 
						&& ('$d(^TEMPDHCWL($J,"DHCWL.MKPI.MMgrModuleCfg","field",treeCode)))) {
						//父节点不存在	
							s jsonData=jsonData_","_fields_","_"""type"""_":"_"""noparent"""_"}"
							k ^TEMPDHCWL($J,className,"field",treeCode,RptCfgCode)

					}else{
						//s fields=""
						s jsonData=jsonData_","_fields_","_"""type"""_":"_"""yes"""_"}"
						//continue
					}
					
				}
			}elseif(className="DHCWL.MKPI.MMgrDataSetCfg") {
				s treeCode=^TEMPDHCWL($j,className,"inx",recInx,"DatasetTreeCode")
				s rptCode=^TEMPDHCWL($j,className,"inx",recInx,"DatasetRptCode")
				s dsCfgCode=^TEMPDHCWL($j,className,"inx",recInx,"DatasetCfgCode")
				if $d(^DHCWL.MKPI.MMgrDataSetCfgI("DatasetMRCodeIdx",treeCode,rptCode,dsCfgCode)) {
					//已存在
					s jsonData=jsonData_","_fields_","_"""type"""_":"_"""repeat"""_"}"
				}else{
					/*
					s fields=""
					s jsonData=""
					continue	
					*/			
					if (('$d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,rptCode))) 
						&& ('$d(^TEMPDHCWL($J,"DHCWL.MKPI.MMgrRptCfg","field",treeCode,rptCode)))) {
						//父节点不存在	
						s jsonData=jsonData_","_fields_","_"""type"""_":"_"""noparent"""_"}"
						
					}else{
						//s fields=""
						s jsonData=jsonData_","_fields_","_"""type"""_":"_"""yes"""_"}"
						//continue
					}
					
				}
			}
			
			i jsonData'="" {
				i jsonDatas'="" s jsonDatas=jsonDatas_","
				s jsonDatas=jsonDatas_jsonData	
			}
		}
	}
	w $g(jsonDatas)
	w "]}"
	q	
	
	
	k ^TEMPDHCWL($J)
}

ClassMethod importData(impData As %Text)
{
	n (impData)
	//1、把导入的数据转换为global，格式为：^TEMPDHCWL($J,类名称,记录个数索引,字段名)=字段值
	/*
	s aryClassName("DHCWL.MKPI.MMgrModuleCfg")=""
	s aryClassName("DHCWL.MKPI.MMgrRptCfg")=""
	s aryClassName("DHCWL.MKPI.MMgrDataSetCfg")=""
	*/
	s $zt="ErrorOperat"
	s ret=""
	s impDataobj=##class(DHCWL.util.Json).buildCollectFromJsonStr(.impData)
	s aryClassName(1)="DHCWL.MKPI.MMgrModuleCfg"
	s aryClassName(2)="DHCWL.MKPI.MMgrRptCfg"
	s aryClassName(3)="DHCWL.MKPI.MMgrDataSetCfg"
	
	s classInx=""
	f {
		s classInx=$o(aryClassName(classInx))
		q:$g(classInx)=""
		s className=aryClassName(classInx)
		
		s keyName=""""_className_""""
		s moduleObj=impDataobj.GetAt(keyName)
		if $isObject(moduleObj) {
			s aryInx=moduleObj.Next("")
			while $g(aryInx)'="" {
				s rec=moduleObj.GetAt(aryInx)
				if $isObject(rec) {
					s ret=""
					s filedCol=rec.Next("")	//filedInx=ModuleCfgCode
					while $g(filedCol)'="" {
						s field=rec.GetAt(filedCol)
						s filedName=filedCol
						s fieldV=field.GetAt(filedName)
						//s fieldV=##class(DHCWL.util.StringUtil).Trim(fieldV,"""")
						//s filedName=##class(DHCWL.util.StringUtil).Trim(filedName,"""")
						s strExec="s aryParam("_filedName_")="_fieldV
						x strExec
						//s ^TEMPDHCWL($J,className,aryInx,filedName)=fieldV
						s filedCol=rec.Next(filedCol)
					}
					if $d(aryParam) {
						s strExec="s ret=##class("_className_").InsertOrUpdateData(.aryParam)"
						x strExec
						if ret'="success" {
							goto ErrorOperat
						}
						k aryParam
					}
				}
				s aryInx=moduleObj.Next(aryInx)
			}
		}
	}
	
	q ret
ErrorOperat
	if $g(ret)="" s ret="数据异常"
	q ret
}

ClassMethod importKpiExlData(impData As %Text)
{
	n (impData)
	//1、把导入的数据转换为global，格式为：^TEMPDHCWL($J,类名称,记录个数索引,字段名)=字段值
	s $zt="ErrorOperat"
	s ret=""

	s aryTransFun("MKPIUpdateDate")="ImpTransDate"
	s aryTransFun("MKPICate")="ImpTransCate"
	s aryTransFun("MKPISectionFlag")="ImpTransSec"
	s aryTransFun("MKPIGetValueType")="ImpTransValueType"
	s impDataobj=##class(DHCWL.util.Json).buildCollectFromJsonStr(.impData)
	s className="DHCWL.MKPI.MKPI"
	
	s keyName=""""_className_""""
	s KPIObj=impDataobj.GetAt(keyName)
	if $isObject(KPIObj) {
		s aryInx=KPIObj.Next("")
		while $g(aryInx)'="" {
			s rec=KPIObj.GetAt(aryInx)
			if $isObject(rec) {
				s ret=""
				s filedCol=rec.Next("")	//filedInx=ModuleCfgCode
				while $g(filedCol)'="" {
					s field=rec.GetAt(filedCol)
					s filedName=filedCol
					s tfiledName=##class(DHCWL.util.StringUtil).Trim(filedName,"""")
					s fieldV=field.GetAt(filedName)
					if $d(aryTransFun(tfiledName)) {
						s transFun=aryTransFun(tfiledName)
						s strTrans="s fieldV=.."_transFun_"("_fieldV_")"
						x strTrans
					}
					s strExec="s aryParam("_filedName_")="_fieldV
					x strExec
					s filedCol=rec.Next(filedCol)
				}
				if $d(aryParam) {
					s strExec="s ret=##class("_className_").InsertOrUpdateData(.aryParam)"

					x strExec
					if ret'="success" {
						goto ErrorOperat
					}

					k aryParam
				}
			}
			s aryInx=KPIObj.Next(aryInx)
		}
	}
	q ret
}

ClassMethod ImpTransDate(strDate As %String) As %String
{
	s ret=""
	s ret=$zdh(strDate,3)
	q ret
}

ClassMethod ImpTransCate(strCate As %String) As %String
{
	n (strCate)
	s alphaup=$SYSTEM.SQL.ALPHAUP(strCate)
	s cateDr=$o(^DHCWL.MKPI.MKPIFLI("FLName",alphaup,""))
	if $g(cateDr)="" {
		s ret="指标类型数据错误"
		goto ErrorOperat
	}
	q cateDr
}

ClassMethod ImpTransSec(strSec As %String) As %String
{
	n (strSec)
	
	s alphaup=$SYSTEM.SQL.ALPHAUP(strSec)

	s secDr=$o(^DHCWL.MKPI.SectionI("SecName",alphaup,""))
	if $g(secDr)="" {
		s ret="指标区间数据错误"
		goto ErrorOperat
	}
	q secDr
}

ClassMethod ImpTransValueType(strValueType As %String) As %String
{
	if (($g(strValueType)'=1) && ($g(strValueType)'=2)) s ret=1
	else  s ret=strValueType
	q ret
}

}
