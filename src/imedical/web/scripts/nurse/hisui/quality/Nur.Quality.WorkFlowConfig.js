/**
 * @description: 质控工作流配置界面
 * @author: ouzilin
 * @date: 2020-05-29 10:43:13
*/
var GV = {
	tableName: "Nur_IP_Quality.WorkFlowConfig"
}
var editRow,dataArray;
$(function() {
	$.extend($.fn.datagrid.defaults.editors, {
    	colorpicker: {
        	init: function (container, options) {
            	var input = $('<input>').appendTo(container);
           		input.colpick({
					layout:'hex',
					submit:0,
					colorScheme:'dark',
					onChange:function(hsb,hex,rgb,el,bySetColor) {
						$(el).css('backgroundColor','#'+hex);
						if(!bySetColor) $(el).val('#'+hex);
					}
				}).keyup(function(){
					$(this).colpickSetColor(this.value);
				});
            	return input;
        	},
        	getValue: function (target) {
            	return $(target).val();
        	},
        	setValue: function (target, value) {
	        	if (value!=undefined)
	        	{
            		$(target).val(value);
            		$(target).css('backgroundColor', value);
            		$(target).colpickSetColor(value);
	        	}
            	
        	},
        	resize: function (target, width) {
            	var input = $(target);
            	if ($.boxModel == true) {
                	input.width(width - (input.outerWidth() - input.width()));
            	} else {
                	input.width(width);
            	}
        	}
    	}
	});
    initUI()
})

