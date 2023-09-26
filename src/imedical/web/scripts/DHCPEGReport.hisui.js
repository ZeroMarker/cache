
//名称	DHCPEGReport.hisui.js
//功能	团体报告	
//创建	2019.04.24
//创建人  xy

$(function(){
	InitCombobox();
	 
	InitGReportQueryTabDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
     
     //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //打印报告
	$("#BPrint").click(function() {	
		BPrint_click();		
        });
   
	 //打印预览
	$("#BPrintView").click(function() {
		BPrintView_click();
        });

   //导出团体结果  
	$("#BExportGroupResult").click(function() {	
		BExportGroupResult_click();		
        });
        
     //导出团体异常值
	$("#BExportGroupAbnormity").click(function() {	
		//BExportGroupAbnormity_click();	
        BExportGroupAbnormityNew_click();		
        });
   
        
})

 //清屏
function BClear_click()
{
	
	$("#DateFrom").datebox('setValue',"");
	$("#DateTo").datebox('setValue',"");
	$("#StationID").combobox('setValue',"");
	$("#GDesc").combogrid('setValue',"");
	$("#GADM_DR").val("");
	InitCombobox();
	BFind_click();
}
 //打印报告
function BPrint_click()
{
	var iGADMDR=$('#GADM_DR').val();
	var Depart=$("#Depart").combogrid("getValue");

	if(iGADMDR=="") {
		$.messager.alert("提示","请先选择待打印报告的团体","info");
		return false;
		}

  	
	var fileName="DHCPETeamReport.raq&GADMDR="+iGADMDR+"&Depart="+Depart;
	DHCCPM_RQPrint(fileName);
	
	var iUserUpdateDR=session['LOGON.USERID'];
  	var iStatus="P";
  	var Instring=$.trim(iGADMDR)
			+"^"+$.trim(iStatus)
			+"^"+$.trim(iUserUpdateDR)
			;
	
	var flag=tkMakeServerCall("web.DHCPE.Report","SetReportStatusNew",Instring);
	
	return false;
}

//打印预览
function BPrintView_click()
{
	var iGADMDR=$('#GADM_DR').val();
	if(iGADMDR=="") {
		$.messager.alert("提示","请先选择待预览报告的团体","info");
		return false;
		}
		var Depart=$("#Depart").combogrid("getValue");
	var fileName="DHCPETeamReport.raq&GADMDR="+iGADMDR+"&Depart="+Depart;
	DHCCPM_RQPrint(fileName);
	
	return false;
}
//导出团体异常值
function BExportGroupAbnormity_click()
{	
	  if ((""==PGADMDR)){
	    $.messager.alert("提示","请先选择待操作的团体","info");
		return false;
	}
     var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
 
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	var PGADMDR=$('#GADM_DR').val();
	var PGADMName=$('#GADM_DR_Name').val();
	
    var iadms=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetIADM",PGADMDR);
    var StationID="";
    var StationID=$("#StationID").combobox('getValue');  
    var patInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMs",iadms,StationID);
	var patArray=patInfo.split("&");
	Array.prototype.name="";
	var array=new Array;  //其元素为数组对象,用于按部门存放人员信息,每个数组元素对应一个部门
	
	/*以下循环是对服务器传来的数据按部门分类存放处理*/
	for(var i=0;i<patArray.length;i++)
	{
		if(i==0)
		{
			var arr=new Array(patArray[0]);
			arr.name=patArray[0].split('$')[0].split('^')[2]; //指定数组name属性为部门名称
			array.push(arr);
			continue;
		}
		for(var j=0;j<array.length;j++)  
		{
			if(array[j].name==patArray[i].split('$')[0].split('^')[2])  //array数组中若已有此部门,则人员信息添加到此部门中
			{
				array[j].push(patArray[i]);
				break;
			}
			if(j==(array.length-1)) //array中无此部门,则添加
			{
				var arr=new Array(patArray[i]);
				arr.name=patArray[i].split('$')[0].split('^')[2];
				array.push(arr);
			}
		}
	}
	
	var k=1;
	xlsheet.cells(k,1)=PGADMName+"异常值汇总";
	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).mergecells=true;
	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment= -4108;
	xlsheet.Rows(k).Font.Name = "黑体";
	xlsheet.Columns(1).NumberFormatLocal="@";
	/*以下循环将数据按格式导出到Excel*/
	for(var i=0;i<array.length;i++)
	{
		k+=2;		
		xlsheet.cells(k,1)=array[i].name;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment= -4108;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).mergecells=true;
		xlsheet.Rows(k).Font.Name = "黑体";
		for(var j=0;j<array[i].length;j++)
		{
			k+=2;
			if(array[i][j].split('$')[0].split('^')[1]==undefined){
				var Name="";
				}
			else{
				var Name=array[i][j].split('$')[0].split('^')[1];
				}

			xlsheet.Cells(k,1)="登记号:"+array[i][j].split('$')[0].split('^')[0];  //登记号
			//xlsheet.Cells(k,2)="姓名:"+array[i][j].split('$')[0].split('^')[1];  //姓名
			xlsheet.Cells(k,2)="姓名:"+Name;  //姓名
			xlsheet.Rows(k).Font.Name = "黑体";
			k+=1
			xlsheet.Cells(k,1)="医嘱名称";
			xlsheet.Cells(k,2)="细项名称";
			xlsheet.Cells(k,5)="检查结果";
			for(var m=1;m<array[i][j].split('$').length;m++)
			{
				
			
				k+=1;
				
				xlsheet.Cells(k,1)=array[i][j].split('$')[m].split('^')[0];
				xlsheet.Cells(k,2)=array[i][j].split('$')[m].split('^')[1];
				xlsheet.Cells(k,5)=array[i][j].split('$')[m].split('^')[2];
			
			}
		}
	}
	xlsheet.SaveAs("d:\\团体异常值汇总.xls");
	
    xlApp.Visible = true;
    xlApp.UserControl = true;
}


