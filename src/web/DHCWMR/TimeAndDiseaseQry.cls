Class web.DHCWMR.TimeAndDiseaseQry Extends %Persistent
{

ClassMethod GetSexDesc(Sex As %Library.String) As %String
{
	i Sex=""  q ""
	i +Sex=1  q "男"
	i +Sex=2  q "女"
	q "未定义"
}

ClassMethod CreateRelCon(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>AND</option>"
	w "<option value=2>OR</option>"
	w "</select>",!
}

ClassMethod CreateComCon(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>LIKE</option>"
	w "<option value=2>=</option>"
	w "<option value=3>></option>"
	w "<option value=4><</option>"
	w "<option value=5>>=</option>"
	w "<option value=6><=</option>"
	w "<option value=7><></option>"
	w "</select>",!
}

ClassMethod CreateDesCon(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>ICD</option>"
	w "<option value=2>名称</option>"
	w "<option value=3>疾病转归</option>"
	w "<option value=4>主诊断</option>"
	w "<option value=5>其他诊断</option>"
	w "<option value=6>术者</option>"
	w "<option value=7>一助</option>"
	w "<option value=8>二助</option>"
	w "<option value=9>麻醉类型</option>"
	w "<option value=10>麻醉医师</option>"
	w "<option value=11>切口愈合</option>"
	w "<option value=12>类别</option>"
	w "<option value=13>位置</option>"
	w "<option value=14>备注</option>"
	w "<option value=15>手术日期</option>"
	w "<option value=16>疾病或手术类别</option>"
	w "</select>",!
}

ClassMethod CreateIPCon(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>住院日期</option>"
	w "<option value=2>出院日期</option>"
	w "<option value=3>住院科室</option>"
	w "<option value=4>出院科室</option>"
	w "<option value=5>住院天数</option>"
	w "</select>",!
}

ClassMethod CreatePatCon(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>病人姓名</option>"
	w "<option value=2>姓名拼音</option>"
	w "<option value=3>性别</option>"
	w "<option value=4>生日</option>"
	w "<option value=5>年龄</option>"
	w "<option value=6>婚姻</option>"
	w "<option value=7>职业</option>"
	w "<option value=8>出生市</option>"
	w "<option value=9>出生县</option>"
	w "<option value=10>民族</option>"
	w "<option value=11>国籍</option>"
	w "<option value=12>身份证号</option>"
	w "<option value=13>工作单位</option>"
	w "<option value=14>工作单位电话</option>"
	w "<option value=15>工作单位邮编</option>"
	w "<option value=16>家庭住址</option>"
	w "<option value=17>家庭电话</option>"
	w "<option value=18>家庭邮编</option>"
	w "<option value=19>与联系人关系</option>"
	w "<option value=20>联系人</option>"
	w "<option value=21>联系人电话</option>"
	w "<option value=22>联系人地址</option>"
	
	w "</select>",!
}

ClassMethod CreateAddCon(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>附加项</option>"
	w "</select>",!
}

ClassMethod CreateSequence(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=1>病案号</option>"
	w "<option value=2>登记号</option>"
	w "<option value=3>姓名</option>"
	w "<option value=4>性别</option>"
	w "<option value=5>年龄</option>"
	w "<option value=6>身份证号</option>"
	w "<option value=7>出院日期</option>"
	w "<option value=8>出院科室</option>"
	w "<option value=9>住院天数</option>"
	w "<option value=10>诊断</option>"
	w "<option value=11>手术</option>"
	w "<option value=12>录入人</option>"
	w "<option value=13>录入日期</option>"
	w "<option value=14>录入时间</option>"
	w "</select>",!
}

/// Creator：     Fanghw
/// CreatDate：   2013-01-07
/// Description:  通过就病案ID取编目信息
/// Table：       PA_Adm,DHC_WMR_FPICD,Pa_PatMas
/// Input:        MainID:病案RowID
/// w ##Class(类名).方法名(参数)
/// do ##class(%ResultSet).RunQuery("web.DHCWMR.TimeAndDiseaseQry","QryInfoByMainNo","302")
Query QryInfoByMainNo(MainID As %String) As %Query(ROWSPEC = "Operator:%String,ICDCode:%String,AssistantDr1:%String,AssistantDr2:%String,NarcosisType:%String,NarcosisDoctor:%String,CloseUp:%String,OperDate:%String,FPICDType:%String,ICDDx:%String,OutCome:%String") [ SqlProc ]
{
}

ClassMethod QryInfoByMainNoExecute(ByRef qHandle As %Binary, MainID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    Quit:MainID="" $$$OK    
	Set VolID=""
	For{
		Set VolID=$o(^DHCWMRVOL(0,"Main",MainID,VolID))
		Quit:VolID=""
		Set FPID=""
		For{
			Set FPID=$o(^DHCWMRFP(0,"VolumeDr",VolID,FPID))	
			Quit:FPID=""
			Set FPICDROWID=""
			For{
				Set FPICDROWID=$o(^DHCWMRFPICD(0,"FP",FPID,FPICDROWID))
				Quit:FPICDROWID=""
				set obj=##Class(web.DHCWMRFPCodingQry).GetFPICDString(FPICDROWID)

				/*Set OperatorID=$p(^DHCWMRFPICD(FPICDROWID),"^",4) //术者
				Set:OperatorID'=0 Operator=$p(^SSU(OperatorID),"^",2)
				Set AssistantDr1ID=$p(^DHCWMRFPICD(FPICDROWID),"^",5) //1助
				Set:AssistantDr1ID'=0 AssistantDr1=$p(^SSU(AssistantDr1ID),"^",2)
				Set AssistantDr2ID=$p(^DHCWMRFPICD(FPICDROWID),"^",6) //2助
				Set:AssistantDr2ID'=0 AssistantDr2=$p(^SSU(AssistantDr2ID),"^",2)
				Set NarcosisType=$p(^DHCWMRFPICD(FPICDROWID),"^",7) //麻醉方式
				Set NarcosisDoctorDr=$p(^DHCWMRFPICD(FPICDROWID),"^",8) //麻醉医师
				Set:NarcosisDoctorDr'=0 NarcosisDoctor=$p(^SSU(NarcosisDoctorDr),"^",2)
				Set CloseUp=$p(^DHCWMRFPICD(FPICDROWID),"^",9) //愈合切口
				Set OperDate=$p(^DHCWMRFPICD(FPICDROWID),"^",13) //手术日期
				Set FPICDTypeDr=$p(^DHCWMRFPICD(FPICDROWID),"^",14) //诊断手术类型
				Set FPICDType=$p(^DHCWMRDIC(FPICDTypeDr),"^",3)
				Set ICDDxId=$p(^DHCWMRFPICD(FPICDROWID),"^",2) //诊断
				Set ICDDx=$p(^DHCWMRICD(ICDDxId),"^",3)
				Set ICDCode=$p(^DHCWMRICD(ICDDxId),"^",1) //编码
				*/
				Set OperatorID=$p(obj,"^",6) //术者
				Set AssistantDr1=$p(obj,"^",7) //1助
				Set AssistantDr2=$p(obj,"^",8) //2助
				Set NarcosisType=$p(obj,"^",9) //麻醉方式
				Set NarcosisDoctor=$p(obj,"^",10) //麻醉医师
				Set OutCome=$p(obj,"^",5) //转归情况
				Set CloseUp=$p(obj,"^",11) //愈合切口
				Set OperDate=$p(obj,"^",15) //手术日期
				Set FPICDType=$p(obj,"^",12) //诊断手术类型
				Set ICDDx=$p(obj,"^",4) //诊断
				Set ICDCode=$p(obj,"^",3) //编码

			}
		}
	}
			Set Data=$lb(Operator,ICDCode,AssistantDr1,AssistantDr2,NarcosisType,NarcosisDoctor,CloseUp,OperDate,FPICDType,ICDDx,OutCome)
 			Set ^CacheTemp(repid,ind)=Data
	        Set ind=ind+1

		

	Quit $$$OK
}

ClassMethod QryInfoByMainNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfoByMainNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfoByMainNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfoByMainNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
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

Storage Default
{
<Data name="TimeAndDiseaseQryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWMR.TimeAndDiseaseQryD</DataLocation>
<DefaultData>TimeAndDiseaseQryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCWMR.TimeAndDiseaseQryD</IdLocation>
<IndexLocation>^web.DHCWMR.TimeAndDiseaseQryI</IndexLocation>
<StreamLocation>^web.DHCWMR.TimeAndDiseaseQryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
