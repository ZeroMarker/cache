var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		if (encmeth!=""){
			var TempFileds=encmeth.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}
//����
function ExportDataToExcel(strMethodGetServer,strMethodGetData,strFileName,strArguments)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.Service",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.RepList.xls";
	
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch(e) {
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ���𡣾��������"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.DTHService.ReportSrv","QryReportInfoToPrint","fillxlSheet",strArguments);
	var fname = xls.Application.GetSaveAsFilename(strFileName,"Excel Spreadsheets (*.xls), *.xls");
	//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
	//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
	try {
		xlBook.SaveAs(fname);
	}catch(e){
		//alert(e.message);
		return false;
	}
	
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}
//�������濨��ϸ���� add by niepeng 2013-12-18
function ExportDataToExcelNP(strMethodGetServer,strMethodGetData,strFileName,strArguments)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.Service",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMed.DTH.ReportListNP.xls";
	
	try {
		xls = new ActiveXObject("Excel.Application");
	}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ���𡣾��������"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.DTHService.ReportInterface","QryReportInfoToPrintNP","fillxlSheet",strArguments);
	var fname = xls.Application.GetSaveAsFilename(strFileName,"Excel Spreadsheets (*.xls), *.xls");
	//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
	//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
	try {
		xlBook.SaveAs(fname);
	}catch(e){
		//alert(e.message);
		return false;
	}
	
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);
	return true;
}

function b64toBlob(data){
    var sliceSize = 512;
    var chars = atob(data);
    var byteArrays = [];
    for(var offset=0; offset<chars.length; offset+=sliceSize){
        var slice = chars.slice(offset, offset+sliceSize);
        var byteNumbers = new Array(slice.length);
        for(var i=0; i<slice.length; i++){
            byteNumbers[i] = slice.charCodeAt(i);
        }
        var byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
    }
    return new Blob(byteArrays, {
        type: ''
    });
}


function toHtml(newArr){
    var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
  	//����
	data.push('<tr><td colspan="11" style="height:40pt;text-align:center;font-size:24px;font-weight:bold;">������������ֱ���յǼ�</td></tr>');
    var trStyle = 'height:32px';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
    data.push('<tr style="'+trStyle+'">');
    //��ͷ
    data.push('<th style="width:200px">����</th>');
    data.push('<th style="width:180px">����״̬</th>');
    data.push('<th style="width:180px">��������</th>');
    data.push('<th style="width:100px">�Ա�</th>');
    data.push('<th style="width:100px">����</th>');
    data.push('<th style="width:200px">ְҵ</th>');
    data.push('<th style="width:400px;">��������</th>');
    data.push('<th style="width:400px;">���ڵ�ַ</th>');
    data.push('<th style="width:100px">��������</th>');
    data.push('<th style="width:100px">�����</th>');
    data.push('<th style="width:150px">�����</th>');
    //�����ѯ���
    for(var i=0; i<newArr.length; i++){	    
        data.push('<tr style="'+trStyle+'">');
        for(var j=0; j<newArr[i].length; j++){
			var value = newArr[i][j];
            data.push(
                '<td style="'+tdStyle0+'">'+value+'</td>'
            );
        }
        data.push('</tr>');
    }
    data.push('</table>');
	
    return data.join('');
}

