/*
* 插件名称： GroupHeaderGrid
* 适用版本： Extjs 3 Grid
* 插件版本： Version 1.0
* 插件功能： 多表头表格插件，支持多列排序，适用多列排序的时候应按住Ctrl键
* 作   者： 佘 斌
* 说   明： GroupHeaderGrid载自网上，然后自行添加了多列排序的功能，
*          排序算法是冒泡排序。
* 完成时间： 2010年8月25日
*/
Ext.namespace("Ext.ux.plugins");

if(Ext.isWebKit){
	Ext.grid.GridView.prototype.borderWidth = 0;
}

Ext.ux.plugins.GroupHeaderGrid = function(config) {
	this.config = config;
};

Ext.extend(Ext.ux.plugins.GroupHeaderGrid, Ext.util.Observable, {
    init: function (grid) {
        Ext.applyIf(grid.colModel, this.config);
        Ext.apply(grid.getView(), this.viewConfig);

        //定义的热键值
        var HotKeyValue = 0;
        var PerSortInfo = null;

        //按键按下的事件
        var keyDown = function () {
            HotKeyValue = event.keyCode;
            PerSortInfo = grid.store.sortInfo;
        }
        //按键弹起的事件
        var keyUp = function () {
            HotKeyValue = 0;
        }

        var upDateMultiSortIcon = function (col, dir, cview) {
            var sc = cview.sortClasses;
            var hds = cview.mainHd.select(cview.cellSelector).removeClass("");
            hds.item(col).removeClass(sc[dir == "DESC" ? 0 : 1]);
            hds.item(col).addClass(sc[dir == "DESC" ? 1 : 0]);
        }

        var upDateSortIcon = function (col, dir, cview) {
            var sc = cview.sortClasses;
            var hds = cview.mainHd.select(cview.cellSelector).removeClass(sc);
            hds.item(col).addClass(sc[dir == "DESC" ? 1 : 0]);
        }

        /*
        * 排序算法：
        * 标准的冒泡
        */
        var DoSort = function (Arr, Afield, ADir) {
            var len = Arr.length;
            if (Arr.length > 1) {   //大于一才开始排序，小于或者等于一的时候不需要排序
                for (n = 0; n < len; n++) {
                    for (m = n + 1; m < len; m++) {
                        if (ADir == "ASC") {
                            if (Arr[n].data[Afield] > Arr[m].data[Afield]) {
                                temp = Arr[n];
                                Arr[n] = Arr[m];
                                Arr[m] = temp;
                            }
                        } else {
                            if (Arr[n].data[Afield] < Arr[m].data[Afield]) {
                                temp = Arr[n];
                                Arr[n] = Arr[m];
                                Arr[m] = temp;
                            }
                        }
                    }
                }
            }
            return Arr;
        }

        /********************************************************************************
        *  用  途： Extjs多列排序方法
        *  方法名： MultiColSort
        *  作  者： shebin
        *  时  间： 2010-08-21
        *  参  数: 第一个是字段的名称，第二个是排序的方式（"ASC/DESC", 大小写敏感）
        *
        *  排序方法，思路如下：
        *  多行排序考虑了任意多个字段排序的情况。
        *  而任何一个字段开始排序之前，其前字段的排序已经完成了
        *  所以只需要根据前一个字段作为参考数据，而对当前的字段做排序即可
        *  
        ********************************************************************************
        */
        var MultiColSort = function (f, direction) {
            var CurView = grid.getView();
            if (CurView.activeHd.id != "" && CurView.activeHd.id.indexOf("TopHead") != -1) {
                return false;
            }
            //如果按住了Contorl键， 17为Control的键值
            if (HotKeyValue == 17) {
                //PerSortInfo在前面定义，表示当前排序之前的那个字段，保存了以前排序的字段和排序的顺序
                if (PerSortInfo != null) {
                    var PerArr = PerSortInfo.field.split("|"); //已经排序的字段的数组

                    //通过判断字段的名字判断是新排序的字段还是点击的同一个排序字段
                    if (PerArr[PerArr.length - 1] != f) { //如果是新字段排序，那么忠于客户的选择
                        this.sortInfo.field = PerSortInfo.field + "|" + f;  //把新排序的字段添加进来
                        this.sortInfo.direction = PerSortInfo.direction + "|" + direction; //把新排序的顺序添加进来
                    } else {  //如果点的是同一个字段，那么认为是在交替排序。顺序正好和以前的相反
                        var TmpDirArr = PerSortInfo.direction.split("|");
                        if (TmpDirArr[TmpDirArr.length - 1] == "ASC") {
                            direction = "DESC";
                        } else {
                            direction = "ASC";
                        }

                        //更新当前的字段排序的实际方向（"ASC/DESC"）
                        TmpDirArr[TmpDirArr.length - 1] = direction;
                        PerSortInfo.direction = "";
                        for (i = 0; i < TmpDirArr.length - 1; i++) {
                            PerSortInfo.direction = PerSortInfo.direction + TmpDirArr[i] + "|";
                        }
                        PerSortInfo.direction = PerSortInfo.direction + direction;
                        this.sortInfo.field = PerSortInfo.field;
                        this.sortInfo.direction = PerSortInfo.direction;
                        //更新完毕
                    }

                    //更新表头箭头的显示效果
                    var acol = grid.getView().activeHdIndex;
                    upDateMultiSortIcon(acol, direction, CurView);

                    var FieldArr = this.sortInfo.field.split("|"); //当前排序的字段数组
                    var DirArr = this.sortInfo.direction.split("|"); //当前排序的顺序数组

                    //定义两个数组，分别记录最终的排序数据和当前分组下需要排序的数据
                    var retArr = new Array();
                    var objArr = new Array();
                    if (this.data.items.length > 0) {
                        //多列的对照值。是前面几个列的数值相加，不用担心数据类型的问题，
                        //如果数据相等，相加之后的值肯定相等
                        //相等的时候说明前面的排序已经固定，只需要排当前的就可以了
                        var curFieldValue = "";
                        for (i = 0; i < FieldArr.length - 1; i++) {
                            curFieldValue = curFieldValue + "&" + this.data.items[0].data[FieldArr[i]]
                        }
                        for (i = 0; i < this.data.items.length; i++) {

                            var CurValue = "";
                            for (u = 0; u < FieldArr.length - 1; u++) {
                                CurValue = CurValue + "&" + this.data.items[i].data[FieldArr[u]]
                            }
                            //如果相等，说明是同组的数据，直接添加进来，按照新的字段排序
                            if (CurValue == curFieldValue) {
                                //do nothing
                            } else {
                                //如果不相等，说明是新的种类，在前面的排完之后，会在排这个，保证了前面的顺序没被打乱
                                var TmpArr = DoSort(objArr, f, direction);
                                for (j = 0; j < TmpArr.length; j++) {
                                    retArr[retArr.length] = TmpArr[j];
                                }
                                objArr.length = 0;
                                curFieldValue = CurValue;
                            }
                            objArr.push(this.data.items[i]);
                        }
                        //最后一次没有可以比较的CurValue，还需要再进行一次排序
                        var TmpArr1 = DoSort(objArr, f, DirArr[DirArr.length - 1]);
                        //排序完成之后，写到结果数组中去
                        for (k = 0; k < TmpArr1.length; k++) {
                            retArr[retArr.length] = TmpArr1[k];
                        }
                    }
                    //更新当前Store的数据。
                    for (li = 0; li < retArr.length; li++) {
                        this.data.items[li] = retArr[li];
                    }
                }
            } else {  //没有按住Control键的时候，为正常排序，没有什么特别的地方
                if (this.data.items.length > 0) {
                    var objArr = new Array();
                    for (i = 0; i < this.data.items.length; i++) {
                        objArr.push(this.data.items[i]);
                    }
                    var TmpArr1 = DoSort(objArr, f, direction);
                    for (li = 0; li < TmpArr1.length; li++) {
                        this.data.items[li] = TmpArr1[li];
                    }
                }

                var acol = grid.getView().activeHdIndex;
                upDateSortIcon(acol, direction, CurView);
            }
        }

        grid.store.sortData = MultiColSort;

        //将键盘事件注册到表格所造的页面级别
        window.document.onkeydown = keyDown;
        window.document.onkeyup = keyUp;
    },

    viewConfig: {
        initTemplates: function () {
            this.constructor.prototype.initTemplates.apply(this, arguments);
            var ts = this.templates || {};
            if (!ts.gcell) {
                ts.gcell = new Ext.XTemplate(
					'<td id="TopHead-{id}" class="x-grid3-hd x-grid3-gcell x-grid3-td-{id} ux-grid-hd-group-row-{row} {cls}" style="{style}">',
                //多行表头，去掉了一个样式x-grid3-hd-{id}，这样在上面的表头中不会显示checkBox图片 sbin amend 2010-08-23
                    '<div {tooltip} class="x-grid3-hd-inner" unselectable="on" style="{istyle}">',
                //'<div {tooltip} class="x-grid3-hd-inner x-grid3-hd-{id}" unselectable="on" style="{istyle}">',
                //多行表头不显示隐藏的菜单(排序和设置列，如果日后有需求应用这些设置，可以打开 sbin amends 2010-08-23)
                    this.grid.enableHdMenu ? '' : '',
                //this.grid.enableHdMenu ? '<a class="x-grid3-hd-btn" href="#"></a>' : '',
					'{value}</div></td>'
				);
            }
            this.templates = ts;
            this.hrowRe = new RegExp("ux-grid-hd-group-row-(\\d+)", "");
        },

        renderHeaders: function () {
            var ts = this.templates, headers = [], cm = this.cm, rows = cm.rows, tstyle = 'width:' + this.getTotalWidth() + ';';
            for (var row = 0, rlen = rows.length; row < rlen; row++) {
                var r = rows[row], cells = [];
                for (var i = 0, gcol = 0, len = r.length; i < len; i++) {
                    var group = r[i];
                    group.colspan = group.colspan || 1;
                    var id = this.getColumnId(group.dataIndex ? cm.findColumnIndex(group.dataIndex) : gcol);
                    var gs = Ext.ux.plugins.GroupHeaderGrid.prototype.getGroupStyle.call(this, group, gcol);
                    cells[i] = ts.gcell.apply({
                        cls: group.header ? 'ux-grid-hd-group-cell' : 'ux-grid-hd-nogroup-cell',
                        id: id,
                        row: row,
                        style: 'width:' + gs.width + ';' + (gs.hidden ? 'display:none;' : '') + (group.align ? 'text-align:' + group.align + ';' : ''),
                        tooltip: group.tooltip ? (Ext.QuickTips.isEnabled() ? 'ext:qtip' : 'title') + '="' + group.tooltip + '"' : '',
                        istyle: group.align == 'right' ? 'padding-right:16px' : '',
                        btn: this.grid.enableHdMenu && group.header,
                        value: group.header || '&nbsp;'
                    });
                    gcol += group.colspan;
                }
                headers[row] = ts.header.apply({
                    tstyle: tstyle,
                    cells: cells.join('')
                });
            }
            headers.push(this.constructor.prototype.renderHeaders.apply(this, arguments));
            return headers.join('');
        },

        onColumnWidthUpdated: function () {
            this.constructor.prototype.onColumnWidthUpdated.apply(this, arguments);
            Ext.ux.plugins.GroupHeaderGrid.prototype.updateGroupStyles.call(this);
        },

        onAllColumnWidthsUpdated: function () {
            this.constructor.prototype.onAllColumnWidthsUpdated.apply(this, arguments);
            Ext.ux.plugins.GroupHeaderGrid.prototype.updateGroupStyles.call(this);
        },

        onColumnHiddenUpdated: function () {
            this.constructor.prototype.onColumnHiddenUpdated.apply(this, arguments);
            Ext.ux.plugins.GroupHeaderGrid.prototype.updateGroupStyles.call(this);
        },

        getHeaderCell: function (index) {
            return this.mainHd.query(this.cellSelector)[index];
        },

        findHeaderCell: function (el) {
            return el ? this.fly(el).findParent('td.x-grid3-hd', this.cellSelectorDepth) : false;
        },

        findHeaderIndex: function (el) {
            var cell = this.findHeaderCell(el);
            return cell ? this.getCellIndex(cell) : false;
        },

        updateSortIcon: function (col, dir) {
            //屏蔽点击上层表头的时候切换排序的图片 Sbin amend 2010-08-25
            if (this.activeHd.id != "" && this.activeHd.id.indexOf("TopHead") != -1) {
                return false;
            }

            var sc = this.sortClasses;
            var hds = this.mainHd.select(this.cellSelector).removeClass(sc);
            hds.item(col).addClass(sc[dir == "DESC" ? 1 : 0]);
        },

        /*
        * 下面这个是隐藏菜单点击的时候触发的事件，因为隐藏菜单已经屏蔽，所以暂时不会执行到这里了
        * sbin amend 2010-08-23
        */
        handleHdMenuClick: function (item) {
            var index = this.hdCtxIndex,
	            cm = this.cm,
	            ds = this.ds,
	            id = item.getItemId();
            switch (id) {
                case 'asc':
                    ds.sort(cm.getDataIndex(index), 'ASC');
                    break;
                case 'desc':
                    ds.sort(cm.getDataIndex(index), 'DESC');
                    break;
                default:
                    if (id.substr(0, 5) == 'group') {
                        var i = id.split('-'),
							row = parseInt(i[1], 10), col = parseInt(i[2], 10),
							r = this.cm.rows[row], group, gcol = 0;
                        for (var i = 0, len = r.length; i < len; i++) {
                            group = r[i];
                            if (col >= gcol && col < gcol + group.colspan) {
                                break;
                            }
                            gcol += group.colspan;
                        }
                        if (item.checked) {
                            var max = cm.getColumnsBy(this.isHideableColumn, this).length;
                            for (var i = gcol, len = gcol + group.colspan; i < len; i++) {
                                if (!cm.isHidden(i)) {
                                    max--;
                                }
                            }
                            if (max < 1) {
                                this.onDenyColumnHide();
                                return false;
                            }
                        }
                        for (var i = gcol, len = gcol + group.colspan; i < len; i++) {
                            if (cm.config[i].fixed !== true && cm.config[i].hideable !== false) {
                                cm.setHidden(i, item.checked);
                            }
                        }
                    } else {
                        index = cm.getIndexById(id.substr(4));
                        if (index != -1) {
                            if (item.checked && cm.getColumnsBy(this.isHideableColumn, this).length <= 1) {
                                this.onDenyColumnHide();
                                return false;
                            }
                            cm.setHidden(index, item.checked);
                        }
                    }
                    item.checked = !item.checked;
                    if (item.menu) {
                        var updateChildren = function (menu) {
                            menu.items.each(function (childItem) {
                                if (!childItem.disabled) {
                                    childItem.setChecked(item.checked, false);
                                    if (childItem.menu) {
                                        updateChildren(childItem.menu);
                                    }
                                }
                            });
                        }
                        updateChildren(item.menu);
                    }
                    var parentMenu = item, parentItem;
                    while (parentMenu = parentMenu.parentMenu) {
                        console.log(parentMenu);
                        if (!parentMenu.parentMenu ||
							!(parentItem = parentMenu.parentMenu.items.get(parentMenu.getItemId())) ||
							!parentItem.setChecked) {
                            break;
                        }
                        var checked = parentMenu.items.findIndexBy(function (m) {
                            return m.checked;
                        }) >= 0;
                        parentItem.setChecked(checked, true);
                    }
                    item.checked = !item.checked;
            }
            return true;
        },

        beforeColMenuShow: function () {
            var cm = this.cm, rows = this.cm.rows;
            this.colMenu.removeAll();
            for (var col = 0, clen = cm.getColumnCount(); col < clen; col++) {
                var menu = this.colMenu, text = cm.getColumnHeader(col);
                if (cm.config[col].fixed !== true && cm.config[col].hideable !== false) {
                    for (var row = 0, rlen = rows.length; row < rlen; row++) {
                        var r = rows[row], group, gcol = 0;
                        for (var i = 0, len = r.length; i < len; i++) {
                            group = r[i];
                            if (col >= gcol && col < gcol + group.colspan) {
                                break;
                            }
                            gcol += group.colspan;
                        }
                        if (group && group.header) {
                            if (cm.hierarchicalColMenu) {
                                var gid = 'group-' + row + '-' + gcol;
                                var item = menu.items.item(gid);
                                var submenu = item ? item.menu : null;
                                if (!submenu) {
                                    submenu = new Ext.menu.Menu({ itemId: gid });
                                    submenu.on("itemclick", this.handleHdMenuClick, this);
                                    var checked = false, disabled = true;
                                    for (var c = gcol, lc = gcol + group.colspan; c < lc; c++) {
                                        if (!cm.isHidden(c)) {
                                            checked = true;
                                        }
                                        if (cm.config[c].hideable !== false) {
                                            disabled = false;
                                        }
                                    }
                                    menu.add({
                                        itemId: gid,
                                        text: group.header,
                                        menu: submenu,
                                        hideOnClick: false,
                                        checked: checked,
                                        disabled: disabled
                                    });
                                }
                                menu = submenu;
                            } else {
                                text = group.header + ' ' + text;
                            }
                        }
                    }
                    menu.add(new Ext.menu.CheckItem({
                        itemId: "col-" + cm.getColumnId(col),
                        text: text,
                        checked: !cm.isHidden(col),
                        hideOnClick: false,
                        disabled: cm.config[col].hideable === false
                    }));
                }
            }
        },

        renderUI: function () {
            this.constructor.prototype.renderUI.apply(this, arguments);
            Ext.apply(this.columnDrop, Ext.ux.plugins.GroupHeaderGrid.prototype.columnDropConfig);
        }
    },

    columnDropConfig: {
        getTargetFromEvent: function (e) {
            var t = Ext.lib.Event.getTarget(e);
            return this.view.findHeaderCell(t);
        },

        positionIndicator: function (h, n, e) {
            var data = Ext.ux.plugins.GroupHeaderGrid.prototype.getDragDropData.call(this, h, n, e);
            if (data === false) {
                return false;
            }
            var px = data.px + this.proxyOffsets[0];
            this.proxyTop.setLeftTop(px, data.r.top + this.proxyOffsets[1]);
            this.proxyTop.show();
            this.proxyBottom.setLeftTop(px, data.r.bottom);
            this.proxyBottom.show();
            return data.pt;
        },

        onNodeDrop: function (n, dd, e, data) {
            var h = data.header;
            if (h != n) {
                var d = Ext.ux.plugins.GroupHeaderGrid.prototype.getDragDropData.call(this, h, n, e);
                if (d === false) {
                    return false;
                }
                var cm = this.grid.colModel, right = d.oldIndex < d.newIndex, rows = cm.rows;
                for (var row = d.row, rlen = rows.length; row < rlen; row++) {
                    var r = rows[row], len = r.length, fromIx = 0, span = 1, toIx = len;
                    for (var i = 0, gcol = 0; i < len; i++) {
                        var group = r[i];
                        if (d.oldIndex >= gcol && d.oldIndex < gcol + group.colspan) {
                            fromIx = i;
                        }
                        if (d.oldIndex + d.colspan - 1 >= gcol && d.oldIndex + d.colspan - 1 < gcol + group.colspan) {
                            span = i - fromIx + 1;
                        }
                        if (d.newIndex >= gcol && d.newIndex < gcol + group.colspan) {
                            toIx = i;
                        }
                        gcol += group.colspan;
                    }
                    var groups = r.splice(fromIx, span);
                    rows[row] = r.splice(0, toIx - (right ? span : 0)).concat(groups).concat(r);
                }
                for (var c = 0; c < d.colspan; c++) {
                    var oldIx = d.oldIndex + (right ? 0 : c), newIx = d.newIndex + (right ? -1 : c);
                    cm.moveColumn(oldIx, newIx);
                    this.grid.fireEvent("columnmove", oldIx, newIx);
                }
                return true;
            }
            return false;
        }
    },

    getGroupStyle: function (group, gcol) {
        var width = 0, hidden = true;
        for (var i = gcol, len = gcol + group.colspan; i < len; i++) {
            if (!this.cm.isHidden(i)) {
                var cw = this.cm.getColumnWidth(i);
                if (typeof cw == 'number') {
                    width += cw;
                }
                hidden = false;
            }
        }
        return {
            width: (Ext.isBorderBox ? width : Math.max(width - this.borderWidth, 0)) + 'px',
            hidden: hidden
        };
    },

    updateGroupStyles: function (col) {
        var tables = this.mainHd.query('.x-grid3-header-offset > table'), tw = this.getTotalWidth(), rows = this.cm.rows;
        for (var row = 0; row < tables.length; row++) {
            tables[row].style.width = tw;
            if (row < rows.length) {
                var cells = tables[row].firstChild.firstChild.childNodes;
                for (var i = 0, gcol = 0; i < cells.length; i++) {
                    var group = rows[row][i];
                    if ((typeof col != 'number') || (col >= gcol && col < gcol + group.colspan)) {
                        var gs = Ext.ux.plugins.GroupHeaderGrid.prototype.getGroupStyle.call(this, group, gcol);
                        cells[i].style.width = gs.width;
                        cells[i].style.display = gs.hidden ? 'none' : '';
                    }
                    gcol += group.colspan;
                }
            }
        }
    },

    getGroupRowIndex: function (el) {
        if (el) {
            var m = el.className.match(this.hrowRe);
            if (m && m[1]) {
                return parseInt(m[1], 10);
            }
        }
        return this.cm.rows.length;
    },

    getGroupSpan: function (row, col) {
        if (row < 0) {
            return { col: 0, colspan: this.cm.getColumnCount() };
        }
        var r = this.cm.rows[row];
        if (r) {
            for (var i = 0, gcol = 0, len = r.length; i < len; i++) {
                var group = r[i];
                if (col >= gcol && col < gcol + group.colspan) {
                    return { col: gcol, colspan: group.colspan };
                }
                gcol += group.colspan;
            }
            return { col: gcol, colspan: 0 };
        }
        return { col: col, colspan: 1 };
    },

    getDragDropData: function (h, n, e) {
        if (h.parentNode != n.parentNode) {
            return false;
        }
        var cm = this.grid.colModel;
        var x = Ext.lib.Event.getPageX(e);
        var r = Ext.lib.Dom.getRegion(n.firstChild);
        var px, pt;
        if ((r.right - x) <= (r.right - r.left) / 2) {
            px = r.right + this.view.borderWidth;
            pt = "after";
        } else {
            px = r.left;
            pt = "before";
        }
        var oldIndex = this.view.getCellIndex(h);
        var newIndex = this.view.getCellIndex(n);
        if (cm.isFixed(newIndex)) {
            return false;
        }
        var row = Ext.ux.plugins.GroupHeaderGrid.prototype.getGroupRowIndex.call(this.view, h);
        var oldGroup = Ext.ux.plugins.GroupHeaderGrid.prototype.getGroupSpan.call(this.view, row, oldIndex);
        var newGroup = Ext.ux.plugins.GroupHeaderGrid.prototype.getGroupSpan.call(this.view, row, newIndex);
        oldIndex = oldGroup.col;
        newIndex = newGroup.col + (pt == "after" ? newGroup.colspan : 0);
        if (newIndex >= oldGroup.col && newIndex <= oldGroup.col + oldGroup.colspan) {
            return false;
        }
        var parentGroup = Ext.ux.plugins.GroupHeaderGrid.prototype.getGroupSpan.call(this.view, row - 1, oldIndex);
        if (newIndex < parentGroup.col || newIndex > parentGroup.col + parentGroup.colspan) {
            return false;
        }
        return {
            r: r,
            px: px,
            pt: pt,
            row: row,
            oldIndex: oldIndex,
            newIndex: newIndex,
            colspan: oldGroup.colspan
        };
    }
});