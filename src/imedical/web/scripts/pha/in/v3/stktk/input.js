/*
*Creator		zhaozhiduan
*CreatDate		20222-04-21
*Description 	���ʵ��¼��--ѡ��¼�뷽ʽ
*
*/
var APP_NAME = "DHCSTINSTKTK"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK"
$(function(){
	PHA_COM.SetPanel('#panel');
	InitDict();             // ��ʼ�������ֵ�
    InitBtn();              // ��ʼ����ť
    InitGridStktkMain();
    InitDefVal();
	SetRequired();
	setTimeout(function () {
		QueryMain();
   }, 1000);
 })
 function SetRequired(){
	PHA.SetRequired($('#gridStktkMainBar' + ' [data-pha]'))
}
function InitDict(){
	//ҩ������
    PHA_UX.ComboBox.Loc('stktkLocId');
}
function InitDefVal(){
    var locId =  $("#stktkLocId").combobox("getValue") || PHA_COM.Session.CTLOCID;
    $('#stktkLocId').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
}

function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', 	function () {QueryMain();});
    PHA_EVENT.Bind('#btnSelStktk', 	'click', 	function () {SelStktk();});
    PHA_EVENT.Bind('#btnClean', 	'click', 	function () {Clean();});
    // diag ��ť�¼�
    PHA_EVENT.Bind('#btnSure', 		'click', 	function () {SureInputModel();});
    PHA_EVENT.Bind('#btnClose', 	'click', 	function () {CloseDiag();});

}
function InitGridStktkMain(){
    var columns = [
        [
            { field: 'stktkId',		title: '����id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'stktkNo',		title: '����',		align: 'left',	width: 160 },
            { field: 'stktkLocId',  title: '����id',	align: 'left',	width: 100,	hidden: true  },
            { field: 'stktkLocDesc',title: '����',		align: 'left',	width: 100 },
            { field: 'stktkDate',   title: '�Ƶ�����',  align: 'left',	width: 100 },
            { field: 'stktkTime',   title: '�Ƶ�ʱ��',  align: 'left',	width: 100 },
            //{ field: 'stkGrpId',  	title: '����',		align: 'left',	width: 100,	hidden: true   },
            //{ field: 'stkGrpDesc',  title: '����',		align: 'left',	width: 100 },
            { field: 'compFlag',    title: '��ɱ�־',  align: 'left',	width: 60 },
            { field: 'stkCatDesc',  title: '������',	align: 'left',	width: 100 },
            { field: 'noUseDesc',  	title: 'Ʒ��',		align: 'left',	width: 100 },
            { field: 'manGrpDesc',  title: '�̵���',	align: 'left',	width: 100 },
            { field: 'selManGrpDesc',title: '��/���̵���',	align: 'left',	width: 100 },
            { field: 'manDrgDesc',	title: '����ҩ',	align: 'left',	width: 100 },
            { field: 'stkBinDesc',  title: '��λ',  	align: 'left',	width: 100 },
            { field: 'inputType',	title: '�̵㷽ʽ',  align: 'left',	width: 100 ,
            	formatter: function (value, rowData, index) {
					if(value==1){
						return $g("������");
					}else if(value==2){
						return $g("��Ʒ��");
					}else if(value==5){
						return "<font color=blue>"+$g("�ƶ���")+":</font>"+$g("��Ʒ��");
					}else if(value==6){
						return "<font color=blue>"+$g("�ƶ���")+":</font>"+$g("������");
					}else{
						return "";
					}		
				}
            },
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 }
        ]
    ];
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridStktkMainBar',
        exportXls: false,
        columns: columns,
        url:PHA.$URL,
        queryParams:{
            pClassName:'PHA.IN.STKTK.Api' ,
            pMethodName:'GetStktkMainList',
            pPlug:'datagrid'
        },
        onSelect: function(rowIndex, rowData) {
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelStktk()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridStktkMain').datagrid("selectRow",0);
            }
        }
        
    };
    PHA.Grid('gridStktkMain', dataGridOption);
}
function QueryMain(){
	var retJson = PHA.GetVals(["stDate","endDate","stktkLocId"],"Json");
	if(retJson[0] == undefined) {return;}
	var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#stktkLocId").combobox("getValue") || "";  
    var stktkStatus = "COMP"
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stktkStatus = stktkStatus;
	pJson.execFlag = "Y"
    $("#gridStktkMain").datagrid('query',{
        pJson: JSON.stringify(pJson)
    }); 
}
function SelStktk(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
	$('#diagSelModel').dialog('open');
	//ҩ������
	var locId = $("#stktkLocId").combobox("getValue") || PHA_COM.Session.CTLOCID ;
    PHA.ComboBox('inputWin',{
		url: PHA_IN_STORE.StkTkWindow(locId).url
	});
	var inputType = Selected.inputType;
	$HUI.radio('input[name="inputModel"]').disable();
	if(inputType==1){
		$HUI.radio('input[name="inputModel"][value=' + 1 + ']').setValue(true);
	}else if(inputType == 2){ // pc Ʒ��
		$HUI.radio('input[name="inputModel"][value=' + 3 + ']').setValue(true);
	}else if(inputType == 5){ // �ƶ� Ʒ��
		$HUI.radio('input[name="inputModel"][value=' + 5 + ']').setValue(true);
	}else if(inputType == 6){
		$HUI.radio('input[name="inputModel"][value=' + 6 + ']').setValue(true);
	}else{
		$HUI.radio('input[name="inputModel"]').enable();
	}
}
function Clean(){
	 PHA.DomData("#qCondition", {
        doType:'clear'
    })
    $('#gridStktkMain').datagrid('clear');
    InitDefVal();
}
function SureInputModel(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ���̵㵥�ݣ�"))
		return
	}
	var locId = Selected.stktkLocId;
	var stktkId = Selected.stktkId;
	var inputModel =  $('input[name="inputModel"]:checked').val() || '';
	var stktkWin = $("#inputWin").datebox("getValue") || ""; 
	// ��ת����Ӧ��¼�����
	var UrlStr = "";
	if(inputModel == 1){
		var text = "¼�뷽ʽһ"
		var UrlStr = 'pha.in.v3.stktk.inputitmwd.csp?stktkId='+stktkId+'&stktkLocId='+locId+'&stktkWinId='+stktkWin;
	}else if(inputModel == 2){
		var text = "¼�뷽ʽ��"
		var UrlStr = 'pha.in.v3.stktk.inputitmwd.csp?stktkId='+stktkId+'&stktkLocId='+locId+'&stktkWinId='+stktkWin;
	}else if(inputModel == 3){
		var text = "¼�뷽ʽ��"
		var UrlStr = 'pha.in.v3.stktk.inputitmwd3.csp?stktkId='+stktkId+'&stktkLocId='+locId+'&stktkWinId='+stktkWin;
	}
	else if(inputModel == 4){
		var text = "¼�뷽ʽ��"
		var UrlStr = 'pha.in.v3.stktk.inputitmwd4.csp?stktkId='+stktkId+'&stktkLocId='+locId+'&stktkWinId='+stktkWin;
	}
	else if((inputModel == 5)||(inputModel == 6)){
		var pJson = {};
		pJson.stktkId = stktkId;
		pJson.inputType = inputModel;
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.STKTK.Api',
			pMethodName: 'UpdInputType',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide")
			if(PHA.Ret(data)){
				QueryMain();
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		})
		$('#diagSelModel').dialog('close');
		return
	}
	
	if ('undefined'!==typeof websys_getMWToken){
		UrlStr += "&MWToken="+websys_getMWToken();
	}
	window.location.href=UrlStr;

	//window.open(UrlStr, text, 'height=' + h + ', width=' + w + ', top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');	
}
function CloseDiag(){
    $('#diagSelModel').dialog('close');
}