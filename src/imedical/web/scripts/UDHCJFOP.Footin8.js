
function BodyLoadHandler() 
{

	var obj=document.getElementById("BPrint");
	if (obj)
	{
		obj.onclick=Print_Click;
	}
	var obj=document.getElementById("BFind");
	if (obj)
	{
		obj.onclick=BFind_Click;
	}
	
	
	var obj=document.getElementById("FootStatus");
   	if (obj)
   	{
	   	obj.onclick=FootStatus_onclick;

   	}
   	
	InitDocument();
}

function FootStatus_onclick()
{
  	var obj=document.getElementById("FootStatus")
	if (obj.checked==true) 
	{
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
		SetUnFootFlag();
		GetInitDate();	
	}else{
		
		 SetFootFlag();		
		 
		 var rtn=GetFootDate();
		
		 if(rtn==1)
		 {
			var obj=document.getElementById("BFoot");
			if (obj)
			{	obj.disabled=false;
				obj.onclick=BFoot_Click;
			}	

		 }
		
		 BFind_Click();
	} 
}

function FootStatus_onchange()
{
  	SetFootStatus();
}

function BFoot_Click()
{
	
	var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;
	
	var UnFootUser=""
	var obj=document.getElementById('GetUnFootUser');
	if (obj) var encmeth=obj.value;
	if (encmeth) var UnFootUser=cspRunServerMethod(encmeth,StDate,EndDate);
	if (""!=UnFootUser)
	{
		var ary = UnFootUser.split("^")
		var alertInfo=t['UFUser']
		for (var i=0;i<ary.length;i++)
		{
			
			alertInfo=alertInfo+"\n"+ary[i];
		}
		//alert(alertInfo);
		
		var myrtn=confirm(alertInfo+"\n\n"+t['03']);
		if (myrtn==false){
			var obj=document.getElementById("BFoot");
			DHCWeb_DisBtn(obj);

			return;
		}
	
	}
	
	var listobj=document.getElementById("RepIdz"+1);
	if (listobj)
	{
		var rtn=DHCWebD_GetCellValue(listobj);
		if(rtn=="") return;
	}
	
	var obj=document.getElementById("TMPJID");
	if (obj) var TMPJID=obj.value; 
	
	var encmeth=""
	var obj=document.getElementById('FootHisId');
	if (obj) var encmeth=obj.value;
	if (encmeth) var myFootInfo=cspRunServerMethod(encmeth,TMPJID,session['LOGON.USERID']);
	var ary=myFootInfo.split("^");
	if(0==ary[0]){
		alert(t['FootOK']);
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
        var obj=document.getElementById("BPrint");
		if (obj)
		{	obj.disabled=false;
			obj.onclick=Print_Click;
		}
	}
	else{
		alert(t['FootFailure'])
		//var obj=document.getElementById("BFoot");
		//DHCWeb_DisBtn(obj);

		return; 
	}
	
}

function BFind_Click()
{

	var StatFlag="N";
	var BFootFlag="N"
	var obj=document.getElementById("FootStatus")
	if (obj.checked==true)  StatFlag="Y";
	//alert(StatFlag)
	if(StatFlag=="N")
	{
		var rtn=GetFootDate();
		
		if(rtn==1)
		{
			var obj=document.getElementById("BFoot");
			if (obj)
			{	obj.disabled=false;
				obj.onclick=BFoot_Click;
			}	
			BFootFlag="Y"
		}
	}
	
	var StDate="",StartTime="",EndDate="",EndTime="";
	var obj=document.getElementById("EndDate")
	if (obj){ var EndDate=obj.value; }
	var obj=document.getElementById("StDate")
	if (obj){ var StDate=obj.value; }
	var obj=document.getElementById("StartTime")
	if (obj){ var StartTime=obj.value; }
	var obj=document.getElementById("EndTime")
	if (obj){ var EndTime=obj.value; }
	var obj=document.getElementById("TMPJID")
	if (obj){ var TMPJID=obj.value; }
	

	
	
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.Footin8&TMPJID="+TMPJID+"&EndDate="+EndDate+"&StDate="+StDate+"&StartTime="+StartTime+"&EndTime="+EndTime+"&StatFlag="+StatFlag+"&BFootFlag="+BFootFlag;
    //alert(lnk)
  	document.location.href=lnk;

	
}

