/**
 * @author zhangxiangbo
 * @version 20210517
 * @description ������������ҩƷʹ�ù���Ǽ�
 * @name nur.narcoticdrugs.js
 */
var GV = {
    _CALSSNAME: "Nur.HISUI.NarcoticDrugs",
    episodeID: "",
};
var init = function () {
    initPageDom();
    initBindEvent();
}
$(init)
function initPageDom() {	
    initCondition();
    initOrdGrid();
    
}
function initBindEvent() {
    $('#regNoInput').bind('keydown', function (e) {
        var regNO = $('#regNoInput').val();
        if (e.keyCode == 13 && regNO != "") {
            var regNoComplete = completeRegNo(regNO);
            $('#regNoInput').val(regNoComplete);
            ordGridReload();
        }
    });
    $('#queryOrderBtn').bind('click', ordGridReload);
    $('#execOrdsBtn').bind('click', saveOrdsBtnClick);
    $('#CheckUserBtn').bind('click', CheckUserBtnClick);
	$('#PrintBtn').bind('click', printBtnClick);
}
/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ��ҽ���б�
 */
function initOrdGrid() {
	var defaultPageSize = 25;
    var defaultPageList = [25, 50, 100, 200, 500];
    var regNo = $('#regNoInput').val();
    var ordName = $('#ordNameInput').val();
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    var ifDischarge = $('#ifDischarge').checkbox('getValue');
    $('#ordGrid').datagrid({
        url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: 20,
		nowrap:false,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "FindNarcoticDrugs",
            RegNo: regNo,
			Ward:session['LOGON.WARDID'],
            StartDate: startDate,
            EndDate: endDate,
            OrdName:ordName,
			LocId:session['LOGON.CTLOCID'],
			IfOutPat:ifDischarge,
        },
		onCellEdit: function(index, field, value){
			var input = $(this).datagrid('input', {index:index, field:field});
			if (input){
				if (value != undefined){
					input.val(value);
				}
				setTimeout(function(){
					$("#ordGrid").datagrid("checkRow",index);
				})
			}
		}
    })
	$('#ordGrid').datagrid('enableCellEditing');
}
/**
 * @description ��ʼ����ѯ������
 */
