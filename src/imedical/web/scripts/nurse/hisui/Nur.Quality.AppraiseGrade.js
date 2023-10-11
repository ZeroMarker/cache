
var GV = {
	tableName: "Nur_IP_Quality.AppraiseGrade"
}
var editIndex = undefined
$(function() {
    initUI()
})

function initUI(){
	
	if (IsManyHosps == 1) //多院区业务
    {
        //初始化医院
        //var hospComp = GenUserHospComp();
        var sessionStr = [session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']]
        var hospComp = GenHospComp(GV.tableName, sessionStr.join("^"))
	    hospComp.jdata.options.onSelect = function(e,t){
			
			 initAppraiseGradeConfig() //初始化病历等级维护
    		initGradeConditionConfig()  //初始化登记条件维护


        }
        hospComp.jdata.options.onLoadSuccess= function(data){
		    
	    }
    }

    initAppraiseGradeConfig() //初始化病历等级维护
    initGradeConditionConfig()  //初始化登记条件维护

}
function initAppraiseGradeConfig(){
	
	
	 $('#inputAppraiseModel').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            var queryParams = $('#appraiseGradeConfigTable').datagrid('options').queryParams
        	queryParams.inputTitleDesc = $('#inputAppraiseModel').val()
        	$('#appraiseGradeConfigTable').datagrid('options').queryParams = queryParams;
			$('#appraiseGradeConfigTable').datagrid("load")
        }
    });
	
	$("#searchBtn").on("click",function(){
		var queryParams = $('#appraiseGradeConfigTable').datagrid('options').queryParams
        queryParams.inputTitleDesc = $('#inputAppraiseModel').val()
        $('#appraiseGradeConfigTable').datagrid('options').queryParams = queryParams;
		$('#appraiseGradeConfigTable').datagrid("load")
	})
	
	$("#searchBtn").on("click",function(){
		var queryParams = $('#appraiseGradeConfigTable').datagrid('options').queryParams
        queryParams.inputTitleDesc = $('#inputAppraiseModel').val()
        $('#appraiseGradeConfigTable').datagrid('options').queryParams = queryParams;
		$('#appraiseGradeConfigTable').datagrid("load")
	})
	
	
    $('#appraiseGradeConfigTable').datagrid({
        url: $URL,
        queryParams:{
             ClassName: 'Nur.Quality.Service.AppraiseEmrConfig',
             QueryName: 'getAppraiseGradeRec',
             inputTitleDesc: $('#inputAppraiseModel').val(),
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
            {field:'appGradeTitleID',hidden:true},
            { field: 'appGradeTitle', title: '等级名称', width: 180, editor:{
                type:'combobox',
                options:{
                    url: LINK_CSP + '?className=Nur.Quality.Service.AppraiseEmrConfig&methodName=getAppraiseEmrTitle',
                    valueField: 'ID',
                    textField: 'Desc',
                    required:true,
                    loadFilter:function(data){
                        return data;
                    },
                    onSelect:function(rec){
                        var rows=$('#appraiseGradeConfigTable').datagrid("selectRow",editIndex).datagrid("getSelected");
                        rows.appGradeTitleID=rec.ID;
                        rows.configID=rec.ID;
                    },
                    onChange:function(newValue, oldValue){
                        if (newValue==""){
                            var rows=$('#appraiseGradeConfigTable').datagrid("selectRow",editIndex).datagrid("getSelected");
                            rows.appGradeTitleID="";
                            rows.configID="";
                        }
                    },
                    onHidePanel:function(){
                        var rows=$('#appraiseGradeConfigTable').datagrid("selectRow",editIndex).datagrid("getSelected");
                        if (!$.isNumeric($(this).combobox('getValue'))) return;
                        rows.appGradeTitleID=$(this).combobox('getValue');
                    }
                  }
            }, formatter:function(value, record){
                return record.appGradeTitle;
            }},
            { field: 'appGradeType', title: '病历类型', width: 70, hidden:true, editor:{
                type:'combobox',
                options:{
                    valueField: 'ID',
                    textField: 'Desc',
                    //required:true,
                    data:[{"ID":"Y","Desc":"终末病历"},{"ID":"N","Desc":"运行病历"}],
                    onSelect:function(rec){
                        var rows=$('#appraiseGradeConfigTable').datagrid("selectRow",editIndex).datagrid("getSelected");
                        rows.appGradeType=rec.ID;
                    },
                    onChange:function(newValue, oldValue){
                        if (newValue==""){
                            var rows=$('#appraiseGradeConfigTable').datagrid("selectRow",editIndex).datagrid("getSelected");
                            rows.appGradeType="";
                        }
                    }
                  },
            }, formatter:function(value, record){
                if (value=="Y"){
                    return "终末病历" 
                }else if(value=="N"){
                    return "运行病历"
                }else{
                    return ""
                }
            }},
            { field: 'configID', title: 'ID', width: 200, hidden:true },
        ]],
        toolbar: [{
            iconCls: 'icon-add',
            text: '新增',
            handler: function() {
                clickBtnEvent('add')
            }
            }, {
                iconCls: 'icon-cancel',
                text: '删除',
                handler: function() {
	            	clickBtnEvent('delete')
                }
            }, {
                iconCls: 'icon-save',
                text: '保存',
                handler: function() {
                    clickBtnEvent('save')
                }
            }
        ],
        onClickRow: function(rowIndex, rowData){
            var rows = $('#appraiseGradeConfigTable').datagrid("getRows");
            var row = rows[rowIndex]
			onClickGradeRec(row)

        }
    })
}

