//DHCRisBooked.js

var gSchudleRowid="";
var gPrintTemplate="";
var UpdateBookInfo="";
var DBBookedFlag="";
var IsPrint="";
var gBookDate,gBookTime,gBookResource;
var SelectedRow="-1"


var $=function(Id){
	return document.getElementById(Id);
}
//alert("Load-00")
function BodyLoadHandler()
{
	//alert("Load-1")	
	var BookingObj=document.getElementById("Booking");
	if (BookingObj)
	{
		BookingObj.onclick=Booking_click;
	}
	//alert("Load-2")
	//��ȡ����ID 
	GetLocId();
	
	//��ѯ��Դ��Ϣ
	GetResource();
	
	
	//��ȡ��ǰ����
	var BookedDateObj=document.getElementById("BookDate");
	if (BookedDateObj)
	{
		if (BookedDateObj.value=="")
			BookedDateObj.value=DateDemo();
	}
	//alert("Load-3")
    GetLocPrintTemplate();
    
    var BookedObj=document.getElementById("BookedPrint");
	if ( BookedObj)
	{
		 BookedObj.onclick= BookedObj_click;
	}
	//alert("Load-4")
	//��ɫ��ʾ��ǰ��ԤԼ��¼
    InitCarrentBooked();
   // alert("Load-5")
	GetSelect();
	//alert("Load-6")
	var obj=document.getElementById("Query");
	if (obj) obj.onclick=FindClickHandler;
	
	document.getElementById("IsPrint").checked=true;
	//alert("Load-7")
	var Isobj=document.getElementById("IsView");
	if (Isobj)
	{
	   Isobj.onclick=IsViewCheckClick;
	}
	//alert("Load-8")
}

function FindClickHandler(e)
{
    document.getElementById("Flag").value=0;
    //alert("1-1")
	return  Query_click();
}

function GetLocId()
{
	var LocID=document.getElementById("LocId");
    if (LocID.value=="")
    {
       var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	   var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	   if (Getlocicvalue=="")
         LocID.value=session['LOGON.CTLOCID'];
       else 
 		 LocID.value=Getlocicvalue;
	}
}

function GetSelect()
{
	var ResourceIdObj=document.getElementById("ResourceId");
	if(ResourceIdObj)
	{
		var ResourceObj=document.getElementById("Resource");
	    if (ResourceObj.options.length>0)
	 	{
			 for (var i=ResourceObj.options.length-1; i>=0; i--)
			 {
				if(ResourceIdObj.value == ResourceObj.options[i].value)
				{
					ResourceObj.selectedIndex = i;
			    }
		     }
	     }
    }
}

function GetResource()
{
	var ResourceObj=document.getElementById("Resource");
    if (ResourceObj)
    {
	 	combo("Resource");
	 	var LocId=document.getElementById("LocId").value;
		var GetWeekInfoFunction=document.getElementById("GetResourceInfo").value;
		var Info1=cspRunServerMethod(GetWeekInfoFunction,LocId);
    	AddItem("Resource",Info1);
    	ResourceObj.onchange=changeResource;
    }
	
}

function changeResource()
{
	var ResourceObj=document.getElementById("Resource");
	if (ResourceObj)
	{
		document.getElementById("ResourceId").value=ResourceObj.value; 
		SelResourceObj=document.getElementById("SelResource");
		if (SelResourceObj)
		{
			SelResourceObj.value=ResourceObj.text;
		}
		Query_click();
 	}
}


/*function GetResource()
{
	var SelResource="";
	SelResourceObj=document.getElementById("SelResource");
	if (SelResourceObj)
	{
		SelResource=SelResourceObj.value;
	}
 
  	var ResourceObj=document.getElementById("Resource");
   	if (ResourceObj)
   	{
 		combo("Resource");
 		var LocId=document.getElementById("LocId").value;
		var GetWeekInfoFunction=document.getElementById("GetResourceInfo").value;
		var Info1=cspRunServerMethod(GetWeekInfoFunction,LocId);
   		AddItem("Resource",Info1);
      	ResourceObj.onchange=onChangeResource; 
      	
      	var ResourceIdObj=document.getElementById("ResourceId");
		if (ResourceIdObj)
		{
			ResourceObj.value=ResourceIdObj.value; 
 		}
 		
  		ResourceObj.text=SelResource;
      	
     	
  	}
}

function onChangeResource()
{
	var ResourceObj=document.getElementById("Resource");
	if (ResourceObj)
	{
		document.getElementById("ResourceId").value=ResourceObj.value; 
 	}
}*/


