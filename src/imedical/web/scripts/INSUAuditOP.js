//INSUAuditOPOP.js
var Flag="",InsuRow=0,num=0
var path="",NowDate=""
var Guser="";
var selectedindex="";
function BodyLoadHandler() {
	Guser=session['LOGON.USERID'];var obl=document.getElementById("RegNo") ;
	var objtbl=document.getElementById("tINSUAuditOP") ;
    var now= new Date()
    //alert(now)
    var yy=now.getFullYear();
	var mm=now.getMonth()+1;
	var dd=now.getDate();
	if (String(mm).length<2) mm="0"+mm
	if (String(dd).length<2) dd="0"+dd
	NowDate=String(yy)+String(mm)+String(dd)
		var BtnFind=document.getElementById("BtnFind") ;
	if (BtnFind)  BtnFind.onclick=BtnFind_Click;
		var Audit=document.getElementById("BtnAudit") ;
		if (Audit)  Audit.onclick=Audit_Click;
		var Refuse=document.getElementById("BtnRefuse") ;
		if (Refuse)  Refuse.onclick=Refuse_Click;
		var ResumeObj=document.getElementById("BtnResume") ;
		if (ResumeObj)  ResumeObj.onclick=Resume_Click;
		var PrintObj=document.getElementById("PrintPL") ;
		if (PrintObj)  PrintObj.onclick=Print_click;
		var obj=document.getElementById("Price800");
		if (obj){	
	  		obj.size=1; 
	  		obj.multiple=false;	 
	  		obj.options[0]=new Option("全部价钱","1");
	  		obj.options[1]=new Option("800以下","2");
	  		obj.options[2]=new Option("800以上","3");
	  		//obj.options[0].selected=true
		      
		      var Priceobj=document.getElementById("Price800Save");
		      if (Priceobj.value!=""){
			      var n=obj.length
			      for (var i =0;i<n;i++){
					  if(obj.options[i].value==Priceobj.value){
					  obj.options[i].selected=true
					  }
			      }
		      }else{
			      obj.options[0].selected=true
			  }

		}

		var obj=document.getElementById("RType");
		if (obj){	
	  		obj.size=1; 
	  		obj.multiple=false;	 
	  		obj.options[0]=new Option("全部","1");
	  		obj.options[1]=new Option("门特","2");
	  		obj.options[2]=new Option("特检特治","3");
	  		//obj.options[0].selected=true
	  		var Typeobj=document.getElementById("RTypeSave");
	  		if (Typeobj.value!=""){
		      var n=obj.length
		      for (var i =0;i<n;i++){
				  
				  if(obj.options[i].value==Typeobj.value){
				  obj.options[i].selected=true
				  }
		      }
		  	}else{
			 obj.options[0].selected=true
			}

		}



	var getpath=parent.frames[0].document.getElementById('getpath');
    if (getpath) {var encmeth=getpath.value} else {var encmeth=''}
    path=cspRunServerMethod(encmeth,'','')

		var Refuse=document.getElementById("InsuNotice") ;
		if (Refuse)  Refuse.onclick=InsuNotice_Click;
}