function InitDocument()
{	
	
	var obj=document.getElementById("StatFlag")
	if ("Y"==obj.value)
	{
		var obj=document.getElementById("FootStatus")
		obj.checked=true;

	}else{
		
		SetFootFlag();
	}
	
	
	var obj=document.getElementById("BFootFlag");
	if (obj.value=="Y") 
	{
		var obj=document.getElementById("BFoot");
		if (obj)
		{	obj.disabled=false;
			obj.onclick=BFoot_Click;
		}
		SetFootFlag();
		var obj=document.getElementById("BPrint");
		DHCWeb_DisBtn(obj);
	}else{
	
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
        var obj=document.getElementById("BPrint");
		if (obj)
		{	obj.disabled=false;
			obj.onclick=Print_Click;
		}
	}
	var listobj=document.getElementById("TTMPJIDz"+1);
	if (listobj)
	{
		var myval=DHCWebD_GetCellValue(listobj);
		var obj=document.getElementById("TMPJID");
		if (obj) obj.value=myval; //alert(obj.value)
	}


}

function GetFootDate()
{
	var Expr=""
	var obj=document.getElementById('getFootDate');
	if (obj) var encmeth=obj.value;
	if (encmeth) var rtn=cspRunServerMethod(encmeth,Expr);
	var ary = rtn.split("^")
	var obj=document.getElementById('StDate');
	if (obj) obj.value=ary[0];
	var obj=document.getElementById('StartTime');
	if (obj) obj.value=ary[1];
	
	return ary[2]
}

function GetInitDate()
{
	var Expr=""
	var obj=document.getElementById('getInitDate');
	if (obj) var encmeth=obj.value;
	if (encmeth) var rtn=cspRunServerMethod(encmeth);
	
	var ary = rtn.split("^")
	var obj=document.getElementById('StDate');
	if (obj) obj.value=ary[0];
	var obj=document.getElementById('StartTime');
	if (obj) obj.value=ary[1];
	
	
}


function SetFootFlag(){
	SetImgStyle("CompId","StDate",true);
	SetImgStyle("CompId","EndDate",true);
	SetItemStyle("StartTime",true);
	SetItemStyle("EndTime",true);
}

function SetUnFootFlag(){
	SetImgStyle("CompId","StDate",false);
	SetImgStyle("CompId","EndDate",false);
	SetItemStyle("StartTime",false);
	SetItemStyle("EndTime",false);
}

function SetImgStyle(CompId,ItemName,flag)
{
	var obj=document.getElementById(CompId);
    if(obj)
    {
		var ItemObj =document.getElementById(ItemName);
		var ImgObj=document.getElementById("ld"+obj.value+"i"+ItemName);
		if(flag) 
		{
			ImgObj.style.display="none";
			//ItemObj.readOnly=true;	
			ItemObj.disabled=true;
		}else{
			 ImgObj.style.display="";
	 		 //stdateobj.readOnly=false;
			 ItemObj.disabled = false;
			
		}
	
	}
	
}

function SetItemStyle(ItemName,flag)
{
	var obj=document.getElementById(ItemName);
    if(obj)
    {
		 obj.disabled = flag;
    }
}

function SetFootStatus()
{
	var obj=document.getElementById("FootStatus")
	if (obj.checked==true) 
	{
		var obj=document.getElementById("BFoot");
		DHCWeb_DisBtn(obj);
		SetUnFootFlag();
	}else{
		/*
		var obj=document.getElementById("BFoot");
		if (obj)
		{	obj.disabled=false;
			obj.onclick=BFoot_Click;
		}
		*/
		SetFootFlag();
		BFind_Click();

	} 

	
	
}

function GetUserInfoByUserCode(value)
{	
	var str=value.split("^");
	var obj=document.getElementById("OperName");
	if (obj) obj.value=str[0]
	var obj=document.getElementById("UserRowId");
	if (obj) obj.value=str[2]
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=str[3]
	
}


function Print_Click()
{
	PrintClickHandler();
	
}

