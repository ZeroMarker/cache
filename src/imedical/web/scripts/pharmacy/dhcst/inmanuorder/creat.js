/**
 * ģ��:     �Ƽ���Ϣά��
 * ��д����: 2018-07-04
 * ��д��:   zzd
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGrpId=session['LOGON.GROUPID']
var inmanuurl="dhcst.inmanuorderaction.csp"
var LocFlag=""
var InManu="";
var gParam=[];
var AddCostType=""

$(function() {
	InitLoc();
    InitGridManuOrd();
    InitGridManuOrdBat() ;
    GetParam();
    //SetChkInfoState();
    $('#btnFind').on("click", OpenFindDiv);
    $('#btnSaveOk').on("click", AddInManu);
    $('#btnAudit').on("click", AuditInManu);
    $('#btnDel').on("click", DelInManu);
    $('#btnClear').on("click", Clear);
    
    //��ѯdiv
    InItInManu()
	$('#btnSearch').on("click", Search);
	$('#btnSelect').on("click", Select);
	$('#btnClose').on("click", Close);
	/*
	$('#txtExpDate').datebox({
            formatter: function (date) {
                var y = date.getFullYear();
				var m = date.getMonth()+1;
				var d = date.getDate();
				return y+'-'+m+'-'+d;
            },
            parser: function (s) {
	            if (/^.{10}$/.test(s)){
		            s = s.replace(/-/g,"/");
					var date = new Date(s);
		            return date
		            }
		        else if (/^.{9}$/.test(s)){
		            s = s.replace(/-/g,"/");
					var date = new Date(s);
		            return date
		            }
		        else if (/^\d{8}$/.test(s)){
			        return new Date(s.substr(0, 4) + '-' + s.substr(4, 2) + '-' + s.substr(6, 2))
			       
			        }
			     else {
				      return new Date()
				     } 
            }
        });
        */
 	// �ǼǺŻس��¼�
    $('#txtTheoryQty').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
	        
	        if(AddCostType!="2"){return;}   //
	        var InRec=$('#cmbInRec').combobox('getValue'); 
	        if((InRec || "")==""){
		        $.messager.alert('��ʾ', '��ѡ���Ƽ�', 'warning');
		        $("#txtTheoryQty").val("");
				return;
	        }
            var TheoryQty = $('#txtTheoryQty').val().trim(); // ��������
            var uomid=$('#cmbUom').combobox("getValue");
            var Locid=$('#cmbLoc').combobox("getValue");
			if((TheoryQty || 0)!=0){
				var addcost=tkMakeServerCall("web.DHCST.ManuOrder","GetAddCost",InRec,TheoryQty,uomid,Locid);
				$("#txtAddCost").val(addcost);
				$("#txtAddCost").validatebox({
					required: true,
					validType: 'PosNumber'
				})
				
			}
			
        }
    });
})
function GetParam(){  
	$.m({
        ClassName: "web.DHCST.ManuOrder",
        MethodName: "GetParam",
        GroupId:SessionGrpId,
        LocId:SessionLoc, 
        UserId:SessionUser
    }, function(retData) {
        gParam = retData.split("^");
       	AddCostType=gParam[0];		//���ӷ��ü��㷽ʽ     1���̶����ӷ�(��������);2����Ʒ��ԭ�Ͻ��۲�(�������йأ�����������۸�)
    });
}
function InitLoc(){
	 DHCST.ComboBox.Init({ Id: 'cmbLoc', Type: 'Loc' }, {
	    editable: true,
	    onLoadSuccess: function() {
		    //if(LocFlag!=""){return}
	        var datas = $("#cmbLoc").combobox("getData");
	        for (var i = 0; i < datas.length; i++) {
	            if (datas[i].RowId == SessionLoc) {
	                $("#cmbLoc").combobox("setValue", datas[i].RowId);
	                LocFlag=1
	                break;
	            }
	        }
	    },
	    onSelect: function(data) {
	       
	    }
	});
	$("#txtManuDate").datebox("setValue",GetDate(0));  //
    $("#txtExpDate").datebox("setValue", "");  //GetDate(1000)
    DHCST.ComboGrid.Init({ Id: 'cmbInRec',Type: 'InRec' }, {
    	onSelect: function(data) {
	        var InRec=data.RowId
	    	
            var rowData = $('#cmbInRec').combogrid("grid").datagrid("getSelected");
            if ((rowData == "") || (rowData == null)) {
                return;
            }
            $("#cmbUom").combobox("setValue", "");
            var InRec=rowData.RowId;
            var ExpDate=rowData.ExpDate;
            var AddCost=rowData.AddCost;
            //var Remark=$('#txtRemarks').val().trim();
			$("#txtRemarks").val(rowData.Remark)
			
			$("#txtExpDate").datebox("setValue", ExpDate);  
        	if(AddCostType=="1"){
	        	$("#txtAddCost").val(AddCost);
        	}
            $('#cmbUom').combobox("reload");
            var Uom="";
            
            var HosId="";
            var Param=SessionGrpId+"^"+SessionLoc+"^"+SessionUser+"^"+HosId;
            var PriceStr=tkMakeServerCall("web.DHCST.Common.JsCommon","GetInrecPrice",InRec,Uom,Param);
            if(PriceStr!=""){
	            var PriceArr=PriceStr.split("^");
	            $("#txtRp").val(PriceArr[0]);
	            $("#txtSp").val(PriceArr[1])
	            
            }
            SetChkInfoState();
	    }
    }); 
  	
    DHCST.ComboBox.Init({ Id: 'cmbManuUser',Type: 'UserOfGrp'}, {});
    DHCST.ComboBox.Init({ Id: 'cmbUom',Type: 'Uom',Inci:'' }, {
    	onBeforeLoad: function(param) {
            param.inputStr = $('#cmbInRec').combobox('getValue');
            param.filterText = param.q;
        },
    	onLoadSuccess: function(data) {
	        var len=data.length;
            if (len > 0) {
                var selectUom = $('#cmbUom').combobox("getValue") || "";
                var finalUom=""
                // Ĭ�ϵ�λ
                for(var i=0;i<len;i++){
	                var iUom=data[i].RowId;
	                if (iUom==selectUom){
		            	finalUom=iUom;
		            	break;
		            }
                }
                if (finalUom==""){
	            	finalUom=data[0].RowId; 
	            }
	            $(this).combobox('select', finalUom);
            }else{
	        	$(this).combobox('clear');
	        }
        },
        onSelect: function(data) {
	    	var InRec=$('#cmbInRec').combobox('getValue'); 
	    	var Uom=data.RowId;
            var HosId="";
            var Param=SessionGrpId+"^"+SessionLoc+"^"+SessionUser+"^"+HosId;
            var PriceStr=tkMakeServerCall("web.DHCST.Common.JsCommon","GetInrecPrice",InRec,Uom,Param);
            if(PriceStr!=""){
	            var PriceArr=PriceStr.split("^");
	            $("#txtRp").val(PriceArr[0]);
	            $("#txtSp").val(PriceArr[1])
	            
            }
	    }
        
    });
	
    //��ѯdiv
    $("#txtStartDate").datebox("setValue",GetDate(-10));
    $("#txtEndDate").datebox("setValue", GetDate(0));
    
    DHCST.ComboBox.Init({Id: 'cmbStatus',data: {
        data: [
            { "RowId": "10", "Description": $g("����") },
            //{ "RowId": "15", "Description": "���" },
            { "RowId": "21", "Description": $g("�����") }
        ]
    }}, {});
    
}



