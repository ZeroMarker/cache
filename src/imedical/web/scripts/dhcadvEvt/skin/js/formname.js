var HospDr="" ;
$(function(){ 
    //��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
    InitHosp(); 
	//��ʼ������Ĭ����Ϣ
	InitDefault();
	
});
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_AdvFormName"); 
	HospDr=hospComp.getValue(); //cy 2021-04-09
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue(); //cy 2021-04-09
		Query();
	}
	$("#_HospBtn").bind('click',function(){
		var rowData = $("#datagrid").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("��ʾ","��ѡ��һ�У�");
			return false;
		}
		GenHospWin("DHC_AdvFormName",rowData.ID);
	})

}

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	$HUI.radio("#queryTypey").setValue(true);
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			Query(); 
     	}
	}
	$HUI.radio("[name='queryType']",{
		onChecked:function(){
   			Query(); 
		}
  	});
  	Query();
}

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'HospDr':HospDr}});
}

function save(){
	saveByDataGrid("web.DHCADVFormName","save","#datagrid",function(data){
		//�޸�
		if(data==0){
			$.messager.alert('��ʾ','����ɹ�');
			$("#datagrid").datagrid('reload'); 
		}else{
		 	if((data=11)||(data=12)){
				$.messager.alert('��ʾ','����ʧ��:�������Ѵ���!');
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data);
			}
		}
		
	});	
}
/// ��ѯ ��Ժ������ cy 2021-04-09
function Query(){
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'});
}