function PrintClickHandler()
{
	try{
		var encmeth=""
		var obj=document.getElementById('GetRepPath');
		if (obj) encmeth=obj.value;
		if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
		
		var StDate="",EndDate="",StartTime="",EndTime="",CurDate="";
		var obj=document.getElementById("StDate");
		if (obj) StDate=obj.value;
		var obj=document.getElementById("EndDate");
		if (obj) EndDate=obj.value;
		var obj=document.getElementById("StartTime");
		if (obj) StartTime=obj.value;
		var obj=document.getElementById("EndTime");
		if (obj) EndTime=obj.value;
		var obj=document.getElementById("CurDate");
		if (obj) CurDate=obj.value;
		
		encmeth=""
		var obj=document.getElementById("DateTrans");
		if (obj) encmeth=obj.value;
		
		//if (""!=StDate) StDate=cspRunServerMethod(encmeth,StDate)
		//if (""!=EndDate) EndDate=cspRunServerMethod(encmeth,EndDate)
		var RepDate=StDate+" "+StartTime+t["zhi"]+EndDate+" "+EndTime
		//alert(StDate+"   "+EndDate+"   "+StartTime+"   "+EndTime+"   "+CurDate)
		
		var OperName=""
		var obj=document.getElementById("OperName");
		if (obj) OperName=obj.value;
		
		var ZBR=session['LOGON.USERNAME'];
		

		var Template=TemplatePath+"JFOP_BJZYYFootRep.xls";
		
		encmeth=""
		var obj=document.getElementById('TMPJID')
		if (obj) var jid=obj.value; 
		var obj=document.getElementById("GetRowNum");
		if (obj) encmeth=obj.value; 
		var Rows=parseInt(cspRunServerMethod(encmeth,jid));
		//alert("Rows"+Rows)
		//OutPutExel
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		//Title
		//var obj=document.getElementById('HeadTitle');
	  	//if (obj) xlsheet.cells(1,2)=obj.value;

		xlsheet.cells(2,8)=RepDate;
		
		var xlsRow=4;
		var xlsCol=0;
		//Data
		//(TNo,TUserCode,TUserName,TGetNum,TGetSum,TRefundNum,TRefundSum,TAbortNum,TAbortSum,TAdmitNum,TCancelNum,TDischargeNum,TPrepayGetNum,TPrepayGetSum,TPrepayRefundNum,TPrepayRefundSum,TPrepayGiveNum,TPrepayGiveSum,JID)
		for (var i=1; i<=Rows; i++)
		{ 
			encmeth="";
			var obj=document.getElementById("ReadPrtData");
			if (obj) var encmeth=obj.value;
			
			var RowStr=cspRunServerMethod(encmeth,jid,i-1);
		
			var ary=RowStr.split("^");
			var Cols=ary.length; 
			/*
			xlsheet.cells(xlsRow+i,xlsCol+1)=ary[3];
			//xlsheet.cells(xlsRow+i,xlsCol+2)=ary[10];
			//xlsheet.cells(xlsRow+i,xlsCol+3)=ary[11];
			xlsheet.cells(xlsRow+i,xlsCol+2)=ary[13];
			xlsheet.cells(xlsRow+i,xlsCol+3)=ary[14];
			xlsheet.cells(xlsRow+i,xlsCol+4)=ary[17];
			xlsheet.cells(xlsRow+i,xlsCol+5)=ary[18];

			xlsheet.cells(xlsRow+i,xlsCol+6)=ary[6];
			xlsheet.cells(xlsRow+i,xlsCol+7)=ary[7];
			xlsheet.cells(xlsRow+i,xlsCol+8)=ary[8];
			xlsheet.cells(xlsRow+i,xlsCol+9)=ary[9];
			*/	
			
			for (var j=1; j<Cols; j++)
			{
				xlsheet.cells(xlsRow+i,xlsCol+j)=ary[j];
			}
		}
		
		gridlist(xlsheet,xlsRow,xlsRow+i-1,1,Cols-1);
		
		//Other
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["zbr"];
		xlsheet.cells(xlsRow+i,xlsCol+2)=ZBR;
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["shr"];
		xlsheet.cells(xlsRow+i,xlsCol+9)=t["bt"];
		xlsheet.cells(xlsRow+i,xlsCol+11)=CurDate+"    ";

		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["JKR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["QZ"];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["SHR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["KJS"];
		//OutPutExcel
		xlsheet.printout; 
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;

		
	} catch(e){
			alert(e.message);
		};
	
	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}


function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function UnloadHandler()
{	
	
	var myEncrypt=DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID=DHCWebD_GetObjValue("TMPJID");
	if (myEncrypt!="")
	{
		var mytmp=cspRunServerMethod(myEncrypt, myTMPGID);
	}
	
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler