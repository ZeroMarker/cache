/**
 * Excel����  DHCPEExcelTool.js
 * @Author   wangguoying
 * @DateTime 2020-03-25
 */

/** HIS8.4�汾��ȫ�ֺ����ж��Ƿ�ΪIE�����   �����Լ�������Ϊ�˼��� 8.3֮ǰ�İ汾  */
var $PEExcel = {
    isIE : window.ActiveXObject || "ActiveXObject" in window //IE�����
}



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
 * [��������]
 * @param    {[object]}    blob     [blob����]
 * @param    {[string]}    saveName [���ص��ļ���]
 * @Author   wangguoying
 * @DateTime 2020-11-12
 */
function download_excel(blob, saveName)
{
    if ($PEExcel.isIE) {
        window.navigator.msSaveOrOpenBlob(blob, saveName);
    }else{
        var url = URL.createObjectURL(blob); // ����blob��ַ
        var aLink = document.createElement('a');
        aLink.href = url;
        aLink.download = saveName || ''; // HTML5���������ԣ�ָ�������ļ��������Բ�Ҫ��׺��ע�⣬file:///ģʽ�²�����Ч
        var event = new MouseEvent('click');
        aLink.dispatchEvent(event);
    }  
}


/**
 * [sheetתblob]
 * @param    {[object]}    sheet     [sheet]
 * @param    {[String]}    sheetName [sheet����]
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
    // ����excel��������
    var wopts = {
        bookType: 'xlsx', // Ҫ���ɵ��ļ�����
        bookSST: false, // �Ƿ�����Shared String Table���ٷ������ǣ�������������ٶȻ��½������ڵͰ汾IOS�豸���и��õļ�����
        type: 'binary'
    };
    var wbout = XLSX.write(workbook, wopts);
    var blob = new Blob([s2ab(wbout)], {type:"application/octet-stream"});
    // �ַ���תArrayBuffer
    function s2ab(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i=0; i!=s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }
    return blob;
}


/**
 * [workbookתblob]
 * @param    {[Obejct]}    sheet     [workbook����]
 * @Author   wangguoying
 * @DateTime 2021-12-15
 */
 function workbook2blob(workbook) {
    
    // ����excel��������
    var wopts = {
        bookType: 'xlsx', // Ҫ���ɵ��ļ�����
        bookSST: false, // �Ƿ�����Shared String Table���ٷ������ǣ�������������ٶȻ��½������ڵͰ汾IOS�豸���и��õļ�����
        type: 'binary',
        showGridLines: true
    };
    var wbout = XLSX.write(workbook, wopts);
    var blob = new Blob([s2ab(wbout)], {type:"application/octet-stream"});
    // �ַ���תArrayBuffer
    function s2ab(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i=0; i!=s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }
    return blob;
}