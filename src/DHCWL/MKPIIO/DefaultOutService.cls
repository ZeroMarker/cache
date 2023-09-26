Class DHCWL.MKPIIO.DefaultOutService Extends %RegisteredObject [ Not ProcedureBlock ]
{

//s kpiSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList("16")

/*
根据要导出的指标id或code，取到指标系统的List对象。（指标系统包括，指标，指标维度，维度，维度属性，指标任务）
*/
ClassMethod GetKpiSystemList(mkpi As %Text, dimFlag = 0) As %Library.ListOfObjects
{
	n (mkpi,dimFlag)
	s list=##Class(%Library.ListOfObjects).%New()
	s len=$l(mkpi,",")
	k dimProArr
	f i=1:1:len {
		s kpiId=$p(mkpi,",",i)
		s kpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(kpiId,"DHCWL.MKPI.MKPI")
		s kpiDimCode="",kpiDimFlag=0
		f {
			s kpiDimCode=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode))
			q:kpiDimCode=""
			s kpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",kpiId,kpiDimCode,""))
			continue:kpiDimId=""
			s kpiDimObj=##class(DHCWL.MKPI.MKPIDimensions).%OpenId(kpiDimId)
			continue:kpiDimId=""
			s kpiDimFlag=1
			d list.Insert(kpiDimObj)
			if (dimFlag=0){
				if (kpiDimObj.MKPIDimDimDr){
					s baseDimId=kpiDimObj.MKPIDimDimDr.%Id()
					if (baseDimId'=""){
						s dimProCode=""
						f {
							s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",baseDimId,dimProCode))
							q:dimProCode=""
							s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",baseDimId,dimProCode,""))
							if ($d(^DHCWL.MKPI.DimPropertyD(dimProId))){
								s primaryDimProCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(dimProId,"DHCWL.MKPI.DimProperty")
								s:primaryDimProCode'="" dimProArr(primaryDimProCode)=dimProId
							}
						}
					}
				}
			}
		}
		if $d(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiId)){
			s meaDr=""
			for {
				s meaDr=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiId,meaDr))
				q:meaDr=""
				s kpiMeaID=""
				s kpiMeaID=$o(^DHCWL.MKPI.MKPIMeasureI("MKPIMeaI",kpiId,meaDr,""))
				s kpiMeaObj=##class(DHCWL.MKPI.MKPIMeasure).%OpenId(kpiMeaID)
				d:kpiMeaObj'="" list.Insert(kpiMeaObj)
			}
			
		}
		if (kpiDimFlag=0){
			s:kpiId'="" kpiObj=##class(DHCWL.MKPI.MKPI).%OpenId(kpiId)
			d:kpiObj'="" list.Insert(kpiObj)
		}
		s activeFlag=""
		f {
			s activeFlag=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,activeFlag))
			q:activeFlag=""
			s taskId=""
			f {
				s taskId=$o(^DHCWL.MKPI.CreatDataTaskI("KPI",kpiId,activeFlag,taskId))
				q:taskId=""
				s taskObj=##class(DHCWL.MKPI.CreatDataTask).%OpenId(taskId)
				d:taskId'="" list.Insert(taskObj)
			}
		}
	}
	s primayDimProCode=""
	f {
		s primayDimProCode=$o(dimProArr(primayDimProCode))
		q:primayDimProCode=""
		s dimProObj=##class(DHCWL.MKPI.DimProperty).%OpenId(dimProArr(primayDimProCode))
		d:dimProObj'="" list.Insert(dimProObj)
	}
	q list
}

//s kpiSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiSystemList("16")

