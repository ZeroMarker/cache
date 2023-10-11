//名称	DHCPEPreGADM.Find.hisui.js
//功能	团体预约查询
//创建	2020.11.19
//创建人  xy

$(function(){
	
			
	InitCombobox();
	
	Initdate();
	
	InitPreGADMFindGrid();  
	
 
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏
	$("#Clear").click(function() {	
		Clear_click();	
        });
        
    //计算费用
    $("#BAllowToCharge").click(function() {	
		BAllowToCharge_click();	
        });
        
    //主场设置
    $("#HomeSet").click(function() {	
		HomeSet_click();	
        });
    
    //复制
    $("#BCopyTeam").click(function() {	
		BCopyTeam_click();	
        });
    //预约修改
    $("#Update").click(function() {	
		Update_click();	
        });
        
   //项目修改
   $("#BModifyItem").click(function() {	
		BModifyItem_click();	
        });
   
    
	  //打印条码
    $("#BPrintBaseInfo").click(function() {	
		BPrintBaseInfo_click();	
		
        });
        
    //打印名单
    $("#PrintGroupPerson").click(function() {	
		PrintGroupPerson_Click();	
        });  
       
      //取消预约
      $("#BCancelPre").click(function() {	
		BCancelPre_click();	
        }); 
      
     //体检完成
     $("#PEFinish").click(function() {	
		PEFinish_click();	
        }); 
      
   	//取消体检
   	$("#CancelPE").click(function() {	
		CancelPE();		
        });

	//撤销取消体检
	 $("#UnCancelPE").click(function() {	
		UnCancelPE();		
        });
	
	//费用
	$("#UpdatePreAudit").click(function() {	
		UpdatePreAudit();		
        });

	
    //导出团体费用清单
     $("#BPrintGroupItem").click(function() {
			BPrintGroupItem_click();			
        });
	
    iniForm();
})


function iniForm(){

	 //预约修改
	$("#Update").linkbutton('disable');
		
	//取消预约
	$("#BCancelPre").linkbutton('disable');
	
	//项目修改
	$("#BModifyItem").linkbutton('disable');
	
	var UserDR=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	/*
	var OPflag=tkMakeServerCall("web.DHCPE.ChargeLimit","GetOPChargeLimitInfo",UserDR); 
	var OPflagOne=OPflag.split("^");
	if(OPflagOne[0]=="0"){
		$("#UpdatePreAudit").linkbutton('disable');
		}
	*/
   var OPflag=tkMakeServerCall("web.DHCPE.CT.ChargeLimit","GetOPChargeLimitInfo",UserDR,LocID);
   var OPflagOne=OPflag.split("^");
   if(OPflagOne[0]=="N"){
		$("#UpdatePreAudit").linkbutton('disable');
	} 


}

//费用
function UpdatePreAudit()
{
	var Type="G",ID="";
	var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("提示","请选择待操作的团体","info");
		return false;
	}
	var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=750,hisui=true,title=费用')
	$HUI.window("#SplitWin", {
        title: "费用",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 650,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	return true;
}

//导出团体费用清单
function BPrintGroupItem_click()
{
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
		var obj;
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
	    var PGADM=$("#PGADMID").val();
	  	if (PGADM=="")  {
		  	$.messager.alert("提示","请先选择团体","info");
	  		return false;
	  	}
		xlApp = new ActiveXObject("Excel.Application");  //固定
		xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

	    
	    var locType="";
	    var ExecFlag="";
	   
	    var ReturnStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonIADM",PGADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		 
		   xlsheet.cells(1,+Col).value=DataStr
		   }
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
	    
			var FeeStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonItem",IADM[k]);
	     
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   xlsheet.cells(row+1,+FeeCol).value=FeeData
		  
		   }

	    }
	   
	    var n=row+2

	     var TotalFeeString=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetItemFeeTotal");
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		  
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   xlsheet.cells(n,+TFeeCol).value=TFeeData}
    	   
	    
		var GroupDesc=$("#GName").val();
		
	 	xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(n,Cols)).Borders.LineStyle=1;	
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;
	}
	    
    
	catch(e)
	{
		$.messager.alert("提示","导出错误：错误为"+e.message,"info");
	  	return false;
	}
}else{
	BPrintGroupItemNew_click();
}
	
}


