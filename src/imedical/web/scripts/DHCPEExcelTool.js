/**
 * Excel处理  DHCPEExcelTool.js
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */


var isIE = window.ActiveXObject || "ActiveXObject" in window; //IE浏览器


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
        if(isIE) {
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
    if(isIE) {
        reader.readAsArrayBuffer(file);
    } else {
        reader.readAsBinaryString(file);
    }
}
