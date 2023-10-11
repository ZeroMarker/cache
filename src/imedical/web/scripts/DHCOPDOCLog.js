function BodyLoadHandler() {
	
	
	//alert(document.getElementById("FindByDoc").value);
	var obj=document.getElementById("PrintRep");
	if (obj){
		//obj.onclick=PrintRep_click;
		obj.onclick=PrintClickHandlerHZRep;
	}
	var obj=document.getElementById("PrintRep2");
	if (obj){
		//obj.onclick=PrintRep_click;
		obj.onclick=PrintClickHandlerHZRep2;
	}
	var obj=document.getElementById("BAount");
	if(obj)obj.onclick=BAount_Click;
	var objLoc=document.getElementById("LocQuery")
	var obj=document.getElementById("RLocID")
	if (obj&&objLoc&&objLoc.value=="") obj.value="";
	// /添加下拉菜单?
	var obj=document.getElementById("SearchConditions");
    if (obj){
	     obj.size=1;
	     obj.multiple=false;
	     obj.onchange=balance_OnChange;
	}	
    var varItem = new Option("","");
    obj.options.add(varItem);
    var varItem = new Option("病人姓名","1");
    obj.options.add(varItem);
    var varItem = new Option("病人ID","2");
    obj.options.add(varItem);
    var varItem = new Option("病案号","3");
    obj.options.add(varItem);
	var obj=document.getElementById("Gsearchmessage");
	if (obj) obj.onkeydown=GsearchmessageKeydownHandler;
	
	var obj=document.getElementById("CardNo")
	if(obj) {
		obj.onkeydown=CardNoKeydownHandler;
		obj.onchange=function(){
			if (this.value==""){
				var PatientIDObj=document.getElementById("PatientID");
				PatientIDObj.value="";
			}
		}
	}
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	loadCardType()
	CardTypeDefine_OnChange()
	var Obj=document.getElementById('ReadCard');
	if (Obj) Obj.onclick = ReadCardHandle;
	var obj=document.getElementById("FindDoc")
	if (obj) {
		obj.onchange=function (){
			var obj=document.getElementById("FindDoc")
			if (obj.value==""){
				var obj=document.getElementById("FindByDoc")
				if (obj) obj.value = "";
			}
		}
	}
	
}
function GsearchmessageKeydownHandler(e){
	var obj=document.getElementById("SearchConditions");
	var index=obj.options.selectedIndex
	var key=websys_getKey(e);
	if ((key==13)&&(index==2)) {
		var PatientNo=document.getElementById("Gsearchmessage").value;
		if (PatientNo!='') {
			if (PatientNo.length<10) {
				for (var i=(10-PatientNo.length-1); i>=0; i--) {
					PatientNo="0"+PatientNo;
				}
			}
		}
		document.getElementById("Gsearchmessage").value=PatientNo;
	}
}
// /下拉菜单相关方法?
function balance_OnChange()
{
	var obj=document.getElementById("SearchConditions");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
	
}

