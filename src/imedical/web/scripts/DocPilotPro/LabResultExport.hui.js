$(function(){	
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	//�¼���ʼ��
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
		"xlSheet.Cells(1,1).Value='��һ��һ��';"+
		"xlSheet.Columns(2).NumberFormatLocal='@';"+	//���õǼǺ�Ϊ�ı��� 
		"xlSheet.Cells(2,2).Value='10002';"+
		"xlSheet.Cells(3,2).Value='0003';"+ 
		"xlSheet.Range(xlSheet.cells(7,1),xlSheet.cells(7,11)).BorderS(4).LineStyle=7;"+ 
		"xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,4)).mergecells=true;"+  //�ϲ���Ԫ��
		"xlSheet.Cells(2,1).Font.Bold = true;"		//���üӴ�
		"xlSheet.Cells(2,2).Font.Size = 14;"+		//�����ֺ�
		"xlSheet.cells(2,2).Font.Underline = true;"+//���������»���;
		"xlApp.Visible = false;"+
		"xlApp.UserControl = false;"+
		"xlSheet.PrintOut();"+
		"xlBook.Close(savechanges=false);"+
		"xlApp.Quit();"+
		"xlSheet=null;"+
		"xlBook=null;"+
		"xlApp=null;"+
		"return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		varrtn =CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
		return;
}*/
function ExportClickHandle(){
	var PPRowId=$("#PPList").combobox("getValue");
	PPRowId=CheckComboxSelData("PPList",PPRowId);
	if (PPRowId=="") {
		$.messager.alert("��ʾ","��ѡ���ٴ�������Ŀ","info",function(){
			$('#PPRowId').next('span').find('input').focus();
		});
		return false;
	}
	var StartScreenNo=$("#StartScreenNo").val();
	if (StartScreenNo=="") {
		$.messager.alert("��ʾ","��¼�뿪ʼɸѡ��","info",function(){
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
		$.messager.alert("��ʾ","û�пɵ����ļ�¼.");
		return false;
	}
	/*$.cm({
	     ExcelName:"���߲��ҵ�",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "web.PilotProject.DHCDocPilotProject",
	     QueryName : "ExportProLabItem",
	     UserID:session['LOGON.USERID'],
		 Job:Job,
		 Count:Totle,
	     rows:99999
	 },false);
	 $.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
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
		Str +="xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(1,10)).mergecells=true;"  //�ϲ���Ԫ��
		Str +="xlSheet.cells(1,1)='ɸѡ�Ŵ�"+StartScreenNo+"��"+EndScreenNo+"�Ĳ��˼�������¼';";
		Str +="xlSheet.cells(2,1)='�����Ŀ';";
		Str +="xlSheet.cells(2,2)='��Ŀ����';";
		Str +="xlSheet.cells(2,3)='��Ŀ��д';";
		Str +="xlSheet.cells(2,4)='��Ŀ���';";
		Str +="xlSheet.cells(2,5)='�쳣��ʾ';";
		Str +="xlSheet.cells(2,6)='��λ';";
		Str +="xlSheet.cells(2,7)='�ο���Χ';";
		Str +="xlSheet.cells(2,8)='���˵��';";
		Str +="xlSheet.cells(2,9)='��ⷽ��';";
		Str +="xlSheet.cells(2,10)='��ʾ���';";
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
				Str +="xlSheet.Columns("+(j+1)+").NumberFormatLocal='@';"	//���õǼǺ�Ϊ�ı��� 
				Str +="xlSheet.cells("+(i+2)+","+(j+1)+")='"+LabResultStr.split('$')[j]+"';";
			}
			if (LabResultStr.split('$')[1]=="") {
				Str +="xlSheet.Range(xlSheet.Cells("+(i+2)+",1),xlSheet.Cells("+(i+2)+",10)).mergecells=true;"  //�ϲ���Ԫ��
			}
		}
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds();
		var filename="��������¼"+h+m+s+".xls";
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
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn =1;   //�����޽�����ã�����������
	var rtn =CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	/*try {
		var TemplatePath=$.cm({
			ClassName:"web.UDHCJFCOMMON",
			MethodName:"getpath",
			dataType:"text"
		},false);
		var PPRowId=$("#PPList").combobox("getValue");
		PPRowId=CheckComboxSelData("PPList",PPRowId);
		if (PPRowId=="") {
			$.messager.alert("��ʾ","��ѡ���ٴ�������Ŀ","info",function(){
				$('#PPRowId').next('span').find('input').focus();
			});
			return false;
		}
		var StartScreenNo=$("#StartScreenNo").val();
		if (StartScreenNo=="") {
			$.messager.alert("��ʾ","��¼�뿪ʼɸѡ��","info",function(){
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
			$.messager.alert("��ʾ","û�пɵ����ļ�¼.");
			return false;
		}
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"UDHCDocProExportLab.xlsx";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;
	    xlsheet.PageSetup.RightMargin=0;
		xlsheet.cells(3,1)="ɸѡ�Ŵ�"+StartScreenNo+"��"+EndScreenNo+"�Ĳ��˼�������¼";
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
	    xlBook.SaveAs("D:\\��������¼"+h+m+s+".xlsx");  
	    xlBook.Close (savechanges=false);
	    $.messager.alert("��ʾ","�ļ�������������D�̸�Ŀ¼��","info",function(){
		    xlApp=null;
		    xlBook=null;
		    xlsheet.Quit();
		    xlsheet=null;
		});
	} catch(e) {
		$.messager.alert("��ʾ",e.message);
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