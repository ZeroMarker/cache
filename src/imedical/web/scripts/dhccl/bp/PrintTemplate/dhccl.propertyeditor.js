
function PropertyEditor(dom, opts){
    this.dom = $(dom);
    this.opts = $.extend(opts, {
        width: 330,
        height: 700,
        border: "1px solid #ccc",
        margin: 10
    });
    this.stylesInfo = [];
    this.init();
}

PropertyEditor.prototype = {
    constructor : PropertyEditor,

    init: function(){
        var opts = this.opts;
        this.dom.empty();
        this.panel = this.dom.panel({
            width:opts.width,
            height:opts.height,
            headerCls: "panel-header-gray",
            title:" "
        });
        if(opts.value){
            this.setValue(opts.value.type, opts.value.obj, opts.value.disabled);
        }
        if(opts.stylesInfo){
            this.stylesInfo = opts.stylesInfo;
        }
    },

    setValue: function(type, obj, disabled){
        var $this = this;
        var table = $("<table></table>");   //.appendTo(dom);
        $.each(obj, function(key, value){
            if(key === "Columns"){
                $this.setColumnsValue(table, type, key, value);
            }
            if(key === "URL"){
                $this.setURLValue(table, type, key, value, obj);
                return;
            }
            if(key === "StyleCode"){
                $this.setStyleValue(table, type, key, value, obj);
                return;
            }
            if (key === "TableInfo"){
                $this.setTableInfoValue(table, type, key, value, obj);
                return;
            }
            if(Array.isArray(value)) return;

            var tr = $("<tr></tr>").appendTo(table);
            var labelTD=$("<td></td>").appendTo(tr);
            var valueTD=$("<td></td>").appendTo(tr);
            var label = $('<label>' + key + ':</label>').appendTo(labelTD);
            if(typeof value == "object"){
                $this.setSubObjectEditor(type, key, valueTD, value, disabled);
            }else{
                var textbox = $('<input type="text" class="textbox" style="width:120px;"/>').appendTo(valueTD);
                textbox.val(value);
                textbox.data("ObjectInfo",{
                    type: type,
                    key: key
                });
                if(disabled) textbox.attr("disabled", true);
                if(key == "Type") textbox.attr("disabled", true);
                textbox.change(function(){
                    var objectInfo =$(this).data("ObjectInfo");
                    var value=$(this).val();
                    if(value == "true") value = true;
                    if(value == "false") value = false;
                    $this.onTextboxValueChanged({
                        type: objectInfo.type,
                        key: objectInfo.key,
                        subKey: "",
                        value: value
                    });
                });
                if(!disabled){
                    $(textbox).dblclick(function(){
                        var value = $(this).val();
                        var richTextEditor = new RichTextEditor({
                            value: value,
                            onSave: function(val){
                                textbox.val(val);
                                textbox.trigger("change");
                            }
                        });
                        richTextEditor.open();
                    });
                }
            }
        });

        this.panel = this.dom.panel({
            title: type,
            content: table
        });
    },

    setSubObjectEditor: function(type, key, container, subObj, disabled){
        var $this = this;
        var table=$("<table></table>").appendTo(container);
        table.css("border","1px solid #ccc");
        $.each(subObj, function(subKey, value){
            var tr = $("<tr></tr>").appendTo(table);
            var td1=$("<td></td>").appendTo(tr);
            var td2=$("<td></td>").appendTo(tr);
            var label = $('<label>' + subKey + ':</label>').appendTo(td1);
            var textbox = $('<input type="text" class="textbox" style="width:120px;"/>').appendTo(td2);
            textbox.val(value);
            if(disabled) textbox.attr("disabled", true);
            textbox.data("ObjectInfo",{
                type: type,
                key: key,
                subKey: subKey
            });
            textbox.change(function(){
                var objectInfo =$(this).data("ObjectInfo");
                var value=$(this).val();
                if(["left","top","width","height","FontSize"].indexOf(objectInfo.subKey) >= 0){
                    if(isNaN(value)) {
                        $(this).css("background-color", "pink");
                        return;
                    }else{
                        $(this).css("background-color", "white");
                    }
                    value = parseInt(value);
                }
                if(value == "true") value = true;
                if(value == "false") value = false;
                $this.onTextboxValueChanged({
                    type: objectInfo.type,
                    key: objectInfo.key,
                    subKey: objectInfo.subKey,
                    value: value
                });
            })
        });
    },

    onTextboxValueChanged: function(valueInfo){
        if(this.opts.onPropertyValueChanged){
            this.opts.onPropertyValueChanged(valueInfo);
        }
    },

    onStylesChanged: function(stylesInfo){
        if(this.opts.onStylesChanged){
            this.opts.onStylesChanged(stylesInfo);
        }
    },

    setStylesInfo: function(stylesInfo){
        this.stylesInfo = stylesInfo;
    },

    setColumnsValue: function(table, type, key, value){
        var $this = this;
        var tr = $("<tr></tr>").appendTo(table);
        var labelTD=$("<td></td>").appendTo(tr);
        var valueTD=$("<td></td>").appendTo(tr);
        var label = $('<label>' + key + ':</label>').appendTo(labelTD);
        var textbox = $('<input type="text" class="textbox" readonly style="width:150px;"/>').appendTo(valueTD);
        
        textbox.val(this.getColumnsDesc(value));
        textbox.data("ObjectInfo",{
            type: type,
            key: key,
            value: value
        });
        textbox.click(function(){
            var objectInfo =$(this).data("ObjectInfo");
            var tableColumnsEditor = new TableColumnsEditor({
                value: objectInfo,
                onSave:function(columnsData){
                    $this.onTextboxValueChanged({
                        type: type,
                        key: key,
                        value: columnsData
                    });
                    textbox.val($this.getColumnsDesc(columnsData));
                }
            });
            tableColumnsEditor.open();
        });
    },

    setURLValue: function(table, type, key, value, obj){
        var $this = this;
        var tr = $("<tr></tr>").appendTo(table);
        var labelTD=$("<td></td>").appendTo(tr);
        var valueTD=$("<td></td>").appendTo(tr);
        var label = $('<label>' + key + ':</label>').appendTo(labelTD);
        var textbox = $('<input type="text" class="textbox" readonly style="width:150px;"/>').appendTo(valueTD);
        
        textbox.val(value);
        textbox.click(function(){
            var width = obj.DisplayRect.width;
            var height = obj.DisplayRect.height;
            var imageReader = new ImageReader({
                value: value,
                imgWidth: width,
                imgHeight: height,
                onSave:function(imgData){
                    $this.onTextboxValueChanged({
                        type: type,
                        key: key,
                        value: imgData
                    });
                    textbox.val(imgData);
                }
            });
            imageReader.open();
        });
    },

    setStyleValue: function(table, type, key, value, obj){
        var $this = this;
        var tr = $("<tr></tr>").appendTo(table);
        var labelTD=$("<td></td>").appendTo(tr);
        var valueTD=$("<td></td>").appendTo(tr);
        var label = $('<label>' + key + ':</label>').appendTo(labelTD);
        var textbox = $('<input type="text" class="textbox" readonly style="width:150px;"/>').appendTo(valueTD);
        
        textbox.val(value);
        textbox.click(function(){
            var styleEditor = new StyleEditor({
                value: $this.stylesInfo,
                onStylesChanged: function(stylesInfo){
                    $this.onStylesChanged(stylesInfo);
                },
                onSave:function(styleCode){
                    $this.onTextboxValueChanged({
                        type: type,
                        key: key,
                        value: styleCode
                    });
                    textbox.val(styleCode);
                }
            });
            styleEditor.open();
        });
    },
    
    getColumnsDesc: function(value){
        var colDescArray = [];
        for(var i = 0; i < value.length; i++){
            var column = value[i];
            var colDesc = column.ColumnDesc;
            colDescArray.push(colDesc);
        }
        return colDescArray.join(",");
    },

    setTableInfoValue: function(table, type, key, value, obj){
        var $this = this;
        var tr = $("<tr></tr>").appendTo(table);
        var labelTD=$("<td></td>").appendTo(tr);
        var valueTD=$("<td></td>").appendTo(tr);
        var label = $('<label>' + key + ':</label>').appendTo(labelTD);
        var textbox = $('<input type="text" class="textbox" readonly style="width:150px;"/>').appendTo(valueTD);
        
        var val = value.Rows.length + "行," + value.Cols.length + "列";
        textbox.val(val);

        var styleCode = obj.StyleCode;
        var tableStyle = null;
        for (var i = 0; i < this.stylesInfo.length; i++) {
            var style = this.stylesInfo[i];
            if (style.StyleCode == styleCode) {
                tableStyle = style;
                break;
            }
        }
        textbox.data("ObjectInfo", obj);

        textbox.click(function(){
            var objectInfo =$(this).data("ObjectInfo");
            var complexTableView = new ComplexTableView({
                complexTable: objectInfo,
                tableStyle: tableStyle,
                onSave: function(tableInfo){
                    $this.onTextboxValueChanged({
                        type: type,
                        key: key,
                        value: tableInfo
                    });
                    textbox.val(tableInfo.Rows.length + "行," + tableInfo.Cols.length + "列");
                }
            });
            complexTableView.open();
        });
    }
}