function initUI()
{
	if (IsManyHosps == 1) //多院区业务
    {
        //初始化医院
        //var hospComp = GenUserHospComp();
        var sessionStr = [session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']]
        var hospComp = GenHospComp(GV.tableName, sessionStr.join("^"))
	    hospComp.jdata.options.onSelect = function(e,t){
		
			initTitleConfig()
    		initLevelConfigTable()  //初始化工作量层级设置
    		initPermissionConfigTable()  //初始化权限设置

        }
        hospComp.jdata.options.onLoadSuccess= function(data){
		    
	    }
    }
	
    initTitleConfig()
    initLevelConfigTable()  //初始化工作量层级设置
    initPermissionConfigTable()  //初始化权限设置

}

function initTitleConfig()
{
    runClassMethod("Nur.Quality.Service.WorkflowConfig","getConfig",{ parameter1: getHospId() },function(data){
        var dataList = data
        $HUI.checkbox('#appraiseConfig').setValue(dataList[0])
        $HUI.checkbox('#noteConfig').setValue(dataList[1])
        $HUI.checkbox('#tempAndOrderConfig').setValue(dataList[2])
        $HUI.checkbox('#emrAuditConfig').setValue(dataList[3])
    })
    $("#configSaveBtn").on("click",function(){
        var data=[]
        data.push($HUI.checkbox('#appraiseConfig').getValue())
        data.push($HUI.checkbox('#noteConfig').getValue())
        data.push($HUI.checkbox('#tempAndOrderConfig').getValue())
        data.push($HUI.checkbox('#emrAuditConfig').getValue())
       runClassMethod("Nur.Quality.Service.WorkflowConfig","setConfig",
       {
            parameter1: data.join("^"),
            parameter2: getHospId()
       },function(data){
            if (data=="0")
            {
                $.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
            }
       })
    })
 
  
}

function initLevelConfigTable()
{
    var flagArray = [
        {Id : "Y", Desc: "Y"},
        {Id : "N", Desc: "N"},
    ]


    $('#levelConfigTable').datagrid({
        url: $URL,
        queryParams:{
             ClassName: 'Nur.Quality.Service.WorkflowConfig',
             QueryName: 'getLevelConfigRec',
             HospId: getHospId()
        },
        method: 'post',
        loadMsg: '数据装载中......',
        striped: true,
        fitColumns: true,
        autoRowHeight: true,
        singleSelect: true,
        showHeader: true,
        nowrap: false,
        columns: [[
            {field:'levelCode',title:'代码',width:80},
            {field:'levelDesc',title:'描述',width:80,editor:{type:'validatebox',options:{required:true}}},
            {field:'levelCondition',title:'条件',width:150,editor:{type:'text',options:{}}},
            { field:'levelDynamicFlag',title:'是否变动',width:50,        
                editor:{
                    type:'combobox',
                    options:{
                        valueField : 'Id',
                        textField :'Desc',
                        data : flagArray
                    }
                }
            },
            {field:'levelLimitFlag',title:'是否限制病历操作',hidden:true,width:100,
                editor:{
                    type:'combobox',
                    options:{
                        valueField : 'Id',
                        textField :'Desc',
                        data : flagArray
                    }
                }
            },
            {field:'levelColor',title:'颜色',width:70,editor:{type:'colorpicker',options:{}},
           	formatter:function(value,row,index){
                   var div='<div style="background-color:' + value + '">'+value+'</div>'
                   return div
               }
            },
            {
                field:'levelPriority',
                title:'优先级',
                width:50,
                formatter:function(value,row,index){
                    var down = '<span style="margin-left:5px;cursor:pointer" class="icon icon-down" onclick=upOrDownBtn("'+row.levelID+'","'+value+'","down","'+index+'")>&nbsp;&nbsp;&nbsp;&nbsp;</span> ';
                    var up = '<span style="cursor:pointer" class="icon icon-up" onclick=upOrDownBtn("'+row.levelID+'","'+value+'","up","'+index+'")>&nbsp;&nbsp;&nbsp;&nbsp;</span>';
                    return down + up;
                }
            },
            {field:'levelID',title:'ID',width:100,hidden:true},
        ]],
        toolbar: [{
                iconCls: 'icon-add',
                text: '新增',
                handler: function() {
                    clickBtnEvent('levelAdd')
                }
            },{
                iconCls: 'icon-save',
                text: '保存',
                handler: function() {
                    clickBtnEvent('levelSave')
                }
            }, {
                iconCls: 'icon-cancel',
                text: '删除',
                handler: function() {
                    clickBtnEvent('levelDelete')
                }
            }
        ],
        onDblClickRow: function(rowIndex, rowData){
            $('#levelConfigTable').datagrid("rejectChanges");
            $('#levelConfigTable').datagrid("unselectAll");
            $('#levelConfigTable').datagrid("beginEdit", rowIndex);
            editRow=rowIndex;
        },
        onClickRow: function(rowIndex, rowData){
            $('#permissionConfigTable').datagrid('load')
        }
    })
}
function initPermissionConfigTable()
{

    function filter(q, row) {
        var opts = $(this).combobox('options');
        var text = row[opts.textField];
        var pyjp = getPinyin(text).toLowerCase();
        if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
            return true;
        }
        return false;
    }

    getType(function(data){
        var typeArray = data[0]
        dataArray = {
            Group : data[1],
            Loc : data[2],
            User : data[3]
        }
        $('#permissionConfigTable').datagrid({
            // url: $URL,
            // queryParams:{
            //      ClassName: 'Nur.Quality.Service.WorkflowConfig',
            //      QueryName: 'getPermissionConfigRec',
            //      LevelID: '',

            // },
            url: LINK_CSP + '?className=Nur.Quality.Service.WorkflowConfig&methodName=getPermissionConfigRec',
            method: 'post',
            loadMsg: '数据装载中......',
            striped: true,
            fitColumns: true,
            autoRowHeight: true,
            singleSelect: true,
            showHeader: true,
            nowrap: false,
            onBeforeLoad: function(param){
                var row = $('#levelConfigTable').datagrid("getSelected"); 
                param.parameter1 = (row == null ? '' : row.levelID);
            },
            columns:[[
                {
                    field:'permissionType',
                    title:'类型',
                    width:20,
                    formatter:function(value){
                        for(var index in typeArray)
                        {
                            if (typeArray[index].Id == value){
                                return typeArray[index].Desc
                            }
                        }
                        return value
                    },
                    editor:{
                        type:'combobox',
                        options:{
                            valueField : 'Id',
                            textField :'Desc',
                            data : typeArray,
                            required : true,
                            value : "1",
                            onSelect:function(newValue, oldValue){
                                var editor=$("#permissionConfigTable").datagrid("getEditor",{index:editRow,field:'permissionPointTo'})
                                $(editor.target).combobox('loadData',dataArray[newValue.Id])
                                $(editor.target).combobox('clear')
                            }
                        }
                    }
                },
                {
                    field:'permissionPointTo',
                    title:'指向',
                    width:100,
                    resizable:true,
                    formatter:function(value,row,index){
                        var targetArr =  dataArray[row.permissionType]
                        if(value==undefined){
                            return value;
                        }else{
                            var tmpVal=value.toString().split(",")
                            var resault=[];
                            for(var i=0;i<targetArr.length;i++){
                                tmpVal.forEach(function(item){
                                    if(parseInt(targetArr[i].Id)==parseInt(item)){
                                        resault.push(targetArr[i].Desc)
                                    }
                                })
                            }
                            return resault.join(",");
                        }
                    },
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'Id',
                            textField:'Desc',
                            data:[],
                            required:true,
                            multiple:true,
                            filter: filter
                        }
                    }
                },
                {field:'permissionID',title:'ID',width:100,hidden:true},
            ]],
            toolbar: [{
                    iconCls: 'icon-add',
                    text: '新增',
                    handler: function() {
                        clickBtnEvent('permissionAdd')
                    }
                },{
                    iconCls: 'icon-save',
                    text: '保存',
                    handler: function() {
                        clickBtnEvent('permissionSave')
                    }
                }, {
                    iconCls: 'icon-cancel',
                    text: '删除',
                    handler: function() {
                        clickBtnEvent('permissionDelete')
                    }
                }
            ],
            onDblClickRow: function(rowIndex, rowData){
                $('#permissionConfigTable').datagrid("rejectChanges");
                $('#permissionConfigTable').datagrid("unselectAll");
                $('#permissionConfigTable').datagrid("beginEdit", rowIndex);
                var editor=$("#permissionConfigTable").datagrid("getEditor",{index:rowIndex,field:'permissionPointTo'})
                $(editor.target).combobox('loadData',dataArray[rowData.permissionType])
                editRow=rowIndex;
            },
            onLoadSuccess: function(data){
               data = {}
            }
        })
    
    })
}