function GetSelectItem()
{
	var TabOEORIRowIdStr=""
	var OEORIRowId=""
	var objtbl=document.getElementById("tINSUAuditOP") ;
	if (objtbl)
	{
		for (i=1;i<objtbl.rows.length;i++)
		{
			var item=document.getElementById("Selectz"+i);
			if(item.checked==true)
			{
				var OEORIRowId=document.getElementById("TabOEORIRowIdz"+i).innerText
				if(TabOEORIRowIdStr=="") var TabOEORIRowIdStr=OEORIRowId
				else   var TabOEORIRowIdStr=TabOEORIRowIdStr+"^"+OEORIRowId
			}
		}
	}
	//alert(TabOEORIRowIdStr)
	return TabOEORIRowIdStr

}
function SelectRowHandler()	{
	var TabPatName=""
	var eSrc=window.event.srcElement;
   //var rowobj=getRow(eSrc)
   var Objtbl=document.getElementById('tINSUAuditOP');
   var Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
    selectedindex=selectrow;
	SelRowObj=document.getElementById('TabOEORIRowIdz'+selectrow);
	if (SelRowObj){TabOEORIRowId=SelRowObj.innerText}
	else{TabOEORIRowId=""}	
	SelRowObj=document.getElementById('TabPatNamez'+selectrow);
	if (SelRowObj){TabPatName=SelRowObj.innerText}
	//SelRowObj=document.getElementById('jobz'+selectrow);
	//if (SelRowObj){alert(1);alert(SelRowObj.value)}
	SelRowObj=document.getElementById('TabPatNoz'+selectrow);
	if (SelRowObj){TabPatNo=SelRowObj.innerText}
	if(InsuRow!=selectrow)
	{
		InsuRow=selectrow
		var obj=parent.frames["DHCINSUOedLinkTar"].document.getElementById("OeOrdDr");
		obj.value=TabOEORIRowId
		var obj=parent.frames["DHCINSUOedLinkTar"].document.getElementById("name");
		obj.value=TabPatName
		var obj=parent.frames["DHCINSUOedLinkTar"].document.getElementById("PatNo");
		obj.value=TabPatNo
		parent.frames["DHCINSUOedLinkTar"].Query_onclick();
	}else{
		InsuRow=""
		var obj=parent.frames["DHCINSUOedLinkTar"].document.getElementById("OeOrdDr");
		obj.value=""
		var obj=parent.frames["DHCINSUOedLinkTar"].document.getElementById("name");
		obj.value=""
		var obj=parent.frames["DHCINSUOedLinkTar"].document.getElementById("PatNo");
		obj.value=""
		parent.frames["DHCINSUOedLinkTar"].Query_onclick();
	}

	//parent.frames["DHCINSUOedLinkTar"].Query_click();
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCINSUOedLinkTar&OeOrdDr="+OeOrdDr;
	//location.href=lnk;
	
	
}
function Audit_Click()
{
	var TabOEORIRowIdStr=GetSelectItem()
	if (""==TabOEORIRowIdStr)
	{
		alert("请选择数据")
	}
	var MedAudit=document.getElementById("MedAudit").value ;
	//alert(TabOEORIRowIdStr+"_"+Guser)
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"Y",Guser);
    //alert(ret)
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
	SelectRowHandler();
    BtnFind_click()
}
function Refuse_Click()
{
	var TabOEORIRowIdStr=GetSelectItem()
	if (""==TabOEORIRowIdStr)
	{
		alert("请选择数据")
	}
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"N",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    BtnFind_click()
}
function Resume_Click()
{
	var TabOEORIRowIdStr=GetSelectItem()
	if (""==TabOEORIRowIdStr)
	{
		alert("请选择数据")
	}
	var MedAudit=document.getElementById("MedAudit").value ;
    var ret=cspRunServerMethod(MedAudit,TabOEORIRowIdStr,"",Guser);
    if (ret!=0)
    {
		alert("更新标志失败!")
	}
    BtnFind_click()
}

