
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


//导出
function ExportData(DataArray){	
	//查询界面 
	var len = DataArray.length;
	if (len<1) return;
    //选定特定列到新数组，字段顺序与表头一致
	var newArr = [];
	for (var ind=0; ind<len;ind++) {
		var r = [];
		r.push(DataArray[ind]["BarCode"],DataArray[ind]["EvItemObjDesc"],DataArray[ind]["MonitorLocDesc"],DataArray[ind]["MonitorDate"],DataArray[ind]["SpecimenNum"],DataArray[ind]["ApplyUserDesc"]) ;       
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
        window.navigator.msSaveBlob(blob, '科室申请单.xls');
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = '科室申请单.xls';
        alink[0].click();
        alink.remove();
    }

}
   
function toHtml(newArr){
    var data = ['<table width="650" border="1" cellpadding="0" cellspacing="0" style="border-collapse:collapse;table-layout:fixed;">'];
  	var thStyle = "text-align:center;font-size:10.0pt;font-weight:700;"
	
	//表头
	data.push('<tr style="height:35px">');
	data.push('	<td style="'+thStyle+'" >序号</td>');
	data.push('	<td style="'+thStyle+'" >申请号</td>');
	data.push('	<td style="'+thStyle+'width:180px;'+'" >监测对象</td>');
	data.push('	<td style="'+thStyle+'" >监测科室</td>');
	data.push('	<td style="'+thStyle+'" >监测日期</td>');
	data.push('	<td style="'+thStyle+'" >标本数量</td>');
	data.push('	<td style="'+thStyle+'" >申请人</td>');
	data.push('</tr>');
	
    var trStyle = 'height:32px;';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
   
    //输出查询结果
    for(var i=0; i<newArr.length; i++){	    
        data.push('<tr style="'+trStyle+'">');
        data.push('<td style="'+tdStyle0+'">'+(i+1)+'</td>');  //序号列
		$.each(newArr[i],function(key,value) {
			if ((value)&&(!isNaN(value))) { //判断字符串是否为纯数字
				 data.push(
					'<td style="'+tdStyle0 +';mso-number-format:\@'+'">'+value+'</td>'
				);
			}else {
				data.push(
					'<td style="'+tdStyle0+'">'+value+'</td>'
				);
			}
        });
        data.push('</tr>');
    }
    data.push('</table>');
	
    return data.join('');
}
