var ExpExcel = function(){
	// $lg(^websys.ConfigurationD(1),69) http://127.0.0.1/dthealth/med/Results/Template/
	var path = document.getElementById("path").value;
 	var Template=path+"DHCSSUserFirstLogon.xls";
    xlApp = new ActiveXObject("Excel.Application");	    
   
    xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	row=2;
	var Stdate = document.getElementById("Stdate").value
	var Enddate = document.getElementById("Enddate").value
	var Guser = document.getElementById("Guser").value
	var StartTime = document.getElementById("StartTime").value
	var EndTime = document.getElementById("EndTime").value
	var LogonLoc = document.getElementById("LogonLoc").value
	var DepGroup = document.getElementById("DepGroup").value
    tkMakeServerCall("web.DHCSSUserLogonLog","ExportExcel",Stdate , Enddate , Guser , StartTime, EndTime, 0,LogonLoc,DepGroup)
    xlApp.Visible = true;
    xlBook.SaveAs("D:\\门诊到岗时间查询.xls");   
    
    xlsheet.Quit;
    xlsheet=null;
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
	
}
function setRow(userName,userCode,ldate,ltime,loc){
	row++; 
	xlsheet.cells(row,2)=userName;
	xlsheet.cells(row,3)=userCode;
	xlsheet.cells(row,4)=ldate;
	xlsheet.cells(row,5)=ltime;
	xlsheet.cells(row,6)=loc;
}
var CustomColumns="UserName:%String:用户名,UserCode:%String:工号,Date:%String:登录日期,LogonTime:%String:登录时间,LogofDate:%String:退出日期,LogofTime:%String:退出时间,IP:%String:IP地址,CompName:%String:电脑名,MAC:%String:MAC地址,Loc:%String:科室,SessionId:%String:会话Id";
var columns=CustomColumns.split(","),columnsDesc=[];
for (var i=0;i<columns.length;i++){columnsDesc.push(columns[i].split(":")[2]||columns[i].split(":")[0]);columns[i]=columns[i].split(":")[0];}
var NewExpExcel = function(){
	var Stdate = document.getElementById("Stdate").value;
	var Enddate = document.getElementById("Enddate").value;
	var Guser = document.getElementById("Guser").value;
	var StartTime = document.getElementById("StartTime").value;
	var EndTime = document.getElementById("EndTime").value;
    var rtn=tkMakeServerCall("websys.Query","ToExcelCustomColumns","登录日志","web.DHCSSUserLogonLog","FindUserLog",CustomColumns,Stdate , Enddate , Guser , StartTime, EndTime, 0)
	location.href = rtn;
}
var MyPrint=function(){
	var Stdate = document.getElementById("Stdate").value;
	var Enddate = document.getElementById("Enddate").value;
	var Guser = document.getElementById("Guser").value;
	var StartTime = document.getElementById("StartTime").value;
	var EndTime = document.getElementById("EndTime").value;
	var c2 = String.fromCharCode(2);
	
	var itmInfo = "StDate"+c2+Stdate+"^"+"EndDate"+c2+Enddate;

	$q({ClassName:'web.DHCSSUserLogonLog',QueryName:'FindUserLog',Stdate:Stdate,Enddate:Enddate,Guser:Guser,StartTime:StartTime,EndTime:EndTime,rows:99999},function(rtn){
		var listInfo=columnsDesc.join("^");
		for (var i=0;i<rtn.rows.length;i++){
			var row=rtn.rows[i],arr=[];
			for (var j=0;j<columns.length;j++){
				arr.push(row[columns[j]]);
			}
			listInfo+=c2+arr.join("^");	
		}
		MyPrintOut(itmInfo,listInfo);
	})
}
var MyPrintOut=function(itmInfo,listInfo){
	var printObj = document.getElementById("ClsBillPrint");
	if(!printObj){ alert("没有打印控件");return;}
	DHCP_GetXMLConfig("PrintItemEnc","DHCSSUserLogonLog");
	var c2 = String.fromCharCode(2);
	DHCP_XMLPrint(printObj,itmInfo, listInfo);
	
}

