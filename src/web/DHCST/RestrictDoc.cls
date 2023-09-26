Import sqluser

/// Description:限制科室用药
/// Creator:XiaoHe
/// CreateDate:2014-07-07
Class web.DHCST.RestrictDoc Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// creator:Xiaohe
/// date:2014-07-07
/// table:  DHC_ArcItemAut
/// input:  医嘱项id,"医生限制用药表id^关系^类型^操作^指向!医生限制用药表id^关系^类型^操作^指向"
/// output: 
/// others:
/// exec: w ##class(web.DHCST.RestrictDoc).Save("1086||1","1086||1||1^AND^KS^=^116!^AND^KS^=^56")
ClassMethod Save(Arcitm As %String, ListData As %String) As %Library.String
{
	n (Arcitm,ListData)
	q:Arcitm="" -1
	q:ListData="" -2
    s err=0
    s ret=0
    s lnum=$l(ListData,"!")
    f i=1:1:lnum  d
    .s RowStr=$p(ListData,"!",i)
    .s AutID=$p(RowStr,"^",1)
    .i AutID=""  d
    ..s ret=..Insert(Arcitm,RowStr)
    .e  d
    ..s ret=..Update(Arcitm,RowStr)
	.i $p(ret,"^",1)<0 s err=ret
	.q:+$p(ret,"^",1)<0
	
	q err
}

