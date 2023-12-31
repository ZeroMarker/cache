/**
 * 自定义项目选择
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180822
 */

(function(global, factory) {
    if (!global.UserDefinedItemView) factory(global.UserDefinedItemView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new UserDefinedItemView(opt);
        return exports.instance;
    }

    exports.open = function() {
        if (exports.instance) exports.instance.open();
        else {
            $.messager.alert('错误', '自定义项目选择界面未初始化', 'icon-error');
        }
    }

    exports.instance = null;

    /**
     * 药品项目属性界面
     * @param {object} opt 
     */
    function UserDefinedItemView(opt) {
        this.options = $.extend(opt, {
            width: 360,
            height: 340
        });
        this.dataCategory = opt.dataCategory;
        this.doQuery = opt.doQuery;
        this.saveHandler = opt.saveHandler;
        this.createItemHandler = opt.createItemHandler;
        this.createview = createview;
        this.itemsview = itemsview;
        this.init();
    }

    UserDefinedItemView.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_ok = $('<a href="#"></a>').linkbutton({
                text: '确定',
                iconCls: 'icon-ok',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.header = $('<div class="userdefineditemview-header"></div>').appendTo(this.dom);
            this.itemContainer = $('<div class="userdefineditemview-body" style="height:200px;"></div>').appendTo(this.dom);

            this.dom.dialog({
                left: 300,
                top: 150,
                height: this.options.height,
                width: this.options.width,
                title: '自定义项目',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.initForm();
            this.initItemContainer();
            this.createview.init(this.createItemHandler, function(result) {
                _this.reloadData();
            });

            this.initiated = true;
        },
        initForm: function() {
            var _this = this;
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 350,
                prompt: '输入简拼或汉字检索',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });
            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });
        },
        initItemContainer: function() {
            var _this = this;
            this.itemContainer.delegate('.userdefined-item', 'click', function() {
                _this.itemContainer.find('.userdefined-item-selected').removeClass('userdefined-item-selected');
                $(this).addClass('userdefined-item-selected');
            });

            this.itemContainer.delegate('.userdefined-item', 'dblclick', function() {
                $(this).addClass('userdefined-item-selected');
                _this.save();
            });

            this.itemContainer.delegate('.userdefined-item-add', 'click', function() {
                _this.createview.open();
            });
        },
        filter: function(filterText) {
            var length = this.items.length;

            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                if (item.Description.indexOf(filterText) >= 0 ||
                    item.Alias.indexOf(filterText) >= 0) {
                    item.target.show();
                } else {
                    item.target.hide();
                }
            }
        },
        /**
         * 设置数据分类
         */
        setDataCategory: function(dataCategory) {
            this.dataCategory = dataCategory;
            this.createview.setDataCategory(dataCategory);
        },
        setItemCategory: function(itemCategory) {
            this.itemCategory = itemCategory;
            this.createview.setItemCategory(itemCategory);
        },
        /**
         * 加载项目数据
         */
        loadData: function(data) {
            this.items = data;
            this.itemsview.render(this.itemContainer, data);
        },
        /**
         * 重新加载项目数据
         */
        reloadData: function() {
            var _this = this;
            if (this.doQuery) {
                this.doQuery({
                    dataCategoryId: this.dataCategory.RowId
                }, function(data) {
                    _this.loadData(data);
                });
            }
        },
        getSelect: function() {
            var selectedItems = this.itemContainer.find('.userdefined-item-selected');
            return selectedItems[0] ? $(selectedItems[0]).data('data') : null;
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.items = [];
            this.itemsview.render(this.itemContainer, this.items);
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 保存
         */
        save: function() {
            var data = this.getSelect();
            if (data && this.saveHandler) {
                this.saveHandler(data);
                this.close();
            }
        }
    }

    var singleItemView = {
        render: function(container, item) {
            container.empty();
            container.data('data', item);
            item.target = container;
            container.append('<span class="icon icon-ok"></span>');
            container.append('<span>' + item.Description + '<span>');
        }
    }

    var itemsview = {
        render: function(container, items) {
            container.empty();
            container.hide();
            var length = items.length;
            var itemRender = singleItemView.render;
            for (var i = 0; i < length; i++) {
                var element = $('<a href="javascript:;" class="userdefined-item"></a>').appendTo(container);
                itemRender(element, items[i]);
            }

            var element = $('<a href="javascript:;" class="userdefined-item userdefined-item-add"><span class="fas fa-plus"></span></a>').appendTo(container);
            container.show();
        }
    }

    var createview = {
        init: function(saveHandler, callback) {
            var _this = this;
            this.saveHandler = saveHandler;
            this.callback = callback;
            this.dom = $('<div></div>').appendTo('body');

            this.form = $('<form class="userdefineditemview-add-form"></form>').appendTo(this.dom);
            this.form.form({});

            var row = $('<div class="editview-f-r"><label class="label">名称：</label></div>').appendTo(this.form);
            this.Description = $('<input type="text" name="Description" style="width:174px;">').appendTo(row);
            this.Description.validatebox({
                required: true,
                novalidate: true
            });

            var row = $('<div class="editview-f-r"><label class="label">简拼：</label></div>').appendTo(this.form);
            this.Alias = $('<input type="text" name="Alias" style="width:174px;">').appendTo(row);
            this.Alias.validatebox({
                required: true,
                novalidate: true
            });

            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);
            this.dom.dialog({
                left: 300,
                top: 150,
                height: 180,
                width: 300,
                title: '创建自定义项目',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

        },
        setDataCategory: function(dataCategory) {
            this.DataCategory = dataCategory;
        },
        setItemCategory: function(itemCategory) {
            this.ItemCategory = itemCategory;
        },
        /**
         * 打开编辑框
         */
        open: function() {
            this.dom.dialog('open');
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.dom.form('clear');
        },
        toData: function() {
            return {
                ItemCategory: this.ItemCategory,
                DataCategory: this.DataCategory.RowId,
                Description: this.Description.validatebox('getValue'),
                Code: this.Alias.validatebox('getValue'),
                Alias: this.Alias.validatebox('getValue'),
                DataType: 'T',
                CreateUser: ''
            }
        },
        save: function() {
            var _this = this;
            var data = this.toData();
            if (this.saveHandler) {
                this.saveHandler(data, function(result) {
                    _this.close();
                    if (_this.callback) _this.callback(result);
                });
            }
        }
    }
}));