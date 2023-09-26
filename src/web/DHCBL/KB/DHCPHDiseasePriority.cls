Class web.DHCBL.KB.DHCPHDiseasePriority Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-12-10
/// Description：查询医嘱优先级表内容
/// Table：User.DHCPHDiseasePriority
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseasePriority","GetList","2","10","FORM","2")
Query GetList(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PDPRowId,PDPInstDr,PDPPriorityDR,PHEPCode,PHEPDesc,PHINSTMode")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s TypeDr=$o(^DHCPHPINL("0","Code","PRIORITY",0))
	s PDPInstDr=0
	for{
		s PDPInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDPInstDr))	q:PDPInstDr=""
		s PHINSTMode = $p($g(^DHCPHINSTRUC(PDPInstDr)),"^",14) //管制级别
		s PDPRowId = $o(^DHCPHDISPR("0","Inst",PDPInstDr,0)) continue:PDPRowId=""
		s PDPPriorityDR=$p($g(^DHCPHDISPR(PDPRowId)),"^",2)  //医嘱优先级Dr
		s:PDPPriorityDR'="" PHEPCode=$p($g(^DHCPHEP(PDPPriorityDR)),"^",1) //医嘱优先级代码
		s:PDPPriorityDR'="" PHEPDesc=$p($g(^DHCPHEP(PDPPriorityDR)),"^",2) //医嘱优先级名称
		
		d OutputRow
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PDPRowId,PDPInstDr,PDPPriorityDR,PHEPCode,PHEPDesc,PHINSTMode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate: 2015-12-10
/// Description：保存医嘱优先级
/// Table：User.DHCPHDiseasePriority    User.DHCPHInstructions
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHDiseasePriority).SaveData("1^C^Priority^0^5^21^Form^DRUG^Y^Y^true^^^^")
ClassMethod SaveData(priorityStr As %String) As %String
{
 if (priorityStr'=""){
	s result = ""
	s Prioritylen=$Length(priorityStr,"*")
	for i=1:1:Prioritylen
	{
		s Priority=$p(priorityStr,"*",i)
		s PDPPriorityDR=$p(Priority,"^",1) //字典id
		s Mode=$p(Priority,"^",2) //管制级别
		s Type=$p(Priority,"^",3) //知识库目录
		s OrderNum=$p(Priority,"^",4) //顺序
		s Gen=$p(Priority,"^",5) //通用名
		s Pointer=$p(Priority,"^",6) //指针
		s PointerType=$p(Priority,"^",7) //指针类型
		s Lib=$p(Priority,"^",8) //知识库标识
		s ActiveFlag=$p(Priority,"^",9) //是否可用
		s SysFlag=$p(Priority,"^",10) //是否系统标识
	
	;主索引表
	Ts
	s sobj=##class(User.DHCPHInstructions).%New()
	s sobj.PHINSTMode=Mode
	s TypeDr=$o(^DHCPHPINL(0,"Code",$ZCONVERT(Type,"U"),0))
	d:TypeDr'="" sobj.PHINSTTypeDrSetObjectId(TypeDr)
	s sobj.PHINSTOrderNum=OrderNum
	d:Gen'="" sobj.PHINSTGenDrSetObjectId(Gen)
	s sobj.PHINSTPointerDr=Pointer
	s sobj.PHINSTPointerType=PointerType
	s LibDr=$o(^DHCPHLIBL(0,"Code",$ZCONVERT(Lib,"U"),0))
	d:LibDr'="" sobj.PHINSTLibDrSetObjectId(LibDr)
	s sobj.PHINSTActiveFlag=ActiveFlag
	s sobj.PHINSTSysFlag=SysFlag
	;医嘱优先级主索引json
	s slogJson="{PHINSTMode:"_$C(34)_Mode_$C(34)_",PHINSTTypeDr:"_$C(34)_TypeDr_$C(34)_",PHINSTOrderNum:"_$C(34)_OrderNum_$C(34)_",PHINSTGenDr:"_$C(34)_Gen_$C(34)_",PHINSTPointerDr:"_$C(34)_Pointer_$C(34)_",PHINSTPointerType:"_$C(34)_PointerType_$C(34)_",PHINSTLibDr:"_$C(34)_LibDr_$C(34)_",PHINSTActiveFlag:"_$C(34)_ActiveFlag_$C(34)_",PHINSTSysFlag:"_$C(34)_SysFlag_$C(34)_"}"
	s scs=sobj.%Save()
	d sobj.%Close()
	If $$$ISOK(scs){ 
		s sid = sobj.%Id()
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHInstructions","User.DHCPHInstructions","医嘱优先级主索引",sid,Mode,"A",slogJson)	
	}
	else{
		s result = "{success:'false',info:'"_$zconvert(scs,"O","JS")_"_'}"    //返回错误信息
	}
	
	;医嘱优先级表
	s obj=##class(User.DHCPHDiseasePriority).%New()
	d:PDPPriorityDR'="" obj.PDPPriorityDRSetObjectId(PDPPriorityDR)
	d:sid'="" obj.PDPInstDrSetObjectId(sid)
	;医嘱优先级json
	s logJson="{PDPPriorityDR:"_$c(34)_PDPPriorityDR_$C(34)_",PDPInstDr:"_$C(34)_sid_$C(34)_"}"
	
	s sc=obj.%Save()
	d obj.%Close()	
	
	If $$$ISOK(sc){
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"    
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseasePriority","User.DHCPHDiseasePriority","医嘱优先级",id,PDPPriorityDR,"A",logJson)
	    //d:SSUSRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_PHDiseasePriority","User.DHCPHDiseasePriority","医嘱优先级",SSUSRRowId,SSUSRName,"U",logJson,blogJson)
	}
	else{
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"_'}"    //返回错误信息
	}			
   	if (result["true"){
		Tc
	}
	else{
		Trollback
		s result="{success:'false',info:'保存失败'}"
	}	
	}
	q result
 }
}

/// Creator:高姗姗
/// CreatDate:2015-12-10
/// Description:根据id删除
/// Table:User.DHCPHDiseasePriority
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHDiseasePriority).DeleteData("21")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	
		s pobj = ##class(User.DHCPHDiseasePriority).%OpenId(id)
		
		;主索引表
		Ts
		s seobj = ##class(web.Entity.KB.DHCPHInstructions).%New()
		s spobj = ##class(User.DHCPHInstructions).%OpenId(pobj.PDPInstDr.%Id())
		s seobj.PHINSTRowId=pobj.PDPInstDr.%Id()
		s seobj.PHINSTMode=spobj.PHINSTMode
		s:spobj.PHINSTTypeDr'="" seobj.PHINSTTypeDr = spobj.PHINSTTypeDr.%Id()
		s seobj.PHINSTOrderNum=spobj.PHINSTOrderNum
		s:spobj.PHINSTGenDr'="" seobj.PHINSTGenDr = spobj.PHINSTGenDr.%Id()
		s seobj.PHINSTPointerDr=spobj.PHINSTPointerDr
		s seobj.PHINSTPointerType=spobj.PHINSTPointerType
		s:spobj.PHINSTLibDr'="" seobj.PHINSTLibDr = spobj.PHINSTLibDr.%Id()
		s seobj.PHINSTActiveFlag=spobj.PHINSTActiveFlag
		s seobj.PHINSTSysFlag=spobj.PHINSTSysFlag
		
		s scs=##class(User.DHCPHInstructions).%DeleteId(pobj.PDPInstDr.%Id())
		if $$$ISOK(scs){
			Tc
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHInstructions","User.DHCPHInstructions","医嘱优先级主索引",seobj.PHINSTRowId,seobj.PHINSTMode,"D",seobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
		
		;医嘱优先级表
		Ts
		s eobj = ##class(web.Entity.KB.DHCPHDiseasePriority).%New()
		s eobj.PDPRowId=id
		s:pobj.PDPPriorityDR'="" eobj.PDPPriorityDR = pobj.PDPPriorityDR.%Id()
		s:pobj.PDPInstDr'="" eobj.PDPInstDr = pobj.PDPInstDr.%Id()

		s sc=##class(User.DHCPHDiseasePriority).%DeleteId(id)
		if $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseasePriority","User.DHCPHDiseasePriority","医嘱优先级",id,eobj.PDPPriorityDR,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}

	q result
}

