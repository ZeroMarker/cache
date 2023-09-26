var editIndex;
var clcpRowId;
var selectOperIndex;
var reg=/^[0-9]+.?[0-9]*$/; 
$(function(){
	InitFormItem();
	InitGroupData();
});
function InitFormItem()
{
	var datefrm=$HUI.datebox("#DateFrom",{
    });
    var datefrm=$HUI.datebox("#DateTo",{
    });
	    var appLoc=$HUI.combobox("#AppLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="";
            param.EpisodeID="";
        }   
    });
    var Type=$HUI.combobox("#Type",{
        url:$URL+"?ClassName=web.DHCCLCareProv&QueryName=LookUpCareProv&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        editable:false,
        panelHeight:'auto',
         onBeforeLoad:function(param)
        {
            param.type="UserType";
        }   
    })
    var yesno=$HUI.combobox("#IsDoc,#IsLeave",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"��",'typecode':"1"},{'typedesc':"��",'typecode':"0"}]
    }) 
	    var fLoc=$HUI.combobox("#FDocLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="";
            param.EpisodeID="";
        }   
    });
    var fType=$HUI.combobox("#FType",{
        url:$URL+"?ClassName=web.DHCCLCareProv&QueryName=LookUpCareProv&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        editable:false,
        panelHeight:'auto',
         onBeforeLoad:function(param)
        {
            param.type="UserType";
        }   
    });
    var fHosp=$HUI.combobox("#FHosp",{
        url:$URL+"?ClassName=web.DHCCLCareProv&QueryName=FindHospital&ResultSetType=array",
        valueField:"ROWID",
        textField:"HOSPDesc",
        editable:false,
        panelHeight:'auto'
    });
    var fyesno=$HUI.combobox("#FIsDoc,#FIsLeave",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        panelHeight:'auto',
        editable:false,
        data:[{'typedesc':"��",'typecode':"1"},{'typedesc':"��",'typecode':"0"}]
    });


}
function InitGroupData()
{
	    $("#CareProvListData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCCLCareProv",
            QueryName:"FindCareProv"
        },
        onBeforeLoad: function(param) {
	        param.descV=$("#Name").val();;
	        param.aliasV=$("#Alias").val();
	        param.ctlocId=$("#AppLoc").combobox('getValue');
	        param.clcpifdoc=$("#IsDoc").combobox('getValue');
	        param.clcptype=$("#Type").combobox('getValue');
	        param.clcpinActive=$("#IsLeave").combobox('getValue');
        },
        columns:[
            [
             {field: "clcpRowId", title: "��ԱId", width: 60, sortable: true},
          	{field: "ctlocdesc", title: "����", width: 120, sortable: true},
               {field: "desc", title: "����", width: 60, sortable: true},
               {field: "alias", title: "����", width: 60, sortable: true},
               {field: "ifDocDes", title: "�Ƿ�ҽ��", width: 60, sortable: true},
               {field: "inActiveDes", title: "�Ƿ��뿪", width: 60, sortable: true},
               {field: "ifDoc", title: "�Ƿ�ҽ������", width: 60, sortable: true,hidden:true},
               {field: "typeDes", title: "����", width: 60, sortable: true},
               {field: "fdate", title: "��ʼ����", width: 80, sortable: true},
               {field: "tdate", title: "��������", width: 80, sortable: true},
               {field: "hospital", title: "ҽԺ", width: 60, sortable: true},
              {field: "type", title: "���ʹ���", width: 60, sortable: true,hidden:true},
                {field: "inActive", title: "�Ƿ��뿪����", width: 100, sortable: true,hidden:true},
              {field: "ctlocdr", title: "���ұ�ʶ", width: 60, sortable: true,hidden:true},
               {field: "hospitalDr", title: "ҽԺ��ʶ", width: 60, sortable: true,hidden:true}
            ]
        ],
        toolbar:[
            {
                iconCls: 'icon-add',
			    text:'����',
			    handler: function(){
                    appendRow();
				}
            },
            {
                iconCls: 'icon-write-order',
			    text:'�༭',
			    handler: function(){
                    editRow();
                }
            },
            {
                iconCls: 'icon-cancel',
			    text:'ɾ��',
			    handler: function(){
                    deleteRow();
                }
            }
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	        clcpRowId=rowData.clcpRowId;
	        
        }
    })
	$("#btnSearch").click(function(){
        $HUI.datagrid("#CareProvListData").reload();
    });
}

