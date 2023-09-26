Class web.DHCCKBMon Extends %RegisteredObject
{

/// function:查询SQLUser.DHC_CKBMonMaster表下的内容
/// Author:wenlai
/// Date:2021/10/14
/// Table:DHC_CKBMonMater,PA_Adm,PA_PatMas,CT_Loc,SS_User
/// Debug:do ##class(%ResultSet).RunQuery("web.DHCCKBMon","GetCKBMonMasterList")
/// output:医疗机构代码，处方流水号，就诊ID，就诊流水号，审查时间，科室代码，科室名称，医生工号，姓名，是否通过，审查级别，审查备注
Query GetCKBMonMasterList() As websys.Query(ROWSPEC = "YLJGDM,CFLSH,PERSONID,JZLSH,SCSJ,KDKSDM,KDKSMC,KDYSGH,KDYSXM,SFTG,SFTG,SCJB,SCBZ") [ SqlProc ]
{
}

ClassMethod GetCKBMonMasterListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    set CMRowID = 0
    
    for
    {	    
		set CMRowID = $order(^CKB.PDSS.MonMasterD(CMRowID))	//处方ID
		quit:CMRowID=""		
		set MonData = $g(^CKB.PDSS.MonMasterD(CMRowID))
		set CMAdmDr = $lg(MonData,2) //就诊ID
		set CMHosp =  $lg(MonData,12) //医疗机构代码	
		if (CMAdmDr '= ""){
			set PAADMPAOMIDR = $piece($get(^PAADM(CMAdmDr)),"^",81)
			set PAPMINO = $piece($get(^PAPER(PAADMPAOMIDR,"PAT",1)),"^",2) 	//就诊流水号 
		}else{
			set PAPMINO = ""	
		}
		
		set CMCreateUser =  $lg(MonData,5) 	//开单医生姓名	
		//根据医生姓名取出工号	
		if (CMCreateUser '= ""){			
			set SSUSRRowID = $order(^SSU("SSUSR",0,"SSUSR_Name",CMCreateUser,""))
			if (SSUSRRowID '= ""){
				set SSUSRInitals = $piece($get(^SSU("SSUSR",SSUSRRowID)),"^",1)		//开单医生工号
			}else{
				set SSUSRInitals = ""
			}
		}else{
			set SSUSRInitals=""
		}
		
		set CMlocDesc =  $lg(MonData,6)	//开单科室名称
		//根据科室描述取出科室代码
		if (CMlocDesc '= ""){			
			set CTLocRowID = $order(^CTLOC(0,"Desc",CMlocDesc,""))
			
			if (CTLocRowID '= ""){
				set CTLocCode = $piece($get(^CTLOC(CTLocRowID)),"^",1)	//开单科室代码
			}else{
				set CTLocCode = ""	
			}
		}
		
		//审查时间
		set CMCreateTime = $zdate( $lg(MonData,3),3)_" "_$ztime( $lg(MonData,4))
		set CMPassFlag = $lg(MonData,7)	//是否通过
		set CMManLvDr = $lg(MonData,8)	//审查级别
		set CMAduitNotes = $lg(MonData,19) //审查备注
		
		do OutputRow  

	}
   
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
OutputRow
    set ^CacheTemp(repid,ind)=$lb(CMHosp,CMRowID,CMAdmDr,PAPMINO,CMCreateTime,CTLocCode,CMlocDesc,SSUSRInitals,CMCreateUser,CMPassFlag,CMManLvDr,CMAduitNotes)
    Set ind=ind+1
    quit
}

/// function:查询SQLUser.DHC_CKBMonQueList表下的内容
/// Author:wenlai
/// Date:2021/10/14
/// Table:DHC_CKBMonQueList,DHC_CKBMonMaster
/// Debug:do ##class(%ResultSet).RunQuery("web.DHCCKBMon","GetCKBMonQueList")
/// Output:医疗机构代码，处方id，药品代码，药品名称，级别，审查问题分类，提示信息
Query GetCKBMonQueList() As websys.Query(ROWSPEC = "YLJGDM,CFLSH,YPDM,YPMC,SCJB,SCWTFL,TSXX") [ SqlProc ]
{
}

ClassMethod GetCKBMonQueListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
    s ind=1
 
 	//set CMRowID = 0
 	set CMRowID = 6924900
 	for{
	 	
	 	set CMRowID = $order(^CKB.PDSS.MonQueListD(CMRowID))
	 	quit:CMRowID=""
	 	set MQLData = $g(^CKB.PDSS.MonQueListD(CMRowID))
	 	set CMParrfDr = $lg(MQLData,2)	//处方id
	 	set MonData = $g(^CKB.PDSS.MonMasterD(CMParrfDr))
	 	set CMHosp = $lg(MonData,12) //医疗机构代码
	 	
	 	set CMItemDr = $lg(MQLData,3)
	 	set CDCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(CMItemDr)),2)	//药品代码
	 	set CDDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(CMItemDr)),3)	//药品名称
	 	
	 	set CMManLevDr = $lg(MQLData,7)	
	 	if (CMManLevDr '= ""){
	 		set CMManLevDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(CMManLevDr)),2)	//级别
	 	}
	 	
		set result = $lg(MonData,10)
		set resultObj = ##class(%DynamicArray).%FromJSON(result)
		set valArr = []
		
		//先取JSON串中的items数组
		set itemsArr = resultObj.items	
		set length = itemsArr.%Size()		
		for i=0:1:length-1
		{
			//items数组中的对象,取warn
			set itemObj = itemsArr.%Get(i)
			set warnArr = itemObj.warns
			set warnLength = warnArr.%Size()
			
			//遍历warn数组，取warn对象
			for j=0:1:warnLength-1
			{
				//warn数组中的对象，取itms
				set warnObj = warnArr.%Get(j)
				set itmsArr = warnObj.itms
				set itmsLength = itmsArr.%Size()
	
				for k=0:1:itmsLength-1
				{
					//itms中的对象，取subitms
					set itmsObj = itmsArr.%Get(k)
					set subitmsArr = itmsObj.itms
					set subitmsLength = subitmsArr.%Size()
					
					for l=0:1:subitmsLength-1
					{
						set subitmsObj = subitmsArr.%Get(l)
						set val = subitmsObj.val
						do valArr.%Push(val)	
					}
				}	
			}
				
		}
		
		set CMExRes = valArr.%ToJSON()	//审查分类	
			 	
	 	set CMTipsMsg = $lg(MQLData,6)	//提示信息
	 	
	 	do OutputRow
	 	
	 }
	 
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
 
OutputRow
    set ^CacheTemp(repid,ind)=$lb(CMHosp,CMParrfDr,CDCode,CDDesc,CMManLevDr,CMExRes,CMTipsMsg)
    Set ind=ind+1
    quit
}

}
