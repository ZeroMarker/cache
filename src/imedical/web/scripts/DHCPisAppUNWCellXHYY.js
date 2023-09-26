//DHCPisAppUNWCellZLYY.js

var bNewPatient = 1
var tstatuscode=0
var specimen=false
var tspecimeninfo=""
var ttmrowid=""
var paadmdr=""
var orditemdr=""
var tclsdr=""
var tclscode="20"
var tclinicrecord=""
var printshape=""
var autoNumber=1
var resultgroup=""
var boolvalue=false
var bitian=false
//新加变量boolvalue是为了判断末次月经日期和肿瘤发现日期是否是在当前日期
//之后用的,实现该功能的函数为BJDate()
var recLocDr=""
var recLocDesc=""
var duihao=String.fromCharCode(8730)
var code1=String.fromCharCode(12300)   //"「"
var code2=String.fromCharCode(12301)   //"」"
var code3=String.fromCharCode(65089)   //"??
var code4=String.fromCharCode(65090)   //"??

//屏蔽放大镜
var tformName=document.getElementById("TFORM").value; 
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; 
var componentId; 
componentId=cspRunServerMethod(getComponentIdByName,tformName); 


function BodyLoadHandler()
 {	
    orditemdr=document.getElementById("OEorditemID").value
    paadmdr=document.getElementById("EpisodeID").value
        
    if(orditemdr=="" || paadmdr=="")
    {
	    return
    }
	
   	document.getElementById("ComponentName").value=tformName
   	
   	var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)

    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			recLocDr=item[17]
			recLocDesc=item[20].split("-")[1]
			
			document.getElementById("RecLocDr").value=recLocDr
			//alert(recLocDr+"="+recLocDesc)
   	}
		DisableChuanCiBuWei()
   	document.getElementById("TLCell").style.display ="none";
   	document.getElementById("TLCellNum").style.display ="none";
   	//document.getElementById("HuiZhenBiaoBen").style.display ="none";
   	document.getElementById("ZXCellNum").style.display ="none";

   	
   	//var AppDateObj=document.getElementById("AppDate")
   	
    //if (AppDateObj.value=="")
    //	AppDateObj.value=DateDemo()
    	
     //20081205 dln
     //通过判断关联的文本框是否为空来设定该复选框是否被选中
    
    if(isNull("OtherInfo")==false)
    {	
    	var other=document.getElementById("OtherInfo").value
		document.getElementById("bOther").checked=true
		document.getElementById("bLiuCell").checked=false		
	}else
	{
		document.getElementById("bOther").checked=false
		document.getElementById("OtherInfo").disabled=true
		document.getElementById("bLiuCell").checked=true	
	}

	if(isNull("TransPos")==false)
	{
		document.getElementById("Transfer").checked=true		
	}else
	{
		document.getElementById("Transfer").checked=false
	}
//-----------------all button action!Begin------------------
//标本来源中的 添加?删除?修改 按钮 的事件 添加 2008-9-17 DLN   
    var SpeAddobj=document.getElementById("SpecimenAdd")
   	if (SpeAddobj)
   	{   
		SpeAddobj.onclick=SpeAddkey
   	}
   
   	var SpeEditobj=document.getElementById("SpecimenEdit")
   	if (SpeEditobj)
   	{
		SpeEditobj.onclick=SpeEditkey
   	}
   
   	var SpeDelobj=document.getElementById("SpecimenDel")
   	if (SpeDelobj)
   	{
		SpeDelobj.onclick=SpeDelkey
   	}
    
    var PirntTMKeyObj=document.getElementById("PirntTM")
   	if (PirntTMKeyObj)
   	{
		PirntTMKeyObj.onclick=PirntTMKey
   	}
    	    
   	var SendAppobj=document.getElementById("SendApp")
  	 if (SendAppobj)
   	{
		SendAppobj.onclick=SendAppkey
   	}
    
    var SaveAppobj=document.getElementById("SaveApp")
  	 if (SaveAppobj)
   	{
		SaveAppobj.onclick=SaveAppkey
   	}
   	
   	var CancelAppobj=document.getElementById("CancelApp")
   	if (CancelAppobj)
   	{
		CancelAppobj.onclick=CancelAppkey
   	}
   	
   	var PrintObj=document.getElementById("PrintApp")
   	if (PrintObj)
   	{
		PrintObj.onclick=PrintAppkey
   	}
   	
   	var LiuObj=document.getElementById("bLiuCell")
   	if (LiuObj)
   	{
		LiuObj.onclick=LiuKey
   	}
   	
   	var OtherObj=document.getElementById("bOther")
   	if (OtherObj)
   	{
		OtherObj.onclick=OtherKey
   	}
	
   	var TumourDateObj=document.getElementById("TumourDate")
   	if (TumourDateObj)
   	{
		TumourDateObj.onblur=TumourDateblur
   	}
   	
   	var TransferObj=document.getElementById("Transfer")
   	if(TransferObj)
   	{
			TransferObj.onclick=TransferKey 	
		}
   	
   	var ZhiQiGuanJingShuaPian=document.getElementById("ZhiQiGuanJingShuaPian")
   	if(ZhiQiGuanJingShuaPian)
   	{
   		ZhiQiGuanJingShuaPian.onclick=ZhiQiGuanJingShuaPianKey
   	}
   	var Tan=document.getElementById("Tan")
   	if(Tan)
   	{
   		Tan.onclick=TanKey
   	}
   	var XiongShui=document.getElementById("XiongShui")
   	if(XiongShui)
   	{
   		XiongShui.onclick=XiongShuiKey
   	}
   	var FuShui=document.getElementById("FuShui")
   	if(FuShui)
   	{
   		FuShui.onclick=FuShuiKey
   	}
   	var XinBaoJiYe=document.getElementById("XinBaoJiYe")
   	if(XinBaoJiYe)
   	{
   		XinBaoJiYe.onclick=XinBaoJiYeKey
   	}
   	var NaoJiYe=document.getElementById("NaoJiYe")
   	if(NaoJiYe)
   	{
   		NaoJiYe.onclick=NaoJiYeKey
   	}
   	var Niao=document.getElementById("Niao")
   	if(Niao)
   	{
   		Niao.onclick=NiaoKey
   	}
   	var YinLiuNiao=document.getElementById("YinLiuNiao")
   	if(YinLiuNiao)
   	{
   		YinLiuNiao.onclick=YinLiuNiaoKey
   	}
   	var ZhiQiGuanJingGuanXiYe=document.getElementById("ZhiQiGuanJingGuanXiYe")
   	if(ZhiQiGuanJingGuanXiYe)
   	{
   		ZhiQiGuanJingGuanXiYe.onclick=ZhiQiGuanJingGuanXiYeKey
   	}
   	var ShiGuanJingShuaPian=document.getElementById("ShiGuanJingShuaPian")
   	if(ShiGuanJingShuaPian)
   	{
   		ShiGuanJingShuaPian.onclick=ShiGuanJingShuaPianKey
   	}
   	var JieChangJingShuaPian=document.getElementById("JieChangJingShuaPian")
   	if(JieChangJingShuaPian)
   	{
   		JieChangJingShuaPian.onclick=JieChangJingShuaPianKey
   	}
   	var PenQiangChongXiYe=document.getElementById("PenQiangChongXiYe")
   	if(PenQiangChongXiYe)
   	{
   		PenQiangChongXiYe.onclick=PenQiangChongXiYeKey
   	}
   	var FuQiangChongXiYe=document.getElementById("FuQiangChongXiYe")
   	if(FuQiangChongXiYe)
   	{
   		FuQiangChongXiYe.onclick=FuQiangChongXiYeKey
   	}
   	var FuPenQiangChongXiYe=document.getElementById("FuPenQiangChongXiYe")
   	if(FuPenQiangChongXiYe)
   	{
   		FuPenQiangChongXiYe.onclick=FuPenQiangChongXiYeKey
   	}
    /*
   	var MianYiXiBaoHuaXue=document.getElementById("MianYiXiBaoHuaXue")
   	if(MianYiXiBaoHuaXue)
   	{
   		MianYiXiBaoHuaXue.onclick=MianYiXiBaoHuaXueKey
   	}
    */
   	var OtherTLCell=document.getElementById("OtherTLCell")           
   	if(OtherTLCell)
   	{
   		OtherTLCell.onclick=OtherTLCellKey
   	}
   	var TBNA=document.getElementById("TBNA")
   	if(TBNA)
   	{
   		TBNA.onclick=TBNAKey
   	}
   	var EBUS=document.getElementById("EBUS")
   	if(EBUS)
   	{
   		EBUS.onclick=EBUSKey
   	}
   	var CTChuanCi=document.getElementById("CTChuanCi")
   	if(CTChuanCi)
   	{
   		CTChuanCi.onclick=CTChuanCiKey
   	}
   	var ChaoShengChuanCi=document.getElementById("ChaoShengChuanCi")
   	if(ChaoShengChuanCi)
   	{
   		ChaoShengChuanCi.onclick=ChaoShengChuanCiKey
   	}
   	var ChuanCiWu=document.getElementById("ChuanCiWu")
   	if(ChuanCiWu)
   	{
   		ChuanCiWu.onclick=ChuanCiWuKey
   	}
    /*
   	var HuiZhen=document.getElementById("HuiZhen")
   	if(HuiZhen)
   	{
   		HuiZhen.onclick=HuiZhenKey
   	}
    */
   	var OtherZXCell=document.getElementById("OtherZXCell")
   	if(OtherZXCell)
   	{
   		OtherZXCell.onclick=OtherZXCellKey
   	}
   	var RuYi=document.getElementById("RuYi")
   	if(RuYi)
   	{
   		RuYi.onclick=RuYiKey
   	}
   	var ZXCellNum=document.getElementById("ZXCellNum")
   	if(ZXCellNum)
   	{
   		ZXCellNum.onblur=ZXCellNumKey
   	}
   	var TLCellNum=document.getElementById("TLCellNum")
   	if(TLCellNum)
   	{
   		TLCellNum.onblur=TLCellNumKey
   	}
   //-----------------all button action!End------------------
   	var GetClsdrFun=document.getElementById("ClassDr").value
 	var CLSDR=cspRunServerMethod(GetClsdrFun,tclscode)
    if (CLSDR!="")
	{	  
	  	tclsdr = CLSDR
    }
    
 	//get tmrowid
    var GetTmrowidFun=document.getElementById("GetTmRowId").value
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,recLocDr,orditemdr)
    if (TMROWID!="")
	{   
		ttmrowid = TMROWID
		document.getElementById("TMrowid").value = TMROWID
		//alert(ttmrowid)
		var GetStatusFun=document.getElementById("GetAppStatus").value
		var VS = cspRunServerMethod(GetStatusFun,ttmrowid)
		if(VS!="")
		{
			var item=VS.split("~")
			var GetRSCodeFun=document.getElementById("RsCode").value
			var curcode=cspRunServerMethod(GetRSCodeFun,item[0])
			if(curcode=="1")
			{
				tstatuscode=1
				bNewPatient=0
			}
			else
			{
				tstatuscode=2
				bNewPatient=0
			}
		}
		else
		{
			tstatuscode=0
			bNewPatient=1
		}
	}
	else
	{
		tstatuscode=0
		bNewPatient=1
		
		var TestmasterAddFun=document.getElementById("AddTmInfo").value
		var TMROWID = cspRunServerMethod(TestmasterAddFun,recLocDr,tclsdr)
		if(TMROWID!="" && TMROWID!="-901")
		{
			ttmrowid = TMROWID
			document.getElementById("TMRowid").value = TMROWID
		}
		
		var appinfo="^^^^^^^^^^^^"+orditemdr
		var SetAppFun=document.getElementById("AddAppInfo").value
		var RECODE=cspRunServerMethod(SetAppFun,appinfo,ttmrowid)
		if(RECODE!="0")
		{
			alert(t['UpdateAppFailure'])
			return
		}
	}
	//alert(ttmrowid)
	var freshFlag=document.getElementById("Refresh").value

   	if (freshFlag=="")
   	{
	   freshFlag=1
	   document.getElementById("Refresh").value=freshFlag
       Refresh()
   	}
    
	if(tstatuscode==1) //已发送
	{   
		document.getElementById("SendApp").disabled=true
		document.getElementById("SaveApp").disabled=true
		
		//document.getElementById("SendApp").style.visibility="hidden"
		//document.getElementById("SaveApp").style.visibility="hidden"

	    /*
	    if (isNull("TumourDate")==true)
	    {
	    document.all("TumourDate").style.display = "none"
	    }
       */
	}
	else if(tstatuscode==2) //已登记
	{
		document.getElementById("SendApp").disabled=true
        document.getElementById("SaveApp").disabled=true
		document.getElementById("CancelApp").disabled=true
		//document.getElementById("SendApp").style.visibility="hidden"
		//document.getElementById("CancelApp").style.visibility="hidden"
		//document.getElementById("SaveApp").style.visibility="hidden"

	}
	else //未申请
	{
		document.getElementById("CancelApp").disabled=true
		document.getElementById("PrintApp").disabled=true
		//document.getElementById("CancelApp").style.visibility="hidden"
		//document.getElementById("PrintApp").style.visibility="hidden"
	}

	GetPatInfo()
	AutoNumber()
	GetAppInfo()
	GetWomanTumourInfo()
	GetAllSpecimenInfo()
	
	//document.getElementById("SpecimenDel").disabled=true
	//document.getElementById("SpecimenEdit").disabled=true
	/*
	var specount=document.getElementById("SpeCount").value
	if(specount=="2")
	 {
	 	  document.getElementById("SpeMemo1").style.display ="";
	 }
	 if(specount=="3")
	 {
	 	  document.getElementById("SpeMemo1").style.display ="";
	 	  document.getElementById("SpeMemo2").style.display ="";
	 }
	 if(specount=="4")
	 {
	 	  document.getElementById("SpeMemo1").style.display ="";
	 	  document.getElementById("SpeMemo2").style.display ="";
	 	  document.getElementById("SpeMemo3").style.display ="";
	 }
	 */
 }
 //取得肿瘤信息
 function GetWomanTumourInfo()
 {
	  var GetTumourInfo=document.getElementById("TumourInfo")
      if (GetTumourInfo)
      {
         var returnTumInfoVal
         var enmeth=GetTumourInfo.value
         var returnTumInfoVal=cspRunServerMethod(enmeth,ttmrowid)
    
         if (returnTumInfoVal!="")
	     {  
	 	    var item=returnTumInfoVal.split("^")
		    document.getElementById("TumourPosition").value=item[1]
		    document.getElementById("TumourSize").value=item[2]
	
		    if (item[0]!="")
		    { 
			    var ChangDFun=document.getElementById("DateChange3to4").value
			    item[0]=cspRunServerMethod(ChangDFun,item[0])
		    }
		    document.getElementById("TumourDate").value=item[0]
		    
		    if (item[5]=="Y") var RadioCure=1
		    else var RadioCure=0
		    document.getElementById("RadioCure").checked=RadioCure
		    if (item[6]=="Y") var ChemicalCure=1
		    else var ChemicalCure=0
		    document.getElementById("ChemicalCure").checked=ChemicalCure
		    if (item[3]=="Y") var Transfer=1
		    else var Transfer=0
		    document.getElementById("Transfer").checked=Transfer
		    document.getElementById("TransPos").value=item[4]
		    document.getElementById("memo").value=item[7]
	     }
      }
	  if(bNewPatient==1)
      {
	     document.getElementById("TMrowid").disabled=true
		 document.getElementById("TumourPosition").disabled=false
		 document.getElementById("TumourSize").disabled=false
	 	 document.getElementById("TumourDate").disabled=false
		 document.getElementById("RadioCure").disabled=false
		 document.getElementById("ChemicalCure").disabled=false
		 document.getElementById("TumourSize").disabled=false
	 	 document.getElementById("Transfer").disabled=false
		 document.getElementById("TransPos").disabled=false
		 document.getElementById("memo").disabled=false 

		 if(isNull("TransPos")==true)
		 	document.all("TransPos").style.display = "none"
      }
      else
      {
	     document.getElementById("TMrowid").disabled=true
		 document.getElementById("TumourPosition").disabled=true
		 document.getElementById("TumourSize").disabled=true
	 	 document.getElementById("TumourDate").disabled=true
		 document.getElementById("RadioCure").disabled=true
		 document.getElementById("ChemicalCure").disabled=true
		 document.getElementById("TumourSize").disabled=true
	 	 document.getElementById("Transfer").disabled=true
		 document.getElementById("TransPos").disabled=true
		 document.getElementById("memo").disabled=true	

      }      
 }