/// creator:XiaoHe
/// date:2014-07-07
/// table:  DHC_ArcItemAut
/// input:  Arcitm,"^关系^类型^操作^指向"
/// output: 
/// others:
/// exec: w ##class(web.DHCST.RestrictDoc).Insert("1087||1","^AND^KS^=^116")
ClassMethod Insert(Arcitm As %String, ListData As %String) As %Library.String
{
	n (ListData,Arcitm)
 	q:ListData="" -3
	q:Arcitm="" -4
	S subs=$P(Arcitm,"||",1)
    S vers=$P(Arcitm,"||",2)
    q:subs="" -5
    q:vers="" -6
    q:'$D(^ARCIM(subs,vers)) -7
	s childsub=$o(^ARCIM(subs,vers,"DHCAUT",""),-1)+1   ;child sub
    s autid=$p(ListData,"^",1)   //rowid
    s relation=$P(ListData,"^",2)	 //关系
    s type=$P(ListData,"^",3)	     //类型
    s Operate=$P(ListData,"^",4)	 //操作
    s Pointer=$P(ListData,"^",5)	 //Pointer
    i Pointer["ZC" s Pointer=$p(Pointer,"ZC",1)
 	s Err=0
  	&SQL(
  		SELECT * FROM DHC_ArcItemAut
  		WHERE AUT_ARCIMSubscript=:subs AND AUT_ARCIMVersion=:vers
		AND AUT_Relation=:relation AND AUT_Type=:type AND AUT_Operate=:Operate 
		AND AUT_Pointer=:Pointer
  	)
  	q:SQLCODE=0 "-1^该类型数据已维护"
  	tstart
 	&sql(insert into DHC_ArcItemAut(AUT_ARCIMSubscript,AUT_ARCIMVersion,AUT_Childsub,AUT_Relation,AUT_Type,AUT_Operate,AUT_Pointer)
    values (:subs,:vers,:childsub,:relation,:type,:Operate,:Pointer)  )
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_ArcItemAut","",SQLCODE_":"_%msg)
 	.s Err=-11
 	.
 	q:Err'=0 Err
 	s autid=$p(%ROWID,$c(1))
 	tcommit
 	
	q autid
}

/// creator:XiaoHe
/// date:2014-07-07
/// table:	DHC_ArcItemAut
/// input:  Arcitm,"医生限制用药表id^关系^类型^操作^指向"
/// output: 
/// others:
/// exec: w ##class(web.DHCST.RestrictDoc).Update("1086||1","1086||1||1^AND^KS^=^116")
ClassMethod Update(Arcitm As %String, ListData As %String) As %Library.String
{
	n (ListData,Arcitm)
 	q:ListData="" -3
	q:Arcitm="" -4
	S subs=$P(Arcitm,"||",1)
    S vers=$P(Arcitm,"||",2)
    q:subs="" -5
    q:vers="" -6
    q:'$D(^ARCIM(subs,vers)) -7
    s autid=$p(ListData,"^",1)   //rowid
    s relation=$P(ListData,"^",2)	 //关系
    s type=$P(ListData,"^",3)	     //类型
    s Operate=$P(ListData,"^",4)	 //操作
    s Pointer=$P(ListData,"^",5)	 //Pointer
    i Pointer["ZC" s Pointer=$p(Pointer,"ZC",1)
    s Err=0   
  	&SQL(
  		SELECT * FROM DHC_ArcItemAut
  		WHERE AUT_ARCIMSubscript=:subs AND AUT_ARCIMVersion=:vers
		AND AUT_Relation=:relation AND AUT_Type=:type AND AUT_Operate=:Operate 
		AND AUT_Pointer=:Pointer 
		AND AUT_RowID!=:autid
  	)
  	q:SQLCODE=0 "-1^该类型数据已维护"     	
 	tstart
 	&sql(Update DHC_ArcItemAut set AUT_Relation=:relation,AUT_Type=:type,AUT_Operate=:Operate,AUT_Pointer=:Pointer where AUT_RowID=:autid )
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_ArcItemAut",autid,SQLCODE_":"_%msg)
 	.s Err=-11
 	q:Err'=0 Err
 	
 	tcommit
 	q 0
}

/// creator:XiaoHe
/// date:2014-07-07
/// table:	DHC_ArcItemAut
/// input:  AUT_RowID
/// output: 
/// others:
/// exec: w ##class(web.DHCST.RestrictDoc).Delete("1087||1||1")
ClassMethod Delete(autid As %String) As %Library.String
{
	n (autid)
	q:autid="" ""
	s Sub=+autid
	s Ver=$P(autid,"||",2)
	s Child=$P(autid,"||",3)
	q:'$d(^ARCIM(Sub,Ver,"DHCAUT",Child)) 0
	s Err=0
	&sql(Delete from DHC_ArcItemAut where AUT_RowID=:autid) 
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_ArcItemAut",autid,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -3  
    ;
    q 0
}

/// Description:获取对应药品的限制科室用药信息
/// creator:XiaoHe
/// date:2014-07-07
/// table:	DHC_ArcItemAut
/// input:  AUT_RowID
/// output: 
/// others:w ##class(web.DHCST.RestrictDoc).GetRestrictDocInfo("858||1")
ClassMethod GetRestrictDocInfo(Arcitm) As %String
{
	n (Arcitm)
	S subs=$P(Arcitm,"||",1)
    S vers=$P(Arcitm,"||",2)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT AUT_RowID AS autid,AUT_Relation as relation,AUT_Type as type,AUT_Operate as Operate,AUT_Pointer as Pointer FROM DHC_ArcItemAut where AUT_ARCIMSubscript="_"'"_subs_"'"_" and AUT_ARCIMVersion="_"'"_vers_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    S Title="autid^relation^relationDesc^type^typeDesc^Operate^OperateDesc^Pointer^PointerDesc"
    While(result.Next())
    {
	    s autid = result.Data("autid")
	    s relation = result.Data("relation")
	    s relationDesc=""
	    i relation="AND" s relationDesc="并且"
	    i relation="OR" s relationDesc="或者"
	    s type = result.Data("type")
	    s typeDesc=""
	    i type="KS" s typeDesc="科室" 
	    i type="ZC" s typeDesc="职称"
	    i type="YS" s typeDesc="医生"  
	    i type="JB" s typeDesc="病人级别"  
	    s Operate = result.Data("Operate")
	    s OperateDesc=""
	    i Operate="=" s OperateDesc="等于"
	    e  i Operate="<>" s OperateDesc="不等于"
	    e  i Operate=">=" s OperateDesc="大于等于"
	    s Pointer = result.Data("Pointer")
	    s PointerDesc=..GetRDName(type,Pointer)
	    i type["ZC" s Pointer=Pointer_"ZC"
	    s tmp=autid_"^"_relation_"^"_relationDesc_"^"_type_"^"_typeDesc_"^"_Operate_"^"_OperateDesc_"^"_Pointer_"^"_PointerDesc
	    s count = count+1
	   	i count=1 d
	    .w "{rows:["
		.w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmp,Title)
		e  d
		.w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(tmp,Title)
    }
    i count>0 w "],results:"_count_"}"
	q ""
}

/// Description:根据类型分别取名称的ID
ClassMethod GetRDNameID(RDTyp, RDName)
{
 n (RDTyp,RDName)
 i RDTyp="KS" d
 .&sql( SELECT CTLOC_ROWID INTO :RDPoint FROM CT_LOC WHERE CTLOC_DESC=:RDName)
 else  If RDTyp="ZC" D
 .s RDPoint=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(RDName),""))
 else  If RDTyp="YS" D
 .s RDName=$P(RDName,"-")
 .&sql(select ssusr_rowid into :RDPoint From ss_user where ssusr_initials=:RDName)        
 .s RDPoint=$p($g(RDPoint),$c(1),1)
 else  If RDTyp="JB" D
 .s RDName=$P(RDName,"-")
 .&sql(SELECT CTEMF_Rowid into :RDPoint FROM CT_EmpFunc WHERE CTEMF_Desc=:RDName)        
 .s RDPoint=$p($g(RDPoint),$c(1),1)

 q RDPoint
}

