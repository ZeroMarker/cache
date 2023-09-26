


function HTMLArea() {}

HTMLArea.prototype.forceRedraw = function() {
this._doc.body.style.visibility = "hidden";
this._doc.body.style.visibility = "visible";
};


HTMLArea.prototype.focusEditor = function() {
window.focus();
return this._doc;
};





HTMLArea.prototype.getParentElement = function() {
var sel = this._getSelection();
var range = this._createRange(sel);
if (HTMLArea.is_ie) {
switch (sel.type) {
case "Text":
case "None":
return range.parentElement();
case "Control":
return range.item(0);
default:
return this._doc.body;
}
} else try {
var p = range.commonAncestorContainer;
if (!range.collapsed && range.startContainer == range.endContainer &&
range.startOffset - range.endOffset <= 1 && range.startContainer.hasChildNodes())
p = range.startContainer.childNodes[range.startOffset];
while (p.nodeType == 3) {
p = p.parentNode;
}
return p;
} catch (e) {
return null;
}
};


HTMLArea.prototype.getAllAncestors = function() {
var p = this.getParentElement();
var a = [];
while (p && (p.nodeType == 1) && (p.tagName.toLowerCase() != 'body')) {
a.push(p);
p = p.parentNode;
}
a.push(this._doc.body);
return a;
};


HTMLArea.prototype.selectNodeContents = function(node, pos) {
this.focusEditor();
this.forceRedraw();
var range;
var collapsed = (typeof pos != "undefined");
if (HTMLArea.is_ie) {
range = this._doc.body.createTextRange();
range.moveToElementText(node);
(collapsed) && range.collapse(pos);
range.select();
} else {
var sel = this._getSelection();
range = this._doc.createRange();
range.selectNodeContents(node);
(collapsed) && range.collapse(pos);
sel.removeAllRanges();
sel.addRange(range);
}
};


HTMLArea.prototype._getSelection = function() {
if (HTMLArea.is_ie) {
return this._doc.selection;
} else {
return this._iframe.contentWindow.getSelection();
}
};


HTMLArea.prototype._createRange = function(sel) {
if (HTMLArea.is_ie) {
return sel.createRange();
} else {
this.focusEditor();
if (typeof sel != "undefined") {
try {
return sel.getRangeAt(0);
} catch(e) {
return this._doc.createRange();
}
} else {
return this._doc.createRange();
}
}
};

HTMLArea.agt = navigator.userAgent.toLowerCase();
HTMLArea.is_ie	   = ((HTMLArea.agt.indexOf("msie") != -1) && (HTMLArea.agt.indexOf("opera") == -1));
HTMLArea.is_opera  = (HTMLArea.agt.indexOf("opera") != -1);
HTMLArea.is_mac	   = (HTMLArea.agt.indexOf("mac") != -1);
HTMLArea.is_mac_ie = (HTMLArea.is_ie && HTMLArea.is_mac);
HTMLArea.is_win_ie = (HTMLArea.is_ie && !HTMLArea.is_mac);
HTMLArea.is_gecko  = (navigator.product == "Gecko");