function BExportGroupResultNew_click(){
	
	var GADM=$('#GADM_DR').val();
    if ((""==GADM)){
	    $.messager.alert("提示","请先选择待操作的团体","info");
		return false;
	}
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEPrintPositiveStatistic.xls';
     
     var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"
         
       var ret=""  
        var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","ExportGroupResult",GADM+"^"+UserID);
	if(flag==""){
			$.messager.alert("提示","没有数据导出","info");
	 		return false;
	}
 	if (flag!=""){
	 		var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		ret="xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,"+Info+")).mergecells=true;"+
 			"xlSheet.cells(1,1).value='团体结果导出';"
 			
	 	 var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		$.messager.alert("提示","没有细项","info");
	 		return false;
 		}

	    var ret1=""
 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		ret1=ret1+"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(2,"+Merge+")).mergecells=true;"+
	 		
	 				"xlSheet.Cells(2,"+StartCell+").value = '"+Desc+"';"
        	
        	
		}
 		var ret2=""
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		n=i+1
	 		ret2=ret2+"xlSheet.Cells(3,"+n+").value = '"+OneInfo+"';"
	 		
		}
		
		
		var ret3=""
 	
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		var row=4+i;
	 		var col=j+1;
	 		ret2=ret2+"xlSheet.Cells("+row+","+col+").value = '"+OneInfo+"';"	
        	
		}
		
	}
         
 	}
 	// var Str=Str+
	 var Str=Str+ret+ret1+ret2+ret3+
	 
         	"xlApp.Visible = true;"+
            "xlApp.UserControl = true;"+
          	"xlSheet.SaveAs('d:\\团体结果汇总.xls');"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
                    //alert(Str)
//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ;
	    
	
	
}
//导出团体结果 
function BExportGroupResult_click()
{
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var GADM=$('#GADM_DR').val();
    if ((""==GADM)){
	    $.messager.alert("提示","请先选择待操作的团体","info");
		return false;
	}
    var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEPrintPositiveStatistic.xls';
	
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
		var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","ExportGroupResult",GADM+"^"+UserID);
	//alert(flag)
 	if (flag!=""){
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,(+Info))).mergecells=true;
 		xlsheet.cells(1,1).value = "团体结果导出";
       
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		$.messager.alert("提示","没有细项","info");
	 		return false;
 		}

 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
        	xlsheet.cells(2,StartCell).value = Desc;
        	
        	
		}
 		
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		xlsheet.cells(3,i+1).value = OneInfo;
        	
		}
         
 	}
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		xlsheet.cells(4+i,j+1).value = OneInfo;
        	
		}
		
	}

	var UserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","ExportGroupResult",GADM+"^"+UserID);
	//alert(flag)
 	if (flag!=""){
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,(+Info))).mergecells=true;
 		xlsheet.cells(1,1).value = "团体结果导出";
       
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		$.messager.alert("提示","没有细项","info");
	 		return false;
 		}

 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
        	xlsheet.cells(2,StartCell).value = Desc;
        	
        	
		}
 		
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		xlsheet.cells(3,i+1).value = OneInfo;
        	
		}
         
 	}
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		xlsheet.cells(4+i,j+1).value = OneInfo;
        	
		}
		
	}
    
	xlsheet.SaveAs("d:\\团体结果汇总.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;
	xlsheet=null;
	xlApp=null;
}else{
	BExportGroupResultNew_click();
}
	
	
	
}




