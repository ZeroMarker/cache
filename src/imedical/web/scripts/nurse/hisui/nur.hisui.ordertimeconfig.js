// Nur_IP_QLAssess
// ���iefind�������������    
isIE();
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
if (!Array.prototype.find) {
    Array.prototype.find = function (callback) {
        return callback && (this.filter(callback) || [])[0];
    };
}
var hospID = ""; // ҽԺid
var proObj = "";
var wardId = ""; // ����id
var hospComp=""
var isMultiHosp=true // ��Ժ���Ƿ�����
var shiftSystem = [];
var timeStr="" // ��ǰ�ɱ༭��ʱ����
window.onload = function () {
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"isMultiHosp"
    },function(res){
        if(res==1){
            // ��ҽԺ����
            isMultiHosp=true
            var proObj = new Promise(function (resolve, reject) {
                hospComp= GenHospComp('ExchangeSettingV2');
                if (hospComp.getValue()) {
                    resolve(hospComp.getValue());
                } else {
                    reject("ҽԺ���ݼ���ʧ�ܣ�");
                }
            });
            proObj.then(function (res) {
                // ��Ժ��
                Init(res);
            });
        }else{
            // �Ƕ�Ժ��
            isMultiHosp=false
            Init_noHosp()
            getShiftSystem()
        }
    })
    // ��ѯ����
    $("#search").click(function () {
        search();
    });
};

function Init_noHosp(){
    // �������ݻ�ȡ
    getWardData("2");
    // ��ʼ��info��Ϣ
    infoInit();
    // ��ʼ���Զ���Ļ
    initScrien();
}

function Init(res) {
    // �й�ҽԺ���߼�(�ж�Ժ��)
    hospID = res;
    $("#_HospList").combogrid({
        onSelect: function () {
            hospID = hospComp.getValue();
            // console.log('song',hospID)
            getWardData(hospID);
        },
    });
    // �������ݻ�ȡ
    getWardData(hospID);
    // ��ʼ���ϱ��
    getShiftSystem()
    // ��ʼ��info��Ϣ
    infoInit();
    // ��ʼ���Զ���Ļ
    initScrien();
}

function getWardData(hospid) {
    $cm({
            ClassName: "Nur.NIS.Service.Base.Ward",
            QueryName: "GetallWardNew",
            desc: "",
            hospid: hospid,
            bizTable: "ExchangeSettingV2",
            rows:99999
        },
        function (obj) {
            wardId = "";
            $HUI.combobox("#wardBox", {
                valueField: "wardid",
                textField: "warddesc",
                multiple: false,
                selectOnNavigation: false,
                panelHeight: "210",
                editable: true,
                data: obj.rows,
                onChange: function (newval) {
                    wardId = newval;
                    // console.log(wardId);
                    // disableButtom(false)
                },
            });
        }
    );
}

function search() {
    // console.log("��ѯ");
    // enableMultTemplates("2^4", false)
    $("#infoContent").find("div.box").find("table").css("visibility","hidden")
	$("#infoContent").find("div.box").find("span").css("visibility","hidden")
    editIndex=undefined
    getShiftSystemData()
}

var editIndex = undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};

