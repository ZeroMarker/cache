/**
 * 表格区域类
 * @param {*} opts 
 */

function ComplexTableView(opt) {
    this.DisplayRect = opt.complexTable.DisplayRect;
    this.Rows = opt.complexTable.TableInfo.Rows;
    this.Cols = opt.complexTable.TableInfo.Cols;
    this.Cells = opt.complexTable.TableInfo.Cells;
    this.tableStyle = opt.tableStyle;

    this.onSave = opt.onSave;

    this.dialogWidth = 1080;
    this.dialogHeight = 700;
    this.marginTop = 10;
    this.marginLeft = 10;

    this.totalRowHeight = 0;
    this.totalColWidth = 0;

    this.currentClickCells = null;
    this.latestMouseDownLocation = null;
    this.latestMouseUpLocation = null;

    this.itemMenus = null;

    this.initForm();
}

ComplexTableView.prototype = {
    initForm: function () {
        var $this = this;

        this.dom = $('<div></div>').appendTo('body');
        var buttons = $('<div></div>');
        this.saveBtn = $('<a href="#"></a>').linkbutton({
            text: '保存',
            iconCls: 'icon-save',
            onClick: function () {
                var tableInfo = {
                    Rows: $this.Rows,
                    Cols: $this.Cols,
                    Cells: $this.Cells
                };
                $this.onSave(tableInfo)
                $this.close();
            }
        }).appendTo(buttons);

        this.closeBtn = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function () {
                $this.close();
            }
        }).appendTo(buttons);
        
        this.initCanvas();

        this.dom.dialog({
            height: this.dialogHeight,
            width: this.dialogWidth,
            title: '复杂表格编辑',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function () {
                
            },
            onClose: function () {
                $this.clear();
            }
        });
    },

    initCanvas: function () {
        var $this = this;
        this.canvasContainer = $('<div style="width:805px;height:1144px;padding:10px;background-color:gray;float:left;"></div>').appendTo(this.dom);
        this.propertyContainer = $('<div style="width:200px;height:1144px;padding:10px;border:1px solid #ccc;float:left;"></div>').appendTo(this.dom);
        $('<canvas id="table-canvas" width="795px" height="1124px" style="border: 1px solid #ccc;background-color:white;"></canvas>').appendTo(this.canvasContainer);
        this.canvas = document.getElementById("table-canvas");
        this.drawContext = this.canvas.getContext("2d");
        HIDPI();

        this.initTableProperty();
        this.drawTable();

        $(this.canvas).tooltip({ content: "", trackMouse: true, showDelay: 0, hideDelay: 0 });

        $(this.canvas).mousedown(canvasMouseDown);
        $(this.canvas).mouseup(canvasMouseUp);
        $(this.canvas).mousemove(canvasMouseMove);
        $(this.canvas).bind("contextmenu", canvasContextMenu);

        function canvasMouseDown(e){
            e.preventDefault();
            
            var canvasLoc = getCanvasLocation($this.canvas, e);
            if(e.which == 1) {  //左键
                $this.setCurrentClickCells(canvasLoc, null);
                $this.latestMouseDownLocation = canvasLoc;
            }
        }

        function canvasMouseUp(e){
            e.preventDefault();

            var canvasLoc = getCanvasLocation($this.canvas, e);
            if(e.which == 1) {  //左键
                this.latestMouseUpLocation = canvasLoc;
            }
        }

        function canvasMouseMove(e){
            e.preventDefault();
            var canvasLoc = getCanvasLocation($this.canvas, e);
            var mousePointInfo = "x: " + Math.round(canvasLoc.x) + ",  y: " + Math.round(canvasLoc.y);
            $($this.canvas).tooltip("update", mousePointInfo);
            $($this.canvas).tooltip("show");

            if(e.which == 1){  //左键
                $this.setCurrentClickCells($this.latestMouseDownLocation, canvasLoc);
            }
        }

        function canvasContextMenu(e){
            e.preventDefault();
            
            //右键
            if (this.itemMenus) this.itemMenus.menu("destroy");

            this.menuList = [{
                text: "合并单元格",
                onMenuClick: function(e){
                    $this.mergeSelectedCells();
                }
            },{
                text: "删除当前行",
                onMenuClick: function(e){
                    if($this.currentClickCells && $this.currentClickCells.length && $this.currentClickCells.length == 1){
                        var cell = $this.currentClickCells[0];
                        $this.removeRow(cell.RowIndex);
                    }
                }
            },{
                text: "添加一行",
                onMenuClick: function(e){
                    $this.appendRow();
                }
            },{
                text: "删除当前列",
                onMenuClick: function(e){
                    if($this.currentClickCells && $this.currentClickCells.length && $this.currentClickCells.length == 1){
                        var cell = $this.currentClickCells[0];
                        $this.removeCol(cell.ColIndex);
                    }
                }
            },{
                text: "添加一列",
                onMenuClick: function(e){
                    $this.appendCol();
                }
            }];
            var menuDiv = $('<div id="tableMenu" class="hisui-menu" style="width:140px;"></div>').appendTo('body');
            this.itemMenus = menuDiv.menu({});

            for(var i = 0; i < this.menuList.length; i++){
                this.itemMenus.menu("appendItem", {
                    text: this.menuList[i].text,
                    onclick: this.menuList[i].onMenuClick
                });
            }

            this.itemMenus.menu("show", {
                left: e.pageX,
                top: e.pageY
            });
        }

        function getCanvasLocation(canvas, e) {
            var box = canvas.getBoundingClientRect();
            return {
                x: e.clientX - box.left,
                y: e.clientY - box.top
            };
        }
    },

    open: function () {
        this.dom.dialog('open');
    },

    close: function () {
        this.dom.dialog('close');
    },

    clear: function () {
        $(this.canvasContainer).remove();
        this.dom.dialog('destroy');
    },

    save: function(){

    },

    initTableProperty: function(){
        var $this = this;
        this.tableRow = $('<table></table>').appendTo(this.propertyContainer);
        this.tableRow.datagrid({
            width:190,
            height: 300,
            singleSelect: true,
            headerCls:'panel-header-gray',
            fitColumns: true,
            title: "行",
            columns:[[
                {field:'RowIndex',title:'行号'},
                {field:'RowHeight',title:'行高', width: 120, editor:'numberbox'}
            ]],
            data: $this.Rows,
            onAfterEdit: function(rowIndex, rowData, changes){
                if(changes.RowHeight){
                    $this.Rows[rowIndex].RowHeight = parseInt(changes.RowHeight);
                    $this.refreshTableProperty();
                    $this.drawTable();
                }
            },
            toolbar: [{
                    iconCls: 'icon-add',
                    text: "增加行",
                    handler: function(){
                        $this.appendRow();
                    }
                },'-',{
                    iconCls: 'icon-remove',
                    text: "删除行",
                    handler: function(){
                        var selectedRow = $this.tableRow.datagrid("getSelected");
                        if (selectedRow){
                            var rowIndex = selectedRow.RowIndex;
                            $this.removeRow(rowIndex);
                        }else{
                            $.messager.alert("提示","请选择要删除的一行");
                        }
                    }
            }]
        }).datagrid("enableCellEditing");

        this.tableColumn = $('<table></table>').appendTo(this.propertyContainer);
        this.tableColumn.datagrid({
            width:190,
            height: 300,
            singleSelect: true,
            headerCls:'panel-header-gray',
            fitColumns: true,
            title: "列",
            columns:[[
                {field:'ColIndex',title:'列号'},
                {field:'ColWidth',title:'列宽', width: 120, editor:'numberbox'}
            ]],
            data: $this.Cols,
            onAfterEdit: function(rowIndex, rowData, changes){
                if(changes.ColWidth){
                    $this.Cols[rowIndex].ColWidth = parseInt(changes.ColWidth);
                    $this.refreshTableProperty();
                    $this.drawTable();
                }
            },
            toolbar: [{
                    iconCls: 'icon-add',
                    text: "增加列",
                    handler: function(){
                        $this.appendCol();
                    }
                },'-',{
                    iconCls: 'icon-remove',
                    text: "删除列",
                    handler: function(){
                        var selectedRow = $this.tableColumn.datagrid("getSelected");
                        if (selectedRow){
                            var colIndex = selectedRow.ColIndex;
                            $this.removeCol(colIndex);
                        }else{
                            $.messager.alert("提示","请选择要删除的一列");
                        }
                    }
            }]
        }).datagrid("enableCellEditing");
    },

    setDrawContext: function(drawContext){
        this.drawContext = drawContext;
    },

    setTableStyle: function(tableStyle){
        this.tableStyle = tableStyle;
    },

    refreshTableProperty: function(){
        this.tableRow.datagrid("loadData", this.Rows);
        this.tableColumn.datagrid("loadData", this.Cols);
    },

    appendRow: function(){
        var rowIndex = this.Rows.length + 1;
        this.Rows.push({RowIndex: rowIndex, RowHeight: 30})

        var columnCount = this.Cols.length + 1;
        for(var i = 1; i <= columnCount; i++){
            var colIndex = i;
            this.Cells.push({
                RowIndex: rowIndex,
                ColIndex: colIndex, 
                IsMergeCells: false, 
                FromRowIndex: rowIndex, 
                ToRowIndex: rowIndex, 
                FromColIndex: colIndex, 
                ToColIndex: colIndex, 
                Content: "", 
                Style: "",
                AreaItems: []
            });
        }
        this.refreshTableProperty();
        this.drawTable();
    },

    removeRow: function(rowIndex){
        if(this.Rows.length == 1){
            $.messager.alert("提示","最后一行不能删除!");
            return;
        }

        this.Rows.splice(rowIndex - 1, 1);
        for(var i = 0; i < this.Rows.length; i++){
            this.Rows[i].RowIndex = i + 1;
        }

        var targetCells = this.Cells.filter(function(cell){
            return !(cell.FromRowIndex == rowIndex && cell.ToRowIndex == rowIndex);
        });

        this.Cells = targetCells;
        for(var k = 0; k < this.Cells.length; k++){
            var cell = this.Cells[k];
            if(cell.FromRowIndex >= rowIndex){
                cell.FromRowIndex = cell.FromRowIndex - 1;
                cell.RowIndex = cell.FromRowIndex;
            }
            if(cell.ToRowIndex >= rowIndex){
                cell.ToRowIndex = cell.ToRowIndex - 1;
            }
        }

        this.refreshTableProperty();
        this.drawTable();
    },

    appendCol: function(){
        var colIndex = this.Cols.length + 1;
        this.Cols.push({ColIndex: colIndex, ColWidth: 100});

        var rowCount = this.Rows.length + 1;
        for(var i = 1; i <= rowCount; i++){
            var rowIndex = i;
            this.Cells.push({
                RowIndex: rowIndex,
                ColIndex: colIndex, 
                IsMergeCells: false, 
                FromRowIndex: rowIndex, 
                ToRowIndex: rowIndex, 
                FromColIndex: colIndex, 
                ToColIndex: colIndex, 
                Content: "", 
                Style: "",
                AreaItems: []
            });
        }

        this.refreshTableProperty();
        this.drawTable();
    },

    removeCol: function(colIndex){
        if(this.Cols.length == 1){
            $.messager.alert("提示","最后一列不能删除!");
            return;
        }

        this.Cols.splice(colIndex - 1, 1);
        for(var i = 0; i < this.Cols.length; i++){
            this.Cols[i].ColIndex = i + 1;
        }

        var targetCells = this.Cells.filter(function(cell){
            return !(cell.FromColIndex == colIndex && cell.ToColIndex == colIndex);
        });

        this.Cells = targetCells;
        for(var k = 0; k < this.Cells.length; k++){
            var cell = this.Cells[k];
            if(cell.FromColIndex >= colIndex){
                cell.FromColIndex = cell.FromColIndex - 1;
                cell.ColIndex = cell.FromColIndex;
            }
            if(cell.ToColIndex >= colIndex){
                cell.ToColIndex = cell.ToColIndex - 1;
            }
        }

        this.refreshTableProperty();
        this.drawTable();
    },

    drawTable: function(){
        this.drawContext.clearRect(0, 0, this.canvas.width, this.canvas.height);

        var borderColor = this.tableStyle.BorderStyle.LineColor;
        var strokeStyle = borderColor;

        var rect = {
            left: this.marginLeft,
            top: this.marginTop,
            width: this.DisplayRect.width,
            height: this.DisplayRect.width.height
        };

        this.totalRowHeight = 0;
        for (var i = 0; i < this.Rows.length; i++) {
            this.totalRowHeight += this.Rows[i].RowHeight;
        }

        this.totalColWidth = 0;
        for (var j = 0; j < this.Cols.length; j++) {
            this.totalColWidth += this.Cols[j].ColWidth;
        }

        //绘制表格外边框
        this.drawContext.drawRectangle(rect, borderColor);
        //绘制表格横线
        var lineTop = rect.top;
        for (var i = 0; i < this.Rows.length - 1; i++) {
            var realRowHeight = (this.Rows[i].RowHeight / this.totalRowHeight) * rect.height;
            lineTop = lineTop + realRowHeight;
            this.drawContext.drawLine({
                x: rect.left,
                y: lineTop
            }, {
                x: rect.left + rect.width,
                y: lineTop
            }, strokeStyle);
        }

        //绘制表格竖线
        var lineLeft = rect.left;
        for (var j = 0; j < this.Cols.length - 1; j++) {
            var realColWidth = (this.Cols[j].ColWidth / this.totalColWidth) * rect.width;
            lineLeft = lineLeft + realColWidth;
            this.drawContext.drawLine({
                x: lineLeft,
                y: rect.top
            }, {
                x: lineLeft,
                y: rect.top + rect.height
            }, strokeStyle);
        }

        //绘制表格内容
        for (var k = 0; k < this.Cells.length; k++) {
            var cell = this.Cells[k];
            var cellRect = this.getCellRect(cell);
            this.drawContext.fillRectangle(cellRect, "white");
            this.drawContext.drawRectangle(cellRect, borderColor);
        }
    },

    getCellRect:function(cell){
        var fromRowIndex = cell.RowIndex, toRowIndex = cell.RowIndex, fromColIndex = cell.ColIndex, toColIndex = cell.ColIndex;
        if (cell.IsMergeCells){
            fromRowIndex = cell.FromRowIndex, toRowIndex = cell.ToRowIndex, fromColIndex = cell.FromColIndex, toColIndex = cell.ToColIndex;
        }

        var cellLeft = 0, cellTop = 0, cellWidth = 0, cellHeight = 0;
        for (var i = 0; i < this.Rows.length; i++) {
            var realRowHeight = (this.Rows[i].RowHeight / this.totalRowHeight) * this.DisplayRect.height;
            if (i < fromRowIndex - 1) {
                cellTop = cellTop + realRowHeight;
            }
            if (i >= fromRowIndex - 1 && i < toRowIndex) {
                cellHeight = cellHeight + realRowHeight;
            }
        }
        for (var j = 0; j < this.Cols.length; j++) {
            var realRowWidth = (this.Cols[j].ColWidth / this.totalColWidth) * this.DisplayRect.width;
            if (j < fromColIndex - 1) {
                cellLeft = cellLeft + realRowWidth;
            }
            if (j >= fromColIndex - 1 && j < toColIndex) {
                cellWidth = cellWidth + realRowWidth;
            }
        }

        return {
            left: this.marginLeft + cellLeft,
            top: this.marginTop + cellTop,
            width: cellWidth,
            height: cellHeight
        }
    },

    getCellByLocation: function(location){
        var result = [];
        for (var k = 0; k < this.Cells.length; k++) {
            var cell = this.Cells[k];
            var rect = this.getCellRect(cell);
            if (this.ifRectContainPoint(rect, location)){
                result.push(cell);
                break;
            }
        }
        return result;
    },

    ifRectContainPoint: function(rect, point){
        var left = rect.left;
        var right = rect.left + rect.width;
        var top = rect.top;
        var bottom = rect.top + rect.height;
        if (point.x - left < 0 || point.x - right > 0) {
            return false;
        }
        if (point.y - top < 0 || point.y - bottom > 0) {
            return false;
        }
        return true;
    },

    ifRectContainRect: function(sourceRect, targetRect){
        var flag1 = sourceRect.left < targetRect.left;
        var flag2 = sourceRect.top < targetRect.top;
        var flag3 = sourceRect.width > targetRect.width;
        var flag4 = sourceRect.height > targetRect.height;

        return flag1&&flag2&&flag3&&flag4;
    },

    //判断两矩形是否相交
    judgeRectIntersect: function (sourceRect, targetRect) {
        var x1 = sourceRect.left,
            y1 = sourceRect.top,
            x2 = sourceRect.left + sourceRect.width,
            y2 = sourceRect.top + sourceRect.height;

        var x3 = targetRect.left,
            y3 = targetRect.top,
            x4 = targetRect.left + targetRect.width,
            y4 = targetRect.top + targetRect.height;

        var flag1 = Math.min(x1, x2) <= Math.max(x3, x4),
            flag2 = Math.min(y3, y4) <= Math.max(y1, y2),
            flag3 = Math.min(x3, x4) <= Math.max(x1, x2),
            flag4 = Math.min(y1, y2) <= Math.max(y3, y4);

        if (!( flag1 && flag2 && flag3 && flag4)){
            return false;
        }   

        var u = (x3 - x1) * (y2 - y1) - (x2 - x1) * (y3 - y1);
        var v = (x4 - x1) * (y2 - y1) - (x2 - x1) * (y4 - y1);
        var w = (x1 - x3) * (y4 - y3) - (x4 - x3) * (y1 - y3);
        var z = (x2 - x3) * (y4 - y3) - (x4 - x3) * (y2 - y3);
        return (u * v <= 0.00000001 && w * z <= 0.00000001);
    },

    // 绘制选中单元格
    drawSelectedCells: function () {
        if (this.currentClickCells && this.currentClickCells.length && this.currentClickCells.length > 0) {
            for(var i=0; i < this.currentClickCells.length; i++){
                var cell = this.currentClickCells[i];
                var rect = this.getCellRect(cell);
                if (rect) {
                    var borderColor = "green";
                    var lineDash = [5, 2];
                    var selectedBorderRect = {
                        left: rect.left + 3,
                        top: rect.top + 3,
                        width: rect.width - 6,
                        height: rect.height - 6
                    };
                    this.drawContext.drawRectangle(selectedBorderRect, borderColor, lineDash);
                }
            }
        }
    },

    getMultClickCell: function(startLocation, endLocation){
        var result = [];

        if(!startLocation){
            return result;
        }

        if(startLocation && (!endLocation)){
            return this.getCellByLocation(startLocation);
        }

        var rect = {
            left : Math.min(startLocation.x, endLocation.x),
            top : Math.min(startLocation.y, endLocation.y),
            width : Math.abs(endLocation.x - startLocation.x),
            height : Math.abs(endLocation.y - startLocation.y)
        };
        var leftTopPos = {x: rect.left, y: rect.top};
        var rightTopPos = {x: rect.left + rect.width, y: rect.top};
        var leftBottomPos = {x: rect.left, y: rect.top + rect.height};
        var rightBottomPos = {x: rect.left + rect.width, y: rect.top + rect.height};

        for (var k = 0; k < this.Cells.length; k++) {
            var cell = this.Cells[k];
            var cellRect = this.getCellRect(cell);
            var flag1 = this.ifRectContainPoint(cellRect, leftTopPos);
            var flag2 = this.ifRectContainPoint(cellRect, rightTopPos);
            var flag3 = this.ifRectContainPoint(cellRect, leftBottomPos);
            var flag4 = this.ifRectContainPoint(cellRect, rightBottomPos);
            var flag5 = this.ifRectContainRect(rect, cellRect);
            var flag6 = this.judgeRectIntersect(rect, cellRect);
            if (flag1 || flag2 || flag3 || flag4 || flag5 || flag6){
                result.push(cell);
            }
        }

        return result;
    },

    setCurrentClickCells: function(startLocation, endLocation){
        this.currentClickCells = this.getMultClickCell(startLocation, endLocation);
        this.drawTable();
        this.drawSelectedCells();
    },

    mergeSelectedCells: function(){
        if(!this.currentClickCells || this.currentClickCells.length == 0){
            $.messager.alert("提示","请选择单元格");
            return;
        }

        if(this.currentClickCells.length == 1){
            $.messager.alert("提示","请选择多个单元格");
            return;
        }

        var ifHasMergeCells = false;
        for(var i = 0; i < this.currentClickCells.length; i++){
            var cell = this.currentClickCells[i];
            if(cell.IsMergeCells){
                ifHasMergeCells = true;
                break;
            }
        }
        if(ifHasMergeCells){
            $.messager.alert("提示","选择单元格中含有合并单元格，请重新选择！");
            return;
        }

        var FromRowIndexArr = [], ToRowIndexArr = [], FromColIndexArr = [], ToColIndexArr = [];
        for(var i = 0; i < this.currentClickCells.length; i++){
            var cell = this.currentClickCells[i];
            FromRowIndexArr.push(cell.FromRowIndex);
            FromColIndexArr.push(cell.FromColIndex);
            ToRowIndexArr.push(cell.ToRowIndex);
            ToColIndexArr.push(cell.ToColIndex);
        }

        var mergedFromRowIndex = Math.min.apply(null, FromRowIndexArr);
        var mergedFromColIndex = Math.min.apply(null, FromColIndexArr);
        var mergedToRowIndex = Math.max.apply(null, ToRowIndexArr);
        var mergedToColIndex = Math.max.apply(null, ToColIndexArr);

        //获取单元格
        var toMergedCell = null;
        for(var i = 0; i < this.currentClickCells.length; i++){
            var cell = this.currentClickCells[i];
            if(cell.FromRowIndex == mergedFromRowIndex && cell.FromColIndex == mergedFromColIndex){
                toMergedCell = cell;
                break;
            }
        }
        if(toMergedCell == null){
            $.messager.alert("提示","未找到对应的合并单元格!");
            return;
        }

        var mergeCell = clone(toMergedCell, new WeakMap());
        mergeCell.FromRowIndex = mergedFromRowIndex;
        mergeCell.FromColIndex = mergedFromColIndex;
        mergeCell.ToRowIndex = mergedToRowIndex;
        mergeCell.ToColIndex = mergedToColIndex;
        mergeCell.IsMergeCells = true;
        
        for(var i = 0; i < this.currentClickCells.length; i++){
            var cell = this.currentClickCells[i];
            this.removeCell(cell);
        }
        
        this.currentClickCells = [];
        this.currentClickCells.push(mergeCell);
        this.Cells.push(mergeCell);
        this.drawTable();
        this.drawSelectedCells();
    },

    removeCell: function(cell){
        var index = this.Cells.indexOf(cell);
        if (index > -1) {
            this.Cells.splice(index, 1);
        }
    }
}

function HIDPI() {
    var ratio = window.devicePixelRatio || 1;
    var canvas = document.getElementById("table-canvas");
    var context = canvas.getContext("2d");
    var oldWidth = canvas.width;
    var oldHeight = canvas.height;
    canvas.width = oldWidth * ratio;
    canvas.height = oldHeight * ratio;
    canvas.style.width = oldWidth + "px";
    canvas.style.height = oldHeight + "px";
    context.scale(ratio, ratio);
}