function Booking_click()
{
	// ѡ��ԤԼ��ҽ��
	var PreRecLocId="",CurrentRecLocId="";
	var IsAllow="Y";
	
	var OrditemRowid="";
	var BOrditemRowid="";
	var BookInfo="";
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisBooked');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var USERID=session['LOGON.USERID'];
	  
    var orddoc=parent.parent.frames["DHCRisWorkBench"].document;
    
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    if (ordtab) 
    {
	   for (var i=1; i<ordtab.rows.length; i++)
       {
	     var selectedobj=orddoc.getElementById("TSelectedz"+i);
         if ((selectedobj)&&(selectedobj.checked))
         {
	         CurrentRecLocId=orddoc.getElementById("RecLocIdz"+i).value;
	         
	         if ((PreRecLocId!="")&&(PreRecLocId!=CurrentRecLocId))
	         {
		          IsAllow="N";
	         }
	         
	        
		     PatientStatusCode=orddoc.getElementById("OEORIItemStatusz"+i).value;
		     TotalFee=orddoc.getElementById("TotalFeez"+i).innerText;
		     TBillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		     ARCIMDesc=orddoc.getElementById("ARCIMDescz"+i).innerText;
		     RegisterStatus=orddoc.getElementById("TStatusz"+i).innerText;
		     
		   
		     var PatientName=orddoc.getElementById("TPatientNamez"+i).innerText;
			 var PatientID=orddoc.getElementById("PatientIDz"+i).innerText;
			 var Sex=orddoc.getElementById("TSexz"+i).innerText;
			 var WardName=orddoc.getElementById("WardNamez"+i).innerText;
			 var bedNo=orddoc.getElementById("TBedCodez"+i).innerText;
			 var RecLoc=orddoc.getElementById("RecLocz"+i).innerText;
			 var strOrderName=orddoc.getElementById("ARCIMDescz"+i).innerText;
			 var BookedDate=orddoc.getElementById("TBookedDatez"+i).innerText;
			 var BookedTime=orddoc.getElementById("TBookedTimez"+i).innerText;
			 var Address=GetLocAddress(CurrentRecLocId);
			 var ItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
			 var PaadmDR=orddoc.getElementById("EpisodeIDz"+i).value;
			 
			 var BInfo=ItemID+"^"+PatientName+"^"+strOrderName
			     BInfo=BInfo+"^"+BookedDate+"^"+BookedTime+"^"+session['LOGON.USERID'];
			 
		     if((TBillStatus=='���շ�')&(TotalFee==0))
		     {
			     ConFlag=confirm('ҽ��'+ARCIMDesc+'���շ�,���Ǽ۸�Ϊ���Ƿ����');
			     if (ConFlag==false){return}
			 }
     	     if ((PatientStatusCode!="A")&&(PatientStatusCode!="B"))
		     {
			     alert("�˲��˵�ҽ������ԤԼ����ȷ�ϼ����Ŀ�Ƿ��������ԤԼ״̬");
			     return;
		     }
		 
		     //if(PatientStatusCode=="B")||(PatientStatusCode=="I")
		     if((PatientStatusCode=="B"))
		     {
			    if (BOrditemRowid=="")
		        {
			       BOrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		        }
		        else
		        {
			       BOrditemRowid=BOrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
			    }
			    
			    if(BookInfo=="")
			    {
				   BookInfo=BInfo; 
				}
				else
				{
				   BookInfo=BookInfo+"@"+BInfo;
				}    
			 }
			 
		     if (OrditemRowid=="")
		     {
			     OrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		     }
		     else
		     {
			     OrditemRowid=OrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
		     }
		     PreRecLocId=CurrentRecLocId;
		     
       	  }
    	}
    }
   
    if ((OrditemRowid=="")&(BOrditemRowid==""))
    {
	    alert("��ѡ��ҽ����Ŀ");
	    return;
    }	
    if (IsAllow=="N")
    {
	    alert("��ִͬ�п��ҿƵ�ҽ������һ��ԤԼ!");
	    return ;
    }
  	
  	///�ڹ��б�����ж�����ע��
  	/*var IsSerGroup=SameServiceGroup(OrditemRowid);
  	if(IsSerGroup=="N")
  	{
	    alert("��ͬ�����鲻��һ��ԤԼ!");
	    return ;	
	}*/
	
  	//�ж��Ƿ�ԤԼʱ���ͻ
  	var BookedConflictFun=document.getElementById("BookedConflict").value;
  	//alert(PaadmDR);
  	//alert(gSchudleRowid);
  	var rets=cspRunServerMethod(BookedConflictFun,PaadmDR,gSchudleRowid);
  	if (rets!="")
  	{
	    ConFlag=confirm('�ò����� '+rets.split("^")[5]+rets.split("^")[2]+' ����ԤԼ,�Ƿ����');
	    if (ConFlag==false){return;}	
	}
	
  	//�����תԤԼ��ҽ����ȡ��ԤԼ�ڵ���ԤԼ����
  	//sunyi 2012-01-08
  	DBBookedFlag="";
  	if(BOrditemRowid!="")
  	{
	  	ConFlag=confirm('ѡ�е�ҽ��: '+'��ԤԼ,�Ƿ�תԤԼ!');
	    if (ConFlag==false){return}
  	    CancelBooking(BOrditemRowid);
  	    DBBookedFlag="Y";
  	}
  	
	if (gSchudleRowid!="")
	{
	    //var OrditemRowid=document.getElementById("OrditemRowid").value;
	    //var Info=OrditemRowid+"^"+gSchudleRowid+"^1^^"+USERID;
	    var Info=OrditemRowid+"^"+gSchudleRowid+"^"+"1^^"+$('LocId').value+"^"+$('PaadmDR').value+"^"+gBookDate+"^"+USERID;
	    //alert(Info);
		var InsertBookInfoFunction=document.getElementById("InsertBookInfo").value;
		var ret=cspRunServerMethod(InsertBookInfoFunction,Info);
		var ret1=ret.split("^")[0]
	    var ret2=ret.split("^")[1]  //��Ϣƽ̨���÷���ֵ
	    if (ret1=="-1000")
	    {
		    alert("����Ŀ����ҪԤԼ");
		    return ;
	    }
	    if(ret1=="-999")
	    {
		    alert("�˲�����Ƿ�Ѳ���ԤԼ!");
		    return;
		}
	    
	    if(ret2!="0")
	    {
		    var ErrorInfo="����ƽ̨��Ϣʧ��="+ret2
		    alert(ErrorInfo);
		}
		if (ret1!="0")
		{
			var ErrorInfo="����̨ԤԼ����,�޷�ԤԼ";
			alert(ErrorInfo);
		}
		else 
		{
			if (document.getElementById("IsPrint").checked)
	            IsPrint="Y";
	         else
	            IsPrint="N";
	            
			alert("ԤԼ�ɹ�!");
			
			///�����תԤԼҪ�����ڷ���Ϣ
			/*if (DBBookedFlag=="Y")
			{
			  SendMessage(BInfo,UpdateBookInfo);
			}*/
			
			//alert("1");
			OrditemSelected();
			//alert("2");
			if ((gPrintTemplate!="")&(IsPrint=="Y"))
			{
	           OnPrint(OrditemRowid);  
			}
			
			
			
			/*var regNo=orddoc.getElementById("RegNo").value;
	      
			var Name=orddoc.getElementById("Name").value;
			var StdDate=orddoc.getElementById("StdDate").value;
	
			var enddate=orddoc.getElementById("enddate").value;
			var Status=orddoc.getElementById("Status").value;
			var StatusCode=orddoc.getElementById("StatusCode").value;
			
		
			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisWorkBenchEx&BookedType=1&RegNo="+regNo+"&Name="+Name+"&StdDate="+StdDate+"&enddate="+enddate+"&StatusCode="+StatusCode+"&Status="+Status;
    		parent.frames['DHCRisWorkBench'].location.href=lnk;
            
            Query_click();*/
            
		
		}
		
		
	}
	else
	{
		alert("��ѡ��ԤԼ��Դ");
	}
	
}


