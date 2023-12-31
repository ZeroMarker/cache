/**
 * 打印预览界面
 * @author 
 */
(function (global, factory) {
    if (!global.LodopPrintView) factory(global.LodopPrintView = {});
}(this, function (exports) {

    exports.init = function (opt) {
        var view = new LodopPrintView(opt);
        exports.instance = view;
        return view;
    }

    function LodopPrintView(opt) {
        this.options = $.extend({
            width: 850,
            height: 700
        }, opt);
        this.valueObject = opt.valueObject;
        this.sheetData = opt.sheetData;
        this.tableValuesArray = opt.tableValuesArray;
        this.init();
    }

    LodopPrintView.prototype = {
        init: function () {
            var $this = this;

            this.dom = $('<div></div>').appendTo('body');
            var buttons = $('<div></div>');
            this.printBtn = $('<a href="#"></a>').linkbutton({
                text: '打印',
                iconCls: 'icon-print',
                onClick: function () {
                    $this.print();
                }
            }).appendTo(buttons);
            this.imagePrintBtn = $('<a href="#"></a>').linkbutton({
                text: '图片打印',
                iconCls: 'icon-print',
                onClick: function () {
                    $this.imagePrint();
                }
            }).appendTo(buttons);
            this.cancelBtn = $('<a href="#"></a>').linkbutton({
                text: '取消',
                iconCls: 'icon-cancel',
                onClick: function () {
                    $this.close();
                }
            }).appendTo(buttons);

            this.initForm();

            this.dom.dialog({
                height: this.options.height,
                width: this.options.width,
                title: '打印预览',
                modal: true,
                closed: true,
                buttons: buttons,
                onOpen: function () {
                    $this.refreshPage();
                },
                onClose: function () {
                    $this.clear();
                }
            });
        },

        initForm: function () {
            this.pageNoContainer = $('<div style="width:800px;height:30px;padding:0;margin:0px;background-color:#ccc;"></div>').appendTo(this.dom);
            this.canvasContainer = $('<div style="width:800px;height:1200px;padding:10px;background-color:gray;"></div>').appendTo(this.dom);
            $('<canvas id="test-canvas" width="795px" height="1124px" style="border: 1px solid #ccc;background-color:white;"></canvas>').appendTo(this.canvasContainer);
            this.canvas = document.getElementById("test-canvas");
            this.refreshPage();
        },

        open: function () {
            this.dom.dialog('open');
        },

        close: function () {
            this.dom.dialog('close');
        },

        clear: function () {

        },

        printView: function () {
            this.open();
        },

        print: function (directPrint) {
            this.lodopPrint(directPrint);
        },

        refreshPage: function () {
            this.drawDisplaySheet();
            this.setPageNoList();
        },

        drawDisplaySheet: function () {
            var $this = this;
            this.displaySheet = new DisplaySheet({
                canvas: $this.canvas,
                sheet: $this.sheetData,
                valueObject: $this.valueObject,
                tableValuesArray: $this.tableValuesArray
            });
        },

        setPageNoList: function () {
            var $this = this;
            this.pageNoContainer.PageNoTabs({
                pages: $this.displaySheet.getPageNoArray(),
                hideAddNewButton: true,
                onPageNoTabSelected: function (pageNo) {
                    $this.displaySheet.setCurrentPage(pageNo);
                }
            })
        },

        setPrintData: function(valueObject, tableValuesArray){
            this.displaySheet.valueObject = valueObject;
            this.displaySheet.tableValuesArray = tableValuesArray;
        },

        lodopPrint: function (directPrint) {
            var lodop = getLodop();
            lodop.PRINT_INIT("DisplaySheet" + (new Date()).getTime());
            var pageDirection = this.displaySheet.sheet.PageDirection;
            var pageName = this.displaySheet.sheet.PageName;
            var pageSize = this.displaySheet.sheet.PageSize;
            var pageSizeUnit = this.displaySheet.sheet.PageSizeUnit;
            var printDuplex = this.displaySheet.sheet.PrintDuplex;
            var orient = (pageDirection === "Horizontal")? 2:1;

            if(pageName && pageSize && pageSizeUnit){
                lodop.SET_PRINT_PAGESIZE(orient, pageSize.width + pageSizeUnit, pageSize.height + pageSizeUnit, pageName);
            }else{
                lodop.SET_PRINT_PAGESIZE(orient, 0, 0, pageName);
            }

            var lodopContext = new LodopContext({
                lodop: lodop,
                ratio: {
                    x: 1,
                    y: 1
                },
                offset: {
                    x: 0,
                    y: 0
                }
            });

            var drawContext = this.displaySheet.drawContext;
            this.displaySheet.drawContext = lodopContext;
            var pageNoArray = this.displaySheet.getPageNoArray();
            for (var i = 0; i < pageNoArray.length; i++) {
                if (i > 0) {
                    lodop.NEWPAGE();
                }
                this.displaySheet.setCurrentPage(pageNoArray[i]);
                this.displaySheet.drawPage();

                this.printImages(lodop);
            }
            this.displaySheet.drawContext = drawContext;

            lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
            lodop.SET_PRINT_STYLEA(0, "Stretch", 2);
            //lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", 95);
            if(printDuplex) {
                lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
            } else {
                lodop.SET_PRINT_MODE("PRINT_DUPLEX", 1);
            }
            if(directPrint){
                lodop.PRINT();
            }else{
                lodop.PREVIEW();
            }
        },

        printImages: function (lodop) {
            var currentPage = this.displaySheet.getCurrentPage();
            for (var i = 0; i < currentPage.Images.length; i++) {
                var image = currentPage.Images[i];
                var rect = image.DisplayRect;
                var src = this.displaySheet.getImageSrc(image, rect);
                lodop.ADD_PRINT_SHAPE(4,rect.top,rect.left,rect.width,rect.height,0,1,"white");
                if(src) {
                    var strHtmlContent = "<img width=" + rect.width + " height=" + rect.height + " src='" + src + "'/>";
                    lodop.ADD_PRINT_IMAGE(rect.top, rect.left, rect.width, rect.height, strHtmlContent);
                    lodop.SET_PRINT_STYLEA(0, "Stretch", 1);
                }  
            }
            for (var i = 0; i < currentPage.Areas.length; i++) {
                var area = currentPage.Areas[i];
                var areaRect = area.DisplayRect;
                for (var j = 0; j < area.AreaItems.length; j++) {
                    var areaItem = area.AreaItems[j];
                    if (areaItem && areaItem.Type === "signature") {
                        var rect = areaItem.DisplayRect;
                        var imageBase64String = $("#" + areaItem.Code + "Image").attr("src");
                        if (imageBase64String) {
                            var ImageOffsetX = parseInt(areaItem.ImageOffsetX ? areaItem.ImageOffsetX : 100);
                            var ImageOffsetY = parseInt(areaItem.ImageOffsetY ? areaItem.ImageOffsetY : -20);
                            var ImageWidth = parseInt(areaItem.ImageWidth ? areaItem.ImageWidth : 120);
                            var ImageHeight = parseInt(areaItem.ImageHeight ? areaItem.ImageHeight : 40);

                            var top = areaRect.top + rect.top + ImageOffsetY;
                            var left = areaRect.left + rect.left + ImageOffsetX;
                            var strHtmlContent = "<img width=" + ImageWidth + " height=" + ImageHeight + " src='" + imageBase64String + "'/>";
                            lodop.ADD_PRINT_IMAGE(top, left, ImageWidth, ImageHeight, strHtmlContent);
                            lodop.SET_PRINT_STYLEA(0, "Stretch", 1);
                        }
                    }

                }
            }
        },

        archive: function(opts){
            if(!opts){
                $.messager.alert("提示","参数不能为空!","error");
                return;
            }
            if(!opts.ip){
                $.messager.alert("提示","归档服务器IP不能为空","error");
                return;
            }
            if(!opts.port){
                $.messager.alert("提示","归档服务器端口参数不能为空!","error");
                return;
            }
            if(!opts.id){
                $.messager.alert("提示","手术申请Id不能为空!","error");
                return;
            }
            if(!opts.date){
                $.messager.alert("提示","归档日期不能为空!","error");
                return;
            }
            if(!opts.filename){
                $.messager.alert("提示","归档文件名不能为空!","error");
                return;
            }

            var archiveContext = new ArchiveContext({
                ratio: {
                    x: 595.28 / 792,
                    y: 841.89 / 1120,
                    fontRatio: 1
                },
                offset: {
                    x: 0,
                    y: 0
                }
            });

            var drawContext = this.displaySheet.drawContext;
            this.displaySheet.drawContext = archiveContext;
            var pageNoArray = this.displaySheet.getPageNoArray();
            for (var i = 0; i < pageNoArray.length; i++) {
                if(i > 0){
                    archiveContext.addPage();
                }
                this.displaySheet.setCurrentPage(pageNoArray[i]);
                this.displaySheet.drawPage();

                var currentPage = this.displaySheet.getCurrentPage();
                for (var i = 0; i < currentPage.Images.length; i++) {
                    var image = currentPage.Images[i];
                    var rect = image.DisplayRect;
                    var URL = image.URL;
                    if($("#" + image.Code).length > 0){
                        var imgData = $("#" + image.Code).attr("src");
                        if(imgData){
                            URL = imgData;
                        }
                    }
                    if(URL) {
                        archiveContext.drawImage(rect, URL);
                    }
                }
            }
            this.displaySheet.drawContext = drawContext;

            var _this = this;
            var protocol = window.location.protocol;
            var archiveServerUrl = protocol + "//" + opts.ip + ":" + opts.port + "/archives";
            archiveContext.archivesTest({ archiveServerUrl: protocol + "//" + opts.ip + ":" + opts.port });
            archiveContext.archives({
                archiveServerUrl: archiveServerUrl,
                type: opts.type,
                id: opts.id,
                date: opts.date,
                filename: opts.filename,
                onSuccess: function(successMsg) {
                    if(successMsg.indexOf("S^")===0){
                        var pdfViewerUrl = protocol + "//" + opts.ip + ":" + opts.port + "/pdfviewer?type=" + opts.type + "&id=" + opts.id + "&date=" + opts.date + "&filename=" + opts.filename;
                        var saveResult = _this.saveArchive(pdfViewerUrl);
                        if(saveResult.indexOf("S^") != 0){
                            $.messager.alert("错误", "归档失败:" + saveResult, "error");
                            return;
                        }
                        $.messager.alert("提示", "归档成功", "info", function(){
                            var recordBrowser = new RecordBrowser({
                                title: opts.patName + "的" + opts.moduleName,
                                href: encodeURI(pdfViewerUrl)
                            });
                            recordBrowser.open();
                        });
                    }else{
                        $.messager.alert("错误", "归档失败:" + successMsg, "error");
                    }
                },
                onError: function(errorMsg) {
                    $.messager.alert("错误", "归档失败:" + errorMsg, "error");
                }       
            });
        },

        saveArchive: function (filePath) {
            var saveDatas = [{
                ClassName: ANCLS.Model.RecordSheet,
                RowId: session.RecordSheetID,
                FileUser: session.UserID,
                FileDate: "today",
                FileTime: "now",
                FilePath: filePath
            }];

            var saveStr = dhccl.formatObjects(saveDatas);
            var saveResult = dhccl.saveDatas(ANCSP.DataListService, {
                jsonData: saveStr
            });

            return saveResult;
        }
    }

}));