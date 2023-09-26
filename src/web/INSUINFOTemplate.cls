Class web.INSUINFOTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: 詹明超
/// Description:解析对象的属性及备注
/// Input:RootID:临时global根节点名称。ClassName:对象类的名称
/// w ##class(web.INSUINFOTemplate).GetCol("test","web.INSUOEORDConInfo")
ClassMethod GetCol(RootID As %String, ClassName As %String = "") As %String
{
	s i=0
	q:ClassName="" i
	s tmpvn="##class("_ClassName_").%New()"
	Set objClass=$$XECUTEN^INSUFUN(tmpvn)
	s RtnStr=i
	q:$IsObject(objClass)=0 RtnStr
	s (RowId,OECode,OEDesc,OENote)=""
	if (objClass.%IsA("%Library.Persistent")||(objClass.%IsA("%RegisteredObject"))){
		s key=""
		f {
			s key=$$$defMemberNext(ClassName,$$$cCLASSproperty,key)
			q:key=""
			i $e(key,1)="%"{
				continue
			}
			s private=$$$comMemberKeyGet(ClassName,$$$cCLASSproperty,key,35)
			if private=1{
				continue
			}
			s (tmptype,subclass)=""
			s subclass=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,5)
			i (($$$defMemberKeyDefined(ClassName,$$$cCLASSproperty,key,27))||(subclass'["%")){
				s tmptype=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,27)
				;s subclass=$$$defMemberKeyGet(ClassName,$$$cCLASSproperty,key,5)
				;s subar=myDecodedArray.GetAt(key)
				s tmpsubclassobj=""
				s subkey=key
				s tmpvn="##class("_subclass_").%New()"
				Set tmpsubclassobj=$$XECUTEN^INSUFUN(tmpvn)
				s slkey=""
				f{
					s slkey=$$$defMemberNext(subclass,$$$cCLASSproperty,slkey)
					q:slkey=""
					i $e(slkey,1)="%"{
						continue
					}
					s private=$$$comMemberKeyGet(subclass,$$$cCLASSproperty,slkey,35)
					if private=1{
						continue
					}
					;以后可以用递归实现
					s subclass2=$$$defMemberKeyGet(subclass,$$$cCLASSproperty,slkey,5)
					i (($$$defMemberKeyDefined(subclass,$$$cCLASSproperty,slkey,27))||(subclass2'["%")) {
						s tmptype2=$$$defMemberKeyGet(subclass,$$$cCLASSproperty,slkey,27)
						s subclass2=$$$defMemberKeyGet(subclass,$$$cCLASSproperty,slkey,5)
						s tmpsubclassobj2=""
						s subkey2=slkey
						s tmpvn2="##class("_subclass_").%New()"
						Set tmpsubclassobj2=$$XECUTEN^INSUFUN(tmpvn2)
						s slkey2=""
						f{
							s slkey2=$$$defMemberNext(subclass2,$$$cCLASSproperty,slkey2)
							q:slkey2=""
							i $e(slkey2,1)="%"{
								continue
							}
							s private2=$$$comMemberKeyGet(subclass2,$$$cCLASSproperty,slkey2,35)
							if private2=1{
								continue
							}
							s OECode=key_":"_slkey_":"_slkey2
							s OEDesc=$g(^oddDEF(subclass2,"a",slkey2,"P","CONTENT"))
							s:OEDesc="" OEDesc=$g(^oddDEF(subclass2,"a",slkey2,4))
							d dicbuildc
						}
					}else{
						//set sc=writer.Object(tmpsubclassobj,slkey)
						s OECode=key_":"_slkey
						s OEDesc=$g(^oddDEF(subclass,"a",slkey,"P","CONTENT"))
						s:OEDesc="" OEDesc=$g(^oddDEF(subclass,"a",slkey,4))
						d dicbuildc
					}
				}
				//s:$IsObject(tmpsubclassobjlist) $PROPERTY(rtnobj,subkey)=tmpsubclassobjlist
			}else{
				//s $PROPERTY(rtnobj,key)=myDecodedArray.GetAt(key)
				//set sc=writer.Object(objClass,key)
				s OECode=key
				//cCLASSparameter
				;s OEDesc=$$$defMemberArrayGet(ClassName,$$$cCLASSproperty,key,$$$cCLASSparameter,"CONTENT")
				s OEDesc=$g(^oddDEF(ClassName,"a",key,"P","CONTENT"))
				s:OEDesc="" OEDesc=$g(^oddDEF(ClassName,"a",key,4))
			}
			d dicbuildc
		}
	}
	q i
dicbuildc
	i i=0 d
	.s ^CacheTemp("INSUINFOTitle",RootID)="RowId^OECode^OEDesc^OENote"
 	s ^CacheTemp("INSUINFO",RootID,i)=RowId_"^"_OECode_"^"_OEDesc_"^"_OENote
 	s i=i+1
}