function OrditemSelected()
{
	orddoc=parent.parent.frames["DHCRisWorkBench"].document;
    var objtbl=orddoc.getElementById('tDHCRisWorkBenchEx');
    var rows=objtbl.rows.length;
    for (i=1;i<rows;i++)
    {
	   var selectedobj=orddoc.getElementById("TSelectedz"+i);
	   if (selectedobj.checked)
	   {
          orddoc.getElementById("TStatusz"+i).innerText="ԤԼ";
          orddoc.getElementById("OEORIItemStatusz"+i).value="B";
          orddoc.getElementById("BookedResz"+i).innerText=gBookResource;
          orddoc.getElementById("TBookedDatez"+i).innerText=gBookDate;
          orddoc.getElementById("TBookedTimez"+i).innerText=gBookTime;
	   }
    }
}



function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[0],perInfo[1]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisBooked');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
    if (!selectrow) return;
    
	if (SelectedRow!=selectrow)
	{  
	    for (i=1;i<rows;i++)
	    {
		    var selectedobj=$("Selectz"+i);
		    if (selectrow!=i)
		    {
			   selectedobj.checked=false;
		    }
		   
	        if ((selectedobj)&&(selectedobj.checked))
	        {
		        
		        var gMaxNumber=$("TMaxNumberz"+i).innerText;
		            gMaxNumber=Number(gMaxNumber);
		            
		        var gUseNumber=$("UseNumberz"+i).innerText;
		            gUseNumber=Number(gUseNumber);
		        var remainTime=$("TremainTimez"+i).innerText;
		        
		        var gManualNumber=$("ManualNumberz"+i).innerText;
		            gManualNumber=Number(gManualNumber);
		            
		        var gManuRemainNumber=$("ManuRemainNumberz"+i).innerText;
		            gManuRemainNumber=Number(gManuRemainNumber);
				if ( remainTime="")
				{
					if(gManualNumber==0)
		            {
			             alert("����̨���ԤԼ��Ϊ0����ԤԼ!");
			             return;
			        }
			        if(gManuRemainNumber==0)
			    	{
				    	alert("����̨���ԤԼʣ����Ϊ0����ԤԼ!");
			            return;
					}
		            if(gMaxNumber==0)
		            {
			             alert("���ԤԼ��Ϊ0����ԤԼ!");
			             return;
			        }
			        if(gMaxNumber<=gUseNumber)
			    	{
				    	var ConFlag=confirm('�ѳ�����Դ���ԤԼ��,�Ƿ����ԤԼ!');
				    	if (ConFlag==false){return} 
					}
				}
				else
				{
					if (remainTime=0)
					{
						var ConFlag=confirm('��û��ʱ��ԤԼ,�Ƿ����ԤԼ!');
				    	if (ConFlag==false){return}
					}
				}
			    
			    
		        gSchudleRowid=$("ResSchudleRowidz"+i).value;
		        //alert(gSchudleRowid)
		       	gBookDate=$("TBookDatez"+i).innerText;
		        gBookTime=$("TStartTimez"+i).innerText;
		        gBookResource=$("TResourcez"+i).innerText;
	     
		        UpdateBookInfo=gBookDate+"^"+gBookTime;
		        
		        SelectedRow = selectrow;
		        document.getElementById("Booking").style.display='';
		    }
		    

	    }
  }
  else
  {
	 SelectedRow="-1"
	 $('PaadmDR').value="";
	 $('LocId').value="";
	 $('OrditemRowid').value="";
	 gBookDate="";
     gBookTime="";
     gBookResource="";
     document.getElementById("Booking").style.display='none';
  }
       
}


function DateDemo()
{
   var d, s="";           // ��������?
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			// ��ȡ��?
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;		// ��ȡ�·�?
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getYear();		// ��ȡ���?
   s = sDay + "/" + sMonth + "/" + sYear;
   return(s); 
   
}

function getRelaDate(offset)
{
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
	if (day<10) day="0"+day;
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	return day+sep+mon+sep+year

}

//��ȡԤԼģ��
//sunyi
function GetLocPrintTemplate()
{
   var locdr=document.getElementById("LocId").value;
   var GetRegTempFunction=document.getElementById("GetLocPrintTemp").value;
   gPrintTemplate=cspRunServerMethod(GetRegTempFunction,locdr);	
}


function PrintBookedBill(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
} 

function GetLocAddress(locId)
{
   var GetLocAddress=document.getElementById("GetLocAddress").value;
   var Address=cspRunServerMethod(GetLocAddress,locId);	
   return Address	
}


// ����ԤԼ��
function BookedObj_click()
{
	var OrditemRowid="";
	var Status;

    var orddoc=parent.parent.frames["DHCRisWorkBench"].document;
    
  	var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    if (ordtab) 
    {
	   for (var i=1; i<ordtab.rows.length; i++)
       {
		     var selectedobj=orddoc.getElementById("TSelectedz"+i);
	         if ((selectedobj)&&(selectedobj.checked))
	         {
		          Status=orddoc.getElementById("TStatusz"+i).innerText;
		          ExterStatus=orddoc.getElementById("ExterBKz"+i).innerText;
		          if(ExterStatus=="Y")
		          {
			          alert("�����ⲿԤԼҽ�����ܴ�ӡ!");
			          return;
			      }
		          if(Status!="ԤԼ")
                  {
	                alert("����ԤԼ״̬���ܴ�ӡ��");
	                return;  
	              }
	              
	              if (OrditemRowid=="")
		          {
			         OrditemRowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		          }
		          else
		          {
			         OrditemRowid=OrditemRowid+"@"+orddoc.getElementById("OEOrdItemIDz"+i).value;
		          }
		          
	         }
       }
       
       
       if (OrditemRowid=="")
       {
	      alert("��ѡ��ҽ����Ŀ");
	      return;
       }
       
       //���ô�ӡ����
       OnPrint(OrditemRowid);
    }          

}