function TableOneInit() {
    var tableOneData=$cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getShiftSystem",
        hospId:hospID,
        wardId:wardId
    },false)
    $HUI.datagrid("#tableOne", {
        columns: [
            [{
                    field: "id",
                    title: "����",
                    width: 300,
                    formatter: function (value) {
                        var targetObj = shiftSystem.find(function (item) {
                            return item.id == value;
                        });
                        // console.log(targetObj);
                        if (targetObj) {
                            return targetObj.desc;
                        } else {
                            return value;
                        }
                    },
                    editor: {
                        type: "combobox",
                        options: {
                            valueField: "id",
                            textField: "desc",
                            data: shiftSystem,
                            panelHeight: "125",
                            required: true,
                            blurValidValue: true,
                        },
                    },
                },
                {
                    field: "note",
                    title: "�������",
                    width: 300,
                    editor: {
                        type: "validatebox",
                        options: {
                            required: true,
                        },
                    },
                },
                {
                    field: "code",
                    title: "��������ģ��Code",
                    width: 300,
                    editor: {
                        type: "validatebox",
                        options: {
                            required: true,
                        },
                    },
                },
                {
                    field: "MainFlag",
                    title: "Ĭ�Ͻ���",
                    width: 300,
                    editor:{
                        type:'icheckbox',
                        options:{
                            on:'Y',
                            off:'N',
                            required: true,
                        }
                    },
                    formatter:function(value){
                        if(value=="Y"){
                            return "��"
                        }else{
                            return "��"
                        }
                    }
                },
            ],
        ],
        data: tableOneData,
        toolbar: [{
                iconCls: "icon-add",
                text: "����",
                id:"add_one",
                handler: function () {
                    if(editIndex!=undefined){
                        $.messager.popover({msg: '��δ����������ݣ�',type:'alert'});
                        return;
                    }
                    var reIndex = 0;
                    $("#tableOne").datagrid("insertRow", {
                        index: reIndex, // ������0��ʼ
                        row: {
                            id: "4",
                            note: "",
                            code: "",
                            MainFlag: "N",
                            rowId:""
                        },
                    });
                    editIndex = reIndex;
                    $("#tableOne").datagrid("beginEdit", reIndex);
                },
            },
            {
                iconCls: "icon-save",
                text: "����",
                id:"save_one",
                handler: function () {
                    // console.log("save");
                    endEditing();
                },
            },
            {
                iconCls: "icon-cancel",
                text: "ɾ��",
                id:"del_one",
                disabled: false,
                handler: function () {
                    var record=$("#tableOne").datagrid("getSelected");
                    if(!record){
                        $.messager.popover({msg: 'δѡ��Ҫɾ��������',type:'alert'});
                        return;
                    }
                    $.messager.confirm("ɾ��", "ȷ��Ҫɾ������������?", function (r) {
                        if (r) {
                        //    console.log(record)
                           $cm({
                               ClassName:"Nur.SHIFT.Service.ShiftSetting",
                               MethodName:"delShiftSystem",
                               rowId:record.rowId
                           },function(res){
                                if(res.status==-1){
                                    $.messager.popover({msg: res.msg,type:'error'});
                                }else{
                                    $.messager.popover({msg: res.msg,type:'success',timeout: 1000});
                                    getShiftSystemData()
                                    editIndex=undefined
                                }
                           })
                        } 
                    });
                },
            },
        ],
        fitColumns: true,
        onDblClickRow: onClickRow,
        onClickRow:function(rowindex,record){
//            if(editIndex!=undefined){
//                return;
//            }
            var typeId=record.id;
            var strarr=[]
            for(var i=1;i<=typeId;i++){
                strarr.push(i);
            }
            var str=strarr.join("^");
            timeStr=str;
            disableMultTemplates()
            enableMultTemplates(str)
            if(record.id==1){
                //$("#Order_1").validatebox("disableValidation")
                //$("#Order_1").validatebox("setDisabled",true)
            }
            setTimeData([])
            getShiftSystemTime(record.rowId)
        }
    });
    
    disableMultTemplates("1^2^3^4")
    if(wardId==""){
        // disableButtom(true)
    }
}

function endEditing(curIndex) {
    if (editIndex == undefined) {
        return true;
    }
    if ($("#tableOne").datagrid("validateRow", editIndex)) {
        //�б���������ʵ�֣��޸ĺ�ѻ�дfeetypename����Ϊformatter��ʾ����feetypename�ֶ�
        var ed = $("#tableOne").datagrid("getEditor", {
            index: editIndex,
            field: "id",
        });
        var feetypename = $(ed.target).combobox("getText");
        $("#tableOne").datagrid("getRows")[editIndex]["id"] = feetypename;
        $("#tableOne").datagrid("endEdit", editIndex);
        modifyAfterRow = $("#tableOne").datagrid("getRows")[editIndex];
        var aStr = JSON.stringify(modifyAfterRow);
        var bStr = JSON.stringify(modifyBeforeRow);
        
        // console.log("�޸ĺ�");
        // console.dir(modifyAfterRow);
        // �ύ����������������
        saveShiftSystem(modifyAfterRow)
        if(curIndex != undefined){	        
			editIndex = curIndex;
	    }else{
		    editIndex = undefined; 
		}
		getShiftSystemData()
        //editIndex = undefined;
        //return true;
    } else {
        //return false;
    }
}

function onClickRow(index) {
            if(editIndex!=undefined){
                return;
            }
	$("#tableOne").datagrid('beginEdit',index)
	if(editIndex == undefined){
		editIndex = index;
	}else if(editIndex != index){
		endEditing(index);
	}	
	
//    if (editIndex != index) {
//        if (endEditing()) {
//            $("#tableOne").datagrid("selectRow", index).datagrid("beginEdit", index);
//            editIndex = index;
//            modifyBeforeRow = $.extend({},
//                $("#tableOne").datagrid("getRows")[editIndex]
//            );
//        } else {
//            $("#tableOne").datagrid("selectRow", editIndex);
//        }
//    }
}

function infoInit() {
    $HUI.panel("#accPanel", {
        iconCls: "icon-paper",
        fit: true,
        onBeforeClose: function () {
            alert("�����˹ر�!");
            return false;
        },
        headerCls: "panel-header-gray",
    });
    $("#saveTwo").click(function () {
        // disableMultTemplates("1^3^4");
        saveTimedata(timeStr)
    });
    infoPanel();
}