function BExportGroupAbnormityNewGoogle_click(){
			var PGADMDR=$('#GADM_DR').val();
	var PGADMName=$('#GADM_DR_Name').val();
	

    if ((""==PGADMDR)){
	    $.messager.alert("提示","请先选择待操作的团体","info");
		return false;
	}

    var iadms=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetIADM",PGADMDR);
    if ( iadms=="" ) {
	    $.messager.alert("提示","该团体无总检人员数据！","info");
		return false;
    }
    var StationID="";
    var StationID=$("#StationID").combobox('getValue');
    var UserId=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",iadms,StationID,"");
    if (UserId == "") {
	    $.messager.alert("提示","无法获取用户数据！","info");
		return false;
    } else if (UserId == "-1") {
	    $.messager.alert("提示","该团体无异常结果数据！","info");
		return false;
    }

	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
	//var Templatefilepath="http://127.0.0.1/imedical/med/Results/Template/"+'DHCPEGroupAbnormity.xls';
	 
    var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"

    var ret="";
	var MainHeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-1");  // 表头
	var MainHead=MainHeadInfo.split("^");
	var HeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-2");  // 细项表头
	var Head=HeadInfo.split("^");
	var BaseCount=Head[0].split("$$");
	var Merge=0;
		for(var i=0; i<MainHead.length; i++) {
		 	var OneInfo=MainHead[i];
		 	var OneArr=OneInfo.split("$$");
		 	var Desc=OneArr[0];
		 	var MergeCount=OneArr[1];
		 	var StartCell=Merge+1;
		 	Merge=Merge+(+MergeCount);
		 	if(ret==""){
		 	if ( Merge < +BaseCount[0] || Merge == ((+BaseCount[0]) + (+BaseCount[1])) ){
			 	ret="xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	} else {
			 	ret="xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(2,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	
		 	}
		 	}else{
			 	if ( Merge < +BaseCount[0] || Merge == ((+BaseCount[0]) + (+BaseCount[1])) ){
			 	ret=ret+"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	} else {
			 	ret=ret+"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(2,"+Merge+")).mergecells=true;"+
		 		"xlSheet.Range(xlSheet.Cells(2,"+StartCell+"),xlSheet.Cells(3,"+Merge+")).HorizontalAlignment= -4108;"
		 	
		 	}
			 	
		 	}
		 	
		 	ret=ret+"xlSheet.Cells(2,"+StartCell+").WrapText=true;"+
		 	"xlSheet.Cells(2,"+StartCell+").VerticalAlignment = 2;"+
		 	"xlSheet.Cells(2,"+StartCell+").Font.Bold = true;"+
		 	"xlSheet.Cells(2,"+StartCell+").value = '"+Desc+"';"
		 	
		 
		}
		//alert(ret)
		var ret1=""
		for(var i=1; i<Head.length; i++) {
		 	var OrderDesc=Head[i];
		 	var StartCell=parseInt(BaseCount[0])+i-1;
		 	StartCell=parseInt(StartCell);
		 	
		 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").WrapText=true;";
		 	if (OrderDesc.length >= 8 && OrderDesc.length < 20){
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 20;"
		 	}
		 	else if (OrderDesc.length > 20 && OrderDesc.length < 35) 
		 	{
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 40;"	
		   }
		 	else if (OrderDesc.length >= 35){
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 60;"
		 	}
		 	else{
			 	ret1=ret1+"xlSheet.Cells(3,"+StartCell+").ColumnWidth = 10;"
		 	
		   }
		  // alert(StartCell+"StartCell")
		     //垂直对齐方式枚举*(1-靠上，2-居中，3-靠下，4-两端对齐，5-分散对齐)
		   ret1=ret1+"xlSheet.Cells(3,"+StartCell+").VerticalAlignment = 2;"+
		   "xlSheet.Cells(3,"+StartCell+").Font.Bold = true;"+
		   "xlSheet.Cells(3,"+StartCell+").value ='"+ OrderDesc+"';"		
		 
		}
		var ret2=""
		var ret3=""
		var IADMInfo=iadms.split("^");var StartRow=3;
		for (var i=0; i<IADMInfo.length; i++) {
			var DataInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,IADMInfo[i]);  // 内容
			if (DataInfo == "") continue;
			StartRow=StartRow+1;
		    var Data=DataInfo.split("^");
		    if (StartRow == 4) {
			    //登记号
		    	//xlsheet.Columns(1).WrapText=true;               //设置为自动换行*
		    	ret2=ret2+"xlSheet.Columns(1).HorizontalAlignment = 3;" +
		    				"xlSheet.Columns(1).ColumnWidth = 12;"+
		    	"xlSheet.Columns(2).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(2).ColumnWidth = 12;"+
		    	"xlSheet.Columns(3).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(3).ColumnWidth = 6;"+
		    	"xlSheet.Columns(4).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(4).ColumnWidth = 6;"+	
		    	"xlSheet.Columns(3).WrapText=true;;"+	
		    	"xlSheet.Columns(3).ColumnWidth = 50;"+	
		    	"xlSheet.Columns(6).HorizontalAlignment = 3;"+
		    	"xlSheet.Columns(6).ColumnWidth = 15;"+
		    	
		    	//总检结论
		    	"xlSheet.Columns("+Data.length+").WrapText=true;"+
		    	"xlSheet.Columns("+Data.length+").ColumnWidth = 200;"+
				"xlSheet.Columns(1).NumberFormatLocal='@';"
		    }
		
		for(var j=0; j<Data.length; j++) {
			 	var IADMData=Data[j];
			 	var StartCell=j+1;
			 	
				if (i == 0) {
					ret3=ret3+"xlSheet.Columns("+StartCell+").NumberFormatLocal='@';"+
    				"xlSheet.Columns("+StartCell+").VerticalAlignment = 2;"
					if ( StartCell > 6 ) {
						ret3=ret3+"xlSheet.Columns("+StartCell+").WrapText=true;"
					}
				}
				
				ret3=ret3+"xlSheet.Cells("+StartRow+","+StartCell+").value ='"+IADMData+"';"
			}
		}
		var k=1;
		
		if(ret!=""){var Str=Str+ret;}
		else {var Str=Str;}
			
		if(ret1!=""){var Str=Str+ret1;}
		else {var Str=Str;}
			
		if(ret2!=""){var Str=Str+ret2;}
		else {var Str=Str;}
		
		if(ret3!=""){var Str=Str+ret3;}
		else {var Str=Str;}
		
		
		var Str=Str+
		"xlSheet.Cells("+k+",1)='"+PGADMName+"阳性体征及总检建议';"+
		"xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+","+Merge+")).mergecells=true;"+
		"xlSheet.Range(xlSheet.Cells("+k+",1),xlSheet.Cells("+k+","+Merge+")).HorizontalAlignment= -4108;"+
		"xlSheet.Rows("+k+").Font.Name = '黑体';"+
		"xlSheet.Cells("+k+",1).Font.Size = 17;" +
		"xlSheet.Cells("+k+",1).Font.Bold = true;"+
		"xlSheet.Columns(1).NumberFormatLocal='@';"+
		"xlApp.Visible = true;"+
        "xlApp.UserControl = true;"+
		"xlSheet.SaveAs('d:\\" + PGADMName + "阳性体征及总检建议.xls');"+
       "return 1;}());";
          //alert(Str)
