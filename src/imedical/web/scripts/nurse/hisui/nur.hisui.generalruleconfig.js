// Nur_IP_QLAssess
// 解决iefind方法报错的问题    
if (!Array.prototype.find) {
    Array.prototype.find = function (callback) {
        return callback && (this.filter(callback) || [])[0];
    };
}

if (typeof Object.assign != 'function') {
    // 解决ie不支持Object.assign的方法
    Object.assign = function(target) {
      'use strict';
      if (target == null) {
        throw new TypeError('Cannot convert undefined or null to object');
      }
   
      target = Object(target);
      for (var index = 1; index < arguments.length; index++) {
        var source = arguments[index];
        if (source != null) {
          for (var key in source) {
            if (Object.prototype.hasOwnProperty.call(source, key)) {
              target[key] = source[key];
            }
          }
        }
      }
      return target;
    };
  }
isIE();
var hospID = ""; // 医院id
var proObj = "";
var wardIDs = ""; // 病区id
var shiftSystem = ""
window.onload = function () {
    var proObj = new Promise(function (resolve, reject) {
        // 本页面没有多院区的概念

        // var hospComp = GenHospComp("Nur_IP_QLAssess");
        // if (hospComp.getValue()) {
        //     resolve(hospComp.getValue());
        // } else {
        //     reject("医院数据加载失败！");
        // }
        $cm({
            ClassName:"Nur.SHIFT.Service.ShiftSetting",
            MethodName:"getShiftSign"
        },function(res){
            res.init=2
            resolve(res)
        })

    });
    proObj.then(
        function (res) {
	        console.log(res)
            // 初始化数据
            InitPanel(res)
        },
        function (err) {
            alert(err);
        }
    );
};

function isIE() { //ie?
    if (!!window.ActiveXObject || "ActiveXObject" in window) {
        var script = document.createElement("script");
        script.type = "text/javascript";
        if (development) {
            script.src = "http://127.0.0.1/imedical/web/scripts/nurse/hisui/bundle.js"; // 本地跑服务
        } else {
            script.src = "../scripts/nurse/hisui/bundle.js"; // 本地跑服务
        }
        // script.src = "http://127.0.0.1/imedical/web/scripts/nurse/hisui/bundle.js"; // 本地跑服务
        document.getElementsByTagName('head')[0].appendChild(script);
    }
}


// 查询数据
$("#search").click(function () {
    search();
});
function search() {
    console.log("查询");
    enableMultTemplates("2^4", false)
}
// 保存数据
$("#save").click(function(){
    Save()
})
function Save(){
   var res= getSignRules()
   console.log(res);
   if(res){
        $cm({
            ClassName:"Nur.SHIFT.Service.ShiftSetting",
            MethodName:"saveShiftSign",
            sign:res.selected_in_val,
            signPatien:res.selected_out_val,
            signCA:res.selected_ca_val
        },function(res){
            if(res.status==-1){
                $.messager.popover({msg: '数据保存失败！',type:'error'});
            }else{
                $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            }
        })
   }
//    console.log(res)

}
function InitScrien() {
    window.onresize = function () {
        // $('#tableOne').datagrid("resize"); // easyui 调用方法的风格
        $HUI.datagrid("#dg").resize();
        $HUI.panel("#accPanel").resize(); // hisui 调用方法的风格
    };
}

function InitPanel(res) {
   $HUI.panel("#accPanel",{
        iconCls:'icon-paper',
        headerCls:'panel-header-gray',
        title:"通用规则配置",
        fit:true
    });
    InitScrien();
    setSignRules(res);
    getLocData()
    getLocLinkWard()
}