//通过匹配申请单关联的标本名称?返回一个标示号?以便确认打印哪张申请单
function GetAllSpecimenInfo()
{ 
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var item1=info.split(");")
	autoNumber=item1.length-1
	var spenames=""
	var spename=""
	var spenamenn=""
  var spenamemm=""
  
	for(var i=0;i<autoNumber;i++)
	{
    var k=i+1
		var item2=item1[i].split(":")
		//alert(item2)
		spenamenn=item2[1].split("(")[0]
    spename=spenamenn.split(duihao)[0]
    spenamemm=spenamenn.split(duihao)[1]
     //document.getElementById("ChuanCiBuWei"+k).value=spenamemm
		var spenaNum=item2[1].split("(")[1]
    if(spenames!="")
    {
    spenames+=code2+spenamemm
    }			
		else
    {
    	spenames=spenamemm
    }
		
    //spenames+=code2+spenamemm
      /*
		if(spenames!="")
			spenames+=code2+spenaNum
		else
			spenames=spenaNum
      */
	}
   			
	if(spename==t['Tan'])
	{
		document.getElementById("Tan").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['XiongShui'])
	{
		document.getElementById("XiongShui").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['FuShui'])
	{
		document.getElementById("FuShui").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['XinBaoJiYe'])
	{
		document.getElementById("XinBaoJiYe").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['NaoJiYe'])
	{
		document.getElementById("NaoJiYe").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['Niao'])
	{
		document.getElementById("Niao").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['YinLiuNiao'])
	{
		document.getElementById("YinLiuNiao").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['ZhiQiGuanJingGuanXiYe'])
	{
		document.getElementById("ZhiQiGuanJingGuanXiYe").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['ZhiQiGuanJingShuaPian'])
	{
		document.getElementById("ZhiQiGuanJingShuaPian").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['ShiGuanJingShuaPian'])
	{
		document.getElementById("ShiGuanJingShuaPian").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['JieChangJingShuaPian'])
	{
		document.getElementById("JieChangJingShuaPian").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['FuQiangChongXiYe'])
	{
		document.getElementById("FuQiangChongXiYe").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['PenQiangChongXiYe'])
	{
		document.getElementById("PenQiangChongXiYe").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['FuPenQiangChongXiYe'])
	{
		document.getElementById("FuPenQiangChongXiYe").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
	if(spename==t['OtherTLCell'])
	{
   var infoqt=info.split("(")
   var infoqttl=infoqt[1].split("~")
   var infoqttlbb=infoqttl[0]

		document.getElementById("OtherTLCell").checked=true
		document.getElementById("TLCell").value=spenames
    document.getElementById("TLCellNum").value=infoqttlbb
    //document.getElementById("TLCell").value=infoqttlbb		
	}
  /*
	if(spename==t['MianYiXiBaoHuaXue'])
	{
		document.getElementById("MianYiXiBaoHuaXue").checked=true
		document.getElementById("TLCellNum").value=autoNumber
	}
  
	if(spename==t['HuiZhen'])
	{
		document.getElementById("HuiZhen").checked=true
		document.getElementById("HuiZhenBiaoBen").value=spenames
	}
	*/
	if(spename==t['ChuanCiWu'])
	{          
		document.getElementById("ChuanCiWu").checked=true
		document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{     
			var specimenName=spenames.split(code2)[j]
      //var specimenName=spenamemm.split(code2)[j]
			var k=j+1
			document.getElementById("ChuanCiBuWei"+k).value=specimenName     //specimenName
      //alert(document.getElementById("ChuanCiBuWei"+k).value)
			document.getElementById("ChuanCiBuWei"+k).style.display=""
			document.getElementById("ChuanCiBuWei"+k).disabled=true;   
		}
	}
 if(spename==t['RuYi'])
	{
		document.getElementById("RuYi").checked=true
		//document.getElementById("TLCellNum").value=autoNumber
    document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{
			var specimenName=spenames.split(code2)[j]
			var k=j+1
			//document.getElementById("TLCell"+k).value=specimenName
			//document.getElementById("TLCell"+k).style.display=""
      document.getElementById("ChuanCiBuWei"+k).value=specimenName
			document.getElementById("ChuanCiBuWei"+k).style.display=""
		}
	}
	
	if(spename==t['TBNA'])
	{
		document.getElementById("TBNA").checked=true
		document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{
			var specimenName=spenames.split(code2)[j]
			var k=j+1
			document.getElementById("ChuanCiBuWei"+k).value=specimenName
			document.getElementById("ChuanCiBuWei"+k).style.display=""
			//document.getElementById("ChuanCiBuWei"+k).disabled=true;
		}
	}
	
	if(spename==t['EBUS'])
	{
		document.getElementById("EBUS").checked=true
		document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{
			var specimenName=spenames.split(code2)[j]
			var k=j+1
			document.getElementById("ChuanCiBuWei"+k).value=specimenName
			document.getElementById("ChuanCiBuWei"+k).style.display=""
			//document.getElementById("ChuanCiBuWei"+k).disabled=true;
		}
	}
	
	if(spename==t['ChaoShengChuanCi'])
	{
		document.getElementById("ChaoShengChuanCi").checked=true
		document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{
			var specimenName=spenames.split(code2)[j]
			var k=j+1
			document.getElementById("ChuanCiBuWei"+k).value=specimenName
			document.getElementById("ChuanCiBuWei"+k).style.display=""
			//document.getElementById("ChuanCiBuWei"+k).disabled=true;
		}
	}
	
	if(spename==t['CTChuanCi'])
	{
		document.getElementById("CTChuanCi").checked=true
		document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{
			var specimenName=spenames.split(code2)[j]
			var k=j+1
			document.getElementById("ChuanCiBuWei"+k).value=       //specimenName
			document.getElementById("ChuanCiBuWei"+k).style.display=""
			//document.getElementById("ChuanCiBuWei"+k).disabled=true;
		}
	}
	
	if(spename==t['OtherZXCell'])
	{
		document.getElementById("OtherZXCell").checked=true
		document.getElementById("ZXCellNum").value=autoNumber
		for(var j=0;j<autoNumber;j++)
		{
			var specimenName=spenames.split(code2)[j]
			var k=j+1
			document.getElementById("ChuanCiBuWei"+k).value=specimenName
			document.getElementById("ChuanCiBuWei"+k).style.display=""
			//document.getElementById("ChuanCiBuWei"+k).disabled=true;
		}
	}
	
	if(bNewPatient!=1)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).disabled=true
			    }               
			}
		}
		document.getElementById("TLCell").style.display=""
		document.getElementById("TLCellNum").style.display=""
		document.getElementById("ZXCellNum").style.display=""
		//document.getElementById("HuiZhenBiaoBen").style.display=""	
		document.getElementById("TLCell").disabled=true
		document.getElementById("TLCellNum").disabled=true
		document.getElementById("ZXCellNum").disabled=true
		//document.getElementById("HuiZhenBiaoBen").disabled=true
	}
}
 //取得病人信息
 function GetPatInfo()
 {
	if(bNewPatient==1)
	{
		var GetPaadmInfoFun=document.getElementById("PatInfo").value
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^");
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight, 21
			//address,SEXDR,feetypedr 24
    		document.getElementById("RegNo").value=item[0]
			document.getElementById("PName").value=item[1]
			
			//2008-5-1-----1/5/2008 ??    
			var vdate3=item[2]
      var vdate4=""
      if(vdate3!="")
			{
				var ChangDFun=document.getElementById("DateChange3to4").value
				vdate4=cspRunServerMethod(ChangDFun,vdate3)
			}
			document.getElementById("PBirthday").value=vdate4
			document.getElementById("PAge").value=item[3]
		
			//sex dr??
			document.getElementById("PSex").value=item[4]
			document.getElementById("SexDr").value=item[22]
			
			document.getElementById("PTel").value=item[18]
			document.getElementById("PAddress").value=item[21]
			
			document.getElementById("PType").value=item[6]
			document.getElementById("AdmtypeDR").value=item[5]
		
			document.getElementById("PChargeType").value=item[15]
			document.getElementById("CharegetypeDR").value=item[23]

			document.getElementById("InpoNo").value=item[8]
      var item9=""
      if(item[9])
        item9=item[9].split("-")[1]
			document.getElementById("RoomNo").value=item9
			document.getElementById("BedNo").value=item[10]
			var item7=item[7].split("-")
			document.getElementById("AppDep").value=item7[1]
        	document.getElementById("AppLocDR").value=item[11]
        	
        	document.getElementById("RoomBedNo").value=item[10]
		}
	}
	else
	{
		var GetPatInfoFun=document.getElementById("GetPatInfo").value
  		var PATINFO=cspRunServerMethod(GetPatInfoFun,ttmrowid)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^")
			//paadmDr,name,nameP,sexDr,birthDate,admType,chargeType 7
			//,address,tel,IPNo,AdmNo,room,bedNo 13
    		document.getElementById("RegNo").value=item[9]
			document.getElementById("PName").value=item[1]
			
			var vdate3=item[4]
			var ChangDFun=document.getElementById("DateChange3to4").value
			var vdate4=cspRunServerMethod(ChangDFun,vdate3)
			document.getElementById("PBirthday").value=vdate4
			//document.getElementById("Age").value=""
			
			var titem1=item[3].split("~")
			document.getElementById("PSex").value=titem1[1]
			document.getElementById("SexDr").value=titem1[0]
			
			document.getElementById("PTel").value=item[8]
			document.getElementById("PAddress").value=item[7]
			
			var titem2=item[5].split("~")
			document.getElementById("PType").value=titem2[1]
			document.getElementById("AdmtypeDR").value=titem2[0]
		
			var titem3=item[6].split("~")
			document.getElementById("PChargeType").value=titem3[1]
			document.getElementById("CharegetypeDR").value=titem3[0]

			document.getElementById("RoomNo").value=item[11]
			document.getElementById("BedNo").value=item[12]
			document.getElementById("InpoNo").value=item[10]
			
        	document.getElementById("RoomBedNo").value=item[11]+" "+item[12];
		}
		
		var GetPaadmInfoFun=document.getElementById("PatInfo").value
  		var PATINFO=cspRunServerMethod(GetPaadmInfoFun,paadmdr)
    	if (PATINFO!="")
		{   
			var item=PATINFO.split("^")
			//RegNo,Name,strDOB,strAge,$g(SexDesc),patienttype,typedesc 7
			//$g(LocName),IPNO,wardname,bedname,$g(Locdr),SexDr,WardDr, 14
			//roomdesc,feetype,Docdr,DocName,Telphone,Height,Weight,address 22
			document.getElementById("PAge").value=item[3]
		}
	}
 }
 //取得申请信息
 function GetAppInfo()
 {
	 if(bNewPatient==1)
	{  
		// get patient main diagonse 
		var GetMainDiagoseFunction=document.getElementById("MainDiagInfo").value
  		var value=cspRunServerMethod(GetMainDiagoseFunction,paadmdr)
    	document.getElementById("ClinicDiag").value=value

			/*
    	var GetCSTATUSFunction=document.getElementById("GetCurrentStatusAll").value
  		var value1=cspRunServerMethod(GetCSTATUSFunction,paadmdr)
   var ClinicRec=document.getElementById("ClinicRec1").value

  		//////////////////////
  		if (ClinicRec=="")
    	   document.getElementById("ClinicRec1").value=value1
///////////////////////////添加标本来源后临床诊断及体征信息YCX
    	  */
    	/*
    	// get patient default current status 
    	var GetCurrentStatusFunction=document.getElementById("GetCurrentStatusFunction").value;
  		var value=cspRunServerMethod(GetCurrentStatusFunction,paadmdr)
    	document.getElementById("ClinicRecord").value=value
		*/

		var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)

    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc,resultgroup 22
			document.getElementById("GetOEorditemName").value=item[1]
			document.getElementById("AppDate").value=item[2]
			document.getElementById("AppDoc").value=item[4]
			document.getElementById("AppDocDR").value=item[5]
			resultgroup=item[21]
			document.getElementById("Price").value=item[13]
			//alert(item[21])
 			//document.getElementById("SpePos").value=item[21]
		}
		
		//dln 20081205 为了返回送检目的勾选情况?下面4条语句的作用放到了前面的注释//20081205 dln下面的语句中了
		//document.getElementById("bLiuCell").checked=true
		//document.getElementById("bOther").checked=false
		//document.getElementById("OtherInfo").disabled=true
		//document.getElementById("OtherInfo").value=""
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  	var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    if (APPINFO!="")
		{   
			var item=APPINFO.split("^")
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13
			//var item7=item[7].split("-")
			if(item[5]!="")
			document.getElementById("ClinicDiag").value=item[5]
			if(item[2]!="")
			document.getElementById("QiangJingXiaSuoJian").value=item[2]
			if(item[1]!="")
			{
				tclinicrecord=item[1]
			if(item[1]!="")
				SetClinicRecord()
			}
			
		}
	}
	else
	{
		var GetAppInfoFun=document.getElementById("GetAppInfo").value
  		var APPINFO=cspRunServerMethod(GetAppInfoFun,ttmrowid)
    	if (APPINFO!="")
		{   
			var item=APPINFO.split("^")
			//frost,clinicRecord,operResult,tumourInfo,womenInfo,relClinic, 6
			//appDeptDr,appDept,appDate,appTime,appDocDr,appDoc,orderDr 13
			//var item7=item[7].split("-")
    		document.getElementById("AppDep").value=item[7]
        	document.getElementById("AppLocDR").value=item[6]
		
			document.getElementById("AppDoc").value=item[11]
			document.getElementById("AppDocDR").value=item[10]
			
			var vdate3=item[8]
			var vdate4=""
			if(vdate3!="")
			{
				var ChangDFun=document.getElementById("DateChange3to4").value
				vdate4=cspRunServerMethod(ChangDFun,vdate3)
			}
			
			document.getElementById("AppDate").value=vdate4
			
			document.getElementById("ClinicDiag").value=item[5]
			document.getElementById("QiangJingXiaSuoJian").value=item[2]
			tclinicrecord=item[1]
			if(item[1]!="")
				SetClinicRecord()
		}
		var GetOrdInfoFun=document.getElementById("OrderInfo").value
  		var ORDERINFO=cspRunServerMethod(GetOrdInfoFun,orditemdr)
    	if (ORDERINFO!="")
		{   
			var item=ORDERINFO.split("^")
			//arcimid,strOrderName,strDate,strTime,requestdoc,ssusrdr, 6
			//strAccessionNum,SGroupDesc,subCatDesc,CatDesc,ifbed,price 12
			//Num,TotalPrice,billed,$g(ItemStatusCode),$g(ServerMaterial) 17
			//RecLocdr,$g(ResultFlag),strCommon,RecLocDesc,resultgroup 22ss
			document.getElementById("GetOEorditemName").value=item[1]
			document.getElementById("Price").value=item[13]
			resultgroup=item[21]
			//document.getElementById("SpePos").value=item[21]
		}
	}
	
	if(bNewPatient==1)
    {
		 document.getElementById("ClinicRec1").disabled=false
		 document.getElementById("QiangJingXiaSuoJian").disabled=false
    }
    else
    {
		 document.getElementById("ClinicRec1").disabled=true
		 document.getElementById("QiangJingXiaSuoJian").disabled=true
    }
 }
 //存储临床症状与体征和送检目的
 function SetClinicRecord()
 {
	var item=tclinicrecord.split(code1)
    
	var trec1=item[0]
	var trec2=item[1]
	var trec3=item[2]
	document.getElementById("ClinicRec1").value=trec1
	document.getElementById("JWClinicRec").value=trec2
	if(trec3==t['CHALIU'])
	{
		document.getElementById("bLiuCell").checked=true
		document.getElementById("bOther").checked=false
		document.getElementById("OtherInfo").value=""
	}
	else
	{
		document.getElementById("bLiuCell").checked=false
		document.getElementById("bOther").checked=true
		document.getElementById("OtherInfo").value=trec3
	}
	
	if(bNewPatient==1)
    {
		 document.getElementById("ClinicRec1").disabled=false
		 document.getElementById("JWClinicRec").disabled=false
	 	 document.getElementById("bLiuCell").disabled=false
	 	 document.getElementById("bOther").disabled=false
	 	 document.getElementById("OtherInfo").disabled=false
    }
    else
    {
		 document.getElementById("ClinicRec1").disabled=true
		 document.getElementById("JWClinicRec").disabled=true
	 	 document.getElementById("bLiuCell").disabled=true
	 	 document.getElementById("bOther").disabled=true
	 	 document.getElementById("OtherInfo").disabled=true
	 	 DisableById(componentId,"TumourDate")
    DisableById(componentId,"LastDate")
    //DisableById(componentId,"HuiZhenBiaoBen")
    //DisableById(componentId,"SpePos")
	 }
 }
