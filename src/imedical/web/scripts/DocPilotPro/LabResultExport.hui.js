$(function(){	
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	$.cm({
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"GetProjectStrDocSelf",
		dataType:"text",
		UserID:session['LOGON.USERID']
	},function(ret){
		var arrDate=new Array();
		for (var i=0;i<ret.split("^").length;i++){
			var PPRowId=ret.split("^")[i].split(String.fromCharCode(1))[0];
			var PPName=ret.split("^")[i].split(String.fromCharCode(1))[1];
			var PlanName=ret.split("^")[i].split(String.fromCharCode(1))[2];
			arrDate.push({"id":PPRowId,"text":PPName,"PlanName":PlanName});
		}
		var cbox = $HUI.combobox("#PPList", {
				valueField: 'id',
				textField: 'text', 
				editable:true,
				data: arrDate,
				panelHeight:'155',
				onChange:function(newValue,OldValue){
					if (newValue==""){
						var cbox = $HUI.combobox("#PPList");
						cbox.setValue("");
					}
				}
		 });
	}); 
}
function InitEvent(){
	$("#Export").click(ExportClickHandle);
}
/*function ExportClickHandle(){
var Str ="(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
		"var xlBook = xlApp.Workbooks.Add('D://tpl.xlsx');"+
		"var xlSheet = xlBook.ActiveSheet;"+
		"xlSheet.Cells(1,1).Value='第一行一列';"+
		"xlSheet.Columns(2).NumberFormatLocal='@';"+	//设置登记号为文本型 
		"xlSheet.Cells(2,2).Value='10002';"+
		"xlSheet.Cells(3,2).Value='0003';"+ 
		"xlSheet.Range(xlSheet.cells(7,1),xlSheet.cells(7,11)).BorderS(4).LineStyle=7;"+ 
		"xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,4)).mergecells=true;"+  //合并单元格
		"xlSheet.Cells(2,1).Font.Bold = true;"		//设置加粗
		"xlSheet.Cells(2,2).Font.Size = 14;"+		//设置字号
		"xlSheet.cells(2,2).Font.Underline = true;"+//设置字体下划线;
		"xlApp.Visible = false;"+
		"xlApp.UserControl = false;"+
		"xlSheet.PrintOut();"+
		"xlBook.Close(savechanges=false);"+
		"xlApp.Quit();"+
		"xlSheet=null;"+
		"xlBook=null;"+
		"xlApp=null;"+
		"return 1;}());";
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
		varrtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return;
}*/
function ExportClickHandle(){
	var PPRowId=$("#PPList").combobox("getValue");
	PPRowId=CheckComboxSelData("PPList",PPRowId);
	if (PPRowId=="") {
		$.messager.alert("提示","请选择临床试验项目","info",function(){
			$('#PPRowId').next('span').find('input').focus();
		});
		return false;
	}
	var StartScreenNo=$("#StartScreenNo").val();
	if (StartScreenNo=="") {
		$.messager.alert("提示","请录入开始筛选号","info",function(){
			$("#StartScreenNo").focus();
		});
		return false;
	}
	var EndScreenNo=$("#EndScreenNo").val();
	if (Trim(EndScreenNo)=="") EndScreenNo=StartScreenNo;
	var RtnStr=$.cm({ 
		ClassName:"web.PilotProject.DHCDocPilotProject",
		MethodName:"ProExportLabByScreenNo", 
		dataType:"text",
		PPRowId:PPRowId,
		StartScreenNo:StartScreenNo,
		EndScreenNo:EndScreenNo,
		UserID:session["LOGON.USERID"]
	},false);
	var Totle=0,Job="";
	if (RtnStr!=0) {
		Totle=RtnStr.split("@")[0];
		Job=RtnStr.split("@")[1];
	}
	if (parseFloat(Totle) < 1) {
		$.messager.alert("提示","没有可导出的记录.");
		return false;
	}
	/*$.cm({
	     ExcelName:"患者查找单",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "web.PilotProject.DHCDocPilotProject",
	     QueryName : "ExportProLabItem",
	     UserID:session['LOGON.USERID'],
		 Job:Job,
		 Count:Totle,
	     rows:99999
	 },false);
	 $.messager.popover({msg: '导出成功！',type:'success',timeout: 1000});
	 return;*/
	/*var TemplatePath=$.cm({
		ClassName:"web.UDHCJFCOMMON",
		MethodName:"getpath",
		dataType:"text"
	},false);
	var FileName=TemplatePath+"UDHCDocProExportLab.xlsx";*/
	var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"
		Str +="var xlBook = xlApp.Workbooks.Add();"
		Str +="var xlSheet = xlBook.ActiveSheet;"
		Str +="xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,10)).mergecells=true;"  //合并单元格
		Str +="xlSheet.cells(1,1)='筛选号从"+StartScreenNo+"至"+EndScreenNo+"的病人检验结果记录';";
		Str +="xlSheet.cells(2,1)='监测项目';";
		Str +="xlSheet.cells(2,2)='项目名称';";
		Str +="xlSheet.cells(2,3)='项目缩写';";
		Str +="xlSheet.cells(2,4)='项目结果';";
		Str +="xlSheet.cells(2,5)='异常提示';";
		Str +="xlSheet.cells(2,6)='单位';";
		Str +="xlSheet.cells(2,7)='参考范围';";
		Str +="xlSheet.cells(2,8)='结果说明';";
		Str +="xlSheet.cells(2,9)='检测方法';";
		Str +="xlSheet.cells(2,10)='显示序号';";
		for (var i=1;i <= parseFloat(Totle);i++) {
			var LabResultStr=$.cm({
				ClassName:"web.PilotProject.DHCDocPilotProject",
				MethodName:"ProExportLabOneItem",
				dataType:'text',  
				UserID:session['LOGON.USERID'],
				Job:Job,
				Count:i
			},false);
			for (var j=0;j<LabResultStr.split('$').length;j++) {
				Str +="xlSheet.Columns("+(j+1)+").NumberFormatLocal='@';"	//设置登记号为文本型 
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+LabResultStr.split('$')[j]+"';";
			}
			if (LabResultStr.split('$')[1]=="") {
				Str +="xlSheet.Range(xlSheet.Cells("+(i+2)+",1),xlSheet.Cells("+(i+2)+",10)).mergecells=true;"  //合并单元格
			}
		}
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds();
		var filename="检验结果记录"+h+m+s+".xls";
		//Str +="Set WshShell=new ActiveXObject('Wscript.Shell');"
		//Str +="Set strDesktop = WshShell.SpecialFolders('Desktop');"
		//Str +="xlBook.SaveAs(strDesktop & '\\"+filename+"');"
		
		Str += "var fname = xlApp.Application.GetSaveAsFilename('"+filename+"', 'Excel Spreadsheets (*.xls), *.xls');" 
		Str += "xlBook.SaveAs(fname);"
		Str +="xlApp.Visible = false;"
		Str +="xlApp.UserControl = false;"
		Str +="xlBook.Close(savechanges=false);"
		Str +="xlApp.Quit();"
		Str +="xlSheet=null;"
		Str +="xlBook=null;"
		Str +="xlApp=null;"
		Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn =1;   //设置无结果调用，不阻塞调用
	var rtn =CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
	/*try {
		var TemplatePath=$.cm({
			ClassName:"web.UDHCJFCOMMON",
			MethodName:"getpath",
			dataType:"text"
		},false);
		var PPRowId=$("#PPList").combobox("getValue");
		PPRowId=CheckComboxSelData("PPList",PPRowId);
		if (PPRowId=="") {
			$.messager.alert("提示","请选择临床试验项目","info",function(){
				$('#PPRowId').next('span').find('input').focus();
			});
			return false;
		}
		var StartScreenNo=$("#StartScreenNo").val();
		if (StartScreenNo=="") {
			$.messager.alert("提示","请录入开始筛选号","info",function(){
				$("#StartScreenNo").focus();
			});
			return false;
		}
		var EndScreenNo=$("#EndScreenNo").val();
		if (Trim(EndScreenNo)=="") EndScreenNo=StartScreenNo;
		var RtnStr=$.cm({ 
			ClassName:"web.PilotProject.DHCDocPilotProject",
			MethodName:"ProExportLabByScreenNo", 
			dataType:"text",
			PPRowId:PPRowId,
			StartScreenNo:StartScreenNo,
			EndScreenNo:EndScreenNo,
			UserID:session["LOGON.USERID"]
		},false);
		var Totle=0,Job="";
		if (RtnStr!=0) {
			Totle=RtnStr.split("@")[0];
			Job=RtnStr.split("@")[1];
		}
		if (parseFloat(Totle) < 1) {
			$.messager.alert("提示","没有可导出的记录.");
			return false;
		}
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"UDHCDocProExportLab.xlsx";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;
	    xlsheet.PageSetup.RightMargin=0;
		xlsheet.cells(3,1)="筛选号从"+StartScreenNo+"至"+EndScreenNo+"的病人检验结果记录";
		for (var i=1;i <= parseFloat(Totle);i++) {
			var LabResultStr=$.cm({ 
				ClassName:"web.PilotProject.DHCDocPilotProject",
				MethodName:"ProExportLabOneItem", 
				dataType:"text",  
				UserID:session["LOGON.USERID"],
				Job:Job,
				Count:i
			},false);
			for (var j=0;j<LabResultStr.split("$").length;j++) {
				xlsheet.cells(i+5,j+1)=LabResultStr.split("$")[j];
			}
		}
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    xlBook.SaveAs("D:\\检验结果记录"+h+m+s+".xlsx");  
	    xlBook.Close (savechanges=false);
	    $.messager.alert("提示","文件将保存在您的D盘根目录下","info",function(){
		    xlApp=null;
		    xlBook=null;
		    xlsheet.Quit();
		    xlsheet=null;
		});
	} catch(e) {
		$.messager.alert("提示",e.message);
	};*/
}
function Trim(str){
	return str.replace(/(^\s*)|(\s*$)/g, "");  
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		  var CombValue=Data[i].id;
		  var CombDesc=Data[i].text;
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}