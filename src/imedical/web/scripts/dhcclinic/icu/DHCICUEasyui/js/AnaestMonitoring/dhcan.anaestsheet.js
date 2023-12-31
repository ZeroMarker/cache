/**
 * 麻醉记录表单构造函数
 * @param {object} options - 麻醉记录表单初始化选项
 * @author chenchangqing 20170711
 */
function AnaestSheet(options) {
    this.dataContext = options.dataContext;
    this.canvas = options.canvas;
    this.totalPageCount = 1;
    this.drawContext = this.canvas.getContext("2d");
    //this.drawContext.scale(window.devicePixelRatio || 1, window.devicePixelRatio || 1);
    this.initSheet();
}

/**
 * 麻醉记录表单原型对象
 * @author chenchangqing 20170711
 */
AnaestSheet.prototype = {
    constructor: AnaestSheet,
    /**
     * 根据JSON文件初始化麻醉记录表单
     * @author chenchangqing 20170711
     */
    initSheet: function() {
        // 页码
        this.currentPageNo = 1;

        // 初始化
        this.initAction();
        this.initFonts();
        // this.setRecordStartDT();
    },

    /**
     * 初始化操作行为对象
     * @author chenchangqing 20170711
     */
    initAction: function() {
        // 鼠标点击对象
        this.clickInfo = {
            location: null,
            area: null,
            category: null,
            item: null,
            categoryItem: null,
            eventLegendItem: null,
            displayData: null,
            locDT: null,
            dataItem: null,
            button: 0,
            value: null
        };

        // 鼠标点击原始对象
        this.originalClickInfo = {
            location: null,
            area: null,
            category: null,
            item: null,
            categoryItem: null,
            eventLegendItem: null,
            displayData: null,
            locDT: null,
            dataItem: null,
            button: 0,
            value: null
        };

        // 鼠标移动对象
        this.moveInfo = {
            location: null,
            area: null,
            category: null,
            item: null,
            categoryItem: null,
            displayData: null,
            locDT: null,
            value: null
        };

        // 折线图绘制上下文对象
        this.chartInfo = {
            item: null,
            categoryItem: null,
            lineDT: null
        };
    },

    /**
     * 初始化字体对象集合
     * @author chenchangqing 20170711
     */
    initFonts: function() {
        this.fonts = [];
        if (this.dataContext.fonts) {
            for (var key in this.dataContext.fonts) {
                var element = this.dataContext.fonts[key];
                this.fonts[key] = new Font(element);
            }
        }
    },

    /**
     * 绘制麻醉记录单页面
     */
    drawPage: function() {
        this.drawContext.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.drawTitles();
        this.drawPageNo();
        this.drawHeaders();
        this.drawBorder();
        this.setAreaItems();
        this.drawAreas();
        this.drawDisplayItems();
    },

    /**
     * 绘制麻醉记录表单标题、副标题、页码等信息。
     * @author chenchangqing 20170711
     */
    drawTitles: function() {
        if (!this.dataContext.titles) return;
        for (var key in this.dataContext.titles) {
            var element = this.dataContext.titles[key],
                font = this.fonts[key],
                colorStyle = this.dataContext.colors[key],
                fontStyle = font.style,
                titleWidth = this.drawContext.measureTextWidth(element.title, colorStyle, fontStyle),
                titleHeight = font.height;
            element.rect = new Rectangle(element.location, { width: titleWidth, height: titleHeight });
            // 标题居中，更改X坐标
            var location = new Point(element.location.x, element.location.y);
            location.x = (this.dataContext.page.size.width - titleWidth) / 2;
            this.drawContext.drawString(element.title, location, colorStyle, fontStyle);
        }
    },
    /**
     * 绘制页码
     */
    drawPageNo: function() {
        var pos = this.dataContext.page.pageNoLoc;
        var pageNoTitle = "第" + this.currentPageNo + "页/共" + this.totalPageCount + "页";
        this.drawContext.fillRectangle(new Rectangle({
            x: pos.x,
            y: pos.y
        }, {
            width: 90,
            height: 12
        }), 'white');
        this.drawContext.drawString(pageNoTitle, pos, this.dataContext.colors.mainTitle, this.fonts.item.style);
    },

    /**
     * 绘制头标题(在矩形区域外面的标题)
     * @author chenchangqing 20170711
     */
    drawHeaders: function() {
        if (!this.dataContext.headers) return;
        for (var key in this.dataContext.headers) {
            var element = this.dataContext.headers[key],
                titleWidth = this.drawContext.measureTextWidth(element.title, this.dataContext.colors.item, this.fonts.item.style);
            element.rect = new Rectangle(element.location, { width: titleWidth, height: this.fonts.item.height });
            this.drawContext.drawString(element.title, element.location, this.dataContext.colors.item, this.fonts.item.style);
            var elementValue = this.dataContext.schedule[key];
            var valueLoc = {
                x: element.location.x + titleWidth,
                y: element.location.y
            };
            this.drawContext.drawString(elementValue, valueLoc, this.dataContext.colors.data, this.fonts.item.style);
        }
    },

    /**
     * 绘制边框
     * @author chenchangqing 20170711
     */
    drawBorder: function() {
        var contentHeight = this.getContentHeight();
        this.dataContext.content.size.height = contentHeight;
        this.dataContext.content.rect = new Rectangle(this.dataContext.content.location, this.dataContext.content.size);
        this.drawContext.drawRectangle(this.dataContext.content.rect, this.dataContext.colors.border);

    },

    /**
     * 绘制显示区域
     * @author chenchangqing 20170711
     */
    drawAreas: function() {
        if (!this.dataContext.displayAreas) return;
        // 根据显示区域布局，设置显示区域的起始坐标以及绘制显示区域的边框
        var layouts = this.dataContext.content.arealayout;
        if (layouts && layouts.length > 0) {
            var startPos = { x: this.dataContext.content.location.x, y: this.dataContext.content.location.y };
            for (var i = 0; i < layouts.length; i++) {
                var layoutRow = layouts[i];
                startPos.x = this.dataContext.content.location.x;
                for (var j = 0; j < layoutRow.length; j++) {
                    var layoutItem = layoutRow[j];
                    var area = this.getDisplayArea(layoutItem.code);
                    if (!area) continue;
                    area.rect = new Rectangle(startPos, area.size);
                    this.drawContext.drawRectangle(area.rect, this.dataContext.colors.border);
                    startPos.x += area.rect.width;
                }
                var rowHeight = this.getAreaRowHeight(layoutRow);
                startPos.y += rowHeight;
            }
        }

        // 绘制显示区域的内容
        var areas = this.dataContext.displayAreas;
        for (var key in areas) {
            var area = this.dataContext.displayAreas[key];
            if (!area.drawMethods) continue;
            for (var i = 0; i < area.drawMethods.length; i++) {
                var drawMethod = area.drawMethods[i];
                //var execFunc = "this." + drawMethod + "(area)";
                //eval(execFunc);
                if (this[drawMethod]) this[drawMethod](area);
            }
        }
    },

    /**
     * 设置显示区域项的值
     * @author chenchangqing 20170808
     */
    setAreaItems: function() {
        var displayAreas = this.dataContext.displayAreas;
        for (var key in displayAreas) {
            var displayArea = displayAreas[key];
            if (displayArea.dataItems && displayArea.dataItems.length > 0) {
                for (var i = 0; i < displayArea.dataItems.length; i++) {
                    var dataItemRow = displayArea.dataItems[i];
                    for (var j = 0; j < dataItemRow.length; j++) {
                        var dataItem = dataItemRow[j];
                        if (this.dataContext.schedule[dataItem.code] || this.dataContext.schedule[dataItem.code] === '') {
                            dataItem.value = this.dataContext.schedule[dataItem.code];
                        }
                    }
                }
            }
        }
    },

    /**
     * 绘制显示区域项
     * @param {object} area - 显示区域对象
     * @author chenchangqing 20170711
     */
    drawAreaItems: function(area) {
        if (!area.dataItems || area.dataItems.length <= 0) return;
        var colorStyle = this.dataContext.colors.item,
            dataColorStyle = this.dataContext.colors.data,
            fontStyle = this.fonts.item.style,
            fontHeight = this.fonts.item.height,
            itemMargin = 10,
            lineMargin = 10,
            bottomMargin = 3,
            titleMargin = 2,
            unitMargin = 2;
        for (var i = 0; i < area.dataItems.length; i++) {
            // 每行显示区域项组成一个数组
            var dataItems = area.dataItems[i],
                itemWidth = itemMargin;
            for (var j = 0; j < dataItems.length; j++) {
                var dataItem = dataItems[j];
                var titleWidth = this.drawContext.measureTextWidth(dataItem.title, colorStyle, fontStyle);
                var checkboxRect = null;
                var textMarginLeft = dataItem.marginLeft || 0;

                dataItem.rect = new Rectangle({
                    x: area.rect.left + itemWidth,
                    y: area.rect.top + lineMargin + i * (fontHeight + lineMargin)
                }, {
                    width: dataItem.width,
                    height: dataItem.rowSpan ? (dataItem.rowSpan * (fontHeight + lineMargin) - lineMargin + bottomMargin) : (fontHeight + bottomMargin)
                });

                if (dataItem.editType === 'checkbox') {
                    checkboxRect = new Rectangle({
                        x: area.rect.left + itemWidth + textMarginLeft,
                        y: area.rect.top + lineMargin + i * (fontHeight + lineMargin)
                    }, {
                        width: 16,
                        height: 16
                    });
                    this.drawContext.drawRectangle(checkboxRect, colorStyle);
                    if (dataItem.value == dataItem.valueOfChecked) {
                        this.drawContext.drawLine({
                            x: checkboxRect.left + 2,
                            y: checkboxRect.top + 10
                        }, {
                            x: checkboxRect.left + 6,
                            y: checkboxRect.bottom - 2
                        }, dataColorStyle, 2);
                        this.drawContext.drawLine({
                            x: checkboxRect.left + 6,
                            y: checkboxRect.bottom - 2
                        }, {
                            x: checkboxRect.right - 2,
                            y: checkboxRect.top + 2
                        }, dataColorStyle, 2);
                    }
                    dataItem.lineStartPos = {
                        x: checkboxRect.left,
                        y: checkboxRect.top
                    };
                    dataItem.lineEndPos = {
                        x: checkboxRect.right,
                        y: checkboxRect.bottom
                    };
                    dataItem.valueStartPos = {
                        x: checkboxRect.left,
                        y: checkboxRect.top
                    };
                    textMarginLeft = textMarginLeft + checkboxRect.width + 3;
                }

                this.drawContext.drawString(dataItem.title, {
                    x: dataItem.rect.left + textMarginLeft,
                    y: dataItem.rect.top
                }, colorStyle, fontStyle);

                var unitWidth = this.drawContext.measureTextWidth(dataItem.unit || '', colorStyle, fontStyle);
                this.drawContext.drawString(dataItem.unit || '', {
                    x: dataItem.rect.right - unitWidth - unitMargin,
                    y: dataItem.rect.top
                }, colorStyle, fontStyle);


                // 绘制显示区域项的下划线

                if (!dataItem.rowSpan || dataItem.rowSpan === 1) {
                    dataItem.lineStartPos = {
                        x: dataItem.rect.left + textMarginLeft + titleWidth + titleMargin,
                        y: dataItem.rect.bottom
                    };
                    dataItem.lineEndPos = {
                        x: dataItem.rect.right - unitWidth - unitMargin,
                        y: dataItem.rect.bottom
                    };
                    dataItem.valueStartPos = {
                        x: dataItem.lineStartPos.x,
                        y: dataItem.rect.top
                    };
                    if (dataItem.underline) { this.drawContext.drawLine(dataItem.lineStartPos, dataItem.lineEndPos, colorStyle); }
                    if (dataItem.value) {
                        this.drawContext.drawString(dataItem.value, dataItem.valueStartPos, dataColorStyle, fontStyle);
                    }
                } else {
                    dataItem.lineStartPos = {
                        x: dataItem.rect.left + textMarginLeft + titleMargin,
                        y: dataItem.rect.top + fontHeight + bottomMargin
                    };
                    dataItem.lineEndPos = {
                        x: dataItem.rect.right,
                        y: dataItem.rect.top + fontHeight + bottomMargin
                    };
                    dataItem.valueStartPos = {
                        x: dataItem.lineStartPos.x,
                        y: dataItem.rect.top + fontHeight + bottomMargin
                    };
                    var border = dataItem.rect.border;
                    if (dataItem.underline) {
                        this.drawContext.drawLine(border.top.start, border.top.end, colorStyle);
                        this.drawContext.drawLine(border.bottom.start, border.bottom.end, colorStyle);
                        this.drawContext.drawLine(border.left.start, border.left.end, colorStyle);
                        this.drawContext.drawLine(border.right.start, border.right.end, colorStyle);
                    }
                    if (dataItem.value) {
                        var dataFont = this.fonts.item;
                        var valueStrList = this.getEventDetailArray(dataItem.value, dataItem.rect.width, dataFont, dataColorStyle);
                        var linePadding = 1.5,
                            lineHeight = dataFont.height + linePadding;
                        var valueLength = valueStrList.length;
                        var pos = {
                            x: dataItem.valueStartPos.x,
                            y: dataItem.valueStartPos.y
                        }
                        for (var valueIndex = 0; valueIndex < valueLength; valueIndex++) {
                            pos.y = dataItem.valueStartPos.y + (valueIndex * lineHeight);
                            this.drawContext.drawString(valueStrList[valueIndex], pos, dataColorStyle, fontStyle);
                        }
                    }
                }

                itemWidth += dataItem.width + itemMargin;
            }
        }
    },

    /**
     * 设置麻醉监护开始时间
     * @param {DateTime} recordStartDT - 监护开始时间，由用户确定
     * @author chenchangqing20170717
     */
    setRecordStartDT: function(recordStartDT) {
        var timeLineArea = this.dataContext.displayAreas.timeLine;
        if (recordStartDT) {
            timeLineArea.recordStartDT = recordStartDT;
        } else {
            timeLineArea.recordStartDT = this.dataContext.recordStartDT;
        }
        timeLineArea.startDT = this.getFirstPageStartDT(timeLineArea.recordStartDT);
        timeLineArea.endDT = timeLineArea.startDT.addHours(timeLineArea.column.count * 6); //需要修改
        //timeLineArea.prevPageStartDT = timeLineArea.pageStartDT = timeLineArea.firstPageStartDT = this.getFirstPageStartDT(timeLineArea.recordStartDT);
        //timeLineArea.pageEndDT = timeLineArea.pageStartDT.addHours(timeLineArea.column.count);
    },
    /**
     * 获取麻醉监护起始页面开始时间
     * @param {DateTime} recordStartDT - 监护开始时间
     * @returns {string} 起始页面的开始时间
     * @author chenchangqing 20170829
     */
    getFirstPageStartDT: function(recordStartDT) {
        var seconds = recordStartDT.getSeconds(),
            minutes = recordStartDT.getMinutes(),
            baseMinutes = 5,
            addMinutes = 0,
            minutesMod = minutes % baseMinutes;
        if (minutesMod < baseMinutes) {
            addMinutes = (-1) * minutesMod;
        } else {
            addMinutes = (-1) * (minutesMod - baseMinutes);
        }
        return recordStartDT.addMinutes(addMinutes).addSeconds((-1) * seconds);
    },
    /**
     * 前页
     * @author chenchangqing 20170831
     */
    previousPage: function() {
        if (this.isFirstPage()) return;
        this.currentPageNo--;
        this.drawPage();
    },
    /**
     * 后页
     * @author chenchangqing 20170831
     */
    nextPage: function() {
        this.currentPageNo++;
        this.drawPage();
    },
    /**
     * 首页
     * @author chenchangqing 20170831
     */
    firstPage: function() {
        if (this.isFirstPage()) return;
        this.currentPageNo = 1;
        this.drawPage();
    },
    /**
     * 最后一页
     */
    lastPage: function() {
        this.countAllPages();
        if (this.isLastPage()) return;
        this.currentPageNo = this.totalPageCount;
        this.drawPage();
    },
    /**
     * 是否第一页
     */
    isFirstPage: function() {
        return this.currentPageNo === 1;
    },
    /**是否最后一页 */
    isLastPage: function() {
        return this.currentPageNo === this.totalPageCount;
    },
    /**
     * 计算监护记录页数，现在只根据时间线计算页数
     */
    countAllPages: function(dataMaxDT) {
        var timeLineArea = this.dataContext.displayAreas.timeLine;
        var timeLines = timeLineArea.timeLines;
        var length = timeLines.length;
        var columnCounts = 0;
        var timeline = null;
        for (var i = 0; i < length; i++) {
            timeline = timeLines[i];
            if (timeline.StartDT > dataMaxDT) continue;
            else if (timeline.EndDT > dataMaxDT) {
                var span = new TimeSpan(dataMaxDT, timeline.StartDT);
                columnCounts = columnCounts + Math.ceil(span.totalMinutes / timeline.ColumnMinutes);
            } else {
                columnCounts = columnCounts + timeline.ColumnCount;
            }
        }
        this.totalPageCount = Math.ceil(columnCounts / 48); //这里的48需要修改；
        return this.totalPageCount;
    },
    /**
     * 设置时间线
     */
    setTimeLines: function() {
        this.setRecordStartDT();
        var timeLineArea = this.dataContext.displayAreas.timeLine,
            defaultColMinutes = timeLineArea.column.subMinutes,
            totalColCount = timeLineArea.column.count * timeLineArea.column.minutes / defaultColMinutes;
        timeLineArea.timeLines = [];
        if (!this.dataContext.timeLines || this.dataContext.timeLines.length < 1) {
            timeLineArea.timeLines.push(new TimeLine({
                StartDT: timeLineArea.startDT,
                EndDT: timeLineArea.endDT,
                ColumnMinutes: timeLineArea.column.subMinutes
            }));
        } else {
            for (var i = 0; i < this.dataContext.timeLines.length; i++) {
                var timeLine = this.dataContext.timeLines[i];
                if (i === 0 && timeLine.StartDT > timeLineArea.startDT) {
                    timeLineArea.timeLines.push(timeLine.getTimeLine(timeLineArea.startDT, "Start", totalColCount, defaultColMinutes));
                }
                if (i === this.dataContext.timeLines.length - 1 && timeLine.EndDT < timeLineArea.endDT) {
                    timeLineArea.timeLines.push(timeLine.getTimeLine(timeLineArea.endDT, "End", totalColCount, defaultColMinutes));
                }
                if (i > 0) {
                    var prevTimeLine = this.dataContext.timeLines[i - 1];
                    if (prevTimeLine.EndDT < timeLine.StartDT) {
                        timeLineArea.timeLines.push(new TimeLine({
                            StartDT: prevTimeLine.EndDT,
                            EndDT: timeLine.StartDT,
                            ColumnMinutes: defaultColMinutes
                        }));
                    }
                }
                timeLineArea.timeLines.push(timeLine);
            }
        }

        timeLineArea.timeLines.sort(dhccl.compareInstance("StartDT"));
        var startColumn = 1;
        for (var i = 0; i < timeLineArea.timeLines.length; i++) {
            var timeLine = timeLineArea.timeLines[i];
            timeLine.StartColumn = startColumn;
            timeLine.EndColumn = startColumn + timeLine.ColumnCount;
            startColumn = timeLine.EndColumn;
        }
    },

    /**
     * 设置时间轴信息
     * @param {object} area 时间轴区域对象
     * @author chenchangqing 20170717
     */
    setTimeLineArea: function(area) {
        // 根据时间轴对象数组设置时间轴信息(时间轴缩放)

        var timeWidth = area.column.totalWidth,
            columnWidth = timeWidth / (area.column.timeList.length - 1);
        area.timeRect = new Rectangle({
            x: area.rect.left + area.column.dateWidth,
            y: area.rect.top
        }, {
            width: timeWidth,
            height: area.rect.height
        });
        area.dateRect = new Rectangle({
            x: area.rect.left,
            y: area.rect.top
        }, {
            width: area.column.dateWidth,
            height: area.rect.height
        });
        area.column.width = columnWidth;
        for (var i = 0; i < area.column.timeList.length; i++) {
            var columnTime = area.column.timeList[i],
                recordDT = null;
            if (area.timeLines && area.timeLines.length > 0) {
                recordDT = this.getTimeByAxis(area.timeRect.left + columnWidth * i);
            } else {
                recordDT = this.dataContext.displayAreas.timeLine.pageStartDT.addHours(i);
            }
            columnTime.recordDT = recordDT;
            columnTime.title = recordDT.format("HH:mm");
        }
    },

    /**
     * 绘制时间轴区域
     * @param {object} area 时间轴区域对象
     * @author chenchangqing 20170717
     */
    drawTimeLineArea: function(area) {
        var fontStyle = this.fonts.item.style,
            colorStyle = this.dataContext.colors.item,
            fontHeight = this.fonts.item.height,
            padding = (area.size.height - fontHeight) / 2;
        // 绘制日期
        var dateTitle = area.column.timeList[0].recordDT.format("yyyy-MM-dd"),
            titleWidth = this.drawContext.measureTextWidth(dateTitle, colorStyle, fontStyle);
        this.drawContext.drawString(dateTitle, {
            x: area.dateRect.left + (area.dateRect.width - titleWidth) / 2,
            y: area.dateRect.top + padding
        }, colorStyle, fontStyle);

        var lastTimeAdjustX = 0;
        var length = area.column.timeList.length;
        // 绘制时间
        for (var i = 0; i < length; i++) {
            var columnTime = area.column.timeList[i];
            var adjustX = 0;
            if (i === length - 1) adjustX = lastTimeAdjustX;
            titleWidth = this.drawContext.measureTextWidth(columnTime.title, colorStyle, fontStyle);
            columnTime.rect = new Rectangle({
                x: area.timeRect.left + i * area.column.width - titleWidth / 2 + adjustX,
                y: area.timeRect.top + columnTime.location.y
            }, {
                width: titleWidth,
                height: area.size.height
            });
            this.drawContext.drawString(columnTime.title, {
                x: columnTime.rect.left,
                y: columnTime.rect.top + padding
            }, colorStyle, fontStyle);
        }

        area.pageStartDT = area.column.timeList[0].recordDT;
        area.pageEndDT = area.column.timeList[length - 1].recordDT;
    },

    /**
     * 绘制显示项区域
     * @param {object} itemArea - 显示项区域
     * @author chenchangqing 20170726
     */
    drawItemArea: function(itemArea) {
        var dataArea = this.dataContext.displayAreas.data,
            itemFont = this.fonts.item,
            borderColor = this.dataContext.colors.border,
            itemColor = this.dataContext.colors.item,
            warningColor = this.dataContext.colors.warning,
            isWarningRow = false,
            chineseWidth = this.drawContext.measureChineseWidth(null, this.dataContext.colors.item, itemFont.style);
        if (itemArea.displayCategories) {
            // 绘制显示分类垂直分割线
            var startPos = {
                    x: itemArea.rect.left + itemArea.categoryWidth,
                    y: itemArea.rect.top
                },
                endPos = {
                    x: startPos.x,
                    y: itemArea.rect.bottom
                };
            this.drawContext.drawLine(startPos, endPos, borderColor);

            // 绘制各个显示分类的水平分割线(显示项区域+显示数据区域)，绘制显示分类标题
            var categoryStartPosY = itemArea.rect.top; // 显示分类Y坐标
            for (var key in itemArea.displayCategories) {
                var category = itemArea.displayCategories[key];

                // 显示分类标题区域
                category.titleRect = new Rectangle({
                    x: itemArea.rect.left,
                    y: categoryStartPosY,
                }, {
                    width: itemArea.categoryWidth,
                    height: category.rowCount * category.rowHeight
                });

                // 显示分类显示项区域
                category.itemRect = new Rectangle({
                    x: category.titleRect.right,
                    y: category.titleRect.top
                }, {
                    width: itemArea.rect.width - itemArea.categoryWidth,
                    height: category.titleRect.height
                });

                // 显示分类数据区域
                category.dataRect = new Rectangle({
                    x: dataArea.rect.left,
                    y: category.titleRect.top
                }, {
                    width: dataArea.rect.width,
                    height: category.titleRect.height
                });

                // 显示分类显示区域
                category.rect = new Rectangle({
                    x: category.itemRect.left,
                    y: category.itemRect.top,
                }, {
                    width: dataArea.rect.width + category.itemRect.width,
                    height: category.itemRect.height
                });

                // 绘制显示分类水平分割线
                startPos.x = itemArea.rect.left;
                startPos.y = category.titleRect.bottom;
                endPos.x = dataArea.rect.right;
                endPos.y = startPos.y;
                this.drawContext.drawLine(startPos, endPos, borderColor);

                // 绘制显示分类标题
                startPos.x = category.titleRect.left + (category.titleRect.width - chineseWidth) / 2;
                startPos.y = category.titleRect.top + (category.titleRect.height - itemFont.height * category.title.length) / 2
                this.drawContext.drawVerticalString(category.title, startPos, itemColor, itemFont.style, itemFont.height);

                // 绘制显示项水平分割线和显示项标题
                startPos.x = category.titleRect.right;
                if (category === itemArea.displayCategories.VitalSignCategory) {
                    startPos.x = category.dataRect.left;
                    this.drawAxias(category);
                }
                for (var i = 0; i < category.rowCount; i++) {
                    startPos.y = category.titleRect.top + i * category.rowHeight;
                    endPos.x = dataArea.rect.right;
                    endPos.y = startPos.y;
                    if (category.specialRowHeights && category.specialRowHeights.length >= i) {
                        startPos.y = category.titleRect.top;
                        for (var j = 0; j < i; j++) {
                            startPos.y = startPos.y + category.specialRowHeights[j];
                        }
                        endPos.y = startPos.y;
                    }
                    isWarningRow = (category.warningRows || []).indexOf(i) > -1;
                    if (i > 0) {
                        // 生命体征区域，偶数行绘制实现，奇数行绘制虚线
                        if (category === itemArea.displayCategories.VitalSignCategory && this.IsEvenNumber(i)) {
                            this.drawContext.drawLine(startPos, endPos, isWarningRow ? warningColor : borderColor);
                            if (i > 0 && i % 6 === 0) this.drawContext.drawLine(startPos, endPos, isWarningRow ? warningColor : borderColor, 2);
                        } else {
                            this.drawContext.drawDashLine(startPos, endPos, isWarningRow ? warningColor : borderColor);
                        }

                    }
                }
                categoryStartPosY = category.titleRect.bottom;
            }
        }
    },
    /**
     * 绘制所有显示项目
     */
    drawDisplayItems: function() {
        var itemArea = this.dataContext.displayAreas.item,
            dataArea = this.dataContext.displayAreas.data,
            itemFont = this.fonts.item,
            itemColor = this.dataContext.colors.item;
        var startPos = {
                x: itemArea.rect.left + itemArea.categoryWidth,
                y: itemArea.rect.top
            },
            endPos = {
                x: startPos.x,
                y: itemArea.rect.bottom
            };
        if (itemArea.displayCategories) {
            for (var key in itemArea.displayCategories) {
                var category = itemArea.displayCategories[key];
                var rowHeight = "";
                for (var i = 0; i < category.rowCount; i++) {
                    startPos.y = category.titleRect.top + i * category.rowHeight;
                    endPos.x = dataArea.rect.right;
                    endPos.y = startPos.y;

                    rowHeight = category.rowHeight;
                    if (category.specialRowHeights && category.specialRowHeights.length >= i) {
                        startPos.y = category.titleRect.top;
                        for (var j = 0; j < i; j++) {
                            startPos.y = startPos.y + category.specialRowHeights[j];
                        }
                        endPos.y = startPos.y;
                        rowHeight = category.specialRowHeights[i];
                    }

                    if (category.displayItems && category.displayItems.length > i) {
                        var displayItem = category.displayItems[i];
                        displayItem.itemRect = new Rectangle({
                            x: category.titleRect.right,
                            y: startPos.y
                        }, {
                            width: category.itemRect.width,
                            height: rowHeight
                        });
                        displayItem.dataRect = new Rectangle({
                            x: category.itemRect.right,
                            y: startPos.y
                        }, {
                            width: category.dataRect.width,
                            height: rowHeight
                        });
                        displayItem.rect = new Rectangle({
                            x: category.titleRect.right,
                            y: startPos.y
                        }, {
                            width: category.itemRect.width + category.dataRect.width,
                            height: rowHeight
                        });
                        var drawLocation = {
                            x: displayItem.rect.location.x + itemArea.itemRectMarginLeft,
                            y: displayItem.rect.location.y + (rowHeight - itemFont.height) / 2
                        };
                        var itemtext = displayItem.Description;
                        if (displayItem.Concentration)
                            itemtext = displayItem.Concentration + displayItem.ConcentrationUnitDesc + itemtext;
                        var attrDesc = '',
                            attrArray = [];
                        attrDesc = displayItem.BloodType;
                        if (displayItem.BloodType) attrArray.push(displayItem.BloodType);
                        if (displayItem.UnitDesc) attrArray.push(displayItem.UnitDesc)
                        attrDesc = attrArray.join(' ');
                        if (attrDesc) {
                            itemtext = itemtext + '(' + attrDesc + ')';
                        }
                        var titleWidth = this.drawContext.measureTextWidth(itemtext, itemColor, itemFont.style);
                        this.drawContext.drawString(itemtext, drawLocation, itemColor, itemFont.style);

                        this.drawDisplayData(displayItem);
                        if (displayItem.vitalSignItem && displayItem.vitalSignItem.legendItem) {
                            this.drawItemIcon({
                                    x: category.itemRect.left + itemArea.iconMarginLeft,
                                    y: drawLocation.y
                                }, displayItem.vitalSignItem.legendItem,
                                displayItem.vitalSignItem.Color);
                        }
                    }
                }
            }

            this.drawEventLegendItem();
        }
    },
    /**
     * 绘制事件图标
     */
    drawEventLegendItem: function() {
        var eventLegendItems = this.dataContext.eventLegendItems;
        var itemColor = this.dataContext.colors.item;
        var itemFont = this.fonts.item;
        var itemArea = this.dataContext.displayAreas.item;
        if (eventLegendItems && eventLegendItems.length > 0) {
            var vitalSignCategory = this.dataContext.displayCategories.VitalSignCategory;
            var startPos = { x: vitalSignCategory.itemRect.left + itemArea.itemRectMarginLeft, y: 0 };
            for (var i = 0; i < eventLegendItems.length; i++) {
                var eventLegendItem = eventLegendItems[i];
                startPos.y = vitalSignCategory.itemRect.bottom - (eventLegendItems.length - i) * vitalSignCategory.rowHeight
                var titleWidth = this.drawContext.measureTextWidth(eventLegendItem.DataItemDesc, itemColor, itemFont.style);
                var iconWidth = 20;
                this.drawContext.drawString(eventLegendItem.DataItemDesc, startPos, itemColor, itemFont.style);
                if (eventLegendItem.legendItem && eventLegendItem.LegendColor && eventLegendItem.LegendColor != "") {
                    this.drawItemIcon({
                            x: vitalSignCategory.itemRect.left + itemArea.iconMarginLeft,
                            y: startPos.y
                        }, eventLegendItem.legendItem,
                        eventLegendItem.LegendColor);
                }
                eventLegendItem.rect = new Rectangle({
                    x: startPos.x,
                    y: startPos.y
                }, {
                    width: titleWidth + itemArea.iconMarginLeft + iconWidth,
                    height: vitalSignCategory.rowHeight
                })
            }
        }
    },

    /**
     * 绘制显示项区域显示项目的图标
     * @author chenchangqing 20170911
     */
    drawItemIcon: function(startPos, legend, color) {
        if (!legend || !legend.datas || legend.datas.length < 1) return;
        var fontHeight = this.fonts.item.height;
        var basePos = {
            x: startPos.x + legend.Width / 2,
            y: startPos.y + fontHeight / 2
        };
        if (legend.Code === "SBP") {
            basePos.y = startPos.y + fontHeight;
        } else if (legend.Code === "DBP") {
            basePos.y = startPos.y;
        }
        var dataPos = {
            x: basePos.x,
            y: basePos.y
        };

        this.drawIcon(legend, basePos, color);
    },


    /**
     * 绘制显示数据区域数据图标
     * @author chenchangqing 20170911
     */
    drawDataIcon: function(startPos, legend, color) {
        if (!legend || !legend.datas || legend.datas.length < 1) return;
        var basePos = startPos;
        this.drawIcon(legend, basePos, color);
    },
    /**
     * 绘制图标
     */
    drawIcon: function(legend, basePos, color) {
        for (var i = 0; i < legend.datas.length; i++) {
            var legendData = legend.datas[i];
            var startPos = {
                    x: legendData.StartPos.x + basePos.x,
                    y: basePos.y - legendData.StartPos.y
                },
                endPos = {
                    x: legendData.EndPos.x + basePos.x,
                    y: basePos.y - legendData.EndPos.y
                };
            switch (legendData.ShapeType) {
                case "L":
                    this.drawContext.drawLine(startPos, endPos, color, legend.LineWeight);
                    break;
                case "C":
                    this.drawContext.drawCircle({
                        x: startPos.x,
                        y: startPos.y,
                        radius: legendData.Radius,
                        eAngle: legendData.RadianMultiple * Math.PI
                    }, color);
                    break;
                case "R":
                    this.drawContext.drawCircle({
                        x: startPos.x,
                        y: startPos.y,
                        radius: legendData.Radius,
                        eAngle: legendData.RadianMultiple * Math.PI
                    }, color, color);
                    break;
            }
        }
    },

    /**
     * 绘制显示数据区域
     * @param {Object} dataArea -显示数据区域
     * @author chenchangqing 20170805
     */
    drawDataArea: function(dataArea) {
        var timeLineArea = this.dataContext.displayAreas.timeLine,
            itemArea = this.dataContext.displayAreas.item,
            startPos = {
                x: timeLineArea.timeRect.left,
                y: timeLineArea.timeRect.bottom
            },
            endPos = {
                x: startPos.x,
                y: dataArea.rect.bottom
            },
            subStartPos = { x: 0, y: 0 },
            subEndPos = { x: 0, y: 0 },
            borderColor = this.dataContext.colors.border,
            subColumnCount = timeLineArea.column.minutes / timeLineArea.column.subMinutes,
            subColumnWidth = timeLineArea.column.width / subColumnCount;

        dataArea.columnTimeList = []
        var length = timeLineArea.column.timeList.length;
        for (var i = 0; i < length - 1; i++) {
            startPos.x = timeLineArea.timeRect.left + i * timeLineArea.column.width;
            endPos.x = startPos.x;
            for (var key in itemArea.displayCategories) {
                var catergory = itemArea.displayCategories[key];
                subStartPos.y = startPos.y = catergory.dataRect.top;
                subEndPos.y = endPos.y = catergory.dataRect.bottom;

                var oddLineMethod = '';
                if (catergory.oddColumnLine === 'solid') oddLineMethod = 'drawLine';
                else if (catergory.oddColumnLine === 'dashed') oddLineMethod = 'drawDashLine';
                var evenLineMethod = '';
                if (catergory.evenColumnLine === 'solid') evenLineMethod = 'drawLine';
                else if (catergory.evenColumnLine === 'dashed') evenLineMethod = 'drawDashLine';

                for (var j = 0; j < subColumnCount; j++) {
                    subStartPos.x = startPos.x + j * subColumnWidth;
                    subEndPos.x = subStartPos.x;

                    var startDT = this.getTimeByAxis(subStartPos.x);
                    dataArea.columnTimeList.push(startDT);

                    if (this.IsEvenNumber(j)) {
                        if (evenLineMethod) {
                            this.drawContext[evenLineMethod](subStartPos, subEndPos, borderColor);
                            if (((i === 0 && j > 0) || (i > 0)) && j % 6 === 0) this.drawContext[evenLineMethod](subStartPos, subEndPos, borderColor, 2);
                        }
                    } else {
                        if (oddLineMethod) this.drawContext[oddLineMethod](subStartPos, subEndPos, borderColor);
                    }
                }
            }
        }
        var startDT = this.getTimeByAxis(timeLineArea.timeRect.right);
        dataArea.columnTimeList.push(startDT);
    },
    /**
     * 是否列时间点
     */
    isColumnTime: function(time) {
        var columnTimeList = this.dataContext.displayAreas.data.columnTimeList;
        var length = columnTimeList.length;
        var found = false;
        for (var i = 0; i < length - 1; i++) {
            if (columnTimeList[i] < time && columnTimeList[i + 1] > time) {
                found = true;
                break;
            }
        }

        if (found) {
            if (new TimeSpan(time, columnTimeList[i]).totalMinutes < 2) {
                return columnTimeList[i];
            } else if (new TimeSpan(columnTimeList[i + 1], time).totalMinutes < 2) {
                return columnTimeList[i + 1];
            }
        }

        return false;
    },
    /**
     * 绘制显示项关联的显示数据
     * @param {object} displayItem - 显示项
     * @author chenchangqing 20171020
     */
    drawDisplayData: function(displayItem) {
        if (!displayItem.displayDatas || displayItem.displayDatas.length === 0) return;

        var _this = this;
        var dataFont = this.fonts.data,
            dataColor = this.dataContext.colors.data,
            startPos = { x: 0, y: displayItem.rect.top + ((displayItem.rect.height - dataFont.height) / 4) },
            endPos = { x: 0, y: startPos.y },
            centerPos = { x: 0, y: startPos.y },
            dataWidth = 0;

        if (displayItem.vitalSignItem && displayItem.vitalSignItem.legendItem) {
            drawVitalSignChartDatas();
        } else if (displayItem.Code === 'OperationEvent' || displayItem.Code === 'OperationDrug') {
            drawEventDatas();
        } else {
            drawCommonDatas();
        }

        function drawVitalSignChartDatas() {
            var drawDatas = [];
            var alpha = '66';
            var iconColor = displayItem.vitalSignItem.Color;
            foreachDisplayData(function(displayData) {
                drawDatas.push(displayData);
                dataWidth = displayItem.vitalSignItem.legendItem.Width;
                var valueYAxis = _this.getAxisByValue(displayItem, displayData.DataValue);
                displayData.rect = new Rectangle({
                    x: startPos.x - displayItem.vitalSignItem.legendItem.Width / 2,
                    y: valueYAxis - displayItem.vitalSignItem.legendItem.Height / 2
                }, {
                    width: dataWidth,
                    height: displayItem.vitalSignItem.legendItem.Height
                });
                displayData.centerPos = { x: startPos.x, y: valueYAxis };

                if (displayData.RowId) color = iconColor;
                else color = iconColor + alpha;
                _this.drawDataIcon(displayData.centerPos, displayItem.vitalSignItem.legendItem, color);
            });

            _this.drawDataLine(displayItem, drawDatas);
        }

        function drawEventDatas() {
            var dataMargin = 1;
            var dataWidth = 0;
            var layerHeight = 12;
            var layers = { 0: [], 1: [], 2: [], 3: [] };
            var rect = null,
                availableLayer = 1;
            for (var i = 0; i < displayItem.displayDatas.length; i++) {
                var displayData = displayItem.displayDatas[i];
                if (!_this.IsDataInPage(displayData)) continue;
                startPos.x = _this.getAxisByTime(displayData.StartDT);
                dataWidth = _this.drawContext.measureTextWidth(displayData.DisplayName, dataColor, dataFont.style);

                rect = { left: startPos.x - dataMargin, right: startPos.x + dataWidth + dataMargin };
                availableLayer = findAvailableLayer(layers, rect);
                if (!availableLayer) availableLayer = 0;
                layers[availableLayer].push(rect);

                startPos.y = displayItem.rect.top + availableLayer * layerHeight;
                displayData.rect = new Rectangle({
                    x: startPos.x,
                    y: startPos.y
                }, {
                    width: dataWidth,
                    height: layerHeight
                });
                displayData.centerPos = { x: startPos.x + (dataWidth / 2), y: startPos.y + layerHeight / 2 };

                //if(!displayData.isFolded)
                _this.drawContext.drawString(displayData.DisplayName, startPos, dataColor, dataFont.style);
            }
            drawEventDataIcon();
        }

        /**
         * 找到可用的层数
         * @param {*} layers 
         * @param {*} rect 
         */
        function findAvailableLayer(layers, rect) {
            for (var key in layers) {
                if (!hasOverlapRegion(layers[key], rect)) return key;
            }

            return null;
        }

        /**
         * 是否有重叠的区域
         */
        function hasOverlapRegion(regions, rect) {
            var length = regions.length;
            var overlap = false;
            for (var k = 0; k < length; k++) {
                if (rect.left < regions[k].right && regions[k].left < rect.right) {
                    overlap = true;
                    break;
                }
            }

            return overlap;
        }

        function drawEventDataIcon() {
            var length = displayItem.eventDatas.length;
            for (var i = 0; i < length; i++) {
                var displayData = displayItem.eventDatas[i];
                if (!_this.IsDataInPage(displayData)) continue;
                var categoryItem = displayData.categoryItemObj;
                var legend = null;
                if (categoryItem && categoryItem.eventItem) legend = categoryItem.eventItem.legendItem;
                if (legend) {
                    setDefaultPosition(displayData);
                    var category = _this.dataContext.displayCategories.VitalSignCategory;
                    centerPos = {
                        x: startPos.x,
                        y: category.rect.top + category.eventLegendRowIndex * category.rowHeight
                    }
                    displayData.legendRect = new Rectangle({
                        x: centerPos.x - legend.Width / 2,
                        y: centerPos.y - legend.Height / 2
                    }, {
                        width: legend.Width,
                        height: legend.Height
                    });
                    _this.drawDataIcon(centerPos, legend, categoryItem.eventItem.LegendColor);
                }
            }
        }

        function drawCommonDatas() {
            foreachDisplayData(function(displayData) {
                _this.drawCommonData(displayData);
            });
        }

        function foreachDisplayData(f) {
            for (var i = 0; i < displayItem.displayDatas.length; i++) {
                var displayData = displayItem.displayDatas[i];
                if (!_this.IsDataInPage(displayData)) continue;
                setDefaultPosition(displayData);

                if (f && typeof f === 'function') f.call(_this, displayData);
            }
        }

        function setDefaultPosition(displayData) {
            startPos.x = _this.getAxisByTime(displayData.StartDT);
            startPos.y = displayItem.rect.top + ((displayItem.rect.height - dataFont.height) / 4);
            dataWidth = _this.drawContext.measureTextWidth(displayData.DisplayName, dataColor, dataFont.style);
            displayData.rect = new Rectangle({
                x: startPos.x,
                y: displayItem.rect.top
            }, {
                width: dataWidth,
                height: displayItem.rect.height
            });
            displayData.centerPos = { x: startPos.x + (dataWidth / 2), y: startPos.y };
        }
    },
    /**
     * 绘制数据
     * @param {object} displayData
     */
    drawCommonData: function(displayData) {
        var displayName = '';
        var dataFont = this.fonts.data,
            dataSmallFont = this.fonts.dataSmall,
            color = this.dataContext.colors.data,
            dataWidth = this.drawContext.measureTextWidth(displayData.DisplayName, color, dataFont.style);
        displayData.lineStartIconRect = null;
        displayData.lineEndIconRect = null;
        var pageStartDT = this.dataContext.displayAreas.timeLine.pageStartDT;
        var pageEndDT = this.dataContext.displayAreas.timeLine.pageEndDT;
        var startDT = displayData.StartDT;
        var endDT = this.getEndDT(displayData);
        var timeSpan = new TimeSpan(endDT, pageStartDT);
        if (timeSpan.totalSeconds > -1 && timeSpan.totalSeconds < 1) return;
        if (displayData.EndDateTime != displayData.StartDateTime) {
            var axis = this.getAxis(displayData),
                rectPadding = 3;
            if (axis) {
                var startPos = {
                        x: axis.startAxis,
                        y: displayData.rect.top + rectPadding
                    },
                    endPos = {
                        x: axis.startAxis,
                        y: displayData.rect.bottom - rectPadding
                    };

                if (startDT >= pageStartDT) {
                    // 绘制起始竖线
                    this.drawContext.drawLine(startPos, endPos, color);
                    displayData.lineStartIconRect = new Rectangle(startPos, {
                        width: 10,
                        height: displayData.rect.height
                    });
                }

                displayName = displayData.DisplayName;
                if (startDT < pageStartDT) displayName = '';

                dataWidth = this.drawContext.measureTextWidth(displayName, color, dataSmallFont.style);
                var displayNameX = axis.startAxis + (axis.endAxis - axis.startAxis - dataWidth) / 2;
                // 如果横线长大于数据字符串长度，绘制两段横线
                if ((axis.endAxis - axis.startAxis) - dataWidth > 6) {
                    // 绘制横线
                    endPos.x = displayNameX - (displayName ? 1 : 0);
                    startPos.y = endPos.y = displayData.rect.top + displayData.rect.height / 2;
                    this.drawContext.drawLine(startPos, endPos, color);

                    // 绘制DisplayName
                    startPos.y = displayData.rect.top + 2;
                    startPos.x = displayNameX;
                    this.drawContext.drawString(displayName, startPos, color, dataSmallFont.style);

                    // 绘制横线
                    startPos.x = displayNameX + (displayName ? dataWidth + 1 : 0);
                    endPos.x = axis.endAxis;
                    startPos.y = endPos.y = displayData.rect.top + displayData.rect.height / 2;
                    this.drawContext.drawLine(startPos, endPos, color);
                } else {
                    // 绘制横线
                    endPos.x = axis.endAxis;
                    startPos.y = endPos.y = displayData.rect.top + displayData.rect.height / 2;
                    this.drawContext.drawLine(startPos, endPos, color);

                    // 绘制DisplayName
                    startPos.y = displayData.rect.top - 5;
                    startPos.x = displayNameX;
                    this.drawContext.drawString(displayName, startPos, color, dataSmallFont.style);
                }

                if (endDT <= pageEndDT && (!displayData.DrugData || displayData.DrugData.TakingAway != 'Y')) {
                    // 绘制">"
                    startPos.y = displayData.rect.top + rectPadding + 2;
                    startPos.x = axis.endAxis - displayData.rect.height / 2;
                    this.drawContext.drawLine(startPos, endPos, color);
                    startPos.y = displayData.rect.bottom - rectPadding - 2;
                    this.drawContext.drawLine(startPos, endPos, color);
                }

                if (displayData.EndDT <= MAXDATE) {
                    if (startDT >= pageStartDT) {
                        // 绘制"<"
                        endPos.x = axis.startAxis;
                        endPos.y = displayData.rect.top + displayData.rect.height / 2;
                        startPos.y = displayData.rect.top + rectPadding + 2;
                        startPos.x = axis.startAxis + displayData.rect.height / 2;
                        this.drawContext.drawLine(startPos, endPos, color);
                        startPos.y = displayData.rect.bottom - rectPadding - 2;
                        this.drawContext.drawLine(startPos, endPos, color);
                    }

                    if (endDT <= pageEndDT && (!displayData.DrugData || displayData.DrugData.TakingAway != 'Y')) {
                        // 绘制结束竖线
                        startPos.y = displayData.rect.top + rectPadding;
                        endPos.y = displayData.rect.bottom - rectPadding;
                        startPos.x = endPos.x = axis.endAxis;
                        this.drawContext.drawLine(startPos, endPos, color);
                        displayData.lineEndIconRect = new Rectangle({
                            x: startPos.x - 10,
                            y: startPos.y
                        }, {
                            width: 10,
                            height: displayData.rect.height
                        });
                    }
                }

                // 设置药品数据的宽度为连续用药直线的宽度
                displayData.rect.width = axis.endAxis - axis.startAxis;
                displayData.rect.location.x = displayData.rect.left = axis.startAxis;
                displayData.rect.right = axis.endAxis;
            }
        } else {
            this.drawContext.drawString(displayData.DisplayName, displayData.rect.location, color, dataFont.style);
        }
    },



    getEndDT: function(displayData) {
        var drugEndDT = displayData.EndDT,
            now = new Date();
        if (!Date.isValidDate(drugEndDT)) {
            if (now < displayData.StartDT) {
                drugEndDT = displayData.StartDT;
            } else if (now > displayData.StartDT.addHours(8)) {
                drugEndDT = displayData.StartDT.addHours(8);
            }
        } else if (drugEndDT >= MAXDATE) {
            if (now >= displayData.StartDT) drugEndDT = now;
            else drugEndDT = displayData.StartDT.addMinutes(5);
        }
        return drugEndDT;
    },

    getAxis: function(displayData) {
        var dataArea = this.dataContext.displayAreas.data,
            endDT = this.getEndDT(displayData),
            result = null;

        var startAxis = this.getAxisByTime(displayData.StartDT),
            endAxis = this.getAxisByTime(endDT),
            startInPage = !(startAxis > dataArea.rect.right || startAxis < dataArea.rect.left),
            endInPage = !(endAxis > dataArea.rect.right || endAxis < dataArea.rect.left);
        if (startInPage && endInPage) {
            result = {
                startAxis: startAxis,
                endAxis: endAxis
            };
        } else if (startInPage && !endInPage) {
            result = {
                startAxis: startAxis,
                endAxis: dataArea.rect.right
            };
        } else if (!startInPage && endInPage) {
            result = {
                startAxis: dataArea.rect.left,
                endAxis: endAxis
            };
        } else {
            if (startAxis <= dataArea.rect.left && endAxis >= dataArea.rect.right) {
                result = {
                    startAxis: dataArea.rect.left,
                    endAxis: dataArea.rect.right
                };
            }
        }
        return result;
    },

    /**
     * 判断显示数据的开始时间是否在当前页面的时间范围内
     * @param {object} displayData - 显示数据对象
     * @return {boolean} 如果在范围内，返回true，否则返回false
     * @author chenchangqing 20171102
     */
    IsDataInPage: function(displayData) {
        var result = true;
        var dataArea = this.dataContext.displayAreas.data;
        var startAxis = this.getAxisByTime(displayData.StartDT),
            endAxis = startAxis;

        // 连续用药数据的结束时间大于开始时间
        if (displayData.Continuous === 'Y') {
            var drugEndDT = this.getEndDT(displayData);
            endAxis = this.getAxisByTime(drugEndDT)
        }

        var startInPage = !(startAxis > dataArea.rect.right || startAxis < dataArea.rect.left),
            endInPage = !(endAxis > dataArea.rect.right || endAxis < dataArea.rect.left),
            inRange = (startAxis <= dataArea.rect.left && endAxis >= dataArea.rect.right);
        if (!startInPage && !endInPage && !inRange) {
            result = false;
        }
        return result;
    },

    /**
     * 绘制某个生命体征折线图的相邻两点的连接直线
     * @param {object} displayItem - 显示项对象
     * @param {array} drawDatas - 当前页面包含该生命体征的数据
     * @
     */
    drawDataLine: function(displayItem, drawDatas) {
        if (drawDatas && drawDatas.length > 1) {
            var legendItem = displayItem.vitalSignItem.legendItem;
            var legendDatas = legendItem.datas;
            for (var i = 0; i < drawDatas.length; i++) {
                if (i === drawDatas.length - 1) continue;
                var curData = drawDatas[i],
                    nextData = drawDatas[i + 1];
                var startPos = {
                    x: curData.centerPos.x,
                    y: curData.centerPos.y
                };
                var endPos = {
                    x: nextData.centerPos.x,
                    y: nextData.centerPos.y
                }
                if (endPos.x - startPos.x > 20 || endPos.x - startPos.x < -20) continue;
                if (displayItem.vitalSignItem.ConnectPoints === 'N') {
                    if (legendDatas.length > 0) {
                        startPos.x = startPos.x + legendDatas[legendDatas.length - 1].EndPos.x;
                        startPos.y = startPos.y + legendDatas[0].StartPos.y;
                        endPos.x = endPos.x + legendDatas[0].StartPos.x;
                        endPos.y = endPos.y + legendDatas[legendDatas.length - 1].EndPos.y;
                    }

                }
                this.drawContext.drawLine(startPos, endPos, displayItem.vitalSignItem.Color);

            }
        }
    },

    connectOtherItemChartData: function() {

    },

    /**
     * 绘制坐标轴
     * @param {Object} category - 显示分类
     * @author chenchangqing 20170805
     */
    drawAxias: function(category) {
        var itemArea = this.dataContext.displayAreas.item,
            dataArea = this.dataContext.displayAreas.data,
            colorStyle = this.dataContext.colors.item,
            fontStyle = this.fonts.item.style,
            fontHeight = this.fonts.item.height;
        if (category.yaxises) {
            var basePos = { x: category.itemRect.right, y: category.itemRect.bottom }; //new Point(category.rectangle.right, category.rectangle.bottom);
            for (var key in category.yaxises) {
                var yaxis = category.yaxises[key],
                    baseRowNumber = yaxis.startRow;
                basePos.y = category.itemRect.bottom - baseRowNumber * category.rowHeight;
                // 偏移量小于0，那么坐标轴显示在数据区域的右边，否则显示在数据区域的左边    
                if (yaxis.offset < 0) {
                    basePos.x = category.dataRect.right - yaxis.offset;
                } else {
                    basePos.x = category.dataRect.left - yaxis.offset;
                }
                // 遍历刻度尺，绘制坐标刻度，支持变比例尺
                for (var scaleIndex = 0; scaleIndex < yaxis.scales.length; scaleIndex++) {
                    var scale = yaxis.scales[scaleIndex];
                    scale.startPos = { x: basePos.x, y: basePos.y };
                    var rowcounts = Math.floor((scale.endValue - scale.startValue) / scale.interval);
                    scale.endPos = { x: basePos.x, y: basePos.y - rowcounts * category.rowHeight };
                    var yAxis = basePos.y - fontHeight / 2; //坐标值显示居中
                    for (var interval = scale.startValue; interval <= scale.endValue; interval += scale.interval) {
                        var valTitle = String(interval),
                            scaleWidth = this.drawContext.measureTextWidth(valTitle, colorStyle, fontStyle),
                            startPos = { x: basePos.x - scaleWidth, y: yAxis };
                        if (yaxis.offset < 0) {
                            startPos.x = basePos.x;
                        }
                        if (this.IsEvenNumber(baseRowNumber)) {
                            this.drawContext.drawString(valTitle, startPos, colorStyle, fontStyle);
                        }
                        baseRowNumber++;
                        yAxis -= category.rowHeight;
                    }
                }
            }
        }
    },

    /**
     * 绘制事件详细信息区域。
     * @param {object} eventArea - 显示区域对象
     * @author chenchangqing 20180109
     */
    drawEventArea: function(eventArea) {
        var borderColor = this.dataContext.colors.border; // 分割线颜色样式
        // 绘制垂直分割线
        var columnWidth = eventArea.rect.width / eventArea.columnCount; // 每列宽度
        var startPos = { x: eventArea.rect.left, y: eventArea.rect.top }, // 分割线起点坐标
            endPos = { x: eventArea.rect.left, y: eventArea.rect.bottom }; // 分割线终点坐标
        for (var columnIndex = 1; columnIndex < eventArea.columnCount; columnIndex++) {
            startPos.x = eventArea.rect.left + columnIndex * columnWidth;
            endPos.x = startPos.x;
            this.drawContext.drawLine(startPos, endPos, borderColor);
        }

        this.drawIntegratedDatas(eventArea);
    },
    /**
     * 加载集合数据
     */
    drawIntegratedDatas: function(eventArea) {
        var borderColor = this.dataContext.colors.border, // 分割线颜色样式
            dataColor = this.dataContext.colors.data, // 事件详细信息文字样式
            dataFont = this.fonts.dataDetail, // 事件详细信息文字字体
            dataHeaderFont = this.fonts.dataDetailHeader; // 事件详细信息序号文字字体
        var columnWidth = eventArea.rect.width / eventArea.columnCount; // 每列宽度
        var startPos = { x: eventArea.rect.left, y: eventArea.rect.top }, // 分割线起点坐标
            endPos = { x: eventArea.rect.left, y: eventArea.rect.bottom }; // 分割线终点坐标
        // 绘制数据
        var eventCategory = this.dataContext.displayCategories.Event;
        // 分类下无项目则不继续运行
        if (!(eventCategory && eventCategory.displayItems && eventCategory.displayItems.length > 0)) return;

        var eventDatas = [];
        for (var itemIndex = 0; itemIndex < eventCategory.displayItems.length; itemIndex++) {
            var displayItem = eventCategory.displayItems[itemIndex];
            if (displayItem.eventDatas && displayItem.eventDatas.length > 0) eventDatas = eventDatas.concat(displayItem.eventDatas);
        }
        eventDatas.sort(dhccl.compareInstance("StartDT"));

        if (eventDatas.length > 0) {
            var totalHeight = 0,
                eventDataIndex = 0,
                detailIndex = 0,
                linePadding = 1.5,
                lineHeight = dataFont.height + linePadding,
                paraPadding = 3,
                detailPadding = 5,
                areaHeight = eventArea.rect.height - 2 * detailPadding,
                origColumnWidth = columnWidth,
                eventData = null,
                headerWidth = 0;
            headerNoWidth = 0,
                headerTextWidth = 0;
            columnWidth -= 2 * detailPadding;
            startPos.x = eventArea.rect.left + detailPadding;
            startPos.y = eventArea.rect.top + detailPadding;
            for (eventDataIndex = 0; eventDataIndex < eventDatas.length; eventDataIndex++) {
                if (eventDataIndex > 0) {
                    totalHeight += paraPadding;
                    startPos.y += paraPadding;
                }
                eventData = eventDatas[eventDataIndex];
                eventData.detailDatas = [];
                eventData.detailRects = [];
                headerNoWidth = this.drawContext.measureTextWidth(eventData.headerNo, dataColor, dataHeaderFont.style);
                headerTextWidth = this.drawContext.measureTextWidth(eventData.headerText, dataColor, dataHeaderFont.style);
                headerWidth = headerNoWidth + headerTextWidth;
                eventData.detailArray = this.getEventDetailArray(eventData.DetailNameList, columnWidth - headerWidth, dataFont, dataColor);
                if (eventData.detailArray && eventData.detailArray.length > 0) {
                    for (detailIndex = 0; detailIndex < eventData.detailArray.length; detailIndex++) {
                        totalHeight += lineHeight;
                        if (totalHeight >= areaHeight) {
                            startPos.x += origColumnWidth;
                            totalHeight = lineHeight;
                            startPos.y = eventArea.rect.top + detailPadding;
                        }
                        if (detailIndex === 0) {
                            eventData.detailDatas.push({
                                description: eventData.headerNo,
                                rect: new Rectangle({ x: startPos.x, y: startPos.y }, { width: headerNoWidth, height: lineHeight })
                            });
                            eventData.detailRects.push(new Rectangle({ x: startPos.x, y: startPos.y }, { width: headerNoWidth, height: lineHeight }));
                            eventData.detailDatas.push({
                                description: eventData.headerText,
                                rect: new Rectangle({ x: startPos.x + headerNoWidth, y: startPos.y }, { width: headerTextWidth, height: lineHeight })
                            });
                            eventData.detailRects.push(new Rectangle({ x: startPos.x + headerNoWidth, y: startPos.y }, { width: headerTextWidth, height: lineHeight }));
                        }
                        eventData.detailDatas.push({
                            description: eventData.detailArray[detailIndex],
                            rect: new Rectangle({ x: startPos.x + headerWidth, y: startPos.y }, { width: columnWidth - headerWidth, height: lineHeight })
                        });
                        eventData.detailRects.push(new Rectangle({ x: startPos.x + headerWidth, y: startPos.y }, { width: columnWidth - headerWidth, height: lineHeight }));
                        // eventData.detailRects.push(new Rectangle(startPos, { width: columnWidth, height: dataFont.height }));
                        // this.drawContext.drawString(eventData.detailArray[detailIndex], startPos, dataColor, dataFont.style);
                        startPos.y += lineHeight;
                    }
                }
            }

            var startPosX = eventArea.rect.left;
            for (eventDataIndex = 0; eventDataIndex < eventDatas.length; eventDataIndex++) {
                eventData = eventDatas[eventDataIndex];
                if (!eventData.detailDatas || eventData.detailDatas.length <= 0) continue;
                for (detailIndex = 0; detailIndex < eventData.detailDatas.length; detailIndex++) {
                    var detailData = eventData.detailDatas[detailIndex];
                    startPosX = detailData.rect.left - (this.currentPageNo - 1) * eventArea.rect.width;
                    if (startPosX < eventArea.rect.left || startPosX > eventArea.rect.right) continue;
                    if (detailIndex == 0) {
                        this.drawContext.drawString(detailData.description, { x: startPosX, y: detailData.rect.top }, dataColor, dataHeaderFont.style);
                    } else {
                        this.drawContext.drawString(detailData.description, { x: startPosX, y: detailData.rect.top }, dataColor, dataFont.style);
                    }
                }
            }
        }
    },
    getEventDatas: function() {
        var eventDatas = [];
        var eventCategory = this.dataContext.displayCategories.Event;
        if (eventCategory && eventCategory.displayItems && eventCategory.displayItems.length > 0) {
            for (var itemIndex = 0; itemIndex < eventCategory.displayItems.length; itemIndex++) {
                var displayItem = eventCategory.displayItems[itemIndex];
                if (displayItem.eventDatas && displayItem.eventDatas.length > 0) {
                    eventDatas = eventDatas.concat(displayItem.eventDatas);
                }
            }
        }
        return eventDatas;
    },
    getEventDetailArray: function(eventDetail, maxWidth, dataFont, dataColor) {
        var result = [],
            detailBuilder = "",
            tempBuilder = "",
            context = this.drawContext;

        if (typeof eventDetail === 'object') {
            var length = eventDetail.length;
            for (var detailIndex = 0; detailIndex < length; detailIndex++) {
                autoWrap(eventDetail[detailIndex]);
            }
        } else if (typeof eventDetail === 'string') {
            autoWrap(eventDetail);
        }

        return result;

        function autoWrap(str) {
            tempBuilder = '';
            detailBuilder = '';
            for (var i = 0; i < str.length; i++) {
                tempBuilder += str.charAt(i);
                detailWidth = context.measureTextWidth(tempBuilder, dataColor, dataFont.style);
                if (detailWidth <= maxWidth) {
                    detailBuilder += str.charAt(i);
                }
                if (detailWidth > maxWidth) {
                    result.push(detailBuilder);
                    detailBuilder = "";
                    tempBuilder = "";
                    i--;
                } else if (i === str.length - 1) {
                    result.push(detailBuilder);
                }
            }
        }
    },

    /**
     * 鼠标移动时，捕获经过的显示区域、显示分类、显示项、显示数据、时间等数据
     * @param {Object} moveLoc - 鼠标移动点的坐标
     * @author chenchangqing 20170805 
     */
    captureMove: function(moveLoc) {
        var canvasLoc = this.canvas.windowToCanvas(moveLoc);
        this.setCaptureInfo(this.moveInfo, canvasLoc);
    },

    /**
     * 鼠标点击时，捕获经过的显示区域、显示分类、显示项、显示数据、时间等数据
     * @param {Object} moveLoc - 鼠标移动点的坐标
     * @author chenchangqing 20170805 
     */
    captureClick: function(clickLoc) {
        var canvasLoc = this.canvas.windowToCanvas(clickLoc);
        this.setCaptureInfo(this.clickInfo, canvasLoc);
        var displayData = this.clickInfo.displayData;
        this.clickInfo.isSelectedStartIcon = false;
        this.clickInfo.isSelectedEndIcon = false;
        if (displayData && displayData.lineStartIconRect &&
            displayData.lineStartIconRect.contains(canvasLoc.x, canvasLoc.y)) {
            this.clickInfo.isSelectedStartIcon = true;
        } else if (displayData && displayData.lineEndIconRect &&
            displayData.lineEndIconRect.contains(canvasLoc.x, canvasLoc.y)) {
            this.clickInfo.isSelectedEndIcon = true;
        }
        this.clickInfo.button = clickLoc.button;
        this.originalClickInfo.area = this.clickInfo.area;
        this.originalClickInfo.category = this.clickInfo.category;
        this.originalClickInfo.item = this.clickInfo.item;
        this.originalClickInfo.displayData = this.clickInfo.displayData;
        this.originalClickInfo.locDT = this.clickInfo.locDT;
        this.originalClickInfo.dataItem = this.clickInfo.dataItem;
        this.originalClickInfo.button = this.clickInfo.button;
        this.setChartInfo();
        if (this.chartInfo.item) $(this.canvas).addClass('drawing');
        else $(this.canvas).removeClass('drawing');
    },

    setChartInfo: function() {
        //this.clearChartInfo();
        var itemArea = this.dataContext.displayAreas.item,
            dataArea = this.dataContext.displayAreas.data,
            timeLineArea = this.dataContext.displayAreas.timeLine,
            vitalSignCategory = this.dataContext.displayCategories.VitalSignCategory;
        if ((this.clickInfo.area !== itemArea && this.clickInfo.area !== dataArea) ||
            this.clickInfo.category != vitalSignCategory) {
            this.clearChartInfo();
        }
        if ((this.clickInfo.area === itemArea || this.clickInfo.area === dataArea) &&
            this.clickInfo.category === vitalSignCategory) {
            if (this.clickInfo.item || this.clickInfo.area === itemArea) {
                this.chartInfo.item = this.clickInfo.item;
                this.chartInfo.categoryItem = this.clickInfo.categoryItem;
            }
            this.chartInfo.lineDT = null;
        }
        if (this.clickInfo.area === dataArea && this.clickInfo.category === vitalSignCategory) {
            var subColumnCount = timeLineArea.column.count * timeLineArea.column.minutes / timeLineArea.column.subMinutes;
            var subColumnWidth = dataArea.rect.width / subColumnCount;
            var startPosX = this.clickInfo.area.rect.left;
            for (var i = 0; i < subColumnCount; i++) {
                startPosX = this.clickInfo.area.rect.left + i * subColumnWidth;
                var endPosX = startPosX + subColumnWidth;
                var startDT = this.getTimeByAxis(startPosX);
                var endDT = this.getTimeByAxis(endPosX);
                if (this.clickInfo.locDT > endDT || this.clickInfo.locDT < startDT) continue;
                var startTimeSpan = new TimeSpan(this.clickInfo.locDT, startDT);
                var endTimeSpan = new TimeSpan(endDT, this.clickInfo.locDT);
                if (startTimeSpan.totalMilliSeconds <= endTimeSpan.totalMilliSeconds) {
                    this.chartInfo.lineDT = startDT;
                } else {
                    this.chartInfo.lineDT = endDT;
                }
            }
        }

        if (this.clickInfo.area === dataArea &&
            this.chartInfo.lineDT) {
            this.chartInfo.startLineDT = this.chartInfo.lineDT;
            //console.log(this.chartInfo.startLineDT);
        }
    },

    getLineData: function() {
        var itemArea = this.dataContext.displayAreas.item,
            dataArea = this.dataContext.displayAreas.data,
            timeLineArea = this.dataContext.displayAreas.timeLine,
            vitalSignCategory = this.dataContext.displayCategories.VitalSignCategory,
            result = null;
        if (this.clickInfo.area === dataArea && this.clickInfo.category === vitalSignCategory && this.chartInfo.item) {
            var displayDatas = this.chartInfo.item.displayDatas;
            if (displayDatas && displayDatas.length > 0) {
                for (var i = 0; i < displayDatas.length; i++) {
                    var displayData = displayDatas[i];
                    if (displayData.StartDT.getTime() == this.chartInfo.lineDT.getTime()) {
                        result = displayData;
                    }
                }
            }
        }
        return result;
    },

    clearChartInfo: function() {
        this.chartInfo.item = null;
        this.chartInfo.categoryItem = null;
        this.chartInfo.lineDT = null;
        this.chartInfo.startLineDT = null;
    },

    /**
     * 清空鼠标点击或移动时捕捉的信息
     * @param {object} captureInstance - 捕捉对象
     * @author chenchangqing 20171102
     */
    clearCaptureInfo: function(captureInstance) {
        captureInstance.location = null;
        captureInstance.area = null;
        captureInstance.category = null;
        captureInstance.dataItem = null;
        captureInstance.item = null;
        captureInstance.displayData = null;
        captureInstance.locDT = null;
        captureInstance.value = null;
        captureInstance.eventLegendItem = null;
        captureInstance.categoryItem = null;
    },

    /**
     * 清空鼠标点击捕捉对象
     * @author chenchangqing 20171102
     */
    clearClickInfo: function() {
        this.clearCaptureInfo(this.clickInfo);
    },

    /**
     * 清空所有捕捉对象
     * @author chenchangqing 20171102
     */
    clearAllCaptureInfo: function() {
        this.clearCaptureInfo(this.clickInfo);
        this.clearCaptureInfo(this.moveInfo);
    },

    /**
     * 设置鼠标移动或点击时捕获的显示对象信息
     * @param {object} captureInstance - 需要设置的对象
     * @param {object} canvasLoc - 捕获点的坐标(已转成相对canvas的坐标)
     * @author chenchangqing 20170805
     */
    setCaptureInfo: function(captureInstance, canvasLoc) {
        this.clearCaptureInfo(captureInstance);
        captureInstance.location = canvasLoc;
        var context = this.dataContext;
        var displayAreas = context.displayAreas,
            dataArea = displayAreas.data,
            timeLineArea = displayAreas.timeLine;
        var itemArea = context.displayAreas.item;
        var patInfoArea = context.displayAreas.patInfo;
        var operInfoArea = context.displayAreas.operInfo;

        if (!setArea()) return;
        if (captureInstance === this.clickInfo) {
            setCategory();
            setDataItem();
            setEventLegendItem(context.eventLegendItems);
        }

        captureInstance.value = this.getValueByAxis(canvasLoc.y);

        if (captureInstance.area) {
            if (captureInstance.area === dataArea || captureInstance.area === timeLineArea) {
                captureInstance.locDT = this.getTimeByAxis(canvasLoc.x);
            }
        }

        function setArea() {
            if (displayAreas) {
                for (var key in displayAreas) {
                    var displayArea = displayAreas[key];
                    if (displayArea.rect.contains(canvasLoc.x, canvasLoc.y)) {
                        captureInstance.area = displayArea;
                        return true;
                    }
                }
            }
            return false;
        }

        function setCategory() {
            var area = displayAreas.item;
            if (area && area.displayCategories) {
                for (var key in area.displayCategories) {
                    var category = area.displayCategories[key];
                    if (category.rect.contains(canvasLoc.x, canvasLoc.y)) {
                        captureInstance.category = category;
                        if (!setItem(category)) retrieveEventParaItem();
                        return true;
                    }
                }
            }

            if (retrieveEventParaItem() || retrieveIntriDrugParaItem()) {
                captureInstance.category = area.displayCategories.Event;
            }

            return false;
        }

        function setItem(category) {
            if (!(category && category.displayItems)) return false;
            var displayItems = category.displayItems;
            var length = displayItems.length;

            for (var itemIndex = 0; itemIndex < length; itemIndex++) {
                var displayItem = displayItems[itemIndex];
                if (captureInstance.area == dataArea && displayItem.vitalSignItem && displayItem.vitalSignItem.legendItem) {
                    if (setData(displayItem)) {
                        captureInstance.item = displayItem;
                        captureInstance.categoryItem = displayItem.categoryItemObj;
                        return true;
                    };
                } else if (displayItem.rect && displayItem.rect.contains(canvasLoc.x, canvasLoc.y)) {
                    captureInstance.item = displayItem;
                    captureInstance.categoryItem = displayItem.categoryItemObj;
                    setData(displayItem);
                    return true;
                }
            }
            return false;
        }

        function setEventLegendItem(eventLegendItems) {
            if (eventLegendItems && eventLegendItems.length > 0) {
                var length = eventLegendItems.length;
                for (var i = 0; i < length; i++) {
                    var eventLegendItem = eventLegendItems[i];
                    if (eventLegendItem.rect && eventLegendItem.rect.contains(canvasLoc.x, canvasLoc.y)) {
                        captureInstance.eventLegendItem = eventLegendItem;
                        captureInstance.item = context.getEventParaItem();
                        captureInstance.categoryItem = context.getCategoryItem(eventLegendItem.DataItemCode);
                        break;
                    }
                }
            }
        }

        function retrieveEventParaItem() {
            if (!captureInstance.item) {
                var item = context.getEventParaItem();
                if (setData(item)) {
                    captureInstance.item = item;
                    captureInstance.categoryItem = captureInstance.displayData.categoryItemObj;
                    return true;
                }
            }
        }

        function retrieveIntriDrugParaItem() {
            if (!captureInstance.item) {
                var item = context.getIntriDrugParaItem();
                if (setData(item)) {
                    captureInstance.item = item;
                    captureInstance.categoryItem = captureInstance.displayData.categoryItemObj;
                    return true;
                }
            }
        }

        function setData(displayItem) {
            if (!displayItem) return false;
            var displayDatas = displayItem.displayDatas;
            if (!displayDatas) return false;

            var length = displayDatas.length;
            for (var dataIndex = 0; dataIndex < length; dataIndex++) {
                var displayData = displayDatas[dataIndex];
                if (!displayData) continue;
                if ((
                        displayData.rect &&
                        displayData.rect.contains(canvasLoc.x, canvasLoc.y)
                    ) ||
                    (
                        displayData.legendRect &&
                        displayData.legendRect.contains(canvasLoc.x, canvasLoc.y)
                    ) ||
                    isInDetailRects(displayData)
                ) {
                    captureInstance.displayData = displayData;
                    return true;
                }
            }

            return false;
        }

        function isInDetailRects(displayData) {
            if (displayData.detailRects && displayData.detailRects.length > 0) {
                var rectLength = displayData.detailRects.length;
                for (var rectIndex = 0; rectIndex < rectLength; rectIndex++) {
                    var rect = displayData.detailRects[rectIndex];
                    if (rect && rect.contains(canvasLoc.x, canvasLoc.y)) return true;
                }
            }
            return false;
        }

        // 手术安排信息项目，是否需要改名称为AreaItem，DataItem有歧义
        function setDataItem() {
            var area = captureInstance.area;
            getDataItemFromArea(area);
        }

        function getDataItemFromArea(area) {
            if (!(area && area.dataItems)) return;
            var dataItems = area.dataItems;
            var rowlength = dataItems.length;
            for (var i = 0; i < rowlength; i++) {
                var length = dataItems[i].length;
                for (var j = 0; j < length; j++) {
                    var dataItem = dataItems[i][j];
                    if (dataItem.rect && dataItem.rect.contains(canvasLoc.x, canvasLoc.y)) {
                        captureInstance.dataItem = dataItem;
                        return true;
                    }
                }
            }

            return false;
        }
    },


    /**
     * 根据X坐标获取对应的时间
     * @param {Number} axis - X坐标值
     * @returns {DateTime} 对应坐标点的时间
     * @author chenchangqing 20170717
     */
    getTimeByAxis: function(axis) {
        var dataArea = this.dataContext.displayAreas.data,
            timeLineArea = this.dataContext.displayAreas.timeLine,
            chartColumnWidth = (dataArea.size.width) / (timeLineArea.column.count * timeLineArea.column.minutes / timeLineArea.column.subMinutes),
            result = null,
            baseAxis = axis + (this.currentPageNo - 1) * dataArea.rect.width;
        for (var i = 0; i < timeLineArea.timeLines.length; i++) {
            var timeLine = timeLineArea.timeLines[i],
                startPosX = dataArea.rect.left + (timeLine.StartColumn - 1) * chartColumnWidth,
                endPosX = dataArea.rect.left + timeLine.EndColumn * chartColumnWidth;
            if (baseAxis - startPosX < 0 || baseAxis - endPosX > 0) continue;
            var totalSecs = (timeLine.EndColumn - timeLine.StartColumn + 1) * timeLine.ColumnMinutes * 60,
                secsPerPiex = totalSecs / (endPosX - startPosX),
                axisSecs = (baseAxis - startPosX) * secsPerPiex;
            result = timeLine.StartDT.addSeconds(axisSecs);
        }
        return result;
    },

    /**
     * 根据时间获取X坐标
     * @param {Date} recordDT - 记录日期时间
     * @returns {Number} 对应时间的X坐标
     * @author chenchangqing 20171024
     */
    getAxisByTime: function(recordDT) {
        if (!(recordDT instanceof Date)) {
            recordDT = dhccl.toDateTime(recordDT);
        }
        if (!(recordDT instanceof Date)) return null;
        var dataArea = this.dataContext.displayAreas.data,
            timeLineArea = this.dataContext.displayAreas.timeLine,
            chartColumnWidth = (dataArea.size.width) / (timeLineArea.column.count * timeLineArea.column.minutes / timeLineArea.column.subMinutes),
            result = -1;
        var latestDT;
        var coordination = chartColumnWidth / 6 / 48 / 600;
        //baseAxis = axis + (this.currentPageNo - 1) * dataArea.rect.width;
        for (var i = 0; i < timeLineArea.timeLines.length; i++) {
            var timeLine = timeLineArea.timeLines[i],
                startPosX = dataArea.rect.left + (timeLine.StartColumn - 1) * chartColumnWidth,
                endPosX = dataArea.rect.left + timeLine.EndColumn * chartColumnWidth;
            if (!latestDT || latestDT < timeLine.EndDT) latestDT = timeLine.EndDT;
            if (recordDT > timeLine.EndDT || recordDT < timeLine.StartDT) continue;
            var totalSecs = new TimeSpan(timeLine.EndDT, timeLine.StartDT).totalSeconds,
                recordSecs = new TimeSpan(recordDT, timeLine.StartDT).totalSeconds
            recordDistance = (endPosX - startPosX) * (recordSecs / totalSecs) - coordination * recordSecs;
            result = (startPosX + recordDistance - (this.currentPageNo - 1) * dataArea.rect.width);
        }

        if (recordDT > latestDT) result = 9999999;
        return result;
    },

    /**
     * 根据折线图的纵坐标获取对应的坐标值
     * @param {number} axis - 折线图纵坐标
     * @returns {number} - 坐标对应的值
     */
    getValueByAxis: function(axis) {
        if (this.moveInfo.area !== this.dataContext.displayAreas.data) return;
        if (this.clickInfo.category !== this.dataContext.displayAreas.item.displayCategories.VitalSignCategory) return;
        if (!this.clickInfo.category.yaxises) return;
        if (!this.chartInfo.item && !this.clickInfo.item) return;
        var item = this.chartInfo.item || this.clickInfo.item;
        var curYAxis = this.clickInfo.category.yaxises.common,
            compareCode = item.Code,
            axisValue = null;
        for (var key in this.clickInfo.category.yaxises) {
            var yaxis = this.clickInfo.category.yaxises[key];
            if (yaxis.displayItemCode && yaxis.displayItemCode.indexOf(compareCode) >= 0) {
                curYAxis = yaxis;
            }
        }
        for (var i = 0; i < curYAxis.scales.length; i++) {
            var scale = curYAxis.scales[i];
            if (scale.startPos.y < axis || scale.endPos.y > axis) continue;
            var totalValue = scale.endValue - scale.startValue,
                totalLength = scale.startPos.y - scale.endPos.y,
                axisLength = scale.startPos.y - axis,
                axisValue = (scale.startValue + ((axisLength / totalLength) * totalValue)).toFixed(curYAxis.precision || 0);
        }

        return axisValue;
    },

    /**
     * 根据坐标对应的值获取折线图纵坐标
     * @param {object} displayItem - 显示项目
     * @param {string} dataValue - 生命体征值
     * @returns {number} 生命体征值对应的纵坐标
     * @author chenchangqing 20171102
     */
    getAxisByValue: function(displayItem, dataValue) {
        var curYAxis = this.dataContext.displayCategories.VitalSignCategory.yaxises.common,
            compareCode = displayItem.Code,
            axis = null,
            dataValue = Number(dataValue);
        for (var key in this.dataContext.displayCategories.VitalSignCategory.yaxises) {
            var yaxis = this.dataContext.displayCategories.VitalSignCategory.yaxises[key];
            if (yaxis.displayItemCode && yaxis.displayItemCode.indexOf(compareCode) >= 0) {
                curYAxis = yaxis;
            }
        }
        for (var i = 0; i < curYAxis.scales.length; i++) {
            var scale = curYAxis.scales[i];
            //if (scale.endValue < dataValue || scale.startValue > dataValue) continue;
            var totalValue = scale.endValue - scale.startValue,
                totalLength = scale.startPos.y - scale.endPos.y,
                axisValue = dataValue - scale.startValue,
                axis = (scale.startPos.y - ((axisValue / totalValue) * totalLength));
        }

        return axis;
    },

    /**
     * 根据显示区域的key获取显示区域对象
     * @param {String} areaKey - 显示区域key值
     * @returns {Object} 显示区域对象
     * @author chenchangqing 20170804
     */
    getDisplayArea: function(areaKey) {
        var result = null;
        if (this.dataContext.displayAreas) {
            for (var key in this.dataContext.displayAreas) {
                var displayArea = this.dataContext.displayAreas[key];
                if (key === areaKey) {
                    result = displayArea;
                    break;
                }
            }
        }
        return result;
    },

    /**
     * 获取显示区域行的高度
     * @param {Object} areaRow - 显示区域项
     * @returns {Float} 显示区域行的高度
     * @author chenchangqing 20170804
     */
    getAreaRowHeight: function(areaRow) {
        var height = 0;
        if (areaRow && areaRow.length > 0) {
            for (var i = 0; i < areaRow.length; i++) {
                var areaRowItem = areaRow[i];
                var area = this.getDisplayArea(areaRowItem.code);
                if (areaRowItem.subAreas && areaRowItem.subAreas.length > 0) {
                    var subTotalHeight = this.getAreaRowHeight(areaRowItem.subAreas);
                    height = height < subTotalHeight ? subTotalHeight : height;
                } else if (area != null) {
                    height = height < area.size.height ? area.size.height : height;
                }
            }
        }
        return height;
    },

    /**
     * 获取显示内容的高度
     * @returns {Float} 显示内容的高度
     * @author chenchangqing 20170804
     */
    getContentHeight: function() {
        var height = 0;
        if (this.dataContext.content && this.dataContext.content.arealayout) {
            for (var i = 0; i < this.dataContext.content.arealayout.length; i++) {
                var areaRow = this.dataContext.content.arealayout[i];
                var areaRowHeight = this.getAreaRowHeight(areaRow);
                height += areaRowHeight;
            }
        }
        return height;
    },

    /**
     * 判断数字是否为偶数
     * @param {Number} number - 需要判断的数字，必须为整数
     * @returns {Boolean} 如果为偶数返回true，奇数返回false
     * @author chenchangqing 20170805
     */
    IsEvenNumber: function(number) {
        return (number % 2 === 0 ? true : false);
    }
}

/**
 * 字体构造函数
 * @param {Object} options - 字体构造选项
 * @author chenchangqing 20170711
 */
function Font(options) {
    this.family = options.family;
    this.size = options.size;
    this.weight = options.weight;
    this.style = this.weight + " " + this.size + " " + this.family;
    this.height = Number(this.size.replace("px", ""));
}

/**
 * 点构造函数
 * @param {Number} x - 点的X坐标
 * @param {Number} y - 点的Y坐标
 * @author chenchangqing 20170711
 */
function Point(x, y) {
    this.x = x;
    this.y = y;
}

/**
 * 矩形构造函数
 * @param {object} location - 矩形的起始点坐标
 * @param {object} size - 矩形的大小
 * @author chenchangqing 20170711
 */
function Rectangle(location, size) {
    this.location = location;
    this.left = this.location.x;
    this.top = this.location.y;
    this.width = size.width;
    this.height = size.height;
    this.right = this.left + this.width;
    this.bottom = this.top + this.height;
    this.centre = { x: (this.left + this.right) / 2, y: (this.top + this.bottom) / 2 };
    this.border = {
        top: {
            start: location,
            end: {
                x: location.x + this.width,
                y: location.y
            }
        },
        bottom: {
            start: {
                x: location.x,
                y: location.y + this.height
            },
            end: {
                x: location.x + this.width,
                y: location.y + this.height
            }
        },
        left: {
            start: location,
            end: {
                x: location.x,
                y: location.y + this.height
            }
        },
        right: {
            start: {
                x: location.x + this.width,
                y: location.y
            },
            end: {
                x: location.x + this.width,
                y: location.y + this.height
            }
        }
    }
}

/**
 * 矩形的原型对象
 * @author chenchangqing 20170711
 */
Rectangle.prototype = {
    constructor: Rectangle,
    /**
     * 判断矩形是否包含坐标为(x,y)的点
     * @param {Number} - 点的X坐标
     * @param {Number} - 点的Y坐标
     * @returns {Boolean} 如果点包含在矩形内返回true，否则返回false
     * @author chenchangqing 20170711
     */
    contains: function(x, y) {
        if (x - this.left < 0 || x - this.right > 0) {
            return false;
        }
        if (y - this.top < 0 || y - this.bottom > 0) {
            return false;
        }
        return true;
    }
}