function BPrintGroupItemNew_click(){
	
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEGroupPersonItem.xls';
		
		var PGADM=$("#PGADMID").val();
	  	if (PGADM=="")  {
		  	$.messager.alert("提示","请先选择团体","info");
	  		return false;
	  	}
	  	var StrNew = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
         
         
	    var locType="";
	    var ExecFlag="";
	   /* var obj=document.getElementById("NoExceFlag");
	    if ((obj)&&(obj.checked)){
	    	ExecFlag="N";
	    }
	    var obj=document.getElementById("RecLoc");
	    if ((obj)&&(obj.checked)){
	    	locType="RecLoc";
	    }*/
	    
	   
	    var ReturnStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonIADM",PGADM,locType,ExecFlag);
	    var IADMStr=ReturnStr.split("%")[1];
	
	    var ItemStr=ReturnStr.split("%")[0];
	    var String=ItemStr.split("&");
		var Cols=String.length;
		var ret=""
		for (j=0;j<Cols;j++)
		  {
		   var ItemColData=String[j].split("^");
		   var Col=ItemColData[0];
		   var DataStr=ItemColData[1];
		    if(ret==""){ret="xlSheet.Cells(1,"+Col+").Value='"+DataStr+"';" }
		    else{ret=ret+"xlSheet.Cells(1,"+Col+").Value='"+DataStr+"';"}
		  
		   }
		   
		   var IADM=IADMStr.split("^");
		   
	       var IADMRows=IADM.length;
	    
		var row=0;
	    for (k=0;k<IADMRows;k++)
	    {   
		   var FeeStr=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPersonItem",IADM[k]);
	        if (FeeStr==0) continue;
	        row=row+1;
	        var Str=FeeStr.split("&");
	
		    var FeeCols=Str.length;
		    for (i=0;i<FeeCols;i++)
		  {
		   var FeeColData=Str[i].split("^");
		   var FeeCol=FeeColData[0];
		   var FeeData=FeeColData[1];
		   var rownew=row+1;
		   if(ret==""){ret="xlSheet.Cells("+rownew+","+FeeCol+").Value='"+FeeData+"';" }
		    else{ret=ret+"xlSheet.Cells("+rownew+","+FeeCol+").Value='"+FeeData+"';"}
		  
		   }
		 
    	
	    }
	    
	    
	    var n=row+2;

	    var TotalFeeString=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetItemFeeTotal");
	    var TotalFeeStr=TotalFeeString.split("&");
		var TotalFeeCols=TotalFeeStr.length;
		for (i=0;i<TotalFeeCols;i++)
		  {
		   var TFeeColData=TotalFeeStr[i].split("^");
		   //alert(TFeeColData)
		   var TFeeCol=TFeeColData[0];
		   var TFeeData=TFeeColData[1];
		   
    	    if(ret==""){ret="xlSheet.Cells("+n+","+TFeeCol+").Value='"+TFeeData+"';" }
		    else{ret=ret+"xlSheet.Cells("+n+","+TFeeCol+").Value='"+TFeeData+"';"}
		  }
		var GroupDesc=$("#GName").val();
	    var StrNew=StrNew+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+n+","+Cols+")).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(StrNew)
		//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(StrNew);   //通过中间件运行打印程序 
		return ;
	   

}

//取消体检
function CancelPE()
{
	
	 var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("提示","请选择待取消体检的团体","info");
		return false;
	}
	
	$.messager.confirm("确认", "确定要取消体检吗？", function(r){
		if (r){
				CancelPECommon(ID,"G",0);
				BFind_click();
				$("#PGADMID,#GName,#Status,#CompleteStatus").val("");
		}
	});
}

//撤销取消体检
function UnCancelPE()
{
	
	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("提示","请选择待撤销取消体检的团体","info");
		return false;
	}
	
	var Status=$("#Status").val();
	if(Status!="取消体检"){
		$.messager.alert("提示","不是取消体检状态,不能撤销取消体检","info");
		return false;
	}

    $.messager.confirm("确认", "确定要撤销取消体检吗？", function(r){
		if (r){
				CancelPECommon(PGADM,"G",1);
	 			BFind_click();
	 			$("#PGADMID,#GName,#Status,#CompleteStatus").val("");
		}
	});
	
}

function CancelPECommon(PGADM,Type,DoType)
{
	var LocID=session['LOGON.CTLOCID'];
	var UserID=session['LOGON.USERID'];
	var Ret=tkMakeServerCall("web.DHCPE.CancelPE","CancelPE",PGADM,Type,DoType,UserID,LocID);
	Ret=Ret.split("^");
	$.messager.alert("提示",Ret[1],"info");
		
}

//体检完成
function PEFinish_click()
{
	
	var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("提示","请选择待完成体检的团体！","info");
		return false;
	}
	
	var iComplete=$("#CompleteStatus").val();
	if(iComplete=="未完成"){var status="完成体检";}
	
	else{var status="取消完成体检";}
	
		$.messager.confirm("确认", "确定要"+status+"吗？", function(r){
		if (r){
				FinishPECommon("G",0);
				BFind_click();
				$("#PGADMID,#GName,#Status,#CompleteStatus").val("");
		}
	});
}

function FinishPECommon(Type,DoType)
{	
	
	var Id= $("#PGADMID").val();
	if(Id==""){
		$.messager.alert("提示","未选择待完成体检的团体！","info");
		    return false;
	}
		
	var Status=$("#Status").val();
	if(Status=="CANCELPE"){
			$.messager.alert("提示","该团体已取消体检！","info");
		    return false;
	} 

	var Ret=tkMakeServerCall("web.DHCPE.PreGADM","UpdatePEComplete",Id)	
	$.messager.alert("提示","操作成功！","info");		
}