//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序// 
		return ;
	  
		
	
}
//导出团体异常值
function BExportGroupAbnormityNew_click() {
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
	var PGADMDR=$('#GADM_DR').val();
	var PGADMName=$('#GADM_DR_Name').val();
	

    if ((""==PGADMDR)){
	    $.messager.alert("提示","请先选择待操作的团体","info");
		return false;
	}

    var iadms=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetIADM",PGADMDR);
    if ( iadms=="" ) {
	    $.messager.alert("提示","该团体无总检人员数据！","info");
		return false;
    }
    var StationID="";
    var StationID=$("#StationID").combobox('getValue');
    var UserId=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",iadms,StationID,"");
    if (UserId == "") {
	    $.messager.alert("提示","无法获取用户数据！","info");
		return false;
    } else if (UserId == "-1") {
	    $.messager.alert("提示","该团体无异常结果数据！","info");
		return false;
    }

	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
	//var Templatefilepath="d:\\"+'DHCPEGroupAbnormity.xls';

	try {
		xlApp = new ActiveXObject("Excel.Application");  //固定
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

	    var MainHeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-1");  // 表头
	    var MainHead=MainHeadInfo.split("^");
		var HeadInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,"-2");  // 细项表头
	    var Head=HeadInfo.split("^");
	    var BaseCount=Head[0].split("$$");
		var Merge=0;
		for(var i=0; i<MainHead.length; i++) {
		 	var OneInfo=MainHead[i];
		 	var OneArr=OneInfo.split("$$");
		 	var Desc=OneArr[0];
		 	var MergeCount=OneArr[1];
		 	var StartCell=Merge+1;
		 	Merge=Merge+(+MergeCount);
		 	if ( Merge < +BaseCount[0] || Merge == ((+BaseCount[0]) + (+BaseCount[1])) ){
		 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(3,Merge)).mergecells=true;
				xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(3,Merge)).HorizontalAlignment= -4108;
		 	} else {
		 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
				xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).HorizontalAlignment= -4108;
		 	}
		 	xlsheet.cells(2,StartCell).WrapText=true;
			xlsheet.cells(2,StartCell).VerticalAlignment = 2;		//垂直对齐方式枚举*(1-靠上，2-居中，3-靠下，4-两端对齐，5-分散对齐)
		 	xlsheet.cells(2,StartCell).Font.Bold = true;             //设置为粗体*
	        xlsheet.cells(2,StartCell).value = Desc;
		}

		for(var i=1; i<Head.length; i++) {
		 	var OrderDesc=Head[i];
		 	var StartCell=+BaseCount[0]+i-1;
		 	xlsheet.cells(3,StartCell).WrapText=true;
		 	if (OrderDesc.length >= 8 && OrderDesc.length < 20) xlsheet.cells(3,StartCell).ColumnWidth = 20;			//设置列宽
		 	else if (OrderDesc.length > 20 && OrderDesc.length < 35) xlsheet.cells(3,StartCell).ColumnWidth = 40;			//设置列宽
		 	else if (OrderDesc.length >= 35)xlsheet.cells(3,StartCell).ColumnWidth = 60;			//设置列宽
		 	else xlsheet.cells(3,StartCell).ColumnWidth = 10;			//设置列宽
			xlsheet.cells(3,StartCell).VerticalAlignment = 2;		//垂直对齐方式枚举*(1-靠上，2-居中，3-靠下，4-两端对齐，5-分散对齐)
		 	xlsheet.cells(3,StartCell).Font.Bold = true;
		 	xlsheet.cells(3,StartCell).value = OrderDesc;
		}

		var IADMInfo=iadms.split("^");var StartRow=3;
		for (var i=0; i<IADMInfo.length; i++) {
			var DataInfo=tkMakeServerCall("web.DHCPE.Report.GroupNotNormalStatistic","GetResultByIADMsNew",UserId,StationID,IADMInfo[i]);  // 内容
			if (DataInfo == "") continue;
			StartRow=StartRow+1;
		    var Data=DataInfo.split("^");
		    if (StartRow == 4) {
			    //登记号
		    	//xlsheet.Columns(1).WrapText=true;               //设置为自动换行*
		    	xlsheet.Columns(1).HorizontalAlignment = 3;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(1).ColumnWidth = 12;			//设置列宽
		    	
		    	//姓名
		    	//xlsheet.Columns(2).WrapText=true;               //设置为自动换行*
		    	xlsheet.Columns(2).HorizontalAlignment = 3;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(2).ColumnWidth = 12;			//设置列宽
		    	
		    	//性别
		    	//xlsheet.Columns(3).WrapText=true;               //设置为自动换行*
		    	xlsheet.Columns(3).HorizontalAlignment = 3;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(3).ColumnWidth = 6;			//设置列宽
		    	
		    	//年龄
		    	//xlsheet.Columns(4).WrapText=true;               //设置为自动换行*
		    	xlsheet.Columns(4).HorizontalAlignment = 3;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(4).ColumnWidth = 6;			//设置列宽
		    	
		    	//团体名称
		    	xlsheet.Columns(5).WrapText=true;               //设置为自动换行*
		    	//xlsheet.Columns(5).HorizontalAlignment = 2;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(5).ColumnWidth = 50;			//设置列宽
		    	
		    	//联系电话
		    	//xlsheet.Columns(6).WrapText=true;               //设置为自动换行*
		    	xlsheet.Columns(6).HorizontalAlignment = 3;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(6).ColumnWidth = 15;			//设置列宽
		    	
		    	//总检结论
		    	xlsheet.Columns(Data.length).WrapText=true;               //设置为自动换行*
		    	//xlsheet.Columns(Data.length).HorizontalAlignment = 2;		//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐)
		    	xlsheet.Columns(Data.length).ColumnWidth = 200;			//设置列宽
		    }
    		//xlsheet.Columns(StartCell).RowHeight = 22;				//设置行高
			for(var j=0; j<Data.length; j++) {
			 	var IADMData=Data[j];
			 	var StartCell=j+1;
			 	
				if (i == 0) {
					xlsheet.Columns(StartCell).NumberFormatLocal="@";
    				xlsheet.Columns(StartCell).VerticalAlignment = 2;		//垂直对齐方式枚举*(1-靠上，2-居中，3-靠下，4-两端对齐，5-分散对齐)
					if ( StartCell > 6 ) xlsheet.Columns(StartCell).WrapText=true;   //设置为自动换行*
				}
				
				xlsheet.cells(StartRow,StartCell).value = IADMData;
			}
		}
		var k=1;
		xlsheet.cells(k,1)=PGADMName+"阳性体征及总检建议";
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,Merge)).mergecells=true;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,Merge)).HorizontalAlignment= -4108;
		xlsheet.Rows(k).Font.Name = "黑体";
		xlsheet.cells(k,1).Font.Size = 17;  //设置为10号字*
		xlsheet.cells(k,1).Font.Bold = true;
		xlsheet.Columns(1).NumberFormatLocal="@";

		xlsheet.SaveAs("d:\\" + PGADMName + "阳性体征及总检建议.xls");

	    xlApp.Visible = true;
	    xlApp.UserControl = true;
	} catch(e) {
		xlsheet=null;
		xlApp=null;
		alert(e);
	}
}else{
	BExportGroupAbnormityNewGoogle_click()
	
}
}


