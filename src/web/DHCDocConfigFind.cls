Class web.DHCDocConfigFind Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:宋春莉
/// CreatDate:2020.08.17
/// Description:导入医生站配置手册
/// Input:Data导入数据,多条数据$C(1)分割,产品线^主页面csp^主页面名称^元素所在页csp^元素所在页名称^元素所在单元ID^元素所在单元描述^元素ID^元素名称^元素说明^主页面是否为链接页面 
/// Return：导入成功数量^导入失败提示
ClassMethod ImportDocConfigXls(Data As %String) As %String
{
	s MsgInfo="",SuccessNum=0
	For i=1:1:$l(Data,$c(1)) {
		K PLIST
		s OneData=$P(Data,$c(1),i)
		s PLIST(2)=productLine=$P(OneData,$c(2),1)
		s PLIST(3)=mainCSPCode=$P(OneData,$c(2),2)
		s PLIST(4)=mainCSPName=$P(OneData,$c(2),3)
		s PLIST(5)=itemCSPCode=$P(OneData,$c(2),4)
		s PLIST(6)=itemCSPName=$P(OneData,$c(2),5)
		s PLIST(7)=itemUnitCode=$P(OneData,$c(2),6)
		s PLIST(8)=itemUnitName=$P(OneData,$c(2),7)
		s PLIST(9)=itemID=$P(OneData,$c(2),8)
		s PLIST(10)=itemName=$P(OneData,$c(2),9)
		s PLIST(11)=itemRemarks=$P(OneData,$c(2),10)
		s PLIST(12)=mainCSPIsLink=$P(OneData,$c(2),11)
		&sql(insert into SQLUser.DHCDoc_ConfigFind values :PLIST())
		if ('SQLCODE) {
			s SuccessNum = SuccessNum +1
		}else{
			if (MsgInfo="") s MsgInfo="第"_i_"行插入失败!"
			else  s MsgInfo = MsgInfo _" "_"第"_i_"行插入失败!"
		}
	}
	Q SuccessNum_"^"_MsgInfo
}

