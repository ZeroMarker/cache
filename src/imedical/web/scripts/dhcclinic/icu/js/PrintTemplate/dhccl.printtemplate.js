

$(initPage);

function initPage() {
    
    var sheetContext = new SheetContext({});
    sheetContext.loadSheetData(function(data){

        var displaySheet = new DisplaySheet({
            canvas: document.getElementById("myCanvas"),
            sheet: data.Sheet,
            editMode: false,
            readonly: false,
            valueObject: {},
            onPageResize: function(){
                HIDPI();
            },
            onItemSelected: onItemSelected
        });

        var propertyEditor = new PropertyEditor($("#propertyEditor"), {
            value: {
                type: "Sheet",
                obj: data.Sheet,
                disabled: true
            },
            stylesInfo: displaySheet.getStyles(),
            onPropertyValueChanged: function(valueInfo){
                displaySheet.onPropertyValueChanged(valueInfo);
            },
            onStylesChanged: function(stylesInfo){
                displaySheet.setStyles(stylesInfo);
            }
        });

        var drawItemContolPanel = new DrawItemContolPanel($("#sheetItemControlPanel"), {
            config: templateConfig,
            setDrawingStatus: function (drawItem) {
                displaySheet.setDrawingContext(drawItem);
            }
        });

        function onItemSelected(type, obj){
            propertyEditor.setValue(type, obj);
            setCopyItemButton(type, obj);
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

            var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
            displaySheet.captureClick(canvasLoc);
            displaySheet.onMouseDown(canvasLoc);
        }

        function canvasMouseUp(e) {
            e.preventDefault();

            var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
            displaySheet.onMouseUp(canvasLoc);
        }

        function canvasMouseMove(e) {
            e.preventDefault();

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

            var canvasLoc = getCanvasLocation(displaySheet.canvas, e);
        }

        function canvasContextMenu(e) {
            e.preventDefault();

            displaySheet.clearDrawingContext();
            if (displaySheet.itemMenus != null) {
                displaySheet.itemMenus.menu("destroy");
            }

            var menuList = displaySheet.getMenuList();
            if(menuList && menuList.length > 0){
                var itemMenus = $('<div class="hisui-menu" style="width:140px;"></div>').appendTo('body');
                displaySheet.itemMenus = itemMenus.menu({});

                for(var i = 0; i < menuList.length; i++){
                    displaySheet.itemMenus.menu("appendItem", {
                        text: menuList[i].text,
                        onclick: menuList[i].onMenuClick
                    });
                }

                displaySheet.itemMenus.menu("show", {
                    left: e.pageX,
                    top: e.pageY
                });
            }
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
                                tableCode: "displayTableTest",
                                tableValues: [
                                    { Column1: "测试1", Column2: "测试2", Column3: "测试3", Column4: "测试4", Column5: "测试5", Column6: "测试6" },
                                    { Column1: "测试1", Column2: "测试2", Column3: "测试3", Column4: "测试4", Column5: "测试5", Column6: "测试6" }
                                ]
                            }
                        ]
                    });
                }
                lodopPrintView.print();
            }
        });
        $("#btnLodopPrint").tooltip({content: '打印', position: 'bottom'});

        $("#btnUploadJson").click(function () {
            saveTemplateJson();
        });
        $("#btnUploadJson").tooltip({content: '保存到服务器上,<span style="color:yellow;">快捷键:CTRL+S</span>', position: 'right'});

        $("#btnEditJson").click(function () {
            var sheetData = displaySheet.getSheetData();
            var sheetDataStr = JSON.stringify(sheetData, null, 2);
            var templateEditor = new TemplateEditor({
                value: sheetDataStr,
                config: templateConfig,
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

        $("#btnScriptEditor").linkbutton({
            onClick: function () {
                var jsData = "";
                var data = sheetContext.getJScriptData();
                if(data) jsData = window.atob(data);
                var aceEditor = new AceEditor({
                    value: jsData,
                    onSave: function(val){
                        var JScriptData = window.btoa(val);
                        sheetContext.saveJScriptData(JScriptData);
                    }
                });
                aceEditor.open();
            }
        });
        $("#btnScriptEditor").tooltip({content: 'JS脚本编辑', position: 'bottom'});

        $("#btnCopyItem").linkbutton({
            onClick: function () {
                var drawItem = $(this).data("drawItem");
                if (drawItem) {
                    displaySheet.setDrawingContext(drawItem);
                }
            }
        });
        $("#btnCopyItem").tooltip({content: '复制项目, <span style="color:yellow;">快捷键:C</span>', position: 'bottom'});

        $("#btnTopAlign").linkbutton({
            onClick: function () {
                var result = displaySheet.setMultSelectedAreaItemAlign("topAlign");
                if(!result){
                    $.messager.popover({
                        msg: "请按住CTRL键，选择多个区域项目，才能向上对齐",
                        type: "error"
                    });
                }
            }
        });
        $("#btnTopAlign").tooltip({content: '选择多个区域项目，向上对齐', position: 'bottom'});

        $("#btnBottomAlign").linkbutton({
            onClick: function () {
                var result = displaySheet.setMultSelectedAreaItemAlign("bottomAlign");
                if(!result){
                    $.messager.popover({
                        msg: "请按住CTRL键，选择多个区域项目，才能向下对齐",
                        type: "error"
                    });
                }
            }
        });
        $("#btnBottomAlign").tooltip({content: '选择多个区域项目，向下对齐', position: 'bottom'});

        $("#btnLeftAlign").linkbutton({
            onClick: function () {
                var result = displaySheet.setMultSelectedAreaItemAlign("leftAlign");
                if(!result){
                    $.messager.popover({
                        msg: "请按住CTRL键，选择多个区域项目，才能向左对齐",
                        type: "error"
                    });
                }
            }
        });
        $("#btnLeftAlign").tooltip({content: '选择多个区域项目，向左对齐', position: 'bottom'});

        $("#btnRightAlign").linkbutton({
            onClick: function () {
                var result = displaySheet.setMultSelectedAreaItemAlign("rightAlign");
                if(!result){
                    $.messager.popover({
                        msg: "请按住CTRL键，选择多个区域项目，才能向右对齐",
                        type: "error"
                    });
                }
            }
        });
        $("#btnRightAlign").tooltip({content: '选择多个区域项目，向右对齐', position: 'bottom'});

        $("#btnUndo").linkbutton({
            onClick: function () {
                displaySheet.undoOperation();
            }
        });
        $("#btnUndo").tooltip({content: '撤销上一步操作, <span style="color:yellow;">快捷键:CTRL+Z</span>', position: 'bottom'});


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

        $("#pageNoTabs").PageNoTabs({
            pages: displaySheet.getPageNoArray(),
            hideAddNewButton: false,
            hideRemoveButton: false,
            onPageNoTabSelected: function (pageNo) {
                displaySheet.setCurrentPage(pageNo);
            },
            onAddNewPageTab: function () {
                var addNewPageEditor = new AddNewPageEditor({
                    defaultPage: templateConfig.defaultPage,
                    onAddNewPage: function (page) {
                        if (displaySheet.ifHasPageNo(page.PageNo)) {
                            $.messager.alert("提示", "第" + page.PageNo + "页已存在，请输入新的页码!!");
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
                    $.messager.alert("提示", "第1页不能删除");
                    return;
                }

                $.messager.confirm("确认", "你确定要删除第" + pageNo + "页?", function(r){
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

        function saveTemplateJson(){
            var sheetData = displaySheet.getSheetData();
            sheetContext.setSheetData(sheetData);
            sheetContext.saveSheetData();
        }

        function windowKeyDown(e){
            var event = e || window.event;
    
            if (event && event.keyCode == 17) {
                displaySheet.isCtrlDown = true;
            }
    
            if(document.activeElement.tagName=="INPUT" || document.activeElement.tagName=="TEXTAREA"){
                return;
            }
            
            //Shift+上下左右键
            if(e.keyCode == 87 && !e.ctrlKey){ //W 向上移  && e.shiftKey
                displaySheet.moveSelectedItem({x : 0, y : -1});
                e.returnValue = false; 
            }
            if(e.keyCode == 83 && !e.ctrlKey){ //S 向下移   && e.shiftKey
                displaySheet.moveSelectedItem({x : 0, y : 1});
                e.returnValue = false; 
            }
    
            if(e.keyCode == 65 && !e.ctrlKey){ //A 向左移   && e.shiftKey
                displaySheet.moveSelectedItem({x : -1, y : 0});
                e.returnValue = false; 
            }
    
            if(e.keyCode == 68 && !e.ctrlKey){ //D 向右移   && e.shiftKey
                displaySheet.moveSelectedItem({x : 1, y : 0});
                e.returnValue = false; 
            }
    
            //CTRL+上下左右键
            if(e.keyCode == 38){ //Up（上箭头）   && e.ctrlKey
                displaySheet.resizeSelectedItem({x : 0, y : -1});
                e.returnValue = false; 
            }
            if(e.keyCode == 40){ //Down（下箭头）  && e.ctrlKey
                displaySheet.resizeSelectedItem({x : 0, y : 1});
                e.returnValue = false; 
            }
    
            if(e.keyCode == 37){ //Left（左箭头） && e.ctrlKey
                displaySheet.resizeSelectedItem({x : -1, y : 0});
                e.returnValue = false; 
            }
    
            if(e.keyCode == 39){ //Right（右箭头）  && e.ctrlKey
                displaySheet.resizeSelectedItem({x : 1, y : 0});
                e.returnValue = false; 
            }
    
            if(e.keyCode == 83 && e.ctrlKey){ //Ctrl+S键按下  
                saveTemplateJson();
                e.returnValue = false; 
            }
    
            if(e.keyCode == 90 && e.ctrlKey){ //Ctrl+Z键按下  
                displaySheet.undoOperation();
                e.returnValue = false; 
            }
    
            if(e.keyCode == 67){   //C键按下
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
    }, true);
}

