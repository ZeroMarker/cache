/**
 * DataGrid Export for jQuery EasyUI
 * version: 1.0.3
 */
 
(function($){
    function getRows(target){
        var state = $(target).data('datagrid');
        if (state.filterSource){
            return state.filterSource.rows;
        } else {
            return state.data.rows;
        }
    }
    function getFooterRows(target){
        var state = $(target).data('datagrid');
        return state.data.footer || [];
    }
    function toHtml(target, rows, footer, caption, fields){
        rows = rows || getRows(target);
        rows = rows.concat(footer||getFooterRows(target));
        var dg = $(target);
        var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
        var fields = fields || dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        var trStyle = 'height:32px';
        var tdStyle0 = 'mso-number-format:\\@;vertical-align:middle;padding:0 4px';
        if (caption){
            data.push('<caption>'+caption+'</caption>');
        }
        data.push('<tr style="'+trStyle+'">');
        for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
            if ((col.hidden)||(col.checkbox)) continue;
            var tdStyle = tdStyle0 + ';width:'+col.boxWidth+'px;';
            tdStyle += 'text-align:'+(col.halign||col.align||'')+';';
            data.push('<td style="'+tdStyle+'">'+col.title+'</td>');
        }
        data.push('</tr>');
        $.map(rows, function(row){
            data.push('<tr style="'+trStyle+'">');
            for(var i=0; i<fields.length; i++){
                var field = fields[i];
                var col   = dg.datagrid('getColumnOption', field);
                if ((col.hidden)||(col.checkbox)) continue;
                var value = row[field];
                if (value == undefined){
                    value = '';
                }
                var tdStyle = tdStyle0;
                tdStyle += 'text-align:'+(col.align||'')+';';
                data.push(
                    '<td style="'+tdStyle+'">'+value+'</td>'
                );
            }
            data.push('</tr>');
        });
        data.push('</table>');
        return data.join('');
    }

    function toArray(target, rows, footer, fields){
        rows = rows || getRows(target);
        rows = rows.concat(footer||getFooterRows(target));
        var dg = $(target);
        var fields = fields || dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        var data = [];
        var r = [];
        for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
            r.push(col.title);
        }
        data.push(r);
        $.map(rows, function(row){
            var r = [];
            for(var i=0; i<fields.length; i++){
                r.push(row[fields[i]]);
            }
            data.push(r);
        });
        return data;
    }

    function print(target, param){
        var title = null;
        var rows = null;
        var footer = null;
        var caption = null;
        var fields = null;
        if (typeof param == 'string'){
            title = param;
        } else {
            title = param['title'];
            rows = param['rows'];
            footer = param['footer'];
            caption = param['caption'];
            fields = param['fields'];
        }
        var newWindow = window.open('', '', 'width=800, height=500');
        var document = newWindow.document.open();
        var content = 
            '<!doctype html>' +
            '<html>' +
            '<head>' +
            '<meta charset="utf-8">' +
            '<title>'+title+'</title>' +
            '</head>' +
            '<body>' + toHtml(target, rows, footer, caption, fields) + '</body>' +
            '</html>';
        document.write(content);
        document.close();
        newWindow.print();
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
            type: ''
        });
    }

    function toExcel(target, param){
        var filename = null;
        var rows = null;
        var footer = null;
        var caption = null;
        var fields = null;
        var worksheet = 'Worksheet';
        if (typeof param == 'string'){
            filename = param;
        } else {
            filename = param['filename'];
            rows = param['rows'];
            footer = param['footer'];
            caption = param['caption'];
            fields = param['fields'];
            worksheet = param['worksheet'] || 'Worksheet';
        }
        var dg = $(target);
        var uri = 'data:application/vnd.ms-excel;base64,'
        , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
        , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
        , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }

        var table = toHtml(target, rows, footer, caption, fields);
        var ctx = { worksheet: worksheet, table: table };
        var data = base64(format(template, ctx));
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

    function toCsv(target, param){
        var filename = null;
        var rows = null;
        var footer = null;
        var fields = null;
        if (typeof param == 'string'){
            filename = param;
        } else {
            filename = param['filename'];
            rows = param['rows'];
            footer = param['footer'];
            fields = param['fields'];
        }
        var arrayData = toArray(target, rows, footer, fields);
        var csv = $.map(arrayData, function(row){
            return row.join(',');
        }).join("\r\n");
        var data = window.btoa(unescape(encodeURIComponent(csv)));
        if (window.navigator.msSaveBlob){
            var blob = b64toBlob(data);
            window.navigator.msSaveBlob(blob, filename);
        } else {
            var uri = 'data:text/csv;charset=utf-8;base64,';
            var alink = $('<a style="display:none"></a>').appendTo('body');
            alink[0].href = uri + data;
            alink[0].download = filename;
            alink[0].click();
            alink.remove();
        }
    }

    $.extend($.fn.datagrid.methods, {
        toHtml: function(jq, rows){
            return toHtml(jq[0], rows);
        },
        toArray: function(jq, rows){
            return toArray(jq[0], rows);
        },
        toExcel: function(jq, param){
            return jq.each(function(){
                toExcel(this, param);
            });
        },
        toCsv: function(jq, param){
            return jq.each(function(){
                toCsv(this, param);
            });
        },
        print: function(jq, param){
            return jq.each(function(){
                print(this, param);
            });
        }
    });
})(jQuery);