/// Creator: 詹明超
/// Description:查询模板数据
/// Input:RootID:临时global根节点名称。inArgs:参数串(医保类型^rowid^查询字符^对照标志^业务类型)
/// w ##class(web.INSUINFOTemplate).GetConInfo("test","ZZB^^YZ^A^INSUOEUPLOAD^1")
ClassMethod GetConInfo(RootID As %String, InsuType As %String, qRowid As %String, qWords As %String, qConFlag As %String, BSYType As %String, QClase As %String, ParmHospital As %String) As %String
{
	s i=0,m=0
	;s InsuType=$p(inArgs,"^",1)
	q:InsuType="" i
	q:ParmHospital="" i
	;s qRowid=$p(inArgs,"^",2)
	;s qWords=$$ALPHAUP^SSUTIL4($p(inArgs,"^",3))
	;s ^TMPZMC("getConInfo")=ParmHospital_"^_"_qWords
	;s qConFlag=$p(inArgs,"^",4)
	;s BSYType=$p(inArgs,"^",5)
	;s QClase=$p(inArgs,"^",6)
	;s ParmHospital=+$p(inArgs,"^",7)
	;s CheckHosipitalGroup=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_UploadInfoCon1",ParmHospital)
	;s CheckHosipitalGroup=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_UploadInfoCon",ParmHospital)
	s sub=$i(^||OECONNODE)
	s (tplCode,tplDesc,OEORDCode,OEORDDesc,PropType)=""
	s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",24))
	i qRowid="" {
		s Rowid=""
		f  s Rowid=$o(@IdxGlobal@(Rowid)) q:Rowid=""  d
		.d dicbuild
	}else{
		s Rowid=qRowid
		d dicbuild
	}
	i i=0 d
	.s ^CacheTemp("INSUINFOTitle",RootID)="id^Rowid^tplCode^tplDesc^OEORDCode^OEORDDesc^PropType^InsuType^ConFlag^ParRowid^_parentId^state^BSYType^ExtStr1^ExtStr2^ExtStr3^ExtStr4^ExtStr5^HospitalDr"
	s:i=0 i=1
	q i
dicbuild
	s (tplCode,tplDesc,OEORDCode,OEORDDesc,PropType,children,parentId,state,ExtStr1,ExtStr2,ExtStr3,ExtStr4,ExtStr5)=""
	s ConFlag="N"
	i ##class(User.INSUUploadInfoCon).%ExistsId(Rowid) d
	.s obj=##class(User.INSUUploadInfoCon).%OpenId(Rowid)
	.;+2019-7-30 tangzf 医院授权判断 start
	.s TmpHospital=obj.Hospital
	.s TmpHospitalFlag=##class(web.DHCBILLINSUCloudCommon).CheckDataSession("User.INSUUploadInfoCon",Rowid,ParmHospital,TmpHospital)
	.q:TmpHospitalFlag'="Y"
	.;q:(TmpHospitalgrp'=CheckHosipitalGroup) ; 该院区无权查看
	.;+2019-7-30 tangzf 医院授权判断 end
	.s tplCode=obj.tplCode
	.s tplDesc=obj.tplDesc
	.s tplpy=##class(web.DHCINSUPort).GetCNCODE(tplDesc,4,"")
	.;s CheckHosipitalCon=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_UploadInfoCon",ParmHospital,TmpHospital)
	.;i CheckHosipitalCon=CheckHosipitalGroup d
	.s OEORDCode=obj.ConCode
	.s OEORDDesc=obj.ConDesc
	.s PropType=obj.PropType
	.s ParRowid=+obj.ParRowid	;父节点rowid
	.s ExtStr1=obj.ExtStr1
	.s ExtStr2=obj.ExtStr2
	.s ExtStr3=obj.ExtStr3
	.s ExtStr4=obj.ExtStr4
	.s ExtStr5=obj.ExtStr5
	.q:(obj.InsuType'=InsuType)&(InsuType'="")	//医保类型
	.q:(obj.BSYType'=BSYType)&(BSYType'="")	//业务类型
	.q:((tplpy'[$$ALPHAUP^SSUTIL4(qWords))&&(QClase="1")&&(qWords'=""))	;按拼音
	.q:(($$ALPHAUP^SSUTIL4(tplCode)'=$$ALPHAUP^SSUTIL4(qWords)))&&(QClase="2")&&(qWords'="")	;按代码
	.q:(($$ALPHAUP^SSUTIL4(tplDesc)'[$$ALPHAUP^SSUTIL4(qWords))&&(QClase="3")&&(qWords'=""))	;按名称
	.;q:PropType="S"
	.s:OEORDCode'="" ConFlag="Y"	//默认为已对照
	.q:(qConFlag'="")&(qConFlag'=ConFlag)&(qConFlag'="A")
	.i i=0 d
	..s ^CacheTemp("INSUINFOTitle",RootID)="id^Rowid^tplCode^tplDesc^OEORDCode^OEORDDesc^PropType^InsuType^ConFlag^ParRowid^_parentId^state^BSYType^ExtStr1^ExtStr2^ExtStr3^ExtStr4^ExtStr5^HospitalDr"
 	.;i PropType="F" d
 	..;s m=m+1
 	..;s msub=m
 	.s:$d(^||OECONNODE("NODEVAL",sub,ParRowid))=0 ^||OECONNODE("NODEVAL",sub,ParRowid)=""
 	.s:$d(^||OECONNODE("NODESUB",sub,ParRowid))=0 ^||OECONNODE("NODESUB",sub,ParRowid)=""
 	.s ^||OECONNODE("NODESUB",sub,ParRowid)=+^||OECONNODE("NODESUB",sub,ParRowid)+1
 	.s parentId=^||OECONNODE("NODEVAL",sub,ParRowid)
 	.s msub=parentId_^||OECONNODE("NODESUB",sub,ParRowid)
 	.s ^||OECONNODE("NODEVAL",sub,Rowid)=msub
 	.s tmpOEORDCode=""
 	.;s:$l(OEORDCode)>20 tmpOEORDCode=##class(%SYSTEM.Encryption).Base64Decode(OEORDCode)
 	.;s:tmpOEORDCode'="" OEORDCode=$Tr(tmpOEORDCode,"^","~")
 	.s ^CacheTemp("INSUINFO",RootID,i)=msub_"^"_Rowid_"^"_tplCode_"^"_tplDesc_"^"_OEORDCode_"^"_OEORDDesc_"^"_PropType_"^"_InsuType_"^"_ConFlag_"^"_ParRowid_"^"_parentId_"^"_state_"^"_BSYType_"^"_ExtStr1_"^"_ExtStr2_"^"_ExtStr3_"^"_ExtStr4_"^"_ExtStr5_"^"_obj.Hospital
 	.s i=i+1
 	q
}

/// Creator: 詹明超
/// Description:保存模板数据
/// Input:inArgs:数据串
/// w ##class(web.INSUINFOTemplate).SaveConInfo("101^ZZB^INSUOEUPLOAD^STRING^100^cseee^cseee^^^^^^^",2)
/// return 成功:大于零 ,失败:小于零^错误信息
ClassMethod SaveConInfo(inArgs As %String = "", ParmHospital As %String = "") As %String
{
	s:($g(%session)'="")&&(+ParmHospital=0) ParmHospital=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s rtnstr="-1"
	;s ^zmc("SaveConInfo334")=inArgs
	q:inArgs="" rtnstr
	s obj=""
	s rowid=$p(inArgs,"^",1)
	s insutpye=$p(inArgs,"^",2)
	s bsytype=$p(inArgs,"^",3)
	s tplCode=$p(inArgs,"^",6)
	s PropType=$$ALPHAUP^SSUTIL4($p(inArgs,"^",4))
	s ParRowid=+$p(inArgs,"^",5)
	s:PropType="" PropType="STRING"	;默认为string类型
	s Flag="Y"
	s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",25))
	s tRowid=""
	f  s tRowid=$O(@IdxGlobal@("IndexOfUnique",+ParmHospital,insutpye,bsytype,ParRowid,tplCode,tRowid))  q:(tRowid="")!(Flag="N")  d
	.q:tRowid=rowid
	.s Flag="N"
	q:Flag="N" "-3^存在相同节点记录"
	i rowid=""{
		s obj=##class(User.INSUUploadInfoCon).%New()
	}else{
		s obj=##class(User.INSUUploadInfoCon).%OpenId(rowid)
	}
	q:$IsObject(obj)=0 rtnstr	;非对象就退出
	s obj.InsuType=insutpye
	s obj.PropType=PropType
	s obj.BSYType=bsytype
	s obj.ParRowid=ParRowid
	s obj.tplCode=tplCode
	s obj.tplDesc=$p(inArgs,"^",7)
	s obj.ConCode=$p(inArgs,"^",8)
	s obj.ConDesc=$p(inArgs,"^",9)
	s obj.ExtStr1=$p(inArgs,"^",10)
	s obj.Hospital=ParmHospital
	s sc=obj.%Save()
	If $$$ISERR(sc) Quit "-2^数据非法请核对"
	s rowid=obj.%Id()
	i ParRowid>0 {
		s obj=##class(User.INSUUploadInfoCon).%OpenId(ParRowid)
		s tmpOEORDCode=""
		s:$p(inArgs,"^",8)'="" tmpOEORDCode=##class(%SYSTEM.Encryption).Base64Decode($p(inArgs,"^",8))
		s $p(tmpOEORDCode,":",$l(tmpOEORDCode,":"))=""
		s tmpOEORDCode=$e(tmpOEORDCode,0,$l(tmpOEORDCode)-1)
		s:tmpOEORDCode'="" tmpOEORDCode=##class(%SYSTEM.Encryption).Base64Encode(tmpOEORDCode)
		s:tmpOEORDCode="" obj.ConDesc=""
		s obj.ConCode=tmpOEORDCode
		s obj.Hospital=ParmHospital
		s obj.ExtStr1=""
		s sc=obj.%Save()
	}
	q rowid
}

/// Creator: 詹明超
/// Description:删除模板数据
/// Input:Rowid:表的rowid。ExtStr:参数串(删除对照标志C为删除对照^)
ClassMethod DelConInfo(Rowid As %String = "", ParmHospital As %String = "", ExtStr As %String = "") As %String
{
	s rtnstr="-1"
	q:Rowid="" rtnstr
	s:($g(%session)'="")&&(+ParmHospital=0) ParmHospital=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s delConflag=$p(ExtStr,"^",1)
	i ##class(User.INSUUploadInfoCon).%ExistsId(Rowid) d
	.s obj=##class(User.INSUUploadInfoCon).%OpenId(Rowid)
	.i delConflag="C" d		;说明只是删除对照
	..s obj.ConCode="",obj.ConDesc="",obj.ExtStr1=""
	..s rtnstr=obj.%Save()	
	.e  d
	..s InsuType=obj.InsuType
	..s bsyType=obj.BSYType
	..s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",25))
	..q:$d(@IdxGlobal@("IndexOfSub",+ParmHospital,InsuType,bsyType,Rowid))
	..s rtnstr=##class(User.INSUUploadInfoCon).%DeleteId(Rowid)	;删除数据
	q rtnstr
}

ClassMethod Importfromcsv(RootID As %String, args As %String, fileStream) As %String
{
	s $zt="importErr"
	;s ^TMPZMC("Import")=fileStream
	;q:('$IsObject(fileStream)) "-1^导入文件非法,"_'$IsObject(fileStream)
	;s filesize=fileStream.Size
	s i=0
	s sc=0,eol=0
	s rtnStr="1"
	s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",25))
	While ('fileStream.AtEnd) {
		s linstr=fileStream.ReadLine(,.sc,.eol)
		If $$$ISERR(sc) {
			s rtnStr="-1^"_$System.Status.DisplayError(sc)
			q
		}
		If eol {
			s i=i+1
			s linstr=$ZCONVERT($tr(linstr,$c(9),"^"),"I","GB18030") 
			s ino=$p(linstr,"^",1)	//序号
			s:ino="" rtnStr="-2^序号不能为空"
			q:ino=""
			i i>1 {
				s:$l(linstr,"^")<19 rtnStr="-3^数据非法"
				q:$l(linstr,"^")<19
				s iRowid=$p(linstr,"^",2)
				s iParRowid=$p(linstr,"^",10) //父节点rowid
				s iParino=$p(linstr,"^",11)	//父节点序号
				s insutpye=$p(linstr,"^",8)
				s bsytype=$p(linstr,"^",13)
				s tplCode=$p(linstr,"^",3)
				i $d(@IdxGlobal@("IDataKey",+$p(linstr,"^",19),insutpye,bsytype,tplCode)) d
				.s tmpRowid=$o(@IdxGlobal@("IDataKey",+$p(linstr,"^",19),insutpye,bsytype,tplCode,""))
				.s:tmpRowid'="" iRowid=tmpRowid
				s nobj=##class(User.INSUUploadInfoCon).%New()
				i ##class(User.INSUUploadInfoCon).%ExistsId(iRowid) d
				.s nobj=##class(User.INSUUploadInfoCon).%OpenId(iRowid)
				s nobj.InsuType=insutpye
				s nobj.PropType=$p(linstr,"^",7)
				s nobj.BSYType=bsytype
				i iParRowid'="" d
				.i '##class(User.INSUUploadInfoCon).%ExistsId(iParRowid) d
				..s iParRowid=""
				i ((iParino'="")&&(iParRowid="")) d
				.i $d(^||IMPCONNODE("NOID",iParino)) d
				..s iParRowid=$o(^||IMPCONNODE("NOID",iParino,""))
				s nobj.ParRowid=iParRowid
				s nobj.tplCode=tplCode
				s nobj.tplDesc=$p(linstr,"^",4)
				s nobj.ConCode=$p(linstr,"^",5)
				s nobj.ConDesc=$p(linstr,"^",6)
				s nobj.ExtStr1=$p(linstr,"^",14)
				s nobj.ExtStr2=$p(linstr,"^",15)
				s nobj.ExtStr3=$p(linstr,"^",16)
				s nobj.ExtStr4=$p(linstr,"^",17)
				s nobj.ExtStr5=$p(linstr,"^",18)
				s nobj.Hospital=$p(linstr,"^",19)
				s sc=nobj.%Save()
				s:$$$ISERR(sc) rtnStr="-4^"_$System.Status.DisplayError(sc)
				q:$$$ISERR(sc)
				s rowid=nobj.%Id()
			 	s:$d(^||IMPCONNODE("NOID",ino,rowid))=0 ^||IMPCONNODE("NOID",ino,rowid)=iRowid
			 	
			}
		}
	}
	q rtnStr
importErr
	s $zt=""
	q "-1^"_$ZE
}

/// just a test
ClassMethod ttttt(ExtStr As %String = "") As %String
{

	;q 0
	s rtnstr="-1"
	s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",24))
	s Rowid=""
	f  s Rowid=$o(@IdxGlobal@(Rowid)) q:Rowid=""  d
	.s obj=##class(User.INSUUploadInfoCon).%OpenId(Rowid)
	.;q:obj.ParRowid'=254
	.;s obj.BSYType="INSUOPTUPLOAD"
	.s obj.tplCode=$tr(obj.tplCode,$c(10),"")
	.s obj.tplCode=$tr(obj.tplCode,$c(13),"")
	.s obj.tplCode=$tr(obj.tplCode,$c(13,10),"")
	.;s obj.ConCode=##class(%SYSTEM.Encryption).Base64Encode(obj.ConCode)
	.;w obj.ConCode_"_"_##class(%SYSTEM.Encryption).Base64Encode(obj.ConCode),!
	.;tmpOEORDCode=##class(%SYSTEM.Encryption).Base64Decode(OEORDCode)
	.d obj.%Save()
	q 1
}

}