function initScrien() {
    window.onresize = function () {
        // $('#tableOne').datagrid("resize"); // easyui ���÷����ķ��
        $HUI.datagrid("#tableOne").resize();
        $HUI.panel("#accPanel").resize(); // hisui ���÷����ķ��
    };
}

function infoPanel() {
    $HUI.panel("#infoPanel", {
        closable: true,
        headerCls: "panel-header-gray"
    });
}

function disableTemplate(Num, isDisable) {
    /**
     * isDisable:true ��ʾ���������Ĭ��Ϊ���ã�
     * isDisable:false ��ʾ�������
     */
    
    var status = "disable"
    var status_Validation = "disableValidation"
    if (!isDisable) {
        status = "enable"
        status_Validation = "enableValidation"
    }
    //console.log(Num+"="+isDisable)
    $("#infoContent").find("div.box").eq(Num-1).find("table").css("visibility","")
    $("#infoContent").find("div.box").eq(Num-1).find("span").css("visibility","")
    if (!Num) {
        // ��������
        for (var i = 1; i <= 4; i++) {
            $("#Order_" + i).validatebox("setDisabled", isDisable)
            $("#Order_" + i).validatebox(status_Validation)
            $("#Time_start_" + i).timespinner(status)
            $("#Time_start_" + i).timespinner(status_Validation)
            $("#Time_end_" + i).timespinner(status)
            $("#Time_end_" + i).timespinner(status_Validation)
            $("#Select_start_" + i).combobox(status)
            $("#Select_start_" + i).combobox(status_Validation)
            $("#Select_end_" + i).combobox(status)
            $("#Select_end_" + i).combobox(status_Validation)
            $("#Color" + i).combobox(status)
            $("#Color" + i).combobox(status_Validation)
            
        }
    } else {
	     
         
        for (var i = 1; i <= 4; i++) {
            if (Num == i) {
                $("#Order_" + i).validatebox("setDisabled", isDisable)
                $("#Order_" + i).validatebox(status_Validation)
                $("#Time_start_" + i).timespinner(status)
                $("#Time_start_" + i).timespinner(status_Validation)
                $("#Time_end_" + i).timespinner(status)
                $("#Time_end_" + i).timespinner(status_Validation)
                $("#Select_start_" + i).combobox(status)
                $("#Select_start_" + i).combobox(status_Validation)
                $("#Select_end_" + i).combobox(status)
                $("#Select_end_" + i).combobox(status_Validation)
                $("#Color" + i).combobox(status)
            	$("#Color" + i).combobox(status_Validation)
            	
            }
        }
    }
    if (!isDisable) {
        // ����ʱ������֤
        // console.log('skjd')
        for (var i = 1; i <= 4; i++) {
            $("#Order_" + i).validatebox("validate")
            $("#Time_start_" + i).timespinner("validate")
            $("#Time_end_" + i).timespinner("validate")
            $("#Select_start_" + i).combobox("validate")
            $("#Select_end_" + i).combobox("validate")
            $("#Color" + i).combobox("validate")
        }
    }
}
// ���������args:1^2^3^4
function disableMultTemplates(args) {
	console.log(args)
    // �������
    if (!args) {
        disableTemplate("",true);
        return;
    }
    args.split("^").forEach(function (item) {
        // console.log(item)
        disableTemplate(item,true)
    });
}
// ���������args:1^2^3^4
function enableMultTemplates(args) {
	$("#infoContent").find("div.box").find("table").css("visibility","hidden")
	$("#infoContent").find("div.box").find("span").css("visibility","hidden")
	
	//console.log(args+"aa")
    if (!args) {
        disableTemplate("", false);
        return;
    }
    
    args.split("^").forEach(function (item) {
        // console.log(item)
        disableTemplate(item, false)
    });
}
// ��ȡ��ָ̨���İ�����Ϣ
function getShiftSystem(){
    $cm({
        ClassName:"CF.NUR.SHIFT.ExchangeSettingV2",
        MethodName:"GetShiftSystem"
    },function(res){
        shiftSystem=res
        // ��ʼ���ϱ��
        TableOneInit();
    })
}
function disableButtom(args){
    // trueΪ
    if(args){
        $("#del_one").linkbutton("disable")
        $("#add_one").linkbutton("disable")
        $("#save_one").linkbutton("disable")
        // $("#saveTwo").linkbutton("disable")
    }else{
        $("#del_one").linkbutton("enable")
        $("#add_one").linkbutton("enable")
        $("#save_one").linkbutton("enable")
        // $("#saveTwo").linkbutton("enable")
    }
}
function saveShiftSystem(record){
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"saveShiftSystem",
        rowId:record.rowId, 
        wardId:wardId, 
        Type:record.id, 
        Name:record.note, 
        code:record.code, 
        mainFlag:record.MainFlag, 
        hospId:hospID
    },function(res){
        if(res.status==-1){
            $.messager.popover({msg: '���ݱ���ʧ�ܣ�',type:'error'});
        }else{
            $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
            //getShiftSystemData()
            //setTimeData([])
        }
    })
}
function getShiftSystemData(){
	setTimeData([])
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getShiftSystem",
        hospId:hospID,
        wardId:wardId
    },function(res){
        $("#tableOne").datagrid("loadData",res)
        //disableMultTemplates()
        timeStr=""
    })
}
function saveTimedata(str){
    if(str==""){
	   
        return;
    }
    // console.log(str)
    var res=[];
    // ����str��ȡ��Ӧ������
    for(var i=1;i<=str.split("^").length;i++){
        var order=$("#Order_" + i).validatebox("isValid")
        var TimeStr=$("#Time_start_" + i).timespinner("isValid")
        var TimeEnd=$("#Time_end_" + i).timespinner("isValid")
        var selectStr=$("#Select_start_" + i).combobox("isValid")
        var selectEnd=$("#Select_end_" + i).combobox("isValid")
        var color=$("#Color_" + i).combobox("isValid")
        var obj={}
        obj.order=order
        obj.TimeStr=TimeStr
        obj.TimeEnd=TimeEnd
        obj.selectStr=selectStr
        obj.selectEnd=selectEnd
        obj.color=color
        res.push(obj)
    }
     //console.log(res)
    // ��֤���Ƿ���δ������
    var isOk=res.every(function(item){
        var status=true
        for(var k in item){
            if(!item[k]){
                status=false
            }
        }
        return status;
    })
   //alert(isOk)
    if(!isOk){
        return;
    }
    // ����str��ȡ��Ӧ�����ֵ
    // console.log($("#Order_1").val())
    var dataArr=[]
    for(var s=1;s<=str.split("^").length;s++){
        var order_d=$("#Order_" + s).val();
        var TimeStr_d=$("#Time_start_" + s).timespinner('getValue')
        var TimeEnd_d=$("#Time_end_" + s).timespinner('getValue')
        var selectStr_d=$("#Select_start_" + s).combobox("getValue")
        var selectEnd_d=$("#Select_end_" + s).combobox("getValue")
        var color_d=$("#Color_" + s).color("getValue");
        var newObj={}
        newObj['order']=order_d
        newObj['TimeStr']=TimeStr_d
        newObj['TimeEnd']=TimeEnd_d
        newObj['selectStr']=selectStr_d
        newObj['selectEnd']=selectEnd_d
        newObj['color']=color_d
        newObj['type']=s
        dataArr.push(newObj)
     }
    var jsonStr=JSON.stringify(dataArr)
    var record=$("#tableOne").datagrid("getSelected");
    if(!record){
        return;
    }
    console.log(jsonStr)
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"saveShiftSystemTime",
        parentId:record.rowId,
        jsonStr:jsonStr
    },function(res){
        if(res.status==-1){
            $.messager.popover({msg: res.msg,type:'error'});
        }else{
            $.messager.popover({msg: res.msg,type:'success',timeout: 1000});
        }
    })
}
function getShiftSystemTime(parentId){
    $cm({
        ClassName:"Nur.SHIFT.Service.ShiftSetting",
        MethodName:"getShiftSystemTime",
        parentId:parentId
    },function(res){
        setTimeData(res)
    })
}

