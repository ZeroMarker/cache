/**
 * Excel����  DHCPEExcelTool.js
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */


var isIE = window.ActiveXObject || "ActiveXObject" in window; //IE�����


/**
 * [ת������]
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
 * [��ȡexcelָ��sheet�����ݣ�����Json����]
 * @param    {[File]}        file       [�ļ�]
 * @param    {[int]}        sheetIndex  [sheet��������0��ʼ]
 * @param    {[function]}    callback   [�ص�����������Ϊ��ȡ��excel����]
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
