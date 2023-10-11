// Nur_IP_QLAssess
// ���iefind�������������    
if (!Array.prototype.find) {
    Array.prototype.find = function (callback) {
        return callback && (this.filter(callback) || [])[0];
    };
}

if (typeof Object.assign != 'function') {
    // ���ie��֧��Object.assign�ķ���
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
var hospID = ""; // ҽԺid
var proObj = "";
var wardIDs = ""; // ����id
var shiftSystem = ""
window.onload = function () {
    var proObj = new Promise(function (resolve, reject) {
        // ��ҳ��û�ж�Ժ���ĸ���

        // var hospComp = GenHospComp("Nur_IP_QLAssess");
        // if (hospComp.getValue()) {
        //     resolve(hospComp.getValue());
        // } else {
        //     reject("ҽԺ���ݼ���ʧ�ܣ�");
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
            // ��ʼ������
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
            script.src = "http://127.0.0.1/imedical/web/scripts/nurse/hisui/bundle.js"; // �����ܷ���
        } else {
            script.src = "../scripts/nurse/hisui/bundle.js"; // �����ܷ���
        }
        // script.src = "http://127.0.0.1/imedical/web/scripts/nurse/hisui/bundle.js"; // �����ܷ���
        document.getElementsByTagName('head')[0].appendChild(script);
    }
}


// ��ѯ����
$("#search").click(function () {
    search();
});
function search() {
    console.log("��ѯ");
    enableMultTemplates("2^4", false)
}
// ��������
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
                $.messager.popover({msg: '���ݱ���ʧ�ܣ�',type:'error'});
            }else{
                $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            }
        })
   }
//    console.log(res)

}
function InitScrien() {
    window.onresize = function () {
        // $('#tableOne').datagrid("resize"); // easyui ���÷����ķ��
        $HUI.datagrid("#dg").resize();
        $HUI.panel("#accPanel").resize(); // hisui ���÷����ķ��
    };
}

function InitPanel(res) {
   $HUI.panel("#accPanel",{
        iconCls:'icon-paper',
        headerCls:'panel-header-gray',
        title:"ͨ�ù�������",
        fit:true
    });
    InitScrien();
    setSignRules(res);
    getLocData()
    getLocLinkWard()
}

// ���༭
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
                        title: "ѡ�����",
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
                                    // ���ﴥ�����ݿ���id�ҵ������Ĳ���
                                    getWardData(newVal.rowId)
                                }
                            },
                        },
                    },
                    {
                        field:"mergeWard",
                        title:"�ϲ�����",
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
                        title:"����",
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
                text: "����",
                handler: function () {
                    if(editIndex==0){
                        $.messager.popover({msg: '��δ����������ݣ�',type:'alert'});
                        return;
                    }
                    var reIndex = 0;
                    var rows=$("#dg").datagrid("getRows");
                    $("#dg").datagrid("insertRow", {
                        index: reIndex, // ������0��ʼ
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
                text: "����",
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
			//�б���������ʵ�֣��޸ĺ�ѻ�дfeetypename����Ϊformatter��ʾ����feetypename�ֶ�
			var ed = $('#dg').datagrid('getEditor', {index:editIndex,field:'loc'});
			var feetypename = $(ed.target).combobox('getText');
			$('#dg').datagrid('getRows')[editIndex]['loc'] = feetypename;
			$('#dg').datagrid('endEdit', editIndex);
			modifyAfterRow = $('#dg').datagrid('getRows')[editIndex];
			var aStr = JSON.stringify(modifyAfterRow);
			var bStr = JSON.stringify(modifyBeforeRow);
			if(aStr!=bStr){
                // console.log(modifyAfterRow,wardIDs,"song");
                // ��������
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
    $.messager.confirm("ɾ��", "ȷ��Ҫɾ��������¼��?", function (r) {
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
            // $.messager.popover({msg: '����ɾ��ʧ�ܣ�',type:'error'});
            getLocLinkWard()
        }else{
            $.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
            getLocLinkWard()
        }
    })
}
function getSignRules(){
    // ��ȡǩ������ѡ�������
    var sign_status=$HUI.radio("input[name='in_sign']").isValid()
    var signPatient_status=$HUI.radio("input[name='out_sign']").isValid()
    var signCA_status=$HUI.radio("input[name='ca_sign']").isValid()
    if(sign_status && signPatient_status && signCA_status){
        var checkedin_sign = $("input[name='in_sign']:checked");
        var checkedout_sign = $("input[name='out_sign']:checked");
        var checkedca_sign = $("input[name='ca_sign']:checked");
        var obj={}
        obj.selected_in_val=checkedin_sign.val(); // ����ǩ��
        obj.selected_out_val=checkedout_sign.val(); // �Ӱ�ǩ��
        obj.selected_ca_val=checkedca_sign.val();  // CAǩ��
        return obj
    }else{
        $.messager.popover({msg: 'ǩ������Ϊ��ѡ��',type:'alert'});
        return false
    }
}
function setSignRules(res){
    $("input[name='in_sign']").radio({
        onChecked:function(){
            if(res.init>0){
                console.log(res.init)
                // ��ʼ����ʱ�򲻵��ñ���
                res.init-=1
                return;
            }
            Save()
        }
    })
    $("input[name='out_sign']").radio({
        onChecked:function(){
            if(res.init>0){
                // ��ʼ����ʱ�򲻵��ñ���
                res.init-=1
                return;
            }
            Save()
        }
    })    
    $("input[name='ca_sign']").radio({
        onChecked:function(){
            if(res.init>0){
                // ��ʼ����ʱ�򲻵��ñ���
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
    // ��ȡ �������ݼ̳й����ѷ�����
    var checkObj=$("input[name='extends']:checked");
    var obj={}
    obj.selected_extends=checkObj.val()
    return obj
}
function getRevoke(){
    // ��ȡ ����ǩ��Ȩ�޹����ѷ�����
    var checkObj=$("input[name='sign_rule']:checked");
    var obj={}
    obj.selected_revoke=checkObj.val()
    return obj
}
function getLocData(){
    // ��ȡ��������
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getLocData",
        descInput:""
    },function(res){
        shiftSystem=res
        // ��ʼ�����
        InitTable();
    })
}
function getWardData(locId){
    if(!locId){
        return;
    }
    
//    // ����ɸѡ
//    var LocalData=$("#dg").datagrid("getData").rows
//    var res=LocalData.find(function(item){
//        return item.loc==locId
//    })
//    if(res){
//        $.messager.popover({msg: '���������Դ��ڣ������ظ����!',type:'alert'});
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
            $.messager.popover({msg: '���ݱ���ʧ�ܣ�',type:'error'});
            getLocLinkWard()
        }else{
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
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
