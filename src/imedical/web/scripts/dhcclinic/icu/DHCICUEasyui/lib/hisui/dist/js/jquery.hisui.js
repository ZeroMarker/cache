if (typeof JSON !== "object") {
    JSON = {};
}

(function() {
    "use strict";
    function f(e) {
        return e < 10 ? "0" + e : e;
    }
    if (typeof Date.prototype.toJSON !== "function") {
        Date.prototype.toJSON = function() {
            return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null;
        };
        String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function() {
            return this.valueOf();
        };
    }
    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, gap, indent, meta = {
        "\b": "\\b",
        "\t": "\\t",
        "\n": "\\n",
        "\f": "\\f",
        "\r": "\\r",
        '"': '\\"',
        "\\": "\\\\"
    }, rep;
    function quote(e) {
        escapable.lastIndex = 0;
        return escapable.test(e) ? '"' + e.replace(escapable, function(e) {
            var t = meta[e];
            return typeof t === "string" ? t : "\\u" + ("0000" + e.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + e + '"';
    }
    function str(e, t) {
        var a, i, n, r, o = gap, s, d = t[e];
        if (d && typeof d === "object" && typeof d.toJSON === "function") {
            d = d.toJSON(e);
        }
        if (typeof rep === "function") {
            d = rep.call(t, e, d);
        }
        switch (typeof d) {
          case "string":
            return quote(d);

          case "number":
            return isFinite(d) ? String(d) : "null";

          case "boolean":
          case "null":
            return String(d);

          case "object":
            if (!d) {
                return "null";
            }
            gap += indent;
            s = [];
            if (Object.prototype.toString.apply(d) === "[object Array]") {
                r = d.length;
                for (a = 0; a < r; a += 1) {
                    s[a] = str(a, d) || "null";
                }
                n = s.length === 0 ? "[]" : gap ? "[\n" + gap + s.join(",\n" + gap) + "\n" + o + "]" : "[" + s.join(",") + "]";
                gap = o;
                return n;
            }
            if (rep && typeof rep === "object") {
                r = rep.length;
                for (a = 0; a < r; a += 1) {
                    if (typeof rep[a] === "string") {
                        i = rep[a];
                        n = str(i, d);
                        if (n) {
                            s.push(quote(i) + (gap ? ": " : ":") + n);
                        }
                    }
                }
            } else {
                for (i in d) {
                    if (Object.prototype.hasOwnProperty.call(d, i)) {
                        n = str(i, d);
                        if (n) {
                            s.push(quote(i) + (gap ? ": " : ":") + n);
                        }
                    }
                }
            }
            n = s.length === 0 ? "{}" : gap ? "{\n" + gap + s.join(",\n" + gap) + "\n" + o + "}" : "{" + s.join(",") + "}";
            gap = o;
            return n;
        }
    }
    if (typeof JSON.stringify !== "function") {
        JSON.stringify = function(e, t, a) {
            var i;
            gap = "";
            indent = "";
            if (typeof a === "number") {
                for (i = 0; i < a; i += 1) {
                    indent += " ";
                }
            } else if (typeof a === "string") {
                indent = a;
            }
            rep = t;
            if (t && typeof t !== "function" && (typeof t !== "object" || typeof t.length !== "number")) {
                throw new Error("JSON.stringify");
            }
            return str("", {
                "": e
            });
        };
    }
    if (typeof JSON.parse !== "function") {
        JSON.parse = function(text, reviver) {
            var j;
            function walk(e, t) {
                var a, i, n = e[t];
                if (n && typeof n === "object") {
                    for (a in n) {
                        if (Object.prototype.hasOwnProperty.call(n, a)) {
                            i = walk(n, a);
                            if (i !== undefined) {
                                n[a] = i;
                            } else {
                                delete n[a];
                            }
                        }
                    }
                }
                return reviver.call(e, t, n);
            }
            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function(e) {
                    return "\\u" + ("0000" + e.charCodeAt(0).toString(16)).slice(-4);
                });
            }
            if (/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, "@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, "]").replace(/(?:^|:|,)(?:\s*\[)+/g, ""))) {
                j = eval("(" + text + ")");
                return typeof reviver === "function" ? walk({
                    "": j
                }, "") : j;
            }
            throw new SyntaxError("JSON.parse");
        };
    }
})();

(function(c) {
    c.hisui = {
        indexOfArray: function(e, t, a) {
            for (var i = 0, n = e.length; i < n; i++) {
                if (a == undefined) {
                    if (e[i] == t) {
                        return i;
                    }
                } else {
                    if (e[i][t] == a) {
                        return i;
                    }
                }
            }
            return -1;
        },
        removeArrayItem: function(e, t, a) {
            if (typeof t == "string") {
                for (var i = 0, n = e.length; i < n; i++) {
                    if (e[i][t] == a) {
                        e.splice(i, 1);
                        return;
                    }
                }
            } else {
                var r = this.indexOfArray(e, t);
                if (r != -1) {
                    e.splice(r, 1);
                }
            }
        },
        addArrayItem: function(e, t, a) {
            var i = this.indexOfArray(e, t, a ? a[t] : undefined);
            if (i == -1) {
                e.push(a ? a : t);
            } else {
                e[i] = a ? a : t;
            }
        },
        getArrayItem: function(e, t, a) {
            var i = this.indexOfArray(e, t, a);
            return i == -1 ? null : e[i];
        },
        forEach: function(e, t, a) {
            var i = [];
            for (var n = 0; n < e.length; n++) {
                i.push(e[n]);
            }
            while (i.length) {
                var r = i.shift();
                if (a(r) == false) {
                    return;
                }
                if (t && r.children) {
                    for (var n = r.children.length - 1; n >= 0; n--) {
                        i.unshift(r.children[n]);
                    }
                }
            }
        },
        debounce: function(i, n, r) {
            var o, s;
            var e = function() {
                var e = this;
                var t = arguments;
                if (o) clearTimeout(o);
                if (r) {
                    var a = !o;
                    o = setTimeout(function() {
                        o = null;
                    }, n);
                    if (a) s = i.apply(e, t);
                } else {
                    o = setTimeout(function() {
                        i.apply(e, t);
                    }, n);
                }
                return s;
            };
            e.cancel = function() {
                clearTimeout(o);
                o = null;
            };
            return e;
        }
    };
    c.hisui.globalContainerId = "z-q-container";
    c.hisui.globalContainerSelector = "#" + c.hisui.globalContainerId;
    c.hisui.getLastSrcTargetDom = function() {
        return c.data(document.getElementById(c.hisui.globalContainerId), "data").srcTargetDom;
    };
    c.hisui.fixPanelTLWH = function() {
        var a = c.data(document.getElementById(c.hisui.globalContainerId), "data");
        var e = a.srcTargetDom;
        var t = c(e);
        var i = c(c.hisui.globalContainerSelector);
        var n = t.offset();
        i.offset({
            top: n.top + t._outerHeight(),
            left: n.left
        });
        (function() {
            if (i.is(":visible")) {
                var e = o();
                var t = r();
                if (Math.abs(e - i.offset().top) > 2 || Math.abs(t - i.offset().left) > 2) {
                    i.offset({
                        top: e,
                        left: t
                    });
                    clearTimeout(a.offsettimer);
                    a.offsettimer = null;
                }
                a.offsettimer = setTimeout(arguments.callee, 60);
            }
        })();
        function r() {
            var e = t.offset().left;
            if (e + i._outerWidth() > c(window)._outerWidth() + c(document).scrollLeft()) {
                e = c(window)._outerWidth() + c(document).scrollLeft() - i._outerWidth();
            }
            if (e < 0) {
                e = 0;
            }
            return e;
        }
        function o() {
            var e = t.offset().top + t._outerHeight();
            if (e + i._outerHeight() > c(window)._outerHeight() + c(document).scrollTop()) {
                e = t.offset().top - i._outerHeight();
            }
            if (e < c(document).scrollTop()) {
                e = t.offset().top + t._outerHeight();
            }
            e = parseInt(e);
            return e;
        }
    };
    c.parser = {
        auto: true,
        onComplete: function(e) {},
        plugins: [ "draggable", "droppable", "resizable", "pagination", "tooltip", "linkbutton", "menu", "menubutton", "splitbutton", "progressbar", "tree", "combobox", "combotree", "combogrid", "numberbox", "validatebox", "searchbox", "numberspinner", "timespinner", "calendar", "datebox", "datetimebox", "slider", "layout", "panel", "datagrid", "propertygrid", "treegrid", "tabs", "accordion", "window", "dialog", "checkbox", "radio", "switchbox", "keywords", "comboq", "lookup", "triggerbox", "dateboxq", "datetimeboxq" ],
        parse: function(i) {
            var n = [];
            for (var e = 0; e < c.parser.plugins.length; e++) {
                var t = c.parser.plugins[e];
                var a = c(".hisui-" + t, i);
                if (a.length) {
                    if (a[t]) {
                        a[t]();
                    } else {
                        n.push({
                            name: t,
                            jq: a
                        });
                    }
                }
            }
            if (n.length && window.easyloader) {
                var r = [];
                for (var e = 0; e < n.length; e++) {
                    r.push(n[e].name);
                }
                easyloader.load(r, function() {
                    for (var e = 0; e < n.length; e++) {
                        var t = n[e].name;
                        var a = n[e].jq;
                        a[t]();
                    }
                    c.parser.onComplete.call(c.parser, i);
                });
            } else {
                c.parser.onComplete.call(c.parser, i);
            }
        },
        parseValue: function(e, t, a, i) {
            i = i || 0;
            var n = c.trim(String(t || ""));
            var r = n.substr(n.length - 1, 1);
            if (r == "%") {
                n = parseFloat(n.substr(0, n.length - 1));
                if (e.toLowerCase().indexOf("width") >= 0) {
                    i += a[0].offsetWidth - a[0].clientWidth;
                    n = Math.floor((a.width() - i) * n / 100);
                } else {
                    i += a[0].offsetHeight - a[0].clientHeight;
                    n = Math.floor((a.height() - i) * n / 100);
                }
            } else {
                n = parseInt(n) || undefined;
            }
            return n;
        },
        parseOptions: function(e, t) {
            var a = c(e);
            var i = {};
            var n = c.trim(a.attr("data-options"));
            if (n) {
                if (n.substring(0, 1) != "{") {
                    n = "{" + n + "}";
                }
                i = new Function("return " + n)();
            }
            if (t) {
                var r = {};
                for (var o = 0; o < t.length; o++) {
                    var s = t[o];
                    if (typeof s == "string") {
                        if (s == "width" || s == "height" || s == "left" || s == "top") {
                            r[s] = parseInt(e.style[s]) || undefined;
                        } else {
                            r[s] = a.attr(s);
                        }
                    } else {
                        for (var d in s) {
                            var l = s[d];
                            if (l == "boolean") {
                                r[d] = a.attr(d) ? a.attr(d) == "true" : undefined;
                            } else {
                                if (l == "number") {
                                    r[d] = a.attr(d) == "0" ? 0 : parseFloat(a.attr(d)) || undefined;
                                }
                            }
                        }
                    }
                }
                c.extend(i, r);
            }
            return i;
        }
    };
    c(function() {
        var e = c('<div style="position:absolute;top:-1000px;width:100px;height:100px;padding:5px"></div>').appendTo("body");
        e.width(100);
        c._boxModel = parseInt(e.width()) == 100;
        e.remove();
        if (!window.easyloader && c.parser.auto) {
            c.parser.parse();
        }
    });
    c.fn._outerWidth = function(e) {
        if (e == undefined) {
            if (this[0] == window) {
                return this.width() || document.body.clientWidth;
            }
            return this.outerWidth() || 0;
        }
        return this.each(function() {
            if (c._boxModel) {
                c(this).width(e - (c(this).outerWidth() - c(this).width()));
            } else {
                c(this).width(e);
            }
        });
    };
    c.fn._outerHeight = function(e) {
        if (e == undefined) {
            if (this[0] == window) {
                return this.height() || document.body.clientHeight;
            }
            return this.outerHeight() || 0;
        }
        return this.each(function() {
            if (c._boxModel) {
                c(this).height(e - (c(this).outerHeight() - c(this).height()));
            } else {
                c(this).height(e);
            }
        });
    };
    c.fn._scrollLeft = function(e) {
        if (e == undefined) {
            return this.scrollLeft();
        } else {
            return this.each(function() {
                c(this).scrollLeft(e);
            });
        }
    };
    c.fn._propAttr = c.fn.prop || c.fn.attr;
    c.fn._fit = function(e) {
        e = e == undefined ? true : e;
        var t = this[0];
        var a = t.tagName == "BODY" ? t : this.parent()[0];
        var i = a.fcount || 0;
        if (e) {
            if (!t.fitted) {
                t.fitted = true;
                a.fcount = i + 1;
                c(a).addClass("panel-noscroll");
                if (a.tagName == "BODY") {
                    c("html").addClass("panel-fit");
                }
            }
        } else {
            if (t.fitted) {
                t.fitted = false;
                a.fcount = i - 1;
                if (a.fcount == 0) {
                    c(a).removeClass("panel-noscroll");
                    if (a.tagName == "BODY") {
                        c("html").removeClass("panel-fit");
                    }
                }
            }
        }
        return {
            width: c(a).width(),
            height: c(a).height()
        };
    };
})(jQuery);

(function(n) {
    var t = null;
    var e = null;
    var a = false;
    function i(e) {
        if (e.touches.length != 1) {
            return;
        }
        if (!a) {
            a = true;
            dblClickTimer = setTimeout(function() {
                a = false;
            }, 500);
        } else {
            clearTimeout(dblClickTimer);
            a = false;
            s(e, "dblclick");
        }
        t = setTimeout(function() {
            s(e, "contextmenu", 3);
        }, 1e3);
        s(e, "mousedown");
        if (n.fn.draggable.isDragging || n.fn.resizable.isResizing) {
            e.preventDefault();
        }
    }
    function r(e) {
        if (e.touches.length != 1) {
            return;
        }
        if (t) {
            clearTimeout(t);
        }
        s(e, "mousemove");
        if (n.fn.draggable.isDragging || n.fn.resizable.isResizing) {
            e.preventDefault();
        }
    }
    function o(e) {
        if (t) {
            clearTimeout(t);
        }
        s(e, "mouseup");
        if (n.fn.draggable.isDragging || n.fn.resizable.isResizing) {
            e.preventDefault();
        }
    }
    function s(e, t, a) {
        var i = new n.Event(t);
        i.pageX = e.changedTouches[0].pageX;
        i.pageY = e.changedTouches[0].pageY;
        i.which = a || 1;
        n(e.target).trigger(i);
    }
    if (document.addEventListener) {
        document.addEventListener("touchstart", i, true);
        document.addEventListener("touchmove", r, true);
        document.addEventListener("touchend", o, true);
    }
})(jQuery);

(function(c) {
    function r(e) {
        var t = c.data(e.data.target, "draggable");
        var a = t.options;
        var i = t.proxy;
        var n = e.data;
        var r = n.startLeft + e.pageX - n.startX;
        var o = n.startTop + e.pageY - n.startY;
        if (i) {
            if (i.parent()[0] == document.body) {
                if (a.deltaX != null && a.deltaX != undefined) {
                    r = e.pageX + a.deltaX;
                } else {
                    r = e.pageX - e.data.offsetWidth;
                }
                if (a.deltaY != null && a.deltaY != undefined) {
                    o = e.pageY + a.deltaY;
                } else {
                    o = e.pageY - e.data.offsetHeight;
                }
            } else {
                if (a.deltaX != null && a.deltaX != undefined) {
                    r += e.data.offsetWidth + a.deltaX;
                }
                if (a.deltaY != null && a.deltaY != undefined) {
                    o += e.data.offsetHeight + a.deltaY;
                }
            }
        }
        if (e.data.parent != document.body) {
            r += c(e.data.parent).scrollLeft();
            o += c(e.data.parent).scrollTop();
        }
        if (a.axis == "h") {
            n.left = r;
        } else {
            if (a.axis == "v") {
                n.top = o;
            } else {
                n.left = r;
                n.top = o;
            }
        }
    }
    function o(e) {
        var t = c.data(e.data.target, "draggable");
        var a = t.options;
        var i = t.proxy;
        if (!i) {
            i = c(e.data.target);
        }
        i.css({
            left: e.data.left,
            top: e.data.top
        });
        c("body").css("cursor", a.cursor);
    }
    function s(t) {
        if (!c.fn.draggable.isDragging) {
            return false;
        }
        var e = c.data(t.data.target, "draggable");
        var a = e.options;
        var i = c(".droppable:visible").filter(function() {
            return t.data.target != this;
        }).filter(function() {
            var e = c.data(this, "droppable").options.accept;
            if (e) {
                return c(e).filter(function() {
                    return this == t.data.target;
                }).length > 0;
            } else {
                return true;
            }
        });
        e.droppables = i;
        var n = e.proxy;
        if (!n) {
            if (a.proxy) {
                if (a.proxy == "clone") {
                    n = c(t.data.target).clone().insertAfter(t.data.target);
                } else {
                    n = a.proxy.call(t.data.target, t.data.target);
                }
                e.proxy = n;
            } else {
                n = c(t.data.target);
            }
        }
        n.css("position", "absolute");
        r(t);
        o(t);
        a.onStartDrag.call(t.data.target, t);
        return false;
    }
    function d(a) {
        if (!c.fn.draggable.isDragging) {
            return false;
        }
        var e = c.data(a.data.target, "draggable");
        r(a);
        if (e.options.onDrag.call(a.data.target, a) != false) {
            o(a);
        }
        var i = a.data.target;
        e.droppables.each(function() {
            var e = c(this);
            if (e.droppable("options").disabled) {
                return;
            }
            var t = e.offset();
            if (a.pageX > t.left && a.pageX < t.left + e.outerWidth() && a.pageY > t.top && a.pageY < t.top + e.outerHeight()) {
                if (!this.entered) {
                    c(this).trigger("_dragenter", [ i ]);
                    this.entered = true;
                }
                c(this).trigger("_dragover", [ i ]);
            } else {
                if (this.entered) {
                    c(this).trigger("_dragleave", [ i ]);
                    this.entered = false;
                }
            }
        });
        return false;
    }
    function l(i) {
        if (!c.fn.draggable.isDragging) {
            u();
            return false;
        }
        d(i);
        var e = c.data(i.data.target, "draggable");
        var t = e.proxy;
        var n = e.options;
        n.onEndDrag.call(i.data.target, i);
        if (n.revert) {
            if (s() == true) {
                c(i.data.target).css({
                    position: i.data.startPosition,
                    left: i.data.startLeft,
                    top: i.data.startTop
                });
            } else {
                if (t) {
                    var a, r;
                    if (t.parent()[0] == document.body) {
                        a = i.data.startX - i.data.offsetWidth;
                        r = i.data.startY - i.data.offsetHeight;
                    } else {
                        a = i.data.startLeft;
                        r = i.data.startTop;
                    }
                    t.animate({
                        left: a,
                        top: r
                    }, function() {
                        o();
                    });
                } else {
                    c(i.data.target).animate({
                        left: i.data.startLeft,
                        top: i.data.startTop
                    }, function() {
                        c(i.data.target).css("position", i.data.startPosition);
                    });
                }
            }
        } else {
            c(i.data.target).css({
                position: "absolute",
                left: i.data.left,
                top: i.data.top
            });
            s();
        }
        n.onStopDrag.call(i.data.target, i);
        u();
        function o() {
            if (t) {
                t.remove();
            }
            e.proxy = null;
        }
        function s() {
            var a = false;
            e.droppables.each(function() {
                var e = c(this);
                if (e.droppable("options").disabled) {
                    return;
                }
                var t = e.offset();
                if (i.pageX > t.left && i.pageX < t.left + e.outerWidth() && i.pageY > t.top && i.pageY < t.top + e.outerHeight()) {
                    if (n.revert) {
                        c(i.data.target).css({
                            position: i.data.startPosition,
                            left: i.data.startLeft,
                            top: i.data.startTop
                        });
                    }
                    c(this).triggerHandler("_drop", [ i.data.target ]);
                    o();
                    a = true;
                    this.entered = false;
                    return false;
                }
            });
            if (!a && !n.revert) {
                o();
            }
            return a;
        }
        return false;
    }
    function u() {
        if (c.fn.draggable.timer) {
            clearTimeout(c.fn.draggable.timer);
            c.fn.draggable.timer = undefined;
        }
        c(document).unbind(".draggable");
        c.fn.draggable.isDragging = false;
        setTimeout(function() {
            c("body").css("cursor", "");
        }, 100);
    }
    c.fn.draggable = function(i, e) {
        if (typeof i == "string") {
            return c.fn.draggable.methods[i](this, e);
        }
        return this.each(function() {
            var e;
            var t = c.data(this, "draggable");
            if (t) {
                t.handle.unbind(".draggable");
                e = c.extend(t.options, i);
            } else {
                e = c.extend({}, c.fn.draggable.defaults, c.fn.draggable.parseOptions(this), i || {});
            }
            var a = e.handle ? typeof e.handle == "string" ? c(e.handle, this) : e.handle : c(this);
            c.data(this, "draggable", {
                options: e,
                handle: a
            });
            if (e.disabled) {
                c(this).css("cursor", "");
                return;
            }
            a.unbind(".draggable").bind("mousemove.draggable", {
                target: this
            }, function(e) {
                if (c.fn.draggable.isDragging) {
                    return;
                }
                var t = c.data(e.data.target, "draggable").options;
                if (r(e)) {
                    c(this).css("cursor", t.cursor);
                } else {
                    c(this).css("cursor", "");
                }
            }).bind("mouseleave.draggable", {
                target: this
            }, function(e) {
                c(this).css("cursor", "");
            }).bind("mousedown.draggable", {
                target: this
            }, function(e) {
                if (r(e) == false) {
                    return;
                }
                c(this).css("cursor", "");
                var t = c(e.data.target).position();
                var a = c(e.data.target).offset();
                var i = {
                    startPosition: c(e.data.target).css("position"),
                    startLeft: t.left,
                    startTop: t.top,
                    left: t.left,
                    top: t.top,
                    startX: e.pageX,
                    startY: e.pageY,
                    width: c(e.data.target).outerWidth(),
                    height: c(e.data.target).outerHeight(),
                    offsetWidth: e.pageX - a.left,
                    offsetHeight: e.pageY - a.top,
                    target: e.data.target,
                    parent: c(e.data.target).parent()[0]
                };
                c.extend(e.data, i);
                var n = c.data(e.data.target, "draggable").options;
                if (n.onBeforeDrag.call(e.data.target, e) == false) {
                    return;
                }
                c(document).bind("mousedown.draggable", e.data, s);
                c(document).bind("mousemove.draggable", e.data, d);
                c(document).bind("mouseup.draggable", e.data, l);
                c.fn.draggable.timer = setTimeout(function() {
                    c.fn.draggable.isDragging = true;
                    s(e);
                }, n.delay);
                return false;
            });
            function r(e) {
                var t = c.data(e.data.target, "draggable");
                var a = t.handle;
                var i = c(a).offset();
                var n = c(a).outerWidth();
                var r = c(a).outerHeight();
                var o = e.pageY - i.top;
                var s = i.left + n - e.pageX;
                var d = i.top + r - e.pageY;
                var l = e.pageX - i.left;
                return Math.min(o, s, d, l) > t.options.edge;
            }
        });
    };
    c.fn.draggable.methods = {
        options: function(e) {
            return c.data(e[0], "draggable").options;
        },
        proxy: function(e) {
            return c.data(e[0], "draggable").proxy;
        },
        enable: function(e) {
            return e.each(function() {
                c(this).draggable({
                    disabled: false
                });
            });
        },
        disable: function(e) {
            return e.each(function() {
                c(this).draggable({
                    disabled: true
                });
            });
        }
    };
    c.fn.draggable.parseOptions = function(e) {
        var t = c(e);
        return c.extend({}, c.parser.parseOptions(e, [ "cursor", "handle", "axis", {
            revert: "boolean",
            deltaX: "number",
            deltaY: "number",
            edge: "number",
            delay: "number"
        } ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    c.fn.draggable.defaults = {
        proxy: null,
        revert: false,
        cursor: "move",
        deltaX: null,
        deltaY: null,
        handle: null,
        disabled: false,
        edge: 0,
        axis: null,
        delay: 100,
        onBeforeDrag: function(e) {},
        onStartDrag: function(e) {},
        onDrag: function(e) {},
        onEndDrag: function(e) {},
        onStopDrag: function(e) {}
    };
    c.fn.draggable.isDragging = false;
})(jQuery);

(function(i) {
    function a(a) {
        i(a).addClass("droppable");
        i(a).bind("_dragenter", function(e, t) {
            i.data(a, "droppable").options.onDragEnter.apply(a, [ e, t ]);
        });
        i(a).bind("_dragleave", function(e, t) {
            i.data(a, "droppable").options.onDragLeave.apply(a, [ e, t ]);
        });
        i(a).bind("_dragover", function(e, t) {
            i.data(a, "droppable").options.onDragOver.apply(a, [ e, t ]);
        });
        i(a).bind("_drop", function(e, t) {
            i.data(a, "droppable").options.onDrop.apply(a, [ e, t ]);
        });
    }
    i.fn.droppable = function(t, e) {
        if (typeof t == "string") {
            return i.fn.droppable.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = i.data(this, "droppable");
            if (e) {
                i.extend(e.options, t);
            } else {
                a(this);
                i.data(this, "droppable", {
                    options: i.extend({}, i.fn.droppable.defaults, i.fn.droppable.parseOptions(this), t)
                });
            }
        });
    };
    i.fn.droppable.methods = {
        options: function(e) {
            return i.data(e[0], "droppable").options;
        },
        enable: function(e) {
            return e.each(function() {
                i(this).droppable({
                    disabled: false
                });
            });
        },
        disable: function(e) {
            return e.each(function() {
                i(this).droppable({
                    disabled: true
                });
            });
        }
    };
    i.fn.droppable.parseOptions = function(e) {
        var t = i(e);
        return i.extend({}, i.parser.parseOptions(e, [ "accept" ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    i.fn.droppable.defaults = {
        accept: null,
        disabled: false,
        onDragEnter: function(e, t) {},
        onDragOver: function(e, t) {},
        onDragLeave: function(e, t) {},
        onDrop: function(e, t) {}
    };
})(jQuery);

(function(u) {
    u.fn.resizable = function(t, e) {
        if (typeof t == "string") {
            return u.fn.resizable.methods[t](this, e);
        }
        function a(e) {
            var t = e.data;
            var a = u.data(t.target, "resizable").options;
            if (t.dir.indexOf("e") != -1) {
                var i = t.startWidth + e.pageX - t.startX;
                i = Math.min(Math.max(i, a.minWidth), a.maxWidth);
                t.width = i;
            }
            if (t.dir.indexOf("s") != -1) {
                var n = t.startHeight + e.pageY - t.startY;
                n = Math.min(Math.max(n, a.minHeight), a.maxHeight);
                t.height = n;
            }
            if (t.dir.indexOf("w") != -1) {
                var i = t.startWidth - e.pageX + t.startX;
                i = Math.min(Math.max(i, a.minWidth), a.maxWidth);
                t.width = i;
                t.left = t.startLeft + t.startWidth - t.width;
            }
            if (t.dir.indexOf("n") != -1) {
                var n = t.startHeight - e.pageY + t.startY;
                n = Math.min(Math.max(n, a.minHeight), a.maxHeight);
                t.height = n;
                t.top = t.startTop + t.startHeight - t.height;
            }
        }
        function i(e) {
            var t = e.data;
            var a = u(t.target);
            a.css({
                left: t.left,
                top: t.top
            });
            if (a.outerWidth() != t.width) {
                a._outerWidth(t.width);
            }
            if (a.outerHeight() != t.height) {
                a._outerHeight(t.height);
            }
        }
        function r(e) {
            u.fn.resizable.isResizing = true;
            u.data(e.data.target, "resizable").options.onStartResize.call(e.data.target, e);
            return false;
        }
        function o(e) {
            a(e);
            if (u.data(e.data.target, "resizable").options.onResize.call(e.data.target, e) != false) {
                i(e);
            }
            return false;
        }
        function s(e) {
            u.fn.resizable.isResizing = false;
            a(e, true);
            i(e);
            u.data(e.data.target, "resizable").options.onStopResize.call(e.data.target, e);
            u(document).unbind(".resizable");
            u("body").css("cursor", "");
            return false;
        }
        return this.each(function() {
            var c = null;
            var e = u.data(this, "resizable");
            if (e) {
                u(this).unbind(".resizable");
                c = u.extend(e.options, t || {});
            } else {
                c = u.extend({}, u.fn.resizable.defaults, u.fn.resizable.parseOptions(this), t || {});
                u.data(this, "resizable", {
                    options: c
                });
            }
            if (c.disabled == true) {
                return;
            }
            u(this).bind("mousemove.resizable", {
                target: this
            }, function(e) {
                if (u.fn.resizable.isResizing) {
                    return;
                }
                var t = n(e);
                if (t == "") {
                    u(e.data.target).css("cursor", "");
                } else {
                    u(e.data.target).css("cursor", t + "-resize");
                }
            }).bind("mouseleave.resizable", {
                target: this
            }, function(e) {
                u(e.data.target).css("cursor", "");
            }).bind("mousedown.resizable", {
                target: this
            }, function(a) {
                var e = n(a);
                if (e == "") {
                    return;
                }
                function t(e) {
                    var t = parseInt(u(a.data.target).css(e));
                    if (isNaN(t)) {
                        return 0;
                    } else {
                        return t;
                    }
                }
                var i = {
                    target: a.data.target,
                    dir: e,
                    startLeft: t("left"),
                    startTop: t("top"),
                    left: t("left"),
                    top: t("top"),
                    startX: a.pageX,
                    startY: a.pageY,
                    startWidth: u(a.data.target).outerWidth(),
                    startHeight: u(a.data.target).outerHeight(),
                    width: u(a.data.target).outerWidth(),
                    height: u(a.data.target).outerHeight(),
                    deltaWidth: u(a.data.target).outerWidth() - u(a.data.target).width(),
                    deltaHeight: u(a.data.target).outerHeight() - u(a.data.target).height()
                };
                u(document).bind("mousedown.resizable", i, r);
                u(document).bind("mousemove.resizable", i, o);
                u(document).bind("mouseup.resizable", i, s);
                u("body").css("cursor", e + "-resize");
            });
            function n(e) {
                var t = u(e.data.target);
                var a = "";
                var i = t.offset();
                var n = t.outerWidth();
                var r = t.outerHeight();
                var o = c.edge;
                if (e.pageY > i.top && e.pageY < i.top + o) {
                    a += "n";
                } else {
                    if (e.pageY < i.top + r && e.pageY > i.top + r - o) {
                        a += "s";
                    }
                }
                if (e.pageX > i.left && e.pageX < i.left + o) {
                    a += "w";
                } else {
                    if (e.pageX < i.left + n && e.pageX > i.left + n - o) {
                        a += "e";
                    }
                }
                var s = c.handles.split(",");
                for (var d = 0; d < s.length; d++) {
                    var l = s[d].replace(/(^\s*)|(\s*$)/g, "");
                    if (l == "all" || l == a) {
                        return a;
                    }
                }
                return "";
            }
        });
    };
    u.fn.resizable.methods = {
        options: function(e) {
            return u.data(e[0], "resizable").options;
        },
        enable: function(e) {
            return e.each(function() {
                u(this).resizable({
                    disabled: false
                });
            });
        },
        disable: function(e) {
            return e.each(function() {
                u(this).resizable({
                    disabled: true
                });
            });
        }
    };
    u.fn.resizable.parseOptions = function(e) {
        var t = u(e);
        return u.extend({}, u.parser.parseOptions(e, [ "handles", {
            minWidth: "number",
            minHeight: "number",
            maxWidth: "number",
            maxHeight: "number",
            edge: "number"
        } ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    u.fn.resizable.defaults = {
        disabled: false,
        handles: "n, e, s, w, ne, se, sw, nw, all",
        minWidth: 10,
        minHeight: 10,
        maxWidth: 1e4,
        maxHeight: 1e4,
        edge: 5,
        onStartResize: function(e) {},
        onResize: function(e) {},
        onStopResize: function(e) {}
    };
    u.fn.resizable.isResizing = false;
})(jQuery);

(function(r) {
    function a(e) {
        var t = r.data(e, "linkbutton").options;
        var a = r(e).empty();
        a.addClass("l-btn").removeClass("l-btn-plain l-btn-selected l-btn-plain-selected");
        a.removeClass("l-btn-small l-btn-medium l-btn-large").addClass("l-btn-" + t.size);
        if (t.plain) {
            a.addClass("l-btn-plain");
        }
        if (t.selected) {
            a.addClass(t.plain ? "l-btn-selected l-btn-plain-selected" : "l-btn-selected");
        }
        a.attr("group", t.group || "");
        a.attr("id", t.id || "");
        var i = r('<span class="l-btn-left"></span>').appendTo(a);
        if (t.text) {
            r('<span class="l-btn-text"></span>').html(t.text).appendTo(i);
        } else {
            r('<span class="l-btn-text l-btn-empty">&nbsp;</span>').appendTo(i);
        }
        if (t.iconImg) {
            r('<span class="l-btn-icon" style="background-image:url(\'' + t.iconImg + "');background-position:center;background-repeat:no-repeat;\">&nbsp;</span>").appendTo(i);
            i.addClass("l-btn-icon-" + t.iconAlign);
        } else if (t.iconCls) {
            r('<span class="l-btn-icon">&nbsp;</span>').addClass(t.iconCls).appendTo(i);
            i.addClass("l-btn-icon-" + t.iconAlign);
        }
        a.unbind(".linkbutton").bind("focus.linkbutton", function() {
            if (!t.disabled) {
                r(this).addClass("l-btn-focus");
            }
        }).bind("blur.linkbutton", function() {
            r(this).removeClass("l-btn-focus");
        }).bind("click.linkbutton", function() {
            if (!t.disabled) {
                if (t.toggle) {
                    if (t.selected) {
                        r(this).linkbutton("unselect");
                    } else {
                        r(this).linkbutton("select");
                    }
                }
                t.onClick.call(this);
            }
            if (!a.hasClass("filebox-button")) return false;
        });
        a.children("span").unbind(".linkbutton").bind("click.linkbutton", function() {
            if (t.disabled && t.stopAllEventOnDisabled) {
                return false;
            } else {
                return true;
            }
        });
        n(e, t.selected);
        o(e, t.disabled);
    }
    function n(e, t) {
        var a = r.data(e, "linkbutton").options;
        if (t) {
            if (a.group) {
                r('a.l-btn[group="' + a.group + '"]').each(function() {
                    var e = r(this).linkbutton("options");
                    if (e.toggle) {
                        r(this).removeClass("l-btn-selected l-btn-plain-selected");
                        e.selected = false;
                    }
                });
            }
            r(e).addClass(a.plain ? "l-btn-selected l-btn-plain-selected" : "l-btn-selected");
            a.selected = true;
        } else {
            if (!a.group) {
                r(e).removeClass("l-btn-selected l-btn-plain-selected");
                a.selected = false;
            }
        }
    }
    function o(e, t) {
        var a = r.data(e, "linkbutton");
        var i = a.options;
        r(e).removeClass("l-btn-disabled l-btn-plain-disabled");
        if (t) {
            i.disabled = true;
            var n = r(e).attr("href");
            if (n) {
                a.href = n;
                r(e).attr("href", "javascript:void(0)");
            }
            if (e.onclick) {
                a.onclick = e.onclick;
                e.onclick = null;
            }
            i.plain ? r(e).addClass("l-btn-disabled l-btn-plain-disabled") : r(e).addClass("l-btn-disabled");
        } else {
            i.disabled = false;
            if (a.href) {
                r(e).attr("href", a.href);
            }
            if (a.onclick) {
                e.onclick = a.onclick;
            }
        }
    }
    r.fn.linkbutton = function(t, e) {
        if (typeof t == "string") {
            return r.fn.linkbutton.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = r.data(this, "linkbutton");
            if (e) {
                r.extend(e.options, t);
            } else {
                r.data(this, "linkbutton", {
                    options: r.extend({}, r.fn.linkbutton.defaults, r.fn.linkbutton.parseOptions(this), t)
                });
                r(this).removeAttr("disabled");
            }
            a(this);
        });
    };
    r.fn.linkbutton.methods = {
        options: function(e) {
            return r.data(e[0], "linkbutton").options;
        },
        enable: function(e) {
            return e.each(function() {
                o(this, false);
            });
        },
        disable: function(e) {
            return e.each(function() {
                o(this, true);
            });
        },
        select: function(e) {
            return e.each(function() {
                n(this, true);
            });
        },
        unselect: function(e) {
            return e.each(function() {
                n(this, false);
            });
        }
    };
    r.fn.linkbutton.parseOptions = function(e) {
        var t = r(e);
        return r.extend({}, r.parser.parseOptions(e, [ "id", "iconImg", "iconCls", "iconAlign", "group", "size", {
            plain: "boolean",
            toggle: "boolean",
            selected: "boolean"
        } ]), {
            disabled: t.attr("disabled") ? true : undefined,
            text: r.trim(t.html()),
            iconCls: t.attr("icon") || t.attr("iconCls")
        });
    };
    r.fn.linkbutton.defaults = {
        id: null,
        disabled: false,
        toggle: false,
        selected: false,
        group: null,
        plain: false,
        text: "",
        iconImg: null,
        iconCls: null,
        iconAlign: "left",
        size: "small",
        onClick: function() {},
        stopAllEventOnDisabled: false
    };
})(jQuery);

(function($) {
    function _81(_82) {
        var _83 = $.data(_82, "pagination");
        var _84 = _83.options;
        var bb = _83.bb = {};
        var _85 = $(_82).addClass("pagination").html('<table cellspacing="0" cellpadding="0" border="0"><tr></tr></table>');
        var tr = _85.find("tr");
        var aa = $.extend([], _84.layout);
        if (!_84.showPageList) {
            _86(aa, "list");
        }
        if (!_84.showRefresh) {
            _86(aa, "refresh");
        }
        if (aa[0] == "sep") {
            aa.shift();
        }
        if (aa[aa.length - 1] == "sep") {
            aa.pop();
        }
        for (var _87 = 0; _87 < aa.length; _87++) {
            var _88 = aa[_87];
            if (_88 == "list") {
                var ps = $('<select class="pagination-page-list"></select>');
                ps.bind("change", function() {
                    _84.pageSize = parseInt($(this).val());
                    _84.onChangePageSize.call(_82, _84.pageSize);
                    _8e(_82, _84.pageNumber);
                });
                for (var i = 0; i < _84.pageList.length; i++) {
                    $("<option></option>").text(_84.pageList[i]).appendTo(ps);
                }
                $("<td></td>").append(ps).appendTo(tr);
            } else {
                if (_88 == "sep") {
                    $('<td><div class="pagination-btn-separator"></div></td>').appendTo(tr);
                } else {
                    if (_88 == "first") {
                        bb.first = _89("first");
                    } else {
                        if (_88 == "prev") {
                            bb.prev = _89("prev");
                        } else {
                            if (_88 == "next") {
                                bb.next = _89("next");
                            } else {
                                if (_88 == "last") {
                                    bb.last = _89("last");
                                } else {
                                    if (_88 == "manual") {
                                        $('<span style="padding-left:6px;"></span>').html(_84.beforePageText).appendTo(tr).wrap("<td></td>");
                                        bb.num = $('<input class="pagination-num" type="text" value="1" size="2">').appendTo(tr).wrap("<td></td>");
                                        bb.num.unbind(".pagination").bind("keydown.pagination", function(e) {
                                            if (e.keyCode == 13) {
                                                var t = parseInt($(this).val()) || 1;
                                                _8e(_82, t);
                                                return false;
                                            }
                                        });
                                        bb.after = $('<span style="padding-right:6px;"></span>').appendTo(tr).wrap("<td></td>");
                                    } else {
                                        if (_88 == "refresh") {
                                            bb.refresh = _89("refresh");
                                        } else {
                                            if (_88 == "links") {
                                                $('<td class="pagination-links"></td>').appendTo(tr);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if (_84.buttons) {
            $('<td><div class="pagination-btn-separator"></div></td>').appendTo(tr);
            if ($.isArray(_84.buttons)) {
                for (var i = 0; i < _84.buttons.length; i++) {
                    var btn = _84.buttons[i];
                    if (btn == "-") {
                        $('<td><div class="pagination-btn-separator"></div></td>').appendTo(tr);
                    } else {
                        var td = $("<td></td>").appendTo(tr);
                        var a = $('<a href="javascript:void(0)"></a>').appendTo(td);
                        a[0].onclick = eval(btn.handler || function() {});
                        a.linkbutton($.extend({}, btn, {
                            plain: true
                        }));
                    }
                }
            } else {
                var td = $("<td></td>").appendTo(tr);
                $(_84.buttons).appendTo(td).show();
            }
        }
        $('<div class="pagination-info"></div>').appendTo(_85);
        $('<div style="clear:both;"></div>').appendTo(_85);
        function _89(e) {
            var t = _84.nav[e];
            var a = $('<a href="javascript:void(0)"></a>').appendTo(tr);
            a.wrap("<td></td>");
            a.linkbutton({
                iconCls: t.iconCls,
                plain: true
            }).unbind(".pagination").bind("click.pagination", function() {
                t.handler.call(_82);
            });
            return a;
        }
        function _86(e, t) {
            var a = $.inArray(t, e);
            if (a >= 0) {
                e.splice(a, 1);
            }
            return e;
        }
    }
    function _8e(e, t) {
        var a = $.data(e, "pagination").options;
        _92(e, {
            pageNumber: t
        });
        a.onSelectPage.call(e, a.pageNumber, a.pageSize);
    }
    function _92(t, e) {
        var a = $.data(t, "pagination");
        var i = a.options;
        var n = a.bb;
        $.extend(i, e || {});
        var r = $(t).find("select.pagination-page-list");
        if (r.length) {
            r.val(i.pageSize + "");
            i.pageSize = parseInt(r.val());
        }
        var o = Math.ceil(i.total / i.pageSize) || 1;
        if (i.pageNumber < 1) {
            i.pageNumber = 1;
        }
        if (i.pageNumber > o) {
            i.pageNumber = o;
        }
        if (n.num) {
            n.num.val(i.pageNumber);
        }
        if (n.after) {
            n.after.html(i.afterPageText.replace(/{pages}/, o));
        }
        var s = $(t).find("td.pagination-links");
        if (s.length) {
            s.empty();
            var d = i.pageNumber - Math.floor(i.links / 2);
            if (d < 1) {
                d = 1;
            }
            var l = d + i.links - 1;
            if (l > o) {
                l = o;
            }
            d = l - i.links + 1;
            if (d < 1) {
                d = 1;
            }
            for (var c = d; c <= l; c++) {
                var u = $('<a class="pagination-link" href="javascript:void(0)"></a>').appendTo(s);
                u.linkbutton({
                    plain: true,
                    text: c
                });
                if (c == i.pageNumber) {
                    u.linkbutton("select");
                } else {
                    u.unbind(".pagination").bind("click.pagination", {
                        pageNumber: c
                    }, function(e) {
                        _8e(t, e.data.pageNumber);
                    });
                }
            }
        }
        var f = i.displayMsg;
        f = f.replace(/{from}/, i.total == 0 ? 0 : i.pageSize * (i.pageNumber - 1) + 1);
        f = f.replace(/{to}/, Math.min(i.pageSize * i.pageNumber, i.total));
        f = f.replace(/{total}/, i.total);
        $(t).find("div.pagination-info").html(f);
        if (n.first) {
            n.first.linkbutton({
                disabled: i.pageNumber == 1
            });
        }
        if (n.prev) {
            n.prev.linkbutton({
                disabled: i.pageNumber == 1
            });
        }
        if (n.next) {
            n.next.linkbutton({
                disabled: i.pageNumber == o
            });
        }
        if (n.last) {
            n.last.linkbutton({
                disabled: i.pageNumber == o
            });
        }
        _9b(t, i.loading);
    }
    function _9b(e, t) {
        var a = $.data(e, "pagination");
        var i = a.options;
        i.loading = t;
        if (i.showRefresh && a.bb.refresh) {
            a.bb.refresh.linkbutton({
                iconCls: i.loading ? "pagination-loading" : "pagination-load"
            });
        }
    }
    $.fn.pagination = function(a, e) {
        if (typeof a == "string") {
            return $.fn.pagination.methods[a](this, e);
        }
        a = a || {};
        return this.each(function() {
            var e;
            var t = $.data(this, "pagination");
            if (t) {
                e = $.extend(t.options, a);
            } else {
                e = $.extend({}, $.fn.pagination.defaults, $.fn.pagination.parseOptions(this), a);
                $.data(this, "pagination", {
                    options: e
                });
            }
            _81(this);
            _92(this);
        });
    };
    $.fn.pagination.methods = {
        options: function(e) {
            return $.data(e[0], "pagination").options;
        },
        loading: function(e) {
            return e.each(function() {
                _9b(this, true);
            });
        },
        loaded: function(e) {
            return e.each(function() {
                _9b(this, false);
            });
        },
        refresh: function(e, t) {
            return e.each(function() {
                _92(this, t);
            });
        },
        select: function(e, t) {
            return e.each(function() {
                _8e(this, t);
            });
        }
    };
    $.fn.pagination.parseOptions = function(_a6) {
        var t = $(_a6);
        return $.extend({}, $.parser.parseOptions(_a6, [ {
            total: "number",
            pageSize: "number",
            pageNumber: "number",
            links: "number"
        }, {
            loading: "boolean",
            showPageList: "boolean",
            showRefresh: "boolean"
        } ]), {
            pageList: t.attr("pageList") ? eval(t.attr("pageList")) : undefined
        });
    };
    $.fn.pagination.defaults = {
        total: 1,
        pageSize: 10,
        pageNumber: 1,
        pageList: [ 10, 20, 30, 50 ],
        loading: false,
        buttons: null,
        showPageList: true,
        showRefresh: true,
        links: 10,
        layout: [ "list", "sep", "first", "prev", "sep", "manual", "sep", "next", "last", "sep", "refresh" ],
        onSelectPage: function(e, t) {},
        onBeforeRefresh: function(e, t) {},
        onRefresh: function(e, t) {},
        onChangePageSize: function(e) {},
        beforePageText: "Page",
        afterPageText: "of {pages}",
        displayMsg: "Displaying {from} to {to} of {total} items",
        nav: {
            first: {
                iconCls: "pagination-first",
                handler: function() {
                    var e = $(this).pagination("options");
                    if (e.pageNumber > 1) {
                        $(this).pagination("select", 1);
                    }
                }
            },
            prev: {
                iconCls: "pagination-prev",
                handler: function() {
                    var e = $(this).pagination("options");
                    if (e.pageNumber > 1) {
                        $(this).pagination("select", e.pageNumber - 1);
                    }
                }
            },
            next: {
                iconCls: "pagination-next",
                handler: function() {
                    var e = $(this).pagination("options");
                    var t = Math.ceil(e.total / e.pageSize);
                    if (e.pageNumber < t) {
                        $(this).pagination("select", e.pageNumber + 1);
                    }
                }
            },
            last: {
                iconCls: "pagination-last",
                handler: function() {
                    var e = $(this).pagination("options");
                    var t = Math.ceil(e.total / e.pageSize);
                    if (e.pageNumber < t) {
                        $(this).pagination("select", t);
                    }
                }
            },
            refresh: {
                iconCls: "pagination-refresh",
                handler: function() {
                    var e = $(this).pagination("options");
                    if (e.onBeforeRefresh.call(this, e.pageNumber, e.pageSize) != false) {
                        $(this).pagination("select", e.pageNumber);
                        e.onRefresh.call(this, e.pageNumber, e.pageSize);
                    }
                }
            }
        }
    };
})(jQuery);

(function(h) {
    function n(e) {
        var t = h(e);
        t.addClass("tree");
        return t;
    }
    function r(i) {
        var n = h.data(i, "tree").options;
        h(i).unbind().bind("mouseover", function(e) {
            var t = h(e.target);
            var a = t.closest("div.tree-node");
            if (!a.length) {
                return;
            }
            a.addClass("tree-node-hover");
            if (t.hasClass("tree-hit")) {
                if (t.hasClass("tree-expanded")) {
                    t.addClass("tree-expanded-hover");
                } else {
                    t.addClass("tree-collapsed-hover");
                }
            }
            e.stopPropagation();
        }).bind("mouseout", function(e) {
            var t = h(e.target);
            var a = t.closest("div.tree-node");
            if (!a.length) {
                return;
            }
            a.removeClass("tree-node-hover");
            if (t.hasClass("tree-hit")) {
                if (t.hasClass("tree-expanded")) {
                    t.removeClass("tree-expanded-hover");
                } else {
                    t.removeClass("tree-collapsed-hover");
                }
            }
            e.stopPropagation();
        }).bind("click", function(e) {
            var t = h(e.target);
            var a = t.closest("div.tree-node");
            if (!a.length) {
                return;
            }
            if (t.hasClass("tree-hit")) {
                c(i, a[0]);
                return false;
            } else {
                if (t.hasClass("tree-checkbox")) {
                    v(i, a[0], !t.hasClass("tree-checkbox1"));
                    return false;
                } else {
                    F(i, a[0]);
                    n.onClick.call(i, y(i, a[0]));
                }
            }
            e.stopPropagation();
        }).bind("dblclick", function(e) {
            var t = h(e.target).closest("div.tree-node");
            if (!t.length) {
                return;
            }
            F(i, t[0]);
            n.onDblClick.call(i, y(i, t[0]));
            e.stopPropagation();
        }).bind("contextmenu", function(e) {
            var t = h(e.target).closest("div.tree-node");
            if (!t.length) {
                return;
            }
            n.onContextMenu.call(i, e, y(i, t[0]));
            e.stopPropagation();
        });
    }
    function t(e) {
        var t = h.data(e, "tree").options;
        t.dnd = false;
        var a = h(e).find("div.tree-node");
        a.draggable("disable");
        a.css("cursor", "pointer");
    }
    function p(r) {
        var o = h.data(r, "tree");
        var s = o.options;
        var e = o.tree;
        o.disabledNodes = [];
        s.dnd = true;
        e.find("div.tree-node").draggable({
            disabled: false,
            revert: true,
            cursor: "pointer",
            proxy: function(e) {
                var t = h('<div class="tree-node-proxy"></div>').appendTo("body");
                t.html('<span class="tree-dnd-icon tree-dnd-no">&nbsp;</span>' + h(e).find(".tree-title").html());
                t.hide();
                return t;
            },
            deltaX: 15,
            deltaY: 15,
            onBeforeDrag: function(e) {
                if (s.onBeforeDrag.call(r, y(r, this)) == false) {
                    return false;
                }
                if (h(e.target).hasClass("tree-hit") || h(e.target).hasClass("tree-checkbox")) {
                    return false;
                }
                if (e.which != 1) {
                    return false;
                }
                h(this).next("ul").find("div.tree-node").droppable({
                    accept: "no-accept"
                });
                var t = h(this).find("span.tree-indent");
                if (t.length) {
                    e.data.offsetWidth -= t.length * t.width();
                }
            },
            onStartDrag: function() {
                h(this).draggable("proxy").css({
                    left: -1e4,
                    top: -1e4
                });
                s.onStartDrag.call(r, y(r, this));
                var e = y(r, this);
                if (e.id == undefined) {
                    e.id = "hisui_tree_node_id_temp";
                    x(r, e);
                }
                o.draggingNodeId = e.id;
            },
            onDrag: function(e) {
                var t = e.pageX, a = e.pageY, i = e.data.startX, n = e.data.startY;
                var r = Math.sqrt((t - i) * (t - i) + (a - n) * (a - n));
                if (r > 3) {
                    h(this).draggable("proxy").show();
                }
                this.pageY = e.pageY;
            },
            onStopDrag: function() {
                h(this).next("ul").find("div.tree-node").droppable({
                    accept: "div.tree-node"
                });
                for (var e = 0; e < o.disabledNodes.length; e++) {
                    h(o.disabledNodes[e]).droppable("enable");
                }
                o.disabledNodes = [];
                var t = H(r, o.draggingNodeId);
                if (t && t.id == "hisui_tree_node_id_temp") {
                    t.id = "";
                    x(r, t);
                }
                s.onStopDrag.call(r, t);
            }
        }).droppable({
            accept: "div.tree-node",
            onDragEnter: function(e, t) {
                if (s.onDragEnter.call(r, this, d(t)) == false) {
                    l(t, false);
                    h(this).removeClass("tree-node-append tree-node-top tree-node-bottom");
                    h(this).droppable("disable");
                    o.disabledNodes.push(this);
                }
            },
            onDragOver: function(e, t) {
                if (h(this).droppable("options").disabled) {
                    return;
                }
                var a = t.pageY;
                var i = h(this).offset().top;
                var n = i + h(this).outerHeight();
                l(t, true);
                h(this).removeClass("tree-node-append tree-node-top tree-node-bottom");
                if (a > i + (n - i) / 2) {
                    if (n - a < 5) {
                        h(this).addClass("tree-node-bottom");
                    } else {
                        h(this).addClass("tree-node-append");
                    }
                } else {
                    if (a - i < 5) {
                        h(this).addClass("tree-node-top");
                    } else {
                        h(this).addClass("tree-node-append");
                    }
                }
                if (s.onDragOver.call(r, this, d(t)) == false) {
                    l(t, false);
                    h(this).removeClass("tree-node-append tree-node-top tree-node-bottom");
                    h(this).droppable("disable");
                    o.disabledNodes.push(this);
                }
            },
            onDragLeave: function(e, t) {
                l(t, false);
                h(this).removeClass("tree-node-append tree-node-top tree-node-bottom");
                s.onDragLeave.call(r, this, d(t));
            },
            onDrop: function(e, t) {
                var a = this;
                var i, n;
                if (h(this).hasClass("tree-node-append")) {
                    i = c;
                    n = "append";
                } else {
                    i = u;
                    n = h(this).hasClass("tree-node-top") ? "top" : "bottom";
                }
                if (s.onBeforeDrop.call(r, a, d(t), n) == false) {
                    h(this).removeClass("tree-node-append tree-node-top tree-node-bottom");
                    return;
                }
                i(t, a, n);
                h(this).removeClass("tree-node-append tree-node-top tree-node-bottom");
            }
        });
        function d(e, t) {
            return h(e).closest("ul.tree").tree(t ? "pop" : "getData", e);
        }
        function l(e, t) {
            var a = h(e).draggable("proxy").find("span.tree-dnd-icon");
            a.removeClass("tree-dnd-yes tree-dnd-no").addClass(t ? "tree-dnd-yes" : "tree-dnd-no");
        }
        function c(t, a) {
            if (y(r, a).state == "closed") {
                f(r, a, function() {
                    e();
                });
            } else {
                e();
            }
            function e() {
                var e = d(t, true);
                h(r).tree("append", {
                    parent: a,
                    data: [ e ]
                });
                s.onDrop.call(r, a, e, "append");
            }
        }
        function u(e, t, a) {
            var i = {};
            if (a == "top") {
                i.before = t;
            } else {
                i.after = t;
            }
            var n = d(e, true);
            i.data = n;
            h(r).tree("insert", i);
            s.onDrop.call(r, t, n, a);
        }
    }
    function v(r, e, t) {
        var a = h.data(r, "tree").options;
        if (!a.checkbox) {
            return;
        }
        var i = y(r, e);
        if (a.onBeforeCheck.call(r, i, t) == false) {
            return;
        }
        var n = h(e);
        var o = n.find(".tree-checkbox");
        o.removeClass("tree-checkbox0 tree-checkbox1 tree-checkbox2");
        if (t) {
            o.addClass("tree-checkbox1");
        } else {
            o.addClass("tree-checkbox0");
        }
        if (a.cascadeCheck) {
            d(n);
            s(n);
        }
        a.onCheck.call(r, i, t);
        function s(e) {
            var t = e.next().find(".tree-checkbox");
            t.removeClass("tree-checkbox0 tree-checkbox1 tree-checkbox2");
            if (e.find(".tree-checkbox").hasClass("tree-checkbox1")) {
                t.addClass("tree-checkbox1");
            } else {
                t.addClass("tree-checkbox0");
            }
        }
        function d(e) {
            var t = L(r, e[0]);
            if (t) {
                var a = h(t.target).find(".tree-checkbox");
                a.removeClass("tree-checkbox0 tree-checkbox1 tree-checkbox2");
                if (i(e)) {
                    a.addClass("tree-checkbox1");
                } else {
                    if (n(e)) {
                        a.addClass("tree-checkbox0");
                    } else {
                        a.addClass("tree-checkbox2");
                    }
                }
                d(h(t.target));
            }
            function i(e) {
                var t = e.find(".tree-checkbox");
                if (t.hasClass("tree-checkbox0") || t.hasClass("tree-checkbox2")) {
                    return false;
                }
                var a = true;
                e.parent().siblings().each(function() {
                    if (!h(this).children("div.tree-node").children(".tree-checkbox").hasClass("tree-checkbox1")) {
                        a = false;
                    }
                });
                return a;
            }
            function n(e) {
                var t = e.find(".tree-checkbox");
                if (t.hasClass("tree-checkbox1") || t.hasClass("tree-checkbox2")) {
                    return false;
                }
                var a = true;
                e.parent().siblings().each(function() {
                    if (!h(this).children("div.tree-node").children(".tree-checkbox").hasClass("tree-checkbox0")) {
                        a = false;
                    }
                });
                return a;
            }
        }
    }
    function s(e, t) {
        var a = h.data(e, "tree").options;
        if (!a.checkbox) {
            return;
        }
        var i = h(t);
        if (k(e, t)) {
            var n = i.find(".tree-checkbox");
            if (n.length) {
                if (n.hasClass("tree-checkbox1")) {
                    v(e, t, true);
                } else {
                    v(e, t, false);
                }
            } else {
                if (a.onlyLeafCheck) {
                    h('<span class="tree-checkbox tree-checkbox0"></span>').insertBefore(i.find(".tree-title"));
                }
            }
        } else {
            var n = i.find(".tree-checkbox");
            if (a.onlyLeafCheck) {
                n.remove();
            } else {
                if (n.hasClass("tree-checkbox1")) {
                    v(e, t, true);
                } else {
                    if (n.hasClass("tree-checkbox2")) {
                        var r = true;
                        var o = true;
                        var s = w(e, t);
                        for (var d = 0; d < s.length; d++) {
                            if (s[d].checked) {
                                o = false;
                            } else {
                                r = false;
                            }
                        }
                        if (r) {
                            v(e, t, true);
                        }
                        if (o) {
                            v(e, t, false);
                        }
                    }
                }
            }
        }
    }
    function l(e, t, a, i) {
        var n = h.data(e, "tree");
        var r = n.options;
        var o = h(t).prevAll("div.tree-node:first");
        a = r.loadFilter.call(e, a, o[0]);
        var s = D(e, "domId", o.attr("id"));
        if (!i) {
            s ? s.children = a : n.data = a;
            h(t).empty();
        } else {
            if (s) {
                s.children ? s.children = s.children.concat(a) : s.children = a;
            } else {
                n.data = n.data.concat(a);
            }
        }
        r.view.render.call(r.view, e, t, a);
        if (r.dnd) {
            p(e);
        }
        if (s) {
            x(e, s);
        }
        var d = [];
        var l = [];
        for (var c = 0; c < a.length; c++) {
            var u = a[c];
            if (!u.checked) {
                d.push(u);
            }
        }
        $(a, function(e) {
            if (e.checked) {
                l.push(e);
            }
        });
        var f = r.onCheck;
        r.onCheck = function() {};
        if (d.length) {
            v(e, h("#" + d[0].domId)[0], false);
        }
        for (var c = 0; c < l.length; c++) {
            v(e, h("#" + l[c].domId)[0], true);
        }
        r.onCheck = f;
        setTimeout(function() {
            g(e, e);
        }, 0);
        r.onLoadSuccess.call(e, s, a);
    }
    function g(a, e, i) {
        var t = h.data(a, "tree").options;
        if (t.lines) {
            h(a).addClass("tree-lines");
        } else {
            h(a).removeClass("tree-lines");
            return;
        }
        if (!i) {
            i = true;
            h(a).find("span.tree-indent").removeClass("tree-line tree-join tree-joinbottom");
            h(a).find("div.tree-node").removeClass("tree-node-last tree-root-first tree-root-one");
            var n = h(a).tree("getRoots");
            if (n.length > 1) {
                h(n[0].target).addClass("tree-root-first");
            } else {
                if (n.length == 1) {
                    h(n[0].target).addClass("tree-root-one");
                }
            }
        }
        h(e).children("li").each(function() {
            var e = h(this).children("div.tree-node");
            var t = e.next("ul");
            if (t.length) {
                if (h(this).next().length) {
                    s(e);
                }
                g(a, t, i);
            } else {
                o(e);
            }
        });
        var r = h(e).children("li:last").children("div.tree-node").addClass("tree-node-last");
        r.children("span.tree-join").removeClass("tree-join").addClass("tree-joinbottom");
        function o(e, t) {
            var a = e.find("span.tree-icon");
            a.prev("span.tree-indent").addClass("tree-join");
        }
        function s(e) {
            var t = e.find("span.tree-indent, span.tree-hit").length;
            e.next().find("div.tree-node").each(function() {
                h(this).children("span:eq(" + (t - 1) + ")").addClass("tree-line");
            });
        }
    }
    function d(t, a, e, i) {
        var n = h.data(t, "tree").options;
        e = e || {};
        var r = null;
        if (t != a) {
            var o = h(a).prev();
            r = y(t, o[0]);
        }
        if (n.onBeforeLoad.call(t, r, e) == false) {
            return;
        }
        var s = h(a).prev().children("span.tree-folder");
        s.addClass("tree-loading");
        var d = n.loader.call(t, e, function(e) {
            s.removeClass("tree-loading");
            l(t, a, e);
            if (i) {
                i();
            }
        }, function() {
            s.removeClass("tree-loading");
            n.onLoadError.apply(t, arguments);
            if (i) {
                i();
            }
        });
        if (d == false) {
            s.removeClass("tree-loading");
        }
    }
    function f(e, t, a) {
        var i = h.data(e, "tree").options;
        var n = h(t).children("span.tree-hit");
        if (n.length == 0) {
            return;
        }
        if (n.hasClass("tree-expanded")) {
            return;
        }
        var r = y(e, t);
        if (i.onBeforeExpand.call(e, r) == false) {
            return;
        }
        n.removeClass("tree-collapsed tree-collapsed-hover").addClass("tree-expanded");
        n.next().addClass("tree-folder-open");
        var o = h(t).next();
        if (o.length) {
            if (i.animate) {
                o.slideDown("normal", function() {
                    r.state = "open";
                    i.onExpand.call(e, r);
                    if (a) {
                        a();
                    }
                });
            } else {
                o.css("display", "block");
                r.state = "open";
                i.onExpand.call(e, r);
                if (a) {
                    a();
                }
            }
        } else {
            var s = h('<ul style="display:none"></ul>').insertAfter(t);
            d(e, s[0], {
                id: r.id
            }, function() {
                if (s.is(":empty")) {
                    s.remove();
                }
                if (i.animate) {
                    s.slideDown("normal", function() {
                        r.state = "open";
                        i.onExpand.call(e, r);
                        if (a) {
                            a();
                        }
                    });
                } else {
                    s.css("display", "block");
                    r.state = "open";
                    i.onExpand.call(e, r);
                    if (a) {
                        a();
                    }
                }
            });
        }
    }
    function o(e, t) {
        var a = h.data(e, "tree").options;
        var i = h(t).children("span.tree-hit");
        if (i.length == 0) {
            return;
        }
        if (i.hasClass("tree-collapsed")) {
            return;
        }
        var n = y(e, t);
        if (a.onBeforeCollapse.call(e, n) == false) {
            return;
        }
        i.removeClass("tree-expanded tree-expanded-hover").addClass("tree-collapsed");
        i.next().removeClass("tree-folder-open");
        var r = h(t).next();
        if (a.animate) {
            r.slideUp("normal", function() {
                n.state = "closed";
                a.onCollapse.call(e, n);
            });
        } else {
            r.css("display", "none");
            n.state = "closed";
            a.onCollapse.call(e, n);
        }
    }
    function c(e, t) {
        var a = h(t).children("span.tree-hit");
        if (a.length == 0) {
            return;
        }
        if (a.hasClass("tree-expanded")) {
            o(e, t);
        } else {
            f(e, t);
        }
    }
    function a(e, t) {
        var a = w(e, t);
        if (t) {
            a.unshift(y(e, t));
        }
        for (var i = 0; i < a.length; i++) {
            f(e, a[i].target);
        }
    }
    function i(e, t) {
        var a = [];
        var i = L(e, t);
        while (i) {
            a.unshift(i);
            i = L(e, i.target);
        }
        for (var n = 0; n < a.length; n++) {
            f(e, a[n].target);
        }
    }
    function u(e, t) {
        var a = h(e).parent();
        while (a[0].tagName != "BODY" && a.css("overflow-y") != "auto") {
            a = a.parent();
        }
        var i = h(t);
        var n = i.offset().top;
        if (a[0].tagName != "BODY") {
            var r = a.offset().top;
            if (n < r) {
                a.scrollTop(a.scrollTop() + n - r);
            } else {
                if (n + i.outerHeight() > r + a.outerHeight() - 18) {
                    a.scrollTop(a.scrollTop() + n + i.outerHeight() - r - a.outerHeight() + 18);
                }
            }
        } else {
            a.scrollTop(n);
        }
    }
    function b(e, t) {
        var a = w(e, t);
        if (t) {
            a.unshift(y(e, t));
        }
        for (var i = 0; i < a.length; i++) {
            o(e, a[i].target);
        }
    }
    function m(e, t) {
        var a = h(t.parent);
        var i = t.data;
        if (!i) {
            return;
        }
        i = h.isArray(i) ? i : [ i ];
        if (!i.length) {
            return;
        }
        var n;
        if (a.length == 0) {
            n = h(e);
        } else {
            if (k(e, a[0])) {
                var r = a.find("span.tree-icon");
                r.removeClass("tree-file").addClass("tree-folder tree-folder-open");
                var o = h('<span class="tree-hit tree-expanded"></span>').insertBefore(r);
                if (o.prev().length) {
                    o.prev().remove();
                }
            }
            n = a.next();
            if (!n.length) {
                n = h("<ul></ul>").insertAfter(a);
            }
        }
        l(e, n[0], i, true);
        s(e, n.prev());
    }
    function C(e, t) {
        var a = t.before || t.after;
        var i = L(e, a);
        var n = t.data;
        if (!n) {
            return;
        }
        n = h.isArray(n) ? n : [ n ];
        if (!n.length) {
            return;
        }
        m(e, {
            parent: i ? i.target : null,
            data: n
        });
        var r = i ? i.children : h(e).tree("getRoots");
        for (var o = 0; o < r.length; o++) {
            if (r[o].domId == h(a).attr("id")) {
                for (var s = n.length - 1; s >= 0; s--) {
                    r.splice(t.before ? o : o + 1, 0, n[s]);
                }
                r.splice(r.length - n.length, n.length);
                break;
            }
        }
        var d = h();
        for (var o = 0; o < n.length; o++) {
            d = d.add(h("#" + n[o].domId).parent());
        }
        if (t.before) {
            d.insertBefore(h(a).parent());
        } else {
            d.insertAfter(h(a).parent());
        }
    }
    function Y(r, e) {
        var t = i(e);
        h(e).parent().remove();
        if (t) {
            if (!t.children || !t.children.length) {
                var a = h(t.target);
                a.find(".tree-icon").removeClass("tree-folder").addClass("tree-file");
                a.find(".tree-hit").remove();
                h('<span class="tree-indent"></span>').prependTo(a);
                a.next().remove();
            }
            x(r, t);
            s(r, t.target);
        }
        g(r, r);
        function i(e) {
            var t = h(e).attr("id");
            var a = L(r, e);
            var i = a ? a.children : h.data(r, "tree").data;
            for (var n = 0; n < i.length; n++) {
                if (i[n].domId == t) {
                    i.splice(n, 1);
                    break;
                }
            }
            return a;
        }
    }
    function x(e, t) {
        var a = h.data(e, "tree").options;
        var i = h(t.target);
        var n = y(e, t.target);
        var r = n.checked;
        if (n.iconCls) {
            i.find(".tree-icon").removeClass(n.iconCls);
        }
        h.extend(n, t);
        i.find(".tree-title").html(a.formatter.call(e, n));
        if (n.iconCls) {
            i.find(".tree-icon").addClass(n.iconCls);
        }
        if (r != n.checked) {
            v(e, t.target, n.checked);
        }
    }
    function Z(e) {
        var t = S(e);
        return t.length ? t[0] : null;
    }
    function S(e) {
        var t = h.data(e, "tree").data;
        for (var a = 0; a < t.length; a++) {
            Q(t[a]);
        }
        return t;
    }
    function w(e, t) {
        var a = [];
        var i = y(e, t);
        var n = i ? i.children : h.data(e, "tree").data;
        $(n, function(e) {
            a.push(Q(e));
        });
        return a;
    }
    function L(e, t) {
        var a = h(t).closest("ul").prevAll("div.tree-node:first");
        return y(e, a[0]);
    }
    function T(t, e) {
        e = e || "checked";
        if (!h.isArray(e)) {
            e = [ e ];
        }
        var a = [];
        for (var i = 0; i < e.length; i++) {
            var n = e[i];
            if (n == "checked") {
                a.push("span.tree-checkbox1");
            } else {
                if (n == "unchecked") {
                    a.push("span.tree-checkbox0");
                } else {
                    if (n == "indeterminate") {
                        a.push("span.tree-checkbox2");
                    }
                }
            }
        }
        var r = [];
        h(t).find(a.join(",")).each(function() {
            var e = h(this).parent();
            r.push(y(t, e[0]));
        });
        return r;
    }
    function X(e) {
        var t = h(e).find("div.tree-node-selected");
        return t.length ? y(e, t[0]) : null;
    }
    function J(e, t) {
        var a = y(e, t);
        if (a && a.children) {
            $(a.children, function(e) {
                Q(e);
            });
        }
        return a;
    }
    function y(e, t) {
        return D(e, "domId", h(t).attr("id"));
    }
    function H(e, t) {
        return D(e, "id", t);
    }
    function D(e, t, a) {
        var i = h.data(e, "tree").data;
        var n = null;
        $(i, function(e) {
            if (e[t] == a) {
                n = Q(e);
                return false;
            }
        });
        return n;
    }
    function Q(e) {
        var t = h("#" + e.domId);
        e.target = t[0];
        e.checked = t.find(".tree-checkbox").hasClass("tree-checkbox1");
        return e;
    }
    function $(e, t) {
        var a = [];
        for (var i = 0; i < e.length; i++) {
            a.push(e[i]);
        }
        while (a.length) {
            var n = a.shift();
            if (t(n) == false) {
                return;
            }
            if (n.children) {
                for (var i = n.children.length - 1; i >= 0; i--) {
                    a.unshift(n.children[i]);
                }
            }
        }
    }
    function F(e, t) {
        var a = h.data(e, "tree").options;
        var i = y(e, t);
        if (a.onBeforeSelect.call(e, i) == false) {
            return;
        }
        h(e).find("div.tree-node-selected").removeClass("tree-node-selected");
        h(t).addClass("tree-node-selected");
        a.onSelect.call(e, i);
    }
    function k(e, t) {
        return h(t).children("span.tree-hit").length == 0;
    }
    function P(t, a) {
        var e = h.data(t, "tree").options;
        var i = y(t, a);
        if (e.onBeforeEdit.call(t, i) == false) {
            return;
        }
        h(a).css("position", "relative");
        var n = h(a).find(".tree-title");
        var r = n.outerWidth();
        n.empty();
        var o = h('<input class="tree-editor">').appendTo(n);
        o.val(i.text).focus();
        o.width(r + 20);
        o.height(document.compatMode == "CSS1Compat" ? 18 - (o.outerHeight() - o.height()) : 18);
        o.bind("click", function(e) {
            return false;
        }).bind("mousedown", function(e) {
            e.stopPropagation();
        }).bind("mousemove", function(e) {
            e.stopPropagation();
        }).bind("keydown", function(e) {
            if (e.keyCode == 13) {
                M(t, a);
                return false;
            } else {
                if (e.keyCode == 27) {
                    _(t, a);
                    return false;
                }
            }
        }).bind("blur", function(e) {
            e.stopPropagation();
            M(t, a);
        });
    }
    function M(e, t) {
        var a = h.data(e, "tree").options;
        h(t).css("position", "");
        var i = h(t).find("input.tree-editor");
        var n = i.val();
        i.remove();
        var r = y(e, t);
        r.text = n;
        x(e, r);
        a.onAfterEdit.call(e, r);
    }
    function _(e, t) {
        var a = h.data(e, "tree").options;
        h(t).css("position", "");
        h(t).find("input.tree-editor").remove();
        var i = y(e, t);
        x(e, i);
        a.onCancelEdit.call(e, i);
    }
    h.fn.tree = function(i, e) {
        if (typeof i == "string") {
            return h.fn.tree.methods[i](this, e);
        }
        var i = i || {};
        return this.each(function() {
            var e = h.data(this, "tree");
            var t;
            if (e) {
                t = h.extend(e.options, i);
                e.options = t;
            } else {
                t = h.extend({}, h.fn.tree.defaults, h.fn.tree.parseOptions(this), i);
                h.data(this, "tree", {
                    options: t,
                    tree: n(this),
                    data: []
                });
                var a = h.fn.tree.parseData(this);
                if (a.length) {
                    l(this, this, a);
                }
            }
            r(this);
            if (t.data) {
                l(this, this, h.extend(true, [], t.data));
            }
            d(this, this);
        });
    };
    h.fn.tree.methods = {
        options: function(e) {
            return h.data(e[0], "tree").options;
        },
        loadData: function(e, t) {
            return e.each(function() {
                l(this, this, t);
            });
        },
        getNode: function(e, t) {
            return y(e[0], t);
        },
        getData: function(e, t) {
            return J(e[0], t);
        },
        reload: function(e, a) {
            return e.each(function() {
                if (a) {
                    var e = h(a);
                    var t = e.children("span.tree-hit");
                    t.removeClass("tree-expanded tree-expanded-hover").addClass("tree-collapsed");
                    e.next().remove();
                    f(this, a);
                } else {
                    h(this).empty();
                    d(this, this);
                }
            });
        },
        getRoot: function(e) {
            return Z(e[0]);
        },
        getRoots: function(e) {
            return S(e[0]);
        },
        getParent: function(e, t) {
            return L(e[0], t);
        },
        getChildren: function(e, t) {
            return w(e[0], t);
        },
        getChecked: function(e, t) {
            return T(e[0], t);
        },
        getSelected: function(e) {
            return X(e[0]);
        },
        isLeaf: function(e, t) {
            return k(e[0], t);
        },
        find: function(e, t) {
            return H(e[0], t);
        },
        select: function(e, t) {
            return e.each(function() {
                F(this, t);
            });
        },
        check: function(e, t) {
            return e.each(function() {
                v(this, t, true);
            });
        },
        uncheck: function(e, t) {
            return e.each(function() {
                v(this, t, false);
            });
        },
        collapse: function(e, t) {
            return e.each(function() {
                o(this, t);
            });
        },
        expand: function(e, t) {
            return e.each(function() {
                f(this, t);
            });
        },
        collapseAll: function(e, t) {
            return e.each(function() {
                b(this, t);
            });
        },
        expandAll: function(e, t) {
            return e.each(function() {
                a(this, t);
            });
        },
        expandTo: function(e, t) {
            return e.each(function() {
                i(this, t);
            });
        },
        scrollTo: function(e, t) {
            return e.each(function() {
                u(this, t);
            });
        },
        toggle: function(e, t) {
            return e.each(function() {
                c(this, t);
            });
        },
        append: function(e, t) {
            return e.each(function() {
                m(this, t);
            });
        },
        insert: function(e, t) {
            return e.each(function() {
                C(this, t);
            });
        },
        remove: function(e, t) {
            return e.each(function() {
                Y(this, t);
            });
        },
        pop: function(e, t) {
            var a = e.tree("getData", t);
            e.tree("remove", t);
            return a;
        },
        update: function(e, t) {
            return e.each(function() {
                x(this, t);
            });
        },
        enableDnd: function(e) {
            return e.each(function() {
                p(this);
            });
        },
        disableDnd: function(e) {
            return e.each(function() {
                t(this);
            });
        },
        beginEdit: function(e, t) {
            return e.each(function() {
                P(this, t);
            });
        },
        endEdit: function(e, t) {
            return e.each(function() {
                M(this, t);
            });
        },
        cancelEdit: function(e, t) {
            return e.each(function() {
                _(this, t);
            });
        }
    };
    h.fn.tree.parseOptions = function(e) {
        var t = h(e);
        return h.extend({}, h.parser.parseOptions(e, [ "url", "method", {
            checkbox: "boolean",
            cascadeCheck: "boolean",
            onlyLeafCheck: "boolean"
        }, {
            animate: "boolean",
            lines: "boolean",
            dnd: "boolean"
        } ]));
    };
    h.fn.tree.parseData = function(e) {
        var t = [];
        n(t, h(e));
        return t;
        function n(i, e) {
            e.children("li").each(function() {
                var e = h(this);
                var t = h.extend({}, h.parser.parseOptions(this, [ "id", "iconCls", "state" ]), {
                    checked: e.attr("checked") ? true : undefined
                });
                t.text = e.children("span").html();
                if (!t.text) {
                    t.text = e.html();
                }
                var a = e.children("ul");
                if (a.length) {
                    t.children = [];
                    n(t.children, a);
                }
                i.push(t);
            });
        }
    };
    var B = 1;
    var e = {
        render: function(l, e, t) {
            var c = h.data(l, "tree").options;
            var u = h('<div id="virtual-node" class="tree-node" style="position:absolute;top:-1000px">').appendTo("body");
            var a = h(e).prev("div.tree-node").find("span.tree-indent, span.tree-hit").length;
            var i = f(a, t);
            h(e).append(i.join(""));
            u.remove();
            function f(e, t) {
                var a = [];
                for (var i = 0; i < t.length; i++) {
                    var n = t[i];
                    if (c.lines && c.autoNodeHeight) {
                        u.empty();
                        var r = h('<span class="tree-title">' + c.formatter.call(l, n) + "</span>").appendTo(u).height();
                    } else {
                        var r = 0;
                    }
                    if (n.state != "open" && n.state != "closed") {
                        n.state = "open";
                    }
                    n.domId = "_hisui_tree_" + B++;
                    a.push("<li>");
                    a.push('<div id="' + n.domId + '" class="tree-node">');
                    for (var o = 0; o < e; o++) {
                        a.push('<span class="tree-indent" ' + (r > 0 ? 'style="height:' + r + 'px"' : "") + "></span>");
                    }
                    var s = false;
                    if (n.state == "closed") {
                        a.push('<span class="tree-hit tree-collapsed" ' + (r > 0 ? 'style="height:' + r + 'px"' : "") + "></span>");
                        if (r > 0) {
                            a.push('<span class="tree-icon tree-folder tree-icon-lines" style="height:' + r + 'px"></span>');
                        } else {
                            a.push('<span class="tree-icon tree-folder ' + (n.iconCls ? n.iconCls : "") + '"></span>');
                        }
                    } else {
                        if (n.children && n.children.length) {
                            a.push('<span class="tree-hit tree-expanded" ' + (r > 0 ? 'style="height:' + r + 'px"' : "") + "></span>");
                            if (r > 0) {
                                a.push('<span class="tree-icon tree-folder tree-folder-open tree-icon-lines" style="height:' + r + 'px"></span>');
                            } else {
                                a.push('<span class="tree-icon tree-folder tree-folder-open ' + (n.iconCls ? n.iconCls : "") + '"></span>');
                            }
                        } else {
                            a.push('<span class="tree-indent" ' + (r > 0 ? 'style="height:' + r + 'px"' : "") + "></span>");
                            if (r > 0) {
                                a.push('<span class="tree-icon tree-file tree-icon-lines" style="height:' + r + 'px"></span>');
                            } else {
                                a.push('<span class="tree-icon tree-file ' + (n.iconCls ? n.iconCls : "") + '"></span>');
                            }
                            s = true;
                        }
                    }
                    if (c.checkbox) {
                        if (!c.onlyLeafCheck || s) {
                            a.push('<span class="tree-checkbox tree-checkbox0"></span>');
                        }
                    }
                    a.push('<span class="tree-title">' + c.formatter.call(l, n) + "</span>");
                    a.push("</div>");
                    if (n.children && n.children.length) {
                        var d = f(e + 1, n.children);
                        a.push('<ul style="display:' + (n.state == "closed" ? "none" : "block") + '">');
                        a = a.concat(d);
                        a.push("</ul>");
                    }
                    a.push("</li>");
                }
                return a;
            }
        }
    };
    h.fn.tree.defaults = {
        url: null,
        method: "post",
        animate: false,
        checkbox: false,
        cascadeCheck: true,
        onlyLeafCheck: false,
        lines: false,
        dnd: false,
        data: null,
        formatter: function(e) {
            return e.text;
        },
        loader: function(e, t, a) {
            var i = h(this).tree("options");
            if (!i.url) {
                return false;
            }
            h.ajax({
                type: i.method,
                url: i.url,
                data: e,
                dataType: "json",
                success: function(e) {
                    t(e);
                },
                error: function() {
                    a.apply(this, arguments);
                }
            });
        },
        loadFilter: function(e, t) {
            return e;
        },
        view: e,
        onBeforeLoad: function(e, t) {},
        onLoadSuccess: function(e, t) {},
        onLoadError: function() {},
        onClick: function(e) {},
        onDblClick: function(e) {},
        onBeforeExpand: function(e) {},
        onExpand: function(e) {},
        onBeforeCollapse: function(e) {},
        onCollapse: function(e) {},
        onBeforeCheck: function(e, t) {},
        onCheck: function(e, t) {},
        onBeforeSelect: function(e) {},
        onSelect: function(e) {},
        onContextMenu: function(e, t) {},
        onBeforeDrag: function(e) {},
        onStartDrag: function(e) {},
        onStopDrag: function(e) {},
        onDragEnter: function(e, t) {},
        onDragOver: function(e, t) {},
        onDragLeave: function(e, t) {},
        onBeforeDrop: function(e, t, a) {},
        onDrop: function(e, t, a) {},
        onBeforeEdit: function(e) {},
        onAfterEdit: function(e) {},
        onCancelEdit: function(e) {},
        autoNodeHeight: false
    };
})(jQuery);

(function(n) {
    function i(e) {
        n(e).addClass("progressbar");
        n(e).html('<div class="progressbar-text"></div><div class="progressbar-value"><div class="progressbar-text"></div></div>');
        return n(e);
    }
    function r(e, t) {
        var a = n.data(e, "progressbar").options;
        var i = n.data(e, "progressbar").bar;
        if (t) {
            a.width = t;
        }
        i._outerWidth(a.width)._outerHeight(a.height);
        i.find("div.progressbar-text").width(i.width());
        i.find("div.progressbar-text,div.progressbar-value").css({
            height: i.height() + "px",
            lineHeight: i.height() + "px"
        });
    }
    n.fn.progressbar = function(t, e) {
        if (typeof t == "string") {
            var a = n.fn.progressbar.methods[t];
            if (a) {
                return a(this, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = n.data(this, "progressbar");
            if (e) {
                n.extend(e.options, t);
            } else {
                e = n.data(this, "progressbar", {
                    options: n.extend({}, n.fn.progressbar.defaults, n.fn.progressbar.parseOptions(this), t),
                    bar: i(this)
                });
            }
            n(this).progressbar("setValue", e.options.value);
            r(this);
        });
    };
    n.fn.progressbar.methods = {
        options: function(e) {
            return n.data(e[0], "progressbar").options;
        },
        resize: function(e, t) {
            return e.each(function() {
                r(this, t);
            });
        },
        getValue: function(e) {
            return n.data(e[0], "progressbar").options.value;
        },
        setValue: function(e, i) {
            if (i < 0) {
                i = 0;
            }
            if (i > 100) {
                i = 100;
            }
            return e.each(function() {
                var e = n.data(this, "progressbar").options;
                var t = e.text.replace(/{value}/, i);
                var a = e.value;
                e.value = i;
                n(this).find("div.progressbar-value").width(i + "%");
                n(this).find("div.progressbar-text").html(t);
                if (a != i) {
                    e.onChange.call(this, i, a);
                }
            });
        }
    };
    n.fn.progressbar.parseOptions = function(e) {
        return n.extend({}, n.parser.parseOptions(e, [ "width", "height", "text", {
            value: "number"
        } ]));
    };
    n.fn.progressbar.defaults = {
        width: "auto",
        height: 22,
        value: 0,
        text: "{value}%",
        onChange: function(e, t) {}
    };
})(jQuery);

(function(s) {
    function a(e) {
        s(e).addClass("tooltip-f");
    }
    function i(t) {
        var a = s.data(t, "tooltip").options;
        s(t).unbind(".tooltip").bind(a.showEvent + ".tooltip", function(e) {
            n(t, e);
        }).bind(a.hideEvent + ".tooltip", function(e) {
            r(t, e);
        }).bind("mousemove.tooltip", function(e) {
            if (a.trackMouse) {
                a.trackMouseX = e.pageX;
                a.trackMouseY = e.pageY;
                l(t);
            }
        });
    }
    function d(e) {
        var t = s.data(e, "tooltip");
        if (t.showTimer) {
            clearTimeout(t.showTimer);
            t.showTimer = null;
        }
        if (t.hideTimer) {
            clearTimeout(t.hideTimer);
            t.hideTimer = null;
        }
    }
    function l(e) {
        var t = s.data(e, "tooltip");
        if (!t || !t.tip) {
            return;
        }
        var a = t.options;
        var i = t.tip;
        if (a.trackMouse) {
            o = s();
            var n = a.trackMouseX + a.deltaX;
            var r = a.trackMouseY + a.deltaY;
        } else {
            var o = s(e);
            var n = o.offset().left + a.deltaX;
            var r = o.offset().top + a.deltaY;
        }
        switch (a.position) {
          case "right":
            n += o._outerWidth() + 12 + (a.trackMouse ? 12 : 0);
            r -= (i._outerHeight() - o._outerHeight()) / 2;
            break;

          case "left":
            n -= i._outerWidth() + 12 + (a.trackMouse ? 12 : 0);
            r -= (i._outerHeight() - o._outerHeight()) / 2;
            break;

          case "top":
            n -= (i._outerWidth() - o._outerWidth()) / 2;
            r -= i._outerHeight() + 12 + (a.trackMouse ? 12 : 0);
            break;

          case "bottom":
            n -= (i._outerWidth() - o._outerWidth()) / 2;
            r += o._outerHeight() + 12 + (a.trackMouse ? 12 : 0);
            break;
        }
        if (!s(e).is(":visible")) {
            n = -1e5;
            r = -1e5;
        }
        i.css({
            left: n,
            top: r,
            zIndex: a.zIndex != undefined ? a.zIndex : s.fn.window ? s.fn.window.defaults.zIndex++ : ""
        });
        a.onPosition.call(e, n, r);
    }
    function n(i, n) {
        var e = s.data(i, "tooltip");
        var r = e.options;
        var o = e.tip;
        if (!o) {
            o = s('<div tabindex="-1" class="tooltip">' + '<div class="tooltip-content"></div>' + '<div class="tooltip-arrow-outer"></div>' + '<div class="tooltip-arrow"></div>' + "</div>").appendTo("body");
            e.tip = o;
            c(i);
        }
        o.removeClass("tooltip-top tooltip-bottom tooltip-left tooltip-right").addClass("tooltip-" + r.position);
        d(i);
        e.showTimer = setTimeout(function() {
            l(i);
            o.show();
            r.onShow.call(i, n);
            var e = o.children(".tooltip-arrow-outer");
            var t = o.children(".tooltip-arrow");
            var a = "border-" + r.position + "-color";
            e.add(t).css({
                borderTopColor: "",
                borderBottomColor: "",
                borderLeftColor: "",
                borderRightColor: ""
            });
            e.css(a, o.css(a));
            t.css(a, o.css("backgroundColor"));
        }, r.showDelay);
    }
    function r(e, t) {
        var a = s.data(e, "tooltip");
        if (a && a.tip) {
            d(e);
            a.hideTimer = setTimeout(function() {
                a.tip.hide();
                a.options.onHide.call(e, t);
            }, a.options.hideDelay);
        }
    }
    function c(e, t) {
        var a = s.data(e, "tooltip");
        var i = a.options;
        if (t) {
            i.content = t;
        }
        if (!a.tip) {
            return;
        }
        var n = typeof i.content == "function" ? i.content.call(e) : i.content;
        a.tip.children(".tooltip-content").html(n);
        i.onUpdate.call(e, n);
    }
    function t(e) {
        var t = s.data(e, "tooltip");
        if (t) {
            d(e);
            var a = t.options;
            if (t.tip) {
                t.tip.remove();
            }
            if (a._title) {
                s(e).attr("title", a._title);
            }
            s.removeData(e, "tooltip");
            s(e).unbind(".tooltip").removeClass("tooltip-f");
            a.onDestroy.call(e);
        }
    }
    s.fn.tooltip = function(t, e) {
        if (typeof t == "string") {
            return s.fn.tooltip.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = s.data(this, "tooltip");
            if (e) {
                s.extend(e.options, t);
            } else {
                s.data(this, "tooltip", {
                    options: s.extend({}, s.fn.tooltip.defaults, s.fn.tooltip.parseOptions(this), t)
                });
                a(this);
            }
            i(this);
            c(this);
        });
    };
    s.fn.tooltip.methods = {
        options: function(e) {
            return s.data(e[0], "tooltip").options;
        },
        tip: function(e) {
            return s.data(e[0], "tooltip").tip;
        },
        arrow: function(e) {
            return e.tooltip("tip").children(".tooltip-arrow-outer,.tooltip-arrow");
        },
        show: function(e, t) {
            return e.each(function() {
                n(this, t);
            });
        },
        hide: function(e, t) {
            return e.each(function() {
                r(this, t);
            });
        },
        update: function(e, t) {
            return e.each(function() {
                c(this, t);
            });
        },
        reposition: function(e) {
            return e.each(function() {
                l(this);
            });
        },
        destroy: function(e) {
            return e.each(function() {
                t(this);
            });
        }
    };
    s.fn.tooltip.parseOptions = function(e) {
        var t = s(e);
        var a = s.extend({}, s.parser.parseOptions(e, [ "position", "showEvent", "hideEvent", "content", {
            deltaX: "number",
            deltaY: "number",
            showDelay: "number",
            hideDelay: "number"
        } ]), {
            _title: t.attr("title")
        });
        t.attr("title", "");
        if (!a.content) {
            a.content = a._title;
        }
        return a;
    };
    s.fn.tooltip.defaults = {
        position: "bottom",
        content: null,
        trackMouse: false,
        deltaX: 0,
        deltaY: 0,
        showEvent: "mouseenter",
        hideEvent: "mouseleave",
        showDelay: 200,
        hideDelay: 100,
        onShow: function(e) {},
        onHide: function(e) {},
        onUpdate: function(e) {},
        onPosition: function(e, t) {},
        onDestroy: function() {}
    };
})(jQuery);

(function($) {
    $.fn._remove = function() {
        return this.each(function() {
            $(this).remove();
            try {
                this.outerHTML = "";
            } catch (e) {}
        });
    };
    function _1e2(e) {
        e._remove();
    }
    function _1e3(e, t) {
        var a = $(e);
        if (a.attr("id") == $.hisui.globalContainerId) {
            a.css(t);
            $.hisui.fixPanelTLWH();
            return;
        }
        var i = $.data(e, "panel").options;
        var n = $.data(e, "panel").panel;
        var r = n.children("div.panel-header");
        var o = n.children("div.panel-body");
        if (t) {
            $.extend(i, {
                width: t.width,
                height: t.height,
                left: t.left,
                top: t.top
            });
        }
        i.fit ? $.extend(i, n._fit()) : n._fit(false);
        n.css({
            left: i.left,
            top: i.top
        });
        if (!isNaN(i.width)) {
            n._outerWidth(i.width);
        } else {
            n.width("auto");
        }
        r.add(o)._outerWidth(n.width());
        if (null != i.headerCls && "undefined" != typeof i.headerCls && i.headerCls.indexOf("panel-header-card") > -1) {
            if (null != i.titleWidth && "undefined" != typeof i.titleWidth) {
                r.width(i.titleWidth);
            } else {
                var s = r.find(".panel-title").text();
                if (s.length <= 4) {
                    r.width(80);
                } else {
                    r.width(s.length * 20);
                }
            }
        }
        if (!isNaN(i.height)) {
            n._outerHeight(i.height);
            o._outerHeight(n.height() - r._outerHeight());
        } else {
            o.height("auto");
        }
        n.css("height", "");
        i.onResize.apply(e, [ i.width, i.height ]);
        $(e).find(">div,>form>div").filter(":visible").each(function() {
            $(this).triggerHandler("_resize");
        });
    }
    function _1e9(e, t) {
        var a = $.data(e, "panel").options;
        var i = $.data(e, "panel").panel;
        if (t) {
            if (t.left != null) {
                a.left = t.left;
            }
            if (t.top != null) {
                a.top = t.top;
            }
        }
        if (a.left < 0) {
            a.left = 0;
        }
        if (a.top < 0) {
            a.top = 0;
        }
        i.css({
            left: a.left,
            top: a.top
        });
        a.onMove.apply(e, [ a.left, a.top ]);
    }
    function _1ed(t) {
        $(t).addClass("panel-body");
        var e = $('<div class="panel"></div>').insertBefore(t);
        e[0].appendChild(t);
        e.bind("_resize", function() {
            var e = $.data(t, "panel").options;
            if (e.fit == true) {
                _1e3(t);
            }
            return false;
        });
        return e;
    }
    function _1f0(_1f1) {
        var opts = $.data(_1f1, "panel").options;
        var _1f2 = $.data(_1f1, "panel").panel;
        if (opts.tools && typeof opts.tools == "string") {
            _1f2.find(">div.panel-header>div.panel-tool .panel-tool-a").appendTo(opts.tools);
        }
        _1e2(_1f2.children("div.panel-header"));
        if (opts.title && !opts.noheader) {
            var _1f3 = $('<div class="panel-header"><div class="panel-title">' + opts.title + "</div></div>").prependTo(_1f2);
            if (opts.iconCls) {
                _1f3.find(".panel-title").addClass("panel-with-icon");
                $('<div class="panel-icon"></div>').addClass(opts.iconCls).appendTo(_1f3);
            }
            var tool = $('<div class="panel-tool"></div>').appendTo(_1f3);
            tool.bind("click", function(e) {
                e.stopPropagation();
            });
            if (opts.tools) {
                if ($.isArray(opts.tools)) {
                    for (var i = 0; i < opts.tools.length; i++) {
                        var t = $('<a href="javascript:void(0)"></a>').addClass(opts.tools[i].iconCls).appendTo(tool);
                        if (opts.tools[i].handler) {
                            t.bind("click", eval(opts.tools[i].handler));
                        }
                    }
                } else {
                    $(opts.tools).children().each(function() {
                        $(this).addClass($(this).attr("iconCls")).addClass("panel-tool-a").appendTo(tool);
                    });
                }
            }
            if (opts.collapsible) {
                $('<a class="panel-tool-collapse" href="javascript:void(0)"></a>').appendTo(tool).bind("click", function() {
                    if (opts.collapsed == true) {
                        _210(_1f1, true);
                    } else {
                        _205(_1f1, true);
                    }
                    return false;
                });
            }
            if (opts.minimizable) {
                $('<a class="panel-tool-min" href="javascript:void(0)"></a>').appendTo(tool).bind("click", function() {
                    _216(_1f1);
                    return false;
                });
            }
            if (opts.maximizable) {
                $('<a class="panel-tool-max" href="javascript:void(0)"></a>').appendTo(tool).bind("click", function() {
                    if (opts.maximized == true) {
                        _219(_1f1);
                    } else {
                        _204(_1f1);
                    }
                    return false;
                });
            }
            if (opts.closable) {
                $('<a class="panel-tool-close" href="javascript:void(0)"></a>').appendTo(tool).bind("click", function() {
                    _1f4(_1f1);
                    return false;
                });
            }
            _1f2.children("div.panel-body").removeClass("panel-body-noheader");
        } else {
            _1f2.children("div.panel-body").addClass("panel-body-noheader");
        }
        var ocxFrame = "";
        if (opts.isTopZindex) {
            if (!!window.ActiveXObject || "ActiveXObject" in window) {
                ocxFrame = '<iframe style="position:absolute;z-index:-1;width:100%;height:100%;top:0;left:0;scrolling:no;" frameborder="0"></iframe>';
                _1f2.prepend(ocxFrame);
            }
        }
    }
    function _1f5(t, e) {
        var a = $.data(t, "panel");
        var i = a.options;
        if (n) {
            i.queryParams = e;
        }
        if (i.href) {
            if (!a.isLoaded || !i.cache) {
                var n = $.extend({}, i.queryParams);
                if (i.onBeforeLoad.call(t, n) == false) {
                    return;
                }
                a.isLoaded = false;
                _1fa(t);
                if (i.loadingMessage) {
                    $(t).html($('<div class="panel-loading"></div>').html(i.loadingMessage));
                }
                i.loader.call(t, n, function(e) {
                    r(i.extractor.call(t, e));
                    i.onLoad.apply(t, arguments);
                    a.isLoaded = true;
                }, function() {
                    i.onLoadError.apply(t, arguments);
                });
            }
        } else {
            if (i.content) {
                if (!a.isLoaded) {
                    _1fa(t);
                    r(i.content);
                    a.isLoaded = true;
                }
            }
        }
        function r(e) {
            $(t).html(e);
            $.parser.parse($(t));
        }
    }
    function _1fa(e) {
        var t = $(e);
        t.find(".combo-f").each(function() {
            $(this).combo("destroy");
        });
        t.find(".m-btn").each(function() {
            $(this).menubutton("destroy");
        });
        t.find(".s-btn").each(function() {
            $(this).splitbutton("destroy");
        });
        t.find(".tooltip-f").each(function() {
            $(this).tooltip("destroy");
        });
        t.children("div").each(function() {
            $(this)._fit(false);
        });
    }
    function _1fe(e) {
        $(e).find("div.panel,div.accordion,div.tabs-container,div.layout").filter(":visible").each(function() {
            $(this).triggerHandler("_resize", [ true ]);
        });
    }
    function findObjectDom(e, t, a) {
        if (!!window.ActiveXObject || "ActiveXObject" in window) return;
        if (windowNPAPITotal < 0) return;
        windowNPAPITotal--;
        var i = t.frames.length;
        for (var n = 0; n < i; n++) {
            var r = t.frames[n].window;
            try {
                r.document;
            } catch (l) {
                return;
            }
            var o = r.document.querySelectorAll("OBJECT");
            if (o.length > 0) {
                for (var s = 0; s < o.length; s++) {
                    if (o[s].type.toLowerCase() == "application/x-iemrplugin") {
                        var d = r.frameElement;
                        changeId = d.id;
                        if (d) {
                            if (null == d.getAttribute("data-hideTimes")) d.setAttribute("data-hideTimes", 0);
                            if (0 > d.getAttribute("data-hideTimes")) d.setAttribute("data-hideTimes", 0);
                            if (a) {
                                if (e.changeIdStr.indexOf(changeId) < 0) {
                                    d.setAttribute("data-hideTimes", parseInt(d.getAttribute("data-hideTimes")) + 1);
                                    e.changeIdStr += changeId;
                                }
                                if (d.style.display != "none") {
                                    d.style.display = "none";
                                }
                            } else {
                                d.setAttribute("data-hideTimes", parseInt(d.getAttribute("data-hideTimes")) - 1);
                                e.changeIdStr = e.changeIdStr.replace(changeId, "");
                                if (d.getAttribute("data-hideTimes") == 0) {
                                    d.style.display = "block";
                                }
                            }
                        }
                    }
                }
            }
            findObjectDom(e, r, a);
        }
    }
    function _200(e, t) {
        var a = $.data(e, "panel").options;
        var i = $.data(e, "panel").panel;
        if (t != true) {
            if (a.onBeforeOpen.call(e) == false) {
                return;
            }
        }
        i.show();
        a.closed = false;
        a.minimized = false;
        var n = i.children("div.panel-header").find("a.panel-tool-restore");
        if (n.length) {
            a.maximized = true;
        }
        if (a.isTopZindex) {
            windowNPAPITotal = 200;
            findObjectDom(a, window, true);
        }
        a.onOpen.call(e);
        if (a.maximized == true) {
            a.maximized = false;
            _204(e);
        }
        if (a.collapsed == true) {
            a.collapsed = false;
            _205(e);
        }
        if (!a.collapsed) {
            _1f5(e);
            _1fe(e);
        }
    }
    function _1f4(e, t) {
        var a = $.data(e, "panel").options;
        var i = $.data(e, "panel").panel;
        if (t != true) {
            if (a.onBeforeClose.call(e) == false) {
                return;
            }
        }
        i._fit(false);
        i.hide();
        if (a.isTopZindex) {
            windowNPAPITotal = 200;
            findObjectDom(a, window, false);
        }
        a.changeIdStr = "";
        a.closed = true;
        a.onClose.call(e);
    }
    function _209(e, t) {
        var a = $.data(e, "panel").options;
        var i = $.data(e, "panel").panel;
        if (t != true) {
            if (a.onBeforeDestroy.call(e) == false) {
                return;
            }
        }
        _1fa(e);
        _1e2(i);
        a.onDestroy.call(e);
    }
    function _205(e, t) {
        var a = $.data(e, "panel").options;
        var i = $.data(e, "panel").panel;
        var n = i.children("div.panel-body");
        var r = i.children("div.panel-header").find("a.panel-tool-collapse");
        if (a.collapsed == true) {
            return;
        }
        n.stop(true, true);
        if (a.onBeforeCollapse.call(e) == false) {
            return;
        }
        r.addClass("panel-tool-expand");
        if (t == true) {
            n.slideUp("normal", function() {
                a.collapsed = true;
                a.onCollapse.call(e);
            });
        } else {
            n.hide();
            a.collapsed = true;
            a.onCollapse.call(e);
        }
    }
    function _210(e, t) {
        var a = $.data(e, "panel").options;
        var i = $.data(e, "panel").panel;
        var n = i.children("div.panel-body");
        var r = i.children("div.panel-header").find("a.panel-tool-collapse");
        if (a.collapsed == false) {
            return;
        }
        n.stop(true, true);
        if (a.onBeforeExpand.call(e) == false) {
            return;
        }
        r.removeClass("panel-tool-expand");
        if (t == true) {
            n.slideDown("normal", function() {
                a.collapsed = false;
                a.onExpand.call(e);
                _1f5(e);
                _1fe(e);
            });
        } else {
            n.show();
            a.collapsed = false;
            a.onExpand.call(e);
            _1f5(e);
            _1fe(e);
        }
    }
    function _204(e) {
        var t = $.data(e, "panel").options;
        var a = $.data(e, "panel").panel;
        var i = a.children("div.panel-header").find("a.panel-tool-max");
        if (t.maximized == true) {
            return;
        }
        i.addClass("panel-tool-restore");
        if (!$.data(e, "panel").original) {
            $.data(e, "panel").original = {
                width: t.width,
                height: t.height,
                left: t.left,
                top: t.top,
                fit: t.fit
            };
        }
        t.left = 0;
        t.top = 0;
        t.fit = true;
        _1e3(e);
        t.minimized = false;
        t.maximized = true;
        t.onMaximize.call(e);
    }
    function _216(e) {
        var t = $.data(e, "panel").options;
        var a = $.data(e, "panel").panel;
        a._fit(false);
        a.hide();
        t.minimized = true;
        t.maximized = false;
        t.onMinimize.call(e);
    }
    function _219(e) {
        var t = $.data(e, "panel").options;
        var a = $.data(e, "panel").panel;
        var i = a.children("div.panel-header").find("a.panel-tool-max");
        if (t.maximized == false) {
            return;
        }
        a.show();
        i.removeClass("panel-tool-restore");
        $.extend(t, $.data(e, "panel").original);
        _1e3(e);
        t.minimized = false;
        t.maximized = false;
        $.data(e, "panel").original = null;
        t.onRestore.call(e);
    }
    function _21c(e) {
        var t = $.data(e, "panel").options;
        var a = $.data(e, "panel").panel;
        var i = $(e).panel("header");
        var n = $(e).panel("body");
        a.css(t.style);
        a.addClass(t.cls);
        if (t.border) {
            i.removeClass("panel-header-noborder");
            n.removeClass("panel-body-noborder");
        } else {
            i.addClass("panel-header-noborder");
            n.addClass("panel-body-noborder");
        }
        i.addClass(t.headerCls);
        n.addClass(t.bodyCls);
        if (t.id) {
            $(e).attr("id", t.id);
        } else {
            $(e).attr("id", "");
        }
    }
    function _220(e, t) {
        $.data(e, "panel").options.title = t;
        $(e).panel("header").find("div.panel-title").html(t);
    }
    var TO = false;
    var _223 = true;
    $(window).unbind(".panel").bind("resize.panel", function() {
        if (!_223) {
            return;
        }
        if (TO !== false) {
            clearTimeout(TO);
        }
        TO = setTimeout(function() {
            _223 = false;
            var e = $("body.layout");
            if (e.length) {
                e.layout("resize");
            } else {
                $("body").children("div.panel,div.accordion,div.tabs-container,div.layout").filter(":visible").each(function() {
                    $(this).triggerHandler("_resize");
                });
            }
            _223 = true;
            TO = false;
        }, 200);
    });
    $.fn.panel = function(a, e) {
        if (typeof a == "string") {
            return $.fn.panel.methods[a](this, e);
        }
        a = a || {};
        return this.each(function() {
            var e = $.data(this, "panel");
            var t;
            if (e) {
                t = $.extend(e.options, a);
                e.isLoaded = false;
            } else {
                t = $.extend({}, $.fn.panel.defaults, $.fn.panel.parseOptions(this), a);
                $(this).attr("title", "");
                e = $.data(this, "panel", {
                    options: t,
                    panel: _1ed(this),
                    isLoaded: false
                });
            }
            _1f0(this);
            _21c(this);
            if (t.doSize == true) {
                e.panel.css("display", "block");
                _1e3(this);
            }
            if (t.closed == true || t.minimized == true) {
                e.panel.hide();
            } else {
                _200(this);
            }
        });
    };
    $.fn.panel.methods = {
        options: function(e) {
            return $.data(e[0], "panel").options;
        },
        panel: function(e) {
            return $.data(e[0], "panel").panel;
        },
        header: function(e) {
            return $.data(e[0], "panel").panel.find(">div.panel-header");
        },
        body: function(e) {
            return $.data(e[0], "panel").panel.find(">div.panel-body");
        },
        setTitle: function(e, t) {
            return e.each(function() {
                _220(this, t);
            });
        },
        open: function(e, t) {
            return e.each(function() {
                _200(this, t);
            });
        },
        close: function(e, t) {
            return e.each(function() {
                _1f4(this, t);
            });
        },
        destroy: function(e, t) {
            return e.each(function() {
                _209(this, t);
            });
        },
        refresh: function(e, t) {
            return e.each(function() {
                var e = $.data(this, "panel");
                e.isLoaded = false;
                if (t) {
                    if (typeof t == "string") {
                        e.options.href = t;
                    } else {
                        e.options.queryParams = t;
                    }
                }
                _1f5(this);
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                _1e3(this, t);
            });
        },
        move: function(e, t) {
            return e.each(function() {
                _1e9(this, t);
            });
        },
        maximize: function(e) {
            return e.each(function() {
                _204(this);
            });
        },
        minimize: function(e) {
            return e.each(function() {
                _216(this);
            });
        },
        restore: function(e) {
            return e.each(function() {
                _219(this);
            });
        },
        collapse: function(e, t) {
            return e.each(function() {
                _205(this, t);
            });
        },
        expand: function(e, t) {
            return e.each(function() {
                _210(this, t);
            });
        }
    };
    $.fn.panel.parseOptions = function(e) {
        var t = $(e);
        return $.extend({}, $.parser.parseOptions(e, [ "id", "width", "height", "left", "top", "title", "titleWidth", "iconCls", "cls", "headerCls", "bodyCls", "tools", "href", "method", {
            cache: "boolean",
            fit: "boolean",
            border: "boolean",
            noheader: "boolean"
        }, {
            collapsible: "boolean",
            minimizable: "boolean",
            maximizable: "boolean"
        }, {
            closable: "boolean",
            collapsed: "boolean",
            minimized: "boolean",
            maximized: "boolean",
            closed: "boolean"
        } ]), {
            loadingMessage: t.attr("loadingMessage") != undefined ? t.attr("loadingMessage") : undefined
        });
    };
    $.fn.panel.defaults = {
        isTopZindex: false,
        changeIdStr: "",
        id: null,
        title: null,
        iconCls: null,
        width: "auto",
        height: "auto",
        left: null,
        top: null,
        cls: null,
        headerCls: null,
        bodyCls: null,
        style: {},
        href: null,
        cache: true,
        fit: false,
        border: true,
        doSize: true,
        noheader: false,
        content: null,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: false,
        collapsed: false,
        minimized: false,
        maximized: false,
        closed: false,
        tools: null,
        queryParams: {},
        method: "get",
        href: null,
        loadingMessage: "Loading...",
        loader: function(e, t, a) {
            var i = $(this).panel("options");
            if (!i.href) {
                return false;
            }
            $.ajax({
                type: i.method,
                url: i.href,
                cache: false,
                data: e,
                dataType: "html",
                success: function(e) {
                    t(e);
                },
                error: function() {
                    a.apply(this, arguments);
                }
            });
        },
        extractor: function(e) {
            var t = /<body[^>]*>((.|[\n\r])*)<\/body>/im;
            var a = t.exec(e);
            if (a) {
                return a[1];
            } else {
                return e;
            }
        },
        onBeforeLoad: function(e) {},
        onLoad: function() {},
        onLoadError: function() {},
        onBeforeOpen: function() {},
        onOpen: function() {},
        onBeforeClose: function() {},
        onClose: function() {},
        onBeforeDestroy: function() {},
        onDestroy: function() {},
        onResize: function(e, t) {},
        onMove: function(e, t) {},
        onMaximize: function() {},
        onRestore: function() {},
        onMinimize: function() {},
        onBeforeCollapse: function() {},
        onBeforeExpand: function() {},
        onCollapse: function() {},
        onExpand: function() {}
    };
})(jQuery);

(function(o) {
    function i(e, t) {
        var a = o.data(e, "window").options;
        if (t) {
            o.extend(a, t);
        }
        o(e).panel("resize", a);
    }
    function s(e, t) {
        var a = o.data(e, "window");
        if (t) {
            if (t.left != null) {
                a.options.left = t.left;
            }
            if (t.top != null) {
                a.options.top = t.top;
            }
        }
        o(e).panel("move", a.options);
        if (a.shadow) {
            a.shadow.css({
                left: a.options.left,
                top: a.options.top
            });
        }
    }
    function r(e, t) {
        var a = o.data(e, "window");
        var i = a.options;
        var n = i.width;
        if (isNaN(n)) {
            n = a.window._outerWidth();
        }
        if (i.inline) {
            var r = a.window.parent();
            i.left = (r.width() - n) / 2 + r.scrollLeft();
        } else {
            i.left = (o(window)._outerWidth() - n) / 2 + o(document).scrollLeft();
        }
        if (t) {
            s(e);
        }
    }
    function d(e, t) {
        var a = o.data(e, "window");
        var i = a.options;
        var n = i.height;
        if (isNaN(n)) {
            n = a.window._outerHeight();
        }
        if (i.inline) {
            var r = a.window.parent();
            i.top = (r.height() - n) / 2 + r.scrollTop();
        } else {
            i.top = (o(window)._outerHeight() - n) / 2 + o(document).scrollTop();
        }
        if (t) {
            s(e);
        }
    }
    function n(i) {
        var n = o.data(i, "window");
        var e = n.options.closed;
        var t = o(i).panel(o.extend({}, n.options, {
            border: false,
            doSize: true,
            closed: true,
            cls: "window",
            headerCls: "window-header",
            bodyCls: "window-body " + (n.options.noheader ? "window-body-noheader" : ""),
            onBeforeDestroy: function() {
                if (n.options.onBeforeDestroy.call(i) == false) {
                    return false;
                }
                if (n.shadow) {
                    n.shadow.remove();
                }
                if (n.mask) {
                    n.mask.remove();
                }
            },
            onClose: function() {
                if (n.shadow) {
                    n.shadow.hide();
                }
                if (n.mask) {
                    n.mask.hide();
                }
                n.options.onClose.call(i);
            },
            onOpen: function() {
                if (n.mask) {
                    n.mask.css({
                        display: "block",
                        zIndex: o.fn.window.defaults.zIndex++
                    });
                }
                if (n.shadow) {
                    n.shadow.css({
                        display: "block",
                        zIndex: o.fn.window.defaults.zIndex++,
                        left: n.options.left,
                        top: n.options.top,
                        width: n.window._outerWidth(),
                        height: n.window._outerHeight()
                    });
                }
                n.window.css("z-index", o.fn.window.defaults.zIndex++);
                n.options.onOpen.call(i);
            },
            onResize: function(e, t) {
                var a = o(this).panel("options");
                o.extend(n.options, {
                    width: a.width,
                    height: a.height,
                    left: a.left,
                    top: a.top
                });
                if (n.shadow) {
                    n.shadow.css({
                        left: n.options.left,
                        top: n.options.top,
                        width: n.window._outerWidth(),
                        height: n.window._outerHeight()
                    });
                }
                n.options.onResize.call(i, e, t);
            },
            onMinimize: function() {
                if (n.shadow) {
                    n.shadow.hide();
                }
                if (n.mask) {
                    n.mask.hide();
                }
                n.options.onMinimize.call(i);
            },
            onBeforeCollapse: function() {
                if (n.options.onBeforeCollapse.call(i) == false) {
                    return false;
                }
                if (n.shadow) {
                    n.shadow.hide();
                }
            },
            onExpand: function() {
                if (n.shadow) {
                    n.shadow.show();
                }
                n.options.onExpand.call(i);
            }
        }));
        n.window = t.panel("panel");
        if (n.mask) {
            n.mask.remove();
        }
        if (n.options.modal == true) {
            var a = "";
            if (n.options.isTopZindex) {
                if (!!window.ActiveXObject || "ActiveXObject" in window) {
                    a = '<iframe style="position:absolute;z-index:-1;width:100%;height:100%;top:0;left:0;scrolling:no;" frameborder="0"></iframe>';
                }
            }
            n.mask = o('<div class="window-mask">' + a + "</div>").insertAfter(n.window);
            n.mask.css({
                width: n.options.inline ? n.mask.parent().width() : c().width,
                height: n.options.inline ? n.mask.parent().height() : c().height,
                display: "none"
            });
        }
        if (n.shadow) {
            n.shadow.remove();
        }
        if (n.options.shadow == true) {
            n.shadow = o('<div class="window-shadow"></div>').insertAfter(n.window);
            n.shadow.css({
                display: "none"
            });
        }
        if (n.options.left == null) {
            r(i);
        }
        if (n.options.top == null) {
            d(i);
        }
        s(i);
        if (!e) {
            t.window("open");
        }
    }
    function l(t) {
        var a = o.data(t, "window");
        a.window.draggable({
            handle: ">div.panel-header>div.panel-title",
            disabled: a.options.draggable == false,
            onStartDrag: function(e) {
                if (a.mask) {
                    a.mask.css("z-index", o.fn.window.defaults.zIndex++);
                }
                if (a.shadow) {
                    a.shadow.css("z-index", o.fn.window.defaults.zIndex++);
                }
                a.window.css("z-index", o.fn.window.defaults.zIndex++);
                if (!a.proxy) {
                    a.proxy = o('<div class="window-proxy"></div>').insertAfter(a.window);
                }
                a.proxy.css({
                    display: "none",
                    zIndex: o.fn.window.defaults.zIndex++,
                    left: e.data.left,
                    top: e.data.top
                });
                a.proxy._outerWidth(a.window._outerWidth());
                a.proxy._outerHeight(a.window._outerHeight());
                setTimeout(function() {
                    if (a.proxy) {
                        a.proxy.show();
                    }
                }, 500);
            },
            onDrag: function(e) {
                a.proxy.css({
                    display: "block",
                    left: e.data.left,
                    top: e.data.top
                });
                return false;
            },
            onStopDrag: function(e) {
                a.options.left = e.data.left;
                a.options.top = e.data.top;
                o(t).window("move");
                a.proxy.remove();
                a.proxy = null;
            }
        });
        a.window.resizable({
            disabled: a.options.resizable == false,
            onStartResize: function(e) {
                a.pmask = o('<div class="window-proxy-mask"></div>').insertAfter(a.window);
                a.pmask.css({
                    zIndex: o.fn.window.defaults.zIndex++,
                    left: e.data.left,
                    top: e.data.top,
                    width: a.window._outerWidth(),
                    height: a.window._outerHeight()
                });
                if (!a.proxy) {
                    a.proxy = o('<div class="window-proxy"></div>').insertAfter(a.window);
                }
                a.proxy.css({
                    zIndex: o.fn.window.defaults.zIndex++,
                    left: e.data.left,
                    top: e.data.top
                });
                a.proxy._outerWidth(e.data.width);
                a.proxy._outerHeight(e.data.height);
            },
            onResize: function(e) {
                a.proxy.css({
                    left: e.data.left,
                    top: e.data.top
                });
                a.proxy._outerWidth(e.data.width);
                a.proxy._outerHeight(e.data.height);
                return false;
            },
            onStopResize: function(e) {
                o.extend(a.options, {
                    left: e.data.left,
                    top: e.data.top,
                    width: e.data.width,
                    height: e.data.height
                });
                i(t);
                a.pmask.remove();
                a.pmask = null;
                a.proxy.remove();
                a.proxy = null;
            }
        });
    }
    function c() {
        if (document.compatMode == "BackCompat") {
            return {
                width: Math.max(document.body.scrollWidth, document.body.clientWidth),
                height: Math.max(document.body.scrollHeight, document.body.clientHeight)
            };
        } else {
            return {
                width: Math.max(document.documentElement.scrollWidth, document.documentElement.clientWidth),
                height: Math.max(document.documentElement.scrollHeight, document.documentElement.clientHeight)
            };
        }
    }
    o(window).resize(function() {
        o("body>div.window-mask").css({
            width: o(window)._outerWidth(),
            height: o(window)._outerHeight()
        });
        setTimeout(function() {
            o("body>div.window-mask").css({
                width: c().width,
                height: c().height
            });
        }, 50);
    });
    o.fn.window = function(t, e) {
        if (typeof t == "string") {
            var a = o.fn.window.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.panel(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = o.data(this, "window");
            if (e) {
                o.extend(e.options, t);
            } else {
                e = o.data(this, "window", {
                    options: o.extend({}, o.fn.window.defaults, o.fn.window.parseOptions(this), t)
                });
                if (!e.options.inline) {
                    document.body.appendChild(this);
                }
            }
            n(this);
            l(this);
        });
    };
    o.fn.window.methods = {
        options: function(e) {
            var t = e.panel("options");
            var a = o.data(e[0], "window").options;
            return o.extend(a, {
                closed: t.closed,
                collapsed: t.collapsed,
                minimized: t.minimized,
                maximized: t.maximized
            });
        },
        window: function(e) {
            return o.data(e[0], "window").window;
        },
        resize: function(e, t) {
            return e.each(function() {
                i(this, t);
            });
        },
        move: function(e, t) {
            return e.each(function() {
                s(this, t);
            });
        },
        hcenter: function(e) {
            return e.each(function() {
                r(this, true);
            });
        },
        vcenter: function(e) {
            return e.each(function() {
                d(this, true);
            });
        },
        center: function(e) {
            return e.each(function() {
                r(this);
                d(this);
                s(this);
            });
        }
    };
    o.fn.window.parseOptions = function(e) {
        return o.extend({}, o.fn.panel.parseOptions(e), o.parser.parseOptions(e, [ {
            draggable: "boolean",
            resizable: "boolean",
            shadow: "boolean",
            modal: "boolean",
            inline: "boolean"
        } ]));
    };
    o.fn.window.defaults = o.extend({}, o.fn.panel.defaults, {
        zIndex: 9e3,
        draggable: true,
        resizable: true,
        shadow: true,
        modal: false,
        inline: false,
        title: "New Window",
        collapsible: true,
        minimizable: true,
        maximizable: true,
        closable: true,
        closed: false
    });
})(jQuery);

(function($) {
    function _260(e) {
        var t = document.createElement("div");
        while (e.firstChild) {
            t.appendChild(e.firstChild);
        }
        e.appendChild(t);
        var a = $(t);
        a.attr("style", $(e).attr("style"));
        $(e).removeAttr("style").css("overflow", "hidden");
        a.panel({
            border: false,
            doSize: false,
            bodyCls: "dialog-content"
        });
        return a;
    }
    function _263(_264) {
        var opts = $.data(_264, "dialog").options;
        var _265 = $.data(_264, "dialog").contentPanel;
        if (opts.toolbar) {
            if ($.isArray(opts.toolbar)) {
                $(_264).find("div.dialog-toolbar").remove();
                var _266 = $('<div class="dialog-toolbar"><table cellspacing="0" cellpadding="0"><tr></tr></table></div>').prependTo(_264);
                var tr = _266.find("tr");
                for (var i = 0; i < opts.toolbar.length; i++) {
                    var btn = opts.toolbar[i];
                    if (btn == "-") {
                        $('<td><div class="dialog-tool-separator"></div></td>').appendTo(tr);
                    } else {
                        var td = $("<td></td>").appendTo(tr);
                        var tool = $('<a href="javascript:void(0)"></a>').appendTo(td);
                        tool[0].onclick = eval(btn.handler || function() {});
                        tool.linkbutton($.extend({}, btn, {
                            plain: true
                        }));
                    }
                }
            } else {
                $(opts.toolbar).addClass("dialog-toolbar").prependTo(_264);
                $(opts.toolbar).show();
            }
        } else {
            $(_264).find("div.dialog-toolbar").remove();
        }
        if (opts.buttons) {
            if ($.isArray(opts.buttons)) {
                $(_264).find("div.dialog-button").remove();
                var _267 = $('<div class="dialog-button"></div>').appendTo(_264);
                for (var i = 0; i < opts.buttons.length; i++) {
                    var p = opts.buttons[i];
                    var _268 = $('<a href="javascript:void(0)"></a>').appendTo(_267);
                    if (p.handler) {
                        _268[0].onclick = p.handler;
                    }
                    _268.linkbutton(p);
                }
            } else {
                $(opts.buttons).addClass("dialog-button").appendTo(_264);
                $(opts.buttons).show();
            }
        } else {
            $(_264).find("div.dialog-button").remove();
        }
        var _269 = opts.href;
        var _26a = opts.content;
        opts.href = null;
        opts.content = null;
        _265.panel({
            closed: opts.closed,
            cache: opts.cache,
            href: _269,
            content: _26a,
            onLoad: function() {
                if (opts.height == "auto") {
                    $(_264).window("resize");
                }
                opts.onLoad.apply(_264, arguments);
            }
        });
        $(_264).window($.extend({}, opts, {
            onOpen: function() {
                if (_265.panel("options").closed) {
                    _265.panel("open");
                }
                if (opts.onOpen) {
                    opts.onOpen.call(_264);
                }
            },
            onResize: function(e, t) {
                var a = $(_264);
                _265.panel("panel").show();
                _265.panel("resize", {
                    width: a.width(),
                    height: t == "auto" ? "auto" : a.height() - a.children("div.dialog-toolbar")._outerHeight() - a.children("div.dialog-button")._outerHeight()
                });
                if (opts.onResize) {
                    opts.onResize.call(_264, e, t);
                }
            }
        }));
        opts.href = _269;
        opts.content = _26a;
    }
    function _26e(e, t) {
        var a = $.data(e, "dialog").contentPanel;
        a.panel("refresh", t);
    }
    $.fn.dialog = function(t, e) {
        if (typeof t == "string") {
            var a = $.fn.dialog.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.window(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = $.data(this, "dialog");
            if (e) {
                $.extend(e.options, t);
            } else {
                $.data(this, "dialog", {
                    options: $.extend({}, $.fn.dialog.defaults, $.fn.dialog.parseOptions(this), t),
                    contentPanel: _260(this)
                });
            }
            _263(this);
        });
    };
    $.fn.dialog.methods = {
        options: function(e) {
            var t = $.data(e[0], "dialog").options;
            var a = e.panel("options");
            $.extend(t, {
                closed: a.closed,
                collapsed: a.collapsed,
                minimized: a.minimized,
                maximized: a.maximized
            });
            var i = $.data(e[0], "dialog").contentPanel;
            return t;
        },
        dialog: function(e) {
            return e.window("window");
        },
        refresh: function(e, t) {
            return e.each(function() {
                _26e(this, t);
            });
        }
    };
    $.fn.dialog.parseOptions = function(e) {
        return $.extend({}, $.fn.window.parseOptions(e), $.parser.parseOptions(e, [ "toolbar", "buttons" ]));
    };
    $.fn.dialog.defaults = $.extend({}, $.fn.window.defaults, {
        title: "New Dialog",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        toolbar: null,
        buttons: null
    });
})(jQuery);

(function($) {
    function show(e, t, a, i) {
        var n = $(e).window("window");
        if (!n) {
            return;
        }
        switch (t) {
          case null:
            n.show();
            break;

          case "slide":
            n.slideDown(a);
            break;

          case "fade":
            n.fadeIn(a);
            break;

          case "show":
            n.show(a);
            break;
        }
        var r = null;
        if (i > 0) {
            r = setTimeout(function() {
                hide(e, t, a);
            }, i);
        }
        n.hover(function() {
            if (r) {
                clearTimeout(r);
            }
        }, function() {
            if (i > 0) {
                r = setTimeout(function() {
                    hide(e, t, a);
                }, i);
            }
        });
    }
    function hide(e, t, a) {
        if (e.locked == true) {
            return;
        }
        e.locked = true;
        var i = $(e).window("window");
        if (!i) {
            return;
        }
        switch (t) {
          case null:
            i.hide();
            break;

          case "slide":
            i.slideUp(a);
            break;

          case "fade":
            i.fadeOut(a);
            break;

          case "show":
            i.hide(a);
            break;
        }
        setTimeout(function() {
            $(e).window("destroy");
        }, a);
    }
    function _27d(e) {
        var t = $.extend({}, $.fn.window.defaults, {
            collapsible: false,
            minimizable: false,
            maximizable: false,
            shadow: false,
            draggable: false,
            resizable: false,
            closed: true,
            style: {
                left: "",
                top: "",
                right: 0,
                zIndex: $.fn.window.defaults.zIndex++,
                bottom: -document.body.scrollTop - document.documentElement.scrollTop
            },
            onBeforeOpen: function() {
                show(this, t.showType, t.showSpeed, t.timeout);
                return false;
            },
            onBeforeClose: function() {
                hide(this, t.showType, t.showSpeed);
                return false;
            }
        }, {
            title: "",
            width: 250,
            height: 100,
            showType: "slide",
            showSpeed: 600,
            msg: "",
            timeout: 4e3
        }, e);
        t.style.zIndex = $.fn.window.defaults.zIndex++;
        var a = $('<div class="messager-body"></div>').html(t.msg).appendTo("body");
        a.window(t);
        a.window("window").css(t.style);
        a.window("open");
        return a;
    }
    function _27f(_280, _281, _282) {
        var win = $('<div class="messager-body"></div>').appendTo("body");
        win.append(_281);
        if (_282) {
            var tb = $('<div class="messager-button"></div>').appendTo(win);
            for (var _283 in _282) {
                $("<a></a>").attr("href", "javascript:void(0)").text(_283).css("margin-left", 10).bind("click", eval(_282[_283])).appendTo(tb).linkbutton();
            }
            win.on("keydown", function(e) {
                if (tb.children().length > 1) {
                    if (e.which == 37) {
                        e.stopPropagation();
                        tb.children().removeClass("active").eq(0).addClass("active");
                    }
                    if (e.which == 39) {
                        tb.children().removeClass("active").eq(1).addClass("active");
                    }
                }
                if (e.which == 32 || e.which == 13) {
                    e.stopPropagation();
                    if (tb.children(".active").length > 0) {
                        tb.children(".active").trigger("click");
                    } else {
                        _282[$.messager.defaults.ok]();
                    }
                    return false;
                }
                if (_282[$.messager.defaults.cancel]) {
                    if (e.which == 27) {
                        e.stopPropagation();
                        _282[$.messager.defaults.cancel]();
                        return false;
                    }
                }
            });
        }
        win.window({
            isTopZindex: true,
            closable: false,
            title: _280,
            noheader: _280 ? false : true,
            width: 300,
            height: "auto",
            modal: true,
            collapsible: false,
            minimizable: false,
            maximizable: false,
            resizable: false,
            onClose: function() {
                setTimeout(function() {
                    win.window("destroy");
                }, 100);
            }
        });
        win.window("window").addClass("messager-window");
        win.children("div.messager-button").children("a:first").focus();
        return win;
    }
    $.messager = {
        show: function(e) {
            return _27d(e);
        },
        alert: function(e, t, a, i) {
            var n = '<div style="margin-left:42px;">' + t + "</div>";
            switch (a) {
              case "error":
                n = '<div class="messager-icon messager-error"></div>' + n;
                break;

              case "info":
                n = '<div class="messager-icon messager-info"></div>' + n;
                break;

              case "question":
                n = '<div class="messager-icon messager-question"></div>' + n;
                break;

              case "warning":
                n = '<div class="messager-icon messager-warning"></div>' + n;
                break;

              case "success":
                n = '<div class="messager-icon messager-success"></div>' + n;
                break;
            }
            n += '<div style="clear:both;"/>';
            var r = {};
            r[$.messager.defaults.ok] = function() {
                o.window("close");
                if (i) {
                    i();
                    return false;
                }
            };
            var o = _27f(e, n, r);
            return o;
        },
        confirm: function(e, t, a) {
            var i = '<div class="messager-icon messager-question"></div>' + '<div style="margin-left:42px;">' + t + "</div>" + '<div style="clear:both;"/>';
            var n = {};
            n[$.messager.defaults.ok] = function() {
                r.window("close");
                if (a) {
                    a(true);
                    return false;
                }
            };
            n[$.messager.defaults.cancel] = function() {
                r.window("close");
                if (a) {
                    a(false);
                    return false;
                }
            };
            var r = _27f(e, i, n);
            return r;
        },
        prompt: function(e, t, a) {
            var i = '<div class="messager-icon messager-question"></div>' + '<div style="margin-left:42px;">' + t + "</div>" + "<br/>" + '<div style="clear:both;"/>' + '<div><input class="messager-input" type="text"/></div>';
            var n = {};
            n[$.messager.defaults.ok] = function() {
                r.window("close");
                if (a) {
                    a($(".messager-input", r).val());
                    return false;
                }
            };
            n[$.messager.defaults.cancel] = function() {
                r.window("close");
                if (a) {
                    a();
                    return false;
                }
            };
            var r = _27f(e, i, n);
            r.children("input.messager-input").focus();
            return r;
        },
        progress: function(e) {
            var t = {
                bar: function() {
                    return $("body>div.messager-window").find("div.messager-p-bar");
                },
                close: function() {
                    var e = $("body>div.messager-window>div.messager-body:has(div.messager-progress)");
                    if (e.length) {
                        e.window("close");
                    }
                }
            };
            if (typeof e == "string") {
                var a = t[e];
                return a();
            }
            var i = $.extend({
                title: "",
                msg: "",
                text: undefined,
                interval: 300
            }, e || {});
            var n = '<div class="messager-progress"><div class="messager-p-msg"></div><div class="messager-p-bar"></div></div>';
            var r = _27f(i.title, n, null);
            r.find("div.messager-p-msg").html(i.msg);
            var o = r.find("div.messager-p-bar");
            o.progressbar({
                text: i.text
            });
            r.window({
                closable: false,
                onClose: function() {
                    if (this.timer) {
                        clearInterval(this.timer);
                    }
                    $(this).window("destroy");
                }
            });
            if (i.interval) {
                r[0].timer = setInterval(function() {
                    var e = o.progressbar("getValue");
                    e += 10;
                    if (e > 100) {
                        e = 0;
                    }
                    o.progressbar("setValue", e);
                }, i.interval);
            }
            return r;
        },
        popover: function(e) {
            var t = {
                style: {
                    top: "",
                    left: ""
                },
                msg: "",
                type: "error",
                timeout: 3e3,
                showSpeed: "fast",
                showType: "slide"
            };
            var a = $.extend({}, t, e);
            var i = '<div class="messager-popover ' + a.type + '" style="display:none;">            <span class="messager-popover-icon ' + a.type + '"/><span class="content">' + a.msg + '</span>            <span class="close"></span>            </div>';
            var n = $(i).appendTo("body");
            if (a.style.left == "") {
                a.style.left = document.body.clientWidth / 2 - n.width() / 2;
            }
            if (a.style.top == "") {
                a.style.top = document.body.clientHeight / 2 - n.height() / 2;
            }
            n.css(a.style);
            switch (a.showType) {
              case null:
                n.show();
                break;

              case "slide":
                n.slideDown(a.showSpeed);
                break;

              case "fade":
                n.fadeIn(a.showSpeed);
                break;

              case "show":
                n.show(a.showSpeed);
                break;
            }
            n.find(".close").click(function() {
                n.remove();
            });
            if (a.timeout > 0) {
                var r = setTimeout(function() {
                    switch (a.showType) {
                      case null:
                        n.hide();
                        break;

                      case "slide":
                        n.slideUp(a.showSpeed);
                        break;

                      case "fade":
                        n.fadeOut(a.showSpeed);
                        break;

                      case "show":
                        n.hide(a.showSpeed);
                        break;
                    }
                    setTimeout(function() {
                        n.remove();
                    }, a.timeout);
                }, a.timeout);
            }
        }
    };
    $.messager.defaults = {
        ok: "Ok",
        cancel: "Cancel"
    };
})(jQuery);

(function(c) {
    function l(e) {
        var t = c.data(e, "accordion");
        var a = t.options;
        var s = t.panels;
        var d = c(e);
        a.fit ? c.extend(a, d._fit()) : d._fit(false);
        if (!isNaN(a.width)) {
            d._outerWidth(a.width);
        } else {
            d.css("width", "");
        }
        var l = 0;
        var i = "auto";
        var n = d.find(">div.panel>div.accordion-header");
        if (n.length) {
            l = c(n[0]).css("height", "")._outerHeight();
        }
        if (!isNaN(a.height)) {
            d._outerHeight(a.height);
            i = d.height() - l * n.length;
        } else {
            d.css("height", "");
        }
        if (d.hasClass("accordion-gray")) {
            i -= 4 * (n.length - 1) + 1;
        }
        r(true, i - r(false) + 1);
        function r(e, t) {
            var a = 0;
            for (var i = 0; i < s.length; i++) {
                var n = s[i];
                var r = n.panel("header")._outerHeight(l);
                if (n.panel("options").collapsible == e) {
                    var o = isNaN(t) ? undefined : t + l * r.length;
                    n.panel("resize", {
                        width: d.width(),
                        height: e ? o : undefined
                    });
                    a += n.panel("panel").outerHeight() - l;
                }
            }
            return a;
        }
    }
    function n(e, t, a, i) {
        var n = c.data(e, "accordion").panels;
        var r = [];
        for (var o = 0; o < n.length; o++) {
            var s = n[o];
            if (t) {
                if (s.panel("options")[t] == a) {
                    r.push(s);
                }
            } else {
                if (s[0] == c(a)[0]) {
                    return o;
                }
            }
        }
        if (t) {
            return i ? r : r.length ? r[0] : null;
        } else {
            return -1;
        }
    }
    function s(e) {
        return n(e, "collapsed", false, true);
    }
    function u(e) {
        var t = s(e);
        return t.length ? t[0] : null;
    }
    function f(e, t) {
        return n(e, null, t);
    }
    function h(e, t) {
        var a = c.data(e, "accordion").panels;
        if (typeof t == "number") {
            if (t < 0 || t >= a.length) {
                return null;
            } else {
                return a[t];
            }
        }
        return n(e, "title", t);
    }
    function a(e) {
        var t = c.data(e, "accordion").options;
        var a = c(e);
        if (t.border) {
            a.removeClass("accordion-noborder");
        } else {
            a.addClass("accordion-noborder");
        }
    }
    function i(i) {
        var a = c.data(i, "accordion");
        var e = c(i);
        e.addClass("accordion");
        a.panels = [];
        e.children("div").each(function() {
            var e = c.extend({}, c.parser.parseOptions(this), {
                selected: c(this).attr("selected") ? true : undefined
            });
            var t = c(this);
            a.panels.push(t);
            o(i, t, e);
        });
        e.bind("_resize", function(e, t) {
            var a = c.data(i, "accordion").options;
            if (a.fit == true || t) {
                l(i);
            }
            return false;
        });
    }
    function o(i, t, n) {
        var r = c.data(i, "accordion").options;
        t.panel(c.extend({}, {
            collapsible: true,
            minimizable: false,
            maximizable: false,
            closable: false,
            doSize: false,
            collapsed: true,
            headerCls: "accordion-header",
            bodyCls: "accordion-body"
        }, n, {
            onBeforeExpand: function() {
                if (n.onBeforeExpand) {
                    if (n.onBeforeExpand.call(this) == false) {
                        return false;
                    }
                }
                if (!r.multiple) {
                    var e = c.grep(s(i), function(e) {
                        return e.panel("options").collapsible;
                    });
                    for (var t = 0; t < e.length; t++) {
                        d(i, f(i, e[t]));
                    }
                }
                var a = c(this).panel("header");
                a.addClass("accordion-header-selected");
                a.find(".accordion-collapse").removeClass("accordion-expand");
            },
            onExpand: function() {
                if (n.onExpand) {
                    n.onExpand.call(this);
                }
                r.onSelect.call(i, c(this).panel("options").title, f(i, this));
            },
            onBeforeCollapse: function() {
                if (n.onBeforeCollapse) {
                    if (n.onBeforeCollapse.call(this) == false) {
                        return false;
                    }
                }
                var e = c(this).panel("header");
                e.removeClass("accordion-header-selected");
                e.find(".accordion-collapse").addClass("accordion-expand");
            },
            onCollapse: function() {
                if (n.onCollapse) {
                    n.onCollapse.call(this);
                }
                r.onUnselect.call(i, c(this).panel("options").title, f(i, this));
            }
        }));
        var e = t.panel("header");
        var a = e.children("div.panel-tool");
        a.children("a.panel-tool-collapse").hide();
        var o = c('<a href="javascript:void(0)"></a>').addClass("accordion-collapse accordion-expand").appendTo(a);
        o.bind("click", function() {
            var e = f(i, t);
            if (t.panel("options").collapsed) {
                p(i, e);
            } else {
                d(i, e);
            }
            return false;
        });
        t.panel("options").collapsible ? o.show() : o.hide();
        e.click(function() {
            c(this).find("a.accordion-collapse:visible").triggerHandler("click");
            return false;
        });
    }
    function p(e, t) {
        var a = h(e, t);
        if (!a) {
            return;
        }
        v(e);
        var i = c.data(e, "accordion").options;
        a.panel("expand", i.animate);
    }
    function d(e, t) {
        var a = h(e, t);
        if (!a) {
            return;
        }
        v(e);
        var i = c.data(e, "accordion").options;
        a.panel("collapse", i.animate);
    }
    function r(a) {
        var i = c.data(a, "accordion").options;
        var e = n(a, "selected", true);
        if (e) {
            t(f(a, e));
        } else {
            t(i.selected);
        }
        function t(e) {
            var t = i.animate;
            i.animate = false;
            p(a, e);
            i.animate = t;
        }
    }
    function v(e) {
        var t = c.data(e, "accordion").panels;
        for (var a = 0; a < t.length; a++) {
            t[a].stop(true, true);
        }
    }
    function g(e, t) {
        var a = c.data(e, "accordion");
        var i = a.options;
        var n = a.panels;
        if (t.selected == undefined) {
            t.selected = true;
        }
        v(e);
        var r = c("<div></div>").appendTo(e);
        n.push(r);
        o(e, r, t);
        l(e);
        i.onAdd.call(e, t.title, n.length - 1);
        if (t.selected) {
            p(e, n.length - 1);
        }
    }
    function b(e, t) {
        var a = c.data(e, "accordion");
        var i = a.options;
        var n = a.panels;
        v(e);
        var r = h(e, t);
        var o = r.panel("options").title;
        var s = f(e, r);
        if (!r) {
            return;
        }
        if (i.onBeforeRemove.call(e, o, s) == false) {
            return;
        }
        n.splice(s, 1);
        r.panel("destroy");
        if (n.length) {
            l(e);
            var d = u(e);
            if (!d) {
                p(e, 0);
            }
        }
        i.onRemove.call(e, o, s);
    }
    c.fn.accordion = function(t, e) {
        if (typeof t == "string") {
            return c.fn.accordion.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = c.data(this, "accordion");
            if (e) {
                c.extend(e.options, t);
            } else {
                c.data(this, "accordion", {
                    options: c.extend({}, c.fn.accordion.defaults, c.fn.accordion.parseOptions(this), t),
                    accordion: c(this).addClass("accordion"),
                    panels: []
                });
                i(this);
            }
            a(this);
            l(this);
            r(this);
        });
    };
    c.fn.accordion.methods = {
        options: function(e) {
            return c.data(e[0], "accordion").options;
        },
        panels: function(e) {
            return c.data(e[0], "accordion").panels;
        },
        resize: function(e) {
            return e.each(function() {
                l(this);
            });
        },
        getSelections: function(e) {
            return s(e[0]);
        },
        getSelected: function(e) {
            return u(e[0]);
        },
        getPanel: function(e, t) {
            return h(e[0], t);
        },
        getPanelIndex: function(e, t) {
            return f(e[0], t);
        },
        select: function(e, t) {
            return e.each(function() {
                p(this, t);
            });
        },
        unselect: function(e, t) {
            return e.each(function() {
                d(this, t);
            });
        },
        add: function(e, t) {
            return e.each(function() {
                g(this, t);
            });
        },
        remove: function(e, t) {
            return e.each(function() {
                b(this, t);
            });
        }
    };
    c.fn.accordion.parseOptions = function(e) {
        var t = c(e);
        return c.extend({}, c.parser.parseOptions(e, [ "width", "height", {
            fit: "boolean",
            border: "boolean",
            animate: "boolean",
            multiple: "boolean",
            selected: "number"
        } ]));
    };
    c.fn.accordion.defaults = {
        width: "auto",
        height: "auto",
        fit: false,
        border: true,
        animate: true,
        multiple: false,
        selected: 0,
        onSelect: function(e, t) {},
        onUnselect: function(e, t) {},
        onAdd: function(e, t) {},
        onBeforeRemove: function(e, t) {},
        onRemove: function(e, t) {}
    };
})(jQuery);

(function($) {
    function setScrollers(e) {
        var t = $.data(e, "tabs").options;
        if (t.tabPosition == "left" || t.tabPosition == "right" || !t.showHeader) {
            return;
        }
        var a = $(e).children("div.tabs-header");
        var i = a.children("div.tabs-tool");
        var n = a.children("div.tabs-scroller-left");
        var r = a.children("div.tabs-scroller-right");
        var o = a.children("div.tabs-wrap");
        var s = a.outerHeight();
        if (t.plain) {
            s -= s - a.height();
        }
        i._outerHeight(s);
        var d = 0;
        $("ul.tabs li", a).each(function() {
            d += $(this).outerWidth(true);
        });
        var l = a.width() - i._outerWidth();
        if (d > l) {
            n.add(r).show()._outerHeight(s);
            if (t.toolPosition == "left") {
                i.css({
                    left: n.outerWidth(),
                    right: ""
                });
                o.css({
                    marginLeft: n.outerWidth() + i._outerWidth(),
                    marginRight: r._outerWidth(),
                    width: l - n.outerWidth() - r.outerWidth()
                });
            } else {
                i.css({
                    left: "",
                    right: r.outerWidth()
                });
                o.css({
                    marginLeft: n.outerWidth(),
                    marginRight: r.outerWidth() + i._outerWidth(),
                    width: l - n.outerWidth() - r.outerWidth()
                });
            }
        } else {
            n.add(r).hide();
            if (t.toolPosition == "left") {
                i.css({
                    left: 0,
                    right: ""
                });
                o.css({
                    marginLeft: i._outerWidth(),
                    marginRight: 0,
                    width: l
                });
            } else {
                i.css({
                    left: "",
                    right: 0
                });
                o.css({
                    marginLeft: 0,
                    marginRight: i._outerWidth(),
                    width: l
                });
            }
        }
    }
    function addTools(container) {
        var opts = $.data(container, "tabs").options;
        var header = $(container).children("div.tabs-header");
        if (opts.tools) {
            if (typeof opts.tools == "string") {
                $(opts.tools).addClass("tabs-tool").appendTo(header);
                $(opts.tools).show();
            } else {
                header.children("div.tabs-tool").remove();
                var tools = $('<div class="tabs-tool"><table cellspacing="0" cellpadding="0" style="height:100%"><tr></tr></table></div>').appendTo(header);
                var tr = tools.find("tr");
                for (var i = 0; i < opts.tools.length; i++) {
                    var td = $("<td></td>").appendTo(tr);
                    var tool = $('<a href="javascript:void(0);"></a>').appendTo(td);
                    tool[0].onclick = eval(opts.tools[i].handler || function() {});
                    tool.linkbutton($.extend({}, opts.tools[i], {
                        plain: true
                    }));
                }
            }
        } else {
            header.children("div.tabs-tool").remove();
        }
    }
    function setSize(e) {
        var t = $.data(e, "tabs");
        var a = t.options;
        var i = $(e);
        a.fit ? $.extend(a, i._fit()) : i._fit(false);
        i.width(a.width).height(a.height);
        var n = $(e).children("div.tabs-header");
        var r = $(e).children("div.tabs-panels");
        var o = n.find("div.tabs-wrap");
        var s = o.find(".tabs");
        for (var d = 0; d < t.tabs.length; d++) {
            var l = t.tabs[d].panel("options");
            var c = l.tab.find("a.tabs-inner");
            var u = parseInt(l.tabWidth || a.tabWidth) || undefined;
            if (u) {
                c._outerWidth(u);
            } else {
                c.css("width", "");
            }
            c._outerHeight(a.tabHeight);
            c.css("lineHeight", c.height() + "px");
        }
        if (a.tabPosition == "left" || a.tabPosition == "right") {
            n._outerWidth(a.showHeader ? a.headerWidth : 0);
            r._outerWidth(i.width() - n.outerWidth());
            n.add(r)._outerHeight(a.height);
            o._outerWidth(n.width());
            s._outerWidth(o.width()).css("height", "");
        } else {
            var f = n.children("div.tabs-scroller-left,div.tabs-scroller-right,div.tabs-tool");
            n._outerWidth(a.width).css("height", "");
            if (a.showHeader) {
                n.css("background-color", "");
                o.css("height", "");
                f.show();
            } else {
                n.css("background-color", "transparent");
                n._outerHeight(0);
                o._outerHeight(0);
                f.hide();
            }
            s._outerHeight(a.tabHeight).css("width", "");
            setScrollers(e);
            var h = a.height;
            if (!isNaN(h)) {
                r._outerHeight(h - n.outerHeight());
            } else {
                r.height("auto");
            }
            var u = a.width;
            if (!isNaN(u)) {
                r._outerWidth(u);
            } else {
                r.width("auto");
            }
        }
    }
    function setSelectedSize(e) {
        var t = $.data(e, "tabs").options;
        var a = getSelectedTab(e);
        if (a) {
            var i = $(e).children("div.tabs-panels");
            var n = t.width == "auto" ? "auto" : i.width();
            var r = t.height == "auto" ? "auto" : i.height();
            a.panel("resize", {
                width: n,
                height: r
            });
        }
    }
    function wrapTabs(i) {
        var n = $.data(i, "tabs").tabs;
        var e = $(i);
        e.addClass("tabs-container");
        var t = $('<div class="tabs-panels"></div>').insertBefore(e);
        e.children("div").each(function() {
            t[0].appendChild(this);
        });
        e[0].appendChild(t[0]);
        $('<div class="tabs-header">' + '<div class="tabs-scroller-left"></div>' + '<div class="tabs-scroller-right"></div>' + '<div class="tabs-wrap">' + '<ul class="tabs"></ul>' + "</div>" + "</div>").prependTo(i);
        e.children("div.tabs-panels").children("div").each(function(e) {
            var t = $.extend({}, $.parser.parseOptions(this), {
                selected: $(this).attr("selected") ? true : undefined
            });
            var a = $(this);
            n.push(a);
            createTab(i, a, t);
        });
        e.children("div.tabs-header").find(".tabs-scroller-left, .tabs-scroller-right").hover(function() {
            $(this).addClass("tabs-scroller-over");
        }, function() {
            $(this).removeClass("tabs-scroller-over");
        });
        e.bind("_resize", function(e, t) {
            var a = $.data(i, "tabs").options;
            if (a.fit == true || t) {
                setSize(i);
                setSelectedSize(i);
            }
            return false;
        });
    }
    function bindEvents(r) {
        var o = $.data(r, "tabs");
        var s = o.options;
        $(r).children("div.tabs-header").unbind().bind("click", function(e) {
            if ($(e.target).hasClass("tabs-scroller-left")) {
                $(r).tabs("scrollBy", -s.scrollIncrement);
            } else {
                if ($(e.target).hasClass("tabs-scroller-right")) {
                    $(r).tabs("scrollBy", s.scrollIncrement);
                } else {
                    var t = $(e.target).closest("li");
                    if (t.hasClass("tabs-disabled")) {
                        return;
                    }
                    var a = $(e.target).closest("a.tabs-close");
                    if (a.length) {
                        closeTab(r, d(t));
                    } else {
                        if (t.length) {
                            var i = d(t);
                            var n = o.tabs[i].panel("options");
                            if (n.collapsible) {
                                n.closed ? selectTab(r, i) : unselectTab(r, i);
                            } else {
                                selectTab(r, i);
                            }
                        }
                    }
                }
            }
        }).bind("contextmenu", function(e) {
            var t = $(e.target).closest("li");
            if (t.hasClass("tabs-disabled")) {
                return;
            }
            if (t.length) {
                s.onContextMenu.call(r, e, t.find("span.tabs-title").html(), d(t));
            }
        });
        function d(t) {
            var a = 0;
            t.parent().children("li").each(function(e) {
                if (t[0] == this) {
                    a = e;
                    return false;
                }
            });
            return a;
        }
    }
    function setProperties(e) {
        var t = $.data(e, "tabs").options;
        var a = $(e).children("div.tabs-header");
        var i = $(e).children("div.tabs-panels");
        a.removeClass("tabs-header-top tabs-header-bottom tabs-header-left tabs-header-right");
        i.removeClass("tabs-panels-top tabs-panels-bottom tabs-panels-left tabs-panels-right");
        if (t.tabPosition == "top") {
            a.insertBefore(i);
        } else {
            if (t.tabPosition == "bottom") {
                a.insertAfter(i);
                a.addClass("tabs-header-bottom");
                i.addClass("tabs-panels-top");
            } else {
                if (t.tabPosition == "left") {
                    a.addClass("tabs-header-left");
                    i.addClass("tabs-panels-right");
                } else {
                    if (t.tabPosition == "right") {
                        a.addClass("tabs-header-right");
                        i.addClass("tabs-panels-left");
                    }
                }
            }
        }
        if (t.plain == true) {
            a.addClass("tabs-header-plain");
        } else {
            a.removeClass("tabs-header-plain");
        }
        if (t.border == true) {
            a.removeClass("tabs-header-noborder");
            i.removeClass("tabs-panels-noborder");
        } else {
            a.addClass("tabs-header-noborder");
            i.addClass("tabs-panels-noborder");
        }
    }
    function createTab(e, t, a) {
        var i = $.data(e, "tabs");
        a = a || {};
        t.panel($.extend({}, a, {
            border: false,
            noheader: true,
            closed: true,
            doSize: false,
            iconCls: a.icon ? a.icon : undefined,
            onLoad: function() {
                if (a.onLoad) {
                    a.onLoad.call(this, arguments);
                }
                i.options.onLoad.call(e, $(this));
            }
        }));
        var n = t.panel("options");
        var r = $(e).children("div.tabs-header").find("ul.tabs");
        if (!!i.options.isBrandTabs && r.children("li").length == 0) {
            n.tab = $("<li class='tabs-brand'></li>").appendTo(r);
        } else {
            n.tab = $("<li></li>").appendTo(r);
        }
        n.tab.append('<a href="javascript:void(0)" class="tabs-inner">' + '<span class="tabs-title"></span>' + '<span class="tabs-icon"></span>' + "</a>");
        $(e).tabs("update", {
            tab: t,
            options: n
        });
    }
    function addTab(e, t) {
        var a = $.data(e, "tabs").options;
        var i = $.data(e, "tabs").tabs;
        if (t.selected == undefined) {
            t.selected = true;
        }
        var n = $("<div></div>").appendTo($(e).children("div.tabs-panels"));
        i.push(n);
        createTab(e, n, t);
        a.onAdd.call(e, t.title, i.length - 1);
        setSize(e);
        if (t.selected) {
            selectTab(e, i.length - 1);
        }
    }
    function updateTab(e, t) {
        var a = $.data(e, "tabs").selectHis;
        var i = t.tab;
        var n = i.panel("options").title;
        i.panel($.extend({}, t.options, {
            iconCls: t.options.icon ? t.options.icon : undefined
        }));
        var r = i.panel("options");
        var o = r.tab;
        var s = o.find("span.tabs-title");
        var d = o.find("span.tabs-icon");
        s.html(r.title);
        d.attr("class", "tabs-icon");
        o.find("a.tabs-close").remove();
        if (r.closable) {
            s.addClass("tabs-closable");
            $('<a href="javascript:void(0)" class="tabs-close"></a>').appendTo(o);
        } else {
            s.removeClass("tabs-closable");
        }
        if (r.iconCls) {
            s.addClass("tabs-with-icon");
            d.addClass(r.iconCls);
        } else {
            s.removeClass("tabs-with-icon");
        }
        if (n != r.title) {
            for (var l = 0; l < a.length; l++) {
                if (a[l] == n) {
                    a[l] = r.title;
                }
            }
        }
        o.find("span.tabs-p-tool").remove();
        if (r.tools) {
            var c = $('<span class="tabs-p-tool"></span>').insertAfter(o.find("a.tabs-inner"));
            if ($.isArray(r.tools)) {
                for (var l = 0; l < r.tools.length; l++) {
                    var u = $('<a href="javascript:void(0)"></a>').appendTo(c);
                    u.addClass(r.tools[l].iconCls);
                    if (r.tools[l].handler) {
                        u.bind("click", {
                            handler: r.tools[l].handler
                        }, function(e) {
                            if ($(this).parents("li").hasClass("tabs-disabled")) {
                                return;
                            }
                            e.data.handler.call(this);
                        });
                    }
                }
            } else {
                $(r.tools).children().appendTo(c);
            }
            var f = c.children().length * 12;
            if (r.closable) {
                f += 8;
            } else {
                f -= 3;
                c.css("right", "5px");
            }
            s.css("padding-right", f + "px");
        }
        setSize(e);
        $.data(e, "tabs").options.onUpdate.call(e, r.title, getTabIndex(e, i));
    }
    function closeTab(e, t) {
        var a = $.data(e, "tabs").options;
        var i = $.data(e, "tabs").tabs;
        var n = $.data(e, "tabs").selectHis;
        if (!exists(e, t)) {
            return;
        }
        var r = getTab(e, t);
        var o = r.panel("options").title;
        var s = getTabIndex(e, r);
        if (a.onBeforeClose.call(e, o, s) == false) {
            return;
        }
        var r = getTab(e, t, true);
        r.panel("options").tab.remove();
        r.panel("destroy");
        a.onClose.call(e, o, s);
        setSize(e);
        for (var d = 0; d < n.length; d++) {
            if (n[d] == o) {
                n.splice(d, 1);
                d--;
            }
        }
        var l = n.pop();
        if (l) {
            selectTab(e, l);
        } else {
            if (i.length) {
                selectTab(e, 0);
            }
        }
    }
    function getTab(e, t, a) {
        var i = $.data(e, "tabs").tabs;
        if (typeof t == "number") {
            if (t < 0 || t >= i.length) {
                return null;
            } else {
                var n = i[t];
                if (a) {
                    i.splice(t, 1);
                }
                return n;
            }
        }
        for (var r = 0; r < i.length; r++) {
            var n = i[r];
            if (n.panel("options").title == t) {
                if (a) {
                    i.splice(r, 1);
                }
                return n;
            }
        }
        return null;
    }
    function getTabIndex(e, t) {
        var a = $.data(e, "tabs").tabs;
        for (var i = 0; i < a.length; i++) {
            if (a[i][0] == $(t)[0]) {
                return i;
            }
        }
        return -1;
    }
    function getSelectedTab(e) {
        var t = $.data(e, "tabs").tabs;
        for (var a = 0; a < t.length; a++) {
            var i = t[a];
            if (i.panel("options").closed == false) {
                return i;
            }
        }
        return null;
    }
    function doFirstSelect(e) {
        var t = $.data(e, "tabs");
        var a = t.tabs;
        var i = !!t.options.isBrandTabs;
        for (var n = 0; n < a.length; n++) {
            if (a[n].panel("options").selected && !(i && n == 0)) {
                selectTab(e, n);
                return;
            }
        }
        if (i && t.options.selected == 0) t.options.selected = 1;
        selectTab(e, t.options.selected);
    }
    function selectTab(e, t) {
        var a = $.data(e, "tabs");
        var i = a.options;
        var n = a.tabs;
        var r = a.selectHis;
        if (n.length == 0) {
            return;
        }
        var o = getTab(e, t);
        if (!o) {
            return;
        }
        var s = getSelectedTab(e);
        if (i.onBeforeSelect) {
            if (false == i.onBeforeSelect.call(e, o.panel("options").title, getTabIndex(e, o))) {
                return false;
            }
        }
        if (!!i.isBrandTabs) {
            if (getTabIndex(e, o) == 0) {
                return false;
            }
        }
        if (s) {
            if (o[0] == s[0]) {
                setSelectedSize(e);
                return;
            }
            unselectTab(e, getTabIndex(e, s));
            if (!s.panel("options").closed) {
                return;
            }
        }
        o.panel("open");
        var d = o.panel("options").title;
        r.push(d);
        var l = o.panel("options").tab;
        l.addClass("tabs-selected");
        var c = $(e).find(">div.tabs-header>div.tabs-wrap");
        var u = l.position().left;
        var f = u + l.outerWidth();
        if (u < 0 || f > c.width()) {
            var h = u - (c.width() - l.width()) / 2;
            $(e).tabs("scrollBy", h);
        } else {
            $(e).tabs("scrollBy", 0);
        }
        setSelectedSize(e);
        i.onSelect.call(e, d, getTabIndex(e, o));
    }
    function unselectTab(e, t) {
        var a = $.data(e, "tabs");
        var i = getTab(e, t);
        if (i) {
            var n = i.panel("options");
            if (!n.closed) {
                i.panel("close");
                if (n.closed) {
                    n.tab.removeClass("tabs-selected");
                    a.options.onUnselect.call(e, n.title, getTabIndex(e, i));
                }
            }
        }
    }
    function exists(e, t) {
        return getTab(e, t) != null;
    }
    function showHeader(e, t) {
        var a = $.data(e, "tabs").options;
        a.showHeader = t;
        $(e).tabs("resize");
    }
    $.fn.tabs = function(a, e) {
        if (typeof a == "string") {
            return $.fn.tabs.methods[a](this, e);
        }
        a = a || {};
        return this.each(function() {
            var e = $.data(this, "tabs");
            var t;
            if (e) {
                t = $.extend(e.options, a);
                e.options = t;
            } else {
                $.data(this, "tabs", {
                    options: $.extend({}, $.fn.tabs.defaults, $.fn.tabs.parseOptions(this), a),
                    tabs: [],
                    selectHis: []
                });
                wrapTabs(this);
            }
            addTools(this);
            setProperties(this);
            setSize(this);
            bindEvents(this);
            doFirstSelect(this);
        });
    };
    $.fn.tabs.methods = {
        options: function(e) {
            var t = e[0];
            var a = $.data(t, "tabs").options;
            var i = getSelectedTab(t);
            a.selected = i ? getTabIndex(t, i) : -1;
            return a;
        },
        tabs: function(e) {
            return $.data(e[0], "tabs").tabs;
        },
        resize: function(e) {
            return e.each(function() {
                setSize(this);
                setSelectedSize(this);
            });
        },
        add: function(e, t) {
            return e.each(function() {
                addTab(this, t);
            });
        },
        close: function(e, t) {
            return e.each(function() {
                closeTab(this, t);
            });
        },
        getTab: function(e, t) {
            return getTab(e[0], t);
        },
        getTabIndex: function(e, t) {
            return getTabIndex(e[0], t);
        },
        getSelected: function(e) {
            return getSelectedTab(e[0]);
        },
        select: function(e, t) {
            return e.each(function() {
                selectTab(this, t);
            });
        },
        unselect: function(e, t) {
            return e.each(function() {
                unselectTab(this, t);
            });
        },
        exists: function(e, t) {
            return exists(e[0], t);
        },
        update: function(e, t) {
            return e.each(function() {
                updateTab(this, t);
            });
        },
        enableTab: function(e, t) {
            return e.each(function() {
                $(this).tabs("getTab", t).panel("options").tab.removeClass("tabs-disabled");
            });
        },
        disableTab: function(e, t) {
            return e.each(function() {
                $(this).tabs("getTab", t).panel("options").tab.addClass("tabs-disabled");
            });
        },
        showHeader: function(e) {
            return e.each(function() {
                showHeader(this, true);
            });
        },
        hideHeader: function(e) {
            return e.each(function() {
                showHeader(this, false);
            });
        },
        scrollBy: function(e, n) {
            return e.each(function() {
                var e = $(this).tabs("options");
                var a = $(this).find(">div.tabs-header>div.tabs-wrap");
                var t = Math.min(a._scrollLeft() + n, i());
                a.animate({
                    scrollLeft: t
                }, e.scrollDuration);
                function i() {
                    var e = 0;
                    var t = a.children("ul");
                    t.children("li").each(function() {
                        e += $(this).outerWidth(true);
                    });
                    return e - a.width() + (t.outerWidth() - t.width());
                }
            });
        }
    };
    $.fn.tabs.parseOptions = function(e) {
        return $.extend({}, $.parser.parseOptions(e, [ "width", "height", "tools", "toolPosition", "tabPosition", {
            fit: "boolean",
            border: "boolean",
            plain: "boolean",
            headerWidth: "number",
            tabWidth: "number",
            tabHeight: "number",
            selected: "number",
            showHeader: "boolean"
        } ]));
    };
    $.fn.tabs.defaults = {
        width: "auto",
        height: "auto",
        headerWidth: 150,
        tabWidth: "auto",
        tabHeight: 27,
        selected: 0,
        showHeader: true,
        plain: false,
        fit: false,
        border: true,
        tools: null,
        toolPosition: "right",
        tabPosition: "top",
        scrollIncrement: 100,
        scrollDuration: 400,
        onLoad: function(e) {},
        onSelect: function(e, t) {},
        onUnselect: function(e, t) {},
        onBeforeClose: function(e, t) {},
        onClose: function(e, t) {},
        onAdd: function(e, t) {},
        onUpdate: function(e, t) {},
        onContextMenu: function(e, t, a) {}
    };
})(jQuery);

(function(f) {
    var h = false;
    function u(e) {
        var t = f.data(e, "layout");
        var a = t.options;
        var i = t.panels;
        var n = f(e);
        if (e.tagName == "BODY") {
            n._fit();
        } else {
            a.fit ? n.css(n._fit()) : n._fit(false);
        }
        var r = {
            top: 0,
            left: 0,
            width: n.width(),
            height: n.height()
        };
        if (e.tagName !== "BODY") {
            var o = f(e).parent();
            if (o[0].tagName === "BODY") {
                r.height = r.height - parseInt(o.css("padding-top")) - parseInt(o.css("padding-bottom"));
            }
        }
        l(b(i.expandNorth) ? i.expandNorth : i.north, "n");
        l(b(i.expandSouth) ? i.expandSouth : i.south, "s");
        c(b(i.expandEast) ? i.expandEast : i.east, "e");
        c(b(i.expandWest) ? i.expandWest : i.west, "w");
        i.center.panel("resize", r);
        p(i);
        function s(e) {
            var t = e.panel("options");
            return Math.min(Math.max(t.height, t.minHeight), t.maxHeight);
        }
        function d(e) {
            var t = e.panel("options");
            return Math.min(Math.max(t.width, t.minWidth), t.maxWidth);
        }
        function l(e, t) {
            if (!e.length || !b(e)) {
                return;
            }
            var a = e.panel("options");
            var i = s(e);
            e.panel("resize", {
                width: n.width(),
                height: i,
                left: 0,
                top: t == "n" ? 0 : n.height() - i
            });
            r.height -= i;
            if (t == "n") {
                r.top += i;
                if (!a.split && a.border) {
                    r.top--;
                }
            }
            if (!a.split && a.border) {
                r.height++;
            }
        }
        function c(e, t) {
            if (!e.length || !b(e)) {
                return;
            }
            var a = e.panel("options");
            var i = d(e);
            e.panel("resize", {
                width: i,
                height: r.height,
                left: t == "e" ? n.width() - i : 0,
                top: r.top
            });
            r.width -= i;
            if (t == "w") {
                r.left += i;
                if (!a.split && a.border) {
                    r.left--;
                }
            }
            if (!a.split && a.border) {
                r.width++;
            }
        }
    }
    function p(e) {
        var t = "";
        if (e.north.hasClass("layout")) {
            t = e.north[0];
        }
        if (e.south.hasClass("layout")) {
            t = e.south[0];
        }
        if (e.east.hasClass("layout")) {
            t = e.east[0];
        }
        if (e.west.hasClass("layout")) {
            t = e.west[0];
        }
        if (f.data(t, "layout")) {
            u(t);
        }
    }
    function i(i) {
        var e = f(i);
        e.addClass("layout");
        function t(e) {
            e.children("div").each(function() {
                var e = f.fn.layout.parsePanelOptions(this);
                if ("north,south,east,west,center".indexOf(e.region) >= 0) {
                    a(i, e, this);
                }
            });
        }
        e.children("form").length ? t(e.children("form")) : t(e);
        e.append('<div class="layout-split-proxy-h"></div><div class="layout-split-proxy-v"></div>');
        e.bind("_resize", function(e, t) {
            var a = f.data(i, "layout").options;
            if (a.fit == true || t) {
                u(i);
            }
            return false;
        });
    }
    function a(s, e, t) {
        e.region = e.region || "center";
        var a = f.data(s, "layout").panels;
        var d = f(s);
        var l = e.region;
        if (a[l].length) {
            return;
        }
        var i = f(t);
        if (!i.length) {
            i = f("<div></div>").appendTo(d);
        }
        var n = f.extend({}, f.fn.layout.paneldefaults, {
            width: i.length ? parseInt(i[0].style.width) || i.outerWidth() : "auto",
            height: i.length ? parseInt(i[0].style.height) || i.outerHeight() : "auto",
            doSize: false,
            collapsible: true,
            cls: "layout-panel layout-panel-" + l,
            bodyCls: "layout-body",
            onOpen: function() {
                var e = f(this).panel("header").children("div.panel-tool");
                e.children("a.panel-tool-collapse").hide();
                var t = {
                    north: "up",
                    south: "down",
                    east: "right",
                    west: "left"
                };
                if (!t[l]) {
                    return;
                }
                var a = "layout-button-" + t[l];
                var i = e.children("a." + a);
                if (!i.length) {
                    i = f('<a href="javascript:void(0)"></a>').addClass(a).appendTo(e);
                    i.bind("click", {
                        dir: l
                    }, function(e) {
                        v(s, e.data.dir);
                        return false;
                    });
                }
                f(this).panel("options").collapsible ? i.show() : i.hide();
            }
        }, e);
        i.panel(n);
        a[l] = i;
        if (i.panel("options").split) {
            var c = i.panel("panel");
            c.addClass("layout-split-" + l);
            var r = "";
            if (l == "north") {
                r = "s";
            }
            if (l == "south") {
                r = "n";
            }
            if (l == "east") {
                r = "w";
            }
            if (l == "west") {
                r = "e";
            }
            c.resizable(f.extend({}, {
                handles: r,
                onStartResize: function(e) {
                    h = true;
                    if (l == "north" || l == "south") {
                        var t = f(">div.layout-split-proxy-v", s);
                    } else {
                        var t = f(">div.layout-split-proxy-h", s);
                    }
                    var a = 0, i = 0, n = 0, r = 0;
                    var o = {
                        display: "block"
                    };
                    if (l == "north") {
                        o.top = parseInt(c.css("top")) + c.outerHeight() - t.height();
                        o.left = parseInt(c.css("left"));
                        o.width = c.outerWidth();
                        o.height = t.height();
                    } else {
                        if (l == "south") {
                            o.top = parseInt(c.css("top"));
                            o.left = parseInt(c.css("left"));
                            o.width = c.outerWidth();
                            o.height = t.height();
                        } else {
                            if (l == "east") {
                                o.top = parseInt(c.css("top")) || 0;
                                o.left = parseInt(c.css("left")) || 0;
                                o.width = t.width();
                                o.height = c.outerHeight();
                            } else {
                                if (l == "west") {
                                    o.top = parseInt(c.css("top")) || 0;
                                    o.left = c.outerWidth() - t.width();
                                    o.width = t.width();
                                    o.height = c.outerHeight();
                                }
                            }
                        }
                    }
                    t.css(o);
                    f('<div class="layout-mask"></div>').css({
                        left: 0,
                        top: 0,
                        width: d.width(),
                        height: d.height()
                    }).appendTo(d);
                },
                onResize: function(e) {
                    if (l == "north" || l == "south") {
                        var t = f(">div.layout-split-proxy-v", s);
                        t.css("top", e.pageY - f(s).offset().top - t.height() / 2);
                    } else {
                        var t = f(">div.layout-split-proxy-h", s);
                        t.css("left", e.pageX - f(s).offset().left - t.width() / 2);
                    }
                    return false;
                },
                onStopResize: function(e) {
                    d.children("div.layout-split-proxy-v,div.layout-split-proxy-h").hide();
                    i.panel("resize", e.data);
                    u(s);
                    h = false;
                    d.find(">div.layout-mask").remove();
                }
            }, e));
        }
    }
    function n(e, t) {
        var a = f.data(e, "layout").panels;
        if (a[t].length) {
            a[t].panel("destroy");
            a[t] = f();
            var i = "expand" + t.substring(0, 1).toUpperCase() + t.substring(1);
            if (a[i]) {
                a[i].panel("destroy");
                a[i] = undefined;
            }
        }
    }
    function v(r, o, e) {
        if (e == undefined) {
            e = "normal";
        }
        var t = f.data(r, "layout");
        var s = t.panels;
        var a = t.options;
        var i = s[o];
        var d = i.panel("options");
        if (d.onBeforeCollapse.call(i) == false) {
            return;
        }
        var n = "expand" + o.substring(0, 1).toUpperCase() + o.substring(1);
        if (!s[n]) {
            s[n] = c(o);
            s[n].panel("panel").bind("click", function() {
                if (a.clickExpand) {
                    g(r, o);
                    return false;
                } else {
                    var e = u();
                    i.panel("expand", false).panel("open").panel("resize", e.collapse);
                    i.panel("panel").animate(e.expand, function() {
                        f(this).unbind(".layout").bind("mouseleave.layout", {
                            region: o
                        }, function(e) {
                            if (h == true) {
                                return;
                            }
                            v(r, e.data.region);
                        });
                    });
                    return false;
                }
            });
        }
        var l = u();
        if (!b(s[n])) {
            s.center.panel("resize", l.resizeC);
        }
        i.panel("panel").animate(l.collapse, e, function() {
            i.panel("collapse", false).panel("close");
            s[n].panel("open").panel("resize", l.expandP);
            f(this).unbind(".layout");
        });
        function c(e) {
            var t;
            if (e == "east") {
                t = "layout-button-left";
            } else {
                if (e == "west") {
                    t = "layout-button-right";
                } else {
                    if (e == "north") {
                        t = "layout-button-down";
                    } else {
                        if (e == "south") {
                            t = "layout-button-up";
                        }
                    }
                }
            }
            var a = "&nbsp;", i = "";
            if (d.title != "" && d.showCollapsedTitle) {
                if (e == "east" || e == "west") {
                    i = d.title.split("").join("</div><div>");
                    i = '<div class="layout-expand-body-title"><div>' + i + "</div></div>";
                } else {
                    a = d.title;
                }
            }
            var n = f("<div></div>").appendTo(r);
            n.panel(f.extend({}, f.fn.layout.paneldefaults, {
                cls: "layout-expand layout-expand-" + e,
                title: a,
                content: i,
                headerCls: d.headerCls,
                bodyCls: d.bodyCls,
                closed: true,
                minWidth: 0,
                minHeight: 0,
                doSize: false,
                tools: [ {
                    iconCls: t,
                    handler: function() {
                        g(r, o);
                        return false;
                    }
                } ]
            }));
            n.panel("panel").hover(function() {
                f(this).addClass("layout-expand-over");
            }, function() {
                f(this).removeClass("layout-expand-over");
            });
            return n;
        }
        function u() {
            var e = f(r);
            var t = s.center.panel("options");
            var a = d.collapsedSize;
            if (o == "east") {
                var i = t.width + d.width - a;
                if (d.split || !d.border) {
                    i++;
                }
                return {
                    resizeC: {
                        width: i
                    },
                    expand: {
                        left: e.width() - d.width
                    },
                    expandP: {
                        top: t.top,
                        left: e.width() - a,
                        width: a,
                        height: t.height
                    },
                    collapse: {
                        left: e.width(),
                        top: t.top,
                        height: t.height
                    }
                };
            } else {
                if (o == "west") {
                    var i = t.width + d.width - a;
                    if (d.split || !d.border) {
                        i++;
                    }
                    return {
                        resizeC: {
                            width: i,
                            left: a - 1
                        },
                        expand: {
                            left: 0
                        },
                        expandP: {
                            left: 0,
                            top: t.top,
                            width: a,
                            height: t.height
                        },
                        collapse: {
                            left: -d.width,
                            top: t.top,
                            height: t.height
                        }
                    };
                } else {
                    if (o == "north") {
                        a = d.collapsedHeight;
                        var n = t.height;
                        if (!b(s.expandNorth)) {
                            n += d.height - a + (d.split || !d.border ? 1 : 0);
                        }
                        s.east.add(s.west).add(s.expandEast).add(s.expandWest).panel("resize", {
                            top: a - 1,
                            height: n
                        });
                        return {
                            resizeC: {
                                top: a - 1,
                                height: n
                            },
                            expand: {
                                top: 0
                            },
                            expandP: {
                                top: 0,
                                left: 0,
                                width: e.width(),
                                height: a
                            },
                            collapse: {
                                top: -d.height,
                                width: e.width()
                            }
                        };
                    } else {
                        if (o == "south") {
                            a = d.collapsedHeight;
                            var n = t.height;
                            if (!b(s.expandSouth)) {
                                n += d.height - a + (d.split || !d.border ? 1 : 0);
                            }
                            s.east.add(s.west).add(s.expandEast).add(s.expandWest).panel("resize", {
                                height: n
                            });
                            return {
                                resizeC: {
                                    height: n
                                },
                                expand: {
                                    top: e.height() - d.height
                                },
                                expandP: {
                                    top: e.height() - a,
                                    left: 0,
                                    width: e.width(),
                                    height: a
                                },
                                collapse: {
                                    top: e.height(),
                                    width: e.width()
                                }
                            };
                        }
                    }
                }
            }
        }
    }
    function g(a, i) {
        var n = f.data(a, "layout").panels;
        var e = n[i];
        var t = e.panel("options");
        if (t.onBeforeExpand.call(e) == false) {
            return;
        }
        var r = s();
        var o = "expand" + i.substring(0, 1).toUpperCase() + i.substring(1);
        if (n[o]) {
            n[o].panel("close");
            e.panel("panel").stop(true, true);
            e.panel("expand", false).panel("open").panel("resize", r.collapse);
            e.panel("panel").animate(r.expand, function() {
                u(a);
            });
        }
        function s() {
            var e = f(a);
            var t = n.center.panel("options");
            if (i == "east" && n.expandEast) {
                return {
                    collapse: {
                        left: e.width(),
                        top: t.top,
                        height: t.height
                    },
                    expand: {
                        left: e.width() - n["east"].panel("options").width
                    }
                };
            } else {
                if (i == "west" && n.expandWest) {
                    return {
                        collapse: {
                            left: -n["west"].panel("options").width,
                            top: t.top,
                            height: t.height
                        },
                        expand: {
                            left: 0
                        }
                    };
                } else {
                    if (i == "north" && n.expandNorth) {
                        return {
                            collapse: {
                                top: -n["north"].panel("options").height,
                                width: e.width()
                            },
                            expand: {
                                top: 0
                            }
                        };
                    } else {
                        if (i == "south" && n.expandSouth) {
                            return {
                                collapse: {
                                    top: e.height(),
                                    width: e.width()
                                },
                                expand: {
                                    top: e.height() - n["south"].panel("options").height
                                }
                            };
                        }
                    }
                }
            }
        }
    }
    function b(e) {
        if (!e) {
            return false;
        }
        if (e.length) {
            return e.panel("panel").is(":visible");
        } else {
            return false;
        }
    }
    function r(e) {
        var t = f.data(e, "layout").panels;
        if (t.east.length && t.east.panel("options").collapsed) {
            v(e, "east", 0);
        }
        if (t.west.length && t.west.panel("options").collapsed) {
            v(e, "west", 0);
        }
        if (t.north.length && t.north.panel("options").collapsed) {
            v(e, "north", 0);
        }
        if (t.south.length && t.south.panel("options").collapsed) {
            v(e, "south", 0);
        }
    }
    f.fn.layout = function(a, e) {
        if (typeof a == "string") {
            return f.fn.layout.methods[a](this, e);
        }
        a = a || {};
        return this.each(function() {
            var e = f.data(this, "layout");
            if (e) {
                f.extend(e.options, a);
            } else {
                var t = f.extend({}, f.fn.layout.defaults, f.fn.layout.parseOptions(this), a);
                f.data(this, "layout", {
                    options: t,
                    panels: {
                        center: f(),
                        north: f(),
                        south: f(),
                        east: f(),
                        west: f()
                    }
                });
                i(this);
            }
            u(this);
            r(this);
        });
    };
    f.fn.layout.methods = {
        resize: function(e) {
            return e.each(function() {
                u(this);
            });
        },
        panel: function(e, t) {
            return f.data(e[0], "layout").panels[t];
        },
        collapse: function(e, t) {
            return e.each(function() {
                v(this, t);
            });
        },
        expand: function(e, t) {
            return e.each(function() {
                g(this, t);
            });
        },
        add: function(e, t) {
            return e.each(function() {
                a(this, t);
                u(this);
                if (f(this).layout("panel", t.region).panel("options").collapsed) {
                    v(this, t.region, 0);
                }
            });
        },
        remove: function(e, t) {
            return e.each(function() {
                n(this, t);
                u(this);
            });
        }
    };
    f.fn.layout.parseOptions = function(e) {
        return f.extend({}, f.parser.parseOptions(e, [ {
            fit: "boolean"
        } ]));
    };
    f.fn.layout.defaults = {
        fit: false,
        clickExpand: false
    };
    f.fn.layout.parsePanelOptions = function(e) {
        var t = f(e);
        return f.extend({}, f.fn.panel.parseOptions(e), f.parser.parseOptions(e, [ "region", {
            split: "boolean",
            showCollapsedTitle: "boolean",
            collpasedSize: "number",
            collapsedHeight: "number",
            minWidth: "number",
            minHeight: "number",
            maxWidth: "number",
            maxHeight: "number"
        } ]));
    };
    f.fn.layout.paneldefaults = f.extend({}, f.fn.panel.defaults, {
        region: null,
        showCollapsedTitle: false,
        split: false,
        collapsedSize: 28,
        collapsedHeight: 38,
        minWidth: 10,
        minHeight: 10,
        maxWidth: 1e4,
        maxHeight: 1e4
    });
})(jQuery);

(function($) {
    function init(i) {
        $(i).appendTo("body");
        $(i).addClass("menu-top");
        var e = $.data(i, "menu").options;
        if (e.isTopZindex) {
            var t = '<iframe style="position:absolute;z-index:-1;width:100%;height:100%;top:0;left:0;scrolling:no;" frameborder="0"></iframe>';
            $(i).prepend(t);
        }
        $(document).unbind(".menu").bind("mousedown.menu", function(e) {
            var t = $(e.target).closest("div.menu,div.combo-p");
            if (t.length) {
                return;
            }
            $("body>div.menu-top:visible").menu("hide");
        });
        var a = r($(i));
        for (var n = 0; n < a.length; n++) {
            o(a[n]);
        }
        function r(e) {
            var a = [];
            e.addClass("menu");
            a.push(e);
            if (!e.hasClass("menu-content")) {
                e.children("div").each(function() {
                    var e = $(this).children("div");
                    if (e.length) {
                        e.insertAfter(i);
                        this.submenu = e;
                        var t = r(e);
                        a = a.concat(t);
                    }
                });
            }
            return a;
        }
        function o(e) {
            var t = $.parser.parseOptions(e[0], [ "width", "height" ]);
            e[0].originalHeight = t.height || 0;
            if (e.hasClass("menu-content")) {
                e[0].originalWidth = t.width || e._outerWidth();
            } else {
                e[0].originalWidth = t.width || 0;
                e.children("div").each(function() {
                    var e = $(this);
                    var t = $.extend({}, $.parser.parseOptions(this, [ "name", "iconCls", "href", {
                        separator: "boolean"
                    } ]), {
                        disabled: e.attr("disabled") ? true : undefined
                    });
                    if (t.separator) {
                        e.addClass("menu-sep");
                    }
                    if (!e.hasClass("menu-sep")) {
                        e[0].itemName = t.name || "";
                        e[0].itemHref = t.href || "";
                        var a = e.addClass("menu-item").html();
                        e.empty().append($('<div class="menu-text"></div>').html(a));
                        if (t.iconCls) {
                            $('<div class="menu-icon"></div>').addClass(t.iconCls).appendTo(e);
                        }
                        if (t.disabled) {
                            setDisabled(i, e[0], true);
                        }
                        if (e[0].submenu) {
                            $('<div class="menu-rightarrow"></div>').appendTo(e);
                        }
                        bindMenuItemEvent(i, e);
                    }
                });
                $('<div class="menu-line"></div>').prependTo(e);
            }
            setMenuWidth(i, e);
            e.hide();
            bindMenuEvent(i, e);
        }
    }
    function setMenuWidth(e, t) {
        var a = $.data(e, "menu").options;
        var i = t.attr("style") || "";
        t.css({
            display: "block",
            left: -1e4,
            height: "auto",
            overflow: "hidden"
        });
        var n = t[0];
        var r = n.originalWidth || 0;
        if (!r) {
            r = 0;
            t.find("div.menu-text").each(function() {
                if (r < $(this)._outerWidth()) {
                    r = $(this)._outerWidth();
                }
                $(this).closest("div.menu-item")._outerHeight($(this)._outerHeight() + 2);
            });
            r += 40;
        }
        r = Math.max(r, a.minWidth);
        var o = n.originalHeight || t.outerHeight();
        var s = Math.max(n.originalHeight, t.outerHeight()) - 2;
        if (a.width && a.width > 0) r = a.width;
        t._outerWidth(r)._outerHeight(o);
        t.children("div.menu-line")._outerHeight(s);
        i += ";width:" + n.style.width + ";height:" + n.style.height;
        t.attr("style", i);
    }
    function bindMenuEvent(e, t) {
        var a = $.data(e, "menu");
        t.unbind(".menu").bind("mouseenter.menu", function() {
            if (a.timer) {
                clearTimeout(a.timer);
                a.timer = null;
            }
        }).bind("mouseleave.menu", function() {
            if (a.options.hideOnUnhover) {
                a.timer = setTimeout(function() {
                    hideAll(e);
                }, 100);
            }
        });
    }
    function bindMenuItemEvent(a, i) {
        if (!i.hasClass("menu-item")) {
            return;
        }
        i.unbind(".menu");
        i.bind("click.menu", function() {
            if ($(this).hasClass("menu-item-disabled")) {
                return;
            }
            if (!this.submenu) {
                hideAll(a);
                var e = $(this).attr("href");
                if (e) {
                    location.href = e;
                }
            }
            var t = $(a).menu("getItem", this);
            $.data(a, "menu").options.onClick.call(a, t);
        }).bind("mouseenter.menu", function(e) {
            i.siblings().each(function() {
                if (this.submenu) {
                    hideMenu(this.submenu);
                }
                $(this).removeClass("menu-active");
            });
            i.addClass("menu-active");
            if ($(this).hasClass("menu-item-disabled")) {
                i.addClass("menu-active-disabled");
                return;
            }
            var t = i[0].submenu;
            if (t) {
                $(a).menu("show", {
                    menu: t,
                    parent: i
                });
            }
        }).bind("mouseleave.menu", function(e) {
            i.removeClass("menu-active menu-active-disabled");
            var t = i[0].submenu;
            if (t) {
                if (e.pageX >= parseInt(t.css("left"))) {
                    i.addClass("menu-active");
                } else {
                    hideMenu(t);
                }
            } else {
                i.removeClass("menu-active");
            }
        });
    }
    function hideAll(e) {
        var t = $.data(e, "menu");
        if (t) {
            if ($(e).is(":visible")) {
                hideMenu($(e));
                t.options.onHide.call(e);
            }
        }
        return false;
    }
    function showMenu(e, t) {
        var a, i;
        t = t || {};
        var n = $(t.menu || e);
        if (n.hasClass("menu-top")) {
            var r = $.data(e, "menu").options;
            $.extend(r, t);
            a = r.left;
            i = r.top;
            if (r.alignTo) {
                var o = $(r.alignTo);
                a = o.offset().left;
                i = o.offset().top + o._outerHeight();
                if (r.align == "right") {
                    a += o.outerWidth() - n.outerWidth();
                }
            }
            if (a + n.outerWidth() > $(window)._outerWidth() + $(document)._scrollLeft()) {
                a = $(window)._outerWidth() + $(document).scrollLeft() - n.outerWidth() - 5;
            }
            if (a < 0) {
                a = 0;
            }
            if (i + n.outerHeight() > $(window)._outerHeight() + $(document).scrollTop()) {
                i = $(window)._outerHeight() + $(document).scrollTop() - n.outerHeight() - 5;
            }
        } else {
            var s = t.parent;
            a = s.offset().left + s.outerWidth() - 2;
            if (a + n.outerWidth() + 5 > $(window)._outerWidth() + $(document).scrollLeft()) {
                a = s.offset().left - n.outerWidth() + 2;
            }
            var i = s.offset().top - 3;
            if (i + n.outerHeight() > $(window)._outerHeight() + $(document).scrollTop()) {
                i = $(window)._outerHeight() + $(document).scrollTop() - n.outerHeight() - 5;
            }
        }
        n.css({
            left: a,
            top: i
        });
        n.show(0, function() {
            if (!n[0].shadow) {
                n[0].shadow = $('<div class="menu-shadow"></div>').insertAfter(n);
            }
            n[0].shadow.css({
                display: "block",
                zIndex: $.fn.menu.defaults.zIndex++,
                left: n.css("left"),
                top: n.css("top"),
                width: n.outerWidth(),
                height: n.outerHeight()
            });
            n.css("z-index", $.fn.menu.defaults.zIndex++);
            if (n.hasClass("menu-top")) {
                $.data(n[0], "menu").options.onShow.call(n[0]);
            }
        });
    }
    function hideMenu(e) {
        if (!e) {
            return;
        }
        t(e);
        e.find("div.menu-item").each(function() {
            if (this.submenu) {
                hideMenu(this.submenu);
            }
            $(this).removeClass("menu-active");
        });
        function t(e) {
            e.stop(true, true);
            if (e[0].shadow) {
                e[0].shadow.hide();
            }
            e.hide();
        }
    }
    function findItem(a, i) {
        var n = null;
        var r = $("<div></div>");
        function o(e) {
            e.children("div.menu-item").each(function() {
                var e = $(a).menu("getItem", this);
                var t = r.empty().html(e.text).text();
                if (i == $.trim(t)) {
                    n = e;
                } else {
                    if (this.submenu && !n) {
                        o(this.submenu);
                    }
                }
            });
        }
        o($(a));
        r.remove();
        return n;
    }
    function setDisabled(e, t, a) {
        var i = $(t);
        if (!i.hasClass("menu-item")) {
            return;
        }
        if (a) {
            i.addClass("menu-item-disabled");
            if (t.onclick) {
                t.onclick1 = t.onclick;
                t.onclick = null;
            }
        } else {
            i.removeClass("menu-item-disabled");
            if (t.onclick1) {
                t.onclick = t.onclick1;
                t.onclick1 = null;
            }
        }
    }
    function appendItem(target, param) {
        var menu = $(target);
        if (param.parent) {
            if (!param.parent.submenu) {
                var submenu = $('<div class="menu"><div class="menu-line"></div></div>').appendTo("body");
                submenu.hide();
                param.parent.submenu = submenu;
                $('<div class="menu-rightarrow"></div>').appendTo(param.parent);
            }
            menu = param.parent.submenu;
        }
        if (param.separator) {
            var item = $('<div class="menu-sep"></div>').appendTo(menu);
        } else {
            var item = $('<div class="menu-item"></div>').appendTo(menu);
            $('<div class="menu-text"></div>').html(param.text).appendTo(item);
        }
        if (param.iconCls) {
            $('<div class="menu-icon"></div>').addClass(param.iconCls).appendTo(item);
        }
        if (param.id) {
            item.attr("id", param.id);
        }
        if (param.name) {
            item[0].itemName = param.name;
        }
        if (param.href) {
            item[0].itemHref = param.href;
        }
        if (param.onclick) {
            if (typeof param.onclick == "string") {
                item.attr("onclick", param.onclick);
            } else {
                item[0].onclick = eval(param.onclick);
            }
        }
        if (param.handler) {
            item[0].onclick = eval(param.handler);
        }
        if (param.disabled) {
            setDisabled(target, item[0], true);
        }
        bindMenuItemEvent(target, item);
        bindMenuEvent(target, menu);
        setMenuWidth(target, menu);
    }
    function removeItem(e, t) {
        function a(e) {
            if (e.submenu) {
                e.submenu.children("div.menu-item").each(function() {
                    a(this);
                });
                var t = e.submenu[0].shadow;
                if (t) {
                    t.remove();
                }
                e.submenu.remove();
            }
            $(e).remove();
        }
        a(t);
    }
    function destroyMenu(e) {
        $(e).children("div.menu-item").each(function() {
            removeItem(e, this);
        });
        if (e.shadow) {
            e.shadow.remove();
        }
        $(e).remove();
    }
    $.fn.menu = function(t, e) {
        if (typeof t == "string") {
            return $.fn.menu.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = $.data(this, "menu");
            if (e) {
                $.extend(e.options, t);
            } else {
                e = $.data(this, "menu", {
                    options: $.extend({}, $.fn.menu.defaults, $.fn.menu.parseOptions(this), t)
                });
                init(this);
            }
            $(this).css({
                left: e.options.left,
                top: e.options.top
            });
        });
    };
    $.fn.menu.methods = {
        options: function(e) {
            return $.data(e[0], "menu").options;
        },
        show: function(e, t) {
            return e.each(function() {
                showMenu(this, t);
            });
        },
        hide: function(e) {
            return e.each(function() {
                hideAll(this);
            });
        },
        destroy: function(e) {
            return e.each(function() {
                destroyMenu(this);
            });
        },
        setText: function(e, t) {
            return e.each(function() {
                $(t.target).children("div.menu-text").html(t.text);
            });
        },
        setIcon: function(e, t) {
            return e.each(function() {
                $(t.target).children("div.menu-icon").remove();
                if (t.iconCls) {
                    $('<div class="menu-icon"></div>').addClass(t.iconCls).appendTo(t.target);
                }
            });
        },
        getItem: function(e, t) {
            var a = $(t);
            var i = {
                target: t,
                id: a.attr("id"),
                text: $.trim(a.children("div.menu-text").html()),
                disabled: a.hasClass("menu-item-disabled"),
                name: t.itemName,
                href: t.itemHref,
                onclick: t.onclick
            };
            var n = a.children("div.menu-icon");
            if (n.length) {
                var r = [];
                var o = n.attr("class").split(" ");
                for (var s = 0; s < o.length; s++) {
                    if (o[s] != "menu-icon") {
                        r.push(o[s]);
                    }
                }
                i.iconCls = r.join(" ");
            }
            return i;
        },
        findItem: function(e, t) {
            return findItem(e[0], t);
        },
        appendItem: function(e, t) {
            return e.each(function() {
                appendItem(this, t);
            });
        },
        removeItem: function(e, t) {
            return e.each(function() {
                removeItem(this, t);
            });
        },
        enableItem: function(e, t) {
            return e.each(function() {
                setDisabled(this, t, false);
            });
        },
        disableItem: function(e, t) {
            return e.each(function() {
                setDisabled(this, t, true);
            });
        }
    };
    $.fn.menu.parseOptions = function(e) {
        return $.extend({}, $.parser.parseOptions(e, [ "left", "top", {
            minWidth: "number",
            hideOnUnhover: "boolean"
        } ]));
    };
    $.fn.menu.defaults = {
        isTopZindex: false,
        zIndex: 11e4,
        left: 0,
        top: 0,
        alignTo: null,
        align: "left",
        minWidth: 120,
        hideOnUnhover: true,
        onShow: function() {},
        onHide: function() {},
        onClick: function(e) {}
    };
})(jQuery);

(function(s) {
    function i(e) {
        var t = s.data(e, "menubutton").options;
        var a = s(e);
        a.linkbutton(t);
        a.removeClass(t.cls.btn1 + " " + t.cls.btn2).addClass("m-btn");
        a.removeClass("m-btn-small m-btn-medium m-btn-large").addClass("m-btn-" + t.size);
        var i = a.find(".l-btn-left");
        s("<span></span>").addClass(t.cls.arrow).appendTo(i);
        s("<span></span>").addClass("m-btn-line").appendTo(i);
        a.removeClass("menubutton-toolbar menubutton-blue").addClass(t.otherCls);
        if (t.menu) {
            s(t.menu).addClass(t.otherCls);
            if (t.otherCls == "menubutton-toolbar" || t.otherCls == "menubutton-blue") {
                s(t.menu).menu({
                    width: a._outerWidth(),
                    isTopZindex: t.isTopZindex
                });
            } else {
                s(t.menu).menu({
                    isTopZindex: t.isTopZindex
                });
            }
            var n = s(t.menu).menu("options");
            var r = n.onShow;
            var o = n.onHide;
            s.extend(n, {
                onShow: function() {
                    var e = s(this).menu("options");
                    var t = s(e.alignTo);
                    var a = t.menubutton("options");
                    t.addClass(a.plain == true ? a.cls.btn2 : a.cls.btn1);
                    r.call(this);
                },
                onHide: function() {
                    var e = s(this).menu("options");
                    var t = s(e.alignTo);
                    var a = t.menubutton("options");
                    t.removeClass(a.plain == true ? a.cls.btn2 : a.cls.btn1);
                    o.call(this);
                }
            });
        }
        d(e, t.disabled);
    }
    function d(e, t) {
        var a = s.data(e, "menubutton").options;
        a.disabled = t;
        var i = s(e);
        var n = i.find("." + a.cls.trigger);
        if (!n.length) {
            n = i;
        }
        n.unbind(".menubutton");
        if (t) {
            i.linkbutton("disable");
        } else {
            i.linkbutton("enable");
            var r = null;
            n.bind("click.menubutton", function() {
                o(e);
                return false;
            }).bind("mouseenter.menubutton", function() {
                r = setTimeout(function() {
                    o(e);
                }, a.duration);
                return false;
            }).bind("mouseleave.menubutton", function(e) {
                if (r) {
                    clearTimeout(r);
                }
                if (s(a.menu).length > 0 && s(a.menu).find(e.toElement).length == 0 && !s(a.menu).is(s(e.toElement))) {
                    s(a.menu).menu("hide");
                }
            });
        }
    }
    function o(e) {
        var t = s.data(e, "menubutton").options;
        if (t.disabled || !t.menu) {
            return;
        }
        s("body>div.menu-top").menu("hide");
        var a = s(e);
        var i = s(t.menu);
        if (i.length) {
            i.menu("options").alignTo = a;
            i.menu("show", {
                alignTo: a,
                align: t.menuAlign
            });
        }
        a.blur();
    }
    s.fn.menubutton = function(t, e) {
        if (typeof t == "string") {
            var a = s.fn.menubutton.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.linkbutton(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = s.data(this, "menubutton");
            if (e) {
                s.extend(e.options, t);
            } else {
                s.data(this, "menubutton", {
                    options: s.extend({}, s.fn.menubutton.defaults, s.fn.menubutton.parseOptions(this), t)
                });
                s(this).removeAttr("disabled");
            }
            i(this);
        });
    };
    s.fn.menubutton.methods = {
        options: function(e) {
            var t = e.linkbutton("options");
            var a = s.data(e[0], "menubutton").options;
            a.toggle = t.toggle;
            a.selected = t.selected;
            return a;
        },
        enable: function(e) {
            return e.each(function() {
                d(this, false);
            });
        },
        disable: function(e) {
            return e.each(function() {
                d(this, true);
            });
        },
        destroy: function(e) {
            return e.each(function() {
                var e = s(this).menubutton("options");
                if (e.menu) {
                    s(e.menu).menu("destroy");
                }
                s(this).remove();
            });
        }
    };
    s.fn.menubutton.parseOptions = function(e) {
        var t = s(e);
        var a = "";
        if (t.hasClass("menubutton-blue")) {
            a = "menubutton-blue";
        } else if (t.hasClass("menubutton-toolbar")) {
            a = "menubutton-toolbar";
        }
        return s.extend({
            otherCls: a
        }, s.fn.linkbutton.parseOptions(e), s.parser.parseOptions(e, [ "menu", {
            plain: "boolean",
            duration: "number"
        } ]));
    };
    s.fn.menubutton.defaults = s.extend({}, s.fn.linkbutton.defaults, {
        otherCls: "",
        plain: true,
        menu: null,
        menuAlign: "left",
        duration: 100,
        cls: {
            btn1: "m-btn-active",
            btn2: "m-btn-plain-active",
            arrow: "m-btn-downarrow",
            trigger: "m-btn"
        }
    });
})(jQuery);

(function(i) {
    function n(e) {
        var t = i.data(e, "splitbutton").options;
        i(e).menubutton(t);
        i(e).addClass("s-btn");
    }
    i.fn.splitbutton = function(t, e) {
        if (typeof t == "string") {
            var a = i.fn.splitbutton.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.menubutton(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = i.data(this, "splitbutton");
            if (e) {
                i.extend(e.options, t);
            } else {
                i.data(this, "splitbutton", {
                    options: i.extend({}, i.fn.splitbutton.defaults, i.fn.splitbutton.parseOptions(this), t)
                });
                i(this).removeAttr("disabled");
            }
            n(this);
        });
    };
    i.fn.splitbutton.methods = {
        options: function(e) {
            var t = e.menubutton("options");
            var a = i.data(e[0], "splitbutton").options;
            i.extend(a, {
                disabled: t.disabled,
                toggle: t.toggle,
                selected: t.selected
            });
            return a;
        }
    };
    i.fn.splitbutton.parseOptions = function(e) {
        var t = i(e);
        return i.extend({}, i.fn.linkbutton.parseOptions(e), i.parser.parseOptions(e, [ "menu", {
            plain: "boolean",
            duration: "number"
        } ]));
    };
    i.fn.splitbutton.defaults = i.extend({}, i.fn.linkbutton.defaults, {
        plain: true,
        menu: null,
        duration: 100,
        cls: {
            btn1: "m-btn-active s-btn-active",
            btn2: "m-btn-plain-active s-btn-plain-active",
            arrow: "m-btn-downarrow",
            trigger: "m-btn-line"
        }
    });
})(jQuery);

(function($) {
    function init(e) {
        $(e).addClass("searchbox-f").hide();
        var t = $('<span class="searchbox"></span>').insertAfter(e);
        var a = $('<input type="text" class="searchbox-text">').appendTo(t);
        $('<span><span class="searchbox-button"></span></span>').appendTo(t);
        var i = $(e).attr("name");
        if (i) {
            a.attr("name", i);
            $(e).removeAttr("name").attr("searchboxName", i);
        }
        return t;
    }
    function _3fe(e, t) {
        var a = $.data(e, "searchbox").options;
        var i = $.data(e, "searchbox").searchbox;
        if (t) {
            a.width = t;
        }
        i.appendTo("body");
        if (isNaN(a.width)) {
            a.width = i._outerWidth();
        }
        var n = i.find("span.searchbox-button");
        var r = i.find("a.searchbox-menu");
        var o = i.find("input.searchbox-text");
        i._outerWidth(a.width)._outerHeight(a.height);
        o._outerWidth(i.width() - r._outerWidth() - n._outerWidth());
        o.css({
            height: i.height() + "px",
            lineHeight: i.height() + "px"
        });
        r._outerHeight(i.height());
        n._outerHeight(i.height());
        var s = r.find("span.l-btn-left");
        s._outerHeight(i.height());
        s.find("span.l-btn-text").css({
            height: s.height() + "px",
            lineHeight: s.height() + "px"
        });
        i.insertAfter(e);
    }
    function _404(a) {
        var i = $.data(a, "searchbox");
        var e = i.options;
        if (e.menu) {
            i.menu = $(e.menu).menu({
                onClick: function(e) {
                    n(e);
                }
            });
            var t = i.menu.children("div.menu-item:first");
            i.menu.children("div.menu-item").each(function() {
                var e = $.extend({}, $.parser.parseOptions(this), {
                    selected: $(this).attr("selected") ? true : undefined
                });
                if (e.selected) {
                    t = $(this);
                    return false;
                }
            });
            t.triggerHandler("click");
        } else {
            i.searchbox.find("a.searchbox-menu").remove();
            i.menu = null;
        }
        function n(e) {
            i.searchbox.find("a.searchbox-menu").remove();
            var t = $('<a class="searchbox-menu" href="javascript:void(0)"></a>').html(e.text);
            t.prependTo(i.searchbox).menubutton({
                menu: i.menu,
                iconCls: e.iconCls
            });
            i.searchbox.find("input.searchbox-text").attr("name", e.name || e.text);
            _3fe(a);
        }
    }
    function _409(t) {
        var e = $.data(t, "searchbox");
        var a = e.options;
        var i = e.searchbox.find("input.searchbox-text");
        var n = e.searchbox.find(".searchbox-button");
        i.unbind(".searchbox");
        n.unbind(".searchbox");
        if (!a.disabled) {
            i.bind("blur.searchbox", function(e) {
                a.value = $(this).val();
                if (a.value == "") {
                    $(this).val(a.prompt);
                    $(this).addClass("searchbox-prompt");
                } else {
                    $(this).removeClass("searchbox-prompt");
                }
            }).bind("focus.searchbox", function(e) {
                if ($(this).val() != a.value) {
                    $(this).val(a.value);
                }
                $(this).removeClass("searchbox-prompt");
            }).bind("keydown.searchbox", function(e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    a.value = $(this).val();
                    a.searcher.call(t, a.value, i._propAttr("name"));
                    return false;
                }
            });
            n.bind("click.searchbox", function() {
                a.searcher.call(t, a.value, i._propAttr("name"));
            }).bind("mouseenter.searchbox", function() {
                $(this).addClass("searchbox-button-hover");
            }).bind("mouseleave.searchbox", function() {
                $(this).removeClass("searchbox-button-hover");
            });
        }
    }
    function _40e(e, t) {
        var a = $.data(e, "searchbox");
        var i = a.options;
        var n = a.searchbox.find("input.searchbox-text");
        var r = a.searchbox.find("a.searchbox-menu");
        if (t) {
            i.disabled = true;
            $(e).attr("disabled", true);
            n.attr("disabled", true);
            if (r.length) {
                r.menubutton("disable");
            }
            a.searchbox.addClass("disabled");
        } else {
            i.disabled = false;
            $(e).removeAttr("disabled");
            n.removeAttr("disabled");
            if (r.length) {
                r.menubutton("enable");
            }
            a.searchbox.removeClass("disabled");
        }
    }
    function _413(e) {
        var t = $.data(e, "searchbox");
        var a = t.options;
        var i = t.searchbox.find("input.searchbox-text");
        a.originalValue = a.value;
        if (a.value) {
            i.val(a.value);
            i.removeClass("searchbox-prompt");
        } else {
            i.val(a.prompt);
            i.addClass("searchbox-prompt");
        }
    }
    $.fn.searchbox = function(t, e) {
        if (typeof t == "string") {
            return $.fn.searchbox.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = $.data(this, "searchbox");
            if (e) {
                $.extend(e.options, t);
            } else {
                e = $.data(this, "searchbox", {
                    options: $.extend({}, $.fn.searchbox.defaults, $.fn.searchbox.parseOptions(this), t),
                    searchbox: init(this)
                });
            }
            _404(this);
            _413(this);
            _409(this);
            _40e(this, e.options.disabled);
            _3fe(this);
        });
    };
    $.fn.searchbox.methods = {
        options: function(e) {
            return $.data(e[0], "searchbox").options;
        },
        menu: function(e) {
            return $.data(e[0], "searchbox").menu;
        },
        textbox: function(e) {
            return $.data(e[0], "searchbox").searchbox.find("input.searchbox-text");
        },
        getValue: function(e) {
            return $.data(e[0], "searchbox").options.value;
        },
        setValue: function(e, t) {
            return e.each(function() {
                $(this).searchbox("options").value = t;
                $(this).searchbox("textbox").val(t);
                $(this).searchbox("textbox").blur();
            });
        },
        clear: function(e) {
            return e.each(function() {
                $(this).searchbox("setValue", "");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = $(this).searchbox("options");
                $(this).searchbox("setValue", e.originalValue);
            });
        },
        getName: function(e) {
            return $.data(e[0], "searchbox").searchbox.find("input.searchbox-text").attr("name");
        },
        selectName: function(e, t) {
            return e.each(function() {
                var e = $.data(this, "searchbox").menu;
                if (e) {
                    e.children('div.menu-item[name="' + t + '"]').triggerHandler("click");
                }
            });
        },
        destroy: function(e) {
            return e.each(function() {
                var e = $(this).searchbox("menu");
                if (e) {
                    e.menu("destroy");
                }
                $.data(this, "searchbox").searchbox.remove();
                $(this).remove();
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                _3fe(this, t);
            });
        },
        disable: function(e) {
            return e.each(function() {
                _40e(this, true);
                _409(this);
            });
        },
        enable: function(e) {
            return e.each(function() {
                _40e(this, false);
                _409(this);
            });
        }
    };
    $.fn.searchbox.parseOptions = function(_41c) {
        var t = $(_41c);
        return $.extend({}, $.parser.parseOptions(_41c, [ "width", "height", "prompt", "menu" ]), {
            value: t.val() || undefined,
            disabled: t.attr("disabled") ? true : undefined,
            searcher: t.attr("searcher") ? eval(t.attr("searcher")) : undefined
        });
    };
    $.fn.searchbox.defaults = {
        width: "auto",
        height: 30,
        prompt: "",
        value: "",
        menu: null,
        disabled: false,
        searcher: function(e, t) {}
    };
})(jQuery);

(function($) {
    function init(e) {
        $(e).addClass("validatebox-text");
    }
    function _41f(e) {
        var t = $.data(e, "validatebox");
        t.validating = false;
        if (t.timer) {
            clearTimeout(t.timer);
        }
        $(e).tooltip("destroy");
        $(e).unbind();
        $(e).remove();
    }
    function _422(t) {
        var a = $(t);
        var e = $.data(t, "validatebox");
        a.unbind(".validatebox");
        if (e.options.novalidate) {
            return;
        }
        a.bind("focus.validatebox", function() {
            e.validating = true;
            e.value = undefined;
            (function() {
                if (e.validating) {
                    if (e.value != a.val()) {
                        e.value = a.val();
                        if (e.timer) {
                            clearTimeout(e.timer);
                        }
                        e.timer = setTimeout(function() {
                            $(t).validatebox("validate");
                        }, e.options.delay);
                    } else {
                        _429(t);
                    }
                    setTimeout(arguments.callee, 200);
                }
            })();
        }).bind("blur.validatebox", function() {
            if (e.timer) {
                clearTimeout(e.timer);
                e.timer = undefined;
            }
            e.validating = false;
            _425(t);
        }).bind("mouseenter.validatebox", function() {
            if (a.hasClass("validatebox-invalid")) {
                _426(t);
            }
            var e = $.data(t, "validatebox");
            if (e.options) {
                if (e.options.prompt && e.options.prompt != "") {
                    e.message = e.options.prompt;
                    _426(t);
                }
            }
        }).bind("mouseleave.validatebox", function() {
            if (!e.validating) {
                _425(t);
            }
        });
    }
    function _426(e) {
        var t = $.data(e, "validatebox");
        var a = t.options;
        $(e).tooltip($.extend({}, a.tipOptions, {
            content: t.message,
            position: a.tipPosition,
            deltaX: a.deltaX
        })).tooltip("show");
        t.tip = true;
    }
    function _429(e) {
        var t = $.data(e, "validatebox");
        if (t && t.tip) {
            $(e).tooltip("reposition");
        }
    }
    function _425(e) {
        var t = $.data(e, "validatebox");
        t.tip = false;
        $(e).tooltip("hide");
    }
    function _42e(_42f) {
        var _430 = $.data(_42f, "validatebox");
        var opts = _430.options;
        var box = $(_42f);
        var _431 = box.val();
        function _432(e) {
            _430.message = e;
        }
        function _433(_434, _435) {
            var _436 = /([a-zA-Z_]+)(.*)/.exec(_434);
            var rule = opts.rules[_436[1]];
            if (rule && _431) {
                var _437 = _435 || opts.validParams || eval(_436[2]);
                if (!rule["validator"].call(_42f, _431, _437)) {
                    box.addClass("validatebox-invalid");
                    var _438 = rule["message"];
                    if (_437) {
                        for (var i = 0; i < _437.length; i++) {
                            _438 = _438.replace(new RegExp("\\{" + i + "\\}", "g"), _437[i]);
                        }
                    }
                    _432(opts.invalidMessage || _438);
                    if (_430.validating) {
                        _426(_42f);
                    }
                    return false;
                }
            }
            return true;
        }
        box.removeClass("validatebox-invalid");
        _425(_42f);
        if (opts.novalidate || box.is(":disabled")) {
            return true;
        }
        if (opts.required) {
            if (_431 == "") {
                box.addClass("validatebox-invalid");
                _432(opts.missingMessage);
                if (_430.validating) {
                    _426(_42f);
                }
                return false;
            }
        }
        if (opts.validType) {
            if ($.isArray(opts.validType)) {
                for (var i = 0; i < opts.validType.length; i++) {
                    if (!_433(opts.validType[i])) {
                        return false;
                    }
                }
            } else {
                if (typeof opts.validType == "string") {
                    if (!_433(opts.validType)) {
                        return false;
                    }
                } else {
                    for (var _439 in opts.validType) {
                        var _43a = opts.validType[_439];
                        if (!_433(_439, _43a)) {
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }
    function setDisabled(e, t) {
        var a = $.data(e, "validatebox").options;
        if (t) {
            a.disabled = true;
            $(e).attr("disabled", true);
        } else {
            a.disabled = false;
            $(e).removeAttr("disabled");
        }
    }
    function _43b(e, t) {
        var a = $.data(e, "validatebox").options;
        if (t != undefined) {
            a.novalidate = t;
        }
        if (a.novalidate) {
            $(e).removeClass("validatebox-invalid");
            _425(e);
        }
        if (a.placeholder != "") {
            $(e).attr("placeholder", a.placeholder);
        }
        _422(e);
    }
    $.fn.validatebox = function(t, e) {
        if (typeof t == "string") {
            return $.fn.validatebox.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = $.data(this, "validatebox");
            if (e) {
                $.extend(e.options, t);
            } else {
                init(this);
                $.data(this, "validatebox", {
                    options: $.extend({}, $.fn.validatebox.defaults, $.fn.validatebox.parseOptions(this), t)
                });
            }
            setDisabled(this, $.data(this, "validatebox").options.disabled);
            _43b(this);
            _42e(this);
        });
    };
    $.fn.validatebox.methods = {
        options: function(e) {
            return $.data(e[0], "validatebox").options;
        },
        destroy: function(e) {
            return e.each(function() {
                _41f(this);
            });
        },
        validate: function(e) {
            return e.each(function() {
                _42e(this);
            });
        },
        isValid: function(e) {
            return _42e(e[0]);
        },
        enableValidation: function(e) {
            return e.each(function() {
                _43b(this, false);
            });
        },
        disableValidation: function(e) {
            return e.each(function() {
                _43b(this, true);
            });
        },
        setDisabled: function(e, t) {
            return e.each(function() {
                setDisabled(this, t);
            });
        }
    };
    $.fn.validatebox.parseOptions = function(e) {
        var t = $(e);
        return $.extend({}, $.parser.parseOptions(e, [ "disabled", "placeholder", "validType", "missingMessage", "invalidMessage", "tipPosition", {
            delay: "number",
            deltaX: "number"
        } ]), {
            required: t.attr("required") ? true : undefined,
            novalidate: t.attr("novalidate") != undefined ? true : undefined
        });
    };
    $.fn.validatebox.defaults = {
        disabled: false,
        placeholder: "",
        required: false,
        validType: null,
        validParams: null,
        delay: 200,
        missingMessage: "This field is required.",
        invalidMessage: null,
        tipPosition: "right",
        deltaX: 0,
        novalidate: false,
        tipOptions: {
            showEvent: "none",
            hideEvent: "none",
            showDelay: 0,
            hideDelay: 0,
            zIndex: "",
            onShow: function() {
                $(this).tooltip("tip").css({
                    color: "#000",
                    borderColor: "#CC9933",
                    backgroundColor: "#FFFFCC"
                });
            },
            onHide: function() {
                $(this).tooltip("destroy");
            }
        },
        rules: {
            email: {
                validator: function(e) {
                    return /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(e);
                },
                message: "Please enter a valid email address."
            },
            url: {
                validator: function(e) {
                    return /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(e);
                },
                message: "Please enter a valid URL."
            },
            length: {
                validator: function(e, t) {
                    var a = $.trim(e).length;
                    return a >= t[0] && a <= t[1];
                },
                message: "Please enter a value between {0} and {1}."
            },
            remote: {
                validator: function(e, t) {
                    var a = {};
                    a[t[1]] = e;
                    var i = $.ajax({
                        url: t[0],
                        dataType: "json",
                        data: a,
                        async: false,
                        cache: false,
                        type: "post"
                    }).responseText;
                    return i == "true";
                },
                message: "Please fix this field."
            },
            idcard: {
                validator: function(e) {
                    var t = $.data(this, "validatebox");
                    var a = t.options;
                    var i = {
                        11: "北京",
                        12: "天津",
                        13: "河北",
                        14: "山西",
                        15: "内蒙古",
                        21: "辽宁",
                        22: "吉林",
                        23: "黑龙江 ",
                        31: "上海",
                        32: "江苏",
                        33: "浙江",
                        34: "安徽",
                        35: "福建",
                        36: "江西",
                        37: "山东",
                        41: "河南",
                        42: "湖北 ",
                        43: "湖南",
                        44: "广东",
                        45: "广西",
                        46: "海南",
                        50: "重庆",
                        51: "四川",
                        52: "贵州",
                        53: "云南",
                        54: "西藏 ",
                        61: "陕西",
                        62: "甘肃",
                        63: "青海",
                        64: "宁夏",
                        65: "新疆",
                        71: "台湾",
                        81: "香港",
                        82: "澳门",
                        91: "国外 "
                    };
                    var n = true;
                    if (!e || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(e)) {
                        if (a.rules.idcard.formattermessage) a.rules.idcard.message = a.rules.idcard.formattermessage;
                        n = false;
                    } else if (!i[e.substr(0, 2)]) {
                        if (a.rules.idcard.addrmessage) a.rules.idcard.message = a.rules.idcard.addrmessage;
                        n = false;
                    } else {
                        if (e.length == 18) {
                            e = e.split("");
                            var r = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ];
                            var o = [ 1, 0, "X", 9, 8, 7, 6, 5, 4, 3, 2 ];
                            var s = 0;
                            var d = 0;
                            var l = 0;
                            for (var c = 0; c < 17; c++) {
                                d = e[c];
                                l = r[c];
                                s += d * l;
                            }
                            var u = o[s % 11];
                            if (o[s % 11] != e[17]) {
                                if (a.rules.idcard.paritymessage) a.rules.idcard.message = a.rules.idcard.paritymessage;
                                n = false;
                            }
                        }
                    }
                    return n;
                },
                message: "Please enter a valid ID card."
            },
            mobilephone: {
                validator: function(e) {
                    var t = function(e) {
                        return e.length == 11 && /^1[3|4|5|8][0-9]\d{8}$/.test(e);
                    };
                    var a = false;
                    a = t(e);
                    if (e.length == 12 && e.substr(0, 1) == 0) {
                        var i = e.substr(1, 11);
                        if (t(i)) {
                            $(this).val(i);
                            a = true;
                        }
                    }
                    return a;
                },
                message: "Please enter a valid mobile phone."
            }
        }
    };
})(jQuery);

(function(p) {
    function i(e, o) {
        o = o || {};
        var t = {};
        if (o.onSubmit) {
            if (o.onSubmit.call(e, t) == false) {
                return;
            }
        }
        var a = p(e);
        if (o.url) {
            a.attr("action", o.url);
        }
        var s = "hisui_frame_" + new Date().getTime();
        var i = p("<iframe id=" + s + " name=" + s + "></iframe>").attr("src", window.ActiveXObject ? "javascript:false" : "about:blank").css({
            position: "absolute",
            top: -1e3,
            left: -1e3
        });
        var n = a.attr("target"), r = a.attr("action");
        a.attr("target", s);
        var d = p();
        try {
            i.appendTo("body");
            i.bind("load", h);
            for (var l in t) {
                var c = p('<input type="hidden" name="' + l + '">').val(t[l]).appendTo(a);
                d = d.add(c);
            }
            u();
            a[0].submit();
        } finally {
            a.attr("action", r);
            n ? a.attr("target", n) : a.removeAttr("target");
            d.remove();
        }
        function u() {
            var e = p("#" + s);
            if (!e.length) {
                return;
            }
            try {
                var t = e.contents()[0].readyState;
                if (t && t.toLowerCase() == "uninitialized") {
                    setTimeout(u, 100);
                }
            } catch (a) {
                h();
            }
        }
        var f = 10;
        function h() {
            var e = p("#" + s);
            if (!e.length) {
                return;
            }
            e.unbind();
            var t = "";
            try {
                var a = e.contents().find("body");
                t = a.html();
                if (t == "") {
                    if (--f) {
                        setTimeout(h, 100);
                        return;
                    }
                }
                var i = a.find(">textarea");
                if (i.length) {
                    t = i.val();
                } else {
                    var n = a.find(">pre");
                    if (n.length) {
                        t = n.html();
                    }
                }
            } catch (r) {}
            if (o.success) {
                o.success(t);
            }
            setTimeout(function() {
                e.unbind();
                e.remove();
            }, 100);
        }
    }
    function a(s, e) {
        if (!p.data(s, "form")) {
            p.data(s, "form", {
                options: p.extend({}, p.fn.form.defaults)
            });
        }
        var o = p.data(s, "form").options;
        if (typeof e == "string") {
            var t = {};
            if (o.onBeforeLoad.call(s, t) == false) {
                return;
            }
            p.ajax({
                url: e,
                data: t,
                dataType: "json",
                success: function(e) {
                    a(e);
                },
                error: function() {
                    o.onLoadError.apply(s, arguments);
                }
            });
        } else {
            a(e);
        }
        function a(e) {
            var t = p(s);
            for (var a in e) {
                var i = e[a];
                var n = d(a, i);
                if (!n.length) {
                    var r = l(a, i);
                    if (!r) {
                        p('input[name="' + a + '"]', t).val(i);
                        p('textarea[name="' + a + '"]', t).val(i);
                        p('select[name="' + a + '"]', t).val(i);
                    }
                }
                c(a, i);
            }
            o.onLoadSuccess.call(s, e);
            u(s);
        }
        function d(e, t) {
            var a = p(s).find('input[name="' + e + '"][type=radio], input[name="' + e + '"][type=checkbox]');
            a._propAttr("checked", false);
            a.each(function() {
                var e = p(this);
                if (e.val() == String(t) || p.inArray(e.val(), p.isArray(t) ? t : [ t ]) >= 0) {
                    e._propAttr("checked", true);
                }
            });
            return a;
        }
        function l(e, t) {
            var a = 0;
            var i = [ "numberbox", "slider" ];
            for (var n = 0; n < i.length; n++) {
                var r = i[n];
                var o = p(s).find("input[" + r + 'Name="' + e + '"]');
                if (o.length) {
                    o[r]("setValue", t);
                    a += o.length;
                }
            }
            return a;
        }
        function c(e, t) {
            var a = p(s);
            var i = [ "combobox", "combotree", "combogrid", "datetimebox", "datebox", "combo" ];
            var n = a.find('[comboName="' + e + '"]');
            if (n.length) {
                for (var r = 0; r < i.length; r++) {
                    var o = i[r];
                    if (n.hasClass(o + "-f")) {
                        if (n[o]("options").multiple) {
                            n[o]("setValues", t);
                        } else {
                            n[o]("setValue", t);
                        }
                        return;
                    }
                }
            }
        }
    }
    function t(e) {
        p("input,select,textarea", e).each(function() {
            var e = this.type, t = this.tagName.toLowerCase();
            if (e == "text" || e == "hidden" || e == "password" || t == "textarea") {
                this.value = "";
            } else {
                if (e == "file") {
                    var a = p(this);
                    var i = a.clone().val("");
                    i.insertAfter(a);
                    if (a.data("validatebox")) {
                        a.validatebox("destroy");
                        i.validatebox();
                    } else {
                        a.remove();
                    }
                } else {
                    if (e == "checkbox" || e == "radio") {
                        this.checked = false;
                    } else {
                        if (t == "select") {
                            this.selectedIndex = -1;
                        }
                    }
                }
            }
        });
        var t = p(e);
        var a = [ "combo", "combobox", "combotree", "combogrid", "slider", "radio", "checkbox" ];
        for (var i = 0; i < a.length; i++) {
            var n = a[i];
            var r = t.find("." + n + "-f");
            if (r.length && r[n]) {
                r[n]("clear");
            }
        }
        u(e);
    }
    function n(e) {
        e.reset();
        var t = p(e);
        var a = [ "combo", "combobox", "combotree", "combogrid", "datebox", "datetimebox", "spinner", "timespinner", "numberbox", "numberspinner", "slider", "radio", "checkbox" ];
        for (var i = 0; i < a.length; i++) {
            var n = a[i];
            var r = t.find("." + n + "-f");
            if (r.length && r[n]) {
                r[n]("reset");
            }
        }
        u(e);
    }
    function r(e) {
        var t = p.data(e, "form").options;
        var a = p(e);
        a.unbind(".form").bind("submit.form", function() {
            setTimeout(function() {
                i(e, t);
            }, 0);
            return false;
        });
    }
    function u(e) {
        if (p.fn.validatebox) {
            var t = p(e);
            t.find(".validatebox-text:not(:disabled)").validatebox("validate");
            var a = t.find(".validatebox-invalid");
            a.filter(":not(:disabled):first").focus();
            return a.length == 0;
        }
        return true;
    }
    function o(e, t) {
        p(e).find(".validatebox-text:not(:disabled)").validatebox(t ? "disableValidation" : "enableValidation");
    }
    p.fn.form = function(e, t) {
        if (typeof e == "string") {
            return p.fn.form.methods[e](this, t);
        }
        e = e || {};
        return this.each(function() {
            if (!p.data(this, "form")) {
                p.data(this, "form", {
                    options: p.extend({}, p.fn.form.defaults, e)
                });
            }
            r(this);
        });
    };
    p.fn.form.methods = {
        submit: function(e, t) {
            return e.each(function() {
                var e = p.extend({}, p.fn.form.defaults, p.data(this, "form") ? p.data(this, "form").options : {}, t || {});
                i(this, e);
            });
        },
        load: function(e, t) {
            return e.each(function() {
                a(this, t);
            });
        },
        clear: function(e) {
            return e.each(function() {
                t(this);
            });
        },
        reset: function(e) {
            return e.each(function() {
                n(this);
            });
        },
        validate: function(e) {
            return u(e[0]);
        },
        disableValidation: function(e) {
            return e.each(function() {
                o(this, true);
            });
        },
        enableValidation: function(e) {
            return e.each(function() {
                o(this, false);
            });
        }
    };
    p.fn.form.defaults = {
        url: null,
        onSubmit: function(e) {
            return p(this).form("validate");
        },
        success: function(e) {},
        onBeforeLoad: function(e) {},
        onLoadSuccess: function(e) {},
        onLoadError: function() {}
    };
})(jQuery);

(function(o) {
    function i(e) {
        o(e).addClass("numberbox numberbox-f");
        var t = o('<input type="hidden">').insertAfter(e);
        var a = o(e).attr("name");
        if (a) {
            t.attr("name", a);
            o(e).removeAttr("name").attr("numberboxName", a);
        }
        return t;
    }
    function n(e) {
        var t = o.data(e, "numberbox").options;
        var a = t.onChange;
        t.onChange = function() {};
        d(e, t.parser.call(e, t.value));
        t.onChange = a;
        t.originalValue = s(e);
    }
    function r(e, t) {
        var a = o.data(e, "numberbox").options;
        if (t) {
            a.width = t;
        }
        var i = o(e);
        var n = o('<div style="display:none"></div>').insertBefore(i);
        i.appendTo("body");
        if (isNaN(a.width)) {
            a.width = i.outerWidth();
        }
        i._outerWidth(a.width)._outerHeight(a.height);
        i.css("line-height", i.height() + "px");
        i.insertAfter(n);
        n.remove();
    }
    function s(e) {
        return o.data(e, "numberbox").field.val();
    }
    function d(e, t) {
        var a = o.data(e, "numberbox");
        var i = a.options;
        var n = s(e);
        t = i.parser.call(e, t);
        i.value = t;
        a.field.val(t);
        o(e).val(i.formatter.call(e, t));
        if (n != t) {
            i.onChange.call(e, t, n);
        }
    }
    function l(t) {
        var a = o.data(t, "numberbox").options;
        o(t).unbind(".numberbox").bind("keypress.numberbox", function(e) {
            return a.filter.call(t, e);
        }).bind("blur.numberbox", function() {
            d(t, o(this).val());
            o(this).val(a.formatter.call(t, s(t)));
        }).bind("focus.numberbox", function() {
            var e = s(t);
            if (e != a.parser.call(t, o(this).val())) {
                o(this).val(a.formatter.call(t, e));
            }
        });
        if (a.isKeyupChange) {
            o(t).bind("keyup.numberbox", function(e) {
                d(t, o(this).val());
                o(this).val(a.formatter.call(t, s(t)));
            });
        }
    }
    function c(e) {
        if (o.fn.validatebox) {
            var t = o.data(e, "numberbox").options;
            if (!t.validType) {
                t.validType = [];
            }
            if ("string" == typeof t.validType) t.validType = [ t.validType ];
            if (typeof t.min == "number") t.validType.push("min[" + t.min + "]");
            if (typeof t.max == "number") t.validType.push("max[" + t.max + "]");
            o(e).validatebox(t);
        }
    }
    function u(e, t) {
        var a = o.data(e, "numberbox").options;
        if (t) {
            a.disabled = true;
            o(e).attr("disabled", true);
        } else {
            a.disabled = false;
            o(e).removeAttr("disabled");
        }
    }
    o.fn.numberbox = function(t, e) {
        if (typeof t == "string") {
            var a = o.fn.numberbox.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.validatebox(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = o.data(this, "numberbox");
            if (e) {
                o.extend(e.options, t);
            } else {
                e = o.data(this, "numberbox", {
                    options: o.extend({}, o.fn.numberbox.defaults, o.fn.numberbox.parseOptions(this), t),
                    field: i(this)
                });
                o(this).removeAttr("disabled");
                o(this).css({
                    imeMode: "disabled"
                });
            }
            u(this, e.options.disabled);
            r(this);
            l(this);
            c(this);
            n(this);
        });
    };
    o.fn.numberbox.methods = {
        options: function(e) {
            return o.data(e[0], "numberbox").options;
        },
        destroy: function(e) {
            return e.each(function() {
                o.data(this, "numberbox").field.remove();
                o(this).validatebox("destroy");
                o(this).remove();
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                r(this, t);
            });
        },
        disable: function(e) {
            return e.each(function() {
                u(this, true);
            });
        },
        enable: function(e) {
            return e.each(function() {
                u(this, false);
            });
        },
        fix: function(e) {
            return e.each(function() {
                d(this, o(this).val());
            });
        },
        setValue: function(e, t) {
            return e.each(function() {
                d(this, t);
            });
        },
        getValue: function(e) {
            return s(e[0]);
        },
        clear: function(e) {
            return e.each(function() {
                var e = o.data(this, "numberbox");
                e.field.val("");
                o(this).val("");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = o(this).numberbox("options");
                o(this).numberbox("setValue", e.originalValue);
            });
        }
    };
    o.fn.numberbox.parseOptions = function(e) {
        var t = o(e);
        return o.extend({}, o.fn.validatebox.parseOptions(e), o.parser.parseOptions(e, [ "width", "height", "decimalSeparator", "groupSeparator", "suffix", {
            min: "number",
            max: "number",
            precision: "number"
        } ]), {
            prefix: t.attr("prefix") ? t.attr("prefix") : undefined,
            disabled: t.attr("disabled") ? true : undefined,
            value: t.val() || undefined
        });
    };
    o.fn.numberbox.defaults = o.extend({}, o.fn.validatebox.defaults, {
        fix: true,
        isKeyupChange: false,
        width: "auto",
        height: 30,
        disabled: false,
        value: "",
        min: null,
        max: null,
        precision: 0,
        decimalSeparator: ".",
        groupSeparator: "",
        prefix: "",
        suffix: "",
        filter: function(e) {
            var t = o(this).numberbox("options");
            if (e.which == 45) {
                return o(this).val().indexOf("-") == -1 ? true : false;
            }
            var a = String.fromCharCode(e.which);
            if (a == t.decimalSeparator) {
                return o(this).val().indexOf(a) == -1 ? true : false;
            } else {
                if (a == t.groupSeparator) {
                    return true;
                } else {
                    if (e.which >= 48 && e.which <= 57 && e.ctrlKey == false && e.shiftKey == false || e.which == 0 || e.which == 8) {
                        return true;
                    } else {
                        if (e.ctrlKey == true && (e.which == 99 || e.which == 118)) {
                            return true;
                        } else {
                            return false;
                        }
                    }
                }
            }
        },
        formatter: function(e) {
            if (!e) {
                return e;
            }
            e = e + "";
            var t = o(this).numberbox("options");
            var a = e, i = "";
            var n = e.indexOf(".");
            if (n >= 0) {
                a = e.substring(0, n);
                i = e.substring(n + 1, e.length);
            }
            if (t.groupSeparator) {
                var r = /(\d+)(\d{3})/;
                while (r.test(a)) {
                    a = a.replace(r, "$1" + t.groupSeparator + "$2");
                }
            }
            if (i) {
                return t.prefix + a + t.decimalSeparator + i + t.suffix;
            } else {
                return t.prefix + a + t.suffix;
            }
        },
        parser: function(e) {
            e = e + "";
            var t = o(this).numberbox("options");
            if (parseFloat(e) != e) {
                if (t.prefix) {
                    e = o.trim(e.replace(new RegExp("\\" + o.trim(t.prefix), "g"), ""));
                }
                if (t.suffix) {
                    e = o.trim(e.replace(new RegExp("\\" + o.trim(t.suffix), "g"), ""));
                }
                if (t.groupSeparator) {
                    e = o.trim(e.replace(new RegExp("\\" + t.groupSeparator, "g"), ""));
                }
                if (t.decimalSeparator) {
                    e = o.trim(e.replace(new RegExp("\\" + t.decimalSeparator, "g"), "."));
                }
                e = e.replace(/\s/g, "");
            }
            var a = parseFloat(e).toFixed(t.precision);
            if (isNaN(a)) {
                a = "";
            } else {
                if (t.fix) {
                    if (typeof t.min == "number" && a < t.min) {
                        a = t.min.toFixed(t.precision);
                    } else {
                        if (typeof t.max == "number" && a > t.max) {
                            a = t.max.toFixed(t.precision);
                        }
                    }
                } else {
                    var i = o.data(this, "validatebox").options.validType;
                    if (!i) o.data(this, "validatebox").options.validType = [];
                    if ("string" == typeof i) o.data(this, "validatebox").options.validType = [ i ];
                    var n = o.data(this, "validatebox").options.validType;
                    if (typeof t.min == "number") n.push("min[" + t.min + "]");
                    if (typeof t.max == "number") n.push("max[" + t.max + "]");
                    o(this).validatebox("validate");
                }
            }
            return a;
        },
        onChange: function(e, t) {}
    });
    o.extend(o.fn.numberbox.defaults.rules, {
        min: {
            validator: function(e, t) {
                if (parseFloat(t[0]) > parseFloat(e)) return false;
                return true;
            },
            message: "Please enter a value greater than {0}"
        },
        max: {
            validator: function(e, t) {
                if (parseFloat(t[0]) < parseFloat(e)) return false;
                return true;
            },
            message: "Please enter a value less than {0}"
        }
    });
})(jQuery);

(function(Z) {
    function a(e) {
        var t = Z.data(e, "calendar").options;
        var a = Z(e);
        t.fit ? Z.extend(t, a._fit()) : a._fit(false);
        var i = a.find(".calendar-header");
        a._outerWidth(t.width);
        a._outerHeight(t.height);
        a.find(".calendar-body")._outerHeight(a.height() - i._outerHeight());
    }
    function i(t) {
        Z(t).addClass("calendar").html('<div class="calendar-header">' + '<div class="calendar-prevmonth"></div>' + '<div class="calendar-nextmonth"></div>' + '<div class="calendar-prevyear"></div>' + '<div class="calendar-nextyear"></div>' + '<div class="calendar-title">' + "<span>Aprial 2010</span>" + "</div>" + "</div>" + '<div class="calendar-body">' + '<div class="calendar-menu">' + '<div class="calendar-menu-year-inner">' + '<span class="calendar-menu-prev"></span>' + '<span><input class="calendar-menu-year" type="text"></input></span>' + '<span class="calendar-menu-next"></span>' + "</div>" + '<div class="calendar-menu-month-inner">' + "</div>" + "</div>" + "</div>");
        Z(t).find(".calendar-title span").hover(function() {
            Z(this).addClass("calendar-menu-hover");
        }, function() {
            Z(this).removeClass("calendar-menu-hover");
        }).click(function() {
            var e = Z(t).find(".calendar-menu");
            if (e.is(":visible")) {
                e.hide();
            } else {
                r(t);
            }
        });
        Z(".calendar-prevmonth,.calendar-nextmonth,.calendar-prevyear,.calendar-nextyear", t).hover(function() {
            Z(this).addClass("calendar-nav-hover");
        }, function() {
            Z(this).removeClass("calendar-nav-hover");
        });
        Z(t).find(".calendar-nextmonth").click(function() {
            e(t, 1);
        });
        Z(t).find(".calendar-prevmonth").click(function() {
            e(t, -1);
        });
        Z(t).find(".calendar-nextyear").click(function() {
            n(t, 1);
        });
        Z(t).find(".calendar-prevyear").click(function() {
            n(t, -1);
        });
        Z(t).bind("_resize", function() {
            var e = Z.data(t, "calendar").options;
            if (e.fit == true) {
                a(t);
            }
            return false;
        });
    }
    function e(e, t) {
        var a = Z.data(e, "calendar").options;
        a.month += t;
        if (a.month > 12) {
            a.year++;
            a.month = 1;
        } else {
            if (a.month < 1) {
                a.year--;
                a.month = 12;
            }
        }
        f(e);
        var i = Z(e).find(".calendar-menu-month-inner");
        i.find("td.calendar-selected").removeClass("calendar-selected");
        i.find("td:eq(" + (a.month - 1) + ")").addClass("calendar-selected");
    }
    function n(e, t) {
        var a = Z.data(e, "calendar").options;
        a.year += t;
        f(e);
        var i = Z(e).find(".calendar-menu-year");
        i.val(a.year);
    }
    function r(n) {
        var r = Z.data(n, "calendar").options;
        Z(n).find(".calendar-menu").show();
        if (Z(n).find(".calendar-menu-month-inner").is(":empty")) {
            Z(n).find(".calendar-menu-month-inner").empty();
            var e = Z('<table class="calendar-mtable"></table>').appendTo(Z(n).find(".calendar-menu-month-inner"));
            var t = 0;
            for (var a = 0; a < 3; a++) {
                var i = Z("<tr></tr>").appendTo(e);
                for (var o = 0; o < 4; o++) {
                    Z('<td class="calendar-menu-month"></td>').html(r.months[t++]).attr("abbr", t).appendTo(i);
                }
            }
            Z(n).find(".calendar-menu-prev,.calendar-menu-next").hover(function() {
                Z(this).addClass("calendar-menu-hover");
            }, function() {
                Z(this).removeClass("calendar-menu-hover");
            });
            Z(n).find(".calendar-menu-next").click(function() {
                var e = Z(n).find(".calendar-menu-year");
                if (!isNaN(e.val())) {
                    e.val(parseInt(e.val()) + 1);
                    s();
                }
            });
            Z(n).find(".calendar-menu-prev").click(function() {
                var e = Z(n).find(".calendar-menu-year");
                if (!isNaN(e.val())) {
                    e.val(parseInt(e.val() - 1));
                    s();
                }
            });
            Z(n).find(".calendar-menu-year").keypress(function(e) {
                if (e.keyCode == 13) {
                    s(true);
                }
            });
            Z(n).find(".calendar-menu-month").hover(function() {
                Z(this).addClass("calendar-menu-hover");
            }, function() {
                Z(this).removeClass("calendar-menu-hover");
            }).click(function() {
                var e = Z(n).find(".calendar-menu");
                e.find(".calendar-selected").removeClass("calendar-selected");
                Z(this).addClass("calendar-selected");
                s(true);
            });
        }
        function s(e) {
            var t = Z(n).find(".calendar-menu");
            var a = t.find(".calendar-menu-year").val();
            var i = t.find(".calendar-selected").attr("abbr");
            if (!isNaN(a)) {
                r.year = parseInt(a);
                r.month = parseInt(i);
                f(n);
            }
            if (e) {
                t.hide();
            }
        }
        var d = Z(n).find(".calendar-body");
        var l = Z(n).find(".calendar-menu");
        var c = l.find(".calendar-menu-year-inner");
        var u = l.find(".calendar-menu-month-inner");
        c.find("input").val(r.year).focus();
        u.find("td.calendar-selected").removeClass("calendar-selected");
        u.find("td:eq(" + (r.month - 1) + ")").addClass("calendar-selected");
        l._outerWidth(d._outerWidth());
        l._outerHeight(d._outerHeight());
        u._outerHeight(l.height() - c._outerHeight());
    }
    function S(e, t, a) {
        var i = Z.data(e, "calendar").options;
        var n = [];
        var r = new Date(t, a, 0).getDate();
        for (var o = 1; o <= r; o++) {
            n.push([ t, a, o ]);
        }
        var s = [], d = [];
        var l = -1;
        while (n.length > 0) {
            var c = n.shift();
            d.push(c);
            var u = new Date(c[0], c[1] - 1, c[2]).getDay();
            if (l == u) {
                u = 0;
            } else {
                if (u == (i.firstDay == 0 ? 7 : i.firstDay) - 1) {
                    s.push(d);
                    d = [];
                }
            }
            l = u;
        }
        if (d.length) {
            s.push(d);
        }
        var f = s[0];
        if (f.length < 7) {
            while (f.length < 7) {
                var h = f[0];
                var c = new Date(h[0], h[1] - 1, h[2] - 1);
                f.unshift([ c.getFullYear(), c.getMonth() + 1, c.getDate() ]);
            }
        } else {
            var h = f[0];
            var d = [];
            for (var o = 1; o <= 7; o++) {
                var c = new Date(h[0], h[1] - 1, h[2] - o);
                d.unshift([ c.getFullYear(), c.getMonth() + 1, c.getDate() ]);
            }
            s.unshift(d);
        }
        var p = s[s.length - 1];
        while (p.length < 7) {
            var v = p[p.length - 1];
            var c = new Date(v[0], v[1] - 1, v[2] + 1);
            p.push([ c.getFullYear(), c.getMonth() + 1, c.getDate() ]);
        }
        if (s.length < 6) {
            var v = p[p.length - 1];
            var d = [];
            for (var o = 1; o <= 7; o++) {
                var c = new Date(v[0], v[1] - 1, v[2] + o);
                d.push([ c.getFullYear(), c.getMonth() + 1, c.getDate() ]);
            }
            s.push(d);
        }
        return s;
    }
    function f(a) {
        var i = Z.data(a, "calendar").options;
        if (i.current && !i.validator.call(a, i.current)) {
            i.current = null;
        }
        var e = new Date();
        var t = e.getFullYear() + "," + (e.getMonth() + 1) + "," + e.getDate();
        var n = i.current ? i.current.getFullYear() + "," + (i.current.getMonth() + 1) + "," + i.current.getDate() : "";
        var r = 6 - i.firstDay;
        var o = r + 1;
        if (r >= 7) {
            r -= 7;
        }
        if (o >= 7) {
            o -= 7;
        }
        Z(a).find(".calendar-title span").html(i.months[i.month - 1] + " " + i.year);
        var s = Z(a).find("div.calendar-body");
        s.children("table").remove();
        var d = [ '<table class="calendar-dtable" cellspacing="0" cellpadding="0" border="0">' ];
        d.push("<thead><tr>");
        for (var l = i.firstDay; l < i.weeks.length; l++) {
            d.push("<th>" + i.weeks[l] + "</th>");
        }
        for (var l = 0; l < i.firstDay; l++) {
            d.push("<th>" + i.weeks[l] + "</th>");
        }
        d.push("</tr></thead>");
        d.push("<tbody>");
        var c = S(a, i.year, i.month);
        for (var l = 0; l < c.length; l++) {
            var u = c[l];
            var f = "";
            if (l == 0) {
                f = "calendar-first";
            } else {
                if (l == c.length - 1) {
                    f = "calendar-last";
                }
            }
            d.push('<tr class="' + f + '">');
            for (var h = 0; h < u.length; h++) {
                var p = u[h];
                var v = p[0] + "," + p[1] + "," + p[2];
                var g = new Date(p[0], parseInt(p[1]) - 1, p[2]);
                var b = i.formatter.call(a, g);
                var m = i.styler.call(a, g);
                var C = "";
                var Y = "";
                if (typeof m == "string") {
                    Y = m;
                } else {
                    if (m) {
                        C = m["class"] || "";
                        Y = m["style"] || "";
                    }
                }
                var f = "calendar-day";
                if (!(i.year == p[0] && i.month == p[1])) {
                    f += " calendar-other-month";
                }
                if (v == t) {
                    f += " calendar-today";
                }
                if (v == n) {
                    f += " calendar-selected";
                }
                if (h == r) {
                    f += " calendar-saturday";
                } else {
                    if (h == o) {
                        f += " calendar-sunday";
                    }
                }
                if (h == 0) {
                    f += " calendar-first";
                } else {
                    if (h == u.length - 1) {
                        f += " calendar-last";
                    }
                }
                f += " " + C;
                if (!i.validator.call(a, g)) {
                    f += " calendar-disabled";
                }
                d.push('<td class="' + f + '" abbr="' + v + '" style="' + Y + '">' + b + "</td>");
            }
            d.push("</tr>");
        }
        d.push("</tbody>");
        d.push("</table>");
        s.append(d.join(""));
        var x = s.children("table.calendar-dtable").prependTo(s);
        x.find("td.calendar-day:not(.calendar-disabled)").hover(function() {
            Z(this).addClass("calendar-hover");
        }, function() {
            Z(this).removeClass("calendar-hover");
        }).click(function() {
            var e = i.current;
            x.find(".calendar-selected").removeClass("calendar-selected");
            Z(this).addClass("calendar-selected");
            var t = Z(this).attr("abbr").split(",");
            i.current = new Date(t[0], parseInt(t[1]) - 1, t[2]);
            i.onSelect.call(a, i.current);
            if (!e || e.getTime() != i.current.getTime()) {
                i.onChange.call(a, i.current, e);
            }
        });
    }
    Z.fn.calendar = function(t, e) {
        if (typeof t == "string") {
            return Z.fn.calendar.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = Z.data(this, "calendar");
            if (e) {
                Z.extend(e.options, t);
            } else {
                e = Z.data(this, "calendar", {
                    options: Z.extend({}, Z.fn.calendar.defaults, Z.fn.calendar.parseOptions(this), t)
                });
                i(this);
            }
            if (e.options.border == false) {
                Z(this).addClass("calendar-noborder");
            }
            a(this);
            f(this);
            Z(this).find("div.calendar-menu").hide();
        });
    };
    Z.fn.calendar.methods = {
        options: function(e) {
            return Z.data(e[0], "calendar").options;
        },
        resize: function(e) {
            return e.each(function() {
                a(this);
            });
        },
        moveTo: function(e, a) {
            return e.each(function() {
                var e = Z(this).calendar("options");
                if (e.validator.call(this, a)) {
                    var t = e.current;
                    Z(this).calendar({
                        year: a.getFullYear(),
                        month: a.getMonth() + 1,
                        current: a
                    });
                    if (!t || t.getTime() != a.getTime()) {
                        e.onChange.call(this, e.current, t);
                    }
                } else {
                    f(this);
                }
            });
        }
    };
    Z.fn.calendar.parseOptions = function(e) {
        var t = Z(e);
        return Z.extend({}, Z.parser.parseOptions(e, [ "width", "height", {
            firstDay: "number",
            fit: "boolean",
            border: "boolean"
        } ]));
    };
    Z.fn.calendar.defaults = {
        width: 180,
        height: 180,
        fit: false,
        border: true,
        firstDay: 0,
        weeks: [ "S", "M", "T", "W", "T", "F", "S" ],
        months: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
        year: new Date().getFullYear(),
        month: new Date().getMonth() + 1,
        current: function() {
            var e = new Date();
            return new Date(e.getFullYear(), e.getMonth(), e.getDate());
        }(),
        formatter: function(e) {
            return e.getDate();
        },
        styler: function(e) {
            return "";
        },
        validator: function(e) {
            return true;
        },
        onSelect: function(e) {},
        onChange: function(e, t) {}
    };
})(jQuery);

(function(o) {
    function i(e) {
        var t = o('<span class="spinner">' + '<span class="spinner-arrow">' + '<span class="spinner-arrow-up"></span>' + '<span class="spinner-arrow-down"></span>' + "</span>" + "</span>").insertAfter(e);
        o(e).addClass("spinner-text spinner-f").prependTo(t);
        return t;
    }
    function n(e, t) {
        var a = o.data(e, "spinner").options;
        var i = o.data(e, "spinner").spinner;
        if (t) {
            a.width = t;
        }
        var n = o('<div style="display:none"></div>').insertBefore(i);
        i.appendTo("body");
        if (isNaN(a.width)) {
            a.width = o(e).outerWidth();
        }
        var r = i.find(".spinner-arrow");
        i._outerWidth(a.width)._outerHeight(a.height);
        o(e)._outerWidth(i.width() - r.outerWidth());
        o(e).css({
            height: i.height() + "px",
            lineHeight: i.height() + "px"
        });
        r._outerHeight(i.height());
        r.find("span")._outerHeight(r.height() / 2);
        i.insertAfter(n);
        n.remove();
    }
    function r(t) {
        var a = o.data(t, "spinner").options;
        var e = o.data(t, "spinner").spinner;
        o(t).unbind(".spinner");
        e.find(".spinner-arrow-up,.spinner-arrow-down").unbind(".spinner");
        if (!a.disabled && !a.readonly) {
            e.find(".spinner-arrow-up").bind("mouseenter.spinner", function() {
                o(this).addClass("spinner-arrow-hover");
            }).bind("mouseleave.spinner", function() {
                o(this).removeClass("spinner-arrow-hover");
            }).bind("click.spinner", function() {
                a.spin.call(t, false);
                a.onSpinUp.call(t);
                o(t).validatebox("validate");
            });
            e.find(".spinner-arrow-down").bind("mouseenter.spinner", function() {
                o(this).addClass("spinner-arrow-hover");
            }).bind("mouseleave.spinner", function() {
                o(this).removeClass("spinner-arrow-hover");
            }).bind("click.spinner", function() {
                a.spin.call(t, true);
                a.onSpinDown.call(t);
                o(t).validatebox("validate");
            });
            o(t).bind("change.spinner", function() {
                o(this).spinner("setValue", o(this).val());
            });
            e.find(".spinner-text").unbind("keydown.spinner").bind("keydown.spinner", function(e) {
                if ("undefined" == typeof e.keyCode) {
                    return;
                }
                switch (e.keyCode) {
                  case 38:
                    a.keyHandler.up.call(t, e);
                    break;

                  case 40:
                    a.keyHandler.down.call(t, e);
                    break;

                  case 13:
                    e.preventDefault();
                    a.keyHandler.enter.call(t, e);
                    return false;

                  default:
                    ;
                }
            });
        }
    }
    function s(e, t) {
        var a = o.data(e, "spinner").options;
        if (t) {
            a.disabled = true;
            o(e).attr("disabled", true);
            o.data(e, "spinner").spinner.addClass("disabled");
        } else {
            a.disabled = false;
            o(e).removeAttr("disabled");
            o.data(e, "spinner").spinner.removeClass("disabled");
        }
    }
    function d(e, t) {
        var a = o.data(e, "spinner");
        var i = a.options;
        i.readonly = t == undefined ? true : t;
        var n = i.readonly ? true : !i.editable;
        o(e).attr("readonly", n).css("cursor", n ? "pointer" : "");
    }
    o.fn.spinner = function(t, e) {
        if (typeof t == "string") {
            var a = o.fn.spinner.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.validatebox(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = o.data(this, "spinner");
            if (e) {
                o.extend(e.options, t);
            } else {
                e = o.data(this, "spinner", {
                    options: o.extend({}, o.fn.spinner.defaults, o.fn.spinner.parseOptions(this), t),
                    spinner: i(this)
                });
                o(this).removeAttr("disabled");
            }
            e.options.originalValue = e.options.value;
            o(this).val(e.options.value);
            s(this, e.options.disabled);
            d(this, e.options.readonly);
            if (true !== o(this).data("rendered")) n(this);
            o(this).validatebox(e.options);
            r(this);
            o(this).data("rendered", true);
        });
    };
    o.fn.spinner.methods = {
        options: function(e) {
            var t = o.data(e[0], "spinner").options;
            return o.extend(t, {
                value: e.val()
            });
        },
        destroy: function(e) {
            return e.each(function() {
                var e = o.data(this, "spinner").spinner;
                o(this).validatebox("destroy");
                e.remove();
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                n(this, t);
            });
        },
        enable: function(e) {
            return e.each(function() {
                s(this, false);
                r(this);
            });
        },
        disable: function(e) {
            return e.each(function() {
                s(this, true);
                r(this);
            });
        },
        readonly: function(e, t) {
            return e.each(function() {
                d(this, t);
                r(this);
            });
        },
        getValue: function(e) {
            return e.val();
        },
        setValue: function(e, a) {
            return e.each(function() {
                var e = o.data(this, "spinner").options;
                var t = e.value;
                e.value = a;
                o(this).val(a);
                if (t != a) {
                    e.onChange.call(this, a, t);
                }
            });
        },
        clear: function(e) {
            return e.each(function() {
                var e = o.data(this, "spinner").options;
                e.value = "";
                o(this).val("");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = o(this).spinner("options");
                o(this).spinner("setValue", e.originalValue);
            });
        }
    };
    o.fn.spinner.parseOptions = function(e) {
        var t = o(e);
        return o.extend({}, o.fn.validatebox.parseOptions(e), o.parser.parseOptions(e, [ "width", "height", "min", "max", {
            increment: "number",
            editable: "boolean"
        } ]), {
            value: t.val() || undefined,
            disabled: t.attr("disabled") ? true : undefined,
            readonly: t.attr("readonly") ? true : undefined
        });
    };
    o.fn.spinner.defaults = o.extend({}, o.fn.validatebox.defaults, {
        width: "auto",
        height: 30,
        deltaX: 19,
        value: "",
        min: null,
        max: null,
        increment: 1,
        editable: true,
        disabled: false,
        readonly: false,
        spin: function(e) {},
        onSpinUp: function() {},
        onSpinDown: function() {},
        onChange: function(e, t) {},
        keyHandler: {
            up: function(e) {},
            down: function(e) {},
            enter: function(e) {}
        }
    });
})(jQuery);

(function(n) {
    function i(e) {
        n(e).addClass("numberspinner-f");
        var t = n.data(e, "numberspinner").options;
        n(e).spinner(t).numberbox(n.extend({}, t, {
            width: "auto"
        }));
    }
    function t(e, t) {
        var a = n.data(e, "numberspinner").options;
        var i = parseFloat(n(e).numberbox("getValue") || a.value) || 0;
        if (t == true) {
            i -= a.increment;
        } else {
            i += a.increment;
        }
        n(e).numberbox("setValue", i);
    }
    n.fn.numberspinner = function(t, e) {
        if (typeof t == "string") {
            var a = n.fn.numberspinner.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.spinner(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = n.data(this, "numberspinner");
            if (e) {
                n.extend(e.options, t);
            } else {
                n.data(this, "numberspinner", {
                    options: n.extend({}, n.fn.numberspinner.defaults, n.fn.numberspinner.parseOptions(this), t)
                });
            }
            i(this);
        });
    };
    n.fn.numberspinner.methods = {
        options: function(e) {
            var t = n.data(e[0], "numberspinner").options;
            return n.extend(t, {
                value: e.numberbox("getValue"),
                originalValue: e.numberbox("options").originalValue
            });
        },
        setValue: function(e, t) {
            return e.each(function() {
                n(this).numberbox("setValue", t);
            });
        },
        getValue: function(e) {
            return e.numberbox("getValue");
        },
        clear: function(e) {
            return e.each(function() {
                n(this).spinner("clear");
                n(this).numberbox("clear");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = n(this).numberspinner("options");
                n(this).numberspinner("setValue", e.originalValue);
            });
        }
    };
    n.fn.numberspinner.parseOptions = function(e) {
        return n.extend({}, n.fn.spinner.parseOptions(e), n.fn.numberbox.parseOptions(e), {});
    };
    n.fn.numberspinner.defaults = n.extend({}, n.fn.spinner.defaults, n.fn.numberbox.defaults, {
        spin: function(e) {
            t(this, e);
        }
    });
})(jQuery);

(function(l) {
    function i(i) {
        var n = l.data(i, "timespinner").options;
        l(i).addClass("timespinner-f");
        l(i).spinner(n);
        l(i).unbind(".timespinner");
        l(i).bind("click.timespinner", function() {
            var e = 0;
            if (this.selectionStart != null) {
                e = this.selectionStart;
            } else {
                if (this.createTextRange) {
                    var t = i.createTextRange();
                    var a = document.selection.createRange();
                    a.setEndPoint("StartToStart", t);
                    e = a.text.length;
                }
            }
            n.highlight = r(e);
            s(i);
        }).bind("blur.timespinner", function() {
            d(i);
        });
    }
    function r(e) {
        if (e >= 0 && e <= 2) {
            return 0;
        } else {
            if (e >= 3 && e <= 5) {
                return 1;
            } else {
                if (e >= 6 && e <= 8) {
                    return 2;
                }
            }
        }
        return 0;
    }
    function s(e) {
        var t = l.data(e, "timespinner").options;
        var a = 0, i = 0;
        if (e.selectionStart != null) {
            t.highlight = r(e.selectionStart);
        }
        if (t.highlight == 0) {
            a = 0;
            i = 2;
        } else {
            if (t.highlight == 1) {
                a = 3;
                i = 5;
            } else {
                if (t.highlight == 2) {
                    a = 6;
                    i = 8;
                }
            }
        }
        if (e.selectionStart != null) {
            e.setSelectionRange(a, i);
        } else {
            if (e.createTextRange) {
                var n = e.createTextRange();
                n.collapse();
                n.moveEnd("character", i);
                n.moveStart("character", a);
                n.select();
            }
        }
        l(e).focus();
    }
    function o(e) {
        var t = [];
        if (e) {
            e = e.replace(/\s/g, "");
            var a = /^([0-2][0-9])([0-6][0-9])([0-9]*)$/;
            var i = /^([3-9])([0-6][0-9])([0-6]*)$/;
            var n = /^([0-2][0-9])$/;
            if (n.test(e)) {
                t = e.match(n);
                t.splice(0, 1);
            } else if (a.test(e)) {
                t = e.match(a);
                t.splice(0, 1);
            } else if (i.test(e)) {
                t = e.match(i);
                t.splice(0, 1);
            }
        }
        return t;
    }
    function c(e, t) {
        var a = l.data(e, "timespinner").options;
        if (!t) {
            return null;
        }
        var i = [];
        if (t.indexOf(a.separator) > -1) {
            i = t.split(a.separator);
            for (var n = 0; n < i.length; n++) {
                if (isNaN(i[n])) {
                    return null;
                }
            }
        } else {
            i = o(t);
        }
        while (i.length < 3) {
            i.push(0);
        }
        return new Date(1900, 0, 0, i[0], i[1], i[2]);
    }
    function d(e) {
        var t = l.data(e, "timespinner").options;
        var a = l(e).val();
        var i = c(e, a);
        if (!i) {
            t.value = "";
            l(e).spinner("setValue", "");
            return;
        }
        var n = c(e, t.min);
        var r = c(e, t.max);
        if (n && n > i) {
            i = n;
        }
        if (r && r < i) {
            i = r;
        }
        var o = [ d(i.getHours()), d(i.getMinutes()) ];
        if (t.showSeconds) {
            o.push(d(i.getSeconds()));
        }
        var s = o.join(t.separator);
        t.value = s;
        l(e).spinner("setValue", s);
        function d(e) {
            return (e < 10 ? "0" : "") + e;
        }
    }
    function t(e, t) {
        var a = l.data(e, "timespinner").options;
        var i = l(e).val();
        if (i == "") {
            i = [ 0, 0, 0 ].join(a.separator);
        }
        var n = i.split(a.separator);
        for (var r = 0; r < n.length; r++) {
            n[r] = parseInt(n[r], 10);
        }
        if (t == true) {
            n[a.highlight] -= a.increment;
        } else {
            n[a.highlight] += a.increment;
        }
        var o = e.selectionStart;
        l(e).val(n.join(a.separator));
        d(e);
        e.selectionStart = o;
        s(e);
    }
    l.fn.timespinner = function(t, e) {
        if (typeof t == "string") {
            var a = l.fn.timespinner.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.spinner(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = l.data(this, "timespinner");
            if (e) {
                l.extend(e.options, t);
            } else {
                l.data(this, "timespinner", {
                    options: l.extend({}, l.fn.timespinner.defaults, l.fn.timespinner.parseOptions(this), t)
                });
            }
            i(this);
        });
    };
    l.fn.timespinner.methods = {
        options: function(e) {
            var t = l.data(e[0], "timespinner").options;
            return l.extend(t, {
                value: e.val(),
                originalValue: e.spinner("options").originalValue
            });
        },
        setValue: function(e, t) {
            return e.each(function() {
                l(this).val(t);
                d(this);
            });
        },
        getHours: function(e) {
            var t = l.data(e[0], "timespinner").options;
            var a = e.val().split(t.separator);
            return parseInt(a[0], 10);
        },
        getMinutes: function(e) {
            var t = l.data(e[0], "timespinner").options;
            var a = e.val().split(t.separator);
            return parseInt(a[1], 10);
        },
        getSeconds: function(e) {
            var t = l.data(e[0], "timespinner").options;
            var a = e.val().split(t.separator);
            return parseInt(a[2], 10) || 0;
        }
    };
    l.fn.timespinner.parseOptions = function(e) {
        return l.extend({}, l.fn.spinner.parseOptions(e), l.parser.parseOptions(e, [ "separator", {
            showSeconds: "boolean",
            highlight: "number"
        } ]));
    };
    l.fn.timespinner.defaults = l.extend({}, l.fn.spinner.defaults, {
        separator: ":",
        showSeconds: false,
        highlight: 0,
        spin: function(e) {
            t(this, e);
        },
        keyHandler: {
            up: function(e) {
                e.preventDefault();
                s(this);
                t(this, false);
                return false;
            },
            down: function(e) {
                e.preventDefault();
                s(this);
                t(this, true);
                return false;
            },
            enter: function(e) {
                d(this);
            }
        }
    });
})(jQuery);

(function($) {
    var _501 = 0;
    function _502(e, t) {
        for (var a = 0, i = e.length; a < i; a++) {
            if (e[a] == t) {
                return a;
            }
        }
        return -1;
    }
    function _503(e, t, a) {
        if (typeof t == "string") {
            for (var i = 0, n = e.length; i < n; i++) {
                if (e[i][t] == a) {
                    e.splice(i, 1);
                    return;
                }
            }
        } else {
            var r = _502(e, t);
            if (r != -1) {
                e.splice(r, 1);
            }
        }
    }
    function _505(e, t, a) {
        for (var i = 0, n = e.length; i < n; i++) {
            if (e[i][t] == a[t]) {
                return;
            }
        }
        e.push(a);
    }
    function _506(e) {
        var t = $.data(e, "datagrid");
        var a = t.options;
        var i = t.panel;
        var n = t.dc;
        var r = null;
        if (a.sharedStyleSheet) {
            r = typeof a.sharedStyleSheet == "boolean" ? "head" : a.sharedStyleSheet;
        } else {
            r = i.closest("div.datagrid-view");
            if (!r.length) {
                r = n.view;
            }
        }
        var o = $(r);
        var s = $.data(o[0], "ss");
        if (!s) {
            s = $.data(o[0], "ss", {
                cache: {},
                dirty: []
            });
        }
        return {
            add: function(e) {
                var t = [ '<style type="text/css" hisui="true">' ];
                for (var a = 0; a < e.length; a++) {
                    s.cache[e[a][0]] = {
                        width: e[a][1]
                    };
                }
                var i = 0;
                for (var n in s.cache) {
                    var r = s.cache[n];
                    r.index = i++;
                    t.push(n + "{width:" + r.width + "}");
                }
                t.push("</style>");
                $(t.join("\n")).appendTo(o);
                o.children("style[hisui]:not(:last)").remove();
            },
            getRule: function(e) {
                var t = o.children("style[hisui]:last")[0];
                var a = t.styleSheet ? t.styleSheet : t.sheet || document.styleSheets[document.styleSheets.length - 1];
                var i = a.cssRules || a.rules;
                return i[e];
            },
            set: function(e, t) {
                var a = s.cache[e];
                if (a) {
                    a.width = t;
                    var i = this.getRule(a.index);
                    if (i) {
                        i.style["width"] = t;
                    }
                }
            },
            remove: function(e) {
                var t = [];
                for (var a in s.cache) {
                    if (a.indexOf(e) == -1) {
                        t.push([ a, s.cache[a].width ]);
                    }
                }
                s.cache = {};
                this.add(t);
            },
            dirty: function(e) {
                if (e) {
                    s.dirty.push(e);
                }
            },
            clean: function() {
                for (var e = 0; e < s.dirty.length; e++) {
                    this.remove(s.dirty[e]);
                }
                s.dirty = [];
            }
        };
    }
    function _515(e, t) {
        var a = $.data(e, "datagrid").options;
        var i = $.data(e, "datagrid").panel;
        if (t) {
            if (t.width) {
                a.width = t.width;
            }
            if (t.height) {
                a.height = t.height;
            }
        }
        if (a.fit == true) {
            var n = i.panel("panel").parent();
            a.width = n.width();
            a.height = n.height();
        }
        i.panel("resize", {
            width: a.width,
            height: a.height
        });
    }
    function _519(e) {
        var t = $.data(e, "datagrid").options;
        var a = $.data(e, "datagrid").dc;
        var i = $.data(e, "datagrid").panel;
        var n = i.width();
        var r = i.height();
        var o = a.view;
        var s = a.view1;
        var d = a.view2;
        var l = s.children("div.datagrid-header");
        var c = d.children("div.datagrid-header");
        var u = l.find("table");
        var f = c.find("table");
        o.width(n);
        var h = l.children("div.datagrid-header-inner").show();
        s.width(h.find("table").width());
        if (!t.showHeader) {
            h.hide();
        }
        d.width(n - s._outerWidth());
        s.children("div.datagrid-header,div.datagrid-body,div.datagrid-footer").width(s.width());
        d.children("div.datagrid-header,div.datagrid-body,div.datagrid-footer").width(d.width());
        var p;
        l.css("height", "");
        c.css("height", "");
        u.css("height", "");
        f.css("height", "");
        p = Math.max(u.height(), f.height());
        u.height(p);
        f.height(p);
        l.add(c)._outerHeight(p);
        if (t.height != "auto") {
            var v = r - d.children("div.datagrid-header")._outerHeight() - d.children("div.datagrid-footer")._outerHeight() - i.children("div.datagrid-toolbar")._outerHeight() - i.children("div.datagrid-btoolbar")._outerHeight();
            i.children("div.datagrid-pager").each(function() {
                v -= $(this)._outerHeight();
            });
            a.body1.add(a.body2).children("table.datagrid-btable-frozen").css({
                position: "absolute",
                top: a.header2._outerHeight()
            });
            var g = a.body2.children("table.datagrid-btable-frozen")._outerHeight();
            s.add(d).children("div.datagrid-body").css({
                marginTop: g,
                height: v - g
            });
        }
        o.height(d.height());
    }
    function _526(e, t, a) {
        var i = $.data(e, "datagrid").data.rows;
        var n = $.data(e, "datagrid").options;
        var r = $.data(e, "datagrid").dc;
        if (!r.body1.is(":empty") && (!n.nowrap || n.autoRowHeight || a)) {
            if (t != undefined) {
                var o = n.finder.getTr(e, t, "body", 1);
                var s = n.finder.getTr(e, t, "body", 2);
                f(o, s);
            } else {
                var o = n.finder.getTr(e, 0, "allbody", 1);
                var s = n.finder.getTr(e, 0, "allbody", 2);
                f(o, s);
                if (n.showFooter) {
                    var o = n.finder.getTr(e, 0, "allfooter", 1);
                    var s = n.finder.getTr(e, 0, "allfooter", 2);
                    f(o, s);
                }
            }
        }
        _519(e);
        if (n.height == "auto") {
            var d = r.body1.parent();
            var l = r.body2;
            var c = h(l);
            var u = c.height;
            if (c.width > l.width()) {
                u += 18;
            }
            d.height(u);
            l.height(u);
            r.view.height(r.view2.height());
        }
        r.body2.triggerHandler("scroll");
        function f(e, t) {
            for (var a = 0; a < t.length; a++) {
                var i = $(e[a]);
                var n = $(t[a]);
                i.css("height", "");
                n.css("height", "");
                var r = Math.max(i.height(), n.height());
                i.css("height", r);
                n.css("height", r);
            }
        }
        function h(e) {
            var t = 0;
            var a = 0;
            $(e).children().each(function() {
                var e = $(this);
                if (e.is(":visible")) {
                    a += e._outerHeight();
                    if (t < e._outerWidth()) {
                        t = e._outerWidth();
                    }
                }
            });
            return {
                width: t,
                height: a
            };
        }
    }
    function _533(i, n) {
        var e = $.data(i, "datagrid");
        var r = e.options;
        var o = e.dc;
        if (!o.body2.children("table.datagrid-btable-frozen").length) {
            o.body1.add(o.body2).prepend('<table class="datagrid-btable datagrid-btable-frozen" cellspacing="0" cellpadding="0"></table>');
        }
        t(true);
        t(false);
        _519(i);
        function t(e) {
            var t = e ? 1 : 2;
            var a = r.finder.getTr(i, n, "body", t);
            (e ? o.body1 : o.body2).children("table.datagrid-btable-frozen").append(a);
        }
    }
    function _53a(_53b, _53c) {
        function _53d() {
            var _53e = [];
            var _53f = [];
            $(_53b).children("thead").each(function() {
                var opt = $.parser.parseOptions(this, [ {
                    frozen: "boolean"
                } ]);
                $(this).find("tr").each(function() {
                    var cols = [];
                    $(this).find("th").each(function() {
                        var th = $(this);
                        var col = $.extend({}, $.parser.parseOptions(this, [ "field", "align", "halign", "order", {
                            sortable: "boolean",
                            checkbox: "boolean",
                            resizable: "boolean",
                            fixed: "boolean"
                        }, {
                            rowspan: "number",
                            colspan: "number",
                            width: "number"
                        } ]), {
                            title: th.html() || undefined,
                            hidden: th.attr("hidden") ? true : undefined,
                            formatter: th.attr("formatter") ? eval(th.attr("formatter")) : undefined,
                            styler: th.attr("styler") ? eval(th.attr("styler")) : undefined,
                            sorter: th.attr("sorter") ? eval(th.attr("sorter")) : undefined
                        });
                        if (th.attr("editor")) {
                            var s = $.trim(th.attr("editor"));
                            if (s.substr(0, 1) == "{") {
                                col.editor = eval("(" + s + ")");
                            } else {
                                col.editor = s;
                            }
                        }
                        cols.push(col);
                    });
                    opt.frozen ? _53e.push(cols) : _53f.push(cols);
                });
            });
            return [ _53e, _53f ];
        }
        var _540 = $('<div class="datagrid-wrap">' + '<div class="datagrid-view">' + '<div class="datagrid-view1">' + '<div class="datagrid-header">' + '<div class="datagrid-header-inner"></div>' + "</div>" + '<div class="datagrid-body">' + '<div class="datagrid-body-inner"></div>' + "</div>" + '<div class="datagrid-footer">' + '<div class="datagrid-footer-inner"></div>' + "</div>" + "</div>" + '<div class="datagrid-view2">' + '<div class="datagrid-header">' + '<div class="datagrid-header-inner"></div>' + "</div>" + '<div class="datagrid-body"></div>' + '<div class="datagrid-footer">' + '<div class="datagrid-footer-inner"></div>' + "</div>" + "</div>" + "</div>" + "</div>").insertAfter(_53b);
        _540.panel({
            doSize: false
        });
        _540.panel("panel").addClass("datagrid").bind("_resize", function(e, t) {
            var a = $.data(_53b, "datagrid").options;
            if (a.fit == true || t) {
                _515(_53b);
                setTimeout(function() {
                    if ($.data(_53b, "datagrid")) {
                        _542(_53b);
                    }
                }, 0);
            }
            return false;
        });
        $(_53b).addClass("datagrid-f").hide().appendTo(_540.children("div.datagrid-view"));
        var cc = _53d();
        var view = _540.children("div.datagrid-view");
        var _543 = view.children("div.datagrid-view1");
        var _544 = view.children("div.datagrid-view2");
        return {
            panel: _540,
            frozenColumns: cc[0],
            columns: cc[1],
            dc: {
                view: view,
                view1: _543,
                view2: _544,
                header1: _543.children("div.datagrid-header").children("div.datagrid-header-inner"),
                header2: _544.children("div.datagrid-header").children("div.datagrid-header-inner"),
                body1: _543.children("div.datagrid-body").children("div.datagrid-body-inner"),
                body2: _544.children("div.datagrid-body"),
                footer1: _543.children("div.datagrid-footer").children("div.datagrid-footer-inner"),
                footer2: _544.children("div.datagrid-footer").children("div.datagrid-footer-inner")
            }
        };
    }
    function _545(_546) {
        var _547 = $.data(_546, "datagrid");
        var opts = _547.options;
        var dc = _547.dc;
        var _548 = _547.panel;
        _547.ss = $(_546).datagrid("createStyleSheet");
        _548.panel($.extend({}, opts, {
            id: null,
            doSize: false,
            onResize: function(e, t) {
                setTimeout(function() {
                    if ($.data(_546, "datagrid")) {
                        _519(_546);
                        _579(_546);
                        opts.onResize.call(_548, e, t);
                    }
                }, 0);
            },
            onExpand: function() {
                _526(_546);
                opts.onExpand.call(_548);
            }
        }));
        _547.rowIdPrefix = "datagrid-row-r" + ++_501;
        _547.cellClassPrefix = "datagrid-cell-c" + _501;
        _54b(dc.header1, opts.frozenColumns, true);
        _54b(dc.header2, opts.columns, false);
        _54c();
        dc.header1.add(dc.header2).css("display", opts.showHeader ? "block" : "none");
        dc.footer1.add(dc.footer2).css("display", opts.showFooter ? "block" : "none");
        if (opts.toolbar) {
            if ($.isArray(opts.toolbar)) {
                $("div.datagrid-toolbar", _548).remove();
                var tb = $('<div class="datagrid-toolbar"><table cellspacing="0" cellpadding="0"><tr></tr></table></div>').prependTo(_548);
                var tr = tb.find("tr");
                for (var i = 0; i < opts.toolbar.length; i++) {
                    var btn = opts.toolbar[i];
                    if (btn == "-") {
                        $('<td><div class="datagrid-btn-separator"></div></td>').appendTo(tr);
                    } else {
                        var td = $("<td></td>").appendTo(tr);
                        var tool = $('<a href="javascript:void(0)"></a>').appendTo(td);
                        tool[0].onclick = eval(btn.handler || function() {});
                        tool.linkbutton($.extend({}, btn, {
                            plain: true
                        }));
                    }
                }
            } else {
                $(opts.toolbar).addClass("datagrid-toolbar").prependTo(_548);
                $(opts.toolbar).show();
            }
        } else {
            $("div.datagrid-toolbar", _548).remove();
        }
        $("div.datagrid-pager", _548).remove();
        if (opts.pagination) {
            var _54d = $('<div class="datagrid-pager"></div>');
            if (opts.pagePosition == "bottom") {
                _54d.appendTo(_548);
            } else {
                if (opts.pagePosition == "top") {
                    _54d.addClass("datagrid-pager-top").prependTo(_548);
                } else {
                    var ptop = $('<div class="datagrid-pager datagrid-pager-top"></div>').prependTo(_548);
                    _54d.appendTo(_548);
                    _54d = _54d.add(ptop);
                }
            }
            _54d.pagination({
                total: opts.pageNumber * opts.pageSize,
                pageNumber: opts.pageNumber,
                showRefresh: opts.showRefresh,
                showPageList: opts.showPageList,
                afterPageText: opts.afterPageText,
                beforePageText: opts.beforePageText,
                displayMsg: opts.displayMsg,
                pageSize: opts.pageSize,
                pageList: opts.pageList,
                onSelectPage: function(e, t) {
                    opts.pageNumber = e;
                    opts.pageSize = t;
                    _54d.pagination("refresh", {
                        pageNumber: e,
                        pageSize: t
                    });
                    _577(_546);
                }
            });
            opts.pageSize = _54d.pagination("options").pageSize;
        }
        dc.body2.html("<div style='width:" + dc.view2.find(".datagrid-header-row").width() + "px;border:solid 0px;height:1px;'></div>");
        function _54b(e, t, a) {
            if (!t) {
                return;
            }
            $(e).show();
            $(e).empty();
            var i = [];
            var n = [];
            if (opts.sortName) {
                i = opts.sortName.split(",");
                n = opts.sortOrder.split(",");
            }
            var r = $('<table class="datagrid-htable" border="0" cellspacing="0" cellpadding="0"><tbody></tbody></table>').appendTo(e);
            for (var o = 0; o < t.length; o++) {
                var s = $('<tr class="datagrid-header-row"></tr>').appendTo($("tbody", r));
                var d = t[o];
                for (var l = 0; l < d.length; l++) {
                    var c = d[l];
                    var u = "";
                    if (c.rowspan) {
                        u += 'rowspan="' + c.rowspan + '" ';
                    }
                    if (c.colspan) {
                        u += 'colspan="' + c.colspan + '" ';
                    }
                    var f = $("<td " + u + "></td>").appendTo(s);
                    if (c.checkbox) {
                        f.attr("field", c.field);
                        $('<div class="datagrid-header-check"></div>').html('<input type="checkbox"/>').appendTo(f);
                    } else {
                        if (c.field) {
                            f.attr("field", c.field);
                            f.append('<div class="datagrid-cell"><span></span><span class="datagrid-sort-icon"></span></div>');
                            $("span", f).html(c.title);
                            $("span.datagrid-sort-icon", f).html("");
                            var h = f.find("div.datagrid-cell");
                            var p = _502(i, c.field);
                            if (p >= 0) {
                                h.addClass("datagrid-sort-" + n[p]);
                            }
                            if (c.resizable == false) {
                                h.attr("resizable", "false");
                            }
                            if (c.width) {
                                h._outerWidth(c.width);
                                c.boxWidth = parseInt(h[0].style.width);
                            } else {
                                c.auto = true;
                            }
                            h.css("text-align", c.halign || c.align || "");
                            c.cellClass = _547.cellClassPrefix + "-" + c.field.replace(/[\.|\s]/g, "-");
                            h.addClass(c.cellClass).css("width", "");
                        } else {
                            $('<div class="datagrid-cell-group"></div>').html(c.title).appendTo(f);
                        }
                    }
                    if (c.hidden) {
                        f.hide();
                    }
                }
            }
            if (a && opts.rownumbers) {
                var f = $('<td rowspan="' + opts.frozenColumns.length + '"><div class="datagrid-header-rownumber"></div></td>');
                if ($("tr", r).length == 0) {
                    f.wrap('<tr class="datagrid-header-row"></tr>').parent().appendTo($("tbody", r));
                } else {
                    f.prependTo($("tr:first", r));
                }
            }
        }
        function _54c() {
            var e = [];
            var t = _557(_546, true).concat(_557(_546));
            for (var a = 0; a < t.length; a++) {
                var i = _558(_546, t[a]);
                if (i && !i.checkbox) {
                    e.push([ "." + i.cellClass, i.boxWidth ? i.boxWidth + "px" : "auto" ]);
                }
            }
            _547.ss.add(e);
            _547.ss.dirty(_547.cellSelectorPrefix);
            _547.cellSelectorPrefix = "." + _547.cellClassPrefix;
        }
        if (opts.btoolbar) {
            if ($.isArray(opts.btoolbar)) {
                $("div.datagrid-btoolbar", _548).remove();
                var tb = $('<div class="datagrid-btoolbar"><table cellspacing="0" cellpadding="0"><tr></tr></table></div>').appendTo(_548);
                var tr = tb.find("tr");
                for (var i = 0; i < opts.btoolbar.length; i++) {
                    var btn = opts.btoolbar[i];
                    if (btn == "-") {
                        $('<td><div class="datagrid-btn-separator"></div></td>').appendTo(tr);
                    } else {
                        var td = $("<td></td>").appendTo(tr);
                        var tool = $('<a href="javascript:void(0)"></a>').appendTo(td);
                        tool[0].onclick = eval(btn.handler || function() {});
                        tool.linkbutton($.extend({}, btn, {
                            plain: true
                        }));
                    }
                }
            } else {
                $(opts.btoolbar).addClass("datagrid-btoolbar").appendTo(_548);
                $(opts.btoolbar).show();
            }
        } else {
            $("div.datagrid-btoolbar", _548).remove();
        }
    }
    function _559(c) {
        var u = $.data(c, "datagrid");
        var t = u.panel;
        var s = u.options;
        var r = u.dc;
        var i = r.header1.add(r.header2);
        i.find("input[type=checkbox]").unbind(".datagrid").bind("click.datagrid", function(e) {
            if (s.singleSelect && s.selectOnCheck) {
                return false;
            }
            if ($(this).is(":checked")) {
                _5df(c);
            } else {
                _5e5(c);
            }
            e.stopPropagation();
        });
        var e = i.find("div.datagrid-cell");
        e.closest("td").unbind(".datagrid").bind("mouseenter.datagrid", function() {
            if (u.resizing) {
                return;
            }
            $(this).addClass("datagrid-header-over");
        }).bind("mouseleave.datagrid", function() {
            $(this).removeClass("datagrid-header-over");
        }).bind("contextmenu.datagrid", function(e) {
            var t = $(this).attr("field");
            s.onHeaderContextMenu.call(c, e, t);
        }).bind("dblclick.datagrid", function(e) {
            var t = $(this).attr("field");
            if (s.queryName != "") {
                e.preventDefault();
                var a = $cm({
                    ClassName: "BSP.SYS.SRV.SSGroup",
                    MethodName: "CurrAllowColumnMgr"
                }, false);
                if (a == 1) websys_lu("../csp/websys.component.customiselayout.csp?ID=1872&DHCICARE=2&CONTEXT=K" + s.className + ":" + s.queryName, false, "hisui=true");
                return false;
            } else {
                s.onDblClickHeader.call(c, e, t);
            }
        });
        e.unbind(".datagrid").bind("click.datagrid", function(e) {
            var t = $(this).offset().left + 5;
            var a = $(this).offset().left + $(this)._outerWidth() - 5;
            if (e.pageX < a && e.pageX > t) {
                _56c(c, $(this).parent().attr("field"));
            }
        }).bind("dblclick.datagrid", function(e) {
            var t = $(this).offset().left + 5;
            var a = $(this).offset().left + $(this)._outerWidth() - 5;
            var i = s.resizeHandle == "right" ? e.pageX > a : s.resizeHandle == "left" ? e.pageX < t : e.pageX < t || e.pageX > a;
            if (i) {
                var n = $(this).parent().attr("field");
                var r = _558(c, n);
                if (r.resizable == false) {
                    return;
                }
                $(c).datagrid("autoSizeColumn", n);
                r.auto = false;
            }
        });
        var a = s.resizeHandle == "right" ? "e" : s.resizeHandle == "left" ? "w" : "e,w";
        e.each(function() {
            $(this).resizable({
                handles: a,
                disabled: $(this).attr("resizable") ? $(this).attr("resizable") == "false" : false,
                minWidth: 25,
                onStartResize: function(e) {
                    u.resizing = true;
                    i.css("cursor", $("body").css("cursor"));
                    if (!u.proxy) {
                        u.proxy = $('<div class="datagrid-resize-proxy"></div>').appendTo(r.view);
                    }
                    u.proxy.css({
                        left: e.pageX - $(t).offset().left - 1,
                        display: "none"
                    });
                    setTimeout(function() {
                        if (u.proxy) {
                            u.proxy.show();
                        }
                    }, 500);
                },
                onResize: function(e) {
                    u.proxy.css({
                        left: e.pageX - $(t).offset().left - 1,
                        display: "block"
                    });
                    return false;
                },
                onStopResize: function(e) {
                    i.css("cursor", "");
                    $(this).css("height", "");
                    $(this)._outerWidth($(this)._outerWidth());
                    var t = $(this).parent().attr("field");
                    var a = _558(c, t);
                    a.width = $(this)._outerWidth();
                    a.boxWidth = parseInt(this.style.width);
                    a.auto = undefined;
                    $(this).css("width", "");
                    _542(c, t);
                    u.proxy.remove();
                    u.proxy = null;
                    if ($(this).parents("div:first.datagrid-header").parent().hasClass("datagrid-view1")) {
                        _519(c);
                    }
                    _579(c);
                    s.onResizeColumn.call(c, t, a.width);
                    setTimeout(function() {
                        u.resizing = false;
                    }, 0);
                }
            });
        });
        function n(e) {
            var t = $(e.target);
            var a = t.closest("tr.datagrid-row");
            if (!h(a)) {
                return;
            }
            var i = f(a);
            if (t.parent().hasClass("datagrid-cell-check")) {
                if (s.singleSelect && s.selectOnCheck) {
                    if (!s.checkOnSelect) {
                        _5e5(c, true);
                    }
                    _5d2(c, i);
                } else {
                    if (t.is(":checked")) {
                        _5d2(c, i);
                    } else {
                        _5d9(c, i);
                    }
                }
            } else {
                var n = s.finder.getRow(c, i);
                var r = t.closest("td[field]", a);
                if (r.length) {
                    var o = r.attr("field");
                    s.onClickCell.call(c, i, o, n[o]);
                }
                if (s.singleSelect == true) {
                    _5cb(c, i);
                } else {
                    if (s.ctrlSelect) {
                        if (e.ctrlKey) {
                            if (a.hasClass("datagrid-row-selected")) {
                                _5d3(c, i);
                            } else {
                                _5cb(c, i);
                            }
                        } else {
                            $(c).datagrid("clearSelections");
                            _5cb(c, i);
                        }
                    } else {
                        if (a.hasClass("datagrid-row-selected")) {
                            _5d3(c, i);
                        } else {
                            _5cb(c, i);
                        }
                    }
                }
                s.onClickRow.call(c, i, n);
            }
        }
        var o = $.hisui.debounce && parseInt(s.clickDelay) > 0 ? $.hisui.debounce(n, parseInt(s.clickDelay)) : n;
        r.body1.add(r.body2).unbind().bind("mouseover", function(e) {
            if (u.resizing) {
                return;
            }
            var t = $(e.target);
            var a = undefined;
            if ("undefined" == typeof t.attr("field")) {
                t = t.closest("td");
            }
            a = t.attr("field");
            if (a) {
                var i = $.data(c, "datagrid");
                var n = i.options.columns;
                for (var r = 0; r < n.length; r++) {
                    for (var o = 0; o < n[r].length; o++) {
                        if (n[r][o].field == a) {
                            if (n[r][o].showTip) {
                                var s = n[r][o].tipWidth || 350;
                                t.tooltip({
                                    content: t.text(),
                                    onShow: function(e) {
                                        $(this).tooltip("tip").css({
                                            width: s,
                                            top: e.pageY + 20,
                                            left: e.pageX - 250 / 2
                                        });
                                    }
                                }).tooltip("show", e);
                            }
                        }
                    }
                }
            }
            var d = $(e.target).closest("tr.datagrid-row");
            if (!h(d)) {
                return;
            }
            var l = f(d);
            _5c7(c, l, true);
            e.stopPropagation();
        }).bind("mouseout", function(e) {
            var t = $(e.target).closest("tr.datagrid-row");
            if (!h(t)) {
                return;
            }
            var a = f(t);
            s.finder.getTr(c, a).removeClass("datagrid-row-over");
            e.stopPropagation();
        }).bind("click", function(e) {
            if (parseInt(s.clickDelay) > 0) {
                o.call(this, e);
            } else {
                n.call(this, e);
            }
            e.stopPropagation();
        }).bind("dblclick", function(e) {
            var t = $(e.target);
            var a = t.closest("tr.datagrid-row");
            if (!h(a)) {
                return;
            }
            var i = f(a);
            var n = s.finder.getRow(c, i);
            var r = t.closest("td[field]", a);
            if (r.length) {
                var o = r.attr("field");
                s.onDblClickCell.call(c, i, o, n[o]);
            }
            s.onDblClickRow.call(c, i, n);
            e.stopPropagation();
        }).bind("contextmenu", function(e) {
            var t = $(e.target).closest("tr.datagrid-row");
            if (!h(t)) {
                return;
            }
            var a = f(t);
            var i = s.finder.getRow(c, a);
            s.onRowContextMenu.call(c, e, a, i);
            e.stopPropagation();
        });
        r.body2.bind("scroll", function() {
            var e = r.view1.children("div.datagrid-body");
            e.scrollTop($(this).scrollTop());
            var t = r.body1.children(":first");
            var a = r.body2.children(":first");
            if (t.length && a.length) {
                var i = t.offset().top;
                var n = a.offset().top;
                if (i != n) {
                    e.scrollTop(e.scrollTop() + i - n);
                }
            }
            r.view2.children("div.datagrid-header,div.datagrid-footer")._scrollLeft($(this)._scrollLeft());
            r.body2.children("table.datagrid-btable-frozen").css("left", -$(this)._scrollLeft());
        });
        function f(e) {
            if (e.attr("datagrid-row-index")) {
                return parseInt(e.attr("datagrid-row-index"));
            } else {
                return e.attr("node-id");
            }
        }
        function h(e) {
            return e.length && e.parent().length;
        }
    }
    function _56c(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        t = t || {};
        var n = {
            sortName: i.sortName,
            sortOrder: i.sortOrder
        };
        if (typeof t == "object") {
            $.extend(n, t);
        }
        var r = [];
        var o = [];
        if (n.sortName) {
            r = n.sortName.split(",");
            o = n.sortOrder.split(",");
        }
        if (typeof t == "string") {
            var s = t;
            var d = _558(e, s);
            if (!d.sortable || a.resizing) {
                return;
            }
            var l = d.order || "asc";
            var c = _502(r, s);
            if (c >= 0) {
                var u = o[c] == "asc" ? "desc" : "asc";
                if (i.multiSort && u == l) {
                    r.splice(c, 1);
                    o.splice(c, 1);
                } else {
                    o[c] = u;
                }
            } else {
                if (i.multiSort) {
                    r.push(s);
                    o.push(l);
                } else {
                    r = [ s ];
                    o = [ l ];
                }
            }
            n.sortName = r.join(",");
            n.sortOrder = o.join(",");
        }
        if (i.onBeforeSortColumn.call(e, n.sortName, n.sortOrder) == false) {
            return;
        }
        $.extend(i, n);
        var f = a.dc;
        var h = f.header1.add(f.header2);
        h.find("div.datagrid-cell").removeClass("datagrid-sort-asc datagrid-sort-desc");
        for (var p = 0; p < r.length; p++) {
            var d = _558(e, r[p]);
            h.find("div." + d.cellClass).addClass("datagrid-sort-" + o[p]);
        }
        if (i.remoteSort) {
            _577(e);
        } else {
            _578(e, $(e).datagrid("getData"));
        }
        i.onSortColumn.call(e, i.sortName, i.sortOrder);
    }
    function _579(e) {
        var t = $.data(e, "datagrid");
        var a = t.options;
        var i = t.dc;
        i.body2.css("overflow-x", "");
        if (!a.fitColumns) {
            return;
        }
        if (!t.leftWidth) {
            t.leftWidth = 0;
        }
        var n = i.view2.children("div.datagrid-header");
        var r = 0;
        var o;
        var s = _557(e, false);
        for (var d = 0; d < s.length; d++) {
            var l = _558(e, s[d]);
            if (v(l)) {
                r += l.width;
                o = l;
            }
        }
        if (!r) {
            return;
        }
        if (o) {
            p(o, -t.leftWidth);
        }
        var c = n.children("div.datagrid-header-inner").show();
        var u = n.width() - n.find("table").width() - a.scrollbarSize + t.leftWidth;
        var f = u / r;
        if (!a.showHeader) {
            c.hide();
        }
        for (var d = 0; d < s.length; d++) {
            var l = _558(e, s[d]);
            if (v(l)) {
                var h = parseInt(l.width * f);
                p(l, h);
                u -= h;
            }
        }
        t.leftWidth = u;
        if (o) {
            p(o, t.leftWidth);
        }
        _542(e);
        if (n.width() >= n.find("table").width()) {
            i.body2.css("overflow-x", "hidden");
        }
        function p(e, t) {
            if (e.width + t > 0) {
                e.width += t;
                e.boxWidth += t;
            }
        }
        function v(e) {
            if (!e.hidden && !e.checkbox && !e.auto && !e.fixed) {
                return true;
            }
        }
    }
    function _586(r, e) {
        var t = $.data(r, "datagrid");
        var o = t.options;
        var s = t.dc;
        var d = $('<div class="datagrid-cell" style="position:absolute;left:-9999px"></div>').appendTo("body");
        if (e) {
            c(e);
            if (o.fitColumns) {
                _519(r);
                _579(r);
            }
        } else {
            if (!!o.autoSizeColumn) {
                var a = false;
                var i = _557(r, true).concat(_557(r, false));
                for (var n = 0; n < i.length; n++) {
                    var e = i[n];
                    var l = _558(r, e);
                    if (!l.hidden && l.auto) {
                        c(e);
                        a = true;
                    }
                }
                if (a && o.fitColumns) {
                    _519(r);
                    _579(r);
                }
            }
        }
        d.remove();
        function c(i) {
            var n = s.view.find('div.datagrid-header td[field="' + i + '"] div.datagrid-cell');
            n.css("width", "");
            var e = $(r).datagrid("getColumnOption", i);
            e.width = undefined;
            e.boxWidth = undefined;
            e.auto = true;
            $(r).datagrid("fixColumnSize", i);
            var t = Math.max(a("header"), a("allbody"), a("allfooter"));
            n._outerWidth(t);
            e.width = t;
            e.boxWidth = parseInt(n[0].style.width);
            n.css("width", "");
            $(r).datagrid("fixColumnSize", i);
            o.onResizeColumn.call(r, i, e.width);
            function a(e) {
                var t = 0;
                if (e == "header") {
                    t = a(n);
                } else {
                    o.finder.getTr(r, 0, e).find('td[field="' + i + '"] div.datagrid-cell').each(function() {
                        var e = a($(this));
                        if (t < e) {
                            t = e;
                        }
                    });
                }
                return t;
                function a(e) {
                    return e.is(":visible") ? e._outerWidth() : d.html(e.html())._outerWidth();
                }
            }
        }
    }
    function _542(a, e) {
        var i = $.data(a, "datagrid");
        var t = i.options;
        var n = i.dc;
        var r = n.view.find("table.datagrid-btable,table.datagrid-ftable");
        r.css("table-layout", "fixed");
        if (e) {
            d(e);
        } else {
            var o = _557(a, true).concat(_557(a, false));
            for (var s = 0; s < o.length; s++) {
                d(o[s]);
            }
        }
        r.css("table-layout", "auto");
        _596(a);
        setTimeout(function() {
            _526(a);
            _59b(a);
        }, 0);
        function d(e) {
            var t = _558(a, e);
            if (!t.checkbox) {
                i.ss.set("." + t.cellClass, t.boxWidth ? t.boxWidth + "px" : "auto");
            }
        }
    }
    function _596(n) {
        var e = $.data(n, "datagrid").dc;
        e.body1.add(e.body2).find("td.datagrid-td-merged").each(function() {
            var e = $(this);
            var t = e.attr("colspan") || 1;
            var a = _558(n, e.attr("field")).width;
            for (var i = 1; i < t; i++) {
                e = e.next();
                a += _558(n, e.attr("field")).width + 1;
            }
            $(this).children("div.datagrid-cell")._outerWidth(a);
        });
    }
    function _59b(n) {
        var e = $.data(n, "datagrid").dc;
        e.view.find("div.datagrid-editable").each(function() {
            var e = $(this);
            var t = e.parent().attr("field");
            var a = $(n).datagrid("getColumnOption", t);
            e._outerWidth(a.width);
            var i = $.data(this, "datagrid.editor");
            if (i.actions.resize) {
                i.actions.resize(i.target, e.width());
            }
        });
    }
    function _558(e, r) {
        function t(e) {
            if (e) {
                for (var t = 0; t < e.length; t++) {
                    var a = e[t];
                    for (var i = 0; i < a.length; i++) {
                        var n = a[i];
                        if (n.field == r) {
                            return n;
                        }
                    }
                }
            }
            return null;
        }
        var a = $.data(e, "datagrid").options;
        var i = t(a.columns);
        if (!i) {
            i = t(a.frozenColumns);
        }
        return i;
    }
    function _557(e, t) {
        var a = $.data(e, "datagrid").options;
        var o = t == true ? a.frozenColumns || [ [] ] : a.columns;
        if (o.length == 0) {
            return [];
        }
        var s = [];
        function d(e) {
            var t = 0;
            var a = 0;
            while (true) {
                if (s[a] == undefined) {
                    if (t == e) {
                        return a;
                    }
                    t++;
                }
                a++;
            }
        }
        function i(e) {
            var t = [];
            var a = 0;
            for (var i = 0; i < o[e].length; i++) {
                var n = o[e][i];
                if (n.field) {
                    t.push([ a, n.field ]);
                }
                a += parseInt(n.colspan || "1");
            }
            for (var i = 0; i < t.length; i++) {
                t[i][0] = d(t[i][0]);
            }
            for (var i = 0; i < t.length; i++) {
                var r = t[i];
                s[r[0]] = r[1];
            }
        }
        for (var n = 0; n < o.length; n++) {
            i(n);
        }
        return s;
    }
    function _578(d, e) {
        var t = $.data(d, "datagrid");
        var a = t.options;
        var i = t.dc;
        e = a.loadFilter.call(d, e);
        e.total = parseInt(e.total);
        t.data = e;
        if (e.footer) {
            t.footer = e.footer;
        }
        if (!a.remoteSort && a.sortName) {
            var l = a.sortName.split(",");
            var c = a.sortOrder.split(",");
            e.rows.sort(function(e, t) {
                var a = 0;
                for (var i = 0; i < l.length; i++) {
                    var n = l[i];
                    var r = c[i];
                    var o = _558(d, n);
                    var s = o.sorter || function(e, t) {
                        return e == t ? 0 : e > t ? 1 : -1;
                    };
                    a = s(e[n], t[n]) * (r == "asc" ? 1 : -1);
                    if (a != 0) {
                        return a;
                    }
                }
                return a;
            });
        }
        if (a.view.onBeforeRender) {
            a.view.onBeforeRender.call(a.view, d, e.rows);
        }
        a.view.render.call(a.view, d, i.body2, false);
        a.view.render.call(a.view, d, i.body1, true);
        if (a.showFooter) {
            a.view.renderFooter.call(a.view, d, i.footer2, false);
            a.view.renderFooter.call(a.view, d, i.footer1, true);
        }
        if (a.view.onAfterRender) {
            a.view.onAfterRender.call(a.view, d);
        }
        t.ss.clean();
        if (a.rownumbers && a.fixRowNumber) {
            $(d).datagrid("fixRowNumber");
        }
        a.onLoadSuccess.call(d, e);
        var n = $(d).datagrid("getPager");
        if (n.length) {
            var r = n.pagination("options");
            if (r.total != e.total) {
                n.pagination("refresh", {
                    total: e.total
                });
                if (a.pageNumber != r.pageNumber) {
                    a.pageNumber = r.pageNumber;
                    _577(d);
                }
            }
        }
        _526(d);
        i.body2.triggerHandler("scroll");
        _5af(d);
        $(d).datagrid("autoSizeColumn");
    }
    function _5af(e) {
        var t = $.data(e, "datagrid");
        var i = t.options;
        if (i.idField) {
            var a = $.data(e, "treegrid") ? true : false;
            var n = i.onSelect;
            var r = i.onCheck;
            i.onSelect = i.onCheck = function() {};
            var o = i.finder.getRows(e);
            for (var s = 0; s < o.length; s++) {
                var d = o[s];
                var l = a ? d[i.idField] : s;
                if (i.view.type == "scrollview") l += i.view.index || 0;
                if (c(t.selectedRows, d)) {
                    _5cb(e, l, true);
                }
                if (c(t.checkedRows, d)) {
                    _5d2(e, l, true);
                }
            }
            i.onSelect = n;
            i.onCheck = r;
        }
        function c(e, t) {
            for (var a = 0; a < e.length; a++) {
                if (e[a][i.idField] == t[i.idField]) {
                    e[a] = t;
                    return true;
                }
            }
            return false;
        }
    }
    function _5b7(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        var n = a.data.rows;
        if (typeof t == "object") {
            return _502(n, t);
        } else {
            for (var r = 0; r < n.length; r++) {
                if (n[r][i.idField] == t) {
                    return r;
                }
            }
            return -1;
        }
    }
    function _5ba(e) {
        var t = $.data(e, "datagrid");
        var a = t.options;
        var i = t.data;
        if (a.idField) {
            return t.selectedRows;
        } else {
            var n = [];
            a.finder.getTr(e, "", "selected", 2).each(function() {
                n.push(a.finder.getRow(e, $(this)));
            });
            return n;
        }
    }
    function _5bd(e) {
        var t = $.data(e, "datagrid");
        var a = t.options;
        if (a.idField) {
            return t.checkedRows;
        } else {
            var i = [];
            a.finder.getTr(e, "", "checked", 2).each(function() {
                i.push(a.finder.getRow(e, $(this)));
            });
            return i;
        }
    }
    function _5c0(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.dc;
        var n = a.options;
        var r = n.finder.getTr(e, t);
        if (r.length) {
            if (r.closest("table").hasClass("datagrid-btable-frozen")) {
                return;
            }
            var o = i.view2.children("div.datagrid-header")._outerHeight();
            var s = i.body2;
            var d = s.outerHeight(true) - s.outerHeight();
            var l = r.position().top - o - d;
            if (l < 0) {
                s.scrollTop(s.scrollTop() + l);
            } else {
                if (l + r._outerHeight() > s.height() - 18) {
                    s.scrollTop(s.scrollTop() + l + r._outerHeight() - s.height() + 18);
                }
            }
        }
    }
    function _5c7(e, t, a) {
        var i = $.data(e, "datagrid");
        var n = i.options;
        n.finder.getTr(e, i.highlightIndex).removeClass("datagrid-row-over");
        n.finder.getTr(e, t).addClass("datagrid-row-over");
        var r = i.highlightIndex;
        i.highlightIndex = t;
        if (a === true && r == t) {} else {
            n.onHighlightRow.call(e, t, i.data.rows[t]);
        }
    }
    function _5cb(e, t, a) {
        var i = $.data(e, "datagrid");
        var n = i.dc;
        var r = i.options;
        var o = i.selectedRows;
        var s = r.finder.getRow(e, t);
        if (false === r.onBeforeSelect.call(e, t, s)) {
            return;
        }
        if (r.singleSelect) {
            _5d1(e);
            o.splice(0, o.length);
        }
        if (!a && r.checkOnSelect) {
            _5d2(e, t, true);
        }
        if (r.idField) {
            _505(o, r.idField, s);
        }
        r.finder.getTr(e, t).addClass("datagrid-row-selected");
        r.onSelect.call(e, t, s);
        _5c0(e, t);
    }
    function _5d3(e, t, a) {
        var i = $.data(e, "datagrid");
        var n = i.dc;
        var r = i.options;
        var o = r.finder.getRow(e, t);
        if (false === r.onBeforeUnselect.call(e, t, o)) {
            return;
        }
        var s = $.data(e, "datagrid").selectedRows;
        if (!a && r.checkOnSelect) {
            _5d9(e, t, true);
        }
        r.finder.getTr(e, t).removeClass("datagrid-row-selected");
        if (r.idField) {
            _503(s, r.idField, o[r.idField]);
        }
        r.onUnselect.call(e, t, o);
    }
    function _5da(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        var n = i.finder.getRows(e);
        var r = $.data(e, "datagrid").selectedRows;
        if (!t && i.checkOnSelect) {
            _5df(e, true);
        }
        i.finder.getTr(e, "", "allbody").addClass("datagrid-row-selected");
        if (i.idField) {
            for (var o = 0; o < n.length; o++) {
                _505(r, i.idField, n[o]);
            }
        }
        i.onSelectAll.call(e, n);
    }
    function _5d1(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        var n = i.finder.getRows(e);
        var r = $.data(e, "datagrid").selectedRows;
        if (!t && i.checkOnSelect) {
            _5e5(e, true);
        }
        i.finder.getTr(e, "", "selected").removeClass("datagrid-row-selected");
        if (i.idField) {
            for (var o = 0; o < n.length; o++) {
                _503(r, i.idField, n[o][i.idField]);
            }
        }
        i.onUnselectAll.call(e, n);
    }
    function _5d2(e, t, a) {
        var i = $.data(e, "datagrid");
        var n = i.options;
        var r = n.finder.getRow(e, t);
        if (false === n.onBeforeCheck.call(e, t, r)) {
            var o = n.finder.getTr(e, t);
            if (!o.hasClass("datagrid-row-checked")) {
                var s = o.find("div.datagrid-cell-check input[type=checkbox]");
                s._propAttr("checked", false);
            }
            return;
        }
        if (!a && n.selectOnCheck) {
            _5cb(e, t, true);
        }
        var o = n.finder.getTr(e, t).addClass("datagrid-row-checked");
        var s = o.find("div.datagrid-cell-check input[type=checkbox]");
        s._propAttr("checked", true);
        o = n.finder.getTr(e, "", "checked", 2);
        if (o.length == n.finder.getRows(e).length) {
            var d = i.dc;
            var l = d.header1.add(d.header2);
            l.find("input[type=checkbox]")._propAttr("checked", true);
        }
        if (n.idField) {
            _505(i.checkedRows, n.idField, r);
        }
        n.onCheck.call(e, t, r);
    }
    function _5d9(e, t, a) {
        var i = $.data(e, "datagrid");
        var n = i.options;
        var r = n.finder.getRow(e, t);
        if (false === n.onBeforeUncheck.call(e, t, r)) {
            var o = n.finder.getTr(e, t);
            if (o.hasClass("datagrid-row-checked")) {
                var s = o.find("div.datagrid-cell-check input[type=checkbox]");
                s._propAttr("checked", true);
            }
            return;
        }
        if (!a && n.selectOnCheck) {
            _5d3(e, t, true);
        }
        var o = n.finder.getTr(e, t).removeClass("datagrid-row-checked");
        var s = o.find("div.datagrid-cell-check input[type=checkbox]");
        s._propAttr("checked", false);
        var d = i.dc;
        var l = d.header1.add(d.header2);
        l.find("input[type=checkbox]")._propAttr("checked", false);
        if (n.idField) {
            _503(i.checkedRows, n.idField, r[n.idField]);
        }
        n.onUncheck.call(e, t, r);
    }
    function _5df(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        var n = i.finder.getRows(e);
        if (!t && i.selectOnCheck) {
            _5da(e, true);
        }
        var r = a.dc;
        var o = r.header1.add(r.header2).find("input[type=checkbox]");
        var s = i.finder.getTr(e, "", "allbody").addClass("datagrid-row-checked").find("div.datagrid-cell-check input[type=checkbox]");
        o.add(s)._propAttr("checked", true);
        if (i.idField) {
            for (var d = 0; d < n.length; d++) {
                _505(a.checkedRows, i.idField, n[d]);
            }
        }
        i.onCheckAll.call(e, n);
    }
    function _5e5(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        var n = i.finder.getRows(e);
        if (!t && i.selectOnCheck) {
            _5d1(e, true);
        }
        var r = a.dc;
        var o = r.header1.add(r.header2).find("input[type=checkbox]");
        var s = i.finder.getTr(e, "", "checked").removeClass("datagrid-row-checked").find("div.datagrid-cell-check input[type=checkbox]");
        o.add(s)._propAttr("checked", false);
        if (i.idField) {
            for (var d = 0; d < n.length; d++) {
                _503(a.checkedRows, i.idField, n[d][i.idField]);
            }
        }
        i.onUncheckAll.call(e, n);
    }
    function _5f7(e, t) {
        var a = $.data(e, "datagrid").options;
        var i = a.finder.getTr(e, t);
        var n = a.finder.getRow(e, t);
        if (i.hasClass("datagrid-row-editing")) {
            return;
        }
        if (a.onBeforeEdit.call(e, t, n) == false) {
            return;
        }
        i.addClass("datagrid-row-editing");
        _5fa(e, t);
        _59b(e);
        i.find("div.datagrid-editable").each(function() {
            var e = $(this).parent().attr("field");
            var t = $.data(this, "datagrid.editor");
            t.actions.setValue(t.target, n[e]);
        });
        _5fc(e, t);
        a.onBeginEdit.call(e, t, n);
    }
    function _5fd(e, t, a) {
        var i = $.data(e, "datagrid").options;
        var n = $.data(e, "datagrid").updatedRows;
        var r = $.data(e, "datagrid").insertedRows;
        var o = i.finder.getTr(e, t);
        var s = i.finder.getRow(e, t);
        if (!o.hasClass("datagrid-row-editing")) {
            return;
        }
        if (!a) {
            if (!_5fc(e, t)) {
                return;
            }
            var d = false;
            var l = {};
            o.find("div.datagrid-editable").each(function() {
                var e = $(this).parent().attr("field");
                var t = $.data(this, "datagrid.editor");
                var a = t.actions.getValue(t.target);
                if (s[e] != a) {
                    s[e] = a;
                    d = true;
                    l[e] = a;
                }
            });
            if (d) {
                if (_502(r, s) == -1) {
                    if (_502(n, s) == -1) {
                        n.push(s);
                    }
                }
            }
            i.onEndEdit.call(e, t, s, l);
        }
        o.removeClass("datagrid-row-editing");
        _607(e, t);
        $(e).datagrid("refreshRow", t);
        if (!a) {
            if (i.showChangedStyle) {
                for (var c in l) {
                    o.children('td[field="' + c + '"]').addClass("datagrid-value-changed");
                }
            }
            i.onAfterEdit.call(e, t, s, l);
        } else {
            i.onCancelEdit.call(e, t, s);
        }
    }
    function _608(e, t) {
        var a = $.data(e, "datagrid").options;
        var i = a.finder.getTr(e, t);
        var n = [];
        i.children("td").each(function() {
            var e = $(this).find("div.datagrid-editable");
            if (e.length) {
                var t = $.data(e[0], "datagrid.editor");
                n.push(t);
            }
        });
        return n;
    }
    function _60c(e, t) {
        var a = _608(e, t.index != undefined ? t.index : t.id);
        for (var i = 0; i < a.length; i++) {
            if (a[i].field == t.field) {
                return a[i];
            }
        }
        return null;
    }
    function _5fa(d, e) {
        var l = $.data(d, "datagrid").options;
        var t = l.finder.getTr(d, e);
        t.children("td").each(function() {
            var e = $(this).find("div.datagrid-cell");
            var t = $(this).attr("field");
            var a = _558(d, t);
            if (a && a.editor) {
                var i, n;
                if (typeof a.editor == "string") {
                    i = a.editor;
                } else {
                    i = a.editor.type;
                    n = a.editor.options;
                }
                var r = l.editors[i];
                if (r) {
                    var o = e.html();
                    var s = e._outerWidth();
                    e.addClass("datagrid-editable");
                    e._outerWidth(s);
                    e.html('<table border="0" cellspacing="0" cellpadding="1"><tr><td></td></tr></table>');
                    e.children("table").bind("click dblclick contextmenu", function(e) {
                        e.stopPropagation();
                    });
                    $.data(e[0], "datagrid.editor", {
                        actions: r,
                        target: r.init(e.find("td"), n),
                        field: t,
                        type: i,
                        oldHtml: o
                    });
                }
            }
        });
        _526(d, e, true);
    }
    function _607(e, t) {
        var a = $.data(e, "datagrid").options;
        var i = a.finder.getTr(e, t);
        i.children("td").each(function() {
            var e = $(this).find("div.datagrid-editable");
            if (e.length) {
                var t = $.data(e[0], "datagrid.editor");
                if (t.actions.destroy) {
                    t.actions.destroy(t.target);
                }
                e.html(t.oldHtml);
                $.removeData(e[0], "datagrid.editor");
                e.removeClass("datagrid-editable");
                e.css("width", "");
            }
        });
    }
    function _5fc(e, t) {
        var a = $.data(e, "datagrid").options.finder.getTr(e, t);
        if (!a.hasClass("datagrid-row-editing")) {
            return true;
        }
        var i = a.find(".validatebox-text");
        i.validatebox("validate");
        i.trigger("mouseleave");
        var n = a.find(".validatebox-invalid");
        return n.length == 0;
    }
    function _61d(e, t) {
        var a = $.data(e, "datagrid").insertedRows;
        var i = $.data(e, "datagrid").deletedRows;
        var n = $.data(e, "datagrid").updatedRows;
        if (!t) {
            var r = [];
            r = r.concat(a);
            r = r.concat(i);
            r = r.concat(n);
            return r;
        } else {
            if (t == "inserted") {
                return a;
            } else {
                if (t == "deleted") {
                    return i;
                } else {
                    if (t == "updated") {
                        return n;
                    }
                }
            }
        }
        return [];
    }
    function _623(e, t) {
        var a = $.data(e, "datagrid");
        var i = a.options;
        var n = a.data;
        var r = a.insertedRows;
        var o = a.deletedRows;
        $(e).datagrid("cancelEdit", t);
        var s = i.finder.getRow(e, t);
        if (_502(r, s) >= 0) {
            _503(r, s);
        } else {
            o.push(s);
        }
        _503(a.selectedRows, i.idField, s[i.idField]);
        _503(a.checkedRows, i.idField, s[i.idField]);
        i.view.deleteRow.call(i.view, e, t);
        if (i.height == "auto") {
            _526(e);
        }
        $(e).datagrid("getPager").pagination("refresh", {
            total: n.total
        });
    }
    function _629(e, t) {
        var a = $.data(e, "datagrid").data;
        var i = $.data(e, "datagrid").options.view;
        var n = $.data(e, "datagrid").insertedRows;
        i.insertRow.call(i, e, t.index, t.row);
        n.push(t.row);
        $(e).datagrid("getPager").pagination("refresh", {
            total: a.total
        });
    }
    function _62d(e, t) {
        var a = $.data(e, "datagrid").data;
        var i = $.data(e, "datagrid").options.view;
        var n = $.data(e, "datagrid").insertedRows;
        i.insertRow.call(i, e, null, t);
        n.push(t);
        $(e).datagrid("getPager").pagination("refresh", {
            total: a.total
        });
    }
    function _630(e) {
        var t = $.data(e, "datagrid");
        var a = t.data;
        var i = a.rows;
        var n = [];
        for (var r = 0; r < i.length; r++) {
            n.push($.extend({}, i[r]));
        }
        t.originalRows = n;
        t.updatedRows = [];
        t.insertedRows = [];
        t.deletedRows = [];
    }
    function _634(e) {
        var t = $.data(e, "datagrid").data;
        var a = true;
        for (var i = 0, n = t.rows.length; i < n; i++) {
            if (_5fc(e, i)) {
                _5fd(e, i, false);
            } else {
                a = false;
            }
        }
        if (a) {
            _630(e);
        }
    }
    function _636(n) {
        var e = $.data(n, "datagrid");
        var i = e.options;
        var t = e.originalRows;
        var a = e.insertedRows;
        var r = e.deletedRows;
        var o = e.selectedRows;
        var s = e.checkedRows;
        var d = e.data;
        function l(e) {
            var t = [];
            for (var a = 0; a < e.length; a++) {
                t.push(e[a][i.idField]);
            }
            return t;
        }
        function c(e, t) {
            for (var a = 0; a < e.length; a++) {
                var i = _5b7(n, e[a]);
                if (i >= 0) {
                    (t == "s" ? _5cb : _5d2)(n, i, true);
                }
            }
        }
        for (var u = 0; u < d.rows.length; u++) {
            _5fd(n, u, true);
        }
        var f = l(o);
        var h = l(s);
        o.splice(0, o.length);
        s.splice(0, s.length);
        d.total += r.length - a.length;
        d.rows = t;
        _578(n, d);
        c(f, "s");
        c(h, "c");
        _630(n);
    }
    function _577(t, e) {
        var a = $.data(t, "datagrid").options;
        if (e) {
            a.queryParams = e;
        }
        var i = $.extend({}, a.queryParams);
        if (a.pagination) {
            $.extend(i, {
                page: a.pageNumber,
                rows: a.pageSize
            });
        }
        if (a.sortName) {
            $.extend(i, {
                sort: a.sortName,
                order: a.sortOrder
            });
        }
        if (a.onBeforeLoad.call(t, i) == false) {
            return;
        }
        $(t).datagrid("loading");
        setTimeout(function() {
            n();
        }, 0);
        function n() {
            var e = a.loader.call(t, i, function(e) {
                setTimeout(function() {
                    $(t).datagrid("loaded");
                }, 0);
                _578(t, e);
                setTimeout(function() {
                    _630(t);
                }, 0);
            }, function() {
                setTimeout(function() {
                    $(t).datagrid("loaded");
                }, 0);
                a.onLoadError.apply(t, arguments);
            });
            if (e == false) {
                $(t).datagrid("loaded");
            }
        }
    }
    function _649(e, t) {
        var a = $.data(e, "datagrid").options;
        t.rowspan = t.rowspan || 1;
        t.colspan = t.colspan || 1;
        if (t.rowspan == 1 && t.colspan == 1) {
            return;
        }
        var i = a.finder.getTr(e, t.index != undefined ? t.index : t.id);
        if (!i.length) {
            return;
        }
        var n = a.finder.getRow(e, i);
        var r = n[t.field];
        var o = i.find('td[field="' + t.field + '"]');
        o.attr("rowspan", t.rowspan).attr("colspan", t.colspan);
        o.addClass("datagrid-td-merged");
        for (var s = 1; s < t.colspan; s++) {
            o = o.next();
            o.hide();
            n[o.attr("field")] = r;
        }
        for (var s = 1; s < t.rowspan; s++) {
            i = i.next();
            if (!i.length) {
                break;
            }
            var n = a.finder.getRow(e, i);
            var o = i.find('td[field="' + t.field + '"]').hide();
            n[o.attr("field")] = r;
            for (var d = 1; d < t.colspan; d++) {
                o = o.next();
                o.hide();
                n[o.attr("field")] = r;
            }
        }
        _596(e);
    }
    function getColumns(e) {
        if (e.className != "" && e.queryName != "") {
            if ("undefined" != typeof $cm) {
                var t = $cm({
                    ClassName: "websys.Query",
                    MethodName: "ColumnDefJson",
                    cn: e.className,
                    qn: e.queryName
                }, false);
                return t;
            } else {
                throw new Error("Not find $cm function. Please include scripts/websys.jquery.js or Setting configuration columns");
            }
        }
        return "";
    }
    $.fn.datagrid = function(r, e) {
        if (typeof r == "string") {
            return $.fn.datagrid.methods[r](this, e);
        }
        r = r || {};
        return this.each(function() {
            var e = $.data(this, "datagrid");
            var t;
            if (e) {
                t = $.extend(e.options, r);
                e.options = t;
            } else {
                t = $.extend({}, $.extend({}, $.fn.datagrid.defaults, {
                    queryParams: {}
                }), $.fn.datagrid.parseOptions(this), r);
                $(this).css("width", "").css("height", "");
                var a = _53a(this, t.rownumbers);
                if (!t.columns) {
                    t.columns = a.columns;
                }
                if (!t.frozenColumns) {
                    t.frozenColumns = a.frozenColumns;
                }
                if (t.queryName) {
                    var i = getColumns(t);
                    if (t.onColumnsLoad) t.onColumnsLoad.call(e, i.cm);
                    t.columns = [ i.cm ];
                    t.pageSize = i.pageSize;
                    if (t.pageList) t.pageList.push(t.pageSize);
                }
                t.columns = $.extend(true, [], t.columns);
                t.frozenColumns = $.extend(true, [], t.frozenColumns);
                t.view = $.extend({}, t.view);
                $.data(this, "datagrid", {
                    options: t,
                    panel: a.panel,
                    dc: a.dc,
                    ss: null,
                    selectedRows: [],
                    checkedRows: [],
                    data: {
                        total: 0,
                        rows: []
                    },
                    originalRows: [],
                    updatedRows: [],
                    insertedRows: [],
                    deletedRows: []
                });
            }
            _545(this);
            _559(this);
            _515(this);
            if (t.data) {
                _578(this, t.data);
                _630(this);
            } else {
                var n = $.fn.datagrid.parseData(this);
                if (n.total > 0) {
                    _578(this, n);
                    _630(this);
                }
            }
            if (!t.lazy && t.url) {
                _577(this);
            }
        });
    };
    var _651 = {
        text: {
            init: function(e, t) {
                var a = $('<input type="text" class="datagrid-editable-input">').appendTo(e);
                return a;
            },
            getValue: function(e) {
                return $(e).val();
            },
            setValue: function(e, t) {
                $(e).val(t);
            },
            resize: function(e, t) {
                $(e)._outerWidth(t)._outerHeight(30);
            }
        },
        textarea: {
            init: function(e, t) {
                var a = $('<textarea class="datagrid-editable-input"></textarea>').appendTo(e);
                return a;
            },
            getValue: function(e) {
                return $(e).val();
            },
            setValue: function(e, t) {
                $(e).val(t);
            },
            resize: function(e, t) {
                $(e)._outerWidth(t);
            }
        },
        icheckbox: {
            init: function(e, t) {
                var a = $.extend({
                    on: "on",
                    off: "off"
                }, t);
                var i = $('<input type="checkbox">').appendTo(e);
                i.checkbox(a);
                return i;
            },
            getValue: function(e) {
                if ($(e).checkbox("getValue")) {
                    return $(e).checkbox("options").on;
                } else {
                    return $(e).checkbox("options").off;
                }
            },
            setValue: function(e, t) {
                var a = false;
                if ($(e).checkbox("options").on == t) {
                    a = true;
                }
                $(e).checkbox("setValue", a);
            }
        },
        checkbox: {
            init: function(e, t) {
                var a = $('<input type="checkbox">').appendTo(e);
                a.val(t.on);
                a.attr("offval", t.off);
                return a;
            },
            getValue: function(e) {
                if ($(e).is(":checked")) {
                    return $(e).val();
                } else {
                    return $(e).attr("offval");
                }
            },
            setValue: function(e, t) {
                var a = false;
                if ($(e).val() == t) {
                    a = true;
                }
                $(e)._propAttr("checked", a);
            }
        },
        numberbox: {
            init: function(e, t) {
                var a = $('<input type="text" class="datagrid-editable-input">').appendTo(e);
                a.numberbox(t);
                return a;
            },
            destroy: function(e) {
                $(e).numberbox("destroy");
            },
            getValue: function(e) {
                $(e).blur();
                return $(e).numberbox("getValue");
            },
            setValue: function(e, t) {
                $(e).numberbox("setValue", t);
            },
            resize: function(e, t) {
                $(e)._outerWidth(t)._outerHeight(30);
            }
        },
        validatebox: {
            init: function(e, t) {
                var a = $('<input type="text" class="datagrid-editable-input">').appendTo(e);
                a.validatebox(t);
                return a;
            },
            destroy: function(e) {
                $(e).validatebox("destroy");
            },
            getValue: function(e) {
                return $(e).val();
            },
            setValue: function(e, t) {
                $(e).val(t);
            },
            resize: function(e, t) {
                $(e)._outerWidth(t)._outerHeight(30);
            }
        },
        datebox: {
            init: function(e, t) {
                var a = $('<input type="text">').appendTo(e);
                a.datebox(t);
                return a;
            },
            destroy: function(e) {
                $(e).datebox("destroy");
            },
            getValue: function(e) {
                return $(e).datebox("getValue");
            },
            setValue: function(e, t) {
                $(e).datebox("setValue", t);
            },
            resize: function(e, t) {
                $(e).datebox("resize", t);
            }
        },
        datetimebox: {
            init: function(e, t) {
                var a = $('<input type="text">').appendTo(e);
                a.datetimebox(t);
                return a;
            },
            destroy: function(e) {
                $(e).datetimebox("destroy");
            },
            getValue: function(e) {
                return $(e).datetimebox("getValue");
            },
            setValue: function(e, t) {
                $(e).datetimebox("setValue", t);
            },
            resize: function(e, t) {
                $(e).datetimebox("resize", t);
            }
        },
        combobox: {
            init: function(e, t) {
                var a = $('<input type="text">').appendTo(e);
                a.combobox(t || {});
                return a;
            },
            destroy: function(e) {
                $(e).combobox("destroy");
            },
            getValue: function(e) {
                var t = $(e).combobox("options");
                if (t.multiple) {
                    return $(e).combobox("getValues").join(t.separator);
                } else {
                    return $(e).combobox("getValue");
                }
            },
            setValue: function(e, t) {
                var a = $(e).combobox("options");
                if (a.multiple) {
                    if (t) {
                        $(e).combobox("setValues", t.split(a.separator));
                    } else {
                        $(e).combobox("clear");
                    }
                } else {
                    $(e).combobox("setValue", t);
                }
            },
            resize: function(e, t) {
                $(e).combobox("resize", t);
            }
        },
        combotree: {
            init: function(e, t) {
                var a = $('<input type="text">').appendTo(e);
                a.combotree(t);
                return a;
            },
            destroy: function(e) {
                $(e).combotree("destroy");
            },
            getValue: function(e) {
                var t = $(e).combotree("options");
                if (t.multiple) {
                    return $(e).combotree("getValues").join(t.separator);
                } else {
                    return $(e).combotree("getValue");
                }
            },
            setValue: function(e, t) {
                var a = $(e).combotree("options");
                if (a.multiple) {
                    if (t) {
                        $(e).combotree("setValues", t.split(a.separator));
                    } else {
                        $(e).combotree("clear");
                    }
                } else {
                    $(e).combotree("setValue", t);
                }
            },
            resize: function(e, t) {
                $(e).combotree("resize", t);
            }
        },
        combogrid: {
            init: function(e, t) {
                var a = $('<input type="text">').appendTo(e);
                a.combogrid(t);
                return a;
            },
            destroy: function(e) {
                $(e).combogrid("destroy");
            },
            getValue: function(e) {
                var t = $(e).combogrid("options");
                if (t.multiple) {
                    return $(e).combogrid("getValues").join(t.separator);
                } else {
                    return $(e).combogrid("getValue");
                }
            },
            setValue: function(e, t) {
                var a = $(e).combogrid("options");
                if (a.multiple) {
                    if (t) {
                        $(e).combogrid("setValues", t.split(a.separator));
                    } else {
                        $(e).combogrid("clear");
                    }
                } else {
                    $(e).combogrid("setValue", t);
                }
            },
            resize: function(e, t) {
                $(e).combogrid("resize", t);
            }
        },
        linkbutton: {
            init: function(e, t) {
                var a = $("<a href='#'></a>").appendTo(e);
                a.linkbutton(t);
                a.click(t.handler);
                return a;
            },
            destroy: function(e) {},
            getValue: function(e) {
                return $(e).linkbutton("options").text;
            },
            setValue: function(e, t) {
                $(e).linkbutton("options").text = t;
                $(e).linkbutton({});
            },
            resize: function(e, t) {}
        },
        switchbox: {
            init: function(e, t) {
                var a = $("<div href='#'></div>").appendTo(e);
                a.switchbox(t);
                return a;
            },
            destroy: function(e) {
                $(e).switchbox("destroy");
            },
            getValue: function(e) {
                if ($(e).switchbox("getValue")) {
                    return $(e).switchbox("options").onText;
                } else {
                    return $(e).switchbox("options").offText;
                }
            },
            setValue: function(e, t) {
                var a = false;
                if ($(e).switchbox("options").onText == t) {
                    a = true;
                }
                $(e).switchbox("setValue", a, false);
            },
            resize: function(e, t) {}
        },
        lookup: {
            init: function(e, t) {
                var a = $("<input class='textbox' type=\"text\">").appendTo(e);
                a.lookup(t);
                return a;
            },
            destroy: function(e) {
                $(e).lookup("destroy");
            },
            getValue: function(e) {
                return $(e).lookup("getText");
            },
            setValue: function(e, t) {
                $(e).lookup("setText", t);
            },
            resize: function(e, t) {
                $(e).lookup("resize", t);
            }
        }
    };
    $.fn.datagrid.methods = {
        options: function(e) {
            var t = $.data(e[0], "datagrid").options;
            var a = $.data(e[0], "datagrid").panel.panel("options");
            var i = $.extend(t, {
                width: a.width,
                height: a.height,
                closed: a.closed,
                collapsed: a.collapsed,
                minimized: a.minimized,
                maximized: a.maximized
            });
            return i;
        },
        setSelectionState: function(e) {
            return e.each(function() {
                _5af(this);
            });
        },
        createStyleSheet: function(e) {
            return _506(e[0]);
        },
        getPanel: function(e) {
            return $.data(e[0], "datagrid").panel;
        },
        getPager: function(e) {
            return $.data(e[0], "datagrid").panel.children("div.datagrid-pager");
        },
        getColumnFields: function(e, t) {
            return _557(e[0], t);
        },
        getColumnOption: function(e, t) {
            return _558(e[0], t);
        },
        resize: function(e, t) {
            return e.each(function() {
                _515(this, t);
            });
        },
        load: function(e, a) {
            return e.each(function() {
                var e = $(this).datagrid("options");
                e.pageNumber = 1;
                var t = $(this).datagrid("getPager");
                t.pagination("refresh", {
                    pageNumber: 1
                });
                _577(this, a);
            });
        },
        reload: function(e, t) {
            return e.each(function() {
                _577(this, t);
            });
        },
        reloadFooter: function(e, a) {
            return e.each(function() {
                var e = $.data(this, "datagrid").options;
                var t = $.data(this, "datagrid").dc;
                if (a) {
                    $.data(this, "datagrid").footer = a;
                }
                if (e.showFooter) {
                    e.view.renderFooter.call(e.view, this, t.footer2, false);
                    e.view.renderFooter.call(e.view, this, t.footer1, true);
                    if (e.view.onAfterRender) {
                        e.view.onAfterRender.call(e.view, this);
                    }
                    $(this).datagrid("fixRowHeight");
                }
            });
        },
        loading: function(e) {
            return e.each(function() {
                var e = $.data(this, "datagrid").options;
                $(this).datagrid("getPager").pagination("loading");
                if (e.loadMsg) {
                    var t = $(this).datagrid("getPanel");
                    if (!t.children("div.datagrid-mask").length) {
                        $('<div class="datagrid-mask" style="display:block"></div>').appendTo(t);
                        var a = $('<div class="datagrid-mask-msg" style="display:block;left:50%"></div>').html(e.loadMsg).appendTo(t);
                        a._outerHeight(40);
                        a.css({
                            marginLeft: -a.outerWidth() / 2,
                            lineHeight: a.height() + "px"
                        });
                    }
                }
            });
        },
        loaded: function(e) {
            return e.each(function() {
                $(this).datagrid("getPager").pagination("loaded");
                var e = $(this).datagrid("getPanel");
                e.children("div.datagrid-mask-msg").remove();
                e.children("div.datagrid-mask").remove();
            });
        },
        fitColumns: function(e) {
            return e.each(function() {
                _579(this);
            });
        },
        fixColumnSize: function(e, t) {
            return e.each(function() {
                _542(this, t);
            });
        },
        fixRowHeight: function(e, t) {
            return e.each(function() {
                _526(this, t);
            });
        },
        fixRowNumber: function(e) {
            return e.each(function() {
                var e = $(this).datagrid("getPanel");
                var t = $(".datagrid-cell-rownumber", e).last().clone();
                t.css({
                    position: "absolute",
                    left: -1e3
                }).appendTo("body");
                var a = t.width("auto").width();
                if (a > 25) {
                    $(".datagrid-header-rownumber,.datagrid-cell-rownumber", e).width(a + 5);
                    $(this).datagrid("resize");
                    t.remove();
                    t = null;
                } else {
                    $(".datagrid-header-rownumber,.datagrid-cell-rownumber", e).removeAttr("style");
                }
            });
        },
        freezeRow: function(e, t) {
            return e.each(function() {
                _533(this, t);
            });
        },
        autoSizeColumn: function(e, t) {
            return e.each(function() {
                _586(this, t);
            });
        },
        loadData: function(e, t) {
            return e.each(function() {
                _578(this, t);
                _630(this);
            });
        },
        getData: function(e) {
            return $.data(e[0], "datagrid").data;
        },
        getRows: function(e) {
            return $.data(e[0], "datagrid").data.rows;
        },
        getFooterRows: function(e) {
            return $.data(e[0], "datagrid").footer;
        },
        getRowIndex: function(e, t) {
            return _5b7(e[0], t);
        },
        getChecked: function(e) {
            return _5bd(e[0]);
        },
        getSelected: function(e) {
            var t = _5ba(e[0]);
            return t.length > 0 ? t[0] : null;
        },
        getSelections: function(e) {
            return _5ba(e[0]);
        },
        clearSelections: function(e) {
            return e.each(function() {
                var e = $.data(this, "datagrid");
                var t = e.selectedRows;
                var a = e.checkedRows;
                t.splice(0, t.length);
                _5d1(this);
                if (e.options.checkOnSelect) {
                    a.splice(0, a.length);
                }
            });
        },
        clearChecked: function(e) {
            return e.each(function() {
                var e = $.data(this, "datagrid");
                var t = e.selectedRows;
                var a = e.checkedRows;
                a.splice(0, a.length);
                _5e5(this);
                if (e.options.selectOnCheck) {
                    t.splice(0, t.length);
                }
            });
        },
        scrollTo: function(e, t) {
            return e.each(function() {
                _5c0(this, t);
            });
        },
        highlightRow: function(e, t) {
            return e.each(function() {
                _5c7(this, t);
                _5c0(this, t);
            });
        },
        selectAll: function(e) {
            return e.each(function() {
                _5da(this);
            });
        },
        unselectAll: function(e) {
            return e.each(function() {
                _5d1(this);
            });
        },
        selectRow: function(e, t) {
            return e.each(function() {
                _5cb(this, t);
            });
        },
        selectRecord: function(e, a) {
            return e.each(function() {
                var e = $.data(this, "datagrid").options;
                if (e.idField) {
                    var t = _5b7(this, a);
                    if (t >= 0) {
                        $(this).datagrid("selectRow", t);
                    }
                }
            });
        },
        unselectRow: function(e, t) {
            return e.each(function() {
                _5d3(this, t);
            });
        },
        checkRow: function(e, t) {
            return e.each(function() {
                _5d2(this, t);
            });
        },
        uncheckRow: function(e, t) {
            return e.each(function() {
                _5d9(this, t);
            });
        },
        checkAll: function(e) {
            return e.each(function() {
                _5df(this);
            });
        },
        uncheckAll: function(e) {
            return e.each(function() {
                _5e5(this);
            });
        },
        beginEdit: function(e, t) {
            return e.each(function() {
                _5f7(this, t);
            });
        },
        endEdit: function(e, t) {
            return e.each(function() {
                _5fd(this, t, false);
            });
        },
        cancelEdit: function(e, t) {
            return e.each(function() {
                _5fd(this, t, true);
            });
        },
        getEditors: function(e, t) {
            return _608(e[0], t);
        },
        getEditor: function(e, t) {
            return _60c(e[0], t);
        },
        refreshRow: function(e, t) {
            return e.each(function() {
                var e = $.data(this, "datagrid").options;
                e.view.refreshRow.call(e.view, this, t);
            });
        },
        validateRow: function(e, t) {
            return _5fc(e[0], t);
        },
        updateRow: function(e, t) {
            return e.each(function() {
                var e = $.data(this, "datagrid").options;
                e.view.updateRow.call(e.view, this, t.index, t.row);
            });
        },
        appendRow: function(e, t) {
            return e.each(function() {
                _62d(this, t);
            });
        },
        insertRow: function(e, t) {
            return e.each(function() {
                _629(this, t);
            });
        },
        deleteRow: function(e, t) {
            return e.each(function() {
                t = parseInt(t);
                _623(this, t);
            });
        },
        getChanges: function(e, t) {
            return _61d(e[0], t);
        },
        acceptChanges: function(e) {
            return e.each(function() {
                _634(this);
            });
        },
        rejectChanges: function(e) {
            return e.each(function() {
                _636(this);
            });
        },
        mergeCells: function(e, t) {
            return e.each(function() {
                _649(this, t);
            });
        },
        showColumn: function(e, t) {
            return e.each(function() {
                var e = $(this).datagrid("getPanel");
                e.find('td[field="' + t + '"]').show();
                $(this).datagrid("getColumnOption", t).hidden = false;
                $(this).datagrid("fitColumns");
            });
        },
        hideColumn: function(e, t) {
            return e.each(function() {
                var e = $(this).datagrid("getPanel");
                e.find('td[field="' + t + '"]').hide();
                $(this).datagrid("getColumnOption", t).hidden = true;
                $(this).datagrid("fitColumns");
            });
        },
        sort: function(e, t) {
            return e.each(function() {
                _56c(this, t);
            });
        },
        setColumnTitle: function(e, a) {
            return e.each(function() {
                var e = $.data($(this)[0], "datagrid").dc.header2;
                for (var t in a) {
                    e.find('.datagrid-header-row td[field="' + t + '"] .datagrid-cell span').first().html(a[t]);
                }
            });
        }
    };
    $.fn.datagrid.parseOptions = function(_6cc) {
        var t = $(_6cc);
        return $.extend({}, $.fn.panel.parseOptions(_6cc), $.parser.parseOptions(_6cc, [ "url", "toolbar", "btoolbar", "idField", "sortName", "sortOrder", "pagePosition", "resizeHandle", {
            sharedStyleSheet: "boolean",
            fitColumns: "boolean",
            autoRowHeight: "boolean",
            striped: "boolean",
            nowrap: "boolean"
        }, {
            rownumbers: "boolean",
            singleSelect: "boolean",
            ctrlSelect: "boolean",
            checkOnSelect: "boolean",
            selectOnCheck: "boolean"
        }, {
            pagination: "boolean",
            pageSize: "number",
            pageNumber: "number"
        }, {
            multiSort: "boolean",
            remoteSort: "boolean",
            showHeader: "boolean",
            showFooter: "boolean"
        }, {
            scrollbarSize: "number"
        } ]), {
            pageList: t.attr("pageList") ? eval(t.attr("pageList")) : undefined,
            loadMsg: t.attr("loadMsg") != undefined ? t.attr("loadMsg") : undefined,
            rowStyler: t.attr("rowStyler") ? eval(t.attr("rowStyler")) : undefined
        });
    };
    $.fn.datagrid.parseData = function(e) {
        var t = $(e);
        var a = {
            total: 0,
            rows: []
        };
        var i = t.datagrid("getColumnFields", true).concat(t.datagrid("getColumnFields", false));
        t.find("tbody tr").each(function() {
            a.total++;
            var e = {};
            $.extend(e, $.parser.parseOptions(this, [ "iconCls", "state" ]));
            for (var t = 0; t < i.length; t++) {
                e[i[t]] = $(this).find("td:eq(" + t + ")").html();
            }
            a.rows.push(e);
        });
        return a;
    };
    var _6cf = {
        render: function(e, t, a) {
            var i = $.data(e, "datagrid");
            var n = i.options;
            var r = i.data.rows;
            var o = $(e).datagrid("getColumnFields", a);
            if (a) {
                if (!(n.rownumbers || n.frozenColumns && n.frozenColumns.length)) {
                    return;
                }
            }
            if (r.length > 0) {
                var s = [ '<table class="datagrid-btable" cellspacing="0" cellpadding="0" border="0"><tbody>' ];
                for (var d = 0; d < r.length; d++) {
                    var l = n.rowStyler ? n.rowStyler.call(e, d, r[d]) : "";
                    var c = "";
                    var u = "";
                    if (typeof l == "string") {
                        u = l;
                    } else {
                        if (l) {
                            c = l["class"] || "";
                            u = l["style"] || "";
                        }
                    }
                    var f = 'class="datagrid-row ' + (d % 2 && n.striped ? "datagrid-row-alt " : " ") + c + '"';
                    var h = u ? 'style="' + u + '"' : "";
                    var p = i.rowIdPrefix + "-" + (a ? 1 : 2) + "-" + d;
                    s.push('<tr id="' + p + '" datagrid-row-index="' + d + '" ' + f + " " + h + ">");
                    s.push(this.renderRow.call(this, e, o, a, d, r[d]));
                    s.push("</tr>");
                }
                s.push("</tbody></table>");
                $(t)[0].innerHTML = s.join("");
            } else {
                $(t).html("<div style='width:" + i.dc.view2.find(".datagrid-header-row").width() + "px;border:solid 0px;height:1px;'></div>");
            }
        },
        renderFooter: function(e, t, a) {
            var i = $.data(e, "datagrid").options;
            var n = $.data(e, "datagrid").footer || [];
            var r = $(e).datagrid("getColumnFields", a);
            var o = [ '<table class="datagrid-ftable" cellspacing="0" cellpadding="0" border="0"><tbody>' ];
            for (var s = 0; s < n.length; s++) {
                o.push('<tr class="datagrid-row" datagrid-row-index="' + s + '">');
                o.push(this.renderRow.call(this, e, r, a, s, n[s]));
                o.push("</tr>");
            }
            o.push("</tbody></table>");
            $(t).html(o.join(""));
        },
        renderRow: function(e, t, a, i, n) {
            var r = $.data(e, "datagrid").options;
            var o = [];
            if (a && r.rownumbers) {
                var s = i + 1;
                if (r.pagination) {
                    s += (r.pageNumber - 1) * r.pageSize;
                }
                o.push('<td class="datagrid-td-rownumber"><div class="datagrid-cell-rownumber">' + s + "</div></td>");
            }
            for (var d = 0; d < t.length; d++) {
                var l = t[d];
                var c = $(e).datagrid("getColumnOption", l);
                if (c) {
                    var u = n[l];
                    var f = c.styler ? c.styler(u, n, i) || "" : "";
                    var h = "";
                    var p = "";
                    if (typeof f == "string") {
                        p = f;
                    } else {
                        if (f) {
                            h = f["class"] || "";
                            p = f["style"] || "";
                        }
                    }
                    var v = h ? 'class="' + h + '"' : "";
                    var g = c.hidden ? 'style="display:none;' + p + '"' : p ? 'style="' + p + '"' : "";
                    o.push('<td field="' + l + '" ' + v + " " + g + ">");
                    var g = "";
                    if (!c.checkbox) {
                        if (c.align) {
                            g += "text-align:" + c.align + ";";
                        }
                        if (!r.nowrap) {
                            g += "white-space:normal;height:auto;";
                        } else {
                            if (r.autoRowHeight) {
                                g += "height:auto;";
                            }
                        }
                    }
                    o.push('<div style="' + g + '" ');
                    o.push(c.checkbox ? 'class="datagrid-cell-check"' : 'class="datagrid-cell ' + c.cellClass + '"');
                    o.push(">");
                    if (c.checkbox) {
                        o.push('<input type="checkbox" ' + (n.checked ? 'checked="checked"' : ""));
                        o.push(' name="' + l + '" value="' + (u != undefined ? u : "") + '">');
                    } else {
                        if (c.formatter) {
                            o.push(c.formatter(u, n, i));
                        } else {
                            if ("string" == typeof u) {
                                if (u.indexOf("<") > -1 && u.indexOf(">") == -1) {
                                    u = u.replace(/</g, "&lt;");
                                }
                                if (u.indexOf(">") > -1 && u.indexOf("<") == -1) {
                                    u = u.replace(/>/g, "&gt;");
                                }
                            }
                            o.push(u);
                        }
                    }
                    o.push("</div>");
                    o.push("</td>");
                }
            }
            return o.join("");
        },
        refreshRow: function(e, t) {
            this.updateRow.call(this, e, t, {});
        },
        updateRow: function(s, d, e) {
            var l = $.data(s, "datagrid").options;
            var c = $(s).datagrid("getRows");
            $.extend(c[d], e);
            var t = l.rowStyler ? l.rowStyler.call(s, d, c[d]) : "";
            var u = "";
            var f = "";
            if (typeof t == "string") {
                f = t;
            } else {
                if (t) {
                    u = t["class"] || "";
                    f = t["style"] || "";
                }
            }
            var u = "datagrid-row " + (d % 2 && l.striped ? "datagrid-row-alt " : " ") + u;
            function a(e) {
                var t = $(s).datagrid("getColumnFields", e);
                var a = l.finder.getTr(s, d, "body", e ? 1 : 2);
                var i = a.find("div.datagrid-cell-check input[type=checkbox]").is(":checked");
                if (l.showChangedStyle) {
                    var n = [];
                    a.children(".datagrid-value-changed").each(function() {
                        n.push($(this).attr("field"));
                    });
                }
                a.html(this.renderRow.call(this, s, t, e, d, c[d]));
                if (l.showChangedStyle) {
                    for (var r = 0; r < n.length; r++) {
                        a.children('td[field="' + n[r] + '"]').addClass("datagrid-value-changed");
                    }
                }
                var o = a.hasClass("datagrid-row-checked");
                a.attr("style", f).attr("class", a.hasClass("datagrid-row-selected") ? u + " datagrid-row-selected" : u);
                if (o) {
                    a.addClass("datagrid-row-checked");
                }
                if (i) {
                    a.find("div.datagrid-cell-check input[type=checkbox]")._propAttr("checked", true);
                }
            }
            a.call(this, true);
            a.call(this, false);
            $(s).datagrid("fixRowHeight", d);
        },
        insertRow: function(o, s, e) {
            var d = $.data(o, "datagrid");
            var l = d.options;
            var c = d.dc;
            var u = d.data;
            if (s == undefined || s == null) {
                s = u.rows.length;
            }
            if (s > u.rows.length) {
                s = u.rows.length;
            }
            function t(e) {
                var t = e ? 1 : 2;
                for (var a = u.rows.length - 1; a >= s; a--) {
                    var i = l.finder.getTr(o, a, "body", t);
                    i.attr("datagrid-row-index", a + 1);
                    i.attr("id", d.rowIdPrefix + "-" + t + "-" + (a + 1));
                    if (e && l.rownumbers) {
                        var n = a + 2;
                        if (l.pagination) {
                            n += (l.pageNumber - 1) * l.pageSize;
                        }
                        i.find("div.datagrid-cell-rownumber").html(n);
                    }
                    if (l.striped) {
                        i.removeClass("datagrid-row-alt").addClass((a + 1) % 2 ? "datagrid-row-alt" : "");
                    }
                }
            }
            function a(e) {
                var t = e ? 1 : 2;
                var a = $(o).datagrid("getColumnFields", e);
                var i = d.rowIdPrefix + "-" + t + "-" + s;
                var n = '<tr id="' + i + '" class="datagrid-row" datagrid-row-index="' + s + '"></tr>';
                if (s >= u.rows.length) {
                    if (u.rows.length) {
                        l.finder.getTr(o, "", "last", t).after(n);
                    } else {
                        var r = e ? c.body1 : c.body2;
                        r.html('<table cellspacing="0" cellpadding="0" border="0"><tbody>' + n + "</tbody></table>");
                    }
                } else {
                    l.finder.getTr(o, s + 1, "body", t).before(n);
                }
            }
            t.call(this, true);
            t.call(this, false);
            a.call(this, true);
            a.call(this, false);
            u.total += 1;
            u.rows.splice(s, 0, e);
            this.refreshRow.call(this, o, s);
        },
        deleteRow: function(r, o) {
            var s = $.data(r, "datagrid");
            var d = s.options;
            var l = s.data;
            function e(e) {
                var t = e ? 1 : 2;
                for (var a = o + 1; a < l.rows.length; a++) {
                    var i = d.finder.getTr(r, a, "body", t);
                    i.attr("datagrid-row-index", a - 1);
                    i.attr("id", s.rowIdPrefix + "-" + t + "-" + (a - 1));
                    if (e && d.rownumbers) {
                        var n = a;
                        if (d.pagination) {
                            n += (d.pageNumber - 1) * d.pageSize;
                        }
                        i.find("div.datagrid-cell-rownumber").html(n);
                    }
                    if (d.striped) {
                        i.removeClass("datagrid-row-alt").addClass((a - 1) % 2 ? "datagrid-row-alt" : "");
                    }
                }
            }
            d.finder.getTr(r, o).remove();
            e.call(this, true);
            e.call(this, false);
            l.total -= 1;
            l.rows.splice(o, 1);
        },
        onBeforeRender: function(e, t) {},
        onAfterRender: function(e) {
            var t = $.data(e, "datagrid").options;
            if (t.showFooter) {
                var a = $(e).datagrid("getPanel").find("div.datagrid-footer");
                a.find("div.datagrid-cell-rownumber,div.datagrid-cell-check").css("visibility", "hidden");
            }
        }
    };
    $.fn.datagrid.defaults = $.extend({}, $.fn.panel.defaults, {
        className: "",
        queryName: "",
        compContext: "",
        showChangedStyle: true,
        fixRowNumber: false,
        autoSizeColumn: true,
        sharedStyleSheet: false,
        frozenColumns: undefined,
        columns: undefined,
        fitColumns: false,
        resizeHandle: "right",
        autoRowHeight: true,
        btoolbar: null,
        toolbar: null,
        striped: false,
        method: "post",
        nowrap: true,
        idField: null,
        url: null,
        data: null,
        loadMsg: "Processing, please wait ...",
        rownumbers: false,
        singleSelect: false,
        ctrlSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        pagination: false,
        pagePosition: "bottom",
        pageNumber: 1,
        pageSize: 10,
        pageList: [ 10, 20, 30, 40, 50 ],
        queryParams: {},
        sortName: null,
        sortOrder: "asc",
        multiSort: false,
        remoteSort: true,
        showHeader: true,
        showFooter: false,
        scrollbarSize: 18,
        rowStyler: function(e, t) {},
        loader: function(e, t, a) {
            var i = $(this).datagrid("options");
            if (!i.url) {
                return false;
            }
            $.ajax({
                type: i.method,
                url: i.url,
                data: e,
                dataType: "json",
                success: function(e) {
                    t(e);
                },
                error: function() {
                    a.apply(this, arguments);
                }
            });
        },
        loadFilter: function(e) {
            if (typeof e.length == "number" && typeof e.splice == "function") {
                return {
                    total: e.length,
                    rows: e
                };
            } else {
                return e;
            }
        },
        editors: _651,
        finder: {
            getTr: function(e, t, a, i) {
                a = a || "body";
                i = i || 0;
                var n = $.data(e, "datagrid");
                var r = n.dc;
                var o = n.options;
                if (i == 0) {
                    var s = o.finder.getTr(e, t, a, 1);
                    var d = o.finder.getTr(e, t, a, 2);
                    return s.add(d);
                } else {
                    if (a == "body") {
                        var l = $("#" + n.rowIdPrefix + "-" + i + "-" + t);
                        if (!l.length) {
                            l = (i == 1 ? r.body1 : r.body2).find(">table>tbody>tr[datagrid-row-index=" + t + "]");
                        }
                        return l;
                    } else {
                        if (a == "footer") {
                            return (i == 1 ? r.footer1 : r.footer2).find(">table>tbody>tr[datagrid-row-index=" + t + "]");
                        } else {
                            if (a == "selected") {
                                return (i == 1 ? r.body1 : r.body2).find(">table>tbody>tr.datagrid-row-selected");
                            } else {
                                if (a == "highlight") {
                                    return (i == 1 ? r.body1 : r.body2).find(">table>tbody>tr.datagrid-row-over");
                                } else {
                                    if (a == "checked") {
                                        return (i == 1 ? r.body1 : r.body2).find(">table>tbody>tr.datagrid-row-checked");
                                    } else {
                                        if (a == "last") {
                                            return (i == 1 ? r.body1 : r.body2).find(">table>tbody>tr[datagrid-row-index]:last");
                                        } else {
                                            if (a == "allbody") {
                                                return (i == 1 ? r.body1 : r.body2).find(">table>tbody>tr[datagrid-row-index]");
                                            } else {
                                                if (a == "allfooter") {
                                                    return (i == 1 ? r.footer1 : r.footer2).find(">table>tbody>tr[datagrid-row-index]");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            getRow: function(e, t) {
                var a = typeof t == "object" ? t.attr("datagrid-row-index") : t;
                return $.data(e, "datagrid").data.rows[parseInt(a)];
            },
            getRows: function(e) {
                return $(e).datagrid("getRows");
            }
        },
        view: _6cf,
        onBeforeLoad: function(e) {},
        onLoadSuccess: function() {},
        onLoadError: function() {},
        onClickRow: function(e, t) {},
        onDblClickRow: function(e, t) {},
        onClickCell: function(e, t, a) {},
        onDblClickCell: function(e, t, a) {},
        onBeforeSortColumn: function(e, t) {},
        onSortColumn: function(e, t) {},
        onResizeColumn: function(e, t) {},
        onBeforeSelect: function(e, t) {},
        onSelect: function(e, t) {},
        onBeforeUnselect: function(e, t) {},
        onUnselect: function(e, t) {},
        onSelectAll: function(e) {},
        onUnselectAll: function(e) {},
        onBeforeCheck: function(e, t) {},
        onCheck: function(e, t) {},
        onBeforeUncheck: function(e, t) {},
        onUncheck: function(e, t) {},
        onCheckAll: function(e) {},
        onUncheckAll: function(e) {},
        onBeforeEdit: function(e, t) {},
        onBeginEdit: function(e, t) {},
        onEndEdit: function(e, t, a) {},
        onAfterEdit: function(e, t, a) {},
        onCancelEdit: function(e, t) {},
        onHeaderContextMenu: function(e, t) {},
        onRowContextMenu: function(e, t, a) {},
        onDblClickHeader: function(e, t) {},
        lazy: false,
        onHighlightRow: function(e, t) {},
        onColumnsLoad: function(e, t) {},
        clickDelay: 0
    });
})(jQuery);

(function(g) {
    var r;
    function i(i) {
        var e = g.data(i, "propertygrid");
        var n = g.data(i, "propertygrid").options;
        g(i).datagrid(g.extend({}, n, {
            cls: "propertygrid",
            view: n.showGroup ? n.groupView : n.view,
            onClickRow: function(e, t) {
                if (r != this) {
                    o(r);
                    r = this;
                }
                if (n.editIndex != e && t.editor) {
                    var a = g(this).datagrid("getColumnOption", "value");
                    a.editor = t.editor;
                    o(r);
                    g(this).datagrid("beginEdit", e);
                    g(this).datagrid("getEditors", e)[0].target.focus();
                    n.editIndex = e;
                }
                n.onClickRow.call(i, e, t);
            },
            loadFilter: function(e) {
                o(this);
                return n.loadFilter.call(this, e);
            }
        }));
        g(document).unbind(".propertygrid").bind("mousedown.propertygrid", function(e) {
            var t = g(e.target).closest("div.datagrid-view,div.combo-panel");
            if (t.length) {
                return;
            }
            o(r);
            r = undefined;
        });
    }
    function o(e) {
        var t = g(e);
        if (!t.length) {
            return;
        }
        var a = g.data(e, "propertygrid").options;
        var i = a.editIndex;
        if (i == undefined) {
            return;
        }
        var n = t.datagrid("getEditors", i)[0];
        if (n) {
            n.target.blur();
            if (t.datagrid("validateRow", i)) {
                t.datagrid("endEdit", i);
            } else {
                t.datagrid("cancelEdit", i);
            }
        }
        a.editIndex = undefined;
    }
    g.fn.propertygrid = function(a, e) {
        if (typeof a == "string") {
            var t = g.fn.propertygrid.methods[a];
            if (t) {
                return t(this, e);
            } else {
                return this.datagrid(a, e);
            }
        }
        a = a || {};
        return this.each(function() {
            var e = g.data(this, "propertygrid");
            if (e) {
                g.extend(e.options, a);
            } else {
                var t = g.extend({}, g.fn.propertygrid.defaults, g.fn.propertygrid.parseOptions(this), a);
                t.frozenColumns = g.extend(true, [], t.frozenColumns);
                t.columns = g.extend(true, [], t.columns);
                g.data(this, "propertygrid", {
                    options: t
                });
            }
            i(this);
        });
    };
    g.fn.propertygrid.methods = {
        options: function(e) {
            return g.data(e[0], "propertygrid").options;
        }
    };
    g.fn.propertygrid.parseOptions = function(e) {
        return g.extend({}, g.fn.datagrid.parseOptions(e), g.parser.parseOptions(e, [ {
            showGroup: "boolean"
        } ]));
    };
    var e = g.extend({}, g.fn.datagrid.defaults.view, {
        render: function(e, t, a) {
            var i = [];
            var n = this.groups;
            for (var r = 0; r < n.length; r++) {
                i.push(this.renderGroup.call(this, e, r, n[r], a));
            }
            g(t).html(i.join(""));
        },
        renderGroup: function(e, t, a, i) {
            var n = g.data(e, "datagrid");
            var r = n.options;
            var o = g(e).datagrid("getColumnFields", i);
            var s = [];
            s.push('<div class="datagrid-group" group-index=' + t + ">");
            s.push('<table cellspacing="0" cellpadding="0" border="0" style="height:100%"><tbody>');
            s.push("<tr>");
            if (i && (r.rownumbers || r.frozenColumns.length) || !i && !(r.rownumbers || r.frozenColumns.length)) {
                s.push('<td style="border:0;text-align:center;width:25px"><span class="datagrid-row-expander datagrid-row-collapse" style="display:inline-block;width:16px;height:16px;cursor:pointer">&nbsp;</span></td>');
            }
            s.push('<td style="border:0;">');
            if (!i) {
                s.push('<span class="datagrid-group-title">');
                s.push(r.groupFormatter.call(e, a.value, a.rows));
                s.push("</span>");
            }
            s.push("</td>");
            s.push("</tr>");
            s.push("</tbody></table>");
            s.push("</div>");
            s.push('<table class="datagrid-btable" cellspacing="0" cellpadding="0" border="0"><tbody>');
            var d = a.startIndex;
            for (var l = 0; l < a.rows.length; l++) {
                var c = r.rowStyler ? r.rowStyler.call(e, d, a.rows[l]) : "";
                var u = "";
                var f = "";
                if (typeof c == "string") {
                    f = c;
                } else {
                    if (c) {
                        u = c["class"] || "";
                        f = c["style"] || "";
                    }
                }
                var h = 'class="datagrid-row ' + (d % 2 && r.striped ? "datagrid-row-alt " : " ") + u + '"';
                var p = f ? 'style="' + f + '"' : "";
                var v = n.rowIdPrefix + "-" + (i ? 1 : 2) + "-" + d;
                s.push('<tr id="' + v + '" datagrid-row-index="' + d + '" ' + h + " " + p + ">");
                s.push(this.renderRow.call(this, e, o, i, d, a.rows[l]));
                s.push("</tr>");
                d++;
            }
            s.push("</tbody></table>");
            return s.join("");
        },
        bindEvents: function(n) {
            var e = g.data(n, "datagrid");
            var t = e.dc;
            var a = t.body1.add(t.body2);
            var r = (g.data(a[0], "events") || g._data(a[0], "events")).click[0].handler;
            a.unbind("click").bind("click", function(e) {
                var t = g(e.target);
                var a = t.closest("span.datagrid-row-expander");
                if (a.length) {
                    var i = a.closest("div.datagrid-group").attr("group-index");
                    if (a.hasClass("datagrid-row-collapse")) {
                        g(n).datagrid("collapseGroup", i);
                    } else {
                        g(n).datagrid("expandGroup", i);
                    }
                } else {
                    r(e);
                }
                e.stopPropagation();
            });
        },
        onBeforeRender: function(e, t) {
            var a = g.data(e, "datagrid");
            var i = a.options;
            f();
            var n = [];
            for (var r = 0; r < t.length; r++) {
                var o = t[r];
                var s = u(o[i.groupField]);
                if (!s) {
                    s = {
                        value: o[i.groupField],
                        rows: [ o ]
                    };
                    n.push(s);
                } else {
                    s.rows.push(o);
                }
            }
            var d = 0;
            var l = [];
            for (var r = 0; r < n.length; r++) {
                var s = n[r];
                s.startIndex = d;
                d += s.rows.length;
                l = l.concat(s.rows);
            }
            a.data.rows = l;
            this.groups = n;
            var c = this;
            setTimeout(function() {
                c.bindEvents(e);
            }, 0);
            function u(e) {
                for (var t = 0; t < n.length; t++) {
                    var a = n[t];
                    if (a.value == e) {
                        return a;
                    }
                }
                return null;
            }
            function f() {
                if (!g("#datagrid-group-style").length) {
                    g("head").append('<style id="datagrid-group-style">' + ".datagrid-group{height:25px;overflow:hidden;font-weight:bold;border-bottom:1px solid #ccc;}" + "</style>");
                }
            }
        }
    });
    g.extend(g.fn.datagrid.methods, {
        expandGroup: function(e, i) {
            return e.each(function() {
                var e = g.data(this, "datagrid").dc.view;
                var t = e.find(i != undefined ? 'div.datagrid-group[group-index="' + i + '"]' : "div.datagrid-group");
                var a = t.find("span.datagrid-row-expander");
                if (a.hasClass("datagrid-row-expand")) {
                    a.removeClass("datagrid-row-expand").addClass("datagrid-row-collapse");
                    t.next("table").show();
                }
                g(this).datagrid("fixRowHeight");
            });
        },
        collapseGroup: function(e, i) {
            return e.each(function() {
                var e = g.data(this, "datagrid").dc.view;
                var t = e.find(i != undefined ? 'div.datagrid-group[group-index="' + i + '"]' : "div.datagrid-group");
                var a = t.find("span.datagrid-row-expander");
                if (a.hasClass("datagrid-row-collapse")) {
                    a.removeClass("datagrid-row-collapse").addClass("datagrid-row-expand");
                    t.next("table").hide();
                }
                g(this).datagrid("fixRowHeight");
            });
        }
    });
    g.fn.propertygrid.defaults = g.extend({}, g.fn.datagrid.defaults, {
        singleSelect: true,
        remoteSort: false,
        fitColumns: true,
        loadMsg: "",
        frozenColumns: [ [ {
            field: "f",
            width: 16,
            resizable: false
        } ] ],
        columns: [ [ {
            field: "name",
            title: "Name",
            width: 100,
            sortable: true
        }, {
            field: "value",
            title: "Value",
            width: 100,
            resizable: false
        } ] ],
        showGroup: false,
        groupView: e,
        groupField: "group",
        groupFormatter: function(e, t) {
            return e;
        }
    });
})(jQuery);

(function(x) {
    function n(i) {
        var e = x.data(i, "treegrid");
        var n = e.options;
        x(i).datagrid(x.extend({}, n, {
            url: null,
            data: null,
            loader: function() {
                return false;
            },
            onBeforeLoad: function() {
                return false;
            },
            onLoadSuccess: function() {},
            onResizeColumn: function(e, t) {
                v(i);
                n.onResizeColumn.call(i, e, t);
            },
            onBeforeSortColumn: function(e, t) {
                if (n.onBeforeSortColumn.call(i, e, t) == false) {
                    return false;
                }
            },
            onSortColumn: function(e, t) {
                n.sortName = e;
                n.sortOrder = t;
                if (n.remoteSort) {
                    m(i);
                } else {
                    var a = x(i).treegrid("getData");
                    p(i, null, a);
                }
                n.onSortColumn.call(i, e, t);
            },
            onClickCell: function(e, t) {
                n.onClickCell.call(i, t, Y(i, e));
            },
            onDblClickCell: function(e, t) {
                n.onDblClickCell.call(i, t, Y(i, e));
            },
            onRowContextMenu: function(e, t) {
                n.onContextMenu.call(i, e, Y(i, t));
            }
        }));
        var t = x.data(i, "datagrid").options;
        n.columns = t.columns;
        n.frozenColumns = t.frozenColumns;
        e.dc = x.data(i, "datagrid").dc;
        if (n.pagination) {
            var a = x(i).datagrid("getPager");
            a.pagination({
                pageNumber: n.pageNumber,
                pageSize: n.pageSize,
                pageList: n.pageList,
                onSelectPage: function(e, t) {
                    n.pageNumber = e;
                    n.pageSize = t;
                    m(i);
                }
            });
            n.pageSize = a.pagination("options").pageSize;
        }
    }
    function v(n, e) {
        var r = x.data(n, "datagrid").options;
        var t = x.data(n, "datagrid").dc;
        if (!t.body1.is(":empty") && (!r.nowrap || r.autoRowHeight)) {
            if (e != undefined) {
                var a = l(n, e);
                for (var i = 0; i < a.length; i++) {
                    o(a[i][r.idField]);
                }
            }
        }
        x(n).datagrid("fixRowHeight", e);
        function o(e) {
            var t = r.finder.getTr(n, e, "body", 1);
            var a = r.finder.getTr(n, e, "body", 2);
            t.css("height", "");
            a.css("height", "");
            var i = Math.max(t.height(), a.height());
            t.css("height", i);
            a.css("height", i);
        }
    }
    function g(e) {
        var t = x.data(e, "datagrid").dc;
        var a = x.data(e, "treegrid").options;
        if (!a.rownumbers) {
            return;
        }
        t.body1.find("div.datagrid-cell-rownumber").each(function(e) {
            x(this).html(e + 1);
        });
    }
    function e(i) {
        return function(e) {
            var t = x(e.target);
            var a = i ? "addClass" : "removeClass";
            if (t.hasClass("tree-hit")) {
                t.hasClass("tree-expanded") ? t[a]("tree-expanded-hover") : t[a]("tree-collapsed-hover");
            }
        };
    }
    function t(e) {
        var i = x(e.target);
        if (i.hasClass("tree-hit")) {
            t(w);
        } else {
            if (i.hasClass("tree-checkbox")) {
                t(s);
            } else {}
        }
        function t(e) {
            var t = i.closest("tr.datagrid-row");
            var a = t.closest("div.datagrid-view").children(".datagrid-f")[0];
            e(a, t.attr("node-id"));
        }
    }
    function s(e, t, a, i) {
        var n = x.data(e, "treegrid");
        var r = n.checkedRows;
        var o = n.options;
        if (!o.checkbox) {
            return;
        }
        var s = Y(e, t);
        if (!s.checkState) {
            return;
        }
        var d = o.finder.getTr(e, t);
        var l = d.find(".tree-checkbox");
        if (a == undefined) {
            if (l.hasClass("tree-checkbox1")) {
                a = false;
            } else {
                if (l.hasClass("tree-checkbox0")) {
                    a = true;
                } else {
                    if (s._checked == undefined) {
                        s._checked = l.hasClass("tree-checkbox1");
                    }
                    a = !s._checked;
                }
            }
        }
        s._checked = a;
        if (a) {
            if (l.hasClass("tree-checkbox1")) {
                return;
            }
        } else {
            if (l.hasClass("tree-checkbox0")) {
                return;
            }
        }
        if (!i) {
            if (o.onBeforeCheckNode.call(e, s, a) == false) {
                return;
            }
        }
        if (o.cascadeCheck) {
            u(e, s, a);
            f(e, s);
        } else {
            c(e, s, a ? "1" : "0");
        }
        if (!i) {
            o.onCheckNode.call(e, s, a);
        }
    }
    function c(e, t, a) {
        var i = x.data(e, "treegrid");
        var n = i.checkedRows;
        var r = i.options;
        if (!t.checkState || a == undefined) {
            return;
        }
        var o = r.finder.getTr(e, t[r.idField]);
        var s = o.find(".tree-checkbox");
        if (!s.length) {
            return;
        }
        t.checkState = [ "unchecked", "checked", "indeterminate" ][a];
        t.checked = t.checkState == "checked";
        s.removeClass("tree-checkbox0 tree-checkbox1 tree-checkbox2");
        s.addClass("tree-checkbox" + a);
        if (a == 0) {
            x.hisui.removeArrayItem(n, r.idField, t[r.idField]);
        } else {
            x.hisui.addArrayItem(n, r.idField, t);
        }
    }
    function u(t, e, a) {
        var i = a ? 1 : 0;
        c(t, e, i);
        x.hisui.forEach(e.children || [], true, function(e) {
            c(t, e, i);
        });
    }
    function f(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = C(e, t[a.idField]);
        if (i) {
            c(e, i, d(i));
            f(e, i);
        }
    }
    function d(e) {
        var t = 0;
        var a = 0;
        var i = 0;
        x.hisui.forEach(e.children || [], false, function(e) {
            if (e.checkState) {
                t++;
                if (e.checkState == "checked") {
                    i++;
                } else {
                    if (e.checkState == "unchecked") {
                        a++;
                    }
                }
            }
        });
        if (t == 0) {
            return undefined;
        }
        var n = 0;
        if (a == t) {
            n = 0;
        } else {
            if (i == t) {
                n = 1;
            } else {
                n = 2;
            }
        }
        return n;
    }
    function r(e, t) {
        var a = x.data(e, "treegrid").options;
        if (!a.checkbox) {
            return;
        }
        var i = Y(e, t);
        var n = a.finder.getTr(e, t);
        var r = n.find(".tree-checkbox");
        if (a.view.hasCheckbox(e, i)) {
            if (!r.length) {
                i.checkState = i.checkState || "unchecked";
                x('<span class="tree-checkbox"></span>').insertBefore(n.find(".tree-title"));
            }
            if (i.checkState == "checked") {
                s(e, t, true, true);
            } else {
                if (i.checkState == "unchecked") {
                    s(e, t, false, true);
                } else {
                    var o = d(i);
                    if (o === 0) {
                        s(e, t, false, true);
                    } else {
                        if (o === 1) {
                            s(e, t, true, true);
                        }
                    }
                }
            }
        } else {
            r.remove();
            i.checkState = undefined;
            i.checked = undefined;
            f(e, i);
        }
    }
    function h(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = a.finder.getTr(e, t, "body", 1);
        var n = a.finder.getTr(e, t, "body", 2);
        var r = x(e).datagrid("getColumnFields", true).length + (a.rownumbers ? 1 : 0);
        var o = x(e).datagrid("getColumnFields", false).length;
        s(i, r);
        s(n, o);
        function s(e, t) {
            x('<tr class="treegrid-tr-tree">' + '<td style="border:0px" colspan="' + t + '">' + "<div></div>" + "</td>" + "</tr>").insertAfter(e);
        }
    }
    function b(e, t) {
        var a = x.data(e, "treegrid");
        var i = a.options;
        var n = a.checkedRows;
        if (!x.isArray(n)) return;
        for (var r = 0; r < n.length; r++) {
            var o = n[r];
            var s = i.finder.getTr(e, o[i.idField], "body", 2);
            if (t.find(s).length > 0) {
                n.splice(r, 1);
                r--;
            }
        }
    }
    function p(e, t, a, i, n) {
        var r = x.data(e, "treegrid");
        var o = r.options;
        var s = r.dc;
        a = o.loadFilter.call(e, a, t);
        var d = Y(e, t);
        if (d) {
            var l = o.finder.getTr(e, t, "body", 1);
            var c = o.finder.getTr(e, t, "body", 2);
            var u = l.next("tr.treegrid-tr-tree").children("td").children("div");
            var f = c.next("tr.treegrid-tr-tree").children("td").children("div");
            if (!i) {
                d.children = [];
            }
        } else {
            var u = s.body1;
            var f = s.body2;
            if (!i) {
                r.data = [];
            }
        }
        if (!i) {
            if (!d) {
                r.checkedRows = [];
            } else {
                b(e, f);
            }
            u.empty();
            f.empty();
        }
        if (o.view.onBeforeRender) {
            o.view.onBeforeRender.call(o.view, e, t, a);
        }
        o.view.render.call(o.view, e, u, true);
        o.view.render.call(o.view, e, f, false);
        if (o.showFooter) {
            o.view.renderFooter.call(o.view, e, s.footer1, true);
            o.view.renderFooter.call(o.view, e, s.footer2, false);
        }
        if (o.view.onAfterRender) {
            o.view.onAfterRender.call(o.view, e);
        }
        if (!t && o.pagination) {
            var h = x.data(e, "treegrid").total;
            var p = x(e).datagrid("getPager");
            if (p.pagination("options").total != h) {
                p.pagination({
                    total: h
                });
            }
        }
        v(e);
        g(e);
        x(e).treegrid("showLines");
        x(e).treegrid("setSelectionState");
        x(e).treegrid("autoSizeColumn");
        if (!n) {
            o.onLoadSuccess.call(e, d, a);
        }
    }
    function m(t, a, e, i, n) {
        var r = x.data(t, "treegrid").options;
        var o = x(t).datagrid("getPanel").find("div.datagrid-body");
        if (a == undefined && r.queryParams) {
            r.queryParams.id = undefined;
        }
        if (e) {
            r.queryParams = e;
        }
        var s = x.extend({}, r.queryParams);
        if (r.pagination) {
            x.extend(s, {
                page: r.pageNumber,
                rows: r.pageSize
            });
        }
        if (r.sortName) {
            x.extend(s, {
                sort: r.sortName,
                order: r.sortOrder
            });
        }
        var d = Y(t, a);
        if (r.onBeforeLoad.call(t, d, s) == false) {
            return;
        }
        var l = o.find('tr[node-id="' + a + '"] span.tree-folder');
        l.addClass("tree-loading");
        x(t).treegrid("loading");
        var c = r.loader.call(t, s, function(e) {
            l.removeClass("tree-loading");
            x(t).treegrid("loaded");
            p(t, a, e, i);
            if (n) {
                n();
            }
        }, function() {
            l.removeClass("tree-loading");
            x(t).treegrid("loaded");
            r.onLoadError.apply(t, arguments);
            if (n) {
                n();
            }
        });
        if (c == false) {
            l.removeClass("tree-loading");
            x(t).treegrid("loaded");
        }
    }
    function a(e) {
        var t = i(e);
        return t.length ? t[0] : null;
    }
    function i(e) {
        return x.data(e, "treegrid").data;
    }
    function C(e, t) {
        var a = Y(e, t);
        if (a._parentId) {
            return Y(e, a._parentId);
        } else {
            return null;
        }
    }
    function l(e, t) {
        var a = x.data(e, "treegrid").data;
        if (t) {
            var i = Y(e, t);
            a = i ? i.children || [] : [];
        }
        var n = [];
        x.hisui.forEach(a, true, function(e) {
            n.push(e);
        });
        return n;
    }
    function o(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = a.finder.getTr(e, t);
        var n = i.children('td[field="' + a.treeField + '"]');
        return n.find("span.tree-indent,span.tree-hit").length;
    }
    function Y(e, t) {
        var a = x.data(e, "treegrid");
        var i = a.options;
        var n = null;
        x.hisui.forEach(a.data, true, function(e) {
            if (e[i.idField] == t) {
                n = e;
                return false;
            }
        });
        return n;
    }
    function Z(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = Y(e, t);
        var n = a.finder.getTr(e, t);
        var r = n.find("span.tree-hit");
        if (r.length == 0) {
            return;
        }
        if (r.hasClass("tree-collapsed")) {
            return;
        }
        if (a.onBeforeCollapse.call(e, i) == false) {
            return;
        }
        r.removeClass("tree-expanded tree-expanded-hover").addClass("tree-collapsed");
        r.next().removeClass("tree-folder-open");
        i.state = "closed";
        n = n.next("tr.treegrid-tr-tree");
        var o = n.children("td").children("div");
        if (a.animate) {
            o.slideUp("normal", function() {
                x(e).treegrid("autoSizeColumn");
                v(e, t);
                a.onCollapse.call(e, i);
            });
        } else {
            o.hide();
            x(e).treegrid("autoSizeColumn");
            v(e, t);
            a.onCollapse.call(e, i);
        }
    }
    function S(t, a) {
        var i = x.data(t, "treegrid").options;
        var e = i.finder.getTr(t, a);
        var n = e.find("span.tree-hit");
        var r = Y(t, a);
        if (n.length == 0) {
            return;
        }
        if (n.hasClass("tree-expanded")) {
            return;
        }
        if (i.onBeforeExpand.call(t, r) == false) {
            return;
        }
        n.removeClass("tree-collapsed tree-collapsed-hover").addClass("tree-expanded");
        n.next().addClass("tree-folder-open");
        var o = e.next("tr.treegrid-tr-tree");
        if (o.length) {
            var s = o.children("td").children("div");
            l(s);
        } else {
            h(t, r[i.idField]);
            var o = e.next("tr.treegrid-tr-tree");
            var s = o.children("td").children("div");
            s.hide();
            var d = x.extend({}, i.queryParams || {});
            d.id = r[i.idField];
            m(t, r[i.idField], d, true, function() {
                if (s.is(":empty")) {
                    o.remove();
                } else {
                    l(s);
                }
            });
        }
        function l(e) {
            r.state = "open";
            if (i.animate) {
                e.slideDown("normal", function() {
                    x(t).treegrid("autoSizeColumn");
                    v(t, a);
                    i.onExpand.call(t, r);
                });
            } else {
                e.show();
                x(t).treegrid("autoSizeColumn");
                v(t, a);
                i.onExpand.call(t, r);
            }
        }
    }
    function w(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = a.finder.getTr(e, t);
        var n = i.find("span.tree-hit");
        if (n.hasClass("tree-expanded")) {
            Z(e, t);
        } else {
            S(e, t);
        }
    }
    function L(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = l(e, t);
        if (t) {
            i.unshift(Y(e, t));
        }
        for (var n = 0; n < i.length; n++) {
            Z(e, i[n][a.idField]);
        }
    }
    function T(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = l(e, t);
        if (t) {
            i.unshift(Y(e, t));
        }
        for (var n = 0; n < i.length; n++) {
            S(e, i[n][a.idField]);
        }
    }
    function X(e, t) {
        var a = x.data(e, "treegrid").options;
        var i = [];
        var n = C(e, t);
        while (n) {
            var r = n[a.idField];
            i.unshift(r);
            n = C(e, r);
        }
        for (var o = 0; o < i.length; o++) {
            S(e, i[o]);
        }
    }
    function J(e, t) {
        var a = x.data(e, "treegrid");
        var i = a.options;
        if (t.parent) {
            var n = i.finder.getTr(e, t.parent);
            if (n.next("tr.treegrid-tr-tree").length == 0) {
                h(e, t.parent);
            }
            var r = n.children('td[field="' + i.treeField + '"]').children("div.datagrid-cell");
            var o = r.children("span.tree-icon");
            if (o.hasClass("tree-file")) {
                o.removeClass("tree-file").addClass("tree-folder tree-folder-open");
                var s = x('<span class="tree-hit tree-expanded"></span>').insertBefore(o);
                if (s.prev().length) {
                    s.prev().remove();
                }
            }
        }
        p(e, t.parent, t.data, a.data.length > 0, true);
    }
    function y(o, s) {
        var d = s.before || s.after;
        var l = x.data(o, "treegrid").options;
        var e = C(o, d);
        J(o, {
            parent: e ? e[l.idField] : null,
            data: [ s.data ]
        });
        var t = e ? e.children : x(o).treegrid("getRoots");
        for (var a = 0; a < t.length; a++) {
            if (t[a][l.idField] == d) {
                var i = t[t.length - 1];
                t.splice(s.before ? a : a + 1, 0, i);
                t.splice(t.length - 1, 1);
                break;
            }
        }
        n(true);
        n(false);
        g(o);
        x(o).treegrid("showLines");
        function n(e) {
            var t = e ? 1 : 2;
            var a = l.finder.getTr(o, s.data[l.idField], "body", t);
            var i = a.closest("table.datagrid-btable");
            a = a.parent().children();
            var n = l.finder.getTr(o, d, "body", t);
            if (s.before) {
                a.insertBefore(n);
            } else {
                var r = n.next("tr.treegrid-tr-tree");
                a.insertAfter(r.length ? r : n);
            }
            i.remove();
        }
    }
    function H(e, t) {
        var a = x.data(e, "treegrid");
        var i = a.options;
        var n = C(e, t);
        x(e).datagrid("deleteRow", t);
        x.hisui.removeArrayItem(a.checkedRows, i.idField, t);
        g(e);
        if (n) {
            r(e, n[i.idField]);
        }
        a.total -= 1;
        x(e).datagrid("getPager").pagination("refresh", {
            total: a.total
        });
        x(e).treegrid("showLines");
    }
    function D(o) {
        var s = x(o);
        var d = s.treegrid("options");
        if (d.lines) {
            s.treegrid("getPanel").addClass("tree-lines");
        } else {
            s.treegrid("getPanel").removeClass("tree-lines");
            return;
        }
        s.treegrid("getPanel").find("span.tree-indent").removeClass("tree-line tree-join tree-joinbottom");
        s.treegrid("getPanel").find("div.datagrid-cell").removeClass("tree-node-last tree-root-first tree-root-one");
        var e = s.treegrid("getRoots");
        if (e.length > 1) {
            i(e[0]).addClass("tree-root-first");
        } else {
            if (e.length == 1) {
                i(e[0]).addClass("tree-root-one");
            }
        }
        a(e);
        l(e);
        function a(e) {
            x.map(e, function(e) {
                if (e.children && e.children.length) {
                    a(e.children);
                } else {
                    var t = i(e);
                    t.find(".tree-icon").prev().addClass("tree-join");
                }
            });
            if (e.length) {
                var t = i(e[e.length - 1]);
                t.addClass("tree-node-last");
                t.find(".tree-join").removeClass("tree-join").addClass("tree-joinbottom");
            }
        }
        function l(e) {
            x.map(e, function(e) {
                if (e.children && e.children.length) {
                    l(e.children);
                }
            });
            for (var t = 0; t < e.length - 1; t++) {
                var a = e[t];
                var i = s.treegrid("getLevel", a[d.idField]);
                var n = d.finder.getTr(o, a[d.idField]);
                var r = n.next().find('tr.datagrid-row td[field="' + d.treeField + '"] div.datagrid-cell');
                r.find("span:eq(" + (i - 1) + ")").addClass("tree-line");
            }
        }
        function i(e) {
            var t = d.finder.getTr(o, e[d.idField]);
            var a = t.find('td[field="' + d.treeField + '"] div.datagrid-cell');
            return a;
        }
    }
    x.fn.treegrid = function(i, e) {
        if (typeof i == "string") {
            var t = x.fn.treegrid.methods[i];
            if (t) {
                return t(this, e);
            } else {
                return this.datagrid(i, e);
            }
        }
        i = i || {};
        return this.each(function() {
            var e = x.data(this, "treegrid");
            if (e) {
                x.extend(e.options, i);
            } else {
                e = x.data(this, "treegrid", {
                    options: x.extend({}, x.fn.treegrid.defaults, x.fn.treegrid.parseOptions(this), i),
                    data: [],
                    checkedRows: [],
                    tmpIds: []
                });
            }
            n(this);
            var t = x(e.dc.body2);
            for (var a in e.options.rowEvents) {
                t.bind(a, e.options.rowEvents[a]);
            }
            if (e.options.data) {
                x(this).treegrid("loadData", e.options.data);
            }
            m(this);
        });
    };
    x.fn.treegrid.methods = {
        options: function(e) {
            return x.data(e[0], "treegrid").options;
        },
        resize: function(e, t) {
            return e.each(function() {
                x(this).datagrid("resize", t);
            });
        },
        fixRowHeight: function(e, t) {
            return e.each(function() {
                v(this, t);
            });
        },
        loadData: function(e, t) {
            return e.each(function() {
                p(this, t.parent, t);
            });
        },
        load: function(e, t) {
            return e.each(function() {
                x(this).treegrid("options").pageNumber = 1;
                x(this).treegrid("getPager").pagination({
                    pageNumber: 1
                });
                x(this).treegrid("reload", t);
            });
        },
        reload: function(e, n) {
            return e.each(function() {
                var e = x(this).treegrid("options");
                var t = {};
                if (typeof n == "object") {
                    t = n;
                } else {
                    t = x.extend({}, e.queryParams);
                    t.id = n;
                }
                if (t.id) {
                    var a = x(this).treegrid("find", t.id);
                    if (a.children) {
                        a.children.splice(0, a.children.length);
                    }
                    e.queryParams = t;
                    var i = e.finder.getTr(this, t.id);
                    b(this, i.next("tr.treegrid-tr-tree"));
                    i.next("tr.treegrid-tr-tree").remove();
                    i.find("span.tree-hit").removeClass("tree-expanded tree-expanded-hover").addClass("tree-collapsed");
                    S(this, t.id);
                } else {
                    m(this, null, t);
                }
            });
        },
        reloadFooter: function(e, a) {
            return e.each(function() {
                var e = x.data(this, "treegrid").options;
                var t = x.data(this, "datagrid").dc;
                if (a) {
                    x.data(this, "treegrid").footer = a;
                }
                if (e.showFooter) {
                    e.view.renderFooter.call(e.view, this, t.footer1, true);
                    e.view.renderFooter.call(e.view, this, t.footer2, false);
                    if (e.view.onAfterRender) {
                        e.view.onAfterRender.call(e.view, this);
                    }
                    x(this).treegrid("fixRowHeight");
                }
            });
        },
        getData: function(e) {
            return x.data(e[0], "treegrid").data;
        },
        getFooterRows: function(e) {
            return x.data(e[0], "treegrid").footer;
        },
        getRoot: function(e) {
            return a(e[0]);
        },
        getRoots: function(e) {
            return i(e[0]);
        },
        getParent: function(e, t) {
            return C(e[0], t);
        },
        getChildren: function(e, t) {
            return l(e[0], t);
        },
        getLevel: function(e, t) {
            return o(e[0], t);
        },
        find: function(e, t) {
            return Y(e[0], t);
        },
        isLeaf: function(e, t) {
            var a = x.data(e[0], "treegrid").options;
            var i = a.finder.getTr(e[0], t);
            var n = i.find("span.tree-hit");
            return n.length == 0;
        },
        select: function(e, t) {
            return e.each(function() {
                x(this).datagrid("selectRow", t);
            });
        },
        unselect: function(e, t) {
            return e.each(function() {
                x(this).datagrid("unselectRow", t);
            });
        },
        collapse: function(e, t) {
            return e.each(function() {
                Z(this, t);
            });
        },
        expand: function(e, t) {
            return e.each(function() {
                S(this, t);
            });
        },
        toggle: function(e, t) {
            return e.each(function() {
                w(this, t);
            });
        },
        collapseAll: function(e, t) {
            return e.each(function() {
                L(this, t);
            });
        },
        expandAll: function(e, t) {
            return e.each(function() {
                T(this, t);
            });
        },
        expandTo: function(e, t) {
            return e.each(function() {
                X(this, t);
            });
        },
        append: function(e, t) {
            return e.each(function() {
                J(this, t);
            });
        },
        insert: function(e, t) {
            return e.each(function() {
                y(this, t);
            });
        },
        remove: function(e, t) {
            return e.each(function() {
                H(this, t);
            });
        },
        pop: function(e, t) {
            var a = e.treegrid("find", t);
            e.treegrid("remove", t);
            return a;
        },
        refresh: function(e, t) {
            return e.each(function() {
                var e = x.data(this, "treegrid").options;
                e.view.refreshRow.call(e.view, this, t);
            });
        },
        update: function(e, a) {
            return e.each(function() {
                var e = x.data(this, "treegrid").options;
                var t = a.row;
                e.view.updateRow.call(e.view, this, a.id, t);
                if (t.checked != undefined) {
                    t = Y(this, a.id);
                    x.extend(t, {
                        checkState: t.checked ? "checked" : t.checked === false ? "unchecked" : undefined
                    });
                    r(this, a.id);
                }
            });
        },
        beginEdit: function(e, t) {
            return e.each(function() {
                x(this).datagrid("beginEdit", t);
                x(this).treegrid("fixRowHeight", t);
            });
        },
        endEdit: function(e, t) {
            return e.each(function() {
                x(this).datagrid("endEdit", t);
            });
        },
        cancelEdit: function(e, t) {
            return e.each(function() {
                x(this).datagrid("cancelEdit", t);
            });
        },
        showLines: function(e) {
            return e.each(function() {
                D(this);
            });
        },
        setSelectionState: function(e) {
            return e.each(function() {
                x(this).datagrid("setSelectionState");
                var e = x(this).data("treegrid");
                for (var t = 0; t < e.tmpIds.length; t++) {
                    s(this, e.tmpIds[t], true, true);
                }
                e.tmpIds = [];
            });
        },
        getCheckedNodes: function(e, t) {
            t = t || "checked";
            var a = [];
            x.hisui.forEach(e.data("treegrid").checkedRows, false, function(e) {
                if (e.checkState == t) {
                    a.push(e);
                }
            });
            return a;
        },
        checkNode: function(e, t) {
            return e.each(function() {
                s(this, t, true);
            });
        },
        uncheckNode: function(e, t) {
            return e.each(function() {
                s(this, t, false);
            });
        },
        clearChecked: function(e) {
            return e.each(function() {
                var t = this;
                var a = x(t).treegrid("options");
                x(t).datagrid("clearChecked");
                x.map(x(t).treegrid("getCheckedNodes"), function(e) {
                    s(t, e[a.idField], false, true);
                });
            });
        }
    };
    x.fn.treegrid.parseOptions = function(e) {
        return x.extend({}, x.fn.datagrid.parseOptions(e), x.parser.parseOptions(e, [ "treeField", {
            checkbox: "boolean",
            cascadeCheck: "boolean",
            onlyLeafCheck: "boolean"
        }, {
            animate: "boolean"
        } ]));
    };
    var Q = x.extend({}, x.fn.datagrid.defaults.view, {
        getStyleValue: function(e) {
            var t = "";
            var a = "";
            if (typeof e == "string") {
                a = e;
            } else {
                if (e) {
                    t = e["class"] || "";
                    a = e["style"] || "";
                }
            }
            return {
                c: t,
                s: a
            };
        },
        render: function(v, e, t) {
            var g = x.data(v, "treegrid").options;
            var b = x(v).datagrid("getColumnFields", t);
            var m = x.data(v, "datagrid").rowIdPrefix;
            if (t) {
                if (!(g.rownumbers || g.frozenColumns && g.frozenColumns.length)) {
                    return;
                }
            }
            var C = this;
            if (this.treeNodes && this.treeNodes.length) {
                var a = Y.call(this, t, this.treeLevel, this.treeNodes);
                x(e).append(a.join(""));
            }
            function Y(e, t, a) {
                var i = x(v).treegrid("getParent", a[0][g.idField]);
                var n = (i ? i.children.length : x(v).treegrid("getRoots").length) - a.length;
                var r = [ '<table class="datagrid-btable" cellspacing="0" cellpadding="0" border="0"><tbody>' ];
                for (var o = 0; o < a.length; o++) {
                    var s = a[o];
                    if (s.state != "open" && s.state != "closed") {
                        s.state = "open";
                    }
                    var d = g.rowStyler ? g.rowStyler.call(v, s) : "";
                    var l = this.getStyleValue(d);
                    var c = 'class="datagrid-row ' + (n++ % 2 && g.striped ? "datagrid-row-alt " : " ") + l.c + '"';
                    var u = l.s ? 'style="' + l.s + '"' : "";
                    var f = m + "-" + (e ? 1 : 2) + "-" + s[g.idField];
                    r.push('<tr id="' + f + '" node-id="' + s[g.idField] + '" ' + c + " " + u + ">");
                    r = r.concat(C.renderRow.call(C, v, b, e, t, s));
                    r.push("</tr>");
                    if (s.children && s.children.length) {
                        var h = Y.call(this, e, t + 1, s.children);
                        var p = s.state == "closed" ? "none" : "block";
                        r.push('<tr class="treegrid-tr-tree"><td style="border:0px" colspan=' + (b.length + (g.rownumbers ? 1 : 0)) + '><div style="display:' + p + '">');
                        r = r.concat(h);
                        r.push("</div></td></tr>");
                    }
                }
                r.push("</tbody></table>");
                return r;
            }
        },
        renderFooter: function(e, t, a) {
            var i = x.data(e, "treegrid").options;
            var n = x.data(e, "treegrid").footer || [];
            var r = x(e).datagrid("getColumnFields", a);
            var o = [ '<table class="datagrid-ftable" cellspacing="0" cellpadding="0" border="0"><tbody>' ];
            for (var s = 0; s < n.length; s++) {
                var d = n[s];
                d[i.idField] = d[i.idField] || "foot-row-id" + s;
                o.push('<tr class="datagrid-row" node-id="' + d[i.idField] + '">');
                o.push(this.renderRow.call(this, e, r, a, 0, d));
                o.push("</tr>");
            }
            o.push("</tbody></table>");
            x(t).html(o.join(""));
        },
        renderRow: function(e, t, a, i, n) {
            var r = x.data(e, "treegrid");
            var o = r.options;
            var s = [];
            if (a && o.rownumbers) {
                s.push('<td class="datagrid-td-rownumber"><div class="datagrid-cell-rownumber">0</div></td>');
            }
            for (var d = 0; d < t.length; d++) {
                var l = t[d];
                var c = x(e).datagrid("getColumnOption", l);
                if (c) {
                    var u = c.styler ? c.styler(n[l], n) || "" : "";
                    var f = this.getStyleValue(u);
                    var h = f.c ? 'class="' + f.c + '"' : "";
                    var p = c.hidden ? 'style="display:none;' + f.s + '"' : f.s ? 'style="' + f.s + '"' : "";
                    s.push('<td field="' + l + '" ' + h + " " + p + ">");
                    var p = "";
                    if (!c.checkbox) {
                        if (c.align) {
                            p += "text-align:" + c.align + ";";
                        }
                        if (!o.nowrap) {
                            p += "white-space:normal;height:auto;";
                        } else {
                            if (o.autoRowHeight) {
                                p += "height:auto;";
                            }
                        }
                    }
                    s.push('<div style="' + p + '" ');
                    if (c.checkbox) {
                        s.push('class="datagrid-cell-check ');
                    } else {
                        s.push('class="datagrid-cell ' + c.cellClass);
                    }
                    s.push('">');
                    if (c.checkbox) {
                        if (n.checked) {
                            s.push('<input type="checkbox" checked="checked"');
                        } else {
                            s.push('<input type="checkbox"');
                        }
                        s.push(' name="' + l + '" value="' + (n[l] != undefined ? n[l] : "") + '">');
                    } else {
                        var v = null;
                        if (c.formatter) {
                            v = c.formatter(n[l], n);
                        } else {
                            v = n[l];
                        }
                        if (l == o.treeField) {
                            for (var g = 0; g < i; g++) {
                                s.push('<span class="tree-indent"></span>');
                            }
                            if (n.state == "closed") {
                                s.push('<span class="tree-hit tree-collapsed"></span>');
                                s.push('<span class="tree-icon tree-folder ' + (n.iconCls ? n.iconCls : "") + '"></span>');
                            } else {
                                if (n.children && n.children.length) {
                                    s.push('<span class="tree-hit tree-expanded"></span>');
                                    s.push('<span class="tree-icon tree-folder tree-folder-open ' + (n.iconCls ? n.iconCls : "") + '"></span>');
                                } else {
                                    s.push('<span class="tree-indent"></span>');
                                    s.push('<span class="tree-icon tree-file ' + (n.iconCls ? n.iconCls : "") + '"></span>');
                                }
                            }
                            if (this.hasCheckbox(e, n)) {
                                var b = 0;
                                var m = x.hisui.getArrayItem(r.checkedRows, o.idField, n[o.idField]);
                                if (m) {
                                    b = m.checkState == "checked" ? 1 : 2;
                                    n.checkState = m.checkState;
                                } else {
                                    var C = x.hisui.getArrayItem(r.checkedRows, o.idField, n._parentId);
                                    if (C && C.checkState == "checked" && o.cascadeCheck) {
                                        b = 1;
                                        n.checked = true;
                                        x.hisui.addArrayItem(r.checkedRows, o.idField, n);
                                    } else {
                                        if (n.checked) {
                                            x.hisui.addArrayItem(r.tmpIds, n[o.idField]);
                                        }
                                    }
                                    n.checkState = b ? "checked" : "unchecked";
                                }
                                s.push('<span class="tree-checkbox tree-checkbox' + b + '"></span>');
                            } else {
                                n.checkState = undefined;
                                n.checked = undefined;
                            }
                            s.push('<span class="tree-title">' + v + "</span>");
                        } else {
                            s.push(v);
                        }
                    }
                    s.push("</div>");
                    s.push("</td>");
                }
            }
            return s.join("");
        },
        hasCheckbox: function(e, t) {
            var a = x.data(e, "treegrid").options;
            if (a.checkbox) {
                if (x.isFunction(a.checkbox)) {
                    if (a.checkbox.call(e, t)) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if (a.onlyLeafCheck) {
                        if (t.state == "open" && !(t.children && t.children.length)) {
                            return true;
                        }
                    } else {
                        return true;
                    }
                }
            }
            return false;
        },
        refreshRow: function(e, t) {
            this.updateRow.call(this, e, t, {});
        },
        updateRow: function(r, o, e) {
            var s = x.data(r, "treegrid").options;
            var d = x(r).treegrid("find", o);
            x.extend(d, e);
            var l = x(r).treegrid("getLevel", o) - 1;
            var c = s.rowStyler ? s.rowStyler.call(r, d) : "";
            var u = x.data(r, "datagrid").rowIdPrefix;
            var f = d[s.idField];
            function t(e) {
                var t = x(r).treegrid("getColumnFields", e);
                var a = s.finder.getTr(r, o, "body", e ? 1 : 2);
                var i = a.find("div.datagrid-cell-rownumber").html();
                var n = a.find("div.datagrid-cell-check input[type=checkbox]").is(":checked");
                a.html(this.renderRow(r, t, e, l, d));
                a.attr("style", c || "");
                a.find("div.datagrid-cell-rownumber").html(i);
                if (n) {
                    a.find("div.datagrid-cell-check input[type=checkbox]")._propAttr("checked", true);
                }
                if (f != o) {
                    a.attr("id", u + "-" + (e ? 1 : 2) + "-" + f);
                    a.attr("node-id", f);
                }
            }
            t.call(this, true);
            t.call(this, false);
            x(r).treegrid("fixRowHeight", o);
        },
        deleteRow: function(n, e) {
            var r = x.data(n, "treegrid").options;
            var t = r.finder.getTr(n, e);
            t.next("tr.treegrid-tr-tree").remove();
            t.remove();
            var a = o(e);
            if (a) {
                if (a.children.length == 0) {
                    t = r.finder.getTr(n, a[r.idField]);
                    t.next("tr.treegrid-tr-tree").remove();
                    var i = t.children('td[field="' + r.treeField + '"]').children("div.datagrid-cell");
                    i.find(".tree-icon").removeClass("tree-folder").addClass("tree-file");
                    i.find(".tree-hit").remove();
                    x('<span class="tree-indent"></span>').prependTo(i);
                }
            }
            function o(e) {
                var t;
                var a = x(n).treegrid("getParent", e);
                if (a) {
                    t = a.children;
                } else {
                    t = x(n).treegrid("getData");
                }
                for (var i = 0; i < t.length; i++) {
                    if (t[i][r.idField] == e) {
                        t.splice(i, 1);
                        break;
                    }
                }
                return a;
            }
        },
        onBeforeRender: function(e, t, a) {
            if (x.isArray(t)) {
                a = {
                    total: t.length,
                    rows: t
                };
                t = null;
            }
            if (!a) {
                return false;
            }
            var i = x.data(e, "treegrid");
            var n = i.options;
            if (a.length == undefined) {
                if (a.footer) {
                    i.footer = a.footer;
                }
                if (a.total) {
                    i.total = a.total;
                }
                a = this.transfer(e, t, a.rows);
            } else {
                function r(e, t) {
                    for (var a = 0; a < e.length; a++) {
                        var i = e[a];
                        i._parentId = t;
                        if (i.children && i.children.length) {
                            r(i.children, i[n.idField]);
                        }
                    }
                }
                r(a, t);
            }
            var o = Y(e, t);
            if (o) {
                if (o.children) {
                    o.children = o.children.concat(a);
                } else {
                    o.children = a;
                }
            } else {
                i.data = i.data.concat(a);
            }
            this.sort(e, a);
            this.treeNodes = a;
            this.treeLevel = x(e).treegrid("getLevel", t);
        },
        sort: function(d, e) {
            var t = x.data(d, "treegrid").options;
            if (!t.remoteSort && t.sortName) {
                var l = t.sortName.split(",");
                var c = t.sortOrder.split(",");
                i(e);
            }
            function i(e) {
                e.sort(function(e, t) {
                    var a = 0;
                    for (var i = 0; i < l.length; i++) {
                        var n = l[i];
                        var r = c[i];
                        var o = x(d).treegrid("getColumnOption", n);
                        var s = o.sorter || function(e, t) {
                            return e == t ? 0 : e > t ? 1 : -1;
                        };
                        a = s(e[n], t[n]) * (r == "asc" ? 1 : -1);
                        if (a != 0) {
                            return a;
                        }
                    }
                    return a;
                });
                for (var t = 0; t < e.length; t++) {
                    var a = e[t].children;
                    if (a && a.length) {
                        i(a);
                    }
                }
            }
        },
        transfer: function(e, t, a) {
            var i = x.data(e, "treegrid").options;
            var n = x.extend([], a);
            var r = l(t, n);
            var o = x.extend([], r);
            while (o.length) {
                var s = o.shift();
                var d = l(s[i.idField], n);
                if (d.length) {
                    if (s.children) {
                        s.children = s.children.concat(d);
                    } else {
                        s.children = d;
                    }
                    o = o.concat(d);
                }
            }
            return r;
            function l(e, t) {
                var a = [];
                for (var i = 0; i < t.length; i++) {
                    var n = t[i];
                    if (n._parentId == e || c(n._parentId, e)) {
                        a.push(n);
                        t.splice(i, 1);
                        i--;
                    }
                }
                return a;
            }
            function c(e, t) {
                return (typeof e == "undefined" || e == null || e == "") && (typeof t == "undefined" || t == null);
            }
        }
    });
    x.fn.treegrid.defaults = x.extend({}, x.fn.datagrid.defaults, {
        treeField: null,
        checkbox: false,
        cascadeCheck: true,
        onlyLeafCheck: false,
        lines: false,
        animate: false,
        singleSelect: true,
        view: Q,
        rowEvents: x.extend({}, x.fn.datagrid.defaults.rowEvents, {
            mouseover: e(true),
            mouseout: e(false),
            click: t
        }),
        loader: function(e, t, a) {
            var i = x(this).treegrid("options");
            if (!i.url) {
                return false;
            }
            x.ajax({
                type: i.method,
                url: i.url,
                data: e,
                dataType: "json",
                success: function(e) {
                    t(e);
                },
                error: function() {
                    a.apply(this, arguments);
                }
            });
        },
        loadFilter: function(e, t) {
            return e;
        },
        finder: {
            getTr: function(e, t, a, i) {
                a = a || "body";
                i = i || 0;
                var n = x.data(e, "datagrid").dc;
                if (i == 0) {
                    var r = x.data(e, "treegrid").options;
                    var o = r.finder.getTr(e, t, a, 1);
                    var s = r.finder.getTr(e, t, a, 2);
                    return o.add(s);
                } else {
                    if (a == "body") {
                        var d = x("#" + x.data(e, "datagrid").rowIdPrefix + "-" + i + "-" + t);
                        if (!d.length) {
                            d = (i == 1 ? n.body1 : n.body2).find('tr[node-id="' + t + '"]');
                        }
                        return d;
                    } else {
                        if (a == "footer") {
                            return (i == 1 ? n.footer1 : n.footer2).find('tr[node-id="' + t + '"]');
                        } else {
                            if (a == "selected") {
                                return (i == 1 ? n.body1 : n.body2).find("tr.datagrid-row-selected");
                            } else {
                                if (a == "highlight") {
                                    return (i == 1 ? n.body1 : n.body2).find("tr.datagrid-row-over");
                                } else {
                                    if (a == "checked") {
                                        return (i == 1 ? n.body1 : n.body2).find("tr.datagrid-row-checked");
                                    } else {
                                        if (a == "last") {
                                            return (i == 1 ? n.body1 : n.body2).find("tr:last[node-id]");
                                        } else {
                                            if (a == "allbody") {
                                                return (i == 1 ? n.body1 : n.body2).find("tr[node-id]");
                                            } else {
                                                if (a == "allfooter") {
                                                    return (i == 1 ? n.footer1 : n.footer2).find("tr[node-id]");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            getRow: function(e, t) {
                var a = typeof t == "object" ? t.attr("node-id") : t;
                return x(e).treegrid("find", a);
            },
            getRows: function(e) {
                return x(e).treegrid("getChildren");
            }
        },
        onBeforeLoad: function(e, t) {},
        onLoadSuccess: function(e, t) {},
        onLoadError: function() {},
        onBeforeCollapse: function(e) {},
        onCollapse: function(e) {},
        onBeforeExpand: function(e) {},
        onExpand: function(e) {},
        onClickRow: function(e) {},
        onDblClickRow: function(e) {},
        onClickCell: function(e, t) {},
        onDblClickCell: function(e, t) {},
        onContextMenu: function(e, t) {},
        onBeforeEdit: function(e) {},
        onAfterEdit: function(e, t) {},
        onCancelEdit: function(e) {},
        onBeforeCheckNode: function(e, t) {},
        onCheckNode: function(e, t) {}
    });
})(jQuery);

(function(u) {
    function i(e, t) {
        var a = u.data(e, "combo");
        var i = a.options;
        var n = a.combo;
        var r = a.panel;
        if (t) {
            i.width = t;
        }
        if (isNaN(i.width)) {
            var o = u(e).clone();
            o.css("visibility", "hidden");
            o.appendTo("body");
            i.width = o.outerWidth();
            o.remove();
        }
        n.appendTo("body");
        var s = n.find("input.combo-text");
        var d = n.find(".combo-arrow");
        var l = i.hasDownArrow ? d._outerWidth() : 0;
        n._outerWidth(i.width)._outerHeight(i.height);
        s._outerWidth(n.width() - l);
        s.css({
            height: n.height() + "px",
            lineHeight: n.height() + "px"
        });
        d._outerHeight(n.height());
        n.insertAfter(e);
    }
    function n(t) {
        u(t).addClass("combo-f").hide();
        var e = u('<span class="combo">' + '<input type="text" class="combo-text" autocomplete="off">' + '<span><span class="combo-arrow"></span></span>' + '<input type="hidden" class="combo-value">' + "</span>").insertAfter(t);
        var a = u('<div class="combo-panel"></div>').appendTo("body");
        a.panel({
            doSize: false,
            closed: true,
            cls: "combo-p",
            style: {
                position: "absolute",
                zIndex: 10
            },
            onOpen: function() {
                var e = u(this).panel("panel");
                if (u.fn.menu) {
                    e.css("z-index", u.fn.menu.defaults.zIndex++);
                } else {
                    if (u.fn.window) {
                        e.css("z-index", u.fn.window.defaults.zIndex++);
                    }
                }
                u(this).panel("resize");
            },
            onBeforeClose: function() {
                d(this);
            },
            onClose: function() {
                var e = u.data(t, "combo");
                if (e) {
                    e.options.onHidePanel.call(t);
                }
            }
        });
        var i = u(t).attr("name");
        if (i) {
            e.find("input.combo-value").attr("name", i);
            u(t).removeAttr("name").attr("comboName", i);
        }
        return {
            combo: e,
            panel: a
        };
    }
    function r(e) {
        var t = u.data(e, "combo");
        var a = t.options;
        var i = t.combo;
        if (a.hasDownArrow) {
            i.find(".combo-arrow").show();
        } else {
            i.find(".combo-arrow").hide();
        }
        c(e, a.disabled);
        f(e, a.readonly);
    }
    function t(e) {
        var t = u.data(e, "combo");
        var a = t.combo.find("input.combo-text");
        a.validatebox("destroy");
        t.panel.panel("destroy");
        t.combo.remove();
        u(e).remove();
    }
    function d(e) {
        u(e).find(".combo-f").each(function() {
            var e = u(this).combo("panel");
            if (e.is(":visible")) {
                e.panel("close");
            }
        });
    }
    function o(a) {
        var i = u.data(a, "combo");
        var n = i.options;
        var r = i.panel;
        var e = i.combo;
        var o = e.find(".combo-text");
        var t = e.find(".combo-arrow");
        u(document).unbind(".combo").bind("mousedown.combo", function(e) {
            var t = u(e.target).closest("span.combo,div.combo-p");
            if (t.length) {
                d(t);
                return;
            }
            u("body>div.combo-p>div.combo-panel:visible").panel("close");
            u(e.target).focus();
        });
        o.unbind(".combo");
        t.unbind(".combo");
        if (!n.disabled && !n.readonly) {
            o.bind("click.combo", function(e) {
                if (!n.editable) {
                    s.call(this);
                } else {
                    var t = u(this).closest("div.combo-panel");
                    u("div.combo-panel:visible").not(r).not(t).panel("close");
                }
            }).bind("keydown.combo paste.combo drop.combo input.combo", function(t) {
                if ("undefined" == typeof t.keyCode) {
                    return;
                }
                switch (t.keyCode) {
                  case 38:
                    n.keyHandler.up.call(a, t);
                    break;

                  case 40:
                    n.keyHandler.down.call(a, t);
                    break;

                  case 37:
                    n.keyHandler.left.call(a, t);
                    break;

                  case 39:
                    n.keyHandler.right.call(a, t);
                    break;

                  case 13:
                    t.preventDefault();
                    n.keyHandler.enter.call(a, t);
                    return false;

                  case 9:
                  case 27:
                    l(a);
                    break;

                  default:
                    if (n.editable) {
                        if (i.timer) {
                            clearTimeout(i.timer);
                        }
                        i.timer = setTimeout(function() {
                            var e = o.val();
                            if (i.previousValue != e) {
                                i.previousValue = e;
                                u(a).combo("showPanel");
                                n.keyHandler.query.call(a, o.val(), t);
                                u(a).combo("validate");
                                n.queryOnFirstArrowDown = false;
                            }
                        }, n.delay);
                    }
                }
            });
            t.bind("click.combo", function() {
                s.call(this);
            }).bind("mouseenter.combo", function() {
                u(this).addClass("combo-arrow-hover");
            }).bind("mouseleave.combo", function() {
                u(this).removeClass("combo-arrow-hover");
            });
        }
        function s() {
            if (r.is(":visible")) {
                l(a);
            } else {
                var e = u(this).closest("div.combo-panel");
                u("div.combo-panel:visible").not(r).not(e).panel("close");
                u(a).combo("showPanel");
                if (n.queryOnFirstArrowDown) {
                    n.keyHandler.query.call(a, o.val());
                    n.queryOnFirstArrowDown = false;
                    u(a).combo("validate");
                }
            }
            o.focus();
        }
    }
    function a(e) {
        var t = u.data(e, "combo");
        var a = t.options;
        var i = t.combo;
        var n = t.panel;
        n.panel("move", {
            left: o(),
            top: s()
        });
        if (n.panel("options").closed) {
            n.panel("open");
            var r = t.combo;
            n.panel("resize", {
                width: a.panelWidth ? a.panelWidth : r.outerWidth(),
                height: a.panelHeight
            });
            if (n.find(".datagrid").length > 0) {
                u.data(e, "combogrid").grid.datagrid("resize", {
                    width: a.panelWidth ? a.panelWidth : r.outerWidth(),
                    height: a.panelHeight
                });
            }
            a.onShowPanel.call(e);
        }
        (function() {
            if (n.is(":visible")) {
                n.panel("move", {
                    left: o(),
                    top: s()
                });
                setTimeout(arguments.callee, 200);
            }
        })();
        function o() {
            var e = i.offset().left;
            if (a.panelAlign == "right") {
                e += i._outerWidth() - n._outerWidth();
            }
            if (e + n._outerWidth() > u(window)._outerWidth() + u(document).scrollLeft()) {
                e = u(window)._outerWidth() + u(document).scrollLeft() - n._outerWidth();
            }
            if (e < 0) {
                e = 0;
            }
            return e;
        }
        function s() {
            var e = i.offset().top + i._outerHeight() - 1;
            if (e + n._outerHeight() > u(window)._outerHeight() + u(document).scrollTop()) {
                e = i.offset().top - n._outerHeight() + 1;
            }
            if (e < u(document).scrollTop()) {
                e = i.offset().top + i._outerHeight() - 1;
            }
            return e;
        }
    }
    function l(e) {
        var t = u.data(e, "combo").panel;
        t.panel("close");
    }
    function s(e) {
        var t = u.data(e, "combo").options;
        var a = u(e).combo("textbox");
        a.validatebox(u.extend({}, t, {
            deltaX: t.hasDownArrow ? t.deltaX : t.deltaX > 0 ? 1 : -1
        }));
    }
    function c(e, t) {
        var a = u.data(e, "combo");
        var i = a.options;
        var n = a.combo;
        if (t) {
            i.disabled = true;
            u(e).attr("disabled", true);
            n.find(".combo-value").attr("disabled", true);
            n.find(".combo-text").attr("disabled", true);
            n.addClass("disabled");
        } else {
            i.disabled = false;
            u(e).removeAttr("disabled");
            n.find(".combo-value").removeAttr("disabled");
            n.find(".combo-text").removeAttr("disabled");
            n.removeClass("disabled");
        }
    }
    function f(e, t) {
        var a = u.data(e, "combo");
        var i = a.options;
        i.readonly = t == undefined ? true : t;
        var n = i.readonly ? true : !i.editable;
        a.combo.find(".combo-text").attr("readonly", n).css("cursor", n ? "pointer" : "");
    }
    function h(e) {
        var t = u.data(e, "combo");
        var a = t.options;
        var i = t.combo;
        if (a.multiple) {
            i.find("input.combo-value").remove();
        } else {
            i.find("input.combo-value").val("");
        }
        i.find("input.combo-text").val("");
    }
    function p(e) {
        var t = u.data(e, "combo").combo;
        return t.find("input.combo-text").val();
    }
    function v(e, t) {
        var a = u.data(e, "combo");
        var i = a.combo.find("input.combo-text");
        if (i.val() != t) {
            i.val(t);
            u(e).combo("validate");
            a.previousValue = t;
        }
    }
    function g(e) {
        var t = [];
        var a = u.data(e, "combo").combo;
        a.find("input.combo-value").each(function() {
            t.push(u(this).val());
        });
        return t;
    }
    function b(e, t) {
        var a = u.data(e, "combo").options;
        var i = g(e);
        var n = u.data(e, "combo").combo;
        n.find("input.combo-value").remove();
        var r = u(e).attr("comboName");
        for (var o = 0; o < t.length; o++) {
            var s = u('<input type="hidden" class="combo-value">').appendTo(n);
            if (r) {
                s.attr("name", r);
            }
            s.val(t[o]);
        }
        var d = [];
        for (var o = 0; o < i.length; o++) {
            d[o] = i[o];
        }
        var l = [];
        for (var o = 0; o < t.length; o++) {
            for (var c = 0; c < d.length; c++) {
                if (t[o] == d[c]) {
                    l.push(t[o]);
                    d.splice(c, 1);
                    break;
                }
            }
        }
        if (l.length != t.length || t.length != i.length) {
            if (a.multiple) {
                a.onChange.call(e, t, i);
            } else {
                a.onChange.call(e, t[0], i[0]);
            }
        }
    }
    function m(e) {
        var t = g(e);
        if (typeof t[0] == "undefined") {
            t[0] = "";
        }
        return t[0];
    }
    function C(e, t) {
        b(e, [ t ]);
    }
    function Y(e) {
        var t = u.data(e, "combo").options;
        var a = t.onChange;
        t.onChange = function() {};
        if (t.multiple) {
            if (t.value) {
                if (typeof t.value == "object") {
                    b(e, t.value);
                } else {
                    C(e, t.value);
                }
            } else {
                b(e, []);
            }
            t.originalValue = g(e);
        } else {
            C(e, t.value);
            t.originalValue = t.value;
        }
        t.onChange = a;
    }
    u.fn.combo = function(a, t) {
        if (typeof a == "string") {
            var e = u.fn.combo.methods[a];
            if (e) {
                return e(this, t);
            } else {
                return this.each(function() {
                    var e = u(this).combo("textbox");
                    e.validatebox(a, t);
                });
            }
        }
        a = a || {};
        return this.each(function() {
            var e = u.data(this, "combo");
            if (e) {
                u.extend(e.options, a);
            } else {
                var t = n(this);
                e = u.data(this, "combo", {
                    options: u.extend({}, u.fn.combo.defaults, u.fn.combo.parseOptions(this), a),
                    combo: t.combo,
                    panel: t.panel,
                    previousValue: null
                });
                u(this).removeAttr("disabled");
            }
            r(this);
            i(this);
            o(this);
            s(this);
            Y(this);
        });
    };
    u.fn.combo.methods = {
        options: function(e) {
            return u.data(e[0], "combo").options;
        },
        panel: function(e) {
            return u.data(e[0], "combo").panel;
        },
        textbox: function(e) {
            return u.data(e[0], "combo").combo.find("input.combo-text");
        },
        destroy: function(e) {
            return e.each(function() {
                t(this);
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                i(this, t);
            });
        },
        showPanel: function(e) {
            return e.each(function() {
                a(this);
            });
        },
        hidePanel: function(e) {
            return e.each(function() {
                l(this);
            });
        },
        disable: function(e) {
            return e.each(function() {
                c(this, true);
                o(this);
            });
        },
        enable: function(e) {
            return e.each(function() {
                c(this, false);
                o(this);
            });
        },
        readonly: function(e, t) {
            return e.each(function() {
                f(this, t);
                o(this);
            });
        },
        isValid: function(e) {
            var t = u.data(e[0], "combo").combo.find("input.combo-text");
            return t.validatebox("isValid");
        },
        clear: function(e) {
            return e.each(function() {
                h(this);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = u.data(this, "combo").options;
                if (e.multiple) {
                    u(this).combo("setValues", e.originalValue);
                } else {
                    u(this).combo("setValue", e.originalValue);
                }
            });
        },
        getText: function(e) {
            return p(e[0]);
        },
        setText: function(e, t) {
            return e.each(function() {
                v(this, t);
            });
        },
        getValues: function(e) {
            return g(e[0]);
        },
        setValues: function(e, t) {
            return e.each(function() {
                b(this, t);
            });
        },
        getValue: function(e) {
            return m(e[0]);
        },
        setValue: function(e, t) {
            return e.each(function() {
                C(this, t);
            });
        }
    };
    u.fn.combo.parseOptions = function(e) {
        var t = u(e);
        return u.extend({}, u.fn.validatebox.parseOptions(e), u.parser.parseOptions(e, [ "blurValidValue", "width", "height", "separator", "panelAlign", {
            panelWidth: "number",
            editable: "boolean",
            hasDownArrow: "boolean",
            delay: "number",
            selectOnNavigation: "boolean"
        } ]), {
            panelHeight: t.attr("panelHeight") == "auto" ? "auto" : parseInt(t.attr("panelHeight")) || undefined,
            multiple: t.attr("multiple") ? true : undefined,
            disabled: t.attr("disabled") ? true : undefined,
            readonly: t.attr("readonly") ? true : undefined,
            value: t.val() || undefined
        });
    };
    u.fn.combo.defaults = u.extend({}, u.fn.validatebox.defaults, {
        blurValidValue: false,
        enterNullValueClear: true,
        width: "auto",
        height: 22,
        panelWidth: null,
        panelHeight: 200,
        panelAlign: "left",
        multiple: false,
        selectOnNavigation: true,
        separator: ",",
        editable: true,
        disabled: false,
        readonly: false,
        hasDownArrow: true,
        value: "",
        delay: 200,
        deltaX: 19,
        keyHandler: {
            up: function(e) {},
            down: function(e) {},
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {},
            query: function(e, t) {}
        },
        onShowPanel: function() {},
        onHidePanel: function() {},
        onChange: function(e, t) {}
    });
})(jQuery);

(function(b) {
    var t = 0;
    function d(e, t) {
        var a = b.data(e, "combobox");
        var i = a.options;
        var n = a.data;
        for (var r = 0; r < n.length; r++) {
            if (n[r][i.valueField] == t) {
                return r;
            }
        }
        return -1;
    }
    function l(e, t) {
        var a = b.data(e, "combobox").options;
        var i = b(e).combo("panel");
        var n = a.finder.getEl(e, t);
        if (n.length) {
            if (n.position().top <= 0) {
                var r = i.scrollTop() + n.position().top;
                i.scrollTop(r);
            } else {
                if (n.position().top + n.outerHeight() > i.height()) {
                    var r = i.scrollTop() + n.position().top + n.outerHeight() - i.height();
                    i.scrollTop(r);
                }
            }
        }
    }
    function a(e, t) {
        var a = b.data(e, "combobox").options;
        var i = b(e).combobox("panel");
        var n = i.children("div.combobox-item-hover");
        if (!n.length) {
            n = i.children("div.combobox-item-selected");
        }
        n.removeClass("combobox-item-hover");
        var r = "div.combobox-item:visible:not(.combobox-item-disabled):first";
        var o = "div.combobox-item:visible:not(.combobox-item-disabled):last";
        if (!n.length) {
            n = i.children(t == "next" ? r : o);
        } else {
            if (t == "next") {
                n = n.nextAll(r);
                if (!n.length) {
                    n = i.children(r);
                }
            } else {
                n = n.prevAll(r);
                if (!n.length) {
                    n = i.children(o);
                }
            }
        }
        if (n.length) {
            n.addClass("combobox-item-hover");
            var s = a.finder.getRow(e, n);
            if (s) {
                l(e, s[a.valueField]);
                if (a.selectOnNavigation) {
                    c(e, s[a.valueField]);
                }
            }
        }
    }
    function c(e, t) {
        var a = b.data(e, "combobox").options;
        var i = b(e).combo("getValues");
        if (b.inArray(t + "", i) == -1) {
            if (a.multiple) {
                i.push(t);
            } else {
                i = [ t ];
            }
            m(e, i);
            a.onSelect.call(e, a.finder.getRow(e, t));
        } else {
            if (a.multiple) {} else {
                if (t) {
                    var n = a.finder.getRow(e, t);
                    if (n) {
                        var r = n[a.textField];
                        if (r !== b(e).combo("getText")) {
                            b(e).combo("setText", r);
                        }
                    }
                }
            }
        }
    }
    function o(e, t) {
        var a = b.data(e, "combobox").options;
        var i = b(e).combo("getValues");
        var n = b.inArray(t + "", i);
        if (n >= 0) {
            i.splice(n, 1);
            m(e, i);
            a.onUnselect.call(e, a.finder.getRow(e, t));
        }
    }
    function m(e, t, a) {
        var i = b.data(e, "combobox").options;
        var n = b(e).combo("panel");
        n.find("div.combobox-item-selected").removeClass("combobox-item-selected");
        var r = [], o = [], s = [];
        for (var d = 0; d < t.length; d++) {
            var l = t[d];
            var c = l;
            if (l != "" && l != undefined && l != null) {
                if (i.finder.getEl(e, l).length > 0) {
                    s.push(l);
                }
            }
            i.finder.getEl(e, l).addClass("combobox-item-selected");
            var u = i.finder.getRow(e, l);
            if (u) {
                c = u[i.textField];
            } else {}
            r.push(l);
            o.push(c);
        }
        b(e).combo("setValues", r);
        if (!a) {
            b(e).combo("setText", o.join(i.separator));
        }
        if (i.rowStyle && i.rowStyle == "checkbox") {
            var f = b.data(e, "combobox").data.length;
            if (s.length == f) {
                n.parent().children("._hisui_combobox-selectall").addClass("checked");
            } else {
                n.parent().children("._hisui_combobox-selectall").removeClass("checked");
            }
        }
    }
    function r(n, e, t) {
        var a = b.data(n, "combobox");
        var r = a.options;
        a.data = r.loadFilter.call(n, e);
        a.groups = [];
        e = a.data;
        var i = b(n).combobox("getValues");
        var o = [];
        var s = undefined;
        for (var d = 0; d < e.length; d++) {
            var l = e[d];
            var c = l[r.valueField] + "";
            var u = l[r.textField];
            var f = l[r.groupField];
            if (f) {
                if (s != f) {
                    s = f;
                    a.groups.push(f);
                    o.push('<div id="' + (a.groupIdPrefix + "_" + (a.groups.length - 1)) + '" class="combobox-group">');
                    o.push(r.groupFormatter ? r.groupFormatter.call(n, f) : f);
                    o.push("</div>");
                }
            } else {
                s = undefined;
            }
            var h = "combobox-item" + (l.disabled ? " combobox-item-disabled" : "") + (f ? " combobox-gitem" : "");
            o.push('<div id="' + (a.itemIdPrefix + "_" + d) + '" class="' + h + '">');
            o.push(r.formatter ? r.formatter.call(n, l) : u);
            o.push("</div>");
            if (l["selected"] && b.inArray(c, i) == -1) {
                i.push(c);
            }
        }
        b(n).combo("panel").html(o.join(""));
        if (r.multiple) {
            m(n, i, t);
            if (r.rowStyle && r.rowStyle == "checkbox") {
                var p = b(n).combo("panel");
                p.closest(".combo-p").children("._hisui_combobox-selectall").remove();
                var v = p.width() - 5;
                var g = b('<div style="width:' + v + 'px" class="_hisui_combobox-selectall"><span class="combobox-checkbox"></span>全选/取消全选</div>').bind("mouseenter", function(e) {
                    b(e.target).closest("div._hisui_combobox-selectall").addClass("combobox-selectall-hover");
                    e.stopPropagation();
                }).bind("mouseleave", function(e) {
                    b(e.target).closest("div._hisui_combobox-selectall").removeClass("combobox-selectall-hover");
                    e.stopPropagation();
                }).bind("click", function(e) {
                    var t = b(this);
                    if (t.hasClass("checked")) {
                        t.removeClass("checked");
                        b(n).combobox("setValues", []);
                    } else {
                        var i = [];
                        t.addClass("checked");
                        var a = b(n).combo("panel");
                        a.find("div.combobox-item").filter(":visible").each(function() {
                            var e = b(this);
                            if (!e.length || e.hasClass("combobox-item-disabled")) {
                                return;
                            }
                            var t = r.finder.getRow(n, e);
                            if (!t) {
                                return;
                            }
                            var a = t[r.valueField];
                            i.push(a);
                        });
                        b(n).combobox("setValues", i);
                    }
                    if (r.onAllSelectClick) {
                        r.onAllSelectClick.call(n, e);
                    }
                });
                if (r.allSelectButtonPosition == "bottom") {
                    g.insertAfter(p);
                    g.parent().addClass("bbtm");
                } else {
                    g.insertBefore(p);
                    g.parent().addClass("btop");
                }
            }
        } else {
            m(n, i.length ? [ i[i.length - 1] ] : [], t);
        }
        r.onLoadSuccess.call(n, e);
    }
    function i(t, e, a, i) {
        var n = b.data(t, "combobox").options;
        if (e) {
            n.url = e;
        }
        a = a || {};
        if (n.onBeforeLoad.call(t, a) == false) {
            return;
        }
        n.loader.call(t, a, function(e) {
            r(t, e, i);
        }, function() {
            n.onLoadError.apply(this, arguments);
        });
    }
    function s(d, e) {
        var l = b.data(d, "combobox");
        var c = l.options;
        if (c.multiple && !e) {
            m(d, [], true);
        } else {
            m(d, [ e ], true);
        }
        if (c.mode == "remote") {
            i(d, null, {
                q: e
            }, true);
        } else {
            var t = b(d).combo("panel");
            t.find("div.combobox-item-selected,div.combobox-item-hover").removeClass("combobox-item-selected combobox-item-hover");
            t.find("div.combobox-item,div.combobox-group").hide();
            var u = l.data;
            var f = [];
            var a = c.multiple ? e.split(c.separator) : [ e ];
            b.map(a, function(e) {
                e = b.trim(e);
                var t = undefined;
                for (var a = 0; a < u.length; a++) {
                    var i = u[a];
                    if (c.filter.call(d, e, i)) {
                        var n = i[c.valueField];
                        var r = i[c.textField];
                        var o = i[c.groupField];
                        var s = c.finder.getEl(d, n).show();
                        if (r.toLowerCase() == e.toLowerCase()) {
                            f.push(n);
                            s.addClass("combobox-item-selected");
                        }
                        if (c.groupField && t != o) {
                            b("#" + l.groupIdPrefix + "_" + b.inArray(o, l.groups)).show();
                            t = o;
                        }
                    }
                }
            });
            m(d, f, true);
            if (f.length > 0) {
                c.onSelect.call(d, c.finder.getRow(d, f[f.length - 1]));
            }
        }
    }
    function n(t) {
        var e = b(t);
        var a = e.combobox("options");
        var i = e.combobox("panel");
        var n = i.children("div.combobox-item-hover");
        if (n.length) {
            var r = a.finder.getRow(t, n);
            var o = r[a.valueField];
            if (a.multiple) {
                if (n.hasClass("combobox-item-selected")) {
                    e.combobox("unselect", o);
                } else {
                    e.combobox("select", o);
                }
            } else {
                e.combobox("select", o);
            }
        }
        var s = [];
        b.map(e.combobox("getValues"), function(e) {
            if (d(t, e) >= 0) {
                s.push(e);
            }
        });
        if (s.length == 0 && !a.enterNullValueClear) {} else {
            e.combobox("setValues", s);
        }
        if (!a.multiple) {
            e.combobox("hidePanel");
        }
    }
    function u(n) {
        var e = b.data(n, "combobox");
        var r = e.options;
        t++;
        e.itemIdPrefix = "_hisui_combobox_i" + t;
        e.groupIdPrefix = "_hisui_combobox_g" + t;
        b(n).addClass("combobox-f");
        b(n).combo(b.extend({}, r, {
            onShowPanel: function() {
                b(n).combo("panel").find("div.combobox-item,div.combobox-group").show();
                l(n, b(n).combobox("getValue"));
                r.onShowPanel.call(n);
            }
        }));
        b(n).combo("panel").unbind().bind("mouseover", function(e) {
            b(this).children("div.combobox-item-hover").removeClass("combobox-item-hover");
            var t = b(e.target).closest("div.combobox-item");
            if (!t.hasClass("combobox-item-disabled")) {
                t.addClass("combobox-item-hover");
            }
            e.stopPropagation();
        }).bind("mouseout", function(e) {
            b(e.target).closest("div.combobox-item").removeClass("combobox-item-hover");
            e.stopPropagation();
        }).bind("click", function(e) {
            var t = b(e.target).closest("div.combobox-item");
            if (!t.length || t.hasClass("combobox-item-disabled")) {
                return;
            }
            var a = r.finder.getRow(n, t);
            if (!a) {
                return;
            }
            var i = a[r.valueField];
            if (r.multiple) {
                if (t.hasClass("combobox-item-selected")) {
                    o(n, i);
                } else {
                    c(n, i);
                }
            } else {
                if (r.allowNull && t.hasClass("combobox-item-selected")) {
                    o(n, i);
                } else {
                    c(n, i);
                    b(n).combo("hidePanel");
                }
            }
            e.stopPropagation();
        });
    }
    b.fn.combobox = function(a, e) {
        if (typeof a == "string") {
            var t = b.fn.combobox.methods[a];
            if (t) {
                return t(this, e);
            } else {
                return this.combo(a, e);
            }
        }
        a = a || {};
        return this.each(function() {
            var e = b.data(this, "combobox");
            if (e) {
                b.extend(e.options, a);
                u(this);
            } else {
                e = b.data(this, "combobox", {
                    options: b.extend({}, b.fn.combobox.defaults, b.fn.combobox.parseOptions(this), a),
                    data: []
                });
                u(this);
                var t = b.fn.combobox.parseData(this);
                if (t.length) {
                    r(this, t);
                }
            }
            if (e.options.data) {
                r(this, e.options.data);
            }
            i(this);
            if (e.options.blurValidValue) {
                e.options.forceValidValue = true;
                var o = this;
                b(o).combo("textbox").bind("blur.combo-text", function(e) {
                    if (b(o).combo("panel").closest(".panel").find(".combobox-selectall-hover").length == 0 && b(o).combo("panel").find(".combobox-item-hover").length == 0) {
                        var t = b(o).combobox("getValue");
                        if (t == undefined || t == "" || t == null) {
                            b(e.target).val("");
                            s(o, "");
                        }
                        var a = 0;
                        var i = b(o).combobox("getData");
                        var n = b(o).combobox("options");
                        for (var r = 0; r < i.length; r++) {
                            if (i[r][n.valueField] == t) {
                                a = 1;
                            }
                        }
                        if (0 == a) {
                            b(e.target).val("");
                            s(o, "");
                        }
                    }
                });
            }
        });
    };
    b.fn.combobox.methods = {
        options: function(e) {
            var t = e.combo("options");
            return b.extend(b.data(e[0], "combobox").options, {
                originalValue: t.originalValue,
                disabled: t.disabled,
                readonly: t.readonly
            });
        },
        getData: function(e) {
            return b.data(e[0], "combobox").data;
        },
        setValues: function(e, t) {
            return e.each(function() {
                m(this, t);
            });
        },
        setValue: function(e, t) {
            return e.each(function() {
                m(this, [ t ]);
            });
        },
        clear: function(e) {
            return e.each(function() {
                b(this).combo("clear");
                var e = b(this).combo("panel");
                e.find("div.combobox-item-selected").removeClass("combobox-item-selected");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = b(this).combobox("options");
                if (e.multiple) {
                    b(this).combobox("setValues", e.originalValue);
                } else {
                    b(this).combobox("setValue", e.originalValue);
                }
            });
        },
        loadData: function(e, t) {
            return e.each(function() {
                r(this, t);
            });
        },
        reload: function(e, t) {
            return e.each(function() {
                i(this, t);
            });
        },
        select: function(e, t) {
            return e.each(function() {
                c(this, t);
            });
        },
        unselect: function(e, t) {
            return e.each(function() {
                o(this, t);
            });
        }
    };
    b.fn.combobox.parseOptions = function(e) {
        var t = b(e);
        return b.extend({}, b.fn.combo.parseOptions(e), b.parser.parseOptions(e, [ "valueField", "textField", "groupField", "mode", "method", "url" ]));
    };
    b.fn.combobox.parseData = function(e) {
        var n = [];
        var r = b(e).combobox("options");
        b(e).children().each(function() {
            if (this.tagName.toLowerCase() == "optgroup") {
                var e = b(this).attr("label");
                b(this).children().each(function() {
                    t(this, e);
                });
            } else {
                t(this);
            }
        });
        return n;
        function t(e, t) {
            var a = b(e);
            var i = {};
            i[r.valueField] = a.attr("value") != undefined ? a.attr("value") : a.text();
            i[r.textField] = a.text();
            i["selected"] = a.is(":selected");
            i["disabled"] = a.is(":disabled");
            if (t) {
                r.groupField = r.groupField || "group";
                i[r.groupField] = t;
            }
            n.push(i);
        }
    };
    b.fn.combobox.defaults = b.extend({}, b.fn.combo.defaults, {
        forceValidValue: false,
        allowNull: false,
        allSelectButtonPosition: "top",
        rowStyle: "",
        valueField: "value",
        textField: "text",
        groupField: null,
        groupFormatter: function(e) {
            return e;
        },
        mode: "local",
        method: "post",
        url: null,
        data: null,
        keyHandler: {
            up: function(e) {
                a(this, "prev");
                e.preventDefault();
            },
            down: function(e) {
                a(this, "next");
                e.preventDefault();
            },
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {
                n(this);
            },
            query: function(e, t) {
                s(this, e);
            }
        },
        filter: function(e, t) {
            var a = b(this).combobox("options");
            return t[a.textField].toLowerCase().indexOf(e.toLowerCase()) == 0;
        },
        formatter: function(e) {
            var t = b(this).combobox("options");
            if (t.rowStyle && t.rowStyle == "checkbox") {
                return "<span class='combobox-checkbox'></span>" + e[t.textField];
            } else {
                return e[t.textField];
            }
        },
        loader: function(e, t, a) {
            var i = b(this).combobox("options");
            if (!i.url) {
                return false;
            }
            b.ajax({
                type: i.method,
                url: i.url,
                data: e,
                dataType: "json",
                success: function(e) {
                    t(e);
                },
                error: function() {
                    a.apply(this, arguments);
                }
            });
        },
        loadFilter: function(e) {
            return e;
        },
        finder: {
            getEl: function(e, t) {
                var a = d(e, t);
                var i = b.data(e, "combobox").itemIdPrefix + "_" + a;
                return b("#" + i);
            },
            getRow: function(e, t) {
                var a = b.data(e, "combobox");
                var i = t instanceof jQuery ? t.attr("id").substr(a.itemIdPrefix.length + 1) : d(e, t);
                return a.data[parseInt(i)];
            }
        },
        onBeforeLoad: function(e) {},
        onLoadSuccess: function() {},
        onLoadError: function() {},
        onSelect: function(e) {},
        onUnselect: function(e) {}
    });
})(jQuery);

(function(f) {
    function i(l) {
        var e = f.data(l, "combotree");
        var c = e.options;
        var u = e.tree;
        f(l).addClass("combotree-f");
        f(l).combo(c);
        var t = f(l).combo("panel");
        if (!u) {
            u = f("<ul></ul>").appendTo(t);
            f.data(l, "combotree").tree = u;
        }
        u.tree(f.extend({}, c, {
            checkbox: c.multiple,
            onLoadSuccess: function(e, t) {
                var a = f(l).combotree("getValues");
                if (c.multiple) {
                    var i = u.tree("getChecked");
                    for (var n = 0; n < i.length; n++) {
                        var r = i[n].id;
                        (function() {
                            for (var e = 0; e < a.length; e++) {
                                if (r == a[e]) {
                                    return;
                                }
                            }
                            a.push(r);
                        })();
                    }
                }
                var o = f(this).tree("options");
                var s = o.onCheck;
                var d = o.onSelect;
                o.onCheck = o.onSelect = function() {};
                f(l).combotree("setValues", a);
                o.onCheck = s;
                o.onSelect = d;
                c.onLoadSuccess.call(this, e, t);
            },
            onClick: function(e) {
                if (c.multiple) {
                    f(this).tree(e.checked ? "uncheck" : "check", e.target);
                } else {
                    f(l).combo("hidePanel");
                }
                a(l);
                c.onClick.call(this, e);
            },
            onCheck: function(e, t) {
                a(l);
                c.onCheck.call(this, e, t);
            }
        }));
    }
    function a(e) {
        var t = f.data(e, "combotree");
        var a = t.options;
        var i = t.tree;
        var n = [], r = [];
        if (a.multiple) {
            var o = i.tree("getChecked");
            for (var s = 0; s < o.length; s++) {
                n.push(o[s].id);
                r.push(o[s].text);
            }
        } else {
            var d = i.tree("getSelected");
            if (d) {
                n.push(d.id);
                r.push(d.text);
            }
        }
        f(e).combo("setValues", n).combo("setText", r.join(a.separator));
    }
    function n(e, t) {
        var a = f.data(e, "combotree").options;
        var i = f.data(e, "combotree").tree;
        i.find("span.tree-checkbox").addClass("tree-checkbox0").removeClass("tree-checkbox1 tree-checkbox2");
        var n = [], r = [];
        for (var o = 0; o < t.length; o++) {
            var s = t[o];
            var d = s;
            var l = i.tree("find", s);
            if (l) {
                d = l.text;
                i.tree("check", l.target);
                i.tree("select", l.target);
            }
            n.push(s);
            r.push(d);
        }
        f(e).combo("setValues", n).combo("setText", r.join(a.separator));
    }
    f.fn.combotree = function(t, e) {
        if (typeof t == "string") {
            var a = f.fn.combotree.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.combo(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = f.data(this, "combotree");
            if (e) {
                f.extend(e.options, t);
            } else {
                f.data(this, "combotree", {
                    options: f.extend({}, f.fn.combotree.defaults, f.fn.combotree.parseOptions(this), t)
                });
            }
            i(this);
        });
    };
    f.fn.combotree.methods = {
        options: function(e) {
            var t = e.combo("options");
            return f.extend(f.data(e[0], "combotree").options, {
                originalValue: t.originalValue,
                disabled: t.disabled,
                readonly: t.readonly
            });
        },
        tree: function(e) {
            return f.data(e[0], "combotree").tree;
        },
        loadData: function(e, a) {
            return e.each(function() {
                var e = f.data(this, "combotree").options;
                e.data = a;
                var t = f.data(this, "combotree").tree;
                t.tree("loadData", a);
            });
        },
        reload: function(e, a) {
            return e.each(function() {
                var e = f.data(this, "combotree").options;
                var t = f.data(this, "combotree").tree;
                if (a) {
                    e.url = a;
                }
                t.tree({
                    url: e.url
                });
            });
        },
        setValues: function(e, t) {
            return e.each(function() {
                n(this, t);
            });
        },
        setValue: function(e, t) {
            return e.each(function() {
                n(this, [ t ]);
            });
        },
        clear: function(e) {
            return e.each(function() {
                var e = f.data(this, "combotree").tree;
                e.find("div.tree-node-selected").removeClass("tree-node-selected");
                var t = e.tree("getChecked");
                for (var a = 0; a < t.length; a++) {
                    e.tree("uncheck", t[a].target);
                }
                f(this).combo("clear");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = f(this).combotree("options");
                if (e.multiple) {
                    f(this).combotree("setValues", e.originalValue);
                } else {
                    f(this).combotree("setValue", e.originalValue);
                }
            });
        }
    };
    f.fn.combotree.parseOptions = function(e) {
        return f.extend({}, f.fn.combo.parseOptions(e), f.fn.tree.parseOptions(e));
    };
    f.fn.combotree.defaults = f.extend({}, f.fn.combo.defaults, f.fn.tree.defaults, {
        editable: false
    });
})(jQuery);

(function(b) {
    function i(n) {
        var r = b.data(n, "combogrid");
        var o = r.options;
        var s = r.grid;
        b(n).addClass("combogrid-f").combo(o);
        var e = b(n).combo("panel");
        if (!s) {
            s = b("<table></table>").appendTo(e);
            r.grid = s;
        }
        if (o.lazy && b(n).combo("getValue") == "") b(n).combo("options").queryOnFirstArrowDown = true;
        s.datagrid(b.extend({}, o, {
            border: false,
            fit: true,
            singleSelect: !o.multiple,
            onLoadSuccess: function(e) {
                var t = b(n).combo("getValues");
                var a = o.onSelect;
                o.onSelect = function() {};
                d(n, t, r.remainText);
                o.onSelect = a;
                o.onLoadSuccess.apply(n, arguments);
            },
            onClickRow: t,
            onSelect: function(e, t) {
                a();
                o.onSelect.call(this, e, t);
            },
            onUnselect: function(e, t) {
                a();
                o.onUnselect.call(this, e, t);
            },
            onSelectAll: function(e) {
                a();
                o.onSelectAll.call(this, e);
            },
            onUnselectAll: function(e) {
                if (o.multiple) {
                    a();
                }
                o.onUnselectAll.call(this, e);
            },
            lazy: o.lazy && b(n).combo("getValue") == ""
        }));
        function t(e, t) {
            r.remainText = false;
            a();
            if (!o.multiple) {
                b(n).combo("hidePanel");
            }
            o.onClickRow.call(this, e, t);
        }
        function a() {
            var e = s.datagrid("getSelections");
            var t = [], a = [];
            for (var i = 0; i < e.length; i++) {
                t.push(e[i][o.idField]);
                a.push(e[i][o.textField]);
            }
            if (!o.multiple) {
                b(n).combo("setValues", t.length ? t : [ "" ]);
            } else {
                b(n).combo("setValues", t);
            }
            if (!r.remainText) {
                b(n).combo("setText", a.join(o.separator));
            }
        }
    }
    function t(e, t) {
        var a = b.data(e, "combogrid");
        var i = a.options;
        var n = a.grid;
        var r = n.datagrid("getRows").length;
        if (!r) {
            return;
        }
        var o = i.finder.getTr(n[0], null, "highlight");
        if (!o.length) {
            o = i.finder.getTr(n[0], null, "selected");
        }
        var s;
        if (!o.length) {
            s = t == "next" ? 0 : r - 1;
        } else {
            var s = parseInt(o.attr("datagrid-row-index"));
            s += t == "next" ? 1 : -1;
            if (s < 0) {
                s = r - 1;
            }
            if (s >= r) {
                s = 0;
            }
        }
        n.datagrid("highlightRow", s);
        if (i.selectOnNavigation) {
            a.remainText = false;
            n.datagrid("selectRow", s);
        }
    }
    function d(e, t, a) {
        var i = b.data(e, "combogrid");
        var n = i.options;
        var r = i.grid;
        var o = r.datagrid("getRows");
        var s = [];
        var d = b(e).combo("getValues");
        var l = b(e).combo("options");
        var c = l.onChange;
        l.onChange = function() {};
        if (t === "") t = [];
        var u = b.map(t, function(e) {
            return String(e);
        });
        var f = b.grep(r.datagrid("getSelections"), function(e, t) {
            return b.inArray(String(e[n.idField]), u) >= 0;
        });
        r.datagrid("clearSelections");
        r.data("datagrid").selectedRows = f;
        for (var h = 0; h < t.length; h++) {
            var p = r.datagrid("getRowIndex", t[h]);
            if (p >= 0) {
                r.datagrid("selectRow", p);
                s.push(o[p][n.textField]);
            } else if (g(t[h], f)) {
                s.push(g(t[h], f));
            } else {
                s.push(t[h]);
            }
        }
        b(e).combo("setValues", d);
        l.onChange = c;
        b(e).combo("setValues", t);
        if (!a) {
            var v = s.join(n.separator);
            if (b(e).combo("getText") != v) {
                b(e).combo("setText", v);
            }
        }
        function g(e, t) {
            var a = b.hisui.getArrayItem(t, n.idField, e);
            return a ? a[n.textField] : undefined;
        }
    }
    function n(i, e) {
        var t = b.data(i, "combogrid");
        var n = t.options;
        var r = t.grid;
        t.remainText = true;
        if (n.multiple && !e) {
            d(i, [], true);
        } else {
            d(i, [ e ], true);
        }
        if (n.mode == "remote") {
            r.datagrid("clearSelections");
            r.datagrid("load", b.extend({}, n.queryParams, {
                q: e
            }));
        } else {
            if (!e) {
                return;
            }
            r.datagrid("clearSelections").datagrid("highlightRow", -1);
            var o = r.datagrid("getRows");
            var a = n.multiple ? e.split(n.separator) : [ e ];
            b.map(a, function(a) {
                a = b.trim(a);
                if (a) {
                    b.map(o, function(e, t) {
                        if (a == e[n.textField]) {
                            r.datagrid("selectRow", t);
                        } else {
                            if (n.filter.call(i, a, e)) {
                                r.datagrid("highlightRow", t);
                            }
                        }
                    });
                }
            });
        }
    }
    function a(e) {
        var t = b.data(e, "combogrid");
        var a = t.options;
        var i = t.grid;
        var n = a.finder.getTr(i[0], null, "highlight");
        t.remainText = false;
        if (n.length) {
            var r = parseInt(n.attr("datagrid-row-index"));
            if (a.multiple) {
                if (n.hasClass("datagrid-row-selected")) {
                    i.datagrid("unselectRow", r);
                } else {
                    i.datagrid("selectRow", r);
                }
            } else {
                i.datagrid("selectRow", r);
            }
        }
        var o = [];
        b.map(i.datagrid("getSelections"), function(e) {
            o.push(e[a.idField]);
        });
        if (o.length == 0 && !a.enterNullValueClear) {} else if (o.length == 1 && a.enterSelectRow) {} else {
            b(e).combogrid("setValues", o);
        }
        if (!a.multiple) {
            b(e).combogrid("hidePanel");
        }
    }
    b.fn.combogrid = function(t, e) {
        if (typeof t == "string") {
            var a = b.fn.combogrid.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.combo(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = b.data(this, "combogrid");
            if (e) {
                b.extend(e.options, t);
            } else {
                e = b.data(this, "combogrid", {
                    options: b.extend({}, b.fn.combogrid.defaults, b.fn.combogrid.parseOptions(this), t)
                });
            }
            i(this);
            if (e.options.blurValidValue) {
                var a = this;
                b(a).combo("textbox").bind("blur.combo-text", function(e) {
                    var t = b(a).combogrid("grid").datagrid("getSelected");
                    if (t == undefined || t == "" || t == null) {
                        b(e.target).val("");
                        n(a, "");
                    }
                });
            }
        });
    };
    b.fn.combogrid.methods = {
        options: function(e) {
            var t = e.combo("options");
            return b.extend(b.data(e[0], "combogrid").options, {
                originalValue: t.originalValue,
                disabled: t.disabled,
                readonly: t.readonly
            });
        },
        grid: function(e) {
            return b.data(e[0], "combogrid").grid;
        },
        setValues: function(e, t) {
            return e.each(function() {
                d(this, t);
            });
        },
        setValue: function(e, t) {
            return e.each(function() {
                d(this, [ t ]);
            });
        },
        clear: function(e) {
            return e.each(function() {
                b(this).combogrid("grid").datagrid("clearSelections");
                b(this).combo("clear");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = b(this).combogrid("options");
                if (e.multiple) {
                    b(this).combogrid("setValues", e.originalValue);
                } else {
                    b(this).combogrid("setValue", e.originalValue);
                }
            });
        }
    };
    b.fn.combogrid.parseOptions = function(e) {
        var t = b(e);
        return b.extend({}, b.fn.combo.parseOptions(e), b.fn.datagrid.parseOptions(e), b.parser.parseOptions(e, [ "idField", "textField", "mode" ]));
    };
    b.fn.combogrid.defaults = b.extend({}, b.fn.combo.defaults, b.fn.datagrid.defaults, {
        enterSelectRow: false,
        loadMsg: null,
        idField: null,
        textField: null,
        mode: "local",
        keyHandler: {
            up: function(e) {
                t(this, "prev");
                e.preventDefault();
            },
            down: function(e) {
                t(this, "next");
                e.preventDefault();
            },
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {
                b.data(this, "combogrid").options.enterSelectRow = true;
                a(this);
                b.data(this, "combogrid").options.enterSelectRow = false;
            },
            query: function(e, t) {
                n(this, e);
            }
        },
        filter: function(e, t) {
            var a = b(this).combogrid("options");
            return t[a.textField].toLowerCase().indexOf(e.toLowerCase()) == 0;
        },
        lazy: false
    });
})(jQuery);

(function(f) {
    function i(l) {
        var c = f.data(l, "datebox");
        var u = c.options;
        f(l).addClass("datebox-f").combo(f.extend({}, u, {
            onShowPanel: function() {
                if (!c.calendar) {
                    e();
                }
                t();
                h(l, f(l).datebox("getText"), true);
                u.onShowPanel.call(l);
            }
        }));
        f(l).combo("textbox").parent().addClass("datebox");
        if (u.allParse) {
            if (!c.calendar) {
                e();
            }
        }
        h(l, u.value);
        f(l).combo("textbox").unbind(".datebox").bind("blur.datebox", function(e) {
            if (f(l).combo("textbox").parent().find(".combo-arrow-hover").length > 0) {
                return;
            }
            if (f.data(l, "datebox").calendar) {
                var t = f.data(l, "datebox").calendar.closest(".panel-body");
                if (t.find(".calendar-hover").length > 0) {
                    return;
                }
                if (t.find(".calendar-nav-hover").length > 0) {
                    return;
                }
            }
            var a = f(l).combo("getText");
            setTimeout(function() {
                u.onBlur(l);
            }, 200);
        });
        function e() {
            var e = f(l).combo("panel").css("overflow", "hidden");
            e.panel("options").onBeforeDestroy = function() {
                var e = f(this).find(".calendar-shared");
                if (e.length) {
                    e.insertBefore(e[0].pholder);
                }
            };
            var t = f('<div class="datebox-calendar-inner"></div>').appendTo(e);
            if (u.sharedCalendar) {
                var a = f(u.sharedCalendar);
                if (!a[0].pholder) {
                    a[0].pholder = f('<div class="calendar-pholder" style="display:none"></div>').insertAfter(a);
                }
                a.addClass("calendar-shared").appendTo(t);
                if (!a.hasClass("calendar")) {
                    a.calendar();
                }
                c.calendar = a;
            } else {
                c.calendar = f("<div></div>").appendTo(t).calendar();
            }
            f.extend(c.calendar.calendar("options"), {
                fit: true,
                border: false,
                onSelect: function(e) {
                    var t = f(this.target).datebox("options");
                    h(this.target, t.formatter.call(this.target, e));
                    f(this.target).combo("hidePanel");
                    t.onSelect.call(l, e);
                },
                validator: function(e, t) {
                    var a = f.data(l, "datebox");
                    var i = a.options;
                    var n = true;
                    if (null != i.minDate) {
                        if (t) t[0] = i.minDate;
                        var r = i.parser.call(l, i.minDate);
                        if (r > e) n = false;
                    }
                    if (null != i.maxDate) {
                        if (t) t[1] = i.maxDate;
                        var o = i.parser.call(l, i.maxDate);
                        if (o < e) n = false;
                    }
                    return n;
                }
            });
            var i = f('<div class="datebox-button"><table cellspacing="0" cellpadding="0" style="width:100%"><tr></tr></table></div>').appendTo(e);
            var n = i.find("tr");
            for (var r = 0; r < u.buttons.length; r++) {
                var o = f("<td></td>").appendTo(n);
                var s = u.buttons[r];
                var d = f('<a href="javascript:void(0)"></a>').html(f.isFunction(s.text) ? s.text(l) : s.text).appendTo(o);
                d.bind("click", {
                    target: l,
                    handler: s.handler
                }, function(e) {
                    e.data.handler.call(this, e.data.target);
                });
            }
            n.find("td").css("width", 100 / u.buttons.length + "%");
        }
        function t() {
            var e = f(l).combo("panel");
            var t = e.children("div.datebox-calendar-inner");
            e.children()._outerWidth(e.width());
            c.calendar.appendTo(t);
            c.calendar[0].target = l;
            if (u.panelHeight != "auto") {
                var a = e.height();
                e.children().not(t).each(function() {
                    a -= f(this).outerHeight();
                });
                t._outerHeight(a);
            }
            c.calendar.calendar("resize");
        }
    }
    function a(e, t) {
        h(e, t, true);
    }
    function n(e) {
        if (!e) return false;
        if (e.charAt(0).toUpperCase() == "T") {
            return true;
        }
        if ("undefined" != typeof dtformat && dtformat == "DMY") {
            var t = e.split("/");
            s = parseInt(t[2], 10);
            d = parseInt(t[1], 10);
            l = parseInt(t[0], 10);
            if (!isNaN(s) && !isNaN(d) && !isNaN(l)) {
                if (d > 12 || l > 31) {
                    return false;
                }
                return true;
            } else {
                return false;
            }
        }
        if (e.charAt(0).toUpperCase() == "T") {
            var t = e.split("-");
            var a = parseInt(t[0], 10);
            var i = parseInt(t[1], 10);
            var n = parseInt(t[2], 10);
            if (!isNaN(a) && !isNaN(i) && !isNaN(n)) {
                e = a + "-" + (i > 9 ? i : "0" + i) + "-" + (n > 9 ? n : "0" + n);
            } else {
                return false;
            }
        }
        var r = /((?!0000)[0-9]{4}((0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-8])|(0[13-9]|1[0-2])(29|30)|(0[13578]|1[02])31)|([0-9]{2}(0[48]|[2468][048]|[13579][26])|(0[48]|[2468][048]|[13579][26])00)0229)/;
        var o = /((?!0000)[0-9]{4}-((0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-8])|(0[13-9]|1[0-2])-(29|30)|(0[13578]|1[02])-31)|([0-9]{2}(0[48]|[2468][048]|[13579][26])|(0[48]|[2468][048]|[13579][26])00)-02-29)/;
        var s = NaN, d = NaN, l = NaN;
        if (r.test(e)) {
            s = parseInt(e.slice(0, 4), 10);
            d = parseInt(e.slice(4, 6));
            l = parseInt(e.slice(6, 8));
        } else if (o.test(e)) {
            var t = e.split("-");
            s = parseInt(t[0], 10);
            d = parseInt(t[1], 10);
            l = parseInt(t[2], 10);
        }
        if (!isNaN(s) && !isNaN(d) && !isNaN(l)) {
            return true;
        } else {
            return false;
        }
    }
    function t(e) {
        var t = f.data(e, "datebox");
        var a = t.options;
        var i;
        if (t.calendar && t.calendar.is(":visible")) {
            i = t.calendar.calendar("options").current;
        }
        if (i) {
            h(e, a.formatter.call(e, i));
            f(e).combo("hidePanel");
        }
    }
    function r(e) {
        f(e).combo("textbox").validatebox("enableValidation");
        if (f(e).combo("textbox").validatebox("isValid")) {
            t(e);
        }
    }
    function h(e, t, a) {
        var i = f.data(e, "datebox");
        var n = i.options;
        f(e).combo("setValue", t);
        var r = i.calendar;
        if (r) {
            r.calendar("moveTo", n.parser.call(e, t));
        }
        if (!a) {
            if (t) {
                if (r) {
                    t = n.formatter.call(e, r.calendar("options").current);
                } else {
                    t = n.formatter.call(e, n.parser.call(e, t));
                }
                f(e).combo("setValue", t).combo("setText", t);
            } else {
                f(e).combo("setText", t);
            }
        }
    }
    f.fn.datebox = function(t, e) {
        if (typeof t == "string") {
            var a = f.fn.datebox.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.combo(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = f.data(this, "datebox");
            if (e) {
                f.extend(e.options, t);
            } else {
                f.data(this, "datebox", {
                    options: f.extend({}, f.fn.datebox.defaults, f.fn.datebox.parseOptions(this), t)
                });
            }
            i(this);
        });
    };
    f.fn.datebox.methods = {
        options: function(e) {
            var t = e.combo("options");
            return f.extend(f.data(e[0], "datebox").options, {
                originalValue: t.originalValue,
                disabled: t.disabled,
                readonly: t.readonly
            });
        },
        calendar: function(e) {
            return f.data(e[0], "datebox").calendar;
        },
        setValue: function(e, t) {
            return e.each(function() {
                h(this, t);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = f(this).datebox("options");
                f(this).datebox("setValue", e.originalValue);
            });
        }
    };
    f.fn.datebox.parseOptions = function(e) {
        return f.extend({}, f.fn.combo.parseOptions(e), f.parser.parseOptions(e, [ "sharedCalendar" ]));
    };
    f.fn.datebox.defaults = f.extend({}, f.fn.combo.defaults, {
        panelWidth: 180,
        panelHeight: "auto",
        sharedCalendar: null,
        keyHandler: {
            up: function(e) {},
            down: function(e) {},
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {
                r(this);
            },
            query: function(e, t) {
                f(this).combo("textbox").validatebox("disableValidation");
                a(this, e);
            }
        },
        currentText: "Today",
        closeText: "Close",
        okText: "Ok",
        buttons: [ {
            text: function(e) {
                return f(e).datebox("options").currentText;
            },
            handler: function(e) {
                f(e).datebox("calendar").calendar({
                    year: new Date().getFullYear(),
                    month: new Date().getMonth() + 1,
                    current: new Date()
                });
                t(e);
            }
        }, {
            text: function(e) {
                return f(e).datebox("options").closeText;
            },
            handler: function(e) {
                f(this).closest("div.combo-panel").panel("close");
            }
        } ],
        formatter: function(e) {
            var t = e.getFullYear();
            var a = e.getMonth() + 1;
            var i = e.getDate();
            return a + "/" + i + "/" + t;
        },
        parser: function(e) {
            var t = Date.parse(e);
            if (!isNaN(t)) {
                return new Date(t);
            } else {
                return new Date();
            }
        },
        onBlur: function(e) {
            r(e);
        },
        onSelect: function(e) {},
        validType: [ 'datebox["YMD"]', "minMaxDate[null,null]" ],
        minDate: null,
        maxDate: null,
        allParse: true
    });
    f.extend(f.fn.datebox.defaults.rules, {
        datebox: {
            validator: function(e, t) {
                if (t == "YMD") {
                    return n(e);
                }
                return true;
            },
            message: "Please enter a valid date."
        },
        minMaxDate: {
            validator: function(e, t) {
                var a = f(this);
                var i = "", n = "";
                if (a.hasClass("dateboxq")) {
                    n = this;
                    i = f.data(n, "dateboxq");
                } else {
                    n = a.closest(".datebox").prev()[0];
                    if (n) {
                        i = f.data(n, "datebox");
                    }
                }
                if (i) {
                    var r = i.options;
                    var o = r.parser.call(n, e);
                    if (r.minDate != null || r.maxDate != null) {
                        if (r.minDate == null && r.rules.minMaxDate.messageMax) {
                            r.rules.minMaxDate.message = r.rules.minMaxDate.messageMax;
                        } else if (r.maxDate == null && r.rules.minMaxDate.messageMin) {
                            r.rules.minMaxDate.message = r.rules.minMaxDate.messageMin;
                        } else {
                            r.rules.minMaxDate.message = r.rules.minMaxDate.messageDef;
                        }
                    } else {
                        r.rules.minMaxDate.message = r.rules.datebox.message;
                    }
                    if (i.calendar) return i.calendar.calendar("options").validator(o, t);
                }
                return true;
            },
            message: "Please enter a valid date.",
            messageDef: "Please enter a valid date."
        }
    });
})(jQuery);

(function(d) {
    function i(t) {
        var e = d.data(t, "datetimebox");
        var a = e.options;
        d(t).datebox(d.extend({}, a, {
            onShowPanel: function() {
                var e = d(t).datetimebox("getValue");
                r(t, e, true);
                a.onShowPanel.call(t);
            },
            formatter: d.fn.datebox.defaults.formatter,
            parser: d.fn.datebox.defaults.parser
        }));
        d(t).removeClass("datebox-f").addClass("datetimebox-f");
        d(t).datebox("calendar").calendar({
            onSelect: function(e) {
                a.onSelect.call(t, e);
            }
        });
        var i = d(t).datebox("panel");
        if (!e.spinner) {
            var n = d('<div style="padding:2px"><input style="width:100px;height:24px"></div>').insertAfter(i.children("div.datebox-calendar-inner"));
            e.spinner = n.children("input");
        }
        e.spinner.timespinner({
            showSeconds: a.showSeconds,
            separator: a.timeSeparator
        }).unbind(".datetimebox").bind("mousedown.datetimebox", function(e) {
            e.stopPropagation();
        });
        r(t, a.value);
    }
    function n(e) {
        var t = d(e).datetimebox("calendar");
        var a = d(e).datetimebox("spinner");
        var i = t.calendar("options").current;
        return new Date(i.getFullYear(), i.getMonth(), i.getDate(), a.timespinner("getHours"), a.timespinner("getMinutes"), a.timespinner("getSeconds"));
    }
    function a(e, t) {
        r(e, t, true);
    }
    function t(e) {
        var t = d.data(e, "datetimebox").options;
        var a = n(e);
        r(e, t.formatter.call(e, a));
        d(e).combo("hidePanel");
    }
    function r(i, e, t) {
        var n = d.data(i, "datetimebox").options;
        d(i).combo("setValue", e);
        if (!t) {
            if (e) {
                var a = n.parser.call(i, e);
                d(i).combo("setValue", n.formatter.call(i, a));
                d(i).combo("setText", n.formatter.call(i, a));
            } else {
                d(i).combo("setText", e);
            }
        }
        var a = n.parser.call(i, e);
        d(i).datetimebox("calendar").calendar("moveTo", a);
        d(i).datetimebox("spinner").timespinner("setValue", r(a));
        function r(e) {
            function t(e) {
                return (e < 10 ? "0" : "") + e;
            }
            var a = [ t(e.getHours()), t(e.getMinutes()) ];
            if (n.showSeconds) {
                a.push(t(e.getSeconds()));
            }
            return a.join(d(i).datetimebox("spinner").timespinner("options").separator);
        }
    }
    d.fn.datetimebox = function(t, e) {
        if (typeof t == "string") {
            var a = d.fn.datetimebox.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return this.datebox(t, e);
            }
        }
        t = t || {};
        return this.each(function() {
            var e = d.data(this, "datetimebox");
            if (e) {
                d.extend(e.options, t);
            } else {
                d.data(this, "datetimebox", {
                    options: d.extend({}, d.fn.datetimebox.defaults, d.fn.datetimebox.parseOptions(this), t)
                });
            }
            i(this);
        });
    };
    d.fn.datetimebox.methods = {
        options: function(e) {
            var t = e.datebox("options");
            return d.extend(d.data(e[0], "datetimebox").options, {
                originalValue: t.originalValue,
                disabled: t.disabled,
                readonly: t.readonly
            });
        },
        spinner: function(e) {
            return d.data(e[0], "datetimebox").spinner;
        },
        setValue: function(e, t) {
            return e.each(function() {
                r(this, t);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = d(this).datetimebox("options");
                d(this).datetimebox("setValue", e.originalValue);
            });
        }
    };
    d.fn.datetimebox.parseOptions = function(e) {
        var t = d(e);
        return d.extend({}, d.fn.datebox.parseOptions(e), d.parser.parseOptions(e, [ "timeSeparator", {
            showSeconds: "boolean"
        } ]));
    };
    d.fn.datetimebox.defaults = d.extend({}, d.fn.datebox.defaults, {
        showSeconds: true,
        timeSeparator: ":",
        keyHandler: {
            up: function(e) {},
            down: function(e) {},
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {
                t(this);
            },
            query: function(e, t) {
                a(this, e);
            }
        },
        buttons: [ {
            text: function(e) {
                return d(e).datetimebox("options").currentText;
            },
            handler: function(e) {
                d(e).datetimebox("calendar").calendar({
                    year: new Date().getFullYear(),
                    month: new Date().getMonth() + 1,
                    current: new Date()
                });
                t(e);
            }
        }, {
            text: function(e) {
                return d(e).datetimebox("options").okText;
            },
            handler: function(e) {
                t(e);
            }
        }, {
            text: function(e) {
                return d(e).datetimebox("options").closeText;
            },
            handler: function(e) {
                d(this).closest("div.combo-panel").panel("close");
            }
        } ],
        formatter: function(e) {
            var t = e.getHours();
            var a = e.getMinutes();
            var i = e.getSeconds();
            function n(e) {
                return (e < 10 ? "0" : "") + e;
            }
            var r = d(this).datetimebox("spinner").timespinner("options").separator;
            var o = d.fn.datebox.defaults.formatter(e) + " " + n(t) + r + n(a);
            if (d(this).datetimebox("options").showSeconds) {
                o += r + n(i);
            }
            return o;
        },
        parser: function(e) {
            if (d.trim(e) == "") {
                return new Date();
            }
            var t = e.split(" ");
            var a = d.fn.datebox.defaults.parser(t[0]);
            if (t.length < 2) {
                return a;
            }
            var i = d(this).datetimebox("spinner").timespinner("options").separator;
            var n = t[1].split(i);
            var r = parseInt(n[0], 10) || 0;
            var o = parseInt(n[1], 10) || 0;
            var s = parseInt(n[2], 10) || 0;
            return new Date(a.getFullYear(), a.getMonth(), a.getDate(), r, o, s);
        },
        onHidePanel: function() {},
        rules: {},
        onBlur: function(e) {}
    });
})(jQuery);

(function($) {
    function init(e) {
        var t = $('<div class="slider">' + '<div class="slider-inner">' + '<a href="javascript:void(0)" class="slider-handle"></a>' + '<span class="slider-tip"></span>' + "</div>" + '<div class="slider-rule"></div>' + '<div class="slider-rulelabel"></div>' + '<div style="clear:both"></div>' + '<input type="hidden" class="slider-value">' + "</div>").insertAfter(e);
        var a = $(e);
        a.addClass("slider-f").hide();
        var i = a.attr("name");
        if (i) {
            t.find("input.slider-value").attr("name", i);
            a.removeAttr("name").attr("sliderName", i);
        }
        return t;
    }
    function setSize(e, t) {
        var a = $.data(e, "slider");
        var i = a.options;
        var n = a.slider;
        if (t) {
            if (t.width) {
                i.width = t.width;
            }
            if (t.height) {
                i.height = t.height;
            }
        }
        if (i.mode == "h") {
            n.css("height", "");
            n.children("div").css("height", "");
            if (!isNaN(i.width)) {
                n.width(i.width);
            }
        } else {
            n.css("width", "");
            n.children("div").css("width", "");
            if (!isNaN(i.height)) {
                n.height(i.height);
                n.find("div.slider-rule").height(i.height);
                n.find("div.slider-rulelabel").height(i.height);
                n.find("div.slider-inner")._outerHeight(i.height);
            }
        }
        initValue(e);
    }
    function showRule(e) {
        var t = $.data(e, "slider");
        var o = t.options;
        var s = t.slider;
        var a = o.mode == "h" ? o.rule : o.rule.slice(0).reverse();
        if (o.reversed) {
            a = a.slice(0).reverse();
        }
        i(a);
        function i(e) {
            var t = s.find("div.slider-rule");
            var a = s.find("div.slider-rulelabel");
            t.empty();
            a.empty();
            for (var i = 0; i < e.length; i++) {
                var n = i * 100 / (e.length - 1) + "%";
                var r = $("<span></span>").appendTo(t);
                r.css(o.mode == "h" ? "left" : "top", n);
                if (e[i] != "|") {
                    r = $("<span></span>").appendTo(a);
                    r.html(e[i]);
                    if (o.mode == "h") {
                        r.css({
                            left: n,
                            marginLeft: -Math.round(r.outerWidth() / 2)
                        });
                    } else {
                        r.css({
                            top: n,
                            marginTop: -Math.round(r.outerHeight() / 2)
                        });
                    }
                }
            }
        }
    }
    function buildSlider(n) {
        var i = $.data(n, "slider");
        var r = i.options;
        var o = i.slider;
        o.removeClass("slider-h slider-v slider-disabled");
        o.addClass(r.mode == "h" ? "slider-h" : "slider-v");
        o.addClass(r.disabled ? "slider-disabled" : "");
        o.find("a.slider-handle").draggable({
            axis: r.mode,
            cursor: "pointer",
            disabled: r.disabled,
            onDrag: function(e) {
                var t = e.data.left;
                var a = o.width();
                if (r.mode != "h") {
                    t = e.data.top;
                    a = o.height();
                }
                if (t < 0 || t > a) {
                    return false;
                } else {
                    var i = pos2value(n, t);
                    s(i);
                    return false;
                }
            },
            onBeforeDrag: function() {
                i.isDragging = true;
            },
            onStartDrag: function() {
                r.onSlideStart.call(n, r.value);
            },
            onStopDrag: function(e) {
                var t = pos2value(n, r.mode == "h" ? e.data.left : e.data.top);
                s(t);
                r.onSlideEnd.call(n, r.value);
                r.onComplete.call(n, r.value);
                i.isDragging = false;
            }
        });
        o.find("div.slider-inner").unbind(".slider").bind("mousedown.slider", function(e) {
            if (i.isDragging) {
                return;
            }
            var t = $(this).offset();
            var a = pos2value(n, r.mode == "h" ? e.pageX - t.left : e.pageY - t.top);
            s(a);
            r.onComplete.call(n, r.value);
        });
        function s(e) {
            var t = Math.abs(e % r.step);
            if (t < r.step / 2) {
                e -= t;
            } else {
                e = e - t + r.step;
            }
            setValue(n, e);
        }
    }
    function setValue(e, t) {
        var a = $.data(e, "slider");
        var i = a.options;
        var n = a.slider;
        var r = i.value;
        if (t < i.min) {
            t = i.min;
        }
        if (t > i.max) {
            t = i.max;
        }
        i.value = t;
        $(e).val(t);
        n.find("input.slider-value").val(t);
        var o = value2pos(e, t);
        var s = n.find(".slider-tip");
        if (i.showTip) {
            s.show();
            s.html(i.tipFormatter.call(e, i.value));
        } else {
            s.hide();
        }
        if (i.mode == "h") {
            var d = "left:" + o + "px;";
            n.find(".slider-handle").attr("style", d);
            s.attr("style", d + "margin-left:" + -Math.round(s.outerWidth() / 2) + "px");
        } else {
            var d = "top:" + o + "px;";
            n.find(".slider-handle").attr("style", d);
            s.attr("style", d + "margin-left:" + -Math.round(s.outerWidth()) + "px");
        }
        if (r != t) {
            i.onChange.call(e, t, r);
        }
    }
    function initValue(e) {
        var t = $.data(e, "slider").options;
        var a = t.onChange;
        t.onChange = function() {};
        setValue(e, t.value);
        t.onChange = a;
    }
    function value2pos(e, t) {
        var a = $.data(e, "slider");
        var i = a.options;
        var n = a.slider;
        var r = i.mode == "h" ? n.width() : n.height();
        var o = i.converter.toPosition.call(e, t, r);
        if (i.mode == "v") {
            o = n.height() - o;
        }
        if (i.reversed) {
            o = r - o;
        }
        return o.toFixed(0);
    }
    function pos2value(e, t) {
        var a = $.data(e, "slider");
        var i = a.options;
        var n = a.slider;
        var r = i.mode == "h" ? n.width() : n.height();
        var o = i.converter.toValue.call(e, i.mode == "h" ? i.reversed ? r - t : t : r - t, r);
        return o.toFixed(0);
    }
    $.fn.slider = function(a, e) {
        if (typeof a == "string") {
            return $.fn.slider.methods[a](this, e);
        }
        a = a || {};
        return this.each(function() {
            var e = $.data(this, "slider");
            if (e) {
                $.extend(e.options, a);
            } else {
                e = $.data(this, "slider", {
                    options: $.extend({}, $.fn.slider.defaults, $.fn.slider.parseOptions(this), a),
                    slider: init(this)
                });
                $(this).removeAttr("disabled");
            }
            var t = e.options;
            t.min = parseFloat(t.min);
            t.max = parseFloat(t.max);
            t.value = parseFloat(t.value);
            t.step = parseFloat(t.step);
            t.originalValue = t.value;
            buildSlider(this);
            showRule(this);
            setSize(this);
        });
    };
    $.fn.slider.methods = {
        options: function(e) {
            return $.data(e[0], "slider").options;
        },
        destroy: function(e) {
            return e.each(function() {
                $.data(this, "slider").slider.remove();
                $(this).remove();
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                setSize(this, t);
            });
        },
        getValue: function(e) {
            return e.slider("options").value;
        },
        setValue: function(e, t) {
            return e.each(function() {
                setValue(this, t);
            });
        },
        clear: function(e) {
            return e.each(function() {
                var e = $(this).slider("options");
                setValue(this, e.min);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = $(this).slider("options");
                setValue(this, e.originalValue);
            });
        },
        enable: function(e) {
            return e.each(function() {
                $.data(this, "slider").options.disabled = false;
                buildSlider(this);
            });
        },
        disable: function(e) {
            return e.each(function() {
                $.data(this, "slider").options.disabled = true;
                buildSlider(this);
            });
        }
    };
    $.fn.slider.parseOptions = function(target) {
        var t = $(target);
        return $.extend({}, $.parser.parseOptions(target, [ "width", "height", "mode", {
            reversed: "boolean",
            showTip: "boolean",
            min: "number",
            max: "number",
            step: "number"
        } ]), {
            value: t.val() || undefined,
            disabled: t.attr("disabled") ? true : undefined,
            rule: t.attr("rule") ? eval(t.attr("rule")) : undefined
        });
    };
    $.fn.slider.defaults = {
        width: "auto",
        height: "auto",
        mode: "h",
        reversed: false,
        showTip: false,
        disabled: false,
        value: 0,
        min: 0,
        max: 100,
        step: 1,
        rule: [],
        tipFormatter: function(e) {
            return e;
        },
        converter: {
            toPosition: function(e, t) {
                var a = $(this).slider("options");
                return (e - a.min) / (a.max - a.min) * t;
            },
            toValue: function(e, t) {
                var a = $(this).slider("options");
                return a.min + (a.max - a.min) * (e / t);
            }
        },
        onChange: function(e, t) {},
        onSlideStart: function(e) {},
        onSlideEnd: function(e) {},
        onComplete: function(e) {}
    };
})(jQuery);

!function(g) {
    "use strict";
    g.fn["bootstrapSwitch"] = function(e) {
        var v = 'input[type!="hidden"]';
        var t = {
            init: function() {
                return this.each(function() {
                    var t = g(this), e, a, i, n, r = t.closest("form"), o = "", s = t.attr("class"), d, l, c = "ON", u = "OFF", f = false, h = false;
                    g.each([ "switch-mini", "switch-small", "switch-large" ], function(e, t) {
                        if (s && s.indexOf(t) >= 0) o = t;
                    });
                    t.addClass("has-switch");
                    if (t.data("on") !== undefined) d = "switch-" + t.data("on");
                    if (t.data("on-label") !== undefined) c = t.data("on-label");
                    if (t.data("off-label") !== undefined) u = t.data("off-label");
                    if (t.data("label-icon") !== undefined) f = t.data("label-icon");
                    if (t.data("text-label") !== undefined) h = t.data("text-label");
                    a = g("<span>").addClass("switch-left").addClass(o).addClass(d).html(c);
                    d = "";
                    if (t.data("off") !== undefined) d = "switch-" + t.data("off");
                    i = g("<span>").addClass("switch-right").addClass(o).addClass(d).html(u);
                    n = g("<label>").html("&nbsp;").addClass(o).attr("for", t.find(v).attr("id"));
                    if (f) {
                        n.html('<i class="icon ' + f + '"></i>');
                    }
                    if (h) {
                        n.html("" + h + "");
                    }
                    e = t.find(v).wrap(g("<div>")).parent().data("animated", false);
                    if (t.data("animated") !== false) e.addClass("switch-animate").data("animated", true);
                    e.append(a).append(n).append(i);
                    t.find(">div").addClass(t.find(v).is(":checked") ? "switch-on" : "switch-off");
                    if (t.find(v).is(":disabled")) g(this).addClass("deactivate");
                    var p = function(e) {
                        if (t.parent("label").is(".label-change-switch")) {} else {
                            e.siblings("label").trigger("mousedown").trigger("mouseup").trigger("click");
                        }
                    };
                    t.on("keydown", function(e) {
                        if (e.keyCode === 32) {
                            e.stopImmediatePropagation();
                            e.preventDefault();
                            p(g(e.target).find("span:first"));
                        }
                    });
                    a.on("click", function(e) {
                        p(g(this));
                    });
                    i.on("click", function(e) {
                        p(g(this));
                    });
                    t.find(v).on("change", function(e, t) {
                        var a = g(this), i = a.parent(), n = a.is(":checked"), r = i.is(".switch-off");
                        e.preventDefault();
                        i.css("left", "");
                        if (r === n) {
                            if (n) i.removeClass("switch-off").addClass("switch-on"); else i.removeClass("switch-on").addClass("switch-off");
                            if (i.data("animated") !== false) i.addClass("switch-animate");
                            if (typeof t === "boolean" && t) return;
                            i.parent().trigger("switch-change", {
                                el: a,
                                value: n
                            });
                        }
                    });
                    t.find("label").on("mousedown touchstart", function(e) {
                        var t = g(this);
                        l = false;
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        t.closest("div").removeClass("switch-animate");
                        if (t.closest(".has-switch").is(".deactivate")) {
                            t.unbind("click");
                        } else if (t.closest(".switch-on").parent().is(".radio-no-uncheck")) {
                            t.unbind("click");
                        } else {
                            t.on("mousemove touchmove", function(e) {
                                var t = g(this).closest(".make-switch");
                                if (t.length == 0) return;
                                var a = (e.pageX || e.originalEvent.targetTouches[0].pageX) - t.offset().left, i = a / t.width() * 100, n = 25, r = 75;
                                l = true;
                                if (i < n) i = n; else if (i > r) i = r;
                                t.find(">div").css("left", i - r + "%");
                            });
                            t.on("click touchend", function(e) {
                                var t = g(this), a = g(e.target), i = a.siblings("input");
                                e.stopImmediatePropagation();
                                e.preventDefault();
                                t.unbind("mouseleave");
                                if (l) i.prop("checked", !(parseInt(t.parent().css("left")) < -25)); else i.prop("checked", !i.is(":checked"));
                                l = false;
                                i.trigger("change");
                            });
                            t.on("mouseleave", function(e) {
                                var t = g(this), a = t.siblings("input");
                                e.preventDefault();
                                e.stopImmediatePropagation();
                                t.unbind("mouseleave");
                                t.trigger("mouseup");
                                a.prop("checked", !(parseInt(t.parent().css("left")) < -25)).trigger("change");
                            });
                            t.on("mouseup", function(e) {
                                e.stopImmediatePropagation();
                                e.preventDefault();
                                g(this).unbind("mousemove");
                            });
                        }
                    });
                    if (r.data("bootstrapSwitch") !== "injected") {
                        r.bind("reset", function() {
                            setTimeout(function() {
                                r.find(".make-switch").each(function() {
                                    var e = g(this).find(v);
                                    e.prop("checked", e.is(":checked")).trigger("change");
                                });
                            }, 1);
                        });
                        r.data("bootstrapSwitch", "injected");
                    }
                });
            },
            toggleActivation: function() {
                var e = g(this);
                e.toggleClass("deactivate");
                e.find(v).prop("disabled", e.is(".deactivate"));
            },
            isActive: function() {
                return !g(this).hasClass("deactivate");
            },
            setActive: function(e) {
                var t = g(this);
                if (e) {
                    t.removeClass("deactivate");
                    t.find(v).removeAttr("disabled");
                } else {
                    t.addClass("deactivate");
                    t.find(v).attr("disabled", "disabled");
                }
            },
            toggleState: function(e) {
                var t = g(this).find(":checkbox");
                t.prop("checked", !t.is(":checked")).trigger("change", e);
            },
            toggleRadioState: function(e) {
                var t = g(this).find(":radio");
                t.not(":checked").prop("checked", !t.is(":checked")).trigger("change", e);
            },
            toggleRadioStateAllowUncheck: function(e, t) {
                var a = g(this).find(":radio");
                if (e) {
                    a.not(":checked").trigger("change", t);
                } else {
                    a.not(":checked").prop("checked", !a.is(":checked")).trigger("change", t);
                }
            },
            setState: function(e, t) {
                g(this).find(v).prop("checked", e).trigger("change", t);
            },
            setOnLabel: function(e) {
                var t = g(this).find(".switch-left");
                t.html(e);
            },
            setOffLabel: function(e) {
                var t = g(this).find(".switch-right");
                t.html(e);
            },
            setOnClass: function(e) {
                var t = g(this).find(".switch-left");
                var a = "";
                if (e !== undefined) {
                    if (g(this).attr("data-on") !== undefined) {
                        a = "switch-" + g(this).attr("data-on");
                    }
                    t.removeClass(a);
                    a = "switch-" + e;
                    t.addClass(a);
                }
            },
            setOffClass: function(e) {
                var t = g(this).find(".switch-right");
                var a = "";
                if (e !== undefined) {
                    if (g(this).attr("data-off") !== undefined) {
                        a = "switch-" + g(this).attr("data-off");
                    }
                    t.removeClass(a);
                    a = "switch-" + e;
                    t.addClass(a);
                }
            },
            setAnimated: function(e) {
                var t = g(this).find(v).parent();
                if (e === undefined) e = false;
                t.data("animated", e);
                t.attr("data-animated", e);
                if (t.data("animated") !== false) {
                    t.addClass("switch-animate");
                } else {
                    t.removeClass("switch-animate");
                }
            },
            setSizeClass: function(a) {
                var e = g(this);
                var i = e.find(".switch-left");
                var n = e.find(".switch-right");
                var r = e.find("label");
                g.each([ "switch-mini", "switch-small", "switch-large" ], function(e, t) {
                    if (t !== a) {
                        i.removeClass(t);
                        n.removeClass(t);
                        r.removeClass(t);
                    } else {
                        i.addClass(t);
                        n.addClass(t);
                        r.addClass(t);
                    }
                });
            },
            status: function() {
                return g(this).find(v).is(":checked");
            },
            destroy: function() {
                var e = g(this), t = e.find("div"), a = e.closest("form"), i;
                t.find(":not(input)").remove();
                i = t.children();
                i.unwrap().unwrap();
                i.unbind("change");
                if (a) {
                    a.unbind("reset");
                    a.removeData("bootstrapSwitch");
                }
                return i;
            }
        };
        if (t[e]) return t[e].apply(this, Array.prototype.slice.call(arguments, 1)); else if (typeof e === "object" || !e) return t.init.apply(this, arguments); else g.error("Method " + e + " does not exist!");
    };
}(jQuery);

!function(c, w, Y) {
    "use strict";
    !function(e) {
        "function" == typeof define && define.amd ? define([ "jquery" ], e) : "object" == typeof exports ? module.exports = e(require("jquery")) : e(c.jQuery);
    }(function(v) {
        function n(e, t) {
            return this.$element = v(e), t && ("string" === v.type(t.delay) || "number" === v.type(t.delay)) && (t.delay = {
                show: t.delay,
                hide: t.delay
            }), this.options = v.extend({}, l, t), this._defaults = l, this._name = d, this._targetclick = !1, 
            this.init(), u.push(this.$element), this;
        }
        var d = "webuiPopover", g = "webui-popover", b = "webui.popover", l = {
            placement: "auto",
            container: null,
            width: "auto",
            height: "auto",
            trigger: "click",
            style: "",
            selector: !1,
            delay: {
                show: null,
                hide: 300
            },
            async: {
                type: "GET",
                before: null,
                success: null,
                error: null
            },
            cache: !0,
            multi: !1,
            arrow: !0,
            title: "",
            content: "",
            closeable: !1,
            padding: !0,
            url: "",
            type: "html",
            direction: "",
            animation: null,
            template: '<div class="webui-popover"><div class="webui-arrow"></div><div class="webui-popover-inner"><a href="#" class="close"></a><h3 class="webui-popover-title"></h3><div class="webui-popover-content"><i class="icon-refresh"></i> <p>&nbsp;</p></div></div></div>',
            backdrop: !1,
            dismissible: !0,
            onShow: null,
            onHide: null,
            abortXHR: !0,
            autoHide: !1,
            offsetTop: 0,
            offsetLeft: 0,
            iframeOptions: {
                frameborder: "0",
                allowtransparency: "true",
                id: "",
                name: "",
                scrolling: "",
                onload: "",
                height: "",
                width: ""
            },
            hideEmpty: !1
        }, m = g + "-rtl", u = [], r = v('<div class="webui-popover-backdrop"></div>'), e = 0, f = !1, S = -2e3, i = v(w), t = function(e, t) {
            return isNaN(e) ? t || 0 : Number(e);
        }, h = function(e) {
            return e.data("plugin_" + d);
        }, p = function() {
            for (var e = null, t = 0; t < u.length; t++) e = h(u[t]), e && e.hide(!0);
            i.trigger("hiddenAll." + b);
        }, a = function(e) {
            for (var t = null, a = 0; a < u.length; a++) t = h(u[a]), t && t.id !== e.id && t.hide(!0);
            i.trigger("hiddenAll." + b);
        }, o = "ontouchstart" in w.documentElement && /Mobi/.test(navigator.userAgent), C = function(e) {
            var t = {
                x: 0,
                y: 0
            };
            if ("touchstart" === e.type || "touchmove" === e.type || "touchend" === e.type || "touchcancel" === e.type) {
                var a = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0];
                t.x = a.pageX, t.y = a.pageY;
            } else ("mousedown" === e.type || "mouseup" === e.type || "click" === e.type) && (t.x = e.pageX, 
            t.y = e.pageY);
            return t;
        };
        n.prototype = {
            init: function() {
                if (this.$element[0] instanceof w.constructor && !this.options.selector) throw new Error("`selector` option must be specified when initializing " + this.type + " on the window.document object!");
                "manual" !== this.getTrigger() && (o ? this.$element.off("touchend", this.options.selector).on("touchend", this.options.selector, v.proxy(this.toggle, this)) : "click" === this.getTrigger() ? this.$element.off("click", this.options.selector).on("click", this.options.selector, v.proxy(this.toggle, this)) : "hover" === this.getTrigger() && this.$element.off("mouseenter mouseleave click", this.options.selector).on("mouseenter", this.options.selector, v.proxy(this.mouseenterHandler, this)).on("mouseleave", this.options.selector, v.proxy(this.mouseleaveHandler, this))), 
                this._poped = !1, this._inited = !0, this._opened = !1, this._idSeed = e, this.id = d + this._idSeed, 
                this.options.container = v(this.options.container || w.body).first(), this.options.backdrop && r.appendTo(this.options.container).hide(), 
                e++, "sticky" === this.getTrigger() && this.show(), this.options.selector && (this._options = v.extend({}, this.options, {
                    selector: ""
                }));
            },
            destroy: function() {
                for (var e = -1, t = 0; t < u.length; t++) if (u[t] === this.$element) {
                    e = t;
                    break;
                }
                u.splice(e, 1), this.hide(), this.$element.data("plugin_" + d, null), "click" === this.getTrigger() ? this.$element.off("click") : "hover" === this.getTrigger() && this.$element.off("mouseenter mouseleave"), 
                this.$target && this.$target.remove();
            },
            getDelegateOptions: function() {
                var a = {};
                return this._options && v.each(this._options, function(e, t) {
                    l[e] !== t && (a[e] = t);
                }), a;
            },
            hide: function(e, t) {
                if ((e || "sticky" !== this.getTrigger()) && this._opened) {
                    t && (t.preventDefault(), t.stopPropagation()), this.xhr && this.options.abortXHR === !0 && (this.xhr.abort(), 
                    this.xhr = null);
                    var a = v.Event("hide." + b);
                    if (this.$element.trigger(a, [ this.$target ]), this.$target) {
                        this.$target.removeClass("in").addClass(this.getHideAnimation());
                        var i = this;
                        setTimeout(function() {
                            i.$target.hide(), i.getCache() || i.$target.remove();
                        }, i.getHideDelay());
                    }
                    this.options.backdrop && r.hide(), this._opened = !1, this.$element.trigger("hidden." + b, [ this.$target ]), 
                    this.options.onHide && this.options.onHide(this.$target);
                }
            },
            resetAutoHide: function() {
                var e = this, t = e.getAutoHide();
                t && (e.autoHideHandler && clearTimeout(e.autoHideHandler), e.autoHideHandler = setTimeout(function() {
                    e.hide();
                }, t));
            },
            delegate: function(e) {
                var t = v(e).data("plugin_" + d);
                return t || (t = new n(e, this.getDelegateOptions()), v(e).data("plugin_" + d, t)), 
                t;
            },
            toggle: function(e) {
                var t = this;
                e && (e.preventDefault(), e.stopPropagation(), this.options.selector && (t = this.delegate(e.currentTarget))), 
                t[t.getTarget().hasClass("in") ? "hide" : "show"]();
            },
            hideAll: function() {
                p();
            },
            hideOthers: function() {
                a(this);
            },
            show: function() {
                if (!this._opened) {
                    var e = this.getTarget().removeClass().addClass(g).addClass(this._customTargetClass);
                    if (this.options.multi || this.hideOthers(), !this.getCache() || !this._poped || "" === this.content) {
                        if (this.content = "", this.setTitle(this.getTitle()), this.options.closeable || e.find(".close").off("click").remove(), 
                        this.isAsync() ? this.setContentASync(this.options.content) : this.setContent(this.getContent()), 
                        this.canEmptyHide() && "" === this.content) return;
                        e.show();
                    }
                    this.displayContent(), this.options.onShow && this.options.onShow(e), this.bindBodyEvents(), 
                    this.options.backdrop && r.show(), this._opened = !0, this.resetAutoHide();
                }
            },
            displayContent: function() {
                var e = this.getElementPosition(), t = this.getTarget().removeClass().addClass(g).addClass(this._customTargetClass), a = this.getContentElement(), i = t[0].offsetWidth, n = t[0].offsetHeight, r = "bottom", o = v.Event("show." + b);
                if (this.canEmptyHide()) {
                    var s = a.children().html();
                    if (null !== s && 0 === s.trim().length) return;
                }
                this.$element.trigger(o, [ t ]);
                var d = this.$element.data("width") || this.options.width;
                "" === d && (d = this._defaults.width), "auto" !== d && t.width(d);
                var l = this.$element.data("height") || this.options.height;
                "" === l && (l = this._defaults.height), "auto" !== l && a.height(l), this.options.style && this.$target.addClass(g + "-" + this.options.style), 
                "rtl" !== this.options.direction || a.hasClass(m) || a.addClass(m), this.options.arrow || t.find(".webui-arrow").remove(), 
                t.detach().css({
                    top: S,
                    left: S,
                    display: "block"
                }), this.getAnimation() && t.addClass(this.getAnimation()), t.appendTo(this.options.container), 
                r = this.getPlacement(e), this.$element.trigger("added." + b), this.initTargetEvents(), 
                this.options.padding || ("auto" !== this.options.height && a.css("height", a.outerHeight()), 
                this.$target.addClass("webui-no-padding")), this.options.maxHeight && a.css("maxHeight", this.options.maxHeight), 
                this.options.maxWidth && a.css("maxWidth", this.options.maxWidth), i = t[0].offsetWidth, 
                n = t[0].offsetHeight;
                var c = this.getTargetPositin(e, r, i, n);
                if (this.$target.css(c.position).addClass(r).addClass("in"), "iframe" === this.options.type) {
                    var u = t.find("iframe"), f = t.width(), h = u.parent().height();
                    "" !== this.options.iframeOptions.width && "auto" !== this.options.iframeOptions.width && (f = this.options.iframeOptions.width), 
                    "" !== this.options.iframeOptions.height && "auto" !== this.options.iframeOptions.height && (h = this.options.iframeOptions.height), 
                    u.width(f).height(h);
                }
                if (this.options.arrow || this.$target.css({
                    margin: 0
                }), this.options.arrow) {
                    var p = this.$target.find(".webui-arrow");
                    p.removeAttr("style"), "left" === r || "right" === r ? p.css({
                        top: this.$target.height() / 2
                    }) : ("top" === r || "bottom" === r) && p.css({
                        left: this.$target.width() / 2
                    }), c.arrowOffset && (-1 === c.arrowOffset.left || -1 === c.arrowOffset.top ? p.hide() : p.css(c.arrowOffset));
                }
                this._poped = !0, this.$element.trigger("shown." + b, [ this.$target ]);
            },
            isTargetLoaded: function() {
                return 0 === this.getTarget().find("i.glyphicon-refresh").length;
            },
            getTriggerElement: function() {
                return this.$element;
            },
            getTarget: function() {
                if (!this.$target) {
                    var e = d + this._idSeed;
                    this.$target = v(this.options.template).attr("id", e), this._customTargetClass = this.$target.attr("class") !== g ? this.$target.attr("class") : null, 
                    this.getTriggerElement().attr("data-target", e);
                }
                return this.$target.data("trigger-element") || this.$target.data("trigger-element", this.getTriggerElement()), 
                this.$target;
            },
            removeTarget: function() {
                this.$target.remove(), this.$target = null, this.$contentElement = null;
            },
            getTitleElement: function() {
                return this.getTarget().find("." + g + "-title");
            },
            getContentElement: function() {
                return this.$contentElement || (this.$contentElement = this.getTarget().find("." + g + "-content")), 
                this.$contentElement;
            },
            getTitle: function() {
                return this.$element.attr("data-title") || this.options.title || this.$element.attr("title");
            },
            getUrl: function() {
                return this.$element.attr("data-url") || this.options.url;
            },
            getAutoHide: function() {
                return this.$element.attr("data-auto-hide") || this.options.autoHide;
            },
            getOffsetTop: function() {
                return t(this.$element.attr("data-offset-top")) || this.options.offsetTop;
            },
            getOffsetLeft: function() {
                return t(this.$element.attr("data-offset-left")) || this.options.offsetLeft;
            },
            getCache: function() {
                var e = this.$element.attr("data-cache");
                if ("undefined" != typeof e) switch (e.toLowerCase()) {
                  case "true":
                  case "yes":
                  case "1":
                    return !0;

                  case "false":
                  case "no":
                  case "0":
                    return !1;
                }
                return this.options.cache;
            },
            getTrigger: function() {
                return this.$element.attr("data-trigger") || this.options.trigger;
            },
            getDelayShow: function() {
                var e = this.$element.attr("data-delay-show");
                return "undefined" != typeof e ? e : 0 === this.options.delay.show ? 0 : this.options.delay.show || 100;
            },
            getHideDelay: function() {
                var e = this.$element.attr("data-delay-hide");
                return "undefined" != typeof e ? e : 0 === this.options.delay.hide ? 0 : this.options.delay.hide || 100;
            },
            getAnimation: function() {
                var e = this.$element.attr("data-animation");
                return e || this.options.animation;
            },
            getHideAnimation: function() {
                var e = this.getAnimation();
                return e ? e + "-out" : "out";
            },
            setTitle: function(e) {
                var t = this.getTitleElement();
                e ? ("rtl" !== this.options.direction || t.hasClass(m) || t.addClass(m), t.html(e)) : t.remove();
            },
            hasContent: function() {
                return this.getContent();
            },
            canEmptyHide: function() {
                return this.options.hideEmpty && "html" === this.options.type;
            },
            getIframe: function() {
                var t = v("<iframe></iframe>").attr("src", this.getUrl()), a = this;
                return v.each(this._defaults.iframeOptions, function(e) {
                    "undefined" != typeof a.options.iframeOptions[e] && t.attr(e, a.options.iframeOptions[e]);
                }), t;
            },
            getContent: function() {
                if (this.getUrl()) switch (this.options.type) {
                  case "iframe":
                    this.content = this.getIframe();
                    break;

                  case "html":
                    try {
                        this.content = v(this.getUrl()), this.content.is(":visible") || this.content.show();
                    } catch (c) {
                        throw new Error("Unable to get popover content. Invalid selector specified.");
                    }
                } else if (!this.content) {
                    var e = "";
                    if (e = v.isFunction(this.options.content) ? this.options.content.apply(this.$element[0], [ this ]) : this.options.content, 
                    this.content = this.$element.attr("data-content") || e, !this.content) {
                        var t = this.$element.next();
                        t && t.hasClass(g + "-content") && (this.content = t);
                    }
                }
                return this.content;
            },
            setContent: function(e) {
                var t = this.getTarget(), a = this.getContentElement();
                "string" == typeof e ? a.html(e) : e instanceof v && (a.html(""), this.options.cache ? e.removeClass(g + "-content").appendTo(a) : e.clone(!0, !0).removeClass(g + "-content").appendTo(a)), 
                this.$target = t;
            },
            isAsync: function() {
                return "async" === this.options.type;
            },
            setContentASync: function(a) {
                var i = this;
                this.xhr || (this.xhr = v.ajax({
                    url: this.getUrl(),
                    type: this.options.async.type,
                    cache: this.getCache(),
                    beforeSend: function(e, t) {
                        i.options.async.before && i.options.async.before(i, e, t);
                    },
                    success: function(e) {
                        i.bindBodyEvents(), a && v.isFunction(a) ? i.content = a.apply(i.$element[0], [ e ]) : i.content = e, 
                        i.setContent(i.content);
                        var t = i.getContentElement();
                        t.removeAttr("style"), i.displayContent(), i.options.async.success && i.options.async.success(i, e);
                    },
                    complete: function() {
                        i.xhr = null;
                    },
                    error: function(e, t) {
                        i.options.async.error && i.options.async.error(i, e, t);
                    }
                }));
            },
            bindBodyEvents: function() {
                f || (this.options.dismissible && "click" === this.getTrigger() ? o ? i.off("touchstart.webui-popover").on("touchstart.webui-popover", v.proxy(this.bodyTouchStartHandler, this)) : (i.off("keyup.webui-popover").on("keyup.webui-popover", v.proxy(this.escapeHandler, this)), 
                i.off("click.webui-popover").on("click.webui-popover", v.proxy(this.bodyClickHandler, this))) : "hover" === this.getTrigger() && i.off("touchend.webui-popover").on("touchend.webui-popover", v.proxy(this.bodyClickHandler, this)));
            },
            mouseenterHandler: function(e) {
                var t = this;
                e && this.options.selector && (t = this.delegate(e.currentTarget)), t._timeout && clearTimeout(t._timeout), 
                t._enterTimeout = setTimeout(function() {
                    t.getTarget().is(":visible") || t.show();
                }, this.getDelayShow());
            },
            mouseleaveHandler: function() {
                var e = this;
                clearTimeout(e._enterTimeout), e._timeout = setTimeout(function() {
                    e.hide();
                }, this.getHideDelay());
            },
            escapeHandler: function(e) {
                27 === e.keyCode && this.hideAll();
            },
            bodyTouchStartHandler: function(e) {
                var t = this, a = v(e.currentTarget);
                a.on("touchend", function(e) {
                    t.bodyClickHandler(e), a.off("touchend");
                }), a.on("touchmove", function() {
                    a.off("touchend");
                });
            },
            bodyClickHandler: function(e) {
                f = !0;
                for (var t = !0, a = 0; a < u.length; a++) {
                    var i = h(u[a]);
                    if (i && i._opened) {
                        var n = i.getTarget().offset(), r = n.left, o = n.top, s = n.left + i.getTarget().width(), d = n.top + i.getTarget().height(), l = C(e), c = l.x >= r && l.x <= s && l.y >= o && l.y <= d;
                        if (c) {
                            t = !1;
                            break;
                        }
                    }
                }
                t && p();
            },
            initTargetEvents: function() {
                "hover" === this.getTrigger() && this.$target.off("mouseenter mouseleave").on("mouseenter", v.proxy(this.mouseenterHandler, this)).on("mouseleave", v.proxy(this.mouseleaveHandler, this)), 
                this.$target.find(".close").off("click").on("click", v.proxy(this.hide, this, !0));
            },
            getPlacement: function(e) {
                var t, a = this.options.container, i = a.innerWidth(), n = a.innerHeight(), r = a.scrollTop(), o = a.scrollLeft(), s = Math.max(0, e.left - o), d = Math.max(0, e.top - r);
                t = "function" == typeof this.options.placement ? this.options.placement.call(this, this.getTarget()[0], this.$element[0]) : this.$element.data("placement") || this.options.placement;
                var l = "horizontal" === t, c = "vertical" === t, u = "auto" === t || l || c;
                return u ? t = i / 3 > s ? n / 3 > d ? l ? "right-bottom" : "bottom-right" : 2 * n / 3 > d ? c ? n / 2 >= d ? "bottom-right" : "top-right" : "right" : l ? "right-top" : "top-right" : 2 * i / 3 > s ? n / 3 > d ? l ? i / 2 >= s ? "right-bottom" : "left-bottom" : "bottom" : 2 * n / 3 > d ? l ? i / 2 >= s ? "right" : "left" : n / 2 >= d ? "bottom" : "top" : l ? i / 2 >= s ? "right-top" : "left-top" : "top" : n / 3 > d ? l ? "left-bottom" : "bottom-left" : 2 * n / 3 > d ? c ? n / 2 >= d ? "bottom-left" : "top-left" : "left" : l ? "left-top" : "top-left" : "auto-top" === t ? t = i / 3 > s ? "top-right" : 2 * i / 3 > s ? "top" : "top-left" : "auto-bottom" === t ? t = i / 3 > s ? "bottom-right" : 2 * i / 3 > s ? "bottom" : "bottom-left" : "auto-left" === t ? t = n / 3 > d ? "left-top" : 2 * n / 3 > d ? "left" : "left-bottom" : "auto-right" === t && (t = n / 3 > d ? "right-bottom" : 2 * n / 3 > d ? "right" : "right-top"), 
                t;
            },
            getElementPosition: function() {
                var e = this.$element[0].getBoundingClientRect(), t = this.options.container, a = t.css("position");
                if (t.is(w.body) || "static" === a) return v.extend({}, this.$element.offset(), {
                    width: this.$element[0].offsetWidth || e.width,
                    height: this.$element[0].offsetHeight || e.height
                });
                if ("fixed" === a) {
                    var i = t[0].getBoundingClientRect();
                    return {
                        top: e.top - i.top + t.scrollTop(),
                        left: e.left - i.left + t.scrollLeft(),
                        width: e.width,
                        height: e.height
                    };
                }
                return "relative" === a ? {
                    top: this.$element.offset().top - t.offset().top,
                    left: this.$element.offset().left - t.offset().left,
                    width: this.$element[0].offsetWidth || e.width,
                    height: this.$element[0].offsetHeight || e.height
                } : void 0;
            },
            getTargetPositin: function(e, t, a, i) {
                var n = e, r = this.options.container, o = this.$element.outerWidth(), s = this.$element.outerHeight(), d = w.documentElement.scrollTop + r.scrollTop(), l = w.documentElement.scrollLeft + r.scrollLeft(), c = {}, u = null, f = this.options.arrow ? 20 : 0, h = 10, p = f + h > o ? f : 0, v = f + h > s ? f : 0, g = 0, b = w.documentElement.clientHeight + d, m = w.documentElement.clientWidth + l, C = n.left + n.width / 2 - p > 0, Y = n.left + n.width / 2 + p < m, x = n.top + n.height / 2 - v > 0, Z = n.top + n.height / 2 + v < b;
                switch (t) {
                  case "bottom":
                    c = {
                        top: n.top + n.height,
                        left: n.left + n.width / 2 - a / 2
                    };
                    break;

                  case "top":
                    c = {
                        top: n.top - i,
                        left: n.left + n.width / 2 - a / 2
                    };
                    break;

                  case "left":
                    c = {
                        top: n.top + n.height / 2 - i / 2,
                        left: n.left - a
                    };
                    break;

                  case "right":
                    c = {
                        top: n.top + n.height / 2 - i / 2,
                        left: n.left + n.width
                    };
                    break;

                  case "top-right":
                    c = {
                        top: n.top - i,
                        left: C ? n.left - p : h
                    }, u = {
                        left: C ? Math.min(o, a) / 2 + p : S
                    };
                    break;

                  case "top-left":
                    g = Y ? p : -h, c = {
                        top: n.top - i,
                        left: n.left - a + n.width + g
                    }, u = {
                        left: Y ? a - Math.min(o, a) / 2 - p : S
                    };
                    break;

                  case "bottom-right":
                    c = {
                        top: n.top + n.height,
                        left: C ? n.left - p : h
                    }, u = {
                        left: C ? Math.min(o, a) / 2 + p : S
                    };
                    break;

                  case "bottom-left":
                    g = Y ? p : -h, c = {
                        top: n.top + n.height,
                        left: n.left - a + n.width + g
                    }, u = {
                        left: Y ? a - Math.min(o, a) / 2 - p : S
                    };
                    break;

                  case "right-top":
                    g = Z ? v : -h, c = {
                        top: n.top - i + n.height + g,
                        left: n.left + n.width
                    }, u = {
                        top: Z ? i - Math.min(s, i) / 2 - v : S
                    };
                    break;

                  case "right-bottom":
                    c = {
                        top: x ? n.top - v : h,
                        left: n.left + n.width
                    }, u = {
                        top: x ? Math.min(s, i) / 2 + v : S
                    };
                    break;

                  case "left-top":
                    g = Z ? v : -h, c = {
                        top: n.top - i + n.height + g,
                        left: n.left - a
                    }, u = {
                        top: Z ? i - Math.min(s, i) / 2 - v : S
                    };
                    break;

                  case "left-bottom":
                    c = {
                        top: x ? n.top - v : h,
                        left: n.left - a
                    }, u = {
                        top: x ? Math.min(s, i) / 2 + v : S
                    };
                }
                return c.top += this.getOffsetTop(), c.left += this.getOffsetLeft(), {
                    position: c,
                    arrowOffset: u
                };
            }
        }, v.fn[d] = function(t, a) {
            var i = [], e = this.each(function() {
                var e = v.data(this, "plugin_" + d);
                e ? "destroy" === t ? e.destroy() : "string" == typeof t && i.push(e[t]()) : (t ? "string" == typeof t ? "destroy" !== t && (a || (e = new n(this, null), 
                i.push(e[t]()))) : "object" == typeof t && (e = new n(this, t)) : e = new n(this, null), 
                v.data(this, "plugin_" + d, e));
            });
            return i.length ? i : e;
        };
        var s = function() {
            var e = function() {
                p();
            }, t = function(e, t) {
                t = t || {}, v(e).webuiPopover(t);
            }, a = function(e) {
                var a = !0;
                return v(e).each(function(e, t) {
                    a = a && v(t).data("plugin_" + d) !== Y;
                }), a;
            }, i = function(e, t) {
                t ? v(e).webuiPopover(t).webuiPopover("show") : v(e).webuiPopover("show");
            }, n = function(e) {
                v(e).webuiPopover("hide");
            }, r = function(e) {
                l = v.extend({}, l, e);
            }, o = function(e, t) {
                var a = v(e).data("plugin_" + d);
                if (a) {
                    var i = a.getCache();
                    a.options.cache = !1, a.options.content = t, a._opened ? (a._opened = !1, a.show()) : a.isAsync() ? a.setContentASync(t) : a.setContent(t), 
                    a.options.cache = i;
                }
            }, s = function(e, t) {
                var a = v(e).data("plugin_" + d);
                if (a) {
                    var i = a.getCache(), n = a.options.type;
                    a.options.cache = !1, a.options.url = t, a._opened ? (a._opened = !1, a.show()) : (a.options.type = "async", 
                    a.setContentASync(a.content)), a.options.cache = i, a.options.type = n;
                }
            };
            return {
                show: i,
                hide: n,
                create: t,
                isCreated: a,
                hideAll: e,
                updateContent: o,
                updateContentAsync: s,
                setDefaultOptions: r
            };
        }();
        c.WebuiPopovers = s;
    });
}(window, document);

(function(n) {
    function a(e) {
        var t = n(e).empty();
        var a = n.data(e, "switchbox").options;
        if (!t.hasClass("has-switch")) {
            var i = "";
            if (a.disabled) {
                i += " disabled ";
            }
            if (a.checked) {
                i += " checked ";
            }
            t.append('<input type="checkbox"' + i + ">");
        }
        if (a.size == "mini") {
            t.addClass("switch-mini");
        } else if (a.size == "small") {
            t.addClass("switch-small");
        } else if (a.size == "large") {
            t.addClass("switch-large");
        }
        t.attr("data-on", a.onClass);
        t.attr("data-off", a.offClass);
        t.attr("data-on-label", a.onText);
        t.attr("data-off-label", a.offText);
        t.attr("data-animated", a.animated);
        t.bootstrapSwitch();
        t.bind("switch-change", function(e, t) {
            if (!a.disabled) {
                a.onSwitchChange.call(this, e, t);
            }
            return false;
        });
    }
    n.fn.switchbox = function(t, e) {
        if (typeof t == "string") {
            return n.fn.switchbox.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = n.data(this, "switchbox");
            if (e) {
                n.extend(e.options, t);
            } else {
                n.data(this, "switchbox", {
                    options: n.extend({}, n.fn.switchbox.defaults, n.fn.switchbox.parseOptions(this), t)
                });
                n(this).removeAttr("disabled");
            }
            a(this);
        });
    };
    n.fn.switchbox.methods = {
        options: function(e) {
            return n.data(e[0], "switchbox").options;
        },
        toggleActivation: function(e) {
            return e.each(function() {
                n(this).bootstrapSwitch("toggleActivation");
            });
        },
        isActive: function(e) {
            return e.eq(0).bootstrapSwitch("isActive");
        },
        setActive: function(e, t) {
            return e.each(function() {
                n(this).bootstrapSwitch("setActive", t);
            });
        },
        toggle: function(e) {
            return e.each(function() {
                n(this).bootstrapSwitch("toggleState");
            });
        },
        setValue: function(e, t, a) {
            return e.each(function() {
                n(this).bootstrapSwitch("setState", t, a || true);
            });
        },
        getValue: function(e) {
            return e.eq(0).bootstrapSwitch("status");
        },
        setOnText: function(e, t) {
            return e.each(function() {
                n(this).bootstrapSwitch("setOnLabel", t);
            });
        },
        setOffText: function(e, t) {
            return e.each(function() {
                n(this).bootstrapSwitch("setOffLabel", t);
            });
        },
        setOnClass: function(e, t) {
            return e.each(function() {
                n(this).bootstrapSwitch("setOnClass", t);
            });
        },
        setOffClass: function(e, t) {
            return e.each(function() {
                n(this).bootstrapSwitch("setOffClass", t);
            });
        },
        destroy: function(e) {
            return e.each(function() {
                n(this).bootstrapSwitch("destroy");
            });
        }
    };
    n.fn.switchbox.parseOptions = function(e) {
        var t = n(e);
        return n.extend({}, n.parser.parseOptions(e, [ "id", "iconCls", "iconAlign", "group", "size", {
            plain: "boolean",
            toggle: "boolean",
            selected: "boolean"
        } ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    n.fn.switchbox.defaults = {
        id: null,
        disabled: false,
        checked: true,
        animated: false,
        size: "mini",
        onText: "开",
        offText: "关",
        onClass: "success",
        offClass: "warning",
        onSwitchChange: function(e, t) {}
    };
})(jQuery);

(function(l) {
    function a(i) {
        var e = l(i).empty();
        var t = l.data(i, "checkbox");
        var a = t.options;
        if (!a.id) {
            a.id = a.label;
            e.attr("id", a.id);
        }
        e.prop("disabled", a.disabled);
        e.prop("checked", a.checked);
        a.originalValue = e.prop("checked");
        if (!e.hasClass("checkbox-f")) {
            e.addClass("checkbox-f");
            var n = i.className.replace("hisui-checkbox", "");
            var r = '<label class="checkbox ' + n;
            if (a.boxPosition == "right") {
                r += " right";
            }
            if (a.disabled) {
                r += " disabled";
            }
            if (a.checked) {
                r += " checked";
            }
            r += '"';
            if (a.width) {
                r += ' style="width:' + a.width + 'px" ';
            }
            r += ">" + a.label + "</label>";
            var o = l(r).insertAfter(e);
            o.unbind("click").bind("click.checkbox", function(e) {
                if (l(i).prop("disabled") == false) c(i, !l(this).hasClass("checked"));
            });
            e.unbind("click").bind("click.checkbox", function(e) {
                var t = l(this).is(":checked");
                if (t) {
                    if (a.onChecked) a.onChecked.call(this, e, true);
                    if (a.ifChecked) a.ifChecked.call(this, e, true);
                } else {
                    if (a.onUnchecked) a.onUnchecked.call(this, e, false);
                    if (a.ifUnchecked) a.ifUnchecked.call(this, e, false);
                }
                if (a.onCheckChange) a.onCheckChange.call(this, e, t);
                if (a.ifToggled) a.ifToggled.call(this, e, t);
            });
            var s = l('label[for="' + a.id + '"]').add(e.closest("label"));
            if (s.length) {
                s.off(".checkbox").on("click.checkbox mouseover.checkbox mouseout.checkbox ", function(e) {
                    var t = e["type"], a = l(this);
                    if (!l(i).prop("disabled")) {
                        if (t == "click") {
                            if (l(e.target).is("a")) {
                                return;
                            }
                            c(i, !o.hasClass("checked"));
                        } else {
                            if (/ut|nd/.test(t)) {
                                o.removeClass("hover");
                            } else {
                                o.addClass("hover");
                            }
                        }
                        return false;
                    }
                });
            }
            t.proxy = o;
        } else {
            var o = t.proxy;
            if (a.disabled && !o.hasClass("disabled")) o.addClass("disabled");
            if (!a.disabled && o.hasClass("disabled")) o.removeClass("disabled");
            if (a.checked && !o.hasClass("checked")) o.addClass("checked");
            if (!a.checked && o.hasClass("checked")) o.removeClass("checked");
            if (a.label != o.text()) o.text(a.label);
        }
        var d = l.data(i, "checkbox");
        l.data(i, "checkbox", d);
        e.hide();
    }
    function i(e) {
        var t = (l.data(e, "checkbox") || l.data(e, "radio") || {})["proxy"];
        if (t) {
            if (l(e).prop("checked") && !t.hasClass("checked")) t.addClass("checked");
            if (!l(e).prop("checked") && t.hasClass("checked")) t.removeClass("checked");
        }
    }
    l.fn.checkbox = function(t, e) {
        if (typeof t == "string") {
            return l.fn.checkbox.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = l.data(this, "checkbox");
            if (e) {
                l.extend(e.options, t);
            } else {
                l.data(this, "checkbox", {
                    options: l.extend({}, l.fn.checkbox.defaults, l.fn.checkbox.parseOptions(this), t)
                });
            }
            a(this);
        });
    };
    function c(e, t) {
        if (t != l(e).is(":checked")) {
            if (l(e).prop("disabled") == true) {
                l(e).prop("disabled", false);
                l(e).prop("checked", t);
                l(e).prop("disabled", true);
            }
            var a = (l.data(e, "checkbox") || l.data(e, "radio") || {})["proxy"];
            if (t) {
                a.addClass("checked");
            } else {
                a.removeClass("checked");
            }
            l(e).trigger("click.checkbox");
        }
        i(e);
    }
    function t(e) {
        return l(e).is(":checked");
    }
    function n(e, t) {
        t = t == true;
        var a = l.data(e, "checkbox") || l.data(e, "radio") || {};
        var i = a.proxy;
        if (i) {
            l(e).prop("disabled", t);
            if (t) i.addClass("disabled"); else i.removeClass("disabled");
            a.options.disabled = t;
        }
    }
    l.fn.checkbox.methods = {
        options: function(e) {
            return l.data(e[0], "checkbox").options;
        },
        setValue: function(e, t) {
            return e.each(function() {
                c(this, t);
                i(this);
            });
        },
        getValue: function(e) {
            return t(e[0]);
        },
        setDisable: function(e, t) {
            return e.each(function() {
                n(this, t);
            });
        },
        check: function(e) {
            return e.each(function() {
                c(this, true);
            });
        },
        uncheck: function(e) {
            return e.each(function() {
                c(this, false);
            });
        },
        toggle: function(e) {
            return e.each(function() {
                c(this, !t(this));
            });
        },
        disable: function(e) {
            return e.each(function() {
                n(this, true);
            });
        },
        enable: function(e) {
            return e.each(function() {
                n(this, false);
            });
        },
        indeterminate: function(e) {
            return e.each(function() {});
        },
        determinate: function(e) {
            return e.each(function() {});
        },
        update: function(e) {},
        destroy: function(e) {},
        clear: function(e) {
            return e.each(function() {
                c(this, false);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = l(this).checkbox("options").originalValue || false;
                c(this, e);
            });
        }
    };
    l.fn.checkbox.parseOptions = function(e) {
        var t = l(e);
        return l.extend({}, l.parser.parseOptions(e, [ "label", "name", "id", "checked", "width" ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    l.fn.checkbox.defaults = {
        id: null,
        label: "",
        width: null,
        boxPosition: "left",
        disabled: false,
        checked: false,
        onCheckChange: null,
        onChecked: null,
        onUnchecked: null,
        ifChecked: null,
        ifUnchecked: null,
        ifToggled: null
    };
})(jQuery);

(function(l) {
    function a(i) {
        var e = l(i).empty();
        var t = l.data(i, "radio");
        var a = t.options;
        if (!a.id) {
            a.id = a.label;
            e.attr("id", a.id);
        }
        if (a.name != "") e.attr("name", a.name);
        e.prop("disabled", a.disabled);
        e.prop("checked", a.checked);
        a.originalValue = e.prop("checked");
        if (!e.hasClass("radio-f")) {
            var n = a.required;
            e.addClass("radio-f");
            var r = '<label class="radio';
            if (a.boxPosition == "right") {
                r += " right";
            }
            if (a.radioClass) {
                r += " hischeckbox_square-blue";
            }
            if (a.disabled) {
                r += " disabled";
            }
            if (a.checked) {
                r += " checked";
            }
            r += '">' + a.label + "</label>";
            var o = l(r).insertAfter(e);
            o.unbind("click").bind("click.radio", function(e) {
                var t = l(this);
                if (!t.hasClass("disabled")) {
                    c(i, !t.hasClass("checked"), !n);
                }
            });
            e.unbind("click").bind("click.radio", function(e) {
                if (l(this).prop("disabled") == false) {
                    var t = l(this).is(":checked");
                    if (t) {
                        if (a.onChecked) a.onChecked.call(this, e, true);
                    } else {}
                    if (a.onCheckChange) a.onCheckChange.call(this, e, t);
                }
            }).bind("ifChecked", function(e, t) {
                if (!l(this).prop("disabled")) {
                    if (a.onChecked) a.onChecked.call(this, e, t);
                }
                return false;
            }).bind("ifUnchecked", function(e, t) {
                if (!l(this).prop("disabled")) {
                    if (a.onUnchecked) a.onUnchecked.call(this, e, t);
                }
                return false;
            }).bind("ifToggled", function(e, t) {
                if (!l(this).prop("disabled")) {
                    if (a.onCheckChange) a.onCheckChange.call(this, e, t);
                }
                return false;
            });
            var s = l('label[for="' + a.id + '"]').add(e.closest("label"));
            if (s.length) {
                s.off(".radio").on("click.radio mouseover.radio mouseout.radio ", function(e) {
                    var t = e["type"], a = l(this);
                    if (!l(i).prop("disabled")) {
                        if (t == "click") {
                            if (l(e.target).is("a")) {
                                return;
                            }
                            c(i, !o.hasClass("checked"), !n);
                        } else {
                            if (/ut|nd/.test(t)) {
                                o.removeClass("hover");
                            } else {
                                o.addClass("hover");
                            }
                        }
                        return false;
                    }
                });
            }
            t.proxy = o;
        } else {
            var o = t.proxy;
            if (a.disabled && !o.hasClass("disabled")) o.addClass("disabled");
            if (!a.disabled && o.hasClass("disabled")) o.removeClass("disabled");
            if (a.checked && !o.hasClass("checked")) o.addClass("checked");
            if (!a.checked && o.hasClass("checked")) o.removeClass("checked");
            if (a.label != o.text()) o.text(a.label);
        }
        var d = l.data(i, "radio");
        l.data(i, "radio", d);
        e.hide();
    }
    function d(e) {
        var t = (l.data(e, "radio") || l.data(e, "checkbox") || {})["proxy"];
        if (t) {
            if (l(e).prop("checked") && !t.hasClass("checked")) t.addClass("checked");
            if (!l(e).prop("checked") && t.hasClass("checked")) t.removeClass("checked");
        }
    }
    l.fn.radio = function(t, e) {
        if (typeof t == "string") {
            return l.fn.radio.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = l.data(this, "radio");
            if (e) {
                l.extend(e.options, t);
            } else {
                l.data(this, "radio", {
                    options: l.extend({}, l.fn.radio.defaults, l.fn.radio.parseOptions(this), t)
                });
            }
            a(this);
        });
    };
    function c(e, t, a) {
        var i = l(e);
        if (t != i.is(":checked")) {
            var n = (l.data(e, "radio") || l.data(e, "checkbox") || {})["proxy"];
            if (t == true) {
                var r = l(e).attr("name");
                if (r) {
                    var o = i.closest("form"), s = 'input[name="' + r + '"]';
                    s = o.length ? o.find(s) : l(s);
                    s.each(function() {
                        if (this !== e && l.data(this, "radio")) {
                            c(this, false, true);
                        }
                    });
                }
                n.addClass("checked");
                l(e).prop("checked", true).trigger("ifChecked", true).trigger("ifToggled", true);
            } else {
                if (a) {
                    n.removeClass("checked");
                    l(e).prop("checked", false).trigger("ifUnchecked", false).trigger("ifToggled", false);
                }
            }
        }
        d(e);
    }
    function t(e) {
        return l(e).is(":checked");
    }
    function i(e, t) {
        t = t == true;
        var a = l.data(e, "radio") || l.data(e, "checkbox") || {};
        var i = a.proxy;
        if (i) {
            l(e).prop("disabled", t);
            if (t) i.addClass("disabled"); else i.removeClass("disabled");
            a.options.disabled = t;
        }
    }
    l.fn.radio.methods = {
        options: function(e) {
            return l.data(e[0], "radio").options;
        },
        setValue: function(e, t) {
            return e.each(function() {
                c(this, t, true);
            });
        },
        getValue: function(e) {
            return t(e[0]);
        },
        setDisable: function(e, t) {
            return e.each(function() {
                i(this, t);
            });
        },
        check: function(e) {
            return e.each(function() {
                c(this, true, true);
            });
        },
        uncheck: function(e) {
            return e.each(function() {
                c(this, false, true);
            });
        },
        toggle: function(e) {
            return e.each(function() {
                c(this, !t(this), true);
            });
        },
        disable: function(e) {
            return e.each(function() {
                i(this, true);
            });
        },
        enable: function(e) {
            return e.each(function() {
                i(this, false);
            });
        },
        indeterminate: function(e) {
            return e.each(function() {});
        },
        determinate: function(e) {
            return e.each(function() {});
        },
        update: function(e) {},
        destroy: function(e) {},
        clear: function(e) {
            return e.each(function() {
                c(this, false, true);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = l(this).radio("options").originalValue || false;
                c(this, e, true);
            });
        }
    };
    l.fn.radio.parseOptions = function(e) {
        var t = l(e);
        return l.extend({}, l.parser.parseOptions(e, [ "label", "id", "name", "checked" ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    l.fn.radio.defaults = {
        id: null,
        label: "",
        name: "",
        boxPosition: "left",
        radioClass: "",
        disabled: false,
        checked: false,
        onCheckChange: null,
        onChecked: null,
        required: false
    };
})(jQuery);

(function(l) {
    l.parser.plugins.push("filebox");
    var c = 0;
    function i(e) {
        var t = l.data(e, "filebox");
        var a = t.options;
        a.fileboxId = "filebox_file_id_" + ++c;
        l(e).addClass("filebox-f").hide();
        var i = l('<span class="filebox">' + '<input class="filebox-text" autocomplete="off">' + '<input type="hidden" class="filebox-value">' + "</span>").insertAfter(e);
        var n = l(e).attr("name");
        if (n) {
            i.find("input.filebox-value").attr("name", n);
            l(e).removeAttr("name").attr("fileboxName", n);
        }
        if (a.plain) i.addClass("filebox-plain");
        if (a.disabled) i.addClass("disabled");
        if (!a.buttonText) i.addClass("filebox-no-txet");
        if (a.buttonAlign == "left") i.addClass("filebox-left");
        var r = l('<a href="javascript:;" class="filebox-button"></a>').prependTo(i);
        r.addClass("filebox-button-" + a.buttonAlign).linkbutton({
            text: a.buttonText,
            iconCls: a.buttonIcon,
            onClick: function() {
                a.onClickButton.call(e);
            },
            disabled: a.disabled
        });
        var o = i.find("input.filebox-text");
        o.attr("readonly", "readonly").attr("placeholder", a.prompt || "");
        t.filebox = l(e).next();
        var s = u(e);
        if (r.length) {
            l('<label class="filebox-label" for="' + a.fileboxId + '"></label>').appendTo(r);
            if (r.linkbutton("options").disabled) {
                s.attr("disabled", "disabled");
            } else {
                s.removeAttr("disabled");
            }
        }
        i._outerWidth(a.width)._outerHeight(a.height);
        var d = i.width() - r.outerWidth();
        o._outerWidth(d).css({
            height: i.height() + "px",
            lineHeight: i.height() + "px",
            marginLeft: (a.buttonAlign == "left" ? r.outerWidth() : 0) + "px"
        });
    }
    function u(t) {
        var e = l.data(t, "filebox");
        var a = e.options;
        e.filebox.find(".filebox-value").remove();
        a.oldValue = "";
        var i = l('<input type="file" class="filebox-value">').appendTo(e.filebox);
        i.attr("id", a.fileboxId).attr("name", l(t).attr("fileboxName") || "");
        i.attr("accept", a.accept);
        i.attr("capture", a.capture);
        if (a.multiple) {
            i.attr("multiple", "multiple");
        }
        i.change(function() {
            var e = this.value;
            if (this.files) {
                e = l.map(this.files, function(e) {
                    return e.name;
                }).join(a.separator);
            }
            l(t).filebox("setText", e);
            a.onChange.call(t, e, a.oldValue);
            a.oldValue = e;
        });
        return i;
    }
    function t(e) {
        var t = l.data(e, "filebox");
        var a = t.options;
        var i = t.filebox;
        i.addClass("disabled");
        var n = i.find(".filebox-button");
        n.linkbutton("disable");
        var r = i.find(".filebox-value");
        r.attr("disabled", "disabled");
        a.disabled = true;
    }
    function a(e) {
        var t = l.data(e, "filebox");
        var a = t.options;
        var i = t.filebox;
        i.removeClass("disabled");
        var n = i.find(".filebox-button");
        n.linkbutton("enable");
        var r = i.find(".filebox-value");
        r.removeAttr("disabled");
        a.disabled = false;
    }
    l.fn.filebox = function(t, e) {
        if (typeof t == "string") {
            var a = l.fn.filebox.methods[t];
            return a(this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = l.data(this, "filebox");
            if (e) {
                l.extend(e.options, t);
            } else {
                l.data(this, "filebox", {
                    options: l.extend({}, l.fn.filebox.defaults, l.fn.filebox.parseOptions(this), t)
                });
            }
            i(this);
        });
    };
    l.fn.filebox.methods = {
        options: function(e) {
            return l.data(e[0], "filebox").options;
        },
        clear: function(e) {
            return e.each(function() {
                u(this);
                l(this).filebox("setText", "");
            });
        },
        reset: function(e) {
            return e.each(function() {
                l(this).filebox("clear");
            });
        },
        setValue: function(e) {
            return e;
        },
        setValues: function(e) {
            return e;
        },
        files: function(e) {
            return e.next().find(".filebox-value")[0].files;
        },
        setText: function(e, t) {
            return e.each(function() {
                l.data(this, "filebox").filebox.find(".filebox-text").val(t);
            });
        },
        button: function(e) {
            return l.data(e[0], "filebox").filebox.find(".filebox-button");
        },
        disable: function(e) {
            return e.each(function() {
                t(this);
            });
        },
        enable: function(e) {
            return e.each(function() {
                a(this);
            });
        }
    };
    l.fn.filebox.parseOptions = function(e) {
        var t = l(e);
        return l.extend({}, l.parser.parseOptions(e, [ "width", "height", "prompt", "accept", "capture", "separator" ]), {
            multiple: t.attr("multiple") ? true : undefined,
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    l.fn.filebox.defaults = l.extend({}, {
        buttonIcon: null,
        buttonText: "Choose File",
        buttonAlign: "right",
        inputEvents: {},
        accept: "",
        capture: "",
        separator: ",",
        multiple: false,
        prompt: "",
        width: "177",
        height: "30",
        disabled: false,
        onClickButton: function() {},
        onChange: function() {},
        plain: false
    });
})(jQuery);

(function(n) {
    function a(e) {
        var t = n(e);
        var a = n.data(e, "popover").options;
        if (!a.id) {
            a.id = a.label;
            t.attr("id", a.id);
        }
        t.prop("disabled", a.disabled);
        if (!a.cache) t.webuiPopover("destroy");
        t.webuiPopover(a);
    }
    n.fn.popover = function(t, e) {
        if (typeof t == "string") {
            return n.fn.popover.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = n.data(this, "popover");
            if (e) {
                n.extend(e.options, t);
            } else {
                n.data(this, "popover", {
                    options: n.extend({}, n.fn.popover.defaults, n.fn.popover.parseOptions(this), t)
                });
            }
            a(this);
        });
    };
    n.fn.popover.methods = {
        options: function(e) {
            return n.data(e[0], "popover").options;
        },
        show: function(e) {
            return e.each(function() {
                var e = n(this);
                e.webuiPopover("show");
            });
        },
        hide: function(e) {
            return e.each(function() {
                var e = n(this);
                if (!n.data(this, "popover").options.cache) {
                    e.webuiPopover("destroy");
                } else {
                    e.webuiPopover("hide");
                }
            });
        },
        destroy: function(e) {
            return e.each(function() {
                n(this).webuiPopover("destroy");
            });
        },
        setContent: function(e, i) {
            return e.each(function() {
                var e = n.data(this, "popover").options.cache;
                if (n.data(this, "popover").options.cache) {
                    n.data(this, "popover").options.cache = false;
                }
                var t = n(this);
                var a = n.data(this, "popover").options;
                a.content = i;
                t.webuiPopover("destroy");
                t.webuiPopover(a);
                n.data(this, "popover").options.cache = e;
            });
        }
    };
    n.fn.popover.parseOptions = function(e) {
        var t = n(e);
        return n.extend({}, n.parser.parseOptions(e, [ "id" ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    n.fn.popover.defaults = {
        id: null,
        disabled: false,
        placement: "auto",
        container: document.body,
        width: "auto",
        height: "auto",
        trigger: "click",
        selector: false,
        style: "",
        animation: null,
        delay: {
            show: null,
            hide: 300
        },
        async: {
            type: "GET",
            before: function(e, t) {},
            success: function(e, t) {},
            error: function(e, t, a) {}
        },
        cache: true,
        multi: false,
        arrow: true,
        title: "",
        content: "",
        closeable: false,
        direction: "",
        padding: true,
        type: "html",
        url: "",
        backdrop: false,
        dismissible: true,
        autoHide: false,
        offsetTop: 0,
        offsetLeft: 0,
        onShow: function(e) {},
        onHide: function(e) {}
    };
})(jQuery);

(function(o) {
    function t(e, t) {
        var a = o(t);
        if (a.hasClass("bginone")) return false;
        var i = e.pageX;
        var n = a._outerWidth();
        var r = a.offset();
        if (i < r.left + n && i > r.left + n - 40) {
            return true;
        }
        return false;
    }
    function a(e, t) {}
    function s(e) {
        var t = o(o.hisui.globalContainerSelector);
        if ("undefined" == typeof e) {
            if (o.data(t[0], "data")) e = o.data(t[0], "data").srcTargetDom;
        }
        if (t.is(":visible")) {
            var a = o.data(e, "comboq");
            var i = a.options;
            a.isShow = false;
            i.onHidePanel.call(this, e);
            o(o.hisui.globalContainerSelector).hide();
            return o(e);
        }
        if ("undefined" != typeof e) return o(e);
        return null;
    }
    function i(e) {
        n(e, "");
        r(e, "");
    }
    function n(e, t) {
        var a = o.data(e, "comboq");
        if (t != o(e).val()) {
            o(e).val(t);
            o(e).comboq("validate");
            a.previousValue = t;
        }
    }
    function r(e, t) {
        var a = o.data(e, "comboq");
        var i = a.options;
        var n = o(e).data("value");
        if (t != n) {
            i.onChange.call(e, t, n);
            o(e).data("value", t);
            o(e).comboq("validate");
            a.originalRealValue = t;
        }
    }
    function d(a) {
        var i = o.data(a, "comboq");
        var n = i.options;
        var r = o(a);
        r.addClass("comboq");
        r.attr("autocomplete", "off");
        if (o.isNumeric(n.width)) r._outerWidth(n.width);
        if (n.disabled) {
            r.addClass("disabled");
        }
        if (n.readOnly) {
            r.addClass("readonly");
        }
        if (!n.hasDownArrow) {
            r.addClass("bginone");
        }
        r.validatebox(n);
        o(document).unbind(".comboq").bind("mousedown.comboq", function(e) {
            var t = o(e.target).closest("input.comboq");
            if (t.length > 0 && o.data(t[0], "comboq").isShow) {
                return;
            }
            var a = o(e.target).closest(o.hisui.globalContainerSelector);
            if (a.length) {
                return;
            }
            if (o(o.hisui.globalContainerSelector).is(":visible")) s();
        });
        r.unbind(".comboq").bind("mousemove.comboq", function(e) {
            if (o(this).hasClass("disabled")) return;
            if (o(this).hasClass("readonly")) return;
            if (t(e, this)) {
                this.style.cursor = "pointer";
            } else {
                this.style.cursor = "auto";
            }
        }).bind("mouseleave.comboq", function() {
            this.style.cursor = "auto";
        }).bind("click.comboq", function(e) {
            if (o(this).hasClass("disabled")) return;
            if (o(this).hasClass("readonly")) return;
            if (t(e, this)) {
                e.preventDefault();
                e.stopPropagation();
                c(this);
                return false;
            }
        }).bind("blur.comboq", function(e) {
            if (n.onBlur) n.onBlur.call(this, a);
        }).bind("keydown.combo paste.combo drop.combo input.combo", function(t) {
            if ("undefined" == typeof t.keyCode) {
                return;
            }
            switch (t.keyCode) {
              case 38:
                n.keyHandler.up.call(a, t);
                break;

              case 40:
                n.keyHandler.down.call(a, t);
                break;

              case 37:
                n.keyHandler.left.call(a, t);
                break;

              case 39:
                n.keyHandler.right.call(a, t);
                break;

              case 33:
                n.keyHandler.pageUp.call(a, t);
                break;

              case 34:
                n.keyHandler.pageDown.call(a, t);
                break;

              case 13:
                t.preventDefault();
                n.keyHandler.enter.call(a, t);
                return false;

              case 9:
              case 27:
                s();
                break;

              default:
                setTimeout(function() {
                    if (n.editable) {
                        if (i.timer) {
                            clearTimeout(i.timer);
                        }
                        if (!n.isCombo) return;
                        if (n.minQueryLen > 0 && r.val().length < n.minQueryLen) return;
                        i.timer = setTimeout(function() {
                            var e = r.val();
                            if (i.previousValue != e) {
                                i.previousValue = e;
                                if (!i.isShow) o(a).comboq("showPanel");
                                n.keyHandler.query.call(a, r.val(), t);
                                o(a).comboq("validate");
                            }
                        }, n.delay);
                    }
                }, 0);
            }
        });
        return;
    }
    function l(e, t) {
        if (t) {
            o(e).addClass("disabled");
            o(e).prop("disabled", true);
        } else {
            o(e).removeClass("disabled");
            o(e).prop("disabled", false);
        }
    }
    function c(e) {
        var t = o(e);
        var a = o.data(e, "comboq");
        var i = a.options;
        if (i.onBeforeShowPanel.call(e) === false) return false;
        var n = o(o.hisui.globalContainerSelector);
        if (n.length > 0) {
            n.empty();
        } else {
            n = o('<div id="' + o.hisui.globalContainerId + '"></div>').appendTo("body");
        }
        n.height(i.panelHeight);
        if (!i.panelWidth) {
            i.panelWidth = t._outerWidth();
        }
        n.width(i.panelWidth);
        a.isShow = true;
        n.show();
        o.data(document.getElementById(o.hisui.globalContainerId), "data", {
            srcTargetDom: e
        });
        i.onShowPanel.call(e);
        o.hisui.fixPanelTLWH();
    }
    o.fn.comboq = function(a, e) {
        if (typeof a == "string") {
            var t = o.fn.comboq.methods[a];
            if (t) {
                return t(this, e);
            } else {
                return this.validatebox(a, e);
            }
        }
        a = a || {};
        return this.each(function() {
            var e = o.data(this, "comboq");
            if (e) {
                o.extend(e.options, a);
            } else {
                e = o.data(this, "comboq", {
                    isShow: false,
                    options: o.extend({}, o.fn.comboq.defaults, o.fn.comboq.parseOptions(this), a),
                    previousValue: null
                });
                var t = d(this);
            }
        });
    };
    o.fn.comboq.methods = {
        options: function(e) {
            return o.data(e[0], "comboq").options;
        },
        panel: function(e) {
            return o(o.hisui.globalContainerSelector);
        },
        textbox: function(e) {
            return e;
        },
        destroy: function(e) {
            return;
        },
        resize: function(e, t) {
            return e.each(function() {
                a(this, t);
            });
        },
        showPanel: function(e) {
            return c(e[0]);
        },
        hidePanel: function(e) {
            return s();
        },
        setDisabled: function(e, t) {
            return e.each(function() {
                l(this, t);
            });
        },
        disable: function(e) {
            return e.each(function() {
                l(this, true);
            });
        },
        enable: function(e) {
            return e.each(function() {
                l(this, false);
            });
        },
        readonly: function(e, t) {
            return e.each(function() {
                if (t) {
                    o(this).addClass("readonly");
                } else {
                    o(this).removeClass("readonly");
                }
                o(this).prop("readonly", t);
            });
        },
        isValid: function(e) {
            return e.validatebox("isValid");
        },
        clear: function(e) {
            return e.each(function() {
                i(this);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = o.data(this, "comboq").options;
                if (e.multiple) {
                    o(this).comboq("setValues", e.originalRealValue);
                    o(this).comboq("setText", e.originalValue);
                } else {
                    o(this).comboq("setValue", e.originalRealValue);
                    o(this).comboq("setText", e.originalValue);
                }
            });
        },
        getText: function(e) {
            return e.val();
        },
        setText: function(e, t) {
            return e.each(function() {
                n(this, t);
            });
        },
        getValues: function(e) {
            return e.data("value");
        },
        setValues: function(e, t) {
            return e.each(function() {
                if (o.isArray(t) && t.length > 0) r(this, t[0]); else {
                    r(this, "");
                }
            });
        },
        getValue: function(e) {
            return e.data("value");
        },
        setValue: function(e, t) {
            return e.each(function() {
                r(this, t);
            });
        },
        createPanelBody: function() {
            var e = o(o.hisui.globalContainerSelector);
            if (e.length) {
                e.empty();
            } else {
                e = o('<div id="' + o.hisui.globalContainerId + '"></div>').appendTo("body");
            }
            return o("<div></div>").appendTo(e);
        }
    };
    o.fn.comboq.parseOptions = function(e) {
        var t = o(e);
        return o.extend({}, o.fn.validatebox.parseOptions(e), o.parser.parseOptions(e, [ "blurValidValue", "width", "height", "separator", "panelAlign", {
            panelWidth: "number",
            editable: "boolean",
            hasDownArrow: "boolean",
            delay: "number",
            selectOnNavigation: "boolean"
        } ]), {
            panelHeight: t.attr("panelHeight") == "auto" ? "auto" : parseInt(t.attr("panelHeight")) || undefined,
            multiple: t.attr("multiple") ? true : undefined,
            disabled: t.attr("disabled") ? true : undefined,
            readonly: t.attr("readonly") ? true : undefined,
            value: t.val() || undefined
        });
    };
    o.fn.comboq.defaults = o.extend({}, o.fn.validatebox.defaults, {
        blurValidValue: false,
        enterNullValueClear: true,
        width: "auto",
        height: 22,
        panelWidth: null,
        panelHeight: 200,
        isCombo: true,
        minQueryLen: 0,
        panelAlign: "left",
        multiple: false,
        selectOnNavigation: true,
        separator: ",",
        editable: true,
        disabled: false,
        readonly: false,
        hasDownArrow: true,
        value: "",
        delay: 200,
        deltaX: 19,
        keyHandler: {
            up: function(e) {},
            down: function(e) {},
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {},
            query: function(e, t) {}
        },
        onBeforeShowPanel: function() {},
        onShowPanel: function() {},
        onHidePanel: function() {},
        onChange: function(e, t) {}
    });
})(jQuery);

(function(h) {
    function t(e, t) {
        var a = h.data(e, "lookup");
        var i = a.options;
        var n = a.grid;
        if (!n) return;
        var r = n.datagrid("getRows").length;
        if (!r) {
            return;
        }
        var o = i.finder.getTr(n[0], null, "highlight");
        if (!o.length) {
            o = i.finder.getTr(n[0], null, "selected");
        }
        var s;
        if (!o.length) {
            s = t == "next" ? 0 : r - 1;
        } else {
            var s = parseInt(o.attr("datagrid-row-index"));
            s += t == "next" ? 1 : -1;
            if (s < 0) {
                s = r - 1;
            }
            if (s >= r) {
                s = 0;
            }
        }
        n.datagrid("highlightRow", s);
        if (i.selectOnNavigation) {
            a.remainText = false;
            n.datagrid("selectRow", s);
        }
    }
    function a(e, t) {
        var a = h.data(e, "lookup");
        var i = a.options;
        var n = a.grid;
        t = t == "prev" ? "prev" : "next";
        var r = n.datagrid("getPager").find(".l-btn-icon.pagination-" + t);
        if (r.parents(".l-btn-disabled").length == 0) {
            r.click();
        }
    }
    function l(e, t, a) {
        var i = h.data(e, "lookup");
        var n = i.options;
        var r = i.grid;
        var o = r.datagrid("getRows");
        var s = [];
        var d = n;
        var l = d.onChange;
        d.onChange = function() {};
        r.datagrid("clearSelections");
        for (var c = 0; c < t.length; c++) {
            var u = r.datagrid("getRowIndex", t[c]);
            if (u >= 0) {
                r.datagrid("selectRow", u);
                s.push(o[u][n.textField]);
            } else {
                s.push(t[c]);
            }
        }
        d.onChange = l;
        if (!a) {
            var f = s.join(n.separator);
            if (h(e).lookup("getText") != f) {
                h(e).lookup("setText", f);
            }
        }
    }
    function c(i, e, t) {
        var a = h.data(i, "lookup");
        var n = a.options;
        var r = a.grid;
        if (n.isCombo && n.enableNumberEvent) {
            var o = t.keyCode;
            if (o <= 57 && o >= 49) {
                r.datagrid("selectRow", o - 49);
                return false;
            } else if (o <= 105 && o >= 97) {
                r.datagrid("selectRow", o - 97);
                return false;
            }
        }
        a.remainText = true;
        if (n.multiple && !e) {
            l(i, [], true);
        } else {
            l(i, [ e ], true);
        }
        if (n.mode == "remote") {
            r.datagrid("loadData", {
                rows: [],
                total: 0
            });
            r.datagrid("clearSelections");
            r.datagrid("load", h.extend({}, n.queryParams, {
                q: e
            }));
        } else {
            if (!e) {
                return;
            }
            r.datagrid("clearSelections").datagrid("highlightRow", -1);
            var s = r.datagrid("getRows");
            var d = n.multiple ? e.split(n.separator) : [ e ];
            h.map(d, function(a) {
                a = h.trim(a);
                if (a) {
                    h.map(s, function(e, t) {
                        if (a == e[n.textField]) {
                            r.datagrid("selectRow", t);
                        } else {
                            if (n.filter.call(i, a, e)) {
                                r.datagrid("highlightRow", t);
                            }
                        }
                    });
                }
            });
        }
    }
    function u(e) {
        var t = false;
        try {
            if (e.grid && e.grid.datagrid("options").lookup) t = true;
        } catch (a) {}
        return t;
    }
    function i(e, t) {
        var a = h.data(e, "lookup");
        var i = a.options;
        var n = a.grid;
        var r = h(e).comboq("panel");
        if (u(a) && r.is(":visible")) {
            var o = n.datagrid("options").queryParams.q;
            if (o == h(e).lookup("getText")) {
                var s = i.finder.getTr(n[0], null, "highlight");
                if (s.length) {
                    var d = parseInt(s.attr("datagrid-row-index"));
                    n.datagrid("selectRow", d);
                    return;
                }
            }
            c(e, h(e).lookup("getText"), t);
        } else {
            h(e).comboq("showPanel");
        }
        return;
    }
    function r(e, t) {
        var a = h(h.hisui.globalContainerSelector);
        if (a.is(":visible")) {
            a.find(".lookup-rowSummary").remove();
            var i = h('<div class="lookup-rowSummary">' + t + "</div>").appendTo(a)._outerHeight();
            a._outerHeight(a.children(".datagrid")._outerHeight() + i);
            h.hisui.fixPanelTLWH();
        }
        return;
    }
    function n(i) {
        var t = h.data(i, "lookup");
        var n = t.options;
        if (!u(t)) {
            var a = h(i).comboq("createPanelBody");
            if (!n.columns && typeof n.columnsLoader == "function") n.columns = n.columnsLoader(i);
            a.datagrid(h.extend({}, n, {
                title: n.gridTitle || "",
                rownumbers: true,
                lazy: true,
                border: false,
                fit: true,
                singleSelect: !n.multiple,
                onLoadSuccess: function(e) {
                    if (t.panel.is(":visible")) {
                        h(i).focus();
                        a.datagrid("highlightRow", 0);
                    }
                    n.onLoadSuccess.apply(i, arguments);
                },
                onSelect: function(e, t) {
                    var a = n.onChange;
                    n.onChange = function() {};
                    h(i).comboq("setText", t[n.textField]);
                    h(i).comboq("setValue", t[n.idField]);
                    n.onChange = a;
                    if (false !== n.onSelect.call(this, e, t)) {
                        h(i).comboq("hidePanel");
                    }
                },
                onHighlightRow: function(e, t) {
                    if ("function" == typeof n.selectRowRender) {
                        var a = n.selectRowRender.call(this, t);
                        if (typeof a != "string") a = "";
                        r(i, a);
                    }
                },
                clickDelay: 200,
                lookup: h(i)
            }));
            a.datagrid("loadData", {
                total: 0,
                rows: []
            });
            t.grid = a;
        }
        if (n.minQueryLen < 0) {
            n.minQueryLen = 0;
        }
        var e = h(i).lookup("getText");
        t.grid.datagrid("load", h.extend({}, n.queryParams, {
            q: e
        }));
    }
    function o(e) {
        var t = h.data(e, "lookup");
        var a = t.options;
        var i = h(e);
        i.addClass("lookup");
        i.comboq(h.extend({}, a, {
            onShowPanel: function() {
                t.panel = h(e).comboq("panel");
                n(e);
                a.onShowPanel.call(e);
            }
        }));
    }
    h.fn.lookup = function(t, e) {
        if (typeof t == "string") {
            var a = h.fn.lookup.methods[t];
            if (a) {
                return a(this, e);
            } else {
                return h(this).comboq(t, e);
            }
        }
        t = t || {};
        t.originalValue = t.value;
        return this.each(function() {
            var e = h.data(this, "lookup");
            if (e) {
                h.extend(e.options, t);
            } else {
                e = h.data(this, "lookup", {
                    options: h.extend({}, h.fn.lookup.defaults, h.fn.lookup.parseOptions(this), t)
                });
                o(this);
            }
        });
    };
    h.fn.lookup.methods = {
        options: function(e) {
            return h.data(e[0], "lookup").options;
        },
        grid: function(e) {
            return h.data(e[0], "lookup").grid;
        },
        clear: function(e) {
            return e.each(function() {
                var e = h(this).lookup("grid");
                if (e) {
                    e.datagrid("clearSelections");
                    h(this).lookup("setText", "");
                    h(this).lookup("setValue", "");
                }
            });
        }
    };
    h.fn.lookup.parseOptions = function(e) {
        return h.extend({}, h.fn.comboq.parseOptions(e), h.fn.datagrid.parseOptions(e), h.parser.parseOptions(e, [ "idField", "textField", "mode", {
            isCombo: "boolean",
            minQueryLen: "number"
        } ]));
    };
    h.fn.lookup.defaults = h.extend({}, h.fn.comboq.defaults, h.fn.datagrid.defaults, {
        loadMsg: null,
        idField: null,
        textField: null,
        mode: "local",
        keyHandler: {
            up: function(e) {
                t(this, "prev");
                e.preventDefault();
            },
            down: function(e) {
                t(this, "next");
                e.preventDefault();
            },
            left: function(e) {},
            right: function(e) {},
            enter: function(e) {
                i(this, e);
            },
            query: function(e, t) {
                c(this, e, t);
            },
            pageUp: function(e) {
                a(this, "prev");
                e.preventDefault();
            },
            pageDown: function(e) {
                a(this, "next");
                e.preventDefault();
            }
        },
        filter: function(e, t) {
            var a = h(this).lookup("options");
            return t[a.textField].toLowerCase().indexOf(e.toLowerCase()) == 0;
        },
        onShowPanel: function() {},
        onHidePanel: function() {},
        onChange: function(e, t) {},
        panelWidth: 350,
        panelHeight: 200,
        panelAlign: "left",
        selectOnNavigation: false,
        separator: ",",
        isCombo: false,
        minQueryLen: 0,
        queryOnSameQueryString: true,
        enableNumberEvent: false,
        onBeforeShowPanel: function() {},
        selectRowRender: function(e) {}
    });
})(jQuery);

(function(o) {
    function s(e, t) {
        var a = o.data(e, "keywords").options;
        var i = a.items;
        var n = t.split("-");
        if (n.length == 1) {
            return i[n[0]];
        }
        if (n.length == 2) {
            return i[n[0]].items[n[1]];
        }
        if (n.length == 3) {
            return i[n[0]].items[n[1]].items[n[2]];
        }
    }
    function a(i) {
        var e = o(i).empty();
        var t = o.data(i, "keywords").options;
        if (t.labelCls != "blue") e.addClass("keywords-label" + t.labelCls);
        var r = "";
        o.each(t.items, function(n, a) {
            if (a.type == "chapter") {
                r += '<div class="kw-chapter">';
                if (a.text != "") r += "<a></a>" + a.text;
                r += '</div><div class="kw-line"></div>';
                o.each(a.items, function(i, e) {
                    if (e.type == "section") {
                        r += '<div class="kw-section"><div class="kw-section-header">' + e.text + "</div>";
                        if (e.items) {
                            r += '<ul class="kw-section-list keywords">';
                        }
                        o.each(e.items, function(e, t) {
                            var a = t.selected ? 'class="selected"' : "";
                            r += '<li id="' + (t.id || t.text) + '" rowid="' + n + "-" + i + "-" + e + '" ' + a + "><a>" + t.text + "</a></li>";
                        });
                        if (e.items) {
                            r += "</ul>";
                        }
                        r += "</div>";
                    } else {
                        if (i == 0) {
                            r += '<ul class="kw-section-list keywords">';
                        }
                        var t = e.selected ? 'class="selected"' : "";
                        r += '<li id="' + (e.id || e.text) + '" rowid="' + n + "-" + i + '" ' + t + "><a>" + e.text + "</a></li>";
                        if (i == a.items.length - 1) r += "</ul>";
                    }
                });
            } else if (a.type == "section") {
                r += '<div class="kw-section"><div class="kw-section-header">' + a.text + "</div>";
                if (a.items) {
                    r += '<ul class="kw-section-list keywords">';
                }
                o.each(a.items, function(e, t) {
                    var a = t.selected ? 'class="selected"' : "";
                    r += '<li id="' + (t.id || t.text) + '" rowid="' + n + "-" + e + '" ' + a + "><a>" + t.text + "</a></li>";
                });
                if (a.items) {
                    r += "</ul>";
                }
                r += "</div>";
            } else {
                if (n == 0) {
                    r += '<ul class="kw-section-list keywords">';
                }
                var e = a.selected ? 'class="selected"' : "";
                r += '<li id="' + (a.id || a.text) + '" rowid="' + n + '" ' + e + "><a>" + a.text + "</a></li>";
                if (n == t.items.length - 1) r += "</ul>";
            }
        });
        e.append(r);
        e.off("click").on("click", "ul.kw-section-list>li", function(e, t) {
            var a = o(this).attr("id");
            n(i, a);
            return false;
        });
    }
    o.fn.keywords = function(t, e) {
        if (typeof t == "string") {
            return o.fn.keywords.methods[t](this, e);
        }
        t = t || {};
        return this.each(function() {
            var e = o.data(this, "keywords");
            if (e) {
                o.extend(e.options, t);
            } else {
                o.data(this, "keywords", {
                    options: o.extend({}, o.fn.keywords.defaults, o.fn.keywords.parseOptions(this), t)
                });
            }
            a(this);
        });
    };
    function n(e, t) {
        var a = o(e);
        var i = o.data(e, "keywords").options;
        if (i.singleSelect) {
            a.find("li.selected").removeClass("selected");
        }
        var n = a.find("li#" + t);
        n.toggleClass("selected");
        var r = s(e, n.attr("rowid"));
        i.onClick.call(this, r);
        if (!i.singleSelect) {
            if (n.hasClass("selected")) {
                i.onSelect.call(this, r);
            } else {
                i.onUnselect.call(this, r);
            }
        }
    }
    function i(e) {
        console.log(e);
        o(e).find("li.selected").removeClass("selected");
    }
    function t(e) {
        var t = [];
        o(e).find("li.selected").each(function() {
            t.push(s(e, o(this).attr("rowid")));
        });
        return t;
    }
    o.fn.keywords.methods = {
        options: function(e) {
            return o.data(e[0], "keywords").options;
        },
        getSelected: function(e) {
            return t(e[0]);
        },
        select: function(e, t) {
            return n(e[0], t);
        },
        switchById: function(e, t) {
            return n(e[0], t);
        },
        clearAllSelected: function(e, t) {
            e.each(function(e, t) {
                i(t);
            });
        }
    };
    o.fn.keywords.parseOptions = function(e) {
        var t = o(e);
        return o.extend({}, o.parser.parseOptions(e, [ "id", "iconCls", "iconAlign", "group", "size", {
            plain: "boolean",
            toggle: "boolean",
            selected: "boolean"
        } ]), {
            disabled: t.attr("disabled") ? true : undefined
        });
    };
    o.fn.keywords.defaults = {
        singleSelect: false,
        labelCls: "blue",
        onClick: function(e) {},
        onUnselect: function(e) {},
        onSelect: function(e) {}
    };
})(jQuery);

(function($) {
    function init(e) {
        $(e).addClass("triggerbox-f").hide();
        var t = $('<span class="triggerbox"></span>').insertAfter(e);
        var a = $('<input type="text" class="triggerbox-text">').appendTo(t);
        $('<span><span class="triggerbox-button"></span></span>').appendTo(t);
        var i = $(e).attr("name");
        if (i) {
            a.attr("name", i);
            $(e).removeAttr("name").attr("triggerboxName", i);
        }
        return t;
    }
    function _3fe(e, t) {
        var a = $.data(e, "triggerbox").options;
        var i = $.data(e, "triggerbox").triggerbox;
        if (t) {
            a.width = t;
        }
        i.appendTo("body");
        if (isNaN(a.width)) {
            a.width = i._outerWidth();
        }
        var n = i.find("span.triggerbox-button");
        if (n && "string" == typeof a.icon) {
            n.addClass(a.icon);
        }
        var r = i.find("input.triggerbox-text");
        i._outerWidth(a.width)._outerHeight(a.height);
        r._outerWidth(i.width() - n._outerWidth());
        r.css({
            height: i.height() + "px",
            lineHeight: i.height() + "px"
        });
        n._outerHeight(i.height());
        i.insertAfter(e);
        if (!a.plain && i.hasClass("triggerbox-plain")) i.removeClass("triggerbox-plain");
        if (a.plain && !i.hasClass("triggerbox-plain")) i.addClass("triggerbox-plain");
    }
    function _409(e) {
        var t = $.data(e, "triggerbox");
        var a = t.options;
        var i = t.triggerbox.find("input.triggerbox-text");
        var n = t.triggerbox.find(".triggerbox-button");
        i.unbind(".triggerbox");
        n.unbind(".triggerbox");
        if (!a.disabled) {
            i.bind("blur.triggerbox", function(e) {
                a.value = $(this).val();
                if (a.value == "") {
                    $(this).val(a.prompt);
                    $(this).addClass("triggerbox-prompt");
                } else {
                    $(this).removeClass("triggerbox-prompt");
                }
            }).bind("focus.triggerbox", function(e) {
                if ($(this).val() != a.value) {
                    $(this).val(a.value);
                }
                $(this).removeClass("triggerbox-prompt");
            });
            n.bind("click.triggerbox", function() {
                a.handler.call(e, a.value, i._propAttr("name"));
            }).bind("mouseenter.triggerbox", function() {
                $(this).addClass("triggerbox-button-hover");
            }).bind("mouseleave.triggerbox", function() {
                $(this).removeClass("triggerbox-button-hover");
            });
        }
    }
    function _40e(e, t) {
        var a = $.data(e, "triggerbox");
        var i = a.options;
        var n = a.triggerbox.find("input.triggerbox-text");
        if (t) {
            i.disabled = true;
            $(e).attr("disabled", true);
            n.attr("disabled", true);
            a.triggerbox.addClass("disabled");
        } else {
            i.disabled = false;
            $(e).removeAttr("disabled");
            n.removeAttr("disabled");
            a.triggerbox.removeClass("disabled");
        }
    }
    function _413(e) {
        var t = $.data(e, "triggerbox");
        var a = t.options;
        var i = t.triggerbox.find("input.triggerbox-text");
        a.originalValue = a.value;
        if (a.value) {
            i.val(a.value);
            i.removeClass("triggerbox-prompt");
        } else {
            i.val(a.prompt);
            i.addClass("triggerbox-prompt");
        }
    }
    $.fn.triggerbox = function(a, e) {
        if (typeof a == "string") {
            return $.fn.triggerbox.methods[a](this, e);
        }
        a = a || {};
        return this.each(function() {
            var e = $.data(this, "triggerbox");
            if (e) {
                $.extend(e.options, a);
            } else {
                var t = $.extend({}, $.fn.triggerbox.parseOptions(this), a);
                if (typeof t.icon == "undefined" && typeof t.plain == "undefined") {
                    t.icon = "icon-trigger-box";
                    t.plain = true;
                }
                e = $.data(this, "triggerbox", {
                    options: $.extend({}, $.fn.triggerbox.defaults, t),
                    triggerbox: init(this)
                });
            }
            _413(this);
            _409(this);
            _40e(this, e.options.disabled);
            _3fe(this);
        });
    };
    $.fn.triggerbox.methods = {
        options: function(e) {
            return $.data(e[0], "triggerbox").options;
        },
        textbox: function(e) {
            return $.data(e[0], "triggerbox").triggerbox.find("input.triggerbox-text");
        },
        getValue: function(e) {
            return $.data(e[0], "triggerbox").options.value;
        },
        setValue: function(e, t) {
            return e.each(function() {
                $(this).triggerbox("options").value = t;
                $(this).triggerbox("textbox").val(t);
                $(this).triggerbox("textbox").blur();
            });
        },
        clear: function(e) {
            return e.each(function() {
                $(this).triggerbox("setValue", "");
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = $(this).triggerbox("options");
                $(this).triggerbox("setValue", e.originalValue);
            });
        },
        getName: function(e) {
            return $.data(e[0], "triggerbox").triggerbox.find("input.triggerbox-text").attr("name");
        },
        destroy: function(e) {
            return e.each(function() {
                $.data(this, "triggerbox").triggerbox.remove();
                $(this).remove();
            });
        },
        resize: function(e, t) {
            return e.each(function() {
                _3fe(this, t);
            });
        },
        disable: function(e) {
            return e.each(function() {
                _40e(this, true);
                _409(this);
            });
        },
        enable: function(e) {
            return e.each(function() {
                _40e(this, false);
                _409(this);
            });
        }
    };
    $.fn.triggerbox.parseOptions = function(_41c) {
        var t = $(_41c);
        var w = t._outerWidth();
        return $.extend({}, $.parser.parseOptions(_41c, [ "width", "height", "prompt", {
            plain: "boolean"
        } ]), {
            width: w,
            value: t.val() || undefined,
            disabled: t.attr("disabled") ? true : undefined,
            handler: t.attr("handler") ? eval(t.attr("handler")) : undefined
        });
    };
    $.fn.triggerbox.defaults = {
        icon: "icon-w-trigger-box",
        width: "auto",
        height: 30,
        prompt: "",
        value: "",
        disabled: false,
        handler: function(e, t) {},
        plain: false
    };
})(jQuery);

(function(i) {
    var a = "YDYQSXMWZSSXJBYMGCCZQPSSQBYCDSCDQLDYLYBSSJGYZZJJFKCCLZDHWDWZJLJPFYYNWJJTMYHZWZHFLZPPQHGSCYYYNJQYXXGJHHSDSJNKKTMOMLCRXYPSNQSECCQZGGLLYJLMYZZSECYKYYHQWJSSGGYXYZYJWWKDJHYCHMYXJTLXJYQBYXZLDWRDJRWYSRLDZJPCBZJJBRCFTLECZSTZFXXZHTRQHYBDLYCZSSYMMRFMYQZPWWJJYFCRWFDFZQPYDDWYXKYJAWJFFXYPSFTZYHHYZYSWCJYXSCLCXXWZZXNBGNNXBXLZSZSBSGPYSYZDHMDZBQBZCWDZZYYTZHBTSYYBZGNTNXQYWQSKBPHHLXGYBFMJEBJHHGQTJCYSXSTKZHLYCKGLYSMZXYALMELDCCXGZYRJXSDLTYZCQKCNNJWHJTZZCQLJSTSTBNXBTYXCEQXGKWJYFLZQLYHYXSPSFXLMPBYSXXXYDJCZYLLLSJXFHJXPJBTFFYABYXBHZZBJYZLWLCZGGBTSSMDTJZXPTHYQTGLJSCQFZKJZJQNLZWLSLHDZBWJNCJZYZSQQYCQYRZCJJWYBRTWPYFTWEXCSKDZCTBZHYZZYYJXZCFFZZMJYXXSDZZOTTBZLQWFCKSZSXFYRLNYJMBDTHJXSQQCCSBXYYTSYFBXDZTGBCNSLCYZZPSAZYZZSCJCSHZQYDXLBPJLLMQXTYDZXSQJTZPXLCGLQTZWJBHCTSYJSFXYEJJTLBGXSXJMYJQQPFZASYJNTYDJXKJCDJSZCBARTDCLYJQMWNQNCLLLKBYBZZSYHQQLTWLCCXTXLLZNTYLNEWYZYXCZXXGRKRMTCNDNJTSYYSSDQDGHSDBJGHRWRQLYBGLXHLGTGXBQJDZPYJSJYJCTMRNYMGRZJCZGJMZMGXMPRYXKJNYMSGMZJYMKMFXMLDTGFBHCJHKYLPFMDXLQJJSMTQGZSJLQDLDGJYCALCMZCSDJLLNXDJFFFFJCZFMZFFPFKHKGDPSXKTACJDHHZDDCRRCFQYJKQCCWJDXHWJLYLLZGCFCQDSMLZPBJJPLSBCJGGDCKKDEZSQCCKJGCGKDJTJDLZYCXKLQSCGJCLTFPCQCZGWPJDQYZJJBYJHSJDZWGFSJGZKQCCZLLPSPKJGQJHZZLJPLGJGJJTHJJYJZCZMLZLYQBGJWMLJKXZDZNJQSYZMLJLLJKYWXMKJLHSKJGBMCLYYMKXJQLBMLLKMDXXKWYXYSLMLPSJQQJQXYXFJTJDXMXXLLCXQBSYJBGWYMBGGBCYXPJYGPEPFGDJGBHBNSQJYZJKJKHXQFGQZKFHYGKHDKLLSDJQXPQYKYBNQSXQNSZSWHBSXWHXWBZZXDMNSJBSBKBBZKLYLXGWXDRWYQZMYWSJQLCJXXJXKJEQXSCYETLZHLYYYSDZPAQYZCMTLSHTZCFYZYXYLJSDCJQAGYSLCQLYYYSHMRQQKLDXZSCSSSYDYCJYSFSJBFRSSZQSBXXPXJYSDRCKGJLGDKZJZBDKTCSYQPYHSTCLDJDHMXMCGXYZHJDDTMHLTXZXYLYMOHYJCLTYFBQQXPFBDFHHTKSQHZYYWCNXXCRWHOWGYJLEGWDQCWGFJYCSNTMYTOLBYGWQWESJPWNMLRYDZSZTXYQPZGCWXHNGPYXSHMYQJXZTDPPBFYHZHTJYFDZWKGKZBLDNTSXHQEEGZZYLZMMZYJZGXZXKHKSTXNXXWYLYAPSTHXDWHZYMPXAGKYDXBHNHXKDPJNMYHYLPMGOCSLNZHKXXLPZZLBMLSFBHHGYGYYGGBHSCYAQTYWLXTZQCEZYDQDQMMHTKLLSZHLSJZWFYHQSWSCWLQAZYNYTLSXTHAZNKZZSZZLAXXZWWCTGQQTDDYZTCCHYQZFLXPSLZYGPZSZNGLNDQTBDLXGTCTAJDKYWNSYZLJHHZZCWNYYZYWMHYCHHYXHJKZWSXHZYXLYSKQYSPSLYZWMYPPKBYGLKZHTYXAXQSYSHXASMCHKDSCRSWJPWXSGZJLWWSCHSJHSQNHCSEGNDAQTBAALZZMSSTDQJCJKTSCJAXPLGGXHHGXXZCXPDMMHLDGTYBYSJMXHMRCPXXJZCKZXSHMLQXXTTHXWZFKHCCZDYTCJYXQHLXDHYPJQXYLSYYDZOZJNYXQEZYSQYAYXWYPDGXDDXSPPYZNDLTWRHXYDXZZJHTCXMCZLHPYYYYMHZLLHNXMYLLLMDCPPXHMXDKYCYRDLTXJCHHZZXZLCCLYLNZSHZJZZLNNRLWHYQSNJHXYNTTTKYJPYCHHYEGKCTTWLGQRLGGTGTYGYHPYHYLQYQGCWYQKPYYYTTTTLHYHLLTYTTSPLKYZXGZWGPYDSSZZDQXSKCQNMJJZZBXYQMJRTFFBTKHZKBXLJJKDXJTLBWFZPPTKQTZTGPDGNTPJYFALQMKGXBDCLZFHZCLLLLADPMXDJHLCCLGYHDZFGYDDGCYYFGYDXKSSEBDHYKDKDKHNAXXYBPBYYHXZQGAFFQYJXDMLJCSQZLLPCHBSXGJYNDYBYQSPZWJLZKSDDTACTBXZDYZYPJZQSJNKKTKNJDJGYYPGTLFYQKASDNTCYHBLWDZHBBYDWJRYGKZYHEYYFJMSDTYFZJJHGCXPLXHLDWXXJKYTCYKSSSMTWCTTQZLPBSZDZWZXGZAGYKTYWXLHLSPBCLLOQMMZSSLCMBJCSZZKYDCZJGQQDSMCYTZQQLWZQZXSSFPTTFQMDDZDSHDTDWFHTDYZJYQJQKYPBDJYYXTLJHDRQXXXHAYDHRJLKLYTWHLLRLLRCXYLBWSRSZZSYMKZZHHKYHXKSMDSYDYCJPBZBSQLFCXXXNXKXWYWSDZYQOGGQMMYHCDZTTFJYYBGSTTTYBYKJDHKYXBELHTYPJQNFXFDYKZHQKZBYJTZBXHFDXKDASWTAWAJLDYJSFHBLDNNTNQJTJNCHXFJSRFWHZFMDRYJYJWZPDJKZYJYMPCYZNYNXFBYTFYFWYGDBNZZZDNYTXZEMMQBSQEHXFZMBMFLZZSRXYMJGSXWZJSPRYDJSJGXHJJGLJJYNZZJXHGXKYMLPYYYCXYTWQZSWHWLYRJLPXSLSXMFSWWKLCTNXNYNPSJSZHDZEPTXMYYWXYYSYWLXJQZQXZDCLEEELMCPJPCLWBXSQHFWWTFFJTNQJHJQDXHWLBYZNFJLALKYYJLDXHHYCSTYYWNRJYXYWTRMDRQHWQCMFJDYZMHMYYXJWMYZQZXTLMRSPWWCHAQBXYGZYPXYYRRCLMPYMGKSJSZYSRMYJSNXTPLNBAPPYPYLXYYZKYNLDZYJZCZNNLMZHHARQMPGWQTZMXXMLLHGDZXYHXKYXYCJMFFYYHJFSBSSQLXXNDYCANNMTCJCYPRRNYTYQNYYMBMSXNDLYLYSLJRLXYSXQMLLYZLZJJJKYZZCSFBZXXMSTBJGNXYZHLXNMCWSCYZYFZLXBRNNNYLBNRTGZQYSATSWRYHYJZMZDHZGZDWYBSSCSKXSYHYTXXGCQGXZZSHYXJSCRHMKKBXCZJYJYMKQHZJFNBHMQHYSNJNZYBKNQMCLGQHWLZNZSWXKHLJHYYBQLBFCDSXDLDSPFZPSKJYZWZXZDDXJSMMEGJSCSSMGCLXXKYYYLNYPWWWGYDKZJGGGZGGSYCKNJWNJPCXBJJTQTJWDSSPJXZXNZXUMELPXFSXTLLXCLJXJJLJZXCTPSWXLYDHLYQRWHSYCSQYYBYAYWJJJQFWQCQQCJQGXALDBZZYJGKGXPLTZYFXJLTPADKYQHPMATLCPDCKBMTXYBHKLENXDLEEGQDYMSAWHZMLJTWYGXLYQZLJEEYYBQQFFNLYXRDSCTGJGXYYNKLLYQKCCTLHJLQMKKZGCYYGLLLJDZGYDHZWXPYSJBZKDZGYZZHYWYFQYTYZSZYEZZLYMHJJHTSMQWYZLKYYWZCSRKQYTLTDXWCTYJKLWSQZWBDCQYNCJSRSZJLKCDCDTLZZZACQQZZDDXYPLXZBQJYLZLLLQDDZQJYJYJZYXNYYYNYJXKXDAZWYRDLJYYYRJLXLLDYXJCYWYWNQCCLDDNYYYNYCKCZHXXCCLGZQJGKWPPCQQJYSBZZXYJSQPXJPZBSBDSFNSFPZXHDWZTDWPPTFLZZBZDMYYPQJRSDZSQZSQXBDGCPZSWDWCSQZGMDHZXMWWFYBPDGPHTMJTHZSMMBGZMBZJCFZWFZBBZMQCFMBDMCJXLGPNJBBXGYHYYJGPTZGZMQBQTCGYXJXLWZKYDPDYMGCFTPFXYZTZXDZXTGKMTYBBCLBJASKYTSSQYYMSZXFJEWLXLLSZBQJJJAKLYLXLYCCTSXMCWFKKKBSXLLLLJYXTYLTJYYTDPJHNHNNKBYQNFQYYZBYYESSESSGDYHFHWTCJBSDZZTFDMXHCNJZYMQWSRYJDZJQPDQBBSTJGGFBKJBXTGQHNGWJXJGDLLTHZHHYYYYYYSXWTYYYCCBDBPYPZYCCZYJPZYWCBDLFWZCWJDXXHYHLHWZZXJTCZLCDPXUJCZZZLYXJJTXPHFXWPYWXZPTDZZBDZCYHJHMLXBQXSBYLRDTGJRRCTTTHYTCZWMXFYTWWZCWJWXJYWCSKYBZSCCTZQNHXNWXXKHKFHTSWOCCJYBCMPZZYKBNNZPBZHHZDLSYDDYTYFJPXYNGFXBYQXCBHXCPSXTYZDMKYSNXSXLHKMZXLYHDHKWHXXSSKQYHHCJYXGLHZXCSNHEKDTGZXQYPKDHEXTYKCNYMYYYPKQYYYKXZLTHJQTBYQHXBMYHSQCKWWYLLHCYYLNNEQXQWMCFBDCCMLJGGXDQKTLXKGNQCDGZJWYJJLYHHQTTTNWCHMXCXWHWSZJYDJCCDBQCDGDNYXZTHCQRXCBHZTQCBXWGQWYYBXHMBYMYQTYEXMQKYAQYRGYZSLFYKKQHYSSQYSHJGJCNXKZYCXSBXYXHYYLSTYCXQTHYSMGSCPMMGCCCCCMTZTASMGQZJHKLOSQYLSWTMXSYQKDZLJQQYPLSYCZTCQQPBBQJZCLPKHQZYYXXDTDDTSJCXFFLLCHQXMJLWCJCXTSPYCXNDTJSHJWXDQQJSKXYAMYLSJHMLALYKXCYYDMNMDQMXMCZNNCYBZKKYFLMCHCMLHXRCJJHSYLNMTJZGZGYWJXSRXCWJGJQHQZDQJDCJJZKJKGDZQGJJYJYLXZXXCDQHHHEYTMHLFSBDJSYYSHFYSTCZQLPBDRFRZTZYKYWHSZYQKWDQZRKMSYNBCRXQBJYFAZPZZEDZCJYWBCJWHYJBQSZYWRYSZPTDKZPFPBNZTKLQYHBBZPNPPTYZZYBQNYDCPJMMCYCQMCYFZZDCMNLFPBPLNGQJTBTTNJZPZBBZNJKLJQYLNBZQHKSJZNGGQSZZKYXSHPZSNBCGZKDDZQANZHJKDRTLZLSWJLJZLYWTJNDJZJHXYAYNCBGTZCSSQMNJPJYTYSWXZFKWJQTKHTZPLBHSNJZSYZBWZZZZLSYLSBJHDWWQPSLMMFBJDWAQYZTCJTBNNWZXQXCDSLQGDSDPDZHJTQQPSWLYYJZLGYXYZLCTCBJTKTYCZJTQKBSJLGMGZDMCSGPYNJZYQYYKNXRPWSZXMTNCSZZYXYBYHYZAXYWQCJTLLCKJJTJHGDXDXYQYZZBYWDLWQCGLZGJGQRQZCZSSBCRPCSKYDZNXJSQGXSSJMYDNSTZTPBDLTKZWXQWQTZEXNQCZGWEZKSSBYBRTSSSLCCGBPSZQSZLCCGLLLZXHZQTHCZMQGYZQZNMCOCSZJMMZSQPJYGQLJYJPPLDXRGZYXCCSXHSHGTZNLZWZKJCXTCFCJXLBMQBCZZWPQDNHXLJCTHYZLGYLNLSZZPCXDSCQQHJQKSXZPBAJYEMSMJTZDXLCJYRYYNWJBNGZZTMJXLTBSLYRZPYLSSCNXPHLLHYLLQQZQLXYMRSYCXZLMMCZLTZSDWTJJLLNZGGQXPFSKYGYGHBFZPDKMWGHCXMSGDXJMCJZDYCABXJDLNBCDQYGSKYDQTXDJJYXMSZQAZDZFSLQXYJSJZYLBTXXWXQQZBJZUFBBLYLWDSLJHXJYZJWTDJCZFQZQZZDZSXZZQLZCDZFJHYSPYMPQZMLPPLFFXJJNZZYLSJEYQZFPFZKSYWJJJHRDJZZXTXXGLGHYDXCSKYSWMMZCWYBAZBJKSHFHJCXMHFQHYXXYZFTSJYZFXYXPZLCHMZMBXHZZSXYFYMNCWDABAZLXKTCSHHXKXJJZJSTHYGXSXYYHHHJWXKZXSSBZZWHHHCWTZZZPJXSNXQQJGZYZYWLLCWXZFXXYXYHXMKYYSWSQMNLNAYCYSPMJKHWCQHYLAJJMZXHMMCNZHBHXCLXTJPLTXYJHDYYLTTXFSZHYXXSJBJYAYRSMXYPLCKDUYHLXRLNLLSTYZYYQYGYHHSCCSMZCTZQXKYQFPYYRPFFLKQUNTSZLLZMWWTCQQYZWTLLMLMPWMBZSSTZRBPDDTLQJJBXZCSRZQQYGWCSXFWZLXCCRSZDZMCYGGDZQSGTJSWLJMYMMZYHFBJDGYXCCPSHXNZCSBSJYJGJMPPWAFFYFNXHYZXZYLREMZGZCYZSSZDLLJCSQFNXZKPTXZGXJJGFMYYYSNBTYLBNLHPFZDCYFBMGQRRSSSZXYSGTZRNYDZZCDGPJAFJFZKNZBLCZSZPSGCYCJSZLMLRSZBZZLDLSLLYSXSQZQLYXZLSKKBRXBRBZCYCXZZZEEYFGKLZLYYHGZSGZLFJHGTGWKRAAJYZKZQTSSHJJXDCYZUYJLZYRZDQQHGJZXSSZBYKJPBFRTJXLLFQWJHYLQTYMBLPZDXTZYGBDHZZRBGXHWNJTJXLKSCFSMWLSDQYSJTXKZSCFWJLBXFTZLLJZLLQBLSQMQQCGCZFPBPHZCZJLPYYGGDTGWDCFCZQYYYQYSSCLXZSKLZZZGFFCQNWGLHQYZJJCZLQZZYJPJZZBPDCCMHJGXDQDGDLZQMFGPSYTSDYFWWDJZJYSXYYCZCYHZWPBYKXRYLYBHKJKSFXTZJMMCKHLLTNYYMSYXYZPYJQYCSYCWMTJJKQYRHLLQXPSGTLYYCLJSCPXJYZFNMLRGJJTYZBXYZMSJYJHHFZQMSYXRSZCWTLRTQZSSTKXGQKGSPTGCZNJSJCQCXHMXGGZTQYDJKZDLBZSXJLHYQGGGTHQSZPYHJHHGYYGKGGCWJZZYLCZLXQSFTGZSLLLMLJSKCTBLLZZSZMMNYTPZSXQHJCJYQXYZXZQZCPSHKZZYSXCDFGMWQRLLQXRFZTLYSTCTMJCXJJXHJNXTNRZTZFQYHQGLLGCXSZSJDJLJCYDSJTLNYXHSZXCGJZYQPYLFHDJSBPCCZHJJJQZJQDYBSSLLCMYTTMQTBHJQNNYGKYRQYQMZGCJKPDCGMYZHQLLSLLCLMHOLZGDYYFZSLJCQZLYLZQJESHNYLLJXGJXLYSYYYXNBZLJSSZCQQCJYLLZLTJYLLZLLBNYLGQCHXYYXOXCXQKYJXXXYKLXSXXYQXCYKQXQCSGYXXYQXYGYTQOHXHXPYXXXULCYEYCHZZCBWQBBWJQZSCSZSSLZYLKDESJZWMYMCYTSDSXXSCJPQQSQYLYYZYCMDJDZYWCBTJSYDJKCYDDJLBDJJSODZYSYXQQYXDHHGQQYQHDYXWGMMMAJDYBBBPPBCMUUPLJZSMTXERXJMHQNUTPJDCBSSMSSSTKJTSSMMTRCPLZSZMLQDSDMJMQPNQDXCFYNBFSDQXYXHYAYKQYDDLQYYYSSZBYDSLNTFQTZQPZMCHDHCZCWFDXTMYQSPHQYYXSRGJCWTJTZZQMGWJJTJHTQJBBHWZPXXHYQFXXQYWYYHYSCDYDHHQMNMTMWCPBSZPPZZGLMZFOLLCFWHMMSJZTTDHZZYFFYTZZGZYSKYJXQYJZQBHMBZZLYGHGFMSHPZFZSNCLPBQSNJXZSLXXFPMTYJYGBXLLDLXPZJYZJYHHZCYWHJYLSJEXFSZZYWXKZJLUYDTMLYMQJPWXYHXSKTQJEZRPXXZHHMHWQPWQLYJJQJJZSZCPHJLCHHNXJLQWZJHBMZYXBDHHYPZLHLHLGFWLCHYYTLHJXCJMSCPXSTKPNHQXSRTYXXTESYJCTLSSLSTDLLLWWYHDHRJZSFGXTSYCZYNYHTDHWJSLHTZDQDJZXXQHGYLTZPHCSQFCLNJTCLZPFSTPDYNYLGMJLLYCQHYSSHCHYLHQYQTMZYPBYWRFQYKQSYSLZDQJMPXYYSSRHZJNYWTQDFZBWWTWWRXCWHGYHXMKMYYYQMSMZHNGCEPMLQQMTCWCTMMPXJPJJHFXYYZSXZHTYBMSTSYJTTQQQYYLHYNPYQZLCYZHZWSMYLKFJXLWGXYPJYTYSYXYMZCKTTWLKSMZSYLMPWLZWXWQZSSAQSYXYRHSSNTSRAPXCPWCMGDXHXZDZYFJHGZTTSBJHGYZSZYSMYCLLLXBTYXHBBZJKSSDMALXHYCFYGMQYPJYCQXJLLLJGSLZGQLYCJCCZOTYXMTMTTLLWTGPXYMZMKLPSZZZXHKQYSXCTYJZYHXSHYXZKXLZWPSQPYHJWPJPWXQQYLXSDHMRSLZZYZWTTCYXYSZZSHBSCCSTPLWSSCJCHNLCGCHSSPHYLHFHHXJSXYLLNYLSZDHZXYLSXLWZYKCLDYAXZCMDDYSPJTQJZLNWQPSSSWCTSTSZLBLNXSMNYYMJQBQHRZWTYYDCHQLXKPZWBGQYBKFCMZWPZLLYYLSZYDWHXPSBCMLJBSCGBHXLQHYRLJXYSWXWXZSLDFHLSLYNJLZYFLYJYCDRJLFSYZFSLLCQYQFGJYHYXZLYLMSTDJCYHBZLLNWLXXYGYYHSMGDHXXHHLZZJZXCZZZCYQZFNGWPYLCPKPYYPMCLQKDGXZGGWQBDXZZKZFBXXLZXJTPJPTTBYTSZZDWSLCHZHSLTYXHQLHYXXXYYZYSWTXZKHLXZXZPYHGCHKCFSYHUTJRLXFJXPTZTWHPLYXFCRHXSHXKYXXYHZQDXQWULHYHMJTBFLKHTXCWHJFWJCFPQRYQXCYYYQYGRPYWSGSUNGWCHKZDXYFLXXHJJBYZWTSXXNCYJJYMSWZJQRMHXZWFQSYLZJZGBHYNSLBGTTCSYBYXXWXYHXYYXNSQYXMQYWRGYQLXBBZLJSYLPSYTJZYHYZAWLRORJMKSCZJXXXYXCHDYXRYXXJDTSQFXLYLTSFFYXLMTYJMJUYYYXLTZCSXQZQHZXLYYXZHDNBRXXXJCTYHLBRLMBRLLAXKYLLLJLYXXLYCRYLCJTGJCMTLZLLCYZZPZPCYAWHJJFYBDYYZSMPCKZDQYQPBPCJPDCYZMDPBCYYDYCNNPLMTMLRMFMMGWYZBSJGYGSMZQQQZTXMKQWGXLLPJGZBQCDJJJFPKJKCXBLJMSWMDTQJXLDLPPBXCWRCQFBFQJCZAHZGMYKPHYYHZYKNDKZMBPJYXPXYHLFPNYYGXJDBKXNXHJMZJXSTRSTLDXSKZYSYBZXJLXYSLBZYSLHXJPFXPQNBYLLJQKYGZMCYZZYMCCSLCLHZFWFWYXZMWSXTYNXJHPYYMCYSPMHYSMYDYSHQYZCHMJJMZCAAGCFJBBHPLYZYLXXSDJGXDHKXXTXXNBHRMLYJSLTXMRHNLXQJXYZLLYSWQGDLBJHDCGJYQYCMHWFMJYBMBYJYJWYMDPWHXQLDYGPDFXXBCGJSPCKRSSYZJMSLBZZJFLJJJLGXZGYXYXLSZQYXBEXYXHGCXBPLDYHWETTWWCJMBTXCHXYQXLLXFLYXLLJLSSFWDPZSMYJCLMWYTCZPCHQEKCQBWLCQYDPLQPPQZQFJQDJHYMMCXTXDRMJWRHXCJZYLQXDYYNHYYHRSLSRSYWWZJYMTLTLLGTQCJZYABTCKZCJYCCQLJZQXALMZYHYWLWDXZXQDLLQSHGPJFJLJHJABCQZDJGTKHSSTCYJLPSWZLXZXRWGLDLZRLZXTGSLLLLZLYXXWGDZYGBDPHZPBRLWSXQBPFDWOFMWHLYPCBJCCLDMBZPBZZLCYQXLDOMZBLZWPDWYYGDSTTHCSQSCCRSSSYSLFYBFNTYJSZDFNDPDHDZZMBBLSLCMYFFGTJJQWFTMTPJWFNLBZCMMJTGBDZLQLPYFHYYMJYLSDCHDZJWJCCTLJCLDTLJJCPDDSQDSSZYBNDBJLGGJZXSXNLYCYBJXQYCBYLZCFZPPGKCXZDZFZTJJFJSJXZBNZYJQTTYJYHTYCZHYMDJXTTMPXSPLZCDWSLSHXYPZGTFMLCJTYCBPMGDKWYCYZCDSZZYHFLYCTYGWHKJYYLSJCXGYWJCBLLCSNDDBTZBSCLYZCZZSSQDLLMQYYHFSLQLLXFTYHABXGWNYWYYPLLSDLDLLBJCYXJZMLHLJDXYYQYTDLLLBUGBFDFBBQJZZMDPJHGCLGMJJPGAEHHBWCQXAXHHHZCHXYPHJAXHLPHJPGPZJQCQZGJJZZUZDMQYYBZZPHYHYBWHAZYJHYKFGDPFQSDLZMLJXKXGALXZDAGLMDGXMWZQYXXDXXPFDMMSSYMPFMDMMKXKSYZYSHDZKXSYSMMZZZMSYDNZZCZXFPLSTMZDNMXCKJMZTYYMZMZZMSXHHDCZJEMXXKLJSTLWLSQLYJZLLZJSSDPPMHNLZJCZYHMXXHGZCJMDHXTKGRMXFWMCGMWKDTKSXQMMMFZZYDKMSCLCMPCGMHSPXQPZDSSLCXKYXTWLWJYAHZJGZQMCSNXYYMMPMLKJXMHLMLQMXCTKZMJQYSZJSYSZHSYJZJCDAJZYBSDQJZGWZQQXFKDMSDJLFWEHKZQKJPEYPZYSZCDWYJFFMZZYLTTDZZEFMZLBNPPLPLPEPSZALLTYLKCKQZKGENQLWAGYXYDPXLHSXQQWQCQXQCLHYXXMLYCCWLYMQYSKGCHLCJNSZKPYZKCQZQLJPDMDZHLASXLBYDWQLWDNBQCRYDDZTJYBKBWSZDXDTNPJDTCTQDFXQQMGNXECLTTBKPWSLCTYQLPWYZZKLPYGZCQQPLLKCCYLPQMZCZQCLJSLQZDJXLDDHPZQDLJJXZQDXYZQKZLJCYQDYJPPYPQYKJYRMPCBYMCXKLLZLLFQPYLLLMBSGLCYSSLRSYSQTMXYXZQZFDZUYSYZTFFMZZSMZQHZSSCCMLYXWTPZGXZJGZGSJSGKDDHTQGGZLLBJDZLCBCHYXYZHZFYWXYZYMSDBZZYJGTSMTFXQYXQSTDGSLNXDLRYZZLRYYLXQHTXSRTZNGZXBNQQZFMYKMZJBZYMKBPNLYZPBLMCNQYZZZSJZHJCTZKHYZZJRDYZHNPXGLFZTLKGJTCTSSYLLGZRZBBQZZKLPKLCZYSSUYXBJFPNJZZXCDWXZYJXZZDJJKGGRSRJKMSMZJLSJYWQSKYHQJSXPJZZZLSNSHRNYPZTWCHKLPSRZLZXYJQXQKYSJYCZTLQZYBBYBWZPQDWWYZCYTJCJXCKCWDKKZXSGKDZXWWYYJQYYTCYTDLLXWKCZKKLCCLZCQQDZLQLCSFQCHQHSFSMQZZLNBJJZBSJHTSZDYSJQJPDLZCDCWJKJZZLPYCGMZWDJJBSJQZSYZYHHXJPBJYDSSXDZNCGLQMBTSFSBPDZDLZNFGFJGFSMPXJQLMBLGQCYYXBQKDJJQYRFKZTJDHCZKLBSDZCFJTPLLJGXHYXZCSSZZXSTJYGKGCKGYOQXJPLZPBPGTGYJZGHZQZZLBJLSQFZGKQQJZGYCZBZQTLDXRJXBSXXPZXHYZYCLWDXJJHXMFDZPFZHQHQMQGKSLYHTYCGFRZGNQXCLPDLBZCSCZQLLJBLHBZCYPZZPPDYMZZSGYHCKCPZJGSLJLNSCDSLDLXBMSTLDDFJMKDJDHZLZXLSZQPQPGJLLYBDSZGQLBZLSLKYYHZTTNTJYQTZZPSZQZTLLJTYYLLQLLQYZQLBDZLSLYYZYMDFSZSNHLXZNCZQZPBWSKRFBSYZMTHBLGJPMCZZLSTLXSHTCSYZLZBLFEQHLXFLCJLYLJQCBZLZJHHSSTBRMHXZHJZCLXFNBGXGTQJCZTMSFZKJMSSNXLJKBHSJXNTNLZDNTLMSJXGZJYJCZXYJYJWRWWQNZTNFJSZPZSHZJFYRDJSFSZJZBJFZQZZHZLXFYSBZQLZSGYFTZDCSZXZJBQMSZKJRHYJZCKMJKHCHGTXKXQGLXPXFXTRTYLXJXHDTSJXHJZJXZWZLCQSBTXWXGXTXXHXFTSDKFJHZYJFJXRZSDLLLTQSQQZQWZXSYQTWGWBZCGZLLYZBCLMQQTZHZXZXLJFRMYZFLXYSQXXJKXRMQDZDMMYYBSQBHGZMWFWXGMXLZPYYTGZYCCDXYZXYWGSYJYZNBHPZJSQSYXSXRTFYZGRHZTXSZZTHCBFCLSYXZLZQMZLMPLMXZJXSFLBYZMYQHXJSXRXSQZZZSSLYFRCZJRCRXHHZXQYDYHXSJJHZCXZBTYNSYSXJBQLPXZQPYMLXZKYXLXCJLCYSXXZZLXDLLLJJYHZXGYJWKJRWYHCPSGNRZLFZWFZZNSXGXFLZSXZZZBFCSYJDBRJKRDHHGXJLJJTGXJXXSTJTJXLYXQFCSGSWMSBCTLQZZWLZZKXJMLTMJYHSDDBXGZHDLBMYJFRZFSGCLYJBPMLYSMSXLSZJQQHJZFXGFQFQBPXZGYYQXGZTCQWYLTLGWSGWHRLFSFGZJMGMGBGTJFSYZZGZYZAFLSSPMLPFLCWBJZCLJJMZLPJJLYMQDMYYYFBGYGYZMLYZDXQYXRQQQHSYYYQXYLJTYXFSFSLLGNQCYHYCWFHCCCFXPYLYPLLZYXXXXXKQHHXSHJZCFZSCZJXCPZWHHHHHAPYLQALPQAFYHXDYLUKMZQGGGDDESRNNZLTZGCHYPPYSQJJHCLLJTOLNJPZLJLHYMHEYDYDSQYCDDHGZUNDZCLZYZLLZNTNYZGSLHSLPJJBDGWXPCDUTJCKLKCLWKLLCASSTKZZDNQNTTLYYZSSYSSZZRYLJQKCQDHHCRXRZYDGRGCWCGZQFFFPPJFZYNAKRGYWYQPQXXFKJTSZZXSWZDDFBBXTBGTZKZNPZZPZXZPJSZBMQHKCYXYLDKLJNYPKYGHGDZJXXEAHPNZKZTZCMXCXMMJXNKSZQNMNLWBWWXJKYHCPSTMCSQTZJYXTPCTPDTNNPGLLLZSJLSPBLPLQHDTNJNLYYRSZFFJFQWDPHZDWMRZCCLODAXNSSNYZRESTYJWJYJDBCFXNMWTTBYLWSTSZGYBLJPXGLBOCLHPCBJLTMXZLJYLZXCLTPNCLCKXTPZJSWCYXSFYSZDKNTLBYJCYJLLSTGQCBXRYZXBXKLYLHZLQZLNZCXWJZLJZJNCJHXMNZZGJZZXTZJXYCYYCXXJYYXJJXSSSJSTSSTTPPGQTCSXWZDCSYFPTFBFHFBBLZJCLZZDBXGCXLQPXKFZFLSYLTUWBMQJHSZBMDDBCYSCCLDXYCDDQLYJJWMQLLCSGLJJSYFPYYCCYLTJANTJJPWYCMMGQYYSXDXQMZHSZXPFTWWZQSWQRFKJLZJQQYFBRXJHHFWJJZYQAZMYFRHCYYBYQWLPEXCCZSTYRLTTDMQLYKMBBGMYYJPRKZNPBSXYXBHYZDJDNGHPMFSGMWFZMFQMMBCMZZCJJLCNUXYQLMLRYGQZCYXZLWJGCJCGGMCJNFYZZJHYCPRRCMTZQZXHFQGTJXCCJEAQCRJYHPLQLSZDJRBCQHQDYRHYLYXJSYMHZYDWLDFRYHBPYDTSSCNWBXGLPZMLZZTQSSCPJMXXYCSJYTYCGHYCJWYRXXLFEMWJNMKLLSWTXHYYYNCMMCWJDQDJZGLLJWJRKHPZGGFLCCSCZMCBLTBHBQJXQDSPDJZZGKGLFQYWBZYZJLTSTDHQHCTCBCHFLQMPWDSHYYTQWCNZZJTLBYMBPDYYYXSQKXWYYFLXXNCWCXYPMAELYKKJMZZZBRXYYQJFLJPFHHHYTZZXSGQQMHSPGDZQWBWPJHZJDYSCQWZKTXXSQLZYYMYSDZGRXCKKUJLWPYSYSCSYZLRMLQSYLJXBCXTLWDQZPCYCYKPPPNSXFYZJJRCEMHSZMSXLXGLRWGCSTLRSXBZGBZGZTCPLUJLSLYLYMTXMTZPALZXPXJTJWTCYYZLBLXBZLQMYLXPGHDSLSSDMXMBDZZSXWHAMLCZCPJMCNHJYSNSYGCHSKQMZZQDLLKABLWJXSFMOCDXJRRLYQZKJMYBYQLYHETFJZFRFKSRYXFJTWDSXXSYSQJYSLYXWJHSNLXYYXHBHAWHHJZXWMYLJCSSLKYDZTXBZSYFDXGXZJKHSXXYBSSXDPYNZWRPTQZCZENYGCXQFJYKJBZMLJCMQQXUOXSLYXXLYLLJDZBTYMHPFSTTQQWLHOKYBLZZALZXQLHZWRRQHLSTMYPYXJJXMQSJFNBXYXYJXXYQYLTHYLQYFMLKLJTMLLHSZWKZHLJMLHLJKLJSTLQXYLMBHHLNLZXQJHXCFXXLHYHJJGBYZZKBXSCQDJQDSUJZYYHZHHMGSXCSYMXFEBCQWWRBPYYJQTYZCYQYQQZYHMWFFHGZFRJFCDPXNTQYZPDYKHJLFRZXPPXZDBBGZQSTLGDGYLCQMLCHHMFYWLZYXKJLYPQHSYWMQQGQZMLZJNSQXJQSYJYCBEHSXFSZPXZWFLLBCYYJDYTDTHWZSFJMQQYJLMQXXLLDTTKHHYBFPWTYYSQQWNQWLGWDEBZWCMYGCULKJXTMXMYJSXHYBRWFYMWFRXYQMXYSZTZZTFYKMLDHQDXWYYNLCRYJBLPSXCXYWLSPRRJWXHQYPHTYDNXHHMMYWYTZCSQMTSSCCDALWZTCPQPYJLLQZYJSWXMZZMMYLMXCLMXCZMXMZSQTZPPQQBLPGXQZHFLJJHYTJSRXWZXSCCDLXTYJDCQJXSLQYCLZXLZZXMXQRJMHRHZJBHMFLJLMLCLQNLDXZLLLPYPSYJYSXCQQDCMQJZZXHNPNXZMEKMXHYKYQLXSXTXJYYHWDCWDZHQYYBGYBCYSCFGPSJNZDYZZJZXRZRQJJYMCANYRJTLDPPYZBSTJKXXZYPFDWFGZZRPYMTNGXZQBYXNBUFNQKRJQZMJEGRZGYCLKXZDSKKNSXKCLJSPJYYZLQQJYBZSSQLLLKJXTBKTYLCCDDBLSPPFYLGYDTZJYQGGKQTTFZXBDKTYYHYBBFYTYYBCLPDYTGDHRYRNJSPTCSNYJQHKLLLZSLYDXXWBCJQSPXBPJZJCJDZFFXXBRMLAZHCSNDLBJDSZBLPRZTSWSBXBCLLXXLZDJZSJPYLYXXYFTFFFBHJJXGBYXJPMMMPSSJZJMTLYZJXSWXTYLEDQPJMYGQZJGDJLQJWJQLLSJGJGYGMSCLJJXDTYGJQJQJCJZCJGDZZSXQGSJGGCXHQXSNQLZZBXHSGZXCXYLJXYXYYDFQQJHJFXDHCTXJYRXYSQTJXYEFYYSSYYJXNCYZXFXMSYSZXYYSCHSHXZZZGZZZGFJDLTYLNPZGYJYZYYQZPBXQBDZTZCZYXXYHHSQXSHDHGQHJHGYWSZTMZMLHYXGEBTYLZKQWYTJZRCLEKYSTDBCYKQQSAYXCJXWWGSBHJYZYDHCSJKQCXSWXFLTYNYZPZCCZJQTZWJQDZZZQZLJJXLSBHPYXXPSXSHHEZTXFPTLQYZZXHYTXNCFZYYHXGNXMYWXTZSJPTHHGYMXMXQZXTSBCZYJYXXTYYZYPCQLMMSZMJZZLLZXGXZAAJZYXJMZXWDXZSXZDZXLEYJJZQBHZWZZZQTZPSXZTDSXJJJZNYAZPHXYYSRNQDTHZHYYKYJHDZXZLSWCLYBZYECWCYCRYLCXNHZYDZYDYJDFRJJHTRSQTXYXJRJHOJYNXELXSFSFJZGHPZSXZSZDZCQZBYYKLSGSJHCZSHDGQGXYZGXCHXZJWYQWGYHKSSEQZZNDZFKWYSSTCLZSTSYMCDHJXXYWEYXCZAYDMPXMDSXYBSQMJMZJMTZQLPJYQZCGQHXJHHLXXHLHDLDJQCLDWBSXFZZYYSCHTYTYYBHECXHYKGJPXHHYZJFXHWHBDZFYZBCAPNPGNYDMSXHMMMMAMYNBYJTMPXYYMCTHJBZYFCGTYHWPHFTWZZEZSBZEGPFMTSKFTYCMHFLLHGPZJXZJGZJYXZSBBQSCZZLZCCSTPGXMJSFTCCZJZDJXCYBZLFCJSYZFGSZLYBCWZZBYZDZYPSWYJZXZBDSYUXLZZBZFYGCZXBZHZFTPBGZGEJBSTGKDMFHYZZJHZLLZZGJQZLSFDJSSCBZGPDLFZFZSZYZYZSYGCXSNXXCHCZXTZZLJFZGQSQYXZJQDCCZTQCDXZJYQJQCHXZTDLGSCXZSYQJQTZWLQDQZTQCHQQJZYEZZZPBWKDJFCJPZTYPQYQTTYNLMBDKTJZPQZQZZFPZSBNJLGYJDXJDZZKZGQKXDLPZJTCJDQBXDJQJSTCKNXBXZMSLYJCQMTJQWWCJQNJNLLLHJCWQTBZQYDZCZPZZDZYDDCYZZZCCJTTJFZDPRRTZTJDCQTQZDTJNPLZBCLLCTZSXKJZQZPZLBZRBTJDCXFCZDBCCJJLTQQPLDCGZDBBZJCQDCJWYNLLZYZCCDWLLXWZLXRXNTQQCZXKQLSGDFQTDDGLRLAJJTKUYMKQLLTZYTDYYCZGJWYXDXFRSKSTQTENQMRKQZHHQKDLDAZFKYPBGGPZREBZZYKZZSPEGJXGYKQZZZSLYSYYYZWFQZYLZZLZHWCHKYPQGNPGBLPLRRJYXCCSYYHSFZFYBZYYTGZXYLXCZWXXZJZBLFFLGSKHYJZEYJHLPLLLLCZGXDRZELRHGKLZZYHZLYQSZZJZQLJZFLNBHGWLCZCFJYSPYXZLZLXGCCPZBLLCYBBBBUBBCBPCRNNZCZYRBFSRLDCGQYYQXYGMQZWTZYTYJXYFWTEHZZJYWLCCNTZYJJZDEDPZDZTSYQJHDYMBJNYJZLXTSSTPHNDJXXBYXQTZQDDTJTDYYTGWSCSZQFLSHLGLBCZPHDLYZJYCKWTYTYLBNYTSDSYCCTYSZYYEBHEXHQDTWNYGYCLXTSZYSTQMYGZAZCCSZZDSLZCLZRQXYYELJSBYMXSXZTEMBBLLYYLLYTDQYSHYMRQWKFKBFXNXSBYCHXBWJYHTQBPBSBWDZYLKGZSKYHXQZJXHXJXGNLJKZLYYCDXLFYFGHLJGJYBXQLYBXQPQGZTZPLNCYPXDJYQYDYMRBESJYYHKXXSTMXRCZZYWXYQYBMCLLYZHQYZWQXDBXBZWZMSLPDMYSKFMZKLZCYQYCZLQXFZZYDQZPZYGYJYZMZXDZFYFYTTQTZHGSPCZMLCCYTZXJCYTJMKSLPZHYSNZLLYTPZCTZZCKTXDHXXTQCYFKSMQCCYYAZHTJPCYLZLYJBJXTPNYLJYYNRXSYLMMNXJSMYBCSYSYLZYLXJJQYLDZLPQBFZZBLFNDXQKCZFYWHGQMRDSXYCYTXNQQJZYYPFZXDYZFPRXEJDGYQBXRCNFYYQPGHYJDYZXGRHTKYLNWDZNTSMPKLBTHBPYSZBZTJZSZZJTYYXZPHSSZZBZCZPTQFZMYFLYPYBBJQXZMXXDJMTSYSKKBJZXHJCKLPSMKYJZCXTMLJYXRZZQSLXXQPYZXMKYXXXJCLJPRMYYGADYSKQLSNDHYZKQXZYZTCGHZTLMLWZYBWSYCTBHJHJFCWZTXWYTKZLXQSHLYJZJXTMPLPYCGLTBZZTLZJCYJGDTCLKLPLLQPJMZPAPXYZLKKTKDZCZZBNZDYDYQZJYJGMCTXLTGXSZLMLHBGLKFWNWZHDXUHLFMKYSLGXDTWWFRJEJZTZHYDXYKSHWFZCQSHKTMQQHTZHYMJDJSKHXZJZBZZXYMPAGQMSTPXLSKLZYNWRTSQLSZBPSPSGZWYHTLKSSSWHZZLYYTNXJGMJSZSUFWNLSOZTXGXLSAMMLBWLDSZYLAKQCQCTMYCFJBSLXCLZZCLXXKSBZQCLHJPSQPLSXXCKSLNHPSFQQYTXYJZLQLDXZQJZDYYDJNZPTUZDSKJFSLJHYLZSQZLBTXYDGTQFDBYAZXDZHZJNHHQBYKNXJJQCZMLLJZKSPLDYCLBBLXKLELXJLBQYCXJXGCNLCQPLZLZYJTZLJGYZDZPLTQCSXFDMNYCXGBTJDCZNBGBQYQJWGKFHTNPYQZQGBKPBBYZMTJDYTBLSQMPSXTBNPDXKLEMYYCJYNZCTLDYKZZXDDXHQSHDGMZSJYCCTAYRZLPYLTLKXSLZCGGEXCLFXLKJRTLQJAQZNCMBYDKKCXGLCZJZXJHPTDJJMZQYKQSECQZDSHHADMLZFMMZBGNTJNNLGBYJBRBTMLBYJDZXLCJLPLDLPCQDHLXZLYCBLCXZZJADJLNZMMSSSMYBHBSQKBHRSXXJMXSDZNZPXLGBRHWGGFCXGMSKLLTSJYYCQLTSKYWYYHYWXBXQYWPYWYKQLSQPTNTKHQCWDQKTWPXXHCPTHTWUMSSYHBWCRWXHJMKMZNGWTMLKFGHKJYLSYYCXWHYECLQHKQHTTQKHFZLDXQWYZYYDESBPKYRZPJFYYZJCEQDZZDLATZBBFJLLCXDLMJSSXEGYGSJQXCWBXSSZPDYZCXDNYXPPZYDLYJCZPLTXLSXYZYRXCYYYDYLWWNZSAHJSYQYHGYWWAXTJZDAXYSRLTDPSSYYFNEJDXYZHLXLLLZQZSJNYQYQQXYJGHZGZCYJCHZLYCDSHWSHJZYJXCLLNXZJJYYXNFXMWFPYLCYLLABWDDHWDXJMCXZTZPMLQZHSFHZYNZTLLDYWLSLXHYMMYLMBWWKYXYADTXYLLDJPYBPWUXJMWMLLSAFDLLYFLBHHHBQQLTZJCQJLDJTFFKMMMBYTHYGDCQRDDWRQJXNBYSNWZDBYYTBJHPYBYTTJXAAHGQDQTMYSTQXKBTZPKJLZRBEQQSSMJJBDJOTGTBXPGBKTLHQXJJJCTHXQDWJLWRFWQGWSHCKRYSWGFTGYGBXSDWDWRFHWYTJJXXXJYZYSLPYYYPAYXHYDQKXSHXYXGSKQHYWFDDDPPLCJLQQEEWXKSYYKDYPLTJTHKJLTCYYHHJTTPLTZZCDLTHQKZXQYSTEEYWYYZYXXYYSTTJKLLPZMCYHQGXYHSRMBXPLLNQYDQHXSXXWGDQBSHYLLPJJJTHYJKYPPTHYYKTYEZYENMDSHLCRPQFDGFXZPSFTLJXXJBSWYYSKSFLXLPPLBBBLBSFXFYZBSJSSYLPBBFFFFSSCJDSTZSXZRYYSYFFSYZYZBJTBCTSBSDHRTJJBYTCXYJEYLXCBNEBJDSYXYKGSJZBXBYTFZWGENYHHTHZHHXFWGCSTBGXKLSXYWMTMBYXJSTZSCDYQRCYTWXZFHMYMCXLZNSDJTTTXRYCFYJSBSDYERXJLJXBBDEYNJGHXGCKGSCYMBLXJMSZNSKGXFBNBPTHFJAAFXYXFPXMYPQDTZCXZZPXRSYWZDLYBBKTYQPQJPZYPZJZNJPZJLZZFYSBTTSLMPTZRTDXQSJEHBZYLZDHLJSQMLHTXTJECXSLZZSPKTLZKQQYFSYGYWPCPQFHQHYTQXZKRSGTTSQCZLPTXCDYYZXSQZSLXLZMYCPCQBZYXHBSXLZDLTCDXTYLZJYYZPZYZLTXJSJXHLPMYTXCQRBLZSSFJZZTNJYTXMYJHLHPPLCYXQJQQKZZSCPZKSWALQSBLCCZJSXGWWWYGYKTJBBZTDKHXHKGTGPBKQYSLPXPJCKBMLLXDZSTBKLGGQKQLSBKKTFXRMDKBFTPZFRTBBRFERQGXYJPZSSTLBZTPSZQZSJDHLJQLZBPMSMMSXLQQNHKNBLRDDNXXDHDDJCYYGYLXGZLXSYGMQQGKHBPMXYXLYTQWLWGCPBMQXCYZYDRJBHTDJYHQSHTMJSBYPLWHLZFFNYPMHXXHPLTBQPFBJWQDBYGPNZTPFZJGSDDTQSHZEAWZZYLLTYYBWJKXXGHLFKXDJTMSZSQYNZGGSWQSPHTLSSKMCLZXYSZQZXNCJDQGZDLFNYKLJCJLLZLMZZNHYDSSHTHZZLZZBBHQZWWYCRZHLYQQJBEYFXXXWHSRXWQHWPSLMSSKZTTYGYQQWRSLALHMJTQJSMXQBJJZJXZYZKXBYQXBJXSHZTSFJLXMXZXFGHKZSZGGYLCLSARJYHSLLLMZXELGLXYDJYTLFBHBPNLYZFBBHPTGJKWETZHKJJXZXXGLLJLSTGSHJJYQLQZFKCGNNDJSSZFDBCTWWSEQFHQJBSAQTGYPQLBXBMMYWXGSLZHGLZGQYFLZBYFZJFRYSFMBYZHQGFWZSYFYJJPHZBYYZFFWODGRLMFTWLBZGYCQXCDJYGZYYYYTYTYDWEGAZYHXJLZYYHLRMGRXXZCLHNELJJTJTPWJYBJJBXJJTJTEEKHWSLJPLPSFYZPQQBDLQJJTYYQLYZKDKSQJYYQZLDQTGJQYZJSUCMRYQTHTEJMFCTYHYPKMHYZWJDQFHYYXWSHCTXRLJHQXHCCYYYJLTKTTYTMXGTCJTZAYYOCZLYLBSZYWJYTSJYHBYSHFJLYGJXXTMZYYLTXXYPZLXYJZYZYYPNHMYMDYYLBLHLSYYQQLLNJJYMSOYQBZGDLYXYLCQYXTSZEGXHZGLHWBLJHEYXTWQMAKBPQCGYSHHEGQCMWYYWLJYJHYYZLLJJYLHZYHMGSLJLJXCJJYCLYCJPCPZJZJMMYLCQLNQLJQJSXYJMLSZLJQLYCMMHCFMMFPQQMFYLQMCFFQMMMMHMZNFHHJGTTHHKHSLNCHHYQDXTMMQDCYZYXYQMYQYLTDCYYYZAZZCYMZYDLZFFFMMYCQZWZZMABTBYZTDMNZZGGDFTYPCGQYTTSSFFWFDTZQSSYSTWXJHXYTSXXYLBYQHWWKXHZXWZNNZZJZJJQJCCCHYYXBZXZCYZTLLCQXYNJYCYYCYNZZQYYYEWYCZDCJYCCHYJLBTZYYCQWMPWPYMLGKDLDLGKQQBGYCHJXY";
    var n = {
        19969: "DZ",
        19975: "WM",
        19988: "QJ",
        20048: "YL",
        20056: "SC",
        20060: "NM",
        20094: "QG",
        20127: "QJ",
        20167: "QC",
        20193: "YG",
        20250: "KH",
        20256: "ZC",
        20282: "SC",
        20285: "QJG",
        20291: "TD",
        20314: "YD",
        20340: "NE",
        20375: "TD",
        20389: "YJ",
        20391: "CZ",
        20415: "PB",
        20446: "YS",
        20447: "SQ",
        20504: "TC",
        20608: "KG",
        20854: "QJ",
        20857: "ZC",
        20911: "PF",
        20504: "TC",
        20608: "KG",
        20854: "QJ",
        20857: "ZC",
        20911: "PF",
        20985: "AW",
        21032: "PB",
        21048: "XQ",
        21049: "SC",
        21089: "YS",
        21119: "JC",
        21242: "SB",
        21273: "SC",
        21305: "YP",
        21306: "QO",
        21330: "ZC",
        21333: "SDC",
        21345: "QK",
        21378: "CA",
        21397: "SC",
        21414: "XS",
        21442: "SC",
        21477: "JG",
        21480: "TD",
        21484: "ZS",
        21494: "YX",
        21505: "YX",
        21512: "HG",
        21523: "XH",
        21537: "PB",
        21542: "PF",
        21549: "KH",
        21571: "E",
        21574: "DA",
        21588: "TD",
        21589: "O",
        21618: "ZC",
        21621: "KHA",
        21632: "ZJ",
        21654: "KG",
        21679: "LKG",
        21683: "KH",
        21710: "A",
        21719: "YH",
        21734: "WOE",
        21769: "A",
        21780: "WN",
        21804: "XH",
        21834: "A",
        21899: "ZD",
        21903: "RN",
        21908: "WO",
        21939: "ZC",
        21956: "SA",
        21964: "YA",
        21970: "TD",
        22003: "A",
        22031: "JG",
        22040: "XS",
        22060: "ZC",
        22066: "ZC",
        22079: "MH",
        22129: "XJ",
        22179: "XA",
        22237: "NJ",
        22244: "TD",
        22280: "JQ",
        22300: "YH",
        22313: "XW",
        22331: "YQ",
        22343: "YJ",
        22351: "PH",
        22395: "DC",
        22412: "TD",
        22484: "PB",
        22500: "PB",
        22534: "ZD",
        22549: "DH",
        22561: "PB",
        22612: "TD",
        22771: "KQ",
        22831: "HB",
        22841: "JG",
        22855: "QJ",
        22865: "XQ",
        23013: "ML",
        23081: "WM",
        23487: "SX",
        23558: "QJ",
        23561: "YW",
        23586: "YW",
        23614: "YW",
        23615: "SN",
        23631: "PB",
        23646: "ZS",
        23663: "ZT",
        23673: "YG",
        23762: "TD",
        23769: "ZS",
        23780: "QJ",
        23884: "QK",
        24055: "XH",
        24113: "DC",
        24162: "ZC",
        24191: "GA",
        24273: "QJ",
        24324: "NL",
        24377: "TD",
        24378: "QJ",
        24439: "PF",
        24554: "ZS",
        24683: "TD",
        24694: "WE",
        24733: "LK",
        24925: "TN",
        25094: "ZG",
        25100: "XQ",
        25103: "XH",
        25153: "PB",
        25170: "PB",
        25179: "KG",
        25203: "PB",
        25240: "ZS",
        25282: "FB",
        25303: "NA",
        25324: "KG",
        25341: "ZY",
        25373: "WZ",
        25375: "XJ",
        25384: "A",
        25457: "A",
        25528: "SD",
        25530: "SC",
        25552: "TD",
        25774: "ZC",
        25874: "ZC",
        26044: "YW",
        26080: "WM",
        26292: "PB",
        26333: "PB",
        26355: "ZY",
        26366: "CZ",
        26397: "ZC",
        26399: "QJ",
        26415: "ZS",
        26451: "SB",
        26526: "ZC",
        26552: "JG",
        26561: "TD",
        26588: "JG",
        26597: "CZ",
        26629: "ZS",
        26638: "YL",
        26646: "XQ",
        26653: "KG",
        26657: "XJ",
        26727: "HG",
        26894: "ZC",
        26937: "ZS",
        26946: "ZC",
        26999: "KJ",
        27099: "KJ",
        27449: "YQ",
        27481: "XS",
        27542: "ZS",
        27663: "ZS",
        27748: "TS",
        27784: "SC",
        27788: "ZD",
        27795: "TD",
        27812: "O",
        27850: "PB",
        27852: "MB",
        27895: "SL",
        27898: "PL",
        27973: "QJ",
        27981: "KH",
        27986: "HX",
        27994: "XJ",
        28044: "YC",
        28065: "WG",
        28177: "SM",
        28267: "QJ",
        28291: "KH",
        28337: "ZQ",
        28463: "TL",
        28548: "DC",
        28601: "TD",
        28689: "PB",
        28805: "JG",
        28820: "QG",
        28846: "PB",
        28952: "TD",
        28975: "ZC",
        29100: "A",
        29325: "QJ",
        29575: "SL",
        29602: "FB",
        30010: "TD",
        30044: "CX",
        30058: "PF",
        30091: "YSP",
        30111: "YN",
        30229: "XJ",
        30427: "SC",
        30465: "SX",
        30631: "YQ",
        30655: "QJ",
        30684: "QJG",
        30707: "SD",
        30729: "XH",
        30796: "LG",
        30917: "PB",
        31074: "NM",
        31085: "JZ",
        31109: "SC",
        31181: "ZC",
        31192: "MLB",
        31293: "JQ",
        31400: "YX",
        31584: "YJ",
        31896: "ZN",
        31909: "ZY",
        31995: "XJ",
        32321: "PF",
        32327: "ZY",
        32418: "HG",
        32420: "XQ",
        32421: "HG",
        32438: "LG",
        32473: "GJ",
        32488: "TD",
        32521: "QJ",
        32527: "PB",
        32562: "ZSQ",
        32564: "JZ",
        32735: "ZD",
        32793: "PB",
        33071: "PF",
        33098: "XL",
        33100: "YA",
        33152: "PB",
        33261: "CX",
        33324: "BP",
        33333: "TD",
        33406: "YA",
        33426: "WM",
        33432: "PB",
        33445: "JG",
        33486: "ZN",
        33493: "TS",
        33507: "QJ",
        33540: "QJ",
        33544: "ZC",
        33564: "XQ",
        33617: "YT",
        33632: "QJ",
        33636: "XH",
        33637: "YX",
        33694: "WG",
        33705: "PF",
        33728: "YW",
        33882: "SR",
        34067: "WM",
        34074: "YW",
        34121: "QJ",
        34255: "ZC",
        34259: "XL",
        34425: "JH",
        34430: "XH",
        34485: "KH",
        34503: "YS",
        34532: "HG",
        34552: "XS",
        34558: "YE",
        34593: "ZL",
        34660: "YQ",
        34892: "XH",
        34928: "SC",
        34999: "QJ",
        35048: "PB",
        35059: "SC",
        35098: "ZC",
        35203: "TQ",
        35265: "JX",
        35299: "JX",
        35782: "SZ",
        35828: "YS",
        35830: "E",
        35843: "TD",
        35895: "YG",
        35977: "MH",
        36158: "JG",
        36228: "QJ",
        36426: "XQ",
        36466: "DC",
        36710: "JC",
        36711: "ZYG",
        36767: "PB",
        36866: "SK",
        36951: "YW",
        37034: "YX",
        37063: "XH",
        37218: "ZC",
        37325: "ZC",
        38063: "PB",
        38079: "TD",
        38085: "QY",
        38107: "DC",
        38116: "TD",
        38123: "YD",
        38224: "HG",
        38241: "XTC",
        38271: "ZC",
        38415: "YE",
        38426: "KH",
        38461: "YD",
        38463: "AE",
        38466: "PB",
        38477: "XJ",
        38518: "YT",
        38551: "WK",
        38585: "ZC",
        38704: "XS",
        38739: "LJ",
        38761: "GJ",
        38808: "SQ",
        39048: "JG",
        39049: "XJ",
        39052: "HG",
        39076: "CZ",
        39271: "XT",
        39534: "TD",
        39552: "TD",
        39584: "PB",
        39647: "SB",
        39730: "LG",
        39748: "TPB",
        40109: "ZQ",
        40479: "ND",
        40516: "HG",
        40536: "HG",
        40583: "QJ",
        40765: "YQ",
        40784: "QJ",
        40840: "YK",
        40863: "QJG"
    };
    function r(e) {
        if (typeof e != "string") throw new Error(-1, "函数makePy需要字符串类型参数!");
        var t = new Array();
        for (var a = 0, i = e.length; a < i; a++) {
            var n = e.charAt(a);
            t.push(o(n));
        }
        return s(t);
    }
    function o(e) {
        var t = e.charCodeAt(0);
        if (t > 40869 || t < 19968) return e;
        return n[t] ? n[t] : a.charAt(t - 19968);
    }
    function s(e) {
        var t = [ "" ];
        for (var a = 0, i = e.length; a < i; a++) {
            var n = e[a];
            var r = n.length;
            if (r == 1) {
                for (var o = 0; o < t.length; o++) {
                    t[o] += n;
                }
            } else {
                var s = t.slice(0);
                t = [];
                for (o = 0; o < r; o++) {
                    var d = s.slice(0);
                    for (var l = 0; l < d.length; l++) {
                        d[l] += n.charAt(o);
                    }
                    t = t.concat(d);
                }
            }
        }
        return t;
    }
    function e(e) {
        var t = i.trim(e);
        if (t != "") {
            var a = r(t);
            return a[0];
        } else {
            return "";
        }
    }
    i.hisui.toChineseSpell = e;
    i.hisui.getChineseSpellArray = r;
})(jQuery);

(function(r) {
    r.extend(r.fn.combobox.defaults, {
        defaultFilter: 1,
        filter: function(e, t) {
            var a = r(this).combobox("options");
            var i = t[a.textField];
            var n = a.defaultFilter || 1;
            if (n == 2) {
                return i.toLowerCase().indexOf(e.toLowerCase()) > -1;
            } else if (n == 3) {
                return i.toLowerCase().indexOf(e.toLowerCase()) == 0 || r.hisui.toChineseSpell(i).toLowerCase().indexOf(e.toLowerCase()) == 0;
            } else if (n == 4) {
                return i.toLowerCase().indexOf(e.toLowerCase()) > -1 || r.hisui.toChineseSpell(i).toLowerCase().indexOf(e.toLowerCase()) > -1;
            } else {
                return i.toLowerCase().indexOf(e.toLowerCase()) == 0;
            }
        }
    });
})(jQuery);

(function(v) {
    function i(e) {
        var t = v.data(e, "dateboxq");
        var a = t.options;
        var i = v(e);
        i.comboq(v.extend({}, a, {
            onShowPanel: function() {
                t.panel = v(e).comboq("panel");
                n(e);
                a.onShowPanel.call(e);
            }
        }));
        i.addClass("dateboxq");
        return;
    }
    function n(s) {
        var e = v(s);
        var t = v.data(s, "dateboxq");
        var a = t.options;
        var i = v(s).comboq("getText");
        var n = a.parser.call(s, i);
        if (a.minDate != null || a.maxDate != null) {
            v(s).dateboxq("calendar").options.validator = function(e, t) {
                var a = v.data(s, "dateboxq");
                var i = a.options;
                var n = true;
                if (null != i.minDate) {
                    if (t) t[0] = i.minDate;
                    var r = i.parser.call(s, i.minDate);
                    if (r > e) n = false;
                }
                if (null != i.maxDate) {
                    if (t) t[1] = i.maxDate;
                    var o = i.parser.call(s, i.maxDate);
                    if (o < e) n = false;
                }
                return n;
            };
        }
        var r = v.extend({
            current: n,
            border: false,
            onSelect: function(e) {
                var t = v(s).dateboxq("options");
                g(s, t.formatter.call(s, e));
                v(s).comboq("hidePanel");
            }
        }, v(s).dateboxq("calendar").calendar("options"));
        var o = v(s).comboq("panel");
        var d = v(s).comboq("createPanelBody");
        d.calendar(r);
        var l = v('<div class="datebox-button"><table cellspacing="0" cellpadding="0" style="width:100%"><tr></tr></table></div>').appendTo(o);
        var c = l.find("tr");
        for (var u = 0; u < a.buttons.length; u++) {
            var f = v("<td></td>").appendTo(c);
            var h = a.buttons[u];
            var p = v('<a href="javascript:void(0)"></a>').html(v.isFunction(h.text) ? h.text(s) : h.text).appendTo(f);
            p.bind("click", {
                target: s,
                handler: h.handler
            }, function(e) {
                e.data.handler.call(this, e.data.target);
            });
        }
        c.find("td").css("width", 100 / a.buttons.length + "%");
        return;
    }
    function t(e, t) {
        t = t === undefined ? true : t;
        var a = v.data(e, "dateboxq");
        var i = a.options;
        var n = v(e).val();
        if (n) {
            g(e, i.formatter.call(e, i.parser.call(e, n)));
            if (t) v(e).comboq("hidePanel");
        }
    }
    function a(e) {
        if (v(e).validatebox("isValid")) {
            t(e, false);
        }
    }
    function r(e) {
        return v(e).val();
    }
    function g(e, t, a) {
        var i = v.data(e, "dateboxq");
        var n = i.options;
        var r = v(e).val();
        if (r != t) {
            n.onChange.call(e, t, r);
        }
        v(e).val(t);
        if (v(e).validatebox("isValid")) {
            n.onSelect.call(e, n.parser.call(e, t));
        }
    }
    v.fn.dateboxq = function(a, e) {
        if (typeof a == "string") {
            var t = v.fn.dateboxq.methods[a];
            if (t) {
                return t(this, e);
            } else {
                return this.comboq(a, e);
            }
        }
        a = a || {};
        return this.each(function() {
            var e = v.data(this, "dateboxq");
            if (e) {
                v.extend(e.options, a);
            } else {
                var t = this;
                v.data(this, "dateboxq", {
                    calendar: {
                        options: {
                            validator: v.fn.calendar.defaults.validator
                        },
                        calendar: function(e) {
                            if (typeof e == "string") {
                                if (e == "options") return v.data(t, "dateboxq").calendar.options;
                            } else {
                                v.extend(v.data(t, "dateboxq").calendar.options, e);
                            }
                        }
                    },
                    options: v.extend({}, v.fn.dateboxq.defaults, v.fn.dateboxq.parseOptions(this), a)
                });
                v(this).css({
                    imeMode: "disabled"
                });
            }
            i(this);
        });
    };
    v.fn.dateboxq.methods = {
        options: function(e) {
            return v.data(e[0], "dateboxq").options;
        },
        setValue: function(e, t) {
            return e.each(function() {
                g(this, t);
            });
        },
        getValue: function(e) {
            return r(e[0]);
        },
        calendar: function(e) {
            return v.data(e[0], "dateboxq").calendar;
        }
    };
    v.fn.dateboxq.parseOptions = function(e) {
        return v.extend({}, v.fn.comboq.parseOptions(e), v.parser.parseOptions(e));
    };
    v.fn.dateboxq.defaults = v.extend({}, v.fn.comboq.defaults, {
        parser: v.fn.datebox.defaults.parser,
        formatter: v.fn.datebox.defaults.formatter,
        currentText: v.fn.datebox.defaults.currentText,
        closeText: v.fn.datebox.defaults.closeText,
        okText: v.fn.datebox.defaults.okText,
        buttons: [ {
            text: function(e) {
                return v(e).dateboxq("options").currentText;
            },
            handler: function(e) {
                v(e).val("t");
                t(e);
            }
        }, {
            text: function(e) {
                return v(e).dateboxq("options").closeText;
            },
            handler: function(e) {
                v(e).comboq("hidePanel");
            }
        } ],
        onBlur: function(e) {
            a(e);
        },
        onSelect: function(e) {},
        onChange: function(e, t) {},
        validType: [ 'datebox["YMD"]', "minMaxDate[null,null]" ],
        minDate: null,
        maxDate: null
    });
})(jQuery);

(function(p) {
    function i(t) {
        var e = p.data(t, "datetimeboxq");
        var a = e.options;
        p(t).val(a.value);
        p(t).dateboxq(p.extend({}, a, {
            onShowPanel: function() {
                var e = p(t).datetimeboxq("getValue");
                o(t, e, true);
                a.onShowPanel.call(t);
            }
        }));
        p(t).removeClass("dateboxq-f").addClass("datetimeboxq-f");
        p(t).dateboxq("calendar").calendar({
            onSelect: function(e) {
                a.onSelect.call(t, e);
            }
        });
    }
    function e(e, t, a) {}
    function r(e, t) {
        t.onHidePanel.call(this, e);
        p(p.hisui.globalContainerSelector).hide();
    }
    function n(e, t) {
        t = t === undefined ? true : t;
        var a = p.data(e, "datetimeboxq");
        var i = a.options;
        var n = p(e).val();
        if (n) {
            s(e, i.formatter.call(e, i.parser.call(e, n)));
            if (t) r(e, i);
        }
    }
    function o(e) {
        var t = p(e);
        var a = p(p.hisui.globalContainerSelector);
        var i = p.data(e, "datetimeboxq").options;
        var n = t.val();
        var r = new Date();
        var o = r.getHours();
        var s = r.getMinutes();
        var d = r.getSeconds();
        var l = n.split(" ");
        function c(e) {
            return (e < 10 ? "0" : "") + e;
        }
        if (l.length == 1) {
            timeval = c(o) + ":" + c(s) + ":" + c(d);
        } else {
            timeval = l[1];
        }
        var u = i.parser.call(e, n);
        var f = p('<div style="padding:2px"><input style="width:100px;height:24px"></div>').insertAfter(a.children("div.calendar"));
        var h = f.children("input");
        h.timespinner({
            showSeconds: i.showSeconds,
            separator: ":"
        }).unbind(".datetimeboxq").bind("mousedown.datetimeboxq", function(e) {
            e.stopPropagation();
        });
        h.timespinner("setValue", timeval);
    }
    function s(e, t, a) {
        var i = p.data(e, "datetimeboxq");
        var n = i.options;
        var r = p(e).val();
        if (r != t) {
            n.onChange.call(e, t, r);
        }
        p(e).val(t);
        if (p(e).validatebox("isValid")) {
            n.onSelect.call(e, n.parser.call(e, t));
        }
    }
    function d(e) {
        var t = p(p.hisui.globalContainerSelector);
        var a = t.children("div.calendar").calendar("options").current;
        var i = t.find("input.spinner-f");
        return new Date(a.getFullYear(), a.getMonth(), a.getDate(), i.timespinner("getHours"), i.timespinner("getMinutes"), i.timespinner("getSeconds"));
    }
    p.fn.datetimeboxq = function(a, e) {
        if (typeof a == "string") {
            var t = p.fn.datetimeboxq.methods[a];
            if (t) {
                return t(this, e);
            } else {
                return this.dateboxq(a, e);
            }
        }
        a = a || {};
        return this.each(function() {
            var e = p.data(this, "datetimeboxq");
            if (e) {
                p.extend(e.options, a);
            } else {
                var t = this;
                p.data(this, "datetimeboxq", {
                    spinner: {
                        options: p.fn.timespinner.defaults.options,
                        timespinner: function(e) {
                            if (typeof e == "string") {
                                if (e == "options") return p.data(t, "datetimeboxq").spinner.options;
                            } else {
                                p.data(t, "datetimeboxq").spinner.options = e;
                            }
                        }
                    },
                    options: p.extend({}, p.fn.datetimeboxq.defaults, p.fn.datetimeboxq.parseOptions(this), a)
                });
            }
            i(this);
        });
    };
    p.fn.datetimeboxq.methods = {
        options: function(e) {
            var t = e.dateboxq("options");
            return p.extend(p.data(e[0], "datetimeboxq").options, {
                originalValue: t.originalValue,
                disabled: t.disabled,
                readonly: t.readonly
            });
        },
        spinner: function(e) {
            return p.data(e[0], "datetimeboxq").spinner;
        },
        setValue: function(e, t) {
            return e.each(function() {
                s(this, t);
            });
        },
        reset: function(e) {
            return e.each(function() {
                var e = p(this).datetimeboxq("options");
                p(this).datetimeboxq("setValue", e.originalValue);
            });
        }
    };
    p.fn.datetimeboxq.parseOptions = function(e) {
        var t = p(e);
        return p.extend({}, p.fn.dateboxq.parseOptions(e), p.parser.parseOptions(e, [ {
            showSeconds: "boolean"
        } ]));
    };
    p.fn.datetimeboxq.defaults = p.extend({}, p.fn.dateboxq.defaults, {
        showSeconds: true,
        buttons: [ {
            text: function(e) {
                return p(e).dateboxq("options").currentText;
            },
            handler: function(e) {
                var t = p(e).dateboxq("options").formatter.call(e, new Date());
                p(e).val(t);
                n(e, true);
            }
        }, {
            text: function(e) {
                return p(e).dateboxq("options").okText;
            },
            handler: function(e) {
                var t = d(e);
                var a = p.data(e, "datetimeboxq");
                var i = a.options.formatter.call(e, t);
                p(e).val(i);
                n(e, true);
            }
        }, {
            text: function(e) {
                return p(e).dateboxq("options").closeText;
            },
            handler: function(e) {
                r(e, p(e).datetimeboxq("options"));
            }
        } ],
        formatter: function(e) {
            var t = e.getHours();
            var a = e.getMinutes();
            var i = e.getSeconds();
            function n(e) {
                return (e < 10 ? "0" : "") + e;
            }
            var r = ":";
            var o = p.fn.dateboxq.defaults.formatter(e) + " " + n(t) + r + n(a);
            if (p(this).datetimeboxq("options").showSeconds) {
                o += r + n(i);
            }
            return o;
        },
        parser: function(e) {
            if (p.trim(e) == "") {
                return new Date();
            }
            var t = e.split(" ");
            var a = p.fn.dateboxq.defaults.parser(t[0]);
            if (t.length < 2) {
                return a;
            }
            var i = ":";
            var n = t[1].split(i);
            var r = parseInt(n[0], 10) || 0;
            var o = parseInt(n[1], 10) || 0;
            var s = parseInt(n[2], 10) || 0;
            return new Date(a.getFullYear(), a.getMonth(), a.getDate(), r, o, s);
        },
        onHidePanel: function() {},
        rules: {},
        onBlur: function(e) {}
    });
})(jQuery);

$URL = "websys.Broker.cls";

var Level = {
    DEBUG: 1,
    INFO: 2,
    WARN: 3,
    ERROR: 4
};

(function() {
    if ("undefined" === typeof console) {
        var e = function() {};
        console = {
            log: e,
            debug: e,
            info: e,
            warn: e,
            error: e,
            assert: e,
            dir: e,
            dirxml: e,
            trace: e,
            group: e,
            groupCollapsed: e,
            time: e,
            timeEnd: e,
            profile: e,
            profileEnd: e,
            count: e,
            clear: e
        };
    }
    var t = function() {
        this.level = Level.ERROR;
    };
    t.prototype = {
        log: function(e) {
            try {
                console.log(e);
            } catch (t) {}
        },
        debug: function(e) {
            if (this.level <= Level.DEBUG) {
                this.log(e);
            }
        },
        info: function(e) {
            if (this.level <= Level.INFO) {
                this.log(e);
            }
        },
        warn: function(e) {
            if (this.level <= Level.WARN) {
                console.warn(e);
            }
        },
        error: function(e) {
            if (this.level <= Level.ERROR) {
                this.log(e);
                console.trace();
            }
        }
    };
    logger = new t();
})();

(function(e, o) {
    var t = {};
    o.fn.validatebox.defaults.tipOptions.onShow = function() {
        o(this).tooltip("tip");
    };
    o.fn.combo.defaults.width = 177;
    o.fn.combo.defaults.height = 30;
    o.fn.combobox.defaults.height = 30;
    o.fn.combotree.defaults.height = 30;
    o.fn.combogrid.defaults.height = 30;
    o.fn.datebox.defaults.height = 30;
    o.fn.datetimebox.defaults.height = 30;
    o.fn.tabs.defaults.tabHeight = 36;
    var s = {
        numberbox: {
            superui: "validatebox"
        },
        spinner: {
            superui: "validatebox"
        },
        timespinner: {
            superui: "spinner"
        },
        numberspinner: {
            superui: "spinner"
        },
        combo: {
            superui: "validatebox"
        },
        combobox: {
            superui: "combo"
        },
        combogrid: {
            superui: "combo"
        },
        combotree: {
            superui: "combo"
        },
        window: {
            superui: "panel"
        },
        dialog: {
            superui: "window"
        },
        datebox: {
            superui: "combo"
        },
        datetimebox: {
            superui: "datebox"
        },
        menubutton: {
            superui: "linkbutton"
        },
        splitbutton: {
            superui: "menubutton"
        },
        propertygrid: {
            superui: "datagrid"
        },
        treegrid: {
            superui: "datagrid"
        },
        lookup: {
            superui: "comboq"
        },
        comboq: {
            superui: "validatebox"
        }
    };
    var a = [ "draggable", "droppable", "resizable", "pagination", "tooltip", "linkbutton", "menu", "menubutton", "splitbutton", "progressbar", "tree", "combo", "combobox", "combotree", "combogrid", "numberbox", "validatebox", "searchbox", "numberspinner", "timespinner", "calendar", "datebox", "datetimebox", "slider", "layout", "panel", "datagrid", "propertygrid", "treegrid", "tabs", "accordion", "window", "dialog", "checkbox", "radio", "switchbox", "filebox", "popover", "comboq", "lookup", "keywords", "triggerbox", "layoutq", "dateboxq" ];
    o.each(a, function(e, r) {
        t[r] = function(e, t) {
            if (!e) return;
            var a = o(e);
            if ("undefined" != typeof t) {
                a[r](t);
            }
            var i = o.extend({
                jdata: a.data(r)
            }, {
                jqselector: e
            });
            function n() {}
            if (s[r] && s[r].superui && s[s[r].superui] && s[s[r].superui].superui) {
                o.each(o.fn[s[s[r].superui].superui].methods, function(e, a) {
                    i[e] = function() {
                        var e = o(this.jqselector);
                        Array.prototype.splice.call(arguments, 0, 0, e);
                        var t = a.apply(e, arguments);
                        return t;
                    };
                });
            }
            if (s[r] && s[r].superui) {
                o.each(o.fn[s[r].superui].methods, function(e, a) {
                    i[e] = function() {
                        var e = o(this.jqselector);
                        Array.prototype.splice.call(arguments, 0, 0, e);
                        var t = a.apply(e, arguments);
                        return t;
                    };
                });
            }
            o.each(o.fn[r].methods, function(e, a) {
                i[e] = function() {
                    var e = o(this.jqselector);
                    Array.prototype.splice.call(arguments, 0, 0, e);
                    var t = a.apply(e, arguments);
                    return t;
                };
            });
            return i;
        };
    });
    e.$HUI = t;
})(window, jQuery);

$(function() {
    $(document.body).on("keydown", function(e) {
        var t = e.keyCode;
        try {
            if (e.altKey && t == 37) {
                e.preventDefault();
                return false;
            }
            if (t == 8) {
                var a = e.target;
                var i = a.tagName.toUpperCase();
                if ($(a).prop("readonly")) {
                    e.preventDefault();
                    return false;
                }
                if (i == "INPUT") {
                    var n = a.type.toUpperCase();
                    if (n == "CHECKBOX") {
                        e.preventDefault();
                        return false;
                    }
                    if (n == "RADIO") {
                        e.preventDefault();
                        return false;
                    }
                }
                if (i !== "INPUT" && i !== "TEXTAREA") {
                    e.preventDefault();
                    return false;
                }
            }
        } catch (e) {}
        return true;
    });
});