/// Creator:宋春莉
/// CreatDate:2020.08.17
/// Description:已缓存页面数据导入
/// Input:Data导入数据,多条数据$C(1)分割,元素所在页csp^元素名称^元素说明
/// Return：导入成功数量^导入失败提示
/// w ##class(web.DHCDocConfigFind).ImportDocConfigXls2(^Tempsc("data"))
ClassMethod ImportDocConfigXls2(Data) As %String
{
	s ^Tempsc("data")=Data
	s MsgInfo="",SuccessNum=0
	For i=1:1:$l(Data,$c(1)) {
		s err=0
		s OneData=$P(Data,$c(1),i)
		s itemCSPCode=$P(OneData,$c(2),1)
		s itemName=$P(OneData,$c(2),2)
		s itemRemarks=$P(OneData,$c(2),3)
		s DOPRowId=$o(^DHCDocOPi("Code",0,itemCSPCode,""))
		if (DOPRowId'="") {
			s itemCSPName=$p(^DHCDocOP(DOPRowId),"^",2)
			s mainCSPCode=$p(^DHCDocOP(DOPRowId),"^",4)
			s mainCSPName=$p(^DHCDocOP(DOPRowId),"^",5)
			s mainCSPIsLink=$p(^DHCDocOP(DOPRowId),"^",6)
			s productLine=$p(^DHCDocOP(DOPRowId),"^",3)
			k DHCDocPageDomNameList
			s PDChildSub=0
			for {
				s PDChildSub=$o(^DHCDocPageDom(DOPRowId,PDChildSub)) Q:PDChildSub=""
				s data=$g(^DHCDocPageDom(DOPRowId,PDChildSub))
				s PDDomID=$p(data,"^",1)
				s PDDomName=$p(data,"^",2)
				s PDDomUnitID=$p(data,"^",10)
				s PDDomUnitName=$p(data,"^",11)
				s DHCDocPageDomNameList(PDDomName,"PDDomID")=PDDomID
				s DHCDocPageDomNameList(PDDomName,"PDDomUnitID")=PDDomUnitID
				s DHCDocPageDomNameList(PDDomName,"PDDomUnitName")=PDDomUnitName
			}
			s count=0
			if (mainCSPCode'="") {
				&sql(select count(ID) into:count from SQLUser.DHCDoc_ConfigFind where (productLine=:productLine and mainCSPCode=:mainCSPCode and itemCSPCode=:itemCSPCode and itemID is null))
			}else{
				&sql(select count(ID) into:count from SQLUser.DHCDoc_ConfigFind where (productLine=:productLine and mainCSPCode is null and itemCSPCode=:itemCSPCode and itemID is null))
			}
			if (count=0) {
				K PLIST
				s PLIST(2)=productLine
				s PLIST(3)=mainCSPCode
				s PLIST(4)=mainCSPName
				s PLIST(5)=itemCSPCode
				s PLIST(6)=itemCSPName
				s PLIST(12)=mainCSPIsLink
				s PLIST(13)=itemRemarks
				;登记页面
				&sql(insert into SQLUser.DHCDoc_ConfigFind values :PLIST())
			}
			if (itemName'=""){
				K PLIST
				s PLIST(2)=productLine
				s PLIST(3)=mainCSPCode
				s PLIST(4)=mainCSPName
				s PLIST(5)=itemCSPCode
				s PLIST(6)=itemCSPName
				s PLIST(10)=itemName
				s PLIST(12)=mainCSPIsLink
				if (itemName'="") {
					s PLIST(7)=$g(DHCDocPageDomNameList(itemName,"PDDomUnitID"))
					s PLIST(8)=$g(DHCDocPageDomNameList(itemName,"PDDomUnitName"))
					s PLIST(9)=$g(DHCDocPageDomNameList(itemName,"PDDomID"))
					s PLIST(11)=itemRemarks
				}
				;登记配置点
				&sql(insert into SQLUser.DHCDoc_ConfigFind values :PLIST())
			}
			s err=SQLCODE
		}else{
			s err=-1
		}
		if ('err) {
			s SuccessNum = SuccessNum +1
		}else{
			if (MsgInfo="") s MsgInfo="第"_i_"行插入失败!"
			else  s MsgInfo = MsgInfo _" "_"第"_i_"行插入失败!"
		}
	}
	Q SuccessNum_"^"_MsgInfo
}

