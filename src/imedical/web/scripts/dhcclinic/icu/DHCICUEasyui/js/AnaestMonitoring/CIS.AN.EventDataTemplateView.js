//
/**
 * 事件数据模板
 * @author yongyang 2021-06-18
 */
(function(global, factory) {
    if (!global.EventDataTemplateView) factory(global.EventDataTemplateView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new EventDataTemplateView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function EventDataTemplateView(opt) {
        this.options = $.extend({ width: 1000, height: 600 }, opt);
        this.saveHandler = opt.saveHandler;
        this.init();
    }

    EventDataTemplateView.prototype = {
        constructor: EventDataTemplateView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');

            this.dataContainer = $('<div class="editor-container" style="overflow:hidden;padding:5px;"></div>').appendTo(this.dom);

            this.dom.dialog({
                right: 200,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '术后镇痛配方模板',
                modal: true,
                closed: true,
                resizable: false,
                iconCls: 'icon-paper',
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                    if (_this.options.onClose) _this.options.onClose.call(_this);
                }
            });

            this.initPanel();
        },
        initPanel: function() {
            var _this = this;
            var container = this.dataContainer;
            this.templatePanel = $('<div style="float:left;width:490px;margin-right:5px;"></div>').appendTo(container);
            this.detailPanel = $('<div style="float:left;width:490px;"></div>').appendTo(container);

            this.templatePanel.height(this.options.height - 48);
            this.detailPanel.height(this.options.height - 48);

            var panel = $('<div style="overflow:hidden;"></div>').appendTo(this.detailPanel);

            var header = $('<div style="padding:5px;border-bottom:1px dashed #ccc;"></div>').appendTo(panel);
            var btnSaveDetail = $('<a href="#" iconCls="icon-save" plain=true >保存</a>').appendTo(header);
            var btnClearDetail = $('<a href="#" iconCls="icon-cancel" plain=true >清空</a>').appendTo(header);

            btnSaveDetail.linkbutton({
                onClick: function() {
                    _this.save();
                }
            });

            btnClearDetail.linkbutton({
                onClick: function() {
                    _this.clear();
                }
            });

            var height = this.options.height - header.height() - 130;

            var content = $('<div style="height:433px;overflow-x:hidden;overflow-y:auto;padding:5px;"></div>').appendTo(panel);
            this.detailForm = $('<form></form>').appendTo(content);
            content.height(height);

            panel.panel({
                iconCls: "icon-paper",
                title: "配方明细",
                fit: true,
                headerCls: "panel-header-gray"
            });

            this.initTemplateList();
            this.initDetailForm();
        },
        initTemplateList: function() {
            var _this = this;
            var dataItem = _this.options.categoryItem.DataItem;

            var toolbar = $('<div></div>').appendTo(this.templatePanel);
            this.templateForm = $('<form></form>').appendTo(toolbar);

            this.initTemplateForm();

            var columns = [
                [
                    { field: "ShortDesc", title: "模板名称", width: 100 },
                    { field: "PermissionDesc", title: "模板类型", width: 80 },
                    { field: "CreateUserDesc", title: "创建用户", width: 80 },
                    { field: "CreateDT", title: "创建时间", width: 160 }
                ]
            ];

            var datagrid = $('<table></table>').appendTo(this.templatePanel);
            datagrid.datagrid({
                fit: true,
                title: "配方模板",
                headerCls: "panel-header-gray",
                iconCls: "icon-paper",
                rownumbers: true,
                singleSelect: true,
                toolbar: toolbar,
                columns: columns,
                url: ANCSP.DataQuery,
                onBeforeLoad: function(param) {
                    param.ClassName = ANCLS.BLL.ConfigQueries;
                    param.QueryName = "FindPreferedDataByDataItem";
                    param.Arg1 = session.ModuleID;
                    param.Arg2 = session.DeptID;
                    param.Arg3 = session.UserID;
                    param.Arg4 = dataItem;
                    param.ArgCnt = 4;
                },
                onSelect: function(rowIndex, rowData) {
                    _this.selectedTemplate = rowData;
                    _this.renderTemplateForm();
                    _this.loadDetailData();
                }
            });

            this.templateGrid = datagrid;
        },
        initTemplateForm: function() {
            var _this = this;
            var form = this.templateForm;

            this.TemplateRowId = $('<input type="hidden" name="RowId">').appendTo(form);

            var group = $('<div class="form-row-group"></div>').appendTo(form);
            var row = $('<div class="form-row"></div>').appendTo(group);
            $('<label style="margin-right:2px;">模板名称</label>').appendTo(row);
            var input = $('<input class="textbox" name="ShortDesc" style="width:120px;">').appendTo(row);
            $('<label style="margin-left:10px;margin-right:2px;">模板类型</label>').appendTo(row);
            var input = $('<input class="textbox" name="Permission" style="width:120px;">').appendTo(row);

            input.combobox({
                valueField: "value",
                textField: "text",
                data: [{
                    value: "Private",
                    text: "私有模板",
                }, {
                    value: "Public",
                    text: "公有模板"
                }],
                editable: false
            });

            var group = $('<div class="form-row-group" style="padding:3px 0"></div>').appendTo(form);
            var btnAddTemplate = $('<a href="#" iconCls="icon-add" plain=true >新增</a>').appendTo(group);
            var btnEditTemplate = $('<a href="#" iconCls="icon-write-order" plain=true >修改</a>').appendTo(group);
            var btnDelTemplate = $('<a href="#" iconCls="icon-remove" plain=true >删除</a>').appendTo(group);

            btnAddTemplate.linkbutton({
                onClick: function() {
                    _this.TemplateRowId.val('');
                    if (_this.validateTemplate()) _this.addTemplate();
                }
            });

            btnEditTemplate.linkbutton({
                onClick: function() {
                    if (_this.TemplateRowId.val() && _this.validateTemplate()) _this.editTemplate();
                }
            });

            btnDelTemplate.linkbutton({
                onClick: function() {
                    if (_this.TemplateRowId.val()) _this.removeTemplate();
                }
            });

            form.form({});
        },
        initDetailForm: function() {
            var _this = this;
            var form = this.detailForm;
            var categoryItem = this.options.categoryItem;
            this.renderDetails(categoryItem.eventDetailItems);
        },
        renderDetails: function(details) {
            var EventDetails = [];

            var detailsContainer = this.detailForm;
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
        loadDetailData: function() {
            var templateId = (this.selectedTemplate || {}).RowId || '';
            var templateDatas = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.ConfigQueries,
                QueryName: "FindPreferedEventDetail",
                Arg1: templateId,
                ArgCnt: 1
            }, "json");

            this.renderDetailForm(templateDatas);
        },
        renderTemplateForm: function() {
            var form = this.templateForm;
            form.form("load", this.selectedTemplate);
        },
        renderDetailForm: function(data) {
            var eventDetailDatas = data;

            $.each(this.EventDetails, function(index, editor) {
                var detailItem = editor.data('detailItem');
                var detailData = getEventDetailData(detailItem, eventDetailDatas);
                var detailValue = detailData.DataValue || '';
                editor[detailItem.Editor]('setValue', detailValue);
                editor.attr('data-rowid', detailData.RowId || '');
            });

            function getEventDetailData(detailItem, eventDetailDatas) {
                var value = {};
                $.each(eventDetailDatas, function(index, detailData) {
                    if (detailData.EventDetailItem === detailItem.RowId) {
                        value = detailData;
                        return false;
                    }
                });
                return value;
            }
        },
        loadData: function() {
            this.clear();
            this.templateGrid.datagrid('reload');
        },
        reload: function() {
            this.templateGrid.datagrid('reload');
        },
        setOptions: function(opt) {
            $.extend(this.options, opt);
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
            if (this.onClose) this.onClose();
        },
        clear: function() {
            $.each(this.EventDetails, function(index, editor) {
                var detailItem = editor.data('detailItem');
                editor[detailItem.Editor]('setValue', '');
                editor.attr('data-rowid', '');
            });
            this.selectedTemplate = {};
        },
        validateTemplate: function() {
            var form = this.templateForm;
            var template = form.serializeJson();

            if (template.ShortDesc && template.Permission) return true;

            return false;
        },
        addTemplate: function() {
            var form = this.templateForm;
            var datagrid = this.templateGrid;
            var categoryItem = this.options.categoryItem;
            var template = form.serializeJson();

            template.ClassName = ANCLS.Config.UserPreferedData;
            template.DataModule = session.ModuleID;
            template.Category = categoryItem.Category;
            template.CategoryItem = categoryItem.RowId;
            template.Type = "E";
            template.CreateUserID = session.UserID;
            template.UpdateUser = session.UserID;
            template.Dept = session.DeptID;
            template.Description = categoryItem.DataItemDesc;
            template.DataItem = categoryItem.DataItem;
            template.RowId = "";

            var jsonStr = dhccl.formatObjects(template);
            var saveRet = dhccl.saveDatas(ANCSP.DataListService, {
                jsonData: jsonStr
            });
            if (saveRet.indexOf("S^") === 0) {
                $.messager.popover({ msg: "新增术后镇痛配方模板成功。", type: "success", timeout: 1500 });
                form.form("clear");
                datagrid.datagrid("reload");
            } else {
                $.messager.alert("提示", "新增术后镇痛配方模板失败。", "error");
            }
        },
        editTemplate: function() {
            var selectedTemplate = this.selectedTemplate
            if (!selectedTemplate || !selectedTemplate.RowId) {
                $.messager.alert("提示", "请先选择模板，再修改。", "warning");
                return;
            }
            var form = this.templateForm;
            var datagrid = this.templateGrid;
            var categoryItem = this.options.categoryItem;
            var template = form.serializeJson();

            template.ClassName = ANCLS.Config.UserPreferedData;

            var jsonStr = dhccl.formatObjects(template);
            var saveRet = dhccl.saveDatas(ANCSP.DataListService, {
                jsonData: jsonStr
            });
            if (saveRet.indexOf("S^") === 0) {
                $.messager.popover({ msg: "修改术后镇痛配方模板成功。", type: "success", timeout: 1500 });
                form.form("clear");
                datagrid.datagrid("reload");
            } else {
                $.messager.alert("提示", "修改术后镇痛配方模板失败。", "error");
            }
        },
        removeTemplate: function() {
            var form = this.templateForm;
            var datagrid = this.templateGrid;
            var selectedTemplate = this.selectedTemplate
            if (!selectedTemplate || !selectedTemplate.RowId) {
                $.messager.alert("提示", "请先选择模板，再修改。", "warning");
                return;
            }

            $.messager.confirm('删除确认', '您确认要删除模板<b>' + selectedTemplate.ShortDesc + '</b>吗？', function(confirmed) {
                if (confirmed) execute();
            });

            function execute() {
                var saveRet = dhccl.removeData(ANCLS.Config.UserPreferedData, selectedTemplate.RowId);
                if (saveRet.indexOf("S^") === 0) {
                    $.messager.popover({ msg: "删除术后镇痛配方模板成功", type: "success", timeout: 1500 });
                    form.form("clear");
                    datagrid.datagrid("reload");
                }
            }
        },
        toData: function() {
            var templateId = (this.selectedTemplate || {}).RowId || '';
            var detailDatas = [];
            $.each(this.EventDetails, function(index, editor) {
                var detailItem = $(editor).data('detailItem');
                var dataRowId = editor.attr('data-rowid');
                var value = $(editor)[detailItem.Editor]('getText');
                if (!value) value = '';
                detailDatas.push({
                    DataValue: value,
                    DataTitle: detailItem.Description,
                    EventDetailItem: detailItem.RowId,
                    UserPreferedData: templateId,
                    RowId: (dataRowId || ''),
                    DataUnit: detailItem.Unit
                });
            });

            return detailDatas;
        },
        save: function() {
            var selectedTemplate = this.selectedTemplate
            if (!selectedTemplate || !selectedTemplate.RowId) {
                $.messager.alert("提示", "请先选择模板，再修改。", "warning");
                return;
            }
            var detailDatas = this.toData();
            var detailDataClassName = ANCLS.Config.UserPreferedEventDetail;
            if (detailDatas && detailDatas.length > 0) {
                $.each(detailDatas, function(index, eventDetailData) {
                    $.extend(eventDetailData, {
                        ClassName: detailDataClassName
                    });
                });
            }

            var saveRet = dhccl.saveDatas(ANCSP.DataListService, {
                jsonData: dhccl.formatObjects(detailDatas)
            });
            if (saveRet.indexOf("S^") === 0) {
                $.messager.popover({ msg: "保存配方明细成功", timeout: 1500, type: "success" });
                this.loadDetailData();
            } else {
                $.messager.alert("提示", "保存配方明细失败，原因：" + saveRet, "error");
            }
        }
    }
}));