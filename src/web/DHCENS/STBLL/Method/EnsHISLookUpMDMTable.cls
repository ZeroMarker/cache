Class web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable Extends (%RegisteredObject, %XML.Adaptor)
{

/// -------------------------------------------------------------------------数据插入方法--------------------------------------------------------------
/// User.EnsHISLookUpMDMTab
/// Input:  EHLMMDMTableCode=CTNation&EHLMHISTableCode=CTNation&EHLMRemarks=民族字典表
/// W ##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).EHLMTableInsert("EHLMMDMTableCode=CTSex&EHLMHISTableCode=CTSex&EHLMDescription=性别字典表&EHLMRemarks=代码一致")
ClassMethod EHLMTableInsert(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set EHLMMDMTableCode=$zcvt($P($p(Input,"&",1),"=",2),"I","URL")
	set EHLMHISTableCode=$zcvt($P($p(Input,"&",2),"=",2),"I","URL")
	set EHLMDescription=$zcvt($P($p(Input,"&",3),"=",2),"I","URL")
	set EHLMRemarks=$zcvt($P($p(Input,"&",4),"=",2),"I","URL")
	set rowID=""
	set rowID=$o(^Config.ENS.EnsHISLookUpMDMTabI("IndexMHTabcode",EHLMMDMTableCode,EHLMHISTableCode,""))
	if rowID=""{
		set stream=##class(%GlobalCharacterStream).%New()
		set UserObj=##class(User.EnsHISLookUpMDMTab).%New()
		set UserObj.EHLMMDMTableCode=EHLMMDMTableCode
		set UserObj.EHLMHISTableCode=EHLMHISTableCode
		set UserObj.EHLMDescription=EHLMDescription
		set UserObj.EHLMRemarks=EHLMRemarks
		set UserObj.EHLMCreatDate=+$h
		set UserObj.EHLMCreatTime=$p($h,",",2)
		set UserObj.EHLMUpdateDate=+$h
		set UserObj.EHLMUpdateTime=$p($h,",",2)
		
		set tSC= UserObj.%Save()
		set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
		do stream.Write(retJson)	
 	    q stream
	}else{
		set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"已有此条数据"_$c(34)_"}"
		
		do stream.Write(retJson)	
 	    q stream
	}
	
	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_"插入失败"_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// -------------------------------------------------------------------------数据更新方法--------------------------------------------------------------
/// User.EnsHISLookUpMDMTab
/// Input: "3^EHLMMDMTableCode=CTMarital&EHLMHISTableCode=CTMarital&EHLMRemarks=婚姻字典表1"
/// W ##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).EHLMTableUpdate("3^EHLMMDMTableCode=CTMarital&EHLMHISTableCode=CTMarital&EHLMRemarks=婚姻字典表1")
ClassMethod EHLMTableUpdate(Input As %String) As %String
{
	
	set $zt="ErrorMsgs"
	set EHLMTableID=$p(Input,"^",1)
	set Content=$p(Input,"^",2)
	set EHLMMDMTableCode=$zcvt($P($p(Content,"&",1),"=",2),"I","URL")
	set EHLMHISTableCode=$zcvt($P($p(Content,"&",2),"=",2),"I","URL")
	set EHLMDescription=$zcvt($P($p(Content,"&",3),"=",2),"I","URL")
	set EHLMRemarks=$zcvt($P($p(Content,"&",4),"=",2),"I","URL")
	set stream=##class(%GlobalCharacterStream).%New()
	
	set TabRowId=""
	set TabRowId=$o(^Config.ENS.EnsHISLookUpMDMTabI("IndexEHLMTable",EHLMTableID,""))
	q:TabRowId=""
	set obj=##class(User.EnsHISLookUpMDMTab).%OpenId(TabRowId)
	set obj.EHLMMDMTableCode=EHLMMDMTableCode
	set obj.EHLMHISTableCode=EHLMHISTableCode
	set obj.EHLMDescription=EHLMDescription
	set obj.EHLMRemarks=EHLMRemarks
	set obj.EHLMUpdateDate=+$h
	set obj.EHLMUpdateTime=$p($h,",",2)
	set tSC=obj.%Save()
 	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)	
 	q stream		

	
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// -------------------------------------------------------------------------数据删除方法--------------------------------------------------------------
/// User.EnsHISLookUpMDMTab
/// Input: 表ID
/// W ##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).EHLMTableDelete("1")
ClassMethod EHLMTableDelete(Input As %String) As %String
{
	set $zt="ErrorMsgs"
	set tSC="0"
	set rowId=""	
	set stream=##class(%GlobalCharacterStream).%New()
	set rowId=$o(^Config.ENS.EnsHISLookUpMDMTabI("IndexEHLMTable",Input,""))
	q:rowId=""
	set obj=##class(User.EnsHISLookUpMDMTab).%OpenId(rowId)
	set tSC=obj.%DeleteId(rowId)
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_tSC_$c(34)_"}"
	do stream.Write(retJson)	
 	q stream
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()
	set retJson="{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}"
	d stream.Write(retJson)
	q stream
}

/// -------------------------------------------------------------------------数据查询方法--------------------------------------------------------------
/// User.EnsHISLookUpMDMTab
/// Input: 表ID
/// W ##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).GetEHLMTableInfo("","0","10")
ClassMethod GetEHLMTableInfo(SearchStr As %String = "", page As %String = "", rows As %String = "") As %String
{
	set $zt="ErrorMsgs"
	set rowId="",pid="0",rowData="",tmpData="",ESCNote=""
	set:page="" page="1"
	set:page="0" page="1"
	set:rows="" rows="2000"
	set startNum=(page-1)*rows
	set EndNum=page*rows
	
	set stream=##class(%GlobalCharacterStream).%New()
	do stream.Write("{"_$c(34)_"rows"_$c(34)_":[")
	
	set (EHLMTableID,EHLMHISTableCode,EHLMMDMTableCode,EHLMDescription,EHLMRemarks,EHLMCreatDateTime,EHLMUpdateDateTime)=""
	set Code=$ZCVT(SearchStr,"U"),EHLMTableID=""
	for  set EHLMTableID=$o(^Config.ENS.EnsHISLookUpMDMTabI("IndexEHLMTable",EHLMTableID)) q:EHLMTableID=""  d
	.set rowId=$o(^Config.ENS.EnsHISLookUpMDMTabI("IndexEHLMTable",EHLMTableID,""))
	.set EHLMHISTableCode=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),3)
	.set EHLMMDMTableCode=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),4)
	.set EHLMRemarks=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),5)
	.set EHLMDescription=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),10)		
	.set EHLMCreatDate=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),6)
	.set:EHLMCreatDate'="" EHLMCreatDate=$zd(EHLMCreatDate,3)
	.set EHLMCreatTime=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),7)
	.set:EHLMCreatTime'="" EHLMCreatTime=$zt(EHLMCreatTime,1)
	.set EHLMCreatDateTime=EHLMCreatDate_" "_EHLMCreatTime
	.set EHLMUpdateDate=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),8)
	.set:EHLMUpdateDate'="" EHLMUpdateDate=$zd(EHLMUpdateDate,3)
	.set EHLMUpdateTime=$lg(^Config.ENS.EnsHISLookUpMDMTabD(rowId),9)
	.set:EHLMUpdateTime EHLMUpdateTime=$zt(EHLMUpdateTime,1)
	.set EHLMUpdateDateTime=EHLMUpdateDate_" "_EHLMUpdateTime
	.set EHLMHISTableCodeU=$zcvt(EHLMHISTableCode,"U"),EHLMMDMTableCodeU=$zcvt(EHLMMDMTableCode,"U")
	.if SearchStr'="" d
	..if ((Code[EHLMHISTableCodeU)||(EHLMHISTableCodeU[Code)||(Code[EHLMMDMTableCodeU)||(EHLMMDMTableCodeU[Code))  d
	...set pid=pid+1
	...q:(pid<=startNum)
	...q:pid>EndNum
	...set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"EHLMTableID"_$c(34)_":"_$c(34)_EHLMTableID_$c(34)_","_$c(34)_"EHLMHISTableCode"_$c(34)_":"_$c(34)_EHLMHISTableCode_$c(34)_","_$c(34)_"EHLMMDMTableCode"_$c(34)_":"_$c(34)_EHLMMDMTableCode_$c(34)_","_$c(34)_"EHLMDescription"_$c(34)_":"_$c(34)_EHLMDescription_$c(34)_","_$c(34)_"EHLMRemarks"_$c(34)_":"_$c(34)_EHLMRemarks_$c(34)_","_$c(34)_"EHLMCreatDateTime"_$c(34)_":"_$c(34)_EHLMCreatDateTime_$c(34)_","_$c(34)_"EHLMUpdateDateTime"_$c(34)_":"_$c(34)_EHLMUpdateDateTime_$c(34)_"}"
    ...i rowData="" d
	....set rowData=tmpData
	...e  d
	....set rowData=rowData_","_tmpData
	.if SearchStr="" d
	..set pid=pid+1
	..q:(pid<=startNum)
	..q:pid>EndNum                                         
	..set tmpData="{"_$c(34)_"pid"_$c(34)_":"_pid_","_$c(34)_"EHLMTableID"_$c(34)_":"_$c(34)_EHLMTableID_$c(34)_","_$c(34)_"EHLMHISTableCode"_$c(34)_":"_$c(34)_EHLMHISTableCode_$c(34)_","_$c(34)_"EHLMMDMTableCode"_$c(34)_":"_$c(34)_EHLMMDMTableCode_$c(34)_","_$c(34)_"EHLMDescription"_$c(34)_":"_$c(34)_EHLMDescription_$c(34)_","_$c(34)_"EHLMRemarks"_$c(34)_":"_$c(34)_EHLMRemarks_$c(34)_","_$c(34)_"EHLMCreatDateTime"_$c(34)_":"_$c(34)_EHLMCreatDateTime_$c(34)_","_$c(34)_"EHLMUpdateDateTime"_$c(34)_":"_$c(34)_EHLMUpdateDateTime_$c(34)_"}"
    ..i rowData="" d
	...set rowData=tmpData
	..e  d
	...set rowData=rowData_","_tmpData	
		
	do stream.Write(rowData_"]"_","_$c(34)_"total"_$c(34)_":"_$c(34)_pid_$c(34)_"}")
	
 	q stream 
ErrorMsgs
	set stream=##class(%GlobalCharacterStream).%New()	
	do stream.Write("{"_$c(34)_"data"_$c(34)_":"_$c(34)_$ze_$c(34)_"}")	
 	q stream
}

/// 表：User.User.BDPTableList
/// Others：d ##class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable","GetHISTable","^^^^ALL")
Query GetHISTable(Input As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String")
{
}

ClassMethod GetHISTableExecute(ByRef QHandle As %Binary, Input As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set startRow=0,endRow=0,totalNum=0
	
	set QHandle=$lb(0,repid,0)
	set rowId=""
	for  set rowId=$o(^User.BDPTableListD(rowId))  q:rowId=""  d
	.set code=$lg(^User.BDPTableListD(rowId),8)
		
	.set desc=$lg(^User.BDPTableListD(rowId),3)
	
	.set ^CacheTemp(repid,ind)=$lb(rowId,code,desc)
	.set ind=ind+1
	Quit $$$OK
}

ClassMethod GetHISTableClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetHISTableFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEnsInterfaceDataExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

///  CT_Marital	婚姻		CT_Marital	基础数据平台	^CT("MAR"
/// w ##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).ExcelImportTable("0&[{""数据中心表编码"":""CT_StockCategorySubGroup"",""对应东华HIS表"":""INC_StkCat,DHC_StkCatGrpRelations"",""数据中心表名称"":""库存分类"",""备注说明"":""""}]")
ClassMethod ExcelImportTable(input) As %String
{
	set startC=$p(input,"&",1)
	set DataStrs=$zcvt($p(input,"&",2),"I","URL")
	set stream=##class(%GlobalCharacterStream).%New()
	set $zt="Exception"
	set rtnObj=##class(%DynamicObject).%New()
	set errorsInfos=##class(%DynamicArray).%New()
	set numFail=0,numSucc=0,len=0
	
	set jObjects = {}.%FromJSON(DataStrs) ;转化成json数组
	set len=jObjects.%Size() ;获取数组长度
	do rtnObj.%Set("total",len) ;设置数据总条数	
	for i=1:1:len{
		set jObject=jObjects.%Get(i-1)
		set DataStr=jObject.%ToJSON()
		set DataStr=##class(ext.util.JsonObject).FromJSON(DataStr)
		set EHLMMDMTableCode=DataStr.GetValue("数据中心表编码")
		set EHLMHISTableCode=DataStr.GetValue("对应东华HIS表")
		set EHLMDescription=DataStr.GetValue("数据中心表名称")
		set EHLMRemarks=DataStr.GetValue("备注说明")
		if ((EHLMMDMTableCode'="")&&(EHLMHISTableCode'="")){
			set rowID=$o(^Config.ENS.EnsHISLookUpMDMTabI("IndexMHTabcode",EHLMMDMTableCode,EHLMHISTableCode,""))
			if rowID'=""  ///判断是否重复插入
			{
				set errorsInfo=##class(%DynamicObject).%New()	
				do errorsInfo.%Set("code","失败")
				do errorsInfo.%Set("desc","第【"_(startC+i)_"】条数据：MDM字典代码【"_EHLMMDMTableCode_"】和HIS字典代码【"_EHLMHISTableCode_"】插入重复")
				do errorsInfos.%Push(errorsInfo)
			}else{
				/*set Flag=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).HISTableFlag(EHLMHISTableCode)
		        if Flag="0"  ///判断HIS字典表代码是否存在于表BDPTableList.ClassName中
		        {
			        set errorsInfo=##class(%DynamicObject).%New()	
					do errorsInfo.%Set("code","失败")
					do errorsInfo.%Set("desc","第【"_(startC+i)_"】条数据,插入失败.【"_EHLMHISTableCode_"】不能匹配表BDPTableList.className")
					do errorsInfos.%Push(errorsInfo)
			        
			    }elseif (Flag="1"){
				    */
				   	set UserObj=##class(User.EnsHISLookUpMDMTab).%New()
				    set UserObj.EHLMMDMTableCode=EHLMMDMTableCode
					set UserObj.EHLMHISTableCode=EHLMHISTableCode
					set UserObj.EHLMDescription=EHLMDescription
					set UserObj.EHLMRemarks=EHLMRemarks
					set UserObj.EHLMCreatDate=+$h
					set UserObj.EHLMCreatTime=$p($h,",",2)
					set UserObj.EHLMUpdateDate=+$h
					set UserObj.EHLMUpdateTime=$p($h,",",2)
					set tSC= UserObj.%Save()
					if tSC="1" {
						set numSucc=numSucc+1
					}else{
						set errorsInfo=##class(%DynamicObject).%New()	
						do errorsInfo.%Set("code","失败")
						do errorsInfo.%Set("desc","第【"_(startC+i)_"】条数据,MDM字典代码【"_EHLMMDMTableCode_"】插入失败")
						do errorsInfos.%Push(errorsInfo)
					}
				//}
		
			}
		}elseif((EHLMMDMTableCode="")&&(EHLMHISTableCode'="")){
			set errorsInfo=##class(%DynamicObject).%New()	
			do errorsInfo.%Set("code","失败")
			do errorsInfo.%Set("desc","第【"_(startC+i)_"】条数据中,HIS字典表【"_EHLMHISTableCode_"】对应的MDM字典表代码为空")
			do errorsInfos.%Push(errorsInfo)
		}elseif ((EHLMMDMTableCode'="")&&(EHLMHISTableCode="")){
			set errorsInfo=##class(%DynamicObject).%New()	
			do errorsInfo.%Set("code","失败")
			do errorsInfo.%Set("desc","第【"_(startC+i)_"】条数据中,MDM字典表【"_EHLMMDMTableCode_"】对应的HIS字典表为空")
			do errorsInfos.%Push(errorsInfo)
		}elseif ((EHLMMDMTableCode="")&&(EHLMHISTableCode="")){
		    set errorsInfo=##class(%DynamicObject).%New()	
			do errorsInfo.%Set("code","失败")
			do errorsInfo.%Set("desc","第【"_(startC+i)_"】条数据中,HIS字典表和MDM字典表为空值")
			do errorsInfos.%Push(errorsInfo)
		}
		
		
	
	}

	set numFail=len-numSucc
	
	do rtnObj.%Set("fail",numFail)
	do rtnObj.%Set("success",numSucc)
	do rtnObj.%Set("info",errorsInfos)
	b ; rtnObj
	q rtnObj.%ToJSON()
	


	
Exception
	do rtnObj.%Set("total",len)
	do rtnObj.%Set("fail",numFail)
	do rtnObj.%Set("success",numSucc)
	do rtnObj.%Set("info",errorsInfos)	
	
	q rtnObj.%ToJSON()
}

/// 验证 入参 与 User.BDPTableList表中ClassName 是否对应
/// 表：User.BDPTableList
/// w ##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).HISTableFlag("na")
ClassMethod HISTableFlag(input As %String) As %String
{
	set $zt="Exception"
	/**    	
	SQLCODE = 0 表示SQL操作成功完成。对于SELECT语句，这通常意味着从表中成功检索数据。
	SQLCODE = 100 表示​​SQL操作已成功，但是找不到要执行的数据
	**/
	&sql(select * from SQLUser.BDP_TableList where CHARINDEX(ClassName,:input)>0)
	if SQLCODE="0"{
		q "1"
	}else{
		q "0"
	}	
	
Exception
	Quit "-1^"_$ze
}

}
