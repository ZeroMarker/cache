//DHCRisComm.JS
var docobj;
var XMLSaveObj;
var IsReturn=""

//选择部位
var listbodyInfo = new Array();


//get obj value
function DHCWebD_GetObjValue1(objname)
{
	var obj=document.getElementById(objname);
	var transval="";
	if (obj)
	{
		switch (obj.type)
		{
			case "select-one":
				myidx=obj.selectedIndex;
				transval=obj.options[myidx].text;
				break;
			case "checkbox":
				transval=obj.checked;
				break;
			case "select-multiple":
			 	var len=obj.options.length;
				for (j=0;j<len;j++)
				{
				   if (transval=="")
				   {
					   transval=obj[j].value+"-"+obj[j].text;
				   }
				   else
				   {
					  transval=transval+"^"+obj[j].value+"-"+obj[j].text; 
				   }
				}
			    break;
			    		
			default:
				transval=obj.value;
				transval=transval.replace(/\^/g,"~");
			    break;
		}
	}
	return transval;
}


//Set Obj value
function DHCWebD_SetObjValue1(objname,value)
{
	var obj=document.getElementById(objname);
	var transval="";
	if (obj)
	{
		switch (obj.type)
		{
			case "select-one":
			 	var Len=obj.options.length;
		    	for (var j=0;j<Len;j++)
		    	{
			      if (obj.options[j].value==value)
			      {
				      obj.options[j].selected=true;
				  }
		    	}
				break;
			case "checkbox":
			    if (value=="true")
			    {
				    obj.checked=true;
			    }
			    else
			    {
				    obj.checked=false;
				    
			    }
			   	break;
			 
			  case "select-multiple":
			    var Item=value.split("^");
			       
			    /*if(Item[0]=="-")!(Item[0]=="")
			    {
				    break;
				}*/
				
			    var arrlen=Item.length;
			    
	   			for (i=0;i<arrlen;i++)
	   			{
		   			//alert("B")
		   			var BodyInfo=Item[i].split("-");
		   			//alert(BodyInfo);
		   			var objSelected = new Option(BodyInfo[1],BodyInfo[0]);
		   			var AddIndex=obj.options.length;
					obj.options[AddIndex]=objSelected;
	
	   			}
		        break;
			  
			   	
			default:
				obj.value=value;
			    break;
		}
	}
	return transval;
}

