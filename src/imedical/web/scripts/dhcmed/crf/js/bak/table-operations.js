















function TableOperations(editor) {
    this.editor = editor;

    var tt = TableOperations.I18N;
    var bl = TableOperations.btnList;
    var self = this;


};







TableOperations.prototype.getClosest = function (tagName) {
    var editor = this.editor;
    var ancestors = editor.getAllAncestors();
    var ret = null;
    tagName = ("" + tagName).toLowerCase();
    for (var i = 0; i < ancestors.length; i++) {
        var el = ancestors[i];
        if (el.tagName.toLowerCase() == tagName) {
            ret = el;
            break;
        }
    }
    return ret;
};




TableOperations.prototype.buttonPress = function (editor, button_id) {
    this.editor = editor;
    var mozbr = "";
    var i18n = TableOperations.I18N;

    function clearRow(tr) {
        var tds = tr.getElementsByTagName("td");
        for (var i = tds.length; --i >= 0; ) {
            var td = tds[i];
            td.rowSpan = 1;
            td.innerHTML = mozbr;
        }
    };

    function splitRow(td) {
        var n = parseInt("" + td.rowSpan);
        var nc = parseInt("" + td.colSpan);
        td.rowSpan = 1;
        tr = td.parentNode;
        var itr = tr.rowIndex;
        var trs = tr.parentNode.rows;
        var index = td.cellIndex;
        while (--n > 0) {
            tr = trs[++itr];
            var otd = editor._doc.createElement("td");
            otd.colSpan = td.colSpan;
            otd.innerHTML = mozbr;

            try {
                tr.insertBefore(otd, tr.cells[index]);
            } catch (e) {
                tr.insertBefore(otd);
            }
        }
        editor.forceRedraw();
    };

    function splitCol(td) {
        var nc = parseInt("" + td.colSpan);
        td.colSpan = 1;
        tr = td.parentNode;
        var ref = td.nextSibling;
        while (--nc > 0) {
            var otd = editor._doc.createElement("td");
            otd.rowSpan = td.rowSpan;
            otd.innerHTML = mozbr;
            tr.insertBefore(otd, ref);
        }
        editor.forceRedraw();
    };

    function splitCell(td) {
        var nc = parseInt("" + td.colSpan);
        splitCol(td);
        var items = td.parentNode.cells;
        var index = td.cellIndex;
        while (nc-- > 0) {
            splitRow(items[index++]);
        }
    };

    function selectNextNode(el) {
        var node = el.nextSibling;
        while (node && node.nodeType != 1) {
            node = node.nextSibling;
        }
        if (!node) {
            node = el.previousSibling;
            while (node && node.nodeType != 1) {
                node = node.previousSibling;
            }
        }
        if (!node) {
            node = el.parentNode;
        }
        editor.selectNodeContents(node);
    };

    switch (button_id) {

        case "TO-row-insert-above":
        case "TO-row-insert-under":
            var tr = this.getClosest("tr");
            if (!tr) {
                break;
            }
            var otr = tr.cloneNode(true);
            clearRow(otr);
            tr.parentNode.insertBefore(otr, /under/.test(button_id) ? tr.nextSibling : tr);
            editor.forceRedraw();
            editor.focusEditor();
            break;
        case "TO-row-delete":
            var tr = this.getClosest("tr");
            if (!tr) {
                break;
            }
            var par = tr.parentNode;
            if (par.rows.length == 1) {
                alert(i18n["not-del-last-row"]);
                break;
            }
            selectNextNode(tr);
            par.removeChild(tr);
            editor.forceRedraw();
            editor.focusEditor();
            break;
        case "TO-row-split":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            splitRow(td);
            break;


        case "TO-col-insert-before":
        case "TO-col-insert-after":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            var rows = td.parentNode.parentNode.rows;
            var index = td.cellIndex;
            for (var i = rows.length; --i >= 0; ) {
                var tr = rows[i];
                var ref = tr.cells[index + (/after/.test(button_id) ? 1 : 0)];
                var otd = editor._doc.createElement("td");
                otd.style.textAlign = "center";
                otd.style.backgroundColor = "#ffffff";
                otd.innerHTML = mozbr;
                if (typeof (ref) == "undefined") {
                    tr.appendChild(otd);
                } else {
                    tr.insertBefore(otd, ref);
                }
            }
            editor.focusEditor();
            break;
        case "TO-col-split":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            splitCol(td);
            break;
        case "TO-col-delete":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            var index = td.cellIndex;
            if (td.parentNode.cells.length == 1) {
                alert(i18n["not-del-last-col"]);
                break;
            }
            selectNextNode(td);
            var rows = td.parentNode.parentNode.rows;
            for (var i = rows.length; --i >= 0; ) {
                var tr = rows[i];
                tr.removeChild(tr.cells[index]);
            }
            editor.forceRedraw();
            editor.focusEditor();
            break;


        case "TO-cell-split":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            splitCell(td);
            break;
        case "TO-cell-insert-before":
        case "TO-cell-insert-after":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            var tr = td.parentNode;
            var otd = editor._doc.createElement("td");

            otd.style.textAlign = "center";
            otd.style.backgroundColor = "#ffffff";

            otd.innerHTML = mozbr;
            tr.insertBefore(otd, /after/.test(button_id) ? td.nextSibling : td);
            editor.forceRedraw();
            editor.focusEditor();
            break;
        case "TO-cell-delete":
            var td = this.getClosest("td");
            if (!td) {
                break;
            }
            if (td.parentNode.cells.length == 1) {
                alert(i18n["not-del-last-cell"]);
                break;
            }
            selectNextNode(td);
            td.parentNode.removeChild(td);
            editor.forceRedraw();
            break;
        case "TO-cell-merge":
            var sel = editor._getSelection();
            var range, i = 0;
            var rows = [];
            var row = null;
            var cells = null;
            if (!HTMLArea.is_ie) {
                try {
                    while (range = sel.getRangeAt(i++)) {
                        var td = range.startContainer.childNodes[range.startOffset];
                        if (td.parentNode != row) {
                            row = td.parentNode;
                            (cells) && rows.push(cells);
                            cells = [];
                        }
                        cells.push(td);
                    }
                } catch (e) { }
                rows.push(cells);
            } else {
                var td = this.getClosest("td");
                if (!td) {
                    alert(i18n["Please click into some cell"]);
                    break;
                }
                var tr = td.parentElement;
                var no_cols = prompt(i18n["How many columns would you like to merge?"], 2);
                if (!no_cols) {
                    break;
                }
                var no_rows = prompt(i18n["How many rows would you like to merge?"], 2);
                if (!no_rows) {
                    break;
                }
                var cell_index = td.cellIndex;
                while (no_rows-- > 0) {
                    td = tr.cells[cell_index];
                    cells = [td];
                    for (var i = 1; i < no_cols; ++i) {
                        td = td.nextSibling;
                        if (!td) {
                            break;
                        }
                        cells.push(td);
                    }
                    rows.push(cells);
                    tr = tr.nextSibling;
                    if (!tr) {
                        break;
                    }
                }
            }
            var HTML = "";
            for (i = 0; i < rows.length; ++i) {
                var cells = rows[i];
                for (var j = 0; j < cells.length; ++j) {
                    var cell = cells[j];
                    HTML += cell.innerHTML;
                    (i || j) && (cell.parentNode.removeChild(cell));
                }
            }
            var td = rows[0][0];
            td.innerHTML = HTML;
            td.rowSpan = rows.length;
            td.colSpan = rows[0].length;
            editor.selectNodeContents(td);
            editor.forceRedraw();
            editor.focusEditor();
            break;


        case "TO-table-prop":
            try {
                if (curSelElement.tagName == "TD") {
                    if (curSelElement.parentNode.parentNode.parentNode.tagName != "TABLE") {
                        alert("请选中表格!");
                        return;
                    }
                    var curobj = curSelElement.parentNode.parentNode.parentNode;
                } else {
                    curobj = curSelElement;
                }
                var sHTab = DjOpen('fcs_Tabattribute', curobj, '展现', "有模式窗口", "直接", "表格属性");
            } catch (e) { alert("请选中表格!"); }
            break;

        case "TO-row-prop":
            break;

        case "TO-cell-prop":
            try {
                if (curSelElement.tagName != "TD") {
                    alert("请选中TD!");
                    return;
                }
                var sHTd = DjOpen('fcs_Tdattribute', curSelElement, '展现', "有模式窗口", "直接", "单元格属性");
            } catch (e) { }
            break;

        default:
            alert("Button [" + button_id + "] not yet implemented");
    }
};