function PrintRep_click(){}
function BAount_Click()
{
	var objtbl=document.getElementById("tDHCOPDOCLog");
	var Rows=objtbl.rows.length;
	if(Rows<2){
		alert("请先查询出数据,以便统计.");
		return;
		}
	var GetInfectStrObj=document.getElementById("GetInfectStr");
	if (GetInfectStrObj) {var encmeth=GetInfectStrObj.value} else {var encmeth=''};
	var InfectStr=cspRunServerMethod(encmeth);
	//alert(InfectStr+"^"+encmeth);
	if(InfectStr=="")InfectStr="0^0" 
	//var obj=document.getElementById("GetInfectSum");
	//if(obj)obj.value=GetInfectStrObj.value;
	//if(obj)var InfectStr=obj.value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDOCLogAount&InfectStr="+InfectStr;
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	win=open(lnk,"BAount","status=1,top=150,left=150,width=1000,height=600,scrollbars=Yes")
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}
function deplook(str) {
	var obj=document.getElementById('depid');
	var tem=str.split("^");
	//alert(tem[1]);
	obj.value=tem[1];
	
}
function PrintClickHandlerHZRep(){
	
	//alert("由于是否10网段设置原因,如果打印按钮打印不出来,请用打印2按钮再操作");
	///AHSLYY  Hospital  INV State
	var TemplatePath
	var getpath=document.getElementById('printpath');
	     if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	     TemplatePath=cspRunServerMethod(encmeth,'','')
	    		/*TemplatePath="http://192.192.10.123/TrakCare/App/Results/Template/"*/
     
        var BeginDate,Depart,TotalSum,PatPaySum,PayorSum;
		var ParkINVInfo,ParkSum,ParkNum;
	    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
        var INVInfo;
        var UserName="";
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        
        /*var obj=document.getElementById("DateTrans");
        if (obj){
	        myencmeth=obj.value;
        }*/
        
        var xlApp,xlsheet,xlBook
	    TemplatePath=TemplatePath+"DHCOPDOCLog1.xls";
	    //alert("TemplatePath=="+TemplatePath);
	    var UserName=""
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserName=obj.innerText;
	    }
	    //得到医生职称 start
	    var UserID=session['LOGON.USERID'];
	    var GetUserTPObj=document.getElementById('GetUserTP');
	    if (GetUserTPObj) {var encmeth=GetUserTPObj.value} else {var encmeth=''};
	    var UserTPDesc=cspRunServerMethod(encmeth,UserID);
	    //得到日期
	    var StartDate=document.getElementById('OpDate');
	    var EndDate=document.getElementById('OpDate2');
	    //guorongyong end
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("OpDate");
	    if (obj) {BeginDate=obj.value;}
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("DocDepartment");
	    if (obj) Depart=obj.value;
	    /*if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }*/
		/*var obj=document.getElementById("CurDate");
		if (obj){
			var PDate=obj.value;
		}*/
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	    //xlsheet.PageSetup.PaperSize = 'xlPaperLegal';
	    /*xlsheet.Columns("B:B").ColumnWidth=4;
	    xlsheet.Columns("C:C").ColumnWidth=6;
	    xlsheet.Columns("D:D").ColumnWidth=22;
	    xlsheet.Columns("E:E").ColumnWidth=6;
	    xlsheet.Columns("F:F").ColumnWidth=9;
	    xlsheet.Columns("G:G").ColumnWidth=9;
	    xlsheet.Columns("H:H").ColumnWidth=9;
	    xlsheet.Columns("I:I").ColumnWidth=9;*/
	    
	  /*  xlsheet.cells(4,3)=BeginDate;
	    xlsheet.cells(4,8)=session["LOGON.USERNAME"];
		xlsheet.cells(4,10)=Depart;//BeginDate+"--" +EndDate;	
		///xlsheet.cells(6,3)=EndDate;*/
		var objtbl=document.getElementById("tDHCOPDOCLog");
		var Rows=objtbl.rows.length;
		var xlsrow=4;
		var xlsCurcol=1;
		var myRows=Rows;
		var HospName=document.getElementById("HospName").value
		if (HospName!="") xlsheet.cells(1,5)=HospName+"门诊病人统计表"
		var ks=document.getElementById("DocDepartment");
	    xlsheet.cells(3,1)="打印就诊日期:"   //"科室:"+ks.value;
		var OpDate=document.getElementById("OpDate");
		var OpDate2=document.getElementById("OpDate2");
		
		if (OpDate==OpDate2){
			cxsj=OpDate.value;			
		}else{
			cxsj=OpDate.value+"至"+OpDate2.value;
		}
				  
	  xlsheet.cells(3,5)=cxsj;
	  //xlsheet.cells(3,6)="医生:"+UserName;  
	  //xlsheet.cells(3,7)="职称:"+UserTPDesc; 

	
    		
		for (var Row=1;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;
			
			
            
			var listobj=document.getElementById("seqnoidz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol)=myval;
			}
			
			if (listobj){
				var listobj=document.getElementById("PatientNamez"+Row);
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+1)=myval;	
			}
			
			
			
			
			
			var listobj=document.getElementById("PatientSexz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			}
			
			var listobj=document.getElementById("PatientAgez"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
			}
			
			var listobj=document.getElementById("DocFirstVisitz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				//var getfrist=myval.split("/");
				//xlsheet.cells(xlsrow,xlsCurcol+4)=getfrist[1];
				xlsheet.cells(xlsrow,xlsCurcol+4)=myval;	
			}

			/*var listobj=document.getElementById("LocalFlagDescz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			}*/		
			
			var listobj=document.getElementById("InfectFlagz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			}

			var listobj=document.getElementById("PAPERTelHz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			}
			var listobj=document.getElementById("DocFirstVisitSignz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				if(myval==true)myval="是";
				else myval="否";
				xlsheet.cells(xlsrow,xlsCurcol+7)=myval;
			}
			var listobj=document.getElementById("DocFurConsultSignz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				if(myval==true)myval="是";
				else myval="否";
				xlsheet.cells(xlsrow,xlsCurcol+8)=myval;
			}
            var listobj=document.getElementById("CTLOCDescz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+9)=myval;
			}
			var listobj=document.getElementById("CTDOCz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+10)=myval;
			}
			/*	
			if (listobj){
				var listobj=document.getElementById("PatientIdz"+Row);
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol)=myval;	
			}
			
			var listobj=document.getElementById("admdatez"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			myval=myval.substr(6,14);
			xlsheet.cells(xlsrow,xlsCurcol+8)=myval;
				
			var listobj=document.getElementById("PatientWorkz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			
			var listobj=document.getElementById("SocialStatusz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			
			var listobj=document.getElementById("jzz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+9)=myval;
			*/
			
			
			/*var listobj=document.getElementById("zfybz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+8)="v";
			} 
			
			var listobj=document.getElementById("zfglz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+9)="v";
			} 
			
			var listobj=document.getElementById("zfqtz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+10)="v";
			} */
    			
			/*var listobj=document.getElementById("DocFirstVisitSignz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+11)="v";
			}
			var listobj=document.getElementById("DocFurConsultSignz"+Row);
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+12)="v";
			} */
			
			//alert(listobj);
				
		}
		gridlist(xlsheet,5,xlsrow,1,11)
	  
	  
	    //xlBook.SaveAs("C:\\zxy.xls");   //lgl+
	  
	  xlsheet.printout;
	   xlBook.Close (savechanges=false);
	   xlApp.Quit();
	   xlApp=null;
	   xlsheet=null;
}

function PrintClickHandlerHZRep2(){
	
	//alert("由于是否10网段设置原因,如果打印2按钮打印不出来,请用打印按钮再操作");
	///AHSLYY  Hospital  INV State
	//Set Config=##Class(websys.Configuration).%OpenId(1)
	//Config.PathToReports
	try {
		var GetPrescPath=document.getElementById("printpath");  //s val=##Class(%CSP.Page).Encrypt($lb("web.UDHCJFCOMMON.getpath"))
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		//TemplatePath="http://192.192.10.123/TrakCare/App/Results/Template/"
        var BeginDate,Depart,TotalSum,PatPaySum,PayorSum;
		var ParkINVInfo,ParkSum,ParkNum;
	    var RefundINVInfo,RefundSum,RefundNum,CheckSum,CheckNum;
        var INVInfo;
        var UserName="";
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        
        /*var obj=document.getElementById("DateTrans");
        if (obj){
	        myencmeth=obj.value;
        }*/
        
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCOPDOCLog.xls";
	    var UserName=""
	    var obj=document.getElementById("sUser");
	    if (obj){
		    var UserName=obj.value;
	    }
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("OpDate");
	    if (obj) {BeginDate=obj.value;}
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("DocDepartment");
	    if (obj) Depart=obj.value;
	    var obj=document.getElementById("OpDate2");
	    if (obj) {EndDate=obj.value;}

		/*var obj=document.getElementById("CurDate");
		if (obj){
			var PDate=obj.value;
		}*/
		
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	    //xlsheet.PageSetup.PaperSize = 'xlPaperLegal';
	    /*xlsheet.Columns("B:B").ColumnWidth=4;
	    xlsheet.Columns("C:C").ColumnWidth=6;
	    xlsheet.Columns("D:D").ColumnWidth=22;
	    xlsheet.Columns("E:E").ColumnWidth=6;
	    xlsheet.Columns("F:F").ColumnWidth=9;
	    xlsheet.Columns("G:G").ColumnWidth=9;
	    xlsheet.Columns("H:H").ColumnWidth=9;
	    xlsheet.Columns("I:I").ColumnWidth=9;*/
	    
	    xlsheet.cells(1,1)=BeginDate+"至"+EndDate+"期间门诊日志";
	    //xlsheet.cells(4,8)=session["LOGON.USERNAME"];
		//xlsheet.cells(4,10)=Depart;//BeginDate+"--" +EndDate;	
		///xlsheet.cells(6,3)=EndDate;
		var objtbl=document.getElementById("tDHCOPDOCLog");
		var Rows=objtbl.rows.length;
		var xlsrow=2;
		var xlsCurcol=0;
		var myRows=Rows;
		
		for (var Row=1;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;
            
			var listobj=document.getElementById("seqnoidz"+Row);
			
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+1)=myval;
			}
			
			var listobj=document.getElementById("CTLOCDescz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+2)=myval;
			}
			
			var listobj=document.getElementById("admdatez"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+3)=myval;
           }
			var listobj=document.getElementById("PatientIDz"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+4)=myval;
			}
			
			var listobj=document.getElementById("PatientNamez"+Row);
			if (listobj){
				var myval=DHCWebD_GetCellValue(listobj);
				xlsheet.cells(xlsrow,xlsCurcol+5)=myval;
			}
		
			var listobj=document.getElementById("PAPERTelHz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+6)=myval;
			}
			var listobj=document.getElementById("PatientSexz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+7)=myval;
			}
			var listobj=document.getElementById("PatientAgez"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+8)=myval;
			}
			}
			var listobj=document.getElementById("CTOCCDescz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+9)=myval;
			} }
			var listobj=document.getElementById("PatientWorkz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			if (myval){
			xlsheet.cells(xlsrow,xlsCurcol+10)=myval;
			}
			}
			//alert(listobj);
			var listobj=document.getElementById("DocFirstVisitz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+11)=myval;			
			}
			var listobj=document.getElementById("DocFirstVisitz"+Row);
			if (listobj){
			var myval=listobj.innerText;
			xlsheet.cells(xlsrow,xlsCurcol+12)=myval;
			}
			var listobj=document.getElementById("MRDIAICDCodeDRz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);			
			xlsheet.cells(xlsrow,xlsCurcol+13)=myval;
			}
			var listobj=document.getElementById("PAADMTriageDatz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+14)=myval;
			}
			var listobj=document.getElementById("DocFirstVisitSignz"+Row)
			if (listobj){
				var myval=""
			var listobjval=DHCWebD_GetCellValue(listobj);
			if (listobjval==true){var myval="初诊"}
			var dfcobj=document.getElementById("DocFurConsultSignz"+Row);
			if (dfcobj){
				var DocFurConsultSign=DHCWebD_GetCellValue(dfcobj);
				if(DocFurConsultSign==true){var myval="复诊"}
			}
			xlsheet.cells(xlsrow,xlsCurcol+15)=myval;
			}
			var listobj=document.getElementById("CTDOCz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+16)=myval;
			}
			var listobj=document.getElementById("CTPCPIdz"+Row);
			if (listobj){
			var myval=DHCWebD_GetCellValue(listobj);
			xlsheet.cells(xlsrow,xlsCurcol+17)=myval;
			}
				  
				  
				  
				  
				  
				  
				  
				    }
		 //alert(99999);
		//gridlist(xlsheet,6,xlsrow,2,13)
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    //alert("C:\\门诊医生日志"+h+m+s+".xls")
	    //xlsheet.save   //printout
	    alert("文件将保存在您的E盘根目录下");
	    xlBook.SaveAs("E:\\门诊医生日志"+h+m+s+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
}
function LoclookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("LocQuery")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("RLocID")
	if (obj) obj.value = lu[1];
	
	var obj=document.getElementById("FindDoc");
	if (obj) obj.value = "";
	var obj=document.getElementById("FindByDoc");
	if (obj) obj.value = "";
}
function DoclookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("FindDoc")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("FindByDoc")
	if (obj) obj.value = lu[1];
}
function LookUpDiagnos(str) {
	//alert(str);
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	
	var obj=document.getElementById("MRDiagnos");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
  
}
function Find(Str)
{
		var loc=Str.split("^");
		var locdes=document.getElementById("SerCon")
		locdes.value=loc[1];
		
}
function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			DHCC_AvailabilityBtn(obj)
			obj.onclick=ReadCardHandle;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}
