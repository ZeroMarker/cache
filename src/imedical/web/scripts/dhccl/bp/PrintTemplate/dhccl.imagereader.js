/**
 * dhccl.imagereader.js
 * 样式编辑
 * @param {*} opt 
 */
function ImageReader(opt) {
    this.options = $.extend({}, opt, {
        width: 400,
        height: 350
    });

    this.styleArray = opt.value;
    this.onSave = opt.onSave;
    this.styleTextAreaArray = [];
    this.selectedStyleIndex = null;

    this.init();
}

ImageReader.prototype = {
    constructor: ImageReader,

    init: function () {
        this.dom = $("<div></div>").appendTo("body");
        this.render();
    },

    render: function () {
        var $this = this;

        var buttons = $("<div></div>");

        var btnSave = $('<a href="#"></a>').linkbutton({
            text: '保存',
            iconCls: 'icon-save',
            onClick: function () {
                $this.save();
                $this.close();
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
            title: "请选择图片",
            modal: true,
            closed: true,
            buttons: buttons
        });


        this.container = $("<div></div>");
        this.container.css({
            width: 350,
            height: 230,
            border: "1px solid #ccc",
            margin: 10
        });

        this.info = $("<span>请选择图片</span>");
        this.info.appendTo(this.container);

        this.imageInput = $("<input type='file'>");
        this.imageInput.appendTo(this.container);

        this.imageHolder = $("<div style='margin:10px'></div>");
        this.imageHolder.appendTo(this.container);

        var imgWidth = this.options.imgWidth;
        var imgHeight = this.options.imgHeight;

        this.img = $("<img>");
        this.img.attr("width", imgWidth);
        this.img.attr("height", imgHeight);
        this.img.appendTo(this.imageHolder);

        this.canvasHolder = $("<div style='margin:10px'></div>");
        this.canvasHolder.appendTo(this.container);

        $("<p>压缩后图片</p>").appendTo(this.canvasHolder);

        this.canvasHolder = $("<div style='margin:10px'></div>");
        this.canvasHolder.appendTo(this.container);
        this.canvas = document.createElement('canvas');
        $(this.canvas).attr("width", imgWidth);
        $(this.canvas).attr("height", imgHeight);
        $(this.canvas).css("border", "1px #ccc solid");
        $(this.canvas).appendTo(this.canvasHolder);
        this.context = this.canvas.getContext('2d');

        this.imageInput.change(function (e) {
            var imgBox = e.target;
            var file = imgBox.files[0];
            var reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = function () {
                var imgSrc = this.result;
                $this.img.attr("src", imgSrc);

                var image = new Image(); //新建一个img标签
                image.src = imgSrc;
                image.onload = function(){
                    $this.context.drawImage(image, 0, 0, imgWidth, imgHeight);
                }
            }
        });

        this.dlg.dialog({
            content: $this.container
        });
    },

    open: function () {
        this.dlg.dialog("open");
        this.dlg.dialog("center");
    },

    close: function () {
        this.container.empty();
        this.dlg.dialog("close");
        this.dlg.dialog("destroy");
    },

    save: function () {
        if (this.onSave) {
            var imgData = this.canvas.toDataURL("image/png", 1);
            this.onSave(imgData);
        }
    }
}
