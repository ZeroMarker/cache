/// Creator:高姗姗
/// CreatDate:2019-07-23
/// Description：结构化诊断子表-维护诊断属性及属性内容
/// Table：User.SDSDiagnosProperty
Class web.DHCBL.MKB.SDSDiagnosProperty Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2019-03-01
/// Description：保存结构化诊断属性及属性内容信息
/// Table：User.SDSDiagnosProperty
/// Input：勾选属性值串 例：70161:S16894*16895,5002:10814*10815,4998:10670*10672
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosProperty).SaveData("1252","4998:10671*10738*10744")
ClassMethod SaveData(parref As %String, info As %String) As %String
{
 s resultChild=""
 s result=""
 if (info=""){ //取消勾选,清空子表
 	s rowid=""
	for { 
		s rowid=$o(^User.SDSDiagnosD(parref,"ChildProperty",rowid)) q:rowid=""
		s PropertyDR=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),2)
		s ProDetail=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),3)
		s res=..DelProperty(parref,PropertyDR,ProDetail)
	 	if (res["false"){
			s result=result_"^false"
		}else{
			s result=result_"^true"	
		}
	}
 }
 else{
	  ///生成临时global，辨别新传入的字符串是新增或删除
	 k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref)
	 s rowid=""
	 for {
	 	s rowid=$o(^User.SDSDiagnosD(parref,"ChildProperty",rowid)) q:rowid=""
	 	s SDSPropertyDR=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),2)
	 	s SDSProDetail=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),3)
	 	s ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,SDSPropertyDR,SDSProDetail)=""
	 }
	 s proLen=$Length(info,",")
	 for i=1:1:proLen{
		s property=$p(info,",",i)
		s proid=$p(property,":",1)
		s detail=$p(property,":",2)
		if (detail["*"){ //多选
			s detailLen=$Length(detail,"*")
			for j=1:1:detailLen{
				s detailItm=$p(detail,"*",j)
				if (detailItm["S"){ //引用术语/单节点
					s detailid=$p(detailItm,"S",2)
					s flag="T"
					if ($d(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid))="1"){ 
						k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid)
					}else{//子表新增
						s res=..SaveProperty(parref,proid,detailid,flag)
						if (res["false"){
							s result=result_"^false"
						}else{
							s result=result_"^true"	
						}
					}
				}else{
					s detailid=detailItm
					s flag="D"
					if ($d(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid))){ 
						k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid)
					}else{//子表新增
						s res=..SaveProperty(parref,proid,detailid,flag)
						if (res["false"){
							s result=result_"^false"
						}else{
							s result=result_"^true"	
						}
					}
				}	
			}
		}else{ //单选
			if (detail["S"){ //引用术语/单节点
				s detailid=$p(detail,"S",2)
				s flag="T"
				if ($d(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid))){ 
					k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid)
				}else{//子表新增
					s res=..SaveProperty(parref,proid,detailid,flag)
					if (res["false"){
						s result=result_"^false"
					}else{
						s result=result_"^true"	
					}
				}
			}else{
				s detailid=detail
				s flag="D"	
				if ($d(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid))){ 
					k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,proid,detailid)
				}else{//子表新增
					s res=..SaveProperty(parref,proid,detailid,flag)
					if (res["false"){
						s result=result_"^false"
					}else{
						s result=result_"^true"	
					}
				}
			}
		}  	 
	 }
	 if ($d(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref))){ //子表删除
		 s delProid=""
		 for {
		 	s delProid=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,delProid)) q:delProid=""
		 	s delDetailid=""
		 	for {
			 	s delDetailid=$o(^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,delProid,delDetailid)) q:delDetailid=""
			 	s res=..DelProperty(parref,delProid,delDetailid)
			 	if (res["false"){
					s result=result_"^false"
				}else{
					k ^TMPDIAGNOSCHILD($zn,$j,"DiagnosChild",parref,delProid,delDetailid)
					s result=result_"^true"	
				}
			}
		 }
	 }
 }
 if (result["false"){
	 s resultChild = "{success:'false'}"
 }else{
	 s resultChild = "{success:'true'}"
 }
  q resultChild
}

