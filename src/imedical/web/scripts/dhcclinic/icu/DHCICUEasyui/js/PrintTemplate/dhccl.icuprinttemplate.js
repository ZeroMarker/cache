EditPluginManager.prototype.getOperAppData = function () {
    return [];
}

EditPluginManager.prototype.getOperDatas = function () {
    return [];
}

EditPluginManager.prototype.getSignatureList = function () {
    return [];
}


let templateId = "";

$(initPage);

function initPage() {
    let moduleId = dhccl.getQueryString("moduleId");
    if (moduleId) {
        $.ajax({
            url: ANCSP.MethodService,
            async: true,
            data: {
                ClassName: "web.DHCICUCPrintTemplate",
                MethodName: "GetPrintTemplate",
                Arg1: moduleId,
                ArgCnt: 1
            },
            type: "post",
            success: function (data) {
                var result = $.trim(data);
                if (result) {
                    try{
                        templateId = result.split("^")[0];
                        var sheetData = $.parseJSON(result.split("^")[1]);
                        initTemplate(sheetData);
                    }catch(err){
                        /*$.messager.alert("提示", "加载数据错误，data:" + result);
                        if(window.localStorage && window.localStorage.getItem(moduleId)){
                            $.messager.confirm('询问','是否加载�?近一次保存记�?',function(r){
                                if (r){
                                    var sheetData = $.parseJSON(window.localStorage.getItem(moduleId));
                                    initTemplate(sheetData);
                                }
                            });
                        }*/
                        console.error(err);
                    }
                } else {
                    loadDefaultTemplate();
                }
            }
        });
    } else {
        $.messager.alert("错误","moduleId不能为空，请选择�?个模块！","error");
    }
}

function loadDefaultTemplate() {
    $.getJSON("../service/dhcanop/data/PrintTemplate.json", function (data) {
        initTemplate(data);
    });
}

