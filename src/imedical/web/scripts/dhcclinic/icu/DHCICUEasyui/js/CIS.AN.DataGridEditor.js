function DataGridEditor(opts){
    this.options=$.extend({
        width:800,
        height:600
    },opts);
    this.init();
}
var preRow=0
DataGridEditor.prototype={
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
            title:"表格编辑器-"+_this.options.title,
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
        var columns=[[{
            field:"Field",
            title:"列代码",
            width:120,
        },{
            field:"Title",
            title:"列名称",
            width:180
        },{
            field:"Width",
            title:"列宽度",
            width:80,
            editor:{type:"numberbox"}
        },{
            field:"Hidden",
            title:"隐藏",
            width:80,
            editor:{type:"combobox",options:{
                valueField:"value",
                textField:"text",
                data:CommonArray.TrueOrFalse
            }}
        },{
            field:"Sortable",
            title:"排序",
            width:80,
            editor:{type:"combobox",options:{
                valueField:"value",
                textField:"text",
                data:CommonArray.TrueOrFalse
            }}
        },{
            field:"Order",
            title:"排序顺序",
            width:80,
            editor:{type:"combobox",options:{
                valueField:"value",
                textField:"text",
                data:[{
                    text:"none",
                    value:"none"
                },{
                    text:"asc",
                    value:"asc"
                },{
                    text:"desc",
                    value:"desc"
                }]
            }}
        },{
            field:"SeqNo",
            title:"序号",
            width:100
        }]];

        var toolbar=[{
            id:"btnRefresh",
            text:"刷新",
            iconCls:"icon-refresh",
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
            border:true,
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
            onAfterEdit:_this.editorAfterEdit,
            onLoadSuccess:function(data){
                $("#btnRefresh").parent().css({"padding":"3px 0 3px 0"});
            }
        });

        //$("#btnRefresh").parent(".datagrid-toolbar").css({"padding":"4px;"});
        
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
                this.changeRow(rowIndex,prevIndex);
                this.dataBox.datagrid("selectRow",prevIndex);   
                /*
                var dataRows=this.dataBox.datagrid("getRows");
                var curRow=dataRows[rowIndex];
                var prevRow=dataRows[prevIndex];
                

                var field=curRow.Field
                var prefield=prevRow.Field
                curRow.Field=prefield;
                prevRow.Field=field;

                var title=curRow.Title
                var pretitle=prevRow.Title
                curRow.Title=pretitle;
                prevRow.Title=title;

                var width=curRow.Width
                var prewidth=prevRow.Width
                curRow.Width=prewidth;
                prevRow.Width=width;

                var hidden=curRow.Hidden
                var prehidden=prevRow.Hidden
                curRow.Hidden=prehidden;
                prevRow.Hidden=hidden;

                var sortable=curRow.Sortable
                var presortable=prevRow.Sortable
                curRow.Sortable=presortable;
                prevRow.Sortable=sortable;

                var order=curRow.Order
                var preorder=prevRow.Order
                curRow.Order=preorder;
                prevRow.Order=order;
                //dataRows.sort(dataRow=>dataRow.SeqNo);

                this.dataBox.datagrid("refreshRow",rowIndex);
                this.dataBox.datagrid("refreshRow",prevIndex);*/
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
                this.changeRow(rowIndex,prevIndex);
                this.dataBox.datagrid("selectRow",prevIndex);
                /*
                var curRow=dataRows[rowIndex];
                var prevRow=dataRows[prevIndex];
                var seqNo=curRow.SeqNo;
                var prevSeqNo=prevRow.SeqNo;
                curRow.SeqNo=prevSeqNo;
                prevRow.SeqNo=seqNo;
                //dataRows.sort(dataRow=>dataRow.SeqNo);
                this.dataBox.datagrid("refreshRow",rowIndex);
                this.dataBox.datagrid("refreshRow",prevIndex);
                //this.dataBox.datagrid("load",dataRows);*/
            }
        }
    },
    changeRow:function(rowIndex,prevIndex){
            var dataRows=this.dataBox.datagrid("getRows");
            var curRow=dataRows[rowIndex];
            var prevRow=dataRows[prevIndex];
             
            var field=curRow.Field
            var prefield=prevRow.Field
            curRow.Field=prefield;
            prevRow.Field=field;

            var title=curRow.Title
            var pretitle=prevRow.Title
            curRow.Title=pretitle;
            prevRow.Title=title;

            var width=curRow.Width
            var prewidth=prevRow.Width
            curRow.Width=prewidth;
            prevRow.Width=width;

            var hidden=curRow.Hidden
            var prehidden=prevRow.Hidden
            curRow.Hidden=prehidden;
            prevRow.Hidden=hidden;

            var sortable=curRow.Sortable
            var presortable=prevRow.Sortable
            curRow.Sortable=presortable;
            prevRow.Sortable=sortable;

                var order=curRow.Order
                var preorder=prevRow.Order
                curRow.Order=preorder;
                prevRow.Order=order;
                //dataRows.sort(dataRow=>dataRow.SeqNo);

                this.dataBox.datagrid("refreshRow",rowIndex);
                this.dataBox.datagrid("refreshRow",prevIndex);
                //this.dataBox.datagrid("load",dataRows);
            
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
		this.initDataGrid();
		preRow=0;
        //this.dataBox.datagrid("reload");
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

    editorAfterEdit:function(rowIndex,rowData,changes){
        $(this).datagrid("endEdit",rowIndex);
    }
}

function numberSort(a,b){  
    var number1 = parseFloat(a);  
    var number2 = parseFloat(b);  
      
    return (number1 > number2 ? 1 : -1);    
}  

// function editorAfterEdit(rowIndex,rowData,changes){
//     $(this).datagrid("endEdit",rowIndex);
// }