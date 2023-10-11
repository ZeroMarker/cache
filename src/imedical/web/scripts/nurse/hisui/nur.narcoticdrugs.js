/**
 * @author zhangxiangbo
 * @version 20210517
 * @description 病区麻醉及精神药品使用管理登记
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
 * @description 初始化医嘱列表
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
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
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
 * @description 初始化查询条件区
 */
function initCondition() {
    $('#startDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    var userID = session['LOGON.USERID'];
    var hospID = session['LOGON.HOSPID'];
}
/**
 * @description 医嘱列表刷新
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
    			$.messager.popover({ msg: '你选择的药品没有保存数据，不能核对签字!', type: 'alert', timeout: 2000 });
    			return;
    		}
		$('#outLocDialog').dialog({
			onClose: function () {
				$('#outLocDialogForm').form('clear');
			},
			buttons: [{
					text: '保存',
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
								if(jsonData.result=='用户名为空!'){
									jsonData.result="核对人工号不能为空!";
								}
								$.messager.show({
									title: '用户验证消息',
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
										$.messager.popover({ msg: '核对人签字失败!', type: 'alert', timeout: 2000 });
									} else {
										$HUI.dialog('#outLocDialog').close();
										ordGridReload();
									}
								});
							}
						});
					}
				}, {
					text: '关闭',
					handler: function () {
						$HUI.dialog('#outLocDialog').close();
					}
				}
			]
		});
		$('#outLocDialog').dialog('open');
	} else {
		$.messager.popover({ msg: '请选择药品!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description 保存数据
 */
function saveOrdsBtnClick() {
//    $('#regNoInput').focus();
//    var selectArray = $('#ordGrid').datagrid('getSelections');
//    var ordIdArray = selectArray.map(function (row) {
//        return row.OeoriId
//    })
    var AllRows=$('#ordGrid').datagrid("getRows"); // 获取所有的行，并且结束掉编辑
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
			$.messager.popover({ msg: '请填写数据后保存!', type: 'alert', timeout: 2000 });
		}
    }else{
	    $.messager.popover({ msg: '请选择药品!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description 调用后台执行方法
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
            $.messager.popover({ msg: '执行成功!', type: 'success', timeout: 2000 });
            $('#ordGrid').datagrid('clearSelections');
        }
        else {
	        var errMsg="执行失败:<br/>"
	        jsonData.errList.forEach(function(errOrd){
		        if(errOrd.ifCanUpdate!=""){
		        	errMsg+=errOrd.errCode+":"+errOrd.ifCanUpdate+"<br/>";
		        }
		        else{
			        errMsg+=errOrd.errCode+"操作失败!<br/>"
			    }
		    });
            $.messager.popover({ msg: errMsg, type: 'alert', timeout: 2000 });
            ordGridReload();            
    		$('#ordGrid').datagrid('clearSelections');
        }
    })
	

}
/**
*@description 打印按钮
*/
function printBtnClick(){
		var titleInfo=$('title').text().trim().split(" ");
		var dateTime=getServerTime("",dtformat=='DMY'?4:3);	
		var headStr="<thead><th>序号</th><th>药品种类</th><th>日期/时间</th><th>住院号</th><th>患者姓名</th><th>药物名称</th><th>剂量</th><th>用法</th><th>处方号</th><th>数量</th><th>执行/核对人签字</th><th>空安瓿/废贴回收数量</th><th>批号</th><th>余量及处置方式</th><th>医嘱执行/核对人签字</th></thead>";
		var footStr="<tfoot style='border: none;'><td></td><td></td><td colspan='12'>打印时间:"+dateTime.date+" "+dateTime.time+"</td></tfoot>";
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
			//LODOP.PRINT_INITA("0.53mm", "0mm", "158.75mm", "211.67mm", "病区麻醉及精神药品使用管理登记");
			LODOP.PRINT_INIT("病区麻醉及精神药品使用管理登记");
			//LODOP.PRINT_INITA("0.53mm", "0mm", "211.67mm", "158.75mm", "病区麻醉及精神药品使用管理登记");
			LODOP.SET_PRINT_PAGESIZE(2,"297mm","210mm","A4")
			LODOP.ADD_PRINT_TEXT(40,0,"100%",42,"病区麻醉及精神药品使用管理登记");
			LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
			LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
			//LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
			LODOP.SET_PRINT_STYLEA(0,"Bold",1);
			LODOP.ADD_PRINT_TEXT(55,77,153,22,"病区:"+session['LOGON.CTLOCDESC']);
			LODOP.ADD_PRINT_TEXT(55,270,123,22,"打印人:"+session['LOGON.USERNAME']);
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
			$.messager.popover({msg: '请选择要打印的数据！',type:'alert'});
		}
}