function SendXMLString(OeorditemID,XDate,UserID,gHtmlTemp,PrintParam)
{
	
	 var XMLString;
	 var OEorditemID;
	 var SendXMLFunctionOBJ="SaveAppBill"
	 var SetAppFiledOBJ="SetCarrentAppFiled"	 
	 XMLString="<?xml version="+'"'+"1.0"+'"'+" encoding="+'"'+"gb2312"+'"'+"?>" 
	 XMLString=XMLString+"<AppBill>";
	 
	 
	 for (var j=0;j<document.all.length;j++)
     {
	    if ((document.all(j).type=="select-one")||(document.all(j).type=="text")||(document.all(j).type=="checkbox")||(document.all(j).type=="textarea")||(document.all(j).type=="select-multiple"))
	    {
		   	var myname=document.all(j).name;
		   	XMLString=XMLString+"<"+myname+">";
		    var myval=DHCWebD_GetObjValue1(myname);
		    XMLString=XMLString+myval+"</"+myname+">"   
		    if (document.all(j).type=="checkbox")
		    {
			    if (myval==true)
	      		{
	    			myval="V";
	      		}	 
	      		else if (myval==false)
	      		{ 
	        		myval="X";
	      		}
	      	}
	      	if ((document.all(j).name=="PatientNow")||(document.all(j).name=="MainDiagose")||(document.all(j).name=="purpose")) 
	      	{
		      	myval=myval.replace(/\^/g,"~");
		    }
		    
		    gHtmlTemp = gHtmlTemp.replace(myname,myval);  
		}
	}
	XMLString=XMLString+"</AppBill>";
	
	//alert(XMLString);
		
	//////////////////////////////////////////save Item Info;
	
	var SelArcItemId="";
	var objtbl=document.getElementById('tDHCRisApplicationBill');
	var rows=objtbl.rows.length;
    var Info="";
    var ungent;
    
    ///sunyi 2011-11-22
    var LocDoctor=document.getElementById("LocDoctor").value;
    if(LocDoctor=="")
    {
	    DoctorID="";
	}
	else
	{
	    DoctorID=document.getElementById("DoctorID").value; 	
	}
	
	if (document.getElementById("ungent").checked)
    {
  	     ungent="Y";
    }
    else
    {
  	     ungent="N";
    }
    
   
	
	for (i=1;i<rows;i++)
 	{
		var ItemName=document.getElementById("Fieldz"+i).innerText;
		var Option=document.getElementById("Optionz"+i).value;
		var FileldDR=document.getElementById("FieldDRz"+i).value;
		var EpisodeID=document.getElementById("EpisodeIDz"+i).value;

		var myname="Content_"+i;
		var Value=DHCWebD_GetObjValue1(myname)
		
		var Require=document.getElementById("Requirez"+i).value;
		if ((Require==1)&&(Value==""))
		{
		    var Isreturn="Y"
			if((ItemName.indexOf("女性患者妊娠情况")=="0")&&(Sex=="男"))
			{
				Isreturn="N";
			}
			
			if (Isreturn=="Y")
			{
				var AlertInfo=ItemName+"字段:不能为空!";
			    alert(AlertInfo);
			    tbl.rows[i].style.backgroundColor="#FF0000";
			    return;
			}
			
			
		}
		
		/*if((ItemName.indexOf("女性患者妊娠情况")=="0")&&(Sex=="女")&&(Value==""))
		{
			var AlertInfo=ItemName+"字段:不能为空!";
			alert(AlertInfo);
			tbl.rows[i].style.backgroundColor="#FF0000";
			return;
			
		}*/
		
		// 选择某个项目?在数据库中插入医嘱项目
		var obj=document.getElementById(myname);
		
		if (obj.type=="checkbox")
		{
			
			if((ItemName.indexOf("床旁")=="0")&&(Value==true))
			{
				var Selbedside=1;
			}
			
			if((ItemName.indexOf("手术")=="0")&&(Value==true))
			{
				var surgical=1;
			}
			if((Selbedside==1)&&(surgical==1))
			{
				alert("不能同时选中床旁和手术!");
				return;
			}
			
			var ItemMastId=document.getElementById("ItemMastIdz"+i).value;
			if ((Value==true)&&(ItemMastId!=""))
			{
				
				if(SelArcItemId=="")
				{
					SelArcItemId=ItemMastId;
				}
				else
				{
					SelArcItemId=SelArcItemId+"@"+ItemMastId;
				}
			}
		}	
	
		var ItemInfo=ItemName+String.fromCharCode(2)+Value;
		if (Info=="")
		{
			 Info=ItemInfo;
		}
		else
		{
			 Info=Info+"^"+ItemInfo;
		} 
		
		if (Option=="default")
		{
			var SetSaveInfo=EpisodeID+"^"+"^"+FileldDR+"^"+Value;
			var SaveAppFiledFunction=document.getElementById(SetAppFiledOBJ).value;
			var ret=cspRunServerMethod(SaveAppFiledFunction,SetSaveInfo);

		}
		
	}
	
	//=session["LOGON.USERID"];
	///根据徐州项目的要求获取部位的信息
	//GetBodyPartInfo();
	//var BodyInfo=GetBodyPartSaveInfo();
	var BodyInfo="";
  	var SaveFunction=document.getElementById(SendXMLFunctionOBJ).value;
	var ret=cspRunServerMethod(SaveFunction,XMLString,OeorditemID,XDate,UserID,gHtmlTemp,Info,PrintParam,BodyInfo,SelArcItemId,DoctorID,ungent,gUserID);
    return ret;
    
 
}



function LoadXMLData(OEorditemID)
{
	var XMLString;
	var GetAppBillObj="GetAppBILL";
	var objtbl=document.getElementById('tDHCRisApplicationBill');
	var rows=objtbl.rows.length;
	
	var GetFunction=document.getElementById(GetAppBillObj).value;
  	var Value=cspRunServerMethod(GetFunction,OEorditemID);
  
	var Item;
	Item=Value.split(String.fromCharCode(2));
	
	if (Item[0]!="")
	{
	   XMLString=Item[0];
	   
	   var XMLItem=XMLString.split(String.fromCharCode(1));
	   var arrlen=XMLItem.length;
	   XMLString="";

	   for (i=0;i<arrlen;i++)
	   {
		   if (XMLString=="")
		   {
			   XMLString=XMLItem[i];
		   }
		   else
		   {
			   XMLString=XMLString+"\r\n"+XMLItem[i];
		   }
	   } 
	   
	   for (var i=0;i<document.all.length;i++)
       {
	      if ((document.all(i).type=="select-one")||(document.all(i).type=="text")||(document.all(i).type=="checkbox")||(document.all(i).type=="textarea")||(document.all(i).type=="select-multiple"))
	      {
	        var myname=document.all(i).name;
	        var Getvalue1=XMLString.split(myname);
	        if(Getvalue1.length==1) continue
	       
	        var len=Getvalue1[1].length;
	        var GetValue="";
	        
		    if (len>3)
		    { 
		   	   GetValue=Getvalue1[1].substring(1,len-2);
		    }
		    
		    DHCWebD_SetObjValue1(myname,GetValue)
	      }
	   }
       return 1
	}
 return 0;	
}

