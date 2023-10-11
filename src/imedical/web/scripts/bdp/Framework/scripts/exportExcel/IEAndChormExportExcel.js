document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/exportExcel/xlsx.core.min.js"></script>')
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/exportExcel/exportExcel.js"></script>')

function exportExcelForIEAndChorm(arr,excelName) {
    //判断浏览器类型
    var ua = window.navigator.userAgent;
    if (ua.indexOf('Safari') > -1) {
        exportExcel(arr,excelName);
    } else { 
        try {        
            //添加一个新excel
            var xlApp = new ActiveXObject("Excel.Application");
			var xlBook = xlApp.Workbooks.Add();///默认三个sheet
        }
        catch (e) {
            var emsg = "请在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
            alert(emsg);
            return;
        }
        //新表
        xlBook.worksheets(1).select();
        var xlsheet = xlBook.ActiveSheet;
        for (var i = 0; i < arr.length; i++) { 
            for (var j = 0; j < arr[i].length; j++) {
                xlsheet.Cells(i+1, j+1).value = arr[i][j]
            }
        }

        xlApp.Visible = true;
        xlBook.Close(savechanges = true);
        xlApp = null;
        xlsheet = null;

        
    }
    return 1
}