function CancelBooking(BOrditemRowid)
{
	var GetCancelFunction=document.getElementById("GetCancelFunction").value;
	var ret=cspRunServerMethod(GetCancelFunction,BOrditemRowid);
	var ret1=ret.split("^")[0]
	var ret2=ret.split("^")[1]  //��Ϣƽ̨���÷���ֵ
	
	if(ret2!="0")
	{
	    var ErrorInfo="ȡ��ԤԼ����ƽ̨��Ϣʧ��="+ret2
		alert(ErrorInfo);
    }
	if (ret1!="0")
	{
		var ErrorInfo="ȡ��ԤԼʧ��="+ret1
		alert(ErrorInfo);
		return;
	}
}


function SameServiceGroup(OrditemRowid)
{
   var SameServiceGroupFun=document.getElementById("SameServiceGroupFun").value;
   var value=cspRunServerMethod(SameServiceGroupFun,OrditemRowid);
   return value;	
}


function OnPrint(OrditemRowid)
{
	if(OrditemRowid!="")
	{
		var UserID=session['LOGON.USERID'];
	    //var nums=OrditemRowid.split("@").length;
  
	    var SameStudyNoFun=document.getElementById("SameItemGroupFun").value;
	    var SameGroup=cspRunServerMethod(SameStudyNoFun,OrditemRowid);
	    var nums=SameGroup.split("^").length;   
	    
        for (var i=0;i<nums;i++)
 	    {
		   var OrditemID=SameGroup.split("^")[i];
		   var GetBookedPrintFun=document.getElementById("GetBookedPrintFun").value;
	       var value=cspRunServerMethod(GetBookedPrintFun,OrditemID);
	      
	       if(value=="")
	       {
		       alert("ҽ����Ŀ���ݳ����ܴ�ӡ��");
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
		       ItmDoc=Item[18];
		            
		   }
	       	
	       var OEorditemID1=OrditemID.split("||")[0]+"-"+OrditemID.split("||")[1];
	       
	       DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
		
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
		   MyPara=MyPara+"^ItmDoc"+String.fromCharCode(2)+ItmDoc;
		   
		   PrintBookedBill(MyPara,"");
		  
		    /*if (value!="")
	       {
		       Item=value.split("^");
		       
		       RecLocdr=Item[0];
		       RegNo=Item[1];
		       Name=Item[2];
		       SexDesc=Item[3];
		       strAge=Item[4];
		       wardname=Item[5];
		       bedname=Item[6];
		       RecLocDesc=Item[7];
		       AppointDate=Item[8];
		       AppointTime=Item[9];
		       ResDesc=Item[10];
		       Address=Item[11];
		       Memo=Item[12]; 
		       BookedNo=Item[13];
               EndTime=Item[14];
		       ItmDoc=Item[15]; 
		       Diagnose=Item[16];      
		   }
	       	
	       	DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
	       //var OEorditemID1=OrditemID.split("||")[0]+"-"+OrditemID.split("||")[1];
	       DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate)
		   var MyPara="PatientName"+String.fromCharCode(2)+Name;
		   //MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+"*"+OEorditemID1+"*";
                   RegNo="*"+RegNo+"*";
		   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
		   //MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+AppointDate+" "+AppointTime;
           MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+AppointDate+" "+AppointTime+"��"+EndTime;
		   MyPara=MyPara+"^LocDesc"+String.fromCharCode(2)+RecLocDesc;
		   MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
		   MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+Diagnose;
		  
		   MyPara=MyPara+"^Age"+String.fromCharCode(2)+strAge;
		   MyPara=MyPara+"^SexDesc"+String.fromCharCode(2)+SexDesc;
		   MyPara=MyPara+"^WardName"+String.fromCharCode(2)+wardname;
		   MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+bedname;
		   MyPara=MyPara+"^Memo"+String.fromCharCode(2)+Memo;
		   MyPara=MyPara+"^BookedNo"+String.fromCharCode(2)+BookedNo;
           MyPara=MyPara+"^ItmDoc"+String.fromCharCode(2)+ItmDoc;
		   //alert(MyPara);
		   PrintBookedBill(MyPara,"");*/
		   
		   
		  	
 	    }
	   
	}
	   
}


function SendMessage(BInfo,UpdateBookInfo)
{
	 var SendMessageFun=document.getElementById("SendMessage").value;
	 var value=cspRunServerMethod(SendMessageFun,BInfo,UpdateBookInfo);
}


//��ɫ��ʾ��ǰ��ԤԼ��¼
function InitCarrentBooked()
{
	var tbl=document.getElementById("tDHCRisBooked");
	var row=tbl.rows.length;
	row=row-1;
	var getSchduleID=GetSchduleID();
	
	document.getElementById("Booking").style.display='none';
	
	for (var j=1;j<row+1;j++)
	{
		var SelSchduleID=$("ResSchudleRowidz"+j).value;
			
		if (gSchudleRowid=="")
		{
		   gBookDate=$("TBookDatez"+j).innerText;
		   gSchudleRowid=SelSchduleID
		}
		if (getSchduleID==SelSchduleID)
		{
           tbl.rows[j].style.backgroundColor="#FF99FF";	
           var selectedobj=$("Selectz"+j);
           selectedobj.checked=true;
           document.getElementById("Booking").style.display='';
       
		}
		
    }
	
}

function GetSchduleID()
{
	 var value=""
	 var  OEOrdItemDr=$("OrditemRowid").value;
	 if (OEOrdItemDr!="")
	 {
	    var SchduleIDFun=$("GetSchduleID").value;
	    value=cspRunServerMethod(SchduleIDFun,OEOrdItemDr);
	 }
	 
	 return value;
}

function IsViewCheckClick()
{
	if (document.getElementById("IsView").checked)
    {
      document.getElementById("IsViewFlag").value=1
      //alert(document.getElementById("IsViewFlag").value)
    }
    else
    {
	  document.getElementById("IsViewFlag").value=0
	  //alert(document.getElementById("IsViewFlag").value)
	}
	
	//FindClickHandler;
	document.getElementById("Flag").value=0;
	return  Query_click();
}
document.body.onload = BodyLoadHandler;