//取消预约
function BCancelPre_click()
{
	var ID = $("#PGADMID").val();
   	if ((""==ID)){
	   	$.messager.alert("提示","请先选择团体","info");
		return false;
	}
	
	var Type=trim($("#BCancelPre").text());
	var Status="PREREG";
	if (Type=="取消预约") Status="CANCELPREREG"
	

	 var PGADMStatus=$("#Status").val();

	var Flag=tkMakeServerCall("web.DHCPE.PreGADM","UpdateStatus",ID,Status)
	
	if (Flag!="0")
	{
		$.messager.alert("提示", "更新团体状态失败", 'error');
		return;
	}else{
		if (Type=="取消预约") {$.messager.alert("提示", "取消预约成功", 'success');}
		else{$.messager.alert("提示", "预约成功", 'success');}
		BFind_click();
		$("#PGADMID,#GName,#Status,#CompleteStatus").val("");

	}

}

//打印名单

function PrintGroupPersonNew_Click(){
	
	var HospID=session['LOGON.HOSPID']

	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("提示","请先选择团体","info");
		return false;
	}
	
	
    var GName=$("#GName").val();

    var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",PGADM,"N")
	var str=returnval; 
	//循环行
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
	   	 $.messager.alert("提示","该团体人员名单为空","info");
	   	return;
	}

	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
    var ret="";
	var k=3; 
   	var tmp=0; 
  
   
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i],HospID);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//本次组rowid不等于上次组rowid并且不是第一组时则行加2
		if((itemrowid != tmp))
		{   
			var count=1;
			k=k+1;
			//xlsheet.Rows(k+1).insert();
			k=k+1;
			//xlsheet.Rows(k+1).insert(); 
			var m=k-1;
			
			if(ret==""){
			 
		     ret="xlSheet.Cells("+m+",1).Value='"+tempcol[8]+"';"+
			 "xlSheet.Range(xlSheet.Cells("+m+",1),xlSheet.Cells("+m+",10)).mergecells=true;"+  //合并单元格
	         "xlSheet.Cells("+k+",1).Value='序号';"+
	         "xlSheet.Cells("+k+",2).Value='登记号';"+ 
	         "xlSheet.Cells("+k+",3).Value='姓名';"+ 
	         "xlSheet.Cells("+k+",4).Value='性别';"+ 
	         "xlSheet.Cells("+k+",5).Value='年龄';"+
	         "xlSheet.Cells("+k+",6).Value='部门';"+ 
	         "xlSheet.Cells("+k+",7).Value='身份证号';"+ 
	         "xlSheet.Cells("+k+",8).Value='收费状态';"+  
	         "xlSheet.Cells("+k+",9).Value='自费金额(元)';"+ 
	         "xlSheet.Cells("+k+",10).Value='公费金额(元)';"+  
	       
			"xlSheet.Columns(2).NumberFormatLocal='@';"+  //设置登记号为文本型
			"xlSheet.Columns(5).NumberFormatLocal='@';"+
			"xlSheet.Columns(7).NumberFormatLocal='@';"+
			"xlSheet.Columns(9).NumberFormatLocal='@';"+
			"xlSheet.Columns(10).NumberFormatLocal='@';"
			}else{
				ret=ret+
				"xlSheet.Cells("+m+",1).Value='"+tempcol[8]+"';"+
			 "xlSheet.Range(xlSheet.Cells("+m+",1),xlSheet.Cells("+m+",10)).mergecells=true;"+  //合并单元格
	         "xlSheet.Cells("+k+",1).Value='序号';"+
	         "xlSheet.Cells("+k+",2).Value='登记号';"+ 
	         "xlSheet.Cells("+k+",3).Value='姓名';"+ 
	         "xlSheet.Cells("+k+",4).Value='性别';"+ 
	         "xlSheet.Cells("+k+",5).Value='年龄';"+
	         "xlSheet.Cells("+k+",6).Value='部门';"+ 
	         "xlSheet.Cells("+k+",7).Value='身份证号';"+ 
	         "xlSheet.Cells("+k+",8).Value='收费状态';"+  
	         "xlSheet.Cells("+k+",9).Value='自费金额(元)';"+ 
	         "xlSheet.Cells("+k+",10).Value='公费金额(元)';"+  
	       
			"xlSheet.Columns(2).NumberFormatLocal='@';"+  //设置登记号为文本型
			"xlSheet.Columns(5).NumberFormatLocal='@';"+
			"xlSheet.Columns(7).NumberFormatLocal='@';"+
			"xlSheet.Columns(9).NumberFormatLocal='@';"+
			"xlSheet.Columns(10).NumberFormatLocal='@';"
			}

		}
		//tempcol[0]=count;
		count=count+1;
		//xlsheet.Rows(k+1).insert();         //插入一行
		//alert(tempcol)
		var n=k+1
		 if(ret==""){ret="xlSheet.Cells("+n+",1).Value='"+tempcol[0]+"';"+
		  "xlSheet.Cells("+n+",2).Value='"+tempcol[1]+"';"+
		  "xlSheet.Cells("+n+",3).Value='"+tempcol[2]+"';"+
		  "xlSheet.Cells("+n+",4).Value='"+tempcol[3]+"';"+
		  "xlSheet.Cells("+n+",5).Value='"+tempcol[4]+"';"+
		  "xlSheet.Cells("+n+",6).Value='"+tempcol[6]+"';"+
		  "xlSheet.Cells("+n+",9).Value='"+tempcol[17]+"';"+
		  "xlSheet.Cells("+n+",10).Value='"+tempcol[16]+"';"+
		   "xlSheet.Cells("+n+",7).Value='"+tempcol[18]+"';"+
		  "xlSheet.Cells("+n+",8).Value='"+tempcol[19]+"';"
		 }else{
			 ret=ret+"xlSheet.Cells("+n+",1).Value='"+tempcol[0]+"';"+
		  "xlSheet.Cells("+n+",2).Value='"+tempcol[1]+"';"+
		  "xlSheet.Cells("+n+",3).Value='"+tempcol[2]+"';"+
		  "xlSheet.Cells("+n+",4).Value='"+tempcol[3]+"';"+
		  "xlSheet.Cells("+n+",5).Value='"+tempcol[4]+"';"+
		  "xlSheet.Cells("+n+",6).Value='"+tempcol[6]+"';"+
		  "xlSheet.Cells("+n+",9).Value='"+tempcol[17]+"';"+
		  "xlSheet.Cells("+n+",10).Value='"+tempcol[16]+"';"+
		   "xlSheet.Cells("+n+",7).Value='"+tempcol[18]+"';"+
		  "xlSheet.Cells("+n+",8).Value='"+tempcol[19]+"';"
		 }
				 
	   tmp=itemrowid;   //将本次组rowid赋给一个临时变量?待与下次取得的组rowid比较
	   k=k+1;
	  
	}
	
	

	  var HospID=session['LOGON.HOSPID'];
	  var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HospID);
	  var Str=Str+ret+
	  		"xlSheet.Cells(1,1).Value='"+HosName+"';"+
	  		"xlSheet.Cells(2,1).Value='团体人员名单';"+
	  		"xlSheet.Cells(3,1).Value='团体名称:"+GName+"(共"+id+"人)';"+
	  		"xlSheet.Range(xlSheet.Cells(2,1),xlSheet.Cells("+k+",10)).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlBook.Close(savechanges=true);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
		//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ;
	
}

