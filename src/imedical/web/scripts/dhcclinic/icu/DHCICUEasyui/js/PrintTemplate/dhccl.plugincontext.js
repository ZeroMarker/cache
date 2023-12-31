function PluginContext(opts) {
    this.plugin = opts.plugin;
}

PluginContext.prototype.drawLine = function (startPos, endPos, strokeStyle, lineWidth, lineCap) {
    this.plugin.addPrintLine(startPos.y, startPos.x, endPos.y, endPos.x, strokeStyle, 1)
};

PluginContext.prototype.drawDashLine = function (startPos, endPos, strokeStyle, lineDash, lineWidth, lineCap) {

};

PluginContext.prototype.drawRectangle = function (rect, strokeStyle, lineDash) {
    this.plugin.addPrintRect(rect.top, rect.left, rect.width, rect.height, strokeStyle, 1);
};

PluginContext.prototype.fillRectangle = function (rect, fillStyle) {

};

PluginContext.prototype.drawString = function (text, startPos, fillStyle, fontStyle, baseline, direction, maxWidth) {
    var fontArr = fontStyle.split(" ");
    var fontSize = Number(fontArr[1].replace("px", ""));
    var fontWeight = fontArr[0];
    var fontName = fontArr[2];
    this.plugin.addPrintString(text, startPos.y, startPos.x, 0, 0, fillStyle, fontName, fontSize, fontWeight);
};

PluginContext.prototype.drawVerticalString = function (text, startPos, fillStyle, fontStyle, fontSize, baseline, direction) {

};

PluginContext.prototype.drawCircle = function (circle, strokeStyle, fillStyle) {

};

PluginContext.prototype.measureTextWidth = function (text, fillStyle, fontStyle, baseline) {

};

PluginContext.prototype.measureChineseWidth = function (text, fillStyle, fontStyle, baseline) {

};

PluginContext.prototype.clearRect = function (x, y, width, height) {

};

PluginContext.prototype.drawImage = function (img, left, top, width, height) {

};