//添加按钮事件
function SpeAddkey()
 { 
	var VSpeNum1=document.getElementById("SpeNum").value
	var VSpeNum=Trim(VSpeNum1)  //Add by lff 2008-12-18
    if ((VSpeNum=="")||(VSpeNum>"1"))
    {
	   alert(t['NOTNULLSpeNum']);
	   return;
    }
	if ((!isDigit(VSpeNum))&&(document.getElementById("SpeCount").value!="0"))
	{
		alert(t['NotNumber']);
		return;
	}
    var VSpePos=document.getElementById("SpePos").value
    var VSpePos=Trim(VSpePos)
    if (VSpePos=="")
    {
	   alert(t['NOTNULLSpePos']);
	   return;
    }
    var VSpeMemo=document.getElementById("SpeMemo").value
    var VSpeMemo1=document.getElementById("SpeMemo1")
    var VSpeMemo2=document.getElementById("SpeMemo2")
    var VSpeMemo3=document.getElementById("SpeMemo3")
    var VSpeMemo=Trim(VSpeMemo)
    var VSpeMemo1v=Trim(VSpeMemo1.value)
    var VSpeMemo2v=Trim(VSpeMemo2.value)
    var VSpeMemo3v=Trim(VSpeMemo3.value)
	if ((VSpeMemo=="")||((VSpeMemo1v=="")&&(VSpeMemo1.style.display==""))||((VSpeMemo2v=="")&&(VSpeMemo2.style.display==""))||((VSpeMemo3v=="")&&(VSpeMemo3.style.display=="")))
    {
	   alert(t['NOTNULLSpeMemo']);
	   return;
    }	
    var TMrowid=ttmrowid

		var SpeMemo=VSpeMemo
		if(VSpeMemo1.style.display=="")  SpeMemo+=code1+VSpeMemo1v
		if(VSpeMemo2.style.display=="")  SpeMemo+=code1+VSpeMemo2v
		if(VSpeMemo3.style.display=="")  SpeMemo+=code1+VSpeMemo3v
		
    var SpeAddFun=document.getElementById("SpeAddFunction").value
    var ret=cspRunServerMethod(SpeAddFun,TMrowid+"^"+VSpeNum+"^"+VSpePos+"^"+SpeMemo+"^"+"^"+"^")
	if (ret=="-916")
    {
	   alert(t['SpeAddWrongNo'])
	}
    else if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeAddFailure'])
	}
    else
    {
	   //alert(t['SpeAddSuccess'])
	}
	
	Refresh()
	AutoNumber()
 }
 //删除按钮事件
 function SpeDelkey()
 {  
  //alert("SpeDelkey")
	selectrow=SelectedRow		
    var SpeRowId=document.getElementById("SpeRowId").value
    if (SpeRowId=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    var SpeDelFun=document.getElementById("SpeDelFunction").value
    var ret=cspRunServerMethod(SpeDelFun,SpeRowId)
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeDelFailure'])
	}
    else
    {
	   //alert(t['SpeDelSuccess'])
	}
	
	Refresh()
		
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 //修改按钮事件
 function SpeEditkey()
 {  //alert("SpeEditkey")
	selectrow=SelectedRow
	var SpeNum=document.getElementById("SpeNum").value
    var SpePos=document.getElementById("SpePos").value
    var VSpeMemo=document.getElementById("SpeMemo").value
    var SpeRowId=document.getElementById("SpeRowId").value
    var VSpeMemo1=document.getElementById("SpeMemo1")
    var VSpeMemo2=document.getElementById("SpeMemo2")
    var VSpeMemo3=document.getElementById("SpeMemo3")
    var VSpeMemo=Trim(VSpeMemo)
    var VSpeMemo1v=Trim(VSpeMemo1.value)
    var VSpeMemo2v=Trim(VSpeMemo2.value)
    var VSpeMemo3v=Trim(VSpeMemo3.value)
    if ((SpeNum=="")||(SpePos=="")||(VSpeMemo=="")||((VSpeMemo1v=="")&&(VSpeMemo1.style.display==""))||((VSpeMemo2v=="")&&(VSpeMemo2.style.display==""))||((VSpeMemo3v=="")&&(VSpeMemo3.style.display=="")))
    {
	   alert(t['NOTNULL'])
	   return;
    }
    if (SpeRowId=="")
    {
	   alert(t['CHOOSELINE'])
	   return;
    }
    
    var SpeMemo=VSpeMemo
		if(VSpeMemo1.style.display=="")  SpeMemo+=code1+VSpeMemo1v
		if(VSpeMemo2.style.display=="")  SpeMemo+=code1+VSpeMemo2v
		if(VSpeMemo3.style.display=="")  SpeMemo+=code1+VSpeMemo3v
    
    var SpeEditFun=document.getElementById("SpeEditFunction").value
    var ret=cspRunServerMethod(SpeEditFun,SpeNum+"^"+SpePos+"^"+SpeMemo+"^"+"^"+"^",SpeRowId)
    if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['SpeEditFailure'])
	}
    else
    {
	  // alert(t['SpeEditSuccess'])
	}
	
	Refresh()
	document.getElementById("SpecimenDel").disabled=true
	document.getElementById("SpecimenEdit").disabled=true
	document.getElementById("SpecimenAdd").disabled=false
 }
 //发送申请单按钮事件
 function SendAppkey()
 { 
 	//if(document.getElementById("SendApp").disabled==true)
 		//return

    if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    //修改
    var jw=document.getElementById("JWClinicRec").value
    var lc=document.getElementById("ClinicRec1").value
    //bitian
    var qj=document.getElementById("QiangJingXiaSuoJian").value
		if(jw==""||lc==""||(bitian&&(qj=="")))
		{
			alert(t['AllDoNotNull'])
			return	
		}
		var OtherTLCell=document.getElementById("OtherTLCell").checked
		var TLCell=document.getElementById("TLCell").value
		//var HuiZhen=document.getElementById("HuiZhen").checked
		//var HuiZhenBiaoBen=document.getElementById("HuiZhenBiaoBen").value
		
		var ChuanCiWu=document.getElementById("ChuanCiWu").checked
		var RuYi=document.getElementById("RuYi").checked
		var TBNA=document.getElementById("TBNA").checked
		var EBUS=document.getElementById("EBUS").checked
		var ChaoShengChuanCi=document.getElementById("ChaoShengChuanCi").checked
		var CTChuanCi=document.getElementById("CTChuanCi").checked
		//var OtherTLCell=document.getElementById("OtherTLCell").checked
		var OtherZXCell=document.getElementById("OtherZXCell").checked
		/*
		if(specimen==false)
		{
			alert(t['NOSPECIMEN']+"1")
			return;
		}
		else
		{
    */
    /*
			if(((OtherTLCell==true)&&(TLCell==""))||((HuiZhen==true)&&(HuiZhenBiaoBen=="")))
			{
				alert(t['NOSPECIMEN']+"2")
				return;
			}
      */
      if((OtherTLCell==true)&&(TLCell==""))
			{
				alert(t['NOSPECIMEN']+"2")
				return;
			}
			if(ChuanCiWu||RuYi||TBNA||EBUS||ChaoShengChuanCi||CTChuanCi||OtherZXCell)
			{
				var chuancibuwei=""
				for(var i=1;i<10;i++)
				{
						var chuancibuwei1=document.getElementById("ChuanCiBuWei"+i).value
						chuancibuwei+=chuancibuwei1
				}
				if(chuancibuwei=="")
				{
					alert(t['NOSPECIMEN']+"3")
					return;
				}
			}
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    SetSpecimenInfo()
    
    var SQDPriceFun=document.getElementById("SQDPrice").value
    var SQDPrice=cspRunServerMethod(SQDPriceFun,orditemdr)
    var TotalPriceInfo=document.getElementById("UpdateTotalPrice").value
    var TotalPrice=cspRunServerMethod(TotalPriceInfo,SQDPrice,ttmrowid)
    
    var typezm=document.getElementById("PType").value
     var orditemrowid=document.getElementById("OEorditemID").value
	 var jifeibiaozhiFun=document.getElementById("jifeibiaozhi").value
	 var biaozhi=cspRunServerMethod(jifeibiaozhiFun,orditemrowid)
	 if ((typezm=="门诊病人")&&(biaozhi!="P"))
	 {
	   alert(t['ISNOTJIFEI'])
	   return
	 }
	 else
	 {
		 SetAppStatus()
		 }
    //SetAppStatus()
    Refresh2()
 }
 
  //发送申请单按钮事件
 function SaveAppkey()
 {  
 	//if(document.getElementById("SendApp").disabled==true)
 		//return
 		
 	if (ttmrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    }
    
	
    SetPatInfo()
    SetAppInfo()
    SetWomanTumourInfo()
    SetSpecimenInfo()
   
    Refresh2()
   	DisableById(componentId,"TumourDate")
    DisableById(componentId,"LastDate")
 }

 //保存标本信息
 function SetSpecimenInfo()
 {
	 //alert(tspecimeninfo)
	 if(bNewPatient==1)
	 {      
	 	var TLCellNum=document.getElementById("TLCellNum").value;
	 	var ZXCellNum=document.getElementById("ZXCellNum").value;
	 	TLCellSpecimen("Tan",TLCellNum)
	 	TLCellSpecimen("XiongShui",TLCellNum)
	 	TLCellSpecimen("FuShui",TLCellNum)
	 	TLCellSpecimen("XinBaoJiYe",TLCellNum)
	 	TLCellSpecimen("NaoJiYe",TLCellNum)
	 	TLCellSpecimen("Niao",TLCellNum)
	 	TLCellSpecimen("YinLiuNiao",TLCellNum)
	 	TLCellSpecimen("ZhiQiGuanJingGuanXiYe",TLCellNum)
	 	TLCellSpecimen("ZhiQiGuanJingShuaPian",TLCellNum)
	 	TLCellSpecimen("ShiGuanJingShuaPian",TLCellNum)
	 	TLCellSpecimen("JieChangJingShuaPian",TLCellNum)
	 	TLCellSpecimen("FuQiangChongXiYe",TLCellNum)
	 	TLCellSpecimen("PenQiangChongXiYe",TLCellNum)
	 	TLCellSpecimen("FuPenQiangChongXiYe",TLCellNum)
	 	//TLCellSpecimen("MianYiXiBaoHuaXue",TLCellNum)
	 	TLCellSpecimen("OtherTLCell",TLCellNum)
	 	//TLCellSpecimen("XiongShui",TLCellNum)
	 	
	 	ZXCellSpecimen("ChuanCiWu",ZXCellNum)
	 	ZXCellSpecimen("RuYi",ZXCellNum)
	 	ZXCellSpecimen("TBNA",ZXCellNum)
	 	ZXCellSpecimen("EBUS",ZXCellNum)
	 	ZXCellSpecimen("ChaoShengChuanCi",ZXCellNum)
	 	ZXCellSpecimen("CTChuanCi",ZXCellNum)
	 	ZXCellSpecimen("OtherZXCell",ZXCellNum)
	 	//ZXCellSpecimen("OtherZXCell",ZXCellNum)
	 	
	 	//HZCellSpecimen()
	 }
 }
 function TLCellSpecimen(id,TLCellNum)
{
	var tspeinfo=""
	var sno=""
	if(id!="OtherTLCell")
	{
		if(document.getElementById(id).checked)
		{     
			tspecimeninfo=t[id]
			//alert(tspecimeninfo)
			for(sno=1;sno<=TLCellNum;sno++)
			{
				tspeinfo=ttmrowid+"^"+sno+"^"+tspecimeninfo+"^"+TLCellNum+"~"+t['tlfen']+"^^^^^"
				var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
				var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)            
  	   	if (tsperowid=="")
  	   	{
	  	  	alert['UpdateSpeFailure']
	  	  	return
  	   	}
			}
		}
	}else
	{
		if(document.getElementById(id).checked)
		{
			//tspecimeninfo=t[id]+"^"+document.getElementById("TLCell").value
			//tspeinfo=ttmrowid+"^1^"+t[id]+":"+tspecimeninfo+"^"+TLCellNum+"~"+t['tlfen']+"^^^"
      var TLCell=document.getElementById("TLCell").value
      tspeinfo=ttmrowid+"^1^"+t[id]+duihao+TLCell+"^"+TLCellNum+"~"+t['tlfen']+"^^^^^"
			var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
			var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)
  	  if (tsperowid=="")
  	  {
	  	 	alert['UpdateSpeFailure']
	  	 	return
  	  }
		}	
	}	
}

