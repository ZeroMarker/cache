(function(global,factory){
    if(!global.excelmgr) factory(global.excelmgr={});
}(this,function(excel){
    excel.sheet2blob=function(sheet,sheetName){
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
    };

    /**
     * 通用的打开下载对话框方法，没有测试过具体兼容性
     * @param url 下载地址，也可以是一个blob对象，必选
     * @param saveName 保存文件名，可选
     */
    excel.openDownloadDialog=function(url,saveName){
        var explorer = window.navigator.userAgent;
        if(explorer.indexOf('Trident')<0)
        {
            // 非IE浏览器
            if(typeof url == 'object' && url instanceof Blob)
            {
                url = URL.createObjectURL(url); // 创建blob地址
            }
            var aLink = document.createElement('a');
            aLink.href = url;
            aLink.download = saveName || ''; // HTML5新增的属性，指定保存文件名，可以不要后缀，注意，file:///模式下不会生效
            aLink.click(); //模拟点击实现下载
            setTimeout(function () { //延时释放
                URL.revokeObjectURL(url); //用URL.revokeObjectURL()来释放这个object URL
            }, 100);
            // var event;
            // if(window.MouseEvent) event = new MouseEvent('click');
            // else
            // {
            //     event = document.createEvent('MouseEvents');
            //     event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            // }
            // aLink.dispatchEvent(event);

        }else{
            // IE浏览器
            navigator.msSaveBlob(url, saveName);
        }
        


    };

    excel.aoa2excel=function(aoa,saveName){
        var _excel=this;
        var sheet= XLSX.utils.aoa_to_sheet(aoa);
        _excel.openDownloadDialog(_excel.sheet2blob(sheet),saveName);
    };

    excel.table2excel=function(table,saveName){
        var _excel=this;
        var sheet= XLSX.utils.table_to_sheet(table);
        _excel.openDownloadDialog(_excel.sheet2blob(sheet),saveName);
    };

    
}));