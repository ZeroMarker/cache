var PageLogicObj={
    'User.DHCItmConflict':{
        'ITCConflictType':[{id:'',text:''},{id:'R',text:'反'},{id:'F',text:'畏'}],
        'ITCShortConflictType':[{id:'',text:''},{id:'DT',text:'当日提醒'},{id:'AT',text:'本次就诊提醒'},{id:'DF',text:'当日禁开'},{id:'AF',text:'本次就诊禁开'}],
        'ITCLongConflictType':[{id:'',text:''},{id:'DT',text:'当日提醒'},{id:'AT',text:'本次就诊提醒'},{id:'S',text:'停止'},{id:'DF',text:'当日禁开'},{id:'AF',text:'本次就诊禁开'}]
    }
};
$(function(){
    $.extend(GenHospComp("DHC_ItmMast").jdata.options,{
        onSelect:function(index,row){
            $('#tabArcimList').datagrid('load');
        },
        onLoadSuccess:function(data){
            InitSearchBox();
            InitArcimGrid();
            InitConflictGrid();
            InitReplaceGrid();
            InitStopDefDate();
            InitTip();
            InitCombo();
            InitEvent();
        }
    });
});
function InitEvent(){
    $('#BSave').click(SaveData);
    $('#DARCIMStopAfterLongOrder').checkbox({
        onCheckChange:function(e,value){
            if(value){
                $('#DARCIMAllowLongOrder').checkbox('enable');
            }else{
                $('#DARCIMAllowLongOrder').checkbox('disable').checkbox('setValue',false);
            }
        }
    });
}
function InitCombo(){
    $("#DARCIMSpecLocDiag").combobox({
		valueField:'Code', textField:'Name',panelHeight:"auto",
		mode:'remote',
		url:$URL+"?ClassName=DHCDoc.Diagnos.SpecLocTemp&QueryName=QueryCat&ResultSetType=array"
	});
}
function InitArcimGrid(){
    var toolbar=[{
		text:'增加',
		iconCls: 'icon-add',
		handler: function(){
            $('#tabArcimList').datagrid('appendRow',{});
            var rows= $('#tabArcimList').datagrid('getRows');
            $('#tabArcimList').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'删除',
		iconCls: 'icon-remove',
		handler: function(){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
                return;
            }
            if(Selected.ID){
                $.messager.confirm('提示','确定删除此条数据?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCItmMast',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"删除成功",type:'success'});
                            $('#tabArcimList').datagrid('load');
                        }else{
                            $.messager.alert('提示','删除失败:'+ret);
                        }
                    }
                });
            }else{
                var index=$('#tabArcimList').datagrid('getRowIndex',Selected);
                $('#tabArcimList').datagrid('deleteRow',index);
            }
		}
	},'-',{
		text:'保存',
		iconCls: 'icon-save',
		handler: function(){
            var SaveRows=$('#tabArcimList').datagrid('getEditRows');
            if(!SaveRows.length){
                $.messager.popover({msg:"没有需要保存的数据",type:'alert'});
                return;
            }
            var ret=$.cm({
                ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                MethodName:'SaveData',
                ClsNameStr:JSON.stringify(['User.DHCItmMast']),
                InputStr:JSON.stringify([SaveRows]),
                dataType:'text'
            },false);
            if(ret=='0'){
                $.messager.popover({ msg: '保存成功!',type:'success'});
                $('#tabArcimList').datagrid('load');
            }else{
                $.messager.alert('提示','保存失败:'+ret);
            }
		}
	},'-',{
		text:'导出',
		iconCls: 'icon-export',
		handler: function(){
            $.messager.progress({text:'导出中...'});
            $cm({
                ResultSetType:"ExcelPlugin",  //表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
                //ResultSetTypeDo:"Print",    //默认Export，可以设置为：PRINT , PREVIEW
                localDir:"Self",	      //D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
                ExcelName:"医嘱项扩展设定",		  //默认DHCCExcel，不用包含后缀
                PageName:"ARCIMEXT",      //表示是哪个界面的导出，防止同一Query多个界面不同定义, 与配置界面PAGENAME一致
                ClassName:"DHCDoc.DHCDocConfig.ARCIMExt",
                QueryName:"QueryItemToExcel",
                HospID:$('#_HospList').getValue(),
                Alias:$('#SearchItem').searchbox('getValue')
            },function(){
                $.messager.progress('close');
            });
        }
    }];
    $('#tabArcimList').datagrid({
        pagination:true,
        pageSize:15,
		pageList : [15,50,100,200],
        toolbar:toolbar,
        columns:[[
            {field:'ID',hidden:true}, 
            {field:'ARCIMRowid',hidden:true},
            {field:'ARCIMDesc',title:'医嘱名称',width:200,valueField:'DARCIMARCIMDR',
                editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'ArcimRowID',
                        textField:'ARCIMDesc',
                        columns:[[  
                            {field:'ARCIMDesc',title:'名称',width:320,sortable:true},
                            {field:'ArcimRowID',title:'ID',width:70,sortable:true}
                        ]],
                        pagination:true,
                        panelWidth:400,
                        panelHeight:400,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
                        onBeforeLoad:function(param){
                            param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});    //:session['LOGON.GROUPID']
                        }
                    }
                }
            },
            {field:'CNMedFlag',title:'是否草药',width:55,align:'center',
                styler: function(value,row,index){
                    return value?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value?'是':'否';
                }
            }
        ]],
        onSelect:function(index,row){
            InitData();
        },
        onBeginEdit:function(index,row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'ARCIMDesc'});
            $(ed.target).focus();
        },
        queryParams:{ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',QueryName:'QueryItmMast'},
        onBeforeLoad:function(param){
            param.Alias=$('#SearchItem').searchbox('getValue');
            param.HospID=$('#_HospList').getValue();
            param.ArcimID="";
            var rows=$(this).datagrid('getRows');
            if(rows.length){
                var Editors=$(this).datagrid('getEditors',rows.length-1);
                if(Editors.length)  param.ArcimID=$(Editors[0].target).getValue();
            }
            $(this).datagrid('unselectAll');
            $('#tabConflict,#tabItemReplace').setData([]);
        },
        onLoadSuccess:function(data){
            if(data.rows.length==1){
                $(this).datagrid('selectRow',0);
            }
        }
    });
}
function InitSearchBox()
{
    $('#SearchItem').searchbox({
        prompt:'请输入项目别名...',
        searcher:function(value,name){
            $('#tabArcimList').datagrid('load');
        }
    });
}
function InitData()
{
    var row=$('#tabArcimList').datagrid('getSelected');
    if(!row) return;
    $('#tabConflict,#tabItemReplace').datagrid('load');
    $('body>.layout-panel-center').showMask();
    $.cm({
        ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
        MethodName:'GetRowData',
        ClsName:'User.DHCItmMast', RowID:row.ID
    },function(data){
        $.each(data, function(id, value) {
            $('#'+id).setValue(value);
        });
        $('body>.layout-panel-center').hideMask();
    });
}
function InitStopDefDate(){
    $('#DARCIMStopDefSttDateDay').numberbox({
        min:0,
        max:9,
        onChange:function(val){
            if(val>0){
                $('#DARCIMStopDefSttTime').timespinner('setValue','08:00:00').timespinner('enable');
            }else{
                $('#DARCIMStopDefSttTime').timespinner('setValue','').timespinner('disable');
            }
        }
    })
}
function InitConflictGrid(){
    var toolbar=[{
		text:'增加',
		iconCls: 'icon-add',
		handler: function(){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择医嘱项目",type:'alert'});
                return;
            }
            $('#tabConflict').datagrid('appendRow',{ITCParRef:Selected.ID});
            var rows= $('#tabConflict').datagrid('getRows');
            $('#tabConflict').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'修改',
		iconCls: 'icon-edit',
		handler: function(){
            var Selected= $('#tabConflict').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择需要修改项目",type:'alert'});
                return;
            }
            var index= $('#tabConflict').datagrid('getRowIndex',Selected);
            $('#tabConflict').datagrid('beginEdit',index);
		}
	},'-',{
		text:'删除',
		iconCls: 'icon-remove',
		handler: function(){
            var Selected= $('#tabConflict').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
                return;
            }
            if(Selected.ID){
                $.messager.confirm('提示','确定删除此条数据?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCItmConflict',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"删除成功",type:'success'});
                            $('#tabConflict').datagrid('load');
                        }else{
                            $.messager.alert('提示','删除失败:'+ret);
                        }
                    }
                });
            }else{
                var index=$('#tabConflict').datagrid('getRowIndex',Selected);
                $('#tabConflict').datagrid('deleteRow',index);
            }
		}
	},'-',{
        id:'btnConflictHelp',
		iconCls: 'icon-help'
    }];
    $('#tabConflict').datagrid({
        idField:'ID',
        pagination:false,
        toolbar:toolbar,
        columns:[[
            {field:'ITCParRef',hidden:true}, 
            {field:'ID',hidden:true}, 
            {field:'ITCConflictItmDR',hidden:true},
            {field:'ARCIMDesc',title:'医嘱名称',width:200,valueField:'ITCConflictItmDR',
                editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'ArcimRowID',
                        textField:'ARCIMDesc',
                        columns:[[  
                            {field:'ARCIMDesc',title:'名称',width:320,sortable:true},
                            {field:'ArcimRowID',title:'ID',width:70,sortable:true}
                        ]],
                        pagination:true,
                        panelWidth:400,
                        panelHeight:400,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
                        onBeforeLoad:function(param){
                            param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});    //:session['LOGON.GROUPID']
                        }
                    }
                }
            },
            {field:'ITCShortConflictType',title:'临时互斥操作(非草药使用)',width:70,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        data:PageLogicObj['User.DHCItmConflict']['ITCShortConflictType']
                    }
                },
                formatter: function(value,row,index){
                    return GetPropTextByVal('User.DHCItmConflict','ITCShortConflictType',value);
                }
            },
            {field:'ITCLongConflictType',title:'长期互斥操作(非草药使用)',width:70,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        data:PageLogicObj['User.DHCItmConflict']['ITCLongConflictType']
                    }
                },
                formatter: function(value,row,index){
                    return GetPropTextByVal('User.DHCItmConflict','ITCLongConflictType',value);
                }
            },
            {field:'ITCConflictType',title:'类型(草药使用)',width:70,align:'center',
                editor:{
                    type:'combobox',
                    options:{
                        url:'',
                        editable:false,
                        data:PageLogicObj['User.DHCItmConflict']['ITCConflictType']
                    }
                },
                formatter: function(value,row,index){
                    return GetPropTextByVal('User.DHCItmConflict','ITCConflictType',value);
                }
            }
        ]],
        onBeginEdit:function(index,row){
            var Editors=$('#tabConflict').datagrid('getEditors',index);
            $(Editors[0].target).setValue(row.ITCConflictItmDR,row.ARCIMDesc).select();
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(Selected.CNMedFlag){
                $(Editors[1].target).combobox('disable');
                $(Editors[2].target).combobox('disable');
                $(Editors[3].target).combobox('enable');
            }else{
                $(Editors[1].target).combobox('enable');
                $(Editors[2].target).combobox('enable');
                $(Editors[3].target).combobox('disable');
            }
        },
        queryParams:{ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',QueryName:'QueryConflict'},
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
        onBeforeLoad:function(param){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected) return false;
            param.ITCParRef=Selected.ID;
            $(this).datagrid('unselectAll');
        }
    });
}
function InitReplaceGrid(){
    var toolbar=[{
		text:'增加',
		iconCls: 'icon-add',
		handler: function(){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择医嘱项目",type:'alert'});
                return;
            }
            $('#tabItemReplace').datagrid('appendRow',{IRParRef:Selected.ID});
            var rows= $('#tabItemReplace').datagrid('getRows');
            $('#tabItemReplace').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'修改',
		iconCls: 'icon-edit',
		handler: function(){
            var Selected= $('#tabItemReplace').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择需要修改项目",type:'alert'});
                return;
            }
            var index= $('#tabItemReplace').datagrid('getRowIndex',Selected);
            $('#tabItemReplace').datagrid('beginEdit',index);
		}
	},'-',{
		text:'删除',
		iconCls: 'icon-remove',
		handler: function(){
            var Selected= $('#tabItemReplace').datagrid('getSelected');
            if(!Selected){
                $.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
                return;
            }
            if(Selected.ID){
                $.messager.confirm('提示','确定删除此条数据?',function(r){
                    if(r){
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
                            MethodName:'DeleteData',
                            ClsName:'User.DHCItmReplace',
                            ID:Selected.ID,
                            dataType:'text'
                        },false);
                        if(ret=='0'){
                            $.messager.popover({msg:"删除成功",type:'success'});
                            $('#tabItemReplace').datagrid('load');
                        }else{
                            $.messager.alert('提示','删除失败:'+ret);
                        }
                    }
                });
            }else{
                var index=$('#tabItemReplace').datagrid('getRowIndex',Selected);
                $('#tabItemReplace').datagrid('deleteRow',index);
            }
		}
	}];
    $('#tabItemReplace').datagrid({
        idField:'ID',
        pagination:false,
        toolbar:toolbar,
        columns:[[
            {field:'IRParRef',hidden:true}, 
            {field:'ID',hidden:true}, 
            {field:'IRReplaceItmDR',hidden:true},
            {field:'ARCIMDesc',title:'医嘱名称',width:200,valueField:'IRReplaceItmDR',
                editor:{
                    type:'lookup',
                    options:{
                        url:$URL,
                        mode:'remote',
                        method:"Get",
                        idField:'ArcimRowID',
                        textField:'ARCIMDesc',
                        columns:[[  
                            {field:'ARCIMDesc',title:'名称',width:320,sortable:true},
                            {field:'ArcimRowID',title:'ID',width:70,sortable:true}
                        ]],
                        pagination:true,
                        panelWidth:400,
                        panelHeight:400,
                        isCombo:true,
                        minQueryLen:2,
                        delay:'500',
                        queryOnSameQueryString:true,
                        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
                        onBeforeLoad:function(param){
                            param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});    //:session['LOGON.GROUPID']
                        }
                    }
                }
            },
            {field:'IRReplaceExpress',title:'替换规则(m程序表达式)',width:150,
                editor:{type:'text'}
            }
        ]],
        onBeginEdit:function(index,row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'ARCIMDesc'});
            $(ed.target).setValue(row.IRReplaceItmDR,row.ARCIMDesc).select();
        },
        queryParams:{ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',QueryName:'QueryReplace'},
        onDblClickRow:function(index, row){
            $(this).datagrid('beginEdit',index);
        },
        onBeforeLoad:function(param){
            var Selected= $('#tabArcimList').datagrid('getSelected');
            if(!Selected) return false;
            param.IRParRef=Selected.ID;
            $(this).datagrid('unselectAll');
        }
    });
}
function SaveData(){
    var row=$('#tabArcimList').datagrid('getSelected');
    if(!row){
        $.messager.popover({ msg: '请选择需要保存的医嘱',type:'alert'});
        return;
    }
    var SaveDataArr=[GetNorData(),GetConflictData(),GetReplaceData()];
    var ClsArr=['User.DHCItmMast','User.DHCItmConflict','User.DHCItmReplace'];
    if(!CheckBeforeSave(SaveDataArr)) return;
    var ret=$.cm({
        ClassName:'DHCDoc.DHCDocConfig.ARCIMExt',
        MethodName:'SaveData',
        ClsNameStr:JSON.stringify(ClsArr),
        InputStr:JSON.stringify(SaveDataArr),
        dataType:'text'
    },false);
    if(ret=='0'){
        $.messager.popover({ msg: '保存成功!',type:'success'});
        $('#tabConflict,#tabItemReplace').datagrid('load');
    }else{
        $.messager.alert('提示','保存失败:'+ret);
    }
}
function GetNorData(){
    var row=$('#tabArcimList').datagrid('getSelected');
    var SaveObj=$.extend({},row);
    $('[clsName="User.DHCItmMast"]').find('[id]').each(function(){
        var id=$(this).attr('id');
        var val=$(this).getValue();
        SaveObj[id]=val;
    });
    return [SaveObj];
}
function GetConflictData(){
    var SaveRows=$('#tabConflict').datagrid('getEditRows');
    return SaveRows;
}
function GetReplaceData(){
    var SaveRows=$('#tabItemReplace').datagrid('getEditRows');
    return SaveRows;
}
function CheckBeforeSave(SaveDataArr)
{
    var Selected= $('#tabArcimList').datagrid('getSelected');
    var CNMedFlag=Selected.CNMedFlag;
    if(CNMedFlag){
        var ConflictData=SaveDataArr[1];
        for(var i=0;i<ConflictData.length;i++){
            if(!ConflictData[i].ITCConflictType){
                $.messager.popover({msg:"请选择草药"+ConflictData[i].ARCIMDesc+" 的互斥类型",type:'alert'});
                return false;
            }
        }
    }
    var ReplaceData=SaveDataArr[2];
    for(var i=0;i<ReplaceData.length;i++){
        if(!ReplaceData[i].IRReplaceExpress){
            $.messager.popover({msg:ReplaceData[i].ARCIMDesc+"替换规则不能为空",type:'alert'});
            return false;
        }
    }
    return true;
}
function GetPropTextByVal(ClsName,PropName,val)
{
    var text="";
    $.each(PageLogicObj[ClsName][PropName],function(){
        if(this.id==val){
            text=this.text;
            return false;
        }
    });
    return text;
}
function InitTip(){
    $.fn.tooltip.defaults.onShow=function(){
        $('.combobox-f').combobox('hidePanel');
    }
    $("#btnConflictHelp").tooltip({
		content:"<ul class='tip_class'><li style='font-weight:bold'>医嘱互斥类型使用说明</li>" + 
                '<li>1、[长期互斥操作、临时互斥操作]是针对已审核的医嘱的类型</li>' +
                '<li>2、如果一个项目存在多个互斥项目,互斥项目之间的互斥取控制级别最高的项目进行管控</li>'+
                '<li>3、互斥操作级别优先级:本次就诊禁开>当日禁开>停止(长期默认)>本次就诊提醒>当日提醒(临时默认)</li>'+
                "</ul>"
	});
    $("#tipRepeatCheckDays").tooltip({
		content:"设置天数后将检索患者所有就诊里满足日期的医嘱,不设置只检索当前就诊记录"
	});
	$("#tipConflic").tooltip({
		content:"<ul class='tip_class'><li style='font-weight:bold'>医嘱互斥类型使用说明</li>" + 
                '<li>1、单向:左侧选择项目与下方互斥项内的项目互斥,互斥项内部项目之间不互斥</li>' +
                '<li>2、双向(默认):左侧选择项目与下方互斥项内的项目互斥,互斥项内部项目之间也互斥</li>'+
                "</ul>"
	});
    $('#tipStopLongOrd').tooltip({
        content:"<ul class='tip_class'><li style='font-weight:bold'>配置说明</li>" +
            "<li>1、today代表本日,设置默认日期后在医嘱录入时自动带入默认数据到医嘱开始日期列。</li>" +
            "<li>2、默认日期输入框应大于等于0,为空业务代码按照0处理。默认时间填写时应大于00:00:00。</li>"+
            "</ul>"
    });
    $('#DARCIMNotLimitQty').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
        content:'检查检验不限制数量为1,所有医嘱不限制最大数量为9999'
    }));
    $("#tipSpecLocDiag").tooltip({
		content:"专科表单应与治疗申请单、检查检验申请单、手术申请单、抗菌药物申请单等有特殊流程的单据区分应用，请勿使用专科表单适配特殊流程应用场景。该配置不受专科表单科室授权管理。"
	});
    $('.datagrid-header-row .datagrid-cell:not(.datagrid-sort-icon)').overflowtip();
}