function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
function CardNoKeydownHandler(e) {
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		CardNoKeydown();
	}
	
}
function CardNoKeydown(){
	var CardNo=document.getElementById("CardNo").value
	CardNo=FormatCardNo();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,CardNo,"","PatInfo");
	//alert(myrtn)
	var myary=myrtn.split("^");
	var rtn=myary[0];
    //alert(CardInform)
    switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			PatientIDObj=document.getElementById("PatientID");
			PatientIDObj.value="";
			document.getElementById("CardNo").value="";
			break;
		default:
			document.getElementById('PatientID').value=myary[4]
			document.getElementById("CardNo").value=CardNo
			break;
	}
}

 function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardTypeDefine"); //BY guorongyong 取所选卡类型传出字符串 2008-02-27
    //var CardTypeValue=tempclear
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}

function ReadCardHandle()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var CardTypeRowId=myary[0];
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=combo_CardType.getActualValue();
	//读卡的时候没有必要非要查找账户信息
    //var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    //var CardInform=DHCACC_ReadMagCard(myEquipDR.split("^")[0])
    var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
    var CardSubInform=myrtn.split("^");
    var rtn=CardSubInform[0];
	var CardNo=CardSubInform[1];
	//var ret=CheckIfUnite(CardNo,"");
    //alert(CardInform)
    switch (rtn){
	        case "0": //卡有效
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				break;
	        case "-201": 
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				break;
			case "-200": //卡无效
				alert("卡无效");
				document.getElementById('PatientID').value="";
				break;
			default:
				break;
		}    
}

document.body.onload = BodyLoadHandler;