function GetPrintParam()
{
     OEorditemID1="";
	 var PrintParam="";PatientNowValue1="";PatientNowValue2="";PatientNowValue3="";PatientNowValue4="";PatientNowValue="";
	 var MainDiagoseValue2="";MainDiagoseValue1="";
	 var PurposeValue="",RegNoTM="";
	 
	 for (var j=0;j<document.all.length;j++)
     {
	    if ((document.all(j).type=="select-one")||(document.all(j).type=="text")||(document.all(j).type=="checkbox")||(document.all(j).type=="textarea")||(document.all(j).type=="select-multiple"))
	    {
		   	var myname=document.all(j).name; 
		   	if(myname=="OEorditemID")
		   	{ 
		   	   OEorditemID=DHCWebD_GetObjValue1("OEorditemID");
		       OEorditemID1=OEorditemID.split("||")[0]+"-"+OEorditemID.split("||")[1];
		    }
		    
		    var myval=DHCWebD_GetObjValue1(myname);
		    if((myname=="BodyList")||(myname=="SelBodyPart")||(myname=="PostureList")||(myname=="SelPostureList"))
		    {
			    myval=myval.replace(/\^/g,"@");
			}
		    
		    
		    if(myname=="PatientNow")
		    {                           //yjy start
		       PatientNowValue=ignoreSpaces(DHCWebD_GetObjValue1("PatientNow"));
		       PatientNowValue=PatientNowValue.replace(/\r|\n/g,"");
		       PatientNowValue1=PatientNowValue.substring(0,44);
		       PatientNowValue2=PatientNowValue.substring(44,88);
		       PatientNowValue3=PatientNowValue.substring(88,132);
		       document.getElementById("PatientNow").value=PatientNowValue;
		   
		    }
		    
		    if(myname=="MainDiagose")
		    { 
		       MainDiagoseValue=ignoreSpaces(DHCWebD_GetObjValue1("MainDiagose"));
		       MainDiagoseValue=MainDiagoseValue.replace(/\r|\n/g,"");
		       MainDiagoseValue1=MainDiagoseValue.substring(0,44);
		       MainDiagoseValue2=MainDiagoseValue.substring(44,88);
		       //document.getElementById("MainDiagose").value=PatientNowValue;
		    }
		    
		    if(myname=="purpose")
		    { 
		       //PurposeValue=ignoreSpaces(DHCWebD_GetObjValue1("purpose"));
		       //document.getElementById("purpose").value=PurposeValue;
		       PurposeValue=ignoreSpaces(DHCWebD_GetObjValue1("purpose"));
		       PurposeValue=PurposeValue.replace(/\r|\n/g,"");
		       PurposeValue1=PurposeValue.substring(0,44);
		       PurposeValue2=PurposeValue.substring(44,88);
		       PurposeValue3=PurposeValue.substring(88,132);
		    }
		    
		    if(myname=="RegNo")
		    {                   
		       RegNoTM=ignoreSpaces(DHCWebD_GetObjValue1("RegNo"));
		       RegNoTM="*"+RegNoTM+"*";
		    }
		    
		    /*if(myname=="reason")
		    { 
		       //PurposeValue=ignoreSpaces(DHCWebD_GetObjValue1("purpose"));
		       //document.getElementById("purpose").value=PurposeValue;
		       reasonValue=ignoreSpaces(DHCWebD_GetObjValue1("reason"));
		       reasonValue=reasonValue.replace(/\r|\n/g,"");
		       reasonvalue1=reasonValue.substring(0,44);
		       reasonvalue2=reasonValue.substring(44,88);
		    }*/
		    
		    if (document.all(j).type=="checkbox")
		    {
		       if (myval==true)
		   	   {
			    	myval="Y";
		   	   } 
		       else if (myval==false)
		   	   { 
		   	       myval="N";
			   }
			   
		       ////////////////////////////////////////////////修改
			   if (document.all(j).name=="ungent")
			   {
					 if (myval=="Y")
					 {
						myval="急!";
					 } 
					 else if (myval=="N")
					 { 
						myval="";
					 }
			    }
			    //////////////////////////////////////////////修改  

		    }
		    if (PrintParam=="")
		   	{
			   PrintParam=myname+String.fromCharCode(2)+myval; 	
		   	}
		   	else
		   	{
			   PrintParam=PrintParam+"^"+myname+String.fromCharCode(2)+myval;
		   	}
		 }
		   // PrintParam=PrintParam+"^OEorditemID1"+String.fromCharCode(2)+OEorditemID1;
	}
	PrintParam=PrintParam+"^OEorditemID1"+String.fromCharCode(2)+"*"+OEorditemID1+"*"; //yjy
	PrintParam=PrintParam+"^PatientNowValue1"+String.fromCharCode(2)+PatientNowValue1;
	PrintParam=PrintParam+"^PatientNowValue2"+String.fromCharCode(2)+PatientNowValue2;
	PrintParam=PrintParam+"^PatientNowValue3"+String.fromCharCode(2)+PatientNowValue3;
	PrintParam=PrintParam+"^PatientNowValue4"+String.fromCharCode(2)+PatientNowValue4;
	PrintParam=PrintParam+"^MainDiagoseValue1"+String.fromCharCode(2)+MainDiagoseValue1;
	PrintParam=PrintParam+"^MainDiagoseValue2"+String.fromCharCode(2)+MainDiagoseValue2; //yjy end
	PrintParam=PrintParam+"^PurposeValue1"+String.fromCharCode(2)+PurposeValue1;
	PrintParam=PrintParam+"^PurposeValue2"+String.fromCharCode(2)+PurposeValue2;
	PrintParam=PrintParam+"^PurposeValue3"+String.fromCharCode(2)+PurposeValue3;
	//PrintParam=PrintParam+"^purpose1"+String.fromCharCode(2)+reasonvalue1;
	//PrintParam=PrintParam+"^purpose2"+String.fromCharCode(2)+reasonvalue2;
	//增加医院名称获取
	var hospitalDesc=tkMakeServerCall("web.DHCRisCommFunction","getHospitalDescByOrder",OEorditemID);
	PrintParam=PrintParam+"^HospitalDesc"+String.fromCharCode(2)+hospitalDesc;
	
    /// 根据徐州项目的要求获取部位的信息
	GetBodyPartInfo();
    PrintBodyInfo=GetBodyParPrintInfo();
    PrintParam=PrintParam+"^"+PrintBodyInfo;
    //设置打印次数
    //alert(OEorditemID)
    var GetPrintNoFunOBJ="GetPrintNoFunction"
    var GetPrintNoFun=document.getElementById(GetPrintNoFunOBJ).value;
    var Index=cspRunServerMethod(GetPrintNoFun,OEorditemID);
       
    ///增加打印医生
    var printtime=GetCurrentTime();
    PrintParam=PrintParam+"^User"+String.fromCharCode(2)+session['LOGON.USERNAME'];
    PrintParam=PrintParam+"^PrintTime"+String.fromCharCode(2)+printtime;
    PrintParam=PrintParam+"^PrintNo"+String.fromCharCode(2)+Index;
    
    //增加急诊病人申请单加"急"标志
    //sunyi 2011-09-22
    //var PatType=GetPatType(OEorditemID);
    //PrintParam=PrintParam+"^EPatType"+String.fromCharCode(2)+PatType;
    
    
    
    //医嘱项目=体位+部位+实际项目名称(或医嘱项目名称)
    //2011-12-29 sunyi 
    var GetAppItemNameFunOBJ="GetAppItemName";
    var GetAppItemNameFun=document.getElementById(GetAppItemNameFunOBJ).value;
    var AppItemName=cspRunServerMethod(GetAppItemNameFun,OEorditemID);
    
   
    //获取发送申请单后的体位与部位
    var GetSelBodyPartFunOBJ="GetSelBodyPartFun";
    var GetSelBodyPartFun=document.getElementById(GetSelBodyPartFunOBJ).value;
    var value=cspRunServerMethod(GetSelBodyPartFun,OEorditemID);
    var item=value.split("^");
    var PPart=item[0];
    var BPart=item[1];
    
    
    PrintParam=PrintParam+"^AppItemName"+String.fromCharCode(2)+AppItemName;
    PrintParam=PrintParam+"^SetSelBodyPart"+String.fromCharCode(2)+BPart;
    PrintParam=PrintParam+"^SetSelPosture"+String.fromCharCode(2)+PPart;
    
    //获取自动预约日期
    /*
    var GetAutoBookedOBJ="GetAutoBooked";
    var GetAutoBookedFun=document.getElementById(GetAutoBookedOBJ).value;
    var BookedDate=cspRunServerMethod(GetAutoBookedFun,OEorditemID);
    PrintParam=PrintParam+"^BookedDate"+String.fromCharCode(2)+BookedDate;
    */
    
    var AppDateTime=GetCurrentTime();
    PrintParam=PrintParam+"^AppDateTime"+String.fromCharCode(2)+AppDateTime;
    
     //获取发送申请单后相关信息
    var CommDataObj="PrintCommData";
    var CommDataFun=document.getElementById(CommDataObj).value;
    var value=cspRunServerMethod(CommDataFun,OEorditemID);
    var item=value.split("^");
    var LAddress=item[0];
    var BAddress=item[1];
    var BINLINO=item[34];
    var Bed=item[45];
    PrintParam=PrintParam+"^LocAddress"+String.fromCharCode(2)+LAddress;
    PrintParam=PrintParam+"^BKAddress"+String.fromCharCode(2)+BAddress;
    PrintParam=PrintParam+"^RegNoTM"+String.fromCharCode(2)+RegNoTM;
    PrintParam=PrintParam+"^BINLINO"+String.fromCharCode(2)+BINLINO;
    PrintParam=PrintParam+"^Bed"+String.fromCharCode(2)+Bed;
    
    
    /*var GetToothFunOBJ="GetTooth";
    if (GetToothFunOBJ)
    {
      var GetTooth=document.getElementById(GetToothFunOBJ).value;
      var SelTooth=cspRunServerMethod(GetTooth,OEorditemID);
    }
    
    PrintParam=PrintParam+"^SelTooth"+String.fromCharCode(2)+SelTooth;*/
	//PrintParam=PrintParam+"^reason2"+String.fromCharCode(2)+reasonvalue2;
    //alert(PrintParam);	
	return PrintParam;
}

