Import SQLUser

/// Creator: 	 bianshuai
/// CreateDate:  2016-07-18
/// Descript:    新产品研发组基础数据导入公共类
Class web.DHCEMImpTools Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 获取部位中要导入的数据
/// Creator:     yangyongtao
/// CreateDate:  2017-03-03
/// Table:	     DHC_AppPart 
/// Input:  	
/// return: result	 
/// w ##Class(web.DHCEMImpTools).SaveData("五官[next]五官[next]五官[next]1[next]","1","1","2")
ClassMethod SaveData(dataStr As %String, sheetid As %String, row As %Float, HospID As %String) As %String
{
	s result=""
	s dataStr=$tr(dataStr," ","")
    // Function:保存药品成分字典  成功result:^1^1
	s:(sheetid=1) result=..SavePart(dataStr,HospID)	
	q result
}

ClassMethod SavePart(dataStr As %String, HospID As %String) As %String
{
	s result=""
	s PartCode=$p(dataStr,"[next]",1)       /// 代码
	Q:$d(^DHCAPPART(0,"Code",PartCode)) "false"
	s PartDesc=$p(dataStr,"[next]",2)       /// 描述
	s LastPartDesc=$p(dataStr,"[next]",3)   /// 上级描述
	s PartNum=$p(dataStr,"[next]",4)        /// 数量
	s LastRowid=+$o(^DHCAPPART(0,"Code",LastPartDesc,""))
	S OrdNum=..GetPartOrdnum(LastRowid)
	;s HospID="" ;="65"
	s Level="1"
	s ActiveFlag="Y"
	Ts	
	//判断必填项
	if ((PartCode="")||(PartDesc="")){   
	    s result=result_"^"_0
    }
    else{ 
   		s result=result_"^"_1    //   web.DHCEMImpPart
		//保存到字典表	
	    s eobj=##class(web.DHCEMImpPart).%New()        
        /*s upcode=$ZCONVERT(PartCode,"U") //转换成大写
		s updesc=$ZCONVERT(PartDesc,"U") //转换成大写
		s idc=$o(^DHCAPPART(0,"Code",upcode,0))
		s idd=$o(^DHCAPPART(0,"Desc",updesc,0))
		//判断是添加还是修改
        if ((idc'="")&(idd'="")&(idc=idd))
		 { 
			s eobj.APRowId=idc
		 } */     
        
	    s eobj.APCode=PartCode
	    s eobj.APDesc=PartDesc
	    s eobj.APParPDr=LastRowid
	    s eobj.APLevel=Level
	    s eobj.APHospDr=HospID //##class(User.CTHospital).%OpenId(HospID)
	    s eobj.APActiveFlag=ActiveFlag
	    s eobj.APPartNum=PartNum
	    s eobj.APOrdNum=OrdNum
	    s str1 = ##class(web.DHCEMImpTools).SaveDataPart(eobj)
	    if (str1["true"){   
		    s result=result_"^"_1
	    }
	    else{        
			s result=result_"^"_0
		    
	    }
    }
     S result=$p(result,"^",2)
      if (result[0)
	{		
		Trollback
		s result = "false"		
	}
	else
	{
		Tc
		s result = "true"
		s ^tempKB("SaveIngr",row)=dataStr
	}
 		
 q result
}

/// sufan 2017-02-13  增加获取顺序号
/// Descrip : 获取部位顺序号
/// Others  : w ##class(web.DHCEMImpTools).GetPartOrdnum("1")
ClassMethod GetPartOrdnum(LastRowid)
{
	n (LastRowid)
	s maxnum=0
	i +LastRowid=0  d
	.s PartID="",Ordnum=""
	.f  s Ordnum=$o(^DHCAPPART(0,"OrdNum",LastRowid,Ordnum)) q:Ordnum=""  d
	..f  s PartID=$o(^DHCAPPART(0,"OrdNum",LastRowid,Ordnum,PartID))  q:PartID=""  d
	...s maxnum=maxnum+1
	...;i ordnum>maxnum s maxnum=ordnum
	e  d
	.s PartID="",Ordnum=""
	.f  s Ordnum=$o(^DHCAPPART(0,"OrdNum",LastRowid,Ordnum)) q:Ordnum=""  d
	..f  s PartID=$o(^DHCAPPART(0,"OrdNum",LastRowid,Ordnum,PartID)) q:PartID=""  d
	...s ordnum=$p(^DHCAPPART(+PartID),"^",8)
	...i ordnum>maxnum s maxnum=ordnum
	s maxnum=maxnum+1
	q maxnum
}

/// Creator：yangyongtao
/// CreatDate: 2017-03-03
/// Description：保存修改内容
/// Table：User.DHCAppPart
/// Input：web.DHCEMImpPart 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveDataPart(eobj As web.DHCEMImpPart) As %String
{
	s result = ""
	if $IsObject(eobj)
	{
		Ts
		//s flag=..FormValidate(eobj.PHEINGRowId,eobj.PHEINGCode,eobj.PHEINGDesc)  //调用重复验证
		//if (flag=1)
		//{
			//s result = "{success:'false',errorinfo:'该记录已经存在'}"
		//}
		//else
		//{
			if (eobj.APRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCAppPart).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCAppPart).%OpenId(eobj.APRowId)
				s bobj = ##class(web.DHCEMImpPart).%New()
				s bobj.APRowId = eobj.APRowId
				s bobj.APCode = obj.APCode
				s bobj.APDesc = obj.APDesc
				s bobj.APParPDr= obj.APParPDr 
			    s bobj.APLevel=obj.APLevel
			    s bobj.APHospDr=##class(User.CTHospital).%OpenId(obj.APHospDr,2)
	            s bobj.APActiveFlag=obj.APActiveFlag
				s bobj.APPartNum = obj.APPartNum
				s bobj.APOrdNum=obj.APOrdNum
				;b ;2222
			}
			s obj.APCode = eobj.APCode
			s obj.APDesc = eobj.APDesc
			s obj.APParPDr= eobj.APParPDr
			s obj.APLevel=eobj.APLevel
			s obj.APHospDr=##class(User.CTHospital).%OpenId(eobj.APHospDr,2)
	        s obj.APActiveFlag=eobj.APActiveFlag
		    s obj.APPartNum = eobj.APPartNum
		    s obj.APOrdNum=eobj.APOrdNum
		    b ;3333
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.APRowId="" ##class(web.DHCEMIMPCOMMON).SaveLog("DHC_AppPart","User.DHCAppPart","部位字典",id,eobj.APDesc,"A",eobj)
				d:eobj.APRowId'="" ##class(web.DHCEMIMPCOMMON).SaveLog("DHC_AppPart","User.DHCAppPart","部位字典",eobj.APRowId,eobj.APDesc,"U",eobj,bobj)

			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息

			}
		}	
	//}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// Descript:临床药师检验指标导入
/// w ##Class(web.DHCEMImpTools).ImportLabItems("d:\tmp\part.txt")
/// w ##Class(web.DHCEMImpTools).ImportLabItems("d:\tmp\partsub.txt")
/// w ##Class(web.DHCEMImpTools).ImportLabItems("d:\tmp\itmcat.txt")
/// w ##Class(web.DHCEMImpTools).ImportLabItems("d:\tmp\tar.txt")
/// w ##Class(web.DHCEMImpTools).ImportLabItems("C:\Users\Administrator\Desktop\部位数据导入\导数据正式\part.txt")
ClassMethod ImportLabItems(filepath As %String) As %String
{
	N (filepath)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s ImpDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.;b ///aaa
	.//d ..InsNoOfCumDays(ImpDataList) ///检验项目指标[临床药师用]
	.s Err=..ImpPart(ImpDataList,pid,hCount)       /// 导部位（主表）
	.//d ..ImpPartItem(ImpDataList) /// 导部位子项目（子表）
	.//d ..ImpTreeAdd(ImpDataList)       /// 检查项目树（主表）
	.//d ..ImpArcLinkTar(ImpDataList)		/// 医嘱项+部位对应收费项目对照表(附加费用)
	c filepath 
	Q Err
	//q filepath
}

