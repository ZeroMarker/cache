//
/**
 * 用户模板管理界面
 * @author yongyang 20180419
 */

(function(global, factory) {
    if (!global.usersTemplateManager) factory(global.usersTemplateManager = {});
}(this, function(exports) {
    var cache = {
        categoryItems: [],
        displayCategories: [],
        units: [],
        concentrationUnits: [],
        categoryUserDefItems: {},
        instructions: [],
        userDefinedItems: [],
        intrmiDrugCategories: [],
        drugCategories: []

    }

    function init(opt) {
        cache.categoryItems = opt.categoryItems;
        cache.displayCategories = opt.displayCategories;
        cache.units = opt.units;
        cache.concentrationUnits = opt.concentrationUnits;
        cache.intrmiDrugCategories = opt.intrmiDrugCategories;
        cache.instructions = opt.instructions;
        cache.drugCategories = opt.drugCategories;

        var view = new TemplateManager(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function TemplateManager(opt) {
        this.options = $.extend({ width: 610, height: 400 }, opt);
        this.editview = editview;
        this.applyview = applyview;

        this.saveHandler = opt.saveHandler;
        this.applyHandler = opt.applyHandler;
        this.removeHandler = opt.removeHandler;
        this.getPageDataHandler = opt.getPageDataHandler;
        this.clearEventDataHandler = opt.clearEventDataHandler;
        this.clearDrugDataHandler = opt.clearDrugDataHandler;

        this.templates = null;
        this.loaded = false;

        this.init();
    }

    TemplateManager.prototype = {
        constructor: TemplateManager,
        init: function() {
            this._initDialog();
            this._initTemplateView();
            this._initEditView();
            this._initItemView();
            this._initApplyView();
        },
        _initDialog: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.templateViewContainer = $('<div class="utm-templatecontainer"></div>').appendTo(this.dom);
            this.itemViewContainer = $('<div class="utm-itemcontainer"></div>').appendTo(this.dom);
            var buttons = $('<div></div>');
            var addButton = $('<a href="#" style="float:left;"></a>').linkbutton({
                text: '新建模板',
                iconCls: 'icon-add',
                onClick: function() {
                    editview.changeAppearance({
                        mode: 'Create',
                        title: '新增模板',
                        iconCls: 'icon-add'
                    });
                    editview.open();
                }
            }).appendTo(buttons);
            this.applyButton = $('<a href="#"></a>').linkbutton({
                text: '应用模板',
                iconCls: 'icon-template',
                disabled: true,
                onClick: function() {
                    _this.applyTemplate();
                }
            }).appendTo(buttons);
            var closeButton = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.dom.dialog({
                left: 300,
                top: 70,
                height: this.options.height,
                width: this.options.width,
                title: '用户模板',
                iconCls: 'icon-template',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.applyButton.linkbutton('disable');
                    $('.template-selected').removeClass('template-selected');
                }
            });
        },
        _initTemplateView: function() {
            var _this = this;
            this.templateViewContainer.height(this.options.height - 87).width(this.options.width - 290);
            $(this.templateViewContainer).delegate('.utm-template', 'click', function() {
				if($(this).hasClass("utm-t-edit")||($(this).hasClass("utm-t-remove")))
					return;
                var template = $(this).data('template');
                itemview.render(template.Items);
                $('.template-selected').removeClass('template-selected');
                $(this).addClass('template-selected');
                _this.applyButton.linkbutton('enable');
            });

            $(this.templateViewContainer).delegate('.utm-t-apply', 'click', function() {
                var templateEl = $($(this).parent());
                var template = templateEl.data('template');
                itemview.render(template.Items);
                $('.template-selected').removeClass('template-selected');
                templateEl.addClass('template-selected');
                _this.applyTemplate();
            });

            $(this.templateViewContainer).delegate('.utm-t-edit', 'click', function() {
                var template = $($(this).parent()).data('template');
                _this.editview.render(template);
                _this.editview.changeAppearance({
                    mode: 'Update',
                    title: '修改模板',
                    iconCls: 'icon-edit'
                });
                _this.editview.open();
				setTimeout(function(){
					_this.applyButton.linkbutton('disable');
					$('.template-selected').removeClass('template-selected');
				},500)
            });

            $(this.templateViewContainer).delegate('.utm-t-remove', 'click', function() {
                var target = $($(this).parent());
                var template = target.data('template');
                $.messager.confirm('删除确认', '您确定删除' +
                    (template.Type == 'Public' ? '<span style="color:red;">科室模板</span>' : '个人模板') +
                    ': <b>' + template.Description + '</b> 吗？删除之后将不能撤销',
                    function(confirmed) {
                        if (confirmed) {
                            if (_this.removeHandler) _this.removeHandler(template);
                            target.remove();
							_this.applyButton.linkbutton('disable');
							$('.template-selected').removeClass('template-selected');
                        }
                    });
            });
        },
        _initItemView: function() {
            this.itemViewContainer.height(this.options.height - 87).width(286);
            itemview.init(this.itemViewContainer);
            itemview.render([]);
        },
        _initEditView: function() {
            this.editview.init({
                saveHandler: this.saveHandler,
                getPageDataHandler: this.getPageDataHandler,
                comboDataSource: this.options.comboDataSource,
                eventCategories: this.options.eventCategories,
                intrmiDrugCategories: this.options.intrmiDrugCategories,
                groupSetting: this.options.groupSetting
            });
        },
        _initApplyView: function() {
            var _this = this;
            this.applyview.init({
                applyHandler: this.applyHandler,
                clearEventDataHandler: this.clearEventDataHandler,
                clearDrugDataHandler: this.clearDrugDataHandler,
                callback: function() {
                    _this.close();
                }
            });
        },
        openItemView: function() {
            this.itemViewContainer.show();
            this.templateViewContainer.width(this.options.width - 300);
            this.templateViewContainer.addClass('utm-templateview-narrow');
        },
        closeItemView: function() {
            this.itemViewContainer.hide();
            this.templateViewContainer.width(this.options.width - 20);
            this.templateViewContainer.removeClass('utm-templateview-narrow');
        },
        loadUserDefinedItems: function(items) {
            this.userDefinedItems = items;
            this.userDefinedItemLoaded = true;
            var length = this.userDefinedItems.length;
            var categoryUserDefItems = {};
            for (var i = 0; i < length; i++) {
                var item = this.userDefinedItems[i];
                if (item.DataCategory) {
                    if (categoryUserDefItems[item.DataCategory]) {
                        categoryUserDefItems[item.DataCategory].push(item);
                    } else {
                        categoryUserDefItems[item.DataCategory] = [item];
                    }
                }
            }
            cache.categoryUserDefItems = categoryUserDefItems;
        },
        setRecordStartDT: function(dateTime) {
            cache.recordStartDT = dateTime;
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        loadData: function(data) {
            this.templates = data;
            var canEditPublic = (this.options.groupSetting.DeptTemplate == 'Y');
            templateview.render(this.templateViewContainer, data, canEditPublic);
            this.loaded = true;
        },
        applyTemplate: function() {
            var _this = this;
            var pageData = null;
            var selectedTemplate = this.templateViewContainer.find('.template-selected');
            var template = $(selectedTemplate).data('template');
            if (this.getPageDataHandler) {
                pageData = this.getPageDataHandler();
            }
            this.applyview.render(template);
            this.applyview.setPageData(pageData);
            this.applyview.open();
        }
    }

    var templateview = {
        render: function(container, data, canEditPublic) {
            container.empty();
            var UserID = session['UserID'];
            var publicContainer = $('<div class="utm-t-container"></div>')
                .append('<div class="utm-t-container-header"><span class="header-text">科室模板</span></div>')
                .appendTo(container);
            var publicBodyContainer = $('<div class="utm-t-container-body"></div>').appendTo(publicContainer);
            var privateContainer = $('<div class="utm-t-container"></div>')
                .append('<div class="utm-t-container-header"><span class="header-text">个人模板</span></div>')
                .appendTo(container);
            var privateBodyContainer = $('<div class="utm-t-container-body"></div>').appendTo(privateContainer);

            $.each(data, function(index, row) {
                var rowElement = $('<a href="#" class="utm-template"></a>');
                rowElement.append('<span class="utm-t-button utm-t-apply icon-arrow-right" title="应用此模板"></span>');
                if (row.Type === 'Public') {
                    if (canEditPublic) rowElement.append('<span class="utm-t-button utm-t-edit icon-edit" title="编辑此模板"></span>')
                        .append('<span class="utm-t-button utm-t-remove icon-cancel" title="删除此模板"></span>');
                    rowElement.appendTo(publicBodyContainer);
                } else {
                    rowElement.append('<span class="utm-t-button utm-t-edit icon-edit" title="编辑此模板"></span>')
                        .append('<span class="utm-t-button utm-t-remove icon-cancel" title="删除此模板"></span>')
                        .appendTo(privateBodyContainer);
                }
                rowElement.data('template', row);
                $('<span class="utm-template-details"></span>')
                    .html('<span>' + row.Description + '</span>')
                    .attr('title', row.Note)
                    .appendTo(rowElement);

            });
        }
    }

    var itemview = {
        init: function(container) {
            this.tree = $('<ul></ul>').appendTo(container);
            this.tree.tree({
                checkbox: false
            });
        },
        render: function(data) {
            this.tree.tree('loadData', loadFilter(data || []));
        }
    }

    var applyview = {
        init: function(opt) {
            var _this = this;
            this.options = opt;
            this.dom = $('<div></div>').appendTo('body');

            var buttons = $('<div></div>');
            var saveButton = $('<a href="#"></a>').linkbutton({
                text: '应用',
                iconCls: 'icon-template',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var closeButton = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.infoContainer = $('<div></div>').appendTo(this.dom);

            this.paramsContainer = $('<div style="border-top:1px solid #eee;padding-top:5px;"></div>').appendTo(this.dom);
            this.form = $('<form class="utm-editview-form"></form>')
                .form({})
                .appendTo(this.paramsContainer);

            this.dom.dialog({
                left: 400,
                top: 50,
                height: 550,
                width: 480,
                title: '应用模板',
                modal: true,
                closed: true,
                iconCls: 'icon-template',
                buttons: buttons,
                onOpen: function() {},
                onClose: function() {
                    _this.clear();
                }
            });

            this.initForm();
        },
        initForm: function() {
            var _this = this;
            var group = $('<div class="shortcutview-group" style="margin-bottom:15px;"></div>').appendTo(this.form);
            var header = $('<div class="shortcutview-group-header"></div>')
                .append('<span class="header-text">药品数据</span>')
                .appendTo(group);
            var itemsContainer = $('<div class="shortcutview-group-items"></div>').appendTo(group);

            var row = $('<div class="utm-editview-f-r"></div>')
                .appendTo(itemsContainer);
            var radio = $('<input type="radio" value="Y" checked name="DrugAccordingToTemplate" label="按模板设定分钟间隔生成">').appendTo(row);
            radio.radio({
                required: true
            });

            var row = $('<div class="utm-editview-f-r"></div>')
                .appendTo(itemsContainer);
            var radio = $('<input type="radio" value="N" name="DrugAccordingToTemplate" label="按此时间生成：">').appendTo(row);
            radio.radio({
                required: true,
                onCheckChange: function(e, value) {
                    if (value) {
                        _this.DrugStartDT.datetimebox('enable');
                        _this.DrugStartDT.datetimebox('setValue', cache.recordStartDT.format('yyyy-MM-dd HH:mm:ss'));
                    } else _this.DrugStartDT.datetimebox('disable');
                }
            });
            this.DrugStartDT = $('<input type="text" name="DrugStartDT">').appendTo(row);
            this.DrugStartDT.datetimebox({
                width: 200,
                disabled: true,
                onChange: function(newValue, oldValue) {
                    $(this).datetimebox('normalize');
                }
            });
            this.DrugStartDT.datetimebox('initiateWheelListener');
            this.DrugStartDT.datetimebox('initiateKeyUpListener');

            var row = $('<div class="utm-editview-f-r"></div>')
                .appendTo(itemsContainer);
            var checkbox = $('<input type="checkbox" checked=false name="RemoveDrugDataInPage" label="删除页面已有数据">').appendTo(row);
            checkbox.checkbox({
                checked: false
            });

            var group = $('<div class="shortcutview-group"></div>').appendTo(this.form);
            var header = $('<div class="shortcutview-group-header"></div>')
                .append('<span class="header-text">事件数据</span>')
                .appendTo(group);
            var itemsContainer = $('<div class="shortcutview-group-items"></div>').appendTo(group);

            var row = $('<div class="utm-editview-f-r"></div>')
                .appendTo(itemsContainer);
            var radio = $('<input type="radio" value="Y" checked name="EventAccordingToTemplate" label="按模板设定分钟间隔生成">').appendTo(row);
            radio.radio({
                required: true
            });

            var row = $('<div class="utm-editview-f-r"></div>')
                .appendTo(itemsContainer);
            var radio = $('<input type="radio" value="N" name="EventAccordingToTemplate" label="按此时间生成：">').appendTo(row);
            radio.radio({
                required: true,
                onCheckChange: function(e, value) {
                    if (value) {
                        _this.EventStartDT.datetimebox('enable');
                        _this.EventStartDT.datetimebox('setValue', cache.recordStartDT.format('yyyy-MM-dd HH:mm:ss'));
                    } else _this.EventStartDT.datetimebox('disable');
                }
            });
            this.EventStartDT = $('<input type="text" name="EventStartDT">').appendTo(row);
            this.EventStartDT.datetimebox({
                width: 200,
                disabled: true,
                onChange: function(newValue, oldValue) {
                    $(this).datetimebox('normalize');
                }
            });
            this.EventStartDT.datetimebox('initiateWheelListener');
            this.EventStartDT.datetimebox('initiateKeyUpListener');

            var row = $('<div class="utm-editview-f-r"></div>')
                .appendTo(itemsContainer);
            var checkbox = $('<input type="checkbox" checked=false name="RemoveEventDataInPage" label="删除页面已有数据">').appendTo(row);
            checkbox.checkbox({
                checked: false
            });
        },
        render: function(template) {
            this.default();
            this.template = template;
            this.infoContainer.empty();
            this.infoContainer.data('data', template);

            var header = $('<div style="height:30px;text-align:center;font-size:15px;font-weight:bold;position:relative;margin-top:5px;"></div>').appendTo(this.infoContainer);
            header.text(template.Description);
            if (template.Type == 'Public') $('<div style="position:absolute;top:0px;left:5px;font-size:11px;color:#fff;background-color:#A164F3;padding:3px 8px;border-radius:15px;">科室模板</div>').appendTo(header);
            else $('<div style="position:absolute;top:0px;left:5px;font-size:11px;color:#fff;background-color:#50B2EE;padding:3px 8px;border-radius:15px;">个人模板</div>').appendTo(header);

            var body = $('<div style="overflow:hidden;"></div>').appendTo(this.infoContainer);

            var itemContainer = $('<div style="width:230px;float:left;padding:5px;"></div>').appendTo(body);
            var dataContainer = $('<div style="width:230px;float:left;padding:5px;"></div>').appendTo(body);

            var itemSummary = $('<div style="height:20px;text-align:center;"></div>').appendTo(itemContainer);
            var itemDetails = $('<div style="overflow-x:hidden;overflow-y:auto;height:100px;"></div>').appendTo(itemContainer);
            var dataSummary = $('<div style="height:20px;text-align:center;"></div>').appendTo(dataContainer);
            var dataDetails = $('<div style="overflow-x:hidden;overflow-y:auto;height:100px;"></div>').appendTo(dataContainer);

            itemSummary.text('项目');
            $('<b style="color:#3C8FC2;margin-left:5px;"></b>').text((template.Items || []).length).appendTo(itemSummary);

            dataSummary.text('数据');
            $('<b style="color:#3C8FC2;margin-left:5px;"></b>').text((template.Data || []).length).appendTo(dataSummary);

            var list = $('<ul></ul>').appendTo(itemDetails);
            var row;
            for (var i = 0, length = (template.Items || []).length; i < length; i++) {
                row = template.Items[i];
                $('<li></li>').text(row.Description || row.DataItemDesc).appendTo(list);
            }

            var list = $('<ul></ul>').appendTo(dataDetails);
            var row, element;
            for (var i = 0, length = (template.Data || []).length; i < length; i++) {
                row = template.Data[i];
                element = $('<li></li>').appendTo(list);
                dataview.render(element, row, true);
            }
        },
        setPageData: function(pageData) {
            this.pageData = pageData;
        },
        validate: function() {
            var data = this.toData();
            if (data.DrugAccordingToTemplate == 'N') {
                var startDT = new Date().tryParse(data.DrugStartDT);
                startDT = startDT.addSeconds(1);
                if (startDT < cache.recordStartDT) {
                    $.messager.alert('设定时间不可用', '数据开始时间不能小于当前页面开始时间<b style="color:red;">' + (cache.recordStartDT.format('yyyy-MM-dd HH:mm:ss')) + '</b>', 'warning');
                    this.DrugStartDT.datetimebox('focus');
                    this.DrugStartDT.datetimebox('warn');
                    return false;
                }
            }

            if (data.EventAccordingToTemplate == 'N') {
                var startDT = new Date().tryParse(data.EventStartDT);
                startDT = startDT.addSeconds(1);
                if (startDT < cache.recordStartDT) {
                    $.messager.alert('设定时间不可用', '数据开始时间不能小于当前页面开始时间<b style="color:red;">' + (cache.recordStartDT.format('yyyy-MM-dd HH:mm:ss')) + '</b>', 'warning');
                    this.EventStartDT.datetimebox('focus');
                    this.EventStartDT.datetimebox('warn');
                    return false;
                }
            }

            return true;
        },
        toData: function() {
            var data = this.form.serializeJson();
            return data;
        },
        save: function() {
            var _this = this;
            var pageData = this.pageData;
            var template = this.template;
            var params = this.toData();

            if (!this.validate()) return;

            if (pageData && pageData.length > 0 &&
                template.Data && template.Data.length > 0) {
                if (params.RemoveDrugDataInPage == 'on') doClearDrugData();
                if (params.RemoveEventDataInPage == 'on') doClearEventData();
            }

            doApply();

            function doClearEventData() {
                if (_this.options.clearEventDataHandler) {
                    _this.options.clearEventDataHandler();
                }
            }

            function doClearDrugData() {
                if (_this.options.clearDrugDataHandler) {
                    _this.options.clearDrugDataHandler();
                }
            }

            function doApply() {
                if (template && _this.options.applyHandler) {
                    _this.options.applyHandler(template.RowId, params);
                    _this.close();
                }

                if (_this.options.callback) {
                    _this.options.callback();
                }

                $.messager.popover({ type: "success", timeout: 1500, msg: "应用模板成功。" });
            }
        },
        default: function() {
            this.form.form('load', {
                DrugAccordingToTemplate: 'Y',
                DrugStartDT: '',
                EventAccordingToTemplate: 'Y',
                EventStartDT: ''
            });
            this.form.find('input[value="Y"]').radio('check');
            this.DrugStartDT.datetimebox('disable');
            this.EventStartDT.datetimebox('disable');
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.infoContainer.empty();
            this.form.form('clear');
            var checkboxes = this.form.find('input[type="checkbox"]');
            checkboxes.checkbox('setValue', false);
            $(checkboxes.parent()).removeClass('checked');
        }
    }

    var editview = {
        init: function(opt) {
            var _this = this;
            this.options = opt;
            this.saveHandler = opt.saveHandler;
            this.getPageDataHandler = opt.getPageDataHandler;
            this.categoryItemSelectionView = categoryItemSelectionView;
            this.itemAttrView = itemAttrView;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var splitMenu = $('<div style="width:120px;"></div>').appendTo('body');
            splitMenu.menu({});
            splitMenu.menu("appendItem", {
                text: '项目',
                height: 25,
                onclick: function() {
                    _this.appendItemsOnCurrentPage();
                }
            });
            splitMenu.menu("appendItem", {
                text: '数据',
                height: 25,
                onclick: function() {
                    _this.appendDatasOnCurrentPage();
                }
            });
            var pasteButton = $('<a href="#" style="float:left;"></a>').menubutton({
                text: '当前页',
                menu: splitMenu,
                iconCls: 'icon-copy'
            }).appendTo(buttons);

            var saveButton = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            var closeButton = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.form = $('<form class="utm-editview-form"></form>')
                .form({})
                .appendTo(this.dom);

            this.dom.dialog({
                left: 400,
                top: 70,
                height: 500,
                width: 480,
                title: '新增模板',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {
                    _this.removedItems = [];
                    _this.removedDatas = [];
                },
                onClose: function() {
                    _this.clear();
                }
            });

            var nameRow = $('<div class="utm-editview-f-r"></div>')
                .append('<div class="label">模板名：</div>')
                .appendTo(this.form);
            this.TemplateName = $('<input type="text" name="Description" style="width:177px;">').appendTo(nameRow);
            this.TemplateName.validatebox({
                width: 180,
                required: true
            });

            var groupSetting = this.options.groupSetting || {};
            var typeRow = $('<div class="utm-editview-f-r"></div>')
                .append('<div class="label">模板类型：</div>')
                .appendTo(this.form);
            this.TemplateType = $('<input type="text" name="Type" style="width:180px;">').appendTo(typeRow);
            this.TemplateType.combobox({
                width: 183,
                data: [{ text: '科室模板', value: 'Public' }, { text: '个人模板', value: 'Private' }]
            });
            if (groupSetting.DeptTemplate != 'Y') typeRow.hide();

            var noteRow = $('<div class="utm-editview-f-r"></div>')
                .append('<div class="label">备注：</div>')
                .appendTo(this.form);
            this.TemplateNote = $('<input type="text" name="Note" style="width:177px;">').appendTo(noteRow);
            this.TemplateNote.validatebox({
                width: 180,
                height: 50,
                novalidate: true,
                multiline: true
            });

            var itemRow = $('<div class="utm-editview-f-r"></div>')
                .append('<div class="label">模板项目：</div>')
                .appendTo(this.form);
            this.TemplateItemContainer = $('<div class="utm-editview-f-i-tree"></div>').appendTo(itemRow);

            this.tree = $('<ul></ul>').appendTo(this.TemplateItemContainer);
            this.tree.tree({
                checkbox: false,
                dnd: true,
                //data: loadFilter(cache.categoryItems || []),
                onBeforeDrag: function(node) {
                    if (node.attributes.type === 'category') return false;
                },
                onBeforeDrop: function(target, source, point) {
                    if (point === 'append') return false;
                    var node = $(this).tree('getNode', target);
                    if (node.attributes.type === 'category') return false;
                    if (node.attributes.categoryId != source.attributes.categoryId) return false;
                    return true;
                }
            });
            //this.uncheckAll();
            this.loadCategory();

            this.tree.delegate('.tree-node-add', 'click', function() {
                var target = $(this).parent().parent().parent();
                var node = _this.tree.tree('getNode', target);
                var category = node.attributes.data;
                var categoryId = category.dataCategory.RowId;
                _this.categoryItemSelectionView.setCallback(function(categoryItem) {
                    _this.insertItem(node, categoryId, categoryItem);
                });
                var userDefinedItems = cache.categoryUserDefItems[categoryId] || [];
                _this.categoryItemSelectionView.render(category.dataCategory.subCategories, userDefinedItems);
                _this.categoryItemSelectionView.position($(this).offset());
                _this.categoryItemSelectionView.open();
            });

            this.tree.delegate('.tree-node-remove', 'click', function() {
                var target = $(this).parent().parent().parent();
                var node = _this.tree.tree('getNode', target);
                var item = node.attributes.data;
                if (node.attributes.type = 'templateItem') {
                    _this.removeTemplateItem(item);
                }
                _this.tree.tree('remove', target);

            });

            this.tree.delegate('.tree-node-up', 'click', function() {
                var target = $(this).parent().parent().parent();
                var node = _this.tree.tree('getNode', target);
                var item = node.attributes.data;
                if (node.attributes.type = 'templateItem') {
                    console.log(item);
                    var preItem = $(node).prev();
                    console.log("pre:" + preItem);
                }
                // _this.tree.tree('remove', target);

            });


            this.tree.delegate('.tree-node-attr', 'click', function() {
                var nodeText = $(this).parent();
                var target = $(this).parent().parent().parent();
                var node = _this.tree.tree('getNode', target);
                var item = node.attributes.data;
                if (node.attributes.type = 'templateItem') {
                    _this.itemAttrView.setCallback(function(templateItem) {
                        $(nodeText).attr('title', '浓度：' + (templateItem.Concentration ? templateItem.Concentration + templateItem.ConcentrationUnitDesc : '') +
                            '\n单位：' + (templateItem.UnitDesc || '') +
                            (templateItem.DoseUnitVisible === 'Y' ? '\n显示剂量单位' : '\n不显示剂量单位') +
                            (templateItem.SpeedUnitVisible === 'Y' ? '\n显示速度单位' : '\n不显示速度单位') +
                            (templateItem.ConcentrationVisible === 'Y' ? '\n显示浓度' : '\n不显示浓度') +
                            (templateItem.Continuous === 'Y' ? '\n默认持续' : '\n不默认持续') +
                            ('\n默认持续分钟数' + templateItem.Duration));
                    });
                    _this.itemAttrView.render(item);
                    _this.itemAttrView.position($(this).offset());
                    _this.itemAttrView.open();
                }
            });

            var dataRow = $('<div class="utm-editview-f-r"></div>')
                .append('<div class="label">模板数据：</div>')
                .appendTo(this.form);
            this.TemplateDataContainer = $('<div class="utm-editview-f-r-data"></div>').appendTo(dataRow);

            this.TemplateDataContainer.delegate('.shortcutview-item-remove', 'click', function(e) {
                var event = e || window.event;
                event.preventDefault();
                event.stopPropagation();

                var data = $($(this).parent()).data('data');
                data.ClassName = ANCLS.Config.UserPreferedData;
                _this.removeTemplateData(data);
                $($(this).parent()).remove();

                event.returnValue = false;
                return false;
            });

            this.TemplateDataContainer.delegate('.shortcutview-item-add', 'click', function() {
                var key = $(this).attr('data-key');
                var pos = $(this).offset();
                _this.openCreateView(key, null, pos);
            });

            this.categoryItemSelectionView.init();
            this.itemAttrView.init();
            this.initDataCreators();
        },
        /**
         * 初始化数据创建编辑框
         */
        initDataCreators: function() {
            var _this = this;
            this.drugDataCreator = drugDataCreator;
            this.eventDataCreator = eventDataCreator;
            this.intrmiDrugDataCreator = intrmiDrugDataCreator;

            this.drugDataCreator.init({
                onOpen: function() {
                    //_this.closeSelectionViews(this)
                },
                onSave: function(data) {
                    _this.prependData(data);
                }
            });
            this.drugDataCreator.setComboDataSource(this.options.comboDataSource);

            this.eventDataCreator.init({
                eventCategories: this.options.eventCategories,
                onOpen: function() {
                    //_this.closeSelectionViews(this)
                },
                onSave: function(data) {
                    _this.prependData(data);
                }
            });

            this.intrmiDrugDataCreator.init({
                onOpen: function() {
                    //_this.closeSelectionViews(this)
                },
                onSave: function(data) {
                    _this.prependData(data);
                }
            });
            this.intrmiDrugDataCreator.setComboDataSource(this.options.comboDataSource);
        },
        /**
         * 加载选中模板
         * @param {object<Data.Template>} template
         */
        render: function(template) {
            //把关联数据项的所有数据都加载到此处
            this.editingTemplate = template;
            this.TemplateName.validatebox('setValue', template.Description);
            this.TemplateNote.validatebox('setValue', template.Note);
            this.TemplateType.combobox('setValue', template.Type);
            this.renderItems(template.Items || []);
            this.renderData(template.Data || []);
        },
        /**
         * 加载当前页的数据项目或选中模板的项目
         * @param {Array<Data.TemplateItem>} items
         */
        renderItems: function(items) {
            var nodes = [];
            $.each(cache.displayCategories, function(index, displayCategory) {
                if (typeof displayCategory.removable === 'boolean' && !displayCategory.removable) return true;
                var categoryId = displayCategory.dataCategory.RowId;
                var node = {
                    id: 'c_' + categoryId,
                    text: '<span class="tree-node-item">' + displayCategory.title + '<a href="#" class="tree-node-item-icon tree-node-add icon-add" title="添加项目"></a></span>',
                    iconCls: 'tree-folder-open',
                    state: 'opened',
                    children: [],
                    attributes: {
                        data: displayCategory,
                        type: 'category'
                    }
                }

                var length = items.length;
                var item = null;
                for (var i = 0; i < length; i++) {
                    item = items[i];
                    if (item.Category === categoryId) {
                        node.children.push({
                            id: 'i_' + (item.CategoryItem ? ('c_' + item.CategoryItem) : ('u_' + item.UserDefinedItem)),
                            text: '<span class="tree-node-item" title="' + '浓度：' + (item.Concentration ? item.Concentration + item.ConcentrationUnitDesc : '') +
                                '\n单位：' + (item.UnitDesc || '') +
                                (item.DoseUnitVisible === 'Y' ? '\n显示剂量单位' : '\n不显示剂量单位') +
                                (item.SpeedUnitVisible === 'Y' ? '\n显示速度单位' : '\n不显示速度单位') +
                                (item.ConcentrationVisible === 'Y' ? '\n显示浓度' : '\n不显示浓度') +
                                (item.Continuous === 'Y' ? '\n默认持续' : '\n不默认持续') +
                                ('\n默认持续分钟数' + item.Duration) +
                                '">' +
                                (item.ItemDesc || item.Description) +
                                '<a href="#" class="tree-node-item-icon tree-node-attr icon-write-order" title="项目属性设置"></a>' +
                                '<a href="#" class="tree-node-item-icon tree-node-remove icon-cancel" title="删除此项目"></a></span>',
                            attributes: {
                                data: item,
                                type: 'templateItem',
                                categoryId: categoryId
                            }
                        });
                    }
                }
                nodes.push(node);
            });

            this.tree.tree('loadData', nodes);
        },
        insertItem: function(node, categoryId, item) {
            var templateItem = {
                RowId: '',
                CategoryItem: isCategoryItem(item) ? item.RowId : '',
                UserDefinedItem: isCategoryItem(item) ? '' : item.RowId,
                Code: item.ItemCode || item.Code,
                Description: item.ItemDesc || item.Description,
                DataCategory: item.DataCategory,
                ItemCategory: item.ItemCategory,
                DataItem: item.DataItem
            };

            this.tree.tree('append', {
                parent: node.target,
                data: [{
                    id: 'i_' + (templateItem.CategoryItem ? ('c_' + templateItem.CategoryItem) : ('u_' + templateItem.UserDefinedItem)),
                    text: '<span class="tree-node-item" title="' + '浓度：' + (templateItem.Concentration ? templateItem.Concentration + templateItem.ConcentrationUnitDesc : '') +
                        '\n单位：' + (templateItem.UnitDesc || '') +
                        (templateItem.DoseUnitVisible === 'Y' ? '\n显示剂量单位' : '\n不显示剂量单位') +
                        (templateItem.SpeedUnitVisible === 'Y' ? '\n显示速度单位' : '\n不显示速度单位') +
                        (templateItem.ConcentrationVisible === 'Y' ? '\n显示浓度' : '\n不显示浓度') +
                        (templateItem.Continuous === 'Y' ? '\n默认持续' : '\n不默认持续') +
                        ('\n默认持续分钟数' + templateItem.Duration) +
                        '">' +
                        (templateItem.Description) +
                        '<a href="#" class="tree-node-item-icon tree-node-attr icon-write-order" title="项目属性设置"></a>' +
                        '<a href="#" class="tree-node-item-icon tree-node-remove icon-cancel" title="删除此项目"></a></span>',
                    attributes: {
                        data: templateItem,
                        type: 'templateItem',
                        categoryId: categoryId
                    }
                }]
            });

            function isCategoryItem(item) {
                return item.DataItem;
            }
        },
        /**
         * 移除项目
         * @param {*} item 
         */
        removeTemplateItem: function(item) {
            this.removedItems.push(item);
        },
        /**
         * 移除数据
         * @param {*} data 
         */
        removeTemplateData: function(data) {
            this.removedDatas.push(data);
        },
        /**
         * 加载当前页面数据
         */
        appendItemsOnCurrentPage: function() {
            this.removeAllItem();
            var nodes = [];
            $.each(cache.displayCategories, function(index, displayCategory) {
                if (typeof displayCategory.removable === 'boolean' && !displayCategory.removable) return true;
                var categoryId = displayCategory.dataCategory.RowId;
                var node = {
                    id: 'c_' + categoryId,
                    text: '<span class="tree-node-item">' + displayCategory.title + '<a href="#" class="tree-node-item-icon tree-node-add icon-add" title="添加项目"></a></span>',
                    iconCls: 'tree-folder-open',
                    state: 'opened',
                    children: [],
                    attributes: {
                        data: displayCategory,
                        type: 'category'
                    }
                }

                var displayItems = displayCategory.displayItems;
                var length = displayItems.length;
                var displayItem = null;
                for (var i = 0; i < length; i++) {
                    displayItem = displayItems[i];
                    var templateItem = {
                        RowId: '',
                        CategoryItem: displayItem.CategoryItem,
                        UserDefinedItem: displayItem.UserDefinedItem,
                        Code: displayItem.Code,
                        Description: (displayItem.ItemDesc || displayItem.Description),
                        DataCategory: displayItem.DataCategory,
                        ItemCategory: displayItem.ItemCategory,
                        DataItem: displayItem.DataItem,
                        Unit: displayItem.Unit,
                        UnitDesc: displayItem.UnitDesc,
                        DoseUnitVisible: displayItem.DoseUnitVisible,
                        SpeedUnitVisible: displayItem.SpeedUnitVisible,
                        ConcentrationVisible: displayItem.ConcentrationVisible,
                        Concentration: displayItem.Concentration,
                        ConcentrationUnit: displayItem.ConcentrationUnit,
                        ConcentrationUnitDesc: displayItem.ConcentrationUnitDesc,
                        Continuous: displayItem.Continuous,
                        Duration: displayItem.Duration
                    };
                    node.children.push({
                        id: 'i_' + (displayItem.CategoryItem ? ('c_' + displayItem.CategoryItem) : ('u_' + displayItem.UserDefinedItem)),
                        text: '<span class="tree-node-item" title="' + '浓度：' + (templateItem.Concentration ? templateItem.Concentration + templateItem.ConcentrationUnitDesc : '') +
                            '\n单位：' + (templateItem.UnitDesc || '') +
                            (templateItem.DoseUnitVisible === 'Y' ? '\n显示剂量单位' : '\n不显示剂量单位') +
                            (templateItem.SpeedUnitVisible === 'Y' ? '\n显示速度单位' : '\n不显示速度单位') +
                            (templateItem.ConcentrationVisible === 'Y' ? '\n显示浓度' : '\n不显示浓度') +
                            (templateItem.Continuous === 'Y' ? '\n默认持续' : '\n不默认持续') +
                            ('\n默认持续分钟数' + templateItem.Duration) +
                            '">' +
                            (displayItem.ItemDesc || displayItem.Description) +
                            '<a href="#" class="tree-node-item-icon tree-node-attr icon-write-order" title="项目属性设置"></a>' +
                            '<a href="#" class="tree-node-item-icon tree-node-remove icon-cancel" title="删除此项目"></a></span>',
                        attributes: {
                            data: templateItem,
                            type: 'templateItem',
                            categoryId: categoryId
                        }
                    });
                }
                nodes.push(node);
            });

            this.tree.tree('loadData', nodes);
        },
        /**
         * 移除所有项目
         */
        removeAllItem: function() {
            var removedItems = this.removedItems;
            var nodes = this.tree.tree('getRoots');
            $.each(nodes, function(index, categoryNode) {
                var itemNodes = categoryNode.children;
                var length = itemNodes.length;
                var itemNode = null;
                seq = 1;

                for (var i = 0; i < length; i++) {
                    itemNode = itemNodes[i];
                    var item = itemNode.attributes.data;
                    if (itemNode.attributes.type = 'templateItem') {
                        removedItems.push(item);
                    }
                }
            });
            this.removedItems = removedItems;
        },
        appendDatasOnCurrentPage: function() {
            if (this.getPageDataHandler) {
                var data = this.getPageDataHandler();
                var templateDataList = this.regulatePageDatas(data);
                this.renderData(templateDataList);
            }
        },
        prependData: function(addingData) {
            var container = this.TemplateDataContainer;
            var groupContainer = container.find('.shortcutview-group[data-key="' + addingData.Type + '"]');
            if (groupContainer.length > 0) {
                var itemsContainer = groupContainer.find('.shortcutview-group-items');
                var element = $('<a href="#" class="shortcutview-item"></a>').prependTo(itemsContainer);
                dataview.render(element, addingData);
            }
        },
        renderData: function(data) {
            var groups = groupingData(data);
            var container = this.TemplateDataContainer;
            this.removeAllTempData();
            var length = groups.length;
            for (var i = 0; i < length; i++) {
                var group = groups[i];
                element = $('<div class="shortcutview-group"></div>').appendTo(container);
                groupView.render(element, groups[i]);

                var element = $('<a href="javascript:;" class="shortcutview-item-add" data-key="' + group.key + '"><span class="fas fa-plus"></span></a>').appendTo(element);
            }
            return this;
        },
        openCreateView: function(key, data, pos) {
            switch (key) {
                case 'D':
                    this.drugDataCreator.open();
                    if (data) this.drugDataCreator.loadData(data);
                    break;
                case 'E':
                    this.eventDataCreator.open();
                    if (data) this.eventDataCreator.loadData(data);
                    break;
                case 'I':
                    this.intrmiDrugDataCreator.open();
                    if (data) this.intrmiDrugDataCreator.loadData(data);
                    break;
                default:
                    break;
            }
        },
        /**
         * 移除所有模板中用户偏好数据
         */
        removeAllTempData: function() {
            var removedDatas = this.removedDatas || [];
            this.TemplateDataContainer.find('.shortcutview-item').each(function(index, element) {
                var row = $(element).data('data');
                removedDatas.push(row);
            });
            this.TemplateDataContainer.empty();
            this.removedDatas = removedDatas;
        },
        regulatePageDatas: function(data) {
            var regulatedData = [];
            var length = data.length;
            for (var i = 0; i < length; i++) {
                var row = data[i];
                var timeSpanMinutes = '';
                if (row.ItemCategory == 'V') continue;
                if (row.Continuous == 'Y') timeSpanMinutes = 0;
                if (row.EndDT < MAXDATE) timeSpanMinutes = new TimeSpan(row.EndDT, row.StartDT).totalMinutes;
                var type = row.ItemCategory;
                if (this.isIntrmiDrugData(row)) type = 'I';

                //if (type === 'D' || type == '') continue;

                var regulatedRow = {
                    Continuous: row.Continuous,
                    TimeSpanMinutes: timeSpanMinutes,
                    DataValue: '',
                    Category: row.DataCategory,
                    CategoryItem: row.CategoryItem,
                    UserDefinedItem: row.UserDefinedItem,
                    DataItem: row.DataItem,
                    Description: row.Description || row.DataItemDesc,
                    GenerateTimeSpan: Math.round(new TimeSpan(row.StartDT, cache.recordStartDT).totalMinutes),
                    Type: type
                }

                if (row.DrugData) {
                    regulatedRow.DrugData = $.extend({}, row.DrugData, {
                        RowId: ''
                    });

                    var drugDataList = [];
                    drugDataList.push(regulatedRow.DrugData);
                    var drugDataLength = row.DrugDataList.length;
                    for (var j = 1; j < drugDataLength; j++) {
                        drugDataList.push($.extend({}, row.DrugDataList[j], { RowId: '' }));
                    }

                    regulatedRow.DrugDataList = drugDataList;
                }

                if (row.EventDetailDatas && row.EventDetailDatas.length) {
                    var eventDetailList = [];

                    var eventDataLength = row.EventDetailDatas.length;
                    for (var j = 0; j < eventDataLength; j++) {
                        eventDetailList.push($.extend({}, row.EventDetailDatas[j], { RowId: '' }));
                    }

                    regulatedRow.EventDetailDatas = eventDetailList;
                }

                regulatedData.push(regulatedRow);
            }

            return regulatedData;
        },
        isIntrmiDrugData: function(data) {
            if (!this.intrmiDrugCategoryIdList) {
                this.intrmiDrugCategoryIdList = [];
                var length = cache.intrmiDrugCategories.length;
                for (var i = 0; i < length; i++) {
                    this.intrmiDrugCategoryIdList.push(cache.intrmiDrugCategories[i].RowId);
                }
            }
            var categoryId = data.DataCategory;
            return this.intrmiDrugCategoryIdList.indexOf(categoryId) > -1;
        },
        loadCategory: function() {
            var nodes = [];
            $.each(cache.displayCategories, function(index, displayCategory) {
                if (typeof displayCategory.removable === 'boolean' && !displayCategory.removable) return true;
                if (!displayCategory.dataCategory) return true;
                var categoryId = displayCategory.dataCategory.RowId;
                var node = {
                    id: 'c_' + categoryId,
                    text: '<span class="tree-node-item">' + displayCategory.title + '<a href="#" class="tree-node-item-icon tree-node-add icon-add" title="添加项目"></a></span>',
                    iconCls: 'tree-folder-open',
                    state: 'opened',
                    children: [],
                    attributes: {
                        data: displayCategory,
                        type: 'category'
                    }
                }
                nodes.push(node);
            });

            this.tree.tree('loadData', nodes);
        },
        changeAppearance: function(appearance) {
            this.dom.dialog(appearance);
            if (appearance.mode == 'Create') {
                this.renderData([]);
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
            this.itemAttrView.close();
        },
        clear: function() {
            this.editingTemplate = null;
            this.form.form('clear');
            this.TemplateDataContainer.empty();
            this.loadCategory();
            this.itemAttrView.close();
        },
        save: function() {
			if (this.TemplateName.val()=="")
			{
				$.messager.popover({ type: "error",msg: "模板名不能为空" })
				return;
			}
            var nodes = this.tree.tree('getRoots');
            var tree = this.tree;
            var templateId = this.editingTemplate ? this.editingTemplate.RowId : '';
            var savingDatas = [];
            var seq = 1;
            var guid = dhccl.guid();
            if (this.editingTemplate) {
                savingDatas.push({
                    ClassName: ANCLS.Config.ModuleTemplate,
                    RowId: this.editingTemplate.RowId,
                    Description: this.TemplateName.val(),
                    Note: this.TemplateNote.val(),
                    Type: this.TemplateType.combobox('getValue') || '',
                    UpdateUserID: session['UserID'],
                    UpdateDate: new Date().format('yyyy-MM-dd'),
                    UpdateTime: new Date().format('HH:mm:ss'),
                    Guid: guid
                });
            } else {
                savingDatas.push({
                    ClassName: ANCLS.Config.ModuleTemplate,
                    RowId: '',
                    Description: this.TemplateName.val(),
                    Note: this.TemplateNote.val(),
                    Type: this.TemplateType.combobox('getValue') || '',
                    DataModule: session.ModuleID,
                    DeptID: session['DeptID'],
                    UserID: session['UserID'],
                    UpdateUserID: session['UserID'],
                    UpdateDate: new Date().format('yyyy-MM-dd'),
                    UpdateTime: new Date().format('HH:mm:ss'),
                    Guid: guid
                });
            }

            $.each(nodes, function(index, categoryNode) {
                var itemNodes = categoryNode.children;
                var length = itemNodes.length;
                var itemNode = null;
                seq = 1;

                for (var i = 0; i < length; i++) {
                    itemNode = itemNodes[i];
                    savingDatas.push(TemplateItem(itemNode));
                }
            });

            $.each(this.removedItems, function(index, templateItem) {
                if (templateItem.RowId)
                    savingDatas.push($.extend({}, templateItem, {
                        ClassName: ANCLS.Config.ModuleTmplItem,
                        TemplateGuid: guid,
                        isRemoved: 'Y',
                        target: ''
                    }));
            });

            $.each(this.removedDatas, function(index, templateData) {
                if (templateData.RowId)
                    savingDatas.push($.extend({}, templateData, {
                        ClassName: ANCLS.Config.UserPreferedData,
                        TemplateGuid: guid,
                        isRemoved: 'Y',
                        target: '',
                        DrugDataList: '',
                        DrugData: '',
                        EventDetailDatas: ''
                    }));
            });

            var UserPreferedDataClassName = ANCLS.Config.UserPreferedData;
            var UserPreferedDrugClassName = ANCLS.Config.UserPreferedDrug;
            var UserPreferedEventClassName = ANCLS.Config.UserPreferedEventDetail;

            this.TemplateDataContainer.find('.shortcutview-item').each(function(index, element) {
                var row = $(element).data('data');
                var dataGuid = dhccl.guid();
                savingDatas.push($.extend({}, row, {
                    ClassName: UserPreferedDataClassName,
                    Permission: 'Private',
                    TemplateGuid: guid,
                    Guid: dataGuid,
                    DrugDataList: '',
                    DrugData: '',
                    EventDetailDatas: '',
                    target: ''
                }));

                if (row.DrugData && !row.DrugDataList) {
                    savingDatas.push($.extend(row.DrugData, {
                        ClassName: UserPreferedDrugClassName,
                        TemplateGuid: guid,
                        DataGuid: dataGuid,
                        target: ''
                    }));
                }

                if (row.DrugDataList && row.DrugDataList.length) {
                    var drugLength = row.DrugDataList.length;
                    for (var i = 0; i < drugLength; i++) {
                        savingDatas.push($.extend(row.DrugDataList[i], {
                            ClassName: UserPreferedDrugClassName,
                            TemplateGuid: guid,
                            DataGuid: dataGuid,
                            target: ''
                        }));
                    }
                }

                if (row.EventDetailDatas && row.EventDetailDatas.length) {
                    var eventLength = row.EventDetailDatas.length;
                    for (var i = 0; i < eventLength; i++) {
                        savingDatas.push($.extend(row.EventDetailDatas[i], {
                            ClassName: UserPreferedEventClassName,
                            TemplateGuid: guid,
                            DataGuid: dataGuid,
                            target: ''
                        }));
                    }
                }
            });

            var msg = (this.editingTemplate) ? '保存模板成功。' : '新增模板成功。';
            if (this.saveHandler) {
                this.saveHandler.call(this, savingDatas);
            }

            this.close();
            $.messager.popover({ type: "success", timeout: 1500, msg: msg });

            function TemplateItem(itemNode) {
                var attrs = itemNode.attributes;
                var oldTemplateItem = attrs.templateItem;
                if (oldTemplateItem) return $.extend(oldTemplateItem, { Seq: seq++ });
                var categoryItem = attrs.data;
                var categoryId = attrs.categoryId;
                var type = attrs.type;
                return type === 'templateItem' ?
                    $.extend(categoryItem, {
                        ClassName: ANCLS.Config.ModuleTmplItem,
                        Template: templateId,
                        Seq: seq++,
                        Category: categoryId,
                        TemplateGuid: guid
                    }) : {
                        ClassName: ANCLS.Config.ModuleTmplItem,
                        RowId: '',
                        Template: templateId,
                        CategoryItem: categoryItem.RowId,
                        Code: categoryItem.ItemCode,
                        Description: categoryItem.ItemDesc,
                        DataCategory: categoryItem.DataCategory,
                        ItemCategory: categoryItem.ItemCategory,
                        DataItem: categoryItem.DataItem,
                        Category: categoryId,
                        Seq: seq++,
                        TemplateGuid: guid
                    };
            }
        }
    }

    /**
     * 单条数据渲染
     */
    var dataview = {
        render: function(dom, data, viewState) {
            dom.data('data', data);
            dom.empty();
            data.target = dom;

            var title = '数据时间：入手术间之后' + (data.GenerateTimeSpan || 0) + '分钟';

            var text = data.Description;
            if (data.Type == "D" && data.DrugData) {
                if (data.DrugData.Speed) text = text + data.DrugData.Speed + data.DrugData.SpeedUnitDesc;
                else if (data.DrugData.DoseQty) text = text + data.DrugData.DoseQty + data.DrugData.DoseUnitDesc;
                if (data.DrugData.Concentration) text = text + data.DrugData.Concentration + data.DrugData.ConcentrationUnitDesc;
                if (data.DrugData.TCI === 'Y') text = text + ' TCI';
            }
            if (data.Type == 'I') {
                var textArr = [];
                if (data.DrugDataList) {
                    var length = data.DrugDataList.length;
                    for (var i = 0; i < length; i++) {
                        var drugData = data.DrugDataList[i];
                        textArr.push((drugData.Description || drugData.ArcimDesc) + " " +
                            drugData.DoseQty + drugData.DoseUnitDesc +
                            (drugData.InstructionDesc ? (" " + drugData.InstructionDesc) : "") +
                            (drugData.Note ? (" " + drugData.Note) : ""));
                    }
                    text = textArr.join('<br/>');
                }
            }
            if (data.Type == 'E') {
                if (!data.EventDetail && data.EventDetailDatas) {
                    var length = data.EventDetailDatas.length;
                    var textArr = [];
                    for (var i = 0; i < length; i++) {
                        var eventData = data.EventDetailDatas[i];
                        textArr.push(eventData.EventDetailDesc + ":" +
                            eventData.DataValue + eventData.DataUnit);
                    }

                    data.EventDetail = textArr.join('\n');
                }
				if(data.EventDetail)
					title = title + '\n' + data.EventDetail;
            }

            dom.attr('title', title);

            if (data.Continuous === 'Y') text = text + ' 持续';
            if (data.TimeSpanMinutes && Number(data.TimeSpanMinutes) > 0) text = text + data.TimeSpanMinutes + '分钟';

            dom.append(text);
            if (!viewState) dom.append('<span class="shortcutview-item-remove item-button icon icon-cancel" title="删除此快捷数据"></span>');
        }
    }

    /**
     * 数据分组渲染
     */
    var groupView = {
        render: function(dom, group) {
            dom.data('data', group);
            dom.empty();
            dom.attr('data-key', group.key);
            group.target = dom;
            var header = $('<div class="shortcutview-group-header"></div>')
                .append('<span class="header-text">' + group.desc + '</span>')
                .appendTo(dom);

            var itemsContainer = $('<div class="shortcutview-group-items"></div>').appendTo(dom);

            var items = group.items;
            var length = items.length;
            var item = null,
                element = null;
            for (var j = 0; j < length; j++) {
                item = items[j];
                element = $('<a href="#" class="shortcutview-item"></a>').appendTo(itemsContainer);
                dataview.render(element, item);
            }
        }
    }

    /**
     * 将数据分组
     * @param {*} data
     */
    function groupingData(data) {
        var types = ['D', 'E', 'I'];
        var groups = [{
            key: 'D',
            desc: '用药',
            items: []
        }, {
            key: 'E',
            desc: '事件',
            items: []
        }, {
            key: 'I',
            desc: '间断给药',
            items: []
        }];
        var length = data.length;
        var row = null,
            index = -1;
        for (var i = 0; i < length; i++) {
            row = data[i];
            index = types.indexOf(row.Type);
            if (index > -1) {
                groups[index].items.push(row);
            } else {
                types.push(row.Type);
                groups.push({
                    key: row.Type,
                    desc: row.TypeDesc,
                    items: [row]
                })
            }
        }

        return groups;
    }

    /**
     * 项目属性
     */
    var itemAttrView = {
        closed: false,
        init: function() {
            var _this = this;
            this.dom = $('<div class="intrmidrugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="intrmidrugeditor-selectionview-container" style="width:340px;"></div>').appendTo(this.dom);
            this.close();

            this.form = $('<form class="itemattrview-form"></form>').appendTo(this.container);
            this.form.form({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"></div>').appendTo(this.form);
            var label = $('<div class="label">浓度：</div>').appendTo(row);
            this.Concentration = $('<input class="textbox" type="text" name="ConcentrationUnit" style="width:83px;margin-right:5px;">').appendTo(row);
            this.Concentration.validatebox({
                width: 90,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit = $('<input type="text" name="ConcentrationUnit">').appendTo(row);
            this.ConcentrationUnit.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 85,
                cls: 'drugeditor-editview-f-r-unit',
                data: cache.concentrationUnits
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">单位：</div>').appendTo(row);
            this.Unit = $('<input type="text" name="Unit">').appendTo(row);
            this.Unit.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 180,
                label: label,
                data: cache.units
            });

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="utm_DoseUnitVisible" class="label">显示剂量单位：</label></div>').appendTo(this.form);
            this.DoseUnitVisible = $('<input id="utm_DoseUnitVisible" type="checkbox" name="DoseUnitVisible">').appendTo(row);
            this.DoseUnitVisible.checkbox({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="utm_SpeedUnitVisible" class="label">显示速度单位：</label></div>').appendTo(this.form);
            this.SpeedUnitVisible = $('<input id="utm_SpeedUnitVisible" type="checkbox" name="SpeedUnitVisible">').appendTo(row);
            this.SpeedUnitVisible.checkbox({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="utm_ConcentrationVisible" class="label">显示浓度：</label></div>').appendTo(this.form);
            this.ConcentrationVisible = $('<input id="utm_ConcentrationVisible" type="checkbox" name="ConcentrationVisible">').appendTo(row);
            this.ConcentrationVisible.checkbox({});

            var row = $('<div class="editview-f-r" data-itemcategory="D"><label for="utm_InstructionVisible" class="label">显示用法：</label></div>').appendTo(this.form);
            this.InstructionVisible = $('<input id="utm_InstructionVisible" type="checkbox" name="InstructionVisible">').appendTo(row);
            this.InstructionVisible.checkbox({});

            var row = $('<div class="editview-f-r"><label for="utm_Continuous" class="label">默认持续：</label></div>').appendTo(this.form);
            this.Continuous = $('<input id="utm_Continuous" type="checkbox" name="Continuous">').appendTo(row);
            this.Continuous.checkbox({});

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            $('<span class="label">默认持续分钟数：</span>').appendTo(row);
            this.Duration = $('<input type="text" name="Duration">').appendTo(row);
            this.Duration.numberbox({
                width: 90,
                prompt: '默认持续分钟数'
            });

            var row = $('<div class="editview-f-r" data-itemcategory="D"></div>').appendTo(this.form);
            var label = $('<div class="label">用药途径：</div>').appendTo(row);
            this.Instruction = $('<input type="text" name="Instruction">').appendTo(row);
            this.Instruction.combobox({
                textField: 'Description',
                valueField: 'RowId',
                width: 180,
                label: label,
                data: cache.instructions
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">备注：</div>').appendTo(row);
            this.Note = $('<input type="text" name="Note" style="width:173px;">').appendTo(row);
            this.Note.validatebox({
                width: 180,
                label: label,
                novalidate: true
            });

            this.bottom = $('<div style="text-align:center;"></div>').appendTo(this.container);
            this.btn_ok = $('<a href="#"></a>').linkbutton({
                text: '确定',
                iconCls: 'icon-ok',
                onClick: function() {
                    _this.save();
                    _this.close();
                }
            }).appendTo(this.bottom);

            return this;
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 渲染
         */
        render: function(templateItem) {
            this.templateItem = templateItem;
            this.Unit.combobox('setValue', templateItem.Unit);
            this.DoseUnitVisible.checkbox('setValue', templateItem.DoseUnitVisible === 'Y');
            this.SpeedUnitVisible.checkbox('setValue', templateItem.SpeedUnitVisible === 'Y');
            this.ConcentrationVisible.checkbox('setValue', templateItem.ConcentrationVisible === 'Y');
            this.InstructionVisible.checkbox('setValue', templateItem.InstructionVisible === 'Y');
            this.Continuous.checkbox('setValue', templateItem.Continuous === 'Y');
            this.Duration.numberbox('setValue', templateItem.Duration);
            this.Concentration.validatebox('setValue', templateItem.Concentration);
            this.ConcentrationUnit.combobox('setValue', templateItem.ConcentrationUnit);
            this.Instruction.combobox('setValue', templateItem.Instruction);
            this.Note.validatebox('setValue', templateItem.Note);

            if (templateItem.ItemCategory == "D") {
                this.dom.find('div[data-itemcategory="D"]').show();
            } else {
                this.dom.find('div[data-itemcategory="D"]').hide();
            }

            return this;
        },
        save: function() {
            this.templateItem.Unit = this.Unit.combobox('getValue');
            this.templateItem.UnitDesc = this.Unit.combobox('getText');
            this.templateItem.DoseUnitVisible = this.DoseUnitVisible.prop('checked') ? 'Y' : 'N';
            this.templateItem.SpeedUnitVisible = this.SpeedUnitVisible.prop('checked') ? 'Y' : 'N';
            this.templateItem.ConcentrationVisible = this.ConcentrationVisible.prop('checked') ? 'Y' : 'N';
            this.templateItem.InstructionVisible = this.InstructionVisible.prop('checked') ? 'Y' : 'N';
            this.templateItem.Continuous = this.Continuous.prop('checked') ? 'Y' : 'N';
            this.templateItem.Duration = this.Duration.numberbox('getValue');
            this.templateItem.Concentration = this.Concentration.validatebox('getValue');
            this.templateItem.ConcentrationUnit = this.ConcentrationUnit.combobox('getValue') || '';
            this.templateItem.ConcentrationUnitDesc = this.ConcentrationUnit.combobox('getText') || '';
            this.templateItem.Instruction = this.Instruction.combobox('getValue') || '';
            this.templateItem.InstructionDesc = this.Instruction.combobox('getText') || '';
            this.templateItem.Note = this.Note.validatebox('getValue') || '';
            if (this.callback) this.callback(this.templateItem);
        },
        /**
         * 打开项目属性编辑框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭项目属性编辑框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left + 30, top: position.top - 20 });
            return this;
        }
    }

    /**
     * 分类项目选择
     */
    var categoryItemSelectionView = {
        closed: false,
        init: function() {
            var _this = this;
            this.dom = $('<div class="intrmidrugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="intrmidrugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="intrmidrugeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter();
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter();
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            return this;
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 渲染
         */
        render: function(dataCategories, userDefinedItems) {
            this.items = [];
            var items = [];
            var container = this.itemContainer;
            container.empty();
            var length = dataCategories.length;
            for (var i = 0; i < length; i++) {
                $.each(dataCategories[i].items || [], function(index, categoryItem) {
                    var element = null;
                    element = $('<a href="#" class="categoryitem-button"></a>').text(categoryItem.ItemDesc).appendTo(container);
                    element.data('data', categoryItem);
                    categoryItem.target = element;
                    items.push(categoryItem);
                });
            }

            var length = userDefinedItems.length;
            for (var i = 0; i < length; i++) {
                var item = userDefinedItems[i];
                var element = null;
                element = $('<a href="#" class="categoryitem-button"></a>').text(item.Description).appendTo(container);
                element.data('data', item);
                item.target = element;
                items.push(item);
            }
            this.items = items;
            return this;
        },
        filter: function(filterString) {
            var _this = this;
            var length = this.items.length;
            var filterString = filterString;
            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                var desc = item.ItemDesc.toUpperCase();
                var alias = item.Alias || '';
                if (!filterString ||
                    desc.indexOf(filterString) > -1 ||
                    alias.indexOf(filterString) > -1
                ) {
                    item.target.show();
                } else {
                    item.target.hide();
                }
            }
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left + 30, top: position.top - 20 });
            return this;
        }
    }

    /**
     * 药品数据创建界面
     */
    var drugDataCreator = {
        init: function(opt) {
            var _this = this;
            this.options = opt;
            this.canChangeCategoryItem = true;
            this.dom = $('<div></div>').appendTo('body');
            this.form = $('<form class="drugeditor-editview-form"></form>').appendTo(this.dom);

            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
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
                top: 50,
                height: 450,
                width: 320,
                title: '模板用药数据',
                modal: false,
                closed: true,
                iconCls: 'icon-drug',
                buttons: buttons,
                resizable: false,
                onOpen: function() {
                    if (_this.options.onOpen)
                        _this.options.onOpen.call(_this);
                },
                onClose: function() {
                    _this.clear();
                }
            });
            this.initForm();

            this.drugCateItemSelectionView = drugCateItemSelectionView;
            this.drugCateItemSelectionView.init(function(categoryItem) {
                _this.setCategoryItem(categoryItem);
            });
            this.drugCateItemSelectionView.render(cache.drugCategories);

            this.arcimSelectionView = arcimSelectionView;
            this.arcimSelectionView.init(function(arcimItem) {
                _this.setArcimItem(arcimItem);
            });
        },
        initForm: function() {
            var _this = this;
            this.form.form({});

            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            this.CategoryRowId = $('<input type="hidden" name="Category">').appendTo(this.form);

            var itemRow = $('<div class="drugeditor-editview-f-r"><div class="label">药品项：</div></div>').appendTo(this.form);
            this.CategoryItem = $('<span class="drugeditor-editview-drugitem" style="width:164px;"></span>').appendTo(itemRow);
            this.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(itemRow);
            this.DataItemRowId = $('<input type="hidden" name="DataItem">').appendTo(itemRow);
            this.UserDefinedItemRowId = $('<input type="hidden" name="UserDefinedItem">').appendTo(itemRow);
            this.CategoryItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var itemRow = $('<div class="drugeditor-editview-f-r"><div class="label">医嘱项：</div></div>').appendTo(this.form);
            this.ArcimItem = $('<span class="drugeditor-editview-drugitem" style="width:164px;"></span>').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.ArcimItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            this.CategoryItemButton.click(function() {
                if (_this.canChangeCategoryItem) {
                    _this.drugCateItemSelectionView.position($(_this.CategoryItem).offset());
                    _this.drugCateItemSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.CategoryItem.click(function() {
                if (_this.canChangeCategoryItem) {
                    _this.drugCateItemSelectionView.position($(this).offset());
                    _this.drugCateItemSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.ArcimItemButton.click(function() {
                if (_this.arcimSelectionView) {
                    _this.arcimSelectionView.position($(_this.ArcimItem).offset());
                    _this.arcimSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            this.ArcimItem.click(function() {
                if (_this.arcimSelectionView) {
                    _this.arcimSelectionView.position($(this).offset());
                    _this.arcimSelectionView.open();
                    $(this).addClass('drugeditor-editview-drugitem-selected');
                }
            });

            var timeRow = $('<div class="drugeditor-editview-f-r" title="将在入手术间后多少分钟添加此数据"></div>').appendTo(this.form);
            var label = $('<div class="label">入室后分钟</div>').appendTo(timeRow);
            this.GenerateTimeSpan = $('<input type="text">').appendTo(timeRow);
            this.GenerateTimeSpan.numberbox({
                width: 200,
                disabled: false,
                label: label
            });

            var itemRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<label class="label" for="utm_drugeditor_continuous">持续：</label>').appendTo(itemRow);
            this.Continuous = $('<input id="utm_drugeditor_continuous" type="checkbox" name="Continuous">').appendTo(itemRow);
            this.Continuous.checkbox({
                onChecked: function(e, value) {
                    _this.TimeSpanMinutes.numberbox('enable');

                    _this.Speed.validatebox('enable');
                    _this.SpeedUnit.combobox('enable');
                },
                onUnchecked: function(e, value) {
                    _this.TimeSpanMinutes.numberbox('disable');
                    _this.TimeSpanMinutes.numberbox('setValue', 0);

                    _this.Speed.validatebox('disable');
                    _this.SpeedUnit.combobox('disable');
                }
            });

            var label = $('<label class="label" for="utm_drugeditor_tci" style="float:none;display:inline-block;">靶控：</label>').appendTo(itemRow);
            this.TCI = $('<input id="utm_drugeditor_tci" type="checkbox" name="TCI">').appendTo(itemRow);
            this.TCI.checkbox({
                onChecked: function(e, value) {
                    _this.Continuous.checkbox('setValue', true);
                },
                onUnchecked: function(e, value) {
                    _this.Continuous.checkbox('setValue', false);
                }
            });

            var timeRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">持续分钟：</div>').appendTo(timeRow);
            this.TimeSpanMinutes = $('<input type="text">').appendTo(timeRow);
            this.TimeSpanMinutes.numberbox({
                width: 200,
                disabled: true,
                label: label
            });

            var doseRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">剂量：</div>').appendTo(doseRow);
            this.DoseQty = $('<input class="textbox" type="text" style="width:93px;margin-right:5px;">').appendTo(doseRow);
            this.DoseUnit = $('<input type="text">').appendTo(doseRow);
            this.DoseQty.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.DoseUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var speedRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">速度：</div>').appendTo(speedRow);
            this.Speed = $('<input class="textbox" type="text" disabled style="width:93px;margin-right:5px;">').appendTo(speedRow);
            this.SpeedUnit = $('<input type="text">').appendTo(speedRow);
            this.Speed.validatebox({
                width: 100,
                label: label,
                novalidate: true,
                disabled: true
            });
            this.SpeedUnit.combobox({
                width: 95,
                disabled: true,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var concentrationRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">浓度：</div>').appendTo(concentrationRow);
            this.Concentration = $('<input class="textbox" type="text" style="width:93px;margin-right:5px;">').appendTo(concentrationRow);
            this.ConcentrationUnit = $('<input type="text">').appendTo(concentrationRow);
            this.Concentration.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'drugeditor-editview-f-r-unit'
            });

            var instructionRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            this.Instruction = $('<input type="text">').appendTo(instructionRow);
            this.Instruction.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var reasonRow = $('<div class="drugeditor-editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            this.Reason = $('<input type="text">').appendTo(reasonRow);
            this.Reason.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var receiveLocRow = $('<div class="drugeditor-editview-f-r" style="display:none;"></div>').appendTo(this.form);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            this.RecvLoc = $('<input type="text">').appendTo(receiveLocRow);
            this.RecvLoc.combobox({
                width: 200,
                valueField: "Id",
                textField: "Desc",
                label: label
            });
        },
        loadData: function(data) {
            if (data) {
                this.originalData = data;
                this.Speed.validatebox("setValue", data.DrugData.Speed);
                this.ArcimID.val(data.DrugData.ArcimID);
                this.DrugItem.text(data.DrugData.ArcimDesc);
                this.RecvLoc.combobox("setValue", data.DrugData.RecvLoc);
                this.RecvLoc.combobox("setText", data.DrugData.RecvLocDesc);
                this.DoseQty.validatebox("setValue", data.DrugData.DoseQty);
                this.DoseUnit.combobox("setValue", data.DrugData.DoseUnit);
                this.Speed.validatebox("setValue", data.DrugData.Speed);
                this.SpeedUnit.combobox("setValue", data.DrugData.SpeedUnit);
                this.Concentration.validatebox("setValue", data.DrugData.Concentration);
                this.ConcentrationUnit.combobox("setValue", data.DrugData.ConcentrationUnit);
                this.Instruction.combobox("setValue", data.DrugData.Instruction);
                this.Reason.combobox("setText", data.DrugData.Reason);
                this.Continuous.checkbox('setValue', data.Continuous === 'Y' ? true : false);
                this.TCI.checkbox('setValue', data.DrugData.TCI === 'Y' ? true : false);
                this.TimeSpanMinutes.numberbox('setValue', data.TimeSpanMinutes);
                this.GenerateTimeSpan.numberbox('setValue', data.GenerateTimeSpan);
                this.CategoryRowId.val(data.Category);
                this.CategoryItem.text(data.DrugData.Description);
                this.CategoryItemRowId.val(data.CategoryItem);
                this.DataItemRowId.val(data.DrugData.DataItem);
            }
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.SpeedUnit.combobox('loadData', dataList.SpeedUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        setCategoryItem: function(categoryItem) {
            this.CategoryItem.text(categoryItem.ItemDesc);
            this.CategoryItemRowId.val(categoryItem.RowId);
            this.DataItemRowId.val(categoryItem.DataItem);
            this.ArcimItem.text('');
            this.ArcimID.val('');
            this.arcimSelectionView.render(categoryItem);
            if (categoryItem.arcimItems &&
                categoryItem.arcimItems.length > 0) {
                this.setArcimItem(categoryItem.arcimItems[0]);
            }
        },
        setArcimItem: function(arcimItem) {
            this.ArcimItem.attr('title', arcimItem.ArcimDesc || arcimItem.Description)
                .text(arcimItem.ArcimDesc || arcimItem.Description);
            this.ArcimID.val(arcimItem.ArcimID);
            if (!(this.originalData && this.originalData.DrugData) && arcimItem.DoseQty) {
                this.DoseQty.validatebox("setValue", arcimItem.DoseQty);
            }
            if (!(this.originalData && this.originalData.DrugData) && arcimItem.ANDoseUom) {
                this.DoseUnit.combobox("setValue", arcimItem.ANDoseUom);
            }
        },
        setItem: function(item) {
            if (item.DataItem) {
                this.CategoryItem.text(item.ItemDesc);
                this.CategoryRowId.val(item.DataCategory);
                this.CategoryItemRowId.val(item.RowId);
                this.DataItemRowId.val(item.DataItem);
            } else {
                this.CategoryItem.text(item.Description);
                this.UserDefinedItemRowId.val(item.RowId);
            }
        },
        /**
         * 清空表单项
         */
        clear: function() {
            this.form.form('clear');
            this.originalData = null;
            this.CategoryItem.text('');
            this.CategoryItemRowId.val('');
            this.ArcimItem.text('');
            this.ArcimID.val('');
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
        toData: function() {
            return {
                Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                TimeSpanMinutes: this.TimeSpanMinutes.numberbox('getValue'),
                GenerateTimeSpan: this.GenerateTimeSpan.numberbox('getValue') || 0,
                DataValue: '',
                Category: this.CategoryRowId.val(),
                CategoryItem: this.CategoryItemRowId.val(),
                UserDefinedItem: this.UserDefinedItemRowId.val(),
                DataItem: this.DataItemRowId.val(),
                Description: this.CategoryItem.text(),
                Type: 'D',
                DrugData: {
                    DoseQty: this.DoseQty.validatebox("getValue"),
                    DoseUnit: this.DoseUnit.combobox("getValue"),
                    Instruction: this.Instruction.combobox("getValue"),
                    Concentration: this.Concentration.validatebox("getValue"),
                    ConcentrationUnit: this.ConcentrationUnit.combobox("getValue"),
                    Speed: this.Speed.validatebox("getValue"),
                    SpeedUnit: this.SpeedUnit.combobox("getValue"),
                    BalanceQty: "",
                    Reason: this.Reason.combobox("getText"),
                    BalanceDisposal: "",
                    RecvLoc: this.RecvLoc.combobox('getValue'),
                    ArcimID: this.ArcimID.val(),
                    OrderItemID: "",
                    DoseUnitDesc: this.DoseUnit.combobox("getText"),
                    SpeedUnitDesc: this.SpeedUnit.combobox("getText"),
                    ConcentrationUnitDesc: this.ConcentrationUnit.combobox("getText"),
                    InstructionDesc: this.Instruction.combobox("getText"),
                    ArcimDesc: this.ArcimItem.text(),
                    RecvLocDesc: this.RecvLoc.combobox('getText'),
                    Continuous: this.Continuous.checkbox('getValue') ? 'Y' : 'N',
                    Description: this.CategoryItem.text(),
                    DataItem: this.DataItemRowId.val(),
                    UserDefinedItem: this.UserDefinedItemRowId.val(),
                    TCI: this.TCI.checkbox('getValue') ? 'Y' : 'N'
                }
            }
        },
        /**
         * 保存
         */
        save: function() {
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                newData = $.extend(originalData, newData);
                newData.DrugData = $.extend(originalData.DrugData, newData.DrugData);
            }

            if (this.options.onSave) this.options.onSave.call(this, newData);
            this.close();
        },
        position: function(pos) {

        }
    }

    /**
     * 药品项选择
     */
    var drugCateItemSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="drugeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter();
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter();
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="drugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
                _this.close();
            });

            return this;
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 渲染
         */
        render: function(dataCategories) {
            this.items = [];
            var items = [];
            var container = this.itemContainer;
            container.empty();
            var length = dataCategories.length;
            for (var i = 0; i < length; i++) {
                var dataCategory = dataCategories[i];
                var subCatLength = dataCategory.subCategories.length;
                for (var j = 0; j < subCatLength; j++) {
                    var subCategory = dataCategory.subCategories[j];
                    $.each(subCategory.items || [], function(index, categoryItem) {
                        var element = null;
                        element = $('<a href="#" class="categoryitem-button"></a>').text(categoryItem.ItemDesc).appendTo(container);
                        element.data('data', categoryItem);
                        categoryItem.target = element;
                        items.push(categoryItem);
                    });
                }
            }
            this.items = items;
            return this;
        },
        filter: function(filterString) {
            var _this = this;
            var length = this.items.length;
            var filterString = filterString;
            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                var desc = item.ItemDesc.toUpperCase();
                var alias = item.Alias || '';
                if (!filterString ||
                    desc.indexOf(filterString) > -1 ||
                    alias.indexOf(filterString) > -1
                ) {
                    item.target.show();
                } else {
                    item.target.hide();
                }
            }
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
    }

    var arcimSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="drugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="drugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="drugeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 190,
                prompt: '输入简拼或汉字检索',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter();
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            })

            this.itemContainer = $('<div class="drugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.drug-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });
        },
        render: function(categoryItem) {
            this.arcimItems = categoryItem.arcimItems || [];
            this.renderItems(this.arcimItems);
        },
        renderItems: function(arcimItems) {
            var container = this.itemContainer;
            container.empty();
            $.each(arcimItems, function(index, arcimItem) {
                var element = null;
                element = $('<a href="#" class="drug-button"></a>')
                    .text(arcimItem.ArcimDesc || arcimItem.Description)
                    .attr('title', arcimItem.ArcimDesc || arcimItem.Description)
                    .appendTo(container);
                element.data('data', arcimItem);
            });
        },
        filter: function(filterString) {
            var _this = this;
            // if (filterString === '') {
            //     this.renderItems(this.drugItems);
            // } else {
            //     dhccl.getDatas(ANCSP.DataQuery, {
            //         ClassName: CLCLS.BLL.Admission,
            //         QueryName: "FindMasterItem",
            //         Arg1: filterString,
            //         ArgCnt: 1
            //     }, 'json', true, function(data) {
            //         _this.renderItems(data);
            //     });
            // }
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
        }
    }

    /**
     * 事件数据创建界面
     */
    var eventDataCreator = {
        init: function(opt) {
            var _this = this;
            this.options = opt;
            this.canChangeCategoryItem = true;
            this.eventSelectionView = eventSelectionView;
            this.dom = $('<div></div>').appendTo('body');
            this.form = $('<form class="eventeditor-form"></form>').appendTo(this.dom);

            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
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
                top: 50,
                height: 450,
                width: 350,
                title: '模板事件数据',
                modal: false,
                closed: true,
                iconCls: 'icon-event',
                buttons: buttons,
                resizable: false,
                onOpen: function() {
                    if (_this.options.onOpen)
                        _this.options.onOpen.call(_this);
                },
                onClose: function() {
                    _this.clear();
                }
            });
            this.initForm();
        },
        initForm: function() {
            var _this = this;
            this.form.form({});

            $(this.form).delegate('input', 'focus', function() {
                if (!_this.eventSelectionView.closed) _this.eventSelectionView.close();
            });
            $(this.form).delegate('textarea', 'focus', function() {
                if (!_this.eventSelectionView.closed) _this.eventSelectionView.close();
            });

            this.eventSelectionView.init(function(categoryItem) {
                _this.render(categoryItem);
                _this.EventName.removeClass('eventeditor-f-r-event-selected');
            });
            this.eventSelectionView.render(this.options.eventCategories);

            this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            this.DataItemRowId = $('<input type="hidden" name="DataItem">').appendTo(this.form);
            this.DataCategoryRowId = $('<input type="hidden" name="DataCategory">').appendTo(this.form);
            this.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(this.form);
            this.UserDefinedItemRowId = $('<input type="hidden" name="UserDefDataItem">').appendTo(this.form);

            var eventNameRow = $('<div class="eventeditor-f-r" style="height:32px;"><div class="label">事件名称：</div></div>').appendTo(this.form);
            this.EventName = $('<span class="eventeditor-f-r-event" title="单击修改事件" style="width:139px;"></span>').appendTo(eventNameRow);
            this.EventItem = $('<input type="hidden" name="EventItem">').appendTo(eventNameRow);
            this.EventNameButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;height:28px;"><span class="icon icon-template" style="margin-top:5px;margin-left:2px;"></span></span>').appendTo(eventNameRow);

            this.EventName.click(function() {
                _this.showEventSelectionView();
            });

            this.EventNameButton.click(function() {
                _this.showEventSelectionView();
            });

            var timeRow = $('<div class="eventeditor-f-r" title="将在入手术间后多少分钟添加此数据"></div>').appendTo(this.form);
            var label = $('<div class="label">入室后分钟：</div>').appendTo(timeRow);
            this.GenerateTimeSpan = $('<input type="text" style="width:180px;">').appendTo(timeRow);
            this.GenerateTimeSpan.numberbox({
                width: 180,
                disabled: false,
                label: label
            });

            var detailsRow = $('<div class="eventeditor-f-r"></div>').appendTo(this.form);
            this.detailsContainer = $('<div class="eventeditor-f-details"></div>').appendTo(detailsRow);
        },
        /**
         * 渲染
         */
        render: function(categoryItem) {
            var details = [];
            this.categoryItem = null;
            this.incompleteRender = true;
            this.EventDetails = [];

            if (categoryItem) {
                if (typeof categoryItem === 'string') {
                    categoryItem = this.getCategoryItemById(categoryItem);
                }
                this.categoryItem = categoryItem;
                details = categoryItem.eventDetailItems;
                this.EventName.text(categoryItem.ItemDesc);
                this.EventItem.val(categoryItem.RowId);
                this.renderDetails(details);
                this.incompleteRender = false;
            }

            this.setItem(categoryItem);
        },
        renderDetails: function(details) {
            var EventDetails = [];

            var detailsContainer = this.detailsContainer;
            detailsContainer.empty();
            $.each(details, function(index, item) {
                var width = Number(item.EditorSize.split(',')[0] || 180);
                var height = Number(item.EditorSize.split(',')[1] || 30);
                var editor = $('<input type="text">').width(item.EditorSize);
                editor.data('detailItem', item);

                var row = $('<div class="eventeditor-f-d-r"></div>')
                    .append($('<div class="label"></div>').text(item.Description + '：'))
                    .append(editor)
                    .append($('<span class="unit"></span>').text(item.Unit))
                    .appendTo(detailsContainer);

                if (editor[item.Editor]) {
                    editor[item.Editor]({
                        width: width,
                        height: height,
                        novalidate: true,
                        validator: function() {

                        }
                    });
                }

                if (item.Editor === 'tagbox') {
                    editor[item.Editor]({
                        "hasDownArrow": true,
                        "multiple": true,
                        "selectOnNavigation": false,
                        "editable": false
                    });
                }

                if (item.Editor === 'combobox' || item.Editor === 'tagbox') {
                    var detailOptions = [];
                    var optionStr = item.ValueRange;
                    var optionArr = optionStr.split(';');
                    var length = optionArr.length;
                    for (var i = 0; i < length; i++) {
                        detailOptions.push({
                            text: optionArr[i],
                            value: optionArr[i]
                        });
                    }
                    editor[item.Editor]('loadData', detailOptions);
                }

                EventDetails.push(editor);
            });

            this.EventDetails = EventDetails;
        },
        loadData: function(eventData) {
            if (data.RowId) {
                this.originalData = data;
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
                this.EventName.text(data.DataItemDesc);
                this.EventItem.val(data.CategoryItem);
                this.categoryItem = this.getCategoryItemByDataItem(data.DataItem);
                this.render(this.categoryItem);
                var eventDetailDatas = data.EventDetailDatas;

                $.each(this.EventDetails, function(index, editor) {
                    var detailItem = editor.data('detailItem');
                    var detailValue = getEventDetailValue(detailItem, eventDetailDatas);
                    editor[detailItem.Editor]('setValue', detailValue);
                });
            } else {
                this.StartDT.datetimebox('setValue', data.StartDT.format(constant.dateTimeFormat));
            }

            function getEventDetailValue(detailItem, eventDetailDatas) {
                var value = '';
                $.each(eventDetailDatas, function(index, detailData) {
                    if (detailData.EventDetailItem === detailItem.RowId) {
                        value = detailData.DataValue;
                        return false;
                    }
                });
                return value;
            }
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.SpeedUnit.combobox('loadData', dataList.SpeedUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        setItem: function(item) {
            if (item.DataItem) {
                this.DataCategoryRowId.val(item.DataCategory);
                this.CategoryItemRowId.val(item.RowId);
                this.DataItemRowId.val(item.DataItem);
            } else {
                this.UserDefinedItemRowId.val(item.RowId);
            }
        },
        /**
         * 值改变时调用
         */
        onChange: function() {
            if (this.originalData) {
                this.originalData.editing = true;
                this.callback.call(this, this.originalData);
            }

        },
        /**
         * 清空
         */
        clear: function() {
            this.originalData = null;
            this.detailsContainer.empty();
            this.form.form('clear');
            this.EventName.text('');
            if (!this.eventSelectionView.closed) this.eventSelectionView.close();
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
        toData: function() {
            var detailDatas = [];
            var detailItem = null;
            var detailStrArr = [];
            $.each(this.EventDetails, function(index, detail) {
                detailItem = $(detail).data('detailItem');
                var value = $(detail)[detailItem.Editor]('getValue');
                if (value) {
                    detailStrArr.push(detailItem.Description + ':' + value + detailItem.Unit);
                    detailDatas.push({
                        EventDetailItem: detailItem.RowId,
                        DataTitle: detailItem.Description,
                        DataValue: value,
                        DataUnit: detailItem.Unit,
                        EventDetailDesc: detailItem.Description,
                        Unit: detailItem.Unit
                    });
                }
            });

            return {
                RowId: "",
                GenerateTimeSpan: this.GenerateTimeSpan.numberbox('getValue'),
                DataCategory: this.DataCategoryRowId.val(),
                DataItem: this.DataItemRowId.val(),
                DataValue: "",
                Description: this.EventName.text(),
                EditFlag: "N",
                FromData: "",
                CreateUserID: "",
                CreateDT: "",
                ItemCategory: "E",
                Type: "E",
                EventDetailDatas: detailDatas,
                EventDetail: detailStrArr.join('\n'),
                edited: true
            }
        },
        /**
         * 保存
         */
        save: function() {
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                newData = $.extend(originalData, newData);
                newData.DrugData = $.extend(originalData.DrugData, newData.DrugData);
            }

            if (this.options.onSave) this.options.onSave.call(this, newData);
            this.close();
        },
        position: function(pos) {

        },
        showEventSelectionView: function() {
            //if (this.originalData) return; // 当有数据加载的时候不能更改已选择的事件名
            this.eventSelectionView.position(this.EventName.offset());
            this.eventSelectionView.open();
            this.EventName.addClass('eventeditor-f-r-event-selected');
        },
        /**
         * 获取数据对应事件明细项
         * @param {string||object} dataOrItemId 
         */
        getEventDetailItems: function(dataOrItemId) {
            var detailItems = [];

            if (typeof dataOrItemId === 'object') {
                var eventData = dataOrItemId;
                var eventDetailDatas = eventData.EventDetailDatas;
                var length = eventDetailDatas || [].length;

                var categoryItem = this.getCategoryItem(eventData.CategoryItem);
                if (categoryItem) $.each(categoryItem.eventDetailItems, function(index, detailItem) {
                    var detailData = null;
                    for (var i = 0; i < length; i++) {
                        if (eventDetailDatas[i].EventDetailItem === detailItem.RowId) {
                            detailData = eventDetailDatas[i];
                            break;
                        }
                    }
                    detailItems.push({
                        data: detailData,
                        item: detailItem
                    })
                });
            } else {
                var dataItemId = dataOrItemId;
                var categoryItem = this.getCategoryItem('', dataItemId);
                if (categoryItem) { detailItems = categoryItem.eventDetailItems }
            }

            return detailItems;
        },
        /**
         * 根据分类或数据项目获取分类
         * @param {string} categoryId 分类Id
         * @param {string} dataItemId 数据项目Id，可选
         */
        getCategoryItem: function(categoryId, dataItemId) {
            var foundItem = null;
            $.each(this.categoryItems, function(index, item) {
                if ((item.RowId === categoryId) || (item.DataItem === dataItemId)) {
                    foundItem = item;
                    return false;
                }
            });

            return foundItem;
        }
    }

    /**
     * 事件选择框
     */
    var eventSelectionView = {
        init: function(callback) {
            var _this = this;
            this.FilterStr = '';
            this.callback = callback;
            this.dom = $('<div class="eventeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="eventeditor-selectionview-container" style="width:280px;"></div>').appendTo(this.dom);
            $(this.dom).delegate('.event-button', 'click', function() {
                var categoryItem = $(this).data('categoryItem');
                _this.callback(categoryItem);
                _this.close();
            });

            this.header = $('<div class="eventeditor-selectionview-header"></div>').appendTo(this.container);
            var searchBox = $('<input type="text">').appendTo(this.header);
            searchBox.searchbox({
                width: 270,
                prompt: '输入汉字和简拼检索',
                onClickButton: function(index) {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });

            var inputRect = searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                _this.FilterStr = $(this).val().toUpperCase();
                _this.filter();
            });

            this.itemContainer = $('<div class="eventeditor-selectionview-items"></div>').appendTo(this.container);

            this.close();

            // this.dom.mouseleave(function() {
            //     _this.close();
            // });

            this.initiated = true;
        },
        render: function(eventCategories) {
            // 按使用次数倒序显示
            var items = [];
            $.each(eventCategories, function(index, category) {
                items = items.concat(category.items || []);
            });
            this.categoryItems = items;
            var sortedItems = getSortedItems(items);

            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();

            var length = sortedItems.length;
            var item = null,
                element = null;
            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="event-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                }
            }
            itemsContainer.show();
        },
        /**
         * 筛选
         */
        filter: function() {
            var filterStr = this.FilterStr;
            this.dom.find('.event-button').each(function(index, e) {
                var text = $(e).text();
                var alias = $(e).attr('data-alias');
                if (filterStr === '' ||
                    text.indexOf(filterStr) > -1 ||
                    alias.indexOf(filterStr) > -1 ||
                    text === '自由文本') {
                    $(e).show();
                } else {
                    $(e).hide();
                }
            });
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            this.FilterStr = '';
        },
        /**
         * 打开
         */
        open: function() {
            if (!this.initiated) this.init();
            this.dom.show();
            this.closed = false;
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
        }
    }

    /**
     * 间断给药
     */
    var intrmiDrugDataCreator = {
        init: function(opt) {
            var _this = this;
            this.options = opt;
            this.dataview = intrmiDrugDataView;
            this.categoryItemSelectionView = intrmiDrugCategoryItemSelectionView;
            this.drugItemSelectionView = intrmiDrugItemSelectionView;
            this.editview = intrmiDrugEditView;
            this.drugDataList = [];

            this.dom = $('<div></div>').appendTo('body');
            this.formContainer = $('<div class="intrmidrugeditor-form-panel"></div>').appendTo(this.dom);
            this.categoryItemContainer = $('<div class="intrmidrugeditor-items-panel" style="width:240px;float:right;"></div>').appendTo(this.dom);

            this.initForm();
            this.initItemSelection();

            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '新增',
                iconCls: 'icon-add',
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
            this.dom.dialog({
                left: 300,
                top: 150,
                height: 330,
                width: 500,
                title: '间断用药模板数据编辑',
                modal: true,
                closed: true,
                iconCls: 'icon-drug',
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.editview.init(function(drugData) {
                if (this.originalData === drugData) _this.editDrugData(drugData);
                else _this.addDrugData(drugData);
            });
            if (this.options.comboDataSource)
                this.editview.setComboDataSource(this.options.comboDataSource);
        },
        /**
         * 初始化表单
         */
        initForm: function() {
            var _this = this;
            this.form = $('<form></form>').appendTo(this.formContainer);
            this.form.form({});

            this.AnaDataRowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
            this.DataCategoryRowId = $('<input type="hidden" name="DataCategory">').appendTo(this.form);
            this.CategoryItemRowId = $('<input type="hidden" name="CategoryItem">').appendTo(this.form);

            var timeRow = $('<div class="intrmidrugeditor-f-r" title="将在入手术间后多少分钟添加此数据"></div>').appendTo(this.form);
            var label = $('<div class="label" style="white-space:nowrap;">入室后分钟</div>').appendTo(timeRow);
            this.GenerateTimeSpan = $('<input type="text" style="width:180px;">').appendTo(timeRow);
            this.GenerateTimeSpan.numberbox({
                width: 180,
                disabled: false,
                label: label
            });

            var row = $('<div class="intrmidrugeditor-f-r"><span class="label">用药：</span></div>').appendTo(this.form);
            var container = $('<div class="intrmidrugeditor-f-r-container"></div>').appendTo(row);
            this.DrugDataContainer = $('<div class="intrmidrugeditor-data-container"></div>').appendTo(container);
            $('<a href="javascript:;" class="drugdata-i-add" title="增加用药">+</a>')
                .click(function() {
                    _this.openEditView();
                })
                .appendTo(container);

            this.DrugDataContainer.delegate('.drugdata-i-btn-edit', 'click', function() {
                $('.drugdata-i-selected').removeClass('drugdata-i-selected');
                var element = $($(this).parent());
                var data = element.data('data');
                element.addClass('drugdata-i-selected');
                _this.dataview.refreshAppearance(data.target, data);
                _this.editview.render(data);
                _this.openEditView();
            });

            this.DrugDataContainer.delegate('.drugdata-i-btn-remove', 'click', function() {
                if (event.stopPropagation) event.stopPropagation();
                else event.cancelBubble = true;
                var element = $($(this).parent());
                var data = element.data('data');
                if (data) {
                    $.messager.confirm('删除数据', '确认删除用药数据：\n' + element.text(), function(confirmed) {
                        if (confirmed) {
                            _this.deleteDrugData(data);
                        }
                    });
                }

                return false;
            })
        },
        setComboDataSource: function(dataList) {
            this.editview.setComboDataSource(dataList);
        },
        /**
         * 初始化项目选择区
         */
        initItemSelection: function() {
            var _this = this;
            this.categoryItemSelectionView.init(this.categoryItemContainer, function(categoryItem) {
                _this.openEditView(categoryItem);
            });
            this.categoryItemSelectionView.render(cache.intrmiDrugCategories);

            this.drugItemSelectionView.init();
            this.drugItemSelectionView.render(cache.intrmiDrugCategories);

            if (cache.intrmiDrugCategories.length > 0) {
                this.DataCategoryRowId.val(cache.intrmiDrugCategories[0].RowId);
            }
        },
        /**
         * 加载数据
         * @param {Model.AnaData} data
         */
        loadData: function(data) {
            this.drugDataList = [];
            this.GenerateTimeSpan.numberbox('setValue', data.GenerateTimeSpan);
            if (data.RowId) {
                this.originalData = data;
                this.drugDataList = data.DrugDataList;
                this.refreshDataView();
            }
        },
        loadUserDefinedItem: function(data) {
            this.userDefinedItemList = data;
            this.categoryItemSelectionView.renderUserDefinedItems(data);
            this.drugItemSelectionView.renderUserDefinedItems(data);
            this.userDefinedItemLoaded = true;

            if (this.incompleteRender) {
                var data = this.originalData;
                this.categoryItem = this.getCategoryItemById(data.CategoryItem);
                this.userDefinedItem = this.getUserDefinedItemById(data.UserDefinedItem);
                this.render(this.categoryItem, this.userDefinedItem);
            }
        },
        getCategoryItemById: function(rowId) {
            var foundItem = null;
            var eventCats = cache.intrmiDrugCategories;
            $.each(eventCats, function(index, category) {
                var items = category.items;
                var length = items.length;
                for (var i = 0; i < length; i++) {
                    if (items[i].RowId === rowId) {
                        foundItem = items[i];
                        break;
                    }
                }

                return foundItem == null;
            });

            return foundItem;
        },
        getUserDefinedItemById: function(rowId) {
            var foundItem = null;
            var items = this.userDefinedItemList || [];
            var length = items.length;
            for (var i = 0; i < length; i++) {
                if (items[i].RowId === rowId) {
                    foundItem = items[i];
                    break;
                }
            }
            return foundItem;
        },
        /**
         * 打开药品编辑界面
         */
        openEditView: function(categoryItem) {
            this.editview.open();
            if (categoryItem) this.editview.setCategoryItem(categoryItem);
        },
        /**
         * 打开
         */
        open: function() {
            this.dom.dialog('open');
            if (this.retrieveUserDefinedItem && !this.userDefinedItemList) {
                this.retrieveUserDefinedItem({
                    dataCategoryId: this.dataCategoryId
                });
            }
        },
        /**
         * 关闭
         */
        close: function() {
            this.dom.dialog('close');
        },
        /**
         * 清空
         */
        clear: function() {
            this.form.form('clear');
            this.DrugDataContainer.empty();
            this.originalData = null;
            this.drugDataList = [];
            if (this.categoryItemSelectionView.searchBox) {
                this.categoryItemSelectionView.searchBox.searchbox('setValue', '');
                this.categoryItemSelectionView.filter('');
            }
        },
        /**
         * 修改DrugData
         */
        editDrugData: function(drugData) {
            this.dataview.refreshAppearance(drugData.target, drugData);
        },
        /**
         * 修改DrugData
         */
        addDrugData: function(drugData) {
            this.drugDataList.push(drugData);
            this.refreshDataView();
        },
        /**
         * 删除DrugData
         */
        deleteDrugData: function(drugData) {
            var index = this.drugDataList.indexOf(drugData);
            this.drugDataList.splice(index, 1);
            drugData.target.remove();
        },
        /**
         * 刷新数据显示
         */
        refreshDataView: function() {
            this.dataview.render(this.DrugDataContainer, this.drugDataList);
        },
        /**
         * 保存
         */
        save: function() {
            var newData = this.toData();
            var originalData = this.originalData;
            if (originalData) {
                newData = $.extend(originalData, newData);
                newData.DrugData = $.extend(originalData.DrugData, newData.DrugData);
                newData.DrugDataList = $.extend(originalData.DrugDataList, newData.DrugDataList);
            }

            if (this.options.onSave) this.options.onSave.call(this, newData);
            this.close();
        },
        /**
         * 生成数据
         */
        toData: function() {
            var textArr = [];
            if (this.drugDataList) {
                var length = this.drugDataList.length;
                for (var i = 0; i < length; i++) {
                    var drugData = this.drugDataList[i];
                    textArr.push((drugData.Description || drugData.ArcimDesc) + " " +
                        drugData.DoseQty + drugData.DoseUnitDesc +
                        (drugData.InstructionDesc ? (" " + drugData.InstructionDesc) : "") +
                        (drugData.Note ? (" " + drugData.Note) : ""));
                }
            }

            return {
                RowId: '',
                GenerateTimeSpan: this.GenerateTimeSpan.numberbox('getValue'),
                DataCategory: this.DataCategoryRowId.val(),
                DataValue: '',
                EditFlag: 'N',
                FromData: '',
                ItemCategory: "D",
                Description: textArr.join('\n'),
                Type: 'I',
                DrugDataList: this.drugDataList
            }
        }
    }

    var singleDataView = {
        /**
         * 渲染单条用药数据显示
         * @param {HTMLElement} container 单条用药数据的容器
         * @param {Module<Data.DrugData>} data 单条用药数据
         */
        render: function(container, data) {
            container.data('data', data);
            data.target = container;
            container.empty();
            $('<a href="javascript:;" class="drugdata-i-btn-remove icon-close" title="删除此条数据"></a>').appendTo(container);
            $('<a href="javascript:;" class="drugdata-i-btn-edit icon-edit" title="修改此条数据"></a>').appendTo(container);
            $('<span class="drugdata-i-name"></span>')
                .text(data.Description)
                .appendTo(container);
            if (Number(data.DoseQty) > 0)
                $('<span class="drugdata-i-dose"></span>')
                .text(data.DoseQty + data.DoseUnitDesc)
                .appendTo(container);
            if (Number(data.Concentration) > 0)
                $('<span class="drugdata-i-concentration"></span>')
                .text(data.Concentration + data.ConcentrationUnitDesc)
                .appendTo(container);
            $('<span class="drugdata-i-instruction"></span>')
                .text(data.InstructionDesc)
                .appendTo(container);

            var tipArr = [];
            tipArr.push(data.Description);
            if (Number(data.DoseQty) > 0)
                tipArr.push('剂量：' + data.DoseQty + data.DoseUnitDesc);
            if (Number(data.Concentration) > 0)
                tipArr.push('浓度：' + data.Concentration + data.ConcentrationUnitDesc);
            tipArr.push('用法：' + data.InstructionDesc);
            tipArr.push('备注：' + data.Note);
            //tipArr.push('接收科室：' + data.RecvLocDesc);
            container.attr('title', tipArr.join('\n'));
        }
    }

    var intrmiDrugDataView = {
        /**
         * 单条数据渲染
         */
        singleDataView: singleDataView,
        /**
         * 渲染用药数据显示
         * @param {HTMLElement} container 容器
         * @param {Array<Data.DrugData>} data 用药数据数组
         */
        render: function(container, data) {
            this.container = container;
            this.container.empty();
            var singlerender = this.singleDataView.render;
            $.each(data, function(index, row) {
                singlerender($('<div class="drugdata-i"></div>').appendTo(container), row);
            })
        },
        /**
         * 清空数据显示
         */
        clear: function() {
            if (this.container) this.container.empty();
        },
        /**
         * 刷新数据显示
         * @param {jQuery<HTMLElement>} container
         * @param {Model.AnaData} drugData 
         */
        refreshAppearance: function(container, drugData) {
            this.singleDataView.render(container, drugData);
        }
    }

    /**
     * 间断用药药品项目选择
     */
    var intrmiDrugCategoryItemSelectionView = {
        closed: false,
        init: function(dom, callback) {
            var _this = this;
            this.callback = callback;
            this.dom = dom;

            this.header = $('<div class="intrmidrugeditor-items-panel-header"></div>').appendTo(this.dom);
            this.searchBox = $('<input type="text">').appendTo(this.header);
            this.searchBox.searchbox({
                width: 180,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getValue');
                    _this.filter(text);
                }
            });

            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-items"></div>').appendTo(this.dom);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            return this;
        },
        /**
         * 渲染
         */
        render: function(dataCategories) {
            var items = [];
            var length = dataCategories.length;
            var items = [];
            for (var i = 0; i < length; i++) {
                items = items.concat(dataCategories[i].items || []);
            }
            this.categoryItems = items;

            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();
            var item = null,
                element = null;
            var sortedItems = getSortedItems(items);
            var length = sortedItems.length;

            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="categoryitem-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                item.target = element;

                element.data('data', item);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }

            this.items = sortedItems;

            itemsContainer.show();
            return this;
        },
        renderUserDefinedItems: function(items) {
            var UserID = session.UserID;
            var _this = this;
            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();

            var sortedItems = getSortedItems(items);
            var length = sortedItems.length;
            var item = null,
                element = null;
            var sortedItems = getSortedItems(items);

            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="categoryitem-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                item.target = element;

                element.data('data', item);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }

            this.items = this.items.concat(items);

            itemsContainer.show();
        },
        filter: function(filterStr) {
            this.dom.find('.categoryitem-button').each(function(index, e) {
                var text = $(e).text();
                var alias = $(e).attr('data-alias');
                if (filterStr === '' ||
                    text.indexOf(filterStr) > -1 ||
                    alias.indexOf(filterStr) > -1) {
                    $(e).show();
                } else {
                    $(e).hide();
                }
            });
        }
    }

    /**
     * 间断用药编辑框
     */
    var intrmiDrugEditView = {
        init: function(callback) {
            this.callback = callback;
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.initForm();

            var buttons = $('<div></div>');
            var btn_confirm = $('<a href="#"></a>').linkbutton({
                text: '确认',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.confirm();
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
                left: 360,
                top: 120,
                height: 330,
                width: 340,
                title: '增加用药',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                    $('.drugdata-i-selected').removeClass('drugdata-i-selected');
                }
            });

            this.arcimSelectionView = intrmiArcimSelectionView;
            this.arcimSelectionView.init(function(arcimItem) {
                _this.setArcimItem(arcimItem);
            });

            this.drugItemSelectionView = intrmiDrugItemSelectionView;
            this.drugItemSelectionView.setCallback(function(drugItem) {
                _this.setItem(drugItem);
            });

            this.DrugItem.click(function() {
                _this.drugItemSelectionView.position($(this).offset()).open();
            });

            this.DrugItemButton.click(function() {
                _this.drugItemSelectionView.position($(_this.DrugItem).offset()).open();
            });

            this.ArcimItem.click(function() {
                _this.arcimSelectionView.position($(this).offset()).open();
            });

            this.ArcimItemButton.click(function() {
                _this.arcimSelectionView.position($(_this.ArcimItem).offset()).open();
            });

            this.form.delegate('input', 'focus', function() {
                _this.arcimSelectionView.close();
            });
        },
        initForm: function() {
            this.form = $('<form class="intrmidrugeditor-editview-form"></form>').appendTo(this.dom);
            this.form.form({});

            this.DrugDataRowId = $('<input type="hidden" name="DrugDataRowId">').appendTo(this.form);

            var itemRow = $('<div class="editview-f-r" style="height:33px;"><div class="label">药品项：</div></div>').appendTo(this.form);
            this.DataItemID = $('<input type="hidden" name="DataItemID">').appendTo(itemRow);
            this.UserDefinedItemID = $('<input type="hidden" name="UserDefinedItemID">').appendTo(itemRow);
            this.DrugItem = $('<span class="intrmidrugeditor-editview-drugitem" style="width:164px;"></span>').appendTo(itemRow);
            this.DrugItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var itemRow = $('<div class="editview-f-r" style="height:33px;"><div class="label">医嘱项：</div></div>').appendTo(this.form);
            this.ArcimItem = $('<div class="intrmidrugeditor-editview-drugitem" title="单击选择医嘱项" style="width:164px;"></div>').appendTo(itemRow);
            this.ArcimID = $('<input type="hidden" name="ArcimID">').appendTo(itemRow);
            this.ArcimItemButton = $('<span class="drugeditor-editview-drugitem" style="width:24px;margin-left:3px;"><span class="icon icon-template" style="margin-top:7px;margin-left:2px;"></span></span>').appendTo(itemRow);

            var doseRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">剂量：</div>').appendTo(doseRow);
            this.DoseQty = $('<input class="textbox" type="text" name="DoseQty" style="width:93px;margin-right:5px;">').appendTo(doseRow);
            this.DoseUnit = $('<input type="text" name="DoseUnit">').appendTo(doseRow);
            this.DoseQty.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.DoseUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var concentrationRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">浓度：</div>').appendTo(concentrationRow);
            this.Concentration = $('<input class="textbox" type="text" name="Concentration" style="width:93px;margin-right:5px;">').appendTo(concentrationRow);
            this.ConcentrationUnit = $('<input type="text" name="ConcentrationUnit">').appendTo(concentrationRow);
            this.Concentration.validatebox({
                width: 100,
                label: label,
                novalidate: true
            });
            this.ConcentrationUnit.combobox({
                width: 95,
                valueField: "RowId",
                textField: "Description",
                cls: 'editview-f-r-unit'
            });

            var instructionRow = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">用药途径：</div>').appendTo(instructionRow);
            this.Instruction = $('<input type="text" name="Instruction">').appendTo(instructionRow);
            this.Instruction.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var reasonRow = $('<div class="editview-f-r" style="display:none;"></div>').appendTo(this.form);
            var label = $('<div class="label">原因：</div>').appendTo(reasonRow);
            this.Reason = $('<input type="text" name="Reason">').appendTo(reasonRow);
            this.Reason.combobox({
                width: 200,
                valueField: "RowId",
                textField: "Description",
                label: label
            });

            var row = $('<div class="editview-f-r"></div>').appendTo(this.form);
            var label = $('<div class="label">备注：</div>').appendTo(row);
            this.Note = $('<input type="text" class="textbox" name="Note" style="width:194px;">').appendTo(row);
            this.Note.validatebox({
                width: 200,
                novalidate: true
            });

            var receiveLocRow = $('<div class="editview-f-r" style="display:none;"></div>').appendTo(this.form);
            var label = $('<div class="label">接收科室：</div>').appendTo(receiveLocRow);
            this.RecvLoc = $('<input type="text" name="RecvLoc">').appendTo(receiveLocRow);
            this.RecvLoc.combobox({
                width: 200,
                valueField: "Id",
                textField: "Desc",
                label: label
            });
        },
        render: function(drugData) {
            if (drugData) {
                this.dom.dialog('setTitle', '编辑用药');
                this.originalData = drugData;
                this.ArcimID.val(drugData.ArcimID);
                this.ArcimItem.attr('title', drugData.ArcimDesc).text(drugData.ArcimDesc);
                this.RecvLoc.combobox("setValue", drugData.RecvLoc);
                this.RecvLoc.combobox("setText", drugData.RecvLocDesc);
                this.DoseQty.validatebox("setValue", drugData.DoseQty);
                this.DoseUnit.combobox("setValue", drugData.DoseUnit);
                this.Concentration.validatebox("setValue", drugData.Concentration);
                this.ConcentrationUnit.combobox("setValue", drugData.ConcentrationUnit);
                this.Instruction.combobox("setValue", drugData.Instruction);
                this.Reason.combobox("setText", drugData.Reason);
                this.Note.validatebox("setValue", drugData.Note);
                this.DrugDataRowId.val(drugData.RowId);
                this.DrugItem.text(drugData.Description);
            } else {
                this.dom.dialog('setTitle', '增加用药');
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.form.form('clear');
            this.ArcimItem.attr('title', '').text('');
            this.originalData = null;
        },
        setComboDataSource: function(dataList) {
            this.DoseUnit.combobox('loadData', dataList.DoseUnits || []);
            this.ConcentrationUnit.combobox('loadData', dataList.ConcentrationUnits || []);
            this.Instruction.combobox('loadData', dataList.Instructions || []);
            this.Reason.combobox('loadData', dataList.Reasons || []);
        },
        setDefaultValues: function(params) {
            if (!this.originalData) {
                if (params.DoseQty) this.DoseQty.validatebox("setValue", params.DoseQty);
                if (params.DoseUnit) this.DoseUnit.combobox("setValue", params.DoseUnit);
                if (params.Concentration) this.Concentration.validatebox("setValue", params.Concentration);
                if (params.ConcentrationUnit) this.ConcentrationUnit.combobox("setValue", params.ConcentrationUnit);
                if (params.Instruction) this.Instruction.combobox("setValue", params.Instruction);
            }
        },
        confirm: function() {
            var drugData = this.toData();
            if (this.originalData) $.extend(this.originalData, drugData);
            this.callback(this.originalData || drugData);
            this.close();
        },
        setCategoryItem: function(categoryItem) {
            this.setItem(categoryItem);
        },
        setItem: function(item) {
            this.DrugItem.text(item.Description || item.ItemDesc);
            if (item.DataItem) this.DataItemID.val(item.DataItem);
            else this.UserDefinedItemID.val(item.RowId);

            var drugItem;
            if (item) drugItem = item.drugItem;
            if (drugItem) {
                this.setDefaultValues({
                    DoseQty: drugItem.DoseQty,
                    DoseUnit: drugItem.DoseUnit,
                    Speed: drugItem.Speed,
                    SpeedUnit: drugItem.SpeedUnit,
                    Concentration: drugItem.Concentration,
                    ConcentrationUnit: drugItem.ConcentrationUnit,
                    Instruction: drugItem.Instruction
                });
            }

            if (item) {
                this.ArcimItem.attr('title', '').text('');
                this.ArcimID.val('');
                this.arcimSelectionView.render(item);
                if (item.arcimItems && item.arcimItems.length > 0) this.setArcimItem(item.arcimItems[0]);
            }
        },
        setArcimItem: function(arcimItem) {
            this.ArcimItem.attr('title', arcimItem.ArcimDesc || arcimItem.Description).text(arcimItem.ArcimDesc || arcimItem.Description);
            this.ArcimID.val(arcimItem.ArcimID);
            if (!this.originalData && arcimItem.DoseQty) {
                this.DoseQty.validatebox("setValue", arcimItem.DoseQty);
            }
            if (!this.originalData && arcimItem.ANDoseUom) {
                this.DoseUnit.combobox("setValue", arcimItem.ANDoseUom);
            }
            //this.loadReceiveLocation();
        },
        loadReceiveLocation: function() {
            var _this = this;
            var recvLocs = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: CLCLS.BLL.Admission,
                QueryName: "FindRecvLoc",
                Arg1: record.context.schedule.EpisodeID, //?
                Arg2: session.DeptID, //?
                Arg3: this.ArcimID.val(), //?
                ArgCnt: 3
            }, "json", true, function(data) {
                if (data && data.length > 0) {
                    _this.RecvLoc.combobox("loadData", data);
                    _this.RecvLoc.combobox("setValue", data[0].Id);
                }
            });
        },
        /**
         * 转换为数据
         */
        toData: function() {
            return {
                RowId: '',
                AnaData: '',
                DataItem: this.DataItemID.val(),
                UserDefinedItem: this.UserDefinedItemID.val(),
                DoseQty: this.DoseQty.validatebox("getValue"),
                DoseUnit: this.DoseUnit.combobox("getValue"),
                Instruction: this.Instruction.combobox("getValue"),
                Concentration: this.Concentration.validatebox("getValue"),
                ConcentrationUnit: this.ConcentrationUnit.combobox("getValue"),
                Speed: '',
                SpeedUnit: '',
                BalanceQty: "",
                Reason: this.Reason.combobox("getText"),
                BalanceDisposal: "",
                RecvLoc: this.RecvLoc.combobox('getValue'),
                ArcimID: this.ArcimID.val(),
                OrderItemID: "",
                DoseUnitDesc: this.DoseUnit.combobox("getText"),
                SpeedUnitDesc: '',
                DensityUnitDesc: this.ConcentrationUnit.combobox("getText"),
                ConcentrationUnitDesc: this.ConcentrationUnit.combobox("getText"),
                InstructionDesc: this.Instruction.combobox("getText"),
                ArcimDesc: this.ArcimItem.text(),
                RecvLocDesc: this.RecvLoc.combobox('getText'),
                Description: this.DrugItem.text(),
                Note: this.Note.validatebox('getValue')
            }
        }
    }

    /**
     * 间断用药药品项选择
     */
    var intrmiDrugItemSelectionView = {
        closed: false,
        init: function() {
            var _this = this;
            this.dom = $('<div class="intrmidrugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="intrmidrugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="intrmidrugeditor-selectionview-header"></div>').appendTo(this.container);
            this.searchBox = $('<input type="text">').appendTo(this.header);
            this.searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter(text);
                }
            });

            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.categoryitem-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            return this;
        },
        setCallback: function(callback) {
            this.callback = callback;
        },
        /**
         * 渲染
         */
        render: function(dataCategories) {
            var items = [];
            var length = dataCategories.length;
            var items = [];
            for (var i = 0; i < length; i++) {
                items = items.concat(dataCategories[i].items || []);
            }
            this.categoryItems = items;


            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();
            var sortedItems = getSortedItems(items);
            var length = sortedItems.length;
            var item = null,
                element = null;

            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="categoryitem-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                item.target = element;

                element.data('data', item);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }

            this.items = sortedItems;
            itemsContainer.show();

            return this;
        },
        renderUserDefinedItems: function(items) {
            var UserID = session.UserID;
            var _this = this;
            var itemsContainer = this.itemContainer;
            itemsContainer.hide();
            itemsContainer.empty();

            var sortedItems = getSortedItems(items);
            var length = sortedItems.length;
            var item = null,
                element = null;

            for (var j = 0; j < length; j++) {
                item = sortedItems[j];
                element = $('<a href="#" class="categoryitem-button"></a>')
                    .text(item.Description || item.ItemDesc)
                    .attr('data-alias', item.Alias)
                    .appendTo(itemsContainer);
                item.target = element;

                element.data('data', item);
                if (item.DataItem) {
                    element.data('categoryItem', item);
                } else {
                    element.data('userdefinedItem', item);
                }
            }

            this.items = this.items.concat(sortedItems);

            itemsContainer.show();
        },
        filter: function(filterString) {
            var _this = this;
            var length = this.items.length;
            var filterString = filterString;
            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                var desc = item.Description || item.ItemDesc;
                desc = desc.toUpperCase();
                var alias = item.Alias || '';
                if (!filterString ||
                    desc.indexOf(filterString) > -1 ||
                    alias.indexOf(filterString) > -1
                ) {
                    item.target.show();
                } else {
                    item.target.hide();
                }
            }
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            if (this.searchBox) {
                this.searchBox.searchbox('setValue', '');
                this.filter('');
            }
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
    }

    /**
     * 间断用药医嘱项选择
     */
    var intrmiArcimSelectionView = {
        closed: false,
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="intrmidrugeditor-selectionview"></div>').appendTo('body');
            this.container = $('<div class="intrmidrugeditor-selectionview-container"></div>').appendTo(this.dom);
            this.close();

            this.dom.mouseleave(function() {
                _this.close();
            });

            this.header = $('<div class="intrmidrugeditor-selectionview-header"></div>').appendTo(this.container);
            this.searchBox = $('<input type="text">').appendTo(this.header);
            this.searchBox.searchbox({
                width: 200,
                prompt: '输入简拼或汉字搜索',
                iconCls: 'icon-search',
                iconAlign: 'right',
                onClickButton: function() {
                    var text = $(this).validatebox('getText');
                    _this.filter(text);
                }
            });

            var inputRect = this.searchBox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.filter(text);
            });

            this.header.delegate('input', 'keyup', function(e) {
                if (e.keyCode == 13) {
                    var text = $(this).val();
                    _this.filter(text);
                }
            });

            this.itemContainer = $('<div class="intrmidrugeditor-selectionview-items"></div>').appendTo(this.container);

            this.dom.delegate('.drug-button', 'click', function() {
                var callback = _this.callback;
                if (callback) callback($(this).data('data'));
            });

            return this;
        },
        render: function(categoryItem) {
            this.items = [];
            if (!categoryItem.DataItem) return;
            this.items = categoryItem.arcimItems || [];
            this.renderItems(this.items);
            return this;
        },
        renderItems: function(items) {
            var container = this.itemContainer;
            container.empty();
            $.each(items, function(index, arcimItem) {
                var element = null;
                element = $('<a href="#" class="drug-button"></a>').text(arcimItem.ArcimDesc || arcimItem.Description).appendTo(container);
                element.data('data', arcimItem);
            });
        },
        filter: function(filterString) {
            var _this = this;
            // if (filterString === '') {
            //     this.renderItems(this.items);
            // } else {
            //     dhccl.getDatas(ANCSP.DataQuery, {
            //         ClassName: CLCLS.BLL.Admission,
            //         QueryName: "FindMasterItem",
            //         Arg1: filterString,
            //         ArgCnt: 1
            //     }, 'json', true, function(data) {
            //         _this.renderItems(data);
            //     });
            // }
        },
        /**
         * 打开药品选择框
         */
        open: function() {
            this.dom.show();
            this.closed = false;
            return this;
        },
        /**
         * 关闭药品选择框
         */
        close: function() {
            this.dom.hide();
            this.closed = true;
            if (this.searchBox) {
                this.searchBox.searchbox('setValue', '');
                this.filter('');
            }
            return this;
        },
        position: function(position) {
            this.dom.css({ left: position.left, top: position.top + 35 });
            return this;
        }
    }

    /**
     * 在模板项目数组中匹配分类项目
     * @param {Array<Data.TemplateItem> or Array<Data.ParaItem>} paraOrTemplateItems
     * @param {Module<Data.CategoryItem>} categoryItem 
     * @param {Array<Data.TemplateItem>[ 0 or 1 ]} foundItems 出参
     */
    function matchItems(paraOrTemplateItems, categoryItem, foundItems) {
        var len = paraOrTemplateItems.length;

        for (var j = 0; j < len; j++) {
            if (matchItem(categoryItem, paraOrTemplateItems[j])) {
                foundItems[0] = paraOrTemplateItems[j];
                return true;
            }
        }

        return false;
    }

    /**
     * 匹配分类项目和模板项目
     * @param {Module<Data.CategoryItem>} categoryItem 
     * @param {Module<Data.TemplateItem> or Module<Data.ParaItem>} paraOrTemplateItem 
     */
    function matchItem(categoryItem, paraOrTemplateItem) {
        return ((categoryItem.Category === paraOrTemplateItem.Category) &&
            (categoryItem.RowId === paraOrTemplateItem.CategoryItem));
    }

    /**
     * 在这里根据模板项目的数据生成对应的树
     * @param {Array<Data.CategoryItem> or Array<Data.TemplateItem>} data
     */
    function loadFilter(data) {
        var nodes = [];
        $.each(cache.displayCategories, function(index, displayCategory) {
            if (typeof displayCategory.removable === 'boolean' && !displayCategory.removable) return true;
            if (!displayCategory.dataCategory) return true;
            var categoryId = displayCategory.dataCategory.RowId;
            var node = {
                id: categoryId,
                text: displayCategory.title,
                iconCls: 'tree-folder-open',
                state: 'opened',
                children: [],
                attributes: {
                    data: displayCategory,
                    type: 'category'
                }
            }
            var length = data.length;
            for (var i = 0; i < length; i++) {
                if (containedInCategory(displayCategory.dataCategory, data[i].Category || data[i].DataCategory)) {
                    node.children.push({
                        id: data[i].RowId,
                        text: '<span class="tree-node-item" title="' + '浓度：' + (data[i].Concentration ? data[i].Concentration + data[i].ConcentrationUnitDesc : '') +
                            '\n单位：' + (data[i].UnitDesc || '') +
                            (data[i].DoseUnitVisible === 'Y' ? '\n显示剂量单位' : '\n不显示剂量单位') +
                            (data[i].SpeedUnitVisible === 'Y' ? '\n显示速度单位' : '\n不显示速度单位') +
                            (data[i].ConcentrationVisible === 'Y' ? '\n显示浓度' : '\n不显示浓度') +
                            (data[i].Continuous === 'Y' ? '\n默认持续' : '\n不默认持续') +
                            ('\n默认持续分钟数' + data[i].Duration) +
                            '">' +
                            (data[i].ItemDesc || data[i].Description) + '</span>',
                        checked: true,
                        attributes: {
                            data: data[i],
                            type: 'item',
                            categoryId: categoryId,
                            isOnCurrentPage: containedInDisplayItems(displayCategory.displayItems, data[i])
                        }
                    });
                }
            }

            nodes.push(node);
        });

        return nodes;
    }

    function containedInCategories(dataCategories, itemCategoryRowId) {
        var length = dataCategories.length;
        for (var i = 0; i < length; i++) {
            if (containedInCategory(dataCategories[i], itemCategoryRowId)) return true;
        }

        return false;
    }

    function containedInCategory(dataCategory, itemCategoryRowId) {
        return (dataCategory.RowId === itemCategoryRowId) ||
            ((dataCategory.subCategories) &&
                (dataCategory.subCategories.length > 0) &&
                (containedInCategories(dataCategory.subCategories, itemCategoryRowId)));
    }

    function containedInDisplayItems(displayItems, item) {
        var length = (displayItems || []).length;
        for (var i = 0; i < length; i++) {
            if (displayItems[i].CategoryItem === item.RowId) return true;
        }

        return false;
    }

    function checkbox(node) {
        if (node.attributes.type === 'category') return false;
        else return true;
    }

    /**
     * 将项目按使用次数排序
     */
    function getSortedItems(items) {
        var sortedList = [];
        sortedList = items.sort(compareCounter);

        return sortedList;
    }

    function compareCounter(item1, item2) {
        var counter1 = item1.Counter;
        var counter2 = item2.Counter;
        counter1 = counter1 || '0';
        counter2 = counter2 || '0';

        if (Number(counter1) > Number(counter2)) return -1;
        else return 1;
    }
}));