function initGradeConditionConfig()
{
    $('#addGradeConditionBtn').on('click',function(){
	    var rows = $('#appraiseGradeConfigTable').datagrid("getSelected");
        if (rows==null)
        {
	    	$.messager.popover({msg: '请选择左侧一条记录',type:'error',timeout: 1000});
	        return
	   	}
        addGradeConditionRec({
            title:'',
            condition: '',
            startScore: '',
            score: '',
            color: '#000000'
        });
        initColorSlect();
    })

    $('#saveGradeConditionBtn').on('click',function(){
        var conditionData=[]
        var ifCanSaveFlag=true
        $('.gradeConditionConfigTable tr').each(function(){
            var single = {}
            single.title = $(this).find(".title").val()
            if (single.title.trim()=="") { ifCanSaveFlag=false }
            single.condition = $(this).find(".condition").val()
            if (single.condition.trim()=="") { ifCanSaveFlag=false }
            if (single.condition == "区间")
            {
	            if (($(this).find(".startScore").val().trim()=="")||($(this).find(".score").val().trim()=="")){ ifCanSaveFlag=false  }
                single.condition = ("score>=" + $(this).find(".startScore").val() + "&&" + "score<=" + $(this).find(".score").val()  )
            }else{
	            if ($(this).find(".score").val().trim()==""){ ifCanSaveFlag=false  }
                single.condition = ("score" + single.condition + $(this).find(".score").val() )
            }
            single.color =  rgb2hex($(this).find(".color-box").css('background-color'))
           conditionData.push(single)
        })
        if (!ifCanSaveFlag)
        {	
	        $.messager.popover({msg: '等级条件维护有未填写项!',type:'error',timeout: 1000});
            return
	    }
        var row=$('#appraiseGradeConfigTable').datagrid("getSelected");
        if (row == undefined){
            $.messager.popover({msg: '请选择一条左侧的记录',type:'error',timeout: 1000});
            return
        }
        runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","gradeConditionHandler",
        {
            parameter1: row.configID,
            parameter2: JSON.stringify(conditionData),
            parameter3: getHospId()
        },function(data){
            if (data == 0){
                $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
                onClickGradeRec(row)
            }
        })
    })
    
    $('.gradeConditionConfigTable').html("")
}

