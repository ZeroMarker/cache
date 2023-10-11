Ext.ns('Nurse.grid');

Nurse.grid.CheckboxSelectionModel = Ext.extend(Ext.grid.CheckboxSelectionModel, {

    renderer: function(v, p, record) {
        var subOrder = record.json.subOrder;
        if (subOrder == "0") {
            return '<div class="x-grid3-row-checker">&#160;</div>';
        } else {
            return "";
        }

    },
    handleMouseDown: function(g, rowIndex, e) {
        if (e.button !== 0 || this.isLocked()) {
            return;
        }
        var view = this.grid.getView();
        if (e.shiftKey && !this.singleSelect && this.last !== false) {
            var last = this.last;
            this.selectRange(last, rowIndex, true);
            this.last = last; // reset the last
            view.focusRow(rowIndex);
        } else {
            var isSelected = this.isSelected(rowIndex);
            if (true && isSelected) {
                this.deselectRow(rowIndex);
            } else if (!isSelected || this.getCount() > 1) {
                this.selectRow(rowIndex, true || e.shiftKey);
                view.focusRow(rowIndex);
            }
        }
    },
    selectRow : function(index, keepExisting, preventViewNotify){
        if(this.isLocked() || (index < 0 || index >= this.grid.store.getCount()) || (keepExisting && this.isSelected(index))){
            return;
        }
        var r = this.grid.store.getAt(index);
        if(r && this.fireEvent('beforerowselect', this, index, keepExisting, r) !== false){
            if(!keepExisting || this.singleSelect){
                this.clearSelections();
            }

            var store = this.grid.getStore();
            var startRecord = store.getAt(index);
            var mainOrderIndex = startRecord.json.mainOrderIndex;
            var orderNum = store.getAt(mainOrderIndex).json.orderNum;
            if (orderNum > 1) {
                for (var i = mainOrderIndex; i < (mainOrderIndex + orderNum); i++) {
                        r=this.grid.store.getAt(i);
                        this.selections.add(r);
                        this.last = this.lastActive = i;
                        if(!preventViewNotify){
                            this.grid.getView().onRowSelect(i);
                        }
                        this.fireEvent('rowselect', this, i, r);
                        this.fireEvent('selectionchange', this);
                };
            } else {
                this.selections.add(r);
                this.last = this.lastActive = index;
                if(!preventViewNotify){
                    this.grid.getView().onRowSelect(index);
                }
                this.fireEvent('rowselect', this, index, r);
                this.fireEvent('selectionchange', this);
            }

        }
    },
    deselectRow : function(index, preventViewNotify){
        if(this.isLocked()){
            return;
        }
        if(this.last == index){
            this.last = false;
        }
        if(this.lastActive == index){
            this.lastActive = false;
        }


        var store = this.grid.getStore();
        var startRecord = store.getAt(index);
        var mainOrderIndex = startRecord.json.mainOrderIndex;
        var orderNum = store.getAt(mainOrderIndex).json.orderNum;
        if (orderNum > 1) {
            for (var i = mainOrderIndex; i < (mainOrderIndex + orderNum); i++) {
                        var r = this.grid.store.getAt(i);
                        if(r){
                            this.selections.remove(r);
                            if(!preventViewNotify){
                                this.grid.getView().onRowDeselect(i);
                            }
                            this.fireEvent('rowdeselect', this, i, r);
                            this.fireEvent('selectionchange', this);
                        }
            };
        } else {
                    var r = this.grid.store.getAt(index);
                    if(r){
                        this.selections.remove(r);
                        if(!preventViewNotify){
                            this.grid.getView().onRowDeselect(index);
                        }
                        this.fireEvent('rowdeselect', this, index, r);
                        this.fireEvent('selectionchange', this);
                    }
        }
    }
});


