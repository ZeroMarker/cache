(function ($) {
    function getRows(target, param) {
        // var state = $(target).data('datagrid');
        // if (state.filterSource) {
        //     return state.filterSource.rows;
        // } else {
        //     return state.data.rows;
        // }
        var exportAll = "";
        if (typeof param == 'string') {
            // 默认
        } else {
            exportAll = param['exportAll'];
        }
        // 导出全部数据
        if (exportAll== "1")
        {
        return $(target).datagrid('getData').originalRows;
      }
      // 导出当前页数据
        return $(target).datagrid('getData').rows;
    }
  
    function getFooterRows(target) {
        var state = $(target).data('datagrid');
        return state.data.footer || [];
    }
  
    function toHtml(target, rows, footer, caption, centertitle, maxcolumn, param) {
        rows = rows || getRows(target, param);
        rows = rows.concat(footer || getFooterRows(target));
        var dg = $(target);
        var data = ['<table border="1" rull="all" style="border-collapse:collapse;vnd.ms-excel.numberformat:@;">'];
        // 2021.12.2 gaoshan add center title
        if (centertitle && centertitle != null && centertitle != "") {
            data.push('<tr style="height:31px;"><td colspan="' + maxcolumn +
                '" style="text-align:center;font-weight:bold;font-size:20px;">' + centertitle + '</td></tr>')
        }
        var frozenFieldsArr = dg.datagrid('getColumnFields', true);
        var NofrozenFieldsArr = dg.datagrid('getColumnFields', false)
        var fields = frozenFieldsArr.concat(NofrozenFieldsArr); //dg.datagrid('getColumnFields', true).concat(dg.datagrid('getColumnFields', false));
        // remove cols that are not necessary---2023.2.3 wujiang add
        fields=JSON.parse(JSON.stringify(fields));
        if (param['removeCols']&&param['removeCols'].length) {
          for (var i = 0; i < fields.length; i++) {
            if (param['removeCols'].indexOf(fields[i])>-1) {
              fields.splice(i,1);
              i--;
            }
          }
        }
        //获取�?有列信息
        var cc = dg.datagrid('options').columns.concat([])
        // remove cols that are not necessary---2023.2.3 wujiang add
        cc=JSON.parse(JSON.stringify(cc));
        if (param['removeCols']&&param['removeCols'].length) {
          for (var i = 0; i < cc.length; i++) {
            for (var j = 0; j < cc[i].length; j++) {
              if (param['removeCols'].indexOf(cc[i][j].field)>-1) {
                cc[i].splice(j,1);
                j--;
              }
            }
          }
        }
        var frozenColumns = dg.datagrid('options').frozenColumns; // 冻结�?
        if (frozenColumns && frozenColumns.length > 0) {
            for (var i = 0; i < cc.length; i++) {
                if(frozenColumns[i]){
                    cc[i] = frozenColumns[i].concat(cc[i])
                }
            }
        }
        //var trStyle = 'height:32px';
        var trStyle = 'height:100%'; // 高度全部自适应处理 2022.5.20
        var tdStyle0 = 'vertical-align:middle;padding:0 4px';
        if (caption) {
            data.push('<caption style="font-size: 26px"><h2>' + caption + '</h2></caption>');
        }
        var TableMergeArr=[];
        //写入表头信息，先判断是否为多级表�?
        for (var j = 0; j < cc.length; j++) {
            var tmptrStyle = trStyle;
            var cols = cc[j];
            /*if (cols && cols.length > 0 && cols[0].rowspan != undefined) {
                // 第一行設置空
                if (j == 0) {
                    tmptrStyle = 'height:0px';
                }
            }*/
            // 第一行表头，高度自适应处理，否则会出现导出表头高度不全 2022.5.20
            //data.push('<tr style="' + tmptrStyle + '">');
            data.push('<tr>');
            for (var i = 0; i < cols.length; i++) {
                //判断是否未隐藏字�?
                if ((cols[i].hidden + "") == "true") {
                    continue;
                }
                var tdStyle = tdStyle0 + ';width:' + cols[i].boxWidth + 'px;';
                tdStyle += ';text-align:' + (cols[i].halign || cols[i].align || '');
                //定义行列信息，初始化行和列的值为1
                var colspans = 1;
                var rowspans = 1;
                if (cols[i].rowspan != undefined) {
                    rowspans = cols[i].rowspan;
                }
                /*
                // gaoshan 特殊处理
                if (cols[i].exportrowspan != undefined){
                  rowspans = cols[i].exportrowspan
                }
                */
                if (cols[i].colspan != undefined) {
                    colspans = cols[i].colspan;
                }
                data.push('<td style="' + tdStyle + '" colspan="' + colspans + '" rowspan="' + rowspans + '">' + $(
                    '<div />').html(cols[i].title).text() + '</td>');
                TableMergeArr.push({
                  rowspans:rowspans,
                  ExportRowNum:0,
              });
            }
            data.push('</tr>');
        }
  
        //原方�?
        /*
         data.push('<tr style="'+trStyle+'">');
         for(var i=0; i<fields.length; i++){
         var col = dg.datagrid('getColumnOption', fields[i]);
         var tdStyle = tdStyle0 + ';width:'+col.boxWidth+'px;';
         tdStyle += ';text-align:'+(col.halign||col.align||'');
         data.push('<td style="'+tdStyle+'">'+col.title+'</td>');
         }
         data.push('</tr>');
         */
        var rowIdPrefix=$.data(target, "datagrid").rowIdPrefix;
        var rowIndex=0;
        $.map(rows, function (row) {
            data.push('<tr style="' + trStyle + '">');
            for (var i = 0; i < fields.length; i++) {
                var field = fields[i];
                var col = dg.datagrid('getColumnOption', field);
                if ((col.hidden + "") == "true") {
                    continue;
                }
                var value = row[field]
                //var value = col.formatter ? $('<div />').html(col.formatter(row[field], row, i)).text() : row[field];
                if (value == undefined) {
                    value = '';
                }
                var tdStyle = tdStyle0;
                tdStyle += ';text-align:' + (col.align || '');
                var frozen=(i < frozenFieldsArr.length)?true:false;
              var rowId = rowIdPrefix + "-" + (frozen ? 1 : 2) + "-" + rowIndex;
              var _$td= $("#"+rowId).find("td[field='"+field+"']");
                if (_$td.css("display")=="none") continue;
            var rowspans=_$td.attr("rowspan") || 1;
              var colspans=_$td.attr("colspan") || 1;
                data.push(
                  '<td style="' + tdStyle + '" colspan="' + colspans + '" rowspan="' + rowspans  +  '">' + value + '</td>'
              );
            }
            data.push('</tr>');
            rowIndex++;
        });
        data.push('</table>');
        return data.join('');
    }
  
    function toArray(target, rows) {
        rows = rows || getRows(target);
        var dg = $(target);
        var fields = dg.datagrid('getColumnFields', true).concat(dg.datagrid('getColumnFields', false));
        var data = [];
        var r = [];
        for (var i = 0; i < fields.length; i++) {
            var col = dg.datagrid('getColumnOption', fields[i]);
            r.push(col.title);
        }
        data.push(r);
        $.map(rows, function (row) {
            var r = [];
            for (var i = 0; i < fields.length; i++) {
                r.push(row[fields[i]]);
            }
            data.push(r);
        });
        return data;
    }
  
    function print(target, param) {
        var title = null;
        var rows = null;
        var footer = null;
        var caption = null;
        if (typeof param == 'string') {
            title = param;
        } else {
            title = param['title'];
            rows = param['rows'];
            footer = param['footer'];
            caption = param['caption'];
        }
        var newWindow = window.open('', '', 'width=800, height=500');
        var document = newWindow.document.open();
        var content =
            '<!doctype html>' +
            '<html>' +
            '<head>' +
            '<meta charset="utf-8">' +
            '<title>' + title + '</title>' +
            '</head>' +
            '<body>' + toHtml(target, rows, footer, caption, centertitle) + '</body>' +
            '</html>';
        document.write(content);
        document.close();
        newWindow.print();
    }
  
    function b64toBlob(data) {
        var sliceSize = 512;
        var chars = atob(data);
        var byteArrays = [];
        for (var offset = 0; offset < chars.length; offset += sliceSize) {
            var slice = chars.slice(offset, offset + sliceSize);
            var byteNumbers = new Array(slice.length);
            for (var i = 0; i < slice.length; i++) {
                byteNumbers[i] = slice.charCodeAt(i);
            }
            var byteArray = new Uint8Array(byteNumbers);
            byteArrays.push(byteArray);
        }
        return new Blob(byteArrays, {
            type: '' // application/vnd.ms-excel  txt/html
        });
    }
  
    function toExcel(target, param) {
        var filename = null;
        var rows = null;
        var footer = null;
        var caption = null;
        var worksheet = 'Worksheet';
        var centertitle = null;
        var maxcolumn = 10;
        if (typeof param == 'string') {
            filename = param;
        } else {
            filename = param['filename'];
            rows = param['rows'];
            footer = param['footer'];
            caption = param['caption'];
            worksheet = param['worksheet'] || 'Worksheet';
            centertitle = param['centertitle'];
            maxcolumn = param['maxcolumn'];
        }
        var dg = $(target);
        var uri = 'data:application/vnd.ms-excel;base64,',
            template =
            '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>',
            base64 = function (s) {
                return window.btoa(unescape(encodeURIComponent(s)))
            },
            format = function (s, c) {
                return s.replace(/{(\w+)}/g, function (m, p) {
                    return c[p];
                })
            }
  
        var table = toHtml(target, rows, footer, caption, centertitle, maxcolumn, param);
        var ctx = {
            worksheet: worksheet,
            table: table
        };
        var data = base64(format(template, ctx));
        if (window.navigator.msSaveBlob) {
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
  
    $.extend($.fn.datagrid.methods, {
        toHtml: function (jq, rows) {
            return toHtml(jq[0], rows);
        },
        toArray: function (jq, rows) {
            return toArray(jq[0], rows);
        },
        toExcel: function (jq, param) {
            return jq.each(function () {
                toExcel(this, param);
            });
        },
        print: function (jq, param) {
            return jq.each(function () {
                print(this, param);
            });
        }
    });
  })(jQuery);