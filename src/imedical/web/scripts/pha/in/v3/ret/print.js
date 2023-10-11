var RET_PRINT = {
    PrintType:null,
    GetData: function (retID) {
        return $.cm(
            {
                ClassName: 'PHA.IN.RET.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    retID: retID,
                    printUserName: session['LOGON.USERNAME']
                })
            },
            false
        );
    },
    Print: function (retID) {
        PHA.Loading('Show');
        if(RET_PRINT.PrintType == null){
            var tmpCom = RET_COM;
            var tmpSettings = tmpCom.GetSettings();
            RET_PRINT.PrintType = tmpSettings.App.PrintType || "";
        }
        var prtData = this.GetData(retID);
        if(prtData.msg != undefined){
            PHA.Alert('', prtData.msg, 'warning');
            PHA.Loading('Hide');
            return;
           
        }
        var rows = prtData.List;
        var para = prtData.Para;
        PIVASLODOP = getLodop();
        PIVASLODOP.PRINT_INIT('PHAINRET');

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
                    'line-height':'5mm'
                },
                'table p': {
                    // 'white-space': 'nowrap',
                    // overflow: 'hidden'
                },
                // 标题
                '.pha-print-title': {
                    'font-size': '16 !important',
                    'font-weight': 'bold',
                    border: 'none'
                },
                // 代码
                '.pha-print-inciCode': {
                    width: '20mm'
                },
                // 名称
                '.pha-print-inciDesc': {
                    width: '25mm'
                },
                // 数量
                '.pha-print-qty': {
                    width: '10mm',
                    'text-align': 'right'
                },
                // 批号效期
                '.pha-print-batNo': {
                    width: '20mm'
                },
                // 单位
                '.pha-print-uomDesc': {
                    width: '10mm'
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
                    width: '18mm',
                    'text-align': 'right'
                },
                // 售价
                '.pha-print-sp': {
                    width: '15mm',
                    'text-align': 'right'
                },
                // 售价金额
                '.pha-print-spAmt': {
                    width: '18mm',
                    'text-align': 'right'
                },
                // 发票
                '.pha-print-invNo': {
                    width: '20mm'
                }
            }) +
            '</style>';
        html += ' <table border=0  cellspacing=0>';
        // 头
        html += '<thead>';
        html += '	<tr><td colspan=11 style="text-align:center;border:none"><p class="pha-print-title">' + para.title + '</p></td></tr>';
        html += '	<tr><td colspan=11 style="border:none">';
        html += '<p style="border:none;">';
        html += '科室：' + para.locDesc;
        html += '　　经营企业：' + para.vendorDesc;
        html += '　　类型：' + para.operateTypeDesc;
        html += '　　单号：' + para.no;
        html += '</p>';
        html += '    </td></tr>';
        html += '	<tr>';
        html += '       <td class="pha-print-inciCode">代码</td>';
        html += '       <td class="pha-print-inciDesc">名称</td>';
        html += '       <td class="pha-print-qty">数量</td>';
        html += '       <td class="pha-print-uomDesc">单位</td>';
        html += '       <td class="pha-print-rp">进价</td>';
        html += '       <td class="pha-print-rpAmt">进价金额</td>';
        html += '       <td class="pha-print-sp">售价</td>';
        html += '       <td class="pha-print-spAmt">售价金额</td>';
        html += '       <td class="pha-print-batNo">批号效期</td>';
        html += '       <td class="pha-print-manfDesc">生产企业</td>';
        html += '       <td class="pha-print-invNo">发票号</td>';
        html += '	</tr>';
        html += '<thead>';
        // 尾
        html += '<tfoot>';
        html += '	<tr>';
        html += '		<td colspan=4 style="text-align:left;">总计</td>';
        html += '		<td colspan=2 style="text-align:right;">' + para.totalRpAmt + '</td>';
        html += '		<td colspan=2 style="text-align:right;">' + para.totalSpAmt + '</td>';
        html += '		<td colspan=3 ></td>';
        html += '	</tr>';
        html += '	<tr>';
        html += '		<td colspan=7 style="text-align:left;border:0;">' + '打印:' + para.printInfo + '　　制单：' + para.createDate + ' ' + para.createTime + ' ' + para.createUserName + '</td>';
        html += '		<td colspan=4 style="text-align:right;border:0;">' + '第<font tdata="PageNO">##</font>页（共 <font tdata="PageCount">##</font>页）' + '</td>';
        html += '	</tr>';

        html += '</tfoot>';
        // 内容
        html += '<tbody>';
        for (var i = 0; i < rows.length; i++) {
            var rowData = rows[i];
            html += '<tr>';
            html += '	<td class="pha-print-inciCode">' + rowData.inciCode + '</td>';
            html += '	<td class="pha-print-inciDesc"><div style="height:10mm;overflow:hidden;">' + rowData.inciDesc + '</div></td>';
            html += '	<td class="pha-print-qty">' + rowData.qty + '</td>';
            html += '	<td class="pha-print-uomDesc">' + rowData.uomDesc + '</td>';
            html += '	<td class="pha-print-rp">' + rowData.rp + '</td>';
            html += '	<td class="pha-print-rpAmt">' + rowData.rpAmt + '</td>';
            html += '   <td class="pha-print-sp">' + rowData.sp + '</td>';
            html += '   <td class="pha-print-spAmt">' + rowData.spAmt + '</td>';
            html += '   <td class="pha-print-batNo">' + rowData.batNo + '</br>'+rowData.expDate +'</td>';
            html += '   <td class="pha-print-manfDesc"><div style="height:10mm;overflow:hidden;">' + rowData.manfDesc + '</div></td>';
            html += '   <td class="pha-print-invNo"><div style="height:10mm;overflow:hidden;">' + rowData.invNo + '</div></td>';
            html += '</tr>';
        }
        html += '</tbody>';
        html += '</table>';
        // 内部控制缩放,此处不用, A4 大小 210 297
        PIVASLODOP.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');
        PIVASLODOP.ADD_PRINT_TABLE('5mm', '5mm', '195mm', '287mm', html);
        if(RET_PRINT.PrintType == "2"){
            PIVASLODOP.PREVIEW()
        }
        else{
            PIVASLODOP.PRINT();   
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