function formItm(){
	window.location.href="dhcadv.formdic.csp";
}
function edit(){
	var rowsData = $("#datagrid").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	if($('#editlayoutwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="editlayoutwin"></div>');
	$('#editlayoutwin').window({
		title:'������',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:screen.availWidth-300,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-150,
		top:$('body').scrollTop()+(50/8)
	});
	//������
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layout.csp?id='+rowsData.ID+'"></iframe>'; 
	$('#editlayoutwin').html(iframe);
	$('#editlayoutwin').window('open');	
}

function delName(){
	var rowsData = $("#datagrid").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	
	$.messager.confirm("������ʾ", "ȷ��Ҫɾ������", function (data) {  
            if (data) {  
                runClassMethod(
					"web.DHCADVFormName",
				    "remove",
					{
		 				'id':rowsData.ID
		 			},
		 			function(data){
			 			$("#datagrid").datagrid('reload'); 
					},"text");
            } 
    }); 
}
function formCat(){
	window.location.href="dhcadv.formcat.csp";
}

//���Ʊ�
function formCopy(){
	var rowsData = $("#datagrid").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	$("#copyCode").val("");
	$("#copyName").val("");
	$('#copy').dialog("open");

}

function saveFormCopy(){
	if($("#copyForm").form('validate')){
		var rowsData = $("#datagrid").datagrid('getSelected');
		runClassMethod(
		"web.DHCADVFormCopy",
		"copyForm",
		{
		 'id':rowsData.ID,
		 'code':$("#copyCode").val(),
		 'name':$("#copyName").val(),
		 'hospdr':hospComp.getValue()}, //cy 2021-06-15
		 function(data){
			 if(data==1){
				$.messager.alert("��ʾ","�����ظ�");
			 	return;
			 }
			 if(data==2){
				$.messager.alert("��ʾ","����ʧ��");
			 	return;
			 }
			 $.messager.alert("��ʾ","����ɹ�");
			 $('#copy').dialog("close");
			 $("#datagrid").datagrid('reload'); 
		},"text");
	}
}

function formExp()
{

  	var rowsData = $("#datagrid").datagrid('getSelected');
	if (rowsData == null) {
		$.messager.alert("��ʾ","��ѡ���!");
		return;	
	}
	/*$.messager.progress({   //���ݵ�����ʾ
		title:'���Ժ�', 
		msg:'�������ڵ�����...' 
	}); */
	
	/* var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var xlSheet = xlBook.ActiveSheet;"+
	"xlSheet.PageSetup.LeftMargin=0;"+  
	"xlSheet.PageSetup.RightMargin=0;"+
	"xlSheet.Application.Visible = true;";
	ret=serverCall("web.DHCADVFormExport","exportFormName",{id:rowsData.ID})
	retArr=ret.split(",");
	if(retArr[1]>0){
		pid=retArr[0];
		Str=Str+"xlSheet.cells(1,1).value='"+retArr[4]+"';";
		//xlSheet.Cells(1,1).Value=retArr[4];
		for (var k=1;k<=retArr[1];k++)
		{
			//xlSheet.Cells(k+1,1).Value=serverCall("web.DHCADVFormExport","exportForm",{pid:pid,count:k});
			Str=Str+"xlSheet.cells("+(k+1)+",1).value='"+serverCall("web.DHCADVFormExport","exportForm",{pid:pid,count:k})+"';";
		}
		Str=Str+"xlSheet.cells("+(parseInt(retArr[1])+2)+",1).value='dicstart'"+";";
		//xlSheet.Cells(parseInt(retArr[1])+2,1).Value="dicstart";
		for (var k=1;k<=retArr[2];k++)
		{
			//xlSheet.Cells(parseInt(k)+parseInt(retArr[1])+2,1).Value=serverCall("web.DHCADVFormExport","exportFormDic",{pid:pid,count:k});
			Str=Str+"xlSheet.cells("+(parseInt(k)+parseInt(retArr[1])+2)+",1).value='"+serverCall("web.DHCADVFormExport","exportFormDic",{pid:pid,count:k})+"';";
		
		}
		Str=Str+"xlSheet.cells("+(parseInt(retArr[1])+parseInt(retArr[2])+3)+",1).value='attrstart'"+";";
		//xlSheet.Cells(parseInt(retArr[1])+parseInt(retArr[2])+3,1).Value="attrstart";	
		for (var k=1;k<=retArr[3];k++)
		{
			//xlSheet.Cells(parseInt(k)+parseInt(retArr[1])+parseInt(retArr[2])+3,1).Value=serverCall("web.DHCADVFormExport","exportFormAttr",{pid:pid,count:k});
		
			Str=Str+"xlSheet.cells("+(parseInt(k)+parseInt(retArr[1])+parseInt(retArr[2])+3)+",1).value='"+serverCall("web.DHCADVFormExport","exportFormAttr",{pid:pid,count:k})+"';";
		
		}
	}
	//$.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
	Str=Str+"xlApp.Visible=true;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"xlSheet=null;"+
    "return 1;}());";
    
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;
	  */
	  
	  try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
        $.messager.alert('��ʾ','����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
        return;
	}
	$.messager.progress({   //���ݵ�����ʾ
		title:'���Ժ�', 
		msg:'�������ڵ�����...' 
	}); 
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	    

	ret=serverCall("web.DHCADVFormExport","exportFormName",{id:rowsData.ID});

	retArr=ret.split(",");
	if(retArr[1]>0){
		pid=retArr[0];
		xlSheet.Cells(1,1).Value=retArr[4];
		for (k=1;k<=retArr[1];k++)
		{
			xlSheet.Cells(k+1,1).Value=serverCall("web.DHCADVFormExport","exportForm",{pid:pid,count:k});
		
		}
		xlSheet.Cells(parseInt(retArr[1])+2,1).Value="dicstart";
		for (k=1;k<=retArr[2];k++)
		{
			xlSheet.Cells(parseInt(k)+parseInt(retArr[1])+2,1).Value=serverCall("web.DHCADVFormExport","exportFormDic",{pid:pid,count:k});
		}
		
		xlSheet.Cells(parseInt(retArr[1])+parseInt(retArr[2])+3,1).Value="attrstart";
		for (k=1;k<=retArr[3];k++)
		{
			xlSheet.Cells(parseInt(k)+parseInt(retArr[1])+parseInt(retArr[2])+3,1).Value=serverCall("web.DHCADVFormExport","exportFormAttr",{pid:pid,count:k});
		}
	}
 	
 	 $.messager.progress('close');//���ݵ�����ɹرռ��ؿ�
 	
 	  
	try
	{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
		if(fileName){
			 var ss = xlBook.SaveAs(fileName);  
		 	if (ss==false)
			{
				 $.messager.alert('��ʾ','����ʧ�ܣ�') ;
			}else{
				 $.messager.alert('��ʾ','�����ɹ���') ;
			}
		}else{
			$.messager.alert('��ʾ','����ȡ����') ;
		}
		
	}
	catch(e){
		  $.messager.alert('��ʾ','����ʧ�ܣ�') ;
	}


	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;

}


//����ļ��ϴ���·�� 
function clearFiles(){
      $('#filepath').filebox('clear');
}
function formImp(){
	
	var efilepath = $("input[name=filepath]").val();
    //alert(efilepath)
    if (efilepath.indexOf("fakepath") > 0) {$.messager.alert('��ʾ',"����IE��ִ�е���(�������������)��"); return; }
    if (efilepath.indexOf(".xls") <= 0) { $.messager.alert('��ʾ',"��ѡ��excel����ļ���"); return; }
    //var kbclassname = ""  //����
    var sheetcount = 1  //ģ���б�ĸ���
    var file = efilepath.split("\\");
    var filename = file[file.length - 1];
    if ((filename.indexOf(".xlsx")<0)&&(filename.indexOf(".xls")<0)) {
	    clearFiles ()
        $.messager.alert('��ʾ', '�ļ�ѡ��Ĳ���ȷ��');
        return;
    }

	try {
	        var oXL = new ActiveXObject("Excel.application");
	        var oWB = oXL.Workbooks.open(efilepath);   	
	}catch (e) {
	        $.messager.alert('����[internetѡ��]-[��ȫ]-[�����ε�վ��]-[վ��]����ӿ�ʼ���浽�����ε�վ�㣬Ȼ����[�Զ��弶��]�ж�[û�б��Ϊ��ȫ��ActiveX�ؼ����г�ʼ���ͽű�����]��һ������Ϊ����!');
	        return;
	}
    var errorRow = "";//û�в������
    var errorMsg = "";//������Ϣ
    oWB.worksheets(1).select();
    var oSheet = oWB.ActiveSheet;
    var rowcount = oXL.Worksheets(1).UsedRange.Cells.Rows.Count;
    var colcount = oXL.Worksheets(1).UsedRange.Cells.Columns.Count;
    
    $.messager.progress({title:'���Ժ�',msg:'�������ڵ�����...'}); 
    
    var errMsg="",dicFlag=0,errMsgnum=0;
    pid=serverCall("web.DHCADVFormExport","importPid");
    for (var j = 1; j <= rowcount; j++) {
        var cellValue = "";
        if (typeof (oSheet.Cells(j, 1).value) == "undefined") {
            cellValue = "";
        } else {
            cellValue = oSheet.Cells(j, 1).value;
        }
		if(cellValue!=""){
			if(cellValue=="dicstart"){
				dicFlag=1;
			}
			if(cellValue=="attrstart"){
				dicFlag=2;
			}
			ret=serverCall("web.DHCADVFormExport","importData",{pid:pid,row:j,data:cellValue,dicFlag:dicFlag})
			if(ret==1){
				errMsg=errMsg+j+"��,";
				errMsgnum=errMsgnum+1;
			}	
		}	
    }
    $.messager.progress('close');//���ݵ�����ɹرռ��ؿ�

    if(errMsg!=""){
	     $.messager.confirm("������ʾ", "��"+errMsgnum+"���ֵ�����ϵͳ�ظ�,���Ḳ��ϵͳ�ֵ�,ȷ�ϼ�����", function (data) {  
            if (data) {  
               saveData(pid);  
            } 
        }); 
	}else{
		saveData(pid);  	
	}
	
    clearFiles();
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

function saveData(pid){
	ret=serverCall("web.DHCADVFormExport","import",{pid:pid,"HospDr":HospDr}); 
    if(ret==0){
	    $.messager.alert("��ʾ","����ɹ�");
	}else if(ret==1){
	    $.messager.alert("��ʾ","�������Դ���,���޸ı������ٵ���!");
	}else{
		$.messager.alert("��ʾ","����ʧ��");
	}
}
