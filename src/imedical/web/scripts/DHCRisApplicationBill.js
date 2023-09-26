//DHCRisApplicationBill.js
var gPrintTemp; 
var gHtmlTemp="";
var gPostureTemp="";
var gBodyPartTemp="";
var nBodyList="";
var nPostureList="";
var list1=new Array();
var list2=new Array();
var list3=new Array();
var ListInfo="";ListInfo="";ListInfo1=""; 
var gOtherBodyParts="N";
var gAppCount="";
var gUserID="";
var gSelCount="";
var gBookTempalte="";
var gLocStartBK="";
var gUseKnowledge="";

var $=function(Id){
	return document.getElementById(Id);
}

function BodyLoadHandler()
{	//alert("Load")
    //window.open("","_top").close();
    //window.close();
    //if selected more orditem ,use first order rowid as master order
    //alert("Strat----")
    //alert("gLocStartBK="+gLocStartBK)
    
    gUserID=session["LOGON.USERID"];
    var OEorditemID=document.getElementById("OEorditemID").value;
    var orditem=OEorditemID.split("@");
    var FirstOrderItem=orditem[0];

    GetPrintTemp(FirstOrderItem); 
    
    GetLocPrintTemplate();
    
    GetLocAutoBK();
    var EpisodeID=document.getElementById("EpisodeID").value;
    //alert(EpisodeID);
 
    var HopeDateObj=document.getElementById("HopeDate");
    if (HopeDateObj.value=="")
    	HopeDateObj.value=DateDemo(); 
    
    
    var SaveStatusobj=document.getElementById("SaveStatus");
	if (SaveStatusobj)
	{
	 	SaveStatusobj.onclick=SaveStatusClick;
	}
    var SaveGlobalObj=document.getElementById("SaveGlobal");
	if (SaveGlobalObj)
	{
		SaveGlobalObj.onclick=SaveGlobalClick;
	}
  	var todayObj=document.getElementById("today");
	if (todayObj)
	{
		todayObj.onclick=todayclick;
	}
   
	var btnsendobj=document.getElementById("SentBiil");
	if (btnsendobj)
	{
		btnsendobj.onclick=sendclick;
	}
	var btnprintobj=document.getElementById("PrintBill");
	if (btnprintobj)
	{
	   btnprintobj.onclick=printClick;
	}
	
	var Cancelobj=document.getElementById("CancelSend");
	if (Cancelobj)
	{
	   Cancelobj.onclick=CancelClick;
	}
	
	var Tempobj=document.getElementById("Template");
	if (Tempobj)
	{
	   Tempobj.onclick=TempClick;
	}
    var Toothobj=document.getElementById("tooth");
	if (Toothobj)
	{
	   Toothobj.onclick=ToothClick;
	}

	var Saveobj=document.getElementById("Save");
	if (Saveobj)
	{
	   Saveobj.onclick=SaveClick;
	}
	
	 var BodyListObj=document.getElementById('BodyList')
	 if (BodyListObj)
	 {
	    BodyListObj.ondblclick=SelectBodyPartClick;
	 }
	 
	 var PostureListObj=document.getElementById('PostureList')
	 if (PostureListObj)
	 {
	    PostureListObj.ondblclick=SelectPostureListClick;
	 }

    
	///////////////////////////////////////////////////////////
    ret=LoadXMLData(OEorditemID) ///  append line 
    //alert(ret);
    //////////////////////////////////////////////////////////
    var GetPaadmInfoFun=document.getElementById("GetAdmInfo").value;
  	var value=cspRunServerMethod(GetPaadmInfoFun,EpisodeID)
  	
    if (value!="")
	{   
		var item=value.split("^");
		document.getElementById("RegNo").value=item[0];
		document.getElementById("Name").value=item[1];
		document.getElementById("DOB").value=item[2];
		document.getElementById("Age").value=item[3];
		document.getElementById("Sex").value=item[4];
		document.getElementById("Ward").value=item[9];
		document.getElementById("BedNo").value=item[10];
		$("InsuranceType").value=item[15];
		document.getElementById("PHeight").value=item[19];
		document.getElementById("PWeight").value=item[20];
		document.getElementById("InPatientNo").value=item[8];
		document.getElementById("TelNo").value=item[18];
		document.getElementById("address").value=item[21];
		document.getElementById("InLoc").value=item[7];
		document.getElementById("AppDoc").value=item[17]; //session['LOGON.USERNAME'];
		document.getElementById("MedicareNo").value=item[32];
		document.getElementById("InsuranceNo").value=item[33];
		document.getElementById("CardNo").value=item[34];
		document.getElementById("Epissubtype").value=item[40];
		document.getElementById("EncryptLevel").value=item[43];
		document.getElementById("PatLevel").value=item[44];
		gUseKnowledge=item[45];
		
	}
    
     //加载部位列表
    GetBodyPartList(OEorditemID);
    //加载体位列表
    GetPostureList(OEorditemID);
    
  
    if (ret==0)     //It doesn't write application bill
	{
		//get default application information
		var GetOrdItemInfoFun=document.getElementById("GetOrdItemInfo").value;
		
  		var OeordInfo=FirstOrderItem.split("||");
  		var value=cspRunServerMethod(GetOrdItemInfoFun,OeordInfo[0],OeordInfo[1]);
  		
     	if (value!="")
		{   
			var item=value.split("^");
			document.getElementById("AppDate").value=item[1];
			document.getElementById("RecLoc").value=item[20];
			document.getElementById("HisBodyPart").value=item[33];
			
			if(item[34]=="Y")
			    document.getElementById("ungent").checked=true;
			    
    		//document.getElementById("price").value=item[11];
		}
		
		//get patient Item TotalPrice
		document.getElementById("price").value=GetTotalPrice(OEorditemID);
		
		// get patient main diagonse 
	    var GetMainDiagoseFunction=document.getElementById("GetMainDiagose").value;
  	    var value=cspRunServerMethod(GetMainDiagoseFunction,EpisodeID);
    	document.getElementById("MainDiagose").value=value;
    	
        // get patient default current status 
        var GetCurrentStatusFunction=document.getElementById("GetCurrentStatusFunction").value;
        var value=cspRunServerMethod(GetCurrentStatusFunction,EpisodeID)
    	    value=value.replace(/^[\r\n\s]+/,"");	
    	document.getElementById("PatientNow").value=value;
    	
    	// get exam default gloal 
    	//alert("00000")
        var Info1=GetBlobal(OEorditemID);
        document.getElementById("purpose").value=Info1;
    	/*var ExclusionFlag=GetExclusionFlag(OEorditemID);
    	document.getElementById("ExclusionFlag").value=ExclusionFlag;*/
    	//插入默认部位
    	InsertBodyPart();

    }
    
     var GetMainDiagoseFunction=document.getElementById("GetMainDiagose").value;
  	 var value=cspRunServerMethod(GetMainDiagoseFunction,EpisodeID);
     document.getElementById("MainDiagose").value=value;
            
    
    //DHCP_GetXMLConfig("XMLObject","DHCRisApplicationBillCT");
    var Info=GetOrdName(OEorditemID);
    document.getElementById("OrdName").value=Info;
    
    //SelectBlobal
    var SelectBlobalobj=document.getElementById("SelectBlobal");
	if (SelectBlobalobj)
	{
	   SelectBlobalobj.onclick=SelectBlobalClick;
	}

    
    var SelBodyListObj=document.getElementById('SelBodyPart'); 
    if (SelBodyListObj)
    {
	    SelBodyListObj.ondblclick=SelBodyPartDBLClick;
    }

    var AllSelectObj=document.getElementById('AllSelect'); 
    if (AllSelectObj)
    {
	    AllSelectObj.onclick=AllSelectClick;
    }

    var AllDeleteObj=document.getElementById('AllDelete1'); 
    if (AllDeleteObj)
    {
	    AllDeleteObj.onclick=AllDeleteClick;
    }
    var SelPostureListObj=document.getElementById('SelPostureList'); 
    if (SelPostureListObj)
    {
	    SelPostureListObj.ondblclick=SelPostureDBLClick;
    }
  
    //根据选定的"其他部位"来设置 其他部位框是否可用
    GetOtherBodyPartFalg(OEorditemID);
    
    var value=DisplayRevelation(OEorditemID)
    if(value=="Y")
    {
	   document.getElementById("cDisplayInfo").style.display='';
	}
	else
	{
	   document.getElementById("cDisplayInfo").style.display='none';
	}
	//得到未发送申请的医嘱数量
	//alert("1")
	GetAppCount();
	//closeWindow();
	//得到选中医嘱的数量
	//alert("1-1")
	GetSelCount(OEorditemID);
	//alert("2");
	StaticButton();
 }

 function GetBlobal(OEorditemID)
 {
	 var orditem=OEorditemID.split("@");
     var len=orditem.length;
     var Info=""
  
	 for (i=0;i<len;i++)
	 {    	
	       var GetGlobalFunction=document.getElementById("GetGlobalFunction").value;
		   var value=cspRunServerMethod(GetGlobalFunction,orditem[i])
	          
		   if (Info=="")
		   {
			  Info=value;
		   }
		   else
		   {
		      Info=Info+"\r\n"+value;
		   }
	 }
	 
	  Info=Info+"  总计:"+document.getElementById("price").value
	  return Info;
 }
 
 function GetOrdName(OEorditemID)
 {
     var GetOrdNameFunction=document.getElementById("GetOrdNameFunction").value;
  	 var value=cspRunServerMethod(GetOrdNameFunction,OEorditemID)
  	 return value;
 }
 
 
 function GetPrintTemp(OEorditemID)
 {
	var GetPrintTempFun=document.getElementById("GetAppPrintTemp").value;
  	var value=cspRunServerMethod(GetPrintTempFun,OEorditemID)
  	var Item=value.split("^");
   	if (Item[1]!="")
  	{
	   gPrintTemp=Item[1];
	   gHtmlTemp=Item[3];
  	   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemp);
  	   //DHCP_GetXMLConfig("XMLObject",gPrintTemp);
  	   //alert(gPrintTemp);
  	}
  	
 }
 
 //Cancel Click 
 function CancelClick()
 {
	 var Ans=confirm(t['DeleteSend'])
	 if (Ans==false)
	 {
		 return;
     }
     
     var objtbl=document.getElementById('tDHCRisApplicationBill');
	 var rows=objtbl.rows.length;
	 
	 for (i=1;i<rows;i++)
	 {
		 var FileldDR=document.getElementById("FieldDRz"+i).value;
		 var EpisodeID=document.getElementById("EpisodeIDz"+i).value;
		 var Option=document.getElementById("Optionz"+i).value;
		 
		 if (Option=="default")
		 {
			 var DelFunction=document.getElementById("DelSaveAppFiledFun").value;
			 var ret=cspRunServerMethod(DelFunction,EpisodeID,FileldDR);
		 }
	 }
	
	
	 var OEorditemID=document.getElementById("OEorditemID").value;
     var CancelSendFunction=document.getElementById("CancelSendFunction").value;
     var value=cspRunServerMethod(CancelSendFunction,OEorditemID)
     if (value=="100")
     {
	     alert(t["StatusNotCorrect"]);
	 }
     else if (value=="0")
     {
	     alert(t["DeleteSucessFul"]);
  
     }
     else
     {
	     alert(t["DeleteFailure"]+"SQLCODE:"+value);
     }
     Refresh();
    
 }
 
 
 
 function sendclick()
 {
	/*var objtbl=document.getElementById('tDHCRisApplicationBill');
	var ItemName=document.getElementById("Fieldz1").innerText;
	var myname="Content_1";
	var Value=DHCWebD_GetObjValue(myname);
	if (ItemName=="标本取材部位(必填)")
	{
		if (Value=="")
		{
			alert("标本取材部位(必填)");
			return ;
		}
		
	}
	*/
 
     var objtbl=document.getElementById('tDHCRisApplicationBill');
 	//alert(objtbl);
	var rows=objtbl.rows.length;
	//alert(rows);
	var hint="";
	for (var i=1; i<rows; i++)
    {
	     var fieldValue=document.getElementById("Fieldz"+i).innerText;
	     //alert(field);
	     //alert(document.getElementById("Requirez"+i).value);
	     if ( document.getElementById("Requirez"+i).value=="1")
	     {
			var myname="Content_"+i;
			var Value=DHCWebD_GetObjValue(myname);
			//Value=CTrimApp(Value);
		    if (Value=="")
		    {
			    if (hint=="")
			    {
				    hint="项目["+fieldValue;
			    }
			    else
			    {
				    hint=hint+" ,"+fieldValue;
			    }
			    
			    
		    }
	     }
    }
    //alert(hint);
    
    if (hint!="")
    {
		alert(hint+"],必须填写!");
		return;
    }
    //SendXMLString(SendXMLFunctionOBJ,OeorditemID,XDate,UserID)
	var OEorditemID=document.getElementById("OEorditemID").value;
	var orditem=OEorditemID.split("@");
    var FirstOrderItem=orditem[0];
    
    //得到选中部位
	gBodyPartTemp=GetSelBodyPartInfo();
    ///调用知识库判断
    if (gUseKnowledge=="Y")
    {
	    var KnowledgeParam=tkMakeServerCall("web.DHCRisApplicationBill","GetKnowledgeItemBodyPart",OEorditemID,gBodyPartTemp);
	    var UserInfo=session["LOGON.USERID"]+"^"+session["LOGON.USERCODE"]+"^"+session['LOGON.GROUPID'];
	    var EpisodeID=document.getElementById("EpisodeID").value;
	    var Input=EpisodeID+"!!"+KnowledgeParam
	   
	    var KnowledgeFun=document.getElementById("KnowledgeInfo").value;
	    var Knowledge=cspRunServerMethod(KnowledgeFun,"C",Input,UserInfo) 
	    
	    var Verification="",Control="",Memo="";
	    if (Knowledge!="") 
	    {
		    var KnowledgeArray=Knowledge.split("^");
		    Verification=KnowledgeArray[0]
		    Control=KnowledgeArray[1];	  
		    Memo=KnowledgeArray[2];  
		    //alert(Memo);
		}
	    
	    if (Verification=="0")
	    {
		    if (Control=="0")
		    {
			     ConFlag=confirm('提示! '+Memo);
		         if (ConFlag==false){return;}	
			    
			}else if (Control=="1")
			{
				alert("知识库验证不通过\r\n\r\n" + Memo +"\r\n\r\n不能发送申请单.");
				return ;
			}
		}
    }
    
	/*var IsSendApp=IsSendAppFlag(OEorditemID);
	if(IsSendApp=="N")
	{
		alert("医嘱状态不对不能发送申请单!");
		return;
	}*/
	
	//判断删除拒绝申请信息
	var value=IsRejectApp(OEorditemID);
	if(value!="0")
	{
		alert("删除拒绝信息失败!");
		return;
	}
	
	//判断体位部位不全为空
	var IsSel=IsSelList();
    if(IsSel=="N")
    {
	    alert("请选择体位或部位列表!");
	    SetStyle('PostureList');
	    SetStyle('BodyList');
	    return;
	}
	
	var OtherBodyP=document.getElementById("OtherBodyPart").value;    
	if((gOtherBodyParts=="Y")&(OtherBodyP==""))
	{
		alert("请填写其他部位后发送申请单!");
		SetStyle('OtherBodyPart');
		return;
    }   
	
	var XDate=document.getElementById("HopeDate").value;
	var UserID=session["LOGON.USERID"];

    var Info1=GetBlobal(OEorditemID);
    //alert(Info1);
   	var Info2=document.getElementById("purpose").value;
   	//alert(Info2)
   	/*if (Info1!=Info2)
   	{
	  var Ans=confirm(t['IsSend'])
	  if (Ans==false)
	  {
		 return;
      }
   	}*/

   
    var EpisodeID=document.getElementById("EpisodeID").value;
    var StatusDesc=document.getElementById("PatientNow").value;
        StatusDesc=cTrim(StatusDesc,0)
    
    var MainDiagose=document.getElementById("MainDiagose").value;
        MainDiagose=cTrim(MainDiagose,0)    
    
    if (StatusDesc=="")
    {
       //alert(t['NOTNULL']);
       alert("【病史及临床所见】不能为空");
       SetStyle('PatientNow');
       return;
    }
    
    if (MainDiagose=="")
    {
	    alert("【临床诊断】不能为空");
       //alert(t['NOTNULL']);
       SetStyle('MainDiagose');
       return;
    }
  
    //SetPatNow(FirstOrderItem);
    var StatusDescL=Replace(StatusDesc);
    var len=strlen(StatusDescL);
    //alert(len);
    
    if(len>3214)
    {
	    alert("病史及临床所见超长不能发送申请单!");
	    return;
	}
	
    /*if (len<20)
    {
       alert("病史及临床所见最少输入10个汉字!");
       SetStyle('PatientNow')
       return;
    }*/
    
    var SaveFun=document.getElementById("SaveStatusFunction").value;
    var ret=cspRunServerMethod(SaveFun,FirstOrderItem,EpisodeID,StatusDesc) //StatusDesc
  
    if (ret=="0")
    {
      //alert(t['SaveSuccess']);
    }
    else
    {
      
       alert(t['SaveFailure']);
    }
	
	
	//得到选中部位
	//gBodyPartTemp=GetSelBodyPartInfo();
	
	//得到选中体位
	gPostureTemp=GetSelPostureInfo();

	//设置平台信息
	SetAppInfo(OEorditemID);
	
	var AppItemNameObj=document.getElementById("AppItemName");
	if (AppItemNameObj)
	{
		AppItemNameObj.value=GetAppItemNmae(OEorditemID);
	}
	
	///////////////////////////////////////////////////////////////
	//GetPrintNo();
	var PrintParam=GetPrintParam();
	
	var ret=SendXMLString(OEorditemID,XDate,UserID,gHtmlTemp,PrintParam);////append line
	
	/*
	//界面选择预约，老版申请单不支持
	var IsBook=""
	if (ret=="0")
	{
		var IsBookedFun=document.getElementById("IsBooked").value;
		//是否预约
	    IsBook=cspRunServerMethod(IsBookedFun,OEorditemID) ;
	}
    
    
	var retBooked=1;
	if ((gLocStartBK=="Y")&&(ret=="0")&&(IsBook=="N"))
	{
		 retBooked=GetAutoBookedInfo(OEorditemID,UserID);
	}
	*/
	if (ret=="0")
	{
		alert(t['SendSuccess']);
		printApplicationbill(PrintParam);
		//alert(retBooked);
		/*
		if (retBooked==0)
		{
			//alert("PRINT-BK")
			OnPrint(OEorditemID);
		}	
		*/	
		//refresh orditem status 
		Refresh();
		/*var SetCount=0;
		if (gAppCount>0)
		{
			SetCount=SetAppCount();
		}
		if(SetCount==0)
		{
		   window.open("","_top").close();
		}*/
	    
	}
	else
	{
		alert(t['SendFailure']);
	}
	//////////////////////////////////////////////////////////
 }
 
 function Refresh()
 {
	 	var Eposide=document.getElementById("EpisodeID").value;
	    var ComponentName=document.getElementById("ComponentName").value;  //"DHCRisApplicationBill"
        var AppRowID=document.getElementById("AppRowID").value;
        var RecLocDR=document.getElementById("RecLocDR").value;
        var AppOrdListDoc=parent.frames["RisOrdItemList"].document;
        //var Selectid=AppOrdListDoc.getElementById("SelectedID").value;
        var OEorditemID=document.getElementById("OEorditemID").value;
        
        var lnk="dhcrisappbill.csp?"+"&EpisodeID="+Eposide
        //var lnk="dhcrisappbill.csp?WEBSYS.TCOMPONENT="+ComponentName+"&EpisodeID="+Eposide+"&OEorditemID="+OEorditemID+"&RecLocDR="+RecLocDR+"&AppRowID="+AppRowID+"&ComponentName="+ComponentName;
        parent.location.href=lnk; 

	 
 }
 
 function SaveStatusClick()
 {
 	  //SaveCurrentStatus(Oeorditemrowid,paadmdr,CurrentStatus)
	  var OEorditemID=document.getElementById("OEorditemID").value;
      var EpisodeID=document.getElementById("EpisodeID").value;
      var StatusDesc=document.getElementById("PatientNow").value;
          StatusDesc=cTrim(StatusDesc,0)
    
      if (StatusDesc=="")
      {
         alert(t['NOTNULL']);
         SetStyle('PatientNow');
         return;
      }
      var SaveFun=document.getElementById("SaveStatusFunction").value;
      var ret=cspRunServerMethod(SaveFun,OEorditemID,EpisodeID,StatusDesc)
      if (ret=="0")
      {
	      //alert(t['SaveSuccess']);
	  }
      else
      {
	      
	      alert(t['SaveFailure']);
      }
          
      //Save Status Template 
      var Desc=document.getElementById("MainDiagose").value;
  	  var SaveFun=document.getElementById("SaveStatusTemplate").value;
  	  var Status="Status";
  	  var CTLOCID=session['LOGON.CTLOCID'];
  	 
      var UserID=session['LOGON.USERID'];
  	  if (document.getElementById("PerTempl").checked)
  	  {
	  	  var UserID="";
  	  }
  	 
  	  var FieldTag="Status"
  	  
  	  //(Desc,Content,UsrID,LocID,FieldTag)
  	  var ret=cspRunServerMethod(SaveFun,Desc,StatusDesc,UserID,CTLOCID,FieldTag)
      if (ret=="0")
      {
	      alert(t['SaveSuccess']);
	  }
      else
      {
	      
	      alert(t['SaveFailure']);
      }
	 
 }
 
 
 function todayclick()
 {
	 var HopeDateObj=document.getElementById("HopeDate");
     HopeDateObj.value=DateDemo(); 
 }
 function printClick()
 {
	  ////////////////////////////////////////
	var PrintParam=GetPrintParam(); ////appline
    printApplicationbill(PrintParam);
    //CommonPrint(gPrintTemp);   
 }
 
 function printApplicationbill(PrintParam)
 {
	   // InvPrintNew(PrintParam,"");
	var oeorowid=document.getElementById("OEorditemID").value;
	var secretDesc=document.getElementById("EncryptLevel").value;
	var InvokeLog=document.getElementById("InvokeHISLog").value;
	var ret=cspRunServerMethod(InvokeLog,"",oeorowid,secretDesc)
	InvPrintNew(PrintParam,"");
 
 }
 
  
 function InvPrintNew(TxtInfo,ListInfo)
 {
	var myobj=document.getElementById("ClsBillPrint");
 	var OEorditemIDvalue=document.getElementById("OEorditemID").value;
 	
	/*if (gPrintTemp=="DHCRisBill_BwUltrasonic")
	{
	    var list="";
 	    for (var j=0;j<document.all.length;j++)
 	    {
 	    	if (document.all(j).type=="checkbox")
		    {
		       	var myname=document.all(j).name;
		       	var myval=DHCWebD_GetObjValue(myname);
		        if (myval==true)
		   	    {
			    	n=myname.split("_")[1];
			    	list=list+(document.getElementById('Fieldz'+n).innerText)+"^";
		   	    } 
		     }
		 }
 		 var saveUltrasonic=document.getElementById('saveUltrasonic');
	     if (saveUltrasonic)
	     {
		     var encmeth=saveUltrasonic.value;
		 }
		 else 
		 {
		     var encmeth=''
		 };
	     cspRunServerMethod(encmeth,OEorditemIDvalue,list);
 	     var flag=0;list1[0]="";list1[1]="";list1[2]="";list1[3]=""
 	     for(i=0;i<list.split("^").length;i++)
 	     {
	 	    	list1[flag]=list.split("^")[i];
	 	    	flag=flag+1;
	 	    	if(flag==4){ListInfo=ListInfo+String.fromCharCode(2)+list1[0]+"^"+list1[1]+"^"+list1[2]+"^"+list1[3];
	 	    	flag=0;
	 	    	list1[0]="";list1[1]="";list1[2]="";list1[3]="";
	 	  }
	 	    	
	 	}
	 	if (list1[0]!="")
	 	{
		 	ListInfo=ListInfo+String.fromCharCode(2)+list1[0]+"^"+list1[1]+"^"+list1[2]+"^"+list1[3]
		}
 	 }
 	 if (gPrintTemp=="DHCRisBill_CT")
 	 {
 	 	var list="";str="Content";num=0;list1="";
 	    for (var j=0;j<document.all.length;j++)
 	    {
 	       if (document.all(j).type=="text")
 	       {
 	    	   var myname=document.all(j).name;
 	    	   if(myname.search(str)==0)
 	    	   {
	 	    	   var num=myname.split("_")[1]
	 	       };
 	    	 	   
 	    	 }
 	     }
 	     for (var j=0;j<document.all.length;j++)
 	     {
 	        if (document.all(j).type=="checkbox")
		    {
		       	var myname=document.all(j).name;
		        var myval=DHCWebD_GetObjValue(myname);
		        if (myval==true)
		   	    {
			    	
			    	n=myname.split("_")[1];
			     	if(parseInt(n)< parseInt(num)){list=list+(document.getElementById('Fieldz'+n).innerText)+"^";}
			    	if(parseInt(n)> parseInt(num)){list1=list1+(document.getElementById('Fieldz'+n).innerText)+"^";}
     	   	    }
     	    }
 	      }	
 	      var savect=document.getElementById('savect');
	      if (savect) {var encmeth=savect.value;} else {var encmeth=''};
	      cspRunServerMethod(encmeth,OEorditemIDvalue,list1);
	      
 	    	var flag=0;list2[0]="";list2[1]="";list2[2]="";list2[3]=""
 	    	for(i=0;i<list1.split("^").length;i++){
	 	    	list2[flag]=list1.split("^")[i];
	 	    	flag=flag+1;
	 	    	if(flag==4){ListInfo=ListInfo+String.fromCharCode(2)+list2[0]+"^"+list2[1]+"^"+list2[2]+"^"+list2[3];
	 	    	flag=0;
	 	    	list2[0]="";list2[1]="";list2[2]="";list2[3]="";
	 	    	}
	 	    	
	 	   }
	 	   if (list2[0]!=""){ListInfo=ListInfo+String.fromCharCode(2)+list2[0]+"^"+list2[1]+"^"+list2[2]+"^"+list2[3]};
	 	   
	 	   /*var flag=0;list3[0]="";list3[1]="";list3[2]="";list3[3]=""
 	    	for(i=0;i<list1.split("^").length;i++){
	 	    	list3[flag]=list1.split("^")[i];
	 	    	flag=flag+1;
	 	    	if(flag==4){ListInfo1=ListInfo1+String.fromCharCode(2)+list3[0]+"^"+list3[1]+"^"+list3[2]+"^"+list3[3];
	 	    	flag=0;
	 	    	list3[0]="";list3[1]="";list3[2]="";list3[3]="";
	 	    	}
	 	    	
	 	   }
	 	   if (list3[0]!=""){ListInfo1=ListInfo1+String.fromCharCode(2)+list3[0]+"^"+list3[1]+"^"+list3[2]+"^"+list3[3]}*/
 	 	//}
 	 	

	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	//call xml print from zhaochangzhong
 } 

 function SaveGlobalClick()
 {
	 // SaveGlobal(Oeorditemrowid, GlobalDesc)
	  var OEorditemID=document.getElementById("OEorditemID").value;
      //var EpisodeID=document.getElementById("EpisodeID").value;
      var GlobalDesc=document.getElementById("purpose").value;
          GlobalDesc=cTrim(GlobalDesc,0)
          
      if (GlobalDesc=="")
      {
	      alert(t['NOTNULL']);
	      SetStyle('purpose');
	      return;
      }
      var SaveFun=document.getElementById("SaveGlobalFunction").value;
      var ret=cspRunServerMethod(SaveFun,OEorditemID,GlobalDesc)
      if (ret=="0")
      {
	      alert(t['SaveSuccess']);
	     
	  }
      else
      {
	      alert(t['SaveFailure']);
	  }
	 
 }