function initCondition() {
    $('#startDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var userID = session['LOGON.USERID'];
    var hospID = session['LOGON.HOSPID'];
}
/**
 * @description ҽ���б�ˢ��
 */
function ordGridReload() {
    var regNo = $('#regNoInput').val();
    var ordName = $('#ordNameInput').val();
    var startDate = $('#startDate').datebox('getValue');
    var endDate = $('#endDate').datebox('getValue');
    var ifDischarge = $('#ifDischarge').checkbox('getValue');
    $('#ordGrid').datagrid("unselectAll").datagrid('load',
        {
            ClassName: GV._CALSSNAME,
            QueryName: "FindNarcoticDrugs",
            RegNo: regNo,
            Ward: session['LOGON.WARDID'],
            StartDate: startDate,
            EndDate: endDate,
            OrdName:ordName,
			LocId:session['LOGON.CTLOCID'],
			IfOutPat:ifDischarge,
        })
}
function CheckUserBtnClick()
{
    var CheckedRows=$('#ordGrid').datagrid('getChecked'); 
	if (CheckedRows.length> 0) {
		var rwStr="";
		for(var i=0;i<CheckedRows.length;i++)
    		{
    			var Data=CheckedRows[i];
    			if((Data.rw=="")) continue;
    			if(rwStr=="")
    			{
    				rwStr=Data.rw
    			}else
    			{
    				rwStr=rwStr+"^"+Data.rw
    			}
    		}
    		if(rwStr=="")
    		{
    			$.messager.popover({ msg: '��ѡ���ҩƷû�б������ݣ����ܺ˶�ǩ��!', type: 'alert', timeout: 2000 });
    			return;
    		}
		$('#outLocDialog').dialog({
			onClose: function () {
				$('#outLocDialogForm').form('clear');
			},
			buttons: [{
					text: '����',
					handler: function () {
						var transUserCode = $('#transUserCode').val();
						var transUserPass = $('#transUserPass').val();
						$cm({
							ClassName: "Nur.NIS.Service.Base.User",
							MethodName: "SignPasswordConfirm",
							userCode: transUserCode,
							passWord: transUserPass,
							ctLoc: ""
						}, function (jsonData) {
							if (String(jsonData.result) !== '0') {
								if(jsonData.result=='�û���Ϊ��!'){
									jsonData.result="�˶��˹��Ų���Ϊ��!";
								}
								$.messager.show({
									title: '�û���֤��Ϣ',
									msg: jsonData.result,
									timeout: 5000,
									showType: 'slide'
								});
							} else {
								var transUserID = jsonData.userID;
								$cm({
									ClassName: GV._CALSSNAME,
									MethodName: "saveCheckUser",
									rwStr: rwStr,
									UserId: transUserID
								}, function (jsonData) {
									if (String(jsonData.success) !== "0") {
										$.messager.popover({ msg: '�˶���ǩ��ʧ��!', type: 'alert', timeout: 2000 });
									} else {
										$HUI.dialog('#outLocDialog').close();
										ordGridReload();
									}
								});
							}
						});
					}
				}, {
					text: '�ر�',
					handler: function () {
						$HUI.dialog('#outLocDialog').close();
					}
				}
			]
		});
		$('#outLocDialog').dialog('open');
	} else {
		$.messager.popover({ msg: '��ѡ��ҩƷ!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description ��������
 */
function saveOrdsBtnClick() {
//    $('#regNoInput').focus();
//    var selectArray = $('#ordGrid').datagrid('getSelections');
//    var ordIdArray = selectArray.map(function (row) {
//        return row.OeoriId
//    })
    var AllRows=$('#ordGrid').datagrid("getRows"); // ��ȡ���е��У����ҽ������༭
    for(var i =0; i < AllRows.length; i++){
		$('#ordGrid').datagrid('endEdit', i);
    }
    var CheckedRows=$('#ordGrid').datagrid('getChecked'); 
    if(CheckedRows.length>0){
    	var ret="",oeoreID="",Usage="",Batch="",DealMehtod="",Data="",rw="";	
    	for(var i=0;i<CheckedRows.length;i++)
    	{
    	     Data=CheckedRows[i];
			 rw=Data.rw
    	     oeoreID=Data.oeoreID;
    	     Usage=Data.Usage;
    	     Batch=Data.Batch;
    	     DealMehtod=Data.DealMehtod;
			 if((Usage=="")&&(Batch=="")&&(DealMehtod=="")&&(rw=="")) continue;
    	     if(ret=="")
    	     {
    	     	ret=oeoreID+"^"+Usage+"^"+Batch+"^"+DealMehtod;
    	     }else
    	     {
    	     	ret=ret+"@"+oeoreID+"^"+Usage+"^"+Batch+"^"+DealMehtod;
    	     }
    	} 
    	if(ret!="") {
	    	SaveNarcoticDrugs(ret);
	    }else{
			$.messager.popover({ msg: '����д���ݺ󱣴�!', type: 'alert', timeout: 2000 });
		}
    }else{
	    $.messager.popover({ msg: '��ѡ��ҩƷ!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description ���ú�ִ̨�з���
 * @param {*} orderStatus 
 */
function SaveNarcoticDrugs(ret) {
    var userID = session['LOGON.USERID'];
    $cm({
        ClassName: GV._CALSSNAME,
        MethodName: "saveNarcoticDrugs",
        parr: ret,
        UserId: userID
    }, function (jsonData) {
        if (jsonData.success == '0') {
	        ordGridReload();       		
            $.messager.popover({ msg: 'ִ�гɹ�!', type: 'success', timeout: 2000 });
            $('#ordGrid').datagrid('clearSelections');
        }
        else {
	        var errMsg="ִ��ʧ��:<br/>"
	        jsonData.errList.forEach(function(errOrd){
		        if(errOrd.ifCanUpdate!=""){
		        	errMsg+=errOrd.errCode+":"+errOrd.ifCanUpdate+"<br/>";
		        }
		        else{
			        errMsg+=errOrd.errCode+"����ʧ��!<br/>"
			    }
		    });
            $.messager.popover({ msg: errMsg, type: 'alert', timeout: 2000 });
            ordGridReload();            
    		$('#ordGrid').datagrid('clearSelections');
        }
    })
	

}
/**
*@description ��ӡ��ť
*/
function printBtnClick(){
		var titleInfo=$('title').text().trim().split(" ");
		var dateTime=getServerTime("",dtformat=='DMY'?4:3);	
		var headStr="<thead><th>���</th><th>ҩƷ����</th><th>����/ʱ��</th><th>סԺ��</th><th>��������</th><th>ҩ������</th><th>����</th><th>�÷�</th><th>������</th><th>����</th><th>ִ��/�˶���ǩ��</th><th>�հ��/������������</th><th>����</th><th>���������÷�ʽ</th><th>ҽ��ִ��/�˶���ǩ��</th></thead>";
		var footStr="<tfoot style='border: none;'><td></td><td></td><td colspan='12'>��ӡʱ��:"+dateTime.date+" "+dateTime.time+"</td></tfoot>";
		//var rows=$('#ordGrid').datagrid('getSelections');
		var rows=$('#ordGrid').datagrid('getChecked'); 
		var SortNo=0;
		if(rows.length>0){
			var rowStr="<tbody>";
			rows.forEach(function(row){
				SortNo=SortNo+1;
				rowStr=rowStr+'<tr>'+'<td>'+SortNo+'</td>'+'<td>'+row.DrugType+'</td>'+'<td>'+row.SttDateTime+'</td>'+'<td>'+row.MedCareNo+'</td>'+'<td>'+row.patName+'</td>'+'<td>'+row.ArcimDesc+'</td>'+'<td>'+row.doseQtyUnit+'</td>'+'<td>'+row.PhcinDesc+'</td>'+'<td>'+row.prescNo+'</td>'+'<td>'+row.Qty+'</td>'+'<td>'+row.execUser+'</td>'+'<td>'+row.Usage+'</td>'+'<td>'+row.Batch+'</td>'+'<td>'+row.DealMehtod+'</td>'+'<td>'+row.EmrUser+'/'+row.CheUser+'</td>'+'</tr>';
			});
			rowStr=rowStr+"</tbody>";
			var strHTML = '<table style="border: 1px solid black; border-image: none; border-collapse: collapse;" border="1">'+headStr+rowStr+footStr+"</table>";
			var LODOP=getLodop();
			//LODOP.PRINT_INITA("0.53mm", "0mm", "158.75mm", "211.67mm", "������������ҩƷʹ�ù���Ǽ�");
			LODOP.PRINT_INIT("������������ҩƷʹ�ù���Ǽ�");
			//LODOP.PRINT_INITA("0.53mm", "0mm", "211.67mm", "158.75mm", "������������ҩƷʹ�ù���Ǽ�");
			LODOP.SET_PRINT_PAGESIZE(2,"297mm","210mm","A4")
			LODOP.ADD_PRINT_TEXT(40,0,"100%",42,"������������ҩƷʹ�ù���Ǽ�");
			LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
			LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
			//LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
			LODOP.SET_PRINT_STYLEA(0,"Bold",1);
			LODOP.ADD_PRINT_TEXT(55,77,153,22,"����:"+session['LOGON.CTLOCDESC']);
			LODOP.ADD_PRINT_TEXT(55,270,123,22,"��ӡ��:"+session['LOGON.USERNAME']);
			//LODOP.ADD_PRINT_TEXT(55,300,173,22,);
			LODOP.ADD_PRINT_TABLE("20mm","5mm","280mm","190mm",strHTML);
			LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
			//LODOP.SET_PRINT_STYLEA(2,"AngleOfPageInside",90);
			//LODOP.SET_PRINT_MODE("RESELECT_ORIENT",false)
			//LODOP.PRINT_DESIGN();
			//LODOP.PREVIEW();
			LODOP.PRINT();
		}
		else{
			$.messager.popover({msg: '��ѡ��Ҫ��ӡ�����ݣ�',type:'alert'});
		}
}