function ZXCellSpecimen(id,ZXCellNum)
{
	var tspeinfo=""
	var sno=""
	if(document.getElementById(id).checked)
		{
			for(sno=1;sno<=ZXCellNum;sno++)
			{
				var ChuanCiBuWei=document.getElementById("ChuanCiBuWei"+sno).value
				if(ChuanCiBuWei=="") continue
				tspeinfo=ttmrowid+"^"+sno+"^"+t[id]+duihao+ChuanCiBuWei+"^"+ZXCellNum+"~"+t['tlfen']+"^^^^^"
				var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
				var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)
  	   	if (tsperowid=="")
  	   	{
	  	  	alert['UpdateSpeFailure']
	  	  	return
  	   	}
			}
		}	
}
/*
function HZCellSpecimen()
{
	var tspeinfo=""
	var sno=""
	if(document.getElementById("HuiZhen").checked)
	{
		var HuiZhenBiaoBen=document.getElementById("HuiZhenBiaoBen").value
		if(HuiZhenBiaoBen=="") 
		{
			alert(t['NOTNULLSpeNum'])
			return;
		}
		tspeinfo=ttmrowid+"^"+sno+"^"+t['HuiZhen']+"^"+HuiZhenBiaoBen+"^^^^"
		var SetSpeInfofun=document.getElementById("SetSpecimenInfo").value;
		var tsperowid=cspRunServerMethod(SetSpeInfofun,tspeinfo)
   	if (tsperowid=="")
   	{
	  	alert['UpdateSpeFailure']
	  	return
   	}
	}	
}
*/
 //保存病人信息
 function SetPatInfo()
 {
 	if(bNewPatient==1)
	{
		 var patinfo=""
		 
		 var ndob=document.getElementById('PBirthday').value
		 var ChangDFun=document.getElementById("DateChange4to3").value
		 var vdate3=cspRunServerMethod(ChangDFun,ndob)

		 patinfo+=paadmdr+"^"
		 patinfo+=document.getElementById('AdmtypeDR').value+"^"
		 patinfo+=document.getElementById('PName').value+"^^"
		 patinfo+=document.getElementById('CharegetypeDR').value+"^"
		 patinfo+=document.getElementById('SexDr').value+"^"
		 patinfo+=vdate3+"^"
		 patinfo+=document.getElementById('PAddress').value+"^"
		 patinfo+=document.getElementById('RegNo').value+"^"
		 patinfo+=document.getElementById('InpoNo').value+"^"
		 patinfo+=document.getElementById('RoomNo').value+"^"
		 patinfo+=document.getElementById('BedNo').value+"^"
		 patinfo+=document.getElementById('PTel').value+"^"
		 
	     var SetPatInfoFun=document.getElementById("AddPatInfo").value
   	     var PATCODE=cspRunServerMethod(SetPatInfoFun,patinfo,ttmrowid)
  	   	 if (PATCODE!="0")
  	   	 {
	  	   	alert['UpdatePatFailure']
	  	   	return
  	   	 }
	 }	 
 }
 //取得临床症状和体征~送检目的
 function GetClinicRecord()
 {
	tclinicrecord=""
	
	var trec1=document.getElementById("ClinicRec1").value
	var trec2=document.getElementById("JWClinicRec").value
	var trec3=""
	if(document.getElementById("bLiuCell").checked==true)
	{
		trec3=t['CHALIU']
	}
	else
	{
		trec3=document.getElementById("OtherInfo").value
	}

	tclinicrecord=trec1+code1+trec2+code1+trec3
 }
 //存储申请信息
 function SetAppInfo()
 {
	 if(bNewPatient==1)
	 {
		 var appinfo=""
		 var tbingdong=""
		 
		 GetClinicRecord()
		 
 		 var tbingdong="0"
		 
		 appinfo+=tclinicrecord+"^"
		 appinfo+=document.getElementById("QiangJingXiaSuoJian").value+"^^^"
		 appinfo+=document.getElementById('ClinicDiag').value+"^"+tbingdong+"^^^"
		 appinfo+=document.getElementById('AppDep').value+"^"
		 appinfo+=document.getElementById('AppLocDR').value+"^"
		 appinfo+=document.getElementById('AppDoc').value+"^"
		 appinfo+=document.getElementById('AppDocDR').value+"^"+orditemdr

	     var SetAppInfoFun=document.getElementById("AddAppInfo").value;
   	     var APPCODE=cspRunServerMethod(SetAppInfoFun,appinfo,ttmrowid)
  	   	 if (APPCODE!="0")
  	   	 {
	  	   	alert['UpdateAppFailure']
	  	   	return
  	   	 }
	 }
 }
 
 //保存肿瘤信息
 function SetWomanTumourInfo()
 {
	 if(bNewPatient==1)
	 {
		//set tumour info//修改
		var foundDate=document.getElementById("TumourDate").value
		var foundPos=document.getElementById("TumourPosition").value
		/*
    if(foundDate==""&&foundPos=="")
		{
			alert['DoNotNull']
			return
		}
		 
		if (!((foundDate=="")&&(foundPos==""))||((foundDate!="")&&(foundPos!="")))  //Add by lff 2008-12-18
		{
			alert(t['AllWrite'])
	     	return
		}
		*/
   		if (foundDate!="" && foundPos!="" && foundDate!=DateDemo())
		{
				var enmeth=document.getElementById("DateChange4to3").value
				foundDate=cspRunServerMethod(enmeth,foundDate)
   			var position=document.getElementById("TumourPosition").value
    		var size=document.getElementById("TumourSize").value
    		var beTransfer=document.getElementById("Transfer").checked
    		var zhuanyi=""
    		if (beTransfer==true) 
    		{
	    		zhuanyi="Y"
    		}
   			else if (beTransfer==false) 
    		{
	    		zhuanyi="N"
    		}
    		
    		var transferPos=document.getElementById("TransPos").value
    		var radioCure=document.getElementById("RadioCure").checked
    		var radioc=""
    		if (radioCure==true) 
    		{
	    		radioc="Y"
    		}
    		else if (radioCure==false) 
    		{
	    		radioc="N"
   			}
    		var chemicalCure=document.getElementById("ChemicalCure").checked
    		var chemicalc=""
   		 	if (chemicalCure==true) 
    		{
	    		chemicalc="Y"
   			}
    		else if (chemicalCure==false) 
    		{
	    		chemicalc="N"
    		}
    		
    		var otherInfo=document.getElementById("memo").value
     		var UpdateTumourInfo=ttmrowid+"^"
     		UpdateTumourInfo+=foundDate+"^"+position+"^"+size+"^"+zhuanyi+"^"+transferPos+"^"+radioc+"^"+chemicalc+"^"+otherInfo
	        var UpdateTumour=document.getElementById("AddTumourInfo").value;
      		var tumourid=cspRunServerMethod(UpdateTumour,UpdateTumourInfo)
      		//alert("UpdateTumourInfo")
	        if (tumourid=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
     		{
	     		alert(t['SendAppFailure'])
	     		return
	 		 }
		}
	 }
 }
 //设定申请标示码
 function SetAppStatus()
 {
	 if(bNewPatient==1)
	 {
		 var trscode="1"
		 var trsid=""
		 
		 var GetRsIDFun=document.getElementById("GetRSidByCode").value

		 var vid=cspRunServerMethod(GetRsIDFun,trscode)
		 if(vid!="")
		 {
			 trsid=vid
			  
			 var SetStatusInfo=document.getElementById("UpdateRStatus").value
   	     	 var rcode=cspRunServerMethod(SetStatusInfo,trsid,ttmrowid)
  	   	 	 if (rcode!="0")
  	   	 	 {
	  	   		alert(t['UpdateStatusFailure'])
	  	   		return
  	   	 	 }
  	   	 	 
  	   	 	 //ChangRISStatus//和RIS接口
			var docdr=document.getElementById("AppDocDR").value
			var ChangeStatusInfo=document.getElementById("ChangRISStatus").value;
			var rriscode=cspRunServerMethod(ChangeStatusInfo,orditemdr,docdr)
      if (rriscode=="0")
			{
				alert(t['sendsuccess'])
			  return
		   }
			if (rriscode!="0")
			{
				alert(t['UpdateStatusFailure'])
				return
			}
		}		 
	 } 
 }
  function SetCancelAppToENS()
 {
	var docdrc=document.getElementById("AppDocDR").value
	var CalcelAppInfo=document.getElementById("CalcelAppInfoToENS").value;
	var rriscode=cspRunServerMethod(CalcelAppInfo,orditemdr,docdrc) 		
 } 
 //取消申请单按钮
 function CancelAppkey()
 { 
 	if(document.getElementById("CancelApp").disabled==true)
 		return
 		 
	var TMrowid=document.getElementById("TMrowid").value
    if (TMrowid=="")
    {
	   alert(t['NOTNULL'])
	   return
    } 	
    
     var Ans=confirm(t['DeleteSend'])
	 if (Ans==false)
	 {
		 return
     }
    //SetCancelAppToENS() 
    var CancelAppFun=document.getElementById("CancelAppFunction").value
    var ret=cspRunServerMethod(CancelAppFun,TMrowid)
	if (ret.split("-")[0]=="") //Such as return -901,-915 or other SQL error,which is initial with "-".
    {
	   alert(t['CancelAppFailure'])
	}
    else
    {
	  // alert(t['CancelAppSuccess'])
	}
	
	Refresh()
 }

//刷新
 function Refresh()
 {
 	var Eposide=document.getElementById("EpisodeID").value
    var ComponentName=document.getElementById("ComponentName").value  //"DHCRisApplicationBill"
    var TMrowid=document.getElementById("TMrowid").value
    var OEorditemID=document.getElementById("OEorditemID").value
    var memovalue=document.getElementById("memo").value
    //YCX20081205缓存临床症状及体征
    var ClinicRec1A=document.getElementById("ClinicRec1").value
    var otherInfo=document.getElementById("OtherInfo").value
   
    ////YCX20081205缓存肿瘤信息
    var TumourPosition=document.getElementById("TumourPosition").value
    var TumourDate=document.getElementById("TumourDate").value
    var TumourSize=document.getElementById("TumourSize").value
    var TransPos=document.getElementById("TransPos").value //转移部位 
    var TLCellNum=document.getElementById("TLCellNum").value
    var ZXCellNum=document.getElementById("ZXCellNum").value
    var Refresh=document.getElementById("Refresh").value
    //var PreSelectrow=document.getElementById("PreSelectrow").value //Add by lff 2008-12-18
    
   var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName
   lnk+="&TumourPosition="+TumourPosition
   lnk+="&TumourDate="+TumourDate
   lnk+="&TumourSize="+TumourSize
   lnk+="&memo="+memovalue
   lnk+="&TransPos="+TransPos  
   
   lnk+="&EpisodeID="+Eposide
   lnk+="&OEorditemID="+OEorditemID
   lnk+="&TMrowid="+TMrowid
   lnk+="&ComponentName="+ComponentName
   
   lnk+="&ClinicRec1="+ClinicRec1A
   lnk+="&OtherInfo="+otherInfo
   
   lnk+="&TLCellNum="+TLCellNum
   lnk+="&ZXCellNum="+ZXCellNum
   lnk+="&Refresh="+Refresh
   //lnk+="&PreSelectrow="+PreSelectrow //Add by lff 2008-12-18 记录前一次所选行
   location.href=lnk
   AutoNumber()
 }
 ////////YCX20081204发送申请单刷新左菜单
  function Refresh2()
 {
 	var Eposide=document.getElementById("EpisodeID").value
    var ComponentName=document.getElementById("ComponentName").value  //"DHCRisApplicationBill"
    var TMrowid=document.getElementById("TMrowid").value
    var OEorditemID=document.getElementById("OEorditemID").value
    var memovalue=document.getElementById("memo").value
    //var ClinicRec1A=document.getElementById("ClinicRec1").value
    //var Refresh=document.getElementById("Refresh").value
    //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&ClinicRec1="+ClinicRec1A+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&memo="+memovalue+"&Refresh="+Refresh
    //var PreSelectrow=document.getElementById("PreSelectrow").value //Add by lff 2008-12-18

    var lnk= "dhcrisappbill.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&TMrowid="+TMrowid+"&ComponentName="+ComponentName+"&memo="+memovalue
    parent.location.href=lnk;
    AutoNumber()
 }
 
 //清空页面
 function Clear()
 {
 	var ComponentName=document.getElementById("ComponentName").value  //"DHCRisApplicationBill"
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+""+"&OEorditemID="+""+"&TMrowid="+""+"&ComponentName="+ComponentName+"&Refresh="+""
    location.href=lnk
 }
 //查瘤细胞事件
 function LiuKey()
{
	var MorningObj=document.getElementById("bLiuCell")
	if (MorningObj.checked)
	{
	  document.getElementById("bOther").checked=false
	  document.getElementById("OtherInfo").disabled=true
	  document.all("OtherInfo").style.display="none"
	  document.getElementById("OtherInfo").value=""
	}
}

//其他?送检目的?时间
function OtherKey()
{
	var AfternoonObj=document.getElementById("bOther")
	if (AfternoonObj.checked)
	{
	  document.getElementById("bLiuCell").checked = false
	  document.getElementById("OtherInfo").disabled=false
	  	  document.all("OtherInfo").style.display=""
	  document.getElementById("OtherInfo").value=""
	}
}

 
 //当前日期
function DateDemo()
{
   var d, s=""        
   d = new Date()
   var sDay="",sMonth="",sYear="",tYear=""
   sDay = d.getDate()			
   if(sDay < 10)
   sDay = "0"+sDay
    
   sMonth = d.getMonth()+1	
   if(sMonth < 10)
   sMonth = "0"+sMonth
   
   sYear  = d.getYear()
   s = sDay + "/" + sMonth + "/" + sYear 
   return(s)
}

//屏蔽 放大镜 
function DisableById(componentId,id)
{
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
}
//肿瘤发现日期失去焦点
function TumourDateblur()
{
	var TDate=document.getElementById("TumourDate")
	if(BJDate(TDate.value))
	{
		alert(t['DateError'])
		document.getElementById("TumourDate").value=""
		TDate.focus()
	}
} 	 	
//比较日期?以便是所选日期不能晚于当前日期
function BJDate(date)
{
	var today=DateDemo();
	var dDate=date.split("/")
	var tDate=today.split("/")
	if(dDate[2]>tDate[2])
	{
		boolvalue=true;
	}else if(dDate[2]==tDate[2])
	{
		if(dDate[1]>tDate[1])
		{
		boolvalue=true;	
		}else if(dDate[1]==tDate[1])
		{
			if(dDate[0]>tDate[0])
			{
				boolvalue=true;	
			}else
			{
				boolvalue=false;	
			}	
		}else
		{
			boolvalue=false;
		}
	}else
	{
		boolvalue=false;
	}
	return boolvalue;
}
//是否转移对转移部位的控制
function TransferKey()
{
	var TransferObj=document.getElementById("Transfer");
	if (TransferObj.checked)
	{
	  document.getElementById("TransPos").disabled = false;
	  document.all("TransPos").style.display = ""
	  document.getElementById("TransPos").value ="";
	}
	else
	{
	  document.getElementById("TransPos").disabled = true;
	  document.all("TransPos").style.display = "none"
	  document.getElementById("TransPos").value="";
	} 
}
//标本序号自动+1
function AutoNumber()
 {
	var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	var item=info.split(";")
	autoNumber=item.length
	//document.getElementById("SpeNum").value = autoNumber
 }
 
  
//判断元素的值是否为空
function isNull(Item)
{
	var ft=true
	var isNull=	document.getElementById(Item).value
	if(isNull=="")
		ft = true;	
	else
		ft = false;
	return ft;
}
//去除字符串首尾空格Trim
function Trim(sInputString)
{
var sTmpStr = ' '
var i = -1
//------去除左空格--------
while(sTmpStr == ' ')
{
++i
sTmpStr = sInputString.substr(i,1)
}
sInputString = sInputString.substring(i)
//------去除左空格--------
//---------去除右空格----
sTmpStr = ' '
i = sInputString.length
while(sTmpStr == ' ')
{
--i
sTmpStr = sInputString.substr(i,1)
}
sInputString = sInputString.substring(0,i+1)
//---------去除右空格----
return sInputString
}

//是否全为数字
function isDigit(s)
{
    var patrn=/^[0-9]{1,20}$/;
    if (!patrn.exec(s)) return false
    return true
}

 //打印申请单日期
function PrintAppkey()
{
	if(document.getElementById("PrintApp").disabled==true)
 		return
 		var GetTmrowidFun=document.getElementById("GetTmRowId").value
  	var TMROWID=cspRunServerMethod(GetTmrowidFun,recLocDr,orditemdr)
  	//alert(TMROWID)
    
    if (TMROWID!=document.getElementById("TMrowid").value)
    {
	   alert(t['NOEXIST'])
	   //Refresh();
	   return
	   
    }
 	//CommonPrint("DHCPisAppQjblZLYY")

	 var xlApp,xlsheet,xlBook
   //,Template
     var GetPrescPath=document.getElementById("GetRepPath");
	 if (GetPrescPath) {var encmeth=GetPrescPath.value} 
	 else {var encmeth=''};
	 if (encmeth!="") 
	 {
		var TemplatePath=cspRunServerMethod(encmeth);
	 }
   //alert(TemplatePath)
      var Template=TemplatePath+"DHCPisAppUNWCellXHYY.xls";
      
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;
      var duihao=String.fromCharCode(8730)        
   	
	    //号码
	    //xlsheet.cells(2,1)="*"+document.getElementById("TMrowid").value+"*";  //条码申请单号
       var OEorditemID=document.getElementById("OEorditemID").value; 
      var ordinfo=OEorditemID.split("||")
      var ordinfotm=ordinfo[0]+"-"+ordinfo[1]
      xlsheet.cells(2,1)="*"+ordinfotm+"*";  //条码医嘱号
	    //xlsheet.cells(3,4)=document.getElementById("TMrowid").value;          //申请单号
      xlsheet.cells(3,4)=document.getElementById("RegNo").value;          //登记号/病人ID
	    xlsheet.cells(3,30)=document.getElementById("InpoNo").value;           //病案号
	    //xlsheet.cells(3,14)=document.getElementById("RegNo").value;           //登记号
	    xlsheet.cells(3,18)=document.getElementById("OEorditemID").value;     //医嘱号
	    
	    //基本信息                                                            
	    xlsheet.cells(5,4)=document.getElementById("PName").value;             //病人姓名
	    xlsheet.cells(5,11)=document.getElementById("PSex").value;             //病人性别
	    xlsheet.cells(5,18)=document.getElementById("PAge").value;             //病人年龄
	    
	     //xlsheet.cells(6,4)=document.getElementById("RoomNo1").value;         //科别
       xlsheet.cells(6,4)=document.getElementById("RoomNo").value;         //病区
	     xlsheet.cells(6,18)=document.getElementById("BedNo").value;         //病床号
	     //xlsheet.cells(23,1)=document.getElementById("SjbbxxLC").value;    //送检信息 	    
	    //申请信息
	    xlsheet.cells(25,4)=document.getElementById("AppDep").value;           //申请科室
	    xlsheet.cells(25,14)=document.getElementById("AppDoc").value;          //申请医生
	    var appdate=document.getElementById("AppDate").value;
	    var item=appdate.split("/")
	    xlsheet.cells(25,25)=item[2]+"-"+item[1]+"-"+item[0];         //申请日期
	    //新修改2011-11-9
	    var Tffkbb=""
	    if(document.getElementById("Tan").checked)    //痰
	    {
	    	 Tffkbb=t['Tan']
	    }
      if(document.getElementById("XiongShui").checked)    //胸水
	    {
	    	 Tffkbb=t['XiongShui']
	    }
	    if(document.getElementById("FuShui").checked)   //腹水
	    {
	    	 Tffkbb=t['FuShui']
	    }
	    if(document.getElementById("XinBaoJiYe").checked)   //心包积液
	    {
	    	 Tffkbb=t['XinBaoJiYe']
	    }
	    if(document.getElementById("Niao").checked)    //尿
	    {
	    	 Tffkbb=t['Niao']
	    }
	    if(document.getElementById("YinLiuNiao").checked)   //引流尿 
	    {
	    	 Tffkbb=t['YinLiuNiao']
	    }
	    if(document.getElementById("NaoJiYe").checked)   //脑脊液
	    {
	    	 Tffkbb=t['NaoJiYe']
	    }
	    if(document.getElementById("ZhiQiGuanJingShuaPian").checked)    //支气管镜刷片
	    {
	    	 Tffkbb=t['ZhiQiGuanJingShuaPian']
	    }
	    if(document.getElementById("ShiGuanJingShuaPian").checked)   //食管镜刷片
	    {
	    	 Tffkbb=t['ShiGuanJingShuaPian']
	    }
	    if(document.getElementById("JieChangJingShuaPian").checked)   //结肠镜刷片 
	    {
	    	 Tffkbb=t['JieChangJingShuaPian']
	    }
	    if(document.getElementById("ZhiQiGuanJingGuanXiYe").checked)   //支气管镜灌洗液 
	    {
	    	 Tffkbb=t['ZhiQiGuanJingGuanXiYe']
	    }
	    if(document.getElementById("FuQiangChongXiYe").checked)  //腹腔冲洗液  
	    {
	    	 Tffkbb=t['FuQiangChongXiYe']
	    }
	    if(document.getElementById("PenQiangChongXiYe").checked)   //盆腔冲洗液  
	    {
	    	 Tffkbb=t['PenQiangChongXiYe']
	    }
	    if(document.getElementById("FuPenQiangChongXiYe").checked)   //腹盆腔冲洗液 
	    {
	    	 Tffkbb=t['FuPenQiangChongXiYe']
	    }
      if(document.getElementById("RuYi").checked)   //乳溢   
	    {
	    	 Tffkbb=t['RuYi']
	    }
	    
	    /////////////////// xlsheet.cells(8,1)=Trim(Tffkbb);
	    if(document.getElementById("ChuanCiWu").checked)    //穿刺物    
	    {
	    	 Tffkbb=t['ChuanCiWu']
	    }
	    if(document.getElementById("ChaoShengChuanCi").checked)   //超声引导下穿刺  
	    {
	    	 Tffkbb=t['ChaoShengChuanCi']
	    }
	    if(document.getElementById("CTChuanCi").checked)   //CT引导下穿刺    
	    {
	    	 Tffkbb=t['CTChuanCi']
	    }
      if(document.getElementById("TBNA").checked)   //TBNA    
	    {
	    	 Tffkbb=t['TBNA']
	    }
	    if(document.getElementById("EBUS").checked)   //E-BUS   
	    {
	    	 Tffkbb=t['EBUS']
	    }
	    if(document.getElementById("OtherZXCell").checked)   //其他针吸细胞学标本     
	    {
	    	 Tffkbb=t['OtherZXCell']
	    }
	     xlsheet.cells(8,1)=Trim(Tffkbb);
      /*
	    利用循环，逐个插入（脱落细胞学）
	    var sno2=""
	    var TLCellNum1=document.getElementById("TLCellNum").value
      alert(TLCellNum1)
	    var tTLCellAll=""
	    if((document.getElementById("RuYi").checked)||document.getElementById("XiongShui").checked||document.getElementById("ZhiQiGuanJingShuaPian").checked)
	    {
	    	for(sno2=1;sno2<=TLCellNum1;sno2++)
			  {
        //alert(sno2)
				  var TLCellAll=document.getElementById("TLCell"+sno2).value
          //alert(document.getElementById("TLCell"+sno2).value)
          //alert(document.getElementById("TLCell"+sno2).value)
				  if(TLCellAll=="") continue
				  tTLCellAll+=TLCellAll+"; "
			  }
			  
	    }
       */
    
		   //利用循环，逐个插入(针吸细胞学)
	    var sno1=""
	    var ZXCellNum1=document.getElementById("ZXCellNum").value
	    var tChuanCiBuWeiAll=""
			for(sno1=1;sno1<=ZXCellNum1;sno1++)
			{
				var ChuanCiBuWeiAll=document.getElementById("ChuanCiBuWei"+sno1).value
				if(ChuanCiBuWeiAll=="") continue
				tChuanCiBuWeiAll+=ChuanCiBuWeiAll+"; "
			}
	
      if((document.getElementById("TLCellNum").value)!="")
      {
      	 //xlsheet.Rows(17).RowHeight = 12;
      	//xlsheet.Cells(18,1).HorizontalAlignment = 3; //水平对齐
				//xlsheet.Cells(18,1).VerticalAlignment = 2;     //垂直对齐
				xlsheet.cells(9,1)=t['tlxbxbbsl'];  //脱落细胞学标本数量
				//xlsheet.cells(10,1)="脱落细胞学标本:";  //脱落细胞学标本
				//xlsheet.cells(10,7)=tTLCellAll;  //脱落细胞学标本
				xlsheet.cells(9,9)=document.getElementById("TLCellNum").value;  //脱落细胞学标本数量
	    
      }
      if((document.getElementById("ZXCellNum").value)!="")
      {
      	xlsheet.cells(9,1)=t['zxxbxbbsl'];  //针吸细胞学标本数量
				xlsheet.cells(10,1)=t['ccbw'];  //穿刺部位
				xlsheet.cells(10,7)=Trim(tChuanCiBuWeiAll); //穿刺部位
				xlsheet.cells(9,9)=document.getElementById("ZXCellNum").value;  //针吸细胞学标本数量   
      }
      if(document.getElementById("OtherTLCell").checked)   //其他脱落细胞学标本 
	    {
	    	 Tffkbb=t['OtherTLCell']+":"+document.getElementById("TLCell").value;  //脱落细胞学标本
         xlsheet.cells(8,1)=Trim(Tffkbb);
	    }
      if(document.getElementById("QiangJingXiaSuoJian").value=="")
      {
      	xlsheet.Rows(16).RowHeight = 1;
      	xlsheet.cells(16,1)="";
      	xlsheet.Rows(17).RowHeight = 1;
        xlsheet.cells(17,1)="";
        
      }
      
      var GetSpecimensFunc=document.getElementById("autoNumAdd").value
	    var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
	    
	    //xlsheet.cells(28,1)=info                                         //标本信息
	    if(document.getElementById("bLiuCell").checked)   //查瘤细胞
	       xlsheet.cells(12,4)=duihao
	    if(document.getElementById("bOther").checked)   //其他
	       xlsheet.cells(12,11)=duihao 
	  xlsheet.cells(12,12)=document.getElementById("OtherInfo").value;  //其他目的信息
	  xlsheet.cells(17,1)=document.getElementById("QiangJingXiaSuoJian").value;   //腔镜下所见
    xlsheet.cells(23,1)=document.getElementById("ClinicDiag").value;    //临床诊断
	  xlsheet.cells(19,1)=document.getElementById("JWClinicRec").value;  //既往病史及治疗史
    xlsheet.cells(21,1)=document.getElementById("ClinicRec1").value;  //临床症状及体征
	    
	    //肿瘤信息
      xlsheet.cells(14,12)=document.getElementById("TumourPosition").value; //肿瘤部位
      xlsheet.cells(14,21)=document.getElementById("TumourSize").value;   //肿瘤大小
      var tdate=document.getElementById("TumourDate").value;
      if(tdate!="")
      {
	  	var item=tdate.split("/")
      	xlsheet.cells(14,4)=item[2]+"-"+item[1]+"-"+item[0];   //发现日期
      }
      if(document.getElementById("Transfer").checked)   //有无转移
          xlsheet.cells(14,28)=duihao
      xlsheet.cells(15,4)=document.getElementById("TransPos").value;   //转移部位
      if(document.getElementById("RadioCure").checked)   //曾否放疗
          xlsheet.cells(15,11)=duihao
      if(document.getElementById("ChemicalCure").checked)   //曾否化疗
          xlsheet.cells(15,17)=duihao
      xlsheet.cells(15,23)=document.getElementById("memo").value;   //备注
      
      xlsheet.PrintOut 
    	xlBook.Close (savechanges=false);
    	xlApp.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制
    	xlBook=null
    	xlApp.Quit();
    	xlApp=null;
    	xlsheet=null 
    	//window.setInterval("Cleanup();",1); 
 }
function PirntTMKey()
{
    var Bar,j;
    Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
    Bar.PrintName="tiaoma";//printer name
       
    var RegisterNum=document.getElementById("RegNo").value
    var PName=document.getElementById("PName").value
    var RoomNo=document.getElementById("RoomNo").value
    var RoomNo=RoomNo.split("-")
    var RoomNo=RoomNo[1]
    var BedNo=document.getElementById("BedNo").value
    var PatLoc=document.getElementById("AppDep").value

    var OrderName=document.getElementById("GetOEorditemName").value

    		var GetSpecimensFunc=document.getElementById("autoNumAdd").value
      	var info=cspRunServerMethod(GetSpecimensFunc,ttmrowid)
      	var items=info.split(";")
      	var lenth=items.length-2
      	//alert("lenth="+lenth)
      	//alert(info) 1:dd(1);2:ss(2);
      	for (var i=0;i<=lenth;i++)
    	  {   
            //Bar.LabNo=document.getElementById("TMRowid").value; 
            var n=i+1;
            Bar.LabNo=ttmrowid+"-"+n
            Bar.RecLoc=t['RecLoc'];
            //Bar.PatLoc=PatLoc+" "+BedNo+t['chuang'];
            Bar.PatLoc=PatLoc;
            Bar.OrdName=OrderName;
            Bar.PatName=RegisterNum+" "+PName;
            Bar.Sex=document.getElementById("PSex").value;
            Bar.Age=document.getElementById("PAge").value;
            Bar.BedCode=BedNo;
            Bar.LabelDesc=items[i].split("~")[0]+items[i].split("~")[1];         
            //Bar.LabelDesc=items[i]; 
            //alert(Bar.LabNo+"="+Bar.RecLoc+"="+Bar.PatLoc+"="+Bar.OrdName+"="+Bar.PatName+"="+Bar.Sex+"="+Bar.Age+"="+Bar.BedCode+"="+Bar.LabelDesc)   
            Bar.PrintOut(1);
        }
}

function ZhiQiGuanJingShuaPianKey()
{
	var elementObj=document.getElementById("ZhiQiGuanJingShuaPian").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="ZhiQiGuanJingShuaPian")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		bitian=true
		QJXSJBiTian(bitian)
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		bitian=false
		QJXSJBiTian(bitian)
		specimen=false
	}
	DisableChuanCiBuWei()
}