/*
根据要导出的维度、维度属性id或code，取到维度系统的List对象。（维度系统包括维度，维度属性）
*/
ClassMethod GetDimSystemList(mdim As %Text, dimFlag = 0) As %Library.ListOfObjects
{
	n (mdim,dimFlag)
	s list=##Class(%Library.ListOfObjects).%New()
	s len=$l(mdim,",")
	k dimProArr
	k dimArr
	f i=1:1:len {
		s dimInfor=$p(mdim,",",i)
		continue:dimInfor=""
		s dimSign=$p(dimInfor,"-",1)
		s dimValue=$p(dimInfor,"-",2)
		if (dimSign="dim"){
			s dimArr(dimSign,dimValue)=""
		}else{
			s dimProArr(dimSign,dimValue)=""
		}
	}
	s dimProID=""
	for{
		s dimProID=$o(dimProArr("dimPro",dimProID))
		q:dimProID=""
		/*s dimID=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),2)
		if ($d(dimArr("dim",dimID))){
			s dimArr("dim",dimID)=1
		}*/
		s dimProObj=##class(DHCWL.MKPI.DimProperty).%OpenId(dimProID)
		d:dimProObj'="" list.Insert(dimProObj)
	}
	/*s dimID=""
	for{
		s dimID=dimArr("dim",dimID)
		q:dimID=""
		continue:dimArr("dim",dimID)=1
		s dimObj=##class(DHCWL.MKPI.MKPIDimType).%OpenId(dimID)
		d:dimProObj'="" list.Insert(dimObj)
	}*/
	q list
}

/// Creator:       wk
/// CreatDate:     2017-07-31
/// Description:   根据要导出任务组ID，取到任务明细的List对象。
/// Table:         DHCWL_MKPI.DHCWLConfigTaskGroup,DHCWL_MKPI.DHCWLTaskGroupDetai
/// other:         s kpiSysList=##class(DHCWL.MKPIIO.DefaultOutService).GetKpiTaskSystemList("16")
ClassMethod GetKpiTaskSystemList(grpIDs As %Text) As %Library.ListOfObjects
{
	n (grpIDs)
	s list=##Class(%Library.ListOfObjects).%New()
	s len=$l(grpIDs,",")
	k taskDetailArr
	f i=1:1:len {
		s grpID=$p(grpIDs,",",i)
		continue:grpID=""
		s grpDetailID=""
		for {
			s grpDetailID=$o(^DHCWL.MKPI.TaskGroupDetailI("Code",grpID,grpDetailID))
			q:grpDetailID=""
			s detailTaskObj=##class(DHCWL.MKPI.TaskGroupDetail).%OpenId(grpDetailID)
			d:detailTaskObj'="" list.Insert(detailTaskObj)
		}
	}
	q list
}

//d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMKPI("16,773","D:\newKpi.xml")

ClassMethod OutputMKPI(list As %Library.ListOfObjects, path)
{
	n (list,path)
	s service=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(.list,.service,path)
}

//d ##class(DHCWL.MKPIIO.DefaultOutService).OutputMKPIToStream(kpiSysList,.stream)

ClassMethod OutputMKPIToStream(list As %Library.ListOfObjects, ByRef stream As %Library.FileBinaryStream, dimFlag = 0)
{
	n (list,stream,dimFlag)
	s service=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(.list,.service,,.stream,,dimFlag)
}

ClassMethod OutputMDIMToStream(list As %Library.ListOfObjects, ByRef stream As %Library.FileBinaryStream, dimFlag = 0)
{
	n (list,stream,dimFlag)
	s service=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(.list,.service,,.stream,"dim",dimFlag)
}

/// creator:     wk
/// creatDate:   "2017-08-02"
/// discription: 任务组导出接口
ClassMethod OutputTaskToStream(list As %Library.ListOfObjects, ByRef stream As %Library.FileBinaryStream, dimFlag = 0)
{
	n (list,stream,dimFlag)
	s service=##class(DHCWL.MKPIIO.util.OutputInterface).%New()
	d ##class(DHCWL.MKPIIO.util.Write).WriteXML(.list,.service,,.stream,"Task",dimFlag)
}

ClassMethod TraverXmlToStr(reader As %XML.TextReader)
{
	n (reader)
	w "<?xml version=""1.0"" encoding=""GBK""?>"
    f {
	    q:'reader.Read()
	    s flag=0
	    i reader.NodeType="element"{
		    w "<"_reader.Name
			i (reader.HasAttributes) {   
				w " "
				s cnt=reader.AttributeCountGet()
				f i=1:1:cnt {
	 				d reader.MoveToAttributeIndex(i)
					w reader.Name_"="""_reader.Value_"""  "
				}
	   		}
	   		w ">"
	    }elseif reader.NodeType="chars" {
		    w "<![CDATA["_reader.Value_"]]>"
		    s flag=1
	    }elseif reader.NodeType="endelement" {
		    i flag=1 w ">"
		   	 w "</"_reader.Name_">"
	    }
    }
}

}