TableOperations.btnList = [
["table-prop", "table"],
null,

["row-prop", "tr"],
["row-insert-above", "tr"],
["row-insert-under", "tr"],
["row-delete", "tr"],
["row-split", "td[rowSpan!=1]"],
null,

["col-insert-before", "td"],
["col-insert-after", "td"],
["col-delete", "td"],
["col-split", "td[colSpan!=1]"],
null,

["cell-prop", "td"],
["cell-insert-before", "td"],
["cell-insert-after", "td"],
["cell-delete", "td"],
["cell-merge", "tr"],
["cell-split", "td[colSpan!=1,rowSpan!=1]"]
];

















TableOperations.I18N = {
    "Align": "Align",
    "All four sides": "All four sides",
    "Background": "Background",
    "Baseline": "Baseline",
    "Border": "Border",
    "Borders": "Borders",
    "Bottom": "Bottom",
    "CSS Style": "Style [CSS]",
    "Caption": "Caption",
    "Cell Properties": "Cell Properties",
    "Center": "Center",
    "Char": "Char",
    "Collapsed borders": "Collapsed borders",
    "Color": "Color",
    "Description": "Description",
    "FG Color": "FG Color",
    "Float": "Float",
    "Frames": "Frames",
    "Height": "Height",
    "How many columns would you like to merge?": "设置要合并的列数:",
    "How many rows would you like to merge?": "设置要合并的行数:",
    "Image URL": "Image URL",
    "Justify": "Justify",
    "Layout": "Layout",
    "Left": "Left",
    "Margin": "Margin",
    "Middle": "Middle",
    "No rules": "No rules",
    "No sides": "No sides",
    "None": "None",
    "Padding": "Padding",
    "Please click into some cell": "请选择单元格",
    "Right": "Right",
    "Row Properties": "Row Properties",
    "Rules will appear between all rows and columns": "Rules will appear between all rows and columns",
    "Rules will appear between columns only": "Rules will appear between columns only",
    "Rules will appear between rows only": "Rules will appear between rows only",
    "Rules": "Rules",
    "Spacing and padding": "Spacing and padding",
    "Spacing": "Spacing",
    "Summary": "Summary",
    "TO-cell-delete": "Delete cell",
    "TO-cell-insert-after": "Insert cell after",
    "TO-cell-insert-before": "Insert cell before",
    "TO-cell-merge": "Merge cells",
    "TO-cell-prop": "Cell properties",
    "TO-cell-split": "Split cell",
    "TO-col-delete": "Delete column",
    "TO-col-insert-after": "Insert column after",
    "TO-col-insert-before": "Insert column before",
    "TO-col-split": "Split column",
    "TO-row-delete": "Delete row",
    "TO-row-insert-above": "Insert row before",
    "TO-row-insert-under": "Insert row after",
    "TO-row-prop": "Row properties",
    "TO-row-split": "Split row",
    "TO-table-prop": "Table properties",
    "Table Properties": "Table Properties",
    "Text align": "Text align",
    "The bottom side only": "The bottom side only",
    "The left-hand side only": "The left-hand side only",
    "The right and left sides only": "The right and left sides only",
    "The right-hand side only": "The right-hand side only",
    "The top and bottom sides only": "The top and bottom sides only",
    "The top side only": "The top side only",
    "Top": "Top",
    "Unset color": "Unset color",
    "Vertical align": "Vertical align",
    "Width": "Width",
    "not-del-last-cell": "不能删除一行中的最后一个单元格",
    "not-del-last-col": "不能删除表格的最后一列",
    "not-del-last-row": "不能删除表格的最后一行",
    "percent": "percent",
    "pixels": "pixels"
};