function clickBtnEvent(id)
{
    switch (id) {
        case 'levelAdd':
            $('#levelConfigTable').datagrid("rejectChanges");
            $('#levelConfigTable').datagrid("unselectAll");
            $('#levelConfigTable').datagrid("insertRow", {
                index: 0,
                row: {}
            });
            $('#levelConfigTable').datagrid("beginEdit", 0);
            editRow=0;
            break;
        case 'levelSave':
            levelConfigHandler('save')
            break;
        case 'levelDelete':
            var row = $('#levelConfigTable').datagrid("getSelected");
            if (!row)
            {
                $.messager.popover({msg: '请选择一条的记录',type:'error',timeout: 1000});
                return
            }
            delConfirm(function(){
                levelConfigHandler('delete')
            })
            break;
        case 'permissionAdd':
        	var levelRow = $('#levelConfigTable').datagrid("getSelected");
         	if (levelRow == undefined){
        		$.messager.popover({msg: '请选择左测一条的记录',type:'error',timeout: 1000});
        		return
    		}
            $('#permissionConfigTable').datagrid("rejectChanges");
            $('#permissionConfigTable').datagrid("unselectAll");
            $('#permissionConfigTable').datagrid("insertRow", {
                index: 0,
                row: {}
            });
            $('#permissionConfigTable').datagrid("beginEdit", 0);
            editRow=0;
            break;
        case 'permissionSave':
            permissionConfigHandler('save')
            break;
        case 'permissionDelete':
            var row = $('#permissionConfigTable').datagrid("getSelected");
            if (!row)
            {
                $.messager.popover({msg: '请选择一条的记录',type:'error',timeout: 1000});
                return
            }
            delConfirm(function(){
                permissionConfigHandler('delete')
            })
            break;
      }
}

function permissionConfigHandler(action)
{
    if (action == "save")
    {
        var editors = $('#permissionConfigTable').datagrid('getEditors', editRow);
        if (editors.length==0){
            $.messager.alert("提示","没有正在编辑的行!");
            return false;
        } 
        var row = $('#permissionConfigTable').datagrid("selectRow",editRow).datagrid("getSelected"); 
    }else{
        var row = $('#permissionConfigTable').datagrid("getSelected"); 
    }
    if (row == undefined){
        $.messager.popover({msg: '请选择一条的记录',type:'error',timeout: 1000});
        return
    }
    var levelRow = $('#levelConfigTable').datagrid("getSelected");
    var levelID = levelRow.levelID

    $('#permissionConfigTable').datagrid('endEdit', editRow);

    if ((row.permissionType == undefined) || (row.permissionPointTo == undefined))
    {
	    $.messager.popover({msg: '必填项未填写',type:'error',timeout: 1000});
        return
    }

    var permissionJsonData={
        levelID: levelID,
        permissionType: row.permissionType,
        permissionPointTo: row.permissionPointTo,
    }

    runClassMethod("Nur.Quality.Service.WorkflowConfig","permissionHandler",
    {
        parameter1: (row.permissionID==undefined ? '' : row.permissionID) ,
        parameter2: JSON.stringify(permissionJsonData),
        parameter3: action,
    },function(data){
        if (data == 0){
            $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
            $('#permissionConfigTable').datagrid("load")
        }else{
            $.messager.popover({msg: data.responseText,type:'error',timeout: 1000});
            $('#permissionConfigTable').datagrid("load")
        }
    })
}