function clickBtnEvent(id){
    switch (id) {
        case 'add':
            $('#appraiseGradeConfigTable').datagrid("rejectChanges");
            $('#appraiseGradeConfigTable').datagrid("unselectAll");
            $('#appraiseGradeConfigTable').datagrid("insertRow", {
                    index: 0,
                    row: {}
            });
            editIndex=0
            $('#appraiseGradeConfigTable').datagrid("beginEdit", 0);
            break;
        case 'delete':
            var rows = $('#appraiseGradeConfigTable').datagrid("getSelected");
            if (rows==null)
            {
	            $.messager.popover({msg: '请选择一条记录',type:'error',timeout: 1000});
	            return
	        }
	        delConfirm(function(){
                runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","appraiseGradeHandler",{
                    parameter1: rows.configID,
                    parameter2: rows.appGradeTitleID,
                    parameter3: rows.appGradeType,
                    parameter4: "delete",
                    parameter5: getHospId()
                },function(data){
                    if (data == 0){
                        $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
                        editIndex == undefined
                        $('.gradeConditionConfigTable').html("")
                        $('#appraiseGradeConfigTable').datagrid("reload")
                    }
                })
            })
            break;
        case 'save':
            if (editIndex == undefined){
		        $.messager.popover({msg:"没有需要保存的数据",type:'error',timeout:1000});  
		        return false
            }
            var rows = $('#appraiseGradeConfigTable').datagrid("selectRow",editIndex).datagrid("getSelected");
	        //if (!((rows.configID)&&(rows.appGradeType)))
	        if (!(rows.configID))
	     	{
	            $.messager.popover({msg: '有必填项未填写',type:'error',timeout: 1000});
	            return
	        }
            runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","appraiseGradeHandler",{
                parameter1: rows.configID,
                parameter2: rows.appGradeTitleID,
                parameter3: "Y",
                parameter4: "add",
                parameter5: getHospId()
            },function(data){
                if (data == 0){
                    $.messager.popover({msg: '操作成功',type:'success',timeout: 1000});
                    editIndex == undefined
                    $('#appraiseGradeConfigTable').datagrid("reload")
                }else(
                	$.messager.popover({msg: data.responseText,type:'error',timeout: 1000})
                )
            })
            break;
      }
}

function endEdit() {
	if(editIndex == undefined) {return true;}//如果为undefined的话，为真，说明可以编辑
	if($('#appraiseGradeConfigTable').datagrid('validateRow',editIndex)) {
		$('#appraiseGradeConfigTable').datagrid('endEdit',editIndex);//当前行编辑事件取消
        editIndex = undefined; 
        return true;//重置编辑行索引对象，返回真，允许编辑
     }
	else {
		return false;
	}//否则，为假，返回假，不允许编辑
}

function addGradeConditionRec(data)
{
    var html = '<tr>' +
                    '<th>条件:<input class="title" value="' + data.title + '" /></<th>' +
                    '<th><select class="condition" onChange="selectChange(this)"><option value=""></option><option '+ (data.condition==">" ? "selected=true":"false") +'    value=">">></option><option '+ (data.condition=="区间" ? "selected=true":"false") +' value="区间">区间</option><option '+ (data.condition=="<=" ? "selected=true":"") +'  value="&lt;=">&lt;=</option></select></th>'  +
                    '<th style="display:' + ((data.condition=="区间") ? "":"none") + '"><input class="startScore" value="' + data.startScore + '" /><span>至</span></th>' +
                    '<th><input class="score" value="' + data.score + '" />分</th>' +
                    '<th><span>&nbsp;&nbsp;颜色</span></th>' +
                    '<th><div class="color-box" onmouseover=initColorSlect(this,"' + data.color + '") style="background-color:' + data.color  + '"></div></th>' +
                    '<th><a class="deleteCondition" onclick="deleteGrade(this)" href="javascript:void(0)" class="l-btn l-btn-small l-btn-plain"><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">&nbsp;</span><span class="l-btn-icon icon-cancel">&nbsp;</span></span></a></th>' +
                '</tr>'
    $('.gradeConditionConfigTable').append(html)

}

function deleteGrade(e)
{
	$(e).parent().parent().remove()
}


function onClickGradeRec(row)
{
	runClassMethod("Nur.Quality.Service.AppraiseEmrConfig","getGradeCondition",
    {
    	parameter1: row.configID,
    	parameter2: getHospId()

    },function(data){
        var data = eval(data)
        $('.gradeConditionConfigTable').html("")
        for (var index in data){
            addGradeConditionRec(data[index])
        }
    })
}

function selectChange(e)
{
	var value=$(e).val()
	if (value != "区间")
	{
		$(e).parent().next().css("display","none")
	}else{
		$(e).parent().next().css("display","")
	}
}

function initColorSlect(obj,color){
    if (color == rgb2hex($(obj).css('background-color')))
    {
        $(obj).colpick({
            colorScheme:'dark',
            layout:'rgbhex',
            color:color,
            onSubmit:function(hsb,hex,rgb,el) {
                $(el).css('background-color', '#'+hex);
                $(el).colpickHide();
            }
        }).css('background-color', color);
    }
}
function rgb2hex(rgb) {
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    function hex(x) {
    return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}


function getHospId()
{
	return (IsManyHosps==1 ? $HUI.combogrid('#_HospList').getValue() : "")
}