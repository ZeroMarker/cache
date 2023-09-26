Import SQLUser

Class web.DHCPRESCDicScheme Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Descript:输出所有科室id、科室名、科室代码
/// Creator:huanghongping
/// Tbable:CT_Loc
/// CreatDate: 2021/9/5
/// Input: 科室名
/// OutPut: 科室id、科室名、科室代码
/// Debug: w ##class(web.DHCPRESCDicScheme).GetAllCTLoc("","","nfm")
ClassMethod GetAllCTLoc(Value As %String = "", Hosp As %String = "", q As %String = "", handStaus As %String = "") As %String
{
	   n (Value,Hosp,q,handStaus)
	   
	   s id=0,count=0
	   w "["
	   for
	   {
		   s id=$o(^CTLOC(id))   q:id=""
		   s ctloc=$p(^CTLOC(id),"^",2)
		   s ctLocHosp=$p(^CTLOC(id),"^",22)  
		   s dateFrom = $p(^CTLOC(id),"^",24)
		   s dateActiveTo = $p(^CTLOC(id),"^",25) 
		   s activeFlag = $p(^CTLOC(id),"^",14)
		   s isAuthFlag = ##class(web.DHCPRESCInterface).IsAuditAuth(id)
		   continue:(dateFrom>+$h)&(dateFrom'="")
		   continue:(dateActiveTo'="")&&(dateActiveTo<+$h) 
		   continue:(activeFlag'="")&&(activeFlag'="Y")                                    
		   continue:(Hosp'="")&&(ctLocHosp'=Hosp)		 //Shy 2023-01-04  添加院区过滤
		   continue:(handStaus=1)&&(isAuthFlag'="Y")
		  
		   s ctcode=$p(^CTLOC(id),"^",1)
		   s CtLocType=$p(^CTLOC(id),"^",13)
		   s CtLocDep=$p(^CTLOC(id),"^",19)
		   s CtLocDepDr=$o(^RBC("DEP",0,"Desc","临床科室",""))
		   i (CtLocType'="E")                    //过滤急诊类型     
		   {
				continue   
		   }
		   s LocPY = $p(^CTLOC(id),"^",43)
		   s LocPY = $$ALPHAUP^SSUTIL4(LocPY)
		   i (Value'="")&&(ctloc'[Value)&&(LocPY'[$$ALPHAUP^SSUTIL4(Value))                        // 科室名不包含就跳过此次循环，用于搜索
		   {
				continue    
		   } 
		   i (q'="")&&(ctloc'[q)&&(LocPY'[$$ALPHAUP^SSUTIL4(q))                         // 科室名不包含就跳过此次循环，用于搜索
		   {
				continue    
		   } 
		   s ListTitle="ctloc^id^ctcode"
		   s listData=ctloc_"^"_id_"^"_ctcode
		   s count=count+1

		   i (count=1)
		   {
			   w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,listData)
		   }
		   else
		   {
			   w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,listData) 
		   }	   
	     }
	   w "]"
	   q ""
}

/// Descript: 输出所有已经选择科室及相关列
/// CreatDate: 2021/9/5
/// Creator:huanghongping
/// Tbable:CF_PHA_PREADT.DicScheme,CF_PHA_PREADT.SchLinkLoc
/// Input: 登录用户ID
/// Output: ID、描述、代码、登录名
/// Debug: w ##class(web.DHCPRESCDicScheme).GetSetFiel(18946)
/// Others: ^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",69,56)
ClassMethod GetSetFiel(ForNameID As %String) As %String
{
	n (ForNameID)
	s ^temptest("ForNameID") = ForNameID
	s id="",count=0
	s itemID=$o(^CF.PHA.PREADT.DicSchemeI("UserIndex",ForNameID,""))
	w "["
	for
	{
		
		s ctlocName="",ctlocCode=""
		s id=$o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",itemID,id)) q:id=""
		s type=$lg(^CF.PHA.PREADT.SchLinkLocD(id),4)
		b //2
		i (type="CTLoc")
		{
			b //1
			s ctlocID=$lg(^CF.PHA.PREADT.SchLinkLocD(id),3)
			s ctlocName=$p(^CTLOC(ctlocID),"^",2)  //科室名称
			s ctlocCode=$p(^CTLOC(ctlocID),"^",1)  //科室代码		
		}
		i (type="DrugLib")
		{
			s DrugID=$lg(^CF.PHA.PREADT.SchLinkLocD(id),3)
			s ctlocName=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugID)),3) //药品目录描述
			s ctlocCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugID)),2) //药品目录代码
		}
		i (type="MedType")
		{
			s medID=$lg(^CF.PHA.PREADT.SchLinkLocD(id),3)
			s:medID=1 ctlocName="西药方",ctlocCode="westMed" 
			s:medID=2 ctlocName="中成药",ctlocCode="chinMed"
			s:medID=3 ctlocName="中草药",ctlocCode="herbMed"
			
		}
		s LogUserName=$p(^SSU("SSUSR",ForNameID),"^",2)	
		s ListTitle="id^ctlocName^LogUserName^ctlocCode"
		s listData=id_"^"_ctlocName_"^"_LogUserName_"^"_ctlocCode
		s count=count+1
		i (count=1)
		{
			w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,listData)
		}
		else
		{
		w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,listData) 
		}	   
	}
	w "]"
	q ""
}

