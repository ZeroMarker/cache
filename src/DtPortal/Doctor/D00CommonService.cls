/// DtPortal.Doctor.D00CommonService
/// 描述:Portal 医生公共方法类
/// 编写者：程鹏
/// 编写日期: 2018-11-07
Class DtPortal.Doctor.D00CommonService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 赵忠原
/// CreatDate： 2014-7-9
/// Description: 根据用户Code,取所属科室
/// Input：	UserCode : 用户Code
/// Return： 	LocStr：科室ID串（以"^"分割）
/// Debug：w ##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode("1772")
ClassMethod GetLocByUserCode(UserCode As %String) As %String
{
	n (UserCode)
	
	q:UserCode="" ""
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	q:UserId="" ""
	
	s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",UserId)),"^",4) //增加默认登陆位置
	
	s sub=0  //从0后面开始取
	s LocStr=""
	f  s sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub)) q:sub=""  d
	.s CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
	.i LocStr="" s LocStr=CTLocDr
	.s WardLocType=$P($g(^CTLOC(CTLocDr)),"^",13) 
	.q:WardLocType="W"   //过滤掉病区类型
	.;修改了有相同科室不同安全组取两次的问题  -----bmz
	.i (LocStr'="")&(("^"_LocStr_"^")'[("^"_CTLocDr_"^"))  d
	..s LocStr=LocStr_"^"_CTLocDr
	s OutLocStr="^"_LocStr_"^"
	s OutSSUSRDefaultDeptDR="^"_SSUSRDefaultDeptDR_"^"
	i (OutLocStr'[OutSSUSRDefaultDeptDR) s LocStr=LocStr_"^"_SSUSRDefaultDeptDR
	s LocStr=..UtilStr(LocStr,"^")  //update by shp
	q LocStr
}

/// creator     :shp
/// date        :20140821
/// description :将一个数据组相同数据只取一次
/// debug       :w ##class(DtPortal.Doctor.D00CommonService).UtilStr("11^12^2^313^1^25^3^61^21^3^1^2^3","^")
///             w ##class(DtPortal.Doctor.D00CommonService).UtilStr("1","^")
ClassMethod UtilStr(str, split) As %String
{
	s temp="" ,buffer="",flag=0
	s len=$length(str,split)
	i len=1 {
		s buffer=str
	}else {
		f i=1:1:len {
			s stri=$p(str,split,i)
			i temp'=stri {
				s temp=stri
				i buffer="" {
					s buffer=temp
				}else{
					s len1=$length(buffer,split)
					f j=1:1:len {
						s strj=$p(buffer,split,j)
						i temp=strj {
							set flag=1
						}
					}
					i flag=0 {
						s buffer=buffer_"^"_temp				
					}
					
				}
				s flag=0
			}
		}
	}
	
	quit buffer
}

