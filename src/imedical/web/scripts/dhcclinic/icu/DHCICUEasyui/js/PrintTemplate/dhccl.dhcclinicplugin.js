const dhcClinicPlugin = new(function () {
    function DHCClinicPlugin() {
        this.webSocket = null;
        this.init();
    }

    DHCClinicPlugin.prototype = {
        constructor: DHCClinicPlugin,

        init: function () {
            var $this = this;

            if (!this.checkBrowserSupport()) {
                console.error("您的浏览器不支持WebSocket，请升级到更高版本!");
            }

            this.webSocket = new WebSocket("ws://127.0.0.1:50000");

            this.webSocket.onopen = function () {
                console.log("连接已建立。");
                $this.printInit();
            };

            this.webSocket.onmessage = function (event) {
                var recvMsg = JSON.parse(event.data);
                if (recvMsg.ResultCode == "E") {
                    console.error(recvMsg.ResultContent);
                }
            };

            this.webSocket.onclose = function () {
                console.error("连接已关闭。");
            };

            this.webSocket.onerror = function (event) {
                console.error("连接失败！");
            };
        },

        printInit: function () {
            this.sendContentMsg("PrintInit", "");
        },

        printPreview: function () {
            this.sendContentMsg("PrintPreview", "");
        },

        archivesInit: function () {
            this.sendContentMsg("ArchivesInit", "");
        },

        archives: function () {
            this.sendContentMsg("Archives", "test.pdf");
        },

        checkBrowserSupport: function () {
            if ("WebSocket" in window) {
                return true;
            } else {
                return false;
            }
        },

        sendAddShapeMsg: function (printShape) {
            var msg = {
                MsgType: "AddArchivesShape", //"PrintShape",
                MsgContent: "",
                PrintShape: printShape
            };
            this.sendMsg(msg);
        },

        sendContentMsg: function (msgType, msgContent) {
            var msg = {
                MsgType: msgType,
                MsgContent: msgContent,
                PrintShape: null
            };
            this.sendMsg(msg);
        },

        sendMsg: function (msgObject) {
            var msgStr = JSON.stringify(msgObject);
            var readyState = this.webSocket.readyState;
            switch (readyState) {
                case 0:
                    console.error("连接尚未建立。");
                    break;

                case 1:
                    this.webSocket.send(msgStr);
                    break;

                case 2:
                    console.error("连接正在进行关闭。");
                    break;

                case 3:
                    console.error("连接已经关闭或者连接不能打开。");
                    break;

                default:
                    console.error("webSocket.readyState=" + readyState);
                    break;
            }
        },

        addPrintString: function (text, intTop, intLeft, intWidth, intHeight, strStrokeStyle, strFontFamily, intFontSize, strFontWeight) {
            var displayShape = {
                DrawType: "DrawString",
                Rect: {
                    Left: intLeft,
                    Top: intTop,
                    Width: intWidth,
                    Height: intHeight
                },
                StrokeStyle: strStrokeStyle,
                FillStyle: "",
                LineWidth: 0,
                LineStyle: "",
                Text: text,
                Font: {
                    Family: strFontFamily,
                    Size: intFontSize,
                    Weight: strFontWeight
                }
            };
            this.sendAddShapeMsg(displayShape);
        },

        addPrintLine: function (intTop1, intLeft1, intTop2, intLeft2, strStrokeStyle, intLineWidth) {
            var displayShape = {
                DrawType: "DrawLine",
                Rect: {
                    Left: intLeft1,
                    Top: intTop1,
                    Width: intLeft2 - intLeft1,
                    Height: intTop2 - intTop1
                },
                StrokeStyle: strStrokeStyle,
                FillStyle: "",
                LineWidth: intLineWidth,
                LineStyle: "",
                Text: "",
                Font: null
            };
            this.sendAddShapeMsg(displayShape);
        },

        addPrintRect: function (intTop, intLeft, intWidth, intHeight, strStrokeStyle, intLineWidth) {
            var displayShape = {
                DrawType: "DrawRectangle",
                Rect: {
                    Left: intLeft,
                    Top: intTop,
                    Width: intWidth,
                    Height: intHeight
                },
                StrokeStyle: strStrokeStyle,
                FillStyle: "",
                LineWidth: intLineWidth,
                LineStyle: "",
                Text: "",
                Font: null
            };
            this.sendAddShapeMsg(displayShape);
        },

        addPrintCircle: function (intTop, intLeft, intWidth, intHeight, strStrokeStyle, intLineWidth) {
            var displayShape = {
                DrawType: "DrawCircle",
                Rect: {
                    Left: intLeft,
                    Top: intTop,
                    Width: intWidth,
                    Height: intHeight
                },
                StrokeStyle: strStrokeStyle,
                FillStyle: "",
                LineWidth: intLineWidth,
                LineStyle: "",
                Text: "",
                Font: null
            };
            this.sendAddShapeMsg(displayShape);
        },

        addPrintImage: function (intTop, intLeft, intWidth, intHeight, imgUrl) {
            var displayShape = {
                DrawType: "DrawImage",
                Rect: {
                    Left: intLeft,
                    Top: intTop,
                    Width: intWidth,
                    Height: intHeight
                },
                StrokeStyle: "",
                FillStyle: "",
                LineWidth: 0,
                LineStyle: "",
                Text: "",
                Font: null,
                Url: imgUrl
            };
            this.sendAddShapeMsg(displayShape);
        },
    }

    return DHCClinicPlugin;
}())();

function getPlugin() {
    return dhcClinicPlugin;
}