/// Description:根据类型和名称ID取描述
ClassMethod GetRDName(RDTyp, RDPoint)
{
 n (RDTyp,RDPoint)
 q:RDPoint="" ""
 s RDName=""
 i RDTyp="KS" d
 .;s RDName=$P(^CTLOC(RDPoint),"^",2)
 .&sql( SELECT CTLOC_DESC INTO :RDName FROM CT_LOC WHERE CTLOC_ROWID=:RDPoint)
 else  If RDTyp="ZC" D
 .s RDName=$p($g(^CT("CPT",RDPoint)),"^",2)
 else  If RDTyp="YS" D
 .s RDPoint=$p($g(RDPoint),$c(1),1)
 .&sql(select SSUSR_Name into :RDName From ss_user where ssusr_rowid=:RDPoint)
 else  If RDTyp="JB" D
 .s RDPoint=$p($g(RDPoint),$c(1),1)
 .&sql(SELECT CTEMF_Desc into :RDName FROM CT_EmpFunc WHERE CTEMF_Rowid=:RDPoint)          
 q RDName
}

ClassMethod GetManfDescForResDoc(ManfId) As %String
{
	q:ManfId="" ""
	s ManfDesc=$P(^PHMNF(ManfId),"^",2)  ;描述
	i ManfDesc["-" s ManfDesc=$P(ManfDesc,"-",2)
	q ManfDesc
}

/// w ##class(web.DHCST.RestrictDoc).GetDesc("KS","")	
ClassMethod GetDesc(Type, PointerDesc) As %String
{
	q:Type="" ""
	i Type="KS" w ..GetTypeLoc("","",PointerDesc)
	i Type="YS" w ..GetLocUser("","",PointerDesc)
	i Type="ZC" w ..GetCarPrvTp(PointerDesc)
	i Type="JB" w ..GetCtEMF(PointerDesc)
	q ""
}

ClassMethod GetLocUser(LocDr, HospDr, PointerDesc) As %String
{
    n (LocDr,HospDr,PointerDesc)
    k ^TMPUSER("DHCST","OUSER")
 	s json = ##class(Code.JsonObj).%New()
    s UserDr="0",count=0

    f  s UserDr=$O(^SSU("SSUSR",UserDr)) q:UserDr=""  d
    .S DefLocDr=$P(^SSU("SSUSR",UserDr),"^",4)
    .Q:(LocDr'="")&(LocDr'=DefLocDr)
    .S LocHospDr=""
    .I DefLocDr'="" D
    ..I $D(^CTLOC(DefLocDr)) S LocHospDr=$P(^CTLOC(DefLocDr),"^",22)
    .Q:(HospDr'="")&(HospDr'=LocHospDr)
    .S UserCode=$P(^SSU("SSUSR",UserDr),"^",1)
    .S UserName=$P(^SSU("SSUSR",UserDr),"^",2)
    .S ^TMPUSER("DHCST","OUSER",UserCode,UserDr)=UserDr_"^"_UserName
    
    s Title="RowId^Description"
	w "{rows:["
	s Code="" f  s Code=$o(^TMPUSER("DHCST","OUSER",Code)) q:Code=""  d
	.s userdr="" f  s userdr=$o(^TMPUSER("DHCST","OUSER",Code,userdr)) q:userdr=""  d
	..s UserDr=userdr
	..s UserName=$P(^TMPUSER("DHCST","OUSER",Code,userdr),"^",2)
	..q:(PointerDesc'="")&(UserName'[PointerDesc)
	..s RowData=userdr_"^"_UserName
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	w "],results:"_1_"}"
    q ""
}

ClassMethod GetCarPrvTp(PointerDesc)
{
	s pid=..NewPid()
    k ^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTp",pid)
 	s json = ##class(Code.JsonObj).%New()
    s CptDr="0",i=0,cnt=0
    f  s CptDr=$o(^CT("CPT",CptDr)) q:CptDr=""  d
    .s CptCode=$p(^CT("CPT",CptDr),"^",1)
    .s CptName=$p(^CT("CPT",CptDr),"^",2)
    .s tmpCptInfo=CptDr_"^"_CptCode_"^"_CptName
    .q:$d(^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTpExist",pid,tmpCptInfo))
    .s ^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTpExist",pid,tmpCptInfo)=""
    .S i=i+1
    .S ^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTp",pid,i)=CptDr_"^"_CptCode_"^"_CptName    
    k ^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTpExist",pid)
    s Title="RowId^Description"
	w "{rows:["
	s num="" f  s num=$o(^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTp",pid,num)) q:num=""  d
	.s CptData=^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTp",pid,num)
	.s cptdr=$p(CptData,"^",1)
	.s cptname=$P(CptData,"^",3)
	.q:(PointerDesc'="")&(cptname'[PointerDesc)  
	.s RowData=cptdr_"ZC"_"^"_cptname
	.s cnt=cnt+1
	.i cnt=1 d
	..w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	.e  d
	..w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	w "],results:"_1_"}"
	k ^TMP("DHCST","web.DHCST.RestrictDoc","GetCarPrvTp",pid)
    q ""
}

/// W ##class(web.DHCST.RestrictDoc).GetTypeLoc("E","","hx")
ClassMethod GetTypeLoc(LocType, HospDr, PointerDesc)
{
    k ^TMPLOC("DHCST","OLOCT")
 	s json = ##class(Code.JsonObj).%New()
	N (LocType,HospDr,PointerDesc)
	S LocDr="",i=0
	s PointerDesc=$zcvt(PointerDesc,"U")
	s locType=""
	f  s locType=$O(^CTLOC(0,"LocType",locType)) q:locType=""  d
	.q:(LocType'="")&&(LocType'=locType)
	.F  S LocDr=$O(^CTLOC(0,"LocType",locType,LocDr)) Q:LocDr=""  D
	..S LocHospDr=$P(^CTLOC(LocDr),"^",22)
	..Q:(HospDr'="")&(HospDr'=LocHospDr)
	..S LocCode=$P(^CTLOC(LocDr),"^",1)
	..S LocDesc=$P(^CTLOC(LocDr),"^",2)
	..s LocName=$zcvt($p(^CTLOC(LocDr),"^",43),"U")
	..q:(PointerDesc'="")&&($zcvt(LocName,"U")'[PointerDesc)&&(LocName'[PointerDesc)
	..S i=i+1
	..S ^TMPLOC("DHCST","OLOCT",LocDesc)=LocDr_"^"_LocCode_"^"_LocDesc
	
    s Title="RowId^Description"
	w "{rows:["
	
	S nn=0
	I i>0 D
	.S Desc=""
	.F  S Desc=$O(^TMPLOC("DHCST","OLOCT",Desc)) Q:Desc=""  D
	..S locdr=$P(^TMPLOC("DHCST","OLOCT",Desc),"^",1)
	..S desc=$P(^TMPLOC("DHCST","OLOCT",Desc),"^",3) 
	..s RowData=locdr_"^"_desc
	..s nn=nn+1
	..i nn=1 d
	...w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	w "],results:"_1_"}"
    q ""
}

/// creator:yunhaibao
/// createdate:20160411
/// description:获取病人级别列表
/// w ##class(web.DHCST.RestrictDoc).GetCtEMF("")
ClassMethod GetCtEMF(PointerDesc)
{
	s PointerDesc="%"_PointerDesc_"%"
	s StrSql="SELECT CTEMF_Rowid RowId,CTEMF_Desc as Description FROM CT_EmpFunc WHERE CTEMF_Desc like "_"'"_PointerDesc_"'"_"and CTEMF_ActiveFlag='Y'"
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    q:err ""
    s count=0
    s Title="RowId^Description"
    While(result.Next())
    {
	    s rowid=result.Data("RowId")
	    s description=result.Data("Description")
	    s RowData=rowid_"^"_ description
	    s count=count+1
	    i count=1 d
	    .w "{rows:["
		.w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
		e  d
		.w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
    }
    i count>0 w "],results:"_count_"}"
	q ""
}

ClassMethod NewPid()
{
	q $i(^DHCST("web.DHCST.RestrictDoc"))
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// deccription:限制科室用药列表
/// table:      User.DHC_ArcItemAut
/// input:		strParams(医嘱项ID)
/// d ##class(%ResultSet).RunQuery("web.DHCST.RestrictDoc","GetRestrictDocInfo","533||1")
Query GetRestrictDocInfo(strParams) As websys.Query(ROWSPEC = "resDocId,resDocRelation,resDocRelationDesc,resDocType,resDocTypeDesc,resDocOperate,resDocOperateDesc,resDocPointer,resDocPointerDesc")
{
}

ClassMethod GetRestrictDocInfoExecute(ByRef qHandle As %Binary, strParams) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s arcItmId=$p(strParams,"^",1)
	q:arcItmId="" $$$OK
	s arcSub=$p(arcItmId,"||",1)
	s arcVer=$p(arcItmId,"||",2)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT AUT_RowID AS autid,AUT_Relation as relation,AUT_Type as type,AUT_Operate as Operate,AUT_Pointer as Pointer FROM DHC_ArcItemAut where AUT_ARCIMSubscript="_"'"_arcSub_"'"_" and AUT_ARCIMVersion="_"'"_arcVer_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    While(result.Next())
    {
	    s arcItmAutId = result.Data("autid")
	    s relation = result.Data("relation")
	    s relationDesc=""
	    i relation="AND" s relationDesc="并且"
	    i relation="OR" s relationDesc="或者"
	    s type = result.Data("type")
	    s typeDesc=""
	    i type="KS" s typeDesc="科室" 
	    i type="ZC" s typeDesc="职称"
	    i type="YS" s typeDesc="医生"  
	    i type="JB" s typeDesc="病人级别"  
	    s operate = result.Data("Operate")
	    s operateDesc=""
	    i operate="=" s operateDesc="等于"
	    e  i operate="<>" s operateDesc="不等于"
	    e  i operate=">=" s operateDesc="大于等于"
	    s pointer = result.Data("Pointer")
	    s pointerDesc=..GetRDName(type,pointer)
	    s pointer=pointer
	    d outputRow
    }
    d result.Close()
	Quit $$$OK
outputRow  
	s Data=$lb(arcItmAutId,relation,relationDesc,type,typeDesc,operate,operateDesc,pointer,pointerDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// deccription:限制科室用药YS-医生信息
/// input:      strParams(科室类型[E,D等]^院区ID)
/// d ##class(%ResultSet).RunQuery("web.DHCST.RestrictDoc","GetLocUser","")
Query GetLocUser(strParams = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetLocUserExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s locId=$p(strParams,"^",1)
	s hospId=$p(strParams,"^",2)
	s filterText=$zcvt($p(strParams,"^",3),"U")
    s userId="0",count=0
    f  s userId=$O(^SSU("SSUSR",userId)) q:userId=""  d
    .S defLocDr=$P(^SSU("SSUSR",userId),"^",4)
    .Q:(locId'="")&(locId'=defLocDr)
    .S locHospDr=""
    .I defLocDr'="" D
    ..I $D(^CTLOC(defLocDr)) S locHospDr=$P(^CTLOC(defLocDr),"^",22)
    .Q:(hospId'="")&(hospId'=locHospDr)
    .S userCode=$P(^SSU("SSUSR",userId),"^",1)
    .S userName=$P(^SSU("SSUSR",userId),"^",2)
    .s existFlag=""
    .i filterText'="" d
    ..s userNamePY=##class(web.DHCST.Common.AppCommon).GetCNCODE(userName)
    ..i userNamePY[filterText s existFlag=1 q
    ..i userName[filterText s existFlag=1 q
    ..i userCode[filterText s existFlag=1 q
    .q:(filterText'="")&&(existFlag="")
    .s UserArrData(userCode,userId)=userId_"^"_userName  
    s userCode=""	
    f  s userCode=$o(UserArrData(userCode)) q:userCode=""  d
	.s userId="" f  s userId=$o(UserArrData(userCode,userId)) q:userId=""  d
	..s userName=$p(UserArrData(userCode,userId),"^",2)
	..s Data=$lb(userId,userName)
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	k UserArrData
	Quit $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// deccription:限制科室用药KS-科室信息
/// input:      strParams(科室ID^院区ID)
/// d ##class(%ResultSet).RunQuery("web.DHCST.RestrictDoc","GetTypeLoc","E^^hx")
Query GetTypeLoc(strParams = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetTypeLocExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s locType=$p(strParams,"^",1)
	s hospId=$p(strParams,"^",2)
	s filterText=$zcvt($p(strParams,"^",3),"U")
	//q:locType="" $$$OK
	S locId=0,i=0
	i locType="" d
	.F  S locType=$O(^CTLOC(0,"LocType",locType)) Q:locType=""  D
	..s locId=0
	..d GetLocData
	e  d GetLocData
    s locDesc=""	
    f  s locDesc=$o(LocArrData(locDesc)) q:locDesc=""  d
	.s locId=$p(LocArrData(locDesc),"^",1)
	.s Data=$lb(locId,locDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	k LocArrData
	Quit $$$OK
GetLocData
	F  S locId=$O(^CTLOC(0,"LocType",locType,locId)) Q:locId=""  D
	.s locData=$g(^CTLOC(locId))
	.q:locData=""
	.S locHospId=$P(locData,"^",22)
	.Q:(hospId'="")&(hospId'=locHospId)
	.S locCode=$P(locData,"^",1)
	.S locDesc=$P(locData,"^",2)
	.q:locDesc=""
	.s existFlag=""
	.i filterText'="" d
	..s locConName=$P(locData,"^",43)
	..i $zcvt(locConName,"U")[filterText s existFlag=1 q
	..i $zcvt(locDesc,"U")[filterText s existFlag=1 q
	.e  s existFlag=1
	.q:existFlag'=1
    .s LocArrData(locDesc)=locId
	q
}

/// creator:    yunhaibao
/// createdate: 2017-06-30
/// deccription:限制科室用药ZC-职称信息
/// input:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.RestrictDoc","GetCarPrvTp","")
Query GetCarPrvTp(strParams = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetCarPrvTpExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s cptId="0"
    f  s cptId=$o(^CT("CPT",cptId)) q:cptId=""  d
    .s cptCode=$p(^CT("CPT",cptId),"^",1)
    .s cptName=$p(^CT("CPT",cptId),"^",2)
    .s tmpCptInfo=cptId_"^"_cptCode_"^"_cptName
    .s CptArrData(tmpCptInfo)=""
    .
    s cptInfo=""	
    f  s cptInfo=$o(CptArrData(cptInfo)) q:cptInfo=""  d
	.s cptId=$p(cptInfo,"^",1)
	.s cptDesc=$p(cptInfo,"^",3)
	.s Data=$lb(cptId,cptDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	k CptArrData
	Quit $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-06-30
/// deccription:病人密级JB-级别信息
/// input:      
/// d ##class(%ResultSet).RunQuery("web.DHCST.RestrictDoc","GetCtEMF","")
Query GetCtEMF(strParams = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod GetCtEMFExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    s result = ##class(%Library.ResultSet).%New()
	s strSql="SELECT CTEMF_Rowid RowId,CTEMF_Desc as Description FROM CT_EmpFunc WHERE CTEMF_ActiveFlag='Y'"
    d result.Prepare(strSql)
    d result.Execute()
    While(result.Next())
    {
        s RowId = result.Data("RowId") 
        s Description = result.Data("Description")
        continue:Description=""
		s Data=$lb(RowId,Description)
		s ^CacheTemp(repid,ind)=Data    
		s ind=ind+1
    }
    d result.Close()
	Quit $$$OK
}

}