/// Descript:  导入分类项目数据
/// w ##Class(web.DHCEMImpTools).ImpTreeAdd("CT^CT三维成像（16排）^胸部")
ClassMethod ImpTreeAdd(ImpDataList As %String) As %String
{
	n (ImpDataList)
	s itemdesc=$p(ImpDataList,"^",1) 	 /// 一级

	Q:itemdesc="" ""
	s itemid1=..isExistItemCat(itemdesc,0)
	i itemid1="" D
	.s itemid1=..InsTreeAdd(itemdesc,itemdesc,0,1,1)

	s itemdesc=$p(ImpDataList,"^",2) 	 /// 二级
	s itemid2=..isExistItemCat(itemdesc,itemid1)
	i itemid2="" D
	.s itemid2=..InsTreeAdd(itemdesc,itemdesc,itemid1,2,1)
	
	s itemdesc=$p(ImpDataList,"^",3) 	 /// 三级
	s itemid3=..isExistItemCat(itemdesc,itemid2)
	i (itemid3="")&(+itemdesc'=1) D
	.s itemid3=..InsTreeAdd(itemdesc,itemdesc,itemid2,2,1)

	s itemdesc=$p(ImpDataList,"^",4) 	     /// 部位
	s PartID=$o(^DHCAPPART(0,"Code",itemdesc,""))

	Q:(+itemdesc'=1)&(PartID="") ""
	
	s itmmastcode=$p(ImpDataList,"^",5) 	 /// 医嘱项代码
	s itmmastid=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itmmastcode),""))

	Q:itmmastid="" ""
	s itmmastver=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itmmastcode),itmmastid,""))

	Q:itmmastver="" ""
	s arcitmid=itmmastid_"||"_itmmastver
	//Q:(+itemdesc'=1)&$d(^DHCAPPTRA(0,"Arc",arcitmid))&$d(^DHCAPPTRA(0,"Part",+PartID)) ""
	
	i itemid3="" s itemid3=itemid2
    s Err=0
    i PartID'="" d
	.s Err=##Class(web.DHCAPPTreeAdd).CheckItmRep(itemid3, PartID, arcitmid)  ///部位不为空，判断分类+部位+医嘱项
	e  d
	.s Err=##Class(web.DHCAPPTreeAdd).CheckItm(itemid3, arcitmid)             ///部位为空，判断分类+医嘱项
    q:Err'=0 "-9"
     
	D ..InsTreeLink(itemid3,PartID,arcitmid)
	Q 0
}

///  Descript:  判断分类是否相同
///  w ##Class(web.DHCEMImpTools).isExistItemCat("上肢","40")
ClassMethod isExistItemCat(itemdesc As %String, lastitemid As %String) As %String
{
	n (itemdesc, lastitemid)
	s tmpitemid=""
	s itemid=""
	f  s itemid=$o(^DHCAPPTRA(0,"Code",itemdesc,itemid)) Q:(itemid="")||(tmpitemid'="")  D
	.s itemlevid=$p(^DHCAPPTRA(itemid),"^",4)
	.Q:itemlevid'=lastitemid
	.s tmpitemid=itemid
	Q tmpitemid
}

/// Descript:  检查分类树维护表
ClassMethod InsTreeAdd(itemCode As %String, itemDesc As %String, lastLevId As %String, leveId As %String, hospID As %String) As %String
{
	n (itemCode,itemDesc,lastLevId,leveId,hospID)
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_Level,TRA_LastRowid,TRA_Hosp_Dr)
		values(:itemCode,:itemDesc,:leveId,:lastLevId,:hospID))
	Q +%ROWID
}

/// Descript:  检查分类树维护表
ClassMethod InsTreeLink(TraID As %String, PartID As %String, ItmmastID As %String) As %String
{
	n (TraID, PartID, ItmmastID)
	s StartDate=..%SysDate()
	s OrdNum=##class(web.DHCAPPTreeAdd).GetMaxOrdsubNum(TraID)
	s ChildSub=$o(^DHCAPPTRA(TraID,"I",""),-1)+1
	&sql(insert into DHC_AppTreeLink(TRA_Add_ParRef,TRA_ChildSub,TRA_Part_Dr,TRA_Arc_Dr,TRA_StDate,TRA_OrdNum) 
		values(:TraID,:ChildSub,:PartID,:ItmmastID,:StartDate,:OrdNum))
    q SQLCODE
}

/// Descript: 更新分类树中项目的顺序号
/// w ##class(web.DHCEMImpTools).UpTreeLinkNum()
ClassMethod UpTreeLinkNum() As %String
{
	s TraID=0
	f  s TraID=$o(^DHCAPPTRA(TraID)) q:TraID=""  d
	.s OrdNum=1,Sub=0  
	.f  s Sub=$o(^DHCAPPTRA(TraID,"I",Sub)) q:Sub=""  d
	..;s ^DHCAPPTRALog("Update",TraID,"I",Sub)=^DHCAPPTRA(TraID,"I",Sub) ;记录更新数据
	..s $p(^DHCAPPTRA(TraID,"I",Sub),"^",5)=OrdNum
	..s OrdNum=OrdNum+1
	q 1
}

/// Descript:  测试导数据
/// w ##Class(web.DHCEMImpTools).ImportTest("f:\ggn.txt")
ClassMethod ImportTest(ImpDataList As %String) As %String
{
	n (ImpDataList)
	s incidesc=$p(ImpDataList,"^",10) 	 //药品通用名
	F i=1:1:9 d
	.s incicode=$p(ImpDataList,"^",i)
	.q:incicode=""
	.s ^TMP("DHCST","web.DHCEMImpTools","ImportTest",incicode)=incicode_"^"_incidesc
	Q ""
}

/// Descript: 导入 DHC_AppArcLink、DHC_AppArcLinkTar
ClassMethod ImpArcLinkTar(ImpDataList As %String) As %String
{
	n (ImpDataList)
	s itmmastcode=$p(ImpDataList,"^",1)    /// 医嘱项代码
	s TarItmCode=$p(ImpDataList,"^",2)     /// 收费项代码
	s PartCode=$p(ImpDataList,"^",3)       /// 部位代码
	s TarQty=+$p(ImpDataList,"^",4)        /// 数量
	s TarBaseFlag=$p(ImpDataList,"^",5)    /// 基价标志

	s PartID=$o(^DHCAPPART(0,"Code",PartCode,""))
	Q:PartID="" ""

	s itmmastid=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itmmastcode),""))
	Q:itmmastid="" ""
	s itmmastver=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itmmastcode),itmmastid,""))
	Q:itmmastver="" ""
	s arcitmid=itmmastid_"||"_itmmastver
	s TarID=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarItmCode),""))
	Q:TarID="" ""

	Q:..InsArcLink(arcitmid,PartID) ""    /// 插入DHC_AppArcLink
	D ..InsArcLinkTar(TarID,arcitmid,PartID,TarQty,TarBaseFlag)
	Q 0
}

/// Descript:  插入DHC_AppArcLink
ClassMethod InsArcLink(itmmastid As %String, PartID As %String) As %String
{
	n (itmmastid, PartID)
	&SQL(insert into DHC_AppArcLink(AL_Arc_Dr,AL_Part_Dr) values(:itmmastid,:PartID))
	Q SQLCODE
}