function TanKey()
{
	var elementObj=document.getElementById("Tan").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="Tan")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="3"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";	
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function XiongShuiKey()
{
   var elementObj=document.getElementById("XiongShui").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="XiongShui")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function FuShuiKey()
{
  var elementObj=document.getElementById("FuShui").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="FuShui")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function XinBaoJiYeKey()
{
  var elementObj=document.getElementById("XinBaoJiYe").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="XinBaoJiYe")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function NaoJiYeKey()
{
  var elementObj=document.getElementById("NaoJiYe").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="NaoJiYe")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function NiaoKey()
{
	var elementObj=document.getElementById("Niao").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="Niao")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function YinLiuNiaoKey()
{
	var elementObj=document.getElementById("YinLiuNiao").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="YinLiuNiao")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function ZhiQiGuanJingGuanXiYeKey()
{
	var elementObj=document.getElementById("ZhiQiGuanJingGuanXiYe").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="ZhiQiGuanJingGuanXiYe")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		bitian=true
		QJXSJBiTian(bitian)
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		bitian=false
		QJXSJBiTian(bitian)
		specimen=false
	}
	DisableChuanCiBuWei()
}
function ShiGuanJingShuaPianKey()
{
	var elementObj=document.getElementById("ShiGuanJingShuaPian").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="ShiGuanJingShuaPian")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		bitian=true
		QJXSJBiTian(bitian)
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		bitian=false
		QJXSJBiTian(bitian)
		specimen=false
	}
	DisableChuanCiBuWei()
}
function JieChangJingShuaPianKey()
{
	var elementObj=document.getElementById("JieChangJingShuaPian").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="JieChangJingShuaPian")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		bitian=true
		QJXSJBiTian(bitian)
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		bitian=false
		QJXSJBiTian(bitian)
		specimen=false
	}
	DisableChuanCiBuWei()
}
function PenQiangChongXiYeKey()
{
	var elementObj=document.getElementById("PenQiangChongXiYe").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="PenQiangChongXiYe")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function FuQiangChongXiYeKey()
{
	var elementObj=document.getElementById("FuQiangChongXiYe").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="FuQiangChongXiYe")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function FuPenQiangChongXiYeKey()
{
	var elementObj=document.getElementById("FuPenQiangChongXiYe").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="FuPenQiangChongXiYe")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