function PrintGroupPerson_Click()
{ 
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
	var obj;
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEPrintGPerson.xls';
	
	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("提示","请先选择团体","info");
		return false;
	}
	
	
    var GName=$("#GName").val();
    
	var returnval=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",PGADM,"N")
   	
	var str=returnval; //[0]
	//var num=info[1]      //组的个数
	//循环行
   	var temprow=str.split("^");
   	if(temprow=="")
   	{
	   	 $.messager.alert("提示","该团体人员名单为空","info");
	   	return;
	}


	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlApp.UserControl = true;
    xlApp.visible = true; //显示
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	

   
   	k=2; 
   	var tmp=0; 
  	
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i]);
	    var row=cspRunServerMethod(encmeth,temprow[i]);
		var tempcol=row.split("^");
	    var id=i+1;
		itemrowid=tempcol[7];
		//本次组rowid不等于上次组rowid并且不是第一组时则行加2
		if((itemrowid != tmp))
		{   var count=1;
			k=k+1;
			xlsheet.Rows(k+1).insert();
			k=k+1;
			xlsheet.Rows(k+1).insert(); 
			xlsheet.cells(k-1,1)=tempcol[8]; 
			var Range=xlsheet.Cells(k-1,1);
	        xlsheet.Range(xlsheet.Cells(k-1,1),xlsheet.Cells(k-1,10)).mergecells=true; //合并单元格
			xlsheet.cells(k,1)="序号"
			xlsheet.cells(k,2)="登记号" 
			xlsheet.cells(k,3)="姓名" 
			xlsheet.cells(k,4)="性别"
			xlsheet.cells(k,5)="年龄"
			//xlsheet.cells(k,6)="婚姻状况"
			xlsheet.cells(k,6)="部门"
			xlsheet.cells(k,7)="身份证号"
			xlsheet.cells(k,8)="收费状态"
			xlsheet.cells(k,9)="自费金额"
			xlsheet.cells(k,10)="公费金额"
			//xlsheet.cells(k,8)="优惠金额"
			//xlsheet.cells(k,9)="实际金额"
			//var Range=xlsheet.Cells(k,1)
			//xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,5)).HorizontalAlignment =-4108;//居中
			//xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment =-4108;//居中
			
			
			xlsheet.Columns(2).NumberFormatLocal="@";  //设置登记号为文本型 
			xlsheet.Columns(5).NumberFormatLocal="@"; 
			xlsheet.Columns(7).NumberFormatLocal="@"; 
			xlsheet.Columns(9).NumberFormatLocal="@"; 
			xlsheet.Columns(10).NumberFormatLocal="@";   

		}
		//tempcol[0]=count;
		count=count+1;
		xlsheet.Rows(k+1).insert();         //插入一行
		//alert(tempcol)
		
			xlsheet.cells(k+1,1).Value=tempcol[0];
			xlsheet.cells(k+1,2).Value=tempcol[1];
			xlsheet.cells(k+1,3).Value=tempcol[2];
			xlsheet.cells(k+1,4).Value=tempcol[3];
			xlsheet.cells(k+1,5).Value=tempcol[4];
			xlsheet.cells(k+1,6).Value=tempcol[6];  
			xlsheet.cells(k+1,9).Value=tempcol[17];  
			xlsheet.cells(k+1,10).Value=tempcol[16];
			xlsheet.cells(k+1,7).Value=tempcol[18];  
			xlsheet.cells(k+1,8).Value=tempcol[19]; 
				 

				 
	   tmp=itemrowid;   //将本次组rowid赋给一个临时变量?待与下次取得的组rowid比较
	   k=k+1;
	   xlsheet.cells(2,1)="团体名称:"+GName+"(共"+id+"人)";
	}
