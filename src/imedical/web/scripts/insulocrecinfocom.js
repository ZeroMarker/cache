
///******************************************************************
///����˵����
///          ���ݵ���
///******************************************************************
//���ҵ���
function InLocImpt()
{		
	importDiag();		
}

function importDiag()
{
	try{
		
	   //var fd = new ActiveXObject("MSComDlg.CommonDialog");
      // fd.Filter = "*.xls"; //�����ļ����
      //fd.FilterIndex = 2;
      //fd.MaxFileSize = 128;
	 //fd.ShowSave();//�������Ҫ�򿪵Ļ�����Ҫ��fd.ShowOpen();
    //fd.ShowOpen();
    //filePath=fd.filename;//fd.filename���û���ѡ��·��
   var filePath="";
	filePath=FileOpenWindow();
	
	$.messager.progress({
				title: "��ʾ",
				msg: '���ڵ����������',
				text: '������....'
			}
			);
			
			
			
   if(filePath=="")
    {
	   $.messager.alert('��ʾ','��ѡ���ļ���','info')
	    return ;
     }
   
   
    
    var ErrMsg="";     //��������
    var errRowNums=0;  //��������
    var sucRowNums=0;  //����ɹ�������
    
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
    var xlsheet = xlBook.ActiveSheet;
    
    var rows=xlsheet.usedrange.rows.count;
    var columns=xlsheet.usedRange.columns.count;

	try{

		for(i=2;i<=rows;i++){
			var pym="";
			var UpdateStr=buildImportStr(xlsheet,i);
			var savecode=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",UpdateStr)
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
				
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			setTimeout('$.messager.progress("close");', 1 * 1000);
			$.messager.alert('��ʾ','������ȷ�������','info');
		}else{
			setTimeout('$.messager.progress("close");', 1 * 1000);
			var tmpErrMsg="�ɹ����롾"+sucRowNums+"/"+(rows-1)+"��������";
			tmpErrMsg=tmpErrMsg+"ʧ�������к����£�\n\n"+ErrMsg;
			$.messager.alert('������ʾ',tmpErrMsg,'error');   
		}
	}
	catch(e){
		$.messager.alert('������ʾ',"����ʱ�����쳣0��ErrInfo��"+e.message,'info');  
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}
	
 }
catch(e){
	$.messager.alert('��ʾ',"����ʱ�����쳣1��"+e.message);
	
}
finally{
	setTimeout('$.messager.progress("close");', 1 * 1000);
} 
	
    
   
}
function buildImportStr(xlsheet,rowindex){
	var tmpVal="";
	
	//Rowid^���Ҵ���^��������^��������^��׼���Ҵ���^רҵ���Ҵ���^����Dr^������λ��^ʵ�ʴ�λ��^���ҳ���ʱ��^ҽʦ����^��ʦ����^ҩʦ����^��ʦ����^���Ҹ�����^���Ҹ����˵绰^������ʿ��^������ʿ���绰^�Ƿ��ص����^�ص���ҵȼ�^�����Ƿ�������^ҽԺ��������^��ʼ����^��ʼʱ��^��������^����ʱ��^��Ч��ʶ^������Dr^��������^����ʱ��^��ע^��չ01^��չ02^��չ03^��չ04^��չ05
	
	//1-5 Rowid^���Ҵ���^��������^��������^��׼���Ҵ���^
	var updateStr="";
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,1).value);                     //����
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,2).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,3).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,4).value);       
	//6-10 רҵ���Ҵ���^����Dr^������λ��^ʵ�ʴ�λ��^���ҳ���ʱ��^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,5).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,6).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,7).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,8).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,9).value);		//

	//11-15 ҽʦ����^��ʦ����^ҩʦ����^��ʦ����^���Ҹ�����^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,10).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,11).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,12).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,13).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,14).value);		//

	//16-20 ���Ҹ����˵绰^������ʿ��^������ʿ���绰^�Ƿ��ص����^�ص���ҵȼ�^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,15).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,16).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,17).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,18).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,19).value);		//

	//21-25 �����Ƿ�������^ҽԺ��������^��ʼ����^��ʼʱ��^��������^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,20).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,21).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,22).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,23).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,24).value);		//

	//26-30 ����ʱ��^��Ч��ʶ^������Dr^��������^����ʱ��^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,25).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,26).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,27).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,28).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,29).value);		//

	//31-36 ��ע^��չ01^��չ02^��չ03^��չ04^��չ05
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,30).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,31).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,32).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,33).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,34).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,35).value);		//
	
	return updateStr;
}
function SetValue(value)
{
	if(value == undefined)
	{
		value="" ;
	}
	
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}





//���ҵ���
function InLocEpot()
{
	try
	{
				
	var rtn = $cm({
	dataType:'text',
	ResultSetType:"Excel",
	ExcelName:"������Ϣά��", //Ĭ��DHCCExcel
	ClassName:"web.DHCINSULocInfoCtl",
	QueryName:"QryInLocInfo",
	InRowid:"",
	KeyWords:$('#KeyWords').val(),
	HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
     },false);
     location.href = rtn;
	$.messager.progress({
				title: "��ʾ",
				msg: '���ڵ�����������',
				text: '������....'
			});
	setTimeout('$.messager.progress("close");', 3 * 1000);	
		
		return;
	} catch(e) {
		$.messager.alert("����",e.message);
		$.messager.progress('close');
	};
	
	
	}

function FileOpenWindow(){
	if($('#FileWindowDiv').length==0){
		$('#FileWindowDiv').empty();
		
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("body").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
	}
	$('#FileWindow').val("");
	$('#FileWindow').select();
	$(".FileWindow input").click();
	var FilePath=$('#FileWindow').val();
	
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	
	var filePath=$(this).val();
	
});