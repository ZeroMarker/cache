/// 名称: DHCHAI.DPS.CSSDRecordSrv
/// 描述: 细菌相关服务
/// 编写者：chenjb
/// 编写日期: 2017-05-09
Class DHCHAI.DPS.CSSDRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-09
/// Description:  查询细菌分类
/// Table：       DHCHAI.DP.LabBactCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.CSSDRecordSrv","QryCssdListNew","1|3|4","1","2022-01-01","2022-01-24","","","")
Query QryCssdListNew(iHospIDs As %String, iDateType As %String, iDateFrom As %String, iDateTo As %String, iBarCode As %String, iBatchNum As %String, iPatNo As %String) As %Query(ROWSPEC = "ID:%String,BarDesc:%String,BarCode:%String,BatchG:%String,BatchNum:%String,PatName:%String,PatNo:%String,LocDr:%String,Send:%String,SendUser:%String,Clean:%String,CleanUser:%String,Steril:%String,SterilUser:%String,Back:%String,BackUser:%String") [ SqlProc ]
{
}

ClassMethod QryCssdListNewExecute(ByRef qHandle As %Binary, iHospIDs As %String, iDateType As %String, iDateFrom As %String, iDateTo As %String, iBarCode As %String, iBatchNum As %String, iPatNo As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//Set ^TMP("QryCssdListExecute",+$h,$p($h,",",2))=$lb(iHospIDs, iDateType, iDateFrom, iDateTo, iBarCode, iBatchNum,iPatNo)
	Quit:iDateType="" $$$OK
	Quit:(iDateFrom="")||(iDateTo="") $$$OK
	//转化日期
	Set:iDateFrom'="" iDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(iDateFrom)
	Set:iDateTo'="" iDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(iDateTo) 	
 	Quit:(iDateFrom>iDateTo) $$$OK
 		
	Set xID=0	
	For {
		Set xID=$o(^DHCHAI.DP.CSSDRecordD(xID))
		Quit:xID=""
		
		Set obj = ##class(DHCHAI.DP.CSSDRecord).GetObjById(xID)
		Continue:'$Isobject(obj)
		Set PAAdmobj  = obj.CSSDEpisodeDr
		//院区过滤
		Continue:'$Isobject(PAAdmobj)
		Set LocDr="",LocID=""
		Set:$ISObject(PAAdmobj) LocDr=PAAdmobj.PAAdmLocDr
		Continue:'$ISObject(LocDr)
		Set LocID=LocDr.%Id()
		Set LocData = $g(^DHCHAI.BT.LocationD(LocID))
		Set HospDr=$li(LocData,8)
		Continue:(iHospIDs'="")&&(iHospIDs'[HospDr)	
			
		Set PatName	   =PAAdmobj.PAPatName				//病人名
		Set PatNo	   =PAAdmobj.PAPapmiNo		//登记号
	    Set BarDesc    = obj.CSSDDesc  					//消毒包名
	    Set BarCode    = obj.CSSDBarCode  		//器械条码
	    Set LocDr      = obj.CSSDLocDr.BTDesc  			//绑定使用科室
	    Set BatchG	   = obj.CSSDBatchG			//灭菌锅号
	    Set BatchNum   = obj.CSSDBatchNumberS	//灭菌批次
	    
	    Set CleanDate  = obj.CSSDCleanDate				//清洗日期
	    Set CleanTime  = obj.CSSDCleanTime				//清洗时间
		Set CleanUser  = obj.CSSDCleanUser 		
		Set:CleanUser["|" CleanUser=$p(CleanUser,"|",3) //清洗人
		Set SterilDate = obj.CSSDSterilDate				//灭菌日期
		Set SterilTime = obj.CSSDSterilTime				//灭菌时间
		Set SterilUser = obj.CSSDSterilUser 	
		Set:SterilUser["|" SterilUser=$p(SterilUser,"|",3)	//灭菌人
		Set SendDate   = obj.CSSDSendDate					//发放日期
		Set SendTime   = obj.CSSDSendTime					//发放时间
		Set SendUser   = obj.CSSDSendUser		
		Set:SendUser["|" SendUser=$p(SendUser,"|",2)		//发放人
		Set BackDate   = obj.CSSDBackDate					//回收日期
		Set BackTime   = obj.CSSDBackTime					//回收时间
		Set BackUser   = obj.CSSDBackUser		
		Set:BackUser["|" BackUser=$p(BackUser,"|",3)		//回收人
		
		//根据条件过滤信息
		//1.日期
		if (iDateType="1"){
			Continue:SendDate=""
			if (SendDate'="")&((SendDate<iDateFrom)||(SendDate>iDateTo)){
				continue
			}
		}
		if (iDateType="2"){
			Continue:CleanDate=""
			if (CleanDate'="")&((CleanDate<iDateFrom)||(CleanDate>iDateTo)){
				continue
			}
		}
		if (iDateType="3"){
			Continue:SterilDate=""
			if (SterilDate'="")&((SterilDate<iDateFrom)||(SterilDate>iDateTo)){
				continue
			}
		}
		if (iDateType="4"){
			Continue:BackDate=""
			if (BackDate'="")&((BackDate<iDateFrom)||(BackDate>iDateTo)){
				continue
			}
		}
		//2.机械条码
		if ( (iBarCode'="")&(BarCode'=iBarCode)){
			continue
		}
		//3.灭菌批次
		if ((iBatchNum'="")&(BatchNum'=iBatchNum)){
			continue	
		}
		//4.登记号
		if ((iPatNo'="")&(iPatNo'=PatNo)){
			continue
		}
		Set:CleanDate'="" CleanDate  =$zd(CleanDate,3)
		Set:CleanTime'="" CleanTime  =$zt(CleanTime,1)
		Set:SterilDate'="" SterilDate =$zd(SterilDate,3)
		Set:SterilTime'="" SterilTime =$zt(SterilTime,1)
		Set:SendDate'="" SendDate   =$zd(SendDate,3)
		Set:SendTime'="" SendTime   =$zt(SendTime,1)
		Set:BackDate'="" BackDate=$zd(BackDate,3)
		Set:BackTime'="" BackTime=$zt(BackTime,1)
		Set Send = SendDate_" "_SendTime //发放时间
	    Set Clean = CleanDate_" "_CleanTime //清洗时间
	    Set Steril =SterilDate_" "_SterilTime //灭菌时间
	    Set Back = BackDate_" "_BackTime //回收时间
	   
		Set Data=$lb(xID,BarDesc,BarCode,BatchG,BatchNum,PatName,PatNo,LocDr,Send,SendUser,Clean,CleanUser,Steril,SterilUser,Back,BackUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
		//Set ^TMP("QryCssdListExecute",+$h,$p($h,",",2),"Data",ind)=Data
	}
	Quit $$$OK
}

ClassMethod QryCssdListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCssdListNewExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCssdListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCssdListNewExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