/*
function MianYiXiBaoHuaXueKey()
{
	var elementObj=document.getElementById("MianYiXiBaoHuaXue").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="MianYiXiBaoHuaXue")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
*/
function OtherTLCellKey()
{
	var elementObj=document.getElementById("OtherTLCell").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="OtherTLCell")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value="1"
		document.getElementById("TLCellNum").style.display ="";
		specimen=true
	}else
	{
		document.getElementById("TLCellNum").value=""
		document.getElementById("TLCellNum").style.display ="none";
		document.getElementById("TLCell").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
function TBNAKey()
{
	var elementObj=document.getElementById("TBNA").checked
	DisableChuanCiBuWei()
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="TBNA")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		bitian=true
		QJXSJBiTian(bitian)
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		
		bitian=false
		QJXSJBiTian(bitian)
		specimen=false
	}
}
function EBUSKey()
{
	var elementObj=document.getElementById("EBUS").checked
	DisableChuanCiBuWei()
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="EBUS")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		bitian=true
		QJXSJBiTian(bitian)
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		
		bitian=false
		QJXSJBiTian(bitian)
		specimen=false
	}
}
function CTChuanCiKey()
{
	var elementObj=document.getElementById("CTChuanCi").checked
	DisableChuanCiBuWei()
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="CTChuanCi")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		
		specimen=false
	}
	bitian=false
	QJXSJBiTian(bitian)
}
function ChaoShengChuanCiKey()
{
	var elementObj=document.getElementById("ChaoShengChuanCi").checked
	DisableChuanCiBuWei()
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="ChaoShengChuanCi")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		
		specimen=false
	}
	bitian=false
	QJXSJBiTian(bitian)
}
function ChuanCiWuKey()
{
	var elementObj=document.getElementById("ChuanCiWu").checked
	DisableChuanCiBuWei()
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="ChuanCiWu")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		specimen=false

	}
	bitian=false
	QJXSJBiTian(bitian)
}
/*
function HuiZhenKey()
{
	var elementObj=document.getElementById("HuiZhen").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="HuiZhen")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value=""
		document.getElementById("TLCellNum").value=""
		document.getElementById("ZXCellNum").style.display ="none";
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		specimen=false
	}
	DisableChuanCiBuWei()
	bitian=false
	QJXSJBiTian(bitian)
}
*/
function OtherZXCellKey()
{
	var elementObj=document.getElementById("OtherZXCell").checked
	DisableChuanCiBuWei()
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="OtherZXCell")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		specimen=false
	}
	bitian=false
	QJXSJBiTian(bitian)
}
function RuYiKey()
{
	var elementObj=document.getElementById("RuYi").checked
	if(elementObj)
	{
		for (var j=0;j<document.all.length;j++)
	  {
		  if ((document.all(j).type=="checkbox"))
		  {
			   	var myname=document.all(j).name;
			   	if((myname!="RuYi")&&(myname!="RadioCure")&&(myname!="ChemicalCure")&&(myname!="bLiuCell")&&(myname!="bOther")&&(myname!="Transfer"))
			    {
				   	document.getElementById(myname).checked=false
			    }               
			}
		}	
		document.getElementById("TLCell").style.display ="none";
		document.getElementById("TLCellNum").style.display ="none";
		//document.getElementById("HuiZhenBiaoBen").style.display ="none";
		document.getElementById("ZXCellNum").style.display ="";
		document.getElementById("TLCell").value=""
		//document.getElementById("HuiZhenBiaoBen").value=""
		document.getElementById("ZXCellNum").value="1"
		document.getElementById("TLCellNum").value=""
		document.getElementById("ChuanCiBuWei1").style.display ="";
		document.getElementById("ChuanCiBuWei1").value=""
		specimen=true
	}else
	{
		document.getElementById("ZXCellNum").style.display ="none";
		document.getElementById("ZXCellNum").value=""
		DisableChuanCiBuWei()
		specimen=false
	}
	bitian=false
	QJXSJBiTian(bitian)
}

