
/*
 * FileName:	dhcinsu.insuservqrycom.js
 * User:		DingSH
 * Date:		2021-01-08
 * Description: 医保常用服务查询通用函数
 */
 var GV = {
	UPDATEDATAID : '',
	HOSPDR:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : '',
	INSUTYPE: '',     //医保类型
	INSUTYPEDESC: '',     //医保类型
	PSNNO:'',         //人员编号
	INSUPLCADMDVS:'', //参保统筹区,
	MDTRTID:'' ,      //医保就诊流水号
	SETLID:''         //医保结算流水号
}

/*
* 将查询入参按照格式拼接
* DingSH 2021-01-11
* input: QryArgs,name,value
* output: name1=value1&name2=value2&...&namen=valuen
* --------------------end	
*/
function AddQryParam(QryArgs,name,value){
	return QryArgs+="&"+name+"="+value;
}
/*
 * 加载查询数据
 * data:[{},{}]格式
 */
function loadQryGrid(dgName,data){
	$('#'+dgName).datagrid({data:data,loadMsg:'数据加载中...',loadFilter: pagerFilter });
	/* 
	*这种方式也可以
	var data={total:RowsData.length,rows:RowsData}
	$('#'+dgName).datagrid({loadFilter: pagerFilter }).datagrid("loadData",data); 
	*/
}
/*
 * 根据字典类型和字典代码取描述
 */
function GetDicDescByCode(DicType,Code){
	var desc="";
	var tCode=Code || "";
	desc = tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",DicType,tCode,4,GV.HOSPDR);
	return desc !="" ? desc:Code;
	
}
// 分页数据的操作  
 function pagerFilter(data) {  
        if (typeof data.length == 'number' && typeof data.splice == 'function') {   // is array  
            data = {  
                total: data.length,  
                rows: data  
            }  
        }  
        var dg = $(this);  
        var opts = dg.datagrid('options');  
        var pager = dg.datagrid('getPager');  
        pager.pagination({  
            onSelectPage: function (pageNum, pageSize) {  
                opts.pageNumber = pageNum;  
                opts.pageSize = pageSize;  
                pager.pagination('refresh', {  
                    pageNumber: pageNum,  
                    pageSize: pageSize  
                });  
                dg.datagrid('loadData', data);  
            }  
        });  
        if (!data.originalRows) {  
            data.originalRows = (data.rows);  
        }  
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);  
        var end = start + parseInt(opts.pageSize);  
        data.rows = (data.originalRows.slice(start, end));  
        return data;  
    }  



/*
*JSON数据导出excel
*/
function JSONToExcelConvertor(JSONData, FileName,title,filter) {  
    if(!JSONData)
        return;
    //转化json为object
    var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;  
    //alert(1111)
    var excel = "<table>";      
    //设置表头  
    var row = "<tr>";  
    if(title)
    {
        //使用标题项
        for (var i in title) {  
            row += "<th align='center'>" + title[i] + '</th>';
        }  

    }
    else{
        //不使用标题项
        for (var i in arrData[0]) {  
            row += "<th align='center'>" + i + '</th>';
        } 
     }

        excel += row + "</tr>";  

    //设置数据  
    for (var i = 0; i < arrData.length; i++) {  
        var row = "<tr>";  

        for (var index in arrData[i]) {
            //判断是否有过滤行
            if(filter)
            {
                if(filter.indexOf(index)==-1)
                {
                     var value = arrData[i][index] == null ? "" : arrData[i][index];  
                     row += '<td>' + value + '</td>'; 
                } 
            }
            else
            {
                 var value = arrData[i][index] == null ? "" : arrData[i][index];  
                 row += "<td align='center'>" + value + "</td>"; 
            }    
        }  

        excel += row + "</tr>";  
            }  

            excel += "</table>";  

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
    alert(excelFile);
    var uri = 'data:application/vnd.ms-excel;charset=utf-8,' + encodeURIComponent(excelFile);  

    var link = document.createElement("a");      
    link.href = uri;  
    alert("1112-0")
    link.style = "visibility:hidden";  
    alert("FileName="+FileName);
    link.download = FileName + ".xls";  
     alert("1112-1")
    document.body.appendChild(link);  
    link.click();  
    document.body.removeChild(link);  
     alert(1113)
} 

 function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel) {
    //If JSONData is not an object then JSON.parse will parse the JSON string in an Object
    var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
    
    var CSV = '';    
    //Set Report title in first row or line
    
    CSV += ReportTitle + '\r\n\n';

    //This condition will generate the Label/Header
    if (ShowLabel) {
        var row = "";
        
        //This loop will extract the label from 1st index of on array
        for (var index in arrData[0]) {
            
            //Now convert each value to string and comma-seprated
            row += index + ',';
        }

        row = row.slice(0, -1);
        
        //append Label row with line break
        CSV += row + '\r\n';
    }
    
    //1st loop is to extract each row
    for (var i = 0; i < arrData.length; i++) {
        var row = "";
        
        //2nd loop will extract each column and convert it in string comma-seprated
        for (var index in arrData[i]) {
            row += '"' + arrData[i][index] + '",';
        }

        row.slice(0, row.length - 1);
        
        //add a line break after each row
        CSV += row + '\r\n';
    }

    if (CSV == '') {        
        alert("Invalid data");
        return;
    }   
    
    //Generate a file name
    var fileName = "MyReport_";
    //this will remove the blank-spaces from the title and replace it with an underscore
    fileName += ReportTitle.replace(/ /g,"_");   
    
    //Initialize file format you want csv or xls
	CSV =  encodeURIComponent(CSV);  
    var uri = 'data:text/csv;charset=utf-8,\ufeff' + CSV;
    
    // Now the little tricky part.
    // you can use either>> window.open(uri);
    // but this will not work in some browsers
    // or you will not get the correct file extension    
    
    //this trick will generate a temp <a /> tag
    var link = document.createElement("a");    
    link.href = uri;
    
    //set the visibility hidden so it will not effect on your web-layout
    link.style = "visibility:hidden";
    link.download = fileName + ".csv";
   // alert(row)
    //this part will append the anchor tag and remove it after automatic click
    document.body.appendChild(link);
    //alert("rrr")
    link.click();
    //alert("test")
    document.body.removeChild(link);
}

