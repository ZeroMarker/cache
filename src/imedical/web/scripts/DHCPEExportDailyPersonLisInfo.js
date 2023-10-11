/// DHCPEExportDailyPersonLisInfo.js

$(function(){
			
	Initdate();
	
	//初始化Grid
	InitPersonStatisticGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
	   
    //导出数据
	$("#BExport").click(function() {	
		BExport_click();		
        });
        
        
    //导出数据
	$("#BImport").click(function() {	
		BImport_click();		
        });    
      
})


function BImport_click(){
	
	var lnk="DHCPEImportDailyPersonLisInfo.csp"
	 $HUI.window("#ImportGWin", {
        title: "导入信息",
        iconCls: "icon-w-import",
        collapsible: false,
        minimizable: false,
        maximizable: true,
        resizable: true,
        closable: true,
        modal: true,
        width: 1200,
        height: 700,
        content: '<iframe src="' + PEURLAddToken(lnk)+ '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	
	
	}
function BExport_click()
{
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportDailyPersonLisInfo.xlsx';
	
	
	var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet= xlBook.ActiveSheet;"
	
	var User=session['LOGON.USERID']
	var NumStr=tkMakeServerCall("web.DHCPE.SecretPE","GetRowNum","ExportDailyPersonLisInfo")
	var Num=NumStr.split("^")
	var Rows=Num.length
	     var ret=""
		for (var i=1;i<=Rows;i++){
			//alert(i)
			var Datas=tkMakeServerCall("web.DHCPE.SecretPE","ExportStationWorkInfo",i,"ExportDailyPersonLisInfo")
            //alert(Datas)
			var DayData=Datas.split("^");
			var n=i+1
		
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				var m=iDayLoop+1
				//alert(DayData[iDayLoop])
				ret=ret+"xlSheet.Cells("+n+","+m+").Value='"+DayData[iDayLoop]+"';"
			}

		}
	var k=parseInt(Rows)+1;	
	//alert(Str)
	var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",9)).Borders.LineStyle='1';"+
         	"xlApp.Visible = true;"+
           // "xlApp.UserControl = true;"+
          	//"xlBook.Close(savechanges=true);"+
           // "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
            //alert(Str)
		//以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
       //alert(Str)
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ;

	
	}

function BExport_clickOld()
{
	try{
		var obj;
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
		var Templatefilepath=prnpath+'DHCPEExportDailyPersonLisInfo.xlsx';
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
    	xlApp.visible = true; //显示 
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1");  
		
		/*
		obj=document.getElementById('GetRowNum');
		 if (obj) {var encmeth=obj.value; } else {var encmeth=''; };
		 var NumStr=cspRunServerMethod(encmeth);
		 
		 */
		 var NumStr=tkMakeServerCall("web.DHCPE.SecretPE","GetRowNum");
		 var Num=NumStr.split("^")
		k=2
		for (j=0;j<Num.length;j++)
		{  
		    /*
			var Ins=document.getElementById('GetStationWorkInfoBox');
		    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		    	
		    	var DataStr=cspRunServerMethod(encmeth,Num[j]);
		    	*/
		    	
		    	var DataStr=tkMakeServerCall("web.DHCPE.SecretPE","ExportStationWorkInfo",Num[j]);
		    	
		    	//alert(DataStr)
		    	if (""==DataStr) { return false; }
// TRegNo_"^"_PatName_"^"_GDesc_"^"_ARCIMDesc_"^"_Status_"^"_OSTATDesc_"^"_ADMPEDateBegin_"^"_ADMPEDateEnd_"^"_FactPrice_"^"_ARCIMPrice

		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
			    xlsheet.cells(k+j,3)=Data[8] 
			    xlsheet.cells(k+j,4)=Data[2] 
			    xlsheet.cells(k+j,5)=Data[3] 
			    xlsheet.cells(k+j,6)=Data[4] 
			    xlsheet.cells(k+j,7)=Data[5] 
			    xlsheet.cells(k+j,8)=Data[6] 
			    xlsheet.cells(k+j,9)=Data[7] 
			    
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,9)).Borders.LineStyle   = 1
			   
		} 
	   /*
   		var SaveDir="d:\\科室工作量统计.xls";
   		xlsheet.SaveAs(SaveDir);
   		xlApp.Visible = true;
   		xlApp.UserControl = true;  
		*/
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;
                                

                                //直接弹出
                                xlApp.Visible = true;
                                xlApp.UserControl = true;
                                
		
   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
	
	} 



//查询
function BFind_click(){

	$("#PersonStatisticGrid").datagrid('load',{
			ClassName:"web.DHCPE.SecretPE",
			QueryName:"ExportDailyPersonLisInfo",
			PEBeginDate:$("#BeginDate").datebox('getValue'),
			PEEndDate :$("#EndDate").datebox('getValue')
			});
}


function InitPersonStatisticGrid(){
	$HUI.datagrid("#PersonStatisticGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 1000,
		pageList : [20,100,200,1000],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SecretPE",
			QueryName:"ExportDailyPersonLisInfo",

		},
		columns:[[
			{field:'PreIADM',width:100,title:'预约id'},
			{field:'PAADM',width:100,title:'就诊id'},
			{field:'IADMDate',title:'体检日期'},
			
			
			{field:'PatName',width:150,title:'姓名'},
			{field:'PatSex',width:60,title:'性别'},
			{field:'PatAge',width:100,title:'出生日期'},
			{field:'PatIDCard',width:180,title:'身份证号'},
			{field:'PatTel',width:150,title:'手机号',},
			{field:'LisStr',nowrap:false,title:'Lis医嘱串',},
		
					
			
			
			
		]],
			
	});
}






//设置默认时间
function Initdate()
{
	var today = getDefStDate(0);
	var day = getDefStDate(0);
	$("#BeginDate").datebox('setValue', today);
	$("#EndDate").datebox('setValue', day);
	$("#ARRIVED").checkbox('setValue',true);
}