function DisableChuanCiBuWei()
{
	document.getElementById("ChuanCiBuWei1").style.display ="none";
  document.getElementById("ChuanCiBuWei2").style.display ="none";
  document.getElementById("ChuanCiBuWei3").style.display ="none";
  document.getElementById("ChuanCiBuWei4").style.display ="none";
  document.getElementById("ChuanCiBuWei5").style.display ="none";
  document.getElementById("ChuanCiBuWei6").style.display ="none";
  document.getElementById("ChuanCiBuWei7").style.display ="none";
  document.getElementById("ChuanCiBuWei8").style.display ="none";
  document.getElementById("ChuanCiBuWei9").style.display ="none";	
}

function QJXSJBiTian(bool)
{
	var qjxsj=document.getElementById("cQiangJingXiaSuoJian")		
	if(bool)
	{
		qjxsj.outerHTML="<label id='cQiangJingXiaSuoJian' CLASS='clsRequired'>"+t['QiangJingXiaSuoJian']+"</label>"
	}else
	{
		qjxsj.outerHTML="<label id='cQiangJingXiaSuoJian' >"+t['QiangJingXiaSuoJian']+"</label>"
	}
}

function SpeNumKey(SpeNum)
{
	var SpeNum1=document.getElementById(SpeNum)
	var SpeNum2=SpeNum1.value
	if(isNaN(SpeNum2)||(SpeNum2.match(/^[0-9]+$/)==null)||(SpeNum2>"9")||(SpeNum2<="0"))
	{
		alert(t['IsNaN'])
		SpeNum1.value=""
		SpeNum1.focus()	
		return false
	}	
	return true
}

function ZXCellNumKey()
{
	if(SpeNumKey("ZXCellNum"))
	{
		DisableChuanCiBuWei()
		var ZXCellNum=document.getElementById("ZXCellNum").value
		for(var i=1;i<=ZXCellNum;i++)
		{
			document.getElementById("ChuanCiBuWei"+i).style.display=""
		}
	}
}
function TLCellNumKey()
{
	SpeNumKey("TLCellNum")
}
document.body.onload = BodyLoadHandler