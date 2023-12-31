function SheetSettings(opts){
    this.options=$.extend({
        width:900,
        height:720
    },opts);
    this.init();
}

SheetSettings.prototype={
    /**
     * 编辑器初始化
     */
    init:function(){
        
        this.dom=$("<div style='padding:10px 10px 0 10px;'></div>").appendTo("body");
        this.dataBox=$("<table></table>").appendTo(this.dom);
        this.initDialog();
        this.initDataGrid();
    },

    /**
     * 初始化对话框
     */
    initDialog:function(){
        var _this=this;
        this.dom.dialog({
            title:"页面编辑器-"+_this.options.title,
            width:this.options.width,
            height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-w-edit",
            buttons:[{
                text:"退出",
                iconCls:"icon-w-cancel",
                handler:function(){
                    _this.exit();
                }
            }],
            onOpen:function(){
                _this.reload();
                if(_this.options.openCallBack)
                    _this.options.openCallBack();
            },
            onClose:function(){
                if(_this.options.closeCallBack)
                    _this.options.closeCallBack();
            }
        });
    },

    /**
     * 初始化数据表格
     */
    initDataGrid:function(){
        var _this=this;
        let columns=[[{
            field:"ElementDesc",
            title:"元素名称",
            width:200,
        },{
            field:"ElementID",
            title:"元素ID",
            width:200,
        },{
            field:"ControlType",
            title:"控件类型",
            width:180
        },{
            field:"Enable",
            title:"可用",
            width:80,
            editor:{type:"combobox",options:{
                valueField:"value",
                textField:"value",
                data:CommonArray.WhetherOrNot
            }}
        },{
            field:"Visible",
            title:"可见",
            width:80,
            editor:{type:"combobox",options:{
                valueField:"value",
                textField:"value",
                data:CommonArray.WhetherOrNot
            }}
        },{
            field:"Required",
            title:"必填项",
            width:80,
            editor:{type:"combobox",options:{
                valueField:"value",
                textField:"value",
                data:CommonArray.WhetherOrNot
            }}
        }]];

        let toolbar=[{
            text:"刷新",
            iconCls:"icon-refresh",
            plain:true,
            handler:function(){
                _this.reload();
            }
        },{
            text:"安全组",
            iconCls:"icon-save",
            plain:true,
            handler:function(){
                _this.save({
                    DataModule:_this.options.moduleId,
                    Site:window.location.host,
                    SSGroup:session.GroupID,
                    SSUser:"",
                    UpdateUser:session.UserID
                });
            }
        },{
            text:"用户",
            iconCls:"icon-save",
            plain:true,
            handler:function(){
                _this.save({
                    DataModule:_this.options.moduleId,
                    Site:window.location.host,
                    SSGroup:session.GroupID,
                    SSUser:session.UserID,
                    UpdateUser:session.UserID
                });
            }
        }]; 

        let elementDatas=_this.getData();
        this.dataBox.datagrid({
            fit:true,
            singleSelect: true,
            checkOnSelect:false,
            selectOnCheck:false,
            rownumbers: true,
            headerCls:"panel-header-gray",
            bodyCls:"panel-header-gray",
            url: ANCSP.DataQuery,
            columns:columns,
            toolbar:toolbar,
            data:elementDatas,
            sortName:"SeqNo",
            // idField: "ElementID",
            // treeField: "ElementDesc",
            onClickRow:function(rowIndex,rowData){
                $(this).datagrid("beginEdit",rowIndex);
            }
        });
    },

    /**
     * 保存
     */
    save:function(elementPermission){
        var _this=this;
        elementPermission.ClassName=ANCLS.Config.SheetPermission;
        let saveDatas=[elementPermission];
        let permissionItems=_this.dataBox.datagrid("getRows");
        for (let i = 0; i < permissionItems.length; i++) {
            _this.dataBox.datagrid("endEdit",i);
            let permissionItem = permissionItems[i];
            if(!permissionItem.SheetPermission) permissionItem.SheetPermission="";
            saveDatas.push({
                RowId:permissionItem.RowId,
                ElementID:permissionItem.ElementID,
                ElementDesc:permissionItem.ElementDesc||"",
                Enable:permissionItem.Enable,
                Visible:permissionItem.Visible,
                SheetPermission:permissionItem.SheetPermission,
                ControlType:permissionItem.ControlType,
                Required:permissionItem.Required,
                ClassName:ANCLS.Config.SheetElement
            });
        }
        if(saveDatas.length>0){
            let saveDataStr=dhccl.formatObjects(saveDatas);
            dhccl.saveDatas(ANCSP.DataListService,{
                ClassName:ANCLS.BLL.SheetSettings,
                MethodName:"SaveSheetSettings",
                jsonData:saveDataStr
            },function(data){
                if(data.indexOf("S^")===0){
                    $.messager.alert("提示","保存成功","info");
                }else{
                    $.messager.alert("提示","保存失败，原因："+data,"error");
                }
            })
        }
    },

    /**
     * 退出
     */
    exit:function(){
        this.close();
    },

    /**
     * 重新加载表格配置数据
     */
    reload:function(){
        this.dataBox.datagrid("reload");
    },

    /**
     * 打开对话框
     */
    open:function(){
        this.dom.dialog("open");
    },

    /**
     * 关闭对话框
     */
    close:function(){
        this.dom.dialog("close");
    },

    getData:function(){
        let _this=this;

        let sheetElements=dhccl.getDatas(ANCSP.MethodService,{
            ClassName:ANCLS.BLL.SheetSettings,
            MethodName:"GetSheetElements",
            Arg1:session.ModuleID,
            Arg2:session.GroupID,
            Arg3:session.UserID,
            ArgCnt:3
        },"json");
        if(sheetElements && sheetElements.length>0){
            return sheetElements;
        }
        let elements=[];
        $(".operdata").each(function(index,item){
            let controlType=_this.getControlType($(item));
            let element={
                ElementID:$(item).attr("id"),
                ElementDesc:$(item).attr("data-title"),
                ControlType:controlType,
                Enable:"Y",
                Visible:"Y",
                Required:"N",
                SheetPermission:"",
                RowId:""
            };
            elements.push(element);

            let elementId=$(item).attr("id");
            $("[data-formitem='"+elementId+"']").each(function(index,subItem){
                let subControlType=_this.getControlType($(subItem));
                elements.push({
                    ElementID:$(subItem).attr("id"),
                    ElementDesc:$(subItem).attr("data-title"),
                    ControlType:subControlType,
                    Enable:"Y",
                    Visible:"Y",
                    Required:"N",
                    SheetPermission:"",
                    RowId:""
                });
            });
        });

        $(".hisui-linkbutton").each(function(index,item){
            let elementId=$(item).attr("id");
            let elementDesc=$(item).attr("data-title");
            let elementClass=_this.getControlType($(item));;
            let required="N";
            let enable="Y";
            let visible="Y";
            elements.push({
                ElementID:elementId,
                ElementDesc:elementDesc,
                ControlType:elementClass,
                Enable:enable,
                Visible:visible,
                Required:required,
                SheetPermission:"",
                RowId:""
            });
        });

        return elements
    },

    getControlType:function(jQueryObj){
        if(jQueryObj.hasClass("hisui-validatebox")){
            return "hisui-validatebox";
        }

        if (jQueryObj.hasClass("hisui-datebox")){
            return "hisui-datebox";
        }

        if(jQueryObj.hasClass("hisui-datetimebox")){
            return "hisui-datetimebox";
        }

        if(jQueryObj.hasClass("hisui-numberbox")){
            return "hisui-numberbox";
        }

        if(jQueryObj.hasClass("hisui-checkbox")){
            return "hisui-checkbox";
        }

        if(jQueryObj.hasClass("hisui-combobox")){
            return "hisui-combobox";
        }

        if(jQueryObj.hasClass("hisui-combogrid")){
            return "hisui-combogrid";
        }

        if(jQueryObj.hasClass("hisui-triggerbox")){
            return "hisui-triggerbox";
        }

        if(jQueryObj.hasClass("hisui-numberspinner")){
            return "hisui-numberspinner";
        }

        if(jQueryObj.hasClass("hisui-timespinner")){
            return "hisui-timespinner";
        }

        if(jQueryObj.hasClass("hisui-searchbox")){
            return "hisui-searchbox";
        }

        if(jQueryObj.hasClass("hisui-switchbox")){
            return "hisui-switchbox";
        }

        if(jQueryObj.hasClass("textbox")){
            return "textbox";
        }

        if(jQueryObj.hasClass("hisui-linkbutton")){
            return "hisui-linkbutton";
        }

        return "";
    }
}