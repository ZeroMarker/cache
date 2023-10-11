/// ��д��: ����
/// ��д����: 2020-09-27
/// ҳ���ʼ������
function initPageDefault()
{	
 $('#micrData').click(function(e)
  {
    micrDataImp();      /// ��������
  });
 $('#ShowData').click(function(e)
  {
    ShowData();      /// չʾ����
  });
		
}
function micrDataImp()
{	
    var efilepath = $("input[name=filepath]").val();
    //alert(efilepath.indexOf(".xls"))
    //if (efilepath.indexOf("fakepath") > 0) {alert("����IE��ִ�е��룡"); return; }
    if (efilepath.indexOf(".xls") <= 0) { alert("��ѡ��excel����ļ���"); return; }
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
    var errMsg="",dicFlag=0;
    var CellValStr=""
    var count=0
    for (var j = 2; j <= rowcount; j++)
     {
       var cellVals=""
       for(var i=1;i<=colcount;i++){
             var cellValue = ""
            if (typeof (oSheet.Cells(j, i).value) == "undefined") {
             cellValue = "" }
           else {
             cellValue = oSheet.Cells(j, i).value}
          if(cellVals=="")
              {
               cellVals=cellValue
              }
          else
            {
	   cellVals=cellVals+"^"+cellValue
             }
          }
      if(CellValStr=="")
          {
               CellValStr=cellVals
           }
        else
          {
	          count++
	          readData(count,cellVals)  //excel���ݴ洢
          }
     }
    detection()
    $.messager.progress('close')//���ݵ�����ɹرռ��ؿ�
    clearFiles ()
    oWB.Close(savechanges = false);
    CollectGarbage();
    oXL.Quit();
    oXL = null;
    oSheet = null;	
}

//����ļ��ϴ���·�� 
function clearFiles ()
{
   var file = $("#filepath");
   file.after(file.clone().val(""));      
   file.remove();   	
}


///���ݵ����洢
function readData(count,cellVals){
	serverCall("web.DHCCKBSuited","InsertByData",{"count":count,"cellVals":cellVals})
	}
	
	///����У��
function detection(){         
	serverCall("web.DHCCKBSuited","GetOrgMatchDiagExecute")
}

//�ȶ����ݽ��չʾ
function ShowData(){
   $("#tbgrid").show();
   var grid= $("#tbgrid").datagrid({
		    url:$URL+"?ClassName=web.DHCCKBSuited&QueryName=GetList",
		    queryParams:{ Id:"" },
		    width:750,
		    height:600,
		    columns:[[
		       {field:"Id",hidden:true},
		       {field:"hisDiag",width:250,title:"���"},
		       {field:"icdCode",width:250,title:"Code"},
		       {field:"icdDiag",width:250,title:"ƥ��"}
		    ]],
		    fitColumns:true,
		    singleSelect:true,//��ѡ,��ѡ�л�
		    rownumbers:true,//�к�
		    pagination:true,//��ҳ������
		    pageSize:20,
		    pageList:[20,40,60]
	    });
}



/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })