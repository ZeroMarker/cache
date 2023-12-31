function DisplaySheet(options) {
    this.itemMenus = null;
    this.canvas = options.canvas;
    this.drawContext = this.canvas.getContext("2d");
    this.canvasContext = this.drawContext;
    this.sheet = options.sheet;
    this.valueObject = options.valueObject;
    this.tableValuesArray = options.tableValuesArray;
    this.onItemSelected = options.onItemSelected;
    this.isCtrlDown = false;
    this.multSelectedAreaItems = [];
    this.lastClickArea = null;
    this.editMode = options.editMode;
    this.onPageResize = options.onPageResize;
    this.onPageLoaded = options.onPageLoaded;
    this.editPluginAreaInfo = [];
    this.ratio = options.ratio ? options.ratio : {
        x: 1,
        y: 1,
        fontRatio: 1
    };
    this.operationRecord = [];
    this.barCodeImg = document.createElement('img');
    this.initSheet();
    this.initAction();
    //if(this.onPageLoaded) this.onPageLoaded();
}

DisplaySheet.prototype = {
    constructor: DisplaySheet,

    initSheet: function () {
        this.setPageSize();
        this.setCurrentPage(this.sheet.Pages[0].PageNo);
    },

    setPageSize: function () {
        this.canvas.width = this.sheet.Size.width * this.ratio.x;
        this.canvas.height = this.sheet.Size.height * this.ratio.y;
        if (this.onPageResize) {
            this.onPageResize();
        }
    },

    getSheetData: function () {
        var $this = this;
        var sheetData = {
            Sheet: $this.sheet
        };
        return sheetData;
    },

    resetSheetData: function (options) {
        this.sheet = options.sheet;
        this.valueObject = options.valueObject;
        this.tableValuesArray = options.tableValuesArray;
        this.initSheet();
        this.initAction();
    },

    setCurrentPageNo: function (pageNo) {
        this.currentPageNo = pageNo;
    },

    getCurrentPageNo: function () {
        return this.currentPageNo;
    },

    setCurrentPage: function (pageNo) {
        this.setCurrentPageNo(pageNo);
        this.currentPage = this.getCurrentPage();

        this.operationRecord = [];
        this.multSelectedAreaItems = [];
        this.operationRecord.push({
            type: "onMouseUp",
            location: '',
            content: "鼠标松开",
            page: JSON.stringify(this.currentPage)
        });

        this.drawPage();
    },

    deletePageByNo: function (pageNo) {
        var index = -1;
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            if (pageNo == this.sheet.Pages[i].PageNo) {
                index = i;
            }
        }

        if (index > -1) {
            this.sheet.Pages.splice(index, 1);
            this.currentPage = null;
        }
    },

    ifHasPageNo: function (pageNo) {
        var result = false;
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            if (pageNo == this.sheet.Pages[i].PageNo) {
                result = true;
            }
        }
        return result;
    },

    getPageNoArray: function () {
        var resultArray = [];
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            resultArray.push(this.sheet.Pages[i].PageNo);
        }
        return resultArray;
    },

    getCurrentPage: function () {
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            if (this.sheet.Pages[i].PageNo == this.currentPageNo) {
                return this.sheet.Pages[i];
            }
        }
    },

    getPageCount: function () {
        return this.sheet.Pages.length;
    },

    isFirstPage: function () {
        return (this.currentPageNo === this.sheet.Pages[0].PageNo);
    },

    isLastPage: function () {
        return (this.currentPageNo == this.sheet.Pages[this.sheet.Pages.length - 1].PageNo);
    },

    getNextPageNo: function () {
        var nextPageNo = "";
        var index = this.getPageIndex();
        if (index + 1 < this.sheet.Pages.length) {
            var nextPage = this.sheet.Pages[index + 1];
            nextPageNo = nextPage.PageNo;
        }
        return nextPageNo;
    },

    getPageIndex: function () {
        var index = 0;
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            if (this.sheet.Pages[i].PageNo == this.currentPageNo) {
                index = i;
            }
        }
        return index;
    },

    getPrePageNo: function () {
        var prePageNo = "";
        var index = 0;
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            if (this.sheet.Pages[i].PageNo == this.currentPageNo) {
                index = i;
            }
        }
        if (index - 1 >= 0) {
            var prePage = this.sheet.Pages[index - 1];
            prePageNo = prePage.PageNo;
        }
        return prePageNo;
    },

    getStyles: function () {
        return this.sheet.Styles;
    },

    setStyles: function (styles) {
        this.sheet.Styles = styles;
    },

    getStyleByCode: function (styleCode) {
        var resultStyle = "";
        for (var i = 0; i < this.sheet.Styles.length; i++) {
            var style = this.sheet.Styles[i];
            if (style.StyleCode == styleCode) {
                resultStyle = style;
                break;
            }
        }
        return resultStyle;
    },

    getPageSetting: function () {
        var $this = this;
        return {
            Code: $this.sheet.Code,
            Desc: $this.sheet.Desc,
            Size: $this.sheet.Size,
            PageName: $this.sheet.PageName,
            PageDirection: $this.sheet.PageDirection,
            PageSize: $this.sheet.PageSize,
            PrintCheckRequired: $this.sheet.PrintCheckRequired,
            ArchiveCheckRequired: $this.sheet.ArchiveCheckRequired,
            ScriptPath: $this.sheet.ScriptPath,
            PrintDuplex: $this.sheet.PrintDuplex,
            OnLoadedMethod: $this.sheet.OnLoadedMethod,
            OnSavedMethod: $this.sheet.OnSavedMethod
        }
    },

    setPageSetting: function (pageSetting) {
        this.sheet.Code = pageSetting.Code;
        this.sheet.Desc = pageSetting.Desc;
        this.sheet.Size = pageSetting.Size;
        this.sheet.PageName = pageSetting.PageName;
        this.sheet.PageDirection = pageSetting.PageDirection;
        this.sheet.PageSize = pageSetting.PageSize;
        this.sheet.PrintCheckRequired = pageSetting.PrintCheckRequired;
        this.sheet.ArchiveCheckRequired = pageSetting.ArchiveCheckRequired;
        this.sheet.ScriptPath = pageSetting.ScriptPath;
        this.sheet.PrintDuplex = pageSetting.PrintDuplex;
        this.sheet.OnLoadedMethod = pageSetting.OnLoadedMethod;
        this.sheet.OnSavedMethod = pageSetting.OnSavedMethod;
    },

    /**
     * 绘制界面
     */
    drawPage: function () {
        this.resizeBlock = {
            width: 8,
            height: 8
        };
        this.currentPage = this.getCurrentPage();
        //this.drawContext.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.drawContext.clearRect(0, 0, $(this.canvas).width(), $(this.canvas).height());
        this.drawImages();
        this.drawTitles();
        this.drawAreas();
        this.drawTables();
        this.drawSplitLines();
        this.drawComplexTables();
    },

    drawEditPlugins: function () {
        for (var i = 0; i < this.currentPage.Areas.length; i++) {
            this.drawArea(this.currentPage.Areas[i]);
        }
    },

    drawImages: function () {
        if (this.currentPage.Images) {
            for (var i = 0; i < this.currentPage.Images.length; i++) {
                this.drawImage(this.currentPage.Images[i]);
            }
        }
    },

    drawImage: function (image) {
        var $this = this;
        var rect = {
            left: image.DisplayRect.left * this.ratio.x,
            top: image.DisplayRect.top * this.ratio.y,
            width: image.DisplayRect.width * this.ratio.x,
            height: image.DisplayRect.height * this.ratio.y
        };
        var img = new Image();
        img.src = this.getImageSrc(image, rect);
        img.onload = function () {
            $this.drawContext.clearRect(rect.left, rect.top, rect.width, rect.height);
            $this.drawContext.drawImage(img, rect.left, rect.top, rect.width, rect.height);
        };

        img.onerror = function () {
            var textColor = "#ccc",fontWeight = "bold",fontSize = 12,fontName = "宋体";
            var textStyle = fontWeight + " " + fontSize + "px " + fontName;
            if (image.Type == "imgsign") {
                $this.drawRectCenterText("请点击此处签名", rect, textColor, textStyle, fontSize);
            }
            if (image.Type == "barCode") {
                $this.drawRectCenterText("条形码", rect, textColor, textStyle, fontSize);
            }
            if (image.Type == "qrCode") {
                $this.drawRectCenterText("二维码", rect, textColor, textStyle, fontSize);
            }
            if (image.Type == "img") {
                $this.drawContext.fillRectangle(rect, "#aaa");
                $this.drawRectCenterText("无图片", rect, textColor, textStyle, fontSize);
            }
            $this.drawContext.drawRectangle(rect, "gray");
        };

        if (this.editMode && image.Type == "imgsign") {
            this.addEditPluginArea({
                code: image.Code,
                target: this.canvas,
                areaItem: image,
                pageNo: this.currentPage.PageNo,
                editBoxRect: {
                    left: rect.left,
                    top: rect.top + 6,
                    width: rect.width,
                    height: rect.height
                }
            });
        }
    },

    getImageSrc: function(image, rect){
        var src = "";
        if(image.Type == "img"){
            if (image.URL) src = image.URL;
            return src;
        }

        var value = "";
        if (this.valueObject){
            value = this.valueObject[image.Code];
        }
        if(!value && this.valueObject && image.ValueFromSchedule){
            value = this.valueObject[image.ValueFromSchedule];
        }
        if(!value && image.DefaultValue){
            value = image.DefaultValue;
        }
        if(value== "") return src;
        
        if(image.Type == "qrCode"){
            src = jrQrcode.getQrBase64(value);
        }
        if(image.Type == "barCode"){
            $(this.barCodeImg).attr("width", rect.width);
            $(this.barCodeImg).attr("height", rect.height);
            if(value != "") $(this.barCodeImg).JsBarcode(value);
            src = this.barCodeImg.src;
        }
        if(image.Type == "imgsign"){
            if(value) src = value;
        }
        return src;
    },

    addEditPluginArea: function(editPluginArea){
        var isFind = false;
        for(var i=0; i < this.editPluginAreaInfo.length; i++){
            if(editPluginArea.code == this.editPluginAreaInfo[i].code){
                isFind = true;
                break;
            }
        }
        if(!isFind){
            this.editPluginAreaInfo.push(editPluginArea);
        }
    },

    getEditPluginArea: function(){
        return this.editPluginAreaInfo;
    },

    drawTitles: function () {
        for (var i = 0; i < this.currentPage.Titles.length; i++) {
            this.drawTitle(this.currentPage.Titles[i]);
        }
    },

    drawTitle: function (title) {
        var rect = {
            left: title.DisplayRect.left * this.ratio.x,
            top: title.DisplayRect.top * this.ratio.y,
            width: title.DisplayRect.width * this.ratio.x,
            height: title.DisplayRect.height * this.ratio.y
        };
        var styleCode = title.StyleCode ? title.StyleCode : "TitleStyle";
        var titleStyle = this.getStyleByCode(styleCode);
        if (titleStyle == "") titleStyle = this.getStyleByCode("TitleStyle");
        if (title.BorderLine) {
            var borderColor = titleStyle.BorderStyle.LineColor;
            this.drawContext.drawRectangle(rect, borderColor);
        }

        var textColor = titleStyle.FontStyle.FontColor;
        var fontWeight = titleStyle.FontStyle.Weight;
        var fontSize = titleStyle.FontStyle.FontSize * this.ratio.fontRatio;
        var fontName = titleStyle.FontStyle.FontName;
        var textStyle = fontWeight + " " + fontSize + "px " + fontName;
        var titleDesc = title.Desc;
        this.drawRectCenterText(titleDesc, rect, textColor, textStyle, fontSize);
    },

    drawRectCenterText: function (text, rect, textColor, textStyle, textHeight) {
        var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle);
        var textLocation = {
            x: rect.left + Math.round((rect.width - textWidth) / 2),
            y: rect.top + Math.round((rect.height - textHeight) / 2)
        };
        this.drawContext.drawString(text, textLocation, textColor, textStyle);
    },

    drawVerticalRectCenterText: function (text, rect, textColor, textStyle, textHeight, charSpace) {
        var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle) * charSpace - (charSpace - 1) * textHeight;
        var textLocation = {
            x: rect.left + Math.round((rect.width - textHeight) / 2),
            y: rect.top + Math.round((rect.height - textWidth) / 2)
        };
        this.drawContext.drawVerticalString(text, textLocation, textColor, textStyle, textHeight * charSpace, "", "", 0);
    },

    drawSplitLines: function () {
        if (this.currentPage.Lines) {
            for (var i = 0; i < this.currentPage.Lines.length; i++) {
                this.drawSplitLine(this.currentPage.Lines[i]);
            }
        }
    },

    drawSplitLine: function (line) {
        var rect = {
            left: line.DisplayRect.left * this.ratio.x,
            top: line.DisplayRect.top * this.ratio.y,
            width: line.DisplayRect.width * this.ratio.x,
            height: line.DisplayRect.height * this.ratio.y
        };

        var startPos = {
            x: rect.left,
            y: rect.top + rect.height / 2
        };
        var endPos = {
            x: rect.left + rect.width,
            y: rect.top + rect.height / 2
        };
        if (line.LineType == "Vertical") {
            startPos = {
                x: rect.left + rect.width / 2,
                y: rect.top
            };
            endPos = {
                x: rect.left + rect.width / 2,
                y: rect.top + rect.height
            };
        }
        var areaStyle = this.getStyleByCode("AreaStyle");
        var strokeStyle = areaStyle.BorderStyle.LineColor;
        if (line.LineDashed) {
            this.drawContext.drawDashLine(startPos, endPos, strokeStyle);
        } else {
            this.drawContext.drawLine(startPos, endPos, strokeStyle);
        }
    },

    drawAreas: function () {
        for (var i = 0; i < this.currentPage.Areas.length; i++) {
            this.drawArea(this.currentPage.Areas[i]);
        }
    },

    drawArea: function (area) {
        var rect = {
            left: area.DisplayRect.left * this.ratio.x,
            top: area.DisplayRect.top * this.ratio.y,
            width: area.DisplayRect.width * this.ratio.x,
            height: area.DisplayRect.height * this.ratio.y
        };
        if(area.Mask) this.drawContext.clearRect(rect.left, rect.top, rect.width, rect.height);
        var styleCode = area.StyleCode ? area.StyleCode : "AreaStyle";
        var areaStyle = this.getStyleByCode(styleCode);
        if (areaStyle == "") areaStyle = this.getStyleByCode("AreaStyle");
        var borderColor = areaStyle.BorderStyle.LineColor;
        if (area.BorderLine) {
            this.drawContext.drawRectangle(rect, borderColor);

            if (area.DrawAreaTitle) {
                var areaItemStyle = this.getStyleByCode("AreaItemStyle");
                var fontSize = areaItemStyle.FontStyle.FontSize;
                var textHeight = fontSize * this.ratio.fontRatio;
                var textColor = areaItemStyle.FontStyle.FontColor;
                var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
                var strokeStyle = borderColor;
                if (area.AreaTitleDirection == "left" || area.AreaTitleDirection == "right") {
                    var areaTitleRect = {
                        left: rect.left,
                        top: rect.top,
                        width: textHeight * 2,
                        height: rect.height
                    };
                    if (area.AreaTitleWidth) {
                        areaTitleRect.width = parseInt(area.AreaTitleWidth);
                    }
                    var startPos = {
                        x: areaTitleRect.left + areaTitleRect.width,
                        y: areaTitleRect.top
                    };
                    var endPos = {
                        x: areaTitleRect.left + areaTitleRect.width,
                        y: areaTitleRect.top + areaTitleRect.height
                    };
                    if (area.AreaTitleDirection == "right") {
                        areaTitleRect.left = rect.left + rect.width - areaTitleRect.width;
                        startPos.x = areaTitleRect.left;
                        endPos.x = areaTitleRect.left;
                    }
                    this.drawContext.drawLine(startPos, endPos, strokeStyle);
                    var charSpace = area.CharSpace ? parseFloat(area.CharSpace) : 1.2;
                    if (charSpace < 1) charSpace = 1;
                    this.drawVerticalRectCenterText(area.Desc, areaTitleRect, textColor, textStyle, textHeight, charSpace);
                }
                if (area.AreaTitleDirection == "top" || area.AreaTitleDirection == "bottom") {
                    var areaTitleRect = {
                        left: rect.left,
                        top: rect.top,
                        width: rect.width,
                        height: textHeight * 2
                    };
                    if (area.AreaTitleWidth) {
                        areaTitleRect.height = parseInt(area.AreaTitleWidth);
                    }
                    var startPos = {
                        x: areaTitleRect.left,
                        y: areaTitleRect.top + areaTitleRect.height
                    };
                    var endPos = {
                        x: areaTitleRect.left + areaTitleRect.width,
                        y: areaTitleRect.top + areaTitleRect.height
                    };
                    if (area.AreaTitleDirection == "bottom") {
                        areaTitleRect.top = rect.top + rect.height - areaTitleRect.height;
                        startPos.y = areaTitleRect.top;
                        endPos.y = areaTitleRect.top;
                    }
                    this.drawContext.drawLine(startPos, endPos, strokeStyle);
                    this.drawRectCenterText(area.Desc, areaTitleRect, textColor, textStyle, textHeight);
                }
            }
        }

        if (area.AreaItems) {
            for (var i = 0; i < area.AreaItems.length; i++) {
                this.drawAreaItem(rect, area.AreaItems[i]);
            }
        }
    },

    drawAreaItem: function (areaRect, areaItem) {
        var type = areaItem.Type;
        switch (type) {
            case "textbox":
            case "combobox":
            case "datebox":
            case "datetimebox":
            case "timespinner":
            case "textarea":
            case "numberspinner":
            case "signature":
                this.drawTextBoxAreaItem(areaRect, areaItem);
                break;
            case "checkbox":
                this.drawCheckBoxAreaItem(areaRect, areaItem);
                break;
            default:
                break;
        }
    },


    drawTextBoxAreaItem: function (areaRect, areaItem) {
        var rect = {
            left: areaRect.left + areaItem.DisplayRect.left * this.ratio.x,
            top: areaRect.top + areaItem.DisplayRect.top * this.ratio.y,
            width: areaItem.DisplayRect.width * this.ratio.x,
            height: areaItem.DisplayRect.height * this.ratio.y
        };
        var styleCode = areaItem.StyleCode ? areaItem.StyleCode : "AreaItemStyle";
        var areaItemStyle = this.getStyleByCode(styleCode);
        if (areaItemStyle == "") areaItemStyle = this.getStyleByCode("AreaItemStyle");
        var textColor = areaItemStyle.FontStyle.FontColor;
        var fontSize = areaItemStyle.FontStyle.FontSize * this.ratio.fontRatio;
        var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
        var textWidth = this.canvasContext.measureTextWidth(areaItem.Desc, textColor, textStyle) * 1.1;
        var unitWidth = 0;
        if (areaItem.Unit) {
            unitWidth = this.canvasContext.measureTextWidth(areaItem.Unit, textColor, textStyle) * 1.2;
        }
        var textHeight = fontSize;
        var textLocation = {
            x: rect.left,
            y: rect.top
        };
        var baseline = "";
        var direction = "";
        var maxWidth = 0;
        if (areaItem.TextDirection && areaItem.TextDirection === "Vertical") {
            var charSpace = 1.2;
            if (areaItem.CharSpace) charSpace = parseFloat(areaItem.CharSpace);
            this.drawContext.drawVerticalString(areaItem.Desc, textLocation, textColor, textStyle, areaItemStyle.FontStyle.FontSize * charSpace, baseline, direction, maxWidth)
        } else {
            if(areaItem.TextDirection && areaItem.TextDirection === "Horizontal" && textWidth > rect.width){
                this.drawMultiLineValue(areaItem.Desc, textLocation, textColor, textStyle, rect.width, textHeight);
            }else{
                this.drawContext.drawString(areaItem.Desc, textLocation, textColor, textStyle, baseline, direction, maxWidth);
            }
        }

        if (areaItem.Unit) {
            var unitLocation = {
                x: rect.left + rect.width - unitWidth / 1.1,
                y: rect.top
            };
            this.drawContext.drawString(areaItem.Unit, unitLocation, textColor, textStyle, baseline, direction, maxWidth);
        }

        if (this.editMode && (!areaItem.TextDirection)) {
            this.addEditPluginArea({
                code: areaItem.Code,
                target: this.canvas,
                areaItem: areaItem,
                pageNo: this.currentPage.PageNo,
                editBoxRect: {
                    left: rect.left + textWidth,
                    top: rect.top,
                    width: rect.width - textWidth - unitWidth * 1.3,
                    height: rect.height
                }
            });
        }

        if (areaItem.UnderLine && !(this.editMode)) {
            var startPos = {
                x: rect.left + textWidth,
                y: rect.top + textHeight
            };
            var endPos = {
                x: rect.left + rect.width - unitWidth,
                y: rect.top + textHeight
            };
            var strokeStyle = textColor;
            this.drawContext.drawLine(startPos, endPos, strokeStyle);
        }

        if (this.valueObject && !(this.editMode) && (!areaItem.TextDirection)) {
            var displayValue = this.valueObject[areaItem.Code];
            if(!displayValue && areaItem.ValueFromSchedule){
                displayValue = this.valueObject[areaItem.ValueFromSchedule];
            }
            if (areaItemStyle.ValueStyle && displayValue) {
                var valueLoction = {
                    x: rect.left + textWidth,
                    y: rect.top
                };
                var remainWidth = rect.width - textWidth - unitWidth;
                var valueColor = areaItemStyle.ValueStyle.FontColor;
                var valueStyle = areaItemStyle.ValueStyle.Weight + " " + areaItemStyle.ValueStyle.FontSize + "px " + areaItemStyle.ValueStyle.FontName;
                var valueWidth = this.canvasContext.measureTextWidth(displayValue, valueColor, valueStyle);
                if (valueWidth > remainWidth || displayValue.indexOf('\n') >= 0) {
                    this.drawMultiLineValue(displayValue, valueLoction, valueColor, valueStyle, remainWidth, textHeight);
                } else {
                    this.drawContext.drawString(displayValue, valueLoction, valueColor, valueStyle);
                }
            }
        }
    },

    drawMultiLineValue: function (displayValue, valueLoction, valueColor, valueStyle, remainWidth, textHeight) {
        // 计算每一行
        var lines = [];
        var curLine = '';
        for (var i = 0; i < displayValue.length; i++) {
            var char = displayValue[i];
            var nextLine = curLine + char;
            var width = this.canvasContext.measureTextWidth(nextLine, valueColor, valueStyle);
            if (char === '\n' || width > remainWidth) {
                lines.push(curLine);
                curLine = char === '\n' ? '' : char;
            } else {
                curLine = nextLine;
            }
        }
        lines.push(curLine);

        // 逐行画文本
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            var lineY = valueLoction.y + (textHeight + textHeight / 2) * i;
            var location = {
                x: valueLoction.x,
                y: lineY
            };
            this.drawContext.drawString(line, location, valueColor, valueStyle);
        }
    },

    drawCheckBoxAreaItem: function (areaRect, areaItem) {
        var rect = {
            left: areaRect.left + areaItem.DisplayRect.left * this.ratio.x,
            top: areaRect.top + areaItem.DisplayRect.top * this.ratio.y,
            width: areaItem.DisplayRect.width * this.ratio.x,
            height: areaItem.DisplayRect.height * this.ratio.y
        };
        var styleCode = areaItem.StyleCode ? areaItem.StyleCode : "AreaItemStyle";
        var areaItemStyle = this.getStyleByCode(styleCode);
        if (areaItemStyle == "") areaItemStyle = this.getStyleByCode("AreaItemStyle");
        var textColor = areaItemStyle.FontStyle.FontColor;
        var fontSize = areaItemStyle.FontStyle.FontSize * this.ratio.fontRatio;
        var textStyle = areaItemStyle.FontStyle.Weight + " " + fontSize + "px " + areaItemStyle.FontStyle.FontName;
        var textHeight = fontSize;

        var boxWidth = Math.round(textHeight * 0.8);
        var boxHeigth = boxWidth;
        var boxRect = {
            left: rect.left,
            top: rect.top + Math.round((textHeight - boxHeigth) / 2),
            width: boxWidth,
            height: boxHeigth
        };
        var textLocation = {
            x: rect.left + textHeight,
            y: rect.top
        };
        if(areaItem.CheckboxAlign && areaItem.CheckboxAlign == "right"){
            boxRect = {
                left: rect.left + rect.width - boxWidth,
                top: rect.top + Math.round((textHeight - boxHeigth) / 2),
                width: boxWidth,
                height: boxHeigth
            };
            textLocation = {
                x: rect.left,
                y: rect.top
            };
        }


        if (!this.editMode) this.drawContext.drawRectangle(boxRect, textColor);
        this.drawContext.drawString(areaItem.Desc, textLocation, textColor, textStyle, "", "", 0);

        if (this.valueObject && !(this.editMode)) {
            var displayValue = this.valueObject[areaItem.Code];
            if (areaItem.Group) displayValue = this.valueObject[areaItem.Group];
            if(!displayValue) return;
            if ((displayValue == "true")||(displayValue == true)||(displayValue.indexOf(areaItem.Code)>=0)||(displayValue.indexOf(areaItem.Desc)>=0)) {
                var valueLoction = {
                    x: boxRect.left - boxRect.width * 0.35,
                    y: boxRect.top - boxRect.height * 0.35
                };
                var valueColor = areaItemStyle.ValueStyle.FontColor;
                var valueWeight = "bold";  //areaItemStyle.ValueStyle.Weight
                var valueFontSize = "18";  //areaItemStyle.ValueStyle.FontSize;
                var valueFontName = areaItemStyle.ValueStyle.FontName;
                var valueStyle = valueWeight + " " + valueFontSize + "px " + valueFontName;
                this.drawContext.drawString("√", valueLoction, valueColor, valueStyle);
            }
        }

        if (this.editMode) {
            this.addEditPluginArea({
                code: areaItem.Code,
                target: this.canvas,
                areaItem: areaItem,
                pageNo: this.currentPage.PageNo,
                editBoxRect: {
                    left: boxRect.left - 8,
                    top: boxRect.top,
                    width: textHeight,
                    height: textHeight
                }
            });
        }
    },

    drawSelectedRect: function () {
        var rect = null;
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject) {
            rect = currentClickObject.clickRect;
        }

        if (rect) {
            var borderColor = "blue";
            var lineDash = [5, 2];
            var selectedBorderRect = {
                left: rect.left - 1,
                top: rect.top - 1,
                width: rect.width + 2,
                height: rect.height + 2
            };
            this.drawContext.drawRectangle(selectedBorderRect, borderColor, lineDash);
            var resizeBlock = this.resizeBlock;
            var resizeBlockRect = {
                left: selectedBorderRect.left + selectedBorderRect.width - resizeBlock.width,
                top: selectedBorderRect.top + selectedBorderRect.height - resizeBlock.height,
                width: resizeBlock.width,
                height: resizeBlock.height
            };
            this.drawContext.drawRectangle(resizeBlockRect, borderColor);
        }
    },

    drawSelectedCell: function () {
        if (this.clickInfo.complexTable && this.clickInfo.complexTableCell) {
            var rect = this.getCurrentComplexCellRect();
            if (rect) {
                var borderColor = "green";
                var lineDash = [5, 2];
                var selectedBorderRect = {
                    left: rect.left + 3,
                    top: rect.top + 3,
                    width: rect.width - 6,
                    height: rect.height - 6
                };
                this.drawContext.drawRectangle(selectedBorderRect, borderColor, lineDash);
            }
        }
    },

    drawTables: function () {
        if (this.currentPage.Tables) {
            for (var i = 0; i < this.currentPage.Tables.length; i++) {
                this.drawTable(this.currentPage.Tables[i]);
            }
        }
    },

    drawTable: function (table) {
        var rect = {
            left: table.DisplayRect.left * this.ratio.x,
            top: table.DisplayRect.top * this.ratio.y,
            width: table.DisplayRect.width * this.ratio.x,
            height: table.DisplayRect.height * this.ratio.y
        };
        var styleCode = table.StyleCode ? table.StyleCode : "TableStyle";
        var tableStyle = this.getStyleByCode(styleCode);
        if (tableStyle == "") tableStyle = this.getStyleByCode("TableStyle");
        var borderColor = tableStyle.BorderStyle.LineColor;
        var strokeStyle = borderColor;

        //绘制边框
        this.drawContext.drawRectangle(rect, borderColor);

        var headerHeight = rect.height / table.RowCount;
        if(parseInt(table.HeaderHeight) > 0){
            headerHeight = parseInt(table.HeaderHeight * this.ratio.y);
        }
        //绘制行
        var rowHeight = (rect.height - headerHeight ) / (table.RowCount - 1);
        var rowPostionY = rect.top;
        for (var i = 0; i < table.RowCount - 1; i++) {
            if(i == 0 ){
                rowPostionY = rowPostionY + headerHeight;
            }else{
                rowPostionY = rowPostionY + rowHeight;
            }
            
            var lineStartPos = {
                x: rect.left,
                y: rowPostionY
            };
            var lineEndPos = {
                x: rect.left + rect.width,
                y: rowPostionY
            };
            this.drawContext.drawLine(lineStartPos, lineEndPos, strokeStyle);
        }

        //绘制列
        var colPostionX = rect.left;
        var totalRelativeWidth = 0;
        var colWidthArray = [];
        for (var i = 0; i < table.Columns.length; i++) {
            totalRelativeWidth = totalRelativeWidth + table.Columns[i].RelativeWidth;
        }

        for (var i = 0; i < table.Columns.length; i++) {
            var column = table.Columns[i];
            var colWidthPercent = column.RelativeWidth / totalRelativeWidth;
            var colWidth = rect.width * colWidthPercent;
            colWidthArray.push(colWidth);

            colPostionX = colPostionX + colWidth;
            if (colPostionX > rect.left + rect.width) {
                break;
            }

            var lineStartPos = {
                x: colPostionX,
                y: rect.top
            };
            var lineEndPos = {
                x: colPostionX,
                y: rect.top + rect.height
            };
            if (i < table.Columns.length - 1) {
                this.drawContext.drawLine(lineStartPos, lineEndPos, strokeStyle);
            }
        }
        this.drawTableCellContent(table, colWidthArray, rowHeight, tableStyle, headerHeight);
    },

    drawTableCellContent: function (table, colWidthArray, rowHeight, tableStyle, headerHeight) {
        var rect = {
            left: table.DisplayRect.left * this.ratio.x,
            top: table.DisplayRect.top * this.ratio.y,
            width: table.DisplayRect.width * this.ratio.x,
            height: table.DisplayRect.height * this.ratio.y
        };
        var textColor = tableStyle.FontStyle.FontColor;
        var fontSize = tableStyle.FontStyle.FontSize * this.ratio.fontRatio;
        var textStyle = tableStyle.FontStyle.Weight + " " + fontSize + "px " + tableStyle.FontStyle.FontName;
        var textHeight = fontSize;

        var valueColor = tableStyle.ValueStyle.FontColor;
        var valueFontSize = tableStyle.ValueStyle.FontSize * this.ratio.fontRatio;
        var valueStyle = tableStyle.ValueStyle.Weight + " " + valueFontSize + "px " + tableStyle.ValueStyle.FontName;
        var valueHeight = valueFontSize;

        //绘制表头
        var colPostionX = rect.left;
        var colPostionY = rect.top;
        for (var i = 0; i < colWidthArray.length; i++) {
            var column = table.Columns[i];
            var colWidth = colWidthArray[i];
            colPostionX = colPostionX + colWidth;
            if (colPostionX > rect.left + rect.width) {
                break;
            }
            var colHeaderRect = {
                left: colPostionX - colWidth,
                top: colPostionY,
                width: colWidth,
                height: headerHeight
            };
            if (column.ColumnDesc) {
                this.drawCellCenterText(column.ColumnDesc, colHeaderRect, textColor, textStyle, textHeight);
            }
        }

        //绘制表格内容
        if (this.tableValuesArray) {
            var currentTableValues = null;
            for (var i = 0; i < this.tableValuesArray.length; i++) {
                if (this.tableValuesArray[i].tableCode === table.Code) {
                    currentTableValues = this.tableValuesArray[i].tableValues;
                    break;
                }
            }
            if (currentTableValues === null) return;
            var cellPostionX = rect.left;
            var cellPostionY = colPostionY + headerHeight;
            for (var i = 0; i < currentTableValues.length; i++) {
                var tableValueObject = currentTableValues[i];
                if (i > table.RowCount - 1) {
                    break;
                }
                for (var j = 0; j < table.Columns.length; j++) {
                    var column = table.Columns[j];
                    var cellValue = tableValueObject[column.ColumnCode];
                    var cellWidth = colWidthArray[j];
                    var cellRect = {
                        left: cellPostionX,
                        top: cellPostionY,
                        width: cellWidth,
                        height: rowHeight
                    };
                    cellPostionX = cellPostionX + cellWidth;
                    this.drawCellCenterText(cellValue, cellRect, valueColor, valueStyle, valueHeight);
                }
                cellPostionX = rect.left;
                cellPostionY = cellPostionY + rowHeight;
            }
        }
        var cellPostionX = rect.left;
        var cellPostionY = rect.top + headerHeight;
        for (var i = 0; i < table.RowCount - 1; i++) {
            for (var j = 0; j < table.Columns.length; j++) {
                var column = table.Columns[j];
                var cellWidth = colWidthArray[j];
                var cellRect = {
                    left: cellPostionX,
                    top: cellPostionY,
                    width: cellWidth,
                    height: rowHeight
                };
                if(column.Type){
                    var areaItemCode = table.Code + "-" + column.ColumnCode + "-" + i;
                    this.drawCenterCellAreaItem(cellRect, areaItemCode, column, fontSize, i);
                }
                cellPostionX = cellPostionX + cellWidth;
            }
            cellPostionX = rect.left;
            cellPostionY = cellPostionY + rowHeight;
        }
    },

    drawCenterCellAreaItem: function(cellRect, areaItemCode, column, fontSize, rowIndex){
        var columeDesc = column.Desc;
        if(columeDesc.indexOf(";") >= 0){
            var columnDescArr = columeDesc.split(";");
            if (rowIndex < columnDescArr.length) columeDesc = columnDescArr[rowIndex];
            else columeDesc = "";
        }
        var controlWidth = cellRect.width * 0.6;
        if(column.ControlWidth) controlWidth = parseInt(column.ControlWidth) * this.ratio.x;
        var controlHeight = fontSize;
        var controlLeft = parseInt((cellRect.width - controlWidth) / 2 );
        var controlTop = parseInt((cellRect.height - controlHeight) / 2 );
        var areaItem  = {
            Code : areaItemCode,
            Desc : columeDesc,
            DisplayRect : {
                left: controlLeft,
                top: controlTop,
                width: controlWidth,
                height: controlHeight
            },
            Type: column.Type, 
            UnderLine: column.UnderLine,
            Editable: column.Editable,
            Required: column.Required,
            TextDirection: column.TextDirection,
            StyleCode: "AreaItemStyle"
        }
        this.drawAreaItem(cellRect, areaItem);
    },

    drawCellCenterText: function(text, cellRect, textColor, textStyle, textHeight){
        var textWidth = this.canvasContext.measureTextWidth(text, textColor, textStyle);
        if (textWidth > cellRect.width || text.indexOf('\n') >= 0) {
            var valueLoction = {
                x : cellRect.left + cellRect.width * 0.05, 
                y : cellRect.top + cellRect.height * 0.05
            };
            var realyTextWidth = cellRect.width * 0.9;
            this.drawMultiLineValue(text, valueLoction, textColor, textStyle, realyTextWidth, textHeight);
        } else {
            this.drawRectCenterText(text, cellRect, textColor, textStyle, textHeight);
        }
    },

    /*** begin 绘制表格区域 ***/
    drawComplexTables: function () {
        if (this.currentPage.ComplexTables) {
            for (var i = 0; i < this.currentPage.ComplexTables.length; i++) {
                this.drawComplexTable(this.currentPage.ComplexTables[i]);
            }
        }
    },

    drawComplexTable: function (complexTable) {
        var styleCode = complexTable.StyleCode ? complexTable.StyleCode : "TableStyle";
        var tableStyle = this.getStyleByCode(styleCode);
        if (tableStyle == "") tableStyle = this.getStyleByCode("TableStyle");
        var borderColor = tableStyle.BorderStyle.LineColor;
        var strokeStyle = borderColor;

        var rect = {
            left: complexTable.DisplayRect.left * this.ratio.x,
            top: complexTable.DisplayRect.top * this.ratio.y,
            width: complexTable.DisplayRect.width * this.ratio.x,
            height: complexTable.DisplayRect.height* this.ratio.y
        };

        if(!complexTable.TableInfo) return;

        var totalRowHeight = 0;
        for (var i = 0; i < complexTable.TableInfo.Rows.length; i++) {
            totalRowHeight += complexTable.TableInfo.Rows[i].RowHeight;
        }
        var totalColWidth = 0;
        for (var j = 0; j < complexTable.TableInfo.Cols.length; j++) {
            totalColWidth += complexTable.TableInfo.Cols[j].ColWidth;
        }

        //绘制表格外边框
        this.drawContext.drawRectangle(rect, borderColor);
        //绘制表格横线
        var lineTop = rect.top;
        for (var i = 0; i < complexTable.TableInfo.Rows.length - 1; i++) {
            var realRowHeight = (complexTable.TableInfo.Rows[i].RowHeight / totalRowHeight) * rect.height;
            lineTop = lineTop + realRowHeight;
            this.drawContext.drawLine({
                x: rect.left,
                y: lineTop
            }, {
                x: rect.left + rect.width,
                y: lineTop
            }, strokeStyle);
        }

        //绘制表格竖线
        var lineLeft = rect.left;
        for (var j = 0; j < complexTable.TableInfo.Cols.length - 1; j++) {
            var realColWidth = (complexTable.TableInfo.Cols[j].ColWidth / totalColWidth) * rect.width;
            lineLeft = lineLeft + realColWidth;
            this.drawContext.drawLine({
                x: lineLeft,
                y: rect.top
            }, {
                x: lineLeft,
                y: rect.top + rect.height
            }, strokeStyle);
        }

        for (var k = 0; k < complexTable.TableInfo.Cells.length; k++) {
            this.drawComplexTableCell(complexTable, complexTable.TableInfo.Cells[k], borderColor);
        }
    },

    drawComplexTableCell: function (complexTable, cell, borderColor) {
        var rect = this.getTableCellRectInfoByCell(complexTable, cell);
        this.drawContext.fillRectangle(rect, "white");
        this.drawContext.drawRectangle(rect, borderColor);

        if (cell.AreaItems) {
            for (var i = 0; i < cell.AreaItems.length; i++) {
                this.drawAreaItem(rect, cell.AreaItems[i]);
            }
        }
    },

    getTableCellRectInfoByCell: function (complexTable, cell) {
        var $this = this;
        var rect = null;
        if (cell.IsMergeCells) {
            rect = getCellRect(complexTable, cell.FromRowIndex, cell.ToRowIndex, cell.FromColIndex, cell.ToColIndex);
        } else {
            rect = getCellRect(complexTable, cell.RowIndex, cell.RowIndex, cell.ColIndex, cell.ColIndex);
        }
        return rect;

        function getCellRect(complexTable, fromRowIndex, toRowIndex, fromColIndex, toColIndex) {
            var cellLeft = 0,
                cellTop = 0;
            var cellWidth = 0,
                cellHeight = 0;

            var totalRowHeight = 0;
            for (var i = 0; i < complexTable.TableInfo.Rows.length; i++) {
                totalRowHeight += complexTable.TableInfo.Rows[i].RowHeight;
            }
            var totalColWidth = 0;
            for (var j = 0; j < complexTable.TableInfo.Cols.length; j++) {
                totalColWidth += complexTable.TableInfo.Cols[j].ColWidth;
            }
            
            for (var i = 0; i < complexTable.TableInfo.Rows.length; i++) {
                var realRowHeight = (complexTable.TableInfo.Rows[i].RowHeight / totalRowHeight) * complexTable.DisplayRect.height * $this.ratio.y;
                if (i < fromRowIndex - 1) {
                    cellTop = cellTop + realRowHeight;
                }
                if (i >= fromRowIndex - 1 && i < toRowIndex) {
                    cellHeight = cellHeight + realRowHeight;
                }
            }
            for (var j = 0; j < complexTable.TableInfo.Cols.length; j++) {
                var realRowWidth = (complexTable.TableInfo.Cols[j].ColWidth / totalColWidth) * complexTable.DisplayRect.width * $this.ratio.x;
                if (j < fromColIndex - 1) {
                    cellLeft = cellLeft + realRowWidth;
                }
                if (j >= fromColIndex - 1 && j < toColIndex) {
                    cellWidth = cellWidth + realRowWidth;
                }
            }

            return {
                left: complexTable.DisplayRect.left * $this.ratio.x + cellLeft,
                top: complexTable.DisplayRect.top * $this.ratio.y + cellTop,
                width: cellWidth,
                height: cellHeight
            }
        }
    },

    getTableCellInfoByLocation: function (complexTable, location) {
        var resultCell = null;
        if (complexTable) {
            for (var i = 0; i < complexTable.TableInfo.Cells.length; i++) {
                var cell = complexTable.TableInfo.Cells[i];
                var rect = this.getTableCellRectInfoByCell(complexTable, cell);
                if (ifRectContainPoint(rect, location)) {
                    resultCell = cell;
                }
            }
        }

        function ifRectContainPoint(rect, point){
            var left = rect.left;
            var right = rect.left + rect.width;
            var top = rect.top;
            var bottom = rect.top + rect.height;
            if (point.x - left < 0 || point.x - right > 0) {
                return false;
            }
            if (point.y - top < 0 || point.y - bottom > 0) {
                return false;
            }
            return true;
        }

        return resultCell;
    },

    getCurrentComplexCellRect: function () {
        var rect = null;
        if (this.clickInfo.complexTable && this.clickInfo.complexTableCell) {
            rect = this.getTableCellRectInfoByCell(this.clickInfo.complexTable, this.clickInfo.complexTableCell);
        }
        return rect;
    },
    /*** end 绘制表格区域 ***/

    drawGrid: function () {
        var width = this.canvas.width;
        var height = this.canvas.height;

        var strokeStyle = "#eeeeee";
        var scale = 10;
        for (var i = scale; i < height; i += scale) {
            var lineStartPos = {
                x: 0,
                y: i
            };
            var lineEndPos = {
                x: width,
                y: i
            };
            this.drawContext.drawLine(lineStartPos, lineEndPos, strokeStyle);
        }

        for (var j = scale; j < width; j += scale) {
            var lineStartPos = {
                x: j,
                y: 0
            };
            var lineEndPos = {
                x: j,
                y: height
            };
            this.drawContext.drawLine(lineStartPos, lineEndPos, strokeStyle);
        }
    },

    drawCoordinateLine: function (location) {
        var width = this.canvas.width;
        var height = this.canvas.height;

        var strokeStyle = "green";
        this.drawContext.drawLine({
            x: location.x,
            y: 0
        }, {
            x: location.x,
            y: height
        }, strokeStyle);
        this.drawContext.drawLine({
            x: 0,
            y: location.y
        }, {
            x: width,
            y: location.y
        }, strokeStyle);
    },

    /**
     * 捕捉鼠标信息，设置上下文
     */
    initAction: function () {
        this.clearClickInfo();
        this.clearDrawingContext();
        this.clearMouseStatus();
    },

    clearClickInfo: function () {
        this.clickInfo = {
            location: null,
            page: null,
            image: null,
            title: null,
            area: null,
            areaItem: null,
            table: null,
            line: null,
            complexTable: null,
            complexTableCell: null,
            isClickResizeBlock: false
        };
    },

    setClickInfo: function (location) {
        this.clickInfo.title = null;
        this.clickInfo.area = null;
        this.clickInfo.areaItem = null;
        this.clickInfo.image = null;
        this.clickInfo.table = null;
        this.clickInfo.line = null;
        this.clickInfo.complexTable = null;
        this.clickInfo.complexTableCell = null;

        this.clickInfo.location = location;
        this.clickInfo.page = this.currentPage;
        this.clickInfo.line = getClickLine(this.currentPage, location);
        this.clickInfo.image = getClickImage(this.currentPage, location);
        this.clickInfo.table = getClickTable(this.currentPage, location);
        this.clickInfo.title = getClickTitle(this.currentPage, location);
        this.clickInfo.area = getClickArea(this.currentPage, location);
        this.clickInfo.areaItem = getClickAreaItem(this.clickInfo.area, location);
        this.clickInfo.complexTable = getClickComplexTable(this.currentPage, location);
        this.clickInfo.complexTableCell = this.getTableCellInfoByLocation(this.clickInfo.complexTable, location);
        if (this.clickInfo.complexTableCell) {
            var cellRect = this.getCurrentComplexCellRect();
            this.clickInfo.areaItem = getClickCellAreaItem(this.clickInfo.complexTableCell, cellRect, location);
        }

        /**begin 选中多个区域项目 */
        if ((this.clickInfo.area != this.lastClickArea && this.lastClickArea != null) || (!this.isCtrlDown)) {
            this.multSelectedAreaItems = [];
        }
        if (this.isCtrlDown && this.clickInfo.areaItem) {
            if (this.multSelectedAreaItems.indexOf(this.clickInfo.areaItem) == -1) {
                this.multSelectedAreaItems.push(this.clickInfo.areaItem);
            }
        }
        this.lastClickArea = this.clickInfo.area;
        /**end 选中多个区域项目 */

        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject) {
            this.clickInfo.isClickResizeBlock = ifClickResizeBlock(currentClickObject.clickRect, this.resizeBlock, location);
        }

        this.setSelectedItemInfo();

        function getClickImage(page, location) {
            for (var i = 0; i < page.Images.length; i++) {
                var image = page.Images[i];
                if (ifRectContainPoint(image.DisplayRect, location)) {
                    return image;
                }
            }
            return null;
        }

        function getClickTitle(page, location) {
            for (var i = 0; i < page.Titles.length; i++) {
                var title = page.Titles[i];
                if (ifRectContainPoint(title.DisplayRect, location)) {
                    return title;
                }
            }
            return null;
        }

        function getClickArea(page, location) {
            for (var i = 0; i < page.Areas.length; i++) {
                var area = page.Areas[i];
                if (ifRectContainPoint(area.DisplayRect, location)) {
                    return area;
                }
            }
            return null;
        }

        function getClickAreaItem(area, location) {
            if (area) {
                for (var i = 0; i < area.AreaItems.length; i++) {
                    var areaItem = area.AreaItems[i];
                    var rect = {
                        left: area.DisplayRect.left + areaItem.DisplayRect.left,
                        top: area.DisplayRect.top + areaItem.DisplayRect.top,
                        width: areaItem.DisplayRect.width,
                        height: areaItem.DisplayRect.height
                    };
                    if (ifRectContainPoint(rect, location)) {
                        return areaItem;
                    }
                }
            }
            return null;
        }

        function getClickCellAreaItem(cell, cellRect, location) {
            if (cell) {
                for (var i = 0; i < cell.AreaItems.length; i++) {
                    var areaItem = cell.AreaItems[i];
                    var rect = {
                        left: cellRect.left + areaItem.DisplayRect.left,
                        top: cellRect.top + areaItem.DisplayRect.top,
                        width: areaItem.DisplayRect.width,
                        height: areaItem.DisplayRect.height
                    };
                    if (ifRectContainPoint(rect, location)) {
                        return areaItem;
                    }
                }
            }
        }

        function getClickTable(page, location) {
            if (page.Tables) {
                for (var i = 0; i < page.Tables.length; i++) {
                    var table = page.Tables[i];
                    if (ifRectContainPoint(table.DisplayRect, location)) {
                        return table;
                    }
                }
            }
            return null;
        }

        function getClickLine(page, location) {
            if (page.Lines) {
                for (var i = 0; i < page.Lines.length; i++) {
                    var line = page.Lines[i];
                    if (ifRectContainPoint(line.DisplayRect, location)) {
                        return line;
                    }
                }
            }
            return null;
        }

        function getClickComplexTable(page, location) {
            if (page.ComplexTables) {
                for (var i = 0; i < page.ComplexTables.length; i++) {
                    var complexTable = page.ComplexTables[i];
                    if (ifRectContainPoint(complexTable.DisplayRect, location)) {
                        return complexTable;
                    }
                }
            }
        }

        function ifRectContainPoint(rect, point) {
            var left = rect.left;
            var right = rect.left + rect.width;
            var top = rect.top;
            var bottom = rect.top + rect.height;
            if (point.x - left < 0 || point.x - right > 0) {
                return false;
            }
            if (point.y - top < 0 || point.y - bottom > 0) {
                return false;
            }
            return true;
        }

        function ifClickResizeBlock(rect, resizeBlock, location) {
            var result = false;
            if (rect) {
                var resizeBlockRect = {
                    left: rect.left + rect.width - resizeBlock.width,
                    top: rect.top + rect.height - resizeBlock.height,
                    width: resizeBlock.width,
                    height: resizeBlock.height
                };
                if (ifRectContainPoint(resizeBlockRect, location)) {
                    result = true;
                }
            }

            return result;
        }
    },

    drawMultSelectedAreaItems: function () {
        for (var i = 0; i < this.multSelectedAreaItems.length; i++) {
            var displayAreaRect = this.clickInfo.area.DisplayRect;
            var rect = this.multSelectedAreaItems[i].DisplayRect;
            var borderColor = "red";
            var lineDash = [5, 2];
            var selectedBorderRect = {
                left: displayAreaRect.left + rect.left - 2,
                top: displayAreaRect.top + rect.top - 2,
                width: rect.width + 2,
                height: rect.height + 2
            };
            this.drawContext.drawRectangle(selectedBorderRect, borderColor, lineDash);
        }
    },

    setMultSelectedAreaItemAlign: function (alignType) {
        if (this.multSelectedAreaItems && this.multSelectedAreaItems.length > 1) {
            var minTop = 1000, maxTop = 0, minLeft = 1000, maxRight = 0;
            for (var i = 0; i < this.multSelectedAreaItems.length; i++) {
                if (this.multSelectedAreaItems[i].DisplayRect.top < minTop) {
                    minTop = this.multSelectedAreaItems[i].DisplayRect.top;
                }
                if (this.multSelectedAreaItems[i].DisplayRect.top > maxTop) {
                    maxTop = this.multSelectedAreaItems[i].DisplayRect.top;
                }
                if (this.multSelectedAreaItems[i].DisplayRect.left < minLeft) {
                    minLeft = this.multSelectedAreaItems[i].DisplayRect.left;
                }
                if (this.multSelectedAreaItems[i].DisplayRect.left + this.multSelectedAreaItems[i].DisplayRect.width > maxRight) {
                    maxRight = this.multSelectedAreaItems[i].DisplayRect.left + this.multSelectedAreaItems[i].DisplayRect.width;
                }
            }

            for (var i = 0; i < this.multSelectedAreaItems.length; i++) {
                if (alignType == "topAlign") {
                    this.multSelectedAreaItems[i].DisplayRect.top = minTop;
                }
                if (alignType == "bottomAlign") {
                    this.multSelectedAreaItems[i].DisplayRect.top = maxTop;
                }
                if (alignType == "leftAlign") {
                    this.multSelectedAreaItems[i].DisplayRect.left = minLeft;
                }
                if (alignType == "rightAlign") {
                    this.multSelectedAreaItems[i].DisplayRect.left = maxRight - this.multSelectedAreaItems[i].DisplayRect.width;
                }
            }

            this.setSelectedItemInfo();
            return true;
        } else {
            return false;
        }
    },

    moveMultSelectedAreaItems: function (moveVector) {
        if (this.multSelectedAreaItems && this.multSelectedAreaItems.length > 1) {
            for (var i = 0; i < this.multSelectedAreaItems.length; i++) {
                var singleSelectedAreaItem = this.multSelectedAreaItems[i];
                if (singleSelectedAreaItem && singleSelectedAreaItem.DisplayRect) {
                    singleSelectedAreaItem.DisplayRect.left += Math.round(moveVector.x);
                    singleSelectedAreaItem.DisplayRect.top += Math.round(moveVector.y);
                }
            }
            this.setSelectedItemInfo();
        }
    },

    getCurrentClickObject: function () {
        var $this = this;
        var currentClickObject = null;
        if (this.clickInfo.line) {
            currentClickObject = {
                clickObjectType: "Line",
                clickObject: $this.clickInfo.line,
                clickRect: $this.clickInfo.line.DisplayRect
            };
        } else if (this.clickInfo.image) {
            currentClickObject = {
                clickObjectType: "Image",
                clickObject: $this.clickInfo.image,
                clickRect: $this.clickInfo.image.DisplayRect
            };
        } else if (this.clickInfo.table) {
            currentClickObject = {
                clickObjectType: "Table",
                clickObject: $this.clickInfo.table,
                clickRect: $this.clickInfo.table.DisplayRect
            };
        } else if (this.clickInfo.areaItem) {
            var areaRectLeft = 0,
                areaRectTop = 0;
            if ($this.clickInfo.area) {
                areaRectLeft = $this.clickInfo.area.DisplayRect.left;
                areaRectTop = $this.clickInfo.area.DisplayRect.top;
            } else if ($this.clickInfo.complexTableCell) {
                var cellRect = $this.getCurrentComplexCellRect();
                areaRectLeft = cellRect.left;
                areaRectTop = cellRect.top;
            }

            currentClickObject = {
                clickObjectType: "AreaItem",
                clickObject: $this.clickInfo.areaItem,
                clickRect: {
                    left: areaRectLeft + $this.clickInfo.areaItem.DisplayRect.left,
                    top: areaRectTop + $this.clickInfo.areaItem.DisplayRect.top,
                    width: $this.clickInfo.areaItem.DisplayRect.width,
                    height: $this.clickInfo.areaItem.DisplayRect.height
                },
                clickRelativeRect: {
                    left: $this.clickInfo.areaItem.DisplayRect.left,
                    top: $this.clickInfo.areaItem.DisplayRect.top,
                    width: $this.clickInfo.areaItem.DisplayRect.width,
                    height: $this.clickInfo.areaItem.DisplayRect.height
                }
            };
        } else if (this.clickInfo.area) {
            currentClickObject = {
                clickObjectType: "Area",
                clickObject: $this.clickInfo.area,
                clickRect: $this.clickInfo.area.DisplayRect
            };
        } else if (this.clickInfo.complexTable) {
            currentClickObject = {
                clickObjectType: "ComplexTable",
                clickObject: $this.clickInfo.complexTable,
                clickRect: $this.clickInfo.complexTable.DisplayRect
            };
        } else if (this.clickInfo.title) {
            currentClickObject = {
                clickObjectType: "Title",
                clickObject: $this.clickInfo.title,
                clickRect: $this.clickInfo.title.DisplayRect
            };
        } else if (this.clickInfo.page) {
            currentClickObject = {
                clickObjectType: "Page",
                clickObject: $this.clickInfo.page,
                clickRect: null
            };
        }
        return currentClickObject;
    },

    setSelectedItemInfo: function () {
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject) {
            if (this.onItemSelected) this.onItemSelected(currentClickObject.clickObjectType, currentClickObject.clickObject);
        }
        this.drawPage();
        this.drawSelectedRect();
        this.drawSelectedCell();
        //绘制已经选择多个区域项目
        this.drawMultSelectedAreaItems();
    },

    onPropertyValueChanged: function (valueInfo) {
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject) {
            if (valueInfo.subKey) {
                currentClickObject.clickObject[valueInfo.key][valueInfo.subKey] = valueInfo.value;
            } else {
                currentClickObject.clickObject[valueInfo.key] = valueInfo.value;
            }
        }
        this.drawPage();
        this.drawSelectedRect();
    },

    moveSelectedItem: function (moveVector) {
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject && currentClickObject.clickObject && currentClickObject.clickObject.DisplayRect) {
            currentClickObject.clickObject.DisplayRect.left += Math.round(moveVector.x);
            currentClickObject.clickObject.DisplayRect.top += Math.round(moveVector.y);

            if (currentClickObject.clickObject.DisplayRect.left < 0) currentClickObject.clickObject.DisplayRect.left = 0;
            if (currentClickObject.clickObject.DisplayRect.top < 0) currentClickObject.clickObject.DisplayRect.top = 0;

        }
        this.setSelectedItemInfo();

        var rect = currentClickObject.clickRect;
        if (rect) this.drawCoordinateLine({
            x: rect.left,
            y: rect.top
        });
    },

    resizeSelectedItem: function (moveVector) {
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject && currentClickObject.clickObject && currentClickObject.clickObject.DisplayRect) {
            currentClickObject.clickObject.DisplayRect.width += Math.round(moveVector.x);
            currentClickObject.clickObject.DisplayRect.height += Math.round(moveVector.y);

            if (currentClickObject.clickObject.DisplayRect.width < 15) currentClickObject.clickObject.DisplayRect.width = 15;
            if (currentClickObject.clickObject.DisplayRect.height < 15) currentClickObject.clickObject.DisplayRect.height = 15;
        }
        this.setSelectedItemInfo();

        var rect = currentClickObject.clickRect;
        if (rect) this.drawCoordinateLine({
            x: rect.left + rect.width,
            y: rect.top + rect.height
        });
    },

    setSelectedItemSize: function (size) {
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject && currentClickObject.clickObject && currentClickObject.clickObject.DisplayRect) {
            currentClickObject.clickObject.DisplayRect.width = size.width;
            currentClickObject.clickObject.DisplayRect.height = size.height;

            if (currentClickObject.clickObject.DisplayRect.width < 15) currentClickObject.clickObject.DisplayRect.width = 15;
            if (currentClickObject.clickObject.DisplayRect.height < 15) currentClickObject.clickObject.DisplayRect.height = 15;
        }
        this.setSelectedItemInfo();

        var rect = currentClickObject.clickRect;
        if (rect) this.drawCoordinateLine({
            x: rect.left + rect.width,
            y: rect.top + rect.height
        });
    },

    addPage: function (page) {
        if (this.ifHasPageNo(page.PageNo)) {
            $.messager.alert("提示", "第" + page.PageNo + "页已存在，请输入新的页码!!");
            return;
        }
        var newPage = clone(page, new WeakMap());
        newPage.Images = [];
        newPage.Titles = [];
        newPage.Areas = [];
        newPage.Tables = [];
        newPage.ComplexTables = [];
        this.sheet.Pages.push(newPage);
    },

    addImage: function (image, location) {
        var newImage = clone(image, new WeakMap());
        newImage.DisplayRect.left = Math.round(location.x);
        newImage.DisplayRect.top = Math.round(location.y);
        newImage.DisplayRect.width = 60;
        newImage.DisplayRect.height = 60;
        this.clickInfo.page.Images.push(newImage);
        return newImage;
    },

    addTitle: function (title, location) {
        var newTitle = clone(title, new WeakMap());
        newTitle.DisplayRect.left = Math.round(location.x);
        newTitle.DisplayRect.top = Math.round(location.y);
        newTitle.DisplayRect.width = 100;
        newTitle.DisplayRect.height = 50;
        this.clickInfo.page.Titles.push(newTitle);
        return newTitle;
    },

    addArea: function (area, location) {
        var newArea = clone(area, new WeakMap());
        newArea.DisplayRect.left = Math.round(location.x);
        newArea.DisplayRect.top = Math.round(location.y);
        newArea.DisplayRect.width = 50;
        newArea.DisplayRect.height = 50;
        newArea.AreaItems = [];
        this.clickInfo.page.Areas.push(newArea);
        return newArea;
    },

    addAreaItem: function (areaItem, location) {
        if (this.clickInfo.area) {
            var rect = this.clickInfo.area.DisplayRect;
            if ((location.x < rect.left || location.x > (rect.left + rect.width)) || (location.y < rect.top || location.y > (rect.top + rect.height))) {
                $.messager.alert("提示", "请在区域内绘制!!");
                return null;
            }

            var newAreaItem = clone(areaItem, new WeakMap());
            newAreaItem.DisplayRect.left = Math.round(location.x) - this.clickInfo.area.DisplayRect.left;
            newAreaItem.DisplayRect.top = Math.round(location.y) - this.clickInfo.area.DisplayRect.top;
            //newAreaItem.DisplayRect.width = 100;
            //newAreaItem.DisplayRect.height = 20;
            this.clickInfo.area.AreaItems.push(newAreaItem);
            return newAreaItem;
        } else {
            this.initAction();
            $.messager.alert("提示", "请选择一个区域!!");
            return null;
        }
    },

    addCellAreaItem: function (areaItem, location) {
        if (this.clickInfo.complexTable && this.clickInfo.complexTableCell) {
            var rect = this.getCurrentComplexCellRect();
            if ((location.x < rect.left || location.x > (rect.left + rect.width)) || (location.y < rect.top || location.y > (rect.top + rect.height))) {
                $.messager.alert("提示", "请在表格区域内绘制!!");
                return null;
            }

            var newAreaItem = clone(areaItem, new WeakMap());
            newAreaItem.DisplayRect.left = Math.round(location.x) - rect.left;
            newAreaItem.DisplayRect.top = Math.round(location.y) - rect.top;
            newAreaItem.DisplayRect.width = 100;
            newAreaItem.DisplayRect.height = 20;
            this.clickInfo.complexTableCell.AreaItems.push(newAreaItem);
            return newAreaItem;
        } else {
            this.initAction();
            $.messager.alert("提示", "请选择一个区域!!");
            return null;
        }
    },

    addTable: function (table, location) {
        var newTable = clone(table, new WeakMap());
        newTable.DisplayRect.left = Math.round(location.x);
        newTable.DisplayRect.top = Math.round(location.y);
        newTable.DisplayRect.width = 40;
        newTable.DisplayRect.height = 40;
        this.clickInfo.page.Tables.push(newTable);
        return newTable;
    },

    addComplexTable: function (complexTable, location) {
        var newComplexTable = clone(complexTable, new WeakMap());
        newComplexTable.DisplayRect.left = Math.round(location.x);
        newComplexTable.DisplayRect.top = Math.round(location.y);
        newComplexTable.DisplayRect.width = 40;
        newComplexTable.DisplayRect.height = 40;
        if(!this.clickInfo.page.ComplexTables) this.clickInfo.page.ComplexTables = [];
        this.clickInfo.page.ComplexTables.push(newComplexTable);
        return newComplexTable;
    },

    addLine: function (line, location) {
        var newLine = clone(line, new WeakMap());
        newLine.DisplayRect.left = Math.round(location.x);
        newLine.DisplayRect.top = Math.round(location.y);
        newLine.DisplayRect.width = 40;
        newLine.DisplayRect.height = 10;
        if (!this.clickInfo.page.Lines) this.clickInfo.page.Lines = [];
        this.clickInfo.page.Lines.push(newLine);
        return newLine;
    },

    addDrawingItem: function (location) {
        if (this.drawingContext.drawingStatus == "DrawingTitle") {
            this.clickInfo.title = this.addTitle(this.drawingContext.drawingTitle, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingArea") {
            this.clickInfo.area = this.addArea(this.drawingContext.drawingArea, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingAreaItem" && this.clickInfo.area) {
            this.clickInfo.areaItem = this.addAreaItem(this.drawingContext.drawingAreaItem, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingAreaItem" && this.clickInfo.complexTable) {
            this.clickInfo.areaItem = this.addCellAreaItem(this.drawingContext.drawingAreaItem, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingImage") {
            this.clickInfo.image = this.addImage(this.drawingContext.drawingImage, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingTable") {
            this.clickInfo.table = this.addTable(this.drawingContext.drawingTable, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingComplexTable") {
            this.clickInfo.complexTable = this.addComplexTable(this.drawingContext.drawingComplexTable, location);
        }
        if (this.drawingContext.drawingStatus == "DrawingLine") {
            this.clickInfo.line = this.addLine(this.drawingContext.drawingLine, location);
        }
    },

    deletePage: function () {
        var index = this.sheet.Pages.indexOf(this.currentPage);
        if (index > -1) {
            this.sheet.Pages.splice(index, 1);
            this.currentPage = null;
        }
    },

    deleteAreaItem: function () {
        if (this.clickInfo.area) {
            var index = this.clickInfo.area.AreaItems.indexOf(this.clickInfo.areaItem);
            if (index > -1) {
                this.clickInfo.area.AreaItems.splice(index, 1);
                this.clickInfo.areaItem = null;
            }
        }
    },

    deleteCellAreaItem: function () {
        if (this.clickInfo.complexTableCell) {
            var index = this.clickInfo.complexTableCell.AreaItems.indexOf(this.clickInfo.areaItem);
            if (index > -1) {
                this.clickInfo.complexTableCell.AreaItems.splice(index, 1);
                this.clickInfo.areaItem = null;
            }
        }
    },

    deleteArea: function () {
        var index = this.clickInfo.page.Areas.indexOf(this.clickInfo.area);
        if (index > -1) {
            this.clickInfo.page.Areas.splice(index, 1);
            this.clickInfo.area = null;
            this.clickInfo.areaItem = null;
        }
    },

    deleteTitle: function () {
        var index = this.clickInfo.page.Titles.indexOf(this.clickInfo.title);
        if (index > -1) {
            this.clickInfo.page.Titles.splice(index, 1);
            this.clickInfo.title = null;
        }
    },

    deleteImage: function () {
        var index = this.clickInfo.page.Images.indexOf(this.clickInfo.image);
        if (index > -1) {
            this.clickInfo.page.Images.splice(index, 1);
            this.clickInfo.image = null;
        }
    },

    deleteTable: function () {
        var index = this.clickInfo.page.Tables.indexOf(this.clickInfo.table);
        if (index > -1) {
            this.clickInfo.page.Tables.splice(index, 1);
            this.clickInfo.table = null;
        }
    },

    deleteComplexTable: function () {
        var index = this.clickInfo.page.ComplexTables.indexOf(this.clickInfo.complexTable);
        if (index > -1) {
            this.clickInfo.page.ComplexTables.splice(index, 1);
            this.clickInfo.complexTable = null;
        }
    },

    deleteLine: function () {
        if (this.clickInfo.page.Lines) {
            var index = this.clickInfo.page.Lines.indexOf(this.clickInfo.line);
            if (index > -1) {
                this.clickInfo.page.Lines.splice(index, 1);
                this.clickInfo.line = null;
            }
        }
    },

    deleteSelectedItem: function () {
        if (this.clickInfo.line) {
            this.deleteLine();
        } else if (this.clickInfo.image) {
            this.deleteImage();
        } else if (this.clickInfo.table) {
            this.deleteTable();
        } else if (this.clickInfo.areaItem && this.clickInfo.complexTable && this.clickInfo.complexTableCell) {
            this.deleteCellAreaItem();
        } else if (this.clickInfo.complexTable) {
            this.deleteComplexTable();
        } else if (this.clickInfo.areaItem && this.clickInfo.area) {
            this.deleteAreaItem();
        } else if (this.clickInfo.area) {
            this.deleteArea();
        } else if (this.clickInfo.title) {
            this.deleteTitle();
        }

        this.clearDrawingContext();
        this.setSelectedItemInfo();
    },

    clearDrawingContext: function () {
        this.drawingContext = {
            drawingStatus: null,
            drawingImage: null,
            drawingTitle: null,
            drawingArea: null,
            drawingAreaItem: null,
            drawingTable: null,
            drawingComplexTable: null,
            drawingLine: null
        };

        this.canvas.style.cursor = "default";
    },

    setDrawingContext: function (drawItem) {
        if (drawItem.type == "DrawingTitle") {
            this.drawingContext.drawingStatus = "DrawingTitle";
            this.drawingContext.drawingTitle = drawItem.value;
        }
        if (drawItem.type == "DrawingArea") {
            this.drawingContext.drawingStatus = "DrawingArea";
            this.drawingContext.drawingArea = drawItem.value;
        }
        if (drawItem.type == "DrawingAreaItem") {
            this.drawingContext.drawingStatus = "DrawingAreaItem";
            this.drawingContext.drawingAreaItem = drawItem.value;
        }
        if (drawItem.type == "DrawingImage") {
            this.drawingContext.drawingStatus = "DrawingImage";
            this.drawingContext.drawingImage = drawItem.value;
        }
        if (drawItem.type == "DrawingTable") {
            this.drawingContext.drawingStatus = "DrawingTable";
            this.drawingContext.drawingTable = drawItem.value;
        }
        if (drawItem.type == "DrawingComplexTable") {
            this.drawingContext.drawingStatus = "DrawingComplexTable";
            this.drawingContext.drawingComplexTable = drawItem.value;
        }
        if (drawItem.type == "DrawingLine") {
            this.drawingContext.drawingStatus = "DrawingLine";
            this.drawingContext.drawingLine = drawItem.value;
        }
        this.canvas.style.cursor = "crosshair";
    },

    setClickedItemAlign: function () {
        var currentClickObject = this.getCurrentClickObject();
        var factor = 5;
        if (currentClickObject && currentClickObject.clickObject && currentClickObject.clickObject.DisplayRect) {
            currentClickObject.clickObject.DisplayRect.left = Math.round(currentClickObject.clickObject.DisplayRect.left / factor) * factor;
            currentClickObject.clickObject.DisplayRect.top = Math.round(currentClickObject.clickObject.DisplayRect.top / factor) * factor;
            currentClickObject.clickObject.DisplayRect.width = Math.round(currentClickObject.clickObject.DisplayRect.width / factor) * factor;
            currentClickObject.clickObject.DisplayRect.height = Math.round(currentClickObject.clickObject.DisplayRect.height / factor) * factor;
        }
    },

    /**
     * 响应鼠标事件
     */
    clearMouseStatus: function () {
        this.mouseStatus = {
            mouseDown: false,
            mouseUp: true,
            mouseLastLocation: {
                x: 0,
                y: 0
            },
            lastMouseDownLocation: {
                x: 0,
                y: 0
            }
        };
    },

    captureClick: function (location) {
        this.setClickInfo(location);
    },

    onMouseDown: function (location) {
        if (this.editMode) return;

        this.mouseStatus.mouseDown = true;
        this.mouseStatus.mouseUp = false;

        if (this.drawingContext.drawingStatus) {
            this.addDrawingItem(location);
        }

        this.setSelectedItemInfo();
        this.mouseStatus.lastMouseDownLocation = location;
    },

    onMouseUp: function (location) {
        if (this.editMode) return;

        this.mouseStatus.mouseDown = false;
        this.mouseStatus.mouseUp = true;

        if (this.drawingContext.drawingStatus) {
            this.clearDrawingContext();
        }

        this.operationRecord.push({
            type: "onMouseUp",
            location: location,
            content: "鼠标松开",
            page: JSON.stringify(this.currentPage)
        });

        this.drawPage();
        this.setSelectedItemInfo();
        this.mouseStatus.mouseLastLocation = location;
    },

    onMouseMove: function (location) {
        if (this.editMode) return;

        if (this.mouseStatus.mouseDown && !this.mouseStatus.mouseUp) {
            if (this.drawingContext.drawingStatus) {
                var size = {
                    width: location.x - this.mouseStatus.lastMouseDownLocation.x,
                    height: location.y - this.mouseStatus.lastMouseDownLocation.y
                };
                this.setSelectedItemSize(size);
            } else {
                var moveVector = {
                    x: (location.x - this.mouseStatus.mouseLastLocation.x),
                    y: (location.y - this.mouseStatus.mouseLastLocation.y)
                };
                if (this.clickInfo.isClickResizeBlock) {
                    this.resizeSelectedItem(moveVector);
                } else {
                    if (this.multSelectedAreaItems && this.multSelectedAreaItems.length > 0) {
                        this.moveMultSelectedAreaItems(moveVector);
                    } else {
                        this.moveSelectedItem(moveVector);
                    }
                }
            }
        }

        this.mouseStatus.mouseLastLocation = location;
    },

    undoOperation: function () {
        this.operationRecord.pop();
        var len = this.operationRecord.length
        if (len > 0) {
            var latestOperation = this.operationRecord[len - 1];
            var nowPage = JSON.parse(latestOperation.page);
            var index = this.getPageIndex();
            this.sheet.Pages[index] = nowPage;
            this.currentPage = nowPage;
            this.clearClickInfo();
            this.drawPage();
        }
    },

    getTooltipInfo: function () {
        var result = "";
        var currentClickObject = this.getCurrentClickObject();
        if (currentClickObject && this.mouseStatus.mouseDown) {
            var rect = currentClickObject.clickRect;
            if (rect) {
                var left = rect.left,
                    top = rect.top;
                if (currentClickObject.clickObjectType == "AreaItem") {
                    left = currentClickObject.clickRelativeRect.left, top = currentClickObject.clickRelativeRect.top;
                }
                result = "left: " + Math.round(left) + ",  top: " + Math.round(top) + ",<span style='color:yellow;'>WASD键上下左右移动</span>";
                if (this.clickInfo.isClickResizeBlock) {
                    result = "width: " + Math.round(rect.width) + ",  height: " + Math.round(rect.height) + ",<span style='color:yellow;'>上下左右键可以调整高度和宽度</span>";
                }
            }
        }
        return result;
    },

    getMenuList: function(){
        var $this = this;
        var menuList = [];
        var curClickObject = this.getCurrentClickObject();
        if(curClickObject && curClickObject.clickObjectType != "Page"){
            menuList.push({
                text: "删除",
                onMenuClick: function(e){
                    $this.deleteSelectedItem();
                }
            });
        }

        return menuList;
    },

    print: function(){
        
    }
}

function clone(obj, hash) {
    // 解决循环引用
    if (hash.has(obj)) {
        return hash.get(obj)
    }
    var temp = null;
    if (obj instanceof Array) {
        // 特殊处理数组对象类型
        temp = [];
        hash.set(obj, temp);
        Object.keys(obj).forEach(function (key) {
            var item = obj[key];
            temp.push(clone(item, hash));
        });
    } else if (obj instanceof Date) {
        // 特殊处理时间对象类型
        temp = new Date(obj.getTime());
    } else if (typeof obj === 'object') {
        // 处理普通对象类型
        // 以obj的原型为原型，构造一个新对象
        temp = Object.create(obj.__proto__);
        hash.set(obj, temp)
    } else {
        temp = obj;
    }
    // 任何对象类型，都遍历递归自身的属性
    if (typeof obj === 'object') {
        Object.keys(obj).forEach(function (key) {
            var val = obj[key];
            temp[key] = clone(val, hash);
        });
    }
    return temp;
}

if (typeof module === 'object' && module.exports) {
    module.exports = DisplaySheet;
}