/// 分配方案维护关联表插入数据
/// CreatDate: 2021/9/5
/// Creator:huanghongping
/// Tbable:CF_PHA_PREADT.SchLinkLoc
/// Input: 用户ID、描述及代码
/// Output: 插入结果值
/// Debug: w ##class(web.DHCPRESCDicScheme).SaveExpField("11870","呼吸内科^ZYZY001&&用法用量^RuleUsage&&西药方^westMed")
/// Others:w $O(^CTLOC(0,"Code","ZYMZ001",""))
/// Others: 呼吸内科门诊^ZYMZ001&&胃肠外科门诊^ZYMZ011
ClassMethod SaveExpField(UserId As %String, Params As %String) As %String
{
	n (UserId,Params)
	s ^Temp("SaveExpField")=$lb(UserId,Params)
	s itemRowID=..InsField(UserId)			//获取分配方案维护表主键
	s result=0,type="",atDr=""
	s len=$L(Params,"&&")
	s $zt="Erp"
	ts
	f i=1:1:len                     //遍历插入科室主键
	{
		
		q:result=-1 
		s atobj=$p(Params,"&&",i)
		s atobjName=$P(atobj,"^",1)
		s atobjCode=$p(atobj,"^",2)
		b //1
		i ($d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(atobjName)))&&$d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(atobjCode))))
		{
			b //2
			s type="CTLoc"
			s atDr=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(atobjCode),""))		
		}
		elseif ($d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(atobjName)))&&$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(atobjCode))))
		{
			b //3
			s type="DrugLib"
			s atDr=$O(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(atobjCode),""))	
		}
		elseif ((atobjCode="westMed")||(atobjCode="chinMed")||(atobjCode="herbMed"))
		{
			b //6
			s:atobjCode="westMed" type="MedType",atDr=1   //西药方
			s:atobjCode="chinMed" type="MedType",atDr=2	  //中成药
			s:atobjCode="herbMed" type="MedType",atDr=3	  //中草药			
		}
		i ('$d(^CF.PHA.PREADT.SchLinkLocI("ItemTypeDrIndex",itemRowID,type,atDr)))
		{
			b //4
			&SQL(INSERT INTO CF_PHA_PREADT.SchLinkLoc (PSL_Item_DR, PSL_At_DR, PSL_Type)VALUES (:itemRowID,:atDr,:type))	
			i (SQLCODE'=0)
			{
			 	s result=-1 
			}	
		}
			
	}
	i (result=0){
	 	tc	
	}
	else
	{
		tro	
	}
	q result
Erp
	tro
	q result
}

