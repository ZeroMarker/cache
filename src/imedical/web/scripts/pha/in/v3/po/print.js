var PO_PRINT = {
    GetData: function (poID) {
        return $.cm(
            {
                ClassName: 'PHA.IN.PO.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    poID: poID,
                    printUserName: session['LOGON.USERNAME']
                })
            },
            false
        );
    },
    Print: function (poID) {
        PHA.Loading('Show');
        var prtData = this.GetData(poID);
        var rows = prtData.List;
        var para = prtData.Para;
        PIVASLODOP = getLodop();
        PIVASLODOP.PRINT_INIT('PHAINPO');

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
                    'line-height': '7mm' // �и�
                },
                'table p': {
                    'white-space': 'nowrap',
                    overflow: 'hidden'
                },
                // ����
                '.pha-print-title': {
                    'font-size': '16 !important',
                    'font-weight': 'bold',
                    border: 'none'
                },
                // ����
                '.pha-print-inciCode': {
                    width: '20mm'
                },
                // ����
                '.pha-print-inciDesc': {
                    width: '50mm'
                },
                // ����
                '.pha-print-qty': {
                    width: '20mm',
                    'text-align': 'right'
                },
                // ��λ
                '.pha-print-uomDesc': {
                    width: '20mm'
                },
                // ������ҵ
                '.pha-print-manfDesc': {
                    width: '30mm'
                },
                // ����
                '.pha-print-rp': {
                    width: '25mm',
                    'text-align': 'right'
                },
                // ���۽��
                '.pha-print-rpAmt': {
                    width: '30mm',
                    'text-align': 'right'
                }
            }) +
            '</style>';
        html += ' <table border=0  cellspacing=0>';
        // ͷ
        html += '<thead>';
        html += '	<tr><td colspan=7 style="text-align:center;border:none"><p class="pha-print-title">' + para.title + '</p></td></tr>';
        html += '	<tr><td colspan=7 style="border:none">';
        html += '<p style="border:none;">';
        html += '���ң�' + para.locDesc;
        html += '������Ӫ��ҵ��' + para.vendorDesc;
        html += '�������ţ�' + para.no;
        html += '�����Ƶ���' + para.createDate + ' ' + para.createTime + ' ' + para.createUserName;
        html += '</p>';
        html += '    </td></tr>';
        html += '	<tr>';
        html += '       <td class="pha-print-inciCode">����</td>';
        html += '       <td class="pha-print-inciDesc">����</td>';
        html += '       <td class="pha-print-qty">����</td>';
        html += '       <td class="pha-print-uomDesc">��λ</td>';
        html += '       <td class="pha-print-manfDesc">������ҵ</td>';
        html += '       <td class="pha-print-rp">����</td>';
        html += '       <td class="pha-print-rpAmt">���۽��</td>';
        html += '	</tr>';
        html += '<thead>';
        // β
        html += '<tfoot>';
        html += '	<tr>';
        html += '		<td colspan=6 style="text-align:left;">�ܼ�</td>';
        html += '		<td colspan=1 style="text-align:right;">' + para.totalRpAmt + '</td>';
        html += '	</tr>';
        html += '	<tr>';
        html += '		<td colspan=5 style="text-align:left;border:0;">' + '��ӡ:' + para.printInfo + '</td>';
        html += '		<td colspan=2 style="text-align:right;border:0;">' + '��<font tdata="PageNO">##</font>ҳ���� <font tdata="PageCount">##</font>ҳ��' + '</td>';
        html += '	</tr>';

        html += '</tfoot>';
        // ����
        html += '<tbody>';
        for (var i = 0; i < rows.length; i++) {
            var rowData = rows[i];
            html += '<tr>';
            html += '	<td class="pha-print-inciCode"><p>' + rowData.inciCode + '</p></td>';
            html += '	<td class="pha-print-inciDesc"><p>' + rowData.inciDesc + '</p></td>';
            html += '	<td class="pha-print-qty"><p>' + rowData.qty + '</p></td>';
            html += '	<td class="pha-print-uomDesc"><p>' + rowData.uomDesc + '</p></td>';
            html += '	<td class="pha-print-manfDesc"><p>' + rowData.manfDesc + '</p></td>';
            html += '	<td class="pha-print-rp"><p>' + rowData.rp + '</p></td>';
            html += '	<td class="pha-print-rpAmt"><p>' + rowData.rpAmt + '</p></td>';
            html += '</tr>';
        }
        html += '</tbody>';
        html += '</table>';
        // �ڲ���������,�˴�����, A4 ��С 210 297
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

