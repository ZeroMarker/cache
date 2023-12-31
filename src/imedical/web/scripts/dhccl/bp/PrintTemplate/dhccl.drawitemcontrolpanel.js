function DrawItemContolPanel(dom, opts){
    this.dom = $(dom);
    this.opts = $.extend(opts, {
        width: 210,
        border: "1px solid #ccc",
        margin: 10
    });
    this.config = opts.config;
    this.init();
}

DrawItemContolPanel.prototype = {
    constructor: DrawItemContolPanel,

    init: function(){
        this.defaultTitle = this.config.defaultTitle;    
        this.defaultArea = this.config.defaultArea; 
        this.defaultLeftArea = this.config.defaultLeftArea;  
        this.defaultTopArea = this.config.defaultTopArea;  
        this.defaultRightArea = this.config.defaultRightArea;  
        this.defaultBottomArea = this.config.defaultBottomArea;      
        this.defaultTextboxAreaItem = this.config.defaultTextboxAreaItem;      
        this.defaultCheckboxAreaItem = this.config.defaultCheckboxAreaItem;
        this.defaultComboboxAreaItem = this.config.defaultComboboxAreaItem;
        this.defaultHorizontalTextboxAreaItem = this.config.defaultHorizontalTextboxAreaItem;      
        this.defaultVerticalTextboxAreaItem = this.config.defaultVerticalTextboxAreaItem;
        this.defaultImage = this.config.defaultImage;
        this.defaultSignImage = this.config.defaultSignImage;
        this.defaultTable = this.config.defaultTable;
        this.templateItems = this.config.templateItems;
        this.defaultSignatureAreaItem = this.config.defaultSignatureAreaItem;
        this.defaultDateboxAreaItem = this.config.defaultDateboxAreaItem;
        this.defaultDatetimeboxAreaItem = this.config.defaultDatetimeboxAreaItem;
        this.defaultTimespinnerAreaItem = this.config.defaultTimespinnerAreaItem;
        this.defaultHorizontalLine = this.config.defaultHorizontalLine;
        this.defaultVerticalLine = this.config.defaultVerticalLine;
        this.defaultQrCode = this.config.defaultQrCode;
        this.defaultBarCode = this.config.defaultBarCode;
        this.defaultTextareaAreaItem = this.config.defaultTextareaAreaItem;
        this.defaultNumberspinnerAreaItem = this.config.defaultNumberspinnerAreaItem;
        this.defaultComplexTable = this.config.defaultComplexTable;

        this.dom.empty();
        this.initDefaultItem();
        //this.initTemplateItem();
    },

    initDefaultItem: function(){
        var $this = this;
        this.defaultSheetItemContainer = $("<div></div>").appendTo(this.dom);

        this.TitleContainer = $("<div style='padding-top:15px;margin-bottom:15px;'></div>").appendTo(this.defaultSheetItemContainer);
        this.MainContainer = $("<div style='padding-top:15px;margin-bottom:15px;'></div>").appendTo(this.defaultSheetItemContainer);
        this.ItemContainer = $("<div style='padding-top:15px;margin-bottom:15px;'></div>").appendTo(this.defaultSheetItemContainer);
        this.IndependentContainer = $("<div style='padding-top:15px;margin-bottom:15px;'></div>").appendTo(this.defaultSheetItemContainer);

        var defaultTitleButton = $("<a/>").appendTo(this.TitleContainer);
        defaultTitleButton.linkbutton({
            text: $this.defaultTitle.Desc,
            plain:true,
            iconCls:'icon-text',
            onClick: function(){
                var drawItem = {
                    type: "DrawingTitle",
                    value: $this.defaultTitle
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultAreaButton = $("<a/>").appendTo(this.MainContainer);
        defaultAreaButton.linkbutton({
            text: $this.defaultArea.Desc,
            plain:true,
            iconCls:'icon-paper',
            width: 50,
            onClick: function(){
                var drawItem = {
                    type: "DrawingArea",
                    value: $this.defaultArea
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultAreaItemButton.linkbutton({
            text: $this.defaultTextboxAreaItem.Desc,
            plain:true,
            iconCls: "icon-text-word",
            width: 50,
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultTextboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultCheckboxAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultCheckboxAreaItemButton.linkbutton({
            text: $this.defaultCheckboxAreaItem.Desc,
            iconCls: "icon-checkbox",
            plain:true,
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultCheckboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultComboboxAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultComboboxAreaItemButton.linkbutton({
            text: $this.defaultComboboxAreaItem.Desc,
            iconCls: "icon-down-arrow-box",
            plain:true,
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultComboboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultNumberspinnerAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultNumberspinnerAreaItemButton.linkbutton({
            text: $this.defaultNumberspinnerAreaItem.Desc,
            plain:true,
            iconCls: "icon-three-cuboid-green",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultNumberspinnerAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultImageButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultImageButton.linkbutton({
            text: $this.defaultImage.Desc,
            plain:true,
            iconCls: "icon-img-blue",
            onClick: function(){
                var drawItem = {
                    type: "DrawingImage",
                    value: $this.defaultImage
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultTableButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultTableButton.linkbutton({
            text: $this.defaultTable.Desc,
            plain:true,
            iconCls:'icon-paper-table',
            onClick: function(){
                var drawItem = {
                    type: "DrawingTable",
                    value: $this.defaultTable
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultSignatureAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultSignatureAreaItemButton.linkbutton({
            text: $this.defaultSignatureAreaItem.Desc,
            plain:true,
            iconCls: "icon-paper-pen-blue",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultSignatureAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultDateboxAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultDateboxAreaItemButton.linkbutton({
            text: $this.defaultDateboxAreaItem.Desc,
            plain:true,
            iconCls: "icon-paste-board",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultDateboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultTimespinnerAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultTimespinnerAreaItemButton.linkbutton({
            text: $this.defaultTimespinnerAreaItem.Desc,
            plain:true,
            iconCls: "icon-clock-blod",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultTimespinnerAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultDatetimeboxAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultDatetimeboxAreaItemButton.linkbutton({
            text: $this.defaultDatetimeboxAreaItem.Desc,
            iconCls: "icon-paper-clock-bue",
            plain:true,
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultDatetimeboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultHorizontalLineButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultHorizontalLineButton.linkbutton({
            text: $this.defaultHorizontalLine.Desc,
            plain:true,
            iconCls: "icon-minus",
            onClick: function(){
                var drawItem = {
                    type: "DrawingLine",
                    value: $this.defaultHorizontalLine
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultVerticalLineButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultVerticalLineButton.linkbutton({
            text: $this.defaultVerticalLine.Desc,
            plain:true,
            iconCls: "icon-down",
            onClick: function(){
                var drawItem = {
                    type: "DrawingLine",
                    value: $this.defaultVerticalLine
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultQrCodeButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultQrCodeButton.linkbutton({
            text: $this.defaultQrCode.Desc,
            plain:true,
            iconCls: "icon-scanning",
            onClick: function(){
                var drawItem = {
                    type: "DrawingImage",
                    value: $this.defaultQrCode
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultBarCodeButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultBarCodeButton.linkbutton({
            text: $this.defaultBarCode.Desc,
            plain:true,
            iconCls: "icon-gen-barcode",
            onClick: function(){
                var drawItem = {
                    type: "DrawingImage",
                    value: $this.defaultBarCode
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultTextareaAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultTextareaAreaItemButton.linkbutton({
            text: $this.defaultTextareaAreaItem.Desc,
            plain:true,
            iconCls: "icon-paper-switch",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultTextareaAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultHorizontalTextboxAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultHorizontalTextboxAreaItemButton.linkbutton({
            text: $this.defaultHorizontalTextboxAreaItem.Desc,
            plain:true,
            iconCls: "icon-align-justify",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultHorizontalTextboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultVerticalTextboxAreaItemButton = $("<a/>").appendTo(this.ItemContainer);
        defaultVerticalTextboxAreaItemButton.linkbutton({
            text: $this.defaultVerticalTextboxAreaItem.Desc,
            plain:true,
            iconCls: "icon-paper-arrow-down",
            onClick: function(){
                var drawItem = {
                    type: "DrawingAreaItem",
                    value: $this.defaultVerticalTextboxAreaItem
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultComplexTableButton = $("<a/>").appendTo(this.MainContainer);
        defaultComplexTableButton.linkbutton({
            text: $this.defaultComplexTable.Desc,
            plain:true,
            iconCls:"icon-add-note",
            onClick: function(){
                var drawItem = {
                    type: "DrawingComplexTable",
                    value: $this.defaultComplexTable
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultSignImageButton = $("<a/>").appendTo(this.IndependentContainer);
        defaultSignImageButton.linkbutton({
            text: $this.defaultSignImage.Desc,
            plain:true,
            iconCls: "icon-doctor-green-pen",
            onClick: function(){
                var drawItem = {
                    type: "DrawingImage",
                    value: $this.defaultSignImage
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultLeftAreaButton = $("<a/>").appendTo(this.MainContainer);
        defaultLeftAreaButton.linkbutton({
            text: $this.defaultLeftArea.Desc,
            plain:true,
            iconCls:'icon-arrow-left',
            width: 50,
            onClick: function(){
                var drawItem = {
                    type: "DrawingArea",
                    value: $this.defaultLeftArea
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultTopAreaButton = $("<a/>").appendTo(this.MainContainer);
        defaultTopAreaButton.linkbutton({
            text: $this.defaultTopArea.Desc,
            plain:true,
            iconCls:'icon-arrow-top',
            width: 50,
            onClick: function(){
                var drawItem = {
                    type: "DrawingArea",
                    value: $this.defaultTopArea
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultRightAreaButton = $("<a/>").appendTo(this.MainContainer);
        defaultRightAreaButton.linkbutton({
            text: $this.defaultRightArea.Desc,
            plain:true,
            iconCls:'icon-arrow-right',
            width: 50,
            onClick: function(){
                var drawItem = {
                    type: "DrawingArea",
                    value: $this.defaultRightArea
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        var defaultBottomAreaButton = $("<a/>").appendTo(this.MainContainer);
        defaultBottomAreaButton.linkbutton({
            text: $this.defaultBottomArea.Desc,
            plain:true,
            iconCls:'icon-arrow-bottom',
            width: 50,
            onClick: function(){
                var drawItem = {
                    type: "DrawingArea",
                    value: $this.defaultBottomArea
                };
                $this.setDrawingStatus(drawItem);
            }
        });

        this.TitleContainer.panel({
            width: $this.opts.width - 5,
            headerCls: "panel-header-card-gray",
            title:'标题'
        });

        this.MainContainer.panel({
            width: $this.opts.width - 5,
            headerCls: "panel-header-card-gray",
            title:'容器'
        });

        this.ItemContainer.panel({
            width: $this.opts.width - 5,
            headerCls: "panel-header-card-gray",
            title:'容器控件'
        });

        this.IndependentContainer.panel({
            width: $this.opts.width - 5,
            headerCls: "panel-header-card-gray",
            title:'独立控件'
        });

        this.defaultSheetItemPanel = this.defaultSheetItemContainer.panel({
            width: $this.opts.width,
            headerCls: "panel-header-gray",
            title:'默认项目'
        });
    },

    initTemplateItem: function(){
        var $this = this;
        this.templateItemContainer = $("<div></div>").appendTo(this.dom);

        for(var i=0; i< this.templateItems.length; i++){
            var item = this.templateItems[i];
            var drawItem = {
                type: "DrawingAreaItem",
                value: item
            };
            var button = $("<a/>").appendTo(this.templateItemContainer);
            button.data("drawItem", drawItem);
            button.linkbutton({
                text: item.Desc,
                plain:true,
                onClick: function(){
                    var drawItem = $(this).data("drawItem");
                    $this.setDrawingStatus(drawItem);
                }
            });
        }

        this.templateItemPanel = this.templateItemContainer.panel({
            width: $this.opts.width,
            headerCls: "panel-header-gray",
            title:'模板区域项目'
        });
    },

    setDrawingStatus: function(drawItem){
        if(this.opts.setDrawingStatus){
            this.opts.setDrawingStatus(drawItem);
        }
    }
}