function GetPatType(OEorditemID)
{
	var GetPatTypeFunOBJ="GetPatTypeFun"
    var GetPatTypeFun=document.getElementById(GetPatTypeFunOBJ).value;
    var Type=cspRunServerMethod(GetPatTypeFun,OEorditemID);
    if (Type=="E")
        {
	       Type="急"   
	    }
	else
	    {
	 	   Type=""  
	    }
	return  Type   
}

function GetCurrentTime()
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
    
    var sHoure=d.getHours();
    
    var sMintues=d.getMinutes();
    if (sMintues<10)
     sMintues="0"+sMintues;  
    
    
    s = sYear +"-"+sMonth+"-"+sDay +" "+sHoure+":"+sMintues;
    return s;
}

function ignoreSpaces(string) 
{
  var temp = "";
  string = '' + string;
  splitstring = string.split(" "); //双引号之间是个空格?
  for(i = 0; i < splitstring.length; i++)
  {
	 temp += splitstring[i];
  }
  return temp
}


function DHCC_SetElementData(ElementName,Val){
	var obj=document.getElementById(ElementName);
	if (obj){
		if (obj.tagName=='LABEL'){
			obj.innerText=Val
		}else{
			if (obj.type=='checkbox'){
				obj.checked=Val;
				return;
			}
			obj.value=Val;
		}
	}
}

function DHCC_GetElementData(ElementName){
	var obj=document.getElementById(ElementName);
	if (obj){
		if (obj.tagName=='LABEL'){
			return obj.innerText
		}else{
			if (obj.type=='checkbox') return obj.checked;
			return obj.value
		}
	}
	return "";
}

function DHCC_ClearAllList(obj) {
	if (obj.options.length>0) {
		for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}

//DHCWebD_ClearAllListA("PayMode");
function DHCC_ClearList(ListName){
	var obj=document.getElementById(ListName);
	if (obj){DHCC_ClearAllList(obj);}
}


function getRelaDate(offset)
{
//in terms of today ,calculate the date
var obj=new Date();
var ms=obj.getTime();
var offsetms=60*60*24*offset*1000;
var newms=ms+offsetms;
var newdate=new Date(newms);
return formatDate(newdate);
}

function formatDate(dateobj)
{
	var sep="/";
	var day=dateobj.getDate();
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	return day+sep+mon+sep+year

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
   
   sYear  = d.getFullYear();   		
   s = sDay + "/" + sMonth + "/" + sYear;   
   return(s); 
   
}


///根据徐州项目的要求 获取部位信息
function GetBodyPartInfo1()
{
   // 数组含义 第一列 部位的序号 第二列子部位的开始序号 第三列 结束序号
   /*var   listbodyIndex= new  Array(new Array("1","2","11"),       
                                   new Array("12","13","29"),  
                                   new Array("30","31","36"),       
        						   new Array("37","38","41"),   
          				 		   new Array("42","43","50"),   
            					   new Array("51","52","53"),   
            				 	   new Array("54","55","58"),
            				 	   new Array("59","60","64")
            				 	   );
            				       //new Array("65","65","65"),
            				       //new Array("61","61","61")
            				 	  //);  
            				 	  
   */
   
           				 			
   // 数组含义 第一列 部位的序号 第二列子部位的开始序号 第三列 结束序号
   var   listbodyIndex= new  Array(new Array("1","2","3"),       
                                   new Array("7","8","9"),
                                   new Array("10","10","11"),
                                   new Array("12","12","12")
                                   
                         	 	  );   
   
    
    for(var j=0;j<listbodyIndex.length;j++)
    {
      listbodyInfo[j]="";
    }

    var objtbl=document.getElementById('tDHCRisApplicationBill');
    var rows=objtbl.rows.length;
    var Info="";
    for (i=1;i<rows;i++)
    {
		var ItemName=document.getElementById("Fieldz"+i).innerText;
		var myname="Content_"+i;
		var Value=DHCWebD_GetObjValue1(myname)
		var ItemInfo=ItemName+String.fromCharCode(2)+Value;
		var Index=document.getElementById("iRowsz"+i).innerText;
		
		var obj=document.getElementById(myname);
		if (obj.type=="checkbox")
		{   
			for(var j=0;j<listbodyIndex.length;j++)
  			{
	  	   		if (listbodyIndex[j][0]==Index)
  		   		{
  			    	listbodyInfo[j]=ItemName+":";
  			    	
  		   		}
  		   		else if (Value==true)
		    	 {
  		   		 if ((Index>=listbodyIndex[j][1])&&(Index<=listbodyIndex[j][2]))
  		   		{
	  		   		//alert(listbodyInfo[j]+"^"+j);
	  		   	 	if (listbodyInfo[j]!="")
	  		    	{
		  	       		if (listbodyInfo[j].length>1)
		  	       		{
	  		          		var lastChar=listbodyInfo[j].substr(listbodyInfo[j].length-1,1);
	  			  	  		if (lastChar==":")
	  			  	  		{
		  		         		listbodyInfo[j]=listbodyInfo[j]+ItemName;
	  			      		}
	  			     		else
	  			      		{
		  		         		listbodyInfo[j]=listbodyInfo[j]+","+ItemName;
	  			      		}
		           		}
	     			 }
	  		   		
  		   		}
  			}
  			}
  		}
		else
		{
			for(var j=0;j<listbodyIndex.length;j++)
  			{
	  	   		if (listbodyIndex[j][0]==Index)
  		   		{
  			    	listbodyInfo[j]=ItemName+":"+Value;
  			    	break;
  		   		}
  			}
			
		}

    }
	 
	return ;
}
    
///根据徐州项目的要求 获取部位信息
function GetBodyPartInfo()
{
    var objtbl=document.getElementById('tDHCRisApplicationBill');
    var rows=objtbl.rows.length;
    var Info="";
    for (i=1;i<rows;i++)
    {
		var ItemName=document.getElementById("Fieldz"+i).innerText;
		var myname="Content_"+i;
		var Value=DHCWebD_GetObjValue1(myname)
		var Index=document.getElementById("iRowsz"+i).innerText;
		
		if ((Index>=1)&&(Index<=11))
		{
			if(Index==1)
			{
				listbodyInfo[0]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[0]=listbodyInfo[0]+ItemName+",";
				}
			}
		}
		else  if ((Index>=12)&&(Index<=29))
		{
			if(Index==12)
			{
				listbodyInfo[1]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[1]=listbodyInfo[1]+ItemName+",";
				}
			}
			
		}
		else if ((Index>=30)&&(Index<=36))
		{
			if(Index==30)
			{
				listbodyInfo[2]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[2]=listbodyInfo[2]+ItemName+",";
				}
			}
		}
		else if ((Index>=37)&&(Index<=41))
		{
			if(Index==37)
			{
				listbodyInfo[3]=ItemName+":";
			}
			else
			{ 	if (Value==true)
				{
					listbodyInfo[3]=listbodyInfo[3]+ItemName+",";
				}
			}
		}
		else if ((Index>=42)&&(Index<=50))
		{
			if(Index==42)
			{
				listbodyInfo[4]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[4]=listbodyInfo[4]+ItemName+",";
				}
			}
		}
		else if ((Index>=51)&&(Index<=53))
		{
			if(Index==51)
			{
				listbodyInfo[5]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[5]=listbodyInfo[5]+ItemName+",";
				}
			}
			
		}
		else if ((Index>=54)&&(Index<=58))
		{
			if(Index==54)
			{
				listbodyInfo[6]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[6]=listbodyInfo[6]+ItemName+",";
				}
			}
			
		}
		else if ((Index>=59)&&(Index<=64))
		{
			if(Index==59)
			{
				listbodyInfo[7]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[7]=listbodyInfo[7]+ItemName+",";
				}
			}
			
		}
		else if ((Index>=65)&&(Index<=66))
		{
			if(Index==65)
			{
				listbodyInfo[8]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[8]=listbodyInfo[8]+ItemName+",";
				}
			}
			
		}
		else if ((Index>=67)&&(Index<=68))
		{
			if(Index==67)
			{
				listbodyInfo[9]=ItemName+":";
			}
			else
			{
				if (Value==true)
				{
					listbodyInfo[9]=listbodyInfo[9]+ItemName+",";
				}
			}
			
		}
		else
		{
			//其他
			listbodyInfo[10]=ItemName+":"+Value;
			
		}
    }
}

// 获取部位的打印信息
function GetBodyParPrintInfo()
{
    //生成打印格式
    PrintBodyInfo=""
	for (i=0;i<listbodyInfo.length;i++)
	{
		if (PrintBodyInfo=="")
		{
			PrintBodyInfo="BodyPart"+i.toString()+String.fromCharCode(2)+listbodyInfo[i];
		}
		else
		{
			PrintBodyInfo=PrintBodyInfo+"^BodyPart"+i.toString()+String.fromCharCode(2)+listbodyInfo[i];
		}
	}
	return PrintBodyInfo;
}

// 获取部位信息保存到医嘱备注里面
function GetBodyPartSaveInfo()
{
    //生成打印格式
    SaveBodyInfo=""
	for (i=0;i<listbodyInfo.length;i++)
	{
		Info=listbodyInfo[i];
		//alert(Info);
		var pos=Info.indexOf(':'); 
		BodyInfo=Info.substr(pos+1,Info.length);
		
		//BodyInfo=Info;
		
		if (BodyInfo!="")
		{
			if (SaveBodyInfo=="")
			{	
				SaveBodyInfo=BodyInfo;	
			}
			else 
			{	
				SaveBodyInfo=SaveBodyInfo+","+BodyInfo;
			}
		}
	}
	return SaveBodyInfo;
}


//****************************************************************
// Description: sInputString 为输入字符串?iType为类型?分别为
// 0 - 去除前后空格; 1 - 去前导空格; 2 - 去尾部空格
//****************************************************************
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}


//encode Chinese characters
function StringEncode(str)
{
	var ret = "";
	for(var i = 0; i < str.length; i ++)
	{
		ret += str.charCodeAt(i) + "."
	}
	return ret;
}

//decode  StringEncode
function StringDecode(str)
{
	var ret = "";
	if((str == "") || (str == null))
		return "";
		
	var objArry = str.split(".");
	for(var i = 0; i < objArry.length - 1; i ++)
	{
		ret += String.fromCharCode(objArry[i])
	}
	return ret;
}
 
 //format dade as "YYYY-MM-DD
 function FormatDateString(str)
 {
	 var objArryDate = str.split("/");
	var strDate = objArryDate[2] + "-" + objArryDate[1] + "-" + objArryDate[0];
	return strDate;
 }


