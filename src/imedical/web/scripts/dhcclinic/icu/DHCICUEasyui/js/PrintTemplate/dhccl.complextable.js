/**
 * 表格区域�?
 * @param {*} opts 
 */

function ComplexTable(table) {
    
    this.table = table;
    this.displayRect = table.DisplayRect;
    this.rows = table.Rows;
    this.cols = table.Cols;
    this.cells = table.Cells;
    this.init();
}

ComplexTable.prototype = {
    constructor: ComplexTable,

    init: function () {
        
    },

    getTotalWidth: function(){
        var totalColWidth = 0;
        for(var i = 0; i < this.cols.length; i++){
            totalColWidth = totalColWidth + this.cols[i].ColWidth;
        }
        return totalColWidth;
    },

    getTotalHeight: function(){
        var totalRowHeight = 0;
        for(var i = 0; i < this.rows.length; i++){
            totalRowHeight = totalRowHeight + this.rows[i].RowHeight;
        }
    },

    getCellRectByIndex: function(fromRowIndex, toRowIndex, fromColIndex, toColIndex){
        var cellLeft = 0, cellTop = 0;
        var cellWidth = 0, cellHeight = 0;

        for(var i = 0; i < this.rows.length; i++){
            var realRowHeight = this.rows[i].RowHeight;
            if(i < fromRowIndex - 1){
                cellTop = cellTop + realRowHeight;
            }
            if(i >= fromRowIndex - 1 && i < toRowIndex){
                cellHeight = cellHeight + realRowHeight;
            }
        }
        for(var j = 0; j < this.cols.length; j++){
            var realRowWidht = this.cols[j].ColWidth;
            if(j < fromColIndex - 1){
                cellLeft = cellLeft + realRowWidht;
            }
            if(j >= fromColIndex - 1 && j < toColIndex){
                cellWidth = cellWidth + realRowWidht;
            }
        }

        return {
            left: complexTable.DisplayRect.left + cellLeft,
            top: complexTable.DisplayRect.top + cellTop,
            width: cellWidth,
            height: cellHeight
        }
    },

    
}