/// Creator： 白明哲
/// CreatDate： 2014-7-29---2015-09-16修改按安全组过滤
/// Description: 根据用户Code,取所属科室名称
/// Input：	UserCode : 用户Code
/// Return： 	LocStr：科室ID串（以"^"分割）
/// Debug：w ##class(DtPortal.Doctor.D00CommonService).GetLocNameByUserCode("1772")
ClassMethod GetLocNameByUserCode(UserCode As %String) As DtPortal.OutPut
{
	n (UserCode)
	
	q:UserCode="" ""
	;s ^bmz("GetLocNameByUserCode")=UserCode
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	k ^||TMPportalD010001
	Set $ZT = "ErrSendMessage2"

	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	q:UserId="" ""
	//获取医生配置的安全组串
	set docGro=##Class(DtPortal.Configure.RoleGroup).getGroupStr("Doctor")
	set docGro="^"_docGro_"^"
	s sub=0  //从0后面开始取
	s LocStr=""
	s WardLocStr=""
	f  s sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub)) q:sub=""  d
	.s CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1)
	.s groupId=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2)
	.s groupIdStr="^"_groupId_"^"
	.s groupDesc=$p($g(^SSU("SSGRP",groupId)),"^",1)  //取安全组描述
	.q:groupDesc["门诊"
	.q:docGro'[groupIdStr
	.s CTLocDesc=$P(^CTLOC(CTLocDr),"^",2)
	.i CTLocDesc["-" s CTLocDesc=$p(CTLocDesc,"-",2)
	.s ^||TMPportalD010001("D000001","loc",2,CTLocDr)=CTLocDesc
	.;通过取出的科室，在取出关联的病区科室
	.s linkSub=0
	.f  s linkSub=$o(^CTLOC(CTLocDr,"LINK",linkSub)) q:linkSub=""  d
	..s WardLocId=^CTLOC(CTLocDr,"LINK",linkSub)
	..//取病区科室的类型，非护理单元科室和科室类型非W  退出
	..s WardLocDepDR=$P(^CTLOC(WardLocId),"^",19)
	..s WardLocType=$P(^CTLOC(WardLocId),"^",13)
	..q:(WardLocDepDR'=3)&&(WardLocType'="W")
	..s WardLocDesc=$P(^CTLOC(WardLocId),"^",2)
	..i WardLocDesc["-" s WardLocDesc=$p(WardLocDesc,"-",2)
    ..i WardLocStr="" s WardLocStr=WardLocDesc_"|"_WardLocId
    ..s ^||TMPportalD010001("D000001","ward",2,WardLocId)=WardLocDesc
 
	
	//取出默认登陆科室
	s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",UserId)),"^",4) //增加默认登陆位置
	//取出科室组类型CTLOC_Dep_DR（RBC_DepartmentGroup）,判断是否是 临床科室和执行科室
	s CTLOCDefaultType=$P(^CTLOC(SSUSRDefaultDeptDR),"^",13)   //科室类型   E、W
	s SSUSRDefaultGroup=$p($g(^SSU("SSUSR",UserId)),"^",5) //增加默认登陆位置的安全组
	s groupIdStr="^"_SSUSRDefaultGroup_"^"
	s SSGRPDesc=$p($g(^SSU("SSGRP",SSUSRDefaultGroup)),"^",1)  //取安全组描述
	if docGro[groupIdStr{ 
		s CTLocDesc=$P(^CTLOC(SSUSRDefaultDeptDR),"^",2)
		i CTLocDesc["-" s CTLocDesc=$p(CTLocDesc,"-",2)
    	s CTLOCDefault=CTLocDesc_"|"_SSUSRDefaultDeptDR_"|1"
    	s ^||TMPportalD010001("D000001","loc",1,SSUSRDefaultDeptDR)=CTLocDesc
    	s linkSub=0
		f  s linkSub=$o(^CTLOC(SSUSRDefaultDeptDR,"LINK",linkSub)) q:linkSub=""  d
		.s WardLocId=^CTLOC(SSUSRDefaultDeptDR,"LINK",linkSub)
		.//取病区科室的类型，非护理单元科室和科室类型非W  退出
		.s WardLocDepDR=$P(^CTLOC(WardLocId),"^",19)
		.s WardLocType=$P(^CTLOC(WardLocId),"^",13)
		.q:(WardLocDepDR'=3)&&(WardLocType'="W")
		.s WardLocDesc=$P(^CTLOC(WardLocId),"^",2)
		.i WardLocDesc["-" s WardLocDesc=$p(WardLocDesc,"-",2)
		.set ^||TMPportalD010001("D000001","ward",1,WardLocId)=WardLocDesc

	}
	
	set retStr="["
	set locType=""
	for
	{
		set locType=$o(^||TMPportalD010001("D000001",locType))
		quit:locType=""
		
		set moIndex=""
		for
		{
			set moIndex=$o(^||TMPportalD010001("D000001",locType,moIndex))
			quit:moIndex=""
			
			set ID=""
			for
			{
				set ID=$o(^||TMPportalD010001("D000001",locType,moIndex,ID))
				quit:ID=""
				
				continue:$d(^||TMPportalD010001("LocWardID",ID))
				set ^||TMPportalD010001("LocWardID",ID)=""
				set desc=^||TMPportalD010001("D000001",locType,moIndex,ID)
				set jsonObj = ##class(DtPortal.Common.JsonObject).%New()
				d jsonObj.Put("type",locType)
				d jsonObj.Put("id",ID)
				d jsonObj.Put("desc",desc)
				set:retStr'="[" retStr=retStr_","_jsonObj.Json()
				set:retStr="[" retStr=retStr_jsonObj.Json()
			}
		}
	}
	set retStr=retStr_"]"
	s ret.data=retStr
	
	Set ret.status = 1
	Set ret.errMSG = ""
	w !,ret.data
	b ;end
	k ^||TMPportalD010001	
	Quit ret
	
ErrSendMessage2
	k ^||TMPportalD010001
	Set ret.status = -91
	Set ret.errMSG = $ZE
	Set ret.data = ""
	b ;err
	Quit ret
}

// 根据用户、科室获取用户登录的安全组和院区ID

// w ##class(DtPortal.Doctor.D00CommonService).getUserGroupHosp("ys01",1)

ClassMethod getUserGroupHosp(userCode As %String = "", locID As %String = "")
{
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	set return=""
	if userCode="" Quit ""
	s UserID=""
	s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",userCode,0))
	if UserID="" Quit ""
	
	if locID="" Quit ""
   
	s objUser = ##class(User.SSUser).%OpenId(UserID)
	
	s DefaultLoc=objUser.SSUSRDefaultDeptDR.CTLOCDesc
	s DefaultLocID = objUser.SSUSRDefaultDeptDR.%Id()
	s DefaultGrp = $s($IsObject(objUser.SSUSRGroup):objUser.SSUSRGroup.SSGRPDesc,1:"")
	s DefaultGrpID = objUser.SSUSRGroup.%Id()
	s DefaultHospID = "",DefaultHosp=""
	s:objUser.SSUSRHospitalDR'="" DefaultHospID=objUser.SSUSRHospitalDR.%Id()
	s:DefaultHospID="" DefaultHospID=$p(^CTLOC(DefaultLocID),"^",22)
	s:DefaultHospID'="" DefaultHosp = $p(^CT("HOSP",DefaultHospID),"^",2)
	s:DefaultLoc["-" DefaultLoc=$p(DefaultLoc,"-",2)
	
	if ((DefaultLocID'="")&&(DefaultHospID'="")&&(DefaultGrpID'="")&&(DefaultLocID=locID)){
		q DefaultGrpID_"^"_DefaultHospID
	}
	
		
	s myCount = objUser.ChildSSUserOtherLogonLoc.Count()
	f myIdx=1:1:myCount{
		set DefaultLocID=""
		set DefaultGrpID=""
		s objUserLoc = objUser.ChildSSUserOtherLogonLoc.GetAt(myIdx)
		s DefaultLocID = objUserLoc.OTHLLCTLOCDR.%Id()
		s:objUserLoc.OTHLLCTLOCDR'="" DefaultLoc = objUserLoc.OTHLLCTLOCDR.CTLOCDesc
		s:objUserLoc.OTHLLUserGroupDR'="" DefaultGrpID = objUserLoc.OTHLLUserGroupDR.%Id()
		s DefaultGrp = $s($IsObject(objUserLoc.OTHLLUserGroupDR):objUserLoc.OTHLLUserGroupDR.SSGRPDesc, 1:"")
		
		set DefaultHospID="",DefaultHosp=""
		if objUserLoc.OTHLLHospitalDR'=""{
			set DefaultHospID = objUserLoc.OTHLLHospitalDR.%Id()	
		}
		set:DefaultHospID="" DefaultHospID=$p(^CTLOC(DefaultLocID),"^",22)
		s:DefaultHospID'="" DefaultHosp = $p(^CT("HOSP",DefaultHospID),"^",2)
		
		s objUserLoc=""
		s:DefaultLoc["-" DefaultLoc=$p(DefaultLoc,"-",2)
		i myIdx
		if ((DefaultLocID'="")&&(DefaultHospID'="")&&(DefaultGrpID'="")&&(DefaultLocID=locID)){
			set return=DefaultGrpID_"^"_DefaultHospID
			q
		}
	}
	q return
}

}