function setTimeData(data){
    if(data.length>0){
        data.forEach(function(item){
            $("#Order_" + item.timeType).val(item.timeName)
            $("#Time_start_" + item.timeType).timespinner('setValue',item.timeStarTimer)
            $("#Time_end_" + item.timeType).timespinner('setValue',item.timeEndTimer)
            $("#Select_start_" + item.timeType).combobox('setValue',item.timeStarFlag)
            $("#Select_end_" + item.timeType).combobox('setValue',item.timeEndFlag) 
            $("#Color_" + item.timeType).color("setValue",item.timeColor)
        })
    }else{
        // ȫ������Ϊ��
        for(var i=1;i<=4;i++){
            $("#Order_" + i).val("")
            $("#Time_start_" + i).timespinner('setValue',"")
            $("#Time_end_" + i).timespinner('setValue',"")
            $("#Select_start_" + i).combobox('setValue',"0")
            $("#Select_end_" + i).combobox('setValue',"0")
            $("#Color_" + i).color("setValue","")
        }
    }
    
    for (var i = 1; i <= 4; i++) {
        $("#Order_" + i).validatebox("validate")
        $("#Time_start_" + i).timespinner("validate")
        $("#Time_end_" + i).timespinner("validate")
        $("#Select_start_" + i).combobox("validate")
        $("#Select_end_" + i).combobox("validate")
    }
    
    
}