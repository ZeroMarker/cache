var REC_PRINT = {
    PrintType:null,
    GetData: function (recID) {
        return $.cm(
            {
                ClassName: 'PHA.IN.REC.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    recID: recID,
                    printUserName: session['LOGON.USERNAME']
                })
            },
            false
        );
    },
    Print: function (recID) {
        PHA.Loading('Show');
        if(REC_PRINT.PrintType == null){
            var tmpCom = REC_COM;
            var tmpSettings = tmpCom.GetSettings();
            REC_PRINT.PrintType = tmpSettings.App.PrintType || "";
        }
        var prtData = this.GetData(recID);
        var rows = prtData.List;
        var para = prtData.Para;
        PIVASLODOP = getLodop();
        PIVASLODOP.PRINT_INIT('PHAINREC');

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
                    'line-height': '5mm'
                },
                'table p': {
                    // 'white-space': 'nowrap',
                    // overflow: 'hidden'
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
                    width: '25mm'
                },
                // ����
                '.pha-print-qty': {
                    width: '10mm',
                    'text-align': 'right'
                },
                // ����Ч��
                '.pha-print-batNo': {
                    width: '20mm'
                },
                // ��λ
                '.pha-print-uomDesc': {
                    width: '10mm'
                },
                // ������ҵ
                '.pha-print-manfDesc': {
                    width: '20mm'
                },
                // ����
                '.pha-print-rp': {
                    width: '15mm',
                    'text-align': 'right'
                },
                // ���۽��
                '.pha-print-rpAmt': {
                    width: '18mm',
                    'text-align': 'right'
                },
                // �ۼ�
                '.pha-print-sp': {
                    width: '15mm',
                    'text-align': 'right'
                },
                // �ۼ۽��
                '.pha-print-spAmt': {
                    width: '18mm',
                    'text-align': 'right'
                },
                // ��Ʊ
                '.pha-print-invNo': {
                    width: '20mm'
                }
            }) +
            '</style>';
        html += ' <table border=0  cellspacing=0>';
        // ͷ
        html += '<thead>';
        html += '   <tr><td colspan=11 style="text-align:center;border:none"><p class="pha-print-title">' + para.title + '</p></td></tr>';
        html += '   <tr><td colspan=11 style="border:none">';
        html += '<p style="border:none;">';
        html += '���ң�' + para.locDesc;
        html += '������Ӫ��ҵ��' + para.vendorDesc;
        html += '�������ͣ�' + para.operateTypeDesc;
        html += '�������ţ�' + para.no;
        html += '</p>';
        html += '    </td></tr>';
        html += '   <tr>';
        html += '       <td class="pha-print-inciCode">����</td>';
        html += '       <td class="pha-print-inciDesc">����</td>';
        html += '       <td class="pha-print-qty">����</td>';
        html += '       <td class="pha-print-uomDesc">��λ</td>';
        html += '       <td class="pha-print-rp">����</td>';
        html += '       <td class="pha-print-rpAmt">���۽��</td>';
        html += '       <td class="pha-print-sp">�ۼ�</td>';
        html += '       <td class="pha-print-spAmt">�ۼ۽��</td>';
        html += '       <td class="pha-print-batNo">����Ч��</td>';
        html += '       <td class="pha-print-manfDesc">������ҵ</td>';
        html += '       <td class="pha-print-invNo">��Ʊ��</td>';
        html += '   </tr>';
        html += '<thead>';
        // β
        html += '<tfoot>';
        html += '   <tr>';
        html += '       <td colspan=4 style="text-align:left;">�ܼ�</td>';
        html += '       <td colspan=2 style="text-align:right;">' + para.totalRpAmt + '</td>';
        html += '       <td colspan=2 style="text-align:right;">' + para.totalSpAmt + '</td>';
        html += '       <td colspan=3 ></td>';
        html += '   </tr>';
        html += '   <tr>';
        html += '       <td colspan=7 style="text-align:left;border:0;">' + '��ӡ:' + para.printInfo + '�����Ƶ���' + para.createDate + ' ' + para.createTime + ' ' + para.createUserName + '</td>';
        html += '       <td colspan=4 style="text-align:right;border:0;">' + '��<font tdata="PageNO">##</font>ҳ���� <font tdata="PageCount">##</font>ҳ��' + '</td>';
        html += '   </tr>';

        html += '</tfoot>';
        // ����
        html += '<tbody>';
        for (var i = 0; i < rows.length; i++) {
            var rowData = rows[i];
            html += '<tr>';
            html += '   <td class="pha-print-inciCode"><div style="height:10mm;overflow:hidden;word-wrap: break-word;">' + rowData.inciCode + '</div></td>';
            html += '   <td class="pha-print-inciDesc"><div style="height:10mm;overflow:hidden;">' + rowData.inciDesc + '</div></td>';
            html += '   <td class="pha-print-qty">' + rowData.qty + '</td>';
            html += '   <td class="pha-print-uomDesc">' + rowData.uomDesc + '</td>';
            html += '   <td class="pha-print-rp">' + rowData.rp + '</td>';
            html += '   <td class="pha-print-rpAmt">' + rowData.rpAmt + '</td>';
            html += '   <td class="pha-print-sp">' + rowData.sp + '</td>';
            html += '   <td class="pha-print-spAmt">' + rowData.spAmt + '</td>';
            html += '   <td class="pha-print-batNo">' + rowData.batNo + '</br>' + rowData.expDate + '</td>';
            html += '   <td class="pha-print-manfDesc"><div style="height:10mm;overflow:hidden;">' + rowData.manfDesc + '</div></td>';
            html += '   <td class="pha-print-invNo"><div style="height:10mm;overflow:hidden;">' + rowData.invNo + '</div></td>';
            html += '</tr>';
        }
        html += '</tbody>';
        html += '</table>';
        // �ڲ���������,�˴�����, A4 ��С 210 297
        PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
        PIVASLODOP.ADD_PRINT_TABLE('5mm', '5mm', '195mm', '287mm', html);
        // Ԥ����ӡ / ֱ�Ӵ�ӡ
        if (REC_PRINT.PrintType == 1){
	        PIVASLODOP.PRINT();
        }
        else{
	        PIVASLODOP.PREVIEW();
        } 
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
