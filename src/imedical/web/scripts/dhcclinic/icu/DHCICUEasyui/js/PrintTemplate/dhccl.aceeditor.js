/**
 * JS代码编辑框
 * dhccl.aceeditor.js
 */

function AceEditor(opt) {
    this.options = $.extend({}, opt, {
        width: 550,
        height: 600
    });

    this.onSave = opt.onSave;
    this.value = opt.value;

    this.init();
}

AceEditor.prototype = {
    constructor: AceEditor,

    init: function () {
        this.dom = $("<div></div>").appendTo("body");
        this.render();
    },

    render: function () {
        var $this = this;

        var buttons = $("<div></div>");

        var btnSave = $('<a href="#"></a>').linkbutton({
            text: '确定',
            iconCls: 'icon-save',
            onClick: function () {
                if ($this.validate()) {
                    $this.save();
                    $this.close();
                }
            }
        }).appendTo(buttons);

        var btnCancel = $('<a href="#"></a>').linkbutton({
            text: '关闭',
            iconCls: 'icon-cancel',
            onClick: function () {
                $this.close();
            }
        }).appendTo(buttons);

        this.dlg = this.dom.dialog({
            width: $this.options.width,
            height: $this.options.height,
            title: "JS脚本编辑器",
            modal: true,
            closed: true,
            buttons: buttons,
            onClose: function () {
                $this.close();
            }
        });

        this.container = $("<div id='aceEditor'></div>");
        this.container.css({
            width: 510,
            height: 1000,
            border: "1px solid #ccc",
            margin: 10
        });

        this.textArea = $("<textarea id='CodeMirror'></textarea>").appendTo(this.container);
        this.textArea.css({
            "width": 505,
            "height": 995,
            "background-color": "black"
        });

        this.dlg.dialog({
            content: $this.container
        });

    },

    open: function () {
        this.dlg.dialog("open");
        this.dlg.dialog("center");

        this.codeMirrorEditor = CodeMirror.fromTextArea(document.getElementById('CodeMirror'), {
            value: "",
            mode: "javascript",
            height: 995,
            lineNumbers: true,
            theme: "monokai"
        });

        this.setValue(this.value);
    },

    close: function () {
        this.container.remove();
        this.dlg.dialog("close");
        this.dlg.dialog("destroy");
    },

    setValue: function (val) {
        this.codeMirrorEditor.setValue(val);
    },

    getValue: function () {
        return this.codeMirrorEditor.getValue();
    },

    validate: function () {
        return true;
    },

    save: function () {
        var val = this.getValue();
        if (this.onSave) {
            this.onSave(val);
        }
    }
}

function Base64() {

    this._keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    this.encode = function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        input = _utf8_encode(input);
        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
        }
        return output;
    }

    this.decode = function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        while (i < input.length) {
            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = _utf8_decode(output);
        return output;
    }

    function _utf8_encode(string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }
        return utftext;
    }

    function _utf8_decode(utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while (i < utftext.length) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
    }

    function utf8ToUtf16(utf8Arr) {
        var utf16Str = '';

        for (var i = 0; i < utf8Arr.length; i++) {
            var one = utf8Arr[i].toString(2);
            var v = one.match(/^1+?(?=0)/);
            if (v && one.length == 8) {
                var bytesLength = v[0].length;
                var store = utf8Arr[i].toString(2).slice(7 - bytesLength);
                for (var st = 1; st < bytesLength; st++) {
                    store += utf8Arr[st + i].toString(2).slice(2)
                }

                utf16Str += String.fromCharCode(parseInt(store, 2));

                i += bytesLength - 1
            } else {
                utf16Str += String.fromCharCode(utf8Arr[i])
            }
        }

        return utf16Str
    }

    function utf16ToUtf8(utf16Str) {
        var utf8Arr = [];
        var byteSize = 0;
        for (var i = 0; i < utf16Str.length; i++) {
            var code = utf16Str.charCodeAt(i);

            if (code >= 0x00 && code <= 0x7f) {
                byteSize += 1;
                utf8Arr.push(code);
            } else if (code >= 0x80 && code <= 0x7ff) {
                byteSize += 2;
                utf8Arr.push((192 | (31 & (code >> 6))));
                utf8Arr.push((128 | (63 & code)))
            } else if ((code >= 0x800 && code <= 0xd7ff)
                || (code >= 0xe000 && code <= 0xffff)) {
                byteSize += 3;
                utf8Arr.push((224 | (15 & (code >> 12))));
                utf8Arr.push((128 | (63 & (code >> 6))));
                utf8Arr.push((128 | (63 & code)))
            } else if(code >= 0x10000 && code <= 0x10ffff ){
                byteSize += 4;
                utf8Arr.push((240 | (7 & (code >> 18))));
                utf8Arr.push((128 | (63 & (code >> 12))));
                utf8Arr.push((128 | (63 & (code >> 6))));
                utf8Arr.push((128 | (63 & code)))
            }
        }

        return utf8Arr
    }
}