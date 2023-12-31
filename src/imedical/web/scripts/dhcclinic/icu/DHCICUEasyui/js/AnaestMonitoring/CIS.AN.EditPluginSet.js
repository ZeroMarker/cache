//
/**
 * EditPluginSet的构造函数
 * 先单行编辑
 * 编辑框集合，将多个编辑框都加载出来，同时编辑
 * @param {object} options
 * @author yongyang 20171128 
 */
function EditPluginSet(options) {
    this.dataItem = options.dataItem;
    this.dataItems = options.dataItems;
    this.availableDataItems = [];
    this.position = null;
    this.target = options.target;
    this.init();
    this.focus();
}

/**
 * EditPluginSet的处理方法
 */
EditPluginSet.prototype = {
    /**
     * 构造方法
     */
    constructor: EditPluginSet,
    init: function() {
        this.filter();
        if (this.visible()) {
            this.initButtons();
            this.render();
        }
    },
    filter: function() {
        var dataItems = [];
        var dataItem, row;
        var exactRow = null;
        for (var i = 0, length = this.dataItems.length; i < length; i++) {
            row = this.dataItems[i];
            for (var j = 0, colLen = row.length; j < colLen; j++) {
                dataItem = row[j];
                if (dataItem == this.dataItem) {
                    exactRow = row;
                    break;
                }
            }
            if (exactRow) break;
        }
        for (var j = 0, colLen = exactRow.length; j < colLen; j++) {
            dataItem = exactRow[j];
            if (dataItem.jointlyEditing) dataItems.push(dataItem);
        }
        this.availableDataItems = dataItems;
    },
    visible: function() {
        return this.availableDataItems.length > 0;
    },
    calculatePosition: function() {
        if (!this.position) {
            var dataItems = this.availableDataItems;
            var position = { x: 0, y: 0 };
            var dataItem;
            for (var i = 0, length = dataItems.length; i < length; i++) {
                dataItem = dataItems[i];
                position.x = Math.max(position.x, dataItem.rect.right);
                position.y = Math.max(position.y, dataItem.rect.bottom);
                if (dataItem.buttonOffset) {
                    position.x = Math.max(position.x, dataItem.rect.right + (dataItem.buttonOffset.x || 0));
                    position.y = Math.max(position.y, dataItem.rect.bottom + (dataItem.buttonOffset.y || 0));
                }
            }
            this.position = position;
        }
        return this.position;
    },
    initButtons: function() {
        var _this = this;
        var position = this.calculatePosition();
        var parent = $($(this.target).parent());
        var scrollTop = parent.scrollTop();
        var scrollLeft = parent.scrollLeft();

        //$($(this.target).parent()).css({ position: 'relative' });

        var htmlArr = [];
        htmlArr.push("<div class='edit-plugin-set'");
        htmlArr.push("style='position:absolute;float:left;z-index:100;width:200px;");
        htmlArr.push("top:" + (position.y - 5 - scrollTop + 33) + "px;");
        htmlArr.push("left:" + (position.x - scrollLeft + 20) + "px'>");
        htmlArr.push("</div>");
        var editPluginSet = $(htmlArr.join(""));
        $(this.target).before(editPluginSet);

        var saveButton = $('<a href="javascript:;" style="position:absolute;top:0px;">保存</a>')
            .linkbutton({
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            })
            .appendTo(editPluginSet);
        var cancelButton = $('<a href="javascript:;" style="position:absolute;top:35px;">取消</a>')
            .linkbutton({
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            })
            .appendTo(editPluginSet);

        this.element = editPluginSet;
    },
    render: function() {
        var editplugins = [];
        var dataItems = this.availableDataItems;
        var dataItem, editplugin;
        for (var i = 0, length = dataItems.length; i < length; i++) {
            dataItem = dataItems[i];
            editplugin = new EditPlugin({
                dataItem: dataItem,
                target: record.sheet.canvas,
                buttonVisible: false
            });
            editplugins.push(editplugin);
        }

        this.editplugins = editplugins;
    },
    refreshPosition: function() {
        var editplugins = this.editplugins;
        var editplugin;
        for (var i = 0, length = editplugins.length; i < length; i++) {
            editplugin = editplugins[i];
            editplugin.refreshPosition();
        }

        var position = this.calculatePosition();

        var parent = $($(this.target).parent());
        var scrollTop = parent.scrollTop();
        var scrollLeft = parent.scrollLeft();

        this.element.css({
            top: position.y - 5 - scrollTop + 33,
            left: position.x - scrollLeft + 20
        });
    },
    focus: function() {
        this.editplugins[0].focus();
    },
    save: function() {
        var editplugins = this.editplugins;
        var editplugin;
        for (var i = 0, length = editplugins.length; i < length; i++) {
            editplugin = editplugins[i];
            editplugin.save();
        }

        this.close();
    },
    confirmAndSave: function() {
        var _this = this;
        $.messager.confirm("请确认保存当前修改", "<em>如需保存请点击【确认】，不保存请点击【取消】</em></div>",
            saveData);

        function saveData() {
            _this.save();
        }
    },
    isSameDataItem: function(otherDataItem) {
        var result = false;
        var dataItems = this.availableDataItems;
        var dataItem;
        for (var i = 0, length = dataItems.length; i < length; i++) {
            dataItem = dataItems[i];
            if (dataItem == otherDataItem) {
                result = true;
                break;
            }
        }

        return result;
    },
    close: function() {
        var editplugins = this.editplugins;
        var editplugin;
        for (var i = 0, length = editplugins.length; i < length; i++) {
            editplugin = editplugins[i];
            editplugin.close();
        }

        this.isClosed = true;
        if (this.element) {
            $(this.element).remove();
        }
    }
}