///删除最后的空行
xlsheet.Rows(k+1).Delete;
///删除最后的空行
xlsheet.Rows(k+1).Delete;
///删除最后的空行
xlsheet.Rows(k+1).Delete;
///删除最后的空行
xlsheet.Rows(k+1).Delete;

  xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
  
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
}else{
	
	PrintGroupPersonNew_Click()
}
}





//打印条码
function BPrintBaseInfo_click()
{
	var HospID=session['LOGON.HOSPID'];
   	var PGADM = $("#PGADMID").val();
   	if ((""==PGADM)){
	   	$.messager.alert("提示","请先选择团体","info");
		return false;
	}
    var NewHPNo=$("#Code").val();
    var VIPLevel=$("#VIPLevel").combobox("getValue");
     
	var str=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetPreGPerson",PGADM,"Y",NewHPNo,VIPLevel)
	var temprow=str.split("^");
	if(temprow=="")
	{
		$.messager.alert("提示","该团体人员名单为空","info");
   		return false ;
	} 
	
	for(i=0;i<=(temprow.length-1);i++)
	{  
		var row=tkMakeServerCall("web.DHCPE.PrintGroupPerson","GetInfoById",temprow[i],HospID);
		var tempcol=row.split("^");
    	var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",temprow[i]); 
		var FactAmount=Amount.split('^')[1]+'元';
   		//var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo;
		var Info=tempcol[1]+"^"+tempcol[2]+"  "+FactAmount+"^"+"^"+"^"+"^"+tempcol[3]+String.fromCharCode(1)+"^"+tempcol[4]+"^"+tempcol[1]+"^"+"";
		//alert(Info)
		PrintBarRis(Info);
	}
}