Nurse.grid.GridView = Ext.extend(Ext.grid.GridView, {
    onRowOver: function(e, target) {
        var row = this.findRowIndex(target);

        if (row !== false) {
            var store = this.grid.getStore();
            var startRecord = store.getAt(row);
            var mainOrderIndex = startRecord.json.mainOrderIndex;
            var orderNum = store.getAt(mainOrderIndex).json.orderNum;
            if (orderNum > 1) {
                for (var i = mainOrderIndex; i < (mainOrderIndex + orderNum); i++) {
                    this.addRowClass(i, this.rowOverCls);
                };
            } else {
                this.addRowClass(row, this.rowOverCls);
            }

        }
    },
    onRowOut: function(e, target) {
        var row = this.findRowIndex(target);

        if (row !== false && !e.within(this.getRow(row), true)) {
            var store = this.grid.getStore();
            var startRecord = store.getAt(row);
            var mainOrderIndex = startRecord.json.mainOrderIndex;
            var orderNum = store.getAt(mainOrderIndex).json.orderNum;
            if (orderNum > 1) {
                if ((row == mainOrderIndex) || (row == (mainOrderIndex + orderNum - 1))) {
                    for (var i = mainOrderIndex; i < (mainOrderIndex + orderNum); i++) {
                        this.removeRowClass(i, this.rowOverCls);
                    };
                }
            } else {
                this.removeRowClass(row, this.rowOverCls);
            }
        }
    },
    // onRowSelect: function(row) {
    //     var store = this.grid.getStore();
    //     var startRecord = store.getAt(row);
    //     var mainOrderIndex = startRecord.json.mainOrderIndex;
    //     var orderNum = store.getAt(mainOrderIndex).json.orderNum;
    //     if (orderNum > 1) {
    //         for (var i = mainOrderIndex; i < (mainOrderIndex + orderNum); i++) {
    //             this.addRowClass(i, this.selectedRowClass);
    //         };
    //     } else {
    //         this.addRowClass(row, this.selectedRowClass);
    //     }
    // },
    // onRowDeselect: function(row) {
    //     var store = this.grid.getStore();
    //     var startRecord = store.getAt(row);
    //     var mainOrderIndex = startRecord.json.mainOrderIndex;
    //     var orderNum = store.getAt(mainOrderIndex).json.orderNum;
    //     if (orderNum > 1) {
    //         for (var i = mainOrderIndex; i < (mainOrderIndex + orderNum); i++) {
    //             this.removeRowClass(i, this.selectedRowClass);
    //         };
    //     } else {
    //         this.removeRowClass(row, this.selectedRowClass);
    //     }
    // },
    doRender : function(columns, records, store, startRow, colCount, stripe) {
        var templates = this.templates,
            cellTemplate = templates.cell,
            rowTemplate = templates.row,
            last = colCount - 1,
            tstyle = 'width:' + this.getTotalWidth() + ';',
            // buffers
            rowBuffer = [],
            colBuffer = [],
            rowParams = {tstyle: tstyle},
            meta = {},
            len  = records.length,
            alt,
            column,
            record, i, j, rowIndex,mainOrderIndex,groupIndex;

        //build up each row's HTML
        for (j = 0; j < len; j++) {
            record    = records[j];
            colBuffer = [];

            rowIndex = j + startRow;

            //build up each column's HTML
            for (i = 0; i < colCount; i++) {
                column = columns[i];
                
                meta.id    = column.id;
                meta.css   = i === 0 ? 'x-grid3-cell-first ' : (i == last ? 'x-grid3-cell-last ' : '');
                meta.attr  = meta.cellAttr = '';
                meta.style = column.style;
                meta.value = column.renderer.call(column.scope, record.data[column.name], meta, record, rowIndex, i, store);
                //子医嘱不显示信息
                var nullValueString="^bedCode^patName^age^ordStatDesc^oecprDesc^phcfrCode^phcinDesc^ctcpDesc^sttDateTime^^^^^^";
                if((record.json.subOrder==1)&&(nullValueString.indexOf("^"+column.name+"^")>-1)){
                    meta.value='&#160;';
                }
                if (Ext.isEmpty(meta.value)) {
                    meta.value = '&#160;';
                }

                if (this.markDirty && record.dirty && typeof record.modified[column.name] != 'undefined') {
                    meta.css += ' x-grid3-dirty-cell';
                }

                colBuffer[colBuffer.length] = cellTemplate.apply(meta);
            }

            alt = [];
            //set up row striping and row dirtiness CSS classes
            // if (stripe && ((rowIndex + 1) % 2 === 0)) {
            //     alt[0] = 'x-grid3-row-alt';
            // }
            if(stripe){
                mainOrderIndex = record.json.mainOrderIndex;
                groupIndex=records[mainOrderIndex].json.groupIndex;
                if (stripe && ((groupIndex + 1) % 2 === 0)) {
                    alt[0] = 'x-grid3-row-alt';
                }
            }

            if (record.dirty) {
                alt[1] = ' x-grid3-dirty-row';
            }

            rowParams.cols = colCount;

            if (this.getRowClass) {
                alt[2] = this.getRowClass(record, rowIndex, rowParams, store);
            }

            rowParams.alt   = alt.join(' ');
            rowParams.cells = colBuffer.join('');
            
            rowBuffer[rowBuffer.length] = rowTemplate.apply(rowParams);
        }

        return rowBuffer.join('');
    }
});


Nurse.grid.GridPanel = Ext.extend(Ext.grid.GridPanel, {
    getView: function() {
        if (!this.view) {
            this.view = new Nurse.grid.GridView(this.viewConfig);
        }

        return this.view;
    }
});

Ext.override(Ext.grid.GridView,{
    getColumnStyle : function(colIndex, isHeader) {
        var colModel  = this.cm,
            colConfig = colModel.config,
            style     = isHeader ? '' : colConfig[colIndex].css || '',
            align     = colConfig[colIndex].align;
        
        if(Ext.isChrome){
                style += String.format("width: {0};", parseInt(this.getColumnWidth(colIndex))-2+'px');
            }else{
                style += String.format("width: {0};", this.getColumnWidth(colIndex));

            }

        
        if (colModel.isHidden(colIndex)) {
            style += 'display: none; ';
        }
        
        if (align) {
            style += String.format("text-align: {0};", align);
        }
        
        return style;
    }
});