function AddInManu(){
	var ManuNo = $('#txtInManuNo').val().trim(); // ����
	if(ManuNo==""){InManu=""}
	SetChkInfoState();
	var paramsArr = [];
	var InManuDate = $('#txtManuDate').datebox('getValue'); // �Ƽ�����
	if((InManuDate || "")==""){
		$.messager.alert('��ʾ', '��¼���Ƽ�����', 'warning');
		return;
	}
	var LocId = $('#cmbLoc').combobox("getValue"); // �Ƽ�������
	if((LocId || "")==""){
		$.messager.alert('��ʾ', '��ѡ���Ƽ�����', 'warning');
		return;
	}
	var InRec= $('#cmbInRec').combobox('getValue'); // �Ƽ�id
	if((InRec || "")==""){
		$.messager.alert('��ʾ', '��ѡ���Ƽ�', 'warning');
		return;
	}
	var BatNo= $('#txtBatNo').val().trim();; // �Ƽ�����
	if((BatNo || "")==""){
		$.messager.alert('��ʾ', '����д�Ƽ�������Ϣ', 'warning');
		return;
	}
	var ExpDate = $('#txtExpDate').datebox('getValue'); // �Ƽ���Ч��
	if((ExpDate || "")==""){
		$.messager.alert('��ʾ', '����д�Ƽ���Ч��', 'warning');
		return;
	}
	var Uom = $('#cmbUom').combobox("getValue"); // �Ƽ���λ
	if((Uom || "")==""){
		$.messager.alert('��ʾ', '��ѡ���Ƽ���λ', 'warning');
		return;
	}
	var valbox = $HUI.validatebox("#txtTheoryQty", {
		required: true,
		validType: 'PosNumber'
	});
	if(!valbox.isValid()){
		$.messager.alert('��ʾ', '����ȷ��д�Ƽ���������', 'warning');
		return;
	}
		
	var TheoryQty = $('#txtTheoryQty').val().trim(); // ��������
	if((TheoryQty || "")==0){
		$.messager.alert('��ʾ', '����д�Ƽ���������', 'warning');
		return;
	}
	var valbox = $HUI.validatebox("#txtFactQty", {
		required: true,
		validType: 'PosNumber'
	});
	if(!valbox.isValid()){
		$.messager.alert('��ʾ', '����ȷ��д�Ƽ�ʵ������', 'warning');
		return;
	}
	var FactQty = $('#txtFactQty').val().trim(); // ʵ������
	if((FactQty || "")==0){
		$.messager.alert('��ʾ', '����д�Ƽ�ʵ������', 'warning');
		return;
	}
	if(parseInt(TheoryQty)<parseInt(FactQty)){
		$.messager.alert('��ʾ', 'ʵ���������ܴ�����������', 'warning');  //��������������С��ʵ������ 
		return;
		}
	
	var valbox = $HUI.validatebox("#txtAddCost", {
		required: true,
		validType: 'PosNumber'
	});
	if(!valbox.isValid()){
		$.messager.alert('��ʾ', '����ȷ��д�Ƽ����ӷ���', 'warning');
		return;
	}
	var AddCost= $('#txtAddCost').val().trim(); // ���ӷ�
	if((AddCost || "")==""){
		$.messager.alert('��ʾ', '����д�Ƽ����ӷ���', 'warning');
		return
	}
	var ManuUser= $('#cmbManuUser').datebox('getValue'); // �Ƽ���
	if((ManuUser || "")==""){
		$.messager.alert('��ʾ', '����д�Ƽ���', 'warning');
		return
	}
	var OperUser=SessionUser;  //������
	var Remark= $('#txtRemarks').val().trim(); // ��ע
	var Comp = $("#chkComp").is(':checked') ? "Y" : "N";
	var ManuStartDate = $('#txtManuStartDate').datebox('getValue'); // �Ƽ�����

	
	var RP= $('#txtRp').val().trim(); // ����
	var valbox = $HUI.validatebox("#txtRp", {
		required: true,
		validType: 'PosNumber'
	});
	if(!valbox.isValid()){
		$.messager.alert('��ʾ', '����ȷ��д�Ƽ�����', 'warning');
		return;
	}
	var RP= $('#txtRp').val().trim(); // ���ӷ�
	if((RP || "")==""){
		$.messager.alert('��ʾ', '����д�Ƽ�����', 'warning');
		return
	}
	
	var valbox = $HUI.validatebox("#txtSp", {
		required: true,
		validType: 'PosNumber'
	});
	if(!valbox.isValid()){
		$.messager.alert('��ʾ', '����ȷ��д�Ƽ��ۼ�', 'warning');
		return;
	}
	var SP= $('#txtSp').val().trim(); // ����
	if((SP || "")==""){
		$.messager.alert('��ʾ', '����д�Ƽ��ۼ�', 'warning');
		return
	}
	paramsArr[0]=InManuDate;
	paramsArr[1]=LocId;
	paramsArr[2]=InRec;
	paramsArr[3]=BatNo;
	paramsArr[4]=ExpDate;
	paramsArr[5]=Uom;
	paramsArr[6]=TheoryQty;
	paramsArr[7]=FactQty;
	paramsArr[8]=AddCost;
	paramsArr[9]=ManuUser;
	paramsArr[10]=OperUser;
	paramsArr[11]=Remark;
	paramsArr[12]=Comp;
	paramsArr[13]=ManuStartDate;
	paramsArr[14]=RP;
	paramsArr[15]=SP;

	var params=paramsArr.join("^");
    DHCST.Progress.Show({ type: 'save', interval: 1000 });
    
    $.m({
        ClassName: "web.DHCST.ManuOrder",
        MethodName: "SaveManuOrder",
        InManu: InManu,
        MainData: params
    }, function(retData) {
        DHCST.Progress.Close();
        var retArr = retData.split("^");
        if (retArr[0] == -1) {
            $.messager.alert('��ʾ', retArr[1], 'warning');
            return;
        } else if (retArr[0] < -1) {
            $.messager.alert('��ʾ', retArr[1], 'error');
            return;
        }
        InManu=retArr[0]
    	Query();
    });
        
	
}
//�Ƽ��������
function AuditInManu(){
	if(InManu==""){
		 $.messager.alert('��ʾ', "�޵��ݣ�", 'warning');
         return;
	}
	var Comp = $("#chkComp").is(':checked') ? "Y" : "N";
	DHCST.Progress.Show({ type: 'save', interval: 1000 });
	if(Comp!="Y"){
		$.m({
		    ClassName: "web.DHCST.ManuOrder",
		    MethodName: "ComplateInManu",
		    InManu: InManu,
		    User:SessionUser
		}, function(retData) {
		    var retArr = retData.split("^");
		    if (retArr[0]!=0) {
			    DHCST.Progress.Close();
		        $.messager.alert('��ʾ', retArr[1], 'err');
		        return;
		    } 
		});
	}
	setTimeout(function(){
		$.m({
		    ClassName: "web.DHCST.ManuOrder",
		    MethodName: "AuditInManu",
		    InManu: InManu,
		    User:SessionUser
		}, function(retData) {
			DHCST.Progress.Close();
		    var retArr = retData.split("^");
		    if (retArr[0]!=0) {
		        $.messager.alert('��ʾ', retArr[1], 'err');
		        return;
		    } 
		    Query();
		});
	},100);
}
//�Ƽ���ɾ��
function DelInManu(){
    $.m({
        ClassName: "web.DHCST.ManuOrder",
        MethodName: "DelManuOrder",
        InManu: InManu
    }, function(retData) {
        var retArr = retData.split("^");
        if (retArr[0] == -1) {
            $.messager.alert('��ʾ', retArr[1], 'warning');
            return;
        } else if (retArr[0] < -1) {
            $.messager.alert('��ʾ', retArr[1], 'error');
            return;
        }
        else{
	    	InManu="";
        	Clear();
        }
        
    });
}
function InitGridManuOrd() {
    var columns = [
        [
        	{ field: "Inci", title: 'Rowid', width: 50, halign: 'center', hidden: true },
            { field: "InciCode", title: 'ԭ�ϴ���', width: 100 },
            { field: "InciDesc", title: 'ԭ������', width: 200},
            { field: "RcpUom", title: '��λ', width: 60 },
            { field: "NeedQty", title: '��������', width: 60 }
  
        ]
    ];
    var dataGridOption = {
        url: '',           //inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        toolbar:[],
        pageSize: 50,
        pageList: [50, 100, 200]
    };
    DHCPHA_HUI_COM.Grid.Init("gridInManuOrd", dataGridOption);
}
function InitGridManuOrdBat() {
    var columns = [
        [	
        	{ field: "Inclb", title: 'Inclb', width: 200, halign: 'center',hidden:'true' },
        	{ field: "InciCode", title: 'ԭ�ϴ���', width: 100 },
            { field: "InciDesc", title: 'ԭ������', width: 200 },
            { field: "ExpDate", title: 'Ч��', width: 100 },
            { field: "BatNo", title: '����', width: 80},
            { field: "Qty", title: '����', width: 60, halign: 'right', align: 'right' },
            { field: "Uom", title: '��λ', width: 60},
            { field: "PQty", title: '����(��ⵥλ)', width: 80 },
            { field: "PurUom", title: '��ⵥλ', width: 60 },
            { field: "StkQTy", title: '�������', width: 80},
            { field: "Manf", title: '������ҵ', width: 160 }
        ]
    ];
    var dataGridOption = {
        url:'', // inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        toolbar:[],
        pageSize: 50,
        pageList: [50, 100, 200]
    };
    DHCPHA_HUI_COM.Grid.Init("gridInManuOrdBat", dataGridOption);
}
function OpenFindDiv(){
	$('#gridInManu').datagrid("clear");
	$('#FindWindowDiv').dialog('open');
	
	return
}
///��ѯ
function Query() {
	
    var params=InManu;
    QueryInRec();
    
    $('#gridInManuOrdBat').datagrid({
	    url: inmanuurl + '?action=GetManuOrdBat',
        queryParams: {
            Params: params
        }
    });
    $('#gridInManuOrd').datagrid({
	    url: inmanuurl + '?action=GetManuOrdDetail',
        queryParams: {
            Params: params
        }
    });
    
}
///�Ƽ�����Ϣ
function QueryInRec(){
	if(InManu==""){return;}
	$.cm({
        ClassName: "web.DHCST.ManuOrder",
        MethodName: "GetInManOrdMInfo",
        InManu: InManu
    }, function(retData) {
        if (retData != "") {
	        $("#cmbLoc").combobox("setValue", retData.LocDr);
            $("#cmbInRec").combogrid("setValue", retData.InRec);
            $("#cmbUom").combobox("setValue", retData.Uomdr);
            //$("#cmbManuUser").combobox("setValue", retData.ManuUser);
            
            var datas = $("#cmbManuUser").combobox("getData");
            var exitFlag=0
	        for (var i = 0; i < datas.length; i++) {
	            if (datas[i].RowId == retData.ManuUser) {
		            exitFlag=1
	            }
	        }
	        if(exitFlag==0){
	        	$("#cmbManuUser").combobox("setValue", "");
	        }else{
		    	$("#cmbManuUser").combobox("setValue", retData.ManuUser);
		    }
            
            
            $("#txtManuDate").datebox("setValue", retData.ManuDate);
            $("#txtExpDate").datebox("setValue", retData.ExpDate);
            
            $("#txtInManuNo").val(retData.ManuNo);
            $("#txtBatNo").val(retData.BatNo);
            $("#txtTheoryQty").val(retData.TheoryQty);
            $("#txtFactQty").val(retData.FactQty);
            $("#txtAddCost").val(retData.CostPrice);
            $("#txtRemarks").val(retData.Remarks);
            
            $("#chkComp").checkbox("setValue", (retData.Complate=="Y") ? true : false);
            $("#chkAudited").checkbox("setValue", (retData.Audited=="Y") ? true : false);
            
            //$("#chkComp").checkbox((retData.Complate=="Y") ? "check" : "uncheck");
            $("#txtManuStartDate").datebox("setValue", retData.ManuStartDate);
            $("#txtRp").val( retData.Rp);
            $("#txtSp").val( retData.Sp);
            SetChkInfoState(true)
            
        }
    })
	
	
	
	
}