//����
function ExportToExcel(){	
	//��ѯ����
    var strDTHList =$m({
		ClassName:"DHCMed.DTHService.ReportSrv",
		QueryName:"QryReportInfo",	
		ResultSetType:'array',	
		aSttDate: $('#txtStartDate').datebox('getValue'), 
		aEndDate: $('#txtEndDate').datebox('getValue'), 
		aRepLoc: $('#cboRepLoc').combobox('getValue'), 
		aHospital:$('#cboSSHosp').combobox('getValue'),   
		aRepStatus: $('#cboRepStatus').combobox('getValue'),
		aPatName: $('#txtPatName').val(),
		aMrNo: $('#txtMrNo').val(),	
		aRegNo: $('#txtRegNo').val()
	}, false);
	var DTHArray = JSON.parse(strDTHList);
	var DTHlen = DTHArray.length;
	if (DTHlen<1) return;
    //ѡ���ض��е������飬�ֶ�˳�����ͷһ��
	var newArr = [];
	for (var ind=0; ind<DTHlen;ind++) {
		var r = [];
		r.push(DTHArray[ind]["DeathNo"],DTHArray[ind]["RepStatusDesc"],DTHArray[ind]["PatName"],DTHArray[ind]["Sex"],DTHArray[ind]["Age"],DTHArray[ind]["Occupation"],DTHArray[ind]["BaseReason"],DTHArray[ind]["CurrAddress"],DTHArray[ind]["DeathDate"],DTHArray[ind]["RepDate"],DTHArray[ind]["RepLoc"])        
		newArr.push(r);
    }
    		    
    var table = toHtml(newArr);
    var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }

    var ctx = { worksheet: 'Worksheet', table: table };
    var data = base64(format(template, ctx));

    if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, '��������Ǽ�.xls');
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = '��������Ǽ�.xls';
        alink[0].click();
        alink.remove();
    }

}
   
//��ϸ
function toDtlHtml(newArr){
    var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
  	//����
    var trStyle = 'height:32px';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
    data.push('<tr style="'+trStyle+'">');
    //��ͷ
   	data.push('<th>���濨ID</th>');
	data.push('<th>�����������</th>');
	data.push('<th>���濨���</th>');
	data.push('<th>��Ⱥ�������</th>');
	data.push('<th>��Ⱥ����</th>');
	data.push('<th>��������</th>');
	data.push('<th>�Ա����</th>');
	data.push('<th>�Ա�</th>');
	data.push('<th>���֤����</th>');
	data.push('<th>��������</th>');
	data.push('<th>����</th>');
	data.push('<th>�������</th>');
	data.push('<th>����</th>');
	data.push('<th>����״������</th>');
	data.push('<th>����״��</th>');
	data.push('<th>��Ҫְҵ�����ֱ���</th>');
	data.push('<th>��Ҫְҵ������</th>');
	data.push('<th>�Ļ��̶ȱ���</th>');
	data.push('<th>�Ļ��̶�</th>');
	data.push('<th>��ǰ��ס��ַ����</th>');
	data.push('<th>��ǰ��ϸ��ַ</th>');
	data.push('<th>��ס��ַ��������</th>');
	data.push('<th>������ַ����</th>');
	data.push('<th>������ַ</th>');
	data.push('<th>������ַ����</th>');
	data.push('<th>��ǰ������λ</th>');
	data.push('<th>����ʱ��</th>');
	data.push('<th>�����ص����</th>');
	data.push('<th>�����ص�</th>');
	data.push('<th>��������</th>');
	data.push('<th>������ϵ�绰</th>');
	data.push('<th>����סַ������λ</th>');
	data.push('<th>aֱ�ӵ��������ļ���</th>');
	data.push('<th>aֱ�ӵ��������ļ���ICD10����</th>');
	data.push('<th>a������������ʱ����</th>');
	data.push('<th>a������������ʱ������λ</th>');
	data.push('<th>bֱ�ӵ��������ļ���</th>');
	data.push('<th>bֱ�ӵ��������ļ���ICD10����</th>');
	data.push('<th>b������������ʱ����</th>');
	data.push('<th>b������������ʱ������λ</th>');
	data.push('<th>cֱ�ӵ��������ļ���</th>');
	data.push('<th>cֱ�ӵ��������ļ���ICD10����</th>');
	data.push('<th>c������������ʱ����</th>');
	data.push('<th>c������������ʱ������λ</th>');
	data.push('<th>dֱ�ӵ��������ļ���</th>');
	data.push('<th>dֱ�ӵ��������ļ���ICD10����</th>');
	data.push('<th>d������������ʱ����</th>');
	data.push('<th>d������������ʱ������λ</th>');
	data.push('<th>�����������</th>');
	data.push('<th>�����������ICD10����</th>');
	data.push('<th>��������ԭ��</th>');
	data.push('<th>��������ICD����</th>');
	data.push('<th>�����ϵ�λ����</th>');
	data.push('<th>�����ϵ�λ</th>');
	data.push('<th>���������ݱ���</th>');
	data.push('<th>����������</th>');
	data.push('<th>�ϱ�ҽ��</th>');
	data.push('<th>סԺ��</th>');
	data.push('<th>ҽ���ϱ�����</th>');
	data.push('<th>���λ����</th>');
	data.push('<th>���λ����</th>');
	data.push('<th>��λ���ͱ���</th>');
	data.push('<th>��λ��������</th>');
	data.push('<th>��ע</th>');
	data.push('<th>������ǰ��ʷ��֢״����</th>');
	data.push('<th>������������</th>');
	data.push('<th>�����߹�ϵ</th>');
	data.push('<th>��ϵ��ַ������λ</th>');
	data.push('<th>�������ߵ绰����</th>');
	data.push('<th>�����ƶ�</th>');
	data.push('<th>������ǩ��</th>');
	data.push('<th>��������</th>');
	data.push('<th>ɾ��ʱ��</th>');
	data.push('<th>¼��ʱ��</th>');
	data.push('<th>¼����ID</th>');
	data.push('<th>��˱�־</th>');
	data.push('<th>���ʱ��</th>');
	data.push('<th>��Ƭ״̬����</th>');
	data.push('<th>��Ƭ״̬</th>');
	data.push('<th>��Ƭ��Դ</th>');
   
    //�����ѯ���
    for(var i=0; i<newArr.length; i++){	    
        data.push('<tr style="'+trStyle+'">');
		$.each(newArr[i],function(key,value) {
			if ((value)&&(!isNaN(value))) { //�ж��ַ����Ƿ�Ϊ������
				 tdStyle0 = tdStyle0 +';mso-number-format:\@';  //����������е���û��0���ɿ�ѧstyle="mso-number-format:'\@';"   
			}
            data.push(
                '<td style="'+tdStyle0+'">'+value+'</td>'
            );
        });
        data.push('</tr>');
    }
    data.push('</table>');
	
    return data.join('');
}