function DateDemo()
{
   var d, s="";          
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;	
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear();	
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
}
function TempClick()
{
    var locid=session['LOGON.CTLOCID'];
    var UserID=session['LOGON.USERID'];
    //var UserID=""
    
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppTemplList"+"&UserID="+UserID+"&LocID="+locid+"&FieldTag=Status";    
    var mynewlink=open(link,"DHCRisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=200,width=500,height=600");

}
function SaveClick()
{
	var OEorditemID=document.getElementById("OEorditemID").value;
	var XDate=document.getElementById("HopeDate").value;
	var UserID=session["LOGON.USERID"];
	
	
    var Info1=GetBlobal(OEorditemID);
   	var Info2=document.getElementById("purpose").value;
   	if (Info1!=Info2)
   	{
	  var Ans=confirm(t['IsSend'])
	  if (Ans==false)
	  {
		 SetStyle('purpose'); 
		 return;
      }
   	}
    // SaveCurrentStatus(Oeorditemrowid,paadmdr,CurrentStatus)
	var EpisodeID=document.getElementById("EpisodeID").value;
    var StatusDesc=document.getElementById("PatientNow").value;
        StatusDesc=StatusDesc.replace(/^[\r\n\s]+/,"");
        StatusDesc=cTrim(StatusDesc,0)
        
    var MainDiagose=$("MainDiagose").value;
        MainDiagose=cTrim(MainDiagose,0)
        
    if (StatusDesc=="")
    {
       alert(t['NOTNULL']);
       SetStyle('PatientNow');
       return;
    }    
    
    if (MainDiagose=="")
    {
       alert(t['NOTNULL']);
       SetStyle('MainDiagose');
       return;
    }
               
    /*var StatusDescL=Replace(StatusDesc);
    var len=strlen(StatusDescL);
    
    if (StatusDesc=="")
    {
	    alert(t['NOTNULL']);
	    return;
    }
    
    if(len<20)
    {
	     alert("病史及临床所见最少输入10个汉字!");
	     return;
	}*/
     
      
    var SaveFun=document.getElementById("SaveStatusFunction").value;
    var ret=cspRunServerMethod(SaveFun,"",EpisodeID,StatusDesc)
    if (ret=="0")
    {
	    //alert(t['SaveSuccess']);
	}
    else
    {
	    alert(t['SaveFailure']);
    }
	///////////////////////////////////////////////////////////////
	var PrintParam=GetPrintParam(); ////appline
	var ret=SendXMLString(OEorditemID,XDate,UserID,gHtmlTemp,PrintParam);////append line
	if (ret=="0")
	{
		alert(t['SaveSuccess']);
		//SaveHtmlFile(OEorditemID);
		//Refresh();
	    
	}
	else
	{
		alert(t['SaveFailure']);
	}
	
	
}

function PrintFun(PObj,inpara,inlist){
	
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;   
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
				
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
		
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function SelectBlobalClick()
{
    var OEorditemID=document.getElementById("OEorditemID").value;
    var orditem=OEorditemID.split("@");
    var FirstOrderItem=orditem[0];

    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppBillSelGlobal"+"&OEorditemID="+FirstOrderItem;   
    var mynewlink=open(link,"DHCRisAppBillGlobal","scrollbars=yes,resizable=yes,top=100,left=100,width=1000,height=700");

}


function GetBodyPartList(OEorditemID)
{
     var BodyPartListInfo=""
	 var BodyListObjFunction=document.getElementById('GetBodyPartList').value; 
	 var BodyListObj=document.getElementById('BodyList')
     
     for (i=BodyListObj.length-1;i>=0;i--)
     {
	    BodyListObj.remove(0);
	 }
	 
	 var BodyPartListInfo=cspRunServerMethod(BodyListObjFunction,OEorditemID);
	
	 if (BodyPartListInfo!="")
	 {
	    	var BodyPartList=BodyPartListInfo.split("@");
     		var Nums=BodyPartList.length;
     	
     	   	for (j=0;j<Nums;j++)
			{
				var Index=BodyListObj.options.length;
				var BodyInfo=BodyPartList[j].split("-");
				var objSelected = new Option(BodyInfo[1],BodyInfo[0]);
				BodyListObj.options[Index]=objSelected;
			}
			
			nBodyList="1" 
	 }
	 
	 
 }
 
 
 /*function SelectBodyPartClick()
 {
	 var ExclusionFlag=document.getElementById('ExclusionFlag').value; 
	 
	 if(ExclusionFlag=="Y")
	 {
		 SelSingleBodyPartClick()
	 }
	 else
	 {
		 SelMultipleBodyPartClick();
	 }
	 
 }*/
 
 
 function SelectBodyPartClick()
 {
	//alert("SelectBodyPartClick");
	var SelBodyInfo;
	
	var BodyListObj=document.getElementById('BodyList'); 
	var nIndex=BodyListObj.selectedIndex;
	if (nIndex==-1) return;
	
	SelBodyInfo1=BodyListObj[nIndex].value;
	var SelItem1=SelBodyInfo1.split("&");
	var BodyCode=SelItem1[0];
	var Flag=SelItem1[1];
	
	SelBodyInfo0=BodyListObj[nIndex].text;
	if (SelBodyInfo0=="其他部位")
	{
		document.getElementById('SelOBPFlag').value=SelBodyInfo0;
		document.getElementById('OtherBodyPart').disabled=false;
		gOtherBodyParts="Y";
	}

	var SelBodyListObj=document.getElementById('SelBodyPart'); 
	var AddIndex=SelBodyListObj.options.length;
	for (i=0;i<AddIndex;i++)
	{
		
		var SelBodyInfo2=SelBodyListObj[i].value;
		var SelItem2=SelBodyInfo2.split("&");
		
		if(SelItem2[0]==BodyCode)
		{
			alert("部位已经存在!");
			return;
		}
		
		if((SelItem2[1]==Flag)&&(Flag!=""))
		{
			alert("部位互斥不能增加!");
			return;
		}
		
		
	}
	
	var objSelected = new Option(SelBodyInfo0,SelBodyInfo1);
	SelBodyListObj.options[AddIndex]=objSelected;
	
	 
 }


//可以选择多个身体部位
function SelMultipleBodyPartClick() 
{
	
	var SelBodyInfo;
	
	var BodyListObj=document.getElementById('BodyList'); 
	var nIndex=BodyListObj.selectedIndex;
	if (nIndex==-1) return;
	
	SelBodyInfo1=BodyListObj[nIndex].value;
	SelBodyInfo0=BodyListObj[nIndex].text;
	var SelBodyListObj=document.getElementById('SelBodyPart'); 
	var AddIndex=SelBodyListObj.options.length;
	for (i=0;i<AddIndex;i++)
	{
		if (SelBodyListObj[i].value==SelBodyInfo1)
		{
			alert("部位已经存在");
			return;
		}
	}
	
	var objSelected = new Option(SelBodyInfo0,SelBodyInfo1);
	SelBodyListObj.options[AddIndex]=objSelected;
	

}

//只允许选择一个身体部位
function SelSingleBodyPartClick()
{
	var BodyListObj=document.getElementById('BodyList'); 
	var nIndex=BodyListObj.selectedIndex;
	if (nIndex==-1) return;
	
	SelBodyInfo1=BodyListObj[nIndex].value;
	SelBodyInfo0=BodyListObj[nIndex].text;
	var SelBodyPartObj=document.getElementById('SelBodyPart'); 
	var AddIndex=SelBodyPartObj.options.length;
	
	for (i=0;i<AddIndex;i++)
	{
		SelBodyPartObj.remove(0);
	}
	
	var AddIndex=SelBodyPartObj.options.length;
	var objSelected = new Option(SelBodyInfo0,SelBodyInfo1);
	SelBodyPartObj.options[AddIndex]=objSelected; 
}



function SelBodyPartDBLClick()
{
	//alert("SelBodyPartDBLClick()")
	var SelBodyPartObj=document.getElementById('SelBodyPart'); 
	var nIndex=SelBodyPartObj.selectedIndex;
	if (nIndex==-1) return;
	SelBodyInfo0=SelBodyPartObj[nIndex].text;
	
	if (SelBodyInfo0=="其他部位")
	{
		document.getElementById('OtherBodyPart').value="";
		document.getElementById("SelOBPFlag").value=""
		document.getElementById('OtherBodyPart').disabled=true;
		gOtherBodyParts="N";
	}
	
    SelBodyPartObj.options[nIndex]=null;
    

}




function AllSelectClick()
{
	var SelBodyInfo;
	var SelBodyListObj=document.getElementById('SelBodyPart'); 
	
	var BodyListObj=document.getElementById('BodyList');
	var len=BodyListObj.options.length;
	for (j=0;j<len;j++)
	{		
		SelBodyInfo1=BodyListObj[j].value;
		var SelItem1=SelBodyInfo1.split("&");
	    var BodyCode=SelItem1[0];
	    var Flag=SelItem1[1];
	    
		SelBodyInfo0=BodyListObj[j].text;
		var AddIndex=SelBodyListObj.options.length;
		for (i=0;i<AddIndex;i++)
		{
			var SelBodyInfo2=SelBodyListObj[i].value;
			var SelItem2=SelBodyInfo2.split("&");
			
			if(SelItem2[0]==BodyCode)
			{
				alert("部位已经存在!");
				return;
			}
			
			if((SelItem2[1]==Flag)&&(Flag!=""))
			{
				alert("存在互斥部位不能全部增加!");
				return;
			}
		}
		
		var objSelected = new Option(SelBodyInfo0,SelBodyInfo1);
		SelBodyListObj.options[AddIndex]=objSelected;
		
		if (SelBodyListObj.options[AddIndex].text=="其他部位");
		{
			document.getElementById('OtherBodyPart').disabled=false;
		    gOtherBodyParts="Y";
		}
	}
	
}




function AllDeleteClick()
{
	var SelBodyPartObj=document.getElementById('SelBodyPart'); 
	var Len=SelBodyPartObj.options.length;
	for (i=Len-1;i>=0;i--)
	{
		SelBodyInfo0=SelBodyPartObj[i].text;
		
		if (SelBodyInfo0=="其他部位")
		{
			document.getElementById('OtherBodyPart').value="";
			document.getElementById("SelOBPFlag").value="";
			document.getElementById('OtherBodyPart').disabled=true;
			gOtherBodyParts="N";
		}
		
		SelBodyPartObj.options[i]=null;
		
	}

}

//设置打印次数
//sunyi 2011-08-15
function GetPrintNo()
 {	
   var OEorditemID=document.getElementById("OEorditemID").value;
   var GetPrintNoFunction=document.getElementById("GetPrintNoFunction").value;
   var Index=cspRunServerMethod(GetPrintNoFunction,OEorditemID);
   document.getElementById("PrintNo").value=Index;
 }


function GetSelectLocUser(tmp)
{
  Item=tmp.split("^");
  document.getElementById("LocDoctor").value=Item[1];
  document.getElementById("DoctorID").value=Item[0];
}


function GetPostureList(OEorditemID)
{
	 
     var PostureListInfo=""
	 var PostureListObjFunction=document.getElementById('GetPostureList').value; 
	 var PostureListObj=document.getElementById('PostureList')
	 
	 for (i=PostureListObj.length-1;i>=0;i--)
     {
	    PostureListObj.remove(0);
	 }
  
	 var PostureListInfo=cspRunServerMethod(PostureListObjFunction,OEorditemID);
	 
	 if (PostureListInfo!="")
	 {
	    	var PostureList=PostureListInfo.split("@");
     		var Nums=PostureList.length;
     	   	for (j=0;j<Nums;j++)
			{
				var Index=PostureListObj.options.length;
				var PostureInfo=PostureList[j].split("-");
				var objSelected = new Option(PostureInfo[1],PostureInfo[0]);
				PostureListObj.options[Index]=objSelected;
			}
			
			nPostureList="1"
	 }
	 
 }
 
 
 //只选择一个体位
 function SelectPostureListClick()
 {
	var PostureListObj=document.getElementById('PostureList'); 
	var nIndex=PostureListObj.selectedIndex;
	
	SelPostureInfo1=PostureListObj[nIndex].value;
	SelPostureInfo0=PostureListObj[nIndex].text;
	gPostureTemp=SelPostureInfo0
	
	var SelPostureListObj=document.getElementById('SelPostureList'); 
	var AddIndex=SelPostureListObj.options.length;
	
	for (i=0;i<AddIndex;i++)
	{
		SelPostureListObj.remove(0);
	}
	
	var AddIndex=SelPostureListObj.options.length;
	var objSelected = new Option(SelPostureInfo0,SelPostureInfo1);
	SelPostureListObj.options[AddIndex]=objSelected; 
 }
 
 
 
 function SelPostureDBLClick()
 {
	var SelPostureObj=document.getElementById('SelPostureList'); 
	var nIndex=SelPostureObj.selectedIndex;
	if (nIndex==-1) return;
    SelPostureObj.options[nIndex]=null;
 }
 
 
 function GetExclusionFlag(OEorditemID)
 {
	var ExclusionFlagFun=document.getElementById("GetExclusionFlag").value;
    var Flag=cspRunServerMethod(ExclusionFlagFun,OEorditemID);
    return Flag;
	 
 }
 
 function SetAppInfo(OEorditemID)
 {
	var LocDoctor=document.getElementById("LocDoctor").value;
	var OtherBodyPart=document.getElementById("OtherBodyPart").value;
	var SelOBPFlag=document.getElementById("SelOBPFlag").value;
	var HopeDate=document.getElementById("HopeDate").value; //=DateDemo();
	var purpose=document.getElementById("purpose").value
	
	var Info=LocDoctor+"^"+SelOBPFlag+"&"+OtherBodyPart+"^"+HopeDate+"^"+gPostureTemp+"^"+gBodyPartTemp+"^"+purpose;
	var SetAppInfoFun=document.getElementById("SetAppInfo").value;
    var ret=cspRunServerMethod(SetAppInfoFun,OEorditemID,Info);
    
    if(ret=="0")
    {
	}
	else
	{
		var error="设置平台数据失败!";
		alert(error);
	}
	 
 }
 
 
 function GetOtherBodyPartFalg(OEorditemID)
 {
	var GetOtherBodyPartFalgFun=document.getElementById("GetOtherBodyPartFalg").value;
    var Info=cspRunServerMethod(GetOtherBodyPartFalgFun,OEorditemID);
    var gPostureTemp=""
    
    var SelItem1=Info.split("^");
	var nums=Info.split("^").length;
    
	var Desc=SelItem1[0];
	if(nums>1)
	{
	   gPostureTemp=SelItem1[1];
	}
    
    if(Desc=="其他部位")
    {
	    document.getElementById('OtherBodyPart').disabled=false;
	    gOtherBodyParts="Y";
	}
	else
	{
		document.getElementById('OtherBodyPart').disabled=true;
		gOtherBodyParts="N";
	}
 }
 
 
 
 function IsSendAppFlag(OEorditemID)
 {
	var GetPatientStatusFun=document.getElementById("GetPatientStatus").value;
    var Status=cspRunServerMethod(GetPatientStatusFun,OEorditemID)
    
    if((Status=="A")||(Status=="E"))
    {
	    IsSend="Y";
	}
	else
	{
		IsSend="N";
	}
	
	return IsSend
 }
 
 
//获取选中部位设置接口程序
function GetSelBodyPartInfo()
{
	var gBodyPart=""
    var SelBodyPartObj=document.getElementById('SelBodyPart'); 
	var Len=SelBodyPartObj.options.length;
	
	for(i=0;i<Len;i++)
	{
		SelBodyInfo0=SelBodyPartObj[i].text;
		gBodyPart=SelBodyInfo0+"&"+gBodyPart;
	}
	
	return gBodyPart;

}

function GetAppItemNmae(OEorditemID)
{
	var GetAppItemNmaeFun=document.getElementById("GetAppItemName").value;
    var Info=cspRunServerMethod(GetAppItemNmaeFun,OEorditemID);
    return Info;
}

function IsRejectApp(OEorditemID)
{
	var IsRejectAppFun=document.getElementById("IsDelRejAppData").value;
    var value=cspRunServerMethod(IsRejectAppFun,OEorditemID);
    return value;
}

function DisplayRevelation(OEorditemID)
{
    var DisplayRevelation=document.getElementById("DisplayRevelation").value;
    var value=cspRunServerMethod(DisplayRevelation,OEorditemID);
    return value;	
}


//获取选中体位设置接口程序
function GetSelPostureInfo()
{
	var gPosture=""
    var SelPostureObj=document.getElementById('SelPostureList'); 
	var Len=SelPostureObj.options.length;
	
	for(i=0;i<Len;i++)
	{
		gPosture=SelPostureObj[i].text;
	}
	
	return gPosture;
}

function strlen(str) 
{   
    var len = 0;   
    for (var i = 0; i < str.length; i++) 
    {   
        if (str.charCodeAt(i) > 255) 
        {
	        len += 2;
        }
        else
        {
	        len += 1;
	    }
    }   
    return len;   
}

function Replace(str)
{
   Info=str.replace(new RegExp("。","g"),".");
   Info=Info.replace(new RegExp("，","g"),",");
   Info=Info.replace(new RegExp("：","g"),":");
   Info=Info.replace(new RegExp("！","g"),"!");
   Info=Info.replace(new RegExp("%","g"),"%");
   Info=Info.replace(new RegExp("《","g"),"<<");
   Info=Info.replace(new RegExp("〉","g"),">>");
   Info=Info.replace(new RegExp("？","g"),"?");
   Info=Info.replace(new RegExp("（","g"),"(");
   Info=Info.replace(new RegExp("）","g"),")");
   Info=Info.replace(new RegExp("、","g"),"");
   Info=Info.replace(new RegExp("^","g"),"~");
	
   return Info
}


//当体位与部位列表不全为空时,如果选择的体位与部位全为空
//不能发送申请单
//2012-02-15 sunyi
function IsSelList()
{
  	var SelPostureObj=document.getElementById('SelPostureList'); 
	var PLen=SelPostureObj.options.length;
	    PLen=Number(PLen);
	var SelBodyPartObj=document.getElementById('SelBodyPart'); 
	var BLen=SelBodyPartObj.options.length;
	    BLen=Number(BLen);
	
	if(PLen==0)
	{
		var nSelPList="0";
	}
	if(BLen==0)
	{
		var nSelBList="0";
	}

	if((nBodyList=="1")||(nPostureList=="1"))
	{
		if((nSelBList=="0")&&(nSelPList=="0"))
		{
			return "N";
		}
	}
	else
	{
		return "Y";
	}
}

function GetTotalPrice(OEorditemID)
{
	var GetTotalPriceFun=document.getElementById("GetTotalPriceFun").value;
    var value=cspRunServerMethod(GetTotalPriceFun,OEorditemID);
    return value;
}

function SetStyle(obj)
{
	document.getElementById(obj).style.border='3px solid #FF0000';
	document.getElementById(obj).focus();
}

function SetPatNow(FirstOrderItem)
{
	var StatusDesc=document.getElementById("PatientNow").value;
        StatusDesc=cTrim(StatusDesc,0)
  
    var StatusDescL=Replace(StatusDesc);
    var len=strlen(StatusDescL);
   
    var n=parseInt(len/2600)
    var mod=len%2600

    if ((mod>0)&(mod<2600))
    {
	    n=n+1;
	}else if (mod>2600)
	{
		n=n+2;
	}
    for(i=1;i<=n;i++)
    {   
        var EndL=2600
        var StratL=0
        if (i==0)
        {
	      tmp1=StatusDescL.substring(StratL,EndL);
        }
        else
        {
	      tmp1=StatusDescL.substring(StratL,EndL);
        }
  
	   StratL=EndL+1;
	   EndL=EndL+2601
	}
 	
}
function ToothClick()
{
	var OEorditemID=document.getElementById("OEorditemID").value;
    var EpisodeID=document.getElementById("EpisodeID").value;
    var lnk="dhcris.MouthDesign.show.csp?OEorditemID="+OEorditemID+"&EpisodeID="+EpisodeID;
    var NewWin=open(lnk,"","top=6,left=6,width=600,height=300");
}



function InsertBodyPart()
{
	var SelBodyInfo;
	var BodyListObj=document.getElementById('BodyList'); 
	var nIndex=BodyListObj.selectedIndex;
	
	var Len=BodyListObj.options.length;
	//alert(Len);
	if (Len==0) return;
	if (nIndex==-1) 
	      nIndex=0
	
	SelBodyInfo1=BodyListObj[nIndex].value;
	SelBodyInfo0=BodyListObj[nIndex].text;
	//alert(SelBodyInfo1);
	//alert(SelBodyInfo0);
    var SelBodyListObj=document.getElementById('SelBodyPart');  
    objSelected = new Option(SelBodyInfo0,SelBodyInfo1); 
    SelBodyListObj.options[nIndex]=objSelected;	

 }
 
function closeWindow() 
{ 
     window.opener=null; 
     window.open('', '_self', ''); 
     window.close(); 
} 

function GetAppCount()
{
	var GetAppCountFun=document.getElementById("GetAppCount").value;
        gAppCount=cspRunServerMethod(GetAppCountFun,gUserID);
}

function SetAppCount()
{
	var SetAppCountFun=document.getElementById("SetAppCount").value;
    var SetCount=cspRunServerMethod(SetAppCountFun,gUserID,gSelCount);
    return SetCount
}
function GetSelCount(OEorditemID)
{
	 var orditem=OEorditemID.split("@");
     var len=orditem.length;
     gSelCount=len;
}

//获取预约模板
//sunyi
function GetLocPrintTemplate()
{
   var locdr=document.getElementById("RecLocDR").value;
   /*var GetBKTempFunction=document.getElementById("GetLocBookTemp").value;
   gBookTempalte=cspRunServerMethod(GetBKTempFunction,locdr);*/	
   gBookTempalte=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetLocBookedPrintTemplate",locdr);
}

function GetLocAutoBK()
{
   var locdr=document.getElementById("RecLocDR").value;
   gLocStartBK=tkMakeServerCall("web.DHCRisCommFunctionEx","GetLocBookSet",locdr);
}

function GetAutoBookedInfo(OEorditemID,UserID)
{
	var BookDateInfo="",BookDate="",StTime="",EndTime=""
	var BookDateInfo=document.getElementById("CanUseDate").value;
	if (BookDateInfo!="")
	{
		 var ArrayInfo=tkMakeServerCall("web.DHCRisCommFunctionEx","GetBookFormatParam",BookDateInfo);
		 if (ArrayInfo!="")
		 {
			 var tmp=ArrayInfo.split("^");
			 BookDate=tmp[0];
			 StTime=tmp[1];
			 EndTime=tmp[2];
		 }
	 
    }
	
	if (BookDate=="")
	{
			BookDate=DateDemo();
			BookDate=tkMakeServerCall("web.DHCRisCommFunctionEx","GetDigitalDateFormat",BookDate);
	}

    var result="",retBK=1
    var result=tkMakeServerCall("web.DHCRisBookCommFunction","AutoBooked",OEorditemID,BookDate,StTime,"",UserID,"","",EndTime);
    if (result!="")
    {
       var BookInfo=result.split("^");
       if (BookInfo[0]==BookInfo[1]) 
       {
	       retBK=0
       }
          
    }
     
    return  retBK      
}



function OnPrint(OEorditemID)
{
	if(OEorditemID!="")
	{
	   var UserID=session['LOGON.USERID'];
	   var GetBookedPrintFun=document.getElementById("GetBookedPrintFun").value;
       var value=cspRunServerMethod(GetBookedPrintFun,OEorditemID);
       
       if(value=="")
       {
	       alert("医嘱项目数据出错不能打印！");
	       return;
	   }
	   
       if (value!="")
       {
	       Item=value.split("^");
	       RegNo=Item[0];
	       Name=Item[1];
	       strOrderName=Item[2];
	       BookedDate=Item[3];
	       BooketTime=Item[4];
	       LocDesc=Item[5];
	       Address=Item[6];
	       ResourceDesc=Item[7];
	       EqAdress=Item[8];
	       DOB=Item[9];
	       Age=Item[10];
	       SexDesc=Item[11];
	       MedicareNo=Item[12];
	       PinYin=Item[13];
	       WardName=Item[14];
	       BedNo=Item[15];
	       AppLocName=Item[16]
	       Memo=Item[17];
	            
	   }
       	
       //var OEorditemID1=OrditemID.split("||")[0]+"-"+OrditemID.split("||")[1];
       
       DHCP_GetXMLConfig("InvPrintEncrypt",gBookTempalte);
	
	   var MyPara="PatientName"+String.fromCharCode(2)+Name;
	   MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+"*"+OEorditemID1+"*";
	   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
	   MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate+" "+BooketTime;
	   MyPara=MyPara+"^LocDesc"+String.fromCharCode(2)+LocDesc;
	   MyPara=MyPara+"^OrderName"+String.fromCharCode(2)+strOrderName;
	   MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
	   MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+ResourceDesc;
	   MyPara=MyPara+"^EqAdress"+String.fromCharCode(2)+EqAdress;
	   MyPara=MyPara+"^DOB"+String.fromCharCode(2)+DOB;
	   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
	   MyPara=MyPara+"^SexDesc"+String.fromCharCode(2)+SexDesc;
	   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+MedicareNo;
	   MyPara=MyPara+"^PinYin"+String.fromCharCode(2)+PinYin;
	   MyPara=MyPara+"^Memo"+String.fromCharCode(2)+Memo;
	   MyPara=MyPara+"^WardName"+String.fromCharCode(2)+WardName;
	   MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+BedNo;
	   MyPara=MyPara+"^AppLocName"+String.fromCharCode(2)+AppLocName;
	   
	   InvPrintNew(MyPara,"");
 
	   
	}
	   
}
function StaticButton()
{

	var AllInfo=document.getElementById("OEorditemID").value;

	var button=tkMakeServerCall("web.DHCRisApplicationBill","IsSendAppBill",AllInfo);//AllInfo返回值
	var GetPatientStatusFun=document.getElementById("GetPatientStatus").value;
    var Status=cspRunServerMethod(GetPatientStatusFun,AllInfo)
	if((button=="Y")&&(Status!="RJ"))//已经发送过的隐藏
	{
		$("SentBiil").style.display = 'none';
		
	}else if(button=="N")
		{
				$("SentBiil").style.display = 'blue';
				$("CancelSend").style.display = "blue"; 
			}  
}

document.body.onload = BodyLoadHandler;