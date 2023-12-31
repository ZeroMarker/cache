/**
 * 新增项目选择
 * 初始化的时候才创建并储存一个实例
 * @author yongyang 20180822
 */

(function(global, factory) {
    if (!global.ItemAddView) factory(global.ItemAddView = {});
}(this, function(exports) {

    exports.init = function(opt) {
        exports.instance = new ItemAddView(opt);
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
    function ItemAddView(opt) {
        this.options = $.extend(opt, {
            width: 480,
            height: 400
        });
        this.dataCategory = opt.dataCategory;
        this.doQuery = opt.doQuery;
        this.saveHandler = opt.saveHandler;
        this.createItemHandler = opt.createItemHandler;
        this.createview = createview;
        this.itemsview = itemsview;
        this.userDefinedCategory = { Code: 'UserDefinedItem', Description: '自定义' };
        this.init();
    }

    ItemAddView.prototype = {
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_ok = $('<a href="#"></a>').linkbutton({
                text: '新增<span class="badge iav-adding-badge">0</span>',
                iconCls: 'icon-w-add',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-w-cancel',
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
                title: '新增项目',
                modal: true,
                closed: true,
                buttons: buttons,
                iconCls: 'icon-w-add',
                onOpen: function() {
                    _this.adjust();
                    _this.refreshBadge();
                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.initForm();
            this.initEventHandler();
            this.createview.init(this.createItemHandler, function(result) {
                _this.reloadData();
            });

            this.initiated = true;
        },
        initForm: function() {
            var _this = this;
            var row = $('<div></div>').appendTo(this.header);
            this.searchBox = $('<input type="text">').appendTo(row);
            this.searchBox.searchbox({
                width: 470,
                prompt: '输入简拼或汉字检索',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });
            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.categoryFilterContainer = $('<div></div>').appendTo(this.header);
        },
        initEventHandler: function() {
            var _this = this;
            this.itemContainer.delegate('.userdefined-item', 'click', function() {
                $(this).toggleClass('userdefined-item-selected');
                _this.refreshBadge();
            });

            this.itemContainer.delegate('.userdefined-item', 'dblclick', function() {
                _this.itemContainer.find('.userdefined-item-selected').removeClass('userdefined-item-selected');
                $(this).addClass('userdefined-item-selected');
                _this.save();
            });

            this.itemContainer.delegate('.userdefined-item-add', 'click', function() {
                _this.createview.open();
            });

            this.header.delegate('.iav-item-cat-i', 'click', function() {
                $(this).toggleClass('iav-item-cat-i-selected');
                var category = $(this).data('data');
                var visible = $(this).hasClass('iav-item-cat-i-selected');
                for (var i = 0, length = category.items.length; i < length; i++) {
                    category.items[i].visible = visible;
                }

                var inputRect = _this.searchBox.siblings('.searchbox');
                var text = $(inputRect).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('.iav-item-cat-i', 'dblclick', function() {
                _this.header.find('.iav-item-cat-i-selected').removeClass('iav-item-cat-i-selected');
                $(this).addClass('iav-item-cat-i-selected');
                var category = $(this).data('data');
                for (var i = 0, length = _this.items.length; i < length; i++) {
                    _this.items[i].visible = false;
                }
                for (var i = 0, length = category.items.length; i < length; i++) {
                    category.items[i].visible = true;
                }
                var inputRect = _this.searchBox.siblings('.searchbox');
                var text = $(inputRect).val().toUpperCase();
                _this.filter(text);
            });
        },
        filter: function(filterText) {
            var length = this.items.length;

            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                if (item.visible) {
                    if ((item.Description || item.ItemDesc).indexOf(filterText) >= 0 ||
                        item.Alias.indexOf(filterText) >= 0) {
                        item.target.show();
                    } else {
                        item.target.hide();
                    }
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
            this.renderCategories();
            this.setCategoryItems();
        },
        renderCategories: function() {
            var container = this.categoryFilterContainer;
            container.empty();
            var category = this.dataCategory;
            var subCategory;
            for (var i = 0, length = category.subCategories.length; i < length; i++) {
                subCategory = category.subCategories[i];
                $('<span class="iav-item-cat-i iav-item-cat-i-selected"></span>')
                    .text(subCategory.Description)
                    .data('data', subCategory)
                    .appendTo(container);
            }

            $('<span class="iav-item-cat-i iav-item-cat-i-selected"></span>')
                .text('自定义')
                .data('data', this.userDefinedCategory)
                .appendTo(container);
        },
        setItemCategory: function(itemCategory) {
            this.itemCategory = itemCategory;
            this.createview.setItemCategory(itemCategory);
        },
        /**
         * 加载项目数据
         */
        loadData: function(data) {
            this.userDefinedCategory.items = data;
            var catergoryItems = this.getCategoryItems();
            this.items = catergoryItems.concat(data);
            this.itemsview.render(this.itemContainer, this.items);
        },
        setCategoryItems: function() {
            var categoryItems = [];
            var category = this.dataCategory;
            var subCategory;
            for (var i = 0, length = category.subCategories.length; i < length; i++) {
                subCategory = category.subCategories[i];
                for (var j = 0, itemLen = (subCategory.items || []).length; j < itemLen; j++) {
                    categoryItems.push(subCategory.items[j]);
                }
            }

            this.categoryItems = categoryItems;
        },
        getCategoryItems: function() {
            if (!this.categoryItems) this.setCategoryItems();
            var categoryItems = this.categoryItems || [];

            return categoryItems;
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
        refreshBadge: function() {
            this.dom.find('.iav-adding-badge').text(this.itemContainer.find('.userdefined-item-selected').length);
        },
        getSelectedItems: function() {
            var selectedElements = this.itemContainer.find('.userdefined-item-selected');
            var selectedItems = [];
            for (var i = 0, length = selectedElements.length; i < length; i++) {
                selectedItems.push($(selectedElements[i]).data('data'));
            }

            return selectedItems;
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.items = [];
            this.itemsview.render(this.itemContainer, this.items);
        },
        adjust: function() {
            this.itemContainer.height(this.itemContainer.parent().height() - 25 - this.header.height());
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
            var data = this.getSelectedItems();
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
            item.visible = true;
            container.append('<span class="userdefined-item-check fa fa-check"></span>');
            container.append('<span>' + (item.Description || item.ItemDesc) + '<span>');
        }
    }

    var itemsview = {
        render: function(container, items) {
            container.empty();
            container.hide();
            var length = items.length;
            for (var i = 0; i < length; i++) {
                var element = $('<a href="javascript:;" class="userdefined-item"></a>').appendTo(container);
                singleItemView.render(element, items[i]);
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