// 表格编辑
var editIndex=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};
function InitTable(){
    
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getLocLinkWard"
    },function(res){
        $HUI.datagrid("#dg",{
            columns:[
                [
                    {
                        field: "loc",
                        title: "选择科室",
                        width: 200,
                        formatter: function (value) {
                            var targetObj = shiftSystem.find(function (item) {
                                return item.rowId == value;
                            });
                            if (targetObj) {
                                return targetObj.desc;
                            } else {
                                return value;
                            }
                        },
                        editor: {
                            type: "combobox",
                            options: {
                                valueField: "rowId",
                                textField: "desc",
                                data: shiftSystem,
                                panelHeight: "240",
                                required: true,
                                blurValidValue: true,
                                onSelect:function(newVal){
                                    // 这里触发根据科室id找到关联的病区
                                    getWardData(newVal.rowId)
                                }
                            },
                        },
                    },
                    {
                        field:"mergeWard",
                        title:"合并病区",
                        width:600,
                        formatter: function (value) {
                            try{
                                if(value=="false"){
                                    return ""
                                }else{
                                    var strArr=[]
                                    value.forEach(function(item){
                                        strArr.push(item.wardDesc)
                                    })
                                    return strArr.join(",")
                                }
                            }catch(err){
                                return value
                            }
                        },
                        editor: {
                            type: "text",
                            options: {
                                required: false                           
                            }
                        }
                    },
                    {
                        field:"option",
                        title:"操作",
                        width:80,
                        formatter:function(value,record){
                            return '<span class="icon icon-cancel" style="cursor:pointer;" onclick=del('+record.rowid+') style="width:30px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
                        }
                    }
                ]
            ],
            data:res,
            fitColumns: true,
            rownumbers:true,
            onDblClickRow: onClickRow,
            toolbar:[{
                iconCls: "icon-add",
                text: "新增",
                handler: function () {
                    if(editIndex==0){
                        $.messager.popover({msg: '有未保存的行数据！',type:'alert'});
                        return;
                    }
                    var reIndex = 0;
                    var rows=$("#dg").datagrid("getRows");
                    $("#dg").datagrid("insertRow", {
                        index: reIndex, // 索引从0开始
                        row: {
	                        rowid:rows.length+1,
                            loc:"",
                            mergeWard:"",
                            option:"del"
                        },
                    });
                    editIndex = reIndex;
                    $("#dg").datagrid("beginEdit", reIndex);
                    var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'mergeWard'});
					$(ed.target).attr("disabled",true);
                },
            },
            {
                iconCls: "icon-save",
                text: "保存",
                handler: function () {
                    endEditing()
                    // $("#dg").datagrid("options").data[0].mergeWard="Sondlskjf"
                    // $("#dg").datagrid("refreshRow",0)
                    // console.log($("#dg").datagrid("options").data)
                    // ;
                },
            },]
        })
    })
}
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#dg').datagrid('validateRow', editIndex)){
			//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
			var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'loc'});
			var feetypename = $(ed.target).combobox('getText');
			$('#dg').datagrid('getRows')[editIndex]['loc'] = feetypename;
			$('#dg').datagrid('endEdit', editIndex);
			modifyAfterRow = $('#dg').datagrid('getRows')[editIndex];
			var aStr = JSON.stringify(modifyAfterRow);
			var bStr = JSON.stringify(modifyBeforeRow);
			if(aStr!=bStr){
                // console.log(modifyAfterRow,wardIDs,"song");
                // 保存数据
                saveLocLinkWard(modifyAfterRow)
			}
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function onClickRow(index,data){
	if (editIndex!=index) {
		if (endEditing()){
			$('#dg').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#dg').datagrid('getRows')[editIndex]);
			var mergeWard=[];
			var mergeWardStr="";
			if(data.mergeWard!="false" && data.mergeWard.length>0){
				data.mergeWard.forEach(function(value,index){
					mergeWard.push(value.wardDesc);
				})	
				mergeWardStr=mergeWard.join(",");
			}							
			var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'mergeWard'});
			$(ed.target).val(mergeWardStr).attr("disabled",true);
		} else {
			$('#dg').datagrid('selectRow', editIndex);
		}
	}
}
function del(rowid){
    $.messager.confirm("删除", "确定要删除这条记录吗?", function (r) {
        if (r) {
            delLocLinkWard(rowid);
            editIndex=undefined;
        } 
    });
}
function delLocLinkWard(rowid){
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"delLocLinkWard",
        rowid:rowid
    },function(res){
        if(res.status==-1){
            // $.messager.popover({msg: '数据删除失败！',type:'error'});
            getLocLinkWard()
        }else{
            $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
            getLocLinkWard()
        }
    })
}
function getSignRules(){
    // 获取签名规则选择的数据
    var sign_status=$HUI.radio("input[name='in_sign']").isValid()
    var signPatient_status=$HUI.radio("input[name='out_sign']").isValid()
    var signCA_status=$HUI.radio("input[name='ca_sign']").isValid()
    if(sign_status && signPatient_status && signCA_status){
        var checkedin_sign = $("input[name='in_sign']:checked");
        var checkedout_sign = $("input[name='out_sign']:checked");
        var checkedca_sign = $("input[name='ca_sign']:checked");
        var obj={}
        obj.selected_in_val=checkedin_sign.val(); // 交班签名
        obj.selected_out_val=checkedout_sign.val(); // 接班签名
        obj.selected_ca_val=checkedca_sign.val();  // CA签名
        return obj
    }else{
        $.messager.popover({msg: '签名规则为必选项',type:'alert'});
        return false
    }
}
function setSignRules(res){
    $("input[name='in_sign']").radio({
        onChecked:function(){
            if(res.init>0){
                console.log(res.init)
                // 初始化的时候不调用保存
                res.init-=1
                return;
            }
            Save()
        }
    })
    $("input[name='out_sign']").radio({
        onChecked:function(){
            if(res.init>0){
                // 初始化的时候不调用保存
                res.init-=1
                return;
            }
            Save()
        }
    })    
    $("input[name='ca_sign']").radio({
        onChecked:function(){
            if(res.init>0){
                // 初始化的时候不调用保存
                res.init-=1
                return;
            }
            Save()
        }
    })
    if(res.sign && res.signPatien && res.signCA){
        var sign_num=res.sign;
        var signPatient_num=res.signPatien
        var signCA_num=res.signCA;
        $HUI.radio("#sign_"+sign_num).check();
        $HUI.radio("#signPatient_"+signPatient_num).check();
        $HUI.radio("#signCA_"+signCA_num).check();
    }
}
function getShiftExtends(){
    // 获取 交班内容继承规则（已废弃）
    var checkObj=$("input[name='extends']:checked");
    var obj={}
    obj.selected_extends=checkObj.val()
    return obj
}
function getRevoke(){
    // 获取 撤销签名权限规则（已废弃）
    var checkObj=$("input[name='sign_rule']:checked");
    var obj={}
    obj.selected_revoke=checkObj.val()
    return obj
}
function getLocData(){
    // 获取科室数据
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getLocData",
        descInput:""
    },function(res){
        shiftSystem=res
        // 初始化表格
        InitTable();
    })
}
function getWardData(locId){
    if(!locId){
        return;
    }
    
//    // 过滤筛选
//    var LocalData=$("#dg").datagrid("getData").rows
//    var res=LocalData.find(function(item){
//        return item.loc==locId
//    })
//    if(res){
//        $.messager.popover({msg: '该条数据以存在，不可重复添加!',type:'alert'});
//        var ed = $('#dg').datagrid('getEditor', {index:0,field:'loc'});
//        $(ed.target).combobox('unselect', locId);
//        return;
//    }
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getWardData",
        locId:locId  
    },function(res){
        var ed = $('#dg').datagrid('getEditor', {index:0,field:'mergeWard'});
        if(res.length>0){
            var arr=[]
            var wardId=[]
            res.forEach(function(item){
                arr.push(item.desc)
                wardId.push(item.rowId)
            })
            var str=arr.join(",")
            wardIDs=wardId.join("^")
            $(ed.target).val(str)
            $(ed.target).attr("disabled","true")
        }else{
            wardIDs=""
            $(ed.target).val("")
            $(ed.target).attr("disabled","true")
        }
    })
}
function saveLocLinkWard(record){
    var locId=record.loc
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"saveLocLinkWard",
        rowid:record.rowid,
        locid:locId,
        wardStr:wardIDs
    },function(res){
        if(res.status==-1){
            $.messager.popover({msg: '数据保存失败！',type:'error'});
            getLocLinkWard()
        }else{
            $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
            getLocLinkWard()
        }
    })

}
function getLocLinkWard(){
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getLocLinkWard"
    },function(res){
        // console.log(res,'ceshi')
        $('#dg').datagrid('loadData',res)
    })
}
