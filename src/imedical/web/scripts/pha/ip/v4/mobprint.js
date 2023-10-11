/**
 * 名称:	 住院药房 - 移动药房相关打印
 * 编写人:	 yunhaibao
 * 编写日期: 2020-08-13
 */
 var PHA_IP_MOBPRINT = {
    // 封箱贴
    Box: function (boxArr, rePrintFlag) {
	    rePrintFlag = rePrintFlag || '';
	    var boxArrStr = boxArr;
	    if (typeof boxArrStr === 'object'){
			 boxArrStr = JSON.stringify(boxArrStr);
		}
        var prtData = tkMakeServerCall('PHA.IP.Print.Box', 'GetJsonData', boxArrStr);
        var prtArr = JSON.parse(prtData);
        for (var i = 0; i < prtArr.length; i++) {
            var prtJson = prtArr[i];
            var newPrtJson = {
	        	Para:prtJson,
	        	List:[]
	        }
	        newPrtJson.Para.toLoc = newPrtJson.Para.toLoc + (rePrintFlag !== '' ? '(补)' : '')
	         PRINTCOM.XML({
	             printBy: 'lodop', // inv or lodop, default is lodop
	             XMLTemplate: 'PHAIPBOX',
	             data: newPrtJson,
	             preview: false
	         });
	         
//            var xmlPrtObj = DHCSTXMLPrint_JsonToXml(newPrtJson);
//            DHCSTGetXMLConfig('PHAIPBOX');          
//            DHCSTPrintFun(xmlPrtObj.xmlPara, xmlPrtObj.xmlList);
        }
    },
    // 固化单
    Connect: function (noArr, rePrintFlag) {
	    rePrintFlag = rePrintFlag || '';
	    var noArrStr = noArr;
	    if (typeof noArrStr === 'object'){
			 noArrStr = JSON.stringify(noArrStr);
		}
        var prtData = tkMakeServerCall('PHA.IP.Print.Connect', 'GetJsonData', noArrStr);
        var prtArr = JSON.parse(prtData);
        for (var i = 0; i < prtArr.length; i++) {
            var prtJson = prtArr[i];
            var newPrtJson = {
	        	Para:prtJson,
	        	List:[]
	        }
            var xmlPrtObj = DHCSTXMLPrint_JsonToXml(newPrtJson);
            DHCSTGetXMLConfig('PHAIPCONNECT');          
            DHCSTPrintFun(xmlPrtObj.xmlPara, xmlPrtObj.xmlList);
        }
    },  
    // 备药单 
    // 备药单
    Draw: function (drawArr, rePrint) {  
	    rePrint = rePrint || '';
	    var PIVASLODOP = getLodop();
	    var drawArrStr = drawArr;
	    if (typeof drawArrStr === 'object'){
			 drawArrStr = JSON.stringify(drawArrStr);
		}	    
		var prtData = tkMakeServerCall('PHA.IP.Print.Draw', 'GetJsonData', drawArrStr);
	    var prtArr = JSON.parse(prtData);
        for (var i = 0; i < prtArr.length; i++) {
            var prtJson = prtArr[i];
            
            var rows = prtJson.rows;
			if (rows.length === 0){
				continue;
			}
			var phdwNo = prtJson.phdwNo;
			var phac = prtJson.phac;
	        PIVASLODOP.PRINT_INIT('PHAIPMOBDRAW');
            PIVASLODOP.SET_PRINT_STYLE('FontName', 'Microsoft Yahei');
            PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
            PIVASLODOP.ADD_PRINT_TEXT('5mm', '0mm', '100%', '5mm', prtJson.locDesc + '备药单 科室联' + rePrint);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontName', 'Microsoft Yahei');
            PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 14);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'Alignment', 2);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);

			PIVASLODOP.ADD_PRINT_TEXT('5mm', '6mm', '100%', '5mm', '单号:'+prtJson.phacNo);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
			PIVASLODOP.ADD_PRINT_TEXT('11mm', '6mm', '100%', '5mm', '类别:'+prtJson.catDesc);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
			PIVASLODOP.ADD_PRINT_TEXT('17mm', '6mm', '100%', '5mm', '病区:'+prtJson.wardDesc);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);

			PIVASLODOP.ADD_PRINT_TEXT('23mm', '6mm', '100%', '5mm', '打印时间:'+prtJson.printDateTime);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);
			PIVASLODOP.ADD_PRINT_TEXT('23mm', '80mm', '100%', '5mm', '打印人:'+session['LOGON.USERNAME']);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
			PIVASLODOP.SET_PRINT_STYLEA(0, 'FontSize', 11);

            PIVASLODOP.ADD_PRINT_BARCODE('5mm', '169mm', '20mm', '20mm', 'QRCode', phac);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);	
            PIVASLODOP.ADD_PRINT_TEXT('23mm', '175mm', '100%', '5mm', phac);
            PIVASLODOP.SET_PRINT_STYLEA(0, 'ItemType', 1);
            
            // 列值用百分比
            var html =
                '<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:' +
                ('14') +
                ';font-family:Microsoft Yahei} table{table-layout:fixed;display:table;width:200mm} tfoot,th{ border:none;font-size:' +
                ('14') +
                ';text-align:left} tfoot,th,tr,td{font-weight:normal}</style><table>';
            html =   ' <table border=1 style="width:200mm;border-collapse:collapse;table-layout:fixed;" >'
            html += "<thead style='font-weight:bold;'>";
            html += "	<td style='text-align:center;width:" + ('5mm') + "'>" + ' 序' + '</td>';
            html += "	<td style='width:" + ('40mm') + "'>" + ' 药品名称' + '</td>';
            html += "	<td style='width:" + ('15mm') + "'>" + ' 商品名' + '</td>';
            html += "	<td style='width:" + ('25mm') + "'>" + ' 规格' + '</td>';
            html += "	<td style='width:" + ('13mm') + ";text-align:right'>" + '单价' + '</td>';
            html += "	<td style='width:" + ('13mm') + ";text-align:right'>" + '总价' + '</td>';
            html += "	<td style='width:" + ('10mm') + ";text-align:center'>" + '医嘱' + '</td>';
            html += "	<td style='width:" + ('10mm') + ";text-align:center'>" + '冲减' + '</td>';
            html += "	<td style='width:" + ('10mm') + ";text-align:center'>" + '实发' + '</td>';
            html += "	<td style='width:" + ('10mm') + ";text-align:center'>" + '缺药' + '</td>';
            html += "	<td style='width:" + ('10mm') + "'>" + ' 入盒' + '</td></tr>';
            html += '</thead>';
            html += '<tbody>';
            var totalAmt = 0;
            for (var i = 0; i < rows.length; i++) {
                var rowData = rows[i];
                html += '<tr>';
                html += '	<td style="text-align:center;height:6mm;width:5mm">' + rowData.seqNo + '</td>';
                html += '	<td style="width:40mm;white-space: nowrap;overflow:hidden;">' + rowData.inciDesc + '</td>';
                html += '	<td style="text-align:left;width:15mm;"><div style="white-space: nowrap;overflow:hidden">' + rowData.goodName + '</div></td>';
                html += '	<td style="text-align:left;width:25mm;"><div>' + rowData.spec + '</div></td>';
                html += '	<td style="text-align:right;;width:13mm">' + rowData.sp + '</td>';
                html += '	<td style="text-align:right;width:13mm">' + rowData.spAmt + '</td>';
                html += '	<td style="text-align:center;width:10mm">' + rowData.orderQty + '</td>';
                html += '	<td style="text-align:center;width:10mm">' + rowData.resQty + '</td>';
				html += '	<td style="text-align:center;width:10mm">' + rowData.lastQty + '</td>';
				html += '	<td style="text-align:center;width:10mm">' + rowData.lessQty + '</td>';
                html += '	<td style="text-align:center;width:10mm">' + rowData.inBox + '</td>';
                html += '</tr>';
                totalAmt = totalAmt + (1*rowData.spAmt);
            }
            html += '</tbody>';
            html += '<tfoot>';
            html += '	<tr>';
            html += '		<th colspan=4 style="text-align:left">总金额</th>';
            html += '		<th colspan=2 style="text-align:right">' + totalAmt.toFixed(2) + '</th>';
            html += '		<th colspan=5 style="text-align:right"></th>';
            html += '	</tr>';
            html += '	<tr>';
            html += '		<th colspan=11 style="text-align:left;height:8mm">配药人: '+prtJson.pyUserName+'　　　　　　　　　　发药人: '+prtJson.fyUserName+'　　　　　　　　　　领药人: </th>';
            html += '	</tr>';
            html += '</tfoot>';       
            html += '</table>';
            // 内部控制缩放,此处不用
            PIVASLODOP.ADD_PRINT_TABLE('30mm', '2mm', '190mm', '240mm', html);     
            PIVASLODOP.PRINT();
        }	
	}
};
