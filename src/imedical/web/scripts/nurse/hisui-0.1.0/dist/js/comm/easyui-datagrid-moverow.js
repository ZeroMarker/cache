/**
 * @description: 单元格方向键事件
 * @param {*} i
 * @param {*} f
 */
function OnHisuiCellEditDirectHandler(tableID, i, f, dir) {
    var currentIndex = window.HisuiEditors[tableID].editElements.indexOf("edit" + tableID + "_" + f);
    var rows = $('#' + tableID).datagrid('getRows').length;
    if (currentIndex == -1)
    	return;
    if ((dir == "right") && (currentIndex == window.HisuiEditors[tableID].editElements.length - 1))
        currentIndex = -1;
    if ((dir == "left") && (currentIndex == 0))
        currentIndex = window.HisuiEditors[tableID].editElements.length;
    if ((dir == "down") && (i == rows - 1))
        i = -1;
    if ((dir == "up") && (i == 0))
        i = rows;
    do {
        if (dir == "right")
        	currentIndex = currentIndex + 1;
        if (dir == "left")
        	currentIndex = currentIndex - 1;
        if (dir == "down")
        	i = i + 1;
        if (dir == "up")
        	i = i - 1;
        var nextField = GetTableFieldByIndentity(window.HisuiEditors[tableID].editElements[currentIndex]);
        var key = i + nextField;
        var findNoEditIndex = window.HisuiEditors[tableID].NoEdit.indexOf(key);
        if (findNoEditIndex == -1) {
            var target = $("#" + tableID);
            var panel = $(target).datagrid('getPanel');
            panel.find('td.datagrid-row-selected').removeClass('datagrid-row-selected');
            setTimeout(function () {
                $('#' + tableID).datagrid('gotoCell', {
                    index: i,
                    field: nextField
                });
                $('#' + tableID).datagrid('editCell', {
                    index: i,
                    field: nextField
                });
            }, 0);
            break;
        }
    } while (currentIndex < window.HisuiEditors[tableID].editElements.length - 1);
}
