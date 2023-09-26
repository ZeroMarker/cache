///导入业务代码与类方法对照关系  DHCPEImportServiceAction.js
///Creater wangguoying


/*
	Type="Cover"  完全覆盖
	Type="Add"    追加
	Type="ForceAdd" 强制追加，业务代码已存在时更新原来记录 
 */
function Import(Template,Type)
{
	
	var xlApp,xlsheet,xlBook;
	try
	{
		var IInString="";
		
		xlApp = new ActiveXObject("Excel.Application");
		
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.WorkSheets(1);
		
		var job=tkMakeServerCall("web.DHCPE.DHCPEServiceAction","GetJob");
		tkMakeServerCall("web.DHCPE.DHCPEServiceAction","KillImportGlobal",job);
		var i = 2
		var num=0;
		while (Flag=1)
		{
			//每30行记录调用一次后台方法  插入global
			if(num>=30){
				num=0;
				tkMakeServerCall("web.DHCPE.DHCPEServiceAction","InsertImportGlobal",job,IInString);
				IInString="";
			}
			StrValue=Trim(StringIsNull(xlsheet.cells(i,1).Value));
			if (StrValue=="") break;
			if(IInString=="")
				IInString=StrValue; //ActionCode
			else
				IInString=IInString+"@"+StrValue; //ActionCode
			
			
			StrValue=Trim(StringIsNull(xlsheet.cells(i,2).Value));
			IInString=IInString+"^"+StrValue; //ActionName
			
			StrValue=Trim(StringIsNull(xlsheet.cells(i,3).Value));
			if (StrValue=="") {
				//设置背景色为红色
				xlsheet.Rows(i).Interior.ColorIndex = 7;
				i++;
				IInString=IInString.substring(0,IInString.lastIndexOf("@")-1);
				continue;
			}
			IInString=IInString+"^"+StrValue; //ClassName
			
			StrValue=Trim(StringIsNull(xlsheet.cells(i,4).Value));
			if (StrValue=="") {
				//设置背景色为红色
				xlsheet.cells(i,4).Interior.ColorIndex = 7;
				i++;
				IInString=IInString.substring(0,IInString.lastIndexOf("@")-1);
				continue;
			}
			IInString=IInString+"^"+StrValue; //MethodName
			num++;
			i++;
		}
		if(IInString!=""){
			tkMakeServerCall("web.DHCPE.DHCPEServiceAction","InsertImportGlobal",job,IInString);
		}
		xlBook.SaveCopyAs(Template);
		CloseExcel(xlApp,xlBook,xlsheet);
		var Return=tkMakeServerCall("web.DHCPE.DHCPEServiceAction","RunImport",job,i-2,Type);
		if(parseInt(Return)!=0){
			$.messager.alert("失败",Return.split("^")[1]);
		}else{
			$.messager.alert("成功","导入成功");
			
		}		
		return false;
	}
	catch(e)
	{
		$.messager.alert("异常",e+"^"+e.message);
	}
}
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function StringIsNull(String)
{
	if (String==null) return ""
	return String
}
//彻底清除打开的Excel进程
function CloseExcel(xlApp,xlBook,xlsheet)
{
	xlBook.Close (savechanges=false);		
	xlApp.Quit();     
	xlApp   =   null; 
	xlsheet=null;  
	
}