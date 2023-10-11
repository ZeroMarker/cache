var GV = {
    PfBarInfo: "",
}
$(function(){
	initBookPat();
	initBookAssess("Y");
	initEvent();
	var AppBedCode=websys_showModal('options').GetSelBookAppBedCode();
	if (AppBedCode !=""){
		$("#BookAssessNoPass").hide();
	}
	$("#UpdateBookAssessNote").linkbutton("disable");
})
function initEvent(){
	$("#BookAssessPass").click(BookAssessPassClick);
	$("#BookAssessNoPass").click(BookAssessNoPassClick);
	$("#AddBookAssessNote").click(AddBookAssessNoteClick);
	$("#UpdateBookAssessNote").click(UpdateBookAssessNoteClick);
}
function initBookPat(){
	$cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetPatBookingList",
        RegNo: "",
        BookNo: BookNo
    }, function(data) {
        if (data.total == 0) {
            $.messager.popover({ msg: 'δ�ܲ�ѯ����Ч��סԺ֤��Ϣ', type: 'success', timeout: 1000 });
        } else {
            GV.PfBarInfo = data.bookList[0];
            setPfBar();
            setBookInfo();
        }
    });
}
function initBookAssess(refreshAssessChkItem){
	$cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "GetIPBookAssessData",
        BookNo: BookNo
    }, function(data) {
	    if (refreshAssessChkItem =="Y"){
		    var ItemData=data.ItemData;
		    if (ItemData){
		    	var AssessCheckedItems=ItemData.AssessCheckedItems;
		    	if (AssessCheckedItems){
			    	for (var i=0;i<AssessCheckedItems.split("^").length;i++){
				    	$("#"+AssessCheckedItems.split("^")[i]).checkbox("check");
				    }
			    }
			    var chk=$("input[type='checkbox']");
			    var checkedchk=$("input[type='checkbox']:checked");
				if (checkedchk.length == (chk.length-1)){
					$("#ckAll").checkbox("check");
				}
		    }
		}
		initBookNotesListGrid(data.GridData);
    });
}
function ckAllChange(e,value){
	var chk=$("input[type='checkbox']");
	for (var i=0;i<chk.length;i++){
		if (value){
			$($("input[type='checkbox']")[i]).checkbox("check");
		}else{
			$($("input[type='checkbox']")[i]).checkbox("uncheck");
		}
	}
}
function otherCKChange(e,value){
	$('#ckAll').checkbox({onCheckChange:function(){}});
	if (value){
		var chk=$("input[type='checkbox']");
	    var checkedchk=$("input[type='checkbox']:checked");
		if (checkedchk.length == (chk.length-1)){
			$("#ckAll").checkbox("check");
		}
	}else{
		$("#ckAll").checkbox("uncheck")
	}
	$('#ckAll').checkbox({onCheckChange:ckAllChange});
}
function initBookNotesListGrid(data){
	var Columns=[[ 
		{ field: 'date', title: '��ע����',width:160},
		{ field: 'Operator', title: '��¼��',width:130},
		{ field: 'Notes', title: '��¼����',width:800}
    ]];
	$('#BookNotesList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('������..'),  
		pagination : false, 
		rownumbers : false,
		idField:"id",
		columns :Columns,
		titleNoWrap:false,
		nowrap:false,  /*�˴�Ϊfalse*/
		data:data,
		onSelect:function(rowIndex, rowData){
			$("#Note").val(rowData.Notes);
			$("#UpdateBookAssessNote").linkbutton("enable");
		},
		onLoadSuccess:function(data){
			$('#BookNotesList').datagrid("unselectAll");
			$("#UpdateBookAssessNote").linkbutton("disable");
		}
	})
}
function BookAssessPassClick(){
	SaveBookAssess("P","");
}
function BookAssessNoPassClick(){
	var note=$.trim($("#Note").val());
	if (note ==""){
		$.messager.popover({ msg: '������ͨ��ʱ��ע���ݲ���Ϊ�գ�', type: 'error', timeout: 1000 });
		$("#Note").focus();
		return false;
	}
	SaveBookAssess("NotP","");
}
function AddBookAssessNoteClick(){
	var note=$.trim($("#Note").val());
	if (note ==""){
		$.messager.popover({ msg: '��ע���ݲ���Ϊ�գ�', type: 'error', timeout: 1000 });
		$("#Note").focus();
		return false;
	}
	SaveBookAssess("","");
}
function UpdateBookAssessNoteClick(){
	if ($("#UpdateBookAssessNote").hasClass("l-btn-disabled")) return false;
	var sel=$('#BookNotesList').datagrid("getSelected");
	if (!sel){
		$.messager.popover({ msg: '��ѡ����Ҫ�޸ı�ע�ļ�¼��', type: 'error', timeout: 1000 });
		return false;
	}
	var note=$.trim($("#Note").val());
	if (note ==""){
		$.messager.popover({ msg: '�޸ĺ�ע���ݲ���Ϊ�գ�', type: 'error', timeout: 1000 });
		$("#Note").focus();
		return false;
	}
	var noteId=sel.id;
	SaveBookAssess("",noteId);
}
function SaveBookAssess(AssessResult,noteId){
	var note=$.trim($("#Note").val());
	var AssessCheckedItemsArr=[];
	if (AssessResult =="P"){
		var chk=$("input[type='checkbox']:checked");
		for (var i=0;i<chk.length;i++){
			var chkId=$("input[type='checkbox']:checked")[i].id;
			if (chkId =="ckAll") continue;
			AssessCheckedItemsArr.push(chkId);
		}
		if (AssessCheckedItemsArr.length ==0){
			$.messager.popover({ msg: '�����ٹ�ѡһ��ͨ������������', type: 'error', timeout: 1000 });
			return false;
		}
	}
	$cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "SaveBookAssess",
        BookNO: BookNo,
        AssessResult:AssessResult,
        AssessCheckedItems:AssessCheckedItemsArr.join("^"), 
        Notes:note, 
        noteId:noteId,
        UserID:session['LOGON.USERID'], 
        UserDep:session['LOGON.CTLOCID'], 
        UserIP:session['REMOTE_ADDR'],
        dataType:"text"
    }, function(rtn) {
        if (rtn < 0){
	        $.messager.popover({ msg: '����������¼ʧ�ܣ�', type: 'error', timeout: 1000 });
			return false;
	    }else{
		    if (AssessResult ==""){
			    $("#Note").val("");
			    $('#BookNotesList').datagrid("unselectAll");
			    initBookAssess("N");
			}else{
				//����ԤԼ�� ԤԼ�˵绰 ��ע
				saveAppInfo();
				websys_showModal('options').CallBackFunc(AssessResult);
			}
		}
    });
}
function saveAppInfo(){
    var AppointName = $('#AppointNameBookI').val();
    var AppointPhone = $('#AppointPhoneBookI').val();
    var Remark = $('#RemarkBookI').val();
    if (AppointName.toString().length>50) return $.messager.popover({msg:'ԤԼ���������Ȳ�����50�֣�',type:'alert'});
    if((''!==AppointPhone)&&(!(/^1\d{10}$/.test(AppointPhone)))) return $.messager.popover({msg:'����д��ȷ��ԤԼ�˵绰��',type:'alert'});
    if (Remark.toString().length>50) return $.messager.popover({msg:'��ע���Ȳ�����50�֣�',type:'alert'});
    var userID = session['LOGON.USERID'];
    $cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "editIPAppointmentInfo",
        BookNO: BookNo,
        AppointName: AppointName,
        AppointPhone: AppointPhone,
        Remark: Remark,
        UserID: userID
    }, function (jsonData) {
        if (jsonData == 0) {
        } else {
            var title='��Ϣ�޸�ʧ��';
            if (jsonData == 100) {
                title='��Ϣ�޸���ʾ';
                jsonData="δ����Ϣ���Ķ���";
            }
            $.messager.show({
                title: title,
                msg: jsonData,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}