/// Descript:  插入DHC_AppArcLinkTar
ClassMethod InsArcLinkTar(TarID As %String, itmmastid As %String, PartID As %String, TarQty As %String, TarBaseFlag As %String) As %String
{
	n (TarID, itmmastid, PartID, TarQty, TarBaseFlag)
	s StartDate=..%SysDate()
	s StartTime=..%SysTime()
	&SQL(insert into DHC_AppArcLinkTar(ALT_Tar_Dr,ALT_Arc_Dr,ALT_StartDate,ALT_StartTime,ALT_Qty,ALT_BaseFlag,ALT_Part_Dr)
		 values(:TarID,:itmmastid,:StartDate,:StartTime,:TarQty,:TarBaseFlag,:PartID))
	Q SQLCODE
}

/// Descript:  导入部位表
ClassMethod ImpPart(ImpDataList As %String, pid As %String, hCount As %String) As %String
{
	n (ImpDataList,pid,hCount)
	s PartCode=$p(ImpDataList,"^",1)       /// 代码
	q:$d(^DHCAPPART(0,"Code",PartCode)) "-1"
	s PartDesc=$p(ImpDataList,"^",2)       /// 描述
	s LastPartDesc=$p(ImpDataList,"^",3)   /// 上级描述
	s PartNum=$p(ImpDataList,"^",4)        /// 数量
	s LastRowid=+$o(^DHCAPPART(0,"Code",LastPartDesc,""))
	S Err= ..InsAppPart(PartCode,PartDesc,LastRowid,PartNum,pid,hCount)
	Q Err
}

/// Descript:  插入部位表
ClassMethod InsAppPart(PartCode As %String, PartDesc As %String, LastRowid As %String, PartNum As %String, pid As %String, hCount As %String) As %String
{
	n (PartCode, PartDesc, LastRowid, PartNum,pid,hCount)
	S Err=1
	s tmpStr=""
	s HospID="65"
	s OrdNum=""
	s Level="1"
	s ActiveFlag="Y"
	&SQL(insert into DHC_APPPART (AP_Code, AP_Desc, AP_LastRowid, AP_Level, AP_ActiveFlag, AP_Hosp_Dr, AP_PartNum, AP_OrdNum) 
		values(:PartCode,:PartDesc,:LastRowid,:Level,:ActiveFlag,:HospID,:PartNum,:OrdNum))
	I SQLCODE'=0   S Err=..SaveImpWarnData(PartCode, PartDesc, LastRowid, PartNum,pid,hCount)  
	Q Err
}

/// 存储导入失败的数据到临时的global
/// Others: w ##class(web.DHCEMImpTools).getImpWarnData("12","1","")
ClassMethod SaveImpWarnData(PartCode As %String, PartDesc As %String, LastRowid As %String, PartNum As %String, pid As %String, hCount As %String) As %String
{
	
	n (PartCode, PartDesc, LastRowid, PartNum,pid,hCount)
	S TempStr=PartCode_"^"_PartDesc_"^"_LastRowid_"^"_PartNum
	S ^TMP("DHCAPP","web.DHCEMImpTools","getImpWarnData",pid,hCount)=TempStr
	Q pid
}

/// 获取失败的数据
/// Others: w ##class(web.DHCEMImpTools).GetImpWarnData("12","1","33786")
ClassMethod GetImpWarnData(rows As %String, page As %String, pid As %String) As %String
{
   	N (rows,page,pid)
	S End = page*rows
	S Start = (page-1)*rows+1
    s h=0,count=0
    
    s index=""
    F  S index=$o(^TMP("DHCAPP","web.DHCEMImpTools","getImpWarnData",pid,index)) Q:index=""  D
    .S h=h+1
  	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
  	q:h=0 ""
	///转换数据为Json格式
	S Title="PartCode^PartDesc^LastRowid^PartNum"
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCAPP","web.DHCEMImpTools","getImpWarnData",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCAPP","web.DHCEMImpTools","getImpWarnData",pid,index))
	.S count = count+1
	.I count=Start D   //Start
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdate)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	K ^TMP("DHCAPP","web.DHCEMImpTools","getImpWarnData",pid)
	Q ""
}

/// Descript:  导入部位子项目
ClassMethod ImpPartItem(ImpDataList As %String) As %String
{
	n (ImpDataList)
	s PartDesc=$p(ImpDataList,"^",1)       /// 父部位
	s SubPartDesc=$p(ImpDataList,"^",2)    /// 子部位
	s PartID=$o(^DHCAPPART(0,"Code",PartDesc,""))
	Q:PartID="" ""
	s SubPartID=$o(^DHCAPPART(0,"Code",SubPartDesc,""))
	Q:SubPartID="" ""
	D ..InsAppPartItem(PartID,SubPartID)
	Q ""
}

/// Descript:  插入部位字典表
ClassMethod InsAppPartItem(PartID As %String, SubPartID As %String) As %String
{
	n (PartID, SubPartID)
	s ChildSub=$o(^DHCAPPART(PartID,"I",""),-1)+1
	&SQL(insert into DHC_AppPartItm (API_ParRef_Dr, API_ChildSub, API_Part_Dr) 
		values(:PartID,:ChildSub,:SubPartID))
	Q SQLCODE
}

/// Descript:  插入部位字典表
/// w ##Class(web.DHCEMImpTools).SetPartPyCode()
ClassMethod SetPartPyCode() As %String
{
	s PartID=""
	f  s PartID=$o(^DHCAPPART(PartID)) Q:PartID=""  D
	.Q:+PartID=0
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)
	.s PartPyCode=##class(web.DHCST.Common.AppCommon).GetCNCODE(PartDesc)
	.Q:PartPyCode=""
	.&SQL(update DHC_AppPart set AP_Alias=:PartPyCode where AP_RowId=:PartID)
	.w PartDesc_"^"_PartPyCode,!
	Q ""
}

/// Descript:  检查树拼音码
/// w ##Class(web.DHCEMImpTools).SetCheckCatTreePyCode()
ClassMethod SetCheckCatTreePyCode() As %String
{
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(TraID)) Q:TraID=""  D
	.Q:+TraID=0
	.s LastLevID=$p(^DHCAPPTRA(TraID),"^",4)
	.Q:'$o(^DHCAPPTRA(TraID,"I",""))
	.//Q:LastLevID'=0
	.s TraDesc=$p(^DHCAPPTRA(TraID),"^",2)
	.s PartPyCode=##class(web.DHCST.Common.AppCommon).GetCNCODE(TraDesc)
	.Q:PartPyCode=""
	.&SQL(update DHC_AppTreeAdd set TRA_Alias=:PartPyCode where TRA_RowID=:TraID)
	.w TraDesc_"^"_PartPyCode,!
	Q ""
}

/// Descript:  检查项目是否已经维护检查分类
/// w ##Class(web.DHCEMImpTools).CheckArcIsService()
ClassMethod CheckArcIsService() As %String
{
	s InString=""
	s itmmastid="" 
	f  s itmmastid=$o(^ARCIM(itmmastid)) Q:itmmastid=""  D
	.Q:itmmastid=0
	.s itmmastver="" 
	.f  s itmmastver=$o(^ARCIM(itmmastid,itmmastver)) Q:itmmastver=""  D
	..Q:'$D(^ARCIM(itmmastid,itmmastver))
	..s ServerMaterial=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",6)
	..Q:(ServerMaterial'="Service")&(ServerMaterial'="S")
	..s itmCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	..Q:$d(^DHCAPARCCA(0,"Cat",itmCatID))
	..s itmCatDesc=$p(^ARC("IC",itmCatID),"^",2)
	..S InStrArrList=$LISTFROMSTRING(InString,",")
    ..q:$lf(InStrArrList,itmCatDesc)'=0
    ..s InString=InString_","_itmCatDesc
	.
	Q InString
}

