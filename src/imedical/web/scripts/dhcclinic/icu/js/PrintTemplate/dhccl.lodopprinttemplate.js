function LodopPrintTemplate(sheet, valueObject) {
    this.sheet = sheet;
    this.valueObject = valueObject;

    this.currentPage = sheet.Pages[0];
    this.lodop = getLodop();

    this.fontRatio = 0.68;

    this.offset = {
        x: 0,
        y: 0
    };

    this.ratio = {
        x: 1,
        y: 1
    };

    this.init();
}

LodopPrintTemplate.prototype = {
    constructor: LodopPrintTemplate,

    init: function () {
        this.lodop.PRINT_INIT(this.sheet.Code);
        this.lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
        this.lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    },

    printPreview: function () {
        this.printPages();
        this.lodop.PREVIEW();
    },

    printPages: function () {
        for (var i = 0; i < this.sheet.Pages.length; i++) {
            if (i > 0) {
                this.lodop.NEWPAGE();
            }

            this.currentPage = this.sheet.Pages[i];

            this.printTitles();
            this.printAreas();

            this.printImages();
        }
    },

    printImages: function () {
        for (var i = 0; i < this.currentPage.Images.length; i++) {
            var image = this.currentPage.Images[i];
            this.printImage(image.URL, image.DisplayRect);
        }
    },

    printTitles: function () {
        for (var i = 0; i < this.currentPage.Titles.length; i++) {
            this.printTitle(this.currentPage.Titles[i]);
        }
    },

    printTitle: function (title) {
        var rect = title.DisplayRect;
        var fontSize = title.FontStyle.FontSize;

        if (title.BorderStyle && title.BorderStyle.BorderLine) {
            var borderColor = title.BorderStyle.LineColor;
            this.printRect(rect, borderColor);
        }

        var textWidth = this.measureTextWidth(title.Desc, fontSize) * 1.2;
        var textHeight = fontSize;
        var textRect = {
            left: rect.left + Math.round((rect.width - textWidth) / 2),
            top: rect.top + Math.round((rect.height - textHeight) / 2),
            width: textWidth,
            height: textHeight
        };
        this.printText(title.Desc, textRect, fontSize, title.FontStyle.FontName, title.FontStyle.FontColor, "middle");
    },

    printAreas: function () {
        for (var i = 0; i < this.currentPage.Areas.length; i++) {
            this.printArea(this.currentPage.Areas[i]);
        }
    },

    printArea: function (area) {
        var rect = area.DisplayRect;
        if (area.BorderStyle && area.BorderStyle.BorderLine) {
            var borderColor = area.BorderStyle.LineColor;
            this.printRect(rect, borderColor);
        }
        if (area.AreaItems) {
            for (var i = 0; i < area.AreaItems.length; i++) {
                this.printAreaItem(area.AreaItems[i]);
            }
        }
    },

    printAreaItem: function (areaItem) {
        var type = areaItem.Type;
        switch (type) {
            case "textbox":
                this.printTextBoxAreaItem(areaItem);
                break;
            case "checkbox":
                this.printCheckBoxAreaItem(areaItem);
                break;
            default:
                break;
        }
    },

    printTextBoxAreaItem: function (areaItem) {
        var rect = areaItem.DisplayRect;
        var fontSize = areaItem.FontStyle.FontSize;

        var textWidth = this.measureTextWidth(areaItem.Desc, fontSize);
        var textHeight = fontSize;
        this.printText(areaItem.Desc, rect, fontSize, areaItem.FontStyle.FontName, areaItem.FontStyle.FontColor);

        if (areaItem.UnderLine) {
            var startPos = {
                x: rect.left + textWidth,
                y: rect.top + textHeight
            };
            var endPos = {
                x: rect.left + rect.width,
                y: rect.top + textHeight
            };
            this.printLine(startPos, endPos);
        }

        if (this.valueObject && this.valueObject[areaItem.Code]) {
            var valueRect = {
                left: rect.left + textWidth,
                top: rect.top,
                width: rect.width - textWidth,
                height: rect.height
            };
            var value = this.valueObject[areaItem.Code];
            var valueFontSize = areaItem.FontStyle.FontSize;
            var valueFontName = areaItem.FontStyle.FontName;
            var valueFontColor = areaItem.FontStyle.FontColor;
            if (areaItem.ValueStyle) {
                valueFontSize = areaItem.ValueStyle.FontSize;
                valueFontName = areaItem.ValueStyle.FontName;
                valueFontColor = areaItem.ValueStyle.FontColor;
            }
            this.printText(value, valueRect, valueFontSize, valueFontName, valueFontColor);
        }
    },

    printCheckBoxAreaItem: function (areaItem) {
        var rect = areaItem.DisplayRect;
        var fontSize = areaItem.FontStyle.FontSize;

        var textHeight = fontSize;
        var boxWidth = Math.round(textHeight * 0.8);
        var boxHeigth = boxWidth;
        var boxRect = {
            left: rect.left,
            top: rect.top + Math.round((textHeight - boxHeigth) / 2),
            width: boxWidth,
            height: boxHeigth
        };
        this.printRect(boxRect, areaItem.FontStyle.FontColor);

        var textRect = {
            left: rect.left + textHeight,
            top: rect.top,
            width: rect.width - textHeight,
            height: rect.width
        };
        this.printText(areaItem.Desc, textRect, fontSize, areaItem.FontStyle.FontName, areaItem.FontStyle.FontColor);

        if (this.valueObject && this.valueObject[areaItem.Code]) {
            var value = this.valueObject[areaItem.Code];
            if (value == "true" || value == true) {
                var valueFontSize = areaItem.FontStyle.FontSize;
                var valueFontName = areaItem.FontStyle.FontName;
                var valueFontColor = areaItem.FontStyle.FontColor;
                if (areaItem.ValueStyle) {
                    valueFontSize = areaItem.ValueStyle.FontSize;
                    valueFontName = areaItem.ValueStyle.FontName;
                    valueFontColor = areaItem.ValueStyle.FontColor;
                }
                this.printText("√", boxRect, valueFontSize, valueFontName, valueFontColor);
            }
        }
    },

    printText: function (text, rect, fontSize, fontName, fontColor, baseLine) {
        fontSize = fontSize * this.fontRatio;

        var top = rect.top * this.ratio.y;
        var left = rect.left * this.ratio.x;
        var width = rect.width * this.ratio.x;
        var height = rect.height * this.ratio.y;
        this.lodop.ADD_PRINT_TEXT(top, left, width, height, text);

        this.lodop.SET_PRINT_STYLEA(0, "FontSize", fontSize);
        this.lodop.SET_PRINT_STYLEA(0, "FontName", fontName);
        this.lodop.SET_PRINT_STYLEA(0, "FontColor", fontColor);
    },

    printRect: function (rect, borderColor) {
        var top = rect.top * this.ratio.y;
        var left = rect.left * this.ratio.x;
        var width = rect.width * this.ratio.x;
        var height = rect.height * this.ratio.y;
        this.lodop.ADD_PRINT_SHAPE(2, top, left, width, height, 0, 1, borderColor);
    },

    printLine: function (startPos, endPos) {
        var startPosY = startPos.y * this.ratio.y;
        var startPosX = startPos.x * this.ratio.x;
        var endPosY = endPos.y * this.ratio.y;
        var endPosX = endPos.x * this.ratio.x;
        this.lodop.ADD_PRINT_LINE(startPosY, startPosX, endPosY, endPosX, 0, 1);
    },

    printImage: function (src, rect) {
        var strHtmlContent = "<img src='" + src + "'/>";
        this.lodop.ADD_PRINT_IMAGE(rect.top, rect.left, rect.width, rect.height, strHtmlContent);
        this.lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
    },

    measureTextWidth: function (text, fontSize) {
        var textWidth = fontSize * text.length * 1.1;
        return textWidth;
    }

}