Nurse.grid.ExecGridView = Ext.extend(Ext.grid.GridView, {
    initTemplates: function() {
        var templates = this.templates || {},
            template, name,

            headerCellTpl = new Ext.Template(
                '<td class="x-grid3-hd x-grid3-cell x-grid3-td-{id} {css}" style="{style}">',
                '<div {tooltip} {attr} class="x-grid3-hd-inner x-grid3-hd-{id}" unselectable="on" style="{istyle}">',
                this.grid.enableHdMenu ? '<a class="x-grid3-hd-btn" href="#"></a>' : '',
                '{value}',
                '<img alt="" class="x-grid3-sort-icon" src="', Ext.BLANK_IMAGE_URL, '" />',
                '</div>',
                '</td>'
            ),

            rowBodyText = [
                '<tr class="x-grid3-row-body-tr" style="{bodyStyle}">',
                '<td colspan="{cols}" class="x-grid3-body-cell" tabIndex="0" hidefocus="on">',
                '<div class="x-grid3-row-body">{body}</div>',
                '</td>',
                '</tr>'
            ].join(""),

            innerText = [
                '<table class="x-grid3-row-table" border="0" cellspacing="0" cellpadding="0" style="{tstyle}">',
                '<tbody>',
                '<tr>{cells}</tr>',
                this.enableRowBody ? rowBodyText : '',
                '</tbody>',
                '</table>'
            ].join("");

        Ext.applyIf(templates, {
            hcell: headerCellTpl,
            cell: this.cellTpl,
            body: this.bodyTpl,
            header: this.headerTpl,
            master: this.masterTpl,
            row: new Ext.Template('<div class="x-subgrid3-row {disposeStatCode} {alt}" style="{tstyle}">' + innerText + '</div>'),
            rowInner: new Ext.Template(innerText)
        });

        for (name in templates) {
            template = templates[name];

            if (template && Ext.isFunction(template.compile) && !template.compiled) {
                template.disableFormats = true;
                template.compile();
            }
        }
        this.templates = templates;
        this.colRe = new RegExp('x-grid3-td-([^\\s]+)', '');
    },
    doRender : function(columns, records, store, startRow, colCount, stripe) {
        var templates = this.templates,
            cellTemplate = templates.cell,
            rowTemplate = templates.row,
            last = colCount - 1,
            tstyle = 'width:' + this.getTotalWidth() + ';',
            // buffers
            rowBuffer = [],
            colBuffer = [],
            rowParams = {tstyle: tstyle},
            meta = {},
            len  = records.length,
            alt,
            column,
            record, i, j, rowIndex;

        //build up each row's HTML
        for (j = 0; j < len; j++) {
            record    = records[j];
            colBuffer = [];

            rowIndex = j + startRow;

            //build up each column's HTML
            for (i = 0; i < colCount; i++) {
                column = columns[i];
                
                meta.id    = column.id;
                meta.css   = i === 0 ? 'x-grid3-cell-first ' : (i == last ? 'x-grid3-cell-last ' : '');
                meta.attr  = meta.cellAttr = '';
                meta.style = column.style;
                meta.value = column.renderer.call(column.scope, record.data[column.name], meta, record, rowIndex, i, store);

                if (Ext.isEmpty(meta.value)) {
                    meta.value = '&#160;';
                }

                if (this.markDirty && record.dirty && typeof record.modified[column.name] != 'undefined') {
                    meta.css += ' x-grid3-dirty-cell';
                }

                colBuffer[colBuffer.length] = cellTemplate.apply(meta);
            }

            alt = [];
            //set up row striping and row dirtiness CSS classes
            if (stripe && ((rowIndex + 1) % 2 === 0)) {
                alt[0] = 'x-grid3-row-alt';
            }

            if (record.dirty) {
                alt[1] = ' x-grid3-dirty-row';
            }

            rowParams.cols = colCount;

            if (this.getRowClass) {
                alt[2] = this.getRowClass(record, rowIndex, rowParams, store);
            }

            rowParams.alt   = alt.join(' ');
            rowParams.cells = colBuffer.join('');
            rowParams.disposeStatCode=record.json.disposeStatCode;
            
            rowBuffer[rowBuffer.length] = rowTemplate.apply(rowParams);
        }

        return rowBuffer.join('');
    }
});

Nurse.grid.ExecGridPanel = Ext.extend(Ext.grid.GridPanel, {
    getView: function() {
        if (!this.view) {
            this.view = new Nurse.grid.ExecGridView(this.viewConfig);
        }

        return this.view;
    }
});


// Ext.ns('Nurse.grid.GridPanel');
// Nurse.grid.GridPanel=Ext.extend(Ext.grid.GridPanel,{

// });