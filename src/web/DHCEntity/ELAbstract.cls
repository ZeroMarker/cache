IncludeGenerator %occInclude

Class web.DHCEntity.ELAbstract Extends %RegisteredObject [ Abstract, ClassType = "", ProcedureBlock ]
{

Parameter DEFAULTCONCURRENCY = "$zu(115,10)";

/// 私有数据，关联医院id
Property LinkHospId As %String;

/// 对应的持久化类名称
/// 
Parameter PersistentClassName;

/// 视图名称
Parameter ViewName;

/// 表名称
/// 授权的时候用到
Parameter TableName;

/// 打开数据的数据调度
ClassMethod OpenIdData(id As %String, lastdate As %String = {$h}) As %ObjectHandle
{
	;d ##class(web.DHCEntity.ELAbstract).
	;变量命名规则   %dss_  名称
	;1. 判断时间是否取历史值， 如果历史值存在直接加载成历史值
	;2. 
	;3. 
	;4. 
	;s %dssRowID = ""
	
	if (lastdate=$h){
		;取当前值
		
	}else{
		;取历史值
		
	}
}

/// 保存数据调度
Method SaveData() As %Status
{
	;变量命名规则   %dss_  名称
	;1. 获取oldvalue, 形成数组
	;2. 生成历史数据 DTL+Global名称(RowID, lastDate, LastTime)=oldvalue
	;3. 调用%Save()方法
	;4. 调用 生成 Bitmap方法， 在DTDSS中
	s %dssRowID = ""
}

Method getOldData(RowID As %String, ByRef oValue As %String) As %Status [ CodeMode = generator ]
{
	s %code=0
}

/// 解决： 数据中包含{} [] 字符的问题
Method JsonS() As %String [ CodeMode = generator ]
{
	;%mode,%class,%property,%method,%parameter,%codemode,%code,%classmodify,%context,%language
	b ;00
	s %code=0
	///$$$I()
	;s abstract=##class(web.DHCBL.DSS.ClassMetadata).IsClassAbstract(%class)
	s abstract = $$$defClassKeyGet(%class, $$$cCLASSabstract)
	q:(abstract) $$$OK
	; 自动生成参数
	
	s pcname="PersistentClassName"
	;s pcflag = ##class(web.DHCBL.DSS.ClassMetadata).IsValidDefineParameter(%class,pcname)
	s pcflag = $s(+$$$defMemberDefined(%class,$$$cCLASSparameter,pcname):1, 1:0)
	i ('pcflag){
		;;;;
		d ##class(web.DHCBL.BDP.ClassDefine).ObjectParameter(%class,pcname,%class)
		;d ##class(web.DHCBL.DSS.ClassDefine).Parameter(%class,pcname,%class)
		//d RebuildItemIndex^%R(%class,"CLS")
	}
	
	;判读是否block
	i ('$$$defClassKeyGet(%class, $$$cCLASSprocedureblock)){
		;$$$GENERATE("	n")
	}
	$$$GENERATE("	s jsonstr = """"")
	
	s prop = ""
	for {
		;s prop = ##class(web.DHCBL.DSS.ClassMetadata).NextPropertyName(%class, prop)
		s prop = $$$comMemberNext($$$NormalizeClassname(%class),$$$cCLASSproperty, prop)
		q:(prop="")
		s privateflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPprivate)
		s readonlyflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPreadonly)
		s calcuflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated)
		If ('privateflag) && ('readonlyflag) && ('calcuflag) {
			$$$comMemberKeyGetLvar(relationship,%class,$$$cCLASSproperty,prop,$$$cPROPrelationship)
			;w !,"relationship= "_relationship
			$$$comMemberKeyGetLvar(cardinality,%class,$$$cCLASSproperty,prop,$$$cPROPcardinality)
			;w !, "cardinality = "_cardinality
			If ('relationship) || ((cardinality '= $$$cPROPCARDINALITYCHILDREN) && (cardinality '= $$$cPROPCARDINALITYMANY)) {
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				If (collection = "") || (collection = $$$cPROPCOLLECTIONLIST) || (collection = $$$cPROPCOLLECTIONARRAY) {
						#; The following check quits if the initialexpression is set because
						#; default values always override randomly generated values. In the case of a collection,
						#; the initialexpression applies to the collection object - not to the elements.
					If (collection '= "") || ($$$IVARinitialexpression($$$gMGINFO,%class,prop) = """""") {
						Set order = $$$comMemberArrayGet(%class,$$$cCLASSproperty,prop,$$$cPROPparameter,"POPORDER")
						If (order) && ('$Data(properties(order))) { Set properties(order) = prop } Else { Set unordered(prop) = "" }
					}
				}
			}
		}
		;$$$GENERATE("	w """_prop_"""")
	}
	
	Set max = $Order(properties(""),-1)
	Set prop = $Order(unordered(""))
	While prop '= "" {
		Set properties($Increment(max)) = prop
		Set prop = $Order(unordered(prop))
	}
	b ;1
	s Idx=""
	for {
		Set Idx = $Order(properties(Idx))
		q:(Idx="")
		Set prop = properties(Idx)
		q:(prop="")
		
		$$$comMemberKeyGetLvar(dt, %class, $$$cCLASSproperty, prop,$$$cPROPtype)
		Set classtype = $$$getClassType(dt)
		;w !, prop_"  classtype = "_classtype
		Set spec = $$$PROPPARAM($$$gMGINFO,%class,prop,"POPSPEC")
		;w !, prop_"  spec = "_spec
			#; Is there a property parameter POPSPEC? If so, process this and discard any class POPSPEC info that might be around.
		 	#; typecategory is set based on collection because collections do not behave nicely. The typecategory for collections
		 	#; is based on the collection class, not the defined type class.
		// 根据属性定义， 区分类型分类
		// 简单数据类型: 文字类型 Literal
		// 持久化类类型： persistent, reference
		/// 流类型： stream
		///  serial
		/// RegisteredObject 子类: DTO
		Set typecategory = $Case(classtype,$$$cCLASSCLASSTYPEDATATYPE:"literal",$$$cCLASSCLASSTYPEPERSISTENT:"reference",$$$cCLASSCLASSTYPESTREAM:"stream",$$$cCLASSCLASSTYPESERIAL:"serial","":"register",:"")
		
		$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
		
		$$$GENERATE("	; property = "_prop_";  type = "_dt_";  collection = "_collection)
		;w !,"	; property = "_prop_";  type = "_dt_";  collection = "_collection
		
		If collection = "" {
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	i $ISOBJECT(.."_prop_") {")
			}
			$$$GENERATE("	Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			;;##class(web.BDP.util.String).EvalJSON("""")
			If (typecategory = "literal") || (typecategory = "stream")  {
				;;$$$GENERATE("	Set jsonstr = jsonstr_"""_prop_":""""""_.."_prop_"_""""""""")
				$$$GENERATE("	Set jsonstr = jsonstr_"""""""_prop_""""":""""""_##class(web.BDP.util.String).EvalJSON(.."_prop_")_""""""""")

			}ElseIf typecategory = "reference" {
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				i (super["ELAbstract"){
					$$$GENERATE("		Set jsonstr = jsonstr_"""""""_prop_""""":""_.."_prop_".JsonS()")
				}else{
					$$$GENERATE("		Set jsonstr = jsonstr_"""""""_prop_""""":""_.."_prop_".GetObjectId()")
				}
			}Elseif typecategory = "serial"{
				
			}Else {
				;认为是%RegisteredObject的子类
				;cCLASSsuper
				;$$$defClassKeyGet(%class, $$$cCLASSsuper)
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				;w !,"类型："_dt_"    =  "_super
				i (super["ELAbstract"){
					$$$GENERATE("		Set jsonstr = jsonstr_"""""""_prop_""""":""_.."_prop_".JsonS()")
				}Else{
					$$$GENERATE("		Set jsonstr = jsonstr_"""""""_prop_""""":""")
				}
			}
			
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	}")
			}
			
		}Else {
			;处理集合属性,数组
			; 针对集合： 如果没有Insert或者SetAt数据, Json中暂时不写标签
			;Array, List
			;w !,"nihao"_prop_"    collection = "_collection_"   typecategory = "_typecategory
			$$$GENERATE("	s jsonliststr = """"")
			;Set set = "f elem=1:1:$r("_($Select('$Get(attrib(prop,"count")):"10",1:attrib(prop,"count"))+1)_") s cval="
			;If collection = $$$cPROPCOLLECTIONARRAY {
				;Set sett=" s key="_$Select($Get(attrib(prop,"key"))="":"##class(%PopulateUtils).String(4)",1:attrib(prop,"key"))_" d obj."_prop_$Select(typecategory="literal":".SetAt(",typecategory="reference":".SetObjectIdAt(",1:".SetObjectAt(")_"cval,key)"
				;目标： 取出key和value值
				$$$GENERATE("	s arykey = """"")
				$$$GENERATE("	for {")
				$$$GENERATE("		Set aryVal = .."_prop_".GetNext(.arykey)")
				$$$GENERATE("		q:(arykey="""")")
				
				s simcodestr = """""""""_"_"aryVal"_"_"""""""""
				If typecategory = "reference" {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}else{
						s simcodestr = "aryVal.%Id()"
					}
				}Elseif typecategory = "serial"{
					
				}Else {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}
				}
				i ((typecategory = "reference")||(typecategory="register")) {
					$$$GENERATE("		i $ISOBJECT(aryVal) {")
					$$$GENERATE("			Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					$$$GENERATE("			Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
					$$$GENERATE("		}")
				}else{
					$$$GENERATE("		Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					$$$GENERATE("		Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
				}
				$$$GENERATE("	}")
			;}ElseIf collection = $$$cPROPCOLLECTIONLIST {
			;}
			
			$$$GENERATE("	i jsonliststr '= """"{")
			$$$GENERATE("		Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			$$$GENERATE("		Set jsonstr = jsonstr_"""""""_prop_""""":""")
			$$$GENERATE("		Set jsonstr = jsonstr_""[""_jsonliststr_""]"" ")
			$$$GENERATE("	}")
			;Set:typecategory="reference" sett = " If (cval'=""""),(##class("_dt_").%ExistsId(cval))"_sett
		}
		
		
		;数据处理完毕
		
		b ;2
		#; If an override value generator was specified in POPSPEC, use it now!
		Set val = $Get(attrib(prop))
		If val = "" {
				#; If there is a value list, pick a value from it...
			Set vallist = $$$PROPPARAM($$$gMGINFO,%class,prop,"VALUELIST")
			If vallist '= "" {
				Set val = "##class(%PopulateUtils).ValueList("""_vallist_""")"
			}
				#; If the property's type class is SERIAL then check to see if it can be populated
				#; if it can then generate a call to dt.PopulateSerial
			ElseIf typecategory = "serial" {
				If $$$comMemberKeyGet(dt,$$$cCLASSmethod,"PopulateSerial",$$$cMETHrunnable) { Set val = "##class("_dt_").PopulateSerial()" }
			}
			ElseIf typecategory = "reference" {
					#; can't generate a reference if the target isn't persistent...
				If ($$$getClassType(dt) = $$$cCLASSCLASSTYPEPERSISTENT) {
					;If $Get(references(dt)) = "" {
					;	Set references=references+1,references(dt)="rss"_references
						;Do DefineLocalVariables^%occStorageUtil(.populate,initcode,"rss"_references)
						;Do QueueCodeLine^%occStorageUtil(.populate,buildsamples,"d ##class(%PopulateUtils).BuildReferenceSample("""_dt_""",."_references(dt)_")")
					;}
					;Set val = "##class(%PopulateUtils).ArrayElement(."_references(dt)_")"
				}
			}
			ElseIf typecategory = "literal" {
				Set val = ""
				Set dts = $$$ClassShortName(dt)
					#; If no value generator is assigned by the property name rule then proceed with the property type rule:
				If val = "" {
					;set minlen = $$$PROPPARAM($$$gMGINFO,%class,prop,"MINLEN"), maxlen = $$$PROPPARAM($$$gMGINFO,%class,prop,"MAXLEN")
				}
			}
		}
	}
	b ;3
	$$$GENERATE("	s jsonstr = ""{""_jsonstr_""}""")
	
	$$$GENERATE("	q jsonstr")
	
	QUIT $$$OK
}

/// 转换一个数组
ClassMethod MultiDataD(ByRef MList As %String) As %ObjectHandle [ CodeMode = generator ]
{
	s %code=0
	///$$$I()
	;s abstract=##class(web.DHCBL.DSS.ClassMetadata).IsClassAbstract(%class)
	s abstract = $$$defClassKeyGet(%class, $$$cCLASSabstract)
	q:(abstract) $$$OK
	;判读是否block
	i ('$$$defClassKeyGet(%class, $$$cCLASSprocedureblock)){
		;$$$GENERATE("	n (json)")
	}
	$$$GENERATE("	s mdobj = ##class("_%class_").%New()")
	
	;$$$GENERATE("	s tmpjsonstr = json")
	;创建了List数组后
	$$$GENERATE("	m Jlist = MList")
	$$$GENERATE("	q:($o(Jlist(""""))="""") mdobj")
	
	s prop = ""
	for {
		;s prop = ##class(web.DHCBL.DSS.ClassMetadata).NextPropertyName(%class, prop)
		s prop = $$$comMemberNext($$$NormalizeClassname(%class),$$$cCLASSproperty, prop)
		q:(prop="")
		s privateflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPprivate)
		s readonlyflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPreadonly)
		s calcuflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated)
		If ('privateflag) && ('readonlyflag) && ('calcuflag) {
			$$$comMemberKeyGetLvar(relationship,%class,$$$cCLASSproperty,prop,$$$cPROPrelationship)
			;w !,"relationship= "_relationship
			$$$comMemberKeyGetLvar(cardinality,%class,$$$cCLASSproperty,prop,$$$cPROPcardinality)
			;w !, "cardinality = "_cardinality
			If ('relationship) || ((cardinality '= $$$cPROPCARDINALITYCHILDREN) && (cardinality '= $$$cPROPCARDINALITYMANY)) {
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				If (collection = "") || (collection = $$$cPROPCOLLECTIONLIST) || (collection = $$$cPROPCOLLECTIONARRAY) {
						#; The following check quits if the initialexpression is set because
						#; default values always override randomly generated values. In the case of a collection,
						#; the initialexpression applies to the collection object - not to the elements.
					If (collection '= "") || ($$$IVARinitialexpression($$$gMGINFO,%class,prop) = """""") {
						Set order = $$$comMemberArrayGet(%class,$$$cCLASSproperty,prop,$$$cPROPparameter,"POPORDER")
						If (order) && ('$Data(properties(order))) { Set properties(order) = prop } Else { Set unordered(prop) = "" }
					}
				}
			}
		}
		;$$$GENERATE("	w """_prop_"""")
	}
	
	Set max = $Order(properties(""),-1)
	Set prop = $Order(unordered(""))
	While prop '= "" {
		Set properties($Increment(max)) = prop
		Set prop = $Order(unordered(prop))
	}
	
	s Idx=""
	for {
		Set Idx = $Order(properties(Idx))
		q:(Idx="")
		Set prop = properties(Idx)
		q:(prop="")
		
		$$$comMemberKeyGetLvar(dt, %class, $$$cCLASSproperty, prop,$$$cPROPtype)
		Set classtype = $$$getClassType(dt)
		;w !, prop_"  classtype = "_classtype
		Set spec = $$$PROPPARAM($$$gMGINFO,%class,prop,"POPSPEC")
		;w !, prop_"  spec = "_spec
			#; Is there a property parameter POPSPEC? If so, process this and discard any class POPSPEC info that might be around.
		 	#; typecategory is set based on collection because collections do not behave nicely. The typecategory for collections
		 	#; is based on the collection class, not the defined type class.
		// 根据属性定义， 区分类型分类
		// 简单数据类型: 文字类型 Literal
		// 持久化类类型： persistent, reference
		/// 流类型： stream
		///  serial
		/// RegisteredObject 子类: DTO
		Set typecategory = $Case(classtype,$$$cCLASSCLASSTYPEDATATYPE:"literal",$$$cCLASSCLASSTYPEPERSISTENT:"reference",$$$cCLASSCLASSTYPESTREAM:"stream",$$$cCLASSCLASSTYPESERIAL:"serial","":"register",:"")
		
		$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
		
		$$$GENERATE("	; property = "_prop_";  type = "_dt_";  collection = "_collection)
		;w !,"	; property = "_prop_";  type = "_dt_";  collection = "_collection
		
		If collection = "" {
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	i $ISOBJECT(mdobj."_prop_") {")
				//$$$GENERATE("		b	;;")
				
			}
			;$$$GENERATE("	Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			
			If (typecategory = "literal") || (typecategory = "stream")  {
				;$$$GENERATE("	Set jsonstr = jsonstr_"""_prop_":""""""_.."_prop_"_""""""""")
				$$$GENERATE("	Set mdobj."_prop_" = $g(Jlist("""_prop_""", 1))")
			}ElseIf typecategory = "reference" {
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				i (super["ELAbstract"){
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_".JsonS()")
					$$$GENERATE("		d mdobj."_prop_".MultiDataD("""", """", .)")
				}else{
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_"GetObjectId()")
					$$$GENERATE("		Set "_prop_"RowID = $g(Jlist("""_prop_""", 1))")
					;open object
					
				}
			}Elseif typecategory = "serial"{
				
			}Else {
				;认为是%RegisteredObject的子类
				;cCLASSsuper
				;$$$defClassKeyGet(%class, $$$cCLASSsuper)
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				;w !,"类型："_dt_"    =  "_super
				i (super["ELAbstract"){
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_".JsonS()")
				}Else{
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""")
					//$$$GENERATE("	Set jsonobj."_prop_" = $g(Jlist("""_prop_"""))")
				}
			}
			
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	}")
			}
			
		}Else {
			;处理集合属性,数组
			; 针对集合： 如果没有Insert或者SetAt数据, Json中暂时不写标签
			;Array, List
			;w !,"nihao"_prop_"    collection = "_collection_"   typecategory = "_typecategory
			;$$$GENERATE("	s jsonliststr = """"")
			;Set set = "f elem=1:1:$r("_($Select('$Get(attrib(prop,"count")):"10",1:attrib(prop,"count"))+1)_") s cval="
			;If collection = $$$cPROPCOLLECTIONARRAY {
				;Set sett=" s key="_$Select($Get(attrib(prop,"key"))="":"##class(%PopulateUtils).String(4)",1:attrib(prop,"key"))_" d obj."_prop_$Select(typecategory="literal":".SetAt(",typecategory="reference":".SetObjectIdAt(",1:".SetObjectAt(")_"cval,key)"
				;目标： 取出key和value值
				;$$$GENERATE("	s arykey = """"")
				;$$$GENERATE("	for {")
				;$$$GENERATE("		Set aryVal = .."_prop_".GetNext(.arykey)")
				;$$$GENERATE("		q:(arykey="""")")
				
				s simcodestr = """""""""_"_"aryVal"_"_"""""""""
				If typecategory = "reference" {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}else{
						s simcodestr = "aryVal.%Id()"
					}
				}Elseif typecategory = "serial"{
					
				}Else {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}
				}
				i ((typecategory = "reference")||(typecategory="register")) {
					;$$$GENERATE("		i $ISOBJECT(aryVal) {")
					;$$$GENERATE("			Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					;$$$GENERATE("			Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
					;$$$GENERATE("		}")
				}else{
					;$$$GENERATE("		Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					;$$$GENERATE("		Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
				}
				;$$$GENERATE("	}")
			;}ElseIf collection = $$$cPROPCOLLECTIONLIST {
			;}
			
			;$$$GENERATE("	i jsonliststr '= """"{")
			;$$$GENERATE("		Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""")
			;$$$GENERATE("		Set jsonstr = jsonstr_""[""_jsonliststr_""]"" ")
			;$$$GENERATE("	}")
			;Set:typecategory="reference" sett = " If (cval'=""""),(##class("_dt_").%ExistsId(cval))"_sett
		}
		
		
		;数据处理完毕
		
		
		#; If an override value generator was specified in POPSPEC, use it now!
	}
	
	$$$GENERATE("	QUIT mdobj")
	
	QUIT $$$OK
}

ClassMethod JsonD(json As %String) As %ObjectHandle [ CodeMode = generator ]
{
	s %code=0
	///$$$I()
	;s abstract=##class(web.DHCBL.DSS.ClassMetadata).IsClassAbstract(%class)
	s abstract = $$$defClassKeyGet(%class, $$$cCLASSabstract)
	q:(abstract) $$$OK
	;判读是否block
	i ('$$$defClassKeyGet(%class, $$$cCLASSprocedureblock)){
		;$$$GENERATE("	n (json)")
	}
	$$$GENERATE("	s jsonobj = ##class("_%class_").%New()")
	
	$$$GENERATE("	s tmpjsonstr = json")
	;创建了List数组后
	$$$GENERATE("	d ..ReadJsonToArray(.tmpjsonstr, """", .Jlist)")
	$$$GENERATE("	q:($o(Jlist(""""))="""") jsonobj")
	
	s prop = ""
	for {
		;s prop = ##class(web.DHCBL.DSS.ClassMetadata).NextPropertyName(%class, prop)
		s prop = $$$comMemberNext($$$NormalizeClassname(%class),$$$cCLASSproperty, prop)
		q:(prop="")
		s privateflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPprivate)
		s readonlyflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPreadonly)
		s calcuflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated)
		If ('privateflag) && ('readonlyflag) && ('calcuflag) {
			$$$comMemberKeyGetLvar(relationship,%class,$$$cCLASSproperty,prop,$$$cPROPrelationship)
			;w !,"relationship= "_relationship
			$$$comMemberKeyGetLvar(cardinality,%class,$$$cCLASSproperty,prop,$$$cPROPcardinality)
			;w !, "cardinality = "_cardinality
			If ('relationship) || ((cardinality '= $$$cPROPCARDINALITYCHILDREN) && (cardinality '= $$$cPROPCARDINALITYMANY)) {
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				If (collection = "") || (collection = $$$cPROPCOLLECTIONLIST) || (collection = $$$cPROPCOLLECTIONARRAY) {
						#; The following check quits if the initialexpression is set because
						#; default values always override randomly generated values. In the case of a collection,
						#; the initialexpression applies to the collection object - not to the elements.
					If (collection '= "") || ($$$IVARinitialexpression($$$gMGINFO,%class,prop) = """""") {
						Set order = $$$comMemberArrayGet(%class,$$$cCLASSproperty,prop,$$$cPROPparameter,"POPORDER")
						If (order) && ('$Data(properties(order))) { Set properties(order) = prop } Else { Set unordered(prop) = "" }
					}
				}
			}
		}
		;$$$GENERATE("	w """_prop_"""")
	}
	
	Set max = $Order(properties(""),-1)
	Set prop = $Order(unordered(""))
	While prop '= "" {
		Set properties($Increment(max)) = prop
		Set prop = $Order(unordered(prop))
	}
	
	s Idx=""
	for {
		Set Idx = $Order(properties(Idx))
		q:(Idx="")
		Set prop = properties(Idx)
		q:(prop="")
		
		$$$comMemberKeyGetLvar(dt, %class, $$$cCLASSproperty, prop,$$$cPROPtype)
		Set classtype = $$$getClassType(dt)
		;w !, prop_"  classtype = "_classtype
		Set spec = $$$PROPPARAM($$$gMGINFO,%class,prop,"POPSPEC")
		;w !, prop_"  spec = "_spec
			#; Is there a property parameter POPSPEC? If so, process this and discard any class POPSPEC info that might be around.
		 	#; typecategory is set based on collection because collections do not behave nicely. The typecategory for collections
		 	#; is based on the collection class, not the defined type class.
		// 根据属性定义， 区分类型分类
		// 简单数据类型: 文字类型 Literal
		// 持久化类类型： persistent, reference
		/// 流类型： stream
		///  serial
		/// RegisteredObject 子类: DTO
		Set typecategory = $Case(classtype,$$$cCLASSCLASSTYPEDATATYPE:"literal",$$$cCLASSCLASSTYPEPERSISTENT:"reference",$$$cCLASSCLASSTYPESTREAM:"stream",$$$cCLASSCLASSTYPESERIAL:"serial","":"register",:"")
		
		$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
		
		$$$GENERATE("	; property = "_prop_";  type = "_dt_";  collection = "_collection)
		;w !,"	; property = "_prop_";  type = "_dt_";  collection = "_collection
		
		If collection = "" {
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	i $ISOBJECT(jsonobj."_prop_") {")
				//$$$GENERATE("		b	;;")
				
			}
			;$$$GENERATE("	Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			
			If (typecategory = "literal") || (typecategory = "stream")  {
				;$$$GENERATE("	Set jsonstr = jsonstr_"""_prop_":""""""_.."_prop_"_""""""""")
				$$$GENERATE("	Set jsonobj."_prop_" = $g(Jlist("""_prop_"""))")
			}ElseIf typecategory = "reference" {
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				i (super["ELAbstract"){
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_".JsonS()")
					$$$GENERATE("		d jsonobj."_prop_".JsonD("""", """", .)")
				}else{
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_"GetObjectId()")
					$$$GENERATE("		Set "_prop_"RowID = $g(Jlist("""_prop_"""))")
					;open object
					
				}
			}Elseif typecategory = "serial"{
				
			}Else {
				;认为是%RegisteredObject的子类
				;cCLASSsuper
				;$$$defClassKeyGet(%class, $$$cCLASSsuper)
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				;w !,"类型："_dt_"    =  "_super
				i (super["ELAbstract"){
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_".JsonS()")
				}Else{
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""")
					//$$$GENERATE("	Set jsonobj."_prop_" = $g(Jlist("""_prop_"""))")
				}
			}
			
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	}")
			}
			
		}Else {
			;处理集合属性,数组
			; 针对集合： 如果没有Insert或者SetAt数据, Json中暂时不写标签
			;Array, List
			;w !,"nihao"_prop_"    collection = "_collection_"   typecategory = "_typecategory
			;$$$GENERATE("	s jsonliststr = """"")
			;Set set = "f elem=1:1:$r("_($Select('$Get(attrib(prop,"count")):"10",1:attrib(prop,"count"))+1)_") s cval="
			;If collection = $$$cPROPCOLLECTIONARRAY {
				;Set sett=" s key="_$Select($Get(attrib(prop,"key"))="":"##class(%PopulateUtils).String(4)",1:attrib(prop,"key"))_" d obj."_prop_$Select(typecategory="literal":".SetAt(",typecategory="reference":".SetObjectIdAt(",1:".SetObjectAt(")_"cval,key)"
				;目标： 取出key和value值
				;$$$GENERATE("	s arykey = """"")
				;$$$GENERATE("	for {")
				;$$$GENERATE("		Set aryVal = .."_prop_".GetNext(.arykey)")
				;$$$GENERATE("		q:(arykey="""")")
				
				s simcodestr = """""""""_"_"aryVal"_"_"""""""""
				If typecategory = "reference" {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}else{
						s simcodestr = "aryVal.%Id()"
					}
				}Elseif typecategory = "serial"{
					
				}Else {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}
				}
				i ((typecategory = "reference")||(typecategory="register")) {
					;$$$GENERATE("		i $ISOBJECT(aryVal) {")
					;$$$GENERATE("			Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					;$$$GENERATE("			Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
					;$$$GENERATE("		}")
				}else{
					;$$$GENERATE("		Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					;$$$GENERATE("		Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
				}
				;$$$GENERATE("	}")
			;}ElseIf collection = $$$cPROPCOLLECTIONLIST {
			;}
			
			;$$$GENERATE("	i jsonliststr '= """"{")
			;$$$GENERATE("		Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""")
			;$$$GENERATE("		Set jsonstr = jsonstr_""[""_jsonliststr_""]"" ")
			;$$$GENERATE("	}")
			;Set:typecategory="reference" sett = " If (cval'=""""),(##class("_dt_").%ExistsId(cval))"_sett
		}
		
		
		;数据处理完毕
		
		
		#; If an override value generator was specified in POPSPEC, use it now!
	}
	
	$$$GENERATE("	QUIT jsonobj")
	
	QUIT $$$OK
}

ClassMethod ReadJsonToArray(ByRef jsonstr As %String, xPath As %String, ByRef Jlist) As %String [ ProcedureBlock = 1 ]
{
	;一个元素一个元素的解决
	;使用左遍历
	
	i ($e(jsonstr,1)["}"){
		quit ""
	}
	
	i ($e(jsonstr,1)["]"){
		quit ""
	}
	;b	;;;DDDD
	;取值
	for {
AA
		q:(..JsonQuitFor(.jsonstr))
		;w "xPath   =   "_xPath,!
		if ($e(jsonstr, 1)="[") {
			;集合
			s jsonstr = $e(jsonstr,1+1,$l(jsonstr))
			d ..ReadJsonToArray(.jsonstr, xPath, .Jlist)
			goto AA
		}elseif($e(jsonstr, 1)="{"){
			s jsonstr = $e(jsonstr,1+1,$l(jsonstr))
			d ..ReadJsonToArray(.jsonstr, xPath, .Jlist)
			goto AA
		}elseif($e(jsonstr, 1)=","){
			s jsonstr = $e(jsonstr,1+1,$l(jsonstr))
			
			;判断是否有  {
			if ($e(jsonstr, 1)="[") {
				;集合
				s jsonstr = $e(jsonstr,1+1,$l(jsonstr))
				d ..ReadJsonToArray(.jsonstr, xPath, .Jlist)
				goto AA
			}elseif($e(jsonstr, 1)="{"){
				s jsonstr = $e(jsonstr,1+1,$l(jsonstr))
				d ..ReadJsonToArray(.jsonstr, xPath, .Jlist)
				goto AA
			}
		}
		
		q:(..JsonQuitFor(.jsonstr))
		q:(jsonstr="")
		
		s key = $p(jsonstr,":",1)
		
		s jsonstr = $e(jsonstr, $l(key)+1, $l(jsonstr))
		q:(..JsonQuitFor(.jsonstr))
		s jsonstr = $e(jsonstr,1,$l(jsonstr))
		
		if ($e(jsonstr, 1)="["){
			d ..ReadJsonToArray(.jsonstr, xPath, .Jlist)
			goto AA
		}elseif($e(jsonstr, 1)="{"){
			;b  ; 开始  {
			d ..ReadJsonToArray(.jsonstr, xPath, .Jlist)
			goto AA
		}elseif($e(jsonstr, 1)=":"){
			s jsonstr = $e(jsonstr, 2, $l(jsonstr))
			q:(..JsonQuitFor(.jsonstr))
			
			if ($e(jsonstr, 1)="["){
				s:xPath'="" xPath=xPath_"^"
				;s xPath = xPath_key
				s jsonstr = $e(jsonstr, 2, $l(jsonstr))
				d ..ReadJsonToArray(.jsonstr, xPath_key, .Jlist)
				goto AA
			}elseif($e(jsonstr, 1)="{"){
				s:xPath'="" xPath=xPath_"^"
				;s xPath = xPath_key
				s jsonstr = $e(jsonstr, 2, $l(jsonstr))
				d ..ReadJsonToArray(.jsonstr, xPath_key, .Jlist)
				goto AA
			}else{
				if ($e(jsonstr, 1)=","){
					s jsonstr = $e(jsonstr,1+1,$l(jsonstr))
				}
				s value = $p(jsonstr,",",1)
				s tmpjsonstr=""
				if (($e(value,$l(value))="}")||($e(value,$l(value))="]")){
					s tmpjsonstr = $e(jsonstr, $l(value)+1, $l(jsonstr))
				}
				;b	;tmpjson
				;判断一下是  对象结束，还是真正取值
				; 如何取键，  如何取值  CTTestArrayDR:[{CTTest1:{Name:""Test11111""}}],Date:""2012-03-22""
				; 把包含的值 再返给jsonstr
BB
				if ($e(value,$l(value))="}"){
					;结束一个对象
					s tmpjsonstr = $e(value, $l(value))_tmpjsonstr
					s value = $e(value, 1, $l(value)-1)
					;b	;;;}
					s jsonstr = $e(jsonstr, $l(value) + 1, $l(jsonstr))
				}elseif ($e(value,$l(value)-1, $l(value))="}]"){
					s tmpjsonstr = "}]"_tmpjsonstr
					s value = $e(value, 1, $l(value)-2)
					s jsonstr = $e(jsonstr, $l(value) + 1, $l(jsonstr))
					;b	;;;}]
				}elseif($e(value,$l(value))="]"){
					s tmpjsonstr = $e(value, $l(value))_tmpjsonstr
					s value = $e(value, 1, $l(value)-1)
					s jsonstr = $e(jsonstr, $l(value) + 1, $l(jsonstr))
					;b	;;;  ]
				}else{
					; 多去掉一个  ：
					s jsonstr = $e(jsonstr, $l(value) + 2, $l(jsonstr))
				}
				
				if (($e(value,$l(value), $l(value))="}")||($e(value,$l(value), $l(value))="]")){
					goto BB
				}
				if (tmpjsonstr'="") {
					;b	;;;
					s jsonstr = tmpjsonstr
				}
				;b	;;;;取值1
				;如果是字符类型
				i value[""""{
					s value = $e(value, 2, $l(value))
				}
				i $e(value,$l(value))[""""{
					s value = $e(value, 1, $l(value)-1)
				}
				
				if (xPath=""){
					s Jlist(key) = value
				}else{
					s Jlist(xPath_"^"_key)=value
				}
				;w "key  =   "_key _"    value=  "_value,!
				s xPath = ""
				;s $p(xPath,"^",$l(xPath,"^") - 1) = ""
				;b	;真正取值
				
			}
		}
		
	}
	
	QUIT ""
}

ClassMethod JsonQuitFor(ByRef jsonstr As %String) As %String
{
	; q:(..QuitFor(.jsonstr))
	;  结束一个循环
	if (($e(jsonstr, 1)="]")||($e(jsonstr, 1)="}")){
		s jsonstr = $e(jsonstr, 2, $l(jsonstr))
		Quit 1
	}
	
	q 0
}

ClassMethod ResultSetD(rs) As %ObjectHandle
{
}

/*
ClassMethod Open(oid As %ObjectIdentity, concurrency As %Integer = -1, ByRef sc As %Status = {$$$OK}) As %ObjectHandle [ CodeMode = generator, Final, ProcedureBlock = 1 ]
{
	#; NOTE: A lot of this code is also in %Reload, if you change %Open you should change this also
	s %code=0
	#; if not passed an initial state, quit with error
	$$$GENERATE("	If $$$oidPrimary($g(oid))="""" Set sc = $$$ERROR($$$NullOid) Quit $$$NULLOREF")
	$$$GENERATE("	If concurrency = -1 Set concurrency="_%parameter("DEFAULTCONCURRENCY"))
	$$$GENERATE("	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Set sc = $$$ERROR($$$ConcurrencyValueInvalid) Quit $$$NULLOREF")
	$$$GENERATE("	Set $Ztrap = ""Catch""")
	#; get class name
	$$$GENERATE("	New %this Set class=$$$oidClassName(oid)")
		#; if class name is not present in oid, we must call the class method %OnDetermineClass if it is present or use this
		#; class for the class name
	If $$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnDetermineClass",$$$cMETHrunnable) {
		$$$GENERATE("	If class="""" { Set sc=..%OnDetermineClass(oid,.class) Quit:$$$ISERR(sc) $$$NULLOREF Set oid=$$$oidInsertClassName(oid,class) } Else { Set class=$$$NormalizeClassname(class) }")
			#; See if we are the correct class. If not, dispatch polymorphically to correct %Delete()
		$$$GENERATE("	If """_%class_"""'=class Quit $zobjclassmethod(class,""%Open"",oid,concurrency,.sc)")
	} Else {
		$$$GENERATE("	If class="""" { Set class="""_%class_""",oid=$$$oidInsertClassName(oid,"""_%class_""") } Else { Set class=$$$NormalizeClassname(class) If """_%class_"""'=class { Quit $zobjclassmethod(class,""%Open"",oid,concurrency,.sc) } }")
	}
		#; if class is abstract, quit here, don't instantiate 
	i $$$comClassKeyGet(%class,$$$cCLASSabstract) {
		$$$GENERATE("	Set sc = $$$ERROR($$$AbstractClassNotInstantiable,"""_%class_""") Quit $$$NULLOREF")
		$$$GENERATE("Catch	Set $Ztrap=""""")
		$$$GENERATE("	If '$$$ISOK($Get(sc)) { Quit $$$NULLOREF }")
		$$$GENERATE("	Set sc = $Select($Extract($ZE,1,8)=""<PROTECT>"":$$$ERROR($$$PersistentProtect,$ZE),1:$$$ERROR($$$CacheError,$ZE))")
		$$$GENERATE("	Quit $$$NULLOREF")
		QUIT $$$OK
	}
		#; see if we should reuse an existing object
	$$$GENERATE("#endclassmethod")
	$$$GENERATE("	$$$ActiveOidSearch(oid,%this)")
	;$$$GENERATE("	If %this'=$$$NULLOREF { If concurrency>..%Concurrency { If (..%Concurrency<3) && (concurrency > 2) { Set reload = 1 } Else { Set reload = 0 } Set sc=..%UpgradeConcurrency(concurrency) If (reload) && ($$$ISOK(sc)) { Set sc=..%Reload() } If $$$ISERR(sc) { Quit $$$NULLOREF } } Else { Set sc = $$$OK } Quit ##this }")
		#; there are multiple copies of the next 3 lines of code in %New too.
	$$$GENERATE("	Set ##this=$$$CreateObject("""_%class_""")")
		#; We should be somewhat stable now, set the %Concurrency attribute...
	;$$$GENERATE("	Set ..%Concurrency=concurrency")
		#; initialize reference variables
	$$$DEFINECODEBLOCK("init","	Set $zobjval(,%1,0)=""""")
	Set ivar="" For  {
		Set ivar=$$$comMemberNext(%class,$$$cCLASSinstancevar,ivar) Quit:ivar=""
		If $$$comMemberKeyGet(%class,$$$cCLASSproperty,ivar,$$$cPROPmultidimensional) Continue
		$$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,ivar,$$$cPROPruntimetype) If $$$classIsDataType(runtimetype) Continue
		$$$comMemberKeyGetLvar(slot,%class,$$$cCLASSinstancevar,ivar,$$$cIVARrefslot)
		$$$ADDCODEBLOCK("init",$listbuild($piece(slot,",")))
	}
	$$$GENERATECODEBLOCKS()
	#; This code initializes all transient properties Multidimensional properties are not initialized
	#; for embedded objects, create new ones
	s prop="" f  s prop=$$$comMemberNext(%class,$$$cCLASSproperty,prop) q:prop=""  d:prop'="%Concurrency"
	. i '$$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPtransient) q
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPmultidimensional) q
	. i $$$comMemberDefined(%class,$$$cCLASSinstancevar,prop) $$$GENERATE("	Set i%"_prop_"="_$$$comMemberKeyGet(%class,$$$cCLASSinstancevar,prop,$$$cIVARinitialexpression))
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcollection)'="" q
	. i $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated) q
	. $$$comMemberKeyGetLvar(runtimetype,%class,$$$cCLASSproperty,prop,$$$cPROPruntimetype) If '$$$classIsSerial(runtimetype) q
	. $$$GENERATE("	If .."_prop_"NewObject()=$$$NULLOREF Quit $$$NULLOREF")
	#; load the object from disk - this is an instance method call!!!
	$$$GENERATE("	Set $$$objOID()=oid $$$ActiveOidInsert(oid,##this)")
	$$$GENERATE("	Set sc=..LoadData($$$oidPrimary(oid)) If $$$ISERR(sc) Quit $$$NULLOREF")
	#; set object as not modified
	$$$GENERATE("	$$$objModAllSet(,0)")
	#; find out if there is a %OnOpen method. If there is a %OnOpen, call it
	i $$$comMemberKeyGet(%class,$$$cCLASSmethod,"%OnOpen",$$$cMETHrunnable) $$$GENERATE("	Set sc=..%OnOpen() If $$$ISERR(sc) Quit $$$NULLOREF")
	$$$GENERATE("#classmethod")
	$$$GENERATE("	Quit ##this")
	$$$GENERATE("Catch	Set $ZTrap = """"")
	$$$GENERATE("	If '$$$ISOK($Get(sc)) { Quit $$$NULLOREF }")
	$$$GENERATE("	Set sc = $Select($Extract($ZE,1,9)=""<PROTECT>"":$$$ERROR($$$InsufficientPrivilegeObjectAccess,"""_%class_"::%Open"_"""),1:$$$ERROR($$$CacheError,$ZE))")
	$$$GENERATE("	Quit $$$NULLOREF")
	QUIT $$$OK
}

/// 加载历史数据
Method LoadData(ID As %String, date As %Date) As %Status [ CodeMode = generator, Private, ProcedureBlock = 1 ]
{
	;PersistentClassName
	s pclass = $$$defMemberKeyGet(%class,$$$cCLASSparameter,"PersistentClassName",$$$cPARAMdefault)
	
	$$$GENERATE("	s jsonobj = ##class("_%class_").%New()")
	
	$$$GENERATE("	s tmpjsonstr = json")
	;创建了List数组后
	$$$GENERATE("	d ..ReadJsonToArray(.tmpjsonstr, """", .Jlist)")
	$$$GENERATE("	q:($o(Jlist(""""))="""") jsonobj")
	
	s prop = ""
	for {
		;s prop = ##class(web.DHCBL.DSS.ClassMetadata).NextPropertyName(%class, prop)
		s prop = $$$comMemberNext($$$NormalizeClassname(%class),$$$cCLASSproperty, prop)
		q:(prop="")
		s privateflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPprivate)
		s readonlyflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPreadonly)
		s calcuflag = $$$comMemberKeyGet(%class,$$$cCLASSproperty,prop,$$$cPROPcalculated)
		If ('privateflag) && ('readonlyflag) && ('calcuflag) {
			$$$comMemberKeyGetLvar(relationship,%class,$$$cCLASSproperty,prop,$$$cPROPrelationship)
			;w !,"relationship= "_relationship
			$$$comMemberKeyGetLvar(cardinality,%class,$$$cCLASSproperty,prop,$$$cPROPcardinality)
			;w !, "cardinality = "_cardinality
			If ('relationship) || ((cardinality '= $$$cPROPCARDINALITYCHILDREN) && (cardinality '= $$$cPROPCARDINALITYMANY)) {
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
				If (collection = "") || (collection = $$$cPROPCOLLECTIONLIST) || (collection = $$$cPROPCOLLECTIONARRAY) {
						#; The following check quits if the initialexpression is set because
						#; default values always override randomly generated values. In the case of a collection,
						#; the initialexpression applies to the collection object - not to the elements.
					If (collection '= "") || ($$$IVARinitialexpression($$$gMGINFO,%class,prop) = """""") {
						Set order = $$$comMemberArrayGet(%class,$$$cCLASSproperty,prop,$$$cPROPparameter,"POPORDER")
						If (order) && ('$Data(properties(order))) { Set properties(order) = prop } Else { Set unordered(prop) = "" }
					}
				}
			}
		}
	}
	
	Set max = $Order(properties(""),-1)
	Set prop = $Order(unordered(""))
	While prop '= "" {
		Set properties($Increment(max)) = prop
		Set prop = $Order(unordered(prop))
	}
	
	s Idx=""
	for {
		Set Idx = $Order(properties(Idx))
		q:(Idx="")
		Set prop = properties(Idx)
		q:(prop="")
		
		$$$comMemberKeyGetLvar(dt, %class, $$$cCLASSproperty, prop,$$$cPROPtype)
		Set classtype = $$$getClassType(dt)
		;w !, prop_"  classtype = "_classtype
		Set spec = $$$PROPPARAM($$$gMGINFO,%class,prop,"POPSPEC")
		;w !, prop_"  spec = "_spec
			#; Is there a property parameter POPSPEC? If so, process this and discard any class POPSPEC info that might be around.
		 	#; typecategory is set based on collection because collections do not behave nicely. The typecategory for collections
		 	#; is based on the collection class, not the defined type class.
		// 根据属性定义， 区分类型分类
		// 简单数据类型: 文字类型 Literal
		// 持久化类类型： persistent, reference
		/// 流类型： stream
		///  serial
		/// RegisteredObject 子类: DTO
		Set typecategory = $Case(classtype,$$$cCLASSCLASSTYPEDATATYPE:"literal",$$$cCLASSCLASSTYPEPERSISTENT:"reference",$$$cCLASSCLASSTYPESTREAM:"stream",$$$cCLASSCLASSTYPESERIAL:"serial","":"register",:"")
		
		$$$comMemberKeyGetLvar(collection,%class,$$$cCLASSproperty,prop,$$$cPROPcollection)
		
		$$$GENERATE("	; property = "_prop_";  type = "_dt_";  collection = "_collection)
		;w !,"	; property = "_prop_";  type = "_dt_";  collection = "_collection
		
		If collection = "" {
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	i $ISOBJECT(jsonobj."_prop_") {")
				//$$$GENERATE("		b	;;")
				
			}
			;$$$GENERATE("	Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			
			If (typecategory = "literal") || (typecategory = "stream")  {
				;$$$GENERATE("	Set jsonstr = jsonstr_"""_prop_":""""""_.."_prop_"_""""""""")
				$$$GENERATE("	Set jsonobj."_prop_" = $g(Jlist("""_prop_"""))")
			}ElseIf typecategory = "reference" {
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				i (super["ELAbstract"){
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_".JsonS()")
					$$$GENERATE("		d jsonobj."_prop_".JsonD("""", """", .)")
				}else{
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_"GetObjectId()")
					$$$GENERATE("		Set "_prop_"RowID = $g(Jlist("""_prop_"""))")
					;open object
					
				}
			}Elseif typecategory = "serial"{
				
			}Else {
				;认为是%RegisteredObject的子类
				;cCLASSsuper
				;$$$defClassKeyGet(%class, $$$cCLASSsuper)
				s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
				;w !,"类型："_dt_"    =  "_super
				i (super["ELAbstract"){
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""_.."_prop_".JsonS()")
				}Else{
					;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""")
					//$$$GENERATE("	Set jsonobj."_prop_" = $g(Jlist("""_prop_"""))")
				}
			}
			
			i ((typecategory = "reference")||(typecategory="register")) {
				$$$GENERATE("	}")
			}
			
		}Else {
			;处理集合属性,数组
			; 针对集合： 如果没有Insert或者SetAt数据, Json中暂时不写标签
			;Array, List
			;w !,"nihao"_prop_"    collection = "_collection_"   typecategory = "_typecategory
			;$$$GENERATE("	s jsonliststr = """"")
			;Set set = "f elem=1:1:$r("_($Select('$Get(attrib(prop,"count")):"10",1:attrib(prop,"count"))+1)_") s cval="
			;If collection = $$$cPROPCOLLECTIONARRAY {
				;Set sett=" s key="_$Select($Get(attrib(prop,"key"))="":"##class(%PopulateUtils).String(4)",1:attrib(prop,"key"))_" d obj."_prop_$Select(typecategory="literal":".SetAt(",typecategory="reference":".SetObjectIdAt(",1:".SetObjectAt(")_"cval,key)"
				;目标： 取出key和value值
				;$$$GENERATE("	s arykey = """"")
				;$$$GENERATE("	for {")
				;$$$GENERATE("		Set aryVal = .."_prop_".GetNext(.arykey)")
				;$$$GENERATE("		q:(arykey="""")")
				
				s simcodestr = """""""""_"_"aryVal"_"_"""""""""
				If typecategory = "reference" {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}else{
						s simcodestr = "aryVal.%Id()"
					}
				}Elseif typecategory = "serial"{
					
				}Else {
					s super = $$$defClassKeyGet(dt, $$$cCLASSsuper)
					i (super["ELAbstract"){
						s simcodestr = "aryVal.JsonS()"
					}
				}
				i ((typecategory = "reference")||(typecategory="register")) {
					;$$$GENERATE("		i $ISOBJECT(aryVal) {")
					;$$$GENERATE("			Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					;$$$GENERATE("			Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
					;$$$GENERATE("		}")
				}else{
					;$$$GENERATE("		Set:(jsonliststr'="""") jsonliststr = jsonliststr_"",""")
					;$$$GENERATE("		Set jsonliststr = jsonliststr_""{""_arykey_"":""_"_simcodestr_"_""}""")
				}
				;$$$GENERATE("	}")
			;}ElseIf collection = $$$cPROPCOLLECTIONLIST {
			;}
			
			;$$$GENERATE("	i jsonliststr '= """"{")
			;$$$GENERATE("		Set:(jsonstr'="""") jsonstr = jsonstr_"",""")
			;$$$GENERATE("		Set jsonstr = jsonstr_"""_prop_":""")
			;$$$GENERATE("		Set jsonstr = jsonstr_""[""_jsonliststr_""]"" ")
			;$$$GENERATE("	}")
			;Set:typecategory="reference" sett = " If (cval'=""""),(##class("_dt_").%ExistsId(cval))"_sett
		}
		
	}
		;数据处理完毕
}*/
}
