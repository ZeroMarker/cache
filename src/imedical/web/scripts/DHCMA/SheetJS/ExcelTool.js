var isIE = window.ActiveXObject || "ActiveXObject" in window; //IE浏览器

//转二进制
function fixdata(data) {
    var o = "",
        l = 0,
        w = 10240;
    for(; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
    o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
    return o;
}

//读取文件，获取工作簿，返回workbook对象
function getWorkBook(file,callback){
	var reader = new FileReader();
    reader.onload = function(e) {
        var data = e.target.result;
        //console.log(data)
        if(data.indexOf("<Author>DHCMA.CPW</Author>")>0){
        	data=decodeURIComponent(escape(data))
        }
        var wb="";
        if(isIE) {
            wb = XLSX.read(btoa(fixdata(data)),{
                type: 'base64'
            });
        } else {
            wb = XLSX.read(data,{
                type: 'binary'
            });
        }
        return callback(wb,file.name)
    };
    if(isIE) {
        reader.readAsArrayBuffer(file);
    } else {
        reader.readAsBinaryString(file);
    }
}

function htmlEncodeByRegExp(str){
	var temp = "";
	if(str.length == 0) return "";
	temp = str.replace(/&/g,"&amp;");
	temp = temp.replace(/</g,"&lt;");
	temp = temp.replace(/>/g,"&gt;");
	temp = temp.replace(/\s/g,"&nbsp;");
	temp = temp.replace(/\'/g,"&#39;");
	temp = temp.replace(/\"/g,"&quot;");
    return temp;
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
        type: 'application/vnd.ms-excel'
    });
}

function ExportForm(FormID,FormName){
	
	var CPWInfo=$m({ClassName:"DHCMA.CPW.BTS.ExportPathWay",MethodName:"GetCPWInfo",aFormID:FormID},false); 
	var arrCPWInfo=eval('['+CPWInfo+']')
	
	var FormInfo=$m({ClassName:"DHCMA.CPW.BTS.ExportPathWay",MethodName:"GetFormInfo",aFormID:FormID},false); 
	var arrFormInfo=eval('['+FormInfo+']')
			
	var uri = 'data:application/vnd.ms-excel;base64,'
	var base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }

    var ctx = "";
    var workbookXML = "";
    var worksheetsXML = "";
    var rowsXML = "";
    
    for(var i=0;i<arrCPWInfo.length;i++){
    	var row=arrCPWInfo[i];
    	rowsXML += '<Row>';
    	rowsXML += '<Cell><Data ss:Type="String">'+row[0]+'</Data></Cell>';
    	rowsXML += '<Cell><Data ss:Type="String">'+htmlEncodeByRegExp(row[1])+'</Data></Cell>';
    	rowsXML += '</Row>'
    }
    worksheetsXML += '<Worksheet ss:Name="路径"><Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="10" x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.4">'
			+'<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="84.6"/>'
			+'<Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="279"/>'
			+rowsXML+'</Table></Worksheet>'
    
    
    var arrRowHight=[24,24,100,220,150]
    rowsXML = "";
    for(var i=0;i<arrFormInfo.length;i++){
    	var row=arrFormInfo[i];
    	//rowsXML += '<Column ss:Index="'+(i+1)+'" ss:AutoFitWidth="1" ss:Width="100"/>';
    	rowsXML += '<Row ss:Height="'+arrRowHight[i]+'">';
    	
    	for(var j=0;j<row.length;j++){
    		rowsXML += '<Cell ss:StyleID="s60"><Data ss:Type="String">'+row[j]+'</Data></Cell>';
    	}
    	rowsXML += '</Row>'
    }
    worksheetsXML += '<Worksheet ss:Name="表单"><Table>'
			+rowsXML+'</Table></Worksheet>'
    
    workbookXML='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">'
	        + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>DHCMA.CPW</Author><Created>'+(new Date()).getTime()+'</Created></DocumentProperties>'
	        + '<Styles>'
	        + '<Style ss:ID="s60"><Alignment ss:Vertical="Top" ss:WrapText="1"/><Borders><Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/><Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/><Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/></Borders><Font ss:FontName="宋体" x:CharSet="134" ss:Size="10"/><NumberFormat/></Style>' 
	        + '</Styles>'
	        + worksheetsXML+'</Workbook>'
	
	var data=base64(workbookXML);
	var filename=FormName+ '.xls';
	if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, filename);
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = filename;
        alink[0].click();
        alink.remove();
    }
}