function InitCombobox()
{
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GDesc",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onChange:function()
		{
			DepartObj.clear();
			
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}			
			
		]]
		});
		
		
		//部门
	var DepartObj = $HUI.combogrid("#Depart",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.PreGTeam&QueryName=SearchGDepart",
		mode:'remote',
		delay:200,
		idField:'DepartName',
		textField:'DepartName',
		onBeforeLoad:function(param){
			//alert($("#GDesc").combogrid("getValue"))
			param.GID = $("#GDesc").combogrid("getValue");
			//param.TeamID = "";
			//param.GID = 69;
			param.Depart = param.q;
		},
		onShowPanel:function()
		{
			$('#Depart').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'DepartName',title:'部门'}
						
			
		]]
		});
		
	//站点	
	var StationObj = $HUI.combobox("#StationID",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		});

}

//查询
function BFind_click(){
	
	$("#GReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchGReportNew",
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			GID:$("#GDesc").combogrid('getValue')
			});
	
}


function InitGReportQueryTabDataGrid(){
	
	$HUI.datagrid("#GReportQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchGReportNew",
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			GID:$("#GDesc").combogrid('getValue')
				
		},
		columns:[[
		    {field:'RPT_ID',title:'RPT_ID',hidden: true},
		    {field:'GADM_DR',title:'GADM_DR',hidden: true},
			{field:'Grp_Code',width:'150',title:'团体编码'},
			{field:'Grp_RegNo',width:'150',title:'登记号'},
			{field:'Grp_Name',width:'240',title:'团体名称'},
			{field:'PGADM_StatusDesc',width:'60',title:'状态'},
			{field:'GADM_Date',width:'120',title:'日期'},
			{field:'RPT_Status',title:'报告状态',hidden: true},
			{field:'RPT_PrintDate',width:'150',title:'打印日期'},
			{field:'RPT_PrintTime',width:'150',title:'打印时间'},
			{field:'RPT_PrintUser',width:'100',title:'打印人'},
			{field:'PGBILinkman1',width:'100',title:'联系人'},
			{field:'PGBITel1',width:'120',title:'联系电话'},			
		]],
		onSelect: function (rowIndex, rowData) {
			$('#GADM_DR').val(rowData.GADM_DR);
			$('#GADM_DR_Name').val(rowData.Grp_Name);

		}
			
	})
		
}