function initTemplate(data) {
    HIDPI();

    //templateConfig是在 dhccl.templateconfig.js 中定义的对象
    var config = templateConfig;

    var propertyEditor = new PropertyEditor($("#propertyEditor"), {
        value: {
            type: "Sheet",
            obj: data.Sheet,
            disabled: true
        },
        onPropertyValueChanged: onPropertyValueChanged,
        onStylesChanged: onStylesChanged
    });

    var displaySheet = new DisplaySheet({
        canvas: document.getElementById("myCanvas"),
        sheet: data.Sheet,
        editMode: false,
        onPageResize: function(){
            HIDPI();
        },
        valueObject: {
            logo1: config.defaultImageSrc
        },
        onItemSelected: function (type, obj) {
            propertyEditor.setValue(type, obj);
            setCopyItemButton(type, obj);
        }
    });

    propertyEditor.setStylesInfo(displaySheet.getStyles());

    var drawItemContolPanel = new DrawItemContolPanel($("#sheetItemControlPanel"), {
        config: config,
        setDrawingStatus: function (drawItem) {
            displaySheet.setDrawingContext(drawItem);
        }
    });

    function onPropertyValueChanged(valueInfo) {
        displaySheet.onPropertyValueChanged(valueInfo);
    }

    function onStylesChanged(stylesInfo){
        displaySheet.setStyles(stylesInfo);
    }

    var canvas = displaySheet.canvas;
    $(canvas).mousedown(canvasMouseDown);
    $(canvas).mouseup(canvasMouseUp);
    $(canvas).mousemove(canvasMouseMove);
    $(canvas).click(canvasMouseClick);
    $(canvas).bind("contextmenu", canvasContextMenu);

    window.addEventListener('keydown',windowKeyDown);
    window.addEventListener('keyup',windowKeyUp);

    $(canvas).tooltip({
        content: "",
        trackMouse: true,
        showDelay: 0,
        hideDelay: 0
    });

    function canvasMouseDown(e) {
        e.preventDefault();

        //var canvasLoc = displaySheet.canvas.windowToCanvas(e);
        var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
        displaySheet.captureClick(canvasLoc);
        displaySheet.onMouseDown(canvasLoc);
        //console.dir(canvasLoc);
    }

    function canvasMouseUp(e) {
        e.preventDefault();

        //var canvasLoc = displaySheet.canvas.windowToCanvas(e);
        var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
        displaySheet.onMouseUp(canvasLoc);
        //console.dir(canvasLoc);
    }

    function canvasMouseMove(e) {
        e.preventDefault();

        //var canvasLoc = displaySheet.canvas.windowToCanvas(e);
        var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
        var mousePointInfo = "x: " + Math.round(canvasLoc.x) + ",  y: " + Math.round(canvasLoc.y);
        var toolTipInfo = displaySheet.getTooltipInfo();
        if(toolTipInfo == "") toolTipInfo = mousePointInfo;
        $(canvas).tooltip("update", toolTipInfo);
        $(canvas).tooltip("show");
        displaySheet.onMouseMove(canvasLoc);
    }

    function canvasMouseClick(e) {
        e.preventDefault();

        //var canvasLoc = displaySheet.canvas.windowToCanvas(e);
        var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
    }

    function canvasContextMenu(e) {
        e.preventDefault();

        if (displaySheet.itemMenus != null) {
            displaySheet.itemMenus.menu("destroy");
        }

        var itemMenus = $('<div class="hisui-menu" style="width:140px;"></div>').appendTo('body');
        displaySheet.itemMenus = itemMenus.menu({});
        displaySheet.itemMenus.menu("appendItem", {
            text: "删除",
            onclick: function (e) {
                displaySheet.deleteSelectedItem();
            }
        });
        displaySheet.itemMenus.menu("show", {
            left: e.pageX,
            top: e.pageY
        });
    }

    function getCanvasLocation(canvas, e) {
        var box = canvas.getBoundingClientRect();
        return {
            x: e.clientX - box.left,
            y: e.clientY - box.top
        };
    }

    $("#btnLodopPrint").linkbutton({
        onClick: function () {
            var sheetData = displaySheet.getSheetData();
            var lodopPrintView = window.LodopPrintView.instance;
            if (!lodopPrintView) {
                lodopPrintView = window.LodopPrintView.init({
                    sheetData: sheetData.Sheet,
                    valueObject: {
                        LocDesc: "测试",
                        BedDesc: "测试",
                        Emergency: true,
                    },
                    tableValuesArray: [
                        {
                            tableCode: "displayTable1",
                            tableValues: [
                                { Column1: "测试1", Column2: "测试2", Column3: "测试3", Column4: "测试4", Column5: "测试5", Column6: "测试6" },
                                { Column1: "测试1", Column2: "测试2", Column3: "测试3", Column4: "测试4", Column5: "测试5", Column6: "测试6" }
                            ]
                        }
                    ]
                });
            }
            lodopPrintView.print();    //直接打印
            //lodopPrintView.printView(); //打印预览
        }
    });
    $("#btnLodopPrint").tooltip({content: '打印', position: 'bottom'});

    $("#btnUploadJson").click(function () {
        saveTemplateJson();
    });
    $("#btnUploadJson").tooltip({content: '保存到服务器�?<span style="color:yellow;">快捷�?CTRL+S</span>', position: 'right'});

    $("#btnEditJson").click(function () {
        var sheetData = displaySheet.getSheetData();
        var sheetDataStr = JSON.stringify(sheetData, null, 2);
        var templateEditor = new TemplateEditor({
            value: sheetDataStr,
            config: config,
            onSave: function (value) {
                var sheetData = JSON.parse(value);
                displaySheet.resetSheetData({
                    sheet: sheetData.Sheet,
                    editMode: false
                });
                propertyEditor.setValue("Sheet", sheetData.Sheet, true);
                $("#pageNoTabs").PageNoTabs("resetPages", {
                    pages: displaySheet.getPageNoArray()
                });
            }
        });
        templateEditor.open();
    });
    $("#btnEditJson").tooltip({content: '编辑表单JSON文本', position: 'bottom'});

    $("#btnPageSettingEditor").linkbutton({
        onClick: function () {
            var pageSettingEditor = new PageSettingEditor({
                pageSetting: displaySheet.getPageSetting(),
                onSave: function (pageSetting) {
                    displaySheet.setPageSetting(pageSetting);
                    displaySheet.setPageSize();
                    displaySheet.drawPage();
                    propertyEditor.setValue("Sheet", displaySheet.sheet, true);
                }
            });
            pageSettingEditor.open();
        }
    });
    $("#btnPageSettingEditor").tooltip({content: '表单设置', position: 'bottom'});

    $("#btnRefresh").linkbutton({
        onClick: function () {
            window.location.reload();
        }
    });
    $("#btnRefresh").tooltip({content: '刷新', position: 'bottom'});

    $("#btnCopyItem").linkbutton({
        onClick: function () {
            var drawItem = $(this).data("drawItem");
            if (drawItem) {
                displaySheet.setDrawingContext(drawItem);
            }
        }
    });
    $("#btnCopyItem").tooltip({content: '复制项目, <span style="color:yellow;">快捷�?C</span>', position: 'bottom'});

    $("#btnTopAlign").linkbutton({
        onClick: function () {
            var result = displaySheet.setMultSelectedAreaItemAlign("topAlign");
            if(!result){
                $.messager.popover({
                    msg: "请按住CTRL键，选择多个区域项目，才能向上对�?,
                    type: "error"
                });
            }
        }
    });
    $("#btnTopAlign").tooltip({content: '选择多个区域项目，向上对�?, position: 'bottom'});

    $("#btnBottomAlign").linkbutton({
        onClick: function () {
            var result = displaySheet.setMultSelectedAreaItemAlign("bottomAlign");
            if(!result){
                $.messager.popover({
                    msg: "请按住CTRL键，选择多个区域项目，才能向下对�?,
                    type: "error"
                });
            }
        }
    });
    $("#btnBottomAlign").tooltip({content: '选择多个区域项目，向下对�?, position: 'bottom'});

    $("#btnUndo").linkbutton({
        onClick: function () {
            displaySheet.undoOperation();
        }
    });
    $("#btnUndo").tooltip({content: '撤销上一步操�? <span style="color:yellow;">快捷�?CTRL+Z</span>', position: 'bottom'});


    function setCopyItemButton(type, obj) {
        if (type && type != "Page") {
            var drawItem = {
                type: "Drawing" + type,
                value: obj
            };
            $("#btnCopyItem").data("drawItem", drawItem);
            $("#btnCopyItem").linkbutton({
                text: "<div style='font-weight:bold; width:150px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;'>(复制)" + obj.Desc + "</div>"
            }).linkbutton("enable");
        } else {
            $("#btnCopyItem").linkbutton({
                text: "(复制)项目"
            }).linkbutton("disable");
        }
    }

    function saveTemplateJson(){
        var sheetData = displaySheet.getSheetData();
        var sheetDataStr = JSON.stringify(sheetData);
        uploadTemplateJson(sheetDataStr);
    }

    function uploadTemplateJson(sheetDataStr) {
        let moduleId = dhccl.getQueryString("moduleId");
        if (moduleId == "") {
            $.messager.alert("提示", "数据模块ID为空�?, "error");
            return;
        }
        if(window.localStorage){
            window.localStorage.setItem(moduleId, sheetDataStr);
        }
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../web.DHCICUCPrintTemplate.cls',
            async: false,
            cache: false,
            data: {
                Action: 'SavePrintTemplate',
                RowId: templateId,
                DataModule: moduleId,
                JSONData: sheetDataStr,
                UpdateUser: ""
            },
            success: function (ret) {
                var value=$.trim(ret);
                if(value.indexOf("S^")===0){
                    $.messager.popover({
                        msg: "上传成功",
                        type: "success"
                    });
                }else{
                    $.messager.alert("提示", "上传数据失败，原因：" + ret, "error");
                }
            },
            error: function (err) {
                $.messager.alert("提示", "上传数据失败，原因：" + err, "error");                     
            }
        });

        var archiveCode = dhccl.getQueryString("archiveCode");
        if(archiveCode){
            var ip = session.ArchiveServerIP;
            var port = session.ArchiveServerPort;
            saveArchivePrintTemplate(ip, port, archiveCode, sheetDataStr);
        }
    }

    $("#pageNoTabs").PageNoTabs({
        pages: displaySheet.getPageNoArray(),
        hideAddNewButton: false,
        onPageNoTabSelected: function (pageNo) {
            displaySheet.setCurrentPage(pageNo);
        },
        onAddNewPageTab: function () {
            var addNewPageEditor = new AddNewPageEditor({
                defaultPage: config.defaultPage,
                onAddNewPage: function (page) {
                    if (displaySheet.ifHasPageNo(page.PageNo)) {
                        $.messager.alert("提示", "�? + page.PageNo + "页已存在，请输入新的页码!!");
                        return;
                    }
                    displaySheet.addPage(page);
                    displaySheet.setCurrentPage(page.PageNo);
                    propertyEditor.setValue("Page", page);
                    $("#pageNoTabs").PageNoTabs("addNewTab", {
                        pageNo: page.PageNo
                    });
                }
            });
            addNewPageEditor.open();
        },
        onPageDeleted: function(pageNo){
            if(pageNo == 1){
                $.messager.alert("提示", "�?�不能删�?);
                return;
            }

            $.messager.confirm("确认", "你确定要删除�? + pageNo + "�?", function(r){
                if (r){
                    displaySheet.deletePageByNo(pageNo);
                    displaySheet.setCurrentPage(1);
                    propertyEditor.setValue("Page", displaySheet.getCurrentPage());
                    $("#pageNoTabs").PageNoTabs("removePage", {
                        pageNo: pageNo
                    });
                }
            });
        }
    });

    //保存归档模板
    function saveArchivePrintTemplate(ip, port, archiveCode, sheetDataStr){
        var url = "http://" + ip + ":" + port + "/saveArchiveTemplate";
        $.ajax({
            url: url,
            async: true,
            data: {
                archiveCode: archiveCode,
                sheetDataStr: sheetDataStr
            },
            dataType: "text",
            type: "post",
            success: function (data) {
                let result = $.trim(data);
                if (result.indexOf("S^") >= 0) {
                    $.messager.popover({
                        msg: "保存归档模板成功",
                        type: "success"
                    });
                } else {
                    $.messager.alert("提示", "保存归档模板失败，原因：" + result, "error");
                }
            },
            error: function(){
                $.messager.popover({
                    msg: "保存归档模板失败",
                    type: "error"
                });
            }
        });
    }

    //后台模板归档
    function templateArchive(opts){
        var archiveServerUrl = "http://" + opts.ip + ":" + opts.port + "/templateArchives";
        var value = {
            valueObject : opts.valueObject,
            tableValuesArray : opts.tableValuesArray
        };
        value.valueObject = opts.valueObject;
        value.tableValuesArray = opts.tableValuesArray;

        $.ajax({
            url: archiveServerUrl,
            async: true,
            data: {
                "type": opts.type,
                "id": opts.id,
                "date": opts.date,
                "filename": opts.filename,
                "pageWidth": opts.pageWidth,
                "pageHeight": opts.pageHeight,
                "archiveCode": opts.archiveCode,
                "valueStr": JSON.stringify(value)
            },
            dataType: "text",
            type: "POST",
            success: function (data, textStatus) {
                $.messager.alert("提示", "归档成功" + data, "info");
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var errorMsg = archiveServerUrl + "无法连接！请�?查归档服务器�?;
                $.messager.alert("提示", "归档失败:" + errorMsg, "error");
            }
        });
    }

    function HIDPI() {
        var ratio = window.devicePixelRatio || 1;
        var canvas = document.getElementById("myCanvas");
        var context = canvas.getContext("2d");
        var oldWidth = canvas.width;
        var oldHeight = canvas.height;
        canvas.width = oldWidth * ratio;
        canvas.height = oldHeight * ratio;
        canvas.style.width = oldWidth + "px";
        canvas.style.height = oldHeight + "px";
        context.scale(ratio, ratio);
    }

    function windowKeyDown(e){
        var event = e || window.event;

        if (event && event.keyCode == 17) {
            displaySheet.isCtrlDown = true;
        }

        if(document.activeElement.tagName=="INPUT" || document.activeElement.tagName=="TEXTAREA"){
            return;
        }
        
        //Shift+上下左右�?
        if(e.keyCode == 87 && !e.ctrlKey){ //W 向上�? && e.shiftKey
            displaySheet.moveSelectedItem({x : 0, y : -1});
            e.returnValue = false; 
        }
        if(e.keyCode == 83 && !e.ctrlKey){ //S 向下�?  && e.shiftKey
            displaySheet.moveSelectedItem({x : 0, y : 1});
            e.returnValue = false; 
        }

        if(e.keyCode == 65 && !e.ctrlKey){ //A 向左�?  && e.shiftKey
            displaySheet.moveSelectedItem({x : -1, y : 0});
            e.returnValue = false; 
        }

        if(e.keyCode == 68 && !e.ctrlKey){ //D 向右�?  && e.shiftKey
            displaySheet.moveSelectedItem({x : 1, y : 0});
            e.returnValue = false; 
        }

        //CTRL+上下左右�?
        if(e.keyCode == 38){ //Up（上箭头�?  && e.ctrlKey
            displaySheet.resizeSelectedItem({x : 0, y : -1});
            e.returnValue = false; 
        }
        if(e.keyCode == 40){ //Down（下箭头�? && e.ctrlKey
            displaySheet.resizeSelectedItem({x : 0, y : 1});
            e.returnValue = false; 
        }

        if(e.keyCode == 37){ //Left（左箭头�?&& e.ctrlKey
            displaySheet.resizeSelectedItem({x : -1, y : 0});
            e.returnValue = false; 
        }

        if(e.keyCode == 39){ //Right（右箭头�? && e.ctrlKey
            displaySheet.resizeSelectedItem({x : 1, y : 0});
            e.returnValue = false; 
        }

        if(e.keyCode == 83 && e.ctrlKey){ //Ctrl+S键按�? 
            saveTemplateJson();
            e.returnValue = false; 
        }

        if(e.keyCode == 90 && e.ctrlKey){ //Ctrl+Z键按�? 
            displaySheet.undoOperation();
            e.returnValue = false; 
        }

        if(e.keyCode == 67){   //C键按�?
            var drawItem = $("#btnCopyItem").data("drawItem");
            if (drawItem) {
                displaySheet.setDrawingContext(drawItem);
            }
        }
    }

    function windowKeyUp(e){
        var event = e || window.event;
        if (event && event.keyCode == 17) {
            displaySheet.isCtrlDown = false;
        }
    }
}