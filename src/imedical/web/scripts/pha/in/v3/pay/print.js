var PAY_PRINT = {
    GetData: function (payID) {
        return $.cm(
            {
                ClassName: 'PHA.IN.PAY.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    payID: payID,
                    printUserName: session['LOGON.USERNAME']
                })
            },
            false
        );
    },
    Print: function (payID) {
        PHA.Loading('Show');
        var prtData = this.GetData(payID);
        var rows = prtData.List;
        var para = prtData.Para;
        PIVASLODOP = getLodop();
        PIVASLODOP.PRINT_INIT('PHAINPAY');

        var html = '';
        html +=
            '<style>' +
            this.FmtStyle2Class({
                'td,th': {
                    border: '1px solid #000'
                },
                table: {
                    'border-collapse': 'collapse',
                    'table-layout': 'fixed',
                    'font-size': '14',
                    'line-height': '7mm' // 行高
                },
                'table p': {
                    'white-space': 'nowrap',
                    overflow: 'hidden'
                },
                // 标题
                '.pha-print-title': {
                    'font-size': '16 !important',
                    'font-weight': 'bold',
                    border: 'none'
                },
                // 代码
                '.pha-print-bizTypeDesc': {
                    width: '10mm'
                },
                // 代码
                '.pha-print-inciCode': {
                    width: '20mm'
                },
                // 名称
                '.pha-print-inciDesc': {
                    width: '40mm'
                },
                // 数量
                '.pha-print-qty': {
                    width: '15mm',
                    'text-align': 'right'
                },
                // 单位
                '.pha-print-uomDesc': {
                    width: '8mm'
                },
                // 批号
                '.pha-print-batNo': {
                    width: '15mm'
                },
                // 生产企业
                '.pha-print-manfDesc': {
                    width: '20mm'
                },
                // 进价
                '.pha-print-rp': {
                    width: '15mm',
                    'text-align': 'right'
                },
                // 进价金额
                '.pha-print-rpAmt': {
                    width: '20mm',
                    'text-align': 'right'
                },
                // 付款金额
                '.pha-print-payAmt': {
                    width: '20mm',
                    'text-align': 'right'
                }
            }) +
            '</style>';
        html += ' <table border=0  cellspacing=0>';
        // 头
        html += '<thead>';
        html += '	<tr><td colspan=10 style="text-align:center;border:none"><p class="pha-print-title">' + para.title + '</p></td></tr>';
        html += '	<tr><td colspan=10 style="border:none">';
        html += '<p style="border:none;">';
        html += '科室：' + para.locDesc;
        html += '　　经营企业：' + para.vendorDesc;
        html += '　　单号：' + para.no;

        html += '</p>';
        html += '    </td></tr>';
        html += '	<tr>';
        html += '       <td class="pha-print-bizTypeDesc">类型</td>';
        html += '       <td class="pha-print-inciCode">代码</td>';
        html += '       <td class="pha-print-inciDesc">名称</td>';
        html += '       <td class="pha-print-qty">数量</td>';
        html += '       <td class="pha-print-uomDesc">单位</td>';
        html += '       <td class="pha-print-batNo">批号</td>';
        html += '       <td class="pha-print-manfDesc">生产企业</td>';
        html += '       <td class="pha-print-rp">进价</td>';
        html += '       <td class="pha-print-rpAmt">进价金额</td>';
        html += '       <td class="pha-print-payAmt">付款金额</td>';
        html += '	</tr>';
        html += '<thead>';
        // 尾
        html += '<tfoot>';
        html += '	<tr>';
        html += '		<td colspan=8 style="text-align:left;">总计</td>';
        html += '		<td colspan=1 style="text-align:right;">' + para.totalRpAmt + '</td>';
        html += '		<td colspan=1 style="text-align:right;">' + para.totalPayAmt + '</td>';
        html += '	</tr>';
        html += '	<tr>';
        html += '		<td colspan=8 style="text-align:left;border:0;">' + '打印:' + para.printInfo + '　　制单：' + para.createDate + ' ' + para.createTime + ' ' + para.createUserName + '</td>';
        html += '		<td colspan=2 style="text-align:right;border:0;">' + '第<font tdata="PageNO">##</font>页（共 <font tdata="PageCount">##</font>页）' + '</td>';
        html += '	</tr>';

        html += '</tfoot>';
        // 内容
        html += '<tbody>';
        for (var i = 0; i < rows.length; i++) {
            var rowData = rows[i];
            html += '<tr>';
            html += '	<td class="pha-print-bizTypeDesc"><p>' + rowData.bizTypeDesc + '</p></td>';
            html += '	<td class="pha-print-inciCode"><p>' + rowData.inciCode + '</p></td>';
            html += '	<td class="pha-print-inciDesc"><p>' + rowData.inciDesc + '</p></td>';
            html += '	<td class="pha-print-qty"><p>' + rowData.qty + '</p></td>';
            html += '	<td class="pha-print-uomDesc"><p>' + rowData.uomDesc + '</p></td>';
            html += '	<td class="pha-print-batNo"><p>' + rowData.batNo + '</p></td>';
            html += '	<td class="pha-print-manfDesc"><p>' + rowData.manfDesc + '</p></td>';
            html += '	<td class="pha-print-rp"><p>' + rowData.rp + '</p></td>';
            html += '	<td class="pha-print-rpAmt"><p>' + rowData.rpAmt + '</p></td>';
            html += '	<td class="pha-print-payAmt"><p>' + rowData.payAmt + '</p></td>';
            html += '</tr>';
        }
        html += '</tbody>';
        html += '</table>';
        // 内部控制缩放,此处不用, A4 大小 210 297
        PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
        PIVASLODOP.ADD_PRINT_TABLE('5mm', '5mm', '200mm', '287mm', html);
        PIVASLODOP.PRINT();
        setTimeout(function () {
            PHA.Loading('Hide');
        }, 500);
    },
    FmtStyle2Class: function (style) {
        var retArr = '';
        for (var className in style) {
            var classStr = className + ' {';
            var classObj = style[className];
            for (var key in classObj) {
                classStr += key + ':' + classObj[key] + ';';
                if (key === 'width') {
                    classStr += 'max-width' + ':' + classObj[key] + ';';
                }
            }
            classStr += '}';
            retArr += ' ' + classStr;
        }
        return retArr;
    }
};
