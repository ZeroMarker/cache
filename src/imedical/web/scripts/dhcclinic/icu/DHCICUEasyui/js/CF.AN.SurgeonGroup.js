var ret=dhccl.runServerMethod("web.DHCClinicCom","GetDateFormat");
if(ret.result=="j/n/Y") var today=(new Date()).format("dd/MM/yyyy");
else var today=(new Date()).format("yyyy-MM-dd");
var DT=(new Date()).format("yyyy-MM-dd HH:mm:ss");
$(document).ready(function() {
    var columns = [
        [
            { field: "RowId", title: "组号", width: 50 },
            { field: "DeptDesc", title: "科室", width: 120 },
            { field: "SurgeonDesc", title: "主刀", width: 120 },
            { field: "Assist1Desc", title: "一助", width: 120 },
            { field: "Assist2Desc", title: "二助", width: 120 },
            { field: "Assist3Desc", title: "三助", width: 120 },
            { field: "ActiveDate", title: "生效日期", width: 120 },
            { field: "ExpireDate", title: "失效日期", width: 120 },
            { field: "ActiveDesc", title: "是否激活", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: $g('手术医师组维护'),
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.SurgeonGroup,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindSurgeonGroup",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });

    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
		fit:true,
        bodyCls: 'panel-body-gray',
        onBeforeLoad: function(param) {
            param.Arg1 = session.DeptID;
            param.ArgCnt = 1;
        }
    });
	
	$("#Dept").combobox({
        valueField: 'RowId',
        textField: 'Description',
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindLocationOld";
            param.Arg1 = param.q?param.q:"";
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.ArgCnt = 2;
        },
        onChange:function(newValue,oldValue){
            $(".sur-careprov").combobox("reload");
        }
    });
	
	//定义样式-UI需要
	$("#Active").combobox({
    });
	
    $(".sur-careprov").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName=ANCLS.BLL.ConfigQueries;
            param.QueryName="FindResourceByHIS";
            param.Arg1=param.q?param.q:"";
            param.Arg2=$("#Dept").combobox("getValue")?$("#Dept").combobox("getValue"):session.DeptID;
            param.Arg3="Y";
            param.Arg4=session.HospID;
            param.ArgCnt=4;
        },
        valueField: "CareProvider",
        textField: "CareProvDesc",
        mode: "remote",
        onSelect:function(record){
            var selector=$(this).attr("id");
            var selectorVal=$("#"+selector).combobox("getValue");
            if((selectorVal===$("#Surgeon").combobox("getValue"))&&(selector!=="Surgeon")){
                $.messager.alert("提示","不可与主刀重复,请重新选择！","warning");
                $(this).combobox("setValue","");
                return;
            }
            if((selectorVal===$("#Assist1").combobox("getValue"))&&(selector!=="Assist1")){
                $.messager.alert("提示","不可与一助重复,请重新选择！","warning");
                $(this).combobox("setValue","");
                return;
            }
            if((selectorVal===$("#Assist2").combobox("getValue"))&&(selector!=="Assist2")){
                $.messager.alert("提示","不可与二助重复,请重新选择！","warning");
                $(this).combobox("setValue","");
                return;
            }
            if((selectorVal===$("#Assist3").combobox("getValue"))&&(selector!=="Assist3")){
                $.messager.alert("提示","不可与三助重复,请重新选择！","warning");
                $(this).combobox("setValue","");
                return;
            }
        }
    });
	
	$("#ActiveDate,#ExpireDate,#UpdateDate").datebox({
		formatter:function (date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
			if(ret.result=="j/n/Y"){ 
			d=d<10?('0'+d):d;
			m=m<10?('0'+m):m;
			var ssss=d+'/'+m+'/'+y;
			return ssss;}
            else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
        },
		parser:function(s){
			if (!s) return new Date();
			if(s.indexOf("/")>=0){
				var ss = s.split('/');
				var y = parseInt(ss[2],10);
				var m = parseInt(ss[1],10);
				var d = parseInt(ss[0],10);
			}
			else{
				var ss = s.split('-');
				var y = parseInt(ss[0],10);
				var m = parseInt(ss[1],10);
				var d = parseInt(ss[2],10);
			}
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
				return new Date();
			}
		}
    });
});

function initDefaultValue() {
    //$("#Active").combobox("setValue", "Y");
    $("#UpdateDate").datebox("setValue",today);
	$HUI.timespinner("#UpdateTime").setValue(DT.split(" ")[1]);
    $("#UpdateUser").val(session.UserID);
    $(".sur-careprov").combobox("reload");
}