/// Descript: 分配方案维护表插入数据
/// CreatDate: 2021/9/5
/// Creator:huanghongping
/// Tbable:CF_PHA_PREADT.DicScheme
/// Input: 用户ID
/// Output: 插入结果值
/// Debug: w ##class(web.DHCPRESCDicScheme).InsField("1,3")
ClassMethod InsField(UserId As %String) As %String
{
	n (UserId)
	s Date=+$h
	s Desc="默认方案"
	s Status="离线" //资源分配时默认为离线 qnp 2022-03-30
	//s Status="在线"
	//s len=$l(UserIds,",")
	s Result=""
	//f i=1:1:len
	//{
	//s UserId=$p(UserIds,",",i)
	i ($d(^CF.PHA.PREADT.DicSchemeI("UserIndex",UserId)))
	{
		&SQL(SELECT ID INTO:ROWID FROM CF_PHA_PREADT.DicScheme WHERE PDS_User_Dr=:UserId)
		s Result=ROWID	
	}
	else
	{
		&SQL(INSERT INTO SQLUser.CF_PHA_PREADT.DicScheme (PDS_User_Dr, PDS_ScDesc, PDS_Date, PDS_Staus)
    	VALUES ( :UserId,:Desc,:Date,:Status))
    	i (SQLCODE=0)
    	{
	   		s Result=%ROWID	    
		} 			
	}
	
	//}  
	q Result
}

/// Descript:输出所有药师及关联科室
/// CreateDate: 2021/9/26
/// Creator: huanghongping
/// Table: SS_User
/// Input: 搜索项
/// Output: 医院名、药师ID、药师名、监测科室列
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCPRESCDicScheme","GetAllPLCtLoc","")
Query GetAllPLCtLoc(SearchString As %String) As websys.Query(ROWSPEC = "RowId:%String,HosDesc:%String,LoginId:%String,LoginName:%String,CtStr:%String")
{
}

