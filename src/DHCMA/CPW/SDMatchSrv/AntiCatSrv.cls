/// AntiCat服务方法类
Class DHCMA.CPW.SDMatchSrv.AntiCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SDMatchSrv.AntiCatSrv","QryAntiCat")
Query QryAntiCat() As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,EName:%String,Resume:%String")
{
}

ClassMethod QryAntiCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SDMatch.AnticatD(xRowID))
	 	Quit:xRowID=""
	 	Set objAnticat        	= ##class(DHCMA.CPW.SDMatch.Anticat).GetObjById(xRowID)
	 	Set Code             	= objAnticat.BTCode
	 	Set Desc             	= objAnticat.BTDesc  
	 	Set EName          		= objAnticat.EName
	 	Set Resume          	= objAnticat.Resume
		Set Data=$lb(xRowID,Code,Desc,EName,Resume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryAntiCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// If there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCMA.CPW.SDMatchSrv.AntiCatSrv).GetCatJsonTree()
ClassMethod GetCatJsonTree() As %String
{
	Set xRowID=0,tmpArr=""
 	For
 	{
	 	Set xRowID        = $o(^DHCMA.CPW.SDMatch.AnticatD(xRowID))
	 	Quit:xRowID=""
	 	Set objAnticat        	= ##class(DHCMA.CPW.SDMatch.Anticat).GetObjById(xRowID)
	 	Set Code             	= objAnticat.BTCode
	 	Set Desc             	= objAnticat.BTDesc 
	 	Set:$l(Code)=1 tmpArr(Code)=Desc
	 	Set:$l(Code)=3 tmpArr($e(Code,1,1),Code)=Desc
	 	Set:$l(Code)=4 tmpArr($e(Code,1,1),$e(Code,1,3),Code)=Desc
	 	Set:$l(Code)=5 tmpArr($e(Code,1,1),$e(Code,1,3),$e(Code,1,4),Code)=Desc
 	}
 	Set Code1="",json=""
 	for {
	 		Set Code1=$o(tmpArr(Code1))
	 		Quit:Code1=""
	 		Set:json="" json="{"
	 		Set text=$g(tmpArr(Code1))
	 		Set text=$tr(text," ","")
	 		Set json=json_"""id"":"""_Code1_""","
	 		Set json=json_"""text"":"""_text_""","
	 		Set json=json_"""state"":"_"""open"""
	 		Set Code2="",code2Ind=0
	 		If ($d(tmpArr(Code1))>1) {
			 	Set json=json_","
		 		Set json=json_"""children"":"_"["
		 		for {
			 			
			 			Set Code2=$o(tmpArr(Code1,Code2))
		 				Quit:Code2="" 
		 				Set:code2Ind>0 json=json_","
		 				Set text=$g(tmpArr(Code1,Code2))
		 				Set json=json_"{""id"":"""_Code2_""","
				 		Set json=json_"""text"":"""_text_""","
				 		Set json=json_"""state"":"_"""closed"""
				 		If ($d(tmpArr(Code1,Code2))>1) {
					 			Set json=json_","
		 						Set json=json_"""children"":"_"["
		 						Set Code3="",code3Ind=0
		 						for {
						 			Set Code3=$o(tmpArr(Code1,Code2,Code3))
					 				Quit:Code3="" 
					 				Set:code3Ind>0 json=json_","
					 				Set text=$g(tmpArr(Code1,Code2,Code3))
					 				Set text=$tr(text," ","")
					 				Set json=json_"{""id"":"""_Code3_""","
							 		Set json=json_"""text"":"""_text_""""
							 		If ($d(tmpArr(Code1,Code2,Code3))>1) {
							 			Set json=json_","
				 						Set json=json_"""children"":"_"["
				 						Set Code4="",code4Ind=0
				 						for {
								 			Set Code4=$o(tmpArr(Code1,Code2,Code3,Code4))
							 				Quit:Code4="" 
							 				Set:code4Ind>0 json=json_","
							 				Set text=$g(tmpArr(Code1,Code2,Code3,Code4))
							 				Set text=$tr(text," ","")
							 				Set json=json_"{""id"":"""_Code4_""","
									 		Set json=json_"""text"":"""_text_""""
									 		Set json=json_"}"
									 		Set code4Ind=code4Ind+1
							 				}
							 				Set json=json_"]"
							 		}
							 		Set json=json_"}"
							 		Set code3Ind=code3Ind+1
					 				}
					 				Set json=json_"]"
					 		}
				 		Set json=json_"}"
				 		Set code2Ind=code2Ind+1
			 		}
			 		Set json=json_"]"
	 		}
	 	}
	 Set:json'="" json=json_"}"
	Quit json
}