function InitOperDiag()
{
	$('#FDocLoc').combobox("reload");
	$('#FIsDoc').combobox("reload");
	$('#FType').combobox("reload");
	$('#FHosp').combobox("reload");
	$('#FIsLeave').combobox("reload");
}
//����
function appendRow()
{
	    $("#operDialog").dialog({
        title: "����ҽ����Ա",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");

}
function editRow()
{
	var selectRow=$("#CareProvListData").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "�޸�ҽ����Ա",
            iconCls: "icon-w-edit"
        });
        var desc=selectRow.desc;
        var alias=selectRow.alias;
        var ctlocdesc=selectRow.ctlocdesc;
        var ifDocDes=selectRow.ifDocDes;
        var inActiveDes=selectRow.inActiveDes;
        var ifDoc=selectRow.ifDoc;
        var typeDes=selectRow.typeDes;
        var fdate=selectRow.fdate;
        var tdate=selectRow.tdate;
        var hospital=selectRow.hospital;
        var clcpRowId=selectRow.clcpRowId;
        var type=selectRow.type;
        var inActive=selectRow.inActive;
        var ctlocdr=selectRow.ctlocdr;
         var hospitalDr=selectRow.hospitalDr;
        $("#FDocLoc").combobox('setValue',ctlocdr)
        $("#FIsDoc").combobox('setValue',ifDoc)
        $("#FType").combobox('setValue',type)
        $("#FIsLeave").combobox('setValue',inActive)
       $("#FHosp").combobox('setValue',hospitalDr)
        $("#FName").val(desc);
        $("#FAlias").val(alias);
        $HUI.datebox("#DateTo").setValue(tdate);
        $("#DateFrom").datebox('setValue',fdate);
        
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
	    //info,question,warning,error
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'warning');
        return;
    }

	
}
function deleteRow()
{
var selectRow=$("#CareProvListData").datagrid("getSelected");
    if(selectRow)
    {
	    var rowId=selectRow.clcpRowId;
	    var datas=$.m({
        ClassName:"web.DHCCLCareProv",
        MethodName:"DeleteCareProv",
        clcpRowId:rowId
    },false);
    if(datas==0)
    {
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#CareProvListData").datagrid("reload");
    }
    }
    else
    {
	    $.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'warning');
        return;
    }	
}
function saveCareProv()
{
        var desc=$("#FName").val();
        var alias=$("#FAlias").val();
 	 	var ctlocdr=$("#FDocLoc").combobox('getValue');
 	 	 if(!reg.test(ctlocdr))
 	 	 {
	 	 	 $.messager.alert("��ʾ","�������������ѡ��","error");
        	return;
 	 	 }
		var ctlocdesc=$("#FDocLoc").combobox('getText');
        var ifDoc=$("#FIsDoc").combobox('getValue');
        var ifDocDes=$("#FIsDoc").combobox('getText');
         var inActive=$("#FIsLeave").combobox('getValue');
       var inActiveDes=$("#FIsLeave").combobox('getText');
         var type=$("#FType").combobox('getValue');
        var typeDes=$("#FType").combobox('getText');
     var tdate=$("#DateTo").datebox('getValue');
        var fdate=$("#DateFrom").datebox('getValue');
        var hospital=$("#FHosp").combobox('getText');
        var hospitalDr=$("#FHosp").combobox('getValue');

      var rowdata={
         desc:desc,
         alias:alias,
        ctlocdesc:ctlocdesc,
          ctlocdr:ctlocdr,
      ifDocDes:ifDocDes,
        ifDoc:ifDoc,
        inActiveDes:inActiveDes,
        inActive:inActive,
        typeDes:typeDes,
        type:type,
        fdate:fdate,
        tdate:tdate,
        hospital:hospital,
        hospitalDr:hospitalDr
    }
     if( $("#EditOperation").val()=="Y")
    {
    	var datas=$.m({
        ClassName:"web.DHCCLCareProv",
        MethodName:"UpdateCareProv",
        clcpRowId:clcpRowId,
        ctlocdr:ctlocdr,
        desc:desc,
        alias:alias,
        fdate:fdate,
        tdate:tdate,
        inActive:inActive,
        ifDoc:ifDoc,
        type:type,
        hospital:hospitalDr
    	},false);
       $HUI.datagrid("#CareProvListData").updateRow({index:selectOperIndex,row:rowdata});
		$.messager.alert("��ʾ", "�޸ĳɹ���", 'info');
    }
    else
    {
    	var datas=$.m({
        ClassName:"web.DHCCLCareProv",
        MethodName:"InsertCareProv",
         ctlocdr:ctlocdr,
        desc:desc,
        alias:alias,
        fdate:fdate,
        tdate:tdate,
        inActive:inActive,
        ifDoc:ifDoc,
        type:type,
        hospital:hospitalDr
    	},false);
    	$HUI.datagrid("#CareProvListData").appendRow(rowdata);
    	$.messager.alert("��ʾ", "��ӳɹ���", 'info');
    }
     $("#CareProvListData").datagrid("reload");
	$HUI.dialog("#operDialog").close();
	
}