/// Creator:高姗姗
/// CreatDate:2019-02-28
/// Description：保存结构化诊断属性及属性内容信息
/// Table：User.SDSDiagnosProperty
/// Input：父id 属性 属性内容 标识
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosProperty).SaveProperty("")
ClassMethod SaveProperty(parref As %String, proid As %String, detailid As %String, flag As %String) As %String
{
 s result=""

    Ts
    s obj=##class(User.SDSDiagnosProperty).%New(parref)
    d:parref'="" obj.ParRefDiagnosSetObjectId(parref)
    d obj.SDSPropertyDRSetObjectId(proid)
    s obj.SDSProDetail = detailid
    s obj.SDSFlag = flag
    
    s sc=obj.%Save()
    s id=obj.%Id()
    d obj.%Close()
    If $$$ISOK(sc) 
    {
	    //维护引用表
	   s:proid'="" resultRefProperty=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDSP",id,"P",proid)
	   if ((flag="D")&(detailid'="")){
		   s resultRefDetail=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDSP",id,"D",detailid)
		}
	   if ((flag="T")&(detailid'="")){
		   s resultRefTerm=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","SDSP",id,"T",detailid)
		}
	    
       Tc
       s result = "{success:'true'}"
    }
    else 
    {
      Trollback
      s result = "{success:'false'}"
    }
   q result
}

/// Creator:高姗姗
/// CreatDate:2019-03-01
/// Description：删除结构化诊断属性及属性内容信息
/// Table：User.SDSDiagnosProperty
/// Input：父id 属性 属性内容 标识
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosProperty).DelProperty("1252","4998","10749")
ClassMethod DelProperty(parref As %String, Proid As %String, Detailid As %String) As %String
{
 	s result=""
    s sub=$o(^User.SDSDiagnosPropertyI("ChildIndex",parref,Proid,Detailid,0))
    s id=parref_"||"_sub
    s sc=##class(User.SDSDiagnosProperty).%DeleteId(id)
    If $$$ISOK(sc) 
    {
	    //删除引用表
	    s resultDelRef=##class(web.DHCBL.MKB.MKBReference).DeleteViaOriginal("SDSP",id)
       s result = "{success:'true'}"
    }
    else 
    {
      s result = "{success:'false'}"
    }
   q result
}

/// Creator:高姗姗
/// CreatDate:2019-03-04
/// Description：获取关联icd等接口参数，通过结构化诊断子表数据获取
/// Table：User.SDSDiagnosProperty
/// Input：parref 结构化诊断id
/// Return：医为智能提示接口传参 诊断id-属性key:属性value1*属性value2,属性key:S属性value
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosProperty).GetParamStr("1003")
ClassMethod GetParamStr(parref) As %String
{
	s result=""
	s SDSTermDR=$LISTGET($G(^User.SDSDiagnosD(parref)),2) //术语id
	q:SDSTermDR="" ""
	s property=""
	for {
		s property=$o(^User.SDSDiagnosPropertyI("ChildIndex",parref,property)) q:property=""
		s detail=""
		s resItm=""
		for {
			s detail=$o(^User.SDSDiagnosPropertyI("ChildIndex",parref,property,detail)) q:detail=""
			s rowid=$o(^User.SDSDiagnosPropertyI("ChildIndex",parref,property,detail,0))
			s SDSFlag=$LISTGET($G(^User.SDSDiagnosD(parref,"ChildProperty",rowid)),4)
			if (SDSFlag="T"){ //术语
				if (resItm=""){
					s resItm="S"_detail
				}else{
					s resItm=resItm_"*S"_detail
				}
			}else{ //属性内容
				if (resItm=""){
					s resItm=detail
				}else{
					s resItm=resItm_"*"_detail
				}
			}
		}
		if (result=""){
			s result=property_":"_resItm
		}else{
			s result=result_","_property_":"_resItm	
		}
		
	}
	if (result=""){
		s result=SDSTermDR	
	}else{
		s result=SDSTermDR_"-"_result
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2019-09-26
/// Description：根据父id获取结构化诊断属性数量及属性内容数量
/// Table：User.SDSDiagnosProperty
/// Input：parref 结构化诊断id
/// Return：属性数量#第一个属性下内容数量^第二个属性下内容数量^……#id信息
/// Other: w ##class(web.DHCBL.MKB.SDSDiagnosProperty).GetPropertyNode("3")
ClassMethod GetPropertyNode(parref) As %String
{
	s result=""
	s retDetail=""
	s propertyinfo=""
	s propertyCount=0
	s property=""
	for {
		s property=$o(^User.SDSDiagnosPropertyI("ChildIndex",parref,property)) q:property=""
		s propertyCount=propertyCount+1
		s detail=""
		s detailinfo=""
		s detailCount=0
		for {
			s detail=$o(^User.SDSDiagnosPropertyI("ChildIndex",parref,property,detail)) q:detail=""
			s detailCount=detailCount+1
			if (detailinfo=""){
				s detailinfo=detail
			}else{
				s detailinfo=detailinfo_"*"_detail	
			}
		}
		if (retDetail=""){
			s retDetail=detailCount
		}else{
			s retDetail=retDetail_"^"_detailCount
		}
		if (propertyinfo=""){
			s propertyinfo=property_":"_detailinfo
		}else{
			s propertyinfo=propertyinfo_","_property_":"_detailinfo
		}
	}
	s result=propertyCount_"#"_retDetail_"#"_propertyinfo
	q result
}

}