ClassMethod GetAllPLCtLocExecute(ByRef qHandle As %Binary, SearchString As %String) As %Status
{
	n (SearchString,qHandle)
	s repid=$i(^CacheTemp)
    s ind=1
    ///代码开始
    s RowId=0
	f
	{
		s CtStr=""
		s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""
		s ProvDr=$p($g(^SSU("SSUSR",RowId)),"^",14)
		i (ProvDr="")
		{
			continue	
		}
		s ProvTpDr=$p($g(^CTPCP(ProvDr,1)),"^",4)
		s Type=$p($g(^CT("CPT",ProvTpDr)),"^",4)
		i (Type'="Pharmacist")
		{
			continue    
		}
		s CtlocDr=$p(^SSU("SSUSR",RowId),"^",4)
		i (CtlocDr="")
		{
			continue	
		}
		s HospDr=$P(^CTLOC(CtlocDr),"^",22)
		s HosDesc=$p(^CT("HOSP",HospDr),"^",2)
		s LoginId=$p(^SSU("SSUSR",RowId),"^",1)
		s LoginName=$p(^SSU("SSUSR",RowId),"^",2)
		i ((LoginId'[SearchString)&(LoginName'[SearchString))
		{
			continue	
		}
		s PdsRowId=$o(^CF.PHA.PREADT.DicSchemeI("UserIndex",RowId,""),-1)
		i (PdsRowId'="")
		{	
			s PdsLocRowId=0
			f
			{
				s PdsLocRowId=$o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",PdsRowId,PdsLocRowId))
				q:PdsLocRowId=""
				s CtlocId=$lg(^CF.PHA.PREADT.SchLinkLocD(PdsLocRowId),3)
				s CtlocType=$lg(^CF.PHA.PREADT.SchLinkLocD(PdsLocRowId),4)
				i (CtlocType="CTLoc")
				{
					s CtlocName=$P(^CTLOC(CtlocId),"^",2)
				}
				i (CtlocType="DrugLib")
				{
					s CtlocName=$lg(^CT.CKB.PDSS.CommonDictionD(CtlocId),3)	
				}
				i (CtlocType="MedType")
				{
					s:CtlocId=1 CtlocName="西药方"
					s:CtlocId=2 CtlocName="中成药"
					s:CtlocId=3 CtlocName="中草药"	
				}
				s CtStr=CtStr_CtlocName_","
				
			}
		}
		s CtStr=$e(CtStr,1,$l(CtStr)-1)
		d OutputLink	  	
	}
	
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputLink
	s Data=$lb(RowId,HosDesc,LoginId,LoginName,CtStr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

/// Descript: 删除科室、药品目录、处方类型
/// CreateDate: 2021/12/7
/// Creator: huanghongping
/// Input: 代码、用户ID
/// Output: 删除结果值
/// Debug: w ##class(web.DHCPRESCDicScheme).deleteItemCtloc("","")
ClassMethod deleteItemCtloc(ctlocCode, userID)
{
	n (ctlocCode,userID)
	s result=0
	ts
	s itemID=$o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userID,""))
	i ($d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(ctlocCode))))
	{
		s ctlocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(ctlocCode),""))
		s ID=$o(^CF.PHA.PREADT.SchLinkLocI("ItemTypeDrIndex",itemID,"CTLoc",ctlocID,""))	
		&SQL(DELETE FROM CF_PHA_PREADT.SchLinkLoc WHERE ID=:ID)
		i (SQLCODE'=0)
		{
			s result=-1	
		}	
	}
	i ($d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(ctlocCode))))
	{
		s drugId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(ctlocCode),""))
		s ID=$o(^CF.PHA.PREADT.SchLinkLocI("ItemTypeDrIndex",itemID,"DrugLib",drugId,""))	
		&SQL(DELETE FROM CF_PHA_PREADT.SchLinkLoc WHERE ID=:ID)
		i (SQLCODE'=0)
		{
			s result=-1	
		}	
	}
	i ((ctlocCode="westMed")||(ctlocCode="chinMed")||(ctlocCode="herbMed"))
	{
		s:ctlocCode="westMed" medId=1
		s:ctlocCode="chinMed" medId=2
		s:ctlocCode="herbMed" medId=3
		s ID=$o(^CF.PHA.PREADT.SchLinkLocI("ItemTypeDrIndex",itemID,"MedType",medId,""))	
		&SQL(DELETE FROM CF_PHA_PREADT.SchLinkLoc WHERE ID=:ID)
		i (SQLCODE'=0)
		{
			s result=-1	
		}	
	}
	i (result=-1)
	{
		tro
	}
	i (result=0)
	{
	   	tc	
	}
	q result
}

/// Descript: 查询所有药品目录
/// CreatDate:2021/12/7
/// Creator:huanghongping
/// Input: 翻页信息
/// Output: 药品目录代码、药品目录描述
/// Debug: w ##class(web.DHCPRESCDicScheme).ListDrugItem(1,1)
ClassMethod ListDrugItem(rows, page)
{
	n (rows,page)
	s end = page*rows
	s start=(page-1)*rows+1
	s parID=$o(^CT.CKB.PDSS.CommonDictionI("Code","DRUGLIBARYDATA",""))
	s id="",count=0
	w "{""rows"":["
	for{
		
		s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parID,id)) q:id=""
		s Code=$lg(^CT.CKB.PDSS.CommonDictionD(id),2)  //代码
		s Desc=$lg(^CT.CKB.PDSS.CommonDictionD(id),3)	//描述
		s showFlag = ##class(web.DHCCKBCommon).IsShow(id,"DHC_CKBCommonDiction")
		continue:showFlag'=1
		s count=count+1
		continue:count<start
		continue:count>end
		w $case(count,start:"",:",")
		s tmpObj={}
		s tmpObj.id=id
		s tmpObj.Code=Code
		s tmpObj.Desc=Desc
		w tmpObj.%ToJSON()	
	}
	w "],""total"":"_count_"}"
	q ""
}

}