//������ϸ
function ExportDtlToExcel(){	
	//��ѯ����
    var strDTHList =$m({
		ClassName:"DHCMed.DTHService.ReportInterface",
		QueryName:"QryReportInfo",	
		ResultSetType:'array',	
		aSttDate: $('#txtStartDate').datebox('getValue'), 
		aEndDate: $('#txtEndDate').datebox('getValue'), 
		aRepLoc: $('#cboRepLoc').combobox('getValue'), 
		aHospital:$('#cboSSHosp').combobox('getValue'),   
		aRepStatus: $('#cboRepStatus').combobox('getValue'),
		aPatName: $('#txtPatName').val(),
		aMrNo: $('#txtMrNo').val(),	
		aRegNo: $('#txtRegNo').val()
	}, false);
	var DTHArray = JSON.parse(strDTHList);
	var DTHlen = DTHArray.length;
	if (DTHlen<1) return;
			    
    var table = toDtlHtml(DTHArray);
    var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }

    var ctx = { worksheet: 'Worksheet', table: table };
    var data = base64(format(template, ctx));

    if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, '����������ϸ��.xls');
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = '����������ϸ��.xls';
        alink[0].click();
        alink.remove();
    }
    
}


function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//����Ԫ��
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//��Ԫ��ϲ�
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//��Ԫ�����
//-4130 �����
//-4131 �Ҷ���
//-4108 ���ж���
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}