//项目修改
function BModifyItem_click()
{
	
	var iRowId = $("#PGADMID").val();
   	if ((""==iRowId)){
	   	$.messager.alert("提示","请先选择团体","info");
		return false;
	}
	
	
    var iName=$("#GName").val();
    
	var lnk="dhcpepregadm.edit.hisui.csp?"
			+"ParRef="+iRowId
			+"&ParRefName="+iName
			+"&OperType="+"T"
			;
	/*
	var wwidth=1450;
	var wheight=1450;
	var xposition = 0;
	var yposition = 0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	*/
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title=预约修改')	
	return true;		
	
	
}
// 预约修改
function Update_click() {
	
	
	var ID = $("#PGADMID").val();
	if (ID=="") {
		 $.messager.alert("提示","请先选择团体","info");
	 	 return false;
	 }

	var iName=$("#GName").val();
	var lnk="dhcpepregadm.edit.hisui.csp?"
			+"ParRef="+ID
			+"&ParRefName="+iName
			+"&OperType="+"E"
			;
	

    //websys_lu(lnk,false,'iconCls=icon-w-edit,width=1430,height=750,hisui=true,title=预约修改')
  $HUI.window("#PreEditWin", {
        title: "预约修改",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1440,
        height: 760,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	return true;		
	

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

//清屏
function Clear_click() {
	
	$("#Code,#PersonNum,#PGADMID,#GName,#Status,#CompleteStatus").val("");
	$(".hisui-combobox").combobox('setValue','');
	
	$(".hisui-combogrid").combogrid('setValue','');
	$("#RegDateFrom").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#RegDateTo").datebox('setValue',"");

	$("#BCopyTeam,#HomeSet,#PEFinish").linkbutton('enable');
			
    iniForm();

	Initdate();
 
  	$(".hisui-checkbox").checkbox('setValue',false);
	
	BFind_click();
   
}

//设置默认时间
function Initdate()
{
	var today = getDefStDate(0-10);
	$("#BeginDate").datebox('setValue', today);
}

//查询
function BFind_click() {
	
    var iCode=$("#Code").val();
	
	var iGroupID=$("#Name").combogrid('getValue');
	if (($("#Name").combogrid('getValue')==undefined)||($("#Name").combogrid('getValue')=="")){var iGroupID="";} 
	
	var iBeginDate=$("#BeginDate").datebox('getValue');
	
	var iEndDate=$("#EndDate").datebox('getValue');
	
	var iChargedStatus=$("#ChargeStatus").combobox('getValue');
	
	var iRegDateFrom=$("#RegDateFrom").datebox('getValue');
	
	var iRegDateTo=$("#RegDateTo").datebox('getValue');
	
	var iPersonNum=$("#PersonNum").val();
	
	var iContractID=$("#Contract").combogrid('getValue');
	if (($("#Contract").combogrid('getValue')==undefined)||($("#Contract").combogrid('getValue')=="")){var iContractID="";} 
	
	var iStatus=GetStatus();


	var iShowPrintGroup="0";
	var ShowPrintGroup=$("#ShowPrintGroup").checkbox('getValue');
	if(ShowPrintGroup){iShowPrintGroup="1";} 
	else{iShowPrintGroup="0";}	     
	
	$("#PreGADMFindGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"SearchPreGADM",
			Code:iCode,
			PGBID:iGroupID,
			BeginDate:iBeginDate,
			EndDate:iEndDate,
			ChargeStatus:iChargedStatus,
			RegDateFrom:iRegDateFrom,
			RegDateTo:iRegDateTo,
			PersonNum:iPersonNum,
			ContractID:iContractID,
			Status:iStatus,
			ReportGroup:iShowPrintGroup
			})
	 

}


function GetStatus() {
	var iStatus="";
	
	// PREREG 预约
	var PREREG=$("#Status_PREREG").checkbox('getValue');
	if(PREREG){iStatus=iStatus+"^"+"PREREG";}      
	
	// REGISTERED 登记
	var REGISTERED=$("#Status_REGISTERED").checkbox('getValue');
	if(REGISTERED){iStatus=iStatus+"^"+"REGISTERED";}  
	
	//到达
	var ARRIVED=$("#Status_ARRIVED").checkbox('getValue');
	if(ARRIVED){iStatus=iStatus+"^"+"ARRIVED";}  
	
	//放弃预约
	var CANCELPREREG=$("#Status_CANCELPREREG").checkbox('getValue');
	if(CANCELPREREG){iStatus=iStatus+"^"+"CANCELPREREG";}  
	
	//取消体检
	var CANCELPE=$("#Status_CANCELPE").checkbox('getValue');
	if(CANCELPE){iStatus=iStatus+"^"+"CANCELPE";}  
	
	
	return iStatus;
}




//团体修改日志记录
function BGAdmRecordList(PGADM)
{
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEGAdmRecordList"+"&GAdmId="+PGADM;
	// websys_lu(lnk,false,'width=600,height=500,hisui=true,title=团体修改日志记录')
	var lnk="dhcpegadmrecordlist.hisui.csp"+"?GAdmId="+PGADM;
	 websys_lu(lnk,false,'width=900,height=500,hisui=true,title=团体操作日志记录')
}

//已检人员
function BHadCheckedList(PGADM)
{
	var lnk="dhcpehadcheckedlist.hisui.csp"+"?GroupID="+PGADM+"&HadCheckType=Y";
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEHadCheckedList"+"&GroupID="+PGADM+"&HadCheckType=Y";
	 websys_lu(lnk,false,'width=1200,height=600,hisui=true,title=已检名单')
	
}

//未检人员
function BNoHadCheckedList(PGADM)
{
	var lnk="dhcpehadcheckedlist.hisui.csp"+"?GroupID="+PGADM+"&HadCheckType=N";
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEHadCheckedList"+"&GroupID="+PGADM+"&HadCheckType=N";
	 websys_lu(lnk,false,'width=1200,height=600,hisui=true,title=未检名单')
	
}

//确认加项人员信息
var openComfirmWin= function(PGADM){

	$("#myWin").show();
	$HUI.window("#myWin",{
		title:"确认加项人员明细",
		iconCls:'icon-w-list',
		minimizable:false,
		maximizable:false,
		collapsible:false,
		modal:true,
		width:550,
		height:390
	});
	
	var ConfirmObj = $HUI.datagrid("#ConfirmAddOrdItemGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"GetConfirmItemPerson",
			PreGADM:PGADM,
		},
		
		columns:[[
			{field:'RegNo',width:'150',title:'登记号'},
			{field:'Name',width:'150',title:'姓名'},
			{field:'Team',width:'150',title:'分组名称'}
			
		]]				
		
		})

	
};
function InitPreGADMFindGrid()
{
	
	$HUI.datagrid("#PreGADMFindGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 50,
		pageList : [50,100,150],
		singleSelect: true,
		checkOnSelect: false, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		
		queryParams:{
			ClassName:"web.DHCPE.PreGADM",
			QueryName:"SearchPreGADM",
			BeginDate:$("#BeginDate").datebox('getValue')

		},
		frozenColumns:[[	
	
			{field:'PGADM_PGBI_DR_Code',width:120,title:'团体编码'},
			{field:'TRegNo',width:120,title:'登记号'},
			{field:'PGADM_PGBI_DR_Name',width:180,title:'团体名称'},
					
		]],
		columns:[[

			{field:'PGADM_RowId',title:'PGADM_RowId',hidden: true},
			{field:'PGADM_BookDateBegin',width:100,title:'起始日期',
			formatter:function(value,rowData,rowIndex){	
				if(rowData.PGADM_RowId!=""){
						return "<a href='#'  class='grid-td-text' onclick=BGAdmRecordList("+rowData.PGADM_RowId+"\)>"+value+"</a>";
			
					}else{return value}
					
					
	
			}},
			{field:'PGADM_BookDateEnd',width:100,title:'截止日期'},
			{field:'PGADM_Status',title:'PGADM_Status',hidden: true},
			{field:'PGADM_Status_Desc',width:100,title:'状态'},
			{field:'PGADM_ChargedStatus_Desc',width:100,title:'收费状态'},
			{field:'PGADM_CompleteStatus',width:100,title:'完成状态'},
			{field:'TTotalPerson',width:250,title:'人数'},
			{field:'GTotalAmont',width:400,title:'总金额'},
			{field:'GGAmountTotal',width:100,title:'公费金额',align:'right'},
			{field:'GIAmountTotal',width:100,title:'自费金额',align:'right'},
			{field:'THadChecked',width:80,title:'已检名单',
			formatter:function(value,rowData,rowIndex){	
				if(rowData.PGADM_RowId!=""){
					    return "<span style='cursor:pointer;padding:0 10px 0px 20px' class='icon-paper' title='已检名单' onclick='BHadCheckedList("+rowData.PGADM_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
			            return '<a><img style="padding:0 10px 0px 20px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="已检名单" border="0" onclick="BHadCheckedList('+rowData.PGADM_RowId+'\)"></a>';
					}
					
			}},
			
			{field:'TNoCheckDetail',width:80,title:'未检名单',
				formatter:function(value,rowData,rowIndex){	
				if(rowData.PGADM_RowId!=""){
						return "<span style='cursor:pointer;padding:0 10px 0px 20px' class='icon-paper' title='未检名单' onclick='BNoHadCheckedList("+rowData.PGADM_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
			            return '<a><img style="padding:0 10px 0px 20px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="未检名单" border="0" onclick="BNoHadCheckedList('+rowData.PGADM_RowId+'\)"></a>';
					}
					
			}},
			{field:'PGBI_Linkman1',width:100,title:'联系人'},
			{field:'PGBI_Tel1',width:100,title:'联系电话'},
		     {field:'TConfirmAddOrdItemPerson',width:100,title:'是否确认加项',align:'center',
				formatter:function(value,rowData,rowIndex){ 
				if(rowData.PGADM_RowId!=""){
					if(rowData.TConfirmAddOrdItemPerson=="是"){
						return "<a href='#'  class='grid-td-text' onclick=openComfirmWin("+rowData.PGADM_RowId+"\)>"+value+"</a>";
					}else{
						
						return value;
					}
				}
					
			}},
			{field:'PGADM_PEDeskClerk_DR_Name',width:100,title:'接待人员'},
			{field:'PGADM_ContractNo',width:100,title:'合同编号'},
			{field:'TContract',width:120,title:'合同名称'},
			{field:'PGADM_CheckedStatus_Desc',width:100,title:'报告状态'},
			{field:'TGetReportDate',width:100,title:'取报告日期'},
			{field:'TType',width:100,title:'允许缴费'},
			
			{field:'THomeGroup',width:100,title:'主场团体'},
			{field:'TPGADMHPCode',width:100,title:'团体代码'},
			{field:'TMark',width:120,title:'备注',editor:{type:'textarea',options:{height:'30px'}}}
					
					
		]],
		onClickRow: onClickRow,
		onAfterEdit: function(index, rowdata, changes) {
			if(rowdata.PGADM_RowId==""){
					//$.messager.alert("提示","合计行不需要保存备注",'info');
					return false;
			}else{
				var rtn=tkMakeServerCall("web.DHCPE.PreGADM","UpDateGMark",rowdata.PGADM_RowId,rowdata.TMark);
				
			}
			

		},
		onSelect: function (rowIndex, rowData) {
			
			$("#PGADMID").val(rowData.PGADM_RowId);
			$("#GName").val(rowData.PGADM_PGBI_DR_Name);
			$("#Status").val(rowData.PGADM_Status_Desc);
			$("#CompleteStatus").val(rowData.PGADM_CompleteStatus);
			DisableButton(rowData.PGADM_Status,rowData.PGADM_CompleteStatus);		
					
		},
		 onLoadSuccess: function(data) {
			//editIndex = undefined;
		}
			
	})
}