/// Description：根据主索引的id获取医嘱优先级显示数据
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseasePriority).GetData("27")
ClassMethod GetData(InstId As %String) As %String
{
	s str=""
	s PDPRowId = $o(^DHCPHDISPR("0","Inst",InstId,0)) 
	s:PDPRowId'="" PDPPriorityDR=$p($g(^DHCPHDISPR(PDPRowId)),"^",2)  //医嘱优先级Dr
	s:PDPPriorityDR'="" PHEPDesc=$p($g(^DHCPHEP(PDPPriorityDR)),"^",2) //医嘱优先级名称 
	
	s str=str_PHEPDesc

	q str
}

/// Description：获取医嘱优先级中已选医嘱优先级的串
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseasePriority).GetPriorityDr("","10","Form","2")
ClassMethod GetPriorityDr(TypeDr, GenDr, PointerType, PointerDr) As %String
{
	s str=""
	s TypeDr=$o(^DHCPHPINL("0","Code","PRIORITY",0))
	s PDPInstDr=0
	for{
		s PDPInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GenDr,PointerType,PointerDr,PDPInstDr))	q:PDPInstDr=""
		s PDPRowId = $o(^DHCPHDISPR("0","Inst",PDPInstDr,0)) continue:PDPRowId=""
		s PDPPriorityDR=$p($g(^DHCPHDISPR(PDPRowId)),"^",2)  //医嘱优先级Dr
		s:PDPPriorityDR'="" PHEPCode=$p($g(^DHCPHEP(PDPPriorityDR)),"^",1) //医嘱优先级代码
		s str="<"_PHEPCode_">^"_str
	}
	q str
}

/// Creator:高姗姗
/// CreatDate: 2015-1-22
/// Description：修改保存级别
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.DHCPHDiseasePriority).SaveCoeff("8^9^LAB")
ClassMethod SaveMode(id As %String, mode As %String) As %String
{
	s result = ""	
	
	s $p(^DHCPHINSTRUC(id),"^",14)=mode     //级别
	
	s result = "{success:'true',info:'修改成功'}"  
	q result
}

}
