/// 名称: 科室维护    
/// 描述: 科室维护，完成显示和更新功能
/// 编写者：基础数据平台组 、蔡昊哲
/// 编写日期: 2012-8-13
Class web.DHCBL.CT.CTLoc Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "CT_Loc";

/// Creator：蔡昊哲
/// CreatDate: 2013-5-7
/// Description：获取科室列表		update 2020-1-10 钟荣枫 增加科室多级分类列，并增加筛选
/// Table：User.CTLoc
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLoc","GetList","","","","")
Query GetList(rowid, code, desc, type, dep, communityid, hospid, cate, treetype, category, activeflag) As %Query(ROWSPEC = "CTLOCRowID,CTLOCCode,CTLOCDesc,CTLOCAddress,CTLOCFloor,CTLOCType,DEPDesc,CTLOCMedicalRecordActive,CTLOCIndex,HOSPDesc,CTLOCExecuteConfirmation,CTLOCContactName,CTLOCDateActiveFrom,CTLOCDateActiveTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTLOCCategoryDR,HospitalGroupDR,CTLOCDeptCode,CTLOCDomainCode,CTLOCLocation,CTLOCActiveFlag,CTLOCSeqNo,CTLOCPYCode,CTLOCWBCode,CTLOCMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, type, dep, communityid, hospid, cate, treetype, category, activeflag) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //s AuStr=""
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    
    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    
    s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
    s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
    
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)   
   	if (rowid'="") //根据rowid返回该条记录
    {
        s CTLOCRowID=rowid
        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
        
        s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室Code
        s CTLOCAddress=$g(^CTLOC(CTLOCRowID,"ADDR",1))  //地址
        s CTLOCFloor=$p($g(^CTLOC(CTLOCRowID)),"^",16)      //楼层    
        s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
        s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
        s:CTLOCDepDR'="" DEPDesc=$p($g(^RBC("DEP",CTLOCDepDR)),"^",2)  //科室部门组描述
        s CTLOCMedicalRecordActive=$p($g(^CTLOC(CTLOCRowID)),"^",27)    //在此科室病历可用
        s CTLOCIndex=$p($g(^CTLOC(CTLOCRowID)),"^",21)  //索引
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        s:CTLOCHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //医院描述
        s HospitalGroupDR=""
        s:CTLOCHospitalDR'="" HospitalGroupDR=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",41)	//所属医院组
        s:HospitalGroupDR="" HospitalGroupDR=CTLOCHospitalDR	//如果默认医院为空，则显示它本身
        
        s CTLOCExecuteConfirmation=$p($g(^CTLOC(CTLOCRowID)),"^",23)
        s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码  
        s CTLOCDateActiveFrom=$p($G(^CTLOC(CTLOCRowID)),"^",24) //开始日期
        s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //结束日期
        s:CTLOCDateActiveFrom'="" CTLOCDateActiveFrom=$zd(CTLOCDateActiveFrom,1) //转换日期格式
        s:CTLOCDateActiveTo'="" CTLOCDateActiveTo=$zd(CTLOCDateActiveTo,1) //转换日期格式
        
        //update2020-1-2 增加指向科室多层分类  钟荣枫
        s CTLOCCategoryDR=$p($g(^CTLOC(CTLOCRowID)),"^",88)    //指向科室多层分类
        s:CTLOCCategoryDR'="" CTLOCCategoryDR=$LISTGET($G(^User.BDPCTLOCCategoryD(CTLOCCategoryDR)),3)   //科室多层分类描述
        
		s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
		s:CTLOCDeptCode'="" CTLOCDeptCode=$LISTGET($G(^CT.BDP.CT.HOSDepartmentD(CTLOCDeptCode)),3)
		s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键
		s:CTLOCDomainCode'="" CTLOCDomainCode=$LISTGET($G(^CT.BDP.CT.HOSBusiDomainD(CTLOCDomainCode)),3)
		
		s CTLOCLocation=$p($g(^CTLOC(CTLOCRowID)),"^",91)	//物理位置
		s CTLOCActiveFlag=$p($g(^CTLOC(CTLOCRowID)),"^",14)	//是否有效(Y/N)
		s:CTLOCActiveFlag="" CTLOCActiveFlag="Y"
		s CTLOCSeqNo=$p($g(^CTLOC(CTLOCRowID)),"^",95)		//系统排序号
		s CTLOCPYCode=$p($g(^CTLOC(CTLOCRowID)),"^",99)		//拼音码
		s CTLOCWBCode=$p($g(^CTLOC(CTLOCRowID)),"^",100)		//五笔码
		s CTLOCMark=$p($g(^CTLOC(CTLOCRowID)),"^",101)		//备注
		
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Loc",CTLOCRowID)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
        d OutputRow
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U")
        //if ((treetype="CTLOCType")||(treetype="")) s type=category
        //if ((treetype="CTLOCDepDR")) s dep=category
        if ((treetype="CTLOCHospitalDR")) s hospid=category
        if ((treetype="CTLOCCategoryDR")) s cate=category		//category为节点的id
        //获取节点下的所有节点id
        s categorystr=##class(web.DHCBL.CT.BDPCTLOCCategory).GetChildOrderedIDStr(cate)
        s categorystr="^"_categorystr_"^"
        s CTLOCRowID=0
        for  
        {
            s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
            s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
            s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
            s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
            s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键
            s strRowId = "{ID:"_CTLOCRowID_"}"
            s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
            s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
            s strDeptCodeID = "{ID:"_CTLOCDeptCode_"}"
            s strDomainCodeID = "{ID:"_CTLOCDomainCode_"}"

            i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((DepartmentAuStr[strDeptCodeID)||(DepartmentAuFlag=1))&&((BusiDomainAuStr[strDomainCodeID)||(BusiDomainAuFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
                s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室Code
                s CTLOCAddress=$g(^CTLOC(CTLOCRowID,"ADDR",1))  //地址
                s CTLOCFloor=$p($g(^CTLOC(CTLOCRowID)),"^",16)      //楼层    
                s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
                s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
                s:CTLOCDepDR'="" DEPDesc=$p($g(^RBC("DEP",CTLOCDepDR)),"^",2)  //科室部门组描述
                s:CTLOCDepDR="" DEPDesc=""
                s CTLOCMedicalRecordActive=$p($g(^CTLOC(CTLOCRowID)),"^",27)    //在此科室病历可用
                s CTLOCIndex=$p($g(^CTLOC(CTLOCRowID)),"^",21)  //索引        
                s:CTLOCHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //医院描述
                s:CTLOCHospitalDR="" HOSPDesc=""
                s HospitalGroupDR=""
		        s:CTLOCHospitalDR'="" HospitalGroupDR=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",41)	//所属医院组
		        s:HospitalGroupDR="" HospitalGroupDR=CTLOCHospitalDR	//如果默认医院为空，则显示它本身
		        
                s CTLOCExecuteConfirmation=$p($g(^CTLOC(CTLOCRowID)),"^",23)
                s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
                s CTLOCDateActiveFrom=$p($g(^CTLOC(CTLOCRowID)),"^",24) //开始日期
                s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //结束日期 
                
                s CTLOCActiveFlag=$p($g(^CTLOC(CTLOCRowID)),"^",14)	//是否有效(Y/N)
				s:CTLOCActiveFlag="" CTLOCActiveFlag="Y"
                //根据有效/无效过滤数据  
				if (activeflag="Y")
				{
					//结束日期为空，或者结束日期在今天之后，且有效标志为Y的数据为有效数据
					if '(((CTLOCDateActiveTo="")||((CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo>=+$h)))&&(CTLOCActiveFlag="Y")) continue	
				}
				if (activeflag="N")
				{
					//结束日期不为空且结束日期在今天之前，或者有效标志为N的数据为无效数据
					if '(((CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h))||(CTLOCActiveFlag="N")) continue
				}
                s:CTLOCDateActiveFrom'="" CTLOCDateActiveFrom=$zd(CTLOCDateActiveFrom,1) //转换日期格式
                s:CTLOCDateActiveTo'="" CTLOCDateActiveTo=$zd(CTLOCDateActiveTo,1) //转换日期格式
                
                //update2020-1-2 增加指向科室多层分类  钟荣枫
                s CTLOCCategoryDR=$p($g(^CTLOC(CTLOCRowID)),"^",88)    //指向科室多层分类
                s CTLOCCategory=CTLOCCategoryDR
        		s:CTLOCCategoryDR'="" CTLOCCategoryDR=$LISTGET($G(^User.BDPCTLOCCategoryD(CTLOCCategoryDR)),3)   //科室多层分类描述
                
                
				
				s:CTLOCDeptCode'="" CTLOCDeptCode=$LISTGET($G(^CT.BDP.CT.HOSDepartmentD(CTLOCDeptCode)),3)
				
				s:CTLOCDomainCode'="" CTLOCDomainCode=$LISTGET($G(^CT.BDP.CT.HOSBusiDomainD(CTLOCDomainCode)),3)
				
				s CTLOCLocation=$p($g(^CTLOC(CTLOCRowID)),"^",91)	//物理位置
				
				
				s CTLOCSeqNo=$p($g(^CTLOC(CTLOCRowID)),"^",95)		//系统排序号
				s CTLOCPYCode=$p($g(^CTLOC(CTLOCRowID)),"^",99)		//拼音码
				s CTLOCWBCode=$p($g(^CTLOC(CTLOCRowID)),"^",100)		//五笔码
				s CTLOCMark=$p($g(^CTLOC(CTLOCRowID)),"^",101)		//备注
				
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Loc",CTLOCRowID)
                s BDPInternalCode =$p($g(resultStr),"^",1)       
                s BDPInternalDesc = $p($g(resultStr),"^",2)  
                s BDPHospNationalCode=$p($g(resultStr),"^",3)         
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                /*
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN=""
                s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
                */
               if (desc'="")
               {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Loc",CTLOCRowID,CTLOCDesc,desc)
               }
                else
               {
                    s AliasFlag= 1   
               }
                
                s HospitalDR = "<"_CTLOCHospitalDR_">"
                
                s CategoryFlag=0
                
                if (categorystr[("^"_CTLOCCategory_"^"))&&($l(categorystr)>2)
                {
	                s CategoryFlag=1
                }
                i ((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc))&((hospid="")||((hospid'="")&&(CTLOCHospitalDR=hospid)))&($zcvt(CTLOCCode,"U")[$ZCONVERT(code,"U"))&((CTLOCType=type)||(type=""))&((CTLOCDepDR=dep)||(dep=""))&((CTLOCCategory=cate)||(CategoryFlag=1)||(cate=""))
                /*($ZCONVERT(CTLOCDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc)||($ZCONVERT(CTLOCContactName,"U")[desc)*/
                {
                    if (communityid'=""){
                        if (HospitalDRs[HospitalDR) d OutputRow
                    }
                    else{
                        d OutputRow
                    }
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(CTLOCRowID,CTLOCCode,CTLOCDesc,CTLOCAddress,CTLOCFloor,CTLOCType,DEPDesc,CTLOCMedicalRecordActive,CTLOCIndex,HOSPDesc,CTLOCExecuteConfirmation,CTLOCContactName,CTLOCDateActiveFrom,CTLOCDateActiveTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,CTLOCCategoryDR,HospitalGroupDR,CTLOCDeptCode,CTLOCDomainCode,CTLOCLocation,CTLOCActiveFlag,CTLOCSeqNo,CTLOCPYCode,CTLOCWBCode,CTLOCMark)
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

/// Creator：陈莹
/// CreatDate: 2013-5-7
/// Description：提供科室下拉框列表查询
/// Table：User.CTLoc
/// Input：rowid, code, desc, query, type, communityid, hospid(医院id)
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLoc","GetDataForCmb1","","","","","","","")
Query GetDataForCmb1(rowid, code, desc, query, type, communityid, hospid) As %Query(ROWSPEC = "CTLOCRowID,CTLOCCode,CTLOCDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid, code, desc, query, type, communityid, hospid) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    
    s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
    s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
	
    
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s:query'="" query=$ZCONVERT(query,"U")
    s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetHospital(communityid)  
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTLOCRowID=rowid
        s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1) 
        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        if (CTLOCHospitalDR'="")&(AuHospStr'="off")
        {
            s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
            s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
            if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
            else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
        }
        d OutputRow1
    }
    else
    {
        s CTLOCRowID=0
        for  
        {
            s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
            
	            
            s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
            s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
            s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
            s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键
            
            s strRowId = "{ID:"_CTLOCRowID_"}"
            s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
            s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
            s strDeptCodeID = "{ID:"_CTLOCDeptCode_"}"
            s strDomainCodeID = "{ID:"_CTLOCDomainCode_"}"
            i (((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((DepartmentAuStr[strDeptCodeID)||(DepartmentAuFlag=1))&&((BusiDomainAuStr[strDomainCodeID)||(BusiDomainAuFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1))) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
	            s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)
                s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)     //用户名
                S CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)
                s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
                s CTLOCDateActiveFrom=$p($g(^CTLOC(CTLOCRowID)),"^",24)    //开始日期
                s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
                continue:(CTLOCDateActiveFrom'="")&&(CTLOCDateActiveFrom>+$h)
                continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                s CTLOCActiveFlag=$p($g(^CTLOC(CTLOCRowID)),"^",14)	//是否有效(Y/N)
                continue:CTLOCActiveFlag="N"
                if (CTLOCHospitalDR'="")&(AuHospStr'="off") 
                {
                    s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
                    s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
                    if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
                    else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
                }
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
                */
                if (desc'="")
               {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Loc",CTLOCRowID,CTLOCDesc,desc)
               }
                else
               {
                    s AliasFlag= 1   
               }
               
                //2022-04-24
				s queryFlag=0
				if (query'="")
				{
					if ($ZCONVERT(CTLOCDesc,"U")[query)||($ZCONVERT(CTLOCContactName,"U")[query)
					{
						s queryFlag=1
					}
				}
				else
				{
					s queryFlag=1
				}
               
                s HospitalDR = "<"_CTLOCHospitalDR_">"
                ///sunfengchao 修复 医院级联时不能检索的问题
                ///只有护士可以看到病区数据
                if ($ZCONVERT(CTLOCCode,"U")[code)&&((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc))&&(queryFlag=1)&&(((CTLOCType'="W")&(type'="N"))||(type="")||(type="N"))&&(((hospid="")||(((hospid'="")&&(CTLOCHospitalDR=hospid))))) 
                {
                    //i ((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc)&((hospid=""))||((hospid'="")&&(CTLOCHospitalDR=hospid)))&($ZCONVERT(CTLOCDesc,"U")[query)&(((CTLOCType'="W")&(type'="N"))||(type="")||(type="N"))
                     /*($ZCONVERT(CTLOCDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc)||($ZCONVERT(CTLOCContactName,"U")[desc)*/
             
                    
                    if (communityid'=""){
                        if (HospitalDRs[HospitalDR) d OutputRow1
                    }else{
                        d OutputRow1
                    }
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(CTLOCRowID,CTLOCCode,CTLOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：谷雪萍
/// CreatDate: 2015-6-23
/// 病区床位界面——所属科室下拉框 ，只显示访问类型位置界面病人类型为OutPatient的科室
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLoc","GetDataForCmb2","","")
Query GetDataForCmb2(rowid, desc, query, type, hospid) As %Query(ROWSPEC = "CTLOCRowID,CTLOCDesc")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid, desc, query, type, hospid) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //s AuStr=""
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s strOPLoc= ##class(web.DHCBL.CT.CTLoc).FindOPLoc()
    
    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    
    s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
    s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
    
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s:query'="" query=$ZCONVERT(query,"U")
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTLOCRowID=rowid
        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        if (CTLOCHospitalDR'="")&(AuHospStr'="off")
        {
            s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
            s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
            if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
            else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
        }
        d OutputRowCmb2
    }
    else
    {
        s CTLOCRowID=0
        for  
        {
            s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
            s str1="["_CTLOCRowID_"]"
            s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
            s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
            s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
            s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键
            
            s strRowId = "{ID:"_CTLOCRowID_"}"
            s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
            s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
            s strDeptCodeID = "{ID:"_CTLOCDeptCode_"}"
            s strDomainCodeID = "{ID:"_CTLOCDomainCode_"}"
            i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((DepartmentAuStr[strDeptCodeID)||(DepartmentAuFlag=1))&&((BusiDomainAuStr[strDomainCodeID)||(BusiDomainAuFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
	            
                s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)
                S CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)
                s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
                s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
                continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                s CTLOCActiveFlag=$p($g(^CTLOC(CTLOCRowID)),"^",14)	//是否有效(Y/N)
                continue:CTLOCActiveFlag="N"
                if (CTLOCHospitalDR'="") & (AuHospStr'="off")
                {
                    s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
		            s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
		            if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
		            else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
                }
                /*
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
                */
                if (desc'="")
               {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Loc",CTLOCRowID,CTLOCDesc,desc)
               }
                else
               {
                    s AliasFlag= 1   
               }
               /*(PINYIN[desc)||($ZCONVERT(CTLOCDesc,"U")[desc)||(ALIASText1[desc||($ZCONVERT(CTLOCContactName,"U")[desc))*/
                
                i ((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc))&((hospid="")||((hospid'="")&&(CTLOCHospitalDR=hospid)))&($ZCONVERT(CTLOCDesc,"U")[query)&(((CTLOCType'="W")&(type'="N"))||(type="")||(type="N"))
                {
                    
                    if (strOPLoc[str1){
                        d OutputRowCmb2
                    }
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb2
    set Data=$lb(CTLOCRowID,CTLOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：陈莹
/// CreatDate: 2020-05-14
/// Description：2020-05-14（特殊接口，返回本组的科室）
/// 获取医院对应医院组的科室数据。a3返回a3的科室，a1 返回a1+a2+a3的科室，如果再把a3例外，a1返回a1+a2的科室
/// Table：User.CTLoc
/// Input：rowid, code, desc, query, type, communityid, hospid(医院id)
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLoc","GetDataForCmbGroup","","","门诊","","","","2")
Query GetDataForCmbGroup(rowid, code, desc, query, type, communityid, hospid, tablename) As %Query(ROWSPEC = "CTLOCRowID,CTLOCCode,CTLOCDesc")
{
}

ClassMethod GetDataForCmbGroupExecute(ByRef qHandle As %Binary, rowid, code, desc, query, type, communityid, hospid, tablename) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    
    s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
    s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
	
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s:query'="" query=$ZCONVERT(query,"U")
    s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetHospital(communityid)  
    if (rowid'="") //根据rowid返回该条记录
    {
        s CTLOCRowID=rowid
        s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1) 
        s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        if (CTLOCHospitalDR'="")&(AuHospStr'="off")
        {
            s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
            s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
            if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
            else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
        }
        d OutputRowForGroup
    }
    else
    {
        s CTLOCRowID=0
        for  
        {
            s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
            s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
            
            
            s HospIds=","_##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName(tablename,hospid)_","  //根据表名，医院id，日期，如果不是例外医院，返回该医院组下所有的非例外医院；
			continue:HospIds'[(","_CTLOCHospitalDR_",")
			
            s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
            s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
            s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键
            
            s strRowId = "{ID:"_CTLOCRowID_"}"
            s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
            s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"

            s strDeptCodeID = "{ID:"_CTLOCDeptCode_"}"
            s strDomainCodeID = "{ID:"_CTLOCDomainCode_"}"
            i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((DepartmentAuStr[strDeptCodeID)||(DepartmentAuFlag=1))&&((BusiDomainAuStr[strDomainCodeID)||(BusiDomainAuFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
	            s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)
                s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)     //用户名
                S CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)
                s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
                s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期
                continue:(CTLOCDateActiveTo'="")&&(CTLOCDateActiveTo<+$h)
                s CTLOCActiveFlag=$p($g(^CTLOC(CTLOCRowID)),"^",14)	//是否有效(Y/N)
                continue:CTLOCActiveFlag="N"
                if (CTLOCHospitalDR'="")&(AuHospStr'="off") 
                {
                    s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)   //开了医院级授权，科室后面显示医院信息
                    s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
                    if HOSPShortName'="" s CTLOCDesc=CTLOCDesc_"【"_HOSPShortName_"】"
                    else  s CTLOCDesc=CTLOCDesc_"【"_HOSPDesc_"】"
                }
                /*s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
                */
                if (desc'="")
               {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Loc",CTLOCRowID,CTLOCDesc,desc)
               }
                else
               {
                    s AliasFlag= 1   
               }
               
                s HospitalDR = "<"_CTLOCHospitalDR_">"
                ///sunfengchao 修复 医院级联时不能检索的问题
                ///只有护士可以看到病区数据
                if ($ZCONVERT(CTLOCCode,"U")[code)&&((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc))&(((CTLOCType'="W")&(type'="N"))||(type="")||(type="N"))&($ZCONVERT(CTLOCDesc,"U")[query)
                {
                    //i ((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc)&((hospid=""))||((hospid'="")&&(CTLOCHospitalDR=hospid)))&($ZCONVERT(CTLOCDesc,"U")[query)&(((CTLOCType'="W")&(type'="N"))||(type="")||(type="N"))
                     /*($ZCONVERT(CTLOCDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc)||($ZCONVERT(CTLOCContactName,"U")[desc)*/
             
                    if (communityid'=""){
                        if (HospitalDRs[HospitalDR) d OutputRowForGroup
                    }else{
                        d OutputRowForGroup
                    }
                    
                }
            }
            
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowForGroup
    set Data=$lb(CTLOCRowID,CTLOCCode,CTLOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbGroupExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmbGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbGroupExecute ]
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

/// 获取病人类型为OutPatient的科室
/// Other: d ##class(web.DHCBL.CT.PACAdmTypeLocation).FindOPLoc()
ClassMethod FindOPLoc() As %String
{
    s strOPLoc=""
    s ADMLOCRowId=0
    for {
        s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""
        s ADMLOCCTLOCDR=""
        s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1) 
        s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
        if (ADMLOCAdmType="I") 
        { 
            s strOPLoc=strOPLoc_"["_ADMLOCCTLOCDR_"]"
        }
    }
    q strOPLoc
}

/// Creator：蔡昊哲
/// CreatDate: 2012-10-12
/// Description：获取修改时的记录
/// Table：User.CTLoc
/// Other: d ##class(web.DHCBL.CT.CTLoc).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.CTLoc).%New()
    s pobj = ##class(User.CTLoc).%OpenId(id)
    s eobj.CTLOCRowID = id
    s eobj.CTLOCCode = pobj.CTLOCCode
    s eobj.CTLOCDesc = pobj.CTLOCDesc
    ;s list=##class(%ListOfDataTypes).%New()
    s eobj.CTLOCAddress = pobj.CTLOCAddress.GetAt(1)
    s eobj.CTLOCFloor = pobj.CTLOCFloor
    s:pobj.CTLOCWardSingleSex'="" eobj.CTLOCWardSingleSex = pobj.CTLOCWardSingleSex.%Id()
    ;s eobj.CTLOCWardSingleSex = pobj.CTLOCWardSingleSex
    s eobj.CTLOCAgeFrom = pobj.CTLOCAgeFrom
    s eobj.CTLOCAgeTo = pobj.CTLOCAgeTo

    s eobj.CTLOCType = pobj.CTLOCType
    s:pobj.CTLOCDepDR'="" eobj.CTLOCDepDR = pobj.CTLOCDepDR.%Id()
    s:pobj.CTLOCDepartmentHeadUserDR'="" eobj.CTLOCDepartmentHeadUserDR = pobj.CTLOCDepartmentHeadUserDR.%Id()
    s eobj.CTLOCMedicalRecordActive = pobj.CTLOCMedicalRecordActive  
    s eobj.CTLOCAllowNoCureLimit = pobj.CTLOCAllowNoCureLimit 
    s eobj.CTLOCBeInHospital = pobj.CTLOCBeInHospital  //是否住院总签床
    s:eobj.CTLOCAllowNoCureLimit="Y" eobj.CTLOCAllowNoCureLimit="true"
    s:eobj.CTLOCBeInHospital="Y" eobj.CTLOCBeInHospital="true"
    s eobj.CTLOCIndex = pobj.CTLOCIndex
    s:pobj.CTLOCHospitalDR'="" eobj.CTLOCHospitalDR = pobj.CTLOCHospitalDR.%Id()
    s eobj.CTLOCExecuteConfirmation = pobj.CTLOCExecuteConfirmation
    ;s:pobj.CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom = $zd(pobj.CTLOCDateActiveFrom,1)
    ;s:pobj.CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo = $zd(pobj.CTLOCDateActiveTo,1)
    s:pobj.CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTLOCDateActiveFrom)
    s:pobj.CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTLOCDateActiveTo)
    s eobj.CTLOCContactName = pobj.CTLOCContactName
    s eobj.CTLOCClinicType = pobj.CTLOCClinicType
    s:pobj.CTLOCBroadPatientGroupDR'="" eobj.CTLOCBroadPatientGroupDR = pobj.CTLOCBroadPatientGroupDR.%Id()
    s eobj.CTLOCTelephone = pobj.CTLOCTelephone
    s eobj.CTLOCNationCode = pobj.CTLOCNationCode
    
    s:pobj.CTLOCCategoryDR'="" eobj.CTLOCCategoryDR= pobj.CTLOCCategoryDR.%Id()
    //upadte2020-1-2 钟荣枫 增加科室科室分类
    
    if $IsObject(pobj.CTLOCDeptCode){
		s eobj.CTLOCDeptCode = pobj.CTLOCDeptCode.%Id() 	//组织外码-外键
	}  
	if $IsObject(pobj.CTLOCDomainCode){
		s eobj.CTLOCDomainCode = pobj.CTLOCDomainCode.%Id() 	//业务域代码-外键
	}
	s eobj.CTLOCLocation=pobj.CTLOCLocation		//物理位置
	s eobj.CTLOCActiveFlag=pobj.CTLOCActiveFlag	//是否有效(Y/N)
	s:((eobj.CTLOCActiveFlag="Y")||(eobj.CTLOCActiveFlag="")) eobj.CTLOCActiveFlag="true"
  	s:(eobj.CTLOCActiveFlag="N") eobj.CTLOCActiveFlag="false"
  
	s eobj.CTLOCSeqNo=pobj.CTLOCSeqNo		//系统排序号
	s eobj.CTLOCPYCode=pobj.CTLOCPYCode		//拼音码
	s eobj.CTLOCWBCode=pobj.CTLOCWBCode		//五笔码
	s eobj.CTLOCMark=pobj.CTLOCMark		//备注
				
    s ADMLOCRowId=0
    f  s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""  d
    .s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1)
    .s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
    .s ADMLOCCTLOCDesc=""
    .s:ADMLOCCTLOCDR'="" ADMLOCCTLOCDesc=$p($g(^CTLOC(ADMLOCCTLOCDR)),"^",2) //获取科室描述
    .i (ADMLOCCTLOCDR=id) d 
    ..s:ADMLOCAdmType="O" eobj.OutPatient= "true"
    ..s:ADMLOCAdmType="I" eobj.InPatient= "true"
    ..s:ADMLOCAdmType="E" eobj.Emergency= "true"
    ..s:ADMLOCAdmType="H" eobj.HealthPromotion= "true"
    
    if (pobj.CTLOCType="W")||(pobj.CTLOCType="EM")||(pobj.CTLOCType="OP")
    {
        s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",id,0))
        if (WARDRowID'=""){
            s wobj = ##class(User.PACWard).%OpenId(WARDRowID)
            s eobj.WARDActive=wobj.WARDActive
            s eobj.WARDSingleRoom=wobj.WARDSingleRoom
            s eobj.WARDViewLinkedRooms=wobj.WARDViewLinkedRooms
            s eobj.WARDViewNextMostUrgent=wobj.WARDViewNextMostUrgent
            s eobj.WARDBeforehand=wobj.WARDBeforehand
            
            s:eobj.WARDActive="Y" eobj.WARDActive="true"
            s:eobj.WARDSingleRoom="Y" eobj.WARDSingleRoom="true"
            s:eobj.WARDViewLinkedRooms="Y" eobj.WARDViewLinkedRooms="true"
            s:eobj.WARDViewNextMostUrgent="Y" eobj.WARDViewNextMostUrgent="true"
            s:eobj.WARDBeforehand="Y" eobj.WARDBeforehand="true"
            d wobj.%Close()
            k wobj
        }
    }
    
    d pobj.%Close() 
    k pobj  
    
    s:eobj.CTLOCIndex="Y" eobj.CTLOCIndex="true"
    s:eobj.CTLOCExecuteConfirmation="Y" eobj.CTLOCExecuteConfirmation="true"
    s:eobj.CTLOCMedicalRecordActive="Y" eobj.CTLOCMedicalRecordActive="true"    
    
    s str = eobj.JsonS()    
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：蔡昊哲
/// CreatDate: 2013-1-29
/// Description：数据重复验证方法
/// Table：User.CTSex
/// Input：id, code, desc,hospid(医院id)
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.CTLoc).FormValidate("","","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    
 	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			///2022-12-30 UPDATE 跨院区也不允许代码相同
			//s CTLOCHospitalDR=$p($g(^CTLOC(idc)),"^",22)     //医院    
			//((hospid="")||((CTLOCHospitalDR=hospid)&&(hospid'="")))
			if (id'=idc)
			{
				s flag=1  //返回重复标志 
			}
		}
		
	}
	
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
			s idd=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			s CTLOCHospitalDR=$p($g(^CTLOC(idd)),"^",22)     //医院    ///2020-02-05update 同一个医院下不允许名称项同
			if ((hospid="")||((CTLOCHospitalDR=hospid)&&(hospid'="")))&&(id'=idd)
			{
				s flag=1  //返回重复标志 
			}
		}
		
	}
	
    
    q flag
}

/// Description：吉大三院 保存修改科室部分信息-同步集成平台
/// Table：User.CTLoc
/// Input：科室编码、科室名称、科室位置、科室楼层
/// Return：成功返回1；失败返回0
/// Others:w ##class(web.DHCBL.CT.CTLoc).SyncData("376","测试2","测试2","A楼","三层")
ClassMethod SyncData(id, CTLOCCode, CTLOCDesc, CTLOCAddress, CTLOCFloor) As %String
{
    s result = ""
    s flag=..FormValidate(id,CTLOCCode,CTLOCDesc)  //调用重复验证
    if (flag=1)
    {
        s result = 0 //"{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (id="")  //如果Id未赋值则增加
        {
            s obj=##class(User.CTLoc).%New()
            s obj.CTLOCType = "O" 
        }
        else
        {
            s obj=##class(User.CTLoc).%OpenId(id)
        }
        Ts                              
        s obj.CTLOCCode = CTLOCCode          //修改代码
        s obj.CTLOCDesc = CTLOCDesc          //修改描述
        s AddressList=##class(%ListOfDataTypes).%New()
        do AddressList.Insert(CTLOCAddress)
        s obj.CTLOCAddress = AddressList          //保存地址
        s obj.CTLOCFloor = CTLOCFloor
    
        s sc = obj.%Save()
        d obj.%Close()
            
        If $$$ISOK(sc)
        {
            Tc                  
            s result = 1     
        }
        else
        {
            Trollback
            s result = 0
        }
    }
    q result
}

/// Creator：蔡昊哲
/// CreatDate: 2012-10-12
/// Description：保存修改科室维护的内容
/// Table：User.CTLoc
/// Input：web.Entity.CT.CTLoc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTLoc).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLoc, ClinicValues As %String = "") As %String
{
    s $zt="ERROE"
    s result = ""
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 
    if $IsObject(eobj)
    {
        s:eobj.CTLOCDateActiveFrom="" eobj.CTLOCDateActiveFrom=+$h
        s eobj.CTLOCClinicType = ClinicValues
        ;s:eobj.CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom=$zdh(eobj.CTLOCDateActiveFrom,15)  //转换日期
        ;s:eobj.CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo=$zdh(eobj.CTLOCDateActiveTo,15)  //转换日期
        s:eobj.CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLOCDateActiveFrom)  //转换日期
        s:eobj.CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLOCDateActiveTo)  //转换日期
        s:eobj.CTLOCIndex="" eobj.CTLOCIndex="N"
        s:eobj.CTLOCMedicalRecordActive="" eobj.CTLOCMedicalRecordActive="N"
        s:eobj.CTLOCExecuteConfirmation="" eobj.CTLOCExecuteConfirmation="N"
        s:eobj.CTLOCAllowNoCureLimit="" eobj.CTLOCAllowNoCureLimit="N"
        s:eobj.CTLOCBeInHospital="" eobj.CTLOCBeInHospital="N"
        
        s:eobj.CTLOCLastUpdateDate="" eobj.CTLOCLastUpdateDate=+$h		//系统最后更新日期
	    s:eobj.CTLOCLastUpdateTime="" eobj.CTLOCLastUpdateTime=$p($h,",",2)		//系统最后更新时间
	    s:eobj.CTLOCLastUpdateUser="" eobj.CTLOCLastUpdateUser=UserID	//系统最新更新人
	    s:eobj.CTLOCActiveFlag="" eobj.CTLOCActiveFlag="N"		//是否有效
    	s eobj.WARDActive=eobj.CTLOCActiveFlag		//“是否有效”标志修改的时候，要同步下病区表的有效标志
        s flag=..FormValidate(eobj.CTLOCRowID,eobj.CTLOCCode,eobj.CTLOCDesc,eobj.CTLOCHospitalDR)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.CTLOCRowID="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.CTLoc).%New()
                s:eobj.CTLOCCreateDate="" eobj.CTLOCCreateDate=+$h	//系统创建日期默认当前日期
			    s:eobj.CTLOCCreateTime="" eobj.CTLOCCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
			    s:eobj.CTLOCCreateUser="" eobj.CTLOCCreateUser= UserID		//系统创建人默认当前登录人员
			    s obj.CTLOCCreateDate=eobj.CTLOCCreateDate		//系统创建日期
				s obj.CTLOCCreateTime=eobj.CTLOCCreateTime		//系统创建时间
				d obj.CTLOCCreateUserSetObjectId(eobj.CTLOCCreateUser)	//系统创建人
            }
            else
            {
                s obj=##class(User.CTLoc).%OpenId(eobj.CTLOCRowID)
                s bobj=##class(web.Entity.CT.CTLoc).%New()
                s bobj.CTLOCRowID=eobj.CTLOCRowID
                s bobj.CTLOCCode = obj.CTLOCCode          //修改代码
                s bobj.CTLOCDesc = obj.CTLOCDesc          //修改描述
                s bobj.CTLOCAddress = obj.CTLOCAddress.GetAt(1)
                s bobj.CTLOCFloor = obj.CTLOCFloor
                s:obj.CTLOCWardSingleSex'="" bobj.CTLOCWardSingleSex = obj.CTLOCWardSingleSex.%Id()
                s bobj.CTLOCAgeFrom = obj.CTLOCAgeFrom
                s bobj.CTLOCAgeTo = obj.CTLOCAgeTo
                s bobj.CTLOCType = obj.CTLOCType 
                s:obj.CTLOCDepDR'="" bobj.CTLOCDepDR = obj.CTLOCDepDR.%Id()
                s bobj.CTLOCIndex = obj.CTLOCIndex
                s:obj.CTLOCHospitalDR'="" bobj.CTLOCHospitalDR = obj.CTLOCHospitalDR.%Id()
                s:obj.CTLOCDepartmentHeadUserDR'="" bobj.CTLOCDepartmentHeadUserDR = obj.CTLOCDepartmentHeadUserDR.%Id()
                s bobj.CTLOCMedicalRecordActive = obj.CTLOCMedicalRecordActive
                s bobj.CTLOCAllowNoCureLimit = obj.CTLOCAllowNoCureLimit  //
                s bobj.CTLOCBeInHospital = obj.CTLOCBeInHospital
                s bobj.CTLOCExecuteConfirmation = obj.CTLOCExecuteConfirmation
                s bobj.CTLOCDateActiveFrom = obj.CTLOCDateActiveFrom	//开始日期
                s bobj.CTLOCDateActiveTo = obj.CTLOCDateActiveTo		//结束日期
                s bobj.CTLOCContactName = obj.CTLOCContactName  
                s bobj.CTLOCClinicType = obj.CTLOCClinicType
                s:obj.CTLOCBroadPatientGroupDR'="" bobj.CTLOCBroadPatientGroupDR = obj.CTLOCBroadPatientGroupDR.%Id()
                s bobj.CTLOCTelephone = obj.CTLOCTelephone
                s bobj.CTLOCNationCode = obj.CTLOCNationCode
                
                s:obj.CTLOCCategoryDR'="" bobj.CTLOCCategoryDR = obj.CTLOCCategoryDR.%Id()	//upadte2020-1-2 钟荣枫 增加科室科室分类
                
                if ((bobj.CTLOCType="W")||(bobj.CTLOCType="EM")||(bobj.CTLOCType="OP"))
                {
	                if (eobj.CTLOCType'=bobj.CTLOCType)
	                {
	                	s str=##class(web.DHCBL.CT.CTLoc).UpdateCTLOCType(eobj.CTLOCRowID,eobj.CTLOCType)
	                	if str'="" q "{success:'false',errorinfo:'"_str_"'}"
	                }
                }
                
                if $IsObject(obj.CTLOCDeptCode){
					s bobj.CTLOCDeptCode = obj.CTLOCDeptCode.%Id() 	//组织外码-外键
				}  
				if $IsObject(obj.CTLOCDomainCode){
					s bobj.CTLOCDomainCode = obj.CTLOCDomainCode.%Id() 	//业务域代码-外键
				}

				s bobj.CTLOCLocation=obj.CTLOCLocation		//物理位置
				s bobj.CTLOCActiveFlag=obj.CTLOCActiveFlag	//是否有效(Y/N)

				s bobj.CTLOCCreateDate=obj.CTLOCCreateDate		//系统创建日期
				s bobj.CTLOCCreateTime=obj.CTLOCCreateTime		//系统创建时间
				if $IsObject(obj.CTLOCCreateUser){
					s bobj.CTLOCCreateUser = obj.CTLOCCreateUser.%Id() 	//系统创建人
				}
				s bobj.CTLOCSeqNo=obj.CTLOCSeqNo		//系统排序号
				s bobj.CTLOCLastUpdateDate=obj.CTLOCLastUpdateDate		//系统最后更新日期
				s bobj.CTLOCLastUpdateTime=obj.CTLOCLastUpdateTime		//系统最后更新时间
				if $IsObject(obj.CTLOCLastUpdateUser){
					s bobj.CTLOCLastUpdateUser = obj.CTLOCLastUpdateUser.%Id() 	//系统最新更新人
				}
				s bobj.CTLOCPYCode=obj.CTLOCPYCode		//拼音码
				s bobj.CTLOCWBCode=obj.CTLOCWBCode		//五笔码
				s bobj.CTLOCMark=obj.CTLOCMark		//备注
                
            }
            s obj.CTLOCCode = eobj.CTLOCCode          //修改代码
            s obj.CTLOCDesc = eobj.CTLOCDesc          //修改描述
            ;s obj.CTLOCAddress = eobj.CTLOCAddress
            s AddressList=##class(%ListOfDataTypes).%New()
            do AddressList.Insert(eobj.CTLOCAddress)
            s obj.CTLOCAddress = AddressList          //保存地址
            s obj.CTLOCFloor = eobj.CTLOCFloor
            s obj.CTLOCType = eobj.CTLOCType 
            s obj.CTLOCAgeFrom = eobj.CTLOCAgeFrom 
            s obj.CTLOCAgeTo = eobj.CTLOCAgeTo 
            s obj.CTLOCType = eobj.CTLOCType 
            d obj.CTLOCWardSingleSexSetObjectId(eobj.CTLOCWardSingleSex)

            d obj.CTLOCDepDRSetObjectId(eobj.CTLOCDepDR)
            d obj.CTLOCDepartmentHeadUserDRSetObjectId(eobj.CTLOCDepartmentHeadUserDR)
            s obj.CTLOCIndex = eobj.CTLOCIndex
            d obj.CTLOCHospitalDRSetObjectId(eobj.CTLOCHospitalDR) 
            s obj.CTLOCMedicalRecordActive = eobj.CTLOCMedicalRecordActive
            s obj.CTLOCExecuteConfirmation = eobj.CTLOCExecuteConfirmation
            s obj.CTLOCAllowNoCureLimit = eobj.CTLOCAllowNoCureLimit
            s obj.CTLOCBeInHospital = eobj.CTLOCBeInHospital  //是否住院总签床
            s obj.CTLOCDateActiveFrom = eobj.CTLOCDateActiveFrom
            s obj.CTLOCDateActiveTo = eobj.CTLOCDateActiveTo
            s obj.CTLOCContactName = eobj.CTLOCContactName  
            s obj.CTLOCClinicType = eobj.CTLOCClinicType
            d obj.CTLOCBroadPatientGroupDRSetObjectId(eobj.CTLOCBroadPatientGroupDR)
            s obj.CTLOCTelephone = eobj.CTLOCTelephone
            s obj.CTLOCNationCode = eobj.CTLOCNationCode
            
            d obj.CTLOCCategoryDRSetObjectId(eobj.CTLOCCategoryDR)	//upadte2020-1-2 钟荣枫 增加科室科室分类
            
            if (eobj.CTLOCType="W")
            {
                s obj.CTLOCWardFlag="Y"
            }
            else
            {
                s obj.CTLOCWardFlag="N"
            }  
            
			d obj.CTLOCDeptCodeSetObjectId(eobj.CTLOCDeptCode) 	//组织外码-外键
			 
			d obj.CTLOCDomainCodeSetObjectId(eobj.CTLOCDomainCode) 	//业务域代码-外键

			s obj.CTLOCLocation=eobj.CTLOCLocation		//物理位置
			s obj.CTLOCActiveFlag=eobj.CTLOCActiveFlag	//是否有效(Y/N)

			s obj.CTLOCSeqNo=eobj.CTLOCSeqNo		//系统排序号
			s obj.CTLOCLastUpdateDate=eobj.CTLOCLastUpdateDate		//系统最后更新日期
			s obj.CTLOCLastUpdateTime=eobj.CTLOCLastUpdateTime		//系统最后更新时间
			d obj.CTLOCLastUpdateUserSetObjectId(eobj.CTLOCLastUpdateUser) 	//系统最新更新人
			s:eobj.CTLOCPYCode="" eobj.CTLOCPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTLOCDesc)
			s obj.CTLOCPYCode=eobj.CTLOCPYCode		//拼音码
			s:eobj.CTLOCWBCode="" eobj.CTLOCWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CTLOCDesc,1)
			s obj.CTLOCWBCode=eobj.CTLOCWBCode		//五笔码
			s obj.CTLOCMark=eobj.CTLOCMark		//备注
            
            Ts                              
                 
            s sc = obj.%Save()
            d obj.%Close()
            
            If $$$ISOK(sc)
            {
                s id = obj.%Id()
                if ((eobj.CTLOCType="W")||(eobj.CTLOCType="EM")||(eobj.CTLOCType="OP"))       //如果科室类型为ward,添加表PAC_Ward记录
                {
                    s:eobj.WARDSingleRoom="" eobj.WARDSingleRoom="N"
                    s:eobj.WARDActive="" eobj.WARDActive="N"
                    s:eobj.WARDViewLinkedRooms="" eobj.WARDViewLinkedRooms="N"
                    s:eobj.WARDViewNextMostUrgent="" eobj.WARDViewNextMostUrgent="N"
                    s:eobj.WARDBeforehand="" eobj.WARDBeforehand="N"
                    s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",id,0))
                    if (WARDRowID'="")
                    {
                        s wobj = ##class(User.PACWard).%OpenId(WARDRowID)
                        //保存日志用 2020年4月27日
                        s bwobj=##class(web.Entity.CT.CTLoc).%New()
                        s bwobj.CTLOCCode=wobj.WARDCode
                        s bwobj.CTLOCDesc=wobj.WARDDesc
                        s bwobj.WARDSingleRoom=wobj.WARDSingleRoom
                        s bwobj.WARDActive=wobj.WARDActive
                        s bwobj.WARDViewLinkedRooms=wobj.WARDViewLinkedRooms
                        s bwobj.WARDViewNextMostUrgent=wobj.WARDViewNextMostUrgent
                        s bwobj.CTLOCDateActiveFrom=wobj.WARDInactiveDateFrom
                        s bwobj.CTLOCDateActiveTo=wobj.WARDInactiveDateTo
                        s bwobj.WARDBeforehand=wobj.WARDBeforehand
                        s bwobj.CTLOCDateActiveFrom=wobj.WARDInactiveDateFrom
                        s bwobj.CTLOCDateActiveTo=wobj.WARDInactiveDateTo
                        
                        s wobj.WARDCode=eobj.CTLOCCode
                        s wobj.WARDDesc=eobj.CTLOCDesc
                        s wobj.WARDSingleRoom = eobj.WARDSingleRoom
                        s wobj.WARDActive = eobj.WARDActive
                        s wobj.WARDViewLinkedRooms = eobj.WARDViewLinkedRooms
                        s wobj.WARDViewNextMostUrgent = eobj.WARDViewNextMostUrgent
                        s wobj.WARDInactiveDateFrom = eobj.CTLOCDateActiveFrom
                        s wobj.WARDInactiveDateTo = eobj.CTLOCDateActiveTo
                        s wobj.WARDBeforehand = eobj.WARDBeforehand
                        S wobj.WARDInactiveDateFrom= eobj.CTLOCDateActiveFrom
                        S wobj.WARDInactiveDateTo= eobj.CTLOCDateActiveTo
                        d wobj.%Save()
                        d wobj.%Close()
                        s wardLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Ward","User.PACWard","病区",WARDRowID,eobj.CTLOCDesc,"U",eobj,bwobj)
                    }
                }
               
                 
                
                Tc                  
                s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                s:eobj.CTLOCRowID'="" resultLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",eobj.CTLOCRowID,eobj.CTLOCDesc,"U",eobj,bobj)
                s:eobj.CTLOCRowID="" resultLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",id,eobj.CTLOCDesc,"A",eobj)
                
                //同步保存组织部门关联Location表的截止日期 2020-08-17
				d:eobj.CTLOCRowID'="" ##class(web.DHCBL.CT.CTLoc).ChangeCTLocDateTo(id,eobj.CTLOCDateActiveTo)
                ///调MDM的接口推送科室id	2020-07-30
                s SyncHCPFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("SyncForHCP")
				if (SyncHCPFlag="Y"){
					d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).SendCTDept(id)
				}
                ///往PACS同步科室数据 2020-05-22
				s SyncPACSFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPSyncPACS")
				if (SyncPACSFlag="Y"){
					d ##class(web.DHCBL.BDP.BDPInterface).PACSUpdateCTLoc(id)	
				}
                //科室分类 2020-03-26 只允许存在一个科室分类
                /*
		s ADMLOCRowId=""
                s AdmType=0
                for
                {
	                s AdmType=$o(^PAC("ADMLOC",0,"AdmType",AdmType)) q:((AdmType="")||(ADMLOCRowId'=""))
	                s ADMLOCRowId=$o(^PAC("ADMLOC",0,"AdmType",AdmType,id,0))
	                if ADMLOCRowId'="" q
                }
	        	s ADMLOCAdmType=""
	        	if (eobj.OutPatient'="") s ADMLOCAdmType="O"
				if (eobj.InPatient'="") s ADMLOCAdmType="I"
	        	if (eobj.Emergency'="") s ADMLOCAdmType="E"
                if (eobj.HealthPromotion'="") s ADMLOCAdmType="H"
                
                if ADMLOCAdmType'=""
                {
	                s ADMLOCeobj=##class(web.Entity.CT.PACAdmTypeLocation).%New()
					s ADMLOCeobj.ADMLOCRowId=ADMLOCRowId
					s ADMLOCeobj.ADMLOCAdmType =ADMLOCAdmType
					s ADMLOCeobj.ADMLOCCTLOCDR=id
	                d ##class(web.DHCBL.CT.PACAdmTypeLocation).SaveEntity(ADMLOCeobj)
                }
                else
                {
	                if ADMLOCRowId'=""
	                {
		                 d ##class(web.DHCBL.CT.PACAdmTypeLocation).DeleteData(ADMLOCRowId)
	                }
	                
                }
		*/
                //访问类型维护 （科室分类） 2022-07-20 去掉只允许设置一个访问类型位置的限制
                s ADMLOCCTLOCDR=id  //科室id
                S AdmTypeStr=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeStrByLoc(ADMLOCCTLOCDR) //已经维护的分类
                
                s ADMLOCAdmType=""
	        	if (eobj.Emergency'="") s ADMLOCAdmType=ADMLOCAdmType_"E"
                if (eobj.HealthPromotion'="") s ADMLOCAdmType=ADMLOCAdmType_"H"
                if (eobj.InPatient'="") s ADMLOCAdmType=ADMLOCAdmType_"I"
	        	if (eobj.OutPatient'="") s ADMLOCAdmType=ADMLOCAdmType_"O"
	        	if AdmTypeStr'=ADMLOCAdmType 
	        	{
	                s admInfo="EHIO"
	                FOR admi=1:1:($l(admInfo))
	                {
		                s AdmType=$E(admInfo,admi)
		                continue:AdmType=""
		                if ADMLOCAdmType[AdmType
		                {
			                if (AdmTypeStr'[AdmType)  //如果还没有维护，就新增
			                {
				                s ADMLOCeobj=##class(web.Entity.CT.PACAdmTypeLocation).%New()
								s ADMLOCeobj.ADMLOCRowId=""
								s ADMLOCeobj.ADMLOCAdmType=AdmType
								s ADMLOCeobj.ADMLOCCTLOCDR=ADMLOCCTLOCDR
				                d ##class(web.DHCBL.CT.PACAdmTypeLocation).SaveEntity(ADMLOCeobj)
			                }
		                }
		                else
		                {
			                s ADMLOCRowId=$o(^PAC("ADMLOC",0,"AdmType",AdmType,ADMLOCCTLOCDR,0))
				            if ADMLOCRowId'="" d ##class(web.DHCBL.CT.PACAdmTypeLocation).DeleteData(ADMLOCRowId)
		                }
	                }
                }
                
                
                s PortalFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUsePortal")
                if (PortalFlag="Y"){
                    s myobj=##class(%Dictionary.CompiledMethod).%OpenId("DtPortal.Configure.DataSync||SyncLocSoap")
				    i $IsObject(myobj)
				    {
					s Soap=##class(DtPortal.Configure.DataSync).SyncLocSoap(id,1)	
                    }
                }
                
                //调用医保组接口，记录科室变更状态，用于医保变更接口判断	2022-12-21
            	d:eobj.CTLOCRowID'="" ##class(web.DHCINSUPort).UptLocFlag(id)
                
            }
            else
            {
                Trollback
                s errorMsg=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
                i errorMsg["Can\'t change type"
                {
                    s errorMsg="该科室类型禁止修改！"
                }
                s result = "{success:'false',errorinfo:'"_errorMsg_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.CT.CTLoc","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
            }
        }           
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.CT.CTLoc","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.CTLoc).GetRefFlag(370)
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s return="0^未被引用可删除！"
    
    i $d(^RB("RES",0,"CTLOC",+id)) s myInfo=myInfo_"<资源表>"
    i $d(^PAWARD(0,"WARD_LocationDR",+id)) s myInfo=myInfo_"<病区表>" 
    i $d(^RBC("SER",0,"CTLOC",+id)) s myInfo=myInfo_"<服务表>"  ;RBC_Services
    i $d(^PAADMi("PAADM_LocDateTime",+id)) s myInfo=myInfo_"<病人就诊记录表>"  s return="1^在里被引用,不能删除！"  ;PA_Adm
    i $d(^OEORD(0,"RecDep",+id)) s myInfo=myInfo_"<医嘱明细表>"  ;OE_OrdItem
    i $d(^INCI("IL_LOC",+id)) s myInfo=myInfo_"<在科室库存表>"  ;INC_ItmLoc
    i $d(^INCI(0,"MainStore",+id)) s myInfo=myInfo_"<库存项表>"  ;INCItm

    
    S ARCRLARCIMSub=0
    f  s ARCRLARCIMSub=$o(^ARCRL(0,ARCRLARCIMSub)) q:ARCRLARCIMSub=""  d
    .i $d(^ARCRL(0,ARCRLARCIMSub,+id)) s myInfo=myInfo_"<医嘱项表>"  ;ARCItmRecLoc **
    .s ChildSub =0
    .f  s ChildSub=$o(^ARCRL(ARCRLARCIMSub,ChildSub)) q:ChildSub=""  d
    ..s ARCRLRecLocDR=$p($g(^ARCRL(ARCRLARCIMSub,ChildSub)),"^",2)
    ..i ARCRLRecLocDR=id s myInfo=myInfo_"<医嘱项表>"   ;ARCItmRecLoc **
    
    i $d(^CT("LL",0,"Loc1",+id)) s myInfo=myInfo_"<科室列表-关联科室>"  ;CTLocationListLocations 
    
    S SSGRPRowId=0
    f  s LLRowId=$o(^SSU("SSGRP",SSGRPRowId,"ST",0,"Loc")) q:LLRowId=""  d
    .i $d(^SSU("SSGRP",SSGRPRowId,"ST",0,"Loc",+id)) s myInfo=myInfo_"<安全组库存授权表>"   ;SSGroupStockLocations **
    
    s flag0=0
    s SSUSRRowId=0
    f  s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""  d
    .s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     //登录科室DR
    .i SSUSRDefaultDeptDR=id s flag0=1
    if (flag0) s myInfo=myInfo_"<用户表>"   ;SSUser **
    
    s flag1=0
    s ParRef=0
    f  s ParRef=$o(^SSU("SSUSR",ParRef)) q:ParRef=""  d 
    .s ChildSub=0
    .f  s ChildSub=$o(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)) q:ChildSub=""  d 
    ..s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
    ..i OTHLLCTLOCDR=id s flag1=1
    if (flag1) s myInfo=myInfo_"<其他登录科室表>"  ;SSUserOtherLogonLoc
    
    s flag2=0
    s ADMLOCRowId=0
    f  s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""  d
    .s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)  
    .i ADMLOCCTLOCDR=id s flag2=1
    if (flag2) s myInfo=myInfo_"<访问类型位置表-科室分类>"  ;PACAdmTypeLocation
    
    s flag3=0
    s ParRef=0
    f  s ParRef=$o(^OEC("ORCAT",ParRef)) q:ParRef=""  d 
    .s ChildSub=0
    .f  s ChildSub=$o(^OEC("ORCAT",ParRef,"RL",ChildSub)) q:ChildSub=""  d
    ..s RLOrdLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",2)
    ..s RLRecLocDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",3)
    ..i (RLOrdLocDR=id)||(RLRecLocDR=id) s flag3=1
    if (flag3) s myInfo=myInfo_"<医嘱大类-接收科室表>" ;OECOrdCatRecLoc
    
    
    s flag4=0
    s ParRef=0
    f  s ParRef=$o(^ARC("IC",ParRef)) q:ParRef=""  d 
    .s ChildSub=0
    .f  s ChildSub=$o(^ARC("IC",ParRef,"RL",ChildSub)) q:ChildSub=""  d
    ..s RLRecLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",3)
    ..s RLOrdLocDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",2)
    ..i (RLOrdLocDR=id)||(RLRecLocDR=id) s flag4=1
    if (flag4) s myInfo=myInfo_"<医嘱子类-接收科室表>" ;ARCItemCatRecLoc
    
    
    s flag5=0
    S ARCIMSubscript=0,ChildSub =0
    f  s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:ARCIMSubscript=""  d
    .i $d(^ARCIM(ARCIMSubscript,0,"EXT",0,"LOC",+id)) s flag5=1
    if (flag5) s myInfo=myInfo_"<在医嘱项-检验外码关联表>" ;ARCItemExternalCodes
    
    s SSGRPRowId=0,flag=0
    for{
        s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:(SSGRPRowId="")||(flag=1)

        s temp=$d(^SSU("SSGRP",SSGRPRowId,"ST",0,"Loc",id))
        if temp=10 
        {
            s flag=1
            s myInfo=myInfo_"<安全组库存授权>"
        }

    }   
    
    s flag6=0
    s ParRef=0
    f  s ParRef=$o(^CTLOC(ParRef)) q:ParRef=""  d 
    .s ChildSub=0
    .f  s ChildSub=$o(^CTLOC(ParRef,"LINK",ChildSub)) q:ChildSub=""  d
    ..s LINKCTLOCDR=$p($g(^CTLOC(ParRef,"LINK",ChildSub)),"^",1)
    ..i (LINKCTLOCDR=id) s flag6=1
    if (flag6) s myInfo=myInfo_"<科室病区-关联科室表>" ;CTLocLinkLocation
    
    s flag7=0       
    s ANCOCRowId=0
    f  s ANCOCRowId=$o(^ORC("OPER",ANCOCRowId)) q:ANCOCRowId=""  d
    .s OPERDefaultOperLocDr=$p($g(^ORC("OPER",ANCOCRowId,"DHC")),"^",10)
    .i OPERDefaultOperLocDr=id s flag7=1
    if (flag7) s myInfo=myInfo_"<手术/过程-扩展信息(默认手术室)>"  ;ORCOperationExtend
    
    s flag8=0
    s ParRef=0
    f  s ParRef=$o(^CTLOC(ParRef)) q:ParRef=""  d 
    .s ChildSub=0
    .f  s ChildSub=$o(^CTLOC(ParRef,"DEP",ChildSub)) q:ChildSub=""  d
    ..s LINKCTLOCDR=$p($g(^CTLOC(ParRef,"DEP",ChildSub)),"^",1)
    ..i (LINKCTLOCDR=id) s flag8=1
    if (flag8) s myInfo=myInfo_"<科室病区-相似部门表>" ;CTLocSimilarDepartment
            
    s ANCOCRowId=0
    for{
        s ANCOCRowId=$o(^ORC("OPER",ANCOCRowId)) q:(ANCOCRowId="")
        s OPERSurgeonDeptDrs=$p($g(^ORC("OPER",ANCOCRowId,"DHC")),"^",6)
        if (OPERSurgeonDeptDrs'=""){
            s loclength=$Length(OPERSurgeonDeptDrs,"|")
            for i=1:1:loclength
            {
                s OPERSurgeonDeptDr=$p(OPERSurgeonDeptDrs,"|",i)
                if (OPERSurgeonDeptDr=id){s myInfo=myInfo_"<手术/过程-扩展信息(手术医生科室)>" } ;ORCOperationExtend
            }       
        }   
    }
    
    s BODPRowId=0,flag=0
    for{
        s BODPRowId=$o(^MRC("BODP",BODPRowId)) q:(BODPRowId="")||(flag=1)
        s BODPCTLOCDR=$p($g(^MRC("BODP",BODPRowId)),"^",3)     
        if BODPCTLOCDR=id
        {
            s flag=1
            s myInfo=myInfo_"<电子病历-身体部位>"
        }
    }   
    
    s CTLOCCode=$p($g(^CTLOC(id)),"^",1)        //科室Code
    i ($d(^DHCPHLIBC(0,"HisCode",CTLOCCode)))
    {
        s myInfo=myInfo_"<知识库标识和HIS科室对照>"
    }
    i ($d(^DHCPHHLOCCON(0,"HisCode",CTLOCCode)))
    {
        s myInfo=myInfo_"<知识库科室字典对照>"
    }
    i ($d(^CT.BDP.CT.HOSPostI("IndexBUCode",id)))
    {
        s myInfo=myInfo_"<岗位>"
    }
    i ($d(^CT.BDP.CT.HOSHORGMedSubjectsI("IndexDesc",id)))
    {
        s myInfo=myInfo_"<医疗机构诊疗科目>"
    }
    
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator：蔡昊哲
/// CreatDate: 2013-7-23
/// Description：根据ID删除科室维护的内容
/// Table：User.CTLoc
/// Input：Id(CTLoc的rowid)
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result = ""
    s SQLCODE=0
    
    s re=##class(web.DHCBL.CT.CTLoc).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        s eobj = ##class(web.Entity.CT.CTLoc).%New()
        s pobj = ##class(User.CTLoc).%OpenId(id)
        s eobj.CTLOCRowID = id
        s eobj.CTLOCCode = pobj.CTLOCCode
        s eobj.CTLOCDesc = pobj.CTLOCDesc
        ;s list=##class(%ListOfDataTypes).%New()
        s eobj.CTLOCAddress = pobj.CTLOCAddress.GetAt(1)
        s eobj.CTLOCFloor = pobj.CTLOCFloor
        s eobj.CTLOCType = pobj.CTLOCType
        s:pobj.CTLOCDepDR'="" eobj.CTLOCDepDR = pobj.CTLOCDepDR.%Id() 
        s eobj.CTLOCMedicalRecordActive = pobj.CTLOCMedicalRecordActive
        s eobj.CTLOCAllowNoCureLimit = pobj.CTLOCAllowNoCureLimit
        s eobj.CTLOCBeInHospital = pobj.CTLOCBeInHospital
        s eobj.CTLOCIndex = pobj.CTLOCIndex
        s:pobj.CTLOCHospitalDR'="" eobj.CTLOCHospitalDR = pobj.CTLOCHospitalDR.%Id()
        s eobj.CTLOCExecuteConfirmation = pobj.CTLOCExecuteConfirmation
        s eobj.CTLOCContactName = pobj.CTLOCContactName
        s eobj.CTLOCClinicType = pobj.CTLOCClinicType
        s:pobj.CTLOCBroadPatientGroupDR'="" eobj.CTLOCBroadPatientGroupDR = pobj.CTLOCBroadPatientGroupDR.%Id()
        s eobj.CTLOCTelephone = pobj.CTLOCTelephone
        s eobj.CTLOCNationCode = pobj.CTLOCNationCode
        //s obj=##class(User.CTLoc).%OpenId(id)
        //if (obj.CTLOCType="W")
        //{
            ;d ##class(User.PACWard).%DeleteId(id)
            ;;&SQL(delete from PAC_Ward where WARD_LocationDR=:id)
        //}
       	if $IsObject(pobj.CTLOCDeptCode){
		s eobj.CTLOCDeptCode = pobj.CTLOCDeptCode.%Id() 	//组织外码-外键
		}  
		if $IsObject(pobj.CTLOCDomainCode){
			s eobj.CTLOCDomainCode = pobj.CTLOCDomainCode.%Id() 	//业务域代码-外键
		}
		s eobj.CTLOCLocation=pobj.CTLOCLocation		//物理位置
		s eobj.CTLOCActiveFlag=pobj.CTLOCActiveFlag	//是否有效(Y/N)
		s eobj.CTLOCSeqNo=pobj.CTLOCSeqNo		//系统排序号
		s eobj.CTLOCPYCode=pobj.CTLOCPYCode		//拼音码
		s eobj.CTLOCWBCode=pobj.CTLOCWBCode		//五笔码
		s eobj.CTLOCMark=pobj.CTLOCMark		//备注
        s sc = ##class(User.CTLoc).%DeleteId(id)
        if $$$ISOK(sc)
        {
            s result = "{success:'true',info:'删除成功！'}"  
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",id,eobj.CTLOCDesc,"D",eobj)
        }
        else 
        {
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.CT.CTLoc","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Creator:gss
/// CreatDate:2016-7-14
/// Description：查询树数据 	update2020-1-10 钟荣枫 增加科室多级分类列表
/// w ##class(web.DHCBL.CT.CTLoc).GetTreeJson("TreeRoot","CTLOCCategoryDR","0","20","")
ClassMethod GetTreeJson(LastLevel As %String, Type As %String, start, limit, query, hospid As %String = "") As %String
{
    s:query'="" query=$ZCONVERT(query,"U")
    //输出菜单JSON串
    s myJsonStr=""
    s count=0
    s end=start+limit
    //科室类型
    if ((Type="CTLOCType")||(Type=""))
    {
        if (LastLevel="TreeRoot") s LastLevel=-100000000000000
        s typeStr="W^Ward*E^Execute*DI^Drug Injection*D^Dispensing*C^Cashier*O^Other*OP^Operating Theatre*EM^Emergency*DS^Day Surgery*MR^Medical Records*OR^OutPatient Consulting Room*CL^Clinic*ADM^Admission Point"
        //输出菜单JSON串
        s typeLen=$Length(typeStr,"*")
        for i=1:1:typeLen
        {
            s type=$p(typeStr,"*",i)
            s myRowID = $p(type,"^",1)  
            s myDesc = $p(type,"^",2)
            s myDescU=$ZCONVERT(myDesc,"U")
            s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
            if ((myDescU[query)||(PINYIN[query)){
                s count=count+1
                if ((count>start)&(count<=end))||(end=0) {
                    s:(myJsonStr'="") myJsonStr=myJsonStr_","
                    s myJsonStr=myJsonStr_"{"
                    s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
                    s myJsonStr=myJsonStr_"""iconCls"":""icon-RoomType"","
                    s myJsonStr=myJsonStr_"""leaf"":true,"
                    s myJsonStr=myJsonStr_"""expanded"":true"
                    s myJsonStr=myJsonStr_"}"
                }
            }
        }           
    }
    //部门组
    if ((Type="CTLOCDepDR"))
    {
        if (LastLevel="TreeRoot") s LastLevel=-100000000000000

        //输出菜单JSON串
        s myRowID=0
        for {
            s myRowID=$o(^RBC("DEP",myRowID)) 
            q:(myRowID="")
            
            //20200522 likefan
            if (hospid'="")
            {
	            s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("RBC_DepartmentGroup",myRowID,hospid)
	  			continue:showflag="N"
            }
            s myDesc=$p($g(^RBC("DEP",myRowID)),"^",2)
            s myDescU=$ZCONVERT(myDesc,"U")
            s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
            if ((myDescU[query)||(PINYIN[query)){
                s count=count+1
                if ((count>start)&(count<=end))||(end=0) {
                    s:(myJsonStr'="") myJsonStr=myJsonStr_","
                    s myJsonStr=myJsonStr_"{"
                    s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
                    s myJsonStr=myJsonStr_"""iconCls"":""icon-DepartmentGroup"","
                    s myJsonStr=myJsonStr_"""leaf"":true,"
                    s myJsonStr=myJsonStr_"""expanded"":true"
                    s myJsonStr=myJsonStr_"}"
                }
            }
        }           
    }
    //医院
    if ((Type="CTLOCHospitalDR"))
    {
        if (LastLevel="TreeRoot") s LastLevel=-100000000000000

        //输出菜单JSON串
        s myRowID=0
        for {
            s myRowID=$o(^CT("HOSP",myRowID)) 
            q:(myRowID="")
            s myDesc=$p($g(^CT("HOSP",myRowID)),"^",2)
            s myDesc= ##class(web.DHCBL.BDP.FunLib).EvalJSON(myDesc)
            s myDescU=$ZCONVERT(myDesc,"U")
            s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
            if ((myDescU[query)||(PINYIN[query)){
                s count=count+1
                if ((count>start)&(count<=end))||(end=0) {
                    s:(myJsonStr'="") myJsonStr=myJsonStr_","
                    s myJsonStr=myJsonStr_"{"
                    s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
                    s myJsonStr=myJsonStr_"""iconCls"":""icon-Hospital"","
                    s myJsonStr=myJsonStr_"""leaf"":true,"
                    s myJsonStr=myJsonStr_"""expanded"":true"
                    s myJsonStr=myJsonStr_"}"
                }
            }
        }           
    }
    s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"

    //科室多层分类
    if ((Type="CTLOCCategoryDR"))
    {
        
        s myJsonStr=..GetCategoryTree(LastLevel,start,limit,query)
    }
    
    q myJsonStr
}

/// Creator:钟荣枫
/// CreatDate:2020-1-9
/// Description：查询页面数据 
/// Table：User.BDPCTLOCCategory
/// Input：父节点 
/// Return：treegrid格式数据串
/// Others:w ##class(web.DHCBL.CT.CTLoc).GetCategoryTree("TreeRoot","","","消化内科门诊")
ClassMethod GetCategoryTree(LastLevel As %String, start, limit, query) As %String
{
	if (LastLevel="TreeRoot") s LastLevel=-100000000000000
	if (LastLevel="") s LastLevel=-100000000000000
	s:query'="" query=$ZCONVERT(query,"U")
	s myJsonStr=""
	s end=start+limit
	k myArray
	k ^tempsequencesort("User.BDPCTLOCCategory")
	s rowid=0
	for {
		s rowid=$o(^User.BDPCTLOCCategoryI("ParCatIdx",LastLevel,rowid)) q:(rowid="")
		s Sequence=$LISTGET($G(^User.BDPCTLOCCategoryD(rowid)),7)
		s:Sequence="" Sequence=" "_Sequence
		s ^tempsequencesort("User.BDPCTLOCCategory",Sequence,rowid)=rowid
	}
	s SequenceSort=""
	s myCount=0
	for
	{
		s SequenceSort=$o(^tempsequencesort("User.BDPCTLOCCategory",SequenceSort))  q:SequenceSort=""
		s RowIDSort=""
		for
		{
			s RowIDSort=$o(^tempsequencesort("User.BDPCTLOCCategory",SequenceSort,RowIDSort))  q:RowIDSort=""
			s RowID=RowIDSort
			s myCount=myCount+1
			s myArray(myCount)=RowID
		}
		
	}
	k ^tempsequencesort("User.BDPCTLOCCategory")
    //输出菜单JSON串
    s myRowID=0
	s myCount=0
	s childStr=""
	s count=0
	for 
	{
		s myCount=$o(myArray(myCount)) q:(myCount="")
		s myRowID=$g(myArray(myCount))
		s myDesc=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),3)
		s myDescU=$ZCONVERT(myDesc,"U")
		s ActiveFlag=$LISTGET($G(^User.BDPCTLOCCategoryD(myRowID)),6)
		continue:ActiveFlag="N"			//过滤未激活
		s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(myDescU)
        if ((myDescU[query)||(PINYIN[query)){
            s count=count+1
            if ((count>start)&(count<=end))||(end=0) {
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_myRowID_""",""text"":"""_myDesc_""","
				s myJsonStr=myJsonStr_"""iconCls"":""icon-house"","
				
                s myChildFlag=$d(^User.BDPCTLOCCategoryI("ParCatIdx",myRowID))
                if (myChildFlag) s myChildFlag=1     //有子菜单不是叶子节点
  			    else  s myChildFlag=0
				if (+myChildFlag'=0)
				{
				
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""children"":"_##class(web.DHCBL.CT.CTLoc).GetCategoryTree(myRowID,start, limit, query)
				}
				else
				{
	 				s myJsonStr=myJsonStr_"""leaf"":true"
				}
                
                
                s myJsonStr=myJsonStr_"}"
            }
        }
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	
	q myJsonStr
}

/// Others:w ##class(web.DHCBL.CT.CTLoc).GetHospitalDR()
ClassMethod GetHospitalDR(RowId) As %String
{
    s CTLOCHospitalDR=""
    s:RowId'="" CTLOCHospitalDR=$p($g(^CTLOC(RowId)),"^",22)
    s:RowId="" CTLOCHospitalDR=""
    q CTLOCHospitalDR
}

/// Others:d ##class(web.DHCBL.CT.CTLoc).GetColumnTree("","","","","","","","","")
/// zw ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp")
ClassMethod GetColumnTree(rowid, code, desc, type, dep, communityid, hospid, treetype, category) As %String
{
    k ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp")
    ;获取科室关联医院
    s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    
    s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
    s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
	
    //s:code'="" desc=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    if ((treetype="CTLOCType")||(treetype="")) s type=category
    if ((treetype="CTLOCDepDR")) s dep=category
    if ((treetype="CTLOCHospitalDR")) s hospid=category
    s CTLOCRowID=0
    for  
    {
        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
        s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
        s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键
                
        s strRowId = "{ID:"_CTLOCRowID_"}"
        s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
        s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
		s strDeptCodeID = "{ID:"_CTLOCDeptCode_"}"
        s strDomainCodeID = "{ID:"_CTLOCDomainCode_"}"
        i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((DepartmentAuStr[strDeptCodeID)||(DepartmentAuFlag=1))&&((BusiDomainAuStr[strDomainCodeID)||(BusiDomainAuFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
        {
            s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
            s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室Code
            s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
            s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
            s ALIASText1=""
            s AliasRowId=0
            for{
                s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
                q:AliasRowId=""
                S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
            }
            s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)   
            s HospitalDR = "<"_CTLOCHospitalDR_">"
            s PINYIN=""
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
            i (($ZCONVERT(CTLOCDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc)||($ZCONVERT(CTLOCContactName,"U")[desc))&((hospid="")||((hospid'="")&&(CTLOCHospitalDR=hospid)))&(CTLOCCode[code)&((CTLOCType=type)||(type="")) & ((CTLOCDepDR=dep)||(dep=""))
            {
                if (CTLOCHospitalDR=""){
                    if ($d(^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp","0"))){
                        s ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp","0")=^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp","0")_"^"_CTLOCRowID
                    }else{
                        s ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp","0")=CTLOCRowID
                    }   
                }else{
                    if ($d(^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",CTLOCHospitalDR))){
                        s ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",CTLOCHospitalDR)=^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",CTLOCHospitalDR)_"^"_CTLOCRowID
                    }else{
                        s ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",CTLOCHospitalDR)=CTLOCRowID
                    }   
                }   
            }
        }
    }
    if ($d(^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp","0"))=0){
        s ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp","0")=""
    }
}

/// d ##class(web.DHCBL.CT.CTLoc).GetListJson("root","","","","","","","","","")
ClassMethod GetListJson(ParentID, rowid, code, desc, type, dep, communityid, hospid, treetype, category) As %String
{
    d ..GetColumnTree(rowid, code, desc, type, dep, communityid, hospid, treetype, category)
    
    //获取医院授权Json
    s AuHospStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    s AuHospFlag=0
    if AuHospStr="" s AuHospFlag=1 
    
    s return ="["
    w "["
    ;医院
    if (ParentID="root"){
        s i=0
        s HOSPRowId=0
        for  
        {   
            s HOSPRowId=$o(^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",HOSPRowId)) q:HOSPRowId="" 
            s strHOSPRowId = "{ID:"_HOSPRowId_"}"

            if (AuHospStr[strHOSPRowId)||(AuHospFlag=1){
                ;科室条数
                s locCount=""
                s locs=^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",HOSPRowId)
                s:locs'="" locCount=$Length(locs,"^")
                s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                if (i=0){
                    s return=return_"{CTLOCDesc:'"_HOSPDesc_"#"_locCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
                    w "{CTLOCDesc:'"_HOSPDesc_"#"_locCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
                }else{
                    s return=return_",{CTLOCDesc:'"_HOSPDesc_"#"_locCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
                    w ",{CTLOCDesc:'"_HOSPDesc_"#"_locCount_"',id:'H"_HOSPRowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
                }
                s i=i+1
            }
        }
        if (^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",0)'=""){
            ;科室条数
            s locCount=""
            s locs=^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",0)
            s:locs'="" locCount=$Length(locs,"^")
                
            if (return="["){
                s return=return_"{CTLOCDesc:'未关联医院#"_locCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
                w "{CTLOCDesc:'未关联医院#"_locCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
            }else{
                s return=return_",{CTLOCDesc:'未关联医院#"_locCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
                w ",{CTLOCDesc:'未关联医院#"_locCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
            }
        }
    }
    ;科室
    if ($e(ParentID,1)="H"){
        s locStr=^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp",$e(ParentID,2,*))
        if (locStr'=""){
            s j=0
            s locLen=$Length(locStr,"^")
            for i=1:1:locLen
            {
                s CTLOCRowID=$p(locStr,"^",i)
                s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
                s CTLOCDesc=$tr(CTLOCDesc,$c(13,10),"")
                s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)       //科室Code
                s CTLOCCode=$tr(CTLOCCode,$c(13,10),"")     
                s CTLOCAddress=$g(^CTLOC(CTLOCRowID,"ADDR",1))  //地址
                s CTLOCFloor=$p($g(^CTLOC(CTLOCRowID)),"^",16)      //楼层    
                s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
                s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
                s:CTLOCDepDR'="" DEPDesc=$p($g(^RBC("DEP",CTLOCDepDR)),"^",2)  //科室部门组描述
                s:CTLOCDepDR="" DEPDesc=""
                s CTLOCMedicalRecordActive=$p($g(^CTLOC(CTLOCRowID)),"^",27)    //在此科室病历可用
                s CTLOCIndex=$p($g(^CTLOC(CTLOCRowID)),"^",21)  //索引        
                s CTLOCExecuteConfirmation=$p($g(^CTLOC(CTLOCRowID)),"^",23)
                s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
                s CTLOCDateActiveFrom=$p($g(^CTLOC(CTLOCRowID)),"^",24) //生效日期
                s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期 
                s:CTLOCDateActiveFrom'="" CTLOCDateActiveFrom=$zd(CTLOCDateActiveFrom,1) //转换日期格式
                s:CTLOCDateActiveTo'="" CTLOCDateActiveTo=$zd(CTLOCDateActiveTo,1) //转换日期格式
                
                if (j=0){
                    w "{CTLOCDesc:'"_CTLOCDesc_"',id:'"_CTLOCRowID_"',CTLOCCode:'"_CTLOCCode_"',CTLOCType:'"_CTLOCType_"',DEPDesc:'"_DEPDesc_"',CTLOCIndex:'"_CTLOCIndex_"',CTLOCMedicalRecordActive:'"_CTLOCMedicalRecordActive_"',CTLOCExecuteConfirmation:'"_CTLOCExecuteConfirmation_"',CTLOCDateActiveFrom:'"_CTLOCDateActiveFrom_"',CTLOCDateActiveTo:'"_CTLOCDateActiveTo_"',uiProvider:'col',iconCls:'icon-Loc',leaf:true}" 
                }else{
                    w ",{CTLOCDesc:'"_CTLOCDesc_"',id:'"_CTLOCRowID_"',CTLOCCode:'"_CTLOCCode_"',CTLOCType:'"_CTLOCType_"',DEPDesc:'"_DEPDesc_"',CTLOCIndex:'"_CTLOCIndex_"',CTLOCMedicalRecordActive:'"_CTLOCMedicalRecordActive_"',CTLOCExecuteConfirmation:'"_CTLOCExecuteConfirmation_"',CTLOCDateActiveFrom:'"_CTLOCDateActiveFrom_"',CTLOCDateActiveTo:'"_CTLOCDateActiveTo_"',uiProvider:'col',iconCls:'icon-Loc',leaf:true}" 
                }
                s j=j+1
            }
        }
    }
    w "]"
    ;q return
}

/// 拖拽
ClassMethod DragNode(id, parentid) As %String
{
    s result=""
    s:parentid="0" parentid=""
    s:parentid="oot" parentid=""
    s obj=##class(User.CTLoc).%OpenId(id)
    
    s bCTLOCDesc = obj.CTLOCDesc
    s:obj.CTLOCHospitalDR'="" bCTLOCHospitalDR = obj.CTLOCHospitalDR.%Id()
    s:obj.CTLOCHospitalDR="" bCTLOCHospitalDR = ""
    s blogJson="{CTLOCRowID:"_$c(34)_id_$c(34)_",CTLOCHospitalDR:"_$c(34)_bCTLOCHospitalDR_$c(34)_"}"
    
    d:parentid="" obj.CTLOCHospitalDRSetObjectId("")
    d:parentid'="" obj.CTLOCHospitalDRSetObjectId(parentid)
    s logJson="{CTLOCRowID:"_$c(34)_id_$c(34)_",CTLOCHospitalDR:"_$c(34)_parentid_$c(34)_"}"
        
    Ts  
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc){
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" //返回RowId
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室病区",id,bCTLOCDesc,"U",logJson,blogJson)
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }
    q result
}

/// Others:d ##class(web.DHCBL.CT.CTLoc).GetColumnTree2("","","","","","","","","")
/// zw ^TMP("ColumnTree","web.DHCBL.CT.CTLoc","Hosp")
ClassMethod GetColumnTree2(rowid, code, desc, type, dep, communityid, hospid, treetype, category, flagType) As %String
{
    k ^TMP("ColumnTree","User.CTLoc")
    
    ;获取科室关联医院
    s AuStr=##class(web.DHCBL.Authorize.CTLoc).DHCGetDataByDefaultSession()
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuRBCDepartmentGroupStr=##class(web.DHCBL.Authorize.RBCDepartmentGroup).DHCGetDataByDefaultSession()
    s AuCTHospitalStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s AuRBCDepartmentGroupFlag=0
    if (AuRBCDepartmentGroupStr="")||(AuRBCDepartmentGroupStr["limited:0") s AuRBCDepartmentGroupFlag=1
    s AuCTHospitalFlag=0
    if (AuCTHospitalStr="")||(AuCTHospitalStr["limited:0") s AuCTHospitalFlag=1
    
    s DepartmentAuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s DepartmentAuFlag=0	
	if (DepartmentAuStr="")||(DepartmentAuStr["limited:0") s DepartmentAuFlag=1
    s BusiDomainAuStr=##class(web.DHCBL.Authorize.HOSBusiDomain).DHCGetDataByDefaultSession()
	s BusiDomainAuFlag=0	
	if (BusiDomainAuStr="")||(BusiDomainAuStr["limited:0") s BusiDomainAuFlag=1
	
    //s:code'="" desc=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    if ((treetype="CTLOCType")||(treetype="")) s type=category
    if ((treetype="CTLOCDepDR")) s dep=category
    if ((treetype="CTLOCHospitalDR")) s hospid=category
    s CTLOCRowID=0
    for  
    {
        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
        s CTLOCHospitalDR=$p($g(^CTLOC(CTLOCRowID)),"^",22)     //医院
        s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
        s CTLOCDeptCode = $p($g(^CTLOC(CTLOCRowID)),"^",89) 	//组织外码-外键
        s CTLOCDomainCode = $p($g(^CTLOC(CTLOCRowID)),"^",90) 	//业务域代码-外键  
          
        s strRowId = "{ID:"_CTLOCRowID_"}"
        s strCTLOCDepDR = "{ID:"_CTLOCDepDR_"}"
        s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
		s strDeptCodeID = "{ID:"_CTLOCDeptCode_"}"
        s strDomainCodeID = "{ID:"_CTLOCDomainCode_"}"
        i ((AuStr[strRowId)||(AuFlag=1))&&((AuRBCDepartmentGroupStr[strCTLOCDepDR)||(AuRBCDepartmentGroupFlag=1))&&((DepartmentAuStr[strDeptCodeID)||(DepartmentAuFlag=1))&&((BusiDomainAuStr[strDomainCodeID)||(BusiDomainAuFlag=1))&&((AuCTHospitalStr[strHospitalID)||(AuCTHospitalFlag=1))&&((AuHospStr="off")||(AuHospStr[strHospitalID)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
        {
            s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
            s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室Code
            s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
            s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
            /*s ALIASText1=""
            s AliasRowId=0
            for{
                s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Loc",CTLOCRowID,AliasRowId))
                q:AliasRowId=""
                S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
            }
            s PINYIN=""
            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)
            */
            if (desc'="")
            {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Loc",CTLOCRowID,CTLOCDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }
            s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)   
            s HospitalDR = "<"_CTLOCHospitalDR_">"
            
            i ((AliasFlag=1)||($ZCONVERT(CTLOCContactName,"U")[desc))&((hospid="")||((hospid'="")&&(CTLOCHospitalDR=hospid)))&(CTLOCCode[code)&((CTLOCType=type)||(type="")) & ((CTLOCDepDR=dep)||(dep=""))
            /*($ZCONVERT(CTLOCDesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc)||($ZCONVERT(CTLOCContactName,"U")[desc)*/
            {
                if (flagType="CTLOCHospitalDR"){
                    if (CTLOCHospitalDR="") s CTLOCHospitalDR=0
                    if ($d(^TMP("ColumnTree","User.CTLoc",flagType,CTLOCHospitalDR))){
                        s ^TMP("ColumnTree","User.CTLoc",flagType,CTLOCHospitalDR)=^TMP("ColumnTree","User.CTLoc",flagType,CTLOCHospitalDR)_"^"_CTLOCRowID
                    }else{
                        s ^TMP("ColumnTree","User.CTLoc",flagType,CTLOCHospitalDR)=CTLOCRowID
                    }
                }
                elseif(flagType="CTLOCDepDR"){
                    if (CTLOCDepDR="") s CTLOCDepDR=0
                    if ($d(^TMP("ColumnTree","User.CTLoc",flagType,CTLOCDepDR))){
                        s ^TMP("ColumnTree","User.CTLoc",flagType,CTLOCDepDR)=^TMP("ColumnTree","User.CTLoc",flagType,CTLOCDepDR)_"^"_CTLOCRowID
                    }else{
                        s ^TMP("ColumnTree","User.CTLoc",flagType,CTLOCDepDR)=CTLOCRowID
                    }
                }   
                elseif(flagType="CTLOCType"){
                    if (CTLOCType="") s CTLOCType=0
                    if ($d(^TMP("ColumnTree","User.CTLoc",flagType,CTLOCType))){
                        s ^TMP("ColumnTree","User.CTLoc",flagType,CTLOCType)=^TMP("ColumnTree","User.CTLoc",flagType,CTLOCType)_"^"_CTLOCRowID
                    }else{
                        s ^TMP("ColumnTree","User.CTLoc",flagType,CTLOCType)=CTLOCRowID
                    }
                }   
            }
        }
    }
    if ($d(^TMP("ColumnTree","User.CTLoc",flagType,"0"))=0){
        s ^TMP("ColumnTree","User.CTLoc",flagType,"0")=""
    }
}

/// d ##class(web.DHCBL.CT.CTLoc).GetListJson2("root","","","","","","","","","")
ClassMethod GetListJson2(ParentID, rowid, code, desc, type, dep, communityid, hospid, treetype, category, flagType, rebuild) As %String
{
    if ((ParentID="root")||(rebuild="Y")){
        d ..GetColumnTree2(rowid, code, desc, type, dep, communityid, hospid, treetype, category, flagType)
    }
    w "["
    ;医院/科室类型/部门组
    if (ParentID="root"){
        s i=0
        s RowId=0
        for  
        {   
            s RowId=$o(^TMP("ColumnTree","User.CTLoc",flagType,RowId)) q:RowId="" 
            ;科室条数
            s locCount=""
            s locs=^TMP("ColumnTree","User.CTLoc",flagType,RowId)
            s:locs'="" locCount=$Length(locs,"^")
            if (flagType="CTLOCHospitalDR"){
                s Desc=$p($g(^CT("HOSP",RowId)),"^",2)
            }elseif(flagType="CTLOCDepDR"){
                s Desc=$p($g(^RBC("DEP",RowId)),"^",2)
            }elseif(flagType="CTLOCType"){
                if (RowId="W"){s Desc="Ward"}
                elseif(RowId="E"){s Desc="Execute"}
                elseif(RowId="DI"){s Desc="Drug Injection"}
                elseif(RowId="D"){s Desc="Dispensing"}
                elseif(RowId="C"){s Desc="Cashier"}
                elseif(RowId="O"){s Desc="Other"}
                elseif(RowId="OP"){s Desc="Operating Theatre"}
                elseif(RowId="EM"){s Desc="Emergency"}
                elseif(RowId="DS"){s Desc="Day Surgery"}
                elseif(RowId="MR"){s Desc="Medical Records"}
                elseif(RowId="OR"){s Desc="OutPatient Consulting Room"}
                elseif(RowId="CL"){s Desc="Clinic"}
                elseif(RowId="ADM"){s Desc="Admission Point"}
            }
            if (i=0){
                w "{CTLOCDesc:'"_Desc_"#"_locCount_"',id:'H"_RowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
            }else{
                w ",{CTLOCDesc:'"_Desc_"#"_locCount_"',id:'H"_RowId_"',uiProvider:'col',iconCls:'icon-Hospital'}" 
            }
            s i=i+1 
        }
        
        if (^TMP("ColumnTree","User.CTLoc",flagType,0)'=""){
            ;科室条数
            s locCount=""
            s locs=^TMP("ColumnTree","User.CTLoc",flagType,0)
            s:locs'="" locCount=$Length(locs,"^")
                
            if (i=0){
                w "{CTLOCDesc:'未关联#"_locCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
            }else{
                w ",{CTLOCDesc:'未关联#"_locCount_"',id:'H0',uiProvider:'col',iconCls:'icon-Hospital'}" 
            }
        }
    }
    ;科室
    if ($e(ParentID,1)="H"){
        s locStr=^TMP("ColumnTree","User.CTLoc",flagType,$e(ParentID,2,*))
        if (locStr'=""){
            s j=0
            s locLen=$Length(locStr,"^")
            for i=1:1:locLen
            {
                s CTLOCRowID=$p(locStr,"^",i)
                q:($d(^CTLOC(CTLOCRowID))=0)
                s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
                s CTLOCDesc=$tr(CTLOCDesc,$c(13,10),"")
                s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)       //科室Code
                s CTLOCCode=$tr(CTLOCCode,$c(13,10),"")     
                s CTLOCAddress=$g(^CTLOC(CTLOCRowID,"ADDR",1))  //地址
                s CTLOCFloor=$p($g(^CTLOC(CTLOCRowID)),"^",16)      //楼层    
                s CTLOCType=$p($g(^CTLOC(CTLOCRowID)),"^",13)       //类型
                s CTLOCDepDR=$p($g(^CTLOC(CTLOCRowID)),"^",19)      //科室部分组 
                s:CTLOCDepDR'="" DEPDesc=$p($g(^RBC("DEP",CTLOCDepDR)),"^",2)  //科室部门组描述
                s:CTLOCDepDR="" DEPDesc=""
                s CTLOCMedicalRecordActive=$p($g(^CTLOC(CTLOCRowID)),"^",27)    //在此科室病历可用
                s CTLOCIndex=$p($g(^CTLOC(CTLOCRowID)),"^",21)  //索引        
                s CTLOCExecuteConfirmation=$p($g(^CTLOC(CTLOCRowID)),"^",23)
                s CTLOCContactName=$p($g(^CTLOC(CTLOCRowID)),"^",43)   //科室检索码
                s CTLOCDateActiveFrom=$p($g(^CTLOC(CTLOCRowID)),"^",24) //生效日期
                s CTLOCDateActiveTo=$p($g(^CTLOC(CTLOCRowID)),"^",25)    //截止日期 
                s:CTLOCDateActiveFrom'="" CTLOCDateActiveFrom=$zd(CTLOCDateActiveFrom,1) //转换日期格式
                s:CTLOCDateActiveTo'="" CTLOCDateActiveTo=$zd(CTLOCDateActiveTo,1) //转换日期格式
                
                if (j=0){
                    w "{CTLOCDesc:'"_CTLOCDesc_"',id:'"_CTLOCRowID_"',CTLOCCode:'"_CTLOCCode_"',CTLOCType:'"_CTLOCType_"',DEPDesc:'"_DEPDesc_"',CTLOCIndex:'"_CTLOCIndex_"',CTLOCMedicalRecordActive:'"_CTLOCMedicalRecordActive_"',CTLOCExecuteConfirmation:'"_CTLOCExecuteConfirmation_"',CTLOCDateActiveFrom:'"_CTLOCDateActiveFrom_"',CTLOCDateActiveTo:'"_CTLOCDateActiveTo_"',uiProvider:'col',iconCls:'icon-Loc',leaf:true}" 
                }else{
                    w ",{CTLOCDesc:'"_CTLOCDesc_"',id:'"_CTLOCRowID_"',CTLOCCode:'"_CTLOCCode_"',CTLOCType:'"_CTLOCType_"',DEPDesc:'"_DEPDesc_"',CTLOCIndex:'"_CTLOCIndex_"',CTLOCMedicalRecordActive:'"_CTLOCMedicalRecordActive_"',CTLOCExecuteConfirmation:'"_CTLOCExecuteConfirmation_"',CTLOCDateActiveFrom:'"_CTLOCDateActiveFrom_"',CTLOCDateActiveTo:'"_CTLOCDateActiveTo_"',uiProvider:'col',iconCls:'icon-Loc',leaf:true}" 
                }
                s j=j+1
            }
        }
    }
    w "]"
}

/// 拖拽
ClassMethod DragNode2(id, parentid, rule) As %String
{
    s result=""
    s:parentid="0" parentid=""
    s:parentid="oot" parentid=""
    s obj=##class(User.CTLoc).%OpenId(id)
    
    s bCTLOCDesc = obj.CTLOCDesc
    if (rule="CTLOCHospitalDR"){
        s:obj.CTLOCHospitalDR'="" bCTLOCHospitalDR = obj.CTLOCHospitalDR.%Id()
        s:obj.CTLOCHospitalDR="" bCTLOCHospitalDR = ""
        s blogJson="{CTLOCRowID:"""_id_""",CTLOCHospitalDR:"""_bCTLOCHospitalDR_"""}"
    
        d:parentid="" obj.CTLOCHospitalDRSetObjectId("")
        d:parentid'="" obj.CTLOCHospitalDRSetObjectId(parentid)
        s logJson="{CTLOCRowID:"""_id_""",CTLOCHospitalDR:"""_parentid_"""}"
    }elseif(rule="CTLOCDepDR"){
        s:obj.CTLOCDepDR'="" bCTLOCDepDR = obj.CTLOCDepDR.%Id()
        s:obj.CTLOCDepDR="" bCTLOCDepDR = ""
        s blogJson="{CTLOCRowID:"""_id_""",CTLOCDepDR:"""_bCTLOCDepDR_"""}"
        
        d:parentid="" obj.CTLOCDepDRSetObjectId("")
        d:parentid'="" obj.CTLOCDepDRSetObjectId(parentid)
        s logJson="{CTLOCRowID:"""_id_""",CTLOCDepDR:"""_parentid_"""}"
    }
    elseif(rule="CTLOCType"){
        s bCTLOCType = obj.CTLOCType
        s blogJson="{CTLOCRowID:"""_id_""",CTLOCType:"""_bCTLOCType_"""}"
        
        s obj.CTLOCType = parentid
        s logJson="{CTLOCRowID:"""_id_""",CTLOCType:"""_parentid_"""}"
    }
        
    Ts  
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc){
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}" //返回RowId
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("CT_Loc","User.CTLoc","科室病区",id,bCTLOCDesc,"U",logJson,blogJson)
    }else{
        Trollback
        s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
    }
    q result
}

/// chenying 
/// 2017-11-17
/// Table：CT_Loc ,PAC_Ward
/// 处理科室类型错误保存为W,OP,EM类型的数据  ,修改科室类型
/// 执行前需要确认: 这个科室目前对应的床位病区里没有床位数据！！如果有床位，不要执行。
/// Input：科室id，科室类型
/// Other: w ##class(web.DHCBL.CT.CTLoc).UpdateCTLOCType(1,"E")
ClassMethod UpdateCTLOCType(CTLOCRowId, CTLOCType) As %String
{
	q:CTLOCRowId="" ""
	s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",CTLOCRowId,0))
	if WARDRowID'=0
	{
		s BEDRowID=$o(^PAWARD(WARDRowID,"BED",0))
		if BEDRowID>0 q "该病区下有床位，不可修改成其他类型"
		
		s ROOMRowId=$o(^PAWARD(WARDRowID,"ROOM",0))  //PACWardRoom
		if ROOMRowId>0 q "该病区下有房间，不可修改成其他类型"
		
		//s $p(^PAWARD(WARDRowID),"^",5)=""
		//k ^PAWARD(0,"WARD_LocationDR",CTLOCRowId,WARDRowID)
		d ##class(User.PACWard).%DeleteId(WARDRowID)
		s ctlocobj=##class(User.CTLoc).%OpenId(CTLOCRowId)
		s ctlocobj.CTLOCType = CTLOCType
		s sc = ctlocobj.%Save()
		d ctlocobj.%Close()	
	}	
	q ""
}

/// 基础数据平台-likefan
/// 2020年8月17日
/// 修改科室时，如果组织部门关联Location表有这个科室，并且截止日期发生变化，则同步保存组织部门关联Location表的截止日期
/// Other: d ##class(web.DHCBL.CT.CTLoc).ChangeCTLocDateTo("","")
ClassMethod ChangeCTLocDateTo(rowid, dateto) As %String
{
	s re=""
	s ID=0
	for
	{
		s ID=$o(^User.CTDepartmentLocationD(ID)) q:ID=""
		s DEPLLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),3)		//Location来源
		s DEPLLocID=$lg($g(^User.CTDepartmentLocationD(ID)),4)			//Location rowid
		if (DEPLLocSource="CT_Loc")&&(DEPLLocID=rowid)
		{
			//保存组织部门关联Location表
			s obj=##class(User.CTDepartmentLocation).%OpenId(ID)
			s eobj=##class(web.Entity.CT.CTDepartmentLocation).%New()
		    s eobj.ID=ID
		    s:obj.DEPLDeptDR'="" eobj.DEPLDeptDR=obj.DEPLDeptDR.%Id()
			s eobj.DEPLLocSource=obj.DEPLLocSource
			s eobj.DEPLLocID=obj.DEPLLocID
			s eobj.DEPLLocCode=obj.DEPLLocCode
			s eobj.DEPLLocDesc=obj.DEPLLocDesc
			s eobj.DEPLParentLocSource=obj.DEPLParentLocSource
			s eobj.DEPLParentLocID=obj.DEPLParentLocID
			s eobj.DEPLParentLocCode=obj.DEPLParentLocCode
			s eobj.DEPLParentLocDesc=obj.DEPLParentLocDesc
			s eobj.DEPLDateFrom=obj.DEPLDateFrom
			s DEPLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(dateto)
			s eobj.DEPLDateTo=DEPLDateTo
			s re=##class(web.DHCBL.CT.CTDepartmentLocation).SaveEntity(eobj)
		}
	}
	q re
}

}
