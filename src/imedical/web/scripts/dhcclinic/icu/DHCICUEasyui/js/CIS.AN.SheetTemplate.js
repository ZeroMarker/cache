/**
 * 手术麻醉模板
 * @param {Object} opts 初始化选项
 */
function SheetTemplate(opts){
    this.options=$.extend({
        boxSize:{width:640,height:400},
        formSize:{width:360,height:300}
    },opts);
    this.init();
}

SheetTemplate.prototype={
    /**
     * 初始化组件
     */
    init:function(){
        this.dom=$("<div></div>").appendTo("body");
        if(this.options.showBox){
            this.templateBox=$("<table id='templateBox'></table>").appendTo(this.dom);
            this.initDomDialog();
            this.initTempalateBox();
        } else if(this.options.showForm){
            var templateBoxArr=["<form id='templateForm' method='post'>",
                            "<input type='hidden' id='TemplateRowId' name='RowId'>",
                            "<div><div class='form-row'>",
                            "<div class='form-title-right6'>选择已有模板</div>",
                            "<div class='form-item-normal'><select id='Templates' name='Templates' class='hisui-combobox'></select></div>",
                            "</div></div>",
                            "<div><div class='form-row'>",
                            "<div class='form-title-right6'>模板代码</div>",
                            "<div class='form-item-normal'><input type='text' id='TemplateCode' name='Code' class='textbox'></div>",
                            "</div></div>",
                            "<div><div class='form-row'>",
                            "<div class='form-title-right6'>模板名称</div>",
                            "<div class='form-item-normal'><input type='text' id='TemplateDesc' name='Description' class='textbox'></div>",
                            "</div></div></form>"];
            this.templateForm=$(templateBoxArr.join("")).appendTo(this.dom);
            this.initDomDialog();
            this.initTemplateForm();
        }
        
    },

    /**
     * 初始化模板表格对话框
     */
    initDomDialog:function(){
        var _this=this;
        var size=_this.options.boxSize;
        var iconCls="icon-paper";
        if(_this.options.showForm){
            size=_this.options.formSize;
            iconCls="icon-w-edit";
        }
        var buttons=[];
        if(_this.options.showForm){
            buttons.push({
                text:"确定",
                iconCls:"icon-w-ok",
                handler:function(){
                    _this.saveTemplate();
                }
            });
        }else{
            buttons.push({
                text:"应用模板",
                iconCls:"icon-w-ok",
                handler:function(){
                    var selectedTemplate=_this.templateBox.datagrid("getSelected");
                    if(!selectedTemplate){
                        $.messager.alert("提示","请先选择一个模板，再应用。","warning");
                    }else{
                        _this.selectTemplate(selectedTemplate);
                    }
                }
            });
        }
        buttons.push({
            text:"退出",
            iconCls:"icon-w-cancel",
            handler:function(){
                _this.exit();
            }
        });

        this.dom.dialog({
            title:_this.options.title,
            width:size.width,
            height:size.height,
            closed:true,
            modal:true,
            iconCls:iconCls,
            buttons:buttons,
            onOpen:function(){
                if(_this.options.showBox){
                    _this.reloadTemplateBox();
                }
                
            },
            onClose:function(){
                _this.dom.remove();
            }
        });
    },

    /**
     * 初始化模板表格
     */
    initTempalateBox:function(){
        var _this=this;
        var columns=[[{
            field:"Code",
            title:"模板代码",
            width:100,
        },{
            field:"Description",
            title:"模板名称",
            width:200,
        },{
            field:"CreateDT",
            title:"创建时间",
            width:150
        },{
            field:"UpdateDT",
            title:"更新时间",
            width:150
        }]];

        var sheetTemplates=_this.getSheetTemplates();
        this.templateBox.datagrid({
            fit:true,
            border:false,
            singleSelect: true,
            checkOnSelect:false,
            selectOnCheck:false,
            rownumbers: true,
            headerCls:"panel-header-gray",
            bodyCls:"panel-header-gray",
            // url: ANCSP.DataQuery,
            columns:columns,
            data:sheetTemplates,
            onDblClickRow:function(rowIndex,rowData){
                _this.selectTemplate(rowData);
            }
        });
    },

    /**
     * 初始化模板表单
     */
    initTemplateForm:function(){
        var _this=this;
        $("#Templates").combobox({
            valueField:"RowId",
            textField:"Description",
            mode:"remote",
            editable:false,
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.SheetTemplate;
                param.QueryName="FindSheetTemplates";
                param.Arg1=_this.options.moduleID;
                param.ArgCnt=1;
            },
            onSelect:function(record){
                _this.templateForm.form("load",record);
            }
        });
    },

    open:function(){
        this.dom.dialog("open");
    },

    /**
     * 选择模板
     * @param {object} template 模板对象
     */
    selectTemplate:function(template){
        var templateDatas=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.SheetTemplate,
            QueryName:"FindTemplateDatas",
            Arg1:template.RowId,
            ArgCnt:1
        },"json");
        if(templateDatas && templateDatas.length>0){
            operDataManager.setOperDataFromTemplate(templateDatas);
            this.exit();
        }
    },

    /**
     * 保存手术麻醉模板表单
     */
    saveTemplate:function(){
        var formData=this.templateForm.serializeJson();
        var moduleID=this.options.moduleID;
        var userID=this.options.userID;
        var templateDatas=operDataManager.getTemplateDatas(".operdata");
        var templateDataStr=dhccl.formatObjects(templateDatas);
        var saveRet=dhccl.runServerMethodNormal(ANCLS.BLL.SheetTemplate,"SaveTemplateData",formData.RowId,formData.Code,formData.Description,moduleID,userID,templateDataStr);
        if(saveRet.indexOf("S^")===0){
            $.messager.popover({msg:"保存模板成功。",type:"success",timeout:1000});
            this.exit();
        }else{
            $.messager.alert("提示","保存模板失败，原因："+saveRet,"error");
        }
    },
    /**
     * 获取模板数据
     */
    getSheetTemplates:function(){
        this.sheetTemplates=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.SheetTemplate,
            QueryName:"FindSheetTemplates",
            Arg1:this.options.moduleID,
            Arg2:this.options.userID,
            ArgCnt:2
        },"json",false);

        return this.sheetTemplates;
    },
    /**
     * 关闭模板数据表格对话框
     */
    exit:function(){
        this.dom.dialog("close");
    },
    /**
     * 重新加载模板表格数据
     */
    reloadTemplateBox:function(){
        this.templateBox.datagrid("reload");
    }
}