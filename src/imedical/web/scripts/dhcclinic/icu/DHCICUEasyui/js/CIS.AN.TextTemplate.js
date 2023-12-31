function TextTemplate(opts){
    this.options=$.extend({
        width:800,
        height:600
    },opts);
    this.init();
}
var preRow=0
TextTemplate.prototype={
    /**
     * 编辑器初始化
     */
    init:function(){
        
        this.dom=$("<div style='padding:10px 10px 0 10px;'></div>").appendTo("body");
        this.dataBox=$("<table></table>").appendTo(this.dom);
        
        this.initDialog();
        this.initDataGrid();

        function getDataToolHtml(){
            var htmlArr=["<div class='form-row-group'><div><div class='form-row'><div class='form-title-normal'>模板描述"];
        }
    },

    /**
     * 初始化对话框
     */
    initDialog:function(){
        var _this=this;
        this.dom.dialog({
            title:"文本模板-"+_this.options.title,
            width:this.options.width,
            height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-edit",
            buttons:[{
                text:"保存",
                iconCls:"icon-w-save",
                handler:function(){
                    _this.save();
                }
            },{
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
        var columns=[[{
            field:"Description",
            title:"列代码",
            width:100,
        }]];

        var toolbar=[{
            text:"查询",
            iconCls:"icon-search",
            plain:true,
            handler:function(){
                _this.reload();
            }
        },{
            text:"上移",
            iconCls:"icon-up",
            plain:true,
            handler:function(){
                _this.moveUp();
            }
        },{
            text:"下移",
            iconCls:"icon-down",
            plain:true,
            handler:function(){
                _this.moveDown();
            }
        },{
            text:"站点",
            iconCls:"icon-save",
            plain:true,
            handler:function(){
                _this.save({
                    DataModule:_this.options.moduleId,
                    Site:window.location.host,
                    SSGroup:"",
                    SSUser:"",
                    UpdateUser:session.UserID,
                    Element:_this.options.elementId
                });
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
                    UpdateUser:session.UserID,
                    Element:_this.options.elementId
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
                    UpdateUser:session.UserID,
                    Element:_this.options.elementId
                });
            }
        }];

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
            data:_this.options.data,
            sortName:"SeqNo",
            onClickCell: function(index, field, value) {

                $(this).datagrid("beginEdit",index,field);
                if(preRow!=0)
                {
                    $(this).datagrid("endEdit",preRow);
                   
                }
                preRow=index
            },
            /*
            onClickRow:function(rowIndex,rowData){
                $(this).datagrid("beginEdit",rowIndex);
            },*/
            onAfterEdit:editorAfterEdit,
        });
    },

    /**
     * 移到首列
     */
    moveFirst:function(){

    },

    /**
     * 移到尾列
     */
    moveLast:function(){

    },

    /**
     * 显示顺序上移
     */
    moveUp:function(){
        var _this=this;
        
        if(dhccl.hasRowSelected(this.dataBox,true)){
            var selectedRow=this.dataBox.datagrid("getSelected");
            var rowIndex=this.dataBox.datagrid("getRowIndex",selectedRow);
            if(rowIndex>0){
                var prevIndex=rowIndex-1;
                var dataRows=this.dataBox.datagrid("getRows");
                var curRow=dataRows[rowIndex];
                var prevRow=dataRows[prevIndex];
                var seqNo=curRow.SeqNo;
                var prevSeqNo=prevRow.SeqNo;
                curRow.SeqNo=prevSeqNo;
                prevRow.SeqNo=seqNo;
                //dataRows.sort(dataRow=>dataRow.SeqNo);

                this.dataBox.datagrid("refreshRow",rowIndex);
                this.dataBox.datagrid("refreshRow",prevIndex);
                //this.dataBox.datagrid("load",dataRows);
            }
        }
    },

    /**
     * 显示顺序下移
     */
    moveDown:function(){
        var _this=this;
        
        if(dhccl.hasRowSelected(this.dataBox,true)){
            var selectedRow=this.dataBox.datagrid("getSelected");
            var rowIndex=this.dataBox.datagrid("getRowIndex",selectedRow);
            var dataRows=this.dataBox.datagrid("getRows");
            if(rowIndex<dataRows.length-1){
                var prevIndex=rowIndex+1;
                
                var curRow=dataRows[rowIndex];
                var prevRow=dataRows[prevIndex];
                var seqNo=curRow.SeqNo;
                var prevSeqNo=prevRow.SeqNo;
                curRow.SeqNo=prevSeqNo;
                prevRow.SeqNo=seqNo;
                //dataRows.sort(dataRow=>dataRow.SeqNo);
                this.dataBox.datagrid("refreshRow",rowIndex);
                this.dataBox.datagrid("refreshRow",prevIndex);
                //this.dataBox.datagrid("load",dataRows);
            }
        }
    },

    /**
     * 保存
     */
    save:function(datagrid){
        var _this=this;
        datagrid.ClassName=ANCLS.Config.DataGrid;
        var saveDatas=[datagrid];
        var dataColumns=_this.dataBox.datagrid("getRows");
        for (var i = 0; i < dataColumns.length; i++) {
            _this.dataBox.datagrid("endEdit",i);
            var dataColumn = dataColumns[i];
            dataColumn.ClassName=ANCLS.Config.DataColumn;
            if(!dataColumn.DataGrid) dataColumn.DataGrid="";
            saveDatas.push(dataColumn);
        }
        if(saveDatas.length>0){
            var saveDataStr=dhccl.formatObjects(saveDatas);
            dhccl.saveDatas(ANCSP.DataListService,{
                ClassName:ANCLS.BLL.DataGrid,
                MethodName:"SaveDataGridSettings",
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
    }
}

function numberSort(a,b){  
    var number1 = parseFloat(a);  
    var number2 = parseFloat(b);  
      
    return (number1 > number2 ? 1 : -1);    
}  

function editorAfterEdit(rowIndex,rowData,changes){
    $(this).datagrid("endEdit",rowIndex);
}