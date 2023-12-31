//
/**
 * 记费结果生成
 * @author yongyang 2018-04-12
 */
(function(global, factory) {
    if (!global.chargeView) factory(global.chargeView = {});
}(this, function(exports) {

    function init(opt) {
        var view = new ChargeView(opt);
        exports.instance = view;
        return view;
    }

    exports.init = init;

    function ChargeView(opt) {
        this.options = $.extend({ width: 600, height: 420 }, opt);
        this.saveHandler = opt.saveHandler;
        this.schedule = this.options.operSchedule;
        this.groupview = groupview;
        this.itemview = itemview;
        this.isItemLoaded = false;
        this.init();
    }

    ChargeView.prototype = {
        constructor: ChargeView,
        init: function() {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            var btn_save = $('<a href="#"></a>').linkbutton({
                text: '保存',
                iconCls: 'icon-save',
                onClick: function() {
                    _this.save();
                }
            }).appendTo(buttons);
            this.btn_print = $('<a href="#"></a>').linkbutton({
                text: '打印',
                disabled: true,
                iconCls: 'icon-print',
                onClick: function() {
                    _this.print();
                }
            }).appendTo(buttons);
            var btn_cancel = $('<a href="#"></a>').linkbutton({
                text: '关闭',
                iconCls: 'icon-cancel',
                onClick: function() {
                    _this.close();
                }
            }).appendTo(buttons);

            this.header = $('<div class="chargeview-header"></div>').appendTo(this.dom);
            this.itemContainer = $('<div class="chargeview-container"></div>').appendTo(this.dom);

            this.dom.dialog({
                left: 300,
                top: 50,
                height: this.options.height,
                width: this.options.width,
                title: '记费项目登记',
                modal: true,
                closed: true,
                resizable: true,
                buttons: buttons,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.initHeader();

            this.itemContainer.delegate('.chargeview-item-plus', 'click', function() {
                var typeEl = $(this).siblings('.chargeview-item-type');
                var types = [];
                if (typeEl.length > 0) types = typeEl.data('data');
                var codeStr = typeEl.text();
                var billNOStr = typeEl.attr('title');

                var itemElement = $($(this).parent());
                var item = itemElement.data('item');
                var data = itemElement.data('data');
                if (data) {
                    data.Qty = Number(data.Qty) + 1;
                } else {
                    data = {
                        ChargeRecord: '',
                        ChargeItem: item.RowId,
                        ChargeItemDesc: item.Description,
                        Qty: 1,
                        Unit: item.Unit,
                        Price: item.Price,
                        TypeCode: codeStr,
                        BillNO: billNOStr
                    }
                }

                itemview.loadData(item.target, data);
                _this.btn_print.linkbutton('disable');
            });

            this.itemContainer.delegate('.chargeview-item-minus', 'click', function() {
                var typeEl = $(this).siblings('.chargeview-item-type');
                var types = [];
                if (typeEl.length > 0) types = typeEl.data('data');
                var codeStr = typeEl.text();
                var billNOStr = typeEl.attr('title');

                var itemElement = $($(this).parent());
                var item = itemElement.data('item');
                var data = itemElement.data('data');
                if (data) {
                    data.Qty = Number(data.Qty) - 1;
                    if (data.Qty < 0) data.Qty = 0;
                } else {
                    data = {
                        ChargeRecord: '',
                        ChargeItem: item.RowId,
                        ChargeItemDesc: item.Description,
                        Qty: 0,
                        Unit: item.Unit,
                        Price: item.Price,
                        TypeCode: codeStr,
                        BillNO: billNOStr
                    }
                }
                itemview.loadData(item.target, data);
                _this.btn_print.linkbutton('disable');
            });

            this.itemContainer.delegate('.chargeview-item-type', 'mouseenter', function() {
                $(this).siblings('.chargeview-item-type-selectview').show();
            });

            this.itemContainer.delegate('.chargeview-item-type-selectview', 'mouseleave', function() {
                $(this).hide();
            });

            this.itemContainer.delegate('.chargeview-item-type-i', 'click', function() {
                var selectview = $(this).parent().parent();
                var typeEl = selectview.siblings('.chargeview-item-type');
                var itemElement = typeEl.parent();
                $(this).toggleClass('chargeview-item-type-i-selected');

                var selectedTypeEls = selectview.find('.chargeview-item-type-i-selected');
                var selectedTypes = [],
                    codes = [],
                    billNos = [],
                    type;
                for (var i = 0, length = selectedTypeEls.length; i < length; i++) {
                    type = $(selectedTypeEls[i]).data('data');
                    selectedTypes.push(type);
                    codes.push(type.TypeCode);
                    billNos.push(type.BillNO)
                }

                var codeStr = codes.join(',');
                var billNOStr = billNos.join(',');
                $(typeEl).data('data', selectedTypes)
                    .text(codeStr)
                    .attr('title', billNOStr);

                var item = itemElement.data('item');
                var data = itemElement.data('data');
                if (data) {
                    data.TypeCode = codeStr;
                    data.BillNO = billNOStr;
                } else {
                    data = {
                        ChargeRecord: '',
                        ChargeItem: item.RowId,
                        ChargeItemDesc: item.Description,
                        Qty: 0,
                        Unit: item.Unit,
                        Price: item.Price,
                        TypeCode: codeStr,
                        BillNO: billNOStr
                    }
                }
                itemview.loadData(item.target, data);
                selectview.hide();
                _this.btn_print.linkbutton('disable');
            });

            this.itemContainer.delegate('input.chargeview-item-value', 'keyup', function() {
                var typeEl = $(this).siblings('.chargeview-item-type');
                var types = [];
                if (typeEl.length > 0) types = typeEl.data('data');
                var codeStr = typeEl.text();
                var billNOStr = typeEl.attr('title');

                var qty = $(this).val();
                var itemElement = $($(this).parent());
                var item = itemElement.data('item');
                var data = itemElement.data('data');
                if (data) {
                    data.Qty = Number(qty);
                } else {
                    data = {
                        ChargeRecord: '',
                        ChargeItem: item.RowId,
                        ChargeItemDesc: item.Description,
                        Qty: qty,
                        Unit: item.Unit,
                        Price: item.Price,
                        TypeCode: codeStr,
                        BillNO: billNOStr
                    }
                }
                itemview.loadData(item.target, data);
                _this.btn_print.linkbutton('disable');
            });
        },
        initHeader: function() {
            var _this = this;
            this.switchCharged = $('<span style="margin-right:10px;"></span>')
                .appendTo(this.header)
                .switchbox({
                    size: 'small',
                    animated: true,
                    onText: '已记',
                    offText: '全部',
                    onClass: 'primary',
                    offClass: 'gray',
                    checked: false,
                    onSwitchChange: function(e, value) {
                        _this.filter();
                    },
                });

            this.searchbox = $('<input>')
                .appendTo(this.header)
                .searchbox({
                    width: 160,
                    prompt: '输入名称或简拼检索'
                });

            var inputRect = this.searchbox.siblings('.searchbox');
            $(inputRect).find('input').keyup(function() {
                var text = $(this).val().toUpperCase();
                _this.FilterText = text;
                _this.filter();
            });

            var btn_generate = $('<a href="#" style="margin-left:10px;display:none;"></a>').linkbutton({
                text: '生成',
                iconCls: 'icon-listitem',
                onClick: function() {
                    _this.generate();
                }
            }).appendTo(this.header);
        },
        render: function(data) {
            var itemDic = {};

            var length = this.items.length;
            for (var i = 0; i < length; i++) {
                var item = this.items[i];
                itemDic[item.RowId] = item;
            }

            var length = data.length;
            for (var i = 0; i < length; i++) {
                var row = data[i];
                if (itemDic[row.ChargeItem]) {
                    var element = itemDic[row.ChargeItem].target;
                    if (element) this.itemview.loadData($(element), row);
                }
            }
            this.btn_print.linkbutton('enable');
        },
        loadItem: function(data) {
            this.items = data;
            this.isItemLoaded = true;
            this.groups = groupingData(data);
            var length = this.groups.length;
            for (var i = 0; i < length; i++) {
                var groupElement = $('<div class="chargeview-group"></div>').appendTo(this.itemContainer);
                this.groupview.render(groupElement, this.groups[i]);
            }

            if (this.waitingDatas) {
                this.render(this.waitingDatas);
                this.waitingDatas = null;
            }
        },
        loadData: function(data) {
            if (this.isItemLoaded) this.render(data);
            else this.waitingDatas = data;
        },
        filter: function() {
            var text = this.FilterText || '';
            var switchCharged = $HUI['switchbox'](this.switchCharged).getValue();
            var visible = true;
            this.dom.find('.chargeview-item').each(function(index, e) {
                var value = $(e).find('.chargeview-item-value').val();
                visible = true;
                if (switchCharged) {
                    if (!value || !Number(value)) visible = false;
                }
                var item = $(e).data('item');
                var desc = $(e).find('.chargeview-item-name').text();
                var alias = item.Alias;
                if (desc.indexOf(text) > -1 || alias.indexOf(text) > -1) visible = visible && true;
                else visible = false;

                if (visible) $(e).show();
                else $(e).hide();
            })
        },
        setPrintCount: function() {

        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            var itemview = this.itemview;
            this.dom.find('.charge-item').each(function(index, e) {
                itemview.clear($(e));
            })
        },
        generate: function() {

        },
        save: function() {
            var datas = [];
            var opsId = session.OPSID;
            var userId = session.UserID;
            var deptId = session.DeptID;
            this.dom.find('.chargeview-item').each(function(index, e) {
                var item = $(e).data('item');
                var data = $(e).data('data');
                if (data && (data.RowId || Number(data.Qty) > 0)) {
                    datas.push($.extend(data, {
                        OperSchedule: opsId,
                        ChargeItemDesc: item.Description,
                        BillDept: deptId,
                        ExecDept: deptId,
                        UserDept: deptId,
                        CreateUser: userId,
                        UpdateUser: userId,
                        isRemoved: Number(data.Qty) == 0 ? 'Y' : 'N'
                    }));
                }
            });

            if (this.saveHandler) {
                this.saveHandler(datas);
                this.btn_print.linkbutton('enable');
            }
        },
        sign: function() {

        },
        print: function() {
            var lodop = getLodop();
            lodop.SET_PRINT_PAGESIZE(1, 0, 0, 'A4');

            lodop.SET_PRINT_STYLE("FontName", "microsoft yahei");
            lodop.SET_PRINT_STYLE("FontSize", 10);
            //lodop.SET_PRINT_STYLE("Bold", 1);
            lodop.ADD_PRINT_TEXT(10, 320, "100%", 60, "麻醉记费处方登记单");
            lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
            lodop.SET_PRINT_STYLEA(0, "FontSize", 18);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);
            lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
            lodop.SET_PRINT_STYLEA(0, "Horient", 2);
            lodop.SET_PRINT_STYLEA(0, "ItemType", 1);

            var titleLineHeight = 40,
                contentLineMargin = 20;
            var startPos = { x: 0, y: 0 },
                linePos = { x: 0, y: 0 };
            startPos.y += titleLineHeight;
            linePos.y = startPos.y + contentLineMargin;
            lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, this.schedule["AdmReason"] || '');
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            startPos.y += 35;
            linePos.y = startPos.y + contentLineMargin;
            lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "姓名");
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);
            lodop.ADD_PRINT_LINE(linePos.y, 60, linePos.y, 140, 0, 1);
            lodop.ADD_PRINT_TEXT(startPos.y, 60, 80, 15, this.schedule["PatName"] || ' ');
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            lodop.ADD_PRINT_TEXT(startPos.y, 150, 200, 15, "科室");
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);
            lodop.ADD_PRINT_LINE(linePos.y, 190, linePos.y, 330, 0, 1);
            lodop.ADD_PRINT_TEXT(startPos.y, 190, 200, 15, this.schedule["PatDeptDesc"] || ' ');
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            lodop.ADD_PRINT_TEXT(startPos.y, 340, 200, 15, "住院号");
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);
            lodop.ADD_PRINT_LINE(linePos.y, 395, linePos.y, 480, 0, 1);
            lodop.ADD_PRINT_TEXT(startPos.y, 395, 200, 15, this.schedule["MedcareNo"] || ' ');
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            lodop.ADD_PRINT_TEXT(startPos.y, 490, 200, 15, "诊断");
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);
            lodop.ADD_PRINT_LINE(linePos.y, 530, linePos.y, 620, 0, 1);
            lodop.ADD_PRINT_TEXT(startPos.y, 530, 100, 15, this.schedule["PrevDiagnosisDesc"] || ' ');
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            lodop.ADD_PRINT_TEXT(startPos.y, 630, 200, 15, "手术间");
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);
            lodop.ADD_PRINT_LINE(linePos.y, 685, linePos.y, 740, 0, 1);
            lodop.ADD_PRINT_TEXT(startPos.y, 685, 200, 15, this.schedule["RoomDesc"] || ' ');
            lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            // 麻醉操作和耗材  宽度合计为720
            // 第1行6项，第2行5项，第3行6行，第4行7项，第5行6项，第6行6项
            startPos.y += 40;
            startPos.x = 20;
            var groupMarginTop = 20;
            var startX = 20;
            var height = 36;
            var padding = {
                top: 8,
                left: 5,
                right: 15
            }
            var description = "",
                text = "",
                unitDesc = "";
            var group = this.groups[0];
            var itemLength = 34;
            var item = null;
            var widthList = [
                120, 120, 120, 120, 120, 120,
                130, 140, 150, 150, 150,
                275, 85, 85, 275,
                140, 135, 85, 85, 80, 80, 115,
                175, 100, 85, 85, 160, 115,
                110, 120, 100, 80, 195, 115
            ];
            var newLineIndex = [6, 11, 15, 22, 28, 34];
            var specialPaddingRightDic = {
                11: 150,
                14: 160
            }
            var cellCount = 0,
                width = 0,
                specialPaddingRight = 0,
                isFirstRow = true;
            for (var j = 0; j < itemLength; j++) {
                item = this.items[j];
                width = widthList[j];

                description = item.Description;
                text = "";
                unitDesc = '';
                if (!item.Qty || Number(item.Qty) <= 0) text = "";
                if (!isFirstRow && Number(item.Qty) == 1) text = "√";
                else text = item.Qty || '';
                if (isFirstRow) unitDesc = item.UnitDesc || '';

                text = text + '';
                specialPaddingRight = specialPaddingRightDic[j] || 0;

                printCell(startPos, width, padding, specialPaddingRight);

                cellCount++;
                startPos.x += width;
                if (newLineIndex.indexOf(cellCount) > -1) {
                    isFirstRow = false;
                    startPos.x = startX;
                    startPos.y += height;
                }
            }

            // 毒麻药 5个换行
            startPos.y += groupMarginTop;

            var group = this.groups[1];
            var emptyCells = [8, 9];
            var cellCount = 0,
                width = 144;
            var itemLength = 5;
            var item = null;
            startPos.x = startX;

            for (var j = 34; j < 42; j++) {
                item = this.items[j];

                description = item.Description;
                text = item.Qty || '';
                text = text + '';
                unitDesc = item.UnitDesc || '';
                printCell(startPos, width, padding);

                cellCount++;
                startPos.x += width;
                if (cellCount % 5 == 0) {
                    startPos.x = startX;
                    startPos.y += height;
                }

                while (emptyCells.indexOf(cellCount) > -1) {
                    text = '';
                    unitDesc = '';
                    description = '';
                    printCell(startPos, width, padding);
                    cellCount++;
                    startPos.x += width;
                    if (cellCount % 5 == 0) {
                        startPos.x = startX;
                        startPos.y += height;
                    }
                }
            }

            // 急救药 每6个换行
            startPos.y += groupMarginTop;

            var length = this.groups.length;
            var emptyCells = [3, 4, 5, 10, 11, 35, 72, 74, 83];
            var cellCount = 0,
                width = 120;
            var itemLength = group.items.length;
            var item = null;
            startPos.x = startX;

            for (var j = 42; j < 78; j++) {
                item = this.items[j];

                description = item.Description;
                text = item.Qty || '';
                unitDesc = item.UnitDesc || '';
                text = text + '';
                printCell(startPos, width, padding);

                cellCount++;
                startPos.x += width;
                if (cellCount % 6 == 0) {
                    startPos.x = startX;
                    startPos.y += height;
                }

                while (emptyCells.indexOf(cellCount) > -1) {
                    text = '';
                    unitDesc = '';
                    description = '';
                    printCell(startPos, width, padding);
                    cellCount++;
                    startPos.x += width;
                    if (cellCount % 6 == 0) {
                        startPos.x = startX;
                        startPos.y += height;
                    }
                }
            }

            // 特殊管制药 每6个换行
            startPos.y += groupMarginTop;

            var emptyCells = [30, 32, 41];
            var cellCount = 0,
                width = 120;
            var itemLength = this.items.length;
            var item = null;
            startPos.x = startX;

            for (var j = 78; j < itemLength; j++) {
                item = this.items[j];

                description = item.Description;
                text = item.Qty || '';
                unitDesc = item.UnitDesc || '';
                text = text + '';
                printCell(startPos, width, padding);

                cellCount++;
                startPos.x += width;
                if (cellCount % 6 == 0) {
                    startPos.x = startX;
                    startPos.y += height;
                }

                while (emptyCells.indexOf(cellCount) > -1) {
                    text = '';
                    unitDesc = '';
                    description = '';
                    printCell(startPos, width, padding);
                    cellCount++;
                    startPos.x += width;
                    if (cellCount % 6 == 0) {
                        startPos.x = startX;
                        startPos.y += height;
                    }
                }
            }

            startPos.y += groupMarginTop;

            htmlArr = [
                "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;}",
                "td {text-align:left;font-size:16px;font-weight:bold;width:141px;vertical-align:middle;background-color:#eee;} tr {height:60px;}",
                "</style>",
                "<table><thead></thead><tbody><tr>",
                "<td></td><td></td><td></td><td></td><td></td></tr></tbody></table>",
            ];
            startPos.x = startX;
            startPos.y = 985;
            lodop.ADD_PRINT_TABLE(startPos.y, startPos.x, "100%", "100%", htmlArr.join(""));

            var width = 144,
                fontsize = 14;
            startPos.y += 18;
            startPos.x += 5;
            lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "麻醉师：" + (this.schedule["AnesthesiologistDesc"] || ''));
            lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            startPos.x += width;
            lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "处方");
            lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            startPos.x += width;
            lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "计费");
            lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            startPos.x += width;
            lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "发药");
            lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            startPos.x += width;
            lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "审核");
            lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            startPos.y += 50;
            lodop.ADD_PRINT_TEXT(startPos.y, 630, 200, 15, this.schedule["OperDate"] || '');
            lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
            lodop.SET_PRINT_STYLEA(0, "Bold", 1);

            lodop.PREVIEW();

            function printCell(startPos, width, padding, specialPaddingRight) {
                var axis = { x: startPos.x, y: startPos.y };
                lodop.ADD_PRINT_RECT(axis.y, axis.x, width, height, 0, 1);

                axis.y = startPos.y + padding.top;
                axis.x = startPos.x + padding.left;
                lodop.ADD_PRINT_TEXT(axis.y, axis.x, "100%", 15, description);

                if (text) {
                    var fontsize = 15;
                    axis.y = startPos.y + (padding.top / 2);
                    var padding_right = padding.right * (text.length + unitDesc.length);
                    if (!padding_right) padding_right = padding.right;
                    axis.x = startPos.x + width - padding_right;
                    if (specialPaddingRight) axis.x = startPos.x + width - specialPaddingRight;
                    if (text == "√") {
                        fontsize = 18;
                        axis.x -= 5;
                    }
                    lodop.ADD_PRINT_TEXT(axis.y, axis.x, "100%", 15, text);
                    lodop.SET_PRINT_STYLEA(0, "FontSize", fontsize);
                    lodop.SET_PRINT_STYLEA(0, "Bold", 1);
                }

                axis.y = startPos.y + padding.top;
                axis.x = startPos.x + width - (padding.right * 1);
                lodop.ADD_PRINT_TEXT(axis.y, axis.x, "100%", 15, unitDesc);
            }
        }
    }

    function groupingData(data) {
        var groups = [];
        var groupKeys = [];
        $.each(data, function(index, row) {
            var key = row.ChargeCategoryDesc;
            var keyIndex = groupKeys.indexOf(key);
            var group = null;
            if (keyIndex > -1) {
                group = groups[keyIndex];
            } else {
                group = {
                    Desc: key,
                    items: []
                }
                groups.push(group);
                groupKeys.push(key);
            }

            group.items.push(row);
        });

        return groups;
    }

    var itemview = {
        render: function(container, item) {
            container.empty();
            container.data('item', item);
            container.attr('id', 'chargeview_item_' + item.RowId);
            item.target = container;

            $('<span class="chargeview-item-name"></span>')
                .text(item.Description)
                .attr('title', item.Description)
                .appendTo(container);

            if (item.Type) {
                var typelist = $.trim(item.Type);
                typelist = $.parseJSON(typelist);

                var typeSelectView = $('<div class="chargeview-item-type-selectview" style="display:none;"></div>').appendTo(container);
                var typeSelectContainer = $('<div class="chargeview-item-type-selectview-container"></div>').appendTo(typeSelectView);
                for (var i = 0, length = typelist.length; i < length; i++) {
                    typelist[i].target = $('<span class="chargeview-item-type-i"></span>')
                        .text(typelist[i].TypeCode)
                        .data('data', typelist[i])
                        .attr('title', typelist[i].BillNO)
                        .appendTo(typeSelectContainer);
                }

                item.typelist = typelist;

                $('<span class="chargeview-item-type"></span>')
                    .text(typelist[0].TypeCode)
                    .data('data', typelist[0])
                    .attr('title', typelist[0].BillNO)
                    .appendTo(container);

                typeSelectView.find('.chargeview-item-type-i:first').addClass('chargeview-item-type-i-selected');
                container.addClass('chargeview-item-multitype');
            }

            $('<input class="chargeview-item-value textbox" type="text">').appendTo(container);
            $('<span class="chargeview-item-uom"></span>').text(item.UnitDesc).appendTo(container);
            $('<a href="javascript:;" class="chargeview-button chargeview-item-plus"><span class="fas fa-plus"></span></a>').appendTo(container);
            $('<a href="javascript:;" class="chargeview-button chargeview-item-minus"><span class="fas fa-minus"></span></a>').appendTo(container);
        },
        loadData: function(container, data) {
            var item = container.data('item');
            item.Qty = data.Qty;

            var typeCodeStr = data.TypeCode;
            var typelist = item.typelist;
            container.find('.chargeview-item-type-i').removeClass('chargeview-item-type-i-selected');
            if (typeCodeStr) {
                var typeCodeList = typeCodeStr.split(',');
                for (var i = 0, length = typelist.length; i < length; i++) {
                    if (typeCodeList.indexOf(typelist[i].TypeCode) > -1) {
                        typelist[i].target.addClass('chargeview-item-type-i-selected');
                    }
                }
            }

            container.data('data', data);
            container.find('.chargeview-item-value').val(data.Qty);
            if (Number(data.Qty) > 0) {
                container.addClass('chargeview-item-selected');
            } else {
                container.removeClass('chargeview-item-selected');
            }
        },
        clear: function(container) {
            container.data('data', null);
            container.removeClass('chargeview-item-selected');
            container.find('.chargeview-item-type-i').removeClass('chargeview-item-type-i-selected');
            container.find('.chargeview-item-value').val('');
        }
    }

    var groupview = {
        render: function(container, group) {
            container.empty();
            container.data('group', group);
            group.target = container;

            $('<div class="chargeview-group-header"></div>')
                .append('<span class="header-text">' + group.Desc + '</span>')
                .appendTo(container);
            var itemscontainer = $('<div class="chargeview-group-container"></div>').appendTo(container);

            var length = group.items.length;
            for (var i = 0; i < length; i++) {
                var element = $('<div class="chargeview-item"></div>').appendTo(itemscontainer);
                itemview.render(element, group.items[i]);
            }
        }
    }
}));