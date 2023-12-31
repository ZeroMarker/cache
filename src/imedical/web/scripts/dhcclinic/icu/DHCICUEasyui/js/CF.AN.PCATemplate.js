function PCATemplate(opts){
    this.options=$.extend(opts,{width:1000,height:600});
    
    this.init();
}

PCATemplate.prototype={
    init:function(){
        this.dom=$("<div id='PCADialog'></div>").appendTo("body");
        var formArr=[
            "<div id='PCALayout' class='hisui-layout' data-options='fit:true'>",
                "<div data-options='region:\"west\",border:false,split:false' style='width:500px;'>",
                    "<div id='PCATemplateLayout' class='hisui-layout' data-options='fit:true'>",
                        "<div data-options='region:\"center\",border:false' style='padding:10px 0 10px 10px;'>",
                            "<table id='templateBox'></table>",
                            "<div id='templateTool'>",
                                "<form id='templateForm'>",
                                    "<div class='form-row-group'>",
                                        "<div>",
                                            "<div class='form-row'>",
                                                "<div class='form-title-normal'>模板名称</div>",
                                                "<div class='form-item-normal'>",
                                                    "<input type='text' class='textbox' id='templateDesc' name='ShortDesc' style='width:120px'>",
                                                "</div>",
                                                "<div class='form-title-normal'>模板类型</div>",
                                                "<div class='form-item-normal'>",
                                                    "<select class='hisui-combobox' id='templateType' name='Permission' style='width:120px'></select>",
                                                "</div>",
                                                "<input type='hidden' id='templateRowId' name='RowId'>",
                                            "</div>",
                                        "</div>",
                                    "</div>",
                                    "<div class='form-row-group' style='padding:3px 0'>",
                                        "<a href='#' id='btnAddTemplate' iconCls='icon-add' plain='true'>新增</a>",
                                        "<a href='#' id='btnEditTemplate' iconCls='icon-write-order' plain='true'>修改</a>",
                                        "<a href='#' id='btnDelTemplate' iconCls='icon-remove' plain='true'>删除</a>",
                                    "</div>",
                                "</form>",
                            "</div>",
                        "</div>",
                        // "<div data-options='region:\"south\",border:false' style='height:40px'>",
                        //     "<div style='text-align:center'>",
                        //         "<span style='margin-right:10px;'>事件时间</span>",
                        //         "<span class='form-item-normal'><input type='hisui-datetimebox' id='eventTime'></span>",
                        //         "<span class='form-btn'><a href='#' class='hisui-linkbutton' iconCls='icon-w-batch-add' id='btnAppTemplateData'>应用模板</a></span>",
                        //     "</div>",
                        // "</div>",
                    "</div>",
                "</div>",
                "<div data-options='region:\"center\",border:false' style='padding:10px 10px 0 10px;'>",
                    "<div id='PCADataLayout' class='hisui-layout' data-options='fit:true'>",
                        "<div data-options='region:\"center\",border:false' style='padding:0 0 10px 0;'>",
                            "<div id='PCADataPanel' class='hisui-panel'>",
                                "<form id='dataForm'>",
                                "</form>",
                            "</div>",
                        "</div>",
                        "<div data-options='region:\"south\",border:false' style='height:40px'>",
                            "<div style='text-align:center'>",
                                "<span class='form-btn'><a href='#' class='hisui-linkbutton' iconCls='icon-w-save' id='btnSaveTemplateData'>保存</a></span>",
                                "<span class='form-btn'><a href='#' class='hisui-linkbutton' iconCls='icon-w-cancel' id='btnClearTemplateData'>清空</a></span>",
                            "</div>",
                        "</div>",
                    "</div>",
                "</div>",
            "</div>"
        ];
        $(formArr.join("")).appendTo(this.dom);
        this.templateBox=$("#templateBox");
        $("#PCALayout,#PCATemplateLayout,#PCADataLayout").layout();
        $("#PCADataPanel").panel({
            iconCls:"icon-paper",
            title:"配方明细",
            fit:true,
            headerCls:"panel-header-gray"
        });
        
        this.initDom();
        this.initTemplateBox();
        this.initDataForm();
    },

    initDom:function(){
        var _this=this;
        this.dom.dialog({
            title:"术后镇痛配方模板",
            iconCls:"icon-paper",
            width:this.options.width,
            height:this.options.height,
            modal:true,
            closed:true,
            onOpen:function(){

            },
            onClose:function(){
                if(_this.dom){
                    _this.dom.remove();
                }   
                
            }
        })
    },

    initTemplateBox:function(){
        var _this=this;

        // var now=(new Date()).format("yyyy-MM-dd HH:mm");
        // $("#eventTime").datetimebox({
        //     showSeconds:false
        // });
        // $("#eventTime").datetimebox("setValue",now);

        $("#templateType").combobox({
            valueField:"value",
            textField:"text",
            data:[{
                value:"Private",
                text:"个人模板",
            },{
                value:"Public",
                text:"公共模板"
            }],
            editable:false
        });

        var columns=[[
            {field:"ShortDesc",title:"模板名称",width:100},
            {field:"PermissionDesc",title:"模板类型",width:80},
            {field:"CreateUserDesc",title:"创建用户",width:80},
            {field:"CreateDT",title:"创建时间",width:160}
        ]];

        $("#templateBox").datagrid({
            fit:true,
            title:"配方模板",
            headerCls:"panel-header-gray",
            iconCls:"icon-paper",
            rownumbers: true,
            singleSelect:true,
            toolbar:"#templateTool",
            columns:columns,
            url:ANCSP.DataQuery,
            onBeforeLoad:function(param){
                param.ClassName=ANCLS.BLL.ConfigQueries;
                param.QueryName="FindPreferedDataByDataItem";
                param.Arg1=_this.options.ModuleID;
                param.Arg2=_this.options.DeptID;
                param.Arg3=_this.options.UserID;
                param.Arg4=_this.options.DataItemID;
                param.ArgCnt=4;
            },

            onSelect:function(rowIndex,rowData){
                $("#templateForm").form("load",rowData);
                var templateDatas=_this.getTemplateData(rowData.RowId);
                _this.loadDataFormValue(templateDatas);
            }
        });

        $("#btnAddTemplate").linkbutton({
            onClick:function(){
                var template=$("#templateForm").serializeJson();
                template.ClassName=ANCLS.Config.UserPreferedData;
                template.DataModule=_this.options.ModuleID;
                template.Category=_this.options.Category;
                template.CategoryItem=_this.options.CategoryItem;
                template.Type="E";
                template.CreateUserID=_this.options.UserID;
                template.UpdateUser=_this.options.UserID;
                template.Dept=_this.options.DeptID;
                template.Description=_this.options.DataItemDesc;
                template.DataItem=_this.options.DataItemID;
                template.RowId="";
                var jsonStr=dhccl.formatObjects(template);
                var saveRet=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:jsonStr
                });
                if(saveRet.indexOf("S^")===0){
                    $.messager.popover({msg:"新增术后镇痛配方模板成功。",type:"success",timeout:1500});
                    $("#templateForm").form("clear");
                    $("#templateBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","新增术后镇痛配方模板失败。","error");
                }
            }
        });

        $("#btnEditTemplate").linkbutton({
            onClick:function(){
                var selectedTemplate=$("#templateBox").datagrid("getSelected");
                if(!selectedTemplate){
                    $.messager.alert("提示","请先选择模板，再修改。","warning");
                    return;
                }
                var template=$("#templateForm").serializeJson();
                template.ClassName=ANCLS.Config.UserPreferedData;
                template.Description=_this.options.DataItemDesc;
                template.UpdateUser=_this.options.UserID;
                var jsonStr=dhccl.formatObjects(template);
                var saveRet=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:jsonStr
                });
                if(saveRet.indexOf("S^")===0){
                    $.messager.popover({msg:"修改术后镇痛配方模板成功。",type:"success",timeout:1500});
                    $("#templateForm").form("clear");
                    $("#templateBox").datagrid("reload");
                }else{
                    $.messager.alert("提示","修改术后镇痛配方模板失败。","error");
                }
            }
        });

        $("#btnDelTemplate").linkbutton({
            onClick:_this.delTemplate
        });

        // $("#btnAppTemplateData").linkbutton({
        //     onClick:function(){

        //     }
        // });
    },

    reselectTemplate:function(){
        var selectedTemplate=$("#templateBox").datagrid("getSelected");
        if(selectedTemplate){
            var selectedIndex=$("#templateBox").datagrid("getRowIndex",selectedTemplate);
            $("#templateBox").datagrid("selectRow",selectedIndex); 
        }
    },

    initDataForm:function(){
        var _this=this;
        var eventOptions=this.options.EventOptions;
        var eventOptionArr=[];
        var maxLength=6,titleClass="form-title-right"+maxLength;
        for(var i=0;i<eventOptions.length;i++){
            var eventOption=eventOptions[i];
            var editorHtml="";
            if(eventOption.Editor==="combobox"){
                var valueRangeArr=eventOption.ValueRange.split(";");
                var valueRanges=[];
                for(var j=0;j<valueRangeArr.length;j++){
                    valueRanges.push({
                        value:valueRangeArr[j],
                        text:valueRangeArr[j]
                    });
                }
                var width=Number(eventOption.EditorSize)+7;
                editorHtml="<input data-unit='"+(eventOption.Unit || '')+"' data-rowid='' data-title='"+eventOption.Description+"' data-eventoption='"+eventOption.RowId+"' id='"+eventOption.Description+"' name='"+eventOption.Description+"' class='hisui-combobox' style='width:"+width+"px;' data-options='valueField:\"value\",textField:\"text\",data:"+(JSON.stringify(valueRanges))+",editable:false'>"
            }else{
                var hisuiClass="hisui-"+eventOption.Editor;
                editorHtml="<input data-unit='"+(eventOption.Unit || '')+"' data-rowid='' data-title='"+eventOption.Description+"' data-eventoption='"+eventOption.RowId+"' id='"+eventOption.Description+"' name='"+eventOption.Description+"' class='"+hisuiClass+"' style='width:"+eventOption.EditorSize+"px;'>";
            }
            var htmlArr=[
                "<div>",
                    "<div class='form-row'>",
                        "<div class='"+titleClass+"'>"+eventOption.Description+"</div>",
                        "<div class='form-item-normal'>",
                            editorHtml,
                            "<span class='form-item-unit'>"+(eventOption.Unit || '')+"</span>",
                        "</div>",
                    "</div>",
                "</div>"
            ];
            eventOptionArr.push(htmlArr.join(""));
        }

        $(eventOptionArr.join("")).appendTo("#dataForm");
        
        $.parser.parse("#PCADataPanel");
        

        $("#btnClearTemplateData").linkbutton({
            onClick:function(){
                $("#dataForm").form("clear");
            }
        });

        $("#btnSaveTemplateData").linkbutton({
            onClick:function(){
                var templateData=$("#dataForm").serializeJson();
                var templateDatas=[];
                var PCATemplate=$("#templateBox").datagrid("getSelected");
                for(var key in templateData){
                    var selector="#"+key;
                    var dataTitle=$(selector).attr("data-title");
                    var eventOption=$(selector).attr("data-eventoption");
                    var dataValue=templateData[key] || '';
                    var dataRowId=$(selector).attr("data-rowid");
                    var dataUnit=$(selector).attr("data-unit");
                    if(!dataValue && !dataRowId) continue;
                    templateDatas.push({
                        ClassName:ANCLS.Config.UserPreferedEventDetail,
                        DataValue:dataValue,
                        DataTitle:dataTitle,
                        EventDetailItem:eventOption,
                        UserPreferedData:PCATemplate.RowId,
                        RowId:(dataRowId || ''),
                        DataUnit:dataUnit
                    });
                }
                var saveRet=dhccl.saveDatas(ANCSP.DataListService,{
                    jsonData:dhccl.formatObjects(templateDatas)
                });
                if(saveRet.indexOf("S^")===0){
                    $.messager.popover({msg:"保存配方明细成功",timeout:1500,type:"success"});
                    _this.reselectTemplate();
                }else{
                    $.messager.alert("提示","保存配方明细失败，原因："+saveRet,"error");
                }
            }
        });
    },

    loadDataFormValue:function(templateDatas){
        if(templateDatas && templateDatas.length>0){
            var formData={};
            for(var i=0;i<templateDatas.length;i++){
                var templateData=templateDatas[i];
                formData[templateData.DataTitle]=templateData.DataValue;
                var selector="#"+templateData.DataTitle;
                $(selector).attr("data-rowid",templateData.RowId);
            }
            $("#dataForm").form("load",formData);
        }
    },

    delTemplate:function(){
        var selectedTemplate=$("#templateBox").datagrid("getSelected");
        if(!selectedTemplate){
            $.messager.alert("提示","请先选择模板，再修改。","warning");
            return;
        }

        var saveRet=dhccl.removeData(ANCLS.Config.UserPreferedData,selectedTemplate.RowId);
        if(saveRet.indexOf("S^")===0){
            $.messager.popover({msg:"删除术后镇痛配方模板成功",type:"success",timeout:1500});
        }
    },

    appTemplate:function(){

    },

    getTemplateData:function(templateId){
        var templateDatas=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.ConfigQueries,
            QueryName:"FindPreferedEventDetail",
            Arg1:templateId,
            ArgCnt:1
        },"json");

        return templateDatas;
    },

    open:function(){
        this.dom.dialog("open");
    },

    close:function(){
        this.dom.dialog("close");
    }
}

var PCATool={
    openPCATemplate:function(){
        var template=new PCATemplate({
            DeptID:session.DeptID,
            UserID:session.UserID,
            EventOptions:[]
        });
        template.open();
    }
}