/// Descript: 临时存储其他项目
/// W ##Class(web.DHCEMImpTools).InsTmpGlobal("1","河南省人民医院^检查^1.2^放射^放射^放射^")
ClassMethod InsTmpGlobal(pid As %String, mListData As %String) As %String
{
	n (pid, mListData)
    s Hospital=$p(mListData,"^",1) /// 医院
    Q:Hospital="" "-1"
    s HospID=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),""))
    Q:HospID="" "-2"
    s itemType=$p(mListData,"^",2) /// 类型
    s itemType=$$ALPHAUP^SSUTIL4(itemType)
    s itemType=$s(itemType="检查":"E",itemType="检验":"L",itemType="病理":"P",1:"E")
    s itemCode=$p(mListData,"^",3) /// 代码
    s index=HospID_"^"_itemCode
    Q:$D(^TMP("DHCST","web.DHCEMImpTools","TmpInsCode",pid,index)) "-3"
	s ^TMP("DHCST","web.DHCEMImpTools","TmpInsCode",pid,index)=""
	s Level=..GetTreLev(mListData) /// 级别
	Q:Level=0 "-4"
	s LastItmDesc=$p(mListData,"^",$s(Level>2:2+Level,1:4))
	s itemDesc=$p(mListData,"^",3+Level)
	s ^TMP("DHCST","web.DHCEMImpTools","TmpInsTree",pid,$I(^TMP("EMImpTools")))=itemCode_"^"_itemDesc_"^"_LastItmDesc_"^"_HospID_"^"_Hospital_"^"_itemType_"^"_Level
	Q 0
}

/// Descript:  检查分类树维护表
/// W ##Class(web.DHCEMImpTools).InsTreeData("1")
ClassMethod InsTreeData(pid As %String) As %String
{
	n (pid)
	s Err=0
	TS
	s index=""
	F  s index=$o(^TMP("DHCST","web.DHCEMImpTools","TmpInsTree",pid,index)) Q:(index="")||(Err'=0)  D
	.s mListData=$g(^TMP("DHCST","web.DHCEMImpTools","TmpInsTree",pid,index))
	.Q:mListData=""
	.s itmCode=$p(mListData,"^",1)   /// 代码
	.s itmDesc=$p(mListData,"^",2)   /// 描述
	.s LastDesc=$p(mListData,"^",3)  /// 上级描述
	.s HospID=$p(mListData,"^",4)    /// 医院
	.s TraType=$p(mListData,"^",6)   /// 类型
	.s TraLev=$p(mListData,"^",7)    /// 级别
	./// 取描述拼音码
	.s PyCode=itmCode ;##Class(web.DHCST.Common.AppCommon).GetCNCODE(itmDesc)
	.s LastID="",ID=""
	.f  s ID=$o(^DHCAPPTRA(0,"LevDesc",TraLev-1,$$ALPHAUP^SSUTIL4(LastDesc),ID)) q:ID=""  d
	..q:$P(^DHCAPPTRA(ID),"^",5)'=HospID
	..s LastID=ID
	.s OrdNum=..GetMaxOrdNum(LastID,HospID) /// 序号
	.s Err=..InsTree(itmCode, itmDesc, +LastID, HospID, PyCode, OrdNum, TraType, TraLev)
	.i Err'=0 s Err="错误代码："_Err_" 错误分类描述："_itmDesc_" 上级描述："_itmDesc
	.
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	d ..killTmpGlobal(pid) //k掉临时global
	Q Err
}

/// Descript:  判断导入数据节点个数,作为层级显示
/// W ##Class(web.DHCEMImpTools).GetTreLev("东华标准版数字化医院[总院]^检查^1^放射^^^")
ClassMethod GetTreLev(mListData As %String) As %String
{
	n (mListData)
	s Num=0
	F i=4:1:$L(mListData,"^")  D
	.s itemDesc=$p(mListData,"^",i)
	.Q:itemDesc=""
	.s Num=Num+1
	.
	Q Num
}

/// Descript:  取检查分类树序号
ClassMethod GetMaxOrdNum(Lastlevid As %String, HospID) As %String
{
	n (Lastlevid,HospID)
	s MaxNum=0
	i +Lastlevid=0  d
	.s TraID=""
	.f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",+Lastlevid,TraID))  q:TraID=""  d
	..q:$P(^DHCAPPTRA(TraID),"^",5)'=HospID
	..s MaxNum=MaxNum+1
	e  d
	.s TraID=""
	.f  s TraID=$o(^DHCAPPTRA(0,"LastRowid",Lastlevid,TraID)) q:TraID=""  d
	..q:$P(^DHCAPPTRA(TraID),"^",5)'=HospID
	..s Ordnum=$p(^DHCAPPTRA(+TraID),"^",6)
	..i Ordnum>MaxNum s MaxNum=Ordnum
	s MaxNum=MaxNum+1
	q MaxNum
}

/// Descript:  取检查分类项目序号
ClassMethod GetMaxOrdsubNum(TraID As %String) As %String
{
	n (TraID)
	s MaxNum=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH))  q:CH=""  d
	.s Ordnum=$p(^DHCAPPTRA(TraID,"I",CH),"^",5)
	.i Ordnum>MaxNum s MaxNum=Ordnum
	s MaxNum=MaxNum+1
	q MaxNum
}

/// Descript:  检查分类树维护表
ClassMethod InsTree(itemCode As %String, itemDesc As %String, LastID As %String, HospID As %String, PyCode As %String, OrdNum As %String, TraType As %String, TraLev As %String) As %String
{
	n (itemCode, itemDesc, LastID, HospID, PyCode, OrdNum, TraType, TraLev)
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_OrdNum,TRA_Alias,TRA_Type,TRA_Level)
		values(:itemCode,:itemDesc,:LastID,:HospID,:OrdNum,:PyCode,:TraType,:TraLev))
	Q SQLCODE
}

/// Descript: 临时存储导入数据
/// W ##Class(web.DHCEMImpTools).InsTmpArcGlobal("1","放射^JC002029^ 临床操作的彩色超声引导^鼻骨")
ClassMethod InsTmpArcGlobal(pid As %String, mListData As %String, HospID As %String = "") As %String
{
	n (pid, mListData)
    s itmCatDesc=$p(mListData,"^",1) /// 分类名称
    Q:itmCatDesc="" 0
    s Hospital=$p(mListData,"^",5)  /// 医院
	s HospID=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),""))
	Q:HospID="" "-5"
    s itmCatID=..GetLeafNode(itmCatDesc,HospID) //$o(^DHCAPPTRA(0,"Desc",$$ALPHAUP^SSUTIL4(itmCatDesc),""))
    Q:itmCatID="" "-1"
    s itemCode=$p(mListData,"^",2) /// 医嘱项代码
    s itemDesc=$p(mListData,"^",3) /// 医嘱项
    s itmmastid=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itemCode),""))
	Q:itmmastid="" "-2"
	s itmmastver=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(itemCode),itmmastid,""))
	Q:itmmastver="" "-3"
	s arcitmid=itmmastid_"||"_itmmastver
	s PartID="",LPartID=""
	s PartDesc=$p(mListData,"^",4) /// 部位
	i PartDesc'="" s PartID=$o(^DHCAPPART(0,"Code",PartDesc,""))
	i PartID'="" s LPartID=$p(^DHCAPPART(PartID),"^",3)
	Q:(PartID'="")&(LPartID=0) "-4"
	q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcitmid,HospID)="N" "-6"
	s ^TMP("DHCST","web.DHCEMImpTools","TmpInsTreeLink",pid,$I(^TMP("EMImpTools")))=itmCatID_"^"_itmCatDesc_"^"_arcitmid_"^"_itemDesc_"^"_PartID_"^"_PartDesc
	Q 0
}

