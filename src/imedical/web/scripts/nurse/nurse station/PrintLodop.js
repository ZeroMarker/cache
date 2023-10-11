/*
 * @Author: SongChao
 * @Date: 2019-11-13 09:55:34
 * @LastEditTime: 2019-11-13 20:27:46
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \nurse-vue\static\PrintLodop.js
 */
(function () {

    function printNeedMeasurePats(runServerMethod, EpisodeIDs, DateStr, Time, Codes) {
        var LODOP = getLodop();
        runServerMethod("Nur.CommonInterface.Temperature", "GetPrintPats", EpisodeIDs, DateStr, Time, Codes).then(function (tableStr) {
            LODOP.PRINT_INIT("打印待测患者列表");
            LODOP.SET_PRINT_PAGESIZE(0, 0, 0, "A4");
            //LODOP.ADD_PRINT_TABLE("2%", "1%", "96%", "98%", tableStr);
            LODOP.ADD_PRINT_TABLE("30mm", "10mm", "185mm", "230mm", tableStr);
            LODOP.ADD_PRINT_TEXT("10mm", 277, 154, 32, "待测患者列表\n");
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
            LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
            LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
            LODOP.ADD_PRINT_TEXT("20mm", "10mm", 100, 25, "待测日期:");
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
            LODOP.ADD_PRINT_TEXT("20mm", "25mm", 100, 25, DateStr);
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
            LODOP.ADD_PRINT_TEXT("20mm", "50mm", 100, 25, "待测时间:");
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
            LODOP.ADD_PRINT_TEXT("20mm", "66mm", 74, 25, Time);
            LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
            LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
            //LODOP.SET_PREVIEW_WINDOW(0, 0, 0, 800, 600, "");
            // LODOP.PRINT_DESIGN();
            LODOP.PREVIEW();
        })
    }

    var PrintLodop = {
        printNeedMeasurePats: printNeedMeasurePats
    };
    window.PrintLodop = PrintLodop;
})()