function levelConfigHandler(action)
{
    if (action == "save")
    {
	    debugger
        var editors = $('#levelConfigTable').datagrid('getEditors', editRow);
        if (editors.length==0){
            $.messager.alert("提示","没有正在编辑的行!");
            return false;
        } 
        var row = $('#levelConfigTable').datagrid("selectRow",editRow).datagrid("getSelected"); 
    }else{
        var row = $('#levelConfigTable').datagrid("getSelected"); 
    }
    if (row == undefined){
        $.messager.popover({msg: '请选择一条的记录',type:'error',timeout: 1000});
        return
    }
    $('#levelConfigTable').datagrid('endEdit', editRow);

    if (row.levelDesc == undefined)
    {
	    $.messager.popover({msg: '必填项未填写',type:'error',timeout: 1000});
        return
    }
	debugger
    var levelJsonData={
        levelDesc: row.levelDesc,
        levelPriority: row.levelPriority,
        levelCondition: row.levelCondition,
        levelDynamicFlag: row.levelDynamicFlag,
        levelLimitFlag: row.levelLimitFlag,
        levelColor: row.levelColor,
    }

    runClassMethod("Nur.Quality.Service.WorkflowConfig","levelHandler",
    {
        parameter1: (row.levelID==undefined ? '' : row.levelID) ,
        parameter2: JSON.stringify(levelJsonData),
        parameter3: action,
        parameter4: getHospId()
    },function(data){
        if (data == 0){
            $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
            $('#levelConfigTable').datagrid("load")
            $('#permissionConfigTable').datagrid("load")
        }else{
            $.messager.popover({msg: data.responseText,type:'error',timeout: 1000});
        }
    })
}

function upOrDownBtn(levelID, priority, type, index)
{
	
	if ((index==0)&&(type=="up"))
    {
        $.messager.popover({msg: '顶行无法上移!',type:'error',timeout: 1000});
      	return
    }
    
    var rows=$('#levelConfigTable').datagrid('getRows');
    var rowlength=rows.length
    
   if ((index==rowlength-1)&&(type=="down"))
   {
   		$.messager.popover({msg: '底行无法下移!',type:'error',timeout: 1000});
       	return
   }
    
    runClassMethod("Nur.Quality.Service.WorkflowConfig", "changePriority",
    {
        parameter1: levelID,
        parameter2: priority,
        parameter3: type,
        parameter4: getHospId()
    },function(data){
        if (data == 0){
            $('#levelConfigTable').datagrid("load")
        }else{
            $.messager.popover({msg: data,type:'error',timeout: 1000});
        }
    })

}

function getType(callback)
{
	
	var typeAry = $cm({
		ClassName:"Nur.Quality.Service.WorkflowConfig",
		MethodName:"getType",
	},false);
	var groupAry = $cm({
		ClassName:"Nur.Quality.Service.WorkflowConfig",
		MethodName:"getTypeInfo",
		Type: "Group",
		HospId: getHospId(), 
		tableName: GV.tableName
	},false);
	var locAry = $cm({
		ClassName:"Nur.Quality.Service.WorkflowConfig",
		MethodName:"getTypeInfo",
		Type: "Loc",
		HospId: getHospId(), 
		tableName: GV.tableName
	},false);
	var userAry = $cm({
		ClassName:"Nur.Quality.Service.WorkflowConfig",
		MethodName:"getTypeInfo",
		Type: "User",
		HospId: getHospId(), 
		tableName: GV.tableName
	},false);
	callback([typeAry,groupAry,locAry,userAry])
	/*
    Promise.all(
        [
            queryData("Nur.Quality.Service.WorkflowConfig","getType",{}),
            queryData("Nur.Quality.Service.WorkflowConfig","getTypeInfo",{ parameter1: "Group" }),
            queryData("Nur.Quality.Service.WorkflowConfig","getTypeInfo",{ parameter1: "Loc" }),
            queryData("Nur.Quality.Service.WorkflowConfig","getTypeInfo",{ parameter1: "User" })
        ]
    ).then(function(result){
        callback(result)
    })
	*/
}

function queryData(ClassName,MethodName,Parr){
    var promise = new Promise(function(resolve, reject){
        runClassMethod(ClassName,MethodName,Parr,function(data){
                resolve(data)
        })
    })
    return promise
}


function getHospId()
{
	return (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
}