/// Creator:宋春莉
/// CreatDate:2020.08.17
/// Description:获取已登记配置数据
/// Return：json数据
/// w ##class(web.DHCDocConfigFind).DHCDocConfigFind("","","","有效天数")
ClassMethod DHCDocConfigFind(searchProductLines As %String, searchPageCSP As %String, searchPageCSPName As %String, searchItemName As %String) As %String
{
	s JsonObj=[]
	k DHCDocConfigFindList
	if (searchProductLines'="") {
		for i=1:1:$l(searchProductLines,"#") {
			s productLine=$p(searchProductLines,"#",i)
			if ('$d(^User.DHCDocConfigFindI("productLine",productLine))) continue
			d GetDHCDocConfigFindList(productLine)
		}
	}elseif (searchItemName'=""){
		s tmpid=$o(^User.DHCDocConfigFindI("itemName",searchItemName,""))
		if (tmpid'="") {
			s productLine=$lg(^User.DHCDocConfigFindD(tmpid),2)
			d GetDHCDocConfigFindList(productLine)
		}
		s searchItemName1=$o(^User.DHCDocConfigFindI("itemName",searchItemName))
		while(searchItemName1'="") {
			if (searchItemName1[searchItemName){
			    s tmpid=""
				s tmpid=$o(^User.DHCDocConfigFindI("itemName",searchItemName1,tmpid))
				while(tmpid'=""){
					s productLine=$lg(^User.DHCDocConfigFindD(tmpid),2)
					d GetDHCDocConfigFindList(productLine)
					s tmpid=$o(^User.DHCDocConfigFindI("itemName",searchItemName1,tmpid))
				}
			}
			Set searchItemName1 = $o(^User.DHCDocConfigFindI("itemName",searchItemName1))
		}
	}else{
		s productLine=0
		for {
			s productLine=$o(^User.DHCDocConfigFindI("productLine",productLine)) Q:productLine=""
			d GetDHCDocConfigFindList(productLine)
		}
	}
	b //45
	s id1=0,index=0
	for {
		s id1=$o(DHCDocConfigFindList(id1)) Q:id1=""
		;过滤产品线下无子节点数据
		continue:$d(DHCDocConfigFindList(id1))=1
		s Json1=$$SetDataJson(id1) do tmpJson.%Set("name",##class(DHCDoc.DHCDocConfig.LocalConfig).GetProductLine(.Product,id1))
		s id2=0,SubDataArr1=[]
		for {
			s id2=$o(DHCDocConfigFindList(id1,id2)) Q:id2=""
			s Json2={}
			s Json2=$$SetDataJson(id2)
			s tmpid=$g(DHCDocConfigFindList(id1,id2))
			s mainCSPCode="",mainCSPIsLink="N",itemCSPCode="",itemCSPRemarks=""
			if (tmpid'="")&&($d(^User.DHCDocConfigFindD(tmpid))){
				s mainCSPIsLink=$lg(^User.DHCDocConfigFindD(tmpid),12)
				s mainCSPCode=$lg(^User.DHCDocConfigFindD(tmpid),3)
				s itemCSPCode=$lg(^User.DHCDocConfigFindD(tmpid),5)
				s itemCSPRemarks=$lg(^User.DHCDocConfigFindD(tmpid),13)
				if (mainCSPCode'=""){
					;设置链接csp和链接标识
					if (mainCSPIsLink="Y") {
						do Json2.%Set("LinkCSPCode",mainCSPCode)
						do Json2.%Set("IsLink","Y")
					}
				}else{
					s Json2=$$SetDataJson(tmpid)
					do Json2.%Set("name",id2)
					do Json2.%Set("itemCSPRemarks",itemCSPRemarks)
					do Json2.%Set("LinkCSPCode",itemCSPCode)
					do Json2.%Set("IsLink","Y")
				}
				if (searchItemName="") do Json2.%Set("state","closed")
			}
			do SubDataArr1.%Push(Json2,"")
			s id3=0,SubDataArr2=[]
			for {
				s id3=$o(DHCDocConfigFindList(id1,id2,id3)) Q:id3=""
				s Json3={}
				s Json3=$$SetDataJson(id3)
				if (mainCSPCode="")||(mainCSPIsLink="N") {
					s tmpid=$g(DHCDocConfigFindList(id1,id2,id3))
					if (tmpid'="")&&($d(^User.DHCDocConfigFindD(tmpid))){
						s itemCSPCode=$lg(^User.DHCDocConfigFindD(tmpid),5)
						s itemCSPRemarks=$lg(^User.DHCDocConfigFindD(tmpid),13)
						s itemID=$lg(^User.DHCDocConfigFindD(tmpid),9)
						if (itemID="") {
							do Json3.%Set("name",id3)
							do Json3.%Set("LinkCSPCode",itemCSPCode)
							do Json3.%Set("itemCSPRemarks",itemCSPRemarks)
							do Json3.%Set("IsLink","Y")
							do Json3.%Set("rowid",tmpid)
						}
					}
				}
				do SubDataArr2.%Push(Json3,"")
				s id4=0,SubDataArr3=[]
				for {
					s id4=$o(DHCDocConfigFindList(id1,id2,id3,id4)) Q:id4=""
					s Json4=$$SetDataJson(id4)
					if (Json4.itemID ="") continue
					do SubDataArr3.%Push(Json4,"")
					s id5=0,SubDataArr4=[]
					for {
						s id5=$o(DHCDocConfigFindList(id1,id2,id3,id4,id5)) Q:id5=""
						s Json5=$$SetDataJson(id5)
						if (Json5.itemID ="") continue
						do SubDataArr4.%Push(Json5,"")
					}
					do Json4.%Set("children",SubDataArr4)
				}
				do Json3.%Set("children",SubDataArr3)
			}
			do Json2.%Set("children",SubDataArr2)
		}
		do Json1.%Set("children",SubDataArr1)
		do JsonObj.%Push(Json1,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
GetDHCDocConfigFindList(productLine)
	s DHCDocConfigFindList(productLine)=1
	s id=0
	for {
		s id=$o(^User.DHCDocConfigFindI("productLine",productLine,id)) Q:id=""
		continue:id=" "
		continue:$d(DHCDocConfigIDList(id))
		s mainCSPCode=$lg(^User.DHCDocConfigFindD(id),3)
		s mainCSPName=$lg(^User.DHCDocConfigFindD(id),4)
		s itemCSPCode=$lg(^User.DHCDocConfigFindD(id),5)
		s itemCSPName=$lg(^User.DHCDocConfigFindD(id),6)
		s itemName=$lg(^User.DHCDocConfigFindD(id),10)
		continue:(searchPageCSPName'="")&&(mainCSPName'[searchPageCSPName)&&(itemCSPName'[searchPageCSPName)
		continue:(searchPageCSP'="")&&(itemCSPCode'[searchPageCSP)
		continue:(searchItemName'="")&&(itemName'[searchItemName)
		s itemActive=$lg(^User.DHCDocConfigFindD(id),14)
		continue:(itemActive="N")
		s itemUnitName=$lg(^User.DHCDocConfigFindD(id),8)
		if (itemName'="") {
			if (mainCSPName'="") {
				if ('$d(DHCDocConfigFindList(productLine,mainCSPName,itemCSPName))) {
					s mainId=$o(^User.DHCDocConfigFindI("mainCSPCode",productLine," "_$zcvt(mainCSPCode,"U"),""))
					b //67
					s DHCDocConfigFindList(productLine,mainCSPName)=mainId
					s DHCDocConfigFindList(productLine,mainCSPName,itemCSPName)=mainId
				}
				if (itemUnitName="") {
					s DHCDocConfigFindList(productLine,mainCSPName,itemCSPName,id)=id
				}else{
					s DHCDocConfigFindList(productLine,mainCSPName,itemCSPName,itemUnitName,id)=id
				}
			}else{
				if ('$d(DHCDocConfigFindList(productLine,itemCSPName))) {
					s mainId=$O(^User.DHCDocConfigFindI("itemCSPCode",productLine," ",itemCSPCode,""))
					s DHCDocConfigFindList(productLine,itemCSPName)=mainId
				}
				if (itemUnitName="") {
					s DHCDocConfigFindList(productLine,itemCSPName,id)=id
				}else{
					s DHCDocConfigFindList(productLine,itemCSPName,itemUnitName,id)=id
				}
			}
		}else{
			if (mainCSPName'="") {
				s DHCDocConfigFindList(productLine,mainCSPName)=id
				s DHCDocConfigFindList(productLine,mainCSPName,itemCSPName)=id
			}else{
				s DHCDocConfigFindList(productLine,itemCSPName)=id
			}
		}
	}
	Q
SetDataJson(id)
	s tmpJson={}
	if ($d(^User.DHCDocConfigFindD(id))){
		s rowid=id
		s name=$lg(^User.DHCDocConfigFindD(id),10)
		s mainCSPCode=$lg(^User.DHCDocConfigFindD(id),3)
		s mainCSPName=$lg(^User.DHCDocConfigFindD(id),4)
		s itemCSPCode=$lg(^User.DHCDocConfigFindD(id),5)
		s itemCSPName=$lg(^User.DHCDocConfigFindD(id),6)
		s itemUnitCode=$lg(^User.DHCDocConfigFindD(id),7)
		s itemUnitName=$lg(^User.DHCDocConfigFindD(id),8)
		s itemID=$lg(^User.DHCDocConfigFindD(id),9)
		s itemRemarks=$lg(^User.DHCDocConfigFindD(id),11)
		s mainCSPIsLink=$lg(^User.DHCDocConfigFindD(id),12)
		s productLine=$lg(^User.DHCDocConfigFindD(id),2)
	}else{
		s rowid=""
		s name=id,mainCSPCode="",mainCSPName="",itemCSPCode="",itemCSPName="",itemUnitCode="",itemUnitName=""
		s itemID="",itemRemarks="",mainCSPIsLink="N",productLine=""
	}
	s index=index+1
	do tmpJson.%Set("index",index)
	do tmpJson.%Set("name",name)
	do tmpJson.%Set("rowid",rowid) 
	do tmpJson.%Set("mainCSPCode",mainCSPCode) 
	do tmpJson.%Set("mainCSPName",mainCSPName)
	do tmpJson.%Set("itemCSPCode",itemCSPCode)
	do tmpJson.%Set("itemCSPName",itemCSPName)
	do tmpJson.%Set("itemUnitCode",itemUnitCode)
	do tmpJson.%Set("itemUnitName",itemUnitName)
	do tmpJson.%Set("itemID",itemID)
	do tmpJson.%Set("itemRemarks",itemRemarks)
	do tmpJson.%Set("mainCSPIsLink",mainCSPIsLink)
	do tmpJson.%Set("productLine",productLine)
	Q tmpJson
}

/// Creator:宋春莉
/// CreatDate:2020.08.19
/// Description:保存配置点数据
/// Return：0 成功 其他 失败
/// w ##class(web.DHCDocConfigFind).SaveDocConfigRemark("^Reg^^^N^^reg.dhccardtypedef.hui.csp^卡类型配置SetFocusElement^ee^测试")
ClassMethod SaveDocConfigRemark(Str As %String) As %String
{
	s rowid=$p(Str,$C(1),1)
	s ProductLine=$p(Str,$C(1),2)
	s MainPageCSPCode=$p(Str,$C(1),3)
	s MainPageCSPName=$p(Str,$C(1),4)
	s mainCSPIsLink=$p(Str,$C(1),5)
	s itemUnitCode=$p(Str,$C(1),6)
	s itemUnitName=$p(Str,$C(1),7)
	s PageCSPCode=$p(Str,$C(1),8)
	s PageCSPName=$p(Str,$C(1),9)
	s ItemId=$p(Str,$C(1),10)
	s ItemName=$p(Str,$C(1),11)
	s ItemRemarks="",itemCSPRemarks=""
	if (ItemId="") {
		s itemCSPRemarks=$p(Str,$C(1),12)
	}else{
		s ItemRemarks=$p(Str,$C(1),12)
	}
	if (ItemId="") {
		if (rowid="") {
			&sql(select * from SQLUser.DHCDoc_ConfigFind where itemCSPCode=:PageCSPCode and itemID is null)
		}else{
			&sql(select * from SQLUser.DHCDoc_ConfigFind where itemCSPCode=:PageCSPCode and itemID is null and ID<>:rowid)
		}
	}else{
		if (rowid="") {
			&sql(select * from SQLUser.DHCDoc_ConfigFind where itemCSPCode=:PageCSPCode and itemID=:ItemId)
		}else{
			&sql(select * from SQLUser.DHCDoc_ConfigFind where itemCSPCode=:PageCSPCode and itemID=:ItemId and ID<>:rowid)
		}
	}
	Q:SQLCODE'=100 "repeat"
	K PLIST
	s PLIST(2)=ProductLine
	s PLIST(3)=MainPageCSPCode
	s PLIST(4)=MainPageCSPName
	s PLIST(5)=PageCSPCode
	s PLIST(6)=PageCSPName
	;登记配置点但未登记页面时先登记页面,可用于页面备注说明及修改
	if (rowid="")&&(ItemId'="") {
		&sql(insert into SQLUser.DHCDoc_ConfigFind values :PLIST())
	}
	s PLIST(7)=itemUnitCode
	s PLIST(8)=itemUnitName
	s PLIST(9)=ItemId
	s PLIST(10)=ItemName
	s PLIST(11)=ItemRemarks
	s PLIST(12)=mainCSPIsLink
	s PLIST(13)=itemCSPRemarks
	if (rowid="") {
		&sql(insert into SQLUser.DHCDoc_ConfigFind values :PLIST())
	}else{
		&sql(update SQLUser.DHCDoc_ConfigFind values :PLIST() where ID=:rowid)
	}
	Q SQLCODE
}

/// Creator:宋春莉
/// CreatDate:2020.08.19
/// table:DHC_DocOrderPage、DHC_DocOrderPage、DHCDoc_ConfigFind
/// Description:获取已缓存但未登记配置数据
/// Return：json数据
/// w ##class(web.DHCDocConfigFind).GetUnRegisterConfigItem()
ClassMethod GetUnRegisterConfigItem() As %String
{
	s JsonObj=[],JsonData={}
	k UnRegisterConfigItemList
	s DOPRowId=0
	for {
		s DOPRowId=$o(^DHCDocOP(DOPRowId)) Q:DOPRowId=""
		s DOPCode=$p(^DHCDocOP(DOPRowId),"^",1)
		s DOPProductLine=$p(^DHCDocOP(DOPRowId),"^",3)
		continue:DOPProductLine=""
		s DOPCode=$p(^DHCDocOP(DOPRowId),"^",1)
		s DOPDesc=$p(^DHCDocOP(DOPRowId),"^",2)
		s DOPProductLine=$p(^DHCDocOP(DOPRowId),"^",3)
		s DOPMainCSPCode=$p(^DHCDocOP(DOPRowId),"^",4)
		s DOPMainCSPDesc=$p(^DHCDocOP(DOPRowId),"^",5)
		s DOPMainCSPIsLink=$p(^DHCDocOP(DOPRowId),"^",6)
		s PDChildSub=0
		for {
			s PDChildSub=$o(^DHCDocPageDom(DOPRowId,PDChildSub)) Q:PDChildSub=""
			s PDDomID=$p(^DHCDocPageDom(DOPRowId,PDChildSub),"^",1)
			s PDDomDomName=$p(^DHCDocPageDom(DOPRowId,PDChildSub),"^",2)
			if ($d(^User.DHCDocConfigFindI("itemID",DOPCode,PDDomID))) continue
			s UnRegisterConfigItemList(DOPProductLine)=1
			if (DOPMainCSPDesc'="") {
				s DHCDocConfigFindList(DOPProductLine,DOPMainCSPDesc)=""
				s DHCDocConfigFindList(DOPProductLine,DOPMainCSPDesc,DOPDesc)=""
			}else{
				s DHCDocConfigFindList(DOPProductLine,DOPDesc)=""
			}
			s PDDomUnitName=$p(^DHCDocPageDom(DOPRowId,PDChildSub),"^",11)
			continue:(PDDomDomName="")&&(PDDomUnitName="")
			if (DOPMainCSPDesc'="") {
				if (PDDomUnitName'="") {
					s DHCDocConfigFindList(DOPProductLine,DOPMainCSPDesc,DOPDesc,PDDomUnitName,DOPRowId_"||"_PDChildSub)=""
				}else{
					s DHCDocConfigFindList(DOPProductLine,DOPMainCSPDesc,DOPDesc,DOPRowId_"||"_PDChildSub)=""
				}
			}else{
				if (PDDomUnitName'="") {
					s DHCDocConfigFindList(DOPProductLine,DOPDesc,PDDomUnitName,DOPRowId_"||"_PDChildSub)=""
				}else{
					s DHCDocConfigFindList(DOPProductLine,DOPDesc,DOPRowId_"||"_PDChildSub)=""
				}
			}
		}
	}
	s id1=0,index=0
	for {
		s id1=$o(DHCDocConfigFindList(id1)) Q:id1=""
		s Json1=$$SetDataJson("",##class(DHCDoc.DHCDocConfig.LocalConfig).GetProductLine(.Product,id1))
		s id2=0,SubDataArr1=[]
		for {
			s id2=$o(DHCDocConfigFindList(id1,id2)) Q:id2=""
			s Json2=$$SetDataJson("",id2)
			do SubDataArr1.%Push(Json2,"")
			s id3=0,SubDataArr2=[]
			for {
				s id3=$o(DHCDocConfigFindList(id1,id2,id3)) Q:id3=""
				if (+id3=0) {
					s Json3=$$SetDataJson("",id3)
				}else {
					s PDDomName=$p(^DHCDocPageDom(+id3,$p(id3,"||",2)),"^",2)
					s Json3=$$SetDataJson(id3,PDDomName)
				}
				do SubDataArr2.%Push(Json3,"")
				s id4=0,SubDataArr3=[]
				for {
					s id4=$o(DHCDocConfigFindList(id1,id2,id3,id4)) Q:id4=""
					if (+id4=0) {
						s Json4=$$SetDataJson("",id4)
					}else{
						s PDDomName=$p(^DHCDocPageDom(+id4,$p(id4,"||",2)),"^",2)
						s Json4=$$SetDataJson(id4,PDDomName)
					}
					do SubDataArr3.%Push(Json4,"")
					s id5=0,SubDataArr4=[]
					for {
						s id5=$o(DHCDocConfigFindList(id1,id2,id3,id4,id5)) Q:id5=""
						s Json5=$$SetDataJson(id5,PDDomName)
						do SubDataArr4.%Push(Json5,"")
					}
					do Json4.%Set("children",SubDataArr4)
				}
				do Json3.%Set("children",SubDataArr3)
			}
			do Json2.%Set("children",SubDataArr2)
		}
		do Json1.%Set("children",SubDataArr1)
		do JsonObj.%Push(Json1,"")
	}
	do JsonData.%Set("data",JsonObj)
	do JsonData.%Set("count",index)
	s returnJsonObj=[]
	do returnJsonObj.%Push(JsonData,"")
	s obj=##class(%Stream.GlobalCharacter).%New()
	do returnJsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
SetDataJson(id,name)
	s tmpJson={}
	s index=index+1
	do tmpJson.%Set("index",index)
	do tmpJson.%Set("name",name)
	if (id'="") {
		s PDDomID=$p(^DHCDocPageDom(+id,$p(id,"||",2)),"^",1)
		s PDDomName=$p(^DHCDocPageDom(+id,$p(id,"||",2)),"^",2)
		s PDDomUnitID=$p(^DHCDocPageDom(+id,$p(id,"||",2)),"^",10)
		s PDDomUnitName=$p(^DHCDocPageDom(+id,$p(id,"||",2)),"^",11)
		do tmpJson.%Set("PDDomUnitID",PDDomUnitID)
		do tmpJson.%Set("PDDomUnitName",PDDomUnitName)
		do tmpJson.%Set("PDDomName",PDDomName)
		do tmpJson.%Set("PDDomID",PDDomID)
		do tmpJson.%Set("itemRemarks","")
		s DOPCode=$p(^DHCDocOP(+id),"^",1)
		s DOPDesc=$p(^DHCDocOP(+id),"^",2)
		s DOPProductLine=$p(^DHCDocOP(+id),"^",3)
		s DOPMainCSPCode=$p(^DHCDocOP(+id),"^",4)
		s DOPMainCSPDesc=$p(^DHCDocOP(+id),"^",5)
		s DOPMainCSPIsLink=$p(^DHCDocOP(+id),"^",6)
		do tmpJson.%Set("DOPCode",DOPCode)
		do tmpJson.%Set("DOPDesc",DOPDesc)
		do tmpJson.%Set("DOPProductLine",DOPProductLine)
		do tmpJson.%Set("DOPMainCSPCode",DOPMainCSPCode)
		do tmpJson.%Set("DOPMainCSPDesc",DOPMainCSPDesc)
		do tmpJson.%Set("DOPMainCSPIsLink",DOPMainCSPIsLink)
	}
	Q tmpJson
}

/// Creator:宋春莉
/// CreatDate:2020.08.19
/// Description:保存未登记配置点数据
/// Return：0 成功 其他 失败
/// w ##class(web.DHCDocConfigFind).SaveUnRegisterConfigItem("")
ClassMethod SaveUnRegisterConfigItem(Str As %String) As %String
{
	s rtn=0
	TS
	for i=1:1:$l(Str,$C(2)) {
		s oenStr=$p(Str,$C(2),i)
		s rtn=..SaveDocConfigRemark(oenStr)
		if (rtn'=0) Q
	}
	if (rtn'=0) tro
	Tc
	Q rtn
}

}