/// w ##class(DHCMA.CPW.SDMatchSrv.AntiCatSrv).GetItemJsonTree(1245)
/// input 单病种值域字典ID
ClassMethod GetItemJsonTree(aQCItemDicId As %String = "", aChecked As %String = "", aKey As %String = "") As %String
{
	n (aQCItemDicId,aChecked,aKey)
	/*获取项目关联的抗菌药code串*/
	
	//新增判断如果aQCItemDicId为空返回undefined
	Quit:aQCItemDicId="" ""
	
	Set AntiCodeStr=##class(DHCMA.CPW.SDS.QCOptionMatchAntiSrv).GetAntiCodeStr(aQCItemDicId)
	Set xRowID=0,tmpArr=""
 	If aKey=""{
	 	For{
			Set xRowID        = $o(^DHCMA.CPW.SDMatch.AnticatD(xRowID))
		 	Quit:xRowID=""
		 	
		 	Set objAnticat        	= ##class(DHCMA.CPW.SDMatch.Anticat).GetObjById(xRowID)
		 	Set Code             	= objAnticat.BTCode
		 	Set Desc             	= objAnticat.BTDesc 
		 	Set:$l(Code)=1 tmpArr(Code)=Desc
		 	Set:$l(Code)=3 tmpArr($e(Code,1,1),Code)=Desc
		 	Set:$l(Code)=4 tmpArr($e(Code,1,1),$e(Code,1,3),Code)=Desc
		 	Set:$l(Code)=5 tmpArr($e(Code,1,1),$e(Code,1,3),$e(Code,1,4),Code)=Desc
	 	}
 	}Else{
	 	For
	 	{
		 	Set xRowID        		= $o(^DHCMA.CPW.SDMatch.AntiItemD(xRowID))
		 	Quit:xRowID=""
		 	
		 	Set objAntiItem        	= ##class(DHCMA.CPW.SDMatch.AntiItem).GetObjById(xRowID)
		 	Set Code             	= objAntiItem.BTCode
		 	Set Desc             	= objAntiItem.BTDesc 
		 	Set EName             	= objAntiItem.EName  
		 	Set IsActive          	= objAntiItem.IsActive
		 	Continue:IsActive'=1
			Continue:(Desc'[aKey)&&(EName'[aKey)
			
			Set objAnt1 = ##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode($e(Code,1,1))
			Continue:'$IsObject(objAnt1)
			Set tmpArr($e(Code,1,1))=objAnt1.BTDesc
			
			Set objAnt2 = ##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode($e(Code,1,3))
			Continue:'$IsObject(objAnt2)
			Set tmpArr($e(Code,1,1),$e(Code,1,3))=objAnt2.BTDesc 
			
			Set objAnt3 = ##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode($e(Code,1,4))
			Continue:'$IsObject(objAnt3)
			Set tmpArr($e(Code,1,1),$e(Code,1,3),$e(Code,1,4))=objAnt3.BTDesc 
			
			Set objAnt4 = ##class(DHCMA.CPW.SDMatch.Anticat).GetObjByCode($e(Code,1,5))
			Continue:'$IsObject(objAnt4)
			Set tmpArr($e(Code,1,1),$e(Code,1,3),$e(Code,1,4),$e(Code,1,5))=objAnt4.BTDesc
						
	 	}
	 	
	 }
	
 	Quit:$d(tmpArr)=1 ""
 	Set Code1="",json=""
 	for {
	 		Set Code1=$o(tmpArr(Code1))
	 		Quit:Code1=""
	 		Set:json="" json="{"
	 		Set text=$g(tmpArr(Code1))
	 		Set text=$tr(text," ","")
	 		Set json=json_"""id"":"""_Code1_""","
	 		Set json=json_"""text"":"""_text_""","
	 		Set json=json_"""state"":"_"""open"""
	 		Set Code2="",code2Ind=0
	 		If ($d(tmpArr(Code1))>1) {
			 	Set json=json_","
		 		Set json=json_"""children"":"_"["
		 		for {
			 			
			 			Set Code2=$o(tmpArr(Code1,Code2))
		 				Quit:Code2="" 
		 				Set:code2Ind>0 json=json_","
		 				Set text=$g(tmpArr(Code1,Code2))
		 				Set json=json_"{""id"":"""_Code2_""","
				 		Set json=json_"""text"":"""_text_""","
				 		Set json=json_"""state"":"_"""open"""
				 		If ($d(tmpArr(Code1,Code2))>1) {
					 			Set json=json_","
		 						Set json=json_"""children"":"_"["
		 						Set Code3="",code3Ind=0
		 						for {
						 			Set Code3=$o(tmpArr(Code1,Code2,Code3))
					 				Quit:Code3="" 
					 				Set:code3Ind>0 json=json_","
					 				Set text=$g(tmpArr(Code1,Code2,Code3))
					 				Set text=$tr(text," ","")
					 				Set json=json_"{""id"":"""_Code3_""","
							 		Set json=json_"""text"":"""_text_""""
							 		If ($d(tmpArr(Code1,Code2,Code3))>1) {
							 			Set json=json_","
				 						Set json=json_"""children"":"_"["
				 						Set Code4="",code4Ind=0
				 						for {
								 			Set Code4=$o(tmpArr(Code1,Code2,Code3,Code4))
							 				Quit:Code4="" 
							 				Set:code4Ind>0 json=json_","
							 				Set text=$g(tmpArr(Code1,Code2,Code3,Code4))
							 				Set text=$tr(text," ","")
							 				Set json=json_"{""id"":"""_Code4_""","
									 		Set json=json_"""text"":"""_text_""""
									 		//获取抗菌药医嘱信息
									 		Set rs=##Class(%ResultSet).%New("DHCMA.CPW.SDMatchSrv.AntiItemSrv:QryAntiItem")
										  	Set sc=rs.Execute(Code4)
										  	If $$$ISERR(sc) {
											  	Do $System.Status.DisplayError(sc)
											  	Continue
										  	}
										  	
										  	
										  	If (rs) { 
										  		Set json=json_","
										  		Set json=json_"""children"":"_"["
										  		Set Code5="",code5Ind=0
										  	}
										    While (rs.Next()){
									 				Set:code5Ind>0 json=json_","
									 				Set text=rs.Data("BTDesc")
									 				Set text=$tr(text," ","")
									 				Set Code5=rs.Data("BTCode")
									 				/*
									 				If ((aKey'="")&&(text'[aKey))
									 				{
											  			Set:code5Ind>0 code5Ind=0
											  			Continue
											  		}*/
									 				//根据表单值域对照信息判断是否被勾选
										  			Set ichecked="false"
										  			Set:AntiCodeStr[Code5 ichecked="true"
										  			If ((aChecked="true")&&(aChecked'=ichecked))
										  			{
											  			Set:code5Ind>0 code5Ind=0
											  			Continue
											  			}
									 				Set json=json_"{""id"":"""_Code5_""","
									 				Set json=json_"""checked"":"_ichecked_","
											 		Set json=json_"""text"":"""_text_""""
											 		Set json=json_"}"
											 		Set code5Ind=code5Ind+1
										 				
										    }
										    If (rs) { Set json=json_"]" }
									 		Set json=json_"}"
									 		Set code4Ind=code4Ind+1
							 				}
							 				Set json=json_"]"
							 		}
							 		Set json=json_"}"
							 		Set code3Ind=code3Ind+1
					 				}
					 				Set json=json_"]"
					 		}
				 		Set json=json_"}"
				 		Set code2Ind=code2Ind+1
			 		}
			 		Set json=json_"]"
	 		}
	 	}
	Set:json'="" json=json_"}"
	Quit json
}

}
