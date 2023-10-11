
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
function ExportNICUData(aDate,aLocID,aType){	
	//查询界面
    var strDataList =$m({
		ClassName:"DHCHAI.IRS.ICULogSrv",
		QueryName:"QryNAISByMonth",	
		ResultSetType:'array',	
		aYYMM: aDate,
        aLocDr: aLocID
	}, false);
	debugger
	var DataArray = JSON.parse(strDataList);
	var len = DataArray.length;
	if (len<1) return;
    //选定特定列到新数组，字段顺序与表头一致
	var newArr = [];
	
    if (aType==1) {
		for (var ind=0; ind<len;ind++) {
			var r = [];
			r.push(DataArray[ind]["SurveryDay"],DataArray[ind]["AISItem1"],DataArray[ind]["AISItem2"],DataArray[ind]["AISItem3"],DataArray[ind]["AISItem4"],DataArray[ind]["AISItem5"],DataArray[ind]["AISItem6"],DataArray[ind]["AISItem7"],DataArray[ind]["AISItem8"],DataArray[ind]["AISItem9"],DataArray[ind]["AISItem10"],DataArray[ind]["AISItem11"],DataArray[ind]["AISItem12"],DataArray[ind]["AISItem13"],DataArray[ind]["AISItem14"],DataArray[ind]["AISItem15"],DataArray[ind]["AISItem16"],DataArray[ind]["AISItem17"],DataArray[ind]["AISItem18"],DataArray[ind]["AISItem19"],DataArray[ind]["AISItem20"]) ;       
			newArr.push(r);
		}	    
    	var table = toWeightHtml(newArr);
    }else {
		for (var ind=0; ind<len;ind++) {
		var r = [];
		r.push(DataArray[ind]["SurveryDay"],DataArray[ind]["AISItem1"],DataArray[ind]["AISItem2"],DataArray[ind]["AISItem3"],DataArray[ind]["AISItem4"],DataArray[ind]["AISItem5"],DataArray[ind]["AISItem6"],DataArray[ind]["AISItem7"],DataArray[ind]["AISItem8"],DataArray[ind]["AISItem9"],DataArray[ind]["AISItem10"],DataArray[ind]["AISItem11"],DataArray[ind]["AISItem12"],DataArray[ind]["AISItem13"],DataArray[ind]["AISItem14"],DataArray[ind]["AISItem15"],DataArray[ind]["AISItem16"]);       
		newArr.push(r);
    }
	    var table = toApgerHtml(newArr);
    }
    var uri = 'data:application/vnd.ms-excel;base64,'
    , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
    , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
    , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }

    var ctx = { worksheet: 'Worksheet', table: table };
    var data = base64(format(template, ctx));

    if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, 'NICU患者日志.xls');
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = 'NICU患者日志.xls';
        alink[0].click();
        alink.remove();
    }

}
   
//体重
function toWeightHtml(newArr){
    var data = ['<table width="1370" border="1" cellpadding="0" cellspacing="0" style="width:825pt;border-collapse:collapse;table-layout:fixed;">'];
  	var thStyle = "text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;"
	
	//表头
	data.push('<tr height="35" style="height:21.00pt;">');
	data.push('	<td height="120" width="100" rowspan="2" style="height:70pt;width:60pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">日期</td>');
	data.push('	<td width="316" colspan="4" style="width:120pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">BW≤1000g</td>');
	data.push('	<td width="316" colspan="4" style="width:120pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">BW 1001g~1500g</td>');
	data.push('	<td width="316" colspan="4" style="width:120pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">BW 1501g~2500g</td>');
	data.push('	<td width="316" colspan="4" style="width:120pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">BW>2500g</td>');
	data.push('	<td width="316" colspan="4" style="width:120pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">BW 未填写</td>');
	data.push('</tr>');
	
	data.push('<tr height="85" style="height:80pt;">');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('</tr>');
	
    var trStyle = 'height:32px';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
   
    //输出查询结果
    for(var i=0; i<newArr.length; i++){	    
        data.push('<tr style="'+trStyle+'">');
		$.each(newArr[i],function(key,value) {
			if ((value)&&(!isNaN(value))) { //判断字符串是否为纯数字
				 tdStyle0 = tdStyle0 +';mso-number-format:\@';  //解决纯数字列导出没有0或变成科学style="mso-number-format:'\@';"   
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

//Apger
function toApgerHtml(newArr){
    var data = ['<table width="1370" border="1" cellpadding="0" cellspacing="0" style="width:825pt;border-collapse:collapse;table-layout:fixed;">'];
  	var thStyle = "text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;"
	
	//表头
	data.push('<tr height="35" style="height:21.00pt;">');
	data.push('	<td height="120" width="110" rowspan="2" style="height:70pt;width:60pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">日期</td>');
	data.push('	<td width="316" colspan="4" style="width:140pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">正常（8-10分）</td>');
	data.push('	<td width="316" colspan="4" style="width:140pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">轻度窒息（4-7分）</td>');
	data.push('	<td width="316" colspan="4" style="width:140pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">重度窒息（0-3分）</td>');
	data.push('	<td width="316" colspan="4" style="width:140pt;text-align:center;white-space:normal;font-size:10.0pt;font-weight:700;">Apgar评分未填写</td>');
	data.push('</tr>');
	
	data.push('<tr height="85" style="height:80pt;">');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('	<td style="'+thStyle+'" >入科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >在科新生儿数</td>');
	data.push('	<td style="'+thStyle+'" >脐/中心静脉插管数</td>');
	data.push('	<td style="'+thStyle+'" >使用呼吸机数</td>');
	data.push('</tr>');
	
    var trStyle = 'height:32px';
    var tdStyle0 = 'vertical-align:middle;text-align:center;padding:0 4px;';
  
    //输出查询结果
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