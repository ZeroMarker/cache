///����ҵ��������෽�����չ�ϵ  DHCPEImportServiceAction.js
///Creater wangguoying


/*
	Type="Cover"  ��ȫ����
	Type="Add"    ׷��
	Type="ForceAdd" ǿ��׷�ӣ�ҵ������Ѵ���ʱ����ԭ����¼ 
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
			//ÿ30�м�¼����һ�κ�̨����  ����global
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
				//���ñ���ɫΪ��ɫ
				xlsheet.Rows(i).Interior.ColorIndex = 7;
				i++;
				IInString=IInString.substring(0,IInString.lastIndexOf("@")-1);
				continue;
			}
			IInString=IInString+"^"+StrValue; //ClassName
			
			StrValue=Trim(StringIsNull(xlsheet.cells(i,4).Value));
			if (StrValue=="") {
				//���ñ���ɫΪ��ɫ
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
			$.messager.alert("ʧ��",Return.split("^")[1]);
		}else{
			$.messager.alert("�ɹ�","����ɹ�");
			
		}		
		return false;
	}
	catch(e)
	{
		$.messager.alert("�쳣",e+"^"+e.message);
	}
}
//ȥ���ַ������˵Ŀո�
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
//��������򿪵�Excel����
function CloseExcel(xlApp,xlBook,xlsheet)
{
	xlBook.Close (savechanges=false);		
	xlApp.Quit();     
	xlApp   =   null; 
	xlsheet=null;  
	
}