//列表编辑
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//结束行编辑
function endEditing() {

	if (editIndex == undefined) {
		return true
	}
	if ($('#PreGADMFindGrid').datagrid('validateRow', editIndex)) {

		$('#PreGADMFindGrid').datagrid('endEdit', editIndex);



		editIndex = undefined;
		return true;
	} else {
		return false;
	}

}

//点击某行进行编辑
function onClickRow(index, value) {
	if (editIndex != index) {
		if (endEditing()) {
			$('#PreGADMFindGrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $('#PreIADMFindGrid').datagrid('getRows')[index]['TMark']

		} else {
			$('#PreIADMFindGrid').datagrid('selectRow', editIndex);
		}


	}

}



function DisableButton(Status,iComplete){

	SetCElement("PEFinish","完成体检");
	if (Status!="ARRIVED"){
		 $("#PEFinish").linkbutton('disable');		
	}else{
		$("#PEFinish").linkbutton('enable');
		if(iComplete=="已完成"){
			SetCElement("PEFinish","取消完成");
		}
	}
	
	
		if (Status=="PREREG")
		{
			 $("#Update").linkbutton('enable');
			 $("#BModifyItem").linkbutton('enable');

			DisableBElement("BCancelPre",false);
				
			SetCElement("BCancelPre","取消预约");

			$("#HomeSet").linkbutton('enable');
			$("#BCopyTeam").linkbutton('enable');
			$("#CancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BCancelPre,#BAllowToCharge").linkbutton('enable');
				
			return;
		}
		if (Status=="CANCELPREREG")
		{
			$("#Update").linkbutton('disable');
			$("#BModifyItem").linkbutton('disable');
			$("#HomeSet").linkbutton('disable');
			$("#BCopyTeam").linkbutton('disable');	
			DisableBElement("BCancelPre",false);
			SetCElement("BCancelPre","预约");
			$("#BCancelPre").css({"width":"118px"});
			$("#CancelPE,#UnCancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BAllowToCharge").linkbutton('disable');
		
			return;
		}

		if (Status=="CANCELPE")
		{
			 $("#Update").linkbutton('disable');
			 $("#BModifyItem").linkbutton('disable');
			 $("#HomeSet").linkbutton('disable');
			 $("#BCopyTeam").linkbutton('disable');
			 $("#UnCancelPE").linkbutton('enable');
			 $("#CancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BCancelPre,#BAllowToCharge").linkbutton('disable');
			
			 return;
		}

		$("#CancelPE,#UpdatePreAudit,#BPrintGroupItem,#BPrintBaseInfo,#PrintGroupPerson,#BCancelPre,#BAllowToCharge").linkbutton('enable');
		$("#HomeSet").linkbutton('enable');
		$("#BCopyTeam").linkbutton('enable');

		$("#Update").linkbutton('enable');
		if (iComplete=="已完成"){                         
			$("#Update").linkbutton('disable');
		}  
		   
		 $("#BModifyItem").linkbutton('enable');                         
		if (iComplete=="已完成"){                         
		 	$("#BModifyItem").linkbutton('disable');    
		} 
		                            
		$("#BCancelPre").linkbutton('disable');    

}
function InitCombobox(){
	

	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		});
		
	
	//收费状态
	var ChargeStatusObj = $HUI.combobox("#ChargeStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:$g('无收费记录')},
            {id:'1',text:$g('未收费')},
            {id:'2',text:$g('已收费')},
            {id:'3',text:$g('部分收费')}
        ]

	});
	
	//团体
	var NameObj = $HUI.combogrid("#Name",{
		panelWidth:430,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode: 'remote',  
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GBI_RowId',title:'ID',width:30},
			{field:'GBI_Desc',title:'名称',width:150},
			{field:'GBI_Code',title:'编码',width:100}
					
		]]
		});
		
		
		//合同
		var ContractObj = $HUI.combogrid("#Contract",{
        panelWidth:600,
        url:$URL+"?ClassName=web.DHCPE.Contract&QueryName=SerchContract",
        mode:'remote',
        delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
        idField:'TID',
        textField:'TName',
        onBeforeLoad:function(param){ 
            param.Contract = param.q;
        },
        onShowPanel:function()
        {
            $('#Contract').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'TID',hidden:true},
            {field:'TNo',title:'合同编号',width:100},
            {field:'TName',title:'合同名称',width:100},
            {field:'TSignDate',title:'签订日期',width:100},
            {field:'TRemark',title:'备注',width:100},
            {field:'TCreateDate',title:'录入日期',width:100},
            {field:'TCreateUser',title:'录入人',width:80}
            
        ]]
        });
       

}


//复制
function BCopyTeam_click(){
	var ID = $("#PGADMID").val();
	if (ID=="") {
		 $.messager.alert("提示","请先选择团体","info");
	 	 return false;
	 }
    var repUrl="dhcpeteamcopy.hisui.csp?ToGID="+ID;	
	websys_lu(repUrl,false,'width=1020,height=545,hisui=true,title=复制分组') 
}

//主场设置
function HomeSet_click(){
	var ID = $("#PGADMID").val();
	if (ID=="") {
		 $.messager.alert("提示","请选择待设定主场的团体","info");
	 	 return false;
	 }
	var lnk = "dhcpe.prehome.csp?PGADM=" + ID;
	//var lnk="dhcpepregadm.home.hisui.csp?PGADMDr="+ID+"&Type=G";	
	websys_lu(lnk, true, 'width=1290,height=660,hisui=true,title=主场设置');
}

//计算费用
function BAllowToCharge_click()
{
	
	 var ID = $("#PGADMID").val();
	 if (ID=="") {
		 $.messager.alert("提示","请先选择团体","info");
	 	 return false;
	 }
	
	var Type="Group";
	var ReturnStr=tkMakeServerCall("web.DHCPE.AllowToCharge","AllowToChargeNew",ID+"^"+"1",Type,"Pre")
	if (ReturnStr==""){
		$.messager.alert("提示","修改完成","info");
		
	}else{
		$.messager.alert("提示","还没有登记,不允许缴费","info");
		 return false;
	
	}
}