function Print_click()
{
	    if (selectedindex==""){alert("为打印查询出的所有数据，请至少选择一条记录以获取打印所需必要进程号");return;}
	    if(eval(selectedindex)<0){alert("为打印查询出的所有数据，请至少选择一条记录以获取打印所需必要进程号");return;} 
	    var xlApp,obook,osheet,xlsheet,xlBook
	    var RTypeObj=document.getElementById('RType');
	    var Price800obj=document.getElementById("Price800");
	     GetNum()
	     if(num<1){alert("没有要打印的数据");return;}
	     for (i=1;i<=num;i++)
	     {var str=ListPrt(i)	      
	      str=str.split("^")
	      //alert(str)
	      if ((str[0]=="3")&&(RTypeObj.value!="2")) //特检特治
	       {
		       if ((str[9]<800)&&(Price800obj.value!="3"))
		       {
		       		PrintTJTZ_click(i,str);
		       	}
	       }
	     else if ((str[0]=="4")&&(RTypeObj.value!="3"))		//门特
	      {
		     
		       if ((str[9]>=800)&&(Price800obj.value!="2"))
		       {
		      		PrintMT_click(i,str);
		      	}
	      }	 
	      else{
		  	PrintAll_click(i,str);
		  }	
	 	}   
	   
}
function PrintAll_click(i,str)
{
	    var xlApp,obook,osheet,xlsheet,xlBook
	   
	    var str=ListPrt(i)
	    //Template=path+"INSU_TJTZ.xls";
	    var xlspath=tkMakeServerCall("web.INSUBase","getpath")
		var Template=xlspath+"INSUAuditOP_All.xls"		//打印模版
		//alert(Template)
	    //Template="C:\\"+"INSU_All.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	      str=str.split("^")
	      xlsheet.cells(6,2)=str[1]
	      xlsheet.cells(6,4)=str[2]
	      xlsheet.cells(6,6)=str[3]+"岁"
	      xlsheet.cells(6,8)=str[4]
	      xlsheet.cells(7,2)=str[5]
	      xlsheet.cells(7,4)=str[6]
	      xlsheet.cells(7,8)=str[7]
	      xlsheet.cells(8,3)=str[8]
	      xlsheet.cells(8,6)=str[9]+"元"
	      xlsheet.cells(8,8)=str[10]
	      var TmpDesc=str[11].split("||")
	      for (var j=0;j<TmpDesc.length-1;j++)
	      {	
		      xlsheet.cells(10+j,1)=TmpDesc[j]  ///收费项目		      
		  }
	      //xlsheet.cells(10,1)=str[10]
	      var Date=str[13].split("-")
	      var Date1=Date[0]+"年"+Date[1]+"月"+Date[2]+"日"
	      xlsheet.cells(30,8)=Date1
			xlsheet.cells(36,8)=Date1
			xlsheet.cells(41,3)=Date1
			xlsheet.cells(41,8)=Date1
		 xlsheet.cells(25,1)=str[14]	
	      	    //xlsheet.SaveAs("c:\\JF_INSU.xls")
	    //xlsheet.PrintPreview()
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null   
	   
}
function PrintTJTZ_click(i,str)
{
	    var xlApp,obook,osheet,xlsheet,xlBook
	   
	    var str=ListPrt(i)
	    var xlspath=tkMakeServerCall("web.INSUBase","getpath")
		var Template=xlspath+"INSUAuditOP_TJTZ.xls"		//打印模版
	    //Template="C:\\"+"INSU_TJTZ.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	      str=str.split("^")
	      xlsheet.cells(6,2)=str[1]
	      xlsheet.cells(6,4)=str[2]
	      xlsheet.cells(6,6)=str[3]+"岁"
	      xlsheet.cells(6,8)=str[4]
	      xlsheet.cells(7,2)=str[5]
	      xlsheet.cells(7,4)=str[6]
	      xlsheet.cells(7,8)=str[7]
	      xlsheet.cells(8,3)=str[8]
	      xlsheet.cells(8,6)=str[9]+"元"
	      xlsheet.cells(8,8)=str[10]
	      var TmpDesc=str[11].split("||")
	      for (var j=0;j<TmpDesc.length-1;j++)
	      {	
		      xlsheet.cells(10+j,1)=TmpDesc[j]  ///收费项目		      
		  }
	      //xlsheet.cells(10,1)=str[10]
	      var Date=str[13].split("-")
	      var Date1=Date[0]+"年"+Date[1]+"月"+Date[2]+"日"
	      xlsheet.cells(30,8)=Date1
			xlsheet.cells(36,8)=Date1
			xlsheet.cells(41,3)=Date1
			xlsheet.cells(41,8)=Date1
		 xlsheet.cells(25,1)=str[14]	
	      	    //xlsheet.SaveAs("c:\\JF_INSU.xls")
	    //xlsheet.PrintPreview()
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null   
	   
}
function PrintMT_click(i,str)
{
	    var xlApp,obook,osheet,xlsheet,xlBook
	   
	    var str=ListPrt(i)
	    //Template="C:\\"+"INSU_MT.xls";
	    var xlspath=tkMakeServerCall("web.INSUBase","getpath")
		var Template=xlspath+"INSUAuditOP_MT.xls"		//打印模版
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	      str=str.split("^")
	      xlsheet.cells(5,2)=str[1]
	      xlsheet.cells(5,4)=str[2]
	      xlsheet.cells(5,6)=str[3]+"岁"
	      xlsheet.cells(6,3)=str[4]
	      xlsheet.cells(6,6)=str[9]+"元"
	      xlsheet.cells(6,8)=str[7]
	     var Date=str[13].split("-")
	      var Date1=Date[0]+"年"+Date[1]+"月"+Date[2]+"日"
	      xlsheet.cells(17,8)=Date1
			xlsheet.cells(26,8)=Date1
			xlsheet.cells(33,8)=Date1
			xlsheet.cells(42,8)=Date1
			xlsheet.cells(10,2)=str[14]
	      	    //xlsheet.SaveAs("c:\\JF_INSU.xls")
	    //xlsheet.PrintPreview()
	    xlsheet.printout
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null   
	   
}
function GetNum() {
   	var SelRowObj=document.getElementById('jobz'+1);
    job=SelRowObj.innerText;
    //alert(job)
    Objtbl=document.getElementById('getnum');
   	if (Objtbl) {var encmeth=Objtbl.value} else {var encmeth=''};
	var str	
    str=cspRunServerMethod(encmeth,'','',job)
    //alert(str)
    str=str.split("^")

    num=str[0]
 	}
function ListPrt(gnum) 
{   
   //Objtbl=parent.frames[0].document.getElementById('tINSUTarContrastComQry');
   var list=document.getElementById('list');
	if (list) {var encmeth=list.value} else {var encmeth=''};
	var str	
	str=cspRunServerMethod(encmeth,'','',job,gnum)
	return str
}

function InsuNotice_Click()
{
    InsuNotice(Guser,NowDate)
}
function BtnFind_Click()
{

	var RegNo="",StartDate="", EndDate="", CheckAuditType=""
	var RegNo=document.getElementById('RegNo').value;
	var StartDate=document.getElementById('StartDate').value;
	var EndDate=document.getElementById('EndDate').value;
	var rttypeval=document.getElementById('RType').value;
	var price800val=document.getElementById('Price800').value;
	var CheckAuditTypeobj=document.getElementById('CheckAuditType');
	if(CheckAuditTypeobj)
	{
		if (CheckAuditTypeobj.checked){var CheckAuditType="on";}
		else{var CheckAuditType="";}
	}
	
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUAuditOP&RegNo="+RegNo+"&StartDate="+StartDate+"&EndDate="+EndDate+"&CheckAuditType="+CheckAuditType+"&RType="+rttypeval+"&Price800="+price800val;
    //alert(lnk)
    location.href=lnk;
	
}
document.body.onload = BodyLoadHandler;