//弹出路径选择框
// from   scripts/dhcadvEvt/jqueryplugins/commonfun.js
function browseFolder()
{  
  try {  
	  var Message = "请选择路径"; //选择框提示信息  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//起始目录为：我的电脑  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // 返回 FolderItems 对象  
		  Folder = Folder.item();  // 返回 Folderitem 对象  
		  Folder = Folder.Path;    // 返回路径  
		  if (Folder.charAt(Folder.length - 1) != "\\"){  
			  Folder = Folder + "\\";  
		  }    
		  return Folder;  
	  }  
  }  
  catch(e) 
  {  
	  alert(e.message);  
  }  
}
///data 二维数组
var MSSimpleExcel=function(operation,data,filefullname){
	//console.log(new Date());  //17
	var xlsApp = new ActiveXObject("Excel.Application");
	var xlsBook = xlsApp.Workbooks.Add();
	var xlsSheet = xlsBook.ActiveSheet;
	var range=xlsSheet.Range(xlsSheet.Cells(1,1), xlsSheet.Cells(data.length,data[0].length))
	range.Cells.Borders.Weight = 1;
	range.Cells.NumberFormatLocal="@";//将单元格的格式定义为文本  //经测试这样统一的修改比一个个cell修改快
	//console.log(new Date());  //18
	for (var i=0;i<data.length;i++){
		var row=data[i];
		for (var j=0;j<row.length;j++){
			var cell=xlsSheet.Cells(i+1,j+1);
			//cell.NumberFormatLocal="@";//将单元格的格式定义为文本   
			//cell.Borders.Weight = 1;
			cell.Value=row[j];
		}	
	}
	range.Columns.AutoFit();
	//console.log(new Date());  //25
	if (operation=="export"){
		xlsBook.SaveAs(filefullname);
	}else if(operation=="print"){
		xlsSheet.PageSetup.Zoom=false;
		xlsSheet.PageSetup.FitToPagesWide=1;
		xlsSheet.PageSetup.PaperSize = 8;  //A3
		xlsSheet.printout();
	}
	xlsBook.Close(savechanges=false);  //27
	//console.log(new Date());
	xlsSheet=null;
	xlsBook=null;
	xlsApp.Quit();
	xlsApp=null;
	//console.log(new Date());  //27 
}
var OperationFun=function(operation){
	var Stdate = document.getElementById("Stdate").value;
	var Enddate = document.getElementById("Enddate").value;
	var Guser = document.getElementById("Guser").value;
	var StartTime = document.getElementById("StartTime").value;
	var EndTime = document.getElementById("EndTime").value;
	var progressBar=showProgressBar("正在处理数据，请勿刷新或关闭页面，请稍候...");
	setTimeout(function(){
		var a = $cm({
			ResultSetType:"ExcelPlugin",
			ResultSetTypeDo:operation,
			//localDir:"Self", 		//用户选择目录
			//localDir:"D:\\xml\\"
			//localDir:"", 			// 桌面，
			ExcelName:"门诊到岗时间查询",				 //默认DHCCExcel
			PageName:"DHCSSUserLogonLog",
			ClassName:"web.DHCSSUserLogonLog",
			QueryName:"FindUserLog",
			Stdate:Stdate ,
			Enddate:Enddate ,
			Guser:Guser , 
			StartTime:StartTime,
			EndTime:EndTime
		},false);
		progressBar.hide()
		//alert("操作成功");
	},0);
	return ;
	$q({ClassName:'web.DHCSSUserLogonLog',QueryName:'FindUserLog',Stdate:Stdate,Enddate:Enddate,Guser:Guser,StartTime:StartTime,EndTime:EndTime,rows:99999},function(rtn){
		var data=[];
		data.push(columnsDesc);
		for (var i=0;i<rtn.rows.length;i++){
			var row=rtn.rows[i],arr=[];
			for (var j=0;j<columns.length;j++){
				arr.push(row[columns[j]]);
			}
			data.push(arr);
		}
		if (operation=="export"){
			var filepath=browseFolder();
	     	if ((typeof filepath!="string")||(!filepath.match(/[a-zA-Z]:\\/))){
		     	alert("无效的导出路径");
		     	return;
		    }
			var filefullpath=filepath+"DHCSSUserLogonLog.xls";
			var progressBar=showProgressBar("正在导出数据，请勿刷新或关闭页面，请稍候...");
			setTimeout(function(){
				MSSimpleExcel(operation,data,filefullpath);
				progressBar.hide()
				alert("导出成功\n"+filefullpath);
			},0);
		}else if(operation=="print"){
			var progressBar=showProgressBar("正在打印数据，请勿刷新或关闭页面，请稍候...");
			setTimeout(function(){
				MSSimpleExcel(operation,data);
				progressBar.hide();
				alert("打印成功");
			},0);

		}
	})
}
var showProgressBar=function(msg){
	return Ext.Msg.show({
	         title:"提示",
	         msg:msg,
	         //progress:true,
	         width:300,
	         closable:false
	     });
}
var bodyonload = function(){
	//var objstr=$m({ClassName:"web.DHCBillPrint",MethodName:"InvBillPrintCLSID",wantreturnval:0},false)
	//$('body').append(objstr)	;
	//var obj = document.getElementById("Exp");
	//obj.onclick = ExpExcel;
	var obj = document.getElementById("Exp");
	//obj.onclick = NewExpExcel;
	obj.onclick = function(){
		OperationFun("export");
	};
	var obj = document.getElementById("Print");
	//obj.onclick = MyPrint;
	obj.onclick = function(){
		OperationFun("print");
	};
}
document.body.onload = bodyonload;