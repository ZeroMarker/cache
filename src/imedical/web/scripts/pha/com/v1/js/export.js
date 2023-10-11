/**
 * 名称:   药房公共导出
 * 编写人:  yunhaibao
 * 编写日期: 2019-08-12
 */
var PHA_EXPORT = {
    RegNotNumber:/身|号|病|码|证/,
    /**
     * 所需js由此js单独加载,不再加载界面同时加载
     * @param {Object} title 表格标题 {"code":"代码","desc":"名称"}
     * @param {Array}  data 表格数据 [{"code":"AA","desc":"AAA"},{"code":"DA","desc":"DADA"}]
     * @param {String} fileName 文件名,默认空时按时间点生成
     * @param {Object} colsForm 数据格式化函数, 例如: {"code":function(v, r, i){}, "desc":function(v, r, i){}}
     */
    XLSX: function (title, data, fileName, colsForm) {
        colsForm = colsForm || {};
        fileName = fileName || "数据导出_" + new Date().getTime() + ".xlsx"; // 待加日期
        var jsArr = [
            "/imedical/web/scripts/pha/plugins/xlsx/xlsx.full.min.js",
            "/imedical/web/scripts/pha/plugins/export-excel/FileSaver.js", 
            "/imedical/web/scripts/pha/plugins/export-excel/Blob.js"
        ]
        PHA_EXPORT.LoadJS(jsArr, DoExport);
        function DoExport(){
            var notNumberArr = [];
            var keys = Object.keys(title);
            var firstRow = {}; // 标题
            keys.forEach(function (item) {
                firstRow[item] = title[item];
            }); // 这段没用
            data.unshift(firstRow);
            var content = {};
            try {
                // 把json格式的数据转为excel的行列形式
                var sheetsData = data.map(function (item, rowIndex) {
                    return keys.map(function (key, columnIndex) {
                        if (title) {
                            if (key in title) {
                                /*return Object.assign({}, {
                                    value: item[key],
                                    position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
                                });*/
                                var keyVal = item[key];
                                if (rowIndex == 0) {
                                    keyVal = PHA_EXPORT.stripHtml(keyVal);
                                } else if (rowIndex > 0 && colsForm[key]) {
                                    keyVal = colsForm[key](item[key], item, rowIndex);
                                    if (typeof keyVal === 'undefined'){
                                        keyVal = ''
                                    }
                                    if (keyVal.indexOf('hisui-switchbox') < 0){
                                        keyVal = PHA_EXPORT.stripHtml(keyVal);
                                    }else{
                                        keyVal = item[key];
                                    }
                                }
                                var keyPosition = (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1);
                                if (PHA_EXPORT.RegNotNumber.test(keyVal)){
                                    notNumberArr.push(keyPosition.replace(/[0-9]/g, ''));
                                }
                                keyVal = keyVal === ' ' ? '' : keyVal; 
                                return {
                                    value: keyVal,
                                    position: keyPosition,
                                };
                            }
                        } else {
                            /*return Object.assign({}, {
                                value: item[key],
                                position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
                            });*/
                            var keyVal = item[key];
                            if (colsForm[key]) {
                                keyVal = colsForm[key](item[key], item, rowIndex);
                                keyVal = PHA_EXPORT.stripHtml(keyVal);
                            }
                            var keyPosition = (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1);
                            return {
                                value: keyVal,
                                position: keyPosition,
                            };
                        }
    
                    });
                }).reduce(function (prev, next) {
                    return prev.concat(next);
                });
                sheetsData.forEach(function (item, index) {
                    if (item) {
                        var itemPosition = item.position;
                        var cellVal=item.value||""; 
                        if (cellVal!=""){
                            cellVal=cellVal.toString();
                            cellVal=cellVal.replace(/<\/br>/g,String.fromCharCode(10));
                        }
                        var colPosition = itemPosition.replace(/[0-9]/g, '');
                        var numberFlag = (isNaN(cellVal) === false && notNumberArr.indexOf(colPosition) < 0) ? true : false;
                        var numberFmt = 'General';
                        if(numberFlag === true){
                            if (cellVal.length >12){
                                if (cellVal.indexOf(".")<0){
                                    numberFmt = '0';
                                }else{
                                    numberFmt = '0.' + cellVal.split('.')[1].replace(/[0-9]/g, "0");
                                }
                            }
                        }
                        content[itemPosition] = {
                            v: cellVal,
                            z: numberFlag ? numberFmt : '@',
                            t: numberFlag ? 'n' : 's'
                        };
                    }
                });
    
                // 设置区域,比如表格从A1到D10,SheetNames:标题
                var coordinate = Object.keys(content);
                var CellsZone = {
                    "!ref": coordinate[0] + ":" + coordinate[coordinate.length - 1]
                };

                var workBook = {
                    SheetNames: ["Sheet1"],
                    SSF:false,
                    Sheets: {
                        "Sheet1": extend(content, CellsZone) // Object.assign({}, content, { "!ref": coordinate[0] + ":" + coordinate[coordinate.length - 1] })
                    }
                };
                // 这里的数据是用来定义导出的格式类型
                var excelData = XLSX.write(workBook, {
                    bookType: "xlsx",
                    bookSST: false,
                    type: "binary" //,
                    // ignoreEC:false
                });
                // const wopts = { bookType: 'csv', bookSST: false, type: 'binary' }; //ods格式
                // const wopts = { bookType: 'ods', bookSST: false, type: 'binary' }; //ods格式
                // const wopts = { bookType: 'xlsb', bookSST: false, type: 'binary' }; //xlsb格式
                // const wopts = { bookType: 'fods', bookSST: false, type: 'binary' }; //fods格式
                // const wopts = { bookType: 'biff2', bookSST: false, type: 'binary' }; //xls格式
        
                var blob = new Blob([string2ArrayBuffer(excelData)], {
                    type:"application/octet-stream" // type: "application/vnd.ms-excel"
                });
                saveAs(blob, fileName); // scripts/filehandingutiljs/FileSaver.min.js
            } catch (e) {
                alert('export.js ' + e.message);
            }
            
            // 字符串转字符流
            function string2ArrayBuffer(s) {
                var buf = new ArrayBuffer(s.length);
                var view = new Uint8Array(buf);
                for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
                return buf;
            }
    
            // 将指定的自然数转换为26进制表示。映射关系：[0-25] -> [A-Z]。
            function getCharCol(n) {
                var temCol = "";
                var s = "";
                var m = 0;
                while (n > 0) {
                    m = n % 26 + 1
                    s = String.fromCharCode(m + 64) + s
                    n = (n - m) / 26
                }
                return s
            }
    
            // 合并对象,原方法中IE不支持Object.assign()方法合并对象
            function extend(target, source) {
                for (var obj in source) {
                    target[obj] = source[obj];
                }
                return target;
            }
        }
    },
    
    /**
     * 导出txt文件
     * Huxt 2020-07-28
     * @param {Object} title 表格标题{"code":"代码","desc":"名称"}
     * @param {Array}  data 表格数据[{"code":"AA","desc":"AAA"},{"code":"DA","desc":"DADA"}]
     * @param {String} fileName 文件名,默认空时按时间点生成
     */
    TXT: function (title, data, fileName) {
        // 标题行
        var txtStr = "";
        var titleStr = "";
        if (typeof title == "object") {
            for (var tk in title) {
                titleStr = titleStr == "" ? title[tk] : titleStr + String.fromCharCode(9) + title[tk];
            }
        } else if(typeof title == "string") {
            titleStr = title;
        }
        if (titleStr != "") {
            txtStr = titleStr
        }
        // 数据
        var isTitleObj = typeof title == "object" ? true : false;
        var dataStr = "";
        if (typeof data == "object") {
            var dRows = data.length;
            for (var r = 0; r < dRows; r++) {
                var oneRowData = data[r];
                var oneRowStr = "";
                for (var c in oneRowData) {
                    if (isTitleObj) {
                        if (c in title) {
                            oneRowStr = oneRowStr == "" ? oneRowData[c] : oneRowStr + String.fromCharCode(9) + oneRowData[c];
                        }
                    } else {
                        oneRowStr = oneRowStr == "" ? oneRowData[c] : oneRowStr + String.fromCharCode(9) + oneRowData[c];
                    }
                }
                dataStr = dataStr == "" ? oneRowStr : dataStr + '\r\n' + oneRowStr;
            }
        } else {
            dataStr = data;
        }
        if (txtStr == "") {
            txtStr = dataStr;
        } else {
            txtStr += '\r\n' + dataStr;
        }
        // 执行导出
        var jsArr = [
            "/imedical/web/scripts/pha/plugins/export-excel/FileSaver.js", 
            "/imedical/web/scripts/pha/plugins/export-excel/Blob.js"
        ];
        PHA_EXPORT.LoadJS(jsArr, function(){
            var blob = new Blob([txtStr], {type: "text/plain;charset=utf-8"});
            saveAs(blob, fileName);
        });
    },
    /**
     * 导出图片文件
     * Huxt 2020-07-28
     * @param {Object} title 不用传
     * @param {Array}  data 为base64字符串
     * @param {String} fileName 文件名, 默认空时按时间点生成
     */
    IMAGE: function (title, data, fileName) {
        // 取文件前后缀
        var fileNameArr = fileName.split('.');
        var fileNamePrefix = '';
        for (var f = 0; f < fileNameArr.length - 1; f++) {
            fileNamePrefix = fileNamePrefix == '' ? fileNameArr[f] : fileNamePrefix + '.' + fileNameArr[f];
        }
        var fileNameSuffix = fileNameArr[fileNameArr.length - 1];
        
        // 定义导出方法 (IE & Chrome)
        function _IEExportImg(base64Str) {
            var myObj = null;
            try {
                myObj = new ActiveXObject("Base64IMGSave.ClsSaveBase64IMG");
                var sReigstNo = fileNamePrefix;
                var sFiletype = fileNameSuffix;
                var rtn = myObj.WriteFile(sReigstNo, base64Str, sFiletype);
                if (!rtn) {
                    return false;
                }
                return true;
            } catch(err) {
                alert(err);
                return false;
            }
        }
        function _OthersExportImg(base64Str) {
            var img = "data:image/png;base64," + base64Str;
            var aLink = document.createElement('a');
            aLink.href = img;
            aLink.download = fileName;
            aLink.click();
            document.body.removeChild(aLink);
        }
        
        // 执行导出方法
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
            _IEExportImg(data);
        } else {
            _OthersExportImg(data);
        }
    },
    // 生成文件名称,防止重复
    GetFileName: function(fileName){
        var fileNameArr = fileName.split(".");
        var fileNamePrefix = '';
        for (var f = 0; f < fileNameArr.length - 1; f++) {
            fileNamePrefix = fileNamePrefix == '' ? fileNameArr[f] : fileNamePrefix + '.' + fileNameArr[f];
        }
        var fileNameSuffix = fileNameArr[fileNameArr.length - 1];
        var today = new Date();
        var month = today.getMonth() + 1;
        month = month < 10 ? '0'+month : month;
        var year = today.getFullYear();
        var day = today.getDate() < 10 ? '0'+today.getDate() : today.getDate();
        var hours = today.getHours() < 10 ? '0'+today.getHours() : today.getHours();
        var mins = today.getMinutes() < 10 ? '0'+today.getMinutes() : today.getMinutes();
        var secs = today.getSeconds() < 10 ? '0'+today.getSeconds() : today.getSeconds();
        return fileNamePrefix + '_' + (year + month + day + hours + mins + secs) + '.' + fileNameSuffix;
    },
    
    // 动态加载JS，已存在不会加载
    LoadJS: function (srcArr, callBack) {
        var loadCnt = srcArr.length;
        var loadI = 0;
        Create();

        function Create() {
            if (loadI >= loadCnt) {
                callBack(loadI);
                return;
            }
            var src = srcArr[loadI];
            if (IsExist(src) == true) {
                loadI++;
                Create();
            } else {
                var head = document.getElementsByTagName('head')[0];
                var script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = src;
                script.charset="utf-8"
                head.appendChild(script);
                script.onload = function () {
                    loadI++;
                    Create();
                }
            }
        }

        function IsExist(src) {
            var scriptArr = document.getElementsByTagName('script');
            for (var i = 0; i < scriptArr.length; i++) {
                var tmpSrc=src.replace("/imedical/web/","")
                if ((scriptArr[i].src).indexOf(tmpSrc.replace("../", "")) >= 0) {
                    return true;
                }
            }
            return false;
        }
    },
    
    // 去掉字符串中的html标签
    stripHtml : function(v) {
        v = String(v);
        var regexp = /<("[^"]*"|'[^']*'|[^'">])*>/gi;
        if (v) {
            v = v.replace(regexp,"");
            return (v && v !== '&nbsp;' && v !== '&#160;') ? v.replace(/\"/g,"'") : "";
        }
        return v;
    }
}