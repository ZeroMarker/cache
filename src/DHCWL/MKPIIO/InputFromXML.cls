Class DHCWL.MKPIIO.InputFromXML Extends %RegisteredObject [ Not ProcedureBlock ]
{

/*将xml文件中的指标数据及其与指标关联的数据导入到数据库中（若无此记录），或更新到数据库中
 *d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXML("C:\2013-05-27 9230outputKpis.xml",0)
 *Creator:李海红
 *Time:2012-8-26
 *Inpute    parFilePathName:导入数据存放路径；skipCode导入时对已经存在该Code的对象是否重新更新对象？1：不更新，0：更新
 *
 */
ClassMethod InputFromXML(parFilePathName, skipCode As %Integer = 1, onlyCheck As %Integer = 0, condtionInput = 0) As %Integer
{
	n (parFilePathName,skipCode,onlyCheck,condtionInput)
	s level=3,markLevel=2
	;W "Please waiting......",!
	k reader
	;s parFilePathName="C:\2013-03-28 16628 680outputKpis.xml"
	Set sc =##class(%XML.TextReader).ParseFile(parFilePathName,.reader)
	If $$$ISERR(sc){ 
		Do $system.OBJ.DisplayError(sc) 
		Quit 0
	}
	i '$d(^DHCWL.MKPI.CodeAndId)  d ##class(DHCWL.MKPIIO.XMLIOConfige).ConfigeCodeAndId()
	s mkpis=""
	s mkpi=""
	s maxDepth=0
	s result=""
	s obj=""
	While (reader.Read()) {	//find all parent single node obj
		//w reader.Depth_" "_reader.NodeType_" "_reader.Name
   		 If ((reader.Depth =markLevel)&&(reader.NodeType="element")) {
	   		 s mkpi=reader.Name
	   		 s mkpis(mkpi)=""
    	 }elseif((reader.Depth =(markLevel+1))&&(reader.NodeType="element")){
	    	 s pro=reader.Name
	    	 s mkpis(mkpi,pro)=""
	    	 i reader.HasAttributes {
			 	s cnt=reader.AttributeCountGet()
			 	f i=1:1:cnt {
	 		 		d reader.MoveToAttributeIndex(i)
	 		 		i reader.Name="ID"{
		 		 		s mkpis(mkpi,pro,reader.Value)=reader.Value
		 		 		s canProcess=1
	 		 		}
			 	}
	   		 }
	   		 
    	 }
    	 if (reader.Depth>maxDepth) s maxDepth=reader.Depth
 	}
    NEW $ETRAP
 	s $ET="do ..TrapRunError(1)"
 	tstart
    s mkpi=""  f  s mkpi=$o(mkpis(mkpi)) q:mkpi=""  d
 	.;w "now processing:"_mkpi,!
 	.i onlyCheck=1 d
 	..s tryId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(mkpi,"DHCWL.MKPI.MKPI")
 	..s parCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName("DHCWL.MKPI.MKPI")
 	..s ^TEMPDHCWL("CK",$j,mkpi)=tryId
	..s ^TEMPDHCWL("CK",$j,mkpi,"P")=parCode
	..s ^TEMPDHCWL("CK",$j,mkpi,"T")="DHCWL.MKPI.MKPI"
	.i onlyCheck=1 q
 	.q:(condtionInput=1)&&('$d(^TEMPDHCWL("REALINPUT",$j,mkpi)))
 	.s objNode=""  f  s objNode=$o(mkpis(mkpi,objNode))  q:objNode=""  d
 	..;w objNode,!
 	..s id=mkpis(mkpi,objNode)
 	..d ..InputFromXMLPri(mkpi,level,objNode,.reader,maxDepth,.skipCode,onlyCheck)
	k ^TempPV($j),^TEMPDHCWL("REALINPUT",$j)
	tcommit
	q 1
}

/// d ##class(DHCWL.MKPIIO.InputFromXML).InputFromStream(stream,0)
ClassMethod InputFromStream(stream As %GlobalCharacterStream, skipCode As %Integer = 1, onlyCheck As %Integer = 0, condtionInput = 0) As %Integer
{
	s level=3,markLevel=2
	;W "Please waiting......",!
	k reader
	;s parFilePathName="C:\2013-03-28 16628 680outputKpis.xml"
	Set sc =##class(%XML.TextReader).ParseStream(stream,.reader)
	If $$$ISERR(sc){ 
		Do $system.OBJ.DisplayError(sc) 
		Quit 0
	}
	i '$d(^DHCWL.MKPI.CodeAndId)  d ##class(DHCWL.MKPIIO.XMLIOConfige).ConfigeCodeAndId()
	s mkpis=""
	s mkpi=""
	s maxDepth=0
	s result=""
	s obj=""
	While (reader.Read()) {		//find all parent single node obj
		//w reader.Depth_" "_reader.NodeType_" "_reader.Name
   		 If ((reader.Depth =markLevel)&&(reader.NodeType="element")) {
	   		 s mkpi=reader.Name
	   		 s mkpis(mkpi)=""
    	 }elseif((reader.Depth =(markLevel+1))&&(reader.NodeType="element")){
	    	 s pro=reader.Name
	    	 s mkpis(mkpi,pro)=""
	    	 i reader.HasAttributes {
			 	s cnt=reader.AttributeCountGet()
			 	f i=1:1:cnt {
	 		 		d reader.MoveToAttributeIndex(i)
	 		 		i reader.Name="ID"{
		 		 		s mkpis(mkpi,pro,reader.Value)=reader.Value
		 		 		s canProcess=1
	 		 		}
			 	}
	   		 }
	   		 
    	 }
    	 if (reader.Depth>maxDepth) s maxDepth=reader.Depth
 	}
    NEW $ETRAP
 	s $ET="do ..TrapRunError(1)"
 	tstart
    s mkpi=""  f  s mkpi=$o(mkpis(mkpi)) q:mkpi=""  d
 	.;w "now processing:"_mkpi,!
 	.i onlyCheck d
 	..s tryId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(mkpi,"DHCWL.MKPI.MKPI")
 	..s parCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName("DHCWL.MKPI.MKPI")
 	..s ^TEMPDHCWL("CK",$j,mkpi)=tryId
	..s ^TEMPDHCWL("CK",$j,mkpi,"P")=parCode
	..s ^TEMPDHCWL("CK",$j,mkpi,"T")="DHCWL.MKPI.MKPI"
	.i flag=1 q
 	.q:(condtionInput=1)&&('$d(^TEMPDHCWL("REALINPUT",$j,mkpi)))
 	.s objNode=""  f  s objNode=$o(mkpis(mkpi,objNode))  q:objNode=""  d
 	..;w objNode,!
 	..s id=mkpis(mkpi,objNode)
 	..d ..InputFromXMLPri(mkpi,level,objNode,.reader,maxDepth,.skipCode,onlyCheck)
	k ^TempPV($j),^TEMPDHCWL("REALINPUT",$j)
	tcommit
	q 1
}

/// d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXMLChecked("C:\2013-05-27 9242outputKpis.xml")
ClassMethod InputFromXMLChecked(parFilePathName, checkFlag As %Integer = 0)
{
	n (parFilePathName,checkFlag)
	;k ^TEMPDHCWL("CK",$j)
	;s parFilePathName="C:\2013-03-25 113542 17outputKpis.xml"
	d ##class(DHCWL.MKPIIO.InputFromXML).InputFromXML(parFilePathName,0,1)
	s num=0
	if (checkFlag=0) {
		w "["
		s mkpiCode=""
		f {
			s mkpiCode=$o(^TEMPDHCWL("CK",$j,mkpiCode))
			q:mkpiCode=""
			i num>0 w ","
			w "["""_mkpiCode_""","""_mkpiCode_"""]"
			s num=num+1
		}
		w "]"
		q
	}
	w "{success:true,root:["
	s id="" f  s id=$o(^TEMPDHCWL("CK",$j,id)) q:id=""  d
	.s code=^TEMPDHCWL("CK",$j,id)
	.s type=^TEMPDHCWL("CK",$j,id,"T")
	.q:(type '="DHCWL.MKPI.MKPI")
	.q:code=""
	.s par=^TEMPDHCWL("CK",$j,id,"P")
	.i num>0 w ","
	.w "{className:'"_type_"',propertyCode:'"_par_"',codeValue:'"_id_"',id:'"_code_"'}"
	.s num=num+1
	w "],totalNum:"_num_"}"
	k ^TEMPDHCWL("CK",$j)
}

ClassMethod InputFromXMLOfReader(reader As %XML.TextReader, skipCode As %Integer = 1, onlyCheck As %Integer = 0) As %String
{
	n (reader,skipCode,onlyCheck)
	q:reader="" "there is not the file!"
	While (reader.Read()) {		//process one obj
		//w reader.Depth_" "_reader.NodeType_" "_reader.Name
   		 If ((reader.Depth =markLevel)&&(reader.NodeType="element")) {
	   		 s mkpi=reader.Name
	   		 s mkpis(mkpi)=""
    	 }elseif((reader.Depth =(markLevel+1))&&(reader.NodeType="element")){
	    	 s pro=reader.Name
	    	 s mkpis(mkpi,pro)=""
	    	 i reader.HasAttributes {
			 	s cnt=reader.AttributeCountGet()
			 	f i=1:1:cnt {
	 		 		d reader.MoveToAttributeIndex(i)
	 		 		i reader.Name="ID"{
		 		 		s mkpis(mkpi,pro,reader.Value)=reader.Value
		 		 		s canProcess=1
	 		 		}
			 	}
	   		 }
	   		 
    	 }
    	 if (reader.Depth>maxDepth) s maxDepth=reader.Depth
 	}
    s mkpi=""  f  s mkpi=$o(mkpis(mkpi)) q:mkpi=""  d
 	.;w "now processing:"_mkpi,!
 	.s objNode=""  f  s objNode=$o(mkpis(mkpi,objNode))  q:objNode=""  d
 	..;w objNode,!
 	..s id=mkpis(mkpi,objNode)
 	..d ..InputFromXMLPri(mkpi,level,objNode,.reader,maxDepth,.skipCode)
	k ^TempPV($j)
	d stream.Clear()
	q 1
}

/*
*导入数据辅助方法
*Creator:李海红
*Input：mkpiCode:哪个节点指标；i:该对象数据所在节点深度；nodeObject：要导入对象的节点名称；reader：xml文件句柄；n:节点最大深度；skipCode：是否忽略代码
*/
ClassMethod InputFromXMLPri(mkpiCode, i As %Integer, nodeObject, ByRef reader As %XML.TextReader, n As %Integer, ByRef skipCode As %Integer, onlyCheck As %Integer = 0) As %ObjectIdentity
{
	n (mkpiCode,i,nodeObject,reader,n,skipCode,onlyCheck)
	if i<=n {
		k ^TempPV($j,nodeObject) //release the resource
		s className=$P(nodeObject,"-",1)   ;##class(DHCWL.MKPIService.XMLIOConfige).GetTypeByProName(nodeObject)
		s procObj=""
		s status="",codeValue="",kpiTaskFlag=0
		d ..FindDirectPropertyByDepth(mkpiCode,nodeObject,className,i,1,1,,.status,.proObject,.reader)
		s comand=status
		q:comand="" $g(proObject)
		s preComand=comand
		i $d(^TempPV($j,nodeObject,i,className,"Code")) s codeValue=$g(^TempPV($j,nodeObject,i,className,"Code"))
		s parCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeByClassName(className)
		if codeValue="" {
			if className="DHCWL.MKPI.CreatDataTask" {
				s tempKpiId=$g(^TempPV($j,nodeObject,i+1,"DHCWL.MKPI.MKPI"))
				s tempSecId=$g(^TempPV($j,nodeObject,i+1,"DHCWL.MKPI.Section"))
				s codeValue=tempKpiId_"||"_tempSecId
				s kpiTaskFlag=1
			}elseif className="DHCWL.MKPI.MKPIDimensions" {
				
			}else{
				s:parCode'="" codeValue=$g(^TempPV($j,nodeObject,i+1,parCode))
			}
		}
		s canId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode($g(codeValue),className)
		s id=canId
		i onlyCheck {
			//don't input only check created
			if (+canId>0)&&(codeValue'=""){
				s ^TEMPDHCWL("CK",$j,canId)=codeValue
				s ^TEMPDHCWL("CK",$j,canId,"P")=parCode
				s ^TEMPDHCWL("CK",$j,canId,"T")=className
				s oneObj="" 
				f  {
					s oneObj=$o(^TempPV($j,nodeObject,i+1,oneObj))  
					q:oneObj=""
					s proName=$g(^TempPV($j,nodeObject,i+1,oneObj,"Property"))
					s id=$g(^TempPV($j,nodeObject,i+1,oneObj,"ID"))
					i proName="" continue
					s type=$g(^TempPV($j,nodeObject,i+1,proName,"Type"))
					;b  ;000
					i (proName="")||(type="") continue
					i (##class(DHCWL.MKPIIO.OutputToXML).IsDateType(type)) continue
					d ..InputFromXMLPri(mkpiCode,(i+1),oneObj_"-"_id,.reader,n,skipCode,onlyCheck)
				}
				
			}
		}
		i onlyCheck q ""
		i ($g(skipCode)=1)&&($g(codeValue)'="")&&(canId'=""){  //cechek can ignore?
			 ;w preComand,!
			 q procObj
		}
		q:comand="" procObj
		i ($g(skipCode)=1)&&(+id>0)&&(parCode'="") q procObj 
		NEW $ETRAP
		s $et="d ..TrapRunError(1)"
		;tstart  //dont do this may affect sppeed when data too more
		if (+id>0)&&(onlyCheck=0){
		   d ..FindDirectPropertyByDepth(mkpiCode,nodeObject,className,i,0,0,id,.comand,.proObject,.reader)
		}elseif (onlyCheck=0){
		  d ..FindDirectPropertyByDepth(mkpiCode,nodeObject,className,i,0,1,id,.comand,.proObject,.reader)
		}
		s procObj=proObject,tempCodeVaue=""
		i (1=0)&& (parCode'="") {  //aftertoday don't use this code
			s str="s tempCodeVaue=proObject."_parCode
			xecute str
			i (tempCodeVaue'="") &&(tempCodeVaue=codeValue){
				q procObj
			}elseif (tempCodeVaue'=codeValue){
				k ^TempPV($j,nodeObject)
				;d ..FindDirectPropertyByDepth(mkpiCode,nodeObject,className,i,1,1,,.status,.proObject,.reader)
				d ..FindDirectPropertyByDepth(mkpiCode,nodeObject,className,i,0,1,id,.preComand,.proObject,.reader)
			}
		}
		if comand {
			s oneObj="" 
			f  {
				s oneObj=$o(^TempPV($j,nodeObject,i+1,oneObj))  
				q:oneObj=""
				s proName=$g(^TempPV($j,nodeObject,i+1,oneObj,"Property"))
				;s id=$g(^TempPV($j,nodeObject,i+1,oneObj,"ID"))
				continue:proName=""
				s type=$g(^TempPV($j,nodeObject,i+1,proName,"Type"))
				;b  ;000
				continue:type=""
				i (##class(DHCWL.MKPIIO.OutputToXML).IsDateType(type)) continue
				//special for kpi task
				i (className="DHCWL.MKPI.CreatDataTask")&&(type="DHCWL.MKPI.MKPI") {
					;b  ;000
					s codeValue=$g(^TempPV($j,nodeObject,i,className,"Code"))
					s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode($p(codeValue,"||",1),"DHCWL.MKPI.MKPI")
					continue:codeValue=""
					s codeValue=$p(codeValue,"||",1)
					s verNode=$o(^DHCWL.MKPI.Version(""),-1)
  					s version=1.0
  					s:verNode'="" version=^DHCWL.MKPI.Version(verNode)
  					s id=$g(^TempPV($j,nodeObject,i+1,oneObj,"ID"))
					;s mkpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(codeValue,"DHCWL.MKPI.MKPI")
					s valRef= ..InputFromXMLPri(codeValue,i,type_"-"_id,.reader,n,skipCode)
					//i +version<3.0 s valRef= ..InputFromXMLPri(codeValue,i,type_"-"_mkpiId,.reader,n,skipCode)  //apply for version 3.0 below
					//e  s valRef= ..InputFromXMLPri(codeValue,i+1,type_"-"_mkpiId,.reader,n,skipCode)  //apply for 3.0
					s cmd=" s procObj.DTaskKPIDR=valRef"    ;##class(DHCWL.MKPI.MKPI).%OpenId("_id_")"
					xecute cmd," s sc=procObj.%Save()"
					;w cmd,!
					continue
				}
				//special for kpiDim
				i (className="DHCWL.MKPI.MKPIDimensions")&&(type="DHCWL.MKPI.MKPI") {
					s codeValue=$g(^TempPV($j,nodeObject,i,className,"Code"))
					;s id=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode($p(codeValue,"||",1),"DHCWL.MKPI.MKPI")
					continue:codeValue=""
					s codeValue=$p(codeValue,"||",1)
					s id=$g(^TempPV($j,nodeObject,i+1,oneObj,"ID"))
					;s mkpiId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(codeValue,"DHCWL.MKPI.MKPI")
					s valRef= ..InputFromXMLPri(codeValue,i,type_"-"_id,.reader,n,skipCode)  //apply for version 3.0 below
					s cmd=" s procObj.MKPIDr=valRef"    ;##class(DHCWL.MKPI.MKPI).%OpenId("_id_")"
					xecute cmd," s sc=procObj.%Save()"
					;w cmd,!
					continue
				}
				//special for dim property
				i (className="DHCWL.MKPI.DimProperty")&&(type="DHCWL.MKPI.MKPIDimType") {
					//b  ;000
					s codeValue=$g(^TempPV($j,nodeObject,i+1,type,"Code"))
					continue:codeValue=""
					s id=$g(^TempPV($j,nodeObject,i+1,oneObj,"ID"))
					;s dimId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(codeValue,"DHCWL.MKPI.MKPIDimType")
					s valRef= ..InputFromXMLPri(mkpiCode,i+1,type_"-"_id,.reader,n,skipCode)
					s cmd=" s procObj.DimDr=valRef"    ;##class(DHCWL.MKPI.MKPI).%OpenId("_id_")"
					xecute cmd," s sc=procObj.%Save()"
					;w cmd,!
					continue
				}
				;b  ;001
				s id=$g(^TempPV($j,nodeObject,i+1,oneObj,"ID"))
				s valRef= ..InputFromXMLPri(mkpiCode,(i+1),oneObj_"-"_id,.reader,n,skipCode)
				i valRef="" {
					s v=..ReflactProperty(procObj,proName) ;$PROPERTY(procObj,proName) ensamble2010前不支持此方法，改用这个
					i $g(v)'="" s cmd=" s procObj."_proName_"=v"
					e  d  s cmd=" s procObj."_proName_"=##class("_oneObj_").%OpenId("_id_")"
				}else {
					s cmd=" s procObj."_proName_"=valRef"
					
				}
				xecute cmd ," s sc=procObj.%Save()"
				i sc'=1 {
					;w "Error input:"_procObj
					w 1/0
				}
			}
		}
		k ^TempPV($j,nodeObject)
		;tcommit
		q procObj
	}
}

/*
*找到某一个节点上所有的直接属性及其值，并创建出执行语句
*Creator:李海红
*Input：mkpiCode:哪个节点指标；parDepth:该对象数据所在节点深度；parObjectNode：要导入对象的节点名称；parClassName:该节点对象的类全名；parIsFirst：第一次查阅对象？;parIsNew:为新对象？；parIndexedId：该节点对象的ID；result：查阅结果句柄：object：生成或打开的对象句柄；reader：xml文件句柄；
*/
ClassMethod FindDirectPropertyByDepth(mkpiCode, parObjectNode, parClassName, parDepth As %Integer, parIsFirst As %Integer, parIsNew As %Integer, parIndexedId, ByRef result, ByRef object As %ObjectIdentity, ByRef reader As %XML.TextReader) As %String
{
  n (mkpiCode,parObjectNode, parDepth, parIsFirst,parIsNew, parIndexedId, parClassName,result, object,reader)
  s comand=""
  ;k ^TempPV($j,parDepth)
  ;k ^TempPV($j,parDepth+1)
  if parIsFirst{
	set flag=1
findLable
	f{   //fist location the obj
		if (reader.NodeType="element")&&(reader.Name=mkpiCode) s flag=0 q
		q:'reader.Read() 
  	 }
  	if (flag){
	   d reader.Rewind()
	   if flag>1 set reslut="" q
	   s flag=flag+1
	   goto findLable	//try two times to find target node
  	}
  	s flag=0
	While (reader.Read()) {		//find the target obj's pro
   		 If ((reader.Depth = parDepth)&&((reader.NodeType="element")&&(reader.Name=parObjectNode))) {
	   		 s pro=$p(reader.Name,"-",1)
	   		 s ^TempPV($j,parObjectNode,parDepth,pro)=""
	   		 i reader.HasAttributes {
			 	s cnt=reader.AttributeCountGet()
			 	f i=1:1:cnt {
	 		 		d reader.MoveToAttributeIndex(i)
					s ^TempPV($j,parObjectNode,parDepth,pro,reader.Name)=reader.Value
			 	}
	   		 }
	   		 s flag=1
	   		 q
    	 } 
 	}
 	if 'flag  s result="" q
 	s (depth,preDepth)=parDepth
 	s pro=""
 	//find the obj property and value
 	f {
	 	 q:'(reader.Read())
	 	 if (reader.NodeType="endelement"){
		 	 	s result="ok"
	    	 	q:reader.Name=parObjectNode
    	 }
    	 s preDepth=depth
    	 s depth=reader.Depth
    	 if (depth=parDepth||(depth=(parDepth+1))){
	    	 if (reader.NodeType="element"){
	    	 	s pro=$p(reader.Name,"-",1)
	    	 	s ^TempPV($j,parObjectNode,depth,pro)=""
	    	 	i reader.HasAttributes {   
			 		s cnt=reader.AttributeCountGet()
			 		f i=1:1:cnt {
	 		 			d reader.MoveToAttributeIndex(i)
						s ^TempPV($j,parObjectNode,depth,pro,reader.Name)=reader.Value
						;i reader.Name="ID" {
						;	s ^TempPV($j,parObjectNode,depth,pro)=reader.Value
						;}
			 		}
	   		 	}
	    	 }
	    	 if (reader.NodeType="chars"){
	    	 		s:((depth=(parDepth+1))&&(pro'="")) ^TempPV($j,parObjectNode,depth,pro)=reader.Value
    	 	 }
    	 } 
 	}
 	//b ;009
 	Set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(parClassName)
 	q:cdef="" ""
 	Set count = cdef.Properties.Count()
 	//covert value by type
 	s Mark("%String",1)=$char(34),Mark("%String",2)=$char(34)
 	s Mark("%Date",1)=$char(36,122,100,104,40,34),Mark("%Date",2)=$char(34,44,51,41) ;"zd(",Mark("%Date",2)=")"
 	s Mark("%Integer",1)=" ",Mark("%Integer",2)=" "
 	//s Mark("",1)="",Mark("",2)=""
 
 	s parDepth=parDepth+1
 	For i = 1:1:count {
	 	s pro=cdef.Properties.GetAt(i).Name
	 	s type=cdef.Properties.GetAt(i).Type
	 	i ($g(^TempPV($j,parObjectNode,parDepth,pro))'=""){
		 	 s ^TempPV($j,parObjectNode,parDepth,pro,"Type")=type
	 	}else{
		 	s pro2=$g(^TempPV($j,parObjectNode,parDepth,type,"Property"))
		 	i pro2'=""  s ^TempPV($j,parObjectNode,parDepth,pro2,"Type")=type
	 	}
 	}
    s id=""
    f  {
	   s id=$o(^TempPV($j,parObjectNode,parDepth,id)) 
	   q:id=""
	   i ($g(^TempPV($j,parObjectNode,parDepth,id))="")||('$d(^TempPV($j,parObjectNode,parDepth,id,"Type")))|| ($g(Mark(^TempPV($j,parObjectNode,parDepth,id,"Type"),1))="") continue
	   s comand=comand_"   s obj."_id_"="_Mark(^TempPV($j,parObjectNode,parDepth,id,"Type"),1)_^TempPV($j,parObjectNode,parDepth,id)_Mark(^TempPV($j,parObjectNode,parDepth,id,"Type"),2)_"    "
    }
    d cdef.%Close()
    s result=comand
    q comand
  }else{
	  if (parIsNew)||(parIndexedId=""){
		 s comandFir=" s obj=##class("_parClassName_").%New()   "
	  }else{
		 s comandFir=" s obj=##class("_parClassName_").%OpenId("_parIndexedId_")  if obj=""""  s obj=##class("_parClassName_").%New()   "   
		
	  }
	  xecute comandFir,result,"  s sc=obj.%Save() "
	  ;w comandFir,!,result,!,"  s sc=obj.%Save() ",!
	  s result=sc  //remember the exec status
	  s object=obj //remember the obj ref
	  q
  }
}

/// s kpi=##class(DHCWL.MKPI.MKPI).%OpenId(1)
/// s v=##class(DHCWL.MKPIIO.InputFromXML).ReflactProperty(kpi,"MKPICode")
ClassMethod ReflactProperty(insta As %Library.ObjectHandle, propertyname) As %Library.ObjectHandle
{
	n (insta,propertyname)
	q:(insta="")||(propertyname="") ""
	//s clsfn=insta.%PackageName()_"."_insta.%ClassName()
	s v=""
	x "  s v=insta."_propertyname
	q v
}

ClassMethod TrapRunError(isRoll = 0)
{
	n (isRoll)
	w
	i isRoll trollback
	w !,"error in inputing mkpi"
	k ^TempPV($j),^TEMPDHCWL("REALINPUT",$j)
	q
}

}
