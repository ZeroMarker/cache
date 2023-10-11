/**
 * Excel处理  DHCPEExcelTool.js
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */

/** HIS8.4版本有全局函数判断是否为IE浏览器   这里自己定义是为了兼容 8.3之前的版本  */
var $PEExcel = {
    isIE : window.ActiveXObject || "ActiveXObject" in window //IE浏览器
}



/**
 * [转二进制]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function fixdata(data) {
    var o = "",
        l = 0,
        w = 10240;
    for(; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
    o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
    return o;
}
/**
 * [读取excel指定sheet的数据，返回Json数组]
 * @param    {[File]}        file       [文件]
 * @param    {[int]}        sheetIndex  [sheet索引，从0开始]
 * @param    {[function]}    callback   [回调函数，参数为读取的excel数组]
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */
function getExcelJsonArr(file,sheetIndex,callback){
    var reader = new FileReader();
    reader.onload = function(e) {
        var data = e.target.result;
        var wb="";
        if($PEExcel.isIE) {
            wb = XLSX.read(btoa(fixdata(data)),{
                type: 'base64'
            });
        } else {
            wb = XLSX.read(data,{
                type: 'binary'
            });
        }
        var excelArr= XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[sheetIndex]]) ;
        callback(excelArr);
      
       
    };
    if($PEExcel.isIE) {
        reader.readAsArrayBuffer(file);
    } else {
        reader.readAsBinaryString(file);
    }
}


/**
 * [数据下载]
 * @param    {[object]}    blob     [blob对象]
 * @param    {[string]}    saveName [下载的文件名]
 * @Author   wangguoying
 * @DateTime 2020-11-12
 */
function download_excel(blob, saveName)
{
    if ($PEExcel.isIE) {
        window.navigator.msSaveOrOpenBlob(blob, saveName);
    }else{
        var url = URL.createObjectURL(blob); // 创建blob地址
        var aLink = document.createElement('a');
        aLink.href = url;
        aLink.download = saveName || ''; // HTML5新增的属性，指定保存文件名，可以不要后缀，注意，file:///模式下不会生效
        var event = new MouseEvent('click');
        aLink.dispatchEvent(event);
    }  
}


/**
 * [sheet转blob]
 * @param    {[object]}    sheet     [sheet]
 * @param    {[String]}    sheetName [sheet名称]
 * @Author   wangguoying
 * @DateTime 2020-11-12
 */
function sheet2blob(sheet, sheetName) {
    sheetName = sheetName || 'sheet1';
    var workbook = {
        SheetNames: [sheetName],
        Sheets: {}
    };
    workbook.Sheets[sheetName] = sheet;
    // 生成excel的配置项
    var wopts = {
        bookType: 'xlsx', // 要生成的文件类型
        bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
        type: 'binary'
    };
    var wbout = XLSX.write(workbook, wopts);
    var blob = new Blob([s2ab(wbout)], {type:"application/octet-stream"});
    // 字符串转ArrayBuffer
    function s2ab(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i=0; i!=s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }
    return blob;
}


/**
 * [workbook转blob]
 * @param    {[Obejct]}    sheet     [workbook对象]
 * @Author   wangguoying
 * @DateTime 2021-12-15
 */
 function workbook2blob(workbook) {
    
    // 生成excel的配置项
    var wopts = {
        bookType: 'xlsx', // 要生成的文件类型
        bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
        type: 'binary',
        showGridLines: true
    };
    var wbout = XLSX.write(workbook, wopts);
    var blob = new Blob([s2ab(wbout)], {type:"application/octet-stream"});
    // 字符串转ArrayBuffer
    function s2ab(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i=0; i!=s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }
    return blob;
}