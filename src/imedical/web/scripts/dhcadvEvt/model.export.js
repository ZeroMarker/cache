function  getExplorer() {
    var explorer = navigator.userAgent.toLowerCase() ;
    //ie
    if (explorer.indexOf("trident")>=0) {
        return 'ie';
    }
    //firefox
    else if (explorer.indexOf("firefox") >= 0) {
        return 'Firefox';
    }
    //Chrome
    else if(explorer.indexOf("chrome") >= 0){
        return 'Chrome';
    }
    //Opera
    else if(explorer.indexOf("opera") >= 0){
        return 'Opera';
    }
    //Safari
    else if(explorer.indexOf("safari") >= 0){
        return 'Safari';
    }
}
function exportExcel(JSONData, filename,title,filter) {//������񿽱���EXCEL��
	
	if(filename==undefined){
		filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
	}
    if(getExplorer()=='ie') {
        try {
            var curTb= document.getElementById("exportTableData");
            if(!JSONData)
                return;
            //ת��jsonΪobject
            var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
            curTb.innerHTML = createTable(arrData, title, filter);//����table��html �ַ���
           
            var curTbl = document.getElementById("table");
            var oXL = new ActiveXObject("Excel.Application");

            //����AX����excel
            var oWB = oXL.Workbooks.Add();
            var oSheet = oWB.ActiveSheet;
            //��ȡworkbook����
            var xlsheet = oWB.Worksheets(1);
            //���ǰsheet
            var sel = document.body.createTextRange();
			oXL.Columns('A:Z').NumberFormatLocal = '@';
            sel.moveToElementText(curTbl);
            //�ѱ���е������Ƶ�TextRange��
            sel.select;
            //ȫѡTextRange������
            sel.execCommand("Copy");
            //����TextRange������
            xlsheet.Paste();
            //ճ�������EXCEL��
            oXL.Visible = true;
            //����excel�ɼ�����
            var fname = oXL.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
        } catch (e) {
            alert("�޷�����Excel!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��δ���Ϊ��ȫִ�нű���ActiveX�ؼ���ʼ����ִ�нű� �� ����");
            return false;
        } finally {
            oWB.SaveAs(fname);

            oWB.Close(savechanges = false);
            //xls.visible = false;
            oXL.Quit();
            oXL = null;
            //����excel���̣��˳����
            //window.setInterval("Cleanup();",1);
            idTmr = window.setInterval("Cleanup();", 1);
        }
    } else {
        tableToExcel(JSONData, filename,title,filter)
    }
}
function Cleanup() {
    window.clearInterval(idTmr);
    CollectGarbage();
}
var tableToExcel =function JSONToExcelConvertor(JSONData, FileName,title,filter) {
	
    if(!JSONData)
        return;
    //ת��jsonΪobject
    var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
 
    var excel = createTable(arrData, title, filter);//����table��html �ַ���
    
    var excelFile = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'>";
    excelFile += '<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
    excelFile += '<meta http-equiv="content-type" content="application/vnd.ms-excel';
    excelFile += '; charset=UTF-8">';
    excelFile += "<head>";
    excelFile += "<!--[if gte mso 9]>";
    excelFile += "<xml>";
    excelFile += "<x:ExcelWorkbook>";
    excelFile += "<x:ExcelWorksheets>";
    excelFile += "<x:ExcelWorksheet>";
    excelFile += "<x:Name>";
    excelFile += "{worksheet}";
    excelFile += "</x:Name>";
    excelFile += "<x:WorksheetOptions>";
    excelFile += "<x:DisplayGridlines/>";
    excelFile += "</x:WorksheetOptions>";
    excelFile += "</x:ExcelWorksheet>";
    excelFile += "</x:ExcelWorksheets>";
    excelFile += "</x:ExcelWorkbook>";
    excelFile += "</xml>";
    excelFile += "<![endif]-->";
    excelFile += "</head>";
    excelFile += "<body>";
    excelFile += excel;
    excelFile += "</body>";
    excelFile += "</html>";

	console.log(excelFile)
    var uri = 'data:application/vnd.ms-excel;charset=utf-8,' + encodeURIComponent(excelFile);

    var link = document.createElement("a");
    link.href = uri;

    link.style = "visibility:hidden";
    link.download = FileName + ".xls";

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}


function createTable(arrData,title,filter) {
	
    var excel = '<table border="1" cellspacing="1" cellpadding="1"  id="table" style="vnd.ms-excel.numberformat:@">';
   
    //���ñ�ͷ
    var row=$(".dhc-table").find("thead").html();
    if(row.indexOf("<th")){
	    row=row.replace(/<th/g,"<th style='mso-number-format: \"\@\"; '");
	}
    /**
    var row = "<tr>";
    if(title)
    {
	    var titleArr=title.split("^");
	    for(var i=0;i<titleArr.length;i++){
		    if (titleArr[i].length>=4){
                row += "<th align='center'  width='100px'>" + titleArr[i] + '</th>';
            }else{
                row += "<th align='center'>" + titleArr[i] + '</th>';
            }
		}
    }
    else{
        //��ʹ�ñ�����
        for (var i in arrData[0]) {
            row += "<th align='center'>" + i + '</th>';
        }
    }
    excel += row + "</tr>";
    */
    excel += row
    //��������
    for (var i = 0; i < arrData.length; i++) {
        var row = "<tr >";
        var rowArr=arrData[i].value.split("^");
        
        for (var index=0;index<rowArr.length;index++) {

                var value = rowArr[index] == null ? "" : rowArr[index];
                row += "<td align='center'  style='mso-number-format: \"\@\"; '    >" +value +"</td>";
            
        }
        excel += row + "</tr>";
    }

    excel += "</table>";
	console.log(excel+"ok")
    return  excel;
}