/// Descript:  检查分类树维护表
/// W ##Class(web.DHCEMImpTools).InsTreeArcData("1")
ClassMethod InsTreeArcData(pid As %String) As %String
{
	n (pid)
	s Err=0
	TS
	s index=""
	F  s index=$o(^TMP("DHCST","web.DHCEMImpTools","TmpInsTreeLink",pid,index)) Q:(index="")||(Err'=0)  D
	.s mListData=$g(^TMP("DHCST","web.DHCEMImpTools","TmpInsTreeLink",pid,index))
	.Q:mListData=""
	.s itmCatID=$p(mListData,"^",1)   /// 分类ID
	.s itmCatDesc=$p(mListData,"^",2) /// 分类
	.s itmmastid=$p(mListData,"^",3)  /// 医嘱项ID
	.s itemDesc=$p(mListData,"^",4)   /// 医嘱项
	.s PartID=$p(mListData,"^",5)     /// 部位ID
	.s PartDesc=$p(mListData,"^",6)   /// 部位
	.s Err=..InsTreeLink(itmCatID, PartID, itmmastid)
	.i Err'=0 s Err="错误代码："_Err_" 错误分类描述："_itmCatDesc_" 医嘱项："_itemDesc_" 部位："_PartDesc
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	d ..killTmpGlobal(pid) //k掉临时global
	Q Err
}

/// Descript:  取为叶子节点的指定分类描述
/// W ##Class(web.DHCEMImpTools).GetLeafNode("放射")
ClassMethod GetLeafNode(Node As %String, HospID As %String = "") As %String
{
	n (Node,HospID)
	s ID="",QuitFlag=0
	F  s ID=$o(^DHCAPPTRA(0,"Desc",$$ALPHAUP^SSUTIL4(Node),ID)) Q:(ID="")||(QuitFlag=1)  D
	.Q:$D(^DHCAPPTRA(0,"LastRowid",ID))
	.q:((HospID'="")&&(HospID'=$P(^DHCAPPTRA(ID),"^",5)))
	.s LeafID=ID
	.s QuitFlag=1
    Q LeafID
}

/// Description:	检查分类树维护(病理部分数据)固定数据
/// Creator:		QuNianpeng
/// CreateDate:		2018-02-24
/// Input:			
/// return:			
/// other:			d ##class(web.DHCEMImpTools).InsTreeAddData()
ClassMethod InsTreeAddData() As %String
{
	s $ZT="err"
	
	// 根节点 病理
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("病理","病理",0,2,"BL","P"))
	s LastRowId=+%ROWID
	
	// 活体组织病理申请单 LIV
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("LIV","活体组织病理申请单",:LastRowId,2,"HTZZBLSQD","P"))
	
	// 细胞学病理申请单   CYT
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("CYT","细胞学病理申请单",:LastRowId,2,"XBXBLSQD","P"))
	
	// 妇科TCT申请单      TCT
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("TCT","妇科TCT申请单",:LastRowId,2,"FKTCTSQD","P"))
		
	// 外院会诊病理申请单 CON
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("CON","外院会诊病理申请单",:LastRowId,2,"WYHZBLSQD","P"))
		
	// HPV检查申请单	  HPV
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("HPV","HPV检查申请单",:LastRowId,2,"HPVJCSQD","P"))
	
	// 分子病理申请单     MOL
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("MOL","分子病理申请单",:LastRowId,2,"FZBLSQD","P"))
	
	// 尸检申请单		  APY	
	&SQL(insert into DHC_AppTreeAdd(TRA_Code,TRA_Desc,TRA_LastRowid,TRA_Hosp_Dr,TRA_Alias,TRA_Type)
		values("APY","尸检申请单",:LastRowId,2,"SJSQD","P"))
		
	q 1
err 
    s msg=$ZE
	q msg
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCEMImpTools","TmpInsCode",pid)
	k ^TMP("DHCST","web.DHCEMImpTools","TmpInsDesc",pid)
	k ^TMP("DHCST","web.DHCEMImpTools","TmpInsTree",pid)
	k ^TMP("DHCST","web.DHCEMImpTools","TmpInsTreeLink",pid)
	k ^TMP("DHCAPP","web.DHCEMImpTools","InsPartTmpGlobal",pid)
	q ""
}

/// Descript:预检分级症状导入
/// w ##Class(web.DHCEMImpTools).ImportSymptom("d:\symptom.txt")
ClassMethod ImportSymptom(filepath As %String) As %String
{
	N (filepath)

	S pid=##class(web.DHCADVCOMMON).NewPid()
	S hCount=0,succ=0,conCount=0
	s Err=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	s symptomLevelOne=""
	s symptomLevelTwo=""
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s ImpDataList=$tr(onerow,$c(9),del)
	.S hCount=hCount+1
	.s Symptom1=$p(ImpDataList,"^",1)       /// 症状分级1
	.s Symptom2=$p(ImpDataList,"^",2)       /// 症状分级2
	.s Symptom=$p(ImpDataList,"^",3)        /// 症状
	.s level=$p(ImpDataList,"^",4)          /// 等级
	.s:Symptom1'="" symptomLevelOne=Symptom1
	.s:Symptom2'="" symptomLevelTwo=Symptom2
	.
	.q:symptomLevelOne=""
	.q:symptomLevelTwo=""
	.q:Symptom=""
	.
	.//一级症状分级
	.//##class(web.DHCAdvAction).ALPHAUP()
	.s expCode=symptomLevelOne_":"_symptomLevelTwo_":"_Symptom
	.
	.s escapeExpCode=$REPLACE(expCode,".and.","")
	.s escapeExpCode=$REPLACE(escapeExpCode,".or.","")
	.s escapeExpCode=$REPLACE(escapeExpCode,".not","")
	.s escapeExpCode=$TR(escapeExpCode,$c(34),"") //双引号
	.s escapeExpCode=$TR(escapeExpCode,$c(40),"") //(
	.s escapeExpCode=$TR(escapeExpCode,$c(41),"") //)
	.s escapeExpCode=$TR(escapeExpCode,$c(91),"") //[
	.s escapeExpCode=$TR(escapeExpCode,$c(93),"") //]
	.s Symptom1Id=$o(^User.DHCSymptomLevI("DescIndex"," "_symptomLevelOne,""))
	.i +Symptom1Id=0 d
	..s tmpOneObj=##class(User.DHCSymptomLev).%New()
	..s tmpOneObj.SYLCode=symptomLevelOne
	..s tmpOneObj.SYLDesc=symptomLevelOne
	..s sc=tmpOneObj.%Save()
	..If $System.Status.IsError(sc) d $System.Status.DisplayError(sc)
	..s Symptom1Id=tmpOneObj.%Id()
	.
	.//二级症状分级
	.s Symptom2Id=$o(^User.DHCSymptomLevI("DescIndex"," "_symptomLevelTwo,""))
	.i +Symptom2Id=0 d
	..s tmpTwoObj=##class(User.DHCSymptomLev).%New()
	..s tmpTwoObj.SYLCode=symptomLevelTwo
	..s tmpTwoObj.SYLDesc=symptomLevelTwo
	..d tmpTwoObj.SYLLastRowidSetObjectId(Symptom1Id)
	..s sc=tmpTwoObj.%Save()
	..If $System.Status.IsError(sc) d $System.Status.DisplayError(sc)
	..s Symptom2Id=tmpTwoObj.%Id()
	.
	.
	.//症状
	.s SymptomId=$o(^DHCSYMFEI("0","Code",expCode,"")) 
	.i +SymptomId=0 d
	..s tmpSymObj=##class(User.DHCSymptomFeild).%New()
	.e  d
	..s tmpSymObj=##class(User.DHCSymptomFeild).%OpenId(+SymptomId)
	.s tmpSymObj.SYFDesc=escapeExpCode
	.s tmpSymObj.SYFActiveFlag="Y"
	.s tmpSymObj.SYFCode=expCode
	.s sc=tmpSymObj.%Save()
	.If $System.Status.IsError(sc) d $System.Status.DisplayError(sc)
	.s SymptomId=tmpSymObj.%Id()
	.//症状分级和症状关联
	.s ConId=$o(^DHCSYMCONi(0,Symptom2Id,SymptomId,""))
	.i +ConId=0 d
	..s conObj=##class(User.DHCSymptomCon).%New()
	..d conObj.SYCFieldDrSetObjectId(SymptomId)
	..d conObj.SYCLevDrSetObjectId(Symptom2Id)
	..d conObj.%Save()
	..s conCount=conCount+1
	.
	.
	.s themeId=1
	.s expId=$o(^DHCEMLEX("0","Code",expCode,""))
	.
	.i +expId=0 d
	..s expObj=##class(User.DHCEmLevExpress).%New()
	.e  d
	..s expObj=##class(User.DHCEmLevExpress).%OpenId(expId)
	.s expObj.LEXActiveFlag="Y"
	.s expObj.LEXCode=expCode
	.s expObj.LEXDesc=expCode
	.s expObj.LEXText="(#Sym.checkSym(["_escapeExpCode_"]))"
	.s sc=expObj.%Save()
	.If $System.Status.IsError(sc) d $System.Status.DisplayError(sc)
	.s expId=expObj.%Id()
	.
	.s themItmId=$o(^DHCEMLTH(0,"LTIDesc",expId,themeId,""))
	.i +themItmId=0 d
	..s themItmObj=##class(User.DHCEmLevTheItm).%New()
	..s themItmObj.LTIChildSub=+$o(^DHCEMLTH(themeId,"L",""),-1)+1
	..d themItmObj.LTITheParRefSetObjectId(themeId)
	.e  d
	..s themItmObj=##class(User.DHCEmLevTheItm).%OpenId(themeId_"||"_+themItmId)
	.s themItmObj.LTIActiveFlag="Y"
	.s themItmObj.LTILev=level
	.d themItmObj.LTIDescSetObjectId(expId)
	.s sc=themItmObj.%Save()
	.If $System.Status.IsError(sc) d $System.Status.DisplayError(sc)
	.s succ=succ+1
	c filepath 
	s ^ZXZX=hCount_"^"_succ_"^"_conCount
	Q succ
}

/// Creator:sufan
/// Descript: 临时存储部位导入数据
/// W ##Class(web.DHCEMImpTools).InsPartTmpGlobal("1","腔内D^腔内^腔内D^1")"1%经直肠+前列腺^经直肠+前列腺^腔内D^1"
ClassMethod InsPartTmpGlobal(pid As %String, mListData As %String) As %String
{
	n (pid, mListData)
	s ^tempsufan("00")=pid_"%"_mListData
   	s PartCode=$p(mListData,"^",1)       	 /// 代码
   	q:PartCode="" 0
	q:$d(^DHCAPPART(0,"Code",PartCode)) "-1"
	s PartDesc=$p(mListData,"^",2)        	 /// 描述
	s LastPartDesc=$p(mListData,"^",3)   	 /// 上级描述
	s PartNum=$p(mListData,"^",4)            /// 数量
	s ^TMP("DHCAPP","web.DHCEMImpTools","InsPartTmpGlobal",pid,$I(^TMP("EMImpTools")))=PartCode_"^"_PartDesc_"^"_LastPartDesc_"^"_PartNum
	Q 0
}

/// W ##Class(web.DHCEMImpTools).InsPartData("1")
ClassMethod InsPartData(pid As %String) As %String
{
	n (pid, %session)
	s Err=0
	TS
	s index=""
	F  s index=$o(^TMP("DHCAPP","web.DHCEMImpTools","InsPartTmpGlobal",pid,index)) Q:(index="")||(Err'=0)  D
	.s mListData=$g(^TMP("DHCAPP","web.DHCEMImpTools","InsPartTmpGlobal",pid,index))
	.Q:mListData=""
	.s PartCode=$p(mListData,"^",1)       	 /// 代码
	.s PartDesc=$p(mListData,"^",2)        	 /// 描述
	.s LastPartDesc=$p(mListData,"^",3)  		 /// 上级ID
	.s PartNum=$p(mListData,"^",4)          /// 数量
	.s Err=..InsPart(PartCode, PartDesc, LastPartDesc, PartNum)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	d ..killTmpGlobal(pid) //k掉临时global
	Q Err
}

/// Descript:  插入DHC_AppPart
ClassMethod InsPart(PartCode As %String, PartDesc As %String, LastPartDesc As %String, PartNum As %String, HospID As %String = "") As %String
{
	n (PartCode, PartDesc, LastPartDesc, PartNum, %session)
	s HospID=%session.Data("LOGON.HOSPID")
	s ActiveFlag="Y"
	s LastRowid=+$o(^DHCAPPART(0,"Code",LastPartDesc,""))
	s OrdNum=..GetPartOrdnum(LastRowid)
	&SQL(insert into DHC_AppPart(AP_Code,AP_Desc,AP_LastRowid,AP_PartNum,AP_ActiveFlag,AP_Hosp_Dr,AP_OrdNum)
		 values(:PartCode,:PartDesc,:LastRowid,:PartNum,:ActiveFlag,:HospID,:OrdNum))
	Q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMImpTools","FindAPPTreeTemp")
Query FindAPPTreeTemp() As %SQLQuery(ROWSPEC = "HospID:%String:医院, type:%String:类型, Code:%String:代码,Code1:%String:一级分类, Code2:%String:二级分类, Code3:%String:三级分类, Code4:%String:四级分类")
{
}

ClassMethod FindAPPTreeTempExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","1","超声","","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","1.1","彩超","","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","1.2","普超","","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","2","CT","","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","2.1","CT","CT16排","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","2.1.1","CT","CT16排","CT16排门诊","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","2.2","CT","CT64排","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检查","2.2.1","CT","CT64排","CT64排门诊","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检验","3","眼科检查","","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检验","3.1","眼科检查","眼底照相","","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("东华标准版数字化医院[总院]","检验","3.2","眼科检查","眼科B超","","")
	s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindAPPTreeTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAPPTreeTempExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAPPTreeTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAPPTreeTempExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMImpTools","FindArcTemp")
Query FindArcTemp() As %SQLQuery(ROWSPEC = "Temp1:%String:分类名称, Temp2:%String:项目代码,Temp3:%String:项目描述,Temp4:%String:部位, Temp5:%String:医院, Temp6:%String:类型")
{
}

ClassMethod FindArcTempExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s ^CacheTemp(repid,ind)=$lb("彩超","F00000006116","床旁彩色多普勒超声检查加收","","东华标准版数字化医院[总院]","")	
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("普超","F00000002924","门静脉系彩色多普勒超声","","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("诱发电位","F00000000178","经颈内静脉、肝内门腔静脉分流术(TIPS)","","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("CT16排门诊","ZT001847","CT平扫（16排）","腹部","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("CT16排门诊","ZT001847","CT平扫（16排）","骨盆","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("CT64排门诊","ZT001851","CT平扫（64排）","腹部","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("CT64排门诊","ZT001851","CT平扫（64排）","骨盆","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼科共焦显微镜","F00000002921","颅内段血管彩色多普勒超声","","东华标准版数字化医院[总院]","")
	s ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼科共焦显微镜","F00000002628","经颈内静脉、肝内门腔静脉分流术(TIPs)用支架","","东华标准版数字化医院[总院]","")
	s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindArcTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcTempExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindArcTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcTempExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMImpTools","FindPartTemp")
Query FindPartTemp() As %SQLQuery(ROWSPEC = "Temp1:%String:部位代码, Temp2:%String:部位描述,Temp3:%String:上级部位,Temp4:%String:部位数量")
{
}

ClassMethod FindPartTempExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s ^CacheTemp(repid,ind)=$lb("组合部位","组合部位","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("组合部位","组合部位","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头部","头部","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部","颈部","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("五官","五官","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部","胸部","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊柱","脊柱","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腹部","腹部","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上肢","上肢","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下肢","下肢","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("（颈+胸+全腹+盆腔）","（颈+胸+全腹+盆腔）","组合部位","5"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("（全腹部+盆腔）","（全腹部+盆腔）","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("（头+颈+胸+全腹+盆腔）","（头+颈+胸+全腹+盆腔）","组合部位","6"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("（胸部+全腹部）","（胸部+全腹部）","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("（胸部+全腹部+盆腔）","（胸部+全腹部+盆腔）","组合部位","4"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("MRCP胰胆管","MRCP胰胆管","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("MRU泌尿系","MRU泌尿系","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肝脏+肝静脉+下腔静脉","肝脏+肝静脉+下腔静脉","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("冠脉造影（非医保）","冠脉造影（非医保）","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("冠脉造影（医保）","冠脉造影（医保）","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("茎突","茎突","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈、胸","颈、胸","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈、胸、盆腔","颈、胸、盆腔","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈、胸、上腹部","颈、胸、上腹部","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈+胸+全腹+盆腔","颈+胸+全腹+盆腔","组合部位","5"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部、盆腔","颈部、盆腔","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部+全腹部+盆腔","颈部+全腹部+盆腔","组合部位","4"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部+胸部","颈部+胸部","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部+胸部+全腹部+盆腔","颈部+胸部+全腹部+盆腔","组合部位","5"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部+胸部+上腹部","颈部+胸部+上腹部","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("门静脉+肠系膜静脉","门静脉+肠系膜静脉","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("泌尿系平扫+增强三维","泌尿系平扫+增强三维","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("泌尿系三维成像","泌尿系三维成像","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞骨增强+肋软骨平扫","颞骨增强+肋软骨平扫","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞骨轴位+听小骨","颞骨轴位+听小骨","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞骨轴位平扫+听小骨","颞骨轴位平扫+听小骨","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全腹部+盆腔","全腹部+盆腔","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全脊柱三维成像（颈胸腰椎）","全脊柱三维成像（颈胸腰椎）","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("三叉神经与血管关系","三叉神经与血管关系","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("三维重建","三维重建","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("三维重建（宝石）","三维重建（宝石）","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上腹部+盆腔","上腹部+盆腔","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肾脏、肾上腺","肾脏、肾上腺","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头+颈+胸+全腹+盆腔","头+颈+胸+全腹+盆腔","组合部位","6"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头部+颈部+胸部+盆腔","头部+颈部+胸部+盆腔","组合部位","4"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头部+颈部+胸部+全腹部","头部+颈部+胸部+全腹部","组合部位","5"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头部+颈部+胸部+全腹部+盆腔","头部+颈部+胸部+全腹部+盆腔","组合部位","6"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头部+胸部+全腹部","头部+胸部+全腹部","组合部位","4"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下腹部+盆腔","下腹部+盆腔","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下腔静脉及门静脉","下腔静脉及门静脉","组合部位","4"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸、全腹部","胸、全腹部","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸、上腹部","胸、上腹部","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部、盆腔","胸部、盆腔","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部+全腹部","胸部+全腹部","组合部位","3"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部+全腹部+盆腔","胸部+全腹部+盆腔","组合部位","4"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部+上腹部","胸部+上腹部","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部超高分辨","胸部超高分辨","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("主动脉（胸主动脉+腹主动脉）","主动脉（胸主动脉+腹主动脉）","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("主动脉血管（胸主动脉+腹主动脉）","主动脉血管（胸主动脉+腹主动脉）","组合部位","2"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("血管斑块","血管斑块","组合部位","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("垂体","垂体","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("蝶鞍区","蝶鞍区","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("海马薄","海马薄","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("海马薄层","海马薄层","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("海绵窦","海绵窦","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颅底冠位","颅底冠位","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颅底-颈3","颅底-颈3","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颅底轴位","颅底轴位","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颅骨薄层","颅骨薄层","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颅颈交界（颅底）","颅颈交界（颅底）","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颅颈交界（颅底-颈3）","颅颈交界（颅底-颈3）","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脑灌注","脑灌注","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞骨","颞骨","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞骨冠位","颞骨冠位","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞骨轴位","颞骨轴位","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颞颌关节","颞颌关节","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颧骨","颧骨","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上颚","上颚","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胎儿头颅","胎儿头颅","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头部","头部","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头颈CTA","头颈CTA","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头颅","头颅","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头颅CTA（非医保）","头颅CTA（非医保）","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("头颅CTA（医保）","头颅CTA（医保）","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("中脑导水管薄层","中脑导水管薄层","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脑","脑","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脑脊液","脑脊液","头部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("喉部","喉部","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("喉咽部","喉咽部","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("寰枢关节","寰枢关节","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("甲状腺","甲状腺","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部","颈部","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部动脉血管","颈部动脉血管","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部对比CE-MRA","颈部对比CE-MRA","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部静脉血管","颈部静脉血管","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈部（甲状腺、喉部）","颈部（甲状腺、喉部）","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈胸段","颈胸段","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈胸腰段","颈胸腰段","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈椎","颈椎","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈椎（颅底-颈3）","颈椎（颅底-颈3）","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颈椎C4-C7","颈椎C4-C7","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腮腺","腮腺","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("锁骨","锁骨","颈部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("鼻部","鼻部","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("鼻窦","鼻窦","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("鼻窦轴位","鼻窦轴位","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("鼻骨","鼻骨","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("鼻咽部","鼻咽部","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("耳及乳突","耳及乳突","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("副鼻窦冠状位","副鼻窦冠状位","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("副鼻窦轴位","副鼻窦轴位","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颌面","颌面","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("颌面部","颌面部","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("口咽","口咽","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("口咽部","口咽部","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("内耳","内耳","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("内听动脉","内听动脉","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上颌窦","上颌窦","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上颌骨","上颌骨","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("视路神经","视路神经","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下颌骨","下颌骨","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼部","眼部","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼及眼眶","眼及眼眶","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼眶","眼眶","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼眶冠位","眼眶冠位","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼眶轴位","眼眶轴位","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("眼球","眼球","五官","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肺、纵膈","肺、纵膈","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肺动脉","肺动脉","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肺静脉","肺静脉","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肋骨","肋骨","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肋软骨","肋软骨","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("气道","气道","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("气道支气管","气道支气管","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("气道支气管树","气道支气管树","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("乳突冠位","乳突冠位","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("乳突轴位","乳突轴位","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("乳腺","乳腺","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上腔静脉","上腔静脉","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("小儿心脏","小儿心脏","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("心脏","心脏","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸10-腰3（胸腰段）","胸10-腰3（胸腰段）","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部","胸部","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸11-腰1","胸11-腰1","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸部MR","胸部MR","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸骨","胸骨","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸锁","胸锁","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸腰段","胸腰段","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸主动脉","胸主动脉","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸主动脉血管","胸主动脉血管","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸椎","胸椎","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸椎T10-T12","胸椎T10-T12","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸椎T1-T3","胸椎T1-T3","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸椎T4-T6","胸椎T4-T6","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸椎T7-T9","胸椎T7-T9","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胸1-骶尾椎1","胸1-骶尾椎1","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("支气管动脉","支气管动脉","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("主动脉","主动脉","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左房肺静脉双期血栓","左房肺静脉双期血栓","胸部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊髓血管","脊髓血管","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊髓血管成像","脊髓血管成像","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊柱侧弯（成人）","脊柱侧弯（成人）","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊柱侧弯（儿童14岁以下）","脊柱侧弯（儿童14岁以下）","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊柱侧弯（儿童14岁以下)","脊柱侧弯（儿童14岁以下)","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全脊柱（颈胸腰椎）","全脊柱（颈胸腰椎）","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全颈椎（C1-C7 ）","全颈椎（C1-C7 ）","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全胸椎（T1-T12）","全胸椎（T1-T12）","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全腰椎（L1-S1 ）","全腰椎（L1-S1 ）","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胎儿脊柱","胎儿脊柱","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腰骶段","腰骶段","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腰骶椎","腰骶椎","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腰椎","腰椎","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腰椎1-骶1","腰椎1-骶1","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腰椎3-骶1","腰椎3-骶1","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腰椎L1-L3","腰椎L1-L3","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脊髓","脊髓","脊柱","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肠系膜动脉","肠系膜动脉","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("耻骨","耻骨","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("骶髂关","骶髂关","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("骶髂关节","骶髂关节","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("骶尾椎","骶尾椎","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("结肠","结肠","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腹主动脉","腹主动脉","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腹主动脉血管","腹主动脉血管","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肝胆胰脾","肝胆胰脾","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肝灌注","肝灌注","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("股骨","股骨","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("骨盆","骨盆","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("结肠","结肠","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("髋关节","髋关节","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("泌尿系","泌尿系","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("膀胱","膀胱","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("盆腔","盆腔","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("盆腔（前列腺膀胱）","盆腔（前列腺膀胱）","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("盆腔（子宫附件）","盆腔（子宫附件）","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("前列腺","前列腺","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("全腹部","全腹部","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上腹部","上腹部","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肾动脉","肾动脉","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肾静脉","肾静脉","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肾上腺","肾上腺","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肾脏","肾脏","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("生殖器","生殖器","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("臂丛","臂丛","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("臂丛神经","臂丛神经","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("尺桡骨","尺桡骨","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肱骨","肱骨","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肱骨（上臂）","肱骨（上臂）","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肩关节","肩关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肩胛骨","肩胛骨","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上肢动脉","上肢动脉","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("上肢静脉","上肢静脉","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("手","手","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("手（掌指骨）","手（掌指骨）","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("手部动脉血管","手部动脉血管","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("手部静脉血管","手部静脉血管","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("手痛风石","手痛风石","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧肩关节","右侧肩关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧前臂","右侧前臂","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧上臂","右侧上臂","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧腕关节","右侧腕关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧掌指骨","右侧掌指骨","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧肘关节","右侧肘关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右上肢血管","右上肢血管","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右手","右手","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右腕关节","右腕关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧肩关节","左侧肩关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("踝关节","踝关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("踝痛风石","踝痛风石","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("脚痛风石","脚痛风石","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胫腓骨","胫腓骨","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("膝关节","膝关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("膝痛风石","膝痛风石","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下肢动脉","下肢动脉","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下肢静脉","下肢静脉","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下肢血管","下肢血管","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧大腿","右侧大腿","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧踝关节","右侧踝关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧膝关节","右侧膝关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右侧小腿","右侧小腿","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("右足","右足","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肘关节","肘关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("足","足","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("足部动脉血管","足部动脉血管","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("足部静脉血管","足部静脉血管","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧大腿","左侧大腿","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧踝关节","左侧踝关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧膝关节","左侧膝关节","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧小腿","左侧小腿","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左足","左足","下肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("双侧骶髂关节","双侧骶髂关节","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("双髋关节","双髋关节","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("腕关节","腕关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下腹部","下腹部","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("胰腺","胰腺","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("阴囊及睾丸","阴囊及睾丸","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("子宫附件","子宫附件","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧前臂","左侧前臂","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧上臂","左侧上臂","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧腕关节","左侧腕关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧掌指骨","左侧掌指骨","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左侧肘关节","左侧肘关节","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左上肢血管","左上肢血管","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("左手","左手","上肢","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肝脏","肝脏","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("肝静脉","肝静脉","腹部","1"),ind=ind+1
	s ^CacheTemp(repid,ind)=$lb("下腔静脉","下腔静脉","腹部","1"),ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindPartTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPartTempExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPartTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPartTempExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEMImpTools","FindAPPTree","2")
Query FindAPPTree(HospID As %String) As %SQLQuery(ROWSPEC = "HospID:%String:医院, type:%String:类型, Code:%String:代码,Code1:%String:一级分类, Code2:%String:二级分类, Code3:%String:三级分类, Code4:%String:四级分类")
{
}

ClassMethod FindAPPTreeExecute(ByRef qHandle As %Binary, HospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s ID=0
  	f  {
	  	s ID=$o(^DHCAPPTRA(0,"LastRowid",0,ID)) 
	  	q:ID=""
	  	s Code=$p(^DHCAPPTRA(ID),"^",1)
	  	s Text=$p(^DHCAPPTRA(ID),"^",2)
	  	Continue:$p(^DHCAPPTRA(ID),"^",5)'=HospID
	  	s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
	  	i OrdNum=0 s OrdNum=Code
	  	s TmpArr(OrdNum,ID)=ID_"^"_Text_"^"_Code
  	}
  	s HospDesc=$P(^CT("HOSP",2),"^",2)
  	s index=""
  	s FNumber=1
  	for {
	  	s index=$o(TmpArr(index))
	  	Q:index="" 
	  	s IDindex=""
	  	for {
		  	s IDindex=$o(TmpArr(index,IDindex))
		  	Q:IDindex=""
		  	s ID=+$g(TmpArr(index,IDindex))
		  	s Text1=$p(^DHCAPPTRA(ID),"^",2)
		  	s Type=$p(^DHCAPPTRA(ID),"^",10)
		  	s Type=$case(Type,"E":"检查","L":"检验","P":"病理",:0)
		  	s ^CacheTemp(repid,ind)=$lb(HospDesc,Type,FNumber,Text1,"","","")
		  	s ind=ind+1
		  	s Sid=$o(^DHCAPPTRA(0,"LastRowid",ID,""))
		  	if (Sid'=""){
			  	s SNumber=1
			  	s SID=0
			  	f  {
				  	s SID=$o(^DHCAPPTRA(0,"LastRowid",ID,SID)) 
				  	q:SID=""
				  	s Text2=$p(^DHCAPPTRA(SID),"^",2)
				  	s ^CacheTemp(repid,ind)=$lb(HospDesc,Type,FNumber_"."_SNumber,Text1,Text2,"","")
		  			s ind=ind+1
				  	s Tid=$o(^DHCAPPTRA(0,"LastRowid",SID,""))
				  	if (Tid'=""){
					  	s TNumber=1
			  			s TID=0
			  			f  {
						  	s TID=$o(^DHCAPPTRA(0,"LastRowid",SID,TID)) 
						  	q:TID=""
						  	s Text3=$p(^DHCAPPTRA(TID),"^",2)
						  	s ^CacheTemp(repid,ind)=$lb(HospDesc,Type,FNumber_"."_SNumber_"."_TNumber,Text1,Text2,Text3,"")
				  			s ind=ind+1
						  	s Fid=$o(^DHCAPPTRA(0,"LastRowid",TID,""))
						  	if (Fid'=""){
							  	s FNumber=1
							  	s FID=0
							  	f  {
								  	s FID=$o(^DHCAPPTRA(0,"LastRowid",TID,FID)) 
								  	q:FID=""
								  	s Text4=$p(^DHCAPPTRA(FID),"^",2)
								  	s ^CacheTemp(repid,ind)=$lb(HospDesc,Type,FNumber_"."_SNumber_"."_TNumber_"."_FNumber,Text1,Text2,Text3,Text4)
						  			s ind=ind+1
						  			s FNumber=FNumber+1
							  	}
							  	}
			  			}
			  			s TNumber=TNumber+1
					  }
					s SNumber=SNumber+1
			  	}
		  	}
		  	s FNumber=FNumber+1
	  	}
  	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindAPPTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAPPTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAPPTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAPPTreeTempExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