function Clear(){
        $('#cmbInRec').combogrid("setValue", "");
        $("#cmbUom").combobox("setValue", "");
        $("#cmbManuUser").combobox("setValue", "");
        
        
        $("#txtManuDate").datebox("setValue",GetDate(0));  
        $("#txtExpDate").datebox("setValue", "");  //GetDate(1000)
        
        $("#txtInManuNo").val("");
        $("#txtBatNo").val("");
        $("#txtTheoryQty").val("");
        $("#txtFactQty").val("");
        $("#txtAddCost").val("");
        $("#txtRemarks").val("");
        $("#txtRp").val("");
        $("#txtSp").val("");
        
		$("#chkComp").checkbox("setValue", false);
		$("#chkAudited").checkbox("setValue",false);
		$("#txtManuStartDate").datebox("setValue", "");
		InManu=""
		$('#gridInManuOrdBat').datagrid("clear");
		$('#gridInManuOrd').datagrid("clear");
		$('#gridInManu').datagrid("clear");
		SetChkInfoState(false);

}
function GetDate(val){
	return tkMakeServerCall("web.DHCST.ManuOrder","DateChange",val);
}


///
function InItInManu(){
	var columns = [
        [	
        	{ field: "InManuId", title: 'InManuId', width: 200, halign: 'center',hidden:'true' },
        	{ field: "InManuNo", title: '�Ƽ�����', width: 200 },
            { field: "InManuDesc", title: '�Ƽ�����', width: 200},
            { field: "InManuTQty", title: '��������', width: 100} ,
            { field: "InManuFQty", title: 'ʵ������', width: 100  },
            { field: "InManuUomDesc", title: '��λ', width: 100 },
            { field: "InManuDate", title: '�Ƽ�����', width: 80},
            { field: "InManuUser", title: '�Ƽ���', width: 60 },
            { field: "Status", title: '״̬', width: 60}
        ]
    ];
    var dataGridOption = {
        url:'', // inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        toolbar:"#gridQueryBar",
        pageSize: 50,
        pageList: [50, 100, 200],
        onLoadSuccess: function() {
            
        },
        rowStyler: function(index, row) {
            
        },
        onDblClickRow: function(rowIndex, rowData) {
	        $('#FindWindowDiv').dialog('close');
		    InManu=rowData.InManuId
		    Query();
	    },
        onClickCell: function(rowIndex, field, value) {
           
        },
        onCheck: function(rowIndex, rowData) {
            
        },
        onUncheck: function(rowIndex, rowData) {
            
        },
        onSelect: function(rowIndex, rowData) {
	        
            
        },
        onUnselect: function(rowIndex, rowData) {
            
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridInManu", dataGridOption);
	
}

function Search(){
	var StartDate = $('#txtStartDate').datebox('getValue'); // ��ʼ����
	var EndDate = $('#txtEndDate').datebox('getValue'); // ��������
	var LocId = $('#cmbLoc').combobox("getValue"); // �Ƽ�������
	if(LocId==""){
		$.messager.alert('��ʾ', '��ѡ���Ƽ�����', "warning");
        return;
	}
	var Status = $('#cmbStatus').combobox("getValue"); // �Ƽ�״̬
	var params=StartDate+"^"+EndDate+"^"+LocId+"^"+Status
	$('#gridInManu').datagrid({
	    url: inmanuurl + '?action=GetManuOrdList',
        queryParams: {
            Params: params
        }
    });
}
function Select(){
	var gridSelect = $('#gridInManu').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ��һ����¼', "warning");
        return;
    }
    var dataInManu= gridSelect.InManuId;
    $('#FindWindowDiv').dialog('close');
    InManu=dataInManu
    Query();
	
	
}
function Close(){
	$('#FindWindowDiv').dialog('close');
}
function SetChkInfoState(flag){
	
	if(flag==undefined){
		flag=true
	}

	var Uom = $('#cmbUom').combobox("getValue"); // �Ƽ���λ
	if((Uom || "")==""){
	    $("#cmbUom").combobox({
			 required: flag
			 
		})
	}
	var ManuUser= $('#cmbManuUser').datebox('getValue'); // �Ƽ���
	if((ManuUser || "")==""){
	    $("#cmbManuUser").combobox({
			 required: flag
			 
		})
	}
	$("#txtTheoryQty").validatebox({
		 required: flag,
		 validType: 'PosNumber'
	})
	$("#txtFactQty").validatebox({
		required: flag,
		 validType: 'PosNumber'
	})
	$("#txtAddCost").validatebox({
		required: flag,
		 validType: 'PosNumber'
	})
	$("#txtBatNo").validatebox({
		required: flag
	})
	$("#txtRp").validatebox({
		required: flag,
		validType: 'PosNumber'
	})
	$("#txtSp").validatebox({
		required: flag,
		validType: 'PosNumber'
	});
	var InManuDate = $('#txtManuDate').datebox('getValue'); // �Ƽ�����
	if((InManuDate || "")==""){
		$("#txtManuDate").datebox({
			required: flag
			
		});
	}
	var ExpDate = $('#txtExpDate').datebox('getValue'); // �Ƽ�����
	if((ExpDate || "")==""){
		$("#txtExpDate").datebox({
			required: flag
		});
	}

	
	
}