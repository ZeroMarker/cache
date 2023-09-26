
//名称	DHCPERecPaper.js
//组件  DHCPERecPaper
//功能	收表
//创建	2018.09.13
//创建人  xy

function BodyLoadHandler(){
	var obj; 
	
	$("#ConfirmRecPaper").keydown(function(e) {
			
			if(e.keyCode==13){
				ConfirmRecPaper_KeyDown();
				}
		});
	
	 
	if (obj){obj.onfocus=txtfocus;}

	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	
	obj=document.getElementById("BPrint");
	if (obj){ obj.onclick=BPrint_click; }	
	
	$("#txtRegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNo_KeyDown();
				}
	});
	

	obj=document.getElementById("BCancelRecPaper");
	if (obj){ obj.onclick=BCancelRecPaper_click; }
	 
	 $("#ALLPerson").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#ALLGroup").checkbox('setValue',false);}
	       	 		        
        	}
        });
		
    $("#ALLGroup").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#ALLPerson").checkbox('setValue',false);}
	       	 		        
        	}
        }); 


	
	websys_setfocus("ConfirmRecPaper"); 
} 


function txtfocus()
{
    var obj;
	obj=document.getElementById("ConfirmRecPaper");
	/*active 代表输入法为中文
	inactive 代表输入法为英文
	auto 代表打开输入法 (默认)
	disable 代表关闭输入法
	*/
if(obj.style.imeMode ==  "disabled")
{                       
 }
else
{                      
	
	obj.style.imeMode   =   "disabled";    
	           
}      
 
}

function BCancelRecPaper_click() {
	if (selectrow==-1) { 
	$.messager.alert("提示","请选择待取消收表的客户","info");
	return;}
	
	var objtbl = $("#tDHCPERecPaper").datagrid('getRows');
    var iPIADM=objtbl[selectrow].PIADM;
	if (iPIADM=="")	{
		$.messager.alert("提示","请选择待取消收表的客户","info");
		return false
	} 
	else{ 
	
		if (confirm(t['02'])) {
			var Ins=document.getElementById('CancelRecPaper');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,iPIADM)
			if(flag=="-1"){alert("未收表不能取消");}
			else if (flag=='0') {alert("操作成功");}
			else{
				alert(t['03']+flag)
			}
		location.reload();
		}
	}
}

function BFind_click() {  

 	var iRecBegDate=getValueById("RecBegDate");
 	
 	var iRecEndDate=getValueById("RecEndDate");
 	
 	var iArrivedFlag=getValueById("ArrivedFlag");
 	if(iArrivedFlag){var iArrivedFlag=1;}
 	else{iArrivedFlag=0;}
 	
  	var iALLPerson=getValueById("ALLPerson");
  	if(iALLPerson){var iALLPerson=1;}
  	else{var iALLPerson=0;}
  	
 	var iALLGroup=getValueById("ALLGroup");
 	if(iALLGroup){var iALLGroup=1;}
 	else{var iALLGroup=0;}
 	
 	var iVIPLevel=getValueById("VIPLevel");
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	var iRegNo=getValueById("txtRegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}

 	$("#tDHCPERecPaper").datagrid('load',{ComponentID:56131,RecBegDate:getValueById("RecBegDate"),RecEndDate:getValueById("RecEndDate"),txtRegNo:getValueById("txtRegNo"),ArrivedFlag:$('#ArrivedFlag').attr("checked"),VIPLevel:getValueById("VIPLevel"),ALLPerson:$('#ALLPerson').attr("checked"),ALLGroup:$('#ALLGroup').attr("checked")})
	/*
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPERecPaper"
			+"&RecBegDate="+iRecBegDate
			+"&RecEndDate="+iRecEndDate 
			+"&txtRegNo="+iRegNo
			+"&ArrivedFlag="+iArrivedFlag
			+"&VIPLevel="+iVIPLevel
			+"&ALLPerson="+iALLPerson
			+"&ALLGroup="+iALLGroup
			;
			//alert(lnk)
	
	window.location.href=lnk; 
	*/
} 

function RegNo_KeyDown()
{
		BFind_click(); 
}



function ConfirmRecPaper_KeyDown()
{
	
	var iReportDate="",iRegNo="";
	
		obj=document.getElementById("ConfirmRecPaper"); 
		if (obj){ iRegNo=obj.value; }
		
	  if (iRegNo=="") 
	   {
		    alert("请输入登记号");
		   return false;
	   }
		var PADMS=tkMakeServerCall("web.DHCPE.PreIADMEx","GetNoRecPaperRecord",iRegNo);
		if (PADMS.split("^")[0]!="0"){
			alert(PADMS.split("^")[1]);
			return false;
		}
		var PADM=PADMS.split("^")[1];
		if (PADM==""){
		    alert("没有要收表的记录");
			return false;
			}
		var PADMArr=PADM.split("$");
		if (PADMArr.length>2){
           
			var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESelectPIADMRecord&PIADMs="+PADM;
	        //window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10')
			websys_lu(lnk,false,'width=800,height=550,hisui=true,title=待收表列表')
		}
		else{
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PADMArr[0]); 
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		}
        /*
		if (Flag!="")
		{
			ConfirmRecPaper_click(iRegNo,PAADM); 
		}
		else
		{
		obj=document.getElementById("RecBegDate"); 
	    if (obj){ iReportDate=obj.value; }
		obj=document.getElementById("ConfirmRecPaper"); 
		if (obj){ iRegNo=obj.value; } 
		var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaper",iRegNo,iReportDate,"");
		if (Return!=0)
		{ 
		alert(Return);
   		}
   		
   		BFind_click(); 
		websys_setfocus("ConfirmRecPaper");
		}
		*/

		ConfirmRecPaper_click(iRegNo,PAADM); 	
		}
	
			
	
}


function ConfirmRecPaper_click(strPatNo,PAADM)
{
	var strPatNo=GetCtlValueById("ConfirmRecPaper")
  	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEReportDate"+"&RegNo="+strPatNo+"&RecLabFlag=1"+"&PAADM="+PAADM;
	websys_lu(lnk,false,'width=1280,height=550,hisui=true,title=收表详情')
	/*
	var wwidth=1000;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			; 
	 
	var cwin=window.open(lnk,"_blank",nwin);
    */

}
function BPrint_click()
{  
	
    try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPERecPaper.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
     
 
	var RowsLen=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowLength");  
	if(RowsLen==0){		
		alert("此次查询结果为空")
	   	return;
	} 
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	xlsheet.cells(1,1)=HosName
	var k=3
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowData",i); 
		var tempcol=DataStr.split("^"); 
		k=k+1;
		xlsheet.Rows(k).insert(); 
		xlsheet.cells(k,1)=tempcol[0];
		xlsheet.cells(k,2)=tempcol[1];
		xlsheet.cells(k,3)=tempcol[2];
		xlsheet.cells(k,4)=tempcol[3];
		xlsheet.cells(k,5)=tempcol[4];
		xlsheet.cells(k,6)=tempcol[5];
		xlsheet.cells(k,7)=tempcol[6];
		xlsheet.cells(k,8)=tempcol[7]; 
		xlsheet.cells(k,9)=tempcol[8];
		xlsheet.cells(k,10)=tempcol[9]; 
		xlsheet.cells(k,11)=tempcol[10];

		
	}   
	///删除最后的空行
	xlsheet.Rows(k+1).Delete;

    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	 
}
catch(e)
	{
		alert(e+"^"+e.message);
	}
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{	
		
	}else
	{
		selectrow=-1;
	
	}	

}
//CurrentSe

document.body.onload = BodyLoadHandler;