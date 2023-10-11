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
    xlBook.SaveAs("D:\\���ﵽ��ʱ���ѯ.xls");   
    
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
var CustomColumns="UserName:%String:�û���,UserCode:%String:����,Date:%String:��¼����,LogonTime:%String:��¼ʱ��,LogofDate:%String:�˳�����,LogofTime:%String:�˳�ʱ��,IP:%String:IP��ַ,CompName:%String:������,MAC:%String:MAC��ַ,Loc:%String:����,SessionId:%String:�ỰId";
var columns=CustomColumns.split(","),columnsDesc=[];
for (var i=0;i<columns.length;i++){columnsDesc.push(columns[i].split(":")[2]||columns[i].split(":")[0]);columns[i]=columns[i].split(":")[0];}
var NewExpExcel = function(){
	var Stdate = document.getElementById("Stdate").value;
	var Enddate = document.getElementById("Enddate").value;
	var Guser = document.getElementById("Guser").value;
	var StartTime = document.getElementById("StartTime").value;
	var EndTime = document.getElementById("EndTime").value;
    var rtn=tkMakeServerCall("websys.Query","ToExcelCustomColumns","��¼��־","web.DHCSSUserLogonLog","FindUserLog",CustomColumns,Stdate , Enddate , Guser , StartTime, EndTime, 0)
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
	if(!printObj){ alert("û�д�ӡ�ؼ�");return;}
	DHCP_GetXMLConfig("PrintItemEnc","DHCSSUserLogonLog");
	var c2 = String.fromCharCode(2);
	DHCP_XMLPrint(printObj,itmInfo, listInfo);
	
}

//����·��ѡ���
// from   scripts/dhcadvEvt/jqueryplugins/commonfun.js
function browseFolder()
{  
  try {  
	  var Message = "��ѡ��·��"; //ѡ�����ʾ��Ϣ  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//��ʼĿ¼Ϊ���ҵĵ���  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // ���� FolderItems ����  
		  Folder = Folder.item();  // ���� Folderitem ����  
		  Folder = Folder.Path;    // ����·��  
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
///data ��ά����
var MSSimpleExcel=function(operation,data,filefullname){
	//console.log(new Date());  //17
	var xlsApp = new ActiveXObject("Excel.Application");
	var xlsBook = xlsApp.Workbooks.Add();
	var xlsSheet = xlsBook.ActiveSheet;
	var range=xlsSheet.Range(xlsSheet.Cells(1,1), xlsSheet.Cells(data.length,data[0].length))
	range.Cells.Borders.Weight = 1;
	range.Cells.NumberFormatLocal="@";//����Ԫ��ĸ�ʽ����Ϊ�ı�  //����������ͳһ���޸ı�һ����cell�޸Ŀ�
	//console.log(new Date());  //18
	for (var i=0;i<data.length;i++){
		var row=data[i];
		for (var j=0;j<row.length;j++){
			var cell=xlsSheet.Cells(i+1,j+1);
			//cell.NumberFormatLocal="@";//����Ԫ��ĸ�ʽ����Ϊ�ı�   
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
	var progressBar=showProgressBar("���ڴ������ݣ�����ˢ�»�ر�ҳ�棬���Ժ�...");
	setTimeout(function(){
		var a = $cm({
			ResultSetType:"ExcelPlugin",
			ResultSetTypeDo:operation,
			//localDir:"Self", 		//�û�ѡ��Ŀ¼
			//localDir:"D:\\xml\\"
			//localDir:"", 			// ���棬
			ExcelName:"���ﵽ��ʱ���ѯ",				 //Ĭ��DHCCExcel
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
		//alert("�����ɹ�");
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
		     	alert("��Ч�ĵ���·��");
		     	return;
		    }
			var filefullpath=filepath+"DHCSSUserLogonLog.xls";
			var progressBar=showProgressBar("���ڵ������ݣ�����ˢ�»�ر�ҳ�棬���Ժ�...");
			setTimeout(function(){
				MSSimpleExcel(operation,data,filefullpath);
				progressBar.hide()
				alert("�����ɹ�\n"+filefullpath);
			},0);
		}else if(operation=="print"){
			var progressBar=showProgressBar("���ڴ�ӡ���ݣ�����ˢ�»�ر�ҳ�棬���Ժ�...");
			setTimeout(function(){
				MSSimpleExcel(operation,data);
				progressBar.hide();
				alert("��ӡ�ɹ�");
			},0);

		}
	})
}
var showProgressBar=function(msg){
	return Ext